package xbolt.hom.hlp.web;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.service.CommonService;

@Controller
public class HelpActionController extends XboltController{
	
	@Autowired
    @Qualifier("commonService")
    private CommonService commonService;
	
	@RequestMapping(value="/helpMenual.do")
	public String helpMenual(HttpServletRequest request, ModelMap model) throws Exception{
		
		try {
			
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl("/hom/hlp/helpMenual");
	}	
	

}
