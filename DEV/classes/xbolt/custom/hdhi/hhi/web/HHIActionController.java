package xbolt.custom.hdhi.hhi.web;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.StringReader;
import java.math.BigDecimal;
import java.math.MathContext;
import java.math.RoundingMode;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.TreeSet;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

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

import com.org.json.JSONArray;
import com.org.json.JSONObject;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.filter.XSSRequestWrapper;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.AESUtil;
import xbolt.cmm.framework.util.DRMUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.GetItemAttrList;
import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.util.compareText;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.custom.hyundai.val.HMGGlobalVal;
import xbolt.custom.hyundai.hkfc.aprv.KR.CO.KEFICO.KASC.Service.CountInformation;
import xbolt.custom.hyundai.hkfc.aprv.KR.CO.KEFICO.KASC.Service.KIACSvcSoapProxy;

import xbolt.file.web.FileMgtActionController;
import xbolt.rpt.web.ReportActionController;

/**
 * @Class Name : HHIActionController.java
 * @Description : HDCActionController.java
 * @Modification Information
 * @수정일 수정자 수정내용 @--------- --------- ------------------------------- @2021. 09.
 *      02. smartfactory 최초생성
 *
 * @since 2021. 09. 02
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class HHIActionController extends XboltController {
	private final Log _log = LogFactory.getLog(this.getClass());

	@Resource(name = "commonService")
	private CommonService commonService;

	@RequestMapping(value = "/zHdhi_getProcToSysList.do")
	public String zHdhi_getProcToSysList(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws ExceptionUtil {
		String url = "/custom/hdhi/report/getProcToSysList";
		try {
			model.put("menu", getLabel(request, commonService));

			HashMap setMap = new HashMap();

			setMap.put("languageID", commandMap.get("sessionCurrLangType"));

			List getProcToSysList = commonService.selectList("custom_SQL.zHdhi_getProcToSysList_gridList", setMap);

			JSONArray gridData = new JSONArray(getProcToSysList);
			model.put("gridData", gridData);

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/zHdhi_getSysToProcList.do")
	public String zHdhi_getSysToProcList(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws ExceptionUtil {
		HashMap setMap = new HashMap();
		try {
			commonService.delete("custom_SQL.zhdhi_deleteSysProcTable", setMap);

			commonService.insert("custom_SQL.zhdhi_insertSysProcTable", setMap);

			setMap.put("languageID", commandMap.get("sessionCurrLangType"));

			List getProcToSysList = commonService.selectList("custom_SQL.zHdhi_getSysToProcList_gridList", setMap);

			JSONArray gridData = new JSONArray(getProcToSysList);
			model.put("gridData", gridData);
			model.put("menu", getLabel(request, commonService));

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/custom/hdhi/report/getSysToProcList");
	}

	@RequestMapping(value = "/custom/zHdhi_getEAIList.do")
	public String zHdhi_getEAIList(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws ExceptionUtil {
		String url = "/custom/hdhi/report/getEAIList";
		try {
			model.put("menu", getLabel(request, commonService));

			HashMap setMap = new HashMap();

			String systemtype = StringUtil.checkNull(request.getParameter("systemtype"));
			setMap.put("systemType", systemtype);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			String projectID = commonService.selectString("custom_SQL.zhdhi_getProjID", setMap);

			setMap.put("projectID", projectID);

			LocalDate currentDate = LocalDate.now();
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
			String formattedDate = currentDate.format(formatter);
			setMap.put("todayDate", formattedDate);

			List getEAIList = null;

			if (systemtype.equals("NCO")) {
				getEAIList = commonService.selectList("custom_SQL.zHdhi_getEAINCOList_gridList", setMap);
			} else if (systemtype.equals("EAI")) {
				getEAIList = commonService.selectList("custom_SQL.zHdhi_getEAIIFList_gridList", setMap);
			} else if (systemtype.equals("SAP")) {
				getEAIList = commonService.selectList("custom_SQL.zHdhi_getEAISAPList_gridList", setMap);
			} else if (systemtype.equals("BATCH")) {
				getEAIList = commonService.selectList("custom_SQL.zHdhi_getEAIBATCHList_gridList", setMap);
			} else if (systemtype.equals("NF")) {
				getEAIList = commonService.selectList("custom_SQL.zHdhi_getEAINFList_gridList", setMap);
			}

			JSONArray gridData = new JSONArray(getEAIList);
			model.put("systemtype", systemtype);
			model.put("gridData", gridData);

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/custom/zHdhi_getEAIUpdateList.do")
	public String zHdhi_getEAIUpdateList(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws ExceptionUtil {
		String url = "/custom/hdhi/report/getEAIUpdateList";
		try {
			model.put("menu", getLabel(request, commonService));

			HashMap setMap = new HashMap();

			String systemtype = StringUtil.checkNull(request.getParameter("systemtype"));
			setMap.put("systemType", systemtype);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			String projectID = commonService.selectString("custom_SQL.zhdhi_getProjID", setMap);

			setMap.put("projectID", projectID);

			List getEAIUpdateList = null;

			if (systemtype.equals("NCO")) {
				getEAIUpdateList = commonService.selectList("custom_SQL.zHdhi_getEAIUpdateNCOList_gridList", setMap);
			} else if (systemtype.equals("EAI")) {
				getEAIUpdateList = commonService.selectList("custom_SQL.zHdhi_getEAIUpdateIFList_gridList", setMap);
			} else if (systemtype.equals("SAP")) {
				getEAIUpdateList = commonService.selectList("custom_SQL.zHdhi_getEAIUpdateSAPList_gridList", setMap);
			} else if (systemtype.equals("BATCH")) {
				getEAIUpdateList = commonService.selectList("custom_SQL.zHdhi_getEAIUpdateBATCHList_gridList", setMap);
			} else if (systemtype.equals("NF")) {
				getEAIUpdateList = commonService.selectList("custom_SQL.zHdhi_getEAIUpdateNFList_gridList", setMap);
			}

			JSONArray gridData = new JSONArray(getEAIUpdateList);
			model.put("systemtype", systemtype);
			model.put("gridData", gridData);

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/custom/zHdhi_callEAIList2.do")
	public String zHdhi_callEAIList2(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map target = new HashMap();

		String IF_ID = StringUtil.checkNull(request.getParameter("IF_ID"));
		String systemtype = StringUtil.checkNull(request.getParameter("systemtype"));
		String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),
				commonService.selectString("getDefaultLang", target));
		;

		String uri = "http://10.100.13.15:8080/EaiIFWeb/Controller.jpf"; // 웹서비스 주소
		String strInfo = "<?xml version='1.0' encoding='UTF-8'?>"
				+ "<EaiRequestInfo xmlns='http://www.hhi.com/EaiRequestInfo.xsd'>" + "<Info>" + "<IF_ID>" + IF_ID
				+ "</IF_ID>" + "<JPD_NAME>" + IF_ID + "</JPD_NAME>" + "<TRANSTYPE>SYNC</TRANSTYPE>"
				+ "<IF_TYPE>D2D</IF_TYPE>" + "<SOURCE>C#</SOURCE>" + "<TARGET>SAP</TARGET>" + "<DIVISION>A</DIVISION>"
				+ "<EMP_NO>BPM</EMP_NO>" + "</Info>" + "</EaiRequestInfo>";
		String strData = "<?xml version='1.0' encoding='EUC-KR'?>" + "<SQL>" + "<systemtype>" + systemtype
				+ "</systemtype>" + "</SQL>";
//		String sendData = "strInfo=" + URLEncoder.encode(strInfo, "UTF-8") + "&strData="
//				+ URLEncoder.encode(strData, "UTF-8");

		String sendData = "strInfo=" + URLEncoder.encode(strInfo, "UTF-8") 
        + "&strData=" + URLEncoder.encode(new String(strData.getBytes("EUC-KR"), "UTF-8"), "UTF-8");

		try {
			// POST 방식일 때
			URL postUrl = new URL(uri);
			HttpURLConnection huc = (HttpURLConnection) postUrl.openConnection();
			huc.setRequestMethod("POST");
			huc.setDoOutput(true);
			// huc.setConnectTimeout(30000); // 30초
			huc.setRequestProperty("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");

			byte[] byteArray = sendData.getBytes("UTF-8");

			DataOutputStream sendStream = new DataOutputStream(huc.getOutputStream());
			sendStream.write(byteArray, 0, byteArray.length); // Data 전송
			sendStream.close();

			if (huc.getResponseCode() == HttpURLConnection.HTTP_OK) // 정상일 경우
			{
				BufferedReader in = new BufferedReader(new InputStreamReader(huc.getInputStream(), "UTF-8"));
				String inputLine;
				StringBuilder response = new StringBuilder();
				while ((inputLine = in.readLine()) != null) {
					response.append(inputLine);
				}
				in.close();
				huc.disconnect();

				System.out.println("호출 성공 !");
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
				target.put(AJAX_SCRIPT, "this.doCallBack();");

			} else {
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
				target.put(AJAX_SCRIPT, "this.doCallBack();");
			}
		} catch (Exception e) {
			e.printStackTrace();
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
			target.put(AJAX_SCRIPT, "this.doCallBack();");
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);

	}

	@RequestMapping(value = "/zHdhi_callEAIList.do")
	public String zHdhi_callEAIList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map target = new HashMap();

		String IF_ID = StringUtil.checkNull(request.getParameter("IF_ID"));
		String systemtype = StringUtil.checkNull(request.getParameter("systemtype"));
		String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),
				commonService.selectString("getDefaultLang", target));
		;

		String uri = "http://10.100.13.15:8080/EaiIFWeb/Controller.jpf"; // 웹서비스 주소
		String strInfo = "<?xml version='1.0' encoding='UTF-8'?>"
				+ "<EaiRequestInfo xmlns='http://www.hhi.com/EaiRequestInfo.xsd'>" + "<Info>" + "<IF_ID>" + IF_ID
				+ "</IF_ID>" + "<JPD_NAME>" + IF_ID + "</JPD_NAME>" + "<TRANSTYPE>SYNC</TRANSTYPE>"
				+ "<IF_TYPE>D2D</IF_TYPE>" + "<SOURCE>C#</SOURCE>" + "<TARGET>SAP</TARGET>" + "<DIVISION>A</DIVISION>"
				+ "<EMP_NO>BPM</EMP_NO>" + "</Info>" + "</EaiRequestInfo>";
		String strData = "<?xml version='1.0' encoding='EUC-KR'?>" + "<SQL>" + "<systemtype>" + systemtype
				+ "</systemtype>" + "</SQL>";
		String sendData = "strInfo=" + URLEncoder.encode(strInfo, "UTF-8") + "&strData="
				+ URLEncoder.encode(strData, "UTF-8");

		try {
			// POST 방식일 때
			URL postUrl = new URL(uri);
			HttpURLConnection huc = (HttpURLConnection) postUrl.openConnection();
			huc.setRequestMethod("POST");
			huc.setDoOutput(true);
			// huc.setConnectTimeout(30000); // 30초
			huc.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

			byte[] byteArray = sendData.getBytes("UTF-8");

			DataOutputStream sendStream = new DataOutputStream(huc.getOutputStream());
			sendStream.write(byteArray, 0, byteArray.length); // Data 전송
			sendStream.close();

			if (huc.getResponseCode() == HttpURLConnection.HTTP_OK) // 정상일 경우
			{
				BufferedReader in = new BufferedReader(new InputStreamReader(huc.getInputStream()));
				String inputLine;
				StringBuilder response = new StringBuilder();
				while ((inputLine = in.readLine()) != null) {
					response.append(inputLine);
				}
				in.close();
				huc.disconnect();

				int statusCnt = updateEAIList(systemtype, languageID);

				if (statusCnt >= 4) {
					target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
					target.put(AJAX_SCRIPT, "this.doCallBack();");
				} else if (statusCnt == 2 || statusCnt == 3) {
					target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
					target.put(AJAX_SCRIPT, "this.doCallBack();");
				} else if (statusCnt == 0 || statusCnt == 1) {
					target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
					target.put(AJAX_SCRIPT, "this.doCallBack();");
				} else {
					target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
					target.put(AJAX_SCRIPT, "this.doCallBack();");
				}

			} else {
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
				target.put(AJAX_SCRIPT, "this.doCallBack();");
			}
		} catch (Exception e) {
			e.printStackTrace();
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
			target.put(AJAX_SCRIPT, "this.doCallBack();");
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);

	}

	public int updateEAIList(String sysType, String languageID) throws Exception {
		Map setMap = new HashMap();

		int statusCnt = 0;

		setMap.put("systemType", sysType);
		setMap.put("languageID", languageID);

		try {
			if (sysType.equals("SAP")) {
				commonService.insert("custom_SQL.zhdhi_insertSAP", setMap);
				statusCnt += 1;
				commonService.insert("custom_SQL.zhdhi_org_tb_use", setMap);
				statusCnt += 1;
			} else if (sysType.equals("NCO")) {
				commonService.insert("custom_SQL.zhdhi_insertNCO", setMap);
				statusCnt += 1;
				commonService.insert("custom_SQL.zhdhi_org_tb_use", setMap);
				statusCnt += 1;
			} else if (sysType.equals("NF")) {
				commonService.insert("custom_SQL.zhdhi_insertNF", setMap);
				statusCnt += 1;
				commonService.insert("custom_SQL.zhdhi_org_tb_use", setMap);
				statusCnt += 1;
			} else if (sysType.equals("EAI")) {
				commonService.insert("custom_SQL.zhdhi_insertEAI", setMap);
				statusCnt += 1;
				commonService.insert("custom_SQL.zhdhi_org_tb_use", setMap);
				statusCnt += 1;
			} else if (sysType.equals("BATCH")) {
				commonService.insert("custom_SQL.zhdhi_insertBATCH", setMap);
				statusCnt += 1;
				commonService.insert("custom_SQL.zhdhi_org_tb_use", setMap);
				statusCnt += 1;
			} else {
				return statusCnt; // CNT - 0 -> EAI 호출 실패
			}

			String projectID = commonService.selectString("custom_SQL.zhdhi_getProjID", setMap);

			int ifTableCnt = 0;
			ifTableCnt = Integer.parseInt(commonService.selectString("custom_SQL.zhdhi_if_tb_cnt", setMap));

			if (ifTableCnt != 0) {
				for (int i = 0; i < 3; i++) {
					commonService.insert("custom_SQL.zhdhi_ti_proc_batch_rdy", setMap);

					ifTableCnt = Integer.parseInt(commonService.selectString("custom_SQL.zhdhi_if_tb_cnt", setMap));

					if (ifTableCnt == 0) {
						break;
					}
				}
				statusCnt += 1;

				int statCnt = 0;
				statCnt = Integer.parseInt(commonService.selectString("custom_SQL.zhdhi_if_tb_stat_cnt", setMap));

				for (int i = 0; i < 3; i++) {
					commonService.insert("custom_SQL.zhdhi_ti_proc_batch", setMap);

					statCnt = Integer.parseInt(commonService.selectString("custom_SQL.zhdhi_if_tb_stat_cnt", setMap));
					if (statCnt == 0) {
						break;
					}
				}
				statusCnt += 1;

				setMap.put("systemType", sysType);
				commonService.insert("custom_SQL.zhdhi_del_sys", setMap);
				setMap.put("systemType", sysType);
				commonService.insert("custom_SQL.zhdhi_change_del_if_tb", setMap);

				LocalDate currentDate = LocalDate.now();
				DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
				String formattedDate = currentDate.format(formatter);
				setMap.put("systemType", sysType);
				setMap.put("todayDate", formattedDate);
				commonService.insert("custom_SQL.zhdhi_insertIFLog", setMap);

				setMap.put("systemType", sysType);
				commonService.delete("custom_SQL.zhdhi_del_if_tb", setMap);

				return statusCnt; // CNT - 4 -> EAI 호출후, IF 테이블 PROC 모두 만족

			} else {
				return statusCnt; // CNT - 2 -> EAI 호출후, IF 테이블 PROC 기준 미달
			}

		} catch (Exception e) {
			e.printStackTrace();
			return statusCnt;
		}

	}

	@RequestMapping(value = "/custom/zHdhi_callEAIAndBatch.do")
	public String zHdhi_callEAIAndBatch(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map target = new HashMap();

		String IF_ID = StringUtil.checkNull(request.getParameter("IF_ID"));
		String systemtype = StringUtil.checkNull(request.getParameter("systemtype"));
		String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),
				commonService.selectString("getDefaultLang", target));
		;
		
		String url = "http://10.100.13.15:8080/EaiIFWeb/Controller.jpf"; // 웹서비스 주소
		// String url = HDHIGlobalVal.prod_IF_URL;
		
		String strInfo = "<?xml version='1.0' encoding='UTF-8'?>"
				+ "<EaiRequestInfo xmlns='http://www.hhi.com/EaiRequestInfo.xsd'>" + "<Info>" + "<IF_ID>" + IF_ID
				+ "</IF_ID>" + "<JPD_NAME>" + IF_ID + "</JPD_NAME>" + "<TRANSTYPE>SYNC</TRANSTYPE>"
				+ "<IF_TYPE>D2D</IF_TYPE>" + "<SOURCE>C#</SOURCE>" + "<TARGET>SAP</TARGET>" + "<DIVISION>A</DIVISION>"
				+ "<EMP_NO>BPM</EMP_NO>" + "</Info>" + "</EaiRequestInfo>";
		String strData = "<?xml version='1.0' encoding='EUC-KR'?>" + "<SQL>" + "<systemtype>" + systemtype
				+ "</systemtype>" + "</SQL>";
		String sendData = "strInfo=" + URLEncoder.encode(strInfo, "UTF-8") + "&strData="
				+ URLEncoder.encode(strData, "UTF-8");

		try {
			// POST 방식일 때
			URL postUrl = new URL(url);
			HttpURLConnection huc = (HttpURLConnection) postUrl.openConnection();
			huc.setRequestMethod("POST");
			huc.setDoOutput(true);
			// huc.setConnectTimeout(30000); // 30초
			huc.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

			byte[] byteArray = sendData.getBytes("UTF-8");

			DataOutputStream sendStream = new DataOutputStream(huc.getOutputStream());
			sendStream.write(byteArray, 0, byteArray.length); // Data 전송
			sendStream.close();

			if (huc.getResponseCode() == HttpURLConnection.HTTP_OK) // 정상일 경우
			{
				BufferedReader in = new BufferedReader(new InputStreamReader(huc.getInputStream()));
				String inputLine;
				StringBuilder response = new StringBuilder();
				while ((inputLine = in.readLine()) != null) {
					response.append(inputLine);
				}
				in.close();
				huc.disconnect();

				int statusCnt = updateEAIList(systemtype, languageID);

				if (statusCnt >= 4) {
					target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
					target.put(AJAX_SCRIPT, "this.doCallBack();");
				} else if (statusCnt == 2 || statusCnt == 3) {
					target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
					target.put(AJAX_SCRIPT, "this.doCallBack();");
				} else if (statusCnt == 0 || statusCnt == 1) {
					target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
					target.put(AJAX_SCRIPT, "this.doCallBack();");
				} else {
					target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
					target.put(AJAX_SCRIPT, "this.doCallBack();");
				}

			} else {
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
				target.put(AJAX_SCRIPT, "this.doCallBack();");
			}
		} catch (Exception e) {
			e.printStackTrace();
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
			target.put(AJAX_SCRIPT, "this.doCallBack();");
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);

	}

	@RequestMapping(value = "/custom/zhdhi_compareAttribute.do")
	public String zhdhi_compareAttribute(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception {
		String url = "/custom/hdhi/item/zhdhi_compareAttribute";

		compareText dmp = new compareText();
		dmp.Diff_Timeout = 0;

		String s_itemID = StringUtil.checkNull(cmmMap.get("s_itemID"));

		String itemID = StringUtil.checkNull(cmmMap.get("itemID"));
		if ("".equals(s_itemID))
			s_itemID = itemID;

		String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
		String varFilter = StringUtil.checkNull(cmmMap.get("varFilter"));
		String attrTypeList = "";
		String attrTypeList2 = "";
		String defAttrCode = StringUtil.checkNull(cmmMap.get("defAttrCode"), "");
		String changeSetID = StringUtil.checkNull(cmmMap.get("changeSet"), "");
		String preChangeSetID = StringUtil.checkNull(cmmMap.get("preChangeSet"), "");

		Map setMap = new HashMap();
		setMap.put("itemID", s_itemID);
		String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);

		if ("".equals(changeSetID)) {
			setMap.put("s_itemID", s_itemID);
			changeSetID = commonService.selectString("project_SQL.getCurChangeSetIDFromItem", setMap);
			preChangeSetID = commonService.selectString("item_SQL.getItemReleaseNo", setMap);
		}

		setMap.put("changeSetID", changeSetID);
		setMap.put("ChangeSetID", changeSetID);
		setMap.put("ItemID", s_itemID);
		String changeMgt = commonService.selectString("project_SQL.getChangeMgt", setMap);
		setMap.put("changeMgt", changeMgt);

		Map CSMap = commonService.select("cs_SQL.getChangeSetRNUM", setMap);

		if ("".equals(preChangeSetID)) {
			String preRNUM = StringUtil.checkNull(CSMap.get("PreRNUM"));
			setMap.put("rNum", preRNUM);
			preChangeSetID = StringUtil.checkNull(commonService.selectString("cs_SQL.getNextPreChangeSetID", setMap));
		}
		setMap.put("s_itemID", s_itemID);
		setMap.put("languageID", languageID);

		setMap.put("itemID", s_itemID);
		setMap.put("changeSetID", changeSetID);

		String updatedOnDate = StringUtil.checkNull(cmmMap.get("updatedOnDate"));
		LocalDate currentDate = LocalDate.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		String formattedDate = currentDate.format(formatter);

		String revDate = "";
		String attrDate = "";
		setMap.put("updatedOnDate", updatedOnDate);
		String lastUpdatedOnDate = commonService.selectString("custom_SQL.zhdhi_getPreRevDate", setMap);
		setMap.put("lastUpdatedOnDate", lastUpdatedOnDate);
		if (!updatedOnDate.equals(formattedDate)) {
			revDate = commonService.selectString("custom_SQL.zhdhi_getPreDateFromRev", setMap);
			attrDate = StringUtil.checkNull(commonService.selectString("custom_SQL.zhdhi_getPostDateFromRev", setMap));

			if (attrDate.equals("") || attrDate == "") {
				attrDate = commonService.selectString("custom_SQL.zhdhi_getDateFromAttr", setMap);
			}
		} else {
			revDate = commonService.selectString("custom_SQL.zhdhi_getPreDateFromRev", setMap);
			attrDate = commonService.selectString("custom_SQL.zhdhi_getDateFromAttr", setMap);
		}

		String identifier = commonService.selectString("item_SQL.s_itemIDentifier", setMap);
		model.put("attrDate", attrDate);
		model.put("revDate", revDate);
		model.put("identifier", identifier);

		String systemtype = StringUtil.checkNull(cmmMap.get("systemtype"));

		if (systemtype.equals("BATCH")) {
			systemtype = "PRD";
		}
		setMap.put("systemtype", systemtype);

		List itemAttrList = commonService.selectList("custom_SQL.zhdhi_getItemClassAllocAttrType", setMap);
		List diffTextList = new ArrayList();
		String curChagneSet = StringUtil.checkNull(commonService.selectString("item_SQL.getCurChangeSet", setMap));

		if (itemAttrList != null && !itemAttrList.isEmpty()) {
			for (int i = 0; i < itemAttrList.size(); i++) {
				String afterData = "", beforeData = "";
				Map diffMap = new HashMap();
				Map attrInfo = (Map) itemAttrList.get(i);
				String isHTML = StringUtil.checkNull(attrInfo.get("HTML"));
				String dataType = StringUtil.checkNull(attrInfo.get("DataType"));
				String attrCode = StringUtil.checkNull(attrInfo.get("AttrTypeCode"));
				String attrName = StringUtil.checkNull(attrInfo.get("Name"));

				/* 기본정보의 속성 내용을 취득 */
				// isComLang = ALL
				if (dataType.equals("Text") || dataType.equals("Date")) {
					// beforeData 취득
					setMap.put("s_itemID", s_itemID);
					setMap.put("languageID", languageID);
					setMap.put("AttrTypeCode", attrCode);
					setMap.put("changeSetID", preChangeSetID);

					setMap.put("preAttr", lastUpdatedOnDate);
					Map beforeDataMap = (Map) commonService.select("custom_SQL.zhdhi_getItemRevDetailInfo", setMap);
					beforeData = StringUtil.checkNull(beforeDataMap.get("PlainText"));

					// afterData 취득
					setMap.put("changeSetID", changeSetID);
					setMap.remove("IsComLang");
					setMap.put("AttrTypeCode", attrCode);

					Map afterDataMap = new HashMap();
					if (curChagneSet.equals(changeSetID)) {
						if (!updatedOnDate.equals(formattedDate)) {
							setMap.put("preAttr", "");
							afterDataMap = (Map) commonService.select("custom_SQL.zhdhi_getItemRevDetailInfo", setMap);
							afterData = StringUtil.checkNull(afterDataMap.get("PlainText"));

							if (afterDataMap.size() == 0) {
								setMap.put("attrTypeCode", attrCode);
								afterData = StringUtil
										.checkNull(commonService.selectString("item_SQL.getItemAttrPlainText", setMap));
							}

						} else {
							setMap.put("attrTypeCode", attrCode);
							afterData = StringUtil
									.checkNull(commonService.selectString("item_SQL.getItemAttrPlainText", setMap));
						}
					} else {
						afterDataMap = (Map) commonService.select("item_SQL.getItemRevDetailInfo", setMap);
						afterData = StringUtil.checkNull(afterDataMap.get("PlainText"));
					}
				} else if (dataType.equals("LOV")) {
					setMap.put("defaultLang", defaultLang);
					setMap.put("s_itemID", s_itemID);
					setMap.put("languageID", languageID);
					setMap.put("AttrTypeCode", attrCode);

					// beforeDATA 취득
					setMap.put("changeSetID", preChangeSetID);
					Map beforeDataMap = (Map) commonService.select("item_SQL.getItemRevDetailInfo", setMap);
					beforeData = StringUtil.checkNull(beforeDataMap.get("PlainText"));

					// afterDATA 취득
					Map afterDataMap = new HashMap();
					setMap.put("changeSetID", changeSetID);
					if (curChagneSet.equals(changeSetID)) {
						setMap.put("attrTypeCode", attrCode);
						String afterLovCode = StringUtil
								.checkNull(commonService.selectString("item_SQL.getItemAttrLovCode", setMap));

						if (!afterLovCode.equals("")) {
							setMap.put("AttrTypeCode", attrCode);
							setMap.put("LovCode", afterLovCode);
							setMap.put("LanguageID", languageID);
							afterData = StringUtil
									.checkNull(commonService.selectString("AttributeType_SQL.selectLov", setMap));
						}
					} else {
						afterDataMap = (Map) commonService.select("item_SQL.getItemRevDetailInfo", setMap);
						afterData = StringUtil.checkNull(afterDataMap.get("PlainText"));
					}
				}

				/*
				 * else if( dataType.equals("Date")) {
				 * 
				 * setMap.put("s_itemID", s_itemID); setMap.put("languageID", languageID); //
				 * beforeData 취득 setMap.put("changeSetID", preChangeSetID);
				 * setMap.remove("IsComLang"); setMap.put("AttrTypeCode",attrCode);
				 * 
				 * Map beforeDataMap =
				 * (Map)commonService.select("item_SQL.getItemRevDetailInfo", setMap);
				 * beforeData = StringUtil.checkNull(beforeDataMap.get("PlainText"));
				 * 
				 * // afterData 취득 setMap.put("changeSetID", changeSetID);
				 * setMap.remove("IsComLang"); setMap.put("AttrTypeCode",attrCode);
				 * 
				 * Map afterDataMap = (Map)commonService.select("item_SQL.getItemRevDetailInfo",
				 * setMap); afterData = StringUtil.checkNull(afterDataMap.get("PlainText"));
				 * 
				 * }
				 */

				if (dataType.equals("Text") || dataType.equals("LOV") || dataType.equals("Date")) {
					LinkedList<compareText.Diff> diffList = dmp.diff_main(removeAllTag(beforeData),
							removeAllTag(afterData), false);

					dmp.diff_cleanupSemantic(diffList);

					String diffTextBas = dmp.diff_prettyHtml(diffList, "BAS");
					String diffTextVer = dmp.diff_prettyHtml(diffList, "VER");

					diffMap.put("diffTextBas", diffTextBas.replaceAll("&&rn", "<br/>"));
					diffMap.put("diffTextVer", diffTextVer.replaceAll("&&rn", "<br/>"));
					diffMap.put("attrName", attrName);
					diffTextList.add(diffMap);
				}
			}
		}

		setMap.put("ChangeSetID", preChangeSetID);
		Map firChangeSetInfo = commonService.select("cs_SQL.getChangeSetData", setMap);
		model.put("firChangeSetInfo", firChangeSetInfo);

		setMap.put("ChangeSetID", changeSetID);
		Map secChangeSetInfo = commonService.select("cs_SQL.getChangeSetData", setMap);
		model.put("secChangeSetInfo", secChangeSetInfo);

		model.put("diffTextList", diffTextList);
		model.put("s_itemID", s_itemID);
		model.put("menu", getLabel(request, commonService));

		return nextUrl(url);
	}

	private String removeAllTag(String str) {

		str = str.replaceAll("&gt;", ">").replaceAll("&lt;", "<").replaceAll("&#40;", "(").replaceAll("&#41;", ")")
				.replace("&sect;", "-").replaceAll("<br/>", "&&rn").replaceAll("<br />", "&&rn")
				.replaceAll("\r\n", "&&rn");
		str = str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#10;", " ")
				.replace("&#xa;", "").replace("&nbsp;", " ").replace("&amp;", "&");
		str = str.replaceAll("<img[^>]*>", "");

		return StringEscapeUtils.unescapeHtml4(str);
	}

	@RequestMapping(value = "/custom/zhdhi_processItemInfo.do")
	public String zhdhi_processItemInfo(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws Exception {
		String url = "";
		try {
			Map setMap = new HashMap();
			String archiCode = StringUtil.checkNull(commandMap.get("option"), "");
			String currIdx = StringUtil.checkNull(commandMap.get("currIdx"), request.getParameter("itemViewPage"));
			String itemID = StringUtil.checkNull(commandMap.get("itemID"));
			String s_itemID = StringUtil.checkNull(commandMap.get("s_itemID"));
			String scrnMode = StringUtil.checkNull(commandMap.get("scrnMode"), "V");
			String accMode = StringUtil.checkNull(commandMap.get("accMode"), "");
			String showPreNextIcon = StringUtil.checkNull(commandMap.get("showPreNextIcon"),
					request.getParameter("itemViewPage"));
			String openItemIDs = StringUtil.checkNull(commandMap.get("openItemIDs"),
					request.getParameter("openItemIDs"));
			String itemViewPage = StringUtil.checkNull(request.getParameter("itemViewPage"));
			String itemEditPage = StringUtil.checkNull(request.getParameter("itemEditPage"));
			String option = StringUtil.checkNull(request.getParameter("option"));
			String screenMode = StringUtil.checkNull(commandMap.get("screenMode"));
			String getCxnFileListYN = StringUtil.checkNull(request.getParameter("getCxnFileListYN"));
			String getChildListYN = StringUtil.checkNull(request.getParameter("getChildListYN"));
			String getCxnListYN = StringUtil.checkNull(request.getParameter("getCxnListYN"));
			String hideBlocked = StringUtil.checkNull(commandMap.get("hideBlocked"), "");
			String csFilterYN = StringUtil.checkNull(commandMap.get("csFilterYN"), ""); // changeSetID 적용 필터

			model.put("screenMode", screenMode);
			setMap.put("itemID", s_itemID);
			url = StringUtil.checkNull(commonService.selectString("menu_SQL.getMenuVarFilterByClass", setMap)); // default
																												// url =
																												// Menu
																												// Varfilter
			url = url.split("=")[url.split("=").length - 1];

			String projectID = commonService.selectString("custom_SQL.zhdhi_getProjID_itemID", setMap);
			setMap.put("projectID", projectID);
			setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));

			String systemtype = commonService.selectString("project_SQL.getProjectName", setMap);

			if (scrnMode.equals("V") || scrnMode.equals("")) {
				if (!itemViewPage.equals("")) {
					url = "/" + StringUtil.checkNull(itemViewPage, url);
				}
			} else {
				accMode = "DEV";
				if (!itemEditPage.equals("")) {
					url = "/" + StringUtil.checkNull(itemEditPage, url);
				}
			}

			if (itemID.equals("") && !s_itemID.equals("")) {
				commandMap.put("itemID", s_itemID);
				setMap.put("itemID", s_itemID);
				itemID = s_itemID;
			}

			if (!itemID.equals("") || !s_itemID.equals("")) {

				List itemPath = new ArrayList();

				itemPath = getRootItemPath(itemID, StringUtil.checkNull(commandMap.get("languageID")), itemPath);
				Collections.reverse(itemPath);
				model.put("itemPath", itemPath);

				setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
				setMap.put("langCode", StringUtil.checkNull(commandMap.get("sessionCurrLangCode")).toUpperCase());
				String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
				setMap.put("s_itemID", StringUtil.checkNull(commandMap.get("itemID")));
				setMap.put("ItemID", StringUtil.checkNull(commandMap.get("itemID")));
				setMap.put("sessionCurrLangType", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));

				model.put("titleViewOption", "");

				if (!StringUtil.checkNull(commandMap.get("scrnType")).equals("")) {
					model.put("titleViewOption", StringUtil.checkNull(commandMap.get("scrnType")));
				}

				Map itemInfo = commonService.select("report_SQL.getItemInfo", setMap);
				model.put("itemInfo", itemInfo);

				String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev")); // 시스템 관리자
				String sessionUserId = StringUtil.checkNull(commandMap.get("sessionUserId"));

				if (StringUtil.checkNull(itemInfo.get("AuthorID")).equals(sessionUserId)
						|| StringUtil.checkNull(itemInfo.get("LockOwner")).equals(sessionUserId)
						|| "1".equals(sessionAuthLev)) {
					model.put("myItem", "Y");
				}

				setMap.put("memberID", sessionUserId);
				model.put("myItemCNT",
						StringUtil.checkNull(commonService.selectString("item_SQL.getMyItemCNT", setMap)));

				String blankPhotoUrlPath = GlobalVal.HTML_IMG_DIR + "/blank_photo.png";
				String photoUrlPath = GlobalVal.EMP_PHOTO_URL;
				setMap.put("blankPhotoUrlPath", blankPhotoUrlPath);
				setMap.put("photoUrlPath", photoUrlPath);
				String empPhotoItemDisPlay = GlobalVal.EMP_PHOTO_ITEM_DISPLAY;
				model.put("empPhotoItemDisPlay", empPhotoItemDisPlay);

				List roleAssignMemberList = new ArrayList();
				if (!empPhotoItemDisPlay.equals("N")) {
					roleAssignMemberList = commonService.selectList("item_SQL.getAssignmentMemberList", setMap);
				}
				model.put("roleAssignMemberList", roleAssignMemberList);

				/* 기본정보 내용 취득 */
				Map prcList = commonService.select("report_SQL.getItemInfo", setMap);

				/* (OPS 와 DEV 가 같아야할 때 )기본정보 -- 관리조직, 프로세스 책임자, 담당자 취득 */
				HashMap teamMap = new HashMap();
				teamMap.put("OwnerTeamID", StringUtil.checkNull(prcList.get("OwnerTeamID")));
				teamMap.put("OwnerTeamName", StringUtil.checkNull(prcList.get("OwnerTeamName")));
				teamMap.put("Name", StringUtil.checkNull(prcList.get("Name")));
				teamMap.put("AuthorID", StringUtil.checkNull(prcList.get("AuthorID")));
				teamMap.put("TeamName", StringUtil.checkNull(prcList.get("TeamName")));

				HashMap setTeamMap = new HashMap();
				setTeamMap.put("teamID", StringUtil.checkNull(teamMap.get("OwnerTeamID")));
				setTeamMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
				Map teamManagerInfo = commonService.select("user_SQL.getUserTeamManagerInfo", setTeamMap);
				teamMap.put("ownerTeamMngNM", teamManagerInfo.get("MemberName"));
				teamMap.put("ownerTeamMngID", teamManagerInfo.get("UserID"));
				model.put("teamMap", teamMap);

				/* 기본정보의 속성 내용을 취득 */
				List attrList = new ArrayList();
				String changeSetID = "";
				if ("OPS".equals(accMode)) {
					changeSetID = StringUtil.checkNull(prcList.get("ReleaseNo"));
					setMap.put("changeSetID", changeSetID);
					prcList = commonService.select("item_SQL.getItemAttrRevInfo", setMap);
					attrList = commonService.selectList("item_SQL.getItemRevDetailInfo", setMap);
				} else {
					changeSetID = StringUtil.checkNull(prcList.get("CurChangeSet"));
					setMap.put("showInvisible", StringUtil.checkNull(request.getParameter("showInvisible")));
					attrList = commonService.selectList("custom_SQL.zHdhi_getItemAttributesInfo", setMap);
				}

				Map attrMap = new HashMap();
				Map attrNameMap = new HashMap();
				Map attrHtmlMap = new HashMap();
				Map attrLinkMap = new HashMap();
				String mlovAttrText = "";
				for (int k = 0; attrList.size() > k; k++) {
					Map map = (Map) attrList.get(k);
					if (!map.get("DataType").equals("MLOV")) {
						attrMap.put(map.get("AttrTypeCode"), map.get("PlainText")); // 기본정보의 td
					} else {
						String mlovAttrCode = (String) map.get("AttrTypeCode");
						if (attrMap.get(mlovAttrCode) == null || attrMap.get(mlovAttrCode) == "") {
							mlovAttrText = map.get("PlainText").toString();
						} else {
							mlovAttrText += " / " + map.get("PlainText").toString();
						}
						attrMap.put(mlovAttrCode, mlovAttrText);
					}
					attrNameMap.put(map.get("AttrTypeCode"), map.get("Name")); // 기본정보의 th
					attrHtmlMap.put(map.get("AttrTypeCode"), map.get("HTML"));
					attrLinkMap.put(map.get("AttrTypeCode"), map.get("URL"));
				}

				// Team Role
				if ("DEV".equals(accMode) || "".equals(accMode)) {
					setMap.put("asgnOption", "1,2"); // 해제,해제중 미출력
				} else {
					setMap.put("asgnOption", "2,3"); // 해제,신규 미출력
				}
				List roleList = commonService.selectList("role_SQL.getItemTeamRoleList_gridList", setMap);

				// Dimension정보 취득
				List dimInfoList = commonService.selectList("dim_SQL.selectDim_gridList", setMap);
				List dimResultList = new ArrayList();
				Map dimResultMap = new HashMap();
				Map dimInfotMap = new HashMap();
				String dimTypeName = "";
				String dimValueNames = "";
				for (int i = 0; i < dimInfoList.size(); i++) {
					Map map = (HashMap) dimInfoList.get(i);
					dimInfotMap.put(map.get("DimValueID").toString(), map.get("DimValueID").toString());
					if (i > 0) {
						if (dimTypeName.equals(map.get("DimTypeName").toString())) {
							dimValueNames += " / " + map.get("DimValuePath").toString();
						} else {
							dimResultMap.put("dimValueNames", dimValueNames);
							dimResultList.add(dimResultMap);
							dimResultMap = new HashMap(); // 초기화
							dimTypeName = map.get("DimTypeName").toString();
							dimResultMap.put("dimTypeName", dimTypeName);
							dimValueNames = map.get("DimValuePath").toString();
						}
					} else {
						dimTypeName = map.get("DimTypeName").toString();
						dimResultMap.put("dimTypeName", dimTypeName);
						dimValueNames = map.get("DimValuePath").toString();
					}
				}
				if (dimInfoList.size() > 0) {
					dimResultMap.put("dimValueNames", dimValueNames);
					dimResultList.add(dimResultMap);
				}

				model.put("dimInfotMap", dimInfotMap);

				// 액티비티 리스트
				List childItemList = new ArrayList();
				if (!getChildListYN.equals("N")) {
					setMap.put("gubun", "M");
					childItemList = commonService.selectList("item_SQL.getSubItemList_gridList", setMap);
					String languageId = String.valueOf(commandMap.get("sessionCurrLangType"));
					childItemList = getChildItemInfo(childItemList, defaultLang, languageId, attrNameMap, attrHtmlMap); // 액티비티의
																														// 속성을
																														// 액티비티
																														// 리스트에
																														// 추가
				}

				// 모델 리스트
				setMap.put("viewYN", "Y");
				List modelList = commonService.selectList("model_SQL.getModelList_gridList", setMap);

				String reqNotInCxnClsList[] = StringUtil.checkNull(request.getParameter("notInCxnClsList"), "")
						.split(",");
				String notInCxnClsList = "";

				if (!StringUtil.checkNull(request.getParameter("notInCxnClsList"), "").equals("")) {
					for (int i = 0; i < reqNotInCxnClsList.length; i++) {
						if (i == 0) {
							notInCxnClsList = "'" + reqNotInCxnClsList[i] + "'";
						} else {
							notInCxnClsList += ",'" + reqNotInCxnClsList[i] + "'";
						}
					}
					setMap.put("notInCxnClsList", notInCxnClsList);
				}

				if (!getCxnListYN.equals("N")) { // &notInClsList=CNL0506,CNL0511
					// 관련항목 리스트
					List relItemList = commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);
					model.put("relItemList", relItemList); // 관련항목
				}

				commandMap.put("s_itemID", StringUtil.checkNull(commandMap.get("itemID")));
				// 변경이력
				List historyList = commonService.selectList("cs_SQL.getItemChangeList_gridList", commandMap);

				// 선/후행 프로세스 리스트
				List elementList = new ArrayList();
				Map modelMap = new HashMap();
				String modelID = "";
				if (modelList.size() > 0) {
					if ("OPS".equals(accMode)) {
						modelID = commonService.selectString("model_SQL.getModelIDFromItem", commandMap);
					} else {
						modelID = StringUtil.checkNull(((Map) modelList.get(0)).get("ModelID"));
					}
				}

				setMap.put("modelID", modelID);
				modelMap = commonService.select("model_SQL.getModelInfo", setMap);

				// mdlIF = Y 인 symbolList
