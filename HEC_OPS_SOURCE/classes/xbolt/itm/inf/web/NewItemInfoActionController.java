package xbolt.itm.inf.web;

import java.io.PrintStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.text.StringEscapeUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.GetItemAttrList;
import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.util.compareText;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

@Controller
public class NewItemInfoActionController extends XboltController
{

  @Resource(name="commonService")
  private CommonService commonService;

  @Resource(name="itemInfoService")
  private CommonService itemInfoService;
  private final Log _log = LogFactory.getLog(getClass());

  @RequestMapping({"/NewItemInfoMain.do"})
  public String NewItemInfoMain(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception { Map target = new HashMap();
    String url = "";
    try
    {
      String showVersion = StringUtil.checkNull(commandMap.get("varFilter"));

      Map setMap = new HashMap();
      setMap.put("languageID", request.getParameter("languageID"));
      setMap.put("s_itemID", request.getParameter("s_itemID"));
      setMap.put("itemId", request.getParameter("s_itemID"));
      String itemFileOption = this.commonService.selectString("fileMgt_SQL.getFileOption", setMap);
      setMap.remove("itemId");

      model.put("itemFileOption", itemFileOption);

      String className = "";
      List pertinentDetailList = new ArrayList();
      List relItemRowList = new ArrayList();
      String strClassName = "";
      int classNameCnt = 1;
      String Level = "";
      String defaultLang = this.commonService.selectString("item_SQL.getDefaultLang", setMap);
      setMap.put("itemID", request.getParameter("s_itemID"));
      setMap.put("status", "CLS");

      String itemReleaseVersion = this.commonService.selectString("cs_SQL.getItemReleaseVersion", setMap);
      String itemValidFrom = this.commonService.selectString("cs_SQL.getItemValidFrom", setMap);
      setMap.remove("status");
      setMap.remove("itemID");
      model.put("itemReleaseVersion", itemReleaseVersion);
      model.put("itemValidFrom", itemValidFrom);

      List prcList = this.commonService.selectList("report_SQL.getItemInfo", setMap);

      List returnData = new ArrayList();

      setMap.put("defaultLang", defaultLang);
      returnData = this.commonService.selectList("attr_SQL.getItemAttrMain", setMap);

      String columnNum2YN = "N";
      if (returnData.size() > 0) {
        for (int i = 0; returnData.size() > i; i++) {
          Map attrListMap = (Map)returnData.get(i);
          if ((!StringUtil.checkNull(attrListMap.get("AttrTypeCode2")).equals("")) && (StringUtil.checkNull(attrListMap.get("ColumnNum2")).equals("2"))) {
            columnNum2YN = "Y";
          }
        }
      }

      model.put("columnNum2YN", columnNum2YN);

      List attrList = new ArrayList();
      Map attrMap = new HashMap();
      Map fromAttrMap = new HashMap();
      attrMap.put("languageID", request.getParameter("languageID"));
      attrMap.put("defaultLang", defaultLang);

      attrMap.put("s_itemID", request.getParameter("s_itemID"));
      attrList = this.commonService.selectList("attr_SQL.getItemAttr", attrMap);

      returnData = GetItemAttrList.getItemAttrList2(this.commonService, returnData, setMap, request.getParameter("languageID"));
      if (!"".equals(StringUtil.checkNull(commandMap.get("sessionParamSubItems")))) {
        setMap.put("sessionParamSubItems", commandMap.get("sessionParamSubItems").toString());
      }

      Map prcMap = (Map)prcList.get(0);

      String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev"));
      String sessionUserId = StringUtil.checkNull(commandMap.get("sessionUserId"));

      if ((StringUtil.checkNull(prcMap.get("AuthorID")).equals(sessionUserId)) || 
        (StringUtil.checkNull(prcMap.get("LockOwner")).equals(sessionUserId)) || 
        ("1".equals(sessionAuthLev))) {
        model.put("myItem", "Y");
      }

      if (!"".equals(StringUtil.checkNull(commandMap.get("sessionParamSubItems")))) {
        setMap.remove("sessionParamSubItems");
      }

      setMap.put("languageID", request.getParameter("languageID"));
      List relItemList = this.commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);

      List relItemClassList = this.commonService.selectList("item_SQL.getRelItemClassList", setMap);
      model.put("relItemList", relItemList);
      model.put("relItemClassList", relItemClassList);
      setMap.put("parentID", request.getParameter("s_itemID"));

      setMap.remove("attrTypeCode");

      for (int i = 0; i < relItemList.size(); i++) {
        Map pertinentMap = (Map)relItemList.get(i);
        String itemId = pertinentMap.get("s_itemID").toString();
        setMap.put("s_itemID", itemId);
        setMap.put("s_itemID", itemId);

        if (pertinentMap.get("ClassName") != null) {
          if (className.isEmpty()) {
            className = pertinentMap.get("ClassName").toString();
            strClassName = className;
            pertinentDetailList.add(removeAllHtmlTagAndSetAttrInfo(pertinentMap));
          }
          else if (className.equals(pertinentMap.get("ClassName").toString())) {
            pertinentDetailList.add(removeAllHtmlTagAndSetAttrInfo(pertinentMap));
          } else {
            relItemRowList.add(pertinentDetailList);

            className = pertinentMap.get("ClassName").toString();
            classNameCnt++;
            strClassName = strClassName + "," + className;

            pertinentDetailList = new ArrayList();
            pertinentDetailList.add(removeAllHtmlTagAndSetAttrInfo(pertinentMap));
          }

        }

        if (i == relItemList.size() - 1) {
          relItemRowList.add(pertinentDetailList);
        }

      }

      setMap.put("s_itemID", request.getParameter("s_itemID"));

      List dimInfoList = this.commonService.selectList("dim_SQL.selectDim_gridList", setMap);
      List dimResultList = new ArrayList();
      Map dimResultMap = new HashMap();
      String dimTypeName = "";
      String dimValueNames = "";
      for (int i = 0; i < dimInfoList.size(); i++) {
        Map map = (HashMap)dimInfoList.get(i);

        if (i > 0) {
          if (dimTypeName.equals(map.get("DimTypeName").toString())) {
            dimValueNames = dimValueNames + " / " + map.get("DimValuePath").toString();
          } else {
            dimResultMap.put("dimValueNames", dimValueNames);
            dimResultList.add(dimResultMap);
            dimResultMap = new HashMap();
            dimTypeName = map.get("DimTypeName").toString();
            dimResultMap.put("dimTypeName", dimTypeName);
            dimValueNames = map.get("DimValuePath").toString();
          }
        } else {
          dimTypeName = map.get("DimTypeName").toString();
          dimResultMap.put("dimTypeName", dimTypeName);
          dimValueNames = map.get("DimValuePath").toString();
        }
      }

      if (dimInfoList.size() > 0) {
        dimResultMap.put("dimValueNames", dimValueNames);
        dimResultList.add(dimResultMap);
      }

      commandMap.put("DocumentID", request.getParameter("s_itemID"));
      commandMap.put("s_itemID", request.getParameter("s_itemID"));
      commandMap.put("languageID", request.getParameter("languageID"));
      commandMap.put("isPublic", "N");
      commandMap.put("DocCategory", "ITM");
      commandMap.put("itmIfMain", "Y");
      commandMap.remove("changeSetID");

      List itemList = this.commonService.selectList("item_SQL.getCxnItemList", commandMap);
      Map getMap = new HashMap();

      String rltdItemId = "";
      for (int i = 0; i < itemList.size(); i++) {
        setMap = (HashMap)itemList.get(i);
        getMap.put("ItemID", setMap.get("ItemID"));
        if (i < itemList.size() - 1)
          rltdItemId = rltdItemId + setMap.get("ItemID").toString() + ",";
        else {
          rltdItemId = rltdItemId + setMap.get("ItemID").toString();
        }
      }

      commandMap.put("rltdItemId", rltdItemId);
      List attachFileList = this.commonService.selectList("fileMgt_SQL.getFile_gridList", commandMap);

      Map setValue = new HashMap();
      setValue.put("s_itemID", request.getParameter("s_itemID"));
      setValue.put("languageID", request.getParameter("languageID"));
      Map menuDisplayMap = this.commonService.select("item_SQL.getMenuIconDisplay", setValue);

      String itemStatus = this.commonService.selectString("project_SQL.getItemStatus", setValue);
      String itemBlocked = this.commonService.selectString("project_SQL.getItemBlocked", setValue);

      model.put("itemStatus", itemStatus);

      if (!"0".equals(itemBlocked))
        model.put("isPossibleEdit", "N");
      else {
        model.put("isPossibleEdit", "Y");
      }

      setValue.put("s_itemID", request.getParameter("s_itemID"));
      setValue.put("languageID", request.getParameter("languageID"));
      List elementModelList = this.commonService.selectList("model_SQL.getItemMdlOccList_gridList", setValue);

      if (elementModelList.size() > 0)
        model.put("isExistModel", "Y");
      else {
        model.put("isExistModel", "N");
      }
      model.put("MDL_CNT", Integer.valueOf(elementModelList.size()));

      setValue.put("MemberID", prcMap.get("AuthorID"));
      Map authorInfoMap = this.commonService.select("item_SQL.getAuthorInfo", setValue);

      String dataType = "";
      String dataType2 = "";
      Map setData = new HashMap();
      List mLovList = new ArrayList();
      String plainText = "";
      for (int i = 0; i < returnData.size(); i++) {
        Map attrTypeMap = (HashMap)returnData.get(i);
        dataType = StringUtil.checkNull(attrTypeMap.get("DataType"));
        dataType2 = StringUtil.checkNull(attrTypeMap.get("DataType2"));
        if (dataType.equals("MLOV")) {
          plainText = getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionCurrLangType")), StringUtil.checkNull(commandMap.get("s_itemID")), StringUtil.checkNull(attrTypeMap.get("AttrTypeCode")));
          attrTypeMap.put("PlainText", plainText);
        }

        if (dataType2.equals("MLOV")) {
          plainText = getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionCurrLangType")), StringUtil.checkNull(commandMap.get("s_itemID")), StringUtil.checkNull(attrTypeMap.get("AttrTypeCode2")));
          attrTypeMap.put("PlainText2", plainText);
        }
      }

      Map setParam = new HashMap();
      setParam.put("refItemID", request.getParameter("s_itemID"));
      setParam.put("languageID", commandMap.get("sessionCurrLangType"));
      List varItemList = this.commonService.selectList("item_SQL.getRefItemInfoList", setParam);

      setParam = new HashMap();
      setParam.put("mstItemID", request.getParameter("s_itemID"));
      setParam.put("languageID", commandMap.get("sessionCurrLangType"));
      Map mstItemMap = this.commonService.select("item_SQL.getRefItemInfoList", setParam);

      model.put("varItemList", varItemList);
      model.put("mstItemMap", mstItemMap);
      model.put("showVersion", showVersion);
      model.put("menu", getLabel(request, this.commonService));
      model.put("strClassName", strClassName);
      model.put("prcList", prcList);
      model.put("attributesList", returnData);
      model.put("authorInfoMap", authorInfoMap);

      model.put("relItemRowList", relItemRowList);
      model.put("s_itemID", request.getParameter("s_itemID"));
      model.put("option", request.getParameter("option"));
      model.put("setMap", setMap);
      model.put("screenMode", StringUtil.checkNull(request.getParameter("screenMode"), ""));
      model.put("menuDisplayMap", menuDisplayMap);
      model.put("FILE_CNT", Integer.valueOf(attachFileList.size()));
      model.put("attachFileList", attachFileList);

      model.put("dimResultList", dimResultList);
      Map setDataID = new HashMap();
      setDataID.put("itemID", commandMap.get("s_itemID"));
      String parentItemID = StringUtil.checkNull(this.commonService.selectString("item_SQL.getParentItemID", setDataID));
      model.put("parentItemID", parentItemID);

      if (StringUtil.checkNull(request.getParameter("kbn")).isEmpty())
        url = "/itm/itemInfo/NewItemInfoMain";
      else {
        url = "/itm/itemInfo/NewItemInfoMainForPrint";
      }

      setDataID.put("rNum", Integer.valueOf(2));
      setDataID.put("parentItemID", parentItemID);
      setDataID.put("s_itemID", commandMap.get("s_itemID"));
      setMap.put("ItemID", request.getParameter("s_itemID"));
      String changeMgt = StringUtil.checkNull(this.commonService.selectString("project_SQL.getChangeMgt", setMap));
      setDataID.put("changeMgt", changeMgt);

      setMap = new HashMap();
      String blankPhotoUrlPath = GlobalVal.HTML_IMG_DIR + "/blank_photo.png";
      String photoUrlPath = GlobalVal.EMP_PHOTO_URL;
      String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));

      setMap.put("itemID", request.getParameter("s_itemID"));
      setMap.put("assignmentType", "CNGROLETP");
      List roleAssignMemberList = new ArrayList();
      if (GlobalVal.EMP_PHOTO_ITEM_DISPLAY.equals("Y")) {
        roleAssignMemberList = this.commonService.selectList("item_SQL.getAssignmentMemberList", setMap);
      }
      model.put("roleAssignMemberList", roleAssignMemberList);
      model.put("baseAtchUrl", GlobalVal.BASE_ATCH_URL);

      String quickCheckOut = "N";
      String itemAuthorID = StringUtil.checkNull(prcMap.get("AuthorID"));

      List projectNameList = new ArrayList();
      String sessionUserID = StringUtil.checkNull(commandMap.get("sessionUserId"));

      if (itemBlocked.equals("2"))
      {
        setMap = new HashMap();
        setMap.put("ItemID", request.getParameter("s_itemID"));
        setMap.put("itemID", request.getParameter("s_itemID"));
        setMap.put("accessRight", "U");
        setMap.put("userID", sessionUserID);
        String myItemMember = StringUtil.checkNull(this.commonService.selectString("item_SQL.getMyItemMemberID", setMap));
        if (((itemStatus.equals("REL")) || (itemStatus.equals("NEW1"))) && (changeMgt.equals("1")) && ((itemAuthorID.equals(sessionUserID)) || (myItemMember.equals(sessionUserID)))) {
          quickCheckOut = "Y";
        }
      }

      setMap = new HashMap();
      setMap.put("userId", sessionUserID);
      setMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
      setMap.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
      setMap.put("ProjectType", "CSR");
      setMap.put("isMainItem", "Y");
      projectNameList = this.commonService.selectList("project_SQL.getProjectNameList", setMap);

