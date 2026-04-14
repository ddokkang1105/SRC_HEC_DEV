package xbolt.board.brd.dto;

public class ForumRequestDTO extends BaseBoardRequestDTO {

	// Write/update payload
	private String subject = "";
	private String content = "";
	private String content_new = "";
	private String boardTitle = "";
	private String replyLev = "";
	private String parentID = "";
	private String parentRefID = "";
	private String commentID = "";
	private String refID = "";
	private String score = "";
	private String type = "";

	// Forum options
	private String mailRcvListSQL = "";
	private String emailCode = "";
	private String replyMailOption = "";
	private String forumMailOption = "";
	private String showReplyDT = "";
	private String showItemInfo = "";
	private String showAuthorInfo = "";
	private String showItemVersionInfo = "";
	private String openDetailSearch = "";
	private String goDetailOpt = "";
	private String dueDateMgt = "";

	// File / upload
	private String uploadToken = "";
	private String fileTokenYN = "";
	private String scrnType = "";

	private String itemAuthorID = "";
	private String receiptUser = "";
	private String sharers = "";
	private String sharerNames = "";
	private String postEmailYn = "";
	private String blocked = "";
	private String itemTypeCode = "";
	private String userID = "";
	private String regUserID = "";
	
	private String regUserName = "";
	private String authorName = "";
	
	private String isMyCop = "";
	private String category = "";
	private String listType = "";
	private String boardIds = "";
	private String srType = "";
	private String noticType = "";
	private String srCategory = "";
	private String srArea1 = "";
	private String searchStatus = "";
	private String requestUser = "";
	private String requestTeam = "";
	private String startRegDT = "";
	private String endRegDT = "";
	private String searchSrCode = "";
	private String srReceiptTeam = "";
	private String srMode = "";
	private String filter = "";
	private String myBoard = "";

	public String getMyBoard() {
		return myBoard;
	}

	public void setMyBoard(String myBoard) {
		this.myBoard = myBoard;
	}

	public String getFilter() {
		return filter;
	}

	public void setFilter(String filter) {
		this.filter = filter;
	}

	public String getIsMyCop() {
		return isMyCop;
	}

