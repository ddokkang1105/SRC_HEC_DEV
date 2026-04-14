package xbolt.cmm.framework.interceptor;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonService;

import java.util.HashMap;
import java.util.Map;

@Aspect
@Component
public class EventLogInterceptor {

    @Autowired
    private CommonService commonService;

    @Autowired
    private EventLogWriterService eventLogWriterService;

    /**
     * updateCSStatusForWF 실행 완료 후 (성공 시)
     */
    @AfterReturning(
            pointcut = "execution(* xbolt..*.updateCSStatusForWF(..))",
            returning = "retVal"
    )
    public void afterUpdateCSStatusForWF(JoinPoint joinPoint, Object retVal) {
        try {
            Object[] args = joinPoint.getArgs();
            if (args == null || args.length < 2 || !(args[1] instanceof Map)) return;

            @SuppressWarnings("unchecked")
            Map<String, Object> commandMap = (Map<String, Object>) args[1];

            String wfInstanceStatus = StringUtil.checkNull(commandMap.get("wfInstanceStatus"), "");
            String items = StringUtil.checkNull(commandMap.get("items"));
            String cngts = StringUtil.checkNull(commandMap.get("cngts"));

            if (items.isEmpty() || cngts.isEmpty()) return;

            if (!items.isEmpty()) {
                String[] itemsArray = items.split("\\s*,\\s*");
                String[] cngtsArray = cngts.split("\\s*,\\s*");
                int len = Math.min(itemsArray.length, cngtsArray.length);

                for (int i = 0; i < len; i++) {

                    String itemId = itemsArray[i];
                    String changeSetId = cngtsArray[i];

                    Map<String, Object> setMap = new HashMap<>();
                    setMap.put("s_itemID", itemId);
                    setMap.put("changeSetID",changeSetId);
                    String itemTypeCode = safeSelectString("config_SQL.getItemTypeCodeItemID", setMap);
                    String changeTypeCode = safeSelectString("cs_SQL.getChangeTypeCode", setMap);

                    // Tech Std
                    if (!"OJ00016".equals(itemTypeCode)) return;

                    if ("2".equals(wfInstanceStatus)) {
                        Map<String, Object> param = new HashMap<>();
                        param.put("objectID", itemId);
                        param.put("objectType", "ITM");
                        param.put("objectTypeCode", itemTypeCode);
                        param.put("completed", "N");
                        param.put("changeSetID", changeSetId);

                        if("NEW".equals(changeTypeCode)) {
                            param.put("operation", "create");
                        } else if("MOD".equals(changeTypeCode)) {
                            param.put("operation", "updated");
                        } else if("DEL".equals(changeTypeCode)) {
                            param.put("operation", "deleted");
                        } else {
                           return;
                        }

                        try {
                            eventLogWriterService.insertEventLog(param);
                            System.out.println(">>> [AOP] EVENT_LOG insert 완료 ObjectID: " + itemId);
                        } catch (Exception e) {
                            System.err.println(">>> [AOP ERROR] EVENT_LOG insert 실패 (" + itemId + "): " + e.getMessage());
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.err.println(">>> [AOP ERROR] EVENT_LOG 처리 중 오류: " + e.getMessage());
        }
    }

    private String safeSelectString(String queryId, Map<String, Object> params) {
        try {
            String result = commonService.selectString(queryId, params);
            return result == null ? "" : result;
        } catch (Exception e) {
            System.err.println(">>> [AOP WARN] selectString 실패 (" + queryId + "): " + e.getMessage());
            return "";
        }
    }

}
