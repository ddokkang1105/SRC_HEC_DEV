package xbolt.itm.inf.dto;

import xbolt.cmm.framework.val.GlobalVal;

/**
 * 
 * @author 강서윤
 */

public class ItemInfoDTO {
	
	// 필수 파라미터
	private String sessionCurrLangType = ""; // 언어코드
    private String languageID = ""; // 언어코드
    private String s_itemID = ""; // s_itemID
    private String itemID = ""; // 아이템 id
    
    // cmm
    private String sessionUserId = "";
    
    // 화면 관련 파라미터
    private String scrnMode = ""; // [ V : view / E : edit / N : new ]
    private String itemViewPage = ""; // scrnMode가 V 일 때 이동할 url
    private String itemEditPage = ""; // srcnMode가 E 일 때 이동할 url
    private String itemNewPage = ""; // srcnMode가 N 일 때 이동할 url
    
    private String itemMainPage = ""; // itemMainMgt에서 사용하는 url
    private String itemInfoPage = ""; // itemInfoMgt에서 사용하는 url
    
    private String scrnType = ""; // [pop : 팝업]
    private String screenMode = "";
    
    // item 관련 파라미터
    private String changeSetID = ""; // changeSet id
    private String ClassCode = "";
    private String Identifier = "";
    private String ItemTypeCode = "";
    private String OwnerTeamID = "";
    private String CompanyID = "";
    private String Version = "";
    private String AuthorID = "";
    private String isSubItem = "";
    private String Editable = "";  // TB_ATTR_TYPE.Editable 
    
	// option 파라미터
    private String showInvisible = ""; // invisible 항목 조회 옵션  [ Y : show / N : hide ]
    private String accMode = ""; // 편집중 조회 모드 옵션 [ OPS : 릴리즈된 항목만 조회 / DEV : 편집중인 항목도 조회 ]
    private String conListYN = ""; // attr 정보에 connection List merge 옵션 [ Y : merge ]
    private String changeMgt = "";
    private String mdlOption = "";
    private String itemPropURL = "";
    private String papagoTrans = "";
    private String gptAITrans = "";
    private String autoID = ""; // auto 로 Identifier 설정 옵션 [ Y : auto ]
    
    // 첨부파일 옵션
    private String hideBlocked = "";
    private String csFilterYN = "";
    private String itemFileOption = ""; // 첨부파일 viewer 옵션
    
    // 연관항목 옵션
    private String notInCxnClsList = "";
    
    // popup 관련 파라미터
    private String htmlTitle = "";
    private String MTCategory = "";
    private String itemClassMenuURL = "";
    private String itemClassMenuVarFilter = "";
    private String itemAttrRevName = "";
    private String itemStatus = "";
    private String focusedItemID = "";
    private String loadEdit = "";
    private String option = "";
    
    // mgt 관련 파라미터
    private String arcCode = "";
    private String srType = "";
    private String showElement = "";
    private String currIdx = "";
    private String showPreNextIcon = "";
    private String level = "";
    private String fromModelYN = "";
    private String showTOJ = "";
    private String tLink = "";
    private String defDimValueID = "";
    private String showLink = "";
    private String myCSR = "";
    private String csrIDs = "";
    private String udfSTR = "";
    private String showAttr = "";
    private String ownerType = "";
    
    private String baseAtchUrl = GlobalVal.BASE_ATCH_URL;
    
    public void fillEmptyFields() {
    	
    	// itemID 혹은 s_itemID가 없을 경우, 둘 중 하나의 값으로 셋팅
    	boolean isItemIdEmpty = (this.itemID == null || this.itemID.trim().isEmpty());
        boolean isSItemIdEmpty = (this.s_itemID == null || this.s_itemID.trim().isEmpty());
        
        if (isItemIdEmpty && !isSItemIdEmpty) {
            this.itemID = this.s_itemID;
        } else if (!isItemIdEmpty && isSItemIdEmpty) {
            this.s_itemID = this.itemID;
        }
        
        // languageID 없을 경우 sessionCurrLangType 으로 셋팅
        if ("".equals(this.languageID) || this.languageID == null) {
            this.languageID = this.sessionCurrLangType;
        }
        
    }

	public String getSessionCurrLangType() {
		return sessionCurrLangType;
	}

