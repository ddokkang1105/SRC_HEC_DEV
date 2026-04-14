package xbolt.app.esp.vocp.web;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import xbolt.app.esp.main.util.ESPUtil;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.util.EmailUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

import com.org.json.JSONArray;

@Controller
@SuppressWarnings("unchecked")
public class VOCPActionController extends XboltController {
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "esmService")
	private CommonService esmService;
	
	@RequestMapping(value = "/vocpMgt.do")
	public String vocpMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/app/esp/vocp/vocpMgt"; 
		try {
				String parentId = StringUtil.checkNull(request.getParameter("s_itemID"));
				String srMode = StringUtil.checkNull(request.getParameter("srMode"));				
				String scrnType = StringUtil.checkNull(cmmMap.get("screenType"),request.getParameter("scrnType")); 
				String mainType = StringUtil.checkNull(cmmMap.get("mainType"),request.getParameter("mainType"));
				String esType = StringUtil.checkNull(request.getParameter("esType"));
				String srType = StringUtil.checkNull(request.getParameter("srType"));
				
				String varFilter = StringUtil.checkNull(request.getParameter("varFilter"));
				String itemProposal = StringUtil.checkNull(cmmMap.get("itemProposal"),request.getParameter("itemProposal"));
				String focusMenu = StringUtil.checkNull(request.getParameter("focusMenu"));
				String arcCode = StringUtil.checkNull(request.getParameter("arcCode"));
				String defCategory = StringUtil.checkNull(request.getParameter("defCategory"));
				String multiComp = StringUtil.checkNull(request.getParameter("multiComp"));

				cmmMap.put("srTypeCode", srType);
				Map srTypeInfo = commonService.select("esm_SQL.getESMSRTypeInfo",cmmMap);
				String srVarFilter = StringUtil.checkNull(srTypeInfo.get("VarFilter"));
				
				cmmMap.put("typeCode", srType);
				cmmMap.put("languageID", cmmMap.get("sessionCurrLangType"));
				cmmMap.put("category", "SRTP");
				String srTypeNM = commonService.selectString("common_SQL.getNameFromDic",cmmMap);
				List boardMgtList = commonService.selectList("board_SQL.boardMgtSRtypeAllocList", cmmMap);
				
				model.put("boardMgtList", boardMgtList);
				model.put("varFilter", varFilter );
				model.put("itemProposal", itemProposal );
				model.put("scrnType", scrnType );
				model.put("srMode",  srMode);
				model.put("esType",  esType);
				model.put("srType",  srType);			
				model.put("srID",  StringUtil.checkNull(request.getParameter("srID")));	
				model.put("sysCode",  StringUtil.checkNull(request.getParameter("sysCode")));	
				model.put("parentID", parentId);
				model.put("mainType", mainType);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */		
				model.put("focusMenu", focusMenu);
				model.put("arcCode", arcCode);
				model.put("srVarFilter", srVarFilter);
				model.put("srTypeNM", srTypeNM);
				model.put("defCategory", defCategory);
				model.put("multiComp", multiComp);

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/vocpList.do")
	public String vocpList(HttpServletRequest request, HashMap cmmMap,  HashMap commandMap,   ModelMap model,HttpServletResponse response) throws Exception {
		String url = "/app/esp/vocp/vocpList";
		try {
			Map setData = new HashMap();
			
			String esType = StringUtil.checkNull(cmmMap.get("esType"),request.getParameter("esType"));
			String srType = StringUtil.checkNull(cmmMap.get("srType"),request.getParameter("srType")); 
			String itemID = StringUtil.checkNull(commandMap.get("s_itemID"),request.getParameter("itemID")); // Item Menu에서 리스트 출력 시 사용
			String projectID = StringUtil.checkNull(commandMap.get("projectID"),""); 
			String srMode = StringUtil.checkNull(request.getParameter("srMode"));
			String arcCode = StringUtil.checkNull(request.getParameter("arcCode"));
			String varFilter = StringUtil.checkNull(request.getParameter("varFilter"));
			String multiComp = StringUtil.checkNull(request.getParameter("multiComp"));
			String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"));
			String menuStyle = StringUtil.checkNull(request.getParameter("menuStyle"));
			String srStatus = StringUtil.checkNull(request.getParameter("srStatus"));
			String startEventCode = StringUtil.checkNull(request.getParameter("startEventCode"));
			
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String scrnType = StringUtil.checkNull(request.getParameter("scrnType"));
			String srID = StringUtil.checkNull(request.getParameter("srID"));
			
			String itemTypeCodeItemID = null;
			
			setData.put("s_itemID", itemID);
			setData.put("languageID", languageID);
			
			// esType 존재 시 esType 기준으로 srArea 조회
			if( esType!= null && !"".equals(esType)){
				setData.put("srType",esType);
			} else {
				setData.put("srType",srType);
			}
			
			setData.put("level", 1);
			String srAreaLabelNM1 = commonService.selectString("esm_SQL.getESMSRAreaLabelName",setData);
			String srArea1ClsCode = commonService.selectString("esm_SQL.getSRAreaClsCode",setData);
			setData.put("level", 2);
			String srAreaLabelNM2 = commonService.selectString("esm_SQL.getESMSRAreaLabelName",setData);
			String srArea2ClsCode = commonService.selectString("esm_SQL.getSRAreaClsCode",setData);

			model.put("srArea1ClsCode", srArea1ClsCode);
			model.put("srArea2ClsCode", srArea2ClsCode);
			
			setData.put("sessionUserId",commandMap.get("sessionUserId"));
			//String customerNo = StringUtil.checkNull(commonService.selectString("user_SQL.userClientID", setData));
			//model.put("customerNo", customerNo);
			
			Map setMap = new HashMap();
			setMap.put("srTypeCode", StringUtil.checkNull(srType,varFilter));				
			Map SRTypeMap = commonService.select("esm_SQL.getESMSRTypeInfo",setMap);

			model.put("refID", projectID);
			model.put("scrnType", scrnType);
			model.put("srMode", srMode);
			model.put("esType", esType);
			model.put("srType", StringUtil.checkNull(srType,varFilter));
			model.put("projectID", projectID);
			model.put("itemID", itemID);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("srID", srID);
			model.put("mainType", StringUtil.checkNull(request.getParameter("mainType")));
			model.put("sysCode", StringUtil.checkNull(request.getParameter("sysCode")));
			model.put("multiComp", multiComp);
			model.put("itemTypeCode", StringUtil.checkNull(itemTypeCodeItemID,itemTypeCode));
			model.put("srAreaLabelNM1", srAreaLabelNM1);
			model.put("srAreaLabelNM2", srAreaLabelNM2);
			model.put("menuStyle",menuStyle);
			model.put("arcCode", arcCode);
			model.put("varFilter", varFilter);
			model.put("defCategory", StringUtil.checkNull(cmmMap.get("defCategory")));
			model.put("srStatus",srStatus);
			model.put("startEventCode",startEventCode);

			// searchOption setting 
			Map ispMap = new HashMap();
			
			ispMap.put("languageID", languageID);
			ispMap.put("scrnType", scrnType);
			ispMap.put("srMode", srMode);
			ispMap.put("srType", srType);
			ispMap.put("itemID", itemID);
			ispMap.put("srStatus", srStatus);
			
			//권한을 통해 자기자신의 company만 봐야하는 경우가 있으면 제어
			//ispMap.put("clientID", customerNo);
			
			if("mySR".equals(srMode) || "myVOC".equals(srMode) || "myTR".equals(srMode) || "myRole".equals(srMode) || "myClient".equals(srMode) || "myPJT".equals(srMode)){
				ispMap.put("loginUserId",commandMap.get("sessionUserId"));
			} else if("PG".equals(srMode) || "PJT".equals(srMode)){
				ispMap.put("refID",projectID);
			} else if("myTeam".equals(srMode)){
				ispMap.put("myTeamId",commandMap.get("sessionTeamId"));
			}
			
			List ispList = commonService.selectList("esm_SQL.getEsrMSTList_gridList",ispMap);
			JSONArray gridData = new JSONArray(ispList);
			model.put("gridData",gridData);
			
			if(srMode.equals("mySr")){
				model.put("requstUser", cmmMap.get("sessionUserNm"));
			}
		
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/registerVOCP.do")
	public String registerVOCP(HttpServletRequest request, HashMap cmmMap, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/app/esp/vocp/registerVOCP";
		try {
				List attachFileList = new ArrayList();
				
				Map setData = new HashMap();
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType")); 
				String srType = StringUtil.checkNull(cmmMap.get("srType"),request.getParameter("srType"));
				String esType = StringUtil.checkNull(cmmMap.get("esType"),request.getParameter("esType"));
				String parentId = StringUtil.checkNull(request.getParameter("parentID")); 
				String itemProposal = StringUtil.checkNull(cmmMap.get("itemProposal"));
				String arcCode = StringUtil.checkNull(cmmMap.get("arcCode"));
				String varFilter = StringUtil.checkNull(cmmMap.get("varFilter"));
				String itemID = StringUtil.checkNull(cmmMap.get("itemID"));
				String itemTypeCode = StringUtil.checkNull(cmmMap.get("itemTypeCode"));
				
				setData.put("srType",StringUtil.checkNull(srType,varFilter));
				setData.put("s_itemID", itemID);
				setData.put("languageID", commandMap.get("sessionCurrLangType"));
				
				setData.put("level", 1);
				String srAreaLabelNM1 = commonService.selectString("esm_SQL.getESMSRAreaLabelName",setData);
				String srArea1ClsCode = commonService.selectString("esm_SQL.getSRAreaClsCode",setData);
				setData.put("level", 2);
				String srAreaLabelNM2 = commonService.selectString("esm_SQL.getESMSRAreaLabelName",setData);
				String srArea2ClsCode = commonService.selectString("esm_SQL.getSRAreaClsCode",setData);
				
				//임시저장된 파일이 존재할 수 있으므로 삭제
				String path=GlobalVal.FILE_UPLOAD_BASE_DIR + cmmMap.get("sessionUserId");
				if(!path.equals("")){FileUtil.deleteDirectory(path);}	
						
				// 시스템 날짜 
				Calendar cal = Calendar.getInstance();
				cal.setTime(new Date(System.currentTimeMillis()));
				String thisYmd = new SimpleDateFormat("yyyyMMdd").format(cal.getTime());

				cal.add(Calendar.DATE, +14);
				String defaultDueDate = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
				
				cal = Calendar.getInstance();
				cal.add(Calendar.DATE, +7);
				String currDateAdd7 = new SimpleDateFormat("yyyyMMdd").format(cal.getTime());
				
				model.put("itemProposal", itemProposal);
				model.put("scrnType", StringUtil.checkNull(request.getParameter("scrnType")) );
				model.put("crMode", StringUtil.checkNull(request.getParameter("crMode")) );
				model.put("crFilePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
				model.put("menu", getLabel(request, commonService)); //  Label Setting 
				model.put("pageNum", StringUtil.checkNull(request.getParameter("pageNum"), "1"));
				model.put("thisYmd", thisYmd);
				model.put("defaultDueDate", defaultDueDate); // default 완료 예정일
				model.put("currDateAdd7", currDateAdd7);
				model.put("ParentID", parentId);
				model.put("scrnType", StringUtil.checkNull(request.getParameter("scrnType"), ""));
				model.put("esType", esType);
				model.put("srType", srType);
				model.put("ProjectID", StringUtil.checkNull(request.getParameter("ProjectID"), ""));
				model.put("srMode", StringUtil.checkNull(request.getParameter("srMode"), ""));
				model.put("defCategory", StringUtil.checkNull(cmmMap.get("defCategory")));
				
				// List 검색조건 setting
				model.put("srCategory", StringUtil.checkNull(cmmMap.get("category")));
				model.put("srArea1", StringUtil.checkNull(cmmMap.get("srArea1")));
				model.put("srArea2", StringUtil.checkNull(cmmMap.get("srArea2")));
				model.put("subject", StringUtil.checkNull(cmmMap.get("subject")));
				model.put("status", StringUtil.checkNull(cmmMap.get("status")));				
				model.put("searchSrCode", StringUtil.checkNull(cmmMap.get("searchSrCode")));
				model.put("subject", StringUtil.checkNull(cmmMap.get("subject")));
				model.put("srReceiptTeam", StringUtil.checkNull(cmmMap.get("srReceiptTeam")));
				model.put("crReceiptTeam", StringUtil.checkNull(cmmMap.get("crReceiptTeam")));
				model.put("srStatus", StringUtil.checkNull(cmmMap.get("srStatus")));
				
				model.put("arcCode", arcCode);
				model.put("varFilter", varFilter);
				model.put("itemID", itemID);
				model.put("itemTypeCode", itemTypeCode);
				model.put("srAreaLabelNM1", srAreaLabelNM1);
				model.put("srAreaLabelNM2", srAreaLabelNM2);
				
				//Call PROC_LOG START TIME
				setInitProcLog(request);
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/processVOCP.do")
	public String processVOCP(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/app/esp/vocp/viewVOCPDetail";
		HashMap setData = new HashMap();
		try {
				List attachFileList = new ArrayList();
				Map setMap = new HashMap();
				Map getSRInfo = new HashMap();		
				
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
				
				// 임시 문서 보관 디렉토리 삭제
				String path = GlobalVal.FILE_UPLOAD_BASE_DIR + cmmMap.get("sessionUserId");
				FileUtil.deleteDirectory(path);
				
				// sr Info
				setData.put("srID", srID);
				setData.put("srType", srType);
				setData.put("srCode", srCode);
				setData.put("languageID", languageID);
				Map srInfoMap = commonService.select("esm_SQL.getESMSRInfo", setData);	
				
				// jsp setting
				String blocked = StringUtil.checkNull(srInfoMap.get("Blocked"));
				String option = StringUtil.checkNull(cmmMap.get("option"));
				if(sessionUserID.equals(receiptUserID) //  사용자 = 접수자
				   && !scrnType.equals("srRqst") // SR 등록 메뉴가 아니고
				   && (blocked.equals("0") || "modifyCMP".equals(option))) // 상태가 조치완료나 마감이 아닐 경우 or **완료-[수정] 제외
				{ // SR 접수 처리로 이동 
					if(!isPopup.equals("Y")){url = "/app/esp/vocp/processVOCP";} // SR모니터링 팝업이 아니면
				}
				
				// Email
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
				
				// 첨부문서 취득
				attachFileList = commonService.selectList("sr_SQL.getSRFileList", setData);
				
				String appBtn = "N"; // app button 제어  
				if(!StringUtil.checkNull(srInfoMap.get("SubCategory")).equals("")
						&& !StringUtil.checkNull(srInfoMap.get("Comment")).equals("")
						){
					appBtn = "Y";
				}
				
				// 담당자 정보 취득
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
				String WFDocURL = StringUtil.checkNull(srTypeInfo.get("WFDocURL"));
				
				// 참조
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
				String checkOutYN = "N"; 
				setData.put("SRID",srID);
				setData.put("RoleType", StringUtil.checkNull(srInfoMap.get("ProcRoleTP")));
				setData.put("srArea", StringUtil.checkNull(srInfoMap.get("SRArea1")));
				setData.put("languageID", languageID);
				
				List RoleTPList = commonService.selectList("esm_SQL.getReceiptUserList", setData);
				String RoleTPID = "";
				if(RoleTPList.size()>0){
					for(int i=0; i<RoleTPList.size(); i++){
						Map RoleMap = (Map)RoleTPList.get(i);
						RoleTPID = StringUtil.checkNull(RoleMap.get("CODE"));
						if(RoleTPID.equals(sessionUserID))checkOutYN = "Y";
					}
				}
				// 담당자 지정 시 해당 담당자 제외 그룹원 접수 불가
				if(!"".equals(receiptUserID)&&!receiptUserID.equals(sessionUserID))checkOutYN = "N";
				
				model.put("WFDocURL", WFDocURL);				
				model.put("itemProposal", itemProposal);
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
				model.put("checkOutYN", checkOutYN);
				
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
	
}
