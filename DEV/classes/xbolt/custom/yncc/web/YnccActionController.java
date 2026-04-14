package xbolt.custom.yncc.web;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.text.StringEscapeUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import xbolt.app.esp.main.util.ESPUtil;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.EmailUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.custom.youngone.val.YoungOneGlobalVal;
import xbolt.project.chgInf.web.CSActionController;
import xbolt.wf.web.WfActionController;
import xbolt.api.enumType.ErrorCode;
import xbolt.api.enumType.ResponseCode;
import xbolt.api.response.ApiResponse;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import SafeIdentity.SSO;

@Controller
@SuppressWarnings("unchecked")
public class YnccActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "CSActionController")
	private CSActionController CSActionController;
	
	@RequestMapping(value = "/zYncc_wfDocMgt.do")
	public String zYncc_wfDocMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		 Map<String, Object> result = new HashMap<>();
		 Map<String, Object> target = new HashMap<>();
		 String url = "/custom/yncc/wf/approvalDetail";
		 System.out.println(" call zYncc_wfDocMgt.do");
		 try {
	    		String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"),""); 
	    		String actionType = StringUtil.checkNull(request.getParameter("actionType"),"");
	    		
	    		Map<String, Object> setData = new HashMap<>();
	    		System.out.println("1.cmmMap :"+cmmMap);
	    		
	    		if("view".equals(actionType)) { // view wf 
	    			String wfInstacceID = StringUtil.checkNull(request.getParameter("wfInstanceID"),"");
	    			String path = commonService.selectString("wf_SQL.getWfPath", cmmMap);
	    			
	    			model.put("docUrl", path);
	    			model.put("resultCode", "S");
	    			
	    		} else { // create new wf
	    			
		    		// 1. 결재 중복 체크 
	    			//setData.put("documentNo", itemID);
		    		setData.put("documentID", changeSetID);
		    		setData.put("status", "0");
	    			// Select WFInstanceID From XBOLTADM.TB_WF_INST Where DocumentID = 2009 And DocumentNo = 'ACM2411133' And Status = 0
	    			//wfInstacceID = StringUtil.checkNull(commonService.selectString("wf_SQL.getWfInstanceID", setData));
	    			/*// 주석해제해야함 중요!
	    			if(!wfInstacceID.equals("")) { // 이미 상신 데이터가 있으면 리턴
	    				
	    				target.put(AJAX_ALERT, "이미 결재가 진행중 입니다.");
	    				model.addAttribute(AJAX_RESULTMAP, target);
		    			return nextUrl(AJAXPAGE);
	    			}
	    			*/
	    			// 2. Tb_WF_INST DB 저장
		    		result = zYncc_createWfDoc_CS(request,result, model, cmmMap);  
		    		
		    		if(StringUtil.checkNull(result.get("error")).equals("Y")) { 
		    			target.put(AJAX_ALERT, "전자결재 생성 요청중 오류가 발생하였습니다."); 
						target.put(AJAX_SCRIPT, "fnCallBackSR();parent.$('#isSubmit').remove();");
		    			model.addAttribute(AJAX_RESULTMAP, target);
		    			return nextUrl(AJAXPAGE);
		    		}
	
		    		// 3. 그룹웨어에 전자결재 생성 및 전송
		    		String gwUrl = GlobalVal.GW_LINK_URL + "/Website/Base/Controls/IntegratedLegacyPal.asmx"; // https://gw.ynccdev.co.kr/Website/Base/Controls/IntegratedLegacyPal.asmx
		    		result.put("languageID", cmmMap.get("sessionCurrLangType"));
		    			    		
		    		Map<String, Object> wfData = zYncc_setWfData(request, result, cmmMap);
		    		wfData.put("gwUrl",gwUrl);
		    		
		    		Map<String, Object> gwResponse = sendToGroupware(wfData);
		    		
		    		System.out.println("sendResult ===> "+gwResponse);
		    		boolean success = Boolean.parseBoolean(StringUtil.checkNull(gwResponse.get("success")));
		    		
		    		String docUrl = StringUtil.checkNull(gwResponse.get("docUrl"));
	    			String docKey = StringUtil.checkNull(gwResponse.get("docKey"));
	    			String xmsgs = StringUtil.checkNull(gwResponse.get("xmsgs"));
	    			String xstat = StringUtil.checkNull(gwResponse.get("xstat"));
	    			
		    		if(success) {
		    			// update docUrl TB_WF_INST.returnedValue 
		    			
		    			System.out.println("sendToGroupware  성공 docUrl :::"+docUrl);
		    			result.put("Path", docUrl);
		    			commonService.update("wf_SQL.updateWfInst", result);
		    			
		    			model.put("xmsgs", xmsgs);
		    			model.put("docUrl", docUrl);
		    			model.put("docKey", docKey);	
		    			model.put("resultCode", "S");
	    	        } else {
	    	        	// roll back : TB_WF_INST, TB_WF_INST_TXT, TB_WF_STEP_INST, update activity WfinstanceID = null 
	    	        	String wfInstanceID = StringUtil.checkNull(wfData.get("wfInstanceID"));
	    	        	cmmMap.put("itemID", StringUtil.checkNull(result.get("itemID")));
	    	        	
	    	        	rollbackWfInstance(wfInstanceID, cmmMap);
		        	
	    	        	model.put("wfInstanceID", wfInstanceID);
	    	        	model.put("xmsgs", xmsgs);		
	    	        	model.put("resultCode", "F");
	    	        	
	    	        	target.put(AJAX_ALERT, "전자결재 생성 요청중 오류가 발생하였습니다."); 
						target.put(AJAX_SCRIPT, "fnCallBack();parent.$('#isSubmit').remove();");
	    	        	
	    	        	model.addAttribute(AJAX_RESULTMAP, target);
		    			return nextUrl(AJAXPAGE);
	    	       }
	    		}
	    } catch (Exception e) {
	    	model.put("success", false);
	    	model.put("message", e.getMessage());
	        model.put("resultCode", "F");
	    }
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(url);
	}
	
	private void sendJsonResponse(HttpServletResponse response, Map<String, Object> result) throws IOException {
		response.setHeader("Cache-Control", "no-cache");
	    response.setContentType("application/json; charset=UTF-8");
	    ObjectMapper objectMapper = new ObjectMapper();
	    response.getWriter().write(objectMapper.writeValueAsString(result));
	}
	
	// TB_WF_INSTANCE 생성 
	public Map<String, Object> zYncc_createWfDoc_CS(HttpServletRequest request, Map<String, Object> result, ModelMap model, HashMap cmmMap) throws Exception {	
		HashMap setData = new HashMap();
		HashMap insertWFInstData = new HashMap();
		HashMap insertWFInstTxtData = new HashMap();
		HashMap insertWFStepData = new HashMap();
		
		String docSubClass = StringUtil.checkNull(request.getParameter("docSubClass")); // classCode
		String wfDocType = StringUtil.checkNull(request.getParameter("wfDocType")); // CS
		String wfID = StringUtil.checkNull(request.getParameter("defWFID"),""); if(wfID.equals("")) wfID="WF004";
		String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"));		
		String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
		
		try {
			setData.put("wfID", wfID);			
			String reqReApprovalYN =  StringUtil.checkNull(request.getParameter("reqReApproval"));
			
			setData.put("changeSetID",changeSetID);
			String itemID = commonService.selectString("cs_SQL.getItemIDForCSID", setData);
			// SR MST
			setData.put("s_itemID", itemID);
			setData.put("changeSetID", changeSetID);
			setData.put("languageID", languageID);
			Map itemInfo = commonService.select("report_SQL.getItemInfo", setData);	
		    String approverID = StringUtil.checkNull(cmmMap.get("sessionUserId"));	 
		    
			if(reqReApprovalYN.equals("Y")) { // 결재가 삭제 -1 상태여서 재승인요청 일경우
				
			} else { // if(!reqReApprovalYN.equals("Y")) { // 재요청이 아닐경우 신규생성
				setData.put("wfID",wfID); // WF004
				setData.put("wfDocType",wfDocType); // CS
				setData.put("docSubClass",docSubClass); // CL01005
				
				String wfAllocID = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFAllocID", setData));
				
				setData.put("wfAllocID", wfAllocID);						
				setData.put("wfStepMemberIDs", StringUtil.checkNull(cmmMap.get("sessionUserId"))); 
				setData.put("wfStepRoleTypes", "AREQ");
				setData.put("wfStepInfo", StringUtil.checkNull(cmmMap.get("sessionUserNm")));
			
				String subject = " ["+StringUtil.checkNull(itemInfo.get("Identifier"))+"] " + StringUtil.checkNull(itemInfo.get("ItemName")); 
				setData.put("subject", subject);
				
				String description = StringUtil.checkNull(itemInfo.get("Description"));	
				setData.put("description", description);
								
				String projectID = StringUtil.checkNull(itemInfo.get("ProjectID"));
				
				String getWfStepMemberIDs = StringUtil.checkNull(setData.get("wfStepMemberIDs"));
				String getWfStepRoleTypes = StringUtil.checkNull(setData.get("wfStepRoleTypes"));
				
				String wfStepMemberIDs[] = null;
				String wfStepRoleTypes[] = null;
				String wfStepSeq[] = null;
				
				if(!getWfStepMemberIDs.isEmpty()){ wfStepMemberIDs = getWfStepMemberIDs.split(","); }
				if(!getWfStepRoleTypes.isEmpty()){ wfStepRoleTypes = getWfStepRoleTypes.split(","); wfStepSeq = getWfStepRoleTypes.split(",");}
				
				// SET APRV PATH	
				int idx = 0;
									
				for(int j=0; j< wfStepRoleTypes.length; j++){	
					if(j == 0){						
						wfStepSeq[j] = "0";
						idx++;
					} else {						
						wfStepSeq[j] = StringUtil.checkNull(idx);
						idx++;
					}
				}
	
				int lastSeq = idx-1;		
								
				//Delete WF Instance Text 
				if (!"".equals(StringUtil.checkNull(request.getParameter("wfInstanceID")))) {
					setData.put("wfInstanceID", StringUtil.checkNull(request.getParameter("wfInstanceID")));
					commonService.delete("wf_SQL.deleteWFInstTxt", setData);
				}
				String status = "0"; // 0: 임시저장, 1: 상신, 2: 승인, 3: 반려, 삭제: -1
				
				//INSERT NEW WF Instance
				insertWFInstData.put("ProjectID", projectID);
				insertWFInstData.put("DocumentID", changeSetID);
				insertWFInstData.put("DocumentNo", StringUtil.checkNull(itemInfo.get("Identifier")));
				insertWFInstData.put("DocCategory", wfDocType);
				insertWFInstData.put("WFID", wfID);
				insertWFInstData.put("LastUser", approverID);
				insertWFInstData.put("Status", status); // 상신
				insertWFInstData.put("curSeq", "1");
				insertWFInstData.put("LastSigner", StringUtil.checkNull(cmmMap.get("sessionUserId")));
				insertWFInstData.put("lastSeq", lastSeq);
				insertWFInstData.put("creatorTeamID", StringUtil.checkNull(cmmMap.get("sessionTeamId")));
				insertWFInstData.put("wfAllocID", wfAllocID);
				insertWFInstData.put("Creator",  StringUtil.checkNull(cmmMap.get("sessionUserId")));
				insertWFInstData.put("prefix", GlobalVal.OLM_SERVER_NAME);
				insertWFInstData.put("padLen", 10);
				
				System.out.println("insert WF : "+insertWFInstData);
				commonService.insert("wf_SQL.insertToWfInst", insertWFInstData);
				String newWFInstanceID = StringUtil.checkNull(insertWFInstData.get("WFInstanceID"));
				
				System.out.println("newWFINstanceID :"+newWFInstanceID);
				
				//INSERT WF STEP INST
				String maxId = "";
			   if(!getWfStepMemberIDs.isEmpty()){
					for(int i=0; i< wfStepMemberIDs.length; i++){	
											
						status = null ;						
						insertWFStepData.put("Seq", wfStepSeq[i]);
						maxId = commonService.selectString("wf_SQL.getMaxStepInstID", setData);	
						
						insertWFStepData.put("StepInstID", Integer.parseInt(maxId) + 1); 						
						insertWFStepData.put("ProjectID", projectID);
						
						if( i == 0){ status = "1"; } else if( wfStepSeq[i].equals("1") ){ status = "0"; }
						
						insertWFStepData.put("Status", status);
						insertWFStepData.put("ActorID", wfStepMemberIDs[i]);
						insertWFStepData.put("WFID", wfID);
						insertWFStepData.put("WFStepID", wfStepRoleTypes[i]);
						insertWFStepData.put("WFInstanceID", newWFInstanceID); 
						
						commonService.insert("wf_SQL.insertWfStepInst", insertWFStepData);
					}
				}
				
				//INSERT WF INST TEXT(SUBJECT, DECSRIPTION)
			    insertWFInstTxtData.put("WFInstanceID",newWFInstanceID);
				insertWFInstTxtData.put("subject",subject);
				insertWFInstTxtData.put("subjectEN",subject);
				insertWFInstTxtData.put("description",description);
				insertWFInstTxtData.put("descriptionEN",description);
				insertWFInstTxtData.put("comment","");
				insertWFInstTxtData.put("actorID",StringUtil.checkNull(cmmMap.get("sessionUserId")));
				commonService.insert("wf_SQL.insertWfInstTxt", insertWFInstTxtData);	
				
				
				insertWFInstTxtData.put("wfInstanceID",newWFInstanceID);
				insertWFInstTxtData.put("s_itemID",changeSetID);
				insertWFInstTxtData.put("Status", "APRV");
				commonService.update("cs_SQL.updateChangeSet", insertWFInstTxtData);	
				
				result.put("wfInstanceID", newWFInstanceID);
				result.put("WFInstanceID", newWFInstanceID);
				result.put("subject", subject);
				result.put("description", description);
				result.put("itemID", itemID);
				result.put("changeSetID", changeSetID);
				result.put("docSubClass", docSubClass);
				result.put("wfDocType", wfDocType);
				result.put("wfID", wfID);
			}
		} catch(Exception e) {
			result.put("success", false);
			result.put("error", "Y");
	        //result.put("message", e.getMessage());
			System.out.println("결재 TB_WF_INST 생성중 오류발생 :"+e);
	        result.put("message", "결재 TB_WF_INST 생성중 오류발생");
		}
		
	    return result;
	}
	
	// 전자결재 정보 조회 및 설정
	public Map<String, Object> zYncc_setWfData(HttpServletRequest request, Map<String, Object> result,  HashMap cmmMap ) throws Exception {
		try {
			String itemID = StringUtil.checkNull(result.get("itemID"));
			String changeSetID = StringUtil.checkNull(result.get("changeSetID"));
			result.put("itemID", itemID);
			result.put("changeSetID", changeSetID);
			
		    String wfInstanceID = StringUtil.checkNull(result.get("wfInstanceID")); //DOCKEY
			
			String subject = StringUtil.checkNull(result.get("subject"));
				   subject = StringEscapeUtils.escapeHtml4(subject); 
			String description = StringUtil.checkNull(result.get("description"));
				   description = StringEscapeUtils.unescapeHtml4(description); 
			String identifier = StringUtil.checkNull(result.get("identifier"));
			
			String DOCKEY = StringUtil.checkNull(result.get("wfInstanceID")); 
			String DOCTYPE = "PAL"; 
			String SYSID = "SFW01";
			String DOCTITLE = subject;
			String USER = StringUtil.checkNull(cmmMap.get("sessionLoginId")); // LoginID
			String PERNR = StringUtil.checkNull(cmmMap.get("sessionEmployeeNm")); 
			String XSTAT = "R";
			String XMSGS = "";
			LocalDateTime now = LocalDateTime.now();
			String XDATS = now.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
			String XTIMS =  now.format(DateTimeFormatter.ofPattern("HHmmss"));
			
			String approverInfo = StringUtil.checkNull(cmmMap.get("sessionUserNm"), "") + "(" +StringUtil.checkNull(cmmMap.get("sessionTeamName"),"")+ ")";
		
			String OLM_SERVER_URL =  StringUtil.checkNull(GlobalVal.OLM_SERVER_URL);
			
			result.put("DocumentID", changeSetID);
			List fileList = commonService.selectList("fileMgt_SQL.getFile_gridList", result);
			
			StringBuilder bodyContext = new StringBuilder(4096);

	        bodyContext.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	        bodyContext.append("<soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\" ")
	                   .append("xmlns:tem=\"http://tempuri.org/\">");
	        bodyContext.append("<soap:Header/>");
	        bodyContext.append("<soap:Body>");
	        bodyContext.append("<tem:GetCommonDataforXML>");
	        bodyContext.append("<tem:commonData>");

	        bodyContext.append("<tem:XROWS>").append(fileList.size()).append("</tem:XROWS>");
	        bodyContext.append("<tem:Datas>");

	        bodyContext.append("<tem:DOCKEY>").append(DOCKEY).append("</tem:DOCKEY>");
	        bodyContext.append("<tem:DOCTYPE>").append(DOCTYPE).append("</tem:DOCTYPE>");
	        bodyContext.append("<tem:SYSID>").append(SYSID).append("</tem:SYSID>");
	        bodyContext.append("<tem:DOCTITLE>").append(DOCTITLE).append("</tem:DOCTITLE>");
	        bodyContext.append("<tem:USER>").append(USER).append("</tem:USER>"); //T0007700(정은철)
	        bodyContext.append("<tem:PERNR>").append(PERNR).append("</tem:PERNR>"); // T0007700(정은철)
	        
	        bodyContext.append("<tem:CONTENTS><![CDATA[");

			// ====== // ---- CONTENTS HTML 본문 시작 ======
			bodyContext.append("<table style=\"width: 100%; border-collapse: collapse; margin-bottom: 20px; table-layout: fixed; \">");
			bodyContext.append("<tr>");
			bodyContext.append("<td style=\"border:1px solid #ccc;padding:8px;\">");

			bodyContext.append("<div id=\"content\" ")
	           .append("style=\"width:100%;font-size:14px;font-family:'Malgun Gothic',sans-serif;box-sizing:border-box;min-height:200px;\">")
	           .append(description)  // 예: "<p>프로세스 자산화 시스템입니다.</p><p>테스트 입니다.&nbsp;</p>"
	           .append("</div>");
			bodyContext.append("</td>");
			bodyContext.append("</tr>");
			bodyContext.append("</table>");
			bodyContext.append("]]></tem:CONTENTS>");
			// ---- CONTENTS 종료 ----
			
	        bodyContext.append("<tem:XSTAT>").append(XSTAT).append("</tem:XSTAT>");
	        bodyContext.append("<tem:XMSGS>").append(XMSGS == null ? "" : XMSGS).append("</tem:XMSGS>");
	        bodyContext.append("<tem:XDATS>").append(XDATS).append("</tem:XDATS>");
	        bodyContext.append("<tem:XTIMS>").append(XTIMS).append("</tem:XTIMS>");
	        
	        // ---- files 블록: ATTACHFILEINFOS 반복 ----
	        bodyContext.append("<tem:files>");
	       
	        if (fileList.size() > 0) {
		        for (int i = 0; i < fileList.size(); i++) {
			        Map fileInfo = (Map) fileList.get(i);
		        	
			        String seq = StringUtil.checkNull(fileInfo.get("Seq"));
			        String fileName = StringUtil.checkNull(fileInfo.get("FileRealName"));
			        String fileSize = StringUtil.checkNull(fileInfo.get("FileSize"));
			        String fileUrl = OLM_SERVER_URL + "custom/inboundLinkFileDown.do?linkID="+seq;
			       
			        bodyContext.append("<tem:ATTACHFILEINFOS>");
		            bodyContext.append("<tem:FILENAME>").append(fileName).append("</tem:FILENAME>");
		            bodyContext.append("<tem:FILESIZE>").append(fileSize).append("</tem:FILESIZE>");
		            bodyContext.append("<tem:FILEURL><![CDATA[").append(fileUrl == null ? "" : fileUrl).append("]]></tem:FILEURL>");
		            bodyContext.append("<tem:FILEID>").append(seq == null ? "" : seq).append("</tem:FILEID>");
		            bodyContext.append("<tem:GUID>").append("</tem:GUID>");
		            bodyContext.append("<tem:ETC1>").append("</tem:ETC1>");
		            bodyContext.append("<tem:ETC2>").append("</tem:ETC2>");
		            bodyContext.append("<tem:ETC3>").append("</tem:ETC3>");
		            
		            bodyContext.append("</tem:ATTACHFILEINFOS>");
		        }
	        }
	        bodyContext.append("</tem:files>");	        
	        bodyContext.append("</tem:Datas>");
	        bodyContext.append("</tem:commonData>");
	        bodyContext.append("</tem:GetCommonDataforXML>");
	        bodyContext.append("</soap:Body>");
	        bodyContext.append("</soap:Envelope>");
			 
			result.put("wfInstanceID", wfInstanceID);
			result.put("success", true);
			result.put("bodyContext", bodyContext.toString()); // 본문 데이터, 본문 HTML	
				
		} catch(Exception e) {
			result.put("success", false);
			result.put("error", "Y");
	        //result.put("message", e.getMessage());
			System.out.println("오류 발생 msg :"+e);
	        result.put("message", "결재 생성하다 난 오류입니다.");
		}
	    return result;
	}
		
	//  전자 결재 그룹웨어 전송	
	public Map<String, Object> sendToGroupware(Map<String, Object> wfData) throws Exception {
		Map<String, Object> sendResult = new HashMap<>();
		try {

	        String gwUrl = StringUtil.checkNull(wfData.get("gwUrl")); // https://gw.ynccdev.co.kr/Website/Base/Controls/IntegratedLegacyExt.asmx
	        System.out.println("gwUrl :" + gwUrl + "\n wfData :\n "+ StringUtil.checkNull(wfData.get("bodyContext")) );
	    
	        URL url = new URL(gwUrl);
	        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	        System.out.println("▶ URL 연결 실행");
	        
	        conn.setConnectTimeout(10000); // 연결 타임아웃 (ms) - 10초
	        conn.setReadTimeout(10000);    // 응답 대기 타임아웃 (ms) - 15초

	        conn.setRequestMethod("POST");
	        conn.setDoOutput(true);
	        // conn.setRequestProperty("Content-Type", "text/xml; charset=UTF-8");
	        conn.setRequestProperty(
        	    "Content-Type",
        	    "application/soap+xml; charset=UTF-8; action=\"http://tempuri.org/GetCommonDataforXML\""
        	);
	        
	        System.out.println("▶ OutputStream 열기 전"); // 확인용 로그
	
	        try (OutputStream os = conn.getOutputStream()) {
	            System.out.println("▶ OutputStream 열림");
	            os.write(StringUtil.checkNull(wfData.get("bodyContext")).getBytes("UTF-8"));
	            System.out.println("데이터 전송 완료");

	            int responseCode = conn.getResponseCode();
	            System.out.println("Response Code: " + responseCode);

	            //응답 스트림 읽어서 Raw 데이터 전체 로그 출력
	            InputStream responseStream = (responseCode >= 200 && responseCode < 400)
	                    ? conn.getInputStream()
	                    : conn.getErrorStream();

	            if (responseStream != null) {
	                BufferedReader in = new BufferedReader(new InputStreamReader(responseStream, "UTF-8"));
	                StringBuilder responseBody = new StringBuilder();
	                String line;
	                while ((line = in.readLine()) != null) {
	                    responseBody.append(line).append("\n");
	                }
	                in.close();

	                // 원본 응답 그대로 출력
	                System.out.println("YNCC GW API 응답 원문 ===============================");
	                System.out.println(responseBody.toString());
	                System.out.println("=============================================");

	                // XML 파싱 시도
	                try {
	                    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
	                    DocumentBuilder builder = factory.newDocumentBuilder();
	                    InputStream xmlInput = new ByteArrayInputStream(responseBody.toString().getBytes("UTF-8"));
	                    Document doc = builder.parse(xmlInput);
	                    doc.getDocumentElement().normalize();

	                    // 각 태그 값 추출
	                    String docUrl = getTagValue(doc, "DOCURL");
	                    String xstat  = getTagValue(doc, "XSTAT");
	                    String xmsgs  = getTagValue(doc, "XMSGS");
	                    String xdat   = getTagValue(doc, "XDATS");
	                    String xtim   = getTagValue(doc, "XTIMS");
	                    String docKey = getTagValue(doc, "DOCKEY");

	                    // 결과 로그
	                    System.out.println("결재문서 URL: " + docUrl);
	                    System.out.println("수행 결과: " + xstat);
	                    System.out.println("전송 메시지: " + xmsgs);
	                    System.out.println("전송 일자: " + xdat);
	                    System.out.println("전송 시간: " + xtim);

	                    sendResult.put("success", true);
	                    sendResult.put("docUrl", docUrl);
	                    sendResult.put("xstat", xstat);
	                    sendResult.put("xmsgs", xmsgs);
	                    sendResult.put("xdat", xdat);
	                    sendResult.put("xtim", xtim);
	                    sendResult.put("docKey", docKey);
	                    sendResult.put("resultCode", "S");
	                } catch (Exception e) {
	                    System.out.println("XML 파싱 실패 - 원문 응답만 처리됨: " + e.getMessage());
	                    sendResult.put("resultCode", "F");
	                }
	            } else {
	                System.out.println("응답 스트림이 없습니다.");
	                sendResult.put("resultCode", "F");
	            }
		        
		        sendResult.put("responseCode", responseCode);
	        }
        } catch (IOException ioe) {
            System.err.println("전송 실패: " + ioe.getMessage());
            ioe.printStackTrace(); // 원인 분석을 위한 상세 로그
            sendResult.put("sendResult", "send CNN ERR"); //전자결재 승인 요청이 완료 
            sendResult.put("success", false);
            sendResult.put("resultCode", "F");
            return sendResult;
        }
        
        return sendResult;
    }
	
	// XML 태그 값 가져오는 헬퍼 메소드
	private static String getTagValue(Document doc, String tag) {
	    NodeList list = doc.getElementsByTagName(tag);
	    if (list != null && list.getLength() > 0) {
	        return list.item(0).getTextContent();
	    }
	    return null;
	}
	
	private void rollbackWfInstance(String wfInstanceID, HashMap cmmMap) {
	    try {
	        if (wfInstanceID == null || wfInstanceID.isEmpty()) {
	            System.err.println("❌ wfInstanceID가 비어 있어 롤백 불가");
	            return;
	        }
	        Map<String, String> setData = new HashMap();
	        setData.put("wfInstanceID", wfInstanceID);
	        // 1. TB_WF_STEP_INST
	        commonService.delete("wf_SQL.deleteWFStepInst", setData);

	        // 2. TB_WF_INST_TXT
	        commonService.delete("wf_SQL.deleteWFInstTxt", setData);

	        // 3. TB_WF_INST
	        commonService.delete("wf_SQL.deleteWFInst", setData);
	        
	        // 4. rollback	  
			HashMap<String, String> reworkMap = new HashMap();
			reworkMap.put("item", StringUtil.checkNull(cmmMap.get("itemID"), ""));
			reworkMap.put("cngt", StringUtil.checkNull(cmmMap.get("changeSetID"), ""));
			reworkMap.put("pjtId", StringUtil.checkNull(cmmMap.get("ProjectID"), ""));
			
	        CSActionController.doReworkTx(reworkMap, cmmMap);
	        
	        System.out.println("전자결재 롤백 처리 완료: wfInstanceID = " + wfInstanceID);

	    } catch (Exception e) {
	        System.err.println("전자결재 롤백 중 예외 발생: " + e.getMessage());
	        e.printStackTrace();
	    }
	}
	
	// 그룹웨어 전자결재에서 상태값 리턴 
	// http://localhost/custom/yncc/csAprvPostProcessing.do // 파라미터 전달 방식 Content-Type: application/json
	@RequestMapping({"/custom/yncc/csAprvPostProcessing.do"})	
	public void csAprvPostProcessing(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception { 
		System.out.println(" /custom/yncc/csAprvPostProcessing.do :: GW -> SFOLM 수신");	
    	Map setData = new HashMap();
    	try {
    			//필수 파라미터 정보 : wfInstanceID, DOCURL, approveStatus
    		    StringBuilder sb = new StringBuilder();
    	        try (BufferedReader reader = request.getReader()) {
    	            String line;
    	            while ((line = reader.readLine()) != null) {
    	                sb.append(line);
    	            }
    	        }
    	        
    	        String jsonBody = sb.toString();
    	        System.out.println("▶ Received JSON Body: " + jsonBody);

    	        // Jackson으로 파싱
    	        com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
    	        Map<String, Object> jsonMap = mapper.readValue(jsonBody, Map.class);

    	        // ✅ JSON 데이터 추출
    	        String wfInstanceID = StringUtil.checkNull(jsonMap.get("wfInstanceID"));
    	        String DOCURL = StringUtil.checkNull(jsonMap.get("DOCURL"));
    	        String approveStatus = StringUtil.checkNull(jsonMap.get("approveStatus"));
    	        String languageID = "1042";

    	        System.out.println("▶ wfInstanceID: " + wfInstanceID);
    	        System.out.println("▶ DOCURL: " + DOCURL);
    	        System.out.println("▶ approveStatus: " + approveStatus);
    	        	    	    
	            setData.put("WFInstanceID", wfInstanceID);
    			Map wfInstanceInfo = commonService.select("wf_SQL.getWFINSTanceInfo", setData);
    			
    			wfInstanceID = StringUtil.checkNull(wfInstanceInfo.get("WFInstanceID"));			
    			String itemID = StringUtil.checkNull(wfInstanceInfo.get("DocumentNo"));    		   
    			String changeSetID = StringUtil.checkNull(wfInstanceInfo.get("changeSetID"));
    			
    			setData.put("changeSetID", changeSetID);
    			setData.put("languageID", languageID);
    			Map itemInfo = commonService.select("report_SQL.getItemInfo", setData);	
    		    String approverID = StringUtil.checkNull(wfInstanceInfo.get("ActorID"));	 
    			    			
    			setData.put("wfID", StringUtil.checkNull(wfInstanceInfo.get("WFID")));
    			setData.put("wfDocType", StringUtil.checkNull(wfInstanceInfo.get("DocCategory")));
    			setData.put("docSubClass", itemInfo.get("ClassCode"));
    			String postProcessing = StringUtil.checkNull(commonService.selectString("wf_SQL.getPostProcessing", setData));
    			
    			// 임시저장(T), 상신(2), 승인(4), 반려(R), 삭제(D), 회수(임시저장)(C), 회수(상신)(2)
    		    String status = "";
    		    String approveYN = "";  // postprocessing param
    		   if(approveStatus.equals("P")) { // 상신, 회수(상신)
    				status = "1"; // 상신     				
    		    } else if(approveStatus.equals("A")) { // 승인
    				status = "2"; // 완료(승인)    				
    			} else if(approveStatus.equals("R")){ // 반려
    				status = "3"; // 반려(반송)    				
    			} 
    		 
    			setData.put("Status", status);
    			setData.put("WFInstanceID", wfInstanceID);
    			
    			setData.put("LastUser",  approverID);
    			setData.put("LastSigner", approverID); 
    			setData.put("ActorID", approverID); 
    			setData.put("Path", DOCURL);
    			
    			System.out.println("update WF setData :"+setData);
    			
    			// update wf_inst 
    			commonService.update("wf_SQL.updateWfInst", setData);
    			commonService.update("wf_SQL.updateWFStepInst", setData);
    	
			    if (StringUtils.isNotBlank(postProcessing) && ("2".equals(status) || "3".equals(status))) {
    				commandMap.put("status","CLS");
					commandMap.put("wfInstanceID",wfInstanceID); 
					commandMap.put("wfInstanceStatus",status); 
					CSActionController.updateCSStatusForWF(request,commandMap,model);
    			}
			    
			    Map<String, String> responseMap = new HashMap<>();
				String ReturnCode  = "S";
				String ReturnMessage  = "Success";
		        responseMap.put("ReturnCode", ReturnCode); 
		        responseMap.put("ReturnMessage", ReturnMessage); 

		        ObjectMapper objectMapper = new ObjectMapper();
		        String jsonResponse = objectMapper.writeValueAsString(responseMap);
		        
		        response.setHeader("Cache-Control", "no-cache");
			    response.setContentType("text/plain");
			    response.setCharacterEncoding("UTF-8");
			    
			    response.getWriter().print(jsonResponse);
			    
    	}catch (Exception e){	    
	    	System.out.println("YnccActionController :: /custom/yncc/csAprvPostProcessing.do ERROR :"+ e);	
	    	Map<String, String> responseMap = new HashMap<>();
	    	
	    	String ReturnCode  = "F";
			String ReturnMessage  = "Fail";
	        responseMap.put("ReturnCode", ReturnCode); 
	        responseMap.put("ReturnMessage", ReturnMessage); 

	        ObjectMapper objectMapper = new ObjectMapper();
	        String jsonResponse = objectMapper.writeValueAsString(responseMap);
	        
	        response.setHeader("Cache-Control", "no-cache");
		    response.setContentType("text/plain");
		    response.setCharacterEncoding("UTF-8");
		    
		    response.getWriter().print(jsonResponse);
	    }
	}
		
	@RequestMapping(value = "/custom/yncc/logout.do")	
	public void logout(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception {

		int nResult = -1;
		String sToken = getCookie(request, "ssoToken");
	
		String CIP = request.getRemoteAddr();
	
		SSO sso = new SSO();
	
		// policyserver에서 관리하는 세션을 삭제합니다. 파라미터는 토큰 값을 넣습니다.
		// 삭제에 성공하면 0을 리턴하고 실패하면 음수의 에러코드를 리턴합니다.
		nResult = sso.unregUserSession(sToken, CIP);
		
		String SSO_URL = "https://aha.yncc.co.kr/";
		
		if(nResult == 0 )  // 세션 삭제 성공시
		{
			System.out.println("세션 삭제 성공 !");
			setCookie( response, "ssoToken", null );	
			response.sendRedirect(SSO_URL);
			// 쿠키 값 삭제 후 로그인 페이지 혹은 기타 페이지로 이동
		}

	}
	
	@RequestMapping(value = "/custom/yncc/indexYNCC.do")	
	public String indexYNCC(Map cmmMap, ModelMap model, HttpServletRequest request, HashMap commandMap, HttpServletResponse response) throws Exception {
		try {
			printAllCookies(request);
			
			response.setHeader("Cache-Control", "no-cache");
			
			String CIP = request.getRemoteAddr();
			int nResult = -1;
			String sToken = getCookie(request, "ssoToken");
			 
			System.out.println("=======================================================");
			System.out.println("CIP : " + CIP);
			System.out.println("Token : " + sToken);
			System.out.println("=======================================================");
			
			String userID = "";
			String SSO_URL = "https://aha.yncc.co.kr/";
			
			if ( sToken  !=  null ) {
				System.out.println("Token 검증을 시작합니다.");
				
				SSO sso = new SSO();
				
				// nResult = sso.verifyToken( sToken, CIP ) ;
				nResult = sso.verifyToken( sToken, "" ) ;
				
				System.out.println("Token 검증 결과 -> nResult Code : " + nResult);
				
//				if( nResult < 0 && !(nResult == -1032 || nResult == -1033 || nResult == -1205 || nResult == -1207) ) {
				if( nResult == -2902 || nResult == -710 || nResult == -748 || nResult == -771 || nResult == -441 || nResult == -442 ) {
					if( nResult == -2902 ) {
						System.out.println("“세션이 만료되었습니다.”");
						// 로그인 페이지로 리다이렉션 시킨다.
						response.sendRedirect(SSO_URL);
					} else if( nResult == -710 || nResult == -748 || nResult == -771 ) {
						System.out.println("“SSO Agent(safeagent)로 연결을 실패하였습니다. Agent가 동작중인지 확인하세요.”");
						// 로그인 페이지로 리다이렉션 시킨다.
						response.sendRedirect(SSO_URL);
					} 
//					else if( nResult == -1032 || nResult == -1033 ) {
//						System.out.println("“정책서버(policyserver)로 연결을 실패하였습니다. 정책서버가 동작중인지 확인하세요.”");
//						// 로그인 페이지로 리다이렉션 시킨다. 
//						response.sendRedirect(SSO_URL);  
//					}
					else if( nResult == -441 || nResult == -442 ) {
						System.out.println("“토큰이 존재하지 않습니다.”");
						// 로그인 페이지로 리다이렉션 시킨다.
						response.sendRedirect(SSO_URL);
					} 
//					else if( nResult == -1205 || nResult == -1207 ) {
//						System.out.println("“토큰 생성시 사용된  서버의  API Key, GroupID(ssotoken.key에서 정의)값과 검증 대상 서버의에서의 값이 다릅니다”");
//						System.out.println("(“또는  VPN 환경등의 이유로 토큰 생성시 클라이언트 IP와 검증시의 IP 값이 다릅니다.”");
//						// 로그인 페이지로 리다이렉션 시킨다.
//						response.sendRedirect(SSO_URL);
//					} 
					else {
						System.out.println("“로그인에 실패하였습니다. 에러코드[" + nResult + "“]”");
						// 로그인 페이지로 리다이렉션 시킨다.
						response.sendRedirect(SSO_URL);
					} 
				} else {
//					if ( nResult == -1032 || nResult == -1033 ) {
//						System.out.println("“정책서버(policyserver)로 연결을 실패하였습니다. 정책서버가 동작중인지 확인하세요.”");
//					} else if( nResult == -1205 || nResult == -1207 ) {
//						System.out.println("“토큰 생성시 사용된  서버의  API Key, GroupID(ssotoken.key에서 정의)값과 검증 대상 서버의에서의 값이 다릅니다”");
//						System.out.println("(“또는  VPN 환경등의 이유로 토큰 생성시 클라이언트 IP와 검증시의 IP 값이 다릅니다.”");
//					}
					
					System.out.println("Token 통과 !");					
					
					userID = sso.getValueUserID(); //로그인시 입력한 사용자 ID 값 추출
					
					System.out.println("Token 존재, SSO ON : " + userID);
					// 이후 각 연동 시스템에서 사용자의 아이디로 로그인 처리 후 해당 시스템의 메인 
					// 페이지로 리다이렉션 시켜서 시스템을 이용하도록 코딩한다.
					
					String olmI = "";				
					
					if (!"".equals(userID) && userID != null) {
						olmI = userID;
					}	
					
					model.put("olmI", olmI);
					model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType"), ""));
					model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType"), ""));
					model.put("srID", StringUtil.checkNull(cmmMap.get("srID"), ""));
					model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode"), ""));
					model.put("proposal", StringUtil.checkNull(cmmMap.get("proposal"), ""));
					model.put("status", StringUtil.checkNull(cmmMap.get("status"), ""));
					
				}
				
			} else {
				// alert 창 띄우기
				model.put(AJAX_SCRIPT, "parent.fnReload('N')");
				model.put(AJAX_ALERT, "TOKEN is not exist. Please try logging in again.");
				response.sendRedirect(SSO_URL);
			}
			
		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("YNCCActionController::mainpage::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/indexYNCC");
	}
	
	@RequestMapping(value = "/custom/yncc/loginYnccForm.do")
	public String loginYnccForm(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		model = setLoginScrnInfo(model, cmmMap);
		model.put("screenType", cmmMap.get("screenType"));
		model.put("mainType", cmmMap.get("mainType"));
		model.put("srID", cmmMap.get("srID"));
		model.put("sysCode", cmmMap.get("sysCode"));
		model.put("proposal", cmmMap.get("proposal"));
		model.put("status", cmmMap.get("status"));
		
		return nextUrl("/custom/yncc/login");
	}	
	
	@RequestMapping(value = "/custom/yncc/loginYncc.do")
	public String loginYncc(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		try {
			
			HttpSession session = request.getSession(true);
			Map resultMap = new HashMap();
			String langCode = GlobalVal.DEFAULT_LANG_CODE;
			String languageID = StringUtil.checkNull(cmmMap.get("LANGUAGE"),
					StringUtil.checkNull(cmmMap.get("LANGUAGEID")));
			if (languageID.equals("")) {
				languageID = GlobalVal.DEFAULT_LANGUAGE;
			}

			cmmMap.put("LANGUAGE", languageID);
			String ref = request.getHeader("referer");
			//String protocol = request.isSecure() ? "https://" : "http://";

			String IS_CHECK = GlobalVal.PWD_CHECK;
			String url_CHECK = StringUtil.chkURL(ref, "https");

			if ("".equals(IS_CHECK))
				IS_CHECK = "Y";

			if ("".equals(url_CHECK)) {
				resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
				resultMap.put(AJAX_ALERT,
						"Your ID does not exist in our system. Please contact system administrator.");
			} else {

				Map idInfo = new HashMap();
  
				if ("Y".equals(IS_CHECK) && "login".equals(url_CHECK)) {
					cmmMap.put("IS_CHECK", "Y");
				} else {
					cmmMap.put("IS_CHECK", "N");
				}

				idInfo = commonService.select("login_SQL.login_id_select", cmmMap);

				if (idInfo == null || idInfo.size() == 0) {
					resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
					// resultMap.put(AJAX_ALERT, "해당아이디가 존재하지 않습니다.");
					resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00002"));
				} else {
					cmmMap.put("LOGIN_ID", idInfo.get("LoginId")); // parameter LOGIN_ID 는 사번이므로 조회한 LOGINID로 put
					Map loginInfo = commonService.select("login_SQL.login_select", cmmMap);
					if (loginInfo == null || loginInfo.size() == 0) {
						resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
						// resultMap.put(AJAX_ALERT, "System에 해당 사용자 정보가 없습니다.등록 요청바랍니다.");
						resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00102"));
					} else {
						// [Authority] < 4 인 경우, 수정가능하게 변경
						if (loginInfo.get("sessionAuthLev").toString().compareTo("4") < 0)
							loginInfo.put("loginType", "editor");
						else
							loginInfo.put("loginType", "viewer");
						resultMap.put(AJAX_SCRIPT, "parent.fnReload('Y')");
						// resultMap.put(AJAX_MESSAGE, "Login성공");
						session.setAttribute("loginInfo", loginInfo);
					}
				}
				model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx"))); // singleSignOn 구분
				model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType")));
				model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType")));
				model.put("srID", StringUtil.checkNull(cmmMap.get("srID")));
				model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode")));
				model.addAttribute(AJAX_RESULTMAP, resultMap);
			}
		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("LoginActionController::loginbase::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping("/custom/yncc/olmInboundLink.do")
	public String zYncc_InboundLink(HttpServletRequest request, HttpServletResponse response, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/template/olmLinkPopup";
		
		try {
			response.setHeader("Cache-Control", "no-cache");
			
			String CIP = request.getRemoteAddr();
			int nResult = -1;
			String sToken = getCookie(request, "ssoToken");
			
			String userID = "";
			String logonId = "";			
			String SSO_URL = "https://aha.yncc.co.kr/";
			
			System.out.println("=======================================================");
			System.out.println("CIP : " + CIP);
			System.out.println("Token : " + sToken);
			System.out.println("=======================================================");
			
			if ( sToken  !=  null ) {
				System.out.println("Token 검증을 시작합니다.");
				
				SSO sso = new SSO();
				
				// nResult = sso.verifyToken( sToken, CIP ) ;
				nResult = sso.verifyToken( sToken, "" ) ;
				
				System.out.println("Token 검증 결과 -> nResult Code : " + nResult);
				
//				if( nResult < 0 && !(nResult == -1032 || nResult == -1033 || nResult == -1205 || nResult == -1207) ) {
				if( nResult == -2902 || nResult == -710 || nResult == -748 || nResult == -771 || nResult == -441 || nResult == -442 ) {
					if( nResult == -2902 ) {
						System.out.println("“세션이 만료되었습니다.”");
						// 로그인 페이지로 리다이렉션 시킨다.
						response.sendRedirect(SSO_URL);
					} else if( nResult == -710 || nResult == -748 || nResult == -771 ) {
						System.out.println("“SSO Agent(safeagent)로 연결을 실패하였습니다. Agent가 동작중인지 확인하세요.”");
						// 로그인 페이지로 리다이렉션 시킨다.
						response.sendRedirect(SSO_URL);
					} 
//					else if( nResult == -1032 || nResult == -1033 ) {
//						System.out.println("“정책서버(policyserver)로 연결을 실패하였습니다. 정책서버가 동작중인지 확인하세요.”");
//						// 로그인 페이지로 리다이렉션 시킨다. 
//						response.sendRedirect(SSO_URL);  
//					}
					else if( nResult == -441 || nResult == -442 ) {
						System.out.println("“토큰이 존재하지 않습니다.”");
						// 로그인 페이지로 리다이렉션 시킨다.
						response.sendRedirect(SSO_URL);
					} 
//					else if( nResult == -1205 || nResult == -1207 ) {
//						System.out.println("“토큰 생성시 사용된  서버의  API Key, GroupID(ssotoken.key에서 정의)값과 검증 대상 서버의에서의 값이 다릅니다”");
//						System.out.println("(“또는  VPN 환경등의 이유로 토큰 생성시 클라이언트 IP와 검증시의 IP 값이 다릅니다.”");
//						// 로그인 페이지로 리다이렉션 시킨다.
//						response.sendRedirect(SSO_URL);
//					} 
					else {
						System.out.println("“로그인에 실패하였습니다. 에러코드[" + nResult + "“]”");
						// 로그인 페이지로 리다이렉션 시킨다.
						response.sendRedirect(SSO_URL);
					} 
				} else {
//					if ( nResult == -1032 || nResult == -1033 ) {
//						System.out.println("“정책서버(policyserver)로 연결을 실패하였습니다. 정책서버가 동작중인지 확인하세요.”");
//					} else if( nResult == -1205 || nResult == -1207 ) {
//						System.out.println("“토큰 생성시 사용된  서버의  API Key, GroupID(ssotoken.key에서 정의)값과 검증 대상 서버의에서의 값이 다릅니다”");
//						System.out.println("(“또는  VPN 환경등의 이유로 토큰 생성시 클라이언트 IP와 검증시의 IP 값이 다릅니다.”");
//					}
					System.out.println("Token 통과 !");
					
					userID = sso.getValueUserID(); //로그인시 입력한 사용자 ID 값 추출
					
					System.out.println("Token 존재, SSO ON : " + userID);
					// 이후 각 연동 시스템에서 사용자의 아이디로 로그인 처리 후 해당 시스템의 메인 
					// 페이지로 리다이렉션 시켜서 시스템을 이용하도록 코딩한다.
					
					logonId = userID;

					Map setData = new HashMap();
					Map userInfo = new HashMap();
					setData.put("loginID", logonId);
					setData.put("loginID", userID);
					userInfo = commonService.select("common_SQL.getLoginIDFromMember", setData);

					if (userInfo != null && !userInfo.isEmpty()) {
						String activeYN = "N";
						HashMap setInfo = new HashMap();

						setInfo.put("LOGIN_ID", StringUtil.checkNull(userInfo.get("LoginId")));

						activeYN = commonService.selectString("login_SQL.login_active_select", setInfo);
						if (!"Y".equals(activeYN)) {
							url = "/index";
						}

						model.put("olmI", StringUtil.checkNull(userInfo.get("LoginId")));
						model.put("loginid", StringUtil.checkNull(userInfo.get("LoginId")));
					}

					String languageID = StringUtil.checkNull(request.getParameter("languageID"));
					if (languageID.equals("")) {
						languageID = GlobalVal.DEFAULT_LANGUAGE;
					}

					model.put("languageID", languageID);
					model.put("keyId", StringUtil.checkNull(request.getParameter("keyId"), ""));
					model.put("object", StringUtil.checkNull(request.getParameter("object"), ""));
					model.put("linkType", StringUtil.checkNull(request.getParameter("linkType"), ""));
					model.put("linkID", StringUtil.checkNull(request.getParameter("linkID"), ""));
					model.put("iType", StringUtil.checkNull(request.getParameter("iType"), ""));
					model.put("aType", StringUtil.checkNull(request.getParameter("aType"), ""));
					model.put("option", StringUtil.checkNull(request.getParameter("option"), ""));
					model.put("type", StringUtil.checkNull(request.getParameter("type"), ""));
					model.put("changeSetID", StringUtil.checkNull(request.getParameter("changeSetID"), ""));
					model.put("projectType", StringUtil.checkNull(request.getParameter("projectType"), ""));
					model.put("olmLng", StringUtil.checkNull(request.getParameter("olmLng"), ""));
					model.put("screenType", StringUtil.checkNull(request.getParameter("screenType"), ""));
					model.put("mainType", StringUtil.checkNull(request.getParameter("mainType"), ""));
					
					
				}
				
			} else {
				url = "/index";
			}

		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl(url);
	}	

	private ModelMap setLoginScrnInfo(ModelMap model, HashMap cmmMap) throws Exception {
		String pass = StringUtil.checkNull(cmmMap.get("pwd"));
		model.addAttribute("loginid", StringUtil.checkNull(cmmMap.get("loginid"), ""));
		model.addAttribute("pwd", pass);
		model.addAttribute("lng", StringUtil.checkNull(cmmMap.get("lng"), ""));

		if (_log.isInfoEnabled()) {
			_log.info("setLoginScrnInfo : loginid=" + StringUtil.checkNull(cmmMap.get("loginid")) + ",pass"
					+ URLEncoder.encode(pass) + ",lng=" + StringUtil.checkNull(cmmMap.get("lng")));
		}
		List langList = commonService.selectList("common_SQL.langType_commonSelect", cmmMap);
		if (langList != null && langList.size() > 0) {
			for (int i = 0; i < langList.size(); i++) {
				Map langInfo = (HashMap) langList.get(i);
				if (langInfo.get("IsDefault").equals("1")) {
					model.put("langType", StringUtil.checkNull(langInfo.get("CODE"), ""));
					model.put("langName", StringUtil.checkNull(langInfo.get("NAME"), ""));
				}
			}
		} else {
			model.put("langType", "");
			model.put("langName", "");
		}
		model.put("langList", langList);
		model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx"))); // singleSignOn 구분
		return model;
	}	
	
	public void printAllCookies(HttpServletRequest request) {
	    Cookie[] cookies = request.getCookies();
	    if (cookies != null) {
	        System.out.println("COOKIES COUNT : " + cookies.length);
	        for (int i = 0; i < cookies.length; i++) {
	            Cookie c = cookies[i];
	            System.out.println("COOKIE [" + i + "] name: " + c.getName() +
	                               ", value: " + c.getValue() +
	                               ", domain: " + c.getDomain() +   // 이건 대부분 null
	                               ", path: " + c.getPath());        // 이건 간혹 보일 수 있음
	        }
	    } else { 
	        System.out.println("쿠키가 없습니다.");
	    }
	}
		
	
	/* sName=sValue 에 해당되는 쿠키 값을 세팅한다. */
	public void setCookie ( HttpServletResponse response, String sName, String sValue )
	{
		Cookie c = new Cookie( sName, sValue );
		c.setPath( "/" );
		// 필요에 따라 쿠키의 옵션값을 추가한다.
		c.setDomain("bpm.yncc.co.kr"); // 사용하는 도메인으로 설정한다.
		response.addCookie(c);
	}

	//---------------------------------------------------------
	/* sName 에 해당되는 쿠키 값을 얻는다. */
	public String getCookie( HttpServletRequest request, String sName )
	{
		Cookie[] cookies = request.getCookies();	
		System.out.println("COOKIES COUNT : " + cookies.length);
		if ( cookies != null ) 
		{
			for (int i=0; i < cookies.length; i++) 
			{	
			     String name = cookies[i].getName();
			     String sDomain = cookies[i].getDomain();		
				
			     if( name != null && name.equals(sName) ) 
			     {
			    	 //System.out.println("COOKIES [" + i + "] : " + cookies[i].getValue());
			    	 System.out.println("COOKIE [" + i + "] name: " + name + ", value: " + cookies[i].getValue());
			    	 return cookies[i].getValue();
			     }
			}
		}
		return null;	
	}
	
	
}