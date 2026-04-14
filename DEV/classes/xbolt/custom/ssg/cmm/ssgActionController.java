package xbolt.custom.ssg.cmm;

import java.awt.Color;
import java.io.File;
import java.io.FileOutputStream;
import java.net.URLEncoder;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeSet;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.text.StringEscapeUtils;
import org.apache.ibatis.session.SqlSession;
import org.apache.poi.hssf.util.CellRangeAddress;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.aspose.words.BreakType;
import com.aspose.words.CellMerge;
import com.aspose.words.CellVerticalAlignment;
import com.aspose.words.Document;
import com.aspose.words.DocumentBuilder;
import com.aspose.words.HeaderFooterType;
import com.aspose.words.HeightRule;
import com.aspose.words.License;
import com.aspose.words.PageSetup;
import com.aspose.words.PaperSize;
import com.aspose.words.ParagraphAlignment;
import com.aspose.words.PreferredWidth;
import com.aspose.words.RelativeHorizontalPosition;
import com.aspose.words.RelativeVerticalPosition;
import com.aspose.words.Section;
import com.aspose.words.TabAlignment;
import com.aspose.words.WrapType;
import com.cubeone.CubeOneAPI;
import com.org.json.JSONArray;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.DRMUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.FormatUtil;
import xbolt.cmm.framework.util.MakeWordReport;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.custom.ssg.val.ssgGlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.rpt.web.ReportActionController;

import xbolt.cmm.framework.util.SessionConfig;

import nets.sso.agent.web.v2020.common.enums.AuthStatus;
import nets.sso.agent.web.v2020.authcheck.AuthCheck;
import nets.sso.agent.web.v2020.common.constant.LiteralConst;
import nets.sso.agent.web.v2020.common.exception.AgentException;
import nets.sso.agent.web.v2020.common.util.StrUtil;
import nets.sso.agent.web.v2020.common.util.WebUtil;
import nets.sso.agent.web.v2020.conf.SSOConfig;
import nets.sso.agent.web.v2020.conf.SSOProvider;


