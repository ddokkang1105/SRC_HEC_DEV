package xbolt.mdl.mdItm.sevice;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonService;
import xbolt.cmm.service.CommonDataServiceImpl;


@Service("mdItemService")
@SuppressWarnings("unchecked")
public class ModelItemServiceImpl extends CommonDataServiceImpl implements CommonService{
	
	@Override
	public void save(Map map) throws Exception{
		String gubun = (String)map.get("GUBUN");
		if("insert".equals(gubun)){
			String modelID = StringUtil.checkNull(selectString("model_SQL.getMaxModelIDString", map));
			map.put("ModelID", modelID);
			String modelXML = StringUtil.checkNull(map.get("modelXML"));
			if(!modelXML.equals("")){
				modelXML = replaceModelXML(map);	
				map.put("modelXML", modelXML);
			}
			
			insert("model_SQL.insertModel", map);
			
			List getLanguageList = selectList("common_SQL.langType_commonSelect", map);			
			for(int i = 0; i < getLanguageList.size(); i++){
				Map getMap = (HashMap)getLanguageList.get(i);
				map.put("LanguageID", getMap.get("CODE") );				
				insert("model_SQL.insertModelAttr", map);
			}
		} 
		else if("update".equals(gubun)){
			update("model_SQL.updateModelMTCategory", map);
			update("model_SQL.updateModelTxt", map);
			
		}else if("copy".equals(gubun)){
			String newModelID = selectString("model_SQL.getMaxModelIDString", map).toString();
			String curChangeSetID = StringUtil.checkNull(selectString("model_SQL.getCurChangeSetID", map));
			map.put("newModelID", newModelID);
			map.put("changeSetID", curChangeSetID);
			insert("model_SQL.copyModel", map);			
			List getElementList = selectList("model_SQL.getCpElementList", map);	
			List getLanguageList = selectList("common_SQL.langType_commonSelect", map);	
			
			for(int i = 0; i < getLanguageList.size(); i++){
				Map getMap = (HashMap)getLanguageList.get(i);
				map.put("LanguageID", getMap.get("CODE") );				
				insert("model_SQL.copyModelTxt", map);
			}

			for(int i=0; i< getElementList.size(); i++){		
				Map getMap = (HashMap)getElementList.get(i);
				map.put("orgElementID", getMap.get("ElementID"));
				if(StringUtil.checkNull(getMap.get("CategoryCode")).equals("MCN")){
					map.put("includeItemMaster", "N");
				}else{
					map.put("includeItemMaster", "Y");
				}
				
				insert("model_SQL.copyModelElement", map);	
			}			
		}else if("insertModelTxt".equals(gubun)){ 
			update("model_SQL.updateModelMTCategory", map);
			insert("model_SQL.insertModelAttr", map);
		
		}else if("ref".equals(gubun)){
			
			String newModelID = StringUtil.checkNull(selectString("model_SQL.getMaxModelIDString", map));
			String curChangeSetID = StringUtil.checkNull(selectString("model_SQL.getCurChangeSetID", map));
			
			map.put("newModelID", newModelID);
			map.put("changeSetID", curChangeSetID);
			map.put("ModelID", newModelID);
			
			insert("model_SQL.insertRefModel", map);			
			List getElementList = selectList("model_SQL.getCpElementList", map);	
			List getLanguageList = selectList("common_SQL.langType_commonSelect", map);	
			
			for(int i = 0; i < getLanguageList.size(); i++){
				Map getMap = (HashMap)getLanguageList.get(i);
				map.put("LanguageID", getMap.get("CODE") );				
				insert("model_SQL.insertRefModelTxt", map);
			}
			
			String checkElmts = map.get("checkElmts").toString(); 
			String arrElmts[] = checkElmts.split(",");
			for(int i=0; i< getElementList.size(); i++){		
				Map getMap = (HashMap)getElementList.get(i);
				
				for(int j=0; j<arrElmts.length; j++){
					if(arrElmts[j].equals(getMap.get("ElementID").toString() )){
						map.put("includeItemMaster", "Y");
					}
				}
				
				map.put("orgElementID", getMap.get("ElementID"));
				insert("model_SQL.copyModelElement", map);	
				map.remove("includeItemMaster");
			}	
			
			
			// NewModel의  Element Link = '' , CategoryCode = 'OJ' -> link 신규생성, 원본 Model.ItemID의 child = refLink -> ST1 생성
			String copyItemMasterYN  = StringUtil.checkNull(map.get("copyItemMasterYN"));
			if(copyItemMasterYN.equals("Y")) {
				createElmItemMaster(map);
			}
						
		}else if("insertArisModel".equals(gubun)){  //item_occ 참조 모델 생성
			
			String creator = StringUtil.checkNull(map.get("sessionUserId"));
			String LanguageID = StringUtil.checkNull(map.get("LanguageID"));
			String defFontFamily = StringUtil.checkNull(map.get("defFontFamily"),"");
			String defFontStyle = StringUtil.checkNull(map.get("defFontStyle"),"");
			String defFontSize = StringUtil.checkNull(map.get("defFontSize"),"");	
			String defFontColor = StringUtil.checkNull(map.get("defFontColor"),"");
			String orgModelID = StringUtil.checkNull(map.get("orgModelID"),"");
			
			
			String newModelID = selectString("model_SQL.getMaxModelIDString", map).toString();
			map.put("newModelID", newModelID);
			map.put("newModelTypeCode", "MT001");
			map.put("newMTCTypeCode", "BAS");
			map.put("Creator", creator);
			map.put("orgModelID", orgModelID);
			map.put("Status", "REL");
			
			insert("model_SQL.insertArisModel", map);
			
			// ModelTXT생성
			List getLanguageList = selectList("common_SQL.langType_commonSelect", map);	
			for(int i = 0; i < getLanguageList.size(); i++){
				Map getMap = (HashMap)getLanguageList.get(i);
				map.put("LanguageID", getMap.get("CODE") );				
				insert("model_SQL.insertArisModelTxt", map);
			}
			
			// Role Item생성
			Map setData = new HashMap();
			String maxItemID = StringUtil.checkNull(selectString("model_SQL.getMaxItemIDNew", map),"1");
			Map roleSymType = new HashMap();
			setData.put("SymTypeCode", "SB00001");
			roleSymType = select("model_SQL.getSymTypeWithSymCode", setData);
			
			Map insertData = new HashMap();
			insertData.put("ItemID", maxItemID);
			insertData.put("AuthorID", creator);
			insertData.put("Creator", creator);
			insertData.put("ItemStatus", "NEW1");
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
			}
			else {
				insertData.put("ItemTypeCode", "OJ00002");
				insertData.put("ClassCode", "CL02003");
				insertData.put("DefSymCode", "SB00001");
				insertData.put("CategoryCode", "MOJ");
			}
			
			insert("model_SQL.insertItemNew", insertData);
			
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
			// Role Element생성
			int rolElementID = Integer.parseInt(newModelID)+2;
			int rolParentID = Integer.parseInt(newModelID)+1;
			
			List getItemOccList = selectList("model_SQL.getItemOccList", map);
			
			Map rolPositionMap = new HashMap();
			setData.put("orgModelID", orgModelID);
			rolPositionMap = select("model_SQL.getItemOccPosition", setData);	
			
			int Height =   Integer.parseInt(rolPositionMap.get("MaxPositionY").toString())+30; 
			insertData.put("ModelID", newModelID);
			insertData.put("Link", maxItemID);
			insertData.put("Deleted", "0");
			insertData.put("PositionX", "20");
			insertData.put("PositionY", "20");
			insertData.put("Width", rolPositionMap.get("MaxPositionX"));
			insertData.put("Height",  Height);
			insertData.put("StartSize", "38");
			insertData.put("ElementID", rolElementID);
			insertData.put("Parent", rolParentID);
			insertData.put("LastUser", creator);
			
			insert("model_SQL.insertElement", insertData); // Role Element 생성
			
			// Item 별 Element 생성
			Map insertElementData = new HashMap();			
			insertElementData.put("Creator", creator);
			insertElementData.put("Status", "NEW1");
			Map eleSymType = new HashMap();
			int j = 1;
			int ElementID;
			
			int PositionY = 100;
			String SymTypeCode;
			for(int i=0; i< getItemOccList.size(); i++){		
				Map getMap = (HashMap)getItemOccList.get(i);
				/* // TB_Symbol_Type ArisTypeNum 입력  
				 * if(getMap.get("SymbolNum").toString().equals("66514")){ SymTypeCode = "SB00004";
				}else if(getMap.get("SymbolNum").toString().equals("131407")){	SymTypeCode = "SB00007";
				}else if(getMap.get("SymbolNum").toString().equals("196943")){	SymTypeCode = "SB00005";
				}else if(getMap.get("SymbolNum").toString().equals("829")){ SymTypeCode = "SB00006";
				}else if(getMap.get("SymbolNum").toString().equals("196609")){ SymTypeCode = "SB00002";// Event
				}else if(getMap.get("SymbolNum").toString().equals("44")){ SymTypeCode = "SB00010"; // OR
				}else if(getMap.get("SymbolNum").toString().equals("42")){ SymTypeCode = "SB00009"; // AND
				}else if(getMap.get("SymbolNum").toString().equals("65580")){ SymTypeCode = "SB00008"; // Branch
				}else{SymTypeCode = "SB00007"; }*/
				
				SymTypeCode = getMap.get("SymTypeCode").toString();
				setData.put("SymTypeCode", SymTypeCode);
				eleSymType = select("model_SQL.getSymTypeWithSymCode", setData);
				
				if(eleSymType != null && eleSymType.size() != 0) {				
					if(eleSymType.get("DefColor") != null){insertElementData.put("FillColor", eleSymType.get("DefColor"));}
					if(eleSymType.get("DefStrokeColor") != null){insertElementData.put("StrokeColor", eleSymType.get("DefStrokeColor"));}
					if(eleSymType.get("ImagePath") != null){insertElementData.put("Style", eleSymType.get("ImagePath"));}
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
				insertElementData.put("SymTypeCode", SymTypeCode);
				insertElementData.put("ObjectID", getMap.get("ObjectID"));
				insertElementData.put("ModelID", newModelID);
				insertElementData.put("Link", getMap.get("ObjectID"));
				insertElementData.put("Deleted", "0");
				insertElementData.put("PositionX", getMap.get("PositionX"));
				insertElementData.put("PositionY", getMap.get("PositionY"));
				insertElementData.put("ElementID", ElementID);
				insertElementData.put("Parent", rolElementID);
				insertElementData.put("LinkType", getMap.get("LinkType"));
				insertElementData.put("CategoryCode", getMap.get("CategoryCode"));
				insertElementData.put("ItemTypeCode", getMap.get("ItemTypeCode"));
				insertElementData.put("ClassCode", getMap.get("ClassCode"));
				insertElementData.put("Width", eleSymType.get("DefWidth"));
				insertElementData.put("Height", eleSymType.get("DefHeight"));				
				insertElementData.put("MinPositionY", rolPositionMap.get("MinPositionY"));
				
				insert("model_SQL.insertOccElement", insertElementData); // item별 Element 생성
				j++;
			}		
		}else if("combineModelElement".equals(gubun)){  
			String newModelID = selectString("model_SQL.getMaxModelIDString", map).toString();
			map.put("newModelID", newModelID);
			
			insert("model_SQL.copyModel", map);			
			List getElementList = selectList("model_SQL.getElementsToCombine", map);	
			List getLanguageList = selectList("common_SQL.langType_commonSelect", map);	
			
			for(int i = 0; i < getLanguageList.size(); i++){
				Map getMap = (HashMap)getLanguageList.get(i);
				map.put("LanguageID", getMap.get("CODE") );				
				insert("model_SQL.copyModelTxt", map);
			}
			map.put("includeItemMaster", "Y");
			
			// 첫번째 모델 
			for(int i=0; i< getElementList.size(); i++){		
				Map getMap = (HashMap)getElementList.get(i);
				map.put("orgElementID", getMap.get("ElementID"));
				map.put("orgModelID", getMap.get("ModelID"));
				insert("model_SQL.copyModelElement", map);
				
			}
			String objectList = map.get("objectList").toString();
			String arrObjList[] = objectList.split(",");
						
			Map setMapComb = new HashMap();
			setMapComb.put("newModelID",newModelID);
			
			List getElementListComb =  new ArrayList();
			
			for(int i=1; i< arrObjList.length; i++){
				map.put("itemIDCom", arrObjList[i].replaceAll("]", ""));
				getElementListComb = selectList("model_SQL.getElementListToCombineMdl", map);
				
				Map getMaxVal = select("model_SQL.getMaxElementSFromNewModel",setMapComb); // MAX ElementID, MAX PositionY
				setMapComb.remove("maxElementID");
				setMapComb.remove("maxPositionY");
				setMapComb.put("maxElementID", getMaxVal.get("maxElementID"));
				setMapComb.put("maxPositionY", getMaxVal.get("maxPositionY"));
				setMapComb.put("LastUser", map.get("Creator"));
				for(int j=0; j< getElementListComb.size(); j++){		
					Map getMap = (HashMap)getElementListComb.get(j);
					setMapComb.put("orgElementID", getMap.get("ElementID"));
					setMapComb.put("orgModelID", getMap.get("ModelID"));
					
					insert("model_SQL.insertCombineModelElement", setMapComb);
					
				}
			}
		}
		else  if("insertDiagram".equals(gubun)){			
			String diagramID = StringUtil.checkNull(selectString("model_SQL.getMaxDiagramID", map));
			map.put("diagramID", diagramID);
			String modelXML = StringUtil.checkNull(map.get("modelXML"));
			/*
			 * if(!modelXML.equals("")){ map.put("ModelID", diagramID); modelXML =
			 * replaceModelXML(map); map.put("modelXML", modelXML); }
			 */
			
			insert("model_SQL.insertDiagram", map);
		} 
	}
	
	public void createElmItemMaster(Map paramMap) throws Exception {
		Map setData = new HashMap();
		Map insertData = new HashMap();
		
		String languageID = StringUtil.checkNull(paramMap.get("languageID"));
		String userID = StringUtil.checkNull(paramMap.get("Creator"));
		
		setData.put("modelID", paramMap.get("newModelID"));
		setData.put("itemID", paramMap.get("orgItemID"));		
		List newModelElementList = selectList("model_SQL.getElementListWOLink", setData);
	//	 getElementListWithChildItem
		for(int i=0; i<newModelElementList.size(); i++) {
			Map elmInfo = (Map)newModelElementList.get(i);
			
			String newModelID = StringUtil.checkNull(elmInfo.get("ModelID"));			
			String elementID = StringUtil.checkNull(elmInfo.get("ElementID"));
			String objectID = StringUtil.checkNull(elmInfo.get("ObjectID"));
			
			setData.put("ItemID", objectID);
			setData.put("languageID", languageID);
			Map itemInfo = select("model_SQL.getItemInfoByItemID", setData);
			
			if(!itemInfo.isEmpty() && itemInfo.size() != 0) {
				String newItemID = StringUtil.checkNull(selectString("model_SQL.getMaxItemIDNew", setData),"");		
				String classCode = StringUtil.checkNull(itemInfo.get("ClassCode"));
				setData.put("itemClassCode",  classCode);
				Map itemClassInfo = select("item_SQL.getClassOption", setData);
				
				String autoID = StringUtil.checkNull(itemClassInfo.get("AutoID"));
				String preFix = StringUtil.checkNull(itemClassInfo.get("PreFix"));
				String identifier = "";
				String idLength = "";
				
				if(autoID.equals("Y")){
					setData.put("preFix", preFix);
					identifier = StringUtil.checkNull(selectString("item_SQL.getMaxPreFixIdentifier", setData));
					for(int k=0; 5-identifier.length() > k; k++){
						idLength = idLength + "0";
					}
					if(identifier.equals("")){
						identifier = preFix + "00001";
					}else{
						identifier = preFix + idLength + identifier;
					}
					
					insertData.put("identifier", identifier);
				}
		
				insertData.put("ItemID", newItemID);
				insertData.put("CategoryCode", StringUtil.checkNull(itemInfo.get("CategoryCode")));
				insertData.put("ItemTypeCode", StringUtil.checkNull(itemInfo.get("ItemTypeCode")));
				insertData.put("ClassCode", StringUtil.checkNull(itemInfo.get("ClassCode")));
				insertData.put("FromItemID", "");	
				insertData.put("ToItemID", "");	
				insertData.put("DefSymCode", StringUtil.checkNull(itemInfo.get("DefSymCode")));
				
				insertData.put("AuthorID", userID);
				insertData.put("ItemStatus", "NEW1");
				insertData.put("Creator", userID);
				insertData.put("LastUser", userID);
				insertData.put("projectID", paramMap.get("projectID"));
				insertData.put("curChangeSet", paramMap.get("changeSetID"));
				insertData.put("ownerTeamID", paramMap.get("ownerTeamID"));
				insertData.put("refItemID", StringUtil.checkNull(elmInfo.get("RefLink")));
				
				insert("model_SQL.insertItemNew", insertData);
				
				// TB_Element 에 newItemID -> link, objectID update
				insertData.put("modelID", newModelID);
				insertData.put("elementID", elementID);					
				insertData.put("objectID", newItemID);
				insertData.put("link", newItemID);
				
				update("model_SQL.updateElementObject", insertData);
				
				// 기존 link TB_Item_Attr 전체 복사 			
				insertData.put("itemID", objectID);
				insertData.put("newItemID", newItemID);
				insertData.put("userID", userID);
				update("item_SQL.copyItemAttrAll", insertData);
				
				
				//refLink = 원본 model.Item 의 child ==> ST1 생성
				String childItemID = StringUtil.checkNull(elmInfo.get("RefLink"));
				if(!childItemID.equals("")) {
					insertData = new HashMap();
					setData.put("s_itemID", newItemID);
					String itemTypeCode = selectString("item_SQL.selectedConItemTypeCode", setData);
				
					String maxItemID = StringUtil.checkNull(selectString("model_SQL.getMaxItemIDNew", setData),"1");
					insertData.put("ItemID", maxItemID); 
					insertData.put("FromItemID", paramMap.get("itemID"));
					insertData.put("ToItemID", newItemID);
					insertData.put("CategoryCode", "ST1");
					insertData.put("ItemTypeCode", itemTypeCode);
					insertData.put("ClassCode", "NL00000");	
					insertData.put("ItemStatus", "NEW1");	
					insertData.put("ownerTeamID", paramMap.get("ownerTeamID"));
					insertData.put("LastUser", userID); 
					insertData.put("AuthorID", userID);
					insertData.put("Creator", userID);
					insertData.put("projectID", paramMap.get("projectID"));
					insertData.put("curChangeSet", paramMap.get("changeSetID"));
					
					insert("model_SQL.insertItemNew", insertData);
				}
			}
		}
	}
	
	@Override
	public void delete(Map map) throws Exception{
			map.put("ModelIDS", map.get("ModelIDS"));
			delete("model_SQL.delElementS",map);
			delete("model_SQL.delModelTxtS",map);
			delete("model_SQL.delModelS",map);
			
	}
	
	public String replaceModelXML(Map map) throws Exception{
		String modelXML = StringUtil.checkNull(map.get("modelXML"));	
		String modelID = StringUtil.checkNull(map.get("ModelID"));
		
		int modelIDInteger = Integer.parseInt(modelID);		
		int mxcellCnt = getmxcelCount(modelXML);
		
		for(int i=0; mxcellCnt>i; i++) {
			modelXML = modelXML.replaceAll(" id=\""+i+"\"", " id=\""+StringUtil.checkNull(modelIDInteger+i) +"\""); 
			modelXML = modelXML.replaceAll(" parent=\""+i+"\"", " parent=\""+StringUtil.checkNull(modelIDInteger+i) +"\""); 
			modelXML = modelXML.replaceAll(" source=\""+i+"\"", " source=\""+StringUtil.checkNull(modelIDInteger+i) +"\""); 
			modelXML = modelXML.replaceAll(" target=\""+i+"\"", " target=\""+StringUtil.checkNull(modelIDInteger+i) +"\""); 
			
			//System.out.println("id=\""+i+"\""+":::::>>> "+ StringUtil.checkNull(modelIDInteger+i)); 
		}		
		return modelXML;
	}
	
	public int getmxcelCount(String modelXML){
		int startIndex	= modelXML.indexOf("<");		
		int mxCellCount = 0;
		do {
			int endIndex 		= modelXML.indexOf(">", startIndex) + 1;			
			String currLine = modelXML.substring(startIndex, endIndex);			
			int startMXTypeIndex	= currLine.indexOf("<") + 1;
			int endMXTypeIndex 		= currLine.indexOf(" ", startMXTypeIndex);
			if(endMXTypeIndex == -1) {endMXTypeIndex = currLine.indexOf(">", startMXTypeIndex);}
			
			String MXType = currLine.substring(startMXTypeIndex, endMXTypeIndex);			
			if (MXType.equals("mxCell")) {
				mxCellCount = mxCellCount + 1;
			}
			startIndex	= modelXML.indexOf("<", endIndex);
			
		} while(startIndex != -1);		
		// System.out.println("mxCell CNT  :"+mxCellCount);
		return mxCellCount;
	}	
}
