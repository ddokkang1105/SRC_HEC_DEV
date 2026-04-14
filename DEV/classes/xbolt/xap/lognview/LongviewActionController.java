package xbolt.xap.lognview;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.cmm.framework.util.AESUtil;
/**
 * 
 * @Class Name : LongviewActionController.java
 * @Description : BI Solution Longview interface program
 * @Modification Information
 * @Created on : 2022. 02. 01	WJCHO
 *
 * @Updated on : 2022. 02. 18.
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class LongviewActionController extends XboltController{

	@Resource(name = "commonService")
	private CommonService commonService;

	
	@RequestMapping(value="/xLV_callApd_Rpt.do")
	public String xLV_callApd_Rpt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		Map setMap = new HashMap();
		try { //AT00014 �샇異쒗빐�꽌
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "1"));
			model.put("custType", StringUtil.checkNull(request.getParameter("custType"), "CS"));
			model.put("custLvl", StringUtil.checkNull(request.getParameter("custLvl"), "G"));
			String s_itemID =  StringUtil.checkNull(cmmMap.get("s_itemID"),"");
			String languageID =  StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),"");
			String apdID =  StringUtil.checkNull(cmmMap.get("apdID"),"");
			String menuStyle =  StringUtil.checkNull(cmmMap.get("menuStyle"),"");
			setMap.put("itemID",s_itemID);
			setMap.put("languageID",languageID);
			String AT00014 = StringUtil.checkNull(commonService.selectString("attr_SQL.getItemSysName",setMap),"");
			
			if(!"".equals(AT00014)) {
				apdID = AT00014;
			}
			
			model.put("apdID", apdID);
			model.put("menuStyle", menuStyle);
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
		return nextUrl("/xap/longview/xLV_Call_Apd_Rpt");
	}
	
}
