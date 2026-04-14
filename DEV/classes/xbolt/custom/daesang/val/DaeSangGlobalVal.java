package xbolt.custom.daesang.val;

import xbolt.cmm.framework.val.GetProperty;

public class DaeSangGlobalVal {		
	private static String initFile = "otherSystemContent.properties";
	public static xbolt.cmm.framework.val.GetProperty dlproperty = new xbolt.cmm.framework.val.GetProperty(initFile);


	public static final String DS_ERP_URL = dlproperty.getProperty("DS_ERP_URL");



}
