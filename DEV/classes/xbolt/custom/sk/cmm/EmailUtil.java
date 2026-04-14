package xbolt.custom.sk.cmm;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.mail.DefaultAuthenticator;
import org.apache.commons.mail.HtmlEmail;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.ModelMap;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import xbolt.cmm.framework.util.MakeEmailContents;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.DrmGlobalVal;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.custom.sk.val.skGlobalVal;


/**
 * SMTP Mail 발송 전용 처리
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2025. 01. 15. dhlim 최초생성
 *
 * @since 2025. 01. 15.
 * @version 1.0
 * @see
 * 
 * Copyright (C) 2025 by SMARTFACTORY All right reserved.
 */
@SuppressWarnings("unused")
public class EmailUtil {	
	
	@Resource(name = "commonService")
	private static CommonService commonService;
	
	public static Map sendMail(HashMap cmmEmailMap, HashMap cmmCnts, Map menu) throws Exception {
		Map returnMap = new HashMap();
		try {
			String baseUrl = GlobalVal.EMAIL_TYPE;
			String languageID = StringUtil.checkNull(cmmEmailMap.get("languageID"));
			String mailBody ="";
				
		if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("SRREQ")){
				mailBody = MakeEmailContents.makeHTML_SRREQ(cmmCnts, menu);					
		} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("CSRAPREQ")){
				 mailBody = MakeEmailContents.makeHTML_CSRAPREQ(cmmCnts,menu);
		
		} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("SRMRV")){
				mailBody = MakeEmailContents.makeHTML_SRREQ(cmmCnts, menu); 
		
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("APRVCLS")){
				mailBody = MakeEmailContents.makeHTML_APRVCLS(cmmCnts, menu);  
		
		} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("APRVRJT")){
				mailBody = MakeEmailContents.makeHTML_APRVRJT(cmmCnts, menu);  
		
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("APRVREF")){
				 mailBody = MakeEmailContents.makeHTML_APREQ_CS(cmmCnts, languageID, menu);	
		
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("BRDMAIL")){
				mailBody = MakeEmailContents.makeHTML_BRDMAIL(cmmCnts, menu); 
		
			}else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("REQITMRW")){
				mailBody = MakeEmailContents.makeHTML_REQITMRW(cmmCnts, menu); 
		
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("REQITMCLS")){
				mailBody = MakeEmailContents.makeHTML_REQITMCLS(cmmCnts, menu); 
		
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("SRTRP")){
				mailBody = MakeEmailContents.makeHTML_SRREQ(cmmCnts, menu); 
		
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("SRCMP")){
				mailBody = MakeEmailContents.makeHTML_SRCMP(cmmCnts, menu);
		
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("CRRCV")){
				mailBody = MakeEmailContents.makeHTML_CRRCV(cmmCnts, menu);
		
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("CSRCLS")){			
				mailBody = MakeEmailContents.makeHTML_APREQ_CSR(cmmCnts, languageID, menu);	
		
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("CSRNTC")){
				mailBody = MakeEmailContents.makeHTML_CSRNTC(cmmCnts, menu);
		
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("APREQ_CS")){			
				mailBody = MakeEmailContents.makeHTML_APREQ_CS(cmmCnts, languageID, menu);	
		
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("TERMREG")){			
				mailBody = MakeEmailContents.makeHTML_TERMREG(cmmCnts, menu);
		
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("TERMREL")){			
				mailBody = MakeEmailContents.makeHTML_TERMREL(cmmCnts, menu);				
		
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("SCHDL") || StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("SCHDLALM")){			
				mailBody = MakeEmailContents.makeHTML_SCHDL(cmmCnts, menu);
			
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("SRAPREQ")){
				mailBody = MakeEmailContents.makeHTML_SRAPREQ(cmmCnts,menu);
	
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("SRAPREL")){
				mailBody = MakeEmailContents.makeHTML_SRAPREL(cmmCnts,menu);
	
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("SRAPRJT")){
				mailBody = MakeEmailContents.makeHTML_SRAPRJT(cmmCnts,menu);
			
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("CTR")){			
				mailBody = MakeEmailContents.makeHTML_CTR(cmmCnts, menu);
			
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("SRCNGRDD")){			
				mailBody = MakeEmailContents.makeHTML_SRCNGRDD(cmmCnts, menu);
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("PIMEM001")){			
				mailBody = MakeEmailContents.makeHTML_PIMEM001(cmmCnts, menu);
		} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("REQSYSTEST")){
				mailBody = MakeEmailContents.makeHTML_REQSYSTEST(cmmCnts, menu);
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("ITSCMP")){
				mailBody = MakeEmailContents.makeHTML_ITSCMP(cmmCnts, menu);
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("REQSREV")){
				mailBody = MakeEmailContents.makeHTML_REQSREV(cmmCnts, menu);
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("RQUSRAUTH")){			
				mailBody = MakeEmailContents.makeHTML_RQUSRAUTH(cmmCnts, menu);
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("SCRAPREQ")){
			mailBody = MakeEmailContents.makeHTML_SCRAPREQ(cmmCnts, menu);
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("SCRAPREL")){
				mailBody = MakeEmailContents.makeHTML_SCRAPREL(cmmCnts, menu);
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("SCRAPRJT")){
				mailBody = MakeEmailContents.makeHTML_SCRAPRJT(cmmCnts, menu);
		} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("WFARLM")){
				mailBody = MakeEmailContents.makeHTML_WFARLM(cmmCnts, menu);
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("ESPMAIL001")){
				mailBody = MakeEmailContents.makeHTML_ESPMAIL001(cmmCnts, menu);					
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("ESPMAIL002")){
				mailBody = MakeEmailContents.makeHTML_ESPMAIL002(cmmCnts, menu);					
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("ESPMAIL003")){
				mailBody = MakeEmailContents.makeHTML_ESPMAIL003(cmmCnts, menu);					
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("ESPMAIL004")){
				mailBody = MakeEmailContents.makeHTML_ESPMAIL004(cmmCnts, menu);					
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("ESPMAIL005")){
				mailBody = MakeEmailContents.makeHTML_ESPMAIL005(cmmCnts, menu);					
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("ESPMAIL006")){
				mailBody = MakeEmailContents.makeHTML_ESPMAIL006(cmmCnts, menu);					
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("ESPMAIL007")){
				mailBody = MakeEmailContents.makeHTML_ESPMAIL007(cmmCnts, menu);					
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("ESPMAIL008")){
				mailBody = MakeEmailContents.makeHTML_ESPMAIL008(cmmCnts, menu);					
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("ESPMAIL009")){
				mailBody = MakeEmailContents.makeHTML_ESPMAIL009(cmmCnts, menu);					
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("ESPMAIL010")){
				mailBody = MakeEmailContents.makeHTML_ESPMAIL010(cmmCnts, menu);					
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("ESPMAIL011")){
				mailBody = MakeEmailContents.makeHTML_ESPMAIL011(cmmCnts, menu);					
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("ESPMAIL012")){
				mailBody = MakeEmailContents.makeHTML_ESPMAIL012(cmmCnts, menu);					
			} else 
			if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("LOGINAUTH")){
				mailBody = MakeEmailContents.makeHTML_LOGINAUTH(cmmCnts, menu);					
			}
			
			returnMap = sendSKEmail(cmmEmailMap,mailBody);
		}
		catch(Exception e) {
			System.out.println(e.toString());
		}
		return returnMap;
	}
	
