package xbolt.cmm.framework.util;

import java.io.PrintStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import xbolt.cmm.framework.val.GlobalVal;

public class MakeEmailContents
{
  private static String startHTML = "<!doctype html><html><body>";
  private static String endHTML = "</body></html>";
  private static String openTable = "<table style=\"table-layout:fixed;border-bottom:1px solid #000;text-align:center;\" width=\"100%\" border=\"1\" cellpadding=\"0\" cellspacing=\"0\">";
  private static String closeTable = "</table>";
  private static String openTh = " <th style=\"padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;height:25px; \">";
  private static String openThBlue = " <th style=\"padding-left:5px;border-top:1px solid #000;background-color:#e5f2f9;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;height:25px; \">";
  private static String openThColspan6 = " <th style=\"padding-left:10px;border-top:2px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:14px;font-family:¸¼Àº °íµñ;height:25px; \" colspan=6>";
  private static String openTd = "<td style=\"padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;\">";

  private static String openTdColspan3 = "<td style=\"padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;\" colspan=3>";
  private static String openTdColspan5 = "<td style=\"padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;\" colspan=5>";
  private static String openTdColspan5H200 = "<td style=\"height:200px;padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;\" colspan=5>";

  private static String openTdColspan6 = "<td style=\"padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;\" colspan=6>";
  private static String openTdColspan6H200 = "<td style=\"height:200px;padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;\" colspan=6>";

  private static String openTdColspan7 = "<td style=\"padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;\" colspan=7>";
  private static String openTdColspan7H200 = "<td style=\"height:200px;padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;\" colspan=7>";

  private static String openTextarea = "<textarea style=\"width:99%;height:200px;font-family:¸¼Àº °íµñ;\">";
  private static String openTdTxtColspan4 = "<td style=\"padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;\" colspan=4><br>";
  private static String openTdTxtColspan5 = "<td style=\"height:200px;padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;\" colspan=5>";
  private static String openTdTxtColspan6 = "<td style=\"padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;\" colspan=6><br>";

  private static String openTh2 = " <th style=\"padding-left:5px;border-top:1px solid #000;background-color:#f8f5e5;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;height:25px; \">";
  private static String openTd2 = "<td style=\"padding-left:5px;border-top:1px solid #000;background-color:#f8f5e5;color:##000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;\">";
  private static String openTd2Colspan5 = "<td style=\"padding-left:5px;border-top:1px solid #000;background-color:#f8f5e5;color:##000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;\" colspan=5>";
  private static String openTh2Colspan6 = "<th style=\"padding-left:10px;border-top:2px solid #666;background-color:#f8f5e5;color:##000;font-weight:bold;text-align:left;font-size:14px;font-family:¸¼Àº °íµñ;height:25px;; \" colspan=6>";

  private static String newLine = "\r\n";
  private static String openDiv = "<div style=\"text-align:center;padding-top:5px;\">";

  private static String openSpan = "<span style=\"font-family: ¸¼Àº °íµñ; font-size: 12px;\">";
  private static String OLM_SERVER_URL = StringUtil.checkNull(GlobalVal.OLM_SERVER_URL);
  private static String HTML_IMG_DIR = StringUtil.checkNull(GlobalVal.HTML_IMG_DIR);
  private static String GW_LINK_URL = StringUtil.checkNull(GlobalVal.GW_LINK_URL);
  private static String OLM_SERVER_NAME = StringUtil.checkNull(GlobalVal.OLM_SERVER_NAME);
  private static String PROPOSAL_SERVER_URL = StringUtil.checkNull(GlobalVal.PROPOSAL_SERVER_URL);
  private static String openForm = "<form id='mForm' name='mForm' method='post' target='_blank'>";
  private static String endForm = "</form>";
  private static String openInput = "<input type='hidden'";
  private static String includeIBJs = "<script src='" + OLM_SERVER_URL + "/cmm/js/xbolt/inBoundHelper.js' type='text/javascript'></script>";

  public static String makeHTML_SRREQ(HashMap cmmCnts, Map menu)
  {
    String ReqUserNM = StringUtil.checkNull(cmmCnts.get("ReqUserNM"));
    String ReqTeamNM = StringUtil.checkNull(cmmCnts.get("ReqTeamNM"));
    String requestUser = ReqUserNM + "(" + ReqTeamNM + ")";
    String reqdueDate = StringUtil.checkNull(cmmCnts.get("ReqDueDate"));
    String regUserName = StringUtil.checkNull(cmmCnts.get("RegUserName"));
    String regTeamName = StringUtil.checkNull(cmmCnts.get("RegTeamName"));
    String srArea1Name = StringUtil.checkNull(cmmCnts.get("SRArea1Name"));
    String srArea2Name = StringUtil.checkNull(cmmCnts.get("SRArea2Name"));
    String priorityName = StringUtil.checkNull(cmmCnts.get("PriorityName"));
    String categoryName = StringUtil.checkNull(cmmCnts.get("CategoryName"));
    String subCategoryName = StringUtil.checkNull(cmmCnts.get("SubCategoryName"));
    String srCode = StringUtil.checkNull(cmmCnts.get("SRCode"));
    String subject = StringUtil.checkNull(cmmCnts.get("Subject"));
    String description = StringUtil.checkNull(cmmCnts.get("Description")).replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\"");
    String status = StringUtil.checkNull(cmmCnts.get("Status"));
    String srID = StringUtil.checkNull(cmmCnts.get("SRID"));
    String loginID = StringUtil.checkNull(cmmCnts.get("loginID"));
    String languageID = StringUtil.checkNull(cmmCnts.get("languageID"));
    String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
    String LN00025 = StringUtil.checkNull(menu.get("LN00025"));
    String LN00222 = StringUtil.checkNull(menu.get("LN00222"));
    String LN00272 = StringUtil.checkNull(menu.get("LN00272"));
    String LN00002 = StringUtil.checkNull(menu.get("LN00002"));

    String srAreaLabelNM1 = StringUtil.checkNull(cmmCnts.get("SRArea1NM"));
    String srAreaLabelNM2 = StringUtil.checkNull(cmmCnts.get("SRArea2NM"));

    String returnHTML = emailHTMLForm;
    returnHTML = returnHTML.replace("#LN00025#", LN00025);
    returnHTML = returnHTML.replace("#LN00222#", LN00222);
    returnHTML = returnHTML.replace("#LN00272#", LN00272);
    returnHTML = returnHTML.replace("#srAreaLabelNM1#", srAreaLabelNM1);
    returnHTML = returnHTML.replace("#srAreaLabelNM2#", srAreaLabelNM2);
    returnHTML = returnHTML.replace("#LN00002#", LN00002);

    returnHTML = returnHTML.replace("#srCode#", srCode);
    returnHTML = returnHTML.replace("#requestUser#", requestUser);
    returnHTML = returnHTML.replace("#reqdueDate#", reqdueDate);
    returnHTML = returnHTML.replace("#categoryName#", categoryName);
    returnHTML = returnHTML.replace("#srArea1Name#", srArea1Name);
    returnHTML = returnHTML.replace("#srArea2Name#", srArea2Name);
    returnHTML = returnHTML.replace("#subject#", subject);
    returnHTML = returnHTML.replace("#description#", description);
    returnHTML = returnHTML.replace("#OLM_SERVER_URL#", OLM_SERVER_URL);
    returnHTML = returnHTML.replace("#HTML_IMG_DIR#", HTML_IMG_DIR);
    returnHTML = returnHTML.replace("#GW_LINK_URL#", GW_LINK_URL + "?olmLng=" + languageID + "&srID=" + srID + "&mainType=mySRDtl");

    returnHTML = returnHTML + "</body></html>";

    System.out.println(returnHTML);
    return returnHTML;
  }

  public static String makeHTML_SRCMP(HashMap cmmCnts, Map menu)
  {
    String receiptName = StringUtil.checkNull(cmmCnts.get("ReceiptName"));
    String receiptTeamName = StringUtil.checkNull(cmmCnts.get("ReceiptTeamName"));
    String receiptUser = receiptName + "(" + receiptTeamName + ")";
    String completionDT = StringUtil.checkNull(cmmCnts.get("CompletionDT"));
    String regUserName = StringUtil.checkNull(cmmCnts.get("RegUserName"));
    String regTeamName = StringUtil.checkNull(cmmCnts.get("RegTeamName"));
    String srArea1Name = StringUtil.checkNull(cmmCnts.get("SRArea1Name"));
    String srArea2Name = StringUtil.checkNull(cmmCnts.get("SRArea2Name"));
    String priorityName = StringUtil.checkNull(cmmCnts.get("PriorityName"));
    String categoryName = StringUtil.checkNull(cmmCnts.get("CategoryName"));
    String subCategoryName = StringUtil.checkNull(cmmCnts.get("SubCategoryName"));
    String srCode = StringUtil.checkNull(cmmCnts.get("SRCode"));
    String subject = StringUtil.checkNull(cmmCnts.get("Subject"));
    String description = StringUtil.checkNull(cmmCnts.get("Description")).replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\"");
    String status = StringUtil.checkNull(cmmCnts.get("Status"));
    String comment = StringUtil.checkNull(cmmCnts.get("Comment")).replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\"");

    String srID = StringUtil.checkNull(cmmCnts.get("srID"));
    String userID = StringUtil.checkNull(cmmCnts.get("userID"));
    String teamID = StringUtil.checkNull(cmmCnts.get("teamID"));
    String loginID = StringUtil.checkNull(cmmCnts.get("loginID"));
    String languageID = StringUtil.checkNull(cmmCnts.get("languageID"));
    String processType = StringUtil.checkNull(cmmCnts.get("ProcessType"));

    String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
    String LN00129 = StringUtil.checkNull(menu.get("LN00129"));
    String LN00004 = StringUtil.checkNull(menu.get("LN00004"));
    String LN00064 = StringUtil.checkNull(menu.get("LN00064"));
    String LN00272 = StringUtil.checkNull(menu.get("LN00272"));
    String LN00274 = StringUtil.checkNull(menu.get("LN00274"));
    String LN00185 = StringUtil.checkNull(menu.get("LN00185"));
    String LN00002 = StringUtil.checkNull(menu.get("LN00002"));
    String LN00228 = StringUtil.checkNull(menu.get("LN00228"));

    String returnHTML = emailHTMLForm;
    returnHTML = returnHTML.replace("#LN00129#", LN00129);
    returnHTML = returnHTML.replace("#LN00004#", LN00004);
    returnHTML = returnHTML.replace("#LN00064#", LN00064);
    returnHTML = returnHTML.replace("#LN00272#", LN00272);
    returnHTML = returnHTML.replace("#LN00274#", LN00274);
    returnHTML = returnHTML.replace("#LN00185#", LN00185);
    returnHTML = returnHTML.replace("#LN00002#", LN00002);
    returnHTML = returnHTML.replace("#LN00228#", LN00228);

    returnHTML = returnHTML.replace("#srCode#", srCode);
    returnHTML = returnHTML.replace("#receiptUser#", receiptUser);
    returnHTML = returnHTML.replace("#completionDT#", completionDT);
    returnHTML = returnHTML.replace("#categoryName#", categoryName);
    returnHTML = returnHTML.replace("#srArea1Name#", srArea1Name);
    returnHTML = returnHTML.replace("#srArea2Name#", srArea2Name);
    returnHTML = returnHTML.replace("#subject#", subject);
    returnHTML = returnHTML.replace("#description#", description);
    returnHTML = returnHTML.replace("#comment#", comment);
    returnHTML = returnHTML.replace("#OLM_SERVER_URL#", OLM_SERVER_URL);
    returnHTML = returnHTML.replace("#HTML_IMG_DIR#", HTML_IMG_DIR);

    if (!processType.equals("0")) {
      returnHTML = returnHTML + "<div style=\"text-align:center;padding-top:5px;\">";
      returnHTML = returnHTML + "<a href=" + OLM_SERVER_URL + "srConfirmFromEmail.do?srID=" + srID + "&userID=" + loginID + "&languageID=" + languageID + " target=\"_blank\"><b>Confirm<b></a></div>";
    }
    returnHTML = returnHTML + "</body></html>";

    System.out.println(returnHTML);
    return returnHTML;
  }

  public static String makeHTML_CRRCV(HashMap cmmCnts, Map menu)
  {
    String csrName = StringUtil.checkNull(cmmCnts.get("CsrName"));
    String requestUser = StringUtil.checkNull(cmmCnts.get("RegUserName")) + "(" + StringUtil.checkNull(cmmCnts.get("RegTeamName")) + ")";
    String statusNM = StringUtil.checkNull(cmmCnts.get("StatusNM"));
    String regDT = StringUtil.checkNull(cmmCnts.get("RegDT"));
    String crArea1NM = StringUtil.checkNull(cmmCnts.get("CRArea1NM"));
    String crArea2NM = StringUtil.checkNull(cmmCnts.get("CRArea2NM"));
    String priorityNM = StringUtil.checkNull(cmmCnts.get("PriorityNM"));
    String reqDueDate = StringUtil.checkNull(cmmCnts.get("ReqDueDate"));
    String subject = StringUtil.checkNull(cmmCnts.get("Subject"));
    String description = StringUtil.checkNull(cmmCnts.get("Description")).replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\"");
    String srDescription = StringUtil.checkNull(cmmCnts.get("SRDescription")).replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\"");

    String crCode = StringUtil.checkNull(cmmCnts.get("CRCode"));
    String CSRID = StringUtil.checkNull(cmmCnts.get("CSRID"));
    String languageID = StringUtil.checkNull(cmmCnts.get("languageID"));

    String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
    String LN00025 = StringUtil.checkNull(menu.get("LN00025"));
    String LN00027 = StringUtil.checkNull(menu.get("LN00027"));
    String LN00093 = StringUtil.checkNull(menu.get("LN00093"));
    String LN00274 = StringUtil.checkNull(menu.get("LN00274"));
    String LN00185 = StringUtil.checkNull(menu.get("LN00185"));
    String LN00067 = StringUtil.checkNull(menu.get("LN00067"));
    String LN00222 = StringUtil.checkNull(menu.get("LN00222"));
    String LN00002 = StringUtil.checkNull(menu.get("LN00002"));
    String LN00035 = StringUtil.checkNull(menu.get("LN00035"));

    String returnHTML = emailHTMLForm;
    returnHTML = returnHTML.replace("#LN00025#", LN00025);
    returnHTML = returnHTML.replace("#LN00027#", LN00027);
    returnHTML = returnHTML.replace("#LN00093#", LN00093);
    returnHTML = returnHTML.replace("#LN00274#", LN00274);
    returnHTML = returnHTML.replace("#LN00185#", LN00185);
    returnHTML = returnHTML.replace("#LN00067#", LN00067);
    returnHTML = returnHTML.replace("#LN00222#", LN00222);
    returnHTML = returnHTML.replace("#LN00002#", LN00002);
    returnHTML = returnHTML.replace("#LN00035#", LN00035);

    returnHTML = returnHTML.replace("#crCode#", crCode);
    returnHTML = returnHTML.replace("#requestUser#", requestUser);
    returnHTML = returnHTML.replace("#statusNM#", statusNM);
    returnHTML = returnHTML.replace("#regDT#", regDT);
    returnHTML = returnHTML.replace("#crArea1NM#", crArea1NM);
    returnHTML = returnHTML.replace("#crArea2NM#", crArea2NM);
    returnHTML = returnHTML.replace("#priorityNM#", priorityNM);
    returnHTML = returnHTML.replace("#reqDueDate#", reqDueDate);
    returnHTML = returnHTML.replace("#subject#", subject);
    returnHTML = returnHTML.replace("#srDescription#", srDescription);
    returnHTML = returnHTML.replace("#description#", description);

    returnHTML = returnHTML + "<div style=\"text-align:center;padding-top:5px;\">";
    returnHTML = returnHTML + "<a href='" + OLM_SERVER_URL + "olmLink.do?olmLoginid=guest&object=CSR&linkType=id&linkID=" + CSRID + "&languageID=" + languageID + "' target=\"_blank\"><img alt=\"View\" src='" + OLM_SERVER_URL + HTML_IMG_DIR + "btn_email_view.png'></img></a></div>";

    returnHTML = returnHTML + "</body></html>";

    System.out.println(returnHTML);
    return returnHTML;
  }

  public static String makeHTML_APREQ_CSR(Map cmmCnts, String languageID, Map menu)
  {
    String projectID = StringUtil.checkNull(cmmCnts.get("ProjectID"));
    String projectName = StringUtil.checkNull(cmmCnts.get("ProjectName"));
    String projectCode = StringUtil.checkNull(cmmCnts.get("ProjectCode"));
    String path = StringUtil.checkNull(cmmCnts.get("Path"));
    String authorName = StringUtil.checkNull(cmmCnts.get("AuthorName"));
    String authorTeamName = StringUtil.checkNull(cmmCnts.get("TeamName"));
    String startDate = StringUtil.checkNull(cmmCnts.get("StartDate"));
    String dueDate = StringUtil.checkNull(cmmCnts.get("DueDate"));
    String priorityName = StringUtil.checkNull(cmmCnts.get("PriorityName"));
    String description = StringUtil.checkNull(cmmCnts.get("Description")).replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\"");

    String subCategoryNM = StringUtil.checkNull(cmmCnts.get("SubCategoryNM"));
    String srArea1Name = StringUtil.checkNull(cmmCnts.get("SRArea1Name"));
    String srArea2Name = StringUtil.checkNull(cmmCnts.get("SRArea2Name"));
    String ReqUserNM = StringUtil.checkNull(cmmCnts.get("ReqUserNM"));
    String ReqTeamNM = StringUtil.checkNull(cmmCnts.get("ReqTeamNM"));
    String reqDueDate = StringUtil.checkNull(cmmCnts.get("ReqDueDate"));
    String srDescription = StringUtil.checkNull(cmmCnts.get("SRDescription"));
    String srID = StringUtil.checkNull(cmmCnts.get("SRID"));

    String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
    String LN00092 = StringUtil.checkNull(menu.get("LN00092"));
    String LN00289 = StringUtil.checkNull(menu.get("LN00289"));
    String LN00025 = StringUtil.checkNull(menu.get("LN00025"));
    String LN00026 = StringUtil.checkNull(menu.get("LN00026"));
    String LN00274 = StringUtil.checkNull(menu.get("LN00274"));
    String LN00185 = StringUtil.checkNull(menu.get("LN00185"));
    String LN00273 = StringUtil.checkNull(menu.get("LN00273"));

    String returnHTML = emailHTMLForm;
    returnHTML = returnHTML.replace("#LN00092#", LN00092);
    returnHTML = returnHTML.replace("#LN00289#", LN00289);
    returnHTML = returnHTML.replace("#LN00025#", LN00025);
    returnHTML = returnHTML.replace("#LN00026#", LN00026);
    returnHTML = returnHTML.replace("#LN00274#", LN00274);
    returnHTML = returnHTML.replace("#LN00185#", LN00185);
    returnHTML = returnHTML.replace("#LN00273#", LN00273);

    returnHTML = returnHTML.replace("#OLM_SERVER_URL#", OLM_SERVER_URL);
    returnHTML = returnHTML.replace("#languageID#", languageID);
    returnHTML = returnHTML.replace("#projectID#", projectID);
    returnHTML = returnHTML.replace("#ReqUserNM#", ReqUserNM);
    returnHTML = returnHTML.replace("#ReqTeamNM#", ReqTeamNM);
    returnHTML = returnHTML.replace("#reqDueDate#", reqDueDate);

    returnHTML = returnHTML + "<!doctype html><html><body>";
    returnHTML = returnHTML + "<script src='#OLM_SERVER_URL#/cmm/js/xbolt/inBoundHelper.js' type='text/javascript'></script>";
    returnHTML = returnHTML + "<form id='mForm' name='mForm' method='post' target='_blank'>";

    returnHTML = returnHTML + "<input type='hidden' id='olmLoginid' name='olmLoginid' value='guest'/>";
    returnHTML = returnHTML + "<input type='hidden' id='object' name='object' value='itm'/>";
    returnHTML = returnHTML + "<input type='hidden' id='linkType' name='linkType' value='CSR'/>";
    returnHTML = returnHTML + "<input type='hidden' id='ibUrl' name='ibUrl' value='#OLM_SERVER_URL#/olmLink.do'/>";
    returnHTML = returnHTML + "<input type='hidden' id='languageID' name='languageID' value='#languageID#'/>";
    returnHTML = returnHTML + "<input type='hidden' id='linkID' name='linkID' value='#projectID#'/>";

    returnHTML = returnHTML + endForm;
    returnHTML = returnHTML + openTable + newLine;
    returnHTML = returnHTML + "<colgroup><col width=\"13%\"><col width=\"20%\"><col width=\"13%\"><col width=\"20%\"><col width=\"13%\"><col width=\"21%\"></colgroup>" + newLine;

    if (!srID.equals("")) {
      returnHTML = returnHTML + " <tr style=\"display:none;\" > " + newLine;
      returnHTML = returnHTML + "<th style=\"padding-left:10px;border-top:2px solid #666;background-color:#f8f5e5;color:##000;font-weight:bold;text-align:left;font-size:14px;font-family:¸¼Àº °íµñ;height:25px;; \" colspan=6>-&nbsp;#LN00092#&nbsp;#LN00289#</th> " + newLine;
      returnHTML = returnHTML + " </tr>" + newLine;

      returnHTML = returnHTML + " <tr> " + newLine;
      returnHTML = returnHTML + "<th style=\"padding-left:5px;border-top:1px solid #000;background-color:#f8f5e5;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;height:25px; \">#LN00025#</th> " + newLine;
      returnHTML = returnHTML + "<td style=\"padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;\">#ReqUserNM#</td> " + newLine;
      returnHTML = returnHTML + "<th style=\"padding-left:5px;border-top:1px solid #000;background-color:#f8f5e5;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;height:25px; \">#LN00026#</th> " + newLine;
      returnHTML = returnHTML + "<td style=\"padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;\">#ReqTeamNM#</td>" + newLine;
      returnHTML = returnHTML + "<th style=\"padding-left:5px;border-top:1px solid #000;background-color:#f8f5e5;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;height:25px; \">#LN00222#</th> " + newLine;
      returnHTML = returnHTML + "<td style=\"padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;\">#reqDueDate#</td> " + newLine;
      returnHTML = returnHTML + " </tr>" + newLine;

      returnHTML = returnHTML + " <tr> " + newLine;
      returnHTML = returnHTML + openTh2 + "#LN00274#</th> " + newLine;
      returnHTML = returnHTML + openTd + srArea1Name + "</td> " + newLine;
      returnHTML = returnHTML + openTh2 + "#LN00185#</th> " + newLine;
      returnHTML = returnHTML + openTd + srArea2Name + "</td>" + newLine;
      returnHTML = returnHTML + openTh2 + "#LN00273#</th> " + newLine;
      returnHTML = returnHTML + openTd + subCategoryNM + "</td> " + newLine;
      returnHTML = returnHTML + " </tr>" + newLine;

      returnHTML = returnHTML + " <tr> " + newLine;
      returnHTML = returnHTML + openTh2 + StringUtil.checkNull(menu.get("LN00092")) + " " + StringUtil.checkNull(menu.get("LN00035")) + "</th> " + newLine;
      returnHTML = returnHTML + openTdColspan5H200 + srDescription + "</td> " + newLine;
      returnHTML = returnHTML + " </tr>" + newLine;
    }

    returnHTML = returnHTML + " <tr> " + newLine;
    returnHTML = returnHTML + openThColspan6 + "- " + StringUtil.checkNull(menu.get("LN00290")) + " " + StringUtil.checkNull(menu.get("LN00289")) + "</th> " + newLine;
    returnHTML = returnHTML + " </tr>" + newLine;

    returnHTML = returnHTML + " <tr> " + newLine;
    returnHTML = returnHTML + openTh + StringUtil.checkNull(menu.get("LN00004")) + "</th> " + newLine;
    returnHTML = returnHTML + openTd + authorName + "</td> " + newLine;
    returnHTML = returnHTML + openTh + StringUtil.checkNull(menu.get("LN00104")) + "</th> " + newLine;
    returnHTML = returnHTML + openTd + authorTeamName + "</td> " + newLine;
    returnHTML = returnHTML + openTh + StringUtil.checkNull(menu.get("LN00221")) + "</th> " + newLine;
    returnHTML = returnHTML + openTd + dueDate + "</td>" + newLine;

    returnHTML = returnHTML + " </tr>" + newLine;

    returnHTML = returnHTML + " <tr> " + newLine;
    returnHTML = returnHTML + openTh + StringUtil.checkNull(menu.get("LN00002")) + "</th> " + newLine;
    returnHTML = returnHTML + openTdColspan5 + projectName + "</td> " + newLine;
    returnHTML = returnHTML + " </tr>" + newLine;

    returnHTML = returnHTML + " <tr> " + newLine;
    returnHTML = returnHTML + openTh + StringUtil.checkNull(menu.get("LN00290")) + " " + StringUtil.checkNull(menu.get("LN00284")) + "</th> " + newLine;

    returnHTML = returnHTML + openTdColspan5 + description + "</td> " + newLine;
    returnHTML = returnHTML + " </tr>" + newLine;

    returnHTML = returnHTML + closeTable + newLine;

    returnHTML = returnHTML + openDiv;
    returnHTML = returnHTML + "<img alt=\"View\" src='" + OLM_SERVER_URL + HTML_IMG_DIR + "btn_email_view.png' onClick=\"javascript:inBoundBoard()\"></img></div>";
    returnHTML = returnHTML + endHTML + newLine;

    System.out.println(returnHTML);
    return returnHTML;
  }

  public static String makeHTML_APREQ_CS(Map cmmCnts, String languageID, Map menu)
  {
    String wfStepInstInfo = StringUtil.checkNull(cmmCnts.get("wfStepInstInfo"));
    String wfStepInstAGRInfo = StringUtil.checkNull(cmmCnts.get("wfStepInstAGRInfo"));
    String wfStepInstREFInfo = StringUtil.checkNull(cmmCnts.get("wfStepInstREFInfo"));
    String wfStepInstRELInfo = StringUtil.checkNull(cmmCnts.get("wfStepInstRELInfo"));
    String wfStepInstRECInfo = StringUtil.checkNull(cmmCnts.get("wfStepInstRECInfo"));
    Map wfInstInfo = (Map)cmmCnts.get("wfInstInfo");
    Map getPJTMap = (Map)cmmCnts.get("getPJTMap");

    String Description = StringUtil.checkNull(getPJTMap.get("Description"), "");

    List csInstList = (List)cmmCnts.get("csInstList");
    String returnHTML = "";

    returnHTML = returnHTML + startHTML + newLine;
    returnHTML = returnHTML + includeIBJs + newLine;
    returnHTML = returnHTML + "Goto " + OLM_SERVER_NAME + " Login >> My Page >> Approval box." + newLine + "<br>";
    returnHTML = returnHTML + openForm + newLine;
    returnHTML = returnHTML + openTable + newLine;
    returnHTML = returnHTML + "<colgroup><col width=\"12%\"><col width=\"21%\"><col width=\"12%\"><col width=\"20%\"><col width=\"12%\"><col width=\"20%\"></colgroup>" + newLine;

    returnHTML = returnHTML + " <tr> " + newLine;
    returnHTML = returnHTML + openThBlue + StringUtil.checkNull(menu.get("LN00134")) + "&nbsp;No.</th> " + newLine;
    returnHTML = returnHTML + openTd + getPJTMap.get("WFInstanceID") + "</td> " + newLine;
    returnHTML = returnHTML + openThBlue + StringUtil.checkNull(menu.get("LN00091")) + "</th> " + newLine;
    returnHTML = returnHTML + openTd + getPJTMap.get("WFDocType") + "</td> " + newLine;
    returnHTML = returnHTML + openThBlue + StringUtil.checkNull(menu.get("LN00027")) + "</th> " + newLine;
    returnHTML = returnHTML + openTd + wfInstInfo.get("StatusName") + "</td>" + newLine;

    returnHTML = returnHTML + " </tr>" + newLine;

    returnHTML = returnHTML + " <tr> " + newLine;
    returnHTML = returnHTML + openThBlue + StringUtil.checkNull(menu.get("LN00140")) + "</th> " + newLine;
    returnHTML = returnHTML + openTdColspan3 + "&nbsp;" + wfStepInstInfo + "</td> " + newLine;
    returnHTML = returnHTML + openThBlue + StringUtil.checkNull(menu.get("LN00045")) + "</th> " + newLine;
    returnHTML = returnHTML + openTd + "&nbsp;" + wfStepInstRELInfo + "</td>" + newLine;
    returnHTML = returnHTML + " </tr>" + newLine;

    returnHTML = returnHTML + " <tr> " + newLine;
    returnHTML = returnHTML + openThBlue + StringUtil.checkNull(menu.get("LN00245")) + "</th> " + newLine;
    returnHTML = returnHTML + openTdColspan5 + "&nbsp;" + wfStepInstREFInfo + "</td>" + newLine;
    returnHTML = returnHTML + " </tr>" + newLine;

    returnHTML = returnHTML + "<tr>" + newLine;
    returnHTML = returnHTML + openThBlue + StringUtil.checkNull(menu.get("LN00002")) + "</th> " + newLine;
    returnHTML = returnHTML + openTdColspan5 + getPJTMap.get("Subject") + "</td> " + newLine;
    returnHTML = returnHTML + " </tr>" + newLine;

    returnHTML = returnHTML + " <tr> " + newLine;
    returnHTML = returnHTML + openThBlue + StringUtil.checkNull(menu.get("LN00290")) + "</th> " + newLine;
    returnHTML = returnHTML + openTdColspan5H200 + Description.replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\"") + "</td> " + newLine;
    returnHTML = returnHTML + " </tr>" + newLine;

    returnHTML = returnHTML + closeTable + newLine + newLine;

    returnHTML = returnHTML + openTable + newLine;
    returnHTML = returnHTML + "<colgroup><col width=\"5%\"><col width=\"5%\"><col width=\"10%\"><col width=\"24%\"><col width=\"8%\">";
    returnHTML = returnHTML + "<col width=\"8%\"><col width=\"8%\"><col width=\"8%\"></colgroup>" + newLine;

    returnHTML = returnHTML + " <tr> " + newLine;
    returnHTML = returnHTML + openTh + StringUtil.checkNull(menu.get("LN00024")) + "</th> " + newLine;
    returnHTML = returnHTML + openTh + StringUtil.checkNull(menu.get("LN00017")) + "</th> " + newLine;
    returnHTML = returnHTML + openTh + StringUtil.checkNull(menu.get("LN00106")) + "</th> " + newLine;
    returnHTML = returnHTML + openTh + StringUtil.checkNull(menu.get("LN00028")) + "</th> " + newLine;
    returnHTML = returnHTML + openTh + StringUtil.checkNull(menu.get("LN00004")) + "</th> " + newLine;
    returnHTML = returnHTML + openTh + StringUtil.checkNull(menu.get("LN00022")) + "</th> " + newLine;
    returnHTML = returnHTML + openTh + StringUtil.checkNull(menu.get("LN00064")) + "</th> " + newLine;
    returnHTML = returnHTML + openTh + StringUtil.checkNull(menu.get("LN00296")) + "</th> " + newLine;
    returnHTML = returnHTML + " </tr>" + newLine;

    for (int i = 0; i < csInstList.size(); i++) {
      Map tempMap = (Map)csInstList.get(i);
      returnHTML = returnHTML + " <tr style=\"height:26px;\"> " + newLine;

      returnHTML = returnHTML + openTd + StringUtil.checkNull(tempMap.get("RNUM")) + "</td>";
      returnHTML = returnHTML + openTd + StringUtil.checkNull(tempMap.get("Version")) + "</td>";
      returnHTML = returnHTML + openTd + StringUtil.checkNull(tempMap.get("Identifier")) + "</td>";

      returnHTML = returnHTML + openTd + "<span onClick=\"javascript:inBoundBoard()\" style='cursor:pointer;'>" + StringUtil.checkNull(tempMap.get("ItemName")) + "</span></td>";
      returnHTML = returnHTML + openInput + "id='olmLoginid' name='olmLoginid' value='guest'/>";
      returnHTML = returnHTML + openInput + "id='object' name='object' value='itm'/>";
      returnHTML = returnHTML + openInput + "id='linkType' name='linkType' value='id'/>";
      returnHTML = returnHTML + openInput + "id='ibUrl' name='ibUrl' value='" + OLM_SERVER_URL + "/olmChangeSetLink.do'/>";
      returnHTML = returnHTML + openInput + "id='keyID' name='keyID' value='" + StringUtil.checkNull(tempMap.get("ItemID")) + "'/>";
      returnHTML = returnHTML + openInput + "id='linkID' name='linkID' value='" + StringUtil.checkNull(tempMap.get("ChangeSetID")) + "'/>";
      returnHTML = returnHTML + openTd + StringUtil.checkNull(tempMap.get("AuthorName")) + "</td>";
      returnHTML = returnHTML + openTd + StringUtil.checkNull(tempMap.get("ChangeType")) + "</td>";
      returnHTML = returnHTML + openTd + StringUtil.checkNull(tempMap.get("CompletionDT")) + "</td>";
      returnHTML = returnHTML + openTd + StringUtil.checkNull(tempMap.get("ValidFrom")) + "</td>";
      returnHTML = returnHTML + " </tr>";
    }
    returnHTML = returnHTML + closeTable + newLine;

    returnHTML = returnHTML + endForm;

    returnHTML = returnHTML + openDiv;
    returnHTML = returnHTML + endHTML + newLine;

    return returnHTML;
  }

  public static String makeHTML_SRPROPOSAL(Map cmmCnts, String languageID, Map menu)
  {
    String ReqUserNM = StringUtil.checkNull(cmmCnts.get("ReqUserNM"));
    String ReqTeamNM = StringUtil.checkNull(cmmCnts.get("ReqTeamNM"));
    String requestUser = ReqUserNM + "(" + ReqTeamNM + ")";
    String reqdueDate = StringUtil.checkNull(cmmCnts.get("ReqDueDate"));
    String regUserName = StringUtil.checkNull(cmmCnts.get("RegUserName"));
    String regTeamName = StringUtil.checkNull(cmmCnts.get("RegTeamName"));
    String srArea1Name = StringUtil.checkNull(cmmCnts.get("SRArea1Name"));
    String srArea2Name = StringUtil.checkNull(cmmCnts.get("SRArea2Name"));
    String priorityName = StringUtil.checkNull(cmmCnts.get("PriorityName"));
    String categoryName = StringUtil.checkNull(cmmCnts.get("CategoryName"));
    String subCategoryName = StringUtil.checkNull(cmmCnts.get("SubCategoryName"));
    String srCode = StringUtil.checkNull(cmmCnts.get("SRCode"));
    String subject = StringUtil.checkNull(cmmCnts.get("Subject"));
    String status = StringUtil.checkNull(cmmCnts.get("Status"));
    String srID = StringUtil.checkNull(cmmCnts.get("SRID"));
    String loginID = StringUtil.checkNull(cmmCnts.get("loginID"));
    String header = "* ¿äÃ»ÇÏ½Å SR °ÇÀº ¾ÆÀÌµð¾îÁ¦¾È¿¡ ÇØ´çµÇ¾î Á¦¾È ½Ã½ºÅÛ(i-Porta)¿¡ ÀÌ°üÇÏ¿´½À´Ï´Ù. <br>"
						+" Á¦¾È ½Ã½ºÅÛ(i-Porta)¿¡¼­ Á¦¾Èµî·Ï-ÀÓ½Ãº¸°üÇÔ¿¡¼­ È®ÀÎÇÏ½Å ÈÄ ¾ÆÀÌµð¾îÁ¦¾È µî·ÏÇÏ½Ã±â ¹Ù¶ø´Ï´Ù.<br><br>";

    String description = StringUtil.checkNull(cmmCnts.get("Description")).replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\"");

    String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
    String LN00025 = StringUtil.checkNull(menu.get("LN00025"));
    String LN00222 = StringUtil.checkNull(menu.get("LN00222"));
    String LN00272 = StringUtil.checkNull(menu.get("LN00272"));
    String LN00274 = StringUtil.checkNull(menu.get("LN00274"));
    String LN00185 = StringUtil.checkNull(menu.get("LN00185"));
    String LN00002 = StringUtil.checkNull(menu.get("LN00002"));

    String returnHTML = emailHTMLForm;
    returnHTML = returnHTML.replace("#LN00025#", LN00025);
    returnHTML = returnHTML.replace("#LN00222#", LN00222);
    returnHTML = returnHTML.replace("#LN00272#", LN00272);
    returnHTML = returnHTML.replace("#LN00274#", LN00274);
    returnHTML = returnHTML.replace("#LN00185#", LN00185);
    returnHTML = returnHTML.replace("#LN00002#", LN00002);

    returnHTML = returnHTML.replace("#header#", header);
    returnHTML = returnHTML.replace("#srCode#", srCode);
    returnHTML = returnHTML.replace("#requestUser#", requestUser);
    returnHTML = returnHTML.replace("#reqdueDate#", reqdueDate);
    returnHTML = returnHTML.replace("#categoryName#", categoryName);
    returnHTML = returnHTML.replace("#srArea1Name#", srArea1Name);
    returnHTML = returnHTML.replace("#srArea2Name#", srArea2Name);
    returnHTML = returnHTML.replace("#subject#", subject);
    returnHTML = returnHTML.replace("#description#", description);

    returnHTML = returnHTML + "<div style=\"text-align:center;padding-top:5px;\">";

    if (GW_LINK_URL != "") {
      returnHTML = returnHTML + "<a href='" + GW_LINK_URL;
      returnHTML = returnHTML + "?authType=2&destination=" + PROPOSAL_SERVER_URL + "' target=\"_blank\"><img alt=\"View\" src='" + OLM_SERVER_URL + HTML_IMG_DIR + "btn_email_view.png'></img></a></div>";
    }
    else {
      returnHTML = returnHTML + "<a href='" + OLM_SERVER_URL;
      returnHTML = returnHTML + "?authType=2&destination=" + PROPOSAL_SERVER_URL + "' target=\"_blank\"><img alt=\"View\" src='" + OLM_SERVER_URL + HTML_IMG_DIR + "btn_email_view.png'></img></a></div>";
    }
    returnHTML = returnHTML + "</body></html>";

    System.out.println(returnHTML);
    return returnHTML;
  }

  public static String makeHTML_SRREQM(HashMap cmmCnts, Map menu)
  {
    String ProjectID = StringUtil.checkNull(cmmCnts.get("ProjectID"));
    String WFID = StringUtil.checkNull(cmmCnts.get("WFID"));
    String WFInstanceID = StringUtil.checkNull(cmmCnts.get("WFInstanceID"));
    String Path = StringUtil.checkNull(cmmCnts.get("Path"));
    String Comment = StringUtil.checkNull(cmmCnts.get("Comment"));
    String StatusName = StringUtil.checkNull(cmmCnts.get("StatusName"));
    String languageID = StringUtil.checkNull(cmmCnts.get("languageID"));

    String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));

    String returnHTML = emailHTMLForm;

    returnHTML = returnHTML.replace("#WFInstanceID#", WFInstanceID);
    returnHTML = returnHTML.replace("#ProjectID#", ProjectID);
    returnHTML = returnHTML.replace("#Comment#", Comment);
    returnHTML = returnHTML.replace("#OLM_SERVER_URL#", OLM_SERVER_URL);
    returnHTML = returnHTML.replace("#HTML_IMG_DIR#", HTML_IMG_DIR);

    if (GW_LINK_URL != "") {
      returnHTML = returnHTML + "<div style=\"text-align:center;padding-top:5px;\">";
      returnHTML = returnHTML + "<a href='" + GW_LINK_URL;
      returnHTML = returnHTML + "?olmLng=" + languageID + "&mainType=mySRDtl' target=\"_blank\"><img alt=\"View\" src='" + OLM_SERVER_URL + HTML_IMG_DIR + "btn_email_view.png'></img></a></div>";
    }

    returnHTML = returnHTML + "</body></html>";

    System.out.println(returnHTML);
    return returnHTML;
  }

  public static String makeHTML_CSRAPREQ(Map cmmCnts, Map menu)
  {
    String wfStepInstInfo = StringUtil.checkNull(cmmCnts.get("wfStepInstInfo"));
    String wfStepInstAGRInfo = StringUtil.checkNull(cmmCnts.get("wfStepInstAGRInfo"));
    String wfStepInstREFInfo = StringUtil.checkNull(cmmCnts.get("wfStepInstREFInfo"));
    String wfStepInstRELInfo = StringUtil.checkNull(cmmCnts.get("wfStepInstRELInfo"));
    String wfStepInstRECInfo = StringUtil.checkNull(cmmCnts.get("wfStepInstRECInfo"));
    List wfInstList = (List)cmmCnts.get("wfInstList");
    Map wfInstInfo = (Map)cmmCnts.get("wfInstInfo");
    Map getPJTMap = (Map)cmmCnts.get("getPJTMap");
    Map csInstInfo = (Map)cmmCnts.get("csInstMap");

    System.out.println("==wfInstList== " + wfInstList);

    String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
    String LN00134 = StringUtil.checkNull(menu.get("LN00134"));
    String LN00091 = StringUtil.checkNull(menu.get("LN00091"));
    String LN00027 = StringUtil.checkNull(menu.get("LN00027"));
    String LN00140 = StringUtil.checkNull(menu.get("LN00140"));
    String LN00045 = StringUtil.checkNull(menu.get("LN00045"));
    String LN00245 = StringUtil.checkNull(menu.get("LN00245"));
    String LN00117 = StringUtil.checkNull(menu.get("LN00117"));
    String LN00131 = StringUtil.checkNull(menu.get("LN00131"));
    String LN00063 = StringUtil.checkNull(menu.get("LN00063"));
    String LN00221 = StringUtil.checkNull(menu.get("LN00221"));
    String LN00002 = StringUtil.checkNull(menu.get("LN00002"));
    String LN00290 = StringUtil.checkNull(menu.get("LN00290"));
    String LN00042 = StringUtil.checkNull(menu.get("LN00042"));
    String LN00017 = StringUtil.checkNull(menu.get("LN00017"));
    String LN00106 = StringUtil.checkNull(menu.get("LN00106"));
    String LN00028 = StringUtil.checkNull(menu.get("LN00028"));
    String LN00004 = StringUtil.checkNull(menu.get("LN00004"));
    String LN00022 = StringUtil.checkNull(menu.get("LN00022"));
    String LN00013 = StringUtil.checkNull(menu.get("LN00013"));
    String LN00064 = StringUtil.checkNull(menu.get("LN00064"));
    String LN00296 = StringUtil.checkNull(menu.get("LN00296"));

    String ProjectCode = StringUtil.checkNull(getPJTMap.get("ProjectCode"));
    String WFDocType = StringUtil.checkNull(getPJTMap.get("WFDocType"));
    String StatusName = StringUtil.checkNull(wfInstInfo.get("StatusName"));
    String Path = StringUtil.checkNull(getPJTMap.get("Path"));
    String StartDate = StringUtil.checkNull(getPJTMap.get("StartDate"));
    String DueDate = StringUtil.checkNull(getPJTMap.get("DueDate"));
    String ProjectName = StringUtil.checkNull(getPJTMap.get("ProjectName"));
    String Description = StringUtil.checkNull(getPJTMap.get("Description").toString().replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\""));
    String ItemTypeImg = StringUtil.checkNull(csInstInfo.get("ItemTypeImg"));
    String Version = StringUtil.checkNull(csInstInfo.get("Version"));
    String Identifier = StringUtil.checkNull(csInstInfo.get("Identifier"));
    String ItemName = StringUtil.checkNull(csInstInfo.get("ItemName"));
    String AuthorName = StringUtil.checkNull(csInstInfo.get("AuthorName"));
    String ChangeType = StringUtil.checkNull(csInstInfo.get("ChangeType"));
    String CreationTime = StringUtil.checkNull(csInstInfo.get("CreationTime"));
    String CompletionDT = StringUtil.checkNull(csInstInfo.get("CompletionDT"));
    String ApproveDate = StringUtil.checkNull(csInstInfo.get("ApproveDate"));

    String returnHTML = emailHTMLForm;
    returnHTML = returnHTML.replace("#LN00134#", LN00134);
    returnHTML = returnHTML.replace("#LN00091#", LN00091);
    returnHTML = returnHTML.replace("#LN00027#", LN00027);
    returnHTML = returnHTML.replace("#LN00140#", LN00140);
    returnHTML = returnHTML.replace("#LN00045#", LN00045);
    returnHTML = returnHTML.replace("#LN00245#", LN00245);
    returnHTML = returnHTML.replace("#LN00117#", LN00117);
    returnHTML = returnHTML.replace("#LN00131#", LN00131);
    returnHTML = returnHTML.replace("#LN00063#", LN00063);
    returnHTML = returnHTML.replace("#LN00221#", LN00221);
    returnHTML = returnHTML.replace("#LN00002#", LN00002);
    returnHTML = returnHTML.replace("#LN00290#", LN00290);
    returnHTML = returnHTML.replace("#LN00042#", LN00042);
    returnHTML = returnHTML.replace("#LN00017#", LN00017);
    returnHTML = returnHTML.replace("#LN00106#", LN00106);
    returnHTML = returnHTML.replace("#LN00028#", LN00028);
    returnHTML = returnHTML.replace("#LN00004#", LN00004);
    returnHTML = returnHTML.replace("#LN00022#", LN00022);
    returnHTML = returnHTML.replace("#LN00013#", LN00013);
    returnHTML = returnHTML.replace("#LN00064#", LN00064);
    returnHTML = returnHTML.replace("#LN00296#", LN00296);

    returnHTML = returnHTML.replace("#OLM_SERVER_NAME#", OLM_SERVER_NAME);
    returnHTML = returnHTML.replace("#ProjectCode#", ProjectCode);
    returnHTML = returnHTML.replace("#WFDocType#", WFDocType);
    returnHTML = returnHTML.replace("#StatusName#", StatusName);
    returnHTML = returnHTML.replace("#wfStepInstInfo#", wfStepInstInfo);
    returnHTML = returnHTML.replace("#wfStepInstRELInfo#", wfStepInstRELInfo);
    returnHTML = returnHTML.replace("#wfStepInstRECInfo#", wfStepInstRECInfo);
    returnHTML = returnHTML.replace("#Path#", Path);
    returnHTML = returnHTML.replace("#StartDate#", StartDate);
    returnHTML = returnHTML.replace("#DueDate#", DueDate);
    returnHTML = returnHTML.replace("#ProjectName#", ProjectName);
    returnHTML = returnHTML.replace("#Description#", Description);
    returnHTML = returnHTML.replace("#ItemTypeImg", ItemTypeImg);
    returnHTML = returnHTML.replace("#Version#", Version);
    returnHTML = returnHTML.replace("#Identifier#", Identifier);
    returnHTML = returnHTML.replace("#ItemName#", ItemName);
    returnHTML = returnHTML.replace("#AuthorName#", AuthorName);
    returnHTML = returnHTML.replace("#ChangeType#", ChangeType);
    returnHTML = returnHTML.replace("#CreationTime#", CreationTime);
    returnHTML = returnHTML.replace("#CompletionDT#", CompletionDT);
    returnHTML = returnHTML.replace("#ApproveDate#", ApproveDate);

    if ((wfInstInfo.get("DocCategory") != null) && (wfInstInfo.get("DocCategory").equals("CS"))) {
      returnHTML = returnHTML.replaceAll("display:none;", "display:block;");
    }

    System.out.println(returnHTML);
    return returnHTML;
  }

  public static String makeHTML_BRDMAIL(Map cmmCnts, Map menu)
  {
    String subject = StringUtil.checkNull(cmmCnts.get("subject"));
    String content = StringUtil.checkNull(cmmCnts.get("content")).replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\"");

    String EmployeeNum = StringUtil.checkNull(cmmCnts.get("EmployeeNum"));
    String Position = StringUtil.checkNull(cmmCnts.get("Position"));
    String email = StringUtil.checkNull(cmmCnts.get("email"));

    String RegDate = StringUtil.checkNull(cmmCnts.get("RegDate"));
    String itemName = StringUtil.checkNull(cmmCnts.get("itemName"));
    String pLabelName = StringUtil.checkNull(cmmCnts.get("pLabelName"));
    HashMap regUInfo = (HashMap)cmmCnts.get("regUInfo");

    Calendar calendar = Calendar.getInstance();
    Date date = calendar.getTime();
    String today = new SimpleDateFormat("yyyy/MM/dd").format(date);

    String UserNAME = StringUtil.checkNull(regUInfo.get("UserNAME"));
    String TeamName = StringUtil.checkNull(regUInfo.get("TeamName"));
    String Email = StringUtil.checkNull(regUInfo.get("Email"));

    String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
    String LN00212 = StringUtil.checkNull(menu.get("LN00212"));
    String LN00078 = StringUtil.checkNull(menu.get("LN00078"));
    String LN00087 = StringUtil.checkNull(menu.get("LN00087"));
    String LN00002 = StringUtil.checkNull(menu.get("LN00002"));
    String LN00003 = StringUtil.checkNull(menu.get("LN00003"));

    String returnHTML = emailHTMLForm;
    returnHTML = returnHTML.replace("#LN00212#", LN00212);
    returnHTML = returnHTML.replace("#LN00078#", LN00078);
    returnHTML = returnHTML.replace("#LN00087#", LN00087);
    returnHTML = returnHTML.replace("#LN00002#", LN00002);
    returnHTML = returnHTML.replace("#LN00003#", LN00003);

    returnHTML = returnHTML.replace("#UserNAME#", UserNAME);
    returnHTML = returnHTML.replace("#TeamName#", TeamName);
    returnHTML = returnHTML.replace("#Email#", Email);
    returnHTML = returnHTML.replace("#today#", today);
    returnHTML = returnHTML.replace("#itemName#", itemName);
    returnHTML = returnHTML.replace("#subject#", subject);
    returnHTML = returnHTML.replace("#content#", content);
    returnHTML = returnHTML.replace("#OLM_SERVER_URL#", OLM_SERVER_URL);

    System.out.println(returnHTML);
    return returnHTML;
  }

  public static String makeHTML_REQITMRW(Map cmmCnts, Map menu) {
    String subject = StringUtil.checkNull(cmmCnts.get("subject"));
    String content = StringUtil.checkNull(cmmCnts.get("content")).replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\"");

    String EmployeeNum = StringUtil.checkNull(cmmCnts.get("EmployeeNum"));
    String Position = StringUtil.checkNull(cmmCnts.get("Position"));
    String email = StringUtil.checkNull(cmmCnts.get("email"));
    String RegDate = StringUtil.checkNull(cmmCnts.get("RegDate"));
    String itemName = StringUtil.checkNull(cmmCnts.get("itemName"));
    String pLabelName = StringUtil.checkNull(cmmCnts.get("pLabelName"));
    String itemID = StringUtil.checkNull(cmmCnts.get("itemID"));
    String changeSetID = StringUtil.checkNull(cmmCnts.get("changeSetID"));
    String loginID = StringUtil.checkNull(cmmCnts.get("loginID"));
    String boardMgtName = StringUtil.checkNull(cmmCnts.get("boardMgtName"));
    String relTeamMembers = StringUtil.checkNull(cmmCnts.get("relTeamMembers"));
    HashMap regUInfo = (HashMap)cmmCnts.get("regUInfo");

    Calendar calendar = Calendar.getInstance();
    Date date = calendar.getTime();
    String today = new SimpleDateFormat("yyyy/MM/dd").format(date);

    String UserNAME = StringUtil.checkNull(regUInfo.get("UserNAME"));
    String TeamName = StringUtil.checkNull(regUInfo.get("TeamName"));
    String Email = StringUtil.checkNull(regUInfo.get("Email"));

    String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
    String LN00212 = StringUtil.checkNull(menu.get("LN00212"));
    String LN00078 = StringUtil.checkNull(menu.get("LN00078"));
    String LN00087 = StringUtil.checkNull(menu.get("LN00087"));
    String LN00002 = StringUtil.checkNull(menu.get("LN00002"));
    String LN00003 = StringUtil.checkNull(menu.get("LN00003"));
    String LN00323 = StringUtil.checkNull(menu.get("LN00323"));

    String returnHTML = emailHTMLForm;
    returnHTML = returnHTML.replace("#LN00212#", LN00212);
    returnHTML = returnHTML.replace("#LN00078#", LN00078);
    returnHTML = returnHTML.replace("#LN00087#", LN00087);
    returnHTML = returnHTML.replace("#LN00002#", LN00002);
    returnHTML = returnHTML.replace("#LN00003#", LN00003);
    returnHTML = returnHTML.replace("#LN00323#", LN00323);

    returnHTML = returnHTML.replace("#UserNAME#", UserNAME);
    returnHTML = returnHTML.replace("#loginID#", loginID);
    returnHTML = returnHTML.replace("#EmployeeNum#", EmployeeNum);
    returnHTML = returnHTML.replace("#TeamName#", TeamName);
    returnHTML = returnHTML.replace("#Email#", Email);
    returnHTML = returnHTML.replace("#today#", today);
    returnHTML = returnHTML.replace("#itemName#", itemName);
    returnHTML = returnHTML.replace("#subject#", subject);
    returnHTML = returnHTML.replace("#content#", content);
    returnHTML = returnHTML.replace("#boardMgtName#", boardMgtName);
    returnHTML = returnHTML.replace("#relTeamMembers#", relTeamMembers);
    returnHTML = returnHTML.replace("#itemID#", itemID);
    returnHTML = returnHTML.replace("#changeSetID#", changeSetID);
    returnHTML = returnHTML.replace("#OLM_SERVER_URL#", OLM_SERVER_URL);

    System.out.println(returnHTML);
    return returnHTML;
  }

  public static String makeHTML_APRVCLS(Map cmmCnts, Map menu)
  {
    String projectCode = StringUtil.checkNull(cmmCnts.get("ProjectCode"));
    String name = StringUtil.checkNull(cmmCnts.get("ProjectName"));
    String wfInstanceID = StringUtil.checkNull(cmmCnts.get("wfInstanceID"));
    String description = StringUtil.checkNull(cmmCnts.get("emDescription"));
    String returnHTML = "";

    returnHTML = returnHTML + "<!doctype html><html><body>";
    returnHTML = returnHTML + "[" + wfInstanceID + "] " + description;
    returnHTML = returnHTML + "</body></html>";

    System.out.println(returnHTML);
    return returnHTML;
  }

  public static String makeHTML_APRVRJT(Map cmmCnts, Map menu)
  {
    String projectCode = StringUtil.checkNull(cmmCnts.get("ProjectCode"));
    String name = StringUtil.checkNull(cmmCnts.get("ProjectName"));
    String description = StringUtil.checkNull(cmmCnts.get("emDescription"));
    String wfInstanceID = StringUtil.checkNull(cmmCnts.get("wfInstanceID"));
    String returnHTML = "";

    returnHTML = returnHTML + "<!doctype html><html><body>";
    returnHTML = returnHTML + "[" + wfInstanceID + "] " + description;
    returnHTML = returnHTML + "</body></html>";

    System.out.println(returnHTML);
    return returnHTML;
  }

  public static String makeHTML_TERMREG(Map cmmCnts, Map menu)
  {
    String content = StringUtil.checkNull(cmmCnts.get("content")).replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\"");
    String returnHTML = "";

    returnHTML = returnHTML + "<!doctype html><html><body>";
    returnHTML = returnHTML + content;
    returnHTML = returnHTML + "</body></html>";

    System.out.println(returnHTML);
    return returnHTML;
  }

  public static String makeHTML_TERMREL(Map cmmCnts, Map menu)
  {
    String description = StringUtil.checkNull(cmmCnts.get("emDescription")).replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\"");
    String returnHTML = "";

    returnHTML = returnHTML + "<!doctype html><html><body>";
    returnHTML = returnHTML + description;
    returnHTML = returnHTML + "</body></html>";

    System.out.println(returnHTML);
    return returnHTML;
  }

  public static String makeHTML_SCHDL(HashMap cmmCnts, Map menu) {
    String subject = StringUtil.checkNull(cmmCnts.get("Subject"), "");
    String location = StringUtil.checkNull(cmmCnts.get("location"), "");
    String startDT = StringUtil.checkNull(cmmCnts.get("StartDT"), "");
    String endDT = StringUtil.checkNull(cmmCnts.get("EndDT"), "");
    String projectID = StringUtil.checkNull(cmmCnts.get("projectID"), "");
    String projectName = StringUtil.checkNull(cmmCnts.get("projectName"), "");
    String sharerNames = StringUtil.checkNull(cmmCnts.get("sharerNames"), "");
    String docCategoryName = StringUtil.checkNull(cmmCnts.get("docCategoryName"), "");
    String disclScope = StringUtil.checkNull(cmmCnts.get("disclScope"), "");
    String disclScopeName = StringUtil.checkNull(cmmCnts.get("disclScopeName"), "");
    if (disclScope.equals("PJT")) {
      disclScopeName = disclScopeName + " / " + projectName;
    }
    String docNO = StringUtil.checkNull(cmmCnts.get("docNO"), "");
    if (!docNO.equals("")) {
      docCategoryName = docCategoryName + "/" + docNO;
    }
    String content = StringUtil.checkNull(cmmCnts.get("Content")).replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\"");
    String userNm = StringUtil.checkNull(cmmCnts.get("userNm"), "");
    String regDT = StringUtil.checkNull(cmmCnts.get("RegDT"), "");
    String modDT = StringUtil.checkNull(cmmCnts.get("ModDT"), "");
    String alarmOptionName = StringUtil.checkNull(cmmCnts.get("alarmOptionName"), "");
    String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
    String LN00002 = StringUtil.checkNull(menu.get("LN00002"));
    String LN00324 = StringUtil.checkNull(menu.get("LN00324"));
    String LN00325 = StringUtil.checkNull(menu.get("LN00325"));
    String LN00237 = StringUtil.checkNull(menu.get("LN00237"));
    String LN00335 = StringUtil.checkNull(menu.get("LN00335"));
    String LN00091 = StringUtil.checkNull(menu.get("LN00091"));
    String LN00078 = StringUtil.checkNull(menu.get("LN00078"));
    String LN00070 = StringUtil.checkNull(menu.get("LN00070"));
    String LN00212 = StringUtil.checkNull(menu.get("LN00212"));
    String LN00245 = StringUtil.checkNull(menu.get("LN00245"));
    String LN00334 = StringUtil.checkNull(menu.get("LN00334"));
    String LN00336 = StringUtil.checkNull(menu.get("LN00336"));
    String LN00337 = StringUtil.checkNull(menu.get("LN00337"));

    String returnHTML = emailHTMLForm;
    returnHTML = returnHTML.replace("#LN00002#", LN00002);
    returnHTML = returnHTML.replace("#subject#", subject);
    returnHTML = returnHTML.replace("#LN00336#", LN00336);
    returnHTML = returnHTML.replace("#content#", content);
    returnHTML = returnHTML.replace("#LN00237#", LN00237);
    returnHTML = returnHTML.replace("#location#", location);
    returnHTML = returnHTML.replace("#LN00324#", LN00324);
    returnHTML = returnHTML.replace("#StartDT#", startDT);
    returnHTML = returnHTML.replace("#LN00325#", LN00325);
    returnHTML = returnHTML.replace("#EndDT#", endDT);
    returnHTML = returnHTML.replace("#LN00337#", LN00337);
    returnHTML = returnHTML.replace("#disclScopeName#", disclScopeName);
    returnHTML = returnHTML.replace("#LN00334#", LN00334);
    returnHTML = returnHTML.replace("#alarmOptionName#", alarmOptionName);
    returnHTML = returnHTML.replace("#LN00245#", LN00245);
    returnHTML = returnHTML.replace("#sharerNames#", sharerNames);
    returnHTML = returnHTML.replace("#LN00091#", LN00091);
    returnHTML = returnHTML.replace("#docCategoryName#", docCategoryName);
    returnHTML = returnHTML.replace("#LN00078#", LN00078);
    returnHTML = returnHTML.replace("#regDT#", regDT);
    returnHTML = returnHTML.replace("#LN00212#", LN00212);
    returnHTML = returnHTML.replace("#userNm#", userNm);
    returnHTML = returnHTML.replace("#OLM_SERVER_URL#", OLM_SERVER_URL);
    returnHTML = returnHTML.replace("#HTML_IMG_DIR#", HTML_IMG_DIR);
    return returnHTML;
  }

  public static String makeHTML_RQUSRAUTH(HashMap cmmCnts, Map menu) {
    String userNm = StringUtil.checkNull(cmmCnts.get("userNm"), "");
    String userTeamName = StringUtil.checkNull(cmmCnts.get("userTeamName"), "");
    String userEmpNm = StringUtil.checkNull(cmmCnts.get("userEmpNm"), "");
    String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));

    String returnHTML = emailHTMLForm;
    returnHTML = returnHTML.replace("#userNm#", userNm);
    returnHTML = returnHTML.replace("#userTeamName#", userTeamName);
    returnHTML = returnHTML.replace("#userEmpNm#", userEmpNm);
    returnHTML = returnHTML.replace("#OLM_SERVER_URL#", OLM_SERVER_URL);
    returnHTML = returnHTML.replace("#HTML_IMG_DIR#", HTML_IMG_DIR);
    return returnHTML;
  }

 public static String makeHTML_CTR(HashMap cmmCnts, Map menu){
	StringBuffer sb = new StringBuffer();
	String status = String.valueOf(cmmCnts.get("status"));
	String urgencyYN = String.valueOf(cmmCnts.get("urgencyYN"));
	sb.append("<!doctype html>");
	sb.append("<html>");
	sb.append("<body>");
	
	sb.append("<table style='border-bottom:1px solid #000;text-align:center;' width='100%' border='1' cellpadding='0' cellspacing='0'>");
	sb.append("<colgroup>");
	sb.append("<col width='10.4%'>");
	sb.append("<col width='14.6%'>");
	sb.append("<col width='10.4%'>");
	sb.append("<col width='14.6%'>");
	sb.append("<col width='10.4%'>");
	sb.append("<col width='14.6%'>");
	sb.append("</colgroup>");
	sb.append("<tr>");
	sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;height:25px; '>  CTS No. </th>");
	sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;'>");
	sb.append(cmmCnts.get("ctrCode")); 
	sb.append("</td>");
	sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;height:25px; '>  ¾÷¹« ¿µ¿ª </th>");
	sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;'>");
	sb.append(cmmCnts.get("sysArea1NM"));  
	sb.append("</td>");
	sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;height:25px; '>  ½Ã½ºÅÛ </th>");
	sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;'>");
	sb.append(cmmCnts.get("sysArea2NM"));  
	sb.append("</td>");
	sb.append("</tr>");
	
	sb.append("<tr>");
	sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;height:25px; '> ±ä±Þ </th>");
	sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;'>");
	sb.append(cmmCnts.get("urgencyYNName")); 
	sb.append("</td>");
	sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;height:25px; '> »óÅÂ </th>");
	sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;'>");
	sb.append(cmmCnts.get("statusNM"));  
	sb.append("</td>");
	sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;height:25px; '> SCR No. </th>");
	sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;'>");
	sb.append(cmmCnts.get("scrCode"));  
	sb.append("</td>");
	sb.append("</tr>");
	sb.append("</table>");
	sb.append("<br>");
	sb.append("<br>");
	if((status.equals("CTSREQ") && urgencyYN.equals("N")) ||  (status.equals("CTSREQ") && urgencyYN.equals("Y")) ) {
		/* ¿äÃ» ÈÄ */
		sb.append("<table style='border-bottom:1px solid #000;text-align:center;' width='100%' border='1' cellpadding='0' cellspacing='0'>");
		sb.append("<colgroup>");
		sb.append("<col width='14%'>");
		sb.append("<col width='36%'>");
		sb.append("<col width='14%'>");
		sb.append("<col width='36%'>");
		sb.append("</colgroup>");
		sb.append("<tr>");
		sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;height:25px; '>  ¿äÃ»ÀÚ  </th>");
		sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;'>");
		sb.append(cmmCnts.get("regTName"));  
		sb.append("</td>");
		sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;height:25px; '>  ¿äÃ»ÀÏ </th>");
		sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;'>");
		sb.append(cmmCnts.get("regDTM"));  
		sb.append("</td>");
		sb.append("</tr>");
		sb.append("<tr>");
		sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;height:25px; '>  Á¦¸ñ </th>");
		sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;' colspan=3>");
		sb.append(cmmCnts.get("subject"));  
		sb.append("</td>");
		sb.append("</tr>");
		sb.append("<tr>");
		sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;height:25px; '>  ¼³¸í</th>");
		sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;' colspan=3><br>");
		sb.append(cmmCnts.get("Description"));
		sb.append("<br>");
		sb.append("<br>");
		sb.append("</td>");
		sb.append("</tr>");
		sb.append("</table>");
		sb.append("<br>");
		sb.append("<br>");
	}
	
	if(status.equals("CTSREW")) {
		/* °ËÅä ÈÄ */
		sb.append("<table style='border-bottom:1px solid #000;text-align:center;' width='100%' border='1' cellpadding='0' cellspacing='0'>");
		sb.append("<colgroup>");
		sb.append("<col width='14%'>");
		sb.append("<col width='36%'>");
		sb.append("<col width='14%'>");
		sb.append("<col width='36%'>");
		sb.append("</colgroup>");
		sb.append("<tr>");
		sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;height:25px; '>  °ËÅäÀÚ  </th>");
		sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;'>");
		sb.append(cmmCnts.get("reviewerTName"));  
		sb.append("</td>");
		sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;height:25px; '>  °ËÅäÀÏ </th>");
		sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;'>");
		sb.append(cmmCnts.get("reviewDTM"));  
		sb.append("</td>");
		sb.append("</tr>");
		sb.append("<tr>");
		sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;height:25px; '>  °ËÅä ³»¿ë</th>");
		sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;' colspan=3><br>");
		sb.append(cmmCnts.get("rewComment"));
		sb.append("<br>");
		sb.append("<br>");
		sb.append("</td>");
		sb.append("</tr>");
		sb.append("</table>");
		sb.append("<br>");
		sb.append("<br>");
	}
	if(status.equals("CTSAPRV") && cmmCnts.get("aprvStatus") != null) {
	/* ½ÂÀÎ ÈÄ */
		sb.append("<table style='border-bottom:1px solid #000;text-align:center;' width='100%' border='1' cellpadding='0' cellspacing='0'>");
		sb.append("<colgroup>");
		sb.append("<col width='10.4%'>");
		sb.append("<col width='14.6%'>");
		sb.append("<col width='10.4%'>");
		sb.append("<col width='14.6%'>");
		sb.append("<col width='10.4%'>");
		sb.append("<col width='14.6%'>");
		sb.append("</colgroup>");
		sb.append("<tr>");
		sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;height:25px; '>  ½ÂÀÎÀÚ</th>");
		sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;'>");
		sb.append(cmmCnts.get("approverTName")); 
		sb.append("</td>");
		sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;height:25px; '>  ½ÂÀÎ ÀÏÀÚ </th>");
		sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;'>");
		sb.append(cmmCnts.get("approvalDTM"));  
		sb.append("</td>");
		sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;height:25px; '>  ½ÂÀÎ/°ÅÀý </th>");
		sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;'>");
		sb.append(cmmCnts.get("aprvStatusNM"));  
		sb.append("</td>");
		sb.append("</tr>");
		sb.append("<tr>");
		sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;height:25px; '> ½ÂÀÎ ³»¿ë </th>");
		sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;' colspan=5><br>");
		sb.append(cmmCnts.get("aprvComment"));
		sb.append("<br>");
		sb.append("<br>");
		sb.append("</td>");
		sb.append("</tr>");
		sb.append("</table>");
		sb.append("<br>");
		sb.append("<br>");
	}
	if(status.equals("CTSCLS") || (status.equals("CTSCMP") && urgencyYN.equals("Y"))) {
		/* ½ÇÇà ÈÄ */
		sb.append("<table style='border-bottom:1px solid #000;text-align:center;' width='100%' border='1' cellpadding='0' cellspacing='0'>");
		sb.append("<colgroup>");
		sb.append("<col width='14%'>");
		sb.append("<col width='36%'>");
		sb.append("<col width='14%'>");
		sb.append("<col width='36%'>");
		sb.append("</colgroup>");
		sb.append("<tr>");
		sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;height:25px; '> ½ÇÇàÀÚ </th>");
		sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;'>");
		sb.append(cmmCnts.get("CTUserNM2"));  
		sb.append("</td>");
		sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;height:25px; '>  ½ÇÇàÀÏ </th>");
		sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;'>");
		sb.append(cmmCnts.get("CTExeDTM"));  
		sb.append("</td>");
		sb.append("</tr>");
		sb.append("<tr>");
		sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;height:25px; '> ½ÇÇà ³»¿ë </th>");
		sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:¸¼Àº °íµñ;' colspan=3><br>");
		sb.append(cmmCnts.get("CTResult"));
		sb.append("<br>");
		sb.append("<br>");
		sb.append("</td>");
		sb.append("</tr>");
		sb.append("</table>");
		sb.append("<br>");
		sb.append("<br>");
	}
	sb.append("</body>");
	sb.append("</html>");
	return sb.toString();
    }

  public static String makeHTML_SRAPREQ(Map cmmCnts, Map menu)
  {
    String wfStepInstInfo = StringUtil.checkNull(cmmCnts.get("wfStepInstInfo"));
    List wfInstList = (List)cmmCnts.get("wfInstList");
    Map wfInstInfo = (Map)cmmCnts.get("wfInstInfo");
    Map getSRInfoMap = (Map)cmmCnts.get("getSRInfoMap");

    System.out.println("SRAPREQ==wfInstList== " + wfInstList);

    String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
    String LN00134 = StringUtil.checkNull(menu.get("LN00134"));
    String LN00122 = StringUtil.checkNull(menu.get("LN00122"));
    String LN00027 = StringUtil.checkNull(menu.get("LN00027"));
    String LN00140 = StringUtil.checkNull(menu.get("LN00140"));
    String LN00025 = StringUtil.checkNull(menu.get("LN00025"));
    String LN00093 = StringUtil.checkNull(menu.get("LN00093"));
    String LN00221 = StringUtil.checkNull(menu.get("LN00221"));
    String LN00002 = StringUtil.checkNull(menu.get("LN00002"));
    String LN00290 = StringUtil.checkNull(menu.get("LN00290"));

    String languageID = StringUtil.checkNull(cmmCnts.get("LanguageID"));
    String WFInstanceID = StringUtil.checkNull(wfInstInfo.get("WFInstanceID"));
    String SRCode = StringUtil.checkNull(getSRInfoMap.get("SRCode"));
    String WFDocType = StringUtil.checkNull(cmmCnts.get("wfDocType"));
    String StatusName = StringUtil.checkNull(wfInstInfo.get("StatusName"));
    String SRArea1Name = StringUtil.checkNull(getSRInfoMap.get("SRArea1Name"));
    String SRArea2Name = StringUtil.checkNull(getSRInfoMap.get("SRArea2Name"));
    String SRArea1NM = StringUtil.checkNull(getSRInfoMap.get("SRArea1NM"));
    String SRArea2NM = StringUtil.checkNull(getSRInfoMap.get("SRArea2NM"));

    String ReqUserNM = StringUtil.checkNull(getSRInfoMap.get("ReqUserNM"));
    String RegDate = StringUtil.checkNull(getSRInfoMap.get("RegDate"));
    String ReqDueDate = StringUtil.checkNull(getSRInfoMap.get("ReqDueDate"));
    String Subject = StringUtil.checkNull(wfInstInfo.get("Subject"));
    String Description = StringUtil.checkNull(wfInstInfo.get("Description").toString().replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\""));

    String returnHTML = emailHTMLForm;
    returnHTML = returnHTML.replace("#LN00134#", LN00134);
    returnHTML = returnHTML.replace("#LN00122#", LN00122);
    returnHTML = returnHTML.replace("#LN00027#", LN00027);
    returnHTML = returnHTML.replace("#LN00140#", LN00140);
    returnHTML = returnHTML.replace("#LN00025#", LN00025);
    returnHTML = returnHTML.replace("#LN00093#", LN00093);
    returnHTML = returnHTML.replace("#LN00221#", LN00221);
    returnHTML = returnHTML.replace("#LN00002#", LN00002);
    returnHTML = returnHTML.replace("#LN00290#", LN00290);

    returnHTML = returnHTML.replace("#WFInstanceID#", WFInstanceID);
    returnHTML = returnHTML.replace("#OLM_SERVER_NAME#", OLM_SERVER_NAME);
    returnHTML = returnHTML.replace("#SRCode#", SRCode);
    returnHTML = returnHTML.replace("#WFDocType#", WFDocType);
    returnHTML = returnHTML.replace("#StatusName#", StatusName);
    returnHTML = returnHTML.replace("#wfStepInstInfo#", ReqUserNM + "(¿äÃ») >> " + wfStepInstInfo);
    returnHTML = returnHTML.replace("#SRArea1Name#", SRArea1Name);
    returnHTML = returnHTML.replace("#SRArea2Name#", SRArea2Name);
    returnHTML = returnHTML.replace("#SRArea1NM#", SRArea1NM);
    returnHTML = returnHTML.replace("#SRArea2NM#", SRArea2NM);
    returnHTML = returnHTML.replace("#ReqUserNM#", ReqUserNM);
    returnHTML = returnHTML.replace("#RegDate#", RegDate);
    returnHTML = returnHTML.replace("#ReqDueDate#", ReqDueDate);
    returnHTML = returnHTML.replace("#Subject#", Subject);
    returnHTML = returnHTML.replace("#Description#", Description);
    returnHTML = returnHTML.replace("#OLM_SERVER_URL#", OLM_SERVER_URL);
    returnHTML = returnHTML.replace("#HTML_IMG_DIR#", HTML_IMG_DIR);

    String projectID = StringUtil.checkNull(cmmCnts.get("projectID"));
    String wfID = StringUtil.checkNull(cmmCnts.get("wfID"));
    String stepInstID = StringUtil.checkNull(cmmCnts.get("stepInstID"));
    String actorID = StringUtil.checkNull(cmmCnts.get("actorID"));
    String stepSeq = StringUtil.checkNull(cmmCnts.get("stepSeq"));
    String wfInstanceID = StringUtil.checkNull(cmmCnts.get("wfInstanceID"));
    String lastSeq = StringUtil.checkNull(cmmCnts.get("lastSeq"));
    String documentID = StringUtil.checkNull(cmmCnts.get("documentID"));
    String srID = StringUtil.checkNull(cmmCnts.get("srID"));
    String docCategory = StringUtil.checkNull(cmmCnts.get("docCategory"));

    String urlAprv = OLM_SERVER_URL + "srAprvDetailEmail.do?languageID=" + languageID + "&projectID=" + projectID + "&stepInstID=" + stepInstID + 
      "&isPop=Y&isMulti=N&actionType=view" + 
      "&actorID=" + actorID + "&stepSeq=" + stepSeq + "&wfInstanceID=" + wfInstanceID + 
      "&lastSeq=" + lastSeq + "&documentID=" + documentID + "&srID=" + srID + 
      "&docCategory=" + docCategory + "&wfMode=CurAprv" + 
      "&aprvMode=APRV";

    String urlRjt = OLM_SERVER_URL + "srAprvDetailEmail.do?languageID=" + languageID + "&projectID=" + projectID + "&stepInstID=" + stepInstID + 
      "&isPop=Y&isMulti=N&actionType=view" + 
      "&actorID=" + actorID + "&stepSeq=" + stepSeq + "&wfInstanceID=" + wfInstanceID + 
      "&lastSeq=" + lastSeq + "&documentID=" + documentID + "&srID=" + srID + 
      "&docCategory=" + docCategory + "&wfMode=CurAprv" + 
      "&aprvMode=RJT";

    String btnImgPath = OLM_SERVER_URL + HTML_IMG_DIR;

    returnHTML = returnHTML.replace("#urlAprv#", urlAprv);
    returnHTML = returnHTML.replace("#urlRjt#", urlRjt);
    returnHTML = returnHTML.replace("#btnImgPath#", btnImgPath);

    System.out.println(returnHTML); return returnHTML;
  }

  public static String makeHTML_SRAPREL(Map cmmCnts, Map menu)
  {
    String wfInstanceID = StringUtil.checkNull(cmmCnts.get("wfInstanceID"));
    String description = StringUtil.checkNull(cmmCnts.get("emDescription"));
    String docNo = StringUtil.checkNull(cmmCnts.get("docNo"));
    String returnHTML = "";

    returnHTML = returnHTML + "<!doctype html><html><body>";
    returnHTML = returnHTML + "[" + docNo + "] " + description;
    returnHTML = returnHTML + "</body></html>";

    System.out.println(returnHTML);
    return returnHTML;
  }

  public static String makeHTML_SRAPRJT(Map cmmCnts, Map menu)
  {
    String projectCode = StringUtil.checkNull(cmmCnts.get("ProjectCode"));
    String name = StringUtil.checkNull(cmmCnts.get("ProjectName"));
    String wfInstanceID = StringUtil.checkNull(cmmCnts.get("wfInstanceID"));
    String docNo = StringUtil.checkNull(cmmCnts.get("docNo"));
    String description = StringUtil.checkNull(cmmCnts.get("emDescription"));
    String returnHTML = "";

    returnHTML = returnHTML + "<!doctype html><html><body>";
    returnHTML = returnHTML + "[" + docNo + "] " + description;
    returnHTML = returnHTML + "</body></html>";

    System.out.println(returnHTML);
    return returnHTML;
  }

  public static String makeHTML_SRCNGRDD(Map cmmCnts, Map menu)
  {
    String srID = StringUtil.checkNull(cmmCnts.get("SRID"));
    String srCode = StringUtil.checkNull(cmmCnts.get("SRCode"));
    String srType = StringUtil.checkNull(cmmCnts.get("SRType"));
    String subject = StringUtil.checkNull(cmmCnts.get("Subject"));
    String userID = StringUtil.checkNull(cmmCnts.get("requestUserID"));
    String languageID = StringUtil.checkNull(cmmCnts.get("languageID"));
    String loginID = StringUtil.checkNull(cmmCnts.get("loginID"));
    String dueDate = StringUtil.checkNull(cmmCnts.get("dueDate"));
    String dueDateTime = StringUtil.checkNull(cmmCnts.get("dueDateTime"));
    String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
    String LN00002 = StringUtil.checkNull(menu.get("LN00002"));
    String LN00221 = StringUtil.checkNull(menu.get("LN00221"));

    String returnHTML = emailHTMLForm;
    returnHTML = returnHTML.replace("#LN00002#", LN00002);
    returnHTML = returnHTML.replace("#LN00221#", LN00221);
    returnHTML = returnHTML.replace("#OLM_SERVER_NAME#", OLM_SERVER_NAME);
    returnHTML = returnHTML.replace("#srCode#", srCode);
    returnHTML = returnHTML.replace("#subject#", subject);
    returnHTML = returnHTML.replace("#dueDate#", dueDate);
    returnHTML = returnHTML.replace("#dueDateTime#", dueDateTime);
    returnHTML = returnHTML.replace("#OLM_SERVER_URL#", OLM_SERVER_URL);
    returnHTML = returnHTML.replace("#HTML_IMG_DIR#", HTML_IMG_DIR);

    String url = OLM_SERVER_URL + "reqSRDueDateChangeEmail.do?userID=" + loginID + 
      "&languageID=" + languageID + "&srID=" + srID + "&srType=" + srType + 
      "&dueDate=" + dueDate + "&dueDateTime=" + dueDateTime;
    String btnImgPath = OLM_SERVER_URL + HTML_IMG_DIR;

    returnHTML = returnHTML.replace("#url#", url);
    returnHTML = returnHTML.replace("#btnImgPath#", btnImgPath);
    System.out.println(returnHTML);

    return returnHTML;
  }

  public static String makeHTML_PIMEM001(Map cmmCnts, Map menu) {
    String procInstNo = StringUtil.checkNull(cmmCnts.get("procInstNo"));
    String elmInstNo = StringUtil.checkNull(cmmCnts.get("elmInstNo"));
    String procProcessName = StringUtil.checkNull(cmmCnts.get("procProcessName"));
    String procInstName = StringUtil.checkNull(cmmCnts.get("procInstName"));
    String elmInstName = StringUtil.checkNull(cmmCnts.get("elmInstName"));
    String elmProcessName = StringUtil.checkNull(cmmCnts.get("elmProcessName"));
    String roleItemID = StringUtil.checkNull(cmmCnts.get("roleItemID"));
    String roleItemName = StringUtil.checkNull(cmmCnts.get("roleItemName"));
    String pimWorker = StringUtil.checkNull(cmmCnts.get("pimWorker"));
    String schStartDate = StringUtil.checkNull(cmmCnts.get("schStartDate"));
    String docCategoryName = StringUtil.checkNull(cmmCnts.get("docCategoryName"));
    String documentNo = StringUtil.checkNull(cmmCnts.get("documentNo"));
    String team = StringUtil.checkNull(cmmCnts.get("team"));
    String roleID = StringUtil.checkNull(cmmCnts.get("roleID"));
    String subject = StringUtil.checkNull(cmmCnts.get("subject"));
    String docCategory = StringUtil.checkNull(cmmCnts.get("docCategory"));
    String ZLN0001 = StringUtil.checkNull(menu.get("ZLN0001"));

    String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));

    String returnHTML = emailHTMLForm;
    returnHTML = returnHTML.replace("#procInstNo#", procInstNo);
    returnHTML = returnHTML.replace("#elmInstNo#", elmInstNo);
    returnHTML = returnHTML.replace("#procProcessName#", procProcessName);
    returnHTML = returnHTML.replace("#procInstName#", procInstName);
    returnHTML = returnHTML.replace("#elmInstName#", elmInstName);
    returnHTML = returnHTML.replace("#elmProcessName#", elmProcessName);
    returnHTML = returnHTML.replace("#roleItemID#", roleItemID);
    returnHTML = returnHTML.replace("#roleItemName#", roleItemName);
    returnHTML = returnHTML.replace("#pimWorker#", pimWorker);
    returnHTML = returnHTML.replace("#schStartDate#", schStartDate);
    returnHTML = returnHTML.replace("#docCategoryName#", docCategoryName);
    returnHTML = returnHTML.replace("#documentNo#", documentNo);
    returnHTML = returnHTML.replace("#team#", team);
    returnHTML = returnHTML.replace("#roleID#", roleID);
    returnHTML = returnHTML.replace("#subject#", subject + " " + ZLN0001);
    returnHTML = returnHTML.replace("#docCategory#", docCategory);
    returnHTML = returnHTML.replace("#OLM_SERVER_URL#", OLM_SERVER_URL);
    returnHTML = returnHTML.replace("#HTML_IMG_DIR#", HTML_IMG_DIR);

    return returnHTML;
  }

  public static String makeHTML_CSRNTC(Map cmmCnts, Map menu)
  {
    String description = StringUtil.checkNull(cmmCnts.get("emDescription"));
    String returnHTML = "";

    returnHTML = returnHTML + "<!doctype html><html><body>";
    returnHTML = returnHTML + description;
    returnHTML = returnHTML + "</body></html>";

    System.out.println(returnHTML);
    return returnHTML;
  }

  public static String makeHTML_REQSYSTEST(Map cmmCnts, Map menu) {
    String SCRCode = StringUtil.checkNull(cmmCnts.get("SCRCode"));
    String description = StringUtil.checkNull(cmmCnts.get("emDescription"));
    String returnHTML = "";

    returnHTML = returnHTML + "<!doctype html><html><body>";
    returnHTML = returnHTML + "[" + SCRCode + "] " + description;
    returnHTML = returnHTML + "</body></html>";

    System.out.println(returnHTML);
    return returnHTML;
  }

  public static String makeHTML_ITSCMP(Map cmmCnts, Map menu) {
    String SRCode = StringUtil.checkNull(cmmCnts.get("SRCode"));
    String description = StringUtil.checkNull(cmmCnts.get("emDescription"));
    String returnHTML = "";

    returnHTML = returnHTML + "<!doctype html><html><body>";
    returnHTML = returnHTML + "[" + SRCode + "] " + description;
    returnHTML = returnHTML + "</body></html>";

    System.out.println(returnHTML);
    return returnHTML;
  }

  public static String makeHTML_REQSREV(Map cmmCnts, Map menu) {
    String SRCode = StringUtil.checkNull(cmmCnts.get("SRCode"));
    String description = StringUtil.checkNull(cmmCnts.get("emDescription"));
    String returnHTML = "";

    returnHTML = returnHTML + "<!doctype html><html><body>";
    returnHTML = returnHTML + "[" + SRCode + "] " + description;
    returnHTML = returnHTML + "</body></html>";

    System.out.println(returnHTML);
    return returnHTML;
  }
}