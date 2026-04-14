package xbolt.hom.sch.web;

import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringEscapeUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.org.json.JSONArray;
import com.org.json.JSONObject;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

@Controller
@SuppressWarnings("unchecked")
public class SearchActionController extends XboltController {
	
	@Resource(name = "commonService")
    private CommonService commonService;

	@RequestMapping(value="/searchList.do")
	public String searchList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		String url = "/hom/search/searchList";
		
		String searchValue = StringUtil.checkNull(request.getParameter("searchValue"));
		searchValue = StringUtil.replaceFilterString(searchValue);
		
		try{
			Map setMap = new HashMap();
			
			// menucat 파라메터가 설정되어서 본 이벤트를 호출 하는 경우 : 아이템 트리의 하위항목 
			String menuCat = StringUtil.checkNull(request.getParameter("menucat"));
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			String isNothingLowLank = "";
			String screenType = StringUtil.checkNull(request.getParameter("screenType"));
			String defDimTypeID = StringUtil.checkNull(request.getParameter("defDimTypeID"));
			String defDimValueID = "";
			String fixDimYN = "N"; // dimension select 고정 option
			
			String templCode = StringUtil.checkNull(request.getParameter("templCode"));
			if (!templCode.isEmpty()) {
				setMap.put("templCode", templCode);
				String templVarFilter = commonService.selectString("menu_SQL.getTemplVarFilter", setMap);
				String parameterName1 = "defDimValueID";
				String parameterName2 = "fixDimValueOption";
	
				String[] params = templVarFilter.split("&");
				for (String param : params) {
				    String[] keyValue = param.split("=");
				    if (keyValue.length == 2 && keyValue[0].equals(parameterName1)) {
				        defDimValueID = keyValue[1];
				    }
				    if (keyValue.length == 2 && keyValue[0].equals(parameterName2)) {
				    	fixDimYN = keyValue[1];
				    }
				}
			}
			String childItems = "";
			setMap.put("s_itemID", s_itemID);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			
			if (!menuCat.isEmpty()) {
				// 선택된 아이템의 하위항목을 모두 취득
				childItems = getChildItemList(s_itemID);
				if (childItems.isEmpty()) {
					isNothingLowLank = "Y";
				}
				model.put("s_itemID", s_itemID);
				model.put("option", StringUtil.checkNull(request.getParameter("option")));
				model.put("pop", StringUtil.checkNull(request.getParameter("pop")));
				
				
				// [ClassCode] List 취득, 해당 아이템 하위의 classcode리스트를 설정
				Map selectedItemInfoMap = commonService.select("project_SQL.getItemInfo", setMap);
				String itemTypeCode = StringUtil.checkNull(selectedItemInfoMap.get("ItemTypeCode"));
				String classCode =  StringUtil.checkNull(selectedItemInfoMap.get("ClassCode"));
				
				setMap.put("ItemTypeCode", itemTypeCode);
				setMap.put("ItemClassCode", classCode);
				List classCodeList = commonService.selectList("search_SQL.getLowlankClassCodeList", setMap);
				
				model.put("classCodeList", classCodeList);
				model.put("ItemTypeCode", itemTypeCode);
				
				// Login user editor 권한 추가
//				String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev")); // 시스템 관리자
//				Map itemAuthorMap = commonService.select("project_SQL.getItemAuthorIDAndLockOwner", setMap);
//				if (StringUtil.checkNull(itemAuthorMap.get("AuthorID")).equals(commandMap.get("sessionUserId")) 
//						|| StringUtil.checkNull(itemAuthorMap.get("LockOwner")).equals(commandMap.get("sessionUserId"))
//						|| "1".equals(sessionAuthLev)) {
//					model.put("myItem", "Y");
//				}
				
				String myItem = commonService.selectString("item_SQL.checkMyItem", commandMap);
				model.put("myItem", myItem);
				
		        url = "/itm/search/searchListForItem";
			}

			commandMap.put("Category", "ITMSTS");
			List statusList = commonService.selectList("common_SQL.getDicWord_commonSelect", commandMap);
			model.put("statusList", statusList);
			commandMap.put("Deactivated", "1");
			
			List itemTypeList = commonService.selectList("common_SQL.itemTypeCode_commonSelect", commandMap);
			commandMap.remove("Deactivated");
			model.put("itemTypeList", itemTypeList);
			
			/** DimTypeId List */
			List dimTypeList = commonService.selectList("dim_SQL.getDimTypeList", commandMap);	
			model.put("dimTypeList", dimTypeList);
	        
			/** 법인 List */
	        setMap.put("TeamType", "2");
			List companyOptionList = commonService.selectList("organization_SQL.getTeamList", setMap);
			model.put("companyOption", companyOptionList);
			
			/** Symbol List */
			List symbolCodeList = commonService.selectList("search_SQL.getSymbolCodeList", setMap);
			model.put("symbolCodeList", symbolCodeList);
			
			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", commandMap);
			
			if(screenType.equals("main")){
				model.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("itemTypeCode")));
				model.put("classCode", StringUtil.checkNull(request.getParameter("classCode")));
				model.put("AttrCode", StringUtil.checkNull(request.getParameter("searchKey")));
				model.put("searchValue", searchValue);
				model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
				model.put("searchTeamName", StringUtil.checkNull(request.getParameter("searchTeamName")));
				model.put("searchAuthorName", StringUtil.checkNull(request.getParameter("searchAuthorName")));


		        commandMap.put("teamID",commandMap.get("sessionTeamId"));
		        commandMap.put("memberID",commandMap.get("sessionUserId"));
		        commandMap.put("searchText", searchValue);
		        
