package xbolt.api.service.impl;


import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import xbolt.api.dto.ItemDto;
import xbolt.api.dto.RequestDto;
import xbolt.api.enumType.ErrorCode;
import xbolt.api.exception.CustomException;
import xbolt.api.service.OlmRestApiService;
import xbolt.api.util.RestApiUtil;
import xbolt.api.util.ValidationUtil;
import xbolt.cmm.framework.util.DRMUtil;
import xbolt.cmm.framework.util.DateUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

/*

	@Transactionl rollback 사용할 경우 
	1. @EnableTransactionManagement
	2. @Transactional(transactionManager = "transactionManager", rollbackFor = {CustomException.class}, propagation= Propagation.REQUIRED)
	주석처리 해제
 */
@Service
@SuppressWarnings("unchecked")
//@EnableTransactionManagement
public class OlmRestApiServiceImpl implements OlmRestApiService {

	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Autowired
    @Qualifier("commonService")
    private CommonService commonService;

	@Autowired
    @Qualifier("fileMgtService")
    private CommonService fileMgtService;
	
	@Autowired
    @Qualifier("CSService")
    private CommonService CSService;
	
	private ObjectMapper objectMapper = new ObjectMapper();

	
	//transactionManager -> MSSQL, transactionManager2 -> Oracle
	//@Transactional(transactionManager = "transactionManager", rollbackFor = {CustomException.class}, propagation= Propagation.REQUIRED)
	public ItemDto insertItemAndFileWithInfo(RequestDto requestDto) throws CustomException, Exception{

		ItemDto itemDto = new ItemDto();
		
		try {
			//param : userId -> memberID validation check
			Map<String, Object> userMap = selectUserInfo(requestDto);	
			if(ValidationUtil.mapIsEmptyCheck(userMap)) throw new CustomException(ErrorCode.INVALID_USER);
			
			//중복된 DocNo, Identifier가 있는지 확인
			Map<String,Object> existingItemMap = checkDuplicatedWithDocNo(requestDto);
			
			
			//기존의 Item이 존재하지 않을때
			if(ValidationUtil.mapIsEmptyCheck(existingItemMap)) {
				
				//기존 새로운 item 생성하는 Process
				itemDto = insertItemWithInfo(requestDto);
				insertItemST1WithInfo(itemDto, requestDto);
				insertChangeSetWithInfo(itemDto, requestDto);
				insertItemAttrWithInfo(itemDto, requestDto);
				insertItemDimensionWithInfo(itemDto, requestDto);	
				insertItemAttrRevWithInfo(itemDto, requestDto);

			}else {
				
				//이미 같은 identifier의 문서가 존재할 떄 item 생성 생략 -> 기존 있던 item 필수적인 기본 정보 추가 설정
				itemDto = new ItemDto(requestDto);
				itemDto.setDuplicatedItemInfo(existingItemMap, userMap);
				insertChangeSetWithInfo(itemDto, requestDto);		
				insertItemAttrRevWithInfo(itemDto, requestDto);
				//insertItemAttrToRevWithInfo(itemDto, requestDto);
				
				if(itemDto.getIsUpgradedVersion()) {
					
					//Update User(json user 정보로 update)
					updateItemWithUserInfo(itemDto, requestDto);
					
					//Update ATTR, DIM
					deleteItemAttrWithInfo(itemDto,requestDto);
					insertItemAttrWithInfo(itemDto, requestDto);
					deleteItemDimensionWithInfo(itemDto, requestDto);
					insertItemDimensionWithInfo(itemDto, requestDto);


				}
			}
			
			
			
			//공통 Logic
			List<Map<String,Object>> fileList = insertFileWithInfo(itemDto, requestDto);
			itemDto.setFileList(fileList);
			insertItemIfWithInfo(itemDto, requestDto);
			
			return itemDto;

		}catch(CustomException e) {
			throw new CustomException(e.getErrorCode());
			
		}catch(Exception e){
			e.printStackTrace();
			throw new CustomException(ErrorCode.ETC_ERROR);
		}

	}
	
	/*
	 * 
	 * insert
	 * 
	 */
	
	public ItemDto insertItemWithInfo(RequestDto requestDto) throws CustomException, Exception{
		
		try {
			Map<String, Object> tmpMap = new HashMap<String, Object>();
			ItemDto itemDto = new ItemDto(requestDto);

			String itemId = commonService.selectString("item_SQL.getItemMaxID", tmpMap);
			String identifier = generateIdentifier(requestDto, itemDto);//Identifier
			String projectId = selectProjectId(itemDto);
			Map<String, Object> userMap = selectUserInfo(requestDto);	
			
			//Default value를 갖춘 itemDto 생성
			itemDto.setItemID(itemId);
			itemDto.setIdentifier(identifier);
			itemDto.setProjectID(projectId);
			itemDto.setUserInfo(userMap);
		
			//convert dto -> map & insert TB_ITEM
			Map<String, Object> itemMap = convertDtoToMap(itemDto);
			
			//companyID, ownerTeadID, AuthorID(&CreatorID)
			
			commonService.insert("item_SQL.insertItem", itemMap);
			

			return itemDto;
		
			
		}catch(CustomException e) {
			
			throw new CustomException(e.getErrorCode());
			
		}catch(Exception e) {
			
			e.printStackTrace();
			throw new CustomException(ErrorCode.ITEM_INSERT_ERROR);
		}


	}


