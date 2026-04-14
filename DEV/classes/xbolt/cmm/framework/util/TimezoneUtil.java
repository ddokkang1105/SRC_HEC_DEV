package xbolt.cmm.framework.util;

import xbolt.cmm.framework.val.TimezoneGlobalVal;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Optional;

/**
 * TimezoneUtil
 *
 * @version 1.0
 * @Class Name : TimezoneUtil.java
 * @Description : ServerTimezone <-> UserTimezone 변환
 * @Modification Information
 * @수정일 수정자        수정내용
 * @--------- ---------	-------------------------------
 * @2025. 07. 21.	kgy		최초생성
 * @see
 * @since 2025. 07. 21.
 */

public class TimezoneUtil {

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final DateTimeFormatter DATETIME_MINUTE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
    private static final DateTimeFormatter DATETIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private static final DateTimeFormatter DATETIME_MILLIS_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");


    // SELECT
    //LocalDateTime : DB datetime
    public static Optional<LocalDateTime> convertToUserTimeZone(LocalDateTime datetime, String userTimeZoneId) {

        try{
            if (isEmpty(userTimeZoneId)) return Optional.empty();
            ZonedDateTime serverZoned = datetime.atZone(ZoneId.of(TimezoneGlobalVal.SERVER_TIMEZONE));
            return Optional.of(serverZoned.withZoneSameInstant(ZoneId.of(userTimeZoneId)).toLocalDateTime());
        }catch(Exception e){
            return Optional.empty();
        }

    }

    // INSERT & UPDATE
    public static Optional<LocalDateTime> convertToServerTimeZone(LocalDateTime datetime, String userTimeZoneId) {

        try{
            if (isEmpty(userTimeZoneId)) return Optional.empty();
            ZonedDateTime userZoned = datetime.atZone(ZoneId.of(userTimeZoneId));
            return Optional.of(userZoned.withZoneSameInstant(ZoneId.of(TimezoneGlobalVal.SERVER_TIMEZONE)).toLocalDateTime());
        }catch(Exception e){
            return Optional.empty();
        }

    }

    /**
     * Datetime(yyyy-MM-dd HH:mm:ss.SSS) -> String으로 변환
     * @param datetime
     * @return Optional
     */
    //DatetimeMillis -> String(Datetime Mills)
    public static Optional<String> datetimeMillisToStringFormat(LocalDateTime datetime) {
        try{
            return Optional.of(datetime.format(DATETIME_MILLIS_FORMATTER));
        }catch(Exception e){
            //throw new IllegalArgumentException("Invalid Datetime format");
            return Optional.empty();
        }
    }

    //Datetime -> String(DateTime)
    public static Optional<String> datetimeToStringFormat(LocalDateTime datetime) {
        try{
            return Optional.of(datetime.format(DATETIME_FORMATTER));
        }catch(Exception e){
            //throw new IllegalArgumentException("Invalid Datetime format");
            return Optional.empty();
        }
    }
    //Datetime -> String(Date)
    public static Optional<String> dateToStringFormat(LocalDateTime datetime) {
        try{
            return Optional.of(datetime.format(DATE_FORMATTER));
        }catch(Exception e){
            //throw new IllegalArgumentException("Invalid Datetime format");
            return Optional.empty();
        }
    }

    /**
     * String -> Datetime(yyyy-MM-dd HH:mm:ss.SSS)
     * @param strDatetime
     * @return Optional
     */
    public static Optional<LocalDateTime> parseStringToDatetime(String strDatetime){

        try{

            Optional<LocalDateTime> millis = stringDatetimeMillisToDatetimeFormat(strDatetime);
            if(millis.isPresent()) return millis;

            Optional<LocalDateTime> datetime = stringDatetimeToDatetimeFormat(strDatetime);
            if(datetime.isPresent()) return datetime;

            Optional<LocalDateTime> minute = stringDatetimeMinuteToDatetimeFormat(strDatetime);
            if (minute.isPresent()) return minute;

            Optional<LocalDateTime> date = stringDateToDatetimeFormat(strDatetime);
            if(date.isPresent()) return date;

            return Optional.empty();

        }catch(Exception e){
            return Optional.empty();
        }
    }
    //String -> Datetime
    public static Optional<LocalDateTime> stringDatetimeToDatetimeFormat(String strDatetime) {

        try{
            return Optional.of(LocalDateTime.parse(strDatetime, DATETIME_FORMATTER));
        }catch(Exception e){
            return Optional.empty();
        }

    }
    public static Optional<LocalDateTime> stringDatetimeMillisToDatetimeFormat(String strDatetime) {

        try{
            return Optional.of(LocalDateTime.parse(strDatetime, DATETIME_MILLIS_FORMATTER));
        }catch(Exception e){
            return Optional.empty();
        }

    }
    public static Optional<LocalDateTime> stringDateToDatetimeFormat(String strDatetime) {

        try{
            return Optional.of(LocalDate.parse(strDatetime, DATE_FORMATTER).atStartOfDay());
        }catch(Exception e){
            return Optional.empty();
        }

    }

    public static Optional<LocalDateTime> stringDatetimeMinuteToDatetimeFormat(String strDatetime) {
        try {
            LocalDateTime datetime = LocalDateTime.parse(strDatetime, DATETIME_MINUTE_FORMATTER);
            return Optional.of(datetime.withSecond(0).withNano(0));
        } catch (Exception e) {
            return Optional.empty();
        }
    }



    /**
     * Empty Check
     * @param value
     * @return
     */
    public static boolean isEmpty(Object value){
        return value == null || value.toString().trim().isEmpty();
    }


}
