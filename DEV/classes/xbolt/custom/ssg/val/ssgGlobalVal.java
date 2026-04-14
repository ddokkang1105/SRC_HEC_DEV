package xbolt.custom.ssg.val;

import xbolt.cmm.framework.util.StringUtil;

public class ssgGlobalVal {
	private static final String initFile = "otherSystemContent.properties";
	public static final xbolt.cmm.framework.val.GetProperty ssgproperty = new xbolt.cmm.framework.val.GetProperty(initFile);
	
	/** SSG Single Sign On */
	public static final String SSG_SSO_URL = StringUtil.checkNull(ssgproperty.getProperty("SSG_SSO_URL")).trim();
}
