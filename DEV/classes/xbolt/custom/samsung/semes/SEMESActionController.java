package xbolt.custom.samsung.semes;

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
public class SEMESActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@RequestMapping(value="/indexSEMES.do")
	public String loginsemesForm(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		String pass = StringUtil.checkNull(cmmMap.get("olmP"));
		model.put("olmI", StringUtil.checkNull(cmmMap.get("olmI"),""));
		model.put("olmP", pass);
		model.put("olmLng", StringUtil.checkNull(cmmMap.get("olmLng"),""));
		model.put("loginIdx", "BASE");
		return nextUrl("indexSEMES");
	}	
	
}