	public void insertItemST1WithInfo(ItemDto itemDto, RequestDto requestDto) throws CustomException, Exception{
		
		try {
			Map<String, Object> tmpMap = new HashMap<String, Object>();
			
			String mstSTR = "";
			String cpItemID = "";
			
			Map<String, Object> stItemMap = convertDtoToMap(itemDto);
			
			
			if (((!cpItemID.equals("")) && (mstSTR.equals("Y"))) || (cpItemID.equals(""))) {
				
				stItemMap.put("ItemID", commonService.selectString("item_SQL.getItemMaxID", tmpMap));
				stItemMap.put("Identifier", null);
				stItemMap.put("ToItemID", itemDto.getItemID());
				stItemMap.put("CategoryCode", "ST1");
				stItemMap.put("ClassCode", "NL00000");


				//fromItemID 찾기
				String fromItemID = selectFromItemIdByInfo(itemDto, requestDto);

				
				stItemMap.put("FromItemID", fromItemID);

				
				tmpMap.put("s_itemID", fromItemID);
				String itemTypeCode = commonService.selectString("item_SQL.selectedConItemTypeCode", tmpMap);
				
				//validationCheck
			    if(!validationNullCheck(fromItemID) || !validationNullCheck(itemTypeCode)) {
			    	throw new CustomException(ErrorCode.ITEM_ST1_INSERT_ERROR);
			    }
				
			    
				stItemMap.put("ItemTypeCode",itemTypeCode);
				
				commonService.insert("item_SQL.insertItem", stItemMap);
				
			}

		}catch(CustomException e) {
			
			throw new CustomException(e.getErrorCode());
			
		}catch(Exception e) {
			e.printStackTrace();
			throw new CustomException(ErrorCode.ITEM_ST1_INSERT_ERROR);
		}


		
		
		
	}
	
	public void insertItemAttrWithInfo(ItemDto itemDto, RequestDto requestDto) throws CustomException, Exception{
		
		try {

			Map<String, String> attrTypeCodes = new HashMap<String, String>();
			//LovCode 필요없음
			attrTypeCodes.put("AT00001", requestDto.getDocName());  // 문서명
			attrTypeCodes.put("AT00003", itemDto.getPlainText()); //개요
			attrTypeCodes.put("AT01007", ""); //키워드
			
			//value : LovCode
			attrTypeCodes.put("ZAT01030", itemDto.getLvl1()); //영역(Lv1)
			attrTypeCodes.put("ZAT01060", itemDto.getLvl2()); // 문서타입(Lv2)
			attrTypeCodes.put("ZAT01020", itemDto.getDocLvl());  // 문서레벨
			attrTypeCodes.put("ZAT01040", itemDto.getDocDomain()); //문서분야
			attrTypeCodes.put("ZAT01010", itemDto.getSiteName());// 관리 site

			//vale : value -> LovCode 변환 필요
			attrTypeCodes.put("ZAT01050", itemDto.getLvl3()); // 공정(Lv3)
			attrTypeCodes.put("ZAT01051", itemDto.getLvl4()); // 상세공정
			attrTypeCodes.put("AT00040", itemDto.getNctTyp()); // NCT 대상여부 

			for (Map.Entry<String, String> entry : attrTypeCodes.entrySet()) {
			    String attrTypeCode = entry.getKey();  // 
			    String formValue = entry.getValue();   // /  
			 
				Map<String, Object> itemAttrMap = new HashMap<String, Object>();
				
			    itemAttrMap.put("languageID", itemDto.getLanguageID());  
			    itemAttrMap.put("ItemID", itemDto.getItemID());         
			    itemAttrMap.put("ItemTypeCode", itemDto.getItemTypeCode()); 
			    itemAttrMap.put("PlainText", formValue);   
			    itemAttrMap.put("AttrTypeCode", attrTypeCode);
			    
			    if(!attrTypeCode.equals("AT00001")&&!attrTypeCode.equals("AT00003")&& !attrTypeCode.equals("AT01007") 
			    		&& !attrTypeCode.equals("ZAT09005") && !attrTypeCode.equals("ZAT09006")) {
				    
				    //lovCode select을 위한 Value
				    itemAttrMap.put("Value", formValue);
				    
				    //Value -> LovCode로 변환
				    if(attrTypeCode.equals("ZAT01050") || attrTypeCode.equals("ZAT01051") || attrTypeCode.equals("AT00040")){
				    	String LovCode = StringUtil.checkNull(convertValueToLovCode(formValue, itemDto.getLanguageID(), attrTypeCode));
				    	itemAttrMap.put("LovCode", LovCode);
				    	itemAttrMap.put("PlainText", LovCode);
				    }else {
				    	itemAttrMap.put("LovCode" , formValue);
				    }

			    }
			    
			   commonService.insert("item_SQL.ItemAttr", itemAttrMap);
			}
		}catch(CustomException e) {
			throw new CustomException(e.getErrorCode());
		}catch(Exception e) {
			e.printStackTrace();
			throw new CustomException(ErrorCode.ITEM_ATTR_INSERT_ERROR);
		}

	}
	

