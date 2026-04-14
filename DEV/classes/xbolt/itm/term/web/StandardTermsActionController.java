package xbolt.itm.term.web;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringEscapeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.org.json.JSONArray;
import com.org.json.JSONObject;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.EmailUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.custom.sk.cmm.XssUtil;


@Controller
@SuppressWarnings("unchecked") 
public class StandardTermsActionController extends XboltController {

	@Autowired
    @Qualifier("commonService")
    private CommonService commonService;
	
	@Resource(name = "standardTermsService")
	private CommonService standardTermsService;
	
	@RequestMapping(value="/termsMgt.do")
	public String termsMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		try {			
				String arcCode =  StringUtil.checkNull(cmmMap.get("arcCode"),"");
				String menuStyle =  StringUtil.checkNull(cmmMap.get("menuStyle"),"");
				Map setMap = new HashMap();
				setMap.put("languageID", cmmMap.get("sessionCurrLangType"));				
				setMap.put("s_itemID", "AT00034");
				List LOVAT34List = commonService.selectList("attr_SQL.selectAttrLovOption", setMap);
				
				Map dataMap = new HashMap();
				dataMap.put("CODE", "");
				dataMap.put("NAME", "ALL");
				
				LOVAT34List.add(0, dataMap);
				model.put("LOVAT34List", LOVAT34List);
				model.put("arcCode", arcCode);
				model.put("menuStyle", menuStyle);
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
				model.addAttribute(HTML_HEADER, "Standard Terms");
				model.put("csr", cmmMap.get("csr"));
				model.put("mgt", cmmMap.get("mgt"));
				model.put("linkOption", cmmMap.get("linkOption"));
				
				String pmenuIndex = ""; 
				int index = 1;
				for(int i=0; i<LOVAT34List.size(); i++){				
					if(i==0){
						pmenuIndex = ""+index;
					}else{
						pmenuIndex = pmenuIndex +" "+ index;
					}
					index++;
				}
				model.put("pmenuIndex",pmenuIndex);
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl("/itm/term/termsMgt");
	}	

