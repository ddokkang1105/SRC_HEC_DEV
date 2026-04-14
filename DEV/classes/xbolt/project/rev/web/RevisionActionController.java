package xbolt.project.rev.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonService;

/**
 * 업무 처리
 * 
 * @Class Name : RevisionActionController.java
 * @Description : 업무화면을 제공한다.
 * @Modification Information
 * @수정일 수정자 수정내용
 * @--------- --------- -------------------------------
 * @2018. 01.08 . smartfactory 최초생성
 * 
 * @since 
 * @version 1.0
 */

@Controller
@SuppressWarnings("unchecked")
public class RevisionActionController extends XboltController {
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/revisionList.do")
	public String revisionList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/project/changeInfo/revisionList"; 
		try {
				String documentID = StringUtil.checkNull(request.getParameter("s_itemID"));
				String docCategory = StringUtil.checkNull(request.getParameter("docCategory"));
				
				String scStartDt = StringUtil.checkNull(cmmMap.get("scStartDt"));
				String searchKey = StringUtil.checkNull(cmmMap.get("searchKey"));
				String searchValue = StringUtil.checkNull(cmmMap.get("searchValue"));
				String scEndDt = StringUtil.checkNull(cmmMap.get("scEndDt"));
				
				HashMap setData = new HashMap();
				setData.put("documentID", documentID);
				setData.put("curChangeSetYN", "Y");
				setData.put("docCategory",docCategory);
				String revisionCNT = StringUtil.checkNull(commonService.selectString("revision_SQL.getRevisionCOUNT", setData));
				
				setData.put("itemID", documentID);
				setData.put("languageID", cmmMap.get("sessionCurrLangType"));
				Map itemAuthInfo = commonService.select("item_SQL.getItemAuthority", setData);
				
				model.put("itemAuthorID", itemAuthInfo.get("AuthorID"));
				model.put("itemBlocked", itemAuthInfo.get("Blocked"));
				model.put("revisionCNT", revisionCNT);
				model.put("scStartDt", scStartDt);
				model.put("scEndDt", scEndDt);
				model.put("searchKey", searchKey);
				model.put("searchValue", searchValue);
				
				model.put("documentID", documentID);
				model.put("docCategory", docCategory);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */	
				
				
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/revisionInfo.do")
	public String revisionInfo(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/project/changeInfo/revisionInfo";
		try {
			Map getMap = new HashMap();
			Map setMap = new HashMap();
			String screenMode = StringUtil.checkNull(request.getParameter("screenMode"));
			String documentID = StringUtil.checkNull(cmmMap.get("s_itemID"),request.getParameter("documentID"));
			String revisionID = StringUtil.checkNull(request.getParameter("revisionID"));
			
			getMap.put("languageID", request.getParameter("LanguageID"));
			getMap.put("documentID", documentID);
			getMap.put("revisionID", revisionID);
			
			setMap = commonService.select("revision_SQL.getRevision", getMap);			
			String Description = StringUtil.checkNull(setMap.get("Description"),"");
			if(!StringUtil.checkNull(setMap.get("AuthorID")).equals(StringUtil.checkNull(cmmMap.get("sessionUserId")))){
				Description = StringUtil.replaceFilterString(Description);
				Description = Description.replaceAll("\r\n", "<br>");
			}
			setMap.put("Description", Description);
			
			model.put("getData", setMap);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("screenMode", screenMode);
			
		} catch (Exception e) {
			System.out.println(e);
		}

		return nextUrl(url);
	}
	
	@RequestMapping(value = "/addRevision.do")
	public String addRevision(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/project/changeInfo/addRevision"; 
		try {
				String documentID = StringUtil.checkNull(cmmMap.get("documentID"));
				String docCategory = StringUtil.checkNull(cmmMap.get("docCategory"));
				
				String changeSetID = "";
				String itemTypeCode = "";
				String modelTypeCode = "";
				String fileTypeCode = "";
				
				Map documentMap = new HashMap();
				Map setData = new HashMap();
				setData.put("s_itemID", documentID);
				if(docCategory.equals("ITM")){ // Item
					documentMap = commonService.select("project_SQL.getItemInfo", setData);
					itemTypeCode = StringUtil.checkNull(documentMap.get("ItemTypeCode"));
					changeSetID = StringUtil.checkNull(documentMap.get("CurChangeSet"));
					model.put("objectType", itemTypeCode);
					model.put("changeSetID", changeSetID);
				}else if(docCategory.equals("MDL")){ // MODEL
					
				}else if(docCategory.equals("FLTP")){ // FILE
					
				}
				
				model.put("documentID", documentID);
				model.put("docCategory", docCategory);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */		
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/saveRevision.do")
	public String saveRevision(HttpServletRequest request, HashMap  commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {	
			HashMap insertData = new HashMap();
			
			String documentID = StringUtil.checkNull(request.getParameter("documentID"));
			String docCategory = StringUtil.checkNull(request.getParameter("docCategory"));
			String objectType = StringUtil.checkNull(request.getParameter("objectType"));
			String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"));
			String description = StringUtil.checkNull(request.getParameter("Description"));
			String revisionID = StringUtil.checkNull(request.getParameter("revisionID"));
			
			insertData.put("revisionID", revisionID);
			insertData.put("docCategory", docCategory);
			insertData.put("objectType", objectType);	
			insertData.put("documentID", documentID);
			insertData.put("changeSetID", changeSetID);
			insertData.put("description", description);
			insertData.put("authorID", commandMap.get("sessionUserId"));
			insertData.put("authorTeamID", commandMap.get("sessionTeamId"));
			
			if(revisionID.equals("")){
				insertData.put("revisionType", "MOD");
				commonService.insert("revision_SQL.insertRevision", insertData);	
			}else{
				commonService.update("revision_SQL.updateRevision", insertData);	
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.fnCallBack();$('#isSubmit').remove()");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	
}
