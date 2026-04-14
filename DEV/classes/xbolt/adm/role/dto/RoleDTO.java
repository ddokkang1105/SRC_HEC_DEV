package xbolt.adm.role.dto;

public class RoleDTO {

	// 필수 파라미터
    private String languageID = ""; // 언어코드
	
    // team option
    private String teamID = "";
    
    // role option
    private String roleManagerID = "";
    private String teamRoleType = "";
	
	// item option
    private String itemTypeCode = "";
    private String classCode = "";
    private String status = "";
	private String s_itemID = ""; // s_itemID
	private String itemID = ""; // itemID 트리로 들어올 경우
	private String nodeID = "";
	
	// search option
	private String searchKey = "";
	private String searchValue = "";
	
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
	public String getTeamID() {
		return teamID;
	}
	public void setTeamID(String teamID) {
		this.teamID = teamID;
	}
	public String getRoleManagerID() {
		return roleManagerID;
	}
	public void setRoleManagerID(String roleManagerID) {
		this.roleManagerID = roleManagerID;
	}
	public String getTeamRoleType() {
		return teamRoleType;
	}
	public void setTeamRoleType(String teamRoleType) {
		this.teamRoleType = teamRoleType;
	}
	public String getItemTypeCode() {
		return itemTypeCode;
	}
	public void setItemTypeCode(String itemTypeCode) {
		this.itemTypeCode = itemTypeCode;
	}
	public String getClassCode() {
		return classCode;
	}
	public void setClassCode(String classCode) {
		this.classCode = classCode;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getS_itemID() {
		return s_itemID;
	}
	public void setS_itemID(String s_itemID) {
		this.s_itemID = s_itemID;
	}
	public String getNodeID() {
		return nodeID;
	}
	public String getItemID() {
		return itemID;
	}

	public void setItemID(String itemID) {
		this.itemID = itemID;
	}
	public void setNodeID(String nodeID) {
		this.nodeID = nodeID;
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
	
	
}