				commonService.insert("search_SQL.insertSearchLog", commandMap);	
			}
			model.put("menuCat", menuCat);
			model.put("isNothingLowLank", isNothingLowLank);
			model.put("defaultLang", defaultLang);
			model.put("defDimValueID", defDimValueID);
			model.put("defDimTypeID", defDimTypeID);
			model.put("fixDimYN",fixDimYN);
			model.put("childItems", childItems);
			model.put("menu", getLabel(request, commonService));
			model.put("idExist", StringUtil.checkNull(request.getParameter("idExist")));	
			model.put("accMode", StringUtil.checkNull(commandMap.get("accMode")));

		} catch(Exception e) {
			System.out.println(e.toString());
		}		
		
		return nextUrl(url);
	}
	
	@RequestMapping(value="/searchItemWFile.do")
	public String searchItemWFile(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		String url = "/hom/search/searchItemWFile";
		String searchValue = StringUtil.checkNull(request.getParameter("searchValue"));
		searchValue = StringUtil.replaceFilterString(searchValue).replace("'","`");
		try{
			commandMap.put("Deactivated", "1");
			List itemTypeList = commonService.selectList("common_SQL.itemTypeCode_commonSelect", commandMap);
			model.put("itemTypeList", itemTypeList);
			model.put("AttrCode","AT00001");
			
			commandMap.put("category", "ITMSTS");
			List statusList = commonService.selectList("common_SQL.getDictionaryOrdStnm_commonSelect", commandMap);
			model.put("statusList", statusList);
			
			List attrTypeList = commonService.selectList("search_SQL.getAllocAttrTypeCodeList", commandMap);
			model.put("attrTypeList", attrTypeList);
			model.put("searchValue", searchValue);
			model.put("menu", getLabel(request, commonService));
			
		} catch(Exception e) {
			System.out.println(e.toString());
		}		
		
		return nextUrl(url);
	}
	
	@RequestMapping(value="/searchItemWFileList.do")
	public String searchItemWFileList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		String url = "/hom/search/searchItemWFileList";
		try{
			String itemIDs = StringUtil.checkNull(commandMap.get("itemIDs"));
			String searchQuery = StringUtil.checkNull(commandMap.get("searchQuery"),"");
			String itemTypeCode = StringUtil.checkNull(commandMap.get("ItemTypeCode"));
			String fileItemListYN = StringUtil.checkNull(commandMap.get("fileItemListYN"));
			if(fileItemListYN.equals("Y")) {
				url = "/itm/fileItm/searchFileItemList";
			}
			
			String AuthorName = StringUtil.checkNull(commandMap.get("AuthorName"),"");
			String OwnerTeamName = StringUtil.checkNull(commandMap.get("OwnerTeamName"),"");
			String StartDate = StringUtil.checkNull(commandMap.get("StartDate"),"");
			String EndDate = StringUtil.checkNull(commandMap.get("EndDate"),"");
			String StatusCode = StringUtil.checkNull(commandMap.get("StatusCode"),"");
			
	    	String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"),GlobalVal.DEFAULT_LANGUAGE);
			//List itemArrayList = (List) commandMap.get("AttrCode");
			String itemArrayList = StringUtil.checkNull(commandMap.get("itemArrayList"));
			String fileArrayList = StringUtil.checkNull(commandMap.get("fileArrayList"));
			String[] itemArrayTemp = null;
			String[] fileArrayTemp = null;
			
			commandMap.put("languageID", languageID);
			SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Map logMap = new HashMap();
			
			logMap.put("searchText",searchQuery);
			logMap.put("memberID",StringUtil.checkNull(commandMap.get("sessionUserId")));
			logMap.put("teamID",StringUtil.checkNull(commandMap.get("sessionTeamId")));
			
			commonService.insert("search_SQL.insertSearchLog", logMap);
			
			if(itemArrayList.indexOf("@OLM_ARRAY_END@,@OLM_ARRAY_START@") > -1) {
				itemArrayTemp = itemArrayList.split("@OLM_ARRAY_END@,@OLM_ARRAY_START@");
			}
			else if(itemArrayList.indexOf("@OLM_ARRAY_END@") > -1) {
				itemArrayTemp = new String[1];
				itemArrayTemp[0] = itemArrayList;
			}
			else {
				itemArrayTemp = new String[0];
			}
			
			if(fileArrayList.indexOf("@OLM_FILE_ARRAY_END@,@OLM_FILE_ARRAY_START@") > -1) {
				fileArrayTemp = fileArrayList.split("@OLM_FILE_ARRAY_END@,@OLM_FILE_ARRAY_START@");
			}
			else if(fileArrayList.indexOf("@OLM_FILE_ARRAY_END@") > -1) {
				fileArrayTemp = new String[1];
				fileArrayTemp[0] = fileArrayList;
			}
			else {
				fileArrayTemp = new String[0];
			}

			if(fileArrayList.indexOf("@OLM_FILE_ARRAY_END@,@OLM_FILE_ARRAY_START@") > -1) {
				fileArrayTemp = fileArrayList.split("@OLM_FILE_ARRAY_END@,@OLM_FILE_ARRAY_START@");
			}
			else if(fileArrayList.indexOf("@OLM_FILE_ARRAY_END@") > -1) {
				fileArrayTemp = new String[1];
				fileArrayTemp[0] = fileArrayList;
			}
			else {
				fileArrayTemp = new String[0];
			}
			
			String searchQuery2 = StringUtil.checkNull(commandMap.get("searchQuery"),"").replace(" ","");
			
			if(searchQuery.equals(searchQuery2)) {
				searchQuery2 = "";
			}
			
			Map setMap = new HashMap();
			List searchList = new ArrayList();
			Map attrTypeMap = new HashMap();
			String afterItemID = "";
			int j=1;
			String itemIDs2 = "";

			Map fileMap = new HashMap();

			for(int i=0; i<fileArrayTemp.length; i++) {
				String[] temp = fileArrayTemp[i].replace("@OLM_FILE_ARRAY_END@", "").split("@OLM@");

				fileMap.put(temp[0], temp[1]);
			
			}

			for(int i=0; i<itemArrayTemp.length; i++) {
				String[] temp = itemArrayTemp[i].replace("@OLM_ARRAY_END@", "").split("@OLM@");
				
				if(!"".equals(StartDate) && !"".equals(EndDate)) {

					Date StartDT = transFormat.parse(StartDate);	
					Date EndDT = transFormat.parse(EndDate);		
					Date searchDT = transFormat.parse(temp[10]);
					
					if(!StartDT.after(searchDT) || !EndDT.before(searchDT)) {
						continue;
					}
					
				}
				Map tempMap = new HashMap();
				
				String itemID = StringUtil.checkNull(temp[0]);
				setMap.put("typeCode",temp[6]);
				setMap.put("languageID",languageID);
				setMap.put("category","AT");
				String attrName = StringUtil.checkNull(commonService.selectString("common_SQL.getNameFromDic",setMap));
				
				String itemContents = StringUtil.checkNull(temp[7]);
				String itemContentsOrg = StringUtil.checkNull(temp[7]);
				int queryIndex = itemContents.indexOf(searchQuery); 
				int lastIndex =	itemContents.length() > 300 ? 100 : itemContents.length() - queryIndex; 
				int	startIndex = queryIndex > 20 ? queryIndex - 20 : 0; 
				
				itemContents = itemContents.substring(startIndex,(itemContents.length() < queryIndex+lastIndex ? itemContents.length() : queryIndex+lastIndex));
				temp[7] = itemContents;
				
				if(i == 0 || "".equals(itemIDs2)) {
					itemIDs2 =  itemID;
				}
				else  {
					itemIDs2 = itemIDs2 + "," + itemID;
				}

				if(!"".equals(searchQuery2)) {
					temp[2] = temp[2].replaceAll("(?i)"+searchQuery2, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery2+"\"</span>");
					temp[7] = temp[7].replaceAll("(?i)"+searchQuery2, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery2+"\"</span>");
				}
				
				if(!"".equals(searchQuery)) {
					temp[2] = temp[2].replaceAll("(?i)"+searchQuery, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery+"\"</span>");
					temp[7] = temp[7].replaceAll("(?i)"+searchQuery, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery+"\"</span>");
				}
							
				if(!afterItemID.equals(itemID) && ( StringUtil.checkNull(temp[2].toLowerCase()).contains(searchQuery.toLowerCase()) || itemContentsOrg.toLowerCase().contains(searchQuery.toLowerCase()) ) ) {
				
					tempMap.put("ItemID",temp[0]);			
					tempMap.put("Identifier",temp[1]);		
					tempMap.put("ItemName",temp[2].replaceAll("\"\"","\""));			
					tempMap.put("Path",temp[3]);				
					tempMap.put("ItemTypeCode",temp[4]);		
					tempMap.put("StatusName",temp[5]);	
					
					if(!"AT00001".equals(temp[6])) {
						tempMap.put(temp[6],"[" + attrName + "]&nbsp;&nbsp;&nbsp;&nbsp;"+temp[7].replaceAll("\"\"","\""));
					}
					
					tempMap.put("Name",temp[8]);			
					tempMap.put("TeamName",temp[9]);			
					tempMap.put("LastUpdated",temp[10]);
					afterItemID = StringUtil.checkNull(temp[0]);

					commandMap.put("DocumentID", StringUtil.checkNull(temp[0]));
					List documentList = new ArrayList();
					List documentList2 = commonService.selectList("fileMgt_SQL.getFile_gridList", commandMap);
					
					if(documentList2 != null && !documentList2.isEmpty()) {

						if(documentList2.size() > 20) {
							
							for(int k=0; k < documentList2.size(); k++) {
								Map tempMap2 = (Map) documentList2.get(k);
								String seq = StringUtil.checkNull(tempMap2.get("Seq"));
								String fileRealName = StringUtil.checkNull(tempMap2.get("FileRealName"));
								String fileName = StringUtil.checkNull(tempMap2.get("FileName"));
								
								if(fileMap.containsKey(seq)) {
									String fileDesc = StringUtil.checkNull(fileMap.get(seq),"");
									
									if(!"||".equals(fileDesc)) {
										if(!"".equals(searchQuery2)) {
											fileDesc = fileDesc.replaceAll("(?i)"+searchQuery2, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery2+"\"</span>");
										}
										
										if(!"".equals(searchQuery)) {
											fileDesc = fileDesc.replaceAll("(?i)"+searchQuery, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery+"\"</span>");
										}
	
										if("".equals(fileRealName)) {
											tempMap2.put("FileRealName", fileName);
										}
										tempMap2.put("fileDescription", "->" + fileDesc);
										}
									else {
										tempMap2.put("fileDescription", "->");
									}

									fileMap.put("itemId", StringUtil.checkNull(temp[0]));
									Map result  = commonService.select("fileMgt_SQL.selectItemAuthorID",fileMap);
									String itemFileOption = commonService.selectString("fileMgt_SQL.getFileOption",fileMap);
									tempMap2.put("itemFileOption", itemFileOption);
									
//									String sessionUserID = StringUtil.checkNull(commandMap.get("sessionUserId"));
//									String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev"));
//									
//									if (StringUtil.checkNull(result.get("AuthorID")).equals(sessionUserID)
//											|| StringUtil.checkNull(result.get("LockOwner")).equals(commandMap.get("sessionUserId"))
//											|| "1".equals(sessionAuthLev)) {
//										tempMap2.put("myItem", "Y");
//									}else {
//										tempMap2.put("myItem", "N");
//									}
									
									String myItem = commonService.selectString("item_SQL.checkMyItem", commandMap);
									tempMap2.put("myItem", myItem);
									
									documentList.add(tempMap2);
								}
							}

						}
						else {
							for(int k=0; k < documentList2.size(); k++) {
								Map tempMap2 = (Map) documentList2.get(k);
								String seq = StringUtil.checkNull(tempMap2.get("Seq"));
								String fileRealName = StringUtil.checkNull(tempMap2.get("FileRealName"));
								String fileName = StringUtil.checkNull(tempMap2.get("FileName"));
								
								if(fileMap.containsKey(seq)) {
									String fileDesc = StringUtil.checkNull(fileMap.get(seq),"");
									if(!"||".equals(fileDesc)) {
										if(!"".equals(searchQuery2)) {
											fileDesc = fileDesc.replaceAll("(?i)"+searchQuery2, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery2+"\"</span>");
										}
										
										if(!"".equals(searchQuery)) {
											fileDesc = fileDesc.replaceAll("(?i)"+searchQuery, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery+"\"</span>");
										}
	
										if("".equals(fileRealName)) {
											tempMap2.put("FileRealName", fileName);
										}
										tempMap2.put("fileDescription", "->" + fileDesc);
									}
									else {
										tempMap2.put("fileDescription", "->");										
									}
								}

								fileMap.put("itemId", StringUtil.checkNull(temp[0]));
								Map result  = commonService.select("fileMgt_SQL.selectItemAuthorID",fileMap);
								String itemFileOption = commonService.selectString("fileMgt_SQL.getFileOption",fileMap);
								tempMap2.put("itemFileOption", itemFileOption);
								
								String sessionUserID = StringUtil.checkNull(commandMap.get("sessionUserId"));
								String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev"));
								
//								if (StringUtil.checkNull(result.get("AuthorID")).equals(sessionUserID)
//										|| StringUtil.checkNull(result.get("LockOwner")).equals(commandMap.get("sessionUserId"))
//										|| "1".equals(sessionAuthLev)) {
//									tempMap2.put("myItem", "Y");
//								}else {
//									tempMap2.put("myItem", "N");
//								}
								
								String myItem = commonService.selectString("item_SQL.checkMyItem", commandMap);
								tempMap2.put("myItem", myItem);
								
								documentList.add(tempMap2);
							}
						}
					}

					tempMap.put("documentList",documentList);		
					searchList.add(tempMap);
				}
				else if(afterItemID.equals(itemID)) {
					Map temp2 = (Map) searchList.get(i-j);
					
					if(!"AT00001".equals(temp[6]) && StringUtil.checkNull(temp[7]).contains(searchQuery)) {
						temp2.put(temp[6],"[" + attrName + "]&nbsp;&nbsp;&nbsp;&nbsp;"+temp[7].replaceAll("\"\"","\""));	
					}
									
					searchList.remove(i-j);
					searchList.add(temp2);
					j++;
				} 
				
				if(!attrTypeMap.containsKey(temp[6])) {
					attrTypeMap.put(temp[6],temp[6]);
				}
			}

			model.put("attrTypeMap", attrTypeMap);	
			model.put("attrTypeMapCnt", attrTypeMap.size());	
			model.put("menu", getLabel(request, commonService));		
			//  AttrCode=[{attrCode=AT00001, selectOption=AND, AttrCodeEscape=, constraint=, searchValue=원부자재}]

			
			Map setMap2 = new HashMap();
			setMap2.put("childItems",itemIDs);
			setMap2.put("masterItemId", itemIDs2);
			setMap2.put("languageID",languageID);
			setMap2.put("ItemTypeCode",itemTypeCode);
			setMap2.put("OwnerTeam",OwnerTeamName);
			setMap2.put("Status",StatusCode);
			setMap2.put("Name",AuthorName);
			setMap2.put("LastUpdated","Y");
			setMap2.put("scStartDt2",StartDate);
			setMap2.put("scEndDt2",EndDate);
			List searchList2 = new ArrayList();
			if(!"".equals(itemIDs)) {
				searchList2 = commonService.selectList("search_SQL.getSearchMultiList_gridList", setMap2);
			}
			
			String itemList2 = "";
			if(searchList2.size()>0) {
				for(int i1=0; i1<searchList2.size(); i1++) {
					Map listMap = (Map)searchList2.get(i1);
					if(i1==0) {
						itemList2 = StringUtil.checkNull(listMap.get("ItemID"));
					}else {
						itemList2 += "," + StringUtil.checkNull(listMap.get("ItemID"));
					}
					
					commandMap.put("DocumentID", StringUtil.checkNull(listMap.get("ItemID")));
					List documentList = new ArrayList();
					List documentList2 = commonService.selectList("fileMgt_SQL.getFile_gridList", commandMap);

					if(documentList2 != null && !documentList2.isEmpty()) {

						if(documentList2.size() > 20) {
							for(int k=0; k < documentList2.size(); k++) {
								Map tempMap2 = (Map) documentList2.get(k);
								String seq = StringUtil.checkNull(tempMap2.get("Seq"));
								String fileRealName = StringUtil.checkNull(tempMap2.get("FileRealName"));
								String fileName = StringUtil.checkNull(tempMap2.get("FileName"));
								
								if(fileMap.containsKey(seq)) {
									String fileDesc = StringUtil.checkNull(fileMap.get(seq),"");
									if(!"||".equals(fileDesc)) {
										if(!"".equals(searchQuery2)) {
											fileDesc = fileDesc.replaceAll(searchQuery2, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery2+"\"</span>");
										}
										
										if(!"".equals(searchQuery)) {
											fileDesc = fileDesc.replaceAll(searchQuery, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery+"\"</span>");
										}
										
										tempMap2.put("fileDescription", "->" + fileDesc);
									}
									else {
										tempMap2.put("fileDescription", "->");
									}
									if("".equals(fileRealName)) {
										tempMap2.put("FileRealName", fileName);
									}
									
									fileMap.put("itemId", StringUtil.checkNull(listMap.get("ItemID")));
									Map result  = commonService.select("fileMgt_SQL.selectItemAuthorID",fileMap);
									String itemFileOption = commonService.selectString("fileMgt_SQL.getFileOption",fileMap);
									tempMap2.put("itemFileOption", itemFileOption);
									
//									String sessionUserID = StringUtil.checkNull(commandMap.get("sessionUserId"));
//									String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev"));
//									
//									if (StringUtil.checkNull(result.get("AuthorID")).equals(sessionUserID)
//											|| StringUtil.checkNull(result.get("LockOwner")).equals(commandMap.get("sessionUserId"))
//											|| "1".equals(sessionAuthLev)) {
//										tempMap2.put("myItem", "Y");
//									}else {
//										tempMap2.put("myItem", "N");
//									}
									
									String myItem = commonService.selectString("item_SQL.checkMyItem", commandMap);
									tempMap2.put("myItem", myItem);
																		
									documentList.add(tempMap2);
								}
							}

						}
						else {
							for(int k=0; k < documentList2.size(); k++) {
								Map tempMap2 = (Map) documentList2.get(k);
								String seq = StringUtil.checkNull(tempMap2.get("Seq"));
								String fileRealName = StringUtil.checkNull(tempMap2.get("FileRealName"));
								String fileName = StringUtil.checkNull(tempMap2.get("FileName"));
								
								if(fileMap.containsKey(seq)) {
									String fileDesc = StringUtil.checkNull(fileMap.get(seq),"");

									if(!"||".equals(fileDesc)) {
										if(!"".equals(searchQuery2)) {
											fileDesc = fileDesc.replaceAll(searchQuery2, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery2+"\"</span>");
										}
										
										if(!"".equals(searchQuery)) {
											fileDesc = fileDesc.replaceAll(searchQuery, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery+"\"</span>");
										}
										tempMap2.put("fileDescription", "->" + fileDesc);
									}
									else {
										tempMap2.put("fileDescription", "->");										
									}

									if("".equals(fileRealName)) {
										tempMap2.put("FileRealName", fileName);
									}
								}

								fileMap.put("itemId", StringUtil.checkNull(listMap.get("ItemID")));
								Map result  = commonService.select("fileMgt_SQL.selectItemAuthorID",fileMap);
								String itemFileOption = commonService.selectString("fileMgt_SQL.getFileOption",fileMap);
								tempMap2.put("itemFileOption", itemFileOption);
								
//								String sessionUserID = StringUtil.checkNull(commandMap.get("sessionUserId"));
//								String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev"));
//								
//								if (StringUtil.checkNull(result.get("AuthorID")).equals(sessionUserID)
//										|| StringUtil.checkNull(result.get("LockOwner")).equals(commandMap.get("sessionUserId"))
//										|| "1".equals(sessionAuthLev)) {
//									tempMap2.put("myItem", "Y");
//								}else {
//									tempMap2.put("myItem", "N");
//								}
								
								String myItem = commonService.selectString("item_SQL.checkMyItem", commandMap);
								tempMap2.put("myItem", myItem);
								
								documentList.add(tempMap2);
							}
						}
					}
					listMap.put("documentList",documentList);

					String description = "";
					if (null != listMap.get("ProcessInfo")) {
						description = removeAllTag(StringUtil.checkNull(listMap.get("ProcessInfo")));
						if(description.length()>99) {
							description = description.substring(100) + "...";
						}
					}
					String ItemName = StringUtil.checkNull(listMap.get("ItemName"));
					//String ItemName = "";
					if(!"".equals(searchQuery2)) {
						ItemName = ItemName.replaceAll(searchQuery2, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery2+"\"</span>");
						description = description.replaceAll(searchQuery2, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery2+"\"</span>");
					}

					if(!"".equals(searchQuery)) {
						ItemName = ItemName.replace(searchQuery, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery+"\"</span>");
						description = description.replaceAll(searchQuery, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery+"\"</span>");
					}
	 				
					listMap.put("ItemName", ItemName.replaceAll("\"\"","\""));
					listMap.put("StringProcessInfo", description.replaceAll("\"\"","\""));
				}
			}

			if(searchList != null && !searchList.isEmpty() && searchList.size() > 0) {
				searchList.addAll(searchList.size(), searchList2);
			}
			else {
				searchList = searchList2;
			}
			
			String itemIDList = itemIDs2;
			
			if(!"".equals(itemList2)) {
				if(!"".equals(itemIDList)) {
					itemIDList = itemIDList + "," + itemList2;
				}else {
					itemIDList = itemList2;
				}
			}
			
			Map setData = new HashMap();			
			setData.put("itemIDList", itemIDList);
			setData.put("CategoryCode", commandMap.get("CategoryCode"));
			setData.put("Deactivated", "1");
			setData.put("languageID", commandMap.get("sessionCurrLangType"));
			
			List itemTypeList = new ArrayList();
			if(searchList.size()>0) {
				itemTypeList = commonService.selectList("search_SQL.getCountListItemByItemTypeCode", setData);
			}
			
			model.put("itemTypeList", itemTypeList);
			model.put("searchList", searchList);	
			
			List attrCodeList = commonService.selectList("search_SQL.getOlmItemDataAttrCodeList", setData);
			model.put("attrCodeList",attrCodeList);
			
		} catch(Exception e) {
			System.out.println(e.toString());
		}		
		
		return nextUrl(url);
	}
	
	private String removeAllTag(String str) {
		str = str.replaceAll("&gt;", ">").replaceAll("&lt;", "<").replaceAll("&#40;", "(").replaceAll("&#41;", ")").replace("&sect;","-");// .replaceAll("<br/>", "&&rn").replaceAll("<br />", "&&rn").replaceAll("\r\n", "&&rn");
		str = str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#10;", " ").replace("&#xa;", "").replace("&nbsp;", " ").replace("&amp;", "&");

		return StringEscapeUtils.unescapeHtml4(str);
	}
	
	@RequestMapping(value="/totalSearchList.do")
	public String totalSearchList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		String url = "/hom/search/totalSearchList";
		try{
			model.put("menu", getLabel(request, commonService));
			
		} catch(Exception e) {
			System.out.println(e.toString());
		}		
		
		return nextUrl(url);
	}
	
	@RequestMapping(value="/searchProcessList.do")
	public String searchProcessList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		String url = "/hom/search/searchProcessList";
		try{
			commandMap.put("Deactivated", "1");
			List itemTypeList = commonService.selectList("common_SQL.itemTypeCode_commonSelect", commandMap);
			String realMenuIndex = "";
			int index = 1;
			String itemTypeCode =  "";
			if(itemTypeList.size() > 0){				
				for(int i=0; i<itemTypeList.size(); i++){
					Map itemTypeInfo = (Map)itemTypeList.get(i);
					if(i == 0){
						realMenuIndex = "1";
						itemTypeCode = StringUtil.checkNull(itemTypeInfo.get("CODE"));
					}else{
						realMenuIndex = realMenuIndex + " " + index;
					}
					index++;
				}
			}
			String searchValue = StringUtil.checkNull(request.getParameter("searchValue"));
			model.put("searchValue", searchValue);
			model.put("realMenuIndex", realMenuIndex);
			model.put("itemTypeList", itemTypeList);
			model.put("itemTypeCode", itemTypeCode);
			model.put("menu", getLabel(request, commonService));
			
		} catch(Exception e) {
			System.out.println(e.toString());
		}		
		
		return nextUrl(url);
	}
	
	@RequestMapping(value="/multiSearchProcessList.do")
	public String multiSearchProcessList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		String url = "/hom/search/multiSearchProcessList";
		try{
			Map setMap = new HashMap();
			
			String isNothingLowLank = "";
			String screenType = StringUtil.checkNull(request.getParameter("screenType"));
			String defDimTypeID = StringUtil.checkNull(request.getParameter("defDimTypeID"));
			String defDimValueID = StringUtil.checkNull(request.getParameter("defDimValueID"));
			String searchValue = StringUtil.checkNull(request.getParameter("searchValue"));
			
			commandMap.put("Category", "ITMSTS");
			List statusList = commonService.selectList("common_SQL.getDicWord_commonSelect", commandMap);
			model.put("statusList", statusList);
			commandMap.put("Deactivated", "1");
			
			List itemTypeList = commonService.selectList("common_SQL.itemTypeCode_commonSelect", commandMap);
			commandMap.remove("Deactivated");
			model.put("itemTypeList", itemTypeList);
			
			/** DimTypeId List */
			List dimTypeList = commonService.selectList("dim_SQL.getDimTypeList", commandMap);	
			model.put("dimTypeList", dimTypeList);
	        
			/** 법인 List */
	        setMap.put("TeamType", "2");
			List companyOptionList = commonService.selectList("organization_SQL.getTeamList", setMap);
			model.put("companyOption", companyOptionList);
			
			/** Symbol List */
			List symbolCodeList = commonService.selectList("search_SQL.getSymbolCodeList", setMap);
			model.put("symbolCodeList", symbolCodeList);
			
			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", commandMap);
			
			if(screenType.equals("main")){
				model.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("itemTypeCode")));
				model.put("classCode", StringUtil.checkNull(request.getParameter("classCode")));
				model.put("AttrCode", StringUtil.checkNull(request.getParameter("searchKey")));
				model.put("searchValue", StringUtil.checkNull(request.getParameter("searchValue")));
				model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
				model.put("searchTeamName", StringUtil.checkNull(request.getParameter("searchTeamName")));
				model.put("searchAuthorName", StringUtil.checkNull(request.getParameter("searchAuthorName")));
			}
	
			model.put("isNothingLowLank", isNothingLowLank);
			model.put("defaultLang", defaultLang);
			model.put("defDimValueID", defDimValueID);
			model.put("defDimTypeID", defDimTypeID);
			model.put("menu", getLabel(request, commonService));
			model.put("idExist", StringUtil.checkNull(request.getParameter("idExist")));
			model.put("searchValue", searchValue);
			
		} catch(Exception e) {
			System.out.println(e.toString());
		}		
		
		return nextUrl(url);
	}
	
	/**
	 * 해당 DimTypeId의 [DimValueIdList]를 취득
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getDimValueSelectOption.do")
	public String getSearchSelectOption(HttpServletRequest request, HashMap commandMap,ModelMap model) throws Exception {
		
		commandMap.put("DimTypeID", request.getParameter("dimTypeId"));
		List getList = commonService.selectList("dim_SQL.getDimValueList" ,commandMap);
		
		String searchYN = StringUtil.checkNull(request.getParameter("searchYN"),"");
		
		if("Y".equals(searchYN)) {
			Map tempMap = new HashMap();
			tempMap.put("CODE", "Nothing");
			tempMap.put("NAME", "N/A");
			getList.add(0,tempMap);
		}
		
		model.put(AJAX_RESULTMAP, getList);
		return nextUrl(AJAXPAGE_SELECTOPTION);
	}
	
	
	@RequestMapping(value="/getSRArea2SelectOption.do")
	public String getSearchSRArea2SelectOption(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		
		Map setMap = new HashMap();
		
		setMap.put("languageID", request.getParameter("languageID"));
		setMap.put("userID", request.getParameter("userID"));
		setMap.put("srType", request.getParameter("srType"));
		setMap.put("parentID", request.getParameter("parentID"));
		
		List srArea2List = commonService.selectList("common_SQL.getSrArea2_commonSelect_List", setMap);
		
		model.put(AJAX_RESULTMAP, srArea2List);
		return nextUrl(AJAXPAGE_SELECTOPTION);
		
	}
	
	
	
	
	/**
	 * 해당 itemTypeCode 의 [symbolCodeList]를 취득
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getSymbolSelectOption.do")
	public String getSymbolSelectOption(HttpServletRequest request, HashMap commandMap,ModelMap model) throws Exception {
		
		commandMap.put("ItemTypeCode", request.getParameter("itemTypeCode"));
		List getList = commonService.selectList("search_SQL.getSymbolCodeList" ,commandMap);
		
		model.put(AJAX_RESULTMAP, getList);
		return nextUrl(AJAXPAGE_SELECTOPTION);
	}
	

	private String getChildItemList(String s_itemID) throws ExceptionUtil {
		String outPutItems = "";
		List delItemIdList = new ArrayList();
		List list = new ArrayList();
		Map map = new HashMap();
		Map setMap = new HashMap();
			try {
			String itemId = s_itemID;
			setMap.put("ItemID", itemId);
			//delItemIdList.add(itemId);
			
			// 취득한 아이템 리스트 사이즈가 0이면 while문을 빠져나간다.
			int j = 1;
			while (j != 0) { 
				String toItemId = "";
				
				setMap.put("CURRENT_ITEM", itemId); // 해당 아이템이 [FromItemID]인것
				setMap.put("CategoryCode", "ST1");
				//setMap.put("CategoryCodes", "'ST1','ST2'");
				list = commonService.selectList("report_SQL.getChildItems", setMap);
				j = list.size();
				for (int k = 0; list.size() > k; k++) {
					 map = (Map) list.get(k);
					 setMap.put("ItemID", map.get("ToItemID"));
					 delItemIdList.add(map.get("ToItemID"));
					 
					 if (k == 0) {
						 toItemId = "'" + String.valueOf(map.get("ToItemID")) + "'";
					 } else {
						 toItemId = toItemId + ",'" + String.valueOf(map.get("ToItemID")) + "'";
					 }
				}
				
				itemId = toItemId; // ToItemID를 다음 ItemID로 설정
			}
			
			outPutItems = "";
			for (int i = 0; delItemIdList.size() > i ; i++) {
				
				if (outPutItems.isEmpty()) {
					outPutItems += delItemIdList.get(i);
				} else {
					outPutItems += "," + delItemIdList.get(i);
				}
			}
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
		
		return outPutItems;
	}
	
	@RequestMapping(value="/itemSearchList.do")
	public String itemSearchList(HttpServletRequest request, ModelMap model) throws Exception{
		
		try{

			//메뉴 받아오기용 language값 넣기
			Map setMap = new HashMap();
			
			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			
			model.put("s_itemID", request.getParameter("s_itemID"));
			
			setMap.put("s_itemID", request.getParameter("s_itemID"));
			
			String ItemTypeCode =  commonService.selectString("config_SQL.getItemTypeCodeItemID", setMap);

			model.put("ItemTypeCode" 	,ItemTypeCode);
			
		}catch(Exception e){
			System.out.println(e.toString());
		}		
		
		return nextUrl("/itm/search/searchList");
	}
	
	@RequestMapping(value="/searchSubItemList.do")
	public String searchSubItemList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		String url = StringUtil.checkNull(request.getParameter("url"),"/itm/structure/searchSubItemList");
		
		try{
			Map setMap = new HashMap();
			
			// menucat 파라메터가 설정되어서 본 이벤트를 호출 하는 경우 : 아이템 트리의 하위항목 			
			String s_itemID = StringUtil.checkNull(request.getParameter("itemID"));
			String isNothingLowLank = "";
			String screenType = StringUtil.checkNull(request.getParameter("screenType"));	
			String accMode = StringUtil.checkNull(commandMap.get("accMode"),"OPS");		
			String childItems = "";
			
			if(s_itemID.equals("")) 
				s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			
			setMap.put("s_itemID", s_itemID);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			
		
			// 선택된 아이템의 하위항목을 모두 취득
			childItems = getChildItemList(s_itemID);
			if (childItems.isEmpty()) {
				isNothingLowLank = "Y";
			}
			model.put("s_itemID", s_itemID);
			model.put("option", StringUtil.checkNull(request.getParameter("option")));
			model.put("pop", StringUtil.checkNull(request.getParameter("pop")));
			
			
			// [ClassCode] List 취득, 해당 아이템 하위의 classcode리스트를 설정
			Map selectedItemInfoMap = commonService.select("project_SQL.getItemInfo", setMap);
			String itemTypeCode = StringUtil.checkNull(selectedItemInfoMap.get("ItemTypeCode"));
			String classCode =  StringUtil.checkNull(selectedItemInfoMap.get("ClassCode"));
						
			setMap.put("ItemTypeCode", itemTypeCode);
			setMap.put("ItemClassCode", classCode);
			List classCodeList = commonService.selectList("search_SQL.getLowlankClassCodeList", setMap);
			
			model.put("classCodeList", classCodeList);
			model.put("ItemTypeCode", itemTypeCode);
			
			// Login user editor 권한 추가
//			String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev")); // 시스템 관리자
//			Map itemAuthorMap = commonService.select("project_SQL.getItemAuthorIDAndLockOwner", setMap);
//			if (StringUtil.checkNull(itemAuthorMap.get("AuthorID")).equals(commandMap.get("sessionUserId")) 
//					|| StringUtil.checkNull(itemAuthorMap.get("LockOwner")).equals(commandMap.get("sessionUserId"))
//					|| "1".equals(sessionAuthLev)) {
//				model.put("myItem", "Y");
//			}
	    
			String myItem = commonService.selectString("item_SQL.checkMyItem", commandMap);
			model.put("myItem", myItem);

			commandMap.put("Category", "ITMSTS");
			List statusList = commonService.selectList("common_SQL.getDicWord_commonSelect", commandMap);
			model.put("statusList", statusList);
			commandMap.put("Deactivated", "1");
						
			/** DimTypeId List */
			List dimTypeList = commonService.selectList("dim_SQL.getDimTypeList", commandMap);	
			model.put("dimTypeList", dimTypeList);
	        
			/** 법인 List */
	        setMap.put("TeamType", "2");
			List companyOptionList = commonService.selectList("organization_SQL.getTeamList", setMap);
			model.put("companyOption", companyOptionList);
			
			/** Symbol List */
			List symbolCodeList = commonService.selectList("search_SQL.getSymbolCodeList", setMap);
			model.put("symbolCodeList", symbolCodeList);
			
			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", commandMap);
			
			if(screenType.equals("main")){
				model.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("itemTypeCode")));
				model.put("classCode", StringUtil.checkNull(request.getParameter("classCode")));
				model.put("AttrCode", StringUtil.checkNull(request.getParameter("searchKey")));
				model.put("searchValue", StringUtil.checkNull(request.getParameter("searchValue")));
				model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
				model.put("searchTeamName", StringUtil.checkNull(request.getParameter("searchTeamName")));
				model.put("searchAuthorName", StringUtil.checkNull(request.getParameter("searchAuthorName")));
			}
			
			String defItemTypeCode = StringUtil.checkNull(request.getParameter("defItemTypeCode"));
			String defClassCode = StringUtil.checkNull(request.getParameter("defClassCode"));
			String defCompany = StringUtil.checkNull(request.getParameter("defCompany"));
			String defOwnerTeam = StringUtil.checkNull(request.getParameter("defOwnerTeam"));
			String defAuthor = StringUtil.checkNull(request.getParameter("defAuthorName"));
			String defDimTypeID = StringUtil.checkNull(request.getParameter("defDimTypeID"));
			String defDimValueID = StringUtil.checkNull(request.getParameter("defDimValueID"));
			String defAttrTypeCode = StringUtil.checkNull(request.getParameter("defAttrTypeCode"));
			String defAttrTypeValue = StringUtil.checkNull(request.getParameter("defAttrTypeValue"));
			String defStatus = StringUtil.checkNull(request.getParameter("defStatus"));
			setMap.put("attrTypeCode", defAttrTypeCode);
			String defAttrTypeName = commonService.selectString("report_SQL.getAttrName", setMap);
			String itemInfoRptUrl = StringUtil.checkNull(request.getParameter("itemInfoRptUrl"));
			
			setMap.put("typeCode", itemTypeCode);
			setMap.put("category", "OJ");
			String itemTypeName = StringUtil.checkNull(commonService.selectString("common_SQL.getNameFromDic", setMap));		
			String selectedItemPath = StringUtil.checkNull(commonService.selectString("item_SQL.getItemPath", setMap));
			
			model.put("itemTypeName", itemTypeName);
			model.put("selectedItemPath", selectedItemPath);
			model.put("defAttrTypeName", defAttrTypeName);
			model.put("defItemTypeCode", defItemTypeCode);
			model.put("defClassCode", defClassCode);
			model.put("defCompany", defCompany);
			model.put("defOwnerTeam", defOwnerTeam);
			model.put("defAuthor", defAuthor);
			model.put("defDimTypeID", defDimTypeID);
			model.put("defDimValueID", defDimValueID);
			model.put("defAttrTypeCode", defAttrTypeCode);
			model.put("defAttrTypeValue", defAttrTypeValue);
			model.put("defStatus", defStatus);
			model.put("itemInfoRptUrl", itemInfoRptUrl);
			
			model.put("isNothingLowLank", isNothingLowLank);
			model.put("defaultLang", defaultLang);
			model.put("childItems", childItems);
			model.put("menu", getLabel(request, commonService));
			model.put("idExist", StringUtil.checkNull(request.getParameter("idExist")));
			model.put("ownerType", StringUtil.checkNull(request.getParameter("ownerType")));
			model.put("showTOJ", StringUtil.checkNull(request.getParameter("showTOJ")));
			model.put("accMode", accMode);
			
	
			
		} catch(Exception e) {
			System.out.println(e.toString());
		}		
		
		return nextUrl(url);
	}
	@RequestMapping(value="/getAutoCompText.do")
	public void getAutoCompText(HttpServletRequest request, HttpServletResponse response, HashMap commandMap, ModelMap model) throws Exception{
	    String searchValue = StringUtil.checkNull(request.getParameter("searchValue"));
	    String attrTypeCode = StringUtil.checkNull(request.getParameter("attrTypeCode"));
	    String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"));
	    String itemClassCode = StringUtil.checkNull(request.getParameter("itemClassCode"));
	    String sessionCurrLangUse = StringUtil.checkNull(request.getParameter("sessionCurrLangType"));
	    int searchListCnt = Integer.valueOf(StringUtil.checkNull(request.getParameter("searchListCnt"),"0"));
		Map setMap = new HashMap();
		JSONObject obj = new JSONObject();
		JSONArray company = new JSONArray();
		String keyValue = "";
		Map map;
		PrintWriter out;
		
		if(sessionCurrLangUse.equals("T")) {
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));	
		}
		setMap.put("attrTypeCode", attrTypeCode);
		setMap.put("searchValue", searchValue);
		setMap.put("itemTypeCode", itemTypeCode);
		setMap.put("itemClassCode", itemClassCode);
		setMap.put("searchListCnt", searchListCnt);
		List searchPlainTextList = commonService.selectList("item_SQL.getSearchPlainText", setMap);
		
		
		response.setContentType("text/html; charset=UTF-8");
		response.setHeader("Cache-control", "no-cache, no-store");
		response.setHeader("Pragma", "no-cache");
		response.setHeader("Expires", "-1");
		out = response.getWriter();
		try {
			
			for (int i = 0; i < searchPlainTextList.size(); i++) {
				map = (Map) searchPlainTextList.get(i);
				keyValue = String.valueOf(map.get("searchValue"));
				obj = new JSONObject();
				obj.put("label", keyValue);
				obj.put("value", StringEscapeUtils.unescapeHtml4(keyValue));
				company.put(obj);
			}
		} catch(Exception e) {
			throw new ExceptionUtil(e.toString());
		}
		//return aaa;
		out.println(company);
		out.close();
	}
	
	@RequestMapping(value="/getTotalSearchList.do")
	public void getTotalSearchList(HashMap cmmMap, HttpServletResponse response, HttpServletRequest request) throws Exception{
		try{ 	
			String sqlID = StringUtil.checkNull(cmmMap.get("sqlID"));			
			Map setData = new HashMap();
			setData.put("searchValue", cmmMap.get("searchValue"));
			setData.put("languageID", cmmMap.get("sessionCurrLangType"));
			sqlID = "search_SQL."+sqlID;
			List searchResultList = commonService.selectList(sqlID, setData);
			
			JSONArray searchResultListJson = new JSONArray(searchResultList);
						
			response.setHeader("Cache-Control", "no-cache");
			response.setContentType("text/plain");
			response.setCharacterEncoding("UTF-8");
			if(!StringUtil.checkNull(searchResultListJson).equals("")){
				response.getWriter().print(searchResultListJson);
			}
			else {
				PrintWriter pw = response.getWriter();
				pw.write("데이터가 존재하지 않습니다.");
			}

			System.out.println("json searchResultListJson :"+searchResultListJson);
		
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}	
	}
	
	@RequestMapping(value="/getItemWFileList.do")
	public void getItemWFileList(HttpServletRequest request, HttpServletResponse response, HashMap commandMap) throws Exception {
		Map setData = new HashMap();		
		String  resultJson = "";
		Map itemMap = new HashMap();
		Map fileMap = new HashMap();
		List totalList = new ArrayList();
		try {
			String query = StringUtil.checkNull(request.getParameter("query"));
			String mode = StringUtil.checkNull(request.getParameter("mode"));
			String sort = StringUtil.checkNull(request.getParameter("sort"),"ITEM_TYPE_CD, ITEM_CD");
			String listCount = StringUtil.checkNull(request.getParameter("listCount"),"100");
			String searchField = StringUtil.checkNull(request.getParameter("searchField"));
			String itemCD = StringUtil.checkNull(request.getParameter("itemCD"));
			String itemNM = StringUtil.checkNull(request.getParameter("itemNm"));
			String itemTypeNM = StringUtil.checkNull(request.getParameter("itemTypeNM"));
			String authorNM = StringUtil.checkNull(request.getParameter("authorNm"));
			String authorEmpNo = StringUtil.checkNull(request.getParameter("authorEmpNo"));
			String itemStatusNM = StringUtil.checkNull(request.getParameter("itemStatusNm"));
			String teamNM = StringUtil.checkNull(request.getParameter("teamNm"));
			String itemContent = StringUtil.checkNull(request.getParameter("itemContents"));
			String languageID = StringUtil.checkNull(request.getParameter("LANGUAGE_ID"),"1042");
			String itemTypeCD = StringUtil.checkNull(request.getParameter("itemTypeCd"));
			String childItems = StringUtil.checkNull(request.getParameter("childItems"));
			
			setData.put("searchValue",query);
			setData.put("LANGUAGE_ID",languageID);
			
			if("basic".equals(mode)) {
				setData.put("searchField",searchField);
			}
			else {

				setData.put("DETAILE",mode);
				setData.put("ITEM_CD",itemCD);
				setData.put("ITEM_NM",itemNM);
				setData.put("ITEM_TYPE_NM",itemTypeNM);
				setData.put("AUTHOR_NM",authorNM);
				setData.put("AUTHOR_EMP_NO",authorEmpNo);
				setData.put("ITEM_STATUS_NM",itemStatusNM);
				setData.put("TEAM_NM",teamNM);
				setData.put("ITEM_CONTENT",itemContent);
				
				setData.put("itemTypeCD",itemTypeCD);
			}
			setData.put("sort", sort);
			setData.put("listCount", listCount);
			setData.put("childItems", childItems);
			
			List itemList = commonService.selectList("search_SQL.getSearchForItemView", setData);
			List itemList2 = new ArrayList();
			String itemIDs = "";
			if(itemList != null && !itemList.isEmpty()) {
				
				for(int i=0; i < itemList.size(); i++) {
					Map temp = (Map)itemList.get(i);
					
					String itemContents = removeAllTag(StringUtil.checkNull(temp.get("ITEM_CONTENTS")));
					/*
					 * int queryIndex = itemContents.indexOf(query); int lastIndex =
					 * itemContents.length() > 300 ? 100 : itemContents.length() - queryIndex; int
					 * startIndex = queryIndex > 20 ? queryIndex - 20 : 0; itemContents =
					 * itemContents.substring(startIndex,(itemContents.length() <
					 * queryIndex+lastIndex ? itemContents.length() : queryIndex+lastIndex));
					 */
					temp.remove("ITEM_CONTENTS");
					temp.put("ITEM_CONTENTS",itemContents);
					itemList2.add(temp);
					
					String itemID = StringUtil.checkNull(temp.get("ITEM_ID"));
					if(i == 0) {
						itemIDs = itemID;
					}else { itemIDs += ","+ itemID; }
				}
				itemMap.put("CollListCount",itemList.size());
				fileMap.put("CollTotCount",itemList.size());
				itemMap.put("Document",itemList2);
				itemMap.put("CollectionName","OLM_ITEM");
			}
			else {
				itemMap.put("CollListCount","0");
				fileMap.put("CollTotCount","0");
				itemMap.put("Document","");
				itemMap.put("CollectionName","OLM_ITEM");				
			}
			
			totalList.add(itemMap);
			
			setData.put("itemIDs", itemIDs);
			List fileList = commonService.selectList("search_SQL.getSearchForFileView", setData);

			if(fileList != null && !fileList.isEmpty()) {
				fileMap.put("CollListCount",fileList.size());
				fileMap.put("CollTotCount",fileList.size());
				fileMap.put("Document",fileList);
				fileMap.put("CollectionName","OLM_FILE");
			}
			else {
				fileMap.put("CollListCount","0");
				fileMap.put("CollTotCount","0");
				fileMap.put("Document","");
				fileMap.put("CollectionName","OLM_FILE");				
			}
			
			totalList.add(fileMap);
			
			JSONArray jObj = new JSONArray(totalList);

			response.setCharacterEncoding("UTF-8");
			// JSON Hijacking 방지용 접두어 추가 (while(1);)
			// JSON 앞에 while(1); 또는 주석 (/* */) 을 붙여서 스크립트로 실행되지 않게 만듭니다.
			//이 방법은 Google, Facebook 등도 사용하는 방식입니다.
			
			response.getWriter().print("while(1);");
			response.getWriter().print(jObj);
	   } catch(Exception e) {
       	throw new ExceptionUtil(e.toString());
       }

    }	
	
	@RequestMapping(value="/getSearchListFileItemData.do")
	public void getSearchListFileItemData(HttpServletRequest request, HashMap commandMap, HttpServletResponse res) throws Exception{
		try{
			String itemIDs = StringUtil.checkNull(commandMap.get("itemIDs"));
			String searchQuery = StringUtil.checkNull(commandMap.get("searchQuery"),"");
			String itemTypeCode = StringUtil.checkNull(commandMap.get("ItemTypeCode"));
					
			String AuthorName = StringUtil.checkNull(commandMap.get("AuthorName"),"");
			String OwnerTeamName = StringUtil.checkNull(commandMap.get("OwnerTeamName"),"");
			String StartDate = StringUtil.checkNull(commandMap.get("StartDate"),"");
			String EndDate = StringUtil.checkNull(commandMap.get("EndDate"),"");
			String StatusCode = StringUtil.checkNull(commandMap.get("StatusCode"),"");
			
	    	String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"),GlobalVal.DEFAULT_LANGUAGE);
			//List itemArrayList = (List) commandMap.get("AttrCode");
			String itemArrayList = StringUtil.checkNull(commandMap.get("itemArrayList"));
			String fileArrayList = StringUtil.checkNull(commandMap.get("fileArrayList"));
			String[] itemArrayTemp = null;
			String[] fileArrayTemp = null;
			
			commandMap.put("languageID", languageID);
			SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Map logMap = new HashMap();
			
			logMap.put("searchText",searchQuery);
			logMap.put("memberID",StringUtil.checkNull(commandMap.get("sessionUserId")));
			logMap.put("teamID",StringUtil.checkNull(commandMap.get("sessionTeamId")));
			
			commonService.insert("search_SQL.insertSearchLog", logMap);
			
			if(itemArrayList.indexOf("@OLM_ARRAY_END@,@OLM_ARRAY_START@") > -1) {
				itemArrayTemp = itemArrayList.split("@OLM_ARRAY_END@,@OLM_ARRAY_START@");
			}
			else if(itemArrayList.indexOf("@OLM_ARRAY_END@") > -1) {
				itemArrayTemp = new String[1];
				itemArrayTemp[0] = itemArrayList;
			}
			else {
				itemArrayTemp = new String[0];
			}
			
			if(fileArrayList.indexOf("@OLM_FILE_ARRAY_END@,@OLM_FILE_ARRAY_START@") > -1) {
				fileArrayTemp = fileArrayList.split("@OLM_FILE_ARRAY_END@,@OLM_FILE_ARRAY_START@");
			}
			else if(fileArrayList.indexOf("@OLM_FILE_ARRAY_END@") > -1) {
				fileArrayTemp = new String[1];
				fileArrayTemp[0] = fileArrayList;
			}
			else {
				fileArrayTemp = new String[0];
			}

			if(fileArrayList.indexOf("@OLM_FILE_ARRAY_END@,@OLM_FILE_ARRAY_START@") > -1) {
				fileArrayTemp = fileArrayList.split("@OLM_FILE_ARRAY_END@,@OLM_FILE_ARRAY_START@");
			}
			else if(fileArrayList.indexOf("@OLM_FILE_ARRAY_END@") > -1) {
				fileArrayTemp = new String[1];
				fileArrayTemp[0] = fileArrayList;
			}
			else {
				fileArrayTemp = new String[0];
			}
			
			String searchQuery2 = StringUtil.checkNull(commandMap.get("searchQuery"),"").replace(" ","");
			
			if(searchQuery.equals(searchQuery2)) {
				searchQuery2 = "";
			}
			
			Map setMap = new HashMap();
			List searchList = new ArrayList();
			Map attrTypeMap = new HashMap();
			String afterItemID = "";
			int j=1;
			String itemIDs2 = "";

			Map fileMap = new HashMap();

			for(int i=0; i<fileArrayTemp.length; i++) {
				String[] temp = fileArrayTemp[i].replace("@OLM_FILE_ARRAY_END@", "").split("@OLM@");

				fileMap.put(temp[0], temp[1]);
			
			}

			for(int i=0; i<itemArrayTemp.length; i++) {
				String[] temp = itemArrayTemp[i].replace("@OLM_ARRAY_END@", "").split("@OLM@");
				
				if(!"".equals(StartDate) && !"".equals(EndDate)) {

					Date StartDT = transFormat.parse(StartDate);	
					Date EndDT = transFormat.parse(EndDate);		
					Date searchDT = transFormat.parse(temp[10]);
					
					if(!StartDT.after(searchDT) || !EndDT.before(searchDT)) {
						continue;
					}
					
				}
				Map tempMap = new HashMap();
				
				String itemID = StringUtil.checkNull(temp[0]);
				setMap.put("typeCode",temp[6]);
				setMap.put("languageID",languageID);
				setMap.put("category","AT");
				String attrName = StringUtil.checkNull(commonService.selectString("common_SQL.getNameFromDic",setMap));
				
				String itemContents = StringUtil.checkNull(temp[7]);
				String itemContentsOrg = StringUtil.checkNull(temp[7]);
				int queryIndex = itemContents.indexOf(searchQuery); 
				int lastIndex =	itemContents.length() > 300 ? 100 : itemContents.length() - queryIndex; 
				int	startIndex = queryIndex > 20 ? queryIndex - 20 : 0; 
				
				itemContents = itemContents.substring(startIndex,(itemContents.length() < queryIndex+lastIndex ? itemContents.length() : queryIndex+lastIndex));
				temp[7] = itemContents;
				
				if(i == 0 || "".equals(itemIDs2)) {
					itemIDs2 =  itemID;
				}
				else  {
					itemIDs2 = itemIDs2 + "," + itemID;
				}

				if(!"".equals(searchQuery2)) {
					temp[2] = temp[2].replaceAll("(?i)"+searchQuery2, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery2+"\"</span>");
					temp[7] = temp[7].replaceAll("(?i)"+searchQuery2, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery2+"\"</span>");
				}
				
				if(!"".equals(searchQuery)) {
					temp[2] = temp[2].replaceAll("(?i)"+searchQuery, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery+"\"</span>");
					temp[7] = temp[7].replaceAll("(?i)"+searchQuery, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery+"\"</span>");
				}
							
				if(!afterItemID.equals(itemID) && ( StringUtil.checkNull(temp[2].toLowerCase()).contains(searchQuery.toLowerCase()) || itemContentsOrg.toLowerCase().contains(searchQuery.toLowerCase()) ) ) {
				
					tempMap.put("ItemID",temp[0]);			
					tempMap.put("Identifier",temp[1]);		
					tempMap.put("ItemName",temp[2].replaceAll("\"\"","\""));			
					tempMap.put("Path",temp[3]);				
					tempMap.put("ItemTypeCode",temp[4]);		
					tempMap.put("StatusName",temp[5]);	
					
					if(!"AT00001".equals(temp[6])) {
						tempMap.put(temp[6],"[" + attrName + "]&nbsp;&nbsp;&nbsp;&nbsp;"+temp[7].replaceAll("\"\"","\""));
					}
					
					tempMap.put("Name",temp[8]);			
					tempMap.put("TeamName",temp[9]);	
					tempMap.put("authorTeamNM",temp[9]);
					tempMap.put("LastUpdated",temp[10]);
					tempMap.put("ItemTypeImg",temp[11]);
					tempMap.put("FileIcon",temp[12]);
					tempMap.put("ClassCode",temp[13]);
					
					setMap.put("itemID", itemID);
					tempMap.put("ClassVarFilter", StringUtil.checkNull(commonService.selectString("menu_SQL.getItemClassMenuVarFilter", setMap)));
						
					afterItemID = StringUtil.checkNull(temp[0]);

					commandMap.put("DocumentID", StringUtil.checkNull(temp[0]));
					List documentList = new ArrayList();
					List documentList2 = commonService.selectList("fileMgt_SQL.getFile_gridList", commandMap);
					
					if(documentList2 != null && !documentList2.isEmpty()) {

						if(documentList2.size() > 20) {
							
							for(int k=0; k < documentList2.size(); k++) {
								Map tempMap2 = (Map) documentList2.get(k);
								String seq = StringUtil.checkNull(tempMap2.get("Seq"));
								String fileRealName = StringUtil.checkNull(tempMap2.get("FileRealName"));
								String fileName = StringUtil.checkNull(tempMap2.get("FileName"));
								
								if(fileMap.containsKey(seq)) {
									String fileDesc = StringUtil.checkNull(fileMap.get(seq),"");
									
									if(!"||".equals(fileDesc)) {
										if(!"".equals(searchQuery2)) {
											fileDesc = fileDesc.replaceAll("(?i)"+searchQuery2, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery2+"\"</span>");
										}
										
										if(!"".equals(searchQuery)) {
											fileDesc = fileDesc.replaceAll("(?i)"+searchQuery, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery+"\"</span>");
										}
	
										if("".equals(fileRealName)) {
											tempMap2.put("FileRealName", fileName);
										}
										tempMap2.put("fileDescription", "->" + fileDesc);
										}
									else {
										tempMap2.put("fileDescription", "->");
									}
									documentList.add(tempMap2);
								}
							}

						}
						else {
							for(int k=0; k < documentList2.size(); k++) {
								Map tempMap2 = (Map) documentList2.get(k);
								String seq = StringUtil.checkNull(tempMap2.get("Seq"));
								String fileRealName = StringUtil.checkNull(tempMap2.get("FileRealName"));
								String fileName = StringUtil.checkNull(tempMap2.get("FileName"));
								
								if(fileMap.containsKey(seq)) {
									String fileDesc = StringUtil.checkNull(fileMap.get(seq),"");
									if(!"||".equals(fileDesc)) {
										if(!"".equals(searchQuery2)) {
											fileDesc = fileDesc.replaceAll("(?i)"+searchQuery2, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery2+"\"</span>");
										}
										
										if(!"".equals(searchQuery)) {
											fileDesc = fileDesc.replaceAll("(?i)"+searchQuery, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery+"\"</span>");
										}
	
										if("".equals(fileRealName)) {
											tempMap2.put("FileRealName", fileName);
										}
										tempMap2.put("fileDescription", "->" + fileDesc);
									}
									else {
										tempMap2.put("fileDescription", "->");										
									}
								}
								documentList.add(tempMap2);
							}
						}
					}

					tempMap.put("documentList",documentList);		
					searchList.add(tempMap);
				}
				else if(afterItemID.equals(itemID)) {
					Map temp2 = (Map) searchList.get(i-j);
					
					if(!"AT00001".equals(temp[6]) && StringUtil.checkNull(temp[7]).contains(searchQuery)) {
						temp2.put(temp[6],"[" + attrName + "]&nbsp;&nbsp;&nbsp;&nbsp;"+temp[7].replaceAll("\"\"","\""));	
					}
									
					searchList.remove(i-j);
					searchList.add(temp2);
					j++;
				} 
				
				if(!attrTypeMap.containsKey(temp[6])) {
					attrTypeMap.put(temp[6],temp[6]);
				}
			}

			//model.put("attrTypeMap", attrTypeMap);	
			//model.put("attrTypeMapCnt", attrTypeMap.size());	
			//model.put("menu", getLabel(request, commonService));		
			//  AttrCode=[{attrCode=AT00001, selectOption=AND, AttrCodeEscape=, constraint=, searchValue=원부자재}]

			
			Map setMap2 = new HashMap();
			setMap2.put("childItems",itemIDs);
			setMap2.put("masterItemId", itemIDs2);
			setMap2.put("languageID",languageID);
			setMap2.put("ItemTypeCode",itemTypeCode);
			setMap2.put("OwnerTeam",OwnerTeamName);
			setMap2.put("Status",StatusCode);
			setMap2.put("Name",AuthorName);
			setMap2.put("LastUpdated","Y");
			setMap2.put("scStartDt2",StartDate);
			setMap2.put("scEndDt2",EndDate);
			List searchList2 = new ArrayList();
			if(!"".equals(itemIDs)) {
				searchList2 = commonService.selectList("search_SQL.getSearchMultiList_gridList", setMap2);
			}
			
			String itemList2 = "";
			if(searchList2.size()>0) {
				for(int i1=0; i1<searchList2.size(); i1++) {
					Map listMap = (Map)searchList2.get(i1);
					if(i1==0) {
						itemList2 = StringUtil.checkNull(listMap.get("ItemID"));
					}else {
						itemList2 += "," + StringUtil.checkNull(listMap.get("ItemID"));
					}
					
					commandMap.put("DocumentID", StringUtil.checkNull(listMap.get("ItemID")));
					List documentList = new ArrayList();
					List documentList2 = commonService.selectList("fileMgt_SQL.getFile_gridList", commandMap);

					if(documentList2 != null && !documentList2.isEmpty()) {

						if(documentList2.size() > 20) {
							for(int k=0; k < documentList2.size(); k++) {
								Map tempMap2 = (Map) documentList2.get(k);
								String seq = StringUtil.checkNull(tempMap2.get("Seq"));
								String fileRealName = StringUtil.checkNull(tempMap2.get("FileRealName"));
								String fileName = StringUtil.checkNull(tempMap2.get("FileName"));
								
								if(fileMap.containsKey(seq)) {
									String fileDesc = StringUtil.checkNull(fileMap.get(seq),"");
									if(!"||".equals(fileDesc)) {
										if(!"".equals(searchQuery2)) {
											fileDesc = fileDesc.replaceAll(searchQuery2, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery2+"\"</span>");
										}
										
										if(!"".equals(searchQuery)) {
											fileDesc = fileDesc.replaceAll(searchQuery, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery+"\"</span>");
										}
										
										tempMap2.put("fileDescription", "->" + fileDesc);
									}
									else {
										tempMap2.put("fileDescription", "->");
									}
									if("".equals(fileRealName)) {
										tempMap2.put("FileRealName", fileName);
									}
									documentList.add(tempMap2);
								}
							}

						}
						else {
							for(int k=0; k < documentList2.size(); k++) {
								Map tempMap2 = (Map) documentList2.get(k);
								String seq = StringUtil.checkNull(tempMap2.get("Seq"));
								String fileRealName = StringUtil.checkNull(tempMap2.get("FileRealName"));
								String fileName = StringUtil.checkNull(tempMap2.get("FileName"));
								
								if(fileMap.containsKey(seq)) {
									String fileDesc = StringUtil.checkNull(fileMap.get(seq),"");

									if(!"||".equals(fileDesc)) {
										if(!"".equals(searchQuery2)) {
											fileDesc = fileDesc.replaceAll(searchQuery2, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery2+"\"</span>");
										}
										
										if(!"".equals(searchQuery)) {
											fileDesc = fileDesc.replaceAll(searchQuery, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery+"\"</span>");
										}
										tempMap2.put("fileDescription", "->" + fileDesc);
									}
									else {
										tempMap2.put("fileDescription", "->");										
									}

									if("".equals(fileRealName)) {
										tempMap2.put("FileRealName", fileName);
									}
								}
								documentList.add(tempMap2);
							}
						}
					}
					listMap.put("documentList",documentList);

					String description = "";
					if (null != listMap.get("ProcessInfo")) {
						description = removeAllTag(StringUtil.checkNull(listMap.get("ProcessInfo")));
						if(description.length()>99) {
							description = description.substring(100) + "...";
						}
					}
					String ItemName = StringUtil.checkNull(listMap.get("ItemName"));
					//String ItemName = "";
					if(!"".equals(searchQuery2)) {
						ItemName = ItemName.replaceAll(searchQuery2, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery2+"\"</span>");
						description = description.replaceAll(searchQuery2, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery2+"\"</span>");
					}

					if(!"".equals(searchQuery)) {
						ItemName = ItemName.replace(searchQuery, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery+"\"</span>");
						description = description.replaceAll(searchQuery, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery+"\"</span>");
					}
	 				
					listMap.put("ItemName", ItemName.replaceAll("\"\"","\""));
					listMap.put("StringProcessInfo", description.replaceAll("\"\"","\""));
				}
			}

			if(searchList != null && !searchList.isEmpty() && searchList.size() > 0) {
				searchList.addAll(searchList.size(), searchList2);
			}
			else {
				searchList = searchList2;
			}
			
			String itemIDList = itemIDs2;
			
			if(!"".equals(itemList2)) {
				if(!"".equals(itemIDList)) {
					itemIDList = itemIDList + "," + itemList2;
				}else {
					itemIDList = itemList2;
				}
			}
			
			JSONArray searchListJSONList = new JSONArray(searchList);
			
			res.setHeader("Cache-Control", "no-cache");
			res.setContentType("text/plain");
			res.setCharacterEncoding("UTF-8");
			if(!StringUtil.checkNull(searchListJSONList).equals("")){
				res.getWriter().print(searchListJSONList);
			}
			else {
				PrintWriter pw = res.getWriter();
				pw.write("데이터가 존재하지 않습니다.");
			}			
			
		} catch(Exception e) {
			System.out.println(e.toString());
		}		
	}
	
	@RequestMapping(value="/searchValueXss.do")
	public void searchValueXss(HttpServletRequest request, HttpServletResponse response, HashMap commandMap, ModelMap model) throws Exception{
		 String searchValue = StringUtil.checkNull(request.getParameter("searchValue"));
		 searchValue = StringUtil.replaceFilterString(searchValue);
		 
			Map setMap = new HashMap();
			JSONObject obj = new JSONObject();
			JSONArray company = new JSONArray();

			Map map;
			PrintWriter out;
			
	        try {
	        	searchValue = URLEncoder.encode(searchValue, "UTF-8");
	        } catch (UnsupportedEncodingException e) {
	            throw new RuntimeException("검색어 인코딩 실패",e);
	        }
	        
			obj = new JSONObject();
			obj.put("value", searchValue);
			company.put(obj);
			
	        response.setContentType("text/html; charset=UTF-8");
			response.setHeader("Cache-control", "no-cache, no-store");
			response.setHeader("Pragma", "no-cache");
			response.setHeader("Expires", "-1");
			out = response.getWriter();
			
			out.println(company);
			out.close();
	}
}
