package xbolt.custom.samsung.cmm;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
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
 * @Class Name : MainSEMESActionController.java
 * @Description : MainSEMESActionController.java
 * @Modification Information
 * @수정일  수정자   수정내용
 * @--------- --------- -------------------------------
 * @2016. 12. 14. smartfactory  최초생성
 *
 * @since 2016. 12. 14.
 * @version 1.0
 * @see
 */
@Controller
@SuppressWarnings("unchecked")
public class MainSamsungActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;


	

	@RequestMapping(value="/olmLinkSamsung.do")
	public String olmLinkSamsung(Map cmmMap, ModelMap model, HttpServletRequest request) throws Exception {
		String url = "/custom/samsung/cmm/linkSSO";
		String defaltLangCode = GlobalVal.DEFAULT_LANG_CODE;
		String keyId = (String) cmmMap.get("keyId");
		String object = (String) cmmMap.get("object");
		String linkType = (String) cmmMap.get("linkType");
		String linkID = (String) cmmMap.get("linkID");
		String iType = (String) cmmMap.get("iType");
		String aType = (String) cmmMap.get("aType");
		
		Map setMap = new HashMap();
		String langCode = (String) cmmMap.get("language");
		
		setMap.put("extCode", langCode);
		
		langCode = commonService.selectString("common_SQL.getLanguageID", setMap);
		
		model.put("DEFAULT_LANG_CODE", defaltLangCode);
		model.put("keyId", keyId);
		model.put("object", object);
		model.put("linkType", linkType);
		model.put("linkID", linkID);
		model.put("iType", iType);
		model.put("aType", aType);
		model.put("languageID", langCode);
		
		return nextUrl(url);
		
	
	}	
	
	@RequestMapping(value="/olmLinkSSOPop.do")
	public String olmLinkSSOPop(Map cmmMap, ModelMap model, HttpServletRequest request) throws Exception {
		String url = "/custom/samsung/cmm/olmLinkPop";
		String defaltLangCode = GlobalVal.DEFAULT_LANG_CODE;
		String keyId = (String) cmmMap.get("keyId");
		String object = (String) cmmMap.get("object");
		String linkType = (String) cmmMap.get("linkType");
		String linkID = (String) cmmMap.get("linkID");
		String iType = (String) cmmMap.get("iType");
		String aType = (String) cmmMap.get("aType");
		String loginID = (String) cmmMap.get("loginID");
		String languageID = (String) cmmMap.get("languageID");
		
		model.put("DEFAULT_LANG_CODE", defaltLangCode);
		model.put("keyId", keyId);
		model.put("object", object);
		model.put("linkType", linkType);
		model.put("linkID", linkID);
		model.put("iType", iType);
		model.put("aType", aType);
		model.put("loginID", loginID);
		model.put("languageID", languageID);
		
		return nextUrl(url);
		
	
	}	
	
}