	public void setIsMyCop(String isMyCop) {
		this.isMyCop = isMyCop;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getListType() {
		return listType;
	}

	public void setListType(String listType) {
		this.listType = listType;
	}

	public String getBoardIds() {
		return boardIds;
	}

	public void setBoardIds(String boardIds) {
		this.boardIds = boardIds;
	}

	public String getSrType() {
		return srType;
	}

	public void setSrType(String srType) {
		this.srType = srType;
	}

	public String getNoticType() {
		return noticType;
	}

	public void setNoticType(String noticType) {
		this.noticType = noticType;
	}

	public String getSrCategory() {
		return srCategory;
	}

	public void setSrCategory(String srCategory) {
		this.srCategory = srCategory;
	}

	public String getSrArea1() {
		return srArea1;
	}

	public void setSrArea1(String srArea1) {
		this.srArea1 = srArea1;
	}

	public String getSearchStatus() {
		return searchStatus;
	}

	public void setSearchStatus(String searchStatus) {
		this.searchStatus = searchStatus;
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

	public String getSearchSrCode() {
		return searchSrCode;
	}

	public void setSearchSrCode(String searchSrCode) {
		this.searchSrCode = searchSrCode;
	}

	public String getSrReceiptTeam() {
		return srReceiptTeam;
	}

	public void setSrReceiptTeam(String srReceiptTeam) {
		this.srReceiptTeam = srReceiptTeam;
	}

	public String getSrMode() {
		return srMode;
	}

	public void setSrMode(String srMode) {
		this.srMode = srMode;
	}

	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getContent_new() {
		return content_new;
	}

	public void setContent_new(String content_new) {
		this.content_new = content_new;
	}

	public String getBoardTitle() {
		return boardTitle;
	}

	public void setBoardTitle(String boardTitle) {
		this.boardTitle = boardTitle;
	}

	public String getReplyLev() {
		return replyLev;
	}

	public void setReplyLev(String replyLev) {
		this.replyLev = replyLev;
	}

	public String getParentID() {
		return parentID;
	}

	public void setParentID(String parentID) {
		this.parentID = parentID;
	}

	public String getParentRefID() {
		return parentRefID;
	}

	public void setParentRefID(String parentRefID) {
		this.parentRefID = parentRefID;
	}

	public String getCommentID() {
		return commentID;
	}

	public void setCommentID(String commentID) {
		this.commentID = commentID;
	}

	public String getRefID() {
		return refID;
	}

	public void setRefID(String refID) {
		this.refID = refID;
	}

	public String getScore() {
		return score;
	}

	public void setScore(String score) {
		this.score = score;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getMailRcvListSQL() {
		return mailRcvListSQL;
	}

	public void setMailRcvListSQL(String mailRcvListSQL) {
		this.mailRcvListSQL = mailRcvListSQL;
	}

	public String getEmailCode() {
		return emailCode;
	}

	public void setEmailCode(String emailCode) {
		this.emailCode = emailCode;
	}

	public String getReplyMailOption() {
		return replyMailOption;
	}

	public void setReplyMailOption(String replyMailOption) {
		this.replyMailOption = replyMailOption;
	}

	public String getForumMailOption() {
		return forumMailOption;
	}

	public void setForumMailOption(String forumMailOption) {
		this.forumMailOption = forumMailOption;
	}

	public String getShowReplyDT() {
		return showReplyDT;
	}

	public void setShowReplyDT(String showReplyDT) {
		this.showReplyDT = showReplyDT;
	}

	public String getShowItemInfo() {
		return showItemInfo;
	}

	public void setShowItemInfo(String showItemInfo) {
		this.showItemInfo = showItemInfo;
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

	public String getUploadToken() {
		return uploadToken;
	}

	public void setUploadToken(String uploadToken) {
		this.uploadToken = uploadToken;
	}

	public String getFileTokenYN() {
		return fileTokenYN;
	}

	public void setFileTokenYN(String fileTokenYN) {
		this.fileTokenYN = fileTokenYN;
	}

	public String getItemTypeCode() {
		return itemTypeCode;
	}

	public void setItemTypeCode(String itemTypeCode) {
		this.itemTypeCode = itemTypeCode;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getRegUserID() {
		return regUserID;
	}

	public void setRegUserID(String regUserID) {
		this.regUserID = regUserID;
	}

	public String getItemAuthorID() {
		return itemAuthorID;
	}

	public void setItemAuthorID(String itemAuthorID) {
		this.itemAuthorID = itemAuthorID;
	}

	public String getReceiptUser() {
		return receiptUser;
	}

	public void setReceiptUser(String receiptUser) {
		this.receiptUser = receiptUser;
	}

	public String getSharers() {
		return sharers;
	}

	public void setSharers(String sharers) {
		this.sharers = sharers;
	}

	public String getSharerNames() {
		return sharerNames;
	}

	public void setSharerNames(String sharerNames) {
		this.sharerNames = sharerNames;
	}

	public String getPostEmailYn() {
		return postEmailYn;
	}

	public void setPostEmailYn(String postEmailYn) {
		this.postEmailYn = postEmailYn;
	}

	public String getBlocked() {
		return blocked;
	}

	public void setBlocked(String blocked) {
		this.blocked = blocked;
	}

	// camelCase alias
	public String getContentNew() {
		return getContent_new();
	}

	public void setContentNew(String contentNew) {
		setContent_new(contentNew);
	}

	public String getPostEmailYN() {
		return getPostEmailYn();
	}

	public void setPostEmailYN(String postEmailYN) {
		setPostEmailYn(postEmailYN);
	}

	public String getDueDateMgt() {
		return dueDateMgt;
	}

	public void setDueDateMgt(String dueDateMgt) {
		this.dueDateMgt = dueDateMgt;
	}

	public String getScrnType() {
		return scrnType;
	}

	public void setScrnType(String scrnType) {
		this.scrnType = scrnType;
	}

	public String getRegUserName() {
		return regUserName;
	}

	public void setRegUserName(String regUserName) {
		this.regUserName = regUserName;
	}

	public String getAuthorName() {
		return authorName;
	}

	public void setAuthorName(String authorName) {
		this.authorName = authorName;
	}
}
