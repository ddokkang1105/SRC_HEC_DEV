package xbolt.api.dto;

import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.annotation.JsonProperty;

import xbolt.cmm.framework.util.StringUtil;

public class ItemDto {
	
	
	//기타 필요한 변수 선언
	private String DocSite;
	private String DocLvl;
	private String DocDomain;
	
	
	
	//아래 변수는 고정 편집 x
	//*************************************************
	private String ItemID;
	private String Identifier;
	private String ParentId;
	
	//technical standard & Tree lv5
	private String ClassCode;
	private String ItemTypeCode;
	private String CategoryCode;
	
	private String ProjectID;
	private String Deleted;
	private String Status;
	private String LanguageID;
	private String NctTyp;
	
	//reg user
	private String Creator;
	private String CreatorName;
	private String AuthorID;
	private String CompanyID;
	private String OwnerTeamId;
	
	//ChangeSet Description
	private String RevDesc;
	//Item Attr Description
	private String PlainText;
	
	//객체 생성 시 null인 부분
	private String ToItemID;
	private String FromItemID;
	private String RefItemID;
	private String CurChangeSet;
	private String ReleaseNo;
	private String AccCtrl;
	private String Level;

	
	//fromParentId
	private String Lvl1;
	private String Lvl2;
	private String Lvl3;
	private String Lvl4;

	private int Version;
	
	//File 고정값(File Default Option)
	private String DocCategory;
	private String FltpCode;
	
	
	//구, 신버전을 위한 flag
	private boolean isUpgradedVersion;
	private String nowChangeSet;
	private String newChangeSet;
	
	//File List
	private List<Map<String,Object>> FileList;

	//*************************************************



	
	public ItemDto() {}
	public ItemDto(RequestDto requestDto) {
		
		//객체 생성 후 set
		//*************************************************
		this.ItemID = null;
		this.ProjectID = null;
		this.Identifier = null;
		this.ParentId = null;
		//*************************************************

		//parentId 찾는 용도
		//*************************************************
		this.Lvl1 = StringUtil.checkNull(requestDto.getLvl1());
		this.Lvl2 = StringUtil.checkNull(requestDto.getLvl2());
		this.Lvl3 = StringUtil.checkNull("전극");
		this.Lvl4 = StringUtil.checkNull(requestDto.getLvl4());
		//*************************************************
		
		this.ItemTypeCode = StringUtil.checkNull(requestDto.getItemTypeCode());
		this.CategoryCode= StringUtil.checkNull(requestDto.getCategoryCode());
		this.ClassCode = StringUtil.checkNull(requestDto.getClassCode());
		this.NctTyp = StringUtil.checkNull(requestDto.getNctTyp());
		this.Version = requestDto.getVersion();
	
		//default user info
		this.Creator = "1";
		this.AuthorID = "1";
		this.OwnerTeamId = "958";//sys
		this.CompanyID = "23";//sys
		this.CreatorName = "관리자";

		this.Deleted = StringUtil.checkNull(requestDto.getDeleted());
		this.Status = StringUtil.checkNull(requestDto.getStatus());
		this.LanguageID = StringUtil.checkNull(requestDto.getLanguageID());	
		this.DocSite = StringUtil.checkNull(requestDto.getSiteName());	
		
		this.ToItemID = null;
		this.FromItemID = null; //Lv1, Lv2, Lv3, Lv4
		this.RefItemID = null;
		this.CurChangeSet = null;
		this.ReleaseNo = null;
		this.AccCtrl = null;
		this.Level = null;

		
		//ChangeSet Description
		this.RevDesc = StringUtil.checkNull(requestDto.getRevDesc());
		//Attr Description
		this.PlainText = StringUtil.checkNull(requestDto.getDescription());
		//File
		this.DocCategory = StringUtil.checkNull(requestDto.getDocCategory());
		this.FltpCode = StringUtil.checkNull(requestDto.getFltpCode());

		//최신 버전인지 확인 flag
		this.isUpgradedVersion = true;
		
	}

	
	//Setter
	public void setItemID(String itemID) {
		this.ItemID = itemID;
	}
	

	public void setProjectID(String projectID) {
		this.ProjectID = projectID;
	}


	public void setParentId(String parentId) {
		this.ParentId = parentId;
	}

	public void setIdentifier(String identifier) {
		this.Identifier = identifier;
	}
	
	public void setFileList(List<Map<String,Object>> FileList) {
		this.FileList = FileList;
	}
	
	
	public void setReleaseNo(String ReleaseNo) {
		this.ReleaseNo = ReleaseNo;
	}
	public void setCurChangeSet(String CurChangeSet) {
		this.CurChangeSet = CurChangeSet;
	}
	public void setIsUpgradedVersion(boolean isUpgradedVersion) {
		this.isUpgradedVersion = isUpgradedVersion;
	}
	public void setNowChangeSet(String nowChangeSet) {
		this.nowChangeSet = nowChangeSet;
	}
	public void setNewChangeSet(String newChangeSet) {
		this.newChangeSet = newChangeSet;
	}

	
	//Getter
	@JsonProperty("ItemID")
	public String getItemID() {
		return ItemID;
	}
	
