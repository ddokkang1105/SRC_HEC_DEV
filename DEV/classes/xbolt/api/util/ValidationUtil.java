package xbolt.api.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import xbolt.api.dto.RequestDto;
import xbolt.api.enumType.ErrorCode;
import xbolt.api.exception.CustomException;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonService;

import java.io.File;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

public class ValidationUtil {

	@Autowired
    @Qualifier("commonService")
    private CommonService commonService;
	
	@Autowired
    @Qualifier("fileMgtService")
    private CommonService fileMgtService;
	
	@Autowired
    @Qualifier("CSService")
    private CommonService CSService;
	
	
	public static void dataValidationCheck(RequestDto requestDto) throws RuntimeException, Exception{
		

		checkNotNullFieldEmpty(requestDto, requestDto.getNotNullColumn());
		
		//선택사항 : 정해진 값만 입력해야 되는 유효성 검사 기능
		//checkDataFormat(requestDto);
		
		checkFileExistsInDirectory(requestDto);

	}

	public static void apiKeyValidationCheck(String requestApiKey, String olmApiKey) throws CustomException, Exception{
		// API 키 검증 로직

		if(!olmApiKey.equals(requestApiKey)) {
			throw new CustomException(ErrorCode.INVALID_API_KEY);
		}
	}
	
	//deserializer에서 error 발생 시 log를 남기기 위한 용도
	public static void deserializerValidationCheck(RequestDto requestDto) throws CustomException, Exception{

		if(requestDto.getErrorCode() != null) {
			throw new CustomException(requestDto.getErrorCode());
		}
	}
	
	public static void checkFileExistsInDirectory(RequestDto requestDto) throws RuntimeException, Exception{
		
		String filePath = requestDto.getOrgFilePath();
		//File directory = new File(filePath);
		//if(!directory.exists()) throw new CustomException(ErrorCode.NO_FILE_AVAILABLE);
		
		List<Map<String,String>> files = requestDto.getFiles();
		for(Map<String,String> sndFile : files) {
			
			String subFilePath = StringUtil.checkNull(sndFile.get("filePath"));
			String fileName = StringUtil.checkNull(sndFile.get("chgFileName"));
			
			String fileNameWithPath = (filePath + RestApiUtil.generateStringPath(subFilePath) + fileName);
			File file = new File(fileNameWithPath);
			if(!(file.exists())) throw new CustomException(ErrorCode.NO_FILE_AVAILABLE);
		}
	}


	public static void checkNotNullFieldEmpty(Object object, List<String> notNullColumn) throws IllegalArgumentException, IllegalAccessException, Exception {

        for (Field field : object.getClass().getDeclaredFields()) {
            field.setAccessible(true);
        	Object columnName = field.getName();
        	Object columnValue = field.get(object);
        	if(notNullColumn.contains(columnName.toString())) {
        		if(columnValue instanceof String) {
            		if (emptyCheck(columnValue.toString())) {
                        throw new CustomException(ErrorCode.INVALID_DATA_FORMAT);
                    }
        		}else if(columnValue instanceof List) {
            		if (((ArrayList<?>)columnValue).size() == 0) {
                        throw new CustomException(ErrorCode.INVALID_DATA_FORMAT);
                    }
        		}
        	}
        }
    }
	
	
	public static Boolean emptyCheck(String str) {

		return str == null || str.trim().isEmpty();
		
	}
	
	public static Boolean mapIsEmptyCheck(Map<String,Object> map) {

		return map == null || map.isEmpty() || map.size() == 0;
		
	}
	
	
	
	
	public static void checkDataFormat(RequestDto requestDto) throws CustomException, Exception{

		if(!requestDto.getLvl1().equals("M")) throw new CustomException(ErrorCode.INVALID_DATA_FORMAT5);//문서영역
		if(!(requestDto.getLvl2().equals("CP") || requestDto.getLvl2().equals("PF") || requestDto.getLvl2().equals("PD")))
			throw new CustomException(ErrorCode.INVALID_DATA_FORMAT2);
		if(!(requestDto.getLvl3().equals("E") || requestDto.getLvl3().equals("A") || requestDto.getLvl3().equals("F") 
				|| requestDto.getLvl3().equals("P") || requestDto.getLvl3().equals("Z")))
			throw new CustomException(ErrorCode.INVALID_DATA_FORMAT8); 
		if(!requestDto.getSiteName().equals("HQ")) throw new CustomException(ErrorCode.INVALID_DATA_FORMAT3);//담당site
		if(!requestDto.getNctTyp().equals("Y")) throw new CustomException(ErrorCode.INVALID_DATA_FORMAT4);//NCT여부

		//plants
		String[] dimList = {};
		List<String> whiteList = new ArrayList<String>(Arrays.asList(dimList));
		for(Map<String,String> dimMap : requestDto.getDimension()){
        	if(!whiteList.contains(dimMap.get("dimID"))) {
        		throw new CustomException(ErrorCode.INVALID_DATA_FORMAT9);
        	}
		} 
	}

	
	

}
