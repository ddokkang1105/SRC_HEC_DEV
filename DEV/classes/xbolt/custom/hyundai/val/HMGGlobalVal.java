package xbolt.custom.hyundai.val;

import xbolt.cmm.framework.val.GetProperty;

public class HMGGlobalVal {	
	public static final String DB_KEY = "2DAE49B9205DC3E7";	
	
	//LGF SAP
	private static String initFile = "otherSystemContent.properties";
	public static xbolt.cmm.framework.val.GetProperty HDCproperty = new xbolt.cmm.framework.val.GetProperty(initFile);
	
	
	public static final String lgySystemId = HDCproperty.getProperty("lgySystemId");
	public static final String wfDocOpenJspUrl = HDCproperty.getProperty("wfDocOpenJspUrl");
	public static final String wfViewAPIUrl = HDCproperty.getProperty("wfViewAPIUrl");
	public static final String wfDocViewJspUrl = HDCproperty.getProperty("wfDocViewJspUrl");
	public static final String dftCompId = HDCproperty.getProperty("dftCompId");
	//public static final String DRM_SOFTCAMP_KEY = HDCproperty.getProperty("DRM_SOFTCAMP_KEY");
	//public static final String DRM_SOFTCAMP_MODULE_PATH = HDCproperty.getProperty("DRM_SOFTCAMP_MODULE_PATH");
	public static final String wiseNutPopularURL = HDCproperty.getProperty("WISENUT_POPULAR_URL");
	
}