	@JsonProperty("Identifier")
	public String getIdentifier() {
		return Identifier;
	}
	
	@JsonProperty("ClassCode")
	public String getClassCode() {
		return ClassCode;
	}
	
	@JsonProperty("ItemTypeCode")
	public String getItemTypeCode() {
		return ItemTypeCode;
	}
	
	@JsonProperty("CategoryCode")
	public String getCategoryCode() {
		return CategoryCode;
	}
	
	@JsonProperty("ProjectID")
	public String getProjectID() {
		return ProjectID;
	}
	
	@JsonProperty("Version")
	public int getVersion() {
		return Version;
	}
	
	@JsonProperty("Creator")
	public String getCreator() {
		return Creator;
	}
	
	@JsonProperty("AuthorID")
	public String getAuthorID() {
		return AuthorID;
	}
	
	@JsonProperty("CompanyID")
	public String getCompanyID() {
		return CompanyID;
	}
	
	@JsonProperty("OwnerTeamId")
	public String getOwnerTeamId() {
		return OwnerTeamId;
	}
	
	@JsonProperty("Deleted")
	public String getDeleted() {
		return Deleted;
	}
	
	@JsonProperty("Status")
	public String getStatus() {
		return Status;
	}
	
	@JsonProperty("LanguageID")
	public String getLanguageID() {
		return LanguageID;
	}
	
	@JsonProperty("ToItemID")
	public String getToItemID() {
		return ToItemID;
	}
	
	@JsonProperty("FromItemID")
	public String getFromItemID() {
		return FromItemID;
	}
	
	@JsonProperty("RefItemID")
	public String getRefItemID() {
		return RefItemID;
	}
	
	@JsonProperty("CurChangeSet")
	public String getCurChangeSet() {
		return CurChangeSet;
	}
	
	@JsonProperty("ReleaseNo")
	public String getReleaseNo() {
		return ReleaseNo;
	}
	
	@JsonProperty("AccCtrl")
	public String getAccCtrl() {
		return AccCtrl;
	}
	
	@JsonProperty("Level")
	public String getLevel() {
		return Level;
	}
	
	@JsonProperty("SiteName")
	public String getSiteName() {
		return DocSite;
	}
	
	@JsonProperty("PlainText")
	public String getPlainText() {
		return PlainText;
	}

	@JsonProperty("DocCategory")
	public String getDocCategory() {
		return DocCategory;
	}
	
	@JsonProperty("FltpCode")
	public String getFltpCode() {
		return FltpCode;
	}

	
	@JsonProperty("NctTyp")
	public String getNctTyp() {
		return NctTyp;
	}
	
	@JsonProperty("RevDesc")
	public String getRevDesc() {
		return RevDesc;
	}
	
	
	@JsonProperty("FileList")
	public List<Map<String, Object>> getFileList() {
		return FileList;
	}
	
	public String getLvl1() {
		return Lvl1;
	}
	
	public String getLvl2() {
		return Lvl2;
	}
	
	public String getLvl3() {
		return Lvl3;
	}
	
	public String getLvl4() {
		return Lvl4;
	}

	public String getCreatorName() {
		return CreatorName;
	}
	
	public boolean getIsUpgradedVersion() {
		return isUpgradedVersion;
	}

	public String getNowChangeSet() {
		return nowChangeSet;
	}
	public String getNewChangeSet() {
		return newChangeSet;
	}
	
	
	@JsonProperty("DocLvl")
	public String getDocLvl() {
		return DocLvl;
	}
	
	@JsonProperty("DocDomain")
	public String getDocDomain() {
		return DocDomain;
	}
	
	

	//ItemDto 담당자 설정
	public void setUserInfo(Map<String,Object> map) {

		this.AuthorID = StringUtil.checkNull(map.get("MemberID"));
		this.Creator = StringUtil.checkNull(map.get("MemberID"));
		this.CreatorName = StringUtil.checkNull(map.get("Name"));
		this.OwnerTeamId = StringUtil.checkNull(map.get("TeamID"));
		this.CompanyID = StringUtil.checkNull(map.get("CompanyID"));
	}
	
	
	//기존에 존재하는 Item update를 위한 ItemDto 생성
	public void setDuplicatedItemInfo(Map<String,Object> map, Map<String, Object> userMap) {

		this.ItemID = StringUtil.checkNull(map.get("itemId"));
		this.Identifier = StringUtil.checkNull(map.get("identifier"));
		this.ProjectID = StringUtil.checkNull(map.get("projectId"));
		this.isUpgradedVersion = ((Boolean)(map.get("isUpgradedVersion"))).booleanValue();
		this.nowChangeSet = StringUtil.checkNull(map.get("curChangeSet"));//기존에 있던 changeSet Version
		setUserInfo(userMap);
	}



}
