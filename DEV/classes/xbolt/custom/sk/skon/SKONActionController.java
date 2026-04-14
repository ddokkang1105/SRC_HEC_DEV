package xbolt.custom.sk.skon;

import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Function;
import java.util.function.Predicate;

import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.DRMUtil;

import java.util.LinkedList;
import java.util.Collections;
import org.apache.commons.text.StringEscapeUtils;
import org.json.simple.parser.JSONParser;

import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.compareText;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RequestMethod;

import org.springframework.web.client.RestTemplate;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import com.google.gson.Gson;
import com.org.json.JSONArray;
import org.json.simple.JSONObject;

import sun.misc.BASE64Decoder;
import xbolt.app.esp.main.util.ESPUtil;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.DateUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.GetItemAttrList;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.custom.daelim.val.DaelimGlobalVal;
import xbolt.file.util.FileUploadUtil;
import xbolt.rpt.web.ReportActionController;
import xbolt.wf.web.WfActionController;
import xbolt.cmm.framework.util.JsonUtil;
import xbolt.project.chgInf.web.CSActionController;

/**
 * @Class Name : SKONActionController.java
 * @Description : SKONActionController.java
 * @Modification Information
 * @수정일 수정자 수정내용 @--------- --------- ------------------------------- @2024. 09.
 *      27. smartfactory 최초생성
 *
 * @since 2024. 09. 27
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class SKONActionController extends XboltController {
	private final Log _log = LogFactory.getLog(this.getClass());

	@Resource(name = "commonService")
	private CommonService commonService;

	@Resource(name = "fileMgtService")
	private CommonService fileMgtService;

	@Resource(name = "CSService")
	private CommonService CSService;

	@Resource(name = "CSActionController")
	private CSActionController CSActionController;
	
	@Autowired
    private FileUploadUtil fileUploadUtil;

	@RequestMapping(value = "/custom/sk/skon/skSSO.do")
	public String indexSK(Map cmmMap, ModelMap model, HttpServletRequest request, HttpServletResponse response,
			HttpSession session) throws Exception {
		try {
			String ssoID = StringUtil.checkNull(cmmMap.get("LOGIN_ID"), "");
			String skSSO = StringUtil.checkNull(cmmMap.get("skSSO"), "");

			model.put("olmI", ssoID);
			model.put("olmP", "");
			model.put("skSSO", skSSO);

			model.put("olmLng", StringUtil.checkNull(cmmMap.get("olmLng"), ""));
			model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType"), ""));
			model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType"), ""));
			model.put("srID", StringUtil.checkNull(cmmMap.get("srID"), ""));
			model.put("proposal", StringUtil.checkNull(cmmMap.get("proposal"), ""));
			model.put("status", StringUtil.checkNull(cmmMap.get("status"), ""));

		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("SKONActionController::mainpage::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/custom/sk/cmm/skSSO");
	}

	@RequestMapping(value = "/zSK_submitWfInst.do")
	public String zSK_submitWfInst(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap setData = new HashMap();
			HashMap setMap = new HashMap();
			HashMap insertWFInstData = new HashMap();

			String wfInstanceID = StringUtil.checkNull(commandMap.get("wfInstanceID"));
			String projectID = StringUtil.checkNull(commandMap.get("projectID"));
			String docSubClass = StringUtil.checkNull(commandMap.get("docSubClass"));
			String docCategory = StringUtil.checkNull(commandMap.get("docCategory"));
			String wfID = StringUtil.checkNull(commandMap.get("wfID"), "");

			setData.put("wfID", wfID);
			String newWFInstanceID = "";

			// SET NEW WFInstance ID
			String maxWFInstanceID = commonService.selectString("wf_SQL.MaxWFInstanceID", setData);
			String OLM_SERVER_NAME = GlobalVal.OLM_SERVER_NAME;
			int OLM_SERVER_NAME_LENGTH = GlobalVal.OLM_SERVER_NAME.length();
			String initLen = "%0" + (13 - OLM_SERVER_NAME_LENGTH) + "d";

			int maxWFInstanceID2 = Integer.parseInt(maxWFInstanceID.substring(OLM_SERVER_NAME_LENGTH));
			int maxcode = maxWFInstanceID2 + 1;
			newWFInstanceID = OLM_SERVER_NAME + String.format(initLen, maxcode);

			if (wfInstanceID != null && !"".equals(wfInstanceID))
				newWFInstanceID = wfInstanceID;

			setData.put("wfID", wfID);
			setData.put("wfDocType", docCategory);
			setData.put("docSubClass", docSubClass);

			String wfAllocID = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFAllocID", setData));

			commandMap.put("wfID", wfID);
			commandMap.put("newWFInstanceID", newWFInstanceID);
			commandMap.put("wfAllocID", wfAllocID);

			// 결재 정보 생성
			insertWFInstData = insertWFStepInst(request, commandMap, model);

			setMap.put("s_itemID", projectID);
			commandMap.put("insertWFInstData", insertWFInstData);
			commandMap.put("lastSeq", insertWFInstData.get("lastSeq"));

			// [전자결재 기안]
			Map rs = zSK_createWfDoc_GW(insertWFInstData);

			// TODO
			// Result 가 SUCCESS 이고 Detail값이 있을 경우 WF Status 0 으로 업데이트
			// 그전엔 Status -1 (임시저장)
			String result = StringUtil.checkNull(rs.get("Result"));
			String message = StringUtil.checkNull(rs.get("Message")); // doc id
			// view url ( message / url / formID / companyID 필요 )
			// http://apv3.dskcorp.net/ApprovalV3/Services/OpenApprovalDoc.aspx?OpenURL=http://apv3.dskcorp.net/ApprovalV3/Workdoc/OpenDocument.aspx?wdid=05442DAC525B4D17AA78B813273AE568&foid=AI20729&mode=r&schema=H67&_guid=05442DAC525B4D17AA78B813273AE568

			if (("SUCCESS").equals(result) && !"".equals(message)) {
				setData.put("Status", "1");
				setData.put("ReturnedValue", message);
				setData.put("WFInstanceID", newWFInstanceID);
				setData.put("LastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));
				commonService.update("wf_SQL.updateWfInst", setData);
				commonService.update("wf_SQL.updateWFStepInst", setData);
			}

			commandMap.put("emailType", "SRAPREQ");
			// 결재 상신 Email 전송
			// sendWfMail(request,commandMap,model);

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00150")); // 상신
																													// 완료
			target.put(AJAX_SCRIPT, "parent.fnCallBackSubmit();parent.$('#isSubmit').remove();");

		} catch (Exception e) {

			System.out.println(e.toString());
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류
																													// 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/custom/zSK_submitWfInstTest.do")
	public static Map<String, Object> zSK_createWfDoc_GW(Map insertWFInstData) throws Exception {

		Map<String, Object> result = new HashMap();

		/*
		 * 
		 * 개발서버 테스트 계정 si77771 ~ si77774
		 * 
		 */

		System.out.println("전자결재 테스트 START");

		String formID = "AI20729";
		String token = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJBUElTZXJ2aWNlIiwiYXB2Snd0Ijp7ImFwcGxpY2F0aW9uSW5mb0lEIjoyMDcyOSwiZm9ybUlEIjoiQUkyMDcyOSIsImxlZ2FjeUlEIjoiR1NETURFViIsImhvc3RJUHMiOiIxMC44Mi40LjgzLCAxMC45MC43MC42MCIsImxlZ2FjeUlGVVJMIjoiaHR0cHM6Ly8xMC44Mi40LjgzL2N1c3RvbS9zay9hcHJ2UHJvY2Vzc2luZy5kbyAiLCJCVFNJRlVSTCI6IiJ9fQ.sP9WyE9cDQ9Mi8oSj9CAJrEdr5eLt3fOKhz3F0G0rmU";
		String url = "http://api.skinnovation.com/apv/api/v1/gate/requestMakeDoc";

		String docTitle = "GSDM 전자결재 테스트"; // subject
		String authorID = "si77771"; // 기안자
		String companyID = "H67"; // 회사코드
		String legacyItemID = "test001"; // wfInstanceID
		String keepYear = "Default";
		String securityLevel = "Default";
		String langCode = "ko";
		String contentType = "HTML";

		// 결재선 정보 가공 [{"TaskName" : "emp0" , "UserID" : "si77771"}]
		List approvers = new ArrayList();

		Map approversMap = new HashMap();
		approversMap.put("TaskName", "emp0");
		approversMap.put("UserID", authorID);
		approvers.add(approversMap);
		approversMap = new HashMap();
		approversMap.put("TaskName", "app0");
		approversMap.put("UserID", "si77774");
		approvers.add(approversMap);

		// 결재 연동 정보 생성
		HashMap apprMap = new HashMap();
		HashMap apprLogMap = new HashMap();

		apprMap.put("KeepYear", keepYear);
		apprMap.put("FormID", formID);
		apprMap.put("LegacyItemID", legacyItemID);

		apprMap.put("SecurityLevel", securityLevel);
		apprMap.put("ApproverList", approvers);
		apprMap.put("LangCode", langCode);
		apprMap.put("ContentType", contentType);

		apprMap.put("DocTitle", docTitle);

		apprMap.put("AuthorID", authorID);
		apprMap.put("CompanyID", companyID);

		apprLogMap.putAll(apprMap);

		try {

			// 1. 요청 보낼 정보 가공.

			// 2.파일 저장 ( CS DOC 만 보낼것인지 ? 아니면 전체를 보낼건지 .. )
			// base64 인코딩 / 30개제한 / 30mb 제한
			// AttachList[ {"FileName":"aa.txt", "UploadData":"binary형식 변환"}]
			// apprMap.put("AttachList","");

			// 3. 로그 기본 정보 가공. ( Contents가 2000보다 클 경우 잘라야 하는듯 ? )
			// content 작성
			String contents = setSKAprvHtmlContent(insertWFInstData);
			if (contents.length() > 2000) {
				apprMap.put("Contents", contents.substring(0, 2000));
			} else {
				apprMap.put("Contents", contents);
			}

			// 기존 json data -> map
			LinkedMultiValueMap<String, Object> map = new LinkedMultiValueMap<String, Object>();
			Gson gson = new Gson();
			map.add("jsonData", gson.toJson(apprMap));

			System.out.println(gson.toJson(apprMap));

			// 전자결재 공통 API 서버로 전송
			HttpHeaders headers = new HttpHeaders();
			MediaType mediaType = new MediaType("application", "x-www-form-urlencoded", Charset.forName("UTF-8"));
			headers.set("Authorization", token);
			headers.setContentType(mediaType);

			HttpEntity<MultiValueMap<String, Object>> request = new HttpEntity<>(map, headers);

			result = new RestTemplate().postForObject(url, request, Map.class);

			System.out.println("전자결재 테스트 END");
			System.out.println("Result : " + result.get("Result"));
			System.out.println("Detail : " + result.get("Detail"));
			System.out.println("Message : " + result.get("Message"));

		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e);
		}

		return result;
	}

	public static String setSKAprvHtmlContent(Map insertWFInstData) throws Exception {

		String contents = "";

		contents += "<table cellspacing='0' cellpadding='0' border='0' width='640' id='ITS_tbApproval'>";
		contents += "	<tr>";
		contents += "		<td>";

		// MAIN SUBJECT
		contents += "			<table cellspacing='0' cellpadding='0' border='0' width='640' style='margin-top: 5px;' height='25px'>";
		contents += "				<tr>";
		contents += "					<td width='15'> <img src='http://its.skenergy.com/Resources/Images/bullet_1depth.gif' width='14' height='15' align='middle'>  </td>";
		contents += "					<td class='stitle2'>제목</td>";
		contents += "				</tr>";
		contents += "			</table>";

		// MAIN CONTENTS ( ATTR 정보 or 결재 정보만 간단하게? ( 변경개요 / 문서유형 등등 .. )
		contents += "			<table cellpadding='2' cellspacing='1' border='0' width='640' style='margin-bottom:10px' class='ITS_OrgTable'>";
		contents += "				<colgroup>";
		contents += "					<col width='140px'>";
		contents += "					<col width='/'>";
		contents += "				</colgroup>";
		contents += "				<tr>";
		contents += "					<td class='ITS_popupOrgTableHeader'>내용</td>";
		contents += "					<td class='ITS_popupOrgTableRight'>내용22</td>";
		contents += "				</tr>";
		contents += "			</table>";

		// SUB TABLE
		contents += "			<table border='0' cellpadding='2' cellspacing='1' width='640' class='ITS_OrgTable' width='100%'>";
		contents += "				<tr>";
		contents += "					<td class='ITS_popupOrgTableHeader' width='80' style='text-align:center'>test</td>";
		contents += "				</tr>";
		contents += "				<tr>";
		contents += "					<td class='ITS_popupOrgTableRightNum' style='text-align:center'>test112</td>";
		contents += "				</tr>";
		contents += "			</table>";

		contents += "		</td>";
		contents += "    </tr>";
		contents += "</table>";

		return contents;
	}

	public HashMap insertWFStepInst(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		HashMap setData = new HashMap();
		HashMap inserWFInstTxtData = new HashMap();
		HashMap insertWFStepData = new HashMap();
		HashMap insertWFInstData = new HashMap();
		try {

			String wfInstanceID = StringUtil.checkNull(commandMap.get("wfInstanceID"));
			String projectID = StringUtil.checkNull(commandMap.get("projectID"));
			String documentID = StringUtil.checkNull(commandMap.get("documentID")); // activityLogID
			String documentNo = StringUtil.checkNull(commandMap.get("documentNo")); // SRCODE
			String wfID = StringUtil.checkNull(commandMap.get("wfID"));
			String loginUser = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String creatorTeamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
			String aprvOption = StringUtil.checkNull(commandMap.get("aprvOption"));
			String docCategory = StringUtil.checkNull(commandMap.get("docCategory"), "");
			String description = StringUtil.checkNull(commandMap.get("description"));
			String wfAllocID = StringUtil.checkNull(commandMap.get("wfAllocID"));
			String subject = StringUtil.checkNull(commandMap.get("subject"));
			String newWFInstanceID = StringUtil.checkNull(commandMap.get("newWFInstanceID"));
			String inhouse = StringUtil.checkNull(commandMap.get("inhouse"));

			String getWfStepMemberIDs = StringUtil.checkNull(commandMap.get("wfStepMemberIDs"));
			String getWfStepRoleTypes = StringUtil.checkNull(commandMap.get("wfStepRoleTypes"));

			String wfStepMemberIDs[] = null;
			String wfStepRoleTypes[] = null;
			String wfStepSeq[] = null;

			if (!getWfStepMemberIDs.isEmpty()) {
				wfStepMemberIDs = getWfStepMemberIDs.split(",");
			}
			if (!getWfStepRoleTypes.isEmpty()) {
				wfStepRoleTypes = getWfStepRoleTypes.split(",");
				wfStepSeq = getWfStepRoleTypes.split(",");
			}

			// SET APRV PATH
			int idx = 0;

			for (int j = 0; j < wfStepRoleTypes.length; j++) {
				if (j == 0) {
					wfStepSeq[j] = "0";
					idx++;
				} else {
					wfStepSeq[j] = StringUtil.checkNull(idx);
					idx++;
				}
			}

			int lastSeq = idx - 1;

			// Delete WF Instance Text
			setData.put("wfInstanceID", wfInstanceID);
			commonService.delete("wf_SQL.deleteWFInstTxt", setData);
			String status = "1"; // 내부 전자결재
			if (inhouse.equals("Y"))
				status = "-1"; // 외부 전자결재

			// gw 호출시 wf_inst.status = -1 --> pid 리턴시 : 0 --> submit 시 결재 진행중 update 1
			// -----> 최종 결재시 2 or 3 나머지는 path 에 update
			// INSERT NEW WF Instance
			insertWFInstData.put("WFInstanceID", newWFInstanceID);
			insertWFInstData.put("ProjectID", projectID);
			insertWFInstData.put("DocumentID", documentID);
			insertWFInstData.put("DocumentNo", documentNo);
			insertWFInstData.put("DocCategory", docCategory);
			insertWFInstData.put("WFID", wfID);
			insertWFInstData.put("Creator", loginUser);
			insertWFInstData.put("LastUser", loginUser);
			insertWFInstData.put("Status", status); // 상신
			insertWFInstData.put("aprvOption", aprvOption);
			insertWFInstData.put("curSeq", "1");
			insertWFInstData.put("LastSigner", loginUser);
			insertWFInstData.put("lastSeq", lastSeq);
			insertWFInstData.put("creatorTeamID", creatorTeamID);
			insertWFInstData.put("wfAllocID", wfAllocID);

			commonService.insert("wf_SQL.insertToWfInst", insertWFInstData);

			// INSERT WF STEP INST
			String maxId = "";
			if (!getWfStepMemberIDs.isEmpty()) {
				for (int i = 0; i < wfStepMemberIDs.length; i++) {

					status = null;

					insertWFStepData.put("Seq", wfStepSeq[i]);
					maxId = commonService.selectString("wf_SQL.getMaxStepInstID", setData);

					insertWFStepData.put("StepInstID", Integer.parseInt(maxId) + 1);
					insertWFStepData.put("ProjectID", projectID);

					if (i == 0) {
						status = "1";
					} else if (wfStepSeq[i].equals("1")) {
						status = "0";
					}
					insertWFStepData.put("Status", status);
					insertWFStepData.put("ActorID", wfStepMemberIDs[i]);
					insertWFStepData.put("WFID", wfID);
					insertWFStepData.put("WFStepID", wfStepRoleTypes[i]);
					if (wfInstanceID.isEmpty()) {
						insertWFStepData.put("WFInstanceID", newWFInstanceID);
					}
					commonService.insert("wf_SQL.insertWfStepInst", insertWFStepData);

				}
			}

			// INSERT WF INST TEXT(SUBJECT, DECSRIPTION)
			inserWFInstTxtData.put("WFInstanceID", newWFInstanceID);
			inserWFInstTxtData.put("subject", subject);
			inserWFInstTxtData.put("subjectEN", subject);
			inserWFInstTxtData.put("description", description);
			inserWFInstTxtData.put("descriptionEN", description);
			inserWFInstTxtData.put("comment", "");
			inserWFInstTxtData.put("actorID", loginUser);
			commonService.insert("wf_SQL.insertWfInstTxt", inserWFInstTxtData);

		} catch (Exception e) {

			System.out.println(e.toString());
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류
																													// 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);

		return insertWFInstData;
	}

	// 전자결재 return ( TODO )
	@RequestMapping("/custom/sk/aprvProcessing.do")
	public String zSK_updateRetrunAprvProcessing(HttpServletRequest request, HashMap commandMap, ModelMap model,
			HttpServletResponse response) throws Exception {

		System.out.println("전자결재 RETURN 테스트 START");
		String url = "";
		Map target = new HashMap();
		Map setData = new HashMap();
		try {

			Enumeration<String> parameterNames = request.getParameterNames();
			System.out.println("Received Parameters:");
			while (parameterNames.hasMoreElements()) {
				String paramName = parameterNames.nextElement();
				String[] paramValues = request.getParameterValues(paramName);

				System.out.print(paramName + ": ");
				for (String value : paramValues) {
					System.out.print(value + " ");
				}
				System.out.println();
			}
			/*
			 * <?xml version="1.0" encoding="UTF-8" ?> <ApprovalExecFeed>
			 * <ItemID>a45cbfec-68e7-471a-8fc5-ddb9438ede62</ItemID>
			 * <DocID>64AD05C4D1184F2A958186BAF1FF6F88</DocID> <DocStatus>진행</DocStatus>
			 * <DocSubStatus>검토요청</DocSubStatus> <ApproverID>si77771</ApproverID>
			 * <LastActionDT>2024-09-10 10:43:58</LastActionDT>
			 * <LastActionName>request</LastActionName> <AuthorID>si77771</AuthorID>
			 * <AuthorName>이노일</AuthorName> <CreateDT>2024-09-10 10:43:00</CreateDT>
			 * <Title>return 테스트</Title> <FormID>AI20729</FormID>
			 * <ApproverList><emp0>si77771</emp0> <r0001>si77773</r0001> <r0002></r0002>
			 * <r0003></r0003> <app0>si77772</app0> <before></before>
			 * <after></after></ApproverList> <Histories> <Approver>
			 * <TaskName>emp0</TaskName> <UserID>si77771</UserID> <Opinion>결재상신
			 * 드립니다</Opinion> </Approver> </Histories> </ApprovalExecFeed>
			 */

			String returnParam = request.getParameter("ApprovalExecFeed");
			System.out.println(returnParam);

			/*
			 * // XML 파서 준비 DocumentBuilderFactory factory =
			 * DocumentBuilderFactory.newInstance(); DocumentBuilder builder =
			 * factory.newDocumentBuilder(); InputStream is = new
			 * ByteArrayInputStream(returnParam.getBytes("UTF-8")); Document document =
			 * builder.parse(is); document.getDocumentElement().normalize();
			 * 
			 * // 예시: 'steps' 엘리먼트의 'datecreated' 속성 추출 String dateCreated =
			 * document.getDocumentElement().getAttribute("datecreated");
			 * System.out.println("Date Created: " + dateCreated);
			 * 
			 * // 예시: 모든 'person' 엘리먼트에서 이름 추출 NodeList personList =
			 * document.getElementsByTagName("person"); for (int i = 0; i <
			 * personList.getLength(); i++) { Element person = (Element) personList.item(i);
			 * String name = person.getAttribute("name"); System.out.println("Person Name: "
			 * + name); }
			 */

			// LastActionName
			// 기안 - request : 진행 : 검토요청
			// 검토 - approve : 진행 : 검토요청 (검토 마지막은 결재요청)
			// 승인 - approve : 완료 : 완료
			// 반려 - reject : 반려 : 반려
			// 결재철회 - withdraw : 철회 : 철회

			// ========================================================================================================================================
			/*
			 * String pid = StringUtil.checkNull(request.getParameter("PID")); String
			 * approveYN = StringUtil.checkNull(request.getParameter("ApproveYN")); //
			 * (P:결재중(APP000102) Y:승인(APP000103) N:반려(APP000104)) String approveId =
			 * request.getParameter("ApproveId"); // ApproveId : sKeys
			 * 
			 * setData.put("returnValue", pid); Map wfInstanceInfo =
			 * commonService.select("wf_SQL.getWFINSTanceInfo", setData); String
			 * wfInstanceID = StringUtil.checkNull(wfInstanceInfo.get("WFInstanceID"));
			 * setData.put("wfID", StringUtil.checkNull(wfInstanceInfo.get("WFID")));
			 * setData.put("wfDocType",
			 * StringUtil.checkNull(wfInstanceInfo.get("DocCategory"))); String
			 * postProcessing =
			 * StringUtil.checkNull(commonService.selectString("wf_SQL.getPostProcessing",
			 * setData));
			 * 
			 * String status = ""; if(approveYN.equals("Y")) { // 승인 status = "2"; } else
			 * if(approveYN.equals("N")){ // 반려 status = "3"; } else
			 * if(approveYN.equals("P")) { // 결재중 status = "1"; }
			 * 
			 * setData.put("Status", status); setData.put("WFInstanceID", wfInstanceID);
			 * setData.put("LastUser", StringUtil.checkNull(wfInstanceInfo.get("Creator")));
			 * setData.put("Path", returnParam);
			 * 
			 * // update wf_inst commonService.update("wf_SQL.updateWfInst", setData);
			 * commonService.update("wf_SQL.updateWFStepInst", setData);
			 * 
			 * if(!postProcessing.equals("")) { String data =
			 * "curWFInstanceID="+wfInstanceID +
			 * "&languageID=1042&lastUser="+StringUtil.checkNull(wfInstanceInfo.get(
			 * "Creator")) +
			 * "&sessionUserId="+StringUtil.checkNull(wfInstanceInfo.get("Creator"))+"&pid="
			 * +pid; postProcessing += "?" + data;
			 * System.out.println("postProcessing :"+postProcessing);
			 * 
			 * response.sendRedirect(postProcessing); return null; // 리디렉션 후 추가 처리가 없으므로
			 * null 반환 }
			 */

		} catch (Exception e) {
			System.out.println(e);
		}

		return nextUrl(AJAXPAGE);
	}

	@RequestMapping({ "/zskOnOwnerItemList.do" })
	public String zhecOwnerItemList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {
			List returnData = new ArrayList();
			model.put("s_itemID", request.getParameter("s_itemID"));
			model.put("regFlg", request.getParameter("regFlg"));
			model.put("pageNum", request.getParameter("pageNum"));
			model.put("option", request.getParameter("option"));
			model.put("ownerType", request.getParameter("ownerType"));
			model.put("teamID", request.getParameter("teamID"));
			model.put("statusList", request.getParameter("statusList"));
			model.put("status", StringUtil.checkNull(request.getParameter("status"), ""));
			model.put("teamManagerID", request.getParameter("teamManagerID"));
			model.put("srID", request.getParameter("srID"));
			model.put("showTOJ", StringUtil.checkNull(commandMap.get("showTOJ")));
			model.put("accMode", StringUtil.checkNull(commandMap.get("accMode"), "DEV"));
			model.put("scrnMode", StringUtil.checkNull(commandMap.get("scrnMode"), "E"));
			model.put("menu", getLabel(request, this.commonService));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/custom/sk/skon/zskOnOwnerItemList");
	}

	@RequestMapping(value = "/logout.do")
	public String logout(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession(false);
		if (session != null) {
			session.invalidate();
		}
		System.out.println("Session ID: " + session.getId() + " destroyed at " + new Date());
		return nextUrl("custom/sf/login");

	}

// --------------------------------------------------------------------------------------------------

	/*
	 * 전자결재 참고 소스
	 * 
	 * ################# JS java 서비스 호출시 Param 정보 ###############################
	 * 
	 * 전자결재 팝업 호출 sample data ( 아래와 같이 데이터를 만든다 ) var aprvInfo = { "process":
	 * SKICOM.ENUM.APPROVAL_PROCESS_TYPE.PROCESS_51, // 33,50 : 첨부파일없는 결재. 34,51 :
	 * 첨부파일있는 결재. "bizTp" : "60", // 업무 구분( 코드 W0017) "bizNo": apprData[0].pjtId, //
	 * 업무 번호(해당 업무 번호) - 프로젝트 ID "bizSeq": apprData[0].itemId, // 업무 순번 - Item ID
	 * "bizSubSeq": apprData[0].procId, // 업무 순번 서브코드(차수 등) - Proc Id "aprTp" :
	 * "T5", // 전자결재(T5) "docTitle" : "[EPMS] Activity 종료 승인 요청", // 결재 제목
	 * "plSetting" : false, // 자기 조직의 PL을 승인자로 자동 셋팅하기 "reqUserId" :
	 * activityApprUserId, "reqUserNm" : activityApprUserNm, "reqUser" :
	 * activityApprUser "keepYear": SKICOM.ENUM.APPROVAL_KEEP_TYPE.MONTH_2, // 보존연한
	 * / Default는 양식설정 기본값 적용 (변경이 필요한 경우만 입력) "secretLevel":
	 * SKICOM.ENUM.APPROVAL_SECRET_TYPE.LEVEL_1, // 보안등급 / Default는 양식설정 기본값 적용 (변경이
	 * 필요한 경우만 입력) };
	 * 
	 * this.fn_requestTokAprv = function (aprvInfo) {
	 * 
	 * //SKICOM.ENUM.APPROVAL_PROCESS_TYPE.PROCESS_51 타입 이외에는 전부 오류가 발생. 우선 51로 강제
	 * 설정. aprvInfo["process"] = SKICOM.ENUM.APPROVAL_PROCESS_TYPE.PROCESS_51;
	 * 
	 * // 보존연한 default 1년 var strKeepYear = ''; if (typeof aprvInfo.keepYear !=
	 * 'undefined' && $.trim(aprvInfo.keepYear) != '') { var tmpKeepYear =
	 * $.trim(aprvInfo.keepYear);
	 * 
	 * if (tmpKeepYear != '2' && tmpKeepYear != '10' && tmpKeepYear != '20' &&
	 * tmpKeepYear != '30' && tmpKeepYear != '50' && tmpKeepYear != '100' &&
	 * tmpKeepYear != '999') { alert('보존연한 정보가 잘못되었습니다. 기안할 수 없습니다.'); return false;
	 * } else { strKeepYear = tmpKeepYear; } }
	 * 
	 * aprvInfo.keepYear = strKeepYear;
	 * 
	 * // 보안등급 default 사내한 var strSecretLevel = ''; if (typeof aprvInfo.secretLevel
	 * != 'undefined' && $.trim(aprvInfo.secretLevel) != '') { var tmpSecretLevel =
	 * $.trim(aprvInfo.secretLevel);
	 * 
	 * if (tmpSecretLevel != '1' && tmpSecretLevel != '2' && tmpSecretLevel != '3'
	 * && tmpSecretLevel != '4') { alert('보안등급 정보가 잘못되었습니다. 기안할 수 없습니다.'); return
	 * false; } else { strSecretLevel = tmpSecretLevel; } }
	 * 
	 * aprvInfo.secretLevel = strSecretLevel;
	 * 
	 * return AprvRequestModule.requestAprv(aprvInfo);
	 * 
	 * };
	 * 
	 * 
	 * 서버로 결재 정보 전달
	 * 
	 * this.requestAprv = function(aprvInfo) { // console.log("apprTest Start"); //
	 * 첨부파일 확인 var isSuccess = false; var aprNo = null; var reqData =
	 * JSON.stringify(aprvInfo, null, 4);
	 * 
	 * $a.request(SKICOM.PATH.APPROVAL_REQUEST, { method : 'POST', dataType :
	 * 'json', async : false, data : aprvInfo, success : function(res) {
	 * 
	 * if (res.data.result == "SUCCESS") {
	 * if(!SKICOM.util.isNull(res.data.openUrl)){
	 * window.open(res.data.openUrl,"POPT5WIN",
	 * "left=0,top=0,width=200,height=200"); aprNo = res.data.formId; } } else {
	 * alert('전자결재 팝업창을 호출할 수 없습니다.\n[원인:' + res.data.message + ']\n[상세내용:' +
	 * res.data.ifDetail + ']'); } }, error: function (res) { //
	 * console.log("error!!!!!!!!!!!"); // console.log(res); } }); //
	 * console.log("=============================end");
	 * 
	 * return aprNo; };
	 * 
	 * 
	 * ################# JAVA 소스 ############################### <pre> 전자결재 API 를
	 * 호출합니다. </pre>
	 * 
	 * @param aprv : 전자결재를 위한 정보로 {@link AprvRequestCallDTO} 클래스 형태입니다.
	 * 
	 * @return 전재 결재 요청에 대한 결과 내용을 반환합니다.
	 * 
	 * public IfAprvLogVO callAprvRequest(AprvRequestCallDTO data) {
	 * 
	 * log.info(gson.toJson(data));
	 * 
	 * // String hostName = System.getenv("HOSTNAME"); // boolean bRunServer =
	 * hostName != null && !"ski-nplmdap".equals(hostName) &&
	 * !"localhost".equals(hostName) ? true : false; boolean bRunServer =
	 * "prd".equals(curServerActive); // 운영서버인지 아닌지 판단
	 * 
	 * 
	 * 화면에서 필수로 받아와야 할 데이터 process, bizTp, bizNo, bizSeq, bizSubSeq, keepYear(변경
	 * 필요시, 빈값인 경우 결재화면의 기본값이 적용됨), secretLevel(변경 필요시, 빈값인 경우 결재화면의 기본값이 적용됨),
	 * approverList 각 업무별 개발자가 작성해야 할 데이터 docTitle, fileNo 리스트, contents 공통에서 만들어 주는
	 * 데이터 authorID, companyID, fileNo Stream Data
	 * 
	 * //결재 연동 정보 생성 EmailCommonDTO emailCommonDTO = new EmailCommonDTO();
	 * emailCommonDTO.setBizno(data.getBizNo());
	 * emailCommonDTO.setBizseq(data.getBizSeq());
	 * emailCommonDTO.setBizsubseq(data.getBizSubSeq());
	 * emailCommonDTO.setBiztype(data.getBizTp());
	 * emailCommonDTO.setDoctitle(data.getDocTitle());
	 * 
	 * emailCommonDTO = emailBizService.makeEmailContent(emailCommonDTO, true);
	 * 
	 * data.setDocTitle(emailCommonDTO.getDoctitle());
	 * data.setContents(emailCommonDTO.getContent());
	 * data.setBottomText(emailCommonDTO.getMessage());
	 * data.setReturnUrl(emailCommonDTO.getReturnurl());
	 * 
	 * //결재 양식 체크 if(data.getProcess() == null) {
	 * data.setProcess(ski.aprv.constant.ApprovalProcessType.PROCESS_51.getName());
	 * }
	 * 
	 * // bRunServer = false; UserInfoDTO userInfoDTO =
	 * SessionUtil.getLoginUserInfo();
	 * 
	 * //개발 서버인 경우 기안자와 회사코드, 결재선을 개발로 지정해준다. if(!bRunServer) { //기안자 작성
	 * data.setAuthorID("si77771");
	 * //data.setAuthorID(userInfoDTO.getUser().getLoginId());
	 * 
	 * //회사 코드 작성 data.setCompanyID("H70");
	 * 
	 * // 테스트 서버 결재선 변경
	 * data.setApproverList(getTestServerApprovalLineList(data.getApproverList()));
	 * } else { //기안자 작성 data.setAuthorID(userInfoDTO.getUser().getLoginId());
	 * 
	 * //회사 코드 작성 data.setCompanyID(userInfoDTO.getUser().getCompanyCode());
	 * 
	 * }
	 * 
	 * IfAprvLogVO result = new IfAprvLogVO(); IfAprvLogVO aprvLog = new
	 * IfAprvLogVO(); AprvResponseDTO resp = new AprvResponseDTO(); Approval.FormID
	 * formType = Approval.findFormID(data.getProcess()); String token =
	 * formType.getToken(); String url = Approval.getRequestURL(); String aprNo =
	 * null;
	 * 
	 * try {
	 * 
	 * // 1. 요청 보낼 정보 가공. AprvRequestDTO req = new AprvRequestDTO();
	 * List<AprvRequestApproverDTO> approvers = new
	 * ArrayList<AprvRequestApproverDTO>(); data.getApproverList().forEach(a ->
	 * approvers.add(getApprover(a.getTaskName(), a.getUserID())));
	 * 
	 * // 파일 저장 List<AprvRequestAttachDTO> attatchments = new
	 * ArrayList<AprvRequestAttachDTO>(); long fileNo =
	 * fileInfoService.saveFileInfo(0,
	 * fileInfoService.uploadFileInfo(data.getFileItemList())); if (fileNo > 0) { //
	 * 첨부가 존재하는 경우 List<FileInfoVO> fileInfoList =
	 * fileInfoService.findByFileNo(fileNo); for (FileInfoVO fileInfo :
	 * fileInfoList) { AprvRequestAttachDTO attatch = new AprvRequestAttachDTO();
	 * String strSteam =
	 * fileToString(Util.getFileDownloadAbsolFilePath(fileInfo.getFilePath()), (int)
	 * fileInfo.getFileSize()); if (strSteam.length() > 0) {
	 * attatch.setFileName(fileInfo.getOriFileNm());
	 * attatch.setUploadData(strSteam); attatchments.add(attatch); } } }
	 * if(data.getFileNo() > 0) { List<FileInfoVO> fileSavedInfoList =
	 * fileInfoService.findByFileNo(data.getFileNo()); List<FileItemDTO> fileList =
	 * data.getFileItemList(); Map<Long, List<FileItemDTO>> deletedFileMap =
	 * fileList.stream().filter(file -> data.getFileNo() == file.getFileNo())
	 * .collect(Collectors.groupingBy(file -> file.getFileSeq())); // 삭제된 파일들
	 * 
	 * for (FileInfoVO fileInfo : fileSavedInfoList) {
	 * if(deletedFileMap.get(fileInfo.getFileSeq()) != null &&
	 * deletedFileMap.get(fileInfo.getFileSeq()).size() > 0) continue; // 삭제된 파일들에
	 * 있으면 전송 X AprvRequestAttachDTO attatch = new AprvRequestAttachDTO(); String
	 * strSteam =
	 * fileToString(Util.getFileDownloadAbsolFilePath(fileInfo.getFilePath()), (int)
	 * fileInfo.getFileSize()); if (strSteam.length() > 0) {
	 * attatch.setFileName(fileInfo.getOriFileNm());
	 * attatch.setUploadData(strSteam); attatchments.add(attatch); } } }
	 * 
	 * req.setAuthorID(data.getAuthorID()); req.setCompanyID(data.getCompanyID());
	 * req.setContents(data.getContents().replace("\n", "<br/>").replace("%",
	 * "%25").replace("&", "%26").replace("+", "%2B"));
	 * req.setDocTitle(data.getDocTitle()); req.setFormID(formType.getFormId());
	 * req.setKeepYear(data.getKeepYear());
	 * req.setSecretLevel(data.getSecretLevel());
	 * req.setContentType(ApprovalContentType.HTML.getName());
	 * req.setLangCode(ApprovalLanguageType.KOREAN.getName());
	 * req.setLegacyItemID(data.getBizTp()); req.setApproverList(approvers);
	 * req.setAttachList(attatchments);
	 * 
	 * log.info(gson.toJson(req));
	 * 
	 * // 2. 로그 기본 정보 가공. aprvLog.setIfSender(data.getAuthorID());
	 * aprvLog.setIfUrl(url); aprvLog.setIfToken(token);
	 * aprvLog.setIfData(gson.toJson(req)); aprvLog.setFormId(req.getFormID());
	 * aprvLog.setLegacyItemId(req.getLegacyItemID());
	 * aprvLog.setDocTitle(req.getDocTitle());
	 * aprvLog.setAuthorId(req.getAuthorID());
	 * aprvLog.setCompanyId(req.getCompanyID());
	 * aprvLog.setKeepYear(req.getKeepYear());
	 * aprvLog.setSecurityLevel(req.getSecretLevel());
	 * aprvLog.setLangCode(req.getLangCode());
	 * aprvLog.setContentType(req.getContentType());
	 * 
	 * if(req.getContents().length() > 2000) {
	 * aprvLog.setContents(req.getContents().substring(0, 2000)); } else {
	 * aprvLog.setContents(req.getContents()); }
	 * 
	 * aprvLog.setApproverList(gson.toJson(req.getApproverList())); if (fileNo > 0)
	 * aprvLog.setFileNo(fileNo+"");
	 * 
	 * LinkedMultiValueMap<String, Object> map = new LinkedMultiValueMap<String,
	 * Object>(); map.add("jsonData", gson.toJson(req)); log.info(gson.toJson(map));
	 * 
	 * //전자결재 공통 API 서버로 전송 Map<String, Object> rst =
	 * Transfer.transmitHttpWithStringObjectMap(url, token, map); resp =
	 * gson.fromJson(gson.toJson(rst), AprvResponseDTO.class);
	 * log.info(gson.toJson(resp));
	 * 
	 * // I/F 결과 로그 정보 가공. if (resp.getResult().equals("SUCCESS")) { //
	 * +++++++++++++++++ 전자 결재 정보를 저장 시작 +++++++++++++++++ String docId =
	 * resp.getMessage(); String openUrl = resp.getDetail();
	 * aprvLog.setDocId(docId); aprvLog.setOpenUrl(openUrl);
	 * aprvLog.setResult(resp.getResult()); aprvLog.setMessage(docId);
	 * aprvLog.setDetail(openUrl); aprvLog.setIfResult(resp.getResult());
	 * aprvLog.setIfDetail("I/F 호출 결과가 성공입니다.");
	 * 
	 * // 전자결재 정보 가공. AprvVO aprv = new AprvVO(); aprv.setAprKind("T5"); //NEW 테이블
	 * 변경 스키마 추가
	 * 
	 * //aprv.setAprSttCd("REQUEST"); //NEW 테이블 변경 스키마 추가
	 * //aprv.setAprSubSttCd("APRREQ");
	 * 
	 * aprv.setDocId(docId); aprv.setOpenUrl(openUrl);
	 * aprv.setBizNo(data.getBizNo()); aprv.setBizTp(data.getBizTp()); //NEW 테이블 변경
	 * 스키마 추가 aprv.setBizSeq(data.getBizSeq());
	 * aprv.setBizSubSeq(data.getBizSubSeq()); aprv.setTitle(data.getDocTitle());
	 * aprv.setFormId(req.getFormID()); if (fileNo > 0) aprv.setFileNo("" + fileNo);
	 * aprv.setKeepYear(data.getKeepYear() != null && data.getKeepYear().length() >
	 * 0 ? data.getKeepYear() :
	 * ski.aprv.constant.ApprovalKeepType.YEAR_1.getName());
	 * aprv.setSecurityLevel(data.getSecretLevel() != null &&
	 * data.getSecretLevel().length() > 0? data.getSecretLevel() :
	 * ski.aprv.constant.ApprovalSecretType.LEVEL_3.getName());
	 * aprv.setBizflag(data.getBizflag()); aprv.setProjectid(data.getProjectid());
	 * aprvRepository.save(aprv);
	 * 
	 * log.info("####### getAprNo ########");
	 * log.info(gson.toJson(aprv.getAprNo()));
	 * log.info("####### getAprNo ########"); aprNo = aprv.getAprNo();
	 * 
	 * // 전자결재 결재자 정보 가공. int i = 1; List<AprvApproverVO> aprvApproverList = new
	 * ArrayList<AprvApproverVO>(); for(AprvRequestApproverDTO man : approvers) {
	 * AprvApproverVO aprvApprover = new AprvApproverVO();
	 * aprvApprover.setAprNo(aprv.getAprNo()); aprvApprover.setAprSeq(i);
	 * aprvApprover.setSttCd("C");
	 * aprvApprover.setAprTp(ConvertApproverType(man.getTaskName()));
	 * aprvApprover.setAprId(man.getUserID());
	 * aprvApproverRepository.save(aprvApprover);
	 * 
	 * aprvApproverList.add(aprvApprover); i++; }
	 * 
	 * aprvApproverRepository.saveAll(aprvApproverList);
	 * 
	 * /** ----------------- 전자 결재 정보를 저장 종료 -----------------
	 * 
	 * // +++++++++++++++++ 업무별 상태값 정보를 저장 시작+++++++++++++++++ //
	 * updateBizData(data, resp); //----------------- 업무별 상태값 정보를 저장 종료
	 * ----------------- } else { aprvLog.setIfResult("FAIL");
	 * aprvLog.setIfDetail("I/F 호출 결과가 실패입니다.");
	 * aprvLog.setResult(resp.getResult()); aprvLog.setMessage(resp.getMessage());
	 * aprvLog.setDetail(resp.getDetail()); }
	 * 
	 * } catch (Exception ex) { // I/F 오류 로그 정보 가공. aprvLog.setDocId("");
	 * aprvLog.setOpenUrl(""); aprvLog.setIfResult("FAIL"); aprvLog.setIfDeString
	 * hostName = System.getenv("HOSTNAME"); // boolean bRunServer = hostName !=
	 * null && !"ski-nplmdap".equals(hostName) && !"localhost".equals(hostName) ?
	 * true : false; boolean bRunServer = "prd".equals(curServerActive); // 운영서버인지
	 * 아닌지 판단
	 * 
	 * 
	 * 화면에서 필수로 받아와야 할 데이터 process, bizTp, bizNo, bizSeq, bizSubSeq, keepYear(변경
	 * 필요시, 빈값인 경우 결재화면의 기본값이 적용됨), secretLevel(변경 필요시, 빈값인 경우 결재화면의 기본값이 적용됨),
	 * approverList 각 업무별 개발자가 작성해야 할 데이터 docTitle, fileNo 리스트, contents 공통에서 만들어 주는
	 * 데이터 authorID, companyID, fileNo Stream Data
	 * 
	 * //결재 연동 정보 생성 EmailCommonDTO emailCommonDTO = new EmailCommonDTO();
	 * emailCommonDTO.setBizno(data.getBizNo());
	 * emailCommonDTO.setBizseq(data.getBizSeq());
	 * emailCommonDTO.setBizsubseq(data.getBizSubSeq());
	 * emailCommonDTO.setBiztype(data.getBizTp());
	 * emailCommonDTO.setDoctitle(data.getDocTitle());
	 * 
	 * emailCommonDTO = emailBizService.makeEmailContent(emailCommonDTO, true);
	 * 
	 * data.setDocTitle(emailCommonDTO.getDoctitle());
	 * data.setContents(emailCommonDTO.getContent());
	 * data.setBottomText(emailCommonDTO.getMessage());
	 * data.setReturnUrl(emailCommonDTO.getReturnurl());
	 * 
	 * //결재 양식 체크 if(data.getProcess() == null) {
	 * data.setProcess(ski.aprv.constant.ApprovalProcessType.PROCESS_51.getName());
	 * }
	 * 
	 * // bRunServer = false; UserInfoDTO userInfoDTO =
	 * SessionUtil.getLoginUserInfo();
	 * 
	 * //개발 서버인 경우 기안자와 회사코드, 결재선을 개발로 지정해준다. if(!bRunServer) { //기안자 작성
	 * data.setAuthorID("si77771");
	 * //data.setAuthorID(userInfoDTO.getUser().getLoginId());
	 * 
	 * //회사 코드 작성 data.setCompanyID("H70");
	 * 
	 * // 테스트 서버 결재선 변경
	 * data.setApproverList(getTestServerApprovalLineList(data.getApproverList()));
	 * } else { //기안자 작성 data.setAuthorID(userInfoDTO.getUser().getLoginId());
	 * 
	 * //회사 코드 작성 data.setCompanyID(userInfoDTO.getUser().getCompanyCode());
	 * 
	 * }
	 * 
	 * IfAprvLogVO result = new IfAprvLogVO(); IfAprvLogVO aprvLog = new
	 * IfAprvLogVO(); AprvResponseDTO resp = new AprvResponseDTO(); Approval.FormID
	 * formType = Approval.findFormID(data.getProcess()); String token =
	 * formType.getToken(); String url = Approval.getRequestURL(); String aprNo =
	 * null;
	 * 
	 * try {
	 * 
	 * // 1. 요청 보낼 정보 가공. AprvRequestDTO req = new AprvRequestDTO();
	 * List<AprvRequestApproverDTO> approvers = new
	 * ArrayList<AprvRequestApproverDTO>(); data.getApproverList().forEach(a ->
	 * approvers.add(getApprover(a.getTaskName(), a.getUserID())));
	 * 
	 * // 파일 저장 List<AprvRequestAttachDTO> attatchments = new
	 * ArrayList<AprvRequestAttachDTO>(); long fileNo =
	 * fileInfoService.saveFileInfo(0,
	 * fileInfoService.uploadFileInfo(data.getFileItemList())); if (fileNo > 0) { //
	 * 첨부가 존재하는 경우 List<FileInfoVO> fileInfoList =
	 * fileInfoService.findByFileNo(fileNo); for (FileInfoVO fileInfo :
	 * fileInfoList) { AprvRequestAttachDTO attatch = new AprvRequestAttachDTO();
	 * String strSteam =
	 * fileToString(Util.getFileDownloadAbsolFilePath(fileInfo.getFilePath()), (int)
	 * fileInfo.getFileSize()); if (strSteam.length() > 0) {
	 * attatch.setFileName(fileInfo.getOriFileNm());
	 * attatch.setUploadData(strSteam); attatchments.add(attatch); } } }
	 * if(data.getFileNo() > 0) { List<FileInfoVO> fileSavedInfoList =
	 * fileInfoService.findByFileNo(data.getFileNo()); List<FileItemDTO> fileList =
	 * data.getFileItemList(); Map<Long, List<FileItemDTO>> deletedFileMap =
	 * fileList.stream().filter(file -> data.getFileNo() == file.getFileNo())
	 * .collect(Collectors.groupingBy(file -> file.getFileSeq())); // 삭제된 파일들
	 * 
	 * for (FileInfoVO fileInfo : fileSavedInfoList) {
	 * if(deletedFileMap.get(fileInfo.getFileSeq()) != null &&
	 * deletedFileMap.get(fileInfo.getFileSeq()).size() > 0) continue; // 삭제된 파일들에
	 * 있으면 전송 X AprvRequestAttachDTO attatch = new AprvRequestAttachDTO(); String
	 * strSteam =
	 * fileToString(Util.getFileDownloadAbsolFilePath(fileInfo.getFilePath()), (int)
	 * fileInfo.getFileSize()); if (strSteam.length() > 0) {
	 * attatch.setFileName(fileInfo.getOriFileNm());
	 * attatch.setUploadData(strSteam); attatchments.add(attatch); } } }
	 * 
	 * req.setAuthorID(data.getAuthorID()); req.setCompanyID(data.getCompanyID());
	 * req.setContents(data.getContents().replace("\n", "<br/>").replace("%",
	 * "%25").replace("&", "%26").replace("+", "%2B"));
	 * req.setDocTitle(data.getDocTitle()); req.setFormID(formType.getFormId());
	 * req.setKeepYear(data.getKeepYear());
	 * req.setSecretLevel(data.getSecretLevel());
	 * req.setContentType(ApprovalContentType.HTML.getName());
	 * req.setLangCode(ApprovalLanguageType.KOREAN.getName());
	 * req.setLegacyItemID(data.getBizTp()); req.setApproverList(approvers);
	 * req.setAttachList(attatchments);
	 * 
	 * log.info(gson.toJson(req));
	 * 
	 * // 2. 로그 기본 정보 가공. aprvLog.setIfSender(data.getAuthorID());
	 * aprvLog.setIfUrl(url); aprvLog.setIfToken(token);
	 * aprvLog.setIfData(gson.toJson(req)); aprvLog.setFormId(req.getFormID());
	 * aprvLog.setLegacyItemId(req.getLegacyItemID());
	 * aprvLog.setDocTitle(req.getDocTitle());
	 * aprvLog.setAuthorId(req.getAuthorID());
	 * aprvLog.setCompanyId(req.getCompanyID());
	 * aprvLog.setKeepYear(req.getKeepYear());
	 * aprvLog.setSecurityLevel(req.getSecretLevel());
	 * aprvLog.setLangCode(req.getLangCode());
	 * aprvLog.setContentType(req.getContentType());
	 * 
	 * if(req.getContents().length() > 2000) {
	 * aprvLog.setContents(req.getContents().substring(0, 2000)); } else {
	 * aprvLog.setContents(req.getContents()); }
	 * 
	 * aprvLog.setApproverList(gson.toJson(req.getApproverList())); if (fileNo > 0)
	 * aprvLog.setFileNo(fileNo+"");
	 * 
	 * LinkedMultiValueMap<String, Object> map = new LinkedMultiValueMap<String,
	 * Object>(); map.add("jsonData", gson.toJson(req)); log.info(gson.toJson(map));
	 * 
	 * //전자결재 공통 API 서버로 전송 Map<String, Object> rst =
	 * Transfer.transmitHttpWithStringObjectMap(url, token, map); resp =
	 * gson.fromJson(gson.toJson(rst), AprvResponseDTO.class);
	 * log.info(gson.toJson(resp));
	 * 
	 * // I/F 결과 로그 정보 가공. if (resp.getResult().equals("SUCCESS")) { //
	 * +++++++++++++++++ 전자 결재 정보를 저장 시작 +++++++++++++++++ String docId =
	 * resp.getMessage(); String openUrl = resp.getDetail();
	 * aprvLog.setDocId(docId); aprvLog.setOpenUrl(openUrl);
	 * aprvLog.setResult(resp.getResult()); aprvLog.setMessage(docId);
	 * aprvLog.setDetail(openUrl); aprvLog.setIfResult(resp.getResult());
	 * aprvLog.setIfDetail("I/F 호출 결과가 성공입니다.");
	 * 
	 * // 전자결재 정보 가공. AprvVO aprv = new AprvVO(); aprv.setAprKind("T5"); //NEW 테이블
	 * 변경 스키마 추가
	 * 
	 * //aprv.setAprSttCd("REQUEST"); //NEW 테이블 변경 스키마 추가
	 * //aprv.setAprSubSttCd("APRREQ");
	 * 
	 * aprv.setDocId(docId); aprv.setOpenUrl(openUrl);
	 * aprv.setBizNo(data.getBizNo()); aprv.setBizTp(data.getBizTp()); //NEW 테이블 변경
	 * 스키마 추가 aprv.setBizSeq(data.getBizSeq());
	 * aprv.setBizSubSeq(data.getBizSubSeq()); aprv.setTitle(data.getDocTitle());
	 * aprv.setFormId(req.getFormID()); if (fileNo > 0) aprv.setFileNo("" + fileNo);
	 * aprv.setKeepYear(data.getKeepYear() != null && data.getKeepYear().length() >
	 * 0 ? data.getKeepYear() :
	 * ski.aprv.constant.ApprovalKeepType.YEAR_1.getName());
	 * aprv.setSecurityLevel(data.getSecretLevel() != null &&
	 * data.getSecretLevel().length() > 0? data.getSecretLevel() :
	 * ski.aprv.constant.ApprovalSecretType.LEVEL_3.getName());
	 * aprv.setBizflag(data.getBizflag()); aprv.setProjectid(data.getProjectid());
	 * aprvRepository.save(aprv);
	 * 
	 * log.info("####### getAprNo ########");
	 * log.info(gson.toJson(aprv.getAprNo()));
	 * log.info("####### getAprNo ########"); aprNo = aprv.getAprNo();
	 * 
	 * // 전자결재 결재자 정보 가공. int i = 1; List<AprvApproverVO> aprvApproverList = new
	 * ArrayList<AprvApproverVO>(); for(AprvRequestApproverDTO man : approvers) {
	 * AprvApproverVO aprvApprover = new AprvApproverVO();
	 * aprvApprover.setAprNo(aprv.getAprNo()); aprvApprover.setAprSeq(i);
	 * aprvApprover.setSttCd("C");
	 * aprvApprover.setAprTp(ConvertApproverType(man.getTaskName()));
	 * aprvApprover.setAprId(man.getUserID());
	 * aprvApproverRepository.save(aprvApprover);
	 * 
	 * aprvApproverList.add(aprvApprover); i++; }
	 * 
	 * aprvApproverRepository.saveAll(aprvApproverList);
	 * 
	 * /** ----------------- 전자 결재 정보를 저장 종료 -----------------
	 * 
	 * // +++++++++++++++++ 업무별 상태값 정보를 저장 시작+++++++++++++++++ //
	 * updateBizData(data, resp); //----------------- 업무별 상태값 정보를 저장 종료
	 * ----------------- } else { aprvLog.setIfResult("FAIL");
	 * aprvLog.setIfDetail("I/F 호출 결과가 실패입니다.");
	 * aprvLog.setResult(resp.getResult()); aprvLog.setMessage(resp.getMessage());
	 * aprvLog.setDetail(resp.getDetail()); }
	 * 
	 * } catch (Exception ex) { // I/F 오류 로그 정보 가공. aprvLog.setDocId("");
	 * aprvLog.setOpenUrl(""); aprvLog.setIfResult("FAIL");
	 * aprvLog.setIfDetail(ex.getMessage()); } finally { // I/F 로그 정보 저장. result =
	 * aprvLogRepository.save(aprvLog); result.setFormId(aprNo);
	 * }tail(ex.getMessage()); } finally { // I/F 로그 정보 저장. result =
	 * aprvLogRepository.save(aprvLog); result.setFormId(aprNo); }
	 * 
	 * return result; }
	 * 
	 */

	/********************* 기술표준 등록 및 조 *************/
	// 신규등록 함수
	@RequestMapping(value = "/zSKON_ProcessItemInfo.do")
	public String processItemInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/custom/sk/skon/item/zSKON_editAttrTSDInfo";
		try {
			Map setMap = new HashMap();

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}

	// 신규등록 2
	@RequestMapping(value = "/zSKregisterItem.do")
	public String zSKregisterItem(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/custom/sk/skon/item/zSKON_registerItem";
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			cmmMap.put("ItemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			cmmMap.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
			String itemPath = StringUtil.checkNull(commonService.selectString("organization_SQL.getPathOrg", cmmMap));
			String itemTypeCode = StringUtil.checkNull(commonService.selectString("item_SQL.getItemTypeCode", cmmMap));

			String classCode = StringUtil.checkNull(request.getParameter("classCode"));
			String fltpCode = StringUtil.checkNull(request.getParameter("fltpCode"));
			String dimTypeList = StringUtil.checkNull(request.getParameter("dimTypeList"));

			cmmMap.put("typeCode", classCode);
			cmmMap.put("category", "CLS");
			String className = StringUtil.checkNull(commonService.selectString("common_SQL.getNameFromDic", cmmMap));

			model.put("itemTypeCode", itemTypeCode);
			model.put("itemPath", itemPath);
			model.put("classCode", classCode);
			model.put("fltpCode", fltpCode);
			model.put("dimTypeID", dimTypeList);
			model.put("className", className);

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

	// 공통등록 save 힘수
	@RequestMapping({ "/zskon_saveItemInfo.do" })
	public String zskon_saveItemInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			String scrnMode = StringUtil.checkNull(request.getParameter("scrnMode"), "E");
			String showSaveAlert = StringUtil.checkNull(request.getParameter("showSaveAlert"), "Y");

			String spliteParam = "<img ";
			String replaceStartParam = "src=\"data:image/png;base64,";
			String replaceEndParam = "/>";
			String changImgSrc = spliteParam + " border='0' src=\"";
			String findEndParam = "/>";

			String usrK = StringUtil.checkNull(commandMap.get("sessionUserId"));

			if (scrnMode.equals("N")) {
				target = zsk_CreateItemFunction(request, commandMap, model);
			} else if (scrnMode.equals("D")) {
				target = zsk_DeleteItemFunction(request, commandMap, model);
			} else {
				String extraParam = showSaveAlert;
				target = zsk_UpdateItemFunction(request, commandMap, model, extraParam);
				// target = zsk_UpdateItemFunction(request, commandMap, model);
			}

//			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();parent.actionComplete();");

		} catch (Exception e) {
			System.out.println(e);
			target.put("SCRIPT", "parent.$('#isSubmit').remove();$('#isSubmit').remove();");
			target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
		}
		model.addAttribute("resultMap", target);
		return nextUrl("/cmm/ajaxResult/ajaxPage");
	}

	public HashMap zsk_CreateItemFunction(HttpServletRequest request, HashMap<String, Object> commandMap, ModelMap model)
			throws Exception {
		Map setMap = new HashMap();
		Map insertCngMap = new HashMap();
		Map updateData = new HashMap();
		HashMap target = new HashMap();
		try {
			Map setValue = new HashMap();
			String autoID = StringUtil.checkNull(request.getParameter("autoID"));
			String preFix = StringUtil.checkNull(request.getParameter("preFix"));
			String cpItemID = StringUtil.checkNull(request.getParameter("cpItemID"));
			String s_itemID = StringUtil.checkNull(commandMap.get("s_itemID"));
			String fromItemID = StringUtil.checkNull(commandMap.get("parentID"));
			String mstSTR = StringUtil.checkNull(request.getParameter("mstSTR"));
			String option = StringUtil.checkNull(request.getParameter("option"));
			String scrnMode = StringUtil.checkNull(request.getParameter("scrnMode"));

			String ItemID = this.commonService.selectString("item_SQL.getItemMaxID", setMap);

			String docIdentifier = "";
			setMap.put("ClassCode", "CL16004");

			if (!"".equals(s_itemID)) {
				setValue.put("ItemID", request.getParameter("s_itemID"));
			} else {
				setValue.put("ItemID", ItemID);
			}

			setMap.put("s_itemID", fromItemID);

			setMap.put("s_itemID", fromItemID);

			String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"));
			String itemClassCode = "";

			if (itemTypeCode.equals("OJ00005")) {
				itemClassCode = "CL05003";
			} else if (itemTypeCode.equals("OJ00016")) {
				itemClassCode = "CL16004";
			}

			setMap.put("itemClassCode", itemClassCode);
			setMap.put("itemTypeCode", itemTypeCode);
			setMap.put("userID", StringUtil.checkNull(commandMap.get("sessionUserId")));
			String projectID = StringUtil
					.checkNull(this.commonService.selectString("item_SQL.getItemClassDefCSRID", setMap));

			setMap.put("option", StringUtil.checkNull(request.getParameter("option")));
			setMap.put("Version", "0");
			setMap.put("Deleted", "0");
			setMap.put("Creator", StringUtil.checkNull(commandMap.get("sessionUserId")));
			setMap.put("CategoryCode", "OJ");
			setMap.put("ClassCode", itemClassCode);
			setMap.put("OwnerTeamId", StringUtil.checkNull(commandMap.get("sessionTeamId")));
			setMap.put("Identifier", docIdentifier);
			setMap.put("ItemID", ItemID);
			if (itemTypeCode.equals("")) {
				itemTypeCode = this.commonService.selectString("item_SQL.selectedItemTypeCode", setMap);
			}
			setMap.put("ItemTypeCode", itemTypeCode);

			setMap.put("AuthorID", StringUtil.checkNull(commandMap.get("sessionUserId")));
			setMap.put("IsPublic", StringUtil.checkNull(request.getParameter("IsPublic")));
			setMap.put("ProjectID", projectID);
			setMap.put("RefItemID", StringUtil.checkNull(request.getParameter("refItemID")));
			setMap.put("Status", "NEW1");

			setMap.put("itemId", StringUtil.checkNull(request.getParameter("s_itemID")));

			this.commonService.insert("item_SQL.insertItem", setMap);
			setMap.remove("CurChangeSet");

			/* 속성 로직추가 수정 start */

			Map<String, String> attrTypeCodes = new HashMap<>();
			attrTypeCodes.put("AT00001", "AT00001"); // 문서명
			attrTypeCodes.put("ZAT01010", "ZAT01010");// 관리 site
			attrTypeCodes.put("ZAT01020", "ZAT01020"); // 문서등급
			attrTypeCodes.put("ZAT02022", "ZAT02022"); // 상세영역
			attrTypeCodes.put("ZAT01030", "ZAT01030"); // 영역
			attrTypeCodes.put("ZAT01040", "ZAT01040"); // 문서분야
			attrTypeCodes.put("ZAT01060", "ZAT01060"); // 문서타입
			attrTypeCodes.put("ZAT01050", "ZAT01050"); // 공정
			attrTypeCodes.put("ZAT01051", "ZAT01051"); // 상세공정
			attrTypeCodes.put("AT00003", "AT00003"); // 개요
			attrTypeCodes.put("AT01007", "AT01007"); // 키워드
			attrTypeCodes.put("AT00040", "AT00040"); // NCT 대상여부
			attrTypeCodes.put("ZAT01080", "ZAT01080");// 채번 site정보
			attrTypeCodes.put("ZAT01090", "ZAT01090"); // NCT 수출입 신고여부 

			for (Map.Entry<String, String> entry : attrTypeCodes.entrySet()) {
				String attrTypeCode = entry.getKey(); //
				String formField = entry.getValue(); //

				String formValue = StringUtil.checkNull(request.getParameter(formField)); //

				setMap.put("PlainText", formValue);

				setMap.put("AttrTypeCode", attrTypeCode); //
				if (!attrTypeCode.equals("AT00001") && !attrTypeCode.equals("AT00003")&& !attrTypeCode.equals("AT01007")) {
					setMap.put("LovCode", formValue);
				}

				List getLanguageList = this.commonService.selectList("common_SQL.langType_commonSelect", setMap);
				for (int i = 0; i < getLanguageList.size(); i++) {
					Map getMap = (HashMap) getLanguageList.get(i);

					setMap.put("languageID", getMap.get("CODE"));
					this.commonService.insert("item_SQL.ItemAttr", setMap);
				}
			}

			/* end */

			/** 채번 Update start **/
			if (docIdentifier.equals("")) { // 문서 채번이 안되있는경우
				// setMap.put("ItemID",ItemID);
				// setMap.put("ClassCode", classCode);
				setMap.put("languageID", request.getParameter("languageID"));
				String newDocIdenfier = StringUtil
						.checkNull(this.commonService.selectString("zSK_SQL.fn_createItemIdentifier", setMap));
				setMap.put("docIdentifier", newDocIdenfier);
				// String docNum = commonService.selectString("zSK_SQL.getMaxIdentifier",
				// setMap);
				docIdentifier = newDocIdenfier;
				setMap.put("Identifier", docIdentifier);
				this.commonService.update("item_SQL.updateItemObjectInfo", setMap);
			}

			/** 채번 Update end **/

			if (((!cpItemID.equals("")) && (mstSTR.equals("Y"))) || (cpItemID.equals(""))) {
				setMap.put("CategoryCode", "ST1");
				setMap.put("ClassCode", "NL00000");
				setMap.put("ToItemID", setMap.get("ItemID"));
				if (fromItemID.equals("")) {
					s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
					setMap.put("s_itemID", s_itemID);
				} else {
					setMap.put("FromItemID", fromItemID);
				}
				setMap.put("ItemID", this.commonService.selectString("item_SQL.getItemMaxID", setMap));

				setMap.remove("RefItemID");
				setMap.remove("Identifier");
				setMap.put("ItemTypeCode", this.commonService.selectString("item_SQL.selectedConItemTypeCode", setMap));
				this.commonService.insert("item_SQL.insertItem", setMap);
			}

			setMap.put("ItemID", ItemID);
			String changeMgt = StringUtil
					.checkNull(this.commonService.selectString("project_SQL.getChangeMgt", setMap));
			if (changeMgt.equals("1")) {
				insertCngMap.put("itemID", ItemID);
				insertCngMap.put("userId", StringUtil.checkNull(commandMap.get("sessionUserId")));
				insertCngMap.put("projectID", projectID);
				insertCngMap.put("classCode", itemClassCode);
				insertCngMap.put("KBN", "insertCNG");
				insertCngMap.put("Reason", StringUtil.checkNull(commandMap.get("Reason")));
				insertCngMap.put("Description", StringUtil.checkNull(commandMap.get("Description")));
				insertCngMap.put("status", "MOD");
				insertCngMap.put("version", "0");
				this.CSService.save(new ArrayList(), insertCngMap);
			} else if (!changeMgt.equals("1")) {
				setMap.put("itemID", s_itemID);
				String sItemIDCurChangeSetID = StringUtil
						.checkNull(this.commonService.selectString("project_SQL.getCurChangeSetIDFromItem", setMap));
				if (!sItemIDCurChangeSetID.equals("")) {
					updateData = new HashMap();
					updateData.put("CurChangeSet", sItemIDCurChangeSetID);
					updateData.put("s_itemID", ItemID);
					this.commonService.update("project_SQL.updateItemStatus", updateData);
				}

			}

			// Dimension
			String dimTypeID = StringUtil.checkNull("100001");
			String dimTypeValueID = StringUtil.checkNull(request.getParameter("siteCodes"));
			if ((!dimTypeID.equals("")) && (!dimTypeValueID.equals(""))) {
				String[] temp = dimTypeValueID.split(",");
				Map setData = new HashMap();

				for (int i = 0; i < temp.length; i++) {
					setData.put("ItemTypeCode", itemTypeCode);
					setData.put("ItemClassCode", itemClassCode);
					setData.put("ItemID", ItemID);
					setData.put("DimTypeID", dimTypeID);
					setData.put("DimValueID", temp[i]);
					this.commonService.update("dim_SQL.insertItemDim", setData);
				}
			}

			HashMap insertData = new HashMap();

			String[] teamIDs = StringUtil.checkNull(request.getParameter("orgTeamIDs")).split(",");

			insertData.put("itemID", ItemID);
			insertData.put("teamRoleType", "REL");
			insertData.put("assigned", "1");
			insertData.put("creator", commandMap.get("sessionUserId"));
			insertData.put("teamRoleCat", "TEAMROLETP");
			List teamRoleList = new ArrayList();
			for (int i = 0; i < teamIDs.length; i++) {
				if ((!"".equals(teamIDs[i])) && (!"0".equals(teamIDs[i]))) {
					insertData.put("teamID", teamIDs[i]);
					teamRoleList = this.commonService.selectList("role_SQL.getTeamRoleIDList", insertData);
					if (teamRoleList.size() == 0) {
						this.commonService.insert("role_SQL.insertTeamRole", insertData);
					}
				}
			}

			/****************************** 첨부파일 등록 ******************************/
			String docCategory = "ITM";
			String fltpCode = "FLTP009";

			String errorMessage = MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068");
			String fileID = StringUtil.checkNull(commandMap.get("fileID"), "");
			commandMap.put("itemId", ItemID);
			commandMap.put("itemID", ItemID);

			Map result = fileMgtService.select("fileMgt_SQL.selectItemAuthorID", commandMap);

			String itemFileOption = fileMgtService.selectString("fileMgt_SQL.getFileOption", commandMap);
			commandMap.put("Status", StringUtil.checkNull(result.get("Status")));
			
			String changeSetID = StringUtil
					.checkNull(commonService.selectString("project_SQL.getCurChangeSetIDFromItem", commandMap));
			
			// file upload 공통 사용
			List fileList = new ArrayList();
			Map fileMap = null;
			Map stusMap = new HashMap();
			
			//Read Server File
			commandMap.put("DocumentID", ItemID);
			commandMap.put("FltpCode", fltpCode);
			commandMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
			commandMap.put("DocCategory", docCategory);
			commandMap.put("fileID", fileID);
			commandMap.put("ChangeSetID", changeSetID);
			
			String KBN = "insert";
			if(!"".equals(fileID)) KBN = "update";
			commandMap.put("KBN", KBN);
			
			Map fileUploadMap = new HashMap();
			fileUploadMap = fileUploadUtil.fileUpload(commandMap, request);
			
			boolean fileUploadResult = (boolean) fileUploadMap.getOrDefault("result",false);
			if(!fileUploadResult) {
				errorMessage = StringUtil.checkNull(fileUploadMap.get("message"),"파일 업로드 실패");
				throw new Exception(errorMessage);
			}
			/****************************** 첨부파일 등록 ******************************/

			target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));

			target.put(AJAX_SCRIPT, "parent.fnEditItemInfo(" + ItemID
					+ ");parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put("SCRIPT", "this.$('#isSubmit').remove()");
			target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
		}

		return target;
	}

	public HashMap zsk_DeleteItemFunction(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws Exception {
		HashMap target = new HashMap();
		try {
			String itemId = StringUtil.checkNull(request.getParameter("s_itemID"));
			String Description = StringUtil.checkNull(request.getParameter("Description"));
			String Reason = StringUtil.checkNull(request.getParameter("Reason"));

			Map setValue = new HashMap();
			setValue.put("ItemID", itemId);
			setValue.put("Status", "DEL1");
			this.commonService.update("item_SQL.updateItemObjectInfo", setValue);

			setValue.put("s_itemID", itemId);
			String changeSetID = StringUtil
					.checkNull(this.commonService.selectString("item_SQL.getItemCurChangeSet", setValue));

			setValue.put("s_itemID", changeSetID);
			setValue.put("Description", Description);
			setValue.put("Reason", Reason);
			setValue.put("ChangeType", "DEL");
			this.commonService.update("cs_SQL.updateChangeSet", setValue);

			target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
			target.put("SCRIPT", "parent.fnEditCallBack()");
		} catch (Exception e) {
			System.out.println(e);
			target.put("SCRIPT", "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
		}
		return target;
	}

	public HashMap zsk_UpdateItemFunction(HttpServletRequest request, HashMap commandMap, ModelMap model,
			String extraParam) throws Exception {
		HashMap target = new HashMap();
		Map updateMap = new HashMap();
		try {
			String setInfo = "";
			String itemId = StringUtil.checkNull(request.getParameter("s_itemID"));
			String option = StringUtil.checkNull(request.getParameter("option"));
			// String identifier = StringUtil.checkNull(request.getParameter("Identifier"));
			String Description = StringUtil.checkNull(request.getParameter("Description"));
			String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"));
			String itemClassCode = StringUtil.checkNull(request.getParameter("itemClassCode"));
			String Reason = StringUtil.checkNull(request.getParameter("Reason"));
			String plantYN = "N";
			String defDimValueID = StringUtil.checkNull(request.getParameter("defDimValueID"));
			String curChangeSet = StringUtil.checkNull(request.getParameter("curChangeSet"));
			String updateOnly = StringUtil.checkNull(request.getParameter("updateOnly"));
			model.put("defDimValueID", defDimValueID);
			Map setValue = new HashMap();
			setValue.put("ItemID", itemId);
			setValue.put("updateOnly", updateOnly);
			// setValue.put("Identifier", identifier);

			String itemCount = "0";

			String languageID = request.getParameter("languageID");

			// cs 업데이트
			updateMap.put("changeSetID", curChangeSet); // changeSetID
			updateMap.put("Description", Description);
			commonService.update("cs_SQL.updateChangeSetDescription", updateMap);

			// identifier =identifier;
			if (!itemCount.equals("0")) {
				setValue.put("languageID", request.getParameter("languageID"));

	
				target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00081",
						new String[] { this.commonService.selectString("attr_SQL.getEqualIdentifierInfo", setValue) }));
				target.put("SCRIPT", "parent.$('#isSubmit').remove();");
			} else {
				setValue.put("languageID", request.getParameter("languageID"));
			
				setValue.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
				setValue.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));

				// 속성 업데이트
	
				String attrTypeCodesParam = request.getParameter("attrTypeCodes"); 
				List<String> attrCodes = new ArrayList<>();
				if (attrTypeCodesParam != null && !attrTypeCodesParam.isEmpty()) {
				    attrCodes = Arrays.asList(attrTypeCodesParam.split(",")); 
				}
				
				for (String code : attrCodes) {
				    if (code.contains(":")) {
				        String[] parts = code.split(":");
				        String typeCode = parts[0];
				        String[] values = parts[1].split("\\$\\$"); 
				        
				        for (String val : values) {
				        	setValue.put("AttrTypeCode", typeCode);
				        	commonService.delete("attr_SQL.delItemAttr", setValue);
				        }
				        for (String val : values) {
				            setValue.put("AttrTypeCode", typeCode);
				            setValue.put("LovCode", val);
				            setValue.put("PlainText", val);    
				            setInfo = GetItemAttrList.attrUpdate(this.commonService, setValue);
				        }
				        continue; 
				    }
				    String value = StringUtil.checkNull(request.getParameter(code)," ");
				    if (!value.isEmpty()) {
				        setValue.put("AttrTypeCode", code);
				        setValue.put("PlainText", value);

				        if ("ZAT01040".equals(code) || "ZAT01030".equals(code)|| "ZAT01051".equals(code) ||"ZAT01050".equals(code) || "ZAT01060".equals(code)||"AT00040".equals(code)||"ZAT01090".equals(code)
				        		|| "ZAT03011".equals(code)||"ZAT03130".equals(code)||"ZAT03131".equals(code)||"ZAT03132".equals(code)||"ZAT03133".equals(code) || "ZAT04003".equals(code) || "ZAT04006".equals(code)) { // 개발서버와 소스 동기화
				            setValue.put("LovCode", value);
				        } else {
				            setValue.remove("LovCode"); 
				        }

				        setInfo = GetItemAttrList.attrUpdate(this.commonService, setValue);
				    }
				}


				setValue.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
				setValue.put("CompanyID", StringUtil.checkNull(request.getParameter("companyCode")));
				setValue.put("OwnerTeamID", StringUtil.checkNull(request.getParameter("ownerTeamCode")));
				setValue.put("Version", StringUtil.checkNull(request.getParameter("Version")));
				setValue.put("AuthorID", StringUtil.checkNull(request.getParameter("AuthorID")));
				setValue.put("LastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));

			
				this.commonService.update("item_SQL.updateItemObjectInfo", setValue);

				List returnData = new ArrayList();

				commandMap.put("Editable", "1");
				returnData = this.commonService.selectList("attr_SQL.getItemAttr", commandMap);

				Map setMap = new HashMap();
				String dataType = "";
				String mLovValue = "";
				String html = "";
				String docLevel = "";
				for (int i = 0; i < returnData.size(); i++) {
					setMap = (HashMap) returnData.get(i);
					dataType = StringUtil.checkNull(setMap.get("DataType"));
					html = StringUtil.checkNull(setMap.get("HTML"));
					if (!dataType.equals("Text")) {
						if (dataType.equals("MLOV")) {
							
						}
						else if (dataType.equals("LOV")) {

							docLevel = request.getParameter("ZAT01020");

						} else {
							Map delData = new HashMap();

							setMap.put("PlainText",
									StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode").toString()), ""));
							setMap.put("ItemID", StringUtil.checkNull(request.getParameter("s_itemID")));
							setMap.put("languageID", commandMap.get("sessionDefLanguageId"));
							setMap.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
							setMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
							setMap.put("LovCode",
									StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode").toString()), ""));
							setInfo = GetItemAttrList.attrUpdate(this.commonService, setMap);
						}
					} else {
						String plainText = StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode")), "");
						if (html.equals("1")) {
							plainText = StringEscapeUtils.escapeHtml4(plainText);
						}
						setMap.put("PlainText", plainText);
						setMap.put("ItemID", StringUtil.checkNull(request.getParameter("s_itemID")));
						setMap.put("languageID", request.getParameter("languageID"));
						setMap.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
						setMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
						setMap.put("LovCode", StringUtil
								.checkNull(this.commonService.selectString("attr_SQL.selectAttrLovCode", setMap), ""));

						setMap.put("updateOnly", updateOnly);
						if (updateOnly.equals("Y")) {
							if (request.getParameter(StringUtil.checkNull(setMap.get("AttrTypeCode"))) != null) {
								List getLanguageList = this.commonService.selectList("common_SQL.langType_commonSelect", setValue);
								for (int j = 0; j < getLanguageList.size(); j++) {
									Map getMap = (HashMap) getLanguageList.get(j);

									setMap.put("languageID", getMap.get("CODE"));
									
									setInfo = GetItemAttrList.attrUpdate(this.commonService, setMap);
								}
							}

						} else {
							List getLanguageList = this.commonService.selectList("common_SQL.langType_commonSelect", setValue);
							for (int j = 0; j < getLanguageList.size(); j++) {
								Map getMap = (HashMap) getLanguageList.get(j);

								setMap.put("languageID", getMap.get("CODE"));
								
								setInfo = GetItemAttrList.attrUpdate(this.commonService, setMap);
							}
						
						}

					}
				}
				setMap.put("s_itemID", itemId);
				String changeSetID = StringUtil
						.checkNull(this.commonService.selectString("item_SQL.getItemCurChangeSet", setMap));
				setMap.put("s_itemID", changeSetID);
				setMap.put("Description", Description);
				setMap.put("Reason", Reason);
				this.commonService.update("cs_SQL.updateChangeSet", setMap);
				/** dimension **/

				String dimTypeID = StringUtil.checkNull("100001");
				String dimTypeValueID = StringUtil.checkNull(request.getParameter("siteCodes"));
				if ((!dimTypeID.equals("")) && (!dimTypeValueID.equals(""))) {
					String[] temp = dimTypeValueID.split(",");
					Map setData = new HashMap();
					setData.put("s_itemID", itemId);
					setData.put("DimTypeID", dimTypeID);
					this.commonService.update("dim_SQL.delSubDimValue", setData);

					for (int i = 0; i < temp.length; i++) {

						setData.put("ItemID", itemId);
						setData.put("DimTypeID", dimTypeID);
						setData.put("DimValueID", temp[i]);
						if (!temp[i].equals("") && !temp[i].equals(" ")) {
							this.commonService.update("dim_SQL.insertItemDim", setData);
						}
					}
				}

				/****************************** 첨부파일 등록 ******************************/
				String errorMessage = MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068");
				String docCategory = "ITM";
				String fileID = StringUtil.checkNull(commandMap.get("fileID"), "");
				String fltpCode = StringUtil.checkNull(request.getParameter("fltpCode"));
				commandMap.put("itemId", itemId);
				commandMap.put("itemID", itemId);

				Map result = fileMgtService.select("fileMgt_SQL.selectItemAuthorID", commandMap);

				String itemFileOption = fileMgtService.selectString("fileMgt_SQL.getFileOption", commandMap);
				commandMap.put("Status", StringUtil.checkNull(result.get("Status")));
				
				// file upload 공통 사용
				List fileList = new ArrayList();
				Map fileMap = null;
				Map stusMap = new HashMap();
				
				//Read Server File
				commandMap.put("DocumentID", itemId);
				commandMap.put("FltpCode", fltpCode);
				commandMap.put("ChangeSetID", changeSetID);
				commandMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
				commandMap.put("DocCategory", docCategory);
				commandMap.put("fileID", fileID);
				
				String KBN = "insert";
				if(!"".equals(fileID)) KBN = "update";
				commandMap.put("KBN", KBN);
				
				Map fileUploadMap = new HashMap();
				fileUploadMap = fileUploadUtil.fileUpload(commandMap, request);
				
				boolean fileUploadResult = (boolean) fileUploadMap.getOrDefault("result",false);
				if(!fileUploadResult) {
					errorMessage = StringUtil.checkNull(fileUploadMap.get("message"),"파일 업로드 실패");
					throw new Exception(errorMessage);
				}
				
				
				/****************************** 첨부파일 등록 ******************************/

				model.put("s_itemID", itemId);
				target.put("SCRIPT", "parent.fnCllbackEdit('" + itemId + "')");
				if ("Y".equalsIgnoreCase(extraParam)) {
					target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
				}
			}
		} catch (Exception e) {
			System.out.println(e);
			target.put("SCRIPT", "parent.$('#isSubmit').remove();");
			target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
		}
		return (HashMap) target;
	}

	@RequestMapping(value = "/zSKON_searchTsdItemList.do")
	public String zSKON_searchTsdItemList(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws Exception {
		String url = StringUtil.checkNull(request.getParameter("url"), "/itm/structure/searchSubItemList");

		try {
			Map setMap = new HashMap();

			// menucat 파라메터가 설정되어서 본 이벤트를 호출 하는 경우 : 아이템 트리의 하위항목
			String s_itemID = StringUtil.checkNull(request.getParameter("itemID"));
			String isNothingLowLank = "";
			String screenType = StringUtil.checkNull(request.getParameter("screenType"));
			String accMode = StringUtil.checkNull(commandMap.get("accMode"), "OPS");
			String childItems = "";
			String screenOption = StringUtil.checkNull(request.getParameter("screenOption"));
			String ArcCode = StringUtil.checkNull(request.getParameter("ArcCode"));

			if (s_itemID.equals(""))
				s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));

			setMap.put("s_itemID", s_itemID);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));

			// 선택된 아이템의 하위항목을 모두 취득
			childItems = zSKON_getChildItemList(s_itemID);
			if (childItems.isEmpty()) {
				isNothingLowLank = "Y";
			}
			model.put("s_itemID", s_itemID);
			model.put("option", StringUtil.checkNull(request.getParameter("option")));
			model.put("pop", StringUtil.checkNull(request.getParameter("pop")));

			// [ClassCode] List 취득, 해당 아이템 하위의 classcode리스트를 설정
			Map selectedItemInfoMap = commonService.select("project_SQL.getItemInfo", setMap);
			String itemTypeCode = StringUtil.checkNull(selectedItemInfoMap.get("ItemTypeCode"));
			String classCode = StringUtil.checkNull(selectedItemInfoMap.get("ClassCode"));

			setMap.put("ItemTypeCode", itemTypeCode);
			setMap.put("ItemClassCode", classCode);
			List classCodeList = commonService.selectList("search_SQL.getLowlankClassCodeList", setMap);

			// Login user editor 권한 추가
