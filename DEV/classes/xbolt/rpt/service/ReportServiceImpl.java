package xbolt.rpt.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import xbolt.cmm.framework.util.DateUtil;
import xbolt.cmm.framework.util.GetItemAttrList;
import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonDataServiceImpl;
import xbolt.cmm.service.CommonService;


@Service("reportService")
@SuppressWarnings("unchecked")
public class ReportServiceImpl extends CommonDataServiceImpl implements CommonService{
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "CSService")
	private CommonService CSService;

	@Override
	public void save(Map map) throws Exception{
		
		if (map.get("uploadTemplate").equals("1")) {
			// 새로운 구조 업로드
			insertNewItem(map);
			
		} else if (map.get("uploadTemplate").equals("2")) {
			// 기존 속성 업데이트
			updateItemAttr(map);
			
		} else if (map.get("uploadTemplate").equals("3")) {
			// 관련항목 Mapping
			insertNewConnetionItem(map);
			
		} else if (map.get("uploadTemplate").equals("4")) {
			// Dimension Mapping
			insertDimensionItem(map);
			
		} else if (map.get("uploadTemplate").equals("5")) {
			// CBO List
			insertNewCBOList(map);
		} else if (map.get("uploadTemplate").equals("6")) {
			// IF Master
			insertNewIFMaster(map);
		} else if (map.get("uploadTemplate").equals("7")) {
			// CBO List Program Status
			insertCboProgramStatus(map);
		} else if (map.get("uploadTemplate").equals("8")) {
			// IF Master Program Status
			insertIfProgramStatus(map);
		} else if (map.get("uploadTemplate").equals("9")) {
			// 전사 시스템 목록 
			insertWholeCompanySystemItem(map);
		} else if (map.get("uploadTemplate").equals("10")) {
			// Item Team Mapping
			insertTeamRole(map);
		} else if (map.get("uploadTemplate").equals("11")) {
			// MyItem Member Mapping
			insertMemberRole(map);
		}
		
	}
	
	
	/**
	 * 새로운 구조 업로드시 읽어들인 템플릿의 정보를 DB에 저장
	 * 
	 * @param map
	 * @throws Exception
	 */
	private void insertNewItem(Map map) throws Exception {
		
		String itemId = "";
		String parentItemId = "";
		String categoryCode = "";
		String csrId = "";
		String companyID = StringUtil.checkNull(map.get("companyID"));
		String ownerTeamID = StringUtil.checkNull(map.get("OwnerTeamID"));	
		String userId = StringUtil.checkNull(map.get("userId"));
		String itemTypeCode = StringUtil.checkNull(map.get("itemTypeCode"));
		String itemTypeCodeCN = StringUtil.checkNull(map.get("itemTypeCodeCN"));
		
		Map identifierMap = new HashMap();
		Map commandMap = new HashMap();
		
		for (int r = 0; r < NumberUtil.getIntValue(map.get("rowCount")); r++) {
			Map data = fetchRowData(map, r);
			Map inputData = new HashMap();
			Map updateData = new HashMap();
			Map insertCngMap  = new HashMap();
			Map setMap  = new HashMap();
			String setInfo = "";
			if (data !=null && data.size() > 0) {
				
				Map categoryInfoMap = select("report_SQL.getCategoryCode", data);
				categoryCode = StringUtil.checkNull(categoryInfoMap.get("Category"));
				itemTypeCode = StringUtil.checkNull(categoryInfoMap.get("ItemTypeCode"), itemTypeCode);
				
				itemId =  selectString("item_SQL.getItemMaxID", data);
				
				/* 공통 내용 */
				inputData.put("Version", "1");
				inputData.put("Deleted", "0");
				inputData.put("Creator", userId);
				inputData.put("CompanyID", companyID);
				inputData.put("OwnerTeamId", ownerTeamID);
				inputData.put("AuthorID", userId);
				
				// 각 행의 Identifier칼럼을 Map에 저장함
				// key: Identifier, value:itemId
				identifierMap.put(StringUtil.checkNull(data.get("newIdentifier")), itemId);
				
				// 첫번째 데이터의 ITEM추가
				// parentID가 없으면 parentItemId를 지정된 상위 ItemId로 지정 해줌
				//if (r == 0) {
				if (StringUtil.checkNull(data.get("newParentIdentifier"), "").isEmpty()) {
					parentItemId = StringUtil.checkNull(map.get("s_itemID"));
				} else {
					if (identifierMap.containsKey(StringUtil.checkNull(data.get("newParentIdentifier")))) {
						parentItemId = identifierMap.get(StringUtil.checkNull(data.get("newParentIdentifier"))).toString(); //TODO: 1번째 파일 부터
					} else {
						if(StringUtil.checkNull(map.get("uploadOption")).equals("1")){
							parentItemId = StringUtil.checkNull(data.get("newParentIdentifier"));
						}else{
							setMap = new HashMap();  //TODO: 2번째 파일 부터
							setMap.put("Identifier", StringUtil.checkNull(data.get("newParentIdentifier")));
							parentItemId = StringUtil.checkNull(selectString("report_SQL.getItemIdWithIdentifier", setMap));
							if(parentItemId.equals("")){ parentItemId = StringUtil.checkNull(map.get("s_itemID")); }
						}
					}
				}
				
				//  [TB_ITEM]에 데이터 insert
				csrId = StringUtil.checkNull(data.get("newItemId"));
				if (csrId.isEmpty()) {
					csrId = StringUtil.checkNull(map.get("csrInfo"));
				}
				inputData.put("CategoryCode", categoryCode); 
				inputData.put("ClassCode", StringUtil.checkNull(data.get("newClassCode")));
				inputData.put("FromItemID", null);
				inputData.put("ToItemID", null); 
				inputData.put("ItemID", itemId);
				inputData.put("ItemTypeCode", itemTypeCode);
				inputData.put("Identifier", StringUtil.checkNull(data.get("newIdentifier")));
				inputData.put("ProjectID", csrId);
				inputData.put("Status", "NEW1");
				
				inputData.put("projectID", csrId);
				String itemAccCtrl = StringUtil.checkNull(commonService.selectString("project_SQL.getProjectItemAccCtrl", inputData));
				inputData.put("AccCtrl", itemAccCtrl);
				
				String clientID = "";
				setMap.put("ProjectID", csrId);
				Map<String, Object> parentInfoMap = select("project_SQL.getParentPjtInfo", setMap);
				if(!parentInfoMap.isEmpty()) {
					clientID = StringUtil.checkNull(parentInfoMap.get("ClientID"));
				}
				inputData.put("clientID", clientID);
				insert("item_SQL.insertItem", inputData);
				
				if ("REF".equals(categoryCode)) {
					// 참조 아이템인 경우
					updateData = new HashMap();
					updateData.put("LastUser", userId);
					updateData.put("RefItemID", parentItemId);
					updateData.put("ItemID", itemId);
					update("item_SQL.updateItem", updateData);
				} else {
					// [TB_ITEM]에 데이터 insert(연결 ITEM)
					inputData.put("CategoryCode", "ST1"); //ST2:관련항목
					inputData.put("ClassCode", "NL00000");
					inputData.put("FromItemID", parentItemId);
					inputData.put("ToItemID", itemId);
					inputData.put("ItemID", (selectString("item_SQL.getItemMaxID", data)));
					inputData.put("Identifier", null);
					inputData.put("ItemTypeCode", itemTypeCodeCN);
					inputData.put("Status", "NEW1");
					insert("item_SQL.insertItem", inputData);
				}
				
				/* 신규 생성된 ITEM의 ITEM_CLASS.ChangeMgt = 1 일 경우, CHANGE_SET 테이블에 레코드 생성  */
				setMap = new HashMap();
				setMap.put("ItemID", itemId);
				String changeMgt = StringUtil.checkNull(commonService.selectString("project_SQL.getChangeMgt", setMap));
				if (changeMgt.equals("1")) {
					/* Insert to TB_CHANGE_SET */
					insertCngMap.put("itemID", itemId);
					insertCngMap.put("userId", userId);
					insertCngMap.put("projectID", csrId);
					insertCngMap.put("classCode", StringUtil.checkNull(data.get("newClassCode")));
					insertCngMap.put("KBN", "insertCNG");
					insertCngMap.put("status", "MOD");
					CSService.save(new ArrayList(), insertCngMap);
				}else {
					/* ParentItem의 CurChangeSet Update */
					setMap.put("itemID", itemId);
					parentItemId = StringUtil.checkNull(commonService.selectString("item_SQL.getFromItemID", setMap));
					setMap.put("itemID",parentItemId);
					String sItemIDCurChangeSetID = StringUtil.checkNull(commonService.selectString("project_SQL.getCurChangeSetIDFromItem", setMap));
					if(!sItemIDCurChangeSetID.equals("")){
						updateData = new HashMap();
						updateData.put("CurChangeSet", sItemIDCurChangeSetID);
						updateData.put("s_itemID", itemId);
						commonService.update("project_SQL.updateItemStatus", updateData);
					}
				}
				
				// 해당 classcode의 [] 의 AttributeCode 취득
				commandMap = new HashMap();
				commandMap.put("s_itemID", itemId);
				commandMap.put("languageID", StringUtil.checkNull(map.get("selectedLang")));
				List allocatedAttrList = commonService.selectList("report_SQL.itemAttributesInfo", commandMap);
				Map allocatedAttrMap = new HashMap();
				Map allocatedAttrHtmlMap = new HashMap();
				allocatedAttrMap.put("AT00001", "Text"); // 명칭
				for (int i = 0; allocatedAttrList.size() > i ; i++) {
					Map attrMap = (Map) allocatedAttrList.get(i);
					allocatedAttrMap.put(attrMap.get("AttrTypeCode"), attrMap.get("DataType"));
					allocatedAttrHtmlMap.put(attrMap.get("AttrTypeCode"), attrMap.get("HTML"));
				}
				
				// PlainText칼럼만큼  [TB_ITEM_ATTR]에 데이터 insert
				// 5번째 칼럽부터 AttrTypeCode가 설정 되어 있음
				Iterator<String> iterator = data.keySet().iterator();
				while (iterator.hasNext()) {
					String attrTypeCode = "";
					String plainText = "";
					String key = StringUtil.checkNull((String) iterator.next());
					String [] vals = StringUtil.checkNull(data.get(key)).split("[::]");
						 
					if (vals.length > 1) {
						attrTypeCode = vals[0];
						// 해당 아이템의 classcode가 allocation된 attrbutecode만 insert or update
						if (allocatedAttrMap.containsKey(attrTypeCode)) {
							for (int j = 1; j < vals.length; j++) {
								plainText = plainText + vals[j];
							}
							
							inputData = new HashMap();
							// DataType = Date or Lov 일때, 값 정합성 체크
							if ("Date".equals(StringUtil.checkNull(allocatedAttrMap.get(attrTypeCode)))) {
								plainText = DateUtil.isValidDate(plainText.replace("-", "").replace("/", ""));
								if (!plainText.isEmpty()) {
									plainText = DateUtil.getDateCalc(plainText, 0, "");
								}
							}
							if ("LOV".equals(StringUtil.checkNull(allocatedAttrMap.get(attrTypeCode)))) {
								inputData.put("getLovCode", "Y");
								inputData.put("Value", plainText);
							}
							
							if ("MLOV".equals(StringUtil.checkNull(allocatedAttrMap.get(attrTypeCode)))) {
								inputData.put("getMLovCode", "Y");
								inputData.put("Value", plainText);
							}
							
							//201610 TEXT Type인 경우
							if ("TEXT".equals(StringUtil.toUpperCase(StringUtil.checkNull(allocatedAttrMap.get(attrTypeCode))))) {
								if (!plainText.isEmpty()) {
									if(attrTypeCode.equals("AT00001")){
										plainText = plainText.replaceAll("&&rn", " ");
									}else{
										//201610 HTML=1인 경우									
										if("1".equals(StringUtil.checkNull(allocatedAttrHtmlMap.get(attrTypeCode)))){
											plainText = plainText.replaceAll("&&rn", "<br/>").replaceAll("_", "/");
										}else{
											plainText = plainText.replaceAll("&&rn", "\r\n").replaceAll("_", "/");
										}
									}
								}							
							}							
							
							if (!plainText.isEmpty()) {
								inputData.put("ItemID", itemId);
								inputData.put("AttrTypeCode", attrTypeCode);
								inputData.put("PlainText", plainText);
								inputData.put("languageID", StringUtil.checkNull(map.get("selectedLang")));
								inputData.put("ItemTypeCode", itemTypeCode);
								inputData.put("ClassCode", StringUtil.checkNull(data.get("newClassCode")));
								
								setInfo = GetItemAttrList.attrUpdate(commonService, inputData); // insert or update
								
							}
						}
						
					}
				} // while 문 끝

			}
		}	
	}
	
	/**
	 * 속성 업데이트시 읽어들인 템플릿의 정보를 DB에 저장
	 * 
	 * @param map
	 * @throws Exception
	 */
	private void updateItemAttr(Map map) throws Exception {
		
		String itemId = "";
		String itemTypeCode = StringUtil.checkNull(map.get("itemTypeCode"));
		String userId = StringUtil.checkNull(map.get("userId"));
		Map commandMap = new HashMap();
		
		for (int r = 0; r < NumberUtil.getIntValue(map.get("rowCount")); r++) {
			Map data = fetchRowData(map, r);
			Map inputData = new HashMap();
			Map updateData = new HashMap();
			String setInfo = "";
			
			if (data !=null && data.size() > 0) {
				itemId = StringUtil.checkNull(data.get("newParentIdentifier"));
				commandMap = new HashMap();
				commandMap.put("s_itemID", itemId);
				commandMap.put("languageID", StringUtil.checkNull(map.get("selectedLang")));
				
				/* 업로드 옵션에서 [ItemID]를 기준으로 데이터 업데이트 */
				if (map.get("uploadOption").equals("1")) {
					if (!StringUtil.checkNull(data.get("newIdentifier")).isEmpty()) {
						updateData.put("Identifier", data.get("newIdentifier"));
					}
				} else {
					commandMap = new HashMap();
					commandMap.put("Identifier", data.get("newIdentifier"));
					commandMap.put("ItemTypeCode", itemTypeCode);
					itemId = StringUtil.checkNull(commonService.selectString("report_SQL.getItemIdWithIdentifier", commandMap));
					commandMap.put("s_itemID", itemId);
				}
				
				// 해당 row의 classcode 취득
				String classCode = commonService.selectString("item_SQL.selectedItemClassCode", commandMap);
					
				// 해당 classcode의 [] 의 AttributeCode 취득
				Map setMap = new HashMap();
				setMap.put("s_itemID", itemId);
				List allocatedAttrList = commonService.selectList("report_SQL.itemAttributesInfo", setMap);
				Map allocatedAttrMap = new HashMap();
				Map allocatedAttrHtmlMap = new HashMap();
				allocatedAttrMap.put("AT00001", "Text");
				for (int i = 0; allocatedAttrList.size() > i ; i++) {
					Map attrMap = (Map) allocatedAttrList.get(i);
					allocatedAttrMap.put(attrMap.get("AttrTypeCode"), attrMap.get("DataType"));
					allocatedAttrHtmlMap.put(attrMap.get("AttrTypeCode"), attrMap.get("HTML"));
				}
				
				// [TB_ITEM] update
				updateData.put("ItemID", itemId);
				/* 2015/04/15 변경관리 처리 변경 적용
				String itemStatus = commonService.selectString("project_SQL.getItemStatus", commandMap);
				// 취득된 Item status가 "REL" 이면 ItemStatus를 "MOD1"으로 변경
				if ("REL".equals(itemStatus)) {
					updateData.put("Status", "MOD1");
				}*/ 
				updateData.put("LastUser", userId);
				String itemCnt = StringUtil.checkNull(commonService.selectString("item_SQL.getItemCount", updateData));
				
				if(Integer.parseInt(itemCnt) == 1){ // itemID 있으면 update 진행 -->> itemID == 1 일때만
					if (!StringUtil.checkNull(data.get("newIdentifier")).isEmpty()) {
						update("item_SQL.updateItem", updateData);			
					}
					// 해당 아이템의 classcode가 allocation된 attrbutecode만 insert or update
					// [TB_ITEM_ATTR] update : DB에 해당 데이터가 존재할경우 update, 존재 하지 않은 경우 insert
					// 5번째 칼럽부터 AttrTypeCode가 설정 되어 있음
					String delMlovYN = "N";
					Iterator<String> iterator = data.keySet().iterator();
					while (iterator.hasNext()) {
						String attrTypeCode = "";
						String plainText = "";
						String key = StringUtil.checkNull((String) iterator.next());
						String [] vals = StringUtil.checkNull(data.get(key)).split("[::]");
							 
						if (vals.length > 0) {
							attrTypeCode = vals[0];
							// 해당 아이템의 classcode가 allocation된 attrbutecode만 insert or update
							if (allocatedAttrMap.containsKey(attrTypeCode)) {
								for (int j = 1; j < vals.length; j++) {
									plainText = plainText + vals[j];
								}
								
								inputData = new HashMap();
								// DataType = Date or Lov 일때, 값 정합성 체크
								if ("Date".equals(StringUtil.checkNull(allocatedAttrMap.get(attrTypeCode)))) {
									plainText = DateUtil.isValidDate(plainText.replace("-", "").replace("/", ""));
									if (!plainText.isEmpty()) {
										plainText = DateUtil.getDateCalc(plainText, 0, "");
	
									}
								}
								if ("LOV".equals(StringUtil.checkNull(allocatedAttrMap.get(attrTypeCode)))) {
									inputData.put("getLovCode", "Y");
									inputData.put("Value", plainText);
									if(plainText.isEmpty()){
										Map setData = new HashMap();
										setData.put("ItemID", itemId);
										setData.put("AttrTypeCode", attrTypeCode);
										setData.put("languageID", StringUtil.checkNull(map.get("selectedLang")));
										delete("attr_SQL.delItemAttr", setData);
										
										inputData.remove("getLovCode");
									}
								}		
								
								if ("MLOV".equals(StringUtil.checkNull(allocatedAttrMap.get(attrTypeCode)))) {
									inputData.put("getMLovCode", "Y");
									inputData.put("Value", plainText);
									if(delMlovYN.equals("N")){ // MLOV 첫번쨰 저장시 기존 data 삭제
										Map setData = new HashMap();
										setData.put("ItemID", itemId);
										setData.put("AttrTypeCode", attrTypeCode);
										setData.put("languageID", StringUtil.checkNull(map.get("selectedLang")));
										delete("attr_SQL.delItemAttr", setData);
										delMlovYN = "Y";
										inputData.remove("getLovCode");
									}
								}		
								
								//201610 TEXT Type인 경우
								if ("TEXT".equals(StringUtil.toUpperCase(StringUtil.checkNull(allocatedAttrMap.get(attrTypeCode))))) {
									if (!plainText.isEmpty()) {
										//201610 HTML=1인 경우									
										if("1".equals(StringUtil.checkNull(allocatedAttrHtmlMap.get(attrTypeCode)))){
											plainText = plainText.replaceAll("&&rn", "<br/>");
										}else{
											plainText = plainText.replaceAll("&&rn", "\r\n");
										}
									}							
								}
								
								// if (!plainText.isEmpty() && !itemId.isEmpty()) {
								if (!itemId.isEmpty()) { // plainText 빈칸이면 삭제되도록
									inputData.put("ItemID", itemId);
									inputData.put("AttrTypeCode", attrTypeCode);
									inputData.put("PlainText", plainText);
									inputData.put("languageID", StringUtil.checkNull(map.get("selectedLang")));
									inputData.put("ItemTypeCode", itemTypeCode);
									inputData.put("ClassCode", classCode);
									inputData.put("sessionDefLanguageID", map.get("sessionDefLanguageID"));
									setInfo = GetItemAttrList.attrUpdate(commonService, inputData); // insert or update
									
								}
							}
							
						}
					} // while 문 끝
				} // if( itemCnt > 0) 끝
			}
		}	
	}
	
	/**
	 * 관련항목 매핑시 읽어들인 템플릿의 정보를 DB에 저장
	 * 
	 * @param map
	 * @throws Exception
	 */
	private void insertNewConnetionItem(Map map) throws Exception {
		
		String itemId = "";
		String fromItemId = "";
		String toItemId = "";
		String companyID = StringUtil.checkNull(map.get("companyID"));
		String ownerTeamID = StringUtil.checkNull(map.get("OwnerTeamID"));	
		String userId = StringUtil.checkNull(map.get("userId"));
		String csrId = StringUtil.checkNull(map.get("csrInfo"));
		for (int r = 0; r < NumberUtil.getIntValue(map.get("rowCount")); r++) {
			Map data = fetchRowData(map, r);
			Map inputData = new HashMap();
			Map commandMap = new HashMap();
			if (data !=null && data.size() > 0) {
				
				if (map.get("uploadOption").equals("1")) {
					itemId =  selectString("item_SQL.getItemMaxID", data);
					/* 업로드 옵션에서 [ItemID]를 선택한경우 */
					fromItemId = data.get("newFromItemId").toString();
					toItemId = data.get("newToItemId").toString();
					// [TB_ITEM]에 데이터 insert(연결 ITEM)
					inputData.put("Version", "1");
					inputData.put("Deleted", "0");
					inputData.put("Creator", userId);
					inputData.put("CompanyID", companyID);
					inputData.put("OwnerTeamId", ownerTeamID);
					inputData.put("CategoryCode", "CN");
					inputData.put("ClassCode", data.get("newConnectionClassCode"));
					commandMap.put("ClassCode", data.get("newConnectionClassCode"));
					inputData.put("ItemTypeCode", StringUtil.checkNull(commonService.selectString("item_SQL.getItemTypeCodeFromClassCode", commandMap)));
					inputData.put("FromItemID", fromItemId);
					inputData.put("ToItemID", toItemId);
					inputData.put("ItemID", itemId);
					inputData.put("Identifier", null);
					inputData.put("AuthorID", userId);
					inputData.put("ProjectID", csrId);
					inputData.put("Status", "NEW1");
					insert("item_SQL.insertItem", inputData);		
				} else {
					/* 업로드 옵션에서 [Identifier]를 선택한경우 */
					
					commandMap.put("Identifier", data.get("newFromItemId"));
					commandMap.put("ClassCode", data.get("newFromClassCode"));
					//fromItemId = 
					List fromItemIdList = commonService.selectList("report_SQL.getItemIdWithIdentifierList", commandMap);
					commandMap.put("Identifier", data.get("newToItemId"));
					commandMap.put("ClassCode", data.get("newToClassCode"));
					toItemId = StringUtil.checkNull(commonService.selectString("report_SQL.getItemIdWithIdentifier", commandMap));
					
					for (int i = 0; fromItemIdList.size() > i ; i++) {
						
						Map fromItemIdMap = (Map) fromItemIdList.get(i);
						
						if (!toItemId.isEmpty()) {
							itemId =  selectString("item_SQL.getItemMaxID", data);
							// [TB_ITEM]에 데이터 insert(연결 ITEM)
							inputData.put("Version", "1");
							inputData.put("Deleted", "0");
							inputData.put("Creator", userId);
							inputData.put("CompanyID", companyID);
							inputData.put("OwnerTeamId", ownerTeamID);
							inputData.put("CategoryCode", "CN");							
							inputData.put("ClassCode", data.get("newConnectionClassCode"));
							commandMap.put("ClassCode", data.get("newConnectionClassCode"));
							inputData.put("ItemTypeCode", StringUtil.checkNull(commonService.selectString("item_SQL.getItemTypeCodeFromClassCode", commandMap)));							
							inputData.put("FromItemID", fromItemIdMap.get("ItemID"));
							inputData.put("ToItemID", toItemId);
							inputData.put("ItemID", itemId);
							inputData.put("Identifier", null);
							inputData.put("AuthorID", userId);
							inputData.put("ProjectID", csrId);
							inputData.put("Status", "NEW1");
							insert("item_SQL.insertItem", inputData);		
						}
					}
					
					
				}
				
				
			}
		}	
		update("item_SQL.updateCxnItemCSID", map);	
	}
	
	/**
	 * Dimension Mapping시 읽어들인 템플릿의 정보를 DB에 저장
	 * 
	 * @param map
	 * @throws Exception
	 */
	private void insertDimensionItem(Map map) throws Exception {

		String dimTypeId = "";
		String infoMsg = "";
		int attrTypeColNum = 0;
		
		for (int r = 0; r < NumberUtil.getIntValue(map.get("rowCount")); r++) {
			Map data = fetchRowData(map, r);
			Map inputData = new HashMap();
			Map commandMap = new HashMap();
			if (data !=null && data.size() > 0) {
				
				if (r == 0) {
					/* [TB_DIM_VALUE].[TB_DIM_VALUE_TXT] 존재 체크 */
					// [TB_DIM_VALUE].[TB_DIM_VALUE_TXT] 존재 하지 않을시 입력 처리 후, 화면 표시 할 information 메시지 설정 
					
					attrTypeColNum = Integer.parseInt(map.get("ATTR_CNT").toString());
					dimTypeId = StringUtil.checkNull(data.get("newDimTypeIdItemName"));
					String [] dimValueText = StringUtil.checkNull(map.get("headerName")).split("[,]");
					
					for (int dimValueCnt = 1; dimValueCnt < attrTypeColNum; dimValueCnt ++) {
						commandMap.put("DimTypeID", dimTypeId);
						commandMap.put("DimValueID", data.get("newDimValue" + dimValueCnt));
						commandMap.put("Name", dimValueText[dimValueCnt]);
						
						// [TB_DIM_VALUE]
						String cnt = StringUtil.checkNull(commonService.selectString("dim_SQL.isExistDimValue", commandMap));
						if (cnt.equals("0")) {
							infoMsg = infoMsg + "DimValueID "+data.get("newDimValue" + dimValueCnt)+" not exist";
						}
						/*if (cnt.equals("0")) { // SKIP
							inputData = new HashMap();
							inputData.put("DimTypeID", dimTypeId);
							inputData.put("DimValueID", data.get("newDimValue" + dimValueCnt));
							inputData.put("ParentID", 0);
							inputData.put("Level", 1);
							inputData.put("Deleted", 0);
							inputData.put("ClientID", 1);
							
							infoMsg = infoMsg  + "[Table Name:TB_DIM_VALUE]" + ", "+ "DimTypeID:" + dimTypeId + ", "+ "DimValueID:" + data.get("newDimValue" + dimValueCnt) + "]";
							insert("dim_SQL.insertDimValue", inputData);
						}*/
						
						// [TB_DIM_VALUE_TXT]
						// TB_LANGUAGE의 해당 언어분 INSERT
						List languageList = commonService.selectList("common_SQL.langType_commonSelect", map);
						String msgDisplayFlg = "0";
						for (int j = 0; j < languageList.size(); j++) {
							Map laguageMap = (Map) languageList.get(j);
							commandMap.put("LanguageID", laguageMap.get("CODE"));
							cnt = StringUtil.checkNull(commonService.selectString("dim_SQL.isExistDimValueText", commandMap));							
							/*if (cnt.equals("0")) { // SKIP
								inputData = new HashMap();
								inputData.put("DimValueID", data.get("newDimValue" + dimValueCnt));
								inputData.put("LanguageID", laguageMap.get("CODE"));
								inputData.put("DimTypeID", dimTypeId);
								inputData.put("Name", dimValueText[dimValueCnt]);
								insert("dim_SQL.insertDimTxt", inputData);
								msgDisplayFlg = "1";
							}*/
						}
						if (!msgDisplayFlg.equals("0")) {
							infoMsg = infoMsg  + "[Table Name:TB_DIM_VALUE_TXT" + ", "+ "DimValueID:" + data.get("newDimValue" + dimValueCnt) + ", "+ "Name:" + dimValueText[dimValueCnt] + "]";
						}
					}
					
					if (!infoMsg.isEmpty()) {
						infoMsg = "  (등록된 데이터정보:" + infoMsg + ")";
						map.put("infoMsg", infoMsg);
					}
					
				} else {
					for (int dimValueCnt = 1; dimValueCnt < attrTypeColNum; dimValueCnt ++) {
						if (!StringUtil.checkNull(data.get("newDimValue" + dimValueCnt)).isEmpty()) {
							
							String itemID = StringUtil.checkNull(data.get("newItemTypeId"));
							
							if (!map.get("uploadOption").equals("1")) {
								/* 업로드 옵션에서 [Identifier]를 선택한경우 */
								commandMap.put("Identifier", itemID);
								itemID = StringUtil.checkNull(commonService.selectString("report_SQL.getItemIdWithIdentifier", commandMap));
							}
							
							commandMap.put("DimTypeID", dimTypeId);
							commandMap.put("DimValueID", data.get("newDimValue" + dimValueCnt));	
							commandMap.put("itemID", itemID);
							String itemDimCNT = StringUtil.checkNull(commonService.selectString("dim_SQL.getCNTItemDim", commandMap)); // ITEM_DIM 중복체크 조회용
							
							if(!itemID.equals("") && itemDimCNT.equals("0")){
								// ItemID의 ItemTypeCode, ClassCode 취득 
								commandMap.put("ItemID", itemID);  
								List itemInfoList = (List) commonService.selectList("dim_SQL.getItemTypeCodeAndClassCode", commandMap);
								Map itemInfoMap = (Map) itemInfoList.get(0);
								String itemTypeCode = itemInfoMap.get("ItemTypeCode").toString();
								String itemClassCode = itemInfoMap.get("ClassCode").toString();
						       							
								/* [TB_ITEM_DIM]에 데이터 insert */
								inputData = new HashMap();
								inputData.put("ItemTypeCode", itemTypeCode);
								inputData.put("ItemClassCode", itemClassCode);
								inputData.put("ItemID", itemID);
								inputData.put("DimTypeID", dimTypeId);
								inputData.put("DimValueID", data.get("newDimValue" + dimValueCnt));
								insert("dim_SQL.insertItemDim", inputData);
							}
					       
							/* [TB_ITEM_DIM_TREE]에 데이터 insert */
							// Connection ItemID 취득, NodeID 설정
							//List<String> connectionIdList = new ArrayList<String>();
					       
							//DimTreeAdd.getOverConnectionId(commonService, itemID, dimTypeId, data.get("newDimValue" + dimValueCnt).toString(), connectionIdList, 0);
							//DimTreeAdd.getUnderConnectionId(commonService, itemID, connectionIdList);
					       
							// connectionId list분, TB_ITEM_DIM_TREE record 입력
							// 단, 이미 존재하는 record 인 경우, INSERT skip
							//DimTreeAdd.insertToTbItemDimTree(commonService, connectionIdList, inputData);
						}
					}
				}
			}
		}	
	}
	
	/**
	 * CBO List 업로드시 읽어들인 템플릿의 정보를 DB에 저장
	 * 
	 * @param map
	 * @throws Exception
	 */
	private void insertNewCBOList(Map map) throws Exception {
		
		String itemId = "";
		String parentItemId = "";
		String categoryCode = "";
		String companyID = StringUtil.checkNull(map.get("companyID"));
		String ownerTeamID = StringUtil.checkNull(map.get("OwnerTeamID"));	
		String userId = StringUtil.checkNull(map.get("userId"));
		String itemTypeCode = StringUtil.checkNull(map.get("itemTypeCode"));
		String itemTypeCodeCN = StringUtil.checkNull(map.get("itemTypeCodeCN"));
		
		List languageList = commonService.selectList("common_SQL.langType_commonSelect", map);
		
		for (int r = 0; r < NumberUtil.getIntValue(map.get("rowCount")); r++) {
			Map data = fetchRowData(map, r);
			Map inputData = new HashMap();
			if (data !=null && data.size() > 0) {
				
				categoryCode = itemTypeCode.substring(0, 2);
				itemId =  selectString("item_SQL.getItemMaxID", data);
				
				/* 공통 내용 */
				inputData.put("Version", "1");
				inputData.put("Deleted", "0");
				inputData.put("Creator", userId);
				inputData.put("CompanyID", companyID);
				inputData.put("OwnerTeamId", ownerTeamID);
				
				// TODO : parent Item을 Insert(삭제)
				/*
				if (r == 0) {
					parentItemId = StringUtil.checkNull(map.get("s_itemID"));
					
					//  [TB_ITEM]에 데이터 insert
					inputData.put("CategoryCode", categoryCode); 
					inputData.put("ClassCode", "CL04003");
					inputData.put("FromItemID", null);
					inputData.put("ToItemID", null); 
					inputData.put("ItemID", itemId);
					inputData.put("ItemTypeCode", itemTypeCode);
					inputData.put("Identifier", StringUtil.checkNull(data.get("newParentIdentifier")));
		            
					insert("item_SQL.insertItem", inputData);
					
					// [TB_ITEM]에 데이터 insert(연결 ITEM)
					inputData.put("CategoryCode", "ST1"); //ST2:관련항목
					inputData.put("ClassCode", "NL00000");
					inputData.put("FromItemID", parentItemId);
					inputData.put("ToItemID", itemId);
					inputData.put("ItemID", (selectString("item_SQL.getItemMaxID", data)));
					inputData.put("Identifier", null);
					inputData.put("ItemTypeCode", itemTypeCodeCN);
					
					insert("item_SQL.insertItem", inputData);
					
					// [TB_ITEM_ATTR]에 데이터 insert
					// TODO :
					for (int j = 0; j < languageList.size(); j++) {
						Map laguageMap = (Map) languageList.get(j);
						
						inputData.put("ItemID", itemId);
						inputData.put("AttrTypeCode", "AT00001");
						inputData.put("PlainText", StringUtil.checkNull(data.get("newParentIdentifier")));
						inputData.put("languageID", laguageMap.get("CODE"));
						inputData.put("ItemTypeCode", itemTypeCode);
						inputData.put("ClassCode", "CL04003");
								
						insert("item_SQL.ItemAttr", inputData);
					}
					
					// MAX ItemId를 취득
					parentItemId = itemId;
					itemId =  selectString("item_SQL.getItemMaxID", data);
				}
				*/
				
				// TODO : Parent ItemId 취득
				parentItemId = StringUtil.checkNull(map.get("s_itemID"));
				
				//  [TB_ITEM]에 데이터 insert
				inputData.put("CategoryCode", categoryCode); 
				inputData.put("ClassCode", "CL04005");
				inputData.put("FromItemID", null);
				inputData.put("ToItemID", null); 
				inputData.put("ItemID", itemId);
				inputData.put("ItemTypeCode", itemTypeCode);
				inputData.put("Identifier", StringUtil.checkNull(data.get("newCBOId")));
	            
				insert("item_SQL.insertItem", inputData);
				
				// [TB_ITEM]에 데이터 insert(연결 ITEM)
				inputData.put("CategoryCode", "ST1"); //ST2:관련항목
				inputData.put("ClassCode", "NL00000");
				inputData.put("FromItemID", parentItemId);
				inputData.put("ToItemID", itemId);
				inputData.put("ItemID", (selectString("item_SQL.getItemMaxID", data)));
				inputData.put("Identifier", null);
				inputData.put("ItemTypeCode", itemTypeCodeCN);
				
				insert("item_SQL.insertItem", inputData);		
				
				// PlainText칼럼만큼  [TB_ITEM_ATTR]에 데이터 insert
				// 공통 칼럼
				inputData.put("ItemID", itemId);
				inputData.put("ItemTypeCode", itemTypeCode);
				inputData.put("ClassCode", "CL04005");
				
				/* 개발항목 : AT00001 */
				String plainText = StringUtil.checkNull(data.get("newName"));
				String attrTypeCode = "AT00001";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* Process ID : AT00061 */
				plainText = StringUtil.checkNull(data.get("newProcessID"));
				attrTypeCode = "AT00061";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* Process 명 : AT00062 */
				plainText = StringUtil.checkNull(data.get("newItemName"));
				attrTypeCode = "AT00062";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* CBO Type : AT00063 */
				plainText = StringUtil.checkNull(data.get("newCBOType"));
				attrTypeCode = "AT00063";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* 개발유형 : AT00064 */
				plainText = StringUtil.checkNull(data.get("newCatagory"));
				attrTypeCode = "AT00064";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* 개발대상SAP : AT00065 */
				plainText = StringUtil.checkNull(data.get("newDSAP"));
				attrTypeCode = "AT00065";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* 사용기간 : AT00066 */
				plainText = StringUtil.checkNull(data.get("newPeriod"));
				attrTypeCode = "AT00066";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* 난이도 : AT00067 */
				plainText = StringUtil.checkNull(data.get("newDifficulty"));
				attrTypeCode = "AT00067";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* 중요도 : AT00068 */
				plainText = StringUtil.checkNull(data.get("newImportance"));
				attrTypeCode = "AT00068";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* 우선순위 : AT00069 */
				plainText = StringUtil.checkNull(data.get("newPriority"));
				attrTypeCode = "AT00069";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* 개발공수 : AT00070 */
				plainText = StringUtil.checkNull(data.get("newProductionCosts"));
				attrTypeCode = "AT00070";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* 관련시스템 : AT00071 */
				plainText = StringUtil.checkNull(data.get("newSystem"));
				attrTypeCode = "AT00071";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* 연관모듈 : AT00072 */
				plainText = StringUtil.checkNull(data.get("newModule"));
				attrTypeCode = "AT00072";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* Program ID : AT00039 */
				plainText = StringUtil.checkNull(data.get("newProgramID"));
				attrTypeCode = "AT00039";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* T-Code : AT00038 */
				plainText = StringUtil.checkNull(data.get("newTCode"));
				attrTypeCode = "AT00038";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* 비고 : AT00075 */
				plainText = StringUtil.checkNull(data.get("newNote"));
				attrTypeCode = "AT00075";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);

			}
		}	
	}
	
	/**
	 * IF Master 업로드시 읽어들인 템플릿의 정보를 DB에 저장
	 * 
	 * @param map
	 * @throws Exception
	 */
	private void insertNewIFMaster(Map map) throws Exception {
		
		String itemId = "";
		String parentItemId = "";
		String categoryCode = "";
		String companyID = StringUtil.checkNull(map.get("companyID"));
		String ownerTeamID = StringUtil.checkNull(map.get("OwnerTeamID"));	
		String userId = StringUtil.checkNull(map.get("userId"));
		String itemTypeCode = StringUtil.checkNull(map.get("itemTypeCode"));
		String itemTypeCodeCN = StringUtil.checkNull(map.get("itemTypeCodeCN"));
		
		List languageList = commonService.selectList("common_SQL.langType_commonSelect", map);
		
		for (int r = 0; r < NumberUtil.getIntValue(map.get("rowCount")); r++) {
			Map data = fetchRowData(map, r);
			Map inputData = new HashMap();
			if (data !=null && data.size() > 0) {
				
				categoryCode = itemTypeCode.substring(0, 2);
				itemId =  selectString("item_SQL.getItemMaxID", data);
				
				/* 공통 내용 */
				inputData.put("Version", "1");
				inputData.put("Deleted", "0");
				inputData.put("Creator", userId);
				inputData.put("CompanyID", companyID);
				inputData.put("OwnerTeamId", ownerTeamID);
				
				// TODO : parent Item을 Insert(삭제)
				/*
				if (r == 0) {
					parentItemId = StringUtil.checkNull(map.get("s_itemID"));
					
					//  [TB_ITEM]에 데이터 insert
					inputData.put("CategoryCode", categoryCode); 
					inputData.put("ClassCode", "CL04003");
					inputData.put("FromItemID", null);
					inputData.put("ToItemID", null); 
					inputData.put("ItemID", itemId);
					inputData.put("ItemTypeCode", itemTypeCode);
					inputData.put("Identifier", StringUtil.checkNull(data.get("newParentIdentifier")));
		            
					insert("item_SQL.insertItem", inputData);
					
					// [TB_ITEM]에 데이터 insert(연결 ITEM)
					inputData.put("CategoryCode", "ST1"); //ST2:관련항목
					inputData.put("ClassCode", "NL00000");
					inputData.put("FromItemID", parentItemId);
					inputData.put("ToItemID", itemId);
					inputData.put("ItemID", (selectString("item_SQL.getItemMaxID", data)));
					inputData.put("Identifier", null);
					inputData.put("ItemTypeCode", itemTypeCodeCN);
					
					insert("item_SQL.insertItem", inputData);
					
					// [TB_ITEM_ATTR]에 데이터 insert
					// TODO :
					inputData.put("ItemID", itemId);
					inputData.put("ItemTypeCode", itemTypeCode);
					inputData.put("ClassCode", "CL04003");
					insertItemAttr(StringUtil.checkNull(data.get("newParentIdentifier")), "AT00001", languageList, inputData);
					
					// MAX ItemId를 취득
					parentItemId = itemId;
					itemId =  selectString("item_SQL.getItemMaxID", data);
				}
				*/
				
				// TODO : ParentItemId 취득
				parentItemId = StringUtil.checkNull(map.get("s_itemID"));
				
				//  [TB_ITEM]에 데이터 insert
				inputData.put("CategoryCode", categoryCode); 
				inputData.put("ClassCode", "CL04006");
				inputData.put("FromItemID", null);
				inputData.put("ToItemID", null); 
				inputData.put("ItemID", itemId);
				inputData.put("ItemTypeCode", itemTypeCode);
				inputData.put("Identifier", StringUtil.checkNull(data.get("newInterfaceID")));
	            
				insert("item_SQL.insertItem", inputData);
				
				// [TB_ITEM]에 데이터 insert(연결 ITEM)
				inputData.put("CategoryCode", "ST1"); //ST2:관련항목
				inputData.put("ClassCode", "NL00000");
				inputData.put("FromItemID", parentItemId);
				inputData.put("ToItemID", itemId);
				inputData.put("ItemID", (selectString("item_SQL.getItemMaxID", data)));
				inputData.put("Identifier", null);
				inputData.put("ItemTypeCode", itemTypeCodeCN);
				
				insert("item_SQL.insertItem", inputData);		
				
				// PlainText칼럼만큼  [TB_ITEM_ATTR]에 데이터 insert
				// 공통 칼럼
				inputData.put("ItemID", itemId);
				inputData.put("ItemTypeCode", itemTypeCode);
				inputData.put("ClassCode", "CL04006");
				
				/* IF 항목명 : AT00001 */
				String plainText = StringUtil.checkNull(data.get("newIfName"));
				String attrTypeCode = "AT00001";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* 그룹명 : AT00076 */
				plainText = StringUtil.checkNull(data.get("newGroupName"));
				attrTypeCode = "AT00076";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* 관리주체 : AT00077 */
				plainText = StringUtil.checkNull(data.get("newKanri"));
				attrTypeCode = "AT00077";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* 단위시스템 : AT00078 */
				plainText = StringUtil.checkNull(data.get("newTani"));
				attrTypeCode = "AT00078";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* 서브시스템 : AT00079 */
				plainText = StringUtil.checkNull(data.get("newSub"));
				attrTypeCode = "AT00079";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* CBO ID : AT00080 */
				plainText = StringUtil.checkNull(data.get("newCboId"));
				attrTypeCode = "AT00080";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* Program ID : AT00039 */
				plainText = StringUtil.checkNull(data.get("newProgramID"));
				attrTypeCode = "AT00039";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* Process ID : AT00061 */
				plainText = StringUtil.checkNull(data.get("newProcessId"));
				attrTypeCode = "AT00061";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* Process Name : AT00062 */
				plainText = StringUtil.checkNull(data.get("newItemName"));
				attrTypeCode = "AT00062";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* Variant : AT00081 */
				plainText = StringUtil.checkNull(data.get("newVariant"));
				attrTypeCode = "AT00081";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* Gap ID : AT00082 */
				plainText = StringUtil.checkNull(data.get("newGapId"));
				attrTypeCode = "AT00082";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* 개발대상 SAP : AT00065 */
				plainText = StringUtil.checkNull(data.get("newDSAP"));
				attrTypeCode = "AT00065";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* 사용기간 : AT00066 */
				plainText = StringUtil.checkNull(data.get("newPeriod"));
				attrTypeCode = "AT00066";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* In/Out : AT00083 */
				plainText = StringUtil.checkNull(data.get("newInOut"));
				attrTypeCode = "AT00083";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* OnLine or Batch : AT00084 */
				plainText = StringUtil.checkNull(data.get("newOnLineOrBatch"));
				attrTypeCode = "AT00084";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* I/F 주기 : AT00085 */
				plainText = StringUtil.checkNull(data.get("newIfPeriod"));
				attrTypeCode = "AT00085";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* ERP : AT00086 */
				plainText = StringUtil.checkNull(data.get("newErp"));
				attrTypeCode = "AT00086";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* RFC Destination : AT00087 */
				plainText = StringUtil.checkNull(data.get("newRfcDestination"));
				attrTypeCode = "AT00087";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* M/W : AT00101 */
				plainText = StringUtil.checkNull(data.get("newMw"));
				attrTypeCode = "AT00101";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* ERP TYPE : AT00089 */
				plainText = StringUtil.checkNull(data.get("newErpType"));
				attrTypeCode = "AT00089";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* M/W Type : AT00090 */
				plainText = StringUtil.checkNull(data.get("newMwType"));
				attrTypeCode = "AT00090";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* Legacy Type : AT00091 */
				plainText = StringUtil.checkNull(data.get("newLegacyType"));
				attrTypeCode = "AT00091";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* ERP담당 : AT00092 */
				plainText = StringUtil.checkNull(data.get("newErpTanto"));
				attrTypeCode = "AT00092";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* M/W담당 : AT00093 */
				plainText = StringUtil.checkNull(data.get("newMwTanto"));
				attrTypeCode = "AT00093";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* Legacy 담당 : AT00094 */
				plainText = StringUtil.checkNull(data.get("newLegacyTanto"));
				attrTypeCode = "AT00094";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* ERP Status : AT00095 */
				plainText = StringUtil.checkNull(data.get("newErpStatus"));
				attrTypeCode = "AT00095";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* M/W Status : AT00096 */
				plainText = StringUtil.checkNull(data.get("newMwStatus"));
				attrTypeCode = "AT00096";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* Legacy Status : AT00097 */
				plainText = StringUtil.checkNull(data.get("newLegacyStatus"));
				attrTypeCode = "AT00097";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* Total Status : AT00098 */
				plainText = StringUtil.checkNull(data.get("newTotalStatus"));
				attrTypeCode = "AT00098";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* 통합테스트 시기 : AT00099 */
				plainText = StringUtil.checkNull(data.get("newTestPeriod"));
				attrTypeCode = "AT00099";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* 고려사항 및 이슈 : AT00100 */
				plainText = StringUtil.checkNull(data.get("newIssue"));
				attrTypeCode = "AT00100";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* 비고 : AT00075 */
				plainText = StringUtil.checkNull(data.get("newNote"));
				attrTypeCode = "AT00075";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);

			}
		}	
	}
	
	
	/**
	 * CBO ListProgram Status 업로드시 읽어들인 템플릿의 정보를 DB에 저장
	 * 
	 * @param map
	 * @throws Exception
	 */
	private void insertCboProgramStatus(Map map) throws Exception {
		
		
		HashMap inputData = new HashMap();
		HashMap setMap = new HashMap();
		String userId = StringUtil.checkNull(map.get("userId"));
		
		for (int r = 0; r < NumberUtil.getIntValue(map.get("rowCount")); r++) {
			Map data = fetchRowData(map, r);
			
			if (data !=null && data.size() > 0) {
				
				// Insert to TB_CHANGE_SET
				HashMap itemInfoMap = new HashMap();
				HashMap userInfoMap = new HashMap();
				HashMap projectMap = new HashMap();
				
				
				String itemID = data.get("newItemId").toString();
				
				setMap.put("s_itemID", itemID);
				setMap.put("userId", userId);
				itemInfoMap  = (HashMap)commonService.select("project_SQL.getItemInfo", setMap);
				userInfoMap  = (HashMap)commonService.select("project_SQL.getUserInfo", setMap);
				
				String projectID = "4";  // TODO : GERP 구축 1단계
				setMap.put("projectID", projectID);
				projectMap  = (HashMap)commonService.select("project_SQL.getProjectCategory", setMap);
				String changeSetID = commonService.selectString("cs_SQL.getMaxChangeSetData", setMap);
						
				inputData.put("ChangeSetID", changeSetID);
				inputData.put("ProjectID", projectID);
				inputData.put("PJTCategory", projectMap.get("PJCategory"));
				inputData.put("ItemID", itemID);
				inputData.put("ItemClassCode", itemInfoMap.get("ClassCode"));
				inputData.put("ItemTypeCode", itemInfoMap.get("ItemTypeCode"));
				inputData.put("AuthorID", userId);
				inputData.put("AuthorName", userInfoMap.get("Name"));
				inputData.put("AuthorTeamID", userInfoMap.get("TeamID"));
				inputData.put("CompanyID", userInfoMap.get("CompanyID"));
				inputData.put("ChangeType", "NEW"); // TODO
				inputData.put("Reason", "ETC"); // TODO
				inputData.put("Status", "APRV1"); // TODO
				
				insert("cs_SQL.insertToChangeSet", inputData);
				
				// Insert to TB_SAP_DEV
				inputData.put("ChangeSetID", changeSetID);
				inputData.put("ItemID", itemID);
				inputData.put("Creator", userId);
				inputData.put("LastUser", userId);
				
				// FD
				inputData.put("ProgramStatus", "PGRSTS1");
				inputData.put("InChargeUser", null);  // TODO
				inputData.put("UTScenarioStatus", null);
				inputData.put("PlannedStartDate", emptyStringToNull(data.get("newFDPlannedStart")));
				inputData.put("PlannedEndDate", emptyStringToNull(data.get("newFDPlannedEnd")));
				inputData.put("ActualStartDate", emptyStringToNull(data.get("newFDActualStart")));
				inputData.put("ActualEndDate", emptyStringToNull(data.get("newFDActualEnd")));
				inputData.put("Status", setStatus(StringUtil.checkNull(data.get("newFDStatus"))));
				
				insert("cs_SQL.insertToChangeSetStep", inputData);
				
				// PG
				inputData.put("ProgramStatus", "PGRSTS2");
				inputData.put("InChargeUser", null);  // TODO
				inputData.put("UTScenarioStatus", null);
				inputData.put("PlannedStartDate", emptyStringToNull(data.get("newPGPlannedStart")));
				inputData.put("PlannedEndDate", emptyStringToNull(data.get("newPGPlannedEnd")));
				inputData.put("ActualStartDate", emptyStringToNull(data.get("newPGActualStart")));
				inputData.put("ActualEndDate", emptyStringToNull(data.get("newPGActualEnd")));
				inputData.put("Status", setStatus(StringUtil.checkNull(data.get("newPGStatus"))));
				
				insert("cs_SQL.insertToChangeSetStep", inputData);
				
				// UT
				inputData.put("ProgramStatus", "PGRSTS3");
				inputData.put("InChargeUser", "1");  // TODO
				inputData.put("UTScenarioStatus", setStatus(StringUtil.checkNull(data.get("newUTScenario"))));
				inputData.put("PlannedStartDate", emptyStringToNull(data.get("newUTPlannedStart")));
				inputData.put("PlannedEndDate", emptyStringToNull(data.get("newUTPlannedEnd")));
				inputData.put("ActualStartDate", emptyStringToNull(data.get("newUTActualStart")));
				inputData.put("ActualEndDate", emptyStringToNull(data.get("newUTActualEnd")));
				inputData.put("Status", setStatus(StringUtil.checkNull(data.get("newUTStatus"))));
				
				insert("cs_SQL.insertToChangeSetStep", inputData);
				
				// TD
				inputData.put("ProgramStatus", "PGRSTS4");
				inputData.put("InChargeUser", null);  // TODO
				inputData.put("UTScenarioStatus", null);
				inputData.put("PlannedStartDate", emptyStringToNull(data.get("newTDPlannedStart")));
				inputData.put("PlannedEndDate", emptyStringToNull(data.get("newTDPlannedEnd")));
				inputData.put("ActualStartDate", emptyStringToNull(data.get("newTDActualStart")));
				inputData.put("ActualEndDate", emptyStringToNull(data.get("newTDActualEnd")));
				inputData.put("Status", setStatus(StringUtil.checkNull(data.get("newTDStatus"))));
				
				insert("cs_SQL.insertToChangeSetStep", inputData);

			}
		}	
	}
	
	/**
	 * IF MasterProgram Status 업로드시 읽어들인 템플릿의 정보를 DB에 저장
	 * 
	 * @param map
	 * @throws Exception
	 */
	private void insertIfProgramStatus(Map map) throws Exception {
		
		
		HashMap inputData = new HashMap();
		HashMap setMap = new HashMap();
		String userId = StringUtil.checkNull(map.get("userId"));
		
		
		
		for (int r = 0; r < NumberUtil.getIntValue(map.get("rowCount")); r++) {
			Map data = fetchRowData(map, r);
			
			if (data !=null && data.size() > 0) {
				
				// Insert to TB_CHANGE_SET
				HashMap itemInfoMap = new HashMap();
				HashMap userInfoMap = new HashMap();
				HashMap projectMap = new HashMap();
				
				
				String itemID = data.get("newItemId").toString();
				
				setMap.put("s_itemID", itemID);
				setMap.put("userId", userId);
				itemInfoMap  = (HashMap)commonService.select("project_SQL.getItemInfo", setMap);
				userInfoMap  = (HashMap)commonService.select("project_SQL.getUserInfo", setMap);
				
				String projectID = "8"; // TODO
				setMap.put("projectID", projectID);
				projectMap  = (HashMap)commonService.select("project_SQL.getProjectCategory", setMap);
				String changeSetID = commonService.selectString("cs_SQL.getMaxChangeSetData", setMap);
						
				inputData.put("ChangeSetID", changeSetID);
				inputData.put("ProjectID", projectID);
				inputData.put("PJTCategory", projectMap.get("PJCategory"));
				inputData.put("ItemID", itemID);
				inputData.put("ItemClassCode", itemInfoMap.get("ClassCode"));
				inputData.put("ItemTypeCode", itemInfoMap.get("ItemTypeCode"));
				inputData.put("AuthorID", userId);
				inputData.put("AuthorName", userInfoMap.get("Name"));
				inputData.put("AuthorTeamID", userInfoMap.get("TeamID"));
				inputData.put("CompanyID", userInfoMap.get("CompanyID"));
				inputData.put("ChangeType", "MOD"); // TODO
				inputData.put("Reason", "IMPR"); // TODO
				inputData.put("Status", "OPN"); // TODO
				
				insert("cs_SQL.insertToChangeSet", inputData);
				
				// Insert to TB_SAP_DEV
				inputData.put("ChangeSetID", changeSetID);
				inputData.put("ItemID", itemID);
				inputData.put("Creator", userId);
				inputData.put("LastUser", userId);
				inputData.put("Status", null); // TODO
				
				// I/F Mapping 정의서 작성
				inputData.put("ProgramStatus", "IFSTS1");
				inputData.put("PlannedStartDate", emptyStringToNull(data.get("newIMPlannedStart")));
				inputData.put("PlannedEndDate", emptyStringToNull(data.get("newIMPlannedEnd")));
				inputData.put("ActualStartDate", emptyStringToNull(data.get("newIMActualStart")));
				
				inputData.put("LegacyPlannedEndDate", null);
				inputData.put("LegacyActualEndDate", emptyStringToNull(data.get("newIMLegacyActualEndDate")));
				inputData.put("EAIEndDate", null);
				inputData.put("MWUtEndDate", null);
				inputData.put("IfMappingName", emptyStringToNull(data.get("newIfMappingName")));
				
				insert("cs_SQL.insertToChangeSetStep", inputData);
				
				// I/F Program 개발
				inputData.put("ProgramStatus", "IFSTS2");
				inputData.put("PlannedStartDate", emptyStringToNull(data.get("newIPPlannedStart")));
				inputData.put("PlannedEndDate", emptyStringToNull(data.get("newIPPlannedEnd")));
				inputData.put("ActualStartDate", emptyStringToNull(data.get("newIPActualStart")));
				inputData.put("ActualEndDate", emptyStringToNull(data.get("newIPActualEnd")));
				
				inputData.put("LegacyPlannedEndDate", emptyStringToNull(data.get("newIPLegacyPlannedEndDate")));
				inputData.put("LegacyActualEndDate", emptyStringToNull(data.get("newIPLegacyActualEndDate")));
				inputData.put("EAIEndDate", emptyStringToNull(data.get("newIPEAIEndDate")));
				inputData.put("MWUtEndDate", null);
				inputData.put("IfMappingName", null);
				
				insert("cs_SQL.insertToChangeSetStep", inputData);
				
				// UT
				inputData.put("ProgramStatus", "IFSTS3");
				inputData.put("PlannedStartDate", emptyStringToNull(data.get("newUtPlannedStart")));
				inputData.put("PlannedEndDate", emptyStringToNull(data.get("newUtPlannedEnd")));
				inputData.put("ActualStartDate", emptyStringToNull(data.get("newUtActualStart")));
				inputData.put("ActualEndDate", emptyStringToNull(data.get("newUtActualEnd")));
				
				inputData.put("LegacyPlannedEndDate", null);
				inputData.put("LegacyActualEndDate", emptyStringToNull(data.get("newUtLegacyActualEndDate")));
				inputData.put("EAIEndDate", null);
				inputData.put("MWUtEndDate", emptyStringToNull(data.get("newUtMWUtEndDate")));
				inputData.put("IfMappingName", null);
				
				insert("cs_SQL.insertToChangeSetStep", inputData);
				
				// IT
				inputData.put("ProgramStatus", "IFSTS4");
				inputData.put("PlannedStartDate", emptyStringToNull(data.get("newITPlannedStart")));
				inputData.put("PlannedEndDate", emptyStringToNull(data.get("newITPlannedEnd")));
				inputData.put("ActualStartDate", emptyStringToNull(data.get("newITActualStart")));
				inputData.put("ActualEndDate", emptyStringToNull(data.get("newITActualEnd")));
				
				inputData.put("LegacyPlannedEndDate", null);
				inputData.put("LegacyActualEndDate", null);
				inputData.put("EAIEndDate", null);
				inputData.put("MWUtEndDate", null);
				inputData.put("IfMappingName", null);
				
				insert("cs_SQL.insertToChangeSetStep", inputData);

			}
		}	
	}
	
	
	/**
	 * 전사 시스템 목록 업로드시 읽어들인 템플릿의 정보를 DB에 저장
	 * 
	 * @param map
	 * @throws Exception
	 */
	private void insertWholeCompanySystemItem(Map map) throws Exception {
		
		String itemId = "";
		String parentItemId = "";
		
		String plainText = "";
		String attrTypeCode = "";
		String systemGroup = ""; // 시스템 그룹
		String parentIdTani = ""; // 단위 시스템
		
		Map<String, String> systemGroupMap = new HashMap<String, String>(); // 시스템 그룹 Map
		
		String categoryCode = "";
		String companyID = StringUtil.checkNull(map.get("companyID"));
		String ownerTeamID = StringUtil.checkNull(map.get("OwnerTeamID"));	
		String userId = StringUtil.checkNull(map.get("userId"));
		String itemTypeCode = StringUtil.checkNull(map.get("itemTypeCode"));
		String itemTypeCodeCN = StringUtil.checkNull(map.get("itemTypeCodeCN"));
		
		List languageList = commonService.selectList("common_SQL.langType_commonSelect", map);
		
		for (int r = 0; r < NumberUtil.getIntValue(map.get("rowCount")); r++) {
			Map data = fetchRowData(map, r);
			Map inputData = new HashMap();
			if (data !=null && data.size() > 0) {
				
				categoryCode = itemTypeCode.substring(0, 2);
				itemId =  selectString("item_SQL.getItemMaxID", data);
				
				/* 공통 내용 */
				inputData.put("Version", "1");
				inputData.put("Deleted", "0");
				inputData.put("Creator", userId);
				inputData.put("CompanyID", companyID);
				inputData.put("OwnerTeamId", ownerTeamID);
				
				// 단위 시스템 단위로 데이터를 insert
				if (!StringUtil.checkNull(data.get("newParentIdentifier")).isEmpty()) {
					
					if (!systemGroup.equals(StringUtil.checkNull(data.get("newParentIdentifier")))) {
						// 시스템 그룹 명 치환
						systemGroup = StringUtil.checkNull(data.get("newParentIdentifier"));
						
						// 시스템 그룹의 맵에 읽어 들인 시스템 그룹의 존재 여부를 판단
						boolean isExistParent = false;
						Iterator<String> iterator = systemGroupMap.keySet().iterator();
						while (iterator.hasNext()) {
							String key = StringUtil.checkNull((String) iterator.next());
							
							if (key.equals(StringUtil.checkNull(data.get("newParentIdentifier")))) {
								isExistParent= true;
								parentIdTani = systemGroupMap.get(key);
								break;
							}
						}
						
						if (!isExistParent) {
							// 시스템 그룹 Map
							systemGroupMap.put(systemGroup, itemId);
							
							/* 1. parent Item을 Insert */
							parentItemId = StringUtil.checkNull(map.get("s_itemID"));
							
							//  [TB_ITEM]에 데이터 insert
							inputData.put("CategoryCode", categoryCode); 
							inputData.put("ClassCode", "CL04001");
							inputData.put("FromItemID", null);
							inputData.put("ToItemID", null); 
							inputData.put("ItemID", itemId);
							inputData.put("ItemTypeCode", itemTypeCode);
							inputData.put("Identifier", StringUtil.checkNull(data.get("newParentIdentifier")));
				            
							insert("item_SQL.insertItem", inputData);
							
							// [TB_ITEM]에 데이터 insert(연결 ITEM)
							inputData.put("CategoryCode", "ST1"); //ST2:관련항목
							inputData.put("ClassCode", "NL00000");
							inputData.put("FromItemID", parentItemId);
							inputData.put("ToItemID", itemId);
							inputData.put("ItemID", (selectString("item_SQL.getItemMaxID", data)));
							inputData.put("Identifier", null);
							inputData.put("ItemTypeCode", itemTypeCodeCN);
							
							insert("item_SQL.insertItem", inputData);
							
							// [TB_ITEM_ATTR]에 데이터 insert
							inputData.put("ItemID", itemId);
							inputData.put("ItemTypeCode", itemTypeCode);
							inputData.put("ClassCode", "CL04001");
							
							/* 개발항목 : AT00001 */
							plainText = StringUtil.checkNull(data.get("newParentIdentifier"));
							attrTypeCode = "AT00001";
							insertItemAttr(plainText, attrTypeCode, languageList, inputData);
							
							// MAX ItemId 취득
							parentIdTani = itemId;
							itemId =  selectString("item_SQL.getItemMaxID", data);
						}
						
					}
					
					/* 2. 단위 시스템 Item insert*/
					//  [TB_ITEM]에 데이터 insert
					inputData.put("CategoryCode", categoryCode); 
					inputData.put("ClassCode", "CL04002");
					inputData.put("FromItemID", null);
					inputData.put("ToItemID", null); 
					inputData.put("ItemID", itemId);
					inputData.put("ItemTypeCode", itemTypeCode);
					inputData.put("Identifier", null);
		            
					insert("item_SQL.insertItem", inputData);
					
					// [TB_ITEM]에 데이터 insert(연결 ITEM)
					inputData.put("CategoryCode", "ST1"); //ST2:관련항목
					inputData.put("ClassCode", "NL00000");
					inputData.put("FromItemID", parentIdTani);
					inputData.put("ToItemID", itemId);
					inputData.put("ItemID", (selectString("item_SQL.getItemMaxID", data)));
					inputData.put("Identifier", null);
					inputData.put("ItemTypeCode", itemTypeCodeCN);
					
					insert("item_SQL.insertItem", inputData);
					
					// [TB_ITEM_ATTR]에 데이터 insert
					inputData.put("ItemID", itemId);
					inputData.put("ItemTypeCode", itemTypeCode);
					inputData.put("ClassCode", "CL04002");
					
					/* 단위시스템영문 : AT00102 */
					plainText = StringUtil.checkNull(data.get("newTaniSystemE"));
					attrTypeCode = "AT00102";
					insertItemAttr(plainText, attrTypeCode, languageList, inputData);
					
					/* 단위시스템한글 : AT00001 */
					plainText = StringUtil.checkNull(data.get("newTaniSystemK"));
					attrTypeCode = "AT00001";
					insertItemAttr(plainText, attrTypeCode, languageList, inputData);
					
					/* 시스템 설명 : AT00003 */
					plainText = StringUtil.checkNull(data.get("newSystemOverview"));
					attrTypeCode = "AT00003";
					insertItemAttr(plainText, attrTypeCode, languageList, inputData);
					
					/* 구축시기 : AT00103 */
					plainText = StringUtil.checkNull(data.get("newDate"));
					attrTypeCode = "AT00103";
					insertItemAttr(plainText, attrTypeCode, languageList, inputData);
					
					/* 현업 부서 : AT00104 */
					plainText = StringUtil.checkNull(data.get("newGenPart"));
					attrTypeCode = "AT00104";
					insertItemAttr(plainText, attrTypeCode, languageList, inputData);
					
					/* 사용자 수 : AT00105 */
					plainText = StringUtil.checkNull(data.get("newUserNum"));
					attrTypeCode = "AT00105";
					insertItemAttr(plainText, attrTypeCode, languageList, inputData);
					
					/* HIDM 적용 : AT00106 */
					plainText = StringUtil.checkNull(data.get("newHidm"));
					attrTypeCode = "AT00106";
					insertItemAttr(plainText, attrTypeCode, languageList, inputData);
					
					/* SSO 적용 : AT00107 */
					plainText = StringUtil.checkNull(data.get("newSso"));
					attrTypeCode = "AT00108";
					insertItemAttr(plainText, attrTypeCode, languageList, inputData);
					
					// MAX ItemId 취득
					parentItemId = itemId;
					itemId =  selectString("item_SQL.getItemMaxID", data);
					
				}
				
				/* 3. 서브 시스템 Item insert*/
				//  [TB_ITEM]에 데이터 insert
				inputData.put("CategoryCode", categoryCode); 
				inputData.put("ClassCode", "CL04003");
				inputData.put("FromItemID", null);
				inputData.put("ToItemID", null); 
				inputData.put("ItemID", itemId);
				inputData.put("ItemTypeCode", itemTypeCode);
				inputData.put("Identifier", null);
	            
				insert("item_SQL.insertItem", inputData);
				
				// [TB_ITEM]에 데이터 insert(연결 ITEM)
				inputData.put("CategoryCode", "ST1"); //ST2:관련항목
				inputData.put("ClassCode", "NL00000");
				inputData.put("FromItemID", parentItemId);
				inputData.put("ToItemID", itemId);
				inputData.put("ItemID", (selectString("item_SQL.getItemMaxID", data)));
				inputData.put("Identifier", null);
				inputData.put("ItemTypeCode", itemTypeCodeCN);
				
				insert("item_SQL.insertItem", inputData);		
				
				// PlainText칼럼만큼  [TB_ITEM_ATTR]에 데이터 insert
				// 공통 칼럼
				inputData.put("ItemID", itemId);
				inputData.put("ItemTypeCode", itemTypeCode);
				inputData.put("ClassCode", "CL04003");
				
				/* 서브시스템 영문 : AT00102 */
				plainText = StringUtil.checkNull(data.get("newSubSystemE"));
				attrTypeCode = "AT00102";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* 서브시스템 한글 : AT00001 */
				plainText = StringUtil.checkNull(data.get("newSubSystemK"));
				attrTypeCode = "AT00001";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* 업무영역 : AT00108 */
				plainText = StringUtil.checkNull(data.get("newWorkArea"));
				attrTypeCode = "AT00108";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* 그룹 : AT00076 */
				plainText = StringUtil.checkNull(data.get("newGroup"));
				attrTypeCode = "AT00076";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* 운영팀 : AT00109 */
				plainText = StringUtil.checkNull(data.get("newUneiTeam"));
				attrTypeCode = "AT00109";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* 운영파트 : AT00110 */
				plainText = StringUtil.checkNull(data.get("newUneiPart"));
				attrTypeCode = "AT00110";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* PL : AT00111 */
				plainText = StringUtil.checkNull(data.get("newPL"));
				attrTypeCode = "AT00111";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* IT담당자 : AT00112 */
				plainText = StringUtil.checkNull(data.get("newItTanto"));
				attrTypeCode = "AT00112";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* 신규SM담당자 : AT00113 */
				plainText = StringUtil.checkNull(data.get("newNewSmTanto"));
				attrTypeCode = "AT00113";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* 기존SM담당자 : AT00114 */
				plainText = StringUtil.checkNull(data.get("newOldSmTamto"));
				attrTypeCode = "AT00114";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* 서비스 범위(본사) : AT00115 */
				plainText = StringUtil.checkNull(data.get("newService1"));
				attrTypeCode = "AT00115";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* 서비스 범위(법인) : AT00116 */
				plainText = StringUtil.checkNull(data.get("newService2"));
				attrTypeCode = "AT00116";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* 서비스 범위(기타) : AT00117 */
				plainText = StringUtil.checkNull(data.get("newService3"));
				attrTypeCode = "AT00117";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
				/* URL : AT00006 */
				plainText = StringUtil.checkNull(data.get("newUrl"));
				attrTypeCode = "AT00006";
				insertItemAttr(plainText, attrTypeCode, languageList, inputData);
				
			}
		}	
	}
	

	private void insertItemAttr(String plainText, String attrTypeCode, List languageList, Map inputData) throws Exception {
		
		if (!plainText.isEmpty()) {
			
			// TB_LANGUAGE의 해당 언어분 INSERT
			for (int j = 0; j < languageList.size(); j++) {
				Map laguageMap = (Map) languageList.get(j);
				inputData.put("AttrTypeCode", attrTypeCode);
				inputData.put("PlainText", plainText);
				inputData.put("languageID", laguageMap.get("CODE"));
						
				// [TB_ITEM_ATTR]에 데이터 insert
				insert("item_SQL.ItemAttr", inputData);
			}
			
		}
	}
	
	/**
	 * Item Team Mapping시 읽어들인 템플릿의 정보를 DB에 저장
	 * 
	 * @param map
	 * @throws Exception
	 */
	private void insertTeamRole(Map map) throws Exception {
		
		String itemID = "";
		String identifier = "";
		String teamCode = "";
		String teamID = "";
		String userId = StringUtil.checkNull(map.get("userId"));
		String teamRoleCat = "";
		String teamRoleType = "";
		List teamRoleList = new ArrayList();
		
		for (int r = 0; r < NumberUtil.getIntValue(map.get("rowCount")); r++) {
			Map data = fetchRowData(map, r);
			Map inputData = new HashMap();
			Map setData = new HashMap();
			if (data !=null && data.size() > 0) {
				
				teamCode = StringUtil.checkNull(data.get("TeamCode"));
				teamRoleCat = StringUtil.checkNull(data.get("TeamRoleCategory"));
				teamRoleType = StringUtil.checkNull(data.get("RoleTypeCode"));
				
				if (map.get("uploadOption").equals("1")) {
					/* 업로드 옵션에서 [ItemID]를 선택한경우 */
					itemID = StringUtil.checkNull(data.get("ItemID"));
					setData.put("teamCode", teamCode);
					teamID = StringUtil.checkNull(selectString("organization_SQL.getTeamIDFromTeamCode",setData ));
								
					inputData.put("itemID", itemID);
					inputData.put("teamID", teamID);
					inputData.put("teamCode", teamCode);
					inputData.put("teamRoleCat", teamRoleCat);
					inputData.put("teamRoleType", teamRoleType);
					inputData.put("assigned", "1");
					inputData.put("creator", userId);
					
					teamRoleList = selectList("role_SQL.getTeamRoleIDList", inputData);
					if(teamRoleList.size()==0 && !teamID.equals("")){		
						insert("role_SQL.insertTeamRole", inputData);
					}	
				} else {
					/* 업로드 옵션에서 [Identifier]를 선택한경우 */
					identifier = StringUtil.checkNull(data.get("Identifier"));
					if(!identifier.equals("")){
						setData.put("Identifier", identifier);
						itemID = StringUtil.checkNull(selectString("report_SQL.getItemIdWithIdentifier", setData));
						
						
						setData.put("teamCode", teamCode);
						teamID = StringUtil.checkNull(selectString("organization_SQL.getTeamIDFromTeamCode",setData ));
									
						inputData.put("itemID", itemID);
						inputData.put("teamID", teamID);
						inputData.put("teamCode", teamCode);
						inputData.put("teamRoleCat", teamRoleCat);
						inputData.put("teamRoleType", teamRoleType);
						inputData.put("assigned", "1");
						inputData.put("creator", userId);
						
						teamRoleList = selectList("role_SQL.getTeamRoleIDList", inputData);
						if(teamRoleList.size()==0 && !teamID.equals("")){		
							insert("role_SQL.insertTeamRole", inputData);
						}	
					}
				}				
			}
		}	
	}
	
	/**
	 * MyItem Member Mapping시 읽어들인 템플릿의 정보를 DB에 저장
	 * 
	 * @param map
	 * @throws Exception
	 */
	private void insertMemberRole(Map map) throws Exception {
		
		String itemID = "";
		String identifier = "";
		String employeeNum = "";
		String memberID = "";
		String userId = StringUtil.checkNull(map.get("userId"));
		String assignmentType = "";
		String roleType = "";
		String myItemCnt = "0";
		String clientID = "";
		
		for (int r = 0; r < NumberUtil.getIntValue(map.get("rowCount")); r++) {
			Map data = fetchRowData(map, r);
			Map inputData = new HashMap();
			Map setData = new HashMap();
			if (data !=null && data.size() > 0) {
				
				employeeNum = StringUtil.checkNull(data.get("EmployeeNum"));
				assignmentType = StringUtil.checkNull(data.get("AssignmentType"));
				roleType = StringUtil.checkNull(data.get("RoleType"));
				clientID = StringUtil.checkNull(data.get("ClientID"));
				
				
				if (map.get("uploadOption").equals("1")) {
					/* 업로드 옵션에서 [ItemID]를 선택한경우 */
					itemID = StringUtil.checkNull(data.get("ItemID"));
					setData.put("employeeNum", employeeNum);
					memberID = StringUtil.checkNull(selectString("user_SQL.getMemberIDFromEmpNO",setData ));
										
					setData.put("itemID", itemID);
					setData.put("memberID", memberID);
					setData.put("assignmentType", assignmentType);
					setData.put("roleType", roleType);
					myItemCnt = StringUtil.checkNull(selectString("role_SQL.getMyItemCnt", setData) );
					if(Integer.parseInt(myItemCnt) == 0){					
						inputData.put("itemID", itemID);
						inputData.put("memberID", memberID);
						inputData.put("assignmentType", assignmentType);
						inputData.put("roleType", roleType);
						inputData.put("assigned", "1");
						inputData.put("creator", userId);
						inputData.put("clientID", clientID);
						insert("role_SQL.insertRoleAssignment", inputData);
					}
					
				} else {
					/* 업로드 옵션에서 [Identifier]를 선택한경우 */
					identifier = StringUtil.checkNull(data.get("Identifier"));
					if(!identifier.equals("")){
						setData.put("Identifier", identifier);
						itemID = StringUtil.checkNull(selectString("report_SQL.getItemIdWithIdentifier", setData));
						
						setData.put("employeeNum", employeeNum);
						memberID = StringUtil.checkNull(selectString("user_SQL.getMemberIDFromEmpNO",setData ));
						
						setData.put("itemID", itemID);
						setData.put("memberID", memberID);
						setData.put("assignmentType", assignmentType);
						setData.put("roleType", roleType);
						myItemCnt = StringUtil.checkNull(selectString("role_SQL.getMyItemCnt", setData) );
						if(Integer.parseInt(myItemCnt) == 0){								
							inputData.put("itemID", itemID);
							inputData.put("memberID", memberID);
							inputData.put("assignmentType", assignmentType);
							inputData.put("roleType", roleType);
							inputData.put("assigned", "1");
							inputData.put("creator", userId);
							inputData.put("clientID", clientID);
							insert("role_SQL.insertRoleAssignment", inputData);
						}
					}
				}				
			}
		}	
	}
	
	private String setStatus(String newStatus) {
		String status = "";
		
		if (!"".equals(newStatus)) {
			status = "END";
		} else {
			status = "OPN";
		}
		
		return status;
	}
	
	private String emptyStringToNull(Object str) {
		String result = String.valueOf(str);
		if (String.valueOf(str).isEmpty()) {
			result = null;
		}
		
		return result;
	}
	
}
