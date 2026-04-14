package xbolt.custom.hyundai.hkfc.web;


import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.math.BigDecimal;
import java.math.MathContext;
import java.math.RoundingMode;
import java.net.URL;
import java.net.URLDecoder;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.org.json.JSONArray;
import com.org.json.JSONObject;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.filter.XSSRequestWrapper;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.AESUtil;
import xbolt.cmm.framework.util.DRMUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.GetItemAttrList;
import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.custom.hyundai.val.HMGGlobalVal;
import xbolt.custom.hyundai.hkfc.aprv.KR.CO.KEFICO.KASC.Service.CountInformation;
import xbolt.custom.hyundai.hkfc.aprv.KR.CO.KEFICO.KASC.Service.KIACSvcSoapProxy;

import xbolt.file.web.FileMgtActionController;

/**
 * @Class Name : HDCActionController.java
 * @Description : HDCActionController.java
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2021. 09. 02. smartfactory		최초생성
 *
 * @since 2021. 09. 02
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class HKFCActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;	
	
	private AESUtil aesAction;
	
	@Resource(name = "fileMgtActionController")
	private FileMgtActionController fileMgtActionController;
	
	@RequestMapping(value="/zHkfcSopMain.do")
	public String zHkfcSopMain(HttpServletRequest request, Map cmmMap,ModelMap model) throws Exception {
		Map target = new HashMap();
		String templCode = "";
		String arcCode = "";
		try {

	    	String defMenuItemID = StringUtil.checkNull(cmmMap.get("defMenuItemID"),StringUtil.checkNull(cmmMap.get("itemID")));
	    	arcCode = StringUtil.checkNull(cmmMap.get("arcCode"));
			Map setMap = new HashMap();
	    	String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),GlobalVal.DEFAULT_LANGUAGE);
	    	setMap.put("itemTypeCode", "OJ00005");
	    	setMap.put("categoryCode", "OJ");
	    	setMap.put("noMainItem", "Y");
	    	setMap.put("languageID", languageID);
	    	setMap.put("level", "1");
	    	setMap.put("itemClassCode", "CL05000");
	    	setMap.put("option", arcCode);

			List L0List = commonService.selectList("analysis_SQL.getL1List", setMap);

			model.put("arcCode", arcCode);		
			
			model.put("L0List", L0List);
			model.put("defMenuItemID", defMenuItemID);
			model.put("menu", getLabel(request, commonService));
			
			Map setData = new HashMap();
			templCode = StringUtil.checkNull(cmmMap.get("sessionTemplCode"));

			// 일반사용자,편집자를 제외한 템플릿  or  편집자의 PMI
			if((!"TMPL001".equals(templCode) && !"TMPL002".equals(templCode) )
					|| ("TMPL002".equals(templCode) && "PAL08".equals(arcCode))) {
				String itemID = StringUtil.checkNull(cmmMap.get("itemID"));
				setData.put("itemID", itemID);
				
				String itemClassMenuVarFilter = StringUtil.checkNull(commonService.selectString("menu_SQL.getItemClassMenuVarFilter", setData)); 
				String currIdx = StringUtil.checkNull(cmmMap.get("currIdx")); 
				String strType = StringUtil.checkNull(cmmMap.get("strType")); 
				String arcFilterType = StringUtil.checkNull(cmmMap.get("arcFilterType")); 
				
				String strItemID = "";
				if(strType.equals("2")){
					strItemID = itemID;
					itemID = StringUtil.checkNull(commonService.selectString("item_SQL.getToItemID", setData));
				}
				
				String teamCNT = "";
				String actionYN = "";
				if(arcFilterType.equals("ORGITM") || arcFilterType.equals("ORG")){
					setData.put("teamID", itemID);
					teamCNT = StringUtil.checkNull(commonService.selectString("organization_SQL.getTeamCNT", setData));
					if(Integer.parseInt(teamCNT) == 0){
						actionYN = "N";
					}
				}
				
				target.put(AJAX_SCRIPT, "parent.creatMenuTab('"+itemID+"','1','"+itemClassMenuVarFilter+"','"+currIdx+"','"+strItemID+"','"+actionYN+"')");
			}
			
			
		}
		catch(Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());			
		}
		
		if((!"TMPL001".equals(templCode) && !"TMPL002".equals(templCode) )
				|| ("TMPL002".equals(templCode) && "PAL08".equals(arcCode))) {
			model.addAttribute(AJAX_RESULTMAP,target); 
			return nextUrl(AJAXPAGE); 
		} else {
			model.put("menu", getLabel(request, commonService));
			return nextUrl("custom/hyundai/hkfc/subMain/zHkfcSopMain");
		}
	}
	
	// TODO ( zHkfcSopMain2.jsp 페이지는 반출 불가 문제로 개발서버에만 위치 )
	@RequestMapping(value="/zHkfcSopMain2.do")
	public String zHkfcSopMain2(HttpServletRequest request, Map cmmMap,ModelMap model) throws Exception {
		Map target = new HashMap();
		String templCode = "";
		String arcCode = "";
		try {

	    	String defMenuItemID = StringUtil.checkNull(cmmMap.get("defMenuItemID"),StringUtil.checkNull(cmmMap.get("itemID")));
	    	arcCode = StringUtil.checkNull(cmmMap.get("arcCode"));
			Map setMap = new HashMap();
	    	String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),GlobalVal.DEFAULT_LANGUAGE);
	    	setMap.put("itemTypeCode", "OJ00005");
	    	setMap.put("categoryCode", "OJ");
	    	setMap.put("noMainItem", "Y");
	    	setMap.put("languageID", languageID);
	    	setMap.put("level", "1");
	    	setMap.put("itemClassCode", "CL05000");
	    	setMap.put("option", arcCode);

			List L0List = commonService.selectList("analysis_SQL.getL1List", setMap);

			model.put("arcCode", arcCode);		
			
			model.put("L0List", L0List);
			model.put("defMenuItemID", defMenuItemID);
			model.put("menu", getLabel(request, commonService));
			
			Map setData = new HashMap();
			templCode = StringUtil.checkNull(cmmMap.get("sessionTemplCode"));

			// 일반사용자,편집자를 제외한 템플릿  or  편집자의 PMI
			if((!"TMPL001".equals(templCode) && !"TMPL002".equals(templCode) )
					|| ("TMPL002".equals(templCode) && "PAL08".equals(arcCode))) {
				String itemID = StringUtil.checkNull(cmmMap.get("itemID"));
				setData.put("itemID", itemID);
				
				String itemClassMenuVarFilter = StringUtil.checkNull(commonService.selectString("menu_SQL.getItemClassMenuVarFilter", setData)); 
				String currIdx = StringUtil.checkNull(cmmMap.get("currIdx")); 
				String strType = StringUtil.checkNull(cmmMap.get("strType")); 
				String arcFilterType = StringUtil.checkNull(cmmMap.get("arcFilterType")); 
				
				String strItemID = "";
				if(strType.equals("2")){
					strItemID = itemID;
					itemID = StringUtil.checkNull(commonService.selectString("item_SQL.getToItemID", setData));
				}
				
				String teamCNT = "";
				String actionYN = "";
				if(arcFilterType.equals("ORGITM") || arcFilterType.equals("ORG")){
					setData.put("teamID", itemID);
					teamCNT = StringUtil.checkNull(commonService.selectString("organization_SQL.getTeamCNT", setData));
					if(Integer.parseInt(teamCNT) == 0){
						actionYN = "N";
					}
				}
				
				target.put(AJAX_SCRIPT, "parent.creatMenuTab('"+itemID+"','1','"+itemClassMenuVarFilter+"','"+currIdx+"','"+strItemID+"','"+actionYN+"')");
			}
			
			
		}
		catch(Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());			
		}
		
		if((!"TMPL001".equals(templCode) && !"TMPL002".equals(templCode) )
				|| ("TMPL002".equals(templCode) && "PAL08".equals(arcCode))) {
			model.addAttribute(AJAX_RESULTMAP,target); 
			return nextUrl(AJAXPAGE); 
		} else {
			model.put("menu", getLabel(request, commonService));
			return nextUrl("custom/hyundai/hkfc/subMain/zHkfcSopMain2");
		}
	}
    
	@RequestMapping("/zhkfc_ProcMntrList.do")
	public String zhkfc_ProcMntrList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		String url = "/custom/hyundai/hkfc/report/zhkfc_ProcMntrList";
		
		try {
	    	String varfilter = StringUtil.checkNull(commandMap.get("varfilter"),"");
	    	String s_itemID = StringUtil.checkNull(commandMap.get("s_itemID"),"");
	    	String teamID = StringUtil.checkNull(commandMap.get("teamID"),"");
	    	String userTeamID = StringUtil.checkNull(commandMap.get("sessionTeamId"),"");
	    	String userID = StringUtil.checkNull(commandMap.get("sessionUserId"),"");
	    	String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"),GlobalVal.DEFAULT_LANGUAGE);
	    	String procMntrEdit = StringUtil.checkNull(commandMap.get("procMntrEdit"),"");
	    	
	    	setMap.put("s_itemID",s_itemID);
	    	int year = Calendar.getInstance().get(Calendar.YEAR);
 
			String itemTypeCode = StringUtil.checkNull(commonService.selectString("item_SQL.getItemTypeCode", setMap));
			model.put("itemTypeCode", itemTypeCode);

			model.put("kpiYear",year);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));

			if(!"".equals(teamID)) {
				model.put("teamID",teamID);
		    	setMap.put("teamID", s_itemID);	
				String teamName = StringUtil.checkNull(commonService.selectString("organization_SQL.getTeamName", setMap));

				model.put("teamName",teamName);
				
			}
			else if("OJ00008".equals(itemTypeCode)) {		    	
				model.put("kpiItemID", s_itemID);	
		    	setMap.put("s_itemID", s_itemID);
		    	
				String kpiAuthorID = StringUtil.checkNull(commonService.selectString("item_SQL.getItemAuthorId", setMap));
				model.put("kpiAuthorID", kpiAuthorID);	
				setMap.put("kpiAuthorID", s_itemID);	
				
				setMap.put("kpiItemID", s_itemID);		
				
			}
			else {
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
		    	
				setMap.put("allItemID", s_itemID);	
			}
	    	
	    	
			model.put("varfilter", varfilter);	
			model.put("menu", getLabel(commandMap, commonService));	
			
			String sessionAuthLev =	StringUtil.checkNull(commandMap.get("sessionAuthLev")); 
			String sessionUserID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String sessionTeamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
			
			// 전체조회 가능하도록 수정 - 주석해제 시 관리자를 제외하고 본인 PMI만 조회가능
			/*
			if(!sessionAuthLev.equals("1")) { 
				setMap.put("authorID", sessionUserID); 
				setMap.put("roleTeamID", sessionTeamID);
			}
			*/
			List getProcMntrList = commonService.selectList("custom_SQL.zhkfc_getProcMntrListFilter",setMap);
			 
			JSONArray gridData = new JSONArray(getProcMntrList);
			model.put("gridData",gridData);
	    	setMap.put("teamID",userTeamID);

			String roleMNID = StringUtil.checkNull(commonService.selectString("organization_SQL.getTeamRoleMNID", setMap));
			
			setMap.put("authorID", userID);
			setMap.put("languageID", languageID);
			setMap.put("classCode", "CL05003");
			List myItemList = commonService.selectList("item_SQL.getOwnerItemList_gridList", setMap);
			
			commandMap.put("dimTypeID", "115053"); // DimTypeID : Company: 115053
			List dimensionList = commonService.selectList("dim_SQL.getSelectDimList", commandMap);
			JSONArray dimensionData = new JSONArray(dimensionList);
			model.put("companyList",dimensionData);		

	    	model.put("myItemCnt",myItemList.size());
	    	model.put("roleMNID",roleMNID);
	    	model.put("s_itemID", s_itemID);
		} catch (Exception e) {
			System.out.println(e);
			throw new Exception("EM00001");
		}
		return nextUrl(url);
	}
	
	
	

	@RequestMapping("/zhkfc_ProcMntrUpdReport.do")
	public String zhec_WFDocMgt(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		
		try {

			model.put("menu", getLabel(commandMap, commonService));	
			
		} catch (Exception e) {
			System.out.println(e);
			throw new Exception("EM00001");
		}
		return nextUrl("/custom/hyundai/hkfc/report/zhkfc_ProcMntrUpdReport");
	}


	//데이타 업로드
	@RequestMapping(value="/zhfkc_procExcelUpload.do")
	public String zhfkc_procExcelUpload(HashMap commandFileMap, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		try {
			List list				= (List) commandFileMap.get("STORED_FILES");
			Map map					= (Map) list.get(0);

			String sys_file_name	= (String)map.get("SysFileNm");

			HashMap drmInfoMap = new HashMap();			
			String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
			String teamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
			String teamName = StringUtil.checkNull(commandMap.get("sessionTeamName"));			
			drmInfoMap.put("userID", userID);
			drmInfoMap.put("userName", userName);
			drmInfoMap.put("teamID", teamID);
			drmInfoMap.put("teamName", teamName);
			
			String filePath	= FileUtil.FILE_UPLOAD_DIR + sys_file_name;		
			
			String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
			String useUploadDRM = StringUtil.checkNull(GlobalVal.DRM_UPLOAD_USE);			
			if(!"".equals(useDRM) && !"N".equals(useUploadDRM)){
				drmInfoMap.put("ORGFileDir", FileUtil.FILE_UPLOAD_DIR);
				drmInfoMap.put("DRMFileDir", FileUtil.FILE_UPLOAD_DIR);
				drmInfoMap.put("Filename", userID + "_" + sys_file_name);	
				drmInfoMap.put("FileRealName", sys_file_name);							
				drmInfoMap.put("funcType", "upload");
				filePath = DRMUtil.drmMgt(drmInfoMap); // 암호화 		
				System.out.println(filePath);
			}
			
			String errorCheckfilePath = GlobalVal.FILE_EXPORT_DIR; 

			Map excelMap = new HashMap();
			
			/* 파일 업로드 체크 시 발생한 에러 메세지 출력 파일 생성 */
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			long date = System.currentTimeMillis();
		    String fileName = "Upload_ERROR_" + formatter.format(date) + ".txt";
		    String downFile = errorCheckfilePath + fileName;
			File file = new File(downFile);
			BufferedWriter errorLog = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file,true), "UTF-8"));
			
			excelMap = getItemList(new File(filePath), commandFileMap, commandMap, errorLog);
			
			errorLog.close();

			List arrayList = (List) excelMap.get("list");
			JSONArray jsonArray = new JSONArray(arrayList);
			//model.put("jsonObject",jsonObject);
		  
			String errMsgYN="";
			if (excelMap.get("msg") != null) {
				errMsgYN =  "Y";
			}else{ 
				errMsgYN = "N";
			}	
			
			insertNewItem(jsonArray); 
			
			String msg = MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00088");
			target.put(AJAX_ALERT,   msg);
			target.put(AJAX_SCRIPT, "parent.doReturn('"+ errMsgYN +"','"+fileName+"','"+downFile+"');");
			
			if (excelMap.get("msg") != null) {				
				errorLog.close();				
			} else {
				file.delete(); 
			}
			
		} catch (Exception e) {
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00072", new String[]{e.getMessage().replaceAll("\"", "")}));
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}	
	
	private Map getItemList(File excelFile, HashMap commandFileMap, HashMap commandMap, BufferedWriter errorLog) throws Exception {
		Map excelMap = new HashMap();
		
		XSSFWorkbook workbook  =  new XSSFWorkbook(new FileInputStream(excelFile));
		XSSFSheet sheet    =  null;
	    
		try{
			
			sheet = workbook.getSheetAt(0);  // 첫번째 sheet의 데이터 취득

			int rowCount = sheet.getPhysicalNumberOfRows();

			if( rowCount <= 1 ){
				throw new Exception("There is not data in excel file.");
			}
				// 새로운 구조 업로드, 기존 속성 업데이트
			excelMap = setUploadMapNew(sheet, commandMap, errorLog);
							
			return excelMap;

		} catch (Exception e) {
			System.out.println(e.toString());
			throw e;
		} finally {
			try{
				workbook	= null;
				sheet		= null;
			} catch(Exception e) {

			}
		}
	}
	private Map setUploadMapNew2(XSSFSheet sheet, HashMap commandMap, BufferedWriter errorLog) throws Exception {
		Map excelMap = new HashMap();
		
		String colsName = "";
		String[][] data	= null;
		List list = new ArrayList();
		
		int valCnt = 0;
		int totalCnt = 0;
		
		int rowCount  =  sheet.getPhysicalNumberOfRows();
		int colCount = sheet.getRow(0).getPhysicalNumberOfCells();
		
		data = new String[rowCount][colCount];
		
		XSSFRow row     =  null;
	    XSSFCell cell    =  null;
	    System.out.println("test start2");
	    String langCode = String.valueOf(commandMap.get("sessionCurrLangCode"));

	    System.out.println("row count : " + rowCount);
	    System.out.println("col count : " + colCount);
		for(int i = 0; i < rowCount; i ++){

			row = sheet.getRow(i);
			
			for(int j = 0; j < colCount; j ++) {
				cell	= row.getCell(j);
				
				if (null != cell) {
					if (HSSFCell.CELL_TYPE_NUMERIC == cell.getCellType()) {
						data[i][j]	= StringUtil.checkNull(setDateYyyymmdd(cell, "yyyy-MM-dd"));
					} else {
						data[i][j]	= StringUtil.checkNull(cell);
					}
				} else {
					data[i][j]	= StringUtil.checkNull(cell);
				}

			    System.out.println("Data : " + data[i][j]);
			}
			/*
			for(int j = 8; j < 20; j ++) {
				cell	= row.getCell(j);
				
				if (null != cell) {
					colsName = colsName + "|" + "Month" + (j - 7);
				} 				
			}*/
			colsName = "|Month1|Month2|Month3|Month4|Month5|Month6|Month7|Month8|Month9|Month10|Month11|Month12";
			
			if(i > 0){
				
				// 데이터 입력 체크
				String msg = checkValueForUploadNew(i, data, langCode, errorLog);
				if (!msg.isEmpty()) {
					excelMap.put("msg", msg);
				}
								
				// 새로운 템플렛 적용
				Map map = new HashMap();
				map.put("RNUM"					, i);
				map.put("procCode"	, data[i][2]);
				map.put("kpiCode"			, data[i][0]);
				map.put("teamCode"	            , data[i][4]);
				map.put("lastUpdated"			, data[i][6]);
				map.put("TargetValue"			, data[i][7]);
				map.put("Remark"			, data[i][21]);
				map.put("Year"			, data[i][8]);
				/*
				for (int j = 8; j < colCount; j ++) {
					map.put("Month"	+ (j-7)		, data[i][j]);
				}
				*/ 
				map.put("Month1"		, data[i][9]);
				map.put("Month2"		, data[i][10]);
				map.put("Month3"		, data[i][11]);
				map.put("Month4"		, data[i][12]);
				map.put("Month5"		, data[i][13]);
				map.put("Month6"		, data[i][14]);
				map.put("Month7"		, data[i][15]);
				map.put("Month8"		, data[i][16]);
				map.put("Month9"		, data[i][17]);
				map.put("Month10"		, data[i][18]);
				map.put("Month11"		, data[i][19]);
				map.put("Month12"		, data[i][20]);
				list.add(map);
				
				if (msg.isEmpty()) {
					++valCnt;
				}
				++totalCnt ;
			}
			
		}
		
		excelMap.put("list", list);
		excelMap.put("validCnt", valCnt);
		excelMap.put("totalCnt", totalCnt);
		excelMap.put("colsName", "procCode|kpiCode|teamCode|lastUpdated|TargetValue|Year" + colsName);

		return excelMap;
	}
	
	/**
	 * [새로운 구조 업로드][속성 업데이트] 읽어들인 템플릿의 정보의 필수 체크와 DB존재 체크
	 * 
	 * @param i  처리행수
	 * @param data 처리행의 각 칼럼 데이터
	 * @param temp
	 * @param option
	 * @param identifierList 전행의 Identifier리스트
	 * @return 에러메세지 msg 
	 * @throws Exception 
	 */
	private String checkValueForUploadNew(int i, String[][] data, String langCode, BufferedWriter errorLog) throws Exception {
		String msg = "";
		
		if (data[i][24].trim().isEmpty()) {
			msg = MessageHandler.getMessage(langCode + ".WM00111", new String[]{String.valueOf(i + 1), "Process ID"});
			errorLog.write(msg); 
			errorLog.newLine();
			
		}
		
		if (data[i][25].trim().isEmpty()) {
			msg = MessageHandler.getMessage(langCode + ".WM00111", new String[]{String.valueOf(i + 1), "KPI ID"});
			errorLog.write(msg); 
			errorLog.newLine();				
		}
		
		if (data[i][27].trim().isEmpty()) {
			msg = MessageHandler.getMessage(langCode + ".WM00111", new String[]{String.valueOf(i + 1), "Team ID"});
			errorLog.write(msg); 
			errorLog.newLine();				
		}
		
		if (data[i][9].trim().isEmpty()) {
			msg = MessageHandler.getMessage(langCode + ".WM00111", new String[]{String.valueOf(i + 1), "연도"});
			errorLog.write(msg); 
			errorLog.newLine();				
		}
		
		return msg;
	}
	

	private String setDateYyyymmdd(XSSFCell cell, String strFormat) {
		String result = "";
		SimpleDateFormat formatter = new SimpleDateFormat(strFormat);
		
		if (cell.getCellType() ==  HSSFCell.CELL_TYPE_NUMERIC) {
			if (HSSFDateUtil.isCellDateFormatted(cell)) {
				result = formatter.format(cell.getDateCellValue());
			} else {
				result = StringUtil.checkNull(cell.getRawValue());
			}
		} else {
			result = StringUtil.checkNull(cell);
		}
		
		return result;
	}
	
	// jsonObject생성시, 에러를 유발시키는 싱글 쿼테이션을 치환하는 처리
	private String replaceSingleQuotation(String plainText) {
		String result = "";
		result = plainText.replace("'", "");
		return result;
	}
	

	// TODO : 개행 코드 삭제
	private String removeAllTag(String str) {

		str = str.replaceAll("&lt;", "<");//201610 new line :: Excel To DB 
		str = str.replaceAll("&gt;", ">");//201610 new line :: Excel To DB 
		str = str.replaceAll("\n", "&&rn");//201610 new line :: Excel To DB 
		str = str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#10;", " ").replace("&#xa;", "").replace("&nbsp;", " ");
		return StringEscapeUtils.unescapeHtml4(str);
	}
	private String removeAllTag(String str,String type) { 
		if(type.equals("DbToEx")){//201610 new line :: DB To Excel
			str = str.replaceAll("<br/>", "&&rn").replaceAll("<br />", "&&rn").replaceAll("\r\n", "&&rn").replaceAll("&gt;", ">").replaceAll("&lt;", "<").replaceAll("&#40;", "(").replaceAll("&#41;", ")").replace("&sect;","-");//20161024 bshyun Test
		}else{
			str = str.replaceAll("\n", "&&rn");//201610 new line :: Excel To DB 
		}
		str = str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#10;", " ").replace("&#xa;", "").replace("&nbsp;", " ").replace("&amp;", "&");
		if(type.equals("DbToEx")){
			str = str.replaceAll("&&rn", "\n");
		}
		return StringEscapeUtils.unescapeHtml4(str);
	}	
	
	@RequestMapping(value="/zhfkc_procExcelSave.do")
	public String zhfkc_procExcelSave(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		try {
			JSONArray uploadExcelResult  = new JSONArray(request.getParameter("uploadExcelResult"));
			insertNewItem(uploadExcelResult);
			
			String msg = MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00088");
			if (commandMap.containsKey("infoMsg")) {
				msg = msg + commandMap.get("infoMsg").toString();
			}
			
			List gridDataList = commonService.selectList("custom_SQL.zhkfc_getProcMntrList_gridList", commandMap);
			JSONArray gridData = new JSONArray(gridDataList);
			
			target.put(AJAX_ALERT,   msg);
			target.put(AJAX_SCRIPT,  "doSaveReturn("+gridData+")");
		}
		catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00073", new String[]{e.getMessage().replaceAll("\"", "")}));
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
	
	/**
	 * 새로운 구조 업로드시 읽어들인 템플릿의 정보를 DB에 저장
	 * 
	 * @param uploadExcelResult
	 * @throws Exception
	 *//*
	private void insertNewItem2(JSONArray jsonArray) throws Exception {
		String itemId = "";
		for (int r = 0; r < jsonArray.length(); r++) {
			Map inputData = new HashMap();
			Map setMap  = new HashMap();
			JSONObject jo = (JSONObject)jsonArray.get(r);
			
			if (jo !=null && jo.length() > 0) {

				setMap.put("Identifier", jo.get("procCode"));
				itemId = StringUtil.checkNull(commonService.selectString("report_SQL.getItemIdWithIdentifier", setMap));

				setMap.put("Identifier", jo.get("kpiCode"));
				String kpiItemId = StringUtil.checkNull(commonService.selectString("report_SQL.getItemIdWithIdentifier", setMap));
				
				setMap.put("teamCode", jo.get("teamCode"));
				String teamID = StringUtil.checkNull(commonService.selectString("organization_SQL.getTeamIDFromTeamCode", setMap));
				
				inputData.put("procID", itemId);
				inputData.put("kpiID", kpiItemId);
				inputData.put("teamID", teamID);
				inputData.put("lastUpdated", jo.get("lastUpdated"));
				inputData.put("TargetValue", jo.get("TargetValue"));
				inputData.put("Year", jo.get("Year"));
				inputData.put("Remark", jo.get("Remark"));

				inputData.put("Month1"		, jo.get("Month1"));
				inputData.put("Month2"		, jo.get("Month2"));
				inputData.put("Month3"		, jo.get("Month3"));
				inputData.put("Month4"		, jo.get("Month4"));
				inputData.put("Month5"		, jo.get("Month5"));
				inputData.put("Month6"		, jo.get("Month6"));
				inputData.put("Month7"		, jo.get("Month7"));
				inputData.put("Month8"		, jo.get("Month8"));
				inputData.put("Month9"		, jo.get("Month9"));
				inputData.put("Month10"		, jo.get("Month10"));
				inputData.put("Month11"		, jo.get("Month11"));
				inputData.put("Month12"		, jo.get("Month12"));
				
				commonService.insert("custom_SQL.zHKFC_insertProcMntrList", inputData);
			}
		}	
	}
	*/
	private Map setUploadMapNew(XSSFSheet sheet, HashMap commandMap, BufferedWriter errorLog) throws Exception {
		Map excelMap = new HashMap();
		
		String colsName = "";
		String[][] data	= null;
		List list = new ArrayList();
		
		int valCnt = 0;
		int totalCnt = 0;
		
		int rowCount  =  sheet.getPhysicalNumberOfRows();
		int colCount = sheet.getRow(0).getPhysicalNumberOfCells();
		
		data = new String[rowCount][colCount];
		
		XSSFRow row     =  null;
	    XSSFCell cell    =  null;
	    String langCode = String.valueOf(commandMap.get("sessionCurrLangCode"));

	    SimpleDateFormat format1 = new SimpleDateFormat ( "yyyy-MM-dd HH:mm:ss");
	    Date today = new Date();
	    
		for(int i = 0; i < rowCount; i ++){

			row = sheet.getRow(i);
			
			for(int j = 0; j < colCount; j ++) {
				cell	= row.getCell(j);
				
				if (null != cell) {
					if (HSSFCell.CELL_TYPE_NUMERIC == cell.getCellType()) {
						data[i][j]	= StringUtil.checkNull(setDateYyyymmdd(cell, "yyyy-MM-dd"));
					} else {
						data[i][j]	= StringUtil.checkNull(cell);
					}
				} else {
					data[i][j]	= StringUtil.checkNull(cell);
				}

			}
			colsName = "|Month";
			
			if(i > 0){
				
				// 데이터 입력 체크
				String msg = checkValueForUploadNew(i, data, langCode, errorLog);
				if (!msg.isEmpty()) {
					excelMap.put("msg", msg);
				}
								
				// 새로운 템플렛 적용
				Map map = new HashMap();
				map.put("RNUM", i);
				map.put("processItemID", data[i][24].trim());
				map.put("kpiItemID", data[i][25].trim());
				map.put("teamID", data[i][27].trim());
				map.put("TargetValue", data[i][6].trim());
				map.put("Year", data[i][9].trim());
				
				map.put("Month1", data[i][10].trim());
				map.put("Month2", data[i][11].trim());
				map.put("Month3", data[i][12].trim());
				map.put("Month4", data[i][13].trim());
				map.put("Month5", data[i][14].trim());
				map.put("Month6", data[i][15].trim());
				map.put("Month7", data[i][16].trim());
				map.put("Month8", data[i][17].trim());
				map.put("Month9", data[i][18].trim());
				map.put("Month10", data[i][19].trim());
				map.put("Month11", data[i][20].trim());
				map.put("Month12", data[i][21].trim());
				map.put("YearOrg", data[i][26].trim());
				map.put("Remark", data[i][23]);

				map.put("lastUpdated", format1.format(today));
				list.add(map);
				
				if (msg.isEmpty()) {
					++valCnt;
				}
				++totalCnt ;
			}
			
		}
		
		excelMap.put("list", list);

		return excelMap;
	}

	private void insertNewItem(JSONArray jsonArray) throws Exception {
		for (int r = 0; r < jsonArray.length(); r++) {
			Map inputData = new HashMap();
			JSONObject jo = (JSONObject)jsonArray.get(r);
			
			if (jo !=null && jo.length() > 0) {
				if(!"".equals(StringUtil.checkNull(jo.get("Year")))
						   && !"".equals(StringUtil.checkNull(jo.get("processItemID")))
						   && !"".equals(StringUtil.checkNull(jo.get("kpiItemID")))
						   && !"".equals(StringUtil.checkNull(jo.get("teamID")))
				) {
					int year = Integer.valueOf(StringUtil.checkNull(jo.get("Year")));
					int yearOrg = Integer.valueOf(StringUtil.checkNull(jo.get("YearOrg")));
					
					inputData.put("objID", jo.get("processItemID"));
					inputData.put("kpiID", jo.get("kpiItemID"));
					inputData.put("teamID", jo.get("teamID"));
					inputData.put("Year", year);
					inputData.put("YearOrg", yearOrg);
					inputData.put("TargetValue", jo.get("TargetValue"));
					inputData.put("lastUpdated", jo.get("lastUpdated"));
					inputData.put("Remark", jo.get("Remark"));
					
					for(int idx=1; idx<13; idx++) {		
						inputData.put("Month", idx);
						String years = year+","+yearOrg;
						inputData.put("Year", years);
						String ValueCnt = StringUtil.checkNull(commonService.selectString("custom_SQL.zhkfc_checkValueForProcMntrList", inputData),"0");
						int kpiValueCnt = Integer.parseInt(ValueCnt);
						
						inputData.put("Value", jo.get("Month"+idx));
						inputData.put("Year", year);
						if(kpiValueCnt == 0) {
							if(!StringUtil.checkNull(jo.get("Month"+idx)).equals("")) {
								commonService.insert("custom_SQL.zHKFC_insertProcMntrList", inputData); 
							}
						}else if(kpiValueCnt == 1){
							commonService.insert("custom_SQL.zHKFC_updateProcMntrList", inputData); 
						}
					}
				}
			}
		}	
	}

	 @RequestMapping(value="/zHkfcCreateSubItemDiv.do")
	 public String zHkfcCreateSubItemDiv(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
	     Map target = new HashMap();
	     String url = "";
	     int index = 0;
		 try{
		      Map setMap = new HashMap();
		      String itemID = StringUtil.checkNull(cmmMap.get("itemID"));
		      String arcCode = StringUtil.checkNull(cmmMap.get("arcCode"));
		      String level = StringUtil.checkNull(cmmMap.get("level"));
		      String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),GlobalVal.DEFAULT_LANGUAGE);
		      String itemClassCode = StringUtil.checkNull(cmmMap.get("itemClassCode"));
		      String itemClassCodeList = StringUtil.checkNull(cmmMap.get("itemClassCodeList"));
		      String listText = "";
		      
		      setMap.put("itemID", itemID);      
		      setMap.put("languageID", languageID);
		      setMap.put("itemClassCode", itemClassCode);
			  
		      setMap.put("index", index);

		      setMap.put("itemClassCodeList", itemClassCodeList);
		      List subList = commonService.selectList("zHEC_SQL.zhec_GetSubItemIDListForFromItemID", setMap);
		   
		      if(subList != null && !subList.isEmpty()) {
		      for(int i=0; i<subList.size(); i++) {
		         Map tempMap = (HashMap)subList.get(i);
		     
			     if(i == 0) {
			      listText = StringUtil.checkNull(tempMap.get("ItemID")) + "_"  
			                  + StringUtil.checkNull(tempMap.get("PlainText")) + "_"
			                  + StringUtil.checkNull(tempMap.get("Level")) + "_"
			                  + StringUtil.checkNull(tempMap.get("FileCount")) + "_"
			            + StringUtil.checkNull(tempMap.get("SubCount")) + "_"
			            + StringUtil.checkNull(tempMap.get("ChdCount"));
			     }
			     else {
			      listText += "@" + StringUtil.checkNull(tempMap.get("ItemID")) + "_"  
			                  + StringUtil.checkNull(tempMap.get("PlainText")) + "_"
			                  + StringUtil.checkNull(tempMap.get("Level")) + "_"
			                  + StringUtil.checkNull(tempMap.get("FileCount")) + "_"
			            + StringUtil.checkNull(tempMap.get("SubCount")) + "_"
			            + StringUtil.checkNull(tempMap.get("ChdCount"));
			     }
			     
			     int cnt = Integer.parseInt(StringUtil.checkNull(tempMap.get("ChdCount")));
			     
			     if(cnt > 0) {
			      listText += setChildeItemList(StringUtil.checkNull(tempMap.get("ItemID")), arcCode, languageID,level, index+1,itemClassCode,itemClassCodeList);
			     }
		      }
		   }
		   target.put(AJAX_SCRIPT, "createSubItemDiv('"+listText+"');$('#isSubmit').remove();"); 
		  
		   
		  }catch(Exception e){
		   System.out.println(e);
		   target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
		  }
		  
		  model.addAttribute(AJAX_RESULTMAP, target);
		  return nextUrl(AJAXPAGE);
	 }
	  
	 public String setChildeItemList(String itemID, String arcCode, String languageID, String level, int index, String itemClassCode, String itemClassCodeList) throws Exception{
	  Map target = new HashMap();
	     String listText = "";
	  try{
	   
	   if(index > Integer.parseInt(level)) {
	    return listText;
	   }
	   
	   Map setMap = new HashMap();
	      
      setMap.put("itemID", itemID);      
      setMap.put("languageID", languageID);
      setMap.put("index", index);
      setMap.put("itemClassCode", itemClassCode);
      setMap.put("itemClassCodeList", itemClassCodeList);
      
	  if(index < 3) {
		   List subList = commonService.selectList("zHEC_SQL.zhec_GetSubItemIDListForFromItemID", setMap);
		   
		   if(subList != null && !subList.isEmpty()) {
			for(int i=0; i<subList.size(); i++) {
			 Map tempMap = (HashMap)subList.get(i);
			 
			 listText += "@" + StringUtil.checkNull(tempMap.get("ItemID")) + "_"  
						 + StringUtil.checkNull(tempMap.get("PlainText")) + "_"
						 + StringUtil.checkNull(tempMap.get("Level")) + "_"
						 + StringUtil.checkNull(tempMap.get("FileCount")) + "_"
						 + StringUtil.checkNull(tempMap.get("SubCount")) + "_"
						 + StringUtil.checkNull(tempMap.get("ChdCount")) + "_"
						 + StringUtil.checkNull(tempMap.get("SubChdCount"));
			 

			 int cnt = Integer.parseInt(StringUtil.checkNull(tempMap.get("ChdCount")));
			 
			 if(cnt > 0) {
			  listText += setChildeItemList(StringUtil.checkNull(tempMap.get("ItemID")), arcCode, languageID, level,index+1,itemClassCode,itemClassCodeList);
			 }
			}
		   } 
	  
	  }
	  }catch(Exception e){
	   System.out.println(e);
	  }
	  
	  return listText;
	 }
	 
	    
	@RequestMapping("/zhkfc_InputKpiList.do")
	public String zhkfc_InputKpiList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		
		try {
	    	String varfilter = StringUtil.checkNull(commandMap.get("varfilter"),"");
	    	String s_itemID = StringUtil.checkNull(commandMap.get("s_itemID"),"");
	    	String teamID =  StringUtil.checkNull(commandMap.get("sessionTeamId"));
			String userId = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String year = StringUtil.checkNull(commandMap.get("year"));
			String itemTypeCode = StringUtil.checkNull(commandMap.get("itemTypeCode"));
	    	
			setMap.put("s_itemID", s_itemID);
	    	setMap.put("kpiTeamID",teamID);
	    	setMap.put("userId",userId);
	    	//setMap.put("isKPI","Y");
	    	setMap.put("classCode","CL05003");
	    	setMap.put("kpiCode","CL08002");
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));

			model.put("menu", getLabel(commandMap, commonService));	
			
			String sessionAuthLev = StringUtil.checkNull(commandMap.get("sessionAuthLev"));
			String sessionUserID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String sessionTeamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
			if(!sessionAuthLev.equals("1")) { 
				setMap.put("authorID", sessionUserID); 
				setMap.put("roleTeamID", sessionTeamID); 
			} 
			List getTeamKpiList = commonService.selectList("custom_SQL.zhkfc_getNewKpiList_gridList", setMap);
			JSONArray gridData = new JSONArray(getTeamKpiList);
			model.put("gridData",gridData);		
			model.put("s_itemID", s_itemID);
			model.put("year", year);
			
			
			// 기존 등록된 data 
			 if("OJ00008".equals(itemTypeCode)) {	
		    	setMap.put("s_itemID", s_itemID);
				setMap.put("kpiItemID", s_itemID);		
			} else {
				setMap.put("allItemID", s_itemID);	
			}
			 
			List pmiList = commonService.selectList("custom_SQL.zhkfc_getProcMntrList_gridList",setMap);
			JSONArray pmiListData = new JSONArray(pmiList);
			model.put("pmiListData",pmiListData);		
			
			System.out.println("pimList size :"+pmiList.size()+" :::> pmiLis :"+pmiList);

		} catch (Exception e) {
			System.out.println(e);
			throw new Exception("EM00001");
		}
		return nextUrl("/custom/hyundai/hkfc/report/zhkfc_InputKpiList");
	}

	@RequestMapping(value = "/zhkfc_saveNewKpiList.do", produces = "application/text; charset=utf-8")
	public void zhkfc_saveNewKpiList(HttpServletRequest request, HttpServletResponse response, HashMap commandMap) throws Exception {
		HashMap target = new HashMap();
		HashMap setMap = new HashMap();
		JSONArray result = new JSONArray();
//		String result = "";
		try {			
			JSONArray jsonArray  = new JSONArray(request.getParameter("editedRow"));
			
			for (int i = 0; i < jsonArray.length(); i++) {
				JSONObject jo = (JSONObject)jsonArray.get(i);
				
				setMap = new HashMap();
				
				
					
					setMap.put("Identifier", jo.get("ObjectCode"));
					String itemId = StringUtil.checkNull(commonService.selectString("report_SQL.getItemIdWithIdentifier", setMap));
	
					setMap.put("Identifier", jo.get("KpiCode"));
					String kpiItemId = StringUtil.checkNull(commonService.selectString("report_SQL.getItemIdWithIdentifier", setMap));
					
					String teamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
					int year = Integer.valueOf(StringUtil.checkNull(jo.get("Year")));
					int month = Integer.valueOf(StringUtil.checkNull(jo.get("Month")));
					int value = Integer.valueOf(StringUtil.checkNull(jo.get("MonthValue")));
					
					if(!"".equals(StringUtil.checkNull(jo.get("Year")))
							   && !"".equals(StringUtil.checkNull(jo.get("Month")))
							   && !"".equals(StringUtil.checkNull(jo.get("MonthValue")))
							   && !"".equals(StringUtil.checkNull(itemId))
							   && !"".equals(StringUtil.checkNull(kpiItemId))
							   && !"".equals(StringUtil.checkNull(teamID))
					
					) {
						
					setMap.put("objID", itemId);
					setMap.put("kpiID", kpiItemId);
					setMap.put("teamID", teamID);
					setMap.put("Year", year);
					setMap.put("Value", value);
					setMap.put("Month", month);
					setMap.put("TargetValue", jo.get("TargetValue"));
					setMap.put("lastUpdated", jo.get("KpiLastUpdated"));
					setMap.put("Remark", jo.get("Remark"));
					
					String ValueCnt = StringUtil.checkNull(commonService.selectString("custom_SQL.zhkfc_checkValueForProcMntrList", setMap),"0");
					if("0".equals(ValueCnt)) {
						commonService.insert("custom_SQL.zHKFC_insertProcMntrList", setMap);
					}else {
						commonService.insert("custom_SQL.zHKFC_updateProcMntrList", setMap);
					}
					
				}
			}
			response.setCharacterEncoding("UTF-8");
			
			setMap = new HashMap();
	    	setMap.put("ownerTeamID",commandMap.get("sessionTeamId"));
	    	setMap.put("classCode","CL05003");
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			
			// List getTeamKpiList = commonService.selectList("custom_SQL.zhkfc_getNewKpiList_gridList", setMap);
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			setMap.put("s_itemID", s_itemID);
			
			String itemTypeCode = StringUtil.checkNull(commonService.selectString("item_SQL.getItemTypeCode", setMap));
			if("OJ00008".equals(itemTypeCode)) {		
		    	setMap.put("s_itemID", s_itemID);
				String kpiAuthorID = StringUtil.checkNull(commonService.selectString("item_SQL.getItemAuthorId", setMap));
				setMap.put("kpiAuthorID", s_itemID);	
				setMap.put("kpiItemID", s_itemID);		
			}
			else {
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
		    	
				setMap.put("allItemID", s_itemID);	
			}
			
			List getProcMntrList = commonService.selectList("custom_SQL.zhkfc_getProcMntrList_gridList", setMap);
			/*
			if(getProcMntrList.size()>0) {
				for(int i=0; i<getProcMntrList.size(); i++) {
					Map procMntrMap = (Map)getProcMntrList.get(i);
					String itemID = StringUtil.checkNull( procMntrMap.get("ProcItemID"));
					Map setData = new HashMap();
					setData.put("s_itemID", itemID);
					setData.put("dimTypeID", "115053");
					
					List dimensionCompayList = commonService.selectList("dim_SQL.getItemDimensionList", setData);
					if(dimensionCompayList.size() == 0) dimensionCompayList = null;
					procMntrMap.put("dimensionCompayList", dimensionCompayList);
				}
			}
			*/
		
			result = new JSONArray(getProcMntrList);
		} catch (Exception e) {
			System.out.println(e);
		}
		response.getWriter().print(result);
	}
	
	@RequestMapping(value = "/zhkfc_saveKpiList.do", produces = "application/text; charset=utf-8")
	public void zhkfc_saveKpiList(HttpServletRequest request, HttpServletResponse response, HashMap commandMap) throws Exception {
		HashMap target = new HashMap();
		HashMap setMap = new HashMap();
		JSONArray result = new JSONArray();
		try {			
			JSONArray jsonArray  = new JSONArray(request.getParameter("editedRow"));
			
			for (int i = 0; i < jsonArray.length(); i++) {
				JSONObject jo = (JSONObject)jsonArray.get(i);
				
				setMap = new HashMap();			
				String itemId = StringUtil.checkNull(jo.get("ProcItemID"));
				String kpiItemId = StringUtil.checkNull(jo.get("KpiItemID"));
				
				String teamID = StringUtil.checkNull(jo.get("TeamID"));
				int year = Integer.valueOf(StringUtil.checkNull(jo.get("Year")));
				String reqYearOrg = StringUtil.checkNull(jo.get("YearOrg"));
				int yearOrg = 0;
				if(!reqYearOrg.equals("")) {
					yearOrg = Integer.valueOf(reqYearOrg);
				}
				
				String lastUpdated = StringUtil.checkNull(jo.get("KpiLastUpdated"));
				String targetValue = StringUtil.checkNull(jo.get("TargetValue"));
				String remark = StringUtil.checkNull(jo.get("Remark"));
				String RoleManagerID = StringUtil.checkNull(jo.get("RoleManagerID"));
				if(lastUpdated.equals("")) {
					lastUpdated = null;
				}
							
				setMap.put("objID", itemId);
				setMap.put("kpiID", kpiItemId);
				setMap.put("teamID", teamID);
				setMap.put("YearOrg", yearOrg);
				setMap.put("TargetValue", targetValue);
				setMap.put("lastUpdated", lastUpdated);
				setMap.put("Remark", remark);
				setMap.put("memberID", RoleManagerID);
			
				for(int idx=1; idx<13; idx++) {
					setMap.put("Remark", remark);
					setMap.put("Month", idx);
					setMap.put("Value", StringUtil.checkNull(jo.get("Month"+idx)));
					String years = year+","+yearOrg;
					setMap.put("Year", years);
					String ValueCnt = StringUtil.checkNull(commonService.selectString("custom_SQL.zhkfc_checkValueForProcMntrList", setMap),"0");
					int kpiValueCnt = Integer.parseInt(ValueCnt);
					setMap.put("Year", year);
					if(kpiValueCnt == 0) {
							commonService.insert("custom_SQL.zHKFC_insertProcMntrList", setMap); 
					}else if(kpiValueCnt == 1){
						commonService.insert("custom_SQL.zHKFC_updateProcMntrList", setMap); 
					}
				}
			}
			response.setCharacterEncoding("UTF-8");
			
		} catch (Exception e) {
			System.out.println(e);
		}
		response.getWriter().print(result);
	}

	@RequestMapping(value = "/zhkfc_getKpiList.do", produces = "application/text; charset=utf-8")
	public void zhkfc_getKpiList(HttpServletRequest request, HttpServletResponse response, HashMap commandMap) throws Exception {
		HashMap target = new HashMap();
		HashMap setMap = new HashMap();
		JSONArray result = new JSONArray();
		try {						
			response.setCharacterEncoding("UTF-8");
			
			setMap = new HashMap();
	    	setMap.put("ownerTeamID",commandMap.get("sessionTeamId"));
	    	setMap.put("classCode","CL05003");
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			setMap.put("s_itemID", s_itemID);
			
			String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"));
			if("OJ00008".equals(itemTypeCode)) {		
		    	setMap.put("s_itemID", s_itemID);
				String kpiAuthorID = StringUtil.checkNull(commonService.selectString("item_SQL.getItemAuthorId", setMap));
				setMap.put("kpiAuthorID", s_itemID);	
				setMap.put("kpiItemID", s_itemID);		
			} else {
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));		    	
				setMap.put("allItemID", s_itemID);	
			}
			
			String year = StringUtil.checkNull(request.getParameter("year"));
			setMap.put("year", year);
			String sessionAuthLev = StringUtil.checkNull(commandMap.get("sessionAuthLev"));
			String sessionUserID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String sessionTeamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
			
			// EDIT일 경우 본인 PMI만 조회
			String mode = StringUtil.checkNull(request.getParameter("mode"));
			if(!sessionAuthLev.equals("1") && "EDT".equals(mode)) { 
				setMap.put("authorID", sessionUserID); 
				setMap.put("roleTeamID", sessionTeamID);
			}
			List getProcMntrList = commonService.selectList("custom_SQL.zhkfc_getProcMntrList_gridList", setMap);
		
			result = new JSONArray(getProcMntrList);
		} catch (Exception e) {
			System.out.println(e);
		}
		response.getWriter().print(result);
	}
	
	@RequestMapping(value = "/zHKFC_deleteKkpiValue.do")
	public String zHKFC_deleteKkpiValue(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		HashMap setParam = new HashMap();
		try {
			String itemIDs[] = StringUtil.checkNull(request.getParameter("itemIDs")).split(",");
			String kpiItemIDs[] = StringUtil.checkNull(request.getParameter("kpiItemIDs")).split(",");
			String years[] = StringUtil.checkNull(request.getParameter("yearOrgs")).split(",");
			String teamIDs[] = StringUtil.checkNull(request.getParameter("teamIDs")).split(",");
			
			
			for (int i = 0; i < itemIDs.length; i++) {
				
				setParam.put("objID",itemIDs[i]);
				setParam.put("kpiID",kpiItemIDs[i]);
				setParam.put("year",years[i]);
				setParam.put("teamID",teamIDs[i]);
				commonService.update("custom_SQL.zHKFC_deleteKkpiValue", setParam);
			}
				
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); 
			target.put(AJAX_SCRIPT, "this.fnInit('N');this.$('#isSubmit').remove();");
			
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // �궘�젣 �삤瑜� 諛쒖깮
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/zhkfc_checkNewKpiList.do", produces = "application/text; charset=utf-8")
	public void zhkfc_checkNewKpiList(HttpServletRequest request, HttpServletResponse response, HashMap commandMap) throws Exception {
		HashMap target = new HashMap();
		HashMap setMap = new HashMap();
		JSONArray result = new JSONArray();
		String alertMessage = MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00117");
		Map temp = new HashMap();
		try {			
			JSONArray jsonArray  = new JSONArray(request.getParameter("editedRow"));
			
			for (int i = 0; i < jsonArray.length(); i++) {
				JSONObject jo = (JSONObject)jsonArray.get(i);
				
				setMap = new HashMap();
				
				if(!"".equals(StringUtil.checkNull(jo.get("Year")))
				   && !"".equals(StringUtil.checkNull(jo.get("Month")))
				   && !"".equals(StringUtil.checkNull(jo.get("MonthValue")))) {
					
					setMap.put("Identifier", jo.get("ObjectCode"));
					String itemId = StringUtil.checkNull(commonService.selectString("report_SQL.getItemIdWithIdentifier", setMap));
	
					setMap.put("Identifier", jo.get("KpiCode"));
					String kpiItemId = StringUtil.checkNull(commonService.selectString("report_SQL.getItemIdWithIdentifier", setMap));
					
					String teamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
					
					int year = Integer.valueOf(StringUtil.checkNull(jo.get("Year")));
					int month = Integer.valueOf(StringUtil.checkNull(jo.get("Month")));
					int value = Integer.valueOf(StringUtil.checkNull(jo.get("MonthValue")));
					
					setMap.put("objID", itemId);
					setMap.put("kpiID", kpiItemId);
					setMap.put("teamID", teamID);
					setMap.put("Year", year);
					setMap.put("YearOrg", year);
					setMap.put("Value", value);
					setMap.put("Month", month);
					setMap.put("TargetValue", jo.get("TargetValue"));
					setMap.put("lastUpdated", jo.get("KpiLastUpdated"));
					setMap.put("Remark", jo.get("Remark"));
					
					String ValueCnt = StringUtil.checkNull(commonService.selectString("custom_SQL.zhkfc_checkValueForProcMntrList", setMap),"0");
				
					if(!"0".equals(ValueCnt)) {						
						alertMessage = alertMessage.replace("{0}", StringUtil.checkNull(jo.get("ObjectName")) + "/" + StringUtil.checkNull(jo.get("KpiName"))+"/"+year);
											
						break;						
					}
					else {
						alertMessage = "NoMessage";
					}

				}
			}

			response.setCharacterEncoding("UTF-8");
			
			alertMessage = "[\"Message\",\"" + alertMessage + "\"]";
			System.out.println(alertMessage);
			result = new JSONArray(alertMessage);

		} catch (Exception e) {
			System.out.println(e);
		}

		response.getWriter().print(result);
	}
	

	@RequestMapping(value="/custom/hyundai/indexHKFC.do")
	public String indexHKFC(Map cmmMap,ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		try{				
			String hkfcSSO = StringUtil.checkNull(cmmMap.get("hkfcSSO"),"");
		
			Map setData = new HashMap();
		    String logonId = StringUtil.checkNull(cmmMap.get("LOGIN_ID"),"");
		    Map userInfo = new HashMap();
		    Map ssoInfo = new HashMap();
		    String scriptMsg = "";
		    String returnUrlTagName = "";
		    Map loginMap = new HashMap();
		    String encID = "KPAL";
		    String companyCode = "H108";
		    String encText = StringUtil.checkNull(cmmMap.get("Encode"),"");
			
		    if(hkfcSSO.equals("T")) {
		    	System.out.println("SSO nets Start");
		    	model.put("olmI", logonId);
		    	model.put("PWD_KEY", StringUtil.checkNull(cmmMap.get("PWD_KEY"),""));
		    	model.put("iv", StringUtil.checkNull(cmmMap.get("iv"),""));
		    	model.put("salt", StringUtil.checkNull(cmmMap.get("salt"),""));
		    }else {
		    	System.out.println("SSO Start");
			    String loginData = ""; //StringUtil.checkNull(KEFICO.SECURITY.LoginUtil.AutowayDecrypt(encID, companyCode, encText));

			    System.out.println(loginData);
			    if(!"".equals(loginData)) {    
				    String[] temp = loginData.split("___");

				    for(int i=0; i<temp.length; i++) {
				    	String[] temp2 = temp[i].split("\\|\\|");
				    	loginMap.put(temp2[0], StringUtil.checkNull(temp2[1]));
				    }
			    }
			    
			    if (!"".equals(StringUtil.checkNull(loginMap.get("User_ID")))) {
		            
		            logonId = StringUtil.checkNull(loginMap.get("User_ID")).replace("H1080","");

					setData.put("employeeNum", logonId);
					
					userInfo = commonService.select("common_SQL.getLoginIDFromMember", setData);

					if(userInfo != null && !userInfo.isEmpty()) {	
						String activeYN = "N";
						HashMap setMap = new HashMap();
						
						setMap.put("LOGIN_ID", StringUtil.checkNull(userInfo.get("LoginId")));
						
						activeYN = commonService.selectString("login_SQL.login_active_select", setMap);
						if(!"Y".equals(activeYN)) {
							return nextUrl("indexHKFC");
						}
						
						model.put("olmI", StringUtil.checkNull(userInfo.get("LoginId")));
					}
		        }
			    
		    }
			model.put("olmLng", StringUtil.checkNull(cmmMap.get("olmLng"),""));
			model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType"),""));
			model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType"),""));
			model.put("srID", StringUtil.checkNull(cmmMap.get("srID"),""));
			model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode"),""));
				
		}catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("HDCActionController::HDC Login ::Error::"+e);}

     	System.out.println(e.getMessage());
			return nextUrl("indexHKFC");	
		}		
		
		return nextUrl("indexHKFC");
	}
	
	
		
		@RequestMapping(value="/custom/hyundai/loginHKFCForm.do")
		public String loginHFKCForm(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		  HttpSession session = request.getSession(true);
		  
		  Map loginInfo = (Map)session.getAttribute("loginInfo");

		  if(loginInfo != null && !loginInfo.isEmpty()) {
			  	if("guest".equals(loginInfo.get("sessionLoginId"))) {
			  		session.invalidate();
					model.put("ssoYN", "N");
			  	}
			  	else {
					model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx"))); //singleSignOn 援щ텇
					model.put("ssoYN", "Y");
			  	}
		  }
		  else {
				model.put("ssoYN", "N");
		  }

		  model=setLoginScrnInfo(model,cmmMap);
		  
		  model.put("screenType", cmmMap.get("screenType"));
		  model.put("mainType", cmmMap.get("mainType"));
		  model.put("srID", cmmMap.get("srID"));
		  model.put("sysCode", cmmMap.get("sysCode"));
		  
		  model.put("PWD_KEY", cmmMap.get("PWD_KEY"));
		  model.put("iv", cmmMap.get("iv"));
		  model.put("salt", cmmMap.get("salt"));
		  model.put("status", cmmMap.get("status"));
		  return nextUrl("/custom/hyundai/hkfc/login");
		}
		

		private ModelMap setLoginScrnInfo(ModelMap model,HashMap cmmMap) throws ExceptionUtil {
			  
		  String pass = StringUtil.checkNull(cmmMap.get("pwd"));
		  model.addAttribute("loginid",StringUtil.checkNull(cmmMap.get("loginid"), ""));
		  model.addAttribute("pwd",pass);
		  model.addAttribute("lng",StringUtil.checkNull(cmmMap.get("lng"), ""));
		  try {
			  List langList = commonService.selectList("common_SQL.langType_commonSelect", cmmMap);
			  if( langList!=null &&langList.size() > 0){
				  for(int i=0; i<langList.size();i++){
					  Map langInfo = (HashMap) langList.get(i);
					  if(langInfo.get("IsDefault").equals("1")){
						  model.put("langType", StringUtil.checkNull(langInfo.get("CODE"),""));
						  model.put("langName", StringUtil.checkNull(langInfo.get("NAME"),""));
					  }
				  }
			  }else{model.put("langType", "");model.put("langName", "");}
			  model.put("langList", langList);
			  model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx"))); //singleSignOn 援щ텇
		  } catch(Exception e) {
			  throw new ExceptionUtil(e.toString());
		  }
		  return model;
	 	}
		

		@RequestMapping(value="/custom/hyundai/loginHKFC.do")
		public String loginHKFC(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
			try {
					HttpSession session = request.getSession(true);
					Map resultMap = new HashMap();
					String langCode = GlobalVal.DEFAULT_LANG_CODE;	
					String languageID = StringUtil.checkNull(cmmMap.get("LANGUAGE"),StringUtil.checkNull(cmmMap.get("LANGUAGEID")) );
					if("".equals(languageID)){
						languageID = GlobalVal.DEFAULT_LANGUAGE;
					}
					aesAction = new AESUtil();				
					aesAction.setIV(StringUtil.checkNull(cmmMap.get("iv")));
					aesAction.setSALT(StringUtil.checkNull(cmmMap.get("salt")));
					
					String LOGIN_ID = (String) cmmMap.get("LOGIN_ID");
					String PWD_KEY = (String) cmmMap.get("PWD_KEY");
					
					PWD_KEY =  aesAction.decrypt(PWD_KEY);
					aesAction.init();
					
					if(PWD_KEY.equals(GlobalVal.PWD_KEY)) {
						aesAction.setIV(StringUtil.checkNull(cmmMap.get("iv")));
						aesAction.setSALT(StringUtil.checkNull(cmmMap.get("salt")));
						LOGIN_ID =  aesAction.decrypt(LOGIN_ID);
						aesAction.init();
					}
					
					cmmMap.put("LOGIN_ID", LOGIN_ID);
					cmmMap.put("LANGUAGE", languageID);
					
					String ref = request.getHeader("referer");
					String protocol = request.isSecure() ? "https://" : "http://";
					
					String IS_CHECK = GlobalVal.PWD_CHECK;
					String url_CHECK = "Y";//StringUtil.chkURL(ref, protocol);

					if("".equals(IS_CHECK))
						IS_CHECK = "Y";
					
					
					if("".equals(url_CHECK)) {
						resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
						resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00002"));	
					}
					else {
						Map idInfo = new HashMap();
						idInfo = commonService.select("login_SQL.login_id_select", cmmMap);
					
						if(idInfo == null || idInfo.size() == 0) {
							resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
							resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00002"));				
						}
						else {	
							// visit log
							cmmMap.put("ActionType","LOGIN");						
							String ip = request.getHeader("X-FORWARDED-FOR");
					        if (ip == null) ip = request.getRemoteAddr();
					        cmmMap.put("IpAddress",ip);
							commonService.insert("gloval_SQL.insertVisitLog", cmmMap);
							
							Map loginInfo = commonService.select("login_SQL.login_select", cmmMap);
							if(loginInfo == null || loginInfo.size() == 0) {
								resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
								//resultMap.put(AJAX_ALERT, "System�뿉 �빐�떦 �궗�슜�옄 �젙蹂닿� �뾾�뒿�땲�떎.�벑濡� �슂泥�諛붾엻�땲�떎.");
								resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00102"));					
							}
							else {
								// [Authority] < 4 �씤 寃쎌슦, �닔�젙媛��뒫�븯寃� 蹂�寃�
								if(loginInfo.get("sessionAuthLev").toString().compareTo("4") < 0)	loginInfo.put("loginType", "editor");
								else	loginInfo.put("loginType", "viewer");	
								resultMap.put(AJAX_SCRIPT, "parent.fnReload('Y')");
								//resultMap.put(AJAX_MESSAGE, "Login�꽦怨�");					
								session.setAttribute("loginInfo", loginInfo);
							}
						}
					}
					model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx"))); //singleSignOn 援щ텇
					model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType")));
				    model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType")));
				    model.put("srID", StringUtil.checkNull(cmmMap.get("srID")));
				    model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode")));

					model.addAttribute(AJAX_RESULTMAP,resultMap);
			}
			catch (Exception e) {
				System.out.println(e.toString());
				if(_log.isInfoEnabled()){_log.info("LoginActionController::loginbase::Error::"+e);}
				throw new ExceptionUtil(e.toString());
			}
			return nextUrl(AJAXPAGE);
		}
		

		@RequestMapping("/custom/hyundai/zhfkc_inboundLink.do")
		public String zhdc_inboundLink(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
			String url = "/template/olmLinkPopup";
			try {
				String logonId = "";          // 로그온 된 사용자 아이디
			    Map userInfo = new HashMap();         // 로그온 된 사용자 추가정보
			    Map ssoInfo = new HashMap();         // 로그온 된 사용자 추가정보
			    Map setMap = new HashMap();         // 로그온 된 사용자 추가정보
			    String scriptMsg = "";        // 에러 메시지
			    String returnUrlTagName = ""; // 리턴 URL 태그 이름
			    String siteTagName = "";      // 사이트 응용프로그램 태그 이름
			    Map setData = new HashMap();
			    
			    Map loginMap = new HashMap();
			    String encID = "KPAL";
			    String companyCode = "H108";
			    String encText = StringUtil.checkNull(request.getParameter("olmLoginid"),"");
				String boardID = StringUtil.checkNull(request.getParameter("boardID"),"");
				String boardMgtID = StringUtil.checkNull(request.getParameter("boardMgtID"),"");
				model.put("boardID", boardID);
				model.put("boardMgtID", boardMgtID);
				
			    String loginData = "";//= StringUtil.checkNull(KEFICO.SECURITY.LoginUtil.AutowayDecrypt(encID, companyCode, encText));
			    loginData = URLDecoder.decode(loginData);
			    if(!"".equals(loginData)) {    
				    String[] temp = loginData.split("___");

				    for(int i=0; i<temp.length; i++) {
				    	String[] temp2 = temp[i].split("\\|\\|");
				    	loginMap.put(temp2[0], StringUtil.checkNull(temp2[1]));
				    }
			    }

		       if (!"".equals(StringUtil.checkNull(loginMap.get("User_ID")))) {
		            
		            logonId = StringUtil.checkNull(loginMap.get("User_ID"));

					setData.put("employeeNum", logonId);
					
					userInfo = commonService.select("common_SQL.getLoginIDFromMember", setData);

					if(userInfo != null && !userInfo.isEmpty()) {	
						String activeYN = "N";
						HashMap setInfo = new HashMap();
						
						setInfo.put("LOGIN_ID", StringUtil.checkNull(userInfo.get("LoginId")));
						
						activeYN = commonService.selectString("login_SQL.login_active_select", setInfo);
						if(!"Y".equals(activeYN)) {
							return nextUrl("indexHDC");
						}
						
						model.put("olmI", StringUtil.checkNull(userInfo.get("LoginId")));
						model.put("loginid", StringUtil.checkNull(userInfo.get("LoginId")));
					}
					
					String itemID = StringUtil.checkNull(commandMap.get("keyID"));
					String changeSetID = StringUtil.checkNull(commandMap.get("linkID"));
					String option = StringUtil.checkNull(commandMap.get("option"));
					String languageID = StringUtil.checkNull(commandMap.get("languageID"));
					String arCode = "";
					setMap = new HashMap();
					setMap.put("ChangeSetID", changeSetID);
					
					setMap.put("itemID", itemID);
					String maxVersion = commonService.selectString("cs_SQL.getItemReleaseVersion", setMap);
					
	
	
					model.put("itemID", itemID);
					model.put("changeSetID", changeSetID);
					model.put("arCode", arCode);
					model.put("option",option);
					model.put("languageID", languageID);
					
					model.put("olmLng", StringUtil.checkNull(commandMap.get("olmLng"),""));
					model.put("screenType", StringUtil.checkNull(commandMap.get("screenType"),""));
					model.put("mainType", StringUtil.checkNull(commandMap.get("mainType"),""));
					model.put("srID", StringUtil.checkNull(commandMap.get("srID"),""));
					model.put("sysCode", StringUtil.checkNull(commandMap.get("sysCode"),""));
					
					
		        } 	


			}  catch(Exception e) {
				System.out.println(e.toString());
			}		
			
			return nextUrl("/template/olmLinkPopup");
		}
		
	@RequestMapping(value="/zHkfcMain.do")
	public String olmMainHomeV34(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception{
		
		String url = "/custom/hyundai/hkfc/zHkfcMain";
		
		try {
			Map setMap = new HashMap();
			List viewItemTypeList = new ArrayList();
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String userId = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			String mLvl = StringUtil.checkNull(cmmMap.get("sessionMlvl"));
			String templCode = StringUtil.checkNull(request.getParameter("templCode"));
			String defDimValueID = "";
			String simpleMode = "N"; //경량화 모드
			
			// defDimValue
			if (!templCode.isEmpty()) {
				setMap.put("templCode", templCode);
				String templVarFilter = commonService.selectString("menu_SQL.getTemplVarFilter", setMap);
				String parameterName1 = "defDimValueID";
	
				String[] params = templVarFilter.split("&");
				for (String param : params) {
				    String[] keyValue = param.split("=");
				    if (keyValue.length == 2 && keyValue[0].equals(parameterName1)) {
				        defDimValueID = keyValue[1];
				    }
				}
			}
			model.put("defDimValueID", defDimValueID);
			model.put("templCode", templCode);
			
			// 경량화 모드 체크 (KR 법인 아닐 시)
			if(!"TMPL001".equals(templCode) && !"TMPL002".equals(templCode)) {
				simpleMode = "Y";
			}
			if("Y".equals(simpleMode)) {
				url = "/custom/hyundai/hkfc/zHkfcMainSimple";
			}
			
			// search start
			cmmMap.put("Deactivated","1");
			List itemTypeList = commonService.selectList("common_SQL.itemTypeCode_commonSelect", cmmMap);
			cmmMap.remove("Deactivated");
			model.put("itemTypeList", itemTypeList);
			// search end
			
			// my cs List start
			setMap.put("languageID",languageID);
			setMap.put("sessionCurrLangType",languageID);
			setMap.put("authorID",userId);
			// 결재
			setMap.put("actorID", userId);
			setMap.put("filter", "myWF");
			setMap.put("wfMode", "CurAprv");
			List wfCurAprvList = commonService.selectList("wf_SQL.getWFInstList_gridList",setMap);
			if(wfCurAprvList != null && !wfCurAprvList.isEmpty()) {
				model.put("wfCurAprvCnt",wfCurAprvList.size());
			}
			else {
				model.put("wfCurAprvCnt","0");
			}
			// 검토
			setMap.put("userID", userId);
			setMap.put("myID", userId);
			setMap.put("myBoard","Y");

			//setMap.put("beforeEndDT", "Y");
			// 한달 전 게시글만 게시
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
			long date = System.currentTimeMillis();
			Calendar mon = Calendar.getInstance();
			mon.add(Calendar.MONTH , -1);
			    
			setMap.put("scEndDt", formatter.format(date));
			setMap.put("scStartDt", formatter.format(mon.getTime()));
			
			setMap.put("BoardMgtID","BRD0001");
			
			List myRewBrdList = commonService.selectList("forum_SQL.forumGridList_gridList", setMap);
			model.put("myRewBrdList", myRewBrdList);
			// Q&A
			setMap.put("BoardMgtID","4");
			List myQABrdList = commonService.selectList("forum_SQL.forumGridList_gridList", setMap);
			model.put("myQABrdList", myQABrdList);
			// my cs List end
			
			model.put("srType", request.getParameter("srType"));
			model.put("viewItemTypeList",viewItemTypeList);
			model.put("languageID", languageID);	
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		}		
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		model.put("menu", getLabel(request, commonService));	//Label Setting
		model.put("screenType", request.getParameter("screenType"));
		return nextUrl(url);
	}
	
	@RequestMapping(value="/zhkfcOwnerItemList.do")
	public String zhkfcOwnerItemList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		Map setMap = new HashMap();
		
		try {
			
			String userId = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			setMap.put("top",5);
			setMap.put("languageID",languageID);
			setMap.put("managerID",userId);
			setMap.put("ownerType","manager");
			setMap.put("sessionUserId",userId);
			setMap.put("changeMgtYN","Y");
			List myItemList = commonService.selectList("item_SQL.getOwnerItemList_gridList", setMap);
			model.put("myItemList", myItemList);
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/custom/hyundai/hkfc/subMain/zhkfcOwnerItemList");
		
	}
	
	@RequestMapping(value="/zHkfcInnovationTaskStatistics.do")
	public String zHkfcInnovationTaskStatistics(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map setMap = new HashMap();
		String itemID = StringUtil.checkNull(commandMap.get("s_itemID"), (String)commandMap.get("itemID"));
		setMap.put("s_itemID", itemID);
		setMap.put("languageID", commandMap.get("languageID"));
		/*
		setMap.put("s_itemID", 161020);
		setMap.put("languageID", 1042);
		*/
		List graphInnovationTaskStatisticsList = commonService.selectList("custom_SQL.zhkfc_getGraphInnovationTaskStatistics", setMap);
		model.put("graphInnovationTaskStatisticsList", graphInnovationTaskStatisticsList);
		
		List graphInnovationTaskALLStatisticsList = commonService.selectList("custom_SQL.zhkfc_getGraphInnovationTaskALLStatistics", setMap);
		model.put("graphInnovationTaskALLStatisticsList", graphInnovationTaskALLStatisticsList);
		
		model.put("s_itemID", itemID);
		model.put("languageID", commandMap.get("languageID"));
		model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
		return nextUrl("/custom/hyundai/hkfc/report/zhfkc_innovationTaskStatistics");
	}
	

	@RequestMapping(value="/zhkfc_searchItemWFile.do")
	public String zhkfc_searchItemWFile(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		String url = "/custom/hyundai/hkfc/search/zhkfc_searchItemWFile";
		try{
			String screenType = StringUtil.checkNull(commandMap.get("screenType"));
			String searchValue = StringUtil.checkNull(commandMap.get("searchValue"));
			searchValue = StringUtil.replaceFilterString(searchValue);
			
			XSSRequestWrapper xss = new XSSRequestWrapper(request);
			searchValue = xss.stripXSS(searchValue);
			searchValue = xss.stripXSS2(searchValue);
			
			Map setMap = new HashMap();
			
			model.put("menu", getLabel(request, commonService));
			commandMap.put("Deactivated", "1");
			List itemTypeList = commonService.selectList("common_SQL.itemTypeCode_commonSelect", commandMap);
			model.put("itemTypeList", itemTypeList);
			model.put("AttrCode","AT00001");
			
			commandMap.put("category", "ITMSTS");
			List statusList = commonService.selectList("common_SQL.getDictionaryOrdStnm_commonSelect", commandMap);
			model.put("statusList", statusList);
			
			List attrTypeList = commonService.selectList("search_SQL.getAllocAttrTypeCodeList", commandMap);

			List searchLogList = new ArrayList();
			
			setMap.put("memberID", commandMap.get("sessionUserId"));
			searchLogList = commonService.selectList("search_SQL.getMySearchHistoryForTop3", setMap);
			
			model.put("searchLogList", searchLogList);
			
			model.put("attrTypeList", attrTypeList);
			model.put("screenType", screenType);
			model.put("searchValue", searchValue);
			String wiseNutUrl = HMGGlobalVal.wiseNutPopularURL;
			List popularList = getWiseNutPopularKeyword(wiseNutUrl);
			model.put("popularList", popularList);
			 
			//model.put("keyword", keyword);
		} catch(Exception e) {
			System.out.println(e.toString());
		}		
		
		return nextUrl(url);
	}
	
	@RequestMapping(value="/zhkfc_searchItemWFileList.do")
	public String zhkfc_searchItemWFileList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		String url = "/custom/hyundai/hkfc/search/zhkfc_searchItemWFileList";
		try{
			String itemIDs = StringUtil.checkNull(commandMap.get("itemIDs"));
			String searchQuery = StringUtil.checkNull(commandMap.get("searchQuery"),"");
			String itemTypeCode = StringUtil.checkNull(commandMap.get("ItemTypeCode"));
			
			String AuthorName = StringUtil.checkNull(commandMap.get("AuthorName"),"");
			String OwnerTeamName = StringUtil.checkNull(commandMap.get("OwnerTeamName"),"");
			String StartDate = StringUtil.checkNull(commandMap.get("StartDate"),"");
			String EndDate = StringUtil.checkNull(commandMap.get("EndDate"),"");
			String StatusCode = StringUtil.checkNull(commandMap.get("StatusCode"),"");
			
	    	String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"),GlobalVal.DEFAULT_LANGUAGE);
			//List itemArrayList = (List) commandMap.get("AttrCode");
			String itemArrayList = StringUtil.checkNull(commandMap.get("itemArrayList"));
			String fileArrayList = StringUtil.checkNull(commandMap.get("fileArrayList"));
			String[] itemArrayTemp = null;
			String[] fileArrayTemp = null;

			commandMap.put("languageID", languageID);
			SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Map logMap = new HashMap();
			
			logMap.put("searchText",searchQuery);
			logMap.put("memberID",StringUtil.checkNull(commandMap.get("sessionUserId")));
			logMap.put("teamID",StringUtil.checkNull(commandMap.get("sessionTeamId")));
			
			commonService.insert("search_SQL.insertSearchLog", logMap);
			
			if(itemArrayList.indexOf("@OLM_ARRAY_END@,@OLM_ARRAY_START@") > -1) {
				itemArrayTemp = itemArrayList.split("@OLM_ARRAY_END@,@OLM_ARRAY_START@");
			}
			else if(itemArrayList.indexOf("@OLM_ARRAY_END@") > -1) {
				itemArrayTemp = new String[1];
				itemArrayTemp[0] = itemArrayList;
			}
			else {
				itemArrayTemp = new String[0];
			}
			
			if(fileArrayList.indexOf("@OLM_FILE_ARRAY_END@,@OLM_FILE_ARRAY_START@") > -1) {
				fileArrayTemp = fileArrayList.split("@OLM_FILE_ARRAY_END@,@OLM_FILE_ARRAY_START@");
			}
			else if(fileArrayList.indexOf("@OLM_FILE_ARRAY_END@") > -1) {
				fileArrayTemp = new String[1];
				fileArrayTemp[0] = fileArrayList;
			}
			else {
				fileArrayTemp = new String[0];
			}
			
			String searchQuery2 = StringUtil.checkNull(commandMap.get("searchQuery"),"").replace(" ","");
			
			if(searchQuery.equals(searchQuery2)) {
				searchQuery2 = "";
			}
			
			String bTypeCd = "";
			Map itemTypeMap = new HashMap();
			Map itemListMap = new HashMap();
			Map setMap = new HashMap();
			List searchList = new ArrayList();
			List attrTypeCodeList = new ArrayList();
			Map attrTypeMap = new HashMap();
			String afterItemID = "";
			int j=1;
			String itemIDs2 = "";
			String afterVersion = "";
			String beforeVersion = "";

			Map fileMap = new HashMap();

			for(int i=0; i<fileArrayTemp.length; i++) {
				String[] temp = fileArrayTemp[i].replace("@OLM_FILE_ARRAY_END@", "").split("@OLM@");

				fileMap.put(temp[0], temp[1]);
			
			}
			
			for(int i=0; i<itemArrayTemp.length; i++) {
				String[] temp = itemArrayTemp[i].replace("@OLM_ARRAY_END@", "").split("@OLM@");
				
				if(!"".equals(StartDate) && !"".equals(EndDate)) {

					Date StartDT = transFormat.parse(StartDate);	
					Date EndDT = transFormat.parse(EndDate);		
					Date searchDT = transFormat.parse(temp[10]);
					
					if(!StartDT.after(searchDT) || !EndDT.before(searchDT)) {
						continue;
					}
					
				}
				Map tempMap = new HashMap();	
				String itemID = temp[0];
				setMap.put("typeCode",temp[6]);
				setMap.put("languageID",languageID);
				setMap.put("category","AT");
				String attrName = StringUtil.checkNull(commonService.selectString("common_SQL.getNameFromDic",setMap));
				
				if(i == 0 || "".equals(itemIDs2)) {
					itemIDs2 =  itemID;
				}
				else  {
					itemIDs2 = itemIDs2 + "," + itemID;
				}

				if(!"".equals(searchQuery2)) {
					temp[2] = temp[2].replace(searchQuery2, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery2+"\"</span>");
					temp[7] = temp[7].replace(searchQuery2, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery2+"\"</span>");
				}
				
				if(!"".equals(searchQuery)) {
					temp[2] = temp[2].replace(searchQuery, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery+"\"</span>");
					temp[7] = temp[7].replace(searchQuery, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery+"\"</span>");
				}
				
				
				if(!afterItemID.equals(itemID)) {
					
					tempMap.put("ItemID",temp[0]);			
					tempMap.put("Identifier",temp[1]);		
					tempMap.put("ItemName",temp[2].replaceAll("\"\"","\""));			
					tempMap.put("Path",temp[3]);				
					tempMap.put("ItemTypeCode",temp[4]);		
					tempMap.put("StatusName",temp[5]);	
					
					if(!"AT00001".equals(temp[6])) {
						tempMap.put(temp[6],"[" + attrName + "]&nbsp;&nbsp;&nbsp;&nbsp;"+temp[7].replaceAll("\"\"","\""));
					}
					
					tempMap.put("Name",temp[8]);			
					tempMap.put("TeamName",temp[9]);			
					tempMap.put("LastUpdated",temp[10]);
					afterItemID = temp[0];

					commandMap.put("DocumentID", StringUtil.checkNull(temp[0]));
					List documentList = new ArrayList();
					List documentList2 = commonService.selectList("fileMgt_SQL.getFile_gridList", commandMap);
					
					if(documentList2 != null && !documentList2.isEmpty()) {

						if(documentList2.size() > 20) {
							
							for(int k=0; k < documentList2.size(); k++) {
								Map tempMap2 = (Map) documentList2.get(k);
								String seq = StringUtil.checkNull(tempMap2.get("Seq"));
								String fileRealName = StringUtil.checkNull(tempMap2.get("FileRealName"));
								String fileName = StringUtil.checkNull(tempMap2.get("FileName"));
								
								if(fileMap.containsKey(seq)) {
									String fileDesc = StringUtil.checkNull(fileMap.get(seq),"");
									
									if(!"||".equals(fileDesc)) {
										if(!"".equals(searchQuery2)) {
											fileDesc = fileDesc.replace(searchQuery2, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery2+"\"</span>");
										}
										
										if(!"".equals(searchQuery)) {
											fileDesc = fileDesc.replace(searchQuery, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery+"\"</span>");
										}
	
										if("".equals(fileRealName)) {
											tempMap2.put("FileRealName", fileName);
										}
										tempMap2.put("fileDescription", "->" + fileDesc);
										}
									else {
										tempMap2.put("fileDescription", "->");
									}
									documentList.add(tempMap2);
								}
							}

						}
						else {
							for(int k=0; k < documentList2.size(); k++) {
								Map tempMap2 = (Map) documentList2.get(k);
								String seq = StringUtil.checkNull(tempMap2.get("Seq"));
								String fileRealName = StringUtil.checkNull(tempMap2.get("FileRealName"));
								String fileName = StringUtil.checkNull(tempMap2.get("FileName"));
								
								if(fileMap.containsKey(seq)) {
									String fileDesc = StringUtil.checkNull(fileMap.get(seq),"");
									if(!"||".equals(fileDesc)) {
										if(!"".equals(searchQuery2)) {
											fileDesc = fileDesc.replace(searchQuery2, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery2+"\"</span>");
										}
										
										if(!"".equals(searchQuery)) {
											fileDesc = fileDesc.replace(searchQuery, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery+"\"</span>");
										}
	
										if("".equals(fileRealName)) {
											tempMap2.put("FileRealName", fileName);
										}
										tempMap2.put("fileDescription", "->" + fileDesc);
									}
									else {
										tempMap2.put("fileDescription", "->");										
									}
								}
								documentList.add(tempMap2);
							}
						}
					}

					tempMap.put("documentList",documentList);					
					searchList.add(tempMap);
				}
				else if(afterItemID.equals(itemID)) {

					Map temp2 = (Map) searchList.get(i-j);

					if(!"AT00001".equals(temp[6])) {
						temp2.put(temp[6],"[" + attrName + "]&nbsp;&nbsp;&nbsp;&nbsp;"+temp[7].replaceAll("\"\"","\""));	
					}
					
					searchList.remove(i-j);
					searchList.add(temp2);
					j++;
				}
				
				if(!attrTypeMap.containsKey(temp[6])) {
					attrTypeMap.put(temp[6],temp[6]);
				}
			}

			model.put("attrTypeMap", attrTypeMap);	
			model.put("attrTypeMapCnt", attrTypeMap.size());	
			model.put("menu", getLabel(request, commonService));		
			//  AttrCode=[{attrCode=AT00001, selectOption=AND, AttrCodeEscape=, constraint=, searchValue=원부자재}]

			
			Map setMap2 = new HashMap();
			setMap2.put("childItems",itemIDs);
			setMap2.put("masterItemId", itemIDs2);
			setMap2.put("languageID",languageID);
			setMap2.put("ItemTypeCode",itemTypeCode);
			setMap2.put("OwnerTeam",OwnerTeamName);
			setMap2.put("Status",StatusCode);
			setMap2.put("Name",AuthorName);
			setMap2.put("LastUpdated","Y");
			setMap2.put("scStartDt2",StartDate);
			setMap2.put("scEndDt2",EndDate);
			List searchList2 = new ArrayList();
			if(!"".equals(itemIDs)) {
				searchList2 = commonService.selectList("search_SQL.getSearchMultiList_gridList", setMap2);
			}
			
			String itemList2 = "";
			if(searchList2.size()>0) {
				for(int i1=0; i1<searchList2.size(); i1++) {
					Map listMap = (Map)searchList2.get(i1);
					if(i1==0) {
						itemList2 = StringUtil.checkNull(listMap.get("ItemID"));
					}else {
						itemList2 += "," + StringUtil.checkNull(listMap.get("ItemID"));
					}
					
					commandMap.put("DocumentID", StringUtil.checkNull(listMap.get("ItemID")));
					List documentList = new ArrayList();
					List documentList2 = commonService.selectList("fileMgt_SQL.getFile_gridList", commandMap);

					if(documentList2 != null && !documentList2.isEmpty()) {

						if(documentList2.size() > 20) {
							for(int k=0; k < documentList2.size(); k++) {
								Map tempMap2 = (Map) documentList2.get(k);
								String seq = StringUtil.checkNull(tempMap2.get("Seq"));
								String fileRealName = StringUtil.checkNull(tempMap2.get("FileRealName"));
								String fileName = StringUtil.checkNull(tempMap2.get("FileName"));
								
								if(fileMap.containsKey(seq)) {
									String fileDesc = StringUtil.checkNull(fileMap.get(seq),"");
									if(!"||".equals(fileDesc)) {
										if(!"".equals(searchQuery2)) {
											fileDesc = fileDesc.replace(searchQuery2, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery2+"\"</span>");
										}
										
										if(!"".equals(searchQuery)) {
											fileDesc = fileDesc.replace(searchQuery, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery+"\"</span>");
										}
										
										tempMap2.put("fileDescription", "->" + fileDesc);
									}
									else {
										tempMap2.put("fileDescription", "->");
									}
									if("".equals(fileRealName)) {
										tempMap2.put("FileRealName", fileName);
									}
									documentList.add(tempMap2);
								}
							}

						}
						else {
							for(int k=0; k < documentList2.size(); k++) {
								Map tempMap2 = (Map) documentList2.get(k);
								String seq = StringUtil.checkNull(tempMap2.get("Seq"));
								String fileRealName = StringUtil.checkNull(tempMap2.get("FileRealName"));
								String fileName = StringUtil.checkNull(tempMap2.get("FileName"));
								
								if(fileMap.containsKey(seq)) {
									String fileDesc = StringUtil.checkNull(fileMap.get(seq),"");

									if(!"||".equals(fileDesc)) {
										if(!"".equals(searchQuery2)) {
											fileDesc = fileDesc.replace(searchQuery2, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery2+"\"</span>");
										}
										
										if(!"".equals(searchQuery)) {
											fileDesc = fileDesc.replace(searchQuery, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery+"\"</span>");
										}
										tempMap2.put("fileDescription", "->" + fileDesc);
									}
									else {
										tempMap2.put("fileDescription", "->");										
									}

									if("".equals(fileRealName)) {
										tempMap2.put("FileRealName", fileName);
									}
								}
								documentList.add(tempMap2);
							}
						}
					}
					listMap.put("documentList",documentList);

					String description = "";
					if (null != listMap.get("ProcessInfo")) {
						description = removeAllTag(StringUtil.checkNull(listMap.get("ProcessInfo")));
						if(description.length()>99) {
							description = description.substring(100) + "...";
						}
					}
					String ItemName = "";

					if(!"".equals(searchQuery2)) {
						ItemName = ItemName.replace(searchQuery2, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery2+"\"</span>");
						description = description.replace(searchQuery2, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery2+"\"</span>");
					}

					if(!"".equals(searchQuery)) {
						ItemName = ItemName.replace(searchQuery, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery+"\"</span>");
						description = description.replace(searchQuery, "<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\""+searchQuery+"\"</span>");
					}
	 				
					listMap.put("ItemName", ItemName.replaceAll("\"\"","\""));
					listMap.put("StringProcessInfo", description.replaceAll("\"\"","\""));
				}
			}

			if(searchList != null && !searchList.isEmpty() && searchList.size() > 0) {
				searchList.addAll(searchList.size(), searchList2);
			}
			else {
				searchList = searchList2;
			}
			
			String itemIDList = itemIDs2;
			
			if(!"".equals(itemList2)) {
				itemIDList = itemIDList + "," + itemList2;
			}
			
			Map setData = new HashMap();			
			setData.put("itemIDList", itemIDList);
			setData.put("CategoryCode", commandMap.get("CategoryCode"));
			setData.put("Deactivated", "1");
			setData.put("languageID", commandMap.get("sessionCurrLangType"));
			
			List itemTypeList = new ArrayList();
			if(searchList.size()>0) {
				itemTypeList = commonService.selectList("search_SQL.getCountListItemByItemTypeCode", setData);
			}
			
			model.put("itemTypeList", itemTypeList);
			model.put("searchList", searchList);
			
		} catch(Exception e) {
			System.out.println(e.toString());
		}		
		
		return nextUrl(url);
	}

	/**
	 * Process 통계 (2014/11/20)
	 * TW_PROCESS 테이블의 데이터 이용
	 * @param request
	 * @param model
	 * @return
	 * @throws ExceptionUtil
	 */
	@RequestMapping(value="/custom/zHkfc_ProcessStatistics.do")
	public String zHkfc_ProcessStatistics(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		String url = "/custom/hyundai/hkfc/report/zHkfc_ProcessStatistics";
		
		Map setMap = new HashMap();
		try {
			String languageID = StringUtil.checkNull(request.getParameter("languageID"), String.valueOf(commandMap.get("sessionCurrLangType")));
			String filepath = request.getSession().getServletContext().getRealPath("/");
			/* xml 파일명 설정 */
	        String xmlFilName = "upload/zHkfc_ProcessStatistics.xml";
	        String header = "";
			String isMainMenu = StringUtil.checkNull(request.getParameter("isMainMenu"));
	        
	        /* update 버튼 클릭으로 본 엑션을 호출한 경우 Process Insert procedure를 기동한다 */
	        if (!StringUtil.checkNull(request.getParameter("eventMode")).isEmpty()) {
	        	 commonService.insert("analysis_SQL.insertTwProcess", setMap);
	        }
	       
			setMap.put("LanguageID", languageID);
			
			// Dimension 검색 정보 설정
			if (!StringUtil.checkNull(request.getParameter("DimTypeID")).isEmpty()) {
				setMap.put("DimTypeID", request.getParameter("DimTypeID"));
				model.put("DimTypeID", request.getParameter("DimTypeID"));
				if (!StringUtil.checkNull(request.getParameter("DimValueID")).isEmpty()) {
					setMap.put("DimValueID", request.getParameter("DimValueID"));
					model.put("DimValueID", request.getParameter("DimValueID"));
				}
			}
			
			// get Level1 NameList (grid header표시용)
	     	List level1NameList = commonService.selectList("analysis_SQL.getLevel1Name", setMap);
	        zHkfc_SetProcessStatistics(filepath, level1NameList, xmlFilName, setMap, request);
	     	
	        for (int j = 0; j < level1NameList.size(); j++) {
	        	Map level1NameMap = (Map) level1NameList.get(j);
        		String level1Name =String.valueOf(level1NameMap.get("label"))+ ",#cspan";
        		header = header + "," + level1Name;
	        }
	        
	        // Dimension 검색조건:DimtypeList
	        //List dimTypeList = commonService.selectList("dim_SQL.getDimTypeList", commandMap);	
			//model.put("dimTypeList", dimTypeList);
	        
	        model.put("level1Name", header + ",Total,#cspan");
	        model.put("cnt", (level1NameList.size() + 2) * 2);
	        model.put("xmlFilName", xmlFilName);
			model.put("isMainMenu", isMainMenu);
			model.put("menu", getLabel(request, commonService));
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl(url);
	}
	
	/**
	 * Process 통계 (2014/11/20)
	 * TW_PROCESS 테이블의 데이터 이용
	 * @param request
	 * @param model
	 * @return
	 * @throws ExceptionUtil
	 */
	@RequestMapping(value="/custom/zHkfc_ProcessStatisticsWithItSystem.do")
	public String zHkfc_ProcessStatisticsWithItSystem(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		String url = "/custom/hyundai/hkfc/report/zHkfc_ProcessStatisticsWithItSystem";
		
		Map setMap = new HashMap();
		try {
			String languageID = StringUtil.checkNull(request.getParameter("languageID"), String.valueOf(commandMap.get("sessionCurrLangType")));
			String filepath = request.getSession().getServletContext().getRealPath("/");
			/* xml 파일명 설정 */
	        String xmlFilName = "upload/zHkfc_ProcessStatisticsWithItSystem.xml";
	        String header = "";
			String isMainMenu = StringUtil.checkNull(request.getParameter("isMainMenu"));
	        
	        /* update 버튼 클릭으로 본 엑션을 호출한 경우 Process Insert procedure를 기동한다 */
	        if (!StringUtil.checkNull(request.getParameter("eventMode")).isEmpty()) {
	        	 commonService.insert("analysis_SQL.insertTwProcess", setMap);
	        }
	       
			setMap.put("LanguageID", languageID);
			
			// Dimension 검색 정보 설정
			if (!StringUtil.checkNull(request.getParameter("DimTypeID")).isEmpty()) {
				setMap.put("DimTypeID", request.getParameter("DimTypeID"));
				model.put("DimTypeID", request.getParameter("DimTypeID"));
				if (!StringUtil.checkNull(request.getParameter("DimValueID")).isEmpty()) {
					setMap.put("DimValueID", request.getParameter("DimValueID"));
					model.put("DimValueID", request.getParameter("DimValueID"));
				}
			}
			
			// get Level1 NameList (grid header표시용)
	     	List level1NameList = commonService.selectList("analysis_SQL.getLevel1Name", setMap);
	        zHkfc_SetProcessStatisticsWithItSystem(filepath, level1NameList, xmlFilName, setMap, request);
	     	
	        for (int j = 0; j < level1NameList.size(); j++) {
	        	Map level1NameMap = (Map) level1NameList.get(j);
        		String level1Name =String.valueOf(level1NameMap.get("label"))+ ",#cspan";
        		header = header + "," + level1Name;
	        }
	        
	        // Dimension 검색조건:DimtypeList
	        //List dimTypeList = commonService.selectList("dim_SQL.getDimTypeList", commandMap);	
			//model.put("dimTypeList", dimTypeList);
	        
	        model.put("level1Name", header + ",Total,#cspan");
	        model.put("cnt", (level1NameList.size() + 2) * 2);
	        model.put("xmlFilName", xmlFilName);
			model.put("isMainMenu", isMainMenu);
			model.put("menu", getLabel(request, commonService));
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl(url);
	}
	
	/**
	 * Process 통계에 표시할 내용을 xml 파일로 생성
	 * @param filepath
	 * @param prcCountList
	 * @param level1NameList
	 * @param xmlFilName
	 * @param setMap
	 * @throws ExceptionUtil
	 */
	private void zHkfc_SetProcessStatisticsWithItSystem(String filepath, List level1NameList, String xmlFilName, Map setMap, HttpServletRequest request) throws ExceptionUtil {
		
        // 통계 수치 resultList를 xml에 값 셋팅해서 grid 생성 
		// 통계 리스트 표시 할 xml 파일 생성
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance(); 
		try {
	    DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
	    
	    // 루트 엘리먼트 
	    Document doc = docBuilder.newDocument(); 
	    Element rootElement = doc.createElement("rows"); 
	    doc.appendChild(rootElement); 
		
	    int rowId = 1;
	    int rowTotal = 0;
	    String classCode = "CL01002";
	    String classLevel = "2";
	    
	    Map<String, Integer> level4TotalMap = new HashMap<String, Integer>();
	    Map activityTotalMap = new HashMap();
	    Map<String, Integer> level6TotalMap = new HashMap<String, Integer>();
	    int levell4TtlCnt = 0;
	    int activityTtlCnt = 0;
	    int levell6TtlCnt = 0;
	    
	    // row 엘리먼트 
        Element row = doc.createElement("row"); 
        rootElement.appendChild(row); 
        row.setAttribute("id", String.valueOf(rowId));
        rowId++;
	    
        Element cell = doc.createElement("cell");
        cell.appendChild(doc.createTextNode(setTitleCell(classLevel, "Y")));
        //cell.setAttribute("colspan", "2"); // title
        cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");
        row.appendChild(cell); 
        cell = doc.createElement("cell");
        cell.appendChild(doc.createTextNode(setTitleCell(classLevel, "N")));
        row.appendChild(cell);

        Map conditionMap = new HashMap();
        
        List newPrcCntList = new ArrayList();
        Map newPrcCntMap = new HashMap();
        
        for (int i = 0; i < level1NameList.size(); i++) {
        	Map map = (Map) level1NameList.get(i);
        	conditionMap.put(String.valueOf(map.get("ItemID")), String.valueOf(map.get("label")));
        }
        setMap.put("ItemTypeCode", "OJ00001");
        List itemClassCodeList = commonService.selectList("analysis_SQL.getItemClassCodeList", setMap);

		int MaxLevel = Integer.parseInt(commonService.selectString("analysis_SQL.getItemClassMaxLevel", setMap));

        Map prcCountMap = new HashMap();
        List prcCountList = new ArrayList();
        for(int icidx = 0; icidx < itemClassCodeList.size(); icidx++) {
        	prcCountMap = new HashMap();
        	Map tempMap = (Map)itemClassCodeList.get(icidx);
        	String itemClassCode = tempMap.get("ItemClassCode").toString();
        	int Level = Integer.parseInt(tempMap.get("Level").toString());
        	 // get L2 List
        	
            setMap.put("ItemClassCode", itemClassCode);
            
            if("CL01005".equals(itemClassCode))
            	setMap.put("isDim", "Y");
            else if(!"CL01006".equals(itemClassCode))
            	setMap.put("isDim", "N");
            
            if(icidx != itemClassCodeList.size()-1) {
                prcCountList = commonService.selectList("analysis_SQL.getPrcCountList", setMap);
            }
            else {
                
                prcCountList = commonService.selectList("analysis_SQL.getPrcCountListL5", setMap);
            }
            
            for (int i = 0; i < prcCountList.size(); i++) {
            	Map map = (Map) prcCountList.get(i);
            	prcCountMap.put(String.valueOf(map.get("L1ItemID")), String.valueOf(map.get("CNT")));
            }
            for (int i = 0; i < level1NameList.size(); i++) {
            	newPrcCntMap = new HashMap();
            	Map map1 = (Map) level1NameList.get(i);
            	newPrcCntMap.put("L1ItemID", String.valueOf(map1.get("ItemID")));
            	newPrcCntMap.put("ItemClassCode", itemClassCode);
            	newPrcCntMap.put("ItemClassLevel", Level);
            	newPrcCntMap.put("Identifier", String.valueOf(map1.get("Identifier")));
            	
            	if (prcCountMap.containsKey(String.valueOf(map1.get("ItemID")))) {
            		newPrcCntMap.put("CNT", prcCountMap.get(String.valueOf(map1.get("ItemID"))));
            	} else {
            		newPrcCntMap.put("CNT", "0");
            	}
            	newPrcCntList.add(newPrcCntMap);
            }
            
        }

        /* Activity 이외의 item count row 생성 */
	    for (int i = 0; i < newPrcCntList.size(); i++) {
	    	prcCountMap = (Map) newPrcCntList.get(i);
	    	String level1ItemId = StringUtil.checkNull(prcCountMap.get("L1ItemID"));
	    	if (conditionMap.containsKey(level1ItemId)) {

	    		int level = Integer.parseInt(prcCountMap.get("ItemClassLevel").toString());
	    		if (!classCode.equals(prcCountMap.get("ItemClassCode"))) {
		    		classCode = String.valueOf(prcCountMap.get("ItemClassCode"));
		    		//if (!classCode.equals("CL01006")) { //TODO:L4의 Total만표시 할때의 조건
		    		if (level <= MaxLevel) {
		    			// Total cell 값 설정 후, 새로운 row 추가
		    			cell = doc.createElement("cell");
				        cell.appendChild(doc.createTextNode(String.valueOf(rowTotal)));
				        cell.setAttribute("style", "font-weight:bold;");
				        cell.setAttribute("colspan", "2"); // cnt1
				        row.appendChild(cell);
				        cell = doc.createElement("cell");
				        cell.appendChild(doc.createTextNode(""));
				        row.appendChild(cell);
				        rowTotal = 0;  // Total 값 초기화
				        
		    			row = doc.createElement("row"); 
			            rootElement.appendChild(row); 
			            row.setAttribute("id", String.valueOf(rowId));
			            rowId++;
			            
			            cell = doc.createElement("cell");
				        cell.appendChild(doc.createTextNode(setTitleCell(prcCountMap.get("ItemClassLevel").toString(), "Y")));
				        //cell.setAttribute("colspan", "2"); // title
				        cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");
				        row.appendChild(cell); 
				        cell = doc.createElement("cell");
				        cell.appendChild(doc.createTextNode(setTitleCell(prcCountMap.get("ItemClassLevel").toString(), "N")));
				        row.appendChild(cell);
		    		}
		    	}
	    		cell = doc.createElement("cell");
		        cell.appendChild(doc.createTextNode(String.valueOf(prcCountMap.get("CNT"))));
		        cell.setAttribute("colspan", "2"); // cnt1
		        row.appendChild(cell);
		        cell = doc.createElement("cell");
		        cell.appendChild(doc.createTextNode(""));
		        row.appendChild(cell);
		        rowTotal = rowTotal + Integer.parseInt(String.valueOf(prcCountMap.get("CNT")));

		        if (level == MaxLevel) { 
		    		activityTotalMap.put(prcCountMap.get("Identifier").toString()+"_CNT", prcCountMap.get("CNT"));
		    	}
	    	}
	    }

		
		activityTotalMap.put("totalCnt", rowTotal);
	    //activityTotalMap.put("TTL", activityTtlCnt);
	    level4TotalMap.put("TTL", levell4TtlCnt);
	    
	    // Activity 이외의 item 마지막 row의 Total cell 값 설정 
		cell = doc.createElement("cell");
        cell.appendChild(doc.createTextNode(String.valueOf(rowTotal)));
        cell.setAttribute("style", "font-weight:bold;color:#0D65B7;text-decoration:underline;");
        cell.setAttribute("colspan", "2"); // cnt1
        row.appendChild(cell);
        cell = doc.createElement("cell");
        cell.appendChild(doc.createTextNode(""));
        row.appendChild(cell);
        rowTotal = 0;  // Total 값 초기화
        
        Map<String, Integer> roleCntMap = setProcessStatisticsWithItSystem(doc, rootElement, row, cell, rowId, activityTotalMap);
    	rowId = roleCntMap.get("rowId");
        
    	Map<String, Integer> pmiCntMap = setCnAvgItemsRow(doc, rootElement, row, cell, rowId, level1NameList, setMap, "CN00104", "toItemID", activityTotalMap);
        rowId = pmiCntMap.get("rowId");
        
	    // XML 파일로 쓰기 
        TransformerFactory transformerFactory = TransformerFactory.newInstance(); 
        Transformer transformer = transformerFactory.newTransformer(); 
        transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8"); 
	    transformer.setOutputProperty(OutputKeys.INDENT, "yes");        
	    DOMSource source = new DOMSource(doc); 	    
	    StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + xmlFilName))); 
	    transformer.transform(source, result); 
		}
		catch(Exception e) {
			throw new ExceptionUtil(e.toString());
		}
	}
	
	private Map<String, Integer> setProcessStatisticsWithItSystem(Document doc, Element rootElement, Element row, Element cell, int rowId, Map activityTotalMap) throws Exception {
		Map<String, Integer> cnItemsMap = new HashMap<String, Integer>();

        List procStaticsWithItsystemList = new ArrayList();
		procStaticsWithItsystemList = commonService.selectList("custom_SQL.zHkfc_getProcessStatisticsWithItSystem", cnItemsMap);
		
        
        String SL1_name = "";
        int l5totalcnt = 0;
        int sysRowTotalCnt = 0;
        int[] sysTotalCnt = new int[13];
        int sysCnt = 0;
        float average = 0;
        for (int i = 0; i < procStaticsWithItsystemList.size(); i++) {
        	Map procStaticsWithItsystem = (Map) procStaticsWithItsystemList.get(i);
        	SL1_name = String.valueOf(procStaticsWithItsystem.get("SL1_name"));
        	
        	row = doc.createElement("row"); 
            rootElement.appendChild(row); 
            row.setAttribute("id", String.valueOf(rowId));
            rowId++;
            
            cell = doc.createElement("cell");
            cell.setAttribute("rowspan", String.valueOf(procStaticsWithItsystemList.size()+1));
            cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");
            cell.appendChild(doc.createTextNode("전산화율 (L5기준)"));
            row.appendChild(cell);
            
        	cell = doc.createElement("cell");
            cell.appendChild(doc.createTextNode(SL1_name));
            row.appendChild(cell);
            
            cell = doc.createElement("cell");
	        cell.appendChild(doc.createTextNode(String.valueOf(procStaticsWithItsystem.get("ITSYS01"))));
	        row.appendChild(cell);
	        
	        cell = doc.createElement("cell");
	        sysCnt = Integer.parseInt(String.valueOf(procStaticsWithItsystem.get("ITSYS01")));
	        sysRowTotalCnt += sysCnt;
	        sysTotalCnt[0] += sysCnt;
	        l5totalcnt = Integer.parseInt(String.valueOf(activityTotalMap.get("01_CNT")));
	        average = (float) ((float) ((float) sysCnt / (float) l5totalcnt)* 100.00);
	        average = (float) (Math.round(average*10)/10.0);
	        cell.appendChild(doc.createTextNode(String.valueOf(average)+"%"));
	        row.appendChild(cell);
	        
	        cell = doc.createElement("cell");
	        cell.appendChild(doc.createTextNode(String.valueOf(procStaticsWithItsystem.get("ITSYS02"))));
	        row.appendChild(cell);
	        
	        cell = doc.createElement("cell");
	        sysCnt = Integer.parseInt(String.valueOf(procStaticsWithItsystem.get("ITSYS02")));
	        sysRowTotalCnt += sysCnt;
	        sysTotalCnt[1] += sysCnt;
	        l5totalcnt = Integer.parseInt(String.valueOf(activityTotalMap.get("02_CNT")));
	        average = (float) ((float) ((float) sysCnt / (float) l5totalcnt)* 100.00);
	        average = (float) (Math.round(average*10)/10.0);

	        cell.appendChild(doc.createTextNode(String.valueOf(average)+"%"));
	        row.appendChild(cell);
	        
	        cell = doc.createElement("cell");
	        cell.appendChild(doc.createTextNode(String.valueOf(procStaticsWithItsystem.get("ITSYS03"))));
	        row.appendChild(cell);
	        
	        cell = doc.createElement("cell");
	        sysCnt = Integer.parseInt(String.valueOf(procStaticsWithItsystem.get("ITSYS03")));
	        sysRowTotalCnt += sysCnt;
	        sysTotalCnt[2] += sysCnt;
	        l5totalcnt = Integer.parseInt(String.valueOf(activityTotalMap.get("03_CNT")));
	        average = (float) ((float) ((float) sysCnt / (float) l5totalcnt)* 100.00);
	        average = (float) (Math.round(average*10)/10.0);

	        cell.appendChild(doc.createTextNode(String.valueOf(average)+"%"));
	        row.appendChild(cell);
	        
	        cell = doc.createElement("cell");
	        cell.appendChild(doc.createTextNode(String.valueOf(procStaticsWithItsystem.get("ITSYS04"))));
	        row.appendChild(cell);
	        
	        cell = doc.createElement("cell");
	        sysCnt = Integer.parseInt(String.valueOf(procStaticsWithItsystem.get("ITSYS04")));
	        sysRowTotalCnt += sysCnt;
	        sysTotalCnt[3] += sysCnt;
	        l5totalcnt = Integer.parseInt(String.valueOf(activityTotalMap.get("04_CNT")));
	        average = (float) ((float) ((float) sysCnt / (float) l5totalcnt)* 100.00);
	        average = (float) (Math.round(average*10)/10.0);

	        cell.appendChild(doc.createTextNode(String.valueOf(average)+"%"));
	        row.appendChild(cell);
	        
	        cell = doc.createElement("cell");
	        cell.appendChild(doc.createTextNode(String.valueOf(procStaticsWithItsystem.get("ITSYS05"))));
	        row.appendChild(cell);
	        
	        cell = doc.createElement("cell");
	        sysCnt = Integer.parseInt(String.valueOf(procStaticsWithItsystem.get("ITSYS05")));
	        sysRowTotalCnt += sysCnt;
	        sysTotalCnt[4] += sysCnt;
	        l5totalcnt = Integer.parseInt(String.valueOf(activityTotalMap.get("05_CNT")));
	        average = (float) ((float) ((float) sysCnt / (float) l5totalcnt)* 100.00);
	        average = (float) (Math.round(average*10)/10.0);

	        cell.appendChild(doc.createTextNode(String.valueOf(average)+"%"));
	        row.appendChild(cell);
	        
	        cell = doc.createElement("cell");
	        cell.appendChild(doc.createTextNode(String.valueOf(procStaticsWithItsystem.get("ITSYS06"))));
	        row.appendChild(cell);
	        
	        cell = doc.createElement("cell");
	        sysCnt = Integer.parseInt(String.valueOf(procStaticsWithItsystem.get("ITSYS06")));
	        sysRowTotalCnt += sysCnt;
	        sysTotalCnt[5] += sysCnt;
	        l5totalcnt = Integer.parseInt(String.valueOf(activityTotalMap.get("06_CNT")));
	        average = (float) ((float) ((float) sysCnt / (float) l5totalcnt)* 100.00);
	        average = (float) (Math.round(average*10)/10.0);

	        cell.appendChild(doc.createTextNode(String.valueOf(average)+"%"));
	        row.appendChild(cell);
	        
	        cell = doc.createElement("cell");
	        cell.appendChild(doc.createTextNode(String.valueOf(procStaticsWithItsystem.get("ITSYS07"))));
	        row.appendChild(cell);
	        
	        cell = doc.createElement("cell");
	        sysCnt = Integer.parseInt(String.valueOf(procStaticsWithItsystem.get("ITSYS07")));
	        sysRowTotalCnt += sysCnt;
	        sysTotalCnt[6] += sysCnt;
	        l5totalcnt = Integer.parseInt(String.valueOf(activityTotalMap.get("07_CNT")));
	        average = (float) ((float) ((float) sysCnt / (float) l5totalcnt)* 100.00);
	        average = (float) (Math.round(average*10)/10.0);
	        cell.appendChild(doc.createTextNode(String.valueOf(average)+"%"));
	        row.appendChild(cell);
	        
	        cell = doc.createElement("cell");
	        cell.appendChild(doc.createTextNode(String.valueOf(procStaticsWithItsystem.get("ITSYS08"))));
	        row.appendChild(cell);
	        
	        cell = doc.createElement("cell");
	        sysCnt = Integer.parseInt(String.valueOf(procStaticsWithItsystem.get("ITSYS08")));
	        sysRowTotalCnt += sysCnt;
	        sysTotalCnt[7] += sysCnt;
	        l5totalcnt = Integer.parseInt(String.valueOf(activityTotalMap.get("08_CNT")));
	        average = (float) ((float) ((float) sysCnt / (float) l5totalcnt)* 100.00);
	        average = (float) (Math.round(average*10)/10.0);
	        cell.appendChild(doc.createTextNode(String.valueOf(average)+"%"));
	        row.appendChild(cell);
	        
	        cell = doc.createElement("cell");
	        cell.appendChild(doc.createTextNode(String.valueOf(procStaticsWithItsystem.get("ITSYS09"))));
	        row.appendChild(cell);
	        
	        cell = doc.createElement("cell");
	        sysCnt = Integer.parseInt(String.valueOf(procStaticsWithItsystem.get("ITSYS09")));
	        sysRowTotalCnt += sysCnt;
	        sysTotalCnt[8] += sysCnt;
	        l5totalcnt = Integer.parseInt(String.valueOf(activityTotalMap.get("09_CNT")));
	        average = (float) ((float) ((float) sysCnt / (float) l5totalcnt)* 100.00);
	        average = (float) (Math.round(average*10)/10.0);
	        cell.appendChild(doc.createTextNode(String.valueOf(average)+"%"));
	        row.appendChild(cell);
	        
	        cell = doc.createElement("cell");
	        cell.appendChild(doc.createTextNode(String.valueOf(procStaticsWithItsystem.get("ITSYS10"))));
	        row.appendChild(cell);
	        
	        cell = doc.createElement("cell");
	        sysCnt = Integer.parseInt(String.valueOf(procStaticsWithItsystem.get("ITSYS10")));
	        sysRowTotalCnt += sysCnt;
	        sysTotalCnt[9] += sysCnt;
	        l5totalcnt = Integer.parseInt(String.valueOf(activityTotalMap.get("10_CNT")));
	        average = (float) ((float) ((float) sysCnt / (float) l5totalcnt)* 100.00);
	        average = (float) (Math.round(average*10)/10.0);
	        cell.appendChild(doc.createTextNode(String.valueOf(average)+"%"));
	        row.appendChild(cell);
	        
	        cell = doc.createElement("cell");
	        cell.appendChild(doc.createTextNode(String.valueOf(procStaticsWithItsystem.get("ITSYS11"))));
	        row.appendChild(cell);
	        
	        cell = doc.createElement("cell");
	        sysCnt = Integer.parseInt(String.valueOf(procStaticsWithItsystem.get("ITSYS11")));
	        sysRowTotalCnt += sysCnt;
	        sysTotalCnt[10] += sysCnt;
	        l5totalcnt = Integer.parseInt(String.valueOf(activityTotalMap.get("11_CNT")));
	        average = (float) ((float) ((float) sysCnt / (float) l5totalcnt)* 100.00);
	        average = (float) (Math.round(average*10)/10.0);
	        cell.appendChild(doc.createTextNode(String.valueOf(average)+"%"));
	        row.appendChild(cell);
	        
	        cell = doc.createElement("cell");
	        cell.appendChild(doc.createTextNode(String.valueOf(procStaticsWithItsystem.get("ITSYS12"))));
	        row.appendChild(cell);
	        
	        cell = doc.createElement("cell");
	        sysCnt = Integer.parseInt(String.valueOf(procStaticsWithItsystem.get("ITSYS12")));
	        sysRowTotalCnt += sysCnt;
	        sysTotalCnt[11] += sysCnt;
	        l5totalcnt = Integer.parseInt(String.valueOf(activityTotalMap.get("12_CNT")));
	        average = (float) ((float) ((float) sysCnt / (float) l5totalcnt)* 100.00);
	        average = (float) (Math.round(average*10)/10.0);
	        cell.appendChild(doc.createTextNode(String.valueOf(average)+"%"));
	        row.appendChild(cell);
	        
	        cell = doc.createElement("cell");
	        cell.appendChild(doc.createTextNode(String.valueOf(sysRowTotalCnt)));
	        row.appendChild(cell);
	        
	        cell = doc.createElement("cell");
	        l5totalcnt = Integer.parseInt(String.valueOf(activityTotalMap.get("totalCnt")));
	        sysTotalCnt[12] += sysRowTotalCnt;
	        average = (float) ((float) ((float) sysRowTotalCnt / (float) l5totalcnt)* 100.00);
	        average = (float) (Math.round(average*10)/10.0);
	        cell.appendChild(doc.createTextNode(String.valueOf(average)+"%"));
	        row.appendChild(cell);
	        
	        sysRowTotalCnt = 0;
        }
        
        row = doc.createElement("row"); 
        rootElement.appendChild(row); 
        row.setAttribute("id", String.valueOf(rowId));
        rowId++;
        
        cell = doc.createElement("cell");
        cell.setAttribute("rowspan", String.valueOf(procStaticsWithItsystemList.size()+1));
        cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");
        cell.appendChild(doc.createTextNode("전산화율 (L5기준)"));
        row.appendChild(cell);
        
    	cell = doc.createElement("cell");
        cell.appendChild(doc.createTextNode("L5 전산화율 Total"));
        row.appendChild(cell);
        
        cell = doc.createElement("cell");
        cell.appendChild(doc.createTextNode(String.valueOf(sysTotalCnt[0])));
        row.appendChild(cell);
        
        cell = doc.createElement("cell");
        l5totalcnt = Integer.parseInt(String.valueOf(activityTotalMap.get("01_CNT")));
        average = (float) ((float) ((float) sysTotalCnt[0] / (float) l5totalcnt)* 100.00);
        average = (float) (Math.round(average*10)/10.0);
        cell.appendChild(doc.createTextNode(String.valueOf(average)+"%"));
        row.appendChild(cell);
        
        cell = doc.createElement("cell");
        cell.appendChild(doc.createTextNode(String.valueOf(sysTotalCnt[1])));
        row.appendChild(cell);
        
        cell = doc.createElement("cell");
        
        l5totalcnt = Integer.parseInt(String.valueOf(activityTotalMap.get("02_CNT")));
        average = (float) ((float) ((float) sysTotalCnt[1] / (float) l5totalcnt)* 100.00);
        average = (float) (Math.round(average*10)/10.0);

        cell.appendChild(doc.createTextNode(String.valueOf(average)+"%"));
        row.appendChild(cell);
        
        cell = doc.createElement("cell");
        cell.appendChild(doc.createTextNode(String.valueOf(sysTotalCnt[2])));
        row.appendChild(cell);
        
        cell = doc.createElement("cell");
        l5totalcnt = Integer.parseInt(String.valueOf(activityTotalMap.get("03_CNT")));
        average = (float) ((float) ((float) sysTotalCnt[2] / (float) l5totalcnt)* 100.00);
        average = (float) (Math.round(average*10)/10.0);

        cell.appendChild(doc.createTextNode(String.valueOf(average)+"%"));
        row.appendChild(cell);
        
        cell = doc.createElement("cell");
        cell.appendChild(doc.createTextNode(String.valueOf(sysTotalCnt[3])));
        row.appendChild(cell);
        
        cell = doc.createElement("cell");
        l5totalcnt = Integer.parseInt(String.valueOf(activityTotalMap.get("04_CNT")));
        average = (float) ((float) ((float) sysTotalCnt[3] / (float) l5totalcnt)* 100.00);
        average = (float) (Math.round(average*10)/10.0);

        cell.appendChild(doc.createTextNode(String.valueOf(average)+"%"));
        row.appendChild(cell);
        
        cell = doc.createElement("cell");
        cell.appendChild(doc.createTextNode(String.valueOf(sysTotalCnt[4])));
        row.appendChild(cell);
        
        cell = doc.createElement("cell");
        l5totalcnt = Integer.parseInt(String.valueOf(activityTotalMap.get("05_CNT")));
        average = (float) ((float) ((float) sysTotalCnt[4] / (float) l5totalcnt)* 100.00);
        average = (float) (Math.round(average*10)/10.0);

        cell.appendChild(doc.createTextNode(String.valueOf(average)+"%"));
        row.appendChild(cell);
        
        cell = doc.createElement("cell");
        cell.appendChild(doc.createTextNode(String.valueOf(sysTotalCnt[5])));
        row.appendChild(cell);
        
        cell = doc.createElement("cell");
        l5totalcnt = Integer.parseInt(String.valueOf(activityTotalMap.get("06_CNT")));
        average = (float) ((float) ((float) sysTotalCnt[5] / (float) l5totalcnt)* 100.00);
        average = (float) (Math.round(average*10)/10.0);

        cell.appendChild(doc.createTextNode(String.valueOf(average)+"%"));
        row.appendChild(cell);
        
        cell = doc.createElement("cell");
        cell.appendChild(doc.createTextNode(String.valueOf(sysTotalCnt[6])));
        row.appendChild(cell);
        
        cell = doc.createElement("cell");
        l5totalcnt = Integer.parseInt(String.valueOf(activityTotalMap.get("07_CNT")));
        average = (float) ((float) ((float) sysTotalCnt[6] / (float) l5totalcnt)* 100.00);
        average = (float) (Math.round(average*10)/10.0);
        cell.appendChild(doc.createTextNode(String.valueOf(average)+"%"));
        row.appendChild(cell);
        
        cell = doc.createElement("cell");
        cell.appendChild(doc.createTextNode(String.valueOf(sysTotalCnt[7])));
        row.appendChild(cell);
        
        cell = doc.createElement("cell");
        l5totalcnt = Integer.parseInt(String.valueOf(activityTotalMap.get("08_CNT")));
        average = (float) ((float) ((float) sysTotalCnt[7] / (float) l5totalcnt)* 100.00);
        average = (float) (Math.round(average*10)/10.0);
        cell.appendChild(doc.createTextNode(String.valueOf(average)+"%"));
        row.appendChild(cell);
        
        cell = doc.createElement("cell");
        cell.appendChild(doc.createTextNode(String.valueOf(sysTotalCnt[8])));
        row.appendChild(cell);
        
        cell = doc.createElement("cell");
        l5totalcnt = Integer.parseInt(String.valueOf(activityTotalMap.get("09_CNT")));
        average = (float) ((float) ((float) sysTotalCnt[8] / (float) l5totalcnt)* 100.00);
        average = (float) (Math.round(average*10)/10.0);
        cell.appendChild(doc.createTextNode(String.valueOf(average)+"%"));
        row.appendChild(cell);
        
        cell = doc.createElement("cell");
        cell.appendChild(doc.createTextNode(String.valueOf(sysTotalCnt[9])));
        row.appendChild(cell);
        
        cell = doc.createElement("cell");
        l5totalcnt = Integer.parseInt(String.valueOf(activityTotalMap.get("10_CNT")));
        average = (float) ((float) ((float) sysTotalCnt[9] / (float) l5totalcnt)* 100.00);
        average = (float) (Math.round(average*10)/10.0);
        cell.appendChild(doc.createTextNode(String.valueOf(average)+"%"));
        row.appendChild(cell);
        
        cell = doc.createElement("cell");
        cell.appendChild(doc.createTextNode(String.valueOf(sysTotalCnt[10])));
        row.appendChild(cell);
        
        cell = doc.createElement("cell");
        l5totalcnt = Integer.parseInt(String.valueOf(activityTotalMap.get("11_CNT")));
        average = (float) ((float) ((float) sysTotalCnt[10] / (float) l5totalcnt)* 100.00);
        average = (float) (Math.round(average*10)/10.0);
        cell.appendChild(doc.createTextNode(String.valueOf(average)+"%"));
        row.appendChild(cell);
        
        cell = doc.createElement("cell");
        cell.appendChild(doc.createTextNode(String.valueOf(sysTotalCnt[11])));
        row.appendChild(cell);
        
        cell = doc.createElement("cell");
        l5totalcnt = Integer.parseInt(String.valueOf(activityTotalMap.get("12_CNT")));
        average = (float) ((float) ((float) sysTotalCnt[11] / (float) l5totalcnt)* 100.00);
        average = (float) (Math.round(average*10)/10.0);
        cell.appendChild(doc.createTextNode(String.valueOf(average)+"%"));
        row.appendChild(cell);
        
        cell = doc.createElement("cell");
        cell.appendChild(doc.createTextNode(String.valueOf(sysTotalCnt[12])));
        row.appendChild(cell);
        
        cell = doc.createElement("cell");
        l5totalcnt = Integer.parseInt(String.valueOf(activityTotalMap.get("totalCnt")));
        average = (float) ((float) ((float) sysTotalCnt[12] / (float) l5totalcnt)* 100.00);
        average = (float) (Math.round(average*10)/10.0);
        cell.appendChild(doc.createTextNode(String.valueOf(average)+"%"));
        row.appendChild(cell);
        
        cnItemsMap.put("rowId",rowId);
		
		return cnItemsMap;
	}
	/**
	 * classCode 별 row title 설정
	 * @param classCode
	 * @return
	 */
	private String setTitleCell(String classLevel, String flag) {
		String result = "";
		if(flag.equals("Y")) {
			if (classLevel.equals("2")) {
				result = "L2";
			} else if (classLevel.equals("3")) {
				result = "L3";
			} else if (classLevel.equals("4")) {
				result = "L4";
			} else if (classLevel.equals("5")){
				result = "L5";
			} else {
				result = "L6";
			}
		}else {
			if (classLevel.equals("2")) {
				result = "L2 Process chain";
			} else if (classLevel.equals("3")) {
				result = "L3 Process Domain";
			} else if (classLevel.equals("4")) {
				result = "L4 Process Total";
			} else if (classLevel.equals("5")){
				result = "L5 Task Total";
			} else {
				result = "L6";
			}
		}
		
		
		return result;
	}
	
	/**
	 * L4 background-color return
	 * @param classCode
	 * @return
	 */
	private String l4RowbackColor(int index) {
		String result = "";
		if (index == 0) {
			result = "background-color:#E0FFFF;";
		} else if (index == 1) {
			result = "background-color:#FFE1FF;";
		} else if (index == 2) {
			result = "background-color:#EEDD82;";
		} else {
			result = "background-color:#8FBC8F;";
		}
		
		return result;
	}
	
	/**
	 * L5 background-color return
	 * @param classCode
	 * @return
	 */
	private String l5RowbackColor(int index) {
		String result = "";
		if (index == 0) {
			result = "background-color:#8DB6CD;";
		} else if (index == 1) {
			result = "background-color:#8FBC8F;";
		} else if (index == 2) {
			result = "background-color:#FFDAB9;";
		} else {
			result = "background-color:#EEDD82;";
		}
		
		return result;
	}
	
	
	
	/**
	 * Rule Set (연관항목:CN00107) Count를 설정 한다
	 * @param doc
	 * @param rootElement
	 * @param row
	 * @param cell
	 * @param rowId
	 * @param level1NameList
	 * @param setMap
	 * @return
	 * @throws ExceptionUtil
	 */
	private Map<String, Integer> setCnItemsRow(Document doc, Element rootElement, Element row, Element cell, int rowId, List level1NameList, Map setMap, String itemTypeCode, String itemFromTo) throws ExceptionUtil {
		
		Map<String, Integer> cnItemsMap = new HashMap<String, Integer>();
		
        try {
			// Title
			row = doc.createElement("row"); 
	        rootElement.appendChild(row); 
	        row.setAttribute("id", String.valueOf(rowId));
	        rowId++;
	        
	        cell = doc.createElement("cell");
	        cell.setAttribute("rowspan", "9");
	        cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");
	        cell.appendChild(doc.createTextNode("연관항목(L1 합계 기준)"));
	        row.appendChild(cell);
	        
	        
	        cell = doc.createElement("cell");
	        if ("CN00107".equals(itemTypeCode)) { 
	        	cell.appendChild(doc.createTextNode("Rule"));
	        }else if("CN00105".equals(itemTypeCode)){ 
	        	cell.appendChild(doc.createTextNode("QMS"));
	        }else if("CN00108".equals(itemTypeCode)){ 
	        	cell.appendChild(doc.createTextNode("PMI"));
	        }else if("CN00104".equals(itemTypeCode)){ 
	        	cell.appendChild(doc.createTextNode("IT System"));
	        }else if("CN01301".equals(itemTypeCode)){ 
	        	cell.appendChild(doc.createTextNode("혁신과제"));
	        }else if("CN00111".equals(itemTypeCode)){ 
	        	cell.appendChild(doc.createTextNode("Term"));
	        }else if("CN00106".equals(itemTypeCode)){ 
	        	cell.appendChild(doc.createTextNode("Form"));
	        }else if("CN00102".equals(itemTypeCode)){ 
	        	cell.appendChild(doc.createTextNode("Role"));
	        }

	        //cell.setAttribute("colspan", "2");
	        row.appendChild(cell);
	        
	        
			for (int i = 0; i < level1NameList.size(); i++) {
	        	Map level1NameMap = (Map) level1NameList.get(i);
	        	String l1ItemID = String.valueOf(level1NameMap.get("ItemID"));
	        	
	        	// Mapping된 L4
	        	setMap.put("ItemTypeCode", itemTypeCode);
	        	setMap.put("L1ItemID", l1ItemID);
	        	List cnItemList = commonService.selectList("analysis_SQL.getCnItemList", setMap);
	        	String cnItemCnt = String.valueOf(cnItemList.size());
	        	
	        	// Mapping된 Total L4
	        	List toItemList = new ArrayList();
		        try {
		        	if(itemFromTo.equals("fromItemID")){
		        		toItemList = commonService.selectList("analysis_SQL.getFromItemList", setMap);
		        	}else{ // toItemID
		        		toItemList = commonService.selectList("analysis_SQL.getToItemList", setMap);
		        	}
		        } catch(Exception e) {
		        	throw new ExceptionUtil(e.toString());
		        }
	        	String toItemCnt = String.valueOf(toItemList.size());
	        	

	        	// Mapping된 L5
	        	setMap.put("ItemTypeCode", itemTypeCode);
	        	setMap.put("L1ItemID", l1ItemID);
	        	List cnItemListL5 = commonService.selectList("analysis_SQL.getCnL5ItemList", setMap);
	        	String cnItemCntL5 = String.valueOf(cnItemListL5.size());
	        	
	        	// Mapping된 Total L5
	        	List toItemListL5 = new ArrayList();
		        try {
		        	if(itemFromTo.equals("fromItemID")){
		        		toItemListL5 = commonService.selectList("analysis_SQL.getFromL5ItemList", setMap);
		        	}else{ // toItemID
		        		toItemListL5 = commonService.selectList("analysis_SQL.getToL5ItemList", setMap);
		        	}
		        } catch(Exception e) {
		        	throw new ExceptionUtil(e.toString());
		        }
	        	String toItemCntL5 = String.valueOf(toItemListL5.size());
	        	
	        	
	        	cell = doc.createElement("cell"); 
		        cell.appendChild(doc.createTextNode(cnItemCnt + "/" + toItemCnt));
		        row.appendChild(cell);
		        cell = doc.createElement("cell");
		        cell.appendChild(doc.createTextNode(cnItemCntL5 + "/" + toItemCntL5));
		        row.appendChild(cell);
		        

		        
	        }
	        
	        
	        // Total값 설정
			// Mapping된 L4
	    	setMap.put("ItemTypeCode", itemTypeCode);
	    	setMap.remove("L1ItemID");
	        List cnItemList = commonService.selectList("analysis_SQL.getCnItemList", setMap);
	        
	    	String cnItemCnt = String.valueOf(cnItemList.size());
	    	
	    	// Mapping된 Total L4
	    	List toItemList = new ArrayList();
	    	if(itemFromTo.equals("fromItemID")){
	    		toItemList = commonService.selectList("analysis_SQL.getFromItemList", setMap);
	    	}else{
	    		toItemList = commonService.selectList("analysis_SQL.getToItemList", setMap);
	    	}
	        
	    	String toItemCnt = String.valueOf(toItemList.size());

	        // Total값 설정
			// Mapping된 L5
	    	setMap.put("ItemTypeCode", itemTypeCode);
	    	setMap.remove("L1ItemID");
	        List cnItemListL5 = commonService.selectList("analysis_SQL.getCnL5ItemList", setMap);
	        
	    	String cnItemCntL5 = String.valueOf(cnItemListL5.size());
	    	
	    	// Mapping된 Total L5
	    	List toItemListL5 = new ArrayList();
	    	if(itemFromTo.equals("fromItemID")){
	    		toItemListL5 = commonService.selectList("analysis_SQL.getFromL5ItemList", setMap);
	    	}else{
	    		toItemListL5 = commonService.selectList("analysis_SQL.getToL5ItemList", setMap);
	    	}
	        
	    	String toItemCntL5 = String.valueOf(toItemListL5.size());
	    	
	        cell = doc.createElement("cell");
	        cell.appendChild(doc.createTextNode(cnItemCnt + "/" + toItemCnt));
	        cell.setAttribute("style", "font-weight:bold;color:#0D65B7;text-decoration:underline;");
	        row.appendChild(cell);
	        cell = doc.createElement("cell");
	        cell.setAttribute("style", "font-weight:bold;color:#0D65B7;text-decoration:underline;");
	        cell.appendChild(doc.createTextNode(cnItemCntL5 + "/" + toItemCntL5));
	        row.appendChild(cell);
	        
	        cnItemsMap.put("rowId", rowId);
		} catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
		return cnItemsMap;
	}
	
	private String getRatio(BigDecimal levelTotalNum, BigDecimal subTotalNum) {
		if (levelTotalNum.compareTo(BigDecimal.ZERO) == 0 || subTotalNum.compareTo(BigDecimal.ZERO) == 0) {
			return "0%";
		}
		BigDecimal resultRatio = (subTotalNum.divide(levelTotalNum, MathContext.DECIMAL32)).multiply(new BigDecimal(100)).setScale(0, RoundingMode.HALF_UP);
		return resultRatio.toString() + "%";
	}
	
	/**
	 * Process 통계에 표시할 내용을 xml 파일로 생성
	 * 
	 * @param filepath
	 * @param prcCountList
	 * @param level1NameList
	 * @param xmlFilName
	 * @param setMap
	 * @throws ExceptionUtil
	 */
	private void zHkfc_SetProcessStatistics(String filepath, List level1NameList, String xmlFilName, Map setMap,	HttpServletRequest request) throws ExceptionUtil {

		// 통계 수치 resultList를 xml에 값 셋팅해서 grid 생성
		// 통계 리스트 표시 할 xml 파일 생성
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
		try {
			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

			// 루트 엘리먼트
			Document doc = docBuilder.newDocument();
			Element rootElement = doc.createElement("rows");
			doc.appendChild(rootElement);

			int rowId = 1;
			int rowTotal = 0;
			String classCode = "CL01002";
			String classLevel = "2";

			Map<String, Integer> level4TotalMap = new HashMap<String, Integer>();
			Map<String, Integer> activityTotalMap = new HashMap<String, Integer>();
			Map<String, Integer> level6TotalMap = new HashMap<String, Integer>();
			int levell4TtlCnt = 0;
			int activityTtlCnt = 0;
			int levell6TtlCnt = 0;

			// row 엘리먼트
			Element row = doc.createElement("row");
			rootElement.appendChild(row);
			row.setAttribute("id", String.valueOf(rowId));
			rowId++;

			Element cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(setTitleCell(classLevel, "Y")));
			cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");
			row.appendChild(cell);
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(setTitleCell(classLevel, "N")));
			row.appendChild(cell);

			Map conditionMap = new HashMap();

			List newPrcCntList = new ArrayList();
			Map newPrcCntMap = new HashMap();

			for (int i = 0; i < level1NameList.size(); i++) {
				Map map = (Map) level1NameList.get(i);
				conditionMap.put(String.valueOf(map.get("ItemID")), String.valueOf(map.get("label")));
			}
			setMap.put("ItemTypeCode", "OJ00001");
			List itemClassCodeList = commonService.selectList("analysis_SQL.getItemClassCodeList", setMap);

			int MaxLevel = Integer.parseInt(commonService.selectString("analysis_SQL.getItemClassMaxLevel", setMap));

			Map prcCountMap = new HashMap();
			List prcCountList = new ArrayList();
			for (int icidx = 0; icidx < itemClassCodeList.size(); icidx++) {
				prcCountMap = new HashMap();
				Map tempMap = (Map) itemClassCodeList.get(icidx);
				String itemClassCode = tempMap.get("ItemClassCode").toString();
				int Level = Integer.parseInt(tempMap.get("Level").toString());
				// get L2 List

				setMap.put("ItemClassCode", itemClassCode);

				if ("CL01005".equals(itemClassCode))
					setMap.put("isDim", "Y");
				else if (!"CL01006".equals(itemClassCode))
					setMap.put("isDim", "N");

				if (icidx != itemClassCodeList.size() - 1) {
					prcCountList = commonService.selectList("analysis_SQL.getPrcCountList", setMap);
				} else {
					prcCountList = commonService.selectList("analysis_SQL.getPrcCountListL5", setMap);
				}

				for (int i = 0; i < prcCountList.size(); i++) {
					Map map = (Map) prcCountList.get(i);
					prcCountMap.put(String.valueOf(map.get("L1ItemID")), String.valueOf(map.get("CNT")));
				}
				for (int i = 0; i < level1NameList.size(); i++) {
					newPrcCntMap = new HashMap();
					Map map1 = (Map) level1NameList.get(i);
					newPrcCntMap.put("L1ItemID", String.valueOf(map1.get("ItemID")));
					newPrcCntMap.put("ItemClassCode", itemClassCode);
					newPrcCntMap.put("ItemClassLevel", Level);
					if (prcCountMap.containsKey(String.valueOf(map1.get("ItemID")))) {
						newPrcCntMap.put("CNT", prcCountMap.get(String.valueOf(map1.get("ItemID"))));
					} else {
						newPrcCntMap.put("CNT", "0");
					}
					newPrcCntList.add(newPrcCntMap);
				}

			}

			/* Activity 이외의 item count row 생성 */
			for (int i = 0; i < newPrcCntList.size(); i++) {
				prcCountMap = (Map) newPrcCntList.get(i);
				String level1ItemId = StringUtil.checkNull(prcCountMap.get("L1ItemID"));
				if (conditionMap.containsKey(level1ItemId)) {

					int level = Integer.parseInt(prcCountMap.get("ItemClassLevel").toString());
					if (!classCode.equals(prcCountMap.get("ItemClassCode"))) {
						classCode = String.valueOf(prcCountMap.get("ItemClassCode"));
						// if (!classCode.equals("CL01006")) { //TODO:L4의 Total만표시 할때의 조건
						if (level < MaxLevel - 1) {
							// Total cell 값 설정 후, 새로운 row 추가
							cell = doc.createElement("cell");
							cell.appendChild(doc.createTextNode(String.valueOf(rowTotal)));
							cell.setAttribute("style", "font-weight:bold;");
							cell.setAttribute("colspan", "2"); // cnt1
							row.appendChild(cell);
							cell = doc.createElement("cell");
							cell.appendChild(doc.createTextNode(""));
							row.appendChild(cell);
							rowTotal = 0; // Total 값 초기화

							row = doc.createElement("row");
							rootElement.appendChild(row);
							row.setAttribute("id", String.valueOf(rowId));
							rowId++;

							cell = doc.createElement("cell");
							cell.appendChild(doc.createTextNode(setTitleCell(prcCountMap.get("ItemClassLevel").toString(), "Y")));
							cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");
							row.appendChild(cell);
							cell = doc.createElement("cell");
							cell.appendChild(doc.createTextNode(setTitleCell(prcCountMap.get("ItemClassLevel").toString(), "N")));
							row.appendChild(cell);
						}
					}

					if (level == MaxLevel) {
						activityTotalMap.put(prcCountMap.get("L1ItemID").toString(),
								Integer.parseInt(prcCountMap.get("CNT").toString()));
						activityTtlCnt = activityTtlCnt + Integer.parseInt(prcCountMap.get("CNT").toString());
					} else if (level == MaxLevel - 1) { // TODO:L4의 Total만표시 할때 : 이 if문의 comment out
						level4TotalMap.put(prcCountMap.get("L1ItemID").toString(),
								Integer.parseInt(prcCountMap.get("CNT").toString()));
						levell4TtlCnt = levell4TtlCnt + Integer.parseInt(prcCountMap.get("CNT").toString());
					} else {
						cell = doc.createElement("cell");
						cell.appendChild(doc.createTextNode(String.valueOf(prcCountMap.get("CNT"))));
						cell.setAttribute("colspan", "2"); // cnt1
						row.appendChild(cell);
						cell = doc.createElement("cell");
						cell.appendChild(doc.createTextNode(""));
						row.appendChild(cell);
						rowTotal = rowTotal + Integer.parseInt(String.valueOf(prcCountMap.get("CNT")));
					}
				}
			}

			activityTotalMap.put("TTL", activityTtlCnt);
			level4TotalMap.put("TTL", levell4TtlCnt);

			// Activity 이외의 item 마지막 row의 Total cell 값 설정
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(String.valueOf(rowTotal)));
			cell.setAttribute("style", "font-weight:bold;color:#0D65B7;text-decoration:underline;");
			cell.setAttribute("colspan", "2"); // cnt1
			row.appendChild(cell);
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(""));
			row.appendChild(cell);
			rowTotal = 0; // Total 값 초기화

			/* L4 count row 생성 */ // TODO:L4의 Total만표시 할때 : comment out
			// Map<String, Integer> level4CntMap = setLevel4Rows(doc, rootElement, row,
			// cell, rowId, level1NameList, setMap, level4TotalMap);
			// rowId = level4CntMap.get("rowId");

			/* Activity count row 생성 */
			// Map<String, Integer> activityCntMap = setActivityRows(doc, rootElement, row,
			// cell, rowId, level1NameList, setMap, activityTotalMap);
			// rowId = activityCntMap.get("rowId");
			Map getMap = new HashMap();
			
			System.out.println(itemClassCodeList.size());
			for (int i = itemClassCodeList.size() - 2; i < itemClassCodeList.size(); i++) {
			
				Map tempMap = (Map) itemClassCodeList.get(i);
				if(tempMap.get("ItemClassCode").equals("CL01005")) {
					getMap.put("ItemClassCode", tempMap.get("ItemClassCode"));
					getMap.put("ItemClassLevel", tempMap.get("Level"));
					getMap.put("AttrTypeCode", "ZAT0005");
					System.out.println((i == itemClassCodeList.size() - 2 ? "level4TotalMap" : "activityTotalMap"));
					System.out.println(activityTotalMap.toString());
					Map<String, Integer> CntMap = setL4Rows(doc, rootElement, row, cell, rowId, level1NameList,
							getMap, setMap, (i == itemClassCodeList.size() - 2 ? level4TotalMap : activityTotalMap),
							MaxLevel);
					rowId = CntMap.get("rowId");
				}else if(tempMap.get("ItemClassCode").equals("CL01006")) {
					getMap.put("ItemClassCode", tempMap.get("ItemClassCode"));
					getMap.put("ItemClassLevel", tempMap.get("Level"));
					System.out.println((i == itemClassCodeList.size() - 2 ? "level4TotalMap" : "activityTotalMap"));
					System.out.println(activityTotalMap.toString());
					Map<String, Integer> CntMap = setL5Rows(doc, rootElement, row, cell, rowId, level1NameList,
							getMap, setMap, (i == itemClassCodeList.size() - 2 ? level4TotalMap : activityTotalMap),
							MaxLevel);
					rowId = CntMap.get("rowId");
				}
			}
			

			/* role row 생성 
        	Map<String, Integer> roleCntMap = setCnItemsRow(doc, rootElement, row, cell, rowId, level1NameList, setMap, "CN00201", "fromItemID");
        	rowId = roleCntMap.get("rowId");

			// QMS row 생성 
        	Map<String, Integer> qmsCntMap = setCnItemsRow(doc, rootElement, row, cell, rowId, level1NameList, setMap, "CN00105", "toItemID");
        	rowId = qmsCntMap.get("rowId");
        	
         	// SOP row 생성 
            Map<String, Integer> pmiCntMap = setCnItemsRow(doc, rootElement, row, cell, rowId, level1NameList, setMap, "CN00108", "toItemID");
            rowId = pmiCntMap.get("rowId");
            
			// Rule set row 생성 
            Map<String, Integer> ruleSetCntMap = setCnItemsRow(doc, rootElement, row, cell, rowId, level1NameList, setMap, "CN00107", "toItemID");
            rowId = ruleSetCntMap.get("rowId");

       		// IT System row 생성 
            Map<String, Integer> itsystemCntMap = setCnItemsRow(doc, rootElement, row, cell, rowId, level1NameList, setMap, "CN00104", "toItemID");
            rowId = itsystemCntMap.get("rowId");

        	// PI row 생성  
        	Map<String, Integer> piCntMap = setCnItemsRow(doc, rootElement, row, cell, rowId, level1NameList, setMap, "CN01301", "fromItemID");
        	rowId = piCntMap.get("rowId");
        
        	// Term row 생성 
    		Map<String, Integer> termCntMap = setCnItemsRow(doc, rootElement, row, cell, rowId, level1NameList, setMap, "CN00111", "toItemID");
    		rowId = termCntMap.get("rowId");
    	
    		// Form row 생성 
    		Map<String, Integer> formCntMap = setCnItemsRow(doc, rootElement, row, cell, rowId, level1NameList, setMap, "CN00106", "toItemID");
    		rowId = formCntMap.get("rowId");
    		
    		// 첨부파일 row 생성 
            Map<String, Integer> fileCntMap = setItemFileRow(doc, rootElement, row, cell, rowId, level1NameList, setMap, request);
            rowId = fileCntMap.get("rowId");
            */ 
			
			// XML 파일로 쓰기
			TransformerFactory transformerFactory = TransformerFactory.newInstance();
			Transformer transformer = transformerFactory.newTransformer();
			transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");
			DOMSource source = new DOMSource(doc);
			StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + xmlFilName)));
			transformer.transform(source, result);
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}
	}
	
	private Map<String, Integer> setL4Rows(Document doc, Element rootElement, Element row, Element cell,
			int rowId, List level1NameList, Map getMap, Map setMap, Map<String, Integer> activityColTtlMap,
			int MaxLevel) throws ExceptionUtil {
		Map<String, Integer> activityTotalMap = new HashMap<String, Integer>();
		int rowTotal = 0;

		setMap.put("AttrTypeCode", getMap.get("AttrTypeCode"));
		List activityLovCodeList = null;
		try {
			activityLovCodeList = commonService.selectList("analysis_SQL.getLovCodeList", setMap);
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}
		BigDecimal Ttl = new BigDecimal(StringUtil.checkNull(activityColTtlMap.get("TTL")));
		String itemClassLevel = getMap.get("ItemClassLevel").toString();

		// Activity Total
		row = doc.createElement("row");
		rootElement.appendChild(row);
		row.setAttribute("id", String.valueOf(rowId));
		rowId++;
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode(setTitleCell(itemClassLevel, "Y")));
		cell.setAttribute("rowspan", String.valueOf(activityLovCodeList.size() + 1)); // col merge
		cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");					
		row.appendChild(cell);
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode("L4 Process"));
		row.appendChild(cell);

		for (int i = 0; i < level1NameList.size(); i++) {
			Map map = (Map) level1NameList.get(i);
			String l1ItemId = String.valueOf(map.get("ItemID"));
			// int totalCnt = activityTotalMap.get(l1ItemId);
			int totalCnt = Integer.parseInt(StringUtil.checkNull(activityColTtlMap.get(l1ItemId), "0"));
			cell = doc.createElement("cell");
			cell.setAttribute("style", "background-color:#f2f2f2;");
			cell.appendChild(doc.createTextNode(String.valueOf(totalCnt)));
			cell.setAttribute("colspan", "2"); // cnt1
			row.appendChild(cell);
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(""));
			row.appendChild(cell);

			rowTotal = rowTotal + Integer.parseInt(String.valueOf(totalCnt));
		}

		// Total값 설정
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode(String.valueOf(rowTotal)));
		cell.setAttribute("colspan", "2"); // cnt1
		cell.setAttribute("style",
				"font-weight:bold;color:#0D65B7;text-decoration:underline;background-color:#f2f2f2;");
		row.appendChild(cell);
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode(""));
		row.appendChild(cell);
		rowTotal = 0; // Total 값 초기화
		
		if (activityLovCodeList != null) {
			for (int index = 0; index < activityLovCodeList.size(); index++) {
				Map map = (Map) activityLovCodeList.get(index);

				String lovValue = (String) map.get("Value");
				String lovCode = (String) map.get("LovCode");
				if (index == 0) {
					// 첫번째 activity
					row = doc.createElement("row");
					rootElement.appendChild(row);
					row.setAttribute("id", String.valueOf(rowId));
					rowId++;
					cell = doc.createElement("cell");
					cell.appendChild(doc.createTextNode(setTitleCell(itemClassLevel, "Y")));
					cell.setAttribute("rowspan", String.valueOf(activityLovCodeList.size() + 1)); // col merge
					cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");					
					row.appendChild(cell);
				} else {
					row = doc.createElement("row");
					rootElement.appendChild(row);
					row.setAttribute("id", String.valueOf(rowId));
					rowId++;
					cell = doc.createElement("cell");
					cell.appendChild(doc.createTextNode(""));
					row.appendChild(cell);
				}

				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(lovValue)); // title 명
				String backColor = "";

				if (Integer.parseInt(itemClassLevel) == MaxLevel - 1)
					backColor = l4RowbackColor(index);
				else
					backColor = l5RowbackColor(index);

				cell.setAttribute("style", "font-weight:bold;" + backColor);
				row.appendChild(cell);
				

				// 해당 activity 건수 취득
				setMap.put("LovCode", lovCode);
				setMap.put("AttrTypeCode", getMap.get("AttrTypeCode"));
				setMap.put("ItemClassCode", getMap.get("ItemClassCode"));
				List activityCntList = null;
				try {
					if (Integer.parseInt(itemClassLevel) == MaxLevel - 1)
						activityCntList = commonService.selectList("analysis_SQL.getLovCountList", setMap);
					else
						activityCntList = commonService.selectList("analysis_SQL.getLovCountListL5", setMap);

				} catch (Exception e) {
					throw new ExceptionUtil(e.toString());
				}
				if (activityCntList.size() == 0) {
					for (int i = 0; i < level1NameList.size(); i++) {
						cell = doc.createElement("cell");
						//cell.setAttribute("style", backColor);
						cell.appendChild(doc.createTextNode("0"));
						row.appendChild(cell);
						cell = doc.createElement("cell");
						//cell.setAttribute("style", backColor);
						cell.appendChild(doc.createTextNode("0%"));
						row.appendChild(cell);
					}
				} else {
					Map activityCntMap = new HashMap();
					for (int i = 0; i < activityCntList.size(); i++) {
						Map cntMap = (Map) activityCntList.get(i);
						activityCntMap.put(String.valueOf(cntMap.get("L1ItemID")), String.valueOf(cntMap.get("CNT")));
					}

					for (int i = 0; i < level1NameList.size(); i++) {
						Map level1NameMap = (Map) level1NameList.get(i);
						String l1ItemID = String.valueOf(level1NameMap.get("ItemID"));

						BigDecimal colTotal = new BigDecimal(
								StringUtil.checkNull(activityColTtlMap.get(l1ItemID), "0")); // 해당 행,Level,Lov의 Total
						BigDecimal nowCnt = new BigDecimal(StringUtil.checkNull(activityCntMap.get(l1ItemID), "0"));

						cell = doc.createElement("cell");
						//cell.setAttribute("style", backColor);
						cell.appendChild(doc.createTextNode(StringUtil.checkNull(activityCntMap.get(l1ItemID), "0")));
						row.appendChild(cell);
						cell = doc.createElement("cell");
						//cell.setAttribute("style", backColor);
						cell.appendChild(doc.createTextNode(getRatio(colTotal, nowCnt))); // 비율 계산
						row.appendChild(cell);
						rowTotal = rowTotal + Integer.parseInt(StringUtil.checkNull(activityCntMap.get(l1ItemID), "0"));

						if (activityTotalMap.containsKey(l1ItemID)) {
							int total = activityTotalMap.get(l1ItemID);
							activityTotalMap.remove(l1ItemID);
							activityTotalMap.put(l1ItemID,
									total + Integer.parseInt(StringUtil.checkNull(activityCntMap.get(l1ItemID), "0")));
						} else {
							activityTotalMap.put(l1ItemID,
									Integer.parseInt(StringUtil.checkNull(activityCntMap.get(l1ItemID), "0")));
						}
					}
				}

				// Total값 설정
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(String.valueOf(rowTotal)));
				cell.setAttribute("style", "font-weight:bold;" + backColor);
				row.appendChild(cell);

				BigDecimal nowCnt = new BigDecimal(String.valueOf(rowTotal));
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(getRatio(Ttl, nowCnt)));
				cell.setAttribute("style", "font-weight:bold;" + backColor);
				row.appendChild(cell);
				rowTotal = 0; // Total 값 초기화
			}
		}

		activityTotalMap.put("rowId", rowId);
		return activityTotalMap;
	}
	
	private Map<String, Integer> setL5Rows(Document doc, Element rootElement, Element row, Element cell,
			int rowId, List level1NameList, Map getMap, Map setMap, Map<String, Integer> activityColTtlMap,
			int MaxLevel) throws ExceptionUtil {
		Map<String, Integer> activityTotalMap = new HashMap<String, Integer>();
		int rowTotal = 0;

		Map L5map = new HashMap();
		String L5titles [] = {"신규","삭제(현업)","삭제(폐지)"};
		BigDecimal Ttl = new BigDecimal(StringUtil.checkNull(activityColTtlMap.get("TTL")));
		String itemClassLevel = getMap.get("ItemClassLevel").toString();
		
		// Activity Total
		row = doc.createElement("row");
		rootElement.appendChild(row);
		row.setAttribute("id", String.valueOf(rowId));
		rowId++;
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode(setTitleCell(itemClassLevel, "Y")));
		cell.setAttribute("rowspan", String.valueOf(L5titles.length + 1)); // col merge
		cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");
		row.appendChild(cell);
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode("L5 Task"));
		row.appendChild(cell);

		for (int i = 0; i < level1NameList.size(); i++) {
			Map map = (Map) level1NameList.get(i);
			String l1ItemId = String.valueOf(map.get("ItemID"));
			// int totalCnt = activityTotalMap.get(l1ItemId);
			int totalCnt = Integer.parseInt(StringUtil.checkNull(activityColTtlMap.get(l1ItemId), "0"));
			cell = doc.createElement("cell");
			cell.setAttribute("style", "background-color:#f2f2f2;");
			cell.appendChild(doc.createTextNode(String.valueOf(totalCnt)));
			cell.setAttribute("colspan", "2"); // cnt1
			row.appendChild(cell);
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(""));
			row.appendChild(cell);

			rowTotal = rowTotal + Integer.parseInt(String.valueOf(totalCnt));
		}

		// Total값 설정
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode(String.valueOf(rowTotal)));
		cell.setAttribute("colspan", "2"); // cnt1
		cell.setAttribute("style",
				"font-weight:bold;color:#0D65B7;text-decoration:underline;background-color:#f2f2f2;");
		row.appendChild(cell);
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode(""));
		row.appendChild(cell);
		rowTotal = 0; // Total 값 초기화
		
		for (int index = 0; index < L5titles.length; index++) {
			//Map map = (Map) activityLovCodeList.get(index);

			String L5title = L5titles[index];
			
			if (index == 0) {
				// 첫번째 activity
				row = doc.createElement("row");
				rootElement.appendChild(row);
				row.setAttribute("id", String.valueOf(rowId));
				rowId++;
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(setTitleCell(itemClassLevel, "Y")));
				cell.setAttribute("rowspan", String.valueOf(L5titles.length + 1)); // col merge
				cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");
				row.appendChild(cell);
			} else {
				row = doc.createElement("row");
				rootElement.appendChild(row);
				row.setAttribute("id", String.valueOf(rowId));
				rowId++;
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(""));
				row.appendChild(cell);
			}

			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(L5title)); // title 명
			String backColor = "";
			backColor = l5RowbackColor(index);

			cell.setAttribute("style", "font-weight:bold;" + backColor);
			row.appendChild(cell);
			
			
			// 해당 activity 건수 취득
			setMap = new HashMap();
			if(L5title.equals("신규")) {
				setMap.put("deleted", 0);
				setMap.put("status", "'NEW1','NEW2'");
			}else if(L5title.equals("삭제(현업)")) {
				setMap.put("deleted", 1);
				setMap.put("status", "'DEL1','DEL2','MOD1','MOD2','NEW1','NEW2'");				
			}else {
				setMap.put("deleted", 1);
				setMap.put("status", "'REL'");				
			}
			
			List L5CntList = null;
			try {
				L5CntList = commonService.selectList("custom_SQL.zHkfc_getItemL5Count", setMap);
			} catch (Exception e) {
				throw new ExceptionUtil(e.toString());
			}
			if (L5CntList.size() == 0) {
				for (int i = 0; i < level1NameList.size(); i++) {
					cell = doc.createElement("cell");
					//cell.setAttribute("style", backColor);
					cell.appendChild(doc.createTextNode("0"));
					row.appendChild(cell);
					cell = doc.createElement("cell");
					//cell.setAttribute("style", backColor);
					cell.appendChild(doc.createTextNode("0%"));
					row.appendChild(cell);
				}
			} else {
				Map activityCntMap = new HashMap();
				for (int i = 0; i < L5CntList.size(); i++) {
					Map cntMap = (Map) L5CntList.get(i);
					activityCntMap.put(String.valueOf(cntMap.get("L1ItemID")), String.valueOf(cntMap.get("CNT")));
				}

				for (int i = 0; i < level1NameList.size(); i++) {
					Map level1NameMap = (Map) level1NameList.get(i);
					String l1ItemID = String.valueOf(level1NameMap.get("ItemID"));

					BigDecimal colTotal = new BigDecimal(
							StringUtil.checkNull(activityColTtlMap.get(l1ItemID), "0")); // 해당 행,Level,Lov의 Total
					BigDecimal nowCnt = new BigDecimal(StringUtil.checkNull(activityCntMap.get(l1ItemID), "0"));

					cell = doc.createElement("cell");
					//cell.setAttribute("style", backColor);
					cell.appendChild(doc.createTextNode(StringUtil.checkNull(activityCntMap.get(l1ItemID), "0")));
					row.appendChild(cell);
					cell = doc.createElement("cell");
					//cell.setAttribute("style", backColor);
					cell.appendChild(doc.createTextNode(getRatio(colTotal, nowCnt))); // 비율 계산
					row.appendChild(cell);
					rowTotal = rowTotal + Integer.parseInt(StringUtil.checkNull(activityCntMap.get(l1ItemID), "0"));

					if (activityTotalMap.containsKey(l1ItemID)) {
						int total = activityTotalMap.get(l1ItemID);
						activityTotalMap.remove(l1ItemID);
						activityTotalMap.put(l1ItemID,
								total + Integer.parseInt(StringUtil.checkNull(activityCntMap.get(l1ItemID), "0")));
					} else {
						activityTotalMap.put(l1ItemID,
								Integer.parseInt(StringUtil.checkNull(activityCntMap.get(l1ItemID), "0")));
					}
				}
			}

			// Total값 설정
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(String.valueOf(rowTotal)));
			cell.setAttribute("style", "font-weight:bold;" + backColor);
			row.appendChild(cell);

			BigDecimal nowCnt = new BigDecimal(String.valueOf(rowTotal));
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(getRatio(Ttl, nowCnt)));
			cell.setAttribute("style", "font-weight:bold;" + backColor);
			row.appendChild(cell);
			rowTotal = 0; // Total 값 초기화
		}

		

		activityTotalMap.put("rowId", rowId);
		return activityTotalMap;
	}
	
	/**
	 * 아이템 파일  Count를 설정 한다
	 * @param doc
	 * @param rootElement
	 * @param row
	 * @param cell
	 * @param rowId
	 * @param level1NameList
	 * @param setMap
	 * @return
	 * @throws ExceptionUtil
	 */
	private Map<String, Integer> setItemFileRow(Document doc, Element rootElement
								, Element row, Element cell, int rowId, List level1NameList
								, Map setMap, HttpServletRequest request) throws ExceptionUtil {
		
		Map<String, Integer> cnItemsMap = new HashMap<String, Integer>();
		try {
			// Title
			row = doc.createElement("row"); 
	        rootElement.appendChild(row); 
	        row.setAttribute("id", String.valueOf(rowId));
	        rowId++;
	        cell = doc.createElement("cell");
	        cell.appendChild(doc.createTextNode(StringUtil.checkNull(getLabel(request, commonService).get("LN00111"))));
	        cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");
	        row.appendChild(cell);

	        cell = doc.createElement("cell");
	        cell.appendChild(doc.createTextNode(""));
	        row.appendChild(cell);

	        
			for (int i = 0; i < level1NameList.size(); i++) {
	        	Map level1NameMap = (Map) level1NameList.get(i);
	        	String l1ItemID = String.valueOf(level1NameMap.get("ItemID"));
	        	
	        	// 첨부 파일이 하나 이상인 L4개수
	        	setMap.put("L1ItemID", l1ItemID);
	        	List l4FileList = commonService.selectList("analysis_SQL.getL4FileList", setMap);
	        	String l4FileCnt = String.valueOf(l4FileList.size());
	        	
	        	// 첨부파일 건수 Total
	        	List ttlL4FileList = commonService.selectList("custom_SQL.zHkfc_getTtlL4FileList", setMap);
	        	String ttlL4FileCnt = String.valueOf(ttlL4FileList.size());
	        	
	        	cell = doc.createElement("cell"); 
		        cell.appendChild(doc.createTextNode(l4FileCnt + "(" + ttlL4FileCnt + ")"));
		        cell.setAttribute("colspan", "2");
		        row.appendChild(cell);
		        cell = doc.createElement("cell");
		        cell.appendChild(doc.createTextNode(""));
		        row.appendChild(cell);
		        
	        }
	        
	        // Total값 설정
			// 첨부 파일이 하나 이상인 L4개수
	    	setMap.remove("L1ItemID");
	    	List l4FileList = commonService.selectList("analysis_SQL.getL4FileList", setMap);
	    	String l4FileCnt = String.valueOf(l4FileList.size());
	    	
	    	// 첨부파일 건수 Total
	    	List ttlL4FileList = commonService.selectList("custom_SQL.zHkfc_getTtlL4FileList", setMap);
	    	String ttlL4FileCnt = String.valueOf(ttlL4FileList.size());
	    	
	        cell = doc.createElement("cell");
	        cell.appendChild(doc.createTextNode(l4FileCnt + "(" + ttlL4FileCnt + ")"));
	        cell.setAttribute("colspan", "2"); // cnt1
	        cell.setAttribute("style", "font-weight:bold;color:#0D65B7;text-decoration:underline;");
	        row.appendChild(cell);
	        cell = doc.createElement("cell");
	        cell.appendChild(doc.createTextNode(""));
	        row.appendChild(cell);
	        
	        cnItemsMap.put("rowId", rowId);
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
		return cnItemsMap;
	}
	
	@RequestMapping(value="/zhkfc_GRProcessStatistics.do")
	public String zhkfc_GRProcessStatistics(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map setMap = new HashMap();
		
		String selYear = StringUtil.checkNull(commandMap.get("selYear"),"");
		List yearList = new ArrayList();
		
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy");
		long date = System.currentTimeMillis();
	    int Year = Integer.parseInt(formatter.format(date));
	    
	    for(int i = -2; i<3; i++) {
	    	yearList.add(Year + i);
	    }
	    
	    if(!selYear.equals("")) {
	    	Year = Integer.parseInt(selYear);
	    }else {
	    	selYear = Integer.toString(Year);
	    }
	    setMap.put("Year",Year);
		List GRProcessStatisticsList = commonService.selectList("custom_SQL.zhkfc_getGRProcessStatisticsList", setMap);
		JSONArray GRProcessStatisticsListData = new JSONArray(GRProcessStatisticsList);
		model.put("GRProcessStatisticsList", GRProcessStatisticsListData);
		model.put("totalCnt", GRProcessStatisticsList.size());
		model.put("yearList", yearList);
		model.put("selYear", selYear);
		
		model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
		return nextUrl("/custom/hyundai/hkfc/report/zhkfc_GRProcessStatistics");
	}

	@RequestMapping(value="/zhkfc_GRVisitLogStatistics.do")
	public String zhkfc_GRVisitLogStatistics(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map setMap = new HashMap();
	
	
	Calendar calendar = Calendar.getInstance();
	calendar.setTime(new Date());

    DateFormat df = new SimpleDateFormat("yyyy-MM-dd");

	String selStartDate = StringUtil.checkNull(commandMap.get("startDate"), "");
	String selEndDate = StringUtil.checkNull(commandMap.get("endDate"), "");
	
	String endDate = df.format(calendar.getTime());
    calendar.add(Calendar.DATE, -7);
	String StartDate = df.format(calendar.getTime());

	if(selStartDate.equals("") && selEndDate.equals("")) {
		selStartDate = StartDate;
		selEndDate = endDate;		
	}

    setMap.put("startDate",selStartDate);
    setMap.put("endDate",selEndDate);
	List GRVisitLogStatisticsList = commonService.selectList("custom_SQL.zhkfc_getGRVisitLogStatisticsList", setMap);
	JSONArray GRVisitLogStatisticsListData = new JSONArray(GRVisitLogStatisticsList);
	model.put("GRVisitLogStatisticsListData", GRVisitLogStatisticsListData);
	model.put("totalCnt", GRVisitLogStatisticsList.size());
	model.put("startDate", selStartDate);
	model.put("endDate", selEndDate);
	
	model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
		return nextUrl("/custom/hyundai/hkfc/report/zhkfc_GRVisitLogStatistics");
	}
	/*
	@RequestMapping(value="/zHkfc_getAllProcessList.do")
	public String zHkfc_getAllProcessList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map setMap = new HashMap();
		
		String itemTypeCode = StringUtil.checkNull(commandMap.get("selItemTypeCode"),"OJ00001");

		setMap.put("languageID", commandMap.get("languageID"));
		setMap.put("itemTypeCode", itemTypeCode);
		model.put("itemTypeCode", itemTypeCode);

		List AllProcessList = commonService.selectList("custom_SQL.zHkfc_getAllProcessList", setMap);
		JSONArray AllProcessListData = new JSONArray(AllProcessList);
		model.put("AllProcessListData", AllProcessListData);
		model.put("totalCnt", AllProcessList.size());

		
		model.put("menu", getLabel(request, commonService));		
		return nextUrl("/custom/hyundai/hkfc/report/zHkfc_getAllProcessList");
	}
	*/
	
	@RequestMapping(value="/zHkfc_getAllProcessList.do")
	public String zHkfc_getAllProcessList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		
		Map setMap = new HashMap();
		Map attrMap = new HashMap();
		Map map = new HashMap();
		
		setMap.put("category", "AT");
		setMap.put("languageID", commandMap.get("languageID"));
		List attrList = commonService.selectList("common_SQL.getDictionaryOrdStnm_commonSelect", setMap);
		for(int i=0; i<attrList.size(); i++) {
			map = (Map) attrList.get(i);
			attrMap.put(map.get("CODE"), map.get("NAME"));
		}
		
		model.put("s_itemID", commandMap.get("s_itemID"));
		model.put("attrMap", attrMap);
		model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
		return nextUrl("/custom/hyundai/hkfc/report/zHkfc_getAllProcessList2");
	}
	
	


	public List getWiseNutPopularKeyword(String url) throws Exception {
		 String returnData = "";
		 List returnList = new ArrayList();
		 try {
			    URL aURL= new URL(url);
			    InputStreamReader tt = new InputStreamReader(aURL.openStream(),"UTF-8");
			    InputStream aa = aURL.openStream();
	            
	            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
	            DocumentBuilder builder = factory.newDocumentBuilder();
	            Document document = builder.parse(aa);
	            
	            NodeList nList = document.getElementsByTagName("Query");
	            Map tempMap = new HashMap();
	            for (int temp = 0; temp < nList.getLength(); temp++) {
	                tempMap = new HashMap();	
	                Node nNode = nList.item(temp);
	                if (nNode.getNodeType() == Node.ELEMENT_NODE) {
	                    Element eElement = (Element) nNode;
	                    tempMap.put("ID", eElement.getAttribute("id"));
	                    tempMap.put("COUNT", eElement.getAttribute("querycount"));
	                    tempMap.put("TEXT", eElement.getTextContent());
	                }
	                returnList.add(tempMap);
	            }
			} catch (Exception e) {
			    e.printStackTrace();
			}    
		 return returnList;
	 }  
	 
	 private Map<String, Integer> setCnAvgItemsRow(Document doc, Element rootElement, Element row, Element cell, int rowId, List level1NameList, Map setMap, String itemTypeCode, String itemFromTo, Map activityTotalMap) throws ExceptionUtil {
			
			Map<String, Integer> cnItemsMap = new HashMap<String, Integer>();
			
	        try {
				// Title
				row = doc.createElement("row"); 
		        rootElement.appendChild(row); 
		        row.setAttribute("id", String.valueOf(rowId));
		        rowId++;
		        
		        cell = doc.createElement("cell");
		        cell.setAttribute("rowspan", "9");
		        cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");
		        cell.appendChild(doc.createTextNode("L5 전산화율 (중복제외)"));
		        row.appendChild(cell);
		        
		        
		        cell = doc.createElement("cell");
		        cell.appendChild(doc.createTextNode("L5 전산화율 Total"));
		        //cell.setAttribute("colspan", "2");
		        row.appendChild(cell);
		        
		        float average = 0;
		        int tempInt = 0;
				for (int i = 0; i < level1NameList.size(); i++) {
		        	Map level1NameMap = (Map) level1NameList.get(i);
		        	String l1ItemID = String.valueOf(level1NameMap.get("ItemID"));	        	

		        	// Mapping된 L5
		        	setMap.put("ItemTypeCode", itemTypeCode);
		        	setMap.put("L1ItemID", l1ItemID);
		        	List cnItemListL5 = commonService.selectList("custom_SQL.zhkfc_getCnL5ItemList", setMap);
		        	String cnItemCntL5 = String.valueOf(cnItemListL5.size());
		        	
		        	// Mapping된 Total L5
		        	List toItemListL5 = new ArrayList();
			        try {
			        	if(itemFromTo.equals("fromItemID")){
			        		toItemListL5 = commonService.selectList("analysis_SQL.getFromL5ItemList", setMap);
			        	}else{ // toItemID
			        		toItemListL5 = commonService.selectList("analysis_SQL.getToL5ItemList", setMap);
			        	}
			        } catch(Exception e) {
			        	throw new ExceptionUtil(e.toString());
			        }
		        	String toItemCntL5 = String.valueOf(toItemListL5.size());
		        	
		        	
		        	cell = doc.createElement("cell"); 
			        cell.appendChild(doc.createTextNode(cnItemCntL5));
			        row.appendChild(cell);
			        cell = doc.createElement("cell");
			        tempInt = Integer.valueOf((String) activityTotalMap.get(level1NameMap.get("Identifier")+"_CNT"));
			        average = (float) ((float) ((float) cnItemListL5.size() / (float) tempInt)* 100.00);
			        average = (float) (Math.round(average*10)/10.0);
			        cell.appendChild(doc.createTextNode(String.valueOf(average)+"%"));
			        //cell.appendChild(doc.createTextNode(cnItemCntL5 + "/" + toItemCntL5));
			        row.appendChild(cell);
		        }
		        
		        
		        // Total값 설정
				// Mapping된 L4
		    	setMap.put("ItemTypeCode", itemTypeCode);
		    	setMap.remove("L1ItemID");
		        List cnItemList = commonService.selectList("analysis_SQL.getCnItemList", setMap);
		        
		    	String cnItemCnt = String.valueOf(cnItemList.size());

		        // Total값 설정
				// Mapping된 L5
		    	setMap.put("ItemTypeCode", itemTypeCode);
		    	setMap.remove("L1ItemID");
		        List cnItemListL5 = commonService.selectList("custom_SQL.zhkfc_getCnL5ItemList", setMap);
		        
		    	String cnItemCntL5 = String.valueOf(cnItemListL5.size());
		    	
		    	// Mapping된 Total L5
		    	List toItemListL5 = new ArrayList();
		    	if(itemFromTo.equals("fromItemID")){
		    		toItemListL5 = commonService.selectList("analysis_SQL.getFromL5ItemList", setMap);
		    	}else{
		    		toItemListL5 = commonService.selectList("analysis_SQL.getToL5ItemList", setMap);
		    	}
		        
		    	String toItemCntL5 = String.valueOf(toItemListL5.size());
		    	
		        cell = doc.createElement("cell");
		        cell.appendChild(doc.createTextNode(toItemCntL5));
		        cell.setAttribute("style", "font-weight:bold;color:#0D65B7;text-decoration:underline;");
		        row.appendChild(cell);
		        cell = doc.createElement("cell");
		        cell.setAttribute("style", "font-weight:bold;color:#0D65B7;text-decoration:underline;");
		        average = (float) ((float) ((float) toItemListL5.size() / (float) cnItemListL5.size())* 100.00);
		        average = (float) (Math.round(average*10)/10.0);
		        cell.appendChild(doc.createTextNode(String.valueOf(average)+"%"));
		        //cell.appendChild(doc.createTextNode(cnItemCntL5 + "/" + toItemCntL5));
		        row.appendChild(cell);
		        
		        cnItemsMap.put("rowId", rowId);
			} catch(Exception e) {
	        	throw new ExceptionUtil(e.toString());
	        }
			return cnItemsMap;
		}
	 
	 @RequestMapping(value="/zhkfc_viewSubItemHistory.do")
		public String viewSubItemHistory(HttpServletRequest request,  HashMap commandMap, ModelMap model) throws Exception{
			String url = "project/changeInfo/viewSubItemHistory";
			try{
				model.put("menu", getLabel(request, commonService));
				
				Map setMap = new HashMap();			
				String subItemClsList = StringUtil.checkNull(request.getParameter("subItemClsList"),"");
				String csStatus = StringUtil.checkNull(request.getParameter("csStatus"),"");
				
				model.put("subItemClsList", subItemClsList);
				model.put("csStatus", csStatus);
				
				String subItemClassList = "";
				if(!subItemClsList.equals("")) {
					String subItemClass[] = subItemClsList.split(",");
					for(int i=0; i<subItemClass.length; i++) {
						if(i == 0) {
							subItemClassList = "'" + subItemClass[i] + "'";
						}else {
							subItemClassList += ",'" + subItemClass[i] + "'";
						}
					}
					
				}
				setMap.put("subItemclassList", subItemClassList);
				setMap.put("csStatus", csStatus);
				
				setMap.put("s_itemID", StringUtil.checkNull( request.getParameter("s_itemID"),"") );
				setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
				
				setMap.put("ItemID", StringUtil.checkNull( request.getParameter("s_itemID"),"") );
				String changeMgt = StringUtil.checkNull(commonService.selectString("project_SQL.getChangeMgt", setMap));
				List subItemHistoryList = commonService.selectList("cs_SQL.getSubItemHistory_gridList", setMap);
				if(subItemHistoryList.size()>0) {
					for(int i=0; i<subItemHistoryList.size(); i++) {
						Map infoMap = (Map)subItemHistoryList.get(i);
						String subVersion = StringUtil.checkNull(infoMap.get("SubVersion"));
						String changeSetID = StringUtil.checkNull(infoMap.get("ChangeSetID"));
						String itemID = StringUtil.checkNull(infoMap.get("ItemID"));
						String statusCode = StringUtil.checkNull(infoMap.get("StatusCode"));
						
						// fnOpenInfoView(row.ChangeSetID, row.StatusCode, row.ItemID)
						subVersion = "<span onClick='fnOpenTeamPop('"+changeSetID+"','"+statusCode+"','"+itemID+"')'>" + subVersion
						+ "<img class='mgL8' src='/cmm/common/images/detail.png' id='popup' style='width:12px; cursor:pointer;' alt='새창열기'></span>";
						infoMap.put("SubVersion", subVersion);
					}		
					
				}
				
				JSONArray subItemHistoryListData = new JSONArray(subItemHistoryList);
				model.put("subItemHistoryList", subItemHistoryListData);
				model.put("totalCnt", subItemHistoryList.size());
				model.put("s_itemID", StringUtil.checkNull( request.getParameter("s_itemID"),"") );
				model.put("changeMgt", changeMgt);
				
			}catch(Exception e){
				System.out.println(e.toString());
			}
			return nextUrl(url);
		}
	 
	 @RequestMapping(value="/custom/hyundai/hkfc/index.do")
		public String ktngIndex(Map cmmMap, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
			try{
				
				Map setData = new HashMap();
				
				String olmI = StringUtil.checkNull(cmmMap.get("LOGIN_ID"),"");
				String hkfcSSO = StringUtil.checkNull(cmmMap.get("hkfcSSO"),"");
				
				if(!hkfcSSO.equals("")) {
					model.put("olmI", olmI);
				}
				model.put("olmLng", StringUtil.checkNull(cmmMap.get("olmLng"),""));
				model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType"),""));
				model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType"),""));
				model.put("srID", StringUtil.checkNull(cmmMap.get("srID"),""));
				model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode"),""));
			
			}catch (Exception e) {
				if(_log.isInfoEnabled()){_log.info("::mainpage::Error::"+e);}
				throw new ExceptionUtil(e.toString());
			}		
			return nextUrl("indexHKFC");
		}
	 
	 @RequestMapping(value="/certiList.do")
	 public String certiList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
				
			model.put("s_itemID", s_itemID);
			
			Map setData = new HashMap();
			setData.put("s_itemID", s_itemID);
			setData.put("classCode", "CL15004");
			setData.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", commandMap);
			setData.put("defaultLang", defaultLang);
			
			List certiList = commonService.selectList("custom_SQL.getCertiList",setData);
			JSONArray gridData = new JSONArray(certiList);
			model.put("gridData", gridData);
						
			setData.put("itemID", s_itemID);
			String s_itemClassCode = StringUtil.checkNull(commonService.selectString("item_SQL.getClassCode",setData));
			model.put("s_itemClassCode", s_itemClassCode);
			
			Map itemInfo = commonService.select("report_SQL.getItemInfo", setData);
			String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev")); 
			String sessionUserId = StringUtil.checkNull(commandMap.get("sessionUserId"));
			
			if (StringUtil.checkNull(itemInfo.get("AuthorID")).equals(sessionUserId) 
					|| StringUtil.checkNull(itemInfo.get("LockOwner")).equals(sessionUserId)
					|| "1".equals(sessionAuthLev)) {
				model.put("myItem", "Y");
			}
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/custom/hyundai/hkfc/item/certiList");
	}
	 
	@RequestMapping(value = "/registerCertiItem.do")
	public String registerCertiItem(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "custom/hyundai/hkfc/item/registerCertiItem";
		try {			
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("s_itemID", s_itemID);
			cmmMap.put("ItemID", s_itemID);
			cmmMap.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
			String itemPath = StringUtil.checkNull(commonService.selectString("organization_SQL.getPathOrg", cmmMap));
			String itemTypeCode = StringUtil.checkNull(commonService.selectString("item_SQL.getItemTypeCode", cmmMap));
			
			String classCode = StringUtil.checkNull(request.getParameter("classCode"));
			String fltpCode = StringUtil.checkNull(request.getParameter("fltpCode"));
			String defCSRID = StringUtil.checkNull(commonService.selectString("item_SQL.getDefCSRID", cmmMap));
			String dimTypeID = StringUtil.checkNull(request.getParameter("dimTypeID"));
											 
			model.put("itemTypeCode", itemTypeCode);
			model.put("itemPath", itemPath);
			model.put("classCode", classCode);
			model.put("fltpCode", fltpCode);
			model.put("dimTypeID", dimTypeID);	
			model.put("csrID", defCSRID);
			
			Map setData = new HashMap();
			
			setData.put("languageID", cmmMap.get("sessionCurrLangType"));
			setData.put("Editable", "1");
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", cmmMap);
			setData.put("defaultLang", defaultLang);
			setData.put("classCode", classCode);
			setData.put("showInvisible", StringUtil.checkNull(request.getParameter("showInvisible")));
			
			// isComLang = ALL
			List attrAllocList = (List)commonService.selectList("attr_SQL.getAttrTypeAllocList", setData);
						
			// get ITEM ATTR (각 속성에 따른 언어 설정(IsComLang)에 따른 data 취득)
			//attrList = GetItemAttrList.getItemAttrList2(commonService, attrList, setData, request.getParameter("languageID"));
						
			List mLovList = new ArrayList();
			List mLovAttrList = new ArrayList();
			List mLovList2 = new ArrayList();
			setData = new HashMap();
			Map mLovMap = new HashMap();
			String dataType = "";
			String dataType2 = "";
			String mLovAttrTypeCode = "";
			String mLovAttrTypeValue = "";
			
			int k=0; int l=0;
			for(int i=0; i<attrAllocList.size(); i++){
				Map listMap = (Map) attrAllocList.get(i);
				dataType = StringUtil.checkNull(listMap.get("DataType"));
				dataType2 = StringUtil.checkNull(listMap.get("DataType2"));
				if(!dataType.equals("Text")){
					setData.put("attrTypeCode",listMap.get("AttrTypeCode"));
					setData.put("languageID", cmmMap.get("sessionCurrLangType")); 
					setData.put("defaultLang", defaultLang);
					mLovList = commonService.selectList("attr_SQL.getMLovListWidthItemAttr",setData);
					listMap.put("mLovList", mLovList);
										
					if(k==0){
						mLovAttrTypeCode = StringUtil.checkNull(listMap.get("AttrTypeCode"));
						mLovAttrTypeValue =  StringUtil.checkNull(listMap.get("NAME"));
					}else{
						mLovAttrTypeCode = mLovAttrTypeCode  + "," +StringUtil.checkNull(listMap.get("AttrTypeCode"));
						mLovAttrTypeValue = mLovAttrTypeValue  + "," +StringUtil.checkNull(listMap.get("NAME"));
					}
					model.put("mLovAttrTypeCode",mLovAttrTypeCode);
					model.put("mLovAttrTypeValue",mLovAttrTypeValue);
					k++;
				}
				
				if(!dataType2.equals("Text")){
					setData.put("attrTypeCode",listMap.get("AttrTypeCode2"));
					setData.put("languageID", cmmMap.get("sessionCurrLangType"));
					setData.put("defaultLang", defaultLang);
					mLovList2 = commonService.selectList("attr_SQL.getMLovListWidthItemAttr",setData);
					listMap.put("mLovList2", mLovList2);
										
					if(l==0 && mLovAttrTypeCode.equals("")){
						mLovAttrTypeCode = StringUtil.checkNull(listMap.get("AttrTypeCode2"));
						mLovAttrTypeValue =  StringUtil.checkNull(listMap.get("NAME2"));
					}else{
						mLovAttrTypeCode = mLovAttrTypeCode  + "," +StringUtil.checkNull(listMap.get("AttrTypeCode2"));
						mLovAttrTypeValue = mLovAttrTypeValue  + "," +StringUtil.checkNull(listMap.get("NAME2"));
					}
					model.put("mLovAttrTypeCode2",mLovAttrTypeCode);
					model.put("mLovAttrTypeValue2",mLovAttrTypeValue);
					l++;
				}
			}
		
			model.put("attrAllocList", attrAllocList);
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	 	
	@RequestMapping(value = "/editCertiItem.do")
	public String editCertiItem(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "custom/hyundai/hkfc/item/editCertiItem";
		try {			
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("s_itemID", s_itemID);
			cmmMap.put("ItemID", s_itemID);
			cmmMap.put("languageID", languageID);
			String itemPath = StringUtil.checkNull(commonService.selectString("organization_SQL.getPathOrg", cmmMap));
			String itemTypeCode = StringUtil.checkNull(commonService.selectString("item_SQL.getItemTypeCode", cmmMap));
			
			String classCode = StringUtil.checkNull(request.getParameter("classCode"));
			String fltpCode = StringUtil.checkNull(request.getParameter("fltpCode"));
			String dimTypeID = StringUtil.checkNull(request.getParameter("dimTypeID"));
			String defCSRID = StringUtil.checkNull(commonService.selectString("item_SQL.getDefCSRID", cmmMap));
			
			model.put("itemTypeCode", itemTypeCode);
			model.put("itemPath", itemPath);
			model.put("classCode", classCode);
			model.put("fltpCode", fltpCode);
			model.put("dimTypeID", dimTypeID);	
			model.put("csrID", defCSRID);
			
			Map setMap = new HashMap();
			setMap.put("s_itemID", s_itemID);
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			setMap.put("Editable", "1");
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", cmmMap);
			setMap.put("defaultLang", defaultLang);
			setMap.put("classCode", classCode);
			setMap.put("showInvisible", StringUtil.checkNull(request.getParameter("showInvisible")));
			
			List attrAllocList = (List)commonService.selectList("attr_SQL.getItemAttrMain", setMap);
			// get ITEM ATTR (각 속성에 따른 언어 설정(IsComLang)에 따른 data 취득)
			attrAllocList = GetItemAttrList.getItemAttrList2(commonService, attrAllocList, setMap, languageID);
						
			List mLovList = new ArrayList();
			List mLovAttrList = new ArrayList();
			List mLovList2 = new ArrayList();
			Map setData = new HashMap();
			Map mLovMap = new HashMap();
			String dataType = "";
			String dataType2 = "";
			String mLovAttrTypeCode = "";
			String mLovAttrTypeValue = "";
			
			int k=0; int l=0;
			for(int i=0; i<attrAllocList.size(); i++){
				Map listMap = (Map) attrAllocList.get(i);
				dataType = StringUtil.checkNull(listMap.get("DataType"));
				dataType2 = StringUtil.checkNull(listMap.get("DataType2"));
				if(!dataType.equals("Text")){
					setData.put("attrTypeCode",listMap.get("AttrTypeCode"));
					setData.put("itemID",s_itemID);
					setData.put("languageID", cmmMap.get("sessionCurrLangType")); 
					setData.put("defaultLang", defaultLang);
					mLovList = commonService.selectList("attr_SQL.getMLovListWidthItemAttr",setData);
					listMap.put("mLovList", mLovList);
										
					if(k==0){
						mLovAttrTypeCode = StringUtil.checkNull(listMap.get("AttrTypeCode"));
						mLovAttrTypeValue =  StringUtil.checkNull(listMap.get("NAME"));
					}else{
						mLovAttrTypeCode = mLovAttrTypeCode  + "," +StringUtil.checkNull(listMap.get("AttrTypeCode"));
						mLovAttrTypeValue = mLovAttrTypeValue  + "," +StringUtil.checkNull(listMap.get("NAME"));
					}
					model.put("mLovAttrTypeCode",mLovAttrTypeCode);
					model.put("mLovAttrTypeValue",mLovAttrTypeValue);
					k++;
				}
				
				if(!dataType2.equals("Text")){
					setData.put("attrTypeCode",listMap.get("AttrTypeCode2"));
					setData.put("itemID",s_itemID);
					setData.put("languageID", cmmMap.get("sessionCurrLangType"));
					setData.put("defaultLang", defaultLang);
					mLovList2 = commonService.selectList("attr_SQL.getMLovListWidthItemAttr",setData);
					listMap.put("mLovList2", mLovList2);
										
					if(l==0 && mLovAttrTypeCode.equals("")){
						mLovAttrTypeCode = StringUtil.checkNull(listMap.get("AttrTypeCode2"));
						mLovAttrTypeValue =  StringUtil.checkNull(listMap.get("NAME2"));
					}else{
						mLovAttrTypeCode = mLovAttrTypeCode  + "," +StringUtil.checkNull(listMap.get("AttrTypeCode2"));
						mLovAttrTypeValue = mLovAttrTypeValue  + "," +StringUtil.checkNull(listMap.get("NAME2"));
					}
					model.put("mLovAttrTypeCode2",mLovAttrTypeCode);
					model.put("mLovAttrTypeValue2",mLovAttrTypeValue);
					l++;
				}
				
				String attrTypeCode2 = StringUtil.checkNull(listMap.get("AttrTypeCode2"));
				if(attrTypeCode2.equals("ZAT4015")) {
					setMap.put("memberID", StringUtil.checkNull(listMap.get("PlainText2")));
					setMap.put("assignmentType", "CNGROLETP");
					setMap.put("roleType", "R");
					setMap.put("orderNum", 1);
					setMap.put("itemID", s_itemID);
					setMap.put("languageID", languageID);
					
					Map ZAT4015Info = commonService.select("role_SQL.getMyItemMemberInfo", setMap);
					model.put("ZAT4015Info", ZAT4015Info);
				}
			}
			model.put("attrAllocList", attrAllocList);
						
			// certi Item Attr 기본 정보 
			setData.put("itemID", s_itemID);
			setData.put("languageID", languageID);
			Map certiItemAttrInfo = commonService.select("custom_SQL.zkpal_getCertiItemAttrInfo", setData);
			
			model.put("certiItemAttrInfo", certiItemAttrInfo);
			
			String sessionAuthLev = String.valueOf(cmmMap.get("sessionAuthLev")); 
			String sessionUserId = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			
			if (StringUtil.checkNull(certiItemAttrInfo.get("AuthorID")).equals(sessionUserId) 
					|| StringUtil.checkNull(certiItemAttrInfo.get("LockOwner")).equals(sessionUserId)
					|| "1".equals(sessionAuthLev)) {
				model.put("myItem", "Y");
			}
			
			setData.put("DocumentID", s_itemID);
			List attachFileList = commonService.selectList("fileMgt_SQL.getFile_gridList", setData);
			model.put("attachFileList", attachFileList);
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value="/saveCertiItemAttr.do")
	public String saveCertiItemAttr(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{		
		HashMap target = new HashMap();		
		try{
			
			String setInfo = "";
			String itemId = StringUtil.checkNull(request.getParameter("s_itemID"));		
			String identifier = StringUtil.checkNull(request.getParameter("Identifier"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String userID = StringUtil.checkNull(commandMap.get("sessionUserID"));
			String csrID = StringUtil.checkNull(commandMap.get("csrID"));
			String fltpCode = StringUtil.checkNull(commandMap.get("fltpCode"));
			
			Map setValue = new HashMap();
			setValue.put("ItemID", itemId);	
			setValue.put("Identifier", identifier);
			
			/* Identifier unique check */
			String itemCount = "0";
			
			if (!identifier.isEmpty()) {
				itemCount = commonService.selectString("attr_SQL.identifierEqualCount", setValue);
			}
			
			//동일 ID 중복 시 팝업 창에 중복된 Item의 "항목계층명/경로/명칭"을 출력해 줌
			if (!itemCount.equals("0")) {
				setValue.put("languageID", languageID);
				//target.put(AJAX_ALERT, "동일한 ID가 "+commonService.selectString("attr_SQL.getEqualIdentifierInfo", setValue)+"에 존재 합니다. ");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00081", new String[]{commonService.selectString("attr_SQL.getEqualIdentifierInfo", setValue)}));
				target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			} else {
				
				/* 기본정보 update */
				setValue.put("languageID", languageID);
				setValue.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
				setValue.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
				
				String itemName = StringUtil.checkNull(request.getParameter("itemName"));
				//String ZAT4010 = StringUtil.checkNull(request.getParameter("ZAT4010"));
				//String ZAT4011 = StringUtil.checkNull(request.getParameter("ZAT4011"));
				//String ZAT4015 = StringUtil.checkNull(request.getParameter("ZAT4015"));
				//String ZAT4016 = StringUtil.checkNull(request.getParameter("ZAT4016"));
				
				setValue.put("AttrTypeCode", "AT00001");
				setValue.put("PlainText", itemName);	
				setValue.put("languageID", languageID);
				System.out.println("setValue :"+setValue);
				setInfo = GetItemAttrList.attrUpdate(commonService, setValue);	
				
				// 명칭 이외
				setValue.put("Identifier", identifier);
				setValue.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
				setValue.put("LastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));
				
				commonService.update("item_SQL.updateItemObjectInfo",setValue);	
				
				String ZAT4015 = StringUtil.checkNull(request.getParameter("ZAT4015_ID"));
				String ZAT4015_Name = StringUtil.checkNull(request.getParameter("ZAT4015"));
				String ZAT4015_ORG = StringUtil.checkNull(request.getParameter("ZAT4015_ORG"));
				
				Map setData = new HashMap();
				if(!ZAT4015_Name.equals("") && ZAT4015_Name != null) {
					setData.put("sessionUserId", ZAT4015);
					String mbrTeamID = commonService.selectString("user_SQL.userTeamID", setData);
					
					setData.put("projectID", csrID);
					setData.put("itemID", itemId);
					setData.put("assignmentType", "CNGROLETP");
					setData.put("roleType", "R");
					setData.put("orderNum", 1);
					setData.put("assigned", 1);
					setData.put("accessRight", "U");
										
					String myItemSeq = StringUtil.checkNull(commonService.selectString("role_SQL.getMyItemSeq", setData));
					
					setData.put("memberID", ZAT4015);
					setData.put("mbrTeamID", mbrTeamID);
					setData.put("creator", userID);
					if(!myItemSeq.equals("")) {
						setData.put("seq", myItemSeq);
						commonService.update("role_SQL.updateRoleAssignment", setData);
					} else {
						commonService.insert("role_SQL.insertRoleAssignment", setData);
					}
				}else {
					setData.put("itemID", itemId);
					setData.put("assignmentType", "CNGROLETP");
					setData.put("roleType", "R");
					setData.put("orderNum", 1);
					setData.put("memberID", ZAT4015_ORG);
					commonService.delete("role_SQL.deleteRoleAssignment", setData);
				}
				
				/* Item_Attr update */
				List returnData = new ArrayList();
				// Editable 이, 1인 속성만 update 처리를 한다
				commandMap.put("Editable", "1");
				returnData = (List)commonService.selectList("attr_SQL.getItemAttr", commandMap);	
				
				//itemInfoService.save(returnData, commandMap);
				Map setMap = new HashMap();
				String dataType = "";
				String mLovValue = "";
				String html = "";
				for(int i = 0; i < returnData.size() ; i++){				
					setMap = (HashMap)returnData.get(i);
					dataType = StringUtil.checkNull(setMap.get("DataType"));
					html = StringUtil.checkNull(setMap.get("HTML"));
					if(!dataType.equals("Text")){
						if(dataType.equals("MLOV")){
							String reqMLovValue[] =  StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode"))).split(",");
							Map delData = new HashMap();
							delData.put("ItemID", itemId);
							delData.put("AttrTypeCode", setMap.get("AttrTypeCode"));
							commonService.delete("attr_SQL.delItemAttr", delData);
								for(int j=0; j<reqMLovValue.length; j++){
									mLovValue = reqMLovValue[j].toString();							
									setMap.put("PlainText", mLovValue);						
									setMap.put("ItemID", StringUtil.checkNull(request.getParameter("s_itemID")));
									setMap.put("languageID", commandMap.get("sessionDefLanguageId"));
									setMap.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
									setMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));															
									setMap.put("LovCode", mLovValue );
									setInfo = GetItemAttrList.attrUpdate(commonService, setMap);
								}	
							}else{
								setMap.put("PlainText", StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode").toString()),"") );					
								setMap.put("ItemID", StringUtil.checkNull(request.getParameter("s_itemID")));
								setMap.put("languageID", commandMap.get("sessionDefLanguageId"));
								setMap.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
								setMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));															
								setMap.put("LovCode", StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode").toString()),"") );
								setInfo = GetItemAttrList.attrUpdate(commonService, setMap);
							}
					}else{	
							String plainText = StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode")),"");
							if(html.equals("1")){
								plainText =  StringEscapeUtils.escapeHtml4(plainText);
							}
							setMap.put("PlainText", plainText);
							setMap.put("ItemID", StringUtil.checkNull(request.getParameter("s_itemID")));
							setMap.put("languageID", languageID);
							setMap.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
							setMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));															
							setMap.put("LovCode", StringUtil.checkNull( commonService.selectString("attr_SQL.selectAttrLovCode", setMap) ,"") );
							setInfo = GetItemAttrList.attrUpdate(commonService, setMap);
					}
				}
				
				//첨부파일 등록 : TB_FILE 
				commandMap.put("projectID", csrID);
				commandMap.put("id", itemId);
				commandMap.put("usrId", userID);
				commandMap.put("docCategory", "ITM");
				fileMgtActionController.saveMultiFile(request,commandMap,model);
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
				target.put(AJAX_SCRIPT, "parent.selfClose();parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
				
			}
			
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}	
	
	@RequestMapping(value="/custom/hyundai/hkfc/updateDocumentCountKPAL.do")
	public void updateDocumentCountKPAL (HttpServletRequest request, HttpServletResponse response) throws Exception {
		try{
			
			Map setData = new HashMap();
			List documentCountList = commonService.selectList("wf_SQL.getDueWFInstCountByActor", setData);
			String userID = "";
			String count = "";
			String code = "KPAL";
			String title = "KPAL";
			String link = GlobalVal.OLM_SERVER_URL;
			CountInformation[] countInformation = new CountInformation[documentCountList.size()];
			
			System.out.println("start updateDocumentCountKPAL");
			
			if(documentCountList.size()>0) {
				for(int i=0; i<documentCountList.size(); i++) {
					Map resultMap = (Map)documentCountList.get(i);
					userID = StringUtil.checkNull(resultMap.get("userID"));
					count = StringUtil.checkNull(resultMap.get("count"));
					
					if (GlobalVal.OLM_INBOUND_LINK != null && !("").equals(GlobalVal.OLM_INBOUND_LINK)){
						link = GlobalVal.OLM_SERVER_URL + "/" + GlobalVal.OLM_INBOUND_LINK + "?olmLoginid=" + userID + "&object=WFLIST";
					}
					
					CountInformation countInfo = new CountInformation(userID,count,code,title,link);
					countInformation[i] = countInfo;
				}
			}
			KIACSvcSoapProxy KIACSvcSoapProxy = new KIACSvcSoapProxy();
			boolean result = KIACSvcSoapProxy.updateDocumentCount(countInformation);
			
			if(result == false){
				System.out.println("failed updateDocumentCountKPAL");
			} else {
				System.out.println("end updateDocumentCountKPAL");
			}
			
		}catch (Exception e) {
			System.out.println(e); 
			throw new ExceptionUtil(e.toString()); 
		}
	} 
	
	@RequestMapping(value="/zhkfc_editItemAttrList.do")
	public String zhkfc_editItemAttrList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {
			model.put("menu", getLabel(request, commonService));
			HashMap setData = new HashMap();			
			String userID = StringUtil.checkNull(commandMap.get("sessionUserId"),"");
			String languageID =  StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String defaultLang = StringUtil.checkNull(commandMap.get("sessionDefLanguageId"));
			String reportCode = StringUtil.checkNull(commandMap.get("reportCode"));
			String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev")); // 시스템 관리자
			
			setData.put("sessionUserID", userID);
			setData.put("languageID", languageID);
			setData.put("reportCode", reportCode);	
			setData.put("classCode", "CL01005");
			setData.put("defaultLang", defaultLang);
			setData.put("sessionAuthLev", sessionAuthLev);
				
			List<String> itemTypeCodeList = new ArrayList(); itemTypeCodeList.add("OJ00001");
			setData.put("itemTypeCodeList",itemTypeCodeList);		
			List L1List = commonService.selectList("analysis_SQL.getL1List", setData);
			
			JSONArray L1Data = new JSONArray(L1List);
			model.put("L1Data", L1Data);
			
			Map L1ListMap = (Map)L1List.get(0); 
			String L1 = StringUtil.checkNull(L1ListMap.get("Identifier"));
			setData.put("L1", L1);
						
			List myItemList = commonService.selectList("custom_SQL.zkpal_getEditItemAttrList", setData);
			JSONArray gridData = new JSONArray(myItemList);
			model.put("gridData", gridData);
			//System.out.println("gridData :"+gridData);
					
			model.put("title", commonService.selectString("report_SQL.getReportName", setData));

			setData.put("attrTypeCode", "ZAT0005");
			List ZAT0005LovList = commonService.selectList("attr_SQL.getMLovListWidthItemAttr", setData);
			
			List<String> AT5Options = new ArrayList<>(); 
			if(ZAT0005LovList.size() > 0) {
				AT5Options.add("\""+""+"\"");
				for(int i=0; i< ZAT0005LovList.size(); i++) {
					Map lovMap = (Map)ZAT0005LovList.get(i);
					AT5Options.add("\""+StringUtil.checkNull(lovMap.get("NAME"))+"\"");
				}
			}
			model.put("AT5Options", AT5Options);
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/custom/hyundai/hkfc/item/zHkfcEditItemAttrList");
	}
	
	@RequestMapping(value="/zHkfc_updateItemAttr.do")
	public String zHkfc_updateItemAttr (HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try{
			Map setData = new HashMap();
			JSONArray jsonArray = new JSONArray(request.getParameter("updateData"));
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),"");
			String itemID = "";
			String ZAT0004Text = "";
			String ZAT0005Text = "";
			String ZAT0006Text = "";
			String plainText = "";
			JSONObject jsonData;
			setData.put("languageID", languageID);
			for (int i = 0; i < jsonArray.length(); i++) {
				jsonData = (JSONObject) jsonArray.get(i);
				
				setData = new HashMap();
				setData.put("languageID", languageID);
				itemID = StringUtil.checkNull(jsonData.get("ItemID"), "");
				ZAT0004Text = StringUtil.checkNull(jsonData.get("ZAT0004"), "");
				ZAT0005Text = StringUtil.checkNull(jsonData.get("ZAT0005"), "");
				ZAT0006Text = StringUtil.checkNull(jsonData.get("ZAT0006"), "");
			
				setData.put("itemID", itemID);setData.put("ItemID", itemID);
				setData.put("AttrTypeCode", "ZAT0004"); 
				setData.put("attrTypeCode", "ZAT0004");
				setData.put("PlainText", ZAT0004Text);
								
				plainText = StringUtil.checkNull(commonService.selectString("item_SQL.getItemAttrPlainText", setData));
				
				if(ZAT0004Text.equals("")) {
					commonService.delete("attr_SQL.delItemAttr", setData);
				}else {
					if(plainText.equals("")){						
						commonService.insert("item_SQL.setItemAttr", setData);
					}else{ 
						commonService.update("item_SQL.updateItemAttr", setData);
					}
				}
				
				setData = new HashMap();
				setData.put("languageID", languageID);
				setData.put("itemID", itemID); setData.put("ItemID", itemID);
				setData.put("AttrTypeCode", "ZAT0005");  setData.put("attrTypeCode", "ZAT0005");
				setData.put("languageID", languageID);
				setData.put("Value", ZAT0005Text);
				
				if(ZAT0005Text.equals("")) {
					commonService.delete("attr_SQL.delItemAttr", setData);
				}else {
					String ZAT0005LovCode = StringUtil.checkNull(commonService.selectString("attr_SQL.selectAttrLovCode2", setData));
					setData.put("PlainText", ZAT0005LovCode);
					setData.put("LovCode", ZAT0005LovCode);
					plainText = StringUtil.checkNull(commonService.selectString("item_SQL.getItemAttrPlainText", setData));
					if(plainText.equals("")){						
						commonService.insert("item_SQL.setItemAttr", setData);
					}else{ 
						commonService.update("item_SQL.updateItemAttr", setData);
					}
				}
				
				setData = new HashMap();
				setData.put("languageID", languageID);
				setData.put("itemID", itemID);setData.put("ItemID", itemID);
				setData.put("AttrTypeCode", "ZAT0006"); 
				setData.put("attrTypeCode", "ZAT0006");
				setData.put("PlainText", ZAT0006Text);
								
				plainText = StringUtil.checkNull(commonService.selectString("item_SQL.getItemAttrPlainText", setData));
				
				if(ZAT0006Text.equals("")) {
					commonService.delete("attr_SQL.delItemAttr", setData);
				}else {
					if(plainText.equals("")){						
						commonService.insert("item_SQL.setItemAttr", setData);
					}else{ 
						commonService.update("item_SQL.updateItemAttr", setData);
					}
				}
			}
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
			target.put(AJAX_SCRIPT, "parent.fnReload();parent.$('#isSubmit').remove();");
			
		}catch (Exception e) {
			System.out.println(e); 
			throw new ExceptionUtil(e.toString()); 
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	} 
	
	@RequestMapping(value="/zhkfc_resetItemAttr.do")
	public String zhkfc_resetItemAttr (HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try{
			Map setData = new HashMap();
			String[] arrayStr = null;
			String itemAttrTypeCodes = StringUtil.checkNull(request.getParameter("itemAttrTypeCodes"),"");
			if(itemAttrTypeCodes.contains(",")) {
				arrayStr = itemAttrTypeCodes.split(",");
			} else {
				arrayStr[0] = itemAttrTypeCodes;
			}
			
			String dbFuncCode = "TI_DELETE_ITEM_ATTR"; // default procedure
			
			setData.put("dbFuncCode",dbFuncCode);
			
			for(int i=0; i< arrayStr.length; i++){
				setData.put("resetItemAttrCode",arrayStr[i]);
				commonService.insert("custom_SQL.zkpal_resetItemAttr", setData);
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00069"));
			target.put(AJAX_SCRIPT, "fnReload();parent.$('#isSubmit').remove();");
			
		}catch (Exception e) {
			System.out.println(e); 
			throw new ExceptionUtil(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	} 
	 
}
