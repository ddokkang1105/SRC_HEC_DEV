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

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.val.GlobalVal;


/**
 * Link Parameter Enc
 * @Class Name : LinkEncUtil.java
 * @Description : Link Parameter Enc 관련 함수 
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2021. 11. 10. smartfactory		최초생성
 *
 * @since 2021. 11. 10.
 * @version 1.0
 * @see
 * 
 * Copyright (C) 2013 by SMARTFACTORY All right reserved.
 */
@SuppressWarnings("unused")
public class LinkEncUtil extends XboltController{	
	
	public static String getEncOutputKey(HashMap LinkMap) throws ExceptionUtil{
		String returnValue = StringUtil.checkNull(LinkMap.get("outputKey"),"");
	
		return returnValue;
	}
	
}
