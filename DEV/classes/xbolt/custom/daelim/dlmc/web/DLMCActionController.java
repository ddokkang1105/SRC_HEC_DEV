
package xbolt.custom.daelim.dlmc.web;

import java.net.URLEncoder;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.org.json.JSONArray;
import com.rathontech2018.sso.sp.agent.web.WebAgent;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

/**
 * @Class Name : DLMCActionController.java
 * @Description : DLMCActionController.java
 * @Modification Information
 * @수정일 수정자 수정내용 @--------- --------- ------------------------------- @2023. 09.
 *      19. smartfactory 최초생성
 *
 * @since 2023. 09. 19.
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings({ "unchecked", "unused" })
public class DLMCActionController extends XboltController {
	private final Log _log = LogFactory.getLog(this.getClass());

	@Resource(name = "commonService")
	private CommonService commonService;

	@RequestMapping(value = "/custom/dlmc/logindlmcForm.do")
	public String logindlmcForm(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		model = setLoginScrnInfo(model, cmmMap);
		model.put("screenType", cmmMap.get("screenType"));
		model.put("mainType", cmmMap.get("mainType"));
		model.put("srID", cmmMap.get("srID"));
		model.put("sysCode", cmmMap.get("sysCode"));
		model.put("proposal", cmmMap.get("proposal"));
		model.put("status", cmmMap.get("status"));
		
		return nextUrl("/custom/daelim/dlmc/login");
	}

	@RequestMapping(value = "/custom/dlmc/logindlmc.do")
	public String logindlmc(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		try {
			
			HttpSession session = request.getSession(true);
			Map resultMap = new HashMap();
			String langCode = GlobalVal.DEFAULT_LANG_CODE;
			String languageID = StringUtil.checkNull(cmmMap.get("LANGUAGE"),
					StringUtil.checkNull(cmmMap.get("LANGUAGEID")));
			if (languageID.equals("")) {
				languageID = GlobalVal.DEFAULT_LANGUAGE;
			}

			cmmMap.put("LANGUAGE", languageID);
			String ref = request.getHeader("referer");
			//String protocol = request.isSecure() ? "https://" : "http://";

			String IS_CHECK = GlobalVal.PWD_CHECK;
			String url_CHECK = StringUtil.chkURL(ref, "https");

			if ("".equals(IS_CHECK))
				IS_CHECK = "Y";

			if ("".equals(url_CHECK)) {
				resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
				resultMap.put(AJAX_ALERT,
						"Your ID does not exist in our system. Please contact system administrator(DL Chemical).");
			} else {

				Map idInfo = new HashMap();

				if ("Y".equals(IS_CHECK) && "login".equals(url_CHECK)) {
					cmmMap.put("IS_CHECK", "Y");
				} else {
					cmmMap.put("IS_CHECK", "N");
				}

				idInfo = commonService.select("login_SQL.login_id_select", cmmMap);

				if (idInfo == null || idInfo.size() == 0) {
					resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
					// resultMap.put(AJAX_ALERT, "해당아이디가 존재하지 않습니다.");
					resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00002"));
				} else {
					cmmMap.put("LOGIN_ID", idInfo.get("LoginId")); // parameter LOGIN_ID 는 사번이므로 조회한 LOGINID로 put
					Map loginInfo = commonService.select("login_SQL.login_select", cmmMap);
					if (loginInfo == null || loginInfo.size() == 0) {
						resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
						// resultMap.put(AJAX_ALERT, "System에 해당 사용자 정보가 없습니다.등록 요청바랍니다.");
						resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00102"));
					} else {
						// [Authority] < 4 인 경우, 수정가능하게 변경
						if (loginInfo.get("sessionAuthLev").toString().compareTo("4") < 0)
							loginInfo.put("loginType", "editor");
						else
							loginInfo.put("loginType", "viewer");
						resultMap.put(AJAX_SCRIPT, "parent.fnReload('Y')");
						// resultMap.put(AJAX_MESSAGE, "Login성공");
						session.setAttribute("loginInfo", loginInfo);
					}
				}
				model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx"))); // singleSignOn 구분
				model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType")));
				model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType")));
				model.put("srID", StringUtil.checkNull(cmmMap.get("srID")));
				model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode")));
				model.addAttribute(AJAX_RESULTMAP, resultMap);
			}
		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("LoginActionController::loginbase::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}

	private ModelMap setLoginScrnInfo(ModelMap model, HashMap cmmMap) throws Exception {
		String pass = StringUtil.checkNull(cmmMap.get("pwd"));
		model.addAttribute("loginid", StringUtil.checkNull(cmmMap.get("loginid"), ""));
		model.addAttribute("pwd", pass);
		model.addAttribute("lng", StringUtil.checkNull(cmmMap.get("lng"), ""));

		if (_log.isInfoEnabled()) {
			_log.info("setLoginScrnInfo : loginid=" + StringUtil.checkNull(cmmMap.get("loginid")) + ",pass"
					+ URLEncoder.encode(pass) + ",lng=" + StringUtil.checkNull(cmmMap.get("lng")));
		}
		List langList = commonService.selectList("common_SQL.langType_commonSelect", cmmMap);
		if (langList != null && langList.size() > 0) {
			for (int i = 0; i < langList.size(); i++) {
				Map langInfo = (HashMap) langList.get(i);
				if (langInfo.get("IsDefault").equals("1")) {
					model.put("langType", StringUtil.checkNull(langInfo.get("CODE"), ""));
					model.put("langName", StringUtil.checkNull(langInfo.get("NAME"), ""));
				}
			}
		} else {
			model.put("langType", "");
			model.put("langName", "");
		}
		model.put("langList", langList);
		model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx"))); // singleSignOn 구분
		return model;
	}

	@RequestMapping(value = "/custom/indexDLMC.do")
	public String indexDLMC(Map cmmMap, ModelMap model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		try {
            
			HttpSession session = request.getSession(true);

			response.setHeader("cache-control", "no-cache");
			response.setHeader("expires", "0");
			response.setHeader("pragma", "no-cache");

			// 환경설정 시작
			// String SSO_URL = "https://gw.daelimcloud.com/WebSite/Login.aspx";
			// 환경설정 끝

			// 기본변수 끝
			String ssoEmp = "";
			String olmI = "";

			// 인증 시작
			WebAgent agent = new WebAgent(); // agent 호출
			agent.requestAuthentication(request, response);

			ssoEmp = StringUtil.checkNull(session.getAttribute("RathonSSO_PERSON_NO"));// 사원번호
			// ssoEmp 없으면 sso 로그인 페이지
			if (!"".equals(ssoEmp) && ssoEmp != null) {
				/*
				 * if(agent.requestAuthentication(request, response,false)){ 
				 * //인증처리 필요 (DL 그룹웨어로
				 * 이동) if(!response.isCommitted()) { //response.sendRedirect(SSO_URL); } } else
				 * {
				 * 
				 * }
				 */
				// SSO 인증완료
				olmI = ssoEmp;
			}

			model.put("olmI", olmI);
			model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType"), ""));
			model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType"), ""));
			model.put("srID", StringUtil.checkNull(cmmMap.get("srID"), ""));
			model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode"), ""));
			model.put("proposal", StringUtil.checkNull(cmmMap.get("proposal"), ""));
			model.put("status", StringUtil.checkNull(cmmMap.get("status"), ""));

		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("DLMCActionController::mainpage::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/indexDLMC");
	}

	@RequestMapping(value = "/mainHomeDLMC.do")
	public String mainHomeDLMC(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception {
		model.put("menu", getLabel(request, commonService));
		return nextUrl("/custom/dlmc/mainHomeDLMC");
	}

	// 개발 진행중

	//@Resource(name="orclSession")
	//private SqlSession orclSession;

	//@Resource(name="sqlSession")
	//private SqlSession sqlSession;
	/*	
	@RequestMapping(value="/custom/zDLMC_exeSYSinterface.do")
	public void exeHRinterface(HttpServletRequest request) throws Exception {
		HashMap setMap = new HashMap();
		System.out.println("start zDLMC_exeERPinterface");
		try {
			
			Map setdata = new HashMap();
			HttpSession session = request.getSession(true);
			// 주석해제하여 패치
			
			String language = GlobalVal.DEFAULT_LANGUAGE;
			if(session.getAttribute("loginInfo") == null) {
				setdata.put("LOGIN_ID", "sys");
				setdata.put("IS_CHECK", "N");
				setdata.put("LANGUAGE", language);	
				Map loginInfo = commonService.select("login_SQL.login_select", setdata);
			}
			
			// 1. TRUNCATE Z_PAL_DEPT && Z_PAL_EMP
			commonService.delete("custom_SQL.zDLMC_deleteTemp", setMap);
			
			// 2. INSERT Z_PAL_DEPT
			List deptList = orclSession.selectList("daelim_ORASQL.dlmc_selectDeptList",setMap);
			for(int i=0; i<deptList.size(); i++) {
				setMap = (HashMap) deptList.get(i);
				commonService.insert("custom_SQL.zDLMC_insertDept",setMap);
			}
			
			// 3. INSERT Z_PAL_EMP
			List empList = orclSession.selectList("daelim_ORASQL.dlmc_selectEmpList",setMap);
			for(int i=0; i<empList.size(); i++) {
				setMap = (HashMap) empList.get(i);
				commonService.insert("custom_SQL.zDLMC_insertEmp",setMap);
			}
			
			// 4. EXE HR_IF
			String procedureName = "XBOLTADM.HR_IF_STD";
			setMap.put("procedureName", procedureName);
			commonService.insert("organization_SQL.insertHRTeamInfo", setMap);
			
			
			System.out.println("end zDLMC_exeERPinterface");
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
	}
*/
	@RequestMapping(value = "/zDlmcMain.do")
	public String zDlmcMain(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception {

		String url = "/custom/daelim/dlmc/zDlmcMain";

		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
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
							.checkNull(commonService.selectString("item_SQL.getItemCntByItemType", setMap));

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
			setMap.put("BoardMgtID", "BRD0002");

			List myBrdList = commonService.selectList("forum_SQL.forumGridList_gridList", setMap);
			model.put("myBrdList", myBrdList);

			model.put("srType", request.getParameter("srType"));
			model.put("viewItemTypeList", viewItemTypeList);
			model.put("languageID", languageID);

			// 시스템 날짜
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
			model.put("clsEndDt", thisYmd);

			cal.add(Calendar.DATE, -90);
			String lastYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
			model.put("clsStartDt", lastYmd);

			setMap.put("itemClassCode", "CL01005");
			setMap.put("ChangeType", "DEL");
			String L4ProcessCount = commonService.selectString("item_SQL.Zdlmc_getProcessCount", setMap);

			setMap.put("itemClassCode", "CL01006");
			String L5ActivityCount = commonService.selectString("item_SQL.Zdlmc_getProcessCount", setMap);
			
			model.put("L4ProcessCount", L4ProcessCount);
			model.put("L5ActivityCount", L5ActivityCount);
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		model.put("menu", getLabel(request, commonService)); // Label Setting
		model.put("screenType", request.getParameter("screenType"));
		return nextUrl(url);
	}

	@RequestMapping("/custom/zDlmc_InboundLink.do")
	public String zDlmc_InboundLink(HttpServletRequest request, HttpServletResponse response, HashMap commandMap,
			ModelMap model) throws Exception {
		String url = "/template/olmLinkPopup";
		try {

			HttpSession session = request.getSession(true);

			response.setHeader("cache-control", "no-cache");
			response.setHeader("expires", "0");
			response.setHeader("pragma", "no-cache");

			String ssoEmp = "";
			String logonId = "";

			// 인증 시작
			WebAgent agent = new WebAgent(); // agent 호출
			agent.requestAuthentication(request, response);

			ssoEmp = StringUtil.checkNull(session.getAttribute("RathonSSO_PERSON_NO"));

			// ssoEmp 없으면 sso 로그인 페이지
			if (!"".equals(ssoEmp) && ssoEmp != null) {
				if (agent.requestAuthentication(request, response, false)) {
					// 인증처리 필요 (DL 그룹웨어로 이동)
					if (!response.isCommitted()) {
						url = "/index";
					}
				} else {
					// SSO 인증완료
					logonId = ssoEmp;

					Map setData = new HashMap();
					Map userInfo = new HashMap();
					setData.put("employeeNum", logonId);
					userInfo = commonService.select("common_SQL.getLoginIDFromMember", setData);

					if (userInfo != null && !userInfo.isEmpty()) {
						String activeYN = "N";
						HashMap setInfo = new HashMap();

						setInfo.put("LOGIN_ID", StringUtil.checkNull(userInfo.get("LoginId")));

						activeYN = commonService.selectString("login_SQL.login_active_select", setInfo);
						if (!"Y".equals(activeYN)) {
							url = "/index";
						}

						model.put("olmI", StringUtil.checkNull(userInfo.get("LoginId")));
						model.put("loginid", StringUtil.checkNull(userInfo.get("LoginId")));
					}

					String languageID = StringUtil.checkNull(request.getParameter("languageID"));
					if (languageID.equals("")) {
						languageID = GlobalVal.DEFAULT_LANGUAGE;
					}

					model.put("languageID", languageID);
					model.put("keyId", StringUtil.checkNull(request.getParameter("keyId"), ""));
					model.put("object", StringUtil.checkNull(request.getParameter("object"), ""));
					model.put("linkType", StringUtil.checkNull(request.getParameter("linkType"), ""));
					model.put("linkID", StringUtil.checkNull(request.getParameter("linkID"), ""));
					model.put("iType", StringUtil.checkNull(request.getParameter("iType"), ""));
					model.put("aType", StringUtil.checkNull(request.getParameter("aType"), ""));
					model.put("option", StringUtil.checkNull(request.getParameter("option"), ""));
					model.put("type", StringUtil.checkNull(request.getParameter("type"), ""));
					model.put("changeSetID", StringUtil.checkNull(request.getParameter("changeSetID"), ""));
					model.put("projectType", StringUtil.checkNull(request.getParameter("projectType"), ""));
					model.put("olmLng", StringUtil.checkNull(request.getParameter("olmLng"), ""));
					model.put("screenType", StringUtil.checkNull(request.getParameter("screenType"), ""));
					model.put("mainType", StringUtil.checkNull(request.getParameter("mainType"), ""));
				}
			} else {
				url = "/index";
			}

		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl(url);
	}

	// 사용자별 활용 통계 
	@RequestMapping(value = "/zDlmc_UserLogStta.do")
	public String zDlmc_UserLogStta(HttpServletRequest request, ModelMap model) throws Exception {
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		

			Map setMap = new HashMap();

			String languageID = StringUtil.checkNull(request.getParameter("languageID"));
			if (languageID.equals("")) {
				languageID = GlobalVal.DEFAULT_LANGUAGE;
			}
			setMap.put("languageID", languageID);


			// 기간설정
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());

			// 30일 전으로 날짜를 이동
			cal.add(Calendar.DATE, -30);
			String beforeYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());

			String scStartDt = StringUtil.checkNull(request.getParameter("REQ_STR_DT"), beforeYmd);
			String scEndDt = StringUtil.checkNull(request.getParameter("REQ_END_DT"), thisYmd);

			model.put("beforeYmd", scStartDt);
			model.put("thisYmd", scEndDt);
		
			 setMap.put("StartDt",scStartDt);
		     setMap.put("EndDt", scEndDt);
			//신규 그리드 Dhtmlx7v 업데이트 로직
			List usrSttaList = commonService.selectList("custom_SQL.zDlmc_getLUserLogStta_gridList", setMap);
			JSONArray gridData = new JSONArray(usrSttaList); //데이터 넘겨줌 
			model.put("gridData", gridData);
			
			

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/custom/daelim/dlmc/report/zDlmc_UserLogStta");
	}

	// 프로세스 현황 리포트 
	@RequestMapping(value = "/zDlmc_ProcessLogStta.do")
	public String zDlmc_ProcessLogStta(HttpServletRequest request, ModelMap model) throws Exception {
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		

			Map setMap = new HashMap();

			String languageID = StringUtil.checkNull(request.getParameter("languageID"));
			if (languageID.equals("")) {
				languageID = GlobalVal.DEFAULT_LANGUAGE;
			}
			setMap.put("languageID", languageID);


		
			// 기간설정
			
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());

			// 30일 전으로 날짜를 이동
			cal.add(Calendar.DATE, -30);
			String beforeYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());

			String scStartDt = StringUtil.checkNull(request.getParameter("REQ_STR_DT"), beforeYmd);
			String scEndDt = StringUtil.checkNull(request.getParameter("REQ_END_DT"), thisYmd);

			model.put("beforeYmd", scStartDt);
			model.put("thisYmd", scEndDt);
	        setMap.put("StartDt",scStartDt);
	        setMap.put("EndDt", scEndDt);

			//신규 그리드 Dhtmlx7v 업데이트 로직
			List procList = commonService.selectList("custom_SQL.zDlmc_ProcessLogStta_gridList", setMap);
			JSONArray gridData = new JSONArray(procList); //데이터 넘겨줌 
			model.put("gridData", gridData);
			
			//System.out.println("GRIDDATA : "+gridData);
			
			

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/custom/daelim/dlmc/report/zDlmc_ProcessLogStta");
	}
	  @RequestMapping(value="/zDlmc_downloadAllProcData.do")
		public String zDlmc_downloadAllProcData(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
			model.put("s_itemID", commandMap.get("s_itemID"));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		

			commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
			
			List ddList = commonService.selectList("custom_SQL.zDlmc_getAllProcessList_gridList",commandMap);
			JSONArray gridData = new JSONArray(ddList);
			model.put("gridData",gridData);
			
			return nextUrl("/custom/daelim/dlmc/report/zDlmc_downloadAllProcData");
		}
	  
	  //valueChain별 통계 그래프
		@RequestMapping(value = "/zdlmcMainSttProcessBarChart.do")
		public String zdlmcmainSttProcessBarChart(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
			try {
				
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				
				cmmMap.put("ClassCode", "CL01005");
				// value chain별 프로세스 폐기제외하고 적용 
				List valProcList = commonService.selectList("custom_SQL.ZdlmcProcessStt_chart", cmmMap);
				
				JSONArray valProcListData = new JSONArray(valProcList);
				model.put("valProcListData", valProcListData);

			} catch (Exception e) {
				System.out.println(e);
				throw new ExceptionUtil(e.toString());
			}
			return nextUrl("/custom/daelim/dlmc/report/zdlmcMainSttProcessBarChart");
		}
		
	  
	  
}
