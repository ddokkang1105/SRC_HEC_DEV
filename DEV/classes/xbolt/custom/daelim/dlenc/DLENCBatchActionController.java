package xbolt.custom.daelim.dlenc ;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;




@SuppressWarnings("unchecked")
public class DLENCBatchActionController extends XboltController{
	@Resource(name = "commonService")
	private CommonService commonService;
	@Autowired
	private DLENCActionController dlencActionController;
	
	private final Log _log = LogFactory.getLog(this.getClass());
	private static String OLM_SERVER_URL =  StringUtil.checkNull(GlobalVal.OLM_SERVER_URL);
		
	//인사프로시저 배치함수
	public void exeBatchHRinterface() throws Exception {
	    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");
		LocalDateTime start = LocalDateTime.now();
		System.out.println(">>> exeBatchHRinterface 호출됨 @ - 시작 시각: " + start.format(formatter));
		
		HashMap setMap = new HashMap();
		setMap.put("ReportCode","HR");
		setMap.put("Contents","XBOLTADM.HR_IF_STD");
		commonService.insert("zDLENC_SQL.insertBatchJobLog", setMap);
		String BatchJobNo = commonService.selectString("zDLENC_SQL.getMaxBatchJobNoString", setMap);
		setMap.put("BatchJobNo",BatchJobNo);
		
		try{
			commonService.insert("zDLENC_SQL.batchIF", setMap);
			
			setMap.put("Status","02");
			commonService.update("zDLENC_SQL.UpdateBatchJobLog",setMap);
			
			LocalDateTime end = LocalDateTime.now();
			Duration duration = Duration.between(start, end);
			System.out.println(">>> [exeBatchHRinterface] 완료됨 # | 완료 시각: " + end.format(formatter) + " | 실행 시간: " + duration.toMillis() + " ms");
		} catch (Exception e) {
			e.printStackTrace(); 
			setMap.put("Status","03");
			commonService.select("zDLENC_SQL.UpdateBatchJobLog", setMap);
			if(_log.isInfoEnabled()){_log.info("DLENCBatchActionController::Error::"+e);}
		}	
	}
	
	
	//주토플 현장 item 업데이트 배치
	public void exeBatchUpdateItem() throws Exception {
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");
		LocalDateTime start = LocalDateTime.now();

		System.out.println(">>> exeBatchUpdateItem 호출됨 ^ - 시작 시각: " + start.format(formatter));
		HashMap setMap = new HashMap();
		setMap.put("ReportCode","ItemUpdate");
		setMap.put("Contents","XBOLTADM.DLENC_ACP_ITEM_UPDATE_BATCH");
		commonService.insert("zDLENC_SQL.insertBatchJobLog", setMap);
		String BatchJobNo = commonService.selectString("zDLENC_SQL.getMaxBatchJobNoString", setMap);
		setMap.put("BatchJobNo",BatchJobNo);		
		try{
			commonService.insert("zDLENC_SQL.getDLENC_UpdateViewActyData", setMap);
			
			setMap.put("Status","02");
			commonService.update("zDLENC_SQL.UpdateBatchJobLog",setMap);
			
			LocalDateTime end = LocalDateTime.now();
			Duration duration = Duration.between(start, end);
			System.out.println(">>> exeBatchUpdateItem 성공 & | 완료 시각: " + end.format(formatter) + " | 실행 시간: " + duration.toMillis() + " ms");
		
		} catch (Exception e) {
			setMap.put("Status","03");
			commonService.select("zDLENC_SQL.UpdateBatchJobLog", setMap);
			e.printStackTrace(); 
			if(_log.isInfoEnabled()){_log.info("DLENCBatchActionController::Error::"+e);}
		}	
	}
	
	
		//모델 선후행 검증 후 삭제 프로시저 배치
		public void exeBatchDeleteModelPrePost() throws Exception {
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");
			LocalDateTime start = LocalDateTime.now();

			System.out.println(">>> exeBatchDeleteModelPrePost 호출됨 - 시작 시각: " + start.format(formatter));
			HashMap setMap = new HashMap();
			setMap.put("ReportCode","D_Model");
			setMap.put("Contents","XBOLTADM.DELETE_MODEL_CHK_PREPOST");
			commonService.insert("zDLENC_SQL.insertBatchJobLog", setMap);
			String BatchJobNo = commonService.selectString("zDLENC_SQL.getMaxBatchJobNoString", setMap);
			setMap.put("BatchJobNo",BatchJobNo);
			try{
				commonService.insert("zDLENC_SQL.batchDeleteModelPrePost", setMap);
				
				setMap.put("Status","02");
				commonService.update("zDLENC_SQL.UpdateBatchJobLog",setMap);
				
				LocalDateTime end = LocalDateTime.now();
				Duration duration = Duration.between(start, end);
				System.out.println(">>> exeBatchDeleteModelPrePost 성공 + | 완료 시각: " + end.format(formatter) + " | 실행 시간: " + duration.toMillis() + " ms");

			} catch (Exception e) {
				setMap.put("Status","03");
				commonService.select("zDLENC_SQL.UpdateBatchJobLog", setMap);
				e.printStackTrace(); 
				if(_log.isInfoEnabled()){_log.info("DLENCBatchActionController::Error::"+e);}
			}	
		}
		
	
	
