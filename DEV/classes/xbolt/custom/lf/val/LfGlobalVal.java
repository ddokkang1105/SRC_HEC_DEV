package xbolt.custom.lf.val;

import xbolt.cmm.framework.val.GetProperty;

public class LfGlobalVal {	
	public static final String DB_KEY = "2DAE49B9205DC3E7";	
	
	//LGF SAP
	private static String initFile = "otherSystemContent.properties";
	public static xbolt.cmm.framework.val.GetProperty lfproperty = new xbolt.cmm.framework.val.GetProperty(initFile);
	
	
	public static final String SAP_MAX_CONNECT = lfproperty.getProperty("LF_SAP_MAX_CONNECT");//개발 -50, 운영-100	
	public static final String SAP_CLIENT_NO = lfproperty.getProperty("LF_SAP_CLIENT_NO");//개발계-700, 운영-100	
	public static final String SAP_USER_ID = lfproperty.getProperty("LF_SAP_USER_ID");	//개발계-IF_IDMS, 운영-IF_IDMS
	public static final String SAP_PASSWORD = lfproperty.getProperty("LF_SAP_PASSWORD");	//개발계-ifadminidms0, 운영-ifadminidms0
	public static final String SAP_LANGUAGE = lfproperty.getProperty("LF_SAP_LANGUAGE");	//개발계-KO, 운영-KO
	public static final String SAP_SERVER_IP = lfproperty.getProperty("LF_SAP_SERVER_IP");	//개발계-165.244.231.75, 운영-165.244.231.68
	public static final String SAP_SYSTEM_NO = lfproperty.getProperty("LF_SAP_SYSTEM_NO");	//개발계-00, 운영-00
	public static final String SAP_SYSTEM_ID = lfproperty.getProperty("LF_SAP_SYSTEM_ID");	//개발계-LFD_POS, 운영-LFP_POS
	public static final String SAP_R3_NAME = lfproperty.getProperty("LF_SAP_R3_NAME");	//개발계-LFD, 운영-LFP
	public static final String SAP_HOST_NAME = lfproperty.getProperty("LF_SAP_HOST_NAME");	//개발계-LGFERPDEV, 운영-LGFLFPDB0
	public static final String SAP_SERVER_NAME = lfproperty.getProperty("LF_SAP_SERVER_NAME");	//개발계-LGFERPDEV_LFD_00, 운영-LGFERP_REAL
	public static final String SAP_POOL_NAME = lfproperty.getProperty("LF_SAP_POOL_NAME");	//개발계-SAP_POOL_NAME, 운영-SAP_POOL_NAME
	public static final String SAP_GROUP = lfproperty.getProperty("LF_SAP_GROUP");	//개발계-LGFDEV, 운영-LGFLFP
	
	//LGF WEP
	public static final String WEB_MDP_URL = lfproperty.getProperty("LF_WEB_MDP_URL");	
	public static final String WEB_PLM_URL = lfproperty.getProperty("LF_WEB_PLM_URL");	
	
}
