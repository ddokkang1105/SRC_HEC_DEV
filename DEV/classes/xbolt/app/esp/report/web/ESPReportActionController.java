package xbolt.app.esp.report.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.org.json.JSONArray;
import com.org.json.JSONObject;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;

import xbolt.cmm.service.CommonService;

//import xbolt.custom.youngone.web.HttpServletRequest;
//import xbolt.custom.youngone.web.HttpServletResponse;

@Controller
@SuppressWarnings("unchecked")
public class ESPReportActionController extends XboltController {
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@RequestMapping(value = "/getValidSrTypeCodeName.do")
	public void getValidSrTypeCodeName(HttpServletRequest request, HashMap commandMap, HttpServletResponse response) throws ExceptionUtil {
	    response.setHeader("Cache-Control", "no-cache");
	    response.setContentType("text/plain");
	    response.setCharacterEncoding("UTF-8");

	    try {
	    	String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
	        List<Map<String, Object>> srTypeRawList = commonService.selectList("esmReport_SQL.getValidSrTypeCodeName", commandMap);
	        
	        JSONObject resultJson = new JSONObject();
	        
	        List<String> srTypeArray = new ArrayList<>();
	        List<String> srNameArray = new ArrayList<>();
	        
	        for (Map<String, Object> row : srTypeRawList) {
	        	srTypeArray.add(StringUtil.checkNull(row.get("srTypeCode")));
	        	srNameArray.add(StringUtil.checkNull(row.get("srTypeName")));
	        }
	        
	        resultJson.put("srTypeArray", new JSONArray(srTypeArray));
	        resultJson.put("srNameArray", new JSONArray(srNameArray));
	        
	        response.getWriter().print(resultJson.toString());

	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        Map<String, Object> rs = new HashMap<>();
	        rs.put("error", e.getMessage());
	        JSONObject result = new JSONObject(rs);
	        try {
	            response.getWriter().print(result);
	        } catch (IOException ioException) {
	            System.out.println(ioException.getMessage());
	        }
	    }
	}
	
