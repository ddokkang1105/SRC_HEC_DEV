package xbolt.wf.web;

import java.io.PrintStream;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
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
import xbolt.cmm.framework.util.EmailUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

@Controller
public class WfActionController extends XboltController
{

  @Resource(name="commonService")
  private CommonService commonService;

  @RequestMapping({"/searchWFMemberPop.do"})
  public String searchWFMemberPop(HttpServletRequest request, HashMap commandMap, ModelMap model)
    throws Exception
  {
    try
    {
      model.put("searchValue", request.getParameter("searchValue"));
      List getList = new ArrayList();
      Map setMap = new HashMap();

      setMap.put("languageID", commandMap.get("sessionCurrLangType"));
      setMap.put("searchKey", request.getParameter("searchKey"));
      setMap.put("searchValue", request.getParameter("searchValue"));
      setMap.put("teamID", commandMap.get("teamID"));
      getList = this.commonService.selectList("project_SQL.searchPjtNamePop", setMap);

      model.put("getList", getList);
      model.put("projectId", commandMap.get("projectId"));
      model.put("teamID", commandMap.get("teamID"));
      model.put("menu", getLabel(request, this.commonService));
    } catch (Exception e) {
      System.out.println(e.toString());
    }
    return nextUrl("/wf/searchWFMemberPop");
  }
  @RequestMapping({"/selectWFMemberPop.do"})
  public String selectWFMemberPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    try {
      String flg = StringUtil.checkNull(request.getParameter("flg"));

      model.put("wfLabel", getLabel(request, this.commonService, "WFSTEP"));
      model.put("flg", flg);
      model.put("menuStyle", "csh_organization");
      model.put("arcCode", "AR000002");
      model.put("menu", getLabel(request, this.commonService));
      model.put("agrYN", StringUtil.checkNull(request.getParameter("agrYN"), "N"));
      model.put("agrSeq", StringUtil.checkNull(this.commonService.selectString("wf_SQL.getAgrSeq", commandMap), ""));
    }
    catch (Exception e) {
      System.out.println(e.toString());
      throw new ExceptionUtil(e.toString());
    }
    return nextUrl("wf/selectWFMemberPop");
  }
  @RequestMapping({"/wfAllcation.do"})
  public String wfAllcation(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    Map setMap = new HashMap();
    try
    {
      String wf_id = StringUtil.checkNull(request.getParameter("wfid"));
      String languageID = request.getParameter("languageID");

      setMap.put("languageID", languageID);

      setMap.put("WFID", wf_id);
    }
    catch (Exception e)
    {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }
    return nextUrl("wf/wfAllcation");
  }
  @RequestMapping({"/aprvBySysRole.do"})
  public String aprvBySysRole(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    try
    {
      HashMap setMap = new HashMap();
      String srID = StringUtil.checkNull(commandMap.get("srID"));
      String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));

      setMap.put("srID", srID);
      setMap.put("languageID", languageID);
      String RequestUserID = StringUtil.checkNull(this.commonService.selectString("esm_SQL.getESMSRReqUserID", setMap));

      setMap.put("sessionUserId", RequestUserID);
      String reqTeamID = StringUtil.checkNull(this.commonService.selectString("user_SQL.userTeamID", setMap));

      setMap.put("teamID", reqTeamID);
      Map managerInfo = this.commonService.select("user_SQL.getUserTeamManagerInfo", setMap);

      if (managerInfo.isEmpty()) {
        String parentTeamID = this.commonService.selectString("user_SQL.getParentTeamID", setMap);
        setMap.put("teamID", parentTeamID);
        managerInfo = this.commonService.select("user_SQL.getUserTeamManagerInfo", setMap);
      }

      String itemID = StringUtil.checkNull(commandMap.get("itemID"));
      String roleType = StringUtil.checkNull(commandMap.get("roleType"));
      String assignmentType = StringUtil.checkNull(commandMap.get("assignmentType"));

      if (itemID.equals("")) itemID = StringUtil.checkNull(this.commonService.selectString("esm_SQL.getESMSRArea2", setMap));
      if (roleType.equals("")) roleType = "I";
      if (assignmentType.equals("")) assignmentType = "SRROLETP";

      setMap.put("itemID", itemID);
      setMap.put("roleType", roleType);
      setMap.put("assignmentType", assignmentType);
      List myItemMemberList = this.commonService.selectList("esm_SQL.getWFMemberList", setMap);

      String wfStepInfo = "";
      String memberIDs = "";
      String roleTypes = "";
      Map itemMemberInfo = new HashMap();

      String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
      String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
      String userTeamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
      String userTeamName = StringUtil.checkNull(commandMap.get("sessionTeamName"));

      String managerID = StringUtil.checkNull(managerInfo.get("UserID"));
      String managerName = StringUtil.checkNull(managerInfo.get("MemberName"));
      String managerTeamID = StringUtil.checkNull(managerInfo.get("TeamID"));
      String managerTeamName = StringUtil.checkNull(managerInfo.get("TeamName"));

      if (!managerID.equals("")) {
        memberIDs = userID + "," + managerID;
        roleTypes = "AREQ,APRV";
        wfStepInfo = userName + "(" + userTeamName + ") >> " + managerName + "(" + managerTeamName + ")";
      } else {
        memberIDs = userID;
        roleTypes = "AREQ";
        wfStepInfo = userName + "(" + userTeamName + ")";
      }

      for (int i = 0; i < myItemMemberList.size(); i++) {
        itemMemberInfo = (Map)myItemMemberList.get(i);
        wfStepInfo = wfStepInfo + " >> " + StringUtil.checkNull(itemMemberInfo.get("WFStep"));
        memberIDs = memberIDs + "," + StringUtil.checkNull(itemMemberInfo.get("MemberID"));

        roleTypes = roleTypes + ",APRV";
      }

      target.put("SCRIPT", "fnSetWFStepInfo('" + wfStepInfo + "','" + memberIDs + "','" + roleTypes + "','','')");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }
  @RequestMapping({"/aprvByManager.do"})
  public String aprvByManager(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    try
    {
      HashMap setMap = new HashMap();
      String srID = StringUtil.checkNull(commandMap.get("srID"));
      String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));

      setMap.put("teamID", commandMap.get("sessionTeamId"));
      setMap.put("languageID", commandMap.get("sessionCurrLangType"));
      Map managerInfo = this.commonService.select("user_SQL.getUserTeamManagerInfo", setMap);

      if (managerInfo.isEmpty()) {
        String parentTeamID = this.commonService.selectString("user_SQL.getParentTeamID", setMap);
        setMap.put("teamID", parentTeamID);
        managerInfo = this.commonService.select("user_SQL.getUserTeamManagerInfo", setMap);
      }

      String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
      String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
      String userTeamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
      String userTeamName = StringUtil.checkNull(commandMap.get("sessionTeamName"));

      String managerID = StringUtil.checkNull(managerInfo.get("UserID"));
      String managerName = StringUtil.checkNull(managerInfo.get("MemberName"));
      String managerTeamID = StringUtil.checkNull(managerInfo.get("TeamID"));
      String managerTeamName = StringUtil.checkNull(managerInfo.get("TeamName"));

      String memberIDs = userID + "," + managerID;
      String roleTypes = "AREQ,APRV";
      String wfStepInfo = userName + "(" + userTeamName + ") >> " + managerName + "(" + managerTeamName + ")";
      if (managerID.equals("")) {
        memberIDs = userID;
        roleTypes = "AREQ";
        wfStepInfo = userName + "(" + userTeamName + ")";
      }

      target.put("SCRIPT", "fnSetWFStepInfo('" + wfStepInfo + "','" + memberIDs + "','" + roleTypes + "','','')");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }
  @RequestMapping({"/aprvBySysPmRole.do"})
  public String aprvBySysPmRole(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    try {
      HashMap setMap = new HashMap();
      String projectID = StringUtil.checkNull(commandMap.get("projectID"));

      setMap.put("teamID", commandMap.get("sessionTeamId"));
      setMap.put("languageID", commandMap.get("sessionCurrLangType"));
      Map managerInfo = this.commonService.select("user_SQL.getUserTeamManagerInfo", setMap);

      if ((managerInfo == null) || (managerInfo.isEmpty())) {
        String parentTeamID = this.commonService.selectString("user_SQL.getParentTeamID", setMap);
        setMap.put("teamID", parentTeamID);
        managerInfo = this.commonService.select("user_SQL.getUserTeamManagerInfo", setMap);
      }

      String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
      String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
      String userTeamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
      String userTeamName = StringUtil.checkNull(commandMap.get("sessionTeamName"));

      String managerID = StringUtil.checkNull(managerInfo.get("UserID"));
      String managerName = StringUtil.checkNull(managerInfo.get("MemberName"));
      String managerTeamID = StringUtil.checkNull(managerInfo.get("TeamID"));
      String managerTeamName = StringUtil.checkNull(managerInfo.get("TeamName"));

      setMap.put("projectID", projectID);
      Map pmInfo = this.commonService.select("project_SQL.getPjtAuthorInfo", setMap);

      String pmID = StringUtil.checkNull(pmInfo.get("AuthorID"));
      String pmName = StringUtil.checkNull(pmInfo.get("AuthorName"));
      String pmTeamName = StringUtil.checkNull(pmInfo.get("Name"));

      String memberIDs = userID + "," + managerID + "," + pmID;
      String roleTypes = "AREQ,APRV,APRV";
      String wfStepInfo = userName + "(" + userTeamName + ") >> " + managerName + "(" + managerTeamName + ") >>" + pmName + "(" + pmTeamName + ")";

      if (managerID.equals("")) {
        memberIDs = userID + "," + pmID;
        roleTypes = "AREQ,APRV";
        wfStepInfo = userName + "(" + userTeamName + ")>>" + pmName + "(" + pmTeamName + ")";
      }

      target.put("SCRIPT", "fnSetWFStepInfo('" + wfStepInfo + "','" + memberIDs + "','" + roleTypes + "','','')");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }
  @RequestMapping({"/aprvByOrgPath.do"})
  public String aprvByOrgPath(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    try
    {
      HashMap setMap = new HashMap();
      String srID = StringUtil.checkNull(commandMap.get("srID"));
      String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
      String limitType = "2";

      String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
      String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
      String userTeamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
      String userTeamName = StringUtil.checkNull(commandMap.get("sessionTeamName"));

      setMap.put("teamID", commandMap.get("sessionTeamId"));
      setMap.put("languageID", commandMap.get("sessionCurrLangType"));
      setMap.put("limitType", limitType);
      Map managerInfo = getTeamManagerInfo(StringUtil.checkNull(commandMap.get("sessionTeamId")), languageID, "", limitType);

      if (managerInfo.isEmpty()) {
        String parentTeamID = this.commonService.selectString("user_SQL.getParentTeamID", setMap);
        managerInfo = getTeamManagerInfo(parentTeamID, languageID, "", limitType);
      }

      String managerID = StringUtil.checkNull(managerInfo.get("UserID"));
      String managerName = StringUtil.checkNull(managerInfo.get("MemberName"));
      String managerTeamID = StringUtil.checkNull(managerInfo.get("TeamID"));
      String managerTeamName = StringUtil.checkNull(managerInfo.get("TeamName"));

      String memberIDs = userID + "," + managerID;
      String roleTypes = "AREQ,APRV";
      String wfStepInfo = userName + "(" + userTeamName + ") >> " + managerName + "(" + managerTeamName + ")";
      if (managerID.equals("")) {
        memberIDs = userID;
        roleTypes = "AREQ";
        wfStepInfo = userName + "(" + userTeamName + ")";
      }

      setMap.put("teamID", managerTeamID);
      String parentTeamID = StringUtil.checkNull(this.commonService.selectString("user_SQL.getParentTeamID", setMap), "");

      while (!"".equals(parentTeamID))
      {
        managerInfo = getTeamManagerInfo(parentTeamID, languageID, "", limitType);

        managerID = StringUtil.checkNull(managerInfo.get("UserID"));
        managerName = StringUtil.checkNull(managerInfo.get("MemberName"));
        managerTeamID = StringUtil.checkNull(managerInfo.get("TeamID"));
        managerTeamName = StringUtil.checkNull(managerInfo.get("TeamName"));

        if (!managerID.equals("")) {
          memberIDs = memberIDs + "," + managerID;
          roleTypes = roleTypes + ",APRV";
          wfStepInfo = wfStepInfo + " >> " + managerName + "(" + managerTeamName + ")";
        }

        setMap.put("teamID", managerTeamID);
        parentTeamID = StringUtil.checkNull(this.commonService.selectString("user_SQL.getParentTeamID", setMap), "");
      }

      target.put("SCRIPT", "fnSetWFStepInfo('" + wfStepInfo + "','" + memberIDs + "','" + roleTypes + "','','')");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  private Map getTeamManagerInfo(String teamID, String languageID, String teamType, String limitType) throws Exception {
    HashMap setMap = new HashMap();

    setMap.put("teamID", teamID);
    setMap.put("languageID", languageID);
    setMap.put("teamType", teamType);
    setMap.put("limitType", limitType);
    Map resultMap = this.commonService.select("user_SQL.getUserTeamManagerInfo", setMap);

    return resultMap;
  }

  private Map aprvBySysPmRole(String projectID, String languageID, HashMap commandMap)
    throws Exception
  {
    Map resultMap = new HashMap();
    HashMap setMap = new HashMap();
    setMap.put("teamID", commandMap.get("sessionTeamId"));
    setMap.put("languageID", commandMap.get("sessionCurrLangType"));
    Map managerInfo = this.commonService.select("user_SQL.getUserTeamManagerInfo", setMap);

    if ((managerInfo == null) || (managerInfo.isEmpty())) {
      String parentTeamID = this.commonService.selectString("user_SQL.getParentTeamID", setMap);
      setMap.put("teamID", parentTeamID);
      managerInfo = this.commonService.select("user_SQL.getUserTeamManagerInfo", setMap);
    }

    String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
    String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
    String userTeamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
    String userTeamName = StringUtil.checkNull(commandMap.get("sessionTeamName"));

    if ((managerInfo == null) || (managerInfo.isEmpty())) {
      resultMap.put("noManager", "Y");
    }

    String managerID = StringUtil.checkNull(managerInfo.get("UserID"));
    String managerName = StringUtil.checkNull(managerInfo.get("MemberName"));
    String managerTeamID = StringUtil.checkNull(managerInfo.get("TeamID"));
    String managerTeamName = StringUtil.checkNull(managerInfo.get("TeamName"));

    setMap.put("projectID", projectID);
    Map pmInfo = this.commonService.select("project_SQL.getPjtAuthorInfo", setMap);

    String pmID = StringUtil.checkNull(pmInfo.get("AuthorID"));
    String pmName = StringUtil.checkNull(pmInfo.get("AuthorName"));
    String pmTeamName = StringUtil.checkNull(pmInfo.get("Name"));

    String memberIDs = userID + "," + managerID + "," + pmID;
    String roleTypes = "AREQ,APRV,APRV";
    String wfStepInfo = userName + "(" + userTeamName + ") >> " + managerName + "(" + managerTeamName + ") >>" + pmName + "(" + pmTeamName + ")";

    if (managerID.equals("")) {
      memberIDs = userID + "," + pmID;
      roleTypes = "AREQ,APRV";
      wfStepInfo = userName + "(" + userTeamName + ")>>" + pmName + "(" + pmTeamName + ")";
    }

    resultMap.put("memberIDs", memberIDs);
    resultMap.put("roleTypes", roleTypes);
    resultMap.put("wfStepInfo", wfStepInfo);

    return resultMap;
  }

  @RequestMapping({"/submitOLMWfInst.do"})
  public String submitOLMWfInst(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    try {
      HashMap setData = new HashMap();
      HashMap setMap = new HashMap();
      HashMap inserWFInstTxtData = new HashMap();
      HashMap insertWFStepData = new HashMap();
      HashMap insertWFStepRefData = new HashMap();
      HashMap insertWFStepRecData = new HashMap();
      HashMap insertWFInstData = new HashMap();
      HashMap updateData = new HashMap();
      HashMap updateCRData = new HashMap();
      HashMap setMailData = new HashMap();

      String wfInstanceID = StringUtil.checkNull(commandMap.get("wfInstanceID"));
      String projectID = StringUtil.checkNull(commandMap.get("projectID"));
      String documentID = StringUtil.checkNull(commandMap.get("documentID"));
      String wfID = StringUtil.checkNull(commandMap.get("wfID"));
      String srID = StringUtil.checkNull(commandMap.get("srID"));
      String speCode = StringUtil.checkNull(commandMap.get("speCode"));
      String blockSR = StringUtil.checkNull(commandMap.get("blockSR"));
      String loginUser = StringUtil.checkNull(commandMap.get("sessionUserId"));
      String creatorTeamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
      String aprvOption = StringUtil.checkNull(commandMap.get("aprvOption"));
      String wfDocType = StringUtil.checkNull(commandMap.get("wfDocType"), "CSR");
      String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
      String Status = StringUtil.checkNull(commandMap.get("Status"));
      String description = StringUtil.checkNull(commandMap.get("description"));
      String subject = StringUtil.checkNull(commandMap.get("subject"));
      String isMulti = StringUtil.checkNull(commandMap.get("isMulti"));
      String wfDocumentIDs = StringUtil.checkNull(commandMap.get("wfDocumentIDs"));
      String emailType = "CSRAPREQ";
      String mailSubject = "";

      String getWfStepMemberIDs = StringUtil.checkNull(commandMap.get("wfStepMemberIDs"));
      String getWfStepRoleTypes = StringUtil.checkNull(commandMap.get("wfStepRoleTypes"));
      String getWfStepRefMemberIDs = StringUtil.checkNull(commandMap.get("wfStepRefMemberIDs"));
      String getWfStepRecMemberIDs = StringUtil.checkNull(commandMap.get("wfStepRecMemberIDs"));
      String getWfStepRecTeamIDs = StringUtil.checkNull(commandMap.get("wfStepRecTeamIDs"));

      String[] wfStepMemberIDs = null;
      String[] wfStepRoleTypes = null;
      String[] wfStepRefMemberIDs = null;
      String[] wfStepRecMemberIDs = null;
      String[] wfStepRecTeamIDs = null;
      String[] wfStepSeq = null;

      if (!getWfStepMemberIDs.isEmpty()) wfStepMemberIDs = getWfStepMemberIDs.split(",");
      if (!getWfStepRoleTypes.isEmpty()) { wfStepRoleTypes = getWfStepRoleTypes.split(","); wfStepSeq = getWfStepRoleTypes.split(","); }
      if (!getWfStepRefMemberIDs.isEmpty()) wfStepRefMemberIDs = getWfStepRefMemberIDs.split(",");
      if (!getWfStepRecMemberIDs.isEmpty()) wfStepRecMemberIDs = getWfStepRecMemberIDs.split(",");
      if (!getWfStepRecTeamIDs.isEmpty()) wfStepRecTeamIDs = getWfStepRecTeamIDs.split(",");

      if ("".equals(wfID)) {
        wfID = StringUtil.checkNull(commandMap.get("wfID2"));
      }
      if (wfID.indexOf("(") > 0) {
        wfID = wfID.substring(0, wfID.indexOf("("));
      }

      setData.put("wfID", wfID);
      String newWFInstanceID = "";

      String maxWFInstanceID = this.commonService.selectString("wf_SQL.MaxWFInstanceID", setData);
      String OLM_SERVER_NAME = GlobalVal.OLM_SERVER_NAME;
      int OLM_SERVER_NAME_LENGTH = GlobalVal.OLM_SERVER_NAME.length();
      String initLen = "%0" + (13 - OLM_SERVER_NAME_LENGTH) + "d";

      int maxWFInstanceID2 = Integer.parseInt(maxWFInstanceID.substring(OLM_SERVER_NAME_LENGTH));
      int maxcode = maxWFInstanceID2 + 1;
      newWFInstanceID = OLM_SERVER_NAME + String.format(initLen, new Object[] { Integer.valueOf(maxcode) });

      if ((wfInstanceID != null) && (!"".equals(wfInstanceID))) {
        newWFInstanceID = wfInstanceID;
      }
      String agrSeq = StringUtil.checkNull(this.commonService.selectString("wf_SQL.getAgrSeq", setData), "");

      int agrCnt = -1;
      int rewCnt = -1;
      int idx = 0;

      for (int j = 0; j < wfStepRoleTypes.length; j++)
      {
        if (("PAGR".equals(wfStepRoleTypes[j])) && (agrCnt > 0)) {
          wfStepSeq[j] = StringUtil.checkNull(Integer.valueOf(idx));

          if ((j + 1 <= wfStepRoleTypes.length) && (!"PAGR".equals(wfStepRoleTypes[(j + 1)])))
            idx++;
        }
        else if (("PAGR".equals(wfStepRoleTypes[j])) && (agrCnt == -1)) {
          wfStepSeq[j] = StringUtil.checkNull(Integer.valueOf(idx));
          agrCnt = 1;

          if ((j + 1 <= wfStepRoleTypes.length) && (!"PAGR".equals(wfStepRoleTypes[(j + 1)])))
            idx++;
        }
        else if ("REW".equals(wfStepRoleTypes[j])) {
          wfStepSeq[j] = StringUtil.checkNull(Integer.valueOf(idx));

          if ((j + 1 <= wfStepRoleTypes.length) && (!"REW".equals(wfStepRoleTypes[(j + 1)])))
            idx++;
        }
        else if ("MGT".equals(wfStepRoleTypes[j])) {
          wfStepSeq[j] = "1";
        } else if (j == 0) {
          wfStepSeq[j] = "0";
          idx++;
        } else {
          wfStepSeq[j] = StringUtil.checkNull(Integer.valueOf(idx));
          idx++;
        }

      }

      int lastSeq = idx - 1;

      setData.put("wfInstanceID", wfInstanceID);
      this.commonService.delete("wf_SQL.deleteWFInstTxt", setData);

      insertWFInstData.put("WFInstanceID", newWFInstanceID);
      insertWFInstData.put("ProjectID", projectID);
      insertWFInstData.put("DocumentID", documentID);
      insertWFInstData.put("DocCategory", wfDocType);
      insertWFInstData.put("WFID", wfID);
      insertWFInstData.put("Creator", loginUser);
      insertWFInstData.put("LastUser", loginUser);
      insertWFInstData.put("Status", "1");
      insertWFInstData.put("aprvOption", aprvOption);
      insertWFInstData.put("curSeq", "1");
      insertWFInstData.put("LastSigner", loginUser);
      insertWFInstData.put("lastSeq", Integer.valueOf(lastSeq));
      insertWFInstData.put("creatorTeamID", creatorTeamID);

      this.commonService.insert("wf_SQL.insertToWfInst", insertWFInstData);

      String maxId = "";
      int seqIndex = 0;
      int PreSeqIndex = 0;
      if (!getWfStepMemberIDs.isEmpty()) {
        for (int i = 0; i < wfStepMemberIDs.length; i++)
        {
          String status = null;

          insertWFStepData.put("Seq", wfStepSeq[i]);
          maxId = this.commonService.selectString("wf_SQL.getMaxStepInstID", setData);

          insertWFStepData.put("StepInstID", Integer.valueOf(Integer.parseInt(maxId) + 1));
          insertWFStepData.put("ProjectID", projectID);

          if (i == 0) status = "1";
          else if (wfStepSeq[i].equals("1")) status = "0";
          insertWFStepData.put("Status", status);
          insertWFStepData.put("ActorID", wfStepMemberIDs[i]);
          insertWFStepData.put("WFID", wfID);
          insertWFStepData.put("WFStepID", wfStepRoleTypes[i]);
          if (wfInstanceID.isEmpty()) insertWFStepData.put("WFInstanceID", newWFInstanceID);
          this.commonService.insert("wf_SQL.insertWfStepInst", insertWFStepData);
        }

      }

      if ((getWfStepRefMemberIDs != null) && (!getWfStepRefMemberIDs.isEmpty())) {
        for (int j = 0; j < wfStepRefMemberIDs.length; j++) {
          maxId = this.commonService.selectString("wf_SQL.getMaxStepInstID", setData);
          insertWFStepRefData.put("StepInstID", Integer.valueOf(Integer.parseInt(maxId) + 1));
          insertWFStepRefData.put("ProjectID", projectID);
          insertWFStepRefData.put("Seq", "0");

          insertWFStepRefData.put("ActorID", wfStepRefMemberIDs[j]);
          insertWFStepRefData.put("WFID", wfID);
          insertWFStepRefData.put("WFStepID", "REF");
          if (wfInstanceID.isEmpty()) insertWFStepRefData.put("WFInstanceID", newWFInstanceID);
          this.commonService.insert("wf_SQL.insertWfStepInst", insertWFStepRefData);
        }

      }

      if ((getWfStepRecMemberIDs != null) && (!getWfStepRecMemberIDs.isEmpty())) {
        for (int j = 0; j < wfStepRecMemberIDs.length; j++) {
          maxId = this.commonService.selectString("wf_SQL.getMaxStepInstID", setData);
          insertWFStepRecData.put("StepInstID", Integer.valueOf(Integer.parseInt(maxId) + 1));
          insertWFStepRecData.put("ProjectID", projectID);
          insertWFStepRecData.put("Seq", "0");
          insertWFStepRecData.put("ActorID", wfStepRecMemberIDs[j]);
          insertWFStepRecData.put("WFID", wfID);
          insertWFStepRecData.put("WFStepID", "REC");
          if (wfInstanceID.isEmpty()) insertWFStepRecData.put("WFInstanceID", newWFInstanceID);
          this.commonService.insert("wf_SQL.insertWfStepInst", insertWFStepRecData);
        }

      }

      if ((getWfStepRecTeamIDs != null) && (!getWfStepRecTeamIDs.isEmpty())) {
        insertWFStepRecData.remove("ActorID");
        for (int j = 0; j < wfStepRecTeamIDs.length; j++) {
          maxId = this.commonService.selectString("wf_SQL.getMaxStepInstID", setData);
          insertWFStepRecData.put("StepInstID", Integer.valueOf(Integer.parseInt(maxId) + 1));
          insertWFStepRecData.put("ProjectID", projectID);
          insertWFStepRecData.put("Seq", "0");
          insertWFStepRecData.put("ActorTeamID", wfStepRecTeamIDs[j]);
          insertWFStepRecData.put("WFID", wfID);
          insertWFStepRecData.put("WFStepID", "REC");
          if (wfInstanceID.isEmpty()) insertWFStepRecData.put("WFInstanceID", newWFInstanceID);
          this.commonService.insert("wf_SQL.insertWfStepInst", insertWFStepRecData);
        }
      }

      inserWFInstTxtData.put("WFInstanceID", newWFInstanceID);
      inserWFInstTxtData.put("subject", subject);
      inserWFInstTxtData.put("subjectEN", subject);
      inserWFInstTxtData.put("description", description);
      inserWFInstTxtData.put("descriptionEN", description);
      inserWFInstTxtData.put("comment", "");
      inserWFInstTxtData.put("actorID", loginUser);
      this.commonService.insert("wf_SQL.insertWfInstTxt", inserWFInstTxtData);

      setMap.put("s_itemID", projectID);

      updateData = new HashMap();
      setMap.put("srID", srID);
      setMap.put("aprvOption", aprvOption);
      setMap.put("projectID", projectID);
      if (Status.equals("CNG")) {
        updateData.put("Status", "APRV2");

        Map setProcMapRst = setProcLog(request, this.commonService, setMap);
        if (setProcMapRst.get("type").equals("FAILE")) {
          String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
          System.out.println("Msg : " + Msg);
        }
      } else {
        updateData.put("Status", "APRV2");
      }
      updateData.put("ProjectID", projectID);

      updateCRData = new HashMap();
      HashMap updateSR = new HashMap();

      if (Status.equals("CNG")) {
        updateCRData.put("status", "RFC");
        updateCRData.put("ITSMIF", "0");
      } else {
        updateCRData.put("status", "APRV");
      }
      updateCRData.put("lastUser", loginUser);

      if ((wfDocType.equals("CSR")) || (wfDocType.equals("PJT")))
      {
        updateData.put("CurWFInstanceID", newWFInstanceID);

        this.commonService.update("project_SQL.updateProject", updateData);
        updateCRData.put("CSRID", projectID);

        if (!srID.equals("")) {
          updateSR.put("srID", srID);
          updateSR.put("status", "CNG");
          updateSR.put("lastUser", loginUser);
          updateSR.put("curWFInstanceID", newWFInstanceID);
          this.commonService.update("esm_SQL.updateESMSR", updateSR);
        }
        this.commonService.update("cr_SQL.updateCR", updateCRData);
      }
      else if (wfDocType.equals("SR")) {
        emailType = "SRAPREQ";
        updateSR.put("srID", documentID);
        updateSR.put("status", speCode);
        updateSR.put("lastUser", loginUser);
        updateSR.put("curWFInstanceID", newWFInstanceID);
        String blocked = "";
        if (blockSR.equals("Y")) blocked = "1";
        updateSR.put("blocked", blocked);
        this.commonService.update("esm_SQL.updateESMSR", updateSR);

        Map setProcMapRst = setProcLog(request, this.commonService, updateSR);
        if (setProcMapRst.get("type").equals("FAILE")) {
          String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
          System.out.println("Msg : " + Msg);
        }
      }
      else if (wfDocType.equals("CS")) {
        emailType = "APREQ_CS";

        updateCRData.put("Status", "APRV");

        if (isMulti.equals("Y")) {
          String[] ids = wfDocumentIDs.split(",");
          for (int i = 0; i < ids.length; i++) {
            updateCRData.put("s_itemID", ids[i]);
            updateCRData.put("wfInstanceID", newWFInstanceID);
            this.commonService.update("cs_SQL.updateChangeSet", updateCRData);
          }
        }
        else {
          updateCRData.put("s_itemID", documentID);
          updateCRData.put("wfInstanceID", newWFInstanceID);
          this.commonService.update("cs_SQL.updateChangeSet", updateCRData);
        }

      }

      setMap.put("languageID", languageID);
      setMap.put("wfInstanceID", newWFInstanceID);
      setMap.put("nextSeq", "1");

      List receiverList = new ArrayList();
      List refList = new ArrayList();

      List temp1 = this.commonService.selectList("wf_SQL.getWFStepMailList", setMap);
      int j = 0;

      String emailStepInstID = "";
      String emailStepSeq = "";
      String emailActorID = "";
      for (int i = 0; i < temp1.size(); i++) {
        Map tempMap = (Map)temp1.get(i);
        Map tempMap2 = new HashMap();

        tempMap2.put("receiptUserID", tempMap.get("ActorID"));
        receiverList.add(j++, tempMap2);
        emailStepInstID = StringUtil.checkNull(tempMap.get("StepInstID"));
        emailStepSeq = StringUtil.checkNull(tempMap.get("Seq"));
        emailActorID = StringUtil.checkNull(tempMap.get("ActorID"));
      }

      mailSubject = subject;
      setMailData.put("receiverList", receiverList);
      setMailData.put("LanguageID", languageID);
      setMailData.put("subject", mailSubject);
      commandMap.put("wfInstanceID", newWFInstanceID);
      commandMap.put("emailCode", emailType);

      Map setMailMap = setEmailLog(request, this.commonService, setMailData, emailType);
      if (StringUtil.checkNull(setMailMap.get("type")).equals("SUCESS")) {
        HashMap mailMap = (HashMap)setMailMap.get("mailLog");

        ModelMap mailModel = getApprovalMailForm(request, commandMap, model);
        mailModel.put("LanguageID", languageID);
        mailMap.put("refList", refList);

        mailModel.put("stepInstID", emailStepInstID);
        mailModel.put("stepSeq", emailStepSeq);
        mailModel.put("lastSeq", StringUtil.checkNull(insertWFInstData.get("lastSeq")));
        mailModel.put("actorID", emailActorID);

        Map resultMailMap = EmailUtil.sendMail(mailMap, mailModel, getLabel(request, this.commonService));
        System.out.println("SEND EMAIL TYPE:" + resultMailMap + ", Msg:" + StringUtil.checkNull(setMailMap.get("type")));
      } else {
        System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : " + StringUtil.checkNull(setMailMap.get("msg")));
      }

      setMap.remove("nextSeq");
      receiverList.clear();
      j = 0;
      setMap.remove("wfStepIDs");
      setMap.put("wfStepID", "REF");
      temp1 = this.commonService.selectList("wf_SQL.getWFStepMailList", setMap);
      for (int i = 0; i < temp1.size(); i++) {
        Map tempMap = (Map)temp1.get(i);
        Map tempMap2 = new HashMap();
        String WFStepID = (String)tempMap.get("WFStepID");
        if ("REF".equals(WFStepID)) {
          tempMap2.put("receiptUserID", tempMap.get("ActorID"));
          receiverList.add(j++, tempMap2);
        }

      }

      setMailData.put("receiverList", receiverList);
      setMailMap = setEmailLog(request, this.commonService, setMailData, "APRVREF");
      if (StringUtil.checkNull(setMailMap.get("type")).equals("SUCESS")) {
        HashMap mailMap = (HashMap)setMailMap.get("mailLog");

        ModelMap mailModel = getApprovalMailForm(request, commandMap, model);
        mailModel.put("LanguageID", languageID);
        mailMap.put("refList", refList);

        Map resultMailMap = EmailUtil.sendMail(mailMap, mailModel, getLabel(request, this.commonService));
        System.out.println("SEND EMAIL TYPE:" + resultMailMap + ", Msg:" + StringUtil.checkNull(setMailMap.get("type")));
      } else {
        System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : " + StringUtil.checkNull(setMailMap.get("msg")));
      }

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00150"));
      target.put("SCRIPT", "parent.fnCallBackSubmit();parent.$('#isSubmit').remove();");
    }
    catch (Exception e)
    {
      System.out.println(e.toString());
      target.put("SCRIPT", "parent.$('#isSubmit').remove();");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }

    model.addAttribute("resultMap", target);

    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  @RequestMapping({"/openApprTransferPop.do"})
  public String openApprTransferPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception
  {
    Map setMap = new HashMap();
    try {
      String projectID = StringUtil.checkNull(commandMap.get("projectID"));
      String wfID = StringUtil.checkNull(commandMap.get("wfID"));
      String loginUser = StringUtil.checkNull(commandMap.get("sessionUserId"));
      String wfInstanceID = StringUtil.checkNull(commandMap.get("wfInstanceID"));
      String stepInstID = StringUtil.checkNull(commandMap.get("stepInstID"));
      String actorID = StringUtil.checkNull(commandMap.get("actorID"));
      String stepSeq = StringUtil.checkNull(commandMap.get("stepSeq"));
      String wfStepInstStatus = StringUtil.checkNull(commandMap.get("wfStepInstStatus"));
      setMap.put("languageID", commandMap.get("sessionCurrLangType"));
      setMap.put("WFID", wfID);
      String MandatoryGRID = this.commonService.selectString("wf_SQL.getMandatoryGRID", setMap);
      model.put("MandatoryGRID", MandatoryGRID);

      model.put("menu", getLabel(request, this.commonService));
      model.put("projectID", projectID);
      model.put("wfID", wfID);
      model.put("stepInstID", stepInstID);
      model.put("actorID", actorID);
      model.put("stepSeq", stepSeq);
      model.put("wfInstanceID", wfInstanceID);
      model.put("wfStepInstStatus", wfStepInstStatus);
    }
    catch (Exception e) {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }
    return nextUrl("/wf/approvalTransfer");
  }

  @RequestMapping({"/afterSubmitCheck.do"})
  public String afterSubmitCheck(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    Map setMap = new HashMap();
    List wfInstList = new ArrayList();
    try
    {
      String wfStepMemberID = StringUtil.checkNull(commandMap.get("wfStepMemberIDs"));
      String wfStepRefMemberID = StringUtil.checkNull(commandMap.get("wfStepRefMemberIDs"));
      String wfStepRecMemberID = StringUtil.checkNull(commandMap.get("wfStepRecMemberIDs"));
      String wfStepRecTeamID = StringUtil.checkNull(commandMap.get("wfStepRecTeamIDs"));
      String wfStepRoleType = StringUtil.checkNull(commandMap.get("wfStepRoleTypes"));
      String endGRID = StringUtil.checkNull(commandMap.get("endGRID"));

      String[] wfStepMemberIDs = null;
      String[] wfStepRefMemberIDs = null;
      String[] wfStepRecMemberIDs = null;
      String[] wfStepRecTeamIDs = null;
      String[] wfStepRoleTypes = null;

      if (!wfStepMemberID.isEmpty()) wfStepMemberIDs = wfStepMemberID.split(",");
      if (!wfStepRoleType.isEmpty()) wfStepRoleTypes = wfStepRoleType.split(",");
      if (!wfStepRefMemberID.isEmpty()) wfStepRefMemberIDs = wfStepRefMemberID.split(",");
      if (!wfStepRecMemberID.isEmpty()) wfStepRecMemberIDs = wfStepRecMemberID.split(",");
      if (!wfStepRecTeamID.isEmpty()) wfStepRecTeamIDs = wfStepRecTeamID.split(",");

      if (!wfStepMemberID.isEmpty())
      {
        for (int i = 0; i < wfStepMemberIDs.length; i++) {
          if ((!wfStepRoleTypes[i].equals("MGT")) && (!wfStepRoleTypes[i].equals("REF"))) {
            Map temp3 = new HashMap();

            setMap.put("memberID", wfStepMemberIDs[i]);
            setMap.put("languageID", commandMap.get("sessionCurrLangType"));
            Map temp = this.commonService.select("user_SQL.getMemberInfo", setMap);
            temp3.put("ActorName", temp.get("Name"));
            temp3.put("TeamName", temp.get("TeamName"));

            setMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
            setMap.put("Category", "WFSTEP");
            setMap.put("TypeCode", wfStepRoleTypes[i]);

            Map temp2 = this.commonService.select("common_SQL.label_commonSelect", setMap);

            temp3.put("WFStepName", temp2.get("LABEL_NM"));
            wfInstList.add(temp3);
          }
        }

        if (!"".equals(endGRID)) {
          Map temp3 = new HashMap();

          setMap.put("memberID", endGRID);
          setMap.put("languageID", commandMap.get("sessionCurrLangType"));
          Map temp = this.commonService.select("user_SQL.getMemberInfo", setMap);
          temp3.put("ActorName", temp.get("Name"));
          temp3.put("TeamName", temp.get("TeamName"));

          setMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
          setMap.put("Category", "WFSTEP");
          setMap.put("TypeCode", "APRV");

          Map temp2 = this.commonService.select("common_SQL.label_commonSelect", setMap);

          temp3.put("WFStepName", temp2.get("LABEL_NM"));
          wfInstList.add(temp3);
        }
      }

      if ((wfStepRefMemberID != null) && (!wfStepRefMemberID.isEmpty())) {
        for (int i = 0; i < wfStepRefMemberIDs.length; i++) {
          Map temp3 = new HashMap();

          setMap.put("memberID", wfStepRefMemberIDs[i]);
          setMap.put("languageID", commandMap.get("sessionCurrLangType"));
          Map temp = this.commonService.select("user_SQL.getMemberInfo", setMap);
          temp3.put("ActorName", temp.get("Name"));
          temp3.put("TeamName", temp.get("TeamName"));

          setMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
          setMap.put("Category", "WFSTEP");
          setMap.put("TypeCode", "REF");

          Map temp2 = this.commonService.select("common_SQL.label_commonSelect", setMap);

          temp3.put("WFStepName", temp2.get("LABEL_NM"));
          wfInstList.add(temp3);
        }

      }

      if ((wfStepRecMemberID != null) && (!wfStepRecMemberID.isEmpty())) {
        for (int i = 0; i < wfStepRecMemberIDs.length; i++) {
          Map temp3 = new HashMap();

          setMap.put("memberID", wfStepRecMemberIDs[i]);
          setMap.put("languageID", commandMap.get("sessionCurrLangType"));
          Map temp = this.commonService.select("user_SQL.getMemberInfo", setMap);
          temp3.put("ActorName", temp.get("Name"));
          temp3.put("TeamName", temp.get("TeamName"));

          setMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
          setMap.put("Category", "WFSTEP");
          setMap.put("TypeCode", "REC");

          Map temp2 = this.commonService.select("common_SQL.label_commonSelect", setMap);

          temp3.put("WFStepName", temp2.get("LABEL_NM"));
          wfInstList.add(temp3);
        }
      }

      if ((wfStepRecTeamID != null) && (!wfStepRecTeamID.isEmpty())) {
        for (int i = 0; i < wfStepRecTeamIDs.length; i++) {
          Map temp3 = new HashMap();

          setMap.put("teamID", wfStepRecTeamIDs[i]);
          setMap.put("languageID", commandMap.get("sessionCurrLangType"));
          String temp = this.commonService.selectString("organization_SQL.getTeamName", setMap);
          temp3.put("ActorName", temp);
          temp3.put("TeamName", temp);

          setMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
          setMap.put("Category", "WFSTEP");
          setMap.put("TypeCode", "REC");

          Map temp2 = this.commonService.select("common_SQL.label_commonSelect", setMap);

          temp3.put("WFStepName", temp2.get("LABEL_NM"));
          wfInstList.add(temp3);
        }

      }

      model.put("wfInstList", wfInstList);
      model.put("menu", getLabel(request, this.commonService));
    }
    catch (Exception e) {
      System.out.println(e.toString());
      throw new ExceptionUtil(e.toString());
    }
    return nextUrl("/wf/afterSubmitCheckPop");
  }

  @RequestMapping({"/changeApprActor.do"})
  public String changeApprActor(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception
  {
    Map setMap = new HashMap();
    Map target = new HashMap();
    try {
      String stepInstID = StringUtil.checkNull(commandMap.get("stepInstID"));
      String wfREL = StringUtil.checkNull(commandMap.get("wfREL"));
      String wfInstanceID = StringUtil.checkNull(commandMap.get("wfInstanceID"));
      String actorTeamID = this.commonService.selectString("user_SQL.userTeamID", commandMap);
      String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));

      setMap.put("stepInstID", stepInstID);
      setMap.put("actorID", wfREL);
      setMap.put("actorTeamID", actorTeamID);

      this.commonService.update("wf_SQL.changeActor", setMap);

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
      target.put("SCRIPT", "parent.fnCallBackSubmit();this.$('#isSubmit').remove();parent.$('#isSubmit').remove();");

      HashMap setMailData = new HashMap();
      setMap.put("wfInstanceID", wfInstanceID);
      String projectID = this.commonService.selectString("wf_SQL.getProjectID", setMap);
      setMap.put("s_itemID", projectID);
      setMap.put("languageID", languageID);

      setMailData = (HashMap)this.commonService.select("project_SQL.getProjectInfo", setMap);
      setMailData.put("subject", setMailData.get("ProjectName"));

      List receiverList = new ArrayList();

      Map tempMap = new HashMap();
      tempMap.put("receiptUserID", wfREL);
      receiverList.add(tempMap);

      setMailData.put("receiverList", receiverList);
      setMailData.put("LanguageID", languageID);

      Map setMailMap = setEmailLog(request, this.commonService, setMailData, "CSRAPREQ");

      if (StringUtil.checkNull(setMailMap.get("type")).equals("SUCESS")) {
        HashMap mailMap = (HashMap)setMailMap.get("mailLog");

        ModelMap MailModel = getApprovalMailForm(request, commandMap, model);
        MailModel.put("receiverList", receiverList);
        MailModel.put("LanguageID", languageID);

        Map resultMailMap = EmailUtil.sendMail(mailMap, MailModel, getLabel(request, this.commonService));
        System.out.println("SEND EMAIL TYPE:" + resultMailMap + ", Msg:" + StringUtil.checkNull(setMailMap.get("type")));
      } else {
        System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : " + StringUtil.checkNull(setMailMap.get("msg")));
      }
    }
    catch (Exception e) {
      target.put("SCRIPT", "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }
  @RequestMapping({"/wfInstanceList.do"})
  public String wfInstanceList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    Map setMap = new HashMap();
    try {
      String wfMode = StringUtil.checkNull(commandMap.get("wfMode"));
      String wfStepID = StringUtil.checkNull(commandMap.get("wfStepID"));
      String projectID = StringUtil.checkNull(commandMap.get("projectID"));
      String screenType = StringUtil.checkNull(commandMap.get("screenType"));
      String filter = StringUtil.checkNull(commandMap.get("filter"), "myWF");

      model.put("menu", getLabel(request, this.commonService));
      String menuNum = "";
      String title = "";
      if (wfMode.equals("AREQ"))
        title = StringUtil.checkNull(getLabel(request, this.commonService).get("LN00211"));
      else if (wfMode.equals("CurAprv"))
        title = StringUtil.checkNull(getLabel(request, this.commonService).get("LN00243"));
      else if (wfMode.equals("ToDoAprv"))
        title = StringUtil.checkNull(getLabel(request, this.commonService).get("LN00244"));
      else if (wfMode.equals("RefMgt"))
        title = StringUtil.checkNull(getLabel(request, this.commonService).get("LN00245"));
      else if (wfMode.equals("Cls")) {
        title = StringUtil.checkNull(getLabel(request, this.commonService).get("LN00118"));
      }

      Calendar cal = Calendar.getInstance();
      cal.setTime(new Date(System.currentTimeMillis()));
      String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());

      cal.add(5, -7);
      String beforeYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());

      setMap.put("DocCategory", "CS");
      setMap.put("languageID", commandMap.get("sessionCurrLangType"));
      String wfURL = StringUtil.checkNull(this.commonService.selectString("wf_SQL.getWFCategoryURL", setMap));

      model.put("wfURL", wfURL);
      model.put("beforeYmd", beforeYmd);
      model.put("thisYmd", thisYmd);
      model.put("wfStepID", wfStepID);
      model.put("title", title);
      model.put("wfMode", wfMode);
      model.put("projectID", projectID);
      model.put("screenType", screenType);
      model.put("filter", filter);
    }
    catch (Exception e) {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }
    return nextUrl("/wf/wfInstanceList");
  }

  public ModelMap getApprovalMailForm(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    Map setMap = new HashMap();
    List attachFileList = new ArrayList();
    List wfInstList = new ArrayList();
    List wfRefInstList = new ArrayList();
    try {
      String projectID = StringUtil.checkNull(commandMap.get("projectID"));
      String wfID = StringUtil.checkNull(commandMap.get("wfID"));
      String stepInstID = StringUtil.checkNull(commandMap.get("stepInstID"));
      String documentID = StringUtil.checkNull(commandMap.get("documentID"));
      String wfInstanceID = StringUtil.checkNull(commandMap.get("wfInstanceID"));
      String lastSeq = StringUtil.checkNull(commandMap.get("lastSeq"));
      String actorID = StringUtil.checkNull(commandMap.get("actorID"));
      String stepSeq = StringUtil.checkNull(commandMap.get("stepSeq"));
      String loginUser = StringUtil.checkNull(commandMap.get("sessionUserId"));
      String srID = StringUtil.checkNull(commandMap.get("srID"));
      String wfDocType = StringUtil.checkNull(commandMap.get("wfDocType"));

      model.put("wfDocType", wfDocType);

      setMap.put("WFStepIDs", "'AREQ','APRV','AGR','PAGR','REW'");
      setMap.put("wfInstanceID", wfInstanceID);
      setMap.put("LanguageID", commandMap.get("sessionCurrLangType"));

      List wfStepInstList = this.commonService.selectList("wf_SQL.getWFStepInstInfoList", setMap);
      Map wfInstInfo = this.commonService.select("wf_SQL.getWFInstanceDetail_gridList", setMap);

      String Description = StringUtil.checkNull(wfInstInfo.get("Description"), "");
      Description = Description.replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\"");
      wfInstInfo.put("Description", Description);

      setMap.put("languageID", commandMap.get("sessionCurrLangType"));

      model.put("wfInstInfo", wfInstInfo);

      String wfStepInstInfo = "";
      String wfStepInstREFInfo = "";
      String wfStepInstRECInfo = "";
      String wfStepInstRELInfo = "";
      String wfStepInstAGRInfo = "";
      String afterSeq = "";
      Map wfStepInstInfoMap = new HashMap();
      if (wfStepInstList.size() > 0) {
        for (int i = 0; i < wfStepInstList.size(); i++) {
          wfStepInstInfoMap = (Map)wfStepInstList.get(i);
          if (i == 0) {
            wfStepInstInfo = wfStepInstInfoMap.get("ActorName") + "(" + wfStepInstInfoMap.get("WFStepName") + ")";
            afterSeq = wfStepInstInfoMap.get("Seq").toString();
          } else {
            if (wfStepInstInfoMap.get("Seq").equals(wfInstInfo.get("CurSeq"))) {
              if (afterSeq.equals(wfStepInstInfoMap.get("Seq").toString()))
                wfStepInstInfo = wfStepInstInfo + ", " + "<span style='color:blue;font-weight:bold'>" + wfStepInstInfoMap.get("ActorName") + "(" + wfStepInstInfoMap.get("WFStepName") + ") </span>";
              else {
                wfStepInstInfo = wfStepInstInfo + " >> " + "<span style='color:blue;font-weight:bold'>" + wfStepInstInfoMap.get("ActorName") + "(" + wfStepInstInfoMap.get("WFStepName") + ") </span>";
              }
            }
            else if (afterSeq.equals(wfStepInstInfoMap.get("Seq").toString()))
              wfStepInstInfo = wfStepInstInfo + ", " + wfStepInstInfoMap.get("ActorName") + "(" + wfStepInstInfoMap.get("WFStepName") + ")";
            else {
              wfStepInstInfo = wfStepInstInfo + " >> " + wfStepInstInfoMap.get("ActorName") + "(" + wfStepInstInfoMap.get("WFStepName") + ")";
            }
            afterSeq = wfStepInstInfoMap.get("Seq").toString();
          }
          if (actorID.equals(wfStepInstInfoMap.get("ActorID").toString())) {
            model.put("actorWFStepName", wfStepInstInfoMap.get("WFStepName"));
            String transYN = this.commonService.selectString("wf_SQL.getApprTransYN", wfStepInstInfoMap);
            model.put("transYN", transYN);
          }
        }
        model.put("wfStepInstInfo", wfStepInstInfo);
      }

      setMap.put("WFStepIDs", "'REF'");
      List wfStepInstREFList = this.commonService.selectList("wf_SQL.getWFStepInstInfoList", setMap);
      Map wfStepInstREFInfoMap = new HashMap();

      if (wfStepInstREFList.size() > 0) {
        for (int i = 0; i < wfStepInstREFList.size(); i++) {
          wfStepInstREFInfoMap = (Map)wfStepInstREFList.get(i);
          if (i == 0)
            wfStepInstREFInfo = StringUtil.checkNull(wfStepInstREFInfoMap.get("ActorName"));
          else {
            wfStepInstREFInfo = wfStepInstREFInfo + "," + wfStepInstREFInfoMap.get("ActorName");
          }
        }
        model.put("wfStepInstREFInfo", wfStepInstREFInfo);
      }

      setMap.put("WFStepIDs", "'MGT'");
      List wfStepInstRELList = this.commonService.selectList("wf_SQL.getWFStepInstInfoList", setMap);
      Map wfStepInstRELInfoMap = new HashMap();
      if (wfStepInstRELList.size() > 0) {
        for (int i = 0; i < wfStepInstRELList.size(); i++) {
          wfStepInstRELInfoMap = (Map)wfStepInstRELList.get(i);
          if (i == 0) {
            wfStepInstRELInfo = StringUtil.checkNull(wfStepInstRELInfoMap.get("ActorName"));
          }
          else if (loginUser.equals(wfStepInstRELInfoMap.get("ActorID"))) {
            wfStepInstRELInfo = wfStepInstRELInfo + "," + wfStepInstRELInfoMap.get("ActorName");
          }

          if (!actorID.equals(wfStepInstRELInfoMap.get("ActorID").toString()))
            continue;
          String transYN = this.commonService.selectString("wf_SQL.getApprTransYN", wfStepInstRELInfoMap);
          model.put("transYN", transYN);
        }

        model.put("wfStepInstRELInfo", wfStepInstRELInfo);
      }

      setMap.put("WFStepIDs", "'REC'");
      setMap.put("WFStepID", "REC");
      List wfStepInstRECList = this.commonService.selectList("wf_SQL.getWFStepInstInfoList", setMap);
      Map wfStepInstRECInfoMap = new HashMap();

      if (wfStepInstRECList.size() > 0) {
        for (int i = 0; i < wfStepInstRECList.size(); i++) {
          wfStepInstRECInfoMap = (Map)wfStepInstRECList.get(i);
          if (i == 0)
            wfStepInstRECInfo = StringUtil.checkNull(wfStepInstRECInfoMap.get("ActorName"));
          else {
            wfStepInstRECInfo = wfStepInstRECInfo + "," + wfStepInstRECInfoMap.get("ActorName");
          }
        }
        model.put("wfStepInstRECInfo", wfStepInstRECInfo);
      }

      setMap.put("languageID", commandMap.get("sessionCurrLangType"));
      setMap.put("s_itemID", projectID);
      Map getPJTMap = new HashMap();

      setMap.put("itemID", null);
      setMap.put("DocCategory", wfInstInfo.get("DocCategory"));
      setMap.put("DocumentID", commandMap.get("DocumentID"));

      if (wfInstInfo.get("DocCategory").equals("CSR")) {
        getPJTMap = this.commonService.select("project_SQL.getProjectInfo", setMap);

        attachFileList = this.commonService.selectList("project_SQL.getPjtFileList", setMap);
      }
      else if (wfInstInfo.get("DocCategory").equals("PJT")) {
        getPJTMap = this.commonService.select("project_SQL.getProjectInfo", setMap);

        attachFileList = this.commonService.selectList("project_SQL.getPjtFileList", setMap);
      }
      else if (wfInstInfo.get("DocCategory").equals("SR"))
      {
        Map getSRInfoMap = new HashMap();
        setMap.put("srID", documentID);
        if (documentID.equals("")) setMap.put("srID", srID);

        getSRInfoMap = this.commonService.select("esm_SQL.getESMSRInfo", setMap);
        attachFileList = this.commonService.selectList("project_SQL.getPjtFileList", setMap);
        model.put("getSRInfoMap", getSRInfoMap);
      }
      else if (wfInstInfo.get("DocCategory").equals("CS")) {
        setMap.put("s_itemID", null);

        getPJTMap = this.commonService.select("wf_SQL.getWFInstDetail", setMap);

        setMap.put("languageID", commandMap.get("sessionCurrLangType"));
        List csInstList = this.commonService.selectList("cs_SQL.getChangeSetList_gridList", setMap);
        model.put("csInstList", csInstList);

        attachFileList = this.commonService.selectList("fileMgt_SQL.getWfFileList", setMap);
      }

      setMap.put("category", "DOCCAT");
      setMap.put("typeCode", wfInstInfo.get("DocCategory"));

      getPJTMap.put("WFDocType", StringUtil.checkNull(this.commonService.selectString("common_SQL.getNameFromDic", setMap)));

      Description = StringUtil.checkNull(getPJTMap.get("Description"), "");
      Description = Description.replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\"");
      getPJTMap.put("Description", Description);
      model.put("getPJTMap", getPJTMap);

      setMap.put("WFStepIDs", "'AREQ','APRV','AGR','PAGR','REW'");
      setMap.put("WFStepID", "");
      wfInstList = this.commonService.selectList("wf_SQL.getWfStepInstList_gridList", setMap);

      setMap.put("WFStepIDs", "'REC','REF'");
      wfRefInstList = this.commonService.selectList("wf_SQL.getWfStepInstList_gridList", setMap);

      String wfURL = this.commonService.selectString("wf_SQL.getWFCategoryURL", setMap);

      setMap.put("emailCode", commandMap.get("emailCode"));
      String emailHTMLForm = StringUtil.checkNull(this.commonService.selectString("email_SQL.getEmailHTMLForm", setMap));

      model.put("emailHTMLForm", emailHTMLForm);
      model.put("menu", getLabel(request, this.commonService));
      model.put("projectID", projectID);
      model.put("wfURL", wfURL);
      model.put("wfID", wfID);
      model.put("srID", srID);
      model.put("stepInstID", stepInstID);
      model.put("actorID", actorID);
      model.put("stepSeq", stepSeq);
      model.put("wfInstanceID", wfInstanceID);
      model.put("wfDocType", wfInstInfo.get("DocCategory"));
      model.put("wfMode", StringUtil.checkNull(commandMap.get("wfMode")));
      model.put("lastSeq", lastSeq);
      model.put("screenType", commandMap.get("screenType"));
      model.put("fileList", attachFileList);
      model.put("filePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
      model.put("wfInstList", wfInstList);
      model.put("wfRefInstList", wfRefInstList);
      model.put("documentID", documentID);
      model.put("docCategory", wfInstInfo.get("DocCategory"));
    }
    catch (Exception e) {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }
    return model;
  }

  @RequestMapping({"/approvalDetail.do"})
  public String approvalDetail(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    Map setMap = new HashMap();
    List attachFileList = new ArrayList();
    List wfInstList = new ArrayList();
    String url = "/wf/approvalDetail";
    try {
      String wfMode = StringUtil.checkNull(commandMap.get("wfMode"));
      String menuIndex = "";
      String docCategory = StringUtil.checkNull(commandMap.get("docCategory"));
      url = StringUtil.checkNull(this.commonService.selectString("wf_SQL.getWFDocURL", commandMap));

      if (wfMode.equals("AREQ"))
        menuIndex = "13";
      else if (wfMode.equals("CurAprv"))
        menuIndex = "14";
      else if (wfMode.equals("ToDoAprv"))
        menuIndex = "15";
      else if (wfMode.equals("Ref"))
        menuIndex = "16";
      else if (wfMode.equals("Cls")) {
        menuIndex = "17";
      }
      model = getApprovalMailForm(request, commandMap, model);

      model.put("menuIndex", menuIndex);
    }
    catch (Exception e) {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }
    return nextUrl(url);
  }
  @RequestMapping({"/getWFStepInfo.do"})
  public String getWFStepInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    Map setMap = new HashMap();
    Map urlMap = new HashMap();
    try {
      String wfID = StringUtil.checkNull(commandMap.get("wfID"));
      String srID = StringUtil.checkNull(commandMap.get("srID"));
      String sessionUserId = StringUtil.checkNull(commandMap.get("sessionUserId"));
      String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
      String projectID = StringUtil.checkNull(commandMap.get("projectID"));
      String wfDocType = StringUtil.checkNull(commandMap.get("wfDocType"));

      setMap.put("wfID", wfID);
      setMap.put("languageID", languageID);
      setMap.put("wfDocType", wfDocType);
      urlMap = this.commonService.select("common_SQL.getMenuURLFromWF2_commonSelect", setMap);
      String url = StringUtil.checkNull(urlMap.get("WFURL"));

      Map aprvBySysRoleInfo = new HashMap();
      Map aprvByManagerInfo = new HashMap();
      Map aprvByPmInfo = new HashMap();
      String wfStepInfo = "";
      String memberIDs = "";
      String roleTypes = "";

      if (url.equals("aprvBySysRole"))
      {
        wfStepInfo = StringUtil.checkNull(aprvBySysRoleInfo.get("wfStepInfo"));
        memberIDs = StringUtil.checkNull(aprvBySysRoleInfo.get("memberIDs"));
        roleTypes = StringUtil.checkNull(aprvBySysRoleInfo.get("roleTypes"));
      } else if (url.equals("aprvByManager"))
      {
        wfStepInfo = StringUtil.checkNull(aprvByManagerInfo.get("wfStepInfo"));
        memberIDs = StringUtil.checkNull(aprvByManagerInfo.get("memberIDs"));
        roleTypes = StringUtil.checkNull(aprvByManagerInfo.get("roleTypes"));
      } else if (url.equals("aprvBySysPmRole")) {
        aprvByPmInfo = aprvBySysPmRole(projectID, languageID, commandMap);

        if ((aprvByPmInfo.get("noManager") != null) && (aprvByPmInfo.get("noManager").equals("Y"))) {
          target.put("SCRIPT", "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
          target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00152"));

          model.addAttribute("resultMap", target);
          return nextUrl("/cmm/ajaxResult/ajaxPage");
        }

        wfStepInfo = StringUtil.checkNull(aprvByPmInfo.get("wfStepInfo"));
        memberIDs = StringUtil.checkNull(aprvByPmInfo.get("memberIDs"));
        roleTypes = StringUtil.checkNull(aprvByPmInfo.get("roleTypes"));
      }

      target.put("SCRIPT", "fnSetWFStepInfo('" + wfStepInfo + "','" + memberIDs + "','" + roleTypes + "','','')");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  @RequestMapping({"/createWFDocCSR.do"})
  public String createWFDocCSR(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    Map setMap = new HashMap();

    String url = StringUtil.checkNull(request.getParameter("WFDocURL"));
    if (url.equals("")) url = GlobalVal.CSR_APPROVAL_PATH;
    try
    {
      String isNew = StringUtil.checkNull(request.getParameter("isNew"));
      String wfStep = StringUtil.checkNull(request.getParameter("wfStep"));
      String projectID = StringUtil.checkNull(request.getParameter("ProjectID"));
      String isMulti = StringUtil.checkNull(request.getParameter("isMulti"));
      String wfStepInfo = StringUtil.checkNull(request.getParameter("wfStep"), "WF001");
      String wfDocType = StringUtil.checkNull(request.getParameter("wfDocType"), "CSR");
      String wfDocumentIDs = StringUtil.checkNull(request.getParameter("wfDocumentIDs"));
      String isPop = StringUtil.checkNull(request.getParameter("isPop"), "N");
      String backFunction = "csrDetail.do";
      String backMessage = "";
      String callbackData = "";
      Map labelMap = getLabel(request, this.commonService);

      String newWFInstanceID = "";

      String maxWFInstanceID = this.commonService.selectString("wf_SQL.MaxWFInstanceID", setMap);
      String OLM_SERVER_NAME = GlobalVal.OLM_SERVER_NAME;
      int OLM_SERVER_NAME_LENGTH = GlobalVal.OLM_SERVER_NAME.length();
      String initLen = "%0" + (13 - OLM_SERVER_NAME_LENGTH) + "d";

      int maxWFInstanceID2 = Integer.parseInt(maxWFInstanceID.substring(OLM_SERVER_NAME_LENGTH));
      int maxcode = maxWFInstanceID2 + 1;
      newWFInstanceID = OLM_SERVER_NAME + String.format(initLen, new Object[] { Integer.valueOf(maxcode) });

      setMap.put("LanguageID", commandMap.get("languageID"));
      setMap.put("WFID", wfStepInfo);
      setMap.put("TypeCode", wfStepInfo);
      setMap.put("ProjectID", request.getParameter("ProjectID"));

      List wfStepList = this.commonService.selectList("wf_SQL.getWfStepList", setMap);

      String wfDescription = this.commonService.selectString("wf_SQL.getWFDescription", setMap);
      String MandatoryGRID = this.commonService.selectString("wf_SQL.getMandatoryGRID", setMap);

      setMap.put("languageID", commandMap.get("sessionCurrLangType"));
      setMap.put("projectID", projectID);
      String ProjectName = this.commonService.selectString("project_SQL.getProjectName", setMap);

      model.put("ProjectName", ProjectName);
      model.put("wfDocumentIDs", wfDocumentIDs);
      model.put("isMulti", isMulti);
      model.put("isPop", isPop);
      model.put("wfDescription", wfDescription);
      model.put("MandatoryGRID", MandatoryGRID);

      setMap.put("WFStepIDs", "'AREQ','APRV','AGR'");

      List wfStepInstList = this.commonService.selectList("wf_SQL.getWFStepInstInfoList", setMap);
      int wfStepInstListSize = 0;
      if ((wfStepInstList != null) && (!wfStepInstList.isEmpty())) {
        wfStepInstListSize = wfStepInstList.size();
      }
      model.put("wfStepInstListSize", Integer.valueOf(wfStepInstListSize));

      String wfStepInstInfo = "";
      String wfStepInstREFInfo = "";
      String wfStepInstAGRInfo = "";

      String wfStepMemberIDs = "";
      String wfStepRoleTypes = "";

      Map wfStepInstInfoMap = new HashMap();
      Map getPJTMap = new HashMap();

      if (wfStepInstListSize > 0) {
        for (int i = 0; i < wfStepInstListSize; i++) {
          wfStepInstInfoMap = (Map)wfStepInstList.get(i);
          if (i == 0) {
            wfStepInstInfo = wfStepInstInfoMap.get("ActorName") + "(" + wfStepInstInfoMap.get("WFStepName") + ")";
            wfStepMemberIDs = StringUtil.checkNull(wfStepInstInfoMap.get("ActorID"));
            wfStepRoleTypes = StringUtil.checkNull(wfStepInstInfoMap.get("WFStepID"));
          } else {
            wfStepInstInfo = wfStepInstInfo + " >> " + wfStepInstInfoMap.get("ActorName") + "(" + wfStepInstInfoMap.get("WFStepName") + ")";
            wfStepMemberIDs = wfStepMemberIDs + "," + StringUtil.checkNull(wfStepInstInfoMap.get("ActorID"));
            wfStepRoleTypes = wfStepRoleTypes + "," + StringUtil.checkNull(wfStepInstInfoMap.get("WFStepID"));
          }
        }
        model.put("wfStepInstInfo", wfStepInstInfo);
        model.put("wfStepMemberIDs", wfStepMemberIDs);
        model.put("wfStepRoleTypes", wfStepRoleTypes);
      }

      String wfStepRefMemberIDs = "";
      setMap.put("WFStepIDs", "'REF'");
      List wfStepInstREFList = this.commonService.selectList("wf_SQL.getWFStepInstInfoList", setMap);
      Map wfStepInstInfREFoMap = new HashMap();
      if (wfStepInstREFList.size() > 0) {
        for (int i = 0; i < wfStepInstREFList.size(); i++) {
          wfStepInstInfREFoMap = (Map)wfStepInstREFList.get(i);
          if (i == 0) {
            wfStepInstREFInfo = wfStepInstInfREFoMap.get("ActorName") + "(" + wfStepInstInfREFoMap.get("WFStepName") + ")";
            wfStepRefMemberIDs = StringUtil.checkNull(wfStepInstInfREFoMap.get("ActorID"));
          } else {
            wfStepInstREFInfo = wfStepInstREFInfo + "," + wfStepInstInfREFoMap.get("ActorName") + "(" + wfStepInstInfREFoMap.get("WFStepName") + ")";
            wfStepRefMemberIDs = wfStepRefMemberIDs + "," + StringUtil.checkNull(wfStepInstInfREFoMap.get("ActorID"));
          }
        }
        model.put("wfStepInstREFInfo", wfStepInstREFInfo);
        model.put("wfStepRefMemberIDs", wfStepRefMemberIDs);
      }

      String wfStepAgrMemberIDs = "";
      setMap.put("WFStepIDs", "'AGR'");
      List wfStepInstAGRList = this.commonService.selectList("wf_SQL.getWFStepInstInfoList", setMap);
      Map wfStepInstInfAGRoMap = new HashMap();
      if (wfStepInstAGRList.size() > 0) {
        for (int i = 0; i < wfStepInstAGRList.size(); i++) {
          wfStepInstInfAGRoMap = (Map)wfStepInstAGRList.get(i);
          if (i == 0) {
            wfStepInstAGRInfo = wfStepInstInfAGRoMap.get("ActorName") + "(" + wfStepInstInfAGRoMap.get("WFStepName") + ")";
            wfStepAgrMemberIDs = StringUtil.checkNull(wfStepInstInfAGRoMap.get("ActorID"));
          } else {
            wfStepInstAGRInfo = wfStepInstAGRInfo + "," + wfStepInstInfAGRoMap.get("ActorName") + "(" + wfStepInstInfAGRoMap.get("WFStepName") + ")";
            wfStepAgrMemberIDs = wfStepAgrMemberIDs + "," + StringUtil.checkNull(wfStepInstInfAGRoMap.get("ActorID"));
          }
        }
        model.put("wfStepInstAGRInfo", wfStepInstAGRInfo);
        model.put("wfStepAGRMemberIDs", wfStepAgrMemberIDs);
      }

      setMap.put("dimTypeID", "100001");
      List regionList = this.commonService.selectList("dim_SQL.getDimValueNameList", setMap);

      model.put("regionList", regionList);
      setMap.put("languageID", commandMap.get("sessionCurrLangType"));
      setMap.put("s_itemID", request.getParameter("ProjectID"));

      Map getMap = this.commonService.select("wf_SQL.getWFInstanceDetail_gridList", setMap);
      model.put("getMap", getMap);

      if ((getMap != null) && (!getMap.isEmpty())) {
        setMap.put("DocCategory", getMap.get("DocCategory"));
      }
      if (wfDocType.equals("CSR")) {
        getPJTMap = this.commonService.select("project_SQL.getProjectInfo", setMap);
        backMessage = StringUtil.checkNull(labelMap.get("LN00203"));
      }
      else if (wfDocType.equals("PJT"))
      {
        backFunction = "viewProjectInfo.do";

        callbackData = "&changeSetID=" + request.getParameter("ChangeSetID") + "&screenType=myPJT&pjtMode=R";
        getPJTMap = this.commonService.select("project_SQL.getProjectInfo", setMap);
        backMessage = StringUtil.checkNull(labelMap.get("LN00249"));
      }
      else if (wfDocType.equals("SR")) {
        setMap.put("srID", request.getParameter("srID"));
        getPJTMap = this.commonService.select("esm_SQL.getESMSRInfo", setMap);
        callbackData = "&srID=" + request.getParameter("srID") + "&screenType=srRqst&srMode=mySR";
        backFunction = "processItsp.do";
        backMessage = StringUtil.checkNull(labelMap.get("LN00281"));

        Map setData = new HashMap();
        String srArea2 = StringUtil.checkNull(request.getParameter("srArea2"));
        setData.put("itemID", srArea2);
        setData.put("roleType", "I");
        setData.put("assignmentType", "SRROLETP");
        setData.put("languageID", commandMap.get("sessionCurrLangType"));
        String approverID = "";
        String aprvTeamID = "";
        List srWFStepList = this.commonService.selectList("esm_SQL.getWFMemberList", setData);

        String srMemberIDs = "";
        String srRoleTypes = "";
        String srWFStepInfo = "";

        String sessionUserName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
        String sessionUserId = StringUtil.checkNull(commandMap.get("sessionUserId"));

        String RequestUserID = StringUtil.checkNull(this.commonService.selectString("esm_SQL.getESMSRReqUserID", setMap));

        setMap.put("sessionUserId", RequestUserID);
        String reqTeamID = StringUtil.checkNull(this.commonService.selectString("user_SQL.userTeamID", setMap));

        setMap.put("teamID", reqTeamID);
        Map managerInfo = this.commonService.select("user_SQL.getUserTeamManagerInfo", setMap);

        String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
        String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
        String userTeamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
        String userTeamName = StringUtil.checkNull(commandMap.get("sessionTeamName"));

        String managerID = StringUtil.checkNull(managerInfo.get("UserID"));
        String managerName = StringUtil.checkNull(managerInfo.get("MemberName"));
        String managerTeamID = StringUtil.checkNull(managerInfo.get("TeamID"));
        String managerTeamName = StringUtil.checkNull(managerInfo.get("TeamName"));

        srMemberIDs = userID + "," + managerID;
        srWFStepInfo = "AREQ,APRV";
        srRoleTypes = userName + "(" + userTeamName + ") >> " + managerName + "(" + managerTeamName + ")";

        if (srWFStepList.size() > 0) {
          for (int i = 0; i < srWFStepList.size(); i++) {
            Map srWFStep = (Map)srWFStepList.get(i);

            srWFStepInfo = srWFStepInfo + ">>" + StringUtil.checkNull(srWFStep.get("WFStep"));
            srMemberIDs = srMemberIDs + "," + StringUtil.checkNull(srWFStep.get("MemberID"));
            srRoleTypes = srRoleTypes + ",APRV";
          }

        }

        model.put("srMemberIDs", srMemberIDs);
        model.put("srRoleTypes", srRoleTypes);
        model.put("srWFStepInfo", srWFStepInfo);

        String srRequestUserID = StringUtil.checkNull(request.getParameter("srRequestUserID"));
        setData.put("memberID", srRequestUserID);
        String srRequestUserInfo = this.commonService.selectString("user_SQL.getMemberTeamInfo", setData);

        model.put("srRequestUserInfo", srRequestUserInfo);
        model.put("srRequestUserID", srRequestUserID);
      }
      else if ((wfDocType.equals("CS")) && (isMulti.equals("N"))) {
        setMap.put("ProjectID", request.getParameter("ProjectID"));
        setMap.put("ChangeSetID", request.getParameter("ChangeSetID"));
        setMap.put("s_itemID", request.getParameter("itemId"));
        getPJTMap = this.commonService.select("wf_SQL.getChangetSetInfoWF", setMap);
        backFunction = "itemChangeInfo.do";
        callbackData = "&changeSetID=" + request.getParameter("ChangeSetID") + "&screenMode=edit&StatusCode=MOD&isAuthorUser=&LanguageID=" + commandMap.get("sessionCurrLangType");
        backMessage = StringUtil.checkNull(labelMap.get("LN00206"));
      }

      setMap.put("languageID", commandMap.get("sessionCurrLangType"));
      setMap.put("s_itemID", request.getParameter("ProjectID"));
      model.put("getPJTMap", getPJTMap);

      Map setData = new HashMap();
      if (StringUtil.checkNull(getPJTMap.get("Status")).equals("APRV")) {
        setData.put("ProjectID", request.getParameter("ProjectID"));
        setData.put("Status", "CNG");
        this.commonService.update("project_SQL.updateProject", setData);
      } else if (StringUtil.checkNull(getPJTMap.get("Status")).equals("APRV2")) {
        setData.put("ProjectID", request.getParameter("ProjectID"));
        setData.put("Status", "QA");
        this.commonService.update("project_SQL.updateProject", setData);
      }

      model.put("regionList", regionList);
      model.put("getPJTMap", getPJTMap);
      model.put("agrCnt", Integer.valueOf(wfStepInstAGRList.size()));

      model.put("wfStep", wfStep);
      model.put("wfDocType", wfDocType);

      model.put("menu", labelMap);
      model.put("isNew", isNew);
      model.put("mainMenu", StringUtil.checkNull(request.getParameter("mainMenu"), "1"));
      model.put("ProjectID", projectID);
      model.put("wfDocType", wfDocType);
      model.put("backFunction", backFunction);
      model.put("backMessage", backMessage);
      model.put("callbackData", callbackData);
      model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "1"));
      model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
      model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
      model.put("fromSR", StringUtil.checkNull(request.getParameter("fromSR")));
      model.put("srID", StringUtil.checkNull(request.getParameter("srID")));
      model.put("newWFInstanceID", newWFInstanceID);

      model.put("seletedTreeId", StringUtil.checkNull(request.getParameter("seletedTreeId")));
      model.put("isItemInfo", StringUtil.checkNull(request.getParameter("isItemInfo")));
    }
    catch (Exception e) {
      System.out.println(e);
      throw new Exception("EM00001");
    }
    return nextUrl(url);
  }
  @RequestMapping({"/openApprCommentPop.do"})
  public String openApprCommentPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    Map setMap = new HashMap();
    try {
      String projectID = StringUtil.checkNull(commandMap.get("projectID"));
      String wfID = StringUtil.checkNull(commandMap.get("wfID"));
      String loginUser = StringUtil.checkNull(commandMap.get("sessionUserId"));
      String wfInstanceID = StringUtil.checkNull(commandMap.get("wfInstanceID"));
      String stepInstID = StringUtil.checkNull(commandMap.get("stepInstID"));
      String actorID = StringUtil.checkNull(commandMap.get("actorID"));
      String stepSeq = StringUtil.checkNull(commandMap.get("stepSeq"));
      String lastSeq = StringUtil.checkNull(commandMap.get("lastSeq"));
      String wfStepInstStatus = StringUtil.checkNull(commandMap.get("wfStepInstStatus"));
      String srID = StringUtil.checkNull(commandMap.get("srID"));
      String documentID = StringUtil.checkNull(commandMap.get("documentID"));
      String svcCompl = StringUtil.checkNull(commandMap.get("svcCompl"));
      String docNo = StringUtil.checkNull(commandMap.get("docNo"));

      setMap.put("ProjectID", projectID);
      setMap.put("languageID", commandMap.get("sessionCurrLangType"));
      setMap.put("s_itemID", projectID);
      Map getPJTMap = this.commonService.select("project_SQL.getProjectInfo", setMap);
      model.put("getPJTMap", getPJTMap);

      model.put("menu", getLabel(request, this.commonService));
      model.put("projectID", projectID);
      model.put("wfID", wfID);
      model.put("documentID", documentID);
      model.put("srID", srID);
      model.put("stepInstID", stepInstID);
      model.put("actorID", actorID);
      model.put("stepSeq", stepSeq);
      model.put("wfInstanceID", wfInstanceID);
      model.put("lastSeq", lastSeq);
      model.put("wfStepInstStatus", wfStepInstStatus);
      model.put("svcCompl", svcCompl);
      model.put("docNo", docNo);
    }
    catch (Exception e) {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }
    return nextUrl("/wf/approvalComment");
  }

  @RequestMapping({"/submitStepApproval.do"})
  public String submitStepApproval(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    Map setMap = new HashMap();
    try {
      String projectID = StringUtil.checkNull(commandMap.get("projectID"));
      String wfInstanceID = StringUtil.checkNull(commandMap.get("wfInstanceID"));
      String stepInstID = StringUtil.checkNull(commandMap.get("stepInstID"));
      String comment = StringUtil.checkNull(commandMap.get("comment"));
      String actorID = StringUtil.checkNull(commandMap.get("actorID"));
      String lastSeq = StringUtil.checkNull(commandMap.get("lastSeq"));
      String stepSeq = StringUtil.checkNull(commandMap.get("stepSeq"));
      String wfStepInstStatus = StringUtil.checkNull(commandMap.get("wfStepInstStatus"));
      String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
      String srID = StringUtil.checkNull(commandMap.get("srID"));
      String wfInstanceStatus = "1";
      String docStatus = "APRV2";
      String aprvOption = StringUtil.checkNull(commandMap.get("aprvOption"), "POST");
      String emailCode = "APREQ_CSR";
      String svcCompl = StringUtil.checkNull(commandMap.get("svcCompl"));
      String docNo = StringUtil.checkNull(commandMap.get("docNo"));

      HashMap apprInfoMail = new HashMap();
      Map wfInfoMap = new HashMap();
      setMap.put("wfInstanceID", wfInstanceID);
      wfInfoMap = this.commonService.select("wf_SQL.getWFInstTXT", setMap);
      String url = "";
      String data = "";
      setMap.put("ProjectID", projectID);
      setMap.put("WFInstanceID", wfInstanceID);
      setMap.put("wfInstanceID", wfInstanceID);
      setMap.put("StepInstID", stepInstID);
      setMap.put("Status", wfStepInstStatus);
      setMap.put("comment", comment);
      setMap.put("ActorID", actorID);
      this.commonService.update("wf_SQL.updateWFStepInst", setMap);
      setMap.put("LastUser", commandMap.get("sessionUserId"));
      String wfID = this.commonService.selectString("wf_SQL.getWFID", setMap);
      Map wfDocMap = this.commonService.select("wf_SQL.getWFInstDoc", setMap);
      String wfStepID = this.commonService.selectString("wf_SQL.getWFINStepID", setMap);
      setMap.put("projectID", projectID);
      setMap.put("stepSeq", stepSeq);
      setMap.put("status", "0");
      setMap.put("languageID", languageID);
      String getWFStepInstCount = this.commonService.selectString("wf_SQL.getWFStepInstCount", setMap);

      HashMap setMailData = new HashMap();
      setMailData.put("subject", wfInfoMap.get("Subject"));
      setMailData.put("LanguageID", languageID);

      if ((wfStepInstStatus.equals("2")) || ("REW".equals(wfStepID)))
      {
        if ((!lastSeq.equals(stepSeq)) && (Integer.parseInt(getWFStepInstCount) == 0)) {
          setMap.put("curSeq", Integer.valueOf(Integer.parseInt(stepSeq) + 1));
          setMap.put("Status", "1");
          this.commonService.update("wf_SQL.updateWfInst", setMap);

          setMap.put("Status", "0");
          setMap.remove("comment");
          setMap.remove("ActorID");
          setMap.remove("StepInstID");
          setMap.put("updateSeq", Integer.valueOf(Integer.parseInt(stepSeq) + 1));

          this.commonService.update("wf_SQL.updateWFStepInst", setMap);

          setMap.put("stepInstID", stepInstID);
          setMap.put("nextSeq", Integer.valueOf(Integer.parseInt(stepSeq) + 1));

          List receiverList = new ArrayList();
          List refList = new ArrayList();
          List temp1 = this.commonService.selectList("wf_SQL.getWFStepMailList", setMap);

          int j = 0;

          String emailStepInstID = "";
          String emailStepSeq = "";
          String emailActorID = "";
          for (int i = 0; i < temp1.size(); i++) {
            Map tempMap = (Map)temp1.get(i);
            Map tempMap2 = new HashMap();
            String WFStepID = (String)tempMap.get("WFStepID");
            if ("REF".equals(WFStepID)) {
              tempMap2.put("userID", tempMap.get("ActorID"));
              refList.add(StringUtil.checkNull(this.commonService.selectString("user_SQL.userEmail", tempMap2), ""));
            }
            else {
              tempMap2.put("receiptUserID", tempMap.get("ActorID"));
              receiverList.add(j++, tempMap2);

              emailStepInstID = StringUtil.checkNull(tempMap.get("StepInstID"));
              emailStepSeq = StringUtil.checkNull(tempMap.get("Seq"));
              emailActorID = StringUtil.checkNull(tempMap.get("ActorID"));
            }
          }

          if (wfDocMap.get("DocCategory").equals("CS")) {
            emailCode = "APREQ_CS";
          } else if (wfDocMap.get("DocCategory").equals("SR")) {
            emailCode = "SRAPREQ";
            commandMap.put("emailCode", emailCode);
          }

          setMailData.put("receiverList", receiverList);
          System.out.println("receiverList ::>> " + receiverList);
          Map setMailMap = setEmailLog(request, this.commonService, setMailData, emailCode);

          if (StringUtil.checkNull(setMailMap.get("type")).equals("SUCESS")) {
            HashMap mailMap = (HashMap)setMailMap.get("mailLog");

            ModelMap MailModel = getApprovalMailForm(request, commandMap, model);
            MailModel.put("receiverList", receiverList);
            MailModel.put("LanguageID", languageID);
            mailMap.put("refList", refList);

            MailModel.put("stepInstID", emailStepInstID);
            MailModel.put("stepSeq", emailStepSeq);
            MailModel.put("lastSeq", lastSeq);
            MailModel.put("actorID", emailActorID);
            System.out.println("MailModel :" + MailModel);
            Map resultMailMap = EmailUtil.sendMail(mailMap, MailModel, getLabel(request, this.commonService));
            System.out.println("SEND EMAIL TYPE:" + resultMailMap + ", Msg:" + StringUtil.checkNull(setMailMap.get("type")));
          } else {
            System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : " + StringUtil.checkNull(setMailMap.get("msg")));
          }
          target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00083"));
        }
        else if ((lastSeq.equals(stepSeq)) && (Integer.parseInt(getWFStepInstCount) == 0)) {
          wfInstanceStatus = "2";

          if (aprvOption.equals("PRE"))
            docStatus = "CNG";
          else {
            docStatus = "QA";
          }
          target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00083"));

          setMap.put("wfStepID", "REF");
          List receiverList = new ArrayList();
          List refList = new ArrayList();
          List temp1 = this.commonService.selectList("wf_SQL.getWFStepMailList", setMap);

          int j = 0;
          for (int i = 0; i < temp1.size(); i++) {
            Map tempMap = (Map)temp1.get(i);
            Map tempMap2 = new HashMap();
            String WFStepID = (String)tempMap.get("WFStepID");
            if ("REF".equals(WFStepID)) {
              tempMap2.put("receiptUserID", tempMap.get("ActorID"));
              receiverList.add(j++, tempMap2);
            }
          }

          setMap.put("wfStepID", "REC");
          temp1 = this.commonService.selectList("wf_SQL.getWFStepMailList", setMap);
          for (int i = 0; i < temp1.size(); i++) {
            Map tempMap = (Map)temp1.get(i);
            Map tempMap2 = new HashMap();
            String WFStepID = (String)tempMap.get("WFStepID");
            if ("REC".equals(WFStepID)) {
              tempMap2.put("receiptUserID", tempMap.get("ActorID"));
              receiverList.add(j++, tempMap2);
            }
          }

          setMailData.put("receiverList", receiverList);
          setMailData.put("LanguageID", languageID);

          Map setMailMap = setEmailLog(request, this.commonService, setMailData, "APRVREF");

          if (StringUtil.checkNull(setMailMap.get("type")).equals("SUCESS")) {
            HashMap mailMap = (HashMap)setMailMap.get("mailLog");

            ModelMap MailModel = getApprovalMailForm(request, commandMap, model);
            MailModel.put("receiverList", receiverList);
            MailModel.put("LanguageID", languageID);
            MailModel.put("wfInstanceID", wfInstanceID);
            MailModel.put("docNo", docNo);

            Map resultMailMap = EmailUtil.sendMail(mailMap, MailModel, getLabel(request, this.commonService));
            System.out.println("SEND EMAIL TYPE:" + resultMailMap + ", Msg:" + StringUtil.checkNull(setMailMap.get("type")));
          } else {
            System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : " + StringUtil.checkNull(setMailMap.get("msg")));
          }

          HashMap projectInfoMap = (HashMap)this.commonService.select("project_SQL.getProjectInfo", setMap);
          Map setWFData = new HashMap();
          Map receiverMap = new HashMap();

          setWFData.put("projectID", projectID);
          setWFData.put("wfInstanceID", wfInstanceID);

          List reqReceiverList = new ArrayList();

          setWFData.put("wfStepID", "AREQ");
          String requester = StringUtil.checkNull(this.commonService.selectString("wf_SQL.getWFActorID", setWFData));
          receiverMap.put("receiptUserID", requester);
          reqReceiverList.add(0, receiverMap);

          Map managerMap = new HashMap();
          setWFData.put("wfStepID", "MGT");
          String manager = StringUtil.checkNull(this.commonService.selectString("wf_SQL.getWFActorID", setWFData));
          if (!manager.equals("")) {
            managerMap.put("receiptUserID", manager);
            reqReceiverList.add(1, managerMap);

            j = 2;
          }
          j = 1;

          setMap.remove("wfStepID");
          setMap.put("wfStepIDs", "'AGR','APRV','PAGR'");
          temp1 = this.commonService.selectList("wf_SQL.getWFStepMailList", setMap);
          for (int i = 0; i < temp1.size(); i++) {
            Map tempMap = (Map)temp1.get(i);
            Map tempMap2 = new HashMap();
            if (!stepSeq.equals(tempMap.get("Seq"))) {
              tempMap2.put("receiptUserID", tempMap.get("ActorID"));
              tempMap2.put("receiptType", "CC");
              reqReceiverList.add(j++, tempMap2);
            }
          }

          setWFData.put("receiverList", reqReceiverList);

          emailCode = "APRVCLS"; if (wfDocMap.get("DocCategory").equals("SR")) emailCode = "SRAPREL";

          Map temp = new HashMap();
          temp.put("Category", "EMAILCODE");
          temp.put("TypeCode", emailCode);
          temp.put("LanguageID", commandMap.get("sessionCurrLangType"));
          Map emDescription = this.commonService.select("common_SQL.label_commonSelect", temp);
          projectInfoMap.put("emDescription", emDescription.get("Description"));

          setWFData.put("languageID", commandMap.get("sessionCurrLangType"));
          String projectName = this.commonService.selectString("project_SQL.getProjectName", setWFData);

          setWFData.put("subject", wfInfoMap.get("Subject"));
          Map setMail_APRVCLS = setEmailLog(request, this.commonService, setWFData, emailCode);

          if (StringUtil.checkNull(setMail_APRVCLS.get("type")).equals("SUCESS")) {
            HashMap mailMap = (HashMap)setMail_APRVCLS.get("mailLog");
            projectInfoMap.put("languageID", commandMap.get("sessionCurrLangType"));
            projectInfoMap.put("wfInstanceID", wfInstanceID);
            projectInfoMap.put("docNo", docNo);
            Map resultMailMap = EmailUtil.sendMail(mailMap, projectInfoMap, getLabel(request, this.commonService));

            System.out.println("SEND EMAIL TYPE:" + resultMailMap + "Msg :" + StringUtil.checkNull(setMail_APRVCLS.get("type")));
          } else {
            System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : " + StringUtil.checkNull(setMail_APRVCLS.get("msg")));
          }
        }
        System.out.println("Approval Update SUCCESS! ");
      } else if (!wfStepInstStatus.equals("2")) {
        wfInstanceStatus = wfStepInstStatus;
        docStatus = "HOLD";
        target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00156"));

        System.out.println("wfStepInstStatus :" + wfStepInstStatus + ": HOLD Update SUCCESS! ");

        setMap.put("Status", wfInstanceStatus);
        this.commonService.update("wf_SQL.updateWfInst", setMap);

        if ((wfDocMap.get("DocCategory").equals("CSR")) || (wfDocMap.get("DocCategory").equals("PJT")))
        {
          setMap.put("Status", docStatus);
          this.commonService.update("project_SQL.updateProject", setMap);
        }
        else if (wfDocMap.get("DocCategory").equals("CS")) {
          docStatus = "WTR";
          setMap.put("status", docStatus);
          setMap.put("wfInstanceID", wfInstanceID);

          this.commonService.update("cs_SQL.updateChangeSetForWFInstID", setMap);
        }

        setMap.put("s_itemID", projectID);
        setMap.put("languageID", commandMap.get("sessionCurrLangType"));
        HashMap projectInfoMap = (HashMap)this.commonService.select("project_SQL.getProjectInfo", setMap);

        Map setWFData = new HashMap();
        setWFData.put("projectID", projectID);

        List receiverList = new ArrayList();
        Map receiverMap = new HashMap();

        setWFData.put("wfStepID", "AREQ");
        setWFData.put("wfInstanceID", wfInstanceID);
        String requester = StringUtil.checkNull(this.commonService.selectString("wf_SQL.getWFActorID", setWFData));
        receiverMap.put("receiptUserID", requester);
        receiverList.add(0, receiverMap);

        Map managerMap = new HashMap();
        setWFData.put("wfStepID", "MGT");
        String manager = StringUtil.checkNull(this.commonService.selectString("wf_SQL.getWFActorID", setWFData));
        if (!manager.equals("")) {
          managerMap.put("receiptUserID", manager);
          receiverList.add(1, managerMap);
        }

        setWFData.put("receiverList", receiverList);

        emailCode = "APRVRJT"; if (wfDocMap.get("DocCategory").equals("SR")) emailCode = "SRAPRJT";
        Map temp = new HashMap();
        temp.put("Category", "EMAILCODE");
        temp.put("TypeCode", emailCode);
        temp.put("LanguageID", commandMap.get("sessionCurrLangType"));
        Map emDescription = this.commonService.select("common_SQL.label_commonSelect", temp);
        projectInfoMap.put("emDescription", emDescription.get("Description"));

        setWFData.put("languageID", commandMap.get("sessionCurrLangType"));
        String projectName = this.commonService.selectString("project_SQL.getProjectName", setWFData);

        setWFData.put("subject", wfInfoMap.get("Subject"));

        Map setMail_APRVRJT = setEmailLog(request, this.commonService, setWFData, emailCode);

        if (StringUtil.checkNull(setMail_APRVRJT.get("type")).equals("SUCESS")) {
          HashMap mailMap = (HashMap)setMail_APRVRJT.get("mailLog");

          projectInfoMap.put("languageID", commandMap.get("sessionCurrLangType"));
          projectInfoMap.put("wfInstanceID", wfInstanceID);
          projectInfoMap.put("docNo", docNo);
          Map resultMailMap = EmailUtil.sendMail(mailMap, projectInfoMap, getLabel(request, this.commonService));
          System.out.println("SEND EMAIL TYPE:" + resultMailMap + "Msg :" + StringUtil.checkNull(setMail_APRVRJT.get("type")));
        } else {
          System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : " + StringUtil.checkNull(setMail_APRVRJT.get("msg")));
        }

      }

      if ((wfInstanceStatus.equals("2")) || (
        (!wfStepInstStatus.equals("2")) && ("REW".equals(wfStepID)) && 
        (lastSeq.equals(stepSeq)) && (Integer.parseInt(getWFStepInstCount) == 0)))
      {
        setMap.put("wfID", wfID);
        setMap.put("wfDocType", wfDocMap.get("DocCategory"));

        String postProcessing = StringUtil.checkNull(this.commonService.selectString("wf_SQL.getPostProcessing", setMap), "");

        if (postProcessing != "")
        {
          docStatus = "CLS";

          if (postProcessing.split("\\?").length > 1) {
            String[] tmp = postProcessing.split("\\?");
            url = tmp[0];
            data = tmp[1] + "&csrID=" + projectID + "&status=" + docStatus + "&srID=" + srID + "&screenType=csrDtl&wfInstanceID=" + wfInstanceID + "&wfInstanceStatus=" + wfInstanceStatus + "&svcCompl=" + svcCompl;
          }
          else {
            url = postProcessing;
            data = "csrID=" + projectID + "&status=" + docStatus + "&srID=" + srID + "&screenType=csrDtl&wfInstanceID=" + wfInstanceID + "&wfInstanceStatus=" + wfInstanceStatus + "&svcCompl=" + svcCompl;
          }

        }

        if ((wfDocMap.get("DocCategory").equals("CSR")) || (wfDocMap.get("DocCategory").equals("PJT"))) {
          if (!srID.equals("")) {
            setMap.put("srID", srID);
            if (aprvOption.equals("PRE")) {
              setMap.put("status", "CNG");

              setMap.put("lastUser", commandMap.get("sessionUserId"));
              this.commonService.update("esm_SQL.updateESMSRStatus", setMap);

              Map setProcMapRst = setProcLog(request, this.commonService, setMap);
              if (setProcMapRst.get("type").equals("FAILE")) {
                String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
                System.out.println("Msg : " + Msg);
              }
            }
          }
          setMap.put("Status", docStatus);
          this.commonService.update("project_SQL.updateProject", setMap);
        }
        else if (wfDocMap.get("DocCategory").equals("CS"))
        {
          setMap.put("status", docStatus);
          setMap.put("wfInstanceID", wfInstanceID);

          this.commonService.update("cs_SQL.updateChangeSetForWFInstID", setMap);
        }

        setMap.put("CSRID", projectID);
        if (aprvOption.equals("PRE")) {
          setMap.put("status", "RFC");
          setMap.put("ITSMIF", "0");
          this.commonService.update("cr_SQL.updateCR", setMap);
        }

        setMap.put("Status", wfInstanceStatus);
        this.commonService.update("wf_SQL.updateWfInst", setMap);
      }
      else if ((wfInstanceStatus.equals("3")) && (wfDocMap.get("DocCategory").equals("CS")))
      {
        setMap.put("wfID", wfID);
        setMap.put("wfDocType", wfDocMap.get("DocCategory"));

        String postProcessing = StringUtil.checkNull(this.commonService.selectString("wf_SQL.getPostProcessing", setMap), "");

        if (postProcessing != "") {
          docStatus = "WTR";
          if (postProcessing.split("\\?").length > 1) {
            String[] tmp = postProcessing.split("\\?");
            url = tmp[0];
            data = tmp[1] + "&csrID=" + projectID + "&status=" + docStatus + "&srID=" + srID + "&screenType=csrDtl&wfInstanceID=" + wfInstanceID;
          }
          else {
            url = postProcessing;
            data = "csrID=" + projectID + "&status=" + docStatus + "&srID=" + srID + "&screenType=csrDtl&wfInstanceID=" + wfInstanceID;
          }

        }

      }
      else if ((wfInstanceStatus.equals("3")) && (wfDocMap.get("DocCategory").equals("SR")))
      {
        setMap.put("wfID", wfID);
        setMap.put("wfDocType", wfDocMap.get("DocCategory"));

        String postProcessing = StringUtil.checkNull(this.commonService.selectString("wf_SQL.getPostProcessing", setMap), "");

        if (postProcessing != "") {
          if (postProcessing.split("\\?").length > 1) {
            String[] tmp = postProcessing.split("\\?");
            url = tmp[0];
            data = tmp[1] + "&srID=" + srID + "&srID=" + srID + "&wfInstanceStatus=" + wfInstanceStatus + "&wfInstanceID=" + wfInstanceID + "&svcCompl=" + svcCompl;
          }
          else {
            url = postProcessing;
            data = "srID=" + srID + "&wfInstanceStatus=" + wfInstanceStatus + "&wfInstanceID=" + wfInstanceID + "&svcCompl=" + svcCompl;
          }
        }
      }

      target.put("SCRIPT", "parent.fnCallBackSubmit('" + url + "', '" + data + "');this.$('#isSubmit').remove()");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00084"));
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }
  @RequestMapping({"/getWFInfo.do"})
  public String getWFInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    Map setMap = new HashMap();
    Map urlMap = new HashMap();
    try {
      String wfID = StringUtil.checkNull(commandMap.get("wfID"));
      String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));

      setMap.put("wfID", wfID);
      setMap.put("languageID", languageID);
      urlMap = this.commonService.select("common_SQL.getMenuURLFromWF_commonSelect", setMap);
      String wfDescription = "";
      String serviceCode = "";
      if (!urlMap.isEmpty()) {
        wfDescription = StringUtil.checkNull(urlMap.get("Description"));
        serviceCode = StringUtil.checkNull(urlMap.get("ServiceCode"));
      }

      target.put("SCRIPT", "fnSetWFInfo('" + wfDescription + "','" + serviceCode + "');");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }
  @RequestMapping({"/getAprvGroupList.do"})
  public String getAprvGroupList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    String wfID = StringUtil.checkNull(request.getParameter("WFID"));
    String grID = StringUtil.checkNull(request.getParameter("GRID"));
    String grType = StringUtil.checkNull(request.getParameter("GRType"));

    if ((grID.equals("")) && (!"".equals(wfID)) && (grType.equals("MGT"))) {
      grID = this.commonService.selectString("wf_SQL.getMandatoryGRID", commandMap);
    }
    else if ((grID.equals("")) && (!"".equals(wfID)) && (grType.equals("End"))) {
      grID = this.commonService.selectString("wf_SQL.getEndGRID", commandMap);
    }

    commandMap.put("state", request.getParameter("dimTypeId"));
    commandMap.put("GRType", request.getParameter("GRType"));
    commandMap.put("GRID", grID);
    List getList = this.commonService.selectList("common_SQL.getAprvGroupList_commonSelect", commandMap);

    model.put("resultMap", getList);
    return nextUrl("/cmm/ajaxResult/ajaxOption");
  }

  @RequestMapping({"/getWFCategoryList.do"})
  public String getWFCategoryList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    Map setMap = new HashMap();
    try
    {
      List categoryList = this.commonService.selectList("wf_SQL.getWFCategoryList", commandMap);

      model.put("categoryList", categoryList);
      model.put("categoryCnt", Integer.valueOf(categoryList.size()));
      model.put("wfInstanceID", StringUtil.checkNull(commandMap.get("wfInstanceID")));
      model.put("menu", getLabel(request, this.commonService));
    }
    catch (Exception e) {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }

    return nextUrl("wf/wfCategoryList");
  }

  @RequestMapping({"/getWFApprovalCheckList.do"})
  public String getWFApprovalCheckList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception
  {
    Map setMap = new HashMap();
    try
    {
      String wfDocType = StringUtil.checkNull(commandMap.get("wfDocType"));
      String documentIDs = StringUtil.checkNull(commandMap.get("documentIDs"));
      String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));

      model.put("wfDocType", wfDocType);
      model.put("documentIDs", documentIDs);
      model.put("menu", getLabel(request, this.commonService));
    }
    catch (Exception e) {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }

    return nextUrl("wf/wfApprovalCheckList");
  }

  @RequestMapping({"/wfDocMgt.do"})
  public String wfDocMgt(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    String url = "";
    Map setMap = new HashMap();
    try
    {
      String actionType = StringUtil.checkNull(request.getParameter("actionType"), "create");
      String wfDocType = StringUtil.checkNull(request.getParameter("wfDocType"), "CSR");
      String wfDocURL = StringUtil.checkNull(request.getParameter("WFDocURL"), "");
      String wfAprURL = StringUtil.checkNull(request.getParameter("wfAprURL"), "");
      String docCategory = StringUtil.checkNull(commandMap.get("docCategory"));

      if (actionType.equals("create")) {
        model = getWfDocInfo(request, commandMap, model);
        url = "".equals(wfDocURL) ? GlobalVal.CS_APPROVAL_PATH : wfDocType.equals("CSR") ? GlobalVal.CSR_APPROVAL_PATH : wfDocURL;
      }
      else if (actionType.equals("view")) {
        model = getApprovalMailForm(request, commandMap, model);
        url = StringUtil.checkNull(this.commonService.selectString("wf_SQL.getWFAprURL", commandMap));
        if (url.equals("")) url = "/wf/approvalDetail"; 
      }
    }
    catch (Exception e)
    {
      System.out.println(e);
      throw new Exception("EM00001");
    }
    return nextUrl(url);
  }

  public ModelMap getWfDocInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    Map setMap = new HashMap();
    try
    {
      String isNew = StringUtil.checkNull(request.getParameter("isNew"));
      String wfStep = StringUtil.checkNull(request.getParameter("wfStep"));
      String projectID = StringUtil.checkNull(request.getParameter("ProjectID"));
      String isMulti = StringUtil.checkNull(request.getParameter("isMulti"));
      String wfStepInfo = StringUtil.checkNull(request.getParameter("wfStep"), "WF001");
      String wfDocType = StringUtil.checkNull(request.getParameter("wfDocType"), "CSR");
      String wfDocumentIDs = StringUtil.checkNull(request.getParameter("wfDocumentIDs"));
      String wfInstanceID = StringUtil.checkNull(request.getParameter("wfInstanceID"));
      String isMultiCnt = StringUtil.checkNull(request.getParameter("isMultiCnt"), "0");
      String isPop = StringUtil.checkNull(request.getParameter("isPop"), "N");
      String backFunction = "csrDetail.do";
      String backMessage = "";
      String callbackData = "";
      Map labelMap = getLabel(request, this.commonService);

      String newWFInstanceID = "";

      String maxWFInstanceID = this.commonService.selectString("wf_SQL.MaxWFInstanceID", setMap);
      String OLM_SERVER_NAME = GlobalVal.OLM_SERVER_NAME;
      int OLM_SERVER_NAME_LENGTH = GlobalVal.OLM_SERVER_NAME.length();
      String initLen = "%0" + (13 - OLM_SERVER_NAME_LENGTH) + "d";

      int maxWFInstanceID2 = Integer.parseInt(maxWFInstanceID.substring(OLM_SERVER_NAME_LENGTH));
      int maxcode = maxWFInstanceID2 + 1;
      newWFInstanceID = OLM_SERVER_NAME + String.format(initLen, new Object[] { Integer.valueOf(maxcode) });

      setMap.put("LanguageID", commandMap.get("languageID"));
      setMap.put("WFID", wfStepInfo);
      setMap.put("TypeCode", wfStepInfo);
      setMap.put("wfInstanceID", wfInstanceID);

      List wfStepList = this.commonService.selectList("wf_SQL.getWfStepList", setMap);

      String wfDescription = this.commonService.selectString("wf_SQL.getWFDescription", setMap);
      String MandatoryGRID = this.commonService.selectString("wf_SQL.getMandatoryGRID", setMap);

      setMap.put("languageID", commandMap.get("sessionCurrLangType"));

      model.put("wfDocumentIDs", wfDocumentIDs);
      model.put("isMulti", isMulti);
      model.put("isPop", isPop);
      model.put("wfDescription", wfDescription);
      model.put("MandatoryGRID", MandatoryGRID);

      setMap.put("WFStepIDs", "'AREQ','APRV','AGR'");

      List wfStepInstList = this.commonService.selectList("wf_SQL.getWFStepInstInfoList", setMap);
      int wfStepInstListSize = 0;
      if ((wfStepInstList != null) && (!wfStepInstList.isEmpty())) {
        wfStepInstListSize = wfStepInstList.size();
      }
      model.put("wfStepInstListSize", Integer.valueOf(wfStepInstListSize));

      String wfStepInstInfo = "";
      String wfStepInstREFInfo = "";
      String wfStepInstAGRInfo = "";

      String wfStepMemberIDs = "";
      String wfStepRoleTypes = "";

      Map wfStepInstInfoMap = new HashMap();
      Map getPJTMap = new HashMap();
      Map getWFTXTMap = new HashMap();

      if (wfStepInstListSize > 0) {
        for (int i = 0; i < wfStepInstListSize; i++) {
          wfStepInstInfoMap = (Map)wfStepInstList.get(i);
          if (i == 0) {
            wfStepInstInfo = wfStepInstInfoMap.get("ActorName") + "(" + wfStepInstInfoMap.get("WFStepName") + ")";
            wfStepMemberIDs = StringUtil.checkNull(wfStepInstInfoMap.get("ActorID"));
            wfStepRoleTypes = StringUtil.checkNull(wfStepInstInfoMap.get("WFStepID"));
          } else {
            wfStepInstInfo = wfStepInstInfo + " >> " + wfStepInstInfoMap.get("ActorName") + "(" + wfStepInstInfoMap.get("WFStepName") + ")";
            wfStepMemberIDs = wfStepMemberIDs + "," + StringUtil.checkNull(wfStepInstInfoMap.get("ActorID"));
            wfStepRoleTypes = wfStepRoleTypes + "," + StringUtil.checkNull(wfStepInstInfoMap.get("WFStepID"));
          }
        }
        model.put("wfStepInstInfo", wfStepInstInfo);
        model.put("wfStepMemberIDs", wfStepMemberIDs);
        model.put("wfStepRoleTypes", wfStepRoleTypes);
      }

      String wfStepRefMemberIDs = "";
      setMap.put("WFStepIDs", "'REF'");
      List wfStepInstREFList = this.commonService.selectList("wf_SQL.getWFStepInstInfoList", setMap);
      Map wfStepInstInfREFoMap = new HashMap();
      if (wfStepInstREFList.size() > 0) {
        for (int i = 0; i < wfStepInstREFList.size(); i++) {
          wfStepInstInfREFoMap = (Map)wfStepInstREFList.get(i);
          if (i == 0) {
            wfStepInstREFInfo = wfStepInstInfREFoMap.get("ActorName") + "(" + wfStepInstInfREFoMap.get("WFStepName") + ")";
            wfStepRefMemberIDs = StringUtil.checkNull(wfStepInstInfREFoMap.get("ActorID"));
          } else {
            wfStepInstREFInfo = wfStepInstREFInfo + "," + wfStepInstInfREFoMap.get("ActorName") + "(" + wfStepInstInfREFoMap.get("WFStepName") + ")";
            wfStepRefMemberIDs = wfStepRefMemberIDs + "," + StringUtil.checkNull(wfStepInstInfREFoMap.get("ActorID"));
          }
        }
        model.put("wfStepInstREFInfo", wfStepInstREFInfo);
        model.put("wfStepRefMemberIDs", wfStepRefMemberIDs);
      }

      String wfStepAgrMemberIDs = "";
      setMap.put("WFStepIDs", "'AGR'");
      List wfStepInstAGRList = this.commonService.selectList("wf_SQL.getWFStepInstInfoList", setMap);
      Map wfStepInstInfAGRoMap = new HashMap();
      if (wfStepInstAGRList.size() > 0) {
        for (int i = 0; i < wfStepInstAGRList.size(); i++) {
          wfStepInstInfAGRoMap = (Map)wfStepInstAGRList.get(i);
          if (i == 0) {
            wfStepInstAGRInfo = wfStepInstInfAGRoMap.get("ActorName") + "(" + wfStepInstInfAGRoMap.get("WFStepName") + ")";
            wfStepAgrMemberIDs = StringUtil.checkNull(wfStepInstInfAGRoMap.get("ActorID"));
          } else {
            wfStepInstAGRInfo = wfStepInstAGRInfo + "," + wfStepInstInfAGRoMap.get("ActorName") + "(" + wfStepInstInfAGRoMap.get("WFStepName") + ")";
            wfStepAgrMemberIDs = wfStepAgrMemberIDs + "," + StringUtil.checkNull(wfStepInstInfAGRoMap.get("ActorID"));
          }
        }
        model.put("wfStepInstAGRInfo", wfStepInstAGRInfo);
        model.put("wfStepAGRMemberIDs", wfStepAgrMemberIDs);
      }

      setMap.put("dimTypeID", "100001");
      List regionList = this.commonService.selectList("dim_SQL.getDimValueNameList", setMap);

      model.put("regionList", regionList);
      setMap.put("languageID", commandMap.get("sessionCurrLangType"));
      setMap.put("s_itemID", request.getParameter("ProjectID"));

      Map getMap = this.commonService.select("wf_SQL.getWFInstanceDetail_gridList", setMap);
      model.put("getMap", getMap);

      if ((getMap != null) && (!getMap.isEmpty())) {
        setMap.put("DocCategory", getMap.get("DocCategory"));
      }
      if (wfDocType.equals("CSR")) {
        getPJTMap = this.commonService.select("project_SQL.getProjectInfo", setMap);
        backMessage = StringUtil.checkNull(labelMap.get("LN00203"));
      }
      else if (wfDocType.equals("PJT"))
      {
        backFunction = "viewProjectInfo.do";

        callbackData = "&changeSetID=" + request.getParameter("changeSetID") + "&screenType=myPJT&pjtMode=R";
        getPJTMap = this.commonService.select("project_SQL.getProjectInfo", setMap);
        backMessage = StringUtil.checkNull(labelMap.get("LN00249"));
      }
      else if (wfDocType.equals("SR"))
      {
        String srID = StringUtil.checkNull(request.getParameter("srID"));
        String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));

        setMap.put("srID", srID);
        getPJTMap = this.commonService.select("esm_SQL.getESMSRInfo", setMap);
        callbackData = "&srID=" + request.getParameter("srID") + "&screenType=srRqst&srMode=mySR&blockSR=" + request.getParameter("blockSR");
        backFunction = "processItsp.do";
        backMessage = StringUtil.checkNull(labelMap.get("LN00281"));

        String defWFID = StringUtil.checkNull(getPJTMap.get("DefWFID"));
        setMap.put("WFID", defWFID);
        model.put("defWFID", defWFID);
        String url = StringUtil.checkNull(this.commonService.selectString("wf_SQL.getWFURL", setMap));
        model.put("wfURL", url);

        Map setData = new HashMap();
        String srRequestUserID = StringUtil.checkNull(request.getParameter("srRequestUserID"));
        setData.put("memberID", srRequestUserID);
        String srRequestUserInfo = this.commonService.selectString("user_SQL.getMemberTeamInfo", setData);

        model.put("srRequestUserInfo", srRequestUserInfo);
        model.put("srRequestUserID", srRequestUserID);
        model.put("blockSR", request.getParameter("blockSR"));

        setData.put("languageID", languageID);
        setData.put("wfDocType", wfDocType);
        setData.put("wfID", defWFID);
        List wfAllocList = this.commonService.selectList("common_SQL.getMenuURLFromWF2_commonSelect", setData);
        if (wfAllocList.size() == 1) {
          Map wfAllocInfo = (Map)wfAllocList.get(0);
          model.put("wfID", wfAllocInfo.get("CODE"));
          model.put("wfName", wfAllocInfo.get("NAME"));
          model.put("wfUrl", wfAllocInfo.get("WFURL"));
        }
        model.put("wfAllocListCNT", Integer.valueOf(wfAllocList.size()));
      }
      else if ((wfDocType.equals("CS")) && ((isMulti.equals("N")) || (isMultiCnt.equals("1")))) {
        setMap.put("ProjectID", request.getParameter("ProjectID"));
        setMap.put("ChangeSetID", request.getParameter("changeSetID"));
        setMap.put("s_itemID", request.getParameter("itemId"));
        getPJTMap = this.commonService.select("wf_SQL.getChangetSetInfoWF", setMap);
        backFunction = "viewItemChangeInfo.do";
        callbackData = "&changeSetID=" + request.getParameter("changeSetID") + "&screenMode=edit&StatusCode=MOD&isAuthorUser=&LanguageID=" + commandMap.get("sessionCurrLangType");
        backMessage = StringUtil.checkNull(labelMap.get("LN00206"));
        setMap.put("itemTypeCode", getPJTMap.get("ItemTypeCode"));
        setMap.put("itemClassCode", getPJTMap.get("ItemClassCode"));
        String DefWFID = StringUtil.checkNull(this.commonService.selectString("wf_SQL.getDefWFIDForClassCode", setMap));

        model.put("defWFID", DefWFID);
      }

      setMap.put("languageID", commandMap.get("sessionCurrLangType"));
      setMap.put("s_itemID", request.getParameter("ProjectID"));
      model.put("getPJTMap", getPJTMap);

      Map setData = new HashMap();
      if (StringUtil.checkNull(getPJTMap.get("Status")).equals("APRV")) {
        setData.put("ProjectID", request.getParameter("ProjectID"));
        setData.put("Status", "CNG");
        this.commonService.update("project_SQL.updateProject", setData);
      } else if (StringUtil.checkNull(getPJTMap.get("Status")).equals("APRV2")) {
        setData.put("ProjectID", request.getParameter("ProjectID"));
        setData.put("Status", "QA");
        this.commonService.update("project_SQL.updateProject", setData);
      }

      model.put("regionList", regionList);
      model.put("regionList", regionList);
      model.put("getPJTMap", getPJTMap);
      model.put("agrCnt", Integer.valueOf(wfStepInstAGRList.size()));

      model.put("wfStep", wfStep);

      setMap.put("wfDocType", wfDocType);
      String wfDocName = this.commonService.selectString("wf_SQL.getWFDocTypeName", setMap);

      model.put("wfLabel", getLabel(request, this.commonService, "WFSTEP"));
      model.put("menu", labelMap);
      model.put("wfDocName", wfDocName);
      model.put("isNew", isNew);
      model.put("mainMenu", StringUtil.checkNull(request.getParameter("mainMenu"), "1"));
      model.put("ProjectID", projectID);
      model.put("wfDocType", wfDocType);
      model.put("backFunction", backFunction);
      model.put("backMessage", backMessage);
      model.put("callbackData", callbackData);
      model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "1"));
      model.put("changeSetID", StringUtil.checkNull(request.getParameter("changeSetID")));
      model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
      model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
      model.put("fromSR", StringUtil.checkNull(request.getParameter("fromSR")));
      model.put("srID", StringUtil.checkNull(request.getParameter("srID")));
      model.put("newWFInstanceID", newWFInstanceID);

      model.put("seletedTreeId", StringUtil.checkNull(request.getParameter("seletedTreeId")));
      model.put("isItemInfo", StringUtil.checkNull(request.getParameter("isItemInfo")));
    }
    catch (Exception e) {
      System.out.println(e);
      throw new Exception("EM00001");
    }
    return model;
  }
  @RequestMapping({"/mainWorkflowList.do"})
  public String mainWorkflowList(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception {
    try {
      String wfMode = StringUtil.checkNull(request.getParameter("wfMode"));
      String screenType = StringUtil.checkNull(request.getParameter("screenType"));

      model.put("wfMode", wfMode);
      model.put("screenType", screenType);
      model.put("menu", getLabel(request, this.commonService));
    }
    catch (Exception e) {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }

    return nextUrl("/hom/main/wf/mainWorkflowList");
  }
  @RequestMapping({"/mainWFInstList.do"})
  public String mainWorkflowList2(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception {
    try {
      HashMap setData = new HashMap();
      int listSize = Integer.parseInt(request.getParameter("listSize"));
      String wfMode = StringUtil.checkNull(request.getParameter("wfMode"));
      String screenType = StringUtil.checkNull(request.getParameter("screenType"));
      String loginID = String.valueOf(cmmMap.get("sessionUserId"));
      String languageID = String.valueOf(cmmMap.get("sessionCurrLangType"));

      if (!screenType.equals("csrDtl")) {
        setData.put("actorID", loginID);
      }
      setData.put("wfMode", wfMode);
      setData.put("filter", "myWF");
      setData.put("languageID", languageID);
      List workflowList = this.commonService.selectList("wf_SQL.getWFInstList_gridList", setData);

      model.put("wfMode", wfMode);
      model.put("screenType", screenType);
      model.put("menu", getLabel(request, this.commonService));
      model.put("workflowList", workflowList);
      model.put("listSize", Integer.valueOf(listSize));
    }
    catch (Exception e) {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }
    return nextUrl("/hom/main/wf/mainWFInstList");
  }

  @RequestMapping({"/srAprvDetailEmail.do"})
  public String srAprvDetailEmail(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
    Map setMap = new HashMap();
    String url = "/wf/srAprvDetailEmail";
    try {
      String languageID = StringUtil.checkNull(request.getParameter("languageID"));
      String projectID = StringUtil.checkNull(request.getParameter("projectID"));
      String isPop = StringUtil.checkNull(request.getParameter("isPop"));
      String isMulti = StringUtil.checkNull(request.getParameter("isMulti"));
      String actionType = StringUtil.checkNull(request.getParameter("actionType"));
      String stepInstID = StringUtil.checkNull(request.getParameter("stepInstID"));
      String actorID = StringUtil.checkNull(request.getParameter("actorID"));
      String stepSeq = StringUtil.checkNull(request.getParameter("stepSeq"));
      String wfInstanceID = StringUtil.checkNull(request.getParameter("wfInstanceID"));
      String wfID = StringUtil.checkNull(request.getParameter("wfID"));
      String documentID = StringUtil.checkNull(request.getParameter("documentID"));
      String srID = StringUtil.checkNull(request.getParameter("srID"));
      String lastSeq = StringUtil.checkNull(request.getParameter("lastSeq"));
      String docCategory = StringUtil.checkNull(request.getParameter("docCategory"));
      String wfMode = StringUtil.checkNull(request.getParameter("wfMode"));
      String aprvMode = StringUtil.checkNull(request.getParameter("aprvMode"));

      cmmMap.put("userID", StringUtil.checkNull(request.getParameter("actorID")));
      String loginID = StringUtil.checkNull(this.commonService.selectString("sr_SQL.getLoginID", cmmMap));

      Map setData = new HashMap();
      setData.put("wfInstanceID", wfInstanceID);
      setData.put("stepInstID", stepInstID);
      setData.put("LanguageID", languageID);
      Map stepInstInfo = this.commonService.select("wf_SQL.getWFStepInstInfoList", setData);

      String stepInstStatus = "";
      if (!stepInstInfo.isEmpty()) {
        stepInstStatus = StringUtil.checkNull(stepInstInfo.get("Status"));
      }
      String msg = MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00165");

      model.put("stepInstStatus", stepInstStatus);
      model.put("msg", msg);
      model.put("srID", srID);
      model.put("userID", loginID);
      model.put("languageID", languageID);

      model.put("projectID", projectID);
      model.put("isPop", isPop);
      model.put("isMulti", isMulti);
      model.put("actionType", actionType);
      model.put("stepInstID", stepInstID);
      model.put("actorID", actorID);
      model.put("stepSeq", stepSeq);
      model.put("wfInstanceID", wfInstanceID);
      model.put("wfID", wfID);
      model.put("documentID", documentID);
      model.put("srID", srID);
      model.put("lastSeq", lastSeq);
      model.put("docCategory", docCategory);
      model.put("wfMode", wfMode);
      model.put("aprvMode", aprvMode);
      model.put("menu", getLabel(request, this.commonService));

      System.out.println(" ## srAprvDetailEmail :" + url + ":actorID:" + actorID);
    } catch (Exception e) {
      System.out.println(e);
    }
    return nextUrl(url);
  }
  @RequestMapping({"/getWFDescription.do"})
  public String getWFDescription(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
    Map target = new HashMap();
    try {
      String wfID = StringUtil.checkNull(cmmMap.get("wfID"));
      String category = StringUtil.checkNull(cmmMap.get("category"));
      Map setData = new HashMap();
      setData.put("languageID", cmmMap.get("sessionCurrLangType"));
      setData.put("typeCode", wfID);
      setData.put("category", category);
      String wfDescription = StringUtil.checkNull(this.commonService.selectString("common_SQL.getDictionaryDescription", setData));

      target.put("SCRIPT", "fnSetWFDescription('" + wfDescription + "')");
    } catch (Exception e) {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }

    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }
}