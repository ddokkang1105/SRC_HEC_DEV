package xbolt.mypage.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonService;
import xbolt.cmm.service.CommonDataServiceImpl;


@Service("mypageService")
@SuppressWarnings("unchecked")
public class MyPageServiceImpl extends CommonDataServiceImpl implements CommonService{

	@Override
	public void save(Map map) throws Exception{
		String gubun = (String)map.get("GUBUN");
		
		System.out.println("map = "+map);
		
		if("insert".equals(gubun)){
			insert("favorite_SQL.insertFavorite", map);
		} 
		else if("update".equals(gubun)){
			update("favorite_SQL.updateFavorite", map);
		} 	
		else if("delete".equals(gubun)){
			delete("favorite_SQL.deleteFavorite", map);
		} 	
	}
}
