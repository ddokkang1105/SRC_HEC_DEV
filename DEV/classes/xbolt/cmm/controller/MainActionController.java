package xbolt.cmm.controller;

import java.io.File;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.activation.CommandMap;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.text.StringEscapeUtils;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.service.CommonService;

import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.org.json.JSONObject;
/**
 * 공통 서블릿 처리
 * @Class Name : MainActionController.java
 * @Description : 공통화면을 제공한다.
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2012. 09. 01. smartfactory		최초생성
 *
 * @since 2012. 09. 01.
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class MainActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;


	/**
	 * Simpleforward 전용
	 * @param cmmMap.nextPage
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/simple.do")
	public String simpleForward(Map cmmMap,ModelMap model) throws Exception {
		model.addAttribute("cmmMap", cmmMap);
		Object simpleforwardAddress = ("nextPage");
		return nextUrl(simpleforwardAddress);
	}
	@RequestMapping(value="/hello.do")
	public void hello() throws Exception {
		//return "hello";
	}

	@RequestMapping(value="/index.do")
	public String index(Map cmmMap,ModelMap model) throws Exception {
		//String pass = URLDecoder.decode(StringUtil.checkNull(cmmMap.get("olmP")), "UTF-8");
		String pass = StringUtil.checkNull(cmmMap.get("olmP"));
		model.put("olmI", StringUtil.checkNull(cmmMap.get("olmI"),""));
		model.put("olmP", pass);
		model.put("olmLng", StringUtil.checkNull(cmmMap.get("olmLng"),""));
		model.put("loginIdx", "BASE");
		return nextUrl("index");
	}
	

	
	
	
	@RequestMapping(value="/indexHSO.do")
	public String indexHSO(HttpServletRequest request,Map cmmMap,ModelMap model) throws Exception {
		//String pass = URLDecoder.decode(StringUtil.checkNull(cmmMap.get("olmP")), "UTF-8");
		String pass = StringUtil.checkNull(cmmMap.get("olmP"));
		model.put("olmI", StringUtil.checkNull(cmmMap.get("olmI"),""));
		model.put("olmP", pass);
		model.put("olmLng", StringUtil.checkNull(cmmMap.get("olmLng"),""));
		return nextUrl("indexHSO");
	}	
	
	@RequestMapping(value="/start.do")
	public String start() throws Exception {
		return nextUrl(GlobalVal.HTML_LOGIN_PAGE);
	}

	@RequestMapping(value="/masterPopup.do")
	public String masterPopup(Map cmmMap,ModelMap model) throws Exception {
		model.put("menuType", ("menuType"));
		model.put("defDimValue", StringUtil.checkNull(cmmMap.get("defDimValue"),""));
		return nextUrl("/template/masterPopup");
	}
	
	@RequestMapping(value="/olmPopup.do")
	public String masterIFPopup(Map cmmMap,ModelMap model) throws Exception {
		String loginid = StringUtil.checkNull(cmmMap.get("olmLoginid"));
		String defaltLangCode = GlobalVal.DEFAULT_LANG_CODE;
		
		model.put("loginid", loginid);
		model.put("DEFAULT_LANG_CODE", defaltLangCode);
		
		return nextUrl("/template/masterIFPopup");
	}

	@RequestMapping(value="/header.do")
	public String header() throws Exception {
		return nextUrl("/tiles/header");
	}
	@RequestMapping(value="/footer.do")
	public String footer() throws Exception {

		return nextUrl("/tiles/footer");
	}
	@RequestMapping(value="/template/contents.do")
	public String contents() throws Exception {
		return nextUrl("/template/contents");
	}

	@RequestMapping(value="/template/emptyPage.do")
	public String emptyPage() throws Exception {
		//return nextUrl(AJAXPAGE);
		return nextUrl("/template/emptyPage");
	}
	@RequestMapping(value="/empty.do")
	public String empty() throws Exception {
		//return nextUrl(AJAXPAGE);
		return nextUrl("/template/notYetPage");
	}
	@RequestMapping(value="/nextPage.do")
	public String nextPage(ModelMap model,Map cmmMap) throws Exception {
		model.addAttribute(AJAX_RESULTMAP, cmmMap);
		String simpleforwardAddress = (String)cmmMap.get("nextPage");
		return nextUrl(simpleforwardAddress);
	}	

	/**
	 * 메인페이지 전용
	 * @param cmmMap.nextPage
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/mainpage.do")
	public void mainpage(ModelMap model, HashMap cmmMap) throws Exception {
		try {
			Map resultMap = new HashMap();
			Map<String,List> tmpMap = new HashMap();
			Map setMap = new HashMap();
			//System.out.println("mainpage.do _ screenType :"+cmmMap.get("screenType"));
			String s_templCode = StringUtil.checkNull(cmmMap.get("s_templCode")); 
			String templMenuID = "";
			
			List layerList = commonService.selectList("menu_SQL.mainTempl_select", cmmMap);
			
			String boardAlertCnt = StringUtil.checkNull(commonService.selectString("forum_SQL.getBoardAlertCnt", cmmMap));
			
			model.put("timeout",StringUtil.checkNull(cmmMap.get("timeout")));
	
			
			model.put("boardAlertCnt",boardAlertCnt);

			model.put("templList", layerList);
			model.put("langList", commonService.selectList("common_SQL.langType_commonSelect", cmmMap));
			model.put("topMenuList", commonService.selectList("menu_SQL.defaultTopMenu_select", cmmMap));
			model.put("mainMenuList", commonService.selectList("menu_SQL.mainMenu_select", cmmMap));
			model.put("scnMenuList", commonService.selectList("menu_SQL.secondMenu_select", cmmMap));
			model.put("thdMenuList", commonService.selectList("menu_SQL.thirdMenu_select", cmmMap));
			
			String defaultTemplCode = StringUtil.checkNull(cmmMap.get("defTemplateCode"));
			if(defaultTemplCode.equals("")){
				defaultTemplCode = StringUtil.checkNull(commonService.selectString("menu_SQL.getDefaultTemplate", cmmMap));
			}
			
			setMap.put("memberID", StringUtil.checkNull(cmmMap.get("sessionUserId")));
			String defaultState = StringUtil.checkNull(commonService.selectString("user_SQL.getMemberState", setMap));
			String mainType = StringUtil.checkNull(cmmMap.get("mainType")); 
			mainType = StringEscapeUtils.escapeHtml4(mainType);
			
			String mainTemplateURL = "";

			if(!"".equals(GlobalVal.OLM_MASTER_URL)) {
				mainTemplateURL = GlobalVal.OLM_MASTER_URL + "?";
				
			}
			
//			if(mainType.equals("pjt")){defaultTempCode="TMPL003";}

			List cmpnyList = commonService.selectList("menu_SQL.company_select", cmmMap);
			String isCmpnyView = "N";
			String isCmpnySelect = "N";
			if(cmpnyList != null && cmpnyList.size() > 0 && StringUtil.checkNull(GlobalVal.MULTI_COMPANY, "N").equals("Y")){
				isCmpnyView = "Y";
				model.put("cmpnyList", cmpnyList);
				//ADMIN인 경우만 선택
				if(StringUtil.checkNull(cmmMap.get("sessionAuthLev"),"").equals("1")){isCmpnySelect="Y";}
			}			
			model.put("isCmpnyView", isCmpnyView);
			model.put("isCmpnySelect", isCmpnySelect);
			model.put("cmpnyCode", StringUtil.checkNull(cmmMap.get("sessionCompanyId"),""));
			model.put("cmpnyText", StringUtil.checkNull(cmmMap.get("sessionCompanyNm"),""));
			
			String myPageTmplFilter = "";
			int maxtmpTxtLng=0; 
			if( layerList.size() > 0){
				float tmpTxtLng1=0; int tmpTxtLng2=0;String templText="";
				float cmpnyTxtLng1=0; int cmpnyTxtLng2=0;String cmpnyText="";
				for(int i=0;i<layerList.size();i++){
					tmpTxtLng1=0;
					cmpnyTxtLng1=0;
					Map layerInfo = (HashMap) layerList.get(i);				
					templText=StringUtil.checkNull(layerInfo.get("TemplText"),"");
					
					if(StringUtil.checkNull(("sessionCurrLangType")).equals("1033")){tmpTxtLng1=templText.getBytes("utf-8").length;tmpTxtLng1=Math.round(tmpTxtLng1*1.3);}
					else{					
						for(int j=0;j<templText.length();j++){
							if((templText.charAt(j)==' ')||(templText.charAt(j)=='/')||(templText.charAt(j)>='a'&&templText.charAt(j)<='z')){tmpTxtLng1+=1.5;}
							else if((templText.charAt(j)>='A'&&templText.charAt(j)<='Z')){tmpTxtLng1+=2;}
							else{tmpTxtLng1+=2.7;}
						}
					}
					//if(tmpTxtLng2>tmpTxtLng1){tmpTxtLng1=tmpTxtLng2;}
					if(tmpTxtLng1>maxtmpTxtLng){maxtmpTxtLng=Math.round(tmpTxtLng1);}
					//System.out.println("txt::"+templText+", leng="+templText.length()+",tmpTxtLng::"+tmpTxtLng1+","+tmpTxtLng2+","+maxtmpTxtLng);
					//System.out.println("defaultTempCode:"+defaultTempCode);
					
				}
				for(int i=0;i<layerList.size();i++){
					Map layerInfo = (HashMap) layerList.get(i);
					templText=StringUtil.checkNull(layerInfo.get("TemplText"),"");
					if(!s_templCode.equals("")) {
						if(s_templCode.equals(StringUtil.checkNull(layerInfo.get("TemplCode"),""))){
							templMenuID = StringUtil.checkNull(layerInfo.get("MenuID"),"");
							model.put("templCode", StringUtil.checkNull(layerInfo.get("TemplCode"),""));
							model.put("templText", templText);
							model.put("mainURL", StringUtil.checkNull(layerInfo.get("MainURL"),""));
							model.put("mainScnText", StringUtil.checkNull(layerInfo.get("MainScnText"),""));
							model.put("mainUrlFilter", StringUtil.checkNull(layerInfo.get("URLFilter"),""));
							model.put("tmplFilter", StringUtil.checkNull(layerInfo.get("TmplFilter"),""));
							if(mainType.equals("pjt")){
								String projectID = commonService.selectString("project_SQL.getProjectID", cmmMap);
								model.put("mainURL","pjtTemplate");
								model.put("projectID", projectID);
							}
							mainTemplateURL = mainTemplateURL + "dTempleCode=" + StringUtil.checkNull(layerInfo.get("TemplCode"),"") 
															  + "&gloProjectID="+StringUtil.checkNull(cmmMap.get("gloProjectID"))
															  + "&focusedItemID="+StringUtil.checkNull(cmmMap.get("focusedItemID"));
							model.put("htmlTitle", templText);
						}
					} else if(defaultTemplCode.equals(StringUtil.checkNull(layerInfo.get("TemplCode"),""))){
						templMenuID = StringUtil.checkNull(layerInfo.get("MenuID"),"");
						model.put("templCode", StringUtil.checkNull(layerInfo.get("TemplCode"),""));
						model.put("templText", templText);
						model.put("mainURL", StringUtil.checkNull(layerInfo.get("MainURL"),""));
						model.put("mainScnText", StringUtil.checkNull(layerInfo.get("MainScnText"),""));
						model.put("mainUrlFilter", StringUtil.checkNull(layerInfo.get("URLFilter"),""));
						model.put("tmplFilter", StringUtil.checkNull(layerInfo.get("TmplFilter"),""));
						if(mainType.equals("pjt")){
							String projectID = commonService.selectString("project_SQL.getProjectID", cmmMap);
							model.put("mainURL","pjtTemplate");
							model.put("projectID", projectID);
						}
						mainTemplateURL = mainTemplateURL + "dTempleCode=" + StringUtil.checkNull(layerInfo.get("TemplCode"),"") 
														  + "&gloProjectID="+StringUtil.checkNull(cmmMap.get("gloProjectID"))
														  + "&focusedItemID="+StringUtil.checkNull(cmmMap.get("focusedItemID"));
						
					} else if(defaultTemplCode.equals("")){
							if(i==0){
								templMenuID = StringUtil.checkNull(layerInfo.get("MenuID"),"");
								model.put("templCode", StringUtil.checkNull(layerInfo.get("TemplCode"),""));
								model.put("templText", templText);
								model.put("mainURL", StringUtil.checkNull(layerInfo.get("MainURL"),""));
								model.put("mainScnText", StringUtil.checkNull(layerInfo.get("MainScnText"),""));
								model.put("mainUrlFilter", StringUtil.checkNull(layerInfo.get("URLFilter"),""));
								model.put("tmplFilter", StringUtil.checkNull(layerInfo.get("TmplFilter"),""));
								mainTemplateURL = mainTemplateURL + "dTempleCode=" + StringUtil.checkNull(layerInfo.get("TemplCode"),"") 
																  + "&gloProjectID="+StringUtil.checkNull(cmmMap.get("gloProjectID"))
																  + "&focusedItemID="+StringUtil.checkNull(cmmMap.get("focusedItemID"));
							}
						}
				}
			}else{
					model.put("templCode", "");
					model.put("templText", "");
					model.put("mainURL", "");
					model.put("mainScnText", "");
					model.put("mainUrlFilter", "");
					model.put("tmplFilter", "");
			}
			/*
			 * if (!StringUtil.checkNull(cmmMap.get("timeout")).isEmpty()) { mainTemplateURL
			 * = mainTemplateURL + "&timeout="+StringUtil.checkNull(cmmMap.get("timeout"));
			 * }
			 */

			model.put("mainTemplateURL",mainTemplateURL);
			
			model.put("tmpTextMaxLng",(maxtmpTxtLng*5));
			
			Map setData = new HashMap();
			if(myPageTmplFilter.equals("")){
				setData.put("templCode", "MYPAGE");
				myPageTmplFilter = StringUtil.checkNull(commonService.selectString("menu_SQL.getTemplVarFilter", setData));				
				model.put("myPageTmplFilter", myPageTmplFilter);
			}
			
			setData.put("templCode", "MYPAGE");
			String myPageMNFilter = StringUtil.checkNull(commonService.selectString("menu_SQL.getMNVarFilter", setData));	
			myPageTmplFilter = myPageTmplFilter + myPageMNFilter;
			model.put("myPageTmplFilter", myPageTmplFilter);
			int maxcmpyTxtLng=0; 
			if( cmpnyList.size() > 0){
				float cmpnyTxtLng1=0; int cmpnyTxtLng2=0;String cmpnyText="";
				for(int i=0;i<cmpnyList.size();i++){
					cmpnyTxtLng1=0;
					Map cmpyInfo = (HashMap) cmpnyList.get(i);				
					cmpnyText=StringUtil.checkNull(cmpyInfo.get("CmpnyText"),"");
					
					if(StringUtil.checkNull(("sessionCurrLangType")).equals("1033")){cmpnyTxtLng1=cmpnyText.getBytes("utf-8").length;cmpnyTxtLng1=Math.round(cmpnyTxtLng1*1.3);}
					else{					
						for(int j=0;j<cmpnyText.length();j++){
							if((cmpnyText.charAt(j)==' ')||(cmpnyText.charAt(j)=='/')||(cmpnyText.charAt(j)>='a'&&cmpnyText.charAt(j)<='z')){cmpnyTxtLng1+=1.5;}
							else if((cmpnyText.charAt(j)>='A'&&cmpnyText.charAt(j)<='Z')){cmpnyTxtLng1+=2;}
							else{cmpnyTxtLng1+=2.7;}
						}
					}
					//if(tmpTxtLng2>tmpTxtLng1){tmpTxtLng1=tmpTxtLng2;}
					if(cmpnyTxtLng1>maxcmpyTxtLng){maxcmpyTxtLng=Math.round(cmpnyTxtLng1);}
					//System.out.println("txt::"+cmpnyText+", leng="+cmpnyText.length()+",tmpTxtLng::"+cmpnyTxtLng1+","+cmpnyTxtLng2+","+maxcmpyTxtLng);
				}
			}
			model.put("cmpnyTextMaxLng",(maxcmpyTxtLng*5));		
			
			if(defaultTemplCode == null || defaultTemplCode.equals("")){defaultTemplCode = "TMPL001";}
			if(!"".equals(defaultTemplCode)) {
				//최근공지사항 조회--START
				setMap.put("viewType", "pop");
				cmmMap.put("TemplCode",defaultTemplCode);
				Map projectInfoMap = commonService.select("main_SQL.getPjtInfoFromTEMPL", cmmMap);	
				
				setMap.put("projectID", projectInfoMap.get("ProjectID"));		
	
				int ntcCnt=NumberUtil.getIntValue(commonService.selectString("board_SQL.boardTotalCnt", setMap));
	
				if(ntcCnt>0){Map getMap = commonService.select("board_SQL.boardDetail", setMap);model.put("BoardID", StringUtil.checkNull(getMap.get("BoardID"),""));}
				model.put("ntcCnt", ntcCnt);
			}
			//최근공지사항 조회--END			
			model.addAttribute(HTML_HEADER, "초기화면");
			model.addAttribute(AJAX_RESULTMAP,tmpMap);
			model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx")));
			model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType")));
			
			if(mainType.equals("mySRDtl")){ // From Email 접수 
				Map getSRInfo = commonService.select("esm_SQL.getESMSRInfo", cmmMap);
				String sessionUserID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
				String receiptUserID = StringUtil.checkNull(getSRInfo.get("ReceiptUserID"));			
				/*
				if(!sessionUserID.equals(receiptUserID)){ // 로그인User!=접수자 
					mainType = "SRDtlView";
				}*/
			}
			// Visit Log
			if(s_templCode == "") {s_templCode = defaultTemplCode;}
			cmmMap.put("ActionType", "TMPLMN");
			cmmMap.put("MenuID", StringUtil.checkNull(s_templCode));
			HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
			 String ip = request.getHeader("X-FORWARDED-FOR");
	        if (ip == null)
	            ip = request.getRemoteAddr();
	        cmmMap.put("IpAddress",ip);
	        	        
			commonService.insert("gloval_SQL.insertVisitLog", cmmMap);			
			model.put("srID", StringUtil.checkNull(cmmMap.get("srID")));
			model.put("srType", StringUtil.checkNull(cmmMap.get("srType")));
			model.put("esType", StringUtil.checkNull(cmmMap.get("esType")));
			
			model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode")));
			model.put("proposal", StringUtil.checkNull(cmmMap.get("proposal")));
			model.put("status", StringUtil.checkNull(cmmMap.get("status")));			
			model.put("gloProjectID", StringUtil.checkNull(cmmMap.get("gloProjectID")));
			model.put("itemID", StringUtil.checkNull(cmmMap.get("itemID")));
			model.put("focusedItemID", StringUtil.checkNull(cmmMap.get("focusedItemID")));
			model.put("wfInstanceID", StringUtil.checkNull(cmmMap.get("wfInstanceID")));
			
			model.put("defTemplateCode", StringUtil.checkNull(cmmMap.get("defTemplateCode")));
			model.put("defArcCode", StringUtil.checkNull(cmmMap.get("defArcCode")));
			
			String defArcCode = StringUtil.checkNull(cmmMap.get("defArcCode"));
			// Item Link Templet view	
			String scrnType = StringUtil.checkNull(cmmMap.get("scrnType"));
			String linkID = StringUtil.checkNull(cmmMap.get("linkID"));
			String linkType = StringUtil.checkNull(cmmMap.get("linkType"));
			String itemTypeCode = StringUtil.checkNull(cmmMap.get("itemTypeCode"));
			String docCategory = StringUtil.checkNull(cmmMap.get("docCategory"));
			String srID = StringUtil.checkNull(cmmMap.get("srID"));
			
			String itemID = "";
			
			if(("SR").equals(docCategory)){
				itemID = srID;
			}else{
				if(scrnType.equals("TMPL") || mainType.equals("arcLink")){
					itemID = linkID;
					setMap.put("identifier", linkID);
					setMap.put("itemTypeCode", itemTypeCode);
					
					if (linkType.equals("code")) {
						itemID = StringUtil.checkNull(commonService.selectString("item_SQL.getItemID", setMap), "");
					} 
					setMap.put("s_itemID", itemID);
					defArcCode = commonService.selectString("item_SQL.getDefArc", setMap);
					model.put("linkNodeID", itemID);
				}
			}
			
			// arcLink setting 
			String arcCode = StringUtil.checkNull(cmmMap.get("arcCode"));
			if(!defArcCode.equals("")){ cmmMap.put("arcCode", defArcCode); model.put("arcCode", defArcCode); mainType = "arcLink";}
			else if(!arcCode.equals("")){ model.put("arcCode", arcCode); }
			model.put("mainType", mainType);
			
			if(mainType.equals("arcLink") ){
				List secondMenuList = commonService.selectList("menu_SQL.secondMenu_select", cmmMap);
				
				if(secondMenuList.size() > 0){
					for(int i=0; i<secondMenuList.size(); i++){
						Map secondMenuInfo = (Map)secondMenuList.get(i);
						if(StringUtil.checkNull(cmmMap.get("arcCode")).equals(StringUtil.checkNull(secondMenuInfo.get("MENU_ID")))){
							model.put("arcLinkName", StringUtil.checkNull(secondMenuInfo.get("MENU_NM")));
							model.put("arcLinkDimTypeID", StringUtil.checkNull(secondMenuInfo.get("DimTypeID")));
							model.put("arcLinkURL", StringUtil.checkNull(secondMenuInfo.get("URL")));
							model.put("arcLinkFILTER", StringUtil.checkNull(secondMenuInfo.get("FILTER"))+"&linkNodeID="+ itemID);
							model.put("arcLinkSTYLE", StringUtil.checkNull(secondMenuInfo.get("STYLE")));
						}
					}
				}
				if(StringUtil.checkNull(model.get("arcLinkURL")).equals("")){
					List mainMenuList = commonService.selectList("menu_SQL.mainMenu_select", cmmMap);
					
					if(mainMenuList.size() > 0){
						for(int i=0; i<mainMenuList.size(); i++){
							Map mainMenuInfo = (Map)mainMenuList.get(i);
							if(StringUtil.checkNull(cmmMap.get("arcCode")).equals(StringUtil.checkNull(mainMenuInfo.get("MENU_ID")))){
								model.put("arcLinkName", StringUtil.checkNull(mainMenuInfo.get("MENU_NM")));
								model.put("arcLinkDimTypeID", StringUtil.checkNull(mainMenuInfo.get("DimTypeID")));
								model.put("arcLinkURL", StringUtil.checkNull(mainMenuInfo.get("URL")));
								model.put("arcLinkFILTER", StringUtil.checkNull(mainMenuInfo.get("FILTER"))+"&linkNodeID=" + itemID);
								model.put("arcLinkSTYLE", StringUtil.checkNull(mainMenuInfo.get("STYLE")));
							}
						}
					}
				}
			}

			
			cmmMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			cmmMap.put("loginID", cmmMap.get("sessionLoginId"));
			List userTeamList = commonService.selectList("login_SQL.getUserTeamList", cmmMap);
			model.put("userTeamList", userTeamList);
		
		}
		catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("MainActionController::mainpage::Error::"+e.toString().replaceAll("\r|\n", ""));}
			throw new ExceptionUtil(e.toString());
		}
	}	

	@RequestMapping(value="/menuURL.do")
	public String menuURL(ModelMap model, HashMap cmmMap) throws Exception {
		Map target = new HashMap();	
		try {
			String url = "";
			String chkType = StringUtil.checkNull(cmmMap.get("MENU_CHK"),"");
			//Configuration URL
			List getList = new ArrayList();
			boolean checkTrue = false;
			String cfgUrl = "";
			getList = commonService.selectList("menu_SQL.getMenuUrlListByCfg", cmmMap);
			for(int i = 0 ; i < getList.size(); i++){
				Map dfMap = new HashMap();
				dfMap = (HashMap) getList.get(i);
				if(cmmMap.get("MENU_ID").equals(StringUtil.checkNull(dfMap.get("CNFG_CODE")))){
					checkTrue = true;cfgUrl=StringUtil.checkNull(dfMap.get("URL"));break;
				}
			}
			
			if( chkType.equals("3") || chkType.equals("4") ){	//어드민 게시판 인경우 : 3-공지사항, 4-FAQ 
				url = "/board/boardAdminMgt&noticType="+chkType;
			}else if(checkTrue){
				url = cfgUrl+".do";
			}else{
				url = StringUtil.checkNull(commonService.selectString("menu_SQL.menuURL", cmmMap), "null");
			}
			
			target.put(AJAX_SCRIPT, "parent.creatMenuTab('"+cmmMap.get("MENU_ID")+"', '"+url+"', '1');");	
					
		}
		catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("MainActionController::menuURL::Error::"+e.toString().replaceAll("\r|\n", ""));}
			throw new ExceptionUtil(e.toString());
		}		
		model.addAttribute(AJAX_RESULTMAP,target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value="/contentMenu.do")
	public String contentMenu(HashMap cmmMap,ModelMap model) throws Exception{
		model.put(AJAX_RESULTMAP, commonService.selectList("menu_SQL.contentMenu", cmmMap));
		return nextUrl(AJAX_ATTRLI);
	}
	
	@RequestMapping(value="/defTreeView.do")
	public String defTreeView(HttpServletRequest request, HashMap cmmMap,ModelMap model) throws Exception{
		String url = "/hom/main/mainTree";
		try{
			
		    	String arcCode = StringUtil.checkNull(request.getParameter("tmplFilter"),"");
				String menuStyle =  StringUtil.checkNull(cmmMap.get("menuStyle"),"csh_process");
				String unfold = StringUtil.checkNull(cmmMap.get("unfold"));
				model.put("arcCode", arcCode);
				model.put("menuStyle", menuStyle);
				model.put("unfold", unfold);
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("MainActionController::setTabMenu::Error::"+e.toString().replaceAll("\r|\n", ""));}
			throw new ExceptionUtil(e.toString());
		}	
		return nextUrl(url);
	}
	
	@RequestMapping(value="/viewArcDefPage.do")
	public String viewArcDefPage(HashMap cmmMap,ModelMap model) throws Exception{
		
		String defPage = StringUtil.checkNull(cmmMap.get("arcDefPage"),"processMain");
		String pageUrl = StringUtil.checkNull(cmmMap.get("pageUrl"));
		String defMenuItemID = StringUtil.checkNull(cmmMap.get("defMenuItemID"));
		String arcCode = StringUtil.checkNull(cmmMap.get("arcCode"));
		String scrnUrl = StringUtil.checkNull(cmmMap.get("scrnUrl"));
		
		String url = "/hom/main/arc/"+ defPage;
		
		try{
			Map setMap = new HashMap();
	    	String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),GlobalVal.DEFAULT_LANGUAGE);
	    	setMap.put("languageID", languageID);
	    	
			List nameList = (List)commonService.selectList("custom_SQL.getMainItemName", setMap);			
			model.put("nameList", nameList);		
			model.put("defMenuItemID", defMenuItemID);	
			
			String itemID = StringUtil.checkNull(cmmMap.get("itemID"));	
		    if (itemID != null && itemID != "") {
		    	model.put("defMenuItemID", itemID);	
		     }
			
			model.put("pageUrl", pageUrl);
			model.put("arcCode", arcCode);
			model.put("scrnUrl", scrnUrl);
			
			model.put("showTOJ", StringUtil.checkNull(cmmMap.get("showTOJ")));
			model.put("accMode", StringUtil.checkNull(cmmMap.get("accMode")));
			model.put("showVAR", StringUtil.checkNull(cmmMap.get("showVAR")));
			model.put("objClassList", StringUtil.checkNull(cmmMap.get("objClassList")));
			model.put("nodeID", StringUtil.checkNull(cmmMap.get("nodeID")));
			
			model.put("menu", getLabel(cmmMap, commonService));				
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("MainActionController::setTabMenu::Error::"+e.toString().replaceAll("\r|\n", ""));}
			throw new ExceptionUtil(e.toString());
		}	
		return nextUrl(url);
	}
	
	
	@RequestMapping(value="/mainDefArc.do")
	public String mainDefArc(HttpServletRequest request, HashMap cmmMap,ModelMap model) throws Exception{
		HashMap target = new HashMap();
		try{
				Map setData = new HashMap();
		    	String arcCode = StringUtil.checkNull(request.getParameter("tmplFilter"),"");
		    	String gloProjectID = StringUtil.checkNull(request.getParameter("gloProjectID"),"");
		    	Map pjtInfoMap = new HashMap();
				if(!gloProjectID.equals("") && !gloProjectID.equals("undefind") ){
					setData.put("projectCode", gloProjectID);
					pjtInfoMap = commonService.select("variant_SQL.getPJTInfos", setData);
					
					if(pjtInfoMap != null){		
						setData.put("refPGID", StringUtil.checkNull(pjtInfoMap.get("RefPGID")));
						arcCode = StringUtil.checkNull(commonService.selectString("variant_SQL.getDefArcCode", setData));
					}
				}
				
				setData.put("arcCode", arcCode);
				setData.put("languageID", cmmMap.get("sessionCurrLangType"));
				Map arcInfo = commonService.select("menu_SQL.getArcInfo", setData);
				
				String arcName = StringUtil.checkNull(arcInfo.get("ArcName"));
				String arcUrl = StringUtil.checkNull(arcInfo.get("URL"))+".do?"+StringUtil.checkNull(arcInfo.get("VarFilter"));
				String arcMenuStyle = StringUtil.checkNull(arcInfo.get("MenuStyle"));
				model.put("arcCode", arcCode);
				
				
				
				target.put(AJAX_SCRIPT, "parent.clickMainMenu('"+arcCode+"','"+arcName+"','','','"+arcMenuStyle+"','','"+arcUrl+"');");
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("MainActionController::mainDefArc::Error::"+e.toString().replaceAll("\r|\n", ""));}
			throw new ExceptionUtil(e.toString());
		}	
		model.addAttribute(AJAX_RESULTMAP, target);
		
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/tmplMgt.do")
	public String tmplMgt(ModelMap model, HashMap cmmMap ) throws Exception {
		String dTempleCode = StringUtil.checkNull(cmmMap.get("dTempleCode"),"TMPL001");
		
		String url = "custom/sf/TMPL001";
		try {
			Map resultMap = new HashMap();
			Map<String,List> tmpMap = new HashMap();
			List layerList = commonService.selectList("menu_SQL.mainTempl_select", cmmMap);
			List projectList = commonService.selectList("project_SQL.getMemberProjectList", cmmMap);
			String pjListCnt = StringUtil.checkNull(commonService.selectString("project_SQL.getProjectMemberRelCnt", cmmMap),"0");
			
			model.put("templList", layerList);
			
			model.put("pjtList", projectList);
			
			model.put("langList", commonService.selectList("common_SQL.langType_commonSelect", cmmMap));
			model.put("topMenuList", commonService.selectList("menu_SQL.defaultTopMenu_select", cmmMap));
			model.put("mainMenuList", commonService.selectList("menu_SQL.mainMenu_select", cmmMap));
			model.put("scnMenuList", commonService.selectList("menu_SQL.secondMenu_select", cmmMap));
			model.put("thdMenuList", commonService.selectList("menu_SQL.thirdMenu_select", cmmMap));

			String defaultTempCode = StringUtil.checkNull(commonService.selectString("menu_SQL.getDefaultTemplate", cmmMap));
			String mainType = StringUtil.checkNull(cmmMap.get("mainType")); 
			if(mainType.equals("pjt")){defaultTempCode="TMPL003";}

			List cmpnyList = commonService.selectList("menu_SQL.company_select", cmmMap);
			String isCmpnyView = "N";
			String isCmpnySelect = "N";
			if(cmpnyList != null && cmpnyList.size() > 0 && StringUtil.checkNull(GlobalVal.MULTI_COMPANY, "N").equals("Y")){
				isCmpnyView = "Y";
				model.put("cmpnyList", cmpnyList);
				//ADMIN인 경우만 선택
				if(StringUtil.checkNull(cmmMap.get("sessionAuthLev"),"").equals("1")){isCmpnySelect="Y";}
			}			
			model.put("isCmpnyView", isCmpnyView);
			model.put("isCmpnySelect", isCmpnySelect);
			model.put("cmpnyCode", StringUtil.checkNull(cmmMap.get("sessionCompanyId"),""));
			model.put("cmpnyText", StringUtil.checkNull(cmmMap.get("sessionCompanyNm"),""));
			
			String glo_project_id = StringUtil.checkNull(cmmMap.get("sessionGloProjectId"));
			
			int maxtmpTxtLng=0; 
			if( layerList.size() > 0){
				float tmpTxtLng1=0; int tmpTxtLng2=0;String templText="";
				float cmpnyTxtLng1=0; int cmpnyTxtLng2=0;String cmpnyText="";
				for(int i=0;i<layerList.size();i++){
					tmpTxtLng1=0;
					cmpnyTxtLng1=0;
					Map layerInfo = (HashMap) layerList.get(i);				
					templText=StringUtil.checkNull(layerInfo.get("TemplText"),"");
					
					if(StringUtil.checkNull(("sessionCurrLangType")).equals("1033")){tmpTxtLng1=templText.getBytes("utf-8").length;tmpTxtLng1=Math.round(tmpTxtLng1*1.3);}
					else{					
						for(int j=0;j<templText.length();j++){
							if((templText.charAt(j)==' ')||(templText.charAt(j)=='/')||(templText.charAt(j)>='a'&&templText.charAt(j)<='z')){tmpTxtLng1+=1.5;}
							else if((templText.charAt(j)>='A'&&templText.charAt(j)<='Z')){tmpTxtLng1+=2;}
							else{tmpTxtLng1+=2.7;}
						}
					}
					//if(tmpTxtLng2>tmpTxtLng1){tmpTxtLng1=tmpTxtLng2;}
					if(tmpTxtLng1>maxtmpTxtLng){maxtmpTxtLng=Math.round(tmpTxtLng1);}
					if(!"".equals(dTempleCode) && dTempleCode.equals(StringUtil.checkNull(layerInfo.get("TemplCode"),""))){					
						model.put("templCode", StringUtil.checkNull(layerInfo.get("TemplCode"),""));
						model.put("templText", templText);
						model.put("mainURL", StringUtil.checkNull(layerInfo.get("MainURL"),""));
						model.put("mainScnText", StringUtil.checkNull(layerInfo.get("MainScnText"),""));
						model.put("mainUrlFilter", StringUtil.checkNull(layerInfo.get("URLFilter"),""));
						model.put("tmplFilter", StringUtil.checkNull(layerInfo.get("TmplFilter"),""));
						String tmplFilter = StringUtil.checkNull(layerInfo.get("TmplFilter"));
						if(tmplFilter.contains("mstScrn")) url = tmplFilter.replaceAll("&mstScrn=", "");
					}
					else if (i==0 && "".equals(dTempleCode)){
						model.put("templCode", StringUtil.checkNull(layerInfo.get("TemplCode"),""));
						model.put("mainURL", StringUtil.checkNull(layerInfo.get("MainURL"),""));
						model.put("mainScnText", StringUtil.checkNull(layerInfo.get("MainScnText"),""));
						model.put("mainUrlFilter", StringUtil.checkNull(layerInfo.get("URLFilter"),""));
						model.put("tmplFilter", StringUtil.checkNull(layerInfo.get("TmplFilter"),""));
					}
					
					if(StringUtil.checkNull(layerInfo.get("TemplCode"),"").equals("MYPAGE")){
						model.put("myPageTmplFilter", StringUtil.checkNull(layerInfo.get("TmplFilter"),""));
					}
					
				}
			}else{
				model.put("templCode", "");
				model.put("templText", "");
				model.put("mainURL", "");
				model.put("mainScnText", "");
				model.put("mainUrlFilter", "");
				model.put("tmplFilter", "");
			}
			HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
			HttpSession session = request.getSession(true);  // 세션 생성 
			String gloProjectCode = StringUtil.checkNull(request.getParameter("gloProjectID"));
			String gloProjectID = "";
			Map setData = new HashMap();
			setData.put("projectCode", gloProjectCode);
			Map pjtInfoMap = commonService.select("variant_SQL.getPJTInfos", setData);
			if(pjtInfoMap != null && !pjtInfoMap.isEmpty()){ gloProjectID = StringUtil.checkNull(pjtInfoMap.get("ProjectID"));  }
			if( projectList.size() > 0){
				String projectName="";
				String projectID="";
				String projectCode="";
				for(int i=0;i<projectList.size();i++){
					Map projectInfo = (HashMap) projectList.get(i);				
					projectName=StringUtil.checkNull(projectInfo.get("ProjectName"),"");
					projectCode=StringUtil.checkNull(projectInfo.get("ProjectCode"),"");
					projectID=StringUtil.checkNull(projectInfo.get("ProjectID"),"");
					
					if(!"".equals(gloProjectID) && projectID.equals(gloProjectID)) {
						model.put("projectTxt", projectCode + " " + projectName);
						model.put("projectID", projectID);
						break;
					}else{
						if(!"".equals(glo_project_id) && projectID.equals(glo_project_id)) {
							model.put("projectTxt", projectCode + " " + projectName);
							model.put("projectID", projectID);
							break;
						}
						else if("".equals(glo_project_id) && i==0) {
							model.put("projectTxt", "Select Project");
							model.put("projectID", "");
							break;
						}
					}
				}
			}else{
				model.put("projectTxt", "Select Project");
				model.put("projectID", "");
			}
			
			model.put("tmpTextMaxLng",(maxtmpTxtLng*5));
			
			int maxcmpyTxtLng=0; 
			if( cmpnyList.size() > 0){
				float cmpnyTxtLng1=0; int cmpnyTxtLng2=0;String cmpnyText="";
				for(int i=0;i<cmpnyList.size();i++){
					cmpnyTxtLng1=0;
					Map cmpyInfo = (HashMap) cmpnyList.get(i);				
					cmpnyText=StringUtil.checkNull(cmpyInfo.get("CmpnyText"),"");
					
					if(StringUtil.checkNull(("sessionCurrLangType")).equals("1033")){cmpnyTxtLng1=cmpnyText.getBytes("utf-8").length;cmpnyTxtLng1=Math.round(cmpnyTxtLng1*1.3);}
					else{					
						for(int j=0;j<cmpnyText.length();j++){
							if((cmpnyText.charAt(j)==' ')||(cmpnyText.charAt(j)=='/')||(cmpnyText.charAt(j)>='a'&&cmpnyText.charAt(j)<='z')){cmpnyTxtLng1+=1.5;}
							else if((cmpnyText.charAt(j)>='A'&&cmpnyText.charAt(j)<='Z')){cmpnyTxtLng1+=2;}
							else{cmpnyTxtLng1+=2.7;}
						}
					}
					//if(tmpTxtLng2>tmpTxtLng1){tmpTxtLng1=tmpTxtLng2;}
					if(cmpnyTxtLng1>maxcmpyTxtLng){maxcmpyTxtLng=Math.round(cmpnyTxtLng1);}
					//System.out.println("txt::"+cmpnyText+", leng="+cmpnyText.length()+",tmpTxtLng::"+cmpnyTxtLng1+","+cmpnyTxtLng2+","+maxcmpyTxtLng);
				}
			}
			model.put("cmpnyTextMaxLng",(maxcmpyTxtLng*5));		
			
			Map pnSetMap = new HashMap();

			pnSetMap.put("sessionCurrLangType", cmmMap.get("sessionCurrLangType"));
			pnSetMap.put("sessionTemplCode", dTempleCode);
			
			Map pnTempMap = commonService.select("main_SQL.getPjtInfoFromTEMPL", pnSetMap);	

			if(!"0".equals(pnTempMap.get("ProjectID").toString())) {
				model.put("projectName", pnTempMap.get("Name"));
				model.put("projectID", pnTempMap.get("ProjectID"));
			}
			
			//최근공지사항 조회--START
			Map setMap = new HashMap();
			setMap.put("viewType", "pop");
			cmmMap.put("TemplCode",defaultTempCode);
			Map projectInfoMap = commonService.select("main_SQL.getPjtInfoFromTEMPL", cmmMap);	
			setMap.put("projectID", projectInfoMap.get("ProjectID"));	

			
			int ntcCnt=NumberUtil.getIntValue(commonService.selectString("board_SQL.boardTotalCnt", setMap));

			if(ntcCnt>0){Map getMap = commonService.select("board_SQL.boardDetail", setMap);model.put("BoardID", StringUtil.checkNull(getMap.get("BoardID"),""));}
			model.put("ntcCnt", ntcCnt);
			//최근공지사항 조회--END			
			model.addAttribute(HTML_HEADER, "초기화면");
			model.addAttribute(AJAX_RESULTMAP,tmpMap);
			model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx")));
			model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType")));
			
			if(mainType.equals("mySRDtl")){ // From Email 접수 
				Map getSRInfo = commonService.select("sr_SQL.getSRInfo", cmmMap);
				String sessionUserID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
				String receiptUserID = StringUtil.checkNull(getSRInfo.get("ReceiptUserID"));			
				if(!sessionUserID.equals(receiptUserID)){ // 로그인User!=접수자 
					mainType = "SRDtlView";
				}
			}
			// Visit Log
			cmmMap.put("ActionType","LOGIN");
			 String ip = request.getHeader("X-FORWARDED-FOR");
	        if (ip == null)
	            ip = request.getRemoteAddr();
	        cmmMap.put("IpAddress",ip);
	        
			commonService.insert("gloval_SQL.insertVisitLog", cmmMap);
			model.put("mainType", mainType);
			model.put("srID", StringUtil.checkNull(cmmMap.get("srID")));
			model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode")));
			model.put("proposal", StringUtil.checkNull(cmmMap.get("proposal")));
			model.put("status", StringUtil.checkNull(cmmMap.get("status")));
			model.put("gloProjectID", StringUtil.checkNull(request.getParameter("gloProjectID")));
			model.put("focusedItemID", StringUtil.checkNull(request.getParameter("focusedItemID")));
		}
		catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("MainActionController::mainpage::Error::"+e.toString().replaceAll("\r|\n", ""));}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}	
	
	@RequestMapping(value="/checkOlmService.do") // @RequestMapping(value="/hec/checkOlmService.do") // hway xbolt.jar version 
	@ResponseBody
	@ResponseStatus(HttpStatus.OK)
	public String checkOlmService() throws Exception {
		Map setData = new HashMap();
		String defLanguage = commonService.selectString("item_SQL.getDefaultLang", setData);
		return "Application is running[return value : "+defLanguage+"].";
	}
	
	@RequestMapping(value="/checkIPforTmpl.do")  
	public void checkIPforTmpl(HttpServletResponse response, HashMap cmmMap) throws Exception {
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		
		String ip = request.getHeader("X-FORWARDED-FOR");
        if (ip == null) ip = request.getRemoteAddr();
        
        /*
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null) {
            ip = request.getRemoteAddr();
        }
        */
        
        // IP Check
        Map setMap = new HashMap();
        setMap.put("userID", StringUtil.checkNull(cmmMap.get("sessionUserId")));
        String emailDomain = StringUtil.checkNull(commonService.selectString("user_SQL.userEmailDomain", setMap));
		
        String result = "false";
        if(emailDomain.equals(ip)){
        	result = "true"; 
        }
        
        JSONObject jsonData = new JSONObject();
        jsonData.put("result", result);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        out.print(jsonData);
        out.flush();
	}
}
