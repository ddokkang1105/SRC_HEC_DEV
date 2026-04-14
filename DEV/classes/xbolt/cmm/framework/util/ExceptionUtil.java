package xbolt.cmm.framework.util;

/**
 * @Class Name : ExceptionUtil.java
 * @Description : ExceptionUtil.java
 * @Modification Exception 처리용 클래스
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2017. 07. 03. smartfactory		최초생성
 *
 * @since 2017. 07. 03.
 * @version 1.0
 * @see
 * Copyright (C) 2017 by SMARTFACTORY All right reserved.
 */
@SuppressWarnings("unchecked")
public class ExceptionUtil extends Exception{
	
	public ExceptionUtil() {
	}
	
	public ExceptionUtil(String message) {
		super(message);
	}
}