	public void setSessionCurrLangType(String sessionCurrLangType) {
		this.sessionCurrLangType = sessionCurrLangType;
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

	public String getSessionUserId() {
		return sessionUserId;
	}

	public void setSessionUserId(String sessionUserId) {
		this.sessionUserId = sessionUserId;
	}

	public String getScrnMode() {
		return scrnMode;
	}

	public void setScrnMode(String scrnMode) {
		this.scrnMode = scrnMode;
	}

	public String getItemViewPage() {
		return itemViewPage;
	}

	public void setItemViewPage(String itemViewPage) {
		// 중복 제거
		if (itemViewPage != null && itemViewPage.contains(",")) {
            // 콤마로 구분된 값 중 첫 번째 값만 사용
            this.itemViewPage = itemViewPage.split(",")[0].trim();
        } else {
            this.itemViewPage = itemViewPage;
        }	
	}

	public String getItemEditPage() {
		return itemEditPage;
	}

	public void setItemEditPage(String itemEditPage) {
		// 중복 제거
		if (itemEditPage != null && itemEditPage.contains(",")) {
            // 콤마로 구분된 값 중 첫 번째 값만 사용
            this.itemEditPage = itemEditPage.split(",")[0].trim();
        } else {
            this.itemEditPage = itemEditPage;
        }
	}

	public String getItemNewPage() {
		return itemNewPage;
	}

	public void setItemNewPage(String itemNewPage) {
		// 중복 제거
		if (itemNewPage != null && itemNewPage.contains(",")) {
            // 콤마로 구분된 값 중 첫 번째 값만 사용
            this.itemNewPage = itemNewPage.split(",")[0].trim();
        } else {
            this.itemNewPage = itemNewPage;
        }
	}

	public String getItemMainPage() {
		return itemMainPage;
	}

	public void setItemMainPage(String itemMainPage) {
		// 중복 제거
		if (itemMainPage != null && itemMainPage.contains(",")) {
            // 콤마로 구분된 값 중 첫 번째 값만 사용
            this.itemMainPage = itemMainPage.split(",")[0].trim();
        } else {
            this.itemMainPage = itemMainPage;
        }
	}

	public String getItemInfoPage() {
		return itemInfoPage;
	}

	public void setItemInfoPage(String itemInfoPage) {
		// 중복 제거
		if (itemInfoPage != null && itemInfoPage.contains(",")) {
            // 콤마로 구분된 값 중 첫 번째 값만 사용
            this.itemInfoPage = itemInfoPage.split(",")[0].trim();
        } else {
            this.itemInfoPage = itemInfoPage;
        }	
	}

	public String getScrnType() {
		return scrnType;
	}

	public void setScrnType(String scrnType) {
		this.scrnType = scrnType;
	}

	public String getScreenMode() {
		return screenMode;
	}

	public void setScreenMode(String screenMode) {
		this.screenMode = screenMode;
	}

	public String getChangeSetID() {
		return changeSetID;
	}

	public void setChangeSetID(String changeSetID) {
		this.changeSetID = changeSetID;
	}

	public String getClassCode() {
		return ClassCode;
	}

	public void setClassCode(String classCode) {
		ClassCode = classCode;
	}

	public String getIdentifier() {
		return Identifier;
	}

	public void setIdentifier(String identifier) {
		Identifier = identifier;
	}

	public String getItemTypeCode() {
		return ItemTypeCode;
	}

	public void setItemTypeCode(String itemTypeCode) {
		ItemTypeCode = itemTypeCode;
	}

	public String getOwnerTeamID() {
		return OwnerTeamID;
	}

	public void setOwnerTeamID(String ownerTeamID) {
		OwnerTeamID = ownerTeamID;
	}

	public String getCompanyID() {
		return CompanyID;
	}

	public void setCompanyID(String companyID) {
		CompanyID = companyID;
	}

	public String getVersion() {
		return Version;
	}

	public void setVersion(String version) {
		Version = version;
	}

	public String getAuthorID() {
		return AuthorID;
	}

	public void setAuthorID(String authorID) {
		AuthorID = authorID;
	}

	public String getIsSubItem() {
		return isSubItem;
	}

	public void setIsSubItem(String isSubItem) {
		this.isSubItem = isSubItem;
	}
	
	public String getEditable() {
		return Editable;
	}

	public void setEditable(String Editable) {
		this.Editable = Editable;
	}

	public String getShowInvisible() {
		return showInvisible;
	}

	public void setShowInvisible(String showInvisible) {
		this.showInvisible = showInvisible;
	}

	public String getAccMode() {
		return accMode;
	}

	public void setAccMode(String accMode) {
		this.accMode = accMode;
	}

	public String getConListYN() {
		return conListYN;
	}

	public void setConListYN(String conListYN) {
		this.conListYN = conListYN;
	}

	public String getChangeMgt() {
		return changeMgt;
	}

	public void setChangeMgt(String changeMgt) {
		this.changeMgt = changeMgt;
	}

	public String getMdlOption() {
		return mdlOption;
	}

	public void setMdlOption(String mdlOption) {
		this.mdlOption = mdlOption;
	}

	public String getItemPropURL() {
		return itemPropURL;
	}

	public void setItemPropURL(String itemPropURL) {
		this.itemPropURL = itemPropURL;
	}

	public String getPapagoTrans() {
		return papagoTrans;
	}

	public void setPapagoTrans(String papagoTrans) {
		this.papagoTrans = papagoTrans;
	}

	public String getGptAITrans() {
		return gptAITrans;
	}

	public void setGptAITrans(String gptAITrans) {
		this.gptAITrans = gptAITrans;
	}

	public String getAutoID() {
		return autoID;
	}

	public void setAutoID(String autoID) {
		this.autoID = autoID;
	}

	public String getHideBlocked() {
		return hideBlocked;
	}

	public void setHideBlocked(String hideBlocked) {
		this.hideBlocked = hideBlocked;
	}

	public String getCsFilterYN() {
		return csFilterYN;
	}

	public void setCsFilterYN(String csFilterYN) {
		this.csFilterYN = csFilterYN;
	}

	public String getItemFileOption() {
		return itemFileOption;
	}

	public void setItemFileOption(String itemFileOption) {
		this.itemFileOption = itemFileOption;
	}

	public String getNotInCxnClsList() {
		return notInCxnClsList;
	}

	public void setNotInCxnClsList(String notInCxnClsList) {
		this.notInCxnClsList = notInCxnClsList;
	}

	public String getHtmlTitle() {
		return htmlTitle;
	}

	public void setHtmlTitle(String htmlTitle) {
		this.htmlTitle = htmlTitle;
	}

	public String getMTCategory() {
		return MTCategory;
	}

	public void setMTCategory(String mTCategory) {
		MTCategory = mTCategory;
	}

	public String getItemClassMenuURL() {
		return itemClassMenuURL;
	}

	public void setItemClassMenuURL(String itemClassMenuURL) {
		this.itemClassMenuURL = itemClassMenuURL;
	}

	public String getItemClassMenuVarFilter() {
		return itemClassMenuVarFilter;
	}

	public void setItemClassMenuVarFilter(String itemClassMenuVarFilter) {
		this.itemClassMenuVarFilter = itemClassMenuVarFilter;
	}

	public String getItemAttrRevName() {
		return itemAttrRevName;
	}

	public void setItemAttrRevName(String itemAttrRevName) {
		this.itemAttrRevName = itemAttrRevName;
	}

	public String getItemStatus() {
		return itemStatus;
	}

	public void setItemStatus(String itemStatus) {
		this.itemStatus = itemStatus;
	}

	public String getFocusedItemID() {
		return focusedItemID;
	}

	public void setFocusedItemID(String focusedItemID) {
		this.focusedItemID = focusedItemID;
	}

	public String getLoadEdit() {
		return loadEdit;
	}

	public void setLoadEdit(String loadEdit) {
		this.loadEdit = loadEdit;
	}

	public String getOption() {
		return option;
	}

	public void setOption(String option) {
		this.option = option;
	}

	public String getArcCode() {
		return arcCode;
	}

	public void setArcCode(String arcCode) {
		this.arcCode = arcCode;
	}

	public String getSrType() {
		return srType;
	}

	public void setSrType(String srType) {
		this.srType = srType;
	}

	public String getShowElement() {
		return showElement;
	}

	public void setShowElement(String showElement) {
		this.showElement = showElement;
	}

	public String getCurrIdx() {
		return currIdx;
	}

	public void setCurrIdx(String currIdx) {
		this.currIdx = currIdx;
	}

	public String getShowPreNextIcon() {
		return showPreNextIcon;
	}

	public void setShowPreNextIcon(String showPreNextIcon) {
		this.showPreNextIcon = showPreNextIcon;
	}

	public String getLevel() {
		return level;
	}

	public void setLevel(String level) {
		this.level = level;
	}

	public String getFromModelYN() {
		return fromModelYN;
	}

	public void setFromModelYN(String fromModelYN) {
		this.fromModelYN = fromModelYN;
	}

	public String getShowTOJ() {
		return showTOJ;
	}

	public void setShowTOJ(String showTOJ) {
		this.showTOJ = showTOJ;
	}

	public String gettLink() {
		return tLink;
	}

	public void settLink(String tLink) {
		this.tLink = tLink;
	}

	public String getDefDimValueID() {
		return defDimValueID;
	}

	public void setDefDimValueID(String defDimValueID) {
		this.defDimValueID = defDimValueID;
	}

	public String getShowLink() {
		return showLink;
	}

	public void setShowLink(String showLink) {
		this.showLink = showLink;
	}

	public String getMyCSR() {
		return myCSR;
	}

	public void setMyCSR(String myCSR) {
		this.myCSR = myCSR;
	}

	public String getCsrIDs() {
		return csrIDs;
	}

	public void setCsrIDs(String csrIDs) {
		this.csrIDs = csrIDs;
	}

	public String getUdfSTR() {
		return udfSTR;
	}

	public void setUdfSTR(String udfSTR) {
		this.udfSTR = udfSTR;
	}

	public String getShowAttr() {
		return showAttr;
	}

	public void setShowAttr(String showAttr) {
		this.showAttr = showAttr;
	}

	public String getOwnerType() {
		return ownerType;
	}

	public void setOwnerType(String ownerType) {
		this.ownerType = ownerType;
	}

	public String getBaseAtchUrl() {
		return baseAtchUrl;
	}

	public void setBaseAtchUrl(String baseAtchUrl) {
		this.baseAtchUrl = baseAtchUrl;
	}
    
    
    
   
	
}