	@RequestMapping(value = "/overviewRptByClient.do")
	public String overviewRptByClient(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		ObjectMapper objectMapper = new ObjectMapper();
		try {
			
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));

			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("languageID", languageID);
			

		} catch (Exception e) {
			System.out.println(e.getMessage());
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/app/esp/report/OverviewRptByClient");
	}
	

	@RequestMapping(value = "/getOverviewGridDataByClient.do")
	public void getOverviewGridDataByClient(HttpServletRequest request, HashMap commandMap, HttpServletResponse response) throws ExceptionUtil, IOException {
		
	    response.setHeader("Cache-Control", "no-cache");
	    response.setContentType("text/plain");
	    response.setCharacterEncoding("UTF-8");

	    try {
	        String regStartDate = StringUtil.checkNull(request.getParameter("regStartDate"));
	        String regEndDate = StringUtil.checkNull(request.getParameter("regEndDate"));

	        String[] srTypeArray = request.getParameterValues("srTypeArray[]");
	        if (srTypeArray != null && srTypeArray.length > 0) {
	            commandMap.put("srTypeArray", Arrays.asList(srTypeArray));
	        }

	        if (!regStartDate.equals("") && !regEndDate.equals("")) {
	            commandMap.put("regStartDate", regStartDate);
	            commandMap.put("regEndDate", regEndDate);
	        }

	        List<Map<String, Object>> overviewRaw = commonService.selectList("esmReport_SQL.getSRCountOverviewByClient", commandMap);


	        long totalClientTotal = 0;
	        for (Map<String, Object> row : overviewRaw) {
	            totalClientTotal += ((Number) row.get("ClientTotal")).longValue();
	        }

	        
	        for (Map<String, Object> row : overviewRaw) {
	            long clientTotal = ((Number) row.get("ClientTotal")).longValue();
	            double share = 0.0;
	            if (totalClientTotal > 0) {
	                share = (double) clientTotal / totalClientTotal * 100;
	            }
	            row.put("ClientShare", String.format("%.1f%%", share));
	        }

	        Map<String, Object> totalRow = new HashMap<>();
	        totalRow.put("ClientName", "Total");

	        for (String srType : srTypeArray) {
	            long totalCompleted = 0;
	            long totalProcessing = 0;
	            long totalTotal = 0;

	            for (Map<String, Object> row : overviewRaw) {
	                if (row.get("ClientName").equals("Total")) continue; // 이미 처리한 totalRow는 건너뛰기
	                totalCompleted += ((Number) row.get(srType + "Completed")).longValue();
	                totalProcessing += ((Number) row.get(srType + "Processing")).longValue();
	                totalTotal += ((Number) row.get(srType + "Total")).longValue();
	            }

	            totalRow.put(srType + "Completed", totalCompleted);
	            totalRow.put(srType + "Processing", totalProcessing);
	            totalRow.put(srType + "Total", totalTotal);
	        }

	        totalRow.put("ClientTotal", totalClientTotal);

	        long totalClientCompleted = 0;
	        long totalClientProcessing = 0;
	        for (Map<String, Object> row : overviewRaw) {
	            if (row.get("ClientName").equals("Total")) continue;
	            totalClientCompleted += ((Number) row.get("ClientCompleted")).longValue();
	            totalClientProcessing += ((Number) row.get("ClientProcessing")).longValue();
	        }
	        totalRow.put("ClientCompleted", totalClientCompleted);
	        totalRow.put("ClientProcessing", totalClientProcessing);
	        totalRow.put("ClientShare", "100%");

	        overviewRaw.add(totalRow);

	        JSONArray overviewStatistics = new JSONArray(overviewRaw);
	        response.getWriter().print(overviewStatistics);

	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        Map<String, Object> rs = new HashMap<>();
	        rs.put("error", e.getMessage());
	        JSONObject result = new JSONObject(rs);
	        response.getWriter().print(result);
	    }
	}
	@RequestMapping(value = "/overviewRptByServicePart.do")
	
	public String overviewRptByServicePart(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		ObjectMapper objectMapper = new ObjectMapper();
		try {
			
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));

			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("languageID", languageID);
			

		} catch (Exception e) {
			System.out.println(e.getMessage());
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/app/esp/report/OverviewRptByServicePart");
	}
	
	@RequestMapping(value = "/getOverviewGridDataBySRArea2.do")
	public void getOverviewGridDataBySRArea2(HttpServletRequest request, HashMap commandMap, HttpServletResponse response) throws ExceptionUtil, IOException {
	    // 응답 헤더 설정
	    response.setHeader("Cache-Control", "no-cache");
	    response.setContentType("text/plain");
	    response.setCharacterEncoding("UTF-8");

	    try {
	        String regStartDate = StringUtil.checkNull(request.getParameter("regStartDate"));
	        String regEndDate = StringUtil.checkNull(request.getParameter("regEndDate"));
	        
	        
	        String[] srTypeArray = request.getParameterValues("srTypeArray[]");
	        if (srTypeArray != null && srTypeArray.length > 0) {
	            commandMap.put("srTypeArray", Arrays.asList(srTypeArray));
	        }

	        if (!regStartDate.equals("") && !regEndDate.equals("")) {
	            commandMap.put("regStartDate", regStartDate);
	            commandMap.put("regEndDate", regEndDate);
	        }
	        
            String customerNo = StringUtil.checkNull(request.getParameter("customerNo"));
 
            if (!customerNo.equals("")) {
                commandMap.put("customerNo", customerNo);
            }
	        
	        List<Map<String, Object>> overviewRaw = commonService.selectList("esmReport_SQL.getSRCountOverviewBySRArea2", commandMap);

	        Map<String, Object> totalRow = new HashMap<>();
	        totalRow.put("PartName", "Total");

	        
	        if (!overviewRaw.isEmpty()) {
	            Map<String, Object> firstRow = overviewRaw.get(0);
	            for (String key : firstRow.keySet()) {
	                
	                if ("ServiceName".equals(key) || "PartName".equals(key) || "PartID".equals(key)) {
	                    continue;
	                }
	                long totalSum = 0;
	                for (Map<String, Object> row : overviewRaw) {
	                    Object value = row.get(key);
	                    if (value instanceof Number) {
	                        totalSum += ((Number) value).longValue();
	                    }
	                }
	                totalRow.put(key, totalSum);
	            }
	        }
	        
	        
	        long totalSum = 0;
	        long completedSum = 0;
	        long processingSum = 0;
	        for (Map<String, Object> row : overviewRaw) {
	            totalSum += ((Number) row.get("Total")).longValue();
	            completedSum += ((Number) row.get("Completed")).longValue();
	            processingSum += ((Number) row.get("Processing")).longValue();
	        }
	        totalRow.put("Total", totalSum);
	        totalRow.put("Completed", completedSum);
	        totalRow.put("Processing", processingSum);
	        
	        
	        overviewRaw.add(totalRow);

	        JSONArray overviewStatistics = new JSONArray(overviewRaw);
	        response.getWriter().print(overviewStatistics);

	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        
	        Map<String, Object> rs = new HashMap<>();
	        rs.put("error", e.getMessage());
	        JSONObject result = new JSONObject(rs);
	        response.getWriter().print(result);
	    }
	}
	
	@RequestMapping(value = "/openTicketReport.do")
	public String openTicketReport(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		ObjectMapper objectMapper = new ObjectMapper();
		try {
			
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String arcCode = StringUtil.checkNull(request.getParameter("arcCode"));
			String period = StringUtil.checkNull(request.getParameter("period"));
			String companyIDs = StringUtil.checkNull(request.getParameter("companyIDs")); // 통게 허용 법인
			
			// 지역관리자 체크 start
			String regionManager = "N";
			Map setMap = new HashMap();
			
			setMap.put("sessionUserId",commandMap.get("sessionUserId"));
			setMap.put("languageID",languageID);
			String myWorkspaceName = commonService.selectString("esm_SQL.getMyWorkspaceName",setMap);
			
			if(!"".equals(myWorkspaceName) && myWorkspaceName != null) regionManager = "Y";
			// 지역관리자 체크 end
			
			
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("arcCode", arcCode); 
			model.put("period", period); 
			model.put("companyIDs", companyIDs); 
			model.put("languageID", languageID);
			model.put("regionManager", regionManager);

		} catch (Exception e) {
			System.out.println(e.getMessage());
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/app/esp/report/openTicketReport");
	}
	
	@RequestMapping(value = "/PerformanceReportSRArea.do")
	public String PerformanceReportSRArea(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		ObjectMapper objectMapper = new ObjectMapper();
		try {
			
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String arcCode = StringUtil.checkNull(request.getParameter("arcCode"));
			String period = StringUtil.checkNull(request.getParameter("period"));
			String esType = StringUtil.checkNull(request.getParameter("esType"));
			String companyIDs = StringUtil.checkNull(request.getParameter("companyIDs")); // 통게 허용 법인
			
			// 지역관리자 체크 start
			String regionManager = "N";
			Map setMap = new HashMap();
			
			setMap.put("sessionUserId",commandMap.get("sessionUserId"));
			setMap.put("languageID",languageID);
			String myWorkspaceName = commonService.selectString("esm_SQL.getMyWorkspaceName",setMap);
			
			if(!"".equals(myWorkspaceName) && myWorkspaceName != null) regionManager = "Y";
			// 지역관리자 체크 end
			
			
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("arcCode", arcCode); 
			model.put("esType", esType); 
			model.put("period", period); 
			model.put("companyIDs", companyIDs); 
			model.put("languageID", languageID);
			model.put("regionManager", regionManager);

		} catch (Exception e) {
			System.out.println(e.getMessage());
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/app/esp/report/PerformanceReportSRArea");
	}
	
	@RequestMapping(value = "/PerformanceReportCategory.do")
	public String PerformanceReportCategory(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		ObjectMapper objectMapper = new ObjectMapper();
		try {
			
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String arcCode = StringUtil.checkNull(request.getParameter("arcCode"));
			String period = StringUtil.checkNull(request.getParameter("period"));
			String esType = StringUtil.checkNull(request.getParameter("esType"));
			String companyIDs = StringUtil.checkNull(request.getParameter("companyIDs")); // 통게 허용 법인
			
			// 지역관리자 체크 start
			String regionManager = "N";
			Map setMap = new HashMap();
			
			setMap.put("sessionUserId",commandMap.get("sessionUserId"));
			setMap.put("languageID",languageID);
			String myWorkspaceName = commonService.selectString("esm_SQL.getMyWorkspaceName",setMap);
			
			if(!"".equals(myWorkspaceName) && myWorkspaceName != null) regionManager = "Y";
			// 지역관리자 체크 end
			
			
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("esType", esType); 
			model.put("arcCode", arcCode); 
			model.put("period", period); 
			model.put("companyIDs", companyIDs); 
			model.put("languageID", languageID);
			model.put("regionManager", regionManager);

		} catch (Exception e) {
			System.out.println(e.getMessage());
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/app/esp/report/PerformanceReportCategory");
	}
	
	@RequestMapping(value = "/individualPerformanceReport.do")
	public String individualPerformanceReport(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		ObjectMapper objectMapper = new ObjectMapper();
		try {
			
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String arcCode = StringUtil.checkNull(request.getParameter("arcCode"));
			String period = StringUtil.checkNull(request.getParameter("period"));
			String companyIDs = StringUtil.checkNull(request.getParameter("companyIDs")); // 통게 허용 법인
			
			// 지역관리자 체크 start
			String regionManager = "N";
			Map setMap = new HashMap();
			
			setMap.put("sessionUserId",commandMap.get("sessionUserId"));
			setMap.put("languageID",languageID);
			String myWorkspaceName = commonService.selectString("esm_SQL.getMyWorkspaceName",setMap);
			
			if(!"".equals(myWorkspaceName) && myWorkspaceName != null) regionManager = "Y";
			// 지역관리자 체크 end
			
			
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("arcCode", arcCode); 
			model.put("period", period); 
			model.put("companyIDs", companyIDs); 
			model.put("languageID", languageID);
			model.put("regionManager", regionManager);

		} catch (Exception e) {
			System.out.println(e.getMessage());
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/app/esp/report/individualPerformanceReport");
	}
	
	@RequestMapping(value = "/PerformanceReportCustomer.do")
	public String PerformanceReportCustomer(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		ObjectMapper objectMapper = new ObjectMapper();
		try {
			
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String arcCode = StringUtil.checkNull(request.getParameter("arcCode"));
			String period = StringUtil.checkNull(request.getParameter("period"));
			String esType = StringUtil.checkNull(request.getParameter("esType"));
			String companyIDs = StringUtil.checkNull(request.getParameter("companyIDs")); // 통게 허용 법인
			
			// 지역관리자 체크 start
			String regionManager = "N";
			Map setMap = new HashMap();
			
			setMap.put("sessionUserId",commandMap.get("sessionUserId"));
			setMap.put("languageID",languageID);
			String myWorkspaceName = commonService.selectString("esm_SQL.getMyWorkspaceName",setMap);
			
			if(!"".equals(myWorkspaceName) && myWorkspaceName != null) regionManager = "Y";
			// 지역관리자 체크 end
			
			
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("arcCode", arcCode); 
			model.put("esType", esType); 
			model.put("period", period); 
			model.put("companyIDs", companyIDs); 
			model.put("languageID", languageID);
			model.put("regionManager", regionManager);

		} catch (Exception e) {
			System.out.println(e.getMessage());
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/app/esp/report/PerformanceReportCustomer");
	}
	
	
}