      setMap.put("DocCategory", "CS");
      setMap.put("languageID", commandMap.get("sessionCurrLangType"));
      String wfURL = StringUtil.checkNull(this.commonService.selectString("wf_SQL.getWFCategoryURL", setMap));
      String curChangeSet = StringUtil.checkNull(prcMap.get("CurChangeSet"));
      setMap.put("changeSetID", curChangeSet);
      String checkInOptionCS = StringUtil.checkNull(this.commonService.selectString("cs_SQL.getCheckInOptionCS", setMap));

      model.put("checkInOption", checkInOptionCS);
      model.put("projectNameList", Integer.valueOf(projectNameList.size()));
      model.put("wfURL", wfURL);
      model.put("quickCheckOut", quickCheckOut);
      model.put("itemBlocked", itemBlocked);
      model.put("changeMgt", changeMgt);
      model.put("curChangeSet", StringUtil.checkNull(prcMap.get("CurChangeSet")));
      model.put("releaseNo", StringUtil.checkNull(prcMap.get("ReleaseNo")));
      model.put("itemInfo", prcMap);

      String releaseNo = StringUtil.checkNull(prcMap.get("ReleaseNo"));
      setDataID.put("changeSetID", curChangeSet);
      String preChangeSetID = "";
      if ((!curChangeSet.equals("")) && (curChangeSet != null)) {
        preChangeSetID = StringUtil.checkNull(this.commonService.selectString("cs_SQL.getPreChangeSetID", setDataID));
      }

      if ((!releaseNo.equals("0")) && (!releaseNo.equals("1")) && (!preChangeSetID.equals(""))) {
        setDataID.put("ChangeSetID", preChangeSetID);
        model.put("preChangeSetID", preChangeSetID);
        Map preChangeSetInfo = this.commonService.select("cs_SQL.getChangeSetData", setDataID);
        model.put("preChangeSetInfo", preChangeSetInfo);
      }

      setMap.put("documentID", request.getParameter("s_itemID"));
      model.put("REV_CNT", this.commonService.selectString("revision_SQL.getRevisionCOUNT", setMap));
      model.put("subscrOption", StringUtil.checkNull(this.commonService.selectString("item_SQL.getSubscrOption", setMap)));

      setMap = new HashMap();
      setMap.put("itemID", request.getParameter("s_itemID"));

