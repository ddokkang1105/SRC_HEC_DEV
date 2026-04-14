package xbolt.custom.sk.skon;

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
public class SKONAPIActionController extends XboltController {

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
	@RequestMapping(value = "zSKON_getChildsItemAndisNothingLow.do", method = RequestMethod.GET)
	@ResponseBody
	public void zSKON_getChildsItemAndisNothingLow(ItemListDTO itemListDTO, HttpServletResponse response) throws Exception {

	    response.setCharacterEncoding("UTF-8");
	    response.setContentType("application/json; charset=UTF-8");

	    JSONObject resultMap = new JSONObject();
	    Map setMap = new HashMap();
	    String childItems = "";
	    
	    boolean success = false;

	    try {
	        
	    	String isNothingLowLank = "N";
	    	String itemId = StringUtil.checkNull(itemListDTO.getS_itemID());
	    	
			List itemIdList = new ArrayList();
			List list = new ArrayList();
			Map map = new HashMap();
			
			setMap.put("ItemID", itemId);

			// 취득한 아이템 리스트 사이즈가 0이면 while문을 빠져나간다.
			int j = 1;
			while (j != 0) {
				String toItemId = "";

				setMap.put("CURRENT_ITEM", itemId); // 해당 아이템이 [FromItemID]인것
				setMap.put("CategoryCode", "ST1");
				// setMap.put("CategoryCodes", "'ST1','ST2'");
				list = commonService.selectList("report_SQL.getChildItems", setMap);
				j = list.size();
				for (int k = 0; list.size() > k; k++) {
					map = (Map) list.get(k);
					setMap.put("ItemID", map.get("ToItemID"));
					itemIdList.add(map.get("ToItemID"));

					if (k == 0) {
						toItemId = "'" + String.valueOf(map.get("ToItemID")) + "'";
					} else {
						toItemId = toItemId + ",'" + String.valueOf(map.get("ToItemID")) + "'";
					}
				}

				itemId = toItemId; // ToItemID를 다음 ItemID로 설정
			}

			for (int i = 0; itemIdList.size() > i; i++) {

				if (childItems.isEmpty()) {
					childItems += itemIdList.get(i);
				} else {
					childItems += "," + itemIdList.get(i);
				}
			}
				
				
			if (childItems.isEmpty()) {
				isNothingLowLank = "Y";
			}
			
			
			map.clear();
			map.put("childItems", childItems);
			map.put("isNothingLowLank", isNothingLowLank);
	        
	        resultMap.put("data", map);
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
	
}
