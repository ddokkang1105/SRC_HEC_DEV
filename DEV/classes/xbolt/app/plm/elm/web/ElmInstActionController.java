package xbolt.app.plm.elm.web;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
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
import javax.servlet.ServletException;
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
public class ElmInstActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@RequestMapping(value="/plm_createProjectCharter.do")
	public String pim_ProcInstanceList(HttpServletRequest request, ModelMap model, HashMap cmmMap)throws Exception{
		String url = "/app/plm/step/plm_createProjectCharter";
		try {			
			String masterItemID = StringUtil.checkNull(cmmMap.get("masterItemID"));

			
			Map setParam = new HashMap();
			setParam.put("mstItemID",  masterItemID);
			setParam.put("languageID", cmmMap.get("sessionCurrLangType"));
			
			List mstItemList = commonService.selectList("item_SQL.getRefItemInfoList", setParam);
			
			Map mstMap = (HashMap)mstItemList.get(0);
			

			setParam.put("s_itemID",  StringUtil.checkNull(mstMap.get("ItemID")));
			setParam.put("ClassCode",  "CL14001");
			setParam.put("languageID", cmmMap.get("sessionCurrLangType"));
			List wbsTypeList = commonService.selectList("item_SQL.getCxnItemList_gridList", setParam);
			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			model.put("wbsTypeList", wbsTypeList);	
			model.put("p_itemID", masterItemID);	
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl(url);		
	}	

	@RequestMapping(value = "/plm_newProjectCharter.do")
	public String plm_newProjectCharter(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap setMap = new HashMap();
			HashMap insertPjtInstData = new HashMap();
			HashMap insertElmInstData = new HashMap();
			
			
			String wbsTypeList = StringUtil.checkNull(commandMap.get("wbsTypeList"));
			String procInstanceName = StringUtil.checkNull(commandMap.get("procInstanceName"));
			String ProcInstNo = StringUtil.checkNull(commandMap.get("ProcInstNo"));
			String p_itemID = StringUtil.checkNull(commandMap.get("p_itemID"));
			
			String loginUserID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String loginTeamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
			String beforePrentID = p_itemID;
			String beforeStepID = "";
			String Status = "RDY";
			String ParentInstNo = "";
			String PreElmInstNo = "";
			
			insertPjtInstData.put("instanceNo", ProcInstNo);
			insertPjtInstData.put("processID", p_itemID);
			insertPjtInstData.put("WBSTypeID", wbsTypeList);
			insertPjtInstData.put("loginUserID", loginUserID);
			insertPjtInstData.put("loginTeamID", loginTeamID);
			insertPjtInstData.put("startTime", "");
			insertPjtInstData.put("dueDate", "");
			insertPjtInstData.put("endTime", "");
			insertPjtInstData.put("status", Status);
			commonService.insert("instance_SQL.insertProcInst", insertPjtInstData);
			
			insertPjtInstData.put("instanceClass", "PROC");
			insertPjtInstData.put("attrTypeCode",  "AT01001");
			insertPjtInstData.put("value", procInstanceName);
			insertPjtInstData.put("regTeamID", loginTeamID);
			insertPjtInstData.put("regUserID", loginUserID);	
			insertPjtInstData.put("lastUserTeamID", loginTeamID);
			insertPjtInstData.put("lastUser", loginUserID);

			commonService.insert("instance_SQL.insertInstanceAttr", insertPjtInstData);	

			setMap.put("wbsItemID",wbsTypeList);
			String rootItemID = commonService.selectString("plm_SQL.getWBSRootItemID", setMap);
			setMap.put("rootItemID",rootItemID);

			List wbsStepList = commonService.selectList("plm_SQL.getWBSStepList", setMap);
			
			if(wbsStepList != null && !wbsStepList.isEmpty()) {

				for(int i=0; i<wbsStepList.size(); i++) {
					
					String newElmInstID = "";
					
					String maxElmInstID = commonService.selectString("instance_SQL.maxElmInstNo", setMap);
					
					int maxWFInstanceID2 = Integer.parseInt(maxElmInstID.substring(3));
					int maxcode = maxWFInstanceID2 + 1;
					newElmInstID = "STP" + String.format("%08d", maxcode);
					
					insertElmInstData.put("newElmInstID", newElmInstID);
					
					Map tempMap = (Map)wbsStepList.get(i);
					String parentID = StringUtil.checkNull(tempMap.get("FromItemID"));
					String stepItemID = StringUtil.checkNull(tempMap.get("ToItemID"));
										
					if(beforePrentID.equals(wbsTypeList) || (!beforePrentID.equals(parentID) && parentID.equals(wbsTypeList))) {
						beforePrentID = stepItemID;
						insertElmInstData.put("stepID", stepItemID);	
						insertElmInstData.put("ProcInstNo", ProcInstNo);		
						insertElmInstData.put("ParentInstNo", null);	
						insertElmInstData.put("PreElmInstNo", null);	
						insertElmInstData.put("status", Status);			
						insertElmInstData.put("startDate", "1900-01-02");			
						insertElmInstData.put("endDate", "1900-01-02");	
						ParentInstNo = newElmInstID;
						PreElmInstNo = "";
					}
					else if(beforePrentID.equals(parentID) || (!beforePrentID.equals(parentID) && beforeStepID.equals(stepItemID))) {
						insertElmInstData.put("stepID", stepItemID);	
						insertElmInstData.put("ProcInstNo", ProcInstNo);	
						insertElmInstData.put("ParentInstNo", ParentInstNo);			
						insertElmInstData.put("status", Status);		
						insertElmInstData.put("PreElmInstNo", PreElmInstNo);		
						insertElmInstData.put("startDate", "1900-01-02");			
						insertElmInstData.put("endDate", "1900-01-02");	
						PreElmInstNo = newElmInstID;
					}
					
					commonService.insert("instance_SQL.insertElmInst", insertElmInstData);
				}
			}
			else {
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 저장 성공
				target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
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
