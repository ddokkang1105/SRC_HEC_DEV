package xbolt.cmm.framework.util;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import xbolt.cmm.framework.val.GlobalVal;
/**
 * 공통 서블릿 처리
 * @Class Name : MakeEmailContents.java
 * @Description : email body 관련 함수
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2016. 01. 13. smartfactory		최초생성
 *
 * @since 2016. 01. 13.
 * @version 1.0
 * @see
 * 
 * Copyright (C) 2013 by SMARTFACTORY All right reserved.
 */
@SuppressWarnings("unused")
public class MakeEmailContents {

	private static String startHTML = "<!doctype html><html><body>";
	private static String endHTML = "</body></html>";
	private static String closeTable = "</table>";
	private static String openThBlue = " <th style=\"padding-left:5px;border-top:1px solid #000;background-color:#e5f2f9;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:맑은 고딕;height:25px; \">";
	private static String openThColspan6 = " <th style=\"padding:10px;color:#000;font-weight:bold;text-align:left;font-size:15px;font-family:맑은 고딕;height:25px; \" colspan=6>";
	private static String openTable = "<table style=\"font-size: 14px;border-collapse: collapse; table-layout:fixed;text-align:center;\"width=\"100%\"  cellpadding=\"0\" cellspacing=\"0\">";
	private static String openTh = "<th style=\"padding-left:10px;border:1px solid #d4d4d4;background-color:#F6F8F9;color:#696969;font-weight:bold;text-align:center;height:30px;\">";
	private static String openTd = "<td style=\"border:1px solid #d4d4d4; padding:10px; color:#000;line-height:23px;vertical-align:top;\">";
	
	private static String openTdColspan3 ="<td style=\"padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:맑은 고딕;\" colspan=3>";
	private static String openTdColspan5 ="<td style=\"padding:10px;border:1px solid #d4d4d4;text-align:left;;font-family:맑은 고딕;\" colspan=5>";
	private static String openTdColspan5H200 ="<td style=\"height:200px;padding:10px;border:1px solid #d4d4d4;color:#000;text-align:left;font-family:맑은 고딕;\" colspan=5>";
	
	private static String openTdColspan6 ="<td style=\"padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:맑은 고딕;\" colspan=6>";
	private static String openTdColspan6H200 ="<td style=\"height:200px;padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:맑은 고딕;\" colspan=6>";

	private static String openTdColspan7 ="<td style=\"padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:맑은 고딕;\" colspan=7>";
	private static String openTdColspan7H200 ="<td style=\"height:200px;padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:맑은 고딕;\" colspan=7>";

	private static String openTextarea ="<textarea style=\"width:99%;height:200px;font-family:맑은 고딕;\">";
	private static String openTdTxtColspan4 ="<td style=\"padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:맑은 고딕;\" colspan=4><br>";
	private static String openTdTxtColspan5 ="<td style=\"height:200px;padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:맑은 고딕;\" colspan=5>";
	private static String openTdTxtColspan6 ="<td style=\"padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:맑은 고딕;\" colspan=6><br>";

	private static String openTh2 = " <th style=\"padding:10px;border:1px solid #d4d4d4;background-color:#f8f5e5;color:#696969;text-align:left;font-family:맑은 고딕;height:25px; \">";
	private static String openTd2 ="<td style=\"padding-left:5px;border-top:1px solid #000;background-color:#f8f5e5;color:##000;text-align:left;font-size:12px;font-family:맑은 고딕;\">";
	private static String openTd2Colspan5 ="<td style=\"padding-left:5px;border-top:1px solid #000;background-color:#f8f5e5;color:##000;text-align:left;font-size:12px;font-family:맑은 고딕;\" colspan=5>";
	private static String openTh2Colspan6 = "<th style=\"padding-left:10px;border-top:2px solid #666;background-color:#f8f5e5;color:##000;font-weight:bold;text-align:left;font-size:14px;font-family:맑은 고딕;height:25px;; \" colspan=6>";
	
	private static String newLine = "\r\n";
	private static String openDiv = "<div style=\"text-align:center;padding-top:20px;\">";
	
	private static String openSpan = "<span style=\"font-family: 맑은 고딕; font-size: 12px;\">";
	private static String OLM_SERVER_URL =  StringUtil.checkNull(GlobalVal.OLM_SERVER_URL); // OLM_SERVER_URL = http://localhost:8080/	
	private static String HTML_IMG_DIR =  StringUtil.checkNull(GlobalVal.HTML_IMG_DIR);
	private static String GW_LINK_URL = StringUtil.checkNull(GlobalVal.GW_LINK_URL);
	private static String OLM_SERVER_NAME =  StringUtil.checkNull(GlobalVal.OLM_SERVER_NAME);
	private static String PROPOSAL_SERVER_URL = StringUtil.checkNull(GlobalVal.PROPOSAL_SERVER_URL); // HTC 제안연계 URL
	private static String openForm = "<form id='mForm' name='mForm' method='post' target='_blank'>";
	private static String endForm = "</form>";
	private static String openInput = "<input type='hidden'";
	private static String includeIBJs = "<script src='"+OLM_SERVER_URL+"/cmm/js/xbolt/inBoundHelper.js' type='text/javascript'></script>";
	
