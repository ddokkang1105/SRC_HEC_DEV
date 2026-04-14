package xbolt.itm.inf.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonDataServiceImpl;
import xbolt.cmm.service.CommonService;


@Service("itemInfoService")
@SuppressWarnings("unchecked")
public class ItemInfoActionServiceImpl extends CommonDataServiceImpl implements CommonService{

	@Override
	public void save(List lst, Map cmmMap) throws Exception{

		Map mapData = new HashMap();
		for(int i = 0; i < lst.size() ; i++){				
			mapData = (HashMap)lst.get(i);				
			mapData.put("ItemID", cmmMap.get("s_itemID"));
			mapData.put("languageID", cmmMap.get("languageID"));
			mapData.put("ClassCode", cmmMap.get("classCode"));
			mapData.put("ItemTypeCode", cmmMap.get("ItemTypeCode"));				
			mapData.put("PlainText", StringUtil.checkNull(cmmMap.get(mapData.get("AttrTypeCode").toString()),"") );				
			mapData.put("LovCode", StringUtil.checkNull( selectString("attr_SQL.selectAttrLovCode", mapData) ,"") );
		
			if(mapData.get("PlainText").toString().equals("")){
				delete("attr_SQL.delItemAttr", mapData);
			}else{
				Map setMap = new HashMap();
				setMap = (HashMap)select("attr_SQL.getItemAttrID", mapData);
				
				if( StringUtil.checkNull(setMap.get("ItemID").toString(),"0").equals("0")){
	
					setMap.put("ClassCode", mapData.get("ClassCode"));
					setMap.put("ItemTypeCode", mapData.get("ItemTypeCode"));
					setMap.put("languageID",  mapData.get("languageID"));
					setMap.put("LovCode", mapData.get("LovCode"));
					setMap.put("ItemID", mapData.get("ItemID"));
					setMap.put("AttrTypeCode", mapData.get("AttrTypeCode"));
					setMap.put("PlainText", mapData.get("PlainText"));
					
					insert("item_SQL.setItemAttr", setMap);
				}else{
					setMap.put("ClassCode", mapData.get("ClassCode"));
					setMap.put("ItemTypeCode", mapData.get("ItemTypeCode"));
					setMap.put("languageID", mapData.get("languageID"));
					setMap.put("LovCode", mapData.get("LovCode"));
					setMap.put("ItemID", mapData.get("ItemID"));
					setMap.put("PlainText", mapData.get("PlainText"));
					setMap.put("AttrTypeCode", mapData.get("AttrTypeCode"));
					update("item_SQL.updateItemAttr", setMap);
				}
			}
		}
	}

}
