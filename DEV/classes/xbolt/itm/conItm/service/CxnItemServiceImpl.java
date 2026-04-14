package xbolt.itm.conItm.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonDataServiceImpl;
import xbolt.cmm.service.CommonService;

@Service("CxnItemService")
@SuppressWarnings("unchecked")
public class CxnItemServiceImpl extends CommonDataServiceImpl implements CommonService{
	@Resource(name = "CSService")
	private CommonService CSService;
		
	@Override
	public void save(Map map) throws Exception{
		// Param 
		String s_itemID = StringUtil.checkNull(map.get("s_itemID")); // mstItemID
		String strItemID = StringUtil.checkNull(map.get("strItemID")); // strItemID
		String toItemID = StringUtil.checkNull(map.get("toItemID")); // 체크한 itemID(connection을 맺을 Item)
		String categoryCode = StringUtil.checkNull(map.get("categoryCode"));
		String structureID = StringUtil.checkNull(map.get("structureID"));
		String strType = StringUtil.checkNull(map.get("strType")); 
		String strLevel = StringUtil.checkNull(map.get("strLevel")); // strItemID 의 level
		String sessionUserId = StringUtil.checkNull(map.get("sessionUserId"));
		String sessionTeamId = StringUtil.checkNull(map.get("sessionTeamId"));
		String cxnItemType = StringUtil.checkNull(map.get("cxnItemType")); // strItemTypeCode
		
		String cxnClassCode = StringUtil.checkNull(map.get("cxnClassCode"));		
		String projectID = StringUtil.checkNull(map.get("projectID"));
		String curChangeSet = StringUtil.checkNull(selectString("item_SQL.getItemCurChangeSet", map));
		
		HashMap setMap = new HashMap();
		HashMap insertData = new HashMap();
				
		insertData.put("Version", "1");			
		insertData.put("Deleted", "0");
		insertData.put("ProjectID", projectID);
		insertData.put("Creator", sessionUserId);
		insertData.put("OwnerTeamId", sessionTeamId);
		insertData.put("AuthorID", sessionUserId);
		insertData.put("Status","NEW1");
		
		String connectionType = StringUtil.checkNull(map.get("connectionType"));
		if(connectionType.equals("")){
			setMap.put("itemTypeCode", StringUtil.checkNull(selectString("item_SQL.getItemTypeCode", map)) );
			setMap.put("cxnTypeCode", StringUtil.checkNull(map.get("cxnTypeCode")));
			Map cxnTypeInfo = (Map)select("item_SQL.getCxnTypeInfo", setMap);
			connectionType = StringUtil.checkNull(cxnTypeInfo.get("CxnType"));
			if(cxnItemType.equals("")) {
				cxnItemType = StringUtil.checkNull(cxnTypeInfo.get("CxnTypeCode"));
			}
		}		
		
		if(!curChangeSet.equals("")){
			setMap.put("s_itemID", curChangeSet);
			setMap.put("ProjectID",StringUtil.checkNull(selectString("cs_SQL.getProjectIDForCSID", setMap)));
		}
		
		String newItemID = StringUtil.checkNull(map.get("newItemID"));
		if(StringUtil.checkNull(map.get("newItemID")).equals("")) {
			newItemID = StringUtil.checkNull(selectString("item_SQL.getItemMaxID", setMap));
		}
		
		insertData.put("ItemID", newItemID);
		if (connectionType.equals("From")) {
			insertData.put("FromItemID", s_itemID);
			insertData.put("ToItemID", toItemID);	
		} else {
			if(!StringUtil.checkNull(map.get("udfSTR")).equals("Y")) {
				insertData.put("ToItemID", s_itemID);
				insertData.put("FromItemID", toItemID);					
			}else {
				insertData.put("FromItemID", s_itemID);
				insertData.put("ToItemID", toItemID);	
			}
		}			
		
		if(strType.equals("2")){			
			setMap.put("itemID", toItemID);											
			cxnClassCode = selectString("item_SQL.getSubStrItemClassCode", setMap);
			insertData.put("ParentID", strItemID);		
			insertData.put("StructureID", structureID);	
			insertData.put("Level", Integer.parseInt(strLevel)+1);				
		}
		if(cxnItemType.equals("")){ cxnItemType = StringUtil.checkNull(selectString("item_SQL.getCXNItemTypeCode",insertData), ""); }

		
		insertData.put("ItemTypeCode", cxnItemType);
		if(categoryCode.equals("")){ categoryCode = StringUtil.checkNull( selectString("item_SQL.selectItemTypeCategory", insertData), "CN"); }
		insertData.put("CategoryCode", categoryCode);
		
		if(cxnClassCode.equals("")){
			cxnClassCode = StringUtil.checkNull( selectString("item_SQL.selectItemClassCodePertinent", insertData), "NL00000");
		}
		insertData.put("ClassCode", cxnClassCode);
		
		String existItem = StringUtil.checkNull(selectString("item_SQL.getConItemID", insertData)); // deleted != 0 	
		if(StringUtil.checkNull(map.get("udfSTR")).equals("Y")) { // 무조건 신규생성되도록
			existItem = "";
			insertData.put("ClassCode", StringUtil.checkNull(map.get("cxnClassCode")));
			insertData.put("refCItemID", StringUtil.checkNull(map.get("refCItemID")));
		}
		if(existItem.equals("") || existItem == null){						
				insert("item_SQL.insertItem", insertData);
		}else{ // update 이미 삭제된(deleted = 1) -> deleted = 0 
			insertData.put("deleted", "0");
			insertData.put("ItemID",existItem);
			insertData.put("LastUser", sessionUserId);
			update("item_SQL.updateItem", insertData);
		}
		
		if(StringUtil.checkNull(map.get("udfSTR")).equals("Y") && !StringUtil.checkNull(map.get("AT00001")).equals("")) { // UDF 생성시 strItemID 의 AT00001 에 클래스 정렬 insert
			setMap.put("ClassCode", cxnClassCode);
			setMap.put("ItemTypeCode", cxnItemType);
			setMap.put("languageID", map.get("languageID"));
			
			setMap.put("ItemID",newItemID);
			setMap.put("AttrTypeCode", "AT00001");
			setMap.put("PlainText", StringUtil.checkNull(map.get("classNames")));
			
			insert("item_SQL.setItemAttr", setMap);
		}
		
		/* 신규 생성된 CXN ITEM의 ITEM_CLASS.ChangeMgt = 1 일 경우, CHANGE_SET 테이블에 레코드 생성  */
		insertData = new HashMap();
		setMap.put("ItemID", newItemID);
		String changeMgt = StringUtil.checkNull(selectString("project_SQL.getChangeMgt", setMap));
		
		insertData.put("itemID", newItemID);
		projectID = selectString("item_SQL.getProjectIDFromItem", insertData);
		
		if (changeMgt.equals("1")) {
			/* Insert to TB_CHANGE_SET */
			//insertData.put("itemID", itemID);
			insertData.put("userId", sessionUserId);
			insertData.put("projectID", projectID);
			insertData.put("classCode", cxnClassCode);
			insertData.put("KBN", "insertCNG");
			insertData.put("status", "MOD");
			CSService.save(new ArrayList(), insertData);						
		}
	} 

}
