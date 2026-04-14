package xbolt.custom.daelim.api;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;

//import com.rathontech2018.sso.sp.agent.web.WebAgent;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

@RestController // Controller 라는 것을 명시 @Controller + @RequestBody
@RequestMapping("/olmapi/")
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class DLMAPIActionController extends XboltController {

	@Autowired
	@Qualifier("commonService")
	private CommonService commonService;

	/**
	 * zDLm 전자 결재 양식 조회
	 * 
	 * @param sKey http://localhost/olmapi/custom/dlm/getAprvXml?PID=5F96388940DD4E7FB7FA52CA77905441
	 *             https://weclickdev.daelim.co.kr/olmapi/custom/dlm/getAprvXml?PID=5F96388940DD4E7FB7FA52CA77905441
	 *             https://weclick.daelim.co.kr/olmapi/custom/dlm/getAprvXml
	 */
	@RequestMapping(value="custom/dlm/getAprvXml", method=RequestMethod.POST, produces="application/xml;charset=utf-8")
	//@ResponseBody
	public void getAprvXml(HttpServletRequest request,HttpServletResponse response) throws Exception {	
		
		System.out.println("========== makeXML getAprvXml ==========");
		String skey = request.getParameter("sKeys");
		String pid = request.getParameter("PID");
		System.out.println("skey :"+skey+" , pid :"+pid);
		
		
		
		 Map<String, String[]> parameterMap = request.getParameterMap();
		    for (Map.Entry<String, String[]> entry : parameterMap.entrySet()) {
		        String paramName = entry.getKey();
		        String[] paramValues = entry.getValue();
		        
		        // 파라미터 이름과 값 출력 (값이 여러 개일 수 있으므로 배열로 출력)
		        System.out.print("Parameter Name: " + paramName + " | ");
		        System.out.print("Parameter Values: ");
		        for (String value : paramValues) {
		            System.out.print(value + " ");
		        }
		        System.out.println();
		    }
		
		String resMsg = "S";
		String xml = "";
		//String docType = "";
		//ApproveFormVO vo = new ApproveFormVO();
		
		//vo.setsKey(skey);
		//vo.setPid(pid);
		try {
			
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> GETXML_STR_DATE UPDATE
			// 통합그룹웨어에서 makexml 전문 별도 호출 시점 : aproveFormDAO.updateGetXmlStrDate
			//approveFormService.updateGetXmlStrDateMapp(vo);
			
			// 전송 받은 정보를 기반으로 전자 결재 INTF_APPROVE_MAPP 테이블에 저장
			// approveFormService.updateApproveMapp(vo);
			
			// 전송 받은 정보로 xml을 작성함
			// xml = approveFormService.getApproveXmlBySkey(vo);
			
			
			
			Map setData = new HashMap();
			
			setData.put("WFInstanceID", skey);
			setData.put("languageID", "1042");
			Map wfInstInfo = (Map)commonService.select("wf_SQL.getWFINSTanceInfo", setData);
			
			String activityLogID = StringUtil.checkNull(wfInstInfo.get("DocumentID"));
			String srCode = StringUtil.checkNull(wfInstInfo.get("DocumentNo"));
			
			setData.put("srCode", srCode);			
			String srID = StringUtil.checkNull(commonService.selectString("esm_SQL.getSRID", setData));
			
			setData.put("srID", srID);
			setData.put("activityLogID",activityLogID);
			setData.put("languageID", 1042);
			Map activityInfo = (Map)commonService.select("esm_SQL.getESMProLogInfo_gridList", setData);
			
			String srType = "";
			if(!activityInfo.isEmpty()) {
				srType = StringUtil.checkNull(activityInfo.get("SRType"));
			}
			if(srType.equals("")) srType ="ACM";
			
			String rcptSpeCode = srType+"0002";
			setData.put("speCode", rcptSpeCode); // 중요성검토 log 			
			setData.remove("activityLogID");
			Map activityInfoACM0002 = (Map)commonService.select("esm_SQL.getESMProLogInfo_gridList", setData);
			
			setData.put("srID", srID);
			Map srInfo = commonService.select("esm_SQL.getESMSRInfo", setData); 
			
			//========================================
			// APV_ADDINFO  파라미터 설정 
			String clientID = StringUtil.checkNull(srInfo.get("ClientID"));  // DL 케미칼 : 0000000007
			String SRArea1 =  StringUtil.checkNull(srInfo.get("SRArea1"));   // 서비스
			String SRArea2 =  StringUtil.checkNull(srInfo.get("SRArea2"));   // 파트
			String APV_ADDINFO = "";
			if("0000000007".equals(clientID) && "101740".equals(SRArea1) && "102738".equals(SRArea2) && "ACM".equals(srType) && !"ACM0010".equals(StringUtil.checkNull(srInfo.get("Status")))) {
				APV_ADDINFO = "Y";				
			}
			//========================================
			
			// SR ATTR
			setData.put("speCode", StringUtil.checkNull(srInfo.get("Status")));
			setData.put("srType", StringUtil.checkNull(srInfo.get("SRType")));
			setData.put("docCategory", "SR");
			
			List srAttrList = (List)commonService.selectList("esm_SQL.getSRAttr", setData);
			
			setData.put("speCode", rcptSpeCode); 
			List srAttrListACM0005 = (List)commonService.selectList("esm_SQL.getSRAttr", setData); // 변경계획수립 의견  SR_ATTR
			
			
			setData.put("speCode", "ACM00010"); 
			List srAttrListSRAT0109 = (List)commonService.selectList("esm_SQL.getSRAttr", setData); // 변경적용요청 전달사항 SR_ATTR
			
			// 두 리스트를 합칠 새로운 리스트 생성
			List<Map<String, Object>> srAttrAllList = new ArrayList<>();

			if (srAttrList != null) {
				srAttrAllList.addAll(srAttrList);
			}
			if (srAttrListACM0005 != null) {
				srAttrAllList.addAll(srAttrListACM0005);
			}
			if (srAttrListSRAT0109 != null) {
				srAttrAllList.addAll(srAttrListSRAT0109);
			}
			
			String SRAT0004 = ""; // 중요도 
			//String SRAT0005 = ""; // 접수자의견 
			String SRAT0006 = ""; // 분석결과  
			String SRAT0015 = ""; // 투입인력
			String SRAT0016 = ""; // 변경계획개요
			String SRAT0017 = ""; // 전달사항 : 변경계획수립
			String SRAT0109 = ""; // 전달사항 : 변경적용요청
			
			String SRAT0037 = ""; // 적용희망일
			if(srAttrAllList.size()>0) {
				for(int i=0; i<srAttrAllList.size(); i++) {					
					Map srAttrInfo = (Map)srAttrAllList.get(i);
					String AttrTypeCode = StringUtil.checkNull(srAttrInfo.get("AttrTypeCode"));
					if(AttrTypeCode.equals("SRAT0004")) {
						SRAT0004 = removeSpecialCharacters(StringUtil.checkNull(srAttrInfo.get("PlainText"))); // 중요도
					}else if(AttrTypeCode.equals("SRAT0006")) {
						SRAT0006 = removeSpecialCharacters(StringUtil.checkNull(srAttrInfo.get("PlainText"))); // 분석결고 
					}else if(AttrTypeCode.equals("SRAT0015")) {
						SRAT0015 = removeSpecialCharacters(StringUtil.checkNull(srAttrInfo.get("PlainText"))); // 투입인력
					}else if(AttrTypeCode.equals("SRAT0016")) {
						SRAT0016 = removeSpecialCharacters(StringUtil.checkNull(srAttrInfo.get("PlainText"))); // 변경계획개요
					}else if(AttrTypeCode.equals("SRAT0017")) {
						SRAT0017 = removeSpecialCharacters(StringUtil.checkNull(srAttrInfo.get("PlainText"))); // 전달사항
					}else if(AttrTypeCode.equals("SRAT0037")) {
						SRAT0037 = removeSpecialCharacters(StringUtil.checkNull(srAttrInfo.get("PlainText"))); // 적용희망일
					}else if(AttrTypeCode.equals("SRAT0109")) {
						SRAT0109 = removeSpecialCharacters(StringUtil.checkNull(srAttrInfo.get("PlainText"))); // 전달사항 : 변경적용요청
					}
				}
			}
			
			String docType = "1";
			
			if(StringUtil.checkNull(srInfo.get("Status")).equals("ACM0010")) // AP 변경적용용청 
				docType = "2";
			// 첨부문서 
			setData.remove("speCode");
			List activityFileList = commonService.selectList("esm_SQL.espFile_gridList", setData);
			String OLM_SERVER_URL =  StringUtil.checkNull(GlobalVal.OLM_SERVER_URL);
			
			String dsCatType = StringUtil.checkNull(srInfo.get("CategoryName")) +"/"+ StringUtil.checkNull(srInfo.get("SubCategoryName"));
			if(StringUtil.checkNull(srInfo.get("SRType")).equals("ICM")) {
				dsCatType = "인프라 변경";
			} else if(StringUtil.checkNull(srInfo.get("SRType")).equals("SCM")) {
				dsCatType = "보안 변경";
			}
		
			if(!"ACM0010".equals(StringUtil.checkNull(activityInfo.get("speCode"))) ){ // 요청부서 결재 요청(WF_FORM_ECLICK) XML   // 전자 결재 종류 1. 요청부서 승인 , 2. 변경 승인 요청
				
				xml = "<?xml version=\"1.0\" encoding=\"euc-kr\"?>"
						+"<DataSet>"
						// 요청정보
						+"<DS_TICKETID><![CDATA["+ srCode +"]]></DS_TICKETID>"
						+"<DS_TITLE><![CDATA["+ StringUtil.checkNull(srInfo.get("Subject")) +"]]></DS_TITLE>"
						+"<DS_REQUEST><![CDATA["+ StringUtil.checkNull(srInfo.get("ReqUserNM")) +"]]></DS_REQUEST>"           // 요청자
						+"<DS_REQUESTTYPE><![CDATA["+ StringUtil.checkNull(srInfo.get("ReqTeamNM")) +"]]></DS_REQUESTTYPE>"   // 요청부서
						+"<DS_CINAME><![CDATA["+ StringUtil.checkNull(srInfo.get("SRArea1Name")) +"/"+ StringUtil.checkNull(srInfo.get("SRArea2Name")) +"]]></DS_CINAME>" // 대상서비스 이름(서비스/파트)
						+"<DS_CATTYPE><![CDATA["+ dsCatType +"]]></DS_CATTYPE>" // 의뢰유형(Category/SubCategory)
						+"<DT_FINISHPLAN><![CDATA["+ StringUtil.checkNull(srInfo.get("ReqDueDate")) +"]]></DT_FINISHPLAN>"    // 완료요청일
						
						+"<DS_REQUESTOPIN><![CDATA["+ removeSpecialCharacters(StringUtil.checkNull(srInfo.get("Description"))) +"]]></DS_REQUESTOPIN>"    // 요청내용본문
						
						// 요청 분석 정보 => 중요성 검토 
						+"<DS_CUSTOMER><![CDATA["+ StringUtil.checkNull(activityInfoACM0002.get("TeamName")) +"/" + StringUtil.checkNull(activityInfoACM0002.get("ActorName")) +"]]></DS_CUSTOMER>" // 중요성검토 담당자  RCPT_USER_ID
						+"<DS_IMPORT><![CDATA["+ SRAT0004  +"]]></DS_IMPORT>" // 중요도 SRAT0004
						+"<DS_OPINION><![CDATA["+ SRAT0006 +"]]></DS_OPINION>" // 분서결과  SRAT0006
						
						// 변경 계획 정보
						+"<DS_PLANUSER><![CDATA["+ StringUtil.checkNull(activityInfo.get("TeamName")) + "/" + StringUtil.checkNull(activityInfo.get("ActorName")) +"]]></DS_PLANUSER>" // 변경계획 담당자 
						+"<DS_MANPLAN><![CDATA["+ SRAT0015 +"]]></DS_MANPLAN>" // 투입인력
						+"<DS_PLANOPIN><![CDATA["+ SRAT0016 +"]]></DS_PLANOPIN>"  // 변경계획 개요
						+"<DS_PLANDATE><![CDATA["+ StringUtil.checkNull(srInfo.get("DueDate")) +"]]></DS_PLANDATE>" // 완료예정일
						+"<DS_PROPA><![CDATA["+ SRAT0017 +"]]></DS_PROPA>" // 전달사항
						
						// 1. 요청회사 DL 케미컬 && 2. 서비스/파트가  : 안전환경(DAC) > 안전환경_D-HSE && 3.AP 변경 and 요청 부서 결재 
				        +"<APV_ADDINFO><![CDATA["+ APV_ADDINFO +"]]></APV_ADDINFO>"; //
				
				// <a href="http://localhost/custom/zDlm_InboundLink.do?olmLoginid=guest&object=file&linkID=39&linkType=fileID&languageID=1042"
				for (int i = 0 ; activityFileList.size()>i ; i++){
					HashMap map = (HashMap)activityFileList.get(i);
					
					xml	+="<OUT_FILELIST>";
					//xml += "<DS_DOMAIN><![CDATA["+OLM_SERVER_URL+"/custom/zDlm_InboundLink.do?object=file&linkID="+ map.get("Seq") +"&linkType=fileID&languageID=1042]]></DS_DOMAIN>";	
					xml += "<DS_DOMAIN><![CDATA["+OLM_SERVER_URL+"/custom/zDlm_InboundLink.do?linkID=]]></DS_DOMAIN>";	
					xml += "<DS_FILEID><![CDATA["+ StringUtil.checkNull(map.get("Seq")) +"]]></DS_FILEID>";
					xml += "<DS_FILESEQ><![CDATA["+ StringUtil.checkNull(map.get("Seq")) +"]]></DS_FILESEQ>";
					xml += "<DS_FILENAME><![CDATA["+ StringUtil.checkNull(map.get("FileRealName"))+"]]></DS_FILENAME>";
					xml += "</OUT_FILELIST> ";
				}	
					xml = xml	+"</DataSet>";
				
			}else{
			
				xml = "<?xml version=\"1.0\" encoding=\"euc-kr\"?>"
						+"<DataSet>"
						// 요청정보
						+"<DS_TICKETID><![CDATA["+ srCode +"]]></DS_TICKETID>"
						+"<DS_TITLE><![CDATA["+ StringUtil.checkNull(srInfo.get("Subject")) +"]]></DS_TITLE>"
						+"<DS_REQUEST><![CDATA["+ StringUtil.checkNull(srInfo.get("ReqUserNM")) +"]]></DS_REQUEST>"           // 요청자
						+"<DS_REQUESTTYPE><![CDATA["+ StringUtil.checkNull(srInfo.get("ReqTeamNM")) +"]]></DS_REQUESTTYPE>"   // 요청부서
						+"<DS_CINAME><![CDATA["+ StringUtil.checkNull(srInfo.get("SRArea1Name")) +"/"+ StringUtil.checkNull(srInfo.get("SRArea2Name")) +"]]></DS_CINAME>"          // 대상서비스 이름(서비스/파트)
						+"<DS_CATTYPE><![CDATA["+ dsCatType +"]]></DS_CATTYPE>" // 의뢰유형(Category/SubCategory)
						+"<DT_FINISHPLAN><![CDATA["+ StringUtil.checkNull(srInfo.get("ReqDueDate")) +"]]></DT_FINISHPLAN>"    // 
						
						+"<DS_REQUESTOPIN><![CDATA["+ removeSpecialCharacters(StringUtil.checkNull(srInfo.get("Description"))) +"]]></DS_REQUESTOPIN>"    // 요청내용본문
						
						// 요청 분석 정보 => 중요성 검토 
						+"<DS_CUSTOMER><![CDATA["+ StringUtil.checkNull(activityInfoACM0002.get("TeamName")) +"/" + StringUtil.checkNull(activityInfoACM0002.get("ActorName")) +"]]></DS_CUSTOMER>" // 중요성검토 담당자  RCPT_USER_ID
						+"<DS_IMPORT><![CDATA["+ SRAT0004  +"]]></DS_IMPORT>" // 중요도 SRAT0004
						+"<DS_OPINION><![CDATA["+ SRAT0006+"]]></DS_OPINION>" // 분석결과 SRAT0006
						
						// 배포계획정보
						+"<DS_RELEASE_USER><![CDATA["+ StringUtil.checkNull(activityInfo.get("TeamName")) + "/" + StringUtil.checkNull(activityInfo.get("ActorName")) + "]]></DS_RELEASE_USER>" //담당자
						+"<DS_RELEASE_DATE><![CDATA["+ SRAT0037 +"]]></DS_RELEASE_DATE>" // 적용희망일
						+"<DS_RELEASE_OPIN><![CDATA["+ SRAT0109 +"]]></DS_RELEASE_OPIN>" // 적용요청 전달 사항 : 번경적용요청
						+"</DataSet>";
				
			}
			
			 
			 System.out.println("makeXML 결과::>> "+ xml);
			 
			if (xml.isEmpty()){
				resMsg= "F";
				new Exception(" 전자 결재 양식이 작성되지 않음");
			}
			
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> GETXML_END_DATE UPDATE
			// 통합그룹웨어에서 makexml 전문 별도 호출 시점 : aproveFormDAO.updateGetXmlEndDate
			//vo.setGetxmlMsg(xml);
			//approveFormService.updateGetXmlEndDateMapp(vo);
			
		 
		} catch(Exception e) {
			resMsg= "F";
			e.printStackTrace();
		}
	
		// Map을 사용하여 XML과 ReturnCode를 JSON 형식으로 저장
        Map<String, String> responseMap = new HashMap<>();
        
        responseMap.put("XML", xml);           // xml 값 그대로 추가
        responseMap.put("ReturnCode", resMsg); // resMsg 값 그대로 추가

        // ObjectMapper를 사용하여 Map을 JSON으로 변환
        ObjectMapper objectMapper = new ObjectMapper();
        String jsonResponse = objectMapper.writeValueAsString(responseMap);
        System.out.println("본문 :::"+jsonResponse);
        // JSON 응답을 반환
  
        response.setHeader("Cache-Control", "no-cache");
	    response.setContentType("text/plain");
	    response.setCharacterEncoding("UTF-8");
	    
	    response.getWriter().print(jsonResponse);
        
	}
	
	// 특수문자 제거 메서드
    public static String removeSpecialCharacters(String input) {
        // 알파벳, 숫자, 공백만 허용하고 나머지 문자는 모두 제거
       // return input.replaceAll("[^a-zA-Z0-9ㄱ-ㅎㅏ-ㅣ가-힣\\s]", "");
    	
    	return input.replaceAll("[\\n\\r\\t\\f\\v]+", "<br>"); // 줄바꿈 문자 포함시 오푸때문에 추가한거임
    	
    }
}