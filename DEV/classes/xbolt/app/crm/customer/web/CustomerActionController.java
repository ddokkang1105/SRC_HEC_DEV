package xbolt.app.crm.customer.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.org.json.JSONArray;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.cmm.framework.util.AESUtil;
/**
 * 공통 서블릿 처리
 * @Class Name : CustomerActionController.java
 * @Description : 조직관련 화면을 제공한다.
 * @Modification Information
 * @수정일			수정자		수정내용
 * @--------- 		---------	-------------------------------
 * @2012. 10. 15.	jhAhn		최초생성
 *
 * @since 2012. 10. 15.
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class CustomerActionController extends XboltController{

	@Resource(name = "commonService")
	private CommonService commonService;
	/*@Resource(name = "userService")
	private CommonService userService;*/
	private AESUtil aesAction;
	
	@RequestMapping(value="/custList.do")
	public String custList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		Map setMap = new HashMap();
		try {
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "1"));
			
			String custType = StringUtil.checkNull(request.getParameter("custType"), "CS");
			custType = custType.equals("CS") ? "Customer" : "Partner";
			model.put("custType", custType);
			
			cmmMap.put("category","CUSTTP");
			cmmMap.put("typeCode",StringUtil.checkNull(request.getParameter("custLvl"), "G"));
			model.put("custLvl", commonService.selectString("common_SQL.getNameFromDic", cmmMap));
			
			String arcCode =  StringUtil.checkNull(request.getParameter("arcCode"),"");
			String menuStyle =  StringUtil.checkNull(cmmMap.get("menuStyle"),"");
			model.put("arcCode", arcCode);
			model.put("menuStyle", menuStyle);
			
			cmmMap.put("ArcCode", arcCode);
			Map arcMap = commonService.select("config_SQL.getSelectArchitecure", cmmMap);
			model.put("arcMap",arcMap);
			
			List gridList = commonService.selectList("crm_SQL.custList_gridList", cmmMap);
			JSONArray gridData = new JSONArray(gridList);
			model.put("gridData",gridData);
		}catch(Exception e){
			System.out.println(e.toString());
		}
		return nextUrl("/app/crm/cust/custList");
	}
	
	@RequestMapping(value="/registerCust.do")
	public String registerCust(HttpServletRequest request, ModelMap model) throws Exception{
		Map setMap = new HashMap();
		try {
			model.put("arcCode", StringUtil.checkNull(request.getParameter("arcCode"),""));
			model.put("viewType", "N");
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "1"));
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
		
		return nextUrl("/app/crm/cust/registerCust");
	}
	
	
	@RequestMapping(value="/saveCust.do")
	public String saveCust(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		HashMap target = new HashMap();
		String viewType = request.getParameter("viewType");
		try {
			Map getMap = new HashMap();
			String custType = StringUtil.checkNull(request.getParameter("custType"),"");
			String custGRNo = StringUtil.checkNull(request.getParameter("custGRNo"),""); 
			String parentNo = StringUtil.checkNull(request.getParameter("parentNo"),"");
			String parentID = StringUtil.checkNull(request.getParameter("parentID"),"");
			String companyID = StringUtil.checkNull(request.getParameter("companyID"),"");
			String customerNo = StringUtil.checkNull(request.getParameter("customerNo"),""); 
			String teamID = StringUtil.checkNull(request.getParameter("teamID"),""); 
			
			getMap.put("regUserID", StringUtil.checkNull(request.getParameter("regUserID"),""));
			getMap.put("custType",custType);
			getMap.put("bizNo", StringUtil.checkNull(request.getParameter("bizNo"),""));
			getMap.put("ceoName", StringUtil.checkNull(request.getParameter("ceoName"),""));
			getMap.put("bizType", StringUtil.checkNull(request.getParameter("bizType"),""));
			getMap.put("bizItem", StringUtil.checkNull(request.getParameter("bizItem"),""));
			getMap.put("countryID", StringUtil.checkNull(request.getParameter("countryID"),""));
			getMap.put("custLvl", StringUtil.checkNull(request.getParameter("custLvl"),""));
			getMap.put("customerDesc", StringUtil.checkNull(request.getParameter("customerDesc"),""));
			getMap.put("parentNo", parentNo);
			getMap.put("userID", commandMap.get("sessionUserId"));
			getMap.put("active", StringUtil.checkNull(request.getParameter("active"),""));
			
			getMap.put("state", StringUtil.checkNull(request.getParameter("state"),""));
			getMap.put("city", StringUtil.checkNull(request.getParameter("city"),""));
			getMap.put("addr1", StringUtil.checkNull(request.getParameter("addr1"),""));
			getMap.put("addr2", StringUtil.checkNull(request.getParameter("addr2"),""));
			
			getMap.put("TeamName", StringUtil.checkNull(request.getParameter("customerNM"),""));
			getMap.put("languageID", commandMap.get("sessionCurrLangType"));
			
			String teamType = "";
			if(StringUtil.checkNull(request.getParameter("custLvl"),"").equals("G")){teamType = "1";}
			else if(StringUtil.checkNull(request.getParameter("custLvl"),"").equals("C")){teamType = "2";}
			else if(StringUtil.checkNull(request.getParameter("custLvl"),"").equals("D")){teamType = "4";}
			getMap.put("TeamType", teamType);
			
			if(viewType.equals("N")){
				String maxCustomerNo = StringUtil.checkNull(commonService.selectString("crm_SQL.getMaxCustNo", getMap));
				teamID = commonService.selectString("organization_SQL.getMaxTeamId", getMap).trim();
								
				for(int i = 0; 10 - maxCustomerNo.length() > i; i++){
					customerNo = "0"+customerNo;
				}
				customerNo = customerNo + maxCustomerNo;
				
			}
			if(teamType.equals("1")){ //GROUP
				if(custType.equals("CS")){parentID = "1";}
				else{parentID = "20";}
				getMap.put("custGRNo",customerNo);
			}else{
				getMap.put("customerNo", parentNo);//ParentID값 구하기위해 임시로
				parentID = StringUtil.checkNull(commonService.selectString("crm_SQL.getTeamIDFromCust", getMap).trim(),"");
				getMap.remove("customerNo");
				if(teamType.equals("2")){ //COMPANY
					getMap.put("custGRNo",parentNo);
					companyID = teamID;
				}else{ //DIVISION
					getMap.put("custGRNo",commonService.selectString("crm_SQL.getCustGRNo", getMap).trim());
					companyID = parentID;
				}
			}
			
			getMap.put("companyID",companyID);
			getMap.put("parentID",parentID);
			getMap.put("ParentID",parentID);
			getMap.put("customerNo", customerNo);
			getMap.put("TeamID", teamID);
			
			if(viewType.equals("N")){
				commonService.insert("crm_SQL.insertCustMst", getMap);
				if(!teamType.equals("1")){commonService.insert("crm_SQL.insertCustAddr", getMap);}
				commonService.insert("organization_SQL.addTeam", getMap);
				commonService.insert("organization_SQL.addTeamText", getMap);
				
				getMap.put("TeamName", StringUtil.checkNull(request.getParameter("customerNM_EN"),""));
				getMap.put("languageID","1033");
				commonService.insert("organization_SQL.addTeamText", getMap);
			}else{
				commonService.update("crm_SQL.updateCustMst", getMap);
				if(!teamType.equals("1")){commonService.update("crm_SQL.updateCustAddr", getMap);}
				commonService.update("organization_SQL.updateTeam", getMap);
				commonService.update("organization_SQL.updateTeamText", getMap);
				
				getMap.put("TeamName", StringUtil.checkNull(request.getParameter("customerNM_EN"),""));
				getMap.put("languageID","1033");
				commonService.insert("organization_SQL.updateTeamText", getMap);
			}

			String script = StringUtil.checkNull(request.getParameter("script"),"this.goBack();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, script + "this.$('#isSubmit').remove()");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		
		model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
		model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "1"));
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	
	}
	
	@RequestMapping(value="/editCustDetail.do")
	public String editCustDetail(HttpServletRequest request, ModelMap model) throws Exception{
		Map getMap = new HashMap();
		try {
			getMap.put("customerNo", request.getParameter("customerNo"));
			getMap.put("languageID", request.getParameter("languageID"));
			getMap = (HashMap) commonService.select("crm_SQL.getCustMstDetail", getMap);
			
			model.put("viewType", "E");
			model.put("languageID", request.getParameter("languageID"));
			model.put("resultMap", getMap);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "1"));
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
		
		return nextUrl("/app/crm/cust/registerCust");
	}
	
	@RequestMapping(value="/custDetail.do")
	public String custDetail(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		Map setData = new HashMap();
		try {
			String custTeamID = StringUtil.checkNull(request.getParameter("custTeamID"));
			String srType = StringUtil.checkNull(request.getParameter("srType"));
			setData.put("custTeamID", custTeamID);
			String customerNo = commonService.selectString("crm_SQL.getCustTeamID", setData);
			
			setData.put("customerNo", StringUtil.checkNull(customerNo,request.getParameter("customerNo")));
			setData.put("languageID", cmmMap.get("sessionCurrLangType"));
			Map custMap = (HashMap) commonService.select("crm_SQL.getCustMstDetail", setData);
			
			setData.put("companyID", custMap.get("CompanyID"));
			List projectList = commonService.selectList("project_SQL.getProjectIDForCRM",setData);
			String projectIDs = "";
			if(projectList.size() > 0){
				for (int index = 0; index < projectList.size(); index++) {
			    	 	projectIDs = projectIDs + projectList.get(index) + ",";
			     }	
				projectIDs = projectIDs.substring(0,projectIDs.length()-1);
			}
			
			setData.put("teamID", custTeamID);
			String itemID = commonService.selectString("crm_SQL.getTeamItemID", setData);
			
			Map setMap = new HashMap();
			setData.put("srTypeCode", srType);				
			Map srTypeInfo = commonService.select("esm_SQL.getESMSRTypeInfo",setData);
			String srVarFilter = StringUtil.checkNull(srTypeInfo.get("VarFilter"));
			model.put("srVarFilter", srVarFilter);
			
			model.put("itemID", itemID);
			model.put("resultMap", custMap);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			
			model.put("customerNo", StringUtil.checkNull(customerNo,request.getParameter("customerNo")));
			model.put("custGRNo", StringUtil.checkNull(request.getParameter("custGRNo")));
			model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "1"));
			model.put("custLvl", request.getParameter("custLvl"));
			model.put("custType", request.getParameter("custType"));
			model.put("projectIDs", projectIDs);
		
		}catch(Exception e){
			System.out.println(e.toString());
		}
		
		return nextUrl("/app/crm/cust/custDetail");
	}
	
	@RequestMapping(value="/custTreeMgt.do")
	public String custTreeMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		Map setData = new HashMap();
		try {
			setData.put("customerNo", request.getParameter("customerNo"));
			setData.put("languageID", cmmMap.get("sessionCurrLangType"));
			String teamID = commonService.selectString("crm_SQL.getTeamIDFromCust", setData);
			
			model.put("teamID", teamID);
			model.put("customerNo", request.getParameter("customerNo"));
			model.put("custGRNo", request.getParameter("custGRNo"));
			model.put("custLvl", request.getParameter("custLvl"));
			model.put("custType", request.getParameter("custType"));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "1"));			
			model.put("arcCode", StringUtil.checkNull(cmmMap.get("arcCode"),""));
			model.put("menuStyle", StringUtil.checkNull(cmmMap.get("menuStyle"),""));
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
		
		return nextUrl("/app/crm/cust/custTreeMgt");
	}
	
	@RequestMapping(value = "/deleteCust.do")
	public String deleteCust(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
				String items = StringUtil.checkNull(request.getParameter("items"), "");
				String teamNo[] = items.split(",");
				
				String teamID = "";
				if (teamNo != null) {
					for (int i = 0; i < teamNo.length; i++) {
						teamID = teamNo[i];
						setMap.put("teamID", teamID);
						commonService.delete("crm_SQL.deleteCust",setMap);
					}
				}
							
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 저장 성공
				target.put(AJAX_SCRIPT, "this.location.reload();this.$('#isSubmit').remove()");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	
	
}
