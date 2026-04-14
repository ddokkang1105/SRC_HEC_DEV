package xbolt.app.esm.eval.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import xbolt.app.esp.main.util.ESPUtil;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.DateUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonService;

/**
 * 공통 서블릿 처리
 * @Class Name : EvalActionController.java
 * @Description : 공통화면을 제공한다.
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2019. 10. 28. Smartfactory 최초생성
 *
 * @since 2019. 10. 28
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class EvalActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
		
	@RequestMapping(value="/viewEvSheet.do")
	public String viewEvSheet(HttpServletRequest request, ModelMap model, HashMap commandMap) throws Exception {
		String url="/app/esm/eval/viewEvSheet";
	try{
		Map setMap = new HashMap();
		String srID = StringUtil.checkNull(request.getParameter("srID"),"");
		String screenType = StringUtil.checkNull(request.getParameter("screenType"),"");
		String esType = StringUtil.checkNull(request.getParameter("esType"),"");
		String srType = StringUtil.checkNull(request.getParameter("srType"),"");
		String speCode = StringUtil.checkNull(request.getParameter("speCode"),"");
		String status = StringUtil.checkNull(request.getParameter("status"),speCode);
		String evalSheetID = StringUtil.checkNull(request.getParameter("evalSheetID"),"");
		String requestUserID = StringUtil.checkNull(request.getParameter("requestUserID"),"");
		String sessionUserID = StringUtil.checkNull(commandMap.get("sessionUserId"),"");
		String tagYN = StringUtil.checkNull(request.getParameter("tagYN"),"");
		
		// screenType 없을 경우 check
		if("".equals(screenType) && "".equals(evalSheetID)) {
			if(requestUserID.equals(sessionUserID)) screenType = "E";
			else screenType = "V";
		}			
		else if("".equals(screenType) && !"".equals(evalSheetID)) screenType = "V";
		
		setMap.put("documentID",srID);
		setMap.put("srTypeCode",srType);
		Map evalTypeInfo = commonService.select("esm_SQL.getESMSRTypeInfo", setMap);
		String evalTypeCode =  StringUtil.checkNull(evalTypeInfo.get("EvalTypeCode"));
		setMap.put("evalTypeCode", evalTypeCode);
		setMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
		
		List evalItemList = commonService.selectList("eval_SQL.getEvalItem", setMap);
		for(int i=0; i<evalItemList.size(); i++){
			Map evalItem = (Map) evalItemList.get(i);
			if(evalItem.get("DataType").equals("LOV")){
				setMap.put("s_itemID", StringUtil.checkNull(evalItem.get("AttrTypeCode")));
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				List lovList = commonService.selectList("attr_SQL.selectAttrLovOption", setMap);
				evalItem.put("LovList", lovList);
				evalItemList.remove(i);
				evalItemList.add(i, evalItem);
			}
			model.put("evItemID", evalItem.get("EvalItemID"));
		}
		
		setMap.put("Category", "EVTP");
		setMap.put("TypeCode", evalTypeCode);
		
				
		List nameByDic = commonService.selectList("common_SQL.label_commonSelect", setMap);
		String evTitleName = StringUtil.checkNull(((Map)nameByDic.get(0)).get("LABEL_NM"));
		
		List evItemValue = new ArrayList();
		//if(screenType.equals("V")){
			Map evalSheetInfoMap = commonService.select("eval_SQL.getEvSheetInfo", setMap);
			setMap.put("evalSheetID", StringUtil.checkNull(evalSheetInfoMap.get("EvalSheetID")));
			model.put("creationTime", StringUtil.checkNull(evalSheetInfoMap.get("CreationTime")));
			evItemValue = commonService.selectList("eval_SQL.getEvalItemValue", setMap);
		//}
		
		model.put("srID", srID);
		model.put("evItemList", evalItemList);
		model.put("evTypeCode", evalTypeCode);
		model.put("evTitleName", evTitleName);
		model.put("evItemValue", evItemValue);
		model.put("evalSheetID", StringUtil.checkNull(evalSheetInfoMap.get("EvalSheetID")));
		model.put("screenType",screenType);
		model.put("esType",esType);
		model.put("srType",srType);
		model.put("status",status);
		model.put("tagYN",tagYN);
		
	} catch (Exception e) {		
		System.out.println(e.toString());
		throw new ExceptionUtil(e.toString());
	}	
		return nextUrl(url);
	}

	@RequestMapping(value="/saveEv.do")
	public String saveEv(HttpServletRequest request, ModelMap model, HashMap commandMap) throws Exception {
		HashMap target = new HashMap();
		try{
			Map setMap = new HashMap();
			String srID = StringUtil.checkNull(request.getParameter("srID"),"");
			String srStatus = StringUtil.checkNull(request.getParameter("srStatus"),"");
			String srType = StringUtil.checkNull(request.getParameter("srType"),"");
			String esType = StringUtil.checkNull(request.getParameter("esType"),"");
			setMap.put("documentID",srID);
			setMap.put("srTypeCode",srType);
			
			String maxEvalSheetID = StringUtil.checkNull(commonService.selectString("eval_SQL.getMaxEvSheetID", setMap)).trim();
			Map evalTypeInfo = commonService.select("esm_SQL.getESMSRTypeInfo", setMap);
			
			// Eval Sheet 생성	
			setMap.put("evalSheetID",maxEvalSheetID);
			setMap.put("evalTypeCode",StringUtil.checkNull(evalTypeInfo.get("EvalTypeCode")));
			setMap.put("docCategory", StringUtil.checkNull(evalTypeInfo.get("DocCategory")));
			setMap.put("evaluatorID",StringUtil.checkNull(commandMap.get("sessionUserId")));
			setMap.put("evalTeamID",commandMap.get("sessionTeamId"));
			commonService.insert("eval_SQL.insertEvalSheet", setMap);
			
			List evalItemList = commonService.selectList("eval_SQL.getEvalItem", setMap);
			for(int i=0; i<evalItemList.size(); i++){
				Map evalItem = (Map) evalItemList.get(i);
				setMap.put("evalItemID",StringUtil.checkNull(evalItem.get("EvalItemID")));
				String attrCode = StringUtil.checkNull(evalItem.get("AttrTypeCode"));
				setMap.put("attrTypeCode",attrCode);
				setMap.put("value",StringUtil.checkNull(request.getParameter(attrCode)));
				commonService.insert("eval_SQL.insertEvalItemValue", setMap);
			}
			
			setMap.put("status",srStatus);
			commonService.update("eval_SQL.updateSRstatus", setMap);
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			if("ITSP".equals(esType)){
				setMap.put("srID",srID);
				setMap.put("speCode",srStatus);
				setMap.put("docCategory", "SR");
				setMap.put("documentID", StringUtil.checkNull(commandMap.get("srID")));
				setMap.put("startTime", DateUtil.getCurrentTime("yyyy-MM-dd HH:mm:ss"));
				setMap.put("endTime", DateUtil.getCurrentTime("yyyy-MM-dd HH:mm:ss"));
				setMap.put("actorID", StringUtil.checkNull(commandMap.get("sessionUserId")));
				setMap.put("actorTeamID", StringUtil.checkNull(commandMap.get("sessionTeamId")));
				ESPUtil.updateESP(request, commonService, setMap);
				target.put(AJAX_SCRIPT, "parent.actionComplete('TAB');");
			} else {
				target.put(AJAX_SCRIPT, "parent.actionComplete();");	
			}
		} catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);		
		return nextUrl(AJAXPAGE);		
	}
}
