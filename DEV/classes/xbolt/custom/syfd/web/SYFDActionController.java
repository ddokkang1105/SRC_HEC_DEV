package xbolt.custom.syfd.web;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.saml.SAMLCredential;
import org.springframework.security.saml.userdetails.SAMLUserDetailsService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.AESUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

/**
 * 삼양식품 서블릿 처리
 * @Class Name : SYFDActionController.java
 * @Description : 삼양식품 custom
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2023.09 .08. Smartfactory		최초생성
 *
 * @since 2023. 09. 08.
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class SYFDActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
	private AESUtil aesAction;
	
	@RequestMapping(value="/mainHomeSyfd.do")
	public String mainHomeSyfd(HttpServletRequest request, Map cmmMap,ModelMap model) throws Exception {		
		try {
			Map setMap = new HashMap();
	    	String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),GlobalVal.DEFAULT_LANGUAGE);
	    	setMap.put("languageID", languageID);

			List nameList = (List)commonService.selectList("custom_SQL.SYFD_getMainItem", setMap);
			
			model.put("nameList", nameList);
			model.put("menu", getLabel(request, commonService));
		}
		catch(Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());			
		}
		return nextUrl("/custom/syfd/mainHomeSyfd");
	}

	
	private Map getCountMap(List conutList) {
		Map contMap = new HashMap();
		Map mapValue = new HashMap();
		for(int i = 0; i < conutList.size(); i++){
			mapValue = (HashMap)conutList.get(i);
			contMap.put(mapValue.get("L1ItemID"), mapValue.get("CNT"));
		}
		
		return contMap;
	}
	private Map getCountMap(List conutList, String pKey, String pValue) {
		Map contMap = new HashMap();
		Map mapValue = new HashMap();
		for(int i = 0; i < conutList.size(); i++){
			mapValue = (HashMap)conutList.get(i);
			contMap.put(mapValue.get(pKey), mapValue.get(pValue));
		}
		
		return contMap;
	}
	private String makeGridHeader(List list, String conStr) {
		String strHeader = "";
		for (int i = 0; list.size() > i ; i++) {
			Map map = (Map) list.get(i);
        	String name = String.valueOf(map.get("CODE"));
        	
			strHeader = strHeader + conStr + name;
		}		
		return strHeader;
	}
	private String makeGridHeader(List list, String keyName ,String conStr) {
		String strHeader = "";
		for (int i = 0; list.size() > i ; i++) {
			Map map = (Map) list.get(i);
        	String name = (String) map.get(keyName);
        	
			strHeader = strHeader + conStr + name;
		}		
		return strHeader;
	}
	
}
