package xbolt.custom.ssg.emart;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.text.StringEscapeUtils;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import com.org.json.JSONException;
import com.org.json.JSONObject;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonService;

/**
 * 업무 처리
 * @Class Name : BizController.java
 * @Description : 업무화면을 제공한다.
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2012. 09. 01. smartfactory		최초생성
 *
 * @since 2012. 09. 01.
 * @version 1.0
 */

@Controller
@SuppressWarnings("unchecked")

public class EMARTApiActionController  extends XboltController{
	
	@Resource(name = "commonService")
	private CommonService commonService;
	@Resource(name = "fileMgtService")
	private CommonService fileMgtService;
	
	
	// 첨부파일 리스트
	@RequestMapping(value = "/zEMT_getAttachFileList.do", method = RequestMethod.GET)
	@ResponseBody
	public void zEMT_getAttachFileList(HttpServletRequest request, HttpServletResponse response) throws Exception {

	    response.setCharacterEncoding("UTF-8");
	    response.setContentType("application/json; charset=UTF-8");

	    JSONObject resultMap = new JSONObject();
	    Map setMap = new HashMap();

	    boolean success = false;

	    try {

	        // parameter
	        String documentID   = StringUtil.checkNull(request.getParameter("DocumentID"), "");
	        String languageID   = StringUtil.checkNull(request.getParameter("languageID"), "");
	        String hideBlocked  = StringUtil.checkNull(request.getParameter("hideBlocked"), "");
	        String isPublick    = StringUtil.checkNull(request.getParameter("isPublick"), "");
	        String docCategory  = StringUtil.checkNull(request.getParameter("DocCategory"), "");

	        // parameter check
	        if (documentID.isEmpty()) {
	            throw new IllegalArgumentException("DocumentID is required.");
	        }

	        // parameter put
	        setMap.put("DocumentID", documentID);
	        setMap.put("languageID", languageID);
	        setMap.put("isPublic", isPublick);      // ✅ 기존 SQL 파라미터명이 isPublic 이면 이대로
	        setMap.put("DocCategory", docCategory);
	        setMap.put("hideBlocked", hideBlocked);

	        // select
	        List attachFileList = commonService.selectList("fileMgt_SQL.getFile_gridList", setMap);

	        resultMap.put("data", attachFileList);
	        success = true;

	    } catch (IllegalArgumentException e) {
	        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
	        resultMap.put("message", e.getMessage());
	        System.err.println(e);
	    } catch (DataAccessException e) {
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


	// 첨부파일 리스트
	@RequestMapping(value = "/zEMT_getSubItemList.do", method = RequestMethod.GET)
	@ResponseBody
	public void zEMT_getSubItemList(HttpServletRequest request, HttpServletResponse response) throws Exception {

	    response.setCharacterEncoding("UTF-8");
	    response.setContentType("application/json; charset=UTF-8");

	    JSONObject resultMap = new JSONObject();
	    Map setMap = new HashMap();

	    boolean success = false;

	    try {

	        // parameter
	        String s_itemID   = StringUtil.checkNull(request.getParameter("s_itemID"), "");
	        String languageID = StringUtil.checkNull(request.getParameter("languageID"),"");
	        
	      
	        // parameter put
	        setMap.put("gubun", "M");
	        setMap.put("s_itemID", s_itemID);
	        setMap.put("languageID", languageID);

	        // select
	      
			List childItemList = commonService.selectList("item_SQL.getSubItemList_gridList", setMap);
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
			
			childItemList = getChildItemInfo(childItemList, defaultLang, languageID);
	        // parameter check
	        if (s_itemID.isEmpty()) {
	            throw new IllegalArgumentException("s_itemID is required.");
	        }


	        resultMap.put("data", childItemList);
	        success = true;

	    } catch (IllegalArgumentException e) {
	        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
	        resultMap.put("message", e.getMessage());
	        System.err.println(e);
	    } catch (DataAccessException e) {
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
	
	
	private List getChildItemInfo(List List, String defaultLang, String sessionCurrLangType) throws Exception {
		List resultList = new ArrayList();


	    
	    // 1. ItemID  수집
	    List itemIdList = new ArrayList();
	    for (int i = 0; i < List.size(); i++) {
	        Map listMap = (Map) List.get(i);
	        itemIdList.add(String.valueOf(listMap.get("ItemID")));
	    }
	    // 2. 공통 파라미터 세팅 
	    
	    Map setMap = new HashMap();
	    setMap.put("ItemIDList", itemIdList);
		setMap.put("DefaultLang", defaultLang);
		setMap.put("sessionCurrLangType", sessionCurrLangType);
		setMap.put("delItemsYN", "N");
		
		//3. attr/ conList 한번에 조회 
		List attrList = commonService.selectList("custom_SQL.zEMT_getItemAttributesInfo", setMap);
		
		List conList = commonService.selectList("custom_SQL.zEMT_getItemConList", setMap);

        // 4. ItemID 기준으로 grouping
	    // ===============================
	    Map attrGroupMap = new HashMap();   // key: ItemID, value: List
	    for (int i = 0; i < attrList.size(); i++) {
	        Map map = (Map) attrList.get(i);
	        String itemId = String.valueOf(map.get("ItemID"));

	        List list = (List) attrGroupMap.get(itemId);
	        if (list == null) {
	            list = new ArrayList();
	            attrGroupMap.put(itemId, list);
	        }
	        list.add(map);
	    }
	    
	    //  // key: ItemID, value: List
	    Map conGroupMap = new HashMap();    // key: ItemID, value: List
	    for (int i = 0; i < conList.size(); i++) {
	        Map map = (Map) conList.get(i);
	        String itemId = String.valueOf(map.get("BaseItemID"));

	        List list = (List) conGroupMap.get(itemId);
	        if (list == null) {
	            list = new ArrayList();
	            conGroupMap.put(itemId, list);
	        }
	        list.add(map);
	    }

	    
	    // 5. 기존 List에 데이터 다시 세팅
	    
	    for (int i = 0; i < List.size(); i++) {

	        Map listMap = (Map) List.get(i);
	        String itemId = String.valueOf(listMap.get("ItemID"));

	        // ---- attr 세팅 (기존 로직 그대로)
	        List itemAttrList = (List) attrGroupMap.get(itemId);
	        if (itemAttrList != null) {
	            for (int k = 0; k < itemAttrList.size(); k++) {
	                Map map = (Map) itemAttrList.get(k);

	                String value = StringUtil.checkNullToBlank(map.get("PlainText"));
	                if (!"".equals(value)) {
	                    value = StringEscapeUtils.unescapeHtml4(value);
	                }

	                listMap.put(map.get("AttrTypeCode"), value);
	            }
	        }

	        // ---- conList 세팅 (기존 키 그대로)
	        List itemConList = (List)conGroupMap.get(itemId);
	        listMap.put("conList", itemConList == null ? new ArrayList() : itemConList);

	        resultList.add(listMap);
	    }


		return resultList;
	}
}
	
	