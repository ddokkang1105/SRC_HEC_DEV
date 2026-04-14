package xbolt.cmm.framework.handler;

import java.util.HashMap;
import java.util.Map;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.service.CommonService;

@Controller
@SuppressWarnings("unchecked")
//@RequestMapping(value = "/error/*.do")
public class ErrorHandler extends XboltController{
	Log log = LogFactory.getLog(this.getClass());	
	
	@Autowired
    @Qualifier("commonService")
    private CommonService commonService;
    
	@RequestMapping(value = "/error/error.do")
	public String getMessage(HashMap commandMap,ModelMap model) throws Exception{
		Map result = null;
		try{
			String code = (String)commandMap.get("ERROR_CD");
			if(null==code || "".equals(code) || code.length()!=6){
				commandMap.put("ERROR_CD","WM00001");
			}
			result= commonService.select("error_SQL.error_message",commandMap);
			model.addAttribute(AJAX_RESULTMAP, result);
		} catch (Exception e){
			System.out.println(e.toString());
		}
		return nextUrl("/cmm/err/errorDetail");
	}
} 