package xbolt.api.service.impl;


import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import xbolt.api.dto.RequestDto;
import xbolt.api.enumType.ErrorCode;
import xbolt.api.exception.CustomException;
import xbolt.api.service.OlmRestApiLogService;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonService;

import java.util.HashMap;
import java.util.Map;


@Service
@SuppressWarnings("unchecked")
public class OlmRestApiLogServiceImpl implements OlmRestApiLogService {


	@Autowired
    @Qualifier("commonService")
    private CommonService commonService;
	
	@Autowired
    @Qualifier("CSService")
    private CommonService CSService;
	
	private ObjectMapper objectMapper = new ObjectMapper();
	
	//main Logic
	public void insertOlmApiLog(Map<String, Object> paramMap) throws CustomException, Exception{
		

		try {

			RequestDto requestDto = (RequestDto) paramMap.get("requestDto");
			Map<String,Object> responseData = (Map<String, Object>) paramMap.get("responseData");
			
			Map<String, Object> logMap = new HashMap<String,Object>();
			
			logMap = objectMapper.convertValue(requestDto, Map.class);
			
			//max logId 찾기
			String logId = commonService.selectString("log_SQL.getOlmApiLogMaxID", logMap);
			
			logMap.put("logId", logId);
			
			//response column
			logMap.put("status", paramMap.get("status"));
			logMap.put("code", paramMap.get("code"));
			logMap.put("msg", paramMap.get("msg"));

			logMap.put("direction", "IN");
			logMap.put("contents", "OLM REST API 호출");
						
			//log insert
			commonService.insert("log_SQL.insertOlmApiLog", logMap);
			
			//plant log insert
			if(requestDto.getDimension()!=null) {
				for(Map<String, String> dimMap : requestDto.getDimension()) {
					Map<String, Object> dimLogMap = new HashMap<String,Object>();
					dimLogMap.put("logId", logId);
					dimLogMap.put("sourceDimID", StringUtil.checkNull(dimMap.get("dimId")));
					dimLogMap.put("sourceDimName", StringUtil.checkNull(dimMap.get("dimValue")));
					
					commonService.insert("log_SQL.insertOlmApiDimLog", dimLogMap);
				}
			}


			//file log insert
			if(requestDto.getFiles()!=null) {
				for(Map<String, String> fileMap : requestDto.getFiles()) {
					Map<String, Object> fileLogMap = new HashMap<String,Object>();
					fileLogMap.put("logId", logId);
					fileLogMap.put("sourceFilePath", StringUtil.checkNull(fileMap.get("filePath")));
					fileLogMap.put("sourceSndFileName", StringUtil.checkNull(fileMap.get("chgFileName")));
					fileLogMap.put("sourceOrgFileName", StringUtil.checkNull(fileMap.get("orgFileName")));
					
					commonService.insert("log_SQL.insertOlmApiFileLog", fileLogMap);
				}
				
			}
			
			//file log 저장 logic
			
		}catch(Exception e) {
			
			e.printStackTrace();
			throw new CustomException(ErrorCode.LOG_INSERT_ERROR);
		}
	}
	

}

