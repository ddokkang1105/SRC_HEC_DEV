package xbolt.cmm.framework.interceptor;


import org.apache.ibatis.executor.Executor;
import org.apache.ibatis.mapping.MappedStatement;
import org.apache.ibatis.mapping.SqlCommandType;
import org.apache.ibatis.plugin.*;
import org.apache.ibatis.session.ResultHandler;
import org.apache.ibatis.session.RowBounds;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import xbolt.cmm.framework.util.TimezoneThreadLocal;
import xbolt.cmm.framework.util.TimezoneUtil;
import xbolt.cmm.framework.val.TimezoneGlobalVal;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

/**
 * TimezoneInterceptor
 *
 * @version 1.0
 * @Class Name : TimezoneInterceptor.java
 * @Description : Timezone을 위한 Mybatis Interceptor
 * @Modification Information
 * @수정일 수정자        수정내용
 * @--------- ---------	-------------------------------
 * @2025. 07. 21.	kgy		최초생성
 * @see
 * @since 2025. 07. 21.
 */
@Intercepts({
        @Signature(type = Executor.class, method = "query", args = {MappedStatement.class, Object.class, RowBounds.class, ResultHandler.class}),
        @Signature(type = Executor.class, method = "update", args = {MappedStatement.class, Object.class})
})
public class TimezoneInterceptor implements Interceptor {

    private static final Logger logger = LoggerFactory.getLogger(TimezoneInterceptor.class);
    private Set<String> keyColumns;
    private Set<String> dateColumns;

    private Set<String> queryMethods;

    @Override
    public Object intercept(Invocation invocation) throws Throwable {



        if (keyColumns == null || dateColumns == null || queryMethods == null) initColumnsProperty();

        String userTimezone = TimezoneThreadLocal.get();
        String serverTimezone = TimezoneGlobalVal.SERVER_TIMEZONE;
        try {

            if (keyColumns.isEmpty()) return invocation.proceed();
            if (TimezoneUtil.isEmpty(userTimezone)) return invocation.proceed();
            if (userTimezone.equals(serverTimezone)) return invocation.proceed();

            Object[] args = invocation.getArgs();
            MappedStatement mappedStatement = (MappedStatement) args[0];
            SqlCommandType commandType = mappedStatement.getSqlCommandType();


            String statementId = mappedStatement.getId();
            String queryMethod = statementId.substring(statementId.lastIndexOf('.') + 1);
            if (!queryMethods.contains(queryMethod)) return invocation.proceed();


            // INSERT/DELETE
            if (commandType == SqlCommandType.INSERT || commandType == SqlCommandType.UPDATE) {
                Object parameter = args[1];

                if (parameter instanceof List<?>) {
                    //List Map일 경우
                    List<?> list = (List<?>) parameter;
                    for (Object obj : list) {
                        if (obj instanceof Map<?, ?>) {
                            convertServerTimezoneToUserTimezone((Map<String, Object>) obj, userTimezone);
                        }
                    }
                } else if (parameter instanceof Map<?, ?>) {
                    //Map일 경우
                    convertUserTimezoneToServerTimezone((Map<String, Object>) parameter, userTimezone);
                }

                return invocation.proceed();
            }


            Object result = invocation.proceed();

            // SELECT
            if (commandType == SqlCommandType.SELECT) {
                if (result instanceof List<?>) {
                    //List Map일 경우
                    List<?> list = (List<?>) result;
                    for (Object obj : list) {
                        if (obj instanceof Map<?, ?>) {
                            convertServerTimezoneToUserTimezone((Map<String, Object>) obj, userTimezone);
                        }
                    }
                } else if (result instanceof Map<?, ?>) {
                    //Map일 경우
                    convertServerTimezoneToUserTimezone((Map<String, Object>) result, userTimezone);
                }
                // TODO : 속도 느릴 시 stream 병렬 처리 고려
            }

            return result;

        } catch (Exception e) {
            logger.error("Timezone Interceptor Error 발생", e);
            throw e;
        }
    }


    @Override
    public Object plugin(Object target) {
        return Plugin.wrap(target, this);
    }

    @Override
    public void setProperties(Properties properties) {

    }

