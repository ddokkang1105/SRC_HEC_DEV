package xbolt.custom.lf.web;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
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

import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.service.CommonService;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

/**
 * 공통 서블릿 처리
 * @Class Name : MainLfActionController.java
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
public class MainLfActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
	@Resource(name = "commonOraService")
	private CommonService commonOraService;

	@RequestMapping(value="/indexLF.do")
	public String indexLF(Map cmmMap,ModelMap model, HttpServletResponse response) throws Exception {	   
		String RTN = null;
		try {
			String apiUrl = "https://ei-gateway-uat.lfcorp.com/services/sso-v3/sso?p1="
							+cmmMap.get("p1")+"&P2="+cmmMap.get("p2")+"&P3="+cmmMap.get("p3")+"&P4="+cmmMap.get("p4")+"&P5="+cmmMap.get("p5");
			URL url = new URL(apiUrl);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			conn.setRequestProperty("Accept", "application/json");
			conn.setDoOutput(true);
			
			int responseCode = conn.getResponseCode();
			System.out.println("responseCode == "+responseCode);
			
			 if (responseCode == 400) {
	            System.out.println("400:: 해당 명령을 실행할 수 없음 ");
	        } else if (responseCode == 401) {
	            System.out.println("401:: X-Auth-Token Header가 잘못됨");
	        } else if (responseCode == 500) {
	            System.out.println("500:: 서버 에러, 문의 필요");
	        } else if (responseCode == conn.HTTP_OK){
	            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8"));
	            System.out.println("br == "+br);
	            
	            StringBuilder sb = new StringBuilder();
	            String line = "";
	            while ((line = br.readLine()) != null) {
	                sb.append(line);
	            }
	            br.close();
				
				JSONParser parser = new JSONParser();
				JSONObject jsonObject = (JSONObject) parser.parse(sb.toString());
				
				JSONObject result = (JSONObject) jsonObject.get("result");
				JSONObject data = (JSONObject) ((JSONArray) result.get("data")).get(0);
				RTN = StringUtil.checkNull(data.get("RTN"));
				System.out.println("RTN == "+RTN);
	        }
		 
			model.put("p1", cmmMap.get("p1"));
			model.put("p2", cmmMap.get("p2"));
			model.put("p3", cmmMap.get("p3"));
			model.put("p4", cmmMap.get("p4"));
			model.put("p5", cmmMap.get("p5"));
			
			String pass = StringUtil.checkNull(cmmMap.get("olmP"));
			model.put("olmI", StringUtil.checkNull(cmmMap.get("p1"),""));
			model.put("olmP", pass);
			model.put("olmLng", StringUtil.checkNull(cmmMap.get("olmLng"),""));
			model.put("RTN", RTN);
		} catch(IOException e) {
			System.out.println("IOExceptin "+e.getCause());
			e.printStackTrace();
		} catch(Exception e) {
			System.out.println("Exception "+e.getCause());
			e.printStackTrace();
		} 
		
		return nextUrl("indexLF");
	}
	
	@RequestMapping(value="/olmLinkLF.do")
	public String olmLinkLF(Map cmmMap,ModelMap model) throws Exception {
		Map sso1Map = new HashMap();
		model.put("p1", cmmMap.get("p1"));
		model.put("p2", cmmMap.get("p2"));
		model.put("p3", cmmMap.get("p3"));
		model.put("p4", cmmMap.get("p4"));
		model.put("p5", cmmMap.get("p5"));
		
		model.put("object", cmmMap.get("object"));
		model.put("linkType", cmmMap.get("linkType"));
		model.put("linkID", cmmMap.get("linkID"));
		model.put("iType", cmmMap.get("iType"));
		model.put("languageID", cmmMap.get("olmLng"));
		
		String loginid = StringUtil.checkNull(cmmMap.get("p1"),"");
		String defaltLangCode = GlobalVal.DEFAULT_LANG_CODE;
		
		String logSso1Check =  StringUtil.checkNull(commonOraService.selectString("lf_ORASQL.getCheckLogSso1", cmmMap)); // LF DBLink 조회 
		String pass = StringUtil.checkNull(cmmMap.get("olmP"));
		model.put("loginid", loginid);
		model.put("DEFAULT_LANG_CODE", defaltLangCode);
		model.put("logSso1Check", logSso1Check);
		model.put("IS_CHECK", "N");
		
		return nextUrl("/custom/lf/olmLinkPopup");
	}
	
	@RequestMapping(value="/LFMainHome.do")
	public String LFMainHome(HttpServletRequest request, Map cmmMap,ModelMap model) throws Exception {
		Map sso1Map = new HashMap();
		model.put("menu", getLabel(request, commonService));
		return nextUrl("/custom/lf/LFMainHome");
	}	

	
	@RequestMapping(value="/mainHomeLF.do")
	public String mainHomeLF(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception{
		Map setData = new HashMap();
		setData.put("sessionCurrLangType", cmmMap.get("sessionCurrLangType"));
		setData.put("sessionUserId", cmmMap.get("sessionUserId"));
		setData.put("templCode", "TMPL003");		
		Map templateMap = commonService.select("menu_SQL.mainTempl_select",setData);
		
		model.put("templateMap", templateMap);
		model.put("menu", getLabel(request, commonService));	//Label Setting
		model.put("screenType", request.getParameter("screenType"));
		return nextUrl("/custom/lf/mainHomeLF");
	}
}
