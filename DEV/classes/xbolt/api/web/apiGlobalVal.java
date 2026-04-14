package xbolt.api.web;

import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GetProperty;

public class apiGlobalVal {
	private static String initFile = "otherSystemContent.properties";
	public static xbolt.cmm.framework.val.GetProperty apiProperty = new xbolt.cmm.framework.val.GetProperty(initFile);
	
	public static final String PAPAGO_API_URL = StringUtil.checkNull(apiProperty.getProperty("PAPAGO_API_URL"));
	public static final String PAPAGO_TRANS_CLIENT_ID = StringUtil.checkNull(apiProperty.getProperty("PAPAGO_TRANS_CLIENT_ID"));
	public static final String PAPAGO_TRANS_CLIENT_SECRET = StringUtil.checkNull(apiProperty.getProperty("PAPAGO_TRANS_CLIENT_SECRET"),"");
	public static final String PAPAGO_DECT_CLIENT_ID = StringUtil.checkNull(apiProperty.getProperty("PAPAGO_DECT_CLIENT_ID"));
	public static final String PAPAGO_DECT_CLIENT_SECRET = StringUtil.checkNull(apiProperty.getProperty("PAPAGO_DECT_CLIENT_SECRET"),"");
	
	public static final String OLM_API_KEY = StringUtil.checkNull(GetProperty.getProperty("OLM_API_KEY"));
	public static final String OLM_API_FILE_UPLOAD_PATH = StringUtil.checkNull(GetProperty.getProperty("OLM_API_FILE_UPLOAD_PATH"));

	public static final String GPTAI_API_URL = StringUtil.checkNull(apiProperty.getProperty("GPTAI_API_URL"));

}
