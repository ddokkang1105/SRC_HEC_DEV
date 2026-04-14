package xbolt.cmm.framework.util;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.*;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import xbolt.cmm.framework.val.GlobalVal;


/**
 * CJGLOBAL File DRM 적용
 * @Class Name : DRMUtil.java
 * @Description : CJ File DRM 적용 관련 함수 
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2017. 04. 28. smartfactory		최초생성
 *
 * @since 2017. 04. 28.
 * @version 1.0
 * @see
 * 
 * Copyright (C) 2013 by SMARTFACTORY All right reserved.
 */
@SuppressWarnings("unused")
public class DRMUtil {	
	
	public static String drmMgt(HashMap drmMap) throws ExceptionUtil{
		String returnValue = "";
		String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
		String className = "xbolt.cmm.framework.util.drm.DRM_" + useDRM;
		Object returnVal = null;
		try {

			Class classInfo = Class.forName(className);
			
			Object obj = classInfo.newInstance();
	  
			String funcType = StringUtil.checkNull(drmMap.get("funcType"));
	        Method methods = obj.getClass().getMethod(funcType,new Class[]{HashMap.class});
	        returnVal = methods.invoke(obj,drmMap);
        
        } catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (NoSuchMethodException e) {
			e.printStackTrace();
		} catch (SecurityException e) {
			e.printStackTrace();
		} catch (IllegalArgumentException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		return returnVal.toString();
	}
	
}