	//주토플 현장 모델 전체 생성 프로시저 배치
	public void exeBatchCreateModelACP() throws Exception {
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");
		LocalDateTime start = LocalDateTime.now();

		System.out.println(">>> exeBatchCreateModelACP 호출됨 ( - 시작 시각: " + start.format(formatter));
		HashMap setMap = new HashMap();
		setMap.put("ReportCode","C_Model");
		setMap.put("Contents","XBOLTADM.ATO_CRTE_MDL_A&XBOLTADM.ATO_CRTE_MDL_C");
		commonService.insert("zDLENC_SQL.insertBatchJobLog", setMap);
		String BatchJobNo = commonService.selectString("zDLENC_SQL.getMaxBatchJobNoString", setMap);
		setMap.put("BatchJobNo",BatchJobNo);
		try{
			commonService.insert("zDLENC_SQL.batchCreateModelA", setMap);
			commonService.insert("zDLENC_SQL.batchCreateModelC", setMap);
			commonService.insert("zDLENC_SQL.batchCreateModelP", setMap);
			
			setMap.put("Status","02");
			commonService.update("zDLENC_SQL.UpdateBatchJobLog",setMap);
			
			LocalDateTime end = LocalDateTime.now();
			Duration duration = Duration.between(start, end);
			System.out.println(">>> exeBatchCreateModelACP 성공 ) | 완료 시각: " + end.format(formatter) + " | 실행 시간: " + duration.toMillis() + " ms");

		} catch (Exception e) {			
			setMap.put("Status","03");
			commonService.select("zDLENC_SQL.UpdateBatchJobLog", setMap);
			
			e.printStackTrace(); 
			if(_log.isInfoEnabled()){_log.info("DLENCBatchActionController::Error::"+e);}
		}	
	}
		

	//주토플 현장 tree + item insert만 예약 배치
	public void exeBatchAVLvLTree() throws Exception {
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");
		LocalDateTime start = LocalDateTime.now();

		System.out.println(">>> exeBatchAVLvLTree 호출됨 $ - 시작 시각: " + start.format(formatter));
	    
		HashMap setMap = new HashMap();
		
		try {
	    	String today = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
	    	
	    	setMap.put("ReportCode","ActyBatch");
	    	setMap.put("Contents","XBOLTADM.DLENC_ACP_TREE_BATCH&XBOLTADM.DLENC_ACP_ITEM_BATCH");
    		commonService.insert("zDLENC_SQL.insertBatchJobLog", setMap);
    		String BatchJobNo = commonService.selectString("zDLENC_SQL.getMaxBatchJobNoString", setMap);
    		setMap.put("BatchJobNo",BatchJobNo);
    		
	    	// 오늘자 execDate가 READY 상태인지 확인 (Comment 컬럼 = 오늘 날짜)
	        Map<String, Object> param = new HashMap<>();
	        param.put("BatName", "FETCH_ACP_LvL_Item");
	        param.put("ExecDate", today);
	        
	        List<Map<String, Object>> readyItems = commonService.selectList("zDLENC_SQL.selectReadyItemIDs", param);

	        if (readyItems == null || readyItems.isEmpty()) {
	            System.out.println(">>> 오늘 날짜에 대한 READY 상태 itemID 없음 → 종료");
	            return;
	        }else {
	        
	        // itemID별 프로시저 실행
	        for (Map<String, Object> item : readyItems) {
	        	Long itemID = (Long) item.get("ItemID");

	            Map<String, Object> execParam = new HashMap<>();
	            execParam.put("itemID", itemID);

	    		
	            commonService.select("zDLENC_SQL.getDLENC_FetchViewTreeData", execParam);
	            commonService.select("zDLENC_SQL.getDLENC_FetchViewActyData", execParam);
	            	            
	            System.out.println(">>> itemID: " + itemID + " 프로시저 실행 완료");
	        }
	        	setMap.put("Status","02");
	        	commonService.update("zDLENC_SQL.UpdateBatchJobLog",setMap);
		        LocalDateTime end = LocalDateTime.now();
				Duration duration = Duration.between(start, end);
				System.out.println(">>> exeBatchAVLvLTree 완료됨 % | 완료 시각: " + end.format(formatter) + " | 실행 시간: " + duration.toMillis() + " ms");

	    	}

	    } catch (Exception e) {
	    	 e.printStackTrace(); 
				setMap.put("Status","03");
				commonService.select("zDLENC_SQL.UpdateBatchJobLog", setMap);
	    	    if (_log.isInfoEnabled()) {
	    	        _log.info("DLENCBatchActionController::Error::" + e);
	    	    }
	    }
	}
	
	public void exeAllBatches() throws Exception {
		
		  exeBatchAVLvLTree();
		  //exeBatchDeleteModelPrePost();
		  exeBatchUpdateItem(); 		  
		  exeBatchCreateModelACP();
		  // Bean 주입 대신 직접 생성
		  String url = "http://localhost/custom/daelim/dlenc/XMLProcessing.do";
		  RestTemplate restTemplate = new RestTemplate();
		  String result = restTemplate.getForObject(url, String.class);
		  System.out.println("HTTP 호출 결과: " + result);	  
	}

	
}