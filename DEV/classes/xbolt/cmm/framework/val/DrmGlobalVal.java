package xbolt.cmm.framework.val;

import xbolt.cmm.framework.util.StringUtil;

public class DrmGlobalVal {		
	private static String initFile = "otherSystemContent.properties";
	public static xbolt.cmm.framework.val.GetProperty DrmProperty = new xbolt.cmm.framework.val.GetProperty(initFile);

	//MIP
	public static final String DRM_MIP_API_URL = StringUtil.checkNull(DrmProperty.getProperty("DRM_MIP_API_URL"));
	public static final String DRM_MIP_API_KEY = StringUtil.checkNull(DrmProperty.getProperty("DRM_MIP_API_KEY"));
	public static final String DRM_MIP_FILEPATH = StringUtil.checkNull(DrmProperty.getProperty("DRM_MIP_FILEPATH"));


	//DRM VIEW(SYNAP YN)
	public static final String DOC_VIEW_DRM = StringUtil.checkNull(DrmProperty.getProperty("DOC_VIEW_DRM"));
	public static final String DOC_DOWNLOAD_FASOO_YN = StringUtil.checkNull(DrmProperty.getProperty("DOC_DOWNLOAD_FASOO_YN"));

	//DRM SOFTCAMP(DOWNLOAD YN)
	public static final String DRM_SOFTCAMP_DOWN_USE = StringUtil.checkNull(DrmProperty.getProperty("DRM_SOFTCAMP_DOWN_USE"));

	//DRM FASOO
	public static final String DRM_FASOO_KEY_ID = StringUtil.checkNull(DrmProperty.getProperty("DRM_FASOO_KEY_ID"),""); 
	public static final String DRM_FASOO_DECODING_FILEPATH = StringUtil.checkNull(DrmProperty.getProperty("DRM_FASOO_DECODING_FILEPATH"));
	public static final String DRM_FASOO_MODULE_PATH = StringUtil.checkNull(DrmProperty.getProperty("DRM_FASOO_MODULE_PATH"),""); 
	public static final String DRM_FASOO_SECURITY_CODE = StringUtil.checkNull(DrmProperty.getProperty("DRM_FASOO_SECURITY_CODE"),""); 

	//DRM SOFTCAMP
	public static final String DRM_SOFTCAMP_KEY = StringUtil.checkNull(DrmProperty.getProperty("DRM_SOFTCAMP_KEY"));
	public static final String DRM_SOFTCAMP_MODULE_PATH = StringUtil.checkNull(DrmProperty.getProperty("DRM_SOFTCAMP_MODULE_PATH"));
	public static final String DRM_DECODING_FILEPATH = StringUtil.checkNull(DrmProperty.getProperty("DRM_DECODING_FILEPATH"),""); 
	
	public static final String AIP_NAS = StringUtil.checkNull(DrmProperty.getProperty("AIP_NAS"));
	public static final String AIP_SVR_ADDR = StringUtil.checkNull(DrmProperty.getProperty("AIP_SVR_ADDR"));
	public static final String AIP_SYS_ID = StringUtil.checkNull(DrmProperty.getProperty("AIP_SYS_ID"));
	public static final String FILE_AIP_EXTENSION = StringUtil.checkNull(DrmProperty.getProperty("FILE_AIP_EXTENSION"),"");
	
	public static final String AIP_SERVICEKEY = StringUtil.checkNull(DrmProperty.getProperty("AIP_SERVICEKEY"));
	
	public static final String PAPAGO_API_URL = StringUtil.checkNull(DrmProperty.getProperty("PAPAGO_API_URL"));
	public static final String PAPAGO_CLIENT_ID = StringUtil.checkNull(DrmProperty.getProperty("PAPAGO_CLIENT_ID"));
	public static final String PAPAGO_CLIENT_SECRET = StringUtil.checkNull(DrmProperty.getProperty("PAPAGO_CLIENT_SECRET"),"");

	
}
