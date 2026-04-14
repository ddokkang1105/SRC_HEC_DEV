package xbolt.itm.inf.web;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.PropertyAccessor;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import xbolt.adm.role.dto.RoleDTO;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.file.util.FileUploadUtil;
import xbolt.itm.inf.dto.ItemInfoDTO;
import xbolt.itm.inf.dto.ItemListDTO;
import xbolt.itm.inf.dto.ItemSearchDTO;
import xbolt.itm.inf.service.ItemInfoAPIServiceImpl;
import xbolt.project.cs.service.CSInfoAPIServiceImpl;
/**
 * 업무 처리
 * 
 * @Class Name : BizController.java
 * @Description : 업무화면을 제공한다.
 * @Modification Information
 * @수정일 수정자 수정내용 @--------- --------- ------------------------------- @2012. 09.
 *      01. smartfactory 최초생성
 *
 * @since 2012. 09. 01.
 * @version 1.0
 */

@Controller
@SuppressWarnings("unchecked")
public class mainItemMgtActionController extends XboltController {

	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "ItemInfoApiService")
	private ItemInfoAPIServiceImpl itemInfoAPIService;
	
	@Resource(name = "CSInfoService")
    private CSInfoAPIServiceImpl csInfoService;
	
	@Autowired
    private FileUploadUtil fileUploadUtil;

	private final Log _log = LogFactory.getLog(this.getClass());
	
	private static final ObjectMapper DTO_MAPPER;

    static {
        DTO_MAPPER = new ObjectMapper();
        // 변수명 동일하게 사용하기 위한 설정
        DTO_MAPPER.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.NONE);
        DTO_MAPPER.setVisibility(PropertyAccessor.FIELD, JsonAutoDetect.Visibility.ANY);
        // 없는 필드 무시하기
        DTO_MAPPER.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
    }
	
	@RequestMapping(value = "/itemMainMgt.do")
	public String itemMainMgt(ItemInfoDTO itemInfoDTO, HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String itemMainPage = "";
		String fileTokenYN = ""; // fileUpload가 필요하면 Y
		Map setMap = new HashMap(); 
		
		try {
			itemMainPage = StringUtil.checkNull(cmmMap.get("itemMainPage"), "/itm/itemInfo/itemClassMenu");
			
			// url을 통해 itemViewPage 체크
			itemMainPage = StringUtil.checkNull(itemInfoAPIService.checkUrlForClassVarfilter(itemInfoDTO));
			itemInfoDTO.setItemMainPage(itemMainPage);
			
			// cmmMap에 있는 데이터를 itemInfoDTO 클래스 형식에 맞춰 업데이트
			try {
			    DTO_MAPPER.updateValue(itemInfoDTO, cmmMap);
			} catch (JsonMappingException e) {
				System.out.println(e);
			}
			
			// itemID 없으면 s_itemID로 셋팅, languageID 없으면 sessionCurLang 으로 셋팅
			itemInfoDTO.fillEmptyFields();
			
			// popup 관련
			if("pop".equals(itemInfoDTO.getScrnType())){
				String htmlTitle = StringUtil.checkNull(itemInfoAPIService.getHtmlTitle(itemInfoDTO));
				itemInfoDTO.setHtmlTitle(htmlTitle);
				model.put("popOption",itemInfoDTO.getOption()); //( * itemMainMgt에선 option을 arcCode로 사용해서 popup쪽 option 명칭 변경 )
				
				itemMainPage = itemInfoDTO.getItemMainPage(); // popup일 경우, itemClassMenuVarfilter 에서 url을 가져올 수 있다
			}
			
			// parameter put
			setMap = DTO_MAPPER.convertValue(itemInfoDTO, Map.class); // item child list 관련 dto
			
			// auth setting
			String sessionUserId = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			String sessionAuthLev = String.valueOf(cmmMap.get("sessionAuthLev"));
			setMap.put("sessionUserId", sessionUserId);
			setMap.put("sessionAuthLev", sessionAuthLev);
			
			// ModelID 보유 확인
			setMap.put("ModelID", itemInfoDTO.getS_itemID());
			
			// class menu 정보
			List getList = new ArrayList();
			getList = itemInfoAPIService.getClassMenu(itemInfoDTO);
			model.put("getList", getList);
			
			// parentItemID 정보
			String parentItemID = StringUtil.checkNull(commonService.selectString("item_SQL.getParentItemID", setMap));
			model.put("parentItemID", parentItemID);
			
			// menu에서 보여줄 항목 정보 ( ex: 파일, 디멘션 .. )
			Map menuDisplayMap = commonService.select("item_SQL.getMenuIconDisplay", setMap);
			model.put("menuDisplayMap", menuDisplayMap);
			
			// myItem 정보
			String myItem = commonService.selectString("item_SQL.checkMyItem", setMap);
			model.put("myItem", myItem);
			
			//기본정보의 속성 내용을 취득
			Map itemInfo = commonService.select("report_SQL.getItemInfo", setMap);
			itemInfo.remove("Description"); //2025-02-17 기본 화면 로딩 안되는 버그 수정		
			
			String changeSetID = "";
			if ("OPS".equals(itemInfoDTO.getAccMode())) {
				
				changeSetID = StringUtil.checkNull(itemInfo.get("ReleaseNo"));
				setMap.put("changeSetID", changeSetID);
				Map prcList = commonService.select("item_SQL.getItemAttrRevInfo", setMap);
				
				if("0".equals(changeSetID) || "".equals(changeSetID)) {
					// changeSetID 이 0인 경우 ItemName / PlainText / Path 제외 기존 값 사용
					itemInfo.put("ItemName", StringUtil.checkNull(prcList.get("ItemName")));
					itemInfo.put("PlainText", StringUtil.checkNull(prcList.get("PlainText")));
					itemInfo.put("Path", StringUtil.checkNull(prcList.get("Path")));
					model.put("itemInfo", itemInfo);
				} else {
					// * prcList 에서 가져와서 사용해야 하는 항목 * 
					// CreateDT Version AuthorID AuthorTeamID ValidFrom TeamName OwnerTeamName Name AuthorName StatusName ProjectID ProjectName RefPjtName Description
					
					// * prcList 엔 없지만 itemInfo에서 가져와서 사용해야 하는 항목 넣어주기 *
					// Blocked ChangeMgt SubscrOption CheckInOption CheckOutOption CurChangeSet Status CSStatus WFInstanceID WFStatus ProjectID Deleted OwnerTeamID
					itemInfo.forEach(prcList::putIfAbsent);
					model.put("itemInfo", prcList);
				}
				
			} else {
				changeSetID = StringUtil.checkNull(itemInfo.get("CurChangeSet"),itemInfo.get("ReleaseNo").toString());
				setMap.put("changeSetID", changeSetID);
				String wfInstanceON = StringUtil.checkNull(commonService.selectString("wf_SQL.getWfInstON", setMap));
				model.put("wfInstanceON", wfInstanceON);
				model.put("itemInfo", itemInfo);
			}
			
			// 아이템 transfer 권한 정보
			setMap.put("userID", sessionUserId);
			setMap.put("checkOutOption", StringUtil.checkNull(itemInfo.get("CheckOutOption")));
			String checkItemAuthorTransferable = commonService.selectString("item_SQL.getCheckItemAuthorTransferable",setMap);
			model.put("checkItemAuthorTransferable", checkItemAuthorTransferable);
			
			// 권한에 따른 버튼 출력 정보 
			setMap.put("memberID", sessionUserId);
			model.put("myItemCNT", StringUtil.checkNull(commonService.selectString("item_SQL.getMyItemCNT", setMap)));
			model.put("myItemSeq", StringUtil.checkNull(commonService.selectString("item_SQL.getMyItemSeq", setMap)));
			
			// QuickCheckOut 설정
			String quickCheckOut;
			quickCheckOut = itemInfoAPIService.getQuickCheckOut(itemInfo, sessionUserId, itemInfoDTO.getS_itemID());
			model.put("quickCheckOut", quickCheckOut);
			
			// 결재 url 정보
			setMap.put("DocCategory", "CS");
			String wfURL = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFCategoryURL", setMap));
			model.put("wfURL", wfURL);
			
			// project Name List
			Map pjtMap = new HashMap();
			pjtMap.put("userId", sessionUserId);
			pjtMap.put("LanguageID", itemInfoDTO.getLanguageID());
			pjtMap.put("s_itemID", itemInfoDTO.getS_itemID());
			pjtMap.put("ProjectType", "CSR");
			pjtMap.put("isMainItem", "Y");
			pjtMap.put("status", "CNG");
			List projectNameList = commonService.selectList("project_SQL.getProjectNameList", pjtMap);
			model.put("projectNameList", projectNameList.size());
		
			model.put("menu", getLabel(request, commonService));
			// DTO의 모든 필드가 model에 개별 변수로 등록
			model.addAllAttributes(setMap);
			
			// file upload token
			fileTokenYN = StringUtil.checkNull(cmmMap.get("fileTokenYN"));
			String scrnMode = StringUtil.checkNull(itemInfoDTO.getScrnMode());
			
			// scrnMode가 편집 혹은 신규일 경우 파일 업로드 토큰
			if("".equals(fileTokenYN)) {
				if(("E").equals(scrnMode) || ("N").equals(scrnMode)) fileTokenYN = "Y";
			}
			
			if("Y".equals(fileTokenYN)) {
				HttpSession session = request.getSession(true);
				String uploadToken = fileUploadUtil.makeFileUploadFolderToken(session);
				model.put("uploadToken", uploadToken);
			}
		
			// 기존 itemClassMenu에서 사용하던 항목
			setMap = new HashMap();
			String blankPhotoUrlPath = GlobalVal.HTML_IMG_DIR + "/blank_photo.png";
			String photoUrlPath = GlobalVal.EMP_PHOTO_URL;
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			
			setMap.put("assignmentType", "CNGROLETP");
			setMap.put("languageID", languageID);
			setMap.put("blankPhotoUrlPath", blankPhotoUrlPath);
			setMap.put("photoUrlPath", photoUrlPath);
			setMap.put("isAll", "N");
			String empPhotoItemDisPlay = GlobalVal.EMP_PHOTO_ITEM_DISPLAY;
			model.put("empPhotoItemDisPlay", empPhotoItemDisPlay);
			
			List roleAssignMemberList = new ArrayList();
			roleAssignMemberList = commonService.selectList("item_SQL.getAssignmentMemberList", setMap);
			model.put("roleAssignMemberList", roleAssignMemberList);
			
			/* DTO 필드와 다르게 가야하는 항목 설정  */
			
			// 1. option => arcCode 로 사용
			model.put("option", itemInfoDTO.getArcCode());
			
			// 2. s_itemID
			model.put("id", itemInfoDTO.getS_itemID());
			model.put("choiceIdentifier", itemInfoDTO.getS_itemID()); // 사용 jsp 없음
			
			// 3. srType 관련 설정
			if (!"".equals(itemInfoDTO.getSrType())) {
				int icpListCNT = commonService.selectList("esm_SQL.getEsrMSTList_gridList", setMap).size();
				model.put("srType", itemInfoDTO.getSrType().toUpperCase());
				model.put("icpListCNT", icpListCNT);
			}
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(itemMainPage);
	}
	
	
	@RequestMapping(value = "/itemInfoMgt.do")
	public String itemInfoMgt(ItemInfoDTO itemInfoDTO, HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String itemInfoPage = "";
		Map setMap = new HashMap();

		try {
			
			// 아이템 개요 조회 / 편집 
			
			// url
			itemInfoPage = itemInfoDTO.getItemInfoPage();
			if("".equals(itemInfoPage)) itemInfoPage = StringUtil.checkNull(commandMap.get("itemInfoPage"), "/itm/itemInfo/itemInfoMgt");
			
			// 중요 param 값 초기화
			itemInfoDTO.fillEmptyFields();
			
	        // commandMap에 있는 데이터를 itemInfoDTO 클래스 형식에 맞춰 업데이트
 			try {
 			    DTO_MAPPER.updateValue(itemInfoDTO, commandMap);
 			} catch (JsonMappingException e) {
 				System.out.println(e);
 			}
	        
			// parameter put
	        setMap = DTO_MAPPER.convertValue(itemInfoDTO, Map.class);
			
			// auth setting
			String sessionUserId = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev"));
			setMap.put("sessionUserId", sessionUserId);
			setMap.put("sessionAuthLev", sessionAuthLev);
			
			// itemInfoDTO
			model.addAllAttributes(setMap); // DTO의 모든 필드가 model에 개별 변수로 등록
			
			// button edit 권한 관련 설정
			String itemStatus = commonService.selectString("project_SQL.getItemStatus", setMap);
			String itemBlocked = commonService.selectString("project_SQL.getItemBlocked", setMap);
			model.put("itemStatus", itemStatus); // 아이템 Status //
			model.put("itemBlocked", itemBlocked); // 아이템 Status
			
			String isPossibleEdit = "Y";
			if (!"0".equals(itemBlocked)) isPossibleEdit = "N";
			model.put("isPossibleEdit", isPossibleEdit);
			
			// changeMgt 설정
			setMap.put("status", "CLS");
			setMap.put("ItemID", itemInfoDTO.getItemID());
			String changeMgt = StringUtil.checkNull(commonService.selectString("project_SQL.getChangeMgt", setMap));
			model.put("changeMgt", changeMgt);
			
			// curChangeSetID 설정
			String curChangeSet = StringUtil.checkNull(commonService.selectString("project_SQL.getCurChangeSetIDFromItem", setMap));
			model.put("curChangeSet", curChangeSet);
			
			// menu에서 보여줄 항목 정보 ( ex: 파일, 디멘션 .. )
			Map menuDisplayMap = commonService.select("item_SQL.getMenuIconDisplay", setMap);
			model.put("menuDisplayMap", menuDisplayMap);
			
			// myItem 정보
			String myItem = commonService.selectString("item_SQL.checkMyItem", setMap);
			model.put("myItem", myItem);
			
			// model 정보
			List elementModelList = commonService.selectList("model_SQL.getItemMdlOccList_gridList", setMap);
			String isExistModel = "N";
			if (elementModelList.size() > 0) isExistModel = "Y";
			model.put("isExistModel", isExistModel);
			model.put("MDL_CNT", elementModelList.size());
			
			// cmm
			model.put("menu", getLabel(request, commonService)); // Label Setting
	     	
			// file upload token
			HttpSession session = request.getSession(true);
			String uploadToken = fileUploadUtil.makeFileUploadFolderToken(session);
			model.put("uploadToken", uploadToken);
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(itemInfoPage);
	}
	
	
	@RequestMapping(value = "/itemListMgt.do")
	public String itemListMgt(ItemListDTO itemListDTO, ItemSearchDTO itemSearchDTO, RoleDTO roleDTO, HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		
		String itemListPage = "";
		Map listMap = new HashMap();
		Map searchMap = new HashMap();
		Map roleMap = new HashMap();
		
		try {
			itemListPage = StringUtil.checkNull(itemListDTO.getItemListPage());
			if("".equals(itemListPage)) itemListPage = StringUtil.checkNull(request.getParameter("itemListPage"), "/itm/structure/childItemList");
			
			// s_itemID & nodeID 체크  
			itemListDTO.fillEmptyFields();
			roleDTO.fillEmptyFields();
			
			// parameter put
	        listMap = DTO_MAPPER.convertValue(itemListDTO, Map.class); // item child list 관련 dto
	        searchMap = DTO_MAPPER.convertValue(itemSearchDTO, Map.class); // item multi search 관련 dto
	        roleMap = DTO_MAPPER.convertValue(roleDTO, Map.class); // role 관련 dto
			
			// Login user editor 권한 추가
			Map itemAuthorMap = commonService.select("project_SQL.getItemAuthorIDAndLockOwner", listMap);
			String myItem = commonService.selectString("item_SQL.checkMyItem", commandMap);
			model.put("myItem", myItem);
			
			// itemListDTO
			model.addAllAttributes(listMap);
			// itemSearchDTO
			model.addAllAttributes(searchMap);
			// teamRoleDTO
			model.addAllAttributes(roleMap);

			// [ADD],[Del] 버튼 제어
			String blocked = StringUtil.checkNull(itemAuthorMap.get("Blocked"));
			if (!"0".equals(blocked)) {
				model.put("blocked", "Y");
			}
			
			// itemList common option
			model.put("addOption", StringUtil.checkNull(commandMap.get("addOption")));
			model.put("sessionParamSubItems", StringUtil.checkNull(commandMap.get("sessionParamSubItems")));
			
			// pop up 창에서 편집 버튼 제어 용
			String pop = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("pop"), ""));
			model.put("pop", pop);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

		} catch (Exception e) { 
			System.out.println(e.toString());
		}
		return nextUrl(itemListPage);
	}
	
	@RequestMapping(value = "/itemTreeMgt.do")
	public String itemMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/itm/structure/itemTreeMgt";
		try {
			String arcCode = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("arcCode"), ""));
			String menuStyle = StringUtil.checkNull(cmmMap.get("menuStyle"), "");
			String unfold = StringUtil.checkNull(cmmMap.get("unfold"));
			String arcDefPage = StringUtil.checkNull(cmmMap.get("arcDefPage"));
			String pageUrl = StringUtil.checkNull(cmmMap.get("pageUrl"));
			String nodeID = StringUtil.checkNull(cmmMap.get("nodeID"));
			String defMenuItemID = StringUtil.checkNull(cmmMap.get("defMenuItemID"));
			String defDimTypeID = StringUtil.checkNull(cmmMap.get("defDimTypeID"));
			String defDimValueID = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("defDimValueID")));
			String loadType = StringUtil.checkNull(cmmMap.get("loadType"));
			String tLink = StringUtil.checkNull(cmmMap.get("tLink"));
			String linkNodeID = StringUtil.checkNull(cmmMap.get("linkNodeID"));
			String autoSave = StringUtil.checkNull(cmmMap.get("autoSave"));
			String myItemOnly = StringUtil.checkNull(cmmMap.get("myItemOnly"));
			String ownerTeamOnly = StringUtil.checkNull(cmmMap.get("ownerTeamOnly"));
			String objClassList = StringUtil.checkNull(cmmMap.get("objClassList"));
			String s_itemID = StringUtil.checkNull(cmmMap.get("s_itemID"));
			String scrnMode = StringUtil.checkNull(cmmMap.get("scrnMode"));

			if (!linkNodeID.equals("")) { // Item Link Templet view linkID 가 있으면 nodeID로 setting
				nodeID = linkNodeID;
			}
			
			if (!s_itemID.equals("")) {
				nodeID = s_itemID;
			}

			Map setData = new HashMap();
			setData.put("itemID", nodeID);
			String itemClassMenuURL = StringUtil
					.checkNull(commonService.selectString("menu_SQL.getItemClassMenuURL", setData));

			setData.put("arcCode", arcCode);
			Map arcMenuInfo = commonService.select("menu_SQL.getArcInfo", setData);
			String strType = ""; String filterType = "";
			if (arcMenuInfo != null && !arcMenuInfo.isEmpty()) {
				menuStyle = StringUtil.checkNull(arcMenuInfo.get("MenuStyle"), "");
				strType = StringUtil.checkNull(arcMenuInfo.get("StrType"), "");
				filterType = StringUtil.checkNull(arcMenuInfo.get("FilterType"));
			}
			model.put("strType", strType);
			model.put("sortOption", arcMenuInfo.get("SortOption"));
			model.put("arcCode", arcCode);
			model.put("menuStyle", menuStyle);
			model.put("defMenuItemID", defMenuItemID);
			model.put("unfold", unfold);
			model.put("arcDefPage", arcDefPage);
			model.put("pageUrl", pageUrl);
			model.put("nodeID", nodeID);
			model.put("itemClassMenuURL", itemClassMenuURL);
			model.put("varFilter", arcMenuInfo.get("VarFilter"));
			model.put("arcVarFilter", arcMenuInfo.get("VarFilter"));
			model.put("showTOJ", StringUtil.checkNull(cmmMap.get("showTOJ")));
			model.put("accMode", StringUtil.checkNull(cmmMap.get("accMode")));
			model.put("showVAR", StringUtil.checkNull(cmmMap.get("showVAR")));
			model.put("defDimTypeID", defDimTypeID);
			model.put("defDimValueID", defDimValueID);

			model.put("loadType", loadType);
			model.put("tLink", tLink);
			model.put("autoSave", autoSave);
			model.put("myItemOnly", myItemOnly);
			model.put("ownerTeamOnly", ownerTeamOnly);
			if (loadType.equals("multi")) {
				setData = new HashMap();
				setData.put("subArcCode", arcCode);
				setData.put("languageID", cmmMap.get("sessionCurrLangType"));
				List arcList = commonService.selectList("menu_SQL.getArcInfo", setData);
				model.put("arcList", arcList);
			}
			model.put("popupUrl", StringUtil.checkNull(cmmMap.get("popupUrl")));
			model.put("pWidth", StringUtil.checkNull(cmmMap.get("pWidth"), "850"));
			model.put("pHeight", StringUtil.checkNull(cmmMap.get("pHeight"), "700"));
			model.put("showLink", StringUtil.checkNull(cmmMap.get("showLink"), ""));
			model.put("filterType", filterType);
			model.put("defaultClassCodes", StringUtil.checkNull(cmmMap.get("defaultClassCodes"), ""));
			model.put("myCSR", StringUtil.checkNull(cmmMap.get("myCSR"), ""));
			model.put("csrIDs", StringUtil.checkNull(cmmMap.get("csrIDs"), ""));
			model.put("udfSTR", StringUtil.checkNull(cmmMap.get("udfSTR"), ""));
			model.put("multiDimType", StringUtil.checkNull(cmmMap.get("multiDimType"), ""));
			model.put("sqlXmlCode", StringUtil.checkNull(cmmMap.get("sqlXmlCode"), ""));
			model.put("objClassList", StringUtil.checkNull(cmmMap.get("objClassList"), ""));
			model.put("scrnMode", scrnMode);
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/registerItemInfo.do")
	public String registerItemInfo(ItemInfoDTO itemInfoDTO, HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String itemNewPage = "";
		Map setMap = new HashMap();

		try {
			
			// url
			itemNewPage = itemInfoDTO.getItemNewPage();
			if("".equals(itemNewPage)) itemNewPage = StringUtil.checkNull(commandMap.get("itemNewPage"), "/itm/structure/registerItem");
			
			// 중요 param 값 초기화
			itemInfoDTO.fillEmptyFields();
			
	        // commandMap에 있는 데이터를 itemInfoDTO 클래스 형식에 맞춰 업데이트
 			try {
 			    DTO_MAPPER.updateValue(itemInfoDTO, commandMap);
 			} catch (JsonMappingException e) {
 				System.out.println(e);
 			}
	        
			// parameter put
	        setMap = DTO_MAPPER.convertValue(itemInfoDTO, Map.class);
			
			// auth setting
			String sessionUserId = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev"));
			setMap.put("sessionUserId", sessionUserId);
			setMap.put("sessionAuthLev", sessionAuthLev);
			
			// itemInfoDTO
			model.addAllAttributes(setMap); // DTO의 모든 필드가 model에 개별 변수로 등록
			
			// cmm
			model.put("menu", getLabel(request, commonService)); // Label Setting
	     	
			// file upload token
			HttpSession session = request.getSession(true);
			String uploadToken = fileUploadUtil.makeFileUploadFolderToken(session);
			model.put("uploadToken", uploadToken);
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(itemNewPage);
	}
}
