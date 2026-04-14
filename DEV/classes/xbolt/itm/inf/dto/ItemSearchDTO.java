package xbolt.itm.inf.dto;

/**
 * 
 * @author 강서윤
 * 
 */

public class ItemSearchDTO {
	
	// 필수 파라미터
    private String languageID = ""; // 언어코드
    
    // common 파라미터
    private String defaultLang = ""; // default 언어코드
    private String isComLang = ""; // 언어코드
    private String pageNum = ""; // 현재 페이지
    private String menucat = "";
    
    // option 파라미터
    private String idExist = ""; // Y : identifier가 존재하는 항목만 조회하는 옵션
    private String isNothingLowLank = ""; // childItemList에서 검색 시, 하위항목에 아이템이 없으면 검색 x
    private String childItems = ""; // childItemList에서 검색 시, 해당 하위항목에서만 검색하는 옵션
    
    // 검색 관련 파라미터
    private String searchKey = ""; // attr 검색 키
    private String searchValue = ""; // attr 검색 value 
    
    // def 관련 파라미터
    private String defDimTypeID = ""; // default dimension id
    private String defDimValueID = ""; // default dimension value
    
    private String defItemTypeCode = "";
    private String defClassCode = "";
    
    private String defAttrTypeCode = "";
    private String defCompany = "";
    private String defOwnerTeam = "";
    private String defAuthor = "";
    
    private String defStatus = "";
    
    // item 관련 파라미터
    private String CategoryCode = "";
    private String ClassCode = "";
    private String ItemTypeCode = "";
    
    // * Identifier
    private String AttrCodeBase2 = "";
    private String baseCondition2 = "";
    private String baseCon2Escape = "";
    
    // * 법인
    private String CompanyID = "";

    // * 관리조직
    private String searchTeamName = "";
    private String ownerTeamID = "";
    private String teamManagerID = "";
    private String OwnerTeam = "";
    private String ownerTeamEscape = "";
    
    // * 담당자
    private String searchAuthorName = "";
    private String authorID = "";
    private String Name = "";
    private String nameEscape = "";
    
    // * 생성일
    private String CreationTime = "";
    private String scStartDt1 = "";
    private String scEndDt1 = "";
    
    // * 수정일
    private String LastUpdated = "";
    private String scStartDt2 = "";
    private String scEndDt2 = "";
    
    // * 상태
    private String Status = "";
    private String changeMgt = "";
    
    // * attr
    private String AttrCodeOLM_MULTI_VALUE = "";
    
    // * dimension
    private String DimValueIDOLM_ARRAY_VALUE = "";
    private String DimTypeID = "";
    private String isNotIn = "";
    private String nothingDim = "";
    
    // * report
    private String itemInfoRptUrl = "";
    
    // * custom
    private String assignMentType = ""; // 현앤 사용

	public String getLanguageID() {
		return languageID;
	}

	public void setLanguageID(String languageID) {
		this.languageID = languageID;
	}

	public String getDefaultLang() {
		return defaultLang;
	}

	public void setDefaultLang(String defaultLang) {
		this.defaultLang = defaultLang;
	}

	public String getIsComLang() {
		return isComLang;
	}

	public void setIsComLang(String isComLang) {
		this.isComLang = isComLang;
	}

	public String getPageNum() {
		return pageNum;
	}

	public void setPageNum(String pageNum) {
		this.pageNum = pageNum;
	}

	public String getMenucat() {
		return menucat;
	}

	public void setMenucat(String menucat) {
		this.menucat = menucat;
	}

	public String getIdExist() {
		return idExist;
	}

	public void setIdExist(String idExist) {
		this.idExist = idExist;
	}

	public String getIsNothingLowLank() {
		return isNothingLowLank;
	}

	public void setIsNothingLowLank(String isNothingLowLank) {
		this.isNothingLowLank = isNothingLowLank;
	}

	public String getChildItems() {
		return childItems;
	}

	public void setChildItems(String childItems) {
		this.childItems = childItems;
	}

	public String getSearchKey() {
		return searchKey;
	}

	public void setSearchKey(String searchKey) {
		this.searchKey = searchKey;
	}

	public String getSearchValue() {
		return searchValue;
	}

	public void setSearchValue(String searchValue) {
		this.searchValue = searchValue;
	}

	public String getDefDimTypeID() {
		return defDimTypeID;
	}

	public void setDefDimTypeID(String defDimTypeID) {
		this.defDimTypeID = defDimTypeID;
	}

	public String getDefDimValueID() {
		return defDimValueID;
	}

	public void setDefDimValueID(String defDimValueID) {
		this.defDimValueID = defDimValueID;
	}

	public String getDefItemTypeCode() {
		return defItemTypeCode;
	}

	public void setDefItemTypeCode(String defItemTypeCode) {
		this.defItemTypeCode = defItemTypeCode;
	}

	public String getDefClassCode() {
		return defClassCode;
	}

	public void setDefClassCode(String defClassCode) {
		this.defClassCode = defClassCode;
	}

	public String getDefAttrTypeCode() {
		return defAttrTypeCode;
	}

	public void setDefAttrTypeCode(String defAttrTypeCode) {
		this.defAttrTypeCode = defAttrTypeCode;
	}

	public String getDefCompany() {
		return defCompany;
	}

	public void setDefCompany(String defCompany) {
		this.defCompany = defCompany;
	}

	public String getDefOwnerTeam() {
		return defOwnerTeam;
	}

	public void setDefOwnerTeam(String defOwnerTeam) {
		this.defOwnerTeam = defOwnerTeam;
	}

	public String getDefAuthor() {
		return defAuthor;
	}

	public void setDefAuthor(String defAuthor) {
		this.defAuthor = defAuthor;
	}

