package xbolt.app.sap;

import java.awt.Color;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.text.StringEscapeUtils;
import org.apache.poi.hssf.util.CellRangeAddress;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.nets.sso.agent.AuthUtil;
import com.nets.sso.agent.authcheck.AuthCheck;
import com.nets.sso.common.AgentExceptionCode;
import com.nets.sso.common.Utility;
import com.nets.sso.common.enums.AuthStatus;
import com.org.json.JSONArray;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.DRMUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.FormatUtil;
import xbolt.cmm.framework.util.SessionConfig;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.rpt.web.ReportActionController;

/**
 * @Class Name : SAPActionController.java
 * @Description : SAPActionController.java
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2024. 03. 29. smartfactory		최초생성
 *
 * @since 2024. 03. 29
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class SAPActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	private ReportActionController RAC;

	

	@RequestMapping(value="/zSAP_TSInfoZip.do")
	public String excelReportTSInfo(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception{
		HashMap target = new HashMap();
		FileOutputStream fileOutput = null;
		XSSFWorkbook wb = new XSSFWorkbook();
		try{
			Map setMap = new HashMap();
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"), "");
			String modelItemClass = StringUtil.checkNull(commandMap.get("modelItemClass"));
			String elmClass = StringUtil.checkNull(commandMap.get("elmClass"));
			String elmChildList = StringUtil.checkNull(commandMap.get("elmChildList"));
			String elmInfoSheet = StringUtil.checkNull(commandMap.get("elmInfoSheet"));
			ArrayList sheetNameList = new ArrayList();
			int shtTmpIdx = 0;
			String sheetTmpName = "";
			String s_itemID = StringUtil.checkNull(request.getParameter("itemID"));
			setMap.put("languageID", languageID);
			setMap.put("s_itemID", s_itemID);
			commandMap.put("ItemID", s_itemID);
			// 선택한 아이템 정보
			Map selectedItemMap = commonService.select("sap_SQL.zSAP_getItemInfo", setMap);
			
			// 선택한 아이템 속성 정보
			List attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
			Map attrValueMap = new HashMap();
			for(int j=0; j<attrList.size(); j++){
				Map attrListMap = (Map) attrList.get(j);
				attrValueMap.put(attrListMap.get("AttrTypeCode"), StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(attrListMap.get("PlainText"),"")));
			}
			
			// AttrTypeCode + Name
			List temp = commonService.selectList("attr_SQL.getItemAttrType", setMap);
			
			Map attrTypeNameInfoMap = new HashMap();
			for(int j=0; j<temp.size(); j++){
				Map Temp = (Map) temp.get(j);
				attrTypeNameInfoMap.put(Temp.get("AttrTypeCode"), Temp.get("DataType"));
			}
			
			String zipFileName = StringUtil.checkNull(selectedItemMap.get("Identifier" )) + StringUtil.checkNull(selectedItemMap.get("ItemName" )) + ".zip"; // excel_files.zip";
			zipFileName = URLEncoder.encode(zipFileName, StandardCharsets.UTF_8.toString());
			zipFileName = zipFileName.replace("+", "%20"); // 공백을 %20으로 대체
			zipFileName = zipFileName.replaceAll("[\\\\/:*?\"<>|]", "_");
			
			byte[] buffer = new byte[1024];
	        FileOutputStream fos = new FileOutputStream( FileUtil.FILE_EXPORT_DIR + zipFileName);
	        ZipOutputStream zos = new ZipOutputStream(fos);
			
	        StringBuilder itemIDs = new StringBuilder();
			
			if(StringUtil.checkNull(selectedItemMap.get("ClassCode")).equals("CL01001") || StringUtil.checkNull(selectedItemMap.get("ClassCode")).equals("CL01002")  ) {
				setMap.put("s_itemID", s_itemID);
				setMap.put("categoryCode", "ST1");
				setMap.put("itemClassCode", "CL01004");
				List subItemIDList = commonService.selectList("item_SQL.getSubItemIDList", setMap);
				if(subItemIDList.size()>0) {
					for(int i=0; i<subItemIDList.size(); i++) {
						Map subItemIDMap = (Map)subItemIDList.get(i);
						 if (itemIDs.length() != 0) {
				                itemIDs.append(",");
				         }
				         itemIDs.append(subItemIDMap.get("ItemID"));
					}
					
					setMap.put("itemIDs", itemIDs.toString());
				}
			}else {
				setMap.put("itemIDs", s_itemID);
			}
			
			setMap.put("itemID", s_itemID);
			setMap.put("elmClass", elmClass);
			List resultSub = commonService.selectList("sap_SQL.zSAP_getElementStrInfo_gridList", setMap);
			sheetNameList.add(StringUtil.checkNull(selectedItemMap.get("Identifier")));
			
			
			///////////////////////////////////////// Create Elemnet info Sheet Start  //////////////////////////////////////////
			//if(elmInfoSheet.equals("Y")){			
				for(int i=0; i<resultSub.size(); i++){
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					//////////////////////////////////외부-> elmInfoSheet 내부로 이동////////////////////////////////////////////////////////
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					wb = new XSSFWorkbook();
					XSSFSheet sheet = wb.createSheet(StringUtil.checkNull(selectedItemMap.get("Identifier")));
					XSSFCellStyle titleStyle = setCellTitleSyle(wb);
					XSSFCellStyle headerStyle = setCellHeaderStyle(wb);
					XSSFCellStyle headerStyle2 = setCellHeaderStyle2(wb);
					XSSFCellStyle contentsLeftStyle = setCellContentsStyleLeft(wb);
					XSSFCellStyle contentsCenterStyle = setCellContentsStyleCenter(wb);
					XSSFCellStyle underLine = setCellUnderline(wb);
					
					String elmInfoOnly = StringUtil.checkNull(commandMap.get("elmInfoOnly"));

					//눈금선 없애기
					sheet.setDisplayGridlines(false);
					
					int cellIndex = 1;
					int rowIndex = 1;
					XSSFRow row = sheet.createRow(rowIndex);
					XSSFCell cell = null;
					
					//sheet.setDefaultColumnWidth(3500);
					sheet.setColumnWidth((short)0,(short)300);

					row = sheet.createRow(0);
					row.setHeight((short) 200);
					
					row = sheet.createRow(rowIndex++);
					row.setHeight((short) 550);
					cell = row.createCell(cellIndex);
					//sheet.addMergedRegion(new CellRangeAddress(1,1,1,9));
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("ID");
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("클래스");
					
					sheet.addMergedRegion(new CellRangeAddress(1,1,3,4));
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("명칭");
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);

					sheet.addMergedRegion(new CellRangeAddress(1,1,5,6));
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Scenario Objective");
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
					
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Check Point");
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("동원F&B");
					//cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("디어푸드");
					//cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("YJP");
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Owner(PI)");
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Owner(Con)");
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Owner(IT)");
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Corperation");
					
					cellIndex = 1;
					row = sheet.createRow(rowIndex++);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(selectedItemMap.get("Identifier")));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(selectedItemMap.get("ClassName")));

					sheet.addMergedRegion(new CellRangeAddress(2,2,3,4));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(selectedItemMap.get("ItemName")));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);

					sheet.addMergedRegion(new CellRangeAddress(2,2,5,6));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(selectedItemMap.get("Description"))));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(attrValueMap.get("AT00029")));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(selectedItemMap.get("C101")));
					//cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(selectedItemMap.get("C102")));
					//cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(selectedItemMap.get("dimYJP")));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(attrValueMap.get("AT00022")));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(attrValueMap.get("AT00025")));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(attrValueMap.get("AT00024")));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(selectedItemMap.get("DimValueIDs"))));
					rowIndex++;
					//
					cellIndex = 1;
					row = sheet.createRow(rowIndex++);
					cell = row.createCell(cellIndex++);
					XSSFFont font= wb.createFont();
					font.setUnderline(XSSFFont.U_SINGLE);
					cell.setCellValue("Test Varint");
					
					//	
					cellIndex = 1;
					row = sheet.createRow(rowIndex++);
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("No");
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Variant");
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Value");
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Remark");

					for(int i3=0; i3<10; i3++) {
						cellIndex = 1;
						row = sheet.createRow(rowIndex++);
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
					}
					rowIndex++;
					//
					cellIndex = 1;
					row = sheet.createRow(rowIndex++);
					//sheet.addMergedRegion(new CellRangeAddress(7,7,1,9));
					cell = row.createCell(cellIndex++);
					font= wb.createFont();
					font.setUnderline(XSSFFont.U_SINGLE);
					cell.setCellValue("Process List");
					//
					cellIndex = 1;
					row = sheet.createRow(rowIndex++);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("No");
					
					sheet.addMergedRegion(new CellRangeAddress(18,18,2,3));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Process ID");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("클래스");
					
					sheet.addMergedRegion(new CellRangeAddress(18,18,5,6));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Process 명");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(18,18,7,9));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("개요");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Owner(PI)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Owner(Con)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Owner(IT)");
					
					//
					int j = 19;
					for(int i2=0; i2<resultSub.size(); i2++){
						cellIndex = 1;
						Map resultSubMap = (Map) resultSub.get(i2);
						
						String MyItemID = StringUtil.checkNull(resultSubMap.get("MyItemID"));
						commandMap.put("ItemID", MyItemID);
						List subItemAttrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
						Map subAttrInfoMap = new HashMap();
						for(int ii=0; ii<subItemAttrList.size(); ii++){
							Map subItemAttrListMap = (Map) subItemAttrList.get(ii);
							subAttrInfoMap.put(subItemAttrListMap.get("AttrTypeCode"), StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(subItemAttrListMap.get("PlainText"),"")));
						}
						
						row = sheet.createRow(rowIndex);
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsCenterStyle); cell.setCellValue(StringUtil.checkNull(resultSubMap.get("RNUM")));
						sheet.addMergedRegion(new CellRangeAddress(j,j,2,3));
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsCenterStyle); cell.setCellValue(StringUtil.checkNull(resultSubMap.get("Identifier")));
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsCenterStyle);

						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsCenterStyle); cell.setCellValue(StringUtil.checkNull(resultSubMap.get("MyClassName")));
						
						sheet.addMergedRegion(new CellRangeAddress(j,j,5,6));
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsCenterStyle); cell.setCellValue(StringUtil.checkNull(resultSubMap.get("MyItemName")));
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsCenterStyle);				
						sheet.addMergedRegion(new CellRangeAddress(j,j,7,9));
						//개요
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(removeAllTag(StringUtil.checkNull(subAttrInfoMap.get("AT00003")),"DbToEx"));
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
						
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(resultSubMap.get("OwnerPI")));
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(resultSubMap.get("OwnerCON")));
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(resultSubMap.get("OwnerIT")));
						rowIndex++;
						j++;
						
					}
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					//////////////////////////////////외부-> elmInfoSheet 내부로 이동/////////////////////////////////////////////////////////
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					
					rowIndex = 1;
					Map resultSubMap = (Map) resultSub.get(i);
					
					setMap = new HashMap();
					setMap.put("s_itemID", StringUtil.checkNull(resultSubMap.get("MyItemID")));
					setMap.put("languageID", languageID);
					
					List subItemAttrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
					Map subAttrInfoMap = new HashMap();
					for(int ii=0; ii<subItemAttrList.size(); ii++){
						Map subItemAttrListMap = (Map) subItemAttrList.get(ii);
						subAttrInfoMap.put(subItemAttrListMap.get("AttrTypeCode"), StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(subItemAttrListMap.get("PlainText"),"")));
					}
					
					Map subItemInfo = commonService.select("report_SQL.getItemInfo", setMap);
					try{
						sheetTmpName = StringUtil.checkNull(resultSubMap.get("Identifier"))+"_"+StringUtil.checkNull(resultSubMap.get("MyItemName")).replace("/", "_");
						for(int shtIdx=0; shtIdx<sheetNameList.size(); shtIdx++) {
							if(sheetNameList.get(shtIdx).equals(sheetTmpName)) {
								shtTmpIdx++;
							}
						}
						sheetNameList.add(sheetTmpName);
						
						sheet = wb.createSheet(sheetTmpName+(shtTmpIdx>0 ? "("+shtTmpIdx+")":""));
						sheet.setDisplayGridlines(false);
					}catch(Exception ex){}
					
					sheet.setColumnWidth((short)0,(short)500);
					row = sheet.createRow(0);
					row.setHeight((short) 200);
					
					row = sheet.createRow(rowIndex);
					row.setHeight((short) 550);
					
					cellIndex = 1;
					row = sheet.createRow(rowIndex);
					sheet.addMergedRegion(new CellRangeAddress(1,1,1,2));
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Test Case 기준");
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(1,1,3,11));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					rowIndex++;
					
					cellIndex = 1;
					row = sheet.createRow(rowIndex);
					sheet.addMergedRegion(new CellRangeAddress(2,2,1,2));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Test Case Data");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(2,2,3,11));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					rowIndex++;
					
					// Sheet Sub Item 4
					cellIndex = 1;
					row = sheet.createRow(rowIndex);
					rowIndex++;
					
					row = sheet.createRow(rowIndex++);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle); 	cell.setCellValue("경로");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("ID");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle); 	cell.setCellValue("클래스");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("명칭");
					
					sheet.addMergedRegion(new CellRangeAddress(4,4,5,7));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("개요");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Owner(PI)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Owner(Con)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Owner(IT)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("테스트결과 요약");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("해외 법인 적용 시 고려사항 ");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("AS-IS 현황");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("TO-BE 변화사항");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("비고/이슈");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Business Rule");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("수정일");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Version");
					
					cellIndex = 1;
					row = sheet.createRow(rowIndex);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle); 	cell.setCellValue(StringUtil.checkNull(resultSubMap.get("MyPath")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("Identifier")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle); 	cell.setCellValue(StringUtil.checkNull(resultSubMap.get("MyClassName")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("MyItemName")));
					
					sheet.addMergedRegion(new CellRangeAddress(5,5,5,7));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(removeAllTag(StringUtil.checkNull(subItemInfo.get("Description")),"DbToEx"));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("OwnerPI")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("OwnerCON")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("OwnerIT")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("ASIS")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("TOBE")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("ISSUE")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("BusinessRule")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("LastUpdated")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("Version")));
					rowIndex++;
					
					
					
					// Sheet Sub Item 
					cellIndex = 1;
					row = sheet.createRow(rowIndex);
					rowIndex++;
					
					row = sheet.createRow(rowIndex);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle); 	cell.setCellValue("No");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("ID");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("명칭");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("클래스");
					
					//sheet.addMergedRegion(new CellRangeAddress(7,7,5,7));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Guideline");
					//cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		
					//cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("System Type");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Application/Module");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("화면코드");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Check Point");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Result Output");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Test Result(Ok, Error)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Test Date");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("발생유형");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("조치계획일");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("조치완료일");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("조치사항");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("이슈");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("담당컨설턴트");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("담당PI");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("테스트수행인");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("비고");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Role");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("관련조직");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("비고/이슈");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("담당자");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("기능요건");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Business Rule");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("수정일");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Version");
					rowIndex++;
					
					Map setData = new HashMap();
					setData.put("s_itemID", StringUtil.checkNull(resultSubMap.get("MyItemID"))); 
					setData.put("languageID", languageID); 
					List childItemList = commonService.selectList("sap_SQL.zSAP_getChildItemList_gridList", setData);

					int p = 8;
					if(childItemList.size()>0){
						for(int m=0; m < childItemList.size(); m++){
							Map childItemInfo = (Map)childItemList.get(m);
							
							// ****
							String ItemID = StringUtil.checkNull(childItemInfo.get("ItemID"));
							setData.put("ItemID",  ItemID); 
							List childItemAttrList = commonService.selectList("attr_SQL.getItemAttributesInfo", setData);
							Map childAttrInfoMap = new HashMap();
							if(childItemAttrList.size()>0){
								for(int ii=0; ii<childItemAttrList.size(); ii++){
									Map childItemAttrListMap = (Map) childItemAttrList.get(ii);
									childAttrInfoMap.put(childItemAttrListMap.get("AttrTypeCode"), StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(childItemAttrListMap.get("PlainText"),"")));
								}
							}
							
							cellIndex = 1;
							row = sheet.createRow(rowIndex);
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("RNUM") ));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("Identifier") ));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("ItemName") ));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("ClassName") ));
							//sheet.addMergedRegion(new CellRangeAddress(p,p,5,7));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(removeAllTag(StringUtil.checkNull(childItemInfo.get("guideline")),"DbToEx"));
							
							//cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
							//cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("systemType") ));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("modualAPP") ));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("tCode") ));  
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("chkPoint") ));
							
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("role")));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("relOrg")));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("issue")));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("AuthorID")));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("funcReq")));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("businessRule")));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("LastUpdated")));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("Version")));
							rowIndex++;
							p++;
						}
					}
					
					int childIdx = childItemList.size() + 8;
					
					int n = 1;
					while (n < 6) { 					
						cellIndex = 1;
						row = sheet.createRow(rowIndex);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						
						//sheet.addMergedRegion(new CellRangeAddress(p,p,5,7));
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						//cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						//cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						rowIndex++;
						childIdx++;					
						n++;
						p++;
					}
					
					cellIndex = 1;
					row = sheet.createRow(rowIndex);
					sheet.addMergedRegion(new CellRangeAddress(childIdx,childIdx,1,11));
					rowIndex++;
					childIdx++;
					
					SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
					long date = System.currentTimeMillis();
					String itemName = StringUtil.checkNull(selectedItemMap.get("Identifier")) + "_" + StringUtil.checkNull(selectedItemMap.get("ItemName")).replace("/", "_");
					
					String selectedItemName1 = new String(sheetTmpName.getBytes("UTF-8"), "ISO-8859-1");
					String selectedItemName2 = new String(selectedItemName1.getBytes("8859_1"), "UTF-8");
					
					String orgFileName1 = "TS Script_" + selectedItemName1 + "_" + formatter.format(date) + ".xlsx";
					String orgFileName2 = "TS Script_" + selectedItemName2 + "_" + formatter.format(date) + ".xlsx";
					String downFile1 = FileUtil.FILE_EXPORT_DIR + orgFileName1;
					String downFile2 = FileUtil.FILE_EXPORT_DIR + orgFileName2;
					
					File file = new File(downFile2);			
					fileOutput =  new FileOutputStream(file);
					wb.write(fileOutput);
					
					/// zip file
					//File file = new File(fileName);
		            FileInputStream fis = new FileInputStream(file);
		            zos.putNextEntry(new ZipEntry(file.getName()));

		            int length;
		            while ((length = fis.read(buffer)) > 0) {
		                zos.write(buffer, 0, length);
		            }
		            

		            zos.closeEntry();
		            fis.close();
				}
				shtTmpIdx = 0;
				zos.close();
			//}
			
			//////////////////////////////////////// Create Element Info Sheet END //////////////////////////////////////////////////////
			/*
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			long date = System.currentTimeMillis();
			String itemName = StringUtil.checkNull(selectedItemMap.get("Identifier")) + "_" + StringUtil.checkNull(selectedItemMap.get("ItemName")).replace("/", "_");
			String selectedItemName1 = new String(itemName.getBytes("UTF-8"), "ISO-8859-1");
			String selectedItemName2 = new String(selectedItemName1.getBytes("8859_1"), "UTF-8");
			
			String orgFileName1 = "TS Script_" + selectedItemName1 + "_" + formatter.format(date) + ".xlsx";
			String orgFileName2 = "TS Script_" + selectedItemName2 + "_" + formatter.format(date) + ".xlsx";
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
			
			if(useDRM.equals("FASOO")){
				DRMUtil.drmMgt(drmInfoMap);
			}
			*/
			
			target.put(AJAX_SCRIPT, "doFileDown('"+zipFileName+"', 'excel');$('#isSubmit').remove();");
			
			
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
	
	@RequestMapping(value="/zSAP_TSInfoExcelReport2Zip.do")
	public String zSAP_excelReportTSInfo_ORG(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception{
		HashMap target = new HashMap();
		FileOutputStream fileOutput = null;
		XSSFWorkbook wb = new XSSFWorkbook();
		try{
			Map setMap = new HashMap();
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"), "");
			String modelItemClass = StringUtil.checkNull(commandMap.get("modelItemClass"));
			String elmClass = StringUtil.checkNull(commandMap.get("elmClass"));
			String elmChildList = StringUtil.checkNull(commandMap.get("elmChildList"));
			String elmInfoSheet = StringUtil.checkNull(commandMap.get("elmInfoSheet"));
			ArrayList sheetNameList = new ArrayList();
			int shtTmpIdx = 0;
			String sheetTmpName = "";
			String s_itemID = StringUtil.checkNull(request.getParameter("itemID"));
			setMap.put("languageID", languageID);
			setMap.put("s_itemID", s_itemID);
			commandMap.put("ItemID", s_itemID);
			// 선택한 아이템 정보
			Map selectedItemMap = commonService.select("sap_SQL.zSAP_getItemInfo", setMap);
			
			// 선택한 아이템 속성 정보
			List attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
			Map attrValueMap = new HashMap();
			for(int j=0; j<attrList.size(); j++){
				Map attrListMap = (Map) attrList.get(j);
				attrValueMap.put(attrListMap.get("AttrTypeCode"), StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(attrListMap.get("PlainText"),"")));
			}
			
			// AttrTypeCode + Name
			List temp = commonService.selectList("attr_SQL.getItemAttrType", setMap);
			
			Map attrTypeNameInfoMap = new HashMap();
			for(int j=0; j<temp.size(); j++){
				Map Temp = (Map) temp.get(j);
				attrTypeNameInfoMap.put(Temp.get("AttrTypeCode"), Temp.get("DataType"));
			}
			
			List resultSub = new ArrayList();
			setMap.put("itemID", s_itemID);
			setMap.put("itemIDs", s_itemID);
			setMap.put("modelItemClass", modelItemClass);
			setMap.put("elmClass", elmClass);
			String attrCodeString = "";

			
			
			resultSub = commonService.selectList("sap_SQL.zSAP_getElementStrInfo_gridList", setMap);
			sheetNameList.add(StringUtil.checkNull(selectedItemMap.get("Identifier")));
			
			XSSFSheet sheet = wb.createSheet(StringUtil.checkNull(selectedItemMap.get("Identifier")));
			XSSFCellStyle titleStyle = setCellTitleSyle(wb);
			XSSFCellStyle headerStyle = setCellHeaderStyle(wb);
			XSSFCellStyle headerStyle2 = setCellHeaderStyle2(wb);
			XSSFCellStyle contentsLeftStyle = setCellContentsStyleLeft(wb);
			XSSFCellStyle contentsCenterStyle = setCellContentsStyleCenter(wb);
			XSSFCellStyle underLine = setCellUnderline(wb);
			
			String elmInfoOnly = StringUtil.checkNull(commandMap.get("elmInfoOnly"));

			//눈금선 없애기
			sheet.setDisplayGridlines(false);
			
			int cellIndex = 1;
			int rowIndex = 1;
			XSSFRow row = sheet.createRow(rowIndex);
			XSSFCell cell = null;
			
			//sheet.setDefaultColumnWidth(3500);
			sheet.setColumnWidth((short)0,(short)300);

			row = sheet.createRow(0);
			row.setHeight((short) 200);
			
			row = sheet.createRow(rowIndex++);
			row.setHeight((short) 550);
			cell = row.createCell(cellIndex);
			//sheet.addMergedRegion(new CellRangeAddress(1,1,1,9));
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("ID");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("클래스");
			
			sheet.addMergedRegion(new CellRangeAddress(1,1,3,4));
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("명칭");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);

			sheet.addMergedRegion(new CellRangeAddress(1,1,5,6));
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Scenario Objective");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
			
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Check Point");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("동원F&B");
			//cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("디어푸드");
			//cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("YJP");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Owner(PI)");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Owner(Con)");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("IT담당자");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Corperation");
			
			cellIndex = 1;
			row = sheet.createRow(rowIndex++);
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(selectedItemMap.get("Identifier")));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(selectedItemMap.get("ClassName")));

			sheet.addMergedRegion(new CellRangeAddress(2,2,3,4));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(selectedItemMap.get("ItemName")));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);

			sheet.addMergedRegion(new CellRangeAddress(2,2,5,6));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(selectedItemMap.get("Description"))));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(attrValueMap.get("AT00029")));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(selectedItemMap.get("C101")));
			//cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(selectedItemMap.get("C102")));
			//cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(selectedItemMap.get("dimYJP")));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(attrValueMap.get("AT00022")));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(attrValueMap.get("AT00025")));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(attrValueMap.get("AT00024")));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(selectedItemMap.get("DimValueIDs"))));
			rowIndex++;
			//
			cellIndex = 1;
			row = sheet.createRow(rowIndex++);
			cell = row.createCell(cellIndex++);
			XSSFFont font= wb.createFont();
			font.setUnderline(XSSFFont.U_SINGLE);
			cell.setCellValue("Test Varint");
			
			//	
			cellIndex = 1;
			row = sheet.createRow(rowIndex++);
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("No");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Variant");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Value");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Remark");

			for(int i=0; i<10; i++) {
				cellIndex = 1;
				row = sheet.createRow(rowIndex++);
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
			}
			rowIndex++;
			//
			cellIndex = 1;
			row = sheet.createRow(rowIndex++);
			//sheet.addMergedRegion(new CellRangeAddress(7,7,1,9));
			cell = row.createCell(cellIndex++);
			font= wb.createFont();
			font.setUnderline(XSSFFont.U_SINGLE);
			cell.setCellValue("Process List");
			//
			cellIndex = 1;
			row = sheet.createRow(rowIndex++);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("No");
			
			sheet.addMergedRegion(new CellRangeAddress(18,18,2,3));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Process ID");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("클래스");
			
			sheet.addMergedRegion(new CellRangeAddress(18,18,5,6));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Process 명");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
			sheet.addMergedRegion(new CellRangeAddress(18,18,7,9));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("개요");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
			
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Owner(PI)");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Owner(Con)");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("IT담당자");
			
			
			//
			int j = 19;
			for(int i=0; i<resultSub.size(); i++){
				cellIndex = 1;
				Map resultSubMap = (Map) resultSub.get(i);
				
				String MyItemID = StringUtil.checkNull(resultSubMap.get("MyItemID"));
				commandMap.put("ItemID", MyItemID);
				List subItemAttrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
				Map subAttrInfoMap = new HashMap();
				for(int ii=0; ii<subItemAttrList.size(); ii++){
					Map subItemAttrListMap = (Map) subItemAttrList.get(ii);
					subAttrInfoMap.put(subItemAttrListMap.get("AttrTypeCode"), StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(subItemAttrListMap.get("PlainText"),"")));
				}
				
				row = sheet.createRow(rowIndex);
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsCenterStyle); cell.setCellValue(StringUtil.checkNull(resultSubMap.get("RNUM")));
				sheet.addMergedRegion(new CellRangeAddress(j,j,2,3));
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsCenterStyle); cell.setCellValue(StringUtil.checkNull(resultSubMap.get("Identifier")));
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsCenterStyle);

				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsCenterStyle); cell.setCellValue(StringUtil.checkNull(resultSubMap.get("MyClassName")));
				
				sheet.addMergedRegion(new CellRangeAddress(j,j,5,6));
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsCenterStyle); cell.setCellValue(StringUtil.checkNull(resultSubMap.get("MyItemName")));
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsCenterStyle);				
				sheet.addMergedRegion(new CellRangeAddress(j,j,7,9));
				//개요
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(removeAllTag(StringUtil.checkNull(subAttrInfoMap.get("AT00003")),"DbToEx"));
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
				
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(resultSubMap.get("OwnerPI")));
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(resultSubMap.get("OwnerCON")));
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(resultSubMap.get("OwnerIT")));
				rowIndex++;
				j++;
				
			}
			
			///////////////////////////////////////// Create Elemnet info Sheet Start  //////////////////////////////////////////
			if(elmInfoSheet.equals("Y")){			
				for(int i=0; i<resultSub.size(); i++){
					rowIndex = 1;
					Map resultSubMap = (Map) resultSub.get(i);
					
					setMap = new HashMap();
					setMap.put("s_itemID", StringUtil.checkNull(resultSubMap.get("MyItemID")));
					setMap.put("languageID", languageID);
					
					List subItemAttrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
					Map subAttrInfoMap = new HashMap();
					for(int ii=0; ii<subItemAttrList.size(); ii++){
						Map subItemAttrListMap = (Map) subItemAttrList.get(ii);
						subAttrInfoMap.put(subItemAttrListMap.get("AttrTypeCode"), StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(subItemAttrListMap.get("PlainText"),"")));
					}
					
					Map subItemInfo = commonService.select("report_SQL.getItemInfo", setMap);
					try{
						sheetTmpName = StringUtil.checkNull(resultSubMap.get("Identifier"))+StringUtil.checkNull(resultSubMap.get("MyItemName")).replace("/", "_");
						for(int shtIdx=0; shtIdx<sheetNameList.size(); shtIdx++) {
							if(sheetNameList.get(shtIdx).equals(sheetTmpName)) {
								shtTmpIdx++;
							}
						}
						sheetNameList.add(sheetTmpName);
						
						sheet = wb.createSheet(sheetTmpName+(shtTmpIdx>0 ? "("+shtTmpIdx+")":""));
						sheet.setDisplayGridlines(false);
					}catch(Exception ex){}
					
					sheet.setColumnWidth((short)0,(short)500);
					row = sheet.createRow(0);
					row.setHeight((short) 200);
					
					row = sheet.createRow(rowIndex);
					row.setHeight((short) 550);
					
					cellIndex = 1;
					row = sheet.createRow(rowIndex);
					sheet.addMergedRegion(new CellRangeAddress(1,1,1,2));
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Test Case 기준");
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(1,1,3,11));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					rowIndex++;
					
					cellIndex = 1;
					row = sheet.createRow(rowIndex);
					sheet.addMergedRegion(new CellRangeAddress(2,2,1,2));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Test Case Data");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(2,2,3,11));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					rowIndex++;
					
					// Sheet Sub Item 4
					cellIndex = 1;
					row = sheet.createRow(rowIndex);
					rowIndex++;
					
					row = sheet.createRow(rowIndex++);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle); 	cell.setCellValue("경로");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("ID");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle); 	cell.setCellValue("클래스");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("명칭");
					
					sheet.addMergedRegion(new CellRangeAddress(4,4,5,7));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("개요");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Owner(PI)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Owner(Con)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Owner(IT)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("테스트결과 요약");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("해외 법인 적용 시 고려사항 ");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("AS-IS 현황");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("TO-BE 변화사항");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("비고/이슈");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Business Rule");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("수정일");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Version");
					
					cellIndex = 1;
					row = sheet.createRow(rowIndex);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle); 	cell.setCellValue(StringUtil.checkNull(resultSubMap.get("MyPath")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("Identifier")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle); 	cell.setCellValue(StringUtil.checkNull(resultSubMap.get("MyClassName")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("MyItemName")));
					
					//sheet.addMergedRegion(new CellRangeAddress(5,5,5,7));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(removeAllTag(StringUtil.checkNull(subItemInfo.get("Description")),"DbToEx"));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("OwnerPI")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("OwnerCON")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("OwnerIT")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("ASIS")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("TOBE")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("ISSUE")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("BusinessRule")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("LastUpdated")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("Version")));
					rowIndex++;
					
					
					
					// Sheet Sub Item 
					cellIndex = 1;
					row = sheet.createRow(rowIndex);
					rowIndex++;
					
					row = sheet.createRow(rowIndex);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle); 	cell.setCellValue("No");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("ID");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("명칭");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("클래스");
					
					//sheet.addMergedRegion(new CellRangeAddress(7,7,5,7));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Guideline");
					//cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		
					//cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("System Type");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Application/Module");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("화면코드");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Check Point");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Result Output");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Test Result(Ok, Error)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Test Date");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("중요도");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("발생유형");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("조치계획일");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("조치완료일");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("조치사항");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("이슈");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("담당컨설턴트");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("담당PI");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("테스트수행인");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("비고");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Role");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("관련조직");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("비고/이슈");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("담당자");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("기능요건");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Business Rule");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("수정일");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Version");
					rowIndex++;
					
					Map setData = new HashMap();
					setData.put("s_itemID", StringUtil.checkNull(resultSubMap.get("MyItemID"))); 
					setData.put("languageID", languageID); 
					List childItemList = commonService.selectList("sap_SQL.zSAP_getChildItemList_gridList", setData);

					int p = 8;
					if(childItemList.size()>0){
						for(int m=0; m < childItemList.size(); m++){
							Map childItemInfo = (Map)childItemList.get(m);
							
							// ****
							String ItemID = StringUtil.checkNull(childItemInfo.get("ItemID"));
							setData.put("ItemID",  ItemID); 
							List childItemAttrList = commonService.selectList("attr_SQL.getItemAttributesInfo", setData);
							Map childAttrInfoMap = new HashMap();
							if(childItemAttrList.size()>0){
								for(int ii=0; ii<childItemAttrList.size(); ii++){
									Map childItemAttrListMap = (Map) childItemAttrList.get(ii);
									childAttrInfoMap.put(childItemAttrListMap.get("AttrTypeCode"), StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(childItemAttrListMap.get("PlainText"),"")));
								}
							}
							
							cellIndex = 1;
							row = sheet.createRow(rowIndex);
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("RNUM") ));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("Identifier") ));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("ItemName") ));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("ClassName") ));
						//	sheet.addMergedRegion(new CellRangeAddress(p,p,5,7));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(removeAllTag(StringUtil.checkNull(childItemInfo.get("guideline")),"DbToEx"));
							
						//	cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						//	cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("systemType") ));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("modualAPP") ));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("tCode") ));  
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("chkPoint") ));
							
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("OwnerCON") ));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("OwnerPI") ));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("role")));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("relOrg")));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("issue")));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("AuthorID")));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("funcReq")));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("businessRule")));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("LastUpdated")));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("Version")));
							rowIndex++;
							p++;
						}
					}
					
					int childIdx = childItemList.size() + 8;
					
					int n = 1;
					while (n < 6) { 					
						cellIndex = 1;
						row = sheet.createRow(rowIndex);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						
					//	sheet.addMergedRegion(new CellRangeAddress(p,p,5,7));
					//	cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					//	cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						rowIndex++;
						childIdx++;					
						n++;
						p++;
					}
					
					cellIndex = 1;
					row = sheet.createRow(rowIndex);
					sheet.addMergedRegion(new CellRangeAddress(childIdx,childIdx,1,11));
					rowIndex++;
					childIdx++;
				}
				shtTmpIdx = 0;
			}
			
			//////////////////////////////////////// Create Element Info Sheet END //////////////////////////////////////////////////////
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			long date = System.currentTimeMillis();
			String itemName = StringUtil.checkNull(selectedItemMap.get("Identifier")) + "_" + StringUtil.checkNull(selectedItemMap.get("ItemName")).replace("/", "_");
			String selectedItemName1 = new String(itemName.getBytes("UTF-8"), "ISO-8859-1");
			String selectedItemName2 = new String(selectedItemName1.getBytes("8859_1"), "UTF-8");
			
			String orgFileName1 = "TS Script_" + selectedItemName1 + "_" + formatter.format(date) + ".xlsx";
			String orgFileName2 = "TS Script_" + selectedItemName2 + "_" + formatter.format(date) + ".xlsx";
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
			
			if(useDRM.equals("FASOO")){
				DRMUtil.drmMgt(drmInfoMap);
			}
			
			target.put(AJAX_SCRIPT, "doFileDown('"+orgFileName1+"', 'excel');$('#isSubmit').remove();");
			
			
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
	
	@RequestMapping(value="/zSAP_TSInfoExcelReport3Zip.do")
	public String zSAP_excelReport3TSInfo_ORG(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception{
		HashMap target = new HashMap();
		FileOutputStream fileOutput = null;
		XSSFWorkbook wb = new XSSFWorkbook();
		try{
			Map setMap = new HashMap();
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"), "");
			String modelItemClass = StringUtil.checkNull(commandMap.get("modelItemClass"));
			String elmClass = StringUtil.checkNull(commandMap.get("elmClass"));
			String elmChildList = StringUtil.checkNull(commandMap.get("elmChildList"));
			String elmInfoSheet = StringUtil.checkNull(commandMap.get("elmInfoSheet"));
			ArrayList sheetNameList = new ArrayList();
			int shtTmpIdx = 0;
			String sheetTmpName = "";
			String s_itemID = StringUtil.checkNull(request.getParameter("itemID"));
			setMap.put("languageID", languageID);
			setMap.put("s_itemID", s_itemID);
			commandMap.put("ItemID", s_itemID);
			// 선택한 아이템 정보
			Map selectedItemMap = commonService.select("sap_SQL.zSAP_getItemInfo", setMap);
			
			// 선택한 아이템 속성 정보
			List attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
			Map attrValueMap = new HashMap();
			for(int j=0; j<attrList.size(); j++){
				Map attrListMap = (Map) attrList.get(j);
				attrValueMap.put(attrListMap.get("AttrTypeCode"), StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(attrListMap.get("PlainText"),"")));
			}
			
			// AttrTypeCode + Name
			List temp = commonService.selectList("attr_SQL.getItemAttrType", setMap);
			
			Map attrTypeNameInfoMap = new HashMap();
			for(int j=0; j<temp.size(); j++){
				Map Temp = (Map) temp.get(j);
				attrTypeNameInfoMap.put(Temp.get("AttrTypeCode"), Temp.get("DataType"));
			}
			
			List resultSub = new ArrayList();
			setMap.put("itemID", s_itemID);
			setMap.put("itemIDs", s_itemID);
			setMap.put("modelItemClass", modelItemClass);
			setMap.put("elmClass", elmClass);
			String attrCodeString = "";

			
			
			resultSub = commonService.selectList("sap_SQL.zSAP_getElementStrInfo_gridList", setMap);
			sheetNameList.add(StringUtil.checkNull(selectedItemMap.get("Identifier")));
			
			XSSFSheet sheet = wb.createSheet(StringUtil.checkNull(selectedItemMap.get("Identifier")));
			XSSFCellStyle titleStyle = setCellTitleSyle(wb);
			XSSFCellStyle headerStyle = setCellHeaderStyle(wb);
			XSSFCellStyle headerStyle2 = setCellHeaderStyle2(wb);
			XSSFCellStyle contentsLeftStyle = setCellContentsStyleLeft(wb);
			XSSFCellStyle contentsCenterStyle = setCellContentsStyleCenter(wb);
			XSSFCellStyle underLine = setCellUnderline(wb);
			
			String elmInfoOnly = StringUtil.checkNull(commandMap.get("elmInfoOnly"));

			//눈금선 없애기
			sheet.setDisplayGridlines(false);
			
			int cellIndex = 1;
			int rowIndex = 1;
			XSSFRow row = sheet.createRow(rowIndex);
			XSSFCell cell = null;
			
			//sheet.setDefaultColumnWidth(3500);
			sheet.setColumnWidth((short)0,(short)300);

			row = sheet.createRow(0);
			row.setHeight((short) 200);
			
			row = sheet.createRow(rowIndex++);
			row.setHeight((short) 550);
			cell = row.createCell(cellIndex);
			//sheet.addMergedRegion(new CellRangeAddress(1,1,1,9));
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("ID");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("클래스");
			
			sheet.addMergedRegion(new CellRangeAddress(1,1,3,4));
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("명칭");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);

			sheet.addMergedRegion(new CellRangeAddress(1,1,5,6));
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Scenario Objective");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
			
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Check Point");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("동원시스템즈");
			//cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("디어푸드");
			//cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("YJP");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Owner(PI)");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Owner(Con)");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("IT담당자");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Corperation");
			
			cellIndex = 1;
			row = sheet.createRow(rowIndex++);
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(selectedItemMap.get("Identifier")));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(selectedItemMap.get("ClassName")));

			sheet.addMergedRegion(new CellRangeAddress(2,2,3,4));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(selectedItemMap.get("ItemName")));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);

			sheet.addMergedRegion(new CellRangeAddress(2,2,5,6));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(selectedItemMap.get("Description"))));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(attrValueMap.get("AT00029")));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(selectedItemMap.get("C101")));
			//cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(selectedItemMap.get("C102")));
			//cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(selectedItemMap.get("dimYJP")));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(attrValueMap.get("AT00022")));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(attrValueMap.get("AT00025")));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(attrValueMap.get("AT00024")));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(selectedItemMap.get("DimValueIDs"))));
			rowIndex++;
			//
			cellIndex = 1;
			row = sheet.createRow(rowIndex++);
			cell = row.createCell(cellIndex++);
			XSSFFont font= wb.createFont();
			font.setUnderline(XSSFFont.U_SINGLE);
			cell.setCellValue("Test Varint");
			
			//	
			cellIndex = 1;
			row = sheet.createRow(rowIndex++);
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("No");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Variant");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Value");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Remark");

			for(int i=0; i<10; i++) {
				cellIndex = 1;
				row = sheet.createRow(rowIndex++);
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
			}
			rowIndex++;
			//
			cellIndex = 1;
			row = sheet.createRow(rowIndex++);
			//sheet.addMergedRegion(new CellRangeAddress(7,7,1,9));
			cell = row.createCell(cellIndex++);
			font= wb.createFont();
			font.setUnderline(XSSFFont.U_SINGLE);
			cell.setCellValue("Process List");
			//
			cellIndex = 1;
			row = sheet.createRow(rowIndex++);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("No");
			
			sheet.addMergedRegion(new CellRangeAddress(18,18,2,3));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Process ID");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("클래스");
			
			sheet.addMergedRegion(new CellRangeAddress(18,18,5,6));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Process 명");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
			sheet.addMergedRegion(new CellRangeAddress(18,18,7,9));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("개요");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
			
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Owner(PI)");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Owner(Con)");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("IT담당자");
			
			
			//
			int j = 19;
			for(int i=0; i<resultSub.size(); i++){
				cellIndex = 1;
				Map resultSubMap = (Map) resultSub.get(i);
				
				String MyItemID = StringUtil.checkNull(resultSubMap.get("MyItemID"));
				commandMap.put("ItemID", MyItemID);
				List subItemAttrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
				Map subAttrInfoMap = new HashMap();
				for(int ii=0; ii<subItemAttrList.size(); ii++){
					Map subItemAttrListMap = (Map) subItemAttrList.get(ii);
					subAttrInfoMap.put(subItemAttrListMap.get("AttrTypeCode"), StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(subItemAttrListMap.get("PlainText"),"")));
				}
				
				row = sheet.createRow(rowIndex);
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsCenterStyle); cell.setCellValue(StringUtil.checkNull(resultSubMap.get("RNUM")));
				sheet.addMergedRegion(new CellRangeAddress(j,j,2,3));
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsCenterStyle); cell.setCellValue(StringUtil.checkNull(resultSubMap.get("Identifier")));
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsCenterStyle);

				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsCenterStyle); cell.setCellValue(StringUtil.checkNull(resultSubMap.get("MyClassName")));
				
				sheet.addMergedRegion(new CellRangeAddress(j,j,5,6));
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsCenterStyle); cell.setCellValue(StringUtil.checkNull(resultSubMap.get("MyItemName")));
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsCenterStyle);				
				sheet.addMergedRegion(new CellRangeAddress(j,j,7,9));
				//개요
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(removeAllTag(StringUtil.checkNull(subAttrInfoMap.get("AT00003")),"DbToEx"));
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
				
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(resultSubMap.get("OwnerPI")));
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(resultSubMap.get("OwnerCON")));
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(resultSubMap.get("OwnerIT")));
				rowIndex++;
				j++;
				
			}
			
			///////////////////////////////////////// Create Elemnet info Sheet Start  //////////////////////////////////////////
			if(elmInfoSheet.equals("Y")){			
				for(int i=0; i<resultSub.size(); i++){
					rowIndex = 1;
					Map resultSubMap = (Map) resultSub.get(i);
					
					setMap = new HashMap();
					setMap.put("s_itemID", StringUtil.checkNull(resultSubMap.get("MyItemID")));
					setMap.put("languageID", languageID);
					
					List subItemAttrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
					Map subAttrInfoMap = new HashMap();
					for(int ii=0; ii<subItemAttrList.size(); ii++){
						Map subItemAttrListMap = (Map) subItemAttrList.get(ii);
						subAttrInfoMap.put(subItemAttrListMap.get("AttrTypeCode"), StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(subItemAttrListMap.get("PlainText"),"")));
					}
					
					Map subItemInfo = commonService.select("report_SQL.getItemInfo", setMap);
					try{
						sheetTmpName = StringUtil.checkNull(resultSubMap.get("Identifier"))+StringUtil.checkNull(resultSubMap.get("MyItemName")).replace("/", "_");
						for(int shtIdx=0; shtIdx<sheetNameList.size(); shtIdx++) {
							if(sheetNameList.get(shtIdx).equals(sheetTmpName)) {
								shtTmpIdx++;
							}
						}
						sheetNameList.add(sheetTmpName);
						
						sheet = wb.createSheet(sheetTmpName+(shtTmpIdx>0 ? "("+shtTmpIdx+")":""));
						sheet.setDisplayGridlines(false);
					}catch(Exception ex){}
					
					sheet.setColumnWidth((short)0,(short)500);
					row = sheet.createRow(0);
					row.setHeight((short) 200);
					
					row = sheet.createRow(rowIndex);
					row.setHeight((short) 550);
					
					cellIndex = 1;
					row = sheet.createRow(rowIndex);
					sheet.addMergedRegion(new CellRangeAddress(1,1,1,2));
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Test Case 기준");
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(1,1,3,11));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					rowIndex++;
					
					cellIndex = 1;
					row = sheet.createRow(rowIndex);
					sheet.addMergedRegion(new CellRangeAddress(2,2,1,2));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Test Case Data");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(2,2,3,11));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					rowIndex++;
					
					// Sheet Sub Item 4
					cellIndex = 1;
					row = sheet.createRow(rowIndex);
					rowIndex++;
					
					row = sheet.createRow(rowIndex++);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle); 	cell.setCellValue("경로");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("ID");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle); 	cell.setCellValue("클래스");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("명칭");
					
					sheet.addMergedRegion(new CellRangeAddress(4,4,5,7));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("개요");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Owner(PI)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Owner(Con)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Owner(IT)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("테스트결과 요약");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("해외 법인 적용 시 고려사항 ");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("AS-IS 현황");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("TO-BE 변화사항");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("비고/이슈");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Business Rule");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("수정일");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Version");
					
					cellIndex = 1;
					row = sheet.createRow(rowIndex);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle); 	cell.setCellValue(StringUtil.checkNull(resultSubMap.get("MyPath")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("Identifier")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle); 	cell.setCellValue(StringUtil.checkNull(resultSubMap.get("MyClassName")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("MyItemName")));
					
					//sheet.addMergedRegion(new CellRangeAddress(5,5,5,7));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(removeAllTag(StringUtil.checkNull(subItemInfo.get("Description")),"DbToEx"));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("OwnerPI")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("OwnerCON")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("OwnerIT")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("ASIS")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("TOBE")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("ISSUE")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("BusinessRule")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("LastUpdated")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(resultSubMap.get("Version")));
					rowIndex++;
					
					
					
					// Sheet Sub Item 
					cellIndex = 1;
					row = sheet.createRow(rowIndex);
					rowIndex++;
					
					row = sheet.createRow(rowIndex);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle); 	cell.setCellValue("No");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("ID");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("명칭");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("클래스");
					
					//sheet.addMergedRegion(new CellRangeAddress(7,7,5,7));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Guideline");
					//cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		
					//cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("System Type");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Application/Module");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Legacy");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Legacy IF ID");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("화면코드");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Check Point");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Result Output");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Test Result(Ok, Error)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Test Date");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("중요도");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("발생유형");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("조치계획일");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("조치완료일");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("조치사항");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("이슈");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("담당컨설턴트");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("담당PI");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("테스트수행인");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("비고");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Role");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("관련조직");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("비고/이슈");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("담당자");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("기능요건");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Business Rule");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("수정일");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Version");
					rowIndex++;
					
					Map setData = new HashMap();
					setData.put("s_itemID", StringUtil.checkNull(resultSubMap.get("MyItemID"))); 
					setData.put("languageID", languageID); 
					List childItemList = commonService.selectList("sap_SQL.zSAP_getChildItemList_gridList", setData);

					int p = 8;
					if(childItemList.size()>0){
						for(int m=0; m < childItemList.size(); m++){
							Map childItemInfo = (Map)childItemList.get(m);
							
							// ****
							String ItemID = StringUtil.checkNull(childItemInfo.get("ItemID"));
							setData.put("ItemID",  ItemID); 
							List childItemAttrList = commonService.selectList("attr_SQL.getItemAttributesInfo", setData);
							Map childAttrInfoMap = new HashMap();
							if(childItemAttrList.size()>0){
								for(int ii=0; ii<childItemAttrList.size(); ii++){
									Map childItemAttrListMap = (Map) childItemAttrList.get(ii);
									childAttrInfoMap.put(childItemAttrListMap.get("AttrTypeCode"), StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(childItemAttrListMap.get("PlainText"),"")));
								}
							}
							
							cellIndex = 1;
							row = sheet.createRow(rowIndex);
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("RNUM") ));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("Identifier") ));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("ItemName") ));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("ClassName") ));
						//	sheet.addMergedRegion(new CellRangeAddress(p,p,5,7));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(removeAllTag(StringUtil.checkNull(childItemInfo.get("guideline")),"DbToEx"));
							
						//	cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						//	cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("systemType") ));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("modualAPP") ));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("legacy") ));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("legacyIFID") ));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("tCode") ));  
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("chkPoint") ));
							
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("OwnerCON") ));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("OwnerPI") ));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("role")));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("relOrg")));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("issue")));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("AuthorID")));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("funcReq")));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("businessRule")));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("LastUpdated")));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("Version")));
							rowIndex++;
							p++;
						}
					}
					
					int childIdx = childItemList.size() + 8;
					
					int n = 1;
					while (n < 6) { 					
						cellIndex = 1;
						row = sheet.createRow(rowIndex);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						
					//	sheet.addMergedRegion(new CellRangeAddress(p,p,5,7));
					//	cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					//	cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						rowIndex++;
						childIdx++;					
						n++;
						p++;
					}
					
					cellIndex = 1;
					row = sheet.createRow(rowIndex);
					sheet.addMergedRegion(new CellRangeAddress(childIdx,childIdx,1,11));
					rowIndex++;
					childIdx++;
				}
				shtTmpIdx = 0;
			}
			
			//////////////////////////////////////// Create Element Info Sheet END //////////////////////////////////////////////////////
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			long date = System.currentTimeMillis();
			String itemName = StringUtil.checkNull(selectedItemMap.get("Identifier")) + "_" + StringUtil.checkNull(selectedItemMap.get("ItemName")).replace("/", "_");
			String selectedItemName1 = new String(itemName.getBytes("UTF-8"), "ISO-8859-1");
			String selectedItemName2 = new String(selectedItemName1.getBytes("8859_1"), "UTF-8");
			
			String orgFileName1 = "TS Script_" + selectedItemName1 + "_" + formatter.format(date) + ".xlsx";
			String orgFileName2 = "TS Script_" + selectedItemName2 + "_" + formatter.format(date) + ".xlsx";
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
			
			if(useDRM.equals("FASOO")){
				DRMUtil.drmMgt(drmInfoMap);
			}
			
			target.put(AJAX_SCRIPT, "doFileDown('"+orgFileName1+"', 'excel');$('#isSubmit').remove();");
			
			
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
	
	@RequestMapping(value="/zSAP_excelReportL4TSInfo.do")
	public String zSAP_excelReportL4TSInfo(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception{
		HashMap target = new HashMap();
		FileOutputStream fileOutput = null;
		XSSFWorkbook wb = new XSSFWorkbook();
		try{
			Map setMap = new HashMap();
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"), "");
			String modelItemClass = StringUtil.checkNull(commandMap.get("modelItemClass"));
			String elmClass = StringUtil.checkNull(commandMap.get("elmClass"));
			String elmChildList = StringUtil.checkNull(commandMap.get("elmChildList"));
			String elmInfoSheet = StringUtil.checkNull(commandMap.get("elmInfoSheet"));
			ArrayList sheetNameList = new ArrayList();
			int shtTmpIdx = 0;
			String sheetTmpName = "";
			String s_itemID = StringUtil.checkNull(request.getParameter("itemID"));
			setMap.put("languageID", languageID);
			setMap.put("s_itemID", s_itemID);
			commandMap.put("ItemID", s_itemID);
			
			// 선택한 아이템 정보
			Map selectedItemMap = commonService.select("sap_SQL.zSAP_getItemInfo", setMap);
			
			// 선택한 아이템 속성 정보
			List attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
			Map attrValueMap = new HashMap();
			for(int j=0; j<attrList.size(); j++){
				Map attrListMap = (Map) attrList.get(j);
				attrValueMap.put(attrListMap.get("AttrTypeCode"), StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(attrListMap.get("PlainText"),"")));
			}
			
			// AttrTypeCode + Name
			List temp = commonService.selectList("attr_SQL.getItemAttrType", setMap);
			
			Map attrTypeNameInfoMap = new HashMap();
			for(int j=0; j<temp.size(); j++){
				Map Temp = (Map) temp.get(j);
				attrTypeNameInfoMap.put(Temp.get("AttrTypeCode"), Temp.get("DataType"));
			}
			
			//List resultSub = new ArrayList();
			setMap.put("itemID", s_itemID);
			setMap.put("itemIDs", s_itemID);
			setMap.put("modelItemClass", modelItemClass);
			setMap.put("elmClass", elmClass);
			String attrCodeString = "";
			
			//resultSub = commonService.selectList("sap_SQL.zSAP_getElementStrInfo_gridList", setMap);
			sheetNameList.add(StringUtil.checkNull(selectedItemMap.get("Identifier")));
			
			XSSFSheet sheet = wb.createSheet(StringUtil.checkNull(selectedItemMap.get("Identifier")));
			XSSFCellStyle titleStyle = setCellTitleSyle(wb);
			XSSFCellStyle headerStyle = setCellHeaderStyle(wb);
			XSSFCellStyle headerStyle2 = setCellHeaderStyle2(wb);
			XSSFCellStyle contentsLeftStyle = setCellContentsStyleLeft(wb);
			XSSFCellStyle contentsCenterStyle = setCellContentsStyleCenter(wb);
			XSSFCellStyle underLine = setCellUnderline(wb);
			
			//눈금선 없애기
			sheet.setDisplayGridlines(false);
			
			int cellIndex = 1;
			int rowIndex = 1;
			XSSFRow row = sheet.createRow(rowIndex);
			XSSFCell cell = null;
			
			///////////////////////////////////////// Create Elemnet info Sheet Start  //////////////////////////////////////////
						
				
			rowIndex = 1;
			List subItemAttrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
			Map subAttrInfoMap = new HashMap();
			for(int ii=0; ii<subItemAttrList.size(); ii++){
				Map subItemAttrListMap = (Map) subItemAttrList.get(ii);
				subAttrInfoMap.put(subItemAttrListMap.get("AttrTypeCode"), StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(subItemAttrListMap.get("PlainText"),"")));
			}
			
			Map subItemInfo = commonService.select("report_SQL.getItemInfo", setMap);
			try{
				sheetTmpName = StringUtil.checkNull(subItemInfo.get("Identifier"))+StringUtil.checkNull(subItemInfo.get("MyItemName")).replace("/", "_");
				for(int shtIdx=0; shtIdx<sheetNameList.size(); shtIdx++) {
					if(sheetNameList.get(shtIdx).equals(sheetTmpName)) {
						shtTmpIdx++;
					}
				}
				sheetNameList.add(sheetTmpName);
				
				
			}catch(Exception ex){}
			
			sheet.setColumnWidth((short)0,(short)500);
			row = sheet.createRow(0);
			row.setHeight((short) 200);
			
			row = sheet.createRow(rowIndex);
			row.setHeight((short) 550);
			
			cellIndex = 1;
			row = sheet.createRow(rowIndex);
			sheet.addMergedRegion(new CellRangeAddress(1,1,1,2));
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Test Case 기준");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
			sheet.addMergedRegion(new CellRangeAddress(1,1,3,11));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			rowIndex++;
			
			cellIndex = 1;
			row = sheet.createRow(rowIndex);
			sheet.addMergedRegion(new CellRangeAddress(2,2,1,2));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Test Case Data");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
			sheet.addMergedRegion(new CellRangeAddress(2,2,3,11));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			rowIndex++;
			
			// Sheet Sub Item 4
			cellIndex = 1;
			row = sheet.createRow(rowIndex);
			rowIndex++;
			
			row = sheet.createRow(rowIndex++);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle); 	cell.setCellValue("경로");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("ID");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle); 	cell.setCellValue("클래스");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("명칭");
			
			sheet.addMergedRegion(new CellRangeAddress(4,4,5,7));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("개요");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Owner(PI)");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Owner(Con)");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Owner(IT)");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("테스트결과 요약");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("해외 법인 적용 시 고려사항 ");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("AS-IS 현황");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("TO-BE 변화사항");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("비고/이슈");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Business Rule");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("수정일");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Version");
			
			cellIndex = 1;
			row = sheet.createRow(rowIndex);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle); 	cell.setCellValue(StringUtil.checkNull(subItemInfo.get("Path")));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(subItemInfo.get("Identifier")));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle); 	cell.setCellValue(StringUtil.checkNull(subItemInfo.get("ClassName")));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(subItemInfo.get("ItemName")));
			
			sheet.addMergedRegion(new CellRangeAddress(5,5,5,7));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(removeAllTag(StringUtil.checkNull(subAttrInfoMap.get("AT00003")),"DbToEx"));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(attrValueMap.get("AT00022")));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(attrValueMap.get("AT00025")));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(attrValueMap.get("AT00024")));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(attrValueMap.get("AT00030")));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(attrValueMap.get("AT00054")));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(attrValueMap.get("AT00006")));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(attrValueMap.get("AT00042")));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(subItemInfo.get("LastUpdated")));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(subItemInfo.get("Version")));
			rowIndex++;
			
			
			
			// Sheet Sub Item 
			cellIndex = 1;
			row = sheet.createRow(rowIndex);
			rowIndex++;
			
			row = sheet.createRow(rowIndex);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle); 	cell.setCellValue("No");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("ID");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("명칭");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("클래스");
			
			//sheet.addMergedRegion(new CellRangeAddress(7,7,5,7));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Guideline");
			//cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		
			//cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Sysyem Type");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("모듈/APP");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("화면코드");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Check Point");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Result Output");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Test Result(Ok, Error)");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Test Date");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("중요도");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("발생유형");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("조치계획일");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("조치완료일");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("조치사항");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("이슈");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("담당컨설턴트");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("담당PI");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("테스트수행인");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("비고");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Role");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("관련조직");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("비고/이슈");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("담당자");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("기능요건");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Business Rule");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("수정일");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Version");
			rowIndex++;
			
			 
			List childItemList = commonService.selectList("sap_SQL.zSAP_getChildItemList_gridList", setMap);
			
			int p = 8;
			if(childItemList.size()>0){
				for(int m=0; m < childItemList.size(); m++){
					Map childItemInfo = (Map)childItemList.get(m);
					
					// ****
					String ItemID = StringUtil.checkNull(childItemInfo.get("ItemID"));
					setMap.put("ItemID",  ItemID); 
					List childItemAttrList = commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
					Map childAttrInfoMap = new HashMap();
					if(childItemAttrList.size()>0){
						for(int ii=0; ii<childItemAttrList.size(); ii++){
							Map childItemAttrListMap = (Map) childItemAttrList.get(ii);
							childAttrInfoMap.put(childItemAttrListMap.get("AttrTypeCode"), StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(childItemAttrListMap.get("PlainText"),"")));
						}
					}
					
					cellIndex = 1;
					row = sheet.createRow(rowIndex);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("RNUM") ));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("Identifier") ));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("ItemName") ));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("ClassName") ));
					//sheet.addMergedRegion(new CellRangeAddress(p,p,5,7));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(removeAllTag(StringUtil.checkNull(childItemInfo.get("guideline")),"DbToEx"));
					//cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					//cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("systemType") ));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("modualAPP") ));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("tCode") ));  
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("chkPoint") ));
					
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("OwnerCON") ));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("OwnerPI")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue("");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("role")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("relOrg")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("issue")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("AuthorID")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("funcReq")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("businessRule")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("LastUpdated")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("Version")));
					rowIndex++;
					p++;
				}
			}
			
			int childIdx = childItemList.size() + 8;
			
			int n = 1;
			while (n < 6) { 					
				cellIndex = 1;
				row = sheet.createRow(rowIndex);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				
				//sheet.addMergedRegion(new CellRangeAddress(p,p,5,7));
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				//cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				//cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);

				rowIndex++;
				childIdx++;					
				n++;
				p++;
			}
			
			cellIndex = 1;
			row = sheet.createRow(rowIndex);
			sheet.addMergedRegion(new CellRangeAddress(childIdx,childIdx,1,11));
			rowIndex++;
			childIdx++;
			
			
			//////////////////////////////////////// Create Element Info Sheet END //////////////////////////////////////////////////////
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			long date = System.currentTimeMillis();
			String itemName = StringUtil.checkNull(selectedItemMap.get("Identifier")) + "_" + StringUtil.checkNull(selectedItemMap.get("ItemName")).replace("/", "_");
			String selectedItemName1 = new String(itemName.getBytes("UTF-8"), "ISO-8859-1");
			String selectedItemName2 = new String(selectedItemName1.getBytes("8859_1"), "UTF-8");
			
			String orgFileName1 = "TS Script_" + selectedItemName1 + "_" + formatter.format(date) + ".xlsx";
			String orgFileName2 = "TS Script_" + selectedItemName2 + "_" + formatter.format(date) + ".xlsx";
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
			
			if(useDRM.equals("FASOO")){
				DRMUtil.drmMgt(drmInfoMap);
			}
			
			target.put(AJAX_SCRIPT, "doFileDown('"+orgFileName1+"', 'excel');$('#isSubmit').remove();");
			
			
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

	@RequestMapping(value="/zSAP_runSysLink.do")
	public String runSysLink(Map commandMap,ModelMap model, HttpServletRequest request) throws Exception {
		Map setMap = new HashMap();
		String itemID = StringUtil.checkNull(commandMap.get("itemID"));
		// String attrTypeCode = "AT00014";
		String attrTypeCode = StringUtil.checkNull(commandMap.get("attrTypeCode"),"AT00014");
		
		setMap.put("attrTypeCode", attrTypeCode);
		setMap.put("itemID", itemID);
		setMap.put("languageID", commandMap.get("sessionDefLanguageId"));			
		String LinkParameter = commonService.selectString("link_SQL.getAttrValue", setMap);
		String url = commonService.selectString("link_SQL.getAttrUrl", setMap);
		
		if(attrTypeCode.equals("AT00014") || attrTypeCode.equals("AT00039")) {
			url = StringUtil.checkNull(url) + StringUtil.checkNull(LinkParameter) + " -DISPLAY";
		} else{
			url = StringUtil.checkNull(url);
		}
		return redirect(url);	
	}
	
	private XSSFCellStyle setCellTitleSyle(XSSFWorkbook wb) {
		XSSFCellStyle style = wb.createCellStyle();
		
		style.setFillForegroundColor(new XSSFColor(new Color(22, 54, 92)));
		style.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		style.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		style.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		style.setBorderRight(XSSFCellStyle.BORDER_THIN);
		style.setBorderTop(XSSFCellStyle.BORDER_THIN);
		style.setVerticalAlignment(VerticalAlignment.CENTER);
		style.setAlignment(XSSFCellStyle.ALIGN_CENTER);
		
		XSSFFont font = wb.createFont();
		font.setFontHeightInPoints((short) 16);
		font.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
		font.setFontName("맑은 고딕");
		font.setColor(HSSFColor.WHITE.index);
		style.setFont(font);
		
		return style;
	}

	private XSSFCellStyle setCellHeaderStyle(XSSFWorkbook wb) {
		XSSFCellStyle style = wb.createCellStyle();
				
		style.setFillForegroundColor(new XSSFColor(new Color(220, 230, 241)));
		style.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		style.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		style.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		style.setBorderRight(XSSFCellStyle.BORDER_THIN);
		style.setBorderTop(XSSFCellStyle.BORDER_THIN);
		style.setVerticalAlignment(VerticalAlignment.CENTER);
		style.setAlignment(XSSFCellStyle.ALIGN_CENTER);
				
		XSSFFont font = wb.createFont();
		font.setFontHeightInPoints((short) 11);
		font.setFontName("맑은 고딕");
		style.setFont(font);
		 
		return style;
	}
	
	private XSSFCellStyle setCellHeaderStyle2(XSSFWorkbook wb) {
		XSSFCellStyle style = wb.createCellStyle();
		
		style.setFillForegroundColor(new XSSFColor(new Color(234, 234, 234)));
		style.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		style.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		style.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		style.setBorderRight(XSSFCellStyle.BORDER_THIN);
		style.setBorderTop(XSSFCellStyle.BORDER_THIN);
		style.setVerticalAlignment(VerticalAlignment.CENTER);
		style.setAlignment(XSSFCellStyle.ALIGN_CENTER);
				
		XSSFFont font = wb.createFont();
		font.setFontHeightInPoints((short) 11);
		font.setFontName("맑은 고딕");
		style.setFont(font);
		
		return style;
	}
	
	private XSSFCellStyle setCellContentsStyleLeft(XSSFWorkbook wb) {
		XSSFCellStyle style = wb.createCellStyle();
		 
		style.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		style.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		style.setBorderRight(XSSFCellStyle.BORDER_THIN);
		style.setBorderTop(XSSFCellStyle.BORDER_THIN);
		style.setVerticalAlignment(VerticalAlignment.CENTER);
		
		XSSFFont font = wb.createFont();
		font.setFontHeightInPoints((short) 11);
		font.setFontName("맑은 고딕");
		style.setFont(font);
		 
		return style;
	}
	
	private XSSFCellStyle setCellContentsStyleCenter(XSSFWorkbook wb) {
		XSSFCellStyle style = wb.createCellStyle();
		 
		style.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		style.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		style.setBorderRight(XSSFCellStyle.BORDER_THIN);
		style.setBorderTop(XSSFCellStyle.BORDER_THIN);
		style.setVerticalAlignment(VerticalAlignment.CENTER);
		style.setAlignment(XSSFCellStyle.ALIGN_CENTER);
		
		XSSFFont font = wb.createFont();
		font.setFontHeightInPoints((short) 11);
		font.setFontName("맑은 고딕");
		style.setFont(font);
		 
		return style;
	}
	
	private XSSFCellStyle setCellUnderline(XSSFWorkbook wb) {
		XSSFCellStyle style = wb.createCellStyle();
		
		XSSFFont font= wb.createFont();
		font.setUnderline(XSSFFont.U_SINGLE);
		style.setFont(font);
		
		return style;
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
		//return str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#10;", " ").replace("&#xa;", "").replace("&nbsp;", " ");
		return StringEscapeUtils.unescapeHtml4(str);
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
	@RequestMapping(value="/zSAP_SubItemListWithElmInfo.do")
	public String zSAP_SubItemListWithElmInfo(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception{
		
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
			int tempIndex = (elmInfoSheet.equals("Y")? 2 : 1);
			ArrayList sheetNameList = new ArrayList();
			int shtTmpIdx = 0;
			int allDataIdx = 0;
			int elmDataIdx = 0;
			String sheetTmpName = "";

			
			List<Map> result = commonService.selectList("report_SQL.getItemStrList_gridList", commandMap);
			List resultSub = new ArrayList();
			List elementChild = new ArrayList();
			Map menu = getLabel(request, commonService);
			String attType = "AT00003,AT00008,AT00013,AT00027,AT00014,AT00053,'','','','','','','',''";
			String attrName = "개요,Guideline,Application,개발 ID,T-Code,Check point,Test 차수,Test 담당자(정),Test 담당자(부),결과값,Pass/Fail,특이/에러사항,처리방안,비고";
			
			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			String defaultLang = StringUtil.checkNull(commandMap.get("sessionDefLanguageId"));
			// 파일명에 이용할 Item Name 을 취득
			Map selectedItemMap = commonService.select("report_SQL.getItemInfo", commandMap);
			String selectedItemName = StringUtil.checkNull(selectedItemMap.get("ItemName"));
			selectedItemName = FormatUtil.makeValidSheetName(selectedItemName);
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
			

			// 그외의 속성
			String[] attrNameArray = attrName.split(",");
			String[] attrTypeArray = attType.split(",");
						
			// Title 행 설정
			row = sheet.createRow(rowIndex);
			row.setHeight((short) 512);
			
			/* NO */
			cell = row.createCell(cellIndex);
			cell.setCellValue("NO");
			cell.setCellStyle(headerStyle);
			cellIndex++;
			/* Module */
			cell = row.createCell(cellIndex);
			cell.setCellValue("Module");
			cell.setCellStyle(headerStyle);
			cellIndex++;			
			/* 경로 */
			cell = row.createCell(cellIndex);
			cell.setCellValue(String.valueOf(menu.get("LN00043")));
			cell.setCellStyle(headerStyle);
			/* 경로 열 숨기기 */
			sheet.setColumnHidden(cellIndex, true);
			cellIndex++;
			/* Process ID */
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
			rowIndex++;
			
			String MyItemName = "";
			String MyPath = "";
			String[] Module = {""};
			// Data 행 설정 
			for (int i=0; i < result.size();i++) {
				Map map = result.get(i);
				itemID = String.valueOf(map.get("MyItemID"));
				ClassCode = String.valueOf(map.get("MyClassCode"));
				MyPath = String.valueOf(StringUtil.checkNull(map.get("MyPath")));
				Module = MyPath.split("/",2);
				
				cellIndex = 0;   // cell index 초기화
			    row = sheet.createRow(rowIndex);
			    row.setHeight((short) (512 * ((double) 8 / 10 )));
		    	MyItemName = StringUtil.checkNull(map.get("MyItemName")).replaceAll("&#10;", "").replaceAll("&amp;", "&");
			   
		    	cell = row.createCell(cellIndex);
			    cell.setCellValue(++allDataIdx); // RNUM
			    if(modelItemClass.equals(ClassCode)){
			    	contentsStyle = selStyle;
			    }else{
			    	contentsStyle = deFaultStyle;
			    }
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(Module[0]); // Module
			    cell.setCellStyle(contentsStyle);
			    sheet.autoSizeColumn(cellIndex);
			    cellIndex++;
			    cell = row.createCell(cellIndex);
			    cell.setCellValue(MyPath); // 경로
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
							cellValue = plainText;
						}
					}
					cell = row.createCell(cellIndex);
					cell.setCellValue(cellValue);
					cell.setCellStyle(contentsStyle);
					cell.setCellType(XSSFCell.CELL_TYPE_STRING);
					sheet.autoSizeColumn(cellIndex);
					cellIndex++;
					
				}
			    rowIndex++;
			    
				if(modelItemClass.equals(ClassCode)){
					setMap = new HashMap();				
					setMap.put("MTCategory", "BAS");
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
						    MyPath = String.valueOf(StringUtil.checkNull(resultSubMap.get("Path")));
							Module = MyPath.split("/", 2);
							
							row = sheet.createRow(rowIndex);
						    row.setHeight((short) (512 * ((double) 8 / 10 )));
						    MyItemName = StringUtil.checkNull(resultSubMap.get("ItemName")).replaceAll("&#10;", "").replaceAll("&amp;", "&");
						    cell = row.createCell(cellIndex);
						    cell.setCellValue(++allDataIdx); // RNUM
						    cell.setCellStyle(contentsStyle);
						    sheet.autoSizeColumn(cellIndex);
						    cellIndex++;
						    cell = row.createCell(cellIndex);
						    cell.setCellValue(Module[0]); // Module
						    cell.setCellStyle(contentsStyle);
						    sheet.autoSizeColumn(cellIndex);
						    cellIndex++;
						    cell = row.createCell(cellIndex);
						    cell.setCellValue(MyPath); // 경로
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
										cellValue = plainText;
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
										sheetTmpName = StringUtil.checkNull(resultSubMap.get("Identifier"))+" "+ StringUtil.checkNull(resultSubMap.get("ItemName"));
										sheetTmpName = FormatUtil.makeValidSheetName(sheetTmpName);
										for(int shtIdx=0; shtIdx<sheetNameList.size(); shtIdx++) {
											if(sheetNameList.get(shtIdx).equals(sheetTmpName)) {
												shtTmpIdx++;
											}
										}
										sheetNameList.add(sheetTmpName);
										
										sheet = wb.createSheet(sheetTmpName+(shtTmpIdx>0 ? "("+shtTmpIdx+")":""));
										row = sheet.createRow(rowIndex);
										
										// Title 행 설정
										cellIndex = 0;   // cell index 초기화
										row = sheet.createRow(rowIndex);
										row.setHeight((short) 512);
										/* ItemID */
										cell = row.createCell(cellIndex);
										cell.setCellValue("NO");
										cell.setCellStyle(headerStyle);
										cellIndex++;
										/* Module */
										cell = row.createCell(cellIndex);
										cell.setCellValue("Module");
										cell.setCellStyle(headerStyle);
										cellIndex++;
										/* 경로 */
										cell = row.createCell(cellIndex);
										cell.setCellValue(String.valueOf(menu.get("LN00043")));
										cell.setCellStyle(headerStyle);
										/* 경로 열 숨기기 */
										sheet.setColumnHidden(cellIndex, true);
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
										    cell.setCellValue((a1 == 1 ? ++elmDataIdx : ++allDataIdx)); // Rnum
										    cell.setCellStyle(deFaultStyle);
										    sheet.autoSizeColumn(cellIndex);
										    cellIndex++;
										    cell = row.createCell(cellIndex);
										    cell.setCellValue(Module[0]); // Module
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
														cellValue = plainText;
													}
												}
												cell = row.createCell(cellIndex);
												cell.setCellValue(cellValue);
												cell.setCellStyle(deFaultStyle);
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												sheet.autoSizeColumn(cellIndex);
												cellIndex++;
												
											}
										    rowIndex++;
										}
									}
									elmDataIdx = 0;
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
			String itemName =  StringUtil.checkNull(selectedItemMap.get("ItemName"));
			itemName = FormatUtil.makeValidFileName(itemName);
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
			if(!"".equals(useDRM)){
				drmInfoMap.put("funcType", "report");
				DRMUtil.drmMgt(drmInfoMap); // 암호화 
			}
			
			//target.put(AJAX_SCRIPT, "parent.doFileDown('"+orgFileName1+"', 'excel');parent.$('#isSubmit').remove();");
			target.put(AJAX_SCRIPT, "doFileDown('"+orgFileName1+"', 'excel');");
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
     * SHA-256으로 해싱하는 메소드
     * 
     * @param bytes
     * @return
     * @throws NoSuchAlgorithmException 
     */
    public static String sha256(String msg) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        md.update(msg.getBytes());
        
        return bytesToHex(md.digest());
    }
 
    /**
     * 바이트를 헥스값으로 변환한다
     * 
     * @param bytes
     * @return
     */
    public static String bytesToHex(byte[] bytes) {
        StringBuilder builder = new StringBuilder();
        for (byte b: bytes) {
          builder.append(String.format("%02x", b));
        }
        return builder.toString();
    }
    
}