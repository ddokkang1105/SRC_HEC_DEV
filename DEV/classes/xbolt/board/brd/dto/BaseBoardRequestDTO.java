package xbolt.board.brd.dto;

public class BaseBoardRequestDTO {

	// Common identifiers
	private String boardMgtID = "";
	private String boardID = "";
	private String s_itemID = "";
	private String itemID = "";
	private String projectID = "";
	private String srID = "";

	// Screen / paging
	private String screenType = "";
	private String pageNum = "";
	private String currPage = "";
	private String listSize = "";
	private String page = "";

	// Search
	private String searchType = "";
	private String searchValue = "";
	private String searchKey = "";
	private String search = "";
	private String scStartDT = "";


	// Etc
	private String languageID = "";
	private String varFilter = "";
	private String url = "";
	private String templProjectID = "";
	private String projectType = "";
	private String projectCategory = "";

	// Session information
	private String sessionUserId = "";
	private String sessionCurrLangType = "";

	public String getSessionUserId() {
		return sessionUserId;
	}

	public void setSessionUserId(String sessionUserId) {
		this.sessionUserId = sessionUserId;
	}

	public String getSessionCurrLangType() {
		return sessionCurrLangType;
	}

	public void setSessionCurrLangType(String sessionCurrLangType) {
		this.sessionCurrLangType = sessionCurrLangType;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getTemplProjectID() {
		return templProjectID;
	}

	public void setTemplProjectID(String templProjectID) {
		this.templProjectID = templProjectID;
	}

	public String getProjectType() {
		return projectType;
	}

	public void setProjectType(String projectType) {
		this.projectType = projectType;
	}

	public String getProjectCategory() {
		return projectCategory;
	}

	public void setProjectCategory(String projectCategory) {
		this.projectCategory = projectCategory;
	}

	private String scEndDT = "";
	private String categoryIndex = "";
	private String categoryCnt = "";
	private String projectIDs = "";
	private String back = "";

	private String defBoardMgtID = "";
	private String categpryCnt = "";

	public String getDefBoardMgtID() {
		return defBoardMgtID;
	}

	public void setDefBoardMgtID(String defBoardMgtID) {
		this.defBoardMgtID = defBoardMgtID;
	}

	public String getCategpryCnt() {
		return categpryCnt;
	}

	public void setCategpryCnt(String categpryCnt) {
		this.categpryCnt = categpryCnt;
	}

	public String getCategoryIndex() {
		return categoryIndex;
	}

	public void setCategoryIndex(String categoryIndex) {
		this.categoryIndex = categoryIndex;
	}

	public String getCategoryCnt() {
		return categoryCnt;
	}

	public void setCategoryCnt(String categoryCnt) {
		this.categoryCnt = categoryCnt;
	}

	public String getProjectIDs() {
		return projectIDs;
	}

	public void setProjectIDs(String projectIDs) {
		this.projectIDs = projectIDs;
	}

	public String getBack() {
		return back;
	}

	public void setBack(String back) {
		this.back = back;
	}

	public String getBoardMgtID() {
		return boardMgtID;
	}

	public void setBoardMgtID(String boardMgtID) {
		this.boardMgtID = boardMgtID;
	}

	public String getBoardID() {
		return boardID;
	}

	public void setBoardID(String boardID) {
		this.boardID = boardID;
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

	public String getProjectID() {
		return projectID;
	}

	public void setProjectID(String projectID) {
		this.projectID = projectID;
	}

	public String getSrID() {
		return srID;
	}

	public void setSrID(String srID) {
		this.srID = srID;
	}

	public String getScreenType() {
		return screenType;
	}

	public void setScreenType(String screenType) {
		this.screenType = screenType;
	}

	public String getPageNum() {
		return pageNum;
	}

	public void setPageNum(String pageNum) {
		this.pageNum = pageNum;
	}

	public String getCurrPage() {
		return currPage;
	}

	public void setCurrPage(String currPage) {
		this.currPage = currPage;
	}

	public String getListSize() {
		return listSize;
	}

	public void setListSize(String listSize) {
		this.listSize = listSize;
	}

	public String getPage() {
		return page;
	}

	public void setPage(String page) {
		this.page = page;
	}

	public String getSearchType() {
		return searchType;
	}

	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}

	public String getSearchValue() {
		return searchValue;
	}

	public void setSearchValue(String searchValue) {
		this.searchValue = searchValue;
	}

	public String getSearchKey() {
		return searchKey;
	}

	public void setSearchKey(String searchKey) {
		this.searchKey = searchKey;
	}

	public String getSearch() {
		return search;
	}

	public void setSearch(String search) {
		this.search = search;
	}

	public String getScStartDT() {
		return scStartDT;
	}

	public void setScStartDT(String scStartDT) {
		this.scStartDT = scStartDT;
	}

	public String getScStartDt() {
		return getScStartDT();
	}

	public void setScStartDt(String scStartDt) {
		setScStartDT(scStartDt);
	}

	public String getScEndDT() {
		return scEndDT;
	}

	public void setScEndDT(String scEndDT) {
		this.scEndDT = scEndDT;
	}

	public String getScEndDt() {
		return getScEndDT();
	}

	public void setScEndDt(String scEndDt) {
		setScEndDT(scEndDt);
	}

	public String getLanguageID() {
		return languageID;
	}

	public void setLanguageID(String languageID) {
		this.languageID = languageID;
	}

	public String getVarFilter() {
		return varFilter;
	}

	public void setVarFilter(String varFilter) {
		this.varFilter = varFilter;
	}


	private String NEW = "";

	public String getNEW() {
		return NEW;
	}

	public void setNEW(String NEW) {
		this.NEW = NEW;
	}
}