	public void insertItemAttrToRevWithInfo(ItemDto itemDto, RequestDto requestDto) throws CustomException, Exception {
		

		Map<String, Object> tmpMap = new HashMap<String,Object>();
		Map<String, Object> attrRevMap = new HashMap<String,Object>();

		String changeSetID = itemDto.getNowChangeSet();

		try {
			if("".equals(changeSetID)){
				throw new CustomException(ErrorCode.ETC_ERROR);
			}
			
			tmpMap.put("itemID", itemDto.getItemID());	

			List<Map<String,Object>> attrMapList = commonService.selectList("project_SQL.getItemAttrList", tmpMap);
			
			for(int i=0; i< attrMapList.size(); i++){
				Map<String,Object> attrListInfo = attrMapList.get(i);			
				
				String seq = StringUtil.checkNull(commonService.selectString("project_SQL.getMaxAttrRevSeq", tmpMap));
				
				attrRevMap.put("seq", seq);
				attrRevMap.put("changeSetID", changeSetID);
				attrRevMap.put("itemID", attrListInfo.get("ItemID"));
				attrRevMap.put("attrTypeCode", attrListInfo.get("AttrTypeCode"));
				attrRevMap.put("languageID", attrListInfo.get("LanguageID"));
				attrRevMap.put("modelID", attrListInfo.get("ModelID"));
				attrRevMap.put("plainText", attrListInfo.get("PlainText"));
				attrRevMap.put("lovCode", attrListInfo.get("LovCode"));
				attrRevMap.put("htmlText", attrListInfo.get("HtmlText"));
				attrRevMap.put("itemTypeCode", attrListInfo.get("ItemTypeCode"));
				attrRevMap.put("classCode", attrListInfo.get("ClassCode"));
				attrRevMap.put("deleted", attrListInfo.get("Deleted"));
				attrRevMap.put("font", attrListInfo.get("Font"));
				attrRevMap.put("fontFamily", attrListInfo.get("FontFamily"));
				attrRevMap.put("fontStyle", attrListInfo.get("FontStyle"));
				attrRevMap.put("fontSize", attrListInfo.get("FontSize"));
				attrRevMap.put("fontColor", attrListInfo.get("FontColor"));	
				
				commonService.insert("api_SQL.insertItemAttrRevWithInfo", attrRevMap);	
			}
			
		}catch(CustomException e) {
			throw new CustomException(e.getErrorCode());
		}catch(Exception e) {
			e.printStackTrace();
			throw new CustomException(ErrorCode.ITEM_ATTR_REV_INSERT_ERROR);
		}	
	}
	
	public void insertItemAttrRevWithInfo(ItemDto itemDto, RequestDto requestDto) throws CustomException, Exception {
		
		
		try {
			String changeSetID = itemDto.getNewChangeSet();
			
			Map<String, String> attrTypeCodes = new HashMap<String, String>();
			//LovCode 필요없음
			attrTypeCodes.put("AT00001", requestDto.getDocName());  // 문서명
			attrTypeCodes.put("AT00003", itemDto.getPlainText()); //개요
			attrTypeCodes.put("AT01007", "키워드"); //키워드
			
			//value : LovCode
			attrTypeCodes.put("ZAT01030", requestDto.getLvl1()); //영역(Lv1)
			attrTypeCodes.put("ZAT01060", requestDto.getLvl2()); // 문서타입(Lv2)
			attrTypeCodes.put("ZAT01020", itemDto.getDocLvl());  // 문서레벨
			attrTypeCodes.put("ZAT01040", itemDto.getDocDomain()); //문서분야
			attrTypeCodes.put("ZAT01010", itemDto.getSiteName());// 관리 site

			//vale : value -> LovCode 변환 필요
			attrTypeCodes.put("ZAT01050", itemDto.getLvl3()); // 공정(Lv3)
			attrTypeCodes.put("ZAT01051", itemDto.getLvl4()); // 상세공정
			attrTypeCodes.put("AT00040", itemDto.getNctTyp()); // NCT 대상여부 		

			for (Map.Entry<String, String> entry : attrTypeCodes.entrySet()) {
			    String attrTypeCode = entry.getKey();  // 
			    String formValue = entry.getValue();   // /  
			 
				Map<String, Object> itemAttrRevMap = new HashMap<String, Object>();
				
				String seq = StringUtil.checkNull(commonService.selectString("project_SQL.getMaxAttrRevSeq", itemAttrRevMap));
				
				itemAttrRevMap.put("seq", seq);
				itemAttrRevMap.put("changeSetID", changeSetID);
				itemAttrRevMap.put("itemID", itemDto.getItemID());         
				itemAttrRevMap.put("attrTypeCode", attrTypeCode);
				itemAttrRevMap.put("languageID", itemDto.getLanguageID());  
				itemAttrRevMap.put("itemTypeCode", itemDto.getItemTypeCode()); 
				itemAttrRevMap.put("plainText", formValue);   
				itemAttrRevMap.put("classCode", itemDto.getClassCode());

				itemAttrRevMap.put("modelID", null);
				itemAttrRevMap.put("lovCode", null);
				itemAttrRevMap.put("htmlText", null);
				itemAttrRevMap.put("deleted", null);
				itemAttrRevMap.put("font", null);
				itemAttrRevMap.put("fontFamily", null);
				itemAttrRevMap.put("fontStyle", null);
				itemAttrRevMap.put("fontSize", null);
				itemAttrRevMap.put("fontColor", null);
				
			    if(!attrTypeCode.equals("AT00001")&&!attrTypeCode.equals("AT00003")&& !attrTypeCode.equals("AT01007")
			    		&& !attrTypeCode.equals("ZAT09005") && !attrTypeCode.equals("ZAT09006")) {
				    
				    //Value -> LovCode로 변환
				    if(attrTypeCode.equals("ZAT01050") || attrTypeCode.equals("ZAT01051")){
				    	String LovCode = StringUtil.checkNull(convertValueToLovCode(formValue, itemDto.getLanguageID(), attrTypeCode));
				    	itemAttrRevMap.put("lovCode", LovCode);
				    }else {
				    	itemAttrRevMap.put("lovCode" , formValue);
				    }

			    }
			    
			   commonService.insert("api_SQL.insertItemAttrRevWithInfo", itemAttrRevMap);
			}
			
		}catch(CustomException e) {
			throw new CustomException(e.getErrorCode());
		}catch(Exception e) {
			e.printStackTrace();
			throw new CustomException(ErrorCode.ITEM_ATTR_REV_INSERT_ERROR);
		}	
		

	}
	public void insertItemIfWithInfo(ItemDto itemDto, RequestDto requestDto) throws CustomException, Exception {
		
		try {
			Map<String, Object> itemIfMap = new HashMap<String,Object>();
			itemIfMap.put("itemId", itemDto.getItemID());
			itemIfMap.put("identifier", itemDto.getIdentifier());
			itemIfMap.put("docNo", requestDto.getDocNo());	
			itemIfMap.put("version", requestDto.getVersion());		
			
			commonService.insert("api_SQL.insertItemIfWithInfo", itemIfMap);
			
		}catch(Exception e) {
			e.printStackTrace();
			throw new CustomException(ErrorCode.PLM_INSERT_ERROR);
		}	
		
	}
	
	//나중에 모듈화 필요 **
	public ItemDto insertChangeSetWithInfo(ItemDto itemDto, RequestDto requestDto) throws CustomException, Exception {

		try {
			Map<String, Object> itemChangeSetMap = new HashMap<String, Object>();
			itemChangeSetMap.put("ItemID", itemDto.getItemID());
			

			String changeMgt = StringUtil
					.checkNull(commonService.selectString("project_SQL.getChangeMgt", itemChangeSetMap));
			if (changeMgt.equals("1")) {

				Map<String,Object> tmpMap = new HashMap<String,Object>();
				Map<String,Object> resultProjectMap = new HashMap<String,Object>();
				Map<String,Object> itemMap = new HashMap<String,Object>();

				//param : projectID
				tmpMap.put("projectID", itemDto.getProjectID());
				resultProjectMap = commonService.select("project_SQL.getProjectCategory", tmpMap);
						
				//param : itemClassCode, projectID
				tmpMap.put("itemClassCode", itemDto.getClassCode());
				itemChangeSetMap.put("checkInOption",  commonService.selectString("project_SQL.getCheckInOption", tmpMap));	
				
				
				int changeSetID = Integer.parseInt(commonService.selectString("cs_SQL.getMaxChangeSetData", itemChangeSetMap));
				
				itemChangeSetMap.put("ChangeSetID", changeSetID);

				itemChangeSetMap.put("ProjectID", itemDto.getProjectID());
				itemChangeSetMap.put("ItemID", itemDto.getItemID());
				itemChangeSetMap.put("ItemClassCode", itemDto.getClassCode());
				itemChangeSetMap.put("ItemTypeCode", itemDto.getItemTypeCode());
				
				itemChangeSetMap.put("AuthorID", itemDto.getAuthorID());
				itemChangeSetMap.put("AuthorName", itemDto.getCreatorName());
				itemChangeSetMap.put("AuthorTeamID", itemDto.getOwnerTeamId());
				itemChangeSetMap.put("CompanyID", itemDto.getCompanyID());

				itemChangeSetMap.put("PJTCategory", resultProjectMap.get("PJCategory"));
				itemChangeSetMap.put("Reason", resultProjectMap.get("Reason"));
				itemChangeSetMap.put("Description", StringUtil.checkNull(requestDto.getRevDesc()));
				
				//Version에 따른 개정, 제정 changeType
				String changeType = requestDto.getVersion() == 0 ? "NEW" : "MOD";
				itemChangeSetMap.put("ChangeType", changeType);
				itemChangeSetMap.put("CurTask", "CLS");
				itemChangeSetMap.put("Status", "CLS");
				itemChangeSetMap.put("version", itemDto.getVersion());
				
				commonService.insert("api_SQL.insertChangeSetWithCompleted", itemChangeSetMap);
				
				//Version에 따른 개정, 제정 releaseNo & changeSetID

				//신규 등록 또는 버전이 올라가는 경우 ( 버전이 내려가는 경우 제외)
				if(itemDto.getIsUpgradedVersion()) {
					itemMap.put("s_itemID", itemDto.getItemID());
					itemMap.put("CurChangeSet", changeSetID);
					if(itemDto.getVersion() != 0){
						itemMap.put("ReleaseNo", changeSetID);
					}

					commonService.update("project_SQL.updateItemStatus", itemMap); //update TB_ITEM.CurChangeSet 
				}
				itemDto.setNewChangeSet(StringUtil.checkNull(changeSetID));
			}
			return itemDto;
			
		}catch(Exception e) {
			e.printStackTrace();
			throw new CustomException(ErrorCode.CHANGESET_INSERT_ERROR);
		}	
		
		
		
	}
	

	public void insertItemDimensionWithInfo(ItemDto itemDto, RequestDto requestDto) throws CustomException, Exception {
		//Dimension
		
		try {
			
			String dimTypeID = StringUtil.checkNull("100001");
			String dimTypeValueID = generateDimString(requestDto.getDimension());
			
			if ((!dimTypeID.equals("")) && (!dimTypeValueID.equals(""))) {
				String[] temp = dimTypeValueID.split(",");
				
				Map<String, Object> itemDimMap = new HashMap<String, Object>();
				
				for (int i = 0; i < temp.length; i++) {
					itemDimMap.put("ItemTypeCode", itemDto.getItemTypeCode());
					itemDimMap.put("ItemClassCode", itemDto.getClassCode());
					itemDimMap.put("ItemID", itemDto.getItemID());
					itemDimMap.put("DimTypeID", dimTypeID);
					itemDimMap.put("DimValueID", temp[i]);
					
					commonService.insert("dim_SQL.insertItemDim", itemDimMap);
				}
			}
			
			
		}catch(CustomException e) {
			throw new CustomException(e.getErrorCode());
		}catch(Exception e) {
			e.printStackTrace();
			throw new CustomException(ErrorCode.DIM_INSERT_ERROR);
		}	

		
	}
	

