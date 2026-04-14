package xbolt.project.chgInf.web;

import java.io.PrintStream;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.DRMUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

@Controller
public class CSActionController extends XboltController
{

  @Resource(name="commonService")
  private CommonService commonService;

  @Resource(name="CSService")
  private CommonService CSService;

  @RequestMapping({"/ObjectHistoryGrid.do"})
  public String ObjectHistoryGrid(HttpServletRequest request, ModelMap model)
    throws Exception
  {
    try
    {
      Map setMap = new HashMap();
      setMap.put("C", " 젣 젙");
      setMap.put("D", " 룓湲 ");
      setMap.put("U", "媛쒖젙");

      model.put("changeClassList", setMap);
      model.put("menu", getLabel(request, this.commonService));
      model.put("s_itemID", request.getParameter("s_itemID"));
    } catch (Exception e) {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }
    return nextUrl("/project/changeInfo/ObjectHistoryGrid");
  }

  @RequestMapping({"/itemHistory.do"})
  public String itemHistory(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    String url = StringUtil.checkNull(request.getParameter("varFilter"), "");
    try {
      Map setMap = new HashMap();
      String s_itemID = StringUtil.checkNull(request.getParameter("subID"), request.getParameter("s_itemID"));
      String isFromTask = StringUtil.checkNull(request.getParameter("isFromTask"));

      if ("".equals(url)) {
        url = "/project/changeInfo/itemHistory";
      }

      setMap.put("userId", commandMap.get("sessionUserId"));
      setMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
      setMap.put("s_itemID", s_itemID);
      setMap.put("ProjectType", "CSR");
      setMap.put("isMainItem", "Y");
      List projectNameList = this.commonService.selectList("project_SQL.getProjectNameList", setMap);

      model.put("s_itemID", s_itemID);
      model.put("myItem", StringUtil.checkNull(request.getParameter("myItem")));
      model.put("itemStatus", StringUtil.checkNull(request.getParameter("itemStatus")));
      model.put("projectNameList", projectNameList);
      model.put("menu", getLabel(request, this.commonService));
      model.put("isFromTask", isFromTask);
      model.put("backBtnYN", StringUtil.checkNull(request.getParameter("backBtnYN")));
      String pop = StringUtil.checkNull(request.getParameter("pop"));
      if (pop.equals("pop"))
        model.put("backBtnYN", "N");
    }
    catch (Exception e)
    {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }
    return nextUrl(url);
  }

  @RequestMapping({"/changeInfoList.do"})
  public String changeInfoList(HttpServletRequest request, HashMap commandMap, ModelMap model)
    throws Exception
  {
    String url = "project/changeInfo/changeSetofCSR";
    Map setMap = new HashMap();
    List classCodeList = new ArrayList();
    List pjtList = new ArrayList();
    List csrList = new ArrayList();

    String isFromPjt = StringUtil.checkNull(request.getParameter("isFromPjt"));
    String projectID = StringUtil.checkNull(request.getParameter("projectID"), "");

    String screenType = StringUtil.checkNull(request.getParameter("screenType"));
    String isMember = StringUtil.checkNull(request.getParameter("isMember"));
    String csrStatus = StringUtil.checkNull(request.getParameter("csrStatus"));
    String classCodes = StringUtil.checkNull(request.getParameter("classCodes"));
    String scrnType = StringUtil.checkNull(request.getParameter("scrnType"));
    String modStartDT = StringUtil.checkNull(request.getParameter("modStartDT"));
    String modEndDT = StringUtil.checkNull(request.getParameter("modEndDT"));
    try
    {
      if ((scrnType.equals("ARC")) || ("0".equals(StringUtil.checkNull(request.getParameter("mainMenu"))))) {
        url = "project/changeInfo/changeSet";

        commandMap.put("Category", "CNGSTS");
        List statusList = this.commonService.selectList("common_SQL.dictionyCode_commonSelect", commandMap);
        model.put("statusList", statusList);

        commandMap.put("Category", "CNGT1");
        List changeTypeList = this.commonService.selectList("common_SQL.dictionyCode_commonSelect", commandMap);
        model.put("changeTypeList", changeTypeList);

        if (!projectID.isEmpty())
        {
          if (screenType.equals("PG"))
            setMap.put("RefPGID", projectID);
          else {
            setMap.put("RefPjtID", projectID);
          }
        }

        model.put("modStartDT", modStartDT);
        model.put("modEndDT", modEndDT);
      }

      setMap.put("ProjectType", "PJT");
      setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
      pjtList = this.commonService.selectList("project_SQL.getParentPjtList", setMap);

      setMap.put("ProjectType", "CSR");
      csrList = this.commonService.selectList("project_SQL.getParentPjtList", setMap);

      setMap.put("LanguageID", String.valueOf(commandMap.get("sessionCurrLangType")));
      setMap.put("isMine", StringUtil.checkNull(request.getParameter("isMine")));
      classCodeList = this.commonService.selectList("cs_SQL.getClassCodeList", setMap);
      model.put("classCodeList", classCodeList);

      setMap.put("s_itemID", StringUtil.checkNull(request.getParameter("ProjectID")));
      setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
      Map projectInfoMap = this.commonService.select("project_SQL.getProjectInfo", setMap);

      setMap.put("ChangeMgt", "1");
      classCodeList = this.commonService.selectList("item_SQL.getClassCodeOption", setMap);
      model.put("classCodeList", classCodeList);

      setMap.put("Creator", StringUtil.checkNull(projectInfoMap.get("Creator")));
      List memberList = this.commonService.selectList("project_SQL.getProjectMemberList", setMap);
      model.put("memberList", memberList);

      model.put("classCodes", classCodes);
      model.put("pjtCreator", StringUtil.checkNull(projectInfoMap.get("Creator")));
      model.put("pjtStatus", StringUtil.checkNull(projectInfoMap.get("Status")));
      model.put("pjtWfId", StringUtil.checkNull(projectInfoMap.get("WFID")));
      model.put("screenMode", StringUtil.checkNull(request.getParameter("screenMode")));
      model.put("isMine", StringUtil.checkNull(request.getParameter("isMine")));
      model.put("status", StringUtil.checkNull(request.getParameter("status")));
      model.put("changeType", StringUtil.checkNull(request.getParameter("changeType")));
      model.put("myTeam", StringUtil.checkNull(request.getParameter("myTeam")));
      model.put("menu", getLabel(request, this.commonService));
      setMap.put("ProjectID", StringUtil.checkNull(request.getParameter("ProjectID")));
      setMap.put("projectID", StringUtil.checkNull(request.getParameter("ProjectID")));
      setMap.put("Status", "CLS");
      model.put("clsCount", this.commonService.selectString("cs_SQL.getCNGTCount", setMap));
      model.put("itemCount", this.commonService.selectString("cs_SQL.getProjectItemCount", setMap));
      model.put("isNew", StringUtil.checkNull(request.getParameter("isNew")));
      model.put("mainMenu", StringUtil.checkNull(request.getParameter("mainMenu"), "1"));
      model.put("pjtList", pjtList);
      model.put("csrList", csrList);
      model.put("currPageA", StringUtil.checkNull(request.getParameter("currPageA"), "1"));
      model.put("isFromPjt", isFromPjt);
      model.put("myPjtId", projectID);
      model.put("closingOption", StringUtil.checkNull(request.getParameter("closingOption")));

      if (!screenType.equals("CSR")) {
        model.put("refID", projectID);
        model.put("projectID", projectID);
      }

      setMap.put("DocCategory", "CS");
      String wfURL = StringUtil.checkNull(this.commonService.selectString("wf_SQL.getWFCategoryURL", setMap));

      List dimTypeList = this.commonService.selectList("dim_SQL.getDimTypeList", commandMap);
      model.put("dimTypeList", dimTypeList);

      model.put("wfURL", wfURL);
      model.put("csrID", StringUtil.checkNull(request.getParameter("csrID")));
      model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
      model.put("screenType", screenType);
      model.put("csrStatus", csrStatus);

      model.put("seletedTreeId", StringUtil.checkNull(request.getParameter("seletedTreeId")));
      model.put("isItemInfo", StringUtil.checkNull(request.getParameter("isItemInfo")));
      model.put("isMember", isMember);
      model.put("chgsts", StringUtil.checkNull(request.getParameter("chgsts")));
    }
    catch (Exception e) {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }

    return nextUrl(url);
  }

  @RequestMapping({"/viewItemChangeInfo.do"})
  public String viewItemChangeInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    try {
      Map getMap = new HashMap();
      Map setMap = new HashMap();
      String screenMode = StringUtil.checkNull(request.getParameter("screenMode"));
      String isMyTask = StringUtil.checkNull(request.getParameter("isMyTask"));
      String itemID = StringUtil.checkNull(commandMap.get("seletedTreeId"));
      String projectID = StringUtil.checkNull(commandMap.get("ProjectID"));
      String changeSetID = StringUtil.checkNull(commandMap.get("changeSetID"));
      if (itemID.equals("")) {
        itemID = StringUtil.checkNull(commandMap.get("itemID"));
      }

      getMap.put("languageID", request.getParameter("LanguageID"));

      List changeTypeList = this.commonService.selectList("cs_SQL.getChangeTypeList", getMap);

      getMap.put("ChangeSetID", request.getParameter("changeSetID"));
      setMap = this.commonService.select("cs_SQL.getChangeSetList_gridList", getMap);

      String wfInstanaceID = StringUtil.checkNull(setMap.get("WFInstanceID"));
      model.put("getData", setMap);

      Map setData = new HashMap();
      setData.put("languageID", commandMap.get("sessionCurrLangType"));
      setData.put("itemID", itemID);

      setData.put("changeSetID", commandMap.get("changeSetID"));
      setData.put("userID", commandMap.get("sessionUserId"));
      Map evaluationClassMap = new HashMap();
      if (!itemID.equals("")) {
        evaluationClassMap = this.commonService.select("project_SQL.getEvaluationClassInfo", setData);
      }

      getMap.put("DocCategory", "CS");
      String wfURL = StringUtil.checkNull(this.commonService.selectString("wf_SQL.getWFCategoryURL", getMap));

      setData.put("s_itemID", itemID);
      List revisionList = this.commonService.selectList("cs_SQL.getRevisionListForCS", setData);
      List nOdList = this.commonService.selectList("item_SQL.getNewORDelListForCS", setData);

      setData = new HashMap();
      setData.put("changeSetID", commandMap.get("changeSetID"));
      setData.put("languageID", request.getParameter("languageID"));
      setData.put("isPublic", "N");

      List attachFileList = this.commonService.selectList("fileMgt_SQL.getFile_gridList", setData);

      model.put("revisionList", revisionList);
      model.put("nOdList", nOdList);
      model.put("attachFileList", attachFileList);

      model.put("StatusCode", StringUtil.checkNull(setMap.get("StatusCode")));
      model.put("CSRStatusCode", StringUtil.checkNull(setMap.get("CSRStatusCode")));
      model.put("isAuthorUser", StringUtil.checkNull(request.getParameter("isAuthorUser")));
      model.put("ProjectID", projectID);
      model.put("menu", getLabel(request, this.commonService));
      model.put("screenMode", screenMode);
      model.put("isMyTask", isMyTask);
      model.put("changeTypeList", changeTypeList);
      model.put("ChangeType", StringUtil.checkNull(request.getParameter("ChangeType")));
      model.put("isNew", StringUtil.checkNull(request.getParameter("isNew")));
      model.put("mainMenu", StringUtil.checkNull(request.getParameter("mainMenu"), "1"));
      model.put("currPageA", StringUtil.checkNull(request.getParameter("currPageA"), "1"));
      model.put("isFromPjt", StringUtil.checkNull(request.getParameter("isFromPjt")));
      model.put("myPjtId", StringUtil.checkNull(request.getParameter("myPjtId")));
      model.put("s_itemID", StringUtil.checkNull(commandMap.get("seletedTreeId")));

      model.put("seletedTreeId", StringUtil.checkNull(request.getParameter("seletedTreeId")));
      model.put("isItemInfo", StringUtil.checkNull(request.getParameter("isItemInfo")));
      model.put("isStsCell", StringUtil.checkNull(request.getParameter("isStsCell")));

      model.put("wfURL", wfURL);

      setData = new HashMap();
      setData.put("itemID", itemID);
      setData.put("changeSetID", changeSetID);
      setData.put("rNum", "1");
      String lastChangeSetID = this.commonService.selectString("cs_SQL.getNextPreChangeSetID", setData);

      if ((lastChangeSetID != null) && (lastChangeSetID.equals(changeSetID)))
        model.put("lastChangeSet", "Y");
      else
        model.put("lastChangeSet", "N");
    }
    catch (Exception e)
    {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }

    return nextUrl("project/changeInfo/viewItemChangeInfo");
  }

  @RequestMapping({"/editItemChangeInfo.do"})
  public String editItemChangeInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception
  {
    try {
      Map getMap = new HashMap();
      Map setMap = new HashMap();
      String screenMode = StringUtil.checkNull(request.getParameter("screenMode"));
      String isMyTask = StringUtil.checkNull(request.getParameter("isMyTask"));
      String itemID = StringUtil.checkNull(commandMap.get("seletedTreeId"));
      String projectID = StringUtil.checkNull(commandMap.get("ProjectID"));
      String changeSetID = StringUtil.checkNull(commandMap.get("changeSetID"));
      if (itemID.equals("")) {
        itemID = StringUtil.checkNull(commandMap.get("itemID"));
      }

      String path = GlobalVal.FILE_UPLOAD_ITEM_DIR + commandMap.get("sessionUserId");
      if (!path.equals("")) FileUtil.deleteDirectory(path);

      getMap.put("languageID", request.getParameter("LanguageID"));

      List changeTypeList = this.commonService.selectList("cs_SQL.getChangeTypeList", getMap);

      getMap.put("ChangeSetID", changeSetID);
      setMap = this.commonService.select("cs_SQL.getChangeSetList_gridList", getMap);
      model.put("getData", setMap);

      Map setData = new HashMap();
      setData.put("languageID", commandMap.get("sessionCurrLangType"));
      setData.put("itemID", itemID);

      setData.put("changeSetID", commandMap.get("changeSetID"));
      setData.put("userID", commandMap.get("sessionUserId"));

      setData.put("s_itemID", itemID);
      List revisionList = this.commonService.selectList("cs_SQL.getRevisionListForCS", setData);
      List nOdList = this.commonService.selectList("item_SQL.getNewORDelListForCS", setData);

      setMap.put("DocCategory", "CS");
      String LanguageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
      setMap.put("languageID", LanguageID);
      String wfURL = StringUtil.checkNull(this.commonService.selectString("wf_SQL.getWFCategoryURL", setMap));

      model.put("revisionList", revisionList);

      model.put("wfURL", wfURL);
      model.put("nOdList", nOdList);

      model.put("StatusCode", StringUtil.checkNull(setMap.get("StatusCode")));
      model.put("CSRStatusCode", StringUtil.checkNull(setMap.get("CSRStatusCode")));
      model.put("isAuthorUser", StringUtil.checkNull(request.getParameter("isAuthorUser")));
      model.put("ProjectID", projectID);
      model.put("menu", getLabel(request, this.commonService));
      model.put("screenMode", screenMode);
      model.put("isMyTask", isMyTask);
      model.put("changeTypeList", changeTypeList);
      model.put("ChangeType", StringUtil.checkNull(request.getParameter("ChangeType")));
      model.put("isNew", StringUtil.checkNull(request.getParameter("isNew")));
      model.put("mainMenu", StringUtil.checkNull(request.getParameter("mainMenu"), "1"));
      model.put("currPageA", StringUtil.checkNull(request.getParameter("currPageA"), "1"));
      model.put("isFromPjt", StringUtil.checkNull(request.getParameter("isFromPjt")));
      model.put("myPjtId", StringUtil.checkNull(request.getParameter("myPjtId")));
      model.put("s_itemID", StringUtil.checkNull(commandMap.get("seletedTreeId")));
      model.put("isItemInfo", StringUtil.checkNull(commandMap.get("isItemInfo")));

      model.put("seletedTreeId", StringUtil.checkNull(request.getParameter("seletedTreeId")));
      model.put("isItemInfo", StringUtil.checkNull(request.getParameter("isItemInfo")));
      model.put("isStsCell", StringUtil.checkNull(request.getParameter("isStsCell")));

      setData.put("changeSetID", commandMap.get("changeSetID"));
      setData.put("languageID", LanguageID);
      setData.put("isPublic", "N");
      List attachFileList = this.commonService.selectList("fileMgt_SQL.getFile_gridList", setData);

      model.put("attachFileList", attachFileList);

      setData = new HashMap();
      setData.put("itemID", itemID);
      setData.put("changeSetID", changeSetID);
      setData.put("rNum", "1");
      String lastChangeSetID = this.commonService.selectString("cs_SQL.getNextPreChangeSetID", setData);

      if ((lastChangeSetID != null) && (lastChangeSetID.equals(changeSetID)))
        model.put("lastChangeSet", "Y");
      else
        model.put("lastChangeSet", "N");
    }
    catch (Exception e)
    {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }

    return nextUrl("project/changeInfo/editItemChangeInfo");
  }
  @RequestMapping({"/saveEVSore.do"})
  public String saveEVSore(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    try {
      HashMap setData = new HashMap();
      HashMap insertEVMSTData = new HashMap();
      HashMap insertEVSCRData = new HashMap();
      HashMap updateData = new HashMap();

      String sessionUserID = StringUtil.checkNull(commandMap.get("sessionUserId"));
      String sessionTeamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
      String itemID = StringUtil.checkNull(commandMap.get("itemId"));
      String csrID = StringUtil.checkNull(commandMap.get("ProjectID"));
      String changeSetID = StringUtil.checkNull(commandMap.get("ChangeSetID"));
      String evaluationClassCode = StringUtil.checkNull(commandMap.get("evaluationClassCode"));
      String[] attrTypeCodeList = StringUtil.checkNull(commandMap.get("attrTypeCodeList")).split(",");
      String[] dataTypeList = StringUtil.checkNull(commandMap.get("dataTypeList")).split(",");
      String evType = StringUtil.checkNull(commandMap.get("evType"));
      String evSeq = "";
      String evUnitCode = "";
      String evScore = "";
      String evValue = "";
      String lovCode = "";
      String dataType = "";

      setData.put("evType", evType);
      setData.put("evClass", evaluationClassCode);
      setData.put("objectID", itemID);
      setData.put("projectID", csrID);
      setData.put("changSetID", changeSetID);
      setData.put("userID", sessionUserID);
      String evaluationID = StringUtil.checkNull(this.commonService.selectString("project_SQL.getEvaluationID", setData));
      if (evaluationID.equals("")) {
        evaluationID = this.commonService.selectString("project_SQL.getMaxEvaluationID", setData);
        insertEVMSTData.put("evaluationID", evaluationID);
        insertEVMSTData.put("evType", evType);
        insertEVMSTData.put("evClass", evaluationClassCode);
        insertEVMSTData.put("objectID", itemID);
        insertEVMSTData.put("projectID", csrID);
        insertEVMSTData.put("changeSetID", changeSetID);
        insertEVMSTData.put("evaluatorID", sessionUserID);
        insertEVMSTData.put("teamID", sessionTeamID);
        this.commonService.insert("project_SQL.insertEVMST", insertEVMSTData);
      }
      for (int i = 0; attrTypeCodeList.length > i; i++) {
        evUnitCode = StringUtil.checkNull(attrTypeCodeList[i]);
        dataType = StringUtil.checkNull(dataTypeList[i]);
        if (dataType.equals("LOV"))
          evScore = StringUtil.checkNull(commandMap.get("evScore" + evUnitCode));
        else {
          evValue = StringUtil.checkNull(commandMap.get("evValue" + evUnitCode));
        }
        evSeq = StringUtil.checkNull(commandMap.get("evSeq" + evUnitCode));
        lovCode = StringUtil.checkNull(commandMap.get("lovCode" + evUnitCode));
        if (evSeq.equals("")) {
          evSeq = this.commonService.selectString("project_SQL.getMaxEVSeqID", setData);
          insertEVSCRData.put("evaluationID", evaluationID);
          insertEVSCRData.put("evSeq", evSeq);
          insertEVSCRData.put("evUnitCode", evUnitCode);
          insertEVSCRData.put("evValue", evValue);
          insertEVSCRData.put("lovCode", lovCode);
          insertEVSCRData.put("evScore", evScore);
          this.commonService.insert("project_SQL.insertEVScore", insertEVSCRData);
          evValue = "";
        }
        else {
          updateData.put("evSeq", evSeq);
          updateData.put("evValue", evValue);
          updateData.put("evScore", evScore);
          updateData.put("lovCode", lovCode);
          updateData.put("evaluationID", evaluationID);
          this.commonService.update("project_SQL.updateEVScore", updateData);
        }
      }

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
      target.put("SCRIPT", "parent.fnCallBack();parent.$('#isSubmit').remove();");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove();");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  @RequestMapping({"/saveNewChangeSet.do"})
  public String saveNewChangeSet(HttpServletRequest request, HashMap commandMap, ModelMap model)
    throws Exception
  {
    HashMap target = new HashMap();
    HashMap fileMap = new HashMap();
    HashMap setMap = new HashMap();
    try {
      String s_itemID = StringUtil.checkNull(request.getParameter("itemId"));
      String screenMode = StringUtil.checkNull(request.getParameter("screenMode"));

      if (screenMode.equals("edit"))
      {
        updateChangeSetForCsr(request, s_itemID);
        target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
        target.put("SCRIPT", "parent.fnCallBackSave();parent.$('#isSubmit').remove();");
      }
      else {
        String projectId = StringUtil.checkNull(request.getParameter("ProjectID"));
        insertChangeSetForCsr(commandMap, s_itemID, projectId);
        target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
        target.put("SCRIPT", "this.thisReload();this.$('#isSubmit').remove();");
      }

      HashMap drmInfoMap = new HashMap();
      List fileList = new ArrayList();

      String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
      String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
      String teamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
      String teamName = StringUtil.checkNull(commandMap.get("sessionTeamName"));
      String ChangeSetID = StringUtil.checkNull(request.getParameter("ChangeSetID"));
      setMap.put("itemID", s_itemID);
      String curChangeSetID = StringUtil.checkNull(this.commonService.selectString("project_SQL.getCurChangeSetIDFromItem", setMap));
      String projectId = StringUtil.checkNull(commandMap.get("ProjectID"));

      if ("".equals(ChangeSetID)) {
        ChangeSetID = curChangeSetID;
      }
      drmInfoMap.put("userID", userID);
      drmInfoMap.put("userName", userName);
      drmInfoMap.put("teamID", teamID);
      drmInfoMap.put("teamName", teamName);
      int seqCnt = 0;
      String fltpCode = "CSDOC";
      setMap.put("fltpCode", fltpCode);
      String fltpPath = StringUtil.checkNull(this.commonService.selectString("fileMgt_SQL.getFilePath", setMap));
      seqCnt = Integer.parseInt(this.commonService.selectString("fileMgt_SQL.itemFile_nextVal", setMap));

      String orginPath = GlobalVal.FILE_UPLOAD_ITEM_DIR + StringUtil.checkNull(commandMap.get("sessionUserId")) + "//";
      String targetPath = fltpPath;
      List tmpFileList = FileUtil.copyFiles(orginPath, targetPath);
      if (tmpFileList != null) {
        for (int i = 0; i < tmpFileList.size(); i++) {
          fileMap = new HashMap();
          HashMap resultMap = (HashMap)tmpFileList.get(i);
          fileMap.put("Seq", Integer.valueOf(seqCnt));
          fileMap.put("DocumentID", ChangeSetID);
          fileMap.put("FileName", resultMap.get("SysFileNm"));
          fileMap.put("FileRealName", resultMap.get("FileNm"));
          fileMap.put("FileSize", resultMap.get("FileSize"));
          fileMap.put("FilePath", fltpPath);
          fileMap.put("FltpCode", fltpCode);
          fileMap.put("ItemID", s_itemID);
          fileMap.put("FileMgt", "ITM");
          fileMap.put("ChangeSetID", curChangeSetID);
          fileMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
          fileMap.put("userId", userID);
          fileMap.put("projectID", projectId);
          fileMap.put("DocCategory", "CS");
          fileMap.put("SQLNAME", "fileMgt_SQL.itemFile_insert");

          String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);

          if ((useDRM != null) && (useDRM != ""))
          {
            drmInfoMap.put("ORGFileDir", targetPath);
            drmInfoMap.put("DRMFileDir", targetPath);
            drmInfoMap.put("Filename", resultMap.get("SysFileNm"));
            drmInfoMap.put("funcType", "upload");
            String str1 = DRMUtil.drmMgt(drmInfoMap);
          }

          fileList.add(fileMap);
          seqCnt++;
        }
        commandMap.put("KBN", "insert");
        this.CSService.save(fileList, commandMap);

        String path = GlobalVal.FILE_UPLOAD_ITEM_DIR + commandMap.get("sessionUserId");
        if (!path.equals("")) FileUtil.deleteDirectory(path); 
      }
    }
    catch (Exception e)
    {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  @RequestMapping({"/deleteChangeSet.do"})
  public String deleteChangeSet(HttpServletRequest request, HashMap commandMap, ModelMap model)
    throws Exception
  {
    HashMap target = new HashMap();
    HashMap setMap = new HashMap();
    HashMap updateCommandMap = new HashMap();
    try
    {
      String items = StringUtil.checkNull(request.getParameter("items"), "");
      String ids = StringUtil.checkNull(request.getParameter("ids"), "");

      if (!items.isEmpty()) {
        String[] itemsArray = items.split(",");
        String[] idsArray = ids.split(",");
        for (int i = 0; itemsArray.length > i; i++)
        {
          setMap.put("ChangeSetID", itemsArray[i]);
          this.commonService.delete("cs_SQL.delChangeSetInfo", setMap);

          setMap.put("s_itemID", idsArray[i]);

          if ("MOD1".equals(this.commonService.selectString("project_SQL.getItemStatus", setMap))) {
            setMap.put("Status", "REL");
          }
          setMap.put("Blocked", "2");
          setMap.put("ProjectID", "Del");
          setMap.put("CurChangeSet", "Del");
          this.commonService.update("project_SQL.updateItemStatus", setMap);

          List lowLanklist = getRowLankItemList(idsArray[i]);
          for (int k = 0; k < lowLanklist.size(); k++) {
            updateCommandMap = new HashMap();
            updateCommandMap.put("s_itemID", lowLanklist.get(k));
            updateCommandMap.put("ProjectID", "Del");
            updateCommandMap.put("Blocked", "2");
            this.commonService.update("project_SQL.updateItemStatus", updateCommandMap);
          }
        }
      }

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069"));
      target.put("SCRIPT", "this.thisReload();this.$('#isSubmit').remove();");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "this.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070"));
    }

    model.addAttribute("resultMap", target);

    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }
  @RequestMapping({"/checkOutItem.do"})
  public String checkOutItem(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    Map setMap = new HashMap();
    try
    {
      String items = StringUtil.checkNull(request.getParameter("itemIds"));
      String projectId = StringUtil.checkNull(request.getParameter("projectId"));

      String srID = StringUtil.checkNull(request.getParameter("srID"));
      String itemName = "";
      setMap.put("rNum", Integer.valueOf(2));

      if ("".equals(srID)) {
        setMap.put("projectID", projectId);
        srID = StringUtil.checkNull(this.commonService.selectString("project_SQL.getSRIDWidhProjectID", setMap));
        commandMap.put("srID", srID);
      }

      if (!items.isEmpty()) {
        String[] itemsArray = items.split(",");

        for (int i = 0; itemsArray.length > i; i++) {
          setMap.put("itemID", StringUtil.checkNull(itemsArray[i]));
          String clsCode = StringUtil.checkNull(this.commonService.selectString("item_SQL.getClassCode", setMap));

          setMap.put("itemClassCode", clsCode);
          String checkOutOption = StringUtil.checkNull(this.commonService.selectString("item_SQL.getCheckOutOption", setMap));

          setMap.put("Status", "MOD");
          String CSCnt = StringUtil.checkNull(this.commonService.selectString("cs_SQL.getChangeSetCountForStatus", setMap));

          if ("02".equals(checkOutOption)) {
            copyBaseModel(commandMap, itemsArray[i]);
          }
          else if ("0".equals(CSCnt)) {
            insertChangeSetForCsr(commandMap, itemsArray[i], projectId);

            System.out.println("Test ==> ");
            copyBaseModel(commandMap, itemsArray[i]);

            System.out.println("Test2 ==> ");
          }
        }

      }

      System.out.println("Test3 ==> ");
      if (!srID.equals(""))
      {
        setMap.put("srID", srID);
        setMap.put("lastUser", StringUtil.checkNull(commandMap.get("sessionUserId"), ""));
        setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType"), ""));
        Map srInfoMap = this.commonService.select("esm_SQL.getESMSRInfo", setMap);
        setMap.put("docCategory", "CS");
        setMap.put("srType", srInfoMap.get("SRType"));

        Map esmProcInfo = decideSRProcPath(request, this.commonService, setMap);

        String procPathID = "";
        String speCode = "";
        if ((esmProcInfo != null) && (!esmProcInfo.isEmpty())) {
          procPathID = StringUtil.checkNull(esmProcInfo.get("ProcPathID"));
          speCode = StringUtil.checkNull(esmProcInfo.get("SpeCode"));
          if ((!speCode.equals("")) && (speCode != null)) setMap.put("status", speCode);
        }

        setMap.put("blocked", "1");
        this.commonService.update("esm_SQL.updateESMSR", setMap);

        Map setProcMapRst = setProcLog(request, this.commonService, setMap);
        if (setProcMapRst.get("type").equals("FAILE")) {
          String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
          System.out.println("Msg : " + Msg);
        }

      }

      target.put("SCRIPT", "this.thisReload();this.$('#isSubmit').remove();");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "this.dhtmlx.alert('" + MessageHandler.getMessage(new StringBuilder().append(commandMap.get("sessionCurrLangCode")).append(".WM00068").toString()) + "');this.$('#isSubmit').remove()");
    }

    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  @RequestMapping({"/openCommitCommentPop.do"})
  public String openCommitCommentPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    Map setMap = new HashMap();
    try {
      String items = StringUtil.checkNull(request.getParameter("items"));
      String cngts = StringUtil.checkNull(request.getParameter("cngts"));
      String pjtIds = StringUtil.checkNull(request.getParameter("pjtIds"));
      String srID = StringUtil.checkNull(request.getParameter("srID"));

      if ("".equals(srID)) {
        setMap.put("projectID", pjtIds);
        srID = StringUtil.checkNull(this.commonService.selectString("project_SQL.getSRIDWidhProjectID", setMap));
      }

      model.put("srID", srID);
      model.put("pjtIds", pjtIds);
      model.put("cngts", cngts);
      model.put("items", items);
      model.put("menu", getLabel(request, this.commonService));
    }
    catch (Exception e) {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }
    return nextUrl("/project/changeInfo/commitComment");
  }
  @RequestMapping({"/commitItem.do"})
  public String commitItem(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    HashMap setMap = new HashMap();

    HashMap updateItemMap = new HashMap();
    HashMap updateCngtMap = new HashMap();
    HashMap updatePjtMap = new HashMap();
    try
    {
      String items = StringUtil.checkNull(request.getParameter("items"));
      String cngts = StringUtil.checkNull(request.getParameter("cngts"));
      String pjtId = StringUtil.checkNull(request.getParameter("pjtIds"));
      String description = StringUtil.checkNull(request.getParameter("description"));
      String srID = StringUtil.checkNull(request.getParameter("srID"));
      String speCode = StringUtil.checkNull(request.getParameter("speCode"));

      String checkInOption = "";
      String csStatus = "CLS";
      int MDLCNT = 0;
      if (!items.isEmpty()) {
        String[] itemsArray = items.split(",");
        String[] cngtsArray = cngts.split(",");

        for (int i = 0; itemsArray.length > i; i++) {
          String itemId = itemsArray[i];
          setMap.put("itemID", StringUtil.checkNull(itemsArray[i]));

          String changeSetId = null;
          if (cngtsArray.length > 1)
            changeSetId = cngtsArray[i];
          else {
            changeSetId = this.commonService.selectString("item_SQL.getCurChangeSet", setMap);
          }

          if ("".equals(pjtId)) {
            pjtId = this.commonService.selectString("item_SQL.getProjectIDFromItem", setMap);
          }

          String curChangeSetID = changeSetId;

          setMap.put("changeSetID", changeSetId);
          checkInOption = this.commonService.selectString("cs_SQL.getCheckInOptionCS", setMap);

          setMap.put("Status", "MOD");
          MDLCNT = Integer.parseInt(this.commonService.selectString("model_SQL.getMDLCNT", setMap));
          if (MDLCNT > 0) {
            target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00157"));
            model.addAttribute("resultMap", target);
            return nextUrl("/cmm/ajaxResult/ajaxPage");
          }

          if ("".equals(srID)) {
            setMap.put("projectID", pjtId);
            srID = StringUtil.checkNull(this.commonService.selectString("project_SQL.getSRIDWidhProjectID", setMap));
          }

          String checkInItemStatus = "";
          setMap.put("s_itemID", itemId);
          String curItemStatus = this.commonService.selectString("project_SQL.getItemStatus", setMap);

          csStatus = "CLS";
          checkInItemStatus = "REL";

          if ("REL".equals(curItemStatus))
          {
            commandMap.put("srID", srID);
            insertChangeSetForCsr(commandMap, itemId, pjtId);
          }

          commandMap.put("projectId", pjtId);
          commandMap.put("changeSetID", changeSetId);
          copyBaseModel(commandMap, itemId);
          insertItemAttrRev(commandMap, itemId, pjtId, changeSetId);

          updateItemMap = new HashMap();
          updateItemMap.put("Status", checkInItemStatus);
          updateItemMap.put("LastUser", commandMap.get("sessionUserId"));

          curChangeSetID = StringUtil.checkNull(this.commonService.selectString("project_SQL.getCurChangeSetIDFromItem", setMap));

          updateItemMap.put("ReleaseNo", curChangeSetID);
          updateItemMap.put("s_itemID", itemId);
          this.commonService.update("project_SQL.updateItemStatus", updateItemMap);

          List lowLanklist = getRowLankItemList(itemId);
          for (int k = 0; k < lowLanklist.size(); k++) {
            setMap.put("ItemID", lowLanklist.get(k));
            String cMgt = StringUtil.checkNull(this.commonService.selectString("project_SQL.getChangeMgt", setMap));

            if (!"1".equals(cMgt)) {
              updateItemMap.put("s_itemID", lowLanklist.get(k));
              this.commonService.update("project_SQL.updateItemStatus", updateItemMap);
            }
            setMap.remove("ItemID");
          }

          updateCngtMap.put("Status", csStatus);
          updateCngtMap.put("CurTask", "CLS");
          updateCngtMap.put("s_itemID", curChangeSetID);
          updateCngtMap.put("userID", commandMap.get("sessionUserId"));
          updateCngtMap.put("Description", description);
          updateCngtMap.put("checkInOption", "02");
          this.commonService.update("cs_SQL.updateChangeSetForWf", updateCngtMap);
        }

        if (!"".equals(srID)) {
          Map updateData = new HashMap();
          updateData.put("srID", srID);
          updateData.put("status", speCode);
          updateData.put("blocked", "Y");
          updateData.put("lastUser", commandMap.get("sessionUserId"));
          this.commonService.update("esm_SQL.updateESMSR", updateData);

          Map setProcMapRst = setProcLog(request, this.commonService, updateData);
          if (setProcMapRst.get("type").equals("FAILE")) {
            System.out.println("SAVE PROC_LOG FAILE Msg : " + StringUtil.checkNull(setProcMapRst.get("msg")));
          }
        }
      }
      if (!checkInOption.equals("03A")) {
        target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
      }

      target.put("SCRIPT", "parent.fnCallBackSubmit()");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "this.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  public void insertItemAttrRev(HashMap commandMap, String s_itemID, String projectId, String changeSetID)
    throws Exception
  {
    HashMap setMap = new HashMap();
    HashMap insertData = new HashMap();
    List attrList = new ArrayList();
    String seq = "";
    if (!changeSetID.equals(""))
    {
      setMap.put("changeSetID", changeSetID);
      attrList = this.commonService.selectList("project_SQL.getItemAttrList", setMap);

      for (int h = 0; h < attrList.size(); h++) {
        Map attrListInfo = (Map)attrList.get(h);
        seq = StringUtil.checkNull(this.commonService.selectString("project_SQL.getMaxAttrRevSeq", setMap));
        insertData.put("seq", seq);
        insertData.put("changeSetID", changeSetID);
        insertData.put("itemID", attrListInfo.get("ItemID"));
        insertData.put("attrTypeCode", attrListInfo.get("AttrTypeCode"));
        insertData.put("languageID", attrListInfo.get("LanguageID"));
        insertData.put("modelID", attrListInfo.get("ModelID"));
        insertData.put("plainText", attrListInfo.get("PlainText"));
        insertData.put("lovCode", attrListInfo.get("LovCode"));
        insertData.put("htmlText", attrListInfo.get("HtmlText"));
        insertData.put("itemTypeCode", attrListInfo.get("ItemTypeCode"));
        insertData.put("classCode", attrListInfo.get("ClassCode"));
        insertData.put("deleted", attrListInfo.get("Deleted"));
        insertData.put("font", attrListInfo.get("Font"));
        insertData.put("fontFamily", attrListInfo.get("FontFamily"));
        insertData.put("fontStyle", attrListInfo.get("FontStyle"));
        insertData.put("fontSize", attrListInfo.get("FontSize"));
        insertData.put("fontColor", attrListInfo.get("FontColor"));

        this.commonService.insert("project_SQL.insertItemAttrRev", insertData);
      }
    }
  }

  public void insertItemAttrRev(HashMap commandMap, String s_itemID, String projectId, String changeSetID, String releaseNo) throws Exception {
    HashMap setMap = new HashMap();
    HashMap insertData = new HashMap();
    List attrList = new ArrayList();
    String seq = "";
    if (!changeSetID.equals(""))
    {
      setMap.put("changeSetID", changeSetID);
      attrList = this.commonService.selectList("project_SQL.getItemAttrList", setMap);

      for (int h = 0; h < attrList.size(); h++) {
        Map attrListInfo = (Map)attrList.get(h);
        seq = StringUtil.checkNull(this.commonService.selectString("project_SQL.getMaxAttrRevSeq", setMap));
        insertData.put("seq", seq);
        insertData.put("changeSetID", releaseNo);
        insertData.put("itemID", attrListInfo.get("ItemID"));
        insertData.put("attrTypeCode", attrListInfo.get("AttrTypeCode"));
        insertData.put("languageID", attrListInfo.get("LanguageID"));
        insertData.put("modelID", attrListInfo.get("ModelID"));
        insertData.put("plainText", attrListInfo.get("PlainText"));
        insertData.put("lovCode", attrListInfo.get("LovCode"));
        insertData.put("htmlText", attrListInfo.get("HtmlText"));
        insertData.put("itemTypeCode", attrListInfo.get("ItemTypeCode"));
        insertData.put("classCode", attrListInfo.get("ClassCode"));
        insertData.put("deleted", attrListInfo.get("Deleted"));
        insertData.put("font", attrListInfo.get("Font"));
        insertData.put("fontFamily", attrListInfo.get("FontFamily"));
        insertData.put("fontStyle", attrListInfo.get("FontStyle"));
        insertData.put("fontSize", attrListInfo.get("FontSize"));
        insertData.put("fontColor", attrListInfo.get("FontColor"));

        this.commonService.insert("project_SQL.insertItemAttrRev", insertData);
      }
    }
  }

  @RequestMapping({"/addCNItemToChangeSetList.do"})
  public String addCNItemToChangeSetList(HttpServletRequest request, HashMap commandMap, ModelMap model)
    throws Exception
  {
    HashMap target = new HashMap();
    Map setMap = new HashMap();
    String msg = "";
    try
    {
      String items = StringUtil.checkNull(request.getParameter("items"));
      String itmNms = 
        StringUtil.checkNull(request.getParameter("itmNms"));
      String rooItem = 
        StringUtil.checkNull(request.getParameter("s_itemID"));
      String projectId = StringUtil.checkNull(request
        .getParameter("ProjectID"));
      String cngtID = 
        StringUtil.checkNull(request.getParameter("cngtID"));
      String languageID = StringUtil.checkNull(request
        .getParameter("languageID"));

      if (!items.isEmpty()) {
        String[] itemsArray = items.split(",");
        String[] itmNmsArray = itmNms.split(":::");

        for (int i = 0; itemsArray.length > i; i++)
        {
          String itemId = itemsArray[i];
          String itemNm = itmNmsArray[i];

          setMap.put("s_itemID", itemId);
          String status = StringUtil.checkNull(this.commonService
            .selectString("project_SQL.getItemStatus", setMap));

          if (("NEW2".equals(status)) || ("MOD2".equals(status)) || 
            ("DEL2".equals(status))) {
            if (msg.isEmpty())
              msg = itemNm;
            else
              msg = msg + "," + itemNm;
          }
          else {
            insertChangeSetForCnItm(itemId, rooItem, projectId, 
              cngtID, languageID);
          }
        }

      }

      model.put("ProjectID", projectId);

      target.put(
        "ALERT", 
        MessageHandler.getMessage(commandMap
        .get("sessionCurrLangCode") + ".WM00067"));

      if (!msg.isEmpty())
      {
        target.put(
          "ALERT", 
          MessageHandler.getMessage(
          commandMap.get("sessionCurrLangCode") + 
          ".WM00082", new String[] { msg }));
      }

      target.put("SCRIPT", 
        "parent.selfClose();parent.$('#isSubmit').remove();");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put(
        "ALERT", 
        MessageHandler.getMessage(commandMap
        .get("sessionCurrLangCode") + ".WM00068"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  private List getRowLankItemList(String s_itemID)
    throws Exception
  {
    List lowLankItemIdList = new ArrayList();
    List list = new ArrayList();
    Map map = new HashMap();
    Map setMap = new HashMap();

    String itemId = s_itemID;
    setMap.put("ItemID", itemId);

    int j = 1;
    while (j != 0) {
      String toItemId = "";

      setMap.put("CURRENT_ITEM", itemId);
      setMap.put("CategoryCode", "ST1");
      list = this.commonService.selectList("report_SQL.getChildItems", setMap);
      j = list.size();
      for (int k = 0; list.size() > k; k++) {
        map = (Map)list.get(k);
        setMap.put("ItemID", map.get("ToItemID"));
        lowLankItemIdList.add(map.get("ToItemID"));

        if (k == 0)
          toItemId = "'" + String.valueOf(map.get("ToItemID")) + "'";
        else {
          toItemId = toItemId + ",'" + String.valueOf(map.get("ToItemID")) + "'";
        }
      }

      itemId = toItemId;
    }

    return lowLankItemIdList;
  }

  @RequestMapping({"/changeInfoViewDetail.do"})
  public String changeInfoViewDetail(HttpServletRequest request, ModelMap model)
    throws Exception
  {
    String url = "/project/changeInfo/changeInfoViewDetail";
    try
    {
      Map getMap = new HashMap();
      Map setMap = new HashMap();

      getMap.put("s_itemID", request.getParameter("changeSetID"));
      getMap.put("languageID", request.getParameter("LanguageID"));

      setMap = this.commonService.select("cs_SQL.getAdminChangeSetInfo", getMap);

      model.put("getData", setMap);
      model.put("menu", getLabel(request, this.commonService));

      model.put("isDone", StringUtil.checkNull(request.getParameter("isDone")));
      model.put("pjtIds", StringUtil.checkNull(request.getParameter("pjtIds")));
      model.put("stepInstIds", StringUtil.checkNull(request.getParameter("stepInstIds")));
      model.put("wfStepIds", StringUtil.checkNull(request.getParameter("wfStepIds")));
      model.put("wfIds", StringUtil.checkNull(request.getParameter("wfIds")));

      model.put("viewCheck", StringUtil.checkNull(request.getParameter("viewCheck")));
      model.put("isMine", StringUtil.checkNull(request.getParameter("isMine")));
      model.put("ProjectID", StringUtil.checkNull(request.getParameter("ProjectID")));

      model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "1"));
      model.put("status", StringUtil.checkNull(request.getParameter("status")));
      model.put("selGov", StringUtil.checkNull(request.getParameter("selGov")));
      model.put("isDoneMenu", StringUtil.checkNull(request.getParameter("isDoneMenu")));
    }
    catch (Exception e) {
      System.out.println(e.toString());
      throw new Exception("EM00001");
    }

    return nextUrl(url);
  }

  private void updateChangeSetForCsr(HttpServletRequest request, String s_itemID)
    throws Exception
  {
    HashMap setMap = new HashMap();
    HashMap fileMap = new HashMap();
    HashMap updateCommandMap = new HashMap();

    updateCommandMap = new HashMap();
    updateCommandMap.put("s_itemID", s_itemID);

    if ((request.getParameter("changeType").equals("DEL")) && (!request.getParameter("changeType").equals("")))
      updateCommandMap.put("Status", "DEL1");
    else if ((request.getParameter("changeType").equals("MOD")) && (!request.getParameter("changeType").equals(""))) {
      updateCommandMap.put("Status", "MOD1");
    }
    this.commonService.update("project_SQL.updateItemStatus", updateCommandMap);

    HashMap changeSetMap = new HashMap();

    setMap.put("ChangeSetID", request.getParameter("ChangeSetID"));
    changeSetMap = (HashMap)this.commonService.select("cs_SQL.getChangeSetData", setMap);
    String validFrom = StringUtil.checkNull(request.getParameter("ValidFrom")).trim();
    if ((validFrom.equals("")) || (validFrom == null)) {
      validFrom = StringUtil.checkNull(changeSetMap.get("CSREndDate"));
    }
    updateCommandMap.put("Status", request.getParameter("StatusCode"));
    updateCommandMap.put("Description", request.getParameter("description"));
    updateCommandMap.put("ChangeType", request.getParameter("changeType").substring(0, 3));
    updateCommandMap.put("Version", request.getParameter("version"));
    updateCommandMap.put("ValidFrom", validFrom);

    updateCommandMap.put("s_itemID", request.getParameter("ChangeSetID"));
    this.commonService.update("cs_SQL.updateChangeSetForWf", updateCommandMap);
  }

  private void insertChangeSetForCsr(HashMap commandMap, String s_itemID, String projectId)
    throws Exception
  {
    HashMap setMap = new HashMap();
    HashMap insertCommandMap = new HashMap();
    HashMap updateCommandMap = new HashMap();
    HashMap fileMap = new HashMap();

    setMap.put("itemID", s_itemID);
    setMap.remove("itemID");
    String sessionUserID = StringUtil.checkNull(commandMap.get("sessionUserId"));
    String LanguageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
    String srID = StringUtil.checkNull(commandMap.get("srID"));

    setMap.put("s_itemID", s_itemID);
    setMap.put("LanguageID", LanguageID);

    String changeType = this.commonService.selectString("project_SQL.getItemConvertStatus", setMap);

    HashMap itemInfoMap = new HashMap();
    HashMap userInfoMap = new HashMap();
    HashMap projectMap = new HashMap();

    itemInfoMap = (HashMap)this.commonService.select("project_SQL.getItemInfo", setMap);

    String itemStatus = StringUtil.checkNull(itemInfoMap.get("Status"));

    setMap.put("userId", sessionUserID);
    userInfoMap = (HashMap)this.commonService.select("project_SQL.getUserInfo", setMap);

    setMap.put("projectId", projectId);
    projectMap = (HashMap)this.commonService.select("project_SQL.getProjectCategory", setMap);

    int changeSetID = Integer.parseInt(this.commonService.selectString("cs_SQL.getMaxChangeSetData", setMap));
    commandMap.put("changeSetID", Integer.valueOf(changeSetID));

    setMap.put("itemClassCode", itemInfoMap.get("ClassCode"));
    String checkInOption = StringUtil.checkNull(this.commonService.selectString("project_SQL.getCheckInOption", setMap));

    if ("NEW1".equals(itemStatus))
      updateCommandMap.put("Status", "NEW1");
    else {
      updateCommandMap.put("Status", "MOD1");
    }
    updateCommandMap.put("AuthorID", sessionUserID);
    updateCommandMap.put("s_itemID", s_itemID);
    updateCommandMap.put("Blocked", "0");
    updateCommandMap.put("ProjectID", projectId);
    updateCommandMap.put("CurChangeSet", String.valueOf(changeSetID));
    updateCommandMap.put("OwnerTeamID", userInfoMap.get("TeamID"));
    updateCommandMap.put("ItemID", s_itemID);
    this.commonService.update("project_SQL.updateItemStatus", updateCommandMap);

    this.commonService.update("item_SQL.updateItemFromElement", updateCommandMap);

    List lowLanklist = getRowLankItemList(s_itemID);
    for (int k = 0; k < lowLanklist.size(); k++) {
      setMap.put("ItemID", lowLanklist.get(k));
      String cMgt = StringUtil.checkNull(this.commonService.selectString("project_SQL.getChangeMgt", setMap));

      if (!"1".equals(cMgt)) {
        updateCommandMap.put("s_itemID", lowLanklist.get(k));
        this.commonService.update("project_SQL.updateItemStatus", updateCommandMap);
      }
      setMap.remove("ItemID");
    }

    setMap.put("itemID", s_itemID);
    String version = StringUtil.checkNull(this.commonService.selectString("cs_SQL.getItemReleaseVersion", setMap), "1.0");
    String defVersion = StringUtil.checkNull(this.commonService.selectString("project_SQL.getItemClassDefVersion", setMap));

    if (defVersion.indexOf(".0") > 0) {
      BigDecimal version2 = new BigDecimal(version);
      BigDecimal defVersion2 = new BigDecimal(defVersion);
      BigDecimal versionD2 = version2.add(defVersion2);
      insertCommandMap.put("version", String.valueOf(versionD2));
    }
    else {
      int versionD2 = (int)Double.parseDouble(version) + (int)Double.parseDouble(defVersion);
      insertCommandMap.put("version", String.valueOf(versionD2));
    }

    insertCommandMap.put("ChangeSetID", Integer.valueOf(changeSetID));
    insertCommandMap.put("ProjectID", projectId);
    insertCommandMap.put("PJTCategory", projectMap.get("PJCategory"));
    insertCommandMap.put("ItemID", s_itemID);
    insertCommandMap.put("ItemClassCode", itemInfoMap.get("ClassCode"));
    insertCommandMap.put("ItemTypeCode", itemInfoMap.get("ItemTypeCode"));
    insertCommandMap.put("AuthorID", sessionUserID);
    insertCommandMap.put("AuthorName", commandMap.get("sessionUserNm"));
    insertCommandMap.put("AuthorTeamID", userInfoMap.get("TeamID"));
    insertCommandMap.put("CompanyID", userInfoMap.get("CompanyID"));
    insertCommandMap.put("Reason", projectMap.get("Reason"));
    insertCommandMap.put("ChangeType", changeType);
    insertCommandMap.put("SRID", srID);

    if ("NEW1".equals(itemStatus))
      insertCommandMap.put("Status", "NEW");
    else {
      insertCommandMap.put("Status", "MOD");
    }
    insertCommandMap.put("GUBUN", "insert");
    insertCommandMap.put("checkInOption", checkInOption);
    this.commonService.insert("cs_SQL.insertToChangeSet", insertCommandMap);

    updateCommandMap = new HashMap();
    updateCommandMap.put("ProjectID", projectId);
    updateCommandMap.put("Status", "CNG");
    this.commonService.update("project_SQL.updateProject", updateCommandMap);
  }

  private void insertChangeSetForCnItm(String s_itemID, String rootItem, String projectId, String cngtID, String languageID)
    throws Exception
  {
    HashMap setMap = new HashMap();
    HashMap insertCommandMap = new HashMap();
    HashMap updateCommandMap = new HashMap();

    setMap.put("s_itemID", s_itemID);
    setMap.put("LanguageID", languageID);

    HashMap changeSetMap = new HashMap();
    HashMap itemInfoMap = new HashMap();
    HashMap rootItemInfoMap = new HashMap();
    HashMap userInfoMap = new HashMap();
    HashMap projectMap = new HashMap();

    changeSetMap = (HashMap)this.commonService.select(
      "cs_SQL.getMaxChangeSetData", setMap);
    itemInfoMap = (HashMap)this.commonService.select("project_SQL.getItemInfo", 
      setMap);
    setMap.put("s_itemID", rootItem);
    rootItemInfoMap = (HashMap)this.commonService.select(
      "project_SQL.getItemInfo", setMap);
    setMap.put("userId", rootItemInfoMap.get("AuthorID"));
    userInfoMap = (HashMap)this.commonService.select("project_SQL.getUserInfo", 
      setMap);

    setMap.put("projectId", projectId);
    projectMap = (HashMap)this.commonService.select(
      "project_SQL.getProjectCategory", setMap);

    int changeSetID = 0;
    if (changeSetMap.get("ChangeSetID") != null)
      changeSetID = Integer.parseInt(changeSetMap.get("ChangeSetID")
        .toString()) + 1;
    else {
      changeSetID = 1;
    }

    setMap.put("ChangeSetID", cngtID);
    changeSetMap = (HashMap)this.commonService.select("cs_SQL.getRootCngtInfo", setMap);

    insertCommandMap.put("ChangeSetID", Integer.valueOf(changeSetID));
    insertCommandMap.put("ProjectID", projectId);
    insertCommandMap.put("PJTCategory", projectMap.get("PJCategory"));
    insertCommandMap.put("ItemID", s_itemID);
    insertCommandMap.put("ItemClassCode", itemInfoMap.get("ClassCode"));
    insertCommandMap.put("ItemTypeCode", itemInfoMap.get("ItemTypeCode"));

    insertCommandMap.put("AuthorID", 
      String.valueOf(changeSetMap.get("AuthorID")));
    insertCommandMap.put("AuthorName", userInfoMap.get("Name"));
    insertCommandMap.put("AuthorTeamID", userInfoMap.get("TeamID"));
    insertCommandMap.put("CompanyID", userInfoMap.get("CompanyID"));

    insertCommandMap.put("ChangeType", 
      String.valueOf(changeSetMap.get("ChangeType")));
    insertCommandMap.put("Status", 
      String.valueOf(changeSetMap.get("Status")));
    insertCommandMap.put("Description", 
      String.valueOf(changeSetMap.get("Description")));
    insertCommandMap.put("Reason", 
      String.valueOf(changeSetMap.get("Reason")));

    insertCommandMap.put("GUBUN", "insert");
    this.commonService.insert("cs_SQL.insertToChangeSet", insertCommandMap);

    updateCommandMap.put("Status", 
      String.valueOf(rootItemInfoMap.get("Status")));
    updateCommandMap.put("s_itemID", s_itemID);
    updateCommandMap.put("LockOwner", 
      String.valueOf(changeSetMap.get("AuthorID")));
    this.commonService.update("project_SQL.updateItemStatus", updateCommandMap);
  }

  private void insertProjectFiles(HashMap commandMap, String projectId)
    throws Exception
  {
    Map fileMap = new HashMap();
    List fileList = new ArrayList();

    int seqCnt = Integer.parseInt(this.commonService.selectString("fileMgt_SQL.itemFile_nextVal", commandMap));
    fileMap.put("projectID", projectId);
    String linkType = StringUtil.checkNull(commandMap.get("linkType"), "1");

    String orginPath = GlobalVal.FILE_UPLOAD_BASE_DIR + StringUtil.checkNull(commandMap.get("sessionUserId")) + "//";
    String filePath = GlobalVal.FILE_UPLOAD_ITEM_DIR;
    String targetPath = filePath;
    List tmpFileList = FileUtil.copyFiles(orginPath, targetPath);
    if (tmpFileList.size() != 0) {
      for (int i = 0; i < tmpFileList.size(); i++) {
        fileMap = new HashMap();
        HashMap resultMap = (HashMap)tmpFileList.get(i);
        fileMap.put("Seq", Integer.valueOf(seqCnt));
        fileMap.put("DocumentID", projectId);
        fileMap.put("projectID", projectId);
        fileMap.put("FileName", resultMap.get("SysFileNm"));
        fileMap.put("FileRealName", resultMap.get("FileNm"));
        fileMap.put("FileSize", resultMap.get("FileSize"));
        fileMap.put("FilePath", filePath);
        fileMap.put("FileMgt", "PJT");
        fileMap.put("DocCategory", "PJT");
        fileMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
        fileMap.put("userId", commandMap.get("sessionUserId"));
        fileMap.put("LinkType", linkType);
        fileMap.put("FltpCode", "CSRDF");
        fileMap.put("KBN", "insert");
        fileMap.put("DocCategory", "PJT");
        fileMap.put("SQLNAME", "fileMgt_SQL.itemFile_insert");
        fileList.add(fileMap);
        seqCnt++;
      }
    }

    if (fileList.size() != 0)
      this.CSService.save(fileList, fileMap);
  }

  @RequestMapping({"/cngCheckOutPop.do"})
  public String cngCheckOutPop(HttpServletRequest request, HashMap commandMap, ModelMap model)
    throws Exception
  {
    try
    {
      String checkType = StringUtil.checkNull(commandMap.get("checkType"), "OUT");
      Map setMap = new HashMap();

      setMap.put("userId", commandMap.get("sessionUserId"));
      setMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
      setMap.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
      setMap.put("ProjectType", "CSR");
      setMap.put("isMainItem", "Y");
      List projectNameList = this.commonService.selectList("project_SQL.getProjectNameList", setMap);

      if (projectNameList.size() == 1) {
        Map projectMap = (HashMap)projectNameList.get(0);
        model.put("CSRID", projectMap.get("ProjectID"));
      }

      model.put("checkType", checkType);
      model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
      model.put("projectNameList", projectNameList);
      model.put("srID", StringUtil.checkNull(request.getParameter("srID")));
      model.put("menu", getLabel(request, this.commonService));
    }
    catch (Exception e) {
      System.out.println(e.toString());
    }

    return nextUrl("/project/changeInfo/cngCheckOutPop");
  }
  @RequestMapping({"/checkInItem.do"})
  public String checkInItem(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    HashMap setMap = new HashMap();

    HashMap updateItemMap = new HashMap();
    HashMap updateCngtMap = new HashMap();
    HashMap updatePjtMap = new HashMap();
    try
    {
      String items = StringUtil.checkNull(request.getParameter("items"));
      String cngts = StringUtil.checkNull(request.getParameter("cngts"));
      String pjtIds = StringUtil.checkNull(request.getParameter("pjtIds"));
      String description = StringUtil.checkNull(request.getParameter("description"));
      String version = StringUtil.checkNull(request.getParameter("version"));
      String validFrom = StringUtil.checkNull(request.getParameter("validFrom")).trim();
      String changeType = StringUtil.checkNull(request.getParameter("changeType")).trim();

      String checkInOption = "";
      String csStatus = "CMP";
      int MDLCNT = 0;

      if (!items.isEmpty()) {
        String[] itemsArray = items.split(",");
        String[] cngtsArray = cngts.split(",");
        String[] pjtIdsArray = pjtIds.split(",");

        for (int i = 0; itemsArray.length > i; i++) {
          String itemId = itemsArray[i];
          String changeSetId = cngtsArray[i];
          String pjtId = pjtIdsArray[i];

          setMap.put("changeSetID", changeSetId);
          checkInOption = this.commonService.selectString("cs_SQL.getCheckInOptionCS", setMap);

          setMap.put("itemID", StringUtil.checkNull(itemsArray[i]));
          setMap.put("Status", "MOD");
          MDLCNT = Integer.parseInt(this.commonService.selectString("model_SQL.getMDLCNT", setMap));
          if (MDLCNT > 0) {
            target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00157"));
            model.addAttribute("resultMap", target);
            return nextUrl("/cmm/ajaxResult/ajaxPage");
          }

          String checkInItemStatus = "";
          setMap.put("s_itemID", itemId);
          String curItemStatus = this.commonService.selectString("project_SQL.getItemStatus", setMap);

          if (checkInOption.equals("01")) {
            csStatus = "CLS";
            checkInItemStatus = "REL";

            insertItemAttrRev(commandMap, itemId, pjtId, changeSetId);
          } else if (!"".equals(changeType))
          {
            if ("NEW".equals(changeType))
              checkInItemStatus = "NEW2";
            else if ("DEL".equals(changeType))
              checkInItemStatus = "DEL2";
            else if ("MOD".equals(changeType)) {
              checkInItemStatus = "MOD2";
            }

          }
          else if ("NEW1".equals(curItemStatus)) {
            checkInItemStatus = "NEW2";
          } else if ("DEL1".equals(curItemStatus)) {
            checkInItemStatus = "DEL2";
          } else if ("MOD1".equals(curItemStatus)) {
            checkInItemStatus = "MOD2";
          }

          List lowLanklist = getRowLankItemList(itemId);

          for (int k = 0; k < lowLanklist.size(); k++) {
            updateItemMap.put("s_itemID", lowLanklist.get(k));
            String childItemStatus = this.commonService.selectString("project_SQL.getItemStatus", updateItemMap);

            HashMap insertData = new HashMap();
            if ((childItemStatus.equals("NEW1")) || (childItemStatus.equals("DEL1"))) {
              insertData.put("docCategory", "ITM");
              insertData.put("objectType", this.commonService.selectString("item_SQL.getItemTypeCode", updateItemMap));
              insertData.put("documentID", lowLanklist.get(k));
              insertData.put("changeSetID", changeSetId);
              if (childItemStatus.equals("NEW1")) {
                insertData.put("description", "Created");
                insertData.put("revisionType", "NEW");
              } else {
                insertData.put("description", "Deleted");
                insertData.put("revisionType", "DEL");
              }
              insertData.put("authorID", commandMap.get("sessionUserId"));
              insertData.put("authorTeamID", commandMap.get("sessionTeamId"));
              this.commonService.insert("revision_SQL.insertRevision", insertData);
            }

          }

          updateItemMap = new HashMap();
          updateItemMap.put("Status", checkInItemStatus);
          updateItemMap.put("LastUser", commandMap.get("sessionUserId"));
          updateItemMap.put("Blocked", "2");
          updateItemMap.put("curChangeSet", changeSetId);
          updateItemMap.put("checkin", "Y");

          if (checkInOption.equals("01")) {
            updateItemMap.put("ReleaseNo", changeSetId);
          }

          this.commonService.update("project_SQL.updateItemStatus", updateItemMap);

          updateItemMap.remove("curChangeSet");
          updateItemMap.remove("checkin");

          updateCngtMap.put("Status", csStatus);
          updateCngtMap.put("CurTask", "CLS");
          updateCngtMap.put("s_itemID", changeSetId);
          updateCngtMap.put("userID", commandMap.get("sessionUserId"));
          updateCngtMap.put("Description", description);
          updateCngtMap.put("Version", version);
          updateCngtMap.put("ValidFrom", validFrom);
          updateCngtMap.put("ChangeType", changeType);
          updateCngtMap.put("checkInOption", checkInOption);
          this.commonService.update("cs_SQL.updateChangeSetForWf", updateCngtMap);

          updateItemMap = new HashMap();
          updateItemMap.put("ItemID", itemId);
          updateItemMap.put("Blocked", "1");
          this.commonService.update("model_SQL.updateModelBlockedOfItem", updateItemMap);

          if (checkInOption.equals("01"))
          {
            updateItemMap.put("csID", changeSetId);
            updateItemMap.put("itemID", itemId);
            this.commonService.update("fileMgt_SQL.updateFileBlockPreVersionWithCS", updateItemMap);

            if ((curItemStatus.equals("MOD1")) || ("MOD".equals(changeType))) {
              updateItemMap.put("orgMTCategory", "BAS");
              updateItemMap.put("updateMTCategory", "VER");
              this.commonService.update("model_SQL.updateModelCat", updateItemMap);

              updateItemMap.put("orgMTCategory", "TOBE");
              updateItemMap.put("updateMTCategory", "BAS");
              this.commonService.update("model_SQL.updateModelCat", updateItemMap);
            } else if ((curItemStatus.equals("DEL1")) || ("DEL".equals(changeType)))
            {
              updateItemMap = new HashMap();
              updateItemMap.put("s_itemID", itemId);
              updateItemMap.put("Deleted", "1");
              this.commonService.update("project_SQL.updateItemStatus", updateItemMap);
              updateItemMap.put("ItemID", itemId);
              this.commonService.update("item_SQL.updateCNItemDeleted", updateItemMap);

              for (int j = 0; j < lowLanklist.size(); j++) {
                updateItemMap = new HashMap();
                updateItemMap.put("s_itemID", lowLanklist.get(j));
                updateItemMap.put("Deleted", "1");
                this.commonService.update("project_SQL.updateItemStatus", updateItemMap);

                updateItemMap.put("ItemID", lowLanklist.get(j));
                this.commonService.update("item_SQL.updateCNItemDeleted", updateItemMap);
              }

            }

          }

          setMap.put("ProjectID", pjtId);
          List varItemList = this.commonService.selectList("project_SQL.getVarItemList", setMap);
          for (int k = 0; k < varItemList.size(); k++) {
            updateItemMap = new HashMap();
            updateItemMap.put("s_itemID", varItemList.get(k));
            updateItemMap.put("Blocked", "2");
            this.commonService.update("project_SQL.updateItemStatus", updateItemMap);
          }

          HashMap drmInfoMap = new HashMap();
          HashMap fileMap = new HashMap();
          List fileList = new ArrayList();

          String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
          String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
          String teamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
          String teamName = StringUtil.checkNull(commandMap.get("sessionTeamName"));
          String ChangeSetID = changeSetId;
          String projectId = pjtId;

          drmInfoMap.put("userID", userID);
          drmInfoMap.put("userName", userName);
          drmInfoMap.put("teamID", teamID);
          drmInfoMap.put("teamName", teamName);
          int seqCnt = 0;
          String fltpCode = "CSDOC";
          setMap.put("fltpCode", fltpCode);
          String fltpPath = StringUtil.checkNull(this.commonService.selectString("fileMgt_SQL.getFilePath", setMap));
          seqCnt = Integer.parseInt(this.commonService.selectString("fileMgt_SQL.itemFile_nextVal", setMap));

          String orginPath = GlobalVal.FILE_UPLOAD_ITEM_DIR + StringUtil.checkNull(commandMap.get("sessionUserId")) + "//";
          String targetPath = fltpPath;
          List tmpFileList = FileUtil.copyFiles(orginPath, targetPath);
          if (tmpFileList != null) {
            for (int j = 0; j < tmpFileList.size(); j++) {
              fileMap = new HashMap();
              HashMap resultMap = (HashMap)tmpFileList.get(j);
              fileMap.put("Seq", Integer.valueOf(seqCnt));
              fileMap.put("DocumentID", ChangeSetID);
              fileMap.put("FileName", resultMap.get("SysFileNm"));
              fileMap.put("FileRealName", resultMap.get("FileNm"));
              fileMap.put("FileSize", resultMap.get("FileSize"));
              fileMap.put("FilePath", fltpPath);
              fileMap.put("FltpCode", fltpCode);
              fileMap.put("ItemID", itemId);
              fileMap.put("FileMgt", "ITM");
              fileMap.put("ChangeSetID", changeSetId);
              fileMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
              fileMap.put("userId", userID);
              fileMap.put("projectID", projectId);
              fileMap.put("DocCategory", "CS");
              fileMap.put("SQLNAME", "fileMgt_SQL.itemFile_insert");

              String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);

              if ((useDRM != null) && (useDRM != ""))
              {
                drmInfoMap.put("ORGFileDir", targetPath);
                drmInfoMap.put("DRMFileDir", targetPath);
                drmInfoMap.put("Filename", resultMap.get("SysFileNm"));
                drmInfoMap.put("funcType", "upload");
                String str1 = DRMUtil.drmMgt(drmInfoMap);
              }

              fileList.add(fileMap);
              seqCnt++;
            }
            commandMap.put("KBN", "insert");
            this.CSService.save(fileList, commandMap);

            String path = GlobalVal.FILE_UPLOAD_ITEM_DIR + commandMap.get("sessionUserId");
            if (path.equals("")) continue; FileUtil.deleteDirectory(path);
          }
        }

      }

      if (!checkInOption.equals("03A")) {
        target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
      }

      target.put("SCRIPT", "fnCallBack('" + checkInOption + "')");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "this.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }
  @RequestMapping({"/closeChangeSet.do"})
  public String closeChangeSet(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    HashMap setMap = new HashMap();

    HashMap updateItemMap = new HashMap();
    HashMap updateCngtMap = new HashMap();
    HashMap updatePjtMap = new HashMap();
    try
    {
      String items = StringUtil.checkNull(request.getParameter("items"));
      String cngts = StringUtil.checkNull(request.getParameter("cngts"));
      String pjtIds = StringUtil.checkNull(request.getParameter("pjtIds"));

      if (!items.isEmpty()) {
        String[] itemsArray = items.split(",");
        String[] cngtsArray = cngts.split(",");
        String[] pjtIdsArray = pjtIds.split(",");

        for (int i = 0; itemsArray.length > i; i++) {
          String itemId = itemsArray[i];
          String changeSetId = cngtsArray[i];
          String pjtId = pjtIdsArray[i];
          setMap.put("changeSetID", changeSetId);

          updateCngtMap.put("Status", "CLS");
          updateCngtMap.put("CurTask", "CLS");
          updateCngtMap.put("s_itemID", changeSetId);
          updateCngtMap.put("userID", commandMap.get("sessionUserId"));
          this.commonService.update("cs_SQL.updateChangeSetForWf", updateCngtMap);

          String checkInItemStatus = "REL";
          updateItemMap.put("s_itemID", itemId);
          updateItemMap.put("Status", checkInItemStatus);
          updateItemMap.put("LastUser", commandMap.get("sessionUserId"));
          updateItemMap.put("Blocked", "2");
          this.commonService.update("project_SQL.updateItemStatus", updateItemMap);

          updateItemMap.put("itemID", itemId);
          updateItemMap.put("orgMTCategory", "BAS");
          updateItemMap.put("updateMTCategory", "VER");
          this.commonService.update("model_SQL.updateModelCat", updateItemMap);

          updateItemMap.put("orgMTCategory", "TOBE");
          updateItemMap.put("updateMTCategory", "BAS");
          this.commonService.update("model_SQL.updateModelCat", updateItemMap);

          List lowLanklist = getRowLankItemList(itemId);
          for (int k = 0; k < lowLanklist.size(); k++) {
            updateItemMap = new HashMap();
            updateItemMap.put("s_itemID", lowLanklist.get(k));
            String childItemStatus = this.commonService.selectString("project_SQL.getItemStatus", updateItemMap);

            HashMap insertData = new HashMap();
            updateItemMap.put("Status", "REL");

            updateItemMap.put("Blocked", "2");
            updateItemMap.put("ProjectID", pjtId);
            this.commonService.update("project_SQL.updateItemStatus", updateItemMap);
          }

          setMap.put("ProjectID", pjtId);
          List varItemList = this.commonService.selectList("project_SQL.getVarItemList", setMap);
          for (int k = 0; k < varItemList.size(); k++) {
            updateItemMap = new HashMap();
            updateItemMap.put("s_itemID", varItemList.get(k));
            updateItemMap.put("Blocked", "2");
            this.commonService.update("project_SQL.updateItemStatus", updateItemMap);
          }
        }
      }
      target.put("SCRIPT", "fnCallBack();parent.$('#isSubmit').remove();");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
    } catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "this.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  @RequestMapping({"/rework.do"})
  public String rework(HttpServletRequest request, HashMap commandMap, ModelMap model)
    throws Exception
  {
    HashMap target = new HashMap();
    HashMap setMap = new HashMap();

    HashMap updateItemMap = new HashMap();
    HashMap updateCngtMap = new HashMap();
    HashMap deletetaskMap = new HashMap();
    HashMap updatePjtMap = new HashMap();
    HashMap setData = new HashMap();
    try
    {
      String itemId = StringUtil.checkNull(request.getParameter("item"), "");
      String changeSetID = StringUtil.checkNull(request.getParameter("cngt"), "");
      String pjtId = StringUtil.checkNull(request.getParameter("pjtId"), "");

      updateCngtMap.put("Status", "MOD");
      updateCngtMap.put("CurTask", "RDY");
      updateCngtMap.put("s_itemID", changeSetID);
      updateCngtMap.put("changeSetID", changeSetID);
      updateCngtMap.put("ApproveDate", "Del");
      this.commonService.update("cs_SQL.updateChangeSetForWf", updateCngtMap);

      String changeTypeCode = StringUtil.checkNull(this.commonService.selectString("cs_SQL.getChangeTypeCode", updateCngtMap));

      deletetaskMap.put("ChangeSetID", changeSetID);
      this.commonService.delete("project_SQL.delTaskINfo", deletetaskMap);

      updatePjtMap.put("ProjectID", pjtId);
      updatePjtMap.put("Status", "CNG");
      this.commonService.update("project_SQL.updateProject", updatePjtMap);

      updateItemMap.put("s_itemID", itemId);
      updateItemMap.put("LastUser", commandMap.get("sessionUserId"));
      updateItemMap.put("Blocked", "0");
      updateItemMap.put("Status", "MOD1");
      if (changeTypeCode.equals("NEW")) updateItemMap.put("Status", "NEW1");

      this.commonService.update("project_SQL.updateItemStatus", updateItemMap);
      updateItemMap.remove("s_itemID");
      updateItemMap.put("curChangeSet", changeSetID);
      updateItemMap.put("rework", "Y");

      this.commonService.update("project_SQL.updateItemStatus", updateItemMap);

      setData.put("itemID", itemId);
      setData.put("changeSetID", changeSetID);
      setData.put("orgMTCategory", "WTR");
      setData.put("updateMTCategory", "TOBE");
      if (changeTypeCode.equals("NEW")) setData.put("updateMTCategory", "BAS");
      this.commonService.update("model_SQL.updateModelCat", setData);

      updateItemMap = new HashMap();
      updateItemMap.put("ItemID", itemId);
      updateItemMap.put("changeSetID", changeSetID);
      updateItemMap.put("Blocked", "0");
      this.commonService.update("model_SQL.updateModelBlockedOfItem", updateItemMap);

      String myPageFlg = StringUtil.checkNull(request.getParameter("myPage"), "N");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));

      if ("Y".equals(myPageFlg)) {
        target.put("SCRIPT", "fnCallBack();parent.$('#isSubmit').remove();");
      }
      else
        target.put("SCRIPT", "parent.fnCallBack();parent.$('#isSubmit').remove();");
    }
    catch (Exception e)
    {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  @RequestMapping({"/csrAprvHistory.do"})
  public String csrAprvHistory(HttpServletRequest request, ModelMap model)
    throws Exception
  {
    String url = "/project/pjt/csrAprvHistory";
    try
    {
      model.put("menu", getLabel(request, this.commonService));
      model.put("ProjectID", StringUtil.checkNull(request.getParameter("ProjectID")));
      model.put("isNew", StringUtil.checkNull(request.getParameter("isNew")));
      model.put("mainMenu", StringUtil.checkNull(request.getParameter("mainMenu"), "1"));
      model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
      model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));

      model.put("seletedTreeId", StringUtil.checkNull(request.getParameter("seletedTreeId")));
      model.put("isItemInfo", StringUtil.checkNull(request.getParameter("isItemInfo")));
    }
    catch (Exception e) {
      System.out.println(e.toString());
      throw new Exception("EM00001");
    }

    return nextUrl(url);
  }
  @RequestMapping({"/getCsrListOption.do"})
  public String getCsrListOption(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    Map setMap = new HashMap();
    String creator = StringUtil.checkNull(request.getParameter("Creator"));
    String userId = String.valueOf(commandMap.get("sessionUserId"));
    String isIssue = StringUtil.checkNull(request.getParameter("isIssue"));
    String screenType = StringUtil.checkNull(request.getParameter("screenType"));
    String projectID = StringUtil.checkNull(request.getParameter("projectID"));

    setMap.put("ProjectType", "CSR");

    setMap.put("languageID", StringUtil.checkNull(request.getParameter("languageID")));
    if (screenType.equals("PG")) {
      setMap.put("RefPGID", projectID);
    } else if (screenType.equals("PJT")) {
      setMap.put("RefPjtID", projectID);
    } else if (screenType.equals("myPage")) {
      setMap.put("memberId", userId);
      setMap.put("RefPjtID", projectID);
    } else {
      setMap.put("RefPjtID", projectID);
    }

    if (!creator.isEmpty()) {
      setMap.put("Creator", creator);
    }
    if ("Y".equals(isIssue)) {
      setMap.put("Status", "CLS");
    }

    model.put("resultMap", this.commonService.selectList("project_SQL.getParentPjtList", setMap));
    return nextUrl("/cmm/ajaxResult/ajaxOption");
  }

  @RequestMapping({"/myChangeSet.do"})
  public String myChangeSet(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    String url = "project/changeInfo/myChangeSet";
    Map setMap = new HashMap();
    List classCodeList = new ArrayList();
    List parentPjtList = new ArrayList();
    List csrList = new ArrayList();
    List statusList = new ArrayList();
    try
    {
      setMap.put("ProjectType", "PJT");
      setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
      parentPjtList = this.commonService.selectList("project_SQL.getParentPjtList", setMap);

      setMap.put("ProjectType", "CSR");
      csrList = this.commonService.selectList("project_SQL.getParentPjtList", setMap);

      setMap.put("LanguageID", String.valueOf(commandMap.get("sessionCurrLangType")));
      classCodeList = this.commonService.selectList("cs_SQL.getClassCodeList", setMap);

      setMap.put("Category", "CNGSTS");

      statusList = this.commonService.selectList("project_SQL.getChangeSetInsertInfo", setMap);

      setMap.put("DocCategory", "CS");
      String wfURL = StringUtil.checkNull(this.commonService.selectString("wf_SQL.getWFCategoryURL", setMap));

      model.put("parentPjtList", parentPjtList);
      model.put("csrList", csrList);
      model.put("classCodeList", classCodeList);
      model.put("wfURL", wfURL);
      model.put("statusList", statusList);
      model.put("isPop", StringUtil.checkNull(request.getParameter("isPop"), "N"));
      model.put("currPageA", StringUtil.checkNull(request.getParameter("currPageA"), "1"));
      model.put("menu", getLabel(request, this.commonService));
    }
    catch (Exception e) {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }

    return nextUrl(url);
  }

  @RequestMapping({"/changeCsrOrder.do"})
  public String changeCsrOrder(HttpServletRequest request, HashMap commandMap, ModelMap model)
    throws Exception
  {
    HashMap target = new HashMap();
    Map setMap = new HashMap();
    Map updateItemMap = new HashMap();
    Map updateCngtMap = new HashMap();
    try {
      String cngts = StringUtil.checkNull(request.getParameter("cngts"));
      String projectId = StringUtil.checkNull(request.getParameter("pjtId"));

      if (!cngts.isEmpty()) {
        String[] cngtArray = cngts.split(",");
        for (int i = 0; cngtArray.length > i; i++) {
          String cngtId = cngtArray[i];

          setMap.put("ChangeSetID", cngtId);
          Map itemInfoMap = this.commonService.select("cs_SQL.getChangeSetData", setMap);
          if (itemInfoMap != null) {
            updateItemMap.put("s_itemID", itemInfoMap.get("ItemID"));
            updateItemMap.put("ProjectID", projectId);
            this.commonService.update("project_SQL.updateItemStatus", updateItemMap);
            updateCngtMap.put("Status", itemInfoMap.get("Status"));

            updateItemMap.put("ChangeSetID", itemInfoMap.get("ChangeSetID"));
            this.commonService.update("project_SQL.updateItemProjectForCS", updateItemMap);
          }

          updateCngtMap.put("s_itemID", cngtId);
          updateCngtMap.put("newPjtId", projectId);
          this.commonService.update("cs_SQL.updateChangeSetForWf", updateCngtMap);
        }

      }

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
      target.put("SCRIPT", "this.thisReload();this.$('#isSubmit').remove();");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "this.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  private int updateWfStepInstStatus(String changeSetId, String pjtId, String wfId, String wfStepId, String stepInstId)
    throws Exception
  {
    int result = 1;

    HashMap searchMap = new HashMap();
    HashMap updateMap = new HashMap();

    updateMap.put("Status", "1");
    updateMap.put("ProjectID", pjtId);
    if (!changeSetId.isEmpty())
      updateMap.put("ChangeSetID", changeSetId);
    else if (!stepInstId.isEmpty()) {
      updateMap.put("StepInstID", stepInstId);
    }
    updateMap.put("WFID", wfId);
    updateMap.put("WFStepID", wfStepId);
    this.commonService.update("wf_SQL.updateWFStepInst", updateMap);

    searchMap.put("ProjectID", pjtId);
    searchMap.put("WFID", wfId);
    searchMap.put("WFStepID", wfStepId);
    List wfStepInstList = this.commonService.selectList("wf_SQL.getWfStepInstList_gridList", searchMap);

    int flg = 0;

    for (int j = 0; wfStepInstList.size() > j; j++) {
      Map map = (Map)wfStepInstList.get(j);
      String status = (String)map.get("Status");
      if (status.equals("0")) {
        flg = 1;
      }
    }

    if (flg == 0)
    {
      result = 2;

      updateMap = new HashMap();
      updateMap.put("Status", "2");
      updateMap.put("ProjectID", pjtId);
      updateMap.put("WFID", wfId);

      this.commonService.update("wf_SQL.updateWFStepInst", updateMap);
    }

    return result;
  }

  @RequestMapping({"/argAprMultiUpdate_ORG.do"})
  public String argAprMultiUpdate_ORG(HttpServletRequest request, HashMap commandMap, ModelMap model)
    throws Exception
  {
    Map target = new HashMap();
    try
    {
      Map setMap = new HashMap();
      Map getRefMap = new HashMap();
      Map updateCngtMap = new HashMap();
      Map updatePjtMap = new HashMap();
      Map updateItemMap = new HashMap();
      Map updateMemberMap = new HashMap();

      String userId = String.valueOf(commandMap.get("sessionUserId"));
      String pjtIds = StringUtil.checkNull(request.getParameter("pjtIds"));
      String srID = StringUtil.checkNull(request.getParameter("srID"));

      if (!pjtIds.isEmpty()) {
        String[] pjtIdArray = pjtIds.split(",");

        for (int i = 0; i < pjtIdArray.length; i++) {
          String pjtId = pjtIdArray[i];

          setMap.put("ProjectID", pjtId);
          setMap.put("ActorID", userId);

          Map wfStepInstInfoMap = this.commonService.select("wf_SQL.getWfStepInstInfo", setMap);

          String stepInstId = StringUtil.checkNull(wfStepInstInfoMap.get("StepInstID"));
          String wfStepId = StringUtil.checkNull(wfStepInstInfoMap.get("WFStepID"));
          String wfId = StringUtil.checkNull(wfStepInstInfoMap.get("WFID"));

          int isDone = updateWfStepInstStatus("", pjtId, wfId, wfStepId, stepInstId);

          if (isDone == 2) {
            setMap.put("WFID", wfId);
            setMap.put("PreStepID", wfStepId);
            String nextWfStep = StringUtil.checkNull(this.commonService.selectString("project_SQL.getWfStepId", setMap));
            if (nextWfStep.isEmpty()) {
              updatePjtMap.put("Status", "CNG");
              updatePjtMap.put("EndDate", "EndDate");
              updatePjtMap.put("CurWFStepID", wfStepId);
              updatePjtMap.put("srID", srID);
            } else {
              updatePjtMap.put("CurWFStepID", nextWfStep);
            }
          } else {
            updatePjtMap.put("CurWFStepID", wfStepId);
          }
          updatePjtMap.put("ProjectID", pjtId);
          updatePjtMap.put("srID", srID);
          this.commonService.update("project_SQL.updateProject", updatePjtMap);

          HashMap updateSts = new HashMap();
          if (!srID.equals("")) {
            updateSts.put("srID", srID);
            updateSts.put("status", "CNG");
            updateSts.put("lastUser", commandMap.get("sessionUserId"));
            this.commonService.insert("esm_SQL.updateESMSRStatus", updateSts);
          }

          setMap.put("WFID", wfId);
          String lastWFStepID = StringUtil.checkNull(this.commonService.selectString("project_SQL.getLastWFStepID", setMap));

          if ((!lastWFStepID.equals(wfStepId)) || (isDone != 2))
            continue;
          setMap.put("ProjectID", pjtId);
          updateMemberMap = new HashMap();
          updateMemberMap.put("ProjectID", pjtId);
          updateMemberMap.put("Involved", Integer.valueOf(0));
          updateMemberMap.put("DropOutDate", "sysdate");
          this.commonService.update("project_SQL.updatePjtMemberRel", updateMemberMap);
        }

      }

      Map setProcMapRst = setProcLog(request, this.commonService, updatePjtMap);
      if (setProcMapRst.get("type").equals("FAILE")) {
        String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
        System.out.println("Msg : " + Msg);
      }

      String screenType = StringUtil.checkNull(request.getParameter("screenType"));
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00083"));
      if (screenType.equals("csrDtl"))
        target.put("SCRIPT", "this.fnCallBack();this.$('#isSubmit').remove();parent.$('#isSubmit').remove();");
      else
        target.put("SCRIPT", "this.goReqList(3);this.$('#isSubmit').remove();parent.$('#isSubmit').remove();");
    }
    catch (Exception e)
    {
      System.out.println(e);
      target.put("SCRIPT", "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00084"));
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  @RequestMapping({"/argAprMultiUpdate.do"})
  public String argAprMultiUpdate(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    Map target = new HashMap();
    try {
      Map setMap = new HashMap();
      Map updateData = new HashMap();
      Map updatePjtMap = new HashMap();
      Map updateMemberMap = new HashMap();

      String userId = String.valueOf(commandMap.get("sessionUserId"));
      String pjtIds = StringUtil.checkNull(request.getParameter("pjtIds"));
      String srID = StringUtil.checkNull(request.getParameter("srID"));

      if (!pjtIds.isEmpty()) {
        String[] pjtIdArray = pjtIds.split(",");
        for (int i = 0; i < pjtIdArray.length; i++) {
          String pjtId = pjtIdArray[i];

          setMap.put("projectID", pjtId);
          setMap.put("actorID", userId);

          Map wfStepInstInfoMap = this.commonService.select("wf_SQL.getWfStepInstInfo", setMap);

          String stepInstId = StringUtil.checkNull(wfStepInstInfoMap.get("StepInstID"));
          String wfStepId = StringUtil.checkNull(wfStepInstInfoMap.get("WFStepID"));
          String wfId = StringUtil.checkNull(wfStepInstInfoMap.get("WFID"));

          int isDone = updateWfStepInstStatus("", pjtId, wfId, wfStepId, stepInstId);

          if (isDone == 2) {
            updatePjtMap.put("ProjectID", pjtId);
            updatePjtMap.put("Status", "CNG");
            updatePjtMap.put("EndDate", "EndDate");
            updatePjtMap.put("srID", srID);
            this.commonService.update("project_SQL.updateProject", updatePjtMap);
          }
          else {
            setMap.put("ProjectID", pjtId);
            String wfInstansceID = this.commonService.selectString("wf_SQL.getWFInstance", setMap);
            String nextWFStepInstSeq = this.commonService.selectString("wf_SQL.getWFStepInstSeq", setMap);
            updateData.put("projectID", pjtId);
            updateData.put("LastUser", userId);
            updateData.put("lastSeq", nextWFStepInstSeq);
            updateData.put("WFInstanceID", wfInstansceID);
            this.commonService.update("wf_SQL.updateWfInst", updateData);
          }

          HashMap updateSts = new HashMap();
          if (!srID.equals("")) {
            updateSts.put("srID", srID);
            updateSts.put("status", "CNG");
            updateSts.put("lastUser", commandMap.get("sessionUserId"));
            this.commonService.insert("esm_SQL.updateESMSRStatus", updateSts);
          }

          setMap.put("WFID", wfId);

          if (isDone != 2)
            continue;
          setMap.put("ProjectID", pjtId);
          updateMemberMap = new HashMap();
          updateMemberMap.put("ProjectID", pjtId);
          updateMemberMap.put("Involved", Integer.valueOf(0));
          updateMemberMap.put("DropOutDate", "sysdate");
          this.commonService.update("project_SQL.updatePjtMemberRel", updateMemberMap);
        }

      }

      Map setProcMapRst = setProcLog(request, this.commonService, updatePjtMap);
      if (setProcMapRst.get("type").equals("FAILE")) {
        String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
        System.out.println("Msg : " + Msg);
      }

      String screenType = StringUtil.checkNull(request.getParameter("screenType"));
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00083"));
      if (screenType.equals("csrDtl"))
        target.put("SCRIPT", "this.fnCallBack();this.$('#isSubmit').remove();parent.$('#isSubmit').remove();");
      else
        target.put("SCRIPT", "this.goReqList(3);this.$('#isSubmit').remove();parent.$('#isSubmit').remove();");
    }
    catch (Exception e)
    {
      System.out.println(e);
      target.put("SCRIPT", "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00084"));
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  private void copyBaseModel(HashMap commandMap, String s_itemID) throws Exception
  {
    HashMap setMap = new HashMap();
    System.out.println("Test ==> ");
    String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
    setMap.put("itemID", s_itemID);
    setMap.put("languageID", languageID);
    setMap.put("mtCategory", "BAS");
    System.out.println("Test ==> " + languageID);
    Map baseModelInfo = this.commonService.select("project_SQL.getBasModelInfo", setMap);
    System.out.println("Test ==> ");
    setMap.remove("mtCategory");
    Map otherModelInfo = this.commonService.select("project_SQL.getBasModelInfo", setMap);
    if ((baseModelInfo != null) && (!baseModelInfo.isEmpty())) {
      setMap.put("blocked", "1");
      setMap.put("MTCategory", "BAS");
      setMap.put("modelID", baseModelInfo.get("ModelID"));
      commandMap.put("orgModelID", baseModelInfo.get("ModelID"));
      this.commonService.update("project_SQL.updateModel", setMap);

      String newModelID = StringUtil.checkNull(this.commonService.selectString("model_SQL.getMaxModelIDString", setMap));
      setMap.put("newModelID", newModelID);
      setMap.put("newMTCTypeCode", "TOBE");
      setMap.put("Creator", commandMap.get("sessionUserId"));
      setMap.put("orgModelID", baseModelInfo.get("ModelID"));
      setMap.put("newModelName", baseModelInfo.get("ModelName"));
      setMap.put("csrYN", "Y");
      setMap.put("projectID", commandMap.get("projectId"));
      setMap.put("changeSetID", commandMap.get("changeSetID"));
      setMap.put("blocked", "0");
      this.commonService.insert("model_SQL.copyModel", setMap);

      List getElementList = this.commonService.selectList("model_SQL.getCpElementList", setMap);
      List getLanguageList = this.commonService.selectList("common_SQL.langType_commonSelect", setMap);
      setMap.put("includeItemMaster", "Y");
      for (int i = 0; i < getLanguageList.size(); i++) {
        Map getMap = (HashMap)getLanguageList.get(i);
        setMap.put("LanguageID", getMap.get("CODE"));
        this.commonService.insert("model_SQL.copyModelTxt", setMap);
      }

      Map setData = new HashMap();
      for (int i = 0; i < getElementList.size(); i++) {
        Map getMap = (HashMap)getElementList.get(i);
        setMap.put("orgElementID", getMap.get("ElementID"));
        this.commonService.insert("model_SQL.copyModelElement", setMap);
      }
    }
    else if ((otherModelInfo != null) && (!otherModelInfo.isEmpty())) {
      setMap.put("blocked", "1");
      setMap.put("MTCategory", "WTR");
      setMap.put("modelID", baseModelInfo.get("ModelID"));
      commandMap.put("orgModelID", baseModelInfo.get("ModelID"));
      this.commonService.update("project_SQL.updateModel", setMap);

      String newModelID = StringUtil.checkNull(this.commonService.selectString("model_SQL.getMaxModelIDString", setMap));
      setMap.put("newModelID", newModelID);
      setMap.put("newMTCTypeCode", "BAS");
      setMap.put("Creator", commandMap.get("sessionUserId"));
      setMap.put("orgModelID", otherModelInfo.get("ModelID"));
      setMap.put("newModelName", otherModelInfo.get("ModelName"));
      setMap.put("csrYN", "Y");
      setMap.put("projectID", commandMap.get("projectId"));
      setMap.put("changeSetID", commandMap.get("changeSetID"));
      setMap.put("blocked", "0");
      this.commonService.insert("model_SQL.copyModel", setMap);

      List getElementList = this.commonService.selectList("model_SQL.getCpElementList", setMap);
      List getLanguageList = this.commonService.selectList("common_SQL.langType_commonSelect", setMap);
      setMap.put("includeItemMaster", "Y");
      for (int i = 0; i < getLanguageList.size(); i++) {
        Map getMap = (HashMap)getLanguageList.get(i);
        setMap.put("LanguageID", getMap.get("CODE"));
        this.commonService.insert("model_SQL.copyModelTxt", setMap);
      }

      Map setData = new HashMap();
      for (int i = 0; i < getElementList.size(); i++) {
        Map getMap = (HashMap)getElementList.get(i);
        setMap.put("orgElementID", getMap.get("ElementID"));
        this.commonService.insert("model_SQL.copyModelElement", setMap);
      }
    }
  }

  @RequestMapping({"/updateCSStatusForWF.do"})
  public String updateCSStatusForWF(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    Map setMap = new HashMap();
    Map updateMap = new HashMap();
    Map tempMap = new HashMap();
    Map updateItemMap = new HashMap();
    try
    {
      String wfInstanceID = StringUtil.checkNull(commandMap.get("wfInstanceID"), "");
      String sessionUserId = StringUtil.checkNull(commandMap.get("sessionUserId"));
      String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
      String status = StringUtil.checkNull(commandMap.get("status"));
      String preFileBlocked = StringUtil.checkNull(commandMap.get("preFileBlocked"));

      setMap.put("languageID", languageID);
      setMap.put("wfInstanceID", wfInstanceID);
      List csList = this.commonService.selectList("cs_SQL.getChangeSetList_gridList", setMap);

      for (int i = 0; i < csList.size(); i++)
      {
        tempMap = (Map)csList.get(i);
        String csID = StringUtil.checkNull(tempMap.get("ChangeSetID"));
        String projectID = StringUtil.checkNull(tempMap.get("ProjectID"));

        updateMap.put("s_itemID", csID);

        if ("WTR".equals(status)) {
          updateMap.put("csStatus", "HOLD");
        }
        else {
          updateMap.put("csStatus", status);
        }

        this.commonService.update("cs_SQL.updateChangeSetClose", updateMap);

        String csItemID = tempMap.get("ItemID").toString();
        List lowLanklist = getRowLankItemList(csItemID);

        setMap.put("s_itemID", csItemID);
        setMap.put("csID", csID);

        if ("CLS".equals(status))
        {
          setMap.put("itemID", csItemID);
          this.commonService.update("fileMgt_SQL.updateFileBlockPreVersionWithCS", setMap);

          setMap.put("Status", "REL");
          setMap.put("LastUser", sessionUserId);
          setMap.put("ReleaseNo", csID);
          setMap.put("curChangeSet", csID);
          setMap.put("Blocked", "2");
          setMap.remove("s_itemID");
          this.commonService.update("project_SQL.updateItemStatus", setMap);

          insertItemAttrRev(commandMap, csItemID, projectID, csID);

          if ("MOD".equals(tempMap.get("ChangeTypeCode"))) {
            Map setData = new HashMap();
            setData.put("itemID", csItemID);
            setData.put("orgMTCategory", "BAS");
            setData.put("updateMTCategory", "VER");
            this.commonService.update("model_SQL.updateModelCat", setData);

            setData.put("orgMTCategory", "TOBE");
            setData.put("updateMTCategory", "BAS");
            this.commonService.update("model_SQL.updateModelCat", setData);
          }
          else if ("DEL".equals(tempMap.get("ChangeTypeCode"))) {
            Map setData = new HashMap();
            setData.put("itemID", csItemID);
            setData.put("deleted", "1");
            this.commonService.update("project_SQL.updateItemDeletedFromCS", setData);

            for (int j = 0; j < lowLanklist.size(); j++) {
              updateItemMap = new HashMap();
              updateItemMap.put("s_itemID", lowLanklist.get(j));
              updateItemMap.put("Deleted", "1");
              this.commonService.update("project_SQL.updateItemStatus", updateItemMap);

              updateItemMap.put("ItemID", lowLanklist.get(j));
              this.commonService.update("item_SQL.updateCNItemDeleted", updateItemMap);
            }
          }
        } else if ("WTR".equals(status)) {
          this.commonService.update("fileMgt_SQL.updateFileBlockWithCSID", setMap);

          if ("MOD".equals(tempMap.get("ChangeTypeCode"))) {
            Map setData = new HashMap();
            setData.put("itemID", csItemID);

            setData.put("orgMTCategory", "TOBE");
            setData.put("updateMTCategory", "WTR");
            this.commonService.update("model_SQL.updateModelCat", setData);
          }
          else if ("NEW".equals(tempMap.get("ChangeTypeCode"))) {
            Map setData = new HashMap();
            setData.put("itemID", csItemID);

            setData.put("orgMTCategory", "BAS");
            setData.put("updateMTCategory", "WTR");
            this.commonService.update("model_SQL.updateModelCat", setData);

            setMap.put("Status", "NEW1");
            setMap.put("LastUser", sessionUserId);
            setMap.put("s_itemID", csItemID);

            this.commonService.update("project_SQL.updateItemStatus", setMap);
          }
          else if ("DEL".equals(tempMap.get("ChangeTypeCode"))) {
            Map setData = new HashMap();
            setData.put("itemID", csItemID);

            setData.put("orgMTCategory", "TOBE");

            setData.put("updateMTCategory", "WTR");
            this.commonService.update("model_SQL.updateModelCat", setData);
          }

        }

      }

      Map setProcMapRst = setProcLog(request, this.commonService, setMap);
      if (setProcMapRst.get("type").equals("FAILE")) {
        String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
        System.out.println("Msg : " + Msg);
      }
      String screenType = StringUtil.checkNull(request.getParameter("screenType"));
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
      target.put("SCRIPT", "this.fnCallBack();this.$('#isSubmit').remove();parent.$('#isSubmit').remove();");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  @RequestMapping({"/mainChangeSetList.do"})
  public String mainChangeSetList(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception {
    try {
      String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"));

      model.put("itemTypeCode", itemTypeCode);
      model.put("menu", getLabel(request, this.commonService));
    }
    catch (Exception e) {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }

    return nextUrl("/hom/main/cs/mainChangeSetList");
  }
  @RequestMapping({"/mainChangeSetList_v2.do"})
  public String mainChangeSetList_v2(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception {
    try {
      String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"));

      model.put("itemTypeCode", itemTypeCode);
      model.put("menu", getLabel(request, this.commonService));
    }
    catch (Exception e) {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }

    return nextUrl("/hom/main/cs/mainChangeSetList_v2");
  }
  @RequestMapping({"/olmMainChangeSetList.do"})
  public String olmMainChangeSetList(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception {
    try {
      Map setMap = new HashMap();
      String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));

      setMap.put("languageID", languageID);
      setMap.put("pageNo", Integer.valueOf(1));
      setMap.put("topNum", Integer.valueOf(10));
      setMap.put("changeMgtYN", "Yes");
      setMap.put("categoryCode", "OJ");
      List csList = this.commonService.selectList("item_SQL.getLastUpdatedWithin7Days", setMap);

      model.put("csList", csList);
      model.put("languageID", languageID);
      model.put("menu", getLabel(request, this.commonService));
    }
    catch (Exception e)
    {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }

    return nextUrl("/hom/main/v34/olmMainChangeSetList");
  }

  @RequestMapping({"/checkInCommentPop.do"})
  public String checkInCommentPop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception
  {
    try
    {
      String pjtIds = StringUtil.checkNull(request.getParameter("pjtIds"));
      String cngts = StringUtil.checkNull(request.getParameter("cngts"));
      String items = StringUtil.checkNull(request.getParameter("items"));

      model.put("pjtIds", pjtIds);
      model.put("cngts", cngts);
      model.put("items", items);
      model.put("menu", getLabel(request, this.commonService));
    }
    catch (Exception e) {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }
    return nextUrl("/popup/checkInCommentPop");
  }
}