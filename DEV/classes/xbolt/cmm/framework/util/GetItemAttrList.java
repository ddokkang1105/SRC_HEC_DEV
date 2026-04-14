package xbolt.cmm.framework.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import xbolt.cmm.service.CommonService;

/**
 * 공통 서블릿 처리
 * @Class Name : GetItemAttrList.java
 * @Description : ITEM, ITEM_ATTR(각 속성에 따른 언어 설정(IsComLang)에 따른 data 취득) 관련 함수 
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2014. 07. 03. smartfactory		최초생성
 *
 * @since 2014. 07. 03.
 * @version 1.0
 * @see
 * 
 * Copyright (C) 2013 by SMARTFACTORY All right reserved.
 */
@SuppressWarnings("unused")
public class GetItemAttrList {
	
	
	public static List getItemAttrList(CommonService commonService, List itemAttrAllList, Map<String, Object> cmdMap, String loginLangType) throws ExceptionUtil {
		
		List returnData = itemAttrAllList;
		Map<String, Object> setMap = cmdMap;
		Map setData = new HashMap();
		List mLovList = new ArrayList();
		String mLovValue = "";
			try {
			// isComLang = 1
			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
			setMap.put("languageID", defaultLang);
			setMap.put("loginLangType", loginLangType);
			setMap.put("IsComLang", "1");
			List comLangList = (List)commonService.selectList("attr_SQL.getItemAttr", setMap);
			
			for (int i = 0; i < returnData.size(); i++) {
				Map allMap = (Map) returnData.get(i);
				String removeAttrCode = String.valueOf(allMap.get("AttrTypeCode"));
				
				String dataType = String.valueOf(allMap.get("DataType"));
				String isComLang = String.valueOf(allMap.get("IsComLang"));
				
				// isComLang = 1인 Item Attr 은  default언어로 취득한 data로 치환
				for (int j = 0; j < comLangList.size(); j++) {
					Map comLangMap = (Map) comLangList.get(j);
					String addAttrCode = String.valueOf(comLangMap.get("AttrTypeCode"));
				
					if (addAttrCode.equals(removeAttrCode)) {
						returnData.remove(i);
						returnData.add(i, comLangMap);
					}
				}
				
				// isComLang = 1이고, DataType = LOV인 Item Attr 은 TB_ITEM_ATTR 취득시만,  default언어설정 해서 값 치환
				if ("LOV".equals(dataType) && "1".equals(isComLang)) {
					setMap.put("languageID", loginLangType);
					setMap.put("defaultLang", defaultLang);
					setMap.put("IsComLang", "0");
					setMap.put("AttrTypeCode", removeAttrCode);
					List lovList = (List)commonService.selectList("attr_SQL.getItemAttr", setMap);
					
					for (int k = 0; k < lovList.size(); k++) {
						Map lovMap = (Map) lovList.get(k);
						String addAttrCode = String.valueOf(lovMap.get("AttrTypeCode"));
					
						if (addAttrCode.equals(removeAttrCode)) {
							returnData.remove(i);
							returnData.add(i, lovMap);
						}
					}
				}
				
				if ("MLOV".equals(dataType)) {
					setData.put("s_itemID",allMap.get("AttrTypeCode"));
					setData.put("languageID", loginLangType);
					mLovList = commonService.selectList("attr_SQL.selectAttrLovOption",setData);
					mLovValue = "";
					for(int a=0; a<mLovList.size(); a++){
						Map mLovMap = (Map) mLovList.get(a);
						if(a==0){
							mLovValue = StringUtil.checkNull( mLovMap.get("NAME"));
						}else{
							mLovValue = mLovValue + StringUtil.checkNull( mLovMap.get("NAME"));
						}
					}
					allMap.put("PlainText", mLovValue);				
				}
				
			}
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
		
		return returnData;
	}
	
	public static List getItemAttrList2(CommonService commonService, List itemAttrAllList, Map<String, Object> cmdMap, String loginLangType) throws ExceptionUtil {
		
		List returnData = itemAttrAllList;
		Map<String, Object> setMap = cmdMap;
		Map setData = new HashMap();
		List mLovList = new ArrayList();
		String mLovValue = "";
			try {
			// isComLang = 1
			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
			setMap.put("languageID", defaultLang);
			setMap.put("loginLangType", loginLangType);
			setMap.put("IsComLang", "1");
			List comLangList = (List)commonService.selectList("attr_SQL.getItemAttr", setMap);
			for (int i = 0; i < returnData.size(); i++) {
				Map allMap = (Map) returnData.get(i);
				String removeAttrCode = String.valueOf(allMap.get("AttrTypeCode"));
				String attrTypeCode2 = String.valueOf(allMap.get("AttrTypeCode2"));
				
				String dataType = String.valueOf(allMap.get("DataType"));
				String isComLang = String.valueOf(allMap.get("IsComLang"));
				
				// isComLang = 1인 Item Attr 은  default언어로 취득한 data로 치환
				for (int j = 0; j < comLangList.size(); j++) {
					Map comLangMap = (Map) comLangList.get(j);
					String addAttrCode = String.valueOf(comLangMap.get("AttrTypeCode"));
				
					if (addAttrCode.equals(removeAttrCode)) {
						returnData.remove(i);						
						if(!attrTypeCode2.equals("") && attrTypeCode2 != null){ // 두번째 컬럼이 있으면 넣어준다 
							comLangMap.put("AttrTypeCode2", attrTypeCode2);
							comLangMap.put("Name2", allMap.get("Name2"));
							comLangMap.put("PlainText2", allMap.get("PlainText2"));
							comLangMap.put("LovCode2", allMap.get("LovCode2"));
							comLangMap.put("BaseLovCode2", allMap.get("BaseLovCode2"));
							comLangMap.put("DataType2", allMap.get("DataType2"));
							comLangMap.put("IsComLang2", allMap.get("IsComLang2"));
							comLangMap.put("HTML2", allMap.get("HTML2"));
							comLangMap.put("Mandatory2", allMap.get("Mandatory2"));
							comLangMap.put("Editable2", allMap.get("Editable2"));
							comLangMap.put("Link2", allMap.get("Link2"));
							comLangMap.put("URL2", allMap.get("URL2"));
							comLangMap.put("AreaHeight2", allMap.get("AreaHeight2"));
							comLangMap.put("editYN2", allMap.get("editYN2"));
							comLangMap.put("RowNum2", allMap.get("RowNum2"));
							comLangMap.put("ColumnNum2", allMap.get("ColumnNum2"));
						}
						returnData.add(i, comLangMap);
					}
					
					if (addAttrCode.equals(attrTypeCode2)) {
						//returnData.remove(i);						
						if(!attrTypeCode2.equals("") && attrTypeCode2 != null){ // 두번째 컬럼이 있으면 넣어준다 
							allMap.put("PlainText2", comLangMap.get("PlainText"));
						}
						//returnData.add(i, comLangMap);
					}
				}
				
				// isComLang = 1이고, DataType = LOV인 Item Attr 은 TB_ITEM_ATTR 취득시만,  default언어설정 해서 값 치환
				if ("LOV".equals(dataType) && "1".equals(isComLang)) {
					setMap.put("languageID", loginLangType);
					setMap.put("defaultLang", defaultLang);
					setMap.put("IsComLang", "0");
					setMap.put("AttrTypeCode", removeAttrCode);
					List lovList = (List)commonService.selectList("attr_SQL.getItemAttr", setMap);
					
					for (int k = 0; k < lovList.size(); k++) {
						Map lovMap = (Map) lovList.get(k);
						String addAttrCode = String.valueOf(lovMap.get("AttrTypeCode"));
					
						if (addAttrCode.equals(removeAttrCode)) {
							returnData.remove(i);							
							if(!attrTypeCode2.equals("") && attrTypeCode2 != null){ // 두번째 컬럼이 있으면 넣어준다 
								lovMap.put("AttrTypeCode2", attrTypeCode2);
								lovMap.put("Name2", allMap.get("Name2"));
								lovMap.put("PlainText2", allMap.get("PlainText2"));
								lovMap.put("LovCode2", allMap.get("LovCode2"));
								lovMap.put("BaseLovCode2", allMap.get("BaseLovCode2"));
								lovMap.put("DataType2", allMap.get("DataType2"));
								lovMap.put("IsComLang2", allMap.get("IsComLang2"));
								lovMap.put("HTML2", allMap.get("HTML2"));
								lovMap.put("Mandatory2", allMap.get("Mandatory2"));
								lovMap.put("Editable2", allMap.get("Editable2"));
								lovMap.put("Link2", allMap.get("Link2"));
								lovMap.put("URL2", allMap.get("URL2"));
								lovMap.put("AreaHeight2", allMap.get("AreaHeight2"));
								lovMap.put("editYN2", allMap.get("editYN2"));
								lovMap.put("RowNum2", allMap.get("RowNum2"));
								lovMap.put("ColumnNum2", allMap.get("ColumnNum2"));
							}
							
							returnData.add(i, lovMap);
						}
					}
				}
				
				if ("MLOV".equals(dataType)) {
					setData.put("s_itemID",allMap.get("AttrTypeCode"));
					setData.put("languageID", loginLangType);
					mLovList = commonService.selectList("attr_SQL.selectAttrLovOption",setData);
					mLovValue = "";
					for(int a=0; a<mLovList.size(); a++){
						Map mLovMap = (Map) mLovList.get(a);
						if(a==0){
							mLovValue = StringUtil.checkNull( mLovMap.get("NAME"));
						}else{
							mLovValue = mLovValue + StringUtil.checkNull( mLovMap.get("NAME"));
						}
					}
					allMap.put("PlainText", mLovValue);				
				}
				
			}
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
		
		return returnData;
	}
	
	public static List getItemAttrRevList(CommonService commonService, List itemAttrAllList, Map<String, Object> cmdMap, String loginLangType) throws ExceptionUtil {
		
		List returnData = itemAttrAllList;
		Map<String, Object> setMap = cmdMap;
		Map setData = new HashMap();
		List mLovList = new ArrayList();
		String mLovValue = "";
		try {
			// isComLang = 1
			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
			setMap.put("languageID", defaultLang);
			setMap.put("loginLangType", loginLangType);
			setMap.put("IsComLang", "1");
			setMap.put("changeSetID", cmdMap.get("changeSetID"));
			List comLangList = (List)commonService.selectList("item_SQL.getItemRevDetailInfo", setMap);
			
			for (int i = 0; i < returnData.size(); i++) {
				Map allMap = (Map) returnData.get(i);
				String removeAttrCode = String.valueOf(allMap.get("AttrTypeCode"));
				
				String dataType = String.valueOf(allMap.get("DataType"));
				String isComLang = String.valueOf(allMap.get("IsComLang"));
				
				// isComLang = 1인 Item Attr 은  default언어로 취득한 data로 치환
				for (int j = 0; j < comLangList.size(); j++) {
					Map comLangMap = (Map) comLangList.get(j);
					String addAttrCode = String.valueOf(comLangMap.get("AttrTypeCode"));
				
					if (addAttrCode.equals(removeAttrCode)) {
						returnData.remove(i);
						returnData.add(i, comLangMap);
					}
				}
				
				// isComLang = 1이고, DataType = LOV인 Item Attr 은 TB_ITEM_ATTR 취득시만,  default언어설정 해서 값 치환
				if ("LOV".equals(dataType) && "1".equals(isComLang)) {
					setMap.put("languageID", loginLangType);
					setMap.put("defaultLang", defaultLang);
					setMap.put("IsComLang", "0");
					setMap.put("AttrTypeCode", removeAttrCode);
					List lovList = (List)commonService.selectList("item_SQL.getItemRevDetailInfo", setMap);
					
					for (int k = 0; k < lovList.size(); k++) {
						Map lovMap = (Map) lovList.get(k);
						String addAttrCode = String.valueOf(lovMap.get("AttrTypeCode"));
					
						if (addAttrCode.equals(removeAttrCode)) {
							returnData.remove(i);
							returnData.add(i, lovMap);
						}
					}
				}
				
				if ("MLOV".equals(dataType)) {
					setData.put("s_itemID",allMap.get("AttrTypeCode"));
					setData.put("languageID", loginLangType);
					mLovList = commonService.selectList("attr_SQL.selectAttrLovOption",setData);
					mLovValue = "";
					for(int a=0; a<mLovList.size(); a++){
						Map mLovMap = (Map) mLovList.get(a);
						if(a==0){
							mLovValue = StringUtil.checkNull( mLovMap.get("NAME"));
						}else{
							mLovValue = mLovValue + StringUtil.checkNull( mLovMap.get("NAME"));
						}
					}
					allMap.put("PlainText", mLovValue);				
				}
				
			}
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
		
		return returnData;
	}
	
	public static String attrUpdate(CommonService commonService,  Map mapData)throws ExceptionUtil{		
		String result = "";
		Map setMap = new HashMap();
		
		try{	
			/* 언어 설정 */
			// TB_ATTR_TYPE.IsComLang = 1 이면, 로그인된 언어와 상관없이 모두 
			// TB_LANGUAGE.IsDefault = 1 인 언어 코드의 ITEM_ATTR 을 insert 또는 update 함
			
			// get IsComLang
			String isComLang = commonService.selectString("attr_SQL.getItemAttrIsComLang", mapData);
			String dataType = commonService.selectString("attr_SQL.getDataType", mapData);
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
			
			if ((!isComLang.isEmpty() && !"0".equals(isComLang)) || !dataType.equals("Text") ) {
				// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
				// 언어 코드를 TB_LANGUAGE.IsDefault = 1 인 언어 코드로 재설정
				mapData.put("languageID", defaultLang);
			}
			
			// get LovCode
			String lovCode = StringUtil.checkNull(mapData.get("LovCode"));
			
			if ("Y".equals(StringUtil.checkNull(mapData.get("getLovCode")))) {
				mapData.remove("PlainText");
				lovCode = StringUtil.checkNull(commonService.selectString("attr_SQL.selectAttrLovCode2", mapData), "Nothing");
				mapData.put("PlainText", lovCode);
			}
			
			if ("Y".equals(StringUtil.checkNull(mapData.get("getMLovCode")))) {
				mapData.remove("PlainText");
				lovCode = StringUtil.checkNull(commonService.selectString("attr_SQL.selectAttrLovCode2", mapData), "Nothing");
				mapData.put("PlainText", lovCode);
			}
						
			if(mapData.get("PlainText").toString().equals("") && !(StringUtil.checkNull(mapData.get("updateOnly"))).equals("Y")){
				commonService.delete("attr_SQL.delItemAttr", mapData);
				result = "D";
			}else{
				if (!"Nothing".equals(lovCode)) {
					mapData.remove("LovCode");
					setMap = (HashMap)commonService.select("attr_SQL.getItemAttrID", mapData);				
					if(StringUtil.checkNull(setMap.get("ItemID").toString(),"0").equals("0") || dataType.equals("MLOV")){
						setMap.put("ClassCode", mapData.get("ClassCode"));
						setMap.put("ItemTypeCode", mapData.get("ItemTypeCode"));
						setMap.put("languageID",  mapData.get("languageID"));
						setMap.put("LovCode", lovCode);
						setMap.put("ItemID", mapData.get("ItemID"));
						setMap.put("AttrTypeCode", mapData.get("AttrTypeCode"));
						setMap.put("PlainText", mapData.get("PlainText"));				
						commonService.insert("item_SQL.setItemAttr", setMap);					
						result = "A";
					}else{
					//	System.out.println("test ==> " + mapData.get("PlainText"));
						setMap.put("ClassCode", mapData.get("ClassCode"));
						setMap.put("ItemTypeCode", mapData.get("ItemTypeCode"));
						setMap.put("languageID", mapData.get("languageID"));
						setMap.put("LovCode", lovCode);
						setMap.put("ItemID", mapData.get("ItemID"));
						setMap.put("PlainText", mapData.get("PlainText"));
						setMap.put("AttrTypeCode", mapData.get("AttrTypeCode"));
						commonService.update("item_SQL.updateItemAttr", setMap);
						result = "U";
					}
					//System.out.println("languageID :"+mapData.get("languageID")+", sessionDefLanguageID :"+mapData.get("sessionDefLanguageId"));
					// Update TB_Item_Attr_Tran rev
					String currLanguageId = StringUtil.checkNull(mapData.get("languageID"));
					if(dataType.equals("Text") && !currLanguageId.equals(defaultLang)){
						setMap.put("targetLanguage", mapData.get("languageID"));
						setMap.put("itemID", mapData.get("ItemID"));
						setMap.put("attrTypeCode", mapData.get("AttrTypeCode"));
						commonService.update("report_SQL.updateItemAttrTran", setMap);		
					}
				}
			}			
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return result;
	}
	
	/**
	 * Item, Item 하위 항목 모두 물리 삭제
	 * @param commonService
	 * @param itemId
	 * @throws ExceptionUtil 
	 */
	public static String delItem(CommonService commonService, String itemId) throws ExceptionUtil {
		
		List<Object> delItemIdList = new ArrayList<Object>();
		List<Object> list = new ArrayList<Object>();
		Map map = new HashMap();
		HashMap<String, Object> setMap = new HashMap<String, Object>();
		String returnItem = "";
			try {
			delItemIdList.add(itemId);
			setMap.put("CURRENT_ToItemID", itemId);
			setMap.put("CategoryCode", "ST1");
			list = commonService.selectList("report_SQL.getChildItems", setMap);
			for (int j = 0; list.size() > j; j++) {// ST1 ItemID
				 map = (Map) list.get(j);
				 delItemIdList.add(map.get("ItemID"));
				 returnItem = String.valueOf(map.get("FromItemID"));
			}
			setMap.remove("CURRENT_ToItemID");
			
			// 취득한 아이템 리스트 사이즈가 0이면 while문을 빠져나간다.
			int i = 1;
			while (i != 0) { 
				String toItemId = "";
				
				setMap.put("CURRENT_ITEM", itemId); // 해당 아이템이 [FromItemID]인것
				setMap.put("CategoryCode", "ST1");
				list = commonService.selectList("report_SQL.getChildItems", setMap);
				i = list.size();
				for (int j = 0; list.size() > j; j++) {
					 map = (Map) list.get(j);
					 delItemIdList.add(map.get("ToItemID"));
					 delItemIdList.add(map.get("ItemID"));
					 if (j == 0) {
						 toItemId = "'" + String.valueOf(map.get("ToItemID")) + "'";
					 } else {
						 toItemId = toItemId + ",'" + String.valueOf(map.get("ToItemID")) + "'";
					 }
				}
				
				// 연관항목(CategoryCode = CN)
				setCNItems(commonService, delItemIdList, itemId, "CN");
				// 모델 커넥션 아이템(CategoryCode = MCN)
				setCNItems(commonService, delItemIdList, itemId, "MCN");
				
				itemId = toItemId; // ToItemID를 다음 ItemID로 설정
			}
	
			String itemIDs ="";
			//Map deItemIDMap = new HashMap();
			for(int ii=0; ii<delItemIdList.size(); ii++){
				//deItemIDMap = (Map)delItemIdList.get(ii);
				if(ii==0){itemIDs = StringUtil.checkNull(delItemIdList.get(ii));
				}else{itemIDs = itemIDs+","+ StringUtil.checkNull(delItemIdList.get(ii));}
			}
			
			Map setData = new HashMap();
			setData.put("itemIDs", itemIDs);
			setData.put("searchItem", "srArea1");
			String srArea1CNT = commonService.selectString("report_SQL.getSRAreaCount", setData);
			
			setData.put("searchItem", "srArea2");
			String srArea2CNT = commonService.selectString("report_SQL.getSRAreaCount", setData);
			
			setData.put("searchItem", "crArea1");
			String crArea1CNT = commonService.selectString("report_SQL.getCRAreaCount", setData);
			setData.put("searchItem", "crArea2");
			String crArea2CNT = commonService.selectString("report_SQL.getCRAreaCount", setData);
			
			//String myItemCNT = commonService.selectString("report_SQL.getMyItemCount", setData);
			
			int totalSearchItemCnt = Integer.parseInt(srArea1CNT)+Integer.parseInt(srArea2CNT)+Integer.parseInt(crArea1CNT)+Integer.parseInt(crArea2CNT);
			
			if(totalSearchItemCnt==0){
			/* ItemID, ST1 ItemID, CN ItemID 모두 물리 삭제 */
			/* 대상 테이블 : TB_ITEM_ATTR, TB_FILE, TB_ITEM_OCC, TB_ELEMENT(커넥션 아이템의 element 포함), TB_ITEM, TB_CHANGE_SET, TB_MY_ITEM, TB_ITEM_DIM */
				for (int index = 0; delItemIdList.size() > index; index++) {
					itemId = String.valueOf(delItemIdList.get(index));
					setMap.put("ItemID", itemId);
					
					// 아이템의 board 정보 삭제
					List boardList = commonService.selectList("board_SQL.getBoardID", setMap);
					for (int g = 0; boardList.size() > g; g++) {
						Map boardMap = (Map) boardList.get(g);
						setMap.put("privateId", boardMap.get("BoardID"));
						commonService.delete("forum_SQL.forumDelete", setMap);
					}
					
					// 아이템의 Model 정보 삭제
					// [TB_ELEMENT][TB_MODEL_TXT][TB_MODEL]의 해당 데이터를 차례로 물리 삭제
					List modelList = commonService.selectList("report_SQL.getModelWithItemId", setMap);
					for (int g = 0; modelList.size() > g; g++) {
						Map modelMap = (Map) modelList.get(g);
						setMap.put("ModelID", modelMap.get("ModelID"));
						commonService.delete("report_SQL.delElementAndModelTxt", setMap);
					}
					
					commonService.delete("report_SQL.delAllChildItems", setMap);
					
				}
			}else{
				returnItem = "N"; // 삭제할수 없는 Item이 있음.
			}
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
		return returnItem;
		
	}
	
	/**
	 * 연관항목 및 모델 커넥션 아이템을 취득해서 list에 저장
	 * @param delItemIdList
	 * @param currentItemId
	 * @param categoryCode
	 * @throws ExceptionUtil
	 */
	private static void setCNItems(CommonService commonService, List<Object> delItemIdList, String currentItemId, String categoryCode) throws ExceptionUtil {
		HashMap<String, Object> schConditionMap = new HashMap<String, Object>();
			try {
			// 해당 아이템이 FromItemId 인 연관항목
			schConditionMap.put("CategoryCode", categoryCode);
			schConditionMap.put("CURRENT_ITEM", currentItemId);
			List list = commonService.selectList("report_SQL.getChildItems", schConditionMap);
			for (int j = 0; list.size() > j; j++) {
				 Map map = (Map) list.get(j);
				 delItemIdList.add(map.get("ItemID"));
			}
			
			// 해당 아이템이 toItemId 인 연관항목
			schConditionMap.remove("CURRENT_ITEM");
			schConditionMap.put("CURRENT_ToItemID", currentItemId);
			list = commonService.selectList("report_SQL.getChildItems", schConditionMap);
			for (int j = 0; list.size() > j; j++) {
				 Map map = (Map) list.get(j);
				 delItemIdList.add(map.get("ItemID"));
			}
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
	}
	
	public static String procInstanceAttrUpdate(CommonService commonService,  Map mapData)throws ExceptionUtil{		
		String result = "";
		Map setMap = new HashMap();
		
		try{	
			/* 언어 설정 */
			// TB_ATTR_TYPE.IsComLang = 1 이면, 로그인된 언어와 상관없이 모두 
			// TB_LANGUAGE.IsDefault = 1 인 언어 코드의 ITEM_ATTR 을 insert 또는 update 함
			
			// get IsComLang
			String isComLang = commonService.selectString("attr_SQL.getItemAttrIsComLang", mapData);
			String dataType = commonService.selectString("attr_SQL.getDataType", mapData);
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
			
			if ((!isComLang.isEmpty() && !"0".equals(isComLang)) || !dataType.equals("Text") ) {
				// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
				// 언어 코드를 TB_LANGUAGE.IsDefault = 1 인 언어 코드로 재설정
				mapData.put("languageID", defaultLang);
			}
			
			// get LovCode
			String lovCode = StringUtil.checkNull(mapData.get("LovCode"));
			
			if ("Y".equals(StringUtil.checkNull(mapData.get("getLovCode")))) {
				mapData.remove("PlainText");
				lovCode = StringUtil.checkNull(commonService.selectString("attr_SQL.selectAttrLovCode2", mapData), "Nothing");
				mapData.put("PlainText", lovCode);
			}
						
			if(mapData.get("value").toString().equals("")){
				commonService.delete("instance_SQL.delInstanceAttr", mapData);
				result = "D";
			}else{
				if (!"Nothing".equals(lovCode)) {
					String procInstAttrCNT = StringUtil.checkNull(commonService.selectString("instance_SQL.getInstanceAttrCNT", mapData));
					
					if(procInstAttrCNT.equals("0") || dataType.equals("MLOV")){
						setMap.put("instanceNo", mapData.get("instanceNo"));
						setMap.put("instanceClass", mapData.get("instanceClass"));
						setMap.put("attrTypeCode",  mapData.get("AttrTypeCode"));
						setMap.put("plannedValue", mapData.get("plannedValue"));
						setMap.put("value", mapData.get("value"));
						setMap.put("regTeamID", mapData.get("regTeamID"));
						setMap.put("regUserID", mapData.get("regUserID"));	
						setMap.put("lastUserTeamID", mapData.get("lastUserTeamID"));
						setMap.put("lastUser", mapData.get("lastUser"));
						
						commonService.insert("instance_SQL.insertInstanceAttr", setMap);					
						result = "A";
					}else{						
						setMap.put("instanceNo", mapData.get("instanceNo"));
						setMap.put("instanceClass", mapData.get("instanceClass"));
						setMap.put("attrTypeCode",  mapData.get("AttrTypeCode"));
						setMap.put("plannedValue", mapData.get("PlannedValue"));
						setMap.put("value", mapData.get("value"));
						setMap.put("lastUserTeamID", mapData.get("lastUserTeamID"));
						setMap.put("lastUser", mapData.get("lastUser"));
						
						commonService.update("instance_SQL.updateInstanceAttr", setMap);					
						result = "U";
					}
				}
			}			
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return result;
	}
	
	
	
}