//				setMap.put("mdlIF","Y");
				setMap.put("modelTypeCode", modelMap.get("ModelTypeCode"));
				/*
				 * List symbolList = commonService.selectList("model_SQL.getSymbolTypeList",
				 * setMap);
				 * 
				 * String SymTypeCodes = ""; for(int i=0; i<symbolList.size(); i++) { Map map =
				 * (Map) symbolList.get(i); if(i != 0) SymTypeCodes += ","; SymTypeCodes +=
				 * "'"+map.get("SymTypeCode")+"'"; }
				 */
				String mdlIF = StringUtil.checkNull(request.getParameter("mdlIF"));
				setMap.put("ModelID", modelID);
				setMap.put("mdlIF", mdlIF);
				elementList = commonService.selectList("report_SQL.getObjListOfModel", setMap);

				// 첨부문서
				setMap.put("itemId", commandMap.get("itemID"));
				String itemFileOption = commonService.selectString("fileMgt_SQL.getFileOption", setMap);

				// 첨부문서 취득
				commandMap.put("DocumentID", StringUtil.checkNull(commandMap.get("itemID")));
				commandMap.put("languageID", StringUtil.checkNull(commandMap.get("languageID")));
				commandMap.put("isPublic", "N");
				commandMap.put("DocCategory", "ITM");
				commandMap.put("hideBlocked", hideBlocked);

				if (!csFilterYN.equals("N")) {
					commandMap.put("changeSetID", changeSetID);
				}

				if (getCxnFileListYN.equals("Y")) {
					// 관련문서 취득
					commandMap.put("fromToItemID", s_itemID);
					List itemList = commonService.selectList("item_SQL.getCxnItemIDList", commandMap);
					Map getMap = new HashMap();
					// 첨부문서 관련문서 합치기, 관련문서 itemClassCodep 할당된 fltpCode 로 filtering
					String rltdItemId = "";
					for (int i = 0; i < itemList.size(); i++) {
						setMap = (HashMap) itemList.get(i);
						getMap.put("ItemID", setMap.get("ItemID"));
						if (i < itemList.size() - 1) {
							rltdItemId += StringUtil.checkNull(setMap.get("ItemID")) + ",";
						} else {
							rltdItemId += StringUtil.checkNull(setMap.get("ItemID"));
						}
					}
					// commandMap.remove("DocumentID");
					commandMap.put("rltdItemId", rltdItemId);
				}

				List attachFileList = commonService.selectList("fileMgt_SQL.getFile_gridList", commandMap);

				setMap.put("status", "CLS");

				setMap.put("ItemID", StringUtil.checkNull(commandMap.get("itemID")));
				String changeMgt = StringUtil.checkNull(commonService.selectString("project_SQL.getChangeMgt", setMap));
				setMap.put("s_itemID", StringUtil.checkNull(commandMap.get("itemID")));
				Map menuDisplayMap = commonService.select("item_SQL.getMenuIconDisplay", setMap);
				model.put("menuDisplayMap", menuDisplayMap);
				model.put("prcList", prcList); // 기본속성
				model.put("roleList", roleList);
				model.put("attrList", attrList);
				model.put("attrMap", attrMap);
				model.put("attrNameMap", attrNameMap);
				model.put("attrLinkMap", attrLinkMap);
				model.put("dimResultList", dimResultList); // 디멘션
				model.put("attachFileList", attachFileList); // 첨부파일
				model.put("changeMgt", changeMgt);
				model.put("modelList", modelList);
				model.put("elementList", elementList); // 선후행
				model.put("activityList", childItemList); // 액티비티
				model.put("childItemList", childItemList);
				model.put("historyList", historyList); // 변경이력
				model.put("option", option);
				model.put("itemFileOption", itemFileOption);

				setMap.put("DocCategory", "CS");

				setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
				String wfURL = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFCategoryURL", setMap));
				model.put("wfURL", wfURL); // 변경이력

				if ("OPS".equals(accMode))
					setMap.put("teamID", StringUtil.checkNull(prcList.get("AuthorTeamID")));
				else
					setMap.put("teamID", StringUtil.checkNull(prcList.get("OwnerTeamID")));

				Map managerInfo = commonService.select("user_SQL.getUserTeamManagerInfo", setMap);
				model.put("ownerTeamMngNM", managerInfo.get("MemberName")); // 프로세스 책임자
				model.put("ownerTeamMngID", managerInfo.get("UserID"));

				// Attr PlainText에 Code가 포함되는 리스트
				setMap.put("defaultLang", defaultLang);
				setMap.put("CategoryCode", "OJ");
				setMap.put("ItemTypeCode", "OJ00001");

				List attrCode = new ArrayList();
				Map temp = new HashMap();
				temp.put("attrCode", "AT00014");
				temp.put("selectOption", "AND");
				temp.put("searchValue", StringUtil.checkNull(prcList.get("Identifier")));
				attrCode.add(temp);
				setMap.put("AttrCode", attrCode);
				List attrMatchValueList = commonService.selectList("search_SQL.getSearchMultiList_gridList", setMap);
				model.put("attrMatchValueList", attrMatchValueList);
			}
			model.put("itemID", StringUtil.checkNull(commandMap.get("itemID")));

			model.put("showVersion", "1");
			model.put("revViewOption", StringUtil.checkNull(request.getParameter("mdlOption"), ""));
			model.put("scrnOption", StringUtil.checkNull(request.getParameter("scrnOption")));

			model.put("showPreNextIcon", showPreNextIcon);
			model.put("openItemIDs", openItemIDs);
			model.put("option", archiCode);
			model.put("currIdx", currIdx);
			model.put("menu", getLabel(commandMap, commonService)); /* Label Setting */
			model.put("itemPropURL", StringUtil.checkNull(request.getParameter("itemPropURL")));
			model.put("itemViewPage", itemViewPage);
			model.put("itemEditPage", itemEditPage);
			model.put("scrnMode", scrnMode);
			model.put("accMode", accMode);
			model.put("systemtype", systemtype);

			url = StringUtil.checkNull(request.getParameter("url"));
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		// url = "custom/hdhi/item/zhdhi_viewSysInfo";
		return nextUrl(url);
	}

	private List getRootItemPath(String itemID, String languageID, List itemPath) throws Exception {
		Map setMap = new HashMap();
		setMap.put("itemID", itemID);
		String ParentItemID = StringUtil.checkNull(commonService.selectString("item_SQL.getParentItemID", setMap), "0");

		if (Integer.parseInt(ParentItemID) != 0 && Integer.parseInt(ParentItemID) > 100) {
			setMap.put("ItemID", ParentItemID);
			setMap.put("languageID", languageID);
			setMap.put("attrTypeCode", "AT00001");
			Map temp = commonService.select("attr_SQL.getItemAttrText", setMap);
			temp.put("itemID", ParentItemID);
			itemPath.add(temp);
			getRootItemPath(ParentItemID, languageID, itemPath);
		}

		return itemPath;
	}

	private List getChildItemInfo(List List, String defaultLang, String sessionCurrLangType, Map attrNameMap,
			Map attrHtmlMap) throws Exception {
		List resultList = new ArrayList();
		Map setMap = new HashMap();
//		List actToCheckList = new ArrayList();
//		List actRuleSetList = new ArrayList();
//		List actRoleList = new ArrayList();
//		List actSystemList = new ArrayList();

		for (int i = 0; i < List.size(); i++) {
			Map listMap = new HashMap();
			listMap = (Map) List.get(i);
			String itemId = String.valueOf(listMap.get("ItemID"));

			setMap.put("ItemID", itemId);
			setMap.put("DefaultLang", defaultLang);
			setMap.put("sessionCurrLangType", sessionCurrLangType);
			setMap.put("delItemsYN", "N");
			List attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);

			for (int k = 0; attrList.size() > k; k++) {
				Map map = (Map) attrList.get(k);
				listMap.put(map.get("AttrTypeCode"),
						StringEscapeUtils.unescapeHtml4(StringUtil.checkNullToBlank(map.get("PlainText"))));
			}

			List conList = commonService.selectList("item_SQL.getItemConList", setMap);
			listMap.put("conList", conList);

			resultList.add(listMap);
		}

		return resultList;
	}

	@RequestMapping(value = "/zhdhi_getValidateItemList.do")
	public String getValidateItemList(HttpServletRequest request, ModelMap model) throws Exception {
		Map target = new HashMap();
		try {
			String ModelID = StringUtil.checkNull(request.getParameter("ModelID"), "");
			String ItemID = StringUtil.checkNull(request.getParameter("ItemID"), "");
			String ModelTypeCode = StringUtil.checkNull(request.getParameter("ModelTypeCode"));
			String InboundChks = StringUtil.checkNull(request.getParameter("InboundChk"), "");

			Map setMap = new HashMap();
			setMap.put("ModelID", ModelID);
			setMap.put("ItemID", ItemID);
			setMap.put("CntType", "Consistent");
			setMap.put("ModelTypeCode", ModelTypeCode);

			Map ConsistentMap = new HashMap();
			ConsistentMap = commonService.select("model_SQL.selectValidateItemListCnt", setMap);

			Map InConsistentMap = new HashMap();
			setMap.remove("CntType");
			setMap.put("CntType", "Inconsistent");
			InConsistentMap = commonService.select("model_SQL.selectValidateItemListCnt", setMap);

			Map TotalMap = new HashMap();
			setMap.remove("CntType");
			TotalMap = commonService.select("model_SQL.selectValidateItemListCnt", setMap);

			model.put("Consistent", ConsistentMap.get("CNT"));
			model.put("InConsistent", InConsistentMap.get("CNT"));
			model.put("TotalCnt", TotalMap.get("CNT"));

			// grid2
			Map ConsistentMap2 = new HashMap();
			setMap.remove("CntType");
			setMap.put("CntType", "Consistent");
			setMap.put("InboundChks", InboundChks);
			ConsistentMap2 = commonService.select("model_SQL.selectValidateItemListFromModelCnt", setMap);

			Map InConsistentMap2 = new HashMap();
			setMap.remove("CntType");
			setMap.put("CntType", "Inconsistent");
			InConsistentMap2 = commonService.select("model_SQL.selectValidateItemListFromModelCnt", setMap);

			Map TotalMap2 = new HashMap();
			setMap.remove("CntType");
			TotalMap2 = commonService.select("model_SQL.selectValidateItemListFromModelCnt", setMap);

			model.put("Consistent2", ConsistentMap2.get("CNT"));
			model.put("InConsistent2", InConsistentMap2.get("CNT"));
			model.put("TotalCnt2", TotalMap2.get("CNT"));

			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("ModelID", ModelID);
			model.put("ItemID", ItemID);
			model.put("ModelTypeCode", ModelTypeCode);
			model.put("InboundChks", InboundChks);

			// List itemList =
			// commonService.selectList("model_SQL.getValidateItemList",setMap);
		} catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl("/custom/hdhi/item/zhdhi_validateItemListPop");
	}

	@RequestMapping(value = "/zhdhi_validateItem.do")
	public String validateItem(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		try {
			Map setMap = new HashMap();
			String itemID = StringUtil.checkNull(request.getParameter("itemID"), "");
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));

			// Inbound Check Option 조회
			List inboundChks = new ArrayList();
			inboundChks = commonService.selectList("model_SQL.selectModelCategory", setMap);
			model.put("ItemID", itemID);
			model.put("inboundChks", inboundChks);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl("/custom/hdhi/item/zhdhi_validateItemPop");
	}

	@RequestMapping(value = "/zhdhi_cxnItemListPop.do")
	public String cxnItemListPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();

		try {

			/* 연관항목의 ItemTypeCode 취득 */
			/*
			 * String varFilters[] =
			 * StringUtil.checkNull(request.getParameter("varFilter")).split(","); //
			 * CN00108,Y, cxnParent = Y OR N String varFilter = ""; String addBtnYN = "N";
			 * String cxnParent = "N"; if(varFilters.length > 2){ addBtnYN =
			 * StringUtil.checkNull(varFilters[1]); cxnParent =
			 * StringUtil.checkNull(varFilters[2].split("=")[1]); varFilter =
			 * StringUtil.checkNull(varFilters[0]); } else if(varFilters.length > 1) {
			 * if(varFilters[1].indexOf("=") > -1) { cxnParent =
			 * StringUtil.checkNull(varFilters[1].split("=")[1]); } else { addBtnYN =
			 * StringUtil.checkNull(varFilters[1]); } varFilter =
			 * StringUtil.checkNull(varFilters[0]); } else if(varFilters.length>0){
			 * varFilter = StringUtil.checkNull(varFilters[0]);
			 * 
			 * }
			 */
			String cxnItemTypeCode = StringUtil.checkNull(request.getParameter("cxnItemTypeCode"));
			// String addBtnYN = StringUtil.checkNull(request.getParameter("addBtnYN"));
			String cxnParent = StringUtil.checkNull(request.getParameter("cxnParent"));

			setMap.put("varFilter", cxnItemTypeCode);
			Map fromToItemMap = commonService.select("organization_SQL.getFromToItemTypeCode", setMap);

			String fromItemTypeCode = StringUtil.checkNull(fromToItemMap.get("FromItemTypeCode"));
			String toItemTypeCode = StringUtil.checkNull(fromToItemMap.get("ToItemTypeCode"));

			/* 연관 항목의 기본정보 취득 */
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			setMap.put("itemID", s_itemID);
			String identifier = commonService.selectString("item_SQL.s_itemIDentifier", setMap);
			model.put("identifier", identifier);

			// Structure item Tree 시 //
			String mstItemID = StringUtil.checkNull(request.getParameter("mstItemID"));
			if (!mstItemID.equals("") && mstItemID != null) {
				s_itemID = mstItemID;
			}

			setMap.put("s_itemID", s_itemID);
			Map itemInfoMap = commonService.select("project_SQL.getItemInfo", setMap);

			String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev")); // 시스템 관리자
			Map itemAuthorMap = commonService.select("project_SQL.getItemAuthorIDAndLockOwner", setMap);
			if ((StringUtil.checkNull(itemAuthorMap.get("AuthorID"))
					.equals(StringUtil.checkNull(commandMap.get("sessionUserId")))
					|| StringUtil.checkNull(itemAuthorMap.get("LockOwner")).equals(
							StringUtil.checkNull(commandMap.get("sessionUserId")))
					|| "1".equals(sessionAuthLev)) && !"1".equals(StringUtil.checkNull(itemInfoMap.get("Blocked")))) {
				model.put("myItem", "Y");
			}

			/* 편집 가능여부 */
			model.put("selectedItemStatus", StringUtil.checkNull(itemInfoMap.get("Status")));
			model.put("selectedItemBlocked", StringUtil.checkNull(itemInfoMap.get("Blocked")));

			String myItemTypeCode = StringUtil.checkNull(itemInfoMap.get("ItemTypeCode"));
			String isFromItem = "";
			if (myItemTypeCode.equals(fromItemTypeCode)) {
				setMap.put("isFromItem", "Y");
				setMap.put("ItemTypeCode", toItemTypeCode);
				model.put("isFromItem", "Y");
				model.put("ItemTypeCode", toItemTypeCode);
				isFromItem = "N";
			} else {
				setMap.put("isFromItem", "N");
				setMap.put("ItemTypeCode", fromItemTypeCode);
				model.put("isFromItem", "N");
				model.put("ItemTypeCode", fromItemTypeCode);
				isFromItem = "Y";
			}

			setMap.put("varFilter", cxnItemTypeCode);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			setMap.put("cxnParent", cxnParent);
			List relatedItemList = commonService.selectList("item_SQL.getCXNItems", setMap);

			/* 연관 항목의 속성 내용을 취득 & 편집 권한 취득 */
			if (!cxnParent.equals("Y")) {
				for (int i = 0; relatedItemList.size() > i; i++) {
					Map relatedItemMap = (Map) relatedItemList.get(i);
					setMap.put("ItemID", relatedItemMap.get("CnItemID"));
					setMap.put("DefaultLang", commonService.selectString("item_SQL.getDefaultLang", setMap));
					setMap.put("sessionCurrLangType", commandMap.get("sessionCurrLangType"));

					setMap.put("s_itemID", relatedItemMap.get("CnItemID"));
					setMap.put("languageID", commandMap.get("sessionCurrLangType"));
					setMap.put("defaultLang", commonService.selectString("item_SQL.getDefaultLang", setMap));
					setMap.put("option", request.getParameter("option"));

					List relatedAttrList = (List) commonService.selectList("attr_SQL.getItemAttr", setMap);
					if (relatedAttrList.size() > 0) {
						for (int k2 = 0; relatedAttrList.size() > k2; k2++) {
							Map attrData = (Map) relatedAttrList.get(k2);
							String attrTypeCode = StringUtil.checkNull(attrData.get("AttrTypeCode"));
							String dataType = StringUtil.checkNull(attrData.get("DataType"));
							if (dataType.equals("MLOV")) {
								String plainText = getMLovVlaue(
										StringUtil.checkNull(commandMap.get("sessionCurrLangType")),
										StringUtil.checkNull(relatedItemMap.get("CnItemID")), attrTypeCode);
								attrData.put("PlainText", plainText);
							}
						}
					}
					String plainText = "";
					String beforAttrTypeCode = "";
					String currAttrTypeCode = "";
					for (int k = 0; relatedAttrList.size() > k; k++) {
						Map map = (Map) relatedAttrList.get(k);
						if (k > 0) {
							beforAttrTypeCode = StringUtil.checkNull(map.get(k - 1));
						}
						currAttrTypeCode = StringUtil.checkNull(map.get(k));
					}

					beforAttrTypeCode = "";
					currAttrTypeCode = "";
					List connectionAttrList = new ArrayList();
					List newConnectionAttrList = new ArrayList();
					if (isFromItem.equals("Y")) {
						setMap.put("ItemID", relatedItemMap.get("RelItemID"));
						connectionAttrList = (List) commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
						newConnectionAttrList = (List) commonService.selectList("attr_SQL.getItemAttributesInfo",
								setMap);
					} else {
						setMap.put("itemID", relatedItemMap.get("PrcItemID"));
						// String projectID =
						// StringUtil.checkNull(commonService.selectString("custom_SQL.zhdhi_getProjID_itemID",
						// setMap), "");
						// setMap.put("projectID", projectID);
						// String systemtype =
						// StringUtil.checkNull(commonService.selectString("project_SQL.getProjectName",
						// setMap), "");
						// setMap.put("systemtype", systemtype);
						setMap.put("ItemID", relatedItemMap.get("PrcItemID"));
						setMap.put("atgGRCodeList", "'ATG0001','ATG0002'");
						connectionAttrList = (List) commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
						newConnectionAttrList = (List) commonService.selectList("attr_SQL.getItemAttributesInfo",
								setMap);
					}
					int jj = -1;
					int j2 = 1;
					List indexList = new ArrayList();
					// System.out.println("connectionAttrList.size() :"+connectionAttrList.size());
					for (int j = 0; connectionAttrList.size() > j; j++) {
						Map cnnMap = (Map) connectionAttrList.get(j);
						beforAttrTypeCode = "";
						currAttrTypeCode = "";
						if (j != 0) {
							Map beforeCnnMap = (Map) connectionAttrList.get(jj);
							beforAttrTypeCode = StringUtil.checkNull(beforeCnnMap.get("AttrTypeCode"));
						}

						currAttrTypeCode = StringUtil.checkNull(cnnMap.get("AttrTypeCode"));
						if (beforAttrTypeCode.equals(currAttrTypeCode)) {
							newConnectionAttrList.remove(j - j2);
							j2++;
						}
						jj++;

					}
					for (int m = 0; newConnectionAttrList.size() > m; m++) {
						Map cnnMap = (Map) newConnectionAttrList.get(m);
						if (cnnMap.get("DataType").equals("MLOV")) {
							plainText = getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionCurrLangType")),
									StringUtil.checkNull(cnnMap.get("ItemID")),
									StringUtil.checkNull(cnnMap.get("AttrTypeCode")));
							cnnMap.put("PlainText", plainText);
						}
					}

					// 연관 항목 기본정보 리스트에 취득한 속성 리스트를 저장
					relatedItemMap.put("relatedAttrList", relatedAttrList);
					relatedItemMap.put("connectionAttrList", newConnectionAttrList);
				}
			}

			setMap.remove("s_itemID");
			List returnData = commonService.selectList("item_SQL.getClassOption", setMap);
			model.put("classOption", returnData);

			// ConnectionItemActionController - cxnItemTreeMgt.do
			List cxnItemList = new ArrayList();
			// cxnItemList.add(relatedItemList);

			for (int i2 = 0; i2 < relatedItemList.size(); i2++) {
				Map relatedItemMap = (Map) relatedItemList.get(i2);

				Map setMap2 = new HashMap();
				String linkImg = "blank.png";

				setMap2.put("itemID", StringUtil.checkNull(relatedItemMap.get("PrcItemID")));

				String classCode = commonService.selectString("item_SQL.getClassCode", setMap2);

				if (classCode.equals("CL04005") || classCode.equals("CL04006")) {
					setMap2.put("languageID", commandMap.get("sessionCurrLangType"));
					setMap2.put("itemClassCode", classCode);
					List linkList = commonService.selectList("link_SQL.getLinkListFromAttAlloc", setMap2);
					String linkUrl = "";
					String lovCode = "";
					String attrTypeCode = "";

					if (linkList.size() > 0) {
						Map linkInfo = (Map) linkList.get(0);
						linkUrl = StringUtil.checkNull(linkInfo.get("URL"), "");
						lovCode = StringUtil.checkNull(linkInfo.get("LovCode"), "");
						attrTypeCode = StringUtil.checkNull(linkInfo.get("AttrTypeCode"), "");
						if (!linkUrl.equals("")) {
							linkImg = "icon_link.png";
						}
						relatedItemMap.put("linkImg", linkImg);
						relatedItemMap.put("linkUrl", linkUrl);
						relatedItemMap.put("lovCode", lovCode);
						relatedItemMap.put("attrTypeCode", attrTypeCode);
					} else {
						relatedItemMap.put("linkImg", linkImg);
					}

					cxnItemList.add(relatedItemMap);
				}
			}

//			List<HashMap<Object, Object>> cxnItemListDis = distinctArray(cxnItemList, "id");  //GridList distinct 할것
//
//			for (HashMap<Object, Object> hashMap : cxnItemListDis) {
//				System.out.println(hashMap);
//			}

			model.put("s_itemID", s_itemID);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("varFilter", cxnItemTypeCode);
			model.put("relatedItemList", relatedItemList);
			model.put("cxnItemList", cxnItemList);
			model.put("cnt", relatedItemList.size());
			model.put("screenMode", StringUtil.checkNull(request.getParameter("screenMode"), ""));
			model.put("attrDisplay", StringUtil.checkNull(request.getParameter("attrDisplay"), ""));
			model.put("myItemTypeCode", myItemTypeCode);
			model.put("option", request.getParameter("option"));
			// model.put("addBtnYN", addBtnYN);
			model.put("cxnParent", cxnParent);

		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/itm/connection/cxnItemListPop");
	}

	private String getMLovVlaue(String languageID, String itemID, String attrTypeCode) throws ExceptionUtil {
		List mLovList = new ArrayList();
		Map setMap = new HashMap();
		String plainText = "";
		try {
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
			setMap.put("languageID", languageID);
			setMap.put("defaultLang", defaultLang);
			setMap.put("itemID", itemID);
			setMap.put("attrTypeCode", attrTypeCode);
			mLovList = commonService.selectList("attr_SQL.getMLovList", setMap);
			if (mLovList.size() > 0) {
				for (int j = 0; j < mLovList.size(); j++) {
					Map mLovListMap = (HashMap) mLovList.get(j);
					if (j == 0) {
						plainText = StringUtil.checkNull(mLovListMap.get("Value"));
					} else {
						plainText = plainText + " / " + mLovListMap.get("Value");
					}
				}
			}
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}
		return plainText;
	}

	@RequestMapping(value = "/zhdhi_updateTcodeL5.do")
	public String updateTcodeL5(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		Map target = new HashMap();

		String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
		setMap.put("itemID", s_itemID);

		List tcodeList = new ArrayList();
		String tcode = "";
		try {
			tcodeList = commonService.selectList("custom_SQL.zhdhi_getCnlIdentifier", setMap);

			if (tcodeList.size() > 0) {
				for (int j = 0; j < tcodeList.size(); j++) {
					Map tcodeListMap = (HashMap) tcodeList.get(j);
					if (j == 0) {
						tcode = StringUtil.checkNull(tcodeListMap.get("ID"));
					} else {
						tcode = tcode + "," + StringUtil.checkNull(tcodeListMap.get("ID"));
					}
				}
			}

			setMap.put("tcode", tcode);
			setMap.put("itemID", s_itemID);
			setMap.put("AttrTypeCode", "AT00014");
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));

			int cntTcode = Integer
					.parseInt(StringUtil.checkNull(commonService.selectString("custom_SQL.zhdhi_count_tcode", setMap)));

			if (cntTcode != 0) {
				commonService.insert("custom_SQL.zhdhi_update_tcode_L5", setMap);
			} else {
				setMap.put("s_itemID", s_itemID);
				setMap.put("itemID", s_itemID);
				setMap.put("ItemID", s_itemID);
				setMap.put("PlainText", tcode);
				setMap.put("ItemTypeCode",
						StringUtil.checkNull(commonService.selectString("item_SQL.selectedItemTypeCode", setMap)));
				commonService.insert("item_SQL.ItemAttr", setMap);
			}

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
			target.put(AJAX_SCRIPT, "this.doCallBack();");

		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);

	}

	@RequestMapping(value = "/zHdhiMain.do")
	public String zHdhiMain(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception {
		String url = StringUtil.checkNull(cmmMap.get("url"), "/custom/hdhi/main/zHdhiMain");
		try {
			Map setMap = new HashMap();
			List viewItemTypeList = new ArrayList();

			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String userId = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			String mLvl = StringUtil.checkNull(cmmMap.get("sessionMlvl"));

			setMap.put("ChangeMgt", "1");
			setMap.put("languageID", languageID);
			List itemTypeCodeList = commonService.selectList("item_SQL.getItemTypeCodeList", setMap);

			if (itemTypeCodeList != null && !itemTypeCodeList.isEmpty()) {
				Map typeTemp = new HashMap();
				Map cntTemp = new HashMap();

				for (int i = 0; i < itemTypeCodeList.size(); i++) {
					typeTemp = (Map) itemTypeCodeList.get(i);
					cntTemp = new HashMap();
					setMap.put("itemTypeCode", StringUtil.checkNull(typeTemp.get("CODE")));

					String itemCnt = StringUtil
							.checkNull(commonService.selectString("custom_SQL.zHdhi_getItemCntByItemType", setMap));

					cntTemp.put("itemCnt", itemCnt);
					cntTemp.put("itemCode", StringUtil.checkNull(typeTemp.get("CODE")));
					cntTemp.put("itemName", StringUtil.checkNull(typeTemp.get("NAME")));
					cntTemp.put("itemIcon", StringUtil.checkNull(typeTemp.get("ICON")));
					cntTemp.put("itemArcCode", StringUtil.checkNull(typeTemp.get("ArcCode")));
					cntTemp.put("itemArcStyle", StringUtil.checkNull(typeTemp.get("ArcStyle")));
					cntTemp.put("itemArcIcon", StringUtil.checkNull(typeTemp.get("ArcIcon")));
					cntTemp.put("itemURL", StringUtil.checkNull(typeTemp.get("URL")));
					cntTemp.put("itemMenuVar", StringUtil.checkNull(typeTemp.get("MenuVar")));
					cntTemp.put("itemArcVar", StringUtil.checkNull(typeTemp.get("ArcVar")));
					cntTemp.put("itemDefColor", StringUtil.checkNull(typeTemp.get("DefColor")));

					viewItemTypeList.add(i, cntTemp);
				}
			}

			setMap.put("sessionCurrLangType", languageID);
			setMap.put("authorID", userId);

			// my cs List
			setMap.put("top", "10");
			setMap.put("changeMgtYN", "Y");
			setMap.put("statusList", "'NEW1','NEW2','MOD1','MOD2'");
			setMap.remove("itemTypeCode");
			List myItemList = commonService.selectList("item_SQL.getOwnerItemList_gridList", setMap);
			model.put("myItemList", myItemList);

			setMap.put("actorID", userId);
			setMap.put("filter", "myWF");
			setMap.put("wfMode", "CurAprv");
			List wfCurAprvList = commonService.selectList("wf_SQL.getWFInstList_gridList", setMap);
			if (wfCurAprvList != null && !wfCurAprvList.isEmpty()) {
				model.put("wfCurAprvCnt", wfCurAprvList.size());
			} else {
				model.put("wfCurAprvCnt", "0");
			}

			// my Review Board List

			setMap.put("myID", userId);
			setMap.put("myBoard", "Y");

			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
			long date = System.currentTimeMillis();
			setMap.put("scEndDtFrom", formatter.format(date));
			setMap.put("BoardMgtID", "BRD0001");

			List myRewBrdList = commonService.selectList("forum_SQL.forumGridList_gridList", setMap);
			model.put("myRewBrdList", myRewBrdList);

			model.put("srType", request.getParameter("srType"));
			model.put("viewItemTypeList", viewItemTypeList);
			model.put("languageID", languageID);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		model.put("menu", getLabel(request, commonService)); // Label Setting
		model.put("screenType", request.getParameter("screenType"));
		return nextUrl(url);
	}

	@RequestMapping(value = "/zhdhi_mainSysToProcChart.do")
	public String mainSysToProcChart(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception {
		String url = "/custom/hdhi/main/zhdhi_mainSysToProcChart";
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

			String system = StringUtil.checkNull(request.getParameter("system"),"SAP");
			cmmMap.put("system", system);
			model.put("system", system);
			
			List<Map<String, Object>> sysToProcList = (List<Map<String, Object>>) commonService.selectList("custom_SQL.zHdhi_getSysToProcChart_gridList", cmmMap);
			
	        int max = 0;
	        for (Map<String, Object> row : sysToProcList) {
	            int mapApplied = Integer.parseInt(row.get("맵 반영").toString());
	            int mapNotApplied = Integer.parseInt(row.get("맵 미반영").toString());

	            max = Math.max(max, Math.max(mapApplied, mapNotApplied));
	        }			
			
			JSONArray sysToProcData = new JSONArray(sysToProcList);
			model.put("sys_max", max);
			model.put("sysToProcData", sysToProcData);

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		model.put("screenType", request.getParameter("screenType"));
		return nextUrl(url);
	}

	@RequestMapping(value = "/zhdhi_mainActivityChart.do")
	public String mainActivityChart(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception {
		String url = "/custom/hdhi/main/zhdhi_mainActivityChart";
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

			List activityList = commonService.selectList("custom_SQL.zHdhi_getActivityChart_gridList", cmmMap);
			JSONArray activityData = new JSONArray(activityList);
			model.put("activityData", activityData);

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		model.put("screenType", request.getParameter("screenType"));
		return nextUrl(url);
	}

	@RequestMapping(value = "/zhdhi_mainL4ProcessChart.do")
	public String mainL4ProcessChart(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception {
		String url = "/custom/hdhi/main/zhdhi_mainL4ProcessChart";
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			
//			String businessType = StringUtil.checkNull(request.getParameter("businessType"),"C");
//			cmmMap.put("businessType", businessType);
//			model.put("businessType", businessType);
			
			List<Map<String, Object>> l4ProcessList = (List<Map<String, Object>>) commonService.selectList("custom_SQL.zHdhi_getProcessChart_gridList", cmmMap);
			
			int max = 0;
			int value = 0;
	        for (Map<String, Object> map : l4ProcessList) {
	            value = (int) map.get("value"); // value 값을 가져옴
	            if (value > max) { // 현재 최대값보다 크면 업데이트
	            	max = value;
	            }
	        }
			
			JSONArray l4ProcessData = new JSONArray(l4ProcessList);
			model.put("l4_max", max);
			model.put("l4ProcessData", l4ProcessData);

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		model.put("screenType", request.getParameter("screenType"));
		return nextUrl(url);
	}

	@RequestMapping(value = "/custom/zhdhi_callHRProc.do")
	public String zhdhi_callHRProc(HttpServletRequest request, HashMap commandMap, ModelMap model) {
		HashMap setMap = new HashMap();
		Map target = new HashMap();

		String procedureName = "XBOLTADM.HR_IF_HDHI";
		setMap.put("procedureName", procedureName);
		try {
			commonService.insert("organization_SQL.insertHRTeamInfo", setMap);

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
			target.put(AJAX_SCRIPT, "this.doCallBack();");
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/zhdhi_batchAttrPop.do")
	public String zhdhi_batchAttrPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

			setMap.put("itemID", StringUtil.checkNull(request.getParameter("itemID")));
			setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));

			// get [Attribute - ATPRD97 ~ 99]
			List batchAttrList = commonService.selectList("custom_SQL.zHdhi_getBatchAttrList", setMap);

			Map attrMap = new HashMap();
			Map attrNameMap = new HashMap();
			for (int k = 0; batchAttrList.size() > k; k++) {
				Map map = (Map) batchAttrList.get(k);

				attrMap.put(map.get("AttrTypeCode"), map.get("PlainText"));
				attrNameMap.put(map.get("AttrTypeCode"), map.get("Name"));
			}

			model.put("itemID", StringUtil.checkNull(request.getParameter("itemID")));
			model.put("attrMap", attrMap);
			model.put("attrNameMap", attrNameMap);
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/custom/hdhi/item/zhdhi_batchAttr");
	}

	@RequestMapping(value = "/zhdhi_batchAttrSave.do")
	public String zhdhi_batchAttrSave(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();

		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

			setMap.put("itemID", StringUtil.checkNull(request.getParameter("itemID")));
			setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));

			// get [Attribute - ATPRD97 ~ 99]
			List batchAttrList = commonService.selectList("custom_SQL.zHdhi_getBatchAttrList", setMap);

			Map attrMap = new HashMap();
			Map attrNameMap = new HashMap();
			for (int k = 0; batchAttrList.size() > k; k++) {
				Map map = (Map) batchAttrList.get(k);

				attrMap.put(map.get("AttrTypeCode"), map.get("PlainText"));
				attrNameMap.put(map.get("AttrTypeCode"), map.get("Name"));
			}

			model.put("attrMap", attrMap);
			model.put("attrNameMap", attrNameMap);

		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/custom/hdhi/item/zhdhi_batchAttr");
	}

	@RequestMapping(value = "/custom/zhdhi_batchReportRdy.do")
	public String zhdhi_batchReportRdy(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws Exception {
		try {
			String s_itemID = StringUtil.checkNull(request.getParameter("itemID"), "");
			String arcCode = StringUtil.checkNull(request.getParameter("ArcCode"), "");
			String url = StringUtil.checkNull(request.getParameter("url"), "");
			String objType = StringUtil.checkNull(request.getParameter("objType"), "OJ00004");
			String classCode = StringUtil.checkNull(request.getParameter("classCode"), "CL04005");
			String rnrOption = StringUtil.checkNull(request.getParameter("rnrOption"), ""); // 1 : 하위항목, 2 : 엘리먼트 리스트
			String elmClassList = StringUtil.checkNull(request.getParameter("elmClassList"), "");
			String accMode = StringUtil.checkNull(request.getParameter("accMode"), "");
			String activityMode = StringUtil.checkNull(request.getParameter("activityMode"), "");

			commandMap.put("ItemTypeCode", objType);
			Map modelExist = commonService.select("common_SQL.getMDLTypeCode_commonSelect", commandMap);

			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("s_itemID", s_itemID);
			model.put("arcCode", arcCode);
			model.put("url", url);
			model.put("objType", objType);
			model.put("classCode", classCode);
			model.put("rnrOption", rnrOption);
			model.put("elmClassList", elmClassList);
			model.put("modelExist", modelExist.size());
			model.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType"), ""));
			model.put("accMode", accMode);
			model.put("activityMode", activityMode);

		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/custom/hdhi/report/batchReportRdy");
	}
	
	@RequestMapping(value = "/zhdhi_saveBatchAttribute.do")
	public String zhdhi_saveBatchAttribute(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map setMap = new HashMap();

			String user = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String itemID = StringUtil.checkNull(request.getParameter("itemID"));
					
			setMap.put("Creator", user);
			setMap.put("languageID", languageID);
			setMap.put("itemID", itemID);
			setMap.put("ItemID", itemID);
			  
			Map<String, String> prdListMap = new HashMap();
	        prdListMap.put("ATPRD97", request.getParameter("ATPRD97"));
	        prdListMap.put("ATPRD98", request.getParameter("ATPRD98"));
	        prdListMap.put("ATPRD99", request.getParameter("ATPRD99"));
			
	        String chkBatchAttr = "";
	        
			for (String key : prdListMap.keySet()) {
				setMap.put("attrTypeCode", key);
				chkBatchAttr = StringUtil.checkNull(commonService.selectString("item_SQL.getItemAttrPlainText",setMap),"<>?");
				if (!chkBatchAttr.equals("<>?")) {
					setMap.put("AttrTypeCode", key);
					setMap.put("PlainText", prdListMap.get(key));
					commonService.update("item_SQL.updateItemAttr",setMap);	
				} else {
					setMap.put("PlainText", prdListMap.get(key));
					setMap.put("languageID", commandMap.get("sessionCurrLangType"));
					setMap.put("ItemID", itemID);
					setMap.put("AttrTypeCode", key);
					setMap.put("LovCode", "");
					setMap.put("ItemTypeCode", "OJ00004");
					commonService.insert("item_SQL.ItemAttr",setMap);	
				}
					
				setMap.remove("attrTypeCode");
				setMap.remove("AttrTypeCode");
				setMap.remove("PlainText");
				setMap.remove("languageID");
				setMap.remove("ItemID");
				setMap.remove("LovCode");
				setMap.remove("ItemTypeCode");
			}
	        
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.selfClose();parent.$('#isSubmit').remove();");
		
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}	

	@RequestMapping(value="/custom/zhdhi_itemDocReport.do")
	public String zhdhi_itemDocReport(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception{
		Map target = new HashMap();
		// client별 word report url 설정
		String url= "/custom/base/report/processReport";
		if(!StringUtil.checkNull(commandMap.get("exportUrl")).equals("")){ url = "/"+ StringUtil.checkNull(commandMap.get("exportUrl")); }
		try{
			Map setMap = new HashMap();
			String languageId = String.valueOf(commandMap.get("sessionCurrLangType"));
			String itemID = request.getParameter("s_itemID");
			String delItemsYN = StringUtil.checkNull(commandMap.get("delItemsYN"));
			String accMode = StringUtil.checkNull(request.getParameter("accMode"),""); 
			String activityMode = StringUtil.checkNull(request.getParameter("activityMode"),""); //하위항목 모드 : 기본 - 아이템의 하위항목 / element = 모델에 존재하는 L4,L5 항목
			
			setMap.put("languageID", languageId);
			setMap.put("langCode", StringUtil.checkNull(commandMap.get("sessionCurrLangCode")).toUpperCase());
			setMap.put("s_itemID", itemID);
			setMap.put("itemID", itemID);
			setMap.put("ArcCode", request.getParameter("ArcCode"));
			setMap.put("rnrOption", request.getParameter("rnrOption"));
			setMap.put("delItemsYN", delItemsYN);
			setMap.put("accMode", accMode);
			setMap.put("activityMode", activityMode);
			
			setMap.put("csYN", request.getParameter("csYN"));
			setMap.put("occYN", request.getParameter("occYN"));
			setMap.put("cxnYN", request.getParameter("cxnYN"));
			setMap.put("fileYN", request.getParameter("fileYN"));
			setMap.put("teamYN", request.getParameter("teamYN"));
			setMap.put("rnrYN", request.getParameter("rnrYN"));
			setMap.put("elmClassList", request.getParameter("elmClassList"));
			setMap.put("subItemYN", request.getParameter("subItemYN"));
			
			// 파일명에 이용할 Item Name 을 취득
			if("OPS".equals(accMode)) {
				setMap.put("attrRevYN", "Y");
			}
			Map selectedItemMap = commonService.select("report_SQL.getItemInfo", setMap);
			setMap.put("ReleaseNo",selectedItemMap.get("ReleaseNo"));
			
			// 로그인 언어별 default font 취득
			String defaultFont = commonService.selectString("report_SQL.getDefaultFont", setMap);			
			
			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", commandMap);			
			List modelList = new ArrayList();
			List totalList = new ArrayList();
			
			List allTotalList = new ArrayList();
			Map allTotalMap = new HashMap();
			Map titleItemMap = new HashMap();
			
			String reportCode = StringUtil.checkNull(commandMap.get("reportCode"));
			String classCode = commonService.selectString("report_SQL.getItemClassCode", setMap);
			String objType = StringUtil.checkNull(commandMap.get("objType"));
			setMap.put("classCode", classCode);
			setMap.put("ItemTypeCode", objType);
			
			setMap.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
			setMap.put("selectLanguageID", StringUtil.checkNull(commandMap.get("selectLanguageID")));
			
			setMap.put("l5_itemID", StringUtil.checkNull(commonService.selectString("custom_SQL.zhdhi_getCnlIdentifier_L5", setMap)));
			setMap.put("l5_ClassCode", "CL01005");
			setMap.put("s_itemID", itemID);
			setMap.put("ClassCode", classCode);
			modelList = commonService.selectList("report_SQL.getItemStrList_gridList", setMap);
			
			/** 선택된 Item의 SubProcess Item취득(L2) */
			setMap.put("CURRENT_ITEM", request.getParameter("s_itemID")); // 해당 아이템이 [FromItemID]인것
			setMap.put("CategoryCode", "ST1");
			setMap.put("languageID", languageId);
			setMap.put("toItemClassCode", "CL01004");   
			
			// 해당 아이템의 하위 항목의 서브프로세스 수 만큼 word report 작성
		    getItemTotalInfo(totalList, modelList, setMap, request, commandMap, defaultLang, languageId, accMode);
			titleItemMap = selectedItemMap;
			allTotalMap.put("titleItemMap", titleItemMap);
			allTotalMap.put("totalList", totalList);
			allTotalList.add(allTotalMap);
			
			model.put("allTotalList", allTotalList);

			model.put("onlyMap", request.getParameter("onlyMap"));
			model.put("paperSize", request.getParameter("paperSize"));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			model.put("setMap", setMap);
			model.put("defaultFont", defaultFont);
			String itemNameofFileNm = StringUtil.checkNull(selectedItemMap.get("ItemName")).replace("&#xa;", "");
			model.put("ItemNameOfFileNm", URLEncoder.encode(itemNameofFileNm, "UTF-8").replace("+", "%20"));
			model.put("selectedItemIdentifier", StringUtil.checkNull(selectedItemMap.get("Identifier")));
			model.put("outputType", request.getParameter("outputType"));  
			model.put("selectedItemMap", selectedItemMap);
			
			setMap.put("teamID", StringUtil.checkNull(selectedItemMap.get("OwnerTeamID")));
			Map managerInfo = commonService.select("user_SQL.getUserTeamManagerInfo", setMap);
			model.put("ownerTeamMngNM",managerInfo.get("MemberName"));	// 프로세스 책임자
			
			model.put("csYN", request.getParameter("csYN"));
			model.put("occYN", request.getParameter("occYN"));
			model.put("cxnYN", request.getParameter("cxnYN"));
			model.put("fileYN", request.getParameter("fileYN"));
			model.put("teamYN", request.getParameter("teamYN"));
			model.put("rnrYN", request.getParameter("rnrYN"));
			model.put("subItemYN", request.getParameter("subItemYN"));
			model.put("reportCode", StringUtil.checkNull(request.getParameter("reportCode"), ""));
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00105")); // DB에 생성된 모델이 없습니다.
			target.put(AJAX_SCRIPT, "parent.goBack();parent.$('#isSubmit').remove();");
			System.out.println("totalList == "+totalList);
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(url);	
	}
	
	public void getItemTotalInfo(List totalList, List modelList, Map setMap, HttpServletRequest request, HashMap commandMap, String defaultLang, String languageId, String accMode) throws Exception {
		String beforFromItemID = "";
		for (int index = 0; modelList.size() > index; index++) {
			Map map = new HashMap();
			Map totalMap = new HashMap();
			Map subProcessMap = (Map) modelList.get(index);
			Map activityMap = new HashMap();
			
			List cngtList = new ArrayList(); // 변경이력 리스트
			List detailElementList = new ArrayList(); // 연관 프로세스 리스트
			List elmObjList = new ArrayList();		// OJ, MOJ 엘리먼트 리스트
			List elementList = new ArrayList(); // element List
			
			String l5_itemID = StringUtil.checkNull(setMap.get("l5_itemID"));
			String l5_ClassCode = StringUtil.checkNull(setMap.get("l5_ClassCode"));
			String s_itemID = StringUtil.checkNull(setMap.get("itemID"));
			String classCode = StringUtil.checkNull(setMap.get("ClassCode"));
			String activityMode = StringUtil.checkNull(setMap.get("activityMode"));
			
			setMap.put("s_itemID", l5_itemID);
			setMap.put("itemId", l5_itemID);
			setMap.put("ClassCode", l5_ClassCode);
			setMap.put("classCode", l5_ClassCode);
			setMap.put("sessionCurrLangType", String.valueOf(commandMap.get("sessionCurrLangType")));
			setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
			setMap.put("attrTypeCode", commandMap.get("attrTypeCode"));
			
			// Model 정보 취득 
			setMap.remove("ModelTypeCode");
			Map modelMap = new HashMap();
			String modelID = "";
			if (!"0".equals(StringUtil.checkNull(commandMap.get("modelExist")))) {
				setMap.put("MTCategory", request.getParameter("MTCategory"));
				modelMap = commonService.select("report_SQL.getModelIdAndSize", setMap);
				
				// 모델이 DB에 존재 하는 경우, 문서에 표시할 모델 맵 크기를 계산 한다
				// 모델이 DB에 존재 하는 경우, [TB_ELEMENT]에서 선행 /후행 데이터 취득
				if (null != modelMap) {
					setModelMap(modelMap, request);
					Map setMap2 = new HashMap();
					setMap2.put("languageID", languageId);
					if ("N".equals(StringUtil.checkNull(commandMap.get("onlyMap"))) && "on".equals(StringUtil.checkNull(setMap.get("occYN")))) {
						// [TB_ELEMENT]에서 선행 /후행 데이터 취득 
						detailElementList = getElementList(setMap2, modelMap);
					}
				}
			}
			
			setMap.put("s_itemID", s_itemID);
			setMap.put("itemId", s_itemID);
			setMap.put("ClassCode", classCode);
			setMap.put("classCode", classCode);
			
			List attrList = new ArrayList();
			String changeSetID = StringUtil.checkNull(modelMap.get("changeSetID"));
			
			/* 기본정보 취득 */
			List prcList = commonService.selectList("report_SQL.getItemInfo", setMap);
			setMap.put("changeSetID",changeSetID);
			
			if(accMode.equals("OPS")) {
				changeSetID = StringUtil.checkNull(setMap.get("ReleaseNo"));
				setMap.put("changeSetID", changeSetID);
				prcList = commonService.selectList("item_SQL.getItemAttrRevInfo", setMap);
				attrList = commonService.selectList("item_SQL.getItemRevDetailInfo", setMap);
			} else {
				attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
			}
			
			/* elementList 취득 */
			if ("N".equals(StringUtil.checkNull(commandMap.get("onlyMap"))) && "element".equals(activityMode)) { // QMS 의 경우
				// mdlIF = Y 인 symbolList
				Map setMap2 = new HashMap();
				setMap2.put("s_itemID", subProcessMap.get("MyItemID"));
				setMap2.put("itemID", String.valueOf(subProcessMap.get("MyItemID")));
				setMap2.put("languageID", languageId);
				
				Map modelMap2 = commonService.select("report_SQL.getModelIdAndSize", setMap2);
				modelID = StringUtil.checkNull(modelMap2.get("ModelID"));
				if(accMode.equals("OPS")) {
					modelID = commonService.selectString("model_SQL.getModelIDFromItem", setMap2);
				}
				
				setMap2.put("ModelID",modelID);
				setMap2.put("mdlIF", "Y");
				elementList = commonService.selectList("report_SQL.getObjListOfModel", setMap2);
			}
			
			Map csInfo = commonService.select("cs_SQL.getChangeSetInfo", setMap);
			totalMap.put("csAuthorNM",csInfo.get("AuthorName"));
			totalMap.put("csOwnerTeamNM",csInfo.get("TeamName"));
			
			//=====================================================================================================
			/* 기본정보의 속성 내용을 취득 */
			commandMap.put("ItemID", subProcessMap.get("MyItemID"));
			commandMap.put("DefaultLang", defaultLang);
			
			if ("N".equals(StringUtil.checkNull(commandMap.get("onlyMap")))) {
				if(!"OPS".equals(accMode)) attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
				
				Map attrMap = new HashMap();
				Map attrNameMap = new HashMap();
				Map attrHtmlMap = new HashMap();
				String mlovAttrText = "";
				for (int k = 0; attrList.size()>k ; k++ ) {
					map = (Map) attrList.get(k);
					if(!map.get("DataType").equals("MLOV")){
						attrMap.put(map.get("AttrTypeCode"), StringEscapeUtils.unescapeHtml4((String) map.get("PlainText")));	// 기본정보의 td
					} else {
						String mlovAttrCode = (String) map.get("AttrTypeCode");
						if(attrMap.get(mlovAttrCode) == null || attrMap.get(mlovAttrCode) == ""){
							mlovAttrText = map.get("PlainText").toString();
						} else {
							mlovAttrText += " / "+map.get("PlainText").toString();
						}
						attrMap.put(mlovAttrCode, mlovAttrText);	
					}
					attrNameMap.put(map.get("AttrTypeCode"), map.get("Name"));	// 기본정보의 th
					attrHtmlMap.put(map.get("AttrTypeCode"), map.get("HTML"));
				}

				Map AttrTypeList = new HashMap();
				List temp = commonService.selectList("attr_SQL.getItemAttrType", setMap);
				Map AttrTypeListTemp = new HashMap();

				for(int j=0; j<temp.size(); j++){
					AttrTypeListTemp = (Map) temp.get(j);
					AttrTypeList.put(AttrTypeListTemp.get("AttrTypeCode"), AttrTypeListTemp.get("DataType"));
				}
				
				totalMap.put("AttrTypeList", AttrTypeList);
				
				totalMap.put("attrMap", attrMap);
				totalMap.put("attrNameMap", attrNameMap);
				totalMap.put("attrHtmlMap", attrHtmlMap);
				
				if("OPS".equals(accMode)){
					setMap.put("asgnOption", "2,3"); //해제,신규 미출력
					setMap.put("cngStatus", "CLS"); //상태 : 완료
				} else {
					setMap.put("asgnOption", "1,2"); //해제,해제중 미출력
				}
				
				setMap.put("itemID", subProcessMap.get("MyItemID"));
				
				if ("on".equals(StringUtil.checkNull(setMap.get("csYN")))) {
					cngtList = commonService.selectList("report_SQL.getItemChangeListRPT", setMap);
				}
				
				setMap.remove("asgnOption");
				setMap.remove("cngStatus");
				
				setMap.put("refModelID", modelMap.get("ModelID"));
				elmObjList = commonService.selectList("model_SQL.getElmtsObjectList_gridList", setMap);
				elmObjList = getActivityAttr(elmObjList, defaultLang ,languageId, attrNameMap, attrHtmlMap,activityMap);
			}
			
			totalMap.put("prcList", prcList);								// 기본정보
			totalMap.put("modelMap", modelMap);				// 업무처리 절차
			totalMap.put("cngtList", cngtList);							// 변경이력
			totalMap.put("elementList", detailElementList);	// 선/후행 Process
			totalMap.put("elmObjList", elmObjList);				// 엘리먼트 OJ, MOJ 목록
//			totalMap.put("elementObjList", elementList);				// 엘리먼트 목록
			totalList.add(index, totalMap);
		}
	}
	
	public void setModelMap(Map modelMap, HttpServletRequest request) {
		// model size 조정
		int width = 546;
		int height = 580;
		int actualWidth = 0;
		int actualHeight = 0;
		int zoom = 100;
		
		/* 문서에 표시할 모델 맵 크기를 계산 한다 */
		if ("2".equals(request.getParameter("paperSize"))) {
			width = 700;
			height = 930;
 		}
		
		actualWidth = Integer.parseInt(StringUtil.checkNull(modelMap.get("Width"), String.valueOf(width)));
		actualHeight = Integer.parseInt(StringUtil.checkNull(modelMap.get("Height"), String.valueOf(height)));
		
		if (width < actualWidth || height < actualHeight) {
			for (int i = 99 ; i > 1 ; i-- ) {
				actualWidth = (actualWidth * i) / 100;
				actualHeight = (actualHeight * i) / 100;
				if( width > actualWidth && height > actualHeight ){
					zoom = i; 
					break;
				}
			}
		}
		
		modelMap.remove("Width");
		modelMap.remove("Height");
		modelMap.put("Width", actualWidth);
		modelMap.put("Height", actualHeight);
		System.out.println("Width=="+actualWidth);
		System.out.println("Height=="+actualHeight);
	}

	private List getElementList(Map setMap2, Map modelMap) throws Exception {
		List returnList = new ArrayList();
		
		// mdlIF = Y 인 symbolList
		setMap2.put("mdlIF","Y");
		setMap2.put("modelTypeCode", modelMap.get("ModelTypeCode"));
		List symbolList = commonService.selectList("model_SQL.getSymbolTypeList", setMap2);
		
		String SymTypeCodes = "";
		for(int i=0; i<symbolList.size(); i++) {
			Map map = (Map) symbolList.get(i);
			if(i != 0) SymTypeCodes += ",";
			SymTypeCodes += "'"+map.get("SymTypeCode")+"'";
		}
		
		/* [TB_ELEMENT]에서 선행 /후행 데이터 취득 */
		setMap2.remove("FromID");
		setMap2.remove("ToID");
		setMap2.put("ModelID", modelMap.get("ModelID"));
		setMap2.put("SymTypeCodes", SymTypeCodes);
		List elementList = commonService.selectList("report_SQL.getObjListOfModel", setMap2);
		
		for (int i = 0 ; elementList.size()> i ; i++) {
			Map returnMap = new HashMap();
			Map elementMap = (Map) elementList.get(i);
			String elementId = String.valueOf(elementMap.get("ElementID"));
			String objectId = String.valueOf(elementMap.get("ObjectID"));
			
			returnMap = elementMap;
			returnMap.put("RNUM", i + 1);
						
			// 선행, 후행 아이템의 Item Info 취득
			setMap2.put("s_itemID", objectId);
			Map itemInfoMap = commonService.select("report_SQL.getItemInfo", setMap2);
			returnMap.put("ID", itemInfoMap.get("Identifier"));
			returnMap.put("Name", itemInfoMap.get("ItemName"));
			returnMap.put("Description", StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(itemInfoMap.get("Description"),"")));
			
			returnList.add(returnMap);
		}
				
		return returnList;
	}

	private List getActivityAttr(List List, String defaultLang, String sessionCurrLangType,Map attrNameMap, Map attrHtmlMap, Map activityMap) throws Exception {
		List resultList = new ArrayList();
		Map setMap = new HashMap();
//		List actToCheckList = new ArrayList();
//		List actRuleSetList = new ArrayList();
//		List actSystemList = new ArrayList();
//		List actRoleList = new ArrayList();
//		List actITSystemList = new ArrayList(); // 연관항목 리스트 출력
//		List actTeamRoleList = new ArrayList(); // 관련조직 리스트 출력
//		List actPrcList = new ArrayList(); // QMS 용 기본정보
		
		String accMode = String.valueOf(activityMap.get("accMode"));
		String changeSetID = String.valueOf(activityMap.get("changeSetID"));
		String activityMode = StringUtil.checkNull(activityMap.get("activityMode"));
		
		setMap.put("DefaultLang", defaultLang);
		setMap.put("sessionCurrLangType", sessionCurrLangType);
		setMap.put("languageID", sessionCurrLangType);
		
		for (int i = 0; i < List.size(); i++) {
			Map listMap = new HashMap();
			listMap = (Map) List.get(i);
			String itemId = String.valueOf(listMap.get("ItemID"));
			
//			// QMS&E2E의 경우
//			if ("element".equals(activityMode)) {
//				itemId = String.valueOf(listMap.get("ObjectID"));
//				setMap.put("itemId", itemId);
//				setMap.put("s_itemID", itemId);
//				
//				changeSetID = commonService.selectString("cs_SQL.getChangeSetID", setMap);
//				actPrcList = commonService.selectList("report_SQL.getItemInfo", setMap);
//				
//				for(int j=0; j < actPrcList.size(); j++) {
//					Map actInfo = (Map) actPrcList.get(j);
//					if(actInfo.containsKey("OwnerTeamID")) {
//						setMap.put("teamID", StringUtil.checkNull(actInfo.get("OwnerTeamID")));
//						Map managerInfo = commonService.select("user_SQL.getUserTeamManagerInfo", setMap);
//						listMap.put("ownerTeamMngNM",managerInfo.get("MemberName"));	// 프로세스 책임자
//						setMap.remove("teamID");
//					}
//				}
//				if (accMode.equals("OPS")) {
//					changeSetID = commonService.selectString("item_SQL.getItemReleaseNo", setMap);
//					setMap.put("changeSetID", changeSetID);
//					actPrcList = commonService.selectList("item_SQL.getItemAttrRevInfo", setMap);
//				}
//			}
//			listMap.put("actPrcList", actPrcList);
			
			setMap.put("ItemID", itemId);
			
			List attrList = new ArrayList();
			if(accMode.equals("OPS")) {
				setMap.put("changeSetID", changeSetID);
				setMap.put("s_itemID", itemId);
				setMap.put("defaultLang", defaultLang);
				attrList = commonService.selectList("item_SQL.getItemRevDetailInfo", setMap);
				setMap.remove(changeSetID);
			} else {
				attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
			}
			
			for (int k = 0; attrList.size()>k ; k++ ) {
				Map map = (Map) attrList.get(k);
				String plainText = "";
				if(map.get("DataType").equals("MLOV")){
					plainText = getMLovVlaue(sessionCurrLangType, itemId, StringUtil.checkNull(map.get("AttrTypeCode")));
					listMap.put(map.get("AttrTypeCode"), plainText);
				}else{
					if(StringUtil.checkNull(map.get("HTML"),"").equals("1")) {
						listMap.put(map.get("AttrTypeCode"), StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(map.get("PlainText"))));
					} else {
						listMap.put(map.get("AttrTypeCode"), map.get("PlainText"));
					}
				}
			}
			
//			/*Activity Rule Set 취득  Rule Group의 하위항목 Rule set list 취득 */
//			setMap.put("CURRENT_ITEM", itemId); // 해당 아이템이 [FromItemID]인것
//			setMap.put("itemTypeCode", "CN00107");
//			actRuleSetList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
//			/* Rule set list의 연관 프로세스 && 속성 정보 취득 */			
//			actRuleSetList = getConItemInfo(actRuleSetList, defaultLang, sessionCurrLangType, attrNameMap, attrHtmlMap, "CN00107", "ToItemID");
//			listMap.put("actRuleSetList", actRuleSetList);
//			setMap.remove("CURRENT_ITEM");
			
//			//ToCheck 취득 
//			setMap.put("CURRENT_ITEM", itemId); // 해당 아이템이 [ToItemID]인것
//			setMap.put("itemTypeCode", "CN00109");			
//			actToCheckList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
//			// Activity ToCheck list의 연관 프로세스 && 속성 정보 취득 
//			actToCheckList = getConItemInfo(actToCheckList, defaultLang, sessionCurrLangType, attrNameMap, attrHtmlMap, "CN00109", "ToItemID");
//			listMap.put("actToCheckList", actToCheckList);
//			setMap.remove("CURRENT_ITEM");
			
			//System 취득 
//			setMap.put("CURRENT_ITEM", itemId); // 해당 아이템이 [ToItemID]인것
//			setMap.put("itemTypeCode", "CN00104");			
//			actSystemList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
//			// Activity system list의 연관 프로세스 && 속성 정보 취득 
//			actSystemList = getConItemInfo(actSystemList, defaultLang, sessionCurrLangType, attrNameMap, attrHtmlMap, "CN00104", "ToItemID");
//			listMap.put("actSystemList", actSystemList);
//			setMap.remove("CURRENT_ITEM");
			
//			//연관항목 취득
//			setMap.put("s_itemID", itemId);
//			actITSystemList = commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);
//			listMap.put("actITSystemList", actITSystemList);
			
//			// Role 취득 
//			setMap.put("CURRENT_ToItemID", itemId); 
//			setMap.put("itemTypeCode", "CN00201");			
//			actRoleList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
//			// Activity Role list의 연관 프로세스 && 속성 정보 취득 
//			actRoleList = getConItemInfo(actRoleList, defaultLang, sessionCurrLangType, attrNameMap, attrHtmlMap, "CN00201", "FromItemID");
//			listMap.put("actRoleList", actRoleList);
//			setMap.remove("CURRENT_ToItemID");
						
//			// 관련조직 취득 
//			setMap.put("itemID", itemId);
//			if("OPS".equals(accMode)){
//				setMap.put("asgnOption", "2,3"); //해제,신규 미출력
//			} else {
//				setMap.put("asgnOption", "1,2"); //해제,해제중 미출력
//			}
//			actTeamRoleList = commonService.selectList("role_SQL.getItemTeamRoleList_gridList", setMap);
//			listMap.put("actTeamRoleList", actTeamRoleList);
			
			resultList.add(listMap);
		}
		
		return resultList;
	}

    private List getConItemInfo(List List, String defaultLang, String sessionCurrLangType, Map attrRsNameMap, Map attrRsHtmlMap, String cnTypeCode , String source) throws Exception {
        List resultList = new ArrayList();
        Map setMap = new HashMap();
        
        for (int i = 0; i < List.size(); i++) {
            Map listMap = new HashMap();
            List resultSubList = new ArrayList();
            
            listMap = (Map) List.get(i);
            String itemId = String.valueOf(listMap.get(source));
            
            setMap.put("ItemID", itemId);
            setMap.put("DefaultLang", defaultLang);
            setMap.put("sessionCurrLangType", sessionCurrLangType);
            List attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
            
            String plainText = "";
            for (int k = 0; attrList.size()>k ; k++ ) {
                Map map = (Map) attrList.get(k);                
                attrRsNameMap.put(map.get("AttrTypeCode"), map.get("Name"));
                attrRsHtmlMap.put(map.get("AttrTypeCode"), map.get("HTML"));
                if(map.get("DataType").equals("MLOV")){
                    plainText = getMLovVlaue(sessionCurrLangType, itemId, StringUtil.checkNull(map.get("AttrTypeCode")));
                    listMap.put(map.get("AttrTypeCode"), plainText);
                }else{
                    listMap.put(map.get("AttrTypeCode"), map.get("PlainText"));
                }
            }
            
            String isFromItem = "Y";
            if(!source.equals("FromItemID")){ isFromItem = "N"; }
            setMap.put("varFilter", cnTypeCode);
            setMap.put("languageID", sessionCurrLangType);
            setMap.put("isFromItem", isFromItem);
            setMap.put("s_itemID", itemId);
            List relatedAttrList = new ArrayList();
//            List cnItemList = commonService.selectList("item_SQL.getCXNItems", setMap);
        
//            for (int k = 0; cnItemList.size()>k ; k++ ) {
//                Map map = (Map) cnItemList.get(k);
            if(isFromItem.equals("Y")){
                resultSubList.add(StringUtil.checkNull(listMap.get("fromItemIdentifier")) + " " + removeAllTag(StringUtil.checkNull(listMap.get("fromItemName"))));
            } else {
                resultSubList.add(StringUtil.checkNull(listMap.get("toItemIdentifier")) + " " + removeAllTag(StringUtil.checkNull(listMap.get("toItemName"))));
            }
                setMap.put("ItemID", listMap.get("FromItemID"));
                setMap.put("DefaultLang", defaultLang);
                setMap.put("sessionCurrLangType", sessionCurrLangType);
                relatedAttrList = commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
                if(relatedAttrList.size()>0){
                    for(int m=0; m<relatedAttrList.size(); m++){
                        Map relAttrMap = (Map) relatedAttrList.get(m);                            
                        resultSubList.add(StringUtil.checkNull(relAttrMap.get("Name")));
                        resultSubList.add(StringUtil.checkNull(relAttrMap.get("PlainText")));
                        resultSubList.add(StringUtil.checkNull(relAttrMap.get("HTML")));
                    }
                }
//            }
            listMap.put("resultSubList", resultSubList);        
            
            resultList.add(listMap);
        }
        
        return resultList;
    }
	
	
}
