package xbolt.app.crm.sr.web;

import java.io.File;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.org.json.JSONArray;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.filter.XSSRequestWrapper;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.EmailUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

@Controller
public class SRActionController extends XboltController
{

  @Resource(name="commonService")
  private CommonService commonService;

  @Resource(name="srService")
  private CommonService srService;

  @RequestMapping({"/srMgt.do"})
  public String srMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model)
    throws Exception
  {
    String url = "/app/crm/sr/srMgt";
    try {
      Map setMap = new HashMap();
      String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"), request.getParameter("languageID"));
      String itemID = StringUtil.checkNull(cmmMap.get("s_itemID"), request.getParameter("itemID"));
      String parentId = StringUtil.checkNull(request.getParameter("s_itemID"));
      String srMode = StringUtil.checkNull(request.getParameter("srMode"));
      String screenType = StringUtil.checkNull(cmmMap.get("screenType"), request.getParameter("screenType"));
      String mainType = StringUtil.checkNull(cmmMap.get("mainType"), request.getParameter("mainType"));

      if ((screenType.equals("srRqst")) || (screenType.equals("srDsk")))
      {
        url = "/app/crm/sr/srReqMain";
      }
      model.put("screenType", screenType);
      model.put("srMode", srMode);
      model.put("srType", StringUtil.checkNull(request.getParameter("srType")));
      model.put("crMode", StringUtil.checkNull(request.getParameter("crMode")));
      model.put("srID", StringUtil.checkNull(request.getParameter("srID")));
      model.put("sysCode", StringUtil.checkNull(request.getParameter("sysCode")));
      model.put("parentID", parentId);
      model.put("mainType", mainType);
      model.put("menu", getLabel(request, this.commonService));
    } catch (Exception e) {
      System.out.println(e.toString());
    }
    return nextUrl(url);
  }

  @RequestMapping({"/srList.do"})
  public String srList(HttpServletRequest request, HashMap cmmMap, HashMap commandMap, ModelMap model) throws Exception {
    String url = "/app/crm/sr/srList";
    try {
      String MULTI_COMPANY = GlobalVal.MULTI_COMPANY;
      if (MULTI_COMPANY.equals("Y"))
      {
        url = "/app/crm/sr/srListByCompany";
      }
      String srType = StringUtil.checkNull(cmmMap.get("srType"), request.getParameter("srType"));
      String itemID = StringUtil.checkNull(commandMap.get("s_itemID"), request.getParameter("itemID"));
      String projectID = StringUtil.checkNull(commandMap.get("projectID"), "");
      String srMode = StringUtil.checkNull(request.getParameter("srMode"));

      model.put("refID", projectID);
      model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
      model.put("srStatus", StringUtil.checkNull(request.getParameter("srStatus")));
      model.put("srMode", srMode);
      model.put("srType", srType);

      model.put("projectID", projectID);
      model.put("itemID", itemID);
      model.put("pageNum", StringUtil.checkNull(request.getParameter("pageNum")));

      model.put("menu", getLabel(request, this.commonService));
      model.put("srID", StringUtil.checkNull(request.getParameter("srID")));
      model.put("mainType", StringUtil.checkNull(request.getParameter("mainType")));
      model.put("sysCode", StringUtil.checkNull(request.getParameter("sysCode")));

      model.put("category", StringUtil.checkNull(cmmMap.get("category")));
      model.put("subCategory", StringUtil.checkNull(cmmMap.get("subCategory")));
      model.put("srArea1", StringUtil.checkNull(cmmMap.get("srArea1")));
      model.put("srArea2", StringUtil.checkNull(cmmMap.get("srArea2")));
      model.put("subject", StringUtil.checkNull(cmmMap.get("subject")));
      model.put("status", StringUtil.checkNull(cmmMap.get("status")));
      model.put("receiptUser", StringUtil.checkNull(cmmMap.get("receiptUser")));
      model.put("requestUser", StringUtil.checkNull(cmmMap.get("requestUser")));
      model.put("requestTeam", StringUtil.checkNull(cmmMap.get("requestTeam")));
      model.put("startRegDT", StringUtil.checkNull(cmmMap.get("startRegDT")));
      model.put("endRegDT", StringUtil.checkNull(cmmMap.get("endRegDT")));
      model.put("stSRDueDate", StringUtil.checkNull(cmmMap.get("stSRDueDate")));
      model.put("endSRDueDate", StringUtil.checkNull(cmmMap.get("endSRDueDate")));
      model.put("stCRDueDate", StringUtil.checkNull(cmmMap.get("stCRDueDate")));
      model.put("endCRDueDate", StringUtil.checkNull(cmmMap.get("endCRDueDate")));
      model.put("searchSrCode", StringUtil.checkNull(cmmMap.get("searchSrCode")));
      model.put("srReceiptTeam", StringUtil.checkNull(cmmMap.get("srReceiptTeam")));
      model.put("crReceiptTeam", StringUtil.checkNull(cmmMap.get("crReceiptTeam")));

      if (srMode.equals("mySr"))
        model.put("requstUser", cmmMap.get("sessionUserNm"));
    }
    catch (Exception e)
    {
      System.out.println(e.toString());
    }
    return nextUrl(url);
  }

  @RequestMapping({"/registSR.do"})
  public String registSR(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
    String url = "/app/crm/sr/registSR";
    try {
      List attachFileList = new ArrayList();
      Map setMap = new HashMap();
      String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
      String srType = StringUtil.checkNull(cmmMap.get("srType"), request.getParameter("srType"));
      String parentId = StringUtil.checkNull(request.getParameter("parentID"));

      String path = GlobalVal.FILE_UPLOAD_BASE_DIR + cmmMap.get("sessionUserId");
      if (!path.equals("")) FileUtil.deleteDirectory(path);

      Calendar cal = Calendar.getInstance();
      cal.setTime(new Date(System.currentTimeMillis()));
      String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());

      cal.add(5, 14);
      String defaultDueDate = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());

      cal = Calendar.getInstance();
      cal.add(5, 7);
      String currDateAdd7 = new SimpleDateFormat("yyyyMMdd").format(cal.getTime());

      model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
      model.put("crMode", StringUtil.checkNull(request.getParameter("crMode")));
      model.put("crFilePath", GlobalVal.FILE_UPLOAD_IS_DIR);
      model.put("menu", getLabel(request, this.commonService));
      model.put("pageNum", StringUtil.checkNull(request.getParameter("pageNum"), "1"));
      model.put("thisYmd", thisYmd);
      model.put("defaultDueDate", defaultDueDate);
      model.put("currDateAdd7", currDateAdd7);
      model.put("ParentID", parentId);
      model.put("screenType", StringUtil.checkNull(request.getParameter("screenType"), ""));
      model.put("srType", srType);
      model.put("ProjectID", StringUtil.checkNull(request.getParameter("ProjectID"), ""));
      model.put("srMode", StringUtil.checkNull(request.getParameter("srMode"), ""));

      model.put("category", StringUtil.checkNull(cmmMap.get("category")));
      model.put("srArea1", StringUtil.checkNull(cmmMap.get("srArea1")));
      model.put("srArea2", StringUtil.checkNull(cmmMap.get("srArea2")));
      model.put("subject", StringUtil.checkNull(cmmMap.get("subject")));
      model.put("status", StringUtil.checkNull(cmmMap.get("status")));
      model.put("searchSrCode", StringUtil.checkNull(cmmMap.get("searchSrCode")));
      model.put("subject", StringUtil.checkNull(cmmMap.get("subject")));
      model.put("srReceiptTeam", StringUtil.checkNull(cmmMap.get("srReceiptTeam")));
      model.put("crReceiptTeam", StringUtil.checkNull(cmmMap.get("crReceiptTeam")));

      String sysCode = StringUtil.checkNull(cmmMap.get("sysCode"));
      String proposal = StringUtil.checkNull(cmmMap.get("proposal"));

      if ((!sysCode.equals("")) && (!sysCode.equals("undefined"))) {
        setMap = new HashMap();
        setMap.put("sysCode", sysCode);
        setMap.put("srType", srType);
        setMap.put("languageID", languageID);
        setMap.put("Identifier", sysCode);
        String srArea2 = StringUtil.checkNull(this.commonService.selectString("report_SQL.getItemIdWithIdentifier", setMap));
        setMap.put("srArea2", srArea2);
        Map getSRArea1 = this.commonService.select("common_SQL.getSrArea2_commonSelect", setMap);

        if (getSRArea1 != null)
          model.put("getSRArea1", getSRArea1.get("itemID"));
        else
          model.put("getSRArea1", "");
        model.put("getSRArea2", srArea2);
        model.put("sysCode", sysCode);
        model.put("proposal", proposal);
      }

      setInitProcLog(request);
    }
    catch (Exception e) {
      System.out.println(e.toString());
    }
    return nextUrl(url);
  }
  @RequestMapping({"/saveNewSr.do"})
  public String saveNewCr(MultipartHttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    XSSRequestWrapper xss = new XSSRequestWrapper(request);
    try {
      HashMap setData = new HashMap();
      HashMap insertData = new HashMap();
      HashMap updateData = new HashMap();
      HashMap setMap = new HashMap();

      String maxSrId = "";
      String curmaxSRCode = "";
      String maxSRCode = "";
      String userID = "";
      String proposal = StringUtil.checkNull(xss.getParameter("proposal"));
      String srMode = StringUtil.checkNull(xss.getParameter("srMode"));
      String screenType = StringUtil.checkNull(xss.getParameter("screenType"));
      String srType = StringUtil.checkNull(xss.getParameter("srType"));
      String requestUserID = StringUtil.checkNull(xss.getParameter("requestUserID"));
      String srArea1 = StringUtil.checkNull(xss.getParameter("srArea1"));
      String srArea2 = StringUtil.checkNull(xss.getParameter("srArea2"));
      String reqdueDate = StringUtil.checkNull(xss.getParameter("reqdueDate"));
      String category = StringUtil.checkNull(xss.getParameter("category"));
      String subject = StringUtil.checkNull(xss.getParameter("subject"));
      String description = StringUtil.checkNull(commandMap.get("description"));
      String isPublic = StringUtil.checkNull(commandMap.get("isPublic"));
      if (isPublic.equals("on"))
        isPublic = "0";
      else {
        isPublic = "1";
      }
      String emailCode = "SRREQ";

      setData.put("memberID", requestUserID);
      String companyID = StringUtil.checkNull(this.commonService.selectString("sr_SQL.getCompanyID", setData));

      Calendar cal = Calendar.getInstance();
      cal.setTime(new Date(System.currentTimeMillis()));
      String thisYmd = new SimpleDateFormat("yyMMdd").format(cal.getTime());
      setData.put("thisYmd", thisYmd);
      maxSrId = StringUtil.checkNull(this.commonService.selectString("sr_SQL.getMaxSrID", setData)).trim();
      curmaxSRCode = StringUtil.checkNull(this.commonService.selectString("sr_SQL.getMaxSRCode", setData)).trim();
      if (curmaxSRCode.equals("")) {
        maxSRCode = "SR" + thisYmd + "0001";
      } else {
        curmaxSRCode = curmaxSRCode.substring(curmaxSRCode.length() - 4, curmaxSRCode.length());
        int curSRCode = Integer.parseInt(curmaxSRCode) + 1;
        maxSRCode = "SR" + thisYmd + String.format("%04d", new Object[] { Integer.valueOf(curSRCode) });
      }

      setData.put("srArea2", srArea2);
      String projectID = StringUtil.checkNull(this.commonService.selectString("sr_SQL.getProjectIDFromL2", setData)).trim();
      insertData.put("projectID", projectID);
      insertData.put("srID", maxSrId);
      insertData.put("srCode", maxSRCode);
      insertData.put("srType", srType);
      insertData.put("subject", subject);
      insertData.put("description", description);
      insertData.put("status", "REQ");
      insertData.put("category", category);
      insertData.put("requestUserID", requestUserID);
      insertData.put("srArea1", srArea1);
      insertData.put("srArea2", srArea2);
      insertData.put("regUserID", commandMap.get("sessionUserId"));
      insertData.put("regTeamID", commandMap.get("sessionTeamId"));
      insertData.put("reqdueDate", reqdueDate);
      insertData.put("companyID", companyID);
      insertData.put("isPublic", isPublic);

      setData.put("srCatID", category);
      setData.put("srType", srType);
      Map RoleAssignMap = this.commonService.select("sr_SQL.getSRAreaFromSrCat", setData);
      String processType = "";
      if (!RoleAssignMap.isEmpty()) {
        if (RoleAssignMap.get("SRArea").equals("SRArea1"))
          setData.put("srArea", srArea1);
        else {
          setData.put("srArea", srArea2);
        }
        setData.put("RoleType", RoleAssignMap.get("RoleType"));

        processType = StringUtil.checkNull(RoleAssignMap.get("ProcessType"));
      }

      setData.put("userID", requestUserID);
      Map reqTeamInfoMap = this.commonService.select("user_SQL.memberTeamInfo", setData);
      insertData.put("requestTeamID", reqTeamInfoMap.get("TeamID"));

      Map receiptInfoMap = new HashMap();
      setData.put("teamID", reqTeamInfoMap.get("TeamID"));
      setData.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
      if (processType.equals("4")) {
        receiptInfoMap = this.commonService.select("user_SQL.getUserTeamManagerInfo", setData);
        insertData.put("status", "MRV");
        emailCode = "SRMRV";
      } else {
        receiptInfoMap = this.commonService.select("sr_SQL.getSRReceiptUser", setData);
      }

      Map receiverMap = new HashMap();
      List receiverList = new ArrayList();
      if (receiptInfoMap != null) {
        insertData.put("receiptUserID", receiptInfoMap.get("UserID"));
        insertData.put("receiptTeamID", receiptInfoMap.get("TeamID"));
        receiverMap.put("receiptUserID", receiptInfoMap.get("UserID"));
        receiverList.add(0, receiverMap);
      } else {
        insertData.put("receiptUserID", "1");
        setData.put("userID", "1");
        Map recTeamInfoMap = this.commonService.select("user_SQL.memberTeamInfo", setData);
        insertData.put("receiptTeamID", recTeamInfoMap.get("TeamID"));
        receiverMap.put("receiptUserID", "1");
        receiverList.add(0, receiverMap);
      }

      insertData.put("proposal", proposal);
      this.commonService.insert("sr_SQL.insertSR", insertData);

      commandMap.put("projcetID", projectID);
      insertSrFiles(commandMap, maxSrId);

      model.put("screenType", screenType);
      model.put("srMode", srMode);
      model.put("pageNum", StringUtil.checkNull(xss.getParameter("pageNum")));
      model.put("projectID", StringUtil.checkNull(xss.getParameter("projectID")));

      Map setProcMapRst = setProcLog(request, this.commonService, insertData);
      if (setProcMapRst.get("type").equals("FAILE")) {
        System.out.println("SAVE PROC_LOG FAILE Msg : " + StringUtil.checkNull(setProcMapRst.get("msg")));
      }

      setData.put("SRArea", srArea1);
      Map SRArea1RoleAssignMentMap = this.commonService.select("sr_SQL.getSRRoleAssignment", setData);
      String SRArea1RoleAssignMember = StringUtil.checkNull(SRArea1RoleAssignMentMap.get("MemberID"));
      String SRArea1RoleAssignMent = StringUtil.checkNull(SRArea1RoleAssignMentMap.get("RoleType"));
      if ((category.equals("SR5000")) && (SRArea1RoleAssignMent.equals("A"))) {
        receiverMap = new HashMap();
        receiverMap.put("receiptUserID", SRArea1RoleAssignMember);
        receiverMap.put("receiptType", "CC");
        receiverList.add(1, receiverMap);
      }

      insertData.put("receiverList", receiverList);
      Map setMailMapRst = setEmailLog(request, this.commonService, insertData, emailCode);
      System.out.println("setMailMapRst : " + setMailMapRst);

      if (StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")) {
        HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
        setMap.put("srID", maxSrId);
        setMap.put("srType", srType);
        setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
        HashMap cntsMap = (HashMap)this.commonService.select("sr_SQL.getSRInfo", setMap);

        cntsMap.put("userID", insertData.get("receiptUserID"));
        cntsMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
        String receiptLoginID = StringUtil.checkNull(this.commonService.selectString("sr_SQL.getLoginID", cntsMap));
        cntsMap.put("loginID", receiptLoginID);

        Map localMap1 = EmailUtil.sendMail(mailMap, cntsMap, getLabel(request, this.commonService));
      }
      else
      {
        System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : " + StringUtil.checkNull(setMailMapRst.get("msg")));
      }

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
      target.put("SCRIPT", "parent.fnGoSRList();parent.$('#isSubmit').remove();");
    } catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  private void insertSrFiles(HashMap commandMap, String srID) throws ExceptionUtil {
    Map fileMap = new HashMap();
    List fileList = new ArrayList();
    try {
      int seqCnt = Integer.parseInt(this.commonService.selectString("fileMgt_SQL.itemFile_nextVal", commandMap));

      String orginPath = GlobalVal.FILE_UPLOAD_BASE_DIR + StringUtil.checkNull(commandMap.get("sessionUserId")) + "//";
      fileMap.put("fltpCode", "SRDOC");
      String filePath = StringUtil.checkNull(this.commonService.selectString("fileMgt_SQL.getFilePath", fileMap));
      String targetPath = filePath;
      List tmpFileList = FileUtil.copyFiles(orginPath, targetPath);
      if (tmpFileList.size() != 0) {
        for (int i = 0; i < tmpFileList.size(); i++) {
          fileMap = new HashMap();
          HashMap resultMap = (HashMap)tmpFileList.get(i);
          fileMap.put("Seq", Integer.valueOf(seqCnt));
          fileMap.put("DocumentID", srID);
          fileMap.put("DocCategory", "SR");
          fileMap.put("projectID", commandMap.get("projectID"));
          fileMap.put("FileName", resultMap.get("SysFileNm"));
          fileMap.put("FileRealName", resultMap.get("FileNm"));
          fileMap.put("FileSize", resultMap.get("FileSize"));
          fileMap.put("FileMgt", "SR");
          fileMap.put("FltpCode", "SRDOC");
          fileMap.put("userId", commandMap.get("sessionUserId"));
          fileMap.put("RegUserID", commandMap.get("sessionUserId"));
          fileMap.put("LastUser", commandMap.get("sessionUserId"));
          fileMap.put("LanguageID", commandMap.get("sessionCurrLangType"));

          fileMap.put("KBN", "insert");
          fileMap.put("SQLNAME", "fileMgt_SQL.itemFile_insert");
          fileList.add(fileMap);
          seqCnt++;
        }
      }
      if (fileList.size() != 0)
        this.srService.save(fileList, fileMap);
    }
    catch (Exception e) {
      throw new ExceptionUtil(e.toString());
    }
  }

  @RequestMapping({"/viewSRIframe.do"})
  public String viewSRIframe(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
    String url = "/app/crm/sr/viewSRIframe";
    HashMap setData = new HashMap();
    try {
      String srID = StringUtil.checkNull(cmmMap.get("srID"));
      String srType = StringUtil.checkNull(cmmMap.get("srType"));
      String screenType = StringUtil.checkNull(cmmMap.get("screenType"));
      String isPopup = StringUtil.checkNull(cmmMap.get("isPopup"));

      model.put("srID", srID);
      model.put("srType", srType);
      model.put("screenType", screenType);
      model.put("isPopup", isPopup);
      model.put("menu", getLabel(request, this.commonService));
    }
    catch (Exception e) {
      System.out.println(e.toString());
    }
    return nextUrl(url);
  }

  @RequestMapping({"/processSR.do"})
  public String processSR(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
    String url = "/app/crm/sr/viewSR";
    HashMap setData = new HashMap();
    try {
      List attachFileList = new ArrayList();
      Map setMap = new HashMap();
      Map getSRInfo = new HashMap();

      String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
      String srID = StringUtil.checkNull(cmmMap.get("srID"));
      String srType = StringUtil.checkNull(cmmMap.get("srType"));
      String screenType = StringUtil.checkNull(cmmMap.get("screenType"));
      String srMode = StringUtil.checkNull(cmmMap.get("srMode"));
      String pageNum = StringUtil.checkNull(cmmMap.get("pageNum"));
      String srCode = StringUtil.checkNull(cmmMap.get("srCode"));
      String sessionUserID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
      String srStatus = StringUtil.checkNull(cmmMap.get("srStatus"));
      String receiptUserID = StringUtil.checkNull(cmmMap.get("receiptUserID"));
      String projectID = StringUtil.checkNull(cmmMap.get("projectID"));
      String itemID = StringUtil.checkNull(cmmMap.get("itemID"));
      String isPopup = StringUtil.checkNull(cmmMap.get("isPopup"));
      String mainType = StringUtil.checkNull(cmmMap.get("mainType"));

      if (srCode.equals("")) {
        setData.put("srID", srID);
        setData.put("srType", srType);
        setData.put("languageID", languageID);
        getSRInfo = this.commonService.select("sr_SQL.getSRInfo", setData);

        if (!getSRInfo.isEmpty()) {
          srStatus = StringUtil.checkNull(getSRInfo.get("Status"));
          receiptUserID = StringUtil.checkNull(getSRInfo.get("ReceiptUserID"));
        }
      }

      if ((!screenType.equals("srRqst")) && (!screenType.equals("CSR")) && 
        (sessionUserID.equals(receiptUserID)) && 
        ((srStatus.equals("REQ")) || (srStatus.equals("RCV"))) && 
        (!isPopup.equals("Y")))
      {
        url = "/app/crm/sr/processSR";
      }

      if ((mainType.equals("mySRDtl")) && (!srStatus.equals("MRV"))) {
        if (sessionUserID.equals(receiptUserID))
        {
          url = "/app/crm/sr/processSR";
        }
        else
          url = "/app/crm/sr/viewSR";
      }
      else if (mainType.equals("SRDtlView"))
      {
        url = "/app/crm/sr/viewSR";
      }

      Calendar cal = Calendar.getInstance();
      cal.setTime(new Date(System.currentTimeMillis()));
      String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());

      String path = GlobalVal.FILE_UPLOAD_BASE_DIR + cmmMap.get("sessionUserId");
      FileUtil.deleteDirectory(path);

      if ((sessionUserID.equals(receiptUserID)) && (srStatus.equals("REQ"))) {
        setMap.put("srID", srID);
        setMap.put("status", "RCV");
        setMap.put("lastUser", sessionUserID);
        this.commonService.update("sr_SQL.updateSRStatus", setMap);

        Map setProcMapRst = setProcLog(request, this.commonService, setMap);
        if (setProcMapRst.get("type").equals("FAILE")) {
          String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
          System.out.println("Msg : " + Msg);
        }
      }

      setData.put("srID", srID);
      setData.put("srType", srType);
      setData.put("srCode", srCode);
      setData.put("languageID", languageID);
      Map srInfoMap = this.commonService.select("sr_SQL.getSRInfo", setData);

      if ((sessionUserID.equals(receiptUserID)) && (srStatus.equals("REQ")) && (StringUtil.checkNull(srInfoMap.get("Proposal")).equals("01")))
      {
        Map setMailData = new HashMap();

        setMailData.put("EMAILCODE", "PROPS");
        setMailData.put("subject", StringUtil.checkNull(srInfoMap.get("Subject")));

        List receiverList = new ArrayList();
        Map receiverMap = new HashMap();
        receiverMap.put("receiptUserID", StringUtil.checkNull(srInfoMap.get("RequestUserID")));
        receiverList.add(0, receiverMap);
        setMailData.put("receiverList", receiverList);

        Map setMailMapRst = setEmailLog(request, this.commonService, setMailData, "PROPS");
        System.out.println("setMailMapRst( [PRIME -    ȿ     ˸ ] ) : " + setMailMapRst);

        HashMap setMailMap = new HashMap();
        if (StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")) {
          HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
          setMailMap.put("srID", srID);
          setMailMap.put("srType", srType);
          setMailMap.put("languageID", String.valueOf(cmmMap.get("sessionCurrLangType")));
          HashMap cntsMap = (HashMap)this.commonService.select("sr_SQL.getSRInfo", setMailMap);

          cntsMap.put("srID", srID);
          cntsMap.put("teamID", StringUtil.checkNull(srInfoMap.get("RequestTeamID")));
          cntsMap.put("userID", StringUtil.checkNull(srInfoMap.get("RequestUserID")));
          cntsMap.put("languageID", String.valueOf(cmmMap.get("sessionCurrLangType")));
          String requestLoginID = StringUtil.checkNull(this.commonService.selectString("sr_SQL.getLoginID", cntsMap));
          cntsMap.put("loginID", requestLoginID);

          Map resultMailMap = EmailUtil.sendMail(mailMap, cntsMap, getLabel(request, this.commonService));
          System.out.println("SEND EMAIL TYPE:" + resultMailMap + "Msg :" + StringUtil.checkNull(setMailMapRst.get("type")));
        } else {
          System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : " + StringUtil.checkNull(setMailMapRst.get("msg")));
        }

      }

      List prLgInfoList = this.commonService.selectList("sr_SQL.getProLogInfo", setData);
      List srStatusList = this.commonService.selectList("sr_SQL.getSRstatusList", setData);

      attachFileList = this.commonService.selectList("sr_SQL.getSRFileList", setData);

      String csrBtn = "N";
      if ((!StringUtil.checkNull(srInfoMap.get("SubCategory")).equals("")) && 
        (!StringUtil.checkNull(srInfoMap.get("Priority")).equals("")) && 
        (!StringUtil.checkNull(srInfoMap.get("Comment")).equals("")) && 
        (!StringUtil.checkNull(srInfoMap.get("Classification")).equals(""))) {
        csrBtn = "Y";
      }

      setData.put("MemberID", receiptUserID);
      Map authorInfoMap = this.commonService.select("item_SQL.getAuthorInfo", setData);
      model.put("authorInfoMap", authorInfoMap);

      String crCnt = this.commonService.selectString("sr_SQL.getCRCNT", setData);
      model.put("crCnt", crCnt);
      model.put("csrBtn", csrBtn);

      String Description = StringUtil.checkNull(srInfoMap.get("Description")).replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\"");
      String Comment = StringUtil.checkNull(srInfoMap.get("Comment")).replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\"");
      srInfoMap.put("Description", Description);
      srInfoMap.put("Comment", Comment);

      model.put("srInfoMap", srInfoMap);
      model.put("prLgInfoList", prLgInfoList);
      model.put("srStatusList", srStatusList);
      model.put("srFilePath", GlobalVal.FILE_UPLOAD_SR_DIR);
      model.put("SRFiles", attachFileList);
      model.put("screenType", screenType);
      model.put("srMode", srMode);
      model.put("srType", srType);
      model.put("menu", getLabel(request, this.commonService));
      model.put("pageNum", pageNum);
      model.put("thisYmd", thisYmd);
      model.put("projectID", projectID);

      model.put("itemID", itemID);
      model.put("isPopup", isPopup);

      model.put("category", StringUtil.checkNull(cmmMap.get("category")));
      model.put("subCategory", StringUtil.checkNull(cmmMap.get("subCategory")));
      model.put("srArea1", StringUtil.checkNull(cmmMap.get("srArea1")));
      model.put("srArea2", StringUtil.checkNull(cmmMap.get("srArea2")));
      model.put("subject", StringUtil.checkNull(cmmMap.get("subject")));
      model.put("status", StringUtil.checkNull(cmmMap.get("status")));
      model.put("receiptUser", StringUtil.checkNull(cmmMap.get("receiptUser")));
      model.put("requestUser", StringUtil.checkNull(cmmMap.get("requestUser")));
      model.put("requestTeam", StringUtil.checkNull(cmmMap.get("requestTeam")));
      model.put("startRegDT", StringUtil.checkNull(cmmMap.get("startRegDT")));
      model.put("endRegDT", StringUtil.checkNull(cmmMap.get("endRegDT")));
      model.put("stSRDueDate", StringUtil.checkNull(cmmMap.get("stSRDueDate")));
      model.put("endSRDueDate", StringUtil.checkNull(cmmMap.get("endSRDueDate")));
      model.put("stCRDueDate", StringUtil.checkNull(cmmMap.get("stCRDueDate")));
      model.put("endCRDueDate", StringUtil.checkNull(cmmMap.get("endCRDueDate")));
      model.put("searchSrCode", StringUtil.checkNull(cmmMap.get("searchSrCode")));
      model.put("srReceiptTeam", StringUtil.checkNull(cmmMap.get("srReceiptTeam")));
      model.put("crReceiptTeam", StringUtil.checkNull(cmmMap.get("crReceiptTeam")));
      model.put("MULTI_COMPANY", GlobalVal.MULTI_COMPANY);
    } catch (Exception e) {
      System.out.println(e.toString());
    }
    return nextUrl(url);
  }
  @RequestMapping({"/deleteSRFile.do"})
  public String deleteSRFile(HashMap commandMap, ModelMap model) throws Exception {
    Map target = new HashMap();
    try {
      String realFile = StringUtil.checkNull(commandMap.get("realFile"));
      File existFile = new File(realFile);
      if ((existFile.exists()) && (existFile.isFile())) existFile.delete();
      this.commonService.delete("sr_SQL.deleteSRFile", commandMap);

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00075"));
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00076"));
    }
    model.addAttribute("resultMap", target);

    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }
  @RequestMapping({"/saveReceiveSRInfo.do"})
  public String saveReceiveSRInfo(MultipartHttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    XSSRequestWrapper xss = new XSSRequestWrapper(request);
    try {
      HashMap setData = new HashMap();
      HashMap updateData = new HashMap();

      String srMode = StringUtil.checkNull(xss.getParameter("srMode"));
      String screenType = StringUtil.checkNull(xss.getParameter("screenType"));
      String srType = StringUtil.checkNull(xss.getParameter("srType"));
      String srID = StringUtil.checkNull(xss.getParameter("srID"));
      String srArea1 = StringUtil.checkNull(xss.getParameter("srArea1"));
      String srArea2 = StringUtil.checkNull(xss.getParameter("srArea2"));
      String category = StringUtil.checkNull(xss.getParameter("category"));
      String subCategory = StringUtil.checkNull(xss.getParameter("subCategory"));
      String priority = StringUtil.checkNull(xss.getParameter("priority"));
      String comment = StringUtil.checkNull(commandMap.get("comment"));
      String dueDate = StringUtil.checkNull(xss.getParameter("dueDate"));
      String proposal = StringUtil.checkNull(xss.getParameter("proposal"));
      String classification = StringUtil.checkNull(xss.getParameter("classification"));
      String autoSave = StringUtil.checkNull(xss.getParameter("autoSave"));
      String reason = StringUtil.checkNull(xss.getParameter("reason"));

      setData.put("srArea2", srArea2);
      String projectID = StringUtil.checkNull(this.commonService.selectString("sr_SQL.getProjectIDFromL2", setData)).trim();
      updateData.put("projectID", projectID);
      updateData.put("srID", srID);
      updateData.put("srType", srType);
      updateData.put("category", category);
      updateData.put("subCategory", subCategory);
      updateData.put("priority", priority);
      updateData.put("srArea1", srArea1);
      updateData.put("srArea2", srArea2);
      updateData.put("dueDate", dueDate);
      updateData.put("comment", comment);
      updateData.put("proposal", proposal);
      updateData.put("classification", classification);
      updateData.put("lastUser", commandMap.get("sessionUserId"));
      updateData.put("reason", reason);
      this.commonService.update("sr_SQL.updateSR", updateData);

      insertSrFiles(commandMap, srID);

      model.put("screenType", screenType);
      model.put("srMode", srMode);
      model.put("pageNum", StringUtil.checkNull(xss.getParameter("pageNum")));
      model.put("projectID", StringUtil.checkNull(xss.getParameter("projectID")));

      if (autoSave.equals("Y")) {
        target.put("SCRIPT", "parent.fnCallBackAutoSave();$('#isSubmit').remove()");
      } else {
        target.put("SCRIPT", "parent.fnCallBackSR();$('#isSubmit').remove()");
        target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
      }
    } catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  @RequestMapping({"/completionSR.do"})
  public String completionSR(MultipartHttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    XSSRequestWrapper xss = new XSSRequestWrapper(request);
    try {
      HashMap setData = new HashMap();
      HashMap setMap = new HashMap();
      HashMap updateData = new HashMap();

      String srID = StringUtil.checkNull(xss.getParameter("srID"));
      String srCode = StringUtil.checkNull(xss.getParameter("srCode"));
      String memberID = StringUtil.checkNull(xss.getParameter("memberID"));
      String srMode = StringUtil.checkNull(xss.getParameter("srMode"));
      String screenType = StringUtil.checkNull(xss.getParameter("screenType"));
      String srType = StringUtil.checkNull(xss.getParameter("srType"));
      String srArea1 = StringUtil.checkNull(xss.getParameter("srArea1"));
      String srArea2 = StringUtil.checkNull(xss.getParameter("srArea2"));
      String category = StringUtil.checkNull(xss.getParameter("category"));
      String subCategory = StringUtil.checkNull(xss.getParameter("subCategory"));
      String subject = StringUtil.checkNull(xss.getParameter("subject"));
      String priority = StringUtil.checkNull(xss.getParameter("priority"));
      String comment = StringUtil.checkNull(xss.getParameter("comment"));
      String dueDate = StringUtil.checkNull(xss.getParameter("dueDate"));
      String receiptUserID = StringUtil.checkNull(xss.getParameter("receiptUserID"));
      String receiptTeamID = StringUtil.checkNull(xss.getParameter("receiptTeamID"));
      String requestUserID = StringUtil.checkNull(xss.getParameter("requestUserID"));
      String requestTeamID = StringUtil.checkNull(xss.getParameter("requestTeamID"));
      String processType = StringUtil.checkNull(xss.getParameter("processType"));
      String crCnt = StringUtil.checkNull(xss.getParameter("crCnt"));

      setData.put("srArea2", srArea2);
      String projectID = StringUtil.checkNull(this.commonService.selectString("sr_SQL.getProjectIDFromL2", setData)).trim();
      updateData.put("projectID", projectID);
      updateData.put("srID", srID);
      updateData.put("srType", srType);
      updateData.put("srCatID", category);
      updateData.put("subCategory", subCategory);
      updateData.put("priority", priority);
      updateData.put("srArea1", srArea1);
      updateData.put("srArea2", srArea2);
      updateData.put("comment", comment);
      updateData.put("dueDate", dueDate);
      updateData.put("lastUser", commandMap.get("sessionUserId"));
      if (processType.equals("0"))
        updateData.put("status", "CLS");
      else {
        updateData.put("status", "CMP");
      }
      updateData.put("srCode", srCode);

      if (crCnt.equals("0")) {
        updateData.put("ITSMIF", "0");
      }
      this.commonService.update("sr_SQL.updateSR", updateData);

      insertSrFiles(commandMap, srID);

      Map setProcMapRst = setProcLog(request, this.commonService, updateData);

      if (setProcMapRst.get("type").equals("FAILE")) {
        String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
        System.out.println("Msg : " + Msg);
      }

      List receiverList = new ArrayList();
      Map receiverMap = new HashMap();
      receiverMap.put("receiptUserID", requestUserID);
      receiverList.add(0, receiverMap);
      updateData.put("receiverList", receiverList);

      updateData.put("subject", subject);
      Map setMailMapRst = setEmailLog(request, this.commonService, updateData, "SRCMP");
      if (StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")) {
        HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
        setMap.put("srID", srID);
        setMap.put("srType", srType);
        setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
        HashMap cntsMap = (HashMap)this.commonService.select("sr_SQL.getSRInfo", setMap);

        cntsMap.put("srID", srID);
        cntsMap.put("teamID", requestTeamID);
        cntsMap.put("userID", requestUserID);
        cntsMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
        String requestLoginID = StringUtil.checkNull(this.commonService.selectString("sr_SQL.getLoginID", cntsMap));
        cntsMap.put("loginID", requestLoginID);

        Map resultMailMap = EmailUtil.sendMail(mailMap, cntsMap, getLabel(request, this.commonService));
        System.out.println("SEND EMAIL TYPE:" + resultMailMap + "Msg :" + StringUtil.checkNull(setMailMapRst.get("type")));
      } else {
        System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : " + StringUtil.checkNull(setMailMapRst.get("msg")));
      }

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
      target.put("SCRIPT", "parent.fnGoSRList();");
    } catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  @RequestMapping({"/confirmSR.do"})
  public String confirmSR(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    String url = "/app/crm/sr/confirmSR";
    HttpSession session = request.getSession(true);
    try {
      String srID = StringUtil.checkNull(request.getParameter("srID"));
      String screenType = StringUtil.checkNull(request.getParameter("screenType"));
      if (screenType.equals("EMAIL"))
      {
        List attachFileList = new ArrayList();
        Map setData = new HashMap();
        setData.put("srID", srID);
        attachFileList = this.commonService.selectList("sr_SQL.getSRFileList", setData);
        model.put("SRFiles", attachFileList);
        model.put("srFilePath", GlobalVal.FILE_UPLOAD_SR_DIR);
      }

      model.put("srID", srID);
      model.put("screenType", screenType.trim());
      model.put("menu", getLabel(request, this.commonService));
    } catch (Exception e) {
      System.out.println(e.toString());
    }
    return nextUrl(url);
  }
  @RequestMapping({"/saveSRPoint.do"})
  public String saveSRPoint(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    try {
      HashMap setData = new HashMap();
      HashMap updateData = new HashMap();

      String srID = StringUtil.checkNull(request.getParameter("srID"));
      String srPoint = StringUtil.checkNull(request.getParameter("srPoint"));
      String opinion = StringUtil.checkNull(request.getParameter("opinion"));

      updateData.put("srID", srID);
      updateData.put("srPoint", srPoint);
      updateData.put("opinion", opinion);
      updateData.put("status", "CLS");
      updateData.put("lastUser", commandMap.get("sessionUserId"));
      this.commonService.update("sr_SQL.updateSRPoint", updateData);

      Map setProcMapRst = setProcLog(request, this.commonService, updateData);
      System.out.println("setProcMapRst....." + setProcMapRst.get("type"));
      if (setProcMapRst.get("type").equals("FAILE")) {
        String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
        System.out.println("Msg : " + Msg);
      }

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
      target.put("SCRIPT", "fnCallBack();");
    } catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  @RequestMapping({"/registSRCR.do"})
  public String registSRCR(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
    String url = "/app/crm/sr/registSRCR";
    try {
      List attachFileList = new ArrayList();
      Map setMap = new HashMap();
      String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
      String srType = StringUtil.checkNull(cmmMap.get("srType"), request.getParameter("srType"));
      String parentId = StringUtil.checkNull(request.getParameter("parentID"));

      String path = GlobalVal.FILE_UPLOAD_BASE_DIR + cmmMap.get("sessionUserId");
      if (!path.equals("")) FileUtil.deleteDirectory(path);

      Calendar cal = Calendar.getInstance();
      cal.setTime(new Date(System.currentTimeMillis()));
      String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());

      model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
      model.put("crMode", StringUtil.checkNull(request.getParameter("crMode")));
      model.put("crFilePath", GlobalVal.FILE_UPLOAD_IS_DIR);
      model.put("menu", getLabel(request, this.commonService));
      model.put("pageNum", StringUtil.checkNull(request.getParameter("pageNum"), "1"));
      model.put("thisYmd", thisYmd);
      model.put("ParentID", parentId);
      model.put("screenType", StringUtil.checkNull(request.getParameter("screenType"), ""));
      model.put("srType", srType);
      model.put("ProjectID", StringUtil.checkNull(request.getParameter("ProjectID"), ""));

      setInitProcLog(request);
    }
    catch (Exception e) {
      System.out.println(e.toString());
    }
    return nextUrl(url);
  }
  @RequestMapping({"/saveNewSRCR.do"})
  public String saveNewSRCR(MultipartHttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    XSSRequestWrapper xss = new XSSRequestWrapper(request);
    try {
      HashMap setData = new HashMap();
      HashMap insertSRData = new HashMap();
      HashMap insertCRData = new HashMap();
      String maxSrId = "";
      String curmaxSRCode = "";
      String maxSRCode = "";
      String userID = "";
      String maxCrId = "";
      String curmaxCRCode = "";
      String maxCRCode = "";

      String srMode = StringUtil.checkNull(xss.getParameter("srMode"));
      String screenType = StringUtil.checkNull(xss.getParameter("screenType"));
      String srType = StringUtil.checkNull(xss.getParameter("srType"));
      String requestUserID = StringUtil.checkNull(xss.getParameter("requestUserID"));
      String srArea1 = StringUtil.checkNull(xss.getParameter("srArea1"));
      String srArea2 = StringUtil.checkNull(xss.getParameter("srArea2"));
      String category = StringUtil.checkNull(xss.getParameter("category"));
      String subject = StringUtil.checkNull(xss.getParameter("subject"));
      String description = StringUtil.checkNull(xss.getParameter("description"));
      String csrID = StringUtil.checkNull(xss.getParameter("csrID"));

      Calendar cal = Calendar.getInstance();
      cal.setTime(new Date(System.currentTimeMillis()));
      String thisYmd = new SimpleDateFormat("yyMMdd").format(cal.getTime());
      setData.put("thisYmd", thisYmd);
      maxSrId = StringUtil.checkNull(this.commonService.selectString("sr_SQL.getMaxSrID", setData)).trim();
      curmaxSRCode = StringUtil.checkNull(this.commonService.selectString("sr_SQL.getMaxSRCode", setData)).trim();
      if (curmaxSRCode.equals("")) {
        maxSRCode = "SR" + thisYmd + "0001";
      } else {
        curmaxSRCode = curmaxSRCode.substring(curmaxSRCode.length() - 4, curmaxSRCode.length());
        int curSRCode = Integer.parseInt(curmaxSRCode) + 1;
        maxSRCode = "SR" + thisYmd + String.format("%04d", new Object[] { Integer.valueOf(curSRCode) });
      }

      setData.put("srArea2", srArea2);
      String projectID = StringUtil.checkNull(this.commonService.selectString("sr_SQL.getProjectIDFromL2", setData)).trim();
      insertSRData.put("projectID", projectID);
      insertSRData.put("srID", maxSrId);
      insertSRData.put("srCode", maxSRCode);
      insertSRData.put("srType", srType);
      insertSRData.put("subject", subject);
      insertSRData.put("description", description);
      insertSRData.put("status", "CMP");
      insertSRData.put("priority", "01");
      insertSRData.put("category", category);
      insertSRData.put("requestUserID", requestUserID);
      insertSRData.put("srArea1", srArea1);
      insertSRData.put("srArea2", srArea2);
      insertSRData.put("regUserID", commandMap.get("sessionUserId"));
      insertSRData.put("regTeamID", commandMap.get("sessionTeamId"));

      setData.put("srCatID", category);
      setData.put("srType", srType);
      Map RoleAssignMap = this.commonService.select("sr_SQL.getSRAreaFromSrCat", setData);

      if (RoleAssignMap.get("SRArea").equals("SRArea1"))
        setData.put("srArea", srArea1);
      else {
        setData.put("srArea", srArea2);
      }
      setData.put("RoleType", RoleAssignMap.get("RoleType"));
      setData.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
      Map receiptInfoMap = this.commonService.select("sr_SQL.getSRReceiptUser", setData);
      insertSRData.put("receiptUserID", receiptInfoMap.get("UserID"));
      insertSRData.put("receiptTeamID", receiptInfoMap.get("TeamID"));

      setData.put("userID", requestUserID);
      Map reqTeamInfoMap = this.commonService.select("user_SQL.memberTeamInfo", setData);
      insertSRData.put("requestTeamID", reqTeamInfoMap.get("TeamID"));

      this.commonService.insert("sr_SQL.insertSR", insertSRData);

      insertSrFiles(commandMap, maxSrId);

      maxCrId = StringUtil.checkNull(this.commonService.selectString("cr_SQL.getMaxCrID", setData)).trim();
      curmaxCRCode = StringUtil.checkNull(this.commonService.selectString("cr_SQL.getMaxCRCode", setData)).trim();
      if (curmaxCRCode.equals("")) {
        maxCRCode = "CR" + thisYmd + "0001";
      } else {
        curmaxCRCode = curmaxCRCode.substring(curmaxCRCode.length() - 4, curmaxCRCode.length());
        int curCRCode = Integer.parseInt(curmaxCRCode) + 1;
        maxCRCode = "CR" + thisYmd + String.format("%04d", new Object[] { Integer.valueOf(curCRCode) });
      }

      Map setMap = new HashMap();
      setMap.put("crArea2", srArea2);
      setMap.put("languageID", commandMap.get("sessionCurrLangType"));
      String ITSMType = StringUtil.checkNull(this.commonService.selectString("cr_SQL.getITSMType", setMap));

      insertCRData.put("crID", maxCrId);
      insertCRData.put("crCode", maxCRCode);
      insertCRData.put("srID", maxSrId);

      insertCRData.put("projectID", projectID);
      insertCRData.put("Subject", subject);
      insertCRData.put("Description", description);
      insertCRData.put("crArea1", srArea1);
      insertCRData.put("crArea2", srArea2);
      insertCRData.put("status", "CLS");
      insertCRData.put("procOption", "ADV");
      insertCRData.put("priority", "01");

      setData.put("srArea", srArea2);
      setData.put("RoleType", "R");
      setData.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
      Map CRreceiptInfoMap = this.commonService.select("sr_SQL.getSRReceiptUser", setData);
      String CRreceiptID = StringUtil.checkNull(CRreceiptInfoMap.get("UserID"));
      String CRreceiptTeamID = StringUtil.checkNull(CRreceiptInfoMap.get("TeamID"));

      insertCRData.put("receiptID", CRreceiptID);
      insertCRData.put("receiptTeamID", CRreceiptTeamID);

      insertCRData.put("ProcessorID", CRreceiptID);
      insertCRData.put("ProcessorTeamID", CRreceiptTeamID);

      insertCRData.put("ITSMType", ITSMType);
      insertCRData.put("RegUserID", commandMap.get("sessionUserId"));
      insertCRData.put("RegTeamID", commandMap.get("sessionTeamId"));

      insertCRData.put("LastUser", commandMap.get("sessionUserId"));
      this.commonService.insert("cr_SQL.insertCR", insertCRData);

      model.put("screenType", screenType);
      model.put("srMode", srMode);
      model.put("pageNum", StringUtil.checkNull(xss.getParameter("pageNum")));
      model.put("projectID", StringUtil.checkNull(xss.getParameter("projectID")));

      Map setProcMapRst = setProcLog(request, this.commonService, insertSRData);
      if (setProcMapRst.get("type").equals("FAILE")) {
        String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
        System.out.println("Msg : " + Msg);
      }

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
      target.put("SCRIPT", "parent.fnGoSRList();parent.$('#isSubmit').remove();");
    } catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }
  @RequestMapping({"/getReceiptUser.do"})
  public String getReceiptUser(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    try {
      HashMap setData = new HashMap();
      String srArea = StringUtil.checkNull(request.getParameter("srArea"));
      String RoleType = StringUtil.checkNull(request.getParameter("RoleType"));
      setData.put("srArea", srArea);
      setData.put("RoleType", RoleType);
      setData.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
      Map receiptInfoMap = this.commonService.select("sr_SQL.getSRReceiptUser", setData);
      String receiptUserID = "";
      String receiptName = "";
      String receiptTeamID = "";
      if (receiptInfoMap != null) {
        receiptUserID = StringUtil.checkNull(receiptInfoMap.get("UserID"));
        receiptName = StringUtil.checkNull(receiptInfoMap.get("Name"));
        receiptTeamID = StringUtil.checkNull(receiptInfoMap.get("TeamID"));
      }
      target.put("SCRIPT", "fnSetReceiptUser('" + receiptUserID + "','" + receiptTeamID + "','" + receiptName + "');");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }
  @RequestMapping({"/srAreaInfo.do"})
  public String srAreaInfo(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
    Map setMap = new HashMap();

    String url = "/app/crm/sr/srAreaInfo";
    List<Map<String, Object>> srArea1CNTList = new ArrayList();
    try {
      String srType = StringUtil.checkNull(request.getParameter("srType"));
      String screenType = StringUtil.checkNull(request.getParameter("screenType"));
      String srMode = StringUtil.checkNull(request.getParameter("srMode"));
      String pageNum = StringUtil.checkNull(request.getParameter("pageNum"));
      String srCode = StringUtil.checkNull(request.getParameter("srCode"));
      String projectID = StringUtil.checkNull(request.getParameter("projectID"));
      String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
      String filepath = request.getSession().getServletContext().getRealPath("/");

      setMap.put("languageID", languageID);
      setMap.put("srType", srType);
      srArea1CNTList = commonService.selectList("sr_SQL.getSRAreaAuthorInfoCnt", setMap);
      
      List result = new ArrayList();
      List spans = new ArrayList();
      int no = 1;
      
	for(int i=0; i < srArea1CNTList.size(); i++) {
		Map<String, Object> newMap = new java.util.HashMap<>(srArea1CNTList.get(i));
		setMap.put("SRArea1Code", newMap.get("SRArea1Code"));
		
		List<Map<String, Object>> srAreaInfoList = commonService.selectList("sr_SQL.getSRAreaAuthorInfo", setMap);
	    
	    for(int j=0; j < srAreaInfoList.size(); j++) {
	        if(j == 0) newMap.put("id", newMap.get("SRArea1Code"));
	        else newMap.remove("id");
	        Map<String, Object> srAreaInfoMap = new java.util.HashMap<>(srAreaInfoList.get(j));
	        newMap.put("no", no);
	        srAreaInfoMap.putAll(newMap);
	        result.add(srAreaInfoMap);
	        no += 1;
	    }
	    
	    Map nameMap = new HashMap();
	    nameMap.put("row", newMap.get("SRArea1Code"));
	    nameMap.put("column", "SRArea1Name");
	    nameMap.put("rowspan", newMap.get("SRArea1CNT"));
	    spans.add(nameMap);
	    
	    Map authorMap = new HashMap();
	    authorMap.put("row", newMap.get("SRArea1Code"));
	    authorMap.put("column", "AuthorInfo1");
	    authorMap.put("rowspan", newMap.get("SRArea1CNT"));
	    spans.add(authorMap);
	}

	JSONArray gridData = new JSONArray(result);
	model.put("gridData", gridData);
	
	JSONArray spansData = new JSONArray(spans);
	model.put("spansData", spansData);

      model.put("screenType", screenType);
      model.put("srMode", srMode);
      model.put("srType", srType);
      model.put("menu", getLabel(request, this.commonService));
      model.put("pageNum", pageNum);
      model.put("projectID", projectID);
    }
    catch (Exception e) {
      System.out.println(e);
    }
    return nextUrl(url);
  }

  private void setSRAreaInfoXmlData(String filepath, List srArea1CNTList, String xmlFilName, HttpServletRequest request, String languageID) throws ExceptionUtil {
    Map setMap = new HashMap();
    List srAreaInfoList = new ArrayList();
    try {
      String srType = StringUtil.checkNull(request.getParameter("srType"));
      setMap.put("srType", srType);
      setMap.put("languageID", languageID);

      List srAreaInfoResultList = new ArrayList();
      Map countMap = new HashMap();

      for (int i = 0; i < srArea1CNTList.size(); i++) {
        Map rowMap = new HashMap();
        Map srMap = (Map)srArea1CNTList.get(i);

        String rNum = String.valueOf(srMap.get("RNUM"));
        String SRArea1Code = String.valueOf(srMap.get("SRArea1Code"));
        String SRArea1Name = String.valueOf(srMap.get("SRArea1Name"));
        String SRArea1CNT = String.valueOf(srMap.get("SRArea1CNT"));

        rowMap.put("rNum", rNum);
        rowMap.put("SRArea1Code", SRArea1Code);
        rowMap.put("SRArea1Name", SRArea1Name);
        rowMap.put("SRArea1CNT", SRArea1CNT);
        srAreaInfoResultList.add(rowMap);
      }

      DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
      DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

      Document doc = docBuilder.newDocument();
      Element rootElement = doc.createElement("rows");
      doc.appendChild(rootElement);
      int rowId = 1;
      int rowId2 = 1;
      for (int i = 0; i < srAreaInfoResultList.size(); i++)
      {
        Map srRowMap = (Map)srAreaInfoResultList.get(i);
        setMap.put("SRArea1Code", srRowMap.get("SRArea1Code"));
        srAreaInfoList = this.commonService.selectList("sr_SQL.getSRAreaAuthorInfo", setMap);
        for (int j = 0; j < srAreaInfoList.size(); j++) {
          Map srAreaInfoMap = (Map)srAreaInfoList.get(j);

          Element row = doc.createElement("row");
          rootElement.appendChild(row);
          row.setAttribute("id", String.valueOf(rowId2));

          Element cell = doc.createElement("cell");
          cell.appendChild(doc.createTextNode(String.valueOf(rowId2)));
          cell.setAttribute("style", "text-align:center;");
          row.appendChild(cell);
          rowId2++;

          cell = doc.createElement("cell");
          cell.appendChild(doc.createTextNode((String)srRowMap.get("SRArea1Name")));
          cell.setAttribute("rowspan", (String)srRowMap.get("SRArea1CNT"));
          cell.setAttribute("style", "text-align:left;");
          row.appendChild(cell);

          cell = doc.createElement("cell");
          cell.appendChild(doc.createTextNode(StringUtil.checkNull(srAreaInfoMap.get("AuthorInfo1"))));
          cell.setAttribute("rowspan", (String)srRowMap.get("SRArea1CNT"));
          cell.setAttribute("style", "text-align:left;");
          row.appendChild(cell);

          cell = doc.createElement("cell");
          cell.appendChild(doc.createTextNode(StringUtil.checkNull(srAreaInfoMap.get("SRArea2Name"))));
          row.appendChild(cell);

          cell = doc.createElement("cell");
          cell.appendChild(doc.createTextNode(StringUtil.checkNull(srAreaInfoMap.get("AuthorInfo2"))));
          row.appendChild(cell);

          cell = doc.createElement("cell");
          cell.appendChild(doc.createTextNode(StringUtil.checkNull(srAreaInfoMap.get("AuthorInfo3"))));
          row.appendChild(cell);
        }

      }

      TransformerFactory transformerFactory = TransformerFactory.newInstance();
      Transformer transformer = transformerFactory.newTransformer();

      transformer.setOutputProperty("encoding", "UTF-8");
      transformer.setOutputProperty("indent", "yes");
      DOMSource source = new DOMSource(doc);

      StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + xmlFilName)));
      transformer.transform(source, result);
    } catch (Exception e) {
      throw new ExceptionUtil(e.toString());
    }
  }

  @RequestMapping({"/srConfirmFromEmail.do"})
  public String srConfirmFromEmail(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
    Map setMap = new HashMap();

    String url = "/app/crm/sr/srConfirmMaster";
    try {
      String srID = StringUtil.checkNull(request.getParameter("srID"));
      String userID = StringUtil.checkNull(request.getParameter("userID"));
      String teamID = StringUtil.checkNull(request.getParameter("teamID"));
      String languageID = StringUtil.checkNull(request.getParameter("languageID"));
      model.put("srID", srID);
      model.put("userID", userID);
      model.put("teamID", teamID);
      model.put("languageID", languageID);
      model.put("menu", getLabel(request, this.commonService));
    } catch (Exception e) {
      System.out.println(e);
    }
    return nextUrl(url);
  }
  @RequestMapping({"/goTransferSRPop.do"})
  public String goTransferSRPop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
    Map setMap = new HashMap();

    String url = "/app/crm/sr/transferSRPop";
    try {
      String srID = StringUtil.checkNull(request.getParameter("srID"));
      String srType = StringUtil.checkNull(request.getParameter("srType"));
      String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));

      setMap.put("srID", srID);
      setMap.put("languageID", languageID);

      Map srInfoMap = this.commonService.select("sr_SQL.getSRInfo", setMap);
      setMap.put("srCatID", srInfoMap.get("Category"));
      setMap.put("srType", srInfoMap.get("SRType"));
      Map RoleAssignMap = this.commonService.select("sr_SQL.getSRAreaFromSrCat", setMap);

      model.put("srID", srID);
      model.put("srType", srType);
      model.put("srInfoMap", srInfoMap);
      model.put("languageID", languageID);
      model.put("roleType", RoleAssignMap.get("RoleType"));
      model.put("srArea", RoleAssignMap.get("SRArea"));
      model.put("menu", getLabel(request, this.commonService));
    } catch (Exception e) {
      System.out.println(e);
    }
    return nextUrl(url);
  }
  @RequestMapping({"/transferReceiptUser.do"})
  public String transferReceiptUser(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    try {
      HashMap setData = new HashMap();
      HashMap updateData = new HashMap();
      HashMap setMap = new HashMap();

      String srID = StringUtil.checkNull(request.getParameter("srID"));
      String srType = StringUtil.checkNull(request.getParameter("srType"));
      String receiptUserID = StringUtil.checkNull(request.getParameter("receiptUserID"));
      String receiptTeamID = StringUtil.checkNull(request.getParameter("receiptTeamID"));
      String comment = StringUtil.checkNull(request.getParameter("comment"));
      String srArea1 = StringUtil.checkNull(request.getParameter("srArea1"));
      String srArea2 = StringUtil.checkNull(request.getParameter("srArea2"));
      String subject = StringUtil.checkNull(request.getParameter("subject"));
      String transferReason = StringUtil.checkNull(request.getParameter("transferReason"));

      setData.put("srArea2", srArea2);
      String projectID = StringUtil.checkNull(this.commonService.selectString("sr_SQL.getProjectIDFromL2", setData)).trim();
      updateData.put("projectID", projectID);
      updateData.put("receiptUserID", receiptUserID);
      updateData.put("receiptTeamID", receiptTeamID);
      updateData.put("comment", comment);
      updateData.put("srID", srID);
      updateData.put("lastUser", commandMap.get("sessionUserId"));
      updateData.put("srArea1", srArea1);
      updateData.put("srArea2", srArea2);
      updateData.put("status", "REQ");

      this.commonService.insert("sr_SQL.updateSR", updateData);

      updateData.put("subject", subject);
      updateData.put("transferReason", transferReason);
      Map setProcMapRst = setProcLog(request, this.commonService, updateData);
      if (setProcMapRst.get("type").equals("FAILE")) {
        String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
        System.out.println("Msg : " + Msg);
      }

      List receiverList = new ArrayList();
      Map receiverMap = new HashMap();
      receiverMap.put("receiptUserID", receiptUserID);
      receiverList.add(0, receiverMap);
      updateData.put("receiverList", receiverList);

      Map setMailMapRst = setEmailLog(request, this.commonService, updateData, "SRTRP");
      System.out.println("setMailMapRst( SR Transfer ) : " + setMailMapRst);

      if (StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")) {
        HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
        setMap.put("srID", srID);
        setMap.put("srType", srType);
        setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
        HashMap cntsMap = (HashMap)this.commonService.select("sr_SQL.getSRInfo", setMap);

        cntsMap.put("userID", updateData.get("receiptUserID"));
        cntsMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
        String receiptLoginID = StringUtil.checkNull(this.commonService.selectString("sr_SQL.getLoginID", cntsMap));
        cntsMap.put("loginID", receiptLoginID);

        Map resultMailMap = EmailUtil.sendMail(mailMap, cntsMap, getLabel(request, this.commonService));
        System.out.println("SEND EMAIL TYPE:" + resultMailMap + " ,Msg : " + StringUtil.checkNull(setMailMapRst.get("type")));
      } else {
        System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : " + StringUtil.checkNull(setMailMapRst.get("msg")));
      }

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
      target.put("SCRIPT", "parent.fnCallBack();");
    } catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }
  @RequestMapping({"/insertFAQFromSR.do"})
  public String insertFAQFromSR(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    try {
      HashMap setData = new HashMap();
      HashMap insertData = new HashMap();
      HashMap insertFileData = new HashMap();

      String srID = StringUtil.checkNull(cmmMap.get("srID"));
      String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));

      setData.put("srID", srID);
      setData.put("languageID", languageID);
      Map srInfoMap = this.commonService.select("sr_SQL.getSRInfo", setData);
      String BoardID = this.commonService.selectString("board_SQL.boardNextVal", cmmMap);
      String space = "<br><br>------------------------------------------------------------------------------------------ <br><br>";
      insertData.put("BoardMgtID", "2");
      insertData.put("BoardID", BoardID);
      insertData.put("Subject", srInfoMap.get("Subject"));
      insertData.put("Content", StringUtil.checkNull(srInfoMap.get("Description"), "") + space + StringUtil.checkNull(srInfoMap.get("Comment"), ""));
      insertData.put("projectID", srInfoMap.get("ProjectID"));
      insertData.put("itemID", srInfoMap.get("SRArea2"));
      insertData.put("sessionUserId", cmmMap.get("sessionUserId"));
      this.commonService.insert("board_SQL.boardInsert", insertData);

      List attachFileList = new ArrayList();
      attachFileList = this.commonService.selectList("sr_SQL.getSRFileList", setData);

      if (attachFileList.size() > 0) {
        String filePath = GlobalVal.FILE_UPLOAD_SR_DIR;
        for (int i = 0; i < attachFileList.size(); i++) {
          int Seq = Integer.parseInt(this.commonService.selectString("boardFile_SQL.boardFile_nextVal", cmmMap));
          int seqCnt = 0;
          HashMap fileMap = (HashMap)attachFileList.get(i);
          insertFileData.put("BoardID", BoardID);
          insertFileData.put("Seq", Integer.valueOf(Seq + seqCnt));
          insertFileData.put("FileNm", fileMap.get("FileRealName"));
          insertFileData.put("FileRealNm", fileMap.get("FileName"));
          insertFileData.put("FileSize", fileMap.get("FileSize"));
          insertFileData.put("FilePath", filePath);

          this.commonService.insert("boardFile_SQL.boardFile_insert", insertFileData);
        }
      }

      target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }
  @RequestMapping({"/saveSRApproval.do"})
  public String saveProcLogSR(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    try {
      HashMap setData = new HashMap();
      HashMap updateData = new HashMap();
      String srID = StringUtil.checkNull(cmmMap.get("srID"));
      String srType = StringUtil.checkNull(cmmMap.get("srType"));
      String approvalComment = StringUtil.checkNull(cmmMap.get("approvalComment"));

      String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
      setData.put("srID", srID);
      setData.put("srType", srType);
      setData.put("languageID", languageID);
      HashMap srInfoMap = (HashMap)this.commonService.select("sr_SQL.getSRInfo", setData);

      updateData.put("receiptUserID", StringUtil.checkNull(cmmMap.get("receiptUserID")));
      updateData.put("receiptTeamID", StringUtil.checkNull(cmmMap.get("receiptTeamID")));
      updateData.put("srID", srID);
      updateData.put("status", "REQ");
      updateData.put("lastUser", cmmMap.get("sessionUserId"));
      this.commonService.update("sr_SQL.updateSR", updateData);

      updateData.put("subject", srInfoMap.get("Subject"));
      updateData.put("approvalComment", approvalComment);
      Map setProcMapRst = setProcLog(request, this.commonService, updateData);
      if (setProcMapRst.get("type").equals("FAILE")) {
        String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
        System.out.println("Msg : " + Msg);
      }

      List receiverList = new ArrayList();
      Map receiverMap = new HashMap();
      receiverMap.put("receiptUserID", StringUtil.checkNull(cmmMap.get("receiptUserID")));
      receiverList.add(0, receiverMap);
      updateData.put("receiverList", receiverList);

      Map setMailMapRst = setEmailLog(request, this.commonService, updateData, "SRTRP");
      System.out.println("setMailMapRst( Approve SR) : " + setMailMapRst);

      if (StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")) {
        HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");

        srInfoMap.put("userID", updateData.get("receiptUserID"));
        srInfoMap.put("languageID", String.valueOf(cmmMap.get("sessionCurrLangType")));
        String receiptLoginID = StringUtil.checkNull(this.commonService.selectString("sr_SQL.getLoginID", srInfoMap));
        srInfoMap.put("loginID", receiptLoginID);

        Map resultMailMap = EmailUtil.sendMail(mailMap, srInfoMap, getLabel(request, this.commonService));
        System.out.println("SEND EMAIL TYPE:" + resultMailMap + " ,Msg : " + StringUtil.checkNull(setMailMapRst.get("type")));
      } else {
        System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : " + StringUtil.checkNull(setMailMapRst.get("msg")));
      }

      target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
      target.put("SCRIPT", "parent.fnCallBack();");
    } catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }
  @RequestMapping({"/goApproveSRPop.do"})
  public String goProcLogSRPop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
    Map setMap = new HashMap();

    String url = "/app/crm/sr/approveSRPop";
    try {
      String srID = StringUtil.checkNull(request.getParameter("srID"));
      String srType = StringUtil.checkNull(request.getParameter("srType"));
      String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));

      setMap.put("srID", srID);
      setMap.put("languageID", languageID);

      Map srInfoMap = this.commonService.select("sr_SQL.getSRInfo", setMap);
      setMap.put("srCatID", StringUtil.checkNull(srInfoMap.get("Category")));
      setMap.put("srType", StringUtil.checkNull(srInfoMap.get("SRType")));

      String srArea1 = StringUtil.checkNull(srInfoMap.get("SRArea1"));
      String srArea2 = StringUtil.checkNull(srInfoMap.get("SRArea2"));
      Map RoleAssignMap = this.commonService.select("sr_SQL.getSRAreaFromSrCat", setMap);

      String processType = "";
      if (!RoleAssignMap.isEmpty()) {
        if (RoleAssignMap.get("SRArea").equals("SRArea1"))
          setMap.put("srArea", srArea1);
        else {
          setMap.put("srArea", srArea2);
        }
      }
      setMap.put("RoleType", StringUtil.checkNull(RoleAssignMap.get("RoleType")));
      setMap.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
      Map receiptInfoMap = this.commonService.select("sr_SQL.getSRReceiptUser", setMap);
      if (receiptInfoMap != null) {
        model.put("receiptUserID", receiptInfoMap.get("UserID"));
        model.put("receiptName", receiptInfoMap.get("Name"));
        model.put("receiptTeamID", receiptInfoMap.get("TeamID"));
        model.put("receiptTeamName", receiptInfoMap.get("TeamName"));
      } else {
        model.put("receiptUserID", "1");
        setMap.put("userID", "1");
        Map recTeamInfoMap = this.commonService.select("user_SQL.memberTeamInfo", setMap);
        model.put("receiptTeamID", recTeamInfoMap.get("TeamID"));
      }

      model.put("srID", srID);
      model.put("srType", srType);
      model.put("srInfoMap", srInfoMap);
      model.put("languageID", languageID);
      model.put("roleType", RoleAssignMap.get("RoleType"));
      model.put("srArea", RoleAssignMap.get("SRArea"));
      model.put("menu", getLabel(request, this.commonService));
    } catch (Exception e) {
      System.out.println(e);
    }
    return nextUrl(url);
  }
  @RequestMapping({"/updateSRStatus.do"})
  public String updateSRStatus(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    try {
      HashMap setData = new HashMap();
      HashMap updateData = new HashMap();

      String srID = StringUtil.checkNull(cmmMap.get("srID"));
      String status = StringUtil.checkNull(cmmMap.get("status"));

      setData.put("srID", srID);
      setData.put("status", status);
      setData.put("lastUser", StringUtil.checkNull(cmmMap.get("sessionUserId")));
      this.commonService.update("sr_SQL.updateSRStatus", setData);

      target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
      target.put("SCRIPT", "fnCallBack();");
    } catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }
  @RequestMapping({"/mainSRAreaInfo.do"})
  public String mainSRAreaInfo(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
    Map setMap = new HashMap();
    String url = "/hom/main/mainSRAreaInfo";
    List srArea1CNTList2 = new ArrayList();
    try {
      String srType = StringUtil.checkNull(cmmMap.get("srType"));
      String screenType = StringUtil.checkNull(cmmMap.get("screenType"));
      String srMode = StringUtil.checkNull(cmmMap.get("srMode"));
      String pageNum = StringUtil.checkNull(cmmMap.get("pageNum"));
      String srCode = StringUtil.checkNull(cmmMap.get("srCode"));
      String projectID = StringUtil.checkNull(cmmMap.get("projectID"));
      String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
      String filepath = request.getSession().getServletContext().getRealPath("/");

      setMap.put("languageID", languageID);
      setMap.put("srType", srType);
      srArea1CNTList2 = this.commonService.selectList("sr_SQL.getSRAreaAuthorInfoCnt", setMap);
      if (srArea1CNTList2.size() > 0)
      {
        String xmlFilName = "upload/mainSRAreaInfoList.xml";

        File oldFile = new File(filepath + xmlFilName);
        if (oldFile.exists()) {
          oldFile.delete();
        }
        setMainSRAreaInfoXmlData(filepath, srArea1CNTList2, xmlFilName, cmmMap, languageID);
        model.put("xmlFilName", xmlFilName);
      }

      model.put("screenType", screenType);
      model.put("srMode", srMode);
      model.put("srType", srType);
      model.put("menu", getLabel(request, this.commonService));
      model.put("pageNum", pageNum);
      model.put("projectID", projectID);
      model.put("fullScreen", cmmMap.get("fullScreen"));
    }
    catch (Exception e) {
      System.out.println(e);
    }
    return nextUrl(url);
  }

  private void setMainSRAreaInfoXmlData(String filepath, List srArea1CNTList, String xmlFilName, HashMap cmmMap, String languageID) throws ExceptionUtil {
    Map setMap = new HashMap();
    List srAreaInfoList = new ArrayList();
    String srType = StringUtil.checkNull(cmmMap.get("srType"));
    setMap.put("srType", srType);
    setMap.put("languageID", languageID);
    try {
      List srAreaInfoResultList = new ArrayList();
      Map countMap = new HashMap();

      for (int i = 0; i < srArea1CNTList.size(); i++) {
        Map rowMap = new HashMap();
        Map srMap = (Map)srArea1CNTList.get(i);

        String rNum = String.valueOf(srMap.get("RNUM"));
        String SRArea1Code = String.valueOf(srMap.get("SRArea1Code"));
        String SRArea1Name = String.valueOf(srMap.get("SRArea1Name"));
        String SRArea1CNT = String.valueOf(srMap.get("SRArea1CNT"));

        rowMap.put("rNum", rNum);
        rowMap.put("SRArea1Code", SRArea1Code);
        rowMap.put("SRArea1Name", SRArea1Name);
        rowMap.put("SRArea1CNT", SRArea1CNT);
        srAreaInfoResultList.add(rowMap);
      }

      DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
      DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

      Document doc = docBuilder.newDocument();
      Element rootElement = doc.createElement("rows");
      doc.appendChild(rootElement);
      int rowId = 1;
      int rowId2 = 1;
      for (int i = 0; i < srAreaInfoResultList.size(); i++) {
        Map srRowMap = (Map)srAreaInfoResultList.get(i);
        setMap.put("SRArea1Code", srRowMap.get("SRArea1Code"));
        srAreaInfoList = this.commonService.selectList("sr_SQL.getSRAreaAuthorInfo2", setMap);
        for (int j = 0; j < srAreaInfoList.size(); j++) {
          Map srAreaInfoMap = (Map)srAreaInfoList.get(j);

          Element row = doc.createElement("row");
          rootElement.appendChild(row);
          row.setAttribute("id", String.valueOf(rowId2));
          rowId2++;
          Element cell = doc.createElement("cell");

          cell = doc.createElement("cell");
          cell.appendChild(doc.createTextNode((String)srRowMap.get("SRArea1Name")));
          cell.setAttribute("rowspan", (String)srRowMap.get("SRArea1CNT"));
          cell.setAttribute("style", "text-align:left;");
          row.appendChild(cell);

          cell = doc.createElement("cell");
          cell.appendChild(doc.createTextNode(StringUtil.checkNull(srAreaInfoMap.get("SRArea2Name"))));
          row.appendChild(cell);

          cell = doc.createElement("cell");
          cell.appendChild(doc.createTextNode(StringUtil.checkNull(srAreaInfoMap.get("AuthorTeamName3"))));
          cell.setAttribute("style", "text-align:left;");
          row.appendChild(cell);

          cell = doc.createElement("cell");
          cell.appendChild(doc.createTextNode(StringUtil.checkNull(srAreaInfoMap.get("AuthorName3")) + " " + StringUtil.checkNull(srAreaInfoMap.get("Author3Position"))));
          cell.setAttribute("style", "text-align:center;");
          row.appendChild(cell);

          cell = doc.createElement("cell");
          cell.appendChild(doc.createTextNode(StringUtil.checkNull(srAreaInfoMap.get("TelNum3"))));
          cell.setAttribute("style", "text-align:center;");
          row.appendChild(cell);

          cell = doc.createElement("cell");
          cell.appendChild(doc.createTextNode(StringUtil.checkNull(srAreaInfoMap.get("AuthorTeamName2"))));
          cell.setAttribute("style", "text-align:left;");
          row.appendChild(cell);

          cell = doc.createElement("cell");
          cell.appendChild(doc.createTextNode(StringUtil.checkNull(srAreaInfoMap.get("AuthorName2")) + " " + StringUtil.checkNull(srAreaInfoMap.get("Author2Position"))));
          cell.setAttribute("style", "text-align:center;");
          row.appendChild(cell);

          cell = doc.createElement("cell");
          cell.appendChild(doc.createTextNode(StringUtil.checkNull(srAreaInfoMap.get("TelNum2"))));
          cell.setAttribute("style", "text-align:center;");
          row.appendChild(cell);
        }

      }

      TransformerFactory transformerFactory = TransformerFactory.newInstance();
      Transformer transformer = transformerFactory.newTransformer();

      transformer.setOutputProperty("encoding", "UTF-8");
      transformer.setOutputProperty("indent", "yes");
      DOMSource source = new DOMSource(doc);

      StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + xmlFilName)));
      transformer.transform(source, result);
    } catch (Exception e) {
      throw new ExceptionUtil(e.toString());
    }
  }

  @RequestMapping({"/createProposal.do"})
  public String createProposal(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    try {
      HashMap updateData = new HashMap();
      String srID = StringUtil.checkNull(cmmMap.get("srID"));
      String sessionUserID = StringUtil.checkNull(cmmMap.get("sessionUserId"));

      updateData.put("srID", srID);
      updateData.put("lastUser", sessionUserID);
      updateData.put("ITSMIF", "5");

      this.commonService.update("sr_SQL.updateSR", updateData);

      Map setProcMapRst = setProcLog(request, this.commonService, updateData);

      target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
      target.put("SCRIPT", "fnCallBackSR();");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }
  @RequestMapping({"/updateProposal.do"})
  public String updateProposal(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    try {
      HashMap updateData = new HashMap();
      HashMap srInfoMap = new HashMap();
      String srID = StringUtil.checkNull(cmmMap.get("srID"));
      String sessionUserID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
      String srType = StringUtil.checkNull(request.getParameter("srType"));
      String subject = StringUtil.checkNull(request.getParameter("subject"));
      String receiptUserID = StringUtil.checkNull(request.getParameter("receiptUserID"));
      String receiptTeamID = StringUtil.checkNull(request.getParameter("receiptTeamID"));
      String requestUserID = StringUtil.checkNull(request.getParameter("requestUserID"));
      String requestTeamID = StringUtil.checkNull(request.getParameter("requestTeamID"));

      updateData.put("srID", srID);
      updateData.put("lastUser", sessionUserID);
      updateData.put("proposal", "01");
      updateData.put("receiptUserID", StringUtil.checkNull(cmmMap.get("receiptUserID")));
      this.commonService.update("sr_SQL.updateSR", updateData);

      updateData.put("EMAILCODE", "PROPS");
      updateData.put("subject", subject);

      List receiverList = new ArrayList();
      Map receiverMap = new HashMap();
      receiverMap.put("receiptUserID", StringUtil.checkNull(cmmMap.get("requestUserID")));
      receiverList.add(0, receiverMap);
      updateData.put("receiverList", receiverList);

      Map setMailMapRst = setEmailLog(request, this.commonService, updateData, "PROPS");
      System.out.println("setMailMapRst( [PRIME -    ȿ     ˸ ] ) : " + setMailMapRst);

      HashMap setMap = new HashMap();
      if (StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")) {
        HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
        setMap.put("srID", srID);
        setMap.put("srType", srType);
        setMap.put("languageID", String.valueOf(cmmMap.get("sessionCurrLangType")));
        HashMap cntsMap = (HashMap)this.commonService.select("sr_SQL.getSRInfo", setMap);

        cntsMap.put("srID", srID);
        cntsMap.put("teamID", requestTeamID);
        cntsMap.put("userID", requestUserID);
        cntsMap.put("languageID", String.valueOf(cmmMap.get("sessionCurrLangType")));
        String requestLoginID = StringUtil.checkNull(this.commonService.selectString("sr_SQL.getLoginID", cntsMap));
        cntsMap.put("loginID", requestLoginID);

        Map resultMailMap = EmailUtil.sendMail(mailMap, cntsMap, getLabel(request, this.commonService));
        System.out.println("SEND EMAIL TYPE:" + resultMailMap + "Msg :" + StringUtil.checkNull(setMailMapRst.get("type")));
      } else {
        System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : " + StringUtil.checkNull(setMailMapRst.get("msg")));
      }

      target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
      target.put("SCRIPT", "parent.fnCallBackSR();");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }
  @RequestMapping({"/procLogDetail.do"})
  public String procLogDetail(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
    Map setMap = new HashMap();

    String url = "/app/crm/sr/procLogDetail";
    try {
      String srID = StringUtil.checkNull(request.getParameter("PID"));
      String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
      String procSeq = StringUtil.checkNull(cmmMap.get("procSeq"));

      setMap.put("srID", srID);
      setMap.put("languageID", languageID);
      setMap.put("seq", procSeq);
      Map srInfoMap = this.commonService.select("sr_SQL.getSRInfo", setMap);
      Map procLogInfo = this.commonService.select("sr_SQL.getProLogInfo", setMap);

      model.put("srID", srID);
      model.put("srInfoMap", srInfoMap);
      model.put("procLogInfo", procLogInfo);
      model.put("menu", getLabel(request, this.commonService));
    }
    catch (Exception e) {
      System.out.println(e);
    }
    return nextUrl(url);
  }

  @RequestMapping({"/srProcessingStatusReport.do"})
  public String srProcessingStatusReport(HttpServletRequest request, HashMap cmmMap, HashMap commandMap, ModelMap model) throws Exception {
    String url = "/app/crm/sr/srProcessingStatusReport";
    try
    {
      Calendar cal = Calendar.getInstance();
      cal.setTime(new Date(System.currentTimeMillis()));
      String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());

      cal.add(1, -1);
      String defaultDueDate = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());

      model.put("startRegDT", defaultDueDate);
      model.put("endRegDT", thisYmd);
      model.put("menu", getLabel(request, this.commonService));
    } catch (Exception e) {
      System.out.println(e.toString());
    }
    return nextUrl(url);
  }
}