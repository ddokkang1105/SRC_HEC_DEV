package xbolt.custom.daesang.web;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.saerom.onepass.client.OnepassClient;

import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.service.CommonService;

/**
 * 공통 서블릿 처리
 * @Class Name : MainHanwhaActionController.java
 * @Description : 공통화면을 제공한다.
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2015. 12. 28. smartfactory		최초생성
 *
 * @since 2015. 12. 28.
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class MainDaesangActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;

	// HanwhaTotal 
	@RequestMapping(value="/indexDS.do")
	public String indexDS(Map cmmMap,ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		try{			
			
			OnepassClient onepassClinet = new OnepassClient(request, response);
			HttpSession session = request.getSession();
			
			if(onepassClinet.ssoValidate()){
				String ssoID = (String)session.getAttribute("onepassid");	// SSO 아이디
				String ssoCompanyCD = (String)session.getAttribute("userinfo1");		// SSO 비밀번호
				String ssoEmp = (String)session.getAttribute("empnumber");	// 사번

				model.put("olmI", ssoEmp);
				model.put("olmP", "");
				model.put("olmLng", StringUtil.checkNull(cmmMap.get("olmLng"),""));
				model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType"),""));
				model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType"),""));
				model.put("srID", StringUtil.checkNull(cmmMap.get("srID"),""));
				model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode"),""));
				model.put("proposal", StringUtil.checkNull(cmmMap.get("proposal"),""));
				model.put("status", StringUtil.checkNull(cmmMap.get("status"),""));

			}
		}catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("MainDaesangActionController::mainpage::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl("indexDS");
	}
	
	@RequestMapping(value="/mainHomeDS.do")
	public String mainHomeDS(HttpServletRequest request, Map cmmMap,ModelMap model) throws Exception {
		model.put("menu", getLabel(request, commonService));
		return nextUrl("/custom/daesang/mainHomeDS");
	}
	
	
}
