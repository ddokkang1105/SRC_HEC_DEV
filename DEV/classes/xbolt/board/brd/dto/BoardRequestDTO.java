package xbolt.board.brd.dto;

public class BoardRequestDTO extends BaseBoardRequestDTO {

	// Board list / filter


	private String category = "";

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}



	private String dueDateMgt = "";
	private String boardUrl = "";
	private String boardTypeCD = "";

	// Forum/board view options
	private String showAuthorInfo = "";
	private String showItemVersionInfo = "";
	private String showItemInfo = "";
	private String openDetailSearch = "";
	private String goDetailOpt = "";
	private String instanceNo = "";
	private String procInst = "";

	// SR style filters
	private String srType = "";
	private String srMode = "";
	private String srArea1 = "";
	private String srCategory = "";
	private String searchSrCode = "";
	private String requestUser = "";
	private String requestTeam = "";
	private String srReceiptTeam = "";
	private String regUserName = "";
	private String searchStatus = "";
	private String startRegDT = "";
	private String endRegDT = "";






	public String getBoardUrl() {
		return boardUrl;
	}

	public void setBoardUrl(String boardUrl) {
		this.boardUrl = boardUrl;
	}

	public String getBoardTypeCD() {
		return boardTypeCD;
	}

	public void setBoardTypeCD(String boardTypeCD) {
		this.boardTypeCD = boardTypeCD;
	}

	public String getShowAuthorInfo() {
		return showAuthorInfo;
	}

	public void setShowAuthorInfo(String showAuthorInfo) {
		this.showAuthorInfo = showAuthorInfo;
	}

	public String getShowItemVersionInfo() {
		return showItemVersionInfo;
	}

	public void setShowItemVersionInfo(String showItemVersionInfo) {
		this.showItemVersionInfo = showItemVersionInfo;
	}

	public String getShowItemInfo() {
		return showItemInfo;
	}

	public void setShowItemInfo(String showItemInfo) {
		this.showItemInfo = showItemInfo;
	}

	public String getOpenDetailSearch() {
		return openDetailSearch;
	}

	public void setOpenDetailSearch(String openDetailSearch) {
		this.openDetailSearch = openDetailSearch;
	}

	public String getGoDetailOpt() {
		return goDetailOpt;
	}

	public void setGoDetailOpt(String goDetailOpt) {
		this.goDetailOpt = goDetailOpt;
	}

	public String getInstanceNo() {
		return instanceNo;
	}

	public void setInstanceNo(String instanceNo) {
		this.instanceNo = instanceNo;
	}

	public String getProcInst() {
		return procInst;
	}

	public void setProcInst(String procInst) {
		this.procInst = procInst;
	}

	public String getSrType() {
		return srType;
	}

	public void setSrType(String srType) {
		this.srType = srType;
	}

	public String getSrMode() {
		return srMode;
	}

	public void setSrMode(String srMode) {
		this.srMode = srMode;
	}

	public String getSrArea1() {
		return srArea1;
	}

	public void setSrArea1(String srArea1) {
		this.srArea1 = srArea1;
	}

	public String getSrCategory() {
		return srCategory;
	}

	public void setSrCategory(String srCategory) {
		this.srCategory = srCategory;
	}

	public String getSearchSrCode() {
		return searchSrCode;
	}

	public void setSearchSrCode(String searchSrCode) {
		this.searchSrCode = searchSrCode;
	}

	public String getRequestUser() {
		return requestUser;
	}

	public void setRequestUser(String requestUser) {
		this.requestUser = requestUser;
	}

	public String getRequestTeam() {
		return requestTeam;
	}

	public void setRequestTeam(String requestTeam) {
		this.requestTeam = requestTeam;
	}

	public String getSrReceiptTeam() {
		return srReceiptTeam;
	}

	public void setSrReceiptTeam(String srReceiptTeam) {
		this.srReceiptTeam = srReceiptTeam;
	}

	public String getRegUserName() {
		return regUserName;
	}

	public void setRegUserName(String regUserName) {
		this.regUserName = regUserName;
	}

	public String getSearchStatus() {
		return searchStatus;
	}

	public void setSearchStatus(String searchStatus) {
		this.searchStatus = searchStatus;
	}

	public String getStartRegDT() {
		return startRegDT;
	}

	public void setStartRegDT(String startRegDT) {
		this.startRegDT = startRegDT;
	}

	public String getEndRegDT() {
		return endRegDT;
	}

	public void setEndRegDT(String endRegDT) {
		this.endRegDT = endRegDT;
	}

	// Legacy aliases for compatibility
	public String getIsProcInst() {
		return getProcInst();
	}

	public void setIsProcInst(String isProcInst) {
		setProcInst(isProcInst);
	}
}