	public List<Map<String,Object>> insertFileWithInfo(ItemDto itemDto, RequestDto requestDto) throws CustomException, Exception {
		/****************************** 첨부파일 등록 ******************************/
		List<Map<String, Object>> successFileList = new ArrayList<Map<String,Object>>();
		
		try {
			//File Seq 생성
			int fileSeq = Integer.parseInt(commonService.selectString("fileMgt_SQL.itemFile_nextVal", new HashMap<String,Object>()));		

			//Item ChangeSet
			Map<String, Object> itemIdMap = new HashMap<String,Object>();
			itemIdMap.put("itemID", itemDto.getItemID());
			
			//String changeSetID = StringUtil.checkNull(commonService.selectString("project_SQL.getCurChangeSetIDFromItem",itemIdMap));
			String changeSetID = itemDto.getNewChangeSet();
			//commandMap.put("Status", itemDto.getStatus());

			//이동될 File Path
			Map<String, Object> fltpMap  = new HashMap<String, Object>();
			fltpMap.put("fltpCode", itemDto.getFltpCode());
			String revisionYN = StringUtil.checkNull(commonService.selectString("fileMgt_SQL.getRevisionYN", fltpMap));	
			
			String orgFilePath = StringUtil.checkNull(requestDto.getOrgFilePath());	
			String chgFilePath = StringUtil.checkNull(commonService.selectString("fileMgt_SQL.getFilePath",fltpMap)); 

			
			//경로에 있는 파일들 담기
			List<Map<String, Object>> tmpFileList = new ArrayList<Map<String,Object>>();
			//tmpFileList = moveFiles(orgFilePath, chgFilePath, requestDto.getFileName());
			tmpFileList = copyFiles(orgFilePath, chgFilePath, requestDto.getFiles());
			/*
			 * FileUtil.copyFiles map 정보
				map.put(FILE_NAME, fOri.getName());
				map.put(ORIGIN_FILE_NM, fOri.getName());
				map.put(UPLOAD_FILE_NM, newFileName);
				map.put(FILE_EXT, fileExt);
				map.put(FILE_PATH, targetPath);
				map.put(FILE_SIZE, String.valueOf(size));
			 */


			String allFileList[] = FileUtil.ALL_FILE_LIST;

			List<Map<String, Object>> fileList = new ArrayList<Map<String, Object>>();
			
			if(tmpFileList.size() != 0){
				for(int i=0; i<tmpFileList.size();i++){
					
					Map<String, Object> fileInfoMap = tmpFileList.get(i);
					String fileExt = StringUtil.checkNull(fileInfoMap.get(FileUtil.FILE_EXT));
					
					Map<String, Object> fileMap = new HashMap<String, Object>();
					
				    if(Arrays.asList(allFileList).contains(fileExt.toUpperCase())) {
						fileMap.put("FileName", fileInfoMap.get(FileUtil.UPLOAD_FILE_NM));
						fileMap.put("FileRealName", fileInfoMap.get(FileUtil.ORIGIN_FILE_NM));
						fileMap.put("FileSize", fileInfoMap.get(FileUtil.FILE_SIZE));
						fileMap.put("FileFormat", fileInfoMap.get(FileUtil.FILE_EXT));
						fileMap.put("DocumentID", itemDto.getItemID());
						fileMap.put("FltpCode", itemDto.getFltpCode());
						fileMap.put("LanguageID", itemDto.getLanguageID());
						fileMap.put("projectID", itemDto.getProjectID());
						fileMap.put("DocCategory",itemDto.getDocCategory());
						fileMap.put("userId", itemDto.getAuthorID());
						fileMap.put("RegUserID", itemDto.getAuthorID());
						fileMap.put("LastUser", itemDto.getAuthorID());

						fileMap.put("Seq", fileSeq);
						fileMap.put("FilePath", chgFilePath);
						fileMap.put("ChangeSetID", changeSetID);
						fileMap.put("revisionYN", revisionYN);
						
						fileMap.put("FileMgt", "ITM");
						fileMap.put("LinkType", "1");
						fileMap.put("KBN", "insert");
						fileMap.put("SQLNAME", "fileMgt_SQL.itemFile_insert");	

						
						// File DRM 복호화
						String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
						String DRM_UPLOAD_USE = StringUtil.checkNull(GlobalVal.DRM_UPLOAD_USE);
						if(!"".equals(useDRM) && !"N".equals(DRM_UPLOAD_USE)){		
							
							HashMap drmInfoMap = new HashMap();		
							
							drmInfoMap.put("userID", itemDto.getAuthorID());
							drmInfoMap.put("teamID", itemDto.getOwnerTeamId());
							
							//DRM 정보
							drmInfoMap.put("ORGFileDir", orgFilePath);
							drmInfoMap.put("DRMFileDir", chgFilePath); // C://OLMFILE//document/FLT016//
							drmInfoMap.put("Filename", fileInfoMap.get(FileUtil.UPLOAD_FILE_NM));	 //  newFileName
							drmInfoMap.put("FileRealName", fileInfoMap.get(FileUtil.FILE_NAME));							
							drmInfoMap.put("funcType", "upload");
							String returnValue = DRMUtil.drmMgt(drmInfoMap); // 복호화 
						}
						
						fileList.add(fileMap);
						fileSeq++;
						
					} else {
				    	System.out.println("disallowedExtension :"+fileExt);
				    }
				}
			}
			
			if(fileList.size() != 0){
				
				Map<String, Object> crudMap = new HashMap<String, Object>();
				crudMap.put("KBN", "insert");
				
				fileMgtService.save(fileList, crudMap);
			}

			successFileList = commonService.selectList("api_SQL.selectItemIfFileListByItemID", itemIdMap);

			return successFileList;
			/*
			//directory 삭제
			List<Map<String,String>> deletFileList = requestDto.getFiles();
			if (!orgFilePath.equals("")) {
				
				for(Map<String,String> map : deletFileList) {
					String fileSubPath = RestApiUtil.generateStringPath(map.get("filePath"));
					if(fileSubPath != null && !fileSubPath.equals("")) {
						FileUtil.deleteDirectory(orgFilePath + fileSubPath);
					}
				}
				
			}
			*/
			
			/*
			//file 삭제
			List<Map<String,String>> deletFileList = requestDto.getFiles();
			if (!orgFilePath.equals("")) {
				
				for(Map<String,String> map : deletFileList) {
					String fullPath = (orgFilePath + RestApiUtil.generateStringPath(map.get("filePath")) + map.get("chgFileName"));
					deleteFile(fullPath);
				}
				
			}
			*/
			
		}catch(CustomException e) {
			throw new CustomException(e.getErrorCode());
		}catch(Exception e) {
			e.printStackTrace();
			throw new CustomException(ErrorCode.FILE_INSERT_ERROR);
		}	

	}
	
