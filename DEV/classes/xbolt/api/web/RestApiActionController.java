package xbolt.api.web;

import com.fasterxml.jackson.core.JsonProcessingException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import xbolt.api.dto.ItemDto;
import xbolt.api.dto.RequestDto;
import xbolt.api.enumType.ResponseCode;
import xbolt.api.exception.CustomException;
import xbolt.api.response.ApiResponse;
import xbolt.api.service.OlmRestApiLogService;
import xbolt.api.service.OlmRestApiService;
import xbolt.api.util.RestApiUtil;
import xbolt.api.util.ValidationUtil;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.util.StringUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/olmapi")
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class RestApiActionController extends XboltController{

	@Autowired
	private OlmRestApiService olmRestApiService;

	@Autowired
	private OlmRestApiLogService olmRestApiLogService;

	@RequestMapping(value = "/olmItemIf", method=RequestMethod.POST, consumes = "application/json; charset=utf-8", produces = "application/json; charset=utf-8")
	public void olmItemIf(@RequestBody String requestJsonData, HttpServletRequest request, HttpServletResponse response) throws Exception {

		ApiResponse<?> apiResponse = null;
		Map<String, Object> responseData = RestApiUtil.generateResultMap();
		RequestDto requestDto = new RequestDto();

		try{

			//mapping data, set default response
			String requestApiKey = StringUtil.checkNull(request.getHeader("x-api-key"));
			requestDto = RestApiUtil.jsonConverter(requestJsonData);
			responseData = RestApiUtil.generateResultMap(requestDto);


			//validation check : api & json value error
			ValidationUtil.dataValidationCheck(requestDto);
			ValidationUtil.apiKeyValidationCheck(requestApiKey, apiGlobalVal.OLM_API_KEY);

			//main logic
			ItemDto itemDto = olmRestApiService.insertItemAndFileWithInfo(requestDto);

			//set response data with result
			responseData.put("identifier", itemDto.getIdentifier());
			apiResponse = ApiResponse.success(ResponseCode.SELECT_SUCCESS.getHttpStatusCode(), null, responseData);


		} catch (CustomException e) {
			//item, file Validation Check 중에 발생한 Error
    		apiResponse = RestApiUtil.handleCustomException(e, responseData);
		} catch (JsonProcessingException e) {
    	        Throwable cause = e.getCause();
    	        //Deserialize 중에 발생한 Error throw CustomException 불가 -> CustomJsonProcessingException
    	        if (cause instanceof CustomException) {
    	            CustomException customException = (CustomException) cause;
        			e.printStackTrace();
            		apiResponse = RestApiUtil.handleCustomException(customException, responseData);
    	        }else {
    	        	throw new Exception();
    	        }
		} catch (Exception e) {
			e.printStackTrace();
    		apiResponse = RestApiUtil.handleException(e, responseData);
		} finally {

			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("requestDto", requestDto);
			paramMap.put("status", apiResponse.getStatus());
			paramMap.put("code", apiResponse.getCode());
			paramMap.put("msg", apiResponse.getMsg());
			paramMap.put("responseData", responseData);

			//결과까지 입력을 위해 AOP 대신 finally
			olmRestApiLogService.insertOlmApiLog(paramMap);

			RestApiUtil.writeJsonResponse(response, apiResponse);
		}
    }

	//jsp
	@RequestMapping(value = "/olmItemIf/page.do")
	 public String olmInterfacePage(ModelMap model, HttpServletRequest request) throws Exception {
		  return nextUrl("olmItemIf");
	}

}
