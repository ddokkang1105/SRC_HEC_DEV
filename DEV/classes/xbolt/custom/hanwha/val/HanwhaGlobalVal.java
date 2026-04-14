package xbolt.custom.hanwha.val;

import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GetProperty;

public class HanwhaGlobalVal {	
	public static final String DB_KEY = "2DAE49B9205DC3E7";	
	
	private static String initFile = "otherSystemContent.properties";
	public static xbolt.cmm.framework.val.GetProperty htcproperty = new xbolt.cmm.framework.val.GetProperty(initFile);
	
	/** HANWHA Sigle Sign On */
	public static final String HW_WSDL_SERVICE_URL = StringUtil.checkNull(GetProperty.getProperty("HW_WSDL_SERVICE_URL")).trim();
	
	public static final String HW_COMPANY_ID = StringUtil.checkNull(GetProperty.getProperty("HW_COMPANY_ID")).trim();
	public static final String HW_SYSTEM_ID = StringUtil.checkNull(GetProperty.getProperty("HW_SYSTEM_ID")).trim();
	
	public static final String HW_ADRM_WSDL_SERVICE_URL = StringUtil.checkNull(GetProperty.getProperty("HW_ADRM_WSDL_SERVICE_URL")).trim();
	public static final String HW_ADRM_WS_KEY = StringUtil.checkNull(GetProperty.getProperty("HW_ADRM_WS_KEY")).trim(); 
	public static final String HW_ADRM_SERVICE_CODE = StringUtil.checkNull(GetProperty.getProperty("HW_ADRM_SERVICE_CODE")).trim();
	public static final String HW_GROUPWARE_URL = StringUtil.checkNull(GetProperty.getProperty("HW_GROUPWARE_URL")).trim();
}
