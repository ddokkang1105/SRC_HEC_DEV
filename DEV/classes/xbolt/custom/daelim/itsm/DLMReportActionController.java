package xbolt.custom.daelim.itsm ;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.TransactionTimedOutException;
import org.springframework.transaction.UnexpectedRollbackException;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;

import com.google.gson.Gson;
import com.org.json.JSONArray;
import com.org.json.JSONObject;

import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.service.CommonService;

/**
 * 공통 서블릿 처리
 * @Class Name : DLMReportActionController.java
 * @Description : 공통화면을 제공한다.
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @since 2024. 12. 13. smartfactory		최초생성
 *
 * @since 2024. 12. 13.
 * @version 1.0
 * @see
 * 
 * Copyright (C) 2024 by SMARTFACTORY All right reserved.
 */

@Controller
@SuppressWarnings("unchecked")
public class DLMReportActionController extends XboltController{
	
	@Resource(name = "commonService")
	private CommonService commonService;

	@RequestMapping(value = "/zdlm_processStatisticsReport.do")
	public String zdlm_processStatisticsReport(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		
		try {
			model.put("menu", getLabel(request, commonService)); 
			
			String customerNo = StringUtil.checkNull(commandMap.get("customerNo"));
			
			if("".equals(customerNo)){
				customerNo = StringUtil.checkNull(commonService.selectString("user_SQL.userClientID", commandMap));
			}
			model.put("customerNo", customerNo);
			
			
		} catch (Exception e) {
			System.out.println(e.getMessage());
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/custom/daelim/itsm/report/zdlm_processStatisticsReport");
	}
	
	@RequestMapping(value = "/zdlm_mhStatisticsReport.do")
	public String zdlm_mhStatisticsReport(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		
		try {
			model.put("menu", getLabel(request, commonService)); 
			
		} catch (Exception e) {
			System.out.println(e.getMessage());
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/custom/daelim/itsm/report/zdlm_mhStatisticsReport");
	}
	
	@RequestMapping(value = "/zdlm_mhTypeStatisticsReport.do")
	public String zdlm_mhTypeStatisticsReport(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		
		try {
			model.put("menu", getLabel(request, commonService)); 
			
		} catch (Exception e) {
			System.out.println(e.getMessage());
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/custom/daelim/itsm/report/zdlm_mhTypeStatisticsReport");
	}
	
	@RequestMapping(value = "/zdlm_viewIndividualMHWorkList.do")
	public String zdlm_viewIndividualMHWorkList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		try {
			model.put("menu", getLabel(request, commonService)); 

			model.put("customerNo", StringUtil.checkNull(commandMap.get("customerNo")));
			model.put("startDate", StringUtil.checkNull(commandMap.get("startDate")));
			model.put("endDate", StringUtil.checkNull(commandMap.get("endDate")));
			model.put("memberID", StringUtil.checkNull(commandMap.get("memberID")));
			model.put("memberName", StringUtil.checkNull(commandMap.get("memberName")));
			model.put("srArea2", StringUtil.checkNull(commandMap.get("srArea2")));
		} catch (Exception e) {
			System.out.println(e.getMessage());
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/custom/daelim/itsm/report/zdlm_viewIndividualMHWorkList");
	}
	
	@RequestMapping(value = "/zdlm_subsidiaryTotalReport.do")
	public String zdlm_subsidiaryTotalReport(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		
		try {
			model.put("menu", getLabel(request, commonService)); 
			
		} catch (Exception e) {
			System.out.println(e.getMessage());
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/custom/daelim/itsm/report/zdlm_subsidiaryTotalReport");
	}
	
	@RequestMapping(value = "/zdlm_StatisticsOfAcceptanceAndFirstResolutionRat.do")
	public String zdlm_StatisticsOfAcceptanceAndFirstResolutionRat(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		
		try {
			model.put("menu", getLabel(request, commonService)); 
			
		} catch (Exception e) {
			System.out.println(e.getMessage());
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/custom/daelim/itsm/report/zdlm_StatisticsOfAcceptanceAndFirstResolutionRat");
	}
	
	@RequestMapping(value = "/zdlm_customerSatisfaction.do")
	public String zdlm_customerSatisfaction(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		
		try {
			model.put("menu", getLabel(request, commonService)); 
			
		} catch (Exception e) {
			System.out.println(e.getMessage());
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/custom/daelim/itsm/report/zdlm_customerSatisfaction");
	}
	
	@RequestMapping(value = "/zdlm_reqStatReport.do")
	public String zdlm_reqStatReport(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		
		try {
			model.put("menu", getLabel(request, commonService)); 
			
		} catch (Exception e) {
			System.out.println(e.getMessage());
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/custom/daelim/itsm/report/zdlm_reqStatReport");
	}
	
	@RequestMapping(value = "/zdlm_jsonDhtmlxListV7.do")
	public void zdlm_jsonDhtmlxListV7(HashMap cmmMap, HttpServletResponse response)  throws Exception {
		try {			
			String SQL_CODE = getString(cmmMap.get("sqlID"), "commonCode");	
					
			String tFilterCode = StringUtil.checkNull(cmmMap.get("tFilterCode"));
			String sqlGridList = StringUtil.checkNull(cmmMap.get("sqlGridList"));
			System.out.println("jsonDhtmlxListV7 cmmMap :"+cmmMap);
			if(!"".equals(tFilterCode)) {
				SQL_CODE=StringUtil.checkNull(commonService.selectString("menu_SQL.getSqlNameForTfilterCode", cmmMap));
			}
			
			String sqlCode = "";
			if(sqlGridList.equals("N")) sqlCode = SQL_CODE; else sqlCode = SQL_CODE+SQL_GRID_LIST;
			List <Map>result = commonService.selectList(sqlCode, cmmMap);
			
			for (int i = 0; i < result.size(); i++) {
	            Map<String, Object> row = result.get(i);

	            if ("전월 대비 증감률".equals(row.get("conDate"))) {
	                // "전월 대비 증감률" 항목은 소수점 둘째자리까지 설정
	                row.put("firstCompRate", formatDecimal(row.get("firstCompRate")));
	                row.put("userCnt", formatDecimal(row.get("userCnt")));
	                row.put("callPerUserRate", formatDecimal(row.get("callPerUserRate")));
	                row.put("eClickCnt", formatDecimal(row.get("eClickCnt")));
	                row.put("callCnt", formatDecimal(row.get("callCnt")));
	                row.put("dayCnt", formatDecimal(row.get("dayCnt")));
	            } else {
	                for (String key : row.keySet()) {
	                	if (!"conDate".equals(key)) {
		                    if (key.toLowerCase().contains("rate")) {
		                        // 'Rate'가 포함된 컬럼은 소수점 둘째자리까지 설정
		                        row.put(key, formatDecimal(row.get(key)));
		                    } else {
		                        // 나머지 컬럼은 정수로 변환
		                    	 row.put(key, formatDecimalRemove(row.get(key)));
		                    }
	                	}
	                }
	            }
	        }
			System.out.println("result :"+result);
			JSONArray resultJosnList = new JSONArray(result);
			zdlm_sendToJsonV7(StringUtil.checkNull(resultJosnList), response);
		} catch (Exception e) {
			System.out.println(e.toString());
		}
	}
	
	public static void zdlm_sendToJsonV7(String jObj, HttpServletResponse res) {
		try {
			res.setHeader("Cache-Control", "no-cache");
			res.setContentType("text/plain");
			res.setCharacterEncoding("UTF-8");
			if(!jObj.equals("{rows: [ ]}")){
				res.getWriter().print(jObj);
			}
			else {
				PrintWriter pw = res.getWriter();
				pw.write("데이터가 존재하지 않습니다.");
			}			
		} catch (IOException e) {
			MessageHandler.getMessage("json.send.message");
			e.printStackTrace();
		}
	}
	

    // 소수점 둘째자리로 포맷팅
    private static String formatDecimal(Object value) {
        if (value == null) return "0.00";
        try {
            BigDecimal bd = new BigDecimal(value.toString());
            return bd.setScale(2, BigDecimal.ROUND_HALF_UP).toString();
        } catch (NumberFormatException e) {
            return "0.00";
        }
    }

    // 정수로 변환
    private static Integer formatInteger(Object value) {
        if (value == null) return 0;
        try {
            return Integer.parseInt(value.toString());
        } catch (NumberFormatException e) {
            return 0;
        }
    }
    
    private static Object formatDecimalRemove(Object value) {
        if (value == null || "".equals(value.toString())) return 0;  // null이나 빈 문자열은 0
        
        try {
            // 숫자형으로 변환
            double number = Double.parseDouble(value.toString());

            // 소수점 이하 제거 (단순히 잘라냄)
            return Math.floor(number); // or Math.trunc(number);
        } catch (NumberFormatException e) {
            return 0;  // 형식 오류 발생 시 0 반환
        }
    }
	
    @RequestMapping(value="/zdlm_test_exceldown.do")
    public String zdlm_test_exceldown(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception{
    	HashMap target = new HashMap();
		HashMap setMap = new HashMap();
		FileOutputStream fileOutput = null;
    	try{
    		String fileName = "MhStat";
    		List tabList = new ArrayList();
    		List headerList = new ArrayList();
    		List contentList = new ArrayList();
    		
    		// 탭 설정
    		tabList.add("사용자 정보");
    		tabList.add("산출물 목록");
    		
    		// 헤더 설정
    		Map header1 = new HashMap();
    		header1.put("RNUM", "No");
    		header1.put("LoginID", "아이디");
    		header1.put("TeamID", "부서");
    		header1.put("UserNAME", "사용자이름");
    		headerList.add(header1);
    		
    		Map header2 = new HashMap();
    		header2.put("RNUM", "No");
    		header2.put("SRCode", "티켓 No.");
    		header2.put("Subject", "제목");
    		header2.put("SpeCodeNM", "상태");
    		header2.put("FltpNM", "분류");
    		header2.put("FileRealName", "파일명");
    		headerList.add(header2);
    		
    		// content 설정
    		setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
    		setMap.put("authority", "EDITOR");
    		List userList = commonService.selectList("user_SQL.userList_gridList", setMap);
    		contentList.add(userList);
    		
    		List fileList = commonService.selectList("esm_SQL.espFile_gridList", setMap);
    		contentList.add(fileList);
    		
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			long date = System.currentTimeMillis();
			
			fileName = fileName + "_" + formatter.format(date);
    		
    		makeExcelFile(tabList, headerList, contentList, fileName);
			
    		target.put(AJAX_SCRIPT, "doFileDown('"+fileName+".xlsx"+"', 'excel');$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		} finally {
			if(fileOutput != null) fileOutput.close();
		}
    	model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);	
    }
    
    // ITSM 프로세스 통합검색 다운로드 (미사용)
    @Transactional(timeout = 15)
    @RequestMapping(value="/zdlm_list_exceldown.do")
    public String zdlm_list_exceldown(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception{
    	HashMap target = new HashMap();
		HashMap setMap = new HashMap();
		//FileOutputStream fileOutput = null;
    	try{
    		String fileName = StringUtil.checkNull(commandMap.get("fileName"));
    		List tabList = new ArrayList();
    		List headerList = new ArrayList();
    		List contentList = new ArrayList();
    		
			// 전체 탭 설정
    		tabList.add("1.프로세스 상세 ");
    		tabList.add("2.프로세스 집계 ");
    		
    		// 헤더 설정
    		Map<String, String> header1 = new LinkedHashMap<>();
    		header1.put("RNUM", "No");
    		header1.put("SRTypeNM", "프로세스");
    		header1.put("SRCode", "티켓 ID");
    		header1.put("Subject", "제목");
    		header1.put("SRArea1Name", "서비스");
    		header1.put("SRArea2Name", "파트");
    		header1.put("CategoryNM", "의뢰 유형");
    		header1.put("SubCategoryNM", "하위 의뢰 유형");
    		header1.put("RegDate", "등록일");
    		header1.put("RegUserName", "등록자");
    		header1.put("ResponseInfo", "상담원");
    		header1.put("ReceiptInfo", "IT담당자");
    		header1.put("StatusName", "현재 Actitity");
    		header1.put("RequestInfo", "요청자(요청조직)");
    		header1.put("ReqDueDate", "고객완료희망일");
    		header1.put("SRDueDate", "티켓 완료예정일");
    		header1.put("CompletionStatus", "완료여부");
    		header1.put("delayDay", "지연일수");
    		header1.put("APPINFRA", "서비스유형");
    		header1.put("SRAT0002", "긴급여부");
    		headerList.add(header1);
    		
    		List list1 = commonService.selectList("esm_SQL.getESPSearchExcelList_gridList", commandMap);
    		contentList.add(list1);
    		
    		// 헤더 설정
    		Map<String, String> header2 = new LinkedHashMap<>();
    		header2.put("Name", "관계사");
    		header2.put("ACM", "AP변경");
    		header2.put("DCM", "데이터변경");
    		header2.put("ICM", "인프라변경");
    		header2.put("SCM", "보안변경");
    		header2.put("DPL", "배포");
    		header2.put("WRK1", "내부요청");
    		header2.put("WRK2", "작업");
    		header2.put("REQ1", "서비스요청");
    		header2.put("REQ2", "서비스요청(단순문의)");
    		headerList.add(header2);
    		
    		List list2 = commonService.selectList("zDLM_SQL.getESPSearchExcelTotalList", commandMap);
    		contentList.add(list2);
    		
    		File file = makeExcelFile(tabList, headerList, contentList, fileName);
			pushFile(file, response);
			
    		target.put(AJAX_SCRIPT, "parent.$('#loading').fadeOut(150);");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		} finally {
			//if(fileOutput != null) fileOutput.close();
		}
    	model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
    }
    
    // ITSM 프로세스 통합검색 다운로드 ( process 별 )
    @Transactional(timeout = 120)
    @RequestMapping(value="/zdlm_list_exceldown_srType.do")
    public void zdlm_list_exceldown_srType(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception{
    	
    	response.setHeader("Cache-Control", "no-cache");
		response.setContentType("text/plain");
		response.setCharacterEncoding("UTF-8");
		
    	HashMap target = new HashMap();
		HashMap setMap = new HashMap();
    	try{
    		
			String srType = StringUtil.checkNull(commandMap.get("srType"));
			
			// 공통 header insert
			LinkedHashMap<String, String> header1 = new LinkedHashMap<>();
			
			header1.put("RNUM", "No");
    		header1.put("SRCode", "티켓 ID");
    		header1.put("CompanyCode", "회사 ID");
    		header1.put("CompanyName", "회사이름");
    		
    		header1.put("StatusName", "현재 Actitity");
    		
    		header1.put("RegDate", "등록일");
    		header1.put("RegUserLoginID", "등록자 ID");
    		header1.put("RegUserName", "등록자");
    		header1.put("RegTeamCode", "등록자 부서 코드");
    		header1.put("RegTeamName", "등록자 부서 이름");
    		
    		header1.put("ReqUserLoginID", "요청자 ID");
    		header1.put("ReqUserNM", "요청자");
    		header1.put("ReqTeamCode", "요청자 부서 코드");
    		header1.put("ReqTeamNM", "요청자 부서 이름");
    		header1.put("ReqCompanyName", "요청자 소속회사 이름");
    		
    		header1.put("ReceiptUserLoginID", "처리자 ID");
    		header1.put("ReceiptName", "처리자");
    		header1.put("ReceiptTeamCode", "처리자 부서 코드");
    		header1.put("ReceiptTeamName", "처리자 부서 이름");
    		header1.put("ProcRoleTypeName", "처리자 그룹 이름");
    		
    		header1.put("SRArea1Code", "서비스 ID");
    		header1.put("SRArea1Name", "서비스");
    		header1.put("SRArea2Code", "파트 ID");
    		header1.put("SRArea2Name", "파트");
    		
    		header1.put("Category", "의뢰 유형 ID");
    		header1.put("CategoryNM", "의뢰 유형");
    		header1.put("SubCategory", "하위 의뢰 유형 ID");
    		header1.put("SubCategoryNM", "하위 의뢰 유형");
    		
    		header1.put("Subject", "제목");
    		header1.put("Description", "내용");
    		
    		header1.put("ReqDueDate", "고객완료희망일");
    		header1.put("SRDueDate", "티켓 완료예정일");
    		header1.put("APPINFRA", "서비스유형");
    		
    		List<Map<String, Object>> list1 = commonService.selectList("esm_SQL.getESPSearchExcelList_gridList", commandMap);
    		
    		// 타입별 header List 추출
    		List<Map<String, String>> headerTypeList = commonService.selectList("zDLM_SQL.getESPSearchExcelHeaderList", commandMap);
    		
    		for (Map<String, String> item : headerTypeList) {
                String key =  StringUtil.checkNull(item.get("HeaderKey"));
                String name = StringUtil.checkNull(item.get("HeaderName"));

                if (!"".equals(key) && !"".equals(name)) {
                	header1.put(key, name);
                }
            }
    		
    		header1.put("ZSPE00_EVAT001", "만족도평가1");
    		header1.put("ZSPE00_EVAT002", "만족도평가2");
    		header1.put("ZSPE00_EVAT003", "만족도평가3");
    		
    		// 타입별 값 추출
            Map<String, Map<String, Object>> cmmList = new HashMap<>();
            List srIdList = new ArrayList();
            
            for (Map<String, Object> record : list1) {
            	cmmList.put(StringUtil.checkNull(record.get("SRID")), record);
            	srIdList.add(StringUtil.checkNull(record.get("SRID")));
            }
            
            // cmmList에 머지 ( 900건으로 끊어서 실행 )
            int batchSize = 900;
            List<Map<String, Object>> list = new ArrayList();
            for (int i = 0; i < srIdList.size(); i += batchSize) {
                int end = Math.min(i + batchSize, srIdList.size());
                List<Long> batch = srIdList.subList(i, end);
                
                commandMap.put("srIdList", batch);
                List<Map<String, Object>> list_temp = commonService.selectList("zDLM_SQL.getESPSearchExcelSubList", commandMap);
                list.addAll(list_temp);
            }
            
            for (Map<String, Object> bRow : list) {
                String srID = StringUtil.checkNull(bRow.get("SRID"));
                String headerKey = StringUtil.checkNull(bRow.get("HeaderKey"));
                String value = StringUtil.checkNull(bRow.get("Value"));

                if (cmmList.containsKey(srID)) {
                	cmmList.get(srID).put(headerKey, value);
                }
            }
	            
	        Map result = new HashMap(); 
	        
	        result.put("header", header1);
	        result.put("data", list1);
    		
			Gson gson = new Gson();
			String jsonOutput = gson.toJson(result);
			
			response.setContentType("application/json; charset=UTF-8");
			response.getWriter().write(jsonOutput);
    		
		} catch (Exception e) {
			System.out.println(e);
	        Map rs = new HashMap();
	        rs.put("error", e);
	        
	        Gson gson = new Gson();
	        String jsonOutput = gson.toJson(rs);
	        response.setContentType("application/json; charset=UTF-8");
	        response.getWriter().write(jsonOutput);
		}
    	
    }
    
    
    
    public File makeExcelFile(List tabList, List headerList, List contentList, String fileName) throws Exception {
        try {
			File file = new File( FileUtil.FILE_EXPORT_DIR + "/" + fileName + ".xlsx");
			FileOutputStream fop = new FileOutputStream(file);
						
			// 엑셀 생성
			XSSFWorkbook wb = new XSSFWorkbook();
			XSSFCellStyle headerStyle = setCellHeaderStyle(wb);
			XSSFCellStyle contentsStyle = setCellContentsStyle(wb, "");
		
			for(int i=0; i < tabList.size(); i++) {
				XSSFSheet sheet = wb.createSheet(String.valueOf(tabList.get(i)));
				int cellIndex = 0;
				int rowIndex = 0;
				XSSFRow row = sheet.createRow(rowIndex);
	 			XSSFCell cell = row.createCell(0);
				row.setHeight((short) (512 * ((double) 8 / 10 )));
				rowIndex++;
				
				Map content = new HashMap();
				List list = (List) contentList.get(i);
				for (int j=0; j < list.size(); j++) {
					content = (Map) list.get(j);
					Set<String> headerKey = ((Map) headerList.get(i)).keySet();
					
					if(j == 0) {
						for (String key : headerKey) {
							String header = (String) ((Map) headerList.get(i)).get(key);
							if(!header.equals(null)) {
								// 헤더(첫번째 열 칼럼) 세팅
								cell = row.createCell(cellIndex);
								cell.setCellValue(header);
								cell.setCellStyle(headerStyle);
								cellIndex++;
							}
						}
					}
					
					// Data 행 설정
					cellIndex = 0;
					row = sheet.createRow(rowIndex);
					for (String key : headerKey) {
						// 열 너비 제한
						if(sheet.getColumnWidth(cellIndex) > 20000) sheet.setColumnWidth(cellIndex, 20000);
						else sheet.autoSizeColumn(cellIndex);
						cell = row.createCell(cellIndex);
						cell.setCellValue(StringUtil.checkNull(content.get(key),""));
						cell.setCellStyle(contentsStyle);
						cellIndex++;
					}
					rowIndex++;
				}
			}
    		
			wb.write(fop); 
            fop.flush();
            fop.close();
            
	        return file;
        } catch ( Exception e ){
        	System.out.println(e.toString());
        	throw e;
        }
    }
    
    private XSSFCellStyle setCellHeaderStyle(XSSFWorkbook wb) {
		XSSFCellStyle style = wb.createCellStyle();
		
		style.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		style.setBottomBorderColor(IndexedColors.GREY_80_PERCENT.getIndex());
		style.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		style.setLeftBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
		style.setBorderRight(XSSFCellStyle.BORDER_THIN);
		style.setRightBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
		style.setBorderTop(XSSFCellStyle.BORDER_THIN);
		style.setTopBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
		style.setAlignment(HorizontalAlignment.CENTER);
		style.setVerticalAlignment(VerticalAlignment.CENTER);
		
		style.setFillForegroundColor(HSSFColor.PALE_BLUE.index);
		style.setFillBackgroundColor(HSSFColor.PALE_BLUE.index);
		style.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		
		XSSFFont font = wb.createFont();
		font.setFontHeightInPoints((short) 9);
		font.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
		font.setFontName("Arial");
		
		style.setFont(font);
		 
		return style;

	}
	
	private XSSFCellStyle setCellContentsStyle(XSSFWorkbook wb, String color) {
		XSSFCellStyle style = wb.createCellStyle();
		 
		style.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		style.setBottomBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
		style.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		style.setLeftBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
		style.setBorderRight(XSSFCellStyle.BORDER_THIN);
		style.setRightBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
		style.setBorderTop(XSSFCellStyle.BORDER_THIN);
		style.setTopBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
		style.setVerticalAlignment(VerticalAlignment.CENTER);
		
		if(color.equals("LIGHT_BLUE")){
			style.setFillBackgroundColor(HSSFColor.LIGHT_BLUE.index);
			style.setFillForegroundColor(HSSFColor.LIGHT_BLUE.index);
			style.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		}else if(color.equals("LIGHT_CORNFLOWER_BLUE")){
			style.setFillBackgroundColor(HSSFColor.LIGHT_CORNFLOWER_BLUE.index);
			style.setFillForegroundColor(HSSFColor.LIGHT_CORNFLOWER_BLUE.index);
			style.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		}else if(color.equals("LIGHT_GREEN")){ 
			style.setFillBackgroundColor(HSSFColor.LIGHT_GREEN.index);
			style.setFillForegroundColor(HSSFColor.LIGHT_GREEN.index);
			style.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		}
		
		XSSFFont font = wb.createFont();
		font.setFontHeightInPoints((short) 10);
		font.setFontName("Arial");
		
		style.setFont(font);
		 
		return style;
	}
	
	/**
	 * excel file을 내보낸다
	 * @param file
	 * @param response
	 * @throws Exception
	 */
	public void pushFile(File file, HttpServletResponse response) throws Exception {
		FileInputStream fin = null;
		try {
            fin = new FileInputStream(file);
            int ifilesize = (int)file.length();
            String filename = file.getName();
            byte b[] = new byte[ifilesize];

            response.setContentLength(ifilesize);
            response.setContentType("application/vnd.ms-excel");
            response.setHeader( "Content-Disposition", "attachment; filename=" + filename+";" );
            ServletOutputStream oout = response.getOutputStream();
           
            while (fin.read(b) > 0) {
	            oout.write(b,0,ifilesize);
            }
	        oout.close();
            fin.close();
            file.delete();
        } catch ( Exception e ) {
        	System.out.println(e.toString());
        	throw e;
        } finally {
        	if(fin != null) {
        		try {
        			fin.close();
        		} catch ( Exception e ) {
                	System.out.println(e.toString());
                	throw e;
                }
        	}
        }
	}
	
	@Transactional(timeout = 15)
	@RequestMapping(value = "/zDlm_jsonDhtmlxListV7.do")
	public void zDlm_jsonDhtmlxListV7(HashMap cmmMap, HttpServletResponse response)  throws Exception {
		response.setHeader("Cache-Control", "no-cache");
		response.setContentType("text/plain");
		response.setCharacterEncoding("UTF-8");
		
		try {			
			String SQL_CODE = getString(cmmMap.get("sqlID"), "commonCode");	
					
			String tFilterCode = StringUtil.checkNull(cmmMap.get("tFilterCode"));
			String sqlGridList = StringUtil.checkNull(cmmMap.get("sqlGridList"));

			if(!"".equals(tFilterCode)) {
				SQL_CODE=StringUtil.checkNull(commonService.selectString("menu_SQL.getSqlNameForTfilterCode", cmmMap));
			}
			
			String sqlCode = "";
			if(sqlGridList.equals("N")) sqlCode = SQL_CODE; else sqlCode = SQL_CODE+SQL_GRID_LIST;
			List <Map>result = commonService.selectList(sqlCode, cmmMap);
			
			JSONArray resultJosnList = new JSONArray(result);
			response.getWriter().print(resultJosnList);
		} catch (Exception e) {
	        System.out.println(e.toString());
	        Map rs = new HashMap();
	        rs.put("error", e);
	        JSONObject result = new JSONObject(rs);
	        response.getWriter().write(result.toString());
	    }
	}
}
