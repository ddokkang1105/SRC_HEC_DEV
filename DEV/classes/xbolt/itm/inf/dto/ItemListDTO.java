package xbolt.itm.inf.dto;

import java.util.List;

/**
 * 
 * @author 강서윤
 * 
 */

public class ItemListDTO {
	
	// 필수 파라미터
    private String languageID = ""; // 언어코드
    private String s_itemID = ""; // s_itemID
    private String itemID = ""; // itemID 트리로 들어올 경우
    private String listType = "child"; // [ child , owner , search ]
    private String nodeID = ""; // 트리로 들어올 경우
    
    // common 파라미터
    private String itemListPage = ""; // itemListMgt에서 사용하는 url
    private String sessionUserId = ""; // sessionUserId
    private String screenType = ""; // [main]
    private String pop = ""; // 
    
	// option 파라미터
    private String option = "";
    private String accMode = ""; // OPS : 릴리즈된 항목만 조회 / DEV : 편집중인 항목도 조회
    private String showTOJ = ""; // Y: 전체 조회 / 그외 : 아이템의 카테고리 코드가 TOJ가 아닌 항목만 조회
    private String showElement = ""; // Y
    private String changeMgtYN = "Y"; // Y : 아이템의 classCode의 changeMgt 설정이 Y 이고 , changeSetID가 있는 항목 조회
    private String mdlIF = ""; // Y : mdlIF 가 Y인 항목만 조회
    private String delItemsYN = ""; // Y : 삭제된 아이템도 조회
    
    // ui 관련 파라미터
    private String hideTitle = ""; // Y : title 숨김
    
    // ownerType 관련 파라미터
    private String ownerType = ""; // ownerTypeList에서 사용하는 옵션 [ manager : / author : / team ]
    private String subTeam = "";
    
    // 정렬 관련 파라미터
    private String maxListCount = ""; // top 파라미터
    private String sortFilter = "";
    private String showID = "";
    
    // item 관련 파라미터
    private String changeSetID = ""; // 해당 changeSetID 아이템만 조회
    private String releaseNo = ""; // 해당 releaseNo 아이템만 조회
    private String statusList = ""; // 해당 status 가 포함된 아이템만 조회 ( ex: NEW1 )
    private String status = "";
    
    // item filter 관련 파라미터
    private String TreeDataFiltered = ""; // 필터된 item만 조회 [ Y : sessionParamSubItems만 조회 ]
    private String sessionParamSubItems = ""; // 필더할 itemID 리스트
    
    // register item
    private String itemTypecode = "";
    private String classCode = "";
    private String fltpCode = "";
    private String dimTypeList = "";
    
    // delete item
    private String categoryCode = "";
    private List<String> items;
    
    // sr
    private String srID = "";
    
    // custom
    private String cnxFlag = ""; // Y : childItem 조회 옵션 [ 현앤 사용 ]
    
    
    public void fillEmptyFields() {
    	
    	// s_itemID 없는 경우 itemID, 없을경우 nodeID 체크 (트리 선택 경우)
    	boolean isNodeIdEmpty = (this.nodeID == null || this.nodeID.trim().isEmpty());
    	boolean isItemIdEmpty = (this.itemID == null || this.itemID.trim().isEmpty());
    	boolean isSItemIdEmpty = (this.s_itemID == null || this.s_itemID.trim().isEmpty());
        
    	if (!isItemIdEmpty && isSItemIdEmpty) {
            this.s_itemID = this.itemID;
        } else if (!isNodeIdEmpty && (isItemIdEmpty && isSItemIdEmpty)) {
            this.s_itemID = this.nodeID;
        }
        
    }

	public String getLanguageID() {
		return languageID;
	}

	public void setLanguageID(String languageID) {
		this.languageID = languageID;
	}

	public String getS_itemID() {
		return s_itemID;
	}

	public void setS_itemID(String s_itemID) {
		this.s_itemID = s_itemID;
	}

	public String getItemID() {
		return itemID;
	}

	public void setItemID(String itemID) {
		this.itemID = itemID;
	}

	public String getListType() {
		return listType;
	}

	public void setListType(String listType) {
		this.listType = listType;
	}

	public String getNodeID() {
		return nodeID;
	}

	public void setNodeID(String nodeID) {
		this.nodeID = nodeID;
	}

	public String getItemListPage() {
		return itemListPage;
	}

	public void setItemListPage(String itemListPage) {
		// 중복 제거
		if (itemListPage != null && itemListPage.contains(",")) {
            // 콤마로 구분된 값 중 첫 번째 값만 사용
            this.itemListPage = itemListPage.split(",")[0].trim();
        } else {
            this.itemListPage = itemListPage;
        }
	}

