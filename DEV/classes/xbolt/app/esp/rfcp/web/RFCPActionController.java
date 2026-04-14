package xbolt.app.esp.rfcp.web;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.text.StringEscapeUtils;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import xbolt.app.esp.main.util.ESPUtil;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.filter.XSSRequestWrapper;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.DateUtil;
import xbolt.cmm.framework.util.EmailUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.org.json.JSONArray;
import com.org.json.JSONObject;

@Controller
@SuppressWarnings("unchecked")
public class RFCPActionController extends XboltController {
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "esmService")
	private CommonService esmService;
	
	@Resource(name = "fileMgtService")
	private CommonService fileMgtService;
	
	@RequestMapping(value = "/processRFCP.do")
	public String processRFCP(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/app/esp/rfcp/viewRFCPDetail";
		HashMap setData = new HashMap();
		try {
				List attachFileList = new ArrayList();
				Map setMap = new HashMap();
				Map getSRInfo = new HashMap();		
				Map getItemMap = new HashMap();
				
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType")); 
				String srID = StringUtil.checkNull(cmmMap.get("srID")); 
				String esType = StringUtil.checkNull(cmmMap.get("esType")); 
				String srType = StringUtil.checkNull(cmmMap.get("srType")); 
				String scrnType = StringUtil.checkNull(cmmMap.get("scrnType")); 
				String srMode = StringUtil.checkNull(cmmMap.get("srMode"));
				String pageNum = StringUtil.checkNull(cmmMap.get("pageNum"));
				String srCode = StringUtil.checkNull(cmmMap.get("srCode"));
				String sessionUserID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
				String srStatus = StringUtil.checkNull(cmmMap.get("srStatus"));
				String status = StringUtil.checkNull(cmmMap.get("status"));
				String receiptUserID = StringUtil.checkNull(cmmMap.get("receiptUserID"));
				String projectID = StringUtil.checkNull(cmmMap.get("projectID"));
				String itemID = StringUtil.checkNull(cmmMap.get("itemID"));
				String isPopup = StringUtil.checkNull(cmmMap.get("isPopup"));	
				String mainType = StringUtil.checkNull(cmmMap.get("mainType"));	
				String varFilter = StringUtil.checkNull(cmmMap.get("varFilter"));	
				String multiComp = StringUtil.checkNull(cmmMap.get("multiComp"));
				String itemTypeCode = StringUtil.checkNull(cmmMap.get("itemTypeCode"));
				
				String itemProposal = StringUtil.checkNull(cmmMap.get("itemProposal"));
				String defCategory = StringUtil.checkNull(cmmMap.get("defCategory"));
				
				if(srCode.equals("")){; // 외부에서 호출시 srID만 넘어옮
					setData.put("srID", srID);
					setData.put("srType", srType);
					setData.put("esType", esType);
					setData.put("languageID", languageID);
					getSRInfo = commonService.select("esm_SQL.getESMSRInfo", setData);					
	
					if(!getSRInfo.isEmpty()){
						status = StringUtil.checkNull(getSRInfo.get("Status"));
						receiptUserID = StringUtil.checkNull(getSRInfo.get("ReceiptUserID"));
					}
				}
				
				// 시스템 날짜 
				Calendar cal = Calendar.getInstance();
				cal.setTime(new Date(System.currentTimeMillis()));
				String thisYmd = new SimpleDateFormat("yyyyMMdd").format(cal.getTime());
				
				/* 임시 문서 보관 디렉토리 삭제 */
				String path = GlobalVal.FILE_UPLOAD_BASE_DIR + cmmMap.get("sessionUserId");
				FileUtil.deleteDirectory(path);

				setData.put("srID", srID);
				setData.put("srType", srType);
				setData.put("srCode", srCode);
				setData.put("languageID", languageID);
				Map srInfoMap = commonService.select("esm_SQL.getESMSRInfo", setData);	
								
				String blocked = StringUtil.checkNull(srInfoMap.get("Blocked"));
				String option = StringUtil.checkNull(cmmMap.get("option"));
				if(sessionUserID.equals(receiptUserID) //  사용자 = 접수자
				   && !scrnType.equals("srRqst") // SR 등록 메뉴가 아니고
				   && (blocked.equals("0") || "modifyCMP".equals(option))) // 상태가 조치완료나 마감이 아닐 경우 or **완료-[수정] 제외
				{ // SR 접수 처리로 이동 
					if(!isPopup.equals("Y")){url = "/app/esp/rfcp/processRFCP";} // SR모니터링 팝업이 아니면
				}
				
				
				// proposal == 01 이메일 전송
				if(sessionUserID.equals(receiptUserID) && status.equals("SPE018") && StringUtil.checkNull(srInfoMap.get("Proposal")).equals("01")){ 
					//==============================================
					Map setMailData = new HashMap();
					//send Email
					setMailData.put("EMAILCODE", "PROPS");
					setMailData.put("subject", StringUtil.checkNull(srInfoMap.get("Subject")));
					
					List receiverList = new ArrayList();
					Map receiverMap = new HashMap();
					receiverMap.put("receiptUserID", StringUtil.checkNull(srInfoMap.get("RequestUserID")));
					receiverList.add(0,receiverMap);
					setMailData.put("receiverList", receiverList);
					
					Map setMailMapRst = (Map)setEmailLog(request, commonService, setMailData, "PROPS");
					System.out.println("setMailMapRst( [PRIME - 제안연계 알림] ) : "+setMailMapRst );
					
					HashMap setMailMap = new HashMap();
					if(StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")){
						HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
						setMailMap.put("srID", srID);
						setMailMap.put("srType", srType);
						setMailMap.put("languageID", String.valueOf(cmmMap.get("sessionCurrLangType")));
						HashMap cntsMap = (HashMap)commonService.select("esm_SQL.getESMSRInfo", setMailMap);
						
						cntsMap.put("srID", srID);	
						cntsMap.put("teamID", StringUtil.checkNull(srInfoMap.get("RequestTeamID")));					
						cntsMap.put("userID", StringUtil.checkNull(srInfoMap.get("RequestUserID")));
						cntsMap.put("languageID", String.valueOf(cmmMap.get("sessionCurrLangType")));
						String requestLoginID = StringUtil.checkNull(commonService.selectString("sr_SQL.getLoginID", cntsMap));
						cntsMap.put("loginID", requestLoginID);
						
						Map resultMailMap = EmailUtil.sendMail(mailMap, cntsMap, getLabel(request, commonService));
						System.out.println("SEND EMAIL TYPE:"+resultMailMap+ "Msg :" + StringUtil.checkNull(setMailMapRst.get("type")));
					}else{
						System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMapRst.get("msg")));
					}
					//==============================================
				}
				
				// 예상 진행 리스트 ( ProcList )
				setData.put("srID", srID);
				setData.put("itemClassCode", "CL03004");
				setData.put("status", status);
				setData.put("esType", esType);
				setData.put("languageID", languageID);
				setData.remove("srType");
				List procStatusList = commonService.selectList("esm_SQL.getESPProcPathList", setData);
				String prSeq =  StringUtil.checkNull(commonService.selectString("esm_SQL.getESPLastLogSeq", setData));
				model.put("prSeq", prSeq);
				
				setData.put("procPathID", StringUtil.checkNull(srInfoMap.get("ProcPathID")) );
				
				// 다음 단계 리스트
				setData.put("rulePass", "N");
				List nextStatusList = commonService.selectList("esm_SQL.getESPNextEventList", setData);
				model.put("nextStatusList", nextStatusList);
				
				/* 첨부문서 취득 */
				attachFileList = commonService.selectList("sr_SQL.getSRFileList", setData);
				
				String appBtn = "N"; // app button 제어  
				if(!StringUtil.checkNull(srInfoMap.get("SubCategory")).equals("")
						&& !StringUtil.checkNull(srInfoMap.get("Comment")).equals("")
						){
					appBtn = "Y";
				}
				
				/* 담당자 정보 취득 */
				if(!"".equals(receiptUserID)){
					// 지정 담당자 존재
					setData.put("MemberID", receiptUserID);
					Map authorInfoMap = commonService.select("item_SQL.getAuthorInfo", setData);	
					model.put("authorInfoMap", authorInfoMap); // 담당자 정보
					model.put("appBtn", appBtn);
				}
				
				// 보안 조치
				String Description = StringUtil.checkNull(srInfoMap.get("Description")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
				String Comment = StringUtil.checkNull(srInfoMap.get("Comment")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
				srInfoMap.put("Description",Description);
				srInfoMap.put("Comment",Comment);
				
				// srType ( WFDocURL )
				setMap = new HashMap();
				setMap.put("srTypeCode", srType);				
				Map srTypeInfo = commonService.select("esm_SQL.getESMSRTypeInfo",setMap);
				
				// 참조
				setMap.put("srID", srID);
				setMap.put("roleType", "REF");
				setMap.put("languageID", cmmMap.get("sessionCurrLangType"));				
				List esmSRMbrList = commonService.selectList("esm_SQL.getESMSRMember",setMap);
				String sharerNames = "";
				if(esmSRMbrList.size()>0){
					for(int i=0; i<esmSRMbrList.size(); i++){
						Map esmSRMbrInfo = (Map)esmSRMbrList.get(i);
						if(i==0){
							sharerNames = StringUtil.checkNull(esmSRMbrInfo.get("esmSRMbr"));
						}else{
							sharerNames = sharerNames + ", " + StringUtil.checkNull(esmSRMbrInfo.get("esmSRMbr"));
						}
					}
				}
				
				setData.put("SRID",srID);
				setData.put("roleType", "REF"); //참조
				setData.put("assignmentType", "SRROLETP");
				setData.put("languageID", languageID);
				List srSharers = commonService.selectList("esm_SQL.getESMSRMember",setData);
				String srSharerName = "";
				String srSharerID = "";
				if(srSharers.size()>0){
					for(int i=0; i<srSharers.size(); i++){
						Map srSharerInfo = (Map)srSharers.get(i);
						if(i==0){
							srSharerName = StringUtil.checkNull(srSharerInfo.get("SRRefMember"));
							srSharerID = StringUtil.checkNull(srSharerInfo.get("MemberID"));
						}else{
							srSharerName = srSharerName + ", " + StringUtil.checkNull(srSharerInfo.get("SRRefMember"));
							srSharerID = srSharerID + "," + StringUtil.checkNull(srSharerInfo.get("MemberID"));
						}
					}
				}
				
				// 담당 그룹 할당버튼 ( self-checkIn )
				if("".equals(receiptUserID)){
					setData.put("SRID",srID);
					setData.put("RoleType", StringUtil.checkNull(srInfoMap.get("ProcRoleTP")));
					setData.put("srArea", StringUtil.checkNull(srInfoMap.get("SRArea1")));
					setData.put("languageID", languageID);
					
					List RoleTPList = commonService.selectList("esm_SQL.getReceiptUserList", setData);
					String RoleTPID = "";
					String checkOutYN = "N"; 
					if(RoleTPList.size()>0){
						for(int i=0; i<RoleTPList.size(); i++){
							Map RoleMap = (Map)RoleTPList.get(i);
							RoleTPID = StringUtil.checkNull(RoleMap.get("CODE"));
							if(RoleTPID.equals(sessionUserID))checkOutYN = "Y";
						}
					}
					model.put("checkOutYN", checkOutYN);	
				}
				
				// attrTypeCode alloc list 
				setMap = new HashMap();
				setMap.put("srID", StringUtil.checkNull(request.getParameter("srID")) );
				
				setMap.put("speCode", StringUtil.checkNull(srInfoMap.get("Status")));
				setMap.put("srCatID", StringUtil.checkNull(srInfoMap.get("SubCategory")));
				setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
				setMap.put("docCategory", "SR");
				System.out.println("setMap :"+setMap+", srInfoMap :"+srInfoMap);
				List srAttrList = (List)commonService.selectList("esm_SQL.getSRAttrList", setMap);
				
				srAttrList = ESPUtil.getSRAttrList(commonService, srAttrList, setMap, languageID);
				
				System.out.println("srAttrList :"+srAttrList);
				
				model.put("srAttrList", srAttrList);
				
				model.put("sharerNames", sharerNames);				
				model.put("WFDocURL", StringUtil.checkNull(srTypeInfo.get("WFDocURL")));				
				model.put("itemProposal", itemProposal);
				model.put("getItemMap",getItemMap);
				model.put("srInfoMap", srInfoMap);
				model.put("procStatusList", procStatusList);
				model.put("srFilePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
				model.put("SRFiles", attachFileList);
				model.put("scrnType", scrnType );
				model.put("srMode", srMode );
				model.put("esType", esType);
				model.put("srType", srType);				
				model.put("menu", getLabel(request, commonService)); //  Label Setting 
				model.put("pageNum", pageNum);
				model.put("thisYmd", thisYmd);
				model.put("projectID", projectID);
				model.put("srStatus", srStatus);
				model.put("itemID", itemID);
				model.put("isPopup", isPopup);
				model.put("srSharerName", srSharerName);
				model.put("srSharerID", srSharerID);
				model.put("multiComp", multiComp);
				model.put("itemTypeCode", itemTypeCode);
				model.put("status", StringUtil.checkNull(cmmMap.get("status")));
				model.put("option",option);
				
				// 검색조건 Setting
				model.put("category", StringUtil.checkNull(cmmMap.get("category")));
				model.put("subCategory", StringUtil.checkNull(cmmMap.get("subCategory")));
				model.put("srArea1", StringUtil.checkNull(cmmMap.get("srArea1")));
				model.put("srArea2", StringUtil.checkNull(cmmMap.get("srArea2")));
				model.put("subject", StringUtil.checkNull(cmmMap.get("subject")));
				model.put("searchStatus", StringUtil.checkNull(cmmMap.get("searchStatus")));
				model.put("receiptUser", StringUtil.checkNull(cmmMap.get("receiptUser")));
				model.put("requestUser", StringUtil.checkNull(cmmMap.get("requestUser")));
				model.put("requestTeam", StringUtil.checkNull(cmmMap.get("requestTeam")));
				model.put("regStartDate", StringUtil.checkNull(cmmMap.get("regStartDate")));
				model.put("regEndDate", StringUtil.checkNull(cmmMap.get("regEndDate")));
				model.put("stSRDueDate", StringUtil.checkNull(cmmMap.get("stSRDueDate")));
				model.put("endSRDueDate", StringUtil.checkNull(cmmMap.get("endSRDueDate")));	
				model.put("searchSrCode", StringUtil.checkNull(cmmMap.get("searchSrCode")));
				model.put("srReceiptTeam", StringUtil.checkNull(cmmMap.get("srReceiptTeam")));
				model.put("varFilter", varFilter);
				model.put("defCategory", defCategory);
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/wipActivityMgt.do")
	public void wipActivityMgt(HttpServletRequest request,  HttpServletResponse res) throws Exception {
		HashMap target = new HashMap();
		try {
			res.setHeader("Cache-Control", "no-cache");
			res.setContentType("text/plain");
			res.setCharacterEncoding("UTF-8");
			
			Map setData = new HashMap();
			setData.put("identifier", StringUtil.checkNull(request.getParameter("speCode")));
			setData.put("attrTypeCode", "AT00015");
			setData.put("languageID", StringUtil.checkNull(request.getParameter("languageID")));
	
			String inputValue = StringUtil.checkNull(commonService.selectString("item_SQL.getPlainTextByIdentifier", setData));
			
			Map<String, String> params = ESPUtil.getQueryParams(inputValue);
			
			String redirectUrl = StringUtil.checkNull(params.get("redirectUrl"));
			if(redirectUrl.equals("")) {
				redirectUrl = "/srActivityResultMgt.do";
			} 
			
			redirectUrl = redirectUrl + "?scrnMode=E"+inputValue;
			
			res.getWriter().print(redirectUrl);
		} catch (IOException e) {
			MessageHandler.getMessage("json.send.message");
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value = "/srActivityResultMgt.do")
	public String srActivityResultMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/app/esp/rfcp/srActivityResultMgt";
		String editMode = "N";
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			Map setMap = new HashMap();
			String srID = StringUtil.checkNull(request.getParameter("srID"));
			String scrID = StringUtil.checkNull(request.getParameter("scrID"));
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String isPopup = StringUtil.checkNull(request.getParameter("isPopup"));
			
			// attrTypeCode alloc list 
			setMap = new HashMap();
			setMap.put("srID", srID);
			setMap.put("scrID", scrID);
			setMap.put("languageID", languageID);
			Map srInfoMap = commonService.select("esm_SQL.getESMSRInfo", setMap);	
			
			// redirect check
			setMap.put("identifier", StringUtil.checkNull(srInfoMap.get("Status")));
			setMap.put("attrTypeCode", "AT00015");
			String inputValue = StringUtil.checkNull(commonService.selectString("item_SQL.getPlainTextByIdentifier", setMap));
			Map<String, String> params = ESPUtil.getQueryParams(inputValue);
			String showInvisible = StringUtil.checkNull(params.get("showInvisible"));
			String docCategory = StringUtil.checkNull(params.get("docCategory"),"SR");
			model.putAll(params);
			
			// isEditableAfterReception 체크
			String isEditableAfterReception = StringUtil.checkNull(params.get("isEditableAfterReception"));
						
			// attrTypeCode alloc list 
			setMap = new HashMap();
			setMap.put("srID", srID);
			setMap.put("scrID", scrID);
			setMap.put("speCode", StringUtil.checkNull(srInfoMap.get("Status")));
			setMap.put("srType", StringUtil.checkNull(srInfoMap.get("SRType")));
			
			setMap.put("languageID", languageID);
			setMap.put("docCategory", docCategory);
			setMap.put("showInvisible", showInvisible);
			
			// SR ATTR ( Invisible = 1 / Editable = 0 일 경우 전에 있던 값 input hidden으로 넣기 )
			if("N".equals(showInvisible)){
				List previousSrAttrList = (List)commonService.selectList("esm_SQL.getPreviousHiddenSRAttr", setMap);
				model.put("previousSrAttrList",previousSrAttrList);
			}
			
			model.put("srInfoMap", srInfoMap);
			model.put("docCategory", docCategory);
			model.put("scrID", scrID);
			model.put("srArea1ListSQL", StringUtil.checkNull(cmmMap.get("srArea1ListSQL")));
			model.put("srType", StringUtil.checkNull(cmmMap.get("srType")));
			model.put("esType", StringUtil.checkNull(cmmMap.get("esType")));
			model.put("isPopup", isPopup);
			
			setMap.put("speCode", StringUtil.checkNull(srInfoMap.get("Status")));
			setMap.put("maxSeq", "Y");
			Map activityLogInfo = commonService.select("esm_SQL.getESMProLogInfo_gridList", setMap);
			model.put("activityLogInfo", activityLogInfo);
			setMap.put("docCategory", "SPE");
			model.put("WFDocURL", StringUtil.checkNull(commonService.selectString("wf_SQL.getWFDocURL", setMap)) );
			
			setMap.put("DocCategory", "SPE"); // wfDocMgt
			model.put("wfURL", StringUtil.checkNull(commonService.selectString("wf_SQL.getWFCategoryURL", setMap)) );
						
			if(activityLogInfo.get("Status").equals("00") && !"N".equals(isEditableAfterReception)) {	// 접수 전
				setMap.put("RoleType", StringUtil.checkNull(srInfoMap.get("ProcRoleTP")));
				setMap.put("srArea", StringUtil.checkNull(srInfoMap.get("SRArea2")));
				List roleUserList = commonService.selectList("esm_SQL.getReceiptUserList", setMap);
				
				String RoleTPID = "";
				if(roleUserList.size()>0){
					for(int i=0; i<roleUserList.size(); i++){
						Map RoleMap = (Map)roleUserList.get(i);
						RoleTPID = StringUtil.checkNull(RoleMap.get("CODE"));
						if(RoleTPID.equals(StringUtil.checkNull(cmmMap.get("sessionUserId")))) {
							editMode = "Y";
							break;
						}
					}
				}
			} 
			
			// 접수
			if(activityLogInfo.get("Status").equals("01")) {	
				if(StringUtil.checkNull(srInfoMap.get("ReceiptUserID")).equals(StringUtil.checkNull(cmmMap.get("sessionUserId"))) ) editMode = "Y";
			}
			// 임시저장인 경우
			String isPublic = StringUtil.checkNull(srInfoMap.get("isPublic"));
			if("0".equals(isPublic) && StringUtil.checkNull(srInfoMap.get("RegUserID")).equals(StringUtil.checkNull(cmmMap.get("sessionUserId")))) {
				 editMode = "Y";
			}
			model.put("editMode", editMode);
			
			//setMap.put("documentID", StringUtil.checkNull(activityLogInfo.get("ActivityLogID")));
			if(!StringUtil.checkNull(activityLogInfo.get("ActivityWFInstanceID")).equals("")) {
				setMap.put("wfInstanceID", StringUtil.checkNull(activityLogInfo.get("ActivityWFInstanceID")));			
				Map wfInstInfo = commonService.select("wf_SQL.getWFInstList_gridList", setMap);
				
				model.put("wfInstInfo", wfInstInfo);
			}
			
			setMap.put("customerNo", StringUtil.checkNull(srInfoMap.get("ClientID")));
			model.put("inhouse",StringUtil.checkNull(commonService.selectString("esm_SQL.getInhouseYN", setMap)));
						
			//임시저장된 파일이 존재할 수 있으므로 삭제
			String path=GlobalVal.FILE_UPLOAD_BASE_DIR + cmmMap.get("sessionUserId");
			if(!path.equals("")){FileUtil.deleteDirectory(path);}
			model.put("defApprovalSystem", GlobalVal.DEF_APPROVAL_SYSTEM);
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/olmapi/srAttr")
	public void srAttr(HttpServletRequest request,  HttpServletResponse res, HashMap<String, Object> cmmMap, ModelMap model) throws Exception {
		JSONObject jsonObject = new JSONObject();
		Map map = new HashMap();
		
        res.setHeader("Cache-Control", "no-cache");
		res.setContentType("text/plain");
		res.setCharacterEncoding("UTF-8");
	    try {
	    	String srID = StringUtil.checkNull(request.getParameter("srID"),"");
	    	String srType = StringUtil.checkNull(request.getParameter("srType"),"");
	    	String speCode = StringUtil.checkNull(request.getParameter("speCode"),"");
	    	String languageID = StringUtil.checkNull(request.getParameter("languageID"),"");
	    	String docCategory = StringUtil.checkNull(request.getParameter("docCategory"),"");
	    	String showInvisible = StringUtil.checkNull(request.getParameter("showInvisible"),"");
	    	
	    	map.put("srID", srID);
	    	map.put("srType", srType);
	    	map.put("speCode", speCode);
	    	map.put("docCategory", docCategory);
	    	map.put("languageID", languageID);
	    	map.put("docCategory", docCategory);
	    	map.put("showInvisible", showInvisible);
	    	List srAttrList = commonService.selectList("esm_SQL.getSRAttrList", map);
			List returnSRAttrList = ESPUtil.getSRAttrList(commonService, srAttrList, map, languageID);
			
			jsonObject.put("data", returnSRAttrList);
	        res.getWriter().print(jsonObject);
	    } catch (Exception e) {
	        System.out.println(e.toString());
	        res.getWriter().print(jsonObject);
	    }
	}
	
	@RequestMapping(value = "/olmapi/activityFile")
	public void activityFile(HttpServletRequest request,  HttpServletResponse res, HashMap<String, Object> cmmMap, ModelMap model) throws Exception {
		JSONObject jsonObject = new JSONObject();
		Map map = new HashMap();
		
        res.setHeader("Cache-Control", "no-cache");
		res.setContentType("text/plain");
		res.setCharacterEncoding("UTF-8");
	    try {
	    	String srID = StringUtil.checkNull(request.getParameter("srID"),"");
	    	String speCode = StringUtil.checkNull(request.getParameter("speCode"),"");
	    	String languageID = StringUtil.checkNull(request.getParameter("languageID"),"");
	    	
	    	map.put("srID", srID);
	    	map.put("speCode", speCode);
	    	map.put("languageID", languageID);
	    	List fileList = commonService.selectList("esm_SQL.espFile_gridList", map);
			
			jsonObject.put("data", fileList);
	        res.getWriter().print(jsonObject);
	    } catch (Exception e) {
	        System.out.println(e.toString());
	        res.getWriter().print(jsonObject);
	    }
	}
	
	@Transactional(rollbackFor = Exception.class)
	@RequestMapping(value = "/saveSRActivityResult.do")
	public String saveSRActivityResult(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String srArea2 = StringUtil.checkNull(commandMap.get("srArea2"));
			String activitySeq = StringUtil.checkNull(commandMap.get("activitySeq"));
			String activityStatus = StringUtil.checkNull(commandMap.get("activityStatus"));
			String docCategory = StringUtil.checkNull(commandMap.get("docCategory"),"SR");
			String editMode = StringUtil.checkNull(commandMap.get("editMode"));
			String changeCategory = StringUtil.checkNull(commandMap.get("changeCategory"));
			
			commandMap.put("changeCategory",changeCategory);
			commandMap.put("languageID", languageID);
			commandMap.put("lastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));
			
			// 04. SR Update 및 로그 처리
			if(!"".equals(activityStatus)) {
				// 04-01. 접수 or 완료 or 보류
				commandMap.put("docCategory", docCategory);
				commandMap.put("documentID", StringUtil.checkNull(commandMap.get("srID")));
				commandMap.put("startTime", ESPUtil.getCurrentLocalDate("yyyy-MM-dd HH:mm:ss"));
				commandMap.put("receiptUserID", StringUtil.checkNull(commandMap.get("sessionUserId")));
				commandMap.put("receiptTeamID", StringUtil.checkNull(commandMap.get("sessionTeamId")));
				commandMap.put("requestUserID", StringUtil.checkNull(commandMap.get("requestUserID")));
				commandMap.put("requestTeamID", StringUtil.checkNull(commandMap.get("requestTeamID")));
				
				// * [접수] & [보류] 인 경우 완료일 X
				if(!"01".equals(activityStatus) && !"09".equals(activityStatus)) 
					commandMap.put("endTime", ESPUtil.getCurrentLocalDate("yyyy-MM-dd HH:mm:ss"));
				// * [완료] 인 경우 speCode 변경 및 log Insert
				if(!"05".equals(activityStatus)){
					commandMap.put("srGoNextYN", "N"); // 완료 제외 speCode 변경 x
					commandMap.put("srLogType", "U"); // log update
				}
			} else {
				// 04-02. 단순저장  [ SAVE ]
				commandMap.put("srGoNextYN", "N"); // speCode 변경 x 
				commandMap.put("srLogType", "N"); // log 저장 x
			}
			
			// * 선처리 여부 체크
			// 선처리 옵션
			String SRAT0019 = StringUtil.checkNull(commandMap.get("SRAT0019"));
			if(!"".equals(SRAT0019)){
				commandMap.put("REQ_DEPT_APP_OPIN", "Y");
			}
			
			// * SR Update
			ESPUtil.updateESP(request, this.commonService, commandMap); 
			
			// * 그룹 인원체크
			String roleGroupNull = StringUtil.checkNull(commandMap.get("roleGroupNull"));
			if("Y".equals(roleGroupNull)) {
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00178")); 
			} else {
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 
			}
			
			target.put(AJAX_SCRIPT, "parent.fnCallBackSR();parent.$('#isSubmit').remove(); isSubmitting = false;");
			
		} catch (Exception e) {
			System.out.println(e);
			
			// rollback
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();  isSubmitting = false;");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/saveSRActivity.do")
	public String saveSRActivity(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		ObjectMapper objectMapper = new ObjectMapper();
		Map setMap = new HashMap();
		try {
			
			// 요청 본문에서 JSON 데이터 읽기
			StringBuilder jsonBuilder = new StringBuilder();
			try (BufferedReader reader = request.getReader()) {
				String line;
				while ((line = reader.readLine()) != null) {
					jsonBuilder.append(line);
				}
			}
			String jsonString = jsonBuilder.toString();

			HashMap data = objectMapper.readValue(jsonString, new TypeReference<HashMap>() {});
			
			String activitySeq = StringUtil.checkNull(data.get("activitySeq"));
			String editMode = StringUtil.checkNull(data.get("editMode"));
			
			// 01. Seq가 1보다 클 경우 ATTR_REV 저장
			if(!"N".equals(editMode)){
				if("".equals(activitySeq)){
					setMap.put("srID", StringUtil.checkNull(data.get("srID")));
					setMap.put("status", StringUtil.checkNull(data.get("speCode")));
					activitySeq = StringUtil.checkNull(commonService.selectString("esm_SQL.getSeqActivityLog", setMap),"1");
				}
				if(Integer.parseInt(activitySeq) > 1){
					int seq = Integer.parseInt(activitySeq)-1;
					if(seq > 0){
						data.put("activitySeq",seq);
						ESPUtil.insertSRAttrRev(data, commonService);
					}
				}
				
				// 02. SR_ATTR 저장
				ESPUtil.updateSRAttr(data, this.commonService);
			}
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/saveEsrFile.do")
	public String saveEsrFile(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		ObjectMapper objectMapper = new ObjectMapper();
		Map setMap = new HashMap();
		try {
			// 요청 본문에서 JSON 데이터 읽기
			StringBuilder jsonBuilder = new StringBuilder();
			try (BufferedReader reader = request.getReader()) {
				String line;
				while ((line = reader.readLine()) != null) {
					jsonBuilder.append(line);
				}
			}
			String jsonString = jsonBuilder.toString();

			Map<String, Object> data = objectMapper.readValue(jsonString, new TypeReference<Map<String, Object>>() {});
			String srID = StringUtil.checkNull(data.get("srID"));
			commandMap.put("srID", srID);
			commandMap.put("docCategory", StringUtil.checkNull(data.get("docCategory")));
			commandMap.put("projectID", StringUtil.checkNull(data.get("projectID")));
			commandMap.put("speCode", StringUtil.checkNull(data.get("speCode")));
			commandMap.put("activityLogID", StringUtil.checkNull(data.get("activityLogID")));
			commandMap.put("fltpCode",StringUtil.checkNull(commonService.selectString("esm_SQL.getESMFltpCode", commandMap)));

			List<Map<String, Object>> fileList = (List<Map<String, Object>>) data.get("fileList");
			List<Map<String, Object>> fileTypeUpdateList = (List<Map<String, Object>>) data.get("fileTypeUpdateList");

			for (int i = 0; i < fileTypeUpdateList.size(); i++) {
				Map temp = fileTypeUpdateList.get(i);
				setMap.put("FltpCode", StringUtil.checkNull(temp.get("fileType")));
				setMap.put("Seq", StringUtil.checkNull(temp.get("seq")));
				setMap.put("Description", "");
				setMap.put("sessionUserId", StringUtil.checkNull(commandMap.get("sessionUserId")));
				setMap.put("LanguageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
				commonService.update("fileMgt_SQL.itemFile_update", setMap);
			}

			if (fileList.size() > 0) ESPUtil.insertESPFilesByFiletype(commandMap, commonService, esmService, srID, fileList);
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}
	
	
	
	
	//운영관리실적 등록화면
	@RequestMapping(value = "/espMbrRcdList.do")
	public String espMbrRcdList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/custom/daelim/itsm/espMbrRcdList"; 
		try {
			
			HashMap setMap  = new HashMap();
			HashMap setData  = new HashMap();

			String scrnType = StringUtil.checkNull(request.getParameter("scrnType"));
			String srID = StringUtil.checkNull(request.getParameter("srID"));
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String useOverTime = StringUtil.checkNull(request.getParameter("useOverTime"));
			
			model.put("scrnType", scrnType);
			model.put("useOverTime", useOverTime);
			model.put("menu", getLabel(request, commonService)); //  Label Setting 
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	//최초 등록시 save
		@RequestMapping(value = "/saveMH.do" )
		public String saveMH( HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {

			 // JSON 문자열을 Java 객체로 변환
	        ObjectMapper objectMapper = new ObjectMapper();
	        HashMap setData  = new HashMap();
			try {
				// 요청 본문에서 JSON 데이터 읽기
		        StringBuilder jsonBuilder = new StringBuilder();
		        try (BufferedReader reader = request.getReader()) {
		            String line;
		            while ((line = reader.readLine()) != null) {
		                jsonBuilder.append(line);
		            }
		        }
		        String jsonString = jsonBuilder.toString();
		        
		        // jsonString을 Map 객체로 변환
		        Map<String, Object> jsonMap = objectMapper.readValue(jsonString, new TypeReference<Map<String, Object>>(){});

		        // data와 delItems 분리
		        List<Map<String, Object>> dataList = (List<Map<String, Object>>) jsonMap.get("data");
		        String srID = StringUtil.checkNull(jsonMap.get("srID"));
		        String speCode = StringUtil.checkNull(jsonMap.get("speCode"));
		        String procRoleTP = StringUtil.checkNull(jsonMap.get("procRoleTP"));

		        // 데이터 처리 로직
		        for (Map<String, Object> item : dataList) {
		            HashMap<String, Object> setMap = new HashMap<>(item);

		            setData.put("srID", srID);
		            
		            setMap.put("Creator", cmmMap.get("sessionUserId"));
	                setMap.put("LastUser", cmmMap.get("sessionUserId"));
	                
	                // TimeZone Setting
	                String WORK_DATE = StringUtil.checkNull(setMap.get("WORK_DATE"));
	                if(!"".equals(WORK_DATE)) {
	                	String currentTime = ESPUtil.getCurrentLocalDate("HH:mm:ss.SSS");
	                	WORK_DATE = WORK_DATE +" "+currentTime;
	                	setMap.put("WORK_DATE", WORK_DATE);
	                }
		            
	                setMap.put("procRoleTP", procRoleTP);
	                setMap.put("SpeCode", speCode);
	                setMap.put("srID", srID);
	                commonService.insert("esm_SQL.insertOpsMbr", setMap);
		        }
		        
		        // 업무내용 insert
		        List<Map<String, Object>> descList = ((List<Map<String, Object>>) jsonMap.get("descMbrList"));	        
		        if (descList != null && !descList.isEmpty()) {
		        	for (Map<String, Object> list : descList) {
						setData.put("SRID", srID);
						setData.put("memberID", StringUtil.checkNull(list.get("memberID")));
						setData.put("sessionUserId", StringUtil.checkNull(list.get("memberID")));
						setData.put("mbrTeamID", commonService.selectString("user_SQL.userTeamID", setData));
						setData.put("speCode", speCode);
						setData.put("assignmentType", "SRROLETP");
						setData.put("roleType", procRoleTP);
						setData.put("roleDescription", StringUtil.checkNull(list.get("desc")));
						setData.put("orderNum", 1);
						setData.put("assigned", "1");
						setData.put("accessRight", "R");
						setData.put("creator", cmmMap.get("sessionUserId"));
						setData.put("speCode", speCode);
						commonService.delete("esm_SQL.deleteSRMbr", setData);
						commonService.insert("esm_SQL.insertESMSRMember", setData);
		        	}
		        }
		          


			} catch (Exception e) {
				System.out.println(e.toString());
			}
		
			return nextUrl(AJAXPAGE);
		
		}	
		
	
	//편집후 save함수
	@Transactional(rollbackFor = Exception.class)
	@RequestMapping(value = "/editSaveMH.do")
	public void editSaveMH(HttpServletRequest request,  HttpServletResponse res, HashMap<String, Object> cmmMap, ModelMap model) throws Exception {
		JSONObject jsonObject = new JSONObject();
	    ObjectMapper objectMapper = new ObjectMapper();
	    HashMap<String, Object> setData = new HashMap<>();
	    
        res.setHeader("Cache-Control", "no-cache");
		res.setContentType("text/plain");
		res.setCharacterEncoding("UTF-8");
		
	    try {
	        // 요청 본문에서 JSON 데이터 읽기
	        StringBuilder jsonBuilder = new StringBuilder();
	        try (BufferedReader reader = request.getReader()) {
	            String line;
	            while ((line = reader.readLine()) != null) {
	                jsonBuilder.append(line);
	            }
	        }
	        String jsonString = jsonBuilder.toString();
	        
	        // jsonString을 Map 객체로 변환
	        Map<String, Object> jsonMap = objectMapper.readValue(jsonString, new TypeReference<Map<String, Object>>(){});

	        // data와 delItems 분리
	        List<Map<String, Object>> dataList = (List<Map<String, Object>>) jsonMap.get("data");
	        List<Integer> delList = (List<Integer>) jsonMap.get("delItems");
	        String srID = StringUtil.checkNull(jsonMap.get("srID"));
	        String procRoleTP = StringUtil.checkNull(jsonMap.get("procRoleTP"));
	        String speCode = StringUtil.checkNull(jsonMap.get("speCode"));
	        String addUser = StringUtil.checkNull(jsonMap.get("addUser"));

	        // 데이터 처리 로직
	        for (Map<String, Object> item : dataList) {
	            HashMap<String, Object> setMap = new HashMap<>(item);

	            // mbrRcdID를 사용하여 데이터 UPDATE, INSERT,DELETE
	            String getMbrRcdID = StringUtil.checkNull(commonService.selectString("esm_SQL.getMbrRcdId", setMap));
	            
	            setData.put("srID", srID);
	            Map<String, Object> procSrDetail = commonService.select("esm_SQL.getSrDetailInfo", setData);
	            procRoleTP = StringUtil.checkNull(procSrDetail.get("ProcRoleTP"));
	            speCode = StringUtil.checkNull(procSrDetail.get("SpeCode"));
	            
	            setMap.put("Creator", cmmMap.get("sessionUserId"));
                setMap.put("LastUser", cmmMap.get("sessionUserId"));

                String workDate = StringUtil.checkNull(setMap.get("WORK_DATE"),"");
                if(!"".equals(workDate)) {
                	workDate = ESPUtil.changeTimeZoneDateType(workDate);
                	setMap.put("WORK_DATE", workDate);
                }
                
	            // mbrRcdID가 중복되면 (이미 존재한다면) 업데이트
	            if (getMbrRcdID != null && !getMbrRcdID.isEmpty()) {
	                HashMap<String, Object> updMap = new HashMap<>();
	                // TimeZone Setting
	                String businessHours = StringUtil.checkNull(setMap.get("BUSINESS_HOURS"),"0");
	                String overTime = StringUtil.checkNull(setMap.get("OVERTIME"),"0");
	                updMap.put("work_date", workDate);
	                updMap.put("business_hours", businessHours);
	                updMap.put("overTime", overTime);
	                updMap.put("getMbrRcdID", getMbrRcdID);
	                commonService.update("esm_SQL.updateMbrRcd", updMap);
	            } else {
	                // 그렇지 않다면 [ESM_MBR_RCD] INSERT
	                setMap.put("procRoleTP", procRoleTP);
	                setMap.put("SpeCode", speCode);
	                setMap.put("srID", srID);
	               // if(setMap.get)
	                commonService.insert("esm_SQL.insertOpsMbr", setMap);
	            }
	        }
	        
	        // 업무내용 insert
	        List<Map<String, Object>> descList = ((List<Map<String, Object>>) jsonMap.get("descMbrList"));	        
	        if (descList != null && !descList.isEmpty()) {
	        	for (Map<String, Object> list : descList) {
	        		 if(addUser.equals("N") && StringUtil.checkNull(list.get("memberID")).equals(StringUtil.checkNull(cmmMap.get("sessionUserId")))) {
						setData.put("SRID", srID);
						setData.put("memberID", StringUtil.checkNull(list.get("memberID")));
						setData.put("sessionUserId", StringUtil.checkNull(list.get("memberID")));
						setData.put("mbrTeamID", commonService.selectString("user_SQL.userTeamID", setData));
						setData.put("speCode", speCode);
						setData.put("assignmentType", "SRROLETP");
						setData.put("roleType", procRoleTP);
						setData.put("roleDescription", StringUtil.checkNull(list.get("desc")));
						setData.put("orderNum", 1);
						setData.put("assigned", "1");
						setData.put("accessRight", "R");
						setData.put("creator", cmmMap.get("sessionUserId"));
						setData.put("speCode", speCode);
						commonService.delete("esm_SQL.deleteSRMbr", setData);
						commonService.insert("esm_SQL.insertESMSRMember", setData);
	        		 }
	        		 if(addUser.equals("Y")) {
	        			setData.put("SRID", srID);
	     				setData.put("memberID", StringUtil.checkNull(list.get("memberID")));
	     				setData.put("sessionUserId", StringUtil.checkNull(list.get("memberID")));
	     	   			setData.put("mbrTeamID", commonService.selectString("user_SQL.userTeamID", setData));
	     	   			setData.put("speCode", speCode);
	     				setData.put("assignmentType", "SRROLETP");
	     				setData.put("roleType", procRoleTP);
	     				setData.put("roleDescription", StringUtil.checkNull(list.get("desc")));
	     				setData.put("orderNum", 1);
	     				setData.put("assigned", "1");
	     				setData.put("accessRight", "R");
	     				setData.put("creator", cmmMap.get("sessionUserId"));
	     				setData.put("speCode", speCode);
	     				commonService.delete("esm_SQL.deleteSRMbr", setData);
	     				commonService.insert("esm_SQL.insertESMSRMember", setData);
	        		 }
	        	}
	        }
	        
	        // 삭제리스트 처리
	        if (delList != null && !delList.isEmpty()) {
	            for (Integer mbrRcdId : delList) {
	                // 삭제할 mbrRcdId를 기준으로 삭제 
	            	if(!"".equals(mbrRcdId)) {
	            		HashMap<String, Object> deleteMap = new HashMap<>();
	            		deleteMap.put("mbrRcdID", mbrRcdId);
	            		commonService.delete("esm_SQL.deleteMbrRcd", deleteMap);
	            	}
	            }
	        }
	        
            //운영실적 조회
	        setData.remove("memberID");
	        setData.put("SRID", srID);
	        setData.put("LanguageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
	        setData.put("speCode", StringUtil.checkNull(jsonMap.get("speCode")));
			List mbrList = commonService.selectList("esm_SQL.selectMbrRcd_gridList", setData);
			JSONArray gridData = new JSONArray(mbrList);
			jsonObject.put("gridData", gridData);
			
			jsonObject.put("result", true);
			jsonObject.put("message", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
	        res.getWriter().print(jsonObject);
	    } catch (Exception e) {
	        System.out.println(e.toString());
	        
	        // rollback
	        TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
	        
	        jsonObject.put("result", false);
	        jsonObject.put("message", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
	        res.getWriter().print(jsonObject);
	    }
	}

	
	//운영실적 조회 및 편집
	@RequestMapping(value = "/editEspMbrRcdList.do")
	public String editEspMbrRcdList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url ="/custom/daelim/itsm/editEspMbrRcdList";
		try {
			HashMap setMap  = new HashMap();
			HashMap setData  = new HashMap();
			
			String editMode = "N";
			String addUser = "N";
			String modUser = "N";
			String defaultMH = "N";
			String srID = StringUtil.checkNull(request.getParameter("srID"));
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String speCode = StringUtil.checkNull(request.getParameter("speCode"));
			
			String procRoleTP = StringUtil.checkNull(request.getParameter("procRoleTP")); 
			String receiptUserID = StringUtil.checkNull(request.getParameter("receiptUserID"));
			String srArea2 = StringUtil.checkNull(request.getParameter("srArea2"));
			String activityStatus = StringUtil.checkNull(request.getParameter("activityStatus"));
			String sessionUserID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			String mbrAddUserYN = StringUtil.checkNull(request.getParameter("mbrAddUserYN"));
			String mbrModUserYN = StringUtil.checkNull(request.getParameter("mbrModUserYN"));
			String useOverTime = StringUtil.checkNull(request.getParameter("useOverTime"));
			
			//운영실적 조회
			setMap.put("SRID", srID);
			setMap.put("LanguageID", languageID);
			setMap.put("speCode", speCode);
			List<Map<String, String>> mbrList = commonService.selectList("esm_SQL.selectMbrRcd_gridList", setMap);
			
			// 편집모드
			/*if(activityStatus.equals("00")) {	// 접수 전
				setMap.put("RoleType", procRoleTP);
				setMap.put("srArea", srArea2);
				List roleUserList = commonService.selectList("esm_SQL.getReceiptUserList", setMap);
				
				String RoleTPID = "";
				if(roleUserList.size()>0){
					for(int i=0; i<roleUserList.size(); i++){
						Map RoleMap = (Map)roleUserList.get(i);
						RoleTPID = StringUtil.checkNull(RoleMap.get("CODE"));
						if(RoleTPID.equals(StringUtil.checkNull(cmmMap.get("sessionUserId")))) {
							editMode = "Y";
							addUser = "Y";
							break;
						}
					}
				}
			} */
			if(sessionUserID.equals(receiptUserID) && activityStatus.equals("01")) {
				editMode = "Y";
				addUser = "Y";
				defaultMH = "Y";
			}
			
			List mbrExistList = mbrList.stream().map(e -> String.valueOf(e.get("memberID"))).distinct().collect(Collectors.toList());
			//if( activityStatus.equals("00") || activityStatus.equals("01") && mbrExistList.contains(sessionUserID)) editMode = "Y";
			if( activityStatus.equals("01") && mbrExistList.contains(sessionUserID)) editMode = "Y";
			
			if("N".equals(mbrAddUserYN)){
				addUser = "N";
			}
			
			if("Y".equals(mbrModUserYN) && sessionUserID.equals(receiptUserID) && "Y".equals(editMode)){
				modUser = "Y";
			}
			
			model.put("editMode", editMode);
			model.put("addUser", addUser);
			model.put("defaultMH",defaultMH);
			model.put("modUser", modUser);
			model.put("useOverTime", useOverTime);
			
			JSONArray gridData = new JSONArray(mbrList);
			model.put("gridData",gridData);
			model.put("srID", srID);
			model.put("speCode", speCode);
			model.put("procRoleTP", procRoleTP);
			model.put("menu", getLabel(request, commonService)); //  Label Setting 
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	// 등록 시 예외처리
	@RequestMapping(value = "/olmapi/checkDuplicateSR", method = RequestMethod.POST)
	@ResponseBody
	public void checkDuplicateSR(HttpServletRequest request,  HttpServletResponse res, HashMap<String, Object> cmmMap, ModelMap model) throws Exception {
		
		JSONObject jsonObject = new JSONObject();
		ObjectMapper objectMapper = new ObjectMapper();
		Map setMap = new HashMap();
		boolean result = true;
		
	    try {
	    	// 티켓 중 중복을 확인하여 예외처리를 한다.
	    	
	    	// 요청 본문에서 JSON 데이터 읽기
	        StringBuilder jsonBuilder = new StringBuilder();
	        try (BufferedReader reader = request.getReader()) {
	            String line;
	            while ((line = reader.readLine()) != null) {
	                jsonBuilder.append(line);
	            }
	        }
	        String jsonString = jsonBuilder.toString();
	        
	        // jsonString을 Map 객체로 변환
	        Map<String, Object> jsonMap = objectMapper.readValue(jsonString, new TypeReference<Map<String, Object>>(){});

	        // data와 delItems 분리
	        List<Map<String, Object>> dataList = (List<Map<String, Object>>) jsonMap.get("data");
	        String subject = StringUtil.checkNull(jsonMap.get("subject"));
	        String speCode = StringUtil.checkNull(jsonMap.get("speCode"));
	        String receiptUserID = StringUtil.checkNull(jsonMap.get("receiptUserID"));
	    	String srType = StringUtil.checkNull(jsonMap.get("srType"),"");
	    	
	    	setMap.put("subject", subject);
	        setMap.put("receiptUserID", receiptUserID);
	        setMap.put("srType", srType);
	        setMap.put("speCode", speCode);
	        
	        // workDate
	        List<String> dateList = new ArrayList();
	        for (Map<String, Object> item : dataList) {
	            HashMap<String, Object> map = new HashMap<>(item);
	            dateList.add(StringUtil.checkNull(map.get("WORK_DATE"),""));
	        }
	        String workDate = dateList.stream()
                    .map(date -> "'" + date + "'") 
                    .collect(Collectors.joining(","));
	        
	        setMap.put("workDate", workDate);
	        
			String duplicateCount = commonService.selectString("esm_SQL.checkDuplicateSR", setMap);
			int count = Integer.parseInt(duplicateCount);
			
			if(count > 0) result = false;
			
			jsonObject.put("result", result);
	        res.getWriter().print(jsonObject);
	        
	    } catch (Exception e) {
	        System.out.println(e.toString());
	        res.getWriter().print(jsonObject);
	    }
	}
}