//			String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev")); // 시스템 관리자
//			Map itemAuthorMap = commonService.select("project_SQL.getItemAuthorIDAndLockOwner", setMap);
//			if (StringUtil.checkNull(itemAuthorMap.get("AuthorID")).equals(commandMap.get("sessionUserId")) 
//					|| StringUtil.checkNull(itemAuthorMap.get("LockOwner")).equals(commandMap.get("sessionUserId"))
//					|| "1".equals(sessionAuthLev)) {
//				model.put("myItem", "Y");
//			}

			String myItem = commonService.selectString("item_SQL.checkMyItem", commandMap);
			model.put("myItem", myItem);

			commandMap.put("Category", "ITMSTS");
			List statusList = commonService.selectList("common_SQL.getDicWord_commonSelect", commandMap);
			model.put("statusList", statusList);
			commandMap.put("Deactivated", "1");

			/** DimTypeId List */
			List dimTypeList = commonService.selectList("dim_SQL.getDimTypeList", commandMap);
			model.put("dimTypeList", dimTypeList);

			/** 법인 List */
			setMap.put("TeamType", "2");
			List companyOptionList = commonService.selectList("organization_SQL.getTeamList", setMap);
			model.put("companyOption", companyOptionList);

			/** Symbol List */
			List symbolCodeList = commonService.selectList("search_SQL.getSymbolCodeList", setMap);
			model.put("symbolCodeList", symbolCodeList);

			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", commandMap);

			if (screenType.equals("main")) {
				model.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("itemTypeCode")));
				model.put("classCode", StringUtil.checkNull(request.getParameter("classCode")));
				model.put("AttrCode", StringUtil.checkNull(request.getParameter("searchKey")));
				model.put("searchValue", StringUtil.checkNull(request.getParameter("searchValue")));
				model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
				model.put("searchTeamName", StringUtil.checkNull(request.getParameter("searchTeamName")));
				model.put("searchAuthorName", StringUtil.checkNull(request.getParameter("searchAuthorName")));
			}

			// 속성 검색
			setMap.put("defaultLang", defaultLang);
			List attrList = commonService.selectList("attr_SQL.getItemAttr", setMap);

			String defItemTypeCode = StringUtil.checkNull(request.getParameter("defItemTypeCode"));
			String defClassCode = StringUtil.checkNull(request.getParameter("defClassCode"));
			String defCompany = StringUtil.checkNull(request.getParameter("defCompany"));
			String defOwnerTeam = StringUtil.checkNull(request.getParameter("defOwnerTeam"));
			String defAuthor = StringUtil.checkNull(request.getParameter("defAuthorName"));
			String defDimTypeID = StringUtil.checkNull(request.getParameter("defDimTypeID"));
			String defDimValueID = StringUtil.checkNull(request.getParameter("defDimValueID"));

			String fixedDimValueID = StringUtil.checkNull(request.getParameter("fixedDimValueID"));
			String defAttrTypeCode = StringUtil.checkNull(request.getParameter("defAttrTypeCode"));
			String defAttrTypeValue = StringUtil.checkNull(request.getParameter("defAttrTypeValue"));
			String defStatus = StringUtil.checkNull(request.getParameter("defStatus"));
			setMap.put("attrTypeCode", defAttrTypeCode);
			String defAttrTypeName = commonService.selectString("report_SQL.getAttrName", setMap);
			String itemInfoRptUrl = StringUtil.checkNull(request.getParameter("itemInfoRptUrl"));

			setMap.put("typeCode", itemTypeCode);
			setMap.put("category", "OJ");
			String itemTypeName = StringUtil.checkNull(commonService.selectString("common_SQL.getNameFromDic", setMap));
			String selectedItemPath = StringUtil.checkNull(commonService.selectString("item_SQL.getItemPath", setMap));

			model.put("itemTypeName", itemTypeName);
			model.put("selectedItemPath", selectedItemPath);
			model.put("defAttrTypeName", defAttrTypeName);
			model.put("defItemTypeCode", defItemTypeCode);
			model.put("defClassCode", defClassCode);
			model.put("defCompany", defCompany);
			model.put("defOwnerTeam", defOwnerTeam);
			model.put("defAuthor", defAuthor);
			model.put("defDimTypeID", defDimTypeID);
			model.put("defDimValueID", defDimValueID);
			model.put("fixedDimValueID", fixedDimValueID);
			model.put("defAttrTypeCode", defAttrTypeCode);
			model.put("defAttrTypeValue", defAttrTypeValue);
			model.put("defStatus", defStatus);
			model.put("itemInfoRptUrl", itemInfoRptUrl);

			model.put("isNothingLowLank", isNothingLowLank);
			model.put("defaultLang", defaultLang);
			model.put("childItems", childItems);
			model.put("menu", getLabel(request, commonService));
			model.put("idExist", StringUtil.checkNull(request.getParameter("idExist")));
			model.put("ownerType", StringUtil.checkNull(request.getParameter("ownerType")));
			model.put("showTOJ", StringUtil.checkNull(request.getParameter("showTOJ")));
			model.put("accMode", accMode);
			model.put("screenOption", screenOption);
			String L1ItemID = commonService.selectString("item_SQL.getL1ItemID", setMap);
			setMap.put("itemID", L1ItemID);
			setMap.put("attrTypeCode", "AT00001");
			String L1ItemName = commonService.selectString("item_SQL.getItemAttrPlainText", setMap);
			model.put("L1ItemName", L1ItemName);
			model.put("s_ClassCode", classCode);
			model.put("attrList", attrList);

			setMap.put("itemID", s_itemID);
			setMap.put("attrTypeCode", "AT00001");
			String itemName = commonService.selectString("item_SQL.getItemAttrPlainText", setMap);
			model.put("itemName", itemName);

			List itemPath = new ArrayList();
			itemPath = getRootItemPath(s_itemID, StringUtil.checkNull(commandMap.get("sessionCurrLangType")), itemPath);
			Collections.reverse(itemPath);
			model.put("itemPath", itemPath);
		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl(url);
	}

	/**
	 * Item Path 조회
	 * 
	 * @param setMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public List getRootItemPath(String itemID, String languageID, List itemPath) throws Exception {
		System.out.println("getRootItemPath");
		Map setMap = new HashMap();
		setMap.put("itemID", itemID);
		String ParentItemID = StringUtil.checkNull(commonService.selectString("item_SQL.getParentItemID", setMap), "0");

		if (Integer.parseInt(ParentItemID) != 0 && Integer.parseInt(ParentItemID) > 100) {
			setMap.put("ItemID", ParentItemID);
			setMap.put("languageID", languageID);
			setMap.put("attrTypeCode", "AT00001");
			Map temp = commonService.select("attr_SQL.getItemAttrText", setMap);
			temp.put("itemID", ParentItemID);
			itemPath.add(temp);
			getRootItemPath(ParentItemID, languageID, itemPath);
		}

		return itemPath;
	}

	private String zSKON_getChildItemList(String s_itemID) throws ExceptionUtil {
		String outPutItems = "";
		List itemIdList = new ArrayList();
		List list = new ArrayList();
		Map map = new HashMap();
		Map setMap = new HashMap();
		try {
			String itemId = s_itemID;
			setMap.put("ItemID", itemId);
			// delItemIdList.add(itemId);

			// 취득한 아이템 리스트 사이즈가 0이면 while문을 빠져나간다.
			int j = 1;
			while (j != 0) {
				String toItemId = "";

				setMap.put("CURRENT_ITEM", itemId); // 해당 아이템이 [FromItemID]인것
				setMap.put("CategoryCode", "ST1");
				// setMap.put("CategoryCodes", "'ST1','ST2'");
				list = commonService.selectList("report_SQL.getChildItems", setMap);
				j = list.size();
				for (int k = 0; list.size() > k; k++) {
					map = (Map) list.get(k);
					setMap.put("ItemID", map.get("ToItemID"));
					itemIdList.add(map.get("ToItemID"));

					if (k == 0) {
						toItemId = "'" + String.valueOf(map.get("ToItemID")) + "'";
					} else {
						toItemId = toItemId + ",'" + String.valueOf(map.get("ToItemID")) + "'";
					}
				}

				itemId = toItemId; // ToItemID를 다음 ItemID로 설정
			}

			outPutItems = "";
			for (int i = 0; itemIdList.size() > i; i++) {

				if (outPutItems.isEmpty()) {
					outPutItems += itemIdList.get(i);
				} else {
					outPutItems += "," + itemIdList.get(i);
				}
			}
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}

		return outPutItems;
	}

	@RequestMapping(value = "/apiTest.do")
	public JSONObject apiTest(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		JSONObject result = new JSONObject();
		try {
			String a = "bar";
			String b = "foo";
			String c = "1";
			String ccList = "\"abc@abc.com\", \"sdf@sdf.com\"";
			String body = "{\"body\":\"" + a + "\",\"body\":\"" + b + "\",\"userId\" : " + c + ",\"cc\": [" + ccList
					+ "]}";
			URL url = new URL("https://jsonplaceholder.typicode.com/posts");
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type", "application/json");
			conn.setRequestProperty("Accept", "application/json");
			conn.setDoOutput(true);
			conn.setDoInput(true);
			// Redirect처리 하지 않음
			conn.setInstanceFollowRedirects(false);

			// Request Body에 Data를 담기위해 OutputStream 객체를 생성.
			OutputStream os = conn.getOutputStream();
			// Request Body에 Data 셋팅.
			byte request_data[] = body.getBytes("utf-8");
			os.write(request_data);
			os.flush();
			os.close();

			int responseCode = conn.getResponseCode();
			System.out.println("responseCode == " + responseCode);
			if (responseCode == 400) {
				System.out.println("400:: 해당 명령을 실행할 수 없음 ");
			} else if (responseCode == 401) {
				System.out.println("401:: X-Auth-Token Header가 잘못됨");
			} else if (responseCode == 500) {
				System.out.println("500:: 서버 에러, 문의 필요");
			} else if (responseCode == conn.HTTP_OK || responseCode == 201) {
				BufferedReader br = null;
				String line = "";
				StringBuilder sb = new StringBuilder();

				try {
					br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
					while ((line = br.readLine()) != null) {
						sb.append(line);
					}
				} catch (Exception e) {
					System.out.println(e.toString());
					throw e;
				} finally {
					br.close();
				}

				line = sb.toString();
				System.out.println("=== line == " + line);

				JSONParser parser = new JSONParser();
				Object obj = parser.parse(line);
				result = (JSONObject) obj;
				System.out.println("=== result == " + result);
			}
		} catch (IOException e) {
			System.out.println("IOException " + e.getCause());
			e.printStackTrace();
		} catch (Exception e) {
			System.out.println("Exception " + e.getCause());
			e.printStackTrace();
		}
		return result;
	}

	@RequestMapping(value = "/zSKON_E2EActivityTreeMgt.do")
	public String zSKON_E2EActivityTreeMgt(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws Exception {
		model.put("s_itemID", commandMap.get("s_itemID"));
		model.put("menu", getLabel(request, commonService)); /* Label Setting */

		commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
		String s_itemID = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("s_itemID"), ""));

		model.put("s_itemID", s_itemID);

		List<Map<String, Object>> subItemList = commonService.selectList("zSK_SQL.getE2EActvityList_gridList",
				commandMap);

		JSONArray gridData = new JSONArray();
		for (Map<String, Object> item : subItemList) {
			JSONObject row = new JSONObject();
			String itemID = item.get("ItemID") == null ? "" : item.get("ItemID").toString();
			String parentItemID = item.get("ParentItemID") == null ? null : item.get("ParentItemID").toString();
			String selectedItemID = s_itemID;

			if (itemID.equals(selectedItemID)) {
				row.put("parent", null);
			} else {
				row.put("parent", parentItemID);
			}
			row.put("id", itemID);
			row.put("ClassCode", item.get("ClassCode"));
			row.put("Identifier", item.get("Identifier"));
			row.put("Activity", item.get("Activity"));
			row.put("ApplicationCategory", item.get("ApplicationCategory"));
			row.put("Period", item.get("Period"));
			row.put("Input", item.get("Input"));
			row.put("Responsible_Input", item.get("Responsible_Input"));
			row.put("Output", item.get("Output"));
			row.put("Responsible_Output", item.get("Responsible_Output"));

			Integer height = 30;
			String split = "\\$\\$ ";

			// 선행
			String preIdentifiers[] = StringUtil.checkNull(item.get("pre_Identifier")).split(split);
			String preItemIDs[] = StringUtil.checkNull(item.get("pre_ItemID")).split(split);
			String preIdentifier = "<ul style='height:100%;align-content: center;'>";
			for (int i = 0; i < preIdentifiers.length; i++) {
				preIdentifier += "<li onclick='doDetail(" + preItemIDs[i] + ")' class='link'>" + preIdentifiers[i]
						+ "</li>";
				if (i > 0 && height < 20 * (i + 1))
					height = 20 * (i + 1);
			}
			preIdentifier += "</ul>";
			row.put("pre_Identifier", preIdentifier);

			// 후행
			String laterIdentifiers[] = StringUtil.checkNull(item.get("later_Identifier")).split(split);
			String laterItemIDs[] = StringUtil.checkNull(item.get("later_ItemID")).split(split);
			String laterIdentifier = "<ul style='height:100%;align-content: center;'>";
			for (int i = 0; i < laterIdentifiers.length; i++) {
				laterIdentifier += "<li onclick='doDetail(" + laterItemIDs[i] + ")' class='link'>" + laterIdentifiers[i]
						+ "</li>";
				if (i > 0 && height < 20 * (i + 1))
					height = 20 * (i + 1);
			}
			laterIdentifier += "</ul>";
			row.put("later_Identifier", laterIdentifier);

			// R
			String r_texts[] = StringUtil.checkNull(item.get("r_text")).split(split);
			String r_ItemIDs[] = StringUtil.checkNull(item.get("r_ItemID")).split(split);
			String r_text = "<ul style='height:100%;align-content: center;'>";
			for (int i = 0; i < r_texts.length; i++) {
				r_text += "<li onclick='doDetail(" + r_ItemIDs[i] + ")' class='link'>" + r_texts[i] + "</li>";
				if (i > 0 && height < 20 * (i + 1))
					height = 20 * (i + 1);
			}
			r_text += "</ul>";
			row.put("r_text", r_text);

			// A
			String a_texts[] = StringUtil.checkNull(item.get("a_text")).split(split);
			String a_ItemIDs[] = StringUtil.checkNull(item.get("a_ItemID")).split(split);
			String a_text = "<ul style='height:100%;align-content: center;'>";
			for (int i = 0; i < a_texts.length; i++) {
				a_text += "<li onclick='doDetail(" + a_ItemIDs[i] + ")' class='link'>" + a_texts[i] + "</li>";
				if (i > 0 && height < 20 * (i + 1))
					height = 20 * (i + 1);
			}
			a_text += "</ul>";
			row.put("a_text", a_text);

			// S
			String s_texts[] = StringUtil.checkNull(item.get("s_text")).split(split);
			String s_ItemIDs[] = StringUtil.checkNull(item.get("s_ItemID")).split(split);
			String s_text = "<ul style='height:100%;align-content: center;'>";
			for (int i = 0; i < s_texts.length; i++) {
				s_text += "<li onclick='doDetail(" + s_ItemIDs[i] + ")' class='link'>" + s_texts[i] + "</li>";
				if (i > 0 && height < 20 * (i + 1))//<< 이런식으로 li마다 기본 높이값 늘리고 (40은 너무 긺) // 개발서버와 소스 동기화
					height = 20 * (i + 1);
			}
			s_text += "</ul>";
			row.put("s_text", s_text);

			// I
			String i_texts[] = StringUtil.checkNull(item.get("i_text")).split(split);
			String i_ItemIDs[] = StringUtil.checkNull(item.get("i_ItemID")).split(split);
			String i_text = "<ul style='height:100%;align-content: center;'>";
			for (int i = 0; i < i_texts.length; i++) {
				i_text += "<li onclick='doDetail(" + i_ItemIDs[i] + ")' class='link'>" + i_texts[i] + "</li>";
				if (i > 0 && height < 20 * (i + 1))
					height = 20 * (i + 1);
			}
			i_text += "</ul>";
			row.put("i_text", i_text);

			// C
			String c_texts[] = StringUtil.checkNull(item.get("c_text")).split(split);
			String c_ItemIDs[] = StringUtil.checkNull(item.get("c_ItemID")).split(split);
			String c_text = "<ul style='height:100%;align-content: center;'>";
			for (int i = 0; i < c_texts.length; i++) {
				c_text += "<li onclick='doDetail(" + c_ItemIDs[i] + ")' class='link'>" + c_texts[i] + "</li>";
				if (i > 0 && height < 20 * (i + 1))
					height = 20 * (i + 1);
			}
			c_text += "</ul>";
			row.put("c_text", c_text);

			// 관련 상세절차서
			String prcTexts[] = StringUtil.checkNull(item.get("prc_text")).split(split);
			String prcItems[] = StringUtil.checkNull(item.get("prc_ItemID")).split(split);
			String prcText = "<ul style='height:100%;align-content: center;'>";

			for (int i = 0; i < prcTexts.length; i++) {
				prcText += "<li onclick='doDetail(" + prcItems[i] + ")' class='link'>" + prcTexts[i] + "</li>";
				if (i > 0 && height < 20 * (i + 1))
					height = 20 * (i + 1);
			}
			prcText += "</ul>";
			row.put("prc_text", prcText);

//			 row.put("height", height); //<< 자동 height가 안되도록 주석 해제해주기 // 개발서버와 소스 동기화
			row.put("ItemTypeImg", item.get("ItemTypeImg"));
			gridData.put(row);
		}
		model.put("gridData", gridData);

		return nextUrl("/custom/sk/skon/item/e2e/e2eActivityTreeMgt");

	}

	@RequestMapping(value = "/zSKON_ObjectAttrInfo.do")
	public String zSKON_ObjectAttrInfo(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws Exception {

		String url = "/custom/sk/skon/model/objectAttrInfoMain";
		try {
			List returnData = new ArrayList();
			HashMap setMap = new HashMap();
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
			String attrRevYN = StringUtil.checkNull(request.getParameter("attrRevYN"), "");
			String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"), "");
			String modelID = StringUtil.checkNull(request.getParameter("ModelID"), "");

			setMap.put("s_itemID", s_itemID);
			setMap.put("languageID", request.getParameter("languageID"));
			setMap.put("defaultLang", defaultLang);
			setMap.put("option", request.getParameter("option"));

			setMap.put("s_itemID", s_itemID);
			setMap.put("attrRevYN", attrRevYN);
			Map itemInfo = commonService.select("report_SQL.getItemInfo", setMap);
			String itemStatus = StringUtil.checkNull(itemInfo.get("Status"));
			String identifier = StringUtil.checkNull(itemInfo.get("Identifier"));
			/* edit 가능 한 Item 인지 Item Status를 취득해서 판단 */
			String itemBlocked = commonService.selectString("project_SQL.getItemBlocked", setMap);

			setMap.put("modelID", modelID);
			setMap.put("link", s_itemID);
			String elementReleaseNo = "";
			if (modelID != null && !modelID.equals("null") && !modelID.equals("")) {
				elementReleaseNo = commonService.selectString("model_SQL.getElementReleaseNo", setMap);
			}

			setMap.put("releaseNo", elementReleaseNo);
			if (attrRevYN.equals("Y")) {
				setMap.put("changeSetID", changeSetID);
				returnData = (List) commonService.selectList("item_SQL.getItemRevDetailInfo", setMap);
				returnData = GetItemAttrList.getItemAttrRevList(commonService, returnData, setMap,
						StringUtil.checkNull(commandMap.get("sessionCurrLangType")));

			} else {
				returnData = (List) commonService.selectList("attr_SQL.getItemAttr", setMap);
				returnData = GetItemAttrList.getItemAttrList(commonService, returnData, setMap,
						request.getParameter("languageID"));
			}

			String dataType = "";
			Map setData = new HashMap();
			List mLovList = new ArrayList();
			String plainText = "";
			for (int i = 0; i < returnData.size(); i++) {
				Map attrTypeMap = (HashMap) returnData.get(i);
				dataType = StringUtil.checkNull(attrTypeMap.get("DataType"));
				if (dataType.equals("MLOV")) {
					setData.put("defaultLang", defaultLang);
					setData.put("languageID", request.getParameter("languageID"));
					setData.put("itemID", commandMap.get("s_itemID"));
					setData.put("attrTypeCode", attrTypeMap.get("AttrTypeCode"));
					mLovList = commonService.selectList("attr_SQL.getMLovList", setData);
					plainText = "";
					if (mLovList.size() > 0) {
						for (int j = 0; j < mLovList.size(); j++) {
							Map mLovListMap = (HashMap) mLovList.get(j);
							if (j == 0) {
								plainText = StringUtil.checkNull(mLovListMap.get("Value"));
							} else {
								plainText = plainText + " / " + mLovListMap.get("Value");
							}
						}
					}
					attrTypeMap.put("PlainText", plainText);
				}
			}

			model.put("itemStatus", itemStatus); // 아이템 Status

			if (modelID.equals("null")) {
				modelID = "";
			}
			setData.put("modelID", modelID);
			String modelBlocked = "";
			if (!modelID.equals("")) {
				modelBlocked = StringUtil.checkNull(commonService.selectString("model_SQL.getModelBlocked", setData));
			}

			if (!"0".equals(itemBlocked) || !"0".equals(modelBlocked)) {
				model.put("isPossibleEdit", "N");
			} else {
				model.put("isPossibleEdit", "Y");
			}

			// Login user editor 권한 추가
//			String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev")); // 시스템 관리자
//			if (StringUtil.checkNull(itemInfo.get("AuthorID")).equals(request.getParameter("userID")) 
//					|| StringUtil.checkNull(itemInfo.get("LockOwner")).equals(request.getParameter("userID"))
//					|| "1".equals(sessionAuthLev)) {
//				model.put("myItem", "Y");
//			}		

			String myItem = commonService.selectString("item_SQL.checkMyItem", commandMap);
			model.put("myItem", myItem);

			commandMap.put("itemID", s_itemID);

			List dimInfoList = commonService.selectList("dim_SQL.selectDim_gridList", setMap);
			List dimResultList = new ArrayList();
			Map dimResultMap = new HashMap();

			String dimTypeName = "";
			String dimValueNames = "";
			for (int i = 0; i < dimInfoList.size(); i++) {
				Map map = (HashMap) dimInfoList.get(i);

				if (i > 0) {
					if (dimTypeName.equals(map.get("DimTypeName").toString())) {
						dimValueNames += " / " + map.get("DimValuePath").toString();
					} else {
						dimResultMap.put("dimValueNames", dimValueNames);
						dimResultList.add(dimResultMap);
						dimResultMap = new HashMap(); // 초기화
						dimTypeName = map.get("DimTypeName").toString();
						dimResultMap.put("dimTypeName", dimTypeName);
						dimValueNames = map.get("DimValuePath").toString();
					}
				} else {
					dimTypeName = map.get("DimTypeName").toString();
					dimResultMap.put("dimTypeName", dimTypeName);
					dimValueNames = map.get("DimValuePath").toString();
				}
			}
			if (dimInfoList.size() > 0) {
				dimResultMap.put("dimValueNames", dimValueNames);
				dimResultList.add(dimResultMap);
			}

			setMap.put("itemID", s_itemID);
			setMap.put("itemId", s_itemID);
			setMap.put("assignmentType", "CNGROLETP");
			setMap.put("languageID", request.getParameter("languageID"));
			List roleAssignMemberList = roleAssignMemberList = commonService
					.selectList("item_SQL.getAssignmentMemberList", setMap);
			model.put("roleAssignMemberList", roleAssignMemberList);

			model.put("dimResultList", dimResultList);

			setMap.put("changeSetID", changeSetID);
			Map csInfo = commonService.select("cs_SQL.getChangeSetInfo", setMap);
			String csValidDate = "";
			if (!csInfo.isEmpty()) {
				csValidDate = StringUtil.checkNull(csInfo.get("ValidFrom"));
			}
			model.put("csValidDate", csValidDate);
			model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
			model.put("s_itemID", s_itemID);
			model.put("identifier", identifier);
			model.put("getList", returnData);
			model.put("attrRevYN", attrRevYN);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("itemInfo", itemInfo);
			// model.put("accRight", accRight);

			List<Map<String, Object>> activityList = commonService.selectList("zSK_SQL.getPrcActivityList", commandMap);
			model.put("activityListData", activityList);

			String split = "\\$\\$ ";

			for (Map<String, Object> item : activityList) {

				// R
				String r_texts[] = StringUtil.checkNull(item.get("r_text")).split(split);
				String r_ItemIDs[] = StringUtil.checkNull(item.get("r_ItemID")).split(split);
				String r_text = "";
				for (int i = 0; i < r_texts.length; i++) {
					r_text += "<span onclick='doDetail(" + r_ItemIDs[i] + ")' class='link'>" + r_texts[i]
							+ "</span><br>";
				}
				model.put("r_text", r_text);

				// A
				String a_texts[] = StringUtil.checkNull(item.get("a_text")).split(split);
				String a_ItemIDs[] = StringUtil.checkNull(item.get("a_ItemID")).split(split);
				String a_text = "";
				for (int i = 0; i < a_texts.length; i++) {
					a_text += "<span onclick='doDetail(" + a_ItemIDs[i] + ")' class='link'>" + a_texts[i]
							+ "</span><br>";
				}
				model.put("a_text", a_text);

				// S
				String s_texts[] = StringUtil.checkNull(item.get("s_text")).split(split);
				String s_ItemIDs[] = StringUtil.checkNull(item.get("s_ItemID")).split(split);
				String s_text = "";
				for (int i = 0; i < s_texts.length; i++) {
					s_text += "<span onclick='doDetail(" + s_ItemIDs[i] + ")' class='link'>" + s_texts[i]
							+ "</span><br>";
				}
				model.put("s_text", s_text);

				// I
				String i_texts[] = StringUtil.checkNull(item.get("i_text")).split(split);
				String i_ItemIDs[] = StringUtil.checkNull(item.get("i_ItemID")).split(split);
				String i_text = "";
				for (int i = 0; i < i_texts.length; i++) {
					i_text += "<span onclick='doDetail(" + i_ItemIDs[i] + ")' class='link'>" + i_texts[i]
							+ "</span><br>";
				}
				model.put("i_text", i_text);

				// C
				String c_texts[] = StringUtil.checkNull(item.get("c_text")).split(split);
				String c_ItemIDs[] = StringUtil.checkNull(item.get("c_ItemID")).split(split);
				String c_text = "";
				for (int i = 0; i < c_texts.length; i++) {
					c_text += "<span onclick='doDetail(" + c_ItemIDs[i] + ")' class='link'>" + c_texts[i]
							+ "</span><br>";
				}
				model.put("c_text", c_text);
			}

			List attachFileList = commonService.selectList("fileMgt_SQL.getFileActivity_gridList", commandMap);
			model.put("attachFileList", attachFileList);

			String itemFileOption = commonService.selectString("fileMgt_SQL.getFileOption", setMap);
			setMap.remove("itemId");
			model.put("itemFileOption", itemFileOption);

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/zSKON_elmInfoTabMenu.do")
	public String zSKON_elmInfoTabMenu(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/custom/sk/skon/model/elmInfoTabMenu";

		String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
		String modelID = StringUtil.checkNull(request.getParameter("modelID"), "");

		Map setMap = new HashMap();

		setMap.put("itemID", s_itemID);
		String classCode = StringUtil.checkNull(commonService.selectString("item_SQL.getClassCode", setMap));
		model.put("classCode", classCode);

		model.put("s_itemID", s_itemID);
		model.put("menu", getLabel(request, commonService)); /* Label Setting */
		model.put("modelID", modelID);

		model.put("screenType", StringUtil.checkNull(request.getParameter("screenType"), ""));
		model.put("attrRevYN", StringUtil.checkNull(request.getParameter("attrRevYN"), ""));
		model.put("changeSetID", StringUtil.checkNull(request.getParameter("changeSetID"), ""));
		model.put("mdlFilter", StringUtil.checkNull(request.getParameter("mdlFilter"), ""));

		model.put("itemTypeFilter", StringUtil.checkNull(request.getParameter("itemTypeFilter")));
		model.put("dimTypeFilter", StringUtil.checkNull(request.getParameter("dimTypeFilter")));
		model.put("symTypeFilter", StringUtil.checkNull(request.getParameter("symTypeFilter")));
		model.put("languageID", StringUtil.checkNull(request.getParameter("languageID")));

		return nextUrl(url);
	}

	@RequestMapping(value = "/custom/sk/skon/csAprvPostProcessing.do")
	public String zhec_UpdWFReValue(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "";
		Map target = new HashMap();
		Map setMap = new HashMap();

		try {

			System.out.println("skon Aprv Processibg ==> Start");

			String wfInstanceID = StringUtil.checkNull(commandMap.get("wfInstanceID"), "");
			String wfInstanceStatus = StringUtil.checkNull(commandMap.get("wfInstanceStatus"), "");
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String preFileBlocked = StringUtil.checkNull(commandMap.get("preFileBlocked"));
			String rjtProcOption = StringUtil.checkNull(commandMap.get("rjtProcOption"));
			String childLevel = StringUtil.checkNull(request.getParameter("childLevel"), "0");
			String status = StringUtil.checkNull(commandMap.get("status"));

			// 1) 기술 문서 신규 등록 시 Identifier 생성 >> 기존 HEC 생성 로직을 SKON 생성 규칙에 맞게 수정 필요

			setMap.put("languageID", languageID);
			setMap.put("wfInstanceID", wfInstanceID);
			Map csInfo = commonService.select("wf_SQL.getChangeSetInfoWF", setMap);
			String itemID = StringUtil.checkNull(csInfo.get("ItemID"));
			String ChangeTypeCode = StringUtil.checkNull(csInfo.get("ChangeTypeCode"));
			String itemTypeCode = StringUtil.checkNull(csInfo.get("ItemTypeCode"));

			String parentID = StringUtil.checkNull(this.commonService.selectString("item_SQL.getItemParentID", setMap));
			// setMap.put("s_itemID", 103109); // 전극을 임시 ParentID 로 설정해서 테스트 중
			// String maxIdentifier =
			// StringUtil.checkNull(this.commonService.selectString("item_SQL.getMaxIdentifierFromParentID",
			// setMap));
			setMap.put("itemID", itemID);
			// 문서채번
			String docIdentifier = StringUtil
					.checkNull(this.commonService.selectString("item_SQL.s_itemIDentifier", setMap), ""); // 기존
																											// identifier
			String docNum = "";
			String newDocIdenfier = "";
			String oldDocIdentifier = "";// 비교할 문서번호

			if (("NEW".equals(ChangeTypeCode)) && ("OJ00016".equals(itemTypeCode))) {// 재정인경우 ???
				if (docIdentifier.equals("")) { // 문서 채번이 안되있는경우
					setMap.put("itemID", itemID);
					newDocIdenfier = StringUtil
							.checkNull(this.commonService.selectString("zSK_SQL.fn_createItemIdentifier", setMap));
					setMap.put("ClassCode", "CL16004");
					setMap.put("docIdentifier", newDocIdenfier);
					docNum = commonService.selectString("zSK_SQL.getMaxIdentifier", setMap);
					docIdentifier = newDocIdenfier + "-" + docNum;
				} else {// 채번이 되어있는경우
					setMap.put("itemID", itemID);
					newDocIdenfier = StringUtil
							.checkNull(this.commonService.selectString("zSK_SQL.fn_createItemIdentifier", setMap));

					oldDocIdentifier = StringUtil.checkNull(docIdentifier.substring(0, docIdentifier.length() - 4), "");
					if (!oldDocIdentifier.equals(newDocIdenfier)) {// 기존문서번호와 변경이 있다면
						setMap.put("ClassCode", "CL16004");
						setMap.put("docIdentifier", newDocIdenfier);
						docNum = commonService.selectString("zSK_SQL.getMaxIdentifier", setMap);
						docIdentifier = newDocIdenfier + "-" + docNum;
					} else {
						docNum = StringUtil.checkNull(docIdentifier.substring(docIdentifier.length() - 3), "");// 기존
																												// 문서번호
						oldDocIdentifier = StringUtil.checkNull(docIdentifier.substring(0, docIdentifier.length() - 4),
								"");
						docIdentifier = oldDocIdentifier + "-" + docNum;
					}
				}

				setMap.put("Identifier", docIdentifier);
				setMap.put("ItemID", itemID);
				setMap.put("CategoryCode", "OJ");
				this.commonService.update("item_SQL.updateItemObjectInfo", setMap);
			} else {// 개정일경우 ?
				setMap.put("itemID", itemID);
				newDocIdenfier = StringUtil
						.checkNull(this.commonService.selectString("zSK_SQL.fn_createItemIdentifier", setMap));
				oldDocIdentifier = StringUtil.checkNull(docIdentifier.substring(0, docIdentifier.length() - 4), "");
				if (!oldDocIdentifier.equals(newDocIdenfier)) {// 기존문서번호와 변경이 있다면
					setMap.put("ClassCode", "CL16004");
					setMap.put("docIdentifier", newDocIdenfier);
					docNum = commonService.selectString("zSK_SQL.getMaxIdentifier", setMap);
					docIdentifier = newDocIdenfier + "-" + docNum;
				} else {
					docNum = StringUtil.checkNull(docIdentifier.substring(docIdentifier.length() - 3), "");// 기존 문서번호
					oldDocIdentifier = StringUtil.checkNull(docIdentifier.substring(0, docIdentifier.length() - 4), "");
					docIdentifier = oldDocIdentifier + "-" + docNum;
				}
				setMap.put("Identifier", docIdentifier);
				setMap.put("ItemID", itemID);
				setMap.put("CategoryCode", "OJ");
				this.commonService.update("item_SQL.updateItemObjectInfo", setMap);
			}
			// 2) Change Set 결재 승인 후 처리

			commandMap.put("wfInstanceID", wfInstanceID);
			commandMap.put("wfInstanceStatus", wfInstanceStatus);
			commandMap.put("preFileBlocked", preFileBlocked);
			commandMap.put("rjtProcOption", rjtProcOption);
			commandMap.put("childLevel", childLevel);
			commandMap.put("status", status);
			this.CSActionController.updateCSStatusForWF(request, commandMap, model);

			target.put(AJAX_SCRIPT, "parent.fnCallBack();this.$('#isSubmit').remove();parent.$('#isSubmit').remove();");
			// target.put(AJAX_SCRIPT,"window.close();");
		} catch (Exception e) {
			System.out.println(e);

			target.put("SCRIPT", "E");
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");

			model.addAttribute("resultMap", target);
		}

		return nextUrl("/cmm/ajaxResult/ajaxNoScriptPage");

	}

	@RequestMapping(value = "/zSKON_searchItemListPop.do")
	public String zSKON_searchItemListPop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {
			model.put("itemTypeCode", StringUtil.checkNull(request.getParameter("itemTypeCode"), ""));

			String docLevel = StringUtil.checkNull(request.getParameter("level"), "");
			String docTypeCode = StringUtil.checkNull(request.getParameter("docTypeCode"), "");
			String classCodes = StringUtil.checkNull(request.getParameter("classCodes"), "");
			String[] codesArray = classCodes.split(",");
			StringBuilder formattedClassCodes = new StringBuilder();
			for (int i = 0; i < codesArray.length; i++) {
				formattedClassCodes.append("'").append(codesArray[i]).append("'");
				if (i < codesArray.length - 1) {
					formattedClassCodes.append(",");
				}
			}

			String classCodesList = formattedClassCodes.toString();
			// setMap.put("lovCode", docLevel);
			// setMap.put("lovListFilter", docTypeCode);
			// setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			model.put("classCodes", classCodesList);
			model.put("docLevel", docLevel);
			model.put("docTypeCode", docTypeCode);

			model.put("items", StringUtil.checkNull(request.getParameter("items"), ""));
			model.put("itemID", StringUtil.checkNull(request.getParameter("itemID"), ""));
			model.put("initSearch", StringUtil.checkNull(request.getParameter("initSearch"), ""));
			model.put("callBackData", StringUtil.checkNull(request.getParameter("callBackData"), ""));
			setMap.put("ItemClassCode", StringUtil.checkNull(request.getParameter("classCode"), ""));
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			model.put("attrList", commonService.selectList("attr_SQL.getAttrAllocList", setMap));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/custom/sk/skon/item/search/searchItemListPop");
	}
	
	// SKON ITEM 생선전 attr 가져오기
	@RequestMapping(value = "/zSKON_getDefSKONAttr.do", method = RequestMethod.GET)
	@ResponseBody
	public void zSKON_getDefSKONAttr(HttpServletRequest request,  HttpServletResponse res) throws Exception {
		JSONObject jsonObject = new JSONObject();
		Map setMap = new HashMap();
		
        res.setHeader("Cache-Control", "no-cache");
		res.setContentType("text/plain");
		res.setCharacterEncoding("UTF-8");
	    try {
	    	String languageID = StringUtil.checkNull(request.getParameter("languageID"),"");
	    	String defDimValueID = StringUtil.checkNull(request.getParameter("defDimValueID"));
	    	String curItemID = StringUtil.checkNull(request.getParameter("curItemID"));
	    	setMap.put("languageID", languageID);
			setMap.put("defDimValueID", defDimValueID);
			setMap.put("curItemID", curItemID); 
			List<Map<String, Object>> getAttrInfoList = new ArrayList<>();
			
		
			
			//속성값 
			setMap.put("ItemID",curItemID);
			setMap.put("sessionCurrLangType",languageID);
			setMap.put("selectLanguageID",languageID);
			getAttrInfoList = commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
			
			//사이트정보
			Map SiteInfo = commonService.select("custom_SQL.zSKON_getSiteInfo", setMap);	
			//setMap.put("siteCode", SiteInfo.get("CODE"));
		
			
			getAttrInfoList.add(SiteInfo);
			
			jsonObject.put("defAttrInfo", getAttrInfoList);
			

			
	        res.getWriter().print(jsonObject);
	    	
	    	
	    	
	    	
	    	
	    } catch (Exception e) {
	        System.out.println(e.toString());
	        res.getWriter().print(jsonObject);
	    }
	}
	
	
}
