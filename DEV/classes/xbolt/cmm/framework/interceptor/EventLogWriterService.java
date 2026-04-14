package xbolt.cmm.framework.interceptor;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import xbolt.cmm.service.CommonService;

import java.util.Map;

@Service
public class EventLogWriterService {

    private final CommonService commonService;

    public EventLogWriterService(CommonService commonService) {
        this.commonService = commonService;
    }

    /**
     * EVENT_LOG 테이블에 INSERT
     * REQUIRES_NEW 로 분리된 독립 트랜잭션에서 실행됨
     */

    @Transactional(transactionManager =  "transactionManager", propagation = Propagation.REQUIRES_NEW, rollbackFor = Exception.class)
    public void insertEventLog(Map<String, Object> param) {
        try {
            // 반영시 주석 해제
            // commonService.insert("gloval_SQL.insertEventLog", param);
        } catch (Exception e) {
            System.err.println(">>> [EVENT_LOG WARN] 로그 테이블 접근 실패: " + e.getMessage());
        }
    }

}
