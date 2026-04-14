package xbolt.app.plm.wbs.web;

import java.io.File;
import java.io.FileOutputStream;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import xbolt.cmm.framework.filter.XSSRequestWrapper;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.GetItemAttrList;
import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.service.CommonService;

import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
/**
 * 공통 서블릿 처리
 * @Class Name : InstnceActionController.java
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
public class WBSActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@RequestMapping(value="/pim_ViewProjectWBS.do")
	public String pim_ViewProjectWBS(HttpServletRequest request, ModelMap model, HashMap cmmMap)throws Exception{
		String url = "/app/plm/wbs/plm_ViewWBSPop";
		try {			
			String ProcInstNo = StringUtil.checkNull(cmmMap.get("ProcInstNo"),"PRC180500058");
			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			model.put("ProcInstNo", ProcInstNo);	
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl(url);		
	}	
	
	
	@RequestMapping(value="/getWBSInstanceList.do")
	public String getWBSInstanceList(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception{
		try{
			String ProcInstNo = StringUtil.checkNull(request.getParameter("ProcInstNo"));
			
			Map setMap = new HashMap();
			String itemIds = "";
			String plainTexts = "";
			String itemIdList = "";
			String data = "\"data\":[";
			String links = "\"links\":[";
			String beforeKey = "";
			int cnt = 0;
			long diffDays = 0 ;
			Date beginDate = null;
			Date endDate = null;
			setMap.put("ProcInstNo", ProcInstNo);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));

			List bpInfoList = commonService.selectList("plm_SQL.getWBSInstanceList",setMap);
			
			model.put("bpInfoList", bpInfoList);
		    SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");		 
		    response.setCharacterEncoding("UTF-8"); // 한글깨짐현상 방지
			PrintWriter out = response.getWriter();

			for (int i=0; i<bpInfoList.size();i++) {
			    Map temp = (Map) bpInfoList.get(i);
			    
			    if(!"".equals(StringUtil.checkNull(temp.get("ReqStartDate")))) {
			    	beginDate = formatter.parse(StringUtil.checkNull(temp.get("ReqStartDate")));
			    }
			    
			    if(!"".equals(StringUtil.checkNull(temp.get("ReqDueDate")))) {
			    	endDate = formatter.parse(StringUtil.checkNull(temp.get("ReqDueDate")));
			    }
			    
			    if(i > 0) {
			    	data += ",";
			    }
			    
			    if(beginDate != null && endDate != null) {
	
				    long diff = endDate.getTime() - beginDate.getTime();
				    diffDays = diff / (24 * 60 * 60 * 1000);

			    }
			    
			    data += "{\"id\":\"" + StringUtil.checkNull(temp.get("TREE_ID")) + "\", \"text\":\"" + StringUtil.checkNull(temp.get("TREE_NM")) + "\"";
			    data += ",\"start_date\":\"" + StringUtil.checkNull(temp.get("ViewStartTime")) + "\", \"end_date\":\"" + StringUtil.checkNull(temp.get("ViewEndTime"))+ "\"";
			    data += ",\"duration\":\"" + diffDays+ "\"";
			    
			    if("CL14003".equals(StringUtil.checkNull(temp.get("ClassCode")))) {

				    data += ",\"type\":\"milestone\"";
			    }
			    else {

				    data += ",\"type\":\"project\"";
			    }
			    
			    data += ",\"parent\":\"" + StringUtil.checkNull(temp.get("P_TREE_ID")) + "\", \"open\":true}";
			  			    
			    if(ProcInstNo.equals(StringUtil.checkNull(temp.get("P_TREE_ID")))) {
			    	
			    	if(!"".equals(beforeKey)) {
					    links += ",{\"id\":\"" + StringUtil.checkNull(temp.get("TREE_ID")) + "_" + i + "\", \"source\":\"" + beforeKey + "\"";
					    links += ",\"target\":\"" +StringUtil.checkNull(temp.get("TREE_ID")) + "\", \"type\":0}";
			    	}
			    	
			    	beforeKey = StringUtil.checkNull(temp.get("TREE_ID"));
			    }
			    
			    
			    if(!"".equals(StringUtil.checkNull(temp.get("PreElmInstNo")))) {
			    	if(cnt > 0) {
			    		links += ",";
			    	}
			    	
				    links += "{\"id\":\"" + StringUtil.checkNull(temp.get("TREE_ID")) + "_" + i + "\", \"source\":\"" + StringUtil.checkNull(temp.get("PreElmInstNo")) + "\"";
				    links += ",\"target\":\"" +StringUtil.checkNull(temp.get("TREE_ID")) + "\", \"type\":0}";
			    	
				    cnt++;
			    }
			    
			    
			}

		    out.append(data);
			out.append("]");
		    out.append("(SLASH)");
		    out.append(links);
			out.append("]");
		    out.flush();
			
			
		}catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("MainDaelimActionController::mainpage::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}		

		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/pim_UpdateProjectWBS.do")
	public String pim_UpdateProjectWBS(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap setMap = new HashMap();
			
			String stepKey = StringUtil.checkNull(commandMap.get("stepKey"));
			String startDate = StringUtil.checkNull(commandMap.get("startDate"));
			String endDate = StringUtil.checkNull(commandMap.get("endDate"));
			String ProcInstNo = StringUtil.checkNull(commandMap.get("ProcInstNo"));
			String parent = StringUtil.checkNull(commandMap.get("parent"));
			String loginUserID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String text = StringUtil.checkNull(commandMap.get("text"));
			String loginTeamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
			String status = "RDY";

			setMap.put("ElmInstNo", stepKey);
			String stepCnt = commonService.selectString("plm_SQL.getWBSStepCnt",setMap);
			
			if(stepCnt != null && !"".equals(stepCnt) && !"0".equals(stepCnt)) {
				setMap.put("ElmInstNo", stepKey);
				setMap.put("startDate", startDate);
				setMap.put("endDate", endDate);
				commonService.update("plm_SQL.UpdateElmInst", setMap);	
			}
			else {
				
				setMap.put("newElmInstNo", stepKey);
				setMap.put("ProcInstNo", ProcInstNo);
				setMap.put("ParentInstNo", parent);
				setMap.put("status", status);
				setMap.put("startDate", startDate);
				setMap.put("endDate", endDate);
				setMap.put("stepID", "");
				commonService.insert("instance_SQL.insertElmInst", setMap);	
				
				setMap.put("instanceNo", stepKey);
				setMap.put("instanceClass", "STEP");
				setMap.put("attrTypeCode",  "AT01001");
				setMap.put("value", text);
				setMap.put("regTeamID", loginTeamID);
				setMap.put("regUserID", loginUserID);	
				setMap.put("lastUserTeamID", loginTeamID);
				setMap.put("lastUser", loginUserID);
				
				commonService.insert("instance_SQL.insertInstanceAttr", setMap);	
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT,"parent.fnCallBackSubmit();parent.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/pim_UpdateMultiWBSList.do")
	public String pim_UpdateMultiWBSList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap setMap = new HashMap();
			
			String stepKey = StringUtil.checkNull(commandMap.get("stepKey"));
			String startDate = StringUtil.checkNull(commandMap.get("startDate"));
			String endDate = StringUtil.checkNull(commandMap.get("endDate"));
			String parent = StringUtil.checkNull(commandMap.get("parent"));
			
			String[] keyList = stepKey.split(",");
			String[] sDateList = startDate.split(",");
			String[] eDateList = endDate.split(",");
			String[] parentList = parent.split(",");
			
			for(int i=0; i<keyList.length; i++) {			
				setMap.put("ElmInstNo", keyList[i]);
				setMap.put("startDate", sDateList[i]);
				setMap.put("endDate", eDateList[i]);
				commonService.update("plm_SQL.UpdateElmInst", setMap);	
			}

			for(int i=0; i<parentList.length; i++) {			
				setMap.put("ElmInstNo", parentList[i]);
				commonService.update("plm_SQL.UpdateParentElmInst", setMap);	
			}
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT,"parent.fnCallBackSubmit();parent.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
	
	
}
