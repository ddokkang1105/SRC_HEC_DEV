package xbolt.custom.cj.val;

import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GetProperty;

public class CJGlobalVal {	
	public static final String DB_KEY = "2DAE49B9205DC3E7";	
	
	private static final String initFile = "otherSystemContent.properties";
	public static final xbolt.cmm.framework.val.GetProperty cjproperty = new xbolt.cmm.framework.val.GetProperty(initFile);
	
	
	/** CJ Single Sign On */
	public static final String CJ_SSO_URL = StringUtil.checkNull(cjproperty.getProperty("CJ_SSO_URL")).trim();
	
}
