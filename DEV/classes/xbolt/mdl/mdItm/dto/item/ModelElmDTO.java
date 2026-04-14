package xbolt.mdl.mdItm.dto.item;

public class ModelElmDTO {

    private String s_itemID;
    private String modelID;
    private String languageID;
    private String gridChk = "element"; // 기본값
    private String MTCategory;
    
    // element 탭 관련 필드
    private String classCode;
    private String searchKey;
    private String searchValue;
    private boolean showChild; // 체크박스이므로 boolean 타입

    // group 탭 관련 필드
    private String groupClassCode;
    private String groupElementCode;

    public String getS_itemID() { return s_itemID; }
    public void setS_itemID(String s_itemID) { this.s_itemID = s_itemID; }
    
    public String getModelID() { return modelID; }
    public void setModelID(String modelID) { this.modelID = modelID; }

    public String getLanguageID() { return languageID; }
    public void setLanguageID(String languageID) { this.languageID = languageID; }

    public String getGridChk() { return gridChk; }
    public void setGridChk(String gridChk) { this.gridChk = gridChk; }

    public String getMTCategory() { return MTCategory; }
    public void setMTCategory(String MTCategory) { this.MTCategory = MTCategory; }

    public String getClassCode() { return classCode; }
    public void setClassCode(String classCode) { this.classCode = classCode; }

    public String getSearchKey() { return searchKey; }
    public void setSearchKey(String searchKey) { this.searchKey = searchKey; }

    public String getSearchValue() { return searchValue; }
    public void setSearchValue(String searchValue) { this.searchValue = searchValue; }

    public boolean isShowChild() { return showChild; } // boolean 타입의 getter는 isXxx
    public void setShowChild(boolean showChild) { this.showChild = showChild; }

    public String getGroupClassCode() { return groupClassCode; }
    public void setGroupClassCode(String groupClassCode) { this.groupClassCode = groupClassCode; }

    public String getGroupElementCode() { return groupElementCode; }
    public void setGroupElementCode(String groupElementCode) { this.groupElementCode = groupElementCode; }
}
