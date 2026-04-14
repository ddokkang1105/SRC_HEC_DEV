package xbolt.itm.inf.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.service.CommonService;
import xbolt.itm.inf.dto.ItemInfoDTO;
import xbolt.itm.inf.dto.ItemListDTO;
import xbolt.itm.inf.dto.ItemSearchDTO;
import xbolt.itm.inf.service.ItemInfoAPIServiceImpl;

import com.fasterxml.jackson.annotation.PropertyAccessor;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.org.json.JSONArray;
import com.org.json.JSONException;
import com.org.json.JSONObject;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.text.StringEscapeUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.*;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.stream.Collectors;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.PropertyAccessor;

/**
 * 업무 처리
 * 
 * @Class Name : BizController.java
 * @Description : 업무화면을 제공한다.
 * @Modification Information
 * @수정일 수정자 수정내용 @--------- --------- ------------------------------- @2012. 09.
 *      01. smartfactory 최초생성
 *
 * @since 2012. 09. 01.
 * @version 1.0
 */

@Controller
@SuppressWarnings("unchecked")
public class itemInfoAPIActionController extends XboltController {

	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "ItemInfoApiService")
	private ItemInfoAPIServiceImpl itemInfoAPIService;

	private final Log _log = LogFactory.getLog(this.getClass());
	
	private static final ObjectMapper DTO_MAPPER;

    static {
        DTO_MAPPER = new ObjectMapper();
        // JSON에만 있는 필드는 무시하고 진행
        DTO_MAPPER.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        // 메서드(Getter/Setter)는 무시하고, 실제 변수(Field)로 확인
        DTO_MAPPER.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.NONE);
        DTO_MAPPER.setVisibility(PropertyAccessor.FIELD, JsonAutoDetect.Visibility.ANY);
    }
	
	// 아이템의 기본 정보 조회
	@RequestMapping(value = "getItemInfo.do", method = RequestMethod.GET)
	@ResponseBody
	public void getItemInfo(ItemInfoDTO itemInfoDTO, HttpServletResponse response) throws Exception {

	    response.setCharacterEncoding("UTF-8");
	    response.setContentType("application/json; charset=UTF-8");

	    JSONObject resultMap = new JSONObject();
	    Map setMap = new HashMap();
	    Map<String, Object> prcList = new HashMap();
	    
	    boolean success = false;

	    try {
	        
	        // parameter check
	        if (itemInfoDTO.getS_itemID().isEmpty()) {
	            throw new IllegalArgumentException("s_itemID is required.");
	        }
	        
	        // parameter put
	        setMap = DTO_MAPPER.convertValue(itemInfoDTO, Map.class);

	        // select
	        prcList = commonService.select("report_SQL.getItemInfo", setMap);
	        if ("OPS".equals(itemInfoDTO.getAccMode())) {
	        	
	        	String releaseNo = StringUtil.checkNull(prcList.get("ReleaseNo"));
	        	//String changeSetID   = itemInfoDTO.getChangeSetID();
                //changeSetID = (changeSetID == null || changeSetID.trim().isEmpty())? releaseNo : changeSetID;
				setMap.put("changeSetID", releaseNo);
				
	        	prcList = commonService.select("item_SQL.getItemAttrRevInfo", setMap);
	        	
	        }
	        
	        resultMap.put("data", prcList);
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
	
	// 아이템의 path 정보 조회
	@RequestMapping(value = "getRootItemPath.do", method = RequestMethod.GET)
	@ResponseBody
	public void getRootItemPath(String itemID, String languageID, HttpServletResponse response) throws Exception {

	    response.setCharacterEncoding("UTF-8");
	    response.setContentType("application/json; charset=UTF-8");

	    JSONObject resultMap = new JSONObject();
	    Map setMap = new HashMap();
	    List itemPath = new ArrayList();
	    boolean success = false;

	    try {
	        
	        // parameter check
	        if (itemID.isEmpty()) {
	            throw new IllegalArgumentException("itemID is required.");
	        }
	        
	        itemPath = itemInfoAPIService.getItemPath(itemID, languageID, itemPath);
	        Collections.reverse(itemPath);
	        
	        resultMap.put("data", itemPath);
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
	
	// 아이템 attr 정보 조회
	@RequestMapping(value = "getItemAttrList.do", method = RequestMethod.GET)
	@ResponseBody
	public void getItemAttrList(ItemInfoDTO itemInfoDTO, @RequestParam(value="AttrTypeCode", required=false) String attrTypeCode, HttpServletResponse response) throws Exception {

	    response.setCharacterEncoding("UTF-8");
	    response.setContentType("application/json; charset=UTF-8");

	    JSONObject resultMap = new JSONObject();
	    Map setMap = new HashMap();
	    List<Map<String, Object>> attrList = new ArrayList();
	    
	    boolean success = false;

	    try {
	    	
	    	// 1. 필수값 체크
	        if (itemInfoDTO.getS_itemID() == null || itemInfoDTO.getS_itemID().isEmpty()) {
	            throw new IllegalArgumentException("s_itemID is required.");
	        }
	        
	        // parameter put
	        setMap = DTO_MAPPER.convertValue(itemInfoDTO, Map.class);

	        // select
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
			
			// dto와는 별개로 넣어줄 data
			setMap.put("ItemID", itemInfoDTO.getS_itemID());
			setMap.put("defaultLang", defaultLang);
			setMap.put("sessionCurrLangType", itemInfoDTO.getLanguageID());
			setMap.put("selectLanguageID", itemInfoDTO.getLanguageID());
			setMap.put("AttrTypeCode", StringUtil.checkNull(attrTypeCode));
			setMap.put("Editable", itemInfoDTO.getEditable()); // TB_ATTR_TYPE.Editable 조건 필터링 필요 
			
			//AttrTypeCode
			
			if ("OPS".equals(itemInfoDTO.getAccMode())) {
				String releaseNo = commonService.selectString("item_SQL.getItemReleaseNo", setMap);
				//String changeSetID   = itemInfoDTO.getChangeSetID();
				//changeSetID = (changeSetID == null || changeSetID.trim().isEmpty())? releaseNo : changeSetID;
				setMap.put("changeSetID", releaseNo);
				attrList = commonService.selectList("item_SQL.getItemRevDetailInfo", setMap);
	        } else {
	        	attrList = commonService.selectList("attr_SQL.getItemAttrV4", setMap);
	        }
			
			
			if("Y".equals(itemInfoDTO.getConListYN())) {
				// attrInfoList에 conList 넣기
				final List<Map<String, Object>> conList = commonService.selectList("item_SQL.getItemConList", setMap);
				attrList.forEach(attr -> attr.put("conList", conList));
			}
	        
	        resultMap.put("data", attrList);
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

	// 아이템 리스트
	@RequestMapping(value = "getItemListInfo.do", method = RequestMethod.GET)
	@ResponseBody
	public void getItemListInfo(ItemListDTO itemListDTO, ItemSearchDTO itemSearchDTO, HttpServletResponse response) throws Exception {

	    response.setCharacterEncoding("UTF-8");
	    response.setContentType("application/json; charset=UTF-8");

	    JSONObject resultMap = new JSONObject();
	    Map setMap = new HashMap();
	    List subItemList = new ArrayList();
	    
	    boolean success = false;

	    try {
	    	
	    	 // parameter check ( 검색을, owner 제외 )
	    	if("child".equals(itemListDTO.getListType())) {
	    		if (itemListDTO.getS_itemID().isEmpty()) {
	    			throw new IllegalArgumentException("s_itemID is required.");
	    		}
	    	}
	        
	    	// parameter put
	        setMap = DTO_MAPPER.convertValue(itemListDTO, Map.class);
	        Map searchMap = DTO_MAPPER.convertValue(itemSearchDTO, Map.class);
	        setMap.putAll(searchMap);

	        // select
	        if("child".equals(itemListDTO.getListType())) {
	        	if("OPS".equals(itemListDTO.getAccMode())) subItemList = commonService.selectList("item_SQL.getChildItemList_gridList", setMap);
	        	else subItemList = commonService.selectList("item_SQL.getSubItemList_gridList", setMap);
	        }
	        else if("owner".equals(itemListDTO.getListType())) {
	        	subItemList = commonService.selectList("item_SQL.getOwnerItemList_gridList",setMap);
	        }
	        else if("search".equals(itemListDTO.getListType())) {
		        
		        // attr 값 setting
		        List<Map<String, Object>> attrList = new ArrayList<>();
		    	attrList = itemInfoAPIService.getAttrCodeList(itemSearchDTO.getAttrCodeOLM_MULTI_VALUE());
		        setMap.put("AttrCode", attrList);
		    	
		    	// dimension 값 setting
		    	String DimValueIDOLM_ARRAY_VALUE = itemSearchDTO.getDimValueIDOLM_ARRAY_VALUE();
		    	if (DimValueIDOLM_ARRAY_VALUE != null && !DimValueIDOLM_ARRAY_VALUE.isEmpty()) {
		    	    String[] dimValueArray = DimValueIDOLM_ARRAY_VALUE.split(",");
		    	    setMap.put("DimValueID", dimValueArray);
		    	}

		        // select
		    	subItemList = commonService.selectList("search_SQL.getSearchMultiList_gridList",setMap);
		    	
	        }
	        
	        resultMap.put("data", subItemList);
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
	
	
	// 하위항목 리스트
	@RequestMapping(value = "getChildItems.do", method = RequestMethod.GET)
	@ResponseBody
	public void getChildItems(ItemListDTO itemListDTO, HttpServletResponse response) throws Exception {

	    response.setCharacterEncoding("UTF-8");
	    response.setContentType("application/json; charset=UTF-8");

	    JSONObject resultMap = new JSONObject();
	    
	    String outPutItems = "";
		Map setMap = new HashMap();
	    
	    boolean success = false;

	    try {
	    	
	    	 // parameter check
	        if (itemListDTO.getS_itemID().isEmpty()) {
	            throw new IllegalArgumentException("s_itemID is required.");
	        }
	    	
	        String itemId = itemListDTO.getS_itemID();
			setMap.put("ItemID", itemId);
	        
			// outPutItems 조회
			outPutItems = itemInfoAPIService.getOutPutItems(itemId, setMap);
			
	        resultMap.put("data", outPutItems);
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
	
	/**
	 * DHTMLX Tree의 목록을 조회한다.
	 */
	@RequestMapping(value="/jsonDhtmlxTreeListData.do")
	public void jsonDhtmlxTreeListJson(HashMap cmmMap, HttpServletResponse response, HttpServletRequest request) throws Exception{
		response.setCharacterEncoding("UTF-8");
		response.setContentType("application/json; charset=UTF-8");
		JSONObject resultMap = new JSONObject();
		boolean success = false;
		
		try {
			String SQL_CODE=StringUtil.checkNull(commonService.selectString("menu_SQL.getMenuTreeSqlName", cmmMap) ,"commonCode");
			String tFilterCode = StringUtil.checkNull(cmmMap.get("tFilterCode"));
			
			if(!"".equals(tFilterCode)) {
				SQL_CODE=StringUtil.checkNull(commonService.selectString("menu_SQL.getSqlNameForTfilterCode", cmmMap));
			}
			/* 해당 프로젝트 ID 설정 */
			Map projectInfoMap = new HashMap();
			String sessionTmplCode = StringUtil.checkNull(cmmMap.get("sessionTemplCode"));
			String projectID = "";
			if(sessionTmplCode.equals("TMPL003")){
				projectID = StringUtil.checkNull(cmmMap.get("projectID"));
				cmmMap.put("projectID", projectID);
			}else{
				projectInfoMap = commonService.select("main_SQL.getPjtInfoFromTEMPL", cmmMap);
				cmmMap.put("projectID", projectInfoMap.get("ProjectID"));
			}
			
			List<Map<String, Object>> data = new ArrayList<>();
			data = commonService.selectList(SQL_CODE, cmmMap);
			
			// TREE_ID 중복 제거 ( PRE_TREE_ID가 더 상위인 항목 하나만 남겨두기 )
			Map<Object, Map<String, Object>> uniqueDataMap = new LinkedHashMap<>(data.size());
			for (Map<String, Object> currentMap : data) {
				Object treeId = currentMap.get("TREE_ID");
			    // 1. 중복 여부 판단
				Map<String, Object> existingMap = uniqueDataMap.get(treeId);
				if (existingMap == null) {
					uniqueDataMap.put(treeId, currentMap);
				} else {
					// 2. 중복일 경우 비교 실행
					long currentPreId = Long.parseLong(String.valueOf(currentMap.getOrDefault("PRE_TREE_ID", "0")));
			        long existingPreId = Long.parseLong(String.valueOf(existingMap.getOrDefault("PRE_TREE_ID", "0")));

			        if (currentPreId < existingPreId) {
			            uniqueDataMap.put(treeId, currentMap);
			        }
				}
			}
			data = new ArrayList<>(uniqueDataMap.values());
			
			
			
			for (Map<String, Object> map : data) {
				// 1. TREE_NM -> value 로 변경
				if (map.containsKey("TREE_NM")) {
					map.put("value", StringUtil.checkNull(map.remove("TREE_NM")).replace("&#10;", ""));
				}
				// 2. PRE_TREE_ID -> parent 로 변경
				if (map.containsKey("PRE_TREE_ID")) {
					map.put("parent", map.remove("PRE_TREE_ID"));
				}
				 // 2. TREE_ID -> id 로 변경
				if (map.containsKey("TREE_ID")) {
					map.put("id", map.remove("TREE_ID"));
					// 스타일 들어가는지 테스트
					map.put("css", map.get("ClassCode"));
				}
			}
			
			success = true;
			resultMap.put("data", data);
		} catch (IllegalArgumentException e) {
        	// 400 Bad Request
        	response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            System.err.println(e);
        } catch (DataAccessException e) {
        	// 500 Internal Server Error
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            System.err.println(e);
        } catch (JSONException e) {
        	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            System.err.println(e);
        } catch (Exception e) {
        	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
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
	
	// 하위항목 아이템 삭제
	@Transactional(rollbackFor = Exception.class)
	@RequestMapping(value = "setItemStatusForDelApi.do", method = RequestMethod.POST)
	@ResponseBody
	public void setItemStatusForDelApi(@RequestBody String requestJsonArray, HttpServletResponse response) throws Exception {

	    response.setCharacterEncoding("UTF-8");
	    response.setContentType("application/json; charset=UTF-8");
	    
	    JSONObject resultMap = new JSONObject();
	    boolean success = false;

	    try {
	    	
	    	// JSON 배열을 DTO로 변환
	        ItemListDTO itemListDTO = DTO_MAPPER.readValue(requestJsonArray, ItemListDTO.class);
	        
	        itemInfoAPIService.deleteItems(itemListDTO);
	        success = true;

	    } catch (IllegalArgumentException e) {
	    	TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
	        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
	        resultMap.put("message", e.getMessage());
	        System.err.println(e);
	    } catch (DataAccessException e) {
	    	TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
	    	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	        resultMap.put("message", e.getMessage());
	        System.err.println(e);
	    } catch (Exception e) {
	    	TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
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
	
	// 아이템 Info 수정
	@Transactional(rollbackFor = Exception.class)
	@RequestMapping(value = "updateItemInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public void updateItemInfo(@RequestBody String requestJsonArray, HttpServletResponse response) throws Exception {

	    response.setCharacterEncoding("UTF-8");
	    response.setContentType("application/json; charset=UTF-8");
	    
	    JSONObject resultMap = new JSONObject();
	    Map setMap = new HashMap();
	    boolean success = false;

	    try {
	    	
	    	// JSON 배열을 DTO로 변환
	        ItemInfoDTO itemInfoDTO = DTO_MAPPER.readValue(requestJsonArray, ItemInfoDTO.class);
	        
	        // parameter put
	        setMap = DTO_MAPPER.convertValue(itemInfoDTO, Map.class);
	        
	        // 기본정보용 parameter setting
	        // 기존 DTO 에서 사용하는 변수가 아닌 항목들
	        setMap.put("ItemID", StringUtil.checkNull(itemInfoDTO.getS_itemID()));
	        setMap.put("LastUser", StringUtil.checkNull(itemInfoDTO.getSessionUserId()));
	        
	        // 기본정보 update
	        // Identifier , ClassCode, CompanyID, OwnerTeamID, Version, AuthorID, LastUser
	        commonService.update("item_SQL.updateItemObjectInfo", setMap);
	        
	        success = true;

	    } catch (IllegalArgumentException e) {
	    	TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
	        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
	        resultMap.put("message", e.getMessage());
	        System.err.println(e);
	    } catch (DataAccessException e) {
	    	TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
	    	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	        resultMap.put("message", e.getMessage());
	        System.err.println(e);
	    } catch (Exception e) {
	    	TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
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
	
	// 아이템 attr 수정
	@Transactional(rollbackFor = Exception.class)
	@RequestMapping(value = "updateItemAttr.do", method = RequestMethod.POST)
	@ResponseBody
	public void updateItemAttr(@RequestBody String requestJsonArray, HttpServletResponse response) throws Exception {

	    response.setCharacterEncoding("UTF-8");
	    response.setContentType("application/json; charset=UTF-8");
	    
	    JSONObject resultMap = new JSONObject();
	    List<Map<String, Object>> updateList = new ArrayList<>();
	    
	    HashMap<String, Object> attrMap = new HashMap();
	    String setInfo = "";
	    
	    boolean success = false;

	    try {
	    	
	    	// JSON 배열을 Map에 저장
	    	attrMap = DTO_MAPPER.readValue(requestJsonArray, new TypeReference<HashMap<String, Object>>() {});
	        
	    	// parameter check
	        String s_itemID = StringUtil.checkNull(attrMap.get("s_itemID"));
	        
	        if (s_itemID == null || s_itemID.isEmpty()) {
	        	throw new IllegalArgumentException("s_itemID is empty.");
	        }
	    	
	        // update 리스트 가져오기
	        updateList = itemInfoAPIService.prepareItemAttrUpdateList(attrMap);
	        
	        // update 진행
	        if (!updateList.isEmpty()) {
	        	for(Map updateMap : updateList) {
	        		setInfo = GetItemAttrList.attrUpdate(commonService, updateMap);
	        	}
	        }
	        
	    	success = true;

	    } catch (IllegalArgumentException e) {
	    	TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
	        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
	        resultMap.put("message", e.getMessage());
	        System.err.println(e);
	    } catch (DataAccessException e) {
	    	TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
	    	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	        resultMap.put("message", e.getMessage());
	        System.err.println(e);
	    } catch (Exception e) {
	    	TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
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
	
	// attr 중 ZAT4015 (최초 인증 담당자) 수정 시, 단순 attr 업데이트가 아닌 roleAssignment을 편집하는 메소드 (KEPICO 사용)
	@Transactional(rollbackFor = Exception.class)
	@RequestMapping(value = "processInitialAuthAssignment.do", method = RequestMethod.POST)
	@ResponseBody
	public void processInitialAuthAssignment(@RequestBody String requestJsonArray, HttpServletResponse response) throws Exception {

	    response.setCharacterEncoding("UTF-8");
	    response.setContentType("application/json; charset=UTF-8");
	    
	    JSONObject resultMap = new JSONObject();
	    
	    HashMap<String, Object> updateMap = new HashMap();
	    List<Map> updateList = new ArrayList<>();
	    
	    HashMap<String, Object> attrMap = new HashMap();
	    String setInfo = "";
	    
	    boolean success = false;

	    try {
	    	
	    	// JSON 배열을 Map에 저장
	    	attrMap = DTO_MAPPER.readValue(requestJsonArray, new TypeReference<HashMap<String, Object>>() {});
	        
	    	String itemID = StringUtil.checkNull(attrMap.get("s_itemID"));
	    	
			// KPEICO 사용 (최초 인증 담당자)
			String ZAT4015 = StringUtil.checkNull(attrMap.get("ZAT4015_ID"));
			String ZAT4015_Name = StringUtil.checkNull(attrMap.get("ZAT4015"));
			String ZAT4015_ORG = StringUtil.checkNull(attrMap.get("ZAT4015_ORG"));
			
			if(!"".equals(ZAT4015)) {
				if (!ZAT4015_Name.equals("") && ZAT4015_Name != null) {
					
					updateMap.put("sessionUserId", ZAT4015);
					String mbrTeamID = commonService.selectString("user_SQL.userTeamID", updateMap);
					
					updateMap.put("projectID", StringUtil.checkNull(attrMap.get("projectID")));
					updateMap.put("itemID", itemID);
					updateMap.put("assignmentType", "CNGROLETP");
					updateMap.put("roleType", "R");
					updateMap.put("orderNum", 1);
					updateMap.put("assigned", 1);
					updateMap.put("accessRight", "U");
					
					String myItemSeq = StringUtil
							.checkNull(commonService.selectString("role_SQL.getMyItemSeq", updateMap));
					
					updateMap.put("memberID", ZAT4015);
					updateMap.put("mbrTeamID", mbrTeamID);
					updateMap.put("creator", StringUtil.checkNull(attrMap.get("sessionUserId")));
					if (!myItemSeq.equals("")) {
						updateMap.put("seq", myItemSeq);
						commonService.update("role_SQL.updateRoleAssignment", updateMap);
					} else {
						commonService.insert("role_SQL.insertRoleAssignment", updateMap);
					}
				} else {
					updateMap.put("itemID", itemID);
					updateMap.put("assignmentType", "CNGROLETP");
					updateMap.put("roleType", "R");
					updateMap.put("orderNum", 1);
					updateMap.put("memberID", ZAT4015_ORG);
					commonService.delete("role_SQL.deleteRoleAssignment", updateMap);
				}
			}
	    	
	    	success = true;

	    } catch (IllegalArgumentException e) {
	    	TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
	        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
	        resultMap.put("message", e.getMessage());
	        System.err.println(e);
	    } catch (DataAccessException e) {
	    	TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
	    	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	        resultMap.put("message", e.getMessage());
	        System.err.println(e);
	    } catch (Exception e) {
	    	TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
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
}
