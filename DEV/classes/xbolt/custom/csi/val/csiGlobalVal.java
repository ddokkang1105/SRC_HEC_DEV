package xbolt.custom.csi.val;

import xbolt.cmm.framework.val.GetProperty;

public class csiGlobalVal {		
	private static String initFile = "otherSystemContent.properties";
	public static xbolt.cmm.framework.val.GetProperty dlproperty = new xbolt.cmm.framework.val.GetProperty(initFile);


	public static final String CSI_HOST = dlproperty.getProperty("CSI_HOST");
	public static final String CSI_BASEDN = dlproperty.getProperty("CSI_BASEDN");
	public static final String CSI_LDAP = dlproperty.getProperty("CSI_LDAP");



}
