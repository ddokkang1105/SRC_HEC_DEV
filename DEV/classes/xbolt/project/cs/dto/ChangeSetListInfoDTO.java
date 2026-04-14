package xbolt.project.cs.dto;

/**
 * @author User
 *
 */
/**
 * @author User
 *
 */
public class ChangeSetListInfoDTO {

    // ===== 공통 =====
    private String listFilterType; // ITM/CSR/MY 
    private String listSubType;   // CSR일 때 DETAIL/TOTAL
    private String languageID;
    private String itemID;
    private String s_itemID;//  ITM / MY 공통  
    private String sessionUserId = "";
    private String  projectID;
    private String csrStatus;
    private String classCodes;
   


    // ===== CSR DETAIL(view/edit ItemCSInfo ) =====
    private String csrID;

    // ===== CSR TOTAL =====
    private String screenType;
    private String modStartDT;
    private String modEndDT;

    

    // ===== MY =====
    private String AuthorID;
    
    // 그외 관련 option 
    
    private String isFromPjt;
    private String changeSetID;
    
    
    // ===== csrDetailPop =====
 
    private String isMember;
    private String isManager;
    private String screenMode;
    private String refPjtID;
    private String mainMenu;
    private String srID;
    private String fromSR;
    private String quickCheckOut;
    private String fromITSP;

    
    // getter/setter ...
	public String getListFilterType() {
		return listFilterType;
	}

	public void setListFilterType(String listFilterType) {
		this.listFilterType = listFilterType;
	}

	public String getListSubType() {
		return listSubType;
	}

	public void setListSubType(String listSubType) {
		this.listSubType = listSubType;
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

	public String getCsrID() {
		return csrID;
	}

	public void setCsrID(String csrID) {
		this.csrID = csrID;
	}

	public String getScreenType() {
		return screenType;
	}

	public void setScreenType(String screenType) {
		this.screenType = screenType;
	}

	

	public String getModStartDT() {
		return modStartDT;
	}

	public void setModStartDT(String modStartDT) {
		this.modStartDT = modStartDT;
	}

	public String getModEndDT() {
		return modEndDT;
	}

	public void setModEndDT(String modEndDT) {
		this.modEndDT = modEndDT;
	}

	public String getAuthorID() {
		return AuthorID;
	}

	public void setAuthorID(String AuthorID) {
		this.AuthorID = AuthorID;
	}

	public String getIsFromPjt() {
		return isFromPjt;
	}

	public void setIsFromPjt(String isFromPjt) {
		this.isFromPjt = isFromPjt;
	}

	public String getChangeSetID() {
		return changeSetID;
	}

	public void setChangeSetID(String changeSetID) {
		this.changeSetID = changeSetID;
	}

	public String getSessionUserId() {
		return sessionUserId;
	}

	public void setSessionUserId(String sessionUserId) {
		this.sessionUserId = sessionUserId;
	}

	public String getCsrStatus() {
		return csrStatus;
	}

	public void setCsrStatus(String csrStatus) {
		this.csrStatus = csrStatus;
	}

	public String getIsMember() {
		return isMember;
	}

	public void setIsMember(String isMember) {
		this.isMember = isMember;
	}

	public String getIsManager() {
		return isManager;
	}

	public void setIsManager(String isManager) {
		this.isManager = isManager;
	}


	public String getScreenMode() {
		return screenMode;
	}

	public void setScreenMode(String screenMode) {
		this.screenMode = screenMode;
	}

	public String getItemID() {
		return itemID;
	}

	public void setItemID(String itemID) {
		this.itemID = itemID;
	}

	public String getRefPjtID() {
		return refPjtID;
	}

	public void setRefPjtID(String refPjtID) {
		this.refPjtID = refPjtID;
	}

	public String getMainMenu() {
		return mainMenu;
	}

	public void setMainMenu(String mainMenu) {
		this.mainMenu = mainMenu;
	}

	public String getSrID() {
		return srID;
	}

	public void setSrID(String srID) {
		this.srID = srID;
	}

	public String getFromSR() {
		return fromSR;
	}

	public void setFromSR(String fromSR) {
		this.fromSR = fromSR;
	}

	public String getQuickCheckOut() {
		return quickCheckOut;
	}

	public void setQuickCheckOut(String quickCheckOut) {
		this.quickCheckOut = quickCheckOut;
	}

	public String getFromITSP() {
		return fromITSP;
	}

	public void setFromITSP(String fromITSP) {
		this.fromITSP = fromITSP;
	}

	public String getProjectID() {
		return projectID;
	}

	public void setProjectID(String projectID) {
		this.projectID = projectID;
	}

	public String getClassCodes() {
		return classCodes;
	}

	public void setClassCodes(String classCodes) {
		this.classCodes = classCodes;
	}


   
    
    
}