      setMap.put("memberID", sessionUserID);
      model.put("myItemCNT", StringUtil.checkNull(this.commonService.selectString("item_SQL.getMyItemCNT", setMap)));
      model.put("myItemSeq", StringUtil.checkNull(this.commonService.selectString("item_SQL.getMyItemSeq", setMap)));
    }
    catch (Exception e) {
      System.out.println(e.toString());
    }

    return nextUrl(url); }

  private String getMLovVlaue(String languageID, String itemID, String attrTypeCode) throws ExceptionUtil
  {
    List mLovList = new ArrayList();
    Map setMap = new HashMap();
    String plainText = "";
    try {
      String defaultLang = this.commonService.selectString("item_SQL.getDefaultLang", setMap);
      setMap.put("languageID", languageID);
      setMap.put("defaultLang", defaultLang);
      setMap.put("itemID", itemID);
      setMap.put("attrTypeCode", attrTypeCode);
      mLovList = this.commonService.selectList("attr_SQL.getMLovList", setMap);
      if (mLovList.size() > 0)
        for (int j = 0; j < mLovList.size(); j++) {
          Map mLovListMap = (HashMap)mLovList.get(j);
          if (j == 0)
            plainText = StringUtil.checkNull(mLovListMap.get("Value"));
          else
            plainText = plainText + " / " + mLovListMap.get("Value");
        }
    }
    catch (Exception e)
    {
      throw new ExceptionUtil(e.toString());
    }
    return plainText;
  }
  @RequestMapping({"/saveObjectInfo.do"})
  public String saveObjectInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception { HashMap target = new HashMap();
    try
    {
      String setInfo = "";
      String itemId = request.getParameter("s_itemID");
      String identifier = StringUtil.checkNull(request.getParameter("Identifier"));

      Map setValue = new HashMap();
      setValue.put("ItemID", itemId);
      setValue.put("Identifier", identifier);

      String itemCount = "0";

      if (!identifier.isEmpty()) {
        itemCount = this.commonService.selectString("attr_SQL.identifierEqualCount", setValue);
      }

      if (!itemCount.equals("0")) {
        setValue.put("languageID", request.getParameter("languageID"));

        target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00081", new String[] { this.commonService.selectString("attr_SQL.getEqualIdentifierInfo", setValue) }));
        target.put("SCRIPT", "parent.$('#isSubmit').remove();");
      }
      else
      {
        setValue.put("languageID", request.getParameter("languageID"));
        setValue.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
        setValue.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
        String AT00001YN = StringUtil.checkNull(request.getParameter("AT00001YN"));

        if ((!request.getParameter("AT00001").isEmpty()) && (!AT00001YN.equals("N"))) {
          setValue.put("AttrTypeCode", "AT00001");
          setValue.put("PlainText", request.getParameter("AT00001"));
          setInfo = GetItemAttrList.attrUpdate(this.commonService, setValue);
        }

        setValue.put("Identifier", identifier);
        setValue.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
        setValue.put("CompanyID", StringUtil.checkNull(request.getParameter("companyCode")));
        setValue.put("OwnerTeamID", StringUtil.checkNull(request.getParameter("ownerTeamCode")));
        setValue.put("Version", StringUtil.checkNull(request.getParameter("Version")));
        setValue.put("AuthorID", StringUtil.checkNull(request.getParameter("AuthorID")));
        setValue.put("LastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));

        this.commonService.update("item_SQL.updateItemObjectInfo", setValue);

        List returnData = new ArrayList();

        commandMap.put("Editable", "1");
        returnData = this.commonService.selectList("attr_SQL.getItemAttr", commandMap);

        Map setMap = new HashMap();
        String dataType = "";
        String mLovValue = "";
        String html = "";
        for (int i = 0; i < returnData.size(); i++) {
          setMap = (HashMap)returnData.get(i);
          dataType = StringUtil.checkNull(setMap.get("DataType"));
          html = StringUtil.checkNull(setMap.get("HTML"));
          if (!dataType.equals("Text")) {
            if (dataType.equals("MLOV")) {
              String[] reqMLovValue = StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode"))).split(",");
              Map delData = new HashMap();
              delData.put("ItemID", itemId);
              delData.put("AttrTypeCode", setMap.get("AttrTypeCode"));
              this.commonService.delete("attr_SQL.delItemAttr", delData);
              for (int j = 0; j < reqMLovValue.length; j++) {
                mLovValue = reqMLovValue[j].toString();
                setMap.put("PlainText", mLovValue);
                setMap.put("ItemID", StringUtil.checkNull(request.getParameter("s_itemID")));
                setMap.put("languageID", commandMap.get("sessionDefLanguageId"));
                setMap.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
                setMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
                setMap.put("LovCode", mLovValue);
                setInfo = GetItemAttrList.attrUpdate(this.commonService, setMap);
              }
            } else {
              Map delData = new HashMap();

              setMap.put("PlainText", StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode").toString()), ""));
              setMap.put("ItemID", StringUtil.checkNull(request.getParameter("s_itemID")));
              setMap.put("languageID", commandMap.get("sessionDefLanguageId"));
              setMap.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
              setMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
              setMap.put("LovCode", StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode").toString()), ""));
              setInfo = GetItemAttrList.attrUpdate(this.commonService, setMap);
            }
          } else {
            String plainText = StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode")), "");
            if (html.equals("1")) {
              plainText = StringEscapeUtils.escapeHtml4(plainText);
            }
            setMap.put("PlainText", plainText);
            setMap.put("ItemID", StringUtil.checkNull(request.getParameter("s_itemID")));
            setMap.put("languageID", request.getParameter("languageID"));
            setMap.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
            setMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
            setMap.put("LovCode", StringUtil.checkNull(this.commonService.selectString("attr_SQL.selectAttrLovCode", setMap), ""));
            setInfo = GetItemAttrList.attrUpdate(this.commonService, setMap);
          }
        }

        target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
        target.put("SCRIPT", "parent.selfClose();parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
      }
    }
    catch (Exception e)
    {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage"); } 
  @RequestMapping({"/saveItemAttr.do"})
  public String saveItemAttr(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception { HashMap target = new HashMap();
    try {
      List returnData = new ArrayList();
      Map setValue = new HashMap();
      String setInfo = "";

      String identifier = StringUtil.checkNull(request.getParameter("identifier"));

      setValue.put("ItemID", request.getParameter("s_itemID"));
      setValue.put("Identifier", identifier);

      String itemCount = "0";

      if (!identifier.isEmpty()) {
        itemCount = this.commonService.selectString("attr_SQL.identifierEqualCount", setValue);
      }

      if (!itemCount.equals("0")) {
        setValue.put("languageID", commandMap.get("sessionCurrLangType"));
        target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00081", new String[] { this.commonService.selectString("attr_SQL.getEqualIdentifierInfo", setValue) }));
        target.put("SCRIPT", "parent.$('#isSubmit').remove();");
      }
      else
      {
        returnData = this.commonService.selectList("attr_SQL.getItemAttr", commandMap);

        Map setMap = new HashMap();
        String dataType = "";
        String mLovValue = "";
        String html = "";
        for (int i = 0; i < returnData.size(); i++) {
          setMap = (HashMap)returnData.get(i);
          dataType = StringUtil.checkNull(setMap.get("DataType"));
          html = StringUtil.checkNull(setMap.get("HTML"));

          if (!dataType.equals("Text")) {
            if (dataType.equals("MLOV")) {
              String[] reqMLovValue = StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode"))).split(",");
              Map delData = new HashMap();
              delData.put("ItemID", request.getParameter("s_itemID"));
              delData.put("AttrTypeCode", setMap.get("AttrTypeCode"));
              this.commonService.delete("attr_SQL.delItemAttr", delData);
              for (int j = 0; j < reqMLovValue.length; j++) {
                mLovValue = reqMLovValue[j].toString();
                setMap.put("PlainText", mLovValue);
                setMap.put("ItemID", StringUtil.checkNull(request.getParameter("s_itemID")));
                setMap.put("languageID", commandMap.get("sessionDefLanguageId"));
                setMap.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
                setMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
                setMap.put("LovCode", mLovValue);
                setInfo = GetItemAttrList.attrUpdate(this.commonService, setMap);
              }
            } else {
              Map delData = new HashMap();

              setMap.put("PlainText", StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode").toString()), ""));
              setMap.put("ItemID", StringUtil.checkNull(request.getParameter("s_itemID")));
              setMap.put("languageID", commandMap.get("sessionDefLanguageId"));
              setMap.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
              setMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
              setMap.put("LovCode", StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode").toString()), ""));
              setInfo = GetItemAttrList.attrUpdate(this.commonService, setMap);
            }
          } else {
            String plainText = StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode")), "");
            if (html.equals("1")) {
              plainText = StringEscapeUtils.escapeHtml4(plainText);
            }
            setMap.put("PlainText", plainText);
            setMap.put("ItemID", StringUtil.checkNull(request.getParameter("s_itemID")));
            setMap.put("languageID", request.getParameter("languageID"));
            setMap.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
            setMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
            setMap.put("LovCode", StringUtil.checkNull(this.commonService.selectString("attr_SQL.selectAttrLovCode", setMap), ""));
            setInfo = GetItemAttrList.attrUpdate(this.commonService, setMap);
          }
        }

        setValue.put("s_itemID", request.getParameter("s_itemID"));
        setValue.put("Identifier", request.getParameter("identifier"));
        setValue.put("LastUser", request.getParameter("UserID"));
        this.commonService.update("project_SQL.updateItemStatus", setValue);

        setValue.put("languageID", commandMap.get("sessionCurrLangType"));
        setValue.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
        setValue.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
        if (!request.getParameter("AT00001").isEmpty()) {
          setValue.put("AttrTypeCode", "AT00001");
          setValue.put("PlainText", request.getParameter("AT00001"));
          setInfo = GetItemAttrList.attrUpdate(this.commonService, setValue);
        }

        target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
        target.put("SCRIPT", "parent.$('#isSubmit').remove();parent.actionComplet();");
      }
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "this.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage"); } 
  @RequestMapping({"/saveCheckedObjAttr.do"})
  public String saveCheckedObjAttr(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    HashMap setMap = new HashMap();
    try
    {
      List returnData = new ArrayList();

      String items = StringUtil.checkNull(request.getParameter("items"));
      String attrCode = StringUtil.checkNull(request.getParameter("attrCode").replace("&#39", "'").replace(";", ""));
      String classCodes = StringUtil.checkNull(request.getParameter("classCodes"));

      setMap.put("languageID", commandMap.get("sessionCurrLangType"));
      setMap.put("AttrTypeCodes", attrCode);
      setMap.put("ItemClassCode", classCodes);
      returnData = this.commonService.selectList("attr_SQL.getAttrAllocList", setMap);

      setMap = new HashMap();
      String[] arrayItems = items.split(",");

      for (int i = 0; i < arrayItems.length; i++) {
        String itemId = arrayItems[i];
        setMap.put("s_itemID", itemId);
        Map itemInfoMap = this.commonService.select("project_SQL.getItemInfo", setMap);
        for (int j = 0; j < returnData.size(); j++) {
          setMap = (HashMap)returnData.get(j);

          setMap.put("ItemID", itemId);
          setMap.put("languageID", commandMap.get("sessionCurrLangType"));
          setMap.put("ClassCode", itemInfoMap.get("ClassCode"));
          setMap.put("ItemTypeCode", itemInfoMap.get("ItemTypeCode"));
          String html = StringUtil.checkNull(setMap.get("HTML"), "");
          String plainText = StringUtil.checkNull(request.getParameter(setMap.get("AttrTypeCode").toString()), "");
          if (setMap.get("DataType").equals("Date")) {
            setMap.put("PlainText", StringUtil.checkNull(request.getParameter("SC_END_DT"), ""));
          } else {
            if (html.equals("1")) {
              plainText = StringEscapeUtils.unescapeHtml4(plainText);
            }
            setMap.put("PlainText", plainText);
          }

          String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"), "");
          String dataType = StringUtil.checkNull(setMap.get("DataType"), "");
          if (dataType.equals("MLOV")) {
            String mLovValue = "";
            String[] reqMLovValue = StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode"))).split(",");
            Map delData = new HashMap();
            delData.put("ItemID", itemId);
            delData.put("languageID", languageID);
            delData.put("AttrTypeCode", setMap.get("AttrTypeCode"));
            this.commonService.delete("attr_SQL.delItemAttr", delData);
            for (int k = 0; k < reqMLovValue.length; k++) {
              mLovValue = reqMLovValue[k].toString();
              setMap.put("PlainText", mLovValue);
              setMap.put("LovCode", mLovValue);
              setMap.put("dataType", dataType);
              GetItemAttrList.attrUpdate(this.commonService, setMap);
            }
          } else {
            setMap.put("LovCode", StringUtil.checkNull(this.commonService.selectString("attr_SQL.selectAttrLovCode", setMap), ""));
            GetItemAttrList.attrUpdate(this.commonService, setMap);
          }
        }

      }

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
      target.put("SCRIPT", "parent.actionComplet();");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "this.$('#isSubmit').remove()");

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  @RequestMapping({"/saveEditIdName.do"})
  public String saveEditIdName(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    try {
      Map setMap = new HashMap();
      Map updateMap = new HashMap();
      String msg = "";

      String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
      setMap.put("s_itemID", s_itemID);
      setMap.put("languageID", commandMap.get("sessionCurrLangType"));
      List getList = this.commonService.selectList("item_SQL.getRowLankItemList", setMap);

      if (msg.isEmpty()) {
        for (int i = 0; i < getList.size(); i++) {
          Map map = (Map)getList.get(i);
          String itemId = StringUtil.checkNull(map.get("ItemID"));
          updateMap = new HashMap();

          updateMap.put("ItemID", itemId);
          updateMap.put("AttrTypeCode", "AT00001");
          updateMap.put("languageID", commandMap.get("sessionCurrLangType"));
          updateMap.put("ClassCode", StringUtil.checkNull(map.get("ClassCode")));
          updateMap.put("ItemTypeCode", StringUtil.checkNull(map.get("ItemTypeCode")));
          updateMap.put("PlainText", request.getParameter("Name_" + itemId));
          updateMap.put("LovCode", "");
          GetItemAttrList.attrUpdate(this.commonService, updateMap);

          updateMap.put("s_itemID", itemId);

          updateMap.put("Identifier", request.getParameter("ID_" + itemId));
          updateMap.put("LastUser", commandMap.get("sessionUserId"));
          this.commonService.update("project_SQL.updateItemStatus", updateMap);
        }

        target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
        target.put("SCRIPT", "parent.$('#isSubmit').remove();parent.selfClose();");
      } else {
        target.put("ALERT", msg);
        target.put("SCRIPT", "parent.$('#isSubmit').remove();");
      }
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "this.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage"); } 
  @RequestMapping({"/saveOwnerInfo.do"})
  public String saveOwnerInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception { HashMap target = new HashMap();
    Map setValue = new HashMap();
    try
    {
      String items = StringUtil.checkNull(request.getParameter("items"));

      String checkAuthor = StringUtil.checkNull(request.getParameter("checkAuthor"));
      String checkOwnerTeam = StringUtil.checkNull(request.getParameter("checkOwnerTeam"));
      String checkCompany = StringUtil.checkNull(request.getParameter("checkCompany"));
      String checkIncludeLowLank = StringUtil.checkNull(request.getParameter("checkIncludeLowLank"));
      String checkTransfer = StringUtil.checkNull(request.getParameter("checkTransfer"));

      setValue.put("languageID", commandMap.get("sessionCurrLangType"));
      setValue.put("LastUser", commandMap.get("sessionUserId"));

      String[] arrayItems = items.split(",");

      List itemList = getLowLankIdList(arrayItems, checkIncludeLowLank);
      for (int i = 0; itemList.size() > i; i++) {
        String itemId = String.valueOf(itemList.get(i));

        setValue.put("ItemID", itemId);

        if ("1".equals(checkCompany)) {
          setValue.put("CompanyID", request.getParameter("companyCode"));
        }
        if ("1".equals(checkOwnerTeam)) {
          setValue.put("OwnerTeamID", request.getParameter("ownerTeamCode"));
        }

        if ("1".equals(checkTransfer)) {
          setValue.put("memberID", request.getParameter("AuthorID"));
          setValue.put("userID", request.getParameter("AuthorID"));
          String companyID = StringUtil.checkNull(this.commonService.selectString("user_SQL.getMemberCompanyID", setValue));
          Map ownerTeamID = this.commonService.select("user_SQL.memberTeamInfo", setValue);
          setValue.put("OwnerTeamID", ownerTeamID.get("TeamID"));
          setValue.put("CompanyID", companyID);
        }

        if ("1".equals(checkAuthor)) {
          setValue.put("AuthorID", request.getParameter("AuthorID"));

          String projectId = this.commonService.selectString("project_SQL.getItemProjectId", setValue);
          setValue.put("ProjectID", projectId);
          int projectCreatorCnt = Integer.parseInt(this.commonService.selectString("project_SQL.getProjectCreatorCnt", setValue));
          int projectMemberCnt = Integer.parseInt(this.commonService.selectString("project_SQL.getProjectMemberCnt", setValue));

          if ((projectCreatorCnt + projectMemberCnt == 0) && ("1".equals(this.commonService.selectString("project_SQL.getChangeMgt", setValue))))
          {
            setValue.put("MemberID", request.getParameter("AuthorID"));
            this.commonService.insert("project_SQL.createPjtMemberRel", setValue);
          }

          setValue.put("itemID", itemId);

          if (checkIncludeLowLank.equals("1"))
          {
            this.commonService.update("item_SQL.updateItemFromElement", setValue);
          }

        }

        if ("1".equals(this.commonService.selectString("project_SQL.getChangeMgt", setValue)))
        {
          setValue.remove("ItemID");
          setValue.put("cngItemId", itemId);
          setValue.put("s_itemID", itemId);
          setValue.put("Status", "MOD");
          setValue.put("userId", request.getParameter("AuthorID"));
          Map changeSetMap = (HashMap)this.commonService.select("cs_SQL.getChangeSetData", setValue);
          if ((changeSetMap != null) && (!changeSetMap.isEmpty())) {
            if (!StringUtil.checkNull(request.getParameter("AuthorID")).isEmpty()) {
              Map userInfoMap = (HashMap)this.commonService.select("project_SQL.getUserInfo", setValue);
              setValue.put("AuthorName", userInfoMap.get("Name"));
            }

            setValue.remove("s_itemID");
            setValue.put("s_itemID", changeSetMap.get("ChangeSetID"));
            this.commonService.update("cs_SQL.updateChangeSetForWf", setValue);
          }
        }
        setValue.remove("Status");
        setValue.put("ItemID", itemId);
        this.commonService.update("item_SQL.updateItemObjectInfo", setValue);
      }

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
      target.put("SCRIPT", "parent.selfClose();parent.$('#isSubmit').remove();");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage"); } 
  @RequestMapping({"/editItemInfo.do"})
  public String editItemInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception { String url = "/itm/itemInfo/editItemInfo";
    try {
      List returnData = new ArrayList();
      HashMap OccAttrInfo = new HashMap();
      HashMap getList = new HashMap();

      model.put("showVersion", StringUtil.checkNull(commandMap.get("showVersion")));

      model.put("menu", getLabel(request, this.commonService));

      String s_itemID = "";
      String setID = "";
      if (!StringUtil.checkNull(request.getParameter("subID"), "").equals("")) {
        s_itemID = StringUtil.checkNull(request.getParameter("subID"), "");
        setID = StringUtil.checkNull(request.getParameter("subID"), "");
      } else {
        s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
        setID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
      }

      OccAttrInfo = new HashMap();
      OccAttrInfo.put("ItemID", s_itemID);
      OccAttrInfo.put("languageID", request.getParameter("languageID"));
      returnData = this.commonService.selectList("attr_SQL.getItemAttrText", OccAttrInfo);
      for (int i = 0; i < returnData.size(); i++) {
        getList = (HashMap)returnData.get(i);
        OccAttrInfo.put(getList.get("AttrTypeCode"), getList.get("PlainText"));
      }
      model.put("AttrInfo", OccAttrInfo);

      model.put("s_itemID", setID);
      model.put("option", request.getParameter("option"));

      returnData = this.commonService.selectList("attr_SQL.getItemAttrType", OccAttrInfo);
      model.put("AttrColumn", returnData);

      OccAttrInfo.put("s_itemID", s_itemID);
      OccAttrInfo.put("option", request.getParameter("option"));
      getList = (HashMap)this.commonService.select("item_SQL.getObjectInfo", OccAttrInfo);
      model.put("getList", getList);

      OccAttrInfo.put("option", request.getParameter("option"));
      returnData = this.commonService.selectList("item_SQL.getClassOption", OccAttrInfo);
      model.put("classOption", returnData);

      returnData = new ArrayList();

      OccAttrInfo.put("languageID", request.getParameter("languageID"));
      returnData = this.commonService.selectList("attr_SQL.getItemAttrType", OccAttrInfo);

      model.put("AttrColumn", returnData);

      returnData = new ArrayList();
      OccAttrInfo.put("s_itemID", s_itemID);
      OccAttrInfo.put("languageID", request.getParameter("languageID"));
      OccAttrInfo.put("option", request.getParameter("option"));
      OccAttrInfo.put("Editable", "1");
      String defaultLang = this.commonService.selectString("item_SQL.getDefaultLang", commandMap);
      OccAttrInfo.put("defaultLang", defaultLang);

      returnData = this.commonService.selectList("attr_SQL.getItemAttrMain", OccAttrInfo);

      returnData = GetItemAttrList.getItemAttrList2(this.commonService, returnData, OccAttrInfo, request.getParameter("languageID"));

      List mLovList = new ArrayList();
      List mLovAttrList = new ArrayList();
      List mLovList2 = new ArrayList();
      Map setData = new HashMap();
      Map mLovMap = new HashMap();
      String dataType = "";
      String dataType2 = "";
      String mLovAttrTypeCode = "";
      String mLovAttrTypeValue = "";

      int k = 0; int l = 0;
      for (int i = 0; i < returnData.size(); i++) {
        Map listMap = (Map)returnData.get(i);
        dataType = StringUtil.checkNull(listMap.get("DataType"));
        dataType2 = StringUtil.checkNull(listMap.get("DataType2"));
        if (!dataType.equals("Text")) {
          setData.put("attrTypeCode", listMap.get("AttrTypeCode"));
          setData.put("itemID", s_itemID);
          setData.put("languageID", commandMap.get("sessionCurrLangType"));
          setData.put("defaultLang", defaultLang);
          mLovList = this.commonService.selectList("attr_SQL.getMLovListWidthItemAttr", setData);
          listMap.put("mLovList", mLovList);

          if (k == 0) {
            mLovAttrTypeCode = StringUtil.checkNull(listMap.get("AttrTypeCode"));
            mLovAttrTypeValue = StringUtil.checkNull(listMap.get("NAME"));
          } else {
            mLovAttrTypeCode = mLovAttrTypeCode + "," + StringUtil.checkNull(listMap.get("AttrTypeCode"));
            mLovAttrTypeValue = mLovAttrTypeValue + "," + StringUtil.checkNull(listMap.get("NAME"));
          }
          model.put("mLovAttrTypeCode", mLovAttrTypeCode);
          model.put("mLovAttrTypeValue", mLovAttrTypeValue);
          k++;
        }

        if (!dataType2.equals("Text")) {
          setData.put("attrTypeCode", listMap.get("AttrTypeCode2"));
          setData.put("itemID", s_itemID);
          setData.put("languageID", commandMap.get("sessionCurrLangType"));
          setData.put("defaultLang", defaultLang);
          mLovList2 = this.commonService.selectList("attr_SQL.getMLovListWidthItemAttr", setData);
          listMap.put("mLovList2", mLovList2);

          if ((l == 0) && (mLovAttrTypeCode.equals(""))) {
            mLovAttrTypeCode = StringUtil.checkNull(listMap.get("AttrTypeCode2"));
            mLovAttrTypeValue = StringUtil.checkNull(listMap.get("NAME2"));
          } else {
            mLovAttrTypeCode = mLovAttrTypeCode + "," + StringUtil.checkNull(listMap.get("AttrTypeCode2"));
            mLovAttrTypeValue = mLovAttrTypeValue + "," + StringUtil.checkNull(listMap.get("NAME2"));
          }
          model.put("mLovAttrTypeCode2", mLovAttrTypeCode);
          model.put("mLovAttrTypeValue2", mLovAttrTypeValue);
          l++;
        }
      }

      setData = new HashMap();
      setData.put("itemClassCode", getList.get("ClassCode"));
      Map itemClassInfo = this.commonService.select("item_SQL.getClassOption", setData);
      String autoID = StringUtil.checkNull(itemClassInfo.get("AutoID"));

      model.put("autoID", autoID);
      model.put("getAttrList", returnData);
      model.put("title", request.getParameter("title"));
    }
    catch (Exception e) {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }
    return nextUrl(url); }

  private List getLowLankIdList(String[] arrayItems, String checkIncludeLowLank)
    throws ExceptionUtil
  {
    List returnList = new ArrayList();
    Map setMap = new HashMap();
    List list = new ArrayList();
    Map map = new HashMap();
    try {
      for (int i = 0; arrayItems.length > i; i++) {
        String itemId = arrayItems[i];
        returnList.add(itemId);

        if ((!"1".equals(checkIncludeLowLank)) || (itemId.equals("0")))
          continue;
        int j = 1;
        while (j != 0) {
          String toItemId = "";
          setMap.put("CURRENT_ITEM", itemId);
          setMap.put("CategoryCode", "ST1");
          list = this.commonService.selectList("report_SQL.getChildItems", setMap);
          j = list.size();
          for (int k = 0; list.size() > k; k++) {
            map = (Map)list.get(k);
            String toItemID = String.valueOf(map.get("ToItemID"));
            if (!toItemID.equals("0")) {
              returnList.add(map.get("ToItemID"));
              if (k == 0)
                toItemId = "'" + String.valueOf(map.get("ToItemID")) + "'";
              else {
                toItemId = toItemId + ",'" + String.valueOf(map.get("ToItemID")) + "'";
              }
            }
          }

          itemId = toItemId;
        }
      }
    }
    catch (Exception e) {
      throw new ExceptionUtil(e.toString());
    }

    return returnList;
  }

  private List removeAllHtmlTag(List List) {
    List resultList = new ArrayList();
    for (int i = 0; i < List.size(); i++) {
      Map listMap = new HashMap();
      listMap = (Map)List.get(i);
      String description = "";
      if (listMap.get("Description") != null) {
        description = listMap.get("Description").toString().replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
      }
      listMap.put("StringDescription", description);
      resultList.add(listMap);
    }
    return resultList;
  }

  private List getModelId(List List, String languageID) throws ExceptionUtil {
    List resultList = new ArrayList();
    Map setMap = new HashMap();
    try {
      for (int i = 0; i < List.size(); i++) {
        Map listMap = new HashMap();
        listMap = (Map)List.get(i);
        String modelId = "";

        setMap.put("ItemID", listMap.get("ItemID"));
        setMap.put("languageID", languageID);
        List modelList = this.commonService.selectList("model_SQL.getModelsWithItemID", setMap);

        if (modelList.size() != 0) {
          Map modelMap = (Map)modelList.get(0);
          modelId = modelMap.get("ModelID").toString();
        }

        listMap.put("ModelID", modelId);
        resultList.add(listMap);
      }
    } catch (Exception e) {
      throw new ExceptionUtil(e.toString());
    }
    return resultList;
  }

  private Map removeAllHtmlTagAndSetAttrInfo(Map map) {
    String description = "";
    Map listMap = new HashMap();

    if (map.get("ProcessInfo") != null) {
      description = map.get("ProcessInfo").toString().replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
    }

    listMap.put("ProcessInfo", description);

    if (map.get("ClassName") != null) {
      listMap.put("ClassName", map.get("ClassName").toString());
    }

    if (map.get("s_itemID") != null) {
      listMap.put("s_itemID", map.get("s_itemID").toString());
    }

    if (map.get("Identifier") != null) {
      listMap.put("Identifier", map.get("Identifier").toString());
    }

    if (map.get("ItemName") != null) {
      listMap.put("ItemName", map.get("ItemName").toString());
    }

    if (map.get("LastUpdated") != null) {
      listMap.put("LastUpdated", map.get("LastUpdated").toString());
    }

    return listMap; } 
  @RequestMapping({"/updateRefItem.do"})
  public String updateRefItem(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception { HashMap target = new HashMap();
    Map setData = new HashMap();
    try {
      String[] ids = StringUtil.checkNull(request.getParameter("ids")).split(",");
      String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));

      setData.put("RefItemID", s_itemID);
      setData.put("LastUser", commandMap.get("sessionUserId"));
      for (int i = 0; i < ids.length; i++) {
        setData.put("ItemID", ids[i]);
        this.commonService.update("item_SQL.updateItem", setData);
      }

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
      target.put("SCRIPT", "fnReturn(" + s_itemID + ");");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage"); } 
  @RequestMapping({"/viewVersionItemInfo.do"})
  public String viewVersionItemInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    Map target = new HashMap();
    String url = "itm/itemInfo/viewVersionItemInfo";
    try {
      Map setMap = new HashMap();
      String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
      String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"));

      setMap.put("languageID", commandMap.get("sessionCurrLangType"));
      setMap.put("s_itemID", s_itemID);
      setMap.put("ChangeSetID", changeSetID);
      setMap.put("changeSetID", changeSetID);
      model.put("menu", getLabel(request, this.commonService));

      String className = "";
      List pertinentDetailList = new ArrayList();
      List relItemRowList = new ArrayList();
      String strClassName = "";
      int classNameCnt = 1;
      String Level = "";

      Map setDataID = new HashMap();
      setDataID.put("itemID", commandMap.get("s_itemID"));
      String parentItemID = StringUtil.checkNull(this.commonService.selectString("item_SQL.getParentItemID", setDataID));
      model.put("parentItemID", parentItemID);
      setMap.put("parentItemID", parentItemID);

      Map selectedCSInfo = this.commonService.select("cs_SQL.getChangeSetData", setMap);
      model.put("selectedCSInfo", selectedCSInfo);

      List prcList = this.commonService.selectList("item_SQL.getItemAttrRevInfo", setMap);

      List returnData = new ArrayList();

      returnData = this.commonService.selectList("item_SQL.getItemRevDetailInfo", setMap);

      List attrList = new ArrayList();
      Map attrMap = new HashMap();
      Map fromAttrMap = new HashMap();
      attrMap.put("languageID", commandMap.get("sessionCurrLangType"));
      attrMap.put("s_itemID", s_itemID);
      attrList = this.commonService.selectList("item_SQL.getItemRevDetailInfo", attrMap);

      returnData = GetItemAttrList.getItemAttrRevList(this.commonService, returnData, setMap, StringUtil.checkNull(commandMap.get("sessionCurrLangType")));

      setMap.put("MemberID", selectedCSInfo.get("AuthorID"));
      Map authorInfoMap = this.commonService.select("item_SQL.getAuthorInfo", setMap);

      String dataType = "";
      Map setData = new HashMap();
      List mLovList = new ArrayList();
      String plainText = "";
      for (int i = 0; i < returnData.size(); i++) {
        Map attrTypeMap = (HashMap)returnData.get(i);
        dataType = StringUtil.checkNull(attrTypeMap.get("DataType"));
        if (dataType.equals("MLOV")) {
          setData.put("languageID", commandMap.get("sessionCurrLangType"));
          setData.put("itemID", commandMap.get("s_itemID"));
          setData.put("attrTypeCode", attrTypeMap.get("AttrTypeCode"));
          setData.put("changeSetID", changeSetID);
          mLovList = this.commonService.selectList("attr_SQL.getAttrRevMLovList", setData);
          plainText = "";
          if (mLovList.size() > 0) {
            for (int j = 0; j < mLovList.size(); j++) {
              Map mLovListMap = (HashMap)mLovList.get(j);
              if (j == 0)
                plainText = StringUtil.checkNull(mLovListMap.get("Value"));
              else {
                plainText = plainText + " / " + mLovListMap.get("Value");
              }
            }
          }
          attrTypeMap.put("PlainText", plainText);
        }

      }

      setMap = new HashMap();
      setMap.put("changeSetID", changeSetID);
      setMap.put("languageID", request.getParameter("languageID"));
      setMap.put("isPublic", "N");
      setMap.put("DocCategory", "ITM");
      setMap.put("languageID", commandMap.get("sessionCurrLangType"));

      List attachFileList = this.commonService.selectList("fileMgt_SQL.getFile_gridList", setMap);
      model.put("attachFileList", attachFileList);

      model.put("strClassName", strClassName);
      model.put("prcList", prcList);
      model.put("attributesList", returnData);
      model.put("authorInfoMap", authorInfoMap);

      setMap = new HashMap();
      setMap.put("changeSetID", changeSetID);
      setMap.put("itemID", StringUtil.checkNull(commandMap.get("s_itemID")));
      String modelID = this.commonService.selectString("item_SQL.getModelIDFromChangSet", setMap);
      setMap.put("ModelID", modelID);
      setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
      Map modelInfo = this.commonService.select("model_SQL.getModel", setMap);
      model.put("modelID", modelID);
      if ((!modelInfo.isEmpty()) && (modelInfo != null)) {
        model.put("MTCategory", StringUtil.checkNull(modelInfo.get("MTCategory")));
        model.put("ModelTypeName", StringUtil.checkNull(modelInfo.get("ModelTypeName")));
      }

      setData = new HashMap();
      setData.put("s_itemID", s_itemID);
      setData.put("itemID", s_itemID);
      setData.put("languageID", commandMap.get("sessionCurrLangType"));
      setData.put("parentItemID", parentItemID);
      setData.put("changeSetID", request.getParameter("changeSetID"));
      setMap.put("ItemID", s_itemID);
      String changeMgt = StringUtil.checkNull(this.commonService.selectString("project_SQL.getChangeMgt", setMap));
      setData.put("changeMgt", changeMgt);

      Map csRNumMap = this.commonService.select("cs_SQL.getChangeSetRNUM", setData);
      String nextChangeSetID = "";
      String nextRNUM = StringUtil.checkNull(csRNumMap.get("NextRNUM"));

      if (!nextRNUM.equals("")) {
        setData.put("rNum", csRNumMap.get("NextRNUM"));
        nextChangeSetID = StringUtil.checkNull(this.commonService.selectString("cs_SQL.getNextPreChangeSetID", setData));

        Map nextChangeSetInfo = new HashMap();
        if (!nextChangeSetID.equals("")) {
          setData.put("ChangeSetID", nextChangeSetID);
          nextChangeSetInfo = this.commonService.select("cs_SQL.getChangeSetData", setData);
          model.put("nextChangeSetInfo", nextChangeSetInfo);
        }

      }

      String preChangeSetID = "";
      String PreRNUM = StringUtil.checkNull(csRNumMap.get("PreRNUM"));

      if (!PreRNUM.equals("")) {
        setData.put("rNum", csRNumMap.get("PreRNUM"));
        preChangeSetID = StringUtil.checkNull(this.commonService.selectString("cs_SQL.getNextPreChangeSetID", setData));
        Map preChangeSetInfo = new HashMap();
        if (!preChangeSetID.equals("")) {
          setData.put("ChangeSetID", preChangeSetID);
          preChangeSetInfo = this.commonService.select("cs_SQL.getChangeSetData", setData);
          model.put("preChangeSetInfo", preChangeSetInfo);
        }

      }

      String lastChangeSetID = "";
      setData.put("rNum", "1");
      lastChangeSetID = StringUtil.checkNull(this.commonService.selectString("cs_SQL.getNextPreChangeSetID", setData));

      model.put("lastChangeSetID", lastChangeSetID);
      model.put("preChangeSetID", preChangeSetID);
      model.put("nextChangeSetID", nextChangeSetID);
      model.put("projectID", request.getParameter("projectID"));
      model.put("changeSetID", changeSetID);
      model.put("authorID", request.getParameter("authorID"));
      model.put("status", request.getParameter("status"));
      model.put("s_itemID", s_itemID);
    }
    catch (Exception e)
    {
      System.out.println(e.toString());
    }

    return nextUrl(url); } 
  @RequestMapping({"/updateEditIdName.do"})
  public String updateEditIdName(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception { HashMap target = new HashMap();
    try {
      Map setMap = new HashMap();
      Map updateMap = new HashMap();
      String msg = "";

      String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
      setMap.put("s_itemID", s_itemID);
      setMap.put("languageID", commandMap.get("sessionCurrLangType"));
      List getList = this.commonService.selectList("item_SQL.getItemCompositionList_gridList", setMap);

      for (int i = 0; i < getList.size(); i++) {
        Map map = (Map)getList.get(i);
        String itemId = StringUtil.checkNull(map.get("ItemID"));
        String cxnItemID = StringUtil.checkNull(map.get("CxnItemID"));
        updateMap = new HashMap();

        updateMap.put("ItemID", itemId);
        updateMap.put("AttrTypeCode", "AT00001");
        updateMap.put("languageID", commandMap.get("sessionCurrLangType"));
        updateMap.put("ClassCode", StringUtil.checkNull(map.get("ClassCode")));
        updateMap.put("ItemTypeCode", StringUtil.checkNull(map.get("ItemTypeCode")));
        updateMap.put("PlainText", request.getParameter("Name_" + itemId));
        updateMap.put("LovCode", "");
        GetItemAttrList.attrUpdate(this.commonService, updateMap);

        updateMap.put("s_itemID", cxnItemID);

        updateMap.put("Identifier", request.getParameter("ID_" + itemId));
        updateMap.put("LastUser", commandMap.get("sessionUserId"));
        this.commonService.update("project_SQL.updateItemStatus", updateMap);
      }

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
      target.put("SCRIPT", "parent.$('#isSubmit').remove();parent.selfClose();");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "this.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage"); } 
  @RequestMapping({"/itemPageView.do"})
  public String itemPageView(HashMap cmmMap, ModelMap model) throws Exception { String url = "/itm/itemInfo/itemPageView";
    try {
      Map setMap = new HashMap();
      String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"), GlobalVal.DEFAULT_LANGUAGE);
      String s_itemID = StringUtil.checkNull(cmmMap.get("s_itemID"), "");
      String itemClassMenuUrl = StringUtil.checkNull(cmmMap.get("itemClassMenuUrl"), "");
      setMap.put("languageID", languageID);
      setMap.put("s_itemID", s_itemID);
      Map processInfo = this.commonService.select("report_SQL.getItemInfo", setMap);

      setMap.put("itemID", s_itemID);
      String parentItemID = StringUtil.checkNull(this.commonService.selectString("item_SQL.getParentItemID", setMap));
      String itemDescription = StringUtil.checkNull(this.commonService.selectString("item_SQL.getTopItemDescription", setMap)).replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\"");

      setMap.put("s_itemID", s_itemID);
      Map menuDisplayMap = this.commonService.select("item_SQL.getMenuIconDisplay", setMap);

      model.put("menuDisplayMap", menuDisplayMap);
      model.put("itemID", s_itemID);
      model.put("parentItemID", parentItemID);
      model.put("processInfo", processInfo);
      model.put("itemDescription", itemDescription);
      model.put("itemClassMenuUrl", itemClassMenuUrl);
      model.put("menu", getLabel(cmmMap, this.commonService));
    }
    catch (Exception e) {
      if (this._log.isInfoEnabled()) this._log.info("ItemAction::itemPageView::Error::" + e);
      throw new ExceptionUtil(e.toString());
    }
    return nextUrl(url); } 
  @RequestMapping({"/editChildItemAttrList.do"})
  public String editChildItemAttrList(HashMap cmmMap, ModelMap model) throws Exception { String url = "/itm/itemInfo/editChildItemAttrList";
    try {
      String s_itemID = StringUtil.checkNull(cmmMap.get("s_itemID"), "");
      String[] varFilter = StringUtil.checkNull(cmmMap.get("varFilter"), "").split(",");
      Map attrTypeMap = new HashMap();

      String attrTypeCodes = "";
      String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
      String defaultLang = StringUtil.checkNull(cmmMap.get("sessionDefLanguageId"));

      Map setData = new HashMap();
      setData.put("languageID", languageID);
      setData.put("attrTypeCodes", "'" + StringUtil.checkNull(varFilter[0], "") + "','" + StringUtil.checkNull(varFilter[1], "") + "','" + StringUtil.checkNull(varFilter[2], "") + "','" + StringUtil.checkNull(varFilter[3], "") + "'");
      List attrTypeList = this.commonService.selectList("attr_SQL.getAttrName", setData);
      int j = 1;
      setData = new HashMap();
      for (int i = 0; i < attrTypeList.size(); i++) {
        Map attrMap = (Map)attrTypeList.get(i);
        attrTypeMap.put("attrTypeName" + j, attrMap.get("AttrTypeName"));
        attrTypeMap.put("attrTypeCode" + j, attrMap.get("AttrTypeCode"));
        setData.put("attrTypeCode_" + j, attrMap.get("AttrTypeCode"));
        if (i == 0)
          attrTypeCodes = StringUtil.checkNull(attrMap.get("AttrTypeCode"));
        else {
          attrTypeCodes = attrTypeCodes + "," + StringUtil.checkNull(attrMap.get("AttrTypeCode"));
        }

        j++;
      }

      setData.put("s_itemID", s_itemID);
      setData.put("languageID", languageID);
      List editChildItemAttrList = this.commonService.selectList("item_SQL.getEditChildItemAttrList", setData);

      String dataType4 = "";
      String plainText4 = "";
      String preItemID = "";
      String mLovValue = "";
      List mLovList = new ArrayList();
      String dataTypes = "";
      for (int i = 0; i < editChildItemAttrList.size(); i++) {
        Map childItemMap = (HashMap)editChildItemAttrList.get(i);
        String itemID = StringUtil.checkNull(childItemMap.get("ItemID"));

        String dataType1 = StringUtil.checkNull(childItemMap.get("DataType1"));
        String dataType2 = StringUtil.checkNull(childItemMap.get("DataType2"));
        String dataType3 = StringUtil.checkNull(childItemMap.get("DataType3"));
        dataType4 = StringUtil.checkNull(childItemMap.get("DataType4"));

        dataTypes = dataType1 + "," + dataType2 + "," + dataType3 + "," + dataType4;

        if (dataType1.equals("MLOV")) {
          setData.put("attrTypeCode", attrTypeMap.get("attrTypeCode1"));
          setData.put("itemID", itemID);
          setData.put("languageID", languageID);
          setData.put("defaultLang", defaultLang);
          mLovList = this.commonService.selectList("attr_SQL.getMLovListWidthItemAttr", setData);

          childItemMap.put("mLovList1", mLovList);
        }

        if (dataType2.equals("MLOV")) {
          setData.put("attrTypeCode", attrTypeMap.get("attrTypeCode2"));
          setData.put("itemID", itemID);
          setData.put("languageID", languageID);
          setData.put("defaultLang", defaultLang);
          mLovList = this.commonService.selectList("attr_SQL.getMLovListWidthItemAttr", setData);

          childItemMap.put("mLovList2", mLovList);
        }

        if (dataType3.equals("MLOV")) {
          setData.put("attrTypeCode", attrTypeMap.get("attrTypeCode3"));
          setData.put("itemID", itemID);
          setData.put("languageID", languageID);
          setData.put("defaultLang", defaultLang);
          mLovList = this.commonService.selectList("attr_SQL.getMLovListWidthItemAttr", setData);

          childItemMap.put("mLovList3", mLovList);
        }

        if (dataType4.equals("MLOV")) {
          setData.put("attrTypeCode", attrTypeMap.get("attrTypeCode4"));
          setData.put("itemID", itemID);
          setData.put("languageID", languageID);
          setData.put("defaultLang", defaultLang);
          mLovList = this.commonService.selectList("attr_SQL.getMLovListWidthItemAttr", setData);

          childItemMap.put("mLovList4", mLovList);
        }

        if (itemID.equals(preItemID)) {
          editChildItemAttrList.remove(i);
          i--;
        }
        preItemID = itemID;
      }

      setData.put("itemID", s_itemID);
      setData.put("accessRight", "U");
      Map sItemInfo = this.commonService.select("item_SQL.getItemAuthority", setData);
      String authorID = StringUtil.checkNull(sItemInfo.get("AuthorID"));
      String sessionUserID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
      String myItemMember = StringUtil.checkNull(this.commonService.selectString("item_SQL.getMyItemMemberID", setData));
      String sessionAuthLev = StringUtil.checkNull(cmmMap.get("sessionAuthLev"));
      String itemBlocked = StringUtil.checkNull(sItemInfo.get("Blocked"));

      String editYN = "N";
      if (("0".equals(itemBlocked)) && ((sessionUserID.equals(myItemMember)) || (authorID.equals(sessionUserID)) || ("1".equals(sessionAuthLev)))) {
        editYN = "Y";
      }

      model.put("editYN", editYN);
      model.put("s_itemID", s_itemID);
      model.put("attrTypeMap", attrTypeMap);
      model.put("editChildItemAttrList", editChildItemAttrList);
      model.put("attrTypeCodes", attrTypeCodes);
      model.put("dataTypes", dataTypes);
      model.put("menu", getLabel(cmmMap, this.commonService));
    }
    catch (Exception e) {
      if (this._log.isInfoEnabled()) this._log.info("NewItemActionController::editChildItemAttrList::Error::" + e);
      throw new ExceptionUtil(e.toString());
    }
    return nextUrl(url); } 
  @RequestMapping({"/saveChildItemAttr.do"})
  public String saveChildItemAttr(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception { HashMap target = new HashMap();
    try
    {
      String setInfo = "";
      String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
      String[] childItemIDs = StringUtil.checkNull(request.getParameter("childItemIDs")).split(",");
      String[] attrTypeCodes = StringUtil.checkNull(request.getParameter("attrTypeCodes")).split(",");
      String[] dataTypes = StringUtil.checkNull(request.getParameter("dataTypes")).split(",");

      Map setValue = new HashMap();
      String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
      String defaultLang = StringUtil.checkNull(cmmMap.get("sessionDefLanguageId"));
      String userID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
      String itemID = "";
      String itemName = "";
      String identifier = "";

      if (childItemIDs.length > 0) {
        for (int i = 0; i < childItemIDs.length; i++)
        {
          setValue = new HashMap();
          itemID = StringUtil.checkNull(childItemIDs[i]);
          identifier = StringUtil.checkNull(StringUtil.checkNull(request.getParameter("ID_" + itemID)));

          setValue.put("ItemID", itemID);
          setValue.put("languageID", languageID);
          setValue.put("identifier", identifier);
          itemName = StringUtil.checkNull(request.getParameter("Name_" + itemID));

          if (!itemName.isEmpty()) {
            setValue.put("AttrTypeCode", "AT00001");
            setValue.put("PlainText", itemName);
            setInfo = GetItemAttrList.attrUpdate(this.commonService, setValue);
          }

          setValue.put("Identifier", identifier);
          setValue.put("LastUser", userID);
          this.commonService.update("item_SQL.updateItemObjectInfo", setValue);

          String attrTypeCode = "";
          String dataType = "";
          String mLovValue = "";
          Map setMap = new HashMap();
          for (int m = 0; m < attrTypeCodes.length; m++) {
            attrTypeCode = StringUtil.checkNull(attrTypeCodes[m]);
            dataType = StringUtil.checkNull(dataTypes[m]);

            if (!dataType.equals("Text")) {
              if (dataType.equals("MLOV")) {
                String[] reqMLovValue = StringUtil.checkNull(request.getParameter(attrTypeCode + "_" + itemID)).split(",");
                Map delData = new HashMap();
                delData.put("ItemID", itemID);
                delData.put("AttrTypeCode", attrTypeCode);
                this.commonService.delete("attr_SQL.delItemAttr", delData);
                for (int j = 0; j < reqMLovValue.length; j++) {
                  mLovValue = StringUtil.checkNull(reqMLovValue[j]);

                  setMap.put("PlainText", mLovValue);
                  setMap.put("ItemID", itemID);
                  setMap.put("AttrTypeCode", attrTypeCode);
                  setMap.put("languageID", defaultLang);
                  setMap.put("ClassCode", StringUtil.checkNull(request.getParameter("itemClassCode_" + itemID)));
                  setMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode_" + itemID)));
                  setMap.put("LovCode", mLovValue);
                  setInfo = GetItemAttrList.attrUpdate(this.commonService, setMap);
                }
              } else {
                Map delData = new HashMap();
                setMap.put("PlainText", StringUtil.checkNull(request.getParameter(attrTypeCode + "_" + itemID)));

                setMap.put("ItemID", itemID);
                setMap.put("AttrTypeCode", attrTypeCode);
                setMap.put("languageID", defaultLang);
                setMap.put("ClassCode", StringUtil.checkNull(request.getParameter("itemClassCode_" + itemID)));
                setMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode_" + itemID)));
                setMap.put("LovCode", StringUtil.checkNull(request.getParameter(attrTypeCode + "_" + itemID)));
                setInfo = GetItemAttrList.attrUpdate(this.commonService, setMap);
              }
            } else {
              setMap.put("PlainText", StringUtil.checkNull(request.getParameter(attrTypeCode + "_" + itemID)));
              setMap.put("ItemID", itemID);
              setMap.put("AttrTypeCode", attrTypeCode);
              setMap.put("languageID", languageID);
              setMap.put("ClassCode", StringUtil.checkNull(request.getParameter("itemClassCode_" + itemID)));
              setMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode_" + itemID)));
              setInfo = GetItemAttrList.attrUpdate(this.commonService, setMap);
            }
          }
        }
      }

      target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
      target.put("SCRIPT", "parent.fnCallBack();parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
      target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage"); } 
  @RequestMapping({"/viewItemProperty.do"})
  public String viewItemProperty(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception { String url = "/itm/itemInfo/viewItemProperty";
    if (!StringUtil.checkNull(request.getParameter("itemPropURL")).equals("")) url = "/" + StringUtil.checkNull(request.getParameter("itemPropURL")); try
    {
      Map setMap = new HashMap();
      String itemID = StringUtil.checkNull(commandMap.get("itemID"));

      if (StringUtil.checkNull(commandMap.get("itemID")).equals("")) {
        commandMap.put("itemID", commandMap.get("s_itemID"));
      }

      model.put("titleViewOption", "");
      if (!StringUtil.checkNull(commandMap.get("scrnType")).equals("")) {
        model.put("titleViewOption", StringUtil.checkNull(commandMap.get("scrnType")));
      }

      setMap.put("languageID", StringUtil.checkNull(commandMap.get("languageID")));
      setMap.put("langCode", StringUtil.checkNull(commandMap.get("sessionCurrLangCode")).toUpperCase());
      String defaultLang = this.commonService.selectString("item_SQL.getDefaultLang", setMap);
      setMap.put("s_itemID", StringUtil.checkNull(commandMap.get("itemID")));
      setMap.put("ItemID", StringUtil.checkNull(commandMap.get("itemID")));
      setMap.put("sessionCurrLangType", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));

      String accMode = StringUtil.checkNull(commandMap.get("accMode"), "OPS");
      String screenMode = StringUtil.checkNull(commandMap.get("screenMode"));

      model.put("screenMode", screenMode);

      Map prcList = this.commonService.select("report_SQL.getItemInfo", setMap);

      List attrList = new ArrayList();
      String changeSetID = "";
      if ((accMode.equals("OPS")) || (accMode.equals(""))) {
        changeSetID = StringUtil.checkNull(prcList.get("ReleaseNo"));
        setMap.put("changeSetID", changeSetID);
        prcList = this.commonService.select("item_SQL.getItemAttrRevInfo", setMap);
        attrList = this.commonService.selectList("item_SQL.getItemRevDetailInfo", setMap);
      } else {
        changeSetID = StringUtil.checkNull(prcList.get("CurChangeSet"));
        attrList = this.commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
      }

      Map attrMap = new HashMap();
      Map attrNameMap = new HashMap();
      Map attrHtmlMap = new HashMap();
      String mlovAttrText = "";
      for (int k = 0; attrList.size() > k; k++) {
        Map map = (Map)attrList.get(k);
        if (!map.get("DataType").equals("MLOV")) {
          attrMap.put(map.get("AttrTypeCode"), map.get("PlainText"));
        } else {
          String mlovAttrCode = (String)map.get("AttrTypeCode");
          if ((attrMap.get(mlovAttrCode) == null) || (attrMap.get(mlovAttrCode) == ""))
            mlovAttrText = map.get("PlainText").toString();
          else {
            mlovAttrText = mlovAttrText + " / " + map.get("PlainText").toString();
          }
          attrMap.put(mlovAttrCode, mlovAttrText);
        }
        attrNameMap.put(map.get("AttrTypeCode"), map.get("Name"));
        attrHtmlMap.put(map.get("AttrTypeCode"), map.get("HTML"));
      }

      List relItemList = this.commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);

      commandMap.put("s_itemID", StringUtil.checkNull(commandMap.get("itemID")));

      setMap.put("itemId", commandMap.get("itemID"));
      String itemFileOption = this.commonService.selectString("fileMgt_SQL.getFileOption", setMap);

      commandMap.put("DocumentID", StringUtil.checkNull(commandMap.get("itemID")));
      commandMap.put("languageID", StringUtil.checkNull(commandMap.get("languageID")));
      commandMap.put("isPublic", "N");
      commandMap.put("DocCategory", "ITM");
      commandMap.put("itmIfMain", "Y");
      commandMap.remove("changeSetID");

      List attachFileList = this.commonService.selectList("fileMgt_SQL.getFile_gridList", commandMap);
      for (int i = 0; i < attachFileList.size(); i++) {
        Map getFilesize = (Map)attachFileList.get(i);
        int fileSize = Integer.parseInt(String.valueOf(getFilesize.get("FileSize")));
        String FileSize = getFileSize(fileSize);
        getFilesize.put("FileSize", FileSize);
        attachFileList.remove(i);
        attachFileList.add(i, getFilesize);
      }

      List itemList = this.commonService.selectList("item_SQL.getCxnItemList", commandMap);
      Map getMap = new HashMap();

      String rltdItemId = "";
      for (int i = 0; i < itemList.size(); i++) {
        setMap = (HashMap)itemList.get(i);
        getMap.put("ItemID", setMap.get("ItemID"));
        if (i < itemList.size() - 1)
          rltdItemId = rltdItemId + setMap.get("ItemID").toString() + ",";
        else {
          rltdItemId = rltdItemId + setMap.get("ItemID").toString();
        }
      }
      commandMap.remove("DocumentID");
      commandMap.put("rltdItemId", rltdItemId);
      List pertinentFileList = this.commonService.selectList("fileMgt_SQL.getFile_gridList", commandMap);

      setMap.put("status", "CLS");
      setMap.put("itemID", StringUtil.checkNull(commandMap.get("itemID")));
      String maxChangeSetVersion = this.commonService.selectString("cs_SQL.getItemReleaseVersion", setMap);
      String maxChangeSetValidFrom = this.commonService.selectString("cs_SQL.getItemValidFrom", setMap);

      setMap.put("ItemID", StringUtil.checkNull(commandMap.get("itemID")));
      String changeMgt = StringUtil.checkNull(this.commonService.selectString("project_SQL.getChangeMgt", setMap));
      setMap.put("s_itemID", StringUtil.checkNull(commandMap.get("itemID")));
      Map menuDisplayMap = this.commonService.select("item_SQL.getMenuIconDisplay", setMap);

      Map itemInfo = this.commonService.select("report_SQL.getItemInfo", setMap);

      List itemPath = new ArrayList();

      itemPath = getRootItemPath(itemID, StringUtil.checkNull(commandMap.get("languageID")), itemPath);
      Collections.reverse(itemPath);

      String blankPhotoUrlPath = GlobalVal.HTML_IMG_DIR + "/blank_photo.png";
      String photoUrlPath = GlobalVal.EMP_PHOTO_URL;
      setMap.put("blankPhotoUrlPath", blankPhotoUrlPath);
      setMap.put("photoUrlPath", photoUrlPath);
      String empPhotoItemDisPlay = GlobalVal.EMP_PHOTO_ITEM_DISPLAY;
      model.put("empPhotoItemDisPlay", empPhotoItemDisPlay);

      List roleAssignMemberList = new ArrayList();
      if (!empPhotoItemDisPlay.equals("N")) {
        roleAssignMemberList = this.commonService.selectList("item_SQL.getAssignmentMemberList", setMap);
      }
      model.put("roleAssignMemberList", roleAssignMemberList);

      model.put("itemInfo", itemInfo);
      model.put("itemPath", itemPath);
      model.put("menuDisplayMap", menuDisplayMap);
      model.put("itemID", StringUtil.checkNull(commandMap.get("itemID")));
      model.put("prcList", prcList);
      model.put("attrMap", attrMap);
      model.put("attrNameMap", attrNameMap);
      model.put("attachFileList", attachFileList);
      model.put("pertinentFileList", pertinentFileList);
      model.put("showVersion", "1");
      model.put("maxVersion", maxChangeSetVersion);
      model.put("maxValidFrom", maxChangeSetValidFrom);
      model.put("changeMgt", changeMgt);
      model.put("revViewOption", StringUtil.checkNull(request.getParameter("mdlOption"), ""));
      model.put("scrnOption", StringUtil.checkNull(request.getParameter("scrnOption")));
      model.put("relItemList", relItemList);
      model.put("menu", getLabel(commandMap, this.commonService));
      String varfilter = StringUtil.checkNull(commandMap.get("varFilter"), "");
      if ((!varfilter.equals("")) && (!varfilter.equals(null)) && (!varfilter.equals("undefined"))) {
        String[] varFilter = StringUtil.checkNull(commandMap.get("varFilter"), "").split(",");
        url = "/" + varFilter[0];
        if (varFilter.length > 1) {
          model.put("titleViewOption", StringUtil.checkNull(varFilter[1], ""));
        }
        if (varFilter.length > 2) {
          model.put("revViewOption", StringUtil.checkNull(varFilter[2], ""));
        }
      }
      model.put("url", url);
      model.put("itemPropURL", StringUtil.checkNull(request.getParameter("itemPropURL")));
      model.put("showElement", "Y");
      model.put("accMode", accMode);
    } catch (Exception e) {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }
    return nextUrl(url);
  }

  private List getElementList(Map setMap2, Map modelMap)
    throws Exception
  {
    List returnList = new ArrayList();

    setMap2.remove("FromID");
    setMap2.remove("ToID");
    setMap2.put("ModelID", modelMap.get("ModelID"));
    setMap2.put("SymTypeCode", "SB00004");
    List elementList = this.commonService.selectList("report_SQL.getElementOfModel", setMap2);
    setMap2.remove("SymTypeCode");

    for (int i = 0; elementList.size() > i; i++) {
      Map returnMap = new HashMap();
      Map elementMap = (Map)elementList.get(i);
      String elementId = String.valueOf(elementMap.get("ElementID"));
      String objectId = String.valueOf(elementMap.get("ObjectID"));

      returnMap.put("RNUM", Integer.valueOf(i + 1));

      setMap2.remove("ToID");
      setMap2.put("FromID", elementId);
      List preList = this.commonService.selectList("report_SQL.getElementOfModel", setMap2);

      setMap2.remove("FromID");
      setMap2.put("ToID", elementId);
      List postList = this.commonService.selectList("report_SQL.getElementOfModel", setMap2);

      if ((preList.size() > 0) && (postList.size() > 0))
        returnMap.put("KBN", "Post");
      else if ((preList.size() > 0) && (postList.size() == 0))
        returnMap.put("KBN", "Pre");
      else if ((preList.size() == 0) && (postList.size() > 0))
        returnMap.put("KBN", "Post");
      else {
        returnMap.put("KBN", "");
      }

      setMap2.put("s_itemID", objectId);
      Map itemInfoMap = this.commonService.select("report_SQL.getItemInfo", setMap2);
      returnMap.put("ID", itemInfoMap.get("Identifier"));
      returnMap.put("Name", itemInfoMap.get("ItemName"));
      returnMap.put("Description", itemInfoMap.get("Description"));
      returnMap.put("itemID", objectId);

      returnList.add(returnMap);
    }

    return returnList;
  }

  public void setModelMap(Map modelMap, HttpServletRequest request)
  {
    int width = 546;
    int height = 655;
    int actualWidth = 0;
    int actualHeight = 0;
    int zoom = 100;

    if ("2".equals(request.getParameter("paperSize"))) {
      width = 700;
      height = 967;
    }

    actualWidth = Integer.parseInt(StringUtil.checkNull(modelMap.get("Width"), String.valueOf(width)));
    actualHeight = Integer.parseInt(StringUtil.checkNull(modelMap.get("Height"), String.valueOf(height)));

    if ((width < actualWidth) || (height < actualHeight)) {
      for (int i = 99; i > 1; i--) {
        actualWidth = actualWidth * i / 100;
        actualHeight = actualHeight * i / 100;
        if ((width > actualWidth) && (height > actualHeight)) {
          zoom = i;
          break;
        }
      }
    }
    modelMap.remove("Width");
    modelMap.remove("Height");
    modelMap.put("Width", Integer.valueOf(actualWidth));
    modelMap.put("Height", Integer.valueOf(actualHeight));
    System.out.println("Width==" + actualWidth);
    System.out.println("Height==" + actualHeight);
  }

  private List getActivityAttr(List List, String defaultLang, String sessionCurrLangType, Map attrNameMap, Map attrHtmlMap)
    throws Exception
  {
    List resultList = new ArrayList();
    Map setMap = new HashMap();

    List actRuleSetList = new ArrayList();
    List actRoleList = new ArrayList();
    List actSystemList = new ArrayList();

    for (int i = 0; i < List.size(); i++) {
      Map listMap = new HashMap();
      listMap = (Map)List.get(i);
      String itemId = String.valueOf(listMap.get("ItemID"));

      setMap.put("ItemID", itemId);
      setMap.put("DefaultLang", defaultLang);
      setMap.put("sessionCurrLangType", sessionCurrLangType);
      setMap.put("delItemsYN", "N");
      List attrList = this.commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);

      for (int k = 0; attrList.size() > k; k++) {
        Map map = (Map)attrList.get(k);
        listMap.put(map.get("AttrTypeCode"), StringUtil.checkNullToBlank(map.get("PlainText")).replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\""));
      }

      setMap.put("languageID", sessionCurrLangType);

      setMap.put("CURRENT_ITEM", itemId);
      setMap.put("itemTypeCode", "CN00107");
      actRuleSetList = this.commonService.selectList("report_SQL.getChildItemsForWord", setMap);

      actRuleSetList = getConItemInfo(actRuleSetList, defaultLang, sessionCurrLangType, attrNameMap, attrHtmlMap, "CN00107", "ToItemID");
      listMap.put("actRuleSetList", actRuleSetList);
      setMap.remove("CURRENT_ITEM");

      setMap.put("CURRENT_ToItemID", itemId);
      setMap.put("itemTypeCode", "CN00201");
      actRoleList = this.commonService.selectList("report_SQL.getChildItemsForWord", setMap);

      actRoleList = getConItemInfo(actRoleList, defaultLang, sessionCurrLangType, attrNameMap, attrHtmlMap, "CN00201", "FromItemID");
      listMap.put("actRoleList", actRoleList);
      setMap.remove("CURRENT_ToItemID");

      setMap.put("CURRENT_ITEM", itemId);
      setMap.put("itemTypeCode", "CN00104");
      actSystemList = this.commonService.selectList("report_SQL.getChildItemsForWord", setMap);

      actSystemList = getConItemInfo(actSystemList, defaultLang, sessionCurrLangType, attrNameMap, attrHtmlMap, "CN00104", "ToItemID");
      listMap.put("actSystemList", actSystemList);
      setMap.remove("CURRENT_ITEM");

      resultList.add(listMap);
    }

    return resultList;
  }

  private List getConItemInfo(List List, String defaultLang, String sessionCurrLangType, Map attrRsNameMap, Map attrRsHtmlMap, String cnTypeCode, String source)
    throws Exception
  {
    List resultList = new ArrayList();
    Map setMap = new HashMap();

    for (int i = 0; i < List.size(); i++) {
      Map listMap = new HashMap();
      List resultSubList = new ArrayList();

      listMap = (Map)List.get(i);
      String itemId = String.valueOf(listMap.get(source));

      setMap.put("ItemID", itemId);
      setMap.put("DefaultLang", defaultLang);
      setMap.put("sessionCurrLangType", sessionCurrLangType);
      List attrList = this.commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);

      String plainText = "";
      for (int k = 0; attrList.size() > k; k++) {
        Map map = (Map)attrList.get(k);
        attrRsNameMap.put(map.get("AttrTypeCode"), map.get("Name"));
        attrRsHtmlMap.put(map.get("AttrTypeCode"), map.get("HTML"));
        if (map.get("DataType").equals("MLOV")) {
          plainText = getMLovVlaue(sessionCurrLangType, itemId, StringUtil.checkNull(map.get("AttrTypeCode")));
          listMap.put(map.get("AttrTypeCode"), plainText);
        } else {
          listMap.put(map.get("AttrTypeCode"), map.get("PlainText"));
        }
      }

      String isFromItem = "Y";
      if (!source.equals("FromItemID")) isFromItem = "N";
      setMap.put("varFilter", cnTypeCode);
      setMap.put("languageID", sessionCurrLangType);
      setMap.put("isFromItem", isFromItem);
      setMap.put("s_itemID", itemId);
      List relatedAttrList = new ArrayList();
      List cnItemList = this.commonService.selectList("item_SQL.getCXNItems", setMap);

      for (int k = 0; cnItemList.size() > k; k++) {
        Map map = (Map)cnItemList.get(k);
        resultSubList.add(StringUtil.checkNull(map.get("RelIdentifier")) + " " + removeAllTag(StringUtil.checkNull(map.get("RelName"))));
        setMap.put("ItemID", map.get("CnItemID"));
        setMap.put("DefaultLang", defaultLang);
        setMap.put("sessionCurrLangType", sessionCurrLangType);
        relatedAttrList = this.commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
        if (relatedAttrList.size() > 0) {
          for (int m = 0; m < relatedAttrList.size(); m++) {
            Map relAttrMap = (Map)relatedAttrList.get(m);
            resultSubList.add(StringUtil.checkNull(relAttrMap.get("Name")));
            resultSubList.add(StringUtil.checkNull(relAttrMap.get("PlainText")));
            resultSubList.add(StringUtil.checkNull(relAttrMap.get("HTML")));
          }
        }
      }
      listMap.put("resultSubList", resultSubList);

      resultList.add(listMap);
    }

    return resultList;
  }

  private String removeAllTag(String str)
  {
    str = str.replaceAll("\n", "&&rn");
    str = str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#10;", " ").replace("&#xa;", "").replace("&nbsp;", " ");

    return StringEscapeUtils.unescapeHtml4(str);
  }

  private String getFileSize(double fileSize)
  {
    String str = "";

    if (fileSize >= 1073741824.0D) {
      fileSize /= 1073741824.0D;
      str = Math.floor(fileSize * 100.0D) / 100.0D + "GB";
    }
    else if (fileSize >= 1048576.0D) {
      fileSize /= 1048576.0D;
      str = Math.floor(fileSize * 100.0D) / 100.0D + "MB";
    }
    else if (fileSize >= 1024.0D) {
      fileSize /= 1024.0D;
      str = Math.round(fileSize) + "KB";
    }
    else
    {
      str = "1KB";
    }
    return str; } 
  @RequestMapping({"/myMgtItemTreePop.do"})
  public String myMgtItemTreePop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception { Map setMap = new HashMap();
    try {
      String itemTypeCodeList = StringUtil.checkNull(request.getParameter("itemTypeCodeList"), "");
      String itemStatus = StringUtil.checkNull(request.getParameter("itemStatus"), "");
      String srID = StringUtil.checkNull(request.getParameter("srID"), "");
      String speCode = StringUtil.checkNull(request.getParameter("speCode"), "");
      String actionType = StringUtil.checkNull(request.getParameter("actionType"), "");
      String projectID = StringUtil.checkNull(request.getParameter("projectID"), "");
      String updated = StringUtil.checkNull(request.getParameter("updated"), "");

      setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
      setMap.put("itemTypeCodeList", itemTypeCodeList);
      List getList = this.commonService.selectList("common_SQL.getItemClassCode_commonSelect", setMap);

      model.put("itemTypeCodeList", itemTypeCodeList);
      model.put("getList", getList);
      model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID"), ""));

      model.put("itemStatus", itemStatus);
      model.put("srID", srID);
      model.put("speCode", speCode);
      model.put("projectID", projectID);
      model.put("actionType", actionType);
      model.put("updated", updated);
      model.put("menu", getLabel(request, this.commonService));
    } catch (Exception e) {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }
    return nextUrl("/popup/myMgtItemTreePop"); }

  @RequestMapping({"/popupMasterItem.do"})
  public String popupMaster(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception
  {
    Map setMap = new HashMap();
    try {
      setMap.put("s_itemID", StringUtil.checkNull(request.getParameter("id")));
      setMap.put("languageID", StringUtil.checkNull(request.getParameter("languageID")));
      String htmlTitle = StringUtil.checkNull(this.commonService.selectString("item_SQL.getItemInfoHeader", setMap), "");

      model.put("MTCategory", StringUtil.checkNull(request.getParameter("MTCategory")));

      Map setData = new HashMap();
      setData.put("itemID", request.getParameter("id"));
      String itemClassMenuURL = StringUtil.checkNull(this.commonService.selectString("menu_SQL.getItemClassMenuURL", setData));
      String itemClassMenuVarFilter = StringUtil.checkNull(this.commonService.selectString("menu_SQL.getItemClassMenuVarFilter", setData));

      if (itemClassMenuVarFilter.contains("OPS")) {
        String releaseNo = StringUtil.checkNull(this.commonService.selectString("item_SQL.getItemReleaseNo", setMap));
        if ((!releaseNo.equals("0")) && (!releaseNo.equals("1"))) {
          setMap.put("changeSetID", releaseNo);
          String itemAttrRevName = StringUtil.checkNull(this.commonService.selectString("item_SQL.getItemRevHeader", setMap), "");
          if (!itemAttrRevName.equals("")) {
            htmlTitle = itemAttrRevName;
          }
        }
      }
      model.put("htmlTitle", htmlTitle);

      String option = StringUtil.checkNull(request.getParameter("option"));
      String itemStatus = this.commonService.selectString("project_SQL.getItemStatus", setMap);
      if (option.equals("CNGREW")) {
        if ((itemStatus.equals("MOD1")) || (itemStatus.equals("MOD2")))
          option = "AR000004"; else option = "AR000004A";
      }
      model.put("ArcCode", option);
      model.put("itemClassMenuURL", itemClassMenuURL);
      model.put("itemClassMenuVarFilter", itemClassMenuVarFilter);
      model.put("focusedItemID", StringUtil.checkNull(request.getParameter("focusedItemID")));
      model.put("changeSetID", StringUtil.checkNull(request.getParameter("changeSetID")));
      model.put("accMode", StringUtil.checkNull(request.getParameter("accMode")));
    }
    catch (Exception e) {
      System.out.println(e.toString());
    }
    return nextUrl("/popup/popupMasterItem");
  }
  @RequestMapping({"/olmPopupMasterItem.do"})
  public String olmPopupMasterItem(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception { Map setMap = new HashMap();
    try {
      String object = StringUtil.checkNull(request.getParameter("object"), "");
      String linkID = StringUtil.checkNull(request.getParameter("linkID"), "");
      String linkType = StringUtil.checkNull(request.getParameter("linkType"), "");
      String itemTypeCode = StringUtil.checkNull(request.getParameter("iType"), "");
      String identifier = StringUtil.checkNull(request.getParameter("linkID"), "");
      String attrTypeCode = StringUtil.checkNull(request.getParameter("aType"), "");
      String languageID = StringUtil.checkNull(request.getParameter("languageID"), "");
      String option = StringUtil.checkNull(request.getParameter("option"), "");
      String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"), "");
      String scrnType = StringUtil.checkNull(request.getParameter("scrnType"), "");

      String itemID = linkID;
      setMap.put("itemTypeCode", itemTypeCode);
      setMap.put("identifier", identifier);
      setMap.put("attrTypeCode", attrTypeCode);
      setMap.put("languageID", languageID);

      if (linkType.equals("code"))
        itemID = StringUtil.checkNull(this.commonService.selectString("item_SQL.getItemID", setMap), "");
      else if (linkType.equals("atr")) {
        itemID = StringUtil.checkNull(this.commonService.selectString("item_SQL.getItemIDFromAttr", setMap), "");
      }

      setMap.put("s_itemID", itemID);
      setMap.put("languageID", request.getParameter("languageID"));
      String htmlTitle = StringUtil.checkNull(this.commonService.selectString("item_SQL.getItemInfoHeader", setMap), "");

      if (!"".equals(itemID)) {
        cmmMap.put("ItemId", itemID);
        if (NumberUtil.isNumeric(itemID)) this.commonService.insert("gloval_SQL.insertVisitLog", cmmMap);
      }

      Map setData = new HashMap();
      setData.put("itemID", itemID);
      String itemClassMenuURL = StringUtil.checkNull(this.commonService.selectString("menu_SQL.getItemClassMenuURL", setData));
      String itemClassMenuVarFilter = StringUtil.checkNull(this.commonService.selectString("menu_SQL.getItemClassMenuVarFilter", setData));

      String itemStatus = this.commonService.selectString("project_SQL.getItemStatus", setMap);
      if (option.equals("CNGREW")) {
        if ((itemStatus.equals("MOD1")) || (itemStatus.equals("MOD2")))
          option = "AR000004"; else option = "AR000004A";
      }

      model.put("itemClassMenuURL", itemClassMenuURL);
      model.put("itemClassMenuVarFilter", itemClassMenuVarFilter);
      model.put("htmlTitle", htmlTitle);
      model.put("itemID", itemID);
      model.put("option", option);
      model.put("ArcCode", option);
      model.put("scrnType", scrnType);
      model.put("itemID", itemID);
      model.put("changeSetID", changeSetID);
      model.put("accMode", StringUtil.checkNull(request.getParameter("accMode")));
    } catch (Exception e) {
      System.out.println(e.toString());
    }
    return nextUrl("/popup/olmPopupMasterItem"); } 
  @RequestMapping({"/compareAttribute.do"})
  public String compareAttribute(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception {
    String url = "/itm/itemInfo/compareAttribute";

    compareText dmp = new compareText();
    dmp.Diff_Timeout = 0.0F;

    String s_itemID = StringUtil.checkNull(cmmMap.get("s_itemID"));

    String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
    String varFilter = StringUtil.checkNull(cmmMap.get("varFilter"));
    String attrTypeList = "";
    String attrTypeList2 = "";
    String defAttrCode = StringUtil.checkNull(cmmMap.get("defAttrCode"), "");
    String changeSetID = StringUtil.checkNull(cmmMap.get("changeSet"), "");
    String preChangeSetID = StringUtil.checkNull(cmmMap.get("preChangeSet"), "");

    Map setMap = new HashMap();
    setMap.put("itemID", s_itemID);
    String defaultLang = this.commonService.selectString("item_SQL.getDefaultLang", setMap);
    setMap.put("changeSetID", changeSetID);
    setMap.put("ChangeSetID", changeSetID);
    setMap.put("ItemID", s_itemID);
    String changeMgt = this.commonService.selectString("project_SQL.getChangeMgt", setMap);
    setMap.put("changeMgt", changeMgt);

    Map CSMap = this.commonService.select("cs_SQL.getChangeSetRNUM", setMap);

    if ("".equals(preChangeSetID)) {
      String preRNUM = StringUtil.checkNull(CSMap.get("PreRNUM"));
      setMap.put("rNum", preRNUM);
      preChangeSetID = StringUtil.checkNull(this.commonService.selectString("cs_SQL.getNextPreChangeSetID", setMap));
    }
    setMap.put("s_itemID", s_itemID);
    setMap.put("languageID", languageID);
    List itemAttrList = this.commonService.selectList("item_SQL.getItemClassAllocAttrType", setMap);
    List diffTextList = new ArrayList();

    if ((itemAttrList != null) && (!itemAttrList.isEmpty())) {
      for (int i = 0; i < itemAttrList.size(); i++) {
        String afterData = ""; String beforeData = "";
        Map diffMap = new HashMap();
        Map attrInfo = (Map)itemAttrList.get(i);
        String isHTML = StringUtil.checkNull(attrInfo.get("HTML"));
        String dataType = StringUtil.checkNull(attrInfo.get("DataType"));
        String attrCode = StringUtil.checkNull(attrInfo.get("AttrTypeCode"));
        String attrName = StringUtil.checkNull(attrInfo.get("Name"));

        if (dataType.equals("Text")) {
          setMap.put("defaultLang", defaultLang);
          setMap.put("s_itemID", s_itemID);
          setMap.put("languageID", languageID);
          setMap.put("attrTypeCode", attrCode);
          beforeData = StringUtil.checkNull(this.commonService.selectString("item_SQL.getItemAttrPlainText", setMap));

          setMap.put("changeSetID", preChangeSetID);
          setMap.put("ChangeSetID", preChangeSetID);
          setMap.remove("IsComLang");
          setMap.put("AttrTypeCode", attrCode);

          Map afterDataMap = new HashMap();
          afterDataMap = this.commonService.select("item_SQL.getItemRevDetailInfo", setMap);

          afterData = StringUtil.checkNull(afterDataMap.get("PlainText"));

          beforeData = beforeData.replaceAll("<br/>", "&&rn").replaceAll("<br />", "&&rn").replaceAll("\r\n", "&&rn");
          afterData = afterData.replaceAll("<br/>", "&&rn").replaceAll("<br />", "&&rn").replaceAll("\r\n", "&&rn");
        }
        else if (dataType.equals("LOV")) {
          setMap.put("defaultLang", defaultLang);
          setMap.put("s_itemID", s_itemID);
          setMap.put("languageID", languageID);
          setMap.put("attrTypeCode", attrCode);
          String lovCode = StringUtil.checkNull(this.commonService.selectString("item_SQL.getItemAttrLovCode", setMap));

          setMap.put("changeSetID", preChangeSetID);
          setMap.put("ChangeSetID", preChangeSetID);
          setMap.remove("IsComLang");
          setMap.put("AttrTypeCode", attrCode);

          Map afterDataMap = new HashMap();
          afterDataMap = this.commonService.select("item_SQL.getItemRevDetailInfo", setMap);

          afterData = StringUtil.checkNull(afterDataMap.get("PlainText"));

          if (!"".equals(lovCode)) {
            setMap.put("AttrTypeCode", attrCode);
            setMap.put("LovCode", lovCode);
            setMap.put("LanguageID", languageID);
            beforeData = StringUtil.checkNull(this.commonService.selectString("AttributeType_SQL.selectLov", setMap));
          }
          beforeData = beforeData.replaceAll("<br/>", "&&rn").replaceAll("<br />", "&&rn").replaceAll("\r\n", "&&rn");
          afterData = afterData.replaceAll("<br/>", "&&rn").replaceAll("<br />", "&&rn").replaceAll("\r\n", "&&rn");
        }
        else if (dataType.equals("Date")) {
          setMap.put("defaultLang", defaultLang);
          setMap.put("s_itemID", s_itemID);
          setMap.put("languageID", languageID);
          setMap.put("attrTypeCode", attrCode);
          beforeData = StringUtil.checkNull(this.commonService.selectString("item_SQL.getItemAttrPlainText", setMap));

          setMap.put("changeSetID", preChangeSetID);
          setMap.put("ChangeSetID", preChangeSetID);
          setMap.remove("IsComLang");
          setMap.put("AttrTypeCode", attrCode);

          Map afterDataMap = new HashMap();
          afterDataMap = this.commonService.select("item_SQL.getItemRevDetailInfo", setMap);

          afterData = StringUtil.checkNull(afterDataMap.get("PlainText"));
        }

        if ((dataType.equals("Text")) || (dataType.equals("LOV")) || (dataType.equals("Date"))) {
          LinkedList diffList = dmp.diff_main(removeAllTag(afterData), removeAllTag(beforeData), false);

          dmp.diff_cleanupSemantic(diffList);

          String diffTextBas = dmp.diff_prettyHtml(diffList, "BAS");
          String diffTextVer = dmp.diff_prettyHtml(diffList, "VER");

          diffMap.put("diffTextBas", diffTextBas.replaceAll("&&rn", "<br/>"));
          diffMap.put("diffTextVer", diffTextVer.replaceAll("&&rn", "<br/>"));
          diffMap.put("attrName", attrName);
          diffTextList.add(diffMap);
        }
      }

    }

    setMap.put("ChangeSetID", preChangeSetID);
    Map firChangeSetInfo = this.commonService.select("cs_SQL.getChangeSetData", setMap);
    model.put("firChangeSetInfo", firChangeSetInfo);

    setMap.put("ChangeSetID", changeSetID);
    Map secChangeSetInfo = this.commonService.select("cs_SQL.getChangeSetData", setMap);
    model.put("secChangeSetInfo", secChangeSetInfo);

    model.put("diffTextList", diffTextList);
    model.put("s_itemID", s_itemID);
    model.put("menu", getLabel(request, this.commonService));

    return nextUrl(url);
  }
  @RequestMapping({"/compareAttributePop.do"})
  public String compareAttributePop(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception { String url = "/itm/itemInfo/compareAttributePop";

    String s_itemID = StringUtil.checkNull(cmmMap.get("itemID"));

    Map setMap = new HashMap();
    setMap.put("itemID", s_itemID);
    String changeSetID = this.commonService.selectString("project_SQL.getCurChangeSetIDFromItem", setMap);

    model.put("changeSetID", changeSetID);
    model.put("s_itemID", s_itemID);
    model.put("menu", getLabel(request, this.commonService));

    return nextUrl(url); }

  public String removeTag(String html) throws Exception
  {
    return html.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", ""); } 
  @RequestMapping({"/processItemInfo.do"})
  public String processItemInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception { String url = "";
    try {
      Map setMap = new HashMap();
      String archiCode = StringUtil.checkNull(commandMap.get("option"), "");
      String currIdx = StringUtil.checkNull(commandMap.get("currIdx"), request.getParameter("viewScrn"));
      String itemID = StringUtil.checkNull(commandMap.get("itemID"));
      String s_itemID = StringUtil.checkNull(commandMap.get("s_itemID"));
      String scrnMode = StringUtil.checkNull(commandMap.get("scrnMode"), "V");
      String accMode = StringUtil.checkNull(commandMap.get("accMode"), "OPS");
      String showPreNextIcon = StringUtil.checkNull(commandMap.get("showPreNextIcon"), request.getParameter("viewScrn"));
      String openItemIDs = StringUtil.checkNull(commandMap.get("openItemIDs"), request.getParameter("openItemIDs"));
      String viewScrn = StringUtil.checkNull(request.getParameter("viewScrn"));
      String editScrn = StringUtil.checkNull(request.getParameter("editScrn"));
      String option = StringUtil.checkNull(request.getParameter("option"));
      String screenMode = StringUtil.checkNull(commandMap.get("screenMode"));

      model.put("screenMode", screenMode);
      setMap.put("itemID", itemID);
      url = StringUtil.checkNull(this.commonService.selectString("menu_SQL.getMenuVarFilterByClass", setMap));
      url = url.split("=")[(url.split("=").length - 1)];

      if ((scrnMode.equals("V")) || (scrnMode.equals(""))) {
        if (!viewScrn.equals("")) url = "/" + StringUtil.checkNull(viewScrn, url);
      }
      else
      {
        accMode = "DEV";
        if (!editScrn.equals("")) url = "/" + StringUtil.checkNull(editScrn, url);
      }

      if ((itemID.equals("")) && (!s_itemID.equals(""))) {
        commandMap.put("itemID", s_itemID);
        itemID = s_itemID;
      }

      if ((!itemID.equals("")) || (!s_itemID.equals("")))
      {
        List itemPath = new ArrayList();

        itemPath = getRootItemPath(itemID, StringUtil.checkNull(commandMap.get("languageID")), itemPath);
        Collections.reverse(itemPath);
        model.put("itemPath", itemPath);

        setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
        setMap.put("langCode", StringUtil.checkNull(commandMap.get("sessionCurrLangCode")).toUpperCase());
        String defaultLang = this.commonService.selectString("item_SQL.getDefaultLang", setMap);
        setMap.put("s_itemID", StringUtil.checkNull(commandMap.get("itemID")));
        setMap.put("ItemID", StringUtil.checkNull(commandMap.get("itemID")));
        setMap.put("sessionCurrLangType", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));

        model.put("titleViewOption", "");

        if (!StringUtil.checkNull(commandMap.get("scrnType")).equals("")) {
          model.put("titleViewOption", StringUtil.checkNull(commandMap.get("scrnType")));
        }

        Map itemInfo = this.commonService.select("report_SQL.getItemInfo", setMap);

        String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev"));
        String sessionUserId = StringUtil.checkNull(commandMap.get("sessionUserId"));

        if ((StringUtil.checkNull(itemInfo.get("AuthorID")).equals(sessionUserId)) || 
          (StringUtil.checkNull(itemInfo.get("LockOwner")).equals(sessionUserId)) || 
          ("1".equals(sessionAuthLev))) {
          model.put("myItem", "Y");
        }

        setMap.put("memberID", sessionUserId);
        model.put("myItemCNT", StringUtil.checkNull(this.commonService.selectString("item_SQL.getMyItemCNT", setMap)));

        String blankPhotoUrlPath = GlobalVal.HTML_IMG_DIR + "/blank_photo.png";
        String photoUrlPath = GlobalVal.EMP_PHOTO_URL;
        setMap.put("blankPhotoUrlPath", blankPhotoUrlPath);
        setMap.put("photoUrlPath", photoUrlPath);
        String empPhotoItemDisPlay = GlobalVal.EMP_PHOTO_ITEM_DISPLAY;
        model.put("empPhotoItemDisPlay", empPhotoItemDisPlay);

        List roleAssignMemberList = new ArrayList();
        if (!empPhotoItemDisPlay.equals("N")) {
          roleAssignMemberList = this.commonService.selectList("item_SQL.getAssignmentMemberList", setMap);
        }
        model.put("roleAssignMemberList", roleAssignMemberList);

        Map prcList = this.commonService.select("report_SQL.getItemInfo", setMap);

        List attrList = new ArrayList();
        String changeSetID = "";
        if ((accMode.equals("OPS")) && (!StringUtil.checkNull(prcList.get("Status")).equals("REL"))) {
          changeSetID = StringUtil.checkNull(prcList.get("ReleaseNo"));
          if ((!changeSetID.equals("0")) && (!changeSetID.equals("1"))) {
            setMap.put("changeSetID", changeSetID);
            prcList = this.commonService.select("item_SQL.getItemAttrRevInfo", setMap);
            prcList.put("Blocked", itemInfo.get("Blocked"));
            prcList.put("ChangeMgt", itemInfo.get("ChangeMgt"));
            prcList.put("SubscrOption", itemInfo.get("SubscrOption"));
            prcList.put("CheckInOption", itemInfo.get("CheckInOption"));
            prcList.put("CheckOutOption", itemInfo.get("CheckOutOption"));
            prcList.put("Status", itemInfo.get("Status"));
            attrList = this.commonService.selectList("item_SQL.getItemRevDetailInfo", setMap);
            model.put("itemInfo", prcList);
          } else {
            attrList = this.commonService.selectList("item_SQL.getItemRevDetailInfo", setMap);
          }
        } else {
          changeSetID = StringUtil.checkNull(prcList.get("CurChangeSet"));
          attrList = this.commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
          model.put("itemInfo", itemInfo);
        }

        Map attrMap = new HashMap();
        Map attrNameMap = new HashMap();
        Map attrHtmlMap = new HashMap();
        String mlovAttrText = "";
        for (int k = 0; attrList.size() > k; k++) {
          Map map = (Map)attrList.get(k);
          if (!map.get("DataType").equals("MLOV")) {
            attrMap.put(map.get("AttrTypeCode"), map.get("PlainText"));
          } else {
            String mlovAttrCode = (String)map.get("AttrTypeCode");
            if ((attrMap.get(mlovAttrCode) == null) || (attrMap.get(mlovAttrCode) == ""))
              mlovAttrText = map.get("PlainText").toString();
            else {
              mlovAttrText = mlovAttrText + " / " + map.get("PlainText").toString();
            }
            attrMap.put(mlovAttrCode, mlovAttrText);
          }
          attrNameMap.put(map.get("AttrTypeCode"), map.get("Name"));
          attrHtmlMap.put(map.get("AttrTypeCode"), map.get("HTML"));
        }

        setMap.put("assigned", "1");
        List roleList = this.commonService.selectList("role_SQL.getItemTeamRoleList_gridList", setMap);

        List dimInfoList = this.commonService.selectList("dim_SQL.selectDim_gridList", setMap);
        List dimResultList = new ArrayList();
        Map dimResultMap = new HashMap();
        Map dimInfotMap = new HashMap();
        String dimTypeName = "";
        String dimValueNames = "";
        for (int i = 0; i < dimInfoList.size(); i++) {
          Map map = (HashMap)dimInfoList.get(i);
          dimInfotMap.put(map.get("DimValueID").toString(), map.get("DimValueID").toString());
          if (i > 0) {
            if (dimTypeName.equals(map.get("DimTypeName").toString())) {
              dimValueNames = dimValueNames + " / " + map.get("DimValuePath").toString();
            } else {
              dimResultMap.put("dimValueNames", dimValueNames);
              dimResultList.add(dimResultMap);
              dimResultMap = new HashMap();
              dimTypeName = map.get("DimTypeName").toString();
              dimResultMap.put("dimTypeName", dimTypeName);
              dimValueNames = map.get("DimValuePath").toString();
            }
          } else {
            dimTypeName = map.get("DimTypeName").toString();
            dimResultMap.put("dimTypeName", dimTypeName);
            dimValueNames = map.get("DimValuePath").toString();
          }
        }
        if (dimInfoList.size() > 0) {
          dimResultMap.put("dimValueNames", dimValueNames);
          dimResultList.add(dimResultMap);
        }

        model.put("dimInfotMap", dimInfotMap);

        List activityList = new ArrayList();
        setMap.put("gubun", "M");
        activityList = this.commonService.selectList("item_SQL.getSubItemList_gridList", setMap);
        String languageId = String.valueOf(commandMap.get("sessionCurrLangType"));
        activityList = getActivityAttr(activityList, defaultLang, languageId, attrNameMap, attrHtmlMap);

        setMap.put("viewYN", "Y");
        List modelList = this.commonService.selectList("model_SQL.getModelList_gridList", setMap);

        List relItemList = this.commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);
        List relItemList2 = new ArrayList();
        for (int i = 0; i < relItemList.size(); i++) {
          Map map = (HashMap)relItemList.get(i);
          String itemtypeCode = StringUtil.checkNull(map.get("ItemTypeCode"));
          String plainText = "";

          if ("OJ00012".equals(itemtypeCode)) {
            setMap.put("s_itemID", StringUtil.checkNull(map.get("s_itemID")));
            setMap.put("attrTypeCode", "ZAT0001");
            plainText = StringUtil.checkNull(this.commonService.selectString("item_SQL.getItemAttrData", setMap));
            map.put("ZAT0001", plainText);

            setMap.put("attrTypeCode", "ZAT0002");
            plainText = StringUtil.checkNull(this.commonService.selectString("item_SQL.getItemAttrData", setMap));
            map.put("ZAT0002", plainText);
            setMap.put("attrTypeCode", "AT00014");
            plainText = StringUtil.checkNull(this.commonService.selectString("item_SQL.getItemAttrData", setMap));
            map.put("AT00014", plainText);
          }

          relItemList2.add(map);
        }

        commandMap.put("s_itemID", StringUtil.checkNull(commandMap.get("itemID")));

        List historyList = this.commonService.selectList("cs_SQL.getItemChangeList_gridList", commandMap);

        List detailElementList = new ArrayList();
        Map modelMap = new HashMap();
        modelMap = this.commonService.select("report_SQL.getModelIdAndSize", setMap);
        detailElementList = getElementList(setMap, modelMap);

        setMap.put("itemId", commandMap.get("itemID"));
        String itemFileOption = this.commonService.selectString("fileMgt_SQL.getFileOption", setMap);

        commandMap.put("DocumentID", StringUtil.checkNull(commandMap.get("itemID")));
        commandMap.put("languageID", StringUtil.checkNull(commandMap.get("languageID")));
        commandMap.put("isPublic", "N");
        commandMap.put("DocCategory", "ITM");
        commandMap.put("changeSetID", changeSetID);
        commandMap.put("fileNameSorting", "Y");

        List attachFileList = this.commonService.selectList("fileMgt_SQL.getFile_gridList", commandMap);
        for (int i = 0; i < attachFileList.size(); i++) {
          Map getFilesize = (Map)attachFileList.get(i);
          int fileSize = Integer.parseInt(String.valueOf(getFilesize.get("FileSize")));
          String FileSize = getFileSize(fileSize);
          getFilesize.put("FileSize", FileSize);
          attachFileList.remove(i);
          attachFileList.add(i, getFilesize);
        }

        List itemList = this.commonService.selectList("item_SQL.getCxnItemList", commandMap);
        Map getMap = new HashMap();

        String rltdItemId = "";
        for (int i = 0; i < itemList.size(); i++) {
          setMap = (HashMap)itemList.get(i);
          getMap.put("ItemID", setMap.get("ItemID"));
          if (i < itemList.size() - 1)
            rltdItemId = rltdItemId + setMap.get("ItemID").toString() + ",";
          else {
            rltdItemId = rltdItemId + setMap.get("ItemID").toString();
          }
        }
        commandMap.remove("DocumentID");
        commandMap.put("rltdItemId", rltdItemId);

        List pertinentFileList = this.commonService.selectList("fileMgt_SQL.getFile_gridList", commandMap);

        setMap.put("status", "CLS");

        setMap.put("ItemID", StringUtil.checkNull(commandMap.get("itemID")));
        String changeMgt = StringUtil.checkNull(this.commonService.selectString("project_SQL.getChangeMgt", setMap));
        setMap.put("s_itemID", StringUtil.checkNull(commandMap.get("itemID")));
        Map menuDisplayMap = this.commonService.select("item_SQL.getMenuIconDisplay", setMap);
        model.put("menuDisplayMap", menuDisplayMap);
        model.put("prcList", prcList);
        model.put("roleList", roleList);
        model.put("attrList", attrList);
        model.put("attrMap", attrMap);
        model.put("attrNameMap", attrNameMap);
        model.put("dimResultList", dimResultList);
        model.put("attachFileList", attachFileList);
        model.put("pertinentFileList", pertinentFileList);
        model.put("changeMgt", changeMgt);
        model.put("modelList", modelList);
        model.put("elementList", detailElementList);
        model.put("relItemList", relItemList2);
        model.put("activityList", activityList);
        model.put("historyList", historyList);
        model.put("option", option);

        setMap.put("DocCategory", "CS");

        setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
        String wfURL = StringUtil.checkNull(this.commonService.selectString("wf_SQL.getWFCategoryURL", setMap));
        model.put("wfURL", wfURL);
      }

      model.put("itemID", StringUtil.checkNull(commandMap.get("itemID")));

      model.put("showVersion", "1");
      model.put("revViewOption", StringUtil.checkNull(request.getParameter("mdlOption"), ""));
      model.put("scrnOption", StringUtil.checkNull(request.getParameter("scrnOption")));

      model.put("showPreNextIcon", showPreNextIcon);
      model.put("openItemIDs", openItemIDs);
      model.put("option", archiCode);
      model.put("currIdx", currIdx);
      model.put("menu", getLabel(commandMap, this.commonService));
      model.put("itemPropURL", StringUtil.checkNull(request.getParameter("itemPropURL")));
      model.put("viewScrn", viewScrn);
      model.put("editScrn", editScrn);
      model.put("scrnMode", scrnMode);
      model.put("accMode", accMode);
    }
    catch (Exception e) {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }
    return nextUrl(url);
  }

  private List getRootItemPath(String itemID, String languageID, List itemPath)
    throws Exception
  {
    Map setMap = new HashMap();
    setMap.put("itemID", itemID);
    String ParentItemID = StringUtil.checkNull(this.commonService.selectString("item_SQL.getParentItemID", setMap), "0");

    if ((Integer.parseInt(ParentItemID) != 0) && (Integer.parseInt(ParentItemID) > 100)) {
      setMap.put("ItemID", ParentItemID);
      setMap.put("languageID", languageID);
      setMap.put("attrTypeCode", "AT00001");
      Map temp = this.commonService.select("attr_SQL.getItemAttrText", setMap);
      temp.put("itemID", ParentItemID);
      itemPath.add(temp);
      getRootItemPath(ParentItemID, languageID, itemPath);
    }

    return itemPath;
  }
}