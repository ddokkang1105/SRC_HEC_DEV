package xbolt.custom.mando.val;
import xbolt.cmm.framework.val.GetProperty;

public class MDGlobalVal {		
	

	private static String initFile = "otherSystemContent.properties";
	public static xbolt.cmm.framework.val.GetProperty MDproperty = new xbolt.cmm.framework.val.GetProperty(initFile);

	public static final String WEB_ERP_URL = "http://gerptap1.mando.com:8020/OA_HTML/RF.jsp";
	public static final String WEB_EAC_URL = "http://eac.mando.com:8000/ea/login/TokenAgent.do";// 8000번 운영, 8010 개발 http://eac.mando.com:8010/ea/login/loginUserIdCheck.do";
	
	public static final String WEB_SSO_URL = "http://gerptap1.mando.com:8020/OA_HTML/fndvald.jsp";
	/* 시스템 코드  */
	public static final String MND_SYS_KEY = MDproperty.getProperty("MND_SYS_KEY");
	/* 복호화 키  */
	public static final String MND_CONTENTS = MDproperty.getProperty("MND_CONTENTS");  

}


