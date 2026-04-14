package xbolt.app.esp.main.web;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
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

import org.apache.commons.text.StringEscapeUtils;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import xbolt.app.esp.main.util.ESPUtil;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.filter.XSSRequestWrapper;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.DateUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.custom.youngone.val.YoungOneGlobalVal;
import xbolt.wf.web.WfActionController;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.org.json.JSONArray;
import com.org.json.JSONObject;

@Controller
@SuppressWarnings("unchecked")
public class ESPActionController extends XboltController {
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "esmService")
	private CommonService esmService;
		
	@Resource(name = "CSService")
	private CommonService CSService;
	
	@Resource(name = "fileMgtService")
	private CommonService fileMgtService;
	
	@RequestMapping(value = "/espMgt.do")
	public String espMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/app/esp/main/espMgt"; 
		try {
				String srType = StringUtil.checkNull(request.getParameter("srType"));
				String esType = StringUtil.checkNull(request.getParameter("esType"));
				String parentId = StringUtil.checkNull(request.getParameter("s_itemID"));
				String srMode = StringUtil.checkNull(request.getParameter("srMode"));				
				String scrnType = StringUtil.checkNull(cmmMap.get("screenType"),request.getParameter("scrnType")); 
				String mainType = StringUtil.checkNull(cmmMap.get("mainType"),request.getParameter("mainType"));
				String srTypeUrl = StringUtil.checkNull(request.getParameter("url"));
				String srArea1ListSQL = StringUtil.checkNull(request.getParameter("srArea1ListSQL"));
				String itemProposal = StringUtil.checkNull(cmmMap.get("itemProposal"),request.getParameter("itemProposal"));
				String focusMenu = StringUtil.checkNull(request.getParameter("focusMenu"));
				String defCategory = StringUtil.checkNull(request.getParameter("defCategory"));
				String defSrarea = StringUtil.checkNull(request.getParameter("defSrarea"));
				
				if(!srTypeUrl.equals("")){
					url = srTypeUrl;
				}
			
				model.put("srType",  srType);
				model.put("esType",  esType);
				model.put("srArea1ListSQL", srArea1ListSQL );
				model.put("itemProposal", itemProposal );
				model.put("scrnType", scrnType );
				model.put("srMode",  srMode);
				model.put("srID",  StringUtil.checkNull(request.getParameter("srID")));	
				model.put("sysCode",  StringUtil.checkNull(request.getParameter("sysCode")));	
				model.put("parentID", parentId);
				model.put("mainType", mainType);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */		
				model.put("focusMenu", focusMenu);
				model.put("srStatus", StringUtil.checkNull(request.getParameter("srStatus"),"ALL"));
				model.put("reqDateLimit",  StringUtil.checkNull(request.getParameter("reqDateLimit")));
				model.put("defCategory",  defCategory);
				model.put("defSrarea",  defSrarea);

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/espList.do")
	public String espList(HttpServletRequest request, HashMap cmmMap,  HashMap commandMap,   ModelMap model) throws Exception {
		String url = "/app/esp/main/espList";
		try {
			Map setData = new HashMap();
			
			String esType = StringUtil.checkNull(cmmMap.get("esType"),request.getParameter("esType"));
			String srType = StringUtil.checkNull(cmmMap.get("srType"),request.getParameter("srType")); 
			String itemID = StringUtil.checkNull(commandMap.get("s_itemID"),request.getParameter("itemID")); // Item Menu에서 리스트 출력 시 사용
			String projectID = StringUtil.checkNull(commandMap.get("projectID"),""); 
			String srMode = StringUtil.checkNull(request.getParameter("srMode"));
			String arcCode = StringUtil.checkNull(request.getParameter("arcCode"));
			String varFilter = StringUtil.checkNull(request.getParameter("varFilter"));
			String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"));
			String menuStyle = StringUtil.checkNull(request.getParameter("menuStyle"));
			String srStatus = StringUtil.checkNull(request.getParameter("srStatus"));
			String myWorkspace = StringUtil.checkNull(request.getParameter("myWorkspace"));
			String period = StringUtil.checkNull(request.getParameter("period")); // 검색기간
			
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
//			Map SRTypeMap = commonService.select("esm_SQL.getESMSRTypeInfo",setMap);

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
			model.put("itemTypeCode", StringUtil.checkNull(itemTypeCodeItemID,itemTypeCode));
			model.put("srAreaLabelNM1", srAreaLabelNM1);
			model.put("srAreaLabelNM2", srAreaLabelNM2);
			model.put("menuStyle",menuStyle);
			model.put("arcCode", arcCode);
			model.put("varFilter", varFilter);
			model.put("defCategory", StringUtil.checkNull(cmmMap.get("defCategory")));
			model.put("srStatus",srStatus);
			model.put("myCSR", StringUtil.checkNull(request.getParameter("myCSR")));
			model.put("myWorkspace", myWorkspace);
			model.put("period", period);

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
			
			if("mySR".equals(srMode) || "myVOC".equals(srMode) || "myTR".equals(srMode) || "myRole".equals(srMode) || "myClient".equals(srMode) || "myPJT".equals(srMode) || "myReq".equals(srMode)){
				ispMap.put("loginUserId",commandMap.get("sessionUserId"));
			} else if("PG".equals(srMode) || "PJT".equals(srMode)){
				ispMap.put("refID",projectID);
			} else if("myTeam".equals(srMode)){
				ispMap.put("myTeamId",commandMap.get("sessionTeamId"));
			}
			
//			List ispList = commonService.selectList("esm_SQL.getESPSearchList_gridList",ispMap);
//			JSONArray gridData = new JSONArray(ispList);
//			model.put("gridData",gridData);
			
			if(srMode.equals("mySr")){
				model.put("requstUser", cmmMap.get("sessionUserNm"));
			}
		
			// searchOption setting 
			model.put("searchSrType", StringUtil.checkNull(request.getParameter("searchSrType")));
			model.put("customerNo", StringUtil.checkNull(request.getParameter("customerNo")));
			model.put("searchStatus", StringUtil.checkNull(request.getParameter("searchStatus")));
			model.put("inProgress", StringUtil.checkNull(request.getParameter("inProgress")));
			model.put("regStartDate", StringUtil.checkNull(request.getParameter("regStartDate")));
			model.put("regEndDate", StringUtil.checkNull(request.getParameter("regEndDate")));
			model.put("stSRDueDate", StringUtil.checkNull(request.getParameter("stSRDueDate")));
			model.put("endSRDueDate", StringUtil.checkNull(request.getParameter("endSRDueDate")));
			model.put("stSRCompDT", StringUtil.checkNull(request.getParameter("stSRCompDT")));
			model.put("endSRCompDT", StringUtil.checkNull(request.getParameter("endSRCompDT")));
			model.put("completionDelay", StringUtil.checkNull(request.getParameter("completionDelay")));
			model.put("searchSrCode", StringUtil.checkNull(request.getParameter("searchSrCode")));
			model.put("subject", StringUtil.checkNull(request.getParameter("subject")));
			model.put("srAreaSearch", StringUtil.checkNull(request.getParameter("srAreaSearch")));
			model.put("srArea1", StringUtil.checkNull(request.getParameter("srArea1")));
			model.put("srArea2", StringUtil.checkNull(request.getParameter("srArea2")));
			model.put("svcType", StringUtil.checkNull(request.getParameter("svcType")));
			model.put("requestUser", StringUtil.checkNull(request.getParameter("requestUser")));
			model.put("requestUserID", StringUtil.checkNull(request.getParameter("requestUserID")));
			model.put("actorName", StringUtil.checkNull(request.getParameter("actorName")));
			model.put("actorID", StringUtil.checkNull(request.getParameter("actorID")));
			model.put("defaultLang", commonService.selectString("item_SQL.getDefaultLang", commandMap));
			model.put("isCallCenter",  StringUtil.checkNull(request.getParameter("isCallCenter")));
			model.put("arcCode", StringUtil.checkNull(request.getParameter("arcCode"), request.getParameter("returnMenuId")));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/myESPList.do")
	public String myESPList(HttpServletRequest request, HashMap cmmMap,  HashMap commandMap,   ModelMap model) throws Exception {
		String url = "/app/esp/main/myESPList";
		try {
			Map setData = new HashMap();
			
			String esType = StringUtil.checkNull(cmmMap.get("esType"),request.getParameter("esType"));
			String srType = StringUtil.checkNull(cmmMap.get("srType"),request.getParameter("srType")); 
			String itemID = StringUtil.checkNull(commandMap.get("s_itemID"),request.getParameter("itemID")); // Item Menu에서 리스트 출력 시 사용
			String projectID = StringUtil.checkNull(commandMap.get("projectID"),""); 
			String srMode = StringUtil.checkNull(request.getParameter("srMode"));
			String arcCode = StringUtil.checkNull(request.getParameter("arcCode"));
			String varFilter = StringUtil.checkNull(request.getParameter("varFilter"));
			String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"));
			String menuStyle = StringUtil.checkNull(request.getParameter("menuStyle"));
			String srStatus = StringUtil.checkNull(request.getParameter("srStatus"));
			String isPublic = StringUtil.checkNull(request.getParameter("isPublic"));
			String myCSR = StringUtil.checkNull(request.getParameter("myCSR"));
			String myWorkspace = StringUtil.checkNull(request.getParameter("myWorkspace"));
			String period = StringUtil.checkNull(request.getParameter("period"));
			
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
//			Map SRTypeMap = commonService.select("esm_SQL.getESMSRTypeInfo",setMap);

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
			model.put("itemTypeCode", StringUtil.checkNull(itemTypeCodeItemID,itemTypeCode));
			model.put("srAreaLabelNM1", srAreaLabelNM1);
			model.put("srAreaLabelNM2", srAreaLabelNM2);
			model.put("menuStyle",menuStyle);
			model.put("arcCode", arcCode);
			model.put("varFilter", varFilter);
			model.put("defCategory", StringUtil.checkNull(cmmMap.get("defCategory")));
			model.put("srStatus",srStatus);
			model.put("isPublic",isPublic); // 0 : 임시저장  / 1 : 정상등록 
			model.put("myCSR",myCSR);
			model.put("myWorkspace",myWorkspace);
			model.put("period", period);
			
			if("Y".equals(myWorkspace)) {
				// user 소속 workspace name
				String myWorkspaceName = commonService.selectString("esm_SQL.getMyWorkspaceName",setData);
				model.put("myWorkspaceName",myWorkspaceName);
			}
			
			// 나의 그룹 할일에 YN_MANGER 체크
			String procRoleTPGroup = StringUtil.checkNull(commandMap.get("procRoleTPGroup"));
			String procRoleTPGroupMemberIDs = StringUtil.checkNull(commandMap.get("sessionUserId"));
			if("Y".equals(procRoleTPGroup)){
				// procRoleTPGroupMemberIDs 추가 
				List<HashMap> procRoleTPGroupMemberIDList = commonService.selectList("zDLM_SQL.getITUserManagerProcRoleTPGroupMember",setData);
				List<String> memberIDList = new ArrayList<>();
		        
		        for (HashMap map : procRoleTPGroupMemberIDList){
		        	String memberID = StringUtil.checkNull(map.get("MemberID"));
		                memberIDList.add(memberID.toString()); // memberID가 null이 아닐 경우 리스트에 추가
		        }
		        memberIDList.add(procRoleTPGroupMemberIDs);
		        procRoleTPGroupMemberIDs = String.join(",", memberIDList);

			}
			model.put("procRoleTPGroupMemberIDs", procRoleTPGroupMemberIDs);

			/*
			Map ispMap = new HashMap();
			
			ispMap.put("languageID", languageID);
			ispMap.put("scrnType", scrnType);
			ispMap.put("srMode", srMode);
			ispMap.put("srType", srType);
			ispMap.put("itemID", itemID);
			ispMap.put("srStatus", srStatus);
			ispMap.put("sessionUserID",commandMap.get("sessionUserId"));
			
			ispMap.put("mbrRcdMgt", StringUtil.checkNull(commandMap.get("mbrRcdMgt"))); // MyPage > 처리해야 할 업무 > 나의 할일(실적)
			ispMap.put("completionDelay", StringUtil.checkNull(commandMap.get("completionDelay"))); // MyPage > 처리해야 할 업무 > 지연업무
			ispMap.put("procRoleTPGroup", StringUtil.checkNull(commandMap.get("procRoleTPGroup"))); // MyPage > 처리해야 할 업무 > 나의 그룹 할 일
			ispMap.put("completedWork", StringUtil.checkNull(commandMap.get("completedWork"))); // MyPage > 처리해야 할 업무 > 처리한 업무 => ActivityLog 에 내가 있으면서 SR_MST.ReceiptUserID 가 내가 아닌것
			ispMap.put("guestTest", StringUtil.checkNull(commandMap.get("guestTest"))); // MyPage > 내가 요청한 업무 > 고객테스트
			ispMap.put("surveyTask", StringUtil.checkNull(commandMap.get("surveyTask"))); // MyPage > 내가 요청한 업무 > 고객테스트
			
			//권한을 통해 자기자신의 company만 봐야하는 경우가 있으면 제어
			//ispMap.put("clientID", customerNo);
			
			if("mySR".equals(srMode) || "myVOC".equals(srMode) || "myTR".equals(srMode) || "myRole".equals(srMode) || "myClient".equals(srMode) || "myPJT".equals(srMode) || "myReq".equals(srMode)){
				ispMap.put("loginUserId",commandMap.get("sessionUserId"));
			} else if("PG".equals(srMode) || "PJT".equals(srMode)){
				ispMap.put("refID",projectID);
			} else if("myTeam".equals(srMode)){
				ispMap.put("myTeamId",commandMap.get("sessionTeamId"));
			}
			
			if(StringUtil.checkNull(commandMap.get("guestTest")).equals("Y")) {
				ispMap.put("srStatus", "ACM0009");
			}
			
			if(StringUtil.checkNull(commandMap.get("surveyTask")).equals("Y")) {
				ispMap.put("srStatus", "ZSPE00");
			}
			
//			List ispList = commonService.selectList("esm_SQL.getESPSearchList_gridList",ispMap);
//			JSONArray gridData = new JSONArray(ispList);
//			model.put("gridData",gridData);
			*/
			
			if(srMode.equals("mySR")){
				model.put("requstUser", cmmMap.get("sessionUserNm"));
			}
			
			model.put("mbrRcdMgt", StringUtil.checkNull(commandMap.get("mbrRcdMgt")));
			model.put("completionDelay", StringUtil.checkNull(commandMap.get("completionDelay"))); 
			model.put("procRoleTPGroup", procRoleTPGroup); 
			model.put("completedWork", StringUtil.checkNull(commandMap.get("completedWork")));
			model.put("guestTest", StringUtil.checkNull(commandMap.get("guestTest")));
			model.put("surveyTask", StringUtil.checkNull(commandMap.get("surveyTask")));
			model.put("noReceiptYN", StringUtil.checkNull(commandMap.get("noReceiptYN")));
			model.put("mbrRcdUser", StringUtil.checkNull(commandMap.get("mbrRcdUser")));
			
			// searchOption setting 
			model.put("searchSrType", StringUtil.checkNull(request.getParameter("searchSrType")));
			model.put("searchStatus", StringUtil.checkNull(request.getParameter("searchStatus")));
			model.put("inProgress", StringUtil.checkNull(request.getParameter("inProgress")));
			model.put("stSRCompDT", StringUtil.checkNull(request.getParameter("stSRCompDT")));
			model.put("endSRCompDT", StringUtil.checkNull(request.getParameter("endSRCompDT")));
			model.put("searchSrCode", StringUtil.checkNull(request.getParameter("searchSrCode")));
			model.put("subject", StringUtil.checkNull(request.getParameter("subject")));
			model.put("regStartDate", StringUtil.checkNull(request.getParameter("regStartDate")));
			model.put("regEndDate", StringUtil.checkNull(request.getParameter("regEndDate")));
			model.put("customerNo", StringUtil.checkNull(request.getParameter("customerNo")));
			model.put("requestUser", StringUtil.checkNull(request.getParameter("requestUser")));
			model.put("requestUserID", StringUtil.checkNull(request.getParameter("requestUserID")));
			model.put("srAreaSearch", StringUtil.checkNull(request.getParameter("srAreaSearch")));
			model.put("srArea1", StringUtil.checkNull(request.getParameter("srArea1")));
			model.put("srArea2", StringUtil.checkNull(request.getParameter("srArea2")));
			
			model.put("arcCode", StringUtil.checkNull(request.getParameter("arcCode"), request.getParameter("returnMenuId")));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/registerESP.do")
	public String registerESP(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "";
		try {
				List attachFileList = new ArrayList();
				Map setMap = new HashMap();
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType")); 
				String srType = StringUtil.checkNull(cmmMap.get("srType"),request.getParameter("srType"));
				String esType = StringUtil.checkNull(cmmMap.get("esType"),request.getParameter("esType"));
				String parentId = StringUtil.checkNull(request.getParameter("parentID")); 
				String startEventCode = StringUtil.checkNull(request.getParameter("startEventCode"));
				String startSortNum = StringUtil.checkNull(request.getParameter("startSortNum"));
				String defCategory = StringUtil.checkNull(request.getParameter("defCategory"));
				String scrnType = StringUtil.checkNull(request.getParameter("scrnType"));
				String procPathID = StringUtil.checkNull(request.getParameter("procPathID"));
				String actionParameter = StringUtil.checkNull(request.getParameter("actionParameter"));
				String resultParameter = StringUtil.checkNull(request.getParameter("resultParameter"));
				String roleFilter = StringUtil.checkNull(request.getParameter("roleFilter"));
				String requestUserID = StringUtil.checkNull(request.getParameter("requestUserID"),"");
				String defSrarea = StringUtil.checkNull(request.getParameter("defSrarea"),"");
				String useOverTime = StringUtil.checkNull(request.getParameter("useOverTime"),"");
				
				url = StringUtil.checkNull(request.getParameter("url"));
				
				if("".equals(url)){
					url = "/app/esp/main/registerESP";
				}
				
				if("/custom/daelim/itsm/registerREQ".equals(url)) {
					scrnType = "REQ";
				}
				
				//임시저장된 파일이 존재할 수 있으므로 삭제
				String path=GlobalVal.FILE_UPLOAD_BASE_DIR + cmmMap.get("sessionUserId");
				if(!path.equals("")){FileUtil.deleteDirectory(path);}	
						
				// 시스템 날짜 
				Calendar cal = Calendar.getInstance();
				cal.setTime(new Date(System.currentTimeMillis()));
				String thisYmd = new SimpleDateFormat("yyyyMMdd").format(cal.getTime());

				cal.add(Calendar.DATE, +14);
				String defaultDueDate = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
				
				//cal = Calendar.getInstance();
				//cal.add(Calendar.DATE, +7);
				//String currDateAdd7 = new SimpleDateFormat("yyyyMMdd").format(cal.getTime());
				
				model.put("scrnType", scrnType );
				model.put("crMode", StringUtil.checkNull(request.getParameter("crMode")) );
				model.put("crFilePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
				model.put("menu", getLabel(request, commonService)); //  Label Setting 
				model.put("pageNum", StringUtil.checkNull(request.getParameter("pageNum"), "1"));
				model.put("thisYmd", thisYmd);
				//model.put("defaultDueDate", defaultDueDate); // default 완료 예정일
				//model.put("currDateAdd7", currDateAdd7);
				model.put("ParentID", parentId);
				model.put("srType", srType);
				model.put("esType", esType);
				model.put("ProjectID", StringUtil.checkNull(request.getParameter("ProjectID"), ""));
				model.put("srMode", StringUtil.checkNull(request.getParameter("srMode"), ""));
				model.put("startEventCode",startEventCode);
				model.put("startSortNum",startSortNum);
				model.put("defCategory",defCategory);
				model.put("procPathID",procPathID);
				model.put("actionParameter",actionParameter);
				model.put("resultParameter",resultParameter);
				model.put("roleFilter", roleFilter);
				model.put("isPopUp", StringUtil.checkNull(request.getParameter("isPopUp"), ""));
				model.put("myClient", StringUtil.checkNull(request.getParameter("myClient"), ""));
				model.put("myCSR", StringUtil.checkNull(request.getParameter("myCSR"), ""));
				model.put("isCallCenter", StringUtil.checkNull(request.getParameter("isCallCenter"), ""));
				model.put("defSrarea",defSrarea);
				model.put("useOverTime",useOverTime);
				
				Map setData = new HashMap();
				// esType 존재 시 esType 기준으로 srArea 조회
				if( esType!= null && !"".equals(esType)){
					setData.put("srType",esType);
				} else {
					setData.put("srType",srType);
				}
				
				setData.put("languageID", cmmMap.get("sessionCurrLangType"));
				setData.put("level", 1);
				String srAreaLabelNM1 = commonService.selectString("esm_SQL.getESMSRAreaLabelName",setData);
				setData.put("level", 2);
				String srAreaLabelNM2 = commonService.selectString("esm_SQL.getESMSRAreaLabelName",setData);
				
				model.put("srAreaLabelNM1", srAreaLabelNM1);
				model.put("srAreaLabelNM2", srAreaLabelNM2);
				model.put("fromSRID", StringUtil.checkNull(request.getParameter("fromSRID")));
				model.put("srArea1ListSQL", StringUtil.checkNull(request.getParameter("srArea1ListSQL")));
				
				// 요청자 memberID 넘어올 경우
				model.put("requestUserID", requestUserID);
				if(!requestUserID.equals("")) {
					setData.put("MemberID", requestUserID);
					Map userInfo = commonService.select("user_SQL.selectUser", setData);
					model.put("requestUserName", StringUtil.checkNull(userInfo.get("UserNAME")));
					model.put("requestTeamName", StringUtil.checkNull(userInfo.get("TeamName")));
				}
				
				//Call PROC_LOG START TIME
				//setInitProcLog(request);

				model.put("arcCode", StringUtil.checkNull(request.getParameter("arcCode")));
				
				// 상세화면으로 넘겨서 뒤로가기 버튼시 돌아갈 ArcMenuID
				model.put("returnMenuId", StringUtil.checkNull(request.getParameter("returnMenuId")));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@Transactional(rollbackFor = Exception.class)
	@RequestMapping(value = "/createESP.do")
	public String createESP(MultipartHttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		XSSRequestWrapper xss = new XSSRequestWrapper(request);
		try {
			HashMap setData = new HashMap();
			HashMap insertData = new HashMap();
			HashMap updateData = new HashMap();
			HashMap setMap = new HashMap();
			
			/****************************** A. parameter setting start ******************************/ 
			String maxSrId = "";
			String curmaxSRCode ="";
			String maxSRCode = "";
			String userID = "";
			String ProjectID = StringUtil.checkNull(xss.getParameter("ProjectID"));
			String proposal = StringUtil.checkNull(xss.getParameter("proposal"));
			String srMode = StringUtil.checkNull(xss.getParameter("srMode"));
			String srStatus = StringUtil.checkNull(xss.getParameter("srStatus"));
			String scrnType = StringUtil.checkNull(xss.getParameter("scrnType"));
			String esType = StringUtil.checkNull(xss.getParameter("esType"),"");
			String srType = StringUtil.checkNull(xss.getParameter("srType"));
			String requestUserID = StringUtil.checkNull(xss.getParameter("requestUserID"));
			String srArea1 = StringUtil.checkNull(xss.getParameter("srArea1"));
			String srArea2 = StringUtil.checkNull(xss.getParameter("srArea2"));
			String reqdueDate = StringUtil.checkNull(xss.getParameter("reqdueDate"));
			String dueDate = StringUtil.checkNull(xss.getParameter("dueDate"));
			String reqDueDateTime = StringUtil.checkNull(xss.getParameter("reqDueDateTime"));
			String category = StringUtil.checkNull(xss.getParameter("category"));
			String subCategory = StringUtil.checkNull(xss.getParameter("subCategory"));
			String defCategory = StringUtil.checkNull(xss.getParameter("defCategory"));
			String defSrarea = StringUtil.checkNull(xss.getParameter("defSrarea"));
			String procPathID = StringUtil.checkNull(xss.getParameter("procPathID"));
			String docCategory = StringUtil.checkNull(xss.getParameter("docCategory"),"SR");
			String isPublic = StringUtil.checkNull(xss.getParameter("isPublic"),"1"); // 0일 경우 임시저장
			
			if(!"".equals(defCategory)){
				category = defCategory;
			}
			if("".equals(srArea1) && !"".equals(defSrarea)){
				srArea1 = defSrarea;
			}
			
			String prevSRCategory = "";
			if("".equals(subCategory)){
				prevSRCategory = category;
			} else {
				prevSRCategory = subCategory;
			}
			
			String srReason = StringUtil.checkNull(xss.getParameter("srReason"));
			String itsmIF = StringUtil.checkNull(xss.getParameter("itsmIF"));
			String subject = StringUtil.checkNull(xss.getParameter("subject"));
			String description = StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(commandMap.get("description")));
			String comment = StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(commandMap.get("comment")));
			String receiveAssigned = StringUtil.checkNull(xss.getParameter("receiveAssigned"));
			String startEventCode = StringUtil.checkNull(xss.getParameter("startEventCode"));
			String startSortNum = StringUtil.checkNull(xss.getParameter("startSortNum"));
			String activityStatus = StringUtil.checkNull(xss.getParameter("activityStatus")); 
			String resultParameter = StringUtil.checkNull(xss.getParameter("resultParameter"));
			String actionParameter = StringUtil.checkNull(xss.getParameter("actionParameter"));
			
			/* customerNo(clientID) 설정 - 서비스&파트 기준 */
			String customerNo = StringUtil.checkNull(xss.getParameter("customerNo"));
			
			/* 요청자 company ID */
			setData.put("memberID", requestUserID);
			String companyID = StringUtil.checkNull(commonService.selectString("user_SQL.getMemberCompanyID", setData));
			
			setData.put("sessionUserId",requestUserID);
			// customerNo 미정 시 요청자의 customerNo
			if("".equals(customerNo)){
				customerNo = StringUtil.checkNull(commonService.selectString("user_SQL.userClientID", setData));
			}
			
			setData.put("customerNo", customerNo);
			/* dueDate 설정 */
			if(!reqDueDateTime.equals("") && !"".equals(reqdueDate)) {
				reqdueDate = reqdueDate+" "+reqDueDateTime;	
			} else if (!"".equals(reqdueDate)) {
				// TimeZone setting
				String currentTime = ESPUtil.getCurrentLocalDate("HH:mm:ss.SSS");
				reqdueDate = reqdueDate +" "+currentTime;
			}
			// TimeZone setting
			if(!"".equals(dueDate)) {
				String currentTime = ESPUtil.getCurrentLocalDate("HH:mm:ss.SSS");
				dueDate = dueDate +" "+currentTime;
				insertData.put("dueDate", dueDate);
			}
						
			/****************************** B. insertData (==> SR_MST) setting start ******************************/ 
			/* B1. 기본정보 */
			//insertData.put("srID", maxSrId);
			insertData.put("esType", esType);
			insertData.put("srType", srType);
			insertData.put("subject", subject);
			insertData.put("description", description);
			insertData.put("category", category);
			insertData.put("subCategory", subCategory);
			insertData.put("requestUserID", requestUserID);
			insertData.put("srArea1", srArea1);
			insertData.put("srArea2", srArea2);
			insertData.put("regUserID", commandMap.get("sessionUserId"));
			insertData.put("regTeamID", commandMap.get("sessionTeamId"));
			insertData.put("companyID", companyID);	
			insertData.put("clientID", customerNo);	
			insertData.put("srReason", srReason);	
			insertData.put("comment", comment);	
			insertData.put("itsmIF", itsmIF);	
			insertData.put("sessionCurrLangType", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
			insertData.put("isPublic", isPublic);
			insertData.put("prevSRCategory", prevSRCategory);
			insertData.put("reqdueDate", reqdueDate);
			
			// CustGroupID setting
			if(!"".equals(customerNo)){
				Map custMap = new HashMap();
				custMap.put("parentNo",customerNo);
				String custGRNo = StringUtil.checkNull(commonService.selectString("crm_SQL.getCustGRNo", custMap));
				insertData.put("custGRNo", custGRNo);
			}
			
			// ProjectID setting
			if(ProjectID.equals("")) {
				ProjectID = StringUtil.checkNull(ESPUtil.getEspProjectID(commonService, insertData));
			}
			insertData.put("projectID", ProjectID);
			
			/* B2. 선택된 카테고리의 접수자/접수팀  정보 취득 (procPathID / category) */
			if(!"".equals(subCategory)){
				setData.put("srCatID", subCategory);
			} else {
				setData.put("srCatID", category);
			}
			setData.put("srType", srType);
			Map RoleAssignMap =  commonService.select("esm_SQL.getESPSRAreaFromSrCat", setData);
			String SRRoleTP = StringUtil.checkNull(RoleAssignMap.get("RoleType")); // Category에 할당 된 receiver group
			
			setData.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")) );			
			setData.put("itemClassCode", "CL03004");
			
			if(!RoleAssignMap.isEmpty()){
				/*
				if(RoleAssignMap.get("SRArea").equals("SRArea1")){ 
					setData.put("srArea", srArea1 );
				}else{
					setData.put("srArea", srArea2 );
				}
				*/
				setData.put("RoleType", RoleAssignMap.get("RoleType"));	
			}
			
			if("".equals(procPathID)){
				procPathID = StringUtil.checkNull(RoleAssignMap.get("ProcPathID"));
				
				// ESM_SR_CAT_CFG 테이블에 procPathID 없을 경우 ESM_SR_CAT 에서 가져오기
				if("".equals(procPathID)){
					Map RoleAssignMap2 =  commonService.select("esm_SQL.getESMSRAreaFromSrCat", setData);
					procPathID = StringUtil.checkNull(RoleAssignMap2.get("ProcPathID"));
				}
			}
			
			insertData.put("procPathID", procPathID);
			
			setMap.put("procPathID", procPathID);
			if("".equals(startEventCode)){
				Map startEventMap = commonService.select("esm_SQL.getESPStartEventCode", setMap);
				startEventCode = StringUtil.checkNull(startEventMap.get("SRStartEventCode"));
				startSortNum = StringUtil.checkNull(startEventMap.get("SortNum"));
			}
			insertData.put("status", startEventCode); 
			insertData.put("sortNum", startSortNum);
			
			// input 에서 procRoleTP 정보 가져오기
			setData.put("speCode", startEventCode);
			Map param = ESPUtil.getStatusParams(commonService, setData);
			String procRoleTP = StringUtil.checkNull(param.get("procRoleTP"));
			insertData.put("procRoleTP", procRoleTP);	
			
			/* B3. 요청자 정보 */
			setData.put("userID", requestUserID);
			Map reqTeamInfoMap = commonService.select("user_SQL.memberTeamInfo", setData);
			insertData.put("requestTeamID",reqTeamInfoMap.get("TeamID"));
			
			/* B4. 접수자 정보 */
			Map receiptInfoMap = new HashMap();
			Map authorInfo = new HashMap();
			
			String receiptUserID ="";
			String receiptTeamID ="";
			
			// receiveAssigned 체크일 경우 접수자 = 등록자
			if("Y".equals(receiveAssigned)){
				receiptUserID = StringUtil.checkNull(commandMap.get("sessionUserId"));
				receiptTeamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
				
				insertData.put("receiptUserID", receiptUserID);
				insertData.put("receiptTeamID", receiptTeamID);
			} else {
				
				// getSRReceiver 사용하여 1선 처리자 가져오기
				Map responseUserMap = commonService.select("esm_SQL.getSRReceiver", setMap);
				
				// 바로 접수 X 현재수행자에 넣고, 접수는 따로 처리해야한다.
				String responseUserID = StringUtil.checkNull(responseUserMap.get("receiptUserID"));
				String responseTeamID = StringUtil.checkNull(responseUserMap.get("receiptTeamID"));
				insertData.put("responseUserID", responseUserID);
				insertData.put("responseTeamID", responseTeamID);
				
				insertData.put("resetRoleTP", "N");
			}
			
			/****************************** B. insertData (==> SR_MST) setting end ******************************/ 
			
			/****************************** C. insertData (==> SR_MST) start ******************************/ 
			commonService.insert("esm_SQL.insertSRMst", insertData);			
			/****************************** C. insertData (==> SR_MST) end ******************************/ 
			
			maxSrId = StringUtil.checkNull(insertData.get("SRID"));
			insertData.put("maxSrId", maxSrId);
			/****************************** D. SR 첨부파일 등록 start ******************************/
			// Sr 첨부파일 등록 : TB_SR_FILE 
			commandMap.put("speCode", startEventCode);
			commandMap.put("projectID", ProjectID);
			ESPUtil.insertESPSRFiles(commandMap, commonService, esmService, maxSrId);
			/****************************** D. SR 첨부파일 등록 end   ******************************/
			
			
			/****************************** E. activity log start ******************************/
			//Save LOG [ 완료 처리 ]
			insertData.put("speCode", startEventCode);
			insertData.put("sortNum", startSortNum);
			insertData.put("docCategory", docCategory);
			insertData.put("documentID", maxSrId);
			insertData.put("activityStatus", activityStatus);
			
			// actorID 별도 존재의 경우 insert
			String actorID = StringUtil.checkNull(xss.getParameter("actorID"));
			String actorTeamID = StringUtil.checkNull(xss.getParameter("actorTeamID"));
			if(!"".equals(actorID)){
				insertData.put("actorID", actorID);
				insertData.put("actorTeamID", actorTeamID);
			}
			
			insertData.put("srID", maxSrId);
			insertData.put("startTime", ESPUtil.getCurrentLocalDate("yyyy-MM-dd HH:mm:ss"));
			if(!"01".equals(activityStatus)) insertData.put("endTime", ESPUtil.getCurrentLocalDate("yyyy-MM-dd HH:mm:ss"));
			Map setActivityLogMapRst = (Map)ESPUtil.setActivityLog(request, commonService, insertData);
			if(setActivityLogMapRst.get("type").equals("FAILE")){
				System.out.println("SAVE PROC_LOG FAILE Msg : "+StringUtil.checkNull(setActivityLogMapRst.get("msg")));
			}
			/****************************** E.  activity log end ******************************/
			
			/****************************** F. sr attr insert start ******************************/
			// SR ATTR INSERT
			List attrList = commonService.selectList("esm_SQL.getSRAttr", insertData);
			int attrCnt = 0;
			if(attrList.size() > 0){
				for(int i=0; i < attrList.size(); i++){
					Map attrMap = (Map)attrList.get(i);
					String attrTypeCode = StringUtil.checkNull(attrMap.get("AttrTypeCode"));
					if(!"".equals(attrTypeCode)){
						String attrValue = StringUtil.checkNull(xss.getParameter(attrTypeCode));
						if(!"".equals(attrValue)){
							attrCnt ++;
							insertData.put(attrTypeCode, attrValue);
						}
					}
				}
				if(attrCnt>0){
					insertData.put("userID",StringUtil.checkNull(commandMap.get("sessionUserId")));
					ESPUtil.updateSRAttr(insertData, commonService);
				}
			}
			/****************************** F.  sr attr insert end ******************************/
			
			/****************************** G.  status update end ******************************/
			// 상태 업데이트 ([접수] / [접수 전] 상태가 아닌 경우에만 )
			if(!"".equals(startEventCode) && !"01".equals(activityStatus) && !"00".equals(activityStatus)){
				insertData.put("actionParameter", actionParameter);
				insertData.put("resultParameter", resultParameter);
				insertData.put("activityStatus", "00");
				insertData.remove("startTime");
				insertData.remove("endTime");
				insertData.remove("actorID");
				insertData.remove("actorTeamID");
				insertData.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")) );
				
				insertData.remove("dueDate");
				insertData.remove("reqdueDate");
				ESPUtil.updateESP(request, commonService, insertData);
			}
			/****************************** G.  status update end ******************************/
			
			
			model.put("scrnType",scrnType);
			model.put("srMode", srMode);
			model.put("pageNum", StringUtil.checkNull(xss.getParameter("pageNum")));
			model.put("projectID", StringUtil.checkNull(xss.getParameter("projectID")));
			model.put("srType", srType);
			model.put("esType", esType);
			model.put("customerNo", customerNo);
			model.put("defCategory", defCategory);
			model.put("srStatus", srStatus);
			model.put("srID",maxSrId);
			
			// roleGroup check
			String roleGroupNull = StringUtil.checkNull(insertData.get("roleGroupNull"));
			if("Y".equals(roleGroupNull)) {
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00178")); 
			} else {
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 
			}
			
			if(srMode.equals("N")) {
				target.put(AJAX_SCRIPT, "parent.callChildSaveMH("+maxSrId+");parent.fnGoDetail(" + maxSrId + ");parent.$('#isSubmit').remove();");
			}else {
				target.put(AJAX_SCRIPT, "parent.fnGoDetail(" + maxSrId + ");parent.$('#isSubmit').remove();");
			}
		
		} catch (Exception e) {
			System.out.println(e);
			
			// rollback
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();parent.$('#loading').fadeOut(150);$('#loading').fadeOut(150)");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	/* SR 결재상신 및 처리 후 PostProcessing */
	@RequestMapping(value = "/custom/srAprvProcessing.do")
	public String srAprvProcessing(HttpServletRequest request, HashMap cmmMap, ModelMap model, HttpServletResponse response) throws Exception {
		HashMap target = new HashMap();
		String pid = StringUtil.checkNull(cmmMap.get("pid"));
		try {
			HashMap setData = new HashMap();		
			
			String svcCompl = StringUtil.checkNull(cmmMap.get("svcCompl"));
			String wfInstanceID = StringUtil.checkNull(cmmMap.get("wfInstanceID"));
			String blockSR = StringUtil.checkNull(cmmMap.get("blockSR"));
			String srID = StringUtil.checkNull(cmmMap.get("srID"));
			String roleType = StringUtil.checkNull(cmmMap.get("roleType"));
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			
			ESPUtil.srAprvProcessingMaster(request, commonService, cmmMap);
			
			if(StringUtil.checkNull(cmmMap.get("pid")).equals("")) {
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
				target.put(AJAX_SCRIPT, "fnCallBack();");
			}
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
	
		model.addAttribute(AJAX_RESULTMAP, target);
		if(!pid.equals("")) {
			//System.out.println("pid ::::"+pid);
			Map<String, String> responseMap = new HashMap<>();
			String resMsg  = "S";
	        responseMap.put("ReturnCode", resMsg); // resMsg 값 그대로 추가

	        ObjectMapper objectMapper = new ObjectMapper();
	        String jsonResponse = objectMapper.writeValueAsString(responseMap);
	        
	        response.setHeader("Cache-Control", "no-cache");
		    response.setContentType("text/plain");
		    response.setCharacterEncoding("UTF-8");
		    
		    response.getWriter().print(jsonResponse);
	        return null;
		}else {			
			return nextUrl(AJAXPAGE);
		}
	}
	
	@RequestMapping(value = "/goTransferESPPop.do")
	public String goTransferESPPop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		String url = "/app/esp/main/transferESPPop";		
		HashMap target = new HashMap();
		try {				
				String srID = StringUtil.checkNull(request.getParameter("srID")); 
				String srType = StringUtil.checkNull(request.getParameter("srType")); 
				String esType = StringUtil.checkNull(request.getParameter("esType")); 
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
				String isPopup = StringUtil.checkNull(request.getParameter("isPopup")); 
				
				setMap.put("srType", srType);
				setMap.put("languageID", languageID);
				setMap.put("level", 1);
				String srAreaLabelNM1 = commonService.selectString("esm_SQL.getESMSRAreaLabelName",setMap);
				setMap.put("level", 2);
				String srAreaLabelNM2 = commonService.selectString("esm_SQL.getESMSRAreaLabelName",setMap);
				
				setMap.put("srID", srID);
				setMap.put("languageID", languageID);
				Map srInfoMap =  commonService.select("esm_SQL.getESMSRInfo", setMap);	
				
				model.put("srInfoMap",srInfoMap);
				model.put("srAreaLabelNM1",srAreaLabelNM1);
				model.put("srAreaLabelNM2",srAreaLabelNM2);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("isPopup",isPopup);
				
				
		} catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/transferESP.do")
	public String transferESP(HttpServletRequest request, HashMap  commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap setData = new HashMap();		
			HashMap updateData = new HashMap();
		
			String srID = StringUtil.checkNull(request.getParameter("srID"));
			String srType = StringUtil.checkNull(request.getParameter("srType"));
			String blocked = StringUtil.checkNull(request.getParameter("blocked"));
			String emailCode = StringUtil.checkNull(request.getParameter("emailCode"));
			String languageID = StringUtil.checkNull(request.getParameter("languageID"));
			
			// A. 2선이관 ( 사용안함 )
			String procRoleTP2 = StringUtil.checkNull(request.getParameter("procRoleTP2")); //변경할 roleType
			String srArea2 = StringUtil.checkNull(request.getParameter("srArea2"));
			String docCategory = StringUtil.checkNull(request.getParameter("docCategory"),"SR");
			
			// B. 업무할당
			String receiptUserID = StringUtil.checkNull(request.getParameter("receiptUserID"));
			String newReceiptUserID = StringUtil.checkNull(request.getParameter("newReceiptUserID"));
			String newReceiptTeamID = StringUtil.checkNull(request.getParameter("newReceiptTeamID"));
			String activityStatus = StringUtil.checkNull(request.getParameter("activityStatus"));
			String speCode = StringUtil.checkNull(request.getParameter("speCode"));
			String procRoleTP = StringUtil.checkNull(request.getParameter("procRoleTP"));
			
			if(blocked.equals("1")) {
				target.put(AJAX_SCRIPT, "this.fnAlertSRCmp();");
				model.addAttribute(AJAX_RESULTMAP, target);
			} else {
				// Update Data setting
				updateData.put("srID", srID);
				updateData.put("srType", srType);
				updateData.put("lastUser", commandMap.get("sessionUserId"));
				updateData.put("emailCode", emailCode);
				
				// 2선 이관
				if(!"".equals(procRoleTP2)){
					updateData.put("procRoleTP",procRoleTP2);
					updateData.put("srArea2",srArea2);
					updateData.put("languageID",commandMap.get("sessionCurrLangType"));
					updateData.put("docCategory", docCategory);
				} else {
					updateData.put("receiptUserID",newReceiptUserID);
					updateData.put("receiptTeamID",newReceiptTeamID);
					updateData.put("activityStatus", activityStatus);
					updateData.put("srGoNextYN", "N");
					updateData.put("srLogType", "U");
					updateData.put("newReceiptUserID",newReceiptUserID);
					updateData.put("languageID",commandMap.get("sessionCurrLangType"));
					
					if(!"".equals(receiptUserID)){
						setData.put("SRID", srID);
				        setData.put("LanguageID", languageID);
				        setData.put("memberID", receiptUserID);
				        setData.put("speCode", speCode);
						
				        List<HashMap> mbrList = commonService.selectList("esm_SQL.selectMbrRcd_gridList", setData);
				        
				        // 담당자 존재 할 경우 운영실적 삭제
				        if(mbrList.size() > 0){
				        	
				        	setData.put("roleType", procRoleTP);
				        	setData.put("assignmentType", "SRROLETP");
				        	commonService.delete("esm_SQL.deleteSRMbr", setData);
				        	
				        	for (HashMap deleteMap : mbrList) {
				        		// 삭제할 mbrRcdId를 기준으로 삭제 
				        		String mbrRcdID = StringUtil.checkNull(deleteMap.get("MbrRcdID"));
				        		if(!"".equals(mbrRcdID)) {
					        		deleteMap.put("mbrRcdID", mbrRcdID);
					        		commonService.delete("esm_SQL.deleteMbrRcd", deleteMap);
				        		}
				        	}
				        }
					}
				}
				
				// SR Update
				ESPUtil.updateESP(request, this.commonService, updateData);
				
				// roleGroup check
				if(!"".equals(procRoleTP2)){
					// 2선이관
					String roleGroupNull = StringUtil.checkNull(updateData.get("roleGroupNull"));
					if("Y".equals(roleGroupNull)) {
						target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00178")); 
					} else {
						target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 
					}
				}else{
					// 업무할당
					target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 
				}
				
				target.put(AJAX_SCRIPT, "fnCallBack();");
			}
			
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/selfCheckOutESP.do")
	public String selfCheckOutESP(HttpServletRequest request, HashMap  commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap setData = new HashMap();		
			HashMap updateData = new HashMap();
			HashMap setMap = new HashMap();
		
			String srID = StringUtil.checkNull(request.getParameter("srID"));
			String srType = StringUtil.checkNull(request.getParameter("srType"));
			String roleType = StringUtil.checkNull(request.getParameter("roleType"));
			String receiptUserID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String srMode = StringUtil.checkNull(request.getParameter("srMode"));
			
			setData.put("sessionUserId",receiptUserID);
			String receiptTeamID = StringUtil.checkNull(commonService.selectString("user_SQL.userTeamID", setData));
			
			// Update Data Setting
			updateData.put("receiptUserID",receiptUserID);
			updateData.put("receiptTeamID",receiptTeamID);
			updateData.put("srID", srID);
			updateData.put("lastUser", commandMap.get("sessionUserId"));
			updateData.put("languageID",commandMap.get("sessionCurrLangType"));
			updateData.put("procRoleTP", roleType);
			updateData.put("srMode", srMode);
			
			// SR Update
			ESPUtil.updateESP(request, this.commonService, updateData);
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/goChangeESPPop.do")
	public String goChangeESPPop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		String url = "/app/esp/main/changeESPPop";		
		HashMap target = new HashMap();
		try {				
				String srID = StringUtil.checkNull(request.getParameter("srID")); 
				String srType = StringUtil.checkNull(request.getParameter("srType")); 
				String esType = StringUtil.checkNull(request.getParameter("esType")); 
				String roleType = StringUtil.checkNull(request.getParameter("roleType")); 
				String srArea1ListSQL = StringUtil.checkNull(request.getParameter("srArea1ListSQL")); 
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
				String startSortNum = StringUtil.checkNull(request.getParameter("startSortNum"));
				String isPopup = StringUtil.checkNull(request.getParameter("isPopup"));
				String customUrl = StringUtil.checkNull(request.getParameter("url")); 
				
				if(!"".equals(customUrl)) url = customUrl;
				
				setMap.put("srID", srID);
				setMap.put("languageID", languageID);
				
				Map srInfoMap =  commonService.select("esm_SQL.getESMSRInfo", setMap);	
				String blocked = StringUtil.checkNull(srInfoMap.get("Blocked")); 
				if(blocked.equals("1")) {
					target.put(AJAX_SCRIPT, "this.fnAlertSRCmp();");
					model.addAttribute(AJAX_RESULTMAP, target);
				} else {
					// 보안조치
					String Description = StringUtil.checkNull(srInfoMap.get("Description")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
					
					setMap.put("LanguageID", languageID);
					model.put("srID", srID );
					model.put("srType", srType );
					model.put("esType", esType );
					model.put("roleType", roleType );
					model.put("srInfoMap", srInfoMap);
					model.put("description", Description);
					model.put("languageID", languageID);
					model.put("srArea1ListSQL", srArea1ListSQL);
					model.put("startSortNum", startSortNum);
					model.put("isPopup", isPopup);
					model.put("menu", getLabel(request, commonService)); //  Label Setting 		
				}				
		} catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/changeESP.do")
	public String changeESP(HttpServletRequest request, HashMap  commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap setData = new HashMap();		
			HashMap updateData = new HashMap();
			HashMap setMap = new HashMap();
		
			String srID = StringUtil.checkNull(request.getParameter("srID"));
			String srType = StringUtil.checkNull(request.getParameter("srType"));
			String receiptUserID = StringUtil.checkNull(request.getParameter("receiptUserID"));
			String receiptTeamID = StringUtil.checkNull(request.getParameter("receiptTeamID"));
			String srArea1 = StringUtil.checkNull(request.getParameter("srArea1"));
			String srArea2 = StringUtil.checkNull(request.getParameter("srArea2"));
			String category = StringUtil.checkNull(request.getParameter("category"));
			String subCategory = StringUtil.checkNull(request.getParameter("subCategory"));
			String customerNo = StringUtil.checkNull(request.getParameter("customerNo"));
			String transferReason = StringUtil.checkNull(request.getParameter("transferReason"));
			String startEventCode = StringUtil.checkNull(request.getParameter("startEventCode"));
			String startSortNum = StringUtil.checkNull(request.getParameter("startSortNum"),"01");
			String nowRoleTP = StringUtil.checkNull(request.getParameter("procRoleTP"));
			String speCode = StringUtil.checkNull(request.getParameter("speCode"));
			String subject = StringUtil.checkNull(request.getParameter("subject"));
			String description = StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(request.getParameter("description")));
			String activityStatus = StringUtil.checkNull(request.getParameter("activityStatus")); 
			String ProjectID = StringUtil.checkNull(request.getParameter("projectID"));
			String docCategory = StringUtil.checkNull(request.getParameter("docCategory"),"SR");
			String actionParameter = StringUtil.checkNull(request.getParameter("actionParameter"));
			String resultParameter = StringUtil.checkNull(request.getParameter("resultParameter"));
			String defCategory = StringUtil.checkNull(request.getParameter("defCategory"));
			String isPopup = StringUtil.checkNull(request.getParameter("isPopup"));
			String requestUserID = StringUtil.checkNull(request.getParameter("requestUserID"));
			String requestTeamID = StringUtil.checkNull(request.getParameter("requestTeamID"));
			String reqdueDate = StringUtil.checkNull(request.getParameter("reqdueDate"));
			
			String prevSRCategory = StringUtil.checkNull(request.getParameter("prevSRCategory"));
			String prevSRType = StringUtil.checkNull(request.getParameter("prevSRType"));
			
			// TimeZone
			if(!"".equals(reqdueDate)) reqdueDate = ESPUtil.changeTimeZoneDateType(reqdueDate);
			
			// get change procPathID
			if(!"".equals(defCategory)){
				category = defCategory;
			}
			/* B2. 선택된 카테고리의 접수자/접수팀  정보 취득 (procPathID / category) */
			if(!"".equals(subCategory)){
				setData.put("srCatID", subCategory);
			} else {
				setData.put("srCatID", category);
			}
			
			setData.put("srType", srType);
			setData.put("customerNo", customerNo);
			Map RoleAssignMap =  commonService.select("esm_SQL.getESPSRAreaFromSrCat", setData);
			
			String procPathID = "";
			if(!RoleAssignMap.isEmpty()){
				procPathID = StringUtil.checkNull(RoleAssignMap.get("ProcPathID"));
			}
			
			setMap.put("procPathID", procPathID);
			setMap.put("sortNum", startSortNum);
			Map startEventMap = commonService.select("esm_SQL.getESPStartEventCode", setMap);
			
			startEventCode = StringUtil.checkNull(startEventMap.get("SRStartEventCode"));
			startSortNum = StringUtil.checkNull(startEventMap.get("SortNum"));

			// ProjectID setting
			if(ProjectID.equals("")) {
				ProjectID = StringUtil.checkNull(ESPUtil.getEspProjectID(commonService, updateData));
			}
			commandMap.put("projectID", ProjectID);
			// Sr 첨부파일 등록 : TB_SR_FILE 
			ESPUtil.insertESPSRFiles(commandMap, commonService, esmService, srID);
			
			// update sr mst
			updateData.put("srType", srType);
			updateData.put("procPathID", procPathID);
			updateData.put("status", startEventCode); 
			updateData.put("sortNum", startSortNum);
			updateData.put("receiptUserID", receiptUserID);
			updateData.put("receiptTeamID", receiptTeamID);
			updateData.put("docCategory","SR");
			updateData.put("srID", srID);
			updateData.put("lastUser", commandMap.get("sessionUserId"));
			updateData.put("srArea1",srArea1);
			updateData.put("srArea2",srArea2);
			updateData.put("category",category);
			updateData.put("subCategory",subCategory);
			updateData.put("subject", subject);
			updateData.put("requestUserID", requestUserID);
			updateData.put("requestTeamID", requestTeamID);
			updateData.put("description", description);
			updateData.put("actionParameter", actionParameter);
			updateData.put("resultParameter", resultParameter);
			updateData.put("reqdueDate", reqdueDate);
			
			// SR UPDATE
			commonService.update("esm_SQL.updateESMSR", updateData);
			
			updateData.put("prevSRCategory", prevSRCategory);
			updateData.put("prevSRType", prevSRType);
			
			//Save LOG ( 기존 REQ Activity 완료처리 )
			updateData.put("speCode", speCode);
			updateData.put("activityStatus", "05");
			updateData.put("endTime", ESPUtil.getCurrentLocalDate("yyyy-MM-dd HH:mm:ss"));
			Map setActivityLogMapRst = (Map)ESPUtil.updateActivityLog(request, commonService, updateData);
			if(setActivityLogMapRst.get("type").equals("FAILE")){
				System.out.println("SAVE PROC_LOG FAILE Msg : "+StringUtil.checkNull(setActivityLogMapRst.get("msg")));
			}
			
			//Save LOG ( 임시저장 - 접수 / 등록 - 완료처리 )
			updateData.put("speCode", startEventCode);
			updateData.put("sortNum", startSortNum);
			updateData.put("docCategory", docCategory);
			updateData.put("documentID", srID);
			updateData.put("activityStatus", activityStatus);
			updateData.put("startTime", ESPUtil.getCurrentLocalDate("yyyy-MM-dd HH:mm:ss"));
			
			if(!"01".equals(activityStatus)) updateData.put("endTime", ESPUtil.getCurrentLocalDate("yyyy-MM-dd HH:mm:ss"));
			setActivityLogMapRst = (Map)ESPUtil.setActivityLog(request, commonService, updateData);
			if(setActivityLogMapRst.get("type").equals("FAILE")){
				System.out.println("SAVE PROC_LOG FAILE Msg : "+StringUtil.checkNull(setActivityLogMapRst.get("msg")));
			}
			
			// SR ATTR INSERT
			List attrList = commonService.selectList("esm_SQL.getSRAttr", updateData);
			int attrCnt = 0;
			if(attrList.size() > 0){
				for(int i=0; i < attrList.size(); i++){
					Map attrMap = (Map)attrList.get(i);
					String attrTypeCode = StringUtil.checkNull(attrMap.get("AttrTypeCode"));
					if(!"".equals(attrTypeCode)){
						String attrValue = StringUtil.checkNull(request.getParameter(attrTypeCode));
						if(!"".equals(attrValue)){
							attrCnt ++;
							updateData.put(attrTypeCode, attrValue);
						}
					}
				}
				if(attrCnt>0){
					updateData.put("userID",StringUtil.checkNull(commandMap.get("sessionUserId")));
					ESPUtil.updateSRAttr(updateData, commonService);
				}
			}
			
			// 상태 업데이트 ([등록]일 경우 )
			if(!"".equals(startSortNum) && !"01".equals(activityStatus) && !"00".equals(activityStatus)){
				updateData.put("activityStatus", "00");
				updateData.remove("startTime");
				updateData.remove("endTime");
				updateData.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")) );
				ESPUtil.updateESP(request, commonService, updateData);
			}
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.fnCallBack(" + srID + ",'" + srType + "'," + isPopup + ");");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	// SR 강제종료
	@RequestMapping(value = "/forceQuitESP.do")
	public String forceQuitESP(HttpServletRequest request, HashMap  commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap setData = new HashMap();	
			HashMap setMap = new HashMap();	
			HashMap updateData = new HashMap();
		
			String srID = StringUtil.checkNull(commandMap.get("srID"));
			String activityComment = StringUtil.checkNull(commandMap.get("activityComment")); //강제종료 사유
			String svcCompl = "Y";
			String blocked = "2";
			String activityStatus = "08"; // 강제종료
			String lastUser = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String actorTeamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
			String sessionAuthLev = StringUtil.checkNull(commandMap.get("sessionAuthLev")); // 시스템 관리자
				
			// Update Data Setting
			updateData.put("srID", srID);
			updateData.put("activityComment", activityComment);	
			updateData.put("activityStatus", activityStatus);	
			updateData.put("lastUser", lastUser);
			updateData.put("actorID", lastUser);
			updateData.put("actorTeamID", actorTeamID);
			updateData.put("svcCompl", svcCompl);
			updateData.put("blocked", blocked);
			updateData.put("srGoNextYN", "N"); // SR 다음단계 진행 X
			updateData.put("srLogType", "U"); // 로그 다음단계 진행 X
			updateData.put("startTime", ESPUtil.getCurrentLocalDate("yyyy-MM-dd HH:mm:ss"));
			updateData.put("maxSeq", "Y");
			
			// SR Update
			if("1".equals(sessionAuthLev)){
				ESPUtil.updateESP(request, this.commonService, updateData);
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			} else {
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00033")); // 권한 없음
			}
			target.put(AJAX_SCRIPT, "fnCallBackSR()");
			
			
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	// Activity Status 되돌리기
	@RequestMapping(value = "/UndoActivityStatus.do")
	public String UndoActivityStatus(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap setMap = new HashMap();	
			HashMap updateData = new HashMap();
		
			String srID = StringUtil.checkNull(request.getParameter("srID"));
			String srType = StringUtil.checkNull(request.getParameter("srType"));
			String status = StringUtil.checkNull(request.getParameter("status"));
			String sortNum = StringUtil.checkNull(request.getParameter("sortNum"));
			String comment = StringUtil.checkNull(request.getParameter("comment"));
			String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String userTeamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
			String languageID = StringUtil.checkNull(request.getParameter("languageID"));
			String activityStatus = StringUtil.checkNull(request.getParameter("activityStatus"));
			String docCategory = StringUtil.checkNull(request.getParameter("docCategory"),"SR");
			
			String preReceiptUserID = ""; // 이전 담당자
			String preReceiptTeamID = ""; // 이전 담당자 팀
			
			// get now status 
			setMap.put("srID", srID);
			setMap.put("status", status);	
			String seq = StringUtil.checkNull(commonService.selectString("esm_SQL.getSeqActivityLog", setMap));
			
			if("".equals(sortNum)) sortNum = StringUtil.checkNull(commonService.selectString("esm_SQL.getESPStatusSortNum", setMap));
			setMap.put("sortNum", sortNum);
			setMap.put("wfCheck", "Y"); // 현재 상태가 결재 상태일 때 되돌리기 불가
			setMap.put("seq",seq);
			
			// get pre status
			String preEvent = StringUtil.checkNull(commonService.selectString("esm_SQL.getESPPreEventCode", setMap));
			String[] preEvents = preEvent.split("/");
			String PreSpeCode = StringUtil.checkNull(preEvents[0]);
			String PreSortNum = StringUtil.checkNull(preEvents[1]);
			
			// 전 단계가 WFInstanceID가 있거나, 고객테스트 or 01 단계일 경우 NULL값 출력
			Map preCheckMap = new HashMap();
			preCheckMap.put("srID", srID);
			preCheckMap.put("status", PreSpeCode);
			String preSeq = StringUtil.checkNull(commonService.selectString("esm_SQL.getSeqActivityLog", preCheckMap));
			preCheckMap.put("sortNum", PreSortNum);
			preCheckMap.put("wfCheck", "Y");
			preCheckMap.put("seq", preSeq);
			String preEventChk = StringUtil.checkNull(commonService.selectString("esm_SQL.getESPPreEventCode", preCheckMap));
			
			if(!"".equals(preEventChk)){
				
				// SR Update ( 이전단계 )
				updateData.put("srID", srID);
				updateData.put("status", PreSpeCode);
				updateData.put("speCode",PreSpeCode);
				updateData.put("languageID", languageID);
				
				Map param = ESPUtil.getStatusParams(commonService, updateData);
				updateData.putAll(param);
				
				// procRoleTP 예외 체크
				String procRoleTP = StringUtil.checkNull(commonService.selectString("esm_SQL.getESPProcRoleTP",preCheckMap)); // next procRoleTP 예외처리 체크
				// * 예외 없을 경우 다음단계의 input의 procRoleTP 체크 후 업데이트 
				if(!"".equals(procRoleTP)){
					updateData.remove("procRoleTP");
					updateData.put("procRoleTP", procRoleTP);
				}
				
				// 담당자 되돌리기
				preCheckMap.put("speCode", PreSpeCode);
				List logList = commonService.selectList("esm_SQL.getESMProLogInfo_gridList", preCheckMap);
				if(logList.size() > 0){
					Map logMap = (Map)logList.get(0);
					preReceiptUserID = StringUtil.checkNull(logMap.get("ActorID"));
					preReceiptTeamID = StringUtil.checkNull(logMap.get("TeamID"));
					updateData.put("receiptUserID", preReceiptUserID);
					updateData.put("receiptTeamID", preReceiptTeamID);		
				}
				
				updateData.put("sortNum", PreSortNum);
				updateData.put("comment", comment);	
				updateData.put("lastUser", userID);
				commonService.update("esm_SQL.updateESMSR", updateData); // *lastUser *srID
				
				// get nextSeq ( activity Log 저장용 )
				int nextActivitySeq = Integer.parseInt(preSeq) + 1;
				
				// 접수전에 되돌리기를 한 경우 접수전 activityLog 삭제
				if("00".equals(activityStatus)){
					Map delMap = new HashMap();
					delMap.put("PID",srID);
					delMap.put("SpeCode",status);
					delMap.put("maxSeq", "Y");
					commonService.update("esm_SQL.deleteActivityLog", delMap); // *lastUser *srID
				}else if ("01".equals(activityStatus)){
					// 접수 후에 되돌리기를 한 경우
					Map setActivityLogMapRst = new HashMap();
					Map updateLogMap = new HashMap();
					updateLogMap.put("srID", srID);
					updateLogMap.put("activitySeq", seq);
					updateLogMap.put("srType", srType);
					updateLogMap.put("speCode", status);
					updateLogMap.put("actorID", userID);
					updateLogMap.put("actorTeamID", userTeamID);
					updateLogMap.put("activityStatus", "07");
					updateLogMap.put("endTime", ESPUtil.getCurrentLocalDate("yyyy-MM-dd HH:mm:ss"));
					setActivityLogMapRst = (Map)ESPUtil.updateActivityLog(request, commonService, updateLogMap);
				}
				
				// LOG UPDATE ( 기존 Log >> 되돌리기 )
				Map setActivityLogMapRst = new HashMap();
				Map updateLogMap = new HashMap();
				updateLogMap.put("srID", srID);
				//updateLogMap.put("activitySeq", seq);
				updateLogMap.put("maxSeq", "Y");
				updateLogMap.put("srType", srType);
				updateLogMap.put("speCode", PreSpeCode);
				updateLogMap.put("actorID", userID);
				updateLogMap.put("actorTeamID", userTeamID);
				updateLogMap.put("activityStatus", "07");
				updateLogMap.put("endTime", ESPUtil.getCurrentLocalDate("yyyy-MM-dd HH:mm:ss"));
				setActivityLogMapRst = (Map)ESPUtil.updateActivityLog(request, commonService, updateLogMap);
				
				// LOG INSERT ( 접수 ) - insert new pre status
				updateData.put("srType", srType);
				updateData.put("activitySeq",nextActivitySeq);
				updateData.put("activityStatus", "01");
				updateData.put("actorID", preReceiptUserID);
				updateData.put("actorTeamID", preReceiptTeamID);
				updateData.put("docCategory", docCategory);
				updateData.put("startTime", ESPUtil.getCurrentLocalDate("yyyy-MM-dd HH:mm:ss"));
				setActivityLogMapRst = (Map)ESPUtil.setActivityLog(request, commonService, updateData);
				

				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			} else {
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생 ( 이전단계가 요청 or 결재상신 )
			}
			target.put(AJAX_SCRIPT, "fnCallBackSR();");
			
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
		
		// LOG VIEW ( 이관예정 )
		@RequestMapping(value = "/espActivityLogList.do")
		public String viewActivityLog(HttpServletRequest request, HashMap cmmMap, HashMap commandMap, ModelMap model) throws Exception {
			String url = "/app/esp/main/espActivityLogList";
			Map setMap = new HashMap();
			try {
				String srID = StringUtil.checkNull(request.getParameter("srID"));
				String srCode = StringUtil.checkNull(request.getParameter("srCode"));
				String languageID = StringUtil.checkNull(request.getParameter("languageID"));
				String srType = StringUtil.checkNull(request.getParameter("srType"));
				String speCode = StringUtil.checkNull(request.getParameter("speCode"));
				if("".equals(languageID)) languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
				String dueDate = StringUtil.checkNull(request.getParameter("dueDate"));
				
				setMap.put("customerNo", StringUtil.checkNull(request.getParameter("clientID")));
				model.put("inhouse",StringUtil.checkNull(commonService.selectString("esm_SQL.getInhouseYN", setMap)));
				
				setMap.put("srID", srID);
				setMap.put("languageID", languageID);
				List logList = commonService.selectList("esm_SQL.getESMProLogInfo_gridList", setMap);
				
				if(!"".equals(dueDate) && !"REQ".equals(srType) && !"WRK".equals(srType) && !"INC".equals(srType)){
					model.put("espDueDateMgt", "V");
				}
				
				JSONArray jsonLogList = new JSONArray(logList);
				model.put("jsonLogList",jsonLogList);
				model.put("logList", logList);
				model.put("srID", srID);
				model.put("srCode", srCode);
				model.put("srType", srType);
				model.put("speCode", speCode);
				model.put("languageID", languageID);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("defApprovalSystem", GlobalVal.DEF_APPROVAL_SYSTEM);
				//  결재 상세 페이지 url 취득
				setMap.put("DocCategory", "SPE"); 
				model.put("wfURL", StringUtil.checkNull(commonService.selectString("wf_SQL.getWFCategoryURL", setMap)) );
			} catch (Exception e) {
				System.out.println(e.toString());
			}
			return nextUrl(url);
		}
		
	    @RequestMapping(value = "/olmapi/espActivityAttr", method = RequestMethod.GET)
		@ResponseBody
		public void espActivityAttr(HttpServletRequest request, HttpServletResponse response) throws Exception {
			Map setMap = new HashMap();
			try {
		        String srID = StringUtil.checkNull(request.getParameter("srID"),"");
		        String languageID = StringUtil.checkNull(request.getParameter("languageID"),"");
		        String speCode = StringUtil.checkNull(request.getParameter("speCode"),"");
		        String srType = StringUtil.checkNull(request.getParameter("srType"),"");
		        String activitySeq = StringUtil.checkNull(request.getParameter("activitySeq"),"");
		        String docCategory = StringUtil.checkNull(request.getParameter("docCategory"),"SR");
		        
		        setMap.put("srID",srID);
		        setMap.put("languageID", languageID);
		        setMap.put("speCode", speCode);
		        setMap.put("srType", srType);
		        setMap.put("docCategory", docCategory);
		        setMap.put("activitySeq", activitySeq);
		        setMap.put("showInvisible", "N");
		        
		        // SR ATTR
		        // * Rev 테이블에 ActivitySeq 로 조건 검색 시 건수 존재하면 REV 로 출력
		        String RevCnt = commonService.selectString("esm_SQL.getSRAttrRevCount", setMap);
		        List result = new ArrayList();
		        
		        if(!"0".equals(RevCnt) && !"".equals(RevCnt)){
		        	List srAttrRevList = (List)commonService.selectList("esm_SQL.getSRAttrRevList", setMap);
		        	result = ESPUtil.getSRAttrRevList(commonService, srAttrRevList, setMap, languageID);
		        } else {
		        	result = (List)commonService.selectList("esm_SQL.getSRAttr", setMap);
//		        	result = ESPUtil.getSRAttrList(commonService, srAttrList, setMap, languageID);
		        }
				
		        JSONArray data = new JSONArray(result);
		        sendToJson(StringUtil.checkNull(data), response);
	        } catch (Exception e) {
	            System.out.println(e);
	        }
		}
	    
	    @RequestMapping(value = "/olmapi/espActivityOutput", method = RequestMethod.GET)
		@ResponseBody
		public void espActivityOutput(HttpServletRequest request, HttpServletResponse response) throws Exception {
			Map setMap = new HashMap();
			try {
		        String srID = StringUtil.checkNull(request.getParameter("srID"),"");
				setMap.put("srID", srID);
				List mbrRcd = commonService.selectList("esm_SQL.selectMbrRcd", setMap);
		        
		        JSONArray data = new JSONArray(mbrRcd);
		        sendToJson(StringUtil.checkNull(data), response);
	        } catch (Exception e) {
	            System.out.println(e);
	        }
		}
	    
		public static void sendToJson(String jObj, HttpServletResponse res) {
			try {
				res.setHeader("Cache-Control", "no-cache");
				res.setContentType("text/plain");
				res.setCharacterEncoding("UTF-8");
				if(!jObj.equals("{data: [ ]}")){
					res.getWriter().print(jObj);
				}
				else {
					PrintWriter pw = res.getWriter();
					pw.write("데이터가 존재하지 않습니다.");
				}			
			} catch (IOException e) {
				MessageHandler.getMessage("json.send.message");
				e.printStackTrace();
			}
		}
		
		@RequestMapping(value = "/espWorkerRecordList.do")
		public String viewWorkerRecord(HttpServletRequest request, HashMap cmmMap, HashMap commandMap, ModelMap model) throws Exception {
			String url = "/app/esp/main/espWorkerRecordList";
			Map setMap = new HashMap();
			try {
				String srID = StringUtil.checkNull(request.getParameter("srID"));
				String languageID = StringUtil.checkNull(request.getParameter("languageID"));
				
				model.put("srID", srID);
				model.put("languageID", languageID);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				
				if("".equals(languageID)) languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
				
				setMap.put("srID", srID);
				setMap.put("languageID", languageID);
				
				List roleList = commonService.selectList("esm_SQL.getRoleRecord_gridList", setMap);
				List MemberList = commonService.selectList("esm_SQL.getMemberRecord_gridList", setMap);
				for(int i=0; i < MemberList.size(); i++) {
					roleList.add(MemberList.get(i));
				}
				
				JSONArray treeGridData = new JSONArray(roleList);
				model.put("treeGridData",treeGridData);
			} catch (Exception e) {
				System.out.println(e.toString());
			}
			return nextUrl(url);
		}
		
		@RequestMapping(value = "/espFileList.do")
		public String espFileList(HttpServletRequest request, HashMap cmmMap, HashMap commandMap, ModelMap model) throws Exception {
			String url = "/app/esp/main/espFileList";
			Map setData = new HashMap();
			try {
				String srID = StringUtil.checkNull(request.getParameter("srID"));
				String srType = StringUtil.checkNull(request.getParameter("srType"),"ITSP");
				
				/*
				setData.put("srType", srType);
				setData.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
				setData.put("level", 1);
				String srAreaLabelNM1 = commonService.selectString("esm_SQL.getESMSRAreaLabelName",setData);
				setData.put("level", 2);
				String srAreaLabelNM2 = commonService.selectString("esm_SQL.getESMSRAreaLabelName",setData);
				
				model.put("srAreaLabelNM1",srAreaLabelNM1);
				model.put("srAreaLabelNM2",srAreaLabelNM2);
				*/
				
				model.put("srID", srID);
				model.put("srType", srType);
				model.put("myCSR", StringUtil.checkNull(request.getParameter("myCSR")));
				model.put("myWorkspace", StringUtil.checkNull(request.getParameter("myWorkspace")));
				model.put("myActivity", StringUtil.checkNull(request.getParameter("myActivity")));
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("period", StringUtil.checkNull(request.getParameter("period")));

				model.put("arcCode", StringUtil.checkNull(request.getParameter("arcCode")));
			} catch (Exception e) {
				System.out.println(e.toString());
			}
			return nextUrl(url);
		}
		
		@RequestMapping(value = "/olmapi/espButtonList", method = RequestMethod.GET)
		@ResponseBody
		public void espButtonList(HttpServletRequest request, HttpServletResponse response) throws Exception {
			Map setMap = new HashMap();
			try {
				
				
				String checkOutYN = "N";
				
				String srID = StringUtil.checkNull(request.getParameter("srID"));
				String srCode = StringUtil.checkNull(request.getParameter("srCode"));
				String procRoleTP = StringUtil.checkNull(request.getParameter("procRoleTP")); 
				String receiptUserID = StringUtil.checkNull(request.getParameter("receiptUserID"));
				String regUserID = StringUtil.checkNull(request.getParameter("regUserID"));
				String srArea1 = StringUtil.checkNull(request.getParameter("srArea1"));
				String srArea2 = StringUtil.checkNull(request.getParameter("srArea2"));
				String activityStatus = StringUtil.checkNull(request.getParameter("activityStatus"));
				String activityBlocked = StringUtil.checkNull(request.getParameter("activityBlocked"));
				String aprvBlock = StringUtil.checkNull(request.getParameter("aprvBlock")); //선처리
				String aprvYN = "N";
				String delBtn = StringUtil.checkNull(request.getParameter("delBtn"));
				String speCode = StringUtil.checkNull(request.getParameter("speCode"));
				String isPublic = StringUtil.checkNull(request.getParameter("isPublic"));
				String SRStatusName = StringUtil.checkNull(request.getParameter("SRStatusName"));
				String clientID = StringUtil.checkNull(request.getParameter("clientID"));
				String isEditableAfterReception = StringUtil.checkNull(request.getParameter("isEditableAfterReception"));
				
				String languageID = StringUtil.checkNull(request.getParameter("languageID"));
				String sessionUserId = StringUtil.checkNull(request.getParameter("sessionUserId"));
				String sessionAuthLev = StringUtil.checkNull(request.getParameter("sessionAuthLev"));
				
				setMap.put("languageID", languageID);
				
				// 01. wf check ( 선처리에 사용 )
				// *aprvBlock 이 2일 경우, 승인중인 WFInstanceID 로 체크해야함
				String wfInstanceID = "";
				if("2".equals(aprvBlock)) {
					setMap.put("srID", srID);
					setMap.put("activityStatusList", "'02'"); // 승인중
					List logList = commonService.selectList("esm_SQL.getESMProLogInfo_gridList", setMap); //ProcRoleTP
					setMap.remove("activityStatusList");
					
					if(logList.size() > 0){
						Map logMap = (Map) logList.get(0);
						wfInstanceID = StringUtil.checkNull(logMap.get("ActivityWFInstanceID"));
					}
				}
				
				// 02. procRoleTP 권한 Check
				setMap.put("SRID",srID);
				setMap.put("RoleType", procRoleTP);
				
				if(!"0".equals(srArea2) && !"".equals(srArea2)){
					setMap.put("srArea", srArea2);
				} else {
					setMap.put("srArea", srArea1);
				}
				
				if("0".equals(receiptUserID) || "".equals(receiptUserID)){
					setMap.put("clientID", clientID);
					List RoleTPList = commonService.selectList("esm_SQL.getReceiptUserList", setMap);
					setMap.remove("clientID");
					String RoleTPID = "";
					if(RoleTPList.size()>0){
						for(int i=0; i<RoleTPList.size(); i++){
							Map RoleMap = (Map)RoleTPList.get(i);
							RoleTPID = StringUtil.checkNull(RoleMap.get("CODE"));
							if(RoleTPID.equals(sessionUserId))checkOutYN = "Y";
						}
					}
				} else if (sessionUserId.equals(receiptUserID)){
					checkOutYN = "Y";
				}
				
				// 03. 버튼 담을 List 생성
				Map btnMap = new HashMap();
				int cnt = 1;
				String[] values;
				
				List btnList = new ArrayList<>();
				
				
				// 04.  되돌리기 및 선처리 및 삭제
				if(("01".equals(activityStatus) || "00".equals(activityStatus))){
					
					String undoYN = "N";
					setMap.put("srID", srID);
					setMap.put("notInActivityStatusList", "'07'");
					setMap.put("SortNum", "2");
					Map logMap = commonService.select("esm_SQL.getESMPreLogInfo", setMap); //ProcRoleTP
					
					// 전단계 정보
					String preActorID = StringUtil.checkNull(logMap.get("ActorID"));
					String preProcRoleTP = StringUtil.checkNull(logMap.get("ProcRoleTP"));
					String preWfInstanceID = StringUtil.checkNull(logMap.get("WFInstanceID"));
					String preactivityStatus = StringUtil.checkNull(logMap.get("Status"));
					String preSortNum = StringUtil.checkNull(logMap.get("SortNum"));
					
					if(!procRoleTP.equals("CLIENT") && !"0".equals(isPublic)){
						// [04-1].선처리 ( 전단계 상태가 [승인 중]/[재상신] 일 경우 )
						if(("10".equals(preactivityStatus) || "02".equals(preactivityStatus))
								&& "00".equals(activityStatus) && "Y".equals(checkOutYN)){
							aprvYN = "Y";
							values = new String[] {"secondary","preProcessing", "LN0018", "fnPreprocessing()"};
							btnMap = ESPUtil.setButtonMap(cnt++,values);
							btnList.add(btnMap);
						}
						
						// [04-2].되돌리기 ( 현 단계 접수전 (전단계 담당자) / 접수 (현단계 담당자) / 관리자 )
						// sortNum = 01 항목 / 고객 테스트 / WFInstance 존재 건 / 전부 되돌리기 불가능
						if("".equals(preWfInstanceID) && !"".equals(preProcRoleTP) && !"CLIENT".equals(preProcRoleTP)) {
							if("00".equals(activityStatus) && !"1".equals(activityBlocked) && sessionUserId.equals(preActorID)){ // 접수 전 + 전단계 담당자 인지 체크
								undoYN = "Y";
							} else if("01".equals(activityStatus) && !"1".equals(activityBlocked) && sessionUserId.equals(receiptUserID)){ // 접수 + 현단계 담당자 인지 체크
								undoYN = "Y";
							} else if("1".equals(sessionAuthLev) && !"1".equals(activityBlocked)){ // 관리자
								undoYN = "Y";
							}
						}
						
						if("Y".equals(undoYN) && "N".equals(aprvYN)){
							values = new String[] {"secondary","undo", "LN0019", "fnUndoActivityStatus()"};
							btnMap = ESPUtil.setButtonMap(cnt++,values);
							btnList.add(btnMap);
						}
					}
					
				}
				
				
				// 05. 현재 이벤트(Status)에 할당된 function List 가져오기 ( 임시저장이 아닌 경우 )
				List menuList = new ArrayList();
				List functionList = new ArrayList();
				if(!"0".equals(isPublic)){
					setMap.put("menuCat", "SR");
					menuList = commonService.selectList("config_SQL.getMenuList_gridList", setMap);
					setMap.put("identifier", speCode);
					setMap.put("attrTypeCode", "SRAT0000");
					functionList = commonService.selectList("item_SQL.getPlainTextByIdentifier", setMap);
				}
				
				// 06. activity Button add ( 선처리일 경우 선처리버튼만 나와야함 )
				if("N".equals(aprvYN)&&"Y".equals(checkOutYN) && !"05".equals(activityStatus) && !"1".equals(activityBlocked)){
					
					// [06-1].요청자 Event가 아닐경우 + 승인중이 아닐 경우
					if(!"CLIENT".equals(procRoleTP) && !"0".equals(isPublic) && !"02".equals(activityStatus)){
						// A.보류
						values = new String[] {"secondary","hold", "LN0015", "fnSaveActivityAttr('09')"};
						btnMap = ESPUtil.setButtonMap(cnt++,values);
						btnList.add(btnMap);
						
						// B.업무할당
						values = new String[] {"secondary","transfer", "LN0016", "fnTransferESP()"};
						btnMap = ESPUtil.setButtonMap(cnt++,values);
						btnList.add(btnMap);
					}
					// [06-2].접수 전 일 때
					if("00".equals(activityStatus)){
						
						// D.반려,기각 (function List)
						if(!"N".equals(isEditableAfterReception)){
							for(int i=0; i<menuList.size(); i++){
								Map menuMap = (Map) menuList.get(i);
								if(menuMap.get("MenuID").equals("PGR00002") || menuMap.get("MenuID").equals("PGR00007")){
									for(int j=0; j<functionList.size(); j++){
										if(functionList.get(j).equals(menuMap.get("MenuID"))){
											values = new String[] {"secondary",StringUtil.checkNull(menuMap.get("MenuID")), StringUtil.checkNull(menuMap.get("VarFilter")), StringUtil.checkNull(menuMap.get("URL"))};
											btnMap = ESPUtil.setButtonMap(cnt++,values);
											btnList.add(btnMap);
										}
									}
								}
							}
						}
						
						// C.접수
						values = new String[] {"primary", "recept", "LN0017", "fnSaveActivityAttr('01')"};
						btnMap = ESPUtil.setButtonMap(cnt++,values);
						btnList.add(btnMap);
					}
					// [06-3].접수 일 때
					else if("01".equals(activityStatus)){

						// G.그 외 function List (* 선처리옵션이 2가 아니거나 2인 경우 선처리가 완료된 경우 ( wfInstance 체크 필수 * 없으면 공문처리 ))
						if(!"2".equals(aprvBlock)
								|| ("2".equals(aprvBlock) && "".equals(wfInstanceID))){
							for(int i=0; i<menuList.size(); i++){
								Map menuMap = (Map) menuList.get(i);
								for(int j=0; j<functionList.size(); j++){
									if(functionList.get(j).equals(menuMap.get("MenuID"))){
										String cls = "secondary";
										if(menuMap.get("MenuID").equals("PGR00008")) cls = "primary"; // 승인요청만 색 변경
										values = new String[] {cls,StringUtil.checkNull(menuMap.get("MenuID")), StringUtil.checkNull(menuMap.get("VarFilter")), StringUtil.checkNull(menuMap.get("URL"))};
										btnMap = ESPUtil.setButtonMap(cnt++,values);
										btnList.add(btnMap);
									}
								}
							}
						}
						
						// E.저장
						values = new String[] {"primary", "save", "LN0014", "fnSaveActivityAttr('')"};
						btnMap = ESPUtil.setButtonMap(cnt++,values);
						btnList.add(btnMap);
						
						// F.완료 (* 선처리옵션이 없거나 2인 경우 선처리가 완료된 경우 ( wfInstance 체크 필수 * 없으면 공문처리  혹은 선처리 완료됨))
						if(("".equals(aprvBlock) && !"05".equals(delBtn)) 
								|| ("2".equals(aprvBlock) && "".equals(wfInstanceID))){
							values = new String[] {"primary", "complete", "LN0023", "fnSaveActivityAttr('05')"};
							btnMap = ESPUtil.setButtonMap(cnt++,values);
							btnList.add(btnMap);
						}
						
					}
				}
				// [06-4].activity가 blocked일 경우
				else if("N".equals(aprvYN)&&"Y".equals(checkOutYN) && !"05".equals(activityStatus) && "1".equals(activityBlocked)){
					// H.보류해제
					if("09".equals(activityStatus)){
						String newStatus = "";
						values = new String[] {"secondary","unHold", "LN0024", "fnCancelHold()"};
						btnMap = ESPUtil.setButtonMap(cnt++,values);
						btnList.add(btnMap);
					}
				}
				
				JSONArray data = new JSONArray(btnList);
				sendToJson(StringUtil.checkNull(data), response);
				
	        } catch (Exception e) {
	            System.out.println(e);
	        }
		}
		
		@RequestMapping(value = "/olmapi/espAttrLovList", method = RequestMethod.GET)
		@ResponseBody
		public void espAttrLovList(HttpServletRequest request, HttpServletResponse response) throws Exception {
			Map setMap = new HashMap();
			try {
				
				String srID = StringUtil.checkNull(request.getParameter("srID")); 
				String srType = StringUtil.checkNull(request.getParameter("srType")); 
				String customerNo = StringUtil.checkNull(request.getParameter("customerNo")); 
				String attrTypeCode = StringUtil.checkNull(request.getParameter("attrTypeCode")); 
				
				setMap.put("srID",srID);
				setMap.put("srType",srType);
				setMap.put("customerNo",customerNo);
				setMap.put("attrTypeCode",attrTypeCode);
				
				String AttrLovList = StringUtil.checkNull(commonService.selectString("esm_SQL.getESPAttrLovList", setMap));
				ObjectMapper objectMapper = new ObjectMapper();
				String jsonString = StringUtil.checkNull(objectMapper.writeValueAsString(AttrLovList));
				 
		        sendToJson(jsonString, response);
	        } catch (Exception e) {
	            System.out.println(e);
	        }
		}
		
		@RequestMapping(value = "/olmapi/espUserDuplicateCheck", method = RequestMethod.GET)
		@ResponseBody
		public void espUserDuplicateCheck(HttpServletRequest request, HttpServletResponse response) throws Exception {
			Map setMap = new HashMap();
			try {
				boolean result = true;
				
				String srID = StringUtil.checkNull(request.getParameter("srID")); 
				String speCode = StringUtil.checkNull(request.getParameter("speCode")); // 현재 단계
				String chkSpeCode = StringUtil.checkNull(request.getParameter("chkSpeCode")); // 비교 할 단계
				String receiptUserID = StringUtil.checkNull(request.getParameter("receiptUserID")); // 현재 단계의 담당자
				String chkReceiptUserID = ""; // 비교할 단계의 담당자
				String languageID = StringUtil.checkNull(request.getParameter("languageID")); 
				String userID = StringUtil.checkNull(request.getParameter("userID"));
				
				// 01. 비교할 단계의 담당자 get
				setMap.put("srID", srID);
				setMap.put("languageID", languageID);
				setMap.put("maxSeq", "Y");
				setMap.put("speCode", chkSpeCode);
				
				List logList = commonService.selectList("esm_SQL.getESMProLogInfo_gridList", setMap);
				
				if(logList.size() > 0){
					Map logMap = (Map) logList.get(0);
					chkReceiptUserID = StringUtil.checkNull(logMap.get("ActorID"));
				}
				
				// 02. 현재단계의 담당자와 동일한지 비교
				if(receiptUserID.equals(chkReceiptUserID)){
					
					// 03. 현재단계의 담당자 외 작업자가 존재하는지 체크
					setMap.put("SRID", srID);
					setMap.put("LanguageID", languageID);
					setMap.put("speCode", speCode);
					setMap.put("notMemberID",receiptUserID);
					List mbrList = commonService.selectList("esm_SQL.selectMbrRcd_gridList", setMap);
					
					if(mbrList.size() < 1){
						result = false;
					}
				}
				
				ObjectMapper objectMapper = new ObjectMapper();
				String jsonString = StringUtil.checkNull(objectMapper.writeValueAsString(result));
				 
		        sendToJson(jsonString, response);
	        } catch (Exception e) {
	            System.out.println(e);
	        }
		}
		
		@RequestMapping(value = "/olmapi/espStatusCheck", method = RequestMethod.GET)
		@ResponseBody
		public void espStatusCheck(HttpServletRequest request, HttpServletResponse response) throws Exception {
			Map setMap = new HashMap();
			try {
				boolean result = true;
				
				String srID = StringUtil.checkNull(request.getParameter("srID")); 
				setMap.put("srID", srID);
				
				// 현재 티켓의 단계 체크
				String nowSpeCode = StringUtil.checkNull(commonService.selectString("esm_SQL.getSRStatus", setMap));
				// 업데이트 하려는 단계 체크
				String speCode = StringUtil.checkNull(request.getParameter("speCode"));
				
				if(!nowSpeCode.equals(speCode)){
					result =  false;
				} 
				
				// 현재 티켓이 종료된 티켓인지 체크
				String CompletionDT = StringUtil.checkNull(commonService.selectString("esm_SQL.getSRCompletionDT", setMap));
				if(!"".equals(CompletionDT)){
					result =  false;
				}
				
				ObjectMapper objectMapper = new ObjectMapper();
				String jsonString = StringUtil.checkNull(objectMapper.writeValueAsString(result));
				 
		        sendToJson(jsonString, response);
	        } catch (Exception e) {
	            System.out.println(e);
	        }
		}
		
		@RequestMapping(value = "/olmapi/espReceiverCheck", method = RequestMethod.GET)
		@ResponseBody
		public void espReceiverCheck(HttpServletRequest request, HttpServletResponse response) throws Exception {
			Map setMap = new HashMap();
			try {
				boolean result = true;
				
				String srID = StringUtil.checkNull(request.getParameter("srID")); 
				setMap.put("srID", srID);
				String speCode = StringUtil.checkNull(request.getParameter("speCode"));
				setMap.put("speCode", speCode);
				
				// 01. 비교할 단계의 담당자 get
				String receiptUserID = StringUtil.checkNull(commonService.selectString("esm_SQL.getReceiver", setMap));
				String sessionUserID = StringUtil.checkNull(request.getParameter("sessionUserId"));
				
				if(!"".equals(receiptUserID) && !sessionUserID.equals(receiptUserID)) {
					result =  false;
				}
				
				ObjectMapper objectMapper = new ObjectMapper();
				String jsonString = StringUtil.checkNull(objectMapper.writeValueAsString(result));
				 
		        sendToJson(jsonString, response);
	        } catch (Exception e) {
	            System.out.println(e);
	        }
		}
		
		@RequestMapping(value = "/olmapi/espActivityFileCheck", method = RequestMethod.POST)
		@ResponseBody
		public void espActivityFileCheck(HttpServletRequest request, HttpServletResponse response) throws Exception {
			Map setMap = new HashMap();
			ObjectMapper objectMapper = new ObjectMapper();
			
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
				setMap.put("srID",srID);
				setMap.put("status",StringUtil.checkNull(data.get("speCode")));
				setMap.put("clientID",StringUtil.checkNull(data.get("clientID")));
				setMap.put("languageID",StringUtil.checkNull(data.get("languageID")));
				setMap.put("SRAT0004",StringUtil.checkNull(data.get("SRAT0004")));
				
				List checkFileList = commonService.selectList("esm_SQL.getESPActivityFileCheckList", setMap);
				
				jsonString = StringUtil.checkNull(objectMapper.writeValueAsString(checkFileList));
				 
		        sendToJson(jsonString, response);
	        } catch (Exception e) {
	            System.out.println(e);
	        }
		}
		
		@RequestMapping(value = "/olmapi/espActivityLogUpdate", method = RequestMethod.POST)
		@ResponseBody
		public void espActivityLogUpdate(HttpServletRequest request, HttpServletResponse response) throws Exception {
			Map setMap = new HashMap();
			ObjectMapper objectMapper = new ObjectMapper();
			boolean result =  true;
			
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
				String updateSpeCode = StringUtil.checkNull(data.get("updateSpeCode"));
				String[] updateSpeCodes = updateSpeCode.split(",");
				
				for (String speCode : updateSpeCodes) {
					Map setActivityLogMapRst = new HashMap();
					Map updateLogMap = new HashMap();
					updateLogMap.put("srID",StringUtil.checkNull(data.get("srID")));
					updateLogMap.put("srType",StringUtil.checkNull(data.get("srType")));
					updateLogMap.put("speCode", speCode);
					updateLogMap.put("activityStatus", "07");
					setActivityLogMapRst = (Map)ESPUtil.updateActivityLog(request, commonService, updateLogMap);
		        }
				
				jsonString = StringUtil.checkNull(objectMapper.writeValueAsString(result));
		        sendToJson(jsonString, response);
	        } catch (Exception e) {
	        	result = false;
	        	String jsonString = StringUtil.checkNull(objectMapper.writeValueAsString(result));
		        sendToJson(jsonString, response);
		        
	            System.out.println(e);
	        }
		}
		
		// srInfoMgt 
		@RequestMapping(value = "/esrInfoMgt.do")
		public String esrInfoMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
			String url = "/app/esp/main/esrInfoMgt";
			HashMap setData = new HashMap();
			try {
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
					
					//임시저장된 파일이 존재할 수 있으므로 삭제
					String path=GlobalVal.FILE_UPLOAD_BASE_DIR + cmmMap.get("sessionUserId");
					if(!path.equals("")){FileUtil.deleteDirectory(path);}
					
					setData.put("srID", srID);
					setData.put("srType", srType);
					setData.put("srCode", srCode);
					setData.put("languageID", languageID);
					Map srInfoMap = commonService.select("esm_SQL.getESMSRInfo", setData);
					
					if(srCode.equals("")){ // 외부에서 호출시 srID만 넘어옮
						setData.put("esType", esType);				
		
						if(!srInfoMap.isEmpty()){
							status = StringUtil.checkNull(srInfoMap.get("Status"));
							receiptUserID = StringUtil.checkNull(srInfoMap.get("ReceiptUserID"));
						}
					}
					
					// 보안 조치
					String Description = StringUtil.checkNull(srInfoMap.get("Description")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
					String Comment = StringUtil.checkNull(srInfoMap.get("Comment")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
					srInfoMap.put("Description",Description);
					srInfoMap.put("Comment",Comment);
					
					model.put("srID",srID);
					model.put("languageID",languageID);
					model.put("itemProposal", itemProposal);
					model.put("getItemMap",getItemMap);
					model.put("srInfoMap", srInfoMap);
					model.put("srFilePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
					model.put("scrnType", scrnType );
					model.put("srMode", srMode );
					model.put("esType", esType);
					model.put("srType", srType);				
					model.put("menu", getLabel(request, commonService)); //  Label Setting 
					model.put("pageNum", pageNum);
					model.put("projectID", projectID);
					model.put("srStatus", srStatus);
					model.put("itemID", itemID);
					model.put("isPopup", isPopup);
					model.put("multiComp", multiComp);
					model.put("itemTypeCode", itemTypeCode);
					model.put("status", StringUtil.checkNull(cmmMap.get("status")));
					model.put("isPopup", StringUtil.checkNull(request.getParameter("isPopup")));
					
					// 검색조건 Setting
					model.put("searchSrType", StringUtil.checkNull(cmmMap.get("searchSrType")));
					model.put("searchStatus", StringUtil.checkNull(cmmMap.get("searchStatus")));
					model.put("inProgress", StringUtil.checkNull(cmmMap.get("inProgress")));
					model.put("stSRCompDT", StringUtil.checkNull(cmmMap.get("stSRCompDT")));
					model.put("endSRCompDT", StringUtil.checkNull(cmmMap.get("endSRCompDT")));
					model.put("searchSrCode", StringUtil.checkNull(cmmMap.get("searchSrCode")));
					model.put("subject", StringUtil.checkNull(cmmMap.get("subject")));
					model.put("regStartDate", StringUtil.checkNull(cmmMap.get("regStartDate")));
					model.put("regEndDate", StringUtil.checkNull(cmmMap.get("regEndDate")));
					model.put("customerNo", StringUtil.checkNull(cmmMap.get("customerNo")));
					model.put("stSRDueDate", StringUtil.checkNull(cmmMap.get("stSRDueDate")));
					model.put("endSRDueDate", StringUtil.checkNull(cmmMap.get("endSRDueDate")));
					model.put("completionDelay", StringUtil.checkNull(cmmMap.get("completionDelay")));
					model.put("srAreaSearch", StringUtil.checkNull(cmmMap.get("srAreaSearch")));
					model.put("srArea1", StringUtil.checkNull(cmmMap.get("srArea1")));
					model.put("srArea2", StringUtil.checkNull(cmmMap.get("srArea2")));
					model.put("svcType", StringUtil.checkNull(cmmMap.get("svcType")));
					model.put("requestUser", StringUtil.checkNull(cmmMap.get("requestUser")));
					model.put("requestUserID", StringUtil.checkNull(cmmMap.get("requestUserID")));
					model.put("actorName", StringUtil.checkNull(cmmMap.get("actorName")));
					model.put("actorID", StringUtil.checkNull(cmmMap.get("actorID")));
					model.put("defApprovalSystem", GlobalVal.DEF_APPROVAL_SYSTEM);
					model.put("YO_GW_VIEW_URL", YoungOneGlobalVal.YO_GW_VIEW_URL); 
					model.put("returnMenuId", StringUtil.checkNull(cmmMap.get("returnMenuId")));
			} catch (Exception e) {
				System.out.println(e.toString());
			}
			return nextUrl(url);
		}
		
		@RequestMapping(value = "/olmapi/getSRProcStatusList",  method = RequestMethod.GET)
		@ResponseBody
		public void getSRProcStatusList (HttpServletRequest request,  HttpServletResponse response) throws Exception {
			HashMap target = new HashMap();
			try {
				Map setData = new HashMap();
				
				String srID = StringUtil.checkNull(request.getParameter("srID"));
				String status = StringUtil.checkNull(request.getParameter("status"));
				String esType = StringUtil.checkNull(request.getParameter("esType"));
				String languageID = StringUtil.checkNull(request.getParameter("languageID"));
				
				setData.put("srID", srID);
				setData.put("itemClassCode", "CL03004");
				setData.put("status", status); //speCode
				setData.put("esType", esType);
				setData.put("languageID", languageID);

				String sortNum = StringUtil.checkNull(commonService.selectString("esm_SQL.getESPStatusSortNum", setData));
				setData.put("sortNum", sortNum);
				
				List procStatusList = commonService.selectList("esm_SQL.getESPProcPathList", setData);
				
				JSONArray data = new JSONArray(procStatusList);
		        sendToJson(StringUtil.checkNull(data), response);
			} catch (IOException e) {
				MessageHandler.getMessage("json.send.message");
				e.printStackTrace();
			}
		}
		
		@RequestMapping(value = "/olmapi/getSRAttachFileList",  method = RequestMethod.GET)
		@ResponseBody
		public void getSRAttachFileList (HttpServletRequest request,  HttpServletResponse response) throws Exception {
			HashMap target = new HashMap();
			try {
				Map setData = new HashMap();
				
				String srID = StringUtil.checkNull(request.getParameter("srID"));
				
				setData.put("srID", srID);
				setData.put("fltpCode", "SRDOC");
				List attachFileList = commonService.selectList("sr_SQL.getSRFileList", setData);
				
				JSONArray data = new JSONArray(attachFileList);
		        sendToJson(StringUtil.checkNull(data), response);
			} catch (IOException e) {
				MessageHandler.getMessage("json.send.message");
				e.printStackTrace();
			}
		}
		
		@RequestMapping(value = "/olmapi/getActivityStatusName",  method = RequestMethod.GET)
		@ResponseBody
		public void getActivityStatusName(HttpServletRequest request,  HttpServletResponse response) throws Exception {
			HashMap target = new HashMap();
			try {
				Map setData = new HashMap();
				String srID = StringUtil.checkNull(request.getParameter("srID"));
				String status = StringUtil.checkNull(request.getParameter("status"));
				String languageID = StringUtil.checkNull(request.getParameter("languageID"));
				
				setData.put("srID", srID);
				setData.put("speCode", status);
				setData.put("languageID", languageID);
				setData.put("maxSeq", "Y");
				String activityStatusName = StringUtil.checkNull(commonService.selectString("esm_SQL.getActivityStatusName", setData));
				
				JSONObject data = new JSONObject();
				data.put("activityStatusName", activityStatusName);
				
		        sendToJson(StringUtil.checkNull(data), response);
		        
			} catch (IOException e) {
				MessageHandler.getMessage("json.send.message");
				e.printStackTrace();
			}
		}
		
		@RequestMapping(value = "/olmapi/getWorkerRecordCount",  method = RequestMethod.GET)
		@ResponseBody
		public void getWorkerRecordCount(HttpServletRequest request,  HttpServletResponse response) throws Exception {
			HashMap target = new HashMap();
			try {
				Map setData = new HashMap();
				String srID = StringUtil.checkNull(request.getParameter("srID"));
				String languageID = StringUtil.checkNull(request.getParameter("languageID"));
				
				// 역할 및 실적 count
				setData.put("srID", srID);
				setData.put("languageID", languageID);
				List workerRecord = commonService.selectList("esm_SQL.getMemberRecord_gridList", setData);
				int workerRecordSize = workerRecord.size();
				
				JSONObject data = new JSONObject();
				data.put("workerRecordCount", workerRecordSize);
				
		        sendToJson(StringUtil.checkNull(data), response);
		        
			} catch (IOException e) {
				MessageHandler.getMessage("json.send.message");
				e.printStackTrace();
			}
		}
		
		
		@RequestMapping(value = "/selectEspFileListPop.do") 
		public String selectEspFileListPop(HttpServletRequest request, HashMap cmmMap, HashMap commandMap, ModelMap model) throws Exception {
			String url = "/app/esp/main/selectEspFileListPop";
			Map getData = new HashMap();
			try {
			
				String srID = StringUtil.checkNull(request.getParameter("srID"));
				String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
				model.put("srID", srID);
				model.put("languageID", languageID);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				getData.put("srID", srID);
				getData.put("languageID", languageID);
				List fileList = commonService.selectList("esm_SQL.espFile_gridList",getData);
				JSONArray gridData = new JSONArray(fileList);
				model.put("gridData", gridData);
			} catch (Exception e) {
				System.out.println(e.toString());
			}
			return nextUrl(url);
		}
		
		@RequestMapping(value = "/olmapi/srArea",  method = RequestMethod.GET)
		@ResponseBody
		public void getSrArea(HttpServletRequest request,  HttpServletResponse response) throws Exception {
			HashMap target = new HashMap();
			try {
				Map setMap = new HashMap();
				setMap.put("languageID", StringUtil.checkNull(request.getParameter("languageID")));
				setMap.put("roleFilter", StringUtil.checkNull(request.getParameter("roleFilter")));
				setMap.put("userID", StringUtil.checkNull(request.getParameter("userID")));
				setMap.put("srType", StringUtil.checkNull(request.getParameter("srType")));
				setMap.put("myCSR", StringUtil.checkNull(request.getParameter("myCSR")));
				setMap.put("clientID", StringUtil.checkNull(request.getParameter("clientID")));
				setMap.put("priorityClientID", StringUtil.checkNull(request.getParameter("priorityClientID")));
				
				List srAreaList = commonService.selectList("esm_SQL.getESPSRArea", setMap);
				
				JSONArray data = new JSONArray(srAreaList);
		        sendToJson(StringUtil.checkNull(data), response);
			} catch (IOException e) {
				MessageHandler.getMessage("json.send.message");
				e.printStackTrace();
			}
		}
		
		@RequestMapping(value = "/searchSrAreaPop.do") 
		public String searchSrAreaPop(HttpServletRequest request, HashMap cmmMap, HashMap commandMap, ModelMap model) throws Exception {
			String url = "/app/esp/main/searchSrAreaPop";
			Map setData = new HashMap();
			try {
				setData.put("srType", StringUtil.checkNull(request.getParameter("srType")));
				setData.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
				setData.put("level", 1);
				String srAreaLabelNM1 = commonService.selectString("esm_SQL.getESMSRAreaLabelName",setData);
				setData.put("level", 2);
				String srAreaLabelNM2 = commonService.selectString("esm_SQL.getESMSRAreaLabelName",setData);
				
				model.put("srType",StringUtil.checkNull(request.getParameter("srType")));
				model.put("srAreaLabelNM1",srAreaLabelNM1);
				model.put("srAreaLabelNM2",srAreaLabelNM2);
				model.put("roleFilter",StringUtil.checkNull(request.getParameter("roleFilter")));
				model.put("myCSR",StringUtil.checkNull(request.getParameter("myCSR")));
				model.put("clientID",StringUtil.checkNull(request.getParameter("clientID")));
				model.put("priorityClientID",StringUtil.checkNull(request.getParameter("priorityClientID")));
				model.put("isCallCenter",StringUtil.checkNull(request.getParameter("isCallCenter")));
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
			} catch (Exception e) {
				System.out.println(e.toString());
			}
			return nextUrl(url);
		}
	
		@RequestMapping(value = "/olmapi/srAreaGroupMember",  method = RequestMethod.GET)
		@ResponseBody
		public void srAreaGroupMember(HttpServletRequest request,  HttpServletResponse response) throws Exception {
			HashMap target = new HashMap();
			try {
				
				String srArea = StringUtil.checkNull(request.getParameter("srArea"));
				
				Map setMap = new HashMap();
				setMap.put("srArea", srArea);
				setMap.put("languageID", StringUtil.checkNull(request.getParameter("languageID")));
				
				List getSRAreaGroupMemberList = commonService.selectList("esm_SQL.getSRAreaGroupMemberList", setMap);
				
				JSONArray data = new JSONArray(getSRAreaGroupMemberList);
		        sendToJson(StringUtil.checkNull(data), response);
			} catch (IOException e) {
				MessageHandler.getMessage("json.send.message");
				e.printStackTrace();
			}
		}
		
	@RequestMapping(value = "/olmapi/espFileType",  method = RequestMethod.GET)
	@ResponseBody
	public void fileType(HttpServletRequest request,  HttpServletResponse response) throws Exception {
		HashMap target = new HashMap();
		try {
			Map setMap = new HashMap();
			setMap.put("languageID", StringUtil.checkNull(request.getParameter("languageID")));
			setMap.put("scrnType", StringUtil.checkNull(request.getParameter("scrnType")));
			setMap.put("docCategory", StringUtil.checkNull(request.getParameter("docCategory")));
			setMap.put("activityLogID", StringUtil.checkNull(request.getParameter("activityLogID")));
			setMap.put("speCode", StringUtil.checkNull(request.getParameter("speCode")));
			setMap.put("srType", StringUtil.checkNull(request.getParameter("srType")));
			
			List fileTypeList = commonService.selectList("esm_SQL.getESMFltpAllocList", setMap);
			
			JSONArray data = new JSONArray(fileTypeList);
	        sendToJson(StringUtil.checkNull(data), response);
		} catch (IOException e) {
			MessageHandler.getMessage("json.send.message");
			e.printStackTrace();
		}
	}

	// 영향받는 CI
	@RequestMapping(value = "/serviceItemMgt.do")
	public String serviceItemMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		String url = "/custom/daelim/itsm/serviceItemMgt"; 
		try {
			String editMode = "N";
			String srID = StringUtil.checkNull(request.getParameter("srID"), "");
			setMap.put("srID", srID);
			setMap.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
			Map srInfoMap = commonService.select("esm_SQL.getESMSRInfo", setMap);	
			if(StringUtil.checkNull(srInfoMap.get("ReceiptUserID"), "").equals(StringUtil.checkNull(cmmMap.get("sessionUserId"), ""))) editMode = "Y";
			
			List itemList = commonService.selectList("esm_SQL.getServiceItemList", setMap);
			JSONArray gridData = new JSONArray(itemList);
			model.put("gridData",gridData);
			model.put("srID",srID);
			model.put("editMode",editMode);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
		
	@RequestMapping(value = "/saveServiceItem.do")
	public void saveServiceItem(HttpServletRequest request,  HttpServletResponse res, HashMap<String, Object> cmmMap, ModelMap model) throws Exception {
		JSONObject jsonObject = new JSONObject();
	    ObjectMapper objectMapper = new ObjectMapper();
	    HashMap<String, Object> setMap = new HashMap<>();
	    
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
	        String srID = StringUtil.checkNull(jsonMap.get("srID"));
	        String[] items = StringUtil.checkNull(jsonMap.get("items")).split(",");

        	setMap.put("srID", srID);
	        setMap.put("docCategory", "SR");
	        setMap.put("lastUser", StringUtil.checkNull(cmmMap.get("sessionUserId")));
	        setMap.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
	        
	        for (int i = 0; i < items.length ; i++) {
	        	setMap.put("itemID", items[i]);
	        	commonService.insert("esm_SQL.insertServiceItem", setMap);
	        }

			List itemList = commonService.selectList("esm_SQL.getServiceItemList", setMap);
			jsonObject.put("gridData", itemList);
			
			jsonObject.put("message", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
	        res.getWriter().print(jsonObject);
	    } catch (Exception e) {
	        System.out.println(e.toString());
	        jsonObject.put("message", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
	        res.getWriter().print(jsonObject);
	    }
	}
		
	@RequestMapping(value = "/saveDescServiceItem.do")
	public void saveDescServiceItem(HttpServletRequest request,  HttpServletResponse res, HashMap<String, Object> cmmMap, ModelMap model) throws Exception {
		JSONObject jsonObject = new JSONObject();
	    ObjectMapper objectMapper = new ObjectMapper();
	    HashMap<String, Object> setMap = new HashMap<>();
	    
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
	        List<Map<String, Object>> dataList = (List<Map<String, Object>>) jsonMap.get("data");
	        setMap.put("lastUser", StringUtil.checkNull(cmmMap.get("sessionUserId")));
	        
	        for (Map<String, Object> temp : dataList) {
	            HashMap<String, Object> item = new HashMap<>(temp);
	            setMap.put("serviceItemID", StringUtil.checkNull(item.get("ServiceItemID"), ""));
	            setMap.put("description", StringUtil.checkNull(item.get("Description"), ""));
	            
	            commonService.update("esm_SQL.updateServiceItem", setMap);
	        }
			
			jsonObject.put("message", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
	        res.getWriter().print(jsonObject);
	    } catch (Exception e) {
	        System.out.println(e.toString());
	        jsonObject.put("message", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
	        res.getWriter().print(jsonObject);
	    }
	}

	@RequestMapping(value = "/deleteServiceItem.do")
	public void deleteServiceItem(HttpServletRequest request,  HttpServletResponse res, HashMap<String, Object> cmmMap, ModelMap model) throws Exception {
		JSONObject jsonObject = new JSONObject();
	    ObjectMapper objectMapper = new ObjectMapper();
	    HashMap<String, Object> setMap = new HashMap<>();
	    
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
	        String serviceItemID = StringUtil.checkNull(jsonMap.get("serviceItemID"));
	        
        	setMap.put("serviceItemID", serviceItemID);
        	commonService.delete("esm_SQL.deleteServiceItem", setMap);
			
			jsonObject.put("message", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00069"));
	        res.getWriter().print(jsonObject);
	    } catch (Exception e) {
	        System.out.println(e.toString());
	        jsonObject.put("message", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
	        res.getWriter().print(jsonObject);
	    }
	}
	
	@RequestMapping(value = "/olmapi/serviceItem", method = RequestMethod.GET)
	@ResponseBody
	public void serviceItem(HttpServletRequest request,  HttpServletResponse res, HashMap<String, Object> cmmMap, ModelMap model) throws Exception {
		JSONObject jsonObject = new JSONObject();
		Map setMap = new HashMap();
	    try {
	    	String srID = StringUtil.checkNull(request.getParameter("srID"),"");
	    	String languageID = StringUtil.checkNull(request.getParameter("languageID"),"");
        	setMap.put("srID", srID);
        	
	        setMap.put("languageID", languageID);

			List itemList = commonService.selectList("esm_SQL.getServiceItemList", setMap);
			jsonObject.put("serviceItemCount", itemList.size());
	        res.getWriter().print(jsonObject);
	    } catch (Exception e) {
	        System.out.println(e.toString());
	        res.getWriter().print(jsonObject);
	    }
	}
	
	
	@RequestMapping(value = "/deleteESP.do")
	public void deleteESP(HttpServletRequest request,  HttpServletResponse res, HashMap<String, Object> cmmMap, ModelMap model) throws Exception {
		JSONObject jsonObject = new JSONObject();
	    ObjectMapper objectMapper = new ObjectMapper();
	    HashMap<String, Object> setMap = new HashMap<>();
	    
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
	        String srID = StringUtil.checkNull(jsonMap.get("srID"));
	        
        	setMap.put("srID", srID);
        	commonService.delete("esm_SQL.deleteSR", setMap);
			
			jsonObject.put("message", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00069"));
	        res.getWriter().print(jsonObject);
	    } catch (Exception e) {
	        System.out.println(e.toString());
	        jsonObject.put("message", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
	        res.getWriter().print(jsonObject);
	    }
	}

	@Transactional(timeout = 15)
	@RequestMapping(value = "/getSrCount.do")
	public void getCount(HashMap cmmMap, HttpServletResponse res)  throws Exception {
		JSONObject jsonObject = new JSONObject();		

        res.setHeader("Cache-Control", "no-cache");
		res.setContentType("text/plain");
		res.setCharacterEncoding("UTF-8");
		try {
			String SQL_CODE = getString(cmmMap.get("sqlID"), "commonCode");
			List result = commonService.selectList(SQL_CODE+"_gridList", cmmMap);
			
			String totalCount = "";
			JSONArray gridData = new JSONArray(result);
			if(result.size() > 0) totalCount = StringUtil.checkNull(((Map)result.get(0)).get("cnt"), "0");
			else totalCount = "0";
			
			jsonObject.put("list", gridData);
			jsonObject.put("total", totalCount);
			res.getWriter().print(jsonObject);
		} catch (Exception e) {
	        System.out.println(e.toString());
	        res.getWriter().print(jsonObject);
	    }
	}
	
	@RequestMapping(value = "/wfDocItsmMgt.do")
	public String wfDocItsmMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		 Map<String, Object> result = new HashMap<>();
		 Map<String, Object> target = new HashMap<>();
		 String actionType = StringUtil.checkNull(request.getParameter("actionType"),"");
		 String url = "";
		try {
			
			if(actionType.equals("create")) {		
				boolean success = false;
				Map<String, Object> label = getLabel(request, commonService, "ERRTP");
				Map<String, Object> setData = new HashMap<>();
				
				String srCode = StringUtil.checkNull(request.getParameter("srCode"),""); 
	    		String activityLogID = StringUtil.checkNull(request.getParameter("activityLogID"),""); 
				// 1. 결재 중복 체크 
				setData.put("documentNo", srCode);
	    		setData.put("documentID", activityLogID);
	    		setData.put("status", "0");
	    		String wfInstacceID = StringUtil.checkNull(commonService.selectString("wf_SQL.getWfInstanceID", setData));
				
				if(!wfInstacceID.equals("")) { // 이미 상신 데이터가 있으면 리턴 //재상신로직도 확인하기 
					System.out.println("이미 결재가 진행중!!");
					target.put(AJAX_ALERT, "이미 결재가 진행중 입니다.");
					model.addAttribute(AJAX_RESULTMAP, target);
	    			return nextUrl(AJAXPAGE);
				}
				
				String wfDocPopYN = StringUtil.checkNull(request.getParameter("wfDocPopYN"),""); // olm 결재 방식 임시저장이 아닌 popup 결재 생성 -> 상신하는 구조 파라미터 
				if("Y".equals(wfDocPopYN)) { // olm 결재 방식 팝업에서 생성하는것 
					url = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFDocURL", cmmMap));
					if(url.equals("")) url = "/custom/sf/wf/createWfDoc_ITSM"; 
					setCreateWfDocITSMData(request, cmmMap, model);
					
				} else { // 대림 전자결재 방식(임시저장기능포함) 
	
					// 2. Tb_WF_INST DB 저장
		    		result = createWfDoc_SR(request,result, model, cmmMap);  
		    		success = Boolean.parseBoolean(StringUtil.checkNull(result.get("success")));
					model.put("success", success);
					if(success) {
		    			target.put(AJAX_ALERT, label.get("ZLN0026")); // "승인 요청이 완료 되었습니다." -> 서비스 요청자의 ECM 임시저장함에서 결재 문서를 상신해 주시기 바랍니다.
						target.put(AJAX_SCRIPT, "fnCallBackSR();parent.$('#isSubmit').remove();");
			        } else {
			        	
			        	// roll back : TB_WF_INST, TB_WF_INST_TXT, TB_WF_STEP_INST, update activity WfinstanceID = null 
			        	 String wfInstanceID = StringUtil.checkNull(result.get("wfInstanceID"));
			        	 rollbackWfInstance(wfInstanceID);
			        	
			            target.put(AJAX_ALERT, label.get("ZLN0027"));  // "전자결재 생성 요청중 오류가 발생하였습니다."
						target.put(AJAX_SCRIPT, "fnCallBackSR();parent.$('#isSubmit').remove();");
			       }
					
					model.addAttribute(AJAX_RESULTMAP, target);
					return nextUrl(AJAXPAGE);
				}
			
			} else if(actionType.equals("view")) {				
				model = getWfItsmDetailInfo(request, cmmMap, model);				
				url = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFAprURL", cmmMap));
				if(url.equals("")) url = "/custom/sf/wf/approvalDetail_SR"; 
				
				return nextUrl(url);
			}
		
		
	    } catch (Exception e) {
	        model.put("success", false);
	        model.put("message", e.getMessage());
	    }
		
		return nextUrl(url);
	}
	
	// TB_WF_INSTANCE 생성 
	public Map<String, Object> createWfDoc_SR(HttpServletRequest request, Map<String, Object> result, ModelMap model, HashMap cmmMap) throws Exception {	
	    HashMap setData = new HashMap();
		HashMap insertWFInstData = new HashMap();
		HashMap inserWFInstTxtData = new HashMap();
		HashMap insertWFStepData = new HashMap();
		
		String docSubClass = StringUtil.checkNull(request.getParameter("docSubClass"));
		String docCategory = StringUtil.checkNull(request.getParameter("docCategory"));
		String wfID = StringUtil.checkNull(request.getParameter("defWFID"),""); if(wfID.equals("")) wfID="WF005";
		String srCode = StringUtil.checkNull(request.getParameter("srCode"));
		String srID = StringUtil.checkNull(request.getParameter("srID"));
		String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
		
		System.out.println("createWfDoc_SR :: docSubClass :"+docSubClass+",docCategory :"+docCategory+",wfID :"+wfID+", srID:"+srID);
		try {
			setData.put("wfID", wfID);			
			String reqReApprovalYN =  StringUtil.checkNull(request.getParameter("reqReApproval"));
			
			// SR MST
			setData.put("srID", srID);
			setData.put("languageID", languageID);
			Map srInfo = commonService.select("esm_SQL.getESMSRInfo", setData);	
			
			// Activity Log Info 
			setData.put("activityLogID", StringUtil.checkNull(request.getParameter("activityLogID")));
			Map activityLogInfo = commonService.select("esm_SQL.getESMProLogInfo_gridList", setData);
			
			
			//////////approverID , approverTeamID 취득 START  //////////////////////////////////////////
		    String srRequestUserID = StringUtil.checkNull(srInfo.get("RequestUserID"));
		    String srRequestTeamID = StringUtil.checkNull(srInfo.get("RequestTeamID"));
		    
		    String procPathID = StringUtil.checkNull(srInfo.get("ProcPathID"));
		    
		    String approverID = srRequestUserID;
		    String approverTeamID = srRequestTeamID;		    
		    		    
		    result.put("approverID", approverID);
		    result.put("approverTeamID", approverTeamID);
		    
		    //////////approverID , approverTeamID 취득 END  //////////////////////////////////////////    
			if(reqReApprovalYN.equals("Y")) { // 결재가 삭제 -1 상태여서 재승인요청 일경우
				// 1. wf-inst Status:0, 
				
				String activityWFInstanceID = StringUtil.checkNull(activityLogInfo.get("ActivityWFInstanceID")); // 재상신할 wfinstanceID
				result.put("wfInstanceID", activityWFInstanceID);
				result.put("subject", "[ITSM]" +  StringUtil.checkNull(srInfo.get("Subject")));
				
			} else { 
				setData.put("wfID",wfID);
				setData.put("wfDocType",docCategory);
				setData.put("docSubClass",docSubClass);
				
				String wfAllocID = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFAllocID", setData));
				
				setData.put("wfAllocID",wfAllocID);
				
				// 상신자 
				String sessionUserId   = StringUtil.checkNull(cmmMap.get("sessionUserId"));
				String sessionUserNm   = StringUtil.checkNull(cmmMap.get("sessionUserNm"));
					
				String wfStepMemberIDsStr = sessionUserId + "," + srRequestUserID;
				String wfStepRoleTypesStr = "AREQ,APRV";
				String wfStepSeqStr = "0,1";
						
				setData.put("wfStepMemberIDs", StringUtil.checkNull(cmmMap.get("sessionUserId"))); 
				setData.put("wfStepRoleTypes", "AREQ");
				setData.put("wfStepInfo", StringUtil.checkNull(cmmMap.get("sessionUserNm")));
			
				String subject = StringUtil.checkNull(srInfo.get("Subject")); 
				setData.put("subject", "[ITSM]" + subject);
				
				// 결재 본문 
				setData.put("speCode", StringUtil.checkNull(srInfo.get("Status")));
				setData.put("srType", StringUtil.checkNull(srInfo.get("SRType")));
				
				setData.put("docCategory", "SR");
				setData.put("showInvisible", StringUtil.checkNull(request.getParameter("showInvisible")));
					
				// SR ATTR		
				List srAttrList = (List)commonService.selectList("esm_SQL.getSRAttrList", setData);
				System.out.println("srAttrList :"+srAttrList);
				srAttrList = ESPUtil.getSRAttrList(commonService, srAttrList, setData, languageID );
				
				String description =  "";
				if(srAttrList.size()>0) {
					for(int i=0; i<srAttrList.size(); i++) {
						Map attrInfo = (Map)srAttrList.get(i);
						if( !StringUtil.checkNull(attrInfo.get("PlainText")).equals("")) {
							description += "&lt;br&gt;"+ StringUtil.checkNull(attrInfo.get("Name")) + " : " +StringUtil.checkNull(attrInfo.get("PlainText"));
						}
					}
					description += "&lt;br&gt;&lt;br&gt;";
				}
				
				setData.put("description", description);
				System.out.println("srAttrdescriptionList :"+srAttrList);
			
				String projectID = StringUtil.checkNull(srInfo.get("ProjectID"));				
				String loginUser = StringUtil.checkNull(cmmMap.get("sessionUserId"));
				String creatorTeamID = StringUtil.checkNull(cmmMap.get("sessionTeamId"));
				
				String wfStepMemberIDs[] = null;
				String wfStepRoleTypes[] = null;
				String wfStepSeq[] = null;
				
				wfStepMemberIDs = wfStepMemberIDsStr.split(","); 
				wfStepRoleTypes = wfStepRoleTypesStr.split(","); 
				wfStepSeq = wfStepSeqStr.split(",");
				
				// SET APRV PATH	
				int idx = 0;
									
				for(int j=0; j< wfStepRoleTypes.length; j++){	
					if(j == 0){						
						wfStepSeq[j] = "0";
						idx++;
					} else {						
						wfStepSeq[j] = StringUtil.checkNull(idx);
						idx++;
					}
				}
	
				int lastSeq = idx-1;		
								
				//Delete WF Instance Text 
				if (!"".equals(StringUtil.checkNull(request.getParameter("wfInstanceID")))) {
					setData.put("wfInstanceID", StringUtil.checkNull(request.getParameter("wfInstanceID")));
					commonService.delete("wf_SQL.deleteWFInstTxt", setData);
				}
				String status = "1"; //  상신 				
				
				//INSERT NEW WF Instance
				//insertWFInstData.put("WFInstanceID", newWFInstanceID);
				insertWFInstData.put("ProjectID", projectID);
				insertWFInstData.put("DocumentID", StringUtil.checkNull(request.getParameter("activityLogID")));
				insertWFInstData.put("DocumentNo", srCode);
				insertWFInstData.put("DocCategory", docCategory);
				insertWFInstData.put("WFID", wfID);
				insertWFInstData.put("LastUser", loginUser);
				insertWFInstData.put("Status", status); // 상신
				insertWFInstData.put("curSeq", "1");
				insertWFInstData.put("LastSigner", loginUser);
				insertWFInstData.put("lastSeq", lastSeq);
				insertWFInstData.put("creatorTeamID", creatorTeamID);
				insertWFInstData.put("wfAllocID", wfAllocID);
				insertWFInstData.put("Creator", loginUser);
				insertWFInstData.put("prefix", GlobalVal.OLM_SERVER_NAME);
				insertWFInstData.put("padLen", 10);
				
				System.out.println("insert WF : "+insertWFInstData);
				commonService.insert("wf_SQL.insertToWfInst", insertWFInstData);
				String newWFInstanceID = (String) insertWFInstData.get("WFInstanceID");
				
				System.out.println("newWFINstanceID :"+newWFInstanceID);
				
				//INSERT WF STEP INST
				
				String maxId = "";
				if(!wfStepMemberIDsStr.isEmpty()){
					for(int i=0; i< wfStepMemberIDs.length; i++){	
											
						status = null ;
						
						insertWFStepData.put("Seq", wfStepSeq[i]);
						maxId = commonService.selectString("wf_SQL.getMaxStepInstID", setData);	
						
						insertWFStepData.put("StepInstID", Integer.parseInt(maxId) + 1); 						
						insertWFStepData.put("ProjectID", projectID);
						
						if( i == 0){ status = "1"; }		
						else if( wfStepSeq[i].equals("1") ){ status = "0"; }
						insertWFStepData.put("Status", status);
						insertWFStepData.put("ActorID", wfStepMemberIDs[i]);
						insertWFStepData.put("WFID", wfID);
						insertWFStepData.put("WFStepID", wfStepRoleTypes[i]);
						insertWFStepData.put("WFInstanceID", newWFInstanceID);
						commonService.insert("wf_SQL.insertWfStepInst", insertWFStepData);
					}
				}
				
				//INSERT WF INST TEXT(SUBJECT, DECSRIPTION)
				inserWFInstTxtData.put("WFInstanceID",newWFInstanceID);
				inserWFInstTxtData.put("subject",subject);
				inserWFInstTxtData.put("subjectEN",subject);
				inserWFInstTxtData.put("description",description);
				inserWFInstTxtData.put("descriptionEN",description);
				inserWFInstTxtData.put("comment","");
				inserWFInstTxtData.put("actorID",loginUser);
				commonService.insert("wf_SQL.insertWfInstTxt", inserWFInstTxtData);	
				
				String inhouse = StringUtil.checkNull(request.getParameter("inhouse"));
				setData.put("PID", srID);
				setData.put("WFInstanceID", newWFInstanceID);
				setData.put("Blocked", "1");
				setData.put("Status", "02"); //승인중
				
				commonService.update("esm_SQL.updateActivityLog", setData);
				
				result.put("wfInstanceID", newWFInstanceID);
				result.put("subject", subject);
				result.put("success", true);
				
			}
		} catch(Exception e) {
			result.put("success", false);
			result.put("error", "Y");
	        //result.put("message", e.getMessage());
			System.out.println("결재 TB_WF_INST 생성중 오류발생 :"+e);
	        result.put("message", "결재 TB_WF_INST 생성중 오류발생");
		}
		
	    return result;
	}
	
	
	private void rollbackWfInstance(String wfInstanceID) {
	    try {
	        if (wfInstanceID == null || wfInstanceID.isEmpty()) {
	            System.err.println(" wfInstanceID가 비어 있어 롤백 불가");
	            return;
	        }
	        Map<String, String> setData = new HashMap();
	        setData.put("wfInstanceID", wfInstanceID);
	        // 1. TB_WF_STEP_INST
	        commonService.delete("wf_SQL.deleteWFStepInst", setData);

	        // 2. TB_WF_INST_TXT
	        commonService.delete("wf_SQL.deleteWFInstTxt", setData);

	        // 3. TB_WF_INST
	        commonService.delete("wf_SQL.deleteWFInst", setData);

	        // 4. Activity wfInstanceID 초기화
	        setData.put("wfInstanceID", wfInstanceID);
	        commonService.delete("esm_SQL.updateWfInstanceNull", setData);

	        System.out.println("전자결재 롤백 처리 완료: wfInstanceID = " + wfInstanceID);

	    } catch (Exception e) {
	        System.err.println(" 전자결재 롤백 중 예외 발생: " + e.getMessage());
	        e.printStackTrace();
	    }
	}
	
	public ModelMap getWfItsmDetailInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		List attachFileList = new ArrayList();
		List wfInstList = new ArrayList();
		List wfRefInstList = new ArrayList();
		try {
				String projectID = StringUtil.checkNull(commandMap.get("projectID"));
				String wfID = StringUtil.checkNull(commandMap.get("wfID"));
				String stepInstID = StringUtil.checkNull(commandMap.get("stepInstID"));
				String documentID = StringUtil.checkNull(commandMap.get("documentID")); // activityLogID
				String wfInstanceID = StringUtil.checkNull(commandMap.get("wfInstanceID"));
				String lastSeq = StringUtil.checkNull(commandMap.get("lastSeq"));
				String actorID = StringUtil.checkNull(commandMap.get("actorID"));
				String stepSeq = StringUtil.checkNull(commandMap.get("stepSeq"));
				String loginUser = StringUtil.checkNull(commandMap.get("sessionUserId"));
				String wfDocType = StringUtil.checkNull(commandMap.get("wfDocType"));
				String inhouse = StringUtil.checkNull(commandMap.get("inhouse"));
				
				model.put("wfDocType",wfDocType);		
				
				setMap.put("WFStepIDs", "'AREQ','APRV'");
				setMap.put("wfInstanceID", wfInstanceID);
				setMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				
				List wfStepInstList = commonService.selectList("wf_SQL.getWFStepInstInfoList", setMap);	
				Map wfInstInfo = commonService.select("wf_SQL.getWFInstanceDetail_gridList", setMap);
			
				String Description = StringUtil.checkNull(wfInstInfo.get("Description"),"");
				Description = StringUtil.replaceFilterString(Description);
				wfInstInfo.put("Description", Description);	

				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				
				model.put("wfInstInfo",wfInstInfo);			
				
				String wfStepInstInfo = "";
				String afterSeq = "";
				Map wfStepInstInfoMap = new HashMap();
				if(wfStepInstList.size() > 0 ){
					for(int i=0; i<wfStepInstList.size(); i++){
						wfStepInstInfoMap = (Map) wfStepInstList.get(i);
						if(i==0){
							wfStepInstInfo = wfStepInstInfoMap.get("ActorName")+"("+ wfStepInstInfoMap.get("WFStepName")+")";
							afterSeq =  wfStepInstInfoMap.get("Seq").toString();
						}else{						
							if(wfStepInstInfoMap.get("Seq").equals(wfInstInfo.get("CurSeq"))){
								if(afterSeq.equals(wfStepInstInfoMap.get("Seq").toString()))
									wfStepInstInfo = wfStepInstInfo + ", "+ "<span style='color:blue;font-weight:bold'>"+wfStepInstInfoMap.get("ActorName")+"("+ wfStepInstInfoMap.get("WFStepName")+") </span>";
								else
									wfStepInstInfo = wfStepInstInfo + " >> "+ "<span style='color:blue;font-weight:bold'>"+wfStepInstInfoMap.get("ActorName")+"("+ wfStepInstInfoMap.get("WFStepName")+") </span>";
								
							}else{
								if(afterSeq.equals(wfStepInstInfoMap.get("Seq").toString()))
									wfStepInstInfo = wfStepInstInfo + ", "+ wfStepInstInfoMap.get("ActorName")+"("+ wfStepInstInfoMap.get("WFStepName")+")";
								else
									wfStepInstInfo = wfStepInstInfo + " >> "+ wfStepInstInfoMap.get("ActorName")+"("+ wfStepInstInfoMap.get("WFStepName")+")";
							}
							afterSeq = wfStepInstInfoMap.get("Seq").toString();
						}
						if(actorID.equals(wfStepInstInfoMap.get("ActorID").toString())) {
							model.put("actorWFStepName",wfStepInstInfoMap.get("WFStepName"));
							String transYN = commonService.selectString("wf_SQL.getApprTransYN", wfStepInstInfoMap);
							model.put("transYN",transYN);
						}
					}
					model.put("wfStepInstInfo", wfStepInstInfo); // 결재선
				}
				
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				setMap.put("s_itemID", projectID);
				Map getPJTMap = new HashMap();

				setMap.put("itemID", projectID);
				setMap.put("DocCategory", wfInstInfo.get("DocCategory"));
				setMap.put("DocumentID", commandMap.get("documentID"));
				
				
				Map getSRInfoMap = new HashMap();
				setMap.put("srCode", StringUtil.checkNull(commandMap.get("documentNo")));
				String srID = commonService.selectString("esm_SQL.getSRID", setMap);
				setMap.put("srID", srID);
					
				getSRInfoMap = commonService.select("esm_SQL.getESMSRInfo", setMap);	
				String srDescription = StringUtil.replaceFilterString(StringUtil.checkNull(getSRInfoMap.get("Description")));
				getSRInfoMap.put("Description", srDescription);
				attachFileList = commonService.selectList("fileMgt_SQL.getWfFileList", setMap);
				model.put("getSRInfoMap", getSRInfoMap);
				
				setMap.put("category", "DOCCAT");
				setMap.put("typeCode", wfInstInfo.get("DocCategory"));
				
				getPJTMap.put("WFDocType",StringUtil.checkNull(commonService.selectString("common_SQL.getNameFromDic", setMap)));
				
				Description = StringUtil.checkNull(getPJTMap.get("Description"),"");
				Description = StringUtil.replaceFilterString(Description);
				getPJTMap.put("Description", Description);	
				model.put("getPJTMap", getPJTMap);				
				
				setMap.put("WFStepIDs", "'AREQ','APRV'");
				setMap.put("WFStepID", "");
				
				wfInstList = commonService.selectList("wf_SQL.getWfStepInstList_gridList", setMap);
				
				String wfURL = commonService.selectString("wf_SQL.getWFCategoryURL", setMap);	
				
				setMap.put("emailCode", commandMap.get("emailCode") );
				String emailHTMLForm = StringUtil.checkNull(commonService.selectString("email_SQL.getEmailHTMLForm", setMap));
				
				// 진행이력 정보 				
				setMap.put("activityLogID", commandMap.get("documentID"));
				Map activityLogInfo = commonService.select("esm_SQL.getESMProLogInfo_gridList", setMap);
				model.put("activityLogInfo", activityLogInfo);
				
				model.put("emailHTMLForm", emailHTMLForm);				
				model.put("menu", getLabel(request, commonService)); /*Label Setting*/	
				model.put("wfInstanceID", wfInstanceID);
				model.put("projectID", projectID);
				model.put("wfURL", wfURL);
				model.put("wfID", wfID);
				model.put("srID", srID);
				model.put("stepInstID", stepInstID);
				model.put("actorID", actorID);
				model.put("stepSeq", stepSeq);
				model.put("wfInstanceID", wfInstanceID);
				model.put("wfDocType", wfInstInfo.get("DocCategory"));
				model.put("wfMode", StringUtil.checkNull(commandMap.get("wfMode")));
				model.put("lastSeq", lastSeq);
				model.put("screenType", commandMap.get("screenType"));
				model.put("fileList", attachFileList);
				model.put("filePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
				model.put("wfInstList", wfInstList);
				model.put("wfRefInstList",wfRefInstList);
				model.put("documentID", documentID);
				model.put("docCategory", wfInstInfo.get("DocCategory"));
				model.put("inhouse", inhouse);
				
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return model;
	}	
	
	// SFOLM ITSM 승인요청시 결재 정보조회 
	public String setCreateWfDocITSMData(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String srID = StringUtil.checkNull(request.getParameter("srID"),"");
		String speCode = StringUtil.checkNull(request.getParameter("speCode"),"");
		String defWFID = StringUtil.checkNull(request.getParameter("defWFID"),"");
		String activityLogID = StringUtil.checkNull(request.getParameter("activityLogID"),"");
		String showInvisible = StringUtil.checkNull(request.getParameter("showInvisible"),"");
		String docCategory = StringUtil.checkNull(request.getParameter("docCategory"),"");
		String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"),"");
		
		Map setMap = new HashMap();
		setMap.put("srID", srID);
		setMap.put("languageID", languageID);
		Map srInfo = commonService.select("esm_SQL.getESMSRInfo", setMap);	
		model.put("srInfo", srInfo);
		model.put("speCode", speCode);
		model.put("wfDocType",  StringUtil.checkNull(request.getParameter("wfDocType"),""));
		
		setMap = new HashMap();
		setMap.put("speCode", speCode);
		setMap.put("srID", srID);
		setMap.put("languageID", languageID);
		setMap.put("activityLogID", activityLogID);
		Map activityLogInfo = commonService.select("esm_SQL.getESMProLogInfo_gridList", setMap);
	
		model.put("activityLogInfo", activityLogInfo);
		model.put("srID", srID);
		model.put("wfID",defWFID);
		
		// ========================= 본문 Start=================================================
		// attrTypeCode alloc list 
		//String inhouse = StringUtil.checkNull(commandMap.get("inhouse"));
		//if(inhouse.equals("Y")) {
			setMap = new HashMap();
			setMap.put("srID", srID);
			setMap.put("speCode", StringUtil.checkNull(srInfo.get("Status")));
			setMap.put("srType", StringUtil.checkNull(srInfo.get("SRType")));
			
			setMap.put("languageID", languageID);
			setMap.put("docCategory", "SR");
			setMap.put("showInvisible", showInvisible);
				
			// SR ATTR		
			List srAttrList = (List)commonService.selectList("esm_SQL.getSRAttrList", setMap);
			srAttrList = ESPUtil.getSRAttrList(commonService, srAttrList, setMap, languageID);
			
			String description =  "";
			if(srAttrList.size()>0) {
				for(int i=0; i<srAttrList.size(); i++) {
					Map attrInfo = (Map)srAttrList.get(i);
					if( !StringUtil.checkNull(attrInfo.get("PlainText")).equals("")) {
						description += "<BR>"+ StringUtil.checkNull(attrInfo.get("Name")) + " : " +StringUtil.checkNull(attrInfo.get("PlainText"));
					}
				}
				description += "&lt;br&gt;&lt;br&gt;";
			}
			
			model.put("description", description);
		//}
		// ========================= 본문 End==================================================
		
		model.put("isPop","Y");
		model.put("docSubClass", StringUtil.checkNull(commandMap.get("docSubClass")));
		model.put("docCategory", StringUtil.checkNull(commandMap.get("docCategory")));
		
		model.put("menu", getLabel(request, commonService)); /*Label Setting*/	
		return "";
	}
}

