package xbolt.api.dto;


import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.annotation.JsonProperty;

import xbolt.api.enumType.ErrorCode;
import xbolt.api.web.apiGlobalVal;

public class RequestDto {
	

	@JsonProperty("etc")
	private String etc;
	

	
	
	//Custom시에도 필수 고정 사항	(불변)
	//*************************************************
	@JsonProperty("docNo")
	private String docNo;
	@JsonProperty("version")
	private int version;
	@JsonProperty("userId")
	private String userId;
	
	
	@JsonProperty("lvl1")
	private String lvl1;
	@JsonProperty("lvl2")
	private String lvl2;
	@JsonProperty("lvl3")
	private String lvl3;
	@JsonProperty("lvl4")
	private String lvl4;
	

	@JsonProperty("siteName")
	private String siteName;
	@JsonProperty("nctTyp")
	private String nctTyp;
	@JsonProperty("description")
	private String description;
	@JsonProperty("docName")
	private String docName;
	@JsonProperty("opTyp")
	private String opTyp;
	@JsonProperty("revDesc")
	private String revDesc;

	@JsonProperty("dimension")
	private List<Map<String,String>> dimension;	
	@JsonProperty("files")
	private List<Map<String,String>> files;	
	private ErrorCode errorCode;
	private List<String> notNullColumn;
	private String orgFilePath;
	private String chgFilePath;

	private String itemTypeCode;
	private String categoryCode;
	private String classCode;
	private String status;
	private String deleted;
	private String languageID;
	private String docCategory;
	private String fltpCode;
	//*************************************************
	
	public RequestDto() {
	}
	
	public RequestDto(
			
			String etc
			
			//Custom시에도 필수 고정 사항(불변)
			//*************************************************
			,String docNo, int version, String userId, String lvl1, String lvl2, String lvl3, String lvl4, 
			String nctTyp, List<Map<String,String>> dimension, List<Map<String,String>> files,
			String siteName, String docName, String description, String revDesc, String opTyp, ErrorCode errorCode
			//*************************************************
			) {
			
	


		this.etc = etc;
		
		

		
		//Custom마다 값만 바꿔줘야 하는 부분
		//*************************************************
		this.status = "REL";
		this.languageID = "1042";
		this.deleted = "0";
		
		this.itemTypeCode = "OJ00016";
		this.categoryCode = "OJ";
		this.classCode = "CL16004";
		this.docCategory = "ITM";
		this.fltpCode = "FLTP009";
		//*************************************************
		
		
		

		String[] blackList = {  "etc"
				
		//Custom시에도 필수 고정 사항(불변)
		//*************************************************
				, "docNo", "docName", "version", "userId", "Lvl1", "Lvl2", "Lvl3", "Lvl4"
				, "nctTyp", "files", "dimension", "siteName", "opType"
				};


		this.docNo = docNo;
		this.version = version;
		this.userId = userId;

		this.lvl1 = lvl1;
		this.lvl2 = lvl2;
		this.lvl3 = lvl3;
		this.lvl4 = lvl4;
		this.nctTyp = nctTyp;
		

		this.siteName = siteName;
		this.docName = docName;
		this.description = description;
		this.revDesc = revDesc;
		
		this.dimension = dimension;
		this.files = files;
		this.opTyp = opTyp;
		this.errorCode = errorCode;
		this.orgFilePath = apiGlobalVal.OLM_API_FILE_UPLOAD_PATH;
		this.chgFilePath = "C://OLMFILE//document//";
		this.notNullColumn = new ArrayList<String>(Arrays.asList(blackList));
		//*************************************************

		//결재가 되서 들어오는지 아닌지
		this.status = "REL";//NEW
	}

	
	
	//custom getter, setter
	public void setEtc(String etc) {
		this.etc = etc;
	}

	public String getEtc() {
		return etc;
	}

	
	
	
	//Custom시에도 필수 고정 사항	(불변) getter, setter
	//*************************************************
	public String getDocName() {
		return docName;
	}
	public String getSiteName() {
		return siteName;
	}
	public String getNctTyp() {
		return nctTyp;
	}
	public String getDescription() {
		return description;
	}
	public String getOpTyp() {
		return opTyp;
	}

	public String getRevDesc() {
		return revDesc;
	}
	
	public String getDocNo() {
		return docNo;
	}
	public int getVersion() {
		return version;
	}
	public String getUserId() {
		return userId;
	}
	
	public String getLvl1() {
		return lvl1;
	}
	public String getLvl2() {
		return lvl2;
	}
	public String getLvl3() {
		return lvl3;
	}
	public String getLvl4() {
		return lvl4;
	}
	
	public List<Map<String,String>> getDimension() {
		return dimension;
	}
	
	public List<Map<String,String>> getFiles() {
		return files;
	}

	public ErrorCode getErrorCode() {
		return errorCode;
	}
	
	public String getOrgFilePath() {
		return orgFilePath;
	}

	public String getChgFilePath() {
		return chgFilePath;
	}
	
	public String getStatus() {
		return status;
	}
	public String getDeleted() {
		return deleted;
	}
	public String getLanguageID() {
		return languageID;
	}
	
	public String getItemTypeCode() {
		return itemTypeCode;
	}
	public String getCategoryCode() {
		return categoryCode;
	}
	public String getClassCode() {
		return classCode;
	}
	
	public String getDocCategory() {
		return docCategory;
	}
	public String getFltpCode() {
		return fltpCode;
	}
	
	public void setDocNo(String docNo) {
		this.docNo = docNo;
	}

	public void setVersion(int version) {
		this.version = version;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	public void setLvl1(String lv1l) {
		this.lvl1 = lv1l;
	}

	public void setLvl2(String lvl2) {
		this.lvl2 = lvl2;
	}

	public void setLvl3(String lvl3) {
		this.lvl3 = lvl3;
	}

	public void setLvl4(String lvl4) {
		this.lvl4 = lvl4;
	}
	public void setErrorCode(ErrorCode errorCode) {
		this.errorCode = errorCode;
	}
	
	public void setDimension(List<Map<String,String>> dimension) {
		this.dimension = dimension;
	}
	
	public void setFiles(List<Map<String,String>> files) {
		this.files = files;
	}
	

	public void setDocName(String docName) {
		this.docName = docName;
	}


	public void setSiteName(String siteName) {
		this.siteName = siteName;
	}


	public void setNctTyp(String nctTyp) {
		this.nctTyp = nctTyp;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public void setOpTyp(String opTyp) {
		this.opTyp = opTyp;
	}

	public void setRevDesc(String revDesc) {
		this.revDesc = revDesc;
	}


	
	public List<String> getNotNullColumn() {
		return notNullColumn;
	}
	
	//*************************************************
	

}
