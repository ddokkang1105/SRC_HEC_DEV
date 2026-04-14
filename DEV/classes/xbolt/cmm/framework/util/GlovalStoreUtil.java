package xbolt.cmm.framework.util;

import xbolt.cmm.service.dao.CommonMsDao;
import xbolt.cmm.service.dao.CommonOraDao;


/**
 * @Class Name : GlovalStoreUtil.java
 * @Description : 기본서비스 틀을 잡기 위함
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2012. 09. 01. smartfactory		최초생성
 *
 * @since 2012. 09. 01.
 * @version 1.0
 * @see
 * 
 * Copyright (C) 2012 by SMARTFACTORY All right reserved.
 */
@SuppressWarnings("unchecked")
public class GlovalStoreUtil {
	
	private CommonMsDao commonDao;
	private CommonOraDao commonOraDao;
	
	public GlovalStoreUtil(CommonMsDao commonDao) {
		this.commonDao = commonDao;
		//this.commonOraDao = commonOraDao;
	}

	public GlovalStoreUtil(CommonOraDao commonOraDao) {
		//this.commonDao = commonDao;
		this.commonOraDao = commonOraDao;
	}
	public void setCommonDao(CommonMsDao commonDao) {
		this.commonDao = commonDao;
	}
	public void setCommonOraDao(CommonOraDao commonOraDao) {
		this.commonOraDao = commonOraDao;
	}
}
