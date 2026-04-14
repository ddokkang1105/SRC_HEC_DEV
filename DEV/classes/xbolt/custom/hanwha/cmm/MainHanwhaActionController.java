package xbolt.custom.hanwha.cmm;

import hanwha.neo.slo.SLOCrypt4AES;
import hanwha.neo.slo.SLODecrypt4AES;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.hanwha.hwc.slo.SLOUtil;

import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.custom.hanwha.val.HanwhaGlobalVal;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.service.CommonService;
import xbolt.custom.hanwha.slo.neo.branch.common.sso.service.NeoSloWsProxy;

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
public class MainHanwhaActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;

	// HanwhaTotal 
	@RequestMapping(value="/indexHW.do")
	public String indexHW(Map cmmMap,ModelMap model, HttpServletRequest request) throws Exception {
		try{
			NeoSloWsProxy proxy = new NeoSloWsProxy();
			String user = StringUtil.checkNull(cmmMap.get("user"));
			System.out.println("user:"+user);
			System.out.println("HW_WSDL_SERVICE_URL :"+HanwhaGlobalVal.HW_WSDL_SERVICE_URL.trim()+"/api/ss/neoslo");    
		   /*	try{
					//ota = proxy.create("kiseon.lee", "P", "Prime"); // OTA 생성
					ota = proxy.create(user, "P", "Prime"); // OTA 생성
			}catch(Exception e){
				System.out.println("OTA Create ERR :"+e);
			}*/
			
			String ota = StringUtil.checkNull(cmmMap.get("slo_p_ota"));
			System.out.println("ota :: >"+ota);
			String encUserInfo = "";
			if(!ota.equals("")){
				try{
					encUserInfo = proxy.login(ota, "Prime");
				}catch (Exception e) {
					System.out.println("ERR :"+e);
					return nextUrl("indexHW");
				}
			
			
				String seed = "1556889699646683";
				String userInfo = SLODecrypt4AES.decrypt(encUserInfo,seed); // ex) String encUserInfo = proxy.login(otaId, "시스템 구분값");
				System.out.println("userInfo :"+userInfo);
				model.put("olmI", StringUtil.checkNull(userInfo));
			}else{
				model.put("olmI", StringUtil.checkNull(cmmMap.get("user")) );
			}
			String pass = StringUtil.checkNull(cmmMap.get("olmP"));
			model.put("olmP", pass);
			model.put("olmLng", StringUtil.checkNull(cmmMap.get("olmLng"),""));
			model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType"),""));
			model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType"),""));
			model.put("srID", StringUtil.checkNull(cmmMap.get("srID"),""));
			model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode"),""));
			model.put("proposal", StringUtil.checkNull(cmmMap.get("proposal"),""));
			model.put("status", StringUtil.checkNull(cmmMap.get("status"),""));
			model.put("fileID", StringUtil.checkNull(cmmMap.get("fileID"),""));
		}catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("MainHanwahActionController::mainpage::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl("indexHW");
	}
	
	@RequestMapping(value="/mainHomeHWC.do")
	public String mainHomeHWC(HttpServletRequest request, Map cmmMap,ModelMap model) throws Exception {
		model.put("menu", getLabel(request, commonService));
		return nextUrl("/custom/hanwha/hwc/mainHomeHWC");
	}
	
	// HanwhaDefense 
	@RequestMapping(value="/indexHWC.do")
	public String indexHWC(Map cmmMap,ModelMap model, HttpServletRequest request) throws Exception {
		try{
			NeoSloWsProxy proxy = new NeoSloWsProxy();
			String user = StringUtil.checkNull(cmmMap.get("user"));
			System.out.println("user:"+user);
			System.out.println("HW_WSDL_SERVICE_URL :"+HanwhaGlobalVal.HW_WSDL_SERVICE_URL.trim()+"/api/ss/neoslo");    
		   /*	try{
					//ota = proxy.create("kiseon.lee", "P", "Prime"); // OTA 생성
					ota = proxy.create(user, "P", "Prime"); // OTA 생성
			}catch(Exception e){
				System.out.println("OTA Create ERR :"+e);
			}*/
			
			String ota = StringUtil.checkNull(cmmMap.get("slo_p_ota"));
			System.out.println("ota :: >"+ota);
			String encUserInfo = "";
			if(!ota.equals("")){
				try{
					encUserInfo = proxy.login(ota, "ERP");
				}catch (Exception e) {
					System.out.println("ERR :"+e);
					return nextUrl("indexHW");
				}
			
			
				String seed = "1556889699646683";
				String userInfo = SLODecrypt4AES.decrypt(encUserInfo,seed); // ex) String encUserInfo = proxy.login(otaId, "시스템 구분값");
				System.out.println("userInfo :"+userInfo);
				model.put("olmI", StringUtil.checkNull(userInfo));
			}else{
				model.put("olmI", StringUtil.checkNull(cmmMap.get("user")) );
			}
			String pass = StringUtil.checkNull(cmmMap.get("olmP"));
			model.put("olmP", pass);
			model.put("olmLng", StringUtil.checkNull(cmmMap.get("olmLng"),""));
			model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType"),""));
			model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType"),""));
			model.put("srID", StringUtil.checkNull(cmmMap.get("srID"),""));
			model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode"),""));
			model.put("proposal", StringUtil.checkNull(cmmMap.get("proposal"),""));
			model.put("status", StringUtil.checkNull(cmmMap.get("status"),""));
		}catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("MainHanwahActionController::mainpage::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl("indexHWC");
	}
	
	
	
}
