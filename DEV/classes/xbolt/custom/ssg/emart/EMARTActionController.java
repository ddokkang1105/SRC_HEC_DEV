package xbolt.custom.ssg.emart;

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
import java.util.TreeSet;
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

import com.aspose.words.BreakType;
import com.aspose.words.CellMerge;
import com.aspose.words.CellVerticalAlignment;
import com.aspose.words.Document;
import com.aspose.words.DocumentBuilder;
import com.aspose.words.HeaderFooterType;
import com.aspose.words.HeightRule;
import com.aspose.words.License;
import com.aspose.words.PageSetup;
import com.aspose.words.PaperSize;
import com.aspose.words.ParagraphAlignment;
import com.aspose.words.PreferredWidth;
import com.aspose.words.RelativeHorizontalPosition;
import com.aspose.words.RelativeVerticalPosition;
import com.aspose.words.Section;
import com.aspose.words.TabAlignment;
import com.aspose.words.WrapType;
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
 * @Class Name : EMARTActionController.java
 * @Description : EMARTActionController.java
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2024. 09. 24. smartfactory		최초생성
 *
 * @since 2024. 03. 29
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class EMARTActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	private ReportActionController RAC;

	

	@RequestMapping(value="/zEMT_TSInfoZip.do") //ZRP0008 - Download TS ZIP Script
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
			Map selectedItemMap = commonService.select("sap_SQL.zEMT_getItemInfo", setMap);
			
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
			List resultSub = commonService.selectList("sap_SQL.zEMT_getElementStrInfo_gridList", setMap);
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
					
					int cellIndex;
					int rowIndex = 0;
					XSSFRow row;
				    XSSFCell cell;
					
					//sheet.setDefaultColumnWidth(3500);
					sheet.setColumnWidth((short)0,(short)300);

					// 1행
					row = sheet.createRow(rowIndex++); 
					row.setHeight((short) 200);
					
					// 2행
					row = sheet.createRow(rowIndex++);
					row.setHeight((short) 550); 
					cellIndex = 1; 
					cell = row.createCell(cellIndex); 
					cell.setCellStyle(titleStyle);  
					cell.setCellValue("■ Test 개요"); 
					
					// 3행
					row = sheet.createRow(rowIndex++);
					row.setHeight((short) 550);
					cellIndex = 1;
					
					//sheet.addMergedRegion(new CellRangeAddress(1,1,1,9));
					sheet.addMergedRegion(new CellRangeAddress(2,2,1,2));
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Test Scenario ID");
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(2,2,3,4));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(selectedItemMap.get("Identifier")));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					sheet.addMergedRegion(new CellRangeAddress(2,2,5,6));
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Test Owner");
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					sheet.addMergedRegion(new CellRangeAddress(2,2,7,8));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(attrValueMap.get("AT00012"))); //Owner
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					sheet.addMergedRegion(new CellRangeAddress(2,2,9,10));
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Test Date");
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(2,2,11,12));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					
					//4행
					row = sheet.createRow(rowIndex++);
					row.setHeight((short) 550);
					cellIndex = 1; 
					
					sheet.addMergedRegion(new CellRangeAddress(3,3,1,2));
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Scenario Title");
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(3,3,3,4));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(selectedItemMap.get("ItemName")));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					sheet.addMergedRegion(new CellRangeAddress(3,3,5,6));
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Test Performer");
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(3,3,7,8));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					sheet.addMergedRegion(new CellRangeAddress(3,3,9,10));
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Status");
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(3,3,11,12));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					
					//5행
					row = sheet.createRow(rowIndex++);
					row.setHeight((short) 550);
					cellIndex = 1; 
					
					sheet.addMergedRegion(new CellRangeAddress(4,4,1,2));
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Test Category");
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(4,4,3,4));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					sheet.addMergedRegion(new CellRangeAddress(4,4,5,6));
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("QA(PMO/영역리더)");
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(4,4,7,8));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					sheet.addMergedRegion(new CellRangeAddress(4,4,9,10));
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Main Module");
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(4,4,11,12));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);

					
					//6행
					row = sheet.createRow(rowIndex++);
					row.setHeight((short) 550);
					cellIndex = 1; 
					
					sheet.addMergedRegion(new CellRangeAddress(5,6,1,2));
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Description");
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(5,6,3,8));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(selectedItemMap.get("Description")))); //개요
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					sheet.addMergedRegion(new CellRangeAddress(5,5,9,10));
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Test Time");
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(5,5,11,12));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					
					//7행
					row = sheet.createRow(rowIndex++);
					row.setHeight((short) 550);
					cellIndex = 1; 

					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);

					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					sheet.addMergedRegion(new CellRangeAddress(6,6,9,10));
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Test Place");
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(6,6,11,12));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);

					rowIndex++;
					
					
					//Tast Cast Box 시작
					// 빈 행 추가
					// 제목 추가 - ■ Test 개요
					row = sheet.createRow(rowIndex++);
					row.setHeight((short) 550); 
					cellIndex = 1; 
					cell = row.createCell(cellIndex); 
					cell.setCellStyle(titleStyle);  
					cell.setCellValue("■ Test 개요"); 
					sheet.addMergedRegion(new CellRangeAddress(rowIndex - 1, rowIndex - 1, 1, 3)); 

					cellIndex = 1;
					row = sheet.createRow(rowIndex++);
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("No");
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("구분");
					sheet.addMergedRegion(new CellRangeAddress(rowIndex - 1, rowIndex - 1, 3, 7)); 
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Test Data / Code");
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(rowIndex - 1, rowIndex - 1, 8, 12)); 
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Remark");
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);

					for(int i3=0; i3<10; i3++) {
						cellIndex = 1;
						row = sheet.createRow(rowIndex++);
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
						sheet.addMergedRegion(new CellRangeAddress(rowIndex - 1, rowIndex - 1, 3, 7)); 
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
						sheet.addMergedRegion(new CellRangeAddress(rowIndex - 1, rowIndex - 1, 8, 12)); 
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
					}
					rowIndex++;
					
					//Business Process List Box 시작
					// 제목 추가 - ■ Test 개요
					row = sheet.createRow(rowIndex++);
					row.setHeight((short) 550); 
					cellIndex = 1; 
					cell = row.createCell(cellIndex); 
					cell.setCellStyle(titleStyle);  
					cell.setCellValue("■ Business Process List"); 
					sheet.addMergedRegion(new CellRangeAddress(rowIndex - 1, rowIndex - 1, 1, 3)); 

					cellIndex = 1;
					row = sheet.createRow(rowIndex++);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("No");
					
					sheet.addMergedRegion(new CellRangeAddress(22,22,2,3)); //(rowIndex - 1,rowIndex - 1,2,3));)
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("프로세스 ID");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					
					sheet.addMergedRegion(new CellRangeAddress(22,22,4,5));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("클래스");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					
					sheet.addMergedRegion(new CellRangeAddress(22,22,6,8)); 
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("프로세스 Title");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					
					sheet.addMergedRegion(new CellRangeAddress(22,22,9,13)); 
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("개요");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					
					sheet.addMergedRegion(new CellRangeAddress(22,22,14,15)); 
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Remark");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("주관 팀");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Owner(PI)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Owner(ST)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Owner(I&C)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Owner(Con.)");

					
					int j = 23;
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

						sheet.addMergedRegion(new CellRangeAddress(j,j,4,5)); 
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsCenterStyle); cell.setCellValue(StringUtil.checkNull(resultSubMap.get("MyClassName")));
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsCenterStyle); 
						
						sheet.addMergedRegion(new CellRangeAddress(j,j,6,8));
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(resultSubMap.get("MyItemName")));
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);	
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);	
						
						//개요
						sheet.addMergedRegion(new CellRangeAddress(j,j,9,13));
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(removeAllTag(StringUtil.checkNull(subAttrInfoMap.get("AT00003")),"DbToEx"));
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
						
						sheet.addMergedRegion(new CellRangeAddress(j,j,14,15));
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsCenterStyle); cell.setCellValue(StringUtil.checkNull(resultSubMap.get("Remark")));
						cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
						
						
						for (int k = 0; k < 5; k++) {
					        cell = row.createCell(cellIndex++); 
					        cell.setCellStyle(contentsLeftStyle);
					    }
						
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
					
					// Sheet Sub Item 4
					//2행
					row = sheet.createRow(rowIndex++);
					row.setHeight((short) 550);
					cellIndex = 1; 

					sheet.addMergedRegion(new CellRangeAddress(1,1,1,2));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);			cell.setCellValue("ID(L4)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle); 
					sheet.addMergedRegion(new CellRangeAddress(1,1,3,4));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);	cell.setCellValue(StringUtil.checkNull(resultSubMap.get("Identifier")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle); 		cell.setCellValue("주관팀");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);	cell.setCellValue(StringUtil.checkNull(resultSubMap.get("TeamName")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);			cell.setCellValue("Owner(PI)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);	cell.setCellValue(StringUtil.checkNull(resultSubMap.get("Author")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);			cell.setCellValue("Owner(ST)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					
					// 너비 조정
					for (int col = 5; col < 11; col++) { 
					    sheet.setColumnWidth(col, (short) 3000); 
					}
					
					//3행
					row = sheet.createRow(rowIndex++);
					row.setHeight((short) 550);
					cellIndex = 1; 
					
					sheet.addMergedRegion(new CellRangeAddress(2,2,1,2));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);			cell.setCellValue("프로세스 Name");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);	
					sheet.addMergedRegion(new CellRangeAddress(2,2,3,4));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);	cell.setCellValue(StringUtil.checkNull(resultSubMap.get("MyItemName")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle); 		cell.setCellValue("Test 일자");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);			cell.setCellValue("Owner(I&C)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);			cell.setCellValue("Owner(Con.)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					
					//4행
					row = sheet.createRow(rowIndex++);
					row.setHeight((short) 550);
					cellIndex = 1; 
					
					sheet.addMergedRegion(new CellRangeAddress(3,3,1,2));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);			cell.setCellValue("프로세스 개요");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					
					sheet.addMergedRegion(new CellRangeAddress(3,3,3,10));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle); 	cell.setCellValue(removeAllTag(StringUtil.checkNull(subItemInfo.get("Description")),"DbToEx"));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					
					//5행
					row = sheet.createRow(rowIndex++);
					row.setHeight((short) 550);
					cellIndex = 1; 
					
					sheet.addMergedRegion(new CellRangeAddress(4,4,1,2));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Test Case Data");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(4,4,3,10));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					
					//6행
					row = sheet.createRow(rowIndex++);
					row.setHeight((short) 550);
					cellIndex = 1; 
					
					sheet.addMergedRegion(new CellRangeAddress(5,5,1,2));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("테스트 결과 요약");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(5,5,3,10));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					
					rowIndex++;
					
					
					
					// Sheet Sub Item 
					cellIndex = 1;
					row = sheet.createRow(rowIndex);
					rowIndex++;
					
					row = sheet.createRow(rowIndex);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle); 	cell.setCellValue("No");
					sheet.addMergedRegion(new CellRangeAddress(8,8,2,3));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Activity ID(L5)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(8,8,4,5));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Activity 명칭(L5)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(8,8,6,8));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Activity 개요");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("수행주체");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("시스템");
					sheet.addMergedRegion(new CellRangeAddress(8,8,11,12));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("T-Code or 개발ID");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(8,8,13,15));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Check Point");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(8,8,16,17));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Result Output");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(8,8,18,19));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Result(Ok, Error, Log)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("발생 유형");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("이슈");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("비고");

					rowIndex++;
					
					Map setData = new HashMap();
					setData.put("s_itemID", StringUtil.checkNull(resultSubMap.get("MyItemID"))); 
					setData.put("languageID", languageID); 
					List childItemList = commonService.selectList("sap_SQL.zEMT_getChildItemList_gridList", setData);

					int p = 10;
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
							
							//10행
							cellIndex = 1;
							row = sheet.createRow(rowIndex);
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("RNUM") ));
							sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,2,3));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("Identifier") ));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);
							sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,4,5));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("ItemName") ));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
							sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,6,8));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(removeAllTag(StringUtil.checkNull(childItemInfo.get("description")),"DbToEx"));			
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
							
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("RsEntity")));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("System")));
							sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,11,12));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("tCode")));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);
							sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,13,15));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle); 		//Check Point
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
							sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,16,17));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		//Result Output
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
							sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,18,19));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		//Result(Ok, Error, Log)
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
							
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		//발생 유형
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		//이슈
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		//비고
	
							rowIndex++;
							p++;
						}
					}
					
					int childIdx = childItemList.size() + 10;
					
					int n = 1;
					while (n < 6) { 					
						cellIndex = 1;
						row = sheet.createRow(rowIndex);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,2,3));
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,4,5));
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,6,8));
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);
						sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,11,12));
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);
						sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,13,15));
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,16,17));
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,18,19));
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
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
	
	@RequestMapping(value="/zEMT_TSInfoExcelReport2Zip.do") //ZRP0002 - Download TS Script
	public String zEMT_excelReportTSInfo_ORG(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception{
		HashMap target = new HashMap();
		FileOutputStream fileOutput = null;
		XSSFWorkbook wb = new XSSFWorkbook();
		try{
			Map setMap = new HashMap();
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"), "");
			String modelItemClass = StringUtil.checkNull(commandMap.get("modelItemClass"));
			String elmClass = StringUtil.checkNull(commandMap.get("elmClass"));
			String elmChildList = StringUtil.checkNull(commandMap.get("elmChildList"));
//			String elmInfoSheet = StringUtil.checkNull(commandMap.get("elmInfoSheet"));
			String elmInfoSheet = StringUtil.checkNull(commandMap.get("elmInfoSheet"), "Y");

			ArrayList sheetNameList = new ArrayList();
			int shtTmpIdx = 0;
			String sheetTmpName = "";
			String s_itemID = StringUtil.checkNull(request.getParameter("itemID"));
			setMap.put("languageID", languageID);
			setMap.put("s_itemID", s_itemID);
			commandMap.put("ItemID", s_itemID);
			// 선택한 아이템 정보
			Map selectedItemMap = commonService.select("sap_SQL.zEMT_getItemInfo", setMap); 
			
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

			
			resultSub = commonService.selectList("sap_SQL.zEMT_getElementStrInfo_gridList", setMap);
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
			
			int cellIndex;
			int rowIndex = 0;
			XSSFRow row;
		    XSSFCell cell;
			
			//sheet.setDefaultColumnWidth(3500);
			sheet.setColumnWidth((short)0,(short)300);

			// 1행
			row = sheet.createRow(rowIndex++); 
			row.setHeight((short) 200);
			
			// 2행
			row = sheet.createRow(rowIndex++);
			row.setHeight((short) 550); 
			cellIndex = 1; 
			cell = row.createCell(cellIndex); 
			cell.setCellStyle(titleStyle);  
			cell.setCellValue("■ Test 개요"); 
			sheet.addMergedRegion(new CellRangeAddress(rowIndex - 1, rowIndex - 1, 1, 3)); 
			
			// 3행
			row = sheet.createRow(rowIndex++);
			row.setHeight((short) 550);
			cellIndex = 1; 
			//sheet.addMergedRegion(new CellRangeAddress(1,1,1,9));
			sheet.addMergedRegion(new CellRangeAddress(2,2,1,2));
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Test Scenario ID");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
			sheet.addMergedRegion(new CellRangeAddress(2,2,3,4));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(selectedItemMap.get("Identifier")));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			sheet.addMergedRegion(new CellRangeAddress(2,2,5,6));
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Test Owner");
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			sheet.addMergedRegion(new CellRangeAddress(2,2,7,8));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(attrValueMap.get("AT00012"))); //Owner
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			sheet.addMergedRegion(new CellRangeAddress(2,2,9,10));
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Test Date");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
			sheet.addMergedRegion(new CellRangeAddress(2,2,11,12));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			
			//4행
			row = sheet.createRow(rowIndex++);
			row.setHeight((short) 550);
			cellIndex = 1; 
			
			sheet.addMergedRegion(new CellRangeAddress(3,3,1,2));
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Scenario Title");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
			sheet.addMergedRegion(new CellRangeAddress(3,3,3,4));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(selectedItemMap.get("ItemName")));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			sheet.addMergedRegion(new CellRangeAddress(3,3,5,6));
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Test Performer");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
			sheet.addMergedRegion(new CellRangeAddress(3,3,7,8));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			sheet.addMergedRegion(new CellRangeAddress(3,3,9,10));
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Status");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
			sheet.addMergedRegion(new CellRangeAddress(3,3,11,12));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			
			//5행
			row = sheet.createRow(rowIndex++);
			row.setHeight((short) 550);
			cellIndex = 1; 
			
			sheet.addMergedRegion(new CellRangeAddress(4,4,1,2));
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Test Category");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
			sheet.addMergedRegion(new CellRangeAddress(4,4,3,4));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			sheet.addMergedRegion(new CellRangeAddress(4,4,5,6));
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("QA(PMO/영역리더)");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
			sheet.addMergedRegion(new CellRangeAddress(4,4,7,8));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			sheet.addMergedRegion(new CellRangeAddress(4,4,9,10));
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Main Module");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
			sheet.addMergedRegion(new CellRangeAddress(4,4,11,12));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);

			
			//6행
			row = sheet.createRow(rowIndex++);
			row.setHeight((short) 550);
			cellIndex = 1; 
			
			sheet.addMergedRegion(new CellRangeAddress(5,6,1,2));
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Description");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
			sheet.addMergedRegion(new CellRangeAddress(5,6,3,8));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(selectedItemMap.get("Description")))); //개요
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			sheet.addMergedRegion(new CellRangeAddress(5,5,9,10));
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Test Time");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
			sheet.addMergedRegion(new CellRangeAddress(5,5,11,12));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			
			//7행
			row = sheet.createRow(rowIndex++);
			row.setHeight((short) 550);
			cellIndex = 1; 

			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);

			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			sheet.addMergedRegion(new CellRangeAddress(6,6,9,10));
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Test Place");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
			sheet.addMergedRegion(new CellRangeAddress(6,6,11,12));
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);

			rowIndex++;
			
			//Tast Cast Box 시작
			// 빈 행 추가
			// 제목 추가 - ■ Test 개요
			row = sheet.createRow(rowIndex++);
			row.setHeight((short) 550); 
			cellIndex = 1; 
			cell = row.createCell(cellIndex); 
			cell.setCellStyle(titleStyle);  
			cell.setCellValue("■ Test 개요"); 
			sheet.addMergedRegion(new CellRangeAddress(rowIndex - 1, rowIndex - 1, 1, 3)); 

			
			cellIndex = 1;
			row = sheet.createRow(rowIndex++);
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("No");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("구분");
			sheet.addMergedRegion(new CellRangeAddress(rowIndex - 1, rowIndex - 1, 3, 7)); 
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Test Data / Code");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
			sheet.addMergedRegion(new CellRangeAddress(rowIndex - 1, rowIndex - 1, 8, 12)); 
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle); cell.setCellValue("Remark");
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);
			cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle);

			for(int i=0; i<10; i++) {
				cellIndex = 1;
				row = sheet.createRow(rowIndex++);
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
				sheet.addMergedRegion(new CellRangeAddress(rowIndex - 1, rowIndex - 1, 3, 7)); 
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
				sheet.addMergedRegion(new CellRangeAddress(rowIndex - 1, rowIndex - 1, 8, 12)); 
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue("");
			}
			rowIndex++;
			
			//Business Process List Box 시작
			// 제목 추가 - ■ Test 개요
			row = sheet.createRow(rowIndex++);
			row.setHeight((short) 550); 
			cellIndex = 1; 
			cell = row.createCell(cellIndex); 
			cell.setCellStyle(titleStyle);  
			cell.setCellValue("■ Business Process List"); 
			sheet.addMergedRegion(new CellRangeAddress(rowIndex - 1, rowIndex - 1, 1, 3)); 

			
			cellIndex = 1;
			row = sheet.createRow(rowIndex++);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("No");
			
			sheet.addMergedRegion(new CellRangeAddress(22,22,2,3)); //(rowIndex - 1,rowIndex - 1,2,3));)
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("프로세스 ID");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
			
			sheet.addMergedRegion(new CellRangeAddress(22,22,4,5));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("클래스");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
			
			sheet.addMergedRegion(new CellRangeAddress(22,22,6,8)); 
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("프로세스 Title");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
			
			sheet.addMergedRegion(new CellRangeAddress(22,22,9,13)); 
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("개요");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
			
			sheet.addMergedRegion(new CellRangeAddress(22,22,14,15)); 
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Remark");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
			
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("주관 팀");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Owner(PI)");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Owner(ST)");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Owner(I&C)");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Owner(Con.)");

			

			int j = 23; // int j = rowIndex;
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

				sheet.addMergedRegion(new CellRangeAddress(j,j,4,5)); 
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsCenterStyle); cell.setCellValue(StringUtil.checkNull(resultSubMap.get("MyClassName")));
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsCenterStyle); 
				
				sheet.addMergedRegion(new CellRangeAddress(j,j,6,8));
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(resultSubMap.get("MyItemName")));
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);	
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);	
				
				//개요
				sheet.addMergedRegion(new CellRangeAddress(j,j,9,13));
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(removeAllTag(StringUtil.checkNull(subAttrInfoMap.get("AT00003")),"DbToEx"));
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
				
				sheet.addMergedRegion(new CellRangeAddress(j,j,14,15));
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsCenterStyle); cell.setCellValue(StringUtil.checkNull(resultSubMap.get("Remark")));
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle);
				
				
				for (int k = 0; k < 5; k++) {
			        cell = row.createCell(cellIndex++); 
			        cell.setCellStyle(contentsLeftStyle);
			    }
				
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
					
					// Sheet Sub Item 4
					//2행
					row = sheet.createRow(rowIndex++);
					row.setHeight((short) 550);
					cellIndex = 1; 

					sheet.addMergedRegion(new CellRangeAddress(1,1,1,2));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);			cell.setCellValue("ID(L4)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle); 
					sheet.addMergedRegion(new CellRangeAddress(1,1,3,4));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);	cell.setCellValue(StringUtil.checkNull(resultSubMap.get("Identifier")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle); 		cell.setCellValue("주관팀");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);	cell.setCellValue(StringUtil.checkNull(resultSubMap.get("TeamName")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);			cell.setCellValue("Owner(PI)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);	cell.setCellValue(StringUtil.checkNull(resultSubMap.get("Author")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);			cell.setCellValue("Owner(ST)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					
					// 너비 조정
					for (int col = 5; col < 11; col++) { 
					    sheet.setColumnWidth(col, (short) 3000); 
					}
					
					//3행
					row = sheet.createRow(rowIndex++);
					row.setHeight((short) 550);
					cellIndex = 1; 
					
					sheet.addMergedRegion(new CellRangeAddress(2,2,1,2));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);			cell.setCellValue("프로세스 Name");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);	
					sheet.addMergedRegion(new CellRangeAddress(2,2,3,4));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);	cell.setCellValue(StringUtil.checkNull(resultSubMap.get("MyItemName")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle); 		cell.setCellValue("Test 일자");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);			cell.setCellValue("Owner(I&C)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);			cell.setCellValue("Owner(Con.)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					
					//4행
					row = sheet.createRow(rowIndex++);
					row.setHeight((short) 550);
					cellIndex = 1; 
					
					sheet.addMergedRegion(new CellRangeAddress(3,3,1,2));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);			cell.setCellValue("프로세스 개요");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					
					sheet.addMergedRegion(new CellRangeAddress(3,3,3,10));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle); 	cell.setCellValue(removeAllTag(StringUtil.checkNull(subItemInfo.get("Description")),"DbToEx"));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					
					//5행
					row = sheet.createRow(rowIndex++);
					row.setHeight((short) 550);
					cellIndex = 1; 
					
					sheet.addMergedRegion(new CellRangeAddress(4,4,1,2));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Test Case Data");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(4,4,3,10));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					
					//6행
					row = sheet.createRow(rowIndex++);
					row.setHeight((short) 550);
					cellIndex = 1; 
					
					sheet.addMergedRegion(new CellRangeAddress(5,5,1,2));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("테스트 결과 요약");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(5,5,3,10));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					
					rowIndex++;
					
					
					
					// Sheet Sub Item 
					cellIndex = 1;
					row = sheet.createRow(rowIndex);
					rowIndex++;
					
					row = sheet.createRow(rowIndex);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle); 	cell.setCellValue("No");
					sheet.addMergedRegion(new CellRangeAddress(8,8,2,3));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Activity ID(L5)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(8,8,4,5));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Activity 명칭(L5)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(8,8,6,8));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Activity 개요");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("수행주체");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("시스템");
					sheet.addMergedRegion(new CellRangeAddress(8,8,11,12));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("T-Code or 개발ID");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(8,8,13,15));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Check Point");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(8,8,16,17));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Result Output");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					sheet.addMergedRegion(new CellRangeAddress(8,8,18,19));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Result(Ok, Error, Log)");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
					
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("발생 유형");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("이슈");
					cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("비고");

					rowIndex++;
					
					Map setData = new HashMap();
					setData.put("s_itemID", StringUtil.checkNull(resultSubMap.get("MyItemID"))); 
					setData.put("languageID", languageID); 
					List childItemList = commonService.selectList("sap_SQL.zEMT_getChildItemList_gridList", setData);

					int p = 10; // int p = rowIndex;
					if(childItemList.size()>0){
						for(int m=0; m < childItemList.size(); m++){
							Map childItemInfo = (Map)childItemList.get(m);
							
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
							//10행
							cellIndex = 1;
							row = sheet.createRow(rowIndex);
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("RNUM") ));
							sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,2,3));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("Identifier") ));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);
							sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,4,5));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("ItemName") ));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
							sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,6,8));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(removeAllTag(StringUtil.checkNull(childItemInfo.get("description")),"DbToEx"));			
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
							
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("RsEntity")));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("System")));
							sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,11,12));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("tCode")));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);
							sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,13,15));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle); 		//Check Point
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
							sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,16,17));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		//Result Output
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
							sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,18,19));
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		//Result(Ok, Error, Log)
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
							
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		//발생 유형
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		//이슈
							cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		//비고
	
							rowIndex++;
							p++;
						}
					}
					
					int childIdx = childItemList.size() + 10; //10행에서 시작
					
					int n = 1;
					while (n < 6) { 					
						cellIndex = 1;
						row = sheet.createRow(rowIndex);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,2,3));
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,4,5));
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,6,8));
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);
						sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,11,12));
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);
						sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,13,15));
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,16,17));
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,18,19));
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//						cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
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
	
	
	@RequestMapping(value="/zEMT_excelReportL4TSInfo.do") //ZRP0006 - Download L4 TS Script
	public String zEMT_excelReportL4TSInfo(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception{
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
			Map selectedItemMap = commonService.select("sap_SQL.zEMT_getItemInfo", setMap);
			
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
			
			// Sheet Sub Item 4
			//2행
			row = sheet.createRow(rowIndex++);
			row.setHeight((short) 550);
			cellIndex = 1; 
			
			sheet.addMergedRegion(new CellRangeAddress(1,1,1,2));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);			cell.setCellValue("ID(L4)");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle); 
			sheet.addMergedRegion(new CellRangeAddress(1,1,3,4));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);	cell.setCellValue(StringUtil.checkNull(subItemInfo.get("Identifier")));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle); 		cell.setCellValue("주관팀");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);	cell.setCellValue(StringUtil.checkNull(subItemInfo.get("OwnerTeamName")));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);			cell.setCellValue("Owner(PI)");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);	cell.setCellValue(StringUtil.checkNull(subItemInfo.get("AuthorName")));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);			cell.setCellValue("Owner(ST)");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			
			// 너비 조정
			for (int col = 5; col < 11; col++) { 
			    sheet.setColumnWidth(col, (short) 3000); 
			}

			//3행
			row = sheet.createRow(rowIndex++);
			row.setHeight((short) 550);
			cellIndex = 1; 
			
			sheet.addMergedRegion(new CellRangeAddress(2,2,1,2));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);			cell.setCellValue("프로세스 Name");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);	
			sheet.addMergedRegion(new CellRangeAddress(2,2,3,4));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);	cell.setCellValue(StringUtil.checkNull(subItemInfo.get("ItemName")));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle); 		cell.setCellValue("Test 일자");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);			cell.setCellValue("Owner(I&C)");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);			cell.setCellValue("Owner(Con.)");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			
			//4행
			row = sheet.createRow(rowIndex++);
			row.setHeight((short) 550);
			cellIndex = 1; 
			
			sheet.addMergedRegion(new CellRangeAddress(3,3,1,2));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);			cell.setCellValue("프로세스 개요");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
			
			sheet.addMergedRegion(new CellRangeAddress(3,3,3,10));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(removeAllTag(StringUtil.checkNull(subAttrInfoMap.get("AT00003")),"DbToEx"));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			
			//5행
			row = sheet.createRow(rowIndex++);
			row.setHeight((short) 550);
			cellIndex = 1; 
			
			sheet.addMergedRegion(new CellRangeAddress(4,4,1,2));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Test Case Data");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
			sheet.addMergedRegion(new CellRangeAddress(4,4,3,10));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			
			//6행
			row = sheet.createRow(rowIndex++);
			row.setHeight((short) 550);
			cellIndex = 1; 
			
			sheet.addMergedRegion(new CellRangeAddress(5,5,1,2));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("테스트 결과 요약");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
			sheet.addMergedRegion(new CellRangeAddress(5,5,3,10));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
			
			rowIndex++;
			
			// Sheet Sub Item 
			cellIndex = 1;
			row = sheet.createRow(rowIndex);
			rowIndex++;
			
			row = sheet.createRow(rowIndex);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle); 	cell.setCellValue("No");
			sheet.addMergedRegion(new CellRangeAddress(8,8,2,3));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Activity ID(L5)");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
			sheet.addMergedRegion(new CellRangeAddress(8,8,4,5));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Activity 명칭(L5)");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
			sheet.addMergedRegion(new CellRangeAddress(8,8,6,8));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Activity 개요");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
			
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("수행주체");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("시스템");
			sheet.addMergedRegion(new CellRangeAddress(8,8,11,12));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("T-Code or 개발ID");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
			sheet.addMergedRegion(new CellRangeAddress(8,8,13,15));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Check Point");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
			sheet.addMergedRegion(new CellRangeAddress(8,8,16,17));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Result Output");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
			sheet.addMergedRegion(new CellRangeAddress(8,8,18,19));
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("Result(Ok, Error, Log)");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);
			
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("발생 유형");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("이슈");
			cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle);		cell.setCellValue("비고");

			rowIndex++;
			
			List childItemList = commonService.selectList("sap_SQL.zEMT_getChildItemList_gridList", setMap);
			
			int p = 10;
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
					
					//10행
					cellIndex = 1;
					row = sheet.createRow(rowIndex);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("RNUM") ));
					sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,2,3));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("Identifier") ));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);
					sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,4,5));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("ItemName") ));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,6,8));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		cell.setCellValue(removeAllTag(StringUtil.checkNull(childItemInfo.get("description")),"DbToEx"));			
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("RsEntity")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("System")));
					sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,11,12));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);		cell.setCellValue(StringUtil.checkNull(childItemInfo.get("tCode")));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);
					sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,13,15));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle); 		//Check Point
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,16,17));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		//Result Output
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,18,19));
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		//Result(Ok, Error, Log)
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
					
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		//발생 유형
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		//이슈
					cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);		//비고

					rowIndex++;
					p++;
					
				}
			}
			
			int childIdx = childItemList.size() + 10;
			
			int n = 1;
			while (n < 6) { 					
				cellIndex = 1;
				row = sheet.createRow(rowIndex);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,2,3));
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,4,5));
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,6,8));
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);
				sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,11,12));
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsCenterStyle);
				sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,13,15));
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,16,17));
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				sheet.addMergedRegion(new CellRangeAddress(rowIndex,rowIndex,18,19));
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
//				cell = row.createCell(cellIndex++);		cell.setCellStyle(contentsLeftStyle);
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

	
	private XSSFCellStyle setCellTitleSyle(XSSFWorkbook wb) {
		XSSFCellStyle style = wb.createCellStyle();
//		style.setFillForegroundColor(new XSSFColor(new Color(22, 54, 92)));
//		style.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		style.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		style.setBorderLeft(XSSFCellStyle.BORDER_NONE);
		style.setBorderRight(XSSFCellStyle.BORDER_NONE);
		style.setBorderTop(XSSFCellStyle.BORDER_NONE);
		style.setVerticalAlignment(VerticalAlignment.CENTER);
		style.setAlignment(XSSFCellStyle.ALIGN_LEFT);
		
		XSSFFont font = wb.createFont();
		font.setFontHeightInPoints((short) 12);
		font.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
		font.setFontName("맑은 고딕");
		font.setColor(HSSFColor.BLACK.index);
		font.setUnderline(XSSFFont.U_SINGLE); 
		style.setFont(font);
		
		return style;
	}

	private XSSFCellStyle setCellHeaderStyle(XSSFWorkbook wb) {
		XSSFCellStyle style = wb.createCellStyle();
				
		style.setFillForegroundColor(new XSSFColor(new Color(217, 217, 217)));
		style.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		style.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		style.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		style.setBorderRight(XSSFCellStyle.BORDER_THIN);
		style.setBorderTop(XSSFCellStyle.BORDER_THIN);
		style.setVerticalAlignment(VerticalAlignment.CENTER);
		style.setAlignment(XSSFCellStyle.ALIGN_CENTER);
				
		XSSFFont font = wb.createFont();
		font.setFontHeightInPoints((short) 11);
		font.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
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

	
	
	

	
	/**
	 * Process이외 Excel 출력
	 * @param request
	 * @param commandMap
	 * @param model
	 * @param response
	 * @return
	 * @throws Exception
	 */
//	@RequestMapping(value="/zSAP_SubItemListWithElmInfo.do")
	@RequestMapping(value="/zEMT_SubItemListWithElmInfo.do")
	public String zEMT_SubItemListWithElmInfo(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception{
		
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