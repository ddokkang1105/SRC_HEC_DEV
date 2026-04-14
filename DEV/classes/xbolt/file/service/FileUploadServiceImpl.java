package xbolt.file.service;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.AccessDeniedException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import xbolt.cmm.framework.util.DRMUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonDataServiceImpl;
import xbolt.cmm.service.CommonService;

@Service("fileUploadService")
@SuppressWarnings("unchecked")
public class FileUploadServiceImpl  extends CommonDataServiceImpl implements CommonService{
	
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Override
	public void save(List lst, Map map) throws Exception{

		if("insert".equals(map.get("KBN").toString())){
			for (int i = 0; i < lst.size(); i++) {
				Map data =(HashMap) lst.get(i);
				insert(data.get("SQLNAME").toString(), data);
			}
		} 
		
		if("update".equals(map.get("KBN").toString())){
			
			for (int i = 0; i < lst.size(); i++) {
				Map data =(HashMap) lst.get(i);
				update(data.get("SQLNAME").toString(), data);
			}
		} 
		
		if("delete".equals(map.get("KBN").toString())){
			for (int i = 0; i < lst.size(); i++) {
				Map data =(HashMap) lst.get(i);
				delete(map.get("SQLNAME").toString(), data);
			}
		} 

	}
	
	

}