	public String getDefStatus() {
		return defStatus;
	}

	public void setDefStatus(String defStatus) {
		this.defStatus = defStatus;
	}

	public String getCategoryCode() {
		return CategoryCode;
	}

	public void setCategoryCode(String categoryCode) {
		CategoryCode = categoryCode;
	}

	public String getClassCode() {
		return ClassCode;
	}

	public void setClassCode(String classCode) {
		ClassCode = classCode;
	}

	public String getItemTypeCode() {
		return ItemTypeCode;
	}

	public void setItemTypeCode(String itemTypeCode) {
		ItemTypeCode = itemTypeCode;
	}

	public String getAttrCodeBase2() {
		return AttrCodeBase2;
	}

	public void setAttrCodeBase2(String attrCodeBase2) {
		AttrCodeBase2 = attrCodeBase2;
	}

	public String getBaseCondition2() {
		return baseCondition2;
	}

	public void setBaseCondition2(String baseCondition2) {
		this.baseCondition2 = baseCondition2;
	}

	public String getBaseCon2Escape() {
		return baseCon2Escape;
	}

	public void setBaseCon2Escape(String baseCon2Escape) {
		this.baseCon2Escape = baseCon2Escape;
	}

	public String getCompanyID() {
		return CompanyID;
	}

	public void setCompanyID(String companyID) {
		CompanyID = companyID;
	}

	public String getSearchTeamName() {
		return searchTeamName;
	}

	public void setSearchTeamName(String searchTeamName) {
		this.searchTeamName = searchTeamName;
	}

	public String getOwnerTeamID() {
		return ownerTeamID;
	}

	public void setOwnerTeamID(String ownerTeamID) {
		this.ownerTeamID = ownerTeamID;
	}

	public String getTeamManagerID() {
		return teamManagerID;
	}

	public void setTeamManagerID(String teamManagerID) {
		this.teamManagerID = teamManagerID;
	}

	public String getOwnerTeam() {
		return OwnerTeam;
	}

	public void setOwnerTeam(String ownerTeam) {
		OwnerTeam = ownerTeam;
	}

	public String getOwnerTeamEscape() {
		return ownerTeamEscape;
	}

	public void setOwnerTeamEscape(String ownerTeamEscape) {
		this.ownerTeamEscape = ownerTeamEscape;
	}

	public String getSearchAuthorName() {
		return searchAuthorName;
	}

	public void setSearchAuthorName(String searchAuthorName) {
		this.searchAuthorName = searchAuthorName;
	}

	public String getAuthorID() {
		return authorID;
	}

	public void setAuthorID(String authorID) {
		this.authorID = authorID;
	}

	public String getName() {
		return Name;
	}

	public void setName(String name) {
		Name = name;
	}

	public String getNameEscape() {
		return nameEscape;
	}

	public void setNameEscape(String nameEscape) {
		this.nameEscape = nameEscape;
	}

	public String getCreationTime() {
		return CreationTime;
	}

	public void setCreationTime(String creationTime) {
		CreationTime = creationTime;
	}

	public String getScStartDt1() {
		return scStartDt1;
	}

	public void setScStartDt1(String scStartDt1) {
		this.scStartDt1 = scStartDt1;
	}

	public String getScEndDt1() {
		return scEndDt1;
	}

	public void setScEndDt1(String scEndDt1) {
		this.scEndDt1 = scEndDt1;
	}

	public String getLastUpdated() {
		return LastUpdated;
	}

	public void setLastUpdated(String lastUpdated) {
		LastUpdated = lastUpdated;
	}

	public String getScStartDt2() {
		return scStartDt2;
	}

	public void setScStartDt2(String scStartDt2) {
		this.scStartDt2 = scStartDt2;
	}

	public String getScEndDt2() {
		return scEndDt2;
	}

	public void setScEndDt2(String scEndDt2) {
		this.scEndDt2 = scEndDt2;
	}

	public String getStatus() {
		return Status;
	}

	public void setStatus(String status) {
		Status = status;
	}

	public String getChangeMgt() {
		return changeMgt;
	}

	public void setChangeMgt(String changeMgt) {
		this.changeMgt = changeMgt;
	}

	public String getAttrCodeOLM_MULTI_VALUE() {
		return AttrCodeOLM_MULTI_VALUE;
	}

	public void setAttrCodeOLM_MULTI_VALUE(String attrCodeOLM_MULTI_VALUE) {
		AttrCodeOLM_MULTI_VALUE = attrCodeOLM_MULTI_VALUE;
	}

	public String getDimValueIDOLM_ARRAY_VALUE() {
		return DimValueIDOLM_ARRAY_VALUE;
	}

	public void setDimValueIDOLM_ARRAY_VALUE(String dimValueIDOLM_ARRAY_VALUE) {
		DimValueIDOLM_ARRAY_VALUE = dimValueIDOLM_ARRAY_VALUE;
	}

	public String getDimTypeID() {
		return DimTypeID;
	}

	public void setDimTypeID(String dimTypeID) {
		DimTypeID = dimTypeID;
	}

	public String getIsNotIn() {
		return isNotIn;
	}

	public void setIsNotIn(String isNotIn) {
		this.isNotIn = isNotIn;
	}

	public String getNothingDim() {
		return nothingDim;
	}

	public void setNothingDim(String nothingDim) {
		this.nothingDim = nothingDim;
	}

	public String getItemInfoRptUrl() {
		return itemInfoRptUrl;
	}

	public void setItemInfoRptUrl(String itemInfoRptUrl) {
		this.itemInfoRptUrl = itemInfoRptUrl;
	}

	public String getAssignMentType() {
		return assignMentType;
	}

	public void setAssignMentType(String assignMentType) {
		this.assignMentType = assignMentType;
	}
    
}

