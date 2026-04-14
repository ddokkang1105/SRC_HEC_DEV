package xbolt.app.esm.ctr.service;

import java.util.Map;

import org.springframework.stereotype.Service;

import xbolt.cmm.service.CommonDataServiceImpl;
import xbolt.cmm.service.CommonService;


@Service("ctrService")
@SuppressWarnings("unchecked")
public class CTRServiceImpl extends CommonDataServiceImpl implements CommonService{

	@Override
	public void save(Map param) throws Exception{

		try{
			insert("sk_cts_SQL.insertCTSFile", param);
		} catch(Exception e) {
			System.out.println("CTS FILE INSERT ERROR :: " + e.getMessage());
		}
	}

}
