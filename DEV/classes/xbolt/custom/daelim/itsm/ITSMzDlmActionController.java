package xbolt.custom.daelim.itsm ;


import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.View;

import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.service.CommonService;
import xbolt.project.chgInf.web.CSActionController;

/**
 * 
 * @Class Name : DLMActionController.java
 * @Description : Daelim WF Action Controller
 * @since 2024. 08. 02.
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class ITSMzDlmActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	// TODO : 주석해제해서 패치
	//@Resource(name="xsqlSession")
	//private SqlSession xsqlSession;
		
	@Resource(name = "mdItemService")
	private CommonService mdItemService;
	
	@Resource(name = "CSService")
	private CommonService CSService;

	@Resource(name = "CSActionController")
	private CSActionController CSActionController;
	
	//서비스대가산정조회
	@RequestMapping(value = "/zDlm_serviceCal.do")
	public String zDlm_serviceCal(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		
		//System.out.println("=======> 1");
		
		String url = "/custom/daelim/itsm/zDlm_serviceCal"; 
		try {
			
			String scrnType = StringUtil.checkNull(request.getParameter("scrnType"));
			String srID = StringUtil.checkNull(request.getParameter("srID"));
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			model.put("scrnType", scrnType);
			
			//model.put("getYear", commonService.selectList("zDLMserviceCal_SQL.getYear", setMap));
	
		} catch (Exception e) {
			//System.out.println(e.toString());
		}
		
		//System.out.println("=======> 2");
		
		return nextUrl(url);
	}
	
	
	@RequestMapping(value="/exeSvcAdmPkg.do")
	public String exeSvcAdmPkg(HttpServletRequest request, HashMap cmmMap, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		try {
			
			String sApplyYm = StringUtil.checkNull(request.getParameter("applyYm"),"");
			String sCorpId = StringUtil.checkNull(request.getParameter("corpId"),"");

			Map getData = new HashMap();
			getData.put("APPLY_YM", sApplyYm);
			getData.put("CORP_ID", sCorpId);
								
			commonService.insert("zDLMserviceCal_SQL.exeSvcAdmPkg", getData);
			commonService.insert("zDLMserviceCal_SQL.exeSvcAdm2Pkg", getData);
			
			//target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); 
			//target.put(AJAX_SCRIPT, "fnGoSRList();");
			//model.addAttribute(AJAX_RESULTMAP, target);
				
		} catch (Exception e) {
			//System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/zDlm_selectServiceCalExcel.do", method={RequestMethod.POST, RequestMethod.GET}, produces="application/vnd.ms-excel")
	public View zDlm_selectServiceCalExcel(HttpServletRequest request,  HttpServletResponse res, HashMap<String, Object> cmmMap, ModelMap model) throws Exception {
		
		
		//System.out.println("======> sApplyYm : " + request.getParameter("applyYm"));
		//System.out.println("======> sCorpId : " + request.getParameter("corpId"));
		
		String sApplyYm = StringUtil.checkNull(request.getParameter("applyYm"),"");
		String sCorpId = StringUtil.checkNull(request.getParameter("corpId"),"");

		Map getData = new HashMap();
		getData.put("APPLY_YM", sApplyYm);
		getData.put("CORP_ID", sCorpId);
		
		//List<?> result1 = commonService.selectList("zDLMserviceCal_SQL.zDlm_selectServiceCalExcel", getData);
    	//List<?> result2 = commonService.selectList("zDLMserviceCal_SQL.zDlm_selectServiceCalExcel_list1", getData);
    	//List<?> result3 = commonService.selectList("zDLMserviceCal_SQL.zDlm_selectServiceCalExcel_list2", getData);
		
		model.addAttribute("result1", commonService.selectList("zDLMserviceCal_SQL.zDlm_selectServiceCalExcel_gridList", getData));
		model.addAttribute("result2", commonService.selectList("zDLMserviceCal_SQL.zDlm_selectServiceCalExcel_list1", getData));
		model.addAttribute("result3", commonService.selectList("zDLMserviceCal_SQL.zDlm_selectServiceCalExcel_list2", getData));
		
		model.addAttribute("getData", getData);
		
		return new ValueCloseServiceAdminDataExcelView();
	}
	
	
	@RequestMapping(value = "/zDlm_selectServiceCalExcel2.do", method={RequestMethod.POST, RequestMethod.GET}, produces="application/vnd.ms-excel")
	public View zDlm_selectServiceCalExcel2(HttpServletRequest request,  HttpServletResponse res, HashMap<String, Object> cmmMap, ModelMap model) throws Exception {
		
		
		//System.out.println("======> sApplyYm : " + request.getParameter("applyYm"));
		//System.out.println("======> sCorpId : " + request.getParameter("corpId"));
		
		String sApplyYm = StringUtil.checkNull(request.getParameter("applyYm"),"");
		String sCorpId = StringUtil.checkNull(request.getParameter("corpId"),"");

		Map getData = new HashMap();
		getData.put("APPLY_YM", sApplyYm);
		getData.put("CORP_ID", sCorpId);
		
		//List<?> result1 = commonService.selectList("zDLMserviceCal_SQL.zDlm_selectServiceCalExcel", getData);
    	//List<?> result2 = commonService.selectList("zDLMserviceCal_SQL.zDlm_selectServiceCalExcel_list1", getData);
    	//List<?> result3 = commonService.selectList("zDLMserviceCal_SQL.zDlm_selectServiceCalExcel_list2", getData);
		
		
		model.addAttribute("result1", commonService.selectList("zDLMserviceCal_SQL.zDlm_selectServiceCalExcel2_list1", getData));
		model.addAttribute("result2", commonService.selectList("zDLMserviceCal_SQL.zDlm_selectServiceCalExcel2_list2", getData));
		
		model.addAttribute("getData", getData);
		
		return new ServiceValidationExcelView();
	}
	
	
	@RequestMapping(value = "/zDlm_selectServiceCalExcel3.do", method={RequestMethod.POST, RequestMethod.GET}, produces="application/vnd.ms-excel")
	public View zDlm_selectServiceCalExcel3(HttpServletRequest request,  HttpServletResponse res, HashMap<String, Object> cmmMap, ModelMap model) throws Exception {
		
		
		//System.out.println("======> sApplyYm : " + request.getParameter("applyYm"));
		//System.out.println("======> sCorpId : " + request.getParameter("corpId"));
		
		String sfApplyYm = StringUtil.checkNull(request.getParameter("fapplyYm"),"");
		String stApplyYm = StringUtil.checkNull(request.getParameter("tapplyYm"),"");
		String sCorpId = StringUtil.checkNull(request.getParameter("corpId"),"");

		Map getData = new HashMap();
		getData.put("F_APPLY_YM", sfApplyYm);
		getData.put("T_APPLY_YM", stApplyYm);
		getData.put("CORP_ID", sCorpId);
		
		//List<?> result1 = commonService.selectList("zDLMserviceCal_SQL.zDlm_selectServiceCalExcel", getData);
    	//List<?> result2 = commonService.selectList("zDLMserviceCal_SQL.zDlm_selectServiceCalExcel_list1", getData);
    	//List<?> result3 = commonService.selectList("zDLMserviceCal_SQL.zDlm_selectServiceCalExcel_list2", getData);
		
		
		model.addAttribute("result", commonService.selectList("zDLMserviceCal_SQL.zDlm_selectServiceCalExcel3_list", getData));
		
		model.addAttribute("getData", getData);
		
		return new ValueManualCalcExcelView();
	}
	
}