	public String getSessionUserId() {
		return sessionUserId;
	}

	public void setSessionUserId(String sessionUserId) {
		this.sessionUserId = sessionUserId;
	}

	public String getScreenType() {
		return screenType;
	}

	public void setScreenType(String screenType) {
		this.screenType = screenType;
	}

	public String getPop() {
		return pop;
	}

	public void setPop(String pop) {
		this.pop = pop;
	}

	public String getOption() {
		return option;
	}

	public void setOption(String option) {
		this.option = option;
	}

	public String getAccMode() {
		return accMode;
	}

	public void setAccMode(String accMode) {
		this.accMode = accMode;
	}

	public String getShowTOJ() {
		return showTOJ;
	}

	public void setShowTOJ(String showTOJ) {
		this.showTOJ = showTOJ;
	}

	public String getShowElement() {
		return showElement;
	}

	public void setShowElement(String showElement) {
		this.showElement = showElement;
	}

	public String getChangeMgtYN() {
		return changeMgtYN;
	}

	public void setChangeMgtYN(String changeMgtYN) {
		this.changeMgtYN = changeMgtYN;
	}

	public String getMdlIF() {
		return mdlIF;
	}

	public void setMdlIF(String mdlIF) {
		this.mdlIF = mdlIF;
	}

	public String getDelItemsYN() {
		return delItemsYN;
	}

	public void setDelItemsYN(String delItemsYN) {
		this.delItemsYN = delItemsYN;
	}

	public String getHideTitle() {
		return hideTitle;
	}

	public void setHideTitle(String hideTitle) {
		this.hideTitle = hideTitle;
	}

	public String getOwnerType() {
		return ownerType;
	}

	public void setOwnerType(String ownerType) {
		this.ownerType = ownerType;
	}
	public String getSubTeam() {
		return subTeam;
	}

	public void setSubTeam(String subTeam) {
		this.subTeam = subTeam;
	}

	public String getMaxListCount() {
		return maxListCount;
	}

	public void setMaxListCount(String maxListCount) {
		this.maxListCount = maxListCount;
	}

	public String getSortFilter() {
		return sortFilter;
	}

	public void setSortFilter(String sortFilter) {
		this.sortFilter = sortFilter;
	}

	public String getShowID() {
		return showID;
	}

	public void setShowID(String showID) {
		this.showID = showID;
	}

	public String getChangeSetID() {
		return changeSetID;
	}

	public void setChangeSetID(String changeSetID) {
		this.changeSetID = changeSetID;
	}

	public String getReleaseNo() {
		return releaseNo;
	}

	public void setReleaseNo(String releaseNo) {
		this.releaseNo = releaseNo;
	}

	public String getStatusList() {
		return statusList;
	}

	public void setStatusList(String statusList) {
		this.statusList = statusList;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getTreeDataFiltered() {
		return TreeDataFiltered;
	}

	public void setTreeDataFiltered(String treeDataFiltered) {
		TreeDataFiltered = treeDataFiltered;
	}

	public String getSessionParamSubItems() {
		return sessionParamSubItems;
	}

	public void setSessionParamSubItems(String sessionParamSubItems) {
		this.sessionParamSubItems = sessionParamSubItems;
	}

	public String getItemTypecode() {
		return itemTypecode;
	}

	public void setItemTypecode(String itemTypecode) {
		this.itemTypecode = itemTypecode;
	}

	public String getClassCode() {
		return classCode;
	}

	public void setClassCode(String classCode) {
		this.classCode = classCode;
	}

	public String getFltpCode() {
		return fltpCode;
	}

	public void setFltpCode(String fltpCode) {
		this.fltpCode = fltpCode;
	}

	public String getDimTypeList() {
		return dimTypeList;
	}

	public void setDimTypeList(String dimTypeList) {
		this.dimTypeList = dimTypeList;
	}

	public String getCategoryCode() {
		return categoryCode;
	}

	public void setCategoryCode(String categoryCode) {
		this.categoryCode = categoryCode;
	}

	public List<String> getItems() {
		return items;
	}

	public void setItems(List<String> items) {
		this.items = items;
	}

	public String getSrID() {
		return srID;
	}

	public void setSrID(String srID) {
		this.srID = srID;
	}

	public String getCnxFlag() {
		return cnxFlag;
	}

	public void setCnxFlag(String cnxFlag) {
		this.cnxFlag = cnxFlag;
	}
    
    
	
}

