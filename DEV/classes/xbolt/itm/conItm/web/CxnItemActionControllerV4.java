package xbolt.itm.conItm.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.org.json.JSONArray;
import com.org.json.JSONException;
import com.org.json.JSONObject;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

@Controller
@SuppressWarnings("unchecked")


public class CxnItemActionControllerV4 extends XboltController{
	
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@RequestMapping(value = "/cxnItemTreeMgtV4.do")
	public String cxnItemTreeMgtV4(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		
		String url = StringUtil.checkNull(cmmMap.get("url"), "/itm/cxnItem/cxnItemTreeMgtV4");			
		
		try {
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");		
			String childCXN = StringUtil.checkNull(request.getParameter("childCXN"), "");
			String screenMode = StringUtil.checkNull(request.getParameter("screenMode"), "");
			String varFilter = StringUtil.checkNull(request.getParameter("varFilter"), "");
			String cxnTypeList = StringUtil.checkNull(request.getParameter("cxnTypeList"), "");
			String notInCxnClsList = StringUtil.checkNull(request.getParameter("notInCxnClsList"), "");

			// 권한 체크
			String myItem = commonService.selectString("item_SQL.checkMyItem", cmmMap);
			model.put("myItem", myItem);
			
			model.put("s_itemID", s_itemID);
			model.put("screenMode", screenMode);
			model.put("varFilter", varFilter);
			model.put("childCXN", childCXN);
			model.put("cxnTypeList", cxnTypeList);
			model.put("notInCxnClsList", notInCxnClsList);
			
			model.put("menu", getLabel(request, commonService));
			model.put("option", request.getParameter("option"));
			model.put("filter", request.getParameter("varFilter"));

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	// connectedProcessList 조회
	@RequestMapping(value = "getConnectedProcessList.do", method = RequestMethod.GET)
	@ResponseBody
	public void getConnectedProcessList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("application/json; charset=UTF-8");
		JSONObject resultMap = new JSONObject();
		Map setMap = new HashMap();
		
		List prcList = new ArrayList();
		boolean success = false;
		
		try {
	        
			// parameter
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");		
			String childCXN = StringUtil.checkNull(request.getParameter("childCXN"), "");
			String languageID = StringUtil.checkNull(request.getParameter("languageID"), "");
			// option
			String accMode = StringUtil.checkNull(request.getParameter("accMode"), "");
			String delItemsYN = StringUtil.checkNull(request.getParameter("delItemsYN"), "");
			String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"), "");
			String releaseNo = StringUtil.checkNull(request.getParameter("releaseNo"), "");
			String statusList = StringUtil.checkNull(request.getParameter("statusList"), "");
			String TreeDataFiltered = StringUtil.checkNull(request.getParameter("TreeDataFiltered"), "");
			String sessionParamSubItems = StringUtil.checkNull(request.getParameter("sessionParamSubItems"), "");
			
			
			// parameter check
			if (s_itemID.isEmpty()) {
	             throw new IllegalArgumentException("s_itemID is required.");
	        }
			
			setMap.put("languageID",languageID);
			setMap.put("s_itemID",s_itemID);
			setMap.put("accMode",accMode);
			
			if(childCXN.equals("Y")){
				// option
				setMap.put("delItemsYN",delItemsYN);
				setMap.put("changeSetID",changeSetID);
				setMap.put("releaseNo",releaseNo);
				setMap.put("statusList",statusList);
				setMap.put("TreeDataFiltered",TreeDataFiltered);
				setMap.put("sessionParamSubItems",sessionParamSubItems);
				prcList = (List)commonService.selectList("item_SQL.getChildItemList_gridList", setMap);
			}else{
				prcList = (List) commonService.selectList("item_SQL.getConnectedProcess_gridList", setMap);
			}
			
			success = true;
			resultMap.put("data", prcList);
			
	        
        } catch (IllegalArgumentException e) {
        	// 400 Bad Request
        	response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (DataAccessException e) {
        	// 500 Internal Server Error
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (JSONException e) {
        	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (Exception e) {
        	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } finally {
        	
        	resultMap.put("success", success);
        	try {
        		// send to json
        		response.getWriter().print(resultMap);
        	} catch (Exception e) {
        		System.err.println(e.getMessage());
        	}
        	
        }
	}
	
	@RequestMapping(value = "getCxnItemList.do", method = RequestMethod.GET)
	@ResponseBody
	public void getCxnItemList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("application/json; charset=UTF-8");
		JSONObject resultMap = new JSONObject();
		Map setMap = new HashMap();
		
		List cxnItemList = new ArrayList();
		boolean success = false;
		
		try {
	        
			// parameter
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");		
			String languageID = StringUtil.checkNull(request.getParameter("languageID"), "");
			String ClassCode = StringUtil.checkNull(request.getParameter("ClassCode"), "");
			String CompanyCode = StringUtil.checkNull(request.getParameter("CompanyCode"), "");
			String objFilter = StringUtil.checkNull(request.getParameter("objFilter"), "");
			String clsFilter = StringUtil.checkNull(request.getParameter("clsFilter"), "");
			String showTOJ = StringUtil.checkNull(request.getParameter("showTOJ"), "");
			
			// parameter check
			if (s_itemID.isEmpty()) {
	             throw new IllegalArgumentException("s_itemID is required.");
	        }
			
			// 요청 타입
			String reqCxnTypeList[] = StringUtil.checkNull(request.getParameter("cxnTypeList"), "").split(",");	
			String cxnTypeList = "";
			if (!StringUtil.checkNull(request.getParameter("cxnTypeList"), "").equals("")) {
				for (int i = 0; i < reqCxnTypeList.length; i++) {
					if(i==0) {
						cxnTypeList = "'"+reqCxnTypeList[i]+"'";
					}else {
						cxnTypeList += ",'"+ reqCxnTypeList[i]+"'";
					}
				}
				setMap.put("cxnTypeList", cxnTypeList);
			}
			
			// 요청 not 타입
			String reqnotInCxnClsList[] = StringUtil.checkNull(request.getParameter("notInCxnClsList"), "").split(",");	
			String notInCxnClsList = "";
			if (!StringUtil.checkNull(request.getParameter("notInCxnClsList"), "").equals("")) {
				for (int i = 0; i < reqnotInCxnClsList.length; i++) {
					if(i==0) {
						notInCxnClsList = "'"+reqnotInCxnClsList[i]+"'";
					}else {
						notInCxnClsList += ",'"+ reqnotInCxnClsList[i]+"'";
					}
				}
				setMap.put("notInCxnClsList", notInCxnClsList);
			}
			
			setMap.put("languageID",languageID);
			setMap.put("s_itemID",s_itemID);
			// option
			setMap.put("ClassCode",ClassCode);
			setMap.put("CompanyCode",CompanyCode);
			setMap.put("objFilter",objFilter);
			setMap.put("clsFilter",clsFilter);
			setMap.put("showTOJ",showTOJ);
			
			cxnItemList = (List) commonService.selectList("item_SQL.getNewCxnItemList_gridList", setMap);
			
			success = true;
			resultMap.put("data", cxnItemList);
			
	        
        } catch (IllegalArgumentException e) {
        	// 400 Bad Request
        	response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (DataAccessException e) {
        	// 500 Internal Server Error
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (JSONException e) {
        	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (Exception e) {
        	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } finally {
        	
        	resultMap.put("success", success);
        	try {
        		// send to json
        		response.getWriter().print(resultMap);
        	} catch (Exception e) {
        		System.err.println(e.getMessage());
        	}
        	
        }
	}
	
	@RequestMapping(value = "getLinkListFromAttAlloc.do", method = RequestMethod.GET)
	@ResponseBody
	public void getLinkListFromAttAlloc(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("application/json; charset=UTF-8");
		JSONObject resultMap = new JSONObject();
		Map setMap = new HashMap();
		Map linkMap = new HashMap();
		List linkList = new ArrayList();
		boolean success = false;
		
		try {
	        
			// parameter
			String itemID = StringUtil.checkNull(request.getParameter("itemID"), "");		
			String languageID = StringUtil.checkNull(request.getParameter("languageID"), "");
			String itemClassCode = StringUtil.checkNull(request.getParameter("itemClassCode"), "");
			
			// parameter check
			if (itemID.isEmpty()) {
	             throw new IllegalArgumentException("itemID is required.");
	        }
			
			
			setMap.put("itemID",itemID);
			setMap.put("languageID",languageID);
			setMap.put("itemClassCode",itemClassCode);
			
			linkList = commonService.selectList("link_SQL.getLinkListFromAttAlloc", setMap);
			
			String linkImg = "blank.png";
			String linkUrl = "";
			String lovCode = "";
			String attrTypeCode = "";
			
			if(linkList.size() > 0){
				
				Map linkInfo = (Map)linkList.get(0);
				linkUrl = StringUtil.checkNull(linkInfo.get("URL"),"");
				lovCode = StringUtil.checkNull(linkInfo.get("LovCode"),"");
				attrTypeCode = StringUtil.checkNull(linkInfo.get("AttrTypeCode"),"");
				
				if(!linkUrl.equals("")){ linkImg = "icon_link.png"; }
				linkMap.put("linkImg", linkImg);
				linkMap.put("linkUrl", linkUrl);
				linkMap.put("lovCode", lovCode);
				linkMap.put("attrTypeCode", attrTypeCode);
				
			}else {
				linkMap.put("linkImg", linkImg);
			}
			
			success = true;
			resultMap.put("data", linkMap);
			
	        
        } catch (IllegalArgumentException e) {
        	// 400 Bad Request
        	response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (DataAccessException e) {
        	// 500 Internal Server Error
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (JSONException e) {
        	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (Exception e) {
        	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } finally {
        	
        	resultMap.put("success", success);
        	try {
        		// send to json
        		response.getWriter().print(resultMap);
        	} catch (Exception e) {
        		System.err.println(e.getMessage());
        	}
        	
        }
	}
	
	@RequestMapping(value = "getCxnItemFileList.do", method = RequestMethod.GET)
	@ResponseBody
	public void getCxnItemFileList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("application/json; charset=UTF-8");
		JSONObject resultMap = new JSONObject();
		Map setMap = new HashMap();
		
		List cifList = new ArrayList();
		boolean success = false;
		
		try {
	        // parameter
			String itemIDs = StringUtil.checkNull(request.getParameter("ItemIDs"),"");
			String languageID = StringUtil.checkNull(request.getParameter("languageID"), "");
			
			// option
			String selectedLanguageID = StringUtil.checkNull(request.getParameter("selectedLanguageID"), "");
			String fltpCode = StringUtil.checkNull(request.getParameter("fltpCode"), "");
			String startLastUpdated = StringUtil.checkNull(request.getParameter("startLastUpdated"), "");
			String endLastUpdated = StringUtil.checkNull(request.getParameter("endLastUpdated"), "");
			String itemName = StringUtil.checkNull(request.getParameter("itemName"), "");
			String fileName = StringUtil.checkNull(request.getParameter("fileName"), "");
			String regUserName = StringUtil.checkNull(request.getParameter("regUserName"), "");
			String filtered = StringUtil.checkNull(request.getParameter("filtered"), "Y");
			
			
			// parameter check
			if (itemIDs.isEmpty() && itemIDs.isEmpty()) {
	             throw new IllegalArgumentException("itemID is required.");
	        }
			
			setMap.put("languageID", languageID);
			setMap.put("itemIDs", itemIDs.replace("[","").replace("]",""));
			
			// option
			setMap.put("selectedLanguageID", selectedLanguageID);
			setMap.put("fltpCode", fltpCode);
			setMap.put("startLastUpdated", startLastUpdated);
			setMap.put("endLastUpdated", endLastUpdated);
			setMap.put("itemName", itemName);
			setMap.put("fileName", fileName);
			setMap.put("regUserName", regUserName);
			setMap.put("filtered", filtered);
			
			cifList = commonService.selectList("fileMgt_SQL.getCxnItemFileList_gridList",setMap);
			
			success = true;
			resultMap.put("data", cifList);
			
	        
        } catch (IllegalArgumentException e) {
        	// 400 Bad Request
        	response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (DataAccessException e) {
        	// 500 Internal Server Error
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (JSONException e) {
        	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (Exception e) {
        	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } finally {
        	
        	resultMap.put("success", success);
        	try {
        		// send to json
        		response.getWriter().print(resultMap);
        	} catch (Exception e) {
        		System.err.println(e.getMessage());
        	}
        	
        }
	}
	
	//중복제거 메소드, key는 제거할 맵 대상
    public static List<HashMap<Object, Object>> distinctArray(List<HashMap<Object, Object>> target, Object key){ 
        if(target != null){
            target = target.stream().filter(distinctByKey(o-> o.get(key))).collect(Collectors.toList());
        }
        return target;
    }
    
    //중복 제거를 위한 함수
    public static <T> Predicate<T> distinctByKey(Function<? super T,Object> keyExtractor) {
        Map<Object,Boolean> seen = new ConcurrentHashMap<>();
        return t -> seen.putIfAbsent(keyExtractor.apply(t), Boolean.TRUE) == null;
	    
	}
 	
 	// rltdItemId 조회
 	@RequestMapping(value = "getRltdItemId.do", method = RequestMethod.GET)
 	@ResponseBody
 	public void getRltdItemId(HttpServletRequest request, HttpServletResponse response) throws Exception {
 		
 		response.setCharacterEncoding("UTF-8");
 		response.setContentType("application/json; charset=UTF-8");
 		JSONObject resultMap = new JSONObject();
 		Map setMap = new HashMap();
 		
 		String rltdItemId = "";
 		boolean success = false;
 		
 		try {
 	        
 			// parameter
 			String DocumentID = StringUtil.checkNull(request.getParameter("DocumentID"), "");
 			String LanguageID = StringUtil.checkNull(request.getParameter("languageID"), "");
 			
 			// parameter check
 			if (DocumentID.isEmpty()) {
 	             throw new IllegalArgumentException("DocumentID is required.");
 	        }
 			
 			// search cxnItemIDList
 			setMap.put("s_itemID", DocumentID);
 			setMap.put("LanguageID", LanguageID);
 			setMap.put("fromToItemID", DocumentID);
 			List cxnItemIDList = commonService.selectList("item_SQL.getCxnItemIDList", setMap);
 			
 			/** 첨부문서 관련문서 합치기, 관련문서 itemClassCodep 할당된 fltpCode 로 filtering */
 			Map getMap = new HashMap();
 			for(int i = 0; i < cxnItemIDList.size(); i++){
 				getMap = (HashMap)cxnItemIDList.get(i);
 				getMap.put("ItemID", getMap.get("ItemID"));
 				if (i < cxnItemIDList.size() - 1) {
 				   rltdItemId += StringUtil.checkNull(getMap.get("ItemID")) + ",";
 				}else{
 					rltdItemId += StringUtil.checkNull(getMap.get("ItemID")) ;
 				}
 			}
 			
 			success = true;
 			resultMap.put("data", rltdItemId);
 			
 	        
         } catch (IllegalArgumentException e) {
         	// 400 Bad Request
         	response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
 			resultMap.put("message", e.getMessage());
             System.err.println(e);
         } catch (DataAccessException e) {
         	// 500 Internal Server Error
             response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
 			resultMap.put("message", e.getMessage());
             System.err.println(e);
         } catch (JSONException e) {
         	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
 			resultMap.put("message", e.getMessage());
             System.err.println(e);
         } catch (Exception e) {
         	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
 			resultMap.put("message", e.getMessage());
             System.err.println(e);
         } finally {
         	
         	resultMap.put("success", success);
         	try {
         		// send to json
         		response.getWriter().print(resultMap);
         	} catch (Exception e) {
         		System.err.println(e.getMessage());
         	}
         	
         }
 	}
 	
 	// 연관항목 리스트 - 하위에 속성 출력
	@RequestMapping(value = "/cxnItemListMgtV4.do")
	public String cxnItemListMgtV4(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/itm/cxnItem/cxnItemListMgtV4";
					
		try {
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");		
			String childCXN = StringUtil.checkNull(request.getParameter("childCXN"), "");
			String screenMode = StringUtil.checkNull(request.getParameter("screenMode"), "");
			String varFilter = StringUtil.checkNull(request.getParameter("varFilter"), "");
			String cxnTypeList = StringUtil.checkNull(request.getParameter("cxnTypeList"), "");
			String notInCxnClsList = StringUtil.checkNull(request.getParameter("notInCxnClsList"), "");
			String ClassCode = StringUtil.checkNull(request.getParameter("ClassCode"), "");
			
			model.put("s_itemID", s_itemID);
			model.put("screenMode", screenMode);
			model.put("varFilter", varFilter);
			model.put("childCXN", childCXN);
			model.put("cxnTypeList", cxnTypeList);
			model.put("notInCxnClsList", notInCxnClsList);
			model.put("ClassCode", ClassCode);
			
			model.put("menu", getLabel(request, commonService));
			model.put("option", request.getParameter("option"));
			model.put("filter", request.getParameter("varFilter"));

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	} 	

}


