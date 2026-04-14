package xbolt.custom.youngone.val;

import xbolt.cmm.framework.val.GetProperty;

public class YoungOneGlobalVal {		
	private static String initFile = "otherSystemContent.properties";
	public static xbolt.cmm.framework.val.GetProperty yoproperty = new xbolt.cmm.framework.val.GetProperty(initFile);

	public static final String YO_GW_VIEW_URL = yoproperty.getProperty("YO_GW_VIEW_URL");
	public static final String INTERNAL_SERVER_URL = yoproperty.getProperty("INTERNAL_SERVER_URL"); // http://weclickdev.daelim.co.kr:8090/index.do , http://weclick.daelim.co.kr:8090/index.do

}