@Controller
@SuppressWarnings("unchecked")
public class ssgActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;

	@RequestMapping(value="/custom/ssg/indexSSG.do")
	public String ssgIndex(Map cmmMap, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		try{
			String ssoID = StringUtil.checkNull(cmmMap.get("LOGIN_ID"),"");
			String emartSSO = StringUtil.checkNull(cmmMap.get("emartSSO"),"");
			
			model.put("olmI", ssoID);
			model.put("olmP", "");
			model.put("emartSSO", emartSSO);
			
			model.put("olmLng", StringUtil.checkNull(cmmMap.get("olmLng"),""));
			model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType"),""));
			model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType"),""));
			model.put("srID", StringUtil.checkNull(cmmMap.get("srID"),""));
			model.put("status", StringUtil.checkNull(cmmMap.get("status"),""));
		}catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("MainEmartActionController::mainpage::Error::"+e.toString().replaceAll("\r|\n", ""));}
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl("/custom/ssg/index");
	}

	@RequestMapping(value="/custom/ssg/loginSSGForm.do")
	public String loginSSGForm(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
	  model=setLoginScrnInfo(model,cmmMap);
	  model.put("screenType", cmmMap.get("screenType"));
	  model.put("mainType", cmmMap.get("mainType"));
	  model.put("srID", cmmMap.get("srID"));
	  model.put("proposal", cmmMap.get("proposal"));
	  model.put("status", cmmMap.get("status"));
	  model.put("emartSSO", cmmMap.get("emartSSO"));
	  model.put("ssoUrl", cmmMap.get("ssoUrl"));
	  model.put("keepLoginYN", StringUtil.checkNull(cmmMap.get("keepLoginYN"),""));
	  return nextUrl("/custom/ssg/login");
	}
	
	private ModelMap setLoginScrnInfo(ModelMap model, HashMap cmmMap) throws Exception {
		  
		  String pass = StringUtil.checkNull(cmmMap.get("pwd"));
		  model.addAttribute("loginid",StringUtil.checkNull(cmmMap.get("userID"), ""));
		  model.addAttribute("pwd",pass);
		  model.addAttribute("lng",StringUtil.checkNull(cmmMap.get("lng"), ""));
		  		  
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

	@RequestMapping(value="/custom/ssg/loginSSG.do")
	public String loginSSG(ModelMap model, HashMap cmmMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
				Map resultMap = new HashMap();
				String langCode = GlobalVal.DEFAULT_LANG_CODE;	
				String languageID = StringUtil.checkNull(cmmMap.get("LANGUAGE"),StringUtil.checkNull(cmmMap.get("LANGUAGEID")) );
				String emartSSO = StringUtil.checkNull(cmmMap.get("emartSSO"));
				
				if(languageID.equals("")){
					languageID = GlobalVal.DEFAULT_LANGUAGE;
				}
			
				cmmMap.put("LANGUAGE", languageID);
//				String ref = request.getHeader("referer");
//				String protocol = request.isSecure() ? "https://" : "http://";
				
				String IS_CHECK = GlobalVal.PWD_CHECK;
//				String url_CHECK = StringUtil.chkURL(ref, protocol);

				if("".equals(IS_CHECK))
					IS_CHECK = "Y";
				
				
//				if("".equals(url_CHECK)) {
//					resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
//					resultMap.put(AJAX_ALERT, "Your ID does not exist in our system. Please contact system administrator.");
//				}
//				else {
					
					cmmMap.put("LOGIN_ID", cmmMap.get("userID"));
					if(!emartSSO.equals("T")) {
						String pwd = (String) cmmMap.get("password");
						//pwd = (String) cmmMap.get("LOGIN_ID") + pwd;						
						//pwd = sha256(pwd);
//						cmmMap.put("PASSWORD", pwd); 
						cmmMap.put("IS_CHECK", "Y");
						
						String item = "PWD" ;
						String encrypt = "" ;
						byte[] errbyte = new byte[5];
						
						CubeOneAPI.coinit("API");
						encrypt = CubeOneAPI.coencchar(pwd,item,11,null,null,errbyte);
						cmmMap.put("PASSWORD", encrypt);
					} else {
						// 인증 객체 선언(Request와 Response 인계)
				        AuthCheck auth = new AuthCheck(request, response);
				        AuthStatus status = auth.checkLogon();
				        // 인증 체크(인증 상태 값 리턴)
				        if (status == AuthStatus.SSOSuccess){ 
				        	cmmMap.remove("LOGIN_ID");
				        	cmmMap.put("LOGIN_ID", StringUtil.checkNull(auth.getUserID()));
				        }
						cmmMap.put("IS_CHECK", "N");
					}
					
					String loginActive = commonService.selectString("login_SQL.login_active_select", cmmMap);
				
					if(loginActive.equals("N")) {
						resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
						//resultMap.put(AJAX_ALERT, "해당아이디가 존재하지 않습니다.");
						resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00002"));				
					}
					else {
						Map loginInfo = commonService.select("login_SQL.login_select", cmmMap);
						cmmMap.put("LOGIN_ID", loginInfo.get("LOGIN_ID")); // parameter LOGIN_ID 는 사번이므로 조회한 LOGINID로 put
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
							loginInfo.put("ACC_MODE", "DEV");
							
							//String returnValue = SessionConfig.getSessionCheck("login_id", StringUtil.checkNull(loginInfo.get("LOGIN_ID")));
									
							////// 중복 로그인 설정 ///////////////////////////////////////////////////////////////////////////////////////////////
							String session_duplicate = GlobalVal.SESSION_DUPLICATE;	
							String returnValue = "";
							String currSessionID = "";
							String browser 	 = "";
							String userAgent = StringUtil.checkNull(request.getHeader("User-Agent"));		
							if(session_duplicate.equals("N")) { // session duplicate check								
								String keepLoginYN = StringUtil.checkNull(request.getParameter("keepLoginYN"));
								if(keepLoginYN.equals("Y")) {
									returnValue = SessionConfig.getSessionCheck("login_id", StringUtil.checkNull(cmmMap.get("userID")),"N","");	
								}else {
									currSessionID = SessionConfig.getSessionIDInfo("login_id", StringUtil.checkNull(cmmMap.get("userID")),"");	
								}
								
								if(userAgent.indexOf("Trident") > -1) {												// IE
									browser = "ie";
								} else if(userAgent.indexOf("Edge") > -1) {											// Edge
									browser = "edge";
								} else if(userAgent.indexOf("Whale") > -1) { 										// Naver Whale
									browser = "whale";
								} else if(userAgent.indexOf("Opera") > -1 || userAgent.indexOf("OPR") > -1) { 		// Opera
									browser = "opera";
								} else if(userAgent.indexOf("Firefox") > -1) { 										 // Firefox
									browser = "firefox";
								} else if(userAgent.indexOf("Safari") > -1 && userAgent.indexOf("Chrome") == -1 ) {	 // Safari
									browser = "safari";		
								} else if(userAgent.indexOf("Chrome") > -1) {										 // Chrome	
									browser = "chrome";
								}
								
							}
							
							HttpSession session = request.getSession(true);
							String sessionBrowser = StringUtil.checkNull(session.getAttribute("sessionBrowser"));
							if(!currSessionID.equals("") && !sessionBrowser.equals(browser)) {
								String loginID = StringUtil.checkNull(cmmMap.get("userID")); 
								String password = StringUtil.checkNull(request.getParameter("password")); 
								String loginIdx = StringUtil.checkNull(request.getParameter("loginIdx"));
								resultMap.put(AJAX_SCRIPT, "parent.fnConfirmDuplicateLogin('"+loginID+"','"+password+"','"+languageID+"','"+loginIdx+"')");
							} else {
								session.setAttribute("login_id", cmmMap.get("userID"));
								session.setAttribute("loginInfo", loginInfo);
								session.setAttribute("sessionBrowser", browser);
							}
						}
					}
					model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx"))); //singleSignOn 구분
					model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType")));
					model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType")));
					model.put("srID", StringUtil.checkNull(cmmMap.get("srID")));
					model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode")));
					model.addAttribute(AJAX_RESULTMAP,resultMap);
//				}
		}
		catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("EmartActionController::loginbase::Error::"+e.toString().replaceAll("\r|\n", ""));}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/logoutSSG.do")
	public void logoutForm(ModelMap model, HashMap cmmMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession(true);
		session.invalidate();
		response.sendRedirect(ssgGlobalVal.SSG_SSO_URL+"/sso/logoutService.do?ssosite=PAL::PAL&returnURL="+GlobalVal.OLM_SERVER_URL+"%2FindexSSG.jsp");
	}
	
	@RequestMapping(value="/zEMT_batchProcessExport.do")
	public String batchProcessExport(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		try{
			
			Map setMap = new HashMap();
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String objType = StringUtil.checkNull(request.getParameter("objType"),"OJ00001");
			String classCode = "CL01005";
			commandMap.put("onlyMap", "N");
						
			setMap.put("itemID", "1");
			setMap.put("classCode", classCode);
			setMap.put("languageID", languageID);
			setMap.put("classCode", classCode);
			setMap.put("batchInterval", 1);
			List itemInfoList = commonService.selectList("report_SQL.getChildItemList", setMap);
			
			commandMap.put("ItemTypeCode", objType);
			Map modelExist = commonService.select("common_SQL.getMDLTypeCode_commonSelect", commandMap);
			model.put("modelExist", modelExist.size());
			
			commandMap.remove("s_itemID");
			String returnValue = "";
			if(itemInfoList.size()>0){
				for(int i=0; i<itemInfoList.size(); i++){
					Map itemInfoMap = (Map)itemInfoList.get(i);
					commandMap.put("s_itemID", itemInfoMap.get("MyItemID"));
					returnValue = setBatchWordReport(request, commandMap, model);
					
					setMap.put("itemId", itemInfoMap.get("MyItemID"));
					setMap.put("fltpCode", "FLTP001");
					setMap.put("searchValue", "프로세스정의서_");
					setMap.put("baseUrl", "");
					setMap.put("itemClassCode", "CL01005");
					List existFile = commonService.selectList("fileMgt_SQL.selectFileList", setMap);
					
					setMap.put("FltpCode", "FLTP001");
					setMap.put("FileName", returnValue);
					setMap.put("LanguageID", String.valueOf(commandMap.get("sessionCurrLangType")));
					if(existFile.size() > 0) {
						setMap.put("Seq", ((Map) existFile.get(0)).get("id"));
						// TB_FILE 데이터 Update
						commonService.update("fileMgt_SQL.itemFile_update",setMap);
					} else {
						int seqCnt = 0;
						seqCnt = Integer.parseInt(commonService.selectString("fileMgt_SQL.itemFile_nextVal", commandMap));
						
						setMap.put("s_itemID", itemInfoMap.get("MyItemID"));
						setMap.put("Seq", seqCnt);
						setMap.put("DocumentID", itemInfoMap.get("MyItemID"));
						setMap.put("DocCategory", "ITM");
						setMap.put("FileRealName", "프로세스정의서_"+ commonService.selectString("report_SQL.getMyIdAndName", setMap) +".docx");
						setMap.put("FilePath", commandMap.get("filePath"));
						setMap.put("FileFormat", "docx");
						setMap.put("userId", String.valueOf(commandMap.get("sessionUserId")));
						
						// TB_FILE 데이터 Insert
						commonService.insert("fileMgt_SQL.itemFile_insert",setMap);
					}
					
				}
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	private String setBatchWordReport(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		String returnValue = "";
		try{
			Map setMap = new HashMap();
			String languageId = String.valueOf(commandMap.get("sessionCurrLangType"));
			String accMode = StringUtil.checkNull(commandMap.get("accMode"),"");
			setMap.put("languageID", languageId);
			setMap.put("langCode", StringUtil.checkNull(commandMap.get("sessionCurrLangCode")).toUpperCase());
			setMap.put("s_itemID", commandMap.get("s_itemID"));
			setMap.put("ArcCode", request.getParameter("ArcCode"));
			setMap.put("rnrOption", request.getParameter("rnrOption"));
			setMap.put("elmClassList", request.getParameter("elmClassList"));
			
			// 파일명에 이용할 Item Name 을 취득
			Map selectedItemMap = commonService.select("report_SQL.getItemInfo", setMap);
			
			/* 첨부 문서 취득 */
			setMap.put("DocumentID", commandMap.get("s_itemID"));
			setMap.put("DocCategory", "ITM");
			// 로그인 언어별 default font 취득
			String defaultFont = commonService.selectString("report_SQL.getDefaultFont", setMap);			
			
			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", commandMap);			
			List modelList = new ArrayList();
			List totalList = new ArrayList();
			
			List allTotalList = new ArrayList();
			Map allTotalMap = new HashMap();
			Map titleItemMap = new HashMap();
			String selectedItemPath = "";
			
			Map gItem = new HashMap();			// L2
			List pItemList = new ArrayList();			// L3
			List mainItemList = new ArrayList();	// L4
			
			setMap.put("classCode", commandMap.get("classCode"));
			
			// 선택된 Item의 Path취득 (Id + Name)
			selectedItemPath= selectedItemMap.get("Identifier")+" "+selectedItemMap.get("ItemName");
			model.put("gItem", gItem);
			model.put("pItemList", pItemList);
			model.put("mainItemList", mainItemList);
			
			setMap.put("ClassCode", commandMap.get("classCode"));
			
			// 해당 아이템의 하위 항목의 서브프로세스 수 만큼 word report 작성
			getItemTotalInfo(totalList, setMap, request, commandMap, defaultLang, languageId, accMode);
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
			model.put("selectedItemPath", selectedItemPath);
			String itemNameofFileNm = StringUtil.checkNull(selectedItemMap.get("ItemName")).replace("&#xa;", "");
			model.put("ItemNameOfFileNm", URLEncoder.encode(itemNameofFileNm, "UTF-8").replace("+", "%20"));
			model.put("ItemNameOfFileNm", itemNameofFileNm);
			model.put("selectedItemIdentifier", StringUtil.checkNull(selectedItemMap.get("Identifier")));
			model.put("outputType", request.getParameter("outputType"));  
			model.put("selectedItemMap", selectedItemMap);
//			
			setMap.put("teamID", StringUtil.checkNull(selectedItemMap.get("OwnerTeamID")));
			Map managerInfo = commonService.select("user_SQL.getUserTeamManagerInfo", setMap);
			model.put("ownerTeamMngNM",managerInfo.get("MemberName"));	// 프로세스 책임자
			model.put("reportCode", StringUtil.checkNull(request.getParameter("reportCode"), ""));
			
			setMap.put("languageID", languageId);
			String extLangCode = StringUtil.checkNull(commonService.selectString("common_SQL.getLanguageExtCode",setMap));
			commandMap.put("extLangCode", extLangCode);
			returnValue = makeWordReport(commandMap,model);
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // DB에 생성된 모델이 없습니다.
			target.put(AJAX_SCRIPT, "parent.afterWordReport();parent.$('#isSubmit').remove();");
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		return returnValue;
	}
	
	public void getItemTotalInfo(List totalList, Map setMap, HttpServletRequest request, HashMap commandMap, String defaultLang, String languageId, String accMode) throws Exception {
//		for (int index = 0; modelList.size() > index; index++) {
			Map map = new HashMap();
			Map totalMap = new HashMap();
//			Map subProcessMap = (Map) modelList.get(index);
			
			List cngtList = new ArrayList(); // 변경이력 리스트
			List detailElementList = new ArrayList(); // 연관 프로세스 리스트
			List relItemList = new ArrayList(); // 연관 항목 리스트
			List dimResultList = new ArrayList(); // 디멘션 정보
			List attachFileList = new ArrayList();	//첨부문서 리스트
			List roleList = new ArrayList();	//관련조직 리스트
			List rnrList = new ArrayList();	//rnr 리스트
			List elmObjList = new ArrayList();		// OJ, MOJ 엘리먼트 리스트
			
			setMap.put("s_itemID", commandMap.get("s_itemID"));
			setMap.put("itemId", String.valueOf(commandMap.get("s_itemID")));
			setMap.put("sessionCurrLangType", String.valueOf(commandMap.get("sessionCurrLangType")));
			setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
			setMap.put("attrTypeCode", commandMap.get("attrTypeCode"));
			
			// Model 정보 취득 
			setMap.remove("ModelTypeCode");
			Map modelMap = new HashMap();
			if (!"0".equals(StringUtil.checkNull(commandMap.get("modelExist")))) {
				setMap.put("MTCategory", request.getParameter("MTCategory"));
				modelMap = commonService.select("report_SQL.getModelIdAndSize", setMap);
				
				// 모델이 DB에 존재 하는 경우, 문서에 표시할 모델 맵 크기를 계산 한다
				// 모델이 DB에 존재 하는 경우, [TB_ELEMENT]에서 선행 /후행 데이터 취득
				if (null != modelMap) {
					setModelMap(modelMap, request);
					Map setMap2 = new HashMap();
					setMap2.put("languageID", languageId);
					// [TB_ELEMENT]에서 선행 /후행 데이터 취득 
					detailElementList = getElementList(setMap2, modelMap);
				}
			}
			
			List attrList = new ArrayList();
			/* 기본정보 취득 */
			List prcList = commonService.selectList("report_SQL.getItemInfo", setMap);
			setMap.put("changeSetID",modelMap.get("ChangeSetID"));
			
			if(accMode.equals("OPS") || accMode.equals("")) {
				prcList = commonService.selectList("item_SQL.getItemAttrRevInfo", setMap);
				attrList = commonService.selectList("item_SQL.getItemRevDetailInfo", setMap);
			} else {
				attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
			}
			
			setMap.put("changeSetID",modelMap.get("ChangeSetID"));
			Map csInfo = commonService.select("cs_SQL.getChangeSetInfo", setMap);
			totalMap.put("csAuthorNM",csInfo.get("AuthorName"));
			totalMap.put("csOwnerTeamNM",csInfo.get("TeamName"));
			
			//=====================================================================================================
			/* 기본정보의 속성 내용을 취득 */
			commandMap.put("ItemID", commandMap.get("s_itemID"));
			commandMap.put("DefaultLang", defaultLang);
			
			List activityList = new ArrayList();
			if ("N".equals(StringUtil.checkNull(commandMap.get("onlyMap")))) {
				attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
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

				// Dimension정보 취득 
				List dimInfoList = commonService.selectList("dim_SQL.selectDim_gridList", setMap);
				Map dimResultMap = new HashMap();
				String dimTypeName = "";
				String dimValueNames = "";
				
				if (dimInfoList.size() > 0) {
					for(int i = 0; i < dimInfoList.size(); i++){
						map = (HashMap)dimInfoList.get(i);
						if (i > 0) {
							if(dimTypeName.equals(map.get("DimTypeName").toString())) {
								dimValueNames += " / "+map.get("DimValueName").toString();
							} else {
								dimResultMap.put("dimValueNames", dimValueNames);
								dimResultList.add(dimResultMap);
								dimResultMap = new HashMap(); // 초기화
								dimTypeName = map.get("DimTypeName").toString();
								dimResultMap.put("dimTypeName", dimTypeName);
								dimValueNames = map.get("DimValueName").toString();
							}
						}else{
							dimTypeName = map.get("DimTypeName").toString();
							dimResultMap.put("dimTypeName", dimTypeName);
							dimValueNames = map.get("DimValueName").toString();
						}
					}
				
					dimResultMap.put("dimValueNames", dimValueNames);
					dimResultList.add(dimResultMap);
				}

				Map AttrTypeList = new HashMap();
				// 관련항목 취득 
				relItemList = commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);
				
				List impl = new ArrayList();
				List relItemID = new ArrayList();
				
				for(int j=0; j<relItemList.size(); j++){
					map = (Map) relItemList.get(j);
					impl.add(map.get("ClassCode"));
					relItemID.add(map.get("s_itemID"));
				}
				// 중복제거
				TreeSet relItemClassCode = new TreeSet(impl);
				ArrayList relItemClassCodeList = new ArrayList(relItemClassCode);
				
				// 관련항목 이름 취득
				List relItemNameList = new ArrayList();
				for(int j=0; j<relItemClassCodeList.size(); j++){
					setMap.put("typeCode", relItemClassCodeList.get(j));
					String cnName = commonService.selectString("common_SQL.getNameFromDic", setMap);
					relItemNameList.add(cnName);
				}
				
				// 관련항목 속성 조회
				List relItemAttrbyID = new ArrayList();
				for(int j=0; j<relItemID.size(); j++){
					setMap.put("itemID", relItemID.get(j));
					List temp = commonService.selectList("report_SQL.getItemAttr", setMap);
					relItemAttrbyID.addAll(temp);
				}
				
				totalMap.put("relItemClassCodeList",relItemClassCodeList);
				totalMap.put("relItemNameList", relItemNameList);
				totalMap.put("relItemID", relItemID);
				totalMap.put("relItemAttrbyID", relItemAttrbyID);
					
				List temp = commonService.selectList("attr_SQL.getItemAttrType", setMap);
				Map AttrTypeListTemp = new HashMap();

				for(int j=0; j<temp.size(); j++){
					AttrTypeListTemp = (Map) temp.get(j);
					AttrTypeList.put(AttrTypeListTemp.get("AttrTypeCode"), AttrTypeListTemp.get("DataType"));
				}
				
				totalMap.put("AttrTypeList", AttrTypeList);
				
				// Activity 정보 취득 
				setMap.put("viewType", "wordReport");
				setMap.put("gubun", "M");
				if ("Y".equals(StringUtil.checkNull(commandMap.get("element")))) {
					setMap.remove("gubun");
				}
				activityList = commonService.selectList("item_SQL.getSubItemList_gridList", setMap);
				
				activityList = getActivityAttr(activityList, defaultLang ,languageId, attrNameMap, attrHtmlMap); // 액티비티의 속성을 액티비티 리스트에 추가

				// Activity 속성명 모두 취득 ( ex) AT00005:수행부서, AT00006:수행주체, AT00013:사용시스템 )
				List activityNames = commonService.selectList("report_SQL.getActivityAttrName", commandMap);
				for (int k = 0; activityNames.size()>k ; k++ ) {
					map = (Map) activityNames.get(k);
					attrNameMap.put(map.get("AttrTypeCode"), map.get("Name"));
				}
				
				totalMap.put("attrMap", attrMap);
				totalMap.put("attrNameMap", attrNameMap);
				totalMap.put("attrHtmlMap", attrHtmlMap);
				
				// 첨부 문서 취득 
				setMap.remove("itemTypeCode");
				setMap.put("DocumentID", String.valueOf(commandMap.get("s_itemID")));
				attachFileList = commonService.selectList("fileMgt_SQL.getFile_gridList", setMap);
				
				setMap.put("refModelID", modelMap.get("ModelID"));
				elmObjList = commonService.selectList("model_SQL.getElmtsObjectList_gridList", setMap);
				elmObjList = getActivityAttr(elmObjList, defaultLang ,languageId, attrNameMap, attrHtmlMap);
			}
			
			totalMap.put("prcList", prcList);								// 기본정보
			totalMap.put("modelMap", modelMap);				// 업무처리 절차
			totalMap.put("dimResultList", dimResultList);	// 기본정보(Dimension)
			totalMap.put("cngtList", cngtList);							// 변경이력
			totalMap.put("elementList", detailElementList);	// 선/후행 Process
			totalMap.put("relItemList", relItemList);				// 관련항목
			totalMap.put("attachFileList", attachFileList);		// 첨부문서 목록
			totalMap.put("roleList", roleList);							// 관련조직 목록
			totalMap.put("activityList", activityList);				// 액티비티 목록
			totalMap.put("rnrList", rnrList);								// R&R 목록
			totalMap.put("elmObjList", elmObjList);				// 엘리먼트 OJ, MOJ 목록
			totalList.add(0, totalMap);
//		}
	}
	
	public void setModelMap(Map modelMap, HttpServletRequest request) {
		// model size 조정
		int width = 546;
		int height = 655;
		int actualWidth = 0;
		int actualHeight = 0;
		int zoom = 100;
		
		/* 문서에 표시할 모델 맵 크기를 계산 한다 */
		if ("2".equals(request.getParameter("paperSize"))) {
			width = 700;
			height = 967;
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
	
	private List getActivityAttr(List List, String defaultLang, String sessionCurrLangType,Map attrNameMap, Map attrHtmlMap) throws Exception {
		List resultList = new ArrayList();
		Map setMap = new HashMap();
		List actToCheckList = new ArrayList();
		List actRuleSetList = new ArrayList();
		List actSystemList = new ArrayList();
		List actRoleList = new ArrayList();
				
		for (int i = 0; i < List.size(); i++) {
			Map listMap = new HashMap();
			listMap = (Map) List.get(i);
			String itemId = String.valueOf(listMap.get("ItemID"));
			
			setMap.put("ItemID", itemId);
			setMap.put("DefaultLang", defaultLang);
			setMap.put("sessionCurrLangType", sessionCurrLangType);
			
			List attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
			
			for (int k = 0; attrList.size()>k ; k++ ) {
				Map map = (Map) attrList.get(k);
				if(StringUtil.checkNull(map.get("HTML"),"").equals("1")) {
					listMap.put(map.get("AttrTypeCode"), StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(map.get("PlainText"))));
				} else {
					listMap.put(map.get("AttrTypeCode"), map.get("PlainText"));
				}
				
			}
			
			setMap.put("languageID", sessionCurrLangType);
			//System 취득 
			setMap.put("CURRENT_ITEM", itemId); // 해당 아이템이 [ToItemID]인것
			setMap.put("itemTypeCode", "CN00104");			
			actSystemList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
			// Activity system list의 연관 프로세스 && 속성 정보 취득 
			actSystemList = getConItemInfo(actSystemList, defaultLang, sessionCurrLangType, attrNameMap, attrHtmlMap, "CN00104", "ToItemID");
			listMap.put("actSystemList", actSystemList);
			setMap.remove("CURRENT_ITEM");
			
			// Role 취득 
			setMap.put("CURRENT_ToItemID", itemId); 
			setMap.put("itemTypeCode", "CN00201");			
			actRoleList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
			// Activity Role list의 연관 프로세스 && 속성 정보 취득 
			actRoleList = getConItemInfo(actRoleList, defaultLang, sessionCurrLangType, attrNameMap, attrHtmlMap, "CN00201", "FromItemID");
			listMap.put("actRoleList", actRoleList);
			setMap.remove("CURRENT_ToItemID");
			
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
//	            List cnItemList = commonService.selectList("item_SQL.getCXNItems", setMap);
        
//	            for (int k = 0; cnItemList.size()>k ; k++ ) {
//	                Map map = (Map) cnItemList.get(k);
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
//	            }
            listMap.put("resultSubList", resultSubList);        
            
            resultList.add(listMap);
        }
        
        return resultList;
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
		
	private String removeAllTag(String str) {
		str = str.replaceAll("\n", "&&rn");//201610 new line :: Excel To DB 
		str = str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#10;", " ").replace("&#xa;", "").replace("&nbsp;", " ");
		//return str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#10;", " ").replace("&#xa;", "").replace("&nbsp;", " ");
		return StringEscapeUtils.unescapeHtml4(str);
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
		
	public static String makeWordReport(HashMap commandMap, ModelMap model) {
		String returnValue = "";
		try{
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
			long date = System.currentTimeMillis();
			
			String LogoImgUrl = "";
			String modelImgPath = GlobalVal.MODELING_DIGM_DIR;
			String logoPath = GlobalVal.FILE_UPLOAD_TINY_DIR;
			String defaultFont = String.valueOf(model.get("defaultFont"));
		 	
			License license = new License();
			license.setLicense(logoPath + "Aspose.Words.lic");
			
			Document doc = new Document();
			DocumentBuilder builder = new DocumentBuilder(doc);	
			
			Map menu = (Map)model.get("menu");
		 	Map setMap = (HashMap)model.get("setMap");
		 	List allTotalList = (List)model.get("allTotalList");
		 	
		 	String onlyMap = String.valueOf(model.get("onlyMap"));
		 	String paperSize = String.valueOf(model.get("paperSize"));
		 	String itemNameOfFileNm = String.valueOf(model.get("ItemNameOfFileNm"));
		 	String outputType = String.valueOf(model.get("outputType"));
		 	
		 	String selectedItemPath = String.valueOf(model.get("selectedItemPath"));
		 	String reportCode = String.valueOf(model.get("reportCode"));
		 	
		 	Map selectedItemMap = (Map)model.get("selectedItemMap");
		 	
		 	double titleCellWidth = 170.0;
		 	double titleCellWidth2 = 95.0;
		 	double contentCellWidth3 = 95.0;
			double contentCellWidth = 350.0;
			double contentCellWidth2 = 220.0;
			double mergeCellWidth = 500.0;
			double totalCellWidth = 560.0;
			String value = "";
			String name = "";
			String fontFamilyHtml = "<span style=\"font-family:"+defaultFont+"; font-size: 10pt;\">";
		//==================================================================================================
			Section currentSection = builder.getCurrentSection();
		    PageSetup pageSetup = currentSection.getPageSetup();
		    
		    // page 여백 설정
			builder.getPageSetup().setRightMargin(30);
			builder.getPageSetup().setLeftMargin(30);
			builder.getPageSetup().setBottomMargin(30);
			builder.getPageSetup().setTopMargin(30);
			
			builder.getPageSetup().setPaperSize(PaperSize.A4);
		//==================================================================================================

		//=========================================================================
			//footer
			currentSection = builder.getCurrentSection();
		    pageSetup = currentSection.getPageSetup();
		    
		    pageSetup.setDifferentFirstPageHeaderFooter(false);
		    pageSetup.setFooterDistance(25);
		    builder.moveToHeaderFooter(HeaderFooterType.FOOTER_PRIMARY);
		    
		    builder.startTable();
		    builder.getCellFormat().getBorders().setLineWidth(0.0);
		    builder.getFont().setName(defaultFont);
		    builder.getFont().setColor(Color.BLACK);
		    builder.getFont().setSize(10);
		    
		 	// 1.footer : Line
		 	builder.getParagraphFormat().setSpaceBefore(7);
		    builder.insertHtml("<hr size=5 color='silver'/>");
		 	// 2.footer : logo
		    builder.insertCell();
			builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(100 / 3));
		    String imageFileName = logoPath + "logo_emart.png";
		    builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			builder.write(formatter.format(date)); //하단
		 	// 3.footer : current page / total page
		    builder.insertCell();
		    builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(100 / 3));
		    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		    builder.insertField("PAGE", "");
		    builder.write(" / ");
		    builder.insertField("NUMPAGES", "");
		    
		    builder.insertCell();
			builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(100 / 3));
		 	builder.getParagraphFormat().setAlignment(ParagraphAlignment.RIGHT);
			builder.write(""); //하단
		    
		 	// 4.footer : current page / total page 
		    builder.insertCell();
			builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(100 / 3));
		    builder.getParagraphFormat().setAlignment(ParagraphAlignment.RIGHT);
		    
		    builder.endTable().setAllowAutoFit(false);
		        
		    builder.moveToDocumentEnd();
		//=========================================================================
			
			builder = new DocumentBuilder(doc);
			
			//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			for (int totalCnt = 0;allTotalList.size() > totalCnt ; totalCnt++ ) {
				Map allTotalMap = (Map)allTotalList.get(totalCnt);
				Map titleItemMap = new HashMap();
				List totalList = (List)allTotalMap.get("totalList");
				titleItemMap = (Map)allTotalMap.get("titleItemMap");
				
				//==================================================================================================
				/* 표지 */
				//if (totalList.size() > 0) { 
					currentSection = builder.getCurrentSection();
				    pageSetup = currentSection.getPageSetup();
				    pageSetup.setDifferentFirstPageHeaderFooter(true);
				   // pageSetup.setD
				 	// 표지 START
				 	builder.startTable();
				 	builder.getCellFormat().getBorders().setLineWidth(0.0);
				 	
				 	// 1.image
				 	builder.insertCell();
		    		builder.getCellFormat().setWidth(totalCellWidth);
				 	builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	builder.insertHtml("<br>");
		    		builder.insertHtml("<br>");
		    		builder.endRow();
		    		
		    		// 2.프로세스 정의서
		    		builder.insertCell();
		    		builder.getFont().setColor(Color.BLACK);
				    builder.getFont().setBold(true);
				    builder.getFont().setName(defaultFont);
				    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
				    builder.getFont().setSize(60);
				    builder.insertHtml("<br>");
				    builder.getFont().setSize(36);
				    builder.writeln("프로세스 정의서");
					builder.endRow();
					
					// 3.선택한 프로세스 정보
		    		builder.insertCell();
		    		builder.getFont().setColor(Color.BLACK);
				    builder.getFont().setBold(true);
				    builder.getFont().setName(defaultFont);
				    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
				    builder.getFont().setSize(26);
				    builder.getFont().setUnderline(0);
					builder.writeln("[ "+selectedItemPath+" ]");
					builder.insertHtml("<br>");
		    		builder.insertHtml("<br>");
		    		builder.insertHtml("<br>");
					builder.endRow();
		    		
		    		// 4.선택한 프로세스 정보 테이블
		    		///////////////////////////////////////////////////////////////////////////////////////
		    		//builder.insertCell();
		    		//builder.getCellFormat().setWidth(30); // 테이블 앞 여백 설정
		    		
					builder.insertCell();
		    		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		    		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		    		builder.getCellFormat().setWidth(totalCellWidth);
		    		
		    		builder.startTable();
					builder.getRowFormat().clearFormatting();
					builder.getCellFormat().clearFormatting();
					
					// Make the header row.
					builder.insertCell();
					builder.getRowFormat().setHeight(30.0);
					builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
					
					// Some special features for the header row.
					builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(247, 247, 247));
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					builder.getFont().setSize(11);
					builder.getFont().setUnderline(0);
					builder.getFont().setBold(false);
					builder.getFont().setColor(Color.BLACK);
					builder.getFont().setName(defaultFont);
					
					builder.getCellFormat().setWidth(120);
					builder.getCellFormat().setHorizontalMerge(CellMerge.FIRST);
					//builder.write(String.valueOf(menu.get("LN00060"))); // 작성자
					builder.write("Process Owner"); // 작성자

					builder.insertCell();
					builder.getCellFormat().setWidth(200);
					//builder.write(String.valueOf(menu.get("LN00131"))); // 프로젝트
					builder.write(String.valueOf(menu.get("LN00018"))); // 관리조직

					builder.insertCell();
					builder.getCellFormat().setWidth(100);
					builder.write(String.valueOf(menu.get("LN00013"))); // 생성일
					
					builder.endRow();
					
					// Set features for the other rows and cells.
					builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					
					// Reset height and define a different height rule for table body
					builder.getRowFormat().setHeight(30.0);
					builder.getRowFormat().setHeightRule(HeightRule.AUTO);
					
					builder.insertCell();
				   	builder.getCellFormat().setWidth(120);
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.write(StringUtil.checkNullToBlank(titleItemMap.get("Name")));
					
					builder.insertCell();
				   	builder.getCellFormat().setWidth(200);
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.write(StringUtil.checkNullToBlank(titleItemMap.get("TeamName")));
					builder.insertCell();
				   	builder.getCellFormat().setWidth(100);
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.write(StringUtil.checkNullToBlank(titleItemMap.get("CreateDT")));	
					builder.endRow();
					builder.endTable().setAlignment(TabAlignment.CENTER);
					builder.endRow();
					
					builder.endTable().setAllowAutoFit(false);
		    		///////////////////////////////////////////////////////////////////////////////////////
		    		// 표지 END
					builder.insertBreak(BreakType.PAGE_BREAK);
					// content END

				//==================================================================================================
				
				if (totalList.size() > 0) { 
				 	for (int index = 0; totalList.size() > index ; index++) {
				 		
				 		if (totalList.size() != 1) {
				 			builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
				 		}
				 		
				 		Map totalMap = (Map)totalList.get(index);
				 		
				 		List prcList = (List)totalMap.get("prcList");
				 		Map rowPrcData =  (HashMap) prcList.get(0); 
				 		List activityList = (List)totalMap.get("activityList");
				 		List elementList = (List)totalMap.get("elementList");
				 		List relItemList = (List)totalMap.get("relItemList");
				 		List dimResultList = (List)totalMap.get("dimResultList");
				 		Map attrMap = (Map)totalMap.get("attrMap");
				 		Map attrHtmlMap = (Map)totalMap.get("attrHtmlMap");
				 		Map modelMap = (Map)totalMap.get("modelMap");
			 	 		Map AttrTypeList = (Map)totalMap.get("AttrTypeList");
				 		Map map = new HashMap();
				 		
				 		currentSection = builder.getCurrentSection();
				 	    pageSetup = currentSection.getPageSetup();
				 	    
				 	    pageSetup.setDifferentFirstPageHeaderFooter(false);
				 	    pageSetup.setHeaderDistance(25);
				 	    builder.moveToHeaderFooter(HeaderFooterType.HEADER_PRIMARY);
				 	    
				 	    //==================================================================================================
				 		// NEW 머릿글 : START
				 	    builder.startTable();
						builder.getRowFormat().clearFormatting();
						builder.getCellFormat().clearFormatting();
						
						// Make the header row.
						builder.insertCell();
						builder.getCellFormat().setWidth(totalCellWidth);
						builder.getRowFormat().setHeight(26.0);
						// builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
						builder.getRowFormat().setHeightRule(HeightRule.AUTO);
						
						// Some special features for the header row.
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
						builder.getFont().setSize(14);
						builder.getFont().setUnderline(0);
						builder.getFont().setBold(true);
						builder.getFont().setColor(Color.BLACK);
						builder.getFont().setName(defaultFont);
						
						builder.getCellFormat().setWidth(140);
						builder.getCellFormat().setVerticalMerge(CellMerge.FIRST);
						//builder.insertCell();
			    		builder.insertImage(imageFileName, 85, 20);

						builder.insertCell();
						builder.getCellFormat().setWidth(420);
						name = StringUtil.checkNullToBlank(rowPrcData.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
				 	   	name = name.replace("&#10;", " ");
				 	   	name = name.replace("&#xa;", "");
				 	    name = name.replace("&nbsp;", " ");
				 	    builder.write("Process & System User Manual");
						
						builder.endRow();
						
						// Set features for the other rows and cells.
						builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
						builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
						builder.getFont().setSize(11);
						builder.getFont().setUnderline(0);
						builder.getFont().setBold(false);
						
						// Reset height and define a different height rule for table body
						builder.getRowFormat().setHeight(30.0);
						builder.getRowFormat().setHeightRule(HeightRule.AUTO);
						
					    builder.insertCell(); 	
					    builder.getCellFormat().setWidth(140);
						builder.getCellFormat().setVerticalMerge(CellMerge.PREVIOUS);
						
						builder.insertCell();
					   	builder.getCellFormat().setWidth(180);builder.getCellFormat().setVerticalMerge(CellMerge.NONE);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.write(rowPrcData.get("Identifier") + " "+ name);  
			    		
						builder.insertCell();
					   	builder.getCellFormat().setWidth(240);builder.getCellFormat().setVerticalMerge(CellMerge.NONE);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.write(StringUtil.checkNullToBlank(rowPrcData.get("Path")));
						builder.endRow();
						
						builder.endTable().setAllowAutoFit(false);
						 // 타이틀과 내용 사이 간격
				 	    builder.insertHtml("<hr size=4 color='silver'/>");
				 	 	// 머릿말 : END
				 	 	builder.moveToDocumentEnd();
				 	  	//==================================================================================================
				 	  		
				 		// 아이템 속성 		
//				 		if ("N".equals(onlyMap)) {
				 			// 프로세스 기본 정보 Title
				 	 		builder.getFont().setColor(Color.BLACK);
						    builder.getFont().setSize(11);
						    builder.getFont().setBold(true);
						    builder.getFont().setName(defaultFont);
							builder.writeln("1. " + String.valueOf(menu.get("LN00005")));
							
				 			builder.startTable();
				 	 		
				 	 	    builder.getFont().setName(defaultFont);
				 	 	    builder.getFont().setColor(Color.BLACK);
				 	 	    builder.getFont().setSize(10);
				 	 		
				 	 		// Make the header row.
				 	 		builder.getRowFormat().clearFormatting();
				 	 		builder.getCellFormat().clearFormatting();
				 	 		builder.getRowFormat().setHeight(30.0);
				 	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO);
				 	 		
				 	 		builder.insertCell();	
				 	 		//==================================================================================================	
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
				 	 		builder.getCellFormat().setWidth(titleCellWidth2);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold(true);
				 	 		builder.write("업태(Division)");
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getFont().setBold(false);
				 	 		builder.getCellFormat().setWidth(contentCellWidth2);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.write("");
				 	 		for(int j=0; j<dimResultList.size(); j++){
				 	 			Map dimResultMap = (Map) dimResultList.get(j);
				 	 			if(dimResultMap.get("dimTypeName").equals("Division")) builder.write(String.valueOf(dimResultMap.get("dimValueNames")));
				 	 		}
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
				 	 		builder.getCellFormat().setWidth(titleCellWidth2);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold(true);
				 	 		builder.write("Center");
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getFont().setBold(false);
				 	 		builder.getCellFormat().setWidth(contentCellWidth2);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.write("");
				 	 		for(int j=0; j<dimResultList.size(); j++){
				 	 			Map dimResultMap = (Map) dimResultList.get(j);
				 	 			if(dimResultMap.get("dimTypeName").equals("Center")) builder.write(String.valueOf(dimResultMap.get("dimValueNames")));
				 	 		}
				 	 		//==================================================================================================	
				 	 		builder.endRow();
				 	 		
				 	 		builder.insertCell();	
				 	 		//==================================================================================================	
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
				 	 		builder.getCellFormat().setWidth(titleCellWidth2);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold(true);
				 	 		builder.write("Category");
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getFont().setBold(false);
				 	 		builder.getCellFormat().setWidth(contentCellWidth2);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.write("");
				 	 		for(int j=0; j<dimResultList.size(); j++){
				 	 			Map dimResultMap = (Map) dimResultList.get(j);
				 	 			if(dimResultMap.get("dimTypeName").equals("Category")) builder.write(String.valueOf(dimResultMap.get("dimValueNames")));
				 	 		}
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
				 	 		builder.getCellFormat().setWidth(titleCellWidth2);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold(true);
				 	 		builder.write(String.valueOf(AttrTypeList.get("AT00007")));
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getFont().setBold(false);
				 	 		builder.getCellFormat().setWidth(contentCellWidth2);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00007")));
				 	 		//==================================================================================================	
				 	 		builder.endRow();
				 	 		
				 	 	// 1.ROW : 개요	 	 	 	
				 	 		builder.insertCell();
				 	 		//==================================================================================================	
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
				 	 		builder.getCellFormat().setWidth(titleCellWidth2);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold(true);
				 	 		builder.write(String.valueOf(AttrTypeList.get("AT00003")));  // 개요
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getCellFormat().setWidth(totalCellWidth);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		
				 	 		String AT00003 = StringUtil.checkNullToBlank(attrMap.get("AT00003")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
				 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00003")))) { // type이 HTML인 경우
				 	 			if(StringUtil.checkNullToBlank(attrMap.get("AT00003")).contains("font-family")){
				 	 				builder.insertHtml(AT00003);
				 	 			}else{
				 	 				builder.insertHtml(fontFamilyHtml+AT00003+"</span>");
				 	 			}
				 	 		} else {
				 	 			builder.getFont().setBold(false);
				 	 			builder.write(AT00003); // 개요 : 내용
				 	 		}
				 	 		//==================================================================================================	
				 	 		builder.endRow();
				 	 			 	 		
				 	 		// 3.ROW : Input,Output
				 	 		builder.insertCell();
				 	 		//==================================================================================================	
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
				 	 		builder.getCellFormat().setWidth(titleCellWidth2);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold(true);
				 	 		builder.write(String.valueOf(AttrTypeList.get("AT00015")));  // Input
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getCellFormat().setWidth(contentCellWidth2);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		
				 	 		String AT00015 = StringUtil.checkNullToBlank(attrMap.get("AT00015")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
				 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00015")))) { // type이 HTML인 경우
				 	 			if(StringUtil.checkNullToBlank(attrMap.get("AT00015")).contains("font-family")){
				 	 				builder.insertHtml(AT00015);
				 	 			}else{
				 	 				builder.insertHtml(fontFamilyHtml+AT00015+"</span>");
				 	 			}
				 	 		} else {
				 	 			builder.getFont().setBold(false);
				 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00015"))); // Input : 내용
				 	 		}
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
				 	 		builder.getCellFormat().setWidth(titleCellWidth2);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold(true);
				 	 		builder.write(String.valueOf(AttrTypeList.get("AT00016")));  // Output
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getCellFormat().setWidth(contentCellWidth2);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		
				 	 		String AT00016 = StringUtil.checkNullToBlank(attrMap.get("AT00016")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
				 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00016")))) { // type이 HTML인 경우
				 	 			if(StringUtil.checkNullToBlank(attrMap.get("AT00016")).contains("font-family")){
				 	 				builder.insertHtml(AT00016);
				 	 			}else{
				 	 				builder.insertHtml(fontFamilyHtml+AT00016+"</span>");
				 	 			}
				 	 		} else {
				 	 			builder.getFont().setBold(false);
				 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00016"))); // Output : 내용
				 	 		}
				 	 		//==================================================================================================	
				 	 		builder.endRow();
				 	 			 	 	
				 	 		// 5.ROW 	
				 	 		builder.insertCell();
				 	 		//==================================================================================================	
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
				 	 		builder.getCellFormat().setWidth(titleCellWidth2);
				 	 		builder.getRowFormat().setHeight(30.0);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold(true);
				 	 		builder.write(String.valueOf(AttrTypeList.get("AT00042")));
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getCellFormat().setWidth(contentCellWidth2);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.getFont().setBold(false);
				 	 		String AT00042 = StringUtil.checkNullToBlank(attrMap.get("AT00042")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
				 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00042")))) { // type이 HTML인 경우
				 	 			if(StringUtil.checkNullToBlank(attrMap.get("AT00042")).contains("font-family")){
				 	 				builder.insertHtml(AT00042);
				 	 			}else{
				 	 				builder.insertHtml(fontFamilyHtml+AT00042+"</span>");
				 	 			}
				 	 		} else {
				 	 			builder.getFont().setBold(false);
				 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00042")));
				 	 		}
				 	 		//==================================================================================================	
				 	 		builder.endRow();
				 	 		builder.endTable().setAllowAutoFit(false);
				 	 		builder.insertHtml("<br>");
				 	 		
				 	 		
				 	 		builder.startTable();			
							builder.getRowFormat().clearFormatting();
							// Make the header row.
							builder.insertCell();
							builder.getRowFormat().setHeight(20.0);
							builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
							
							// Some special features for the header row.
							builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
							builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
							builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
							builder.getFont().setSize(10);
							builder.getFont().setBold (true);
							builder.getFont().setColor(Color.BLACK);
							builder.getFont().setName(defaultFont);				
							
							builder.getCellFormat().setWidth(100);
							builder.write("업태구분");

							builder.insertCell();
							builder.getCellFormat().setWidth(250);
							builder.write("프로세스 오너");

							builder.insertCell();
							builder.getCellFormat().setWidth(150);
							builder.write("주관부서");
							
							builder.insertCell();
							builder.getCellFormat().setWidth(250);
							builder.write("관련부서");
							builder.endRow();	
							
							builder.getFont().setBold (false);				
							builder.insertCell();
							builder.getCellFormat().setWidth(100);
							builder.write("이마트");
							
							// Set features for the other rows and cells.
							builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
							builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
							
							// Reset height and define a different height rule for table body
							builder.getRowFormat().setHeight(30.0);
							builder.getRowFormat().setHeightRule(HeightRule.AUTO);
									
							builder.insertCell();
							builder.getCellFormat().setWidth(250);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0001")));

							builder.insertCell();
							builder.getCellFormat().setWidth(150);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0002")));
							
							builder.insertCell();
							builder.getCellFormat().setWidth(250);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0003")));
							builder.endRow();	
							
							
							builder.insertCell();
							builder.getCellFormat().setWidth(100);
							builder.write("노브랜드");
							
							// Set features for the other rows and cells.
							builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
							builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
							
							// Reset height and define a different height rule for table body
							builder.getRowFormat().setHeight(30.0);
							builder.getRowFormat().setHeightRule(HeightRule.AUTO);
									
							builder.insertCell();
							builder.getCellFormat().setWidth(250);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0004")));

							builder.insertCell();
							builder.getCellFormat().setWidth(150);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0005")));
							
							builder.insertCell();
							builder.getCellFormat().setWidth(250);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0006")));
							builder.endRow();
							
							builder.insertCell();
							builder.getCellFormat().setWidth(100);
							builder.write("트레이더스");
							
							// Set features for the other rows and cells.
							builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
							builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
							
							// Reset height and define a different height rule for table body
							builder.getRowFormat().setHeight(30.0);
							builder.getRowFormat().setHeightRule(HeightRule.AUTO);
									
							builder.insertCell();
							builder.getCellFormat().setWidth(250);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0007")));

							builder.insertCell();
							builder.getCellFormat().setWidth(150);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0008")));
							
							builder.insertCell();
							builder.getCellFormat().setWidth(250);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0009")));
							builder.endRow();
							
							builder.insertCell();
							builder.getCellFormat().setWidth(100);
							builder.write("SSG푸드마켓");
							
							// Set features for the other rows and cells.
							builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
							builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
							
							// Reset height and define a different height rule for table body
							builder.getRowFormat().setHeight(30.0);
							builder.getRowFormat().setHeightRule(HeightRule.AUTO);
									
							builder.insertCell();
							builder.getCellFormat().setWidth(250);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0010")));

							builder.insertCell();
							builder.getCellFormat().setWidth(150);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0011")));
							
							builder.insertCell();
							builder.getCellFormat().setWidth(250);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0012")));
							builder.endRow();
				 	 		
							builder.insertCell();
							builder.getCellFormat().setWidth(100);
							builder.write("전문점");
							
							// Set features for the other rows and cells.
							builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
							builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
							
							// Reset height and define a different height rule for table body
							builder.getRowFormat().setHeight(30.0);
							builder.getRowFormat().setHeightRule(HeightRule.AUTO);
									
							builder.insertCell();
							builder.getCellFormat().setWidth(250);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0013")));

							builder.insertCell();
							builder.getCellFormat().setWidth(150);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0014")));
							
							builder.insertCell();
							builder.getCellFormat().setWidth(250);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0015")));
							builder.endRow();
							builder.endTable().setAllowAutoFit(false);


							builder.insertHtml("<br>");
							
							builder.startTable();			
							builder.getRowFormat().clearFormatting();
							// Make the header row.
							builder.insertCell();
							builder.getRowFormat().setHeight(20.0);
							builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
							
							// Some special features for the header row.
							builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
							builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
							builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
							builder.getFont().setSize(10);
							builder.getFont().setBold (true);
							builder.getFont().setColor(Color.BLACK);
							builder.getFont().setName(defaultFont);				
							
							builder.getCellFormat().setWidth(100);
							builder.write("센터구분");

							builder.insertCell();
							builder.getCellFormat().setWidth(250);
							builder.write("프로세스 오너");

							builder.insertCell();
							builder.getCellFormat().setWidth(150);
							builder.write("주관부서");
							
							builder.insertCell();
							builder.getCellFormat().setWidth(250);
							builder.write("관련부서");
							builder.endRow();	
							
							builder.getFont().setBold (false);				
							builder.insertCell();
							builder.getCellFormat().setWidth(100);
							builder.write("TC");
							
							// Set features for the other rows and cells.
							builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
							builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
							
							// Reset height and define a different height rule for table body
							builder.getRowFormat().setHeight(30.0);
							builder.getRowFormat().setHeightRule(HeightRule.AUTO);
									
							builder.insertCell();
							builder.getCellFormat().setWidth(250);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0016")));

							builder.insertCell();
							builder.getCellFormat().setWidth(150);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0017")));
							
							builder.insertCell();
							builder.getCellFormat().setWidth(250);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0018")));
							builder.endRow();	
							
							
							builder.insertCell();
							builder.getCellFormat().setWidth(100);
							builder.write("DC");
							
							// Set features for the other rows and cells.
							builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
							builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
							
							// Reset height and define a different height rule for table body
							builder.getRowFormat().setHeight(30.0);
							builder.getRowFormat().setHeightRule(HeightRule.AUTO);
									
							builder.insertCell();
							builder.getCellFormat().setWidth(250);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0019")));

							builder.insertCell();
							builder.getCellFormat().setWidth(150);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0020")));
							
							builder.insertCell();
							builder.getCellFormat().setWidth(250);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0021")));
							builder.endRow();
							
							builder.insertCell();
							builder.getCellFormat().setWidth(100);
							builder.write("RDC");
							
							// Set features for the other rows and cells.
							builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
							builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
							
							// Reset height and define a different height rule for table body
							builder.getRowFormat().setHeight(30.0);
							builder.getRowFormat().setHeightRule(HeightRule.AUTO);
									
							builder.insertCell();
							builder.getCellFormat().setWidth(250);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0022")));

							builder.insertCell();
							builder.getCellFormat().setWidth(150);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0023")));
							
							builder.insertCell();
							builder.getCellFormat().setWidth(250);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0024")));
							builder.endRow();
							
							builder.insertCell();
							builder.getCellFormat().setWidth(100);
							builder.write("전문점");
							
							// Set features for the other rows and cells.
							builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
							builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
							
							// Reset height and define a different height rule for table body
							builder.getRowFormat().setHeight(30.0);
							builder.getRowFormat().setHeightRule(HeightRule.AUTO);
									
							builder.insertCell();
							builder.getCellFormat().setWidth(250);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0025")));

							builder.insertCell();
							builder.getCellFormat().setWidth(150);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0026")));
							
							builder.insertCell();
							builder.getCellFormat().setWidth(250);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0027")));
							builder.endRow();
				 	 		
							builder.insertCell();
							builder.getCellFormat().setWidth(100);
							builder.write("PC");
							
							// Set features for the other rows and cells.
							builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
							builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
							
							// Reset height and define a different height rule for table body
							builder.getRowFormat().setHeight(30.0);
							builder.getRowFormat().setHeightRule(HeightRule.AUTO);
									
							builder.insertCell();
							builder.getCellFormat().setWidth(250);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0028")));

							builder.insertCell();
							builder.getCellFormat().setWidth(150);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0029")));
							
							builder.insertCell();
							builder.getCellFormat().setWidth(250);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0030")));
							builder.endRow();
							
							builder.insertCell();
							builder.getCellFormat().setWidth(100);
							builder.write("APC");
							
							// Set features for the other rows and cells.
							builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
							builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
							
							// Reset height and define a different height rule for table body
							builder.getRowFormat().setHeight(30.0);
							builder.getRowFormat().setHeightRule(HeightRule.AUTO);
									
							builder.insertCell();
							builder.getCellFormat().setWidth(250);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0031")));

							builder.insertCell();
							builder.getCellFormat().setWidth(150);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0032")));
							
							builder.insertCell();
							builder.getCellFormat().setWidth(250);
							builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0033")));
							builder.endRow();
							builder.endTable().setAllowAutoFit(false);
				 	 		
							int headerNO = 2;
							if (0 != modelMap.size()) {
				 				builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
				 				
						 		builder.getFont().setColor(Color.DARK_GRAY);
							    builder.getFont().setSize(11);
							    builder.getFont().setBold(true);
							    builder.getFont().setName(defaultFont);
								builder.writeln(headerNO+". " + String.valueOf(menu.get("LN00197")));
								headerNO++;
								
					 	 		//==================================================================================================
				 		 		//프로세스 맵
				 		 	 	builder.startTable();
				 		 	 	builder.insertCell();
				 		 	 	builder.getRowFormat().clearFormatting();
				 		 		builder.getCellFormat().clearFormatting();
				 		 		builder.getRowFormat().setHeight(20.0);
				 		 		builder.getRowFormat().setHeightRule(HeightRule.AUTO);
				 		 	 	builder.getCellFormat().setWidth(totalCellWidth);
				 		 	 	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
				 		 	 	
				 		 		String imgLang = "_"+StringUtil.checkNull(setMap.get("langCode"));
				 		 		String imgPath = modelImgPath+modelMap.get("ModelID")+imgLang+"."+GlobalVal.MODELING_DIGM_IMG_TYPE;
				 		 		int width = Integer.parseInt(String.valueOf(modelMap.get("Width")));
				 		 		int height = Integer.parseInt(String.valueOf(modelMap.get("Height")));
				 		 		System.out.println("프로세스맵 imgPath="+imgPath);
				 		 		try{
				 		 			builder.insertHtml("<br>");
				 		 			builder.insertImage(imgPath, RelativeHorizontalPosition.PAGE, 30, RelativeVerticalPosition.PAGE,20,width,height,WrapType.INLINE);
				 		 			builder.insertHtml("<br>");
				 		 		} catch(Exception ex){}
				 		 		
				 		 		
				 		 		builder.endTable().setAllowAutoFit(false);
				 		 		
				 		 		//==================================================================================================
				 		 		
				 			}
				 	 		
				 	 		builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
			
				 	 		// 2. 선/후행 프로세스
				 	 		builder.getFont().setColor(Color.BLACK);
						    builder.getFont().setSize(11);
						    builder.getFont().setBold(true);
						    builder.getFont().setName(defaultFont);
							builder.writeln(headerNO+". " + String.valueOf(menu.get("LN00178"))+"Process");
							headerNO++;
							
					 		if (elementList.size() > 0) {
					 			Map cnProcessData = new HashMap();
					 			
						 		for(int j=0; j<elementList.size(); j++){
									cnProcessData = (HashMap) elementList.get(j);
						 			if(cnProcessData.get("LinkType").equals("Pre")) {
						 				builder.insertHtml("<br>");
										String itemName = StringUtil.checkNullToBlank(cnProcessData.get("Name")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
										itemName = itemName.replace("&#10;", " ");
										itemName = itemName.replace("&#xa;", "");
										itemName = itemName.replace("&nbsp;", " ");
										String processInfo = StringUtil.checkNullToBlank(cnProcessData.get("Description")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");;
										processInfo = processInfo.replace("&#10;", " ");
										processInfo = processInfo.replace("&#xa;", "");
										processInfo = processInfo.replace("&nbsp;", " ");
										builder.getCellFormat().setWidth(30);
										
										builder.getFont().setColor(new Color(0,112,192));
										builder.getFont().setBold(true);
										builder.writeln("[선행 프로세스] "+StringUtil.checkNullToBlank(cnProcessData.get("ID"))+itemName);
			
							 	 		builder.getFont().setColor(Color.BLACK);
							 	 		builder.getFont().setBold(false);
										if(StringUtil.checkNullToBlank(processInfo).contains("font-family")){	
											builder.insertHtml(processInfo);
						 	 			}else{
						 	 				builder.insertHtml(fontFamilyHtml+processInfo+"</span>",false);
						 	 			}
										builder.insertHtml("<br>");
							 		}
					 			}
					 			
						 		for(int j=0; j<elementList.size(); j++){
									cnProcessData = (HashMap) elementList.get(j);
						 			if(cnProcessData.get("LinkType").equals("Post")) {
						 				builder.insertHtml("<br>");
										String itemName = StringUtil.checkNullToBlank(cnProcessData.get("Name")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
										itemName = itemName.replace("&#10;", " ");
										itemName = itemName.replace("&#xa;", "");
										itemName = itemName.replace("&nbsp;", " ");
										String processInfo = StringUtil.checkNullToBlank(cnProcessData.get("Description")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");;
										processInfo = processInfo.replace("&#10;", " ");
										processInfo = processInfo.replace("&#xa;", "");
										processInfo = processInfo.replace("&nbsp;", " ");
										builder.getCellFormat().setWidth(30);
										
										builder.getFont().setColor(Color.red);
										builder.getFont().setBold(true);
										builder.writeln("[후행 프로세스] "+StringUtil.checkNullToBlank(cnProcessData.get("ID"))+itemName);
										
										builder.getFont().setColor(Color.BLACK);
										builder.getFont().setBold(false);
										if(StringUtil.checkNullToBlank(processInfo).contains("font-family")){	
											builder.insertHtml(processInfo);
						 	 			}else{
						 	 				builder.insertHtml(fontFamilyHtml+processInfo+"</span>",false);
						 	 			}
										builder.insertHtml("<br>");
							 		}
					 			}
						 	}
				 	 								
							builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
					 		// 액티비티 리스트 Title
					 		builder.getFont().setColor(Color.DARK_GRAY);
						    builder.getFont().setSize(11);
						    builder.getFont().setBold(true);
						    builder.getFont().setName(defaultFont);
							builder.writeln(headerNO+". " + String.valueOf(menu.get("LN00151")));
							builder.insertHtml("<br>");
							Map rowActData = new HashMap();	
							for(int j=0; j<activityList.size(); j++){
								rowActData = (HashMap) activityList.get(j);
								
								builder.getFont().setColor(Color.DARK_GRAY);
							    builder.getFont().setSize(11);
							    builder.getFont().setBold(true);
							    builder.getFont().setName(defaultFont);
							    
							    String identifier =  StringUtil.checkNullToBlank(rowActData.get("Identifier"));
							    String itemName = StringUtil.checkNullToBlank(rowActData.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
							    itemName = itemName.replace("&#10;", " ");
								itemName = itemName.replace("&#xa;", "");
								itemName = itemName.replace("&nbsp;", " ");
								builder.getFont().setColor(new Color(0,112,192));
							    builder.writeln(identifier+" "+itemName); //명칭
							    
							    builder.getFont().setColor(Color.black);
								builder.writeln("[Guideline]");// GuideLine
								builder.getFont().setBold(false);						
								String ATVITAT00003 = StringUtil.checkNullToBlank(rowActData.get("AT00003")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
								if(StringUtil.checkNullToBlank(rowActData.get("AT00003")).contains("font-family")){	
									builder.insertHtml(ATVITAT00003);
				 	 			}else{
				 	 				builder.insertHtml(fontFamilyHtml+ATVITAT00003+"</span>");
				 	 			}
								 builder.insertHtml("<br>");
								builder.getFont().setBold(true);
								builder.write("[Role] "); // 담당
								builder.getFont().setBold(false);
								builder.writeln(StringUtil.checkNullToBlank(rowActData.get("AT00017"))); // 담당
								
								builder.getFont().setBold(true);
								builder.write("[System] ");
								builder.getFont().setBold(false);
								List actSystemList = (List)rowActData.get("actSystemList");
								if (actSystemList.size() > 0) {
									Map rowActSystemSetData = new HashMap();
									for(int m=0; m<actSystemList.size(); m++){
										rowActSystemSetData = (HashMap)actSystemList.get(m);
										builder.writeln(StringUtil.checkNullToBlank(StringUtil.checkNullToBlank(rowActSystemSetData.get("toItemName")))); // toItemDescription
									}
								}
								builder.insertHtml("<br>");
								
								
								builder.getFont().setBold(true);
								builder.write( "[T-Code] ");
								builder.getFont().setBold(false);
								builder.writeln(StringUtil.checkNullToBlank(rowActData.get("AT00014"))); // 화면코드
								builder.insertHtml("<br>");
							}
//					 	}
					 }
				}
			}
			
			String extLangCode = StringUtil.checkNull(commandMap.get("extLangCode"));
			
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			//String filePath = "C://TEMP//" ;
			String filePath = StringUtil.checkNull(commandMap.get("filePath"));
			File dirFile = new File(filePath); if(!dirFile.exists()){dirFile.mkdirs();}

			formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			date = System.currentTimeMillis();
			String fileRealName = "BPD_" + formatter.format(date) +".doc";

		    String downFile = filePath+"/"+fileRealName;
			doc.save(downFile);
			returnValue = fileRealName;
			
		} catch(Exception e){
			System.out.println(e.toString());
		}	
		return returnValue;
	}

	 // TODO : 주석해제하여 패치
	/*
	@Resource(name="orclSession")
	private SqlSession orclSession;

	@Resource(name="xsqlSession")
	private SqlSession xsqlSession;
			
	@RequestMapping(value="/custom/zSSG_exeSYSinterface.do")
	public void exeHRinterface(HttpServletRequest request) throws Exception {
		HashMap setMap = new HashMap();
		System.out.println("start zSSG_exeERPinterface");
		try {
			Map setdata = new HashMap();
			HttpSession session = request.getSession(true);

			String language = GlobalVal.DEFAULT_LANGUAGE;
			if(session.getAttribute("loginInfo") == null) {
				setdata.put("LOGIN_ID", "sys");
				setdata.put("IS_CHECK", "N");
				setdata.put("LANGUAGE", language);	
				Map loginInfo = commonService.select("login_SQL.login_select", setdata);
			}
			
			 // 주석해제하여 패치
			commonService.delete("custom_SQL.zSSG_deleteTemp", setMap);
			List roleList = orclSession.selectList("ssg_ORASQL.ssg_selectRole_gridList",setMap);
			
			if(roleList.size() == 0) {
				String ip = request.getHeader("X-FORWARDED-FOR");
				if (ip == null)
		            ip = request.getRemoteAddr();
		        
				setdata.put("IpAddress",ip);	
				
				xsqlSession.insert("custom_SQL.zSSG_insertAMSBatchErrorTbl", setdata);
			}
			
			for(int i=0; i<roleList.size(); i++) {
				setMap = (HashMap) roleList.get(i);
				commonService.insert("custom_SQL.zSSG_insertRole",setMap);
			}
						
			List userRoleList = orclSession.selectList("ssg_ORASQL.ssg_selectUserRole_gridList",setMap);
			for(int i=0; i<userRoleList.size(); i++) {
				setMap = (HashMap) userRoleList.get(i);
				commonService.insert("custom_SQL.zSSG_insertUserRole",setMap);
			}
			
			List tcodeList = orclSession.selectList("ssg_ORASQL.ssg_selectTcode_gridList",setMap);
			for(int i=0; i<tcodeList.size(); i++) {
				setMap = (HashMap) tcodeList.get(i);
				commonService.insert("custom_SQL.zSSG_insertMenu",setMap);
			}
			
			List tcodeRoleList = orclSession.selectList("ssg_ORASQL.ssg_selectTcodeRole_gridList",setMap);
			for(int i=0; i<tcodeRoleList.size(); i++) {
				setMap = (HashMap) tcodeRoleList.get(i);
				commonService.insert("custom_SQL.zSSG_inserRoleMenu",setMap);
			}
			
			// 하나의 프로시저
			// 없는 것들만 TI_ITEM_ATTR_IF(아직 role List 기준 미정), TI_ITEM_CON_IF 에 insert
			// XBOLTADM.TI_ITEM_BATCH,XBOLTADM.TI_ITEM_CON_BATCH 실행
			// MY_ITEM insert
			commonService.insert("custom_SQL.zSSG_createCxnTcodeRole", setMap);
			System.out.println("end exeHRinterface");
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
	}
	*/
	
	@RequestMapping(value="/zEmartMain.do")
	public String zSSGMain(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception{
		
		try {
			Map setMap = new HashMap();
			
			List procStatCount = commonService.selectList("custom_SQL.zSSG_selectProcStatCount", setMap);
			
			setMap.put("top", "10");
			List csList = commonService.selectList("custom_SQL.zSSG_getLastUpdatedWithin6Months", setMap);
			
			model.put("procStatCount",procStatCount);
			model.put("csList",csList);
			model.put("srType", request.getParameter("srType"));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		}		
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		model.put("menu", getLabel(request, commonService));	//Label Setting
		model.put("screenType", request.getParameter("screenType"));
		return nextUrl("/custom/ssg/emart/emartMain");
	}
	
	@RequestMapping(value="/zSSG_LastUpdatedWithin6Months.do")
	public String zSSG_LastUpdatedWithin6Months(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception{
		
		try {
			Map setMap = new HashMap();
			
			List csList = commonService.selectList("custom_SQL.zSSG_getLastUpdatedWithin6Months", setMap);
			JSONArray gridData = new JSONArray(csList);
			model.put("gridData",gridData);
			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		}		
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		model.put("menu", getLabel(request, commonService));	//Label Setting
		model.put("screenType", request.getParameter("screenType"));
		return nextUrl("/custom/ssg/emart/emartUpdated6Months");
	}
	
	@RequestMapping(value="/custom/olmLinkSSG.do", method=RequestMethod.POST)
	public String indexCSI(Map cmmMap,ModelMap model, HttpServletRequest request) throws Exception {
		try{
			String loginid = StringUtil.checkNull(request.getParameter("olmLoginid"));
			String defaltLangCode = GlobalVal.DEFAULT_LANG_CODE;		
			model.put("loginid", loginid);
			model.put("DEFAULT_LANG_CODE", defaltLangCode);
			System.out.println("***olmLinkPopupSSG***");
		}catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl("/custom/ssg/emart/olmLinkPopup");
	}
}