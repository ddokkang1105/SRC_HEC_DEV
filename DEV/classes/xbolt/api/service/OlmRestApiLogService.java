package xbolt.api.service;


import xbolt.api.exception.CustomException;

import java.util.Map;

public interface OlmRestApiLogService {

	//Request Log
	void insertOlmApiLog(Map<String, Object> paramMap) throws CustomException, Exception;
	

}
