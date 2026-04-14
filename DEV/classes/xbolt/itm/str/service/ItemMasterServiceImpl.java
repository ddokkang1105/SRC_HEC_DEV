package xbolt.itm.str.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonDataServiceImpl;
import xbolt.cmm.service.CommonService;

@Service("itemMasterService")
public class ItemMasterServiceImpl extends CommonDataServiceImpl implements CommonService{
	@Resource(name = "CSService")
	private CommonService CSService;
		
	@Override
	public void save(Map map) throws Exception{
		HashMap setMap = new HashMap();
		HashMap insertData = new HashMap();
		
		String s_itemID = StringUtil.checkNull(map.get("s_itemID")); 
		String option = StringUtil.checkNull(map.get("option")); 
		String sessionUserId = StringUtil.checkNull(map.get("sessionUserId")); 
		String sessionTeamId = StringUtil.checkNull(map.get("sessionTeamId")); 
		String newClassCode = StringUtil.checkNull(map.get("newClassCode")); 
		String identifier = StringUtil.checkNull(map.get("newIdentifier")); 
		String itemTypeCode = StringUtil.checkNull(map.get("itemTypeCode")); 
		String IsPublic = StringUtil.checkNull(map.get("IsPublic")); 
		String csrInfo = StringUtil.checkNull(map.get("csrInfo")); 
		String refItemID = StringUtil.checkNull(map.get("refItemID")); 
		String autoID = StringUtil.checkNull(map.get("autoID")); 
		String preFix = StringUtil.checkNull(map.get("preFix")); 
		String newItemName = StringUtil.checkNull(map.get("newItemName")); 
		String cpItemID = StringUtil.checkNull(map.get("cpItemID")); 
		String mstSTR = StringUtil.checkNull(map.get("mstSTR")); 
		String strType = StringUtil.checkNull(map.get("strType")); 
		String mstItemID = StringUtil.checkNull(map.get("mstItemID")); 
		String structureID = StringUtil.checkNull(map.get("structureID")); 
		String strLevel = StringUtil.checkNull(map.get("strLevel")); 
		String strItemTypeCode = StringUtil.checkNull(map.get("strItemTypeCode"));
		String mstItemTypeCode = StringUtil.checkNull(map.get("mstItemTypeCode"));
		String newItemID = StringUtil.checkNull(map.get("newItemID"));
		
		setMap.put("s_itemID", s_itemID);
		if(itemTypeCode.equals("")){
			itemTypeCode = StringUtil.checkNull(selectString("item_SQL.selectedItemTypeCode", setMap));
		}
		
		if(newItemID.equals("")) newItemID = selectString("item_SQL.getItemMaxID", setMap);
		
		insertData.put("option", option);			
		insertData.put("Version", "1");
		insertData.put("Deleted", "0");
		insertData.put("Creator", sessionUserId);
		insertData.put("CategoryCode", "OJ");
		insertData.put("ClassCode", newClassCode);
		insertData.put("OwnerTeamId", sessionTeamId);
		insertData.put("Identifier", identifier);
		insertData.put("ItemID", newItemID);			
		insertData.put("s_itemID", s_itemID);	
		insertData.put("ItemTypeCode", itemTypeCode);
		
		insertData.put("AuthorID", sessionUserId);
		insertData.put("IsPublic", IsPublic);
		insertData.put("ProjectID", csrInfo);
		insertData.put("RefItemID", refItemID);
		insertData.put("Status","NEW1");
		insertData.put("projectID", csrInfo);
		String itemAccCtrl = StringUtil.checkNull(selectString("project_SQL.getProjectItemAccCtrl", insertData));
		insertData.put("AccCtrl", itemAccCtrl);
		insertData.put("itemId", s_itemID);	
		String idLength = "";
		
		String newItemCode = "";
		if(autoID.equals("Y")){
			newItemCode = StringUtil.checkNull(selectString("item_SQL.getNewItemCode", setMap));
			if(!newItemCode.equals("") && newItemCode != null) {				
				identifier = newItemCode;				
			}else {
				setMap.put("preFix", preFix);
				identifier = StringUtil.checkNull(selectString("item_SQL.getMaxPreFixIdentifier", setMap));
				for(int i=0; 5-identifier.length() > i; i++){
					idLength = idLength + "0";
				}
				
				if(identifier.equals("")){
					identifier = preFix + "00001";
				}else{
					identifier = preFix + idLength + identifier;
				}
			}
			
			insertData.put("Identifier", identifier);
		}
		
		String clientID = "";
		setMap.put("ProjectID", csrInfo);
		Map<String, Object> parentInfoMap = select("project_SQL.getParentPjtInfo", setMap);
		if(!parentInfoMap.isEmpty()) {
			clientID = StringUtil.checkNull(parentInfoMap.get("ClientID"));
		}
		insertData.put("clientID", clientID);
	
		insert("item_SQL.insertItem", insertData);
		
		insertData.put("PlainText", newItemName);
		insertData.put("AttrTypeCode","AT00001");			
		List getLanguageList = selectList("common_SQL.langType_commonSelect", insertData);			
		for(int i = 0; i < getLanguageList.size(); i++){
			Map getMap = (HashMap)getLanguageList.get(i);
			insertData.put("languageID", getMap.get("CODE") );				
			insert("item_SQL.ItemAttr", insertData);
		}	
		
		////// TB_ITEM, TB_ITEM_ATTR 생성 완료 ////////////////////////////////////
		
		////// CREATE STR ITEM //////////////////////////////////////////////// 
		String fromItemID = "";
		if ((!cpItemID.equals("") && mstSTR.equals("Y")) || cpItemID.equals("")) {
			if (strType.equals("2")) {
				insertData.put("itemID", newItemID);
				insertData.put("Level", Integer.parseInt(strLevel) + 1);
				String itemClassCode = StringUtil.checkNull(selectString("item_SQL.getSubStrItemClassCode", insertData));
				insertData.put("CategoryCode", "ST2");
				insertData.put("ClassCode", itemClassCode);
				insertData.put("ParentID", s_itemID);
				fromItemID = mstItemID;
				insertData.put("ItemTypeCode", strItemTypeCode);
				insertData.put("StructureID", structureID);
			} else {
				insertData.put("CategoryCode", "ST1");
				insertData.put("ClassCode", "NL00000");
				insertData.put("ItemTypeCode",selectString("item_SQL.selectedConItemTypeCode", insertData));
			}
			insertData.put("ToItemID", insertData.get("ItemID"));
			if (fromItemID.equals("")) {
				insertData.put("FromItemID", s_itemID);
			} else {
				insertData.put("FromItemID", fromItemID);
			}
			insertData.put("ItemID", StringUtil.checkNull(selectString("item_SQL.getItemMaxID", setMap)));
		
			insertData.remove("RefItemID");
			insertData.remove("Identifier");

			insert("item_SQL.insertItem", insertData);
		}
		
		/* 신규 생성된 ITEM의 ITEM_CLASS.ChangeMgt = 1 일 경우, CHANGE_SET 테이블에 레코드 생성  */
		insertData = new HashMap();
		setMap.put("ItemID", newItemID);
		String changeMgt = StringUtil.checkNull(selectString("project_SQL.getChangeMgt", setMap));
		if (changeMgt.equals("1")) {
			/* Insert to TB_CHANGE_SET */
			insertData.put("itemID", newItemID);
			insertData.put("userId", sessionUserId);
			insertData.put("projectID", csrInfo);
			insertData.put("classCode", newClassCode);
			insertData.put("KBN", "insertCNG");
			insertData.put("status", "MOD");
			CSService.save(new ArrayList(), insertData);
		}else if(!changeMgt.equals("1")){ 
			/* ChangeMgt !=1 인 경우 ParentItem의 CurChangeSet Update */
			setMap.put("itemID",s_itemID);
			String sItemIDCurChangeSetID = StringUtil.checkNull(selectString("project_SQL.getCurChangeSetIDFromItem", setMap));
			if(!sItemIDCurChangeSetID.equals("")){
				insertData = new HashMap();
				insertData.put("CurChangeSet", sItemIDCurChangeSetID);
				insertData.put("s_itemID", newItemID);
				update("project_SQL.updateItemStatus", insertData);
			}
		}
	} 

}
