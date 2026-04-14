package xbolt.itm.inf.service;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.apache.commons.text.StringEscapeUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.PropertyAccessor;
import com.fasterxml.jackson.databind.ObjectMapper;

import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.GetItemAttrList;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonDataServiceImpl;
import xbolt.cmm.service.CommonService;
import xbolt.itm.inf.dto.ItemInfoDTO;
import xbolt.itm.inf.dto.ItemListDTO;


@Service("ItemInfoApiService")
@SuppressWarnings("unchecked")
public class ItemInfoAPIServiceImpl extends CommonDataServiceImpl implements CommonService{
	
	private static final ObjectMapper DTO_MAPPER;

    static {
        DTO_MAPPER = new ObjectMapper();
        DTO_MAPPER.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.NONE);
        DTO_MAPPER.setVisibility(PropertyAccessor.FIELD, JsonAutoDetect.Visibility.ANY);
    }
	
	//1) htmlTitle 조회
	
    public String getHtmlTitle(ItemInfoDTO itemInfoDTO) throws Exception {
        Map<String, Object> setMap = new HashMap<>();
        String htmlTitle = "";

        //  DTO → Map 변환 
        setMap = DTO_MAPPER.convertValue(itemInfoDTO, Map.class);
        
        // main list
        htmlTitle = StringUtil.checkNull(selectString("item_SQL.getItemInfoHeader", setMap));
		String itemClassMenuVarFilter = StringUtil.checkNull(selectString("menu_SQL.getItemClassMenuVarFilter", setMap));

		if (itemClassMenuVarFilter.contains("OPS")) {
			if("".equals(itemInfoDTO.getChangeSetID())) {
				String releaseNo = StringUtil.checkNull(selectString("item_SQL.getItemReleaseNo", setMap));
				setMap.put("changeSetID", releaseNo);
			}
			String itemAttrRevName = StringUtil.checkNull(selectString("item_SQL.getItemRevHeader", setMap), "");
			if (!"".equals(itemAttrRevName)) {
				htmlTitle = itemAttrRevName;
			}
		}
		
	    return htmlTitle;
    }
    
    //2) itemMgtInfo url을 통해 itemViewPage 체크
	
    public String checkUrlForClassVarfilter(ItemInfoDTO itemInfoDTO) throws Exception {
        Map<String, Object> setMap = new HashMap<>();
        String itemMainPage = StringUtil.checkNull(itemInfoDTO.getItemMainPage());
        String classVarfilter = "";
        
        //  DTO → Map 변환 
        setMap = DTO_MAPPER.convertValue(itemInfoDTO, Map.class);
        
        // class varfilter 가져오기
        classVarfilter = StringUtil.checkNull(selectString("menu_SQL.getMenuVarFilterByClass", setMap)); // default url = Menu Varfilter
        classVarfilter = classVarfilter.split("=")[classVarfilter.split("=").length - 1];

		if (("V").equals(itemInfoDTO.getScrnMode()) || ("").equals(itemInfoDTO.getScrnMode())) {
			if (!("").equals(itemInfoDTO.getItemViewPage())) {
				itemMainPage = "/" + StringUtil.checkNull(itemInfoDTO.getItemViewPage(), classVarfilter);
			}
		} else if (("N").equals(itemInfoDTO.getScrnMode())) {
			if (!("").equals(itemInfoDTO.getItemNewPage())) {
				itemMainPage = "/" + StringUtil.checkNull(itemInfoDTO.getItemNewPage(), classVarfilter);
			}
		} else {
			itemInfoDTO.setAccMode("DEV");
			if (!("").equals(itemInfoDTO.getItemEditPage())) {
				itemMainPage = "/" + StringUtil.checkNull(itemInfoDTO.getItemEditPage(), classVarfilter);
			}
		}
		
		if(itemMainPage == "") itemMainPage = "/itm/itemInfo/itemClassMenu";
		
	    return itemMainPage;
    }
    
    //3) RootItemPath 조회
	
    public List getItemPath(String itemID, String languageID, List itemPath) throws Exception {
        Map<String, Object> setMap = new HashMap<>();
		setMap.put("itemID", itemID);
		String ParentItemID = StringUtil.checkNull(selectString("item_SQL.getParentItemID", setMap), "0");
		
		int pID = 0;
	    try {
	        pID = Integer.parseInt(ParentItemID);
	    } catch (NumberFormatException e) {
	        return itemPath; // 숫자가 아니면 여기서 중단
	    }
		
        if (pID != 0 && pID > 100) {
			
        	setMap.put("ItemID", ParentItemID);
			setMap.put("languageID", languageID);
			setMap.put("attrTypeCode", "AT00001");
			Map temp = select("attr_SQL.getItemAttrText", setMap);
			
			if (temp != null) {
				temp.put("itemID", ParentItemID);
				itemPath.add(temp);
				getItemPath(ParentItemID, languageID, itemPath);
			}
		}
		
	    return itemPath;
    }
    
    //4) classCode 할당 메뉴 조회
	
    public List getClassMenu(ItemInfoDTO itemInfoDTO) throws Exception {
        Map<String, Object> setMap = new HashMap<>();
        setMap = DTO_MAPPER.convertValue(itemInfoDTO, Map.class); // item child list 관련 dto
        
        List getList = new ArrayList();
        
        setMap.put("ArcCode", itemInfoDTO.getArcCode());
		// TODO:MPM관리자 -> Org/User -> 사용자 관리
		// TB_MENU_ALLOC.ClassCode IS NULL

		// [ArcCode][ClassCode]의 Menu 취득
		getList = selectList("menu_SQL.getTabMenu", setMap);

		// [ClassCode]의 default Menu 취득
		if (getList.size() == 0) {
			setMap.put("ArcCode", "AR000000");
			getList = selectList("menu_SQL.getTabMenu", setMap);
		}

		// default Menu 취득
		if (getList.size() == 0) {
			setMap.put("ArcCode", "AR000000");
			setMap.put("s_itemID", "null");
			setMap.put("ClassCode", "CL01000");
			getList = selectList("menu_SQL.getTabMenu", setMap);
		}
		
	    return getList;
    }
    
    //5) quick checkout 설정
	
    public String getQuickCheckOut(Map itemInfo, String sessionUserId, String s_itemID) throws Exception {
    	
    	Map<String, Object> setMap = new HashMap<>();
    	String quickCheckOut = "N";
		
    	String itemAuthorID = StringUtil.checkNull(itemInfo.get("AuthorID"));
		
		setMap.put("ItemID", s_itemID);
		String changeMgt = StringUtil.checkNull(selectString("project_SQL.getChangeMgt", setMap));
		
		if (itemInfo.get("Blocked").equals("2")) {
			// attributeBtn = "N";
			setMap = new HashMap();
			setMap.put("itemID", s_itemID);
			setMap.put("accessRight", "U");
			setMap.put("userID", sessionUserId);
			String myItemMember = StringUtil.checkNull(selectString("item_SQL.getMyItemMemberIDTop1", setMap));
			if ((itemInfo.get("Status").equals("REL")) && changeMgt.equals("1")
					&& (itemAuthorID.equals(sessionUserId) || myItemMember.equals(sessionUserId))) {
				quickCheckOut = "Y";
			}
		}
		
	    return quickCheckOut;
    }
    
    //6) multiSearch용 attrList 설정
	
    public List<Map<String, Object>> getAttrCodeList(String AttrCodeOLM_MULTI_VALUE) throws Exception {
    	
    	List<Map<String, Object>> attrList = new ArrayList<>();
		
    	if (AttrCodeOLM_MULTI_VALUE != null && !AttrCodeOLM_MULTI_VALUE.isEmpty()) {
    		String[] attrValue = AttrCodeOLM_MULTI_VALUE.split(",", -1);

    		for (int i = 0; i < attrValue.length; i += 6) {
    		    // 범위 check
    		    if (i + 5 >= attrValue.length) break;

    		    Map<String, Object> row = new HashMap<>();
    		    row.put("attrCode", attrValue[i]);
    		    
    		    // lovCode 처리: 빈 값이 아니면 배열로 변환
    		    if (!attrValue[i+1].isEmpty()) {
    		        row.put("lovCode", attrValue[i+1].split("\\*"));
    		    }
    		    
    		    if (!attrValue[i+2].isEmpty()) {
    		    	String searchValue = URLDecoder.decode(attrValue[i+2], StandardCharsets.UTF_8.name());
    		    	row.put("searchValue", searchValue.replace("comma", ","));
    		    }
    		    row.put("AttrCodeEscape", attrValue[i+3]);
    		    row.put("constraint", attrValue[i+4]);
    		    row.put("selectOption", attrValue[i+5]);

    		    attrList.add(row);
    		}
    	}
		
	    return attrList;
    }
    
    //7) outPutItems 하위항목 조회
    public String getOutPutItems(String itemId, Map setMap) throws Exception {
    	
		List<String> delItemIdList = new ArrayList<>();
		String currentSearchId = itemId;
		
		while (true) { 
			
			setMap.put("CURRENT_ITEM", currentSearchId); // 해당 아이템이 [FromItemID]인것
			setMap.put("CategoryCode", "ST1");
			
			List<Map<String, Object>> list = selectList("report_SQL.getChildItems", setMap);
			if (list == null || list.isEmpty()) break;
			
			List<String> toItemIds = list.stream()
					.map(m -> String.valueOf(m.get("ToItemID")))
	                .collect(Collectors.toList());
			
			delItemIdList.addAll(toItemIds);
			
			currentSearchId = toItemIds.stream().map(id -> "'" + id + "'").collect(Collectors.joining(","));
		}
			
		return delItemIdList.stream().distinct().collect(Collectors.joining(","));
		
    }
    
    //8) 하위항목 item 삭제
    @Transactional(rollbackFor = Exception.class)
    public void deleteItems(ItemListDTO itemListDTO) throws Exception {
    	
    	// parameter check
        List<String> items = itemListDTO.getItems();
        if (items == null || items.isEmpty()) {
            throw new IllegalArgumentException("Selected items are empty.");
        }

        String categoryCode = itemListDTO.getCategoryCode();
        String userId = itemListDTO.getSessionUserId();

        for (String itemId : items) {
            Map<String, Object> paramMap = new HashMap<>();
            paramMap.put("s_itemID", itemId);

            // 1. 상태 조회
            String itemStatus = selectString("project_SQL.getItemStatus", paramMap);

            // 2. 파라미터 셋팅
            Map<String, Object> updateMap = new HashMap<>();
            updateMap.put("s_itemID", itemId);
            updateMap.put("ItemID", itemId);
            updateMap.put("Deleted", "1");
            updateMap.put("LastUser", userId);
            updateMap.put("lastUser", userId);
            
            if (!"".equals(categoryCode)) updateMap.put("categoryCode", categoryCode);
        
            if ("MOD1".equals(itemStatus)) {
                updateMap.put("Status", "DEL1");
            }
            
            // connection Item update
            update("item_SQL.updateCNItemDeleted", updateMap);
            // Item update
            update("project_SQL.updateItemStatus", updateMap);
        }
        
    }
    
    //9) 아이템 attr 업데이트를 위한 업데이트 list 셋팅 ( 셋팅 시 , MLOV 값은 삭제가 진행됨 )
	public List<Map<String, Object>> prepareItemAttrUpdateList(HashMap attrMap) throws Exception {
		
        
        List<Map<String, Object>> updateList = new ArrayList<>();
        
        // 공통 변수 정리
 		String itemID = StringUtil.checkNull(attrMap.get("s_itemID"));
 		String classCode = StringUtil.checkNull(attrMap.get("classCode"));
 		String itemTypeCode = StringUtil.checkNull(attrMap.get("ItemTypeCode"));
 		String languageID = StringUtil.checkNull(attrMap.get("languageID"));
        
        // 명칭 update
        String AT00001YN = StringUtil.checkNull(attrMap.get("AT00001YN"));
        String AT00001 = StringUtil.checkNull(attrMap.get("AT00001"));
        
        if (!"".equals(AT00001) && !"N".equals(AT00001YN)) {
        	Map<String, Object> nameMap = new HashMap<>();
        	nameMap.put("AttrTypeCode", "AT00001");
        	nameMap.put("PlainText", AT00001);
        	nameMap.put("ItemID", itemID);
        	nameMap.put("ClassCode", classCode);
        	nameMap.put("ItemTypeCode", itemTypeCode);
        	nameMap.put("languageID", languageID);
        	updateList.add(nameMap);
		}
    	
        // Editable 이, 1인 속성만 update 처리를 한다
        attrMap.put("Editable", "1");
        List<Map<String, Object>> returnData = (List) selectList("attr_SQL.getItemAttr", attrMap);
		
		
		
		// returnData 값과 attrMap 값을 이용해 updateMap 셋팅
		for (int i = 0; i < returnData.size(); i++) {
			Map<String, Object> row = (Map<String, Object>) returnData.get(i);
		    String dataType = StringUtil.checkNull(row.get("DataType"));
		    String attrTypeCode = StringUtil.checkNull(row.get("AttrTypeCode"));
		    String value = StringUtil.checkNull(attrMap.get(attrTypeCode));
		    
		    Map<String, Object> updateMap = new HashMap<>(row);
		    updateMap.put("ItemID", itemID);
		    updateMap.put("ClassCode", classCode);
		    updateMap.put("ItemTypeCode", itemTypeCode);
		    updateMap.put("languageID", languageID);
		    
		    if ("MLOV".equals(dataType)) {
		        Map delData = new HashMap();
		        delData.put("ItemID", itemID);
		        delData.put("AttrTypeCode", attrTypeCode);
		        delete("attr_SQL.delItemAttr", delData);

		        String[] reqMLovValues = value.split(",");
		        for (String val : reqMLovValues) {
		            Map mlovMap = new HashMap(updateMap);
		            mlovMap.put("PlainText", val);
		            mlovMap.put("LovCode", val);
		            updateList.add(mlovMap); 
		        }
		    } else {
		        
		        if ("Text".equals(dataType)) {
		            if ("1".equals(StringUtil.checkNull(updateMap.get("HTML")))) {
		                value = StringEscapeUtils.escapeHtml4(value);
		            }
		            updateMap.put("languageID", languageID);
		            updateMap.put("LovCode", StringUtil.checkNull(selectString("attr_SQL.selectAttrLovCode", updateMap), ""));
		        } else {
		        	if (!"Time".equals(dataType)) {
			        	updateMap.put("LovCode", value);
			        }
		        }
		        updateMap.put("PlainText", value);
		        updateList.add(updateMap);
		    }
		}
        
        return updateList;
		
	}
    
    
}