	@RequestMapping(value="/standardTermsMgt.do")
	public String standardTermsMgt(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		try {
				model.addAttribute(HTML_HEADER, "Standard Terms");
				String attrTypeCode = StringUtil.checkNull(commandMap.get("attrTypeCode")); 
				model.put("attrTypeCode", attrTypeCode);
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl("/itm/term/standardTermsMgt");
	}	
	
	@RequestMapping(value="/standardTermsSch.do")
	public String standardTermsSch(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		model.addAttribute(HTML_HEADER, "Standard Terms");
		
		try { 
				String lovCode = StringUtil.
						replaceFilterString(StringUtil.checkNull(commandMap.get("lovCode")));
				String page = StringUtil.checkNull(request.getParameter("page"), "1");
				String searchCondition1 = StringUtil.checkNull(request.getParameter("searchCondition1"), ""); // 검색 조건
				String searchCondition2 = StringUtil.checkNull(request.getParameter("searchCondition2"), ""); // 검색 조건
				String searchCondition3 = StringUtil.checkNull(request.getParameter("searchCondition3"), ""); // 검색 조건
				String searchCondition4 = StringUtil.checkNull(request.getParameter("searchCondition4"), ""); // 검색 조건
				String languageID =StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
				String userId = StringUtil.checkNull(commandMap.get("sessionUserId"));
				String searchValue =StringUtil.replaceFilterString(StringUtil.checkNull(commandMap.get("searchValue")));
			
				/** BEGIN ::: LANGUAGE**/
				HashMap cmmMap = new HashMap();
				HashMap getMap = new HashMap();
				
				cmmMap.put("languageID", languageID);
				cmmMap.put("userId", userId);
				String clientId = StringUtil.checkNull(commonService.selectString("standardTerms_SQL.getUserClientId", cmmMap));
				
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/
				/** END ::: LANGUAGE**/
				
				Map mapValue = new HashMap();
				mapValue.put("languageID", languageID);
				
				if (!searchCondition1.isEmpty()) {
					mapValue.put("searchCondition1", searchCondition1);
				} else if (!searchCondition2.isEmpty()) {
					mapValue.put("searchCondition2", searchCondition2);
				} else if (!searchCondition3.isEmpty()) {
					mapValue.put("searchCondition3", searchCondition3);
					mapValue.put("searchCondition4", searchCondition4);
				}
				
				String lovName = "";
				lovName = StringUtil.checkNull(commonService.selectString("standardTerms_SQL.getLovValue", commandMap),"");
				
				//gridData
				commandMap.put("languageID", languageID);
				commandMap.put("lovCode", lovCode);
				String defaultLang = commonService.selectString("config_SQL.defaultLanguageID", commandMap);
				commandMap.put("defaultLang", defaultLang);
			    List tarmsList = commonService.selectList("standardTerms_SQL.getSearchResult_gridList", commandMap);
		        JSONArray gridData = new JSONArray(tarmsList);
		        model.put("gridData",gridData);	
								
		        model.put("defaultLang", defaultLang);
				model.put("languageID", languageID);
				model.put("clientID", clientId);
				model.put("page", page);
				model.put("searchCondition1", searchCondition1);
				model.put("searchCondition2", searchCondition2);
				model.put("searchCondition3", searchCondition3);
				model.put("searchCondition4", searchCondition4);
				model.put("pageScale", GlobalVal.LIST_PAGE_SCALE);
				model.put("lovCode", lovCode);
				model.put("lovName", lovName);
				model.put("csr", StringUtil.replaceFilterString(StringUtil.checkNull(commandMap.get("csr"))));
				model.put("mgt", StringUtil.replaceFilterString(StringUtil.checkNull(commandMap.get("mgt"))));
				model.put("searchValue", searchValue);
				model.put("linkOption", StringUtil.replaceFilterString(StringUtil.checkNull(commandMap.get("linkOption"))));
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("/itm/term/standardTerms");
	}
	
	@RequestMapping(value="/standardTermsEditForm.do")
	public String standardTermsAdd(HttpServletRequest request, ModelMap model) throws Exception{
		try {
			
			HashMap cmmMap = new HashMap();
			HashMap getMap = new HashMap();
			String languageID = request.getParameter("languageID");
			String clientID = request.getParameter("clientID");
			String isNew = request.getParameter("isNew");
			String typeCode = request.getParameter("typeCode");
			String subject = "";
			String content = "";
			
			if (isNew.equals("N")) {
				getMap = new HashMap();
				cmmMap.put("TypeCode", typeCode);
				cmmMap.put("LanguageID", languageID);
				List termList = commonService.selectList("standardTerms_SQL.getStandardTerm", cmmMap);
				getMap = (HashMap) termList.get(0);
				subject = getMap.get("subject").toString();
				content = getMap.get("content").toString();
			}
			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			model.put("languageID", languageID);
			model.put("clientID", clientID);
			model.put("isNew", isNew);
			model.put("typeCode", typeCode);
			model.put("subject", subject);
			model.put("content", content);
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("/itm/term/standardTermsEdit");
	}
	
	@RequestMapping(value = "/standardTermsEdit.do")
	public String standardTermsEdit(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {
			Map setMap = new HashMap();
			String languageID = StringUtil.checkNull(request.getParameter("languageID"), "");
			String clientID = StringUtil.checkNull(request.getParameter("clientID"), "");
			String subject = StringUtil.checkNull(request.getParameter("subject"), "");
			String content = StringUtil.checkNull(request.getParameter("content"), "");
			String isNew = StringUtil.checkNull(request.getParameter("isNew"), "");
			String typeCode = StringUtil.checkNull(request.getParameter("typeCode"), "");
			
			if (isNew.equals("N")) {
				/* update */
				Map updateValMap = new HashMap();
				Map updateInfoMap = new HashMap();
				List updateList = new ArrayList();
				
				updateValMap.put("subject", subject);
				updateValMap.put("content", content);
				updateValMap.put("TypeCode", typeCode);
				updateValMap.put("LanguageID", languageID);
				
				updateList.add(updateValMap);
				updateInfoMap.put("KBN", "update");
				updateInfoMap.put("SQLNAME", "standardTerms_SQL.standardTermsUpdate");
				
				standardTermsService.save(updateList, updateInfoMap);
				
			} else {
				
				/* insert */
				// Max TypdeCode를 취득
				String maxTypeCode = commonService.selectString("standardTerms_SQL.getMaxTypeCode", setMap);
				maxTypeCode = String.valueOf(Integer.parseInt(maxTypeCode.substring(2)) + 1);
				int cnt = maxTypeCode.length();
				for (int i = 0 ; i < (5 - cnt); i++) {
					maxTypeCode = "0" + maxTypeCode;
				}
				maxTypeCode = "ST" + maxTypeCode;
				
				Map insertValMap = new HashMap();
				Map insertInfoMap = new HashMap();
				List insertList = new ArrayList();
				
				insertValMap.put("TypeCode", maxTypeCode);
				insertValMap.put("LanguageID", languageID);
				insertValMap.put("subject", subject);
				insertValMap.put("content", content);
				insertValMap.put("ClientID", clientID);
				
				insertList.add(insertValMap);
				insertInfoMap.put("KBN", "insert");
				insertInfoMap.put("SQLNAME", "standardTerms_SQL.standardTermsInsert");
				
				standardTermsService.save(insertList, insertInfoMap);
				
			}
			
			// 화면 표시 메뉴 Map 취득
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
						
			Map target = new HashMap();
			//target.put(AJAX_ALERT, "저장이 성공하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.doReturn();");
			model.addAttribute(AJAX_RESULTMAP, target);
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/standardTermsDelete.do")
	public String standardTermsDelete(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {
			String languageID = StringUtil.checkNull(request.getParameter("languageID"), "");
			String typeCode = StringUtil.checkNull(request.getParameter("typeCode"), "");
			
			Map deleteValMap = new HashMap();
			Map deleteInfoMap = new HashMap();
			List deleteList = new ArrayList();
			deleteValMap.put("TypeCode", typeCode);
			deleteValMap.put("LanguageID", languageID);
			deleteList.add(deleteValMap);
			deleteInfoMap.put("KBN", "delete");
			deleteInfoMap.put("SQLNAME", "standardTerms_SQL.standardTermsDelete");
			standardTermsService.save(deleteList, deleteInfoMap);
			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
						
			Map target = new HashMap();
			//target.put(AJAX_ALERT, "저장이 성공하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.doReturn();");
			model.addAttribute(AJAX_RESULTMAP, target);
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/viewTermDetail.do")
	public String viewTermDetail(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		String url = "/itm/term/viewTermDetail";
		try {
				HashMap setMap = new HashMap();
				String itemID = StringUtil.checkNull(request.getParameter("itemID"));
				setMap.put("itemID", itemID);
				setMap.put("s_itemID", itemID);
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			
				String defaultLang = commonService.selectString("config_SQL.defaultLanguageID", setMap);
				setMap.put("defaultLang", defaultLang);
				
				Map termDetailInfo = commonService.select("standardTerms_SQL.getTermDetailInfo", setMap);
				List itemHistoryList = commonService.selectList("cs_SQL.getItemChangeList_gridList", setMap);
				
				String csrID = StringUtil.checkNull(commandMap.get("csr"));
				Map setData = new HashMap();
				setData.put("ProjectID", csrID);
				String csrAuthorID = StringUtil.checkNull(commonService.selectString("project_SQL.getPjtAuthorID", setData));
				
				List list = commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);
				JSONArray cxnList = new JSONArray(list);
				model.put("cxnList", cxnList);
				model.put("itemID", itemID);
				model.put("termDetailInfo", termDetailInfo);
				model.put("itemHistoryList", itemHistoryList);
				model.put("csr", commandMap.get("csr"));
				model.put("mgt", commandMap.get("mgt"));
				model.put("option", commandMap.get("option"));
				model.put("csrAuthorID", csrAuthorID);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */	
							
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value="/editTermDetail.do")
	public String editTermDetail(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		String url = "/itm/term/editTermDetail";
		try {
				HashMap setMap = new HashMap();
				String itemID = StringUtil.checkNull(request.getParameter("itemID"));
				String languageID = StringUtil.checkNull(request.getParameter("languageID"));
				setMap.put("languageID", languageID);
				setMap.put("itemID", itemID);
				
				String defaultLang = commonService.selectString("config_SQL.defaultLanguageID", setMap);
				setMap.put("defaultLang", defaultLang);
							
				Map termDetailInfo = commonService.select("standardTerms_SQL.getTermDetailInfo", setMap);
				
				String parentID = commonService.selectString("item_SQL.getParentItemID", setMap);

				setMap.put("itemID", parentID);
				String gItemID = commonService.selectString("item_SQL.getParentItemID", setMap);
				
				model.put("parentID", parentID);
				model.put("gItemID", gItemID);
				model.put("itemID", itemID);
				model.put("termDetailInfo", termDetailInfo);
				model.put("csr", commandMap.get("csr"));
				model.put("languageID", languageID);
				model.put("callback", StringUtil.checkNull(request.getParameter("callback")));
				model.put("option", StringUtil.checkNull(request.getParameter("option")));
				model.put("duplicateCheck", StringUtil.checkNull(request.getParameter("duplicateCheck")));
				model.put("menu", getLabel(request, commonService)); /* Label Setting */	
							
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/saveTermDetail.do")
	public String saveTermDetail(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		try {
				Map setMap = new HashMap();
				String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"), "");
				String AT00034 = StringUtil.checkNull(request.getParameter("Category"), "");
				String AT00073 = StringUtil.checkNull(request.getParameter("Abbreviation"), "");
				String krName = StringUtil.checkNull(request.getParameter("1042_Name"), "");
				String enName = StringUtil.checkNull(request.getParameter("1033_Name"), "");
				String cnName = StringUtil.checkNull(request.getParameter("2052_Name"), "");
				String AT00056 = StringUtil.checkNull(request.getParameter("AT00056"), "");
				String AT00057 = StringUtil.checkNull(request.getParameter("AT00057"), "");
				String AT00058 = StringUtil.checkNull(request.getParameter("AT00058"), "");
				String itemID = StringUtil.checkNull(request.getParameter("itemID"));
				String csr = StringUtil.checkNull(request.getParameter("csr"));
				String mgt = StringUtil.checkNull(request.getParameter("mgt"),"N");
				String parentID = StringUtil.checkNull(request.getParameter("parentID"));
				String isComLang = "";
				
				//2025-02-12 skon Xss Filter 처리
				AT00073 = XssUtil.xssCustomFilter(AT00073);
				krName = XssUtil.xssCustomFilter(krName);
				enName = XssUtil.xssCustomFilter(enName);
				cnName = XssUtil.xssCustomFilter(cnName);
				AT00056 = XssUtil.xssFilter(AT00056);
				AT00057 = XssUtil.xssFilter(AT00057);
				AT00058 = XssUtil.xssFilter(AT00058);
				
				/*
				AT00003 = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(AT00003));
				AT00003 = StringEscapeUtils.unescapeHtml4(AT00003);
				
				AT00056 = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(AT00056));
				AT00056 = StringEscapeUtils.unescapeHtml4(AT00056);
				*/
				
				String changeSetDescription = StringUtil.checkNull(request.getParameter("changeSetDescription"));
				if (!mgt.equals("Y")) {
					String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
					
					setMap.put("itemID", itemID);
					setMap.put("languageID", languageID);
					setMap.put("attrTypeCode", "AT00001");
					setMap.put("AttrTypeCode", "AT00001");
					isComLang = commonService.selectString("attr_SQL.getItemAttrIsComLang", setMap);
					if ((!isComLang.isEmpty() && !"0".equals(isComLang)) ) {
						// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
						// 언어 코드를 TB_LANGUAGE.IsDefault = 1 인 언어 코드로 재설정
						setMap.put("languageID", defaultLang);
					}
					setMap.put("plainText", krName);
					commonService.update("standardTerms_SQL.saveTerms",setMap);
					
					if(!"".equals(enName)) {
						setMap.put("languageID", "1033");
						setMap.put("plainText", enName);
						commonService.update("standardTerms_SQL.saveTerms",setMap);
					}
					
					if(!"".equals(cnName)) {
						setMap.put("languageID", "2052");
						setMap.put("plainText", cnName);
						commonService.update("standardTerms_SQL.saveTerms",setMap);
					}
					
					setMap.put("attrTypeCode", "AT00034");
					setMap.put("lovCode", AT00034);
					setMap.put("plainText", AT00034);
					setMap.put("AttrTypeCode", "AT00034");
					isComLang = commonService.selectString("attr_SQL.getItemAttrIsComLang", setMap);
					if ((!isComLang.isEmpty() && !"0".equals(isComLang)) ) {
						// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
						// 언어 코드를 TB_LANGUAGE.IsDefault = 1 인 언어 코드로 재설정
						setMap.put("languageID", defaultLang);
					}
					commonService.update("standardTerms_SQL.saveTerms",setMap);
					
					setMap.put("attrTypeCode", "AT00073");
					setMap.put("plainText", AT00073);
					setMap.put("AttrTypeCode", "AT00073");
					isComLang = commonService.selectString("attr_SQL.getItemAttrIsComLang", setMap);
					if ((!isComLang.isEmpty() && !"0".equals(isComLang)) ) {
						// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
						// 언어 코드를 TB_LANGUAGE.IsDefault = 1 인 언어 코드로 재설정
						setMap.put("languageID", defaultLang);
					}
					commonService.update("standardTerms_SQL.saveTerms",setMap);
					
					setMap.put("attrTypeCode", "AT00056");
					setMap.put("plainText", AT00056);
					setMap.put("AttrTypeCode", "AT00056");
					isComLang = commonService.selectString("attr_SQL.getItemAttrIsComLang", setMap);
					if ((!isComLang.isEmpty() && !"0".equals(isComLang)) ) {
						// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
						// 언어 코드를 TB_LANGUAGE.IsDefault = 1 인 언어 코드로 재설정
						setMap.put("languageID", defaultLang);
					}
					commonService.update("standardTerms_SQL.saveTerms",setMap);					

					setMap.put("attrTypeCode", "AT00057");
					setMap.put("plainText", AT00057);
					setMap.put("AttrTypeCode", "AT00057");
					isComLang = commonService.selectString("attr_SQL.getItemAttrIsComLang", setMap);
					if ((!isComLang.isEmpty() && !"0".equals(isComLang)) ) {
						// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
						// 언어 코드를 TB_LANGUAGE.IsDefault = 1 인 언어 코드로 재설정
						setMap.put("languageID", defaultLang);
					}
					commonService.update("standardTerms_SQL.saveTerms",setMap);
					
					setMap.put("attrTypeCode", "AT00058");
					setMap.put("plainText", AT00058);
					setMap.put("AttrTypeCode", "AT00058");
					isComLang = commonService.selectString("attr_SQL.getItemAttrIsComLang", setMap);
					if ((!isComLang.isEmpty() && !"0".equals(isComLang)) ) {
						// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
						// 언어 코드를 TB_LANGUAGE.IsDefault = 1 인 언어 코드로 재설정
						setMap.put("languageID", defaultLang);
					}
					commonService.update("standardTerms_SQL.saveTerms",setMap);
					
					setMap.put("ChangeSetID", commonService.selectString("cs_SQL.selectChangeSetMaxID", setMap));
					setMap.put("Description",changeSetDescription);
					setMap.put("ProjectID",csr);
					setMap.put("PJTcategory","PC1");
					setMap.put("ItemID",itemID);
					setMap.put("AuthorID", commandMap.get("sessionUserId"));
					setMap.put("Authorname", commandMap.get("sessionUserNm"));
					setMap.put("TeamID", commandMap.get("sessionTeamId"));
					setMap.put("CompanyID", commandMap.get("sessionCompanyId"));
					setMap.put("ChangeType", "MOD");
					setMap.put("Status", "CLS");
					
					commonService.insert("cs_SQL.addChangeSet", setMap);	
					
				}else if (mgt.equals("Y"))  {
					setMap.put("s_itemIDs", itemID);
					setMap.put("ChangeType", "MOD");
				    setMap.put("Status", "REL");
					
					commonService.update("project_SQL.updateItemStatus", setMap);
					//commonService.update("cs_SQL.updateChangeSet", setMap);
					
					 // send Eamil 
					setMap = new HashMap();
					HashMap mailFormMap = new HashMap();
					List receiverList = new ArrayList();
					Map receiverMap = new HashMap();	

					setMap.put("itemID",itemID);
					setMap.put("languageID",languageID);
					mailFormMap = (HashMap) commonService.select("item_SQL.getItemAuthority", setMap); // 메일 수신자 정보 조회
					Map termInfoMap = (HashMap) commonService.select("standardTerms_SQL.getTermDetailInfo", setMap); 
					receiverMap.put("receiptUserID", mailFormMap.get("AuthorID"));
					receiverList.add(0,receiverMap);
					mailFormMap.put("receiverList", receiverList);
					
					Map temp = new HashMap();
					temp.put("Category", "EMAILCODE"); 
					temp.put("TypeCode", "TERMREL");
					temp.put("LanguageID", commandMap.get("sessionCurrLangType"));
					Map emDescription = commonService.select("common_SQL.label_commonSelect", temp);
					
					mailFormMap.put("emDescription", emDescription.get("Description"));
					Map setMailCSRMapRst = (Map)setEmailLog(request, commonService, mailFormMap, "TERMREL");
					
					if(StringUtil.checkNull(setMailCSRMapRst.get("type")).equals("SUCESS")){
						HashMap mailMap = (HashMap)setMailCSRMapRst.get("mailLog");	

						String mailSubject = StringUtil.checkNull(mailMap.get("mailSubject"));
						
						mailMap.put("mailSubject", mailSubject + " " + termInfoMap.get("Name"));
						
						Map resultMailMap = EmailUtil.sendMail(mailMap, mailFormMap, getLabel(request, commonService));
						System.out.println("SEND EMAIL TYPE:"+resultMailMap+ "Msg :" + StringUtil.checkNull(setMailCSRMapRst.get("type")));
					}else{
						System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+ StringUtil.checkNull(setMailCSRMapRst.get("msg")));
					}
					
			}
				
				/** item ST1 update start *****/
				if(!parentID.equals("")) {
					String FromItemID = commonService.selectString("item_SQL.getParentItemID", setMap); 
					setMap.put("FromItemID", FromItemID);
					setMap.put("ToItemID", itemID);
					setMap.put("setFromItemID", parentID);
					commonService.update("item_SQL.updateCxnItem", setMap);
				}
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
				target.put(AJAX_SCRIPT, "parent.fnCallBack();");
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/registerTerm.do")
	public String registTerms(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		try {
				Map setMap = new HashMap();				
				String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"), "");
				String AT00034 = StringUtil.checkNull(request.getParameter("Category"), "");
				String AT00073 = StringUtil.checkNull(request.getParameter("Abbreviation"), "");
				String krName = StringUtil.checkNull(request.getParameter("1042_Name"), "");
				String enName = StringUtil.checkNull(request.getParameter("1033_Name"), "");
				String cnName = StringUtil.checkNull(request.getParameter("2052_Name"), "");
				String AT00056 = StringUtil.checkNull(request.getParameter("AT00056"), "");
				String AT00057 = StringUtil.checkNull(request.getParameter("AT00057"), "");
				String AT00058 = StringUtil.checkNull(request.getParameter("AT00058"), "");
				String parentID = StringUtil.checkNull(request.getParameter("parentID"), "");
				
				//2025-02-12 skon Xss Filter 처리
				AT00073 = XssUtil.xssCustomFilter(AT00073);
				krName = XssUtil.xssCustomFilter(krName);
				enName = XssUtil.xssCustomFilter(enName);
				cnName = XssUtil.xssCustomFilter(cnName);
				AT00056 = XssUtil.xssFilter(AT00056);
				AT00057 = XssUtil.xssFilter(AT00057);
				AT00058 = XssUtil.xssFilter(AT00058);
				
				String csr = StringUtil.checkNull(request.getParameter("csr"));
				String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
				// insert Item
				String itemID = commonService.selectString("item_SQL.getItemMaxID", setMap);
			
				setMap.put("Version", "1");
				setMap.put("Deleted", "0");
				setMap.put("Creator", userID);
				setMap.put("CategoryCode", "OJ");
				setMap.put("ItemTypeCode", "OJ00011");
				setMap.put("ClassCode", "CL11004");
				setMap.put("OwnerTeamId", commandMap.get("sessionTeamId"));
				setMap.put("Identifier", request.getParameter("newIdentifier"));
				setMap.put("ItemID", itemID);			
				setMap.put("s_itemID", request.getParameter("s_itemID"));			
				
				setMap.put("ProjectID",csr);
				setMap.put("AuthorID", userID);
				setMap.put("Status","NEW2");
				commonService.insert("item_SQL.insertItem", setMap);
				
				/** item ST1 insert start *****/
				if(!parentID.equals("")) {
					setMap.put("CategoryCode", "ST1");
					setMap.put("ClassCode", "NL00000");
					setMap.put("ToItemID", itemID);
					setMap.put("FromItemID", parentID);
					setMap.put("ItemID", commonService.selectString("item_SQL.getItemMaxID", setMap));
					setMap.remove("Identifier");
					setMap.put("s_itemID", parentID);
					setMap.put("ItemTypeCode", commonService.selectString("item_SQL.selectedConItemTypeCode", setMap));
					commonService.insert("item_SQL.insertItem", setMap);
				}
				
				setMap = new HashMap();
				setMap.put("itemID", itemID);
				String isComLang = "";
				String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
				
				setMap.put("attrTypeCode", "AT00001");
				List getLanguageList = commonService.selectList("common_SQL.langType_commonSelect", setMap);			
				for(int i = 0; i < getLanguageList.size(); i++){
					Map getMap = (HashMap)getLanguageList.get(i);
					setMap.put("languageID", getMap.get("CODE") );
					if(StringUtil.checkNull(getMap.get("CODE")).equals("1042")) setMap.put("plainText", krName);
					else if(StringUtil.checkNull(getMap.get("CODE")).equals("1033")) setMap.put("plainText", enName);
					else if(StringUtil.checkNull(getMap.get("CODE")).equals("2052")) setMap.put("plainText", cnName);
					else setMap.put("plainText", enName);
					commonService.update("standardTerms_SQL.saveTerms",setMap);
				}

				setMap.put("languageID", languageID);
				
				setMap.put("attrTypeCode", "AT00034");
				
				// parentID 가 있을 경우, parent의 AT00034 갑을 insert 해주는 로직
				if(!parentID.equals("")) {
					setMap.put("itemID", parentID);
					AT00034 = commonService.selectString("item_SQL.getItemAttrPlainText", setMap);
				}
				
				setMap.put("itemID", itemID);
				setMap.put("plainText", AT00034);
				setMap.put("lovCode", AT00034);
				setMap.put("AttrTypeCode", "AT00034");
				isComLang = commonService.selectString("attr_SQL.getItemAttrIsComLang", setMap);
				if ((!isComLang.isEmpty() && !"0".equals(isComLang)) ) {
					// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
					// 언어 코드를 TB_LANGUAGE.IsDefault = 1 인 언어 코드로 재설정
					setMap.put("languageID", defaultLang);
				}
				commonService.update("standardTerms_SQL.saveTerms",setMap);
				setMap.remove("lovCode");
				
				setMap.put("attrTypeCode", "AT00073");
				setMap.put("plainText", AT00073);
				setMap.put("AttrTypeCode", "AT00073");
				isComLang = commonService.selectString("attr_SQL.getItemAttrIsComLang", setMap);
				if ((!isComLang.isEmpty() && !"0".equals(isComLang)) ) {
					// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
					// 언어 코드를 TB_LANGUAGE.IsDefault = 1 인 언어 코드로 재설정
					setMap.put("languageID", defaultLang);
				}
				commonService.update("standardTerms_SQL.saveTerms",setMap);
				
				setMap.put("attrTypeCode", "AT00056");
				setMap.put("plainText", AT00056);
				setMap.put("AttrTypeCode", "AT00056");
				isComLang = commonService.selectString("attr_SQL.getItemAttrIsComLang", setMap);
				if ((!isComLang.isEmpty() && !"0".equals(isComLang)) ) {
					// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
					// 언어 코드를 TB_LANGUAGE.IsDefault = 1 인 언어 코드로 재설정
					setMap.put("languageID", defaultLang);
				}
				commonService.update("standardTerms_SQL.saveTerms",setMap);
				
				setMap.put("attrTypeCode", "AT00057");
				setMap.put("plainText", AT00057);
				setMap.put("AttrTypeCode", "AT00057");
				isComLang = commonService.selectString("attr_SQL.getItemAttrIsComLang", setMap);
				if ((!isComLang.isEmpty() && !"0".equals(isComLang)) ) {
					// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
					// 언어 코드를 TB_LANGUAGE.IsDefault = 1 인 언어 코드로 재설정
					setMap.put("languageID", defaultLang);
				}
				commonService.update("standardTerms_SQL.saveTerms",setMap);
				
				setMap.put("attrTypeCode", "AT00058");
				setMap.put("plainText", AT00058);
				setMap.put("AttrTypeCode", "AT00058");
				isComLang = commonService.selectString("attr_SQL.getItemAttrIsComLang", setMap);
				if ((!isComLang.isEmpty() && !"0".equals(isComLang)) ) {
					// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
					// 언어 코드를 TB_LANGUAGE.IsDefault = 1 인 언어 코드로 재설정
					setMap.put("languageID", defaultLang);
				}
				commonService.update("standardTerms_SQL.saveTerms",setMap);
				
				setMap = new HashMap();
				setMap.put("languageID", languageID);
				
				setMap.put("ChangeType", "NEW");
				setMap.put("ProjectID",csr);
				setMap.put("PJTcategory","PC1");
				setMap.put("Status", "CLS");
				setMap.put("ItemID",itemID);
				setMap.put("ChangeSetID", commonService.selectString("cs_SQL.selectChangeSetMaxID", setMap));
				setMap.put("AuthorID", commandMap.get("sessionUserId"));
				setMap.put("Authorname", commandMap.get("sessionUserNm"));
				setMap.put("TeamID", commandMap.get("sessionTeamId"));
				setMap.put("CompanyID", commandMap.get("sessionCompanyId"));
					
				commonService.insert("cs_SQL.addChangeSet", setMap);

				List receiverList = new ArrayList();
				setMap = new HashMap();
				setMap.put("ProjectID",csr);
				
				String authorID = commonService.selectString("project_SQL.getPjtAuthorID",setMap);
				
				Map tempMap = new HashMap();
				tempMap.put("receiptUserID",authorID);
				receiverList.add(0,tempMap);
				
				HashMap setMailData = new HashMap();
				
				setMailData.put("receiverList",receiverList);
				
				Map setMailMap = (Map)setEmailLog(request, commonService, setMailData, "TERMREG"); 
				if(StringUtil.checkNull(setMailMap.get("type")).equals("SUCESS")){
					HashMap mailMap = (HashMap)setMailMap.get("mailLog");
					setMailData.put("content", AT00056);
					String mailSubject = StringUtil.checkNull(mailMap.get("mailSubject"));
					
					mailMap.put("mailSubject", mailSubject + " " + krName);
					
					Map resultMailMap = EmailUtil.sendMail(mailMap,setMailData,getLabel(request, commonService));
					System.out.println("SEND EMAIL TYPE:"+resultMailMap+", Msg:"+StringUtil.checkNull(setMailMap.get("type")));
				}else{
					System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMap.get("msg")));
				}
				
				model.put("itemID", itemID);
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
				target.put(AJAX_SCRIPT, "parent.fnCallBackAdd('"+itemID+"');");
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/deleteTerm.do")
	public String deleteTerm(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		try {
				Map setMap = new HashMap();	
				String itemID = StringUtil.checkNull(request.getParameter("itemID"));
				setMap.put("FromItemID", itemID); 
				setMap.put("ToItemID", itemID);
				
				commonService.update("item_SQL.processDeleteCheck",setMap);
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069"));
				target.put(AJAX_SCRIPT, "fnCallBack();");
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/termsURL.do")
	public String termsURL(ModelMap model, HashMap cmmMap) throws Exception {		
		Map target = new HashMap();	
		try {		
				String url = StringUtil.checkNull(cmmMap.get("url"))+".do";
				
				target.put(AJAX_SCRIPT, "parent.creatMenuTab('"+cmmMap.get("menuID")+"', '"+url+"', '1');");					
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		model.addAttribute(AJAX_RESULTMAP,target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/popupTermsMgt.do")
	public String popupTermsMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		try {			
				String arcCode =  StringUtil.checkNull(cmmMap.get("arcCode"),"");
				String menuStyle =  StringUtil.checkNull(cmmMap.get("menuStyle"),"");
				String searchValue =  StringUtil.checkNull(cmmMap.get("searchValue"),"");
				
				Map setMap = new HashMap();
				setMap.put("languageID", cmmMap.get("sessionCurrLangType"));				
				setMap.put("s_itemID", "AT00034");
				List LOVAT34List = commonService.selectList("attr_SQL.selectAttrLovOption", setMap);
				
				Map dataMap = new HashMap();
				dataMap.put("CODE", "");
				dataMap.put("NAME", "ALL");
				
				LOVAT34List.add(0, dataMap);
				model.put("LOVAT34List", LOVAT34List);
				model.put("arcCode", arcCode);
				model.put("menuStyle", menuStyle);
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
				model.addAttribute(HTML_HEADER, "Standard Terms");
				model.put("csr", cmmMap.get("csr"));
				model.put("mgt", cmmMap.get("mgt"));
				model.put("linkOption", cmmMap.get("linkOption"));
				
				String pmenuIndex = ""; 
				int index = 1;
				for(int i=0; i<LOVAT34List.size(); i++){				
					if(i==0){
						pmenuIndex = ""+index;
					}else{
						pmenuIndex = pmenuIndex +" "+ index;
					}
					index++;
				}
				model.put("pmenuIndex",pmenuIndex);
				model.put("searchValue",searchValue);
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl("/itm/term/termsMgt");
	}
	
	@RequestMapping(value="/itemTermsMgt.do")
	public String itemTermsMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		try {			
				String arcCode =  StringUtil.checkNull(cmmMap.get("arcCode"),"");
				String menuStyle =  StringUtil.checkNull(cmmMap.get("menuStyle"),"");
				Map setMap = new HashMap();
				setMap.put("languageID", cmmMap.get("sessionCurrLangType"));				

				model.put("arcCode", arcCode);
				model.put("menuStyle", menuStyle);
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
				model.addAttribute(HTML_HEADER, "Standard Terms");
				model.put("csr", cmmMap.get("csr"));
				model.put("mgt", cmmMap.get("mgt"));
				model.put("linkOption", cmmMap.get("linkOption"));
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl("/itm/term/itemTermsMgt");
	}

	@RequestMapping(value="/itemTerms.do")
	public String itemTerms(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		model.addAttribute(HTML_HEADER, "Standard Terms");
		
		try { 
				String itemID = StringUtil.checkNull(request.getParameter("itemID"), "");
				String page = StringUtil.checkNull(request.getParameter("page"), "1");
				String searchCondition1 = StringUtil.checkNull(request.getParameter("searchCondition1"), ""); // 검색 조건
				String searchCondition2 = StringUtil.checkNull(request.getParameter("searchCondition2"), ""); // 검색 조건
				String searchCondition3 = StringUtil.checkNull(request.getParameter("searchCondition3"), ""); // 검색 조건
				String searchCondition4 = StringUtil.checkNull(request.getParameter("searchCondition4"), ""); // 검색 조건
				String languageID =StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
				String userId = StringUtil.checkNull(commandMap.get("sessionUserId"));
				String searchValue =StringUtil.replaceFilterString(StringUtil.checkNull(commandMap.get("searchValue")));
				String arcCode = StringUtil.checkNull(request.getParameter("arcCode"), "");
				/**첨부문서 **/
				String myItem = commonService.selectString("item_SQL.checkMyItem", commandMap);
				model.put("myItem", myItem);

				commandMap.put("DocumentID", itemID);
				commandMap.put("languageID", languageID);
				commandMap.put("DocCategory", "ITM");
				/* 의견공유, 변경이력, 첨부문서 화면의 표시 여부를 취득 */
				Map setValue = new HashMap();
				setValue.put("s_itemID", itemID);
				setValue.put("languageID", request.getParameter("languageID"));
				
				/* edit 가능 한 Item 인지 Item Status를 취득해서 판단 */
				String itemBlocked = commonService.selectString("project_SQL.getItemBlocked", setValue);
				
				setValue.put("itemId", itemID);
				String itemFileOption = commonService.selectString("fileMgt_SQL.getFileOption", setValue);
				
				Map menuDisplayMap = commonService.select("item_SQL.getMenuIconDisplay", setValue);
				
				//첨부문서
				List attachFileList = commonService.selectList("fileMgt_SQL.getFile_gridList",commandMap);
				

				
				
				/** BEGIN ::: LANGUAGE**/
				HashMap cmmMap = new HashMap();
				HashMap getMap = new HashMap();
				
				cmmMap.put("languageID", languageID);
				cmmMap.put("userId", userId);
				String clientId = StringUtil.checkNull(commonService.selectString("standardTerms_SQL.getUserClientId", cmmMap));
				
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/
				/** END ::: LANGUAGE**/
				
				Map mapValue = new HashMap();
				mapValue.put("languageID", languageID);
				
				if (!searchCondition1.isEmpty()) {
					mapValue.put("searchCondition1", searchCondition1);
				} else if (!searchCondition2.isEmpty()) {
					mapValue.put("searchCondition2", searchCondition2);
				} else if (!searchCondition3.isEmpty()) {
					mapValue.put("searchCondition3", searchCondition3);
					mapValue.put("searchCondition4", searchCondition4);
				}
				
				//gridData
//				commandMap.put("languageID", languageID);
//				commandMap.put("itemID", itemID);
//			    List termsList = commonService.selectList("standardTerms_SQL.getSubItemList_gridList", commandMap);
//		        JSONArray gridData = new JSONArray(termsList);
//		        model.put("gridData",gridData);	
				
				cmmMap.put("s_itemID", itemID);
				model.put("itemPath", commonService.selectString("item_SQL.getItemPath", cmmMap));
								
		        model.put("itemID", itemID);
				model.put("languageID", languageID);
				model.put("clientID", clientId);
				model.put("page", page);
				model.put("searchCondition1", searchCondition1);
				model.put("searchCondition2", searchCondition2);
				model.put("searchCondition3", searchCondition3);
				model.put("searchCondition4", searchCondition4);
				model.put("pageScale", GlobalVal.LIST_PAGE_SCALE);
				model.put("csr", StringUtil.replaceFilterString(StringUtil.checkNull(commandMap.get("csr"))));
				model.put("mgt", StringUtil.replaceFilterString(StringUtil.checkNull(commandMap.get("mgt"))));
				model.put("option", StringUtil.replaceFilterString(StringUtil.checkNull(commandMap.get("option"))));
				model.put("searchValue", searchValue);
				model.put("linkOption", StringUtil.replaceFilterString(StringUtil.checkNull(commandMap.get("linkOption"))));
				model.put("defaultLang", commonService.selectString("config_SQL.defaultLanguageID", cmmMap));
				model.put("attachFileList", attachFileList);
				model.put("myItem", myItem);
				model.put("menuDisplayMap", menuDisplayMap);
				model.put("itemBlocked", itemBlocked);
				model.put("langFilter", StringUtil.checkNull(request.getParameter("langFilter")));
				model.put("arcCode", arcCode);
				model.put("itemFileOption", itemFileOption);
				
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("/itm/term/itemTerms");
	}
	
	// itemID 받아서 상위 리스트 리턴
	@RequestMapping(value = "/getParentID.do", method = RequestMethod.GET)
	@ResponseBody
	public void getParentID(HttpServletRequest request,  HttpServletResponse res, HashMap<String, Object> cmmMap, ModelMap model) throws Exception {
		JSONObject jsonObject = new JSONObject();
		Map setMap = new HashMap();
		
		res.setHeader("Cache-Control", "no-cache");
		res.setContentType("text/plain");
		res.setCharacterEncoding("UTF-8");
		
	    try {
	    	String itemID = StringUtil.checkNull(request.getParameter("itemID"),"");
	    	setMap.put("itemID", itemID);
	        setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
	        
	        String parentID = commonService.selectString("item_SQL.getParentItemID", setMap); 
	        setMap.put("s_itemID", parentID);
	        
	        String parentClassCode = commonService.selectString("report_SQL.getItemClassCode", setMap); 
			jsonObject.put("parentID", parentID);
			jsonObject.put("parentClassCode", parentClassCode);
	        res.getWriter().print(jsonObject);
	    } catch (Exception e) {
	        System.out.println(e.toString());
	        res.getWriter().print(jsonObject);
	    }
	}
}
