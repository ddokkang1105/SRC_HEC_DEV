package xbolt.custom.daelim.itsm ;


import java.io.BufferedReader;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import com.org.json.JSONObject;

import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.service.CommonService;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.type.TypeReference;
import org.apache.ibatis.session.SqlSession;

/**
 * 
 * @Class Name : CCActionController.java
 * @Description : Daelim Call Center Action Controller
 * @since 2024. 12. 31.
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class CCActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	// TODO : 주석해제해서 패치
//	@Resource(name="xsqlSession")
//	private SqlSession xsqlSession;
	
	// 고객용 메인화면
	@RequestMapping(value = "/zDLM_customerMain.do")
	public String customerMain(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/custom/daelim/itsm/cc/customerMain"; 
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	// 콜센터용 메인화면
	@RequestMapping(value = "/zDLM_callCenterMain.do")
	public String callCenterMain(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/custom/daelim/itsm/cc/callCenterMain"; 
		try {
			model.put("loginFunc", StringUtil.checkNull(request.getParameter("loginFunc")));
			model.put("logoutFunc", StringUtil.checkNull(request.getParameter("logoutFunc")));
			model.put("initialLoad", StringUtil.checkNull(request.getParameter("initialLoad")));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/zDLM_callCenterMainData.do")
	public void callCenterMainData(HttpServletRequest request,  HttpServletResponse res, HashMap<String, Object> cmmMap, ModelMap model) throws Exception {
		JSONObject jsonObject = new JSONObject();
		Map setMap = new HashMap();
		
        res.setHeader("Cache-Control", "no-cache");
		res.setContentType("text/plain");
		res.setCharacterEncoding("UTF-8");
	    try {
	    	String memberID = StringUtil.checkNull(request.getParameter("memberID"),"");
	    	setMap.put("memberID", memberID);
			List status = commonService.selectList("zDLM_SQL.selectCCUserStatus", setMap);
	        
			Date today = new Date();
			SimpleDateFormat yyyyMM = new SimpleDateFormat("yyyyMM");
			SimpleDateFormat yyyyMMdd = new SimpleDateFormat("yyyyMMdd");
			setMap.put("yyyyMM", yyyyMM.format(today));
			setMap.put("yyyyMMdd", yyyyMMdd.format(today));
			
			String telNum = StringUtil.checkNull(request.getParameter("telNum"),"");
	    	setMap.put("telNum", telNum);
			// TODO : 주석해제해서 패치
//			List temp = xsqlSession.selectList("daelim_SQL.zDLM_callCenter_dashboard", setMap);
//			jsonObject.put("ctiData", temp.get(0));
//			List temp1 = xsqlSession.selectList("daelim_SQL.zDLM_callCenter_myDashboard", setMap);
//			jsonObject.put("myData", temp1.get(0));
			
			jsonObject.put("status", status.get(0));
	        res.getWriter().print(jsonObject);
	    } catch (Exception e) {
	        System.out.println(e.toString());
	        res.getWriter().print(jsonObject);
	    }
	}
	
	@RequestMapping(value = "/zDLM_getCCUserSts.do")
	public void getCCUserSts(HttpServletRequest request,  HttpServletResponse res, HashMap<String, Object> cmmMap, ModelMap model) throws Exception {
		JSONObject jsonObject = new JSONObject();
		Map setMap = new HashMap();
		
        res.setHeader("Cache-Control", "no-cache");
		res.setContentType("text/plain");
		res.setCharacterEncoding("UTF-8");
	    try {
	    	setMap.put("memberID", StringUtil.checkNull(request.getParameter("memberID"),""));
			Map info = commonService.select("zDLM_SQL.getCCUserInfo", setMap);
			jsonObject.put("telNum", StringUtil.checkNull(info.get("TelNum")));
			jsonObject.put("status", StringUtil.checkNull(info.get("STATUS_CD")));
	        res.getWriter().print(jsonObject);
	    } catch (Exception e) {
	        System.out.println(e.toString());
	        jsonObject.put("message", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
	        res.getWriter().print(jsonObject);
	    }
	}
	
	@RequestMapping(value = "/zDLM_saveCCUserSts.do")
	public void saveCCUserSts(HttpServletRequest request,  HttpServletResponse res, HashMap<String, Object> cmmMap, ModelMap model) throws Exception {
		JSONObject jsonObject = new JSONObject();
	    ObjectMapper objectMapper = new ObjectMapper();
	    HashMap<String, Object> setData = new HashMap<>();
	    
        res.setHeader("Cache-Control", "no-cache");
		res.setContentType("text/plain");
		res.setCharacterEncoding("UTF-8");
		
	    try {
	        // 요청 본문에서 JSON 데이터 읽기
	        StringBuilder jsonBuilder = new StringBuilder();
	        try (BufferedReader reader = request.getReader()) {
	            String line;
	            while ((line = reader.readLine()) != null) {
	                jsonBuilder.append(line);
	            }
	        }
	        String jsonString = jsonBuilder.toString();
	        
	        // jsonString을 Map 객체로 변환
	        Map<String, Object> jsonMap = objectMapper.readValue(jsonString, new TypeReference<Map<String, Object>>(){});
	        String STATUS_CD = StringUtil.checkNull(jsonMap.get("STATUS_CD"));
	        String STATUS_NAME = StringUtil.checkNull(jsonMap.get("STATUS_NAME"));
	        String PBX_CC_USER_STATUS_CD = StringUtil.checkNull(jsonMap.get("PBX_CC_USER_STATUS_CD"));
	        String memberID = StringUtil.checkNull(jsonMap.get("memberID"));
	        
	        setData.put("STATUS_CD", STATUS_CD);
	        setData.put("STATUS_NAME", STATUS_NAME);
	        setData.put("PBX_CC_USER_STATUS_CD", PBX_CC_USER_STATUS_CD);
	        setData.put("memberID", memberID);
	        commonService.update("zDLM_SQL.updateCCUserSts", setData);
	        
			jsonObject.put("message", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
	        res.getWriter().print(jsonObject);	        
	    } catch (Exception e) {
	        System.out.println(e.toString());
	        jsonObject.put("message", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
	        res.getWriter().print(jsonObject);
	    }
	}
	
	// 콜센터 메인화면 - 콜인입시 사용자 리스트 화면 호출
	@RequestMapping(value = "/zDLM_mbrListByPhoneNo.do")
	public String mbrListByPhoneNo(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/custom/daelim/itsm/cc/mbrListByPhoneNo";
		try {
			model.put("telNum", StringUtil.checkNull(request.getParameter("telNum"),""));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/zDLM_viewMbrInfoPop.do")
	public String viewMbrInfoPop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/custom/daelim/itsm/cc/viewMbrInfoPop";
		try {
			Map setMap = new HashMap();
			setMap.put("MemberID", StringUtil.checkNull(request.getParameter("memberID"),""));
	        setMap.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
			Map userInfo = commonService.select("user_SQL.selectUser", setMap);
			
			model.put("userInfo", userInfo);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
		
	@RequestMapping(value = "/zDlm_ccUserList.do")
	public String zDlm_ccUserList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/custom/daelim/itsm/cc/zDlm_ccUserList";
		try {
	        model.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value="/addCCUser.do")
	public String addCCUserPop(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception{
		String url = "/custom/daelim/itsm/cc/addCCUserPop";
		Map setMap = new HashMap();
		try{
	        setMap.put("languageID", StringUtil.checkNull(mapValue.get("sessionCurrLangType")));
	        List ccUserList = commonService.selectList("zDLM_SQL.getCCUserList", setMap);
			model.put("ccUserList", ccUserList); 
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
			model.put("languageID", request.getParameter("languageID"));
		}catch(Exception e){
			System.out.println(e.toString());
		}		
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/saveCCUser.do")
	public String saveCCUser(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();
			Map setMap = new HashMap();
			String memberID = request.getParameter("objName");
			setMap.put("MemberID",memberID);
	        Map countMap  = commonService.select("zDLM_SQL.selectUserByMemberID", setMap);  
	        Integer count = (Integer) countMap.get("count");

		    if (count != null && count > 0) {
	            target.put(AJAX_ALERT, "이미 존재하는 memberID입니다. 다른 ID를 사용해 주세요.");
	            target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
	            model.addAttribute(AJAX_RESULTMAP, target);
	            return nextUrl(AJAXPAGE);
	        }

			String statusCD = request.getParameter("objStatus"); 
			String statusName = "";
			
				switch (statusCD) {
			    case "22":
			        statusName = "교육";
			        break;
			    case "13":
			        statusName = "상담후 작업";
			        break;
			    case "3":
			        statusName = "상담 대기중";
			        break;
			    case "21":
			        statusName = "원격 연결";
			        break;
			    case "23":
			        statusName = "휴가";
			        break;
			    case "24":
			        statusName = "식사";
			        break;
			    case "27":
			        statusName = "로그아웃";
			        break;
			    default:
			        statusName = "알 수 없음"; 
			        break;
			}
			
			
			setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
	        Map memberInfo = commonService.select("user_SQL.selectUser", setMap);
	        String ccUserName = (String) memberInfo.get("UserNAME"); 
	        String loginID = (String) memberInfo.get("LoginID"); 
	        String telNum = (String) memberInfo.get("TelNum"); 
			
			getMap.put("memberID", memberID);
			getMap.put("CCUserEmpNo", loginID);
			getMap.put("CCUserName", ccUserName);
			getMap.put("telNum", telNum);
			getMap.put("statusCD", statusCD);
			getMap.put("statusName", statusName);
			getMap.put("useYN", request.getParameter("objUseYN"));
			//getMap.put("isManager", request.getParameter("objisManager"));
			getMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));

			commonService.insert("zDLM_SQL.InsertCCUser", getMap); 

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT, "parent.selfClose();parent.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/DeleteCCUser.do")
	public String DeleteCCUser(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();

			getMap.put("memberId", request.getParameter("memberId"));
			getMap.put("statusCD", request.getParameter("statusCD"));

			commonService.delete("zDLM_SQL.DeleteCCUser", getMap);

			if (StringUtil.checkNull(request.getParameter("FinalData"), "").equals("Final")) {
				// target.put(AJAX_ALERT, "�궘�젣媛� �꽦怨듯븯���뒿�땲�떎.");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // �궘�젣													
				target.put(AJAX_SCRIPT, "this.fnCallBack();this.$('#isSubmit').remove();"); // �꽦怨�
			}

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			// target.put(AJAX_ALERT, " �궘�젣以� �삤瑜섍� 諛쒖깮�븯���뒿�땲�떎.");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // �궘�젣 �삤瑜�														// 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		// model.put("noticType", noticType);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/updateAllCCUser.do")
	public String updateEsmFltpAlloc(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
			try {
				String memberIds[] = request.getParameter("memberIds").split(",");
				String useYNList[] = request.getParameter("useYNList").split(",");
				String isManagerList[] = request.getParameter("isManagerList").split(",");
				String TelNums[] = request.getParameter("TelNums").split(",");
							
				  for(int i=0; i<memberIds.length; i++){     
				        setMap.put("memberID",memberIds[i]);
						setMap.put("useYN",useYNList[i]);
						setMap.put("isManager", isManagerList[i]);  
						setMap.put("TelNum", TelNums[i]);  
				        commonService.update("zDLM_SQL.updateCCUserSts", setMap);
					}
			    
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 	
				target.put(AJAX_SCRIPT, "parent.fnCallBack();parent.$('#isSubmit').remove();");
				
			} catch (Exception e) {
				System.out.println(e);
				target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮												
			}
			model.addAttribute(AJAX_RESULTMAP, target);
			return nextUrl(AJAXPAGE);
	}
	
//	@RequestMapping(value = "/updateAllCCUser.do")
//	public String updateEsmFltpAlloc(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
//		HashMap target = new HashMap();
//		Map setMap = new HashMap();
//			try {
//				String memberIds[] = request.getParameter("memberIds").split(",");
//				String useYNList[] = request.getParameter("useYNList").split(",");
//				String isManagerList[] = request.getParameter("isManagerList").split(",");
//				String TelNums[] = request.getParameter("TelNums").split(",");
//							
//				Map<String, Map<String, Object>> updateData = new HashMap<>();			     
//				
//				  for(int i=0; i<memberIds.length; i++){     
//					  String memberId = memberIds[i];
//					 	Map<String, Object> currentData = updateData.getOrDefault(memberId, new HashMap<>());
//
//					 	currentData.put("memberID",memberIds[i]);
//					 	currentData.put("useYN",useYNList[i]);
//					 	currentData.put("isManager", isManagerList[i]);  
//					 	currentData.put("TelNum", TelNums[i]);  
//						
//						updateData.put(memberId, currentData);
//					}
//			    
//				  for (Map<String, Object> data : updateData.values()) {
//			            commonService.update("zDLM_SQL.updateCCUserSts", data);
//			        }
//				  
////				  commonService.update("zDLM_SQL.updateCCUserSts", setMap);
//				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 	
//				target.put(AJAX_SCRIPT, "parent.fnCallBack();parent.$('#isSubmit').remove();");
//				
//			} catch (Exception e) {
//				System.out.println(e);
//				target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
//				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮												
//			}
//			model.addAttribute(AJAX_RESULTMAP, target);
//			return nextUrl(AJAXPAGE);
//	}
}
