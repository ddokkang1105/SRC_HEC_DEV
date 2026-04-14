package xbolt.rpt.web;

import com.org.json.JSONArray;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.text.StringEscapeUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.xssf.usermodel.*;
import org.apache.tools.zip.ZipEntry;
import org.apache.tools.zip.ZipOutputStream;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.*;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.cmm.service.dao.CommonMsDao;
import xbolt.project.chgInf.web.CSActionController;

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
import java.io.*;
import java.lang.reflect.Method;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 분석/통계
 * @Class Name : ReportActionController.java
 * @Description : 분석/통계관련 Biz.
 * @Modification Information
 * @수정일			수정자		수정내용
 * @--------- 		---------	-------------------------------
 * @2013. 01. 22.	bshy		최초생성
 *
 * @since 2013. 01. 22
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class ReportActionController extends XboltController{

	private final Log _log = LogFactory.getLog(this.getClass());

	@Resource(name = "commonService")
	private CommonService commonService;

	@Resource(name = "reportService")
	private CommonService reportService;
	
	@Resource(name = "fileMgtService")
	private CommonService fileMgtService;
	
	@Resource(name = "CSActionController")
	private CSActionController CSActionController;
	
	@Resource(name = "CxnItemService")
	private CommonService CxnItemService;
	
	//계층구조 화면 속성
		@RequestMapping(value="/downSubItemMasterList.do")
		public String downSubItemMasterList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
			try{
				
				Map setMap = new HashMap();
				
				// 선택된 아이템의 ItemTypeCode 취득
				setMap.put("s_itemID", request.getParameter("itemID"));
				Map iteminfoMap = commonService.select("project_SQL.getItemInfo", setMap);
				
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
				model.put("s_itemID", request.getParameter("itemID"));
				model.put("ArcCode", request.getParameter("ArcCode"));
				model.put("itemTypeCode", StringUtil.checkNull(iteminfoMap.get("ItemTypeCode")));
				model.put("defDimValueID", StringUtil.checkNull(commandMap.get("defDimValueID")));
				model.put("showInvisible", StringUtil.checkNull(commandMap.get("showInvisible")));
				
			} catch(Exception e) {
				System.out.println(e.toString());
			}
			
			return nextUrl("/report/downSubItemMasterList");
		}
	
	
	
	//계층구조 화면 속성
	@RequestMapping(value="/hierarchStrReport.do")
	public String hierarchStrReport(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		try{
			
			Map setMap = new HashMap();
			
			// 선택된 아이템의 ItemTypeCode 취득
			setMap.put("s_itemID", request.getParameter("itemID"));
			Map iteminfoMap = commonService.select("project_SQL.getItemInfo", setMap);
			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
			model.put("s_itemID", request.getParameter("itemID"));
			model.put("ArcCode", request.getParameter("ArcCode"));
			model.put("itemTypeCode", StringUtil.checkNull(iteminfoMap.get("ItemTypeCode")));
			
		} catch(Exception e) {
			System.out.println(e.toString());
		}
		
		return nextUrl("/report/hierarchStrReport");
	}
	
	@RequestMapping(value="/hierarchStrReportGridJson.do")
	public void hierarchStrReportGridJson(HashMap commandMap, HttpServletResponse response) throws Exception{
			
			
		String SQL_CODE = getString(commandMap.get("menuId"), "commonCode");	// menuId가 없은 경우가 가끔 있음

		List <Map>result = commonService.selectList(SQL_CODE+SQL_GRID_LIST, commandMap);
		List <Map>attrResult = commonService.selectList("report_SQL.itemAttrByHierarchStr", commandMap);
		String subcol = ((String)commandMap.get("subcols"));
		
		String [] maincols = ((String)commandMap.get("cols")).replaceAll(subcol, "").split("[|]");//중복되는 column 제외
		String [] subcols = (subcol).split("[|]");
		
		int totalPage = 0;

		JsonUtil.returnGridMergeJson(result, attrResult, maincols, subcols, totalPage, response, (String)commandMap.get("contextPath"));
	}
	
	/**
	 * Process Excel 출력
	 * @param request
	 * @param commandMap
	 * @param model
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/subItemMasterListWithStr.do")
	public String subItemMasterListWithStr(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception{
		
		HashMap target = new HashMap();
		HashMap setMap = new HashMap();
		FileOutputStream fileOutput = null;
		XSSFWorkbook wb = new XSSFWorkbook();
		
		try{
			
			Map menu = getLabel(request, commonService);
			String attType = StringUtil.checkNull(commandMap.get("AttrTypeCode"));
			String attrName = StringUtil.checkNull(commandMap.get("AttrName"));
			
			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", commandMap);
			String selectedLang = StringUtil.checkNull(commandMap.get("languageID"));
			
			// 파일명에 이용할 Item Name 을 취득
			Map selectedItemMap = commonService.select("report_SQL.getItemInfo", commandMap);
			
			/* SQL에 넘겨줄 선택된 속성 코드를 ArrayList에 담음 */
			// 각 속성의 IsComLang 취득
			commandMap.put("attType", attType.replaceAll("&#39;", "'"));
			List comLangList = commonService.selectList("report_SQL.getAttrIsComLang", commandMap);
			Map comLangMap = new HashMap();
			
			for (int i = 0; comLangList.size() > i ; i++) {
				Map map = (Map) comLangList.get(i);
				comLangMap.put(map.get("AttrTypeCode"), map.get("IsComLang"));
			}
			
			String[] attrTypeArray = attType.split(",");
			List attrTypeArrayList = new ArrayList();
			Map attrTypeArrayMap = new HashMap();
			
			for (int i = 0; attrTypeArray.length > i ; i++) {
				attrTypeArrayMap = new HashMap();
				attrTypeArrayMap.put("TableName", "T" + String.valueOf(i + 10));
				attrTypeArrayMap.put("AttrNum", attrTypeArray[i].replace("'", ""));
				if ("1".equals(comLangMap.get(attrTypeArray[i].replace("'", "")).toString())) {
					attrTypeArrayMap.put("LangCode", defaultLang);
				} else {
					attrTypeArrayMap.put("LangCode", selectedLang);
				}
				attrTypeArrayList.add(attrTypeArrayMap);
			}
			
			commandMap.put("attrList", attrTypeArrayList);
			
			/* arcCode [TB_ARC_FILTER_DIM] 존재 체크, 존재 하면 [TB_ITEM_DIM]에 존재 하는 아이템의 정보만 report로 출력 */
			String arcCode = StringUtil.checkNull(request.getParameter("ArcCode"));
			commandMap.put("ArcCode", arcCode);
			commandMap.put("SelectMenuId", arcCode);
			/*Map arcFilterDimInfoMap =  commonService.select("report_SQL.getArcFilterDimInfo", commandMap);
			if (null != arcFilterDimInfoMap) {
				//String[] arrayLowLankItem =  StringUtil.checkNull(commandMap.get("sessionParamSubItems")).split(",");
				//String outPutItems = getChildItemList(arrayLowLankItem, arcFilterDimInfoMap, StringUtil.checkNull(request.getParameter("s_itemID")));
				String outPutItems = getArcTreeIDs(commandMap);
				commandMap.put("outPutItems", outPutItems);
			}*/
			
			String level = commonService.selectString("report_SQL.getItemClassLevel", commandMap);
			
			if ("1".equals(level)) {
				commandMap.put("LevelName", "L1ItemID");
			} else if ("2".equals(level)) {
				commandMap.put("LevelName", "L2ItemID");
			} else if ("3".equals(level)) {
				commandMap.put("LevelName", "L3ItemID");
			} else if ("4".equals(level)) {
				commandMap.put("LevelName", "L4ItemID");
			} else if ("0".equals(level)) {
				commandMap.put("LevelName", "L0ItemID");
			}
			
			List result = commonService.selectList("report_SQL.exportSubItemList", commandMap);
			
			XSSFSheet sheet = wb.createSheet("Item master list");
			sheet.createFreezePane(6, 2); // 고정줄
			XSSFCellStyle headerStyle = setCellHeaderStyle(wb);
			XSSFCellStyle contentsStyle = setCellContentsStyle(wb, "");
		
			int cellIndex = 0;
			int rowIndex = 0;
			XSSFRow row = sheet.createRow(rowIndex);
			row.setHeight((short) (512 * ((double) 8 / 10 )));
			XSSFCell cell = null;
			rowIndex++;
			
			// AttributeCode 행 설정
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			// 명칭
			cell = row.createCell(cellIndex);
			cell.setCellValue("AT00001");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			// 그외의 속성
			String[] attrNameArray = attrName.split(",");
			
			for (int i = 0; attrTypeArray.length > i ; i++) {
				cell = row.createCell(cellIndex);
				cell.setCellValue(attrTypeArray[i].replace("'", ""));
				cell.setCellStyle(headerStyle);
				cellIndex++;
			}
			
			// 수정일
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			// 최종 수정자
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			// Title 행 설정
			cellIndex = 0;   // cell index 초기화
			row = sheet.createRow(rowIndex);
			row.setHeight((short) 512);
			rowIndex++;
			/* ItemID */
			cell = row.createCell(cellIndex);
			cell.setCellValue("ItemID");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			/* 경로 */
			
			cell = row.createCell(cellIndex);
			cell.setCellValue("Level1");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("Level2");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("Level3");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("Level4");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			/* ID */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00106")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			/* 항목계층 */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00016")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			/* Name */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00028")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			// 속성 header 설정
			for (int i = 0; attrNameArray.length > i ; i++) {
				cell = row.createCell(cellIndex);
				cell.setCellValue(attrNameArray[i].replace("'", ""));
				cell.setCellStyle(headerStyle);
				cellIndex++;
			}
			
			/* 수정일 */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00070")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			/* 최종 수정자 */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00105")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			// Data 행 설정
			
			for (int i=0; i < result.size();i++) {
				cellIndex = 0;   // cell index 초기화
				Map map = (Map) result.get(i);
			    row = sheet.createRow(rowIndex);
			    row.setHeight((short) (512 * ((double) 8 / 10 )));
			    
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("MyItemID"))); // MPM ID
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(removeAllTag(StringUtil.checkNull(map.get("L1Name")))); // Level1
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(removeAllTag(StringUtil.checkNull(map.get("L2Name")))); // Level2
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(removeAllTag(StringUtil.checkNull(map.get("L3Name")))); // Level3
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(removeAllTag(StringUtil.checkNull(map.get("L4Name")))); // Level4
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("Identifier"))); // ID
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("MyClassName"))); // 항목계층
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(removeAllTag(StringUtil.checkNull(map.get("MyItemName")))); // 명칭
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    
			    cell = row.createCell(cellIndex);
			    
				for (int j = 0; attrTypeArray.length > j ; j++) {
					String attrType = attrTypeArray[j].replace("'", "");
					String cellValue = removeAllTag(StringUtil.checkNull(map.get(attrType)));
					
					setMap.put("AttrTypeCode",attrType);
					String isHTML = commonService.selectString("report_SQL.getAttrHtmlType",setMap);
					if(StringUtil.checkNull(isHTML).equals("1")) cellValue = removeAllTag(cellValue,"DbToEx");
					
					cell = row.createCell(cellIndex);
					cell.setCellValue(cellValue);
					cell.setCellStyle(contentsStyle);
					cell.setCellType(XSSFCell.CELL_TYPE_STRING);
					sheet.autoSizeColumn(cellIndex);
					cellIndex++;
				}
				
				cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("LastUpdated"))); // 수정일
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("LastUser"))); // 최종 수정자
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    
			    rowIndex++;
			}
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			long date = System.currentTimeMillis();
			String itemName = StringUtil.checkNull(selectedItemMap.get("ItemName")).replace("/", "_");
			String selectedItemName1 = new String(itemName.getBytes("UTF-8"), "ISO-8859-1");
			String selectedItemName2 = new String(selectedItemName1.getBytes("8859_1"), "UTF-8");
			
			String orgFileName1 = "ITEMLIST_" + selectedItemName1 + "_" + formatter.format(date) + ".xlsx";
			String orgFileName2 = "ITEMLIST_" + selectedItemName2 + "_" + formatter.format(date) + ".xlsx";
			String downFile1 = FileUtil.FILE_EXPORT_DIR + orgFileName1;
			String downFile2 = FileUtil.FILE_EXPORT_DIR + orgFileName2;
			
			File file = new File(downFile2);
			fileOutput = new FileOutputStream(file);
			
			wb.write(fileOutput);
			
			target.put(AJAX_SCRIPT, "parent.doFileDown('"+orgFileName1+"', 'excel');parent.$('#isSubmit').remove();");
			
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			//target.put(AJAX_ALERT, " 저장중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		} finally {
			if(fileOutput != null) fileOutput.close();
			wb = null;
			
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);	
		
	}
	
	/**
	 * Process이외 Excel 출력
	 * @param request
	 * @param commandMap
	 * @param model
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/subItemMasterListExcel.do")
	public String subItemMasterListExcel(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception{
		
		HashMap target = new HashMap();
		HashMap setMap = new HashMap();
		FileOutputStream fileOutput = null;
		XSSFWorkbook wb = new XSSFWorkbook();
		
		try{
			String linefeedYN = StringUtil.checkNull(request.getParameter("linefeedYN"));
			/* arcCode [TB_ARC_FILTER_DIM] 존재 체크, 존재 하면 [TB_ITEM_DIM]에 존재 하는 아이템의 정보만 report로 출력 */
			String arcCode = StringUtil.checkNull(request.getParameter("ArcCode"));
			commandMap.put("ArcCode", arcCode);
			commandMap.put("SelectMenuId", arcCode);
			Map arcTreeFilterInfoMap =  commonService.select("report_SQL.getArcTreeFilterInfo", commandMap);	
			String TreeSql = StringUtil.checkNull(arcTreeFilterInfoMap.get("TreeSql"));
			commandMap.put("TreeSql", TreeSql);	
	    
			if(TreeSql != null && !"".equals(TreeSql))	{
				String outPutItems = getArcTreeIDs(commandMap);
				commandMap.put("outPutItems", outPutItems);
			}

			commandMap.put("sessionCurrLangType", commandMap.get("languageID"));
			List<Map> result = commonService.selectList("report_SQL.getItemStrList_gridList", commandMap);
			Map menu = getLabel(request, commonService);
			String attType = StringUtil.checkNull(commandMap.get("AttrTypeCode"));
			String attrName = StringUtil.checkNull(commandMap.get("AttrName"));
						
			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			String defaultLang = StringUtil.checkNull(commandMap.get("sessionDefLanguageId"));
			// 파일명에 이용할 Item Name 을 취득
			Map selectedItemMap = commonService.select("report_SQL.getItemInfo", commandMap);
			
			XSSFSheet sheet = wb.createSheet("process report");
			sheet.createFreezePane(3, 2); // 고정줄
			XSSFCellStyle headerStyle = setCellHeaderStyle(wb);
			XSSFCellStyle contentsStyle = setCellContentsStyle(wb, "");
		
			int cellIndex = 0;
			int rowIndex = 0;
			XSSFRow row = sheet.createRow(rowIndex);
			row.setHeight((short) (512 * ((double) 8 / 10 )));
			XSSFCell cell = null;
			rowIndex++;			
			// AttributeCode 행 설정
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
            /* AttributeCode 행 숨기기	*/
			row.setZeroHeight(true);  			
			/* ItemID 열  숨기기 */
			sheet.setColumnHidden(cellIndex, true);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			// 명칭
			cell = row.createCell(cellIndex);
			cell.setCellValue("AT00001");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			// 그외의 속성
			String[] attrNameArray = attrName.split("#");
			String[] attrTypeArray = attType.split("#");
			
			for (int i = 0; attrTypeArray.length > i ; i++) {
				cell = row.createCell(cellIndex);
				cell.setCellValue(attrTypeArray[i].replaceAll("&#39;", "").replaceAll("'",""));				
				cell.setCellStyle(headerStyle);
				cellIndex++;
			}
			
			// 수정일
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			// 최종 수정자
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			// Title 행 설정
			cellIndex = 0;   // cell index 초기화
			row = sheet.createRow(rowIndex);
			row.setHeight((short) 512);
			rowIndex++;
			/* ItemID */
			cell = row.createCell(cellIndex);
			cell.setCellValue("ItemID");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			/* 경로 */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00043")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			/* ID */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00106")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			/* 항목계층 */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00016")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			/* Name */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00028")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			// 속성 header 설정
			for (int i = 0; attrNameArray.length > i ; i++) {
				cell = row.createCell(cellIndex);
				cell.setCellValue(attrNameArray[i].replaceAll("&#39;", "").replaceAll("'", "").replace("&amp;", "&"));
				cell.setCellStyle(headerStyle);
				cellIndex++;
			}
			
			/* 수정일 */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00070")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			/* 최종 수정자 */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00105")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			String MyItemName = "";
			// Data 행 설정 
			for (int i=0; i < result.size();i++) {
				cellIndex = 0;   // cell index 초기화
				Map map = result.get(i);
			    row = sheet.createRow(rowIndex);
			    row.setHeight((short) (512 * ((double) 8 / 10 )));
			    if(linefeedYN.equals("Y")){ // linePeed 설정
			    	MyItemName = StringUtil.checkNull(map.get("MyItemName"));
			    }else{
			    	MyItemName = StringUtil.checkNull(map.get("MyItemName")).replaceAll("&#10;", "").replaceAll("&amp;", "&");
			    }
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("MyItemID"))); // MPM ID
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("MyPath"))); // 경로
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("Identifier"))); // ID
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("MyClassName"))); // 항목계층
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(MyItemName); // 명칭
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    
			    cell = row.createCell(cellIndex);
			    
				commandMap.put("ItemID", map.get("MyItemID"));
				commandMap.put("DefaultLang", defaultLang);
				
				String showInvisible = StringUtil.checkNull(request.getParameter("showInvisible"));
				commandMap.put("showInvisible",showInvisible);
				List attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
				String dataType = "";
				Map setData = new HashMap();
				List mLovList = new ArrayList();
				for (int j = 0; attrTypeArray.length > j ; j++) {
					String attrType = attrTypeArray[j].replaceAll("&#39;", "").replaceAll("'","");
					String cellValue = "";
					
					for (int k = 0; attrList.size()>k ; k++ ) {
						Map attrMap = (Map) attrList.get(k);
						dataType = StringUtil.checkNull(attrMap.get("DataType"));
						if (attrMap.get("AttrTypeCode").equals(attrType)) {
							String plainText = removeAllTag(StringUtil.checkNull(attrMap.get("PlainText")),"DbToEx");
							if(dataType.equals("MLOV")){								
								plainText = getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionDefLanguageId")), StringUtil.checkNull(map.get("MyItemID")), attrType);
								cellValue = plainText;
							}else{
								cellValue = plainText;
							}
						}
					}
					cell = row.createCell(cellIndex);
					cell.setCellValue(cellValue);
					cell.setCellStyle(contentsStyle);
					cell.setCellType(XSSFCell.CELL_TYPE_STRING);
					sheet.autoSizeColumn(cellIndex);
					cellIndex++;
					
				}
				
				cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("LastUpdated"))); // 수정일
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("LastUser"))); // 최종 수정자
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
				
			    rowIndex++;
			}
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			long date = System.currentTimeMillis();
			String itemName = StringUtil.checkNull(selectedItemMap.get("ItemName")).replace("/", "_");
			String selectedItemName1 = new String(itemName.getBytes("UTF-8"), "ISO-8859-1");
			String selectedItemName2 = new String(selectedItemName1.getBytes("8859_1"), "UTF-8");
			
			String orgFileName1 = "ITEMLIST_" + selectedItemName1 + "_" + formatter.format(date) + ".xlsx";
			String orgFileName2 = "ITEMLIST_" + selectedItemName2 + "_" + formatter.format(date) + ".xlsx";
			String downFile1 = FileUtil.FILE_EXPORT_DIR + orgFileName1;
			String downFile2 = FileUtil.FILE_EXPORT_DIR + orgFileName2;
			
			File file = new File(downFile2);
			fileOutput = new FileOutputStream(file);
			
			wb.write(fileOutput);
			
			HashMap drmInfoMap = new HashMap();
			
			String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
			String teamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
			String teamName = StringUtil.checkNull(commandMap.get("sessionTeamName"));
			
			drmInfoMap.put("userID", userID);
			drmInfoMap.put("userName", userName);
			drmInfoMap.put("teamID", teamID);
			drmInfoMap.put("teamName", teamName);
			drmInfoMap.put("orgFileName", orgFileName2);
			drmInfoMap.put("downFile", downFile2);
			drmInfoMap.put("loginID", commandMap.get("sessionLoginId"));
			drmInfoMap.put("sessionEmail", commandMap.get("sessionEmail"));
			
			// file DRM 적용
			String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
			String useDownDRM = StringUtil.checkNull(GlobalVal.DRM_DOWN_USE);
			if(!"".equals(useDRM) && !"N".equals(useDownDRM)){
				drmInfoMap.put("funcType", "report");
				DRMUtil.drmMgt(drmInfoMap); // 암호화 
			}

			target.put(AJAX_SCRIPT, "parent.doFileDown('"+orgFileName1+"', 'excel');parent.$('#isSubmit').remove();");
			
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			//target.put(AJAX_ALERT, " 저장중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		} finally {
			if(fileOutput != null) fileOutput.close();
			wb = null;
			
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);	
		
	}
	
	@RequestMapping(value="/downLoadItemMultiLanguageExcelReport.do")
	public String downLoadItemMultiLanguageExcelReport(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception{
		
		HashMap target = new HashMap();
		HashMap setMap = new HashMap();
		FileOutputStream fileOutput = null;
		XSSFWorkbook wb = new XSSFWorkbook();
		
		try{
			String linefeedYN = StringUtil.checkNull(request.getParameter("linefeedYN"));
			/* arcCode [TB_ARC_FILTER_DIM] 존재 체크, 존재 하면 [TB_ITEM_DIM]에 존재 하는 아이템의 정보만 report로 출력 */
			String arcCode = StringUtil.checkNull(request.getParameter("ArcCode"));
			commandMap.put("ArcCode", arcCode);
			commandMap.put("SelectMenuId", arcCode);
			Map arcFilterDimInfoMap =  commonService.select("report_SQL.getArcTreeFilterInfo", commandMap);	
			String TreeSql = StringUtil.checkNull(arcFilterDimInfoMap.get("TreeSql"));
			commandMap.put("TreeSql", TreeSql);	
	    
			if(TreeSql != null && !"".equals(TreeSql))	{
				String outPutItems = getArcTreeIDs(commandMap);
				commandMap.put("outPutItems", outPutItems);
			}
			
			commandMap.put("sessionCurrLangType", commandMap.get("languageID"));
			List<Map> result = commonService.selectList("report_SQL.getItemStrList_gridList", commandMap);
			Map menu = getLabel(request, commonService);
			String attType = StringUtil.checkNull(commandMap.get("AttrTypeCode"));
			String attrName = StringUtil.checkNull(commandMap.get("AttrName"));
			
			String selectLanguageID = StringUtil.checkNull(commandMap.get("selectLanguageID"));
			String sessionCurrLangCode = StringUtil.checkNull(commandMap.get("sessionCurrLangCode"));
			
			Map setData = new HashMap();
			setData.put("attrTypeCodes", attType);
			setData.put("LanguageID", selectLanguageID);
			setData.put("languageID", selectLanguageID);
			String selectLanguageCode = StringUtil.checkNull(commonService.selectString("common_SQL.getLanguageCode", setData));
			List selectLangAttrNameList = commonService.selectList("attr_SQL.getAttrName", setData);
			
			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			String defaultLang = StringUtil.checkNull(commandMap.get("sessionDefLanguageId"));
			// 파일명에 이용할 Item Name 을 취득
			Map selectedItemMap = commonService.select("report_SQL.getItemInfo", commandMap);
			
			XSSFSheet sheet = wb.createSheet("process report");
			sheet.createFreezePane(3, 2); // 고정줄
			XSSFCellStyle headerStyle = setCellHeaderStyle(wb);
			XSSFCellStyle contentsStyle = setCellContentsStyle(wb, "");
		
			int cellIndex = 0;
			int rowIndex = 0;
			XSSFRow row = sheet.createRow(rowIndex);
			row.setHeight((short) (512 * ((double) 8 / 10 )));
			XSSFCell cell = null;
			rowIndex++;
			
			// AttributeCode 행 설정
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			// 명칭
			cell = row.createCell(cellIndex);
			cell.setCellValue("AT00001");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			//selectLanguageID 명칭
			cell = row.createCell(cellIndex);
			cell.setCellValue("AT00001");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			// 그외의 속성
			String[] attrNameArray = attrName.split(",");
			String[] attrTypeArray = attType.split(",");
			
			for (int i = 0; attrTypeArray.length > i ; i++) {
							
				cell = row.createCell(cellIndex);
				cell.setCellValue(attrTypeArray[i].replaceAll("&#39;", "").replaceAll("'",""));				
				cell.setCellStyle(headerStyle);
				cellIndex++;
				
				cell = row.createCell(cellIndex);
				cell.setCellValue(attrTypeArray[i].replaceAll("&#39;", "").replaceAll("'",""));			
				cell.setCellStyle(headerStyle);
				cellIndex++;
			}
			
			// 수정일
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			// 최종 수정자
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			// Title 행 설정
			cellIndex = 0;   // cell index 초기화
			row = sheet.createRow(rowIndex);
			row.setHeight((short) 512);
			rowIndex++;
			/* ItemID */
			cell = row.createCell(cellIndex);
			cell.setCellValue("ItemID");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			/* 경로 */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00043")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			/* ID */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00106")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			/* 항목계층 */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00016")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			/* Name */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00028"))+"("+sessionCurrLangCode+")");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			/* SelectLanguageID Name */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00028"))+"("+selectLanguageCode+")");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			// 속성 header 설정
			for (int i = 0; attrNameArray.length > i ; i++) {			
				
				cell = row.createCell(cellIndex);
				cell.setCellValue(attrNameArray[i].replaceAll("&#39;", "").replaceAll("'", "")+"("+sessionCurrLangCode+")");
				cell.setCellStyle(headerStyle);
				cellIndex++;
				
				setData = new HashMap();
				setData.put("languageID", selectLanguageID);
				setData.put("typeCode", attrTypeArray[i].replaceAll("'", ""));
				setData.put("category", "AT");
				String selectLanguageAttrTypeName = StringUtil.checkNull(commonService.selectString("common_SQL.getNameFromDic", setData));
				
				cell = row.createCell(cellIndex);
				cell.setCellValue(selectLanguageAttrTypeName+"("+selectLanguageCode+")");				
				cell.setCellStyle(headerStyle);
				cellIndex++;
			}
			
			/* 수정일 */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00070")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			/* 최종 수정자 */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00105")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			String MyItemName = "";
			// Data 행 설정 
			for (int i=0; i < result.size();i++) {
				cellIndex = 0;   // cell index 초기화
				Map map = result.get(i);
			    row = sheet.createRow(rowIndex);
			    row.setHeight((short) (512 * ((double) 8 / 10 )));
			   
			    MyItemName = StringUtil.checkNull(map.get("MyItemName")).replaceAll("&#10;", "").replaceAll("&amp;", "&");
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("MyItemID"))); // MPM ID
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("MyPath"))); // 경로
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("Identifier"))); // ID
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("MyClassName"))); // 항목계층
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			   
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(MyItemName); // 명칭
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    
			    
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("SelectLanguageMyItemName")).replaceAll("&#10;", "").replaceAll("&amp;", "&")); // SelectedLanguage 명칭
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    
			    cell = row.createCell(cellIndex);
			    
				commandMap.put("ItemID", map.get("MyItemID"));
				commandMap.put("DefaultLang", defaultLang);
				
				List attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
				String dataType = "";
				setData = new HashMap();
				List mLovList = new ArrayList();
				for (int j = 0; attrTypeArray.length > j ; j++) {
					String attrType = attrTypeArray[j].replaceAll("&#39;", "").replaceAll("'","");
					String cellValue = ""; String cellValue2 = "";
					
					for (int k = 0; attrList.size()>k ; k++ ) {
						Map attrMap = (Map) attrList.get(k);
						dataType = StringUtil.checkNull(attrMap.get("DataType"));
						if (attrMap.get("AttrTypeCode").equals(attrType)) {
							String plainText = removeAllTag(StringUtil.checkNull(attrMap.get("PlainText")),"DbToEx");
							String plainText2 = removeAllTag(StringUtil.checkNull(attrMap.get("PlainText2")),"DbToEx");
							if(dataType.equals("MLOV")){								
								plainText = getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionDefLanguageId")), StringUtil.checkNull(map.get("MyItemID")), attrType);
								plainText2 = getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionDefLanguageId")), StringUtil.checkNull(map.get("MyItemID")), attrType);
								cellValue = plainText; cellValue2 = plainText2;
							}else{
								cellValue = plainText;  cellValue2 = plainText2;
							}
						}
					}
					cell = row.createCell(cellIndex);
					cell.setCellValue(cellValue);
					cell.setCellStyle(contentsStyle);
					cell.setCellType(XSSFCell.CELL_TYPE_STRING);
					sheet.autoSizeColumn(cellIndex);
					cellIndex++;
					
					cell = row.createCell(cellIndex);
					cell.setCellValue(cellValue2);
					cell.setCellStyle(contentsStyle);
					cell.setCellType(XSSFCell.CELL_TYPE_STRING);
					sheet.autoSizeColumn(cellIndex);
					cellIndex++;
					
				}
				
				cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("LastUpdated"))); // 수정일
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("LastUser"))); // 최종 수정자
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
				
			    rowIndex++;
			}
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			long date = System.currentTimeMillis();
			String itemName = StringUtil.checkNull(selectedItemMap.get("ItemName")).replace("/", "_");
			String selectedItemName1 = new String(itemName.getBytes("UTF-8"), "ISO-8859-1");
			String selectedItemName2 = new String(selectedItemName1.getBytes("8859_1"), "UTF-8");
			
			String orgFileName1 = "ITEMLIST_" + selectedItemName1 + "_" + formatter.format(date) + ".xlsx";
			String orgFileName2 = "ITEMLIST_" + selectedItemName2 + "_" + formatter.format(date) + ".xlsx";
			String downFile1 = FileUtil.FILE_EXPORT_DIR + orgFileName1;
			String downFile2 = FileUtil.FILE_EXPORT_DIR + orgFileName2;
			
			File file = new File(downFile2);
			fileOutput = new FileOutputStream(file);
			
			wb.write(fileOutput);
			
			HashMap drmInfoMap = new HashMap();
			
			String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
			String teamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
			String teamName = StringUtil.checkNull(commandMap.get("sessionTeamName"));
			
			drmInfoMap.put("userID", userID);
			drmInfoMap.put("userName", userName);
			drmInfoMap.put("teamID", teamID);
			drmInfoMap.put("teamName", teamName);
			drmInfoMap.put("orgFileName", orgFileName2);
			drmInfoMap.put("downFile", downFile2);
			
			// file DRM 적용
			String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
			String useDownDRM = StringUtil.checkNull(GlobalVal.DRM_DOWN_USE);
			if(!"".equals(useDRM) && !"N".equals(useDownDRM)){
				drmInfoMap.put("funcType", "report");
				DRMUtil.drmMgt(drmInfoMap); // 암호화 
			}
			target.put(AJAX_SCRIPT, "parent.doFileDown('"+orgFileName1+"', 'excel');parent.$('#isSubmit').remove();");
			
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		} finally {
			if(fileOutput != null) fileOutput.close();
			wb = null;
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);	
		
	}
	
	/**
	 * Process이외 Excel 출력
	 * @param request
	 * @param commandMap
	 * @param model
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/cNListReportExcel.do")
	public String cNListReportExcel(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception{

		HashMap target = new HashMap();
		HashMap setMap = new HashMap();

		String url= "/report/downloadCNList";	
		try{
			List<Map> result = commonService.selectList("report_SQL.selectCNItemList", commandMap);
			Map menu = getLabel(request, commonService);
			String attType = StringUtil.checkNull(commandMap.get("AttrTypeCode")); 
			String attrName = StringUtil.checkNull(commandMap.get("AttrName"));
		
			List<String> attrCodeList = new ArrayList<>();
			List<String> attrNameList = new ArrayList<>();
			

			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", commandMap);
			String selectedLang = StringUtil.checkNull(commandMap.get("languageID"));
			// 파일명에 이용할 Item Name 을 취득
			Map selectedItemMap = commonService.select("report_SQL.getItemInfo", commandMap);
			
			/* SQL에 넘겨줄 선택된 속성 코드를 ArrayList에 담음 */
			// 각 속성의 IsComLang 취득
			List comLangList = null;
			Map comLangMap = new HashMap();
			if(!attType.equals("")){
				commandMap.put("attType", attType);
				comLangList = commonService.selectList("report_SQL.getAttrIsComLang", commandMap);
				for (int i = 0; comLangList.size() > i ; i++) {
					Map map = (Map) comLangList.get(i);
					comLangMap.put(map.get("AttrTypeCode"), map.get("IsComLang"));
				}
			}
			
			String[] attrTypeArray = null;
			if(!attType.equals("")){
				attrTypeArray = attType.split(",");
			
				List attrTypeArrayList = new ArrayList();
				Map attrTypeArrayMap = new HashMap();
				
				for (int i = 0; attrTypeArray.length > i ; i++) {
					attrTypeArrayMap = new HashMap();
					attrTypeArrayMap.put("TableName", "T" + String.valueOf(i + 10));
					attrTypeArrayMap.put("AttrNum", attrTypeArray[i].replace("'", ""));
					if ("1".equals(comLangMap.get(attrTypeArray[i].replace("'", "")).toString())) {
						attrTypeArrayMap.put("LangCode", defaultLang);
					} else {
						attrTypeArrayMap.put("LangCode", selectedLang);
					}
					attrTypeArrayList.add(attrTypeArrayMap);
				}
				
				commandMap.put("attrList", attrTypeArrayList);
			}
			
			
			// 화면에서 선택한 속성	  => AT01000
			if(!attType.equals("")){
				for (int i = 0; attrTypeArray.length > i ; i++) {
		
						attrCodeList.add(attrTypeArray[i].replace("'", ""));
				}
			}
			
			
			// 그외의 속성  필수/선택
			String[] attrNameArray = null;
			if(!attrName.equals("")){	
				attrNameArray = attrName.split(",");
				for (int i = 0; attrNameArray.length > i ; i++) {
					attrNameList.add(attrNameArray[i].replace("'", ""));
			
				}
			}
						
			// Data 행 설정
			for (int i=0; i < result.size();i++) {
				Map map = result.get(i);
				commandMap.put("ItemID", map.get("ConnctionID"));//ConnctionID
				commandMap.put("DefaultLang", defaultLang);
				
				List attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);				
				if(!attType.equals("")){
					for (int j = 0; attrTypeArray.length > j ; j++) {
						String attrType = attrTypeArray[j].replace("'", "");
						String cellValue = "";
						
						for (int k = 0; attrList.size()>k ; k++ ) {
							Map attrMap = (Map) attrList.get(k);
							if (attrMap.get("AttrTypeCode").equals(attrType)) {
								String plainText = removeAllTag(StringUtil.checkNullToBlank(attrMap.get("PlainText")));// 필수
								cellValue = plainText;
							}
						}
					      // result 의 map 에 새로운 값 추가
			            map.put(attrType, cellValue);
					}
				}

			}
			JSONArray excelGridData = new JSONArray(result);
			JSONArray codeJson = new JSONArray(attrCodeList);
			JSONArray nameJson = new JSONArray(attrNameList);  

			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			long date = System.currentTimeMillis();
			String itemName = StringUtil.checkNull(selectedItemMap.get("ItemName")).replace("/", "_");

			String orgFileName1 = itemName + "_" + formatter.format(date);

			target.put(AJAX_SCRIPT, "parent.doFileDown('"+excelGridData+"', '"+codeJson+"', '"+nameJson+"', '"+orgFileName1+"' );parent.$('#isSubmit').remove();");
			model.addAttribute(AJAX_RESULTMAP, target);
			
			
		} catch(Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(AJAXPAGE);	
		//return nextUrl(url);
	
	}
	
	// 매핑 항목 카운트 
	@RequestMapping(value = "/downloadCNCount.do")
	public String downloadCNCount(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		Map reqMap = new HashMap();

		String url = "/report/downloadCNCount";
		List toItemList = new ArrayList();
		List attrLovList = new ArrayList();
		String attrTypeName = "";		
		
		try {				
				String filepath = request.getSession().getServletContext().getRealPath("/");
				String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), ""); 
				String cNType = StringUtil.checkNull(request.getParameter("itemTypeCode"), ""); 
				String itemClassCode = StringUtil.checkNull(request.getParameter("itemClassCode"), ""); 
				String attrTypeCode = StringUtil.checkNull(request.getParameter("attrTypeCode"), ""); 
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"), "");
				String searchKey = StringUtil.checkNull(request.getParameter("searchKey"), ""); 
				String searchValue = StringUtil.checkNull(request.getParameter("searchValue"), ""); 
				String treeItemTypeCode = StringUtil.checkNull(request.getParameter("treeItemTypeCode"), ""); 
				
				setMap.put("itemID", s_itemID);
				setMap.put("languageID", languageID);
				setMap.put("itemClassCode", itemClassCode);
				setMap.put("attrTypeCode", attrTypeCode);
				setMap.put("cNType", cNType);
				setMap.put("searchKey", searchKey);
				setMap.put("searchValue", searchValue);
				setMap.put("typeCode", treeItemTypeCode);
				
				String childItems = getChildItemList(s_itemID);
				String isNothingLowLank = "";
				if (childItems.isEmpty()) {
					isNothingLowLank = "Y";
				}
				
				setMap.put("childItems", childItems);
				setMap.put("isNothingLowLank", isNothingLowLank);
				toItemList = commonService.selectList("report_SQL.getToItemList", setMap);
				
				if(!attrTypeCode.isEmpty()){
					attrLovList = commonService.selectList("report_SQL.selectAttrLovList", setMap);//[{LovCode=LV100001, Value=필수}, {LovCode=LV100002, Value=선택}]
					attrTypeName = commonService.selectString("report_SQL.getAttrName", setMap);// 필수/선택
				}
				String treeItemTypeName = commonService.selectString("common_SQL.getNameFromDic", setMap); //Process
				Map fromToItemName = commonService.select("report_SQL.getFromToItemName", setMap); //{FromItemType=Process, ToItemType=Dimension}
				
				String relatedItemTypeName = "";
				if(!treeItemTypeName.equals(StringUtil.checkNull(fromToItemName.get("FromItemType")))){
					relatedItemTypeName =  StringUtil.checkNull(fromToItemName.get("FromItemType"));
				}else{
					relatedItemTypeName =  StringUtil.checkNull(fromToItemName.get("ToItemType"));//Dimension 헤더값 
				}

				List<Map<String, String>> toItemResultList = new ArrayList<Map<String, String>>();
				toItemResultList = setCNCountXmlData(filepath, toItemList, attrLovList, languageID,  request);
		      

				JSONArray gridData = new JSONArray(toItemResultList);
				model.put("gridData",gridData);
				
				JSONArray gridHeadData = new JSONArray(attrLovList);
				model.put("gridHeadData", gridHeadData);
	

				model.put("treeItemTypeCode", treeItemTypeCode);
				model.put("treeItemTypeName", treeItemTypeName);
				model.put("relatedItemTypeName", relatedItemTypeName);
				model.put("lovSize", attrLovList.size());
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				
				model.put("s_itemID", s_itemID);	
				model.put("CNTypeCode", cNType);	
				model.put("itemClassCode", itemClassCode);	
				model.put("attrTypeCode", attrTypeCode);	
				model.put("totalCnt", toItemList.size());
				 
		} catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl(url);
	}
	
	private String getChildItemList(String s_itemID) throws Exception {
		String outPutItems = "";
		List subTreeItemIdList = new ArrayList();
		List list = new ArrayList();
		Map map = new HashMap();
		Map setMap = new HashMap();
		
		String itemId = s_itemID;
		setMap.put("ItemID", itemId);

		
		// 취득한 아이템 리스트 사이즈가 0이면 while문을 빠져나간다.
		int j = 1;
		while (j != 0) { 
			String toItemId = "";
			
			setMap.put("CURRENT_ITEM", itemId); // 해당 아이템이 [FromItemID]인것
			setMap.put("CategoryCode", "ST1");
			//setMap.put("CategoryCodes", "'ST1','ST2'");
			list = commonService.selectList("report_SQL.getChildItems", setMap);
			j = list.size();
			for (int k = 0; list.size() > k; k++) {
				 map = (Map) list.get(k);
				 setMap.put("ItemID", map.get("ToItemID"));
				 subTreeItemIdList.add(map.get("ToItemID"));
				 
				 if (k == 0) {
					 toItemId = "'" + String.valueOf(map.get("ToItemID")) + "'";
				 } else {
					 toItemId = toItemId + ",'" + String.valueOf(map.get("ToItemID")) + "'";
				 }
			}
			
			itemId = toItemId; // ToItemID를 다음 ItemID로 설정
		}
		
		outPutItems = "";
		for (int i = 0; subTreeItemIdList.size() > i ; i++) {
			
			if (outPutItems.isEmpty()) {
				outPutItems += subTreeItemIdList.get(i);
			} else {
				outPutItems += "," + subTreeItemIdList.get(i);
			}
		}
		return outPutItems;
	}

private List<Map<String, String>> setCNCountXmlData(String filepath, List toItemList, List attrLovList, String langaugeID, HttpServletRequest request ) throws Exception {        Map setMap = new HashMap();
        
    	List<Map<String, String>> toItemResultList = new ArrayList<Map<String, String>>();
		Map<String, Integer> countMap = new HashMap<String, Integer>();
		
		String attrTypeCode =  StringUtil.checkNull(request.getParameter("attrTypeCode"), "");//AT01000
		String cNType =  StringUtil.checkNull(request.getParameter("itemTypeCode"), ""); 	//CN00110	
		setMap.put("attrTypeCode", attrTypeCode);
		setMap.put("cNType", cNType);
		
		String attrDataType = ""; 
		if(!attrTypeCode.equals("")){
			attrDataType = commonService.selectString("report_SQL.getAttrDataType", setMap);//lov
		}
    	// 하위항목 List
        for (int i = 0; i < toItemList.size(); i++) {
        	Map<String, String> rowMap = new HashMap<String, String>();
        	Map toItemMap = (Map) toItemList.get(i);
        	
        	String identifier = String.valueOf(toItemMap.get("Identifier"));
        	String itemID = String.valueOf(toItemMap.get("ItemID"));
        	String itemName = String.valueOf(toItemMap.get("ItemName"));
        	String path = String.valueOf(toItemMap.get("Path"));
        	
        	rowMap.put("identifier", identifier);
        	rowMap.put("itemName", itemName);
        	rowMap.put("path", path);
        	rowMap.put("itemID", itemID);
        	
        	toItemResultList.add(rowMap);
        }
   
	    for (int i = 0; i < toItemResultList.size(); i++) {

	        
	        Map<String, String> toItemRowMap = toItemResultList.get(i);
	        
	
	        String attrCnt;	     
	        int alocationTotal = 0;
	        if(attrDataType.equals("LOV")){
				for(int j=0; j<attrLovList.size(); j++){
					Map lovMap = (Map) attrLovList.get(j);
					setMap.put("lovCode", lovMap.get("LovCode"));
					setMap.put("itemID", toItemRowMap.get("itemID"));
					setMap.put("languageID", langaugeID);
					setMap.put("cNType", cNType);
					attrCnt = commonService.selectString("report_SQL.getLovCount", setMap);  // 각 lov count
					String lovAttrCode = StringUtil.checkNull(lovMap.get("LovCode"));
					toItemRowMap.put(lovAttrCode, attrCnt);

			        alocationTotal = alocationTotal +Integer.parseInt(attrCnt);
				}
				
		        
				setMap.remove("lovCode");
				setMap.put("itemID", toItemRowMap.get("itemID"));
				setMap.put("languageID", langaugeID);
				setMap.put("cNType", cNType);
				attrCnt = commonService.selectString("report_SQL.getLovCount", setMap); // attr 개수
				String total = attrCnt;
				toItemRowMap.put("NA", StringUtil.checkNull(Integer.parseInt(attrCnt) - alocationTotal));
				toItemRowMap.put("total", total);

			}else{
				setMap.remove("lovCode");
				setMap.put("itemID", toItemRowMap.get("itemID"));
				setMap.put("languageID", langaugeID);
				setMap.put("cNType", cNType);
				attrCnt = commonService.selectString("report_SQL.getConnCount", setMap); //total 
				toItemRowMap.put("total", attrCnt);

			}
	       
	    }
	   
	    
	    return toItemResultList;
	}
	/**
	 * Dim tree SQL의 모든 Dimension nodeID를 취득
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	private String getArcTreeIDs(HashMap commandMap) throws Exception {
		String result = "";
		String TreeSql = StringUtil.checkNull(commandMap.get("TreeSql"));
		
		List arcTreeIdList = commonService.selectList(TreeSql, commandMap);
		
		for (int i = 0; arcTreeIdList.size() > i ; i++) {
			Map map = (Map) arcTreeIdList.get(i);
			String treeId = String.valueOf(map.get("TREE_ID"));
			if (result.isEmpty()) {
				result = treeId;
			} else {
				result = result + "," + treeId;
			}
		}
		
		return result;
	}
	
	/**
	 * 넘어온 아이템들의  하위 항목 취득 (해당 아이템이 [TB_ITEM_DIM]에 존재 할 경우 리턴 리스트에 아이템 추가)
	 * @param arrayStr
	 * @param arcFilterDimInfoMap
	 * @throws Exception
	 */
	private String getChildItemList(String[] arrayStr, Map arcFilterDimInfoMap, String s_itemID) throws Exception {
		String outPutItems = "";
		List delItemIdList = new ArrayList();
		List list = new ArrayList();
		Map map = new HashMap();
		Map setMap = new HashMap();
		
		// 메뉴에서 선택된 dimension 정보를 설정
		setMap.put("DimTypeID", arcFilterDimInfoMap.get("DimTypeID"));
		setMap.put("DimValueID", arcFilterDimInfoMap.get("DefDimValueID"));
		
		for (int i = 0; i < arrayStr.length; i++) {
			String itemId = arrayStr[i];
			setMap.put("ItemID", itemId);
			// TODO : 임시로 TB_ITEM_DIM_TREE 테이블에 존재 여부를 확인 안함
			 // 모델에서 아이템 추가, 삭제, 이동시 DimTree테이블과 통기화 안되어 있는 문제 때문!!!!
			//if (!"0".equals(commonService.selectString("report_SQL.isExistAtDimTree", setMap))) {
				delItemIdList.add(itemId);
			//}
			
			// 취득한 아이템 리스트 사이즈가 0이면 while문을 빠져나간다.
			int j = 1;
			while (j != 0) { 
				String toItemId = "";
				
				setMap.put("CURRENT_ITEM", itemId); // 해당 아이템이 [FromItemID]인것
				setMap.put("CategoryCode", "ST1");
				list = commonService.selectList("report_SQL.getChildItems", setMap);
				j = list.size();
				for (int k = 0; list.size() > k; k++) {
					 map = (Map) list.get(k);
					 setMap.put("ItemID", map.get("ToItemID"));
					 // TODO : 임시로 TB_ITEM_DIM_TREE 테이블에 존재 여부를 확인 안함
					 // 모델에서 아이템 추가, 삭제, 이동시 DimTree테이블과 통기화 안되어 있는 문제 때문!!!!
					 //if (!"0".equals(commonService.selectString("report_SQL.isExistAtDimTree", setMap))) {
					 	delItemIdList.add(map.get("ToItemID"));
					 //}
					 if (k == 0) {
						 toItemId = "'" + String.valueOf(map.get("ToItemID")) + "'";
					 } else {
						 toItemId = toItemId + ",'" + String.valueOf(map.get("ToItemID")) + "'";
					 }
				}
				
				itemId = toItemId; // ToItemID를 다음 ItemID로 설정
			}
			
		}
		
		outPutItems = s_itemID;
		for (int i = 0; delItemIdList.size() > i ; i++) {
			outPutItems += "," + delItemIdList.get(i);
		}
		
		return outPutItems;
	}
		
	/**
	 * 선택된 아이템과 하위항목을 모두 삭제
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/delLowLankItem.do")
	public String delLowLankItem(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		HashMap target = new HashMap();
		
		try{
			// 선택된 아이템 아이디
			String itemId = StringUtil.checkNull(request.getParameter("itemID"));
			String returnItem = GetItemAttrList.delItem(commonService, itemId);
		
			if(returnItem.equals("N")){
				target.put(AJAX_ALERT, itemId+""+MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00148")); // 삭제 할수 없는 아이템이 있습니다.(은(는) 사용 중으로 삭제할 수 없습니다.) 
			}else{
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제 성공
				if (StringUtil.checkNull(request.getParameter("kbn")).isEmpty()) {
					target.put(AJAX_SCRIPT, "window.opener.urlReload();this.$('#isSubmit').remove();");
				} else {
					target.put(AJAX_SCRIPT, "parent.fnRefreshTree('"+ returnItem +"',true);	parent.fnGetItemClassMenuURL('"+ returnItem +"');this.$('#isSubmit').remove();");
				}
			}
			
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // 오류 발생
		} 
		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);	
		
	}
	
	@RequestMapping(value="/delSubItemMasterList.do")
	public String delSubItemMasterList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		HashMap target = new HashMap();
		
		try{
			// 선택된 아이템 아이디
			String itemId = StringUtil.checkNull(request.getParameter("itemID"));
			String scrnType = StringUtil.checkNull(request.getParameter("scrnType"));
			String returnItem = GetItemAttrList.delItem(commonService, itemId);
		
			if(returnItem.equals("N")){
				target.put(AJAX_ALERT, itemId+""+MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00148")); // 삭제 할수 없는 아이템이 있습니다.(은(는) 사용 중으로 삭제할 수 없습니다.) 
				target.put(AJAX_SCRIPT, "this.doCallBack(); this.$('#isSubmit').remove();");
			}else{
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제 성공
				if (StringUtil.checkNull(request.getParameter("kbn")).isEmpty()) {
					target.put(AJAX_SCRIPT, "window.opener.urlReload();this.$('#isSubmit').remove();");
				} else if(scrnType.equals("pop")) {
					target.put(AJAX_SCRIPT, "this.doCallBack(); this.$('#isSubmit').remove();");
				} else {
					target.put(AJAX_SCRIPT, "parent.fnRefreshTree('"+ returnItem +"',true);	parent.fnGetItemClassMenuURL('"+ returnItem +"');this.$('#isSubmit').remove();");
				}
			}
			
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // 오류 발생
		} 
		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);	
		
	}
	
	private XSSFCellStyle setCellHeaderStyle(XSSFWorkbook wb) {
		XSSFCellStyle style = wb.createCellStyle();
		 
		style.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		style.setBottomBorderColor(IndexedColors.GREY_80_PERCENT.getIndex());
		style.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		style.setLeftBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
		style.setBorderRight(XSSFCellStyle.BORDER_THIN);
		style.setRightBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
		style.setBorderTop(XSSFCellStyle.BORDER_THIN);
		style.setTopBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
		style.setAlignment(HorizontalAlignment.CENTER);
		style.setVerticalAlignment(VerticalAlignment.CENTER);
		
		style.setFillForegroundColor(HSSFColor.PALE_BLUE.index);
		style.setFillBackgroundColor(HSSFColor.PALE_BLUE.index);
		style.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		
		XSSFFont font = wb.createFont();
		font.setFontHeightInPoints((short) 9);
		font.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
		font.setFontName("Arial");
		
		style.setFont(font);
		 
		return style;

	}
	
	private XSSFCellStyle setCellContentsStyle(XSSFWorkbook wb, String color) {
		XSSFCellStyle style = wb.createCellStyle();
		 
		style.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		style.setBottomBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
		style.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		style.setLeftBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
		style.setBorderRight(XSSFCellStyle.BORDER_THIN);
		style.setRightBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
		style.setBorderTop(XSSFCellStyle.BORDER_THIN);
		style.setTopBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
		style.setVerticalAlignment(VerticalAlignment.CENTER);
		
		if(color.equals("LIGHT_BLUE")){
			style.setFillBackgroundColor(HSSFColor.LIGHT_BLUE.index);
			style.setFillForegroundColor(HSSFColor.LIGHT_BLUE.index);
			style.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		}else if(color.equals("LIGHT_CORNFLOWER_BLUE")){
			style.setFillBackgroundColor(HSSFColor.LIGHT_CORNFLOWER_BLUE.index);
			style.setFillForegroundColor(HSSFColor.LIGHT_CORNFLOWER_BLUE.index);
			style.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		}else if(color.equals("LIGHT_GREEN")){ 
			style.setFillBackgroundColor(HSSFColor.LIGHT_GREEN.index);
			style.setFillForegroundColor(HSSFColor.LIGHT_GREEN.index);
			style.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		}
		
		XSSFFont font = wb.createFont();
		font.setFontHeightInPoints((short) 10);
		font.setFontName("Arial");
		
		style.setFont(font);
		 
		return style;

	}
	
	/**
	 * 디멘션 리포트 출력 화면
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dimensionReport.do")
	public String dimensionReport(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		

		
		List itemTypeCodeList = commonService.selectList("report_SQL.getItemTypeCodeFromItemDim", commandMap);
		

		model.put("dimTypeID", request.getParameter("itemID"));		
		model.put("itemTypeCodeList", itemTypeCodeList);
		model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
		
	
		

		return nextUrl("/report/dimensionReport");
	}
	
	/**
	 * ITEM_DIM 테이블에 존재하는  ItemTypeCode별 Dimension 정보를 취득 
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getDimensionInfo.do")
	public String getDimensionInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		try{
			Map resultMap = new HashMap();
			
			String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"));
			String dimTypeID = StringUtil.checkNull(request.getParameter("dimTypeID"));
			commandMap.put("ItemTypeCode", itemTypeCode);
			commandMap.put("DimTypeID", dimTypeID);
			List dimInfoList = commonService.selectList("report_SQL.getDimInfoWithItemTypeCode", commandMap);
			
			String dimValueName = "";
			String dimValueId = "";
			
			for (int i = 0; i < dimInfoList.size() ; i++) {
				Map map = (Map) dimInfoList.get(i);
				if (i == 0) {
					dimValueId = StringUtil.checkNull(map.get("DimValueID"));
				} else {
					dimValueId = dimValueId + "," +StringUtil.checkNull(map.get("DimValueID"));
				}
				
				dimValueName = dimValueName + "," +StringUtil.checkNull(map.get("DimValueName"));
			}
			
			resultMap.put(AJAX_SCRIPT, "doSearchList('"+dimValueName+"', '"+dimValueId+"',"+dimInfoList.size()+")");
			model.addAttribute(AJAX_RESULTMAP,resultMap);
		}catch (Exception e){
			System.out.println(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}
	
	/**
	 * 디멘션 리포트에 출력 할 데이터 설정
	 * @param commandMap
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value="/dimensionReportGridJson.do")
	public void dimensionReportGridJson(HashMap cmmMap, HttpServletResponse response) throws Exception{
		response.setHeader("Cache-Control", "no-cache");
		response.setContentType("text/plain");
		response.setCharacterEncoding("UTF-8");
		
		
		List <Map>list = new ArrayList();
		Map jsonMap = new HashMap();
		int rnum = 1;
		int dimIdCnt = 1;
		String codeId = "";
		
		

		String[] dimValueIds = StringUtil.checkNull(cmmMap.get("ID")).replaceAll("'", "").split(",");//[70, 71, 72]
		


		try {			
			String SQL_CODE = getString(cmmMap.get("sqlID"), "commonCode");	
					
			String tFilterCode = StringUtil.checkNull(cmmMap.get("tFilterCode"));
			String sqlGridList = StringUtil.checkNull(cmmMap.get("sqlGridList"));
			

			
			System.out.println("jsonDhtmlxList cmmMap :"+cmmMap);
			if(!"".equals(tFilterCode)) {
				SQL_CODE=StringUtil.checkNull(commonService.selectString("menu_SQL.getSqlNameForTfilterCode", cmmMap));
			}
			
			String sqlCode = "";
			if(sqlGridList.equals("N")) sqlCode = SQL_CODE; else sqlCode = SQL_CODE+SQL_GRID_LIST;
			List <Map>result = commonService.selectList(sqlCode, cmmMap);
			
			
			for (Map dimValueProcessInfoMap : result) {
				if (codeId.isEmpty()) {
					codeId = String.valueOf(dimValueProcessInfoMap.get("CodeID"));
					jsonMap = new HashMap();
				} else {
					if (!codeId.equals(String.valueOf(dimValueProcessInfoMap.get("CodeID")))) {
						list.add(jsonMap);
						rnum++;
						codeId = String.valueOf(dimValueProcessInfoMap.get("CodeID"));
						jsonMap = new HashMap();
					}
				}
				
				jsonMap.put("RNUM", rnum);
				jsonMap.put("Identifier", dimValueProcessInfoMap.get("Identifier"));
				jsonMap.put("ItemName", dimValueProcessInfoMap.get("ItemName"));
				jsonMap.put("Path", dimValueProcessInfoMap.get("Path"));
				jsonMap.put("ClassName", dimValueProcessInfoMap.get("ClassName"));
				for (int i = 0 ; i < dimValueIds.length ; i++) {
					if (dimValueIds[i].equals(dimValueProcessInfoMap.get("DimValueID"))) {
						jsonMap.put("DimValueName" + String.valueOf(i+1), "true");
					}
				}
				
			}
			
			list.add(jsonMap);
			
			
			
			
			JSONArray resultJosnList = new JSONArray(list);

			response.getWriter().print(resultJosnList);
		} catch (Exception e) {
			System.out.println(e.toString());
		}
	}
		
	/**
	 * wordReport 출력
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/wordReport.do")
	public String wordReport(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception{
		Map target = new HashMap();
		// client별 word report url 설정
		String url= "/custom/base/report/wordExport_base";
		if(!StringUtil.checkNull(commandMap.get("URL")).equals("")){ url = "/"+ StringUtil.checkNull(commandMap.get("URL")); }
		try{
			Map setMap = new HashMap();
			String languageId = String.valueOf(commandMap.get("sessionCurrLangType"));
			String delItemsYN = StringUtil.checkNull(commandMap.get("delItemsYN"));
			setMap.put("languageID", languageId);
			setMap.put("langCode", StringUtil.checkNull(commandMap.get("sessionCurrLangCode")).toUpperCase());
			setMap.put("s_itemID", request.getParameter("s_itemID"));
			setMap.put("ArcCode", request.getParameter("ArcCode"));
			setMap.put("delItemsYN", delItemsYN);
			
			// 파일명에 이용할 Item Name 을 취득
			Map selectedItemMap = commonService.select("report_SQL.getItemInfo", setMap);
			
			/* 첨부 문서 취득 */
			setMap.put("DocumentID", request.getParameter("s_itemID"));
			setMap.put("DocCategory", "ITM");
			List L2AttachFileList = commonService.selectList("fileMgt_SQL.getFile_gridList", setMap);
			// 로그인 언어별 default font 취득
			String defaultFont = commonService.selectString("report_SQL.getDefaultFont", setMap);			
			
			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", commandMap);			
			List modelList = new ArrayList();
			List totalList = new ArrayList();
			
			List allTotalList = new ArrayList();
			Map allTotalMap = new HashMap();
			Map titleItemMap = new HashMap();
			String e2eModelId = "";
			Map e2eModelMap = new HashMap();
			List subTreeItemIDList = new ArrayList();
			String selectedItemPath = "";
			Map e2eAttrMap = new HashMap();
			Map e2eAttrNameMap = new HashMap();
			Map e2eAttrHtmlMap = new HashMap();
			List e2eDimResultList = new ArrayList();
			
			Map piAttrMap = new HashMap();
			Map piAttrNameMap = new HashMap();
			Map piAttrHtmlMap = new HashMap();
			
			String reportCode = StringUtil.checkNull(commandMap.get("reportCode"));
			String classCode = commonService.selectString("report_SQL.getItemClassCode", setMap);
			List rptAllocClassList = commonService.selectList("report_SQL.getRptAllocatedClass", commandMap);
			Map e2eClassMap = new HashMap();
			Map piClassMap = new HashMap();
			
			List L2SubItemInfoList = new ArrayList();
				
			if(rptAllocClassList.size() > 0){			
				for (int i = 0; rptAllocClassList.size() > i; i++) {
					Map map = (Map) rptAllocClassList.get(i);
					if(classCode.equals("CL01008") || classCode.equals("CL01009")){ // get E2E allocation Report List	
						e2eClassMap.put(map.get("ClassCode"), map.get("ClassCode"));
					}else if(reportCode.equals("RP00031")){ // get PI allocation Report List	
						piClassMap.put(map.get("ClassCode"), map.get("ClassCode"));
					}
				}
			}
			
			if (e2eClassMap.containsKey(classCode)) {// E2E				
				/* Model 정보 취득 */
				setMap.put("ModelTypeCode", "MT002");
				e2eModelMap = commonService.select("report_SQL.getModelIdAndSize", setMap);
				
				/** 선택된 Item의 Path취득 (Id + Name) */
				selectedItemPath = commonService.selectString("report_SQL.getMyIdAndNamePath", setMap);
				
				commandMap.put("ItemID", request.getParameter("s_itemID"));
				commandMap.put("DefaultLang", defaultLang);
				List attrList = new ArrayList();
				/** 선택된 E2E Item의 기본정보의 속성 내용을 취득 */
				getE2EAttrInfo(commandMap, e2eAttrMap, e2eAttrNameMap, e2eAttrHtmlMap);
				
				/** 선택된 E2E Item의 Dimension 정보 취득 */
				getE2EDimInfo(setMap, e2eDimResultList);
				
				if (null == e2eModelMap) {
					url = AJAXPAGE;
				} else {
					setModelMap(e2eModelMap, request); // TODO
					e2eModelId = StringUtil.checkNull(e2eModelMap.get("ModelID"));
					List elementList = getE2EModelList(e2eModelId, "", "");

					allTotalMap = new HashMap();
					setTotalList(totalList, elementList, setMap, request, commandMap, defaultLang, languageId);
					allTotalMap.put("titleItemMap", titleItemMap);
					allTotalMap.put("totalList", totalList);
					allTotalList.add(allTotalMap);
				}
				
				/** 목차 리스트 취득 */
				if (totalList.size() > 0) {
					subTreeItemIDList = getE2EContents(allTotalList);
				}
			}else if(piClassMap.containsKey(classCode)){ // PI WordReport 
				/** 선택된 Item의 Path취득 (Id + Name) */
				//selectedItemPath = commonService.selectString("report_SQL.getMyIdAndNamePath", setMap);
				selectedItemPath= selectedItemMap.get("Identifier")+" "+selectedItemMap.get("ItemName");;
				
				commandMap.put("ItemID", request.getParameter("s_itemID"));
				commandMap.put("DefaultLang", defaultLang);
				List attrList = new ArrayList();
				if ("N".equals(StringUtil.checkNull(request.getParameter("onlyMap")))) {
					/** 선택된 PI Item의 기본정보의 속성 내용을 취득 */
					getPIAttrInfo(commandMap, piAttrMap, piAttrNameMap, piAttrHtmlMap);
					
					/** 선택된 PI Item의 연관프로세스 취득 */
					setMap.put("languageID", request.getParameter("languageID"));
					List relItemList = commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);
					
					allTotalMap = new HashMap();
					totalList = new ArrayList();
					setTotalList(totalList, relItemList, setMap, request, commandMap, defaultLang, languageId);
					titleItemMap = selectedItemMap;
					allTotalMap.put("titleItemMap", titleItemMap);
					allTotalMap.put("totalList", totalList);
					allTotalList.add(allTotalMap);
					
				}
				
				/** 목차 리스트 취득 */
				if (totalList.size() > 0) {
					subTreeItemIDList = getE2EContents(allTotalList);
				}
			} else {
				if ("CL01005".equals(classCode)) {
					Map subProcessMap = new HashMap();
					subProcessMap.put("MyItemID", request.getParameter("s_itemID"));
					modelList.add(subProcessMap);
					selectedItemPath= selectedItemMap.get("Identifier")+" "+selectedItemMap.get("ItemName");
				} else {
					setMap.put("ClassCode", "subProcess");
					
					String arcCode = StringUtil.checkNull(request.getParameter("ArcCode"));
					commandMap.put("ArcCode", arcCode);
					commandMap.put("SelectMenuId", arcCode);
					Map arcTreeFilterInfoMap =  commonService.select("report_SQL.getArcTreeFilterInfo", commandMap);	
					String TreeSql = StringUtil.checkNull(arcTreeFilterInfoMap.get("TreeSql"));
					commandMap.put("TreeSql", TreeSql);	
					String outPutItems = "";
					if(TreeSql != null && !"".equals(TreeSql))	{
						outPutItems = getArcTreeIDs(commandMap);
						commandMap.put("outPutItems", outPutItems);
					}
					
					setMap.put("outPutItems", outPutItems);	
					modelList = commonService.selectList("report_SQL.getItemStrList_gridList", setMap);
					setMap.remove("ClassCode");
					
					/** 목차 리스트 취득 */
					subTreeItemIDList = getChildItemList(commonService, request.getParameter("s_itemID"), classCode, languageId, outPutItems, delItemsYN);
					
					/** 선택된 Item의 Path취득 (Id + Name) */
					//selectedItemPath = commonService.selectString("report_SQL.getMyIdAndNamePath", setMap);
					selectedItemPath= selectedItemMap.get("Identifier")+" "+selectedItemMap.get("ItemName");;
					
					/** 선택된 Item의 SubProcess Item취득(L2) */
					setMap.put("CURRENT_ITEM", request.getParameter("s_itemID")); // 해당 아이템이 [FromItemID]인것
					setMap.put("CategoryCode", "ST1");
					setMap.put("languageID", languageId);
					setMap.put("toItemClassCode", "CL01004");   
					
					L2SubItemInfoList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
				}
				// 해당 아이템의 하위 항목의 서브프로세스 수 만큼 word report 작성
				setTotalList(totalList, modelList, setMap, request, commandMap, defaultLang, languageId);
				titleItemMap = selectedItemMap;
				allTotalMap.put("titleItemMap", titleItemMap);
				allTotalMap.put("totalList", totalList);
				allTotalMap.put("L2AttachFileList", L2AttachFileList);
				allTotalList.add(allTotalMap);
			}

			model.put("allTotalList", allTotalList);
			model.put("e2eModelMap", e2eModelMap); // E2E report 출력인 경우
			model.put("e2eItemInfo", selectedItemMap); // E2E report 출력인 경우
			model.put("e2eAttrMap", e2eAttrMap); // E2E report 출력인 경우
			model.put("e2eAttrNameMap", e2eAttrNameMap); // E2E report 출력인 경우
			model.put("e2eAttrHtmlMap", e2eAttrHtmlMap); // E2E report 출력인 경우
			model.put("e2eDimResultList", e2eDimResultList); // E2E report 출력인 경우
			
			model.put("piItemInfo", selectedItemMap); // PI report 출력인 경우
			model.put("piAttrMap", piAttrMap); // PI report 출력인 경우
			model.put("piAttrNameMap", piAttrNameMap); // PI report 출력인 경우
			model.put("piAttrHtmlMap", piAttrHtmlMap); // PI report 출력인 경우
			model.put("reportCode", reportCode);
			model.put("onlyMap", request.getParameter("onlyMap"));
			model.put("paperSize", request.getParameter("paperSize"));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			model.put("setMap", setMap);
			model.put("defaultFont", defaultFont);
			model.put("subTreeItemIDList", subTreeItemIDList);
			model.put("selectedItemPath", selectedItemPath);
			String itemNameofFileNm = StringUtil.checkNull(selectedItemMap.get("ItemName")).replace("&#xa;", "");
			model.put("ItemNameOfFileNm", URLEncoder.encode(itemNameofFileNm, "UTF-8").replace("+", "%20"));
			allTotalMap.put("L2SubItemInfoList", L2SubItemInfoList);
			model.put("selectedItemIdentifier", StringUtil.checkNull(selectedItemMap.get("Identifier")));
			model.put("outputType", request.getParameter("outputType"));  
			model.put("selectedItemMap", selectedItemMap);
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00105")); // DB에 생성된 모델이 없습니다.
			target.put(AJAX_SCRIPT, "parent.goBack();parent.$('#isSubmit').remove();");
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(url);	
	}
	
	
	/**
	 * batch wordReport 출력
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/batchProcessExport.do")
	public String batchProcessExport(HttpServletRequest request, HttpServletResponse response, HashMap commandMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		try{
				
			  Map setMap = new HashMap(); String languageID =
			  StringUtil.checkNull(commandMap.get("sessionCurrLangType")); String itemID =
			  StringUtil.checkNull(request.getParameter("s_itemID")); String classCode =
			  "CL01005"; commandMap.put("onlyMap", "N");
			  
			  setMap.put("itemID", itemID); setMap.put("classCode", classCode);
			  setMap.put("languageID", languageID); List itemInfoList =
			  commonService.selectList("report_SQL.getChildItemList", setMap);
			  
			  commandMap.remove("s_itemID"); String returnValue = "";
			  if(itemInfoList.size()>0){ for(int i=0; i<itemInfoList.size(); i++){ Map
			  itemInfoMap = (Map)itemInfoList.get(i); commandMap.put("s_itemID",
			  itemInfoMap.get("MyItemID")); returnValue = setBatchWordReport(request,
			  commandMap, model); } 
			  }
			
			String directoryPath = GlobalVal.FILE_UPLOAD_ITEM_DIR + "FLTP001/";
			File directory = new File(directoryPath);

			if (!directory.exists() || !directory.isDirectory()) {
			    throw new FileNotFoundException("Directory does not exist: " + directoryPath);
			}

			// 압축 파일 이름 생성
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			String zipFileName = "ALL_FILES_" + formatter.format(new Date()) + ".zip";
			String zipFilePath = directoryPath + zipFileName;

			// ZIP 파일 생성
			try (ZipOutputStream zos = new ZipOutputStream(new FileOutputStream(zipFilePath))) {
			    byte[] buffer = new byte[1024 * 2];
			    File[] files = directory.listFiles();

			    if (files != null) {
			        for (File file : files) {
			            if (file.isFile() && !file.getName().endsWith(".zip")) { // 기존 ZIP 파일 제외
			                try (BufferedInputStream bis = new BufferedInputStream(new FileInputStream(file))) {
			                    zos.putNextEntry(new ZipEntry(file.getName()));
			                    int length;
			                    while ((length = bis.read(buffer)) != -1) {
			                        zos.write(buffer, 0, length);
			                    }
			                    zos.closeEntry();
			                }
			                file.delete();
			            }
			        }
			    }
			    zos.setEncoding("euc-kr");
			} catch (Exception e) {
			    e.printStackTrace();
			    throw new IOException("Failed to create zip file: " + e.getMessage());
			}

			// 응답 헤더 설정 및 파일 다운로드
			response.setContentType("application/zip");
			String encodedZipFileName = URLEncoder.encode(zipFileName, StandardCharsets.UTF_8.toString()).replace("+", "%20");
			response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedZipFileName + "\"");
			response.setHeader("Content-Length", String.valueOf(new File(zipFilePath).length()));

			try (BufferedInputStream bis = new BufferedInputStream(new FileInputStream(zipFilePath))) {
			    byte[] buffer = new byte[1024];
			    int length;
			    OutputStream os = response.getOutputStream();
			    while ((length = bis.read(buffer)) > 0) {
			        os.write(buffer, 0, length);
			    }
			    os.flush(); // 스트림을 플러시하여 버퍼를 비웁니다.
			} finally {
			    // 임시 ZIP 파일 삭제
				 new File(zipFilePath).delete();
			}

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 
			target.put(AJAX_SCRIPT, "parent.afterWordReport();parent.$('#isSubmit').remove();");

			}catch(Exception e){
			    System.out.println(e);
			    target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			    target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
			}
		
		//model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	private String setBatchWordReport(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		String returnValue = "";
		try{
			Map setMap = new HashMap();
			String languageId = String.valueOf(commandMap.get("sessionCurrLangType"));
			String delItemsYN = StringUtil.checkNull(commandMap.get("delItemsYN"));
			setMap.put("languageID", languageId);
			setMap.put("langCode", StringUtil.checkNull(commandMap.get("sessionCurrLangCode")).toUpperCase());
			setMap.put("s_itemID", commandMap.get("s_itemID"));
			setMap.put("s_itemID", commandMap.get("s_itemID"));
			setMap.put("ArcCode", request.getParameter("ArcCode"));
			setMap.put("delItemsYN", delItemsYN);
	
			// 파일명에 이용할 Item Name 을 취득
			Map selectedItemMap = commonService.select("report_SQL.getItemInfo", setMap);
			
			/* 첨부 문서 취득 */
			setMap.put("DocumentID", StringUtil.checkNull(commandMap.get("s_itemID")));
			setMap.put("DocCategory", "ITM");
			List L2AttachFileList = commonService.selectList("fileMgt_SQL.getFile_gridList", setMap);
			
			// 로그인 언어별 default font 취득
			String defaultFont = commonService.selectString("report_SQL.getDefaultFont", setMap);			
			
			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", commandMap);			
			List modelList = new ArrayList();
			List totalList = new ArrayList();
			
			List allTotalList = new ArrayList();
			Map allTotalMap = new HashMap();
			Map titleItemMap = new HashMap();
			String e2eModelId = "";
			Map e2eModelMap = new HashMap();
			List subTreeItemIDList = new ArrayList();
			String selectedItemPath = "";
			Map e2eAttrMap = new HashMap();
			Map e2eAttrNameMap = new HashMap();
			Map e2eAttrHtmlMap = new HashMap();
			List e2eDimResultList = new ArrayList();
			
			Map piAttrMap = new HashMap();
			Map piAttrNameMap = new HashMap();
			Map piAttrHtmlMap = new HashMap();
			
			String reportCode = StringUtil.checkNull(commandMap.get("reportCode"));
			String classCode = commonService.selectString("report_SQL.getItemClassCode", setMap);
			List rptAllocClassList = commonService.selectList("report_SQL.getRptAllocatedClass", commandMap);
			Map e2eClassMap = new HashMap();
			Map piClassMap = new HashMap();
			
			List L2SubItemInfoList = new ArrayList();
				
			if(rptAllocClassList.size() > 0){			
				for (int i = 0; rptAllocClassList.size() > i; i++) {
					Map map = (Map) rptAllocClassList.get(i);
					if(reportCode.equals("RP00008")){ // get E2E allocation Report List	
						e2eClassMap.put(map.get("ClassCode"), map.get("ClassCode"));
					}else if(reportCode.equals("RP00031")){ // get PI allocation Report List	
						piClassMap.put(map.get("ClassCode"), map.get("ClassCode"));
					}
				}
			}
			
			if (e2eClassMap.containsKey(classCode)) {// E2E				
				/* Model 정보 취득 */
				setMap.put("ModelTypeCode", "MT003");
				e2eModelMap = commonService.select("report_SQL.getModelIdAndSize", setMap);
				
				/** 선택된 Item의 Path취득 (Id + Name) */
				selectedItemPath = commonService.selectString("report_SQL.getMyIdAndNamePath", setMap);
				
				commandMap.put("ItemID", commandMap.get("s_itemID"));
				commandMap.put("DefaultLang", defaultLang);
				List attrList = new ArrayList();
				if ("N".equals(StringUtil.checkNull(request.getParameter("onlyMap")))) {
					/** 선택된 E2E Item의 기본정보의 속성 내용을 취득 */
					getE2EAttrInfo(commandMap, e2eAttrMap, e2eAttrNameMap, e2eAttrHtmlMap);
					
					/** 선택된 E2E Item의 Dimension 정보 취득 */
					getE2EDimInfo(setMap, e2eDimResultList);
				}
				
				if (null == e2eModelMap) {
					//surl = AJAXPAGE;
				} else {
					setModelMap(e2eModelMap, request); // TODO
					e2eModelId = StringUtil.checkNull(e2eModelMap.get("ModelID"));
					List parentList = getE2EModelList(e2eModelId, "SB00001", "");
					
					for (int p = 0; parentList.size() > p ; p++) {
						titleItemMap = new HashMap();
						Map parentMap = (Map) parentList.get(p);
						
						/* 프로세스 요약의 타이틀 설정 */
						setMap.put("s_itemID", parentMap.get("MyItemID"));
						titleItemMap = commonService.select("report_SQL.getItemInfo", setMap);
						/* 해당 아이템에 정의 되어 있는 모델 리스트 취득 */
						List childList = getE2EModelList(e2eModelId, "SB00004", StringUtil.checkNull(parentMap.get("ElementID")));
						
						if (childList.size() > 0) { // 해당 아이템에 정의 되어 있는 모델이 존재 할 경우
							allTotalMap = new HashMap();
							totalList = new ArrayList();
							setTotalList(totalList, childList, setMap, request, commandMap, defaultLang, languageId);
							allTotalMap.put("titleItemMap", titleItemMap);
							allTotalMap.put("totalList", totalList);
							allTotalList.add(allTotalMap);
						}
					}
				}
				
				/** 목차 리스트 취득 */
				if (totalList.size() > 0) {
					subTreeItemIDList = getE2EContents(allTotalList);
				}
			}else if(piClassMap.containsKey(classCode)){ // PI WordReport 
				/** 선택된 Item의 Path취득 (Id + Name) */
				//selectedItemPath = commonService.selectString("report_SQL.getMyIdAndNamePath", setMap);
				selectedItemPath= selectedItemMap.get("Identifier")+" "+selectedItemMap.get("ItemName");;
				
				commandMap.put("ItemID", commandMap.get("s_itemID"));
				commandMap.put("DefaultLang", defaultLang);
				List attrList = new ArrayList();
				if ("N".equals(StringUtil.checkNull(request.getParameter("onlyMap")))) {
					/** 선택된 PI Item의 기본정보의 속성 내용을 취득 */
					getPIAttrInfo(commandMap, piAttrMap, piAttrNameMap, piAttrHtmlMap);
					
					/** 선택된 PI Item의 연관프로세스 취득 */
					setMap.put("languageID", request.getParameter("languageID"));
					List relItemList = commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);
					
					allTotalMap = new HashMap();
					totalList = new ArrayList();
					setTotalList(totalList, relItemList, setMap, request, commandMap, defaultLang, languageId);
					titleItemMap = selectedItemMap;
					allTotalMap.put("titleItemMap", titleItemMap);
					allTotalMap.put("totalList", totalList);
					allTotalList.add(allTotalMap);
					
				}
				
				/** 목차 리스트 취득 */
				if (totalList.size() > 0) {
					subTreeItemIDList = getE2EContents(allTotalList);
				}
			} else {
				if ("CL01005".equals(classCode)) {
					Map subProcessMap = new HashMap();
					subProcessMap.put("MyItemID", commandMap.get("s_itemID"));
					modelList.add(subProcessMap);
					selectedItemPath= selectedItemMap.get("Identifier")+" "+selectedItemMap.get("ItemName");
				} else {
					setMap.put("ClassCode", "subProcess");
					
					// Dimension tree인경우
					String arcCode = StringUtil.checkNull(request.getParameter("ArcCode"));
					commandMap.put("ArcCode", arcCode);
					commandMap.put("SelectMenuId", arcCode);
					//Map arcFilterDimInfoMap =  commonService.select("report_SQL.getArcFilterDimInfo", commandMap);
					String outPutItems = "";
					/*if (null != arcFilterDimInfoMap) {
						outPutItems = getArcTreeIDs(commandMap);
						setMap.put("outPutItems", outPutItems);
					}*/
						
					modelList = commonService.selectList("report_SQL.getItemStrList_gridList", setMap);
					setMap.remove("ClassCode");
					
					/** 목차 리스트 취득 */
					subTreeItemIDList = getChildItemList(commonService,StringUtil.checkNull(commandMap.get("s_itemID")), classCode, languageId, outPutItems, delItemsYN);
					
					/** 선택된 Item의 Path취득 (Id + Name) */
					selectedItemPath = commonService.selectString("report_SQL.getMyIdAndNamePath", setMap);
					
					/** 선택된 Item의 SubProcess Item취득(L2) */
					//setMap.put("CURRENT_ITEM", request.getParameter("s_itemID")); // 해당 아이템이 [FromItemID]인것
					setMap.put("CURRENT_ITEM", commandMap.get("s_itemID")); // 해당 아이템이 [FromItemID]인것
					setMap.put("CategoryCode", "ST1");
					setMap.put("languageID", languageId);
					setMap.put("toItemClassCode", "CL01004");	
					
					L2SubItemInfoList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
				}
				
				// 해당 아이템의 하위 항목의 서브프로세스 수 만큼 word report 작성
				setTotalList(totalList, modelList, setMap, request, commandMap, defaultLang, languageId);
				titleItemMap = selectedItemMap;
				allTotalMap.put("titleItemMap", titleItemMap);
				allTotalMap.put("totalList", totalList);
				allTotalMap.put("L2AttachFileList", L2AttachFileList);
				allTotalList.add(allTotalMap);
			}

			model.put("allTotalList", allTotalList);
			model.put("e2eModelMap", e2eModelMap); // E2E report 출력인 경우
			model.put("e2eItemInfo", selectedItemMap); // E2E report 출력인 경우
			model.put("e2eAttrMap", e2eAttrMap); // E2E report 출력인 경우
			model.put("e2eAttrNameMap", e2eAttrNameMap); // E2E report 출력인 경우
			model.put("e2eAttrHtmlMap", e2eAttrHtmlMap); // E2E report 출력인 경우
			model.put("e2eDimResultList", e2eDimResultList); // E2E report 출력인 경우
			
			model.put("piItemInfo", selectedItemMap); // PI report 출력인 경우
			model.put("piAttrMap", piAttrMap); // PI report 출력인 경우
			model.put("piAttrNameMap", piAttrNameMap); // PI report 출력인 경우
			model.put("piAttrHtmlMap", piAttrHtmlMap); // PI report 출력인 경우
			model.put("reportCode", reportCode);
			model.put("onlyMap", commandMap.get("onlyMap"));
			model.put("paperSize", commandMap.get("paperSize"));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			model.put("setMap", setMap);
			model.put("defaultFont", defaultFont);
			model.put("subTreeItemIDList", subTreeItemIDList);
			model.put("selectedItemPath", selectedItemPath);
			String itemNameofFileNm = StringUtil.checkNull(selectedItemMap.get("ItemName")).replace("&#xa;", "");
			model.put("ItemNameOfFileNm", itemNameofFileNm);
			commandMap.put("identifier", StringUtil.checkNull(selectedItemMap.get("Identifier")));
			allTotalMap.put("L2SubItemInfoList", L2SubItemInfoList);
			
			setMap.put("languageID", languageId);
			String extLangCode = StringUtil.checkNull(commonService.selectString("common_SQL.getLanguageExtCode",setMap));
			commandMap.put("extLangCode", extLangCode);
			String className = "xbolt.cmm.framework.util.MakeWordReport";
	        String methodName = "exportProcessReport";
	        String exportProcessReport = StringUtil.checkNull(request.getParameter("exportProcessReport"));
	        if(!exportProcessReport.isEmpty()) {
	        	methodName = exportProcessReport;
	        }
	        	
	        returnValue = invokeMethod(className, methodName, commandMap, model);
//	    	returnValue = MakeWordReport.exportProcessReport(commandMap,model);
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		return returnValue;
	}
	
    public static String invokeMethod(String className, String methodName, HashMap commandMap, ModelMap model) throws Exception {
        Class<?> classInfo = Class.forName(className);
        Object obj = classInfo.getDeclaredConstructor().newInstance();   
        Method method = classInfo.getMethod(methodName, HashMap.class, ModelMap.class);
        return (String) method.invoke(obj, commandMap, model);
    }
	/**
	 * Rule set wordReport 출력
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/wordReportPI.do")
	public String wordReportPI(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map target = new HashMap();
	
		String url= "/custom/" + GlobalVal.BASE_ATCH_URL + "/wordExportPI"+ "_" + GlobalVal.BASE_ATCH_URL;
		if(!StringUtil.checkNull(request.getParameter("url")).equals("")){ 
			url = "/custom/" + GlobalVal.BASE_ATCH_URL +"/"+ StringUtil.checkNull(request.getParameter("url")); 
		}
		
		try{
			Map setMap = new HashMap();
			String languageId = String.valueOf(commandMap.get("sessionCurrLangType"));
			String delItemsYN = StringUtil.checkNull(commandMap.get("delItemsYN"));
			setMap.put("languageID", languageId);
			setMap.put("langCode", StringUtil.checkNull(commandMap.get("sessionCurrLangCode")).toUpperCase());
			setMap.put("s_itemID", request.getParameter("s_itemID"));
			setMap.put("s_itemID", request.getParameter("s_itemID"));
			setMap.put("itemID", request.getParameter("s_itemID"));
			setMap.put("ArcCode", request.getParameter("ArcCode"));
			setMap.put("delItemsYN", delItemsYN);
			
			String selectedItemPath = "";
			String selectedItemName = "";
			
			// 선택한 Rule Group의 경로 + 명칭
			selectedItemPath = commonService.selectString("report_SQL.getMyPathAndName", setMap);
			selectedItemName = StringUtil.checkNull(commonService.selectString("report_SQL.getMyIdAndName", setMap)).replace("&#xa;", "");
			// 파일명에 이용할 Item Name 을 취득
			Map selectedItemMap = commonService.select("report_SQL.getItemInfo", setMap);
			
			// 로그인 언어별 default font 취득
			String defaultFont = commonService.selectString("report_SQL.getDefaultFont", setMap);			
			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", commandMap);	
			String classCode = commonService.selectString("report_SQL.getItemClassCode", setMap);
			
			List piSubItemList = commonService.selectList("report_SQL.getSubPIItemList", setMap);
			List L4ProcessList = commonService.selectList("report_SQL.getPIL4ItemList", setMap);// + ToCheck 
			
			Map setData = new HashMap();
			Map piSubItemInfoMap = new HashMap();
			List piSubItemList2 = new ArrayList();
			if(piSubItemList.size()>0){
				for(int i=0; piSubItemList.size() > i; i++){				
					Map processMap = (Map)piSubItemList.get(i);
					
					setData.put("itemID", processMap.get("SUBPIItemID")); 
					setData.put("s_itemID", processMap.get("SUBPIItemID"));
					setData.put("languageID", commandMap.get("sessionCurrLangType"));
					piSubItemInfoMap = commonService.select("report_SQL.getItemInfo", setData);
					
					setData.put("SUBPIItemID", processMap.get("SUBPIItemID")); 
					List subItemRelatedList = commonService.selectList("report_SQL.getPIL4ItemList", setData);// + ToCheck 
	
					setData.put("objClassCode", "CL08002");
					List piSubItemKpiList = commonService.selectList("report_SQL.getPIObjectList", setData);
					
					setData.put("objClassCode", "CL07002");
					List piSubItemRuleSetList = commonService.selectList("report_SQL.getPIObjectList", setData);
					
					setData.put("objClassCode", "CL09002");
					List piSubItemToCheckList = commonService.selectList("report_SQL.getPIObjectList", setData);
					
					processMap.put("AT00003",piSubItemInfoMap.get("Description")); 
					processMap.put("OwnerTeamName",piSubItemInfoMap.get("OwnerTeamName"));
					processMap.put("OwnerName",piSubItemInfoMap.get("Name"));	
					
					processMap.put("subItemRelatedList", subItemRelatedList);
					processMap.put("piSubItemKpiList", piSubItemKpiList);
					processMap.put("piSubItemRuleSetList", piSubItemRuleSetList);
					processMap.put("piSubItemToCheckList", piSubItemToCheckList);
					
					piSubItemList2.add(i,processMap);
				}
			}
			
			model.put("piSubItemList", piSubItemList2);
			model.put("L4ProcessList", L4ProcessList);
			
			setMap.put("objClassCode", "CL08002");
			List piKpiList = commonService.selectList("report_SQL.getPIObjectList", setMap);
			
			setMap.put("objClassCode", "CL07002");
			List piRuleSetList = commonService.selectList("report_SQL.getPIObjectList", setMap);
			
			setMap.put("objClassCode", "CL09002");
			List piToCheckList = commonService.selectList("report_SQL.getPIObjectList", setMap);
			
			model.put("piKpiList", piKpiList);
			model.put("piRuleSetList", piRuleSetList);
			model.put("piToCheckList", piToCheckList);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			model.put("setMap", setMap);
			model.put("defaultFont", defaultFont);
			model.put("selectedItemPath", selectedItemPath);
			model.put("selectedItemName", selectedItemName);
			model.put("selectedItemMap", selectedItemMap);
			model.put("ItemNameOfFileNm", URLEncoder.encode(selectedItemName, "UTF-8").replace("+", "%20"));
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00105")); // DB에 생성된 모델이 없습니다.
			target.put(AJAX_SCRIPT, "parent.afterWordReport();parent.$('#isSubmit').remove();");
			
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(url);
	}
	
	/**
	 * Rule set wordReport 출력
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/rulesetWordReport.do")
	public String rulesetWordReport(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		String url= "/custom/base/report/ruleReport";
		if(!StringUtil.checkNull(commandMap.get("url")).equals("")){ url = "/"+ StringUtil.checkNull(commandMap.get("url")); }
		
		try{
			Map setMap = new HashMap();
			String languageId = String.valueOf(commandMap.get("sessionCurrLangType"));
			setMap.put("languageID", languageId);
			setMap.put("langCode", StringUtil.checkNull(commandMap.get("sessionCurrLangCode")).toUpperCase());
			setMap.put("s_itemID", request.getParameter("s_itemID"));
			setMap.put("s_itemID", request.getParameter("s_itemID"));
			setMap.put("ArcCode", request.getParameter("ArcCode"));
			
			List ruleSetList = new ArrayList();
			Map attrRsNameMap = new HashMap();
			Map attrRsHtmlMap = new HashMap();
			String selectedItemPath = "";
			String selectedItemName = "";
			
			// 선택한 Rule Group의 경로 + 명칭
			selectedItemPath = commonService.selectString("report_SQL.getMyPathAndName", setMap);
			selectedItemName = StringUtil.checkNull(commonService.selectString("report_SQL.getMyIdAndName", setMap)).replace("&#xa;", "");
			// 로그인 언어별 default font 취득
			String defaultFont = commonService.selectString("report_SQL.getDefaultFont", setMap);			
			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", commandMap);	
			String classCode = commonService.selectString("report_SQL.getItemClassCode", setMap);
			
			// Rule Group:CL07001
			if ("CL07001".equals(classCode)) {
				/* Rule Group의 하위항목 Rule set list 취득 */
				setMap.put("CURRENT_ITEM", request.getParameter("s_itemID")); // 해당 아이템이 [FromItemID]인것
				setMap.put("CategoryCode", "ST1");
				ruleSetList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
				
				/* Rule set list의 연관 프로세스 && 속성 정보 취득 */
				ruleSetList = getConItemInfo(ruleSetList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, "CN00107", "ToItemID");
			} 
			
			model.put("attrRsNameMap", attrRsNameMap);
			model.put("attrRsHtmlMap", attrRsHtmlMap);
			model.put("ruleSetList", ruleSetList);
			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			model.put("setMap", setMap);
			model.put("defaultFont", defaultFont);
			model.put("selectedItemPath", selectedItemPath);
			model.put("selectedItemName", URLEncoder.encode(selectedItemName, "UTF-8").replace("+", "%20"));
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00105")); // DB에 생성된 모델이 없습니다.
			target.put(AJAX_SCRIPT, "parent.afterWordReport();parent.$('#isSubmit').remove();");
			
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(url);
	}
	
	/**
	 * Rule set wordReport 출력
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/wordReportRuleSet.do")
	public String wordReportRuleSet(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		String url= "/custom/" + GlobalVal.BASE_ATCH_URL + "/wordExportRuleSet"+ "_" + GlobalVal.BASE_ATCH_URL;
		if(!StringUtil.checkNull(request.getParameter("url")).equals("")){ 
			url = "/custom/" + GlobalVal.BASE_ATCH_URL +"/"+ StringUtil.checkNull(request.getParameter("url")); 
		}
		
		try{
			Map setMap = new HashMap();
			String languageId = String.valueOf(commandMap.get("sessionCurrLangType"));
			setMap.put("languageID", languageId);
			setMap.put("langCode", StringUtil.checkNull(commandMap.get("sessionCurrLangCode")).toUpperCase());
			setMap.put("s_itemID", request.getParameter("s_itemID"));
			setMap.put("s_itemID", request.getParameter("s_itemID"));
			setMap.put("ArcCode", request.getParameter("ArcCode"));
			
			List ruleSetList = new ArrayList();
			Map attrRsNameMap = new HashMap();
			Map attrRsHtmlMap = new HashMap();
			String selectedItemPath = "";
			String selectedItemName = "";
			
			// 선택한 Rule Group의 경로 + 명칭
			selectedItemPath = commonService.selectString("report_SQL.getMyPathAndName", setMap);
			selectedItemName = StringUtil.checkNull(commonService.selectString("report_SQL.getMyIdAndName", setMap)).replace("&#xa;", "");
			// 로그인 언어별 default font 취득
			String defaultFont = commonService.selectString("report_SQL.getDefaultFont", setMap);			
			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", commandMap);	
			String classCode = commonService.selectString("report_SQL.getItemClassCode", setMap);
			
			// 파일명에 이용할 Item Name 을 취득
			Map selectedItemMap = commonService.select("report_SQL.getItemInfo", setMap);
			
			// Rule Group:CL07001
			if ("CL07001".equals(classCode)) {
				/* Rule Group의 하위항목 Rule set list 취득 */
				setMap.put("CURRENT_ITEM", request.getParameter("s_itemID")); // 해당 아이템이 [FromItemID]인것
				setMap.put("CategoryCode", "ST1");
				ruleSetList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
				
				/* Rule set list의 연관 프로세스 && 속성 정보 취득 */
				ruleSetList = getConItemInfo(ruleSetList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, "CN00107", "ToItemID");
			} 
			
			model.put("attrRsNameMap", attrRsNameMap);
			model.put("attrRsHtmlMap", attrRsHtmlMap);
			model.put("ruleSetList", ruleSetList);
			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			model.put("setMap", setMap);
			model.put("defaultFont", defaultFont);
			model.put("selectedItemPath", selectedItemPath);
			model.put("selectedItemName", selectedItemName);
			model.put("itemNameOfFileNm", URLEncoder.encode(selectedItemName, "UTF-8").replace("+", "%20"));
			model.put("selectedItemMap", selectedItemMap);
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00105")); // DB에 생성된 모델이 없습니다.
			target.put(AJAX_SCRIPT, "parent.afterWordReport();parent.$('#isSubmit').remove();");
			
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(url);
	}
	
	
	/**
	 * KPI wordReport 출력
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/kpiWordReport.do")
	public String kpiWordReport(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		String url= "/custom/base/report/kpiReport";
		if(!StringUtil.checkNull(commandMap.get("url")).equals("")){ url = "/"+ StringUtil.checkNull(commandMap.get("url")); }
		
		try{
			Map setMap = new HashMap();
			String languageId = String.valueOf(commandMap.get("sessionCurrLangType"));
			setMap.put("languageID", languageId);
			setMap.put("langCode", StringUtil.checkNull(commandMap.get("sessionCurrLangCode")).toUpperCase());
			setMap.put("s_itemID", request.getParameter("s_itemID"));
			setMap.put("s_itemID", request.getParameter("s_itemID"));
			setMap.put("ArcCode", request.getParameter("ArcCode"));
			
			List kpiList = new ArrayList();
			Map attrRsNameMap = new HashMap();
			Map attrRsHtmlMap = new HashMap();
			String selectedItemPath = "";
			String selectedItemName = "";
			
			// 선택한 Rule Group의 경로 + 명칭
			selectedItemPath = commonService.selectString("report_SQL.getMyPathAndName", setMap);
			selectedItemName = StringUtil.checkNull(commonService.selectString("report_SQL.getMyIdAndName", setMap)).replace("&#xa;", "");
			// 로그인 언어별 default font 취득
			String defaultFont = commonService.selectString("report_SQL.getDefaultFont", setMap);			
			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", commandMap);	
			String classCode = commonService.selectString("report_SQL.getItemClassCode", setMap);
			
			// 지표 분류:CL08001
			if ("CL08001".equals(classCode)) {
				/* Rule Group의 하위항목 Rule set list 취득 */
				setMap.put("CURRENT_ITEM", request.getParameter("s_itemID")); // 해당 아이템이 [FromItemID]인것
				setMap.put("CategoryCode", "ST1");
				kpiList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
				
				/* KPI list의 연관 프로세스 && 속성 정보 취득 */
				kpiList = getConItemInfo(kpiList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, "CN00108", "ToItemID");
			} 
			
			model.put("attrRsNameMap", attrRsNameMap);
			model.put("attrRsHtmlMap", attrRsHtmlMap);
			model.put("kpiList", kpiList);
			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			model.put("setMap", setMap);
			model.put("defaultFont", defaultFont);
			model.put("selectedItemPath", selectedItemPath);
			model.put("selectedItemName", URLEncoder.encode(selectedItemName, "UTF-8").replace("+", "%20"));
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00105")); // DB에 생성된 모델이 없습니다.
			target.put(AJAX_SCRIPT, "parent.afterWordReport();parent.$('#isSubmit').remove();");
			
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(url);
	}

	/**
	 * KPI wordReport 출력
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/wordReportKpi.do")
	public String wordReportKpi(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		String url= "/custom/" + GlobalVal.BASE_ATCH_URL + "/wordExportKpi"+ "_" + GlobalVal.BASE_ATCH_URL;
		if(!StringUtil.checkNull(request.getParameter("url")).equals("")){ 
			url = "/custom/" + GlobalVal.BASE_ATCH_URL +"/"+ StringUtil.checkNull(request.getParameter("url")); 
		}
		try{
			Map setMap = new HashMap();
			String languageId = String.valueOf(commandMap.get("sessionCurrLangType"));
			setMap.put("languageID", languageId);
			setMap.put("langCode", StringUtil.checkNull(commandMap.get("sessionCurrLangCode")).toUpperCase());
			setMap.put("s_itemID", request.getParameter("s_itemID"));
			setMap.put("s_itemID", request.getParameter("s_itemID"));
			setMap.put("ArcCode", request.getParameter("ArcCode"));
			
			List kpiList = new ArrayList();
			Map attrRsNameMap = new HashMap();
			Map attrRsHtmlMap = new HashMap();
			String selectedItemPath = "";
			String selectedItemName = "";
			
			// 선택한 Rule Group의 경로 + 명칭
			selectedItemPath = commonService.selectString("report_SQL.getMyPathAndName", setMap);
			selectedItemName = StringUtil.checkNull(commonService.selectString("report_SQL.getMyIdAndName", setMap)).replace("&#xa;", "");
			// 로그인 언어별 default font 취득
			String defaultFont = commonService.selectString("report_SQL.getDefaultFont", setMap);			
			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", commandMap);	
			String classCode = commonService.selectString("report_SQL.getItemClassCode", setMap);
			
			// 선택한 아이템 정보 
			Map selectedItemMap = commonService.select("report_SQL.getItemInfo", setMap);
			// 지표 분류:CL08001
			if ("CL08001".equals(classCode)) {
				/* Rule Group의 하위항목 Rule set list 취득 */
				setMap.put("CURRENT_ITEM", request.getParameter("s_itemID")); // 해당 아이템이 [FromItemID]인것
				setMap.put("CategoryCode", "ST1");
				kpiList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
				
				/* KPI list의 연관 프로세스 && 속성 정보 취득 */
				kpiList = getConItemInfo(kpiList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, "CN00108", "ToItemID");
			} 
			
			model.put("attrRsNameMap", attrRsNameMap);
			model.put("attrRsHtmlMap", attrRsHtmlMap);
			model.put("kpiList", kpiList);
			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			model.put("setMap", setMap);
			model.put("defaultFont", defaultFont);
			model.put("selectedItemPath", selectedItemPath);
			model.put("selectedItemName", selectedItemName);
			model.put("itemNameOfFileNm", URLEncoder.encode(selectedItemName, "UTF-8").replace("+", "%20"));
			model.put("selectedItemMap", selectedItemMap);
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00105")); // DB에 생성된 모델이 없습니다.
			target.put(AJAX_SCRIPT, "parent.afterWordReport();parent.$('#isSubmit').remove();");
			
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(url);
	}
	
	/**
	 * E2E Item의 속성 정보 취득
	 * @param commandMap
	 * @param e2eAttrMap
	 * @param e2eAttrNameMap
	 * @param e2eAttrHtmlMap
	 * @throws Exception
	 */
	public void getE2EAttrInfo(HashMap commandMap, Map e2eAttrMap, Map e2eAttrNameMap, Map e2eAttrHtmlMap) throws Exception {
		List attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
		for (int k = 0; attrList.size()>k ; k++ ) {
			Map map = (Map) attrList.get(k);
			e2eAttrMap.put(map.get("AttrTypeCode"), StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(map.get("PlainText"))));
			e2eAttrNameMap.put(map.get("AttrTypeCode"), map.get("Name"));
			e2eAttrHtmlMap.put(map.get("AttrTypeCode"), map.get("HTML"));
		}
	}
	
	/**
	 * PI Item의 속성 정보 취득
	 * @param commandMap
	 * @param piAttrMap
	 * @param piAttrNameMap
	 * @param piAttrHtmlMap
	 * @throws Exception
	 */
	public void getPIAttrInfo(HashMap commandMap, Map piAttrMap, Map piAttrNameMap, Map piAttrHtmlMap) throws Exception {
		List attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
		for (int k = 0; attrList.size()>k ; k++ ) {
			Map map = (Map) attrList.get(k);
			piAttrMap.put(map.get("AttrTypeCode"), map.get("PlainText"));
			piAttrNameMap.put(map.get("AttrTypeCode"), map.get("Name"));
			piAttrHtmlMap.put(map.get("AttrTypeCode"), map.get("HTML"));
		}
	}
	
	/**
	 * E2E Item의 Dimension 정보 취득
	 * @param setMap
	 * @param dimResultList
	 * @throws Exception
	 */
	public void getE2EDimInfo(Map setMap, List dimResultList) throws Exception {
		List dimInfoList = commonService.selectList("dim_SQL.selectDim_gridList", setMap);
		Map dimResultMap = new HashMap();
		String dimTypeName = "";
		String dimValueNames = "";
		for(int i = 0; i < dimInfoList.size(); i++){
			Map map = (HashMap)dimInfoList.get(i);
			
			if (i > 0) {
				if(dimTypeName.equals(map.get("DimTypeName").toString())) {
					dimValueNames += " / "+map.get("DimValueName").toString();
				} else {
					dimResultMap.put("dimValueNames", dimValueNames);
					dimResultList.add(dimResultMap);
					dimResultMap = new HashMap(); // 초기화
					dimTypeName = map.get("DimTypeName").toString();
					dimResultMap.put("dimTypeName", dimTypeName);
					dimValueNames = map.get("DimValueName").toString();
				}
			}else{
				dimTypeName = map.get("DimTypeName").toString();
				dimResultMap.put("dimTypeName", dimTypeName);
				dimValueNames = map.get("DimValueName").toString();
			}
		}
		
		if (dimInfoList.size() > 0) {
			dimResultMap.put("dimValueNames", dimValueNames);
			dimResultList.add(dimResultMap);
		}
	}
	
	/**
	 * E2E report의 목차 리스트 취득
	 * @param commonService
	 * @param selectedItemId
	 * @param classCode
	 * @param languageID
	 * @return
	 * @throws Exception
	 */
	public List getE2EContents(List allTotalList) throws Exception {
		List subTreeItemIDList = new ArrayList();
		Map lowLankItemIdMap = new HashMap();
		List l4ItemList = new ArrayList();
		Map l3l4ItemIdMap = new HashMap();
		List l3l4ItemIdList = new ArrayList();
		
		for (int index = 0; allTotalList.size() > index ; index++) {
			Map allTotalMap = (Map) allTotalList.get(index);
			List totalList = (List) allTotalMap.get("totalList");
			for (int i = 0; totalList.size() > i ; i++) {
				Map totalMap = (Map) totalList.get(i);
				List prcList = (List) totalMap.get("prcList");
				Map prcMap = (Map) prcList.get(0);
				String name = removeAllTag(StringUtil.checkNull(prcMap.get("ItemName")));
				if(name.equals("")){
					name = StringUtil.checkNull(prcMap.get("ItemName"));
				}
				l4ItemList.add(StringUtil.checkNull(prcMap.get("Identifier") + " " + name));
				
			}
		}
		
		l3l4ItemIdMap.put("l3Item", "");
		l3l4ItemIdMap.put("l4ItemList", l4ItemList);
		l3l4ItemIdList.add(l3l4ItemIdMap);
		lowLankItemIdMap.put("l2Item", "");
		lowLankItemIdMap.put("l3l4ItemIdList", l3l4ItemIdList);
		subTreeItemIDList.add(lowLankItemIdMap);
		
		return subTreeItemIDList;
		
	}
	
	/**
	 * 계층별 (L1, L2, L3), 아이템의 L3, L4 리스트를 (ID + 명칭) 으로 취득
	 * @param commandMap
	 * @param arrayStr
	 * @throws Exception
	 */
	public List getChildItemList(CommonService commonService, String selectedItemId, String classCode, String languageID, String outPutItems, String delItemsYN) throws Exception {
		List list0 = new ArrayList();
		List list1 = new ArrayList();
		List l3l4ItemIdList = new ArrayList();
		Map lowLankItemIdMap = new HashMap();
		List subTreeItemIDList = new ArrayList();
		Map map0 = new HashMap();
		Map map1 = new HashMap();
		Map setMap = new HashMap();
		
		String itemId = selectedItemId;
		String toItemId = "";
		setMap.put("delItemsYN", delItemsYN);
		if (!outPutItems.isEmpty()) {
			setMap.put("CURRENT_ToItemID", outPutItems); // Dimension tree인 경우
		}
		
		if ("CL01001".equals(classCode)) {
			setMap.put("CURRENT_ITEM", itemId); // 해당 아이템이 [FromItemID]인것
			setMap.put("CategoryCode", "ST1");
			setMap.put("languageID", languageID);
			setMap.put("toItemClassCode", "CL01002");
			list0 = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
		} else if ("CL01002".equals(classCode)) { // L2
			setMap.put("CURRENT_ITEM", itemId); // 해당 아이템이 [FromItemID]인것
			setMap.put("CategoryCode", "ST1");
			setMap.put("languageID", languageID);
			setMap.put("toItemClassCode", "CL01004");
			list1 = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
		} else if ("CL01004".equals(classCode)) { // L3
			setMap.put("languageID", languageID);
			setMap.put("s_itemID", itemId);
			list1 = commonService.selectList("report_SQL.itemStDetailInfo", setMap);
			map1 = (Map) list1.get(0);
			map1.put("ToItemID", itemId);
			map1.put("toItemIdentifier", map1.get("Identifier"));
			map1.put("toItemName", map1.get("ItemName"));
			list1 = new ArrayList();
			list1.add(map1);
		}
		
		if (list0.size() > 0) {
			for (int i = 0; list0.size() > i; i++){
				lowLankItemIdMap = new HashMap();
				l3l4ItemIdList = new ArrayList();
				map0 = (Map) list0.get(i);
				
				String l2Name = removeAllTag(StringUtil.checkNull(map0.get("toItemName")));
				String l2Item = StringUtil.checkNull(map0.get("toItemIdentifier") + " " + l2Name);
				
				setMap.put("CURRENT_ITEM", map0.get("ToItemID")); // 해당 아이템이 [FromItemID]인것
				setMap.put("toItemClassCode", "CL01004");
				setMap.put("outPutItems",outPutItems);
				list1 = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
				lowLankItemIdMap.put("l2Item", l2Item);
				getL3l4ContentsList(list1, l3l4ItemIdList, setMap);
				lowLankItemIdMap.put("l3l4ItemIdList", l3l4ItemIdList);
				subTreeItemIDList.add(lowLankItemIdMap);
			}
		} else {
			lowLankItemIdMap = new HashMap();
			l3l4ItemIdList = new ArrayList();
			getL3l4ContentsList(list1, l3l4ItemIdList, setMap);
			lowLankItemIdMap.put("l2Item", "");
			lowLankItemIdMap.put("l3l4ItemIdList", l3l4ItemIdList);
			subTreeItemIDList.add(lowLankItemIdMap);
		}
		
		return subTreeItemIDList;
	}
	
	
	/**
	 * 아이템의 L3, L4 리스트를 (ID + 명칭) 으로 취득
	 * @param commandMap
	 * @param arrayStr
	 * @throws Exception
	 */
	private void getL3l4ContentsList(List list1, List l3l4ItemIdList, Map setMap) throws Exception {
		List l4ItemList = new ArrayList();
		Map l3l4ItemIdMap = new HashMap();
		
		for (int k = 0; list1.size() > k; k++) {
			l4ItemList = new ArrayList();
			l3l4ItemIdMap = new HashMap();
			
			Map map1 = (Map) list1.get(k);
			
			String l3Name = removeAllTag(StringUtil.checkNull(map1.get("toItemName")));
			String l3Item = StringUtil.checkNull(map1.get("toItemIdentifier") + " " + l3Name);
			 
			setMap.put("CURRENT_ITEM", map1.get("ToItemID")); // 해당 아이템이 [FromItemID]인것
			setMap.put("toItemClassCode", "CL01005");
			List list2 = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
		 
			for (int m = 0; list2.size() > m; m++) {
				Map map2 = (Map) list2.get(m);
				String l4Name = removeAllTag(StringUtil.checkNull(map2.get("toItemName")));
				l4ItemList.add(StringUtil.checkNull(map2.get("toItemIdentifier") + " " + l4Name));
			}
		 
			l3l4ItemIdMap.put("l3Item", l3Item);
			l3l4ItemIdMap.put("l4ItemList", l4ItemList);
			l3l4ItemIdList.add(l3l4ItemIdMap);
		}
	}
	
	
	/**
	 * 각 모델의 아이템 정보 및 모델 맵 사이즈 등을 취득
	 * @param totalList
	 * @param modelList
	 * @param setMap
	 * @param request
	 * @param commandMap
	 * @param defaultLang
	 * @param languageId
	 * @throws Exception
	 */
	public void setTotalList(List totalList, List modelList, Map setMap, HttpServletRequest request, HashMap commandMap, String defaultLang, String languageId) throws Exception {
		String beforFromItemID = "";
		for (int index = 0; modelList.size() > index; index++) {
			Map totalMap = new HashMap();
			Map subProcessMap = (Map) modelList.get(index);
			Map activityMap = new HashMap();
			
			List detailElementList = new ArrayList(); // 연관 프로세스 리스트
			List cnitemList = new ArrayList(); // 연관 항목 리스트
			List dimResultList = new ArrayList(); // 디멘션 정보
			List ruleSetList = new ArrayList(); // Rule set
			List requirementList = new ArrayList(); // Rule set
			List kpiList = new ArrayList(); // KPI
			List attachFileList = new ArrayList(); // 첨부 문서
			List toCheckList = new ArrayList(); // ToCheck
			
			List L3SubItemInfoList = new ArrayList();
			List L3KpiList = new ArrayList();
			Map L3AttrKpiNameMap = new HashMap();
			Map L3AttrKpiHtmlMap = new HashMap();
			List L3AttachFileList = new ArrayList();
			
			List cngtList = new ArrayList();
			
			setMap.put("s_itemID", subProcessMap.get("MyItemID"));
			setMap.put("itemId", String.valueOf(subProcessMap.get("MyItemID")));
			setMap.put("sessionCurrLangType", String.valueOf(commandMap.get("sessionCurrLangType")));
			setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
			setMap.put("attrTypeCode", commandMap.get("attrTypeCode"));
			/* 기본정보 취득 */
			List prcList = commonService.selectList("report_SQL.getItemInfo", setMap);

			/** 상위 item Info 취득 */
			//=====================================================================================================
			Map prcMap = (Map)prcList.get(0);
			String fromItemID = StringUtil.checkNull(prcMap.get("FromItemID")); // L3 ItemID 
			//if(!StringUtil.checkNull(prcMap.get("ClassCode")).equals("CL01005")){
				if(beforFromItemID.equals("") || !beforFromItemID.equals(fromItemID)){
					Map setData = new HashMap();
					setData.put("CURRENT_ITEM", fromItemID); // L4Item의 FromItem
					setData.put("CategoryCode", "ST1");
					setData.put("languageID", languageId);
					setData.put("toItemClassCode", "CL01005");					
					L3SubItemInfoList = commonService.selectList("report_SQL.getChildItemsForWord", setData);	
					
					// L3 KPI 취득 
					setData.put("CURRENT_ITEM", fromItemID); // 해당 아이템이 [FromItemID]인것
					setData.put("itemTypeCode", "CN00108");
					L3KpiList = commonService.selectList("report_SQL.getChildItemsForWord", setData);
					// L3 KPI list의 연관 프로세스 && 속성 정보 취득 
					L3KpiList = getConItemInfo(L3KpiList, defaultLang, languageId, L3AttrKpiNameMap, L3AttrKpiHtmlMap, "CN00108", "ToItemID");
					totalMap.put("L3AttrKpiNameMap", L3AttrKpiNameMap);
					totalMap.put("L3AttrKpiHtmlMap", L3AttrKpiHtmlMap);
					totalMap.put("L3KpiList", L3KpiList);
					setData.remove("CURRENT_ITEM");
					
					// 첨부 문서 취득 
					setData.put("DocumentID", fromItemID); // L3 itemID
					setData.put("DocCategory", "ITM");
					setData.remove("itemTypeCode");
					L3AttachFileList = commonService.selectList("fileMgt_SQL.getFile_gridList", setData);
				}
				beforFromItemID = fromItemID;
			//}
			//=====================================================================================================
			/* 기본정보의 속성 내용을 취득 */
			commandMap.put("ItemID", subProcessMap.get("MyItemID"));
			commandMap.put("DefaultLang", defaultLang);
			
			List attrList = new ArrayList();
			List activityList = new ArrayList();
//			if ("N".equals(StringUtil.checkNull(commandMap.get("onlyMap")))) {
				attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
				Map attrMap = new LinkedHashMap();
				Map attrNameMap = new LinkedHashMap();
				Map attrHtmlMap = new LinkedHashMap();
				for (int k = 0; attrList.size()>k ; k++ ) {
					Map map = (Map) attrList.get(k);
					attrMap.put(map.get("AttrTypeCode"), map.get("PlainText"));
					attrNameMap.put(map.get("AttrTypeCode"), map.get("Name"));
					attrHtmlMap.put(map.get("AttrTypeCode"), map.get("HTML"));
				}
				
				// Activity 정보 취득 
				setMap.put("viewType", "wordReport");
				activityList = commonService.selectList("item_SQL.getSubItemList_gridList", setMap);
				
				activityList = getActivityAttr(activityList, defaultLang ,languageId, attrNameMap, attrHtmlMap, activityMap); // 액티비티의 속성을 액티비티 리스트에 추가
				
				// Activity 속성명 모두 취득 ( ex) AT00005:수행부서, AT00006:수행주체, AT00013:사용시스템 )
				List activityNames = commonService.selectList("report_SQL.getActivityAttrName", commandMap);
				for (int k = 0; activityNames.size()>k ; k++ ) {
					Map map = (Map) activityNames.get(k);
					attrNameMap.put(map.get("AttrTypeCode"), map.get("Name"));
				}
				
				totalMap.put("attrMap", attrMap);
				totalMap.put("attrNameMap", attrNameMap);
				totalMap.put("attrHtmlMap", attrHtmlMap);
//			}
			
			// Model 정보 취득 
			setMap.remove("ModelTypeCode");
			setMap.put("MTCategory", request.getParameter("MTCategory"));
			Map modelMap = commonService.select("report_SQL.getModelIdAndSize", setMap);
			// 모델이 DB에 존재 하는 경우, 문서에 표시할 모델 맵 크기를 계산 한다
			// 모델이 DB에 존재 하는 경우, [TB_ELEMENT]에서 선행 /후행 데이터 취득
			if (null != modelMap) {
				setModelMap(modelMap, request);
				Map setMap2 = new HashMap();
				setMap2.put("languageID", languageId);
//				if ("N".equals(StringUtil.checkNull(commandMap.get("onlyMap")))) {
					// [TB_ELEMENT]에서 선행 /후행 데이터 취득 
					detailElementList = getElementList(setMap2, modelMap);
//				}
			}

//			if ("N".equals(StringUtil.checkNull(commandMap.get("onlyMap")))) {
				// 관련항목 취득 
				cnitemList = commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);
				
				// Dimension정보 취득 
				List dimInfoList = commonService.selectList("dim_SQL.selectDim_gridList", setMap);
				Map dimResultMap = new HashMap();
				String dimTypeName = "";
				String dimValueNames = "";
				for(int i = 0; i < dimInfoList.size(); i++){
					Map map = (HashMap)dimInfoList.get(i);
					
					if (i > 0) {
						if(dimTypeName.equals(map.get("DimTypeName").toString())) {
							dimValueNames += " / "+map.get("DimValueName").toString();
						} else {
							dimResultMap.put("dimValueNames", dimValueNames);
							dimResultList.add(dimResultMap);
							dimResultMap = new HashMap(); // 초기화
							dimTypeName = map.get("DimTypeName").toString();
							dimResultMap.put("dimTypeName", dimTypeName);
							dimValueNames = map.get("DimValueName").toString();
						}
					}else{
						dimTypeName = map.get("DimTypeName").toString();
						dimResultMap.put("dimTypeName", dimTypeName);
						dimValueNames = map.get("DimValueName").toString();
					}
				}
				
				if (dimInfoList.size() > 0) {
					dimResultMap.put("dimValueNames", dimValueNames);
					dimResultList.add(dimResultMap);
				}
				
				// Rule Set 취득  Rule Group의 하위항목 Rule set list 취득 
				Map attrRsNameMap = new HashMap();
				Map attrRsHtmlMap = new HashMap();
				setMap.put("CURRENT_ITEM", setMap.get("s_itemID")); // 해당 아이템이 [FromItemID]인것
				setMap.put("itemTypeCode", "CN00107");
				ruleSetList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
				// Rule set list의 연관 프로세스 && 속성 정보 취득 
				ruleSetList = getConItemInfo(ruleSetList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, "CN00107", "ToItemID");
				totalMap.put("attrRsNameMap", attrRsNameMap);
				totalMap.put("attrRsHtmlMap", attrRsHtmlMap);
				totalMap.put("ruleSetList", ruleSetList);
				setMap.remove("CURRENT_ITEM");
				
				// KPI 취득 
				setMap.put("CURRENT_ITEM", setMap.get("s_itemID")); // 해당 아이템이 [FromItemID]인것
				setMap.put("itemTypeCode", "CN00108");
				kpiList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);				
				// KPI list의 연관 프로세스 && 속성 정보 취득 
				kpiList = getConItemInfo(kpiList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, "CN00108", "ToItemID");
				totalMap.put("attrKpiNameMap", attrRsNameMap);
				totalMap.put("attrKpiHtmlMap", attrRsHtmlMap);
				totalMap.put("kpiList", kpiList);
				setMap.remove("CURRENT_ITEM");
				
				// 첨부 문서 취득 
				setMap.remove("itemTypeCode");
				setMap.put("DocumentID", String.valueOf(subProcessMap.get("MyItemID")));
				attachFileList = commonService.selectList("fileMgt_SQL.getFile_gridList", setMap);
				
				// PI과제 취득 
				String classCode = commonService.selectString("report_SQL.getItemClassCode", setMap);
				
				setMap.put("CURRENT_ToItemID", setMap.get("s_itemID")); // 해당 아이템이 [FromItemID]인것
				setMap.put("itemTypeCode", "CN01301");
				requirementList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
		
				// PI list의 연관 프로세스 && 속성 정보 취득 
				requirementList = getConItemInfo(requirementList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, "CN01301" , "FromItemID");
				totalMap.put("attrPINameMap", attrRsNameMap);
				totalMap.put("attrPIHtmlMap", attrRsHtmlMap);
				totalMap.put("requirementList", requirementList);
				setMap.remove("CURRENT_ToItemID");
				
				// ToCheck 취득 
				setMap.put("CURRENT_ITEM", setMap.get("s_itemID")); // 해당 아이템이 [ToItemID]인것
				setMap.put("itemTypeCode", "CN00109");
				toCheckList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
				
				// ToCheck list의 연관 프로세스 && 속성 정보 취득 
				toCheckList = getConItemInfo(toCheckList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, "CN00109", "ToItemID");
				totalMap.put("attrToCheckNameMap", attrRsNameMap);
				totalMap.put("attrToCheckHtmlMap", attrRsHtmlMap);
				totalMap.put("toCheckList", toCheckList);
				setMap.remove("CURRENT_ToItemID");
				
				// 개정이력(changeSet) 취득
				cngtList = commonService.selectList("report_SQL.getItemChangeListRPT", setMap);
				
				List companyRuleList = new ArrayList(); // 사규 OJ00007
				List guideLineProcList = new ArrayList(); // 업무지침 OJ00005
				List standardFormList = new ArrayList(); // 서식 OJ00006
				
				List positionList = new ArrayList(); // 직무 OJ00006
				List knowledgeList = new ArrayList(); // 서식 OJ00006
				
				// 사규 취득  
				setMap.remove("CURRENT_ToItemID");
				setMap.remove("CategoryCode");
				setMap.remove("toItemClassCode");
				setMap.put("CURRENT_ITEM", setMap.get("s_itemID")); // 해당 아이템이 [ToItemID]인것
				setMap.put("itemTypeCode", "CN00107");
				companyRuleList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);

				// 사규 list의 연관 프로세스 && 속성 정보 취득 
				companyRuleList = getConItemInfo(companyRuleList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, "CN00107", "FromItemID");
				totalMap.put("attrCompanyRuleNameMap", attrRsNameMap);
				totalMap.put("attrCompanyRuleHtmlMap", attrRsHtmlMap);
				totalMap.put("companyRuleList", companyRuleList);
				//setMap.remove("CURRENT_ITEM");
				
				// 업무지침 
				setMap.remove("CURRENT_ITEM");
				setMap.remove("CURRENT_ToItemID");
				setMap.put("CURRENT_ITEM", setMap.get("s_itemID")); // 해당 아이템이 [ToItemID]인것
				//setMap.put("itemTypeCode", "CN00105");
				guideLineProcList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
				// 업무지침 list의 연관 프로세스 && 속성 정보 취득 
				guideLineProcList = getConItemInfo(guideLineProcList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, "CN00105", "ToItemID");
				totalMap.put("attrGuideProcNameMap", attrRsNameMap);
				totalMap.put("attrGuideProcHtmlMap", attrRsHtmlMap);
				totalMap.put("guideLineProcList", guideLineProcList);
				//setMap.remove("CURRENT_ITEM");
				
				// 직무/역할 구조 
				setMap.remove("CURRENT_ITEM");
				setMap.remove("CURRENT_ToItemID");
				setMap.put("CURRENT_ToItemID", setMap.get("s_itemID")); // 해당 아이템이 [ToItemID]인것
				setMap.put("itemTypeCode", "CN00201");
				setMap.remove("toItemClassCode");
				positionList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
				//System.out.println("positionList :"+positionList+"setMap.get(s_itemID) : "+setMap.get("s_itemID"));
				// 업무지침 list의 연관 프로세스 && 속성 정보 취득 
				positionList = getConItemInfo(positionList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, "CN00201", "ToItemID");
				totalMap.put("attrPositionNameMap", attrRsNameMap);
				totalMap.put("attrPositionHtmlMap", attrRsHtmlMap);
				totalMap.put("positionList", positionList);
				
				// 관련지식
				setMap.remove("CURRENT_ITEM");
				setMap.remove("CURRENT_ToItemID");
				setMap.put("CURRENT_ITEM", setMap.get("s_itemID")); // 해당 아이템이 [ToItemID]인것
				setMap.put("itemTypeCode", "CN00112");
				setMap.remove("toItemClassCode");
				knowledgeList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
				// 업무지침 list의 연관 프로세스 && 속성 정보 취득 
				knowledgeList = getConItemInfo(knowledgeList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, "CN00112", "FromItemID");
				totalMap.put("attrPositionNameMap", attrRsNameMap);
				totalMap.put("attrPositionHtmlMap", attrRsHtmlMap);
				totalMap.put("knowledgeList", knowledgeList);

				// 서식 
				setMap.put("CURRENT_ITEM", setMap.get("s_itemID")); // 해당 아이템이 [ToItemID]인것
				setMap.put("itemTypeCode", "CN00106");
				standardFormList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
				
				// 서식 list의 연관 프로세스 && 속성 정보 취득 
				standardFormList = getConItemInfo(standardFormList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, "CN00106", "ToItemID");
				totalMap.put("attrGuideSystemNameMap", attrRsNameMap);
				totalMap.put("attrGuideSystemHtmlMap", attrRsHtmlMap);
				totalMap.put("standardFormList", standardFormList);
				
//			}

			totalMap.put("prcList", prcList);
			totalMap.put("modelMap", modelMap);
			totalMap.put("activityList", activityList);
			totalMap.put("elementList", detailElementList);
			totalMap.put("cnitemList", cnitemList);
			totalMap.put("dimResultList", dimResultList);
			totalMap.put("ruleSetList", ruleSetList);
			totalMap.put("kpiList", kpiList);
			totalMap.put("attachFileList", attachFileList);
			totalMap.put("requirementList", requirementList);
			totalMap.put("toCheckList", toCheckList);
			totalMap.put("L3SubItemInfoList", L3SubItemInfoList);
			totalMap.put("L3KpiList", L3KpiList);
			totalMap.put("L3AttachFileList", L3AttachFileList);
			totalMap.put("cngtList", cngtList); 
			totalList.add(index, totalMap);
			
		}
	}
	
	
	
	/**
	 * 모델 정보 취득
	 * @param modelMap
	 * @param request
	 */
	public void setModelMap(Map modelMap, HttpServletRequest request) {
		// model size 조정
		int width = 546;
		int height = 580;
		int actualWidth = 0;
		int actualHeight = 0;
		int zoom = 100;
		
		/* 문서에 표시할 모델 맵 크기를 계산 한다 */
		if ("2".equals(request.getParameter("paperSize"))) {
			width = 700;
			height = 930;
 		}
		
		actualWidth = Integer.parseInt(StringUtil.checkNull(modelMap.get("Width"), String.valueOf(width)));
		actualHeight = Integer.parseInt(StringUtil.checkNull(modelMap.get("Height"), String.valueOf(height)));
		
		if (width < actualWidth || height < actualHeight) {
			for (int i = 99 ; i > 1 ; i-- ) {
				actualWidth = (actualWidth * i) / 100;
				actualHeight = (actualHeight * i) / 100;
				if( width > actualWidth && height > actualHeight ){
					zoom = i; 
					break;
				}
			}
		}
		
		modelMap.remove("Width");
		modelMap.remove("Height");
		modelMap.put("Width", actualWidth);
		modelMap.put("Height", actualHeight);
		System.out.println("Width=="+actualWidth);
		System.out.println("Height=="+actualHeight);
	}
	
	/**
	 * E2E모델 리스트 취득
	 * @return
	 * @throws Exception 
	 */
	public List getE2EModelList(String modelId, String symTypeCode, String parent) throws Exception {
		Map map = new HashMap();
		map.put("ModelID", modelId);
		map.put("SymTypeCode", symTypeCode);
		map.put("Parent", parent);
		List returnModelList = commonService.selectList("report_SQL.getE2EMElementList", map);
		return returnModelList;
	}
	
	/**
	 * 연관 항목 취득
	 * @param list
	 * @param setMap
	 * @return
	 */
	private List getCnItemList(List list, Map setMap) {
		setMap.put("parentID", setMap.get("s_itemID"));
		String className = "";

		List pertinentDetailList = new ArrayList();
 		List relItemRowList = new ArrayList();
		Map classNameMap = new HashMap();
		int classNameCnt = 1;
		String strClassName = "";
		
		setMap.remove("attrTypeCode");
		
		for (int i = 0; i < list.size(); i++) {
			Map pertinentMap = (Map) list.get(i);
			String itemId = pertinentMap.get("s_itemID").toString();
			setMap.put("s_itemID", itemId);
			setMap.put("s_itemID", itemId);
			
			if (null != pertinentMap.get("ClassName")) {
				if (className.isEmpty()) {
					className = pertinentMap.get("ClassName").toString();
					strClassName = className;
					pertinentDetailList.add(removeAllHtmlTagAndSetAttrInfo(pertinentMap));
				} else {
					if (className.equals(pertinentMap.get("ClassName").toString())) {
						pertinentDetailList.add(removeAllHtmlTagAndSetAttrInfo(pertinentMap));
					} else {
						relItemRowList.add(pertinentDetailList);
						
						className = pertinentMap.get("ClassName").toString();
						classNameCnt++;
						strClassName = strClassName + "," + className;
						
						pertinentDetailList = new ArrayList();
						pertinentDetailList.add(removeAllHtmlTagAndSetAttrInfo(pertinentMap));
					}
				}
			}
			
			if (i == (list.size()- 1)) {
				relItemRowList.add(pertinentDetailList);
			}
			
		}
		
		return relItemRowList;

	}
	
	/**
	 * Model의 선행/후행 process 취득 
	 * @param setMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	private List getElementList(Map setMap2, Map modelMap) throws Exception {
		List returnList = new ArrayList();
		
		// mdlIF = Y 인 symbolList
		setMap2.put("mdlIF","Y");
		setMap2.put("modelTypeCode", modelMap.get("ModelTypeCode"));
		List symbolList = commonService.selectList("model_SQL.getSymbolTypeList", setMap2);
		
		String SymTypeCodes = "";
		for(int i=0; i<symbolList.size(); i++) {
			Map map = (Map) symbolList.get(i);
			if(i != 0) SymTypeCodes += ",";
			SymTypeCodes += "'"+map.get("SymTypeCode")+"'";
		}
		
		/* [TB_ELEMENT]에서 선행 /후행 데이터 취득 */
		setMap2.remove("FromID");
		setMap2.remove("ToID");
		setMap2.put("ModelID", modelMap.get("ModelID"));
		setMap2.put("SymTypeCodes", SymTypeCodes);
		List elementList = commonService.selectList("report_SQL.getObjListOfModel", setMap2);
		
		for (int i = 0 ; elementList.size()> i ; i++) {
			Map returnMap = new HashMap();
			Map elementMap = (Map) elementList.get(i);
			String elementId = String.valueOf(elementMap.get("ElementID"));
			String objectId = String.valueOf(elementMap.get("ObjectID"));
			
			returnMap = elementMap;
			returnMap.put("RNUM", i + 1);
						
			// 선행, 후행 아이템의 Item Info 취득
			setMap2.put("s_itemID", objectId);
			Map itemInfoMap = commonService.select("report_SQL.getItemInfo", setMap2);
			returnMap.put("ID", itemInfoMap.get("Identifier"));
			returnMap.put("Name", itemInfoMap.get("ItemName"));
			returnMap.put("Description", StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(itemInfoMap.get("Description"),"")));
			
			returnList.add(returnMap);
		}
				
		return returnList;
	}
	
	/**
	 * 액티비티 속성 정보 취득
	 * @param List
	 * @param defaultLang
	 * @param sessionCurrLangType
	 * @return
	 * @throws Exception
	 */
	private List getActivityAttr(List List, String defaultLang, String sessionCurrLangType,Map attrNameMap, Map attrHtmlMap, Map activityMap) throws Exception {
		List resultList = new ArrayList();
		Map setMap = new HashMap();
		List actToCheckList = new ArrayList();
		List actRuleSetList = new ArrayList();
		List actSystemList = new ArrayList();
		List actRoleList = new ArrayList();
		List actITSystemList = new ArrayList(); // 연관항목 리스트 출력
		List actTeamRoleList = new ArrayList(); // 관련조직 리스트 출력
		List actPrcList = new ArrayList(); // QMS 용 기본정보
		
		String accMode = String.valueOf(activityMap.get("accMode"));
		String changeSetID = String.valueOf(activityMap.get("changeSetID"));
		String activityMode = StringUtil.checkNull(activityMap.get("activityMode"));
		
		setMap.put("DefaultLang", defaultLang);
		setMap.put("sessionCurrLangType", sessionCurrLangType);
		setMap.put("languageID", sessionCurrLangType);
		
		for (int i = 0; i < List.size(); i++) {
			Map listMap = new HashMap();
			listMap = (Map) List.get(i);
			String itemId = String.valueOf(listMap.get("ItemID"));
			
			// QMS&E2E의 경우
			if ("element".equals(activityMode)) {
				itemId = String.valueOf(listMap.get("ObjectID"));
				setMap.put("itemId", itemId);
				setMap.put("s_itemID", itemId);
				
				changeSetID = commonService.selectString("cs_SQL.getChangeSetID", setMap);
				actPrcList = commonService.selectList("report_SQL.getItemInfo", setMap);
				
				for(int j=0; j < actPrcList.size(); j++) {
					Map actInfo = (Map) actPrcList.get(j);
					if(actInfo.containsKey("OwnerTeamID")) {
						setMap.put("teamID", StringUtil.checkNull(actInfo.get("OwnerTeamID")));
						Map managerInfo = commonService.select("user_SQL.getUserTeamManagerInfo", setMap);
						listMap.put("ownerTeamMngNM",managerInfo.get("MemberName"));	// 프로세스 책임자
						setMap.remove("teamID");
					}
				}
				if (accMode.equals("OPS")) {
					changeSetID = commonService.selectString("item_SQL.getItemReleaseNo", setMap);
					setMap.put("changeSetID", changeSetID);
					actPrcList = commonService.selectList("item_SQL.getItemAttrRevInfo", setMap);
				}
			}
			listMap.put("actPrcList", actPrcList);
			
			setMap.put("ItemID", itemId);
			
			List attrList = new ArrayList();
			if(accMode.equals("OPS")) {
				setMap.put("changeSetID", changeSetID);
				setMap.put("s_itemID", itemId);
				setMap.put("defaultLang", defaultLang);
				attrList = commonService.selectList("item_SQL.getItemRevDetailInfo", setMap);
				setMap.remove(changeSetID);
			} else {
				attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
			}
			
			for (int k = 0; attrList.size()>k ; k++ ) {
				Map map = (Map) attrList.get(k);
				String plainText = "";
				if(map.get("DataType").equals("MLOV")){
					plainText = getMLovVlaue(sessionCurrLangType, itemId, StringUtil.checkNull(map.get("AttrTypeCode")));
					listMap.put(map.get("AttrTypeCode"), plainText);
				}else{
					if(StringUtil.checkNull(map.get("HTML"),"").equals("1")) {
						listMap.put(map.get("AttrTypeCode"), StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(map.get("PlainText"))));
					} else {
						listMap.put(map.get("AttrTypeCode"), map.get("PlainText"));
					}
				}
			}
			
			/*Activity Rule Set 취득  Rule Group의 하위항목 Rule set list 취득 */
			setMap.put("CURRENT_ITEM", itemId); // 해당 아이템이 [FromItemID]인것
			setMap.put("itemTypeCode", "CN00107");
			actRuleSetList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
			/* Rule set list의 연관 프로세스 && 속성 정보 취득 */			
			actRuleSetList = getConItemInfo(actRuleSetList, defaultLang, sessionCurrLangType, attrNameMap, attrHtmlMap, "CN00107", "ToItemID");
			listMap.put("actRuleSetList", actRuleSetList);
			setMap.remove("CURRENT_ITEM");
			
			//ToCheck 취득 
			setMap.put("CURRENT_ITEM", itemId); // 해당 아이템이 [ToItemID]인것
			setMap.put("itemTypeCode", "CN00109");			
			actToCheckList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
			// Activity ToCheck list의 연관 프로세스 && 속성 정보 취득 
			actToCheckList = getConItemInfo(actToCheckList, defaultLang, sessionCurrLangType, attrNameMap, attrHtmlMap, "CN00109", "ToItemID");
			listMap.put("actToCheckList", actToCheckList);
			setMap.remove("CURRENT_ITEM");
			
			//System 취득 
			setMap.put("CURRENT_ITEM", itemId); // 해당 아이템이 [ToItemID]인것
			setMap.put("itemTypeCode", "CN00104");			
			actSystemList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
			// Activity system list의 연관 프로세스 && 속성 정보 취득 
			actSystemList = getConItemInfo(actSystemList, defaultLang, sessionCurrLangType, attrNameMap, attrHtmlMap, "CN00104", "ToItemID");
			listMap.put("actSystemList", actSystemList);
			setMap.remove("CURRENT_ITEM");
			
			//연관항목 취득
			setMap.put("s_itemID", itemId);
			actITSystemList = commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);
			listMap.put("actITSystemList", actITSystemList);
			
			// Role 취득 
			setMap.put("CURRENT_ToItemID", itemId); 
			setMap.put("itemTypeCode", "CN00201");			
			actRoleList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
			// Activity Role list의 연관 프로세스 && 속성 정보 취득 
			actRoleList = getConItemInfo(actRoleList, defaultLang, sessionCurrLangType, attrNameMap, attrHtmlMap, "CN00201", "FromItemID");
			listMap.put("actRoleList", actRoleList);
			setMap.remove("CURRENT_ToItemID");
						
			// 관련조직 취득 
			setMap.put("itemID", itemId);
			if("OPS".equals(accMode)){
				setMap.put("asgnOption", "2,3"); //해제,신규 미출력
			} else {
				setMap.put("asgnOption", "1,2"); //해제,해제중 미출력
			}
			actTeamRoleList = commonService.selectList("role_SQL.getItemTeamRoleList_gridList", setMap);
			listMap.put("actTeamRoleList", actTeamRoleList);
			
			resultList.add(listMap);
		}
		
		return resultList;
	}
	
	/**
	 * Rule set 속성 정보 취득
	 * @param List
	 * @param defaultLang
	 * @param sessionCurrLangType
	 * @return
	 * @throws Exception
	 */
	private List getRuleSetAttr(List List, String defaultLang, String sessionCurrLangType, Map attrRsNameMap, Map attrRsHtmlMap) throws Exception {
		List resultList = new ArrayList();
		Map setMap = new HashMap();
		
		for (int i = 0; i < List.size(); i++) {
			Map listMap = new HashMap();
			listMap = (Map) List.get(i);
			String itemId = String.valueOf(listMap.get("s_itemID"));
			
			setMap.put("ItemID", itemId);
			setMap.put("DefaultLang", defaultLang);
			setMap.put("sessionCurrLangType", sessionCurrLangType);
			
			List attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
			
			for (int k = 0; attrList.size()>k ; k++ ) {
				Map map = (Map) attrList.get(k);
				listMap.put(map.get("AttrTypeCode"), map.get("PlainText"));
				attrRsNameMap.put(map.get("AttrTypeCode"), map.get("Name"));
				attrRsHtmlMap.put(map.get("AttrTypeCode"), map.get("HTML"));
			}
			
			resultList.add(listMap);
		}
		
		return resultList;
	}
	
	
	/**
     * Connection 의 Info 정보 취득
     * @param List
     * @param defaultLang
     * @param sessionCurrLangType
     * @return
     * @throws Exception
     */
    private List getConItemInfo(List List, String defaultLang, String sessionCurrLangType, Map attrRsNameMap, Map attrRsHtmlMap, String cnTypeCode , String source) throws Exception {
        List resultList = new ArrayList();
        Map setMap = new HashMap();
        
        for (int i = 0; i < List.size(); i++) {
            Map listMap = new HashMap();
            List resultSubList = new ArrayList();
            
            listMap = (Map) List.get(i);
            String itemId = String.valueOf(listMap.get(source));
            
            setMap.put("ItemID", itemId);
            setMap.put("DefaultLang", defaultLang);
            setMap.put("sessionCurrLangType", sessionCurrLangType);
            List attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
            
            String plainText = "";
            for (int k = 0; attrList.size()>k ; k++ ) {
                Map map = (Map) attrList.get(k);                
                attrRsNameMap.put(map.get("AttrTypeCode"), map.get("Name"));
                attrRsHtmlMap.put(map.get("AttrTypeCode"), map.get("HTML"));
                if(map.get("DataType").equals("MLOV")){
                    plainText = getMLovVlaue(sessionCurrLangType, itemId, StringUtil.checkNull(map.get("AttrTypeCode")));
                    listMap.put(map.get("AttrTypeCode"), plainText);
                }else{
                    listMap.put(map.get("AttrTypeCode"), map.get("PlainText"));
                }
            }
            
            String isFromItem = "Y";
            if(!source.equals("FromItemID")){ isFromItem = "N"; }
            setMap.put("varFilter", cnTypeCode);
            setMap.put("languageID", sessionCurrLangType);
            setMap.put("isFromItem", isFromItem);
            setMap.put("s_itemID", itemId);
            List relatedAttrList = new ArrayList();
//            List cnItemList = commonService.selectList("item_SQL.getCXNItems", setMap);
        
//            for (int k = 0; cnItemList.size()>k ; k++ ) {
//                Map map = (Map) cnItemList.get(k);
            if(isFromItem.equals("Y")){
                resultSubList.add(StringUtil.checkNull(listMap.get("fromItemIdentifier")) + " " + removeAllTag(StringUtil.checkNull(listMap.get("fromItemName"))));
            } else {
                resultSubList.add(StringUtil.checkNull(listMap.get("toItemIdentifier")) + " " + removeAllTag(StringUtil.checkNull(listMap.get("toItemName"))));
            }
                setMap.put("ItemID", listMap.get("FromItemID"));
                setMap.put("DefaultLang", defaultLang);
                setMap.put("sessionCurrLangType", sessionCurrLangType);
                relatedAttrList = commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
                if(relatedAttrList.size()>0){
                    for(int m=0; m<relatedAttrList.size(); m++){
                        Map relAttrMap = (Map) relatedAttrList.get(m);                            
                        resultSubList.add(StringUtil.checkNull(relAttrMap.get("Name")));
                        resultSubList.add(StringUtil.checkNull(relAttrMap.get("PlainText")));
                        resultSubList.add(StringUtil.checkNull(relAttrMap.get("HTML")));
                    }
                }
//            }
            listMap.put("resultSubList", resultSubList);        
            
            resultList.add(listMap);
        }
        
        return resultList;
    }
	
	private String getMLovVlaue(String languageID, String itemID, String attrTypeCode) throws Exception {
		List mLovList = new ArrayList();
		Map setMap = new HashMap();
		String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
		setMap.put("languageID", languageID);
		setMap.put("defaultLang", defaultLang);	
		setMap.put("itemID", itemID);
		setMap.put("attrTypeCode", attrTypeCode);
		mLovList = commonService.selectList("attr_SQL.getMLovList",setMap);
		String plainText = "";
		if(mLovList.size() > 0){
			for(int j=0; j<mLovList.size(); j++){
				Map mLovListMap = (HashMap)mLovList.get(j);
				if(j==0){
					plainText = StringUtil.checkNull(mLovListMap.get("Value"));
				}else {
					plainText = plainText + " / " + mLovListMap.get("Value") ;
				}
			}
		}
		return plainText;
	}
	
	
	//계층구조 화면 속성
	@RequestMapping(value="/excelImport.do")
	public String excelImport(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		try
		{
			
			/* 선택된 아이템의 해당 CSR 리스트를 취득 */
			commandMap.put("AuthorID", commandMap.get("sessionUserId"));
			commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
			List returnData = commonService.selectList("project_SQL.getCsrListWithMember", commandMap);
			model.put("csrOption", returnData);
			
			model.put("languageID", commandMap.get("sessionCurrLangType"));
			model.put("s_itemID", request.getParameter("itemID"));
			model.put("option", request.getParameter("ArcCode"));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
			
			//model.put("setMap", setMap);
	
		}catch(Exception e){
			System.out.println(e.toString());
		}
		
		return nextUrl("/report/excelImport");
	}
	
	//데이타 업로드
	@RequestMapping(value="/itemExcelUpload.do")
	public String itemExcelUpload(HashMap commandFileMap, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();

		int line = 0;

		try {

			List list				= (List) commandFileMap.get("STORED_FILES");
			Map map					= (Map) list.get(0);

			String sys_file_name	= (String)map.get("SysFileNm");
			String file_path		= "";//(String)map.get("FilePath");
			String file_id			= (String)map.get("AttFileID");

			

			HashMap drmInfoMap = new HashMap();			
			String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
			String teamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
			String teamName = StringUtil.checkNull(commandMap.get("sessionTeamName"));			
			drmInfoMap.put("userID", userID);
			drmInfoMap.put("userName", userName);
			drmInfoMap.put("teamID", teamID);
			drmInfoMap.put("teamName", teamName);
			drmInfoMap.put("loginID", commandMap.get("sessionLoginId"));
			drmInfoMap.put("sessionEmail", commandMap.get("sessionEmail"));
			
			String filePath			= FileUtil.FILE_UPLOAD_DIR + sys_file_name;			
			System.out.println(filePath);
			String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
			String useUploadDRM = StringUtil.checkNull(GlobalVal.DRM_UPLOAD_USE);
			if(!"".equals(useDRM) && !"N".equals(useUploadDRM)){
				drmInfoMap.put("ORGFileDir", FileUtil.FILE_UPLOAD_DIR);
				drmInfoMap.put("DRMFileDir", FileUtil.FILE_UPLOAD_DIR);
				// drmInfoMap.put("Filename", userID + "_" + sys_file_name);
				drmInfoMap.put("Filename", sys_file_name);
				drmInfoMap.put("FileRealName", sys_file_name);							
				drmInfoMap.put("funcType", "upload");
				filePath = DRMUtil.drmMgt(drmInfoMap); // 복호화 		
				System.out.println(filePath);
			}
			
			
			String errorCheckfilePath = GlobalVal.FILE_EXPORT_DIR; //.FILE_UPLOAD_TINY_DIR;

			Map excelMap = new HashMap();
			int total_cnt		= 0;
			int valid_cnt		= 0;
			int attrTypeCode_cnt = 0;
			String colsName = "";
			String headerName = "";
			
			/* 파일 업로드 체크 시 발생한 에러 메세지 출력 파일 생성 */
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			long date = System.currentTimeMillis();
		    String fileName = "Upload_ERROR_" + formatter.format(date) + ".txt";
		    String downFile = errorCheckfilePath + fileName;
			File file = new File(downFile);
//			BufferedWriter errorLog = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file,true), "UTF-8"));
			
//			excelMap = getItemList(new File(filePath), commandFileMap, commandMap, errorLog);
			
			// 읽어 들인 데이터 체크에서 메세지가 있을 때, 처리를 중단하고 메세지표시
			/*if (excelMap.get("msg") != null) {
				
				errorLog.close();
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00074")); // 오류 발생
				target.put(AJAX_SCRIPT, "parent.errorTxtDown('"+ fileName +"','"+ downFile +"');parent.$('#isSubmit').remove();");
				
			} else {*/
//			errorLog.close();
			// file.delete(); // 파일 업로드 정상 종료인경우, 생성된 로그 파일을 삭제 한다.
			
			BufferedWriter errorLog = null;
			OutputStreamWriter os = null;
			FileOutputStream fos = null;
			
			try {
				fos = new FileOutputStream(file,true);
				os = new OutputStreamWriter(fos, "UTF-8");
				errorLog = new BufferedWriter(os);
				excelMap = getItemList(new File(filePath), commandFileMap, commandMap, errorLog);
			} catch ( Exception e ) {
	        	System.out.println(e.toString());
	        	throw e;
	        } finally {
	        	errorLog.close();
	        }
			
			List arrayList = (List) excelMap.get("list");
			total_cnt = NumberUtil.getIntValue(excelMap.get("totalCnt"));
			valid_cnt = NumberUtil.getIntValue(excelMap.get("validCnt"));
			attrTypeCode_cnt = NumberUtil.getIntValue(excelMap.get("attrTypeCodeCnt"));
			colsName = excelMap.get("colsName").toString();
			if (commandFileMap.get("uploadTemplate").equals("4")) {
				headerName = excelMap.get("headerName").toString();
			}
				
			String jsonObject = "";
			if(arrayList.size() > 0){
				String [] cols = colsName.split("[|]");
				int totalPage = 0;
				jsonObject = JsonUtil.parseGridJson(arrayList, cols, totalPage, 1 ,(String)commandFileMap.get("contextPath"));
				jsonObject = jsonObject.replace("<br/>", ", ");
			}
			

			System.out.println("total_cnt=="+total_cnt);
			System.out.println("valid_cnt=="+valid_cnt);
			
			//target.put(AJAX_ALERT, "파일 업로드를 성공하였습니다.");
			//target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00071")
			//		+ " " + MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".CM00021")); // 파일 업로드 성공
			String type = StringUtil.checkNull(commandFileMap.get("uploadTemplate"));
			target.put(AJAX_SCRIPT, "parent.doCntReturn('');parent.$('#isSubmit').remove();");
			System.out.println("attrTypeCode_cnt == "+attrTypeCode_cnt);
			System.out.println("type == "+type);
			System.out.println("file_id == "+file_id);
			System.out.println("jsonObject == "+jsonObject);
			System.out.println("headerName == "+headerName);			
			
			String errMsgYN="";
			if (excelMap.get("msg") != null) {
				errMsgYN =  "Y";
			}else{ errMsgYN = "N";}				
			target.put(AJAX_SCRIPT, "parent.doCntReturn('"+total_cnt+"','"+valid_cnt+"','"+attrTypeCode_cnt+"','"+type+"','"+file_id+"','"+jsonObject+"','"+headerName+"','"+errMsgYN+"','"+ fileName +"','"+ downFile +"');");
			//}
			
			// 읽어 들인 데이터 체크에서 메세지가 있을 때, 처리를 중단하고 메세지표시
			if (excelMap.get("msg") != null) {				
				errorLog.close();				
				//target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00074")); // 오류 발생
				//target.put(AJAX_SCRIPT, "parent.errorTxtDown('"+ fileName +"','"+ downFile +"');parent.$('#isSubmit').remove();");
			} else {
				file.delete(); // 파일 업로드 정상 종료인경우, 생성된 로그 파일을 삭제 한다.
				//target.put(AJAX_SCRIPT, "parent.doCntReturn('"+total_cnt+"','"+valid_cnt+"','"+attrTypeCode_cnt+"','"+type+"','"+file_id+"','"+jsonObject+"','"+headerName+"');");
			}
			
		} catch (Exception e) {
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			//target.put(AJAX_ALERT, "파일 업로드 중 오류 : " + e.getMessage().replaceAll("\"", ""));
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00072", new String[]{e.getMessage().replaceAll("\"", "")}));
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}	
	
	@RequestMapping(value="/itemExcelSave.do")
	public String itemExcelSave(HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		try {

			String itemTypeCode = StringUtil.checkNull(commonService.selectString("item_SQL.selectedItemTypeCode", commandMap));
			String itemTypeCodeCN = StringUtil.checkNull(commonService.selectString("item_SQL.selectedConItemTypeCode", commandMap));
			
			// 로그인 유저의[CompanyID][TeamID]취득
			List userInfoList = commonService.selectList("report_SQL.getUserInfo", commandMap);
			Map userInfoMap = (Map) userInfoList.get(0);
			
			commandMap.put("companyID", userInfoMap.get("CompanyID"));			
			commandMap.put("OwnerTeamID", userInfoMap.get("TeamID"));
			
			commandMap.put("itemTypeCode", itemTypeCode);
			commandMap.put("itemTypeCodeCN", itemTypeCodeCN);
			
			reportService.save(commandMap);
			
			String msg = MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00088");
			
			if (commandMap.containsKey("infoMsg")) {
				msg = msg + commandMap.get("infoMsg").toString();
			}
			
			target.put(AJAX_ALERT,   msg);
			target.put(AJAX_SCRIPT,  "parent.doSaveReturn();parent.$('#isSubmit').remove()");
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
	 * Consolidation 리포트 실행 
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/exeConsolidation.do") 
	 public String exeConsolidation(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception{  
		 HashMap target = new HashMap();  
		 try{
	   
			 Map setMap = new HashMap(); 
			 String items = request.getParameter("items").toString();
			 String masterItemId = request.getParameter("masterItemId").toString();
			 String[] arrayItems = items.split(",");
			
			 for (int i = 0; i < arrayItems.length; i++) {
				 String targetItemId = arrayItems[i];
				 setMap.put("masterItemId", masterItemId);    
				 setMap.put("targetItemId", targetItemId);   
				 commonService.update("report_SQL.exeConsolidation", setMap);
			 }
	   
			 target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			 target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();");
	   
	  }catch (Exception e) {
		  System.out.println(e);
		  target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
		  target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생

	  }
		 model.addAttribute(AJAX_RESULTMAP, target);
		 return nextUrl(AJAXPAGE);
	 }
	
	// TODO : word 리포트 내용을 화면에 표시
	@RequestMapping(value="/html.do")
	public String html(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		
		String url= "/report/html";
		
		try{
			String schType = "";
			Map setMap = new HashMap();
			setMap.put("languageID", request.getParameter("languageID"));
			setMap.put("s_itemID", request.getParameter("s_itemID"));
			setMap.put("s_itemID", request.getParameter("s_itemID"));
			setMap.put("ArcCode", request.getParameter("option"));
			
			//하위 데이터가 있는 경우
			int totCnt = NumberUtil.getIntValue(commonService.selectString("report_SQL.processTotalCnt", setMap));
			_log.info("totCnt="+totCnt);
			if( totCnt > 0)	setMap.put("schType", "FROM");
			else setMap.put("schType", "TO");
			
			/* 메뉴명 취득 */
			Map mapValue = new HashMap();
			/* 기본정보 내용 취득 */
			List prcList = removeAllHtmlTag(commonService.selectList("report_SQL.getItemInfo", setMap));
			
			/* 기본정보의 속성 내용을 취득 */
			List attributesList = commonService.selectList("report_SQL.itemAttributesInfo", setMap);
			List attributesNameList = commonService.selectList("report_SQL.getAttrDicName", setMap);
			
			Map attrNameMap = new HashMap();
			Map attrTextMap = new HashMap();
			mapValue = new HashMap();
			for(int i = 0; i < attributesList.size(); i++){
				mapValue = (HashMap)attributesList.get(i);
				attrTextMap.put(mapValue.get("AttrTypeCode"), mapValue.get("PlainText"));
			}
			
			for(int i = 0; i < attributesNameList.size(); i++){
				mapValue = (HashMap)attributesNameList.get(i);
				attrNameMap.put(mapValue.get("TypeCode"), mapValue.get("Name"));
			}
			
			//List itemFileList = commonService.selectList("report_SQL.itemFileInfo", setMap);
			//List changeSetInfoList = commonService.selectList("report_SQL.getChangeSetInfo", setMap);
			
			if (!("").equals(commandMap.get("sessionParamSubItems"))) {
				setMap.put("sessionParamSubItems", commandMap.get("sessionParamSubItems").toString());
			}
			
			List subModelList = commonService.selectList("item_SQL.getSubItemList_gridList", setMap);
			
			if (!("").equals(commandMap.get("sessionParamSubItems"))) {
				setMap.remove("sessionParamSubItems");
			}
//			List structureList = commonService.selectList("item_SQL.getSubItemList_gridList", setMap);
			List relItemList = commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);

			setMap.put("parentID", request.getParameter("s_itemID"));
			String className = "";
			
			/** 구조정보 취득 */
//			List activityList = new ArrayList();
//			List subProcessList = new ArrayList();
			
//			for (int i = 0; i < structureList.size(); i++) {
//				Map structureMap = (Map) structureList.get(i);
//				String itemId = structureMap.get("ItemID").toString();
//				setMap.put("s_itemID", itemId);
//				setMap.put("s_itemID", itemId);
//				if (null != structureMap.get("ClassName")) {
//					if (className.isEmpty()) {
//						className = structureMap.get("ClassName").toString();
//					} else {
//						if (!className.equals(structureMap.get("ClassName").toString())) {
//							setMap.put("attrTypeCode", "AT00038");
//							activityList.add(removeAllHtmlTagAndSetAttrInfo(commonService.selectList("report_SQL.itemAttributesInfo", setMap), structureMap));
//						}				
//					}
//				}
//			}
			
//			for (int i = 0; i < subModelList.size(); i++) {
//				Map structureMap = (Map) subModelList.get(i);
//				String itemId = structureMap.get("ItemID").toString();
//				setMap.put("s_itemID", itemId);
//				setMap.put("s_itemID", itemId);
//				if (null != structureMap.get("ClassName")) {
//					setMap.put("attrTypeCode", "AT00037");
//					subProcessList.add(removeAllHtmlTagAndSetAttrInfo(commonService.selectList("report_SQL.itemAttributesInfo", setMap), structureMap));
//				}
//			}
			
			/** 관련항목 취득 */
			className = "";
	
			List pertinentDetailList = new ArrayList();
			List relItemRowList = new ArrayList();
			Map classNameMap = new HashMap();
			int classNameCnt = 1;
			String strClassName = "";
			
			setMap.remove("attrTypeCode");
			
			for (int i = 0; i < relItemList.size(); i++) {
				Map pertinentMap = (Map) relItemList.get(i);
				String itemId = pertinentMap.get("s_itemID").toString();
				setMap.put("s_itemID", itemId);
				setMap.put("s_itemID", itemId);
				
				if (null != pertinentMap.get("ClassName")) {
					if (className.isEmpty()) {
						className = pertinentMap.get("ClassName").toString();
						strClassName = className;
						pertinentDetailList.add(removeAllHtmlTagAndSetAttrInfo(pertinentMap));
					} else {
						if (className.equals(pertinentMap.get("ClassName").toString())) {
							pertinentDetailList.add(removeAllHtmlTagAndSetAttrInfo(pertinentMap));
						} else {
							relItemRowList.add(pertinentDetailList);
							
							className = pertinentMap.get("ClassName").toString();
							classNameCnt++;
							strClassName = strClassName + "," + className;
							
							pertinentDetailList = new ArrayList();
							pertinentDetailList.add(removeAllHtmlTagAndSetAttrInfo(pertinentMap));
						}
					}
				}
				
				if (i == (relItemList.size()- 1)) {
					relItemRowList.add(pertinentDetailList);
				}
				
			}
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			model.put("strClassName", strClassName);
			model.put("prcList", prcList);
			
			model.put("attrNameMap", attrNameMap);
			model.put("attrTextMap", attrTextMap);
			
//			model.put("itemFileList", itemFileList);
//			model.put("changeSetInfoList", changeSetInfoList);
			
			model.put("subModelList", subModelList);
//			model.put("activityList", activityList);
			model.put("relItemRowList", relItemRowList);
			
			model.put("s_itemID", request.getParameter("s_itemID"));
			
			model.put("setMap", setMap);
			
		} catch(Exception e) {
			System.out.println(e.toString());
		}
		
		return nextUrl(url);
	}
	
	// TODO : word 리포트 내용을 화면에 표시 Program Status(CBO List, I/F Master)
	@RequestMapping(value="/programHtml.do")
	public String programHtml(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		
		String url= "/report/programHtml";
		
		try{
			String schType = "";
			Map setMap = new HashMap();
			setMap.put("languageID", request.getParameter("languageID"));
			setMap.put("LanguageID", request.getParameter("languageID"));
			setMap.put("s_itemID", request.getParameter("s_itemID"));
			setMap.put("s_itemID", request.getParameter("s_itemID"));
			setMap.put("ArcCode", request.getParameter("option"));
			
			//하위 데이터가 있는 경우
			int totCnt = NumberUtil.getIntValue(commonService.selectString("report_SQL.processTotalCnt", setMap));
			_log.info("totCnt="+totCnt);
			if( totCnt > 0)	setMap.put("schType", "FROM");
			else setMap.put("schType", "TO");
			
			/* 메뉴명 취득 */
			Map menuMap = new HashMap();
			Map mapValue = new HashMap();
			
			/* 기본정보 내용 취득 */
			List prcList = removeAllHtmlTag(commonService.selectList("report_SQL.getItemInfo", setMap));
			
			String classCode = (String)((HashMap) prcList.get(0)).get("ClassCode");
			
			// classCode에 따라 속성 및 Program Status 내용 취득을 분기
			List attributesList = new ArrayList();
			List attributesNameList = new ArrayList();
			List programStatusList = new ArrayList();
			
			Map attrNameMap = new HashMap();
			Map attrTextMap = new HashMap();
			Map pgrStsMap = new HashMap();
			
			if ("CL04005".equals(classCode)) {
				
				/* CBO */
				
				/* 기본정보의 속성 내용을 취득 */
				setMap.put("FromTypeCode", "AT00038");
				setMap.put("ToTypeCode", "AT00072");
				attributesList = commonService.selectList("report_SQL.itemAttrInfoForProgram", setMap);
				attributesNameList = commonService.selectList("report_SQL.getAttrDicNameForProgram", setMap);
				
				mapValue = new HashMap();
				for(int i = 0; i < attributesList.size(); i++){
					mapValue = (HashMap)attributesList.get(i);
					attrTextMap.put(mapValue.get("AttrTypeCode"), mapValue.get("PlainText"));
				}
				
				for(int i = 0; i < attributesNameList.size(); i++){
					mapValue = (HashMap)attributesNameList.get(i);
					attrNameMap.put(mapValue.get("TypeCode"), mapValue.get("Name"));
				}
				
				/* Program Status 내용을 취득 */
				setMap.put("Category", "PGRSTS"); // Program Status 명 취득
				programStatusList  = commonService.selectList("project_SQL.getChangeSetInsertInfo", setMap);
				
				for(int i = 0; i < programStatusList.size(); i++){
					mapValue = (HashMap)programStatusList.get(i);
					pgrStsMap.put(mapValue.get("TypeCode"), mapValue.get("Name"));
				}
				
				// ItemID에 해당하는 ChangeSet List를 모두 취득
				//changeSetInfoList = commonService.selectList("cs_SQL.getChangeSetList_gridList", setMap);
				
			} else {
				/* I/F */
				
				/* 기본정보의 속성 내용을 취득 */
				setMap.put("FromTypeCode", "AT00039");
				setMap.put("ToTypeCode", "AT00101");
				attributesList = commonService.selectList("report_SQL.itemAttrInfoForProgram", setMap);
				attributesNameList = commonService.selectList("report_SQL.getAttrDicNameForProgram", setMap);
				
				mapValue = new HashMap();
				for(int i = 0; i < attributesList.size(); i++){
					mapValue = (HashMap)attributesList.get(i);
					attrTextMap.put(mapValue.get("AttrTypeCode"), mapValue.get("PlainText"));
				}
				
				for(int i = 0; i < attributesNameList.size(); i++){
					mapValue = (HashMap)attributesNameList.get(i);
					attrNameMap.put(mapValue.get("TypeCode"), mapValue.get("Name"));
				}
				
				/* Program Status 내용을 취득 */
				setMap.put("Category", "IFSTS"); // Program Status 명 취득
				programStatusList  = commonService.selectList("project_SQL.getChangeSetInsertInfo", setMap);
				
				for(int i = 0; i < programStatusList.size(); i++){
					mapValue = (HashMap)programStatusList.get(i);
					pgrStsMap.put(mapValue.get("TypeCode"), mapValue.get("Name"));
				}
				
				// ItemID에 해당하는 ChangeSet List를 모두 취득
				//changeSetInfoList = commonService.selectList("cs_SQL.getChangeSetList_gridList", setMap);
				
			}
			
			
			/** 관련항목 취득 */
			List relItemList = commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);

			setMap.put("parentID", request.getParameter("s_itemID"));
			String className = "";
			
			className = "";
	
			List pertinentDetailList = new ArrayList();
			List relItemRowList = new ArrayList();
			Map classNameMap = new HashMap();
			int classNameCnt = 1;
			String strClassName = "";
			
			setMap.remove("attrTypeCode");
			
			for (int i = 0; i < relItemList.size(); i++) {
				Map pertinentMap = (Map) relItemList.get(i);
				String itemId = pertinentMap.get("s_itemID").toString();
				setMap.put("s_itemID", itemId);
				setMap.put("s_itemID", itemId);
				
				if (null != pertinentMap.get("ClassName")) {
					if (className.isEmpty()) {
						className = pertinentMap.get("ClassName").toString();
						strClassName = className;
						pertinentDetailList.add(removeAllHtmlTagAndSetAttrInfo(pertinentMap));
					} else {
						if (className.equals(pertinentMap.get("ClassName").toString())) {
							pertinentDetailList.add(removeAllHtmlTagAndSetAttrInfo(pertinentMap));
						} else {
							relItemRowList.add(pertinentDetailList);
							
							className = pertinentMap.get("ClassName").toString();
							classNameCnt++;
							strClassName = strClassName + "," + className;
							
							pertinentDetailList = new ArrayList();
							pertinentDetailList.add(removeAllHtmlTagAndSetAttrInfo(pertinentMap));
						}
					}
				}
				
				if (i == (relItemList.size()- 1)) {
					relItemRowList.add(pertinentDetailList);
				}
				
			}
			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			model.put("prcList", prcList);
			
			model.put("attrNameMap", attrNameMap);
			model.put("attrTextMap", attrTextMap);
			model.put("pgrStsMap", pgrStsMap);
			
			model.put("classCode", classCode);
//			model.put("changeSetInfoList", changeSetInfoList);
			model.put("programStatusList", programStatusList);
			model.put("strClassName", strClassName);
			model.put("relItemRowList", relItemRowList);
			
			model.put("s_itemID", request.getParameter("s_itemID"));
			
			model.put("setMap", setMap);
			
		} catch(Exception e) {
			System.out.println(e.toString());
		}
		
		return nextUrl(url);
	}
	
	// TODO : 매핑항목 리스트 팝업
	@RequestMapping(value="/downloadCNListPop.do")
	public String downloadCNListPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		String url= "/report/downloadCNListPop";
		
		try{
				Map setMap = new HashMap();
				setMap.put("s_itemID", commandMap.get("itemID"));
				String itemTypeCode = commonService.selectString("config_SQL.getItemTypeCodeItemID", setMap);
				
				model.put("itemTypeCode", itemTypeCode);
				model.put("s_itemID", commandMap.get("s_itemID"));
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
			
		} catch(Exception e) {
			System.out.println(e.toString());
		}
		
		return nextUrl(url);
	}
	
	// TODO : 매핑항목 리스트 팝업
	@RequestMapping(value="/downloadCNList.do")
	public String downloadCNList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		String url= "/report/downloadCNList";		
		try{
				Map setMap = new HashMap();
				model.put("itemTypeCode", request.getParameter("itemTypeCode"));
				model.put("s_itemID", commandMap.get("s_itemID"));
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
		} catch(Exception e) {
			System.out.println(e.toString());
		}
		
		return nextUrl(url);
	}
	
	// TODO : 매핑항목 리스트 팝업
	@RequestMapping(value="/downloadCNCountPop.do")
	public String downloadCNCountPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		String url= "/report/downloadCNCountPop";
		
		try{
				Map setMap = new HashMap();
				setMap.put("s_itemID", commandMap.get("itemID"));
				String itemTypeCode = commonService.selectString("config_SQL.getItemTypeCodeItemID", setMap);
				
				model.put("itemTypeCode", itemTypeCode);
				model.put("s_itemID", commandMap.get("s_itemID"));
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
			
		} catch(Exception e) {
			System.out.println(e.toString());
		}
		
		return nextUrl(url);
	}
	
	private List removeAllHtmlTag(List List) {
		List resultList = new ArrayList();
		for (int i = 0; i < List.size(); i++) {
			Map listMap = new HashMap();
			listMap = (Map) List.get(i);
			String description = "";
			if (null != listMap.get("Description")) {
				description = listMap.get("Description").toString().replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
			}
			listMap.put("StringDescription", description);
			resultList.add(listMap);
		}
		
		return resultList;
	}
	
	private List removeAllHtmlTagAndSetAttrInfo(List List, Map map) {
		List resultList = new ArrayList();
		
		if (List.size() == 0) {
			resultList.add(map);
		} else {
			for (int i = 0; i < List.size(); i++) {
				Map listMap = new HashMap();
				listMap = (Map) List.get(i);
				String description = "";
				if (null != map.get("ProcessInfo")) {
					description = map.get("ProcessInfo").toString().replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
				}
				
				listMap.put("ProcessInfo", description);
				
				if (null != map.get("ClassName")) {
					listMap.put("ClassName", map.get("ClassName").toString());
				}
				
				if (null != map.get("ItemID")) {
					listMap.put("ItemID", map.get("ItemID").toString());
				}
				
				if (null != map.get("ItemName")) {
					listMap.put("ItemName", map.get("ItemName").toString());
				}
				
				resultList.add(listMap);
			}
		}
		
		return resultList;
	}
	
	private Map removeAllHtmlTagAndSetAttrInfo(Map map) {
		String description = "";
		Map listMap = new HashMap();
		
		if (null != map.get("ProcessInfo")) {
			description = map.get("ProcessInfo").toString().replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
		}
		
		listMap.put("ProcessInfo", description);
		
		if (null != map.get("ClassName")) {
			listMap.put("ClassName", map.get("ClassName").toString());
		}
		
		if (null != map.get("s_itemID")) {
			listMap.put("s_itemID", map.get("s_itemID").toString());
		}
		
		if (null != map.get("Identifier")) {
			listMap.put("Identifier", map.get("Identifier").toString());
		}
		
		if (null != map.get("ItemName")) {
			listMap.put("ItemName", map.get("ItemName").toString());
		}
		
		if (null != map.get("LastUpdated")) {
			listMap.put("LastUpdated", map.get("LastUpdated").toString());
		}
		
		return listMap;
	}

	protected Map fetchRowData(Map map, int index) throws Exception{
		Map result = new HashMap();
		int colNum = NumberUtil.getIntValue(map.get("colNum"));
		String[]cols = ((String) map.get("colName")).split("[|]");

		for(int i = 1; i < colNum; i++) {
			result.put(cols[i-1], map.get("r"+index+"_col"+i));
		}
		result.put(CommonMsDao.SQL_TYPE, map.get("r"+index+"_type"));
		if (map.get("loginInfo")!=null) {
			result.putAll((Map)map.get("loginInfo"));
		}
		return result;
	}
	
	// 선택한 엑셀파일 읽어오기
	private Map getItemList(File excelFile, HashMap commandFileMap, HashMap commandMap, BufferedWriter errorLog) throws Exception {
		Map excelMap = new HashMap();
		
		XSSFWorkbook workbook  =  new XSSFWorkbook(new FileInputStream(excelFile));
		XSSFSheet sheet    =  null;
	    
		try{
			
			sheet = workbook.getSheetAt(0);  // 첫번째 sheet의 데이터 취득

			
			int rowCount = sheet.getPhysicalNumberOfRows();;

			if( rowCount <= 1 ){
				throw new Exception("There is not data in excel file.");
			}
			
			if (commandFileMap.get("uploadTemplate").equals("1") || commandFileMap.get("uploadTemplate").equals("2")) {
				// 새로운 구조 업로드, 기존 속성 업데이트
				excelMap = setUploadMapNew(sheet, commandFileMap.get("uploadTemplate").toString(), commandFileMap.get("uploadOption").toString(), commandMap, errorLog);
				
			} else if (commandFileMap.get("uploadTemplate").equals("3")) {
				// 관련항목 Mapping
				excelMap = setUploadMapConnection(sheet, commandFileMap.get("uploadOption").toString(), commandMap, errorLog);
				
			} else if (commandFileMap.get("uploadTemplate").equals("4")) {
				// Dimension Mapping
				excelMap = setUploadMapDimension(sheet, commandFileMap.get("uploadOption").toString(), commandMap, errorLog);
			
			} else if (commandFileMap.get("uploadTemplate").equals("10")) {
				// Item Team Mapping
				excelMap = setUploadMapItemTeam(sheet, commandFileMap.get("uploadOption").toString(), commandMap, errorLog);
			
			} else if (commandFileMap.get("uploadTemplate").equals("11")) {
				// Item Member Mapping
				excelMap = setUploadMapItemMember(sheet, commandFileMap.get("uploadOption").toString(), commandMap, errorLog);
			}				
			
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
	
	// TODO : 개행 코드 삭제
	private String removeAllTag(String str) {
		str = str.replaceAll("\n", "&&rn");//201610 new line :: Excel To DB 
		str = str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#10;", " ").replace("&#xa;", "").replace("&nbsp;", " ");
		//return str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#10;", " ").replace("&#xa;", "").replace("&nbsp;", " ");
		return StringEscapeUtils.unescapeHtml4(str);
	}
	private String removeAllTag(String str,String type) { 
		if(type.equals("DbToEx")){//201610 new line :: DB To Excel
			str = str.replaceAll("\r\n", "&&rn").replaceAll("&gt;", ">").replaceAll("&lt;", "<").replaceAll("&#40;", "(").replaceAll("&#41;", ")").replace("&sect;","-").replaceAll("<br/>", "&&rn").replaceAll("<br />", "&&rn");
		}else{
			str = str.replaceAll("\n", "&&rn");//201610 new line :: Excel To DB 
		}
		str = str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#10;", " ").replace("&#xa;", "").replace("&nbsp;", " ").replace("&amp;", "&");
		if(type.equals("DbToEx")){
			str = str.replaceAll("&&rn", "\n");
		}
		//return str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#10;", " ").replace("&#xa;", "").replace("&nbsp;", " ");
		return StringEscapeUtils.unescapeHtml4(str);
	}	
	
	/**
	 * [새로운 구조 업로드][속성 업데이트] 읽어들인 템플릿의 정보를 Map에 저장
	 * 
	 * @param sheet
	 * @param temp
	 * @param option
	 * @return 템플릿의 정보 Map
	 * @throws Exception 
	 */
	private Map setUploadMapNew(XSSFSheet sheet, String temp, String option, HashMap commandMap, BufferedWriter errorLog) throws Exception {
		Map excelMap = new HashMap();
		
		String colsName = "";
		int attrTypeColNum = 1;
		String[][] data	= null;
		List list = new ArrayList();
		List identifierList = new ArrayList();
		
		int valCnt = 0;
		int totalCnt = 0;
		
		int rowCount  =  sheet.getPhysicalNumberOfRows();
		int colCount = sheet.getRow(0).getPhysicalNumberOfCells();
	
		int numberOfRowsWithData = 0;
		Iterator<Row> rowIterator = sheet.iterator();

		while (rowIterator.hasNext()) {
		    Row row = rowIterator.next();
		    if (row.getPhysicalNumberOfCells() > 0) {
		        // 빈 행이 아닌 경우에만 세기
		        numberOfRowsWithData++;
		    }
		}

		rowCount = numberOfRowsWithData;
		
		data = new String[rowCount][colCount];
		
		XSSFRow row     =  null;
	    XSSFCell cell    =  null;
	    
	    String langCode = String.valueOf(commandMap.get("sessionCurrLangCode"));
		
		for(int i = 0; i < rowCount; i ++){
			
			row = sheet.getRow(i);
			//colCount   =  row.getPhysicalNumberOfCells();
			
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
				
				// 첫번째 row에서 AttrTypeCode를 취득
				// 템플릿 상에서 5번째 칼럼 부터 AttrTypeCode를 설정 해 줌 
				if (i == 0 && j > 3) {
					/* AttrTypeCode 필수 체크 */
					if (data[i][j].isEmpty()) {
						//excelMap.put("msg", (j + 1) + "열의 타이틀에  AttrTypeCode를 입력해 주세요.");
						excelMap.put("msg", MessageHandler.getMessage(langCode + ".WM00110", new String[]{String.valueOf(j + 1), "AttrTypeCode"}));
						errorLog.write(MessageHandler.getMessage(langCode + ".WM00110", new String[]{String.valueOf(j + 1), "AttrTypeCode"})); 
						errorLog.newLine();
						//break;
					}
					excelMap.put("AttrTypeCode" + (j - 3), data[i][j]);
					colsName = colsName + "|" + "newPlainText" + (j - 3);
					attrTypeColNum ++;
				}
			}
			
			if(i > 1){
				
				// 데이터 입력 체크
				String msg = checkValueForUploadNew(i, data, temp, option, identifierList, langCode, errorLog);
				if (!msg.isEmpty()) {
					excelMap.put("msg", msg);
				}
				
				// 새로운 템플렛 적용
				Map map = new HashMap();
				map.put("RNUM"					, i-1);
				map.put("newParentIdentifier"	, data[i][0]);
				map.put("newItemId"	            , data[i][1]);
				map.put("newIdentifier"			, data[i][2]);
				map.put("newClassCode"			, data[i][3]);
				for (int j = 1; j < attrTypeColNum; j ++) {
					// AttrTypeCode:PlanText[ex)AT00001::구매]
					map.put("newPlainText" + j, replaceSingleQuotation(excelMap.get("AttrTypeCode" + j).toString() + "::" + removeAllTag(StringUtil.checkNull(data[i][3+j]))));
				}
			
				if (data[i][0].equals(data[i][2])) { /* ParentID == Identifier 중복 체크*/					
				}else if(msg.equals("")){ 
					
					identifierList.add(data[i][2]);// 해당 행의 identifier를 identifier의 리스트에 추가(identifier의 중복 체크 처리를 위해)
					list.add(map); 
					++valCnt;
				}
				
				/*
				 * if (msg.isEmpty()) { ++valCnt; }
				 */
				++totalCnt ;
				msg = "";
			}
			
//			if (excelMap.get("msg") != null) {
//				break;
//			}
		}
		
		excelMap.put("list", list);
		excelMap.put("validCnt", valCnt);
		excelMap.put("totalCnt", totalCnt);
		excelMap.put("attrTypeCodeCnt", attrTypeColNum);
		excelMap.put("colsName", "newParentIdentifier|newItemId|newIdentifier|newClassCode" + colsName);

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
	private String checkValueForUploadNew(int i, String[][] data, String temp, String option, List identifierList, String langCode, BufferedWriter errorLog) throws Exception {
		String msg = "";
		Map commandMap = new HashMap();
		
		// 엑셀에서 읽어 들인 데이터의 입력 체크처리
		if (temp.equals("1")) {
			/* ParentIdentifier 필수 체크 (읽어 들인 파일내에) */
			if (!data[i][0].isEmpty()) {
				if (!identifierList.contains(data[i][0])) {
					msg = MessageHandler.getMessage(langCode + ".WM00111", new String[]{String.valueOf(i + 1), "ParentIdentifier"});
					errorLog.write(msg); 
					errorLog.newLine();
					//return msg;
				}
			}
			/* CSR ID DB 존재 체크 */
			if (!data[i][1].isEmpty()) {
				commandMap.put("ProjectID", data[i][1]);
				String cnt = StringUtil.checkNull(commonService.selectString("report_SQL.getCSRCnt", commandMap));
				if (cnt.equals("0")) {
					//msg = (i + 1) + "행의 CSR ID가 데이터베이스에 존재 하지 않습니다..";
					msg = MessageHandler.getMessage(langCode + ".WM00108", new String[]{String.valueOf(i + 1), "CSR ID"});
					errorLog.write(msg);
					errorLog.newLine();
				}
			}
			/* Identifier 필수 체크 */
			if (data[i][2].isEmpty()) {
				//msg = (i + 1) + "행의 Identifier를 입력해 주세요.";
				msg = MessageHandler.getMessage(langCode + ".WM00107", new String[]{String.valueOf(i + 1), "Identifier"});
				errorLog.write(msg); 
				errorLog.newLine();
				//return msg;
			}
			/* Identifier 중복 체크 */
			if (identifierList.contains(data[i][2])) {
				//msg = (i + 1) + "행의 Identifier는 이미 사용된 Identifier입니다.";
				msg = MessageHandler.getMessage(langCode + ".WM00109", new String[]{String.valueOf(i + 1), "Identifier"});
				errorLog.write(msg); 
				errorLog.newLine();
				//return msg;
			}

			/* ParentID == Identifier 중복 체크 */
			if (data[i][0].equals(data[i][2])) {
				//msg = (i + 1) + "행의 Identifier는 이미 사용된 Identifier입니다.";
				msg = MessageHandler.getMessage(langCode + ".WM00109", new String[]{String.valueOf(i + 1), "Identifier"});
				errorLog.write(msg); 
				errorLog.newLine();
				//return msg;
			}			
			
		} else {
			if (option.equals("1")) {
				// 업로드 option  [ItemId]를 선택한경우
				/* ItemId 필수 체크 */
				if (data[i][0].isEmpty()) {
					//msg = (i + 1) + "행의 ItemId를 입력해 주세요.";
					msg = MessageHandler.getMessage(langCode + ".WM00107", new String[]{String.valueOf(i + 1), " ItemId"});
					errorLog.write(msg); 
					errorLog.newLine();
					//return msg;
				} else {
					/* ItemId 존재 체크 */
					commandMap.put("ItemID", data[i][0]);
					String cnt = StringUtil.checkNull(commonService.selectString("report_SQL.getCountWithItemId", commandMap));
					if (cnt.equals("0")) {
						//msg = (i + 1) + "행의 ItemId가 데이터베이스에 존재 하지 않습니다..";
						msg = MessageHandler.getMessage(langCode + ".WM00108", new String[]{String.valueOf(i + 1), " ItemId"});
						errorLog.write(msg); 
						errorLog.newLine();
						//return msg;
					}
				}
			} else {
				// 업로드 option   [Identifier]를 선택한경우
				/* Identifier 필수 체크 */
				if (data[i][2].isEmpty()) {
					//msg = (i + 1) + "행의 Identifier를 입력해 주세요.";
					msg = MessageHandler.getMessage(langCode + ".WM00107", new String[]{String.valueOf(i + 1), "Identifier"});
					errorLog.write(msg); 
					errorLog.newLine();
					//return msg;
				} else {
					/* Identifier 존재 체크 */
					commandMap.put("Identifier", data[i][2]); 
					commandMap.put("ClassCode", data[i][3]); 
					String cnt = StringUtil.checkNull(commonService.selectString("report_SQL.getCountWithIdentifier", commandMap));
					if (cnt.equals("0")) {
						//msg = (i + 1) + "행의 Identifier가 데이터베이스에 존재 하지 않습니다..";
						msg = MessageHandler.getMessage(langCode + ".WM00108", new String[]{String.valueOf(i + 1), "Identifier"});
						errorLog.write(msg); 
						errorLog.newLine();					
					}					
				}
				
			}
		}
		
		/* ClassCode 필수 체크 */
		if (data[i][3].isEmpty()) {
			//msg = (i + 1) + "행의 ClassCode를 입력해 주세요.";
			msg = MessageHandler.getMessage(langCode + ".WM00107", new String[]{String.valueOf(i + 1), "ClassCode"});
			errorLog.write(msg); 
			errorLog.newLine();
			//return msg;
		}
		/* plainText 필수 체크 */
		if (data[i][4].isEmpty() && data[i][5].isEmpty()) {
			//msg = (i + 1) + "행의 plainText를 입력해 주세요.";
			msg = MessageHandler.getMessage(langCode + ".WM00107", new String[]{String.valueOf(i + 1), "plainText"});
			errorLog.write(msg); 
			errorLog.newLine();
			//return msg;
		}
		
		return msg;
	}
	
	/**
	 * [CBO List 업로드] 읽어들인 템플릿의 정보를 Map에 저장
	 * 
	 * @param sheet
	 * @return 템플릿의 정보 Map
	 * @throws Exception 
	 */
	private Map setUploadMapCboList(XSSFSheet sheet) throws Exception {
		Map excelMap = new HashMap();
		
		String colsName = "newParentIdentifier|newProcessID|newItemName|newName|newCBOType|newCBOId|" 
						+ "newCatagory|newDSAP|newPeriod|newDifficulty|newImportance|newPriority|newProductionCosts|" 
						+ "newSystem|newModule|newProgramID|newTCode|newNote";
		int attrTypeColNum = 1;
		List list = new ArrayList();
		
		int valCnt = 0;
		int rowCount  =  sheet.getPhysicalNumberOfRows();
		
		XSSFRow row     =  null;
	    XSSFCell cell    =  null;
	    String parentIdentifier = "";
	    
	    // 입력 값 체크
	    String msg = checkValueForUploadCboList(sheet, rowCount);
	    if (!msg.isEmpty()) {
	    	excelMap.put("msg", msg);
	    }
		
	    if (excelMap.get("msg") == null) {
	    	
	    	// 4번째 줄 Title
			// 5번째 줄 부터 데이터를 읽어 들임
	    	for(int i = 4; i < rowCount; i ++){
				
				row = sheet.getRow(i);
				int colCount   =  row.getPhysicalNumberOfCells();
				
				Map map = new HashMap();
				int kbn = 0;
				
				for(int j = 0; j < colCount; j ++) {
					cell	= row.getCell(j);
					
					if (i == 4 && j == 0) {
						parentIdentifier = String.valueOf(cell); 
					}
					
					map.put("RNUM"					, i - 3);
					
					if (j == 0) {
						if (StringUtil.checkNull(cell).isEmpty() || !parentIdentifier.equals(String.valueOf(cell))) {
							kbn = 1;
							break;
						}
						
						map.put("newParentIdentifier"	, cell);   // ParentID	
					}
					
					if (j == 3) { map.put("newProcessID"	    , cell); }  // Process ID
					if (j == 4) { map.put("newItemName"		, cell); }  // Process 명
					if (j == 6) { map.put("newName"			    , cell); }  // 개발항목
					if (j == 7) { map.put("newCBOType"			, cell); }  // CBO Type
					if (j == 8) { map.put("newCBOId"			, cell.getRawValue()); }  // CBO ID
					if (j == 9) { map.put("newCatagory"	        , cell); }  // 개발 유형
					if (j == 10) { map.put("newDSAP"			, cell); }  // 개발대상SAP
					if (j == 11) { map.put("newPeriod"			, cell); }  // 사용 기간
					
					if (j == 14) { map.put("newDifficulty"	    , cell); }  // 난이도
					if (j == 15) { map.put("newImportance"		, cell); }  // 중요도
					if (j == 16) { map.put("newPriority"	    , cell); }  // 우선순위
					if (j == 17) { map.put("newProductionCosts" , cell); }  // 개발공수
					if (j == 18) { map.put("newSystem"			, cell); }  // 관련시스템
					if (j == 19) { map.put("newModule"			, cell); }  // 연관모듈
					
					if (j == 45) { map.put("newProgramID"		, cell); }  // Program ID
					if (j == 46) { map.put("newTCode"			, cell); }  // T-Code
					if (j == 47) { map.put("newNote"			, StringUtil.checkNull(cell, "").replace("<br/>", "")); }  // 비고
		 			
				}
				
				if (kbn == 0) {
					list.add(map);
				}
				
				++valCnt;
				
			}
	    }
	
		excelMap.put("list", list);
		excelMap.put("validCnt", valCnt);
		excelMap.put("totalCnt", valCnt);
		excelMap.put("attrTypeCodeCnt", attrTypeColNum);
		excelMap.put("colsName", colsName);

		return excelMap;
	}
	
	/**
	 * [CBO List 업로드] 읽어들인 템플릿의 정보의 필수 체크와 DB존재 체크
	 * 
	 * @param sheet  읽어들일 Excel 해당 sheet
	 * @param rowCount 읽어 들일 row Count
	 * @return 에러메세지 msg 
	 * @throws Exception 
	 */
	private String checkValueForUploadCboList(XSSFSheet sheet, int rowCount) throws Exception {
		String msg = "";
		Map commandMap = new HashMap();
		
		XSSFRow row     =  null;
	    XSSFCell cell    =  null;
	    
	    String parentIdentifier = "";
		
	    for(int i = 4; i < rowCount; i ++){
			
			row = sheet.getRow(i);
			int colCount   =  row.getPhysicalNumberOfCells();
			
			Map map = new HashMap();
			int kbn = 0;
			
			for(int j = 0; j < colCount; j ++) {
				cell	= row.getCell(j);
				
				if (i == 4 && j == 0) {
					parentIdentifier = String.valueOf(cell); 
				}
				
				if (j == 0) {
					if (StringUtil.checkNull(cell).isEmpty() || !parentIdentifier.equals(String.valueOf(cell))) {
						kbn = 1;
						break;
					}
					
					if (StringUtil.checkNull(cell).isEmpty()) {
						msg = (i + 1) + "행의 [모듈/시스템]을 입력해 주세요.";
						return msg;
					}
					
				}
				
				// 개발항목
				if (j == 6) {
					if (StringUtil.checkNull(cell).isEmpty()) {
						msg = (i + 1) + "행의 [개발항목]을 입력해 주세요.";
						return msg;
					} 
				}  
				// CBO Type
				if (j == 7) {
					if (StringUtil.checkNull(cell).isEmpty()) {
						msg = (i + 1) + "행의 [CBO Type]을 입력해 주세요.";
						return msg;
					} 
				} 
				
				// CBO ID
				if (j == 8) {
					if (StringUtil.checkNull(cell).isEmpty()) {
						msg = (i + 1) + "행의 [CBO ID]을 입력해 주세요.";
						return msg;
					}  
				}  
				
			}
	    
	    }
	    
		return msg;
	}
	
	/**
	 * [IF Master 업로드] 읽어들인 템플릿의 정보를 Map에 저장
	 * 
	 * @param sheet
	 * @param colCount
	 * @param rowCount
	 * @param temp
	 * @param option
	 * @return 템플릿의 정보 Map
	 * @throws Exception 
	 */
	private Map setUploadMapIfMaster(XSSFSheet sheet) throws Exception {
		Map excelMap = new HashMap();
		
		String colsName = "newParentIdentifier|newInterfaceID|newGroupName|newKanri|newTani|newSub|" 
						+ "newIfName|newCboId|newProgramID|newProcessId|newItemName|newVariant|newGapId|" 
						+ "newDSAP|newPeriod|newInOut|newOnLineOrBatch|newIfPeriod|newErp|newRfcDestination|newMw|newLegacy|" 
						+ "newErpType|newMwType|newLegacyType|newErpTanto|newMwTanto|newLegacyTanto|"
						+ "newErpStatus|newMwStatus|newLegacyStatus|newTotalStatus|newTestPeriod|newIssue|newNote";
		int attrTypeColNum = 1;
		List list = new ArrayList();
		
		int valCnt = 0;
		int rowCount  =  sheet.getPhysicalNumberOfRows();
		
		XSSFRow row     =  null;
	    XSSFCell cell    =  null;
	    String parentIdentifier = "";
	    
	    // TODO: 입력 값 체크
	    String msg = checkValueForUploadIfMaster(sheet, rowCount);
	    if (!msg.isEmpty()) {
	    	excelMap.put("msg", msg);
	    }
		
	    if (excelMap.get("msg") == null) {
	    	
	    	// 4번째 줄 Title
			// 5번째 줄 부터 데이터를 읽어 들임
	    	for(int i = 4; i < rowCount; i ++){
				
				row = sheet.getRow(i);
				int colCount   =  row.getPhysicalNumberOfCells();
				
				Map map = new HashMap();
				int kbn = 0;
				
				for(int j = 0; j < colCount; j ++) {
					cell	= row.getCell(j);
					
					if (i == 4 && j == 0) {
						parentIdentifier = String.valueOf(cell); 
					}
					
					map.put("RNUM"					, i - 3);
					
					if (j == 0) {
						if (StringUtil.checkNull(cell).isEmpty() || !parentIdentifier.equals(String.valueOf(cell))) {
							kbn = 1;
							break;
						}
						
						map.put("newParentIdentifier"	, cell);   // ParentID	
					}
					
					if (j == 1) { map.put("newInterfaceID"	    , cell.getRawValue()); }  // Interface ID
					if (j == 2) { map.put("newGroupName"		, cell); }  // 그룹명
					if (j == 3) { map.put("newKanri"			, cell); }  // 관리주체
					if (j == 4) { map.put("newTani"			    , cell); }  // 단위시스템
					if (j == 5) { map.put("newSub"				, cell); }  // 서브시스템
					if (j == 6) { map.put("newIfName"	        , cell); }  // IF 항목명
					if (j == 7) { map.put("newCboId"			, cell); }  // CBO ID
					if (j == 8) { map.put("newProgramID"		, cell); }  // Program ID
					if (j == 9) { map.put("newProcessId"		, cell); }  // Process ID
					if (j == 10) { map.put("newItemName"		, cell); }  // Process Name
					if (j == 11) { map.put("newVariant"			, cell); }  // Variant
					if (j == 12) { map.put("newGapId"			, cell); }  // Gap ID
					if (j == 13) { map.put("newDSAP"			, cell); }  // 개발대상 SAP
					if (j == 14) { map.put("newPeriod"			, cell); }  // 사용 기간
					if (j == 15) { map.put("newInOut"	    	, cell); }  // In/Out
					if (j == 16) { map.put("newOnLineOrBatch"	, cell); }  // OnLine or Batch
					if (j == 17) { map.put("newIfPeriod"	    , cell); }  // I/F 주기
					if (j == 18) { map.put("newErp" 			, cell); }  // ERP
					if (j == 19) { map.put("newRfcDestination"	, cell); }  // RFC Destination
					if (j == 20) { map.put("newMw"				, cell); }  // M/W
					if (j == 21) { map.put("newLegacy"			, cell); }  // Legacy
					if (j == 22) { map.put("newErpType"			, cell); }  // ERP TYPE
					if (j == 23) { map.put("newMwType"			, cell); }  // M/W Type
					if (j == 24) { map.put("newLegacyType"		, cell); }  // Legacy Type
					if (j == 25) { map.put("newErpTanto"		, cell); }  // ERP담당
					if (j == 26) { map.put("newMwTanto"			, cell); }  // M/W담당
					if (j == 27) { map.put("newLegacyTanto"		, cell); }  // Legacy 담당
					if (j == 28) { map.put("newErpStatus"		, cell); }  // ERP Status
					if (j == 29) { map.put("newMwStatus"		, cell); }  // M/W Status
					if (j == 30) { map.put("newLegacyStatus"	, cell); }  // Legacy Status
					if (j == 31) { map.put("newTotalStatus"		, cell); }  // Total Status
					if (j == 32) { map.put("newTestPeriod"		, cell); }  // 통합테스트 시기
					
					if (j == 56) { map.put("newIssue"			, StringUtil.checkNull(cell, "").replace("<br/>", "")); }  // 고려사항 및 이슈
					if (j == 57) { map.put("newNote"			, StringUtil.checkNull(cell, "").replace("<br/>", "")); }  // 비고
		 			
				}
				
				if (kbn == 0) {
					list.add(map);
				}
				
				++valCnt;
				
			}
	    }
	
		excelMap.put("list", list);
		excelMap.put("validCnt", valCnt);
		excelMap.put("totalCnt", valCnt);
		excelMap.put("attrTypeCodeCnt", attrTypeColNum);
		excelMap.put("colsName", colsName);

		return excelMap;
	}
	
	/**
	 * [IF Master 업로드] 읽어들인 템플릿의 정보의 필수 체크와 DB존재 체크
	 * 
	 * @param sheet  읽어들일 Excel 해당 sheet
	 * @param rowCount 읽어 들일 row Count
	 * @return 에러메세지 msg 
	 * @throws Exception 
	 */
	private String checkValueForUploadIfMaster(XSSFSheet sheet, int rowCount) throws Exception {
		String msg = "";
		Map commandMap = new HashMap();
		
		XSSFRow row     =  null;
	    XSSFCell cell    =  null;
	    
	    String parentIdentifier = "";
		
	    for(int i = 4; i < rowCount; i ++){
			
			row = sheet.getRow(i);
			int colCount   =  row.getPhysicalNumberOfCells();
			
			Map map = new HashMap();
			int kbn = 0;
			
			for(int j = 0; j < colCount; j ++) {
				cell	= row.getCell(j);
				
				if (i == 4 && j == 0) {
					parentIdentifier = String.valueOf(cell); 
				}
				
				if (j == 0) {
					if (StringUtil.checkNull(cell).isEmpty() || !parentIdentifier.equals(String.valueOf(cell))) {
						kbn = 1;
						break;
					}
					
					if (StringUtil.checkNull(cell).isEmpty()) {
						msg = (i + 1) + "행의 [모듈/시스템]을 입력해 주세요.";
						return msg;
					}
					
				}
				
				// Interface ID
				if (j == 1) {
					if (StringUtil.checkNull(cell).isEmpty()) {
						msg = (i + 1) + "행의 [Interface ID]을 입력해 주세요.";
						return msg;
					} 
				}  
				
				// I/F 항목 명
				if (j == 6) {
					if (StringUtil.checkNull(cell).isEmpty()) {
						msg = (i + 1) + "행의 [I/F 항목 명]을 입력해 주세요.";
						return msg;
					} 
				}  
				
			}
	    
	    }
	    
		return msg;
	}
	
	/**
	 * [전사 시스템 목록 업로드] 읽어들인 템플릿의 정보를 Map에 저장
	 * 
	 * @param sheet
	 * @return 템플릿의 정보 Map
	 * @throws Exception 
	 */
	private Map setUploadWholeCompanySystemItem(XSSFSheet sheet) throws Exception {
		Map excelMap = new HashMap();
		
		String colsName = "newParentIdentifier|newTaniSystemE|newTaniSystemK|newSystemOverview|newDate|newGenPart|newUserNum|newHidm|newSso|"
				 + "newSubSystemE|newSubSystemK|newWorkArea|newGroup|newUneiTeam|newUneiPart|newPL|newItTanto|newNewSmTanto|"
				 + "newOldSmTamto|newService1|newService2|newService3|newUrl";
		
		int attrTypeColNum = 1;
		List list = new ArrayList();
		
		int valCnt = 0;
		int rowCount  =  sheet.getPhysicalNumberOfRows();
		
		XSSFRow row     =  null;
	    XSSFCell cell    =  null;
	    
	    String parentIdentifier = ""; 
	    
	    // TODO : 입력 값 체크
//	    String msg = checkValueForUploadCboList(sheet, rowCount);
//	    if (!msg.isEmpty()) {
//	    	excelMap.put("msg", msg);
//	    }
		
	    if (excelMap.get("msg") == null) {
	    	
	    	// 3번째 줄 Title
			// 4번째 줄 부터 데이터를 읽어 들임
	    	for(int i = 3; i < rowCount; i ++){
				
				row = sheet.getRow(i);
				int colCount   =  row.getPhysicalNumberOfCells();
				
				Map map = new HashMap();
				
				for(int j = 0; j < colCount; j ++) {
					cell	= row.getCell(j);
					
					map.put("RNUM"					, i - 2);
					
					if (j == 1) { map.put("newParentIdentifier"	, setCell(cell)); }  // 시스템그룹
					if (j == 4) { map.put("newTaniSystemE"		, setCell(cell)); }  // 단위시스템영문	
					if (j == 5) { map.put("newTaniSystemK"	    , setCell(cell)); }  // 단위시스템한글
					if (j == 6) { map.put("newSystemOverview"	, setCell(cell)); }  // 시스템 설명
					if (j == 7) { map.put("newDate"			    , setDateYyyymmdd(cell, "yyyy-MM")); }  // 구축시기
					if (j == 8) { map.put("newGenPart"			, setCell(cell)); }  // 현업 부서
					if (j == 9) { map.put("newUserNum"			, setCell(cell)); }  // 사용자 수
					if (j == 10) { map.put("newHidm"			, setCell(cell)); }  // HIDM 적용
					if (j == 11) { map.put("newSso"	        	, setCell(cell)); }  // SSO 적용
					
					if (j == 12) { map.put("newSubSystemE"		, setCell(cell)); }  // 서브시스템 영문
					if (j == 13) { map.put("newSubSystemK"		, setCell(cell)); }  // 서브시스템 한글
					if (j == 14) { map.put("newWorkArea"		, setCell(cell)); }  // 업무영역
					if (j == 15) { map.put("newGroup"			, setCell(cell)); }  // 그룹
					if (j == 16) { map.put("newUneiTeam"	    , setCell(cell)); }  // 운영팀
					if (j == 17) { map.put("newUneiPart"		, setCell(cell)); }  // 운영파트
					if (j == 18) { map.put("newPL"	    		, setCell(cell)); }  // PL
					if (j == 19) { map.put("newItTanto" 		, setCell(cell)); }  // IT담당자
					if (j == 20) { map.put("newNewSmTanto"		, setCell(cell)); }  // 신규SM담당자
					if (j == 21) { map.put("newOldSmTamto"		, setCell(cell)); }  // 기존SM담당자
					if (j == 22) { map.put("newService1"		, setCell(cell)); }  // 서비스 범위(본사)
					if (j == 23) { map.put("newService2"		, setCell(cell)); }  // 서비스 범위(범인)
					if (j == 24) { map.put("newService3"		, setCell(cell)); }  // 서비스 범위(기타)
					if (j == 25) { map.put("newUrl"		, setCell(cell)); }  // URL
					
				}
				
				list.add(map);
				
				++valCnt;
				
			}
	    }
	
		excelMap.put("list", list);
		excelMap.put("validCnt", valCnt);
		excelMap.put("totalCnt", valCnt);
		excelMap.put("attrTypeCodeCnt", attrTypeColNum);
		excelMap.put("colsName", colsName);

		return excelMap;
	}
	
	// TODO :
	private String setCell(XSSFCell cell) {
		 return StringUtil.checkNull(cell).replaceAll(System.getProperty("line.separator"), "");
	}
	
	/**
	 * [관련항목 매핑] 읽어들인 템플릿의 정보를 Map에 저장
	 * 
	 * @param sheet
	 * @param colCount
	 * @param rowCount
	 * @param option
	 * @return 템플릿의 정보 Map
	 * @throws Exception
	 */
	private Map setUploadMapConnection(XSSFSheet sheet, String option, HashMap commandMap, BufferedWriter errorLog)throws Exception {
		Map excelMap = new HashMap();

		int attrTypeColNum = 1;
		String[][] data = null;
		List list = new ArrayList();
		int valCnt = 0;
		int totalCnt = 0;

		int rowCount = sheet.getPhysicalNumberOfRows();
		int colCount = sheet.getRow(0).getPhysicalNumberOfCells();

		data = new String[rowCount][colCount];

		XSSFRow row = null;
		XSSFCell cell = null;

		String langCode = String.valueOf(commandMap.get("sessionCurrLangCode"));

		for (int i = 0; i < rowCount; i++) {

			row = sheet.getRow(i);
			colCount = row.getPhysicalNumberOfCells();

			for (int j = 0; j < colCount; j++) {
				cell = row.getCell(j);

				// TODO:
				if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
					data[i][j] = StringUtil.checkNull(cell.getRawValue());
				} else {
					data[i][j] = StringUtil.checkNull(cell);
				}

				// data[i][j] = StringUtil.checkNull(cell);
			}
			
			if (i > 0) {
				Map setData = new HashMap();
				// 데이터 입력 체크
				String msg = checkValueForConnection(i, data, option, langCode, errorLog);
				if (!msg.isEmpty()) {
					excelMap.put("msg", msg);
				}
				
				String fromItemID = data[i][0];
				String toItemID = data[i][3];
				String check = "Y";
				// 엑셀에서 읽어 들인 데이터의 입력 체크처리
				if (option.equals("1")) { // option [ItemId]를 선택한경우
					setData.put("ItemID", fromItemID);
					String cnt = StringUtil.checkNull(commonService.selectString("report_SQL.getCountWithItemId", setData));
					if(cnt.equals("0")) {
						check = "N";
					}
					setData.put("ItemID", toItemID);				
					cnt = StringUtil.checkNull(commonService.selectString("report_SQL.getCountWithItemId", setData));
					if(cnt.equals("0")) {
						check = "N";
					}
				} else {
					// 업로드 option [Identifier]를 선택한경우
					/* Identifier 존재 체크 */
					setData.put("Identifier", data[i][0]);
					setData.put("ClassCode", data[i][1]);
					fromItemID = StringUtil.checkNull(commonService.selectString("report_SQL.getItemIdWithIdentifier", setData));
					
					setData.put("Identifier", data[i][3]);
					setData.put("ClassCode", data[i][4]);
					toItemID = StringUtil.checkNull(commonService.selectString("report_SQL.getItemIdWithIdentifier", setData));
					
					if (fromItemID.equals("") ) {
						check = "N";
					}
					if(toItemID.equals("")) {
						check = "N";
					}
				}
				
				// connection 중복 체크
				setData.put("ClassCode", data[i][6]);
				String cxnTypeCode = StringUtil.checkNull(commonService.selectString("item_SQL.getItemTypeCodeFromClassCode", setData)); 
				
				setData.put("FromItemID", fromItemID);
				setData.put("ToItemID", toItemID);
				setData.put("ItemTypeCode", cxnTypeCode);
				setData.put("deleted", "1");
				
				String cxnItem = StringUtil.checkNull(commonService.selectString("item_SQL.getConItemID", setData)); // deleted // != 0
				if (!cxnItem.equals("")) {
					check = "N";
				}

				// 새로운 템플렛 적용
				Map map = new HashMap();

				map.put("RNUM", i);
				map.put("newFromItemId", data[i][0]);
				map.put("newFromClassCode", data[i][1]);
				map.put("newFromName", replaceSingleQuotation(data[i][2]));
				map.put("newToItemId", data[i][3]);
				map.put("newToClassCode", data[i][4]);
				map.put("newToName", replaceSingleQuotation(data[i][5]));
				map.put("newConnectionClassCode", data[i][6]);
				
				if(check.equals("Y")) {
					list.add(map);
				}
				++valCnt;
			}
			++totalCnt;
		}

		excelMap.put("list", list);
		excelMap.put("validCnt", list.size());
		excelMap.put("totalCnt", valCnt);
		excelMap.put("attrTypeCodeCnt", attrTypeColNum);
		excelMap.put("colsName", "newFromItemId|newFromClassCode|newFromName|newToItemId|newToClassCode|newToName|newConnectionClassCode");

		return excelMap;
	}

	/**
	 *  [관련항목 매핑]  읽어들인 템플릿의 정보의 필수 체크와 DB존재 체크
	 * 
	 * @param i  처리행수
	 * @param data 처리행의 각 칼럼 데이터
	 * @param option
	 * @return 에러메세지 msg 
	 * @throws Exception 
	 */
	private String checkValueForConnection(int i, String[][] data, String option, String langCode,BufferedWriter errorLog) throws Exception {
		String msg = "";
		Map commandMap = new HashMap();

		/* From ItemID 필수 체크 */
		if (data[i][0].isEmpty()) {
			// msg = (i + 1) + "행의 From ItemID를 입력해 주세요.";
			msg = MessageHandler.getMessage(langCode + ".WM00107",
					new String[] { String.valueOf(i + 1), "From ItemID" });
			errorLog.write(msg);
			errorLog.newLine();
		}
		/* To ItemID 필수 체크 */
		if (data[i][3].isEmpty()) {
			// msg = (i + 1) + "행의 To ItemID를 입력해 주세요.";
			msg = MessageHandler.getMessage(langCode + ".WM00107", new String[] { String.valueOf(i + 1), "To ItemID" });
			errorLog.write(msg);
			errorLog.newLine();
		}

		/* Connection Type 필수 체크 */
		if (data[i][6].isEmpty()) {
			msg = MessageHandler.getMessage(langCode + ".WM00107", new String[] { String.valueOf(i + 1), "Connection Class" });
			errorLog.write(msg);
			errorLog.newLine();
		}

		String fromItemID = data[i][0];
		String toItemID = data[i][3];
		// 엑셀에서 읽어 들인 데이터의 입력 체크처리
		if (option.equals("1")) {
			// 업로드 option [ItemId]를 선택한경우
			/* ItemId 존재 체크 */
			commandMap.put("ItemID", data[i][0]);
			String cnt = StringUtil.checkNull(commonService.selectString("report_SQL.getCountWithItemId", commandMap));
			if (cnt.equals("0")) {
				msg = "Line " + (i + 1)  + " : ItemID does not exist.";
				errorLog.write(msg);
				errorLog.newLine();
			}
			commandMap.put("ItemID", data[i][3]);
			cnt = StringUtil.checkNull(commonService.selectString("report_SQL.getCountWithItemId", commandMap));
			if (cnt.equals("0")) {
				msg = "Line " + (i + 1)  + " : ItemID does not exist.";
				errorLog.write(msg);
				errorLog.newLine();
			}

		} else {
			// 업로드 option [Identifier]를 선택한경우
			/* Identifier 존재 체크 */
			commandMap.put("Identifier", data[i][0]);
			commandMap.put("ClassCode", data[i][1]);
			fromItemID = StringUtil.checkNull(commonService.selectString("report_SQL.getItemIdWithIdentifier", commandMap));

			if (fromItemID.equals("")) {
				msg = "Line " + (i + 1)  + " : Identifier does not exist.";
				errorLog.write(msg);
				errorLog.newLine();
			}
			commandMap.put("Identifier", data[i][3]);
			commandMap.put("ClassCode", data[i][4]);
			toItemID = StringUtil.checkNull(commonService.selectString("report_SQL.getItemIdWithIdentifier", commandMap));
			if (toItemID.equals("")) {
				msg = "Line " + (i + 1)  + " : Identifier does not exist.";
				errorLog.write(msg);
				errorLog.newLine();
			}
		}

		// connection 중복 체크
		commandMap.put("ClassCode", data[i][6]);
		String cxnTypeCode = StringUtil.checkNull(commonService.selectString("item_SQL.getItemTypeCodeFromClassCode", commandMap)); 
		
		commandMap.put("FromItemID", fromItemID);
		commandMap.put("ToItemID", toItemID);
		commandMap.put("ItemTypeCode", cxnTypeCode);
		commandMap.put("deleted", "1");
		String cxnItem = StringUtil.checkNull(commonService.selectString("item_SQL.getConItemID", commandMap)); // deleted // != 0
		if (!cxnItem.equals("")) {
			msg = "Line " + (i + 1) +" : Already exists. Duplicate Connection cannot be added.";
			errorLog.write(msg);
			errorLog.newLine();
		}

		return msg;
	}
	
	
	/**
	 * [Dimension Mapping] 읽어들인 템플릿의 정보를 Map에 저장
	 * 
	 * @param sheet
	 * @param colCount
	 * @param rowCount
	 * @return 템플릿의 정보 Map
	 * @throws Exception 
	 */
	private Map setUploadMapDimension(XSSFSheet sheet, String option, HashMap commandMap, BufferedWriter errorLog) throws Exception {
		Map excelMap = new HashMap();
		
		String colsName = "";
		String headerName = "";
		int attrTypeColNum = 1;
		String[][] data	= null;
		List list = new ArrayList();
		int valCnt = 0;
		
		int rowCount  =  sheet.getPhysicalNumberOfRows();
		int colCount = sheet.getRow(0).getPhysicalNumberOfCells();
		
		data = new String[rowCount][colCount];
		
		XSSFRow row     =  null;
	    XSSFCell cell    =  null;
	    
	    String langCode = String.valueOf(commandMap.get("sessionCurrLangCode"));
	    
		for(int i = 0; i < rowCount; i ++){
			row = sheet.getRow(i);
			colCount   =  row.getPhysicalNumberOfCells();
			
			for(int j = 0; j < colCount; j ++) {
				cell	= row.getCell(j);
				data[i][j]	= StringUtil.checkNull(cell);;
				
				// 첫번째 row에서 DimValueText를 취득
				// 템플릿 상에서 3번째 칼럼 부터 DimValueText를 설정 해 줌 
				if (i == 0 && j > 1) {
					/* DimValueText 필수 체크 */
					if (data[i][j].isEmpty()) {
						//excelMap.put("msg", (j + 1) + "열의 타이틀에  DimValueText를 입력해 주세요.");
						excelMap.put("msg", MessageHandler.getMessage(langCode + ".WM00110", new String[]{String.valueOf(j + 1), "DimValueText"}));
						errorLog.write(MessageHandler.getMessage(langCode + ".WM00110", new String[]{String.valueOf(j + 1), "DimValueText"})); 
						errorLog.newLine();
						//break;
					}
					
					excelMap.put("DimValueText" + (j - 1), data[i][j]);
					colsName = colsName + "|" + "newDimValue" + (j - 1);
					headerName = headerName + "," + data[i][j];
					attrTypeColNum++;
				}
				
				if (i == 1 && j > 1) {
					/* DimValueId 필수 체크 */
					if (data[i][j].isEmpty()) {
						//excelMap.put("msg", (j + 1) + "열의 타이틀에  DimValueID를 입력해 주세요.");
						excelMap.put("msg", MessageHandler.getMessage(langCode + ".WM00110", new String[]{String.valueOf(j + 1), "DimValueID"}));
						errorLog.write(MessageHandler.getMessage(langCode + ".WM00110", new String[]{String.valueOf(j + 1), "DimValueText"})); 
						errorLog.newLine();
						//break;
					}
					excelMap.put("DimValue" + (j - 1), data[i][j]);
				}
			}
			
			if(i > 0){
				
				// 데이터 입력 체크
				String msg = checkValueForDimension(i, data, option, langCode, errorLog);
				if (!msg.isEmpty()) {
					excelMap.put("msg", msg);
				}
				
				// 새로운 템플렛 적용
				Map map = new HashMap();
				
				map.put("RNUM"				  , i);
				map.put("newItemTypeId"	      , data[i][0]);
				if(i==1){ // index 1 DimensionTypeID만 필요. 
					map.put("newDimTypeIdItemName", data[i][1]);
				}
								
				for (int j = 1; j < attrTypeColNum; j ++) {
					if (!data[i][1+j].isEmpty()) {
						map.put("newDimValue" + j, excelMap.get("DimValue" + j).toString());
					} else {
						map.put("newDimValue" + j, "");
					}
				}
				
				list.add(map);
				++valCnt;
			}
			
//			if (excelMap.get("msg") != null) {
//				break;
//			}
		}
		
		excelMap.put("list", list);
		excelMap.put("validCnt", valCnt);
		excelMap.put("totalCnt", valCnt);
		excelMap.put("attrTypeCodeCnt", attrTypeColNum);
		excelMap.put("colsName", "newItemTypeId|newDimTypeIdItemName" + colsName);
		excelMap.put("headerName", headerName);

		return excelMap;
	}
	
	/**
	 *  [Dimension Mapping]  읽어들인 템플릿의 정보의 필수 체크와 DB존재 체크
	 * 
	 * @param i  처리행수
	 * @param data 처리행의 각 칼럼 데이터
	 * @return 에러메세지 msg 
	 * @throws Exception 
	 */
	private String checkValueForDimension(int i, String[][] data, String option, String langCode, BufferedWriter errorLog) throws Exception {
		String msg = "";
		Map commandMap = new HashMap();
		
		if (i == 1) {
			/* ItemTypeCode 필수 체크 */
			if (data[i][0].isEmpty()) {
				//msg = (i + 1) + "행의 ItemTypeCode를 입력해 주세요.";
				msg = MessageHandler.getMessage(langCode + ".WM00107", new String[]{String.valueOf(i + 1), "ItemTypeCode"});
				errorLog.write(msg); 
				errorLog.newLine();
				//return msg;
			}
			/* Dimensin Type ID 필수 체크 */
			if (data[i][1].isEmpty()) {
				//msg = (i + 1) + "행의 Dimensin Type ID를 입력해 주세요.";
				msg = MessageHandler.getMessage(langCode + ".WM00107", new String[]{String.valueOf(i + 1), "Dimensin Type ID"});
				errorLog.write(msg); 
				errorLog.newLine();
				//return msg;
			}
			
			/* ItemId 존재 체크 */
			commandMap.put("ItemID", data[i][1]); 
			String cnt = StringUtil.checkNull(commonService.selectString("report_SQL.getCountWithItemId", commandMap));
			if (cnt.equals("0")) {
				//msg = (i + 1) + "행의 Dimensin Type ID가 데이터베이스에 존재 하지 않습니다.";
				msg = MessageHandler.getMessage(langCode + ".WM00108", new String[]{String.valueOf(i + 1), "Dimensin Type ID"});
				errorLog.write(msg); 
				errorLog.newLine();
				//return msg;
			}
			
		}
		
		if (i > 1) {
			/* ItemId 필수 체크 */
			if (data[i][0].isEmpty()) {
				//msg = (i + 1) + "행의 ItemID or Identifier 를 입력해 주세요.";
				msg = MessageHandler.getMessage(langCode + ".WM00107", new String[]{String.valueOf(i + 1), "ItemID or Identifier"});
				errorLog.write(msg); 
				errorLog.newLine();
				//return msg;
			}
			
			
			/* ItemId or Identifier 존재 체크 */
			if (option.equals("1")) {
				// 업로드 option  [ItemId]를 선택한경우
				/* ItemId 존재 체크 */
				commandMap.put("ItemID", data[i][0]);
				String cnt = StringUtil.checkNull(commonService.selectString("report_SQL.getCountWithItemId", commandMap));
				if (cnt.equals("0")) {
					//msg = (i + 1) + "행의 ItemId가 데이터베이스(TB_ITEM)에 존재 하지 않습니다.";
					msg = MessageHandler.getMessage(langCode + ".WM00108", new String[]{String.valueOf(i + 1), "ItemId"});
					errorLog.write(msg); 
					errorLog.newLine();
					//return msg;
				}
			} else {
				// 업로드 option [Identifier]를 선택한경우
				/* Identifier 필수 체크 */
				commandMap.put("Identifier", data[i][0]);
				String cnt = StringUtil.checkNull(commonService.selectString("report_SQL.getCountWithIdentifier", commandMap));
				if (cnt.equals("0")) {
					//msg = (i + 1) + "행의 Identifier가 데이터베이스(TB_ITEM)에 존재 하지 않습니다.";
					msg = MessageHandler.getMessage(langCode + ".WM00108", new String[]{String.valueOf(i + 1), "Identifier"});
					errorLog.write(msg); 
					errorLog.newLine();
					//return msg;
				}
			}
			
		}
		
		return msg;
	}
	
	/**
	 * [Program Status] 읽어들인 템플릿의 정보를 Map에 저장
	 * 
	 * @param sheet
	 * @return 템플릿의 정보 Map
	 * @throws Exception 
	 */
	private Map setUploadPgStatusCboList(XSSFSheet sheet) throws Exception {
		Map excelMap = new HashMap();
		
		String colsName = "newItemId|newFDTanto|newFDPlannedStart|newFDPlannedEnd|newFDStatus|newFDActualStart|newFDActualEnd|" 
						+ "newPGTanto|newPGPlannedStart|newPGPlannedEnd|newPGStatus|newPGActualStart|newPGActualEnd|" 
						+ "newUTTanto|newUTPlannedStart|newUTPlannedEnd|newUTStatus|newUTActualStart|newUTActualEnd|"
						+ "newTDTanto|newTDPlannedStart|newTDPlannedEnd|newTDStatus|newTDActualStart|newTDActualEnd";
		
		int attrTypeColNum = 1;
		List list = new ArrayList();
		List identifierList = new ArrayList();
		Map commandMap = new HashMap();
		
		int valCnt = 0;
		
		
		int rowCount  =  sheet.getPhysicalNumberOfRows();
		
		XSSFRow row     =  null;
	    XSSFCell cell    =  null;
	    String parentIdentifier = "";
		
	    // 입력 값 체크
	    String msg = checkValueForUploadPgStatusCboList(sheet, rowCount);
	    if (!msg.isEmpty()) {
	    	excelMap.put("msg", msg);
	    }
		
	    if (excelMap.get("msg") == null) {
	    	
	    	// 4번째 줄 Title
			// 5번째 줄 부터 데이터를 읽어 들임
	    	for(int i = 4; i < rowCount; i ++){
				
				row = sheet.getRow(i);
				int colCount   =  row.getPhysicalNumberOfCells();
				
				Map map = new HashMap();
				int kbn = 0;
				
				for(int j = 0; j < colCount; j ++) {
					cell	= row.getCell(j);
					
					if (i == 4 && j == 0) {
						parentIdentifier = String.valueOf(cell); 
					}
					
					map.put("RNUM"					, i - 3);
					
					// ParentID 
					if (j == 0) {
						if (StringUtil.checkNull(cell).isEmpty() || !parentIdentifier.equals(String.valueOf(cell))) {
							kbn = 1;
							break;
						}
					}
					
					// ItemId 취득
					if (j == 1) { 
						commandMap.put("Identifier", cell.getRawValue()); // CBO ID
						String itemId = StringUtil.checkNull(commonService.selectString("report_SQL.getItemIdWithIdentifier", commandMap));
						map.put("newItemId", itemId); // 해당 ItemId
					}
					
					if (j == 2) { map.put("newFDTanto"	        , cell); }  // FD담당자
					if (j == 3) { map.put("newFDPlannedStart"	, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // FD시작일(Planned)
					if (j == 4) { map.put("newFDPlannedEnd"	, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // FD완료일(Planned)
					if (j == 5) { map.put("newFDStatus"		, cell); }  // FD상태
					if (j == 6) { map.put("newFDActualStart"	, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // FD시작일(Actual)
					if (j == 7) { map.put("newFDActualEnd"		, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // FD완료일(Actual)
					
					if (j == 8) { map.put("newPGTanto"	        , cell); }  // Program담당자
					if (j == 9) { map.put("newPGPlannedStart"	, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // Program시작일(Planned)
					if (j == 10) { map.put("newPGPlannedEnd"	, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // Program완료일(Planned)
					if (j == 11) { map.put("newPGStatus"		, cell); }  // Program상태
					if (j == 12) { map.put("newPGActualStart"	, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // Program시작일(Actual)
					if (j == 13) { map.put("newPGActualEnd"		, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // Program완료일(Actual)
					
					if (j == 14) { map.put("newUTTanto"	        , cell); }  // UnitTest담당자
					//if (j == 33) { map.put("newUTScenario"	    , cell); }  // UnitTest시나리오작성
					if (j == 15) { map.put("newUTPlannedStart"	, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // UnitTest시작일(Planned)
					if (j == 16) { map.put("newUTPlannedEnd"	, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // UnitTest완료일(Planned)
					if (j == 17) { map.put("newUTStatus"		, cell); }  // UnitTest상태
					if (j == 18) { map.put("newUTActualStart"	, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // UnitTest시작일(Actual)
					if (j == 19) { map.put("newUTActualEnd"		, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // UnitTest완료일(Actual)
					
					if (j == 20) { map.put("newTDTanto"	        , cell); }  // TD담당자
					if (j == 21) { map.put("newTDPlannedStart"	, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // TD시작일(Planned)
					if (j == 22) { map.put("newTDPlannedEnd"	, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // TD완료일(Planned)
					if (j == 23) { map.put("newTDStatus"		, cell); }  // TD상태
					if (j == 24) { map.put("newTDActualStart"	, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // TD시작일(Actual)
					if (j == 25) { map.put("newTDActualEnd"		, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // TD완료일(Actual)
					
				}
				
				if (kbn == 0) {
					list.add(map);
				}
				
				++valCnt;
				
				if (excelMap.get("msg") != null) {
					break;
				}
			}
	    }
		
		
		excelMap.put("list", list);
		excelMap.put("validCnt", valCnt);
		excelMap.put("totalCnt", valCnt);
		excelMap.put("attrTypeCodeCnt", attrTypeColNum);
		excelMap.put("colsName", colsName);

		return excelMap;
	}
	
	/**
	 * [Program Status 업로드] 읽어들인 템플릿의 정보의 필수 체크와 DB존재 체크
	 * 
	 * @param sheet  읽어들일 Excel 해당 sheet
	 * @param rowCount 읽어 들일 row Count
	 * @return 에러메세지 msg 
	 * @throws Exception 
	 */
	private String checkValueForUploadPgStatusCboList(XSSFSheet sheet, int rowCount) throws Exception {
		String msg = "";
		Map commandMap = new HashMap();
		
		XSSFRow row     =  null;
	    XSSFCell cell    =  null;
	    
	    String parentIdentifier = "";
		
	    for(int i = 4; i < rowCount; i ++){
			
			row = sheet.getRow(i);
			int colCount   =  row.getPhysicalNumberOfCells();
			
			Map map = new HashMap();
			int kbn = 0;
			
			for(int j = 0; j < colCount; j ++) {
				cell	= row.getCell(j);
				
				if (i == 4 && j == 0) {
					parentIdentifier = String.valueOf(cell); 
				}
				
				if (j == 0) {
					if (StringUtil.checkNull(cell).isEmpty()|| !parentIdentifier.equals(String.valueOf(cell))) {
						kbn = 1;
						break;
					}
					
				}
				
				// CBO ID
				if (j == 8) {
					if (StringUtil.checkNull(cell).isEmpty()) {
						msg = (i + 1) + "행의 [CBO ID]을 입력해 주세요.";
						return msg;
					} else {
						commandMap.put("Identifier", cell.getRawValue()); // CBO ID
						String itemId = StringUtil.checkNull(commonService.selectString("report_SQL.getItemIdWithIdentifier", commandMap));
						
						if (itemId.isEmpty()) {
							msg = (i + 1) + "행의 [CBO ID]가 데이터 베이스에 존재 하지 않습니다.";
							return msg;
						}
					}
				}  
				
			}
	    
	    }
	    
		return msg;
	}
	
	/**
	 * [I/F Program Status] 읽어들인 템플릿의 정보를 Map에 저장
	 * 
	 * @param sheet
	 * @return 템플릿의 정보 Map
	 * @throws Exception 
	 */
	private Map setUploadPgStatusIfMaster(XSSFSheet sheet) throws Exception {
		Map excelMap = new HashMap();
		
		String colsName = "newItemId|newIMPlannedStart|newIMPlannedEnd|newIMActualStart|newIMActualEnd|newIMLegacyActualEndDate|newIfMappingName|"
				+ "newIPPlannedStart|newIPPlannedEnd|newIPActualStart|newIPActualEnd|newIPEAIEndDate|newIPLegacyPlannedEndDate|newIPLegacyActualEndDate|"
				+ "newUtPlannedStart|newUtPlannedEnd|newUtActualStart|newUtActualEnd|newUtMWUtEndDate|newUtLegacyActualEndDate|"
				+ "newITPlannedStart|newITPlannedEnd|newITActualStart|newITActualEnd";
		
		int attrTypeColNum = 1;
		List list = new ArrayList();
		List identifierList = new ArrayList();
		Map commandMap = new HashMap();
		
		int valCnt = 0;
		
		
		int rowCount  =  sheet.getPhysicalNumberOfRows();
		
		XSSFRow row     =  null;
	    XSSFCell cell    =  null;
	    String parentIdentifier = "";
		
	    // 입력 값 체크
	    String msg = checkValueForUploadPgStatusIfMaster(sheet, rowCount);
	    if (!msg.isEmpty()) {
	    	excelMap.put("msg", msg);
	    }
		
	    if (excelMap.get("msg") == null) {
	    	
	    	// 4번째 줄 Title
			// 5번째 줄 부터 데이터를 읽어 들임
	    	for(int i = 4; i < rowCount; i ++){
				
				row = sheet.getRow(i);
				int colCount   =  row.getPhysicalNumberOfCells();
				
				Map map = new HashMap();
				int kbn = 0;
				
				for(int j = 0; j < colCount; j ++) {
					cell	= row.getCell(j);
					
					if (i == 4 && j == 0) {
						parentIdentifier = String.valueOf(cell); 
					}
					
					map.put("RNUM"					, i - 3);
					
					if (j == 0) {
						if (StringUtil.checkNull(cell).isEmpty() || !parentIdentifier.equals(String.valueOf(cell))) {
							kbn = 1;
							break;
						}
					}
					
					// ItemId 취득
					if (j == 1) { 
						commandMap.put("Identifier", cell.getRawValue()); // Interface ID
						String itemId = StringUtil.checkNull(commonService.selectString("report_SQL.getItemIdWithIdentifier", commandMap));
						map.put("newItemId", itemId); // 해당 ItemId
					}
					
					if (j == 33) { map.put("newIMPlannedStart"			, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // I/F Mapping 정의서 작성 시작일 (Planned)
					if (j == 34) { map.put("newIMPlannedEnd"			, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // I/F Mapping 정의서 작성 완료일(Planned)
					if (j == 35) { map.put("newIMActualStart"			, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // I/F Mapping 정의서 작성 시작일(Actual)
					if (j == 36) { map.put("newIMActualEnd"				, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // I/F Mapping 정의서 작성 완료일(Actual)
					if (j == 37) { map.put("newIMLegacyActualEndDate"	, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // I/F Mapping 정의서 Legacy 작성 완료일(Actual)
					if (j == 38) { map.put("newIfMappingName"			, cell); }  				 // I/F Mapping 정의서 명(Actual)
					
					if (j == 39) { map.put("newIPPlannedStart"			, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // I/F Program 개발 시작일 (Planned)
					if (j == 40) { map.put("newIPPlannedEnd"			, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // I/F Program 개발 완료일(Planned)
					if (j == 41) { map.put("newIPActualStart"			, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // I/F Program 개발 시작일(Actual)
					if (j == 42) { map.put("newIPActualEnd"				, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // I/F Program 개발 완료일(Actual)
					if (j == 43) { map.put("newIPEAIEndDate"			, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // I/F Program 개발 EAI 완료일(Actual)
					if (j == 44) { map.put("newIPLegacyPlannedEndDate"	, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // I/F Program 개발 Legacy 완료일(Planned)
					if (j == 45) { map.put("newIPLegacyActualEndDate"	, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // I/F Program 개발 Legacy 완료일(Actual)
					
					if (j == 46) { map.put("newUtPlannedStart"			, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // 단위 테스트 시작일 (Planned)
					if (j == 47) { map.put("newUtPlannedEnd"			, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // 단위 테스트 완료일(Planned)
					if (j == 48) { map.put("newUtActualStart"			, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // 단위 테스트 시작일(Actual)
					if (j == 49) { map.put("newUtActualEnd"				, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // 단위 테스트 완료일(Actual)
					if (j == 50) { map.put("newUtMWUtEndDate"			, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // 단위 테스트 M/W 완료일(Actual)
					if (j == 51) { map.put("newUtLegacyActualEndDate"	, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // 단위 테스트 Legacy 완료일(Actual)
					
					if (j == 52) { map.put("newITPlannedStart"			, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // 연동 테스트 시작일 (Planned)
					if (j == 53) { map.put("newITPlannedEnd"			, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // 연동 테스트 완료일(Planned)
					if (j == 54) { map.put("newITActualStart"			, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // 연동 테스트 시작일(Actual)
					if (j == 55) { map.put("newITActualEnd"				, setDateYyyymmdd(cell, "yyyy-MM-dd")); }  // 연동 테스트 완료일(Actual)
					
				}
				
				if (kbn == 0) {
					list.add(map);
				}
				
				++valCnt;
				
				if (excelMap.get("msg") != null) {
					break;
				}
			}
	    }
		
		
		excelMap.put("list", list);
		excelMap.put("validCnt", valCnt);
		excelMap.put("totalCnt", valCnt);
		excelMap.put("attrTypeCodeCnt", attrTypeColNum);
		excelMap.put("colsName", colsName);

		return excelMap;
	}
	
	/**
	 * [I/F Program Status 업로드] 읽어들인 템플릿의 정보의 필수 체크와 DB존재 체크
	 * 
	 * @param sheet  읽어들일 Excel 해당 sheet
	 * @param rowCount 읽어 들일 row Count
	 * @return 에러메세지 msg 
	 * @throws Exception 
	 */
	private String checkValueForUploadPgStatusIfMaster(XSSFSheet sheet, int rowCount) throws Exception {
		String msg = "";
		Map commandMap = new HashMap();
		
		XSSFRow row     =  null;
	    XSSFCell cell    =  null;
	    
	    String parentIdentifier = "";
		
	    for(int i = 4; i < rowCount; i ++){
			
			row = sheet.getRow(i);
			int colCount   =  row.getPhysicalNumberOfCells();
			
			Map map = new HashMap();
			int kbn = 0;
			
			for(int j = 0; j < colCount; j ++) {
				cell	= row.getCell(j);
				
				if (i == 4 && j == 0) {
					parentIdentifier = String.valueOf(cell); 
				}
				
				if (j == 0) {
					if (StringUtil.checkNull(cell).isEmpty()|| !parentIdentifier.equals(String.valueOf(cell))) {
						kbn = 1;
						break;
					}
					
				}
				
				// Interface ID
				if (j == 1) {
					if (StringUtil.checkNull(cell).isEmpty()) {
						msg = (i + 1) + "행의 [Interface ID]을 입력해 주세요.";
						return msg;
					} else {
						commandMap.put("Identifier", cell.getRawValue()); // Interface ID
						String itemId = StringUtil.checkNull(commonService.selectString("report_SQL.getItemIdWithIdentifier", commandMap));
						
						if (itemId.isEmpty()) {
							msg = (i + 1) + "행의 [Interface ID]가 데이터 베이스에 존재 하지 않습니다.";
							return msg;
						}
					}
				}  
				
			}
	    
	    }
	    
		return msg;
	}
	
	
		
	// jsonObject생성시, 에러를 유발시키는 싱글 쿼테이션을 치환하는 처리
	private String replaceSingleQuotation(String plainText) {
		String result = "";
		result = plainText.replace("'", "");
		return result;
	}
	
	private List getModelId(List List, String languageID) throws Exception {
		List resultList = new ArrayList();
		Map setMap = new HashMap();
		for (int i = 0; i < List.size(); i++) {
			Map listMap = new HashMap();
			listMap = (Map) List.get(i);
			String modelId = "";
			
			setMap.put("ItemID", listMap.get("ItemID"));
			setMap.put("languageID", languageID);
			List modelList = commonService.selectList("model_SQL.getModelsWithItemID", setMap);
			
			if (modelList.size() != 0) {
				Map modelMap = (Map) modelList.get(0);
				modelId = modelMap.get("ModelID").toString();
			}
			
			listMap.put("ModelID", modelId);
			resultList.add(listMap);
		}
		return resultList;
	}
	
//	String result = "";
//	Map setMap = new HashMap();
//	setMap.put("AttrTypeCode", attrTypeCode);
//	setMap.put("ItemID", itemId);
//	
//	Map map = commonService.select("report_SQL.getIsComLang", setMap);
//	
//	if (!StringUtil.checkNull(map.get("IsComLang")).isEmpty()) {
//		if ("LOV".equals(String.valueOf(map.get("DataType")))) {
//			setMap.put("LanguageID", selLang);
//			result = StringUtil.checkNull(commonService.selectString("report_SQL.getAttrLovValue", setMap));
//		} else {
//			setMap.put("LanguageID", commonService.selectString("item_SQL.getDefaultLang", setMap));
//			result = StringUtil.checkNull(commonService.selectString("report_SQL.getAttrValue", setMap));
//		}
//		
//	} else {
//		if ("LOV".equals(String.valueOf(map.get("DataType")))) {
//			setMap.put("LanguageID", selLang);
//			result = StringUtil.checkNull(commonService.selectString("report_SQL.getAttrLovValue", setMap));
//		} else {
//			result = value;
//		}
//		
//	}
//	
//	return result.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
//}


//private Map getAttrResultMap(List attrResult) {
//	Map contMap = new HashMap();
//	Map mapValue = new HashMap();
//	for(int i = 0; i < attrResult.size(); i++){
//		mapValue = (HashMap)attrResult.get(i);
//		contMap.put(mapValue.get("AttrType"), mapValue.get("AttrValue"));
//	}
//	return contMap;
//}
	
	
	/**
	 * Translation (2017/01/13)
	 * TB_ITEM_ATTR_TRAN 테이블의 데이터 이용
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/tranAttrList.do")
	public String tranAttrList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/itm/tran/tranAttrList";
		model.put("menu", getLabel(request, commonService));		
		
		return nextUrl(url);
	}
	
	/**
	 * Translation (2017/01/13)
	 * TB_ITEM_ATTR_TRAN 테이블의 데이터 이용
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/updateTranAttr.do")
	public String updateTranAttr(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();		
		try {				
				commonService.insert("report_SQL.insertTranAttr", commandMap);	
				commonService.update("report_SQL.updateTranAttr", commandMap);	
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 
		}
		catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
	
	/**
	 * Process이외 Excel 출력
	 * @param request
	 * @param commandMap
	 * @param model
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/downloadTranAttrExcel.do")
	public String downloadTranAttrExcel(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception{
		
		HashMap target = new HashMap();
		HashMap setData = new HashMap();
		FileOutputStream fileOutput = null;
		XSSFWorkbook wb = new XSSFWorkbook();
		
		try{
			List<Map> result = commonService.selectList("report_SQL.getTranAttrDataList_gridList", commandMap);			
			
			XSSFSheet sheet = wb.createSheet("TranAttr Data");
			XSSFCellStyle headerStyle = setCellHeaderStyle(wb);
			XSSFCellStyle contentsStyle = setCellContentsStyle(wb, "");
		
			int cellIndex = 0;
			int rowIndex = 0;
			XSSFRow row = sheet.createRow(rowIndex);
			row.setHeight((short) (512 * ((double) 8 / 10 )));
			XSSFCell cell = null;
			rowIndex++;
			String TextDefOLD = "";
			String TextDef = "";
			String TargetText = "";
			
			// AttributeCode 행 설정
			cell = row.createCell(cellIndex);
			cell.setCellValue("System ID");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("AttrType Code");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("Language ID");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("Item type");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("Class");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("ID");
			cell.setCellStyle(headerStyle);
			cellIndex++;	
			cell = row.createCell(cellIndex);
			cell.setCellValue("Path");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("Default Language(before)");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("Default Language(updated)");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("Target Language");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("Last Updated");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("Revision Date");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
		
			// Data 행 설정 
			for (int i=0; i < result.size();i++) {
				cellIndex = 0;   // cell index 초기화
				Map map = result.get(i);
			    row = sheet.createRow(rowIndex);
			    row.setHeight((short) (512 * ((double) 8 / 10 )));
			    
			    TextDefOLD = removeAllTag(StringUtil.checkNull(map.get("TextDefOLD")), "DbToEx");
			    TextDef = removeAllTag(StringUtil.checkNull(map.get("TextDef")), "DbToEx");
			    TargetText = removeAllTag(StringUtil.checkNull(map.get("TargetText")), "TargetText");
			    
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("ItemID"))); 
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("AttrTypeCode"))); 
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("LanguageID"))); 
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("ItemType")));
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("Class")));
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("Identifier")));
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;	
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("ItemPath")));
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(TextDefOLD);
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(TextDef);
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(TargetText);
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("LastUpdated")));
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			      cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("RevisionDate")));
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    
			    rowIndex++;
			}
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			long date = System.currentTimeMillis();
			String itemName = "TranAttrList";
			String selectedItemName1 = new String(itemName.getBytes("UTF-8"), "ISO-8859-1");
			String selectedItemName2 = new String(selectedItemName1.getBytes("8859_1"), "UTF-8");
			
			String orgFileName1 = selectedItemName1 + "_" + formatter.format(date) + ".xlsx";
			String orgFileName2 = selectedItemName2 + "_" + formatter.format(date) + ".xlsx";
			String downFile1 = FileUtil.FILE_EXPORT_DIR + orgFileName1;
			String downFile2 = FileUtil.FILE_EXPORT_DIR + orgFileName2;
			
			File file = new File(downFile2);
			fileOutput = new FileOutputStream(file);
			wb.write(fileOutput);
			target.put(AJAX_SCRIPT, "parent.doFileDown('"+orgFileName1+"', 'excel');parent.$('#isSubmit').remove();");
			
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00089")); // 오류 발생
		} finally {
			if(fileOutput != null) fileOutput.close();
			wb = null;
			
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);	
		
	}
	
	//데이타 업로드
	@RequestMapping(value="/tranAttrExcelUpload.do")
	public String tranAttrExcelUpload(HashMap commandFileMap, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		int line = 0;

		try {

			List list				= (List) commandFileMap.get("STORED_FILES");
			Map map					= (Map) list.get(0);

			String sys_file_name	= (String)map.get("SysFileNm");
			String file_path		= "";//(String)map.get("FilePath");
			String file_id			= (String)map.get("AttFileID");

			String filePath			= FileUtil.FILE_UPLOAD_DIR + sys_file_name;
			
			String errorCheckfilePath = GlobalVal.FILE_EXPORT_DIR; //.FILE_UPLOAD_TINY_DIR;

			Map excelMap = new HashMap();
			int total_cnt		= 0;
			int valid_cnt		= 0;
			String colsName = "";
			String headerName = "";
			
			/* 파일 업로드 체크 시 발생한 에러 메세지 출력 파일 생성 */
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			long date = System.currentTimeMillis();
		    String fileName = "Upload_ATTR_ERROR_" + formatter.format(date) + ".txt";
		    String downFile = errorCheckfilePath + fileName;
			File file = new File(downFile);
//			BufferedWriter errorLog = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file,true), "UTF-8"));
			
//			excelMap = getAttrTranList(new File(filePath), commandFileMap, commandMap, errorLog);
			
			// 읽어 들인 데이터 체크에서 메세지가 있을 때, 처리를 중단하고 메세지표시
			/*if (excelMap.get("msg") != null) {				
				errorLog.close();
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00074")); // 오류 발생
				target.put(AJAX_SCRIPT, "parent.errorTxtDown('"+ fileName +"','"+ downFile +"');parent.$('#isSubmit').remove();");
				
			} else {*/
//				errorLog.close();
				//file.delete(); // 파일 업로드 정상 종료인경우, 생성된 로그 파일을 삭제 한다.
				
				BufferedWriter errorLog = null;
				OutputStreamWriter os = null;
				FileOutputStream fos = null;
				
				try {
					fos = new FileOutputStream(file,true);
					os = new OutputStreamWriter(fos, "UTF-8");
					errorLog = new BufferedWriter(os);
					excelMap = getItemList(new File(filePath), commandFileMap, commandMap, errorLog);
				} catch ( Exception e ) {
		        	System.out.println(e.toString());
		        	throw e;
		        } finally {
		        	errorLog.close();
		        }
				
				List arrayList = (List) excelMap.get("list");
				total_cnt = NumberUtil.getIntValue(excelMap.get("totalCnt"));
				valid_cnt = NumberUtil.getIntValue(excelMap.get("validCnt"));
				colsName = excelMap.get("colsName").toString();
								
				String jsonObject = "";
				if(arrayList.size() > 0){
					String [] cols = colsName.split("[|]");
					int totalPage = 0;
					jsonObject = JsonUtil.parseGridJson(arrayList, cols, totalPage, 1 ,(String)commandFileMap.get("contextPath"));
					jsonObject = jsonObject.replace("<br/>", "&&rn");
				}
				
				String errMsgYN="";
				if (excelMap.get("msg") != null) {
					errMsgYN =  "Y";
				}else{ errMsgYN = "N";}	
				System.out.println("total_cnt=="+total_cnt);
				System.out.println("jsonObject=="+jsonObject);
				target.put(AJAX_SCRIPT, "parent.doCntReturn('"+total_cnt+"','"+valid_cnt+"','"+file_id+"','"+jsonObject+"','"+errMsgYN+"','"+ fileName +"','"+ downFile +"');");
			//}
				// 읽어 들인 데이터 체크에서 메세지가 있을 때, 처리를 중단하고 메세지표시
				if (excelMap.get("msg") != null) {				
					errorLog.close();				
				} else {
					file.delete(); // 파일 업로드 정상 종료인경우, 생성된 로그 파일을 삭제 한다.
				}
			
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00072", new String[]{e.getMessage().replaceAll("\"", "")}));
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}	
	
	// 선택한 엑셀파일 읽어오기
	private Map getAttrTranList(File excelFile, HashMap commandFileMap, HashMap commandMap, BufferedWriter errorLog) throws Exception {
		Map excelMap = new HashMap();		
		XSSFWorkbook workbook  =  new XSSFWorkbook(new FileInputStream(excelFile));
		XSSFSheet sheet    =  null;	    
		try{			
			sheet = workbook.getSheetAt(0);  // 첫번째 sheet의 데이터 취득			
			int rowCount = sheet.getPhysicalNumberOfRows();;

			if( rowCount <= 1 ){
				throw new Exception("There is no data in the file.");
			}
			excelMap = setUploadAttrTranMap(sheet, commandMap, errorLog);
			
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
	
	/**
	 * [속성 업데이트] 읽어들인 템플릿의 정보를 Map에 저장
	 * 
	 * @param sheet
	 * @param temp
	 * @param option
	 * @return 템플릿의 정보 Map
	 * @throws Exception 
	 */
	private Map setUploadAttrTranMap(XSSFSheet sheet, HashMap commandMap, BufferedWriter errorLog) throws Exception {
		Map excelMap = new HashMap();
		
		String colsName = "";
		int attrTypeColNum = 1;
		String[][] data	= null;
		List list = new ArrayList();
		List identifierList = new ArrayList();
		
		int valCnt = 0;		
		int rowCount  =  sheet.getPhysicalNumberOfRows();
		int colCount = sheet.getRow(0).getPhysicalNumberOfCells();
		
		data = new String[rowCount][colCount];
		
		XSSFRow row     =  null;
	    XSSFCell cell    =  null;
	    
	    String langCode = String.valueOf(commandMap.get("sessionCurrLangCode"));
		//System.out.println("rowCount :"+rowCount);
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
				//System.out.println("data["+i+"]["+j+"] : "+data[i][j]);
			}
			
			if(i > 0){				
				// 데이터 입력 체크
				String msg = checkValueForUploadTran(i, data, langCode, errorLog);
				if (!msg.isEmpty()) {
					excelMap.put("msg", msg);
				}
				
				// 새로운 템플렛 적용
				Map map = new HashMap();
				map.put("RNUM", i);
				map.put("itemID", data[i][1]);
				map.put("attrTypeCode", data[i][2]);
				map.put("languageID", data[i][3]);			
				map.put("targetText", data[i][10]);	
				map.put("revisionNo", data[i][13]);	
				list.add(map);
				++valCnt;
			}
		}
		excelMap.put("list", list);
		excelMap.put("validCnt", valCnt);
		excelMap.put("totalCnt", valCnt);
		excelMap.put("colsName", "itemID|attrTypeCode|languageID|targetText|revisionNo");

		return excelMap;
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
	
	/**
	 * 읽어들인 정보의 필수 체크와 DB존재 체크
	 * 
	 * @param i  처리행수
	 * @param data 처리행의 각 칼럼 데이터
	 * @param temp
	 * @param option
	 * @param identifierList 전행의 Identifier리스트
	 * @return 에러메세지 msg 
	 * @throws Exception 
	 */
	private String checkValueForUploadTran(int i, String[][] data, String langCode, BufferedWriter errorLog) throws Exception {
		String msg = "";
		/* ItemID 필수 체크 */
		if (data[i][0].isEmpty()) {
			msg = MessageHandler.getMessage(langCode + ".WM00107", new String[]{String.valueOf(i + 1), "ItemID"});
			errorLog.write(msg);
			errorLog.newLine();
		}
		
		/* AttrTypeCode 필수 체크 */
		if (data[i][1].isEmpty()) {
			//msg = (i + 1) + "행의 Identifier를 입력해 주세요.";
			msg = MessageHandler.getMessage(langCode + ".WM00107", new String[]{String.valueOf(i + 1), "AttrTypeCode"});
			errorLog.write(msg); 
			errorLog.newLine();
		}
		
		return msg;
	}
	
	/**
	 * Translation (2017/01/13)
	 * TB_ITEM_ATTR_TRAN 테이블의 데이터 이용
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/tranAttrExcelImport.do")
	public String tranAttrExcelImport(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/itm/tran/tranAttrExcelImportPop";
		model.put("menu", getLabel(request, commonService));	   	
		
		return nextUrl(url);
	}

	// TranAttr 저장
	@RequestMapping(value="/saveTranAttrExcel.do")
	public String saveTranAttrExcel(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();		
		try {	
				String rowCount = StringUtil.checkNull(commandMap.get("TOT_CNT"));
				String languageID = StringUtil.checkNull(commandMap.get("language"));
				String textName = "";
				String itemID = "";
				String attrTypeCode = "";
				String targetLanguage = "";
				String plainTextDef = "";
				String plainTextTarget = "";
				String revisionNo = "";
				Map insertData = new HashMap();	
				Map updateTranData = new HashMap();	
				int itemAttrCnt = 0;
				String html = "";
				for (int r = 0; r < NumberUtil.getIntValue(rowCount); r++) {
					Map data = fetchRowData(commandMap, r); 					
					
					if (data !=null && data.size() > 0) {
						itemID = StringUtil.checkNull(data.get("itemID"));
						attrTypeCode = StringUtil.checkNull(data.get("attrTypeCode"));
						targetLanguage = StringUtil.checkNull(data.get("languageID"));						
						plainTextTarget = removeAllTag(StringUtil.checkNull(data.get("targetText")));
						revisionNo = StringUtil.checkNull(data.get("revisionNo"));
						//System.out.println(r+". itemID :"+itemID+", attrTypeCode :"+attrTypeCode+", Language :"+languageID+", Text :"+plainTextTarget);
						
						// Insert TB_Item_Attr
						insertData.put("ItemID", itemID); 
						insertData.put("languageID", targetLanguage);
						insertData.put("AttrTypeCode", attrTypeCode);
							
						html = StringUtil.checkNull(commonService.selectString("report_SQL.getAttrHtmlType", insertData));
						if(attrTypeCode.equals("AT00001")){
							plainTextTarget = plainTextTarget.replaceAll("&&rn", " ");
						}else{
							if(html.equals("1")){
								plainTextTarget = plainTextTarget.replaceAll("&&rn", "<br/>");
							}else{						
								plainTextTarget = plainTextTarget.replaceAll("&&rn", "\r\n");
							}
						}
						
						insertData.put("PlainText", plainTextTarget);	
						itemAttrCnt = Integer.parseInt(commonService.selectString("report_SQL.getItemAttrCnt", insertData)); // itemAttr 유무 check
						if(itemAttrCnt >0){ // update 
							commonService.insert("item_SQL.updateItemAttr", insertData);							
						}else{ // insert 
							commonService.insert("item_SQL.setItemAttr", insertData);
						}				
						
						// Update TB_Item_Attr_Tran Rev_Def  
						updateTranData.put("itemID", itemID);
						updateTranData.put("attrTypeCode", attrTypeCode);
						updateTranData.put("targetLanguage", targetLanguage);
						updateTranData.put("revisionNo", revisionNo);
						commonService.update("report_SQL.updateItemAttrTran", updateTranData);
						
					}
				}
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 
				target.put(AJAX_SCRIPT, "parent.fnCallBack();");
		}
		catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
	
	public String insertFile(HashMap fileMap, HashMap model, HashMap commandMap) throws Exception {
		String resultValue = "sucess";
		try{			
			List fileList = new ArrayList();
			
			Map setMap = new HashMap();
			setMap.put("itemID", model.get("selectedItemID"));
			setMap.put("fileName", fileMap.get("fileName"));
			String fileSeq  = StringUtil.checkNull(commonService.selectString("fileMgt_SQL.getFileSeq", setMap));
			
			if(fileSeq.equals("")){
				fileSeq = StringUtil.checkNull(commonService.selectString("fileMgt_SQL.itemFile_nextVal", setMap));
				
				fileMap.put("Seq", fileSeq);
				fileMap.put("DocumentID", model.get("selectedItemID"));
				fileMap.put("FileRealName", fileMap.get("fileName"));
				fileMap.put("FileName", fileMap.get("sysFileName"));
				fileMap.put("FltpCode", fileMap.get("fltpCode"));
				fileMap.put("FileMgt", fileMap.get("fileMgt"));
				fileMap.put("userId", commandMap.get("itemAuthorID"));
				fileMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
				fileMap.put("KBN", "insert");
				fileMap.put("DocCategory", "ITM");
				fileMap.put("projectID", commandMap.get("itemProjectID"));
				fileMap.put("SQLNAME", "fileMgt_SQL.itemFile_insert");
			
				fileList.add(fileMap);				 
				
			}else{ // update
				fileMap.put("Seq", fileSeq);
				fileMap.put("FileName", fileMap.get("sysFileName"));
				fileMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
				fileMap.put("sessionUserId", commandMap.get("itemAuthorID"));
				fileMap.put("FltpCode", fileMap.get("fltpCode"));
				fileMap.put("KBN", "update");
				fileMap.put("SQLNAME", "fileMgt_SQL.itemFile_update"); 
				   
				fileList.add(fileMap);
			}
			
			fileMgtService.save(fileList, fileMap);
			
		}catch(Exception ex){
			resultValue = "failed";
			System.out.println(ex.toString());
		}
		
		return resultValue;
	}
	
	@RequestMapping(value = "/deleteItem.do")
	public String deleteItem(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception {
		HashMap target = new HashMap();
		HashMap updateCommandMap = new HashMap();
		HashMap setMap = new HashMap();
		try {			
			String itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			Map setData = new HashMap();
			setData.put("itemId", itemID);
			Map itemInfo  = commonService.select("fileMgt_SQL.selectItemAuthorID",setData);
			String itemStatus = StringUtil.checkNull(itemInfo.get("Status"));
			String itemBlocked = StringUtil.checkNull(itemInfo.get("Blocked"));
			
			setData.put("itemID", itemID);
			int toItemCNT = Integer.parseInt( StringUtil.checkNull(commonService.selectString("report_SQL.getToItemCNT", setData)));
			int mdlOBJCNT = Integer.parseInt( StringUtil.checkNull(commonService.selectString("report_SQL.getMDLOBJCNT", setData)));
			
			if(!itemBlocked.equals("0")){
				if(itemStatus.equals("REL")){
					target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00121")); // CSR에 등록 안된 항목이므로 삭제할 수 없습니다.
				}else{
					target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00054")); // 릴리즈 대기 중이므로 삭제할 수 없습니다.
				}				
				 model.addAttribute(AJAX_RESULTMAP, target);
				 return nextUrl(AJAXPAGE);
			}else{				
				if (itemStatus.equals("NEW1") || itemStatus.equals("NEW2") || itemStatus.equals("REL")) {
					if(toItemCNT > 0){						
						target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00024")); // 하위항목이 있으므로 삭제할 수 없습니다.
						model.addAttribute(AJAX_RESULTMAP, target);
						return nextUrl(AJAXPAGE);
					}else if(mdlOBJCNT > 0){
						target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00052")); // 모델에서 사용된 Element 입니다. 모델에서 해당 Element를 삭제하십시요.
						model.addAttribute(AJAX_RESULTMAP, target);
						return nextUrl(AJAXPAGE);
					}					
				}				
			}	
			
			updateCommandMap = new HashMap();
			updateCommandMap.put("Deleted", "1");
					
			if ("MOD1".equals(itemStatus)) {
				updateCommandMap.put("Status", "DEL1");
			}
			
			updateCommandMap.put("s_itemID", itemID);
			updateCommandMap.put("ItemID", itemID);
			updateCommandMap.put("LastUser", commandMap.get("sessionUserId"));
			
			// connection Item update 
			commonService.update("item_SQL.updateCNItemDeleted", updateCommandMap);
			// Item update
			commonService.update("project_SQL.updateItemStatus",updateCommandMap);
			
			//deleteDimItemTreeInfo(commandMap, itemID);
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제 성공
			target.put(AJAX_SCRIPT, "this.doCallBack();this.$('#isSubmit').remove();");
			
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			//target.put(AJAX_ALERT, " 삭제중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // 삭제 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	private void deleteDimItemTreeInfo(HashMap commandMap, String itemID) throws ExceptionUtil {
		
		/* DELETE TB_ITEM_DIM_TREE :: 이동할 아이템의  Dimension Tree 정보 삭제 */
		Map setMap = new HashMap();
		
		try {
			
			String deletedItemId = itemID;
			setMap.put("ItemID", deletedItemId);
			List dimensionList = commonService.selectList("dim_SQL.getDimListWithItemId", setMap);
			
			for (int j = 0; j < dimensionList.size(); j++) {
				Map dimensionMap = (Map) dimensionList.get(j);
				String dimTypeID = String.valueOf(dimensionMap.get("DimTypeID"));
				String dimValueID = String.valueOf(dimensionMap.get("DimValueID"));
				
				/* DELETE TB_ITEM_DIM_TREE 
				// Connection ItemID 취득, NodeID 설정
				List<String> connectionIdList = new ArrayList<String>();
		   
				// 삭제 대상의 ItemId의 Connection ItemID 중  TB_ITEM_DIM record가 존재하는 data를 취득
				List<String> itemDimIdList  = new ArrayList<String>();
				DimTreeAdd.getUnderConnectionId(commonService, itemID, connectionIdList);
				DimTreeAdd.getExistItemDimId(commonService, itemDimIdList, connectionIdList, dimTypeID, dimValueID);
			   
				connectionIdList = new ArrayList<String>();
				DimTreeAdd.getOverConnectionId(commonService, itemID, dimTypeID, dimValueID, connectionIdList, 0);
				DimTreeAdd.getExistItemDimId(commonService, itemDimIdList, connectionIdList, dimTypeID, dimValueID);
			   
				// 삭제 대상의 ItemId의 Connection ItemID를 TB_ITEM_DIM_TREE 테이블에서 모두 삭제
				connectionIdList = new ArrayList<String>();
				DimTreeAdd.getUnderConnectionId(commonService, itemID, connectionIdList);
				DimTreeAdd.getOverConnectionId(commonService, itemID, dimTypeID, dimValueID, connectionIdList, 1);
			   
				setMap.put("DimTypeID", dimTypeID);
				setMap.put("DimValueID", dimValueID);
				for (String connectionId : connectionIdList) {
					setMap.put("NodeID", connectionId);
					commonService.delete("dim_SQL.delSubDimTree", setMap); 
				}
		
				// 삭제 대상의 ItemId의 Connection ItemID 중  TB_ITEM_DIM record가 존재하는 data의 TB_ITEM_DIM_TREE record를 INSERT
				itemDimIdList.remove(itemID);
				if (itemDimIdList.size() != 0) {
					//Map commandMap = new HashMap();
			    
					for (int k = 0; k < itemDimIdList.size(); k++) {
						String itemDimId = itemDimIdList.get(k);
						// ItemID의 ItemTypeCode, ClassCode 취득 
						commandMap.put("ItemID", itemDimId);  
						List itemInfoList = (List) commonService.selectList("dim_SQL.getItemTypeCodeAndClassCode", commandMap);
						Map itemInfoMap = (Map) itemInfoList.get(0);
						String itemTypeCode = itemInfoMap.get("ItemTypeCode").toString();
			     
						connectionIdList = new ArrayList<String>();
			     
						DimTreeAdd.getOverConnectionId(commonService, itemDimId, dimTypeID, dimValueID, connectionIdList, 0);
						DimTreeAdd.getUnderConnectionId(commonService, itemDimId, connectionIdList);
			     
						// connectionId list분, TB_ITEM_DIM_TREE record 입력
						// 단, 이미 존재하는 record 인 경우, INSERT skip
						commandMap.put("DimTypeID", dimTypeID);
						commandMap.put("DimValueID", dimValueID);
						commandMap.put("ItemTypeCode", itemTypeCode);
						DimTreeAdd.insertToTbItemDimTree(commonService, connectionIdList, commandMap);
					}
			    
				}
				
				/* DELETE TB_ITEM_DIM */
			    setMap.put("DimTypeID", dimTypeID);
			    setMap.put("DimValueID", dimValueID);    
			    setMap.put("s_itemID", itemID);   
			    commonService.delete("dim_SQL.delSubDimValue", setMap); 
				
			}
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
	}
	
	@RequestMapping(value="/objectReportList.do")
	public String objectReportList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		
		String url = "itm/sub/ObjectReportList";
		
		try{
			List getList = new ArrayList();
			Map getMap = new HashMap();
			
			String kbn = StringUtil.checkNull(request.getParameter("kbn"));
			
			getMap.put("s_itemID", request.getParameter("s_itemID"));
			getMap.put("languageID", commandMap.get("sessionCurrLangType"));
			getMap.put("AuthLev", commandMap.get("sessionAuthLev"));
			getMap.put("defLanguageID", commandMap.get("sessionDefLanguageId"));
					
			getList = commonService.selectList("report_SQL.getReportList",getMap);
			
			// IsPublic = 0 인 reportList들은 선택된 Item의 AuthorID와 로그인 유저 ID를 비교해서 
			// 같을 경우 만 reportList에 남겨두고, 다를 경우는 reportList에서 제외 한다
			String loginUser = String.valueOf(commandMap.get("sessionUserId"));
			if (!"1".equals(String.valueOf(commandMap.get("sessionAuthLev")))) {
				for (int i = 0; getList.size() > i; i++) {
					Map map = (Map) getList.get(i);
					String IsPublic = StringUtil.checkNull(map.get("IsPublic"));
					String SeqLevel = StringUtil.checkNull(map.get("SeqLevel"));
					if ("0".equals(IsPublic) || "1".equals(SeqLevel)) {
						String itemAuthorID = StringUtil.checkNull(map.get("AuthorID"));
						if (!itemAuthorID.equals(loginUser)) {
							getList.remove(i);
							i = i - 1;
						}
					}
				}
			}
			
			model.put("getList", getList);
			model.put("menu", getLabel(request, commonService));
			model.put("s_itemID", request.getParameter("s_itemID"));
			model.put("option", request.getParameter("option"));
			model.put("kbn", kbn);
			model.put("backBtnYN", request.getParameter("backBtnYN"));
			model.put("accMode", request.getParameter("accMode"));
			model.put("scrnType", request.getParameter("scrnType"));
			model.put("defDimValueID", StringUtil.checkNull(commandMap.get("defDimValueID")));
			model.put("mstItemID", StringUtil.checkNull(commandMap.get("mstItemID")));
			model.put("strItemID", StringUtil.checkNull(commandMap.get("strItemID")));
			model.put("structureID", StringUtil.checkNull(commandMap.get("structureID")));
			model.put("udfSTR", StringUtil.checkNull(commandMap.get("udfSTR")));
			
		}catch(Exception e){
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl(url);
	}
	/**
	 * AttributeTypeLov update
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/checkDocDownComplete.do")
	public String checkDocDownComplete(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HttpSession session = request.getSession(true);	
			
			String flg = StringUtil.checkNull(session.getAttribute("expFlag"),"N");
			
			if("Y".equals(flg)) {
				target.put(AJAX_SCRIPT, "Y");
			}
			else {
				target.put(AJAX_SCRIPT, "N");
			}
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		
		// model.put("noticType", noticType);

		return nextUrl(AJAXPAGE);
		
	}
	
	@RequestMapping(value="/downloadAllProcessList.do")
	public String downloadAllProcData(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		/* Map setMap = new HashMap(); */
		
		model.put("s_itemID", commandMap.get("s_itemID"));
		model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		/*
		 * setMap.put("languageID", commandMap.get("sessionCurrLangType"));
		 * 
		 * List allProcList =
		 * commonService.selectList("custom_SQL.getProcessListBase_gridList",setMap);
		 * 
		 * JSONArray gridData = new JSONArray(allProcList);
		 * model.put("gridData",gridData);
		 */
		
		
		return nextUrl("/custom/base/report/downloadAllProcessList");
	}
	
	@RequestMapping(value="/processListRPT.do")
	public String processListRPT(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		String url = "/custom/base/report/downloadAllProcessList";
		model.put("s_itemID", commandMap.get("s_itemID"));
		model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		
		if(!StringUtil.checkNull(request.getParameter("url")).equals("")) {
			url = StringUtil.checkNull(request.getParameter("url"),"");
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/updateElementPosition.do")
	public String updateElementPosition(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap setData = new HashMap();
			HashMap updateData = new HashMap();
			List elementList = commonService.selectList("report_SQL.getElmentList",setData);
			String currPath = "";
			String newPath = "";
			String currPositionY = "";
			String newPositionY = "";
			for(int i=0; elementList.size()>i; i++){				
				Map elementListMap = (Map)elementList.get(i);
				updateData = new HashMap();
				currPositionY = StringUtil.checkNull(elementListMap.get("PositionY"));
				if(!currPositionY.equals("") && currPositionY != null){
					newPositionY = StringUtil.checkNull(Float.parseFloat(currPositionY)+250);
					updateData.put("positionY", newPositionY);
				}
				currPath = StringUtil.checkNull(elementListMap.get("Path"));				
				updateData.put("modelID", StringUtil.checkNull(elementListMap.get("ModelID")));
				updateData.put("elementID", StringUtil.checkNull(elementListMap.get("ElementID")));				
				updateData.put("lastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));
				
				if(!currPath.equals("") && currPath != null){
					Map elementMap = getCurrXmlStr(currPath);	
			
					if(!elementMap.isEmpty()){
						String currY = "";
						String valueY[] = StringUtil.checkNull(elementMap.get("valueY")).split(",");
						String newY = "";						
						
						if(valueY.length>0){
							for(int j=0; valueY.length > j; j++){
								currY = StringUtil.checkNull(valueY[j]);
								newY = StringUtil.checkNull((Float.parseFloat(valueY[j])+25));
								if(j==0){
									newPath = currPath.replace(currY, newY);	
								}else{
									newPath = newPath.replace(currY, newY);	
								}
							}
							updateData.put("path", newPath);
						}
					}
				}
				if(!currPositionY.equals("") || !currPath.equals("")){
					commonService.update("report_SQL.updateElementPosionY", updateData);
				}				
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 
			target.put(AJAX_SCRIPT, "this.doCallBack();this.$('#isSubmit').remove();");
		
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
		
	}
	private String valueY = "";


	private Map getCurrXmlStr(String m_xmlStr){
		HashMap currMXCell = new HashMap();
		int startIndex	= m_xmlStr.indexOf("<");		
		do {
			int endIndex 		= m_xmlStr.indexOf(">", startIndex) + 1;			
			String currLine = m_xmlStr.substring(startIndex, endIndex);			
			int startMXTypeIndex	= currLine.indexOf("<") + 1;
			int endMXTypeIndex 		= currLine.indexOf(" ", startMXTypeIndex);
			if(endMXTypeIndex == -1) {endMXTypeIndex = currLine.indexOf(">", startMXTypeIndex);}
			
			String MXType = currLine.substring(startMXTypeIndex, endMXTypeIndex);	
			if (MXType.equals("mxPoint")) {				
				getElementValue(currLine,currMXCell);
			}
			startIndex	= m_xmlStr.indexOf("<", endIndex);
			
		} while(startIndex != -1);	
		valueY = "";
		return currMXCell;
	}
	
	private void getElementValue(String cellStr, HashMap mxCell) {	
		int startIndex	= cellStr.indexOf("x=\"");
		int endIndex 	= 0; 
		String currStr = "";
		int i=0;
	
		startIndex	= cellStr.indexOf("y=\"");
		if(startIndex != -1) {
			startIndex += 3;
			endIndex 	= cellStr.indexOf("\"", startIndex);
			currStr = cellStr.substring(startIndex, endIndex);		
			
			if(valueY.equals("")){
				valueY = currStr;
			}else{
				valueY = valueY + "," + currStr;
			}
			mxCell.put("valueY", valueY);
		}
	}
	
	@RequestMapping(value="/itemExcelIF.do")
	public String itemExcelIF(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		try
		{
			
			/* 선택된 아이템의 해당 CSR 리스트를 취득 */
			commandMap.put("AuthorID", commandMap.get("sessionUserId"));
			commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
			List returnData = commonService.selectList("project_SQL.getCsrListWithMember", commandMap);
			model.put("csrOption", returnData);
			
			model.put("languageID", commandMap.get("sessionCurrLangType"));
			model.put("s_itemID", request.getParameter("itemID"));
			model.put("option", request.getParameter("ArcCode"));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
	
		}catch(Exception e){
			System.out.println(e.toString());
		}
		
		return nextUrl("/report/itemExcelIF");
	}
	
	@RequestMapping(value="/itemExcelIFUpload.do")
	public String itemExcelIFUpload(HashMap commandFileMap, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		int line = 0;
		
		try {
			// UPLOAD
			List list				= (List) commandFileMap.get("STORED_FILES");
			Map map					= (Map) list.get(0);

			String sys_file_name	= (String)map.get("SysFileNm");
			String file_path		= "";
			String file_id			= (String)map.get("AttFileID");

			String filePath			= FileUtil.FILE_UPLOAD_DIR + sys_file_name;
			
			String errorCheckfilePath = GlobalVal.FILE_EXPORT_DIR; //.FILE_UPLOAD_TINY_DIR;

			Map excelMap = new HashMap();
			int total_cnt		= 0;
			int valid_cnt		= 0;
			int attrTypeCode_cnt = 0;
			
			/* 파일 업로드 체크 시 발생한 에러 메세지 출력 파일 생성 */
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			long date = System.currentTimeMillis();
		    String fileName = "Upload_ERROR_" + formatter.format(date) + ".txt";
		    String downFile = errorCheckfilePath + fileName;
			File file = new File(downFile);
			BufferedWriter errorLog = null;
			OutputStreamWriter os = null;
			FileOutputStream fos = null;
			
			try {
				fos = new FileOutputStream(file,true);
				os = new OutputStreamWriter(fos, "UTF-8");
				errorLog = new BufferedWriter(os);
				excelMap = getItemList(new File(filePath), commandFileMap, commandMap, errorLog);
			} catch ( Exception e ) {
	        	System.out.println(e.toString());
	        	throw e;
	        } finally {
	        	errorLog.close();
	        }
			
			List arrayList = (List) excelMap.get("list");
			total_cnt = NumberUtil.getIntValue(excelMap.get("totalCnt"));
			valid_cnt = NumberUtil.getIntValue(excelMap.get("validCnt"));
			attrTypeCode_cnt = NumberUtil.getIntValue(excelMap.get("attrTypeCodeCnt"));
			
			System.out.println("arrayList=="+arrayList);
			System.out.println("total_cnt=="+total_cnt);
			System.out.println("valid_cnt=="+valid_cnt);
			
			String type = StringUtil.checkNull(commandFileMap.get("uploadTemplate"));
			String option =  StringUtil.checkNull(commandFileMap.get("uploadOption").toString());
			
			System.out.println("attrTypeCode_cnt == "+attrTypeCode_cnt);
			System.out.println("type == "+type);
			System.out.println("file_id == "+file_id);
			
			Map resultMap = new HashMap();
			commonService.delete("report_SQL.deleteItemAttrIF", resultMap);
			for(int i=0; i<arrayList.size(); i++){
				Map<String, Object> map2 = (Map<String, Object>) arrayList.get(i);
				
				resultMap.put("ParentID", map2.get("newParentIdentifier").toString());
				resultMap.put("ItemClassCode", map2.get("newClassCode").toString());
				resultMap.put("ProjectID", commandMap.get("csrInfo"));
				
				if (option.equals("2") || option == "2"){ //UPDATE
					resultMap.put("Identifier", map2.get("newIdentifier").toString());
				} else{
					resultMap.put("ItemID", map2.get("newIdentifier").toString());
				}
				
				for (int j = 1; j < attrTypeCode_cnt; j ++) {
					String attrTypeCode = map2.get("newPlainText"+j).toString().substring(0,7);
					String plainText = map2.get("newPlainText"+j).toString().substring(9);
					resultMap.put(attrTypeCode, plainText);
				}
				
				if (type.equals("2") || type == "2"){ //UPDATE
					resultMap.put("Action","U");
					resultMap.put("languageID", commandMap.get("reportLanguage"));
				}
				
				commonService.insert("report_SQL.insertItemAttrIF", resultMap);
			}
			
			String errMsgYN="";
			if (excelMap.get("msg") != null) {
				errMsgYN =  "Y";
			}else{ errMsgYN = "N";}				
			target.put(AJAX_SCRIPT, "parent.doCntReturn('"+total_cnt+"','"+valid_cnt+"','"+attrTypeCode_cnt+"','"+type+"','"+file_id+"','"+errMsgYN+"','"+ fileName +"','"+ downFile +"');");
			
			// 읽어 들인 데이터 체크에서 메세지가 있을 때, 처리를 중단하고 메세지표시
			if (excelMap.get("msg") != null) {				
				errorLog.close();				
			} else {
				file.delete(); // 파일 업로드 정상 종료인경우, 생성된 로그 파일을 삭제 한다.
			}
		}
		catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00073", new String[]{e.getMessage().replaceAll("\"", "")}));
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/callExcelIF.do")
	public String callExcelIf(HashMap commandMap, HttpServletRequest request, ModelMap model) throws Exception {
		Map target = new HashMap();
		
		try{
			Map resultMap = new HashMap();
			resultMap.put("procedureName", "XBOLTADM.TI_ITEM_BATCH");
			commonService.insert("report_SQL.insertExcelIF", resultMap);
			
			String errorCode = StringUtil.checkNull(commonService.selectString("report_SQL.getItemAttrError", resultMap),"");
			String msg = MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00088");
				
			if (!errorCode.equals("")) {
				msg = "Error : " + errorCode;
			}
				
			target.put(AJAX_ALERT,   msg);
			target.put(AJAX_SCRIPT,  "parent.doSaveReturn();parent.$('#isSubmit').remove()");
		}
		catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00073", new String[]{e.getMessage().replaceAll("\"", "")}));
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/subItemInfoReport.do")
	public String subItemInfoReportPop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		
		String pageUrl = StringUtil.checkNull(request.getParameter("pageUrl"),"/popup/subItemInfoRptPop");

		try {
			String s_itemID = StringUtil.checkNull(request.getParameter("itemID"),"");
			String classCodeList = StringUtil.checkNull(request.getParameter("classCodeList"),"");
			String url = StringUtil.checkNull(request.getParameter("url"),"");
			String itemInfoRptUrl = StringUtil.checkNull(request.getParameter("itemInfoRptUrl"),"");
			String accMode = StringUtil.checkNull(request.getParameter("accMode"),"");
			if(!itemInfoRptUrl.equals("")){ url = "/"+ itemInfoRptUrl; }
			
			model.put("s_itemID", s_itemID);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("url", url);
			model.put("classCodeList", classCodeList);
			model.put("accMode", accMode);
			model.put("outputType",StringUtil.checkNull(cmmMap.get("outputType")));
			
			HttpSession session = request.getSession(true);
			
			session.setAttribute("expFlag", "N");

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl(pageUrl);
	}
	
	/**
	 * Sub ItemDetailReport wordReport 출력
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/subItemInfoReportEXE.do")
	public String subItemInfoReportEXE(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		String url= "/custom/base/report/subItemInfoReport";
		if(!StringUtil.checkNull(request.getParameter("URL")).equals("")){ url = "/"+ StringUtil.checkNull(request.getParameter("URL")); }
		try{
			Map setMap = new HashMap();
			String languageId = String.valueOf(commandMap.get("sessionCurrLangType"));
			setMap.put("languageID", languageId);
			setMap.put("langCode", StringUtil.checkNull(commandMap.get("sessionCurrLangCode")).toUpperCase());
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			String s_itemIDs = StringUtil.checkNull(request.getParameter("s_itemIDs"));
			String delItemsYN = String.valueOf(request.getParameter("delItemsYN"));
			String outputType = String.valueOf(request.getParameter("outputType"));
			String paperSize = String.valueOf(request.getParameter("paperSize"));
			String accMode = StringUtil.checkNull(commandMap.get("accMode"),"OPS");
			setMap.put("delItemsYN", delItemsYN);
			
			String[] arrayItems;
			if(s_itemIDs.isEmpty()) {
				arrayItems = s_itemID.split(",");
			} else {
				arrayItems = s_itemIDs.split(",");
			}

			Map attrRsNameMap = new HashMap();
			Map attrRsHtmlMap = new HashMap();
			String selectedItemPath = "";
			String selectedItemName = "";
			List allSubItemList = new ArrayList();
			List items = new ArrayList();
			Map itemsMap = new HashMap();
			
			// 로그인 언어별 default font 취득
			String defaultFont = commonService.selectString("report_SQL.getDefaultFont", setMap);			
			
			for(int index=0; index<arrayItems.length; index++) {
				s_itemID = arrayItems[index];
				setMap.put("s_itemID", s_itemID);
				Map selectedItemMap = commonService.select("report_SQL.getItemInfo", setMap);
				model.put("selectedItemInfo", selectedItemMap);
				
				String classCode = commonService.selectString("report_SQL.getItemClassCode", setMap);
				String classCodeList = StringUtil.checkNull(request.getParameter("classCodeList"));
				String classCodes = "";
				String includeClassCode = "N";
				Map classMap = new HashMap();
				if(!classCodeList.isEmpty() && classCodeList != null){
					String classCodeListSPLT[] = classCodeList.split(",");
					for(int i=0; classCodeListSPLT.length>i; i++){
						if(i == 0){
							classCodes = "'"+classCodeListSPLT[i]+"'";
						}else{
							classCodes = classCodes+",'"+classCodeListSPLT[i]+"'";
						}
					    if(classCode.equals(classCodeListSPLT[i])){
					    	includeClassCode = "Y";
					    }
					}
				} else if(!s_itemIDs.isEmpty()) {
					includeClassCode = "Y";
				}
				model.put("includeClassCode", includeClassCode);
				
				// 선택한 Item의  경로 + 명칭
				selectedItemPath = commonService.selectString("report_SQL.getMyPathAndName", setMap);
				selectedItemName = StringUtil.checkNull(commonService.selectString("report_SQL.getMyIdAndName", setMap)).replace("&#xa;", "");

				// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
				String defaultLang = commonService.selectString("item_SQL.getDefaultLang", commandMap);	
				
				List subItemList = new ArrayList();
				Map setData = new HashMap();	
				String toItemID = "";
				
				// 선택한 Item의 classCode 가 varFilter의 classCodelist와 같으면  하위 항목이 아닌 선택한 Item 정보출력
				if(includeClassCode.equals("Y")){
					items.add(s_itemID);
					setMap.put("itemID", s_itemID);
					subItemList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
					allSubItemList = subItemList;
					/* SubItem list의 연관 프로세스 && 속성 정보 취득 */
					allSubItemList = getCXNItemsInfo(allSubItemList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, accMode, "ItemID");
					itemsMap.put(s_itemID, allSubItemList);
				}else{
					setMap.remove("s_itemID");
					setMap.put("CURRENT_ITEM", request.getParameter("s_itemID")); // 해당 아이템이 [FromItemID]인것
					setMap.put("CategoryCode", "ST1");
					setMap.put("itemClassCodes", classCodes);
					subItemList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
					String itemID="";
					for(int i=0; subItemList.size() > i; i++){
						allSubItemList = new ArrayList();
						allSubItemList.clear();
						Map subItemInfo = (Map)subItemList.get(i);
						allSubItemList.add(subItemInfo);
						itemID = StringUtil.checkNull(subItemInfo.get("ToItemID"));
						items.add(itemID);
						
						setData.put("CURRENT_ITEM", itemID);
						setData.put("CategoryCode", "ST1");
						setData.put("languageID", languageId);
						setData.put("itemClassCodes", classCodes);
						List getSubItemList =  commonService.selectList("report_SQL.getChildItemsForWord", setData);
						
						for(int j=0; getSubItemList.size() > j; j++){
							allSubItemList = new ArrayList();
							allSubItemList.clear();
							Map getSubItemInfo = (Map)getSubItemList.get(j);
							allSubItemList.add(getSubItemInfo);
							itemID = StringUtil.checkNull(getSubItemInfo.get("ToItemID"));
							items.add(itemID);
							
							/* SubItem list의 연관 프로세스 && 속성 정보 취득 */
							allSubItemList = getCXNItemsInfo(allSubItemList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, accMode, "ToItemID");
							itemsMap.put(itemID, allSubItemList);
						}
						
						/* SubItem list의 연관 프로세스 && 속성 정보 취득 */
						allSubItemList = getCXNItemsInfo(allSubItemList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, accMode, "ToItemID");
						itemsMap.put(itemID, allSubItemList);
					}
				}		
			}
			model.put("attrRsNameMap", attrRsNameMap);
			model.put("attrRsHtmlMap", attrRsHtmlMap);
			model.put("allSubItemList", allSubItemList);
			model.put("items", items);
			model.put("itemsMap",itemsMap);
			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			model.put("setMap", setMap);
			model.put("outputType", outputType);
			model.put("paperSize", paperSize);
			model.put("defaultFont", defaultFont);
			model.put("selectedItemPath", selectedItemPath);
			model.put("itemName", selectedItemName);
			model.put("selectedItemName", URLEncoder.encode(selectedItemName, "UTF-8").replace("+", "%20"));
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00105")); // DB에 생성된 모델이 없습니다.
			target.put(AJAX_SCRIPT, "parent.goBack();parent.$('#isSubmit').remove();");
			
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(url);
	}
	
	/**
	 * Connection 의 Info 정보 취득
	 * @param List
	 * @param defaultLang
	 * @param sessionCurrLangType
	 * @return
	 * @throws Exception
	 */
	private List getCXNItemsInfo(List List, String defaultLang, String sessionCurrLangType, Map attrRsNameMap, Map attrRsHtmlMap, String accMode , String source) throws Exception {
		List resultList = new ArrayList();
		Map setMap = new HashMap();
		List cngtList = new ArrayList();
		List attrList = new ArrayList();
		Map attrMap = new HashMap();
		
		for (int i = 0; i < List.size(); i++) {
			Map listMap = new HashMap();
			List resultSubList = new ArrayList();
			
			listMap = (Map) List.get(i);
			String itemId = String.valueOf(listMap.get(source));
			setMap.put("itemID", itemId);
			setMap.put("s_itemID", itemId);
			setMap.put("languageID", sessionCurrLangType);

			// 개정이력(changeSet) 취득
			setMap.put("itemId", itemId);
			cngtList = commonService.selectList("report_SQL.getItemChangeListRPT", setMap);
			listMap.put("cngtList", cngtList);	
			
			/* 기본정보 내용 취득 */
			Map prcList = commonService.select("report_SQL.getItemInfo", setMap);
			/* 기본정보의 속성 내용을 취득 */
			List attrOrgList = new ArrayList();
			String changeSetID = "";
			setMap.put("ItemID", itemId);
			setMap.put("DefaultLang", defaultLang);
			setMap.put("sessionCurrLangType", sessionCurrLangType);
			
			if("OPS".equals(accMode)) {
				changeSetID = StringUtil.checkNull(prcList.get("ReleaseNo"));
				setMap.put("changeSetID",changeSetID);
				if(!changeSetID.equals("0")) {		// 신규 아닐 경우
					prcList = commonService.select("item_SQL.getItemAttrRevInfo", setMap);
				}
				attrOrgList = commonService.selectList("item_SQL.getItemRevDetailInfo", setMap);
			} else {
				changeSetID = StringUtil.checkNull(prcList.get("CurChangeSet"));
				attrOrgList = commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
			}
			
			String plainText = "";
			for (int k = 0; attrOrgList.size()>k ; k++ ) {
				Map map = (Map) attrOrgList.get(k);				
				attrRsNameMap.put(map.get("AttrTypeCode"), map.get("Name"));
				attrRsHtmlMap.put(map.get("AttrTypeCode"), map.get("HTML"));
				if(map.get("DataType").equals("MLOV")){
					plainText = getMLovVlaue(sessionCurrLangType, itemId, StringUtil.checkNull(map.get("AttrTypeCode")));
				//	listMap.put(map.get("AttrTypeCode"), plainText);
				}else{
					plainText = StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(map.get("PlainText")));
				//	listMap.put(map.get("AttrTypeCode"), plainText);
				}
				attrMap = new HashMap();
				attrMap.put("AttrTypeCode",map.get("AttrTypeCode"));
				attrMap.put("Name",map.get("Name"));
				attrMap.put("PlainText",plainText);
				attrMap.put("PlainText2",map.get("PlainText2"));
				attrMap.put("LovCode",map.get("LovCode"));
				attrMap.put("BaseLovCode",map.get("BaseLovCode"));
				attrMap.put("DataType",map.get("DataType"));
				attrMap.put("IsComLang",map.get("IsComLang"));
				attrMap.put("HTML",map.get("HTML"));
				attrMap.put("AreaHeight",map.get("AreaHeight"));
				attrMap.put("ItemID",map.get("ItemID"));
				attrMap.put("AttrTypeCode",map.get("AttrTypeCode"));
				attrList.add(attrMap);
			}
			
			
			listMap.put("prcList", prcList);	
			listMap.put("attrList", attrList);	
			
			// Team Role
			setMap.put("assigned","1");
			List roleList = commonService.selectList("role_SQL.getItemTeamRoleList_gridList", setMap);
			listMap.put("roleList", roleList);
			
			// 연관항목 리스트
			List relItemList = new ArrayList();
			List relItemTemp = commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);
			
			String isFromItem = "Y";
			if(!source.equals("FromItemID")){ isFromItem = "N"; }
			for(int j=0; j< relItemTemp.size(); j++){
				Map relItem = (Map) relItemTemp.get(j);
				Map temp = new HashMap();
				temp.put("languageID", sessionCurrLangType);
				String typeCode= (String) relItem.get("ItemTypeCode");
				String cxnCode = "CN001"+typeCode.substring(5, 7);
				temp.put("varFilter",cxnCode);
				temp.put("isFromItem", isFromItem);
				temp.put("s_itemID",relItem.get("s_itemID"));
				List relCxnItemList = commonService.selectList("item_SQL.getCXNItems", temp);
				relItem.put("cxnList", relCxnItemList);
				relItemList.add(j,relItem);
				
				List relatedAttrList = new ArrayList();
				for (int k = 0; relCxnItemList.size()>k ; k++ ) {
					Map map = (Map) relCxnItemList.get(k);
					resultSubList.add(StringUtil.checkNull(map.get("RelIdentifier")) + " " + removeAllTag(StringUtil.checkNull(map.get("RelName"))));
					String cnItemItem = "";
					if(k > 0){
						cnItemItem = " / "+StringUtil.checkNull(map.get("RelIdentifier")) + " " + removeAllTag(StringUtil.checkNull(map.get("RelName")));
					}
					setMap.put("ItemID", map.get("CnItemID"));
					setMap.put("DefaultLang", defaultLang);
					setMap.put("sessionCurrLangType", sessionCurrLangType);
					relatedAttrList = commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
					if(relatedAttrList.size()>0){
						for(int m=0; m<relatedAttrList.size(); m++){
							Map relAttrMap = (Map) relatedAttrList.get(m);						
							cnItemItem = cnItemItem +StringUtil.checkNull(relAttrMap.get("Name"))+StringUtil.checkNull(relAttrMap.get("PlainText"))+StringUtil.checkNull(relAttrMap.get("HTML"));
						}
					}
					resultSubList.add(cnItemItem);
					cnItemItem = "";
				}
			}
			
			listMap.put("resultSubList", resultSubList);
			listMap.put("relItemList", relItemList);		
			
			List dimInfoList = commonService.selectList("dim_SQL.selectDim_gridList", setMap);
			List dimResultList = new ArrayList();
			Map dimResultMap = new HashMap();
			String dimTypeName = "";
			String dimValueNames = "";
			if(dimInfoList.size()>0){
				for(int k = 0; k < dimInfoList.size(); k++){
					Map map = (HashMap)dimInfoList.get(k);
					
					if (k > 0) {
						if(dimTypeName.equals(map.get("DimTypeName").toString())) {
							dimValueNames += " / "+map.get("DimValuePath").toString();
						} else {
							dimResultMap.put("dimValueNames", dimValueNames);
							dimResultList.add(dimResultMap);
							dimResultMap = new HashMap(); // 초기화
							dimTypeName = map.get("DimTypeName").toString();
							dimResultMap.put("dimTypeName", dimTypeName);
							dimValueNames = map.get("DimValuePath").toString();
						}
					}else{
						dimTypeName = map.get("DimTypeName").toString();
						dimResultMap.put("dimTypeName", dimTypeName);
						dimValueNames = map.get("DimValuePath").toString();
					}
				}
			
			}
			if (dimInfoList.size() > 0) {
				dimResultMap.put("dimValueNames", dimValueNames);
				dimResultList.add(dimResultMap);
			}
			
			listMap.put("dimResultList", dimResultList);
			
			// 변경이력 목록 getChangeSetInfo
			setMap = new HashMap();
			setMap.put("s_itemID", itemId);
			List changeSetList = commonService.selectList("report_SQL.getChangeSetInfo", setMap);
			listMap.put("changeSetList", changeSetList);
			
			// 첨부파일 리스트 
			setMap.put("DocumentID", itemId); 
			setMap.put("DocCategory", "ITM");
			setMap.put("languageID", sessionCurrLangType);
			setMap.put("changeSetID",changeSetID);
			List fileList = commonService.selectList("fileMgt_SQL.getFile_gridList", setMap);
			listMap.put("fileList", fileList);
			
			resultList.add(listMap);
		}
		
		return resultList;
	}
	
	
//===============OLM V4 TREEGRID START ===========================
	
	public static void sendToJson(String jObj, HttpServletResponse res) {
		try {
			res.setHeader("Cache-Control", "no-cache");
			res.setContentType("text/plain");
			res.setCharacterEncoding("UTF-8");
			if(!jObj.equals("{rows: [ ]}")){
				res.getWriter().print(jObj);
			}
			else {
				PrintWriter pw = res.getWriter();
				pw.write("데이터가 존재하지 않습니다.");
			}

			System.out.println("json Object :"+jObj);
			
		} catch (IOException e) {
			MessageHandler.getMessage("json.send.message");
			e.printStackTrace();
		}
	}
	
	private final static String IMG_NEW_SRC = "@{new}";
	private final static String IMG_NEW_TARGET_OPEN = "<img src='";
	private final static String IMG_NEW_TARGET_CLOSE = "/images/btn_star.gif' width='13' height='13' />";
	
	
//	  엔터를 <br/>로 변환한다.
//	  @param object
//	  @return
	 
	private static Object get(Object object, final String contextPath) {
		if(object == null) {
			return "";
		}
		if(object instanceof java.lang.String) {
			String result = StringUtil.replace((String)object, "\n", "<br/>");
			result = StringUtil.replace(result, IMG_NEW_SRC, IMG_NEW_TARGET_OPEN+contextPath + IMG_NEW_TARGET_CLOSE);
			result = StringUtil.replace(result, "\r", "<br/>");
			if(result.indexOf('"')!=-1) {
				result = StringUtil.replace(result, "\"", "＂");
			}
			if(result.indexOf('\\')!=-1) {
				result = StringUtil.replace(result, "\\", "/");
			}
			return result;
		}
		return object;
	}
	
	@RequestMapping(value = "/itemTreeListByDim.do")
	public String itemTreeListByDim(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		try {
			Map setMap = new HashMap();
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String rootItemID = StringUtil.checkNull(request.getParameter("rootItemID"));	
			String rootClassCode = StringUtil.checkNull(request.getParameter("rootClassCode"));	
			String selectedDimClass = StringUtil.checkNull(request.getParameter("selectedDimClass"));	
			String cxnTypeCode = StringUtil.checkNull(request.getParameter("cxnTypeCode"));	
			int maxTreeLevel = Integer.parseInt(request.getParameter("maxTreeLevel"));	
			String dimTypeID = StringUtil.checkNull(request.getParameter("dimTypeID"));	
			
			setMap.put("languageID", languageID);	
			setMap.put("sessionCurrLangType", languageID);	
			setMap.put("reportCode",StringUtil.checkNull(request.getParameter("reportCode"), ""));
			setMap.put("rootItemID", rootItemID);
			setMap.put("itemTypeCode", cxnTypeCode);
			setMap.put("classCode", rootClassCode);
			setMap.put("DimTypeID",dimTypeID);
			
			List dimValueNmList = (List) commonService.selectList("dim_SQL.getDimValueList", setMap);
			
			String treegridHeader = "";
			String cols = "";
			for(int i=0;i<dimValueNmList.size();i++) {
				Map temp = (Map)dimValueNmList.get(i);
				if(i > 0) {
					treegridHeader += "{width:100, id:"+StringUtil.checkNull(temp.get("CODE"))+", type:\"string\", header:[{text:\""+StringUtil.checkNull(temp.get("NAME"))+"\", align: \"center\"}], align: \"center\"},";
					cols += "|"+StringUtil.checkNull(temp.get("CODE"));
				}
				else {
					treegridHeader = "{width:100, id:"+StringUtil.checkNull(temp.get("CODE"))+", type:\"string\", header:[{text:\""+StringUtil.checkNull(temp.get("NAME"))+"\", align: \"center\"}], align: \"center\"},";
					cols = "|"+StringUtil.checkNull(temp.get("CODE"));
				}
			}
			
			model.put("reportCode", StringUtil.checkNull(request.getParameter("reportCode"), ""));
			model.put("treegridHeader", treegridHeader);
			model.put("dimcols", cols);
			model.put("dimTypeID", dimTypeID);
			model.put("rootItemID", rootItemID);
			model.put("rootClassCode", rootClassCode);
			model.put("selectedDimClass", selectedDimClass);
			model.put("cxnTypeCode", cxnTypeCode);
			model.put("maxTreeLevel", maxTreeLevel);
			model.put("title", commonService.selectString("report_SQL.getReportName", setMap));
			setMap.put("reportCode",StringUtil.checkNull(request.getParameter("reportCode"), ""));
			model.put("reportCode", StringUtil.checkNull(request.getParameter("reportCode"), ""));
			model.put("menu", getLabel(request, commonService)); // Label Setting 
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/report/itemTreeListByDim");
	}
	
	@RequestMapping(value="/getItemTreeListByDim.do")
	public void getItemTreeListByDim( Map cmmMap, HttpServletResponse response ) throws Exception {
		Map setMap = new HashMap();
		try {
			//List treeRootItemData = new ArrayList();
			List itemTreeListByDimList = new ArrayList();
			List fromItemIdList = new ArrayList();
			List dimValueList = new ArrayList();
			List dimValueNmList = new ArrayList();			
			String rootItemID = StringUtil.checkNull(cmmMap.get("rootItemID"));	
			String rootClassCode = StringUtil.checkNull(cmmMap.get("rootClassCode"));	
			String dimTypeID = StringUtil.checkNull(cmmMap.get("dimTypeID"));	
			String cxnTypeCode = StringUtil.checkNull(cmmMap.get("cxnTypeCode"));	
			String selectedDimClass = StringUtil.checkNull(cmmMap.get("selectedDimClass"));	
			
			int maxTreeLevel = Integer.parseInt(StringUtil.checkNull(cmmMap.get("maxTreeLevel")));	
		
			setMap.put("dimTypeID",dimTypeID);
			setMap.put("rootItemID", rootItemID);
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));			
			setMap.put("itemTypeCode", cxnTypeCode);
			setMap.put("classCode", rootClassCode);

			// Get RootItem Data 
			List <Map>treeRootItemData =commonService.selectList("report_SQL.getTreeRootItem", setMap);
						
			for (int i=0; treeRootItemData.size()>i ; i++ ) {
				Map tempMap0 = (Map) treeRootItemData.get(i);
				rootItemID = String.valueOf(tempMap0.get("ItemID"));
				setMap.put("ItemTypeCode", tempMap0.get("ItemTypeCode"));
				setMap.put("classCode", tempMap0.get("Level"));
			}
			
			// FromItemIdList Setting 
			Map tempMap1 = new HashMap();
			tempMap1.put("ToItemID", rootItemID);
			fromItemIdList.add(tempMap1);
			
			// Get ChildItem Data 
			for(int i=1; i<maxTreeLevel; i++){	
				if(0<fromItemIdList.size()){
					setMap.put("FromItemIdList", fromItemIdList);
					setMap.put("treeLevel", i);
					List <Map>treetItemData =commonService.selectList("report_SQL.getItemTreeListByDimList", setMap);
					itemTreeListByDimList.add(treetItemData);
					fromItemIdList = (List) commonService.selectList("report_SQL.getItemTreeListByDimFromItemId", setMap);					
				}
			}
			
			// Get DimValue Data
			dimValueList = (List) commonService.selectList("dim_SQL.getDimValueNameList", setMap);
			
			cmmMap.put("DimTypeID", dimTypeID);
			dimValueNmList = (List) commonService.selectList("dim_SQL.getDimValueList", cmmMap);
			
			String [] cols = ((String)cmmMap.get("cols")).split("[|]");
			
			for(int j=0; j<itemTreeListByDimList.size(); j++) {
				List itemTreeList = (List)itemTreeListByDimList.get(j);
				for(int i=0; i<itemTreeList.size(); i++) {
					Map itemMap = (Map)itemTreeList.get(i);
					
					treeRootItemData.add(itemMap);
				}
			}
			
			for(int i=0; treeRootItemData.size()>i; i++) {
				Map treeDataInfo = (Map)treeRootItemData.get(i);
				String dimValueIDs[] = StringUtil.checkNull(treeDataInfo.get("DimValueID")).split(",");
				String classCode = StringUtil.checkNull(treeDataInfo.get("Level"));
				for(int l4d=0; l4d < dimValueList.size(); l4d++) {
					Map tempDimValue = (Map)dimValueList.get(l4d);
					for (String DimValueID : dimValueIDs) {
						
						if(tempDimValue.get("DimValueID").equals(DimValueID) && classCode.equals(selectedDimClass)){ 
							treeDataInfo.put(tempDimValue.get("DimValueID"), "O");
						}else {
							if(!StringUtil.checkNull(treeDataInfo.get(tempDimValue.get("DimValueID"))).equals("O")){
								treeDataInfo.put(tempDimValue.get("DimValueID"), " ");
							}
						}
					}
				}
			}
			
			returnTreeGridJson(treeRootItemData, cols, response, (String)cmmMap.get("contextPath"));
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
	}
	
	public static void returnTreeGridJson(List list, final String[]cols, HttpServletResponse res, final String contextPath){
		sendToJson(parseTreeGridJson(list, cols,contextPath), res);
	}
	
	public static String parseTreeGridJson(List list, final String[]cols, final String contextPath) {
		final String OPEN = "[";
		final String COT = "\"";
		final String COMMA = ",";
		final String CLOSE = "]";
		final String BOPEN = "{";
		final String BClOSE = "}";
		final String COL = ":";

		StringBuffer result = new StringBuffer();
		
		if (list != null && list.size()>0 && cols != null && cols.length > 0) {
			result.append(OPEN);
			for (int i = 0; i < list.size(); i++) {
				if (i != 0) {
					result.append(COMMA);
				}
				Map map = (Map) list.get(i);
				result.append(BOPEN);
				int j=0;
				for (String string : cols) {
					if (j>0 && !StringUtil.checkNull(map.get(string)).equals("") && !StringUtil.checkNull(map.get(string)).equals("1") ) {
						result.append(COMMA);
					}
					
					if( !StringUtil.checkNull(map.get(string)).equals("") && !StringUtil.checkNull(map.get(string)).equals("1") ) {
						result.append(COT).append(string).append(COT).append(COL);
						if(string.equals("TREE_NM")) {
							result.append(COT).append("<img src=/cmm/common/images/item/img_process.png>"+get(map.get(string), contextPath)).append(COT);
						} else {
							result.append(COT).append(get(map.get(string), contextPath)).append(COT);
						}
						j++;
					}
				}
				result.append(BClOSE);
			}
			result.append(CLOSE);
		}

		// System.out.println("V7 result.toString() 1111 :"+result.toString().replaceAll("PRE_TREE_ID","parent").replaceAll("TREE_ID", "id").replaceAll("TREE_NM","value").replaceAll("PRE_id","parent").replaceAll(",,",","));
		
		String resultData = result.toString().replaceAll("PREE_TREE_ID","parent").replaceAll("TREE_ID", "id").replaceAll("TREE_NM","value").replaceAll("PRE_id","parent").replaceAll(",,",",");
		return resultData;
	}

	//===============OLM V4 TREEGRID END =========================================================
	 

	
	private Map getCountMap(List conutList) {
		Map contMap = new HashMap();
		Map mapValue = new HashMap();
		for(int i = 0; i < conutList.size(); i++){
			mapValue = (HashMap)conutList.get(i);
			contMap.put(mapValue.get("Identifier"), mapValue.get("CNT"));
		}
		
		return contMap;
	}
	private String makeGridHeader(List list, String conStr) {
		String strHeader = "";
		for (int i = 0; list.size() > i ; i++) {
			Map map = (Map) list.get(i);
        	String name = (String) map.get("Identifier");
        	
			strHeader = strHeader + conStr + name;
		}		
		return strHeader;
	}
	private String makeGridHeader(List list, String keyName ,String conStr) {
		String strHeader = "";
		for (int i = 0; list.size() > i ; i++) {
			Map map = (Map) list.get(i);
        	String name = (String) map.get(keyName);
        	
			strHeader = strHeader + conStr + name;
		}		
		return strHeader;
	}
	
	// itemTotalList 출력 리포트
	@RequestMapping(value="/itemTotalReport.do")
	public String itemTotalReport(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		try{
			String s_itemID = StringUtil.checkNull(request.getParameter("itemID"),"");
			String arcCode = StringUtil.checkNull(request.getParameter("ArcCode"),"");
			String url = StringUtil.checkNull(request.getParameter("url"),"");
			String objType = StringUtil.checkNull(request.getParameter("objType"),"OJ00001");
			String classCode = StringUtil.checkNull(request.getParameter("classCode"),"CL01005");
			String rnrOption = StringUtil.checkNull(request.getParameter("rnrOption"),"");		// 1 : 하위항목, 2 : 엘리먼트 리스트
			String elmClassList = StringUtil.checkNull(request.getParameter("elmClassList"),"");
			String accMode = StringUtil.checkNull(request.getParameter("accMode"),"");	
			String activityMode = StringUtil.checkNull(request.getParameter("activityMode"),"");	
//			String customMode = StringUtil.checkNull(request.getParameter("customMode"),"");
			
			commandMap.put("ItemTypeCode", objType);
			Map modelExist = commonService.select("common_SQL.getMDLTypeCode_commonSelect", commandMap);
			
		
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
			model.put("s_itemID", s_itemID);
			model.put("arcCode", arcCode);
			model.put("url", url);
			model.put("objType", objType);
			model.put("classCode", classCode);
			model.put("rnrOption", rnrOption);
			model.put("elmClassList", elmClassList);
			model.put("modelExist", modelExist.size());
			model.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType"), ""));
			model.put("accMode", accMode);
			model.put("activityMode", activityMode);
//			model.put("customMode", customMode);
		} catch(Exception e) {
			System.out.println(e.toString());
		}
		
		return nextUrl("/report/itemTotalReport");
	}
	
	/**
	 * itemDocReport 출력
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/itemDocReport.do")
	public String itemDocReport(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception{
		Map target = new HashMap();
		// client별 word report url 설정
		String url= "/custom/base/report/processReport";
		if(!StringUtil.checkNull(commandMap.get("exportUrl")).equals("")){ url = "/"+ StringUtil.checkNull(commandMap.get("exportUrl")); }
		try{
			Map setMap = new HashMap();
			String languageId = String.valueOf(commandMap.get("sessionCurrLangType"));
			String delItemsYN = StringUtil.checkNull(commandMap.get("delItemsYN"));
			String accMode = StringUtil.checkNull(request.getParameter("accMode"),""); 
			String activityMode = StringUtil.checkNull(request.getParameter("activityMode"),""); //하위항목 모드 : 기본 - 아이템의 하위항목 / element = 모델에 존재하는 L4,L5 항목
//			String customMode=StringUtil.checkNull(commandMap.get("customMode"),"");
			
			setMap.put("languageID", languageId);
			setMap.put("langCode", StringUtil.checkNull(commandMap.get("sessionCurrLangCode")).toUpperCase());
			setMap.put("s_itemID", request.getParameter("s_itemID"));
			setMap.put("ArcCode", request.getParameter("ArcCode"));
			setMap.put("rnrOption", request.getParameter("rnrOption"));
			setMap.put("delItemsYN", delItemsYN);
			setMap.put("accMode", accMode);
			setMap.put("activityMode", activityMode);
			
			setMap.put("csYN", request.getParameter("csYN"));
			setMap.put("occYN", request.getParameter("occYN"));
			setMap.put("cxnYN", request.getParameter("cxnYN"));
			setMap.put("fileYN", request.getParameter("fileYN"));
			setMap.put("teamYN", request.getParameter("teamYN"));
			setMap.put("rnrYN", request.getParameter("rnrYN"));
			setMap.put("elmClassList", request.getParameter("elmClassList"));
			setMap.put("subItemYN", request.getParameter("subItemYN"));
			
			// 파일명에 이용할 Item Name 을 취득
			if("OPS".equals(accMode)) {
				setMap.put("attrRevYN", "Y");
			}
			
		
			Map selectedItemMap = commonService.select("report_SQL.getItemInfo", setMap);
			setMap.put("ReleaseNo",selectedItemMap.get("ReleaseNo"));
			
			/* 첨부 문서 취득 */
			setMap.put("DocumentID", request.getParameter("s_itemID"));
			setMap.put("DocCategory", "ITM");
			List L2AttachFileList = commonService.selectList("fileMgt_SQL.getFile_gridList", setMap);
			// 로그인 언어별 default font 취득
			String defaultFont = commonService.selectString("report_SQL.getDefaultFont", setMap);			
			
			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", commandMap);			
			List modelList = new ArrayList();
			List totalList = new ArrayList();
			
			List allTotalList = new ArrayList();
			Map allTotalMap = new HashMap();
			Map titleItemMap = new HashMap();
			String e2eModelId = "";
			Map e2eModelMap = new HashMap();
			List subTreeItemIDList = new ArrayList();
			String selectedItemPath = "";
			Map e2eAttrMap = new HashMap();
			Map e2eAttrNameMap = new HashMap();
			Map e2eAttrHtmlMap = new HashMap();
			List e2eDimResultList = new ArrayList();
			
			Map gItem = new HashMap();			// L2
			List pItemList = new ArrayList();			// L3
			List mainItemList = new ArrayList();	// L4
			
			String reportCode = StringUtil.checkNull(commandMap.get("reportCode"));
			String classCode = commonService.selectString("report_SQL.getItemClassCode", setMap);
			String objType = StringUtil.checkNull(commandMap.get("objType"));
			setMap.put("classCode", classCode);
			setMap.put("ItemTypeCode", objType);
			int maxLevel = Integer.parseInt(commonService.selectString("analysis_SQL.getItemClassMaxLevel", setMap));
			
			// 해당 아이템의 레벨 확인
			int Level = Integer.parseInt(commonService.selectString("report_SQL.getLevelfromClassCode", setMap));
			
			if(Level == 2){							// L2에서 워드리포트 실행 경우
				gItem = selectedItemMap;
				
				setMap.put("CURRENT_ITEM", selectedItemMap.get("ItemID"));
				setMap.put("CategoryCode", "ST1");
				pItemList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
				
				for(int i = 0; i<pItemList.size(); i++){
					Map pItemMap = (Map) pItemList.get(i);
					setMap.put("classCode", pItemMap.get("toItemClassCode"));
					// 하위항목의 레벨 확인
					int pItemLevel = Integer.parseInt(commonService.selectString("report_SQL.getLevelfromClassCode", setMap));
					pItemLevel++;
					if(pItemLevel != maxLevel){
						setMap.put("CURRENT_ITEM", pItemMap.get("ToItemID"));
						setMap.put("CategoryCode", "ST1");
						mainItemList.add(commonService.selectList("report_SQL.getChildItemsForWord", setMap));
					}
				}
			}
			if(Level == 3){				// L3에서 워드리포트 실행 경우
				setMap.put("classCode", selectedItemMap.get("ClassCode"));
				// 하위항목의 레벨 확인
				int pItemLevel = Integer.parseInt(commonService.selectString("report_SQL.getLevelfromClassCode", setMap));
				pItemLevel++;
				if(pItemLevel != maxLevel){
					pItemList.add(selectedItemMap);
					setMap.put("CURRENT_ITEM", selectedItemMap.get("ItemID"));
					setMap.put("CategoryCode", "ST1");
					mainItemList.add(commonService.selectList("report_SQL.getChildItemsForWord", setMap));
				}
			}
			
			// 선택된 Item의 Path취득 (Id + Name)
			selectedItemPath= selectedItemMap.get("Identifier")+" "+selectedItemMap.get("ItemName");
			model.put("gItem", gItem);
			model.put("pItemList", pItemList);
			model.put("mainItemList", mainItemList);
			
			setMap.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
			
			String arcCode = StringUtil.checkNull(request.getParameter("ArcCode"));
			commandMap.put("ArcCode", arcCode);
			commandMap.put("SelectMenuId", arcCode);
			Map arcTreeFilterInfoMap =  commonService.select("report_SQL.getArcTreeFilterInfo", commandMap);	
			String TreeSql = StringUtil.checkNull(arcTreeFilterInfoMap.get("TreeSql"));
			commandMap.put("TreeSql", TreeSql);	
			String outPutItems = "";
			if(TreeSql != null && !"".equals(TreeSql))	{
				outPutItems = getArcTreeIDs(commandMap);
				commandMap.put("outPutItems", outPutItems);
			}
			
			if (classCode.equals("CL04005")) {
				setMap.put("classCode", classCode);
				setMap.put("itemTypeCode", objType);
				List arcTreeIdList = commonService.selectList("custom_SQL.zHdhi_getBatchList", setMap);
				String result = "";
				for (int i = 0; arcTreeIdList.size() > i; i++) {
					Map map = (Map) arcTreeIdList.get(i);
					String treeId = String.valueOf(map.get("TREE_ID"));
					if (result.isEmpty()) {
						result = treeId;
					} else {
						result = result + "," + treeId;
					}
				}
				
				outPutItems = result;
			}
			
			setMap.put("outPutItems", outPutItems);
			setMap.put("selectLanguageID", StringUtil.checkNull(commandMap.get("selectLanguageID")));	
			modelList = commonService.selectList("report_SQL.getItemStrList_gridList", setMap);
			setMap.remove("ClassCode");
			
			subTreeItemIDList = getChildItemList(commonService, request.getParameter("s_itemID"), classCode, languageId, outPutItems, delItemsYN);
			
			/** 선택된 Item의 SubProcess Item취득(L2) */
			setMap.put("CURRENT_ITEM", request.getParameter("s_itemID")); // 해당 아이템이 [FromItemID]인것
			setMap.put("CategoryCode", "ST1");
			setMap.put("languageID", languageId);
			setMap.put("toItemClassCode", "CL01004");   
			
			List L2SubItemInfoList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
			allTotalMap.put("L2SubItemInfoList", L2SubItemInfoList);
			
//			setMap.put("toItemClassCode", "CL01006"); //Activity 리스트
//			List L5SubItemInfoList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
//			allTotalMap.put("L5SubItemInfoList", L5SubItemInfoList);
			
			// QMS&E2E 의 경우 연관항목 추출 (개요에 사용)
			if ("element".equals(activityMode)) {
				setMap.put("cxnYN", "on");
				// rnrYN 이 on 일 때, subItem 정보 필요
				if("on".equals(StringUtil.checkNull(setMap.get("rnrYN")))) {
					setMap.put("subItemYN", "on");
				}
			}
//			List cngtList = new ArrayList();
//
//			//if(customMode.equals("Y")) {
//				setMap.put("itemId",   request.getParameter("s_itemID"));
//				//표지 히스토리
//				 cngtList = commonService.selectList("report_SQL.getItemChangeListRPT", setMap);
//
//				 allTotalMap.put("cngtList", cngtList);
//			//}
			
			// 해당 아이템의 하위 항목의 서브프로세스 수 만큼 word report 작성
			getItemTotalInfo(totalList, modelList, setMap, request, commandMap, defaultLang, languageId, accMode);
			titleItemMap = selectedItemMap;
			allTotalMap.put("titleItemMap", titleItemMap);
			allTotalMap.put("totalList", totalList);
			allTotalMap.put("L2AttachFileList", L2AttachFileList);
			allTotalList.add(allTotalMap);
			
			
//			// RASI ACTIVITY INFO ("languageID", languageId);
//			commandMap.put("languageID", languageId);
//			commandMap.put("s_itemID", request.getParameter("s_itemID"));
//
//
//
//		    List<Map<String, Object>> activityList = commonService.selectList("zSK_SQL2.getProcessActivity_gridList", commandMap);
//
//		    model.put("activityList", activityList);
		
		
			
			model.put("allTotalList", allTotalList);
			model.put("e2eModelMap", e2eModelMap); // E2E report 출력인 경우
			model.put("e2eItemInfo", selectedItemMap); // E2E report 출력인 경우
			model.put("e2eAttrMap", e2eAttrMap); // E2E report 출력인 경우
			model.put("e2eAttrNameMap", e2eAttrNameMap); // E2E report 출력인 경우
			model.put("e2eAttrHtmlMap", e2eAttrHtmlMap); // E2E report 출력인 경우
			model.put("e2eDimResultList", e2eDimResultList); // E2E report 출력인 경우
			
			model.put("onlyMap", request.getParameter("onlyMap"));
			model.put("paperSize", request.getParameter("paperSize"));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			model.put("setMap", setMap);
			model.put("defaultFont", defaultFont);
			model.put("subTreeItemIDList", subTreeItemIDList);
			model.put("selectedItemPath", selectedItemPath);
			String itemNameofFileNm = StringUtil.checkNull(selectedItemMap.get("ItemName")).replace("&#xa;", "");
			model.put("ItemNameOfFileNm", URLEncoder.encode(itemNameofFileNm, "UTF-8").replace("+", "%20"));
			model.put("selectedItemIdentifier", StringUtil.checkNull(selectedItemMap.get("Identifier")));
			model.put("outputType", request.getParameter("outputType"));  
			model.put("selectedItemMap", selectedItemMap);
			
			setMap.put("teamID", StringUtil.checkNull(selectedItemMap.get("OwnerTeamID")));
			Map managerInfo = commonService.select("user_SQL.getUserTeamManagerInfo", setMap);
			model.put("ownerTeamMngNM",managerInfo.get("MemberName"));	// 프로세스 책임자
			
			model.put("csYN", request.getParameter("csYN"));
			model.put("occYN", request.getParameter("occYN"));
			model.put("cxnYN", request.getParameter("cxnYN"));
			model.put("fileYN", request.getParameter("fileYN"));
			model.put("teamYN", request.getParameter("teamYN"));
			model.put("rnrYN", request.getParameter("rnrYN"));
			model.put("subItemYN", request.getParameter("subItemYN"));
			model.put("reportCode", StringUtil.checkNull(request.getParameter("reportCode"), ""));
//			model.put("customMode", customMode);
	
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00105")); // DB에 생성된 모델이 없습니다.
			target.put(AJAX_SCRIPT, "parent.goBack();parent.$('#isSubmit').remove();");
			System.out.println("totalList == "+totalList);
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(url);	
	}
	
	/**
	 * 각 아이템 총정보를 취득
	 * @param totalList
	 * @param modelList
	 * @param setMap
	 * @param request
	 * @param commandMap
	 * @param defaultLang
	 * @param languageId
	 * @throws Exception
	 */
	public void getItemTotalInfo(List totalList, List modelList, Map setMap, HttpServletRequest request, HashMap commandMap, String defaultLang, String languageId, String accMode) throws Exception {
		String beforFromItemID = "";
		for (int index = 0; modelList.size() > index; index++) {
			Map map = new HashMap();
			Map totalMap = new HashMap();
			Map subProcessMap = (Map) modelList.get(index);
			Map activityMap = new HashMap();
			
			List cngtList = new ArrayList(); // 변경이력 리스트
			List detailElementList = new ArrayList(); // 연관 프로세스 리스트
			List relItemList = new ArrayList(); // 연관 항목 리스트
			List relItemConList = new ArrayList(); // 연관 항목 Connected Process 리스트 
			List relItemSubList = new ArrayList(); // 연관 항목 sub item 리스트 (L4한정)
			List dimResultList = new ArrayList(); // 디멘션 정보
			List attachFileList = new ArrayList();	//첨부문서 리스트
			List roleList = new ArrayList();	//관련조직 리스트
			List rnrList = new ArrayList();	//rnr 리스트
			List elmObjList = new ArrayList();		// OJ, MOJ 엘리먼트 리스트
			List elementList = new ArrayList(); // element List
//			List termList = new ArrayList();
			
			String activityMode = StringUtil.checkNull(setMap.get("activityMode"));
			
			setMap.put("s_itemID", subProcessMap.get("MyItemID"));
			setMap.put("itemId", String.valueOf(subProcessMap.get("MyItemID")));
			setMap.put("sessionCurrLangType", String.valueOf(commandMap.get("sessionCurrLangType")));
			setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
			setMap.put("attrTypeCode", commandMap.get("attrTypeCode"));
			
			// Model 정보 취득 
			setMap.remove("ModelTypeCode");
			Map modelMap = new HashMap();
			String modelID = "";
			if (!"0".equals(StringUtil.checkNull(commandMap.get("modelExist")))) {
				setMap.put("MTCategory", request.getParameter("MTCategory"));
				modelMap = commonService.select("report_SQL.getModelIdAndSize", setMap);
				
				// 모델이 DB에 존재 하는 경우, 문서에 표시할 모델 맵 크기를 계산 한다
				// 모델이 DB에 존재 하는 경우, [TB_ELEMENT]에서 선행 /후행 데이터 취득
				if (null != modelMap) {
					setModelMap(modelMap, request);
					Map setMap2 = new HashMap();
					setMap2.put("languageID", languageId);
					if ("N".equals(StringUtil.checkNull(commandMap.get("onlyMap"))) && "on".equals(StringUtil.checkNull(setMap.get("occYN")))) {
						// [TB_ELEMENT]에서 선행 /후행 데이터 취득 
						detailElementList = getElementList(setMap2, modelMap);
					}
				}
			}
			
			List attrList = new ArrayList();
			String changeSetID = StringUtil.checkNull(modelMap.get("changeSetID"));
			
			/* 기본정보 취득 */
			List prcList = commonService.selectList("report_SQL.getItemInfo", setMap);
			setMap.put("changeSetID",changeSetID);
			
			if(accMode.equals("OPS")) {
				changeSetID = StringUtil.checkNull(setMap.get("ReleaseNo"));
				setMap.put("changeSetID", changeSetID);
				prcList = commonService.selectList("item_SQL.getItemAttrRevInfo", setMap);
				attrList = commonService.selectList("item_SQL.getItemRevDetailInfo", setMap);
			} else {
				attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
			}
			
			/* elementList 취득 */
			if ("N".equals(StringUtil.checkNull(commandMap.get("onlyMap"))) && "element".equals(activityMode)) { // QMS 의 경우
				// mdlIF = Y 인 symbolList
				Map setMap2 = new HashMap();
				setMap2.put("s_itemID", subProcessMap.get("MyItemID"));
				setMap2.put("itemID", String.valueOf(subProcessMap.get("MyItemID")));
				setMap2.put("languageID", languageId);
				
				Map modelMap2 = commonService.select("report_SQL.getModelIdAndSize", setMap2);
				modelID = StringUtil.checkNull(modelMap2.get("ModelID"));
				if(accMode.equals("OPS")) {
					modelID = commonService.selectString("model_SQL.getModelIDFromItem", setMap2);
				}
				
				setMap2.put("ModelID",modelID);
				setMap2.put("mdlIF", "Y");
				elementList = commonService.selectList("report_SQL.getObjListOfModel", setMap2);
			}
			
			Map csInfo = commonService.select("cs_SQL.getChangeSetInfo", setMap);
			totalMap.put("csAuthorNM",csInfo.get("AuthorName"));
			totalMap.put("csOwnerTeamNM",csInfo.get("TeamName"));
			
			//=====================================================================================================
			/* 기본정보의 속성 내용을 취득 */
			commandMap.put("ItemID", subProcessMap.get("MyItemID"));
			commandMap.put("DefaultLang", defaultLang);
			
			List activityList = new ArrayList();
			if ("N".equals(StringUtil.checkNull(commandMap.get("onlyMap")))) {
				if(!"OPS".equals(accMode)) attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
				
				Map attrMap = new HashMap();
				Map attrNameMap = new HashMap();
				Map attrHtmlMap = new HashMap();
				String mlovAttrText = "";
				for (int k = 0; attrList.size()>k ; k++ ) {
					map = (Map) attrList.get(k);
					if(!map.get("DataType").equals("MLOV")){
						attrMap.put(map.get("AttrTypeCode"), StringEscapeUtils.unescapeHtml4((String) map.get("PlainText")));	// 기본정보의 td
					} else {
						String mlovAttrCode = (String) map.get("AttrTypeCode");
						if(attrMap.get(mlovAttrCode) == null || attrMap.get(mlovAttrCode) == ""){
							mlovAttrText = map.get("PlainText").toString();
						} else {
							mlovAttrText += " / "+map.get("PlainText").toString();
						}
						attrMap.put(mlovAttrCode, mlovAttrText);	
					}
					attrNameMap.put(map.get("AttrTypeCode"), map.get("Name"));	// 기본정보의 th
					attrHtmlMap.put(map.get("AttrTypeCode"), map.get("HTML"));
				}

				// Dimension정보 취득 
				List dimInfoList = commonService.selectList("dim_SQL.selectDim_gridList", setMap);
				Map dimResultMap = new HashMap();
				String dimTypeName = "";
				String dimValueNames = "";
				
				if (dimInfoList.size() > 0) {
					for(int i = 0; i < dimInfoList.size(); i++){
						map = (HashMap)dimInfoList.get(i);
						if (i > 0) {
							if(dimTypeName.equals(map.get("DimTypeName").toString())) {
								dimValueNames += " / "+map.get("DimValueName").toString();
							} else {
								dimResultMap.put("dimValueNames", dimValueNames);
								dimResultList.add(dimResultMap);
								dimResultMap = new HashMap(); // 초기화
								dimTypeName = map.get("DimTypeName").toString();
								dimResultMap.put("dimTypeName", dimTypeName);
								dimValueNames = map.get("DimValueName").toString();
							}
						}else{
							dimTypeName = map.get("DimTypeName").toString();
							dimResultMap.put("dimTypeName", dimTypeName);
							dimValueNames = map.get("DimValueName").toString();
						}
					}
				
					dimResultMap.put("dimValueNames", dimValueNames);
					dimResultList.add(dimResultMap);
				}

				Map AttrTypeList = new HashMap();
				if ("on".equals(StringUtil.checkNull(setMap.get("cxnYN")))) {
					// 관련항목 취득 
					relItemList = commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);
					
					// 관련항목 connected processed 취득
					setMap.put("showElement", "Y");
					setMap.put("mdlIF", "Y");
					relItemConList = commonService.selectList("item_SQL.getSubItemList_gridList", setMap);
					setMap.remove("showElement");
					setMap.remove("mdlIF");
					
					// sub item 관련항목 취득 (L4일때만)
					List childItemList = commonService.selectList("item_SQL.getChildItemList_gridList", setMap);
					for(int j=0; j<childItemList.size(); j++){
						Map tmp = (Map) childItemList.get(j);
						Map tmpMap = new HashMap();
						setMap.put("s_itemID", tmp.get("ItemID"));
						tmpMap.put("TreeName",StringUtil.checkNull(tmp.get("TreeName")));
						tmpMap.put("list",commonService.selectList("item_SQL.getCxnItemList_gridList", setMap));
						relItemSubList.add(tmpMap);
					}
					setMap.put("s_itemID", subProcessMap.get("MyItemID"));
					
					List impl = new ArrayList();
					List relItemID = new ArrayList();
					
					for(int j=0; j<relItemList.size(); j++){
						map = (Map) relItemList.get(j);
						impl.add(map.get("ClassCode"));
						relItemID.add(map.get("s_itemID"));
					}
					// 중복제거
					TreeSet relItemClassCode = new TreeSet(impl);
					ArrayList relItemClassCodeList = new ArrayList(relItemClassCode);
					
					// 관련항목 이름 취득
					List relItemNameList = new ArrayList();
					for(int j=0; j<relItemClassCodeList.size(); j++){
						setMap.put("typeCode", relItemClassCodeList.get(j));
						String cnName = commonService.selectString("common_SQL.getNameFromDic", setMap);
						relItemNameList.add(cnName);
					}
					
					// 관련항목 속성 조회
					List relItemAttrbyID = new ArrayList();
					for(int j=0; j<relItemID.size(); j++){
						setMap.put("itemID", relItemID.get(j));
						List temp = commonService.selectList("report_SQL.getItemAttr", setMap);
						relItemAttrbyID.addAll(temp);
					}
//					// 용어의 정의 리스트
//					setMap.put("defaultLang", defaultLang);
//					setMap.put("ClassCode", "CL11004");
//					setMap.remove("ItemTypeCode");
//					termList = commonService.selectList("zSK_SQL.getCxnItemList_gridList", setMap);
//					setMap.remove("ClassCode");
//
//					totalMap.put("termList",termList);
					totalMap.put("relItemClassCodeList",relItemClassCodeList);
					totalMap.put("relItemNameList", relItemNameList);
					totalMap.put("relItemID", relItemID);
					totalMap.put("relItemAttrbyID", relItemAttrbyID);
				}
				List temp = commonService.selectList("attr_SQL.getItemAttrType", setMap);
				Map AttrTypeListTemp = new HashMap();

				for(int j=0; j<temp.size(); j++){
					AttrTypeListTemp = (Map) temp.get(j);
					AttrTypeList.put(AttrTypeListTemp.get("AttrTypeCode"), AttrTypeListTemp.get("DataType"));
				}
				
				totalMap.put("AttrTypeList", AttrTypeList);
				
				if ("on".equals(StringUtil.checkNull(setMap.get("subItemYN")))) {
					// Activity 정보 취득 
					setMap.put("viewType", "wordReport");
					setMap.put("gubun", "M");
					if ("Y".equals(StringUtil.checkNull(commandMap.get("element")))) {
						setMap.remove("gubun");
					}
					
					if("OPS".equals(accMode)){
						activityMap.put("accMode",accMode);
						activityMap.put("changeSetID",changeSetID);
						activityList = commonService.selectList("item_SQL.getChildItemList_gridList",setMap);
					}else {
						activityList = commonService.selectList("item_SQL.getSubItemList_gridList", setMap);
					}
					
					activityMap.put("activityMode",activityMode);
					if ("element".equals(activityMode)) { // QMS 의 경우
						setMap.put("modelTypeCode", modelMap.get("ModelTypeCode"));
						String mdlIF = StringUtil.checkNull(request.getParameter("mdlIF"));
						setMap.put("ModelID", modelMap.get("ModelID"));
						setMap.put("mdlIF", mdlIF);
						setMap.put("SymTypeCodes", "'SB00004','SB00007'");
						setMap.put("itemCategory","OJ");
						activityList = commonService.selectList("report_SQL.getObjListOfModel", setMap);
					}
					
					activityList = getActivityAttr(activityList, defaultLang ,languageId, attrNameMap, attrHtmlMap, activityMap); // 액티비티의 속성을 액티비티 리스트에 추가
	
					// Activity 속성명 모두 취득 ( ex) AT00005:수행부서, AT00006:수행주체, AT00013:사용시스템 )
					List activityNames = commonService.selectList("report_SQL.getActivityAttrName", commandMap);
					for (int k = 0; activityNames.size()>k ; k++ ) {
						map = (Map) activityNames.get(k);
						attrNameMap.put(map.get("AttrTypeCode"), map.get("Name"));
					}
					activityMap.remove("activityMode");
				}
				
				totalMap.put("attrMap", attrMap);
				totalMap.put("attrNameMap", attrNameMap);
				totalMap.put("attrHtmlMap", attrHtmlMap);
				
				// 첨부 문서 취득 
				setMap.remove("itemTypeCode");
				setMap.put("DocumentID", String.valueOf(subProcessMap.get("MyItemID")));
				if ("on".equals(StringUtil.checkNull(setMap.get("fileYN")))) {
					if("OPS".equals(accMode)) {
						setMap.remove("changeSetID");
						attachFileList = commonService.selectList("fileMgt_SQL.getFile_gridList", setMap);
						setMap.put("changeSetID",changeSetID);
					} else {
						attachFileList = commonService.selectList("fileMgt_SQL.getFile_gridList", setMap);
					}
					
				}
				
				if("OPS".equals(accMode)){
					setMap.put("asgnOption", "2,3"); //해제,신규 미출력
					setMap.put("cngStatus", "CLS"); //상태 : 완료
				} else {
					setMap.put("asgnOption", "1,2"); //해제,해제중 미출력
				}
				
				//if ("on".equals(StringUtil.checkNull(setMap.get("teamYN")))) {
					setMap.put("itemID", subProcessMap.get("MyItemID"));
					roleList = commonService.selectList("role_SQL.getItemTeamRoleList_gridList", setMap);
				//}
				
				if ("on".equals(StringUtil.checkNull(setMap.get("csYN")))) {
					cngtList = commonService.selectList("report_SQL.getItemChangeListRPT", setMap);
				}
				
				if ("on".equals(StringUtil.checkNull(setMap.get("rnrYN")))) {
					if("2".equals(StringUtil.checkNull(setMap.get("rnrOption")))) { // 엘리먼트 리스트
						String elmClassLists[] = StringUtil.checkNull(setMap.get("elmClassList")).split(",");
						String classCodes = "";
						for(int i=0; i<elmClassLists.length; i++) {
							if(i == 0){
								classCodes = "'"+elmClassLists[i]+"'";
							}else{
								classCodes = classCodes+",'"+elmClassLists[i]+"'";
							}
						}
						setMap.put("elmClassList", classCodes);
					}
					List rnrTotalList = commonService.selectList("role_SQL.getSubItemTeamRoleTreeGList", setMap);
					
					for(int j=0; j<rnrTotalList.size(); j++){
						Map rnrInfo = (Map) rnrTotalList.get(j);
						AttrTypeList.put(AttrTypeListTemp.get("AttrTypeCode"), AttrTypeListTemp.get("DataType"));
						setMap.put("itemID", rnrInfo.get("ItemID"));
						List subItemRoleList = commonService.selectList("role_SQL.getItemTeamRoleList_gridList", setMap);
						rnrInfo.put("teamInfo",subItemRoleList);
						rnrList.add(rnrInfo);
					}
				}
				
				setMap.remove("asgnOption");
				setMap.remove("cngStatus");
				
				setMap.put("refModelID", modelMap.get("ModelID"));
				elmObjList = commonService.selectList("model_SQL.getElmtsObjectList_gridList", setMap);
				elmObjList = getActivityAttr(elmObjList, defaultLang ,languageId, attrNameMap, attrHtmlMap,activityMap);
			}
			
			totalMap.put("prcList", prcList);								// 기본정보
			totalMap.put("modelMap", modelMap);				// 업무처리 절차
			totalMap.put("dimResultList", dimResultList);	// 기본정보(Dimension)
			totalMap.put("cngtList", cngtList);							// 변경이력
			totalMap.put("elementList", detailElementList);	// 선/후행 Process
			totalMap.put("relItemList", relItemList);				// 관련항목
			totalMap.put("relItemConList", relItemConList);			// 관련항목 connected process
			totalMap.put("relItemSubList", relItemSubList); 			// 관련항목 sub item
			totalMap.put("attachFileList", attachFileList);		// 첨부문서 목록
			totalMap.put("roleList", roleList);							// 관련조직 목록
			totalMap.put("activityList", activityList);				// 액티비티 목록
			totalMap.put("rnrList", rnrList);								// R&R 목록
			totalMap.put("elmObjList", elmObjList);				// 엘리먼트 OJ, MOJ 목록
			totalMap.put("elementObjList", elementList);				// 엘리먼트 목록
			totalList.add(index, totalMap);
		}
	}
	
	@RequestMapping(value="/itemStrListWithElement.do")
	public String itemStrListWithElement(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		try{
			
			Map setMap = new HashMap();
			
			// 선택된 아이템의 ItemTypeCode 취득
			setMap.put("s_itemID", request.getParameter("itemID"));
			Map iteminfoMap = commonService.select("project_SQL.getItemInfo", setMap);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
			model.put("s_itemID", request.getParameter("itemID"));
			model.put("modelItemClass", request.getParameter("modelItemClass"));
			model.put("elmChildList", request.getParameter("elmChildList"));
			model.put("elmInfoSheet", request.getParameter("elmInfoSheet"));
			model.put("elmClass", request.getParameter("elmClass"));
			model.put("ArcCode", request.getParameter("ArcCode"));
			model.put("multiple", request.getParameter("multiple"));
			
			model.put("itemTypeCode", StringUtil.checkNull(iteminfoMap.get("ItemTypeCode")));
			
		} catch(Exception e) {
			System.out.println(e.toString());
		}
		
		return nextUrl("/report/itemStrListWithElement");
	}
	
	/**
	 * Process이외 Excel 출력
	 * @param request
	 * @param commandMap
	 * @param model
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/itemStrListWithElementExcel.do")
	public String itemStrListWithElementExcel(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception{
		
		HashMap target = new HashMap();
		HashMap setMap = new HashMap();
		FileOutputStream fileOutput = null;
		XSSFWorkbook wb = new XSSFWorkbook();
		
		try{

			String itemID = "";
			String ClassCode = "";
			String modelItemClass = StringUtil.checkNull(request.getParameter("modelItemClass"));
			
			/* arcCode [TB_ARC_FILTER_DIM] 존재 체크, 존재 하면 [TB_ITEM_DIM]에 존재 하는 아이템의 정보만 report로 출력 */
			String arcCode = StringUtil.checkNull(request.getParameter("ArcCode"));
			commandMap.put("ArcCode", arcCode);
			commandMap.put("SelectMenuId", arcCode);
			commandMap.put("modelItemClass", modelItemClass);
			Map arcTreeFilterInfoMap =  commonService.select("report_SQL.getArcTreeFilterInfo", commandMap);	
			String TreeSql = StringUtil.checkNull(arcTreeFilterInfoMap.get("TreeSql"));
			commandMap.put("TreeSql", TreeSql);	
	    
			if(TreeSql != null && !"".equals(TreeSql))	{
				String outPutItems = getArcTreeIDs(commandMap);
				commandMap.put("outPutItems", outPutItems);
			}
			
			List<Map> result = commonService.selectList("report_SQL.getItemStrList_gridList", commandMap);
			List resultSub = new ArrayList();
			Map menu = getLabel(request, commonService);
			String attType = StringUtil.checkNull(commandMap.get("AttrTypeCode"));
			String attrName = StringUtil.checkNull(commandMap.get("AttrName"));
			
			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			String defaultLang = StringUtil.checkNull(commandMap.get("sessionDefLanguageId"));
			// 파일명에 이용할 Item Name 을 취득
			Map selectedItemMap = commonService.select("report_SQL.getItemInfo", commandMap);
			
			XSSFSheet sheet = wb.createSheet("process report");
			sheet.createFreezePane(3, 2); // 고정줄
			XSSFCellStyle headerStyle = setCellHeaderStyle(wb);
			XSSFCellStyle deFaultStyle = setCellContentsStyle(wb, "");
			XSSFCellStyle selStyle = setCellContentsStyle(wb, "LIGHT_BLUE");
			XSSFCellStyle elmStyle = setCellContentsStyle(wb, "LIGHT_CORNFLOWER_BLUE");
			XSSFCellStyle contentsStyle = deFaultStyle;
			
			int cellIndex = 0;
			int rowIndex = 0;
			XSSFRow row = sheet.createRow(rowIndex);
			row.setHeight((short) (512 * ((double) 8 / 10 )));
			XSSFCell cell = null;
			rowIndex++;
			
			// AttributeCode 행 설정
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			// 명칭
			cell = row.createCell(cellIndex);
			cell.setCellValue("AT00001");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			// 그외의 속성
			String[] attrNameArray = attrName.split(",");
			String[] attrTypeArray = attType.split(",");
			
			for (int i = 0; attrTypeArray.length > i ; i++) {
				cell = row.createCell(cellIndex);
				cell.setCellValue(attrTypeArray[i].replaceAll("&#39;", "").replaceAll("'",""));
				cell.setCellStyle(headerStyle);
				cellIndex++;
			}
			
			// 수정일
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			// 최종 수정자
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			// Title 행 설정
			cellIndex = 0;   // cell index 초기화
			row = sheet.createRow(rowIndex);
			row.setHeight((short) 512);
			rowIndex++;
			/* ItemID */
			cell = row.createCell(cellIndex);
			cell.setCellValue("ItemID");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			/* 경로 */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00043")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			/* ID */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00106")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			/* 항목계층 */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00016")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			/* Name */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00028")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			// 속성 header 설정
			for (int i = 0; attrNameArray.length > i ; i++) {
				cell = row.createCell(cellIndex);
				cell.setCellValue(attrNameArray[i].replaceAll("&#39;", "").replaceAll("'", ""));
				cell.setCellStyle(headerStyle);
				cellIndex++;
			}
			
			/* 수정일 */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00070")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			/* 최종 수정자 */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00105")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			String MyItemName = "";
			// Data 행 설정 
			for (int i=0; i < result.size();i++) {
				Map map = result.get(i);
				itemID = String.valueOf(map.get("MyItemID"));
				ClassCode = String.valueOf(map.get("MyClassCode"));
				
				cellIndex = 0;   // cell index 초기화
			    row = sheet.createRow(rowIndex);
			    row.setHeight((short) (512 * ((double) 8 / 10 )));
		    	MyItemName = StringUtil.checkNull(map.get("MyItemName")).replaceAll("&#10;", "").replaceAll("&amp;", "&");
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("MyItemID"))); // MPM ID
			    if(modelItemClass.equals(ClassCode)){
			    	contentsStyle = selStyle;
			    }else{
			    	contentsStyle = deFaultStyle;
			    }
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("MyPath"))); // 경로
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("Identifier"))); // ID
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("MyClassName"))); // 항목계층
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(MyItemName); // 명칭
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    
			    cell = row.createCell(cellIndex);
			    
				commandMap.put("ItemID", itemID);
				commandMap.put("DefaultLang", defaultLang);
				
				List attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
				String dataType = "";
				Map setData = new HashMap();
				List mLovList = new ArrayList();
				for (int j = 0; attrTypeArray.length > j ; j++) {
					String attrType = attrTypeArray[j].replaceAll("&#39;", "").replaceAll("'","");
					String cellValue = "";
					
					for (int k = 0; attrList.size()>k ; k++ ) {
						Map attrMap = (Map) attrList.get(k);
						dataType = StringUtil.checkNull(attrMap.get("DataType"));
						if (attrMap.get("AttrTypeCode").equals(attrType)) {
							String plainText = removeAllTag(StringUtil.checkNull(attrMap.get("PlainText")),"DbToEx");
							if(dataType.equals("MLOV")){								
								plainText = getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionDefLanguageId")), itemID, attrType);
								cellValue = plainText;
							}else{
								cellValue = plainText;
							}
						}
					}
					cell = row.createCell(cellIndex);
					cell.setCellValue(cellValue);
					cell.setCellStyle(contentsStyle);
					cell.setCellType(XSSFCell.CELL_TYPE_STRING);
					sheet.autoSizeColumn(cellIndex);
					cellIndex++;
					
				}
				
				cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("LastUpdated"))); // 수정일
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("LastUser"))); // 최종 수정자
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
				
			    rowIndex++;
			    
			    
				if(modelItemClass.equals(ClassCode)){
					setMap = new HashMap();
					setMap.put("itemID", itemID);
					resultSub = commonService.selectList("report_SQL.getElementStrInfo_gridList", setMap);
					for (int j = 0; resultSub.size() > j ; j++) {
						cellIndex = 0;
						Map resultSubMap = (Map) resultSub.get(j);
						
						row = sheet.createRow(rowIndex);
					    row.setHeight((short) (512 * ((double) 8 / 10 )));
					    MyItemName = StringUtil.checkNull(resultSubMap.get("MyItemName")).replaceAll("&#10;", "").replaceAll("&amp;", "&");
					    cell = row.createCell(cellIndex);
					    cell.setCellValue(StringUtil.checkNull(resultSubMap.get("MyItemID"))); // MPM ID
					    cell.setCellStyle(deFaultStyle);
					    sheet.autoSizeColumn(cellIndex);
					    cellIndex++;
					    cell = row.createCell(cellIndex);
					    cell.setCellValue(StringUtil.checkNull(resultSubMap.get("MyPath"))); // 경로
					    cell.setCellStyle(deFaultStyle);
					    sheet.autoSizeColumn(cellIndex);
					    cellIndex++;
					    cell = row.createCell(cellIndex);
					    cell.setCellValue(StringUtil.checkNull(resultSubMap.get("Identifier"))); // ID
					    cell.setCellStyle(deFaultStyle);
					    sheet.autoSizeColumn(cellIndex);
					    cellIndex++;
					    cell = row.createCell(cellIndex);
					    cell.setCellValue(StringUtil.checkNull(resultSubMap.get("MyClassName"))); // 항목계층
					    cell.setCellStyle(deFaultStyle);
					    sheet.autoSizeColumn(cellIndex);
					    cellIndex++;
					    cell = row.createCell(cellIndex);
					    cell.setCellValue(MyItemName); // 명칭
					    cell.setCellStyle(deFaultStyle);
					    sheet.autoSizeColumn(cellIndex);
					    cellIndex++;
					    
					    cell = row.createCell(cellIndex);
					    
						commandMap.put("ItemID", resultSubMap.get("MyItemID"));
						commandMap.put("DefaultLang", defaultLang);
						
						attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
						dataType = "";
						setData = new HashMap();
						mLovList = new ArrayList();
						for (int jj = 0; attrTypeArray.length > jj ; jj++) {
							String attrType = attrTypeArray[jj].replaceAll("&#39;", "").replaceAll("'","");
							String cellValue = "";
							
							for (int k = 0; attrList.size()>k ; k++ ) {
								Map attrMap = (Map) attrList.get(k);
								dataType = StringUtil.checkNull(attrMap.get("DataType"));
								if (attrMap.get("AttrTypeCode").equals(attrType)) {
									String plainText = removeAllTag(StringUtil.checkNull(attrMap.get("PlainText")),"DbToEx");
									if(dataType.equals("MLOV")){								
										plainText = getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionDefLanguageId")), StringUtil.checkNull(resultSubMap.get("MyItemID")), attrType);
										cellValue = plainText;
									}else{
										cellValue = plainText;
									}
								}
							}
							cell = row.createCell(cellIndex);
							cell.setCellValue(cellValue);
							cell.setCellStyle(deFaultStyle);
							cell.setCellType(XSSFCell.CELL_TYPE_STRING);
							sheet.autoSizeColumn(cellIndex);
							cellIndex++;
							
						}
						
						cell = row.createCell(cellIndex);
					    cell.setCellValue(StringUtil.checkNull(resultSubMap.get("LastUpdated"))); // 수정일
					    cell.setCellStyle(deFaultStyle);
					    sheet.autoSizeColumn(cellIndex);
					    cellIndex++;
					    cell = row.createCell(cellIndex);
					    cell.setCellValue(StringUtil.checkNull(resultSubMap.get("LastUser"))); // 최종 수정자
					    cell.setCellStyle(deFaultStyle);
					    sheet.autoSizeColumn(cellIndex);
					    cellIndex++;
						
					    rowIndex++;
					}
				}
			}
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			long date = System.currentTimeMillis();
			String itemName = StringUtil.checkNull(selectedItemMap.get("ItemName")).replace("/", "_");
			String selectedItemName1 = new String(itemName.getBytes("UTF-8"), "ISO-8859-1");
			String selectedItemName2 = new String(selectedItemName1.getBytes("8859_1"), "UTF-8");
			
			String orgFileName1 = "ITEMLIST_" + selectedItemName1 + "_" + formatter.format(date) + ".xlsx";
			String orgFileName2 = "ITEMLIST_" + selectedItemName2 + "_" + formatter.format(date) + ".xlsx";
			String downFile1 = FileUtil.FILE_EXPORT_DIR + orgFileName1;
			String downFile2 = FileUtil.FILE_EXPORT_DIR + orgFileName2;
			
			File file = new File(downFile2);			
			fileOutput =  new FileOutputStream(file);
			wb.write(fileOutput);
			
			HashMap drmInfoMap = new HashMap();
			String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
			String teamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
			String teamName = StringUtil.checkNull(commandMap.get("sessionTeamName"));
			drmInfoMap.put("userID", userID);
			drmInfoMap.put("userName", userName);
			drmInfoMap.put("teamID", teamID);
			drmInfoMap.put("teamName", teamName);
			drmInfoMap.put("orgFileName", orgFileName2);
			drmInfoMap.put("downFile", downFile2);
			// file DRM 적용
			String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
			/*
			if(useDRM.equals("FASOO")){
				DRMUtil.setDRM(drmInfoMap);
			}
			*/
			target.put(AJAX_SCRIPT, "parent.doFileDown('"+orgFileName1+"', 'excel');parent.$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			//target.put(AJAX_ALERT, " 저장중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		} finally {
			if(fileOutput != null) fileOutput.close();
			wb = null;	
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);			
	}
	
	
	/**
	 * Process이외 Excel 출력
	 * @param request
	 * @param commandMap
	 * @param model
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/subItemListWithElmInfoSheet.do")
	public String subItemListWithElmInfoSheet(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception{
		
		HashMap target = new HashMap();
		HashMap setMap = new HashMap();
		Map modelMap = new HashMap();
		FileOutputStream fileOutput = null;
		XSSFWorkbook wb = new XSSFWorkbook();
		int tempCellIndex = 0;
		int tempRowIndex = 0;
		
		try{

			String itemID = "";
			String s_itemID = "";
			String elm_itemID = "";
			String ClassCode = "";
			String modelItemClass = StringUtil.checkNull(request.getParameter("modelItemClass"));
			String elmChildList = StringUtil.checkNull(request.getParameter("elmChildList"));
			String elmInfoSheet = StringUtil.checkNull(request.getParameter("elmInfoSheet"));
			String elmClass = StringUtil.checkNull(request.getParameter("elmClass"));
			String MTCategory = StringUtil.checkNull(request.getParameter("MTCategory"));
			int tempIndex = (elmInfoSheet.equals("Y")? 2 : 1);
			ArrayList sheetNameList = new ArrayList();
			int shtTmpIdx = 0;
			String sheetTmpName = "";

			/* arcCode [TB_ARC_FILTER_DIM] 존재 체크, 존재 하면 [TB_ITEM_DIM]에 존재 하는 아이템의 정보만 report로 출력 */
			String arcCode = StringUtil.checkNull(request.getParameter("ArcCode"));
			commandMap.put("ArcCode", arcCode);
			commandMap.put("SelectMenuId", arcCode);
			commandMap.put("modelItemClass", modelItemClass);
			Map arcTreeFilterInfoMap =  commonService.select("report_SQL.getArcTreeFilterInfo", commandMap);	
			String TreeSql = StringUtil.checkNull(arcTreeFilterInfoMap.get("TreeSql"));
			commandMap.put("TreeSql", TreeSql);	
	    
			if(TreeSql != null && !"".equals(TreeSql))	{
				String outPutItems = getArcTreeIDs(commandMap);
				commandMap.put("outPutItems", outPutItems);
			}
			
			List<Map> result = commonService.selectList("report_SQL.getItemStrList_gridList", commandMap);
			List resultSub = new ArrayList();
			List elementChild = new ArrayList();
			Map menu = getLabel(request, commonService);
			String attType = StringUtil.checkNull(commandMap.get("AttrTypeCode"));
			String attrName = StringUtil.checkNull(commandMap.get("AttrName"));
			
			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			String defaultLang = StringUtil.checkNull(commandMap.get("sessionDefLanguageId"));
			// 파일명에 이용할 Item Name 을 취득
			Map selectedItemMap = commonService.select("report_SQL.getItemInfo", commandMap);
			String selectedItemName = StringUtil.checkNull(selectedItemMap.get("ItemName")).replace("/", "_");
			sheetNameList.add(selectedItemName);
			
			XSSFSheet sheet = wb.createSheet(selectedItemName);
			sheet.createFreezePane(3, 2); // 고정줄
			XSSFCellStyle headerStyle = setCellHeaderStyle(wb);
			XSSFCellStyle deFaultStyle = setCellContentsStyle(wb, "");
			XSSFCellStyle selStyle = setCellContentsStyle(wb, "LIGHT_GREEN");
			XSSFCellStyle elmStyle = setCellContentsStyle(wb, "LIGHT_CORNFLOWER_BLUE");
			XSSFCellStyle contentsStyle = deFaultStyle;
			
			int cellIndex = 0;
			int rowIndex = 0;
			XSSFRow row = sheet.createRow(rowIndex);
			row.setHeight((short) (512 * ((double) 8 / 10 )));
			XSSFCell cell = null;
			
			// AttributeCode 행 설정
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			// 명칭
			cell = row.createCell(cellIndex);
			cell.setCellValue("AT00001");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			// 그외의 속성
			String[] attrNameArray = attrName.split(",");
			String[] attrTypeArray = attType.split(",");
			
			for (int i = 0; attrTypeArray.length > i ; i++) {
				cell = row.createCell(cellIndex);
				cell.setCellValue(attrTypeArray[i].replaceAll("&#39;", "").replaceAll("'",""));
				cell.setCellStyle(headerStyle);
				cellIndex++;
			}
			
			// 수정일
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			// 최종 수정자
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			rowIndex++;
			
			// Title 행 설정
			cellIndex = 0;   // cell index 초기화
			row = sheet.createRow(rowIndex);
			row.setHeight((short) 512);
			
			/* ItemID */
			cell = row.createCell(cellIndex);
			cell.setCellValue("ItemID");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			/* 경로 */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00043")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			/* ID */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00106")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			/* 항목계층 */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00016")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			/* Name */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00028")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			// 속성 header 설정
			for (int i = 0; attrNameArray.length > i ; i++) {
				cell = row.createCell(cellIndex);
				cell.setCellValue(attrNameArray[i].replaceAll("&#39;", "").replaceAll("'", ""));
				cell.setCellStyle(headerStyle);
				cellIndex++;
			}
			
			/* 수정일 */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00070")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			/* 최종 수정자 */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00105")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			rowIndex++;
			
			String MyItemName = "";
			// Data 행 설정 
			for (int i=0; i < result.size();i++) {
				Map map = result.get(i);
				itemID = String.valueOf(map.get("MyItemID"));
				ClassCode = String.valueOf(map.get("MyClassCode"));
				
				cellIndex = 0;   // cell index 초기화
			    row = sheet.createRow(rowIndex);
			    row.setHeight((short) (512 * ((double) 8 / 10 )));
		    	MyItemName = StringUtil.checkNull(map.get("MyItemName")).replaceAll("&#10;", "").replaceAll("&amp;", "&");
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(itemID); // MPM ID
			    if(modelItemClass.equals(ClassCode)){
			    	contentsStyle = selStyle;
			    }else{
			    	contentsStyle = deFaultStyle;
			    }
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("MyPath"))); // 경로
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("Identifier"))); // ID
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("MyClassName"))); // 항목계층
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(MyItemName); // 명칭
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    
			    cell = row.createCell(cellIndex);
			    
				commandMap.put("ItemID", itemID);
				commandMap.put("DefaultLang", defaultLang);
				
				List attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
				String dataType = "";
				Map setData = new HashMap();
				List mLovList = new ArrayList();
				for (int j = 0; attrTypeArray.length > j ; j++) {
					String attrType = attrTypeArray[j].replaceAll("&#39;", "").replaceAll("'","");
					String cellValue = "";
					
					for (int k = 0; attrList.size()>k ; k++ ) {
						Map attrMap = (Map) attrList.get(k);
						dataType = StringUtil.checkNull(attrMap.get("DataType"));
						if (attrMap.get("AttrTypeCode").equals(attrType)) {
							String plainText = removeAllTag(StringUtil.checkNull(attrMap.get("PlainText")),"DbToEx");
							if(dataType.equals("MLOV")){								
								plainText = getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionDefLanguageId")), itemID, attrType);
								cellValue = plainText;
							}else{
								cellValue = plainText;
							}
						}
					}
					cell = row.createCell(cellIndex);
					cell.setCellValue(cellValue);
					cell.setCellStyle(contentsStyle);
					cell.setCellType(XSSFCell.CELL_TYPE_STRING);
					sheet.autoSizeColumn(cellIndex);
					cellIndex++;
					
				}
				
				cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("LastUpdated"))); // 수정일
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("LastUser"))); // 최종 수정자
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    rowIndex++;
			    
				if(modelItemClass.equals(ClassCode)){
					setMap = new HashMap();				
					setMap.put("MTCategory", MTCategory);
					setMap.put("ItemID", itemID);
					setMap.put("languageID", defaultLang);
					modelMap = commonService.select("model_SQL.getModelViewer", setMap);
					setMap = new HashMap();
					setMap.put("languageID", defaultLang);
					setMap.put("modelID",modelMap.get("ModelID"));
					setMap.put("cxnYN","N");
					setMap.put("classCode",elmClass);
					//resultSub = commonService.selectList("report_SQL.getElementStrInfo_gridList", setMap);	
					resultSub = commonService.selectList("model_SQL.getElementItemList_gridList", setMap);
                        
						for (int j = 0; resultSub.size() > j ; j++) {
							cellIndex = 0;
							contentsStyle = elmStyle;
							Map resultSubMap = (Map) resultSub.get(j);
						    s_itemID = StringUtil.checkNull(resultSubMap.get("ItemID"));
							
							row = sheet.createRow(rowIndex);
						    row.setHeight((short) (512 * ((double) 8 / 10 )));
						    MyItemName = StringUtil.checkNull(resultSubMap.get("ItemName")).replaceAll("&#10;", "").replaceAll("&amp;", "&");
						    cell = row.createCell(cellIndex);
						    cell.setCellValue(s_itemID); // MPM ID
						    cell.setCellStyle(contentsStyle);
						    sheet.autoSizeColumn(cellIndex);
						    cellIndex++;
						    cell = row.createCell(cellIndex);
						    cell.setCellValue(StringUtil.checkNull(resultSubMap.get("Path"))); // 경로
						    cell.setCellStyle(contentsStyle);
						    sheet.autoSizeColumn(cellIndex);
						    cellIndex++;
						    cell = row.createCell(cellIndex);
						    cell.setCellValue(StringUtil.checkNull(resultSubMap.get("Identifier"))); // ID
						    cell.setCellStyle(contentsStyle);
						    sheet.autoSizeColumn(cellIndex);
						    cellIndex++;
						    cell = row.createCell(cellIndex);
						    cell.setCellValue(StringUtil.checkNull(resultSubMap.get("ClassName"))); // 항목계층
						    cell.setCellStyle(contentsStyle);
						    sheet.autoSizeColumn(cellIndex);
						    cellIndex++;
						    cell = row.createCell(cellIndex);
						    cell.setCellValue(MyItemName); // 명칭
						    cell.setCellStyle(contentsStyle);
						    sheet.autoSizeColumn(cellIndex);
						    cellIndex++;
						    
						    
							commandMap.put("ItemID", s_itemID);
							commandMap.put("DefaultLang", defaultLang);
							
							attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
							dataType = "";
							setData = new HashMap();
							mLovList = new ArrayList();
							for (int jj = 0; attrTypeArray.length > jj ; jj++) {
								String attrType = attrTypeArray[jj].replaceAll("&#39;", "").replaceAll("'","");
								String cellValue = "";
								
								for (int k = 0; attrList.size()>k ; k++ ) {
									Map attrMap = (Map) attrList.get(k);
									dataType = StringUtil.checkNull(attrMap.get("DataType"));
									if (attrMap.get("AttrTypeCode").equals(attrType)) {
										String plainText = removeAllTag(StringUtil.checkNull(attrMap.get("PlainText")),"DbToEx");
										if(dataType.equals("MLOV")){								
											plainText = getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionDefLanguageId")), s_itemID, attrType);
											cellValue = plainText;
										}else{
											cellValue = plainText;
										}
									}
								}
								cell = row.createCell(cellIndex);
								cell = row.createCell(cellIndex);
								cell.setCellValue(cellValue);
								cell.setCellStyle(contentsStyle);
								cell.setCellType(XSSFCell.CELL_TYPE_STRING);
								sheet.autoSizeColumn(cellIndex);
								cellIndex++;
							}
							
							cell = row.createCell(cellIndex);
						    cell.setCellValue(StringUtil.checkNull(resultSubMap.get("LastUpdated"))); // 수정일
						    cell.setCellStyle(contentsStyle);
						    sheet.autoSizeColumn(cellIndex);
						    cellIndex++;
						    cell = row.createCell(cellIndex);
						    cell.setCellValue(StringUtil.checkNull(resultSubMap.get("LastUser"))); // 최종 수정자
						    cell.setCellStyle(contentsStyle);
						    sheet.autoSizeColumn(cellIndex);
						    cellIndex++;							
						    rowIndex++;

						    if(elmChildList.equals("Y")){
								setMap = new HashMap();
								setMap.put("s_itemID", s_itemID);
								setMap.put("languageID", defaultLang);
								elementChild = commonService.selectList("report_SQL.getItemStrList_gridList", setMap);
								for(int a1 = 0; a1 < tempIndex; a1++){								
									if(elmInfoSheet.equals("Y") && a1 > 0){
										rowIndex = 0;
										cellIndex = 0;
										contentsStyle = deFaultStyle;
										sheetTmpName = StringUtil.checkNull(resultSubMap.get("Identifier"))+" "+ StringUtil.checkNull(resultSubMap.get("ItemName")).replace("/", "_");
										for(int shtIdx=0; shtIdx<sheetNameList.size(); shtIdx++) {
											if(sheetNameList.get(shtIdx).equals(sheetTmpName)) {
												shtTmpIdx++;
											}
										}
										sheetNameList.add(sheetTmpName);
										
										sheet = wb.createSheet(sheetTmpName+(shtTmpIdx>0 ? "("+shtTmpIdx+")":""));
										row = sheet.createRow(rowIndex);
										
										// AttributeCode 행 설정
										cell = row.createCell(cellIndex);
										cell.setCellValue("");
										cell.setCellStyle(headerStyle);
										cellIndex++;
										cell = row.createCell(cellIndex);
										cell.setCellValue("");
										cell.setCellStyle(headerStyle);
										cellIndex++;
										cell = row.createCell(cellIndex);
										cell.setCellValue("");
										cell.setCellStyle(headerStyle);
										cellIndex++;
										cell = row.createCell(cellIndex);
										cell.setCellValue("");
										cell.setCellStyle(headerStyle);
										cellIndex++;
										// 명칭
										cell = row.createCell(cellIndex);
										cell.setCellValue("AT00001");
										cell.setCellStyle(headerStyle);
										cellIndex++;
										
										// 그외의 속성
										attrNameArray = attrName.split(",");
										attrTypeArray = attType.split(",");
										
										for (int i2 = 0; attrTypeArray.length > i2 ; i2++) {
											cell = row.createCell(cellIndex);
											cell.setCellValue(attrTypeArray[i2].replaceAll("&#39;", "").replaceAll("'",""));
											cell.setCellStyle(headerStyle);
											cellIndex++;
										}
										
										// 수정일
										cell = row.createCell(cellIndex);
										cell.setCellValue("");
										cell.setCellStyle(headerStyle);
										cellIndex++;
										// 최종 수정자
										cell = row.createCell(cellIndex);
										cell.setCellValue("");
										cell.setCellStyle(headerStyle);
										cellIndex++;
										rowIndex++;
										
										// Title 행 설정
										cellIndex = 0;   // cell index 초기화
										row = sheet.createRow(rowIndex);
										row.setHeight((short) 512);
										/* ItemID */
										cell = row.createCell(cellIndex);
										cell.setCellValue("ItemID");
										cell.setCellStyle(headerStyle);
										cellIndex++;
										/* 경로 */
										cell = row.createCell(cellIndex);
										cell.setCellValue(String.valueOf(menu.get("LN00043")));
										cell.setCellStyle(headerStyle);
										cellIndex++;
										/* ID */
										cell = row.createCell(cellIndex);
										cell.setCellValue(String.valueOf(menu.get("LN00106")));
										cell.setCellStyle(headerStyle);
										cellIndex++;
										/* 항목계층 */
										cell = row.createCell(cellIndex);
										cell.setCellValue(String.valueOf(menu.get("LN00016")));
										cell.setCellStyle(headerStyle);
										cellIndex++;
										
										/* Name */
										cell = row.createCell(cellIndex);
										cell.setCellValue(String.valueOf(menu.get("LN00028")));
										cell.setCellStyle(headerStyle);
										cellIndex++;
										
										// 속성 header 설정
										for (int i1 = 0; attrNameArray.length > i1 ; i1++) {
											cell = row.createCell(cellIndex);
											cell.setCellValue(attrNameArray[i1].replaceAll("&#39;", "").replaceAll("'", ""));
											cell.setCellStyle(headerStyle);
											cellIndex++;
										}
										
										/* 수정일 */
										cell = row.createCell(cellIndex);
										cell.setCellValue(String.valueOf(menu.get("LN00070")));
										cell.setCellStyle(headerStyle);
										cellIndex++;
										
										/* 최종 수정자 */
										cell = row.createCell(cellIndex);
										cell.setCellValue(String.valueOf(menu.get("LN00105")));
										cell.setCellStyle(headerStyle);
										cellIndex++;
										rowIndex++;
									}
									
									for (int d = 0; elementChild.size() > d ; d++) {
										cellIndex = 0;
										Map elementChildMap = (Map) elementChild.get(d);
										elm_itemID = StringUtil.checkNull(elementChildMap.get("MyItemID"));
										if(!s_itemID.equals(elm_itemID)){
											row = sheet.createRow(rowIndex);
										    row.setHeight((short) (512 * ((double) 8 / 10 )));
										    MyItemName = StringUtil.checkNull(elementChildMap.get("MyItemName")).replaceAll("&#10;", "").replaceAll("&amp;", "&");
										    cell = row.createCell(cellIndex);
										    cell.setCellValue(StringUtil.checkNull(elementChildMap.get("MyItemID"))); // MPM ID
										    cell.setCellStyle(deFaultStyle);
										    sheet.autoSizeColumn(cellIndex);
										    cellIndex++;
										    cell = row.createCell(cellIndex);
										    cell.setCellValue(StringUtil.checkNull(elementChildMap.get("MyPath"))); // 경로
										    cell.setCellStyle(deFaultStyle);
										    sheet.autoSizeColumn(cellIndex);
										    cellIndex++;
										    cell = row.createCell(cellIndex);
										    cell.setCellValue(StringUtil.checkNull(elementChildMap.get("Identifier"))); // ID
										    cell.setCellStyle(deFaultStyle);
										    sheet.autoSizeColumn(cellIndex);
										    cellIndex++;
										    cell = row.createCell(cellIndex);
										    cell.setCellValue(StringUtil.checkNull(elementChildMap.get("MyClassName"))); // 항목계층
										    cell.setCellStyle(deFaultStyle);
										    sheet.autoSizeColumn(cellIndex);
										    cellIndex++;
										    cell = row.createCell(cellIndex);
										    cell.setCellValue(MyItemName); // 명칭
										    cell.setCellStyle(deFaultStyle);
										    sheet.autoSizeColumn(cellIndex);
										    cellIndex++;
										    
										    cell = row.createCell(cellIndex);
										    
											commandMap.put("ItemID", elementChildMap.get("MyItemID"));
											commandMap.put("DefaultLang", defaultLang);
											
											attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
											dataType = "";
											setData = new HashMap();
											mLovList = new ArrayList();
											for (int jj = 0; attrTypeArray.length > jj ; jj++) {
												String attrType = attrTypeArray[jj].replaceAll("&#39;", "").replaceAll("'","");
												String cellValue = "";
												
												for (int k = 0; attrList.size()>k ; k++ ) {
													Map attrMap = (Map) attrList.get(k);
													dataType = StringUtil.checkNull(attrMap.get("DataType"));
													if (attrMap.get("AttrTypeCode").equals(attrType)) {
														String plainText = removeAllTag(StringUtil.checkNull(attrMap.get("PlainText")),"DbToEx");
														if(dataType.equals("MLOV")){								
															plainText = getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionDefLanguageId")), StringUtil.checkNull(elementChildMap.get("MyItemID")), attrType);
															cellValue = plainText;
														}else{
															cellValue = plainText;
														}
													}
												}
												cell = row.createCell(cellIndex);
												cell.setCellValue(cellValue);
												cell.setCellStyle(deFaultStyle);
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												sheet.autoSizeColumn(cellIndex);
												cellIndex++;
												
											}
											
											cell = row.createCell(cellIndex);
										    cell.setCellValue(StringUtil.checkNull(elementChildMap.get("LastUpdated"))); // 수정일
										    cell.setCellStyle(deFaultStyle);
										    sheet.autoSizeColumn(cellIndex);
										    cellIndex++;
										    cell = row.createCell(cellIndex);
										    cell.setCellValue(StringUtil.checkNull(elementChildMap.get("LastUser"))); // 최종 수정자
										    cell.setCellStyle(deFaultStyle);
										    sheet.autoSizeColumn(cellIndex);
										    cellIndex++;
										    rowIndex++;
										}
									}
									if(a1 == 0){
										tempCellIndex = cellIndex;
										tempRowIndex = rowIndex;
									}
							}
						    /*****/
						sheet = wb.getSheet(selectedItemName);
						cellIndex = tempCellIndex;
						rowIndex = tempRowIndex;
						shtTmpIdx = 0;
						}
					}
				}
			}
						
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			long date = System.currentTimeMillis();
			String itemName = StringUtil.checkNull(selectedItemMap.get("ItemName")).replace("/", "_");
			String selectedItemName1 = new String(itemName.getBytes("UTF-8"), "ISO-8859-1");
			String selectedItemName2 = new String(selectedItemName1.getBytes("8859_1"), "UTF-8");
			
			String orgFileName1 = "ITEMLIST_" + selectedItemName1 + "_" + formatter.format(date) + ".xlsx";
			String orgFileName2 = "ITEMLIST_" + selectedItemName2 + "_" + formatter.format(date) + ".xlsx";
			String downFile1 = FileUtil.FILE_EXPORT_DIR + orgFileName1;
			String downFile2 = FileUtil.FILE_EXPORT_DIR + orgFileName2;
			
			File file = new File(downFile2);			
			fileOutput =  new FileOutputStream(file);
			wb.write(fileOutput);
			
			HashMap drmInfoMap = new HashMap();
			String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
			String teamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
			String teamName = StringUtil.checkNull(commandMap.get("sessionTeamName"));
			drmInfoMap.put("userID", userID);
			drmInfoMap.put("userName", userName);
			drmInfoMap.put("teamID", teamID);
			drmInfoMap.put("teamName", teamName);
			drmInfoMap.put("orgFileName", orgFileName2);
			drmInfoMap.put("downFile", downFile2);
			
			// file DRM 적용
			String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
			String useDownDRM = StringUtil.checkNull(GlobalVal.DRM_DOWN_USE);
			if(!"".equals(useDRM) && !"N".equals(useDownDRM)){
				drmInfoMap.put("funcType", "report");
				DRMUtil.drmMgt(drmInfoMap); // 암호화 
			}
			
			target.put(AJAX_SCRIPT, "parent.doFileDown('"+orgFileName1+"', 'excel');parent.$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			//target.put(AJAX_ALERT, " 저장중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		} finally {
			if(fileOutput != null) fileOutput.close();
			wb = null;	
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);			
	}
	
	/**
	 * Process이외 Excel 출력
	 * @param request
	 * @param commandMap
	 * @param model
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/subItemListWithElmInfoMultiple.do")
	public String subItemListWithElmInfoMultiple(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception{
		HashMap target = new HashMap();
		try{
			String s_itemID = "";
			String elm_itemID = "";
			String ClassCode = "";
			String modelItemClass = StringUtil.checkNull(request.getParameter("modelItemClass"));
			
			Map selectedItemMap = commonService.select("report_SQL.getItemInfo", commandMap);
			
			List<Map> treeItemList = commonService.selectList("report_SQL.getItemStrList_gridList", commandMap);
			commandMap.remove("multiple");
			List fileList = new ArrayList();
			String fileName = "";
			for(int i=0; i<treeItemList.size(); i++){
				Map treeMap = (Map)treeItemList.get(i);				
				s_itemID = StringUtil.checkNull(treeMap.get("MyItemID"));
				
				commandMap.put("s_itemID", s_itemID);
				commandMap.put("myClassCode", treeMap.get("MyClassCode"));
				fileName = makeSubItemListWithElmInfoMultiple(request, commandMap, model);
				fileList.add(fileName);
			}
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			long date = System.currentTimeMillis();
			String itemName = StringUtil.checkNull(selectedItemMap.get("ItemName")).replace("/", "_");
			String selectedItemName1 = new String(itemName.getBytes("UTF-8"), "ISO-8859-1");
			String selectedItemName2 = new String(selectedItemName1.getBytes("8859_1"), "UTF-8");
			
			String zipFileName1 = "ITEMLIST_" + selectedItemName1 + "_"+ formatter.format(date) +".zip";
			String zipFileName2 = "ITEMLIST_" + selectedItemName2 + "_"+ formatter.format(date) +".zip";
		 
			String path = FileUtil.FILE_EXPORT_DIR;
			String fullPath = FileUtil.FILE_EXPORT_DIR + zipFileName2;
			
			File zipFile = new File(fullPath); 
			File dirFile = new File(path);
		    if(!dirFile.exists()) {
			    dirFile.mkdirs();
			} 
	
			ZipOutputStream zos = null;		     
		    try {
		    	zos = new ZipOutputStream(new FileOutputStream(zipFile));
				zos.setEncoding("euc-kr");
			 
				byte[] buffer = new byte[1024 * 2];
			    int k = 0;
				String filePath = "";
				String file = "";
				for(int i=0; i< fileList.size(); i++){	 
					file = StringUtil.checkNull(fileList.get(i));
					filePath = path + file;
					BufferedInputStream bis = null;
					try {
						bis = new BufferedInputStream(new FileInputStream (filePath));
						zos.putNextEntry(new ZipEntry(file));
					    
					    int length = 0;
				        while((length = bis.read(buffer)) != -1) {
				           zos.write(buffer, 0, length);
				        }
					} catch ( Exception e ) {
			        	System.out.println(e.toString());
			        	throw e;
			        } finally {
			        	zos.closeEntry();
				        bis.close();
			        }
				 }
		    } catch ( Exception e ) {
	        	System.out.println(e.toString());
	        	throw e;
	        } finally {
    			zos.closeEntry();
			    zos.close();
	        }
		     
		     target.put(AJAX_SCRIPT, "parent.doFileDown('"+zipFileName1+"', 'excel');parent.$('#isSubmit').remove();");
			
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); 
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);			
	}
		
	/**
	 * Process이외 Excel 출력
	 * @param request
	 * @param commandMap
	 * @param model
	 * @param response
	 * @return
	 * @throws Exception
	 */
	private String makeSubItemListWithElmInfoMultiple(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		HashMap setMap = new HashMap();
		FileOutputStream fileOutput = null;
		XSSFWorkbook wb = new XSSFWorkbook();
		int tempCellIndex = 0;
		int tempRowIndex = 0;
		String returnFile = "";
		try{
		
			String itemID = "";
			String s_itemID = "";
			String elm_itemID = "";
			String ClassCode = "";
			String modelItemClasses[] = StringUtil.checkNull(request.getParameter("modelItemClass")).split(",");
			String elmChildList = StringUtil.checkNull(request.getParameter("elmChildList"));
			String elmInfoSheet = StringUtil.checkNull(request.getParameter("elmInfoSheet"));
			String elmClass = StringUtil.checkNull(request.getParameter("elmClass"));
			int tempIndex = (elmInfoSheet.equals("Y")? 2 : 1);
			
			String selectedItemClassCode = StringUtil.checkNull(commandMap.get("myClassCode"));
			Map modelItemClassMap = new HashMap();
			String modelItemClass = "";
			if(modelItemClasses.length>0){
				for(int i=0; i< modelItemClasses.length; i++){					
					if(selectedItemClassCode.equals(StringUtil.checkNull(modelItemClasses[i]))){
						modelItemClass = StringUtil.checkNull(modelItemClasses[i]);
						commandMap.put("modelItemClass", StringUtil.checkNull(modelItemClasses[i]));	
					}
				}
			}
			
			/* arcCode [TB_ARC_FILTER_DIM] 존재 체크, 존재 하면 [TB_ITEM_DIM]에 존재 하는 아이템의 정보만 report로 출력 */
			String arcCode = StringUtil.checkNull(request.getParameter("ArcCode"));
			commandMap.put("ArcCode", arcCode);
			commandMap.put("SelectMenuId", arcCode);
			//commandMap.put("modelItemClass", modelItemClass);
			Map arcTreeFilterInfoMap =  commonService.select("report_SQL.getArcTreeFilterInfo", commandMap);	
			String TreeSql = StringUtil.checkNull(arcTreeFilterInfoMap.get("TreeSql"));
			commandMap.put("TreeSql", TreeSql);	
	    
			if(TreeSql != null && !"".equals(TreeSql))	{
				String outPutItems = getArcTreeIDs(commandMap);
				commandMap.put("outPutItems", outPutItems);
			}
			
			List<Map> result = commonService.selectList("report_SQL.getItemStrList_gridList", commandMap);
			List resultSub = new ArrayList();
			List elementChild = new ArrayList();
			Map menu = getLabel(request, commonService);
			String attType = StringUtil.checkNull(commandMap.get("AttrTypeCode"));
			String attrName = StringUtil.checkNull(commandMap.get("AttrName"));
			
			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			String defaultLang = StringUtil.checkNull(commandMap.get("sessionDefLanguageId"));
			// 파일명에 이용할 Item Name 을 취득
			Map selectedItemMap = commonService.select("report_SQL.getItemInfo", commandMap);
			String selectedItemName = StringUtil.checkNull(selectedItemMap.get("ItemName"));
			XSSFSheet sheet = wb.createSheet(selectedItemName);
			sheet.createFreezePane(3, 2); // 고정줄
			XSSFCellStyle headerStyle = setCellHeaderStyle(wb);
			XSSFCellStyle deFaultStyle = setCellContentsStyle(wb, "");
			XSSFCellStyle selStyle = setCellContentsStyle(wb, "LIGHT_GREEN");
			XSSFCellStyle elmStyle = setCellContentsStyle(wb, "LIGHT_CORNFLOWER_BLUE");
			XSSFCellStyle contentsStyle = deFaultStyle;
			
			int cellIndex = 0;
			int rowIndex = 0;
			XSSFRow row = sheet.createRow(rowIndex);
			row.setHeight((short) (512 * ((double) 8 / 10 )));
			XSSFCell cell = null;
			
			// AttributeCode 행 설정
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			// 명칭
			cell = row.createCell(cellIndex);
			cell.setCellValue("AT00001");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			// 그외의 속성
			String[] attrNameArray = attrName.split(",");
			String[] attrTypeArray = attType.split(",");
			
			for (int i = 0; attrTypeArray.length > i ; i++) {
				cell = row.createCell(cellIndex);
				cell.setCellValue(attrTypeArray[i].replaceAll("&#39;", "").replaceAll("'",""));
				cell.setCellStyle(headerStyle);
				cellIndex++;
			}
			
			// 수정일
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			// 최종 수정자
			cell = row.createCell(cellIndex);
			cell.setCellValue("");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			rowIndex++;
			
			// Title 행 설정
			cellIndex = 0;   // cell index 초기화
			row = sheet.createRow(rowIndex);
			row.setHeight((short) 512);
			
			/* ItemID */
			cell = row.createCell(cellIndex);
			cell.setCellValue("ItemID");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			/* 경로 */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00043")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			/* ID */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00106")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			/* 항목계층 */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00016")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			/* Name */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00028")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			// 속성 header 설정
			for (int i = 0; attrNameArray.length > i ; i++) {
				cell = row.createCell(cellIndex);
				cell.setCellValue(attrNameArray[i].replaceAll("&#39;", "").replaceAll("'", ""));
				cell.setCellStyle(headerStyle);
				cellIndex++;
			}
			
			/* 수정일 */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00070")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			
			/* 최종 수정자 */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00105")));
			cell.setCellStyle(headerStyle);
			cellIndex++;
			rowIndex++;
			
			String MyItemName = "";
			// Data 행 설정 
			for (int i=0; i < result.size();i++) {
				Map map = result.get(i);
				itemID = String.valueOf(map.get("MyItemID"));
				ClassCode = String.valueOf(map.get("MyClassCode"));
				
				cellIndex = 0;   // cell index 초기화
			    row = sheet.createRow(rowIndex);
			    row.setHeight((short) (512 * ((double) 8 / 10 )));
		    	MyItemName = StringUtil.checkNull(map.get("MyItemName")).replaceAll("&#10;", "").replaceAll("&amp;", "&");
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(itemID); // MPM ID
			    if(modelItemClass.equals(ClassCode)){
			    	contentsStyle = selStyle;
			    }else{
			    	contentsStyle = deFaultStyle;
			    }
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("MyPath"))); // 경로
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("Identifier"))); // ID
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("MyClassName"))); // 항목계층
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(MyItemName); // 명칭
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    
			    cell = row.createCell(cellIndex);
			    
				commandMap.put("ItemID", itemID);
				commandMap.put("DefaultLang", defaultLang);
				
				List attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
				String dataType = "";
				Map setData = new HashMap();
				List mLovList = new ArrayList();
				for (int j = 0; attrTypeArray.length > j ; j++) {
					String attrType = attrTypeArray[j].replaceAll("&#39;", "").replaceAll("'","");
					String cellValue = "";
					
					for (int k = 0; attrList.size()>k ; k++ ) {
						Map attrMap = (Map) attrList.get(k);
						dataType = StringUtil.checkNull(attrMap.get("DataType"));
						if (attrMap.get("AttrTypeCode").equals(attrType)) {
							String plainText = removeAllTag(StringUtil.checkNull(attrMap.get("PlainText")),"DbToEx");
							if(dataType.equals("MLOV")){								
								plainText = getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionDefLanguageId")), itemID, attrType);
								cellValue = plainText;
							}else{
								cellValue = plainText;
							}
						}
					}
					cell = row.createCell(cellIndex);
					cell.setCellValue(cellValue);
					cell.setCellStyle(contentsStyle);
					cell.setCellType(XSSFCell.CELL_TYPE_STRING);
					sheet.autoSizeColumn(cellIndex);
					cellIndex++;
					
				}
				
				cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("LastUpdated"))); // 수정일
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(StringUtil.checkNull(map.get("LastUser"))); // 최종 수정자
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    rowIndex++;
			    
				if(modelItemClass.equals(ClassCode)){
					setMap = new HashMap();
					setMap.put("itemID", itemID);
					setMap.put("elmClass", elmClass);
					setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
					resultSub = commonService.selectList("report_SQL.getElementStrInfo_gridList", setMap);
						for (int j = 0; resultSub.size() > j ; j++) {
							cellIndex = 0;
							contentsStyle = elmStyle;
							Map resultSubMap = (Map) resultSub.get(j);
						    s_itemID = StringUtil.checkNull(resultSubMap.get("MyItemID"));
							
							row = sheet.createRow(rowIndex);
						    row.setHeight((short) (512 * ((double) 8 / 10 )));
						    MyItemName = StringUtil.checkNull(resultSubMap.get("MyItemName")).replaceAll("&#10;", "").replaceAll("&amp;", "&");
						    cell = row.createCell(cellIndex);
						    cell.setCellValue(s_itemID); // MPM ID
						    cell.setCellStyle(contentsStyle);
						    sheet.autoSizeColumn(cellIndex);
						    cellIndex++;
						    cell = row.createCell(cellIndex);
						    cell.setCellValue(StringUtil.checkNull(resultSubMap.get("MyPath"))); // 경로
						    cell.setCellStyle(contentsStyle);
						    sheet.autoSizeColumn(cellIndex);
						    cellIndex++;
						    cell = row.createCell(cellIndex);
						    cell.setCellValue(StringUtil.checkNull(resultSubMap.get("Identifier"))); // ID
						    cell.setCellStyle(contentsStyle);
						    sheet.autoSizeColumn(cellIndex);
						    cellIndex++;
						    cell = row.createCell(cellIndex);
						    cell.setCellValue(StringUtil.checkNull(resultSubMap.get("MyClassName"))); // 항목계층
						    cell.setCellStyle(contentsStyle);
						    sheet.autoSizeColumn(cellIndex);
						    cellIndex++;
						    cell = row.createCell(cellIndex);
						    cell.setCellValue(MyItemName); // 명칭
						    cell.setCellStyle(contentsStyle);
						    sheet.autoSizeColumn(cellIndex);
						    cellIndex++;
						    
							commandMap.put("ItemID", s_itemID);
							commandMap.put("DefaultLang", defaultLang);
							
							attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
							dataType = "";
							setData = new HashMap();
							mLovList = new ArrayList();
							for (int jj = 0; attrTypeArray.length > jj ; jj++) {
								String attrType = attrTypeArray[jj].replaceAll("&#39;", "").replaceAll("'","");
								String cellValue = "";
								
								for (int k = 0; attrList.size()>k ; k++ ) {
									Map attrMap = (Map) attrList.get(k);
									dataType = StringUtil.checkNull(attrMap.get("DataType"));
									if (attrMap.get("AttrTypeCode").equals(attrType)) {
										String plainText = removeAllTag(StringUtil.checkNull(attrMap.get("PlainText")),"DbToEx");
										if(dataType.equals("MLOV")){								
											plainText = getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionDefLanguageId")), s_itemID, attrType);
											cellValue = plainText;
										}else{
											cellValue = plainText;
										}
									}
								}
								cell = row.createCell(cellIndex);
								cell = row.createCell(cellIndex);
								cell.setCellValue(cellValue);
								cell.setCellStyle(contentsStyle);
								cell.setCellType(XSSFCell.CELL_TYPE_STRING);
								sheet.autoSizeColumn(cellIndex);
								cellIndex++;
							}
							
							cell = row.createCell(cellIndex);
						    cell.setCellValue(StringUtil.checkNull(resultSubMap.get("LastUpdated"))); // 수정일
						    cell.setCellStyle(contentsStyle);
						    sheet.autoSizeColumn(cellIndex);
						    cellIndex++;
						    cell = row.createCell(cellIndex);
						    cell.setCellValue(StringUtil.checkNull(resultSubMap.get("LastUser"))); // 최종 수정자
						    cell.setCellStyle(contentsStyle);
						    sheet.autoSizeColumn(cellIndex);
						    cellIndex++;							
						    rowIndex++;
						    
						    if(elmChildList.equals("Y")){
								setMap = new HashMap();
								setMap.put("s_itemID", s_itemID);
								setMap.put("languageID", defaultLang);
								elementChild = commonService.selectList("report_SQL.getItemStrList_gridList", setMap);
								for(int a1 = 0; a1 < tempIndex; a1++){								
									if(elmInfoSheet.equals("Y") && a1 > 0){
										rowIndex = 0;
										cellIndex = 0;
										contentsStyle = deFaultStyle;
										try{
										sheet = wb.createSheet(StringUtil.checkNull(resultSubMap.get("Identifier"))+" "+ StringUtil.checkNull(resultSubMap.get("MyItemName")));
										}catch(Exception ex){ }
										row = sheet.createRow(rowIndex);
										
										// AttributeCode 행 설정
										cell = row.createCell(cellIndex);
										cell.setCellValue("");
										cell.setCellStyle(headerStyle);
										cellIndex++;
										cell = row.createCell(cellIndex);
										cell.setCellValue("");
										cell.setCellStyle(headerStyle);
										cellIndex++;
										cell = row.createCell(cellIndex);
										cell.setCellValue("");
										cell.setCellStyle(headerStyle);
										cellIndex++;
										cell = row.createCell(cellIndex);
										cell.setCellValue("");
										cell.setCellStyle(headerStyle);
										cellIndex++;
										// 명칭
										cell = row.createCell(cellIndex);
										cell.setCellValue("AT00001");
										cell.setCellStyle(headerStyle);
										cellIndex++;
										
										// 그외의 속성
										attrNameArray = attrName.split(",");
										attrTypeArray = attType.split(",");
										
										for (int i2 = 0; attrTypeArray.length > i2 ; i2++) {
											cell = row.createCell(cellIndex);
											cell.setCellValue(attrTypeArray[i2].replaceAll("&#39;", "").replaceAll("'",""));
											cell.setCellStyle(headerStyle);
											cellIndex++;
										}
										
										// 수정일
										cell = row.createCell(cellIndex);
										cell.setCellValue("");
										cell.setCellStyle(headerStyle);
										cellIndex++;
										// 최종 수정자
										cell = row.createCell(cellIndex);
										cell.setCellValue("");
										cell.setCellStyle(headerStyle);
										cellIndex++;
										rowIndex++;
										
										// Title 행 설정
										cellIndex = 0;   // cell index 초기화
										row = sheet.createRow(rowIndex);
										row.setHeight((short) 512);
										/* ItemID */
										cell = row.createCell(cellIndex);
										cell.setCellValue("ItemID");
										cell.setCellStyle(headerStyle);
										cellIndex++;
										/* 경로 */
										cell = row.createCell(cellIndex);
										cell.setCellValue(String.valueOf(menu.get("LN00043")));
										cell.setCellStyle(headerStyle);
										cellIndex++;
										/* ID */
										cell = row.createCell(cellIndex);
										cell.setCellValue(String.valueOf(menu.get("LN00106")));
										cell.setCellStyle(headerStyle);
										cellIndex++;
										/* 항목계층 */
										cell = row.createCell(cellIndex);
										cell.setCellValue(String.valueOf(menu.get("LN00016")));
										cell.setCellStyle(headerStyle);
										cellIndex++;
										
										/* Name */
										cell = row.createCell(cellIndex);
										cell.setCellValue(String.valueOf(menu.get("LN00028")));
										cell.setCellStyle(headerStyle);
										cellIndex++;
										
										// 속성 header 설정
										for (int i1 = 0; attrNameArray.length > i1 ; i1++) {
											cell = row.createCell(cellIndex);
											cell.setCellValue(attrNameArray[i1].replaceAll("&#39;", "").replaceAll("'", ""));
											cell.setCellStyle(headerStyle);
											cellIndex++;
										}
										
										/* 수정일 */
										cell = row.createCell(cellIndex);
										cell.setCellValue(String.valueOf(menu.get("LN00070")));
										cell.setCellStyle(headerStyle);
										cellIndex++;
										
										/* 최종 수정자 */
										cell = row.createCell(cellIndex);
										cell.setCellValue(String.valueOf(menu.get("LN00105")));
										cell.setCellStyle(headerStyle);
										cellIndex++;
										rowIndex++;
									}
									
									for (int d = 0; elementChild.size() > d ; d++) {
										cellIndex = 0;
										Map elementChildMap = (Map) elementChild.get(d);
										elm_itemID = StringUtil.checkNull(elementChildMap.get("MyItemID"));
										if(!s_itemID.equals(elm_itemID)){
											row = sheet.createRow(rowIndex);
										    row.setHeight((short) (512 * ((double) 8 / 10 )));
										    MyItemName = StringUtil.checkNull(elementChildMap.get("MyItemName")).replaceAll("&#10;", "").replaceAll("&amp;", "&");
										    cell = row.createCell(cellIndex);
										    cell.setCellValue(StringUtil.checkNull(elementChildMap.get("MyItemID"))); // MPM ID
										    cell.setCellStyle(deFaultStyle);
										    sheet.autoSizeColumn(cellIndex);
										    cellIndex++;
										    cell = row.createCell(cellIndex);
										    cell.setCellValue(StringUtil.checkNull(elementChildMap.get("MyPath"))); // 경로
										    cell.setCellStyle(deFaultStyle);
										    sheet.autoSizeColumn(cellIndex);
										    cellIndex++;
										    cell = row.createCell(cellIndex);
										    cell.setCellValue(StringUtil.checkNull(elementChildMap.get("Identifier"))); // ID
										    cell.setCellStyle(deFaultStyle);
										    sheet.autoSizeColumn(cellIndex);
										    cellIndex++;
										    cell = row.createCell(cellIndex);
										    cell.setCellValue(StringUtil.checkNull(elementChildMap.get("MyClassName"))); // 항목계층
										    cell.setCellStyle(deFaultStyle);
										    sheet.autoSizeColumn(cellIndex);
										    cellIndex++;
										    cell = row.createCell(cellIndex);
										    cell.setCellValue(MyItemName); // 명칭
										    cell.setCellStyle(deFaultStyle);
										    sheet.autoSizeColumn(cellIndex);
										    cellIndex++;
										    
										    cell = row.createCell(cellIndex);
										    
											commandMap.put("ItemID", elementChildMap.get("MyItemID"));
											commandMap.put("DefaultLang", defaultLang);
											
											attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
											dataType = "";
											setData = new HashMap();
											mLovList = new ArrayList();
											for (int jj = 0; attrTypeArray.length > jj ; jj++) {
												String attrType = attrTypeArray[jj].replaceAll("&#39;", "").replaceAll("'","");
												String cellValue = "";
												
												for (int k = 0; attrList.size()>k ; k++ ) {
													Map attrMap = (Map) attrList.get(k);
													dataType = StringUtil.checkNull(attrMap.get("DataType"));
													if (attrMap.get("AttrTypeCode").equals(attrType)) {
														String plainText = removeAllTag(StringUtil.checkNull(attrMap.get("PlainText")),"DbToEx");
														if(dataType.equals("MLOV")){								
															plainText = getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionDefLanguageId")), StringUtil.checkNull(elementChildMap.get("MyItemID")), attrType);
															cellValue = plainText;
														}else{
															cellValue = plainText;
														}
													}
												}
												cell = row.createCell(cellIndex);
												cell.setCellValue(cellValue);
												cell.setCellStyle(deFaultStyle);
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												sheet.autoSizeColumn(cellIndex);
												cellIndex++;
												
											}
											
											cell = row.createCell(cellIndex);
										    cell.setCellValue(StringUtil.checkNull(elementChildMap.get("LastUpdated"))); // 수정일
										    cell.setCellStyle(deFaultStyle);
										    sheet.autoSizeColumn(cellIndex);
										    cellIndex++;
										    cell = row.createCell(cellIndex);
										    cell.setCellValue(StringUtil.checkNull(elementChildMap.get("LastUser"))); // 최종 수정자
										    cell.setCellStyle(deFaultStyle);
										    sheet.autoSizeColumn(cellIndex);
										    cellIndex++;
										    rowIndex++;
										}
									}
									if(a1 == 0){
										tempCellIndex = cellIndex;
										tempRowIndex = rowIndex;
									}
							}
						    /*****/
						sheet = wb.getSheet(selectedItemName);
						cellIndex = tempCellIndex;
						rowIndex = tempRowIndex;
						}
						   
					}
				}
			}
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			long date = System.currentTimeMillis();
			String itemName = StringUtil.checkNull(selectedItemMap.get("ItemName")).replace("/", "_");
			String selectedItemName1 = new String(itemName.getBytes("UTF-8"), "ISO-8859-1");
			String selectedItemName2 = new String(selectedItemName1.getBytes("8859_1"), "UTF-8");
			
			String orgFileName1 = "ITEMLIST_" + selectedItemName1 + "_" + formatter.format(date) + ".xlsx";
			String orgFileName2 = "ITEMLIST_" + selectedItemName2 + "_" + formatter.format(date) + ".xlsx";
			returnFile = "ITEMLIST_" + itemName + "_" + formatter.format(date) + ".xlsx";
			String downFile1 = FileUtil.FILE_EXPORT_DIR + orgFileName1;
			String downFile2 = FileUtil.FILE_EXPORT_DIR + orgFileName2;
			
			File file = new File(downFile2);			
			fileOutput =  new FileOutputStream(file);
			wb.write(fileOutput);
			
			HashMap drmInfoMap = new HashMap();
			String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
			String teamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
			String teamName = StringUtil.checkNull(commandMap.get("sessionTeamName"));
			drmInfoMap.put("userID", userID);
			drmInfoMap.put("userName", userName);
			drmInfoMap.put("teamID", teamID);
			drmInfoMap.put("teamName", teamName);
			drmInfoMap.put("orgFileName", orgFileName2);
			drmInfoMap.put("downFile", downFile2);
			
			// file DRM 적용
			String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
			String useDownDRM = StringUtil.checkNull(GlobalVal.DRM_DOWN_USE);
			if(!"".equals(useDRM) && !"N".equals(useDownDRM)){
				drmInfoMap.put("funcType", "report");
				DRMUtil.drmMgt(drmInfoMap); // 암호화 
			}
		} catch (Exception e) {
			System.out.println(e);
		} finally {
			if(fileOutput != null) fileOutput.close();
			wb = null;	
		}
		return returnFile;			
	}
	
	private Map setUploadMapItemTeam(XSSFSheet sheet, String option, HashMap commandMap, BufferedWriter errorLog) throws Exception {
		Map excelMap = new HashMap();
		
		int attrTypeColNum = 1;
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
		
		for(int i = 0; i < rowCount; i ++){
			
			row = sheet.getRow(i);
			colCount   =  row.getPhysicalNumberOfCells();
			
			for(int j = 0; j < colCount; j ++) {
				cell	= row.getCell(j);
				
				// TODO:
				if (cell.getCellType() ==  HSSFCell.CELL_TYPE_NUMERIC) {
					data[i][j]	= StringUtil.checkNull(cell.getRawValue());
				} else {
					data[i][j]	= StringUtil.checkNull(cell);
				}
			}
			
			if(i > 0){
				// 데이터 입력 체크
				String msg = checkValueForTeamMapping(i, data, option, langCode, errorLog);
				if (!msg.isEmpty()) {
					excelMap.put("msg", msg);
				}
				
				// 새로운 템플렛 적용
				Map map = new HashMap();
				
				map.put("RNUM"				, i);
				map.put("TeamCode"			, data[i][0]);
				map.put("TeamName"		    , replaceSingleQuotation(data[i][1]));
				map.put("Identifier"	    , data[i][2]);
				map.put("ClassCode"	    	, data[i][3]);
				map.put("ItemName"	    	, replaceSingleQuotation(data[i][4]));	
				map.put("TeamRoleCategory"	, replaceSingleQuotation(data[i][5]));
				map.put("RoleTypeCode"		, data[i][6]);
				list.add(map);
				++valCnt;
			}
			++totalCnt;
		}
		
		excelMap.put("list", list);
		excelMap.put("validCnt", valCnt);
		excelMap.put("totalCnt", totalCnt);
		excelMap.put("attrTypeCodeCnt", attrTypeColNum);
		excelMap.put("colsName", "Identifier|ClassCode|ItemName|TeamCode|TeamName|TeamRoleCategory|RoleTypeCode");

		return excelMap;
	}
	
	private String checkValueForTeamMapping(int i, String[][] data, String option, String langCode, BufferedWriter errorLog) throws Exception {
		String msg = "";
		Map commandMap = new HashMap();
		
		/* From ItemID 필수 체크 */
		if (data[i][0].isEmpty()) {
			//msg = (i + 1) + "행의 From ItemID를 입력해 주세요.";
			msg = MessageHandler.getMessage(langCode + ".WM00107", new String[]{String.valueOf(i + 1), "From ItemID"});
			errorLog.write(msg); 
			errorLog.newLine();
			//return msg;
		}
		/* To ItemID 필수 체크 */
		if (data[i][3].isEmpty()) {
			//msg = (i + 1) + "행의 To ItemID를 입력해 주세요.";
			msg = MessageHandler.getMessage(langCode + ".WM00107", new String[]{String.valueOf(i + 1), "Team Code"});
			errorLog.write(msg); 
			errorLog.newLine();
			//return msg;
		}
	
		/* Connection Type 필수 체크 */
		if (data[i][6].isEmpty()) {
			msg = "Input Connection Type of row " + (i + 1);
			errorLog.write(msg); 
			errorLog.newLine();
			//return msg;
		}
		
		return msg;
	}
	
	private Map setUploadMapItemMember(XSSFSheet sheet, String option, HashMap commandMap, BufferedWriter errorLog) throws Exception {
		Map excelMap = new HashMap();
		
		int attrTypeColNum = 1;
		String[][] data	= null;
		List list = new ArrayList();
		int valCnt = 0;
		int totalCnt = 0;
		int idx = 1;
		
		int rowCount  =  sheet.getPhysicalNumberOfRows();
		int colCount = sheet.getRow(0).getPhysicalNumberOfCells();
		
		data = new String[rowCount][colCount];
		
		XSSFRow row     =  null;
	    XSSFCell cell    =  null;
	    
		String langCode = String.valueOf(commandMap.get("sessionCurrLangCode"));
		
		for(int i = 0; i < rowCount; i ++){
			
			row = sheet.getRow(i);
			colCount   =  row.getPhysicalNumberOfCells();
			
			for(int j = 0; j < colCount; j ++) {
				cell	= row.getCell(j);
				
				// TODO:
				if (cell.getCellType() ==  HSSFCell.CELL_TYPE_NUMERIC) {
					data[i][j]	= StringUtil.checkNull(cell.getRawValue());
				} else {
					data[i][j]	= StringUtil.checkNull(cell);
				}
			}
			
			if(i > 0){
				// 데이터 입력 체크
				String msg = checkValueForMemberMapping(i, data, option, langCode, errorLog);
				if (!msg.isEmpty()) {
					excelMap.put("msg", msg);
				}
				
				if (!data[i][0].isEmpty()) {
					Map setData = new HashMap();			
					String employeeNum = StringUtil.checkNull(data[i][0]);
					setData.put("employeeNum", employeeNum);
					String employeeCnt = commonService.selectString("user_SQL.getMemberIDFromEmpNOCNT", setData);
					
					if(Integer.parseInt(employeeCnt) == 1 ){						
						Map map = new HashMap();
						
						map.put("RNUM"				, idx);
						map.put("EmployeeNum"		, data[i][0]);
						map.put("MemberName"		, replaceSingleQuotation(data[i][1]));
						map.put("Identifier"	    , data[i][2]);
						map.put("ClassCode"	    	, data[i][3]);
						map.put("ItemName"	    	, replaceSingleQuotation(data[i][4]));	
						map.put("AssignmentType"	, data[i][5]);
						map.put("RoleType"		    , data[i][6]);
						map.put("Order"		        , data[i][7]);
						map.put("ClientID"		    , data[i][8]);
						
						list.add(map);
						++valCnt;
						++idx;
					}
				}
			}
			++totalCnt;
		}
		
		excelMap.put("list", list);
		excelMap.put("validCnt", valCnt);
		excelMap.put("totalCnt", totalCnt);
		excelMap.put("attrTypeCodeCnt", attrTypeColNum);
		excelMap.put("colsName", "Identifier|ClassCode|ItemName|EmployeeNum|MemberName|AssignmentType|RoleType|Order|ClientID");

		return excelMap;
	}
	
	private String checkValueForMemberMapping(int i, String[][] data, String option, String langCode, BufferedWriter errorLog) throws Exception {
		String msg = "";
		Map commandMap = new HashMap();
		
		/* EmployeeNum 필수 체크 */
		if (data[i][0].isEmpty()) {
			msg = MessageHandler.getMessage(langCode + ".WM00107", new String[]{String.valueOf(i + 1), "EmployeeNum"});
			errorLog.write(msg); 
			errorLog.newLine();
		}
		/* Identifier 필수 체크 */
		if (data[i][2].isEmpty()) {
			msg = MessageHandler.getMessage(langCode + ".WM00107", new String[]{String.valueOf(i + 1), "Item Code"});
			errorLog.write(msg); 
			errorLog.newLine();
		}
	
		/* Role Category 필수 체크 */
		if (data[i][5].isEmpty()) {
			msg = MessageHandler.getMessage(langCode + ".WM00107", new String[]{String.valueOf(i + 1), "Role Category"});
			errorLog.write(msg); 
			errorLog.newLine();
			//return msg;
		}
		
		/* Role TypeCode 필수 체크 */
		if (data[i][6].isEmpty()) {
			msg = MessageHandler.getMessage(langCode + ".WM00107", new String[]{String.valueOf(i + 1), "Role Type"});
			errorLog.write(msg); 
			errorLog.newLine();
		}
		
		if (!data[i][0].isEmpty()) {
			Map setData = new HashMap();			
			String employeeNum = StringUtil.checkNull(data[i][0]);
			setData.put("employeeNum", employeeNum);
			String employeeCnt = commonService.selectString("user_SQL.getMemberIDFromEmpNOCNT", setData);
			if(Integer.parseInt(employeeCnt) >1 ){
				
				msg = "Employee number : "+ employeeNum + " is duplicated.";
				errorLog.write(msg); 
				errorLog.newLine();
			}
		}
		
		return msg;
	}
	
	@RequestMapping(value="/itemMstListWLang.do")
	public String itemMstListWLang(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		try{			
			Map setMap = new HashMap();			
			setMap.put("s_itemID", request.getParameter("itemID"));
			Map iteminfoMap = commonService.select("project_SQL.getItemInfo", setMap);
			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
			model.put("s_itemID", request.getParameter("itemID"));
			model.put("ArcCode", request.getParameter("ArcCode"));
			model.put("itemTypeCode", StringUtil.checkNull(iteminfoMap.get("ItemTypeCode")));
			model.put("itemMstListWLang","Y");
			
		} catch(Exception e) {
			System.out.println(e.toString());
		}
		
		return nextUrl("/report/hierarchStrReport");
	}
	
	@RequestMapping(value="/exportMOJWLang.do")
	public String itemMultiLangWithElementList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
		return nextUrl("/report/exportMOJWLang");
	}
			
	@RequestMapping(value="/replaceHtmlTagSpclChrctrs.do")
	public String replaceHtmlTagSpclChrctrs(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		HashMap target = new HashMap();	
		try{			
			Map setMap = new HashMap();			
			List htmlPlainTextList = commonService.selectList("report_SQL.getHTMLPlainText", setMap);
			
			String plainText = "";			
			String replaceHtmlPlainText = "";
			String seq = "";
			String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			setMap.put("lastUser", userID);
			
			if(htmlPlainTextList.size()>0){
				for(int i = 0; i<htmlPlainTextList.size(); i++ ){
					Map htmlPlainTextInfo = (Map)htmlPlainTextList.get(i);
					
					seq = StringUtil.checkNull(htmlPlainTextInfo.get("Seq"));
					plainText = StringUtil.checkNull(htmlPlainTextInfo.get("PlainText"));					
					replaceHtmlPlainText = StringEscapeUtils.unescapeHtml4(plainText);
					
					//System.out.println("seq :"+seq+" , plainText :"+plainText+"==> replaceHtmlPlainText :"+replaceHtmlPlainText);
					setMap.put("seq", seq);
					setMap.put("plainText", replaceHtmlPlainText);
					commonService.update("report_SQL.updatePlainText", setMap);
				}
			}
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "this.doCallBack();");
		} catch(Exception e) {
			System.out.println(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);		
		return nextUrl(AJAXPAGE);	
	}
	
	@RequestMapping(value="/removeInvalidXMLCharacter.do")
	public String removeInvalidXMLCharacter(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		HashMap target = new HashMap();	
		try{			
			Map setMap = new HashMap();			
			commonService.update("report_SQL.updateRemoveInvalidXMLCharacter", setMap);
			

			List xmlPlainTextList = commonService.selectList("report_SQL.getInvalidXMLCharacter", setMap);
			
			String plainText = "";			
			String replaceHtmlPlainText = "";
			String seq = "";
			String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			setMap.put("lastUser", userID);
			
			if(xmlPlainTextList.size()>0){
				for(int i = 0; i<xmlPlainTextList.size(); i++ ){
					Map xmlPlainTextInfo = (Map)xmlPlainTextList.get(i);
					
					seq = StringUtil.checkNull(xmlPlainTextInfo.get("Seq"));
					plainText = StringUtil.checkNull(xmlPlainTextInfo.get("PlainText"));	
								
					replaceHtmlPlainText = plainText.replaceAll("[^\\u0009\\u000A\\u000D\\u0020-\\uD7FF\\uE000-\\uFFFD\\u10000-\\u10FFF]+", "");	
					
					//System.out.println("seq :"+seq+" , plainText :"+plainText+"==> replaceHtmlPlainText :"+replaceHtmlPlainText);
					setMap.put("seq", seq);
					setMap.put("plainText", replaceHtmlPlainText);
					commonService.update("report_SQL.updatePlainText", setMap);
				}
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "this.doCallBack();");
		} catch(Exception e) {
			System.out.println(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);		
		return nextUrl(AJAXPAGE);	
	}

	// 므로세스 모델 속성 수정 팝업
		@RequestMapping(value = "/wordReportPop.do")
		public String wordReportPop(HttpServletRequest request, HashMap cmmMap,
				ModelMap model) throws Exception {
			try {
				List returnData = new ArrayList();
				HashMap setMap = new HashMap();

				String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
				String scrnType = StringUtil.checkNull(request.getParameter("scrnType"), "");
				String url = StringUtil.checkNull(cmmMap.get("url"));

				setMap.put("s_itemID", s_itemID);
				String classCode = commonService.selectString("report_SQL.getItemClassCode", setMap);
				String l4List = getRowLankL4List(s_itemID, classCode,	String.valueOf(cmmMap.get("sessionCurrLangType")));

				model.put("s_itemID", s_itemID);
				model.put("l4List", l4List);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("scrnType", scrnType);
				model.put("url", url);
				model.put("outputType",StringUtil.checkNull(cmmMap.get("outputType")));
				
				HttpSession session = request.getSession(true);
				
				session.setAttribute("expFlag", "N");

			} catch (Exception e) {
				System.out.println(e);
				throw new ExceptionUtil(e.toString());
			}
			return nextUrl("/popup/wordReportPop");
		}

		/**
		 * 아이템의 L4 리스트(ItemId) 취득
		 * 
		 * @param commandMap
		 * @param arrayStr
		 * @throws Exception
		 */
		private String getRowLankL4List(String selectedItemId, String classCode,String languageID) throws ExceptionUtil {
			List list1 = new ArrayList();
			List list2 = new ArrayList();
			String l4ItemList = "";
			try { 
				Map map1 = new HashMap();
				Map map2 = new HashMap();
				Map setMap = new HashMap();
		
				String itemId = selectedItemId;
				String toItemId = "";
		
				if ("CL01002".equals(classCode)) {
					setMap.put("CURRENT_ITEM", itemId); // 해당 아이템이 [FromItemID]인것
					setMap.put("CategoryCode", "ST1");
					setMap.put("languageID", languageID);
					setMap.put("toItemClassCode", "CL01004");
					list1 = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
				} else if ("CL01004".equals(classCode)) {
					setMap.put("languageID", languageID);
					setMap.put("s_itemID", itemId);
					list1 = commonService.selectList("report_SQL.itemStDetailInfo", setMap);
					map1 = (Map) list1.get(0);
					map1.put("ToItemID", itemId);
					map1.put("toItemIdentifier", map1.get("Identifier"));
					map1.put("toItemName", map1.get("ItemName"));
					list1 = new ArrayList();
					list1.add(map1);
				}
		
				for (int k = 0; list1.size() > k; k++) {
					map1 = (Map) list1.get(k);
					setMap.put("CURRENT_ITEM", map1.get("ToItemID")); // 해당 아이템이
																		// [FromItemID]인것
					setMap.put("toItemClassCode", "CL01005");
					list2 = commonService.selectList("report_SQL.getChildItemsForWord",
							setMap);
		
					for (int m = 0; list2.size() > m; m++) {
						map2 = (Map) list2.get(m);
						if (l4ItemList.isEmpty()) {
							l4ItemList = StringUtil.checkNull(map2.get("ToItemID"));
						} else {
							l4ItemList = l4ItemList + ","
									+ StringUtil.checkNull(map2.get("ToItemID"));
						}
					}
		
				}
	        } catch(Exception e) {
	        	throw new ExceptionUtil(e.toString());
	        }

			return l4ItemList;
		}
		

		
		@RequestMapping(value="/updateItemBlocked.do")
		 public String updateItemBlocked(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		 HashMap target = new HashMap();
		 try{
				 Map setMap = new HashMap(); // For Item Blocked Update 
				 Map modelMap = new HashMap(); // For Model Blocked Update 
				 Map delMap = new HashMap(); // For Delete ItemAttrRev
				 
				// item blocked update
				 String s_itemID = StringUtil.checkNull(commandMap.get("itemID"));
				 setMap.put("s_itemID", s_itemID);
				 String itemStatus = StringUtil.checkNull(commonService.selectString("project_SQL.getItemStatus", setMap));
				 String changeSetID = StringUtil.checkNull( commonService.selectString("item_SQL.getItemCurChangeSet", setMap)); 
				 String projectID = StringUtil.checkNull( commonService.selectString("item_SQL.getProjectIDFromItem", setMap)); 
				 String blocked = StringUtil.checkNull( commonService.selectString("item_SQL.getItemBlocked", setMap)); 
				 String releaseNo = StringUtil.checkNull( commonService.selectString("item_SQL.getItemReleaseNo", setMap));
		
				 setMap.put("changeSetID", changeSetID);
				 
				 if("REL".equals(itemStatus) && "0".equals(blocked)) {
				 	 setMap.put("Blocked", "2");
				 	 modelMap.put("Blocked", "1");
				 	 
				 	 // status = REL / blocked = 0->2 일 때, ItemAttrRev delete & insert
				 	 delMap.put("changeSetID", releaseNo);
				 	 commonService.update("attr_SQL.delItemAttrRevDataByCSID", delMap);
				 	 CSActionController.insertItemAttrRev(commandMap, s_itemID, projectID, changeSetID);
				 }
				 else if("REL".equals(itemStatus) && !"0".equals(blocked)) {
					 setMap.put("Blocked", "0");
					 modelMap.put("Blocked", "0");
				 }
				 else if(!"REL".equals(itemStatus) && "0".equals(blocked)) {
					 setMap.put("Blocked", "2");
					 modelMap.put("Blocked", "1");
				 }
				 else {
					 setMap.put("Blocked", "0");
					 modelMap.put("Blocked", "0");
				 }
				
			 	setMap.put("ItemID",s_itemID);
			 	commonService.update("item_SQL.updateItemObjectInfo", setMap);
			 	
			 	// model blocked update
			 	modelMap.put("ItemID", s_itemID);
			 	modelMap.put("MTCategory", "BAS");
			 	commonService.update("model_SQL.updateModelBlockedOfItem", modelMap);
			 	modelMap.put("MTCategory", "TOBE");
			 	commonService.update("model_SQL.updateModelBlockedOfItem", modelMap);
	
			 	target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00171")); 
			 	target.put(AJAX_SCRIPT, "this.doCallBack();");
			 } catch(Exception e) {
				 System.out.println(e.toString());
			 }
		 
			 model.addAttribute(AJAX_RESULTMAP, target);
			 return nextUrl(AJAXPAGE);
		 }
		
		@RequestMapping(value="/procDesignStatistics.do")
		public String procDesignStatistics(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception {
			Map setMap = new HashMap();
			try {
				List procDesignStatisticsList = new ArrayList();
				
				List subListOfValueCodeList = new ArrayList();			
				String rootItemID = StringUtil.checkNull(request.getParameter("rootItemID"));	
				String rootClassCode = StringUtil.checkNull(request.getParameter("rootClassCode"));	
				String TypeCode = StringUtil.checkNull(request.getParameter("TypeCode"),"AT00026");	
					
				String selectedDimClass = StringUtil.checkNull(request.getParameter("selectedDimClass"));	
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
				
				String filepath = request.getSession().getServletContext().getRealPath("/");
				String xmlFilName = "upload/procDesignStatistics.xml";

				setMap.put("LanguageID", languageID);
				setMap.put("TypeCode", TypeCode);
				subListOfValueCodeList = (List) commonService.selectList("config_SQL.getSubListOfValueCode_gridList", setMap);
				
				String lovQuery = "";
				Map subListOfValueCode;
				for(int i=0; i<subListOfValueCodeList.size(); i++) {
					subListOfValueCode = (HashMap) subListOfValueCodeList.get(i);
					lovQuery += "ISNULL(SUM(CASE WHEN TIA.LovCode = '"+subListOfValueCode.get("LovCode")+"' then 1 else 0 END ), 0) AS Lov"+(i+1)+","; 
				}
				
				/* Get RootItem Data */ 
				setMap.put("rootItemID", rootItemID);
				setMap.put("languageID", languageID);
				setMap.put("lovQuery", lovQuery);
				procDesignStatisticsList = (List) commonService.selectList("report_SQL.getprocDesignStatistics", setMap);
				
				
				File oldFile = new File(filepath + xmlFilName);
				if (oldFile.exists()) {
					oldFile.delete();
				}
				
				DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance(); 
				DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
				
				// 루트 엘리먼트 
				Document doc = docBuilder.newDocument(); 
				Element rootElement = doc.createElement("rows"); 
				doc.appendChild(rootElement); 								
				
				Element row, cell;
				Map procDesignStatistics;
				for (int i = 0; i < procDesignStatisticsList.size(); i++) {
					procDesignStatistics = (HashMap) procDesignStatisticsList.get(i);
					
					row = doc.createElement("row"); 
					rootElement.appendChild(row); 
					
					cell = doc.createElement("cell"); 
					cell.appendChild(doc.createTextNode(StringUtil.checkNull(procDesignStatistics.get("Name"))));
					row.appendChild(cell);
					
					for(int k=0; k<subListOfValueCodeList.size(); k++) {
						cell = doc.createElement("cell"); 
						cell.appendChild(doc.createTextNode(StringUtil.checkNull(procDesignStatistics.get("Lov"+(k+1)))));
						row.appendChild(cell);
					}
					
					cell = doc.createElement("cell"); 
					cell.appendChild(doc.createTextNode(StringUtil.checkNull(procDesignStatistics.get("total"))));
					row.appendChild(cell);
					
				}
				
				TransformerFactory transformerFactory = TransformerFactory.newInstance(); 
				Transformer transformer = transformerFactory.newTransformer(); 
				
				transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8"); 
				transformer.setOutputProperty(OutputKeys.INDENT, "yes");        
				DOMSource source = new DOMSource(doc); 
				
				StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + xmlFilName))); 
				transformer.transform(source, result); 
				
				String subListOfValueNM = "";
				String dWidth = "";
				String dAlign = "";
				String dType = "";
				String dSort = "";			
				String classCode = "";
				
				for(int i=0;i<subListOfValueCodeList.size();i++) {
					Map temp = (Map)subListOfValueCodeList.get(i);
					subListOfValueNM += StringUtil.checkNull(temp.get("NAME"))+ ",";
					dWidth += "80,";
					dAlign += "center,";
					dType += "ro,";
					dSort += "str,";
					
				}
				subListOfValueNM += "TOTAL";
				dWidth += "80";
				dAlign += "center";
				dType += "ro";
				dSort += "str";
				
				model.put("xmlFilName", xmlFilName);
				model.put("rootItemID", rootItemID);
				model.put("TypeCode", TypeCode);
				model.put("subListOfValueNM", subListOfValueNM);
				model.put("dWidth", dWidth);
				model.put("dAlign", dAlign);
				model.put("dType", dType);
				model.put("dSort", dSort);
				model.put("rootClassCode", rootClassCode);
				model.put("selectedDimClass", selectedDimClass);
				

				model.put("menu", getLabel(request, commonService));	/*Label Setting*/
				
				
				setMap.put("reportCode",StringUtil.checkNull(request.getParameter("reportCode"), ""));
				model.put("reportCode", StringUtil.checkNull(request.getParameter("reportCode"), ""));
				model.put("title", commonService.selectString("report_SQL.getReportName", setMap));
			} catch (Exception e) {
				System.out.println(e.toString());
			}

			return nextUrl("/report/procDesignStatistics");
		}
		
		@RequestMapping(value = "/mbrAgentList.do")
		public String mbrAgentList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
			try {
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/
				String roleCategory = StringUtil.checkNull(request.getParameter("roleCategory"));
				Map setMap = new HashMap();
				setMap.put("languageID",StringUtil.checkNull(commandMap.get("languageID")));
				setMap.put("roleCategory",roleCategory);
				model.put("roleCategory",roleCategory);
				
				List list = commonService.selectList("user_SQL.getMbrAgentList", setMap);
				JSONArray gridData = new JSONArray(list);
				model.put("gridData",gridData);
				
			} catch (Exception e) {
				System.out.println(e.toString());
			}
			return nextUrl("/report/mbrAgentList");
		}
		
		@RequestMapping(value="/restoreItem.do")
		public String restoreItem(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
			HashMap target = new HashMap();
			try{
				Map setMap = new HashMap();
				String s_itemID = StringUtil.checkNull(commandMap.get("s_itemID"));
				setMap.put("s_itemID", s_itemID);
				String changeSetCount = StringUtil.checkNull(commonService.selectString("cs_SQL.getCountChangeSet", setMap));
				String changeSetID = StringUtil.checkNull( commonService.selectString("item_SQL.getItemCurChangeSet", setMap)); 
				String releaseNo = StringUtil.checkNull( commonService.selectString("item_SQL.getItemReleaseNo", setMap));
				
				setMap.put("changeSetID", changeSetID);
				Map csInfo = commonService.select("cs_SQL.getChangeSetInfo", setMap);
				
				System.out.println("changeSetCount :"+changeSetCount);
				if(changeSetCount.equals("0")) { // TCS.Status = MOD,CMP, ChangeType != New --> 0이면 원복 안됨
					target.put(AJAX_SCRIPT, "doCallBack();");
					target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00051"));	
					
					model.addAttribute(AJAX_RESULTMAP, target);
					return nextUrl(AJAXPAGE);
				}
				 
				// 첨부파일 삭제 
				setMap.put("changeSetID", changeSetID);		
				List fileList = commonService.selectList("fileMgt_SQL.getFullFileNameList", setMap);
				if(fileList.size()>0) {
					for(int i=0; i<fileList.size(); i++) {
						Map fileMap = (Map)fileList.get(i);
						String file = StringUtil.checkNull(fileMap.get("FullFileName"));
						
						File existFile = new File(file); 
						if(existFile.isFile() && existFile.exists()){existFile.delete();}
					}
					
					commonService.delete("fileMgt_SQL.deleteFile", setMap);
				}
				 
				//본문 내용 이전 버전 내용으로 원복
				setMap.put("changeSetID", releaseNo);
				setMap.put("languageID",StringUtil.checkNull(commandMap.get("languageID")));
				commonService.update("item_SQL.updateItemAttrFromRev", setMap);
				 
				// Revision 백업 정보 삭제
				setMap.put("changeSetID", changeSetID);
				commonService.delete("item_SQL.deleteAttrRev", setMap);
				 				 				 
				// ChangeSet 정보 삭제
				setMap.put("ChangeSetID", changeSetID);
				if(!changeSetID.equals(releaseNo)) {
					commonService.delete("cs_SQL.delChangeSetInfo", setMap);
					
					// Revision 삭제 
					setMap.put("changeSetID", changeSetID);
					commonService.delete("item_SQL.deleteRevision", setMap);
				}else {
					setMap.put("s_itemID", changeSetID);
					setMap.put("csStatus", "CLS");	
					setMap.put("completionDT","Y");
					commonService.update("cs_SQL.updateChangeSetClose", setMap);
				}
				 
				// Revision No 및 상태 변경
				setMap = new HashMap();
				setMap.put("changeSetID", changeSetID);
				setMap.put("releaseNo", releaseNo);
				if(releaseNo.equals("0")) {
					setMap.put("deleted", "0");
				}else {
					setMap.put("status", "REL");
					setMap.put("blocked", "2");
				}
				setMap.put("userID", StringUtil.checkNull(commandMap.get("sessionUserId")));				
				commonService.update("item_SQL.updateItemFromCS", setMap);
				 
				//Element,Model삭제, update releaseNo model.Category = BAS
				if(!changeSetID.equals(releaseNo)) {
					setMap.put("changeSetID", changeSetID);
					commonService.delete("model_SQL.deleteModelFromChangeSet", setMap);
				}
				
				String csStatus = StringUtil.checkNull(csInfo.get("Status"));
				if(csStatus.equals("APRV")) {
					String wfInstanceID = StringUtil.checkNull(csInfo.get("WfInstanceID"));
					//System.out.println("wfInstanceID :"+wfInstanceID+", csStatus:"+csStatus);
					setMap.put("wfInstanceID", wfInstanceID);
					commonService.delete("wf_SQL.deleteWFStepInst", setMap);
					commonService.delete("wf_SQL.deleteWFInstTxt", setMap);
					commonService.delete("wf_SQL.deleteWFInst", setMap);
				}
	
			 	target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00171")); 
			 	target.put(AJAX_SCRIPT, "this.doCallBack();");
			 } catch(Exception e) {
				 System.out.println(e.toString());
			 }
			 model.addAttribute(AJAX_RESULTMAP, target);
			 return nextUrl(AJAXPAGE);
		}
		
		@RequestMapping(value="/sysProcIFList.do")
		public String sysProcIFList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
			try{
				// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
				String defaultLang = commonService.selectString("item_SQL.getDefaultLang", commandMap);
				
				commandMap.put("reportCode",StringUtil.checkNull(request.getParameter("rptType")));
				String reportName = commonService.selectString("report_SQL.getReportName", commandMap);
				model.put("reportName", reportName);
				
				commandMap.put("defaultLang", defaultLang);				
				List list = commonService.selectList("report_SQL.getSysProcIFList", commandMap);
				JSONArray gridData = new JSONArray(list);
				model.put("gridData", gridData);
				
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
				
			} catch(Exception e) {
				System.out.println(e.toString());
			}
			
			return nextUrl("/report/sysProcIFList");
		}
		
		 
}