	//SR 접수 HTML
	public static String makeHTML_SRREQ(HashMap cmmCnts, Map menu){
		String ReqUserNM = StringUtil.checkNull(cmmCnts.get("ReqUserNM"));
		String ReqTeamNM = StringUtil.checkNull(cmmCnts.get("ReqTeamNM"));
		String requestUser = ReqUserNM+"("+ReqTeamNM+")";
		String reqdueDate = StringUtil.checkNull(cmmCnts.get("ReqDueDate"));
		
		
		String srArea1Name = StringUtil.checkNull(cmmCnts.get("SRArea1Name"));
		String srArea2Name = StringUtil.checkNull(cmmCnts.get("SRArea2Name"));
		
		String categoryName = StringUtil.checkNull(cmmCnts.get("CategoryName"));
		String subCategoryName = StringUtil.checkNull(cmmCnts.get("SubCategoryName"));
		String srCode = StringUtil.checkNull(cmmCnts.get("SRCode"));
		String subject = StringUtil.checkNull(cmmCnts.get("Subject"));
		String description = StringUtil.checkNull(cmmCnts.get("Description")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
		description = StringUtil.checkNull(description).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		description = StringUtil.checkNull(description).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
		String srReason = StringUtil.checkNull(cmmCnts.get("SRReasonNM")); // 이슈원인
		String itsmIF = StringUtil.checkNull(cmmCnts.get("ITSMIF")); // IT 지원
		
		String status = StringUtil.checkNull(cmmCnts.get("Status"));
		String srID = StringUtil.checkNull(cmmCnts.get("SRID"));
		String loginID = StringUtil.checkNull(cmmCnts.get("loginID"));
		String languageID = StringUtil.checkNull(cmmCnts.get("languageID"));
		String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
		String LN00025 = StringUtil.checkNull(menu.get("LN00025"));
		String LN00222 = StringUtil.checkNull(menu.get("LN00222")); // 완료 요청일
		String LN00272 = StringUtil.checkNull(menu.get("LN00272"));
		String LN00002 = StringUtil.checkNull(menu.get("LN00002"));
		String LN00093 = StringUtil.checkNull(menu.get("LN00093")); // 요청일
		
		String srAreaLabelNM1 = StringUtil.checkNull(cmmCnts.get("SRArea1NM")); 
		String srAreaLabelNM2 = StringUtil.checkNull(cmmCnts.get("SRArea2NM")); 
		
		String returnHTML = emailHTMLForm;
		returnHTML = returnHTML.replaceAll("#LN00025#", LN00025);
		returnHTML = returnHTML.replaceAll("#LN00222#", LN00222);		
		returnHTML = returnHTML.replaceAll("#LN00272#", LN00272);
		returnHTML = returnHTML.replaceAll("#LN00093#", LN00093);	
		returnHTML = returnHTML.replaceAll("#srAreaLabelNM1#", srAreaLabelNM1);
		returnHTML = returnHTML.replaceAll("#srAreaLabelNM2#", srAreaLabelNM2);		
		returnHTML = returnHTML.replaceAll("#LN00002#", LN00002);
		
		returnHTML = returnHTML.replaceAll("#srCode#", srCode);
		returnHTML = returnHTML.replaceAll("#requestUser#", requestUser);
		returnHTML = returnHTML.replaceAll("#reqdueDate#", reqdueDate);
		returnHTML = returnHTML.replaceAll("#categoryName#", categoryName);
		returnHTML = returnHTML.replaceAll("#srArea1Name#", srArea1Name);
		returnHTML = returnHTML.replaceAll("#srArea2Name#", srArea2Name);
		returnHTML = returnHTML.replaceAll("#srReason#", srReason);
		returnHTML = returnHTML.replaceAll("#itsmIF#", itsmIF);
		returnHTML = returnHTML.replaceAll("#subject#", subject);
		returnHTML = returnHTML.replaceAll("#description#", description);
		returnHTML = returnHTML.replaceAll("#srID#", srID);
		returnHTML = returnHTML.replaceAll("#languageID#", languageID);
		returnHTML = returnHTML.replaceAll("#OLM_SERVER_URL#", OLM_SERVER_URL);
		returnHTML = returnHTML.replaceAll("#HTML_IMG_DIR#", HTML_IMG_DIR);
		returnHTML = returnHTML.replaceAll("#GW_LINK_URL#", GW_LINK_URL+"?olmLng="+languageID+"&srID="+srID+"&mainType=mySRDtl");
/*
		if(GW_LINK_URL != ""){			
			returnHTML += "<div style=\"text-align:center;padding-top:5px;\">";
			returnHTML += "<a href='"+GW_LINK_URL;
			returnHTML+= "?olmLng="+languageID+"&srID="+srID+"&mainType=mySRDtl' target=\"_blank\"><img alt=\"View\" src='"+OLM_SERVER_URL+HTML_IMG_DIR+"btn_email_view.png'></img></a></div>";
		}
*/
			
		returnHTML+=  "</body></html>";
			
		System.out.println(returnHTML);
		return returnHTML;
	}	
	
	//SR 조치완료 HTML
	public static String makeHTML_SRCMP(HashMap cmmCnts, Map menu){
		String receiptName = StringUtil.checkNull(cmmCnts.get("ReceiptName"));
		String receiptTeamName = StringUtil.checkNull(cmmCnts.get("ReceiptTeamName"));
		String receiptUser = receiptName+"("+receiptTeamName+")";
		String completionDT = StringUtil.checkNull(cmmCnts.get("CompletionDT"));
		
		
		String srArea1Name = StringUtil.checkNull(cmmCnts.get("SRArea1Name"));
		String srArea2Name = StringUtil.checkNull(cmmCnts.get("SRArea2Name"));
		
		String categoryName = StringUtil.checkNull(cmmCnts.get("CategoryName"));
		
		String srCode = StringUtil.checkNull(cmmCnts.get("SRCode"));
		String srID = StringUtil.checkNull(cmmCnts.get("SRID"));
		String subject = StringUtil.checkNull(cmmCnts.get("Subject"));
		String description = StringUtil.checkNull(cmmCnts.get("Description")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
		description = StringUtil.checkNull(description).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		description = StringUtil.checkNull(description).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
		
		String comment = StringUtil.checkNull(cmmCnts.get("Comment")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
		//comment = comment.replaceAll("\r\n","<br>");
		String ReqUserNM = StringUtil.checkNull(cmmCnts.get("ReqUserNM"));
		String ReqTeamNM = StringUtil.checkNull(cmmCnts.get("ReqTeamNM"));
		
		
		String userID = StringUtil.checkNull(cmmCnts.get("userID"));
		
		String requestUser = ReqUserNM+"("+ReqTeamNM+")";
		String reqdueDate = StringUtil.checkNull(cmmCnts.get("ReqDueDate"));
		
		String srReason = StringUtil.checkNull(cmmCnts.get("SRReasonNM")); // 이슈원인
		String itsmIF = StringUtil.checkNull(cmmCnts.get("ITSMIF")); // IT 지원
		
		String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
		String LN00129 = StringUtil.checkNull(menu.get("LN00129"));
		String LN00004 = StringUtil.checkNull(menu.get("LN00004"));
		String LN00064 = StringUtil.checkNull(menu.get("LN00064"));
		String LN00272 = StringUtil.checkNull(menu.get("LN00272"));
		String LN00274 = StringUtil.checkNull(menu.get("LN00274"));
		String LN00185 = StringUtil.checkNull(menu.get("LN00185"));
		String LN00002 = StringUtil.checkNull(menu.get("LN00002"));
		String LN00228 = StringUtil.checkNull(menu.get("LN00228"));
		String LN00025 = StringUtil.checkNull(menu.get("LN00025"));
		String LN00222 = StringUtil.checkNull(menu.get("LN00222"));

		String srAreaLabelNM1 = StringUtil.checkNull(cmmCnts.get("SRArea1NM")); 
		String srAreaLabelNM2 = StringUtil.checkNull(cmmCnts.get("SRArea2NM")); 
		
		String returnHTML = emailHTMLForm;
		returnHTML = returnHTML.replaceAll("#LN00129#", LN00129);
		returnHTML = returnHTML.replaceAll("#LN00004#", LN00004);
		returnHTML = returnHTML.replaceAll("#LN00064#", LN00064);		
		returnHTML = returnHTML.replaceAll("#LN00272#", LN00272);
		returnHTML = returnHTML.replaceAll("#LN00274#", LN00274);
		returnHTML = returnHTML.replaceAll("#LN00185#", LN00185);		
		returnHTML = returnHTML.replaceAll("#LN00002#", LN00002);
		returnHTML = returnHTML.replaceAll("#LN00228#", LN00228);
		returnHTML = returnHTML.replaceAll("#LN00025#", LN00025);
		returnHTML = returnHTML.replaceAll("#LN00222#", LN00222);
		returnHTML = returnHTML.replaceAll("#srAreaLabelNM1#", srAreaLabelNM1);
		returnHTML = returnHTML.replaceAll("#srAreaLabelNM2#", srAreaLabelNM2);		
		returnHTML = returnHTML.replaceAll("#srReason#", srReason);
		returnHTML = returnHTML.replaceAll("#itsmIF#", itsmIF);
		
		returnHTML = returnHTML.replaceAll("#requestUser#", requestUser);
		returnHTML = returnHTML.replaceAll("#reqdueDate#", reqdueDate);
		returnHTML = returnHTML.replaceAll("#srCode#", srCode);
		returnHTML = returnHTML.replaceAll("#srID#", srID);
		returnHTML = returnHTML.replaceAll("#receiptUser#",receiptUser);
		returnHTML = returnHTML.replaceAll("#completionDT#",completionDT);
		returnHTML = returnHTML.replaceAll("#categoryName#",categoryName);
		returnHTML = returnHTML.replaceAll("#srArea1Name#",srArea1Name);
		returnHTML = returnHTML.replaceAll("#srArea2Name#",srArea2Name);
		returnHTML = returnHTML.replaceAll("#subject#",subject);
		returnHTML = returnHTML.replaceAll("#description#",description);
		returnHTML = returnHTML.replaceAll("#comment#",comment);
		returnHTML = returnHTML.replaceAll("#OLM_SERVER_URL#", OLM_SERVER_URL);
		returnHTML = returnHTML.replaceAll("#HTML_IMG_DIR#", HTML_IMG_DIR);
				
//		if(!processType.equals("0")){
//			returnHTML+= "<div style=\"text-align:center;padding-top:5px;\">";
//			returnHTML+= "<a href="+OLM_SERVER_URL+"srConfirmFromEmail.do?srID="+srID+"&userID="+loginID+"&languageID="+languageID+" target=\"_blank\"><b>Confirm<b></a></div>";
//		}
		returnHTML+= "</body></html>";
		
		System.out.println(returnHTML);
		return returnHTML;
	}	
	
	//CR 접수/취소 HMTL
	public static String makeHTML_CRRCV(HashMap cmmCnts, Map menu){
		
		String requestUser = StringUtil.checkNull(cmmCnts.get("RegUserName"))+"("+StringUtil.checkNull(cmmCnts.get("RegTeamName"))+")";
		String statusNM = StringUtil.checkNull(cmmCnts.get("StatusNM"));
		String regDT = StringUtil.checkNull(cmmCnts.get("RegDT"));
		String crArea1NM = StringUtil.checkNull(cmmCnts.get("CRArea1NM"));
		String crArea2NM = StringUtil.checkNull(cmmCnts.get("CRArea2NM"));
		String priorityNM = StringUtil.checkNull(cmmCnts.get("PriorityNM"));
		String reqDueDate = StringUtil.checkNull(cmmCnts.get("ReqDueDate"));
		String subject = StringUtil.checkNull(cmmCnts.get("Subject"));
		String description = StringUtil.checkNull(cmmCnts.get("Description")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
		description = StringUtil.checkNull(description).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		description = StringUtil.checkNull(description).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
		String srDescription = StringUtil.checkNull(cmmCnts.get("SRDescription")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
		srDescription = StringUtil.checkNull(srDescription).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		srDescription = StringUtil.checkNull(srDescription).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
	 //   description = description.replaceAll("\r\n","<br>");
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
		returnHTML = returnHTML.replaceAll("#LN00025#", LN00025);
		returnHTML = returnHTML.replaceAll("#LN00027#", LN00027);		
		returnHTML = returnHTML.replaceAll("#LN00093#", LN00093);
		returnHTML = returnHTML.replaceAll("#LN00274#", LN00274);
		returnHTML = returnHTML.replaceAll("#LN00185#", LN00185);		
		returnHTML = returnHTML.replaceAll("#LN00067#", LN00067);
		returnHTML = returnHTML.replaceAll("#LN00222#", LN00222);
		returnHTML = returnHTML.replaceAll("#LN00002#", LN00002);
		returnHTML = returnHTML.replaceAll("#LN00035#", LN00035);
		
		returnHTML = returnHTML.replaceAll("#crCode#", crCode);
		returnHTML = returnHTML.replaceAll("#requestUser#", requestUser);
		returnHTML = returnHTML.replaceAll("#statusNM#", statusNM);
		returnHTML = returnHTML.replaceAll("#regDT#", regDT);
		returnHTML = returnHTML.replaceAll("#crArea1NM#", crArea1NM);
		returnHTML = returnHTML.replaceAll("#crArea2NM#", crArea2NM);
		returnHTML = returnHTML.replaceAll("#priorityNM#", priorityNM);
		returnHTML = returnHTML.replaceAll("#reqDueDate#", reqDueDate);
		returnHTML = returnHTML.replaceAll("#subject#", subject);
		returnHTML = returnHTML.replaceAll("#srDescription#", srDescription);
		returnHTML = returnHTML.replaceAll("#description#", description);
				
		returnHTML+= "<div style=\"text-align:center;padding-top:5px;\">";
		returnHTML+= "<a href='"+OLM_SERVER_URL+"olmLink.do?olmLoginid=guest&object=CSR&linkType=id&linkID="+CSRID+"&languageID="+languageID+"' target=\"_blank\"><img alt=\"View\" src='"+OLM_SERVER_URL+HTML_IMG_DIR+"btn_email_view.png'></img></a></div>";
	
		returnHTML+= "</body></html>";
		
		System.out.println(returnHTML);
		return returnHTML;
	}
	
	// CSR용 전자결재 본문 HMTL
	public static String makeHTML_APREQ_CSR(Map cmmCnts,String languageID, Map menu){
		String projectID = StringUtil.checkNull(cmmCnts.get("ProjectID")); 
		String projectName = StringUtil.checkNull(cmmCnts.get("ProjectName")); // 명칭
		String path = StringUtil.checkNull(cmmCnts.get("Path")); // 프로젝트
		String authorName = StringUtil.checkNull(cmmCnts.get("AuthorName")) ;
		String authorTeamName = StringUtil.checkNull(cmmCnts.get("TeamName")); 
		String dueDate = StringUtil.checkNull(cmmCnts.get("DueDate"));
				
		String description = StringUtil.checkNull(cmmCnts.get("Description")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
		description = StringUtil.checkNull(description).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		description = StringUtil.checkNull(description).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
	 //   description = description.replaceAll("\r\n","<br>");
		String subCategoryNM = StringUtil.checkNull(cmmCnts.get("SubCategoryNM"));
		String srArea1Name = StringUtil.checkNull(cmmCnts.get("SRArea1Name"));
		String srArea2Name = StringUtil.checkNull(cmmCnts.get("SRArea2Name"));
		String ReqUserNM = StringUtil.checkNull(cmmCnts.get("ReqUserNM"));
		String ReqTeamNM = StringUtil.checkNull(cmmCnts.get("ReqTeamNM"));
		String reqDueDate = StringUtil.checkNull(cmmCnts.get("ReqDueDate"));
		String srDescription = StringUtil.checkNull(cmmCnts.get("SRDescription"));
		String srID = StringUtil.checkNull(cmmCnts.get("SRID"));
		String wfInstanceID = StringUtil.checkNull(cmmCnts.get("wfInstanceID"));
		
		String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
		String LN00092 = StringUtil.checkNull(menu.get("LN00092"));
		String LN00289 = StringUtil.checkNull(menu.get("LN00289"));
		String LN00025 = StringUtil.checkNull(menu.get("LN00025"));
		String LN00026 = StringUtil.checkNull(menu.get("LN00026"));
		String LN00274 = StringUtil.checkNull(menu.get("LN00274"));
		String LN00185 = StringUtil.checkNull(menu.get("LN00185"));
		String LN00273 = StringUtil.checkNull(menu.get("LN00273"));
		String LN00222 = StringUtil.checkNull(menu.get("LN00222"));
		
		String returnHTML = emailHTMLForm;
		returnHTML = returnHTML.replaceAll("#LN00092#", LN00092);
		returnHTML = returnHTML.replaceAll("#LN00289#", LN00289);		
		returnHTML = returnHTML.replaceAll("#LN00025#", LN00025);
		returnHTML = returnHTML.replaceAll("#LN00026#", LN00026);
		returnHTML = returnHTML.replaceAll("#LN00274#", LN00274);		
		returnHTML = returnHTML.replaceAll("#LN00185#", LN00185);
		returnHTML = returnHTML.replaceAll("#LN00273#", LN00273);
		
		returnHTML = returnHTML.replaceAll("#OLM_SERVER_URL#", OLM_SERVER_URL);
		returnHTML = returnHTML.replaceAll("#languageID#", languageID);
		returnHTML = returnHTML.replaceAll("#projectID#", projectID);
		returnHTML = returnHTML.replaceAll("#ReqUserNM#", ReqUserNM);
		returnHTML = returnHTML.replaceAll("#ReqTeamNM#", ReqTeamNM);
		returnHTML = returnHTML.replaceAll("#reqDueDate#", reqDueDate);
		
		returnHTML+= "<!doctype html><html><body>";
		returnHTML+= "<script src='#OLM_SERVER_URL#/cmm/js/xbolt/inBoundHelper.js' type='text/javascript'></script>";
		returnHTML+= "<form id='mForm' name='mForm' method='post' target='_blank'>";
		
		returnHTML+= "<input type='hidden' id='olmLoginid' name='olmLoginid' value='guest'/>";
		returnHTML+= "<input type='hidden' id='object' name='object' value='itm'/>";
		returnHTML+= "<input type='hidden' id='linkType' name='linkType' value='CSR'/>";
		returnHTML+= "<input type='hidden' id='ibUrl' name='ibUrl' value='#OLM_SERVER_URL#/olmLink.do'/>";
		returnHTML+= "<input type='hidden' id='languageID' name='languageID' value='#languageID#'/>";
		returnHTML+= "<input type='hidden' id='linkID' name='linkID' value='#projectID#'/>";
		
		returnHTML+= endForm;
		returnHTML+= openTable+newLine;
		returnHTML+= "<colgroup><col width=\"13%\"><col width=\"20%\"><col width=\"13%\"><col width=\"20%\"><col width=\"13%\"><col width=\"21%\"></colgroup>"+newLine;
		
		// 전자결재 SR 정보
		if(!srID.equals("")){
			returnHTML+= " <tr style=\"display:none;\" > "+newLine;
			returnHTML+= "<th style=\"padding-left:10px;border-top:2px solid #666;background-color:#f8f5e5;color:##000;font-weight:bold;text-align:left;font-size:14px;font-family:맑은 고딕;height:25px;; \" colspan=6>-&nbsp;"+LN00092+"&nbsp"+LN00289+"</th> "+newLine;
			returnHTML+= " </tr>"+newLine;
			
			returnHTML+= " <tr> "+newLine;
			returnHTML+= openTh2+LN00025+"</th> "+newLine;
			returnHTML+= openTd+ReqUserNM+"</td> "+newLine;
			returnHTML+= openTh2+LN00026+"</th> "+newLine;
			returnHTML+= openTd+ReqTeamNM+"</td>"+newLine;
			returnHTML+= openTh2+LN00222+"</th> "+newLine;
			returnHTML+= openTd+reqDueDate+"</td> "+newLine;		
			returnHTML+= " </tr>"+newLine;
					
			returnHTML+= " <tr> "+newLine;
			returnHTML+= openTh2 + LN00274+"</th> "+newLine;
			returnHTML+= openTd + srArea1Name + "</td> "+newLine;
			returnHTML+= openTh2 + LN00185+"</th> "+newLine;
			returnHTML+= openTd + srArea2Name + "</td>"+newLine;
			returnHTML+= openTh2 +LN00273+"</th> "+newLine;
			returnHTML+= openTd + subCategoryNM + "</td> "+newLine;		
			returnHTML+= " </tr>"+newLine;
			
			returnHTML+= " <tr> "+newLine;
			returnHTML+= openTh2 + StringUtil.checkNull(menu.get("LN00092"))+ " " + StringUtil.checkNull(menu.get("LN00035")) + "</th> "+newLine;
			returnHTML+= openTdColspan5H200 +  srDescription + "</td> "+newLine;
			returnHTML+= " </tr>"+newLine;
		}
		
	// 전자결재 CSR 정보		
		returnHTML+= " <tr> "+newLine;
		returnHTML+= openThColspan6 + StringUtil.checkNull(menu.get("LN00290"))+ " " + StringUtil.checkNull(menu.get("LN00289")) + "</th> "+newLine;
		returnHTML+= " </tr>"+newLine;		

		returnHTML+= " <tr> "+newLine;
		returnHTML+= openTh + StringUtil.checkNull(menu.get("LN00004")) + "</th> "+newLine;
		returnHTML+= openTd + authorName + "</td> "+newLine;
		returnHTML+= openTh + StringUtil.checkNull(menu.get("LN00104")) + "</th> "+newLine;
		returnHTML+= openTd + authorTeamName + "</td> "+newLine;		
		returnHTML+= openTh + StringUtil.checkNull(menu.get("LN00221")) + "</th> "+newLine;
		returnHTML+= openTd + dueDate + "</td>"+newLine;

		returnHTML+= " </tr>"+newLine;
		
		returnHTML+= " <tr> "+newLine;
		returnHTML+= openTh +StringUtil.checkNull(menu.get("LN00002"))+"</th> "+newLine;
		returnHTML+= openTdColspan5 + projectName + "</td> " + newLine;			
		returnHTML+= " </tr>"+newLine;
		
		returnHTML+= " <tr> "+newLine;
		returnHTML+= openTh + StringUtil.checkNull(menu.get("LN00290"))+ " " + StringUtil.checkNull(menu.get("LN00284")) + "</th> "+newLine;
		// returnHTML+= openTdColspan5 + openTextarea +  description + "</textarea></td> "+newLine;
		returnHTML+= openTdColspan5 + description + "</td> "+newLine;
		returnHTML+= " </tr>"+newLine;
		
		returnHTML+= closeTable+newLine;
		
		returnHTML+= openDiv;
		returnHTML+= "<a href=\""+OLM_SERVER_URL+"olmLinkMaster.do?wfInstanceID="+wfInstanceID+"&mainType=myWFDtl\" style=\"color: #ffffff; \">" + 
									"<SPAN target=\"_blank\" style=\"FONT-SIZE: 16px;  TEXT-DECORATION: none;HEIGHT: 43px; WIDTH: 155px; FONT-WEIGHT: 600; COLOR: #ffffff;DISPLAY: inline-block; LINE-HEIGHT: 44px; BACKGROUND-COLOR: #29aeff; padding: 2px;border-radius: 2px; cursor:pointer; margin: 0 15px;\"> 결재 상세</SPAN>" + 
									"</a></div>";
		returnHTML+= endHTML+newLine;
		
		System.out.println(returnHTML);
		return returnHTML;
	}	
	
	// CS 용 전자결재 본문 HMTL
	public static String makeHTML_APREQ_CS(Map cmmCnts,String languageID, Map menu){
		
		String wfStepInstInfo = StringUtil.checkNull(cmmCnts.get("wfStepInstInfo"));
		String wfStepInstAGRInfo = StringUtil.checkNull(cmmCnts.get("wfStepInstAGRInfo"));
		String wfStepInstREFInfo = StringUtil.checkNull(cmmCnts.get("wfStepInstREFInfo"));
		String wfStepInstRELInfo = StringUtil.checkNull(cmmCnts.get("wfStepInstRELInfo"));
		String wfStepInstRECInfo = StringUtil.checkNull(cmmCnts.get("wfStepInstRECInfo"));

		Map wfInstInfo = (Map) cmmCnts.get("wfInstInfo");
		Map getPJTMap = (Map) cmmCnts.get("getPJTMap"); 
		
		String WFInstanceID = StringUtil.checkNull(getPJTMap.get("WFInstanceID"));
		String WFDocType = StringUtil.checkNull(getPJTMap.get("WFDocType"));
		String changeSetID = StringUtil.checkNull(getPJTMap.get("DocumentID"));
		String StatusName = StringUtil.checkNull(wfInstInfo.get("StatusName"));
		String Subject = StringUtil.checkNull(getPJTMap.get("Subject"));
		String Description = StringUtil.checkNull(getPJTMap.get("Description"),"");
		String CreatorName = StringUtil.checkNull(getPJTMap.get("CreatorName"),"");
		String CreatorTeamName = StringUtil.checkNull(getPJTMap.get("CreatorTeamName"),"");
		String DocumentNo = StringUtil.checkNull(getPJTMap.get("DocumentNo"),"");
		Description = StringUtil.checkNull(Description).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		Description = StringUtil.checkNull(Description).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
		
		List csInstList = (List) cmmCnts.get("csInstList");
			
		String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
		String LN00134 = StringUtil.checkNull(menu.get("LN00134"));
		String LN00091 = StringUtil.checkNull(menu.get("LN00091"));
		String LN00027 = StringUtil.checkNull(menu.get("LN00027"));
		String LN00140 = StringUtil.checkNull(menu.get("LN00140"));
		String LN00045 = StringUtil.checkNull(menu.get("LN00045"));
		String LN00245 = StringUtil.checkNull(menu.get("LN00245"));
		String LN00002 = StringUtil.checkNull(menu.get("LN00002"));
		String LN00290 = StringUtil.checkNull(menu.get("LN00290"));
		String LN00025 = StringUtil.checkNull(menu.get("LN00025"));
		String returnHTML = emailHTMLForm;
		
		returnHTML = returnHTML.replaceAll("#LN00134#", LN00134);
		returnHTML = returnHTML.replaceAll("#LN00091#", LN00091);
		returnHTML = returnHTML.replaceAll("#LN00027#", LN00027);
		returnHTML = returnHTML.replaceAll("#LN00140#", LN00140);
		returnHTML = returnHTML.replaceAll("#LN00045#", LN00045);
		returnHTML = returnHTML.replaceAll("#LN00245#", LN00245);
		returnHTML = returnHTML.replaceAll("#LN00002#", LN00002);
		returnHTML = returnHTML.replaceAll("#LN00290#", LN00290);
		returnHTML = returnHTML.replaceAll("#LN00025#", LN00025);
		
		returnHTML = returnHTML.replaceAll("#WFInstanceID#", WFInstanceID);
		returnHTML = returnHTML.replaceAll("#WFDocType#", WFDocType);
		returnHTML = returnHTML.replaceAll("#StatusName#", StatusName);
		returnHTML = returnHTML.replaceAll("#Subject#", Subject);
		returnHTML = returnHTML.replaceAll("#Description#", Description);
		returnHTML = returnHTML.replaceAll("#wfStepInstInfo#", wfStepInstInfo);
		returnHTML = returnHTML.replaceAll("#wfStepInstAGRInfo#", wfStepInstAGRInfo);
		returnHTML = returnHTML.replaceAll("#wfStepInstREFInfo#", wfStepInstREFInfo);
		returnHTML = returnHTML.replaceAll("#wfStepInstRELInfo#", wfStepInstRELInfo);
		returnHTML = returnHTML.replaceAll("#wfStepInstRECInfo#", wfStepInstRECInfo);
		returnHTML = returnHTML.replaceAll("#wfStepInstRECInfo#", wfStepInstRECInfo);
		returnHTML = returnHTML.replaceAll("#CreatorName#", CreatorName);
		returnHTML = returnHTML.replaceAll("#CreatorTeamName#", CreatorTeamName);
		returnHTML = returnHTML.replaceAll("#DocumentNo#", DocumentNo);
		returnHTML = returnHTML.replaceAll("#OLM_SERVER_NAME#", OLM_SERVER_NAME);
		returnHTML = returnHTML.replaceAll("#OLM_SERVER_URL#", OLM_SERVER_URL);	
		//CS List 출력 부분
		String csItemListHTML = "<form id='mForm' name='mForm' method='GET'>"+newLine+openTable+newLine;
		csItemListHTML+= "<colgroup><col width=\"5%\"><col width=\"5%\"><col width=\"10%\"><col width=\"24%\"><col width=\"8%\">";
		csItemListHTML+= "<col width=\"8%\"><col width=\"8%\"><col width=\"8%\"></colgroup>"+newLine;

		csItemListHTML+= " <tr> "+newLine;
		csItemListHTML+= openTh + StringUtil.checkNull(menu.get("LN00024")) + "</th> "+newLine;
		csItemListHTML+= openTh + StringUtil.checkNull(menu.get("LN00017")) + "</th> "+newLine;
		csItemListHTML+= openTh + StringUtil.checkNull(menu.get("LN00106")) + "</th> "+newLine;
		csItemListHTML+= openTh + StringUtil.checkNull(menu.get("LN00011")) + "</th> "+newLine;
		csItemListHTML+= openTh + StringUtil.checkNull(menu.get("LN00004")) + "</th> "+newLine;
		csItemListHTML+= openTh + StringUtil.checkNull(menu.get("LN00022")) + "</th> "+newLine;
		csItemListHTML+= openTh + StringUtil.checkNull(menu.get("LN00064")) + "</th> "+newLine;
		csItemListHTML+= openTh + StringUtil.checkNull(menu.get("LN00296")) + "</th> "+newLine;
		csItemListHTML+= " </tr>"+newLine;
		
		String outputKey = StringUtil.checkNull(cmmCnts.get("outputKey"),"guest");
		if(outputKey.equals("")) {outputKey = "guest";}
		
		for(int i=0; i<csInstList.size(); i++) {
			Map tempMap = (Map) csInstList.get(i);
			csItemListHTML+= " <tr style=\"font-family:Apple SD Gothic Neo, sans-serif;\"> "+newLine;
			
			csItemListHTML+= openTd+StringUtil.checkNull(tempMap.get("RNUM"))+"</td>";
			csItemListHTML+= openTd+StringUtil.checkNull(tempMap.get("Version"))+"</td>";
			csItemListHTML+= openTd+StringUtil.checkNull(tempMap.get("Identifier"))+"</td>";
			if (GlobalVal.OLM_INBOUND_LINK == null || GlobalVal.OLM_INBOUND_LINK.equals("")){
				csItemListHTML+= openTd+StringUtil.checkNull(tempMap.get("ItemName"))+"</td>";
			} else {
				csItemListHTML+= openTd+"<a href=\""+OLM_SERVER_URL+"/"+GlobalVal.OLM_INBOUND_LINK+"?olmLoginid="+outputKey+"&object=itm&option=CNGREW&linkType=id&linkID="+StringUtil.checkNull(tempMap.get("ItemID"))+"&changeSetID="+changeSetID+"&style=\"background-color: transparent;text-decoration: underline;border: none;cursor: pointer;\">"+StringUtil.checkNull(tempMap.get("ItemName"))+"</a></td>";
		

			}
			csItemListHTML+= openTd+StringUtil.checkNull(tempMap.get("AuthorName"))+"</td>";
			csItemListHTML+= openTd+StringUtil.checkNull(tempMap.get("ChangeType"))+"</td>";
			csItemListHTML+= openTd+StringUtil.checkNull(tempMap.get("CompletionDT"))+"</td>";		
			csItemListHTML+= openTd+StringUtil.checkNull(tempMap.get("ValidFrom"))+"</td>";	
			csItemListHTML+= " </tr>";
		}
		csItemListHTML+= closeTable+newLine;
		
		csItemListHTML+= endForm;
		
		csItemListHTML+= openDiv;
		csItemListHTML+= endHTML+newLine;
		
		csItemListHTML+= openDiv;
	//	csItemListHTML+= "<a href=\""+OLM_SERVER_URL+"olmLinkMaster.do?wfInstanceID="+WFInstanceID+"&mainType=myWFDtl\" style=\"color: #ffffff; \">" + 
	//								"<SPAN target=\"_blank\" style=\"FONT-SIZE: 16px;  TEXT-DECORATION: none;HEIGHT: 43px; WIDTH: 155px; FONT-WEIGHT: 600; COLOR: #ffffff;DISPLAY: inline-block; LINE-HEIGHT: 44px; BACKGROUND-COLOR: #29aeff; padding: 2px;border-radius: 2px; cursor:pointer; margin: 0 15px;\"> 결재 상세</SPAN>" + 
	//								"</a></div>";
		csItemListHTML+= endHTML+newLine;

		returnHTML = returnHTML.replaceAll("#csItemListHTML#", csItemListHTML);
		

		
	
	
		String  RejectGuideLinkHTML =
			    "<form id='mForm' name='mForm' method='GET'>" + newLine +
			    "  <div style=\"margin-top:20px; font-family: Apple SD Gothic Neo, sans-serif; font-size:14px;\">" +
			    "  <div style=\"font-weight:bold; margin-bottom:8px; font-size:15px; text-align:left;\">개정 참고항목1</div>" +
			    "  </div>" + newLine +
			    "<table style=\"font-size: 14px;border-collapse: collapse; table-layout:fixed;text-align:center; align=\"left\" \"width=\"55%\"   cellpadding=\"0\" cellspacing=\"0\">" + newLine +
			    "  <colgroup><col width=\"10%\"><col width=\"35%\"><col width=\"55%\"></colgroup>" + newLine +
			    "  <thead style=\"background-color:#f5f5f5; font-weight:bold;\">" + newLine +
			    "    <tr>" + newLine +
			    openTh + StringUtil.checkNull(menu.get("LN00024")) + "</th>" + newLine +   // No (예시)
			    openTh + "참고 항목</th>" + newLine +
			    openTh + StringUtil.checkNull(menu.get("LN00106")) + "</th>" + newLine +    // ID (예시)
			    "    </tr>" + newLine +
			    "  </thead>" + newLine +
			    "  <tbody>" + newLine +
			    "    <tr>" + newLine +
			    openTd + "1</td>" + newLine +
			    openTd + "개정 변경사항 (모델 비교)</td>" + newLine +
			    openTd + "프로세스 링크 내 '모델 비교' 탭 확인</td>" + newLine +
			    "    </tr>" + newLine +
			    "    <tr>" + newLine +
			    openTd + "2</td>" + newLine +
			    openTd + "승인/반려방법</td>" + newLine +
			    openTd +
			      "<a href=\"" + OLM_SERVER_URL + "/" + GlobalVal.OLM_INBOUND_LINK +
			      "?olmLoginid=" + outputKey + "&object=BRD\" style=\"color:blue; text-decoration:underline;\">매뉴얼</a>" +
			    "</td>" + newLine +
			    "    </tr>" + newLine +
			    "  </tbody>" + newLine +
			    closeTable + newLine +
			    "</form>" + newLine +
			    endHTML + newLine;


		returnHTML = returnHTML.replaceAll("#guideLinkHTML#", RejectGuideLinkHTML);
		
		System.out.println(returnHTML);
		return returnHTML;
	}	
	
	
	// Update SR PROPOSAL 본문 HMTL
	public static String makeHTML_SRPROPOSAL(Map cmmCnts,String languageID, Map menu){
		String ReqUserNM = StringUtil.checkNull(cmmCnts.get("ReqUserNM"));
		String ReqTeamNM = StringUtil.checkNull(cmmCnts.get("ReqTeamNM"));
		String requestUser = ReqUserNM+"("+ReqTeamNM+")";
		String reqdueDate = StringUtil.checkNull(cmmCnts.get("ReqDueDate"));
		
		
		String srArea1Name = StringUtil.checkNull(cmmCnts.get("SRArea1Name"));
		String srArea2Name = StringUtil.checkNull(cmmCnts.get("SRArea2Name"));
		
		String categoryName = StringUtil.checkNull(cmmCnts.get("CategoryName"));
		
		String srCode = StringUtil.checkNull(cmmCnts.get("SRCode"));
		String subject = StringUtil.checkNull(cmmCnts.get("Subject"));		
		
		
		
		String header = "* 요청하신 SR 건은 아이디어제안에 해당되어 제안 시스템(i-Portal)에 이관하였습니다. <br>"
						+" 제안 시스템(i-Portal)에서 제안등록-임시보관함에서 확인하신 후 아이디어제안 등록하시기 바랍니다.<br><br>";
		String description = StringUtil.checkNull(cmmCnts.get("Description")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
		description = StringUtil.checkNull(description).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		description = StringUtil.checkNull(description).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
		
		String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
		String LN00025 = StringUtil.checkNull(menu.get("LN00025"));
		String LN00222 = StringUtil.checkNull(menu.get("LN00222"));
		String LN00272 = StringUtil.checkNull(menu.get("LN00272"));
		String LN00274 = StringUtil.checkNull(menu.get("LN00274"));
		String LN00185 = StringUtil.checkNull(menu.get("LN00185"));
		String LN00002 = StringUtil.checkNull(menu.get("LN00002"));
		
		String returnHTML = emailHTMLForm;
		returnHTML = returnHTML.replaceAll("#LN00025#", LN00025);
		returnHTML = returnHTML.replaceAll("#LN00222#", LN00222);
		returnHTML = returnHTML.replaceAll("#LN00272#", LN00272);
		returnHTML = returnHTML.replaceAll("#LN00274#", LN00274);
		returnHTML = returnHTML.replaceAll("#LN00185#", LN00185);
		returnHTML = returnHTML.replaceAll("#LN00002#", LN00002);
		
		returnHTML = returnHTML.replaceAll("#header#", header);
		returnHTML = returnHTML.replaceAll("#srCode#", srCode);
		returnHTML = returnHTML.replaceAll("#requestUser#", requestUser);
		returnHTML = returnHTML.replaceAll("#reqdueDate#", reqdueDate);
		returnHTML = returnHTML.replaceAll("#categoryName#", categoryName);
		returnHTML = returnHTML.replaceAll("#srArea1Name#", srArea1Name);
		returnHTML = returnHTML.replaceAll("#srArea2Name#", srArea2Name);
		returnHTML = returnHTML.replaceAll("#subject#", subject);
		returnHTML = returnHTML.replaceAll("#description#", description);
		
		returnHTML+= "<div style=\"text-align:center;padding-top:5px;\">";

		if(GW_LINK_URL != ""){
			returnHTML += "<a href='"+GW_LINK_URL;
			returnHTML+= "?authType=2&destination="+PROPOSAL_SERVER_URL+"' target=\"_blank\"><img alt=\"View\" src='"+OLM_SERVER_URL+HTML_IMG_DIR+"btn_email_view.png'></img></a></div>";
		}
		else {
			returnHTML+= "<a href='"+OLM_SERVER_URL;
			returnHTML +="?authType=2&destination="+PROPOSAL_SERVER_URL+"' target=\"_blank\"><img alt=\"View\" src='"+OLM_SERVER_URL+HTML_IMG_DIR+"btn_email_view.png'></img></a></div>";
		}
		returnHTML+= "</body></html>";
			
		System.out.println(returnHTML);
		return returnHTML;
	}	
	
	//WF 만도 접수 
	public static String makeHTML_SRREQM(HashMap cmmCnts, Map menu){
		String ProjectID = StringUtil.checkNull(cmmCnts.get("ProjectID"));
		String WFInstanceID = StringUtil.checkNull(cmmCnts.get("WFInstanceID"));
		
		String Comment = StringUtil.checkNull(cmmCnts.get("Comment"));
		String languageID = StringUtil.checkNull(cmmCnts.get("languageID"));
		
		String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
		
		String returnHTML = emailHTMLForm;
		
		returnHTML = returnHTML.replaceAll("#WFInstanceID#", WFInstanceID);
		returnHTML = returnHTML.replaceAll("#ProjectID#", ProjectID);
		returnHTML = returnHTML.replaceAll("#Comment#", Comment);
		returnHTML = returnHTML.replaceAll("#OLM_SERVER_URL#", OLM_SERVER_URL);
		returnHTML = returnHTML.replaceAll("#HTML_IMG_DIR#", HTML_IMG_DIR);
		
		if(GW_LINK_URL != ""){
			returnHTML+= "<div style=\"text-align:center;padding-top:5px;\">";
			returnHTML += "<a href='"+GW_LINK_URL;
			returnHTML+= "?olmLng="+languageID+"&mainType=mySRDtl' target=\"_blank\"><img alt=\"View\" src='"+OLM_SERVER_URL+HTML_IMG_DIR+"btn_email_view.png'></img></a></div>";
		}
			
		returnHTML+= "</body></html>";
			
		System.out.println(returnHTML);
		return returnHTML;
	}	
	
	// 전자결재 상신 본문 HMTL
	public static String makeHTML_CSRAPREQ(Map cmmCnts, Map menu){
		String wfStepInstInfo = StringUtil.checkNull(cmmCnts.get("wfStepInstInfo"));
		
		String wfStepInstRELInfo = StringUtil.checkNull(cmmCnts.get("wfStepInstRELInfo"));
		String wfStepInstRECInfo = StringUtil.checkNull(cmmCnts.get("wfStepInstRECInfo"));
		List wfInstList = (List) cmmCnts.get("wfInstList");
		Map wfInstInfo = (Map) cmmCnts.get("wfInstInfo");
		Map getPJTMap = (Map) cmmCnts.get("getPJTMap"); 
		Map csInstInfo = (Map) cmmCnts.get("csInstMap");
		
		System.out.println("==wfInstList== "+wfInstList);
		
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
		String Description = StringUtil.checkNull(getPJTMap.get("Description").toString().replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\""));
		Description = StringUtil.checkNull(Description).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		Description = StringUtil.checkNull(Description).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
		
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
		returnHTML = returnHTML.replaceAll("#LN00134#", LN00134);
		returnHTML = returnHTML.replaceAll("#LN00091#", LN00091);
		returnHTML = returnHTML.replaceAll("#LN00027#", LN00027);
		returnHTML = returnHTML.replaceAll("#LN00140#", LN00140);
		returnHTML = returnHTML.replaceAll("#LN00045#", LN00045);
		returnHTML = returnHTML.replaceAll("#LN00245#", LN00245);
		returnHTML = returnHTML.replaceAll("#LN00117#", LN00117);
		returnHTML = returnHTML.replaceAll("#LN00131#", LN00131);
		returnHTML = returnHTML.replaceAll("#LN00063#", LN00063);
		returnHTML = returnHTML.replaceAll("#LN00221#", LN00221);
		returnHTML = returnHTML.replaceAll("#LN00002#", LN00002);
		returnHTML = returnHTML.replaceAll("#LN00290#", LN00290);
		returnHTML = returnHTML.replaceAll("#LN00042#", LN00042);
		returnHTML = returnHTML.replaceAll("#LN00017#", LN00017);
		returnHTML = returnHTML.replaceAll("#LN00106#", LN00106);
		returnHTML = returnHTML.replaceAll("#LN00028#", LN00028);
		returnHTML = returnHTML.replaceAll("#LN00004#", LN00004);
		returnHTML = returnHTML.replaceAll("#LN00022#", LN00022);
		returnHTML = returnHTML.replaceAll("#LN00013#", LN00013);
		returnHTML = returnHTML.replaceAll("#LN00064#", LN00064);
		returnHTML = returnHTML.replaceAll("#LN00296#", LN00296);
		
		returnHTML = returnHTML.replaceAll("#OLM_SERVER_NAME#", OLM_SERVER_NAME);
		returnHTML = returnHTML.replaceAll("#ProjectCode#", ProjectCode);
		returnHTML = returnHTML.replaceAll("#WFDocType#", WFDocType);
		returnHTML = returnHTML.replaceAll("#StatusName#", StatusName);
		returnHTML = returnHTML.replaceAll("#wfStepInstInfo#", wfStepInstInfo);
		returnHTML = returnHTML.replaceAll("#wfStepInstRELInfo#", wfStepInstRELInfo);
		returnHTML = returnHTML.replaceAll("#wfStepInstRECInfo#", wfStepInstRECInfo);
		returnHTML = returnHTML.replaceAll("#Path#", Path);
		returnHTML = returnHTML.replaceAll("#StartDate#", StartDate);
		returnHTML = returnHTML.replaceAll("#DueDate#", DueDate);
		returnHTML = returnHTML.replaceAll("#ProjectName#", ProjectName);
		returnHTML = returnHTML.replaceAll("#Description#", Description);
		returnHTML = returnHTML.replaceAll("#ItemTypeImg", ItemTypeImg);
		returnHTML = returnHTML.replaceAll("#Version#", Version);
		returnHTML = returnHTML.replaceAll("#Identifier#", Identifier);
		returnHTML = returnHTML.replaceAll("#ItemName#", ItemName);
		returnHTML = returnHTML.replaceAll("#AuthorName#", AuthorName);
		returnHTML = returnHTML.replaceAll("#ChangeType#", ChangeType);
		returnHTML = returnHTML.replaceAll("#CreationTime#", CreationTime);
		returnHTML = returnHTML.replaceAll("#CompletionDT#", CompletionDT);
		returnHTML = returnHTML.replaceAll("#ApproveDate#", ApproveDate);
				
		if(wfInstInfo.get("DocCategory") != null && wfInstInfo.get("DocCategory").equals("CS")) {
			returnHTML = returnHTML.replaceAll("display:none;", "display:block;");
		}
		
		System.out.println(returnHTML);
		return returnHTML;
	}	
	
	// Process 게시글 등록 알림HMTL
		public static String makeHTML_BRDMAIL(Map cmmCnts, Map menu){
			String subject = StringUtil.checkNull(cmmCnts.get("subject"));
			String content = StringUtil.checkNull(cmmCnts.get("content")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
//			String UserNAME = StringUtil.checkNull(cmmCnts.get("UserNAME"));
//			String TeamName = StringUtil.checkNull(cmmCnts.get("TeamName"));
			String itemName = StringUtil.checkNull(cmmCnts.get("itemName"));
			HashMap regUInfo = (HashMap) cmmCnts.get("regUInfo");
			String boardMgtName = StringUtil.checkNull(cmmCnts.get("boardMgtName"));
			String relTeamMembers = StringUtil.checkNull(cmmCnts.get("relTeamMembers"));
			String SC_END_DT = StringUtil.checkNull(cmmCnts.get("SC_END_DT"));
			
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
			String LN00233 = StringUtil.checkNull(menu.get("LN00233"));
			
			String returnHTML = emailHTMLForm;
			returnHTML = returnHTML.replaceAll("#LN00212#", LN00212);
			returnHTML = returnHTML.replaceAll("#LN00078#", LN00078);
			returnHTML = returnHTML.replaceAll("#LN00087#", LN00087);
			returnHTML = returnHTML.replaceAll("#LN00002#", LN00002);
			returnHTML = returnHTML.replaceAll("#LN00003#", LN00003);
			returnHTML = returnHTML.replaceAll("#LN00323#", LN00323);
			returnHTML = returnHTML.replaceAll("#LN00233#", LN00233);
			
			returnHTML = returnHTML.replaceAll("#UserNAME#", UserNAME);
			returnHTML = returnHTML.replaceAll("#TeamName#", TeamName);
			returnHTML = returnHTML.replaceAll("#Email#", Email);
			returnHTML = returnHTML.replaceAll("#today#", today);
			returnHTML = returnHTML.replaceAll("#itemName#", itemName);
			returnHTML = returnHTML.replaceAll("#subject#", subject);
			returnHTML = returnHTML.replaceAll("#content#", content);
			returnHTML = returnHTML.replaceAll("#relTeamMembers#", relTeamMembers);
			returnHTML = returnHTML.replaceAll("#SC_END_DT#", SC_END_DT);
			returnHTML = returnHTML.replaceAll("#OLM_SERVER_URL#", OLM_SERVER_URL);
			returnHTML = returnHTML.replaceAll("#boardMgtName#", boardMgtName);
					
			System.out.println(returnHTML);
			return returnHTML;
		}	
	
	public static String makeHTML_REQITMRW(Map cmmCnts, Map menu){
		String subject = StringUtil.checkNull(cmmCnts.get("subject"));
		String content = StringUtil.checkNull(cmmCnts.get("content")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
		String EmployeeNum = StringUtil.checkNull(cmmCnts.get("EmployeeNum"));
		String itemName = StringUtil.checkNull(cmmCnts.get("itemName"));
		String itemID = StringUtil.checkNull(cmmCnts.get("itemID"));
		String changeSetID = StringUtil.checkNull(cmmCnts.get("changeSetID"));
		String loginID = StringUtil.checkNull(cmmCnts.get("loginID"));
		String boardMgtName = StringUtil.checkNull(cmmCnts.get("boardMgtName"));
		String relTeamMembers = StringUtil.checkNull(cmmCnts.get("relTeamMembers"));
		String SC_END_DT = StringUtil.checkNull(cmmCnts.get("SC_END_DT"));
		HashMap regUInfo = (HashMap) cmmCnts.get("regUInfo");
		
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
		String LN00233 = StringUtil.checkNull(menu.get("LN00233"));
		
		String returnHTML = emailHTMLForm;
		returnHTML = returnHTML.replaceAll("#LN00212#", LN00212);
		returnHTML = returnHTML.replaceAll("#LN00078#", LN00078);
		returnHTML = returnHTML.replaceAll("#LN00087#", LN00087);
		returnHTML = returnHTML.replaceAll("#LN00002#", LN00002);
		returnHTML = returnHTML.replaceAll("#LN00003#", LN00003);
		returnHTML = returnHTML.replaceAll("#LN00323#", LN00323);
		returnHTML = returnHTML.replaceAll("#LN00233#", LN00233);
		
		returnHTML = returnHTML.replaceAll("#UserNAME#", UserNAME);
		returnHTML = returnHTML.replaceAll("#loginID#", loginID);
		returnHTML = returnHTML.replaceAll("#EmployeeNum#", EmployeeNum);
		returnHTML = returnHTML.replaceAll("#TeamName#", TeamName);
		returnHTML = returnHTML.replaceAll("#Email#", Email);
		returnHTML = returnHTML.replaceAll("#today#", today);
		returnHTML = returnHTML.replaceAll("#itemName#", itemName);
		returnHTML = returnHTML.replaceAll("#subject#", subject);
		returnHTML = returnHTML.replaceAll("#content#", content);
		returnHTML = returnHTML.replaceAll("#boardMgtName#", boardMgtName);
		returnHTML = returnHTML.replaceAll("#relTeamMembers#", relTeamMembers);
		returnHTML = returnHTML.replaceAll("#itemID#", itemID);
		returnHTML = returnHTML.replaceAll("#changeSetID#", changeSetID);
		returnHTML = returnHTML.replaceAll("#SC_END_DT#", SC_END_DT);
		returnHTML = returnHTML.replaceAll("#OLM_SERVER_URL#", OLM_SERVER_URL);

		/***/
		
		System.out.println(returnHTML);
		return returnHTML;
	}	
	
	// Post Processing Mail Form after final  approval 
	public static String makeHTML_APRVCLS(Map cmmCnts, Map menu){
		String wfInstanceID = StringUtil.checkNull(cmmCnts.get("wfInstanceID"));
		String description = StringUtil.checkNull(cmmCnts.get("emDescription"));
		description = StringUtil.checkNull(description).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		description = StringUtil.checkNull(description).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
		
		List wfInstList = (List) cmmCnts.get("wfInstList");
		List wfRefInstList = (List) cmmCnts.get("wfRefInstList");
		
		String returnHTML="";
		
		returnHTML += "<!doctype html><html><body>";
		returnHTML += "<table style=\"font-size: 14px;border-collapse: collapse; table-layout:fixed;text-align:left;margin-bottom:10px;\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tr><td>";
		
		returnHTML +=  "[" + wfInstanceID + "] "  + description;
		returnHTML += "</td></tr></table>" + newLine;
		
		//Approval History List 출력 부분 
		String wfInstListHTML = openTable + newLine;
		wfInstListHTML+= "<colgroup><col width=\"10%\"><col width=\"15%\"><col width=\"10%\">";;
		wfInstListHTML+= "<col width=\"10%\"><col width=\"20%\"><col width=\"35%\"></colgroup>"+newLine;

		wfInstListHTML+= " <tr> "+newLine;
		wfInstListHTML+= openTh + StringUtil.checkNull(menu.get("LN00004")) + "</th> "+newLine;
		wfInstListHTML+= openTh + StringUtil.checkNull(menu.get("LN00104")) + "</th> "+newLine;
		wfInstListHTML+= openTh + StringUtil.checkNull(menu.get("LN00120")) + "</th> "+newLine;
		wfInstListHTML+= openTh + StringUtil.checkNull(menu.get("LN00027")) + "</th> "+newLine;
		wfInstListHTML+= openTh + "Approval Date </th> "+newLine;
		wfInstListHTML+= openTh + "Comment </th> "+newLine;
		wfInstListHTML+= " </tr>"+newLine;
		
		if(wfInstList.size()>0) {
			for(int i=0; i<wfInstList.size(); i++) {
				Map tempMap = (Map) wfInstList.get(i);
				wfInstListHTML+= " <tr style=\"font-family:Apple SD Gothic Neo, sans-serif;\"> "+newLine;			
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("ActorName"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("TeamName"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("WFStepName"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("StatusNM"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("ApprovalDate"))+"</td>";		
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("Comment"))+"</td>";	
				wfInstListHTML+= " </tr>";
			}
		}
		if(wfRefInstList.size()>0) {
			for(int i=0; i<wfRefInstList.size(); i++) {
				Map tempMap = (Map) wfRefInstList.get(i);
				wfInstListHTML+= " <tr style=\"font-family:Apple SD Gothic Neo, sans-serif;\"> "+newLine;			
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("ActorName"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("TeamName"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("WFStepName"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("StatusNM"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("ApprovalDate"))+"</td>";		
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("Comment"))+"</td>";	
				wfInstListHTML+= " </tr>";
			}
		}
		wfInstListHTML+= closeTable+newLine;
		wfInstListHTML+= endHTML+newLine;
		
		returnHTML += wfInstListHTML;
		
		System.out.println(returnHTML);
		return returnHTML;
	}	
	
	// 전자결제 반려 HTML 
	public static String makeHTML_APRVRJT(Map cmmCnts, Map menu){
		String description = StringUtil.checkNull(cmmCnts.get("emDescription"));
		description = StringUtil.checkNull(description).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		description = StringUtil.checkNull(description).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
		
		String wfInstanceID = StringUtil.checkNull(cmmCnts.get("wfInstanceID"));
		String returnHTML="";
		
		List wfInstList = (List) cmmCnts.get("wfInstList");
		List wfRefInstList = (List) cmmCnts.get("wfRefInstList");
		
		returnHTML += "<!doctype html><html><body>";
		returnHTML += "<table style=\"font-size: 14px;border-collapse: collapse; table-layout:fixed;text-align:left;margin-bottom:10px;\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tr><td>";
		
		returnHTML +=  "[" + wfInstanceID + "] "  + description;
		returnHTML += "</td></tr></table>" + newLine;
		
		//Approval History List 출력 부분 
		String wfInstListHTML = openTable + newLine;
		wfInstListHTML+= "<colgroup><col width=\"10%\"><col width=\"15%\"><col width=\"10%\">";;
		wfInstListHTML+= "<col width=\"10%\"><col width=\"20%\"><col width=\"35%\"></colgroup>"+newLine;

		wfInstListHTML+= " <tr> "+newLine;
		wfInstListHTML+= openTh + StringUtil.checkNull(menu.get("LN00004")) + "</th> "+newLine;
		wfInstListHTML+= openTh + StringUtil.checkNull(menu.get("LN00104")) + "</th> "+newLine;
		wfInstListHTML+= openTh + StringUtil.checkNull(menu.get("LN00120")) + "</th> "+newLine;
		wfInstListHTML+= openTh + StringUtil.checkNull(menu.get("LN00027")) + "</th> "+newLine;
		wfInstListHTML+= openTh + "Approval Date </th> "+newLine;
		wfInstListHTML+= openTh + "Comment </th> "+newLine;
		wfInstListHTML+= " </tr>"+newLine;
		
		if(wfInstList.size()>0) {
			for(int i=0; i<wfInstList.size(); i++) {
				Map tempMap = (Map) wfInstList.get(i);
				wfInstListHTML+= " <tr style=\"font-family:Apple SD Gothic Neo, sans-serif;\"> "+newLine;			
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("ActorName"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("TeamName"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("WFStepName"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("StatusNM"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("ApprovalDate"))+"</td>";		
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("Comment"))+"</td>";	
				wfInstListHTML+= " </tr>";
			}
		}
		if(wfRefInstList.size()>0) {
			for(int i=0; i<wfRefInstList.size(); i++) {
				Map tempMap = (Map) wfRefInstList.get(i);
				wfInstListHTML+= " <tr style=\"font-family:Apple SD Gothic Neo, sans-serif;\"> "+newLine;			
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("ActorName"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("TeamName"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("WFStepName"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("StatusNM"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("ApprovalDate"))+"</td>";		
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("Comment"))+"</td>";	
				wfInstListHTML+= " </tr>";
			}
		}
		wfInstListHTML+= closeTable+newLine;
		wfInstListHTML+= endHTML+newLine;
		
		returnHTML += wfInstListHTML;
		
		System.out.println(returnHTML);
		return returnHTML;
	}	
	
	// Term REG Mail Form
	public static String makeHTML_TERMREG(Map cmmCnts, Map menu){
		
		String content = StringUtil.checkNull(cmmCnts.get("content")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
		String returnHTML="";
		
		returnHTML+= "<!doctype html><html><body>";
		returnHTML += content;
		returnHTML+= "</body></html>";
		
		System.out.println(returnHTML);
		return returnHTML;
	}	
	
	// Term REL Mail Form
	public static String makeHTML_TERMREL(Map cmmCnts, Map menu){
		
		String description = StringUtil.checkNull(cmmCnts.get("emDescription")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
		description = StringUtil.checkNull(description).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		description = StringUtil.checkNull(description).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
		
		String returnHTML="";
		
		returnHTML+= "<!doctype html><html><body>";
		returnHTML += description;
		returnHTML+= "</body></html>";
		
		System.out.println(returnHTML);
		return returnHTML;
	}	
	
	public static String makeHTML_SCHDL(HashMap cmmCnts, Map menu){
		String subject = StringUtil.checkNull(cmmCnts.get("Subject"),"");
		String location = StringUtil.checkNull(cmmCnts.get("location"),"");			
		String startDT = StringUtil.checkNull(cmmCnts.get("StartDT"),"");
		String endDT = StringUtil.checkNull(cmmCnts.get("EndDT"),"");
		
		String projectName = StringUtil.checkNull(cmmCnts.get("projectName"),"");
		String sharerNames = StringUtil.checkNull(cmmCnts.get("sharerNames"),"");
		String docCategoryName = StringUtil.checkNull(cmmCnts.get("docCategoryName"),"");
		String disclScope = StringUtil.checkNull(cmmCnts.get("disclScope"),"");
		String disclScopeName = StringUtil.checkNull(cmmCnts.get("disclScopeName"),"");
		if(disclScope.equals("PJT")) {
			disclScopeName += " / " + projectName;
		}
		String docNO = StringUtil.checkNull(cmmCnts.get("docNO"),"");
		if(!docNO.equals("")) {
			docCategoryName = docCategoryName + "/" + docNO;
		}
		String content = StringUtil.checkNull(cmmCnts.get("Content")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
		String userNm = StringUtil.checkNull(cmmCnts.get("userNm"),"");
		String regDT = StringUtil.checkNull(cmmCnts.get("RegDT"),"");
		
		String alarmOptionName = StringUtil.checkNull(cmmCnts.get("alarmOptionName"),"");
		String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
		String LN00002 = StringUtil.checkNull(menu.get("LN00002"));
		String LN00324 = StringUtil.checkNull(menu.get("LN00324"));
		String LN00325 = StringUtil.checkNull(menu.get("LN00325"));
		String LN00237 = StringUtil.checkNull(menu.get("LN00237"));
		
		String LN00033 = StringUtil.checkNull(menu.get("LN00033"));
		String LN00078 = StringUtil.checkNull(menu.get("LN00078"));
		
		String LN00212 = StringUtil.checkNull(menu.get("LN00212"));
		String LN00245 = StringUtil.checkNull(menu.get("LN00245"));
		String LN00334 = StringUtil.checkNull(menu.get("LN00334"));
		String LN00336 = StringUtil.checkNull(menu.get("LN00336"));
		String LN00337 = StringUtil.checkNull(menu.get("LN00337"));
		
		String returnHTML = emailHTMLForm;
		returnHTML = returnHTML.replaceAll("#LN00002#", LN00002);
		returnHTML = returnHTML.replaceAll("#subject#", subject);
		returnHTML = returnHTML.replaceAll("#LN00336#", LN00336);
		returnHTML = returnHTML.replaceAll("#content#", content);
		returnHTML = returnHTML.replaceAll("#LN00237#", LN00237);
		returnHTML = returnHTML.replaceAll("#location#", location);
		returnHTML = returnHTML.replaceAll("#LN00324#", LN00324);
		returnHTML = returnHTML.replaceAll("#StartDT#", startDT);
		returnHTML = returnHTML.replaceAll("#LN00325#", LN00325);
		returnHTML = returnHTML.replaceAll("#EndDT#", endDT);
		returnHTML = returnHTML.replaceAll("#LN00337#", LN00337);
		returnHTML = returnHTML.replaceAll("#disclScopeName#", disclScopeName);
		returnHTML = returnHTML.replaceAll("#LN00334#", LN00334);
		returnHTML = returnHTML.replaceAll("#alarmOptionName#", alarmOptionName);
		returnHTML = returnHTML.replaceAll("#LN00245#", LN00245);
		returnHTML = returnHTML.replaceAll("#sharerNames#", sharerNames);
		returnHTML = returnHTML.replaceAll("#LN00033#", LN00033);
		returnHTML = returnHTML.replaceAll("#docCategoryName#", docCategoryName);
		returnHTML = returnHTML.replaceAll("#LN00078#", LN00078);
		returnHTML = returnHTML.replaceAll("#regDT#", regDT);
		returnHTML = returnHTML.replaceAll("#LN00212#", LN00212);
		returnHTML = returnHTML.replaceAll("#userNm#", userNm);
		returnHTML = returnHTML.replaceAll("#OLM_SERVER_URL#", OLM_SERVER_URL);
		returnHTML = returnHTML.replaceAll("#HTML_IMG_DIR#", HTML_IMG_DIR);
		return returnHTML;
	}
	
	public static String makeHTML_RQUSRAUTH(HashMap cmmCnts, Map menu){
		String userNm = StringUtil.checkNull(cmmCnts.get("userNm"),"");
		String userTeamName = StringUtil.checkNull(cmmCnts.get("userTeamName"),"");	
		String userEmpNm = StringUtil.checkNull(cmmCnts.get("userEmpNm"),"");	
		String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
		
		String returnHTML = emailHTMLForm;
		returnHTML = returnHTML.replaceAll("#userNm#", userNm);
		returnHTML = returnHTML.replaceAll("#userTeamName#", userTeamName);
		returnHTML = returnHTML.replaceAll("#userEmpNm#", userEmpNm);
		returnHTML = returnHTML.replaceAll("#OLM_SERVER_URL#", OLM_SERVER_URL);
		returnHTML = returnHTML.replaceAll("#HTML_IMG_DIR#", HTML_IMG_DIR);
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
		sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:맑은 고딕;height:25px; '>  CTS No. </th>");
		sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:맑은 고딕;'>");
		sb.append(cmmCnts.get("ctrCode")); 
		sb.append("</td>");
		sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:맑은 고딕;height:25px; '>  업무 영역 </th>");
		sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:맑은 고딕;'>");
		sb.append(cmmCnts.get("sysArea1NM"));  
		sb.append("</td>");
		sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:맑은 고딕;height:25px; '>  시스템 </th>");
		sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:맑은 고딕;'>");
		sb.append(cmmCnts.get("sysArea2NM"));  
		sb.append("</td>");
		sb.append("</tr>");
		
		sb.append("<tr>");
		sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:맑은 고딕;height:25px; '> 긴급 </th>");
		sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:맑은 고딕;'>");
		sb.append(StringUtil.checkNull(cmmCnts.get("urgencyYNName"),"")); 
		sb.append("</td>");
		sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:맑은 고딕;height:25px; '> 상태 </th>");
		sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:맑은 고딕;'>");
		sb.append(cmmCnts.get("statusNM"));  
		sb.append("</td>");
		sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:맑은 고딕;height:25px; '> SCR No. </th>");
		sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:맑은 고딕;'>");
		sb.append(cmmCnts.get("scrCode"));  
		sb.append("</td>");
		sb.append("</tr>");
		sb.append("</table>");
		sb.append("<br>");
		sb.append("<br>");
		if((status.equals("CTSREQ") && urgencyYN.equals("N")) ||  (status.equals("CTSREQ") && urgencyYN.equals("Y")) ) {
			/* 요청 후 */
			sb.append("<table style='border-bottom:1px solid #000;text-align:center;' width='100%' border='1' cellpadding='0' cellspacing='0'>");
			sb.append("<colgroup>");
			sb.append("<col width='14%'>");
			sb.append("<col width='36%'>");
			sb.append("<col width='14%'>");
			sb.append("<col width='36%'>");
			sb.append("</colgroup>");
			sb.append("<tr>");
			sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:맑은 고딕;height:25px; '>  요청자  </th>");
			sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:맑은 고딕;'>");
			sb.append(cmmCnts.get("regTName"));  
			sb.append("</td>");
			sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:맑은 고딕;height:25px; '>  요청일 </th>");
			sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:맑은 고딕;'>");
			sb.append(cmmCnts.get("regDTM"));  
			sb.append("</td>");
			sb.append("</tr>");
			sb.append("<tr>");
			sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:맑은 고딕;height:25px; '>  제목 </th>");
			sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:맑은 고딕;' colspan=3>");
			sb.append(cmmCnts.get("subject"));  
			sb.append("</td>");
			sb.append("</tr>");
			sb.append("<tr>");
			sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:맑은 고딕;height:25px; '>  설명</th>");
			sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:맑은 고딕;' colspan=3><br>");
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
			/* 검토 후 */
			sb.append("<table style='border-bottom:1px solid #000;text-align:center;' width='100%' border='1' cellpadding='0' cellspacing='0'>");
			sb.append("<colgroup>");
			sb.append("<col width='14%'>");
			sb.append("<col width='36%'>");
			sb.append("<col width='14%'>");
			sb.append("<col width='36%'>");
			sb.append("</colgroup>");
			sb.append("<tr>");
			sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:맑은 고딕;height:25px; '>  검토자  </th>");
			sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:맑은 고딕;'>");
			sb.append(cmmCnts.get("reviewerTName"));  
			sb.append("</td>");
			sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:맑은 고딕;height:25px; '>  검토일 </th>");
			sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:맑은 고딕;'>");
			sb.append(cmmCnts.get("reviewDTM"));  
			sb.append("</td>");
			sb.append("</tr>");
			sb.append("<tr>");
			sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:맑은 고딕;height:25px; '>  검토 내용</th>");
			sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:맑은 고딕;' colspan=3><br>");
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
		/* 승인 후 */
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
			sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:맑은 고딕;height:25px; '>  승인자</th>");
			sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:맑은 고딕;'>");
			sb.append(cmmCnts.get("approverTName")); 
			sb.append("</td>");
			sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:맑은 고딕;height:25px; '>  승인 일자 </th>");
			sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:맑은 고딕;'>");
			sb.append(cmmCnts.get("approvalDTM"));  
			sb.append("</td>");
			sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:맑은 고딕;height:25px; '>  승인/거절 </th>");
			sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:맑은 고딕;'>");
			sb.append(cmmCnts.get("aprvStatusNM"));  
			sb.append("</td>");
			sb.append("</tr>");
			sb.append("<tr>");
			sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:맑은 고딕;height:25px; '> 승인 내용 </th>");
			sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:맑은 고딕;' colspan=5><br>");
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
			/* 실행 후 */
			sb.append("<table style='border-bottom:1px solid #000;text-align:center;' width='100%' border='1' cellpadding='0' cellspacing='0'>");
			sb.append("<colgroup>");
			sb.append("<col width='14%'>");
			sb.append("<col width='36%'>");
			sb.append("<col width='14%'>");
			sb.append("<col width='36%'>");
			sb.append("</colgroup>");
			sb.append("<tr>");
			sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:맑은 고딕;height:25px; '> 실행자 </th>");
			sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:맑은 고딕;'>");
			sb.append(cmmCnts.get("CTUserNM2"));  
			sb.append("</td>");
			sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:맑은 고딕;height:25px; '>  실행일 </th>");
			sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:맑은 고딕;'>");
			sb.append(cmmCnts.get("CTExeDTM"));  
			sb.append("</td>");
			sb.append("</tr>");
			sb.append("<tr>");
			sb.append("<th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:맑은 고딕;height:25px; '> 실행 내용 </th>");
			sb.append("<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:맑은 고딕;' colspan=3><br>");
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
		
	// Request Approval SR
	public static String makeHTML_SRAPREQ(Map cmmCnts, Map menu){
		String wfStepInstInfo = StringUtil.checkNull(cmmCnts.get("wfStepInstInfo"));
		List wfInstList = (List) cmmCnts.get("wfInstList");
		
		Map wfInstInfo = (Map) cmmCnts.get("wfInstInfo");
		Map getSRInfoMap = (Map) cmmCnts.get("getSRInfoMap"); 
		
		System.out.println("SRAPREQ==wfInstList== "+wfInstList);
		
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
		String LN00091 = StringUtil.checkNull(menu.get("LN00091"));
		String LN00035 = StringUtil.checkNull(menu.get("LN00035"));
		
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
		String DueDate = StringUtil.checkNull(getSRInfoMap.get("DueDate"));
		String Subject = StringUtil.checkNull(wfInstInfo.get("Subject"));
		String SRDescription = StringUtil.checkNull(getSRInfoMap.get("Description").toString().replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\""));
		SRDescription = StringUtil.checkNull(SRDescription).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		SRDescription = StringUtil.checkNull(SRDescription).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
		String Description = StringUtil.checkNull(wfInstInfo.get("Description").toString().replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\""));
		Description = StringUtil.checkNull(Description).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		Description = StringUtil.checkNull(Description).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
		
		String returnHTML = emailHTMLForm;
		returnHTML = returnHTML.replaceAll("#LN00134#", LN00134);
		returnHTML = returnHTML.replaceAll("#LN00122#", LN00122);
		returnHTML = returnHTML.replaceAll("#LN00027#", LN00027);
		returnHTML = returnHTML.replaceAll("#LN00140#", LN00140);
		returnHTML = returnHTML.replaceAll("#LN00025#", LN00025);
		returnHTML = returnHTML.replaceAll("#LN00093#", LN00093);
		returnHTML = returnHTML.replaceAll("#LN00221#", LN00221);
		returnHTML = returnHTML.replaceAll("#LN00002#", LN00002);
		returnHTML = returnHTML.replaceAll("#LN00290#", LN00290);
		returnHTML = returnHTML.replaceAll("#LN00091#", LN00091);
		returnHTML = returnHTML.replaceAll("#LN00035#", LN00035);
		
		returnHTML = returnHTML.replaceAll("#WFInstanceID#", WFInstanceID);
		returnHTML = returnHTML.replaceAll("#OLM_SERVER_NAME#", OLM_SERVER_NAME);
		returnHTML = returnHTML.replaceAll("#SRCode#", SRCode);
		returnHTML = returnHTML.replaceAll("#WFDocType#", WFDocType);
		returnHTML = returnHTML.replaceAll("#StatusName#", StatusName);
		returnHTML = returnHTML.replaceAll("#wfStepInstInfo#", ReqUserNM+"(요청) >> " + wfStepInstInfo);
		returnHTML = returnHTML.replaceAll("#SRArea1Name#", SRArea1Name);
		returnHTML = returnHTML.replaceAll("#SRArea2Name#", SRArea2Name);
		returnHTML = returnHTML.replaceAll("#SRArea1NM#", SRArea1NM);
		returnHTML = returnHTML.replaceAll("#SRArea2NM#", SRArea2NM);
		returnHTML = returnHTML.replaceAll("#ReqUserNM#", ReqUserNM);
		returnHTML = returnHTML.replaceAll("#RegDate#", RegDate);
		returnHTML = returnHTML.replaceAll("#ReqDueDate#", DueDate);
		returnHTML = returnHTML.replaceAll("#Subject#", Subject);
		returnHTML = returnHTML.replaceAll("#SRDescription#", SRDescription);
		returnHTML = returnHTML.replaceAll("#Description#", Description);
		returnHTML = returnHTML.replaceAll("#OLM_SERVER_URL#", OLM_SERVER_URL);
		returnHTML = returnHTML.replaceAll("#HTML_IMG_DIR#", HTML_IMG_DIR);
		
		String projectID = StringUtil.checkNull(cmmCnts.get("projectID"));
		
		String stepInstID = StringUtil.checkNull(cmmCnts.get("stepInstID"));
		String actorID = StringUtil.checkNull(cmmCnts.get("actorID"));
		String stepSeq = StringUtil.checkNull(cmmCnts.get("stepSeq"));			
		String wfInstanceID = StringUtil.checkNull(cmmCnts.get("wfInstanceID"));
		String lastSeq = StringUtil.checkNull(cmmCnts.get("lastSeq"));
		String documentID = StringUtil.checkNull(cmmCnts.get("documentID"));
		String srID = StringUtil.checkNull(cmmCnts.get("srID"));
		String docCategory = StringUtil.checkNull(cmmCnts.get("docCategory"));					
		
		returnHTML = returnHTML.replaceAll("#languageID#", languageID);
		returnHTML = returnHTML.replaceAll("#projectID#", projectID);
		returnHTML = returnHTML.replaceAll("#stepInstID#", stepInstID);
		
		returnHTML = returnHTML.replaceAll("#actorID#", actorID);
		returnHTML = returnHTML.replaceAll("#stepSeq#", stepSeq);
		returnHTML = returnHTML.replaceAll("#lastSeq#", lastSeq);
		returnHTML = returnHTML.replaceAll("#documentID#", documentID);
		returnHTML = returnHTML.replaceAll("#srID#", srID);
		returnHTML = returnHTML.replaceAll("#docCategory#", docCategory);
		
		String btnImgPath = OLM_SERVER_URL+HTML_IMG_DIR;
		returnHTML = returnHTML.replaceAll("#btnImgPath#", btnImgPath);
					
		System.out.println(returnHTML);			return returnHTML;
	}	
	
	// Approve SR
	public static String makeHTML_SRAPREL(Map cmmCnts, Map menu){
		
		String description = StringUtil.checkNull(cmmCnts.get("emDescription"));
		description = StringUtil.checkNull(description).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		description = StringUtil.checkNull(description).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
		
		List wfInstList = (List) cmmCnts.get("wfInstList");
		List wfRefInstList = (List) cmmCnts.get("wfRefInstList");
		
		String docNo = StringUtil.checkNull(cmmCnts.get("docNo"));
		String returnHTML="";
		
		returnHTML += "<!doctype html><html><body>";
		returnHTML += "<table style=\"font-size: 14px;border-collapse: collapse; table-layout:fixed;text-align:left;margin-bottom:10px;\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tr><td>";
		returnHTML +=  "[" + docNo + "] "  + description;
		returnHTML += "</td></tr></table>" + newLine;
		
		//Approval History List 출력 부분 
		String wfInstListHTML = openTable + newLine;
		wfInstListHTML+= "<colgroup><col width=\"10%\"><col width=\"15%\"><col width=\"10%\">";;
		wfInstListHTML+= "<col width=\"10%\"><col width=\"20%\"><col width=\"35%\"></colgroup>"+newLine;

		wfInstListHTML+= " <tr> "+newLine;
		wfInstListHTML+= openTh + StringUtil.checkNull(menu.get("LN00004")) + "</th> "+newLine;
		wfInstListHTML+= openTh + StringUtil.checkNull(menu.get("LN00104")) + "</th> "+newLine;
		wfInstListHTML+= openTh + StringUtil.checkNull(menu.get("LN00120")) + "</th> "+newLine;
		wfInstListHTML+= openTh + StringUtil.checkNull(menu.get("LN00027")) + "</th> "+newLine;
		wfInstListHTML+= openTh + "Approval Date </th> "+newLine;
		wfInstListHTML+= openTh + "Comment </th> "+newLine;
		wfInstListHTML+= " </tr>"+newLine;
		
		if(wfInstList.size()>0) {
			for(int i=0; i<wfInstList.size(); i++) {
				Map tempMap = (Map) wfInstList.get(i);
				wfInstListHTML+= " <tr style=\"font-family:Apple SD Gothic Neo, sans-serif;\"> "+newLine;			
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("ActorName"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("TeamName"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("WFStepName"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("StatusNM"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("ApprovalDate"))+"</td>";		
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("Comment"))+"</td>";	
				wfInstListHTML+= " </tr>";
			}
		}
		if(wfRefInstList.size()>0) {
			for(int i=0; i<wfRefInstList.size(); i++) {
				Map tempMap = (Map) wfRefInstList.get(i);
				wfInstListHTML+= " <tr style=\"font-family:Apple SD Gothic Neo, sans-serif;\"> "+newLine;			
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("ActorName"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("TeamName"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("WFStepName"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("StatusNM"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("ApprovalDate"))+"</td>";		
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("Comment"))+"</td>";	
				wfInstListHTML+= " </tr>";
			}
		}
		wfInstListHTML+= closeTable+newLine;
		wfInstListHTML+= endHTML+newLine;
		
		returnHTML += wfInstListHTML;
		
		System.out.println(returnHTML);
		return returnHTML;
	}	
	
	// SR Approve Reject
	public static String makeHTML_SRAPRJT(Map cmmCnts, Map menu){
		String docNo = StringUtil.checkNull(cmmCnts.get("docNo"));
		String description = StringUtil.checkNull(cmmCnts.get("emDescription"));
		description = StringUtil.checkNull(description).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		description = StringUtil.checkNull(description).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
		
		List wfInstList = (List) cmmCnts.get("wfInstList");
		List wfRefInstList = (List) cmmCnts.get("wfRefInstList");
		
		String returnHTML="";
		
		returnHTML += "<!doctype html><html><body>";
		returnHTML += "<table style=\"font-size: 14px;border-collapse: collapse; table-layout:fixed;text-align:left;margin-bottom:10px;\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tr><td>";
		returnHTML +=  "[" + docNo + "] "  + description;
		returnHTML += "</td></tr></table>" + newLine;
		
		//Approval History List 출력 부분 
		String wfInstListHTML = openTable + newLine;
		wfInstListHTML+= "<colgroup><col width=\"10%\"><col width=\"15%\"><col width=\"10%\">";;
		wfInstListHTML+= "<col width=\"10%\"><col width=\"20%\"><col width=\"35%\"></colgroup>"+newLine;

		wfInstListHTML+= " <tr> "+newLine;
		wfInstListHTML+= openTh + StringUtil.checkNull(menu.get("LN00004")) + "</th> "+newLine;
		wfInstListHTML+= openTh + StringUtil.checkNull(menu.get("LN00104")) + "</th> "+newLine;
		wfInstListHTML+= openTh + StringUtil.checkNull(menu.get("LN00120")) + "</th> "+newLine;
		wfInstListHTML+= openTh + StringUtil.checkNull(menu.get("LN00027")) + "</th> "+newLine;
		wfInstListHTML+= openTh + "Approval Date </th> "+newLine;
		wfInstListHTML+= openTh + "Comment </th> "+newLine;
		wfInstListHTML+= " </tr>"+newLine;
		
		if(wfInstList.size()>0) {
			for(int i=0; i<wfInstList.size(); i++) {
				Map tempMap = (Map) wfInstList.get(i);
				wfInstListHTML+= " <tr style=\"font-family:Apple SD Gothic Neo, sans-serif;\"> "+newLine;			
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("ActorName"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("TeamName"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("WFStepName"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("StatusNM"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("ApprovalDate"))+"</td>";		
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("Comment"))+"</td>";	
				wfInstListHTML+= " </tr>";
			}
		}
		if(wfRefInstList.size()>0) {
			for(int i=0; i<wfRefInstList.size(); i++) {
				Map tempMap = (Map) wfRefInstList.get(i);
				wfInstListHTML+= " <tr style=\"font-family:Apple SD Gothic Neo, sans-serif;\"> "+newLine;			
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("ActorName"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("TeamName"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("WFStepName"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("StatusNM"))+"</td>";
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("ApprovalDate"))+"</td>";		
				wfInstListHTML+= openTd+StringUtil.checkNull(tempMap.get("Comment"))+"</td>";	
				wfInstListHTML+= " </tr>";
			}
		}
		wfInstListHTML+= closeTable+newLine;					
		wfInstListHTML+= endHTML+newLine;
		
		returnHTML += wfInstListHTML;
		
		System.out.println(returnHTML);
		return returnHTML;
	}	
	
	// Change SR Due Date
	public static String makeHTML_SRCNGRDD(Map cmmCnts, Map menu){
		String srID = StringUtil.checkNull(cmmCnts.get("SRID"));
		String srCode = StringUtil.checkNull(cmmCnts.get("SRCode"));
		String srType = StringUtil.checkNull(cmmCnts.get("SRType"));
		String subject = StringUtil.checkNull(cmmCnts.get("Subject"));
		
		String languageID = StringUtil.checkNull(cmmCnts.get("languageID"));
		String loginID = StringUtil.checkNull(cmmCnts.get("loginID"));
		String dueDate = StringUtil.checkNull(cmmCnts.get("dueDate"));
		String dueDateTime = StringUtil.checkNull(cmmCnts.get("dueDateTime"));
		String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
		String LN00002 = StringUtil.checkNull(menu.get("LN00002"));
		String LN00221 = StringUtil.checkNull(menu.get("LN00221"));
		
		String returnHTML = emailHTMLForm;
		returnHTML = returnHTML.replaceAll("#LN00002#", LN00002);
		returnHTML = returnHTML.replaceAll("#LN00221#", LN00221);
		returnHTML = returnHTML.replaceAll("#OLM_SERVER_NAME#", OLM_SERVER_NAME);
		returnHTML = returnHTML.replaceAll("#srCode#", srCode);
		returnHTML = returnHTML.replaceAll("#subject#", subject);
		returnHTML = returnHTML.replaceAll("#dueDate#", dueDate);
		returnHTML = returnHTML.replaceAll("#dueDateTime#", dueDateTime);
		returnHTML = returnHTML.replaceAll("#OLM_SERVER_URL#", OLM_SERVER_URL);
		returnHTML = returnHTML.replaceAll("#HTML_IMG_DIR#", HTML_IMG_DIR);
		
		String url = OLM_SERVER_URL+"reqSRDueDateChangeEmail.do?userID="+loginID
					+"&languageID="+languageID+"&srID="+srID+"&srType="+srType
					+"&dueDate="+dueDate+"&dueDateTime="+dueDateTime;
		String btnImgPath = OLM_SERVER_URL+HTML_IMG_DIR;
		
		returnHTML = returnHTML.replaceAll("#url#", url);
		returnHTML = returnHTML.replaceAll("#btnImgPath#", btnImgPath);
		System.out.println(returnHTML);
		
		return returnHTML;
	}	
	
	public static String makeHTML_PIMEM001(Map cmmCnts, Map menu){
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
		String docItemNM = StringUtil.checkNull(cmmCnts.get("docItemNM"));
		String documentNo = StringUtil.checkNull(cmmCnts.get("documentNo"));
		String team = StringUtil.checkNull(cmmCnts.get("team"));
		String roleID = StringUtil.checkNull(cmmCnts.get("roleID"));
		String subject = StringUtil.checkNull(cmmCnts.get("subject"));
		String docItemNo = StringUtil.checkNull(cmmCnts.get("docItemNo"));
		String ZLN0001 = StringUtil.checkNull(menu.get("ZLN0001"));
		
		String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
		

		
		String returnHTML = emailHTMLForm;
		returnHTML = returnHTML.replaceAll("#procInstNo#", procInstNo);
		returnHTML = returnHTML.replaceAll("#elmInstNo#", elmInstNo);
		returnHTML = returnHTML.replaceAll("#procProcessName#", procProcessName);
		returnHTML = returnHTML.replaceAll("#procInstName#", procInstName);
		returnHTML = returnHTML.replaceAll("#elmInstName#", elmInstName);
		returnHTML = returnHTML.replaceAll("#elmProcessName#", elmProcessName);
		returnHTML = returnHTML.replaceAll("#roleItemID#", roleItemID);
		returnHTML = returnHTML.replaceAll("#roleItemName#", roleItemName);
		returnHTML = returnHTML.replaceAll("#pimWorker#", pimWorker);
		returnHTML = returnHTML.replaceAll("#schStartDate#", schStartDate);
		returnHTML = returnHTML.replaceAll("#docItemNM#", docItemNM);
		returnHTML = returnHTML.replaceAll("#documentNo#", documentNo);
		returnHTML = returnHTML.replaceAll("#team#", team);
		returnHTML = returnHTML.replaceAll("#roleID#", roleID);
		returnHTML = returnHTML.replaceAll("#subject#", subject +" "+ ZLN0001);
		returnHTML = returnHTML.replaceAll("#docItemNo#", docItemNo);
		returnHTML = returnHTML.replaceAll("#OLM_SERVER_URL#", OLM_SERVER_URL);
		returnHTML = returnHTML.replaceAll("#HTML_IMG_DIR#", HTML_IMG_DIR);
		
		//String url = OLM_SERVER_URL+"popupMasterItem.do?id="+itemID+"&languageID="+languageID+"&scrnType=pop";		
		//returnHTML = returnHTML.replaceAll("#GW_LINK_URL#", url);
		
		return returnHTML;
	}	
	
	// Post Processing Mail Form after final  approval 
	public static String makeHTML_CSRNTC(Map cmmCnts, Map menu){
		
		String description = StringUtil.checkNull(cmmCnts.get("emDescription"));
		description = StringUtil.checkNull(description).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		description = StringUtil.checkNull(description).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
		
		String returnHTML="";
		
		returnHTML+= "<!doctype html><html><body>";
		returnHTML += description;
		returnHTML+= "</body></html>";
		
		System.out.println(returnHTML);
		return returnHTML;
	}	
	
	public static String makeHTML_REQSYSTEST(Map cmmCnts, Map menu){
		String SCRCode = StringUtil.checkNull(cmmCnts.get("SCRCode"));
		String description = StringUtil.checkNull(cmmCnts.get("emDescription"));
		description = StringUtil.checkNull(description).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		description = StringUtil.checkNull(description).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
		
		String returnHTML="";
		
		returnHTML+= "<!doctype html><html><body>";
		returnHTML +=  "[" + SCRCode + "] "  + description;
		returnHTML+= "</body></html>";
		
		System.out.println(returnHTML);
		return returnHTML;
	}
	
	public static String makeHTML_SCRAPREQ(Map cmmCnts, Map menu){
		String SCRCode = StringUtil.checkNull(cmmCnts.get("SCRCode"));
		String description = StringUtil.checkNull(cmmCnts.get("emDescription"));
		description = StringUtil.checkNull(description).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		description = StringUtil.checkNull(description).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
		
		String returnHTML="";
		
		returnHTML+= "<!doctype html><html><body>";
		returnHTML +=  "[" + SCRCode + "] "  + description;
		returnHTML+= "</body></html>";
		
		System.out.println(returnHTML);
		return returnHTML;
	}
	
	public static String makeHTML_SCRAPREL(Map cmmCnts, Map menu){
		String SCRCode = StringUtil.checkNull(cmmCnts.get("SCRCode"));
		String description = StringUtil.checkNull(cmmCnts.get("emDescription"));
		description = StringUtil.checkNull(description).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		description = StringUtil.checkNull(description).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
		
		String returnHTML="";
		
		returnHTML+= "<!doctype html><html><body>";
		returnHTML +=  "[" + SCRCode + "] "  + description;
		returnHTML+= "</body></html>";
		
		System.out.println(returnHTML);
		return returnHTML;
	}
	
	public static String makeHTML_SCRAPRJT(Map cmmCnts, Map menu){
		String SCRCode = StringUtil.checkNull(cmmCnts.get("SCRCode"));
		String description = StringUtil.checkNull(cmmCnts.get("emDescription"));
		description = StringUtil.checkNull(description).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		description = StringUtil.checkNull(description).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
		
		String returnHTML="";
		
		returnHTML+= "<!doctype html><html><body>";
		returnHTML +=  "[" + SCRCode + "] "  + description;
		returnHTML+= "</body></html>";
		
		System.out.println(returnHTML);
		return returnHTML;
	}
	
	public static String makeHTML_ITSCMP(Map cmmCnts, Map menu){
		String SRCode = StringUtil.checkNull(cmmCnts.get("SRCode"));
		String description = StringUtil.checkNull(cmmCnts.get("emDescription"));
		description = StringUtil.checkNull(description).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		description = StringUtil.checkNull(description).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
		
		String returnHTML="";
		
		returnHTML+= "<!doctype html><html><body>";
		returnHTML +=  "[" + SRCode + "] "  + description;
		returnHTML+= "</body></html>";
		
		System.out.println(returnHTML);
		return returnHTML;
	}
	
	public static String makeHTML_REQSREV(Map cmmCnts, Map menu){
		String SRCode = StringUtil.checkNull(cmmCnts.get("SRCode"));
		String description = StringUtil.checkNull(cmmCnts.get("emDescription"));
		description = StringUtil.checkNull(description).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		description = StringUtil.checkNull(description).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
		
		String returnHTML="";
		
		returnHTML+= "<!doctype html><html><body>";
		returnHTML +=  "[" + SRCode + "] "  + description;
		returnHTML+= "</body></html>";
		
		System.out.println(returnHTML);
		return returnHTML;
	}
	
	//작업 촉진 메일
	public static String makeHTML_WFARLM(HashMap cmmCnts, Map menu){
		
		String alarmMailType = "";
		String returnHTML = "";
		String languageID = StringUtil.checkNull(cmmCnts.get("languageID"));
		String delayDate = StringUtil.checkNull(cmmCnts.get("delayDate"));
		String CreationTime = "";
		String CompletionDT = "";
		
		String LN00391 = StringUtil.checkNull(menu.get("LN00391"));
		String LN00392 = StringUtil.checkNull(menu.get("LN00392"));
		String LN00393 = StringUtil.checkNull(menu.get("LN00393"));
		
		//remindList 출력 부분
		List remindList = (List) cmmCnts.get("remindList");
		
		String remindListHTML = "";
		
		for(int i=0; i<remindList.size(); i++) {
			Map tempMap = (Map) remindList.get(i);
			alarmMailType = StringUtil.checkNull(tempMap.get("alarmMailType"));
			
				remindListHTML+= "<tr style=\"font-family:Apple SD Gothic Neo, sans-serif;\"> "+newLine;
				String td = "<td style=\"border:1px solid #d4d4d4; text-align:center; font-size:14px; padding: 10px 0; color:#000;line-height:23px;vertical-align:top;\">";
				remindListHTML+= td+ (i+1) +"</td>"; //No
				// 구분
				if (alarmMailType.equals("WF")) {
					remindListHTML+= td+ LN00392 + "</td>";
				} else {
					remindListHTML+= td+ LN00393 + "</td>";
				}
				remindListHTML+= td+StringUtil.checkNull(tempMap.get("Version")) + "</td>"; //ID
				remindListHTML+= td+StringUtil.checkNull(tempMap.get("Identifier")) + "</td>"; //ID
				remindListHTML+= td+StringUtil.checkNull(tempMap.get("ItemName")) + "</td>"; //명칭
				remindListHTML+= td+StringUtil.checkNull(tempMap.get("AuthorName")) + "</td>"; //담당자
				remindListHTML+= td+StringUtil.checkNull(tempMap.get("ChangeType")) + "</td>"; //변경구분
				
				CreationTime = StringUtil.checkNull(tempMap.get("CreationTime"));
				CompletionDT = StringUtil.checkNull(tempMap.get("CompletionDT"));
				
				if ("".equals(CreationTime)) CreationTime = "-";
				if ("".equals(CompletionDT)) CompletionDT = "-";
				
				remindListHTML+= td+StringUtil.checkNull(CreationTime,"-") + "</td>"; //상신일
				remindListHTML+= td+StringUtil.checkNull(CompletionDT,"-") + "</td>"; //변경완료일
				remindListHTML+= td+StringUtil.checkNull(tempMap.get("delayDate")) + LN00391 + "</td>"; //경과일
				remindListHTML+= " </tr>";
		}
		
		String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
		returnHTML = emailHTMLForm;
		returnHTML = returnHTML.replaceAll("#OLM_SERVER_URL#", OLM_SERVER_URL);
		returnHTML = returnHTML.replaceAll("#delay#", delayDate);
		returnHTML = returnHTML.replaceAll("#remindListHTML#", remindListHTML);
		
		return returnHTML;
	}
	
	// 등록 ( assign.mail.template )
	public static String makeHTML_ESPMAIL001(HashMap cmmCnts, Map menu) {
		
		String ReqUserNM = StringUtil.checkNull(cmmCnts.get("ReqUserNM"));
		String ReqTeamNM = StringUtil.checkNull(cmmCnts.get("ReqTeamNM"));
		String requestUser = ReqUserNM+"("+ReqTeamNM+")";
		
		String srArea1Name = StringUtil.checkNull(cmmCnts.get("SRArea1Name"));
		String srArea2Name = StringUtil.checkNull(cmmCnts.get("SRArea2Name"));
		
		String srCode = StringUtil.checkNull(cmmCnts.get("SRCode"));
		String subject = StringUtil.checkNull(cmmCnts.get("Subject"));
		String description = StringUtil.checkNull(cmmCnts.get("Description")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
		description = StringUtil.checkNull(description).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		description = StringUtil.checkNull(description).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
		
		String status = StringUtil.checkNull(cmmCnts.get("SRStatusName"));
		String procRoleTPName = StringUtil.checkNull(cmmCnts.get("procRoleTPName"));
		
		String receiptUserNM = StringUtil.checkNull(cmmCnts.get("ReceiptName"));
		String receiptTeamNM = StringUtil.checkNull(cmmCnts.get("ReceiptTeamName"));
		String receiptUser = StringUtil.checkNull(cmmCnts.get("AssignmentRequired"));
		if(!"".equals(receiptUserNM)){
			receiptUser = receiptUserNM+"("+receiptTeamNM+")";
		}
		
		String languageID = StringUtil.checkNull(cmmCnts.get("languageID"));
		String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
		
		String returnHTML = emailHTMLForm;
		returnHTML = returnHTML.replaceAll("#subject#", subject);
		returnHTML = returnHTML.replaceAll("#description#", description);
		returnHTML = returnHTML.replaceAll("#srCode#", srCode);
		returnHTML = returnHTML.replaceAll("#requestUser#", requestUser);
		returnHTML = returnHTML.replaceAll("#ReqUserNM#", ReqUserNM);
		returnHTML = returnHTML.replaceAll("#ReqTeamNM#", ReqTeamNM);
		returnHTML = returnHTML.replaceAll("#srAreaName#", srArea1Name + "/" + srArea2Name);
		returnHTML = returnHTML.replaceAll("#status#", status);
		returnHTML = returnHTML.replaceAll("#procRoleTPName#", procRoleTPName);
		returnHTML = returnHTML.replaceAll("#receiptUser#", receiptUser);
		returnHTML = returnHTML.replaceAll("#OLM_SERVER_URL#", OLM_SERVER_URL);
			
		return returnHTML;
	}
	
	// 완료 ( assign.mail.template )
	public static String makeHTML_ESPMAIL002(HashMap cmmCnts, Map menu) {
		
		String ReqUserNM = StringUtil.checkNull(cmmCnts.get("ReqUserNM"));
		String ReqTeamNM = StringUtil.checkNull(cmmCnts.get("ReqTeamNM"));
		String requestUser = ReqUserNM+"("+ReqTeamNM+")";
		
		String CategoryName = StringUtil.checkNull(cmmCnts.get("CategoryName"));
		String ParentOrgPath = StringUtil.checkNull(cmmCnts.get("ParentOrgPath"));
		
		String srArea1Name = StringUtil.checkNull(cmmCnts.get("SRArea1Name"));
		String srArea2Name = StringUtil.checkNull(cmmCnts.get("SRArea2Name"));
		
		String srCode = StringUtil.checkNull(cmmCnts.get("SRCode"));
		String subject = StringUtil.checkNull(cmmCnts.get("Subject"));
		String description = StringUtil.checkNull(cmmCnts.get("Description")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
		description = StringUtil.checkNull(description).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		description = StringUtil.checkNull(description).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
		
		String status = StringUtil.checkNull(cmmCnts.get("SRStatusName"));
		String procRoleTPName = StringUtil.checkNull(cmmCnts.get("procRoleTPName"));
		
		String receiptUserNM = StringUtil.checkNull(cmmCnts.get("ReceiptName"));
		String receiptTeamNM = StringUtil.checkNull(cmmCnts.get("ReceiptTeamName"));
		String receiptUser = StringUtil.checkNull(cmmCnts.get("AssignmentRequired"));
		if(!"".equals(receiptUserNM)){
			receiptUser = receiptUserNM+"("+receiptTeamNM+")";
		}
		
		String languageID = StringUtil.checkNull(cmmCnts.get("languageID"));
		String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
		
		String returnHTML = emailHTMLForm;
		returnHTML = returnHTML.replaceAll("#subject#", subject);
		returnHTML = returnHTML.replaceAll("#description#", description);
		returnHTML = returnHTML.replaceAll("#srCode#", srCode);
		returnHTML = returnHTML.replaceAll("#requestUser#", requestUser);
		returnHTML = returnHTML.replaceAll("#srAreaName#", srArea1Name + "/" + srArea2Name);
		returnHTML = returnHTML.replaceAll("#status#", status);
		returnHTML = returnHTML.replaceAll("#procRoleTPName#", procRoleTPName);
		returnHTML = returnHTML.replaceAll("#receiptUser#", receiptUser);
		returnHTML = returnHTML.replaceAll("#ReqUserNM#", ReqUserNM);
		returnHTML = returnHTML.replaceAll("#ReqTeamNM#", ReqTeamNM);
		returnHTML = returnHTML.replaceAll("#ParentOrgPath#", ParentOrgPath);
		returnHTML = returnHTML.replaceAll("#CategoryName#", CategoryName);
		returnHTML = returnHTML.replaceAll("#OLM_SERVER_URL#", OLM_SERVER_URL);
		
		String linkParameter = StringUtil.checkNull(cmmCnts.get("linkParameter"));
		returnHTML = returnHTML.replaceAll("#linkParameter#", linkParameter);
			
		return returnHTML;
	}
	
	// 2선접수 ( receipt.mail.template )
	public static String makeHTML_ESPMAIL003(HashMap cmmCnts, Map menu) {
		
		String ReqUserNM = StringUtil.checkNull(cmmCnts.get("ReqUserNM"));
		String ReqTeamNM = StringUtil.checkNull(cmmCnts.get("ReqTeamNM"));
		String requestUser = ReqUserNM+"("+ReqTeamNM+")";
		
		String CategoryName = StringUtil.checkNull(cmmCnts.get("CategoryName"));
		String ParentOrgPath = StringUtil.checkNull(cmmCnts.get("ParentOrgPath"));
		
		String srArea1Name = StringUtil.checkNull(cmmCnts.get("SRArea1Name"));
		String srArea2Name = StringUtil.checkNull(cmmCnts.get("SRArea2Name"));
		
		String srCode = StringUtil.checkNull(cmmCnts.get("SRCode"));
		String subject = StringUtil.checkNull(cmmCnts.get("Subject"));
		String description = StringUtil.checkNull(cmmCnts.get("Description")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
		description = StringUtil.checkNull(description).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		description = StringUtil.checkNull(description).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
		
		String languageID = StringUtil.checkNull(cmmCnts.get("languageID"));
		String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
		
		String returnHTML = emailHTMLForm;
		returnHTML = returnHTML.replaceAll("#subject#", subject);
		returnHTML = returnHTML.replaceAll("#description#", description);
		returnHTML = returnHTML.replaceAll("#srCode#", srCode);
		returnHTML = returnHTML.replaceAll("#requestUser#", requestUser);
		returnHTML = returnHTML.replaceAll("#ReqUserNM#", ReqUserNM);
		returnHTML = returnHTML.replaceAll("#ReqTeamNM#", ReqTeamNM);
		returnHTML = returnHTML.replaceAll("#srAreaName#", srArea1Name + "/" + srArea2Name);
		returnHTML = returnHTML.replaceAll("#ParentOrgPath#", ParentOrgPath);
		returnHTML = returnHTML.replaceAll("#CategoryName#", CategoryName);
		returnHTML = returnHTML.replaceAll("#OLM_SERVER_URL#", OLM_SERVER_URL);
		
		String linkParameter = StringUtil.checkNull(cmmCnts.get("linkParameter"));
		returnHTML = returnHTML.replaceAll("#linkParameter#", linkParameter);
			
		return returnHTML;
	}
	
	// 반려 ( denied.mail.template )
	public static String makeHTML_ESPMAIL004(HashMap cmmCnts, Map menu) {
		
		String ReqUserNM = StringUtil.checkNull(cmmCnts.get("ReqUserNM"));
		String ReqTeamNM = StringUtil.checkNull(cmmCnts.get("ReqTeamNM"));
		String requestUser = ReqUserNM+"("+ReqTeamNM+")";
		
		String CategoryName = StringUtil.checkNull(cmmCnts.get("CategoryName"));
		String ParentOrgPath = StringUtil.checkNull(cmmCnts.get("ParentOrgPath"));
		
		String srArea1Name = StringUtil.checkNull(cmmCnts.get("SRArea1Name"));
		String srArea2Name = StringUtil.checkNull(cmmCnts.get("SRArea2Name"));
		
		String srCode = StringUtil.checkNull(cmmCnts.get("SRCode"));
		String subject = StringUtil.checkNull(cmmCnts.get("Subject"));
		String description = StringUtil.checkNull(cmmCnts.get("Description")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
		description = StringUtil.checkNull(description).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		description = StringUtil.checkNull(description).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
		
		String receiptUserNM = StringUtil.checkNull(cmmCnts.get("ReceiptName"));
		String receiptTeamNM = StringUtil.checkNull(cmmCnts.get("ReceiptTeamName"));
		String receiptUser = StringUtil.checkNull(cmmCnts.get("AssignmentRequired"));
		if(!"".equals(receiptUserNM)){
			receiptUser = receiptUserNM+"("+receiptTeamNM+")";
		}
		
		String languageID = StringUtil.checkNull(cmmCnts.get("languageID"));
		String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
		
		String returnHTML = emailHTMLForm;
		returnHTML = returnHTML.replaceAll("#subject#", subject);
		returnHTML = returnHTML.replaceAll("#description#", description);
		returnHTML = returnHTML.replaceAll("#srCode#", srCode);
		returnHTML = returnHTML.replaceAll("#requestUser#", requestUser);
		returnHTML = returnHTML.replaceAll("#ReqUserNM#", ReqUserNM);
		returnHTML = returnHTML.replaceAll("#ReqTeamNM#", ReqTeamNM);
		returnHTML = returnHTML.replaceAll("#srAreaName#", srArea1Name + "/" + srArea2Name);
		returnHTML = returnHTML.replaceAll("#receiptUser#", receiptUser);
		returnHTML = returnHTML.replaceAll("#ParentOrgPath#", ParentOrgPath);
		returnHTML = returnHTML.replaceAll("#CategoryName#", CategoryName);
		returnHTML = returnHTML.replaceAll("#OLM_SERVER_URL#", OLM_SERVER_URL);
		
		String linkParameter = StringUtil.checkNull(cmmCnts.get("linkParameter"));
		returnHTML = returnHTML.replaceAll("#linkParameter#", linkParameter);
		
		return returnHTML;
	}
	
	// 기각 ( denied.mail.template )
	public static String makeHTML_ESPMAIL005(HashMap cmmCnts, Map menu) {
		
		String ReqUserNM = StringUtil.checkNull(cmmCnts.get("ReqUserNM"));
		String ReqTeamNM = StringUtil.checkNull(cmmCnts.get("ReqTeamNM"));
		String requestUser = ReqUserNM+"("+ReqTeamNM+")";
		
		String CategoryName = StringUtil.checkNull(cmmCnts.get("CategoryName"));
		String ParentOrgPath = StringUtil.checkNull(cmmCnts.get("ParentOrgPath"));
		
		String srArea1Name = StringUtil.checkNull(cmmCnts.get("SRArea1Name"));
		String srArea2Name = StringUtil.checkNull(cmmCnts.get("SRArea2Name"));
		
		String srCode = StringUtil.checkNull(cmmCnts.get("SRCode"));
		String subject = StringUtil.checkNull(cmmCnts.get("Subject"));
		String description = StringUtil.checkNull(cmmCnts.get("Description")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
		description = StringUtil.checkNull(description).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		description = StringUtil.checkNull(description).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
		
		String receiptUserNM = StringUtil.checkNull(cmmCnts.get("ReceiptName"));
		String receiptTeamNM = StringUtil.checkNull(cmmCnts.get("ReceiptTeamName"));
		String receiptUser = StringUtil.checkNull(cmmCnts.get("AssignmentRequired"));
		if(!"".equals(receiptUserNM)){
			receiptUser = receiptUserNM+"("+receiptTeamNM+")";
		}
		
		String languageID = StringUtil.checkNull(cmmCnts.get("languageID"));
		String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
		
		String returnHTML = emailHTMLForm;
		returnHTML = returnHTML.replaceAll("#subject#", subject);
		returnHTML = returnHTML.replaceAll("#description#", description);
		returnHTML = returnHTML.replaceAll("#srCode#", srCode);
		returnHTML = returnHTML.replaceAll("#requestUser#", requestUser);
		returnHTML = returnHTML.replaceAll("#ReqUserNM#", ReqUserNM);
		returnHTML = returnHTML.replaceAll("#ReqTeamNM#", ReqTeamNM);
		returnHTML = returnHTML.replaceAll("#srAreaName#", srArea1Name + "/" + srArea2Name);
		returnHTML = returnHTML.replaceAll("#receiptUser#", receiptUser);
		returnHTML = returnHTML.replaceAll("#ParentOrgPath#", ParentOrgPath);
		returnHTML = returnHTML.replaceAll("#CategoryName#", CategoryName);
		returnHTML = returnHTML.replaceAll("#OLM_SERVER_URL#", OLM_SERVER_URL);
		
		String linkParameter = StringUtil.checkNull(cmmCnts.get("linkParameter"));
		returnHTML = returnHTML.replaceAll("#linkParameter#", linkParameter);
			
		return returnHTML;
	}
	
	// 결재요청 ( approve.mail.template )
	public static String makeHTML_ESPMAIL006(HashMap cmmCnts, Map menu) {
		
		String ReqUserNM = StringUtil.checkNull(cmmCnts.get("ReqUserNM"));
		String ReqTeamNM = StringUtil.checkNull(cmmCnts.get("ReqTeamNM"));
		String requestUser = ReqUserNM+"("+ReqTeamNM+")";
		
		String CategoryName = StringUtil.checkNull(cmmCnts.get("CategoryName"));
		String ParentOrgPath = StringUtil.checkNull(cmmCnts.get("ParentOrgPath"));
		
		String srArea1Name = StringUtil.checkNull(cmmCnts.get("SRArea1Name"));
		String srArea2Name = StringUtil.checkNull(cmmCnts.get("SRArea2Name"));
		
		String srCode = StringUtil.checkNull(cmmCnts.get("SRCode"));
		String subject = StringUtil.checkNull(cmmCnts.get("Subject"));
		String description = StringUtil.checkNull(cmmCnts.get("Description")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
		description = StringUtil.checkNull(description).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		description = StringUtil.checkNull(description).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
		
		String receiptUserNM = StringUtil.checkNull(cmmCnts.get("ReceiptName"));
		String receiptTeamNM = StringUtil.checkNull(cmmCnts.get("ReceiptTeamName"));
		String receiptUser = StringUtil.checkNull(cmmCnts.get("AssignmentRequired"));
		if(!"".equals(receiptUserNM)){
			receiptUser = receiptUserNM+"("+receiptTeamNM+")";
		}
		
		String languageID = StringUtil.checkNull(cmmCnts.get("languageID"));
		String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
		
		String returnHTML = emailHTMLForm;
		returnHTML = returnHTML.replaceAll("#subject#", subject);
		returnHTML = returnHTML.replaceAll("#description#", description);
		returnHTML = returnHTML.replaceAll("#srCode#", srCode);
		returnHTML = returnHTML.replaceAll("#requestUser#", requestUser);
		returnHTML = returnHTML.replaceAll("#ReqUserNM#", ReqUserNM);
		returnHTML = returnHTML.replaceAll("#ReqTeamNM#", ReqTeamNM);
		returnHTML = returnHTML.replaceAll("#srAreaName#", srArea1Name + "/" + srArea2Name);
		returnHTML = returnHTML.replaceAll("#receiptUser#", receiptUser);
		returnHTML = returnHTML.replaceAll("#ParentOrgPath#", ParentOrgPath);
		returnHTML = returnHTML.replaceAll("#CategoryName#", CategoryName);
		returnHTML = returnHTML.replaceAll("#OLM_SERVER_URL#", OLM_SERVER_URL);
		
		String linkParameter = StringUtil.checkNull(cmmCnts.get("linkParameter"));
		returnHTML = returnHTML.replaceAll("#linkParameter#", linkParameter);
			
		return returnHTML;
	}
	
	// 결재반려 ( approve.mail.template )
	public static String makeHTML_ESPMAIL007(HashMap cmmCnts, Map menu) {
		
		String ReqUserNM = StringUtil.checkNull(cmmCnts.get("ReqUserNM"));
		String ReqTeamNM = StringUtil.checkNull(cmmCnts.get("ReqTeamNM"));
		String requestUser = ReqUserNM+"("+ReqTeamNM+")";
		
		String CategoryName = StringUtil.checkNull(cmmCnts.get("CategoryName"));
		String ParentOrgPath = StringUtil.checkNull(cmmCnts.get("ParentOrgPath"));
		
		String srArea1Name = StringUtil.checkNull(cmmCnts.get("SRArea1Name"));
		String srArea2Name = StringUtil.checkNull(cmmCnts.get("SRArea2Name"));
		
		String srCode = StringUtil.checkNull(cmmCnts.get("SRCode"));
		String subject = StringUtil.checkNull(cmmCnts.get("Subject"));
		String description = StringUtil.checkNull(cmmCnts.get("Description")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
		description = StringUtil.checkNull(description).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		description = StringUtil.checkNull(description).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
		
		String receiptUserNM = StringUtil.checkNull(cmmCnts.get("ReceiptName"));
		String receiptTeamNM = StringUtil.checkNull(cmmCnts.get("ReceiptTeamName"));
		String receiptUser = StringUtil.checkNull(cmmCnts.get("AssignmentRequired"));
		if(!"".equals(receiptUserNM)){
			receiptUser = receiptUserNM+"("+receiptTeamNM+")";
		}
		
		String languageID = StringUtil.checkNull(cmmCnts.get("languageID"));
		String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
		
		String returnHTML = emailHTMLForm;
		returnHTML = returnHTML.replaceAll("#subject#", subject);
		returnHTML = returnHTML.replaceAll("#description#", description);
		returnHTML = returnHTML.replaceAll("#srCode#", srCode);
		returnHTML = returnHTML.replaceAll("#requestUser#", requestUser);
		returnHTML = returnHTML.replaceAll("#ReqUserNM#", ReqUserNM);
		returnHTML = returnHTML.replaceAll("#ReqTeamNM#", ReqTeamNM);
		returnHTML = returnHTML.replaceAll("#srAreaName#", srArea1Name + "/" + srArea2Name);
		returnHTML = returnHTML.replaceAll("#receiptUser#", receiptUser);
		returnHTML = returnHTML.replaceAll("#ParentOrgPath#", ParentOrgPath);
		returnHTML = returnHTML.replaceAll("#CategoryName#", CategoryName);
		returnHTML = returnHTML.replaceAll("#OLM_SERVER_URL#", OLM_SERVER_URL);
		
		String linkParameter = StringUtil.checkNull(cmmCnts.get("linkParameter"));
		returnHTML = returnHTML.replaceAll("#linkParameter#", linkParameter);
			
		return returnHTML;
	}
	
	// 만족도조사 ( happy.mail.template )
	public static String makeHTML_ESPMAIL008(HashMap cmmCnts, Map menu) {
		
		String ReqUserNM = StringUtil.checkNull(cmmCnts.get("ReqUserNM"));
		String ReqTeamNM = StringUtil.checkNull(cmmCnts.get("ReqTeamNM"));
		String requestUser = ReqUserNM+"("+ReqTeamNM+")";
		
		String CategoryName = StringUtil.checkNull(cmmCnts.get("CategoryName"));
		String ParentOrgPath = StringUtil.checkNull(cmmCnts.get("ParentOrgPath"));
		
		String srArea1Name = StringUtil.checkNull(cmmCnts.get("SRArea1Name"));
		String srArea2Name = StringUtil.checkNull(cmmCnts.get("SRArea2Name"));
		
		String subject = StringUtil.checkNull(cmmCnts.get("Subject"));
		
		String regDate = StringUtil.checkNull(cmmCnts.get("RegDate"));
		String completionDT = StringUtil.checkNull(cmmCnts.get("CompletionDT"));
		String comment = StringUtil.checkNull(cmmCnts.get("Comment"));
		
		String srID = StringUtil.checkNull(cmmCnts.get("SRID"));
		String srType = StringUtil.checkNull(cmmCnts.get("SRType"));
		String esType = StringUtil.checkNull(cmmCnts.get("ESType"));
		
		// 만족도 조사 바로가기 버튼
		String happyButton = OLM_SERVER_URL + "/custom/daelim/indexEClick.do?srID=" + srID + "&srType=" + srType +"&esType=" + esType;
		
		String languageID = StringUtil.checkNull(cmmCnts.get("languageID"));
		String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
		
		String returnHTML = emailHTMLForm;
		returnHTML = returnHTML.replaceAll("#requestUser#", requestUser);
		returnHTML = returnHTML.replaceAll("#ReqUserNM#", ReqUserNM);
		returnHTML = returnHTML.replaceAll("#ReqTeamNM#", ReqTeamNM);
		returnHTML = returnHTML.replaceAll("#subject#", subject);
		returnHTML = returnHTML.replaceAll("#regDate#", regDate);
		returnHTML = returnHTML.replaceAll("#completionDT#", completionDT);
		returnHTML = returnHTML.replaceAll("#comment#", comment);
		returnHTML = returnHTML.replaceAll("#happyButton#", happyButton);
		returnHTML = returnHTML.replaceAll("#ParentOrgPath#", ParentOrgPath);
		returnHTML = returnHTML.replaceAll("#CategoryName#", CategoryName);
		returnHTML = returnHTML.replaceAll("#OLM_SERVER_URL#", OLM_SERVER_URL);
		
		String linkParameter = StringUtil.checkNull(cmmCnts.get("linkParameter"));
		returnHTML = returnHTML.replaceAll("#linkParameter#", linkParameter);
			
		return returnHTML;
	}
	
	// 고객테스트 ( assign.mail.template )
	public static String makeHTML_ESPMAIL009(HashMap cmmCnts, Map menu) {
		
		String ReqUserNM = StringUtil.checkNull(cmmCnts.get("ReqUserNM"));
		String ReqTeamNM = StringUtil.checkNull(cmmCnts.get("ReqTeamNM"));
		String requestUser = ReqUserNM+"("+ReqTeamNM+")";
		
		String CategoryName = StringUtil.checkNull(cmmCnts.get("CategoryName"));
		String ParentOrgPath = StringUtil.checkNull(cmmCnts.get("ParentOrgPath"));
		
		String srArea1Name = StringUtil.checkNull(cmmCnts.get("SRArea1Name"));
		String srArea2Name = StringUtil.checkNull(cmmCnts.get("SRArea2Name"));
		
		String srCode = StringUtil.checkNull(cmmCnts.get("SRCode"));
		String subject = StringUtil.checkNull(cmmCnts.get("Subject"));
		String description = StringUtil.checkNull(cmmCnts.get("Description")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
		description = StringUtil.checkNull(description).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		description = StringUtil.checkNull(description).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
		
		String status = StringUtil.checkNull(cmmCnts.get("SRStatusName"));
		String procRoleTPName = StringUtil.checkNull(cmmCnts.get("procRoleTPName"));
		
		String receiptUserNM = StringUtil.checkNull(cmmCnts.get("ReceiptName"));
		String receiptTeamNM = StringUtil.checkNull(cmmCnts.get("ReceiptTeamName"));
		String receiptUser = StringUtil.checkNull(cmmCnts.get("AssignmentRequired"));
		if(!"".equals(receiptUserNM)){
			receiptUser = receiptUserNM+"("+receiptTeamNM+")";
		}
		
		String languageID = StringUtil.checkNull(cmmCnts.get("languageID"));
		String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
		
		String returnHTML = emailHTMLForm;
		returnHTML = returnHTML.replaceAll("#subject#", subject);
		returnHTML = returnHTML.replaceAll("#description#", description);
		returnHTML = returnHTML.replaceAll("#srCode#", srCode);
		returnHTML = returnHTML.replaceAll("#requestUser#", requestUser);
		returnHTML = returnHTML.replaceAll("#ReqUserNM#", ReqUserNM);
		returnHTML = returnHTML.replaceAll("#srAreaName#", srArea1Name + "/" + srArea2Name);
		returnHTML = returnHTML.replaceAll("#status#", status);
		returnHTML = returnHTML.replaceAll("#procRoleTPName#", procRoleTPName);
		returnHTML = returnHTML.replaceAll("#receiptUser#", receiptUser);
		returnHTML = returnHTML.replaceAll("#ReqTeamNM#", ReqTeamNM);
		returnHTML = returnHTML.replaceAll("#ParentOrgPath#", ParentOrgPath);
		returnHTML = returnHTML.replaceAll("#CategoryName#", CategoryName);
		returnHTML = returnHTML.replaceAll("#OLM_SERVER_URL#", OLM_SERVER_URL);
		
		String linkParameter = StringUtil.checkNull(cmmCnts.get("linkParameter"));
		returnHTML = returnHTML.replaceAll("#linkParameter#", linkParameter);
			
		return returnHTML;
	}
	
	// 종료 ( assign.mail.template )
	public static String makeHTML_ESPMAIL010(HashMap cmmCnts, Map menu) {
		
		String ReqUserNM = StringUtil.checkNull(cmmCnts.get("ReqUserNM"));
		String ReqTeamNM = StringUtil.checkNull(cmmCnts.get("ReqTeamNM"));
		String requestUser = ReqUserNM+"("+ReqTeamNM+")";
		
		String CategoryName = StringUtil.checkNull(cmmCnts.get("CategoryName"));
		String ParentOrgPath = StringUtil.checkNull(cmmCnts.get("ParentOrgPath"));
		
		String srArea1Name = StringUtil.checkNull(cmmCnts.get("SRArea1Name"));
		String srArea2Name = StringUtil.checkNull(cmmCnts.get("SRArea2Name"));
		
		String srCode = StringUtil.checkNull(cmmCnts.get("SRCode"));
		String subject = StringUtil.checkNull(cmmCnts.get("Subject"));
		String description = StringUtil.checkNull(cmmCnts.get("Description")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
		description = StringUtil.checkNull(description).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		description = StringUtil.checkNull(description).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
		
		String status = StringUtil.checkNull(cmmCnts.get("SRStatusName"));
		String procRoleTPName = StringUtil.checkNull(cmmCnts.get("procRoleTPName"));
		
		String receiptUserNM = StringUtil.checkNull(cmmCnts.get("ReceiptName"));
		String receiptTeamNM = StringUtil.checkNull(cmmCnts.get("ReceiptTeamName"));
		String receiptUser = StringUtil.checkNull(cmmCnts.get("AssignmentRequired"));
		if(!"".equals(receiptUserNM)){
			receiptUser = receiptUserNM+"("+receiptTeamNM+")";
		}
		
		String languageID = StringUtil.checkNull(cmmCnts.get("languageID"));
		String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
		
		String returnHTML = emailHTMLForm;
		returnHTML = returnHTML.replaceAll("#subject#", subject);
		returnHTML = returnHTML.replaceAll("#description#", description);
		returnHTML = returnHTML.replaceAll("#srCode#", srCode);
		returnHTML = returnHTML.replaceAll("#requestUser#", requestUser);
		returnHTML = returnHTML.replaceAll("#ReqUserNM#", ReqUserNM);
		returnHTML = returnHTML.replaceAll("#srAreaName#", srArea1Name + "/" + srArea2Name);
		returnHTML = returnHTML.replaceAll("#status#", status);
		returnHTML = returnHTML.replaceAll("#procRoleTPName#", procRoleTPName);
		returnHTML = returnHTML.replaceAll("#receiptUser#", receiptUser);
		returnHTML = returnHTML.replaceAll("#ReqTeamNM#", ReqTeamNM);
		returnHTML = returnHTML.replaceAll("#ParentOrgPath#", ParentOrgPath);
		returnHTML = returnHTML.replaceAll("#CategoryName#", CategoryName);
		returnHTML = returnHTML.replaceAll("#OLM_SERVER_URL#", OLM_SERVER_URL);
		
		String linkParameter = StringUtil.checkNull(cmmCnts.get("linkParameter"));
		returnHTML = returnHTML.replaceAll("#linkParameter#", linkParameter);
			
		return returnHTML;
	}
	
	// 지연 ( assign.mail.template )
	public static String makeHTML_ESPMAIL011(HashMap cmmCnts, Map menu) {
		
		String ReqUserNM = StringUtil.checkNull(cmmCnts.get("ReqUserNM"));
		String ReqTeamNM = StringUtil.checkNull(cmmCnts.get("ReqTeamNM"));
		String requestUser = ReqUserNM+"("+ReqTeamNM+")";
		
		String CategoryName = StringUtil.checkNull(cmmCnts.get("CategoryName"));
		String ParentOrgPath = StringUtil.checkNull(cmmCnts.get("ParentOrgPath"));
		
		String srArea1Name = StringUtil.checkNull(cmmCnts.get("SRArea1Name"));
		String srArea2Name = StringUtil.checkNull(cmmCnts.get("SRArea2Name"));
		
		String srCode = StringUtil.checkNull(cmmCnts.get("SRCode"));
		String subject = StringUtil.checkNull(cmmCnts.get("Subject"));
		String description = StringUtil.checkNull(cmmCnts.get("Description")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
		description = StringUtil.checkNull(description).replace("src=\"/upload", "src=\""+OLM_SERVER_URL+"/upload");
		description = StringUtil.checkNull(description).replace("src=\"upload", "src=\""+OLM_SERVER_URL+"/upload");
		
		String status = StringUtil.checkNull(cmmCnts.get("SRStatusName"));
		String procRoleTPName = StringUtil.checkNull(cmmCnts.get("procRoleTPName"));
		
		String receiptUserNM = StringUtil.checkNull(cmmCnts.get("ReceiptName"));
		String receiptTeamNM = StringUtil.checkNull(cmmCnts.get("ReceiptTeamName"));
		String receiptUser = StringUtil.checkNull(cmmCnts.get("AssignmentRequired"));
		if(!"".equals(receiptUserNM)){
			receiptUser = receiptUserNM+"("+receiptTeamNM+")";
		}
		
		String dueDate = StringUtil.checkNull(cmmCnts.get("DueDate"));
		String languageID = StringUtil.checkNull(cmmCnts.get("languageID"));
		String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
		
		String returnHTML = emailHTMLForm;
		returnHTML = returnHTML.replaceAll("#subject#", subject);
		returnHTML = returnHTML.replaceAll("#description#", description);
		returnHTML = returnHTML.replaceAll("#srCode#", srCode);
		returnHTML = returnHTML.replaceAll("#requestUser#", requestUser);
		returnHTML = returnHTML.replaceAll("#ReqUserNM#", ReqUserNM);
		returnHTML = returnHTML.replaceAll("#srAreaName#", srArea1Name + "/" + srArea2Name);
		returnHTML = returnHTML.replaceAll("#status#", status);
		returnHTML = returnHTML.replaceAll("#procRoleTPName#", procRoleTPName);
		returnHTML = returnHTML.replaceAll("#receiptUser#", receiptUser);
		returnHTML = returnHTML.replaceAll("#receiptUser#", receiptUser);
		returnHTML = returnHTML.replaceAll("#dueDate#", dueDate);
		returnHTML = returnHTML.replaceAll("#ParentOrgPath#", ParentOrgPath);
		returnHTML = returnHTML.replaceAll("#ReqTeamNM#", ReqTeamNM);
		returnHTML = returnHTML.replaceAll("#OLM_SERVER_URL#", OLM_SERVER_URL);
			
		return returnHTML;
	}
	
	// 배치 
	public static String makeHTML_ESPMAIL012(HashMap cmmCnts, Map menu) {
		
		String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
		return emailHTMLForm;
	}
	
	public static String makeHTML_LOGINAUTH(HashMap cmmCnts, Map menu) {		
		String subject = StringUtil.checkNull(cmmCnts.get("Subject"));	
		String authNumber = StringUtil.checkNull(cmmCnts.get("authNumber"));
		String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
		
		String returnHTML = emailHTMLForm;
		returnHTML = returnHTML.replaceAll("#subject#", subject);
		returnHTML = returnHTML.replaceAll("#authNumber#", authNumber);
		returnHTML = returnHTML.replaceAll("#OLM_SERVER_URL#", OLM_SERVER_URL);
		return returnHTML;
	}

	public static String makeHTML_REQITMCLS(HashMap cmmCnts, Map menu) {
		String subject = StringUtil.checkNull(cmmCnts.get("Subject"));
		String content = StringUtil.checkNull(cmmCnts.get("Content")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
		String itemName = StringUtil.checkNull(cmmCnts.get("ItemName"));
		String itemID = StringUtil.checkNull(cmmCnts.get("ItemID"));
		String changeSetID = StringUtil.checkNull(cmmCnts.get("BrdChangeSetID"));
		String loginID = StringUtil.checkNull(cmmCnts.get("LoginID"));
		String boardMgtName = StringUtil.checkNull(cmmCnts.get("boardMgtName"));
		String SC_END_DT = StringUtil.checkNull(cmmCnts.get("SC_END_DT"));
		HashMap regUInfo = (HashMap) cmmCnts.get("regUInfo");
		
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
		String LN00233 = StringUtil.checkNull(menu.get("LN00233"));
		
		String returnHTML = emailHTMLForm;
		returnHTML = returnHTML.replaceAll("#LN00212#", LN00212);
		returnHTML = returnHTML.replaceAll("#LN00078#", LN00078);
		returnHTML = returnHTML.replaceAll("#LN00087#", LN00087);
		returnHTML = returnHTML.replaceAll("#LN00002#", LN00002);
		returnHTML = returnHTML.replaceAll("#LN00003#", LN00003);
		returnHTML = returnHTML.replaceAll("#LN00323#", LN00323);
		returnHTML = returnHTML.replaceAll("#LN00233#", LN00233);
		
		returnHTML = returnHTML.replaceAll("#UserNAME#", UserNAME);
		returnHTML = returnHTML.replaceAll("#loginID#", loginID);
		returnHTML = returnHTML.replaceAll("#TeamName#", TeamName);
		returnHTML = returnHTML.replaceAll("#Email#", Email);
		returnHTML = returnHTML.replaceAll("#today#", today);
		returnHTML = returnHTML.replaceAll("#itemName#", itemName);
		returnHTML = returnHTML.replaceAll("#subject#", subject);
		returnHTML = returnHTML.replaceAll("#content#", content);
		returnHTML = returnHTML.replaceAll("#boardMgtName#", boardMgtName);
		returnHTML = returnHTML.replaceAll("#itemID#", itemID);
		returnHTML = returnHTML.replaceAll("#changeSetID#", changeSetID);
		returnHTML = returnHTML.replaceAll("#SC_END_DT#", SC_END_DT);
		returnHTML = returnHTML.replaceAll("#OLM_SERVER_URL#", OLM_SERVER_URL);

		/***/
		
		System.out.println(returnHTML);
		return returnHTML;
	}
	
	
	public static String makeHTML_ITMMAIL001(HashMap cmmCnts, Map menu) {		
		String subject = StringUtil.checkNull(cmmCnts.get("Subject"));	 // 메일 제목  ex) 제목 : 13.01.01.02 test
		String identifier = StringUtil.checkNull(cmmCnts.get("Identifier"));//문서번호 
		String procName =StringUtil.checkNull(cmmCnts.get("ProcName"));//프로세스명
		String beforeTeamNM = StringUtil.checkNull(cmmCnts.get("BeforeTeamNM"));
		String beforeUserNM = StringUtil.checkNull(cmmCnts.get("BeforeUserNM"));
		String afterTeamNM = StringUtil.checkNull(cmmCnts.get("AfterTeamNM"));
		String afterUserNM = StringUtil.checkNull(cmmCnts.get("AfterUserNM"));
		String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));// 이메일 코드 
		String LN00002 = StringUtil.checkNull(menu.get("LN00002"));
		
		String returnHTML = emailHTMLForm;
		returnHTML = returnHTML.replaceAll("#LN00002#", LN00002);
		returnHTML = returnHTML.replaceAll("#Subject#", subject);
		returnHTML = returnHTML.replaceAll("#Identifier#", identifier);
		returnHTML = returnHTML.replaceAll("#ProcName#", procName);
		returnHTML = returnHTML.replaceAll("#BeforeTeamNM#", beforeTeamNM);
		returnHTML = returnHTML.replaceAll("#BeforeUserNM#", beforeUserNM);
		returnHTML = returnHTML.replaceAll("#AfterTeamNM#", afterTeamNM);
		returnHTML = returnHTML.replaceAll("#AfterUserNM#", afterUserNM);
		returnHTML = returnHTML.replaceAll("#OLM_SERVER_URL#", OLM_SERVER_URL);
		return returnHTML;
	}
}

