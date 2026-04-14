package xbolt.api.util;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import xbolt.api.dto.RequestDto;
import xbolt.api.enumType.ErrorCode;
import xbolt.api.exception.CustomException;
import xbolt.api.json.Deserializer;
import xbolt.api.response.ApiResponse;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class RestApiUtil {


	//ApiResponse -> Json
	public static RequestDto jsonConverter(String jsonString) throws JsonMappingException, JsonProcessingException {
		
		ObjectMapper customObjectMapper = Deserializer.olmObjectMapper();
		return customObjectMapper.readValue(jsonString, new TypeReference<RequestDto>() {});
	}

	//CustomException 발생 시 ApiResponse 구성
	public static ApiResponse<?> handleCustomException(CustomException e, Map<String, Object> result) { 
		return ApiResponse.fail(e.getErrorCode(), result);

	}
	
	//Exception 발생 시 ApiResponse 구성
	public static ApiResponse<?> handleException(Exception e, Map<String, Object> result) {
		return ApiResponse.fail(ErrorCode.ETC_ERROR, result);
	}

	//filePath 생성
	public static String generateStringPath(String fileSubPath) {
		return (fileSubPath != null && !fileSubPath.equals("")) ? fileSubPath + "//" : "";
	}
	
	//고정된 result request로 부터 설정
	public static Map<String, Object> generateResultMap(RequestDto requestDto){
		
		Map<String, Object> resultMap = new HashMap<>();
		
		resultMap.put("identifier", null);
		resultMap.put("orgIdentifier", requestDto.getDocNo());
		resultMap.put("version", requestDto.getVersion());

		return resultMap;
	}
	
	//default result 설정
	public static Map<String, Object> generateResultMap(){
		
		Map<String, Object> resultMap = new HashMap<>();
		
		resultMap.put("identifier", null);
		resultMap.put("orgIdentifier", "");
		resultMap.put("version", "");

		
		return resultMap;
	}
	
	public static void writeJsonResponse(HttpServletResponse response, ApiResponse<?> apiResponse) throws IOException {
	    // JSON 응답을 생성하여 반환
	    ObjectMapper objectMapper = new ObjectMapper();
	    String jsonResponse = objectMapper.writeValueAsString(apiResponse);

	    response.setHeader("Cache-Control", "no-cache");
	    response.setContentType("application/json");
	    response.setCharacterEncoding("UTF-8");
	    response.getWriter().print(jsonResponse);
	}

	

	
}
