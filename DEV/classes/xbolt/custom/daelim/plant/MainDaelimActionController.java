package xbolt.custom.daelim.plant;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.service.CommonService;
import xbolt.custom.cj.util.CryptoUtil;

/**
 * 공통 서블릿 처리
 * @Class Name : MainCJActionController.java
 * @Description : 공통화면을 제공한다.
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2016. 12. 14. smartfactory		최초생성
 *
 * @since 2016. 12. 14.
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class MainDaelimActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;

	@RequestMapping(value="/setDaelimTemplate.do")
	public String setDaelimTemplate(ModelMap model, HashMap cmmMap) throws Exception {
		String dTempleCode = StringUtil.checkNull(cmmMap.get("dTempleCode"),"TMPL001");
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
					//System.out.println("txt::"+templText+", leng="+templText.length()+",tmpTxtLng::"+tmpTxtLng1+","+tmpTxtLng2+","+maxtmpTxtLng);
					//System.out.println("defaultTempCode:"+defaultTempCode);
//					if(defaultTempCode.equals(StringUtil.checkNull(layerInfo.get("TemplCode"),""))){
//						model.put("templCode", StringUtil.checkNull(layerInfo.get("TemplCode"),""));
//						model.put("templText", templText);
//						model.put("mainURL", StringUtil.checkNull(layerInfo.get("MainURL"),""));
//						model.put("mainScnText", StringUtil.checkNull(layerInfo.get("MainScnText"),""));
//						model.put("mainUrlFilter", StringUtil.checkNull(layerInfo.get("URLFilter"),""));
//						model.put("tmplFilter", StringUtil.checkNull(layerInfo.get("TmplFilter"),""));
//						if(mainType.equals("pjt")){
//							String projectID = commonService.selectString("project_SQL.getProjectID", cmmMap);
//							model.put("mainURL","pjtTemplate");
//							model.put("projectID", projectID);
//						}
//					}else if(defaultTempCode.equals("")){
						if(!"".equals(dTempleCode) && dTempleCode.equals(StringUtil.checkNull(layerInfo.get("TemplCode"),""))){					
							model.put("templCode", StringUtil.checkNull(layerInfo.get("TemplCode"),""));
							model.put("templText", templText);
							model.put("mainURL", StringUtil.checkNull(layerInfo.get("MainURL"),""));
							model.put("mainScnText", StringUtil.checkNull(layerInfo.get("MainScnText"),""));
							model.put("mainUrlFilter", StringUtil.checkNull(layerInfo.get("URLFilter"),""));
							model.put("tmplFilter", StringUtil.checkNull(layerInfo.get("TmplFilter"),""));
						}
						else if (i==0 && "".equals(dTempleCode)){
							model.put("templCode", StringUtil.checkNull(layerInfo.get("TemplCode"),""));
							model.put("mainURL", StringUtil.checkNull(layerInfo.get("MainURL"),""));
							model.put("mainScnText", StringUtil.checkNull(layerInfo.get("MainScnText"),""));
							model.put("mainUrlFilter", StringUtil.checkNull(layerInfo.get("URLFilter"),""));
							model.put("tmplFilter", StringUtil.checkNull(layerInfo.get("TmplFilter"),""));
						}
//					}
					
					if(StringUtil.checkNull(layerInfo.get("TemplCode"),"").equals("MYPAGE")){
						model.put("myPageTmplFilter", StringUtil.checkNull(layerInfo.get("TmplFilter"),""));
					}
					
			}}else{
					model.put("templCode", "");
					model.put("templText", "");
					model.put("mainURL", "");
					model.put("mainScnText", "");
					model.put("mainUrlFilter", "");
					model.put("tmplFilter", "");
				}
			HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
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
			if(_log.isInfoEnabled()){_log.info("MainActionController::mainpage::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("custom/daelim/"+dTempleCode);
	}	

	@RequestMapping(value="/projectSetting.do")
	public String projectSetting(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		Map target = new HashMap();
		try{ 			
			String projectID = StringUtil.checkNull(cmmMap.get("projectID").toString());
			
			HttpSession session = request.getSession(true);			
			//선택한 회사 선언  -> Session에 저장
			Map loginInfo = (Map)session.getAttribute("loginInfo");
			loginInfo.put("glo_project_id", projectID);
			session.setAttribute("loginInfo", loginInfo);
			

			Map setData = new HashMap();
			setData.put("projectID", projectID);
			setData.put("sessionUserId", loginInfo.get("sessionUserId"));
			setData.put("sessionCurrLangType", loginInfo.get("sessionCurrLangType"));
			String projectText = commonService.selectString("project_SQL.getMemberProjectText", setData);
			
			
			target.put(AJAX_SCRIPT, "parent.changePjtTxt('"+projectText+"');");
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("CmmActionController::companySetting::Error::"+e);}
			throw e;
		}		
		
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}	
	
	@RequestMapping(value="/indexIEP.do")
	public String indexIEP(Map cmmMap,ModelMap model, HttpServletRequest request) throws Exception {
		try{
			String language =  StringUtil.checkNull(request.getParameter("language"));
			
			String GUID = StringUtil.checkNull(request.getParameter("GUID"));
			Map setMap = new HashMap();
			
			setMap.put("GUID", GUID);
			Map uInfoMap = commonService.select("custom_SQL.zdaelim_getLoginInfo", cmmMap);
			
			if(uInfoMap != null && !uInfoMap.isEmpty() && "R".equals(uInfoMap.get("CL_HNDL"))) {
				String employeeNum = StringUtil.checkNull(uInfoMap.get("ID_RQST"));
				setMap.put("employeeNum", employeeNum);
				Map userMap = commonService.select("common_SQL.getLoginIDFromMember", setMap);
				
				model.put("loginID", userMap.get("LoginId"));
				model.put("olmI", userMap.get("LoginId"));
				String CD_RQST = StringUtil.checkNull(uInfoMap.get("CD_RQST"));
				
				String[] projectInfo = CD_RQST.split("\\^"); 
				model.put("gloProjectID", projectInfo[1]);
			}
			else {
				model.put("loginID", "");
				model.put("gloProjectID", "");
				model.put("olmI", "");
			}
			
			model.put("language", language);				
		
		}catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("MainDaelimActionController::indexIEP::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl("indexIEP");
	}	
	
	// 외부시스템에서 OLM Item 호출 
		@RequestMapping(value="/zDli2Olm.do")
		public String zDli2Olm(Map cmmMap, ModelMap model) throws Exception {
			String url = "/custom/daelim/plant/olmLinkPopup";
			String loginid = "";
			String defaltLangCode = GlobalVal.DEFAULT_LANG_CODE;
			
			String GUID = StringUtil.checkNull(cmmMap.get("GUID"));
			Map setMap = new HashMap();
			
			setMap.put("GUID", GUID);
			if(GUID.equals("guest")) {
				model.put("loginid", GUID);
			}else{
				Map uInfoMap = commonService.select("custom_SQL.zdaelim_getLoginInfo", cmmMap);
				/* TEST
				Map uInfoMap = new HashMap();
				uInfoMap.put("CL_HNDL", "R");
				uInfoMap.put("ID_RQST", "20110580"); //김영욱사번
				uInfoMap.put("CD_RQST", "BIM^160082"); //type^projectCode
				*/
				if(uInfoMap != null && !uInfoMap.isEmpty() && "R".equals(uInfoMap.get("CL_HNDL"))) {
					String employeeNum = StringUtil.checkNull(uInfoMap.get("ID_RQST"));
					setMap.put("employeeNum", employeeNum);
					Map userMap = commonService.select("common_SQL.getLoginIDFromMember", setMap);
					loginid = StringUtil.checkNull(userMap.get("LoginId"));
					String CD_RQST = StringUtil.checkNull(uInfoMap.get("CD_RQST"));
					String[] projectInfo = CD_RQST.split("\\^"); 
					model.put("gloProjectID", projectInfo[1]);
					model.put("loginid", loginid);
				}else {
					model.put("loginID", "");
					model.put("gloProjectID", "");
				}
			}
			
			
			model.put("DEFAULT_LANG_CODE", defaltLangCode);
			System.out.println("***olmLinkPopup::"+url+"???loginid="+loginid);
			return nextUrl(url);
		}
	
}