//	성공인 경우
//	  "message": "You successfully receive title/body [메일 제목/본문]",
//	  "result": "SUCCESS",
//	  "Result": "SUCCESS",
//	  "Message": "You successfully receive title/body [메일 제목/본문]"
//
//	실패인 경우
//	  "message": "You failed => [실패 원인]",
//	  "result": "FAIL",
//	  "Result": " FAIL ",
//	  "Message": " You failed => [실패 원인]"
//	}
//
//	** 성공, 실패가 의미하는 것은 메일API 호출해서 파라미터 전달이 성공, 실패했다는 의미.
//	** 메일API에서 EWS로 전달 후에 실제 메일 발송이 성공했다는 의미는 아님.
	 
	private static Map sendSKEmail(HashMap cmmEmailMap, String mailBody) throws Exception {
		Map returnMap = new HashMap();

		try{
			String apiToken = skGlobalVal.SK_MAIL_TOKEN;
			 String mailSubject = StringUtil.checkNull(cmmEmailMap.get("mailSubject"));
			 List refList = (List)cmmEmailMap.get("refList");
			 List receiverInfoList = (List)cmmEmailMap.get("receiverInfoList");
			 String receiverList = "";
			 String ccList = "";
			 
			 if(receiverInfoList != null && !receiverInfoList.isEmpty()) {
				 for(int i=0; i<receiverInfoList.size(); i++) {
					 Map receiverInfo = (Map)receiverInfoList.get(i);
					 if(receiverInfo.get("receiptType") == "CC"){
						 if(ccList == "") ccList += "\""+StringUtil.checkNull(receiverInfo.get("receiptEmail"))+"\"";
						 else ccList += "," + "\""+StringUtil.checkNull(receiverInfo.get("receiptEmail"))+"\"";
					 }else{
						 if(receiverList == "") receiverList += "\""+StringUtil.checkNull(receiverInfo.get("receiptEmail"))+"\"";
						 else receiverList += "," + "\""+StringUtil.checkNull(receiverInfo.get("receiptEmail"))+"\"";
					 }
				 }
			 } else {
				 returnMap.put("type", "FAILE");
				 returnMap.put("msg", "No Receive Member");
				 
				 return returnMap;
			 }
			 
			 //System.out.println("mailBody ==== "+mailBody.replaceAll("\\n", ""));
			 
			 String requestBody = "{\"subject\":\""+mailSubject+"\",\"body\":\""+mailBody.replaceAll("\\n", "")+"\",\"to\": ["+receiverList+"]"+",\"cc\": ["+ccList+"]}";
			 
			 HttpHeaders headers = new HttpHeaders();
			 headers.set("Content-Type", "application/json");
			 headers.set("Authorization", apiToken ); // API사용신청시 부여받은 토큰
			 headers.setContentType(MediaType.APPLICATION_JSON_UTF8);
			 
			 HttpEntity<String> request = new HttpEntity<>(requestBody, headers);
			 
			 RestTemplate rt = new RestTemplate();
			 ResponseEntity<String> response = rt.exchange(skGlobalVal.SK_MAIL_SERVER, HttpMethod.POST, request, String.class);
			 
			// HTTP POST 요청에 대한 응답 확인
			 System.out.println("status : " + response.getStatusCode());
			 System.out.println("body : " + response.getBody());
			 
			 returnMap.put("type", "SUCESS");
			 
		}catch(Exception ex){
			returnMap.put("type", "FAILE");
			returnMap.put("msg", ex.toString());
			System.out.println("SEND MAP ::: " + cmmEmailMap.toString());
			System.out.println("SEND EMAIL FAILE ::: "+ex.getMessage());						
		}
		return returnMap;
	}
}
