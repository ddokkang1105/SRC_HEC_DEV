package xbolt.project.cr.web;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.org.json.JSONArray;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.EmailUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.project.chgInf.web.CSActionController;

/**
 * 업무 처리
 * 
 * @Class Name : CrActionController.java
 * @Description : 업무화면을 제공한다.
 * @Modification Information
 * @수정일 수정자 수정내용
 * @--------- --------- -------------------------------
 * @2012. 09. 01. smartfactory 최초생성
 * 
 * @since 2012. 09. 01.
 * @version 1.0
 */

@Controller
@SuppressWarnings("unchecked")
public class CRActionController extends XboltController {

@Resource(name = "commonService")
private CommonService commonService;
	
@Resource(name = "crService")
private CommonService crService;

@Resource(name = "CSActionController")
private CSActionController CSActionController;
	
@RequestMapping(value = "/crList.do")
	public String crList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/project/cr/crList";
		try {
				Map setMap = new HashMap();
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),request.getParameter("languageID")); 
		     	String itemID = StringUtil.checkNull(cmmMap.get("s_itemID"),""); 
				String projectID = StringUtil.checkNull(request.getParameter("projectID"),""); 
				String crMode = StringUtil.checkNull(request.getParameter("crMode"),"");
				String screenType = StringUtil.checkNull(request.getParameter("screenType"));	
				String requestUserName = StringUtil.checkNull(request.getParameter("requestUserName"));	
				String dueDate = StringUtil.checkNull(request.getParameter("dueDate"));	
				String completionDT = StringUtil.checkNull(request.getParameter("completionDT"));	
				String subject = StringUtil.checkNull(request.getParameter("subject"));	
				String crStatus = StringUtil.checkNull(request.getParameter("crStatus"));	
				String crArea1 = StringUtil.checkNull(request.getParameter("crArea1"));	
				String crArea2 = StringUtil.checkNull(request.getParameter("crArea2"));	
				String receiptUserName = StringUtil.checkNull(request.getParameter("receiptUserName"));	
				String receiptTeam = StringUtil.checkNull(request.getParameter("receiptTeam"));	
				String refID = StringUtil.checkNull(request.getParameter("refID"));	
				String csrID = StringUtil.checkNull(request.getParameter("csrID"));	
				String sessionUserId = StringUtil.checkNull(request.getParameter("sessionUserId"));	
				String sessionTeamId = StringUtil.checkNull(request.getParameter("sessionTeamId"));	
				
				
				cmmMap.put("languageID", languageID);
				cmmMap.put("crMode", crMode);
				cmmMap.put("screenType", screenType);
				cmmMap.put("itemID", itemID);
				cmmMap.put("requestUserName", requestUserName);
				cmmMap.put("dueDate", dueDate);
				cmmMap.put("completionDT", completionDT);
				cmmMap.put("subject", subject);
				cmmMap.put("crStatus", crStatus);
				cmmMap.put("crArea1", crArea1);
				cmmMap.put("crArea2", crArea2);
				cmmMap.put("receiptUserName", receiptUserName);
				cmmMap.put("receiptTeam", receiptTeam);
				cmmMap.put("refID", refID);
				cmmMap.put("csrID", csrID);
				cmmMap.put("sessionUserId", sessionUserId);
				cmmMap.put("sessionTeamId", sessionTeamId);
				
		        List crGridList = commonService.selectList("cr_SQL.getCrMstList_gridList", cmmMap);
		        JSONArray gridData = new JSONArray(crGridList);
		        model.put("gridData",gridData);	
							
				if(crMode.equals("myCr")){
					model.put("requstUser", cmmMap.get("sessionUserNm"));
				}
				// 화면  = PG or PJT일 경우 
				model.put("screenType", StringUtil.checkNull(request.getParameter("screenType"), "crRqst"));				
				model.put("srType", StringUtil.checkNull(request.getParameter("srType"), "ITSP"));
				model.put("refID", projectID);		
				// 화면 = CSR일 경우 
				model.put("csrID", StringUtil.checkNull(request.getParameter("csrID")));				
				model.put("itemID", itemID);
				setMap.put("languageID", String.valueOf(cmmMap.get("sessionCurrLangType")));
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("crMode", crMode);
				
				model.put("crArea1", StringUtil.checkNull(cmmMap.get("crArea1")));
				model.put("crArea2", StringUtil.checkNull(cmmMap.get("crArea2")));
				model.put("requestUser", StringUtil.checkNull(cmmMap.get("requestUser")));
				model.put("crStatus", StringUtil.checkNull(cmmMap.get("crStatus")));
				model.put("DUE_DT", StringUtil.checkNull(cmmMap.get("DUE_DT")));
				model.put("completionDT", StringUtil.checkNull(cmmMap.get("completionDT")));
				model.put("receiptTeam", StringUtil.checkNull(cmmMap.get("receiptTeam")));
				model.put("receiptUser", StringUtil.checkNull(cmmMap.get("receiptUser")));
				model.put("subject", StringUtil.checkNull(cmmMap.get("subject")));
		
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/addNewCr.do")
	public String addNewCr(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/project/cr/addNewCr";
		try {
				List attachFileList = new ArrayList();
				Map setMap = new HashMap();
				Map getMap = new HashMap();
				Map getCSRMap = new HashMap();
				Map getItemMap = new HashMap();
				
				String crID = StringUtil.checkNull(request.getParameter("crID"));
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),request.getParameter("languageID")); 
				String isCrEdit = StringUtil.checkNull(request.getParameter("isCrEdit"));
				String csrId = StringUtil.checkNull(request.getParameter("CSRID")); 
				String projectID = StringUtil.checkNull(request.getParameter("ProjectID")); 
				String srID = StringUtil.checkNull(request.getParameter("srID"));
				String srType = StringUtil.checkNull(request.getParameter("srType"), "ITSP");
				String mainMenu = StringUtil.checkNull(request.getParameter("mainMenu"));
				
				if (!crID.isEmpty()) {
					// Cr 편집 화면 일때
					setMap.put("crID", crID);
					setMap.put("languageID", languageID);
					getMap = commonService.select("cr_SQL.getCrMstList_gridList", setMap);
				}else if(crID.isEmpty() && !srID.isEmpty()){	//신규 이면
					
					setMap.put("srID", srID);
					setMap.put("srType", srType);
					setMap.put("languageID", languageID);
					getMap = commonService.select("sr_SQL.getSRInfo", setMap);
					if(!csrId.isEmpty()){
					setMap.put("ProjectID", csrId);
						getCSRMap = commonService.select("project_SQL.getSetProjectListForCsr_gridList", setMap);
					}
				}
				
				getItemMap = commonService.select("esm_SQL.getESMSRTypeInfo", setMap);
				
				/* 시스템 날짜 */
				Calendar cal = Calendar.getInstance();
				cal.setTime(new Date(System.currentTimeMillis()));
				String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
				
				model.put("mainMenu", mainMenu);
				model.put("getItemMap", getItemMap);
				model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")) );
				model.put("crMode", StringUtil.checkNull(request.getParameter("crMode")) );
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("currPageI", StringUtil.checkNull(request.getParameter("currPageI"), "1"));
				model.put("thisYmd", thisYmd);
				model.put("ProjectID", projectID);
				model.put("isCrEdit", isCrEdit);
				model.put("srType", srType);
				model.put("screenType", StringUtil.checkNull(request.getParameter("screenType"), ""));
				model.put("CSRID", StringUtil.checkNull(request.getParameter("CSRID"), ""));
				model.put("getMap", getMap);
				model.put("getCSRMap", getCSRMap);
				
				//Call PROC_LOG START TIME
				setInitProcLog(request);
				
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/saveNewCr.do")
	public String saveNewCr(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap setData = new HashMap();
			HashMap insertData = new HashMap();
			HashMap updateData = new HashMap();
			HashMap setMap = new HashMap();
			String maxCrId = "";
			String curmaxCRCode ="";
			String maxCRCode = "";
			
			String crID = StringUtil.checkNull(commandMap.get("crID"));
			String status = StringUtil.checkNull(commandMap.get("status"));
			String csrId = StringUtil.checkNull(commandMap.get("csrID"));
			String srID = StringUtil.checkNull(commandMap.get("srID"),null);
			String projectID = StringUtil.checkNull(commandMap.get("ProjectID"));
			String crArea1 = StringUtil.checkNull(commandMap.get("crArea1"));
			String crArea2 = StringUtil.checkNull(commandMap.get("crArea2"));
			String priority = StringUtil.checkNull(commandMap.get("priority"));
			String receiptID = StringUtil.checkNull(commandMap.get("receiptID"));
			String receiptTeamID = StringUtil.checkNull(commandMap.get("receiptTeamID"));
			String crMode = StringUtil.checkNull(commandMap.get("crMode"));
			String itemIDs = StringUtil.checkNull(commandMap.get("itemIDs"));
			
			setMap.put("crArea2", crArea2);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			String ITSMType = StringUtil.checkNull(commonService.selectString("cr_SQL.getITSMType", setMap));	
			String ITSMIF = StringUtil.checkNull(commandMap.get("ITSMIF"));

			if ("WTR".equals(status)) {
				/* Cr 편집은 없음  취소만 있음*/
				updateData.put("crID", crID); // 상태:취소 (WRT)
				updateData.put("status", "WTR"); 
				updateData.put("lastUser", StringUtil.checkNull(commandMap.get("sessionUserId")) );
				/* 이미 IF 되었으면   다시 보내야 하므로 ITSMIF == 0으로 변경  --> ITSM에서 취소해서 OLM CR 업데이트하는 프로세스로 변경
				if ("-1".equals(ITSMIF) || "0".equals(ITSMIF)) {
				//	updateData.put("ITSMIF", "4");
				// 아직 IF되기 전  CR 취소	
				} else {
				//	updateData.put("ITSMIF", "0");	
				}*/
				commonService.insert("cr_SQL.updateCR", updateData);	
			
			} else {
				/* Cr 신규 등록 */
				/* 시스템 날짜 */
				Calendar cal = Calendar.getInstance();
				cal.setTime(new Date(System.currentTimeMillis()));
				String thisYmd = new SimpleDateFormat("yyMMdd").format(cal.getTime());
				setData.put("thisYmd", thisYmd);
				maxCrId = StringUtil.checkNull(commonService.selectString("cr_SQL.getMaxCrID", setData)).trim();
				curmaxCRCode = StringUtil.checkNull(commonService.selectString("cr_SQL.getMaxCRCode", setData)).trim();				
				if(curmaxCRCode.equals("")){ // 당일 CR이 없으면
					maxCRCode = "CR"  + thisYmd + "0001";
				} else {
					curmaxCRCode = curmaxCRCode.substring(curmaxCRCode.length() - 4, curmaxCRCode.length());
					int curCRCode = Integer.parseInt(curmaxCRCode) + 1;
					maxCRCode =  "CR" +  thisYmd + String.format("%04d", curCRCode);			
				}
				
				insertData.put("crID", maxCrId);
				insertData.put("crCode", maxCRCode);
				insertData.put("srID", srID);
				insertData.put("csrID", csrId);
				insertData.put("projectID", projectID);
				insertData.put("Subject", StringUtil.checkNull(request.getParameter("Subject")));				
				insertData.put("Description", StringUtil.checkNull(commandMap.get("Description")));
				insertData.put("crArea1", crArea1); 
				insertData.put("crArea2", crArea2); 
				insertData.put("priority", priority); 
				insertData.put("status", "RFC"); // 상태:등록 (01)
				insertData.put("receiptID", receiptID);
				insertData.put("receiptTeamID", receiptTeamID);
				insertData.put("ITSMType", ITSMType);
				insertData.put("RegUserID", commandMap.get("sessionUserId"));
				insertData.put("RegTeamID", commandMap.get("sessionTeamId"));
			
				// 접수자/접수팀은  CRArea2 담당자를 자동 지정함
				insertData.put("ReqDueDate", StringUtil.checkNull(request.getParameter("ReqDueDate")));
				insertData.put("LastUser", commandMap.get("sessionUserId"));
				
				if(crMode.equals("SR")){
					insertData.put("procOption", "ADV"); //선조치				  
				} else {
					insertData.put("procOption", "POST"); //결재 후 조치					
				}
				commonService.insert("cr_SQL.insertCR", insertData);
			 }	
			 
			 //==================SR에서 CR 생성 시 상태값을 변경================
		 	if(crMode.equals("SR")){
			  	setMap.put("status", "CNG");
			   	setMap.put("srID", srID);
			    commonService.update("sr_SQL.updateSRStatus", setMap);	
			}		
		 	
		 	if(itemIDs != null && !"".equals(itemIDs)) {
	 		
				commandMap.put("itemIds",itemIDs);
				commandMap.put("projectID",projectID);
	 			CSActionController.checkOutItem(request,commandMap,model);
		 		
		 	}
		 	
			//==================CSR에서 CR 생성 시만 이메일 전송함====================
			//send Email
			if(!crMode.equals("SR")){				
				List receiverList = new ArrayList();
				Map receiverMap = new HashMap();
				receiverMap.put("receiptUserID", receiptID);
				receiverList.add(0,receiverMap);
				insertData.put("receiverList", receiverList);			
				insertData.put("subject", StringUtil.checkNull(request.getParameter("Subject")));
				Map setMailMapRst = (Map)setEmailLog(request, commonService, insertData, "CRRCV"); //CR 접수/취소
				System.out.println("setMailMapRst : "+setMailMapRst );
				
				if(StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")){
					HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
					if ("WTR".equals(status)) {
						setMap.put("crID", crID);
					}else{
						setMap.put("crID", maxCrId);
					}
					setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
					HashMap cntsMap = (HashMap)commonService.select("cr_SQL.getCrMstList_gridList", setMap);
					
					Map resultMailMap = EmailUtil.sendMail(mailMap,cntsMap,getLabel(request, commonService));
					System.out.println("SEND EMAIL TYPE:"+resultMailMap+", Msg:"+StringUtil.checkNull(setMailMapRst.get("type")));
				}else{
					System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMapRst.get("msg")));
				}
			//==============================================	
			}
			
			//====================Proposal 메일발송 ==========================
			setData = new HashMap();
			setData.put("srID", srID);  
		
			Map SRMstInfo = commonService.select("sr_SQL.getSRMST", setData);
			String srCatID = "";
			String srType = "";
			String proposal = "";
			String srRequestTeamID = "";
			String srSubject = "";
			String srRequestUserID = "";
			String srRegTeamID = "";
			if(!SRMstInfo.isEmpty()){
				srCatID = StringUtil.checkNull(SRMstInfo.get("SubCategory"));
				srType = StringUtil.checkNull(SRMstInfo.get("SRType"));
				proposal = StringUtil.checkNull(SRMstInfo.get("Proposal"));
				srRequestTeamID = StringUtil.checkNull(SRMstInfo.get("RequestTeamID"));
				srSubject = StringUtil.checkNull(SRMstInfo.get("Subject"));
				srRequestUserID = StringUtil.checkNull(SRMstInfo.get("RequestUserID"));
				srRegTeamID = StringUtil.checkNull(SRMstInfo.get("RegTeamID"));
			}
			
			setData.put("srCatID", srCatID);
			setData.put("srType", srType);
			Map SRCATInfo = commonService.select("sr_SQL.getSRAreaFromSrCat", setData);
			String proposalOption = "";
			if(!SRCATInfo.isEmpty()){
				proposalOption = StringUtil.checkNull(SRCATInfo.get("ProposalOption"),"").trim(); 
			}
						
			// proposalOtion == 1 && proposal==00 인경우만  진행  && SRRegTeamID != 156,159(ITO,열린)
			if(proposalOption.equals("1") && proposal.equals("00") && (!srRegTeamID.equals("156") && !srRegTeamID.equals("159"))){
				// Proposal update, Proposal Mail 발송
				updateData = new HashMap();	
				updateData.put("srID", srID);
				updateData.put("lastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));	
				updateData.put("proposal", "01");			
				updateData.put("receiptUserID", StringUtil.checkNull(SRMstInfo.get("ReceiptUserID")));
				commonService.update("sr_SQL.updateSR", updateData);
				//send Email
				updateData.put("EMAILCODE", "PROPS");
				updateData.put("subject", srSubject);
				
				List receiverList = new ArrayList();
				Map receiverMap = new HashMap();
				receiverMap.put("receiptUserID", srRequestUserID);
				receiverList.add(0,receiverMap);
				updateData.put("receiverList", receiverList);
				
				Map setMailMapRst = (Map)setEmailLog(request, commonService, updateData, "PROPS");
				System.out.println("CR 생성  PROPOSAL setMailMapRst( [PRIME - 제안연계 알림] ) : "+setMailMapRst );
				
				setMap = new HashMap();
				if(StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")){
					HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
					setMap.put("srID", srID);
					setMap.put("srType", srType);
					setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
					HashMap cntsMap = (HashMap)commonService.select("sr_SQL.getSRInfo", setMap);
					
					cntsMap.put("srID", srID);	
					cntsMap.put("teamID", srRequestTeamID);					
					cntsMap.put("userID", srRequestUserID);
					cntsMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
					String requestLoginID = StringUtil.checkNull(commonService.selectString("sr_SQL.getLoginID", cntsMap));
					cntsMap.put("loginID", requestLoginID);
					
					Map resultMailMap = EmailUtil.sendMail(mailMap, cntsMap, getLabel(request, commonService));
					System.out.println("SEND EMAIL TYPE:"+resultMailMap+ "Msg :" + StringUtil.checkNull(setMailMapRst.get("type")));
				}else{
					System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMapRst.get("msg")));
				}
			}
			
			//============================================================			
			//Save PROC_LOG
			Map setProcMapRst = (Map)setProcLog(request, commonService, insertData);
			if(setProcMapRst.get("type").equals("FAILE")){
				System.out.println("SAVE PROC_LOG FAILE Msg : "+StringUtil.checkNull(setProcMapRst.get("msg")));
			}
			
			model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			
			if(status.equals("WTR")){				
				target.put(AJAX_SCRIPT, "goBack();");
			}else{
				if(crMode.equals("SR")){
					target.put(AJAX_SCRIPT, "parent.fnGoBackSR();parent.$('#isSubmit').remove();");
				}else{
					target.put(AJAX_SCRIPT, "parent.fnGoBack();parent.$('#isSubmit').remove();");
				}
			}
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	private void insertCrFiles(HashMap commandMap, String crID) throws Exception {
		Map fileMap  = new HashMap();
		List fileList = new ArrayList();

		int seqCnt = Integer.parseInt(commonService.selectString("issue_SQL.issueFile_nextVal", commandMap));
		//Read Server File
		String orginPath = GlobalVal.FILE_UPLOAD_BASE_DIR + StringUtil.checkNull(commandMap.get("sessionUserId"))+"//";
		String filePath = GlobalVal.FILE_UPLOAD_ITEM_DIR;
		String targetPath = filePath;
		List tmpFileList = FileUtil.copyFiles(orginPath, targetPath);
		if(tmpFileList.size() != 0){
			for(int i=0; i<tmpFileList.size();i++){
				fileMap = new HashMap(); 
				HashMap resultMap = (HashMap)tmpFileList.get(i);
				fileMap.put("Seq", seqCnt);
				fileMap.put("IssueID",crID);
				fileMap.put("FileName", resultMap.get(FileUtil.UPLOAD_FILE_NM));
				fileMap.put("FileRealName", resultMap.get(FileUtil.ORIGIN_FILE_NM));
				fileMap.put("FileSize", resultMap.get(FileUtil.FILE_SIZE));
				fileMap.put("FilePath", filePath);
				fileMap.put("FileMgt", "CR");
				fileMap.put("userId", commandMap.get("sessionUserId"));
				fileMap.put("RegMemberID", commandMap.get("sessionUserId"));
				fileMap.put("LastUser", commandMap.get("sessionUserId"));
				fileMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
				
				fileMap.put("KBN", "insert");
				fileMap.put("SQLNAME", "issue_SQL.issueFile_insert");					
				fileList.add(fileMap);
				seqCnt++;
			}
		}
		
		if(fileList.size() != 0){
			commonService.save(fileList, fileMap);
		}
	}
	
	@RequestMapping("/crInfoDetail.do")
	public String crInfoDetail(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "project/cr/crInfoDetail";
		Map setMap = new HashMap();
		Map getMap = new HashMap();
		List attachFileList = new ArrayList();
		
		try {
			String crID = StringUtil.checkNull(request.getParameter("crID"));
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			
			setMap.put("crID", crID);
			getMap = commonService.select("cr_SQL.getCrMstList_gridList", setMap);			
						
			model.put("getMap", getMap); 
			model.put("crFiles", attachFileList);
			model.put("crFilePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("crMode", StringUtil.checkNull(request.getParameter("crMode")));
			
			model.put("ParentID", StringUtil.checkNull(request.getParameter("ParentID")));
			model.put("Creator", StringUtil.checkNull(request.getParameter("Creator")));
			model.put("ProjectID", StringUtil.checkNull(request.getParameter("ProjectID")));
			model.put("isNew", StringUtil.checkNull(request.getParameter("isNew")));
			model.put("mainMenu", StringUtil.checkNull(request.getParameter("mainMenu"), "1"));
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("refID", StringUtil.checkNull(request.getParameter("refID")));
			model.put("csrID", StringUtil.checkNull(request.getParameter("csrID")));
			model.put("isPopup", StringUtil.checkNull(commandMap.get("isPopup")));
			model.put("srType", StringUtil.checkNull(commandMap.get("srType")));
			
			model.put("crArea1", StringUtil.checkNull(commandMap.get("crArea1")));
			model.put("crArea2", StringUtil.checkNull(commandMap.get("crArea2")));
			model.put("requestUser", StringUtil.checkNull(commandMap.get("requestUser")));
			model.put("crStatus", StringUtil.checkNull(commandMap.get("crStatus")));
			model.put("DUE_DT", StringUtil.checkNull(commandMap.get("DUE_DT")));
			model.put("completionDT", StringUtil.checkNull(commandMap.get("completionDT")));
			model.put("receiptTeam", StringUtil.checkNull(commandMap.get("receiptTeam")));
			model.put("receiptUser", StringUtil.checkNull(commandMap.get("receiptUser")));
			model.put("subject", StringUtil.checkNull(commandMap.get("subject")));
			
			// Tree >> ITEM >> [개요] >> [변경 이력]
			model.put("seletedTreeId", StringUtil.checkNull(request.getParameter("seletedTreeId")));
			model.put("isItemInfo", StringUtil.checkNull(request.getParameter("isItemInfo")));
			model.put("currPageI", StringUtil.checkNull(request.getParameter("currPageI"), "1"));
			
			model.put("screenType", StringUtil.checkNull(request.getParameter("screenType"), ""));

		} catch (Exception e) {
			System.out.println(e);
			throw new Exception("EM00001");
		}
		return nextUrl(url);
	}
	
	@RequestMapping("/getReceipt.do")
	public String getReceipt(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		Map getReqUser = new HashMap();
		HashMap target = new HashMap();
		try {
			String crArea2 = StringUtil.checkNull(request.getParameter("crArea2"));			
		//	setMap.put("crArea2", crArea2);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			setMap.put("srArea", crArea2 );
			setMap.put("RoleType","R");		
			setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")) );
			Map CRreceiptInfoMap = commonService.select("sr_SQL.getSRReceiptUser", setMap);			
						
		//	getReqUser = commonService.select("cr_SQL.getReceipt", setMap);
			String receiptID = StringUtil.checkNull(CRreceiptInfoMap.get("UserID"));
			String receiptName = StringUtil.checkNull(CRreceiptInfoMap.get("Name"));
			String receiptTeamID = StringUtil.checkNull(CRreceiptInfoMap.get("TeamID"));
			
			String ITSMType = StringUtil.checkNull(commonService.selectString("cr_SQL.getITSMType", setMap));
						
			//target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "fnSetReceipt('"+receiptID+"','"+receiptName+"','"+receiptTeamID+"','"+ITSMType+"');");

		} catch (Exception e) {
			System.out.println(e);
			throw new Exception("EM00001");
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping("/editCrInfo.do")
	public String editCrInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "project/cr/editCrInfo";
		Map setMap = new HashMap();
		Map getMap = new HashMap();
		//Map getItemMap = new HashMap();
		List attachFileList = new ArrayList();
		
		try {
			String crID = StringUtil.checkNull(request.getParameter("crID"));
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			
			setMap.put("crID", crID);
			getMap = commonService.select("cr_SQL.getCrMstList_gridList", setMap);		
			
			// setMap.put("srID", getMap.get("SRID"));getItemMap = commonService.select("sr_SQL.getSRItemTypeInfo", setMap);	
						
			//model.put("getItemMap", getItemMap); 
			model.put("getMap", getMap); 
			model.put("crFiles", attachFileList);
			model.put("crFilePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("crMode", StringUtil.checkNull(request.getParameter("crMode")));
			model.put("isCrEdit", StringUtil.checkNull(request.getParameter("isCrEdit")));
			
			model.put("ParentID", StringUtil.checkNull(request.getParameter("ParentID")));
			model.put("Creator", StringUtil.checkNull(request.getParameter("Creator")));
			model.put("ProjectID", StringUtil.checkNull(request.getParameter("ProjectID")));
			model.put("isNew", StringUtil.checkNull(request.getParameter("isNew")));
			model.put("mainMenu", StringUtil.checkNull(request.getParameter("mainMenu"), "1"));
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("refID", StringUtil.checkNull(request.getParameter("refID")));
			model.put("csrID", StringUtil.checkNull(request.getParameter("csrID")));
			model.put("isPopup", StringUtil.checkNull(commandMap.get("isPopup")));
			model.put("srType", StringUtil.checkNull(commandMap.get("srType")));
			
			model.put("crArea1", StringUtil.checkNull(commandMap.get("crArea1")));
			model.put("crArea2", StringUtil.checkNull(commandMap.get("crArea2")));
			model.put("requestUser", StringUtil.checkNull(commandMap.get("requestUser")));
			model.put("crStatus", StringUtil.checkNull(commandMap.get("crStatus")));
			model.put("DUE_DT", StringUtil.checkNull(commandMap.get("DUE_DT")));
			model.put("completionDT", StringUtil.checkNull(commandMap.get("completionDT")));
			model.put("receiptTeam", StringUtil.checkNull(commandMap.get("receiptTeam")));
			model.put("receiptUser", StringUtil.checkNull(commandMap.get("receiptUser")));
			model.put("subject", StringUtil.checkNull(commandMap.get("subject")));
			
			// Tree >> ITEM >> [개요] >> [변경 이력]
			model.put("seletedTreeId", StringUtil.checkNull(request.getParameter("seletedTreeId")));
			model.put("isItemInfo", StringUtil.checkNull(request.getParameter("isItemInfo")));
			model.put("currPageI", StringUtil.checkNull(request.getParameter("currPageI"), "1"));
			
			model.put("screenType", StringUtil.checkNull(request.getParameter("screenType"), ""));

		} catch (Exception e) {
			System.out.println(e);
			throw new Exception("EM00001");
		}
		return nextUrl(url);
	}
	
	
	@RequestMapping(value = "/saveCrInfo.do")
	public String saveCrInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap setData = new HashMap();
			HashMap updateData = new HashMap();
			HashMap setMap = new HashMap();
			String maxCrId = "";
			String curmaxCRCode ="";
			String maxCRCode = "";
			
			String crID = StringUtil.checkNull(commandMap.get("crID"));
			String status = StringUtil.checkNull(commandMap.get("status"));
			String csrId = StringUtil.checkNull(commandMap.get("csrID"));
			String srID = StringUtil.checkNull(commandMap.get("srID"),null);
			String projectID = StringUtil.checkNull(commandMap.get("ProjectID"));
			String crArea1 = StringUtil.checkNull(commandMap.get("crArea1"));
			String crArea2 = StringUtil.checkNull(commandMap.get("crArea2"));
			String priority = StringUtil.checkNull(commandMap.get("priority"));
			String receiptID = StringUtil.checkNull(commandMap.get("receiptID"));
			String receiptTeamID = StringUtil.checkNull(commandMap.get("receiptTeamID"));
			String crMode = StringUtil.checkNull(commandMap.get("crMode"));
			String itemIDs = StringUtil.checkNull(commandMap.get("itemIDs"));
			
			setMap.put("crArea2", crArea2);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			String ITSMType = StringUtil.checkNull(commonService.selectString("cr_SQL.getITSMType", setMap));	
			String ITSMIF = StringUtil.checkNull(commandMap.get("ITSMIF"));

			if ("WTR".equals(status)) {
				/* Cr 편집은 없음  취소만 있음*/
				updateData.put("crID", crID); // 상태:취소 (WRT)
				updateData.put("status", "WTR"); 
				updateData.put("lastUser", StringUtil.checkNull(commandMap.get("sessionUserId")) );
				/* 이미 IF 되었으면   다시 보내야 하므로 ITSMIF == 0으로 변경  --> ITSM에서 취소해서 OLM CR 업데이트하는 프로세스로 변경
				if ("-1".equals(ITSMIF) || "0".equals(ITSMIF)) {
				//	updateData.put("ITSMIF", "4");
				// 아직 IF되기 전  CR 취소	
				} else {
				//	updateData.put("ITSMIF", "0");	
				}*/
				commonService.insert("cr_SQL.updateCR", updateData);	
			
			} else {
				/* Cr Info Update */
				
				updateData.put("crID", crID);
				updateData.put("Subject", StringUtil.checkNull(request.getParameter("Subject")));				
				updateData.put("Description", StringUtil.checkNull(commandMap.get("Description")));
	
				updateData.put("priority", priority); 
				updateData.put("receiptID", receiptID);
				updateData.put("receiptTeamID", receiptTeamID);
				updateData.put("ITSMType", ITSMType);
			
				commonService.insert("cr_SQL.updateCR", updateData);
			}	
			
			//============================================================			
			//Save PROC_LOG
			Map setProcMapRst = (Map)setProcLog(request, commonService, updateData);
			if(setProcMapRst.get("type").equals("FAILE")){
				System.out.println("SAVE PROC_LOG FAILE Msg : "+StringUtil.checkNull(setProcMapRst.get("msg")));
			}
			
			model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			
			if(status.equals("WTR")){				
				target.put(AJAX_SCRIPT, "goBack();");
			}else{
				if(crMode.equals("SR")){
					target.put(AJAX_SCRIPT, "parent.fnGoBackSR();parent.$('#isSubmit').remove();");
				}else{
					target.put(AJAX_SCRIPT, "parent.goBack();parent.$('#isSubmit').remove();");
				}
			}
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	/* // 20211108 주석처리  
	 * @RequestMapping(value = "/completionCR.do") public String
	 * completionCR(HttpServletRequest request, HashMap commandMap, ModelMap model)
	 * throws Exception { HashMap target = new HashMap(); try { HashMap setData =
	 * new HashMap(); HashMap updateData = new HashMap(); HashMap setMap = new
	 * HashMap();
	 * 
	 * String crID = StringUtil.checkNull(commandMap.get("crID")); String status =
	 * StringUtil.checkNull(commandMap.get("status")); String csrId =
	 * StringUtil.checkNull(commandMap.get("csrID")); String srID =
	 * StringUtil.checkNull(commandMap.get("srID"),null); String projectID =
	 * StringUtil.checkNull(commandMap.get("ProjectID")); String crArea1 =
	 * StringUtil.checkNull(commandMap.get("crArea1")); String crArea2 =
	 * StringUtil.checkNull(commandMap.get("crArea2")); String priority =
	 * StringUtil.checkNull(commandMap.get("priority")); String receiptID =
	 * StringUtil.checkNull(commandMap.get("receiptID")); String receiptTeamID =
	 * StringUtil.checkNull(commandMap.get("receiptTeamID")); String crMode =
	 * StringUtil.checkNull(commandMap.get("crMode")); String itemIDs =
	 * StringUtil.checkNull(commandMap.get("itemIDs"));
	 * 
	 * setMap.put("crArea2", crArea2); setMap.put("languageID",
	 * commandMap.get("sessionCurrLangType")); String ITSMType =
	 * StringUtil.checkNull(commonService.selectString("cr_SQL.getITSMType",
	 * setMap)); String ITSMIF = StringUtil.checkNull(commandMap.get("ITSMIF"));
	 * 
	 * updateData.put("crID", crID); updateData.put("Subject",
	 * StringUtil.checkNull(request.getParameter("Subject")));
	 * updateData.put("Description",
	 * StringUtil.checkNull(commandMap.get("Description")));
	 * 
	 * updateData.put("priority", priority); updateData.put("receiptID", receiptID);
	 * updateData.put("receiptTeamID", receiptTeamID); updateData.put("ITSMType",
	 * ITSMType); updateData.put("status", "CLS"); updateData.put("lastUser",
	 * StringUtil.checkNull(commandMap.get("sessionUserId")));
	 * 
	 * commonService.insert("cr_SQL.updateCR", updateData);
	 * 
	 * updateData = new HashMap(); updateData.put("srID", srID);
	 * updateData.put("status", "SPE007"); updateData.put("lastUser",
	 * StringUtil.checkNull(commandMap.get("sessionUserId")));
	 * commonService.insert("sr_SQL.updateSR", updateData);
	 * 
	 * //============================================================ //Save
	 * PROC_LOG Map setProcMapRst = (Map)setProcLog(request, commonService,
	 * updateData); if(setProcMapRst.get("type").equals("FAILE")){
	 * System.out.println("SAVE PROC_LOG FAILE Msg : "+StringUtil.checkNull(
	 * setProcMapRst.get("msg"))); }
	 * 
	 * model.put("screenType",
	 * StringUtil.checkNull(request.getParameter("screenType")));
	 * target.put(AJAX_ALERT,
	 * MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") +
	 * ".WM00067")); // 저장 성공 target.put(AJAX_SCRIPT,
	 * "parent.goBack();parent.$('#isSubmit').remove();");
	 * 
	 * } catch (Exception e) { System.out.println(e); target.put(AJAX_SCRIPT,
	 * "parent.$('#isSubmit').remove()"); target.put(AJAX_ALERT,
	 * MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") +
	 * ".WM00068")); // 오류 발생 }
	 * 
	 * model.addAttribute(AJAX_RESULTMAP, target); return nextUrl(AJAXPAGE); }
	 */
	
	@RequestMapping(value = "/completionCR.do")
	public String completionCR(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap updateData = new HashMap();			
			String crID = StringUtil.checkNull(commandMap.get("crID"));
			
			updateData.put("crID", crID);
			updateData.put("status", "CLS");
			updateData.put("lastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));			
			commonService.insert("cr_SQL.updateCR", updateData);
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 
			target.put(AJAX_SCRIPT, "fnCallback();parent.$('#isSubmit').remove();");
		
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	
}
	