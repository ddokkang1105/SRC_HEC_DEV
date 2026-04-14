package xbolt.project.cs.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.PropertyAccessor;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.org.json.JSONException;
import com.org.json.JSONObject;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonService;
import xbolt.project.cs.dto.ChangeSetListInfoDTO;
import xbolt.project.cs.service.CSInfoAPIServiceImpl;

/**
 * 업무 처리
 * 
 * @Class Name : CsInfoAPIActionController.java
 * @Description : cs 관련 API 호출용 자바 
 * @Modification Information
 * @수정일 수정자 수정내용
 * @--------- --------- -------------------------------
 * @2012. 09. 01. smartfactory 최초생성
 * 
 * @since 2026. 01. 26.
 * @version 1.0
 */
@Controller
public class CSInfoAPIActionController extends XboltController {
	
	@Resource(name = "commonService")
	private CommonService commonService;

    @Resource(name = "CSInfoService")
    private CSInfoAPIServiceImpl csInfoService;
    
    private static final ObjectMapper DTO_MAPPER;

    static {
        DTO_MAPPER = new ObjectMapper();
        DTO_MAPPER.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.NONE);
        DTO_MAPPER.setVisibility(PropertyAccessor.FIELD, JsonAutoDetect.Visibility.ANY);
    }

    //item CS리스트
	@RequestMapping(value = "getChangeSetListInfo.do", method = RequestMethod.GET)
	@ResponseBody
	public void getChangeSetListInfo(ChangeSetListInfoDTO csInfoDTO,HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("application/json; charset=UTF-8");
		JSONObject resultMap = new JSONObject();
		
		Map Info = new HashMap();
		Map setMap = new HashMap();
		
		boolean success = false;
		
		try {
			
		  

	   
	        Object data = csInfoService.getItemChangeSetList(csInfoDTO);

	        success = true;
	        resultMap.put("data", data);
	        
        } catch (IllegalArgumentException e) {
        	// 400 Bad Request
        	response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (DataAccessException e) {
        	// 500 Internal Server Error
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (JSONException e) {
        	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (Exception e) {
        	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } finally {
        	
        	resultMap.put("success", success);
        	try {
        		// send to json
        		response.getWriter().print(resultMap);
        	} catch (Exception e) {
        		System.err.println(e.getMessage());
        	}
        	
        }
	}


		
		// 아이템 변경내역리스트
		@RequestMapping(value = "getRevisionCSInfoView.do", method = RequestMethod.GET)
		@ResponseBody
		public void getRevisionCSInfoView(ChangeSetListInfoDTO csInfoDTO,HttpServletRequest request, HttpServletResponse response) throws Exception {
			
			response.setCharacterEncoding("UTF-8");
			response.setContentType("application/json; charset=UTF-8");
			JSONObject resultMap = new JSONObject();
			
			Map Info = new HashMap();
			Map setMap = new HashMap();
			
			boolean success = false;
			
			try {
				
				// parameter
				String languageID = StringUtil.checkNull(csInfoDTO.getLanguageID());
				String changeSetID = StringUtil.checkNull(csInfoDTO.getChangeSetID());
				
				//paraneter check
				if(changeSetID.isEmpty()) {
					throw new IllegalArgumentException("changeSetID is required.");
				}
				if(languageID.isEmpty()) {
					throw new IllegalArgumentException("languageID is required.");
				}
				


		        //  DTO → Map 변환 
		        setMap = DTO_MAPPER.convertValue(csInfoDTO, Map.class);
		        
				List revisionList = commonService.selectList("cs_SQL.getRevisionListForCS", setMap); 
				
				success = true;
				resultMap.put("data", revisionList);
		        
	        } catch (IllegalArgumentException e) {
	        	// 400 Bad Request
	        	response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
				resultMap.put("message", e.getMessage());
	            System.err.println(e);
	        } catch (DataAccessException e) {
	        	// 500 Internal Server Error
	            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				resultMap.put("message", e.getMessage());
	            System.err.println(e);
	        } catch (JSONException e) {
	        	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				resultMap.put("message", e.getMessage());
	            System.err.println(e);
	        } catch (Exception e) {
	        	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				resultMap.put("message", e.getMessage());
	            System.err.println(e);
	        } finally {
	        	
	        	resultMap.put("success", success);
	        	try {
	        		// send to json
	        		response.getWriter().print(resultMap);
	        	} catch (Exception e) {
	        		System.err.println(e.getMessage());
	        	}
	        	
	        }
		}
		
	
}
