package xbolt.project.cs.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;
import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.PropertyAccessor;
import com.fasterxml.jackson.databind.ObjectMapper;

import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonDataServiceImpl;
import xbolt.cmm.service.CommonService;
import xbolt.project.cs.dto.ChangeSetListInfoDTO;

@Service("CSInfoService")
@SuppressWarnings("unchecked")
public class CSInfoAPIServiceImpl extends CommonDataServiceImpl{
	  private static final ObjectMapper DTO_MAPPER;

	    static {
	        DTO_MAPPER = new ObjectMapper();
	        DTO_MAPPER.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.NONE);
	        DTO_MAPPER.setVisibility(PropertyAccessor.FIELD, JsonAutoDetect.Visibility.ANY);
	    }


	//1) ITEM 변경이력 (목록+ 상세 붙이기) 
	
    public List<Map<String, Object>> getItemChangeSetList(ChangeSetListInfoDTO csInfoDTO) throws Exception {
        Map<String, Object> setMap = new HashMap<>();
        Map<String, Object> Info = new HashMap();

        //Parameter
        String s_itemID   = StringUtil.checkNull(csInfoDTO.getS_itemID());
        String languageID = StringUtil.checkNull(csInfoDTO.getLanguageID());
        String changeSetID = "";

        //parameter Check
        if (s_itemID.isEmpty()) throw new IllegalArgumentException("s_itemID is required.");
        if (languageID.isEmpty()) throw new IllegalArgumentException("languageID is required.");


        //  DTO → Map 변환 
        setMap = DTO_MAPPER.convertValue(csInfoDTO, Map.class);
        
        // main list
        List<Map<String, Object>> changeSetList =(List<Map<String, Object>>) selectList("cs_SQL.getItemChangeList_gridList", setMap);

        // 공통값 미리 구해두기 
        setMap.put("DocCategory", "CS");
        String wfURL = getWfUrlForCS(setMap);
        String lastChangeSetID = getLastChangeSetID(setMap);

        // 상세 붙이기
        // 변경내역 상세 호출
	    for (Map<String, Object> row : changeSetList) {

	        changeSetID = StringUtil.checkNull(row.get("ChangeSetID"));
	        if ("".equals(changeSetID)) {
	            throw new IllegalArgumentException("changeSetID is required.");
	        }

	        // 변경내역 List 상세 ( ChangeSetID / languageID )
	        setMap.put("ChangeSetID", changeSetID);
	        Info = select("cs_SQL.getChangeSetList_gridList", setMap);
	        row.put("Info", Info);

	        // LastChangeSetID 여부
	        if (lastChangeSetID != null && lastChangeSetID.equals(changeSetID)) {
	            row.put("lastChangeSet", "Y");
	        } else {
	            row.put("lastChangeSet", "N");
	        }

	        // 결재 상세페이지 url
	        row.put("wfURL", wfURL);
	    }
		
	    return changeSetList;
    }
    
    
 

    // =====================
    // 공통(재사용) 메소드들
    // =====================

    private String getWfUrlForCS(Map<String, Object> map) throws Exception {

        return StringUtil.checkNull(selectString("wf_SQL.getWFCategoryURL", map));
    }
    
    private String getLastChangeSetID(Map<String, Object> setMap) throws Exception {
     
        return selectString("cs_SQL.getNextPreChangeSetID", setMap);
    }
    
    
}