    /**
     * SELECT
     *
     * Server -> User(조회)
     * Server String ('yyyy-mm-dd') -> Server DateTime('yyyy-mm-dd hh:mm:ss.SSS') -> User DateTime ('yyyy-mm-dd hh:mm:ss.SSS') -> User String ('yyyy-mm-dd hh:mm:ss.SSS' or 'yyyy-mm-dd hh:mm:ss' or 'yyyy-mm-dd')
     * Server String ('yyyy-mm-dd hh:mm') -> Server DateTime('yyyy-mm-dd hh:mm:ss.SSS') -> User DateTime('yyyy-mm-dd hh:mm:ss.SSS') -> User String ('yyyy-mm-dd hh:mm:ss.SSS' or 'yyyy-mm-dd hh:mm:ss' or 'yyyy-mm-dd')
     * Server String ('yyyy-mm-dd hh:mm:ss') -> Server DateTime('yyyy-mm-dd hh:mm:ss.SSS') -> User DateTime('yyyy-mm-dd hh:mm:ss.SSS') -> User String ('yyyy-mm-dd hh:mm:ss.SSS' or 'yyyy-mm-dd hh:mm:ss' or 'yyyy-mm-dd')
     * Server String ('yyyy-mm-dd hh:mm:ss.SSS') -> Server DateTime('yyyy-mm-dd hh:mm:ss.SSS') -> User DateTime('yyyy-mm-dd hh:mm:ss.SSS') -> User String ('yyyy-mm-dd hh:mm:ss.SSS' or 'yyyy-mm-dd hh:mm:ss' or 'yyyy-mm-dd')
     * <p>
     * 모든 Exception 발생 시 (NPE, input 규격 맞지않음) -> 그대로 통과
     */
    public void convertServerTimezoneToUserTimezone(Map<String, Object> map, String userTimezone) {

        for (Map.Entry<String, Object> entry : map.entrySet()) {
            String key = entry.getKey();
            Object value = entry.getValue();

            if (!keyColumns.contains(key) || TimezoneUtil.isEmpty(value)) continue;

            try {
                System.out.println("SELECT -> Timezone 변환 진행 중 : " + key + ", value : " + value);
                Optional.ofNullable((String) value)
                        .flatMap(TimezoneUtil::parseStringToDatetime)
                        .flatMap(serverDateTime -> TimezoneUtil.convertToUserTimeZone(serverDateTime, userTimezone))
                        .flatMap(dateColumns.contains(key) ? (TimezoneUtil::dateToStringFormat) : (TimezoneUtil::datetimeToStringFormat)
                        ).ifPresent(result -> {
                            System.out.println("Timezone 변환 성공 : " + key + ", value : " + value + " -> " + result);
                            entry.setValue(result);
                        });

            } catch (Exception e) {
                logger.warn("Timezone 변환 실패 : key = {}, value = {}", key, value, e);
            }
        }
    }

    /**
     * INSERT/UPDATE
     *
     * User -> Server(INSERT/UPDATE)
     * User String ('yyyy-mm-dd hh:mm:ss') -> User DateTime('yyyy-mm-dd hh:mm:ss.SSS') -> Server DateTime('yyyy-mm-dd hh:mm:ss.SSS') -> Server String ('yyyy-mm-dd hh:mm:ss.SSS')
     * User String ('yyyy-mm-dd hh:mm') -> User DateTime('yyyy-mm-dd hh:mm:ss.SSS') -> Server DateTime('yyyy-mm-dd hh:mm:ss.SSS') -> Server String ('yyyy-mm-dd hh:mm:ss.SSS')
     * User String ('yyyy-mm-dd') -> User DateTime('yyyy-mm-dd hh:mm:ss.SSS') -> Server DateTime('yyyy-mm-dd hh:mm:ss.SSS') -> Server String ('yyyy-mm-dd hh:mm:ss.SSS')
     * User String ( Empty ) -> User Current DateTime -> Server DateTime -> Server String ('yyyy-mm-dd hh:mm:ss.SSS')
     * <p>
     * 모든 Exception 발생 시 (NPE, input 규격 맞지않음) -> 그대로 통과
     */
    public void convertUserTimezoneToServerTimezone(Map<String, Object> map, String userTimezone) {

        for (Map.Entry<String, Object> entry : map.entrySet()) {
            String key = entry.getKey();
            Object value = entry.getValue();

            if (!keyColumns.contains(key)) continue;

            try {
                /**
                 * TODO: 값이 없다면 현재 시간으로 입력
                 * map에 key 없음 -> query상 getDate()로 입력
                 * map에 key 필요 + query상 getDate() #{}로 수정
                 */

                System.out.println("INSERT/UPDATE -> Timezone 변환 진행 중 : " + key + ", value : " + value);
                //User로부터 날짜 정보를 안받는 경우(getDate)
                if (TimezoneUtil.isEmpty(value)) {
                    TimezoneUtil.datetimeMillisToStringFormat(LocalDateTime.now())
                            .ifPresent(nowDatetimeStr -> {
                                System.out.println("Timezone 변환 성공 : " + key + ", value : " + value + " -> " + nowDatetimeStr);
                                entry.setValue(nowDatetimeStr);
                            });
                    continue;
                }

                //User로부터 날짜 정보를 넘겨받을 경우
                Optional.ofNullable((String) value)
                        .flatMap(TimezoneUtil::parseStringToDatetime)
                        .flatMap(userDateTime -> TimezoneUtil.convertToServerTimeZone(userDateTime, userTimezone))
                        .flatMap(TimezoneUtil::datetimeMillisToStringFormat)
                        .ifPresent(result -> {
                            System.out.println("Timezone 변환 성공 : " + key + ", value : " + value + " -> " + result);
                            entry.setValue(result);
                        });

            } catch (Exception e) {
                logger.warn("Timezone 변환 실패 : key = {}, value = {}", key, value, e);
            }
        }
    }

    private Set<String> convertStringToSet(String globalVal) {
        return Optional.ofNullable(globalVal)
                .filter(value -> !value.isEmpty())
                .map(str -> Arrays.stream(str.split(","))
                        .map(String::trim)
                        .collect(Collectors.toSet()))
                .orElseGet(Collections::emptySet);
    }

    public void initColumnsProperty() {
        keyColumns = convertStringToSet(TimezoneGlobalVal.KEY_COLUMNS_TIMEZONE);
        dateColumns = convertStringToSet(TimezoneGlobalVal.DATE_COLUMNS_TIMEZONE);
        queryMethods = convertStringToSet(TimezoneGlobalVal.QUERY_METHOD_TIMEZONE);
    }

}


