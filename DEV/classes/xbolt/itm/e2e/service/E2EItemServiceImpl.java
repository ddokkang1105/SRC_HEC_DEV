package xbolt.itm.e2e.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonDataServiceImpl;
import xbolt.cmm.service.CommonService;


@Service("e2eItemService")
@SuppressWarnings("unchecked")
public class E2EItemServiceImpl extends CommonDataServiceImpl implements CommonService{

	@Override
	public void save(Map map) throws Exception{
		String gubun = (String)map.get("GUBUN");
		
		if("insertE2eModel".equals(gubun)){
			String ItemID = StringUtil.checkNull(map.get("ItemID"));
			String e2eItemIDS = StringUtil.checkNull(map.get("e2eItemIDS"));
			String newModelName = StringUtil.checkNull(map.get("newModelName"),"");
			String MTCTypeCode = StringUtil.checkNull(map.get("MTCTypeCode"),"");
			String ModelTypeCode = StringUtil.checkNull(map.get("ModelTypeCode"),"");
			
			String creator = StringUtil.checkNull(map.get("sessionUserId"));
			String LanguageID = StringUtil.checkNull(map.get("LanguageID"));
			String defFontFamily = StringUtil.checkNull(map.get("defFontFamily"),"");	
			String defFontSize = StringUtil.checkNull(map.get("defFontSize"),"");	
			String defFontColor = StringUtil.checkNull(map.get("defFontColor"),"");	
			String defFontStyle = StringUtil.checkNull(map.get("defFontStyle"),"");	
			
			insert("model_SQL.updateDefSymTypeCode", map);  //default symbol update procedure 
			
			// 모델 생성
			Map setData = new HashMap();
			String newModelID = selectString("model_SQL.getMaxModelIDString", map).toString();
			map.put("ModelID", newModelID);
			setData.put("ModelID", newModelID);
			setData.put("ItemID", ItemID);
			setData.put("ModelTypeCode", ModelTypeCode);
			setData.put("MTCategory", MTCTypeCode);
			setData.put("Creator", creator);
			setData.put("Deleted", "0");
			setData.put("Status", "REL");
			setData.put("Blocked", "0");
			setData.put("ModelName", newModelName);
			setData.put("LanguageID", LanguageID);
			insert("model_SQL.insertModel", setData);
			insert("model_SQL.insertRefModelTxt", setData);
			
			// Role item 생성 
			String maxItemID = StringUtil.checkNull(selectString("model_SQL.getMaxItemIDNew", setData),"1");
			Map roleSymType = new HashMap();
			setData.put("SymTypeCode", "SB00001");
			roleSymType = select("model_SQL.getSymTypeWithSymCode", setData);
			
			Map insertData = new HashMap();
			insertData.put("ItemID", maxItemID);
			insertData.put("Creator", creator);
			insertData.put("Status", "NEW1");
			insertData.put("LanguageID", LanguageID);
			
			if(roleSymType != null && roleSymType.size() != 0) {
				if(roleSymType.get("ItemTypeCode") != null){insertData.put("ItemTypeCode", roleSymType.get("ItemTypeCode"));}
				if(roleSymType.get("SymTypeCode") != null){
					insertData.put("DefSymCode", roleSymType.get("SymTypeCode"));
					insertData.put("SymTypeCode", roleSymType.get("SymTypeCode")); }
				if(roleSymType.get("ClassCode") != null){insertData.put("ClassCode", roleSymType.get("ClassCode"));}
				if(roleSymType.get("ItemCategory") != null){
					insertData.put("CategoryCode", roleSymType.get("ItemCategory"));
					insertData.put("ItemCategory", roleSymType.get("ItemCategory"));
				}
				if(roleSymType.get("ImagePath") != null){insertData.put("Style", roleSymType.get("ImagePath"));}
				if(roleSymType.get("DefColor") != null){insertData.put("FillColor", roleSymType.get("DefColor"));}
				if(roleSymType.get("DefGradientColor") != null){insertData.put("GradientColor", roleSymType.get("DefGradientColor"));}
			}
			else {
				insertData.put("ItemTypeCode", "OJ00002");
				insertData.put("ClassCode", "CL02003");
				insertData.put("DefSymCode", "SB00001");
				insertData.put("CategoryCode", "MOJ");
			}
		
			insert("model_SQL.insertItemNew", insertData);
			List getLanguageList = selectList("common_SQL.langType_commonSelect", map);	
			
			insertData.put("PlainText", "ROLE");
			insertData.put("AttrTypeCode", "AT00001");
			insertData.put("FontFamily", defFontFamily);
			insertData.put("FontStyle", defFontStyle);
			insertData.put("FontSize", defFontSize);
			insertData.put("FontColor", defFontColor);
			
			for(int i = 0; i < getLanguageList.size(); i++){
				Map getMap = (HashMap)getLanguageList.get(i);
				insertData.put("languageID", getMap.get("CODE") );				
				insert("model_SQL.insertItemAttr", insertData);
			}
			
			String[] e2eItemIDSArr = e2eItemIDS.split(",");
			
			int rolElementID = Integer.parseInt(newModelID)+2;
			int rolParentID = Integer.parseInt(newModelID)+1;
			
			int Height = (90 * e2eItemIDSArr.length) +200;
			insertData.put("ModelID", newModelID);
			insertData.put("Link", maxItemID);
			insertData.put("Deleted", "0");
			insertData.put("PositionX", "20");
			insertData.put("PositionY", "20");
			insertData.put("Width", "360");
			insertData.put("Height", Height);
			insertData.put("FontSize", defFontSize);
			insertData.put("FontStyle", "1");
			insertData.put("FontFamily", defFontFamily);
			insertData.put("StartSize", "38");
			insertData.put("ElementID", rolElementID);
			insertData.put("Parent", rolParentID);
			insertData.put("ElementID", rolElementID);
			insertData.put("LastUser", creator);
			insert("model_SQL.insertElement", insertData); // Role Element 생성 
			
			// Item 별 Element 생성
			Map insertElementData = new HashMap();			
			insertElementData.put("Creator", creator);
			insertElementData.put("Status", "NEW1");
			Map eleSymType = new HashMap();
			int j = 1;
			int ElementID;
			
			Map defSymCodeMap = new HashMap();
		    setData.put("e2eItemIDS", e2eItemIDS);
			List defSymCodeList = selectList("model_SQL.getItemDefSymCode",setData);
		
			int PositionY = 100;
			String defSymTypeCodeClass = "";
			for (int i = 0; e2eItemIDSArr.length > i; i++ ) { 
				defSymCodeMap = (HashMap)defSymCodeList.get(i);		
				defSymTypeCodeClass = StringUtil.checkNull(defSymCodeMap.get("DefSymCodeClass"),"SB00007");
				if(defSymCodeMap.get("DefSymCode").toString().length() == 0){
					setData.put("SymTypeCode", defSymTypeCodeClass);
				}else{
					setData.put("SymTypeCode", defSymCodeMap.get("DefSymCode"));
				}
				eleSymType = select("model_SQL.getSymTypeWithSymCode", setData);
				
				if(eleSymType == null || eleSymType.size() == 0){
					setData.put("SymTypeCode", "SB00007");
					eleSymType = select("model_SQL.getSymTypeWithSymCode", setData);
				}
								
				if(eleSymType != null && eleSymType.size() != 0) {
					if(eleSymType.get("ItemTypeCode") != null){insertElementData.put("ItemTypeCode", eleSymType.get("ItemTypeCode"));}
					if(eleSymType.get("SymTypeCode") != null){insertElementData.put("SymTypeCode", eleSymType.get("SymTypeCode"));}
					if(eleSymType.get("ClassCode") != null){insertElementData.put("ClassCode", eleSymType.get("ClassCode"));}
					if(eleSymType.get("ItemCategory") != null){insertElementData.put("CategoryCode", eleSymType.get("ItemCategory"));}
					if(eleSymType.get("ImagePath") != null){insertElementData.put("Style", eleSymType.get("ImagePath"));}
					if(eleSymType.get("DefColor") != null){insertElementData.put("FillColor", eleSymType.get("DefColor"));}
					if(eleSymType.get("DefWidth") != null){insertElementData.put("Width", eleSymType.get("DefWidth"));}
					if(eleSymType.get("DefHeight") != null){insertElementData.put("Height", eleSymType.get("DefHeight"));}
					if(eleSymType.get("DefStrokeColor") != null){insertElementData.put("StrokeColor", eleSymType.get("DefStrokeColor"));}
					if(eleSymType.get("DefGradientColor") != null){insertElementData.put("GradientColor", eleSymType.get("DefGradientColor"));}
					if(eleSymType.get("DefShadow") != null){insertElementData.put("Shadow", eleSymType.get("DefShadow"));}
					
					if(eleSymType.get("SymTypeCode").toString().equals("SB00006") || eleSymType.get("SymTypeCode").toString().equals("SB00015") || eleSymType.get("SymTypeCode").toString().equals("SB00016")){
						insertElementData.put("SpacingTop", "-50");
						insertElementData.put("LabelBackgroundColor", "none");
					}else{
						insertElementData.put("SpacingTop", null);
						insertElementData.put("LabelBackgroundColor", null);
					}
				}
				
				ElementID = rolElementID + j;
				insertElementData.put("ItemID", e2eItemIDSArr[i]);
				insertElementData.put("ModelID", newModelID);
				insertElementData.put("Link", e2eItemIDSArr[i]);
				insertElementData.put("Deleted", "0");
				insertElementData.put("PositionX", "125");
				insertElementData.put("PositionY", PositionY);
				insertElementData.put("FontSize", defFontSize);
				insertElementData.put("FontStyle", "1");
				insertElementData.put("FontFamily", defFontFamily);
				insertElementData.put("ElementID", ElementID);
				insertElementData.put("Parent", rolElementID);
				insertElementData.put("LastUser", creator);
				insert("model_SQL.insertElement", insertElementData); // item별 Element 생성
				PositionY = PositionY + 100;
				j++;
			}
		}
		if("addObjectToDiagram".equals(gubun)){
			
			String ItemID = StringUtil.checkNull(map.get("ItemID"));
			String e2eItemIDS = StringUtil.checkNull(map.get("e2eItemIDS"));
			String modelID = StringUtil.checkNull(map.get("modelID"));
			String positionX = StringUtil.checkNull(map.get("positionX"));
			String positionY = StringUtil.checkNull(map.get("positionY"));
						
			String creator = StringUtil.checkNull(map.get("sessionUserId"));
			String LanguageID = StringUtil.checkNull(map.get("LanguageID"));
			String defFontFamily = StringUtil.checkNull(map.get("defFontFamily"),"");	
			String defFontSize = StringUtil.checkNull(map.get("defFontSize"),"");	
			String defFontColor = StringUtil.checkNull(map.get("defFontColor"),"");	
			String defFontStyle = StringUtil.checkNull(map.get("defFontStyle"),"");	
			String itemTypeCode = StringUtil.checkNull(map.get("itemTypeCode"));
			
			String[] e2eItemIDSArr = e2eItemIDS.split(",");
			
			insert("model_SQL.updateDefSymTypeCode", map);  //default symbol update procedure 
			
			Map insertElementData = new HashMap();			
			insertElementData.put("Creator", creator);
			insertElementData.put("Status", "NEW1");
			Map eleSymType = new HashMap();
			String ElementID;
			int parentID = Integer.parseInt(modelID)+1;
			
			Map setData = new HashMap();
			Map defSymCodeMap = new HashMap();
		    setData.put("e2eItemIDS", e2eItemIDS);
			List defSymCodeList = selectList("model_SQL.getItemDefSymCode",setData);
			
			int PositionY =  Integer.parseInt(positionY);
			String defSymTypeCodeClass = "";
			String defSymTypeCodeItemType = "";
			for (int i = 0; e2eItemIDSArr.length > i; i++ ) { 
				defSymCodeMap = (HashMap)defSymCodeList.get(i);		
				defSymTypeCodeClass = StringUtil.checkNull(defSymCodeMap.get("DefSymCodeClass"),"SB00007");
				defSymTypeCodeItemType = StringUtil.checkNull(selectString("model_SQL.getSymTypeCodeItemType", map));
				if(StringUtil.checkNull(defSymCodeMap.get("DefSymCode"),"").equals("")){
					if(defSymTypeCodeClass.equals("")){
						setData.put("SymTypeCode", defSymTypeCodeItemType);
					}else{
						setData.put("SymTypeCode", defSymTypeCodeClass);
					}
				}else{
					setData.put("SymTypeCode", StringUtil.checkNull(defSymCodeMap.get("DefSymCode"),""));
				}
				eleSymType = select("model_SQL.getSymTypeWithSymCode", setData);
				
				/*if(eleSymType == null || eleSymType.size() == 0){
					setData.put("SymTypeCode", "SB00007");
					eleSymType = select("model_SQL.getSymTypeWithSymCode", setData);
				}*/
								
				if(eleSymType != null && eleSymType.size() != 0) {
					if(eleSymType.get("ItemTypeCode") != null){insertElementData.put("ItemTypeCode", eleSymType.get("ItemTypeCode"));}
					if(eleSymType.get("SymTypeCode") != null){insertElementData.put("SymTypeCode", eleSymType.get("SymTypeCode"));}
					if(eleSymType.get("ClassCode") != null){insertElementData.put("ClassCode", eleSymType.get("ClassCode"));}
					if(eleSymType.get("ItemCategory") != null){insertElementData.put("CategoryCode", eleSymType.get("ItemCategory"));}
					if(eleSymType.get("ImagePath") != null){insertElementData.put("Style", eleSymType.get("ImagePath"));}
					if(eleSymType.get("DefFontColor") != null){insertElementData.put("FontColor", eleSymType.get("DefFontColor"));}
					if(eleSymType.get("DefFillColor") != null){insertElementData.put("FillColor", eleSymType.get("DefFillColor"));}
					if(eleSymType.get("DefWidth") != null){insertElementData.put("Width", eleSymType.get("DefWidth"));}
					if(eleSymType.get("DefHeight") != null){insertElementData.put("Height", eleSymType.get("DefHeight"));}
					if(eleSymType.get("DefStrokeColor") != null){insertElementData.put("StrokeColor", eleSymType.get("DefStrokeColor"));}
					if(eleSymType.get("DefGradientColor") != null){insertElementData.put("GradientColor", eleSymType.get("DefGradientColor"));}
					if(eleSymType.get("DefShadow") != null){insertElementData.put("Shadow", eleSymType.get("DefShadow"));}
					
					if(eleSymType.get("SymTypeCode").toString().equals("SB00006") || eleSymType.get("SymTypeCode").toString().equals("SB00015") || eleSymType.get("SymTypeCode").toString().equals("SB00016")){
						insertElementData.put("SpacingTop", "-50");
						insertElementData.put("LabelBackgroundColor", "none");
					}else{
						insertElementData.put("SpacingTop", null);
						insertElementData.put("LabelBackgroundColor", null);
					}
				}
				
				ElementID = selectString("model_SQL.getMaxElementID",setData); 
				insertElementData.put("ItemID", e2eItemIDSArr[i]);
				insertElementData.put("ModelID", modelID);
				insertElementData.put("Link", e2eItemIDSArr[i]);
				insertElementData.put("Deleted", "0");
				insertElementData.put("PositionX", positionX);
				insertElementData.put("PositionY", PositionY);
				insertElementData.put("FontSize", defFontSize);
				insertElementData.put("FontStyle", "1");
				insertElementData.put("FontFamily", defFontFamily);
				insertElementData.put("ElementID", ElementID);
				insertElementData.put("Parent", parentID);
				insertElementData.put("LastUser", creator);
				
				insert("model_SQL.insertElement", insertElementData); // item별 Element 생성
				PositionY = PositionY + 100;
			}
			
		}
	}

}