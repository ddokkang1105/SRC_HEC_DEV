package xbolt.custom.hyundai.hkfc.util;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.util.*;
import xbolt.cmm.framework.val.GetProperty;
import xbolt.cmm.framework.val.GlobalVal;

import javax.servlet.http.HttpServletRequest;
import xbolt.cmm.service.CommonDataServiceImpl;
import xbolt.cmm.service.CommonService;

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
@Controller
@SuppressWarnings("unused")
public class HFKC_Util extends XboltController {	

	public static HFKC_Util linkHKFC;
	
	
	

	@PostConstruct
    public void init() {
		linkHKFC = this;
    }
	
	@Autowired
	@Resource(name = "commonService")
	private CommonService commonService;

	
	public String getEncOutputKey(HashMap linkInfoMap) throws ExceptionUtil { 
		Map returnMap = new HashMap();
		
		boolean bret = false;
		boolean nret = false;
		boolean iret = false; 
		int fileType = 0;
		String encText = "";
		String data = "";
		try {				
			String empNo = StringUtil.checkNull(linkInfoMap.get("outputKey"),"");

			System.out.println(empNo);
			Map setMap = new HashMap();
		
			setMap.put("userID", empNo);
			String userEmpNo = StringUtil.checkNull(linkHKFC.commonService.selectString("user_SQL.getEmployeeNum", setMap));
			String userEmail = StringUtil.checkNull(linkHKFC.commonService.selectString("user_SQL.userEmail", setMap));
			DateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss"); 
			Calendar cal = Calendar.getInstance(); 

			data = "Email||"+userEmail+"___User_Classi_Code||H108___User_ID||"+userEmpNo+"___IP||10.224.52.208___ssoTIME||"+dateFormat.format(cal.getTime());
			
			encText = "";//KEFICO.SECURITY.LoginUtil.autowayEncryption("KPAL", "H108", URLEncoder.encode(data));
			System.out.println(encText);
			
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
		
		return encText;
	}
	/*	
	@Resource(name="xsqlSession")
	private SqlSession xsqlSession;
	
	private final Log _log = LogFactory.getLog(this.getClass());
	
	String CRONEXE = StringUtil.checkNull(GetProperty.getProperty("CRONEXE"));
	String prefix = StringUtil.checkNull(GetProperty.getProperty("PREFIX"),"zhkfc");
	
	//@Scheduled(cron = "0 0/50 07,20 * * MON-FRI") // 매일 14시, 18시에 시작해서 5분 간격으로 실행
	@RequestMapping(value="/custom/exeHRinterface.do")
	public void exeHRinterface() throws Exception {
		HashMap setMap = new HashMap();
		
		System.out.println("start exeHRinterface");
		try{
			
			if(!prefix.equals("")) {
				truncateEmployee(prefix);
				List employeeList = selectEmployeeList(prefix);
				insertEmployee(prefix, employeeList);
				
				truncateOrganization(prefix);
				List organizationList = selectOrganizationList(prefix);
				insertOrganization(prefix, organizationList);
				
				exeHRProcedure(prefix);
				
			}

			System.out.println("end exeHRinterface");
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("SecondActionController::getEmployeeList::Error::"+e);}
			//throw e;
		}	
	}
	
	public void exeHRProcedure(String prefix) {
		HashMap setMap = new HashMap();
		String procedureName = StringUtil.checkNull(GlobalVal.HR_IF_PROC);
		setMap.put("procedureName", "XBOLTADM."+procedureName);
		try{ 			
			//xsqlSession.update("custom_SQL." + prefix + "_exeHRProcedure", setMap);
			commonService.insert("organization_SQL.insertHRTeamInfo", setMap);
			System.out.println("organization_SQL." + prefix + "insertHRTeamInfo");
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("SecondActionController::insertEmployeeList::Error::"+e);}
			//throw e;
		}	
	}
	
	
	public List selectEmployeeList(String prefix) throws Exception {
		HashMap setMap = new HashMap();
		List mapList = new ArrayList();

		try{
			mapList = xsqlSession.selectList("hkfc_SQL." + prefix + "_selectEmployeeList", setMap);
			
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("SecondActionController::getEmployeeList::Error::"+e);}
			//throw e;
		}
		return mapList;	
	}
	
	public void truncateEmployee(String prefix) {
		HashMap setMap = new HashMap();
		
		try{ 			
			commonService.delete("custom_SQL." + prefix + "_truncateEmployee", setMap);
			System.out.println("custom_SQL." + prefix + "_truncateEmployee");
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("SecondActionController::truncateEmployee::Error::"+e);}
			//throw e;
		}	
		
	}
	
	public void insertEmployee(String prefix, List mapList) {
		HashMap setMap = new HashMap();
		try{ 			
			for(int i=0; i<mapList.size(); i++) {
				setMap = (HashMap) mapList.get(i);
				commonService.insert("custom_SQL." + prefix + "_insertEmployee", setMap);
			}
			System.out.println("custom_SQL." + prefix + "_insertEmployee");
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("SecondActionController::insertEmployeeList::Error::"+e);}
			//throw e;
		}	
	}
	
	public List selectOrganizationList(String prefix) throws Exception {
		HashMap setMap = new HashMap();
		List mapList = new ArrayList();

		try{
			mapList = xsqlSession.selectList("hkfc_SQL." + prefix + "_selectOrganizationList", setMap);
			System.out.println("hkfc_SQL." + prefix + "_selectOrganizationList");
			
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("SecondActionController::getOrganizationList::Error::"+e);}
			//throw e;
		}
		return mapList;	
	}
	
	public void truncateOrganization(String prefix) {
		HashMap setMap = new HashMap();
		
		try{ 			
			commonService.delete("custom_SQL." + prefix + "_truncateOrganization", setMap);
			System.out.println("custom_SQL." + prefix + "_truncateOrganization");
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("SecondActionController::truncateOrganization::Error::"+e);}
			//throw e;
		}	
		
	}
	
	public void insertOrganization(String prefix, List mapList) {
		HashMap setMap = new HashMap();
		try{ 			
			for(int i=0; i<mapList.size(); i++) {
				setMap = (HashMap) mapList.get(i);
				commonService.insert("custom_SQL." + prefix + "_insertOrganization", setMap);
			}
			System.out.println("custom_SQL." + prefix + "_insertOrganization");
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("SecondActionController::insertOrganizationList::Error::"+e);}
			//throw e;
		}	
	}
   */
}
