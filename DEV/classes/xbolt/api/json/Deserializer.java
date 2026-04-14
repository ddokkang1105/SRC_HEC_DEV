package xbolt.api.json;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.ObjectCodec;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.deser.std.StdDeserializer;
import com.fasterxml.jackson.databind.json.JsonMapper;
import com.fasterxml.jackson.databind.module.SimpleModule;

import xbolt.api.dto.RequestDto;
import xbolt.api.enumType.ErrorCode;
import xbolt.api.exception.CustomException;
import xbolt.api.exception.CustomJsonProcessingException;

public class Deserializer extends StdDeserializer<RequestDto>{

	private ErrorCode deserializerErrorCode = null;
	
	public Deserializer() {
		this(null);
	}
	
	public Deserializer(Class<?> vc) {
		super(vc);
	}
	
	@Override
	public RequestDto deserialize(JsonParser parser, DeserializationContext deserializer) throws IOException, JsonProcessingException {
	    try {	    	
	    	
	        ObjectCodec codec = parser.getCodec();
	        JsonNode node = codec.readTree(parser);


	        //Project별 Custom해야 하는 부분
        	//*************************************************
	        String etc = checkStringMappingValidation(node.get("ETC"), ErrorCode.INVALID_JSON_INPUT8);
        	//*************************************************
	        
	        
	        
	        
        	//Custom시에도 필수 고정 사항	(불변)
        	//*************************************************
	        String docNo = checkStringMappingValidation(node.get("DOC_NO"), ErrorCode.INVALID_JSON_INPUT1);
	        String docName = checkStringMappingValidation(node.get("DOC_NAME"), ErrorCode.INVALID_JSON_INPUT2);
	        int version = checkIntMappingValidation(node.get("VERSION"), ErrorCode.INVALID_JSON_INPUT1);
	        
	        String userId = checkStringMappingValidation(node.get("USER_ID"), ErrorCode.INVALID_JSON_INPUT4);
	        
	        String lvl1 = checkStringMappingValidation(node.get("LEVEL1"), ErrorCode.INVALID_JSON_INPUT6);
	        String lvl2 = checkStringMappingValidation(node.get("LEVEL2"), ErrorCode.INVALID_JSON_INPUT);
	        String lvl3 = checkStringMappingValidation(node.get("LEVEL3"), ErrorCode.INVALID_JSON_INPUT9);
	        String lvl4 = checkStringMappingValidation(node.get("LEVEL4"), ErrorCode.INVALID_JSON_INPUT);
	        String nctTyp = checkStringMappingValidation(node.get("NCT_TYP"), ErrorCode.INVALID_JSON_INPUT5);

	        String revDesc = checkStringMappingValidation(node.get("REV_DESC"), ErrorCode.INVALID_JSON_INPUT);
	        String description = checkStringMappingValidation(node.get("DESC"), ErrorCode.INVALID_JSON_INPUT);
	        String siteName = checkStringMappingValidation(node.get("SITE_NAME"), ErrorCode.INVALID_JSON_INPUT3);

	        String opTyp = checkStringMappingValidation(node.get("OP_TYP"), ErrorCode.INVALID_JSON_INPUT);
	        
	        JsonNode dimensionArray = checkJsonNodeMappingValidation(node.get("DIM"), ErrorCode.INVALID_JSON_INPUT);
	        List<String> dimensionId = new ArrayList<>();
	        List<Map<String, String>> dimension = new ArrayList<Map<String, String>>();
	        if (dimensionArray != null && dimensionArray.isArray()) {
	            for (JsonNode dimensionNode : dimensionArray) {
	            	Map<String, String> dimMap = new HashMap<String, String>();
	            	dimMap.put("dimId", checkStringMappingValidation(dimensionNode.get("DIM_ID"), ErrorCode.INVALID_JSON_INPUT));
	            	dimMap.put("dimValue", checkStringMappingValidation(dimensionNode.get("DIM_VALUE"), ErrorCode.INVALID_JSON_INPUT));

	            	dimensionId.add("dimId");
	            	dimension.add(dimMap);
	            }
	        }
	        // file list
	        JsonNode fileArray = checkJsonNodeMappingValidation(node.get("FILES"), ErrorCode.INVALID_JSON_INPUT);
	        List<Map<String, String>> files = new ArrayList<Map<String, String>>();
	        List<String> fileName = new ArrayList<>();
	        if (fileArray != null && fileArray.isArray()) {
	            for (JsonNode fileNode : fileArray) {
	                Map<String, String> file = new HashMap<String, String>();
	                file.put("filePath", checkStringMappingValidation(fileNode.get("FILE_PATH"), ErrorCode.INVALID_JSON_INPUT));
	                file.put("chgFileName", checkStringMappingValidation(fileNode.get("CHG_FILE_NAME"), ErrorCode.INVALID_JSON_INPUT));
	                file.put("orgFileName", checkStringMappingValidation(fileNode.get("ORG_FILE_NAME"), ErrorCode.INVALID_JSON_INPUT));

	                fileName.add(checkStringMappingValidation(fileNode.get("ORG_FILE_NAME"), ErrorCode.INVALID_JSON_INPUT));
	                files.add(file);
	            }
	        }
        	//*************************************************
	        

	        return new RequestDto(
	        		//Project별 Custom해야 하는 부분
	        		etc
	        		
	        		
	            	//Custom시에도 필수 고정 사항	(불변)
	            	//*************************************************
	                ,docNo, version, userId, lvl1, lvl2, lvl3, lvl4, 
	                nctTyp, dimension, files, siteName, docName, description, revDesc, opTyp, deserializerErrorCode);
        			//*************************************************
	        
	        
	    } catch (CustomException e) {
	        throw new CustomJsonProcessingException("An error occurred during deserialization", e);  // CustomException을 직접 다시 던집니다.
	    } catch (Exception e) {
	        throw new IOException("An error with UnExcepted Exception occurred during deserialization", e); // IOException을 던집니다.
	    }
	}
	
	public static ObjectMapper olmObjectMapper() {
		ObjectMapper objectMapper = JsonMapper.builder()
				//Mapping될 Object에 없는 JSON 필드 무시
				.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
				.build();

		SimpleModule customModule = new SimpleModule();
		customModule.addDeserializer(RequestDto.class, new Deserializer());
		objectMapper.registerModule(customModule);
		
		return objectMapper;
	}


	public String checkStringMappingValidation(JsonNode jsonNode, ErrorCode errorCode) throws CustomException{
		if(jsonNode != null) {
			return jsonNode.asText();
		}else {
			deserializerErrorCode = errorCode;
			return null;
		}

	}
	

	public int checkIntMappingValidation(JsonNode jsonNode, ErrorCode errorCode) throws CustomException{	
		if(jsonNode != null) {
			return jsonNode.asInt();
		}else {
			deserializerErrorCode = errorCode;
			return 0;
		}
	}
	public JsonNode checkJsonNodeMappingValidation(JsonNode jsonNode, ErrorCode errorCode) throws CustomException{
		
		if(jsonNode != null) {
			return jsonNode;
		}else {
			deserializerErrorCode = errorCode;
			return null;
		}
	}


}
