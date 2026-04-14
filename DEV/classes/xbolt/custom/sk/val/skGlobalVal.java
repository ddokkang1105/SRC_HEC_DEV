package xbolt.custom.sk.val;

import xbolt.cmm.framework.val.GetProperty;

public class skGlobalVal {	
	public static final String DB_KEY = "2DAE49B9205DC3E7";	
	
	//SK Approval
	private static String initFile = "otherSystemContent.properties";
	public static xbolt.cmm.framework.val.GetProperty skproperty = new xbolt.cmm.framework.val.GetProperty(initFile);
	
	
	public static final String SK_MPM_URL = GetProperty.getProperty("SK_MPM_URL");
	public static final String SK_ACC_RJC_URL = GetProperty.getProperty("SK_ACC_RJC_URL");
	public static final String SK_LOGOUT_URL = GetProperty.getProperty("SK_LOGOUT_URL");
	public static final String FILE_UPLOAD_CTS_DIR = GetProperty.getProperty("FILE_UPLOAD_CTS_DIR");
	
	public static final String SK_MAIL_SERVER = GetProperty.getProperty("SK_MAIL_SERVER");
	public static final String SK_MAIL_TOKEN = GetProperty.getProperty("SK_MAIL_TOKEN");

}
