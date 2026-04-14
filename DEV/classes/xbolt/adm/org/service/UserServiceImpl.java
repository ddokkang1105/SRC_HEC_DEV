package xbolt.adm.org.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonService;
import xbolt.cmm.service.CommonDataServiceImpl;


@Service("userService")
@SuppressWarnings("unchecked")
public class UserServiceImpl extends CommonDataServiceImpl implements CommonService{

	@Override
	public void save(List lst, Map map) throws Exception{
		String gubun = (String)map.get("GUBUN");
		if("insert".equals(gubun)){
			insert("user_SQL.insertUser", map);
		} 
		else if("update".equals(gubun)){
			update("user_SQL.updateUser", map);
		} 	
		else if("delete".equals(gubun)){
			delete("user_SQL.deleteUser", map);
		} 	
	}
}
