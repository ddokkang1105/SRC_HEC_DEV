package xbolt.custom.cj.web;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.service.CommonService;
import xbolt.custom.cj.util.CryptoUtil;

/**
 * 공통 서블릿 처리
 * @Class Name : MainCJActionController.java
 * @Description : 공통화면을 제공한다.
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2016. 12. 14. smartfactory		최초생성
 *
 * @since 2016. 12. 14.
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class MainCJActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;

	// HanwhaTotal 
	@RequestMapping(value="/indexCJ.do")
	public String indexHW(Map cmmMap,ModelMap model, HttpServletRequest request) throws Exception {
		try{
			String userId = StringUtil.checkNull(request.getParameter("userId"));
			String token = StringUtil.checkNull(request.getParameter("token"));
			String keyValue = "SFOL"; 
			String language = StringUtil.checkNull(request.getParameter("language"));
			String loginID = CryptoUtil.decrypt(keyValue, userId);
		
			
			model.put("userId", userId);
			model.put("token", token);
			model.put("language", language);	
			model.put("loginID", loginID);			
		
		}catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("MainCJActionController::mainpage::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl("indexCJ");
	}
	
	@RequestMapping(value="/custom/olmLinkCJ.do")
	public String olmLinkLF(Map cmmMap,ModelMap model, HttpServletRequest request) throws Exception {
		String defaltLangCode = GlobalVal.DEFAULT_LANG_CODE;
		model.put("DEFAULT_LANG_CODE", defaltLangCode);
		
		// SSO
		String userId = StringUtil.checkNull(request.getParameter("userId"));
		String token = StringUtil.checkNull(request.getParameter("token"));
		String keyValue = "SFOL"; 
		String language = StringUtil.checkNull(request.getParameter("language"));
		String loginID = CryptoUtil.decrypt(keyValue, userId);
		
		model.put("userId", userId);
		model.put("token", token);
		model.put("language", language);	
		model.put("loginID", loginID);
		
		// item popup
		String languageID = StringUtil.checkNull(request.getParameter("languageID"));
		String scrnType = StringUtil.checkNull(request.getParameter("scrnType"));
		String object = StringUtil.checkNull(request.getParameter("object"));
		String linkID = StringUtil.checkNull(request.getParameter("linkID"));
		String linkType = StringUtil.checkNull(request.getParameter("linkType"));
		
		model.put("languageID", languageID);
		model.put("scrnType", scrnType);
		model.put("object", object);	
		model.put("linkID", linkID);
		model.put("linkType", linkType);
		
		return nextUrl("/custom/cj/olmLinkPopup");
	}
}
