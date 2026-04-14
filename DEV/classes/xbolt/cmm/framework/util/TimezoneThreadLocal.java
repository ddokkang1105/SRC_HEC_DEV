package xbolt.cmm.framework.util;


/**
 * TimezoeThreadLocal
 *
 * @version 1.0
 * @Class Name : TimezoneThreadLocal.java
 * @Description : Filter -> MyBatis Interceptor에 session 정보 전달
 * @Modification Information
 * @수정일 수정자        수정내용
 * @--------- ---------	-------------------------------
 * @2025. 07. 21.	kgy		최초생성
 * @see
 * @since 2025. 07. 21.
 */
public class TimezoneThreadLocal {

    private static final ThreadLocal<String> timezone = new ThreadLocal<>();

    public static void set(String userTimezone) {
        timezone.set(userTimezone);
    }

    public static String get() {
        return timezone.get();
    }

    public static void clear() {
        timezone.remove();
    }

}
