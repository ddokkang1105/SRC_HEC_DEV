package xbolt.cmm.framework.val;

import xbolt.cmm.framework.util.StringUtil;

public class TimezoneGlobalVal {

    private static String initFile = "otherSystemContent.properties";

    public static xbolt.cmm.framework.val.GetProperty TimeZoneProperty = new xbolt.cmm.framework.val.GetProperty(initFile);

    //Timezone
    public static final String SERVER_TIMEZONE = StringUtil.checkNull(TimeZoneProperty.getProperty("SERVER_TIMEZONE"));
    public static final String KEY_COLUMNS_TIMEZONE = StringUtil.checkNull(TimeZoneProperty.getProperty("KEY_COLUMNS_TIMEZONE"));
    public static final String DATE_COLUMNS_TIMEZONE = StringUtil.checkNull(TimeZoneProperty.getProperty("DATE_COLUMNS_TIMEZONE"));
    public static final String QUERY_METHOD_TIMEZONE = StringUtil.checkNull(TimeZoneProperty.getProperty("QUERY_METHOD_TIMEZONE"));




}
