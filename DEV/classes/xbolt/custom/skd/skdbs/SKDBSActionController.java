package xbolt.custom.skd.skdbs;


import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StringReader;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.math.MathContext;
import java.math.RoundingMode;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Optional;

import javax.annotation.Resource;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import javax.security.cert.X509Certificate;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.soap.MessageFactory;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPConnection;
import javax.xml.soap.SOAPConnectionFactory;
import javax.xml.soap.SOAPMessage;
import javax.xml.soap.SOAPPart;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import net.sf.json.JSON;

import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;


import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
















/*
import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;
import com.jcraft.jsch.SftpATTRS;
*/
import com.nets.sso.agent.AuthUtil;
import com.nets.sso.agent.authcheck.AuthCheck;
import com.nets.sso.common.AgentExceptionCode;
import com.nets.sso.common.enums.AuthStatus;
import com.org.json.JSONArray;
import com.org.json.JSONObject;

import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.DRMUtil;
import xbolt.cmm.framework.util.DateUtil;
import xbolt.cmm.framework.util.EmailUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.GetItemAttrList;
import xbolt.cmm.framework.util.JsonUtil;
import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.custom.hyundai.val.HMGGlobalVal;
import xbolt.custom.hanwha.val.HanwhaGlobalVal;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.service.CommonService;
import xbolt.project.chgInf.web.CSActionController;

/**
 * @Class Name : HDCActionController.java
 * @Description : HDCActionController.java
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2021. 09. 02. smartfactory		최초생성
 *
 * @since 2021. 09. 02
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class SKDBSActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;

	@RequestMapping(value="/zSKDBS_getAllProcessList.do")
	public String zSpc_getAllProcessList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map setMap = new HashMap();
		Map tempMap = new HashMap();
		Map attrTypeMap = new HashMap();
		List attrAllocList = new ArrayList();
		setMap.put("languageID", commandMap.get("languageID"));
		String classcodes [] = {"CL01005", "CL01006"};
		for(int i=0; i < classcodes.length; i++) {
			setMap.put("ItemClassCode", classcodes[i]);
			attrAllocList = (List)commonService.selectList("attr_SQL.getAttrAllocList", setMap);
			for(int k=0; k < attrAllocList.size(); k++) {
				tempMap = (HashMap)attrAllocList.get(k);
				attrTypeMap.put(tempMap.get("AttrTypeCode"), tempMap.get("Name"));
			}
		}
		
		List AllProcessList = commonService.selectList("sap_SQL.zSKDBS_getAllProcessList", setMap);
		
		for(int i=0; i<AllProcessList.size(); i++) {
			tempMap = new HashMap();
			tempMap = (HashMap)AllProcessList.get(i);
			tempMap.put("AT03", removeAllTag(StringUtil.checkNull(tempMap.get("AT03")),"DbToEx"));
			tempMap.put("AT26", getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionDefLanguageId")), StringUtil.checkNull(tempMap.get("ItemID")), "AT00026"));
			tempMap.put("AT37", getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionDefLanguageId")), StringUtil.checkNull(tempMap.get("ItemID")), "AT00037"));
			AllProcessList.set(i, tempMap);
			
		}
		JSONArray AllProcessListData = new JSONArray(AllProcessList);
		model.put("AllProcessListData", AllProcessListData);
		model.put("totalCnt", AllProcessList.size());
		model.put("attrTypeMap", attrTypeMap);

		
		model.put("menu", getLabel(request, commonService));		
		return nextUrl("/custom/spc/report/zSpc_getAllProcessList");
	}
	
	private String removeAllTag(String str,String type) { 
		if(type.equals("DbToEx")){//201610 new line :: DB To Excel
			str = str.replaceAll("\r\n", "&&rn").replaceAll("&gt;", ">").replaceAll("&lt;", "<").replaceAll("&#40;", "(").replaceAll("&#41;", ")").replace("&sect;","-").replaceAll("<br/>", "&&rn").replaceAll("<br />", "&&rn");
		}else{
			str = str.replaceAll("\n", "&&rn");//201610 new line :: Excel To DB 
		}
		str = str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#10;", " ").replace("&#xa;", "").replace("&nbsp;", " ").replace("&amp;", "&");
		if(type.equals("DbToEx")){
			str = str.replaceAll("&&rn", "\n");
		}
		//return str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#10;", " ").replace("&#xa;", "").replace("&nbsp;", " ");
		return StringEscapeUtils.unescapeHtml4(str);
	}
	private String getMLovVlaue(String languageID, String itemID, String attrTypeCode) throws Exception {
		List mLovList = new ArrayList();
		Map setMap = new HashMap();
		String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
		setMap.put("languageID", languageID);
		setMap.put("defaultLang", defaultLang);	
		setMap.put("itemID", itemID);
		setMap.put("attrTypeCode", attrTypeCode);
		mLovList = commonService.selectList("attr_SQL.getMLovList",setMap);
		String plainText = "";
		if(mLovList.size() > 0){
			for(int j=0; j<mLovList.size(); j++){
				Map mLovListMap = (HashMap)mLovList.get(j);
				if(j==0){
					plainText = StringUtil.checkNull(mLovListMap.get("Value"));
				}else {
					plainText = plainText + " / " + mLovListMap.get("Value") ;
				}
			}
		}
		return plainText;
	}
	@RequestMapping(value="/zSkdbs_downloadAllProcData.do")
	public String zSkdbs_downloadAllProcData(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		model.put("s_itemID", commandMap.get("s_itemID"));
		model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		model.put("accMode", commandMap.get("accMode"));	/*Label Setting*/
		
		Map setMap = new HashMap();
		commonService.insert("analysis_SQL.insertTwProcess", setMap);
		
		commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
		List dList = new ArrayList();
		if(commandMap.get("accMode")!= null && commandMap.get("accMode").equals("OPS")) {
			dList = commonService.selectList("custom_SQL.zSkdbs_getAllOPSProcessList_gridList",commandMap);
		}else {
			dList = commonService.selectList("custom_SQL.zSkdbs_getAllProcessList_gridList",commandMap);
		}
		
		JSONArray gridData = new JSONArray(dList);
		gridData = new JSONArray(getJSONFormatClean(gridData.toString()));
		model.put("gridData",gridData);
		
		return nextUrl("/custom/skd/skdbs/report/downloadAllProcData");
	}
	
	public static String getJSONFormatClean(String s) {
	    if (s == null) {
	        return null;
	    }
		String cleanedString = s.replaceAll("&lt;br\\s*/?&gt;", " ").replaceAll("&amp;","&").replaceAll("&#10;", "");
			    return StringEscapeUtils.unescapeHtml4(cleanedString).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>|<!--(.*?)-->", "").replaceAll("<img[^>]*>", "");
	}
}