	public void insertItemTeamWithInfo(ItemDto itemDto, RequestDto requestDto) throws CustomException, Exception {
	
		Map<String, Object> itemTeamMap = new HashMap<String, Object>();

		//String[] teamIDs = StringUtil.checkNull(request.getParameter("orgTeamIDs")).split(",");
		String[] teamIDs = null;
		
		itemTeamMap.put("itemID", itemDto.getItemID());
		itemTeamMap.put("teamRoleType", "REL");
		itemTeamMap.put("assigned", "1");
		itemTeamMap.put("creator", itemDto.getCreator());
		itemTeamMap.put("teamRoleCat", "TEAMROLETP");
		
		List<String> teamRoleList = new ArrayList<String>();
		
		for (int i = 0; i < teamIDs.length; i++) {
			if ((!"".equals(teamIDs[i])) && (!"0".equals(teamIDs[i]))) {
				itemTeamMap.put("teamID", teamIDs[i]);
				teamRoleList = commonService.selectList("role_SQL.getTeamRoleIDList", itemTeamMap);
				if (teamRoleList.size() == 0) {
					//insert
					commonService.insert("role_SQL.insertTeamRole", itemTeamMap);
				}
			}
		}
	
	}


	/*
	 * 
	 * delete
	 * 
	 */
	
	
	
	public void deleteItemDimensionWithInfo(ItemDto itemDto, RequestDto requestDto) throws CustomException, Exception {

		try {
			
			Map<String, Object> tmpMap = new HashMap<String, Object>();
			tmpMap.put("itemId", itemDto.getItemID());
			commonService.delete("api_SQL.deleteDimWithItemID", tmpMap);
			
			
		}catch(Exception e) {
			e.printStackTrace();
			throw new CustomException(ErrorCode.DIM_DELETE_ERROR);
		}	

	}
	
	public void deleteItemAttrWithInfo(ItemDto itemDto, RequestDto requestDto) throws CustomException, Exception {
		
		try {
			
			Map<String, Object> tmpMap = new HashMap<String, Object>();
			tmpMap.put("itemId", itemDto.getItemID());
			commonService.delete("api_SQL.deleteItemAttrWithItemID", tmpMap);
			
			
			
		}catch(Exception e) {
			e.printStackTrace();
			throw new CustomException(ErrorCode.ITEM_ATTR_DELETE_ERROR);
		}	


	}


	/*
	 * 
	 * select methods
	 * 
	 */

	//Select ST FromItemId 
	private String selectFromItemIdByInfo(ItemDto itemDto, RequestDto requestDto) throws CustomException, Exception {
		
		try {
			
			Map<String, Object> fromItemIdMap = new HashMap<String, Object>();


			String lvl1= StringUtil.checkNull(convertLovCodeToValue(itemDto.getLvl1(), itemDto.getLanguageID()));//문서영역 LV1
			String lvl2 = StringUtil.checkNull(convertLovCodeToValue(itemDto.getLvl2(), itemDto.getLanguageID()));//문서등급 LV2
			String lvl3 = StringUtil.checkNull(itemDto.getLvl3());//문서분야 LV3
			
			/*
			fromItemIdMap.put("docArea", docArea);
			fromItemIdMap.put("docTyp", docTyp);
			fromItemIdMap.put("docProc", docProc);
			*/

			fromItemIdMap.put("docArea", lvl1);
			fromItemIdMap.put("docTyp", lvl2);
			fromItemIdMap.put("docProc", lvl3);

			fromItemIdMap.put("languageId", itemDto.getLanguageID());//1042
			
			//LV1, LV2, LV3 관련 고정값
			fromItemIdMap.put("attrTypeCode", "AT00001");
			fromItemIdMap.put("categoryCode", "ST1");
			fromItemIdMap.put("lv1ClassCode", "CL16001");
			fromItemIdMap.put("lv2ClassCode", "CL16002");
			fromItemIdMap.put("lv3ClassCode", "CL16003");
			fromItemIdMap.put("lv3AttrTypeCode", "ZAT01050");
			
			//String docProcLovCode = StringUtil.checkNull(commonService.selectString("api_SQL.selectLovCodeByValue", fromItemIdMap));
			//fromItemIdMap.put("docProc", docProcLovCode);

			String fromItemId = StringUtil.checkNull(commonService.selectString("api_SQL.selectFromItemIDByInfo", fromItemIdMap));
			
			return fromItemId;
			
			
		}catch(CustomException e) {
			throw new CustomException(e.getErrorCode());
		}catch(Exception e) {
			e.printStackTrace();
			throw new CustomException(ErrorCode.PARENT_ID_SELECT_ERROR);
		}	
		
		
	}

	//Select ProjectId
	private String selectProjectId(ItemDto itemDto) throws CustomException, Exception {

		try {
			Map<String, Object> map = new HashMap<>();
			
			map.put("itemClassCode", itemDto.getClassCode());
			map.put("itemTypeCode", itemDto.getItemTypeCode());
			map.put("userID", itemDto.getAuthorID());	
			String projectID = StringUtil.checkNull(commonService.selectString("item_SQL.getItemClassDefCSRID", map));
			
			return projectID;
			
		}catch(Exception e) {
			e.printStackTrace();
			throw new CustomException(ErrorCode.PROJECT_INFO_SELECT_ERROR);
		}	

	}

	
	private Map<String,Object> selectLatestVersionOfItem(Map<String,Object> map) throws CustomException, Exception{

		try {
			Map<String, Object> resultMap = commonService.select("api_SQL.selectItemWithItemID", map);
			
			return resultMap;
			
		}catch(Exception e) {
			e.printStackTrace();
			throw new CustomException(ErrorCode.PLM_ITEM_INFO_SELECT_ERROR);
		}	

	}
	
	private Map<String, Object> selectUserInfo(RequestDto requestDto) throws CustomException, Exception {
		
		try {
			
			Map<String,Object> userMap = new HashMap<String, Object>();
			userMap.put("loginId", requestDto.getUserId());
			
			Map<String, Object> resultUserMap =  commonService.select("project_SQL.getUserInfo", userMap);
			
			return resultUserMap;
			
			
		}catch(Exception e) {
			e.printStackTrace();
			throw new CustomException(ErrorCode.USER_INFO_SELECT_ERROR);
		}	
	

	}
	
	/*
	 * 
	 * update part
	 * 
	 */
	public void updateItemWithUserInfo(ItemDto itemDto, RequestDto requestDto) throws CustomException, Exception {
		
		try {
			Map<String, Object> userMap = selectUserInfo(requestDto);	
			userMap.put("itemId", itemDto.getItemID());
			commonService.update("api_SQL.updateItemWithUserInfo", userMap);
			
		}catch(Exception e) {
			e.printStackTrace();
			throw new CustomException(ErrorCode.USER_ITEM_UPDATE_ERROR);
		}
	}
	
	
	/*
	 * 
	 * convert part
	 * 
	 */
	
	//Camel Case가 적용 되어있지 않아서 직접 앞자리 대문자로 map 생성
	private Map<String, Object> convertDtoToMap(ItemDto itemDto) throws CustomException, Exception {
		
		return objectMapper.convertValue(itemDto, Map.class);
	}

	
	private String convertValueToLovCode(String value, String languageId, String attrTypeCode)  throws CustomException, Exception {
		
		try {
			
			Map<String, Object> valueMap = new HashMap<String, Object>();
			
			valueMap.put("value", value);
			valueMap.put("languageID", languageId);
			valueMap.put("attrTypeCode", attrTypeCode);
			
			String lovCode = commonService.selectString("api_SQL.selectLovCodeByInfo", valueMap);
			
			return lovCode;
			
			
		}catch(Exception e) {
			e.printStackTrace();
			throw new CustomException(ErrorCode.LOVCODE_SELECT_ERROR);
		}	
		
	}
	
	private String convertLovCodeToValue(String lovCode, String languageId) throws CustomException, Exception {
		
		try {
			
			Map<String, Object> lovCodeMap = new HashMap<String, Object>();
			
			lovCodeMap.put("lovCode", lovCode);
			lovCodeMap.put("languageID", languageId);
			
			String value = commonService.selectString("api_SQL.selectValueByLovCode", lovCodeMap);
			
			return value;
			
		}catch(Exception e) {
			e.printStackTrace();
			throw new CustomException(ErrorCode.VALUE_SELECT_ERROR);
		}

		
	}
	
	//Dim List -> Dim str
	private String generateDimString(List<Map<String,String>> dimension) throws CustomException, Exception {
		
		Set<String> dimList = new HashSet<>();
		
		for(Map<String,String> dimMap : dimension) {
			String dimId = StringUtil.checkNull(dimMap.get("dimId"));
			dimList.add(dimId);
		}
		
		String dimStr = String.join(",",dimList);

		return dimStr;
	}
	

	
	/*
	 * 
	 * file 관련
	 * 
	 */
	
	public List copyFiles(String orignPath, String targetPath, List<Map<String,String>> files) throws CustomException, Exception {
		
		String a = orignPath;
		try {

			List<Map<String,String>> fileList = new ArrayList<Map<String,String>>();

			File fTargetFolder = new File (targetPath);
			if ( !fTargetFolder.isDirectory()){fTargetFolder.mkdir();}
			
			
		    //File fOri = null;
		    //File fTarget = null;
		    if(files!=null){
		    for( int i = 0; i < files.size(); i++) {
		    	
		    	Map<String, String> file = files.get(i);
				HashMap<String, String> map = new HashMap<String, String>();
		    	
		    	String orgFullPath = (orignPath + RestApiUtil.generateStringPath(file.get("filePath")) + StringUtil.checkNull(file.get("sndFileName")));
		    	String fileRealName = StringUtil.checkNull(file.get("orgFileName"));
		    	File fOri = new File ( orgFullPath );

				String orginFileName = fOri.getName();
				String fileExt = getExt(orginFileName);
				
				//newName 은 Naming Convention에 의해서 생성
				//newFileName = DateUtil.getCurrentTime() + "." + fileExt;
		    	String newFileName = DateUtil.getCurrentTime() + "_" + UUID.randomUUID().toString().substring(0, 8) + "." + fileExt;
				
				//String newFileName = StringUtil.checkNull(file.get("orgFileName"));
				
				File fTarget = new File ( targetPath + newFileName );

				//file copy
				Files.copy(fOri.toPath(), fTarget.toPath()); 
				


				long size = fOri.length();		
				
				map.put("FileNm", fileRealName);
				map.put("FileNm", fileRealName);
				map.put("SysFileNm", newFileName);
				map.put("FILE_EXT", fileExt);
				map.put("FilePath", targetPath);
				map.put("FileSize", String.valueOf(size));
				
				fileList.add(map);
		    
		    }}
			return fileList;
		}catch(Exception e) {
			e.printStackTrace();
			throw new CustomException(ErrorCode.FILE_COPY_ERROR);
		}
	}
	
	public String getExt(String fileName) {
		return fileName.substring(fileName.lastIndexOf(".") + 1);
	}
	
	public void deleteFile(String fullPath) throws CustomException, Exception {
		
		try {
			Path filePath = Paths.get(fullPath);
			Files.delete(filePath);
			
		}catch(Exception e) {
			e.printStackTrace();
			throw new CustomException(ErrorCode.FILE_DELETE_ERROR);
		}

	}
	
	
	/*
	 * 
	 * 생성 관련
	 * 
	 */
	
	/** 생성시  문서 자동채번 **/
	public String generateIdentifier(RequestDto requestDto, ItemDto itemDto) throws CustomException, Exception {

		try {
			
			Map<String,Object> map = new HashMap<String, Object>();
			
			String docIdentifier="";
			
			docIdentifier = generateBaseIdentifier(requestDto);
			
			map.put("ClassCode", itemDto.getClassCode());
			map.put("docIdentifier", docIdentifier);
			String maxDocNum = commonService.selectString("api_SQL.getMaxIdentifier", map);
			String identifier = docIdentifier+"-"+maxDocNum;
			
			return identifier;
			
		}catch(Exception e) {
			e.printStackTrace();
			throw new CustomException(ErrorCode.IDENTIFIER_GENERATE_ERROR);
		}
		
	}
	
	public String generateBaseIdentifier(RequestDto requestDto) throws CustomException, Exception{
		
	    String siteName = StringUtil.checkNull(requestDto.getSiteName()); //문서 사이트 
		String etc = StringUtil.checkNull(requestDto.getEtc());//문서분야
		String lvl1= StringUtil.checkNull(requestDto.getLvl1());//문서영역
		String lvl3 = StringUtil.checkNull(requestDto.getLvl3());//공정
		//String docProc = StringUtil.checkNull(convertValueToLovCode(itemDto.getDocProc(),itemDto.getLanguageID(), null));//공정
		String lvl2 = StringUtil.checkNull(requestDto.getLvl2());//문서타입
		
		return siteName+lvl1+"-"+etc+"-"+lvl3+"CO"+"-"+lvl2;

	}

	
	/*
	 * 
	 * Validation Check
	 * 
	 */
	
	public Map<String, Object> checkDuplicatedWithDocNo(RequestDto requestDto) throws CustomException, Exception{
		
		try {
			Map<String, Object> tmpMap = new HashMap<>();
			Map<String, Object> resultMap = new HashMap<>();
			Map<String, Object> itemIdMap = new HashMap<>();
			Map<String, Object> duplicatedMap = new HashMap<>();
			
			String baseIdentifier = generateBaseIdentifier(requestDto);
			
			tmpMap.put("docNo", requestDto.getDocNo());
			tmpMap.put("version", requestDto.getVersion());

			//docNo, revNo가 같으면 -> 중복
			duplicatedMap = commonService.select("api_SQL.selectOlmApiItemIDWithVersion", tmpMap);
			if(!ValidationUtil.mapIsEmptyCheck(duplicatedMap)) throw new CustomException(ErrorCode.REV_DUPLICATED);
			

			//docNo, identifier가 같으면 -> version up or down
			tmpMap.put("identifier", baseIdentifier);
			itemIdMap = commonService.select("api_SQL.selectOlmApiItemIDWithIdentifier", tmpMap);
			
			if(!ValidationUtil.mapIsEmptyCheck(itemIdMap)) {
				Map<String, Object> itemMap = commonService.select("api_SQL.selectOlmApiItemInfoWithInfo", tmpMap);
				
				//docNo, revNo, identifier가 다 같을 경우 중복
				if(!ValidationUtil.mapIsEmptyCheck(itemMap)) throw new CustomException(ErrorCode.REV_DUPLICATED);
				
				resultMap = selectLatestVersionOfItem(itemIdMap);
				int latestVersion = Integer.valueOf(StringUtil.checkNull(resultMap.get("version")));
				
				//버전이 최신 여부
				if(requestDto.getVersion() > latestVersion) {
					resultMap.put("isUpgradedVersion", true);
				}else if(requestDto.getVersion() < latestVersion){
					resultMap.put("isUpgradedVersion", false);
				}
				
			}

			return resultMap;
			
		}catch(CustomException e) {
			throw new CustomException(e.getErrorCode());
		}catch(Exception e) {
			e.printStackTrace();
			throw new CustomException(ErrorCode.CHECK_DOC_NO_ERROR);
		}
		
	}
	
	private Boolean validationNullCheck(String str) {
		if(str == null || str.isEmpty() || str.equals("")) {
			return false;
		}else {
			return true;
		}
	}
	
	
}

