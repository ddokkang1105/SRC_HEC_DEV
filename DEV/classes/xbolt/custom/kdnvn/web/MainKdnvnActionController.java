package xbolt.custom.kdnvn.web;

import java.io.File;
import java.io.FileOutputStream;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.AESUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

/**
 * 공통 서블릿 처리
 * @Class Name : MainKdnvnActionController.java
 * @Description : 공통화면을 제공한다.
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2019.01 .08. Smartfactory		최초생성
 *
 * @since 2019. 01. 08.
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class MainKdnvnActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
	private AESUtil aesAction;
	
	// HanwhaDefense 
	@RequestMapping(value="/indexKDNVN.do")
	public String indexKDNVN(Map cmmMap,ModelMap model, HttpServletRequest request) throws Exception {
		try{
				Map setData = new HashMap();
				Map userInfo = new HashMap();
				
				String empNo = StringUtil.checkNull(request.getParameter("empNo"),"");
				String langCode = StringUtil.checkNull(request.getParameter("language"),"");
				
				setData.put("extCode", langCode);
				langCode = commonService.selectString("common_SQL.getLanguageID", setData);
				setData.put("employeeNum", empNo);
				
				if(empNo != null && !empNo.isEmpty()) {
					userInfo = commonService.select("common_SQL.getLoginIDFromMember", setData);
				}
				
				if(userInfo != null && !userInfo.isEmpty()) {
					model.put("olmI", StringUtil.checkNull(userInfo.get("LoginId")));
				}
				model.put("olmLng",langCode);
				model.put("IS_CHECK", "N");	
				model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType"),""));
				model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType"),""));
				model.put("srID", StringUtil.checkNull(cmmMap.get("srID"),""));
				model.put("pwdCheck", StringUtil.checkNull(cmmMap.get("pwdCheck"),""));
				model.put("defArcCode", StringUtil.checkNull(cmmMap.get("defArcCode"),""));
				model.put("defTemplateCode", StringUtil.checkNull(cmmMap.get("defTemplateCode"),""));
				
		}catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("MainKdnvnActionController::KDNVN Login ::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl("indexKDNVN");
	}
	
	@RequestMapping(value="kdnvn/loginkdnvnForm.do")
	public String loginkdnvnForm(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
	  model=setKdnvnLoginScrnInfo(model,cmmMap);
	  model.put("screenType", cmmMap.get("screenType"));
	  model.put("mainType", cmmMap.get("mainType"));
	  model.put("srID", cmmMap.get("srID"));
	  model.put("status", cmmMap.get("status"));
	  model.put("pwdCheck", cmmMap.get("pwdCheck"));
	  model.put("defArcCode", cmmMap.get("defArcCode"));
	  model.put("defTemplateCode", cmmMap.get("defTemplateCode"));
	  
	  return nextUrl("/custom/kdnvn/login");
	}
	
	@RequestMapping(value="/kdnvn/loginkdnvn.do")
	public String loginkdnvn(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		try {
			HttpSession session = request.getSession(true);
			Map resultMap = new HashMap();
			String langCode = GlobalVal.DEFAULT_LANG_CODE;
			String languageID = StringUtil.checkNull(cmmMap.get("LANGUAGE"),StringUtil.checkNull(cmmMap.get("LANGUAGEID")) );
				if(languageID.equals("")){
					languageID = GlobalVal.DEFAULT_LANGUAGE;
				}
			
			cmmMap.put("LANGUAGE", languageID);
			String ref = request.getHeader("referer");
			String protocol = request.isSecure() ? "https://" : "http://";
			
			String IS_CHECK2 = StringUtil.checkNull(cmmMap.get("IS_CHECK"),"");
			String IS_CHECK = GlobalVal.PWD_CHECK;
			
			if("".equals(IS_CHECK))
				IS_CHECK = "Y";
			
			if("N".equals(IS_CHECK2))
				IS_CHECK = "N";
			
			cmmMap.put("IS_CHECK", IS_CHECK);
			String url_CHECK = StringUtil.chkURL(ref, protocol);
			String pwdCheck = StringUtil.checkNull(cmmMap.get("pwdCheck"),"");
			
			if("".equals(url_CHECK)) {
				resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
				resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00002"));	
			}
			else {		
				Map idInfo = commonService.select("login_SQL.login_id_select", cmmMap);
				model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx")));
				if(idInfo == null || idInfo.size() == 0) {
					resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
					//resultMap.put(AJAX_ALERT, "해당아이디가 존재하지 않습니다.");
					resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00002"));				
				}
				else {
					aesAction = new AESUtil();
					cmmMap.put("LOGIN_ID", idInfo.get("LoginId"));
					
					if("Y".equals(IS_CHECK) && "login".equals(url_CHECK)) {
						cmmMap.put("IS_CHECK", "Y");
					}
					else if (pwdCheck.equals("N")){
						cmmMap.put("IS_CHECK", "N");
					}
					
					String pwd = (String) cmmMap.get("PASSWORD");
					
					if("Y".equals(GlobalVal.PWD_ENCODING)) {
						aesAction.setIV(request.getParameter("iv"));
						aesAction.setSALT(request.getParameter("salt"));
						
						pwd =  aesAction.decrypt(pwd);
											
						aesAction.init();
						
						pwd = aesAction.encrypt(pwd);
					}
	
					cmmMap.put("PASSWORD", pwd); 
					
					Map loginInfo = commonService.select("login_SQL.login_select", cmmMap);
					if(loginInfo == null || loginInfo.size() == 0) {
						resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
						//resultMap.put(AJAX_ALERT, "System에 해당 사용자 정보가 없습니다.등록 요청바랍니다.");
						resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00102"));					
					}
					else {
						// [Authority] < 4 인 경우, 수정가능하게 변경
						if(loginInfo.get("sessionAuthLev").toString().compareTo("4") < 0)	loginInfo.put("loginType", "editor");
						else	loginInfo.put("loginType", "viewer");	
						
						resultMap.put(AJAX_SCRIPT, "parent.fnReload('Y')");
						//resultMap.put(AJAX_MESSAGE, "Login성공");					
						session.setAttribute("loginInfo", loginInfo);
					}
				}
				model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx")));
				model.addAttribute(AJAX_RESULTMAP,resultMap);
			}
		}
		catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("LoginActionController::loginbase::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}	
	

	private ModelMap setKdnvnLoginScrnInfo(ModelMap model,HashMap cmmMap) throws Exception {
		  
	  String pass = StringUtil.checkNull(cmmMap.get("pwd"));
	  model.addAttribute("loginid",StringUtil.checkNull(cmmMap.get("loginid"), ""));
	  model.addAttribute("pwd",pass);
	  model.addAttribute("lng",StringUtil.checkNull(cmmMap.get("lng"), ""));
	  
	  if(_log.isInfoEnabled()){_log.info("setLoginScrnInfo : loginid="+StringUtil.checkNull(cmmMap.get("loginid"))+",pass"+URLEncoder.encode(pass)+",lng="+StringUtil.checkNull(cmmMap.get("lng")));}		  
	  List langList = commonService.selectList("common_SQL.langType_commonSelect", cmmMap);
	  if( langList!=null &&langList.size() > 0){
		  for(int i=0; i<langList.size();i++){
			  Map langInfo = (HashMap) langList.get(i);
			  if(langInfo.get("IsDefault").equals("1")){
				  model.put("langType", StringUtil.checkNull(langInfo.get("CODE"),""));
				  model.put("langName", StringUtil.checkNull(langInfo.get("NAME"),""));
			  }
		  }
	  }else{model.put("langType", "");model.put("langName", "");}
	  model.put("langList", langList);
	  model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx"))); //singleSignOn 구분
	  return model;
 	}

	
	@RequestMapping(value="/mainHomeKdnvn.do")
	public String mainHomeKdnvn(HttpServletRequest request, Map cmmMap,ModelMap model) throws Exception {		
		try {
			Map setMap = new HashMap();
	    	String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),GlobalVal.DEFAULT_LANGUAGE);
	    	setMap.put("languageID", languageID);

			List nameList = (List)commonService.selectList("custom_SQL.getMainItemName", setMap);
			
			model.put("nameList", nameList);
			model.put("languageID", languageID);
			model.put("menu", getLabel(request, commonService));
		}
		catch(Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());			
		}
		return nextUrl("/custom/kdnvn/mainHomeKdnvn");
	}
	
		@RequestMapping(value="/visitLogStatisticsByTeamKDNVN.do")
	public String visitLogStatisticsByTeamKDNVN(HttpServletRequest request, ModelMap model, HashMap cmmMap) throws ExceptionUtil {
		
		try {
			String haederL1 = StringUtil.checkNull(request.getParameter("haederL1"), "OJ00001");
			String filepath = request.getSession().getServletContext().getRealPath("/");
			Map<String, Object> setMap = new HashMap<String, Object>();

			// Date
			String startDate = "";
			String endDate = "";			
			String teamID = StringUtil.checkNull(request.getParameter("teamID"),"");
			String companyID = StringUtil.checkNull(request.getParameter("companyID"), "");
			
			String year = StringUtil.checkNull(request.getParameter("year"),"");
			String month = StringUtil.checkNull(request.getParameter("month"),"");
			String date = year + month;
				
			Map rowMap = new HashMap();
			List allCountList = new ArrayList();
			List teamList = new ArrayList();
			
			int lastYear = Calendar.getInstance().get(Calendar.YEAR);
			model.put("lastYear",lastYear);
			
			if(date.equals("") || date == ""){
				SimpleDateFormat formatter = new SimpleDateFormat("yyyyMM");
				long curTime = System.currentTimeMillis();	
				date = formatter.format(curTime);
				endDate = date;
				startDate = date;
				year = endDate.substring(0,4);
				month = endDate.substring(4,endDate.length());
			}else{
				endDate = date;
				startDate = date;
			}		
			setMap.put("languageID",cmmMap.get("sessionCurrLangType"));		
			setMap.put("itemTypeCode",haederL1);		
			List itemNameList = commonService.selectList("analysis_SQL.getL1List", setMap);
			List companyStandardList = commonService.selectList("custom_SQL.getKDNVNCompanyStandard", setMap);
			
			setMap.put("teamID",teamID);
			setMap.put("companyID",companyID);
			
			teamList = commonService.selectList("custom_SQL.getKDNVNTeamList", setMap);
			
			// system date 부터  한달의 visit log 취득
			for (int i = 0; i < teamList.size() ; i++) {
				rowMap = new HashMap();				
				setMap.put("Date", date);
				setMap.put("dayType", StringUtil.checkNull(cmmMap.get("dayType"),"MONTH"));
				setMap.put("teamID",((HashMap)teamList.get(i)).get("CODE"));
				setMap.put("companyID",companyID);
				setMap.put("Date", date);
				List processVisitCntList = commonService.selectList("analysis_SQL.getVisitCountByConLog", setMap);
				Map processVisitCntMap = getCountMap(processVisitCntList, "L1ItemID", "CNT");

				rowMap.put("teamName",((HashMap)teamList.get(i)).get("NAME"));
				rowMap.put("totalMember", NumberUtil.getIntValue(processVisitCntMap.get("MemberCount")));
				
				for (int j = 0; itemNameList.size() > j ; j++) {
					Map itemNameMap = (Map) itemNameList.get(j);
					String itemName = String.valueOf(itemNameMap.get("CODE"));
					if (processVisitCntMap.containsKey(itemName)) {
						rowMap.put(itemName, processVisitCntMap.get(itemName));
					} else {
						rowMap.put(itemName, "0");
					}
				}
				for (int j = 0; companyStandardList.size() > j ; j++) {
					Map companyStandardMap = (Map) companyStandardList.get(j);
					String itemName = String.valueOf(companyStandardMap.get("CODE"));
					
					if (processVisitCntMap.containsKey(itemName)) {
						rowMap.put(itemName, processVisitCntMap.get(itemName));
					} else {
						rowMap.put(itemName, "0");
					}
				}

				allCountList.add(rowMap);
			}
			
			// 통계 수치 resultList를 xml에 값 셋팅해서 grid 생성 
			// TODO:통계 리스트 표시 할 xml 파일 생성
			DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance(); 
	        DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
	        
	        // 루트 엘리먼트 
	        Document doc = docBuilder.newDocument(); 
	        Element rootElement = doc.createElement("rows"); 
	        doc.appendChild(rootElement); 
			
	        int rowId = 1;
	        
	        for (int i = 0; i < allCountList.size(); i++) {
	        	// row 엘리먼트 
	            Element row = doc.createElement("row"); 
	            rootElement.appendChild(row); 
	            row.setAttribute("id", String.valueOf(rowId));
	            rowId++;
	            
	            Map countRowMap = (Map) allCountList.get(i);
	            
	            Element cell = doc.createElement("cell"); 
	            // Date
	            cell = doc.createElement("cell"); 
	            cell.appendChild(doc.createTextNode(String.valueOf(countRowMap.get("teamName"))));
                row.appendChild(cell);
                
	            for (int j = 0; itemNameList.size() > j ; j++) {
	            	Map itemNameMap = (Map) itemNameList.get(j);
	            	String itemName = String.valueOf(itemNameMap.get("CODE"));
	            	cell = doc.createElement("cell"); 
	            	cell.appendChild(doc.createTextNode(String.valueOf(countRowMap.get(itemName))));
	                row.appendChild(cell); 
	            }
	            for (int j = 0; companyStandardList.size() > j ; j++) {
	            	Map companyStandardMap = (Map) companyStandardList.get(j);
	            	String itemName = String.valueOf(companyStandardMap.get("CODE"));
	            	cell = doc.createElement("cell"); 
	            	cell.appendChild(doc.createTextNode(String.valueOf(countRowMap.get(itemName))));
	                row.appendChild(cell); 
	            }
	        }
	        
	        setMap = new HashMap<String, Object>();	        
	        setMap.put("languageID",cmmMap.get("sessionCurrLangType"));
	        setMap.put("startDate", startDate);
	        setMap.put("endDate", endDate);
	        setMap.put("dayType", StringUtil.checkNull(cmmMap.get("dayType"),"MONTH"));
	        setMap.put("teamID", teamID);
			setMap.put("companyID",companyID);
	        List processVisitCntList = commonService.selectList("analysis_SQL.getVisitCountByConLog", setMap);
			Map processVisitCntMap = getCountMap(processVisitCntList, "L1ItemID", "CNT");
			
			// TOTAL 행에 표시될 값 설절
	        Element row = doc.createElement("row"); 
            rootElement.appendChild(row); 
            row.setAttribute("id", String.valueOf(rowId));
	        
            Element cell = doc.createElement("cell"); 
            cell = doc.createElement("cell"); 
            cell.appendChild(doc.createTextNode("Total"));
            row.appendChild(cell); 
            
            for (int j = 0; itemNameList.size() > j ; j++) {
            	Map itemNameMap = (Map) itemNameList.get(j);
            	String itemName = String.valueOf(itemNameMap.get("CODE"));
            	cell = doc.createElement("cell"); 
            	cell.appendChild(doc.createTextNode(StringUtil.checkNull(processVisitCntMap.get(itemName), "0")));
                row.appendChild(cell); 
            }
            for (int j = 0; companyStandardList.size() > j ; j++) {
            	Map companyStandardMap = (Map) companyStandardList.get(j);
            	String itemName = String.valueOf(companyStandardMap.get("CODE"));
            	cell = doc.createElement("cell"); 
            	cell.appendChild(doc.createTextNode(StringUtil.checkNull(processVisitCntMap.get(itemName), "0")));
                row.appendChild(cell); 
            }

	        // XML 파일로 쓰기 
	        TransformerFactory transformerFactory = TransformerFactory.newInstance(); 
	        Transformer transformer = transformerFactory.newTransformer(); 
	 
	        transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8"); 
	        transformer.setOutputProperty(OutputKeys.INDENT, "yes");        
	        DOMSource source = new DOMSource(doc); 
	        
	        StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + "upload/visitLogStatisticsByTeamKDNVNGrid.xml"))); 
	        transformer.transform(source, result);
			
		
			model.put("processRows", makeGridHeader(itemNameList, "NAME", ","));
			model.put("processCols", makeGridHeader(itemNameList, "|"));
			model.put("processCnt", itemNameList.size());
			model.put("companyStandardRows", makeGridHeader(companyStandardList, "NAME", ","));
			model.put("companyStandardCols", makeGridHeader(companyStandardList, "|"));
			model.put("companyStandardCnt", companyStandardList.size());
			model.put("year", year);
			model.put("month", month);
			model.put("teamID", teamID);
			model.put("companyID", companyID);
			setMap.put("reportCode",StringUtil.checkNull(request.getParameter("reportCode"), ""));
			model.put("title", commonService.selectString("report_SQL.getReportName", setMap));
			model.put("menu", getLabel(request, commonService));
			
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl("/custom/kdnvn/report/visitLogStatisticsByTeam");
	}
	
	
	@RequestMapping(value="/visitLogStatisticsByDayKDNVN.do")
	public String visitLogStatisticsByDayKDNVN(HttpServletRequest request, ModelMap model, HashMap cmmMap) throws ExceptionUtil {
		
		try {
			String haederL1 = StringUtil.checkNull(request.getParameter("haederL1"), "OJ00001");
			List itemNameList = new ArrayList();
			List companyStandardList = new ArrayList();
			String filepath = request.getSession().getServletContext().getRealPath("/");
			Map<String, Object> setMap = new HashMap<String, Object>();
			long startDate = 0,endDate = 0; 
			setMap.put("languageID",cmmMap.get("sessionCurrLangType"));		
			setMap.put("itemTypeCode",haederL1);
			
			itemNameList = commonService.selectList("analysis_SQL.getL1List", setMap);
			companyStandardList = commonService.selectList("custom_SQL.getKDNVNCompanyStandard", setMap);
							
			Map rowMap = new HashMap();
			
			List allCountList = new ArrayList();
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
			
			// system date 부터  한달의 visit log 취득
			for (int i = 1; 31 > i ; i++) {
				rowMap = new HashMap();
				// Date
				
				long date = System.currentTimeMillis() - ((long) 1000 * 60 * 60 * 24 * i);
				
				if(i==1){ endDate = date;	}if(i == 30){ startDate = date; }
				
				rowMap.put("Date", formatter.format(date));
				setMap.put("dayType", StringUtil.checkNull(cmmMap.get("dayType"),"DAY"));
				
				setMap.put("Date", formatter.format(date));
				List processVisitCntList = commonService.selectList("analysis_SQL.getVisitCountByConLog", setMap);
				Map processVisitCntMap = getCountMap(processVisitCntList, "L1ItemID", "CNT");
				rowMap.put("totalMember", NumberUtil.getIntValue(processVisitCntMap.get("MemberCount")));
				
				for (int j = 0; itemNameList.size() > j ; j++) {
					Map itemNameMap = (Map) itemNameList.get(j);
					String itemName = String.valueOf(itemNameMap.get("CODE"));
					
					if (processVisitCntMap.containsKey(itemName)) {
						rowMap.put(itemName, processVisitCntMap.get(itemName));
					} else {
						rowMap.put(itemName, "0");
					}
				}
				for (int j = 0; companyStandardList.size() > j ; j++) {
					Map companyStandardMap = (Map) companyStandardList.get(j);
					String itemName = String.valueOf(companyStandardMap.get("CODE"));
					
					if (processVisitCntMap.containsKey(itemName)) {
						rowMap.put(itemName, processVisitCntMap.get(itemName));
					} else {
						rowMap.put(itemName, "0");
					}
				}
				allCountList.add(rowMap);
			}
			
			// 통계 수치 resultList를 xml에 값 셋팅해서 grid 생성 
			// TODO:통계 리스트 표시 할 xml 파일 생성
			DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance(); 
	        DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
	        
	        // 루트 엘리먼트 
	        Document doc = docBuilder.newDocument(); 
	        Element rootElement = doc.createElement("rows"); 
	        doc.appendChild(rootElement); 
			
	        int rowId = 1;
	        
	        for (int i = 0; i < allCountList.size(); i++) {
	        	// row 엘리먼트 
	            Element row = doc.createElement("row"); 
	            rootElement.appendChild(row); 
	            row.setAttribute("id", String.valueOf(rowId));
	            rowId++;
	            
	            Map countRowMap = (Map) allCountList.get(i);
	            
	            Element cell = doc.createElement("cell"); 
	            // Date
	            cell = doc.createElement("cell"); 
	            cell.appendChild(doc.createTextNode(String.valueOf(countRowMap.get("Date"))));
                row.appendChild(cell);
                
                // Total 접속자수
                cell = doc.createElement("cell"); 
	            cell.appendChild(doc.createTextNode(String.valueOf(countRowMap.get("totalMember"))));
                row.appendChild(cell);
	            
	            for (int j = 0; itemNameList.size() > j ; j++) {
	            	Map itemNameMap = (Map) itemNameList.get(j);
	            	String itemName = String.valueOf(itemNameMap.get("CODE"));
	            	cell = doc.createElement("cell"); 
	            	cell.appendChild(doc.createTextNode(String.valueOf(countRowMap.get(itemName))));
	                row.appendChild(cell); 
	            }
	            for (int j = 0; companyStandardList.size() > j ; j++) {
	            	Map companyStandardMap = (Map) companyStandardList.get(j);
	            	String itemName = String.valueOf(companyStandardMap.get("CODE"));
	            	cell = doc.createElement("cell"); 
	            	cell.appendChild(doc.createTextNode(String.valueOf(countRowMap.get(itemName))));
	                row.appendChild(cell); 
	            }
	        }
	        
	        setMap = new HashMap<String, Object>();
	        setMap.put("startDate", formatter.format(startDate));
	        setMap.put("endDate", formatter.format(endDate));
	        setMap.put("dayType", StringUtil.checkNull(cmmMap.get("dayType"),"DAY"));
	        setMap.put("languageID",cmmMap.get("sessionCurrLangType"));
	        List processVisitCntList = commonService.selectList("analysis_SQL.getVisitCountByConLog", setMap);
			Map processVisitCntMap = getCountMap(processVisitCntList, "L1ItemID", "CNT");
			
			// TOTAL 행에 표시될 값 설절
	        Element row = doc.createElement("row"); 
            rootElement.appendChild(row); 
            row.setAttribute("id", String.valueOf(rowId));
	        
            Element cell = doc.createElement("cell"); 
            cell = doc.createElement("cell"); 
            cell.appendChild(doc.createTextNode("Total"));
            row.appendChild(cell); 
            
            cell = doc.createElement("cell"); 
            cell = doc.createElement("cell"); 
            cell.appendChild(doc.createTextNode(StringUtil.checkNull(processVisitCntMap.get("MemberCount"), "0")));
            row.appendChild(cell); 
            
            for (int j = 0; itemNameList.size() > j ; j++) {
            	Map itemNameMap = (Map) itemNameList.get(j);
            	String itemName = String.valueOf(itemNameMap.get("CODE"));
            	cell = doc.createElement("cell"); 
            	cell.appendChild(doc.createTextNode(StringUtil.checkNull(processVisitCntMap.get(itemName), "0")));
                row.appendChild(cell); 
            }
            
            for (int j = 0; companyStandardList.size() > j ; j++) {
            	Map companyStandardMap = (Map) companyStandardList.get(j);
            	String itemName = String.valueOf(companyStandardMap.get("CODE"));
            	cell = doc.createElement("cell"); 
            	cell.appendChild(doc.createTextNode(StringUtil.checkNull(processVisitCntMap.get(itemName), "0")));
                row.appendChild(cell); 
            }
	        // XML 파일로 쓰기 
	        TransformerFactory transformerFactory = TransformerFactory.newInstance(); 
	        Transformer transformer = transformerFactory.newTransformer(); 
	 
	        transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8"); 
	        transformer.setOutputProperty(OutputKeys.INDENT, "yes");        
	        DOMSource source = new DOMSource(doc); 
	        
	        StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + "upload/visitLogStatisticsByDayKDNVNGrid.xml"))); 
	        transformer.transform(source, result); 
	        
			model.put("processRows", makeGridHeader(itemNameList,"NAME", ","));
			model.put("processCols", makeGridHeader(itemNameList, "|"));
			model.put("processCnt", itemNameList.size());
			model.put("companyStandardRows", makeGridHeader(companyStandardList, "NAME", ","));
			model.put("companyStandardCols", makeGridHeader(companyStandardList, "|"));
			model.put("companyStandardCnt", companyStandardList.size());
			model.put("menu", getLabel(request, commonService));
			setMap.put("reportCode",StringUtil.checkNull(request.getParameter("reportCode"), ""));
			model.put("title", commonService.selectString("report_SQL.getReportName", setMap));
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/custom/kdnvn/report/visitLogStatisticsByDay");
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
