package xbolt.cmm.framework.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import xbolt.cmm.service.CommonService;

/**
 * 공통 서블릿 처리
 * @Class Name : DimTreeAddUtil.java
 * @Description : TB_DIM_TREE INSERT처리 관련 함수
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2014. 01. 13. smartfactory		최초생성
 *
 * @since 2014. 01. 13.
 * @version 1.0
 * @see
 * 
 * Copyright (C) 2013 by SMARTFACTORY All right reserved.
 */
@SuppressWarnings("unused")
public class DimTreeAdd {
	
	/**
	 * TB_ITEM_DIM_TREE 테이블에 record를 insert
	 * 이미 INSERT되어 있는 NodeID의 Insert는 skip
	 * @param connectionIdList
	 * @param setMap
	 * @throws ExceptionUtil 
	 */
	public static void insertToTbItemDimTree(CommonService commonService, List<String> connectionIdList, Map<String, Object> setMap) throws ExceptionUtil {
		try {
			for (String connectionId : connectionIdList) {
				setMap.put("NodeID", connectionId);
				
				// connectionId의 DB 존재 Check
				if ("0".equals(commonService.selectString("dim_SQL.isExistDimTreeNodeID", setMap))) {
					commonService.insert("dim_SQL.insertItemDimTree", setMap);
				}
			}
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
	}
	
	/**
	 *  파라메터로 넘어온 ItemID의 상위 connection ItemID 를 취득
	 *  FromItemID가 [0]인 connection ItemID까지 취득
	 * @param itemId
	 * @param dimTypeID
	 * @param dimValueID
	 * @param connectionIdList
	 * @param kbn
	 * @throws ExceptionUtil
	 */
	@SuppressWarnings("unchecked")
	public static void getOverConnectionId(CommonService commonService, String itemId, String dimTypeID, String dimValueID, List<String> connectionIdList, int kbn) throws ExceptionUtil {
		
		Map<String, String> commandMap = new HashMap<String, String>();
		
		String toItemID = itemId;
		boolean isNext = true;
			try {
			commandMap.put("ToItemID", toItemID);
			List<Map<String, Object>> connectionIdInfoList = (List<Map<String, Object>>) commonService.selectList("dim_SQL.getConnectionIdInfo", commandMap);
			Map<String, Object> connectionIdInfoMap = (Map<String, Object>) connectionIdInfoList.get(0);
			toItemID = connectionIdInfoMap.get("FromItemID").toString();
			
			int level = 0;
			if (null != connectionIdInfoMap.get("Level")) {
				level = Integer.parseInt(connectionIdInfoMap.get("Level").toString());
			}
			
			connectionIdList.add(connectionIdInfoMap.get("ItemID").toString());
			
			if (kbn == 1) {
				Map<String, String> commandMap2 = new HashMap<String, String>();
				commandMap2.put("DimTypeID", dimTypeID);
				commandMap2.put("DimValueID", dimValueID);
				commandMap2.put("FromItemID", connectionIdInfoMap.get("FromItemID").toString());
				commandMap2.put("ToItemID", connectionIdInfoMap.get("ToItemID").toString());
				if (!"0".equals(commonService.selectString("dim_SQL.isExistDimTreeFromItemID", commandMap2))) {
					// 대상 NodeID의 FromItemId와 같은 record가 존재 할 경우, NodeID추가 처리를 마침
					//level = 0;
					isNext = false;
				}
			}
			
			//for (int i = 0; i < level; i++) {
			while (isNext == true) {
				commandMap = new HashMap<String, String>();
				commandMap.put("ToItemID", toItemID);
				
				connectionIdInfoList = (List<Map<String, Object>>) commonService.selectList("dim_SQL.getConnectionIdInfo", commandMap);
				
				if (connectionIdInfoList.size() > 0) {
					connectionIdInfoMap = (Map<String, Object>) connectionIdInfoList.get(0);
					toItemID = connectionIdInfoMap.get("FromItemID").toString();
					
					if (kbn == 1) {
						
						Map<String, String> commandMap3 = new HashMap<String, String>();
						commandMap3.put("DimTypeID", dimTypeID);
						commandMap3.put("DimValueID", dimValueID);
						commandMap3.put("FromItemID", connectionIdInfoMap.get("FromItemID").toString());
						commandMap3.put("ToItemID", connectionIdInfoMap.get("ToItemID").toString());
						connectionIdList.add(connectionIdInfoMap.get("ItemID").toString());
						
						if (!"0".equals(commonService.selectString("dim_SQL.isExistDimTreeFromItemID", commandMap3))) {
							// 대상 NodeID의 FromItemId와 같은 record가 존재 할 경우, NodeID추가 처리를 마침
							break;
						}
						
					} else {
						connectionIdList.add(connectionIdInfoMap.get("ItemID").toString());
					}
				}
				
				if (toItemID.equals("0")) {
					isNext = false;
				}
				
			}
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
		
	}


	/**
	 *  파라메터로 넘어온 ItemID의 하위 connection ItemID 를 취득
	 *  connection ItemID의 Level [5]인 connection ItemID까지 취득
	 * @param itemId
	 * @param connectionIdList
	 * @throws ExceptionUtil
	 */
	@SuppressWarnings("unchecked")
	public static void getUnderConnectionId(CommonService commonService, String itemId, List<String> connectionIdList) throws ExceptionUtil {
		Map<String, String> commandMap = new HashMap<String, String>();
		
		String fromItemID = itemId;
		int nowLevel = 0;
			try {
			// 해당 아이템의 ItemTypeCode 중 Max 레벨 취득
			commandMap.put("s_itemID", itemId);
			Map itemInfoMap  =  commonService.select("project_SQL.getItemInfo", commandMap);
			commandMap.put("ItemTypeCode", StringUtil.checkNull(itemInfoMap.get("ItemTypeCode")));
			int maxLevel = Integer.parseInt(commonService.selectString("dim_SQL.getMaxLevelWithItemTypeCode", commandMap));
			
			commandMap.put("FromItemID", fromItemID);
			List<Map<String, Object>> connectionIdInfoList = (List<Map<String, Object>>) commonService.selectList("dim_SQL.getConnectionIdInfo", commandMap);
			
			while (nowLevel < maxLevel && connectionIdInfoList.size() > 0) {        
				
				for (Map<String, Object> connectionIdInfoMap : connectionIdInfoList) {
					nowLevel = Integer.parseInt(StringUtil.checkNull(connectionIdInfoMap.get("Level"), "0")); // TODO : Level = null ?
					fromItemID = connectionIdInfoMap.get("ToItemID").toString();
					commandMap.put("FromItemID", fromItemID);
					connectionIdList.add(connectionIdInfoMap.get("ItemID").toString());
				}
				
				connectionIdInfoList = (List<Map<String, Object>>) commonService.selectList("dim_SQL.getConnectionIdInfo", commandMap);
				
			}
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
	}
	
	/**
	 * TB_ITEM_DIM 테이블에 존재하는 ItemID를 취득해서 list에 저장
	 * @param itemDimIdList
	 * @param connectionIdList
	 * @param dimTypeID
	 * @param dimValueID
	 * @throws ExceptionUtil
	 */
	public static void getExistItemDimId(
					CommonService commonService, 
					List<String> itemDimIdList, 
					List<String> connectionIdList, 
					String dimTypeID, String dimValueID) throws ExceptionUtil {
    
        Map<String, String> commandMap = new HashMap<String, String>(); 
		commandMap.put("DimTypeID", dimTypeID);
		commandMap.put("DimValueID", dimValueID);
	    try {
			for (int i = 0; i < connectionIdList.size() ; i++) {
				String connectionId = connectionIdList.get(i);
				commandMap.put("NodeID", connectionId);
		   
				String itemDimid = commonService.selectString("dim_SQL.isExistItemDim", commandMap);
				if (null != itemDimid) {
					itemDimIdList.add(itemDimid);
				}
			}
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
	 }
	
	/**
	 * 아이템의  상위 항목 취득
	 * @param commandMap
	 * @param arrayStr
	 * @throws ExceptionUtil
	 */
	public static List getHighLankItemList(CommonService commonService, String[] arrayStr) throws ExceptionUtil {
		List highLankItemIdList = new ArrayList();
		List list = new ArrayList();
		Map map = new HashMap();
		Map setMap = new HashMap();
		try {
			for (int i = 0; i < arrayStr.length; i++) {
				String itemId = arrayStr[i];
				highLankItemIdList.add(itemId);
				
				// 취득한 아이템 리스트 사이즈가 0이면 while문을 빠져나간다.
				int j = 1;
				while (j != 0) { 
					String fromItemId = "";
					
					setMap.put("CURRENT_ToItemID", itemId); // 해당 아이템이 [FromItemID]인것
					setMap.put("CategoryCode", "ST1");
					list = commonService.selectList("report_SQL.getChildItems", setMap);
					j = list.size();
					for (int k = 0; list.size() > k; k++) {
						 map = (Map) list.get(k);
						 highLankItemIdList.add(map.get("FromItemID"));
						 if (k == 0) {
							 fromItemId = "'" + String.valueOf(map.get("FromItemID")) + "'";
						 } else {
							 fromItemId = fromItemId + ",'" + String.valueOf(map.get("FromItemID")) + "'";
						 }
					}
					
					if (fromItemId.equals("'0'")) {
						j = 0;
					} else {
						itemId = fromItemId; // fromItemId를 다음 ItemID로 설정
					}
					
				}
				
			}
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
		
		return highLankItemIdList;
	}
	
	/**
	 * 아이템의  하위 항목 취득
	 * @param commandMap
	 * @param arrayStr
	 * @throws ExceptionUtil
	 */
	public static List getChildItemList(CommonService commonService, String[] arrayStr) throws ExceptionUtil {
		List subTreeItemIDList = new ArrayList();
		List list = new ArrayList();
		Map map = new HashMap();
		Map setMap = new HashMap();
		try {
			// TODO : HasDimension 이 1인것만 처리 할지 여부 ???
			//  1인것만 처리 할 경우, ClassCode의 HasDimension 정보 update에 제약이 생김
			for (int i = 0; i < arrayStr.length; i++) {
				String itemId = arrayStr[i];
				subTreeItemIDList.add(itemId);
				
				// 취득한 아이템 리스트 사이즈가 0이면 while문을 빠져나간다.
				int j = 1;
				while (j != 0) { 
					String toItemId = "";
					
					setMap.put("CURRENT_ITEM", itemId); // 해당 아이템이 [FromItemID]인것
					setMap.put("CategoryCode", "ST1");
					list = commonService.selectList("report_SQL.getChildItems", setMap);
					j = list.size();
					for (int k = 0; list.size() > k; k++) {
						 map = (Map) list.get(k);
						 subTreeItemIDList.add(map.get("ToItemID"));
						 if (k == 0) {
							 toItemId = "'" + String.valueOf(map.get("ToItemID")) + "'";
						 } else {
							 toItemId = toItemId + ",'" + String.valueOf(map.get("ToItemID")) + "'";
						 }
					}
					
					itemId = toItemId; // ToItemID를 다음 ItemID로 설정
				}
				
			}
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
		
		return subTreeItemIDList;
	}
	
	/**
	 * 이동할 아이템의  Dimension Tree 정보 삭제
	 * @param commonService
	 * @param commandMap
	 * @param arrayStr
	 * @throws ExceptionUtil
	 */
	public static void deleteDimTreeInfo(CommonService commonService, HashMap commandMap, List rowLankItemList) throws ExceptionUtil {
		
		/* DELETE TB_ITEM_DIM_TREE :: 이동할 아이템의  Dimension Tree 정보 삭제 */
		Map setMap = new HashMap();
		try {
			for (int i = 0; i < rowLankItemList.size(); i++) {
				String deletedItemId = rowLankItemList.get(i).toString();
				setMap.put("ItemID", deletedItemId);
				List dimensionList = commonService.selectList("dim_SQL.getDimListWithItemId", setMap);
				String itemID = deletedItemId;
				for (int j = 0; j < dimensionList.size(); j++) {
					Map dimensionMap = (Map) dimensionList.get(j);
					String dimTypeID = String.valueOf(dimensionMap.get("DimTypeID"));
					String dimValueID = String.valueOf(dimensionMap.get("DimValueID"));
					
					/* DELETE TB_ITEM_DIM_TREE */
					// Connection ItemID 취득, NodeID 설정
					List<String> connectionIdList = new ArrayList<String>();
			   
					// 삭제 대상의 ItemId의 Connection ItemID 중  TB_ITEM_DIM record가 존재하는 data를 취득
					List<String> itemDimIdList  = new ArrayList<String>();
					DimTreeAdd.getUnderConnectionId(commonService, itemID, connectionIdList);
					DimTreeAdd.getExistItemDimId(commonService, itemDimIdList, connectionIdList, dimTypeID, dimValueID);
				   
					connectionIdList = new ArrayList<String>();
					DimTreeAdd.getOverConnectionId(commonService, itemID, dimTypeID, dimValueID, connectionIdList, 0);
					DimTreeAdd.getExistItemDimId(commonService, itemDimIdList, connectionIdList, dimTypeID, dimValueID);
				   
					// 삭제 대상의 ItemId의 Connection ItemID를 TB_ITEM_DIM_TREE 테이블에서 모두 삭제
					connectionIdList = new ArrayList<String>();
					DimTreeAdd.getUnderConnectionId(commonService, itemID, connectionIdList);
					DimTreeAdd.getOverConnectionId(commonService, itemID, dimTypeID, dimValueID, connectionIdList, 1);
				   
					setMap.put("DimTypeID", dimTypeID);
					setMap.put("DimValueID", dimValueID);
					for (String connectionId : connectionIdList) {
						setMap.put("NodeID", connectionId);
						commonService.delete("dim_SQL.delSubDimTree", setMap); 
					}
			
					// 삭제 대상의 ItemId의 Connection ItemID 중  TB_ITEM_DIM record가 존재하는 data의 TB_ITEM_DIM_TREE record를 INSERT
					itemDimIdList.remove(itemID);
					if (itemDimIdList.size() != 0) {
						//Map commandMap = new HashMap();
				    
						for (int k = 0; k < itemDimIdList.size(); k++) {
							String itemDimId = itemDimIdList.get(k);
							// ItemID의 ItemTypeCode, ClassCode 취득 
							commandMap.put("ItemID", itemDimId);  
							List itemInfoList = (List) commonService.selectList("dim_SQL.getItemTypeCodeAndClassCode", commandMap);
							Map itemInfoMap = (Map) itemInfoList.get(0);
							String itemTypeCode = itemInfoMap.get("ItemTypeCode").toString();
				     
							connectionIdList = new ArrayList<String>();
				     
							DimTreeAdd.getOverConnectionId(commonService, itemDimId, dimTypeID, dimValueID, connectionIdList, 0);
							DimTreeAdd.getUnderConnectionId(commonService, itemDimId, connectionIdList);
				     
							// connectionId list분, TB_ITEM_DIM_TREE record 입력
							// 단, 이미 존재하는 record 인 경우, INSERT skip
							commandMap.put("DimTypeID", dimTypeID);
							commandMap.put("DimValueID", dimValueID);
							commandMap.put("ItemTypeCode", itemTypeCode);
							DimTreeAdd.insertToTbItemDimTree(commonService, connectionIdList, commandMap);
						}
				    
					}
					
				}
				
			}
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
	}

	/**
	 * 이동한 아이템의  Dimension Tree 정보 추가
	 * @param commonService
	 * @param commandMap
	 * @param rowLankItemList
	 * @throws ExceptionUtil
	 */
	public static void insertDimTreeInfo(CommonService commonService, HashMap commandMap, List rowLankItemList) throws ExceptionUtil {
		/* INSERT TB_ITEM_DIM_TREE :: 이동한 아이템의  Dimension Tree 정보 추가 */
		Map setMap = new HashMap();
		try {
			for (int i = 0; i < rowLankItemList.size(); i++) {
				String insertItemId = rowLankItemList.get(i).toString();
				setMap.put("ItemID", insertItemId);
				List dimensionList = commonService.selectList("dim_SQL.getDimListWithItemId", setMap);
				String itemID = insertItemId;
				for (int j = 0; j < dimensionList.size(); j++) {
					Map dimensionMap = (Map) dimensionList.get(j);
					String dimTypeID = String.valueOf(dimensionMap.get("DimTypeID"));
					String dimValueID = String.valueOf(dimensionMap.get("DimValueID"));
					
					// ItemID의 ItemTypeCode, ClassCode 취득 
					commandMap.put("ItemID", itemID);  
					List itemInfoList = (List) commonService.selectList("dim_SQL.getItemTypeCodeAndClassCode", commandMap);
					Map itemInfoMap = (Map) itemInfoList.get(0);
					String itemTypeCode = itemInfoMap.get("ItemTypeCode").toString();
					String itemClassCode = itemInfoMap.get("ClassCode").toString();
					
					/* INSERT TB_ITEM_DIM_TREE */
			   
					// Connection ItemID 취득, NodeID 설정
					List<String> connectionIdList = new ArrayList<String>();
			   
					DimTreeAdd.getOverConnectionId(commonService, itemID, dimTypeID, dimValueID, connectionIdList, 0);
					DimTreeAdd.getUnderConnectionId(commonService, itemID, connectionIdList);
			   
					// connectionId list분, TB_ITEM_DIM_TREE record 입력
					// 단, 이미 존재하는 record 인 경우, INSERT skip
					setMap.put("ItemTypeCode", itemTypeCode);
					setMap.put("DimTypeID", dimTypeID); 
					setMap.put("DimValueID", dimValueID);   
					DimTreeAdd.insertToTbItemDimTree(commonService, connectionIdList, setMap);
					
				}
			}
	    } catch(Exception e) {
	    	throw new ExceptionUtil(e.toString());
	    }
	}
}
