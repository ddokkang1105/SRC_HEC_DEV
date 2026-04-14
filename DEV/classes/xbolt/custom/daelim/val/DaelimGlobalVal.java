package xbolt.custom.daelim.val;

import xbolt.cmm.framework.val.GetProperty;

public class DaelimGlobalVal {		
	private static String initFile = "otherSystemContent.properties";
	public static xbolt.cmm.framework.val.GetProperty dlproperty = new xbolt.cmm.framework.val.GetProperty(initFile);


	public static final String WEB_BP_URL = dlproperty.getProperty("IEP_POP_URL");
	public static final String DLM_WEBSERVICE_URL = dlproperty.getProperty("DLM_WEBSERVICE_URL");
	public static final String DLM_GW_URL = dlproperty.getProperty("DLM_GW_URL");
	public static final String DLM_PUSH_serverUrl = dlproperty.getProperty("DLM_PUSH_serverUrl");
	public static final String DLM_PUSH_appId = dlproperty.getProperty("DLM_PUSH_appId");
	public static final String DLM_PUSH_serviceCode = dlproperty.getProperty("DLM_PUSH_serviceCode");
	public static final String DLM_PUSH_sendsmsYn = dlproperty.getProperty("DLM_PUSH_sendsmsYn");
	public static final String DLM_PUSH_senderCode = dlproperty.getProperty("DLM_PUSH_senderCode");
	public static final String DLM_PUSH_senderName = dlproperty.getProperty("DLM_PUSH_senderName");
	public static final String DLM_PUSH_senderNum = dlproperty.getProperty("DLM_PUSH_senderNum");
	


}
