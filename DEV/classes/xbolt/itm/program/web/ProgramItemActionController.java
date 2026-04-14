package xbolt.itm.program.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonService;



/**
 * 업무 처리
 * @Class Name : BizController.java
 * @Description : 업무화면을 제공한다.
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2012. 09. 01. smartfactory		최초생성
 *
 * @since 2012. 09. 01.
 * @version 1.0
 */

@Controller
@SuppressWarnings("unchecked")
public class ProgramItemActionController extends XboltController{

	@Resource(name = "commonService")
	private CommonService commonService;
	
	@RequestMapping(value="/ProgramInfo.do")
	public String programInfo(HttpServletRequest request, ModelMap model)throws Exception{
		
		String url = "/itm/sub/ProgramInfoMain";

		try{
			
			HashMap setMap = new HashMap(); 
			
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
			// TODO : String s_itemID = StringUtil.checkNull(request.getParameter("subID"),"");
			String LanguageID = StringUtil.checkNull(request.getParameter("languageID"),"");
			String classCode = StringUtil.checkNull(request.getParameter("classCode"),"");
			String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"),"");
			
			// rootItemId가 '14':CBO List, '15':Interface Master
			//setMap.put("parentID", parentID);
			//String rootItemId  = commonService.selectString("project_SQL.getRootItemID", setMap);
			
			List programStatusList = new ArrayList();
			List statusList = new ArrayList();
			List userList = new ArrayList();
			List pgStatusList1 = new ArrayList();
			List pgStatusList2 = new ArrayList();
			List pgStatusList3 = new ArrayList();
			List pgStatusList4 = new ArrayList();
			setMap.put("LanguageID", LanguageID);
			
			// CBO List
			if (classCode.equals("CL04005")) {
				
				model.put("DisplayDiv", 0);
				
				// get select List
				setMap.put("Category", "PGRSTS"); // Program Status 명 취득
				programStatusList  = commonService.selectList("project_SQL.getChangeSetInsertInfo", setMap);
				setMap.put("Category", "STS"); // Program 상태 Status 취득
				statusList  = commonService.selectList("project_SQL.getStatus", setMap);
				
				userList = commonService.selectList("project_SQL.getUserInfo", setMap);
				
				// get Program Status List
				setMap.put("ItemID", s_itemID);
				setMap.put("ChangeSetID", changeSetID);
				setMap.put("ProgramStatus", "PGRSTS1");
				pgStatusList1  = commonService.selectList("project_SQL.getChangeSetStep", setMap);
				setMap.put("ProgramStatus", "PGRSTS2");
				pgStatusList2  = commonService.selectList("project_SQL.getChangeSetStep", setMap);
				setMap.put("ProgramStatus", "PGRSTS3");
				pgStatusList3  = commonService.selectList("project_SQL.getChangeSetStep", setMap);
				setMap.put("ProgramStatus", "PGRSTS4");
				pgStatusList4  = commonService.selectList("project_SQL.getChangeSetStep", setMap);
				
				if (0 == (pgStatusList1.size() + pgStatusList2.size() + pgStatusList3.size() + pgStatusList4.size())) {
					model.put("screenDisPlay", 0);
				} else {
					model.put("screenDisPlay", 1);
				}
				
			} else {
				
				model.put("DisplayDiv", 1);
				
				// Interface Master
				// get select List
				setMap.put("Category", "IFSTS"); // Program Status 명 취득
				programStatusList  = commonService.selectList("project_SQL.getChangeSetInsertInfo", setMap);
				
				// get Program Status List
				setMap.put("ItemID", s_itemID);
				setMap.put("ChangeSetID", changeSetID);
				setMap.put("ProgramStatus", "IFSTS1");
				pgStatusList1  = commonService.selectList("project_SQL.getChangeSetStep", setMap);
				setMap.put("ProgramStatus", "IFSTS2");
				pgStatusList2  = commonService.selectList("project_SQL.getChangeSetStep", setMap);
				setMap.put("ProgramStatus", "IFSTS3");
				pgStatusList3  = commonService.selectList("project_SQL.getChangeSetStep", setMap);
				setMap.put("ProgramStatus", "IFSTS4");
				pgStatusList4  = commonService.selectList("project_SQL.getChangeSetStep", setMap);
				
				if (0 == (pgStatusList1.size() + pgStatusList2.size() + pgStatusList3.size() + pgStatusList4.size())) {
					model.put("screenDisPlay", 0);
				} else {
					model.put("screenDisPlay", 1);
				}
			}
			
			model.put("menu", getLabel(request, commonService));
			model.put("programStatusList", programStatusList);
			model.put("statusList", statusList);
			model.put("userList", userList);
			model.put("pgStatusList1", pgStatusList1);
			model.put("pgStatusList2", pgStatusList2);
			model.put("pgStatusList3", pgStatusList3);
			model.put("pgStatusList4", pgStatusList4);
			model.put("s_itemID", s_itemID);
			model.put("classCode", classCode);
			model.put("changeSetID", changeSetID);
			
		}catch(Exception e){
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl(url);
	}
	
	@RequestMapping(value="/saveChangeSetStepInfo.do")
	public String saveChangeSetInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		
		HashMap target = new HashMap();
		
		try{
			
			HashMap setMap = new HashMap();
			HashMap updateCommandMap = new HashMap();
			
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
			String LanguageID = StringUtil.checkNull(request.getParameter("LanguageID"),"");
			String userId = StringUtil.checkNull(request.getParameter("userId"),"");
			String classCode = StringUtil.checkNull(request.getParameter("classCode"),"");
			String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"),"");
			String screenMode = StringUtil.checkNull(request.getParameter("screenMode"),"");
			
			updateCommandMap.put("s_itemID", s_itemID);
			updateCommandMap.put("LanguageID", LanguageID);
			updateCommandMap.put("ChangeSetID", changeSetID);
			updateCommandMap.put("userId", userId);
			
			if (screenMode.equals("0")) {
				/* CBO List Program Status */
				// [Functional Design] update
				// Program Status
				updateCommandMap.put("ProgramStatus", "PGRSTS1");
				updateCommandMap.put("InChargeUser", StringUtil.checkNull(request.getParameter("userSel1"))); // 담당자
				updateCommandMap.put("PlannedStartDate", emptyDateToNull(request.getParameter("PlannedStartDate1"))); // 예정시작일
				updateCommandMap.put("PlannedEndDate", emptyDateToNull(request.getParameter("PlannedEndDate1"))); // 예정완료일
				updateCommandMap.put("ActualStartDate", emptyDateToNull(request.getParameter("ActualStartDate1"))); // 시작일
				updateCommandMap.put("ActualEndDate", emptyDateToNull(request.getParameter("ActualEndDate1"))); // 완료일
				updateCommandMap.put("Status", StringUtil.checkNull(request.getParameter("status1"))); // 진행 상태
				commonService.update("cs_SQL.updateChangeSetStep", updateCommandMap);	
				
				// [Program 개발] update
				// Program Status
				updateCommandMap.put("ProgramStatus", "PGRSTS2");
				updateCommandMap.put("InChargeUser", StringUtil.checkNull(request.getParameter("userSel2"))); // 담당자
				updateCommandMap.put("PlannedStartDate", emptyDateToNull(request.getParameter("PlannedStartDate2"))); // 예정시작일
				updateCommandMap.put("PlannedEndDate", emptyDateToNull(request.getParameter("PlannedEndDate2"))); // 예정완료일
				updateCommandMap.put("ActualStartDate", emptyDateToNull(request.getParameter("ActualStartDate2"))); // 시작일
				updateCommandMap.put("ActualEndDate", emptyDateToNull(request.getParameter("ActualEndDate2"))); // 완료일
				updateCommandMap.put("Status", StringUtil.checkNull(request.getParameter("status2"))); // 진행 상태
				commonService.update("cs_SQL.updateChangeSetStep", updateCommandMap);
				
				// [Unit Test] update
				// Program Status
				updateCommandMap.put("ProgramStatus", "PGRSTS3");
				updateCommandMap.put("InChargeUser", StringUtil.checkNull(request.getParameter("userSel3"))); // 담당자
				updateCommandMap.put("PlannedStartDate", emptyDateToNull(request.getParameter("PlannedStartDate3"))); // 예정시작일
				updateCommandMap.put("PlannedEndDate", emptyDateToNull(request.getParameter("PlannedEndDate3"))); // 예정완료일
				updateCommandMap.put("ActualStartDate", emptyDateToNull(request.getParameter("ActualStartDate3"))); // 시작일
				updateCommandMap.put("ActualEndDate", emptyDateToNull(request.getParameter("ActualEndDate3"))); // 완료일
				updateCommandMap.put("Status", StringUtil.checkNull(request.getParameter("status3"))); // 진행 상태
				updateCommandMap.put("UTScenarioStatus", StringUtil.checkNull(request.getParameter("uTScenarioStatus"))); // 시나리오작성
				commonService.update("cs_SQL.updateChangeSetStep", updateCommandMap);
				
				// [Technical Design] update
				// Program Status
				updateCommandMap.put("ProgramStatus", "PGRSTS4");
				updateCommandMap.put("InChargeUser", StringUtil.checkNull(request.getParameter("userSel4"))); // 담당자
				updateCommandMap.put("PlannedStartDate", emptyDateToNull(request.getParameter("PlannedStartDate4"))); // 예정시작일
				updateCommandMap.put("PlannedEndDate", emptyDateToNull(request.getParameter("PlannedEndDate4"))); // 예정완료일
				updateCommandMap.put("ActualStartDate", emptyDateToNull(request.getParameter("ActualStartDate4"))); // 시작일
				updateCommandMap.put("ActualEndDate", emptyDateToNull(request.getParameter("ActualEndDate4"))); // 완료일
				updateCommandMap.put("Status", StringUtil.checkNull(request.getParameter("status4"))); // 진행 상태
				updateCommandMap.put("UTScenarioStatus", null); // 시나리오작성
				commonService.update("cs_SQL.updateChangeSetStep", updateCommandMap);
			} else {
				
				/* I/F Master Program Status */
				// [I/F Mapping 정의서 작성] update
				// Program Status
				updateCommandMap.put("ProgramStatus", "IFSTS1");
				updateCommandMap.put("PlannedStartDate", emptyDateToNull(request.getParameter("If_PlannedStartDate1"))); // 예정시작일
				updateCommandMap.put("PlannedEndDate", emptyDateToNull(request.getParameter("If_PlannedEndDate1"))); // 예정완료일
				updateCommandMap.put("ActualStartDate", emptyDateToNull(request.getParameter("If_ActualStartDate1"))); // 시작일
				updateCommandMap.put("ActualEndDate", emptyDateToNull(request.getParameter("If_ActualEndDate1"))); // 완료일
				
				updateCommandMap.put("LegacyActualEndDate", emptyDateToNull(request.getParameter("LegacyActualEndDate1")));
				updateCommandMap.put("IfMappingName", StringUtil.checkNull(request.getParameter("IfMappingName")));
				commonService.update("cs_SQL.updateChangeSetStep", updateCommandMap);	
				
				// [I/F Program 개발] update
				// Program Status
				updateCommandMap.put("ProgramStatus", "IFSTS2");
				updateCommandMap.put("PlannedStartDate", emptyDateToNull(request.getParameter("If_PlannedStartDate2"))); // 예정시작일
				updateCommandMap.put("PlannedEndDate", emptyDateToNull(request.getParameter("If_PlannedEndDate2"))); // 예정완료일
				updateCommandMap.put("ActualStartDate", emptyDateToNull(request.getParameter("If_ActualStartDate2"))); // 시작일
				updateCommandMap.put("ActualEndDate", emptyDateToNull(request.getParameter("If_ActualEndDate2"))); // 완료일
				
				updateCommandMap.put("EAIEndDate", emptyDateToNull(request.getParameter("EAIEndDate2")));
				updateCommandMap.put("LegacyPlannedEndDate", emptyDateToNull(request.getParameter("LegacyPlannedEndDate2")));
				updateCommandMap.put("LegacyActualEndDate", emptyDateToNull(request.getParameter("LegacyActualEndDate2")));
				updateCommandMap.put("IfMappingName", null);
				commonService.update("cs_SQL.updateChangeSetStep", updateCommandMap);
				
				// [Unit Test] update
				// Program Status
				updateCommandMap.put("ProgramStatus", "IFSTS3");
				updateCommandMap.put("PlannedStartDate", emptyDateToNull(request.getParameter("If_PlannedStartDate3"))); // 예정시작일
				updateCommandMap.put("PlannedEndDate", emptyDateToNull(request.getParameter("If_PlannedEndDate3"))); // 예정완료일
				updateCommandMap.put("ActualStartDate", emptyDateToNull(request.getParameter("If_ActualStartDate3"))); // 시작일
				updateCommandMap.put("ActualEndDate", emptyDateToNull(request.getParameter("If_ActualEndDate3"))); // 완료일
				
				updateCommandMap.put("EAIEndDate", null);
				updateCommandMap.put("MWUtEndDate", emptyDateToNull(request.getParameter("MWUtEndDate")));
				updateCommandMap.put("LegacyActualEndDate", emptyDateToNull(request.getParameter("LegacyActualEndDate3")));
				updateCommandMap.put("LegacyPlannedEndDate", null);
				updateCommandMap.put("IfMappingName", null);
				commonService.update("cs_SQL.updateChangeSetStep", updateCommandMap);
				
				// [연동테스트] update
				// Program Status
				updateCommandMap.put("ProgramStatus", "IFSTS4");
				updateCommandMap.put("PlannedStartDate", emptyDateToNull(request.getParameter("If_PlannedStartDate4"))); // 예정시작일
				updateCommandMap.put("PlannedEndDate", emptyDateToNull(request.getParameter("If_PlannedEndDate4"))); // 예정완료일
				updateCommandMap.put("ActualStartDate", emptyDateToNull(request.getParameter("If_ActualStartDate4"))); // 시작일
				updateCommandMap.put("ActualEndDate", emptyDateToNull(request.getParameter("If_ActualEndDate4"))); // 완료일
				
				updateCommandMap.put("EAIEndDate", null);
				updateCommandMap.put("MWUtEndDate", null);
				updateCommandMap.put("LegacyActualEndDate", null);
				updateCommandMap.put("LegacyPlannedEndDate", null);
				updateCommandMap.put("IfMappingName", null);
				
				commonService.update("cs_SQL.updateChangeSetStep", updateCommandMap);
			}
			
			//target.put(AJAX_ALERT, "저장이 성공하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.selfClose('"+s_itemID+"', '"+classCode+"');this.$('#isSubmit').remove();");
			
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			//target.put(AJAX_ALERT, " 저장중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);		
	}
	
	private String emptyDateToNull(String strDate) {
		String result = strDate;
		
		if (strDate.equals("undefined") || strDate.trim().isEmpty()) {
			result = null;
		}
		
		return result;
	}
	
}
