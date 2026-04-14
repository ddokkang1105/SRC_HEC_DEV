package xbolt.api.service;


import xbolt.api.dto.ItemDto;
import xbolt.api.dto.RequestDto;

public interface OlmRestApiService {

	//RequestType : JSON Object
	ItemDto insertItemAndFileWithInfo(RequestDto requestDto) throws Exception;
	
	//RequestType : JSON Array
	//List<AttrIfVO> requestMappingListToVO(Map<String, Object> commandMap);

}
