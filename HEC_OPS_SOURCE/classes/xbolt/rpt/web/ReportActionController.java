package xbolt.rpt.web;

import java.io.BufferedInputStream;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintStream;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeSet;
import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.text.StringEscapeUtils;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.tools.zip.ZipEntry;
import org.apache.tools.zip.ZipOutputStream;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.DRMUtil;
import xbolt.cmm.framework.util.DimTreeAdd;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.GetItemAttrList;
import xbolt.cmm.framework.util.JsonUtil;
import xbolt.cmm.framework.util.MakeWordReport;
import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.project.chgInf.web.CSActionController;

@Controller
public class ReportActionController extends XboltController
{
  private final Log _log = LogFactory.getLog(getClass());

  @Resource(name="commonService")
  private CommonService commonService;

  @Resource(name="reportService")
  private CommonService reportService;

  @Resource(name="fileMgtService")
  private CommonService fileMgtService;

  @Resource(name="CSActionController")
  private CSActionController CSActionController;
  private String valueY = "";

  @RequestMapping({"/downSubItemMasterList.do"})
  public String downSubItemMasterList(HttpServletRequest request, HashMap commandMap, ModelMap model)
    throws Exception
  {
    try
    {
      Map setMap = new HashMap();

      setMap.put("s_itemID", request.getParameter("itemID"));
      Map iteminfoMap = this.commonService.select("project_SQL.getItemInfo", setMap);

      model.put("menu", getLabel(request, this.commonService));
      model.put("s_itemID", request.getParameter("itemID"));
      model.put("ArcCode", request.getParameter("ArcCode"));
      model.put("itemTypeCode", StringUtil.checkNull(iteminfoMap.get("ItemTypeCode")));
    }
    catch (Exception e) {
      System.out.println(e.toString());
    }

    return nextUrl("/report/downSubItemMasterList");
  }

  @RequestMapping({"/hierarchStrReport.do"})
  public String hierarchStrReport(HttpServletRequest request, HashMap commandMap, ModelMap model)
    throws Exception
  {
    try
    {
      Map setMap = new HashMap();

      setMap.put("s_itemID", request.getParameter("itemID"));
      Map iteminfoMap = this.commonService.select("project_SQL.getItemInfo", setMap);

      model.put("menu", getLabel(request, this.commonService));
      model.put("s_itemID", request.getParameter("itemID"));
      model.put("ArcCode", request.getParameter("ArcCode"));
      model.put("itemTypeCode", StringUtil.checkNull(iteminfoMap.get("ItemTypeCode")));
    }
    catch (Exception e) {
      System.out.println(e.toString());
    }

    return nextUrl("/report/hierarchStrReport");
  }

  @RequestMapping({"/hierarchStrReportGridJson.do"})
  public void hierarchStrReportGridJson(HashMap commandMap, HttpServletResponse response) throws Exception
  {
    String SQL_CODE = getString(commandMap.get("menuId"), "commonCode");

    List result = this.commonService.selectList(SQL_CODE + "_gridList", commandMap);
    List attrResult = this.commonService.selectList("report_SQL.itemAttrByHierarchStr", commandMap);
    String subcol = (String)commandMap.get("subcols");

    String[] maincols = ((String)commandMap.get("cols")).replaceAll(subcol, "").split("[|]");
    String[] subcols = subcol.split("[|]");

    int totalPage = 0;

    JsonUtil.returnGridMergeJson(result, attrResult, maincols, subcols, totalPage, response, (String)commandMap.get("contextPath"));
  }

  @RequestMapping({"/hierarchStrReportExcelForPrc.do"})
  public String hierarchStrReportExcelForPrc(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response)
    throws Exception
  {
    HashMap target = new HashMap();
    FileOutputStream fileOutput = null;
    XSSFWorkbook wb = new XSSFWorkbook();
    try
    {
      Map menu = getLabel(request, this.commonService);
      String attType = StringUtil.checkNull(commandMap.get("AttrTypeCode"));
      String attrName = StringUtil.checkNull(commandMap.get("AttrName"));

      String defaultLang = this.commonService.selectString("item_SQL.getDefaultLang", commandMap);
      String selectedLang = StringUtil.checkNull(commandMap.get("languageID"));

      Map selectedItemMap = this.commonService.select("report_SQL.getItemInfo", commandMap);

      commandMap.put("attType", attType.replaceAll("&#39;", "'"));
      List comLangList = this.commonService.selectList("report_SQL.getAttrIsComLang", commandMap);
      Map comLangMap = new HashMap();

      for (int i = 0; comLangList.size() > i; i++) {
        Map map = (Map)comLangList.get(i);
        comLangMap.put(map.get("AttrTypeCode"), map.get("IsComLang"));
      }

      String[] attrTypeArray = attType.split(",");
      List attrTypeArrayList = new ArrayList();
      Map attrTypeArrayMap = new HashMap();

      for (int i = 0; attrTypeArray.length > i; i++) {
        attrTypeArrayMap = new HashMap();
        attrTypeArrayMap.put("TableName", "T" + String.valueOf(i + 10));
        attrTypeArrayMap.put("AttrNum", attrTypeArray[i].replace("'", ""));
        if ("1".equals(comLangMap.get(attrTypeArray[i].replace("'", "")).toString()))
          attrTypeArrayMap.put("LangCode", defaultLang);
        else {
          attrTypeArrayMap.put("LangCode", selectedLang);
        }
        attrTypeArrayList.add(attrTypeArrayMap);
      }

      commandMap.put("attrList", attrTypeArrayList);

      String arcCode = StringUtil.checkNull(request.getParameter("ArcCode"));
      commandMap.put("ArcCode", arcCode);
      commandMap.put("SelectMenuId", arcCode);

      String level = this.commonService.selectString("report_SQL.getItemClassLevel", commandMap);

      if ("1".equals(level))
        commandMap.put("LevelName", "L1ItemID");
      else if ("2".equals(level))
        commandMap.put("LevelName", "L2ItemID");
      else if ("3".equals(level))
        commandMap.put("LevelName", "L3ItemID");
      else if ("4".equals(level))
        commandMap.put("LevelName", "L4ItemID");
      else if ("0".equals(level)) {
        commandMap.put("LevelName", "L0ItemID");
      }

      List result = this.commonService.selectList("report_SQL.exportSubItemList", commandMap);

      XSSFSheet sheet = wb.createSheet("Item master list");
      sheet.createFreezePane(6, 2);
      XSSFCellStyle headerStyle = setCellHeaderStyle(wb);
      XSSFCellStyle contentsStyle = setCellContentsStyle(wb, "");

      int cellIndex = 0;
      int rowIndex = 0;
      XSSFRow row = sheet.createRow(rowIndex);
      row.setHeight((short) 409);
      XSSFCell cell = null;
      rowIndex++;

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

      cell = row.createCell(cellIndex);
      cell.setCellValue("AT00001");
      cell.setCellStyle(headerStyle);
      cellIndex++;

      String[] attrNameArray = attrName.split(",");

      for (int i = 0; attrTypeArray.length > i; i++) {
        cell = row.createCell(cellIndex);
        cell.setCellValue(attrTypeArray[i].replace("'", ""));
        cell.setCellStyle(headerStyle);
        cellIndex++;
      }

      cell = row.createCell(cellIndex);
      cell.setCellValue("");
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue("");
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cellIndex = 0;
      row = sheet.createRow(rowIndex);
      row.setHeight((short) 512);
      rowIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue("ItemID");
      cell.setCellStyle(headerStyle);
      cellIndex++;

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

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00106")));
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00016")));
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00028")));
      cell.setCellStyle(headerStyle);
      cellIndex++;

      for (int i = 0; attrNameArray.length > i; i++) {
        cell = row.createCell(cellIndex);
        cell.setCellValue(attrNameArray[i].replace("'", ""));
        cell.setCellStyle(headerStyle);
        cellIndex++;
      }

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00070")));
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00105")));
      cell.setCellStyle(headerStyle);
      cellIndex++;

      for (int i = 0; i < result.size(); i++) {
        cellIndex = 0;
        Map map = (Map)result.get(i);
        row = sheet.createRow(rowIndex);
        row.setHeight((short) 409);

        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("MyItemID")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;

        cell = row.createCell(cellIndex);
        cell.setCellValue(removeAllTag(StringUtil.checkNull(map.get("L1Name"))));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(removeAllTag(StringUtil.checkNull(map.get("L2Name"))));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(removeAllTag(StringUtil.checkNull(map.get("L3Name"))));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(removeAllTag(StringUtil.checkNull(map.get("L4Name"))));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;

        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("Identifier")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("MyClassName")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(removeAllTag(StringUtil.checkNull(map.get("MyItemName"))));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;

        cell = row.createCell(cellIndex);

        for (int j = 0; attrTypeArray.length > j; j++) {
          String attrType = attrTypeArray[j].replace("'", "");
          String cellValue = removeAllTag(StringUtil.checkNull(map.get(attrType)));

          cell = row.createCell(cellIndex);
          cell.setCellValue(cellValue);
          cell.setCellStyle(contentsStyle);
          cell.setCellType(1);
          sheet.autoSizeColumn(cellIndex);
          cellIndex++;
        }

        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("LastUpdated")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("LastUser")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);

        rowIndex++;
      }

      SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
      long date = System.currentTimeMillis();
      String itemName = StringUtil.checkNull(selectedItemMap.get("ItemName")).replace("/", "_");
      String selectedItemName1 = new String(itemName.getBytes("UTF-8"), "ISO-8859-1");
      String selectedItemName2 = new String(selectedItemName1.getBytes("8859_1"), "UTF-8");

      String orgFileName1 = "ITEMLIST_" + selectedItemName1 + "_" + formatter.format(Long.valueOf(date)) + ".xlsx";
      String orgFileName2 = "ITEMLIST_" + selectedItemName2 + "_" + formatter.format(Long.valueOf(date)) + ".xlsx";
      String downFile1 = FileUtil.FILE_EXPORT_DIR + orgFileName1;
      String downFile2 = FileUtil.FILE_EXPORT_DIR + orgFileName2;

      File file = new File(downFile2);
      fileOutput = new FileOutputStream(file);

      wb.write(fileOutput);

      target.put("SCRIPT", "parent.doFileDown('" + orgFileName1 + "', 'excel');parent.$('#isSubmit').remove();");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    } finally {
      if (fileOutput != null) fileOutput.close();
      wb = null;
    }

    model.addAttribute("resultMap", target);

    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  @RequestMapping({"/hierarchStrReportExcel.do"})
  public String hierarchStrReportExcel(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response)
    throws Exception
  {
    HashMap target = new HashMap();
    HashMap setMap = new HashMap();
    FileOutputStream fileOutput = null;
    XSSFWorkbook wb = new XSSFWorkbook();
    try
    {
      String linefeedYN = StringUtil.checkNull(request.getParameter("linefeedYN"));

      String arcCode = StringUtil.checkNull(request.getParameter("ArcCode"));
      commandMap.put("ArcCode", arcCode);
      commandMap.put("SelectMenuId", arcCode);
      Map arcFilterDimInfoMap = this.commonService.select("report_SQL.getArcFilterDimInfo", commandMap);
      String TreeSql = StringUtil.checkNull(arcFilterDimInfoMap.get("TreeSql"));
      commandMap.put("TreeSql", TreeSql);

      if ((TreeSql != null) && (!"".equals(TreeSql))) {
        String outPutItems = getArcDimTreeIDs(commandMap);
        commandMap.put("outPutItems", outPutItems);
      }

      commandMap.put("sessionCurrLangType", commandMap.get("languageID"));
      List result = this.commonService.selectList("report_SQL.getItemStrList_gridList", commandMap);
      Map menu = getLabel(request, this.commonService);
      String attType = StringUtil.checkNull(commandMap.get("AttrTypeCode"));
      String attrName = StringUtil.checkNull(commandMap.get("AttrName"));

      String defaultLang = StringUtil.checkNull(commandMap.get("sessionDefLanguageId"));

      Map selectedItemMap = this.commonService.select("report_SQL.getItemInfo", commandMap);

      XSSFSheet sheet = wb.createSheet("process report");
      sheet.createFreezePane(3, 2);
      XSSFCellStyle headerStyle = setCellHeaderStyle(wb);
      XSSFCellStyle contentsStyle = setCellContentsStyle(wb, "");

      int cellIndex = 0;
      int rowIndex = 0;
      XSSFRow row = sheet.createRow(rowIndex);
      row.setHeight((short) 409);
      XSSFCell cell = null;
      rowIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue("");
      cell.setCellStyle(headerStyle);

      row.setZeroHeight(true);

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

      cell = row.createCell(cellIndex);
      cell.setCellValue("AT00001");
      cell.setCellStyle(headerStyle);
      cellIndex++;

      String[] attrNameArray = attrName.split(",");
      String[] attrTypeArray = attType.split(",");

      for (int i = 0; attrTypeArray.length > i; i++) {
        cell = row.createCell(cellIndex);
        cell.setCellValue(attrTypeArray[i].replaceAll("&#39;", "").replaceAll("'", ""));
        cell.setCellStyle(headerStyle);
        cellIndex++;
      }

      cell = row.createCell(cellIndex);
      cell.setCellValue("");
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue("");
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cellIndex = 0;
      row = sheet.createRow(rowIndex);
      row.setHeight((short) 512);
      rowIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue("ItemID");
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00043")));
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00106")));
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00016")));
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00028")));
      cell.setCellStyle(headerStyle);
      cellIndex++;

      for (int i = 0; attrNameArray.length > i; i++) {
        cell = row.createCell(cellIndex);
        cell.setCellValue(attrNameArray[i].replaceAll("&#39;", "").replaceAll("'", ""));
        cell.setCellStyle(headerStyle);
        cellIndex++;
      }

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00070")));
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00105")));
      cell.setCellStyle(headerStyle);
      cellIndex++;
      String MyItemName = "";

      for (int i = 0; i < result.size(); i++) {
        cellIndex = 0;
        Map map = (Map)result.get(i);
        row = sheet.createRow(rowIndex);
        row.setHeight((short) 409);
        if (linefeedYN.equals("Y"))
          MyItemName = StringUtil.checkNull(map.get("MyItemName"));
        else {
          MyItemName = StringUtil.checkNull(map.get("MyItemName")).replaceAll("&#10;", "").replaceAll("&amp;", "&");
        }
        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("MyItemID")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("MyPath")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("Identifier")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("MyClassName")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(MyItemName);
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;

        cell = row.createCell(cellIndex);

        commandMap.put("ItemID", map.get("MyItemID"));
        commandMap.put("DefaultLang", defaultLang);

        List attrList = this.commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
        String dataType = "";
        Map setData = new HashMap();
        List mLovList = new ArrayList();
        for (int j = 0; attrTypeArray.length > j; j++) {
          String attrType = attrTypeArray[j].replaceAll("&#39;", "").replaceAll("'", "");
          String cellValue = "";

          for (int k = 0; attrList.size() > k; k++) {
            Map attrMap = (Map)attrList.get(k);
            dataType = StringUtil.checkNull(attrMap.get("DataType"));
            if (attrMap.get("AttrTypeCode").equals(attrType)) {
              String plainText = removeAllTag(StringUtil.checkNull(attrMap.get("PlainText")), "DbToEx");
              if (dataType.equals("MLOV")) {
                plainText = getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionDefLanguageId")), StringUtil.checkNull(map.get("MyItemID")), attrType);
                cellValue = plainText;
              } else {
                cellValue = plainText;
              }
            }
          }
          cell = row.createCell(cellIndex);
          cell.setCellValue(cellValue);
          cell.setCellStyle(contentsStyle);
          cell.setCellType(1);
          sheet.autoSizeColumn(cellIndex);
          cellIndex++;
        }

        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("LastUpdated")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("LastUser")));
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

      String orgFileName1 = "ITEMLIST_" + selectedItemName1 + "_" + formatter.format(Long.valueOf(date)) + ".xlsx";
      String orgFileName2 = "ITEMLIST_" + selectedItemName2 + "_" + formatter.format(Long.valueOf(date)) + ".xlsx";
      String orgFileName3 = "ITEMLIST_" + itemName + "_" + formatter.format(Long.valueOf(date)) + ".xlsx";
      String downFile1 = FileUtil.FILE_EXPORT_DIR + orgFileName1;
      String downFile2 = FileUtil.FILE_EXPORT_DIR + orgFileName2;
      String downFile3 = FileUtil.FILE_EXPORT_DIR + orgFileName3;

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
      drmInfoMap.put("downFile", downFile3);

      String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
      String useDownDRM = "";
      if ((!"".equals(useDRM)) && (!"N".equals(useDownDRM))) {
        drmInfoMap.put("funcType", "report");
        DRMUtil.drmMgt(drmInfoMap);
      }

      target.put("SCRIPT", "parent.doFileDown('" + orgFileName3 + "', 'excel');parent.$('#isSubmit').remove();");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    } finally {
      if (fileOutput != null) fileOutput.close();
      wb = null;
    }

    model.addAttribute("resultMap", target);

    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  @RequestMapping({"/downLoadItemMultiLanguageExcelReport.do"})
  public String downLoadItemMultiLanguageExcelReport(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception
  {
    HashMap target = new HashMap();
    HashMap setMap = new HashMap();
    FileOutputStream fileOutput = null;
    XSSFWorkbook wb = new XSSFWorkbook();
    try
    {
      String linefeedYN = StringUtil.checkNull(request.getParameter("linefeedYN"));

      String arcCode = StringUtil.checkNull(request.getParameter("ArcCode"));
      commandMap.put("ArcCode", arcCode);
      commandMap.put("SelectMenuId", arcCode);
      Map arcFilterDimInfoMap = this.commonService.select("report_SQL.getArcFilterDimInfo", commandMap);
      String TreeSql = StringUtil.checkNull(arcFilterDimInfoMap.get("TreeSql"));
      commandMap.put("TreeSql", TreeSql);

      if ((TreeSql != null) && (!"".equals(TreeSql))) {
        String outPutItems = getArcDimTreeIDs(commandMap);
        commandMap.put("outPutItems", outPutItems);
      }

      commandMap.put("sessionCurrLangType", commandMap.get("languageID"));
      List result = this.commonService.selectList("report_SQL.getItemStrList_gridList", commandMap);
      Map menu = getLabel(request, this.commonService);
      String attType = StringUtil.checkNull(commandMap.get("AttrTypeCode"));
      String attrName = StringUtil.checkNull(commandMap.get("AttrName"));

      String selectLanguageID = StringUtil.checkNull(commandMap.get("selectLanguageID"));
      String sessionCurrLangCode = StringUtil.checkNull(commandMap.get("sessionCurrLangCode"));

      Map setData = new HashMap();
      setData.put("attrTypeCodes", attType);
      setData.put("LanguageID", selectLanguageID);
      setData.put("languageID", selectLanguageID);
      String selectLanguageCode = StringUtil.checkNull(this.commonService.selectString("common_SQL.getLanguageCode", setData));
      List selectLangAttrNameList = this.commonService.selectList("attr_SQL.getAttrName", setData);

      String defaultLang = StringUtil.checkNull(commandMap.get("sessionDefLanguageId"));

      Map selectedItemMap = this.commonService.select("report_SQL.getItemInfo", commandMap);

      XSSFSheet sheet = wb.createSheet("process report");
      sheet.createFreezePane(3, 2);
      XSSFCellStyle headerStyle = setCellHeaderStyle(wb);
      XSSFCellStyle contentsStyle = setCellContentsStyle(wb, "");

      int cellIndex = 0;
      int rowIndex = 0;
      XSSFRow row = sheet.createRow(rowIndex);
      row.setHeight((short) 409);
      XSSFCell cell = null;
      rowIndex++;

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
      cell.setCellValue("AT00001");
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue("AT00001");
      cell.setCellStyle(headerStyle);
      cellIndex++;

      String[] attrNameArray = attrName.split(",");
      String[] attrTypeArray = attType.split(",");

      for (int i = 0; attrTypeArray.length > i; i++)
      {
        cell = row.createCell(cellIndex);
        cell.setCellValue(attrTypeArray[i].replaceAll("&#39;", "").replaceAll("'", ""));
        cell.setCellStyle(headerStyle);
        cellIndex++;

        cell = row.createCell(cellIndex);
        cell.setCellValue(attrTypeArray[i].replaceAll("&#39;", "").replaceAll("'", ""));
        cell.setCellStyle(headerStyle);
        cellIndex++;
      }

      cell = row.createCell(cellIndex);
      cell.setCellValue("");
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue("");
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cellIndex = 0;
      row = sheet.createRow(rowIndex);
      row.setHeight((short) 512);
      rowIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue("ItemID");
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00043")));
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00106")));
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00016")));
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00028")) + "(" + sessionCurrLangCode + ")");
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00028")) + "(" + selectLanguageCode + ")");
      cell.setCellStyle(headerStyle);
      cellIndex++;

      for (int i = 0; attrNameArray.length > i; i++)
      {
        cell = row.createCell(cellIndex);
        cell.setCellValue(attrNameArray[i].replaceAll("&#39;", "").replaceAll("'", "") + "(" + sessionCurrLangCode + ")");
        cell.setCellStyle(headerStyle);
        cellIndex++;

        setData = new HashMap();
        setData.put("languageID", selectLanguageID);
        setData.put("typeCode", attrTypeArray[i].replaceAll("'", ""));
        setData.put("category", "AT");
        String selectLanguageAttrTypeName = StringUtil.checkNull(this.commonService.selectString("common_SQL.getNameFromDic", setData));

        cell = row.createCell(cellIndex);
        cell.setCellValue(selectLanguageAttrTypeName + "(" + selectLanguageCode + ")");
        cell.setCellStyle(headerStyle);
        cellIndex++;
      }

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00070")));
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00105")));
      cell.setCellStyle(headerStyle);
      cellIndex++;
      String MyItemName = "";

      for (int i = 0; i < result.size(); i++) {
        cellIndex = 0;
        Map map = (Map)result.get(i);
        row = sheet.createRow(rowIndex);
        row.setHeight((short) 409);

        MyItemName = StringUtil.checkNull(map.get("MyItemName")).replaceAll("&#10;", "").replaceAll("&amp;", "&");
        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("MyItemID")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("MyPath")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("Identifier")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("MyClassName")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;

        cell = row.createCell(cellIndex);
        cell.setCellValue(MyItemName);
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;

        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("SelectLanguageMyItemName")).replaceAll("&#10;", "").replaceAll("&amp;", "&"));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;

        cell = row.createCell(cellIndex);

        commandMap.put("ItemID", map.get("MyItemID"));
        commandMap.put("DefaultLang", defaultLang);

        List attrList = this.commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
        String dataType = "";
        setData = new HashMap();
        List mLovList = new ArrayList();
        for (int j = 0; attrTypeArray.length > j; j++) {
          String attrType = attrTypeArray[j].replaceAll("&#39;", "").replaceAll("'", "");
          String cellValue = ""; String cellValue2 = "";

          for (int k = 0; attrList.size() > k; k++) {
            Map attrMap = (Map)attrList.get(k);
            dataType = StringUtil.checkNull(attrMap.get("DataType"));
            if (attrMap.get("AttrTypeCode").equals(attrType)) {
              String plainText = removeAllTag(StringUtil.checkNull(attrMap.get("PlainText")), "DbToEx");
              String plainText2 = removeAllTag(StringUtil.checkNull(attrMap.get("PlainText2")), "DbToEx");
              if (dataType.equals("MLOV")) {
                plainText = getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionDefLanguageId")), StringUtil.checkNull(map.get("MyItemID")), attrType);
                plainText2 = getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionDefLanguageId")), StringUtil.checkNull(map.get("MyItemID")), attrType);
                cellValue = plainText; cellValue2 = plainText2;
              } else {
                cellValue = plainText; cellValue2 = plainText2;
              }
            }
          }
          cell = row.createCell(cellIndex);
          cell.setCellValue(cellValue);
          cell.setCellStyle(contentsStyle);
          cell.setCellType(1);
          sheet.autoSizeColumn(cellIndex);
          cellIndex++;

          cell = row.createCell(cellIndex);
          cell.setCellValue(cellValue2);
          cell.setCellStyle(contentsStyle);
          cell.setCellType(1);
          sheet.autoSizeColumn(cellIndex);
          cellIndex++;
        }

        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("LastUpdated")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("LastUser")));
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

      String orgFileName1 = "ITEMLIST_" + selectedItemName1 + "_" + formatter.format(Long.valueOf(date)) + ".xlsx";
      String orgFileName2 = "ITEMLIST_" + selectedItemName2 + "_" + formatter.format(Long.valueOf(date)) + ".xlsx";
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

      String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
      String useDownDRM = "";
      if ((!"".equals(useDRM)) && (!"N".equals(useDownDRM))) {
        drmInfoMap.put("funcType", "report");
        DRMUtil.drmMgt(drmInfoMap);
      }
      target.put("SCRIPT", "parent.doFileDown('" + orgFileName1 + "', 'excel');parent.$('#isSubmit').remove();");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    } finally {
      if (fileOutput != null) fileOutput.close();
      wb = null;
    }

    model.addAttribute("resultMap", target);

    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  @RequestMapping({"/cNListReportExcel.do"})
  public String cNListReportExcel(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response)
    throws Exception
  {
    HashMap target = new HashMap();
    HashMap setMap = new HashMap();
    FileOutputStream fileOutput = null;
    XSSFWorkbook wb = new XSSFWorkbook();
    try
    {
      List result = this.commonService.selectList("report_SQL.selectCNItemList", commandMap);
      Map menu = getLabel(request, this.commonService);
      String attType = StringUtil.checkNull(commandMap.get("AttrTypeCode"));
      String attrName = StringUtil.checkNull(commandMap.get("AttrName"));

      String defaultLang = this.commonService.selectString("item_SQL.getDefaultLang", commandMap);
      String selectedLang = StringUtil.checkNull(commandMap.get("languageID"));

      Map selectedItemMap = this.commonService.select("report_SQL.getItemInfo", commandMap);

      List comLangList = null;
      Map comLangMap = new HashMap();
      if (!attType.equals("")) {
        commandMap.put("attType", attType);
        comLangList = this.commonService.selectList("report_SQL.getAttrIsComLang", commandMap);
        for (int i = 0; comLangList.size() > i; i++) {
          Map map = (Map)comLangList.get(i);
          comLangMap.put(map.get("AttrTypeCode"), map.get("IsComLang"));
        }
      }

      String[] attrTypeArray = null;
      if (!attType.equals("")) {
        attrTypeArray = attType.split(",");

        List attrTypeArrayList = new ArrayList();
        Map attrTypeArrayMap = new HashMap();

        for (int i = 0; attrTypeArray.length > i; i++) {
          attrTypeArrayMap = new HashMap();
          attrTypeArrayMap.put("TableName", "T" + String.valueOf(i + 10));
          attrTypeArrayMap.put("AttrNum", attrTypeArray[i].replace("'", ""));
          if ("1".equals(comLangMap.get(attrTypeArray[i].replace("'", "")).toString()))
            attrTypeArrayMap.put("LangCode", defaultLang);
          else {
            attrTypeArrayMap.put("LangCode", selectedLang);
          }
          attrTypeArrayList.add(attrTypeArrayMap);
        }

        commandMap.put("attrList", attrTypeArrayList);
      }

      XSSFSheet sheet = wb.createSheet("Connection report");
      sheet.createFreezePane(7, 2);
      XSSFCellStyle headerStyle = setCellHeaderStyle(wb);
      XSSFCellStyle contentsStyle = setCellContentsStyle(wb, "");

      int cellIndex = 0;
      int rowIndex = 0;
      XSSFRow row = sheet.createRow(rowIndex);
      row.setHeight((short) 409);
      XSSFCell cell = null;
      rowIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue("");
      cell.setCellStyle(headerStyle);
      cellIndex++;
      cell = row.createCell(cellIndex);
      cell.setCellValue("From");
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
      cell.setCellValue("To");
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

      if (!attType.equals("")) {
        for (int i = 0; attrTypeArray.length > i; i++) {
          cell = row.createCell(cellIndex);
          cell.setCellValue(attrTypeArray[i].replace("'", ""));
          cell.setCellStyle(headerStyle);
          cellIndex++;
        }

      }

      cellIndex = 0;
      row = sheet.createRow(rowIndex);
      row.setHeight((short) 512);
      rowIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue("Connection ID");
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue("Identifier");
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue("Name");
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue("Path");
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue("Identifier");
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue("Name");
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue("Path");
      cell.setCellStyle(headerStyle);
      cellIndex++;

      String[] attrNameArray = null;
      if (!attrName.equals("")) {
        attrNameArray = attrName.split(",");
        for (int i = 0; attrNameArray.length > i; i++) {
          cell = row.createCell(cellIndex);
          cell.setCellValue(attrNameArray[i].replace("'", ""));
          cell.setCellStyle(headerStyle);
          cellIndex++;
        }

      }

      for (int i = 0; i < result.size(); i++) {
        cellIndex = 0;
        Map map = (Map)result.get(i);
        row = sheet.createRow(rowIndex);
        row.setHeight((short) 409);

        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("ConnctionID")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;

        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("FromIdentifier")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("FromItemName")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("FromItemPath")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;

        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("ToIdentifier")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("ToItemName")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("ToItemPath")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;

        commandMap.put("ItemID", map.get("ConnctionID"));
        commandMap.put("DefaultLang", defaultLang);

        List attrList = this.commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
        if (!attType.equals("")) {
          for (int j = 0; attrTypeArray.length > j; j++) {
            String attrType = attrTypeArray[j].replace("'", "");
            String cellValue = "";

            for (int k = 0; attrList.size() > k; k++) {
              Map attrMap = (Map)attrList.get(k);
              if (attrMap.get("AttrTypeCode").equals(attrType)) {
                String plainText = removeAllTag(StringUtil.checkNullToBlank(attrMap.get("PlainText")));
                cellValue = plainText;
              }
            }

            cell = row.createCell(cellIndex);
            cell.setCellValue(cellValue);
            cell.setCellStyle(contentsStyle);
            cell.setCellType(1);
            sheet.autoSizeColumn(cellIndex);
            cellIndex++;
          }
        }
        rowIndex++;
      }

      SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
      long date = System.currentTimeMillis();
      String itemName = StringUtil.checkNull(selectedItemMap.get("ItemName")).replace("/", "_");
      String selectedItemName1 = new String(itemName.getBytes("UTF-8"), "ISO-8859-1");
      String selectedItemName2 = new String(selectedItemName1.getBytes("8859_1"), "UTF-8");

      String orgFileName1 = "ITEM MAPPING " + selectedItemName1 + "_" + formatter.format(Long.valueOf(date)) + ".xlsx";
      String orgFileName2 = "ITEM MAPPING " + selectedItemName2 + "_" + formatter.format(Long.valueOf(date)) + ".xlsx";
      String downFile1 = FileUtil.FILE_EXPORT_DIR + orgFileName1;
      String downFile2 = FileUtil.FILE_EXPORT_DIR + orgFileName2;

      File file = new File(downFile2);
      fileOutput = new FileOutputStream(file);

      wb.write(fileOutput);

      target.put("SCRIPT", "parent.doFileDown('" + orgFileName1 + "', 'excel');parent.$('#isSubmit').remove();");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    } finally {
      if (fileOutput != null) fileOutput.close();
      wb = null;
    }

    model.addAttribute("resultMap", target);

    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  @RequestMapping({"/downloadCNCount.do"})
  public String downloadCNCount(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
    Map setMap = new HashMap();
    Map reqMap = new HashMap();

    String url = "/report/downloadCNCount";
    List toItemList = new ArrayList();
    List attrLovList = new ArrayList();
    String attrTypeName = "";
    try
    {
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

      String childItems = getRowLankItemList(s_itemID);
      String isNothingLowLank = "";
      if (childItems.isEmpty()) {
        isNothingLowLank = "Y";
      }

      setMap.put("childItems", childItems);
      setMap.put("isNothingLowLank", isNothingLowLank);
      toItemList = this.commonService.selectList("report_SQL.getToItemList", setMap);

      if (!attrTypeCode.isEmpty()) {
        attrLovList = this.commonService.selectList("report_SQL.selectAttrLovList", setMap);
        attrTypeName = this.commonService.selectString("report_SQL.getAttrName", setMap);
      }
      String treeItemTypeName = this.commonService.selectString("common_SQL.getNameFromDic", setMap);
      Map fromToItemName = this.commonService.select("report_SQL.getFromToItemName", setMap);

      String relatedItemTypeName = "";
      if (!treeItemTypeName.equals(StringUtil.checkNull(fromToItemName.get("FromItemType"))))
        relatedItemTypeName = StringUtil.checkNull(fromToItemName.get("FromItemType"));
      else {
        relatedItemTypeName = StringUtil.checkNull(fromToItemName.get("ToItemType"));
      }

      String xmlFilName = "doc/tmp/CNCountList.xml";

      File dirFile = new File(filepath + "doc/tmp/");
      if (!dirFile.exists()) {
        dirFile.mkdirs();
      }

      File oldFile = new File(filepath + xmlFilName);
      if (oldFile.exists()) {
        oldFile.delete();
      }
      setCNCountXmlData(filepath, toItemList, attrLovList, languageID, xmlFilName, request);

      model.put("xmlFilName", xmlFilName);

      String attachHeader1 = "";
      String header = "";
      String widths = "";
      String sorting = "";
      String aligns = "";
      if (attrLovList.size() > 0) {
        for (int i = 0; i < attrLovList.size(); i++) {
          Map attrLovValue = (Map)attrLovList.get(i);
          attachHeader1 = attachHeader1 + "," + StringUtil.checkNull(attrLovValue.get("Value"));
          if (i == 0)
            header = "," + attrTypeName;
          else {
            header = header + ",#cspan";
          }
        }

        attachHeader1 = attachHeader1 + ",N/A,Total";
        widths = widths + ",80,80";
        sorting = sorting + ",str,str";
        aligns = aligns + ",center,center";
      } else {
        attachHeader1 = ",Total";
        widths = ",80";
        sorting = ",str";
        aligns = ",center";
      }

      model.put("header", header);
      model.put("attachHeader1", attachHeader1);
      model.put("widths", widths);
      model.put("sorting", sorting);
      model.put("aligns", aligns);
      model.put("treeItemTypeCode", treeItemTypeCode);
      model.put("treeItemTypeName", treeItemTypeName);
      model.put("relatedItemTypeName", relatedItemTypeName);
      model.put("lovSize", Integer.valueOf(attrLovList.size()));
      model.put("menu", getLabel(request, this.commonService));

      model.put("s_itemID", s_itemID);
      model.put("CNTypeCode", cNType);
      model.put("itemClassCode", itemClassCode);
      model.put("attrTypeCode", attrTypeCode);
      model.put("totalCnt", Integer.valueOf(toItemList.size()));
    }
    catch (Exception e) {
      System.out.println(e);
    }
    return nextUrl(url);
  }

  private String getRowLankItemList(String s_itemID) throws Exception {
    String outPutItems = "";
    List delItemIdList = new ArrayList();
    List list = new ArrayList();
    Map map = new HashMap();
    Map setMap = new HashMap();

    String itemId = s_itemID;
    setMap.put("ItemID", itemId);

    int j = 1;
    while (j != 0) {
      String toItemId = "";

      setMap.put("CURRENT_ITEM", itemId);
      setMap.put("CategoryCode", "ST1");

      list = this.commonService.selectList("report_SQL.getChildItems", setMap);
      j = list.size();
      for (int k = 0; list.size() > k; k++) {
        map = (Map)list.get(k);
        setMap.put("ItemID", map.get("ToItemID"));
        delItemIdList.add(map.get("ToItemID"));

        if (k == 0)
          toItemId = "'" + String.valueOf(map.get("ToItemID")) + "'";
        else {
          toItemId = toItemId + ",'" + String.valueOf(map.get("ToItemID")) + "'";
        }
      }

      itemId = toItemId;
    }

    outPutItems = "";
    for (int i = 0; delItemIdList.size() > i; i++)
    {
      if (outPutItems.isEmpty())
        outPutItems = outPutItems + delItemIdList.get(i);
      else {
        outPutItems = outPutItems + "," + delItemIdList.get(i);
      }
    }
    return outPutItems;
  }

  private void setCNCountXmlData(String filepath, List toItemList, List attrLovList, String langaugeID, String xmlFilName, HttpServletRequest request) throws Exception {
    Map setMap = new HashMap();

    List toItemResultList = new ArrayList();
    Map countMap = new HashMap();

    String attrTypeCode = StringUtil.checkNull(request.getParameter("attrTypeCode"), "");
    String cNType = StringUtil.checkNull(request.getParameter("itemTypeCode"), "");
    setMap.put("attrTypeCode", attrTypeCode);
    setMap.put("cNType", cNType);

    String attrDataType = "";
    if (!attrTypeCode.equals("")) {
      attrDataType = this.commonService.selectString("report_SQL.getAttrDataType", setMap);
    }

    for (int i = 0; i < toItemList.size(); i++) {
      Map rowMap = new HashMap();
      Map toItemMap = (Map)toItemList.get(i);

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

    DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
    DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

    Document doc = docBuilder.newDocument();
    Element rootElement = doc.createElement("rows");
    doc.appendChild(rootElement);

    int rowId = 1;
    for (int i = 0; i < toItemResultList.size(); i++)
    {
      Element row = doc.createElement("row");
      rootElement.appendChild(row);
      row.setAttribute("id", String.valueOf(rowId));
      rowId++;

      Map toItemRowMap = (Map)toItemResultList.get(i);

      Element cell = doc.createElement("cell");
      cell.appendChild(doc.createTextNode((String)toItemRowMap.get("identifier")));
      cell.setAttribute("style", "text-align:left;");
      row.appendChild(cell);

      cell = doc.createElement("cell");
      cell.appendChild(doc.createTextNode((String)toItemRowMap.get("itemName")));
      row.appendChild(cell);

      cell = doc.createElement("cell");
      cell.appendChild(doc.createTextNode((String)toItemRowMap.get("path")));
      row.appendChild(cell);

      cell = doc.createElement("cell");
      cell.appendChild(doc.createTextNode((String)toItemRowMap.get("itemID")));
      row.appendChild(cell);

      int alocationTotal = 0;
      if (attrDataType.equals("LOV")) {
        for (int j = 0; j < attrLovList.size(); j++) {
          Map lovMap = (Map)attrLovList.get(j);
          setMap.put("lovCode", lovMap.get("LovCode"));
          setMap.put("itemID", toItemRowMap.get("itemID"));
          setMap.put("languageID", langaugeID);
          setMap.put("cNType", cNType);
          String attrCnt = this.commonService.selectString("report_SQL.getLovCount", setMap);

          cell = doc.createElement("cell");
          cell.appendChild(doc.createTextNode(attrCnt));
          row.appendChild(cell);
          alocationTotal += Integer.parseInt(attrCnt);
        }

        setMap.remove("lovCode");
        setMap.put("itemID", toItemRowMap.get("itemID"));
        setMap.put("languageID", langaugeID);
        setMap.put("cNType", cNType);
        String attrCnt = this.commonService.selectString("report_SQL.getLovCount", setMap);

        cell = doc.createElement("cell");
        cell.appendChild(doc.createTextNode(StringUtil.checkNull(Integer.valueOf(Integer.parseInt(attrCnt) - alocationTotal))));
        row.appendChild(cell);

        cell = doc.createElement("cell");
        cell.appendChild(doc.createTextNode(attrCnt));
        row.appendChild(cell);
      } else {
        setMap.remove("lovCode");
        setMap.put("itemID", toItemRowMap.get("itemID"));
        setMap.put("languageID", langaugeID);
        setMap.put("cNType", cNType);
        String attrCnt = this.commonService.selectString("report_SQL.getConnCount", setMap);
        cell = doc.createElement("cell");
        cell.appendChild(doc.createTextNode(attrCnt));
        row.appendChild(cell);
      }

    }

    TransformerFactory transformerFactory = TransformerFactory.newInstance();
    Transformer transformer = transformerFactory.newTransformer();

    transformer.setOutputProperty("encoding", "UTF-8");
    transformer.setOutputProperty("indent", "yes");
    DOMSource source = new DOMSource(doc);

    StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + xmlFilName)));
    transformer.transform(source, result);
  }

  private String getArcDimTreeIDs(HashMap commandMap)
    throws Exception
  {
    String result = "";
    String TreeSql = StringUtil.checkNull(commandMap.get("TreeSql"));

    List arcDimTreeIdList = this.commonService.selectList(TreeSql, commandMap);

    for (int i = 0; arcDimTreeIdList.size() > i; i++) {
      Map map = (Map)arcDimTreeIdList.get(i);
      String treeId = String.valueOf(map.get("TREE_ID"));
      if (result.isEmpty())
        result = treeId;
      else {
        result = result + "," + treeId;
      }
    }

    return result;
  }

  private String getRowLankItemList(String[] arrayStr, Map arcFilterDimInfoMap, String s_itemID)
    throws Exception
  {
    String outPutItems = "";
    List delItemIdList = new ArrayList();
    List list = new ArrayList();
    Map map = new HashMap();
    Map setMap = new HashMap();

    setMap.put("DimTypeID", arcFilterDimInfoMap.get("DimTypeID"));
    setMap.put("DimValueID", arcFilterDimInfoMap.get("DefDimValueID"));

    for (int i = 0; i < arrayStr.length; i++) {
      String itemId = arrayStr[i];
      setMap.put("ItemID", itemId);

      delItemIdList.add(itemId);

      int j = 1;
      while (j != 0) {
        String toItemId = "";

        setMap.put("CURRENT_ITEM", itemId);
        setMap.put("CategoryCode", "ST1");
        list = this.commonService.selectList("report_SQL.getChildItems", setMap);
        j = list.size();
        for (int k = 0; list.size() > k; k++) {
          map = (Map)list.get(k);
          setMap.put("ItemID", map.get("ToItemID"));

          delItemIdList.add(map.get("ToItemID"));

          if (k == 0)
            toItemId = "'" + String.valueOf(map.get("ToItemID")) + "'";
          else {
            toItemId = toItemId + ",'" + String.valueOf(map.get("ToItemID")) + "'";
          }
        }

        itemId = toItemId;
      }

    }

    outPutItems = s_itemID;
    for (int i = 0; delItemIdList.size() > i; i++) {
      outPutItems = outPutItems + "," + delItemIdList.get(i);
    }

    return outPutItems;
  }

  @RequestMapping({"/delLowLankItem.do"})
  public String delLowLankItem(HttpServletRequest request, HashMap commandMap, ModelMap model)
    throws Exception
  {
    HashMap target = new HashMap();
    try
    {
      String itemId = StringUtil.checkNull(request.getParameter("itemID"));
      String returnItem = GetItemAttrList.delItem(this.commonService, itemId);

      if (returnItem.equals("N")) {
        target.put("ALERT", itemId + MessageHandler.getMessage(new StringBuilder().append(commandMap.get("sessionCurrLangCode")).append(".WM00148").toString()));
      } else {
        target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069"));
        if (StringUtil.checkNull(request.getParameter("kbn")).isEmpty())
          target.put("SCRIPT", "window.opener.urlReload();this.$('#isSubmit').remove();");
        else
          target.put("SCRIPT", "parent.fnRefreshTree('" + returnItem + "',true);\tparent.fnGetItemClassMenuURL('" + returnItem + "');this.$('#isSubmit').remove();");
      }
    }
    catch (Exception e)
    {
      System.out.println(e);
      target.put("SCRIPT", "this.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  @RequestMapping({"/delSubItemMasterList.do"})
  public String delSubItemMasterList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    try
    {
      String itemId = StringUtil.checkNull(request.getParameter("itemID"));
      String returnItem = GetItemAttrList.delItem(this.commonService, itemId);

      if (returnItem.equals("N")) {
        target.put("ALERT", itemId + MessageHandler.getMessage(new StringBuilder().append(commandMap.get("sessionCurrLangCode")).append(".WM00148").toString()));
      } else {
        target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069"));
        if (StringUtil.checkNull(request.getParameter("kbn")).isEmpty())
          target.put("SCRIPT", "window.opener.urlReload();this.$('#isSubmit').remove();");
        else
          target.put("SCRIPT", "parent.fnRefreshTree('" + returnItem + "',true);\tparent.fnGetItemClassMenuURL('" + returnItem + "');this.$('#isSubmit').remove();");
      }
    }
    catch (Exception e)
    {
      System.out.println(e);
      target.put("SCRIPT", "this.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  private XSSFCellStyle setCellHeaderStyle(XSSFWorkbook wb)
  {
    XSSFCellStyle style = wb.createCellStyle();

    style.setBorderBottom((short) 1);
    style.setBottomBorderColor(IndexedColors.GREY_80_PERCENT.getIndex());
    style.setBorderLeft((short) 1);
    style.setLeftBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
    style.setBorderRight((short) 1);
    style.setRightBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
    style.setBorderTop((short) 1);
    style.setTopBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
    style.setAlignment(HorizontalAlignment.CENTER);
    style.setVerticalAlignment(VerticalAlignment.CENTER);

    style.setFillForegroundColor((short) 44);
    style.setFillBackgroundColor((short) 44);
    style.setFillPattern((short) 1);

    XSSFFont font = wb.createFont();
    font.setFontHeightInPoints((short) 9);
    font.setBoldweight((short) 700);
    font.setFontName("Arial");

    style.setFont(font);

    return style;
  }

  private XSSFCellStyle setCellContentsStyle(XSSFWorkbook wb, String color)
  {
    XSSFCellStyle style = wb.createCellStyle();

    style.setBorderBottom((short) 1);
    style.setBottomBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
    style.setBorderLeft((short) 1);
    style.setLeftBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
    style.setBorderRight((short) 1);
    style.setRightBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
    style.setBorderTop((short) 1);
    style.setTopBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
    style.setVerticalAlignment(VerticalAlignment.CENTER);

    if (color.equals("LIGHT_BLUE")) {
      style.setFillBackgroundColor((short) 48);
      style.setFillForegroundColor((short) 48);
      style.setFillPattern((short) 1);
    } else if (color.equals("LIGHT_CORNFLOWER_BLUE")) {
      style.setFillBackgroundColor((short) 31);
      style.setFillForegroundColor((short) 31);
      style.setFillPattern((short) 1);
    } else if (color.equals("LIGHT_GREEN")) {
      style.setFillBackgroundColor((short) 42);
      style.setFillForegroundColor((short) 42);
      style.setFillPattern((short) 1);
    }

    XSSFFont font = wb.createFont();
    font.setFontHeightInPoints((short) 10);
    font.setFontName("Arial");

    style.setFont(font);

    return style;
  }

  @RequestMapping({"/dimensionReport.do"})
  public String dimensionReport(HttpServletRequest request, HashMap commandMap, ModelMap model)
    throws Exception
  {
    List itemTypeCodeList = this.commonService.selectList("report_SQL.getItemTypeCodeFromItemDim", commandMap);

    model.put("dimTypeID", request.getParameter("itemID"));
    model.put("itemTypeCodeList", itemTypeCodeList);
    model.put("menu", getLabel(request, this.commonService));

    return nextUrl("/report/dimensionReport");
  }

  @RequestMapping({"/getDimensionInfo.do"})
  public String getDimensionInfo(HttpServletRequest request, HashMap commandMap, ModelMap model)
    throws Exception
  {
    try
    {
      Map resultMap = new HashMap();

      String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"));
      String dimTypeID = StringUtil.checkNull(request.getParameter("dimTypeID"));
      commandMap.put("ItemTypeCode", itemTypeCode);
      commandMap.put("DimTypeID", dimTypeID);
      List dimInfoList = this.commonService.selectList("report_SQL.getDimInfoWithItemTypeCode", commandMap);

      String dimValueName = "";
      String dimValueId = "";

      for (int i = 0; i < dimInfoList.size(); i++) {
        Map map = (Map)dimInfoList.get(i);
        if (i == 0)
          dimValueId = StringUtil.checkNull(map.get("DimValueID"));
        else {
          dimValueId = dimValueId + "," + StringUtil.checkNull(map.get("DimValueID"));
        }

        dimValueName = dimValueName + "," + StringUtil.checkNull(map.get("DimValueName"));
      }

      resultMap.put("SCRIPT", "doSearchList('" + dimValueName + "', '" + dimValueId + "'," + dimInfoList.size() + ")");
      model.addAttribute("resultMap", resultMap);
    } catch (Exception e) {
      System.out.println(e.toString());
    }
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  @RequestMapping({"/dimensionReportGridJson.do"})
  public void dimensionReportGridJson(HashMap commandMap, HttpServletResponse response)
    throws Exception
  {
    List list = new ArrayList();
    Map jsonMap = new HashMap();
    int rnum = 1;
    int dimIdCnt = 1;
    String codeId = "";

    List<Map> dimValueProcessInfoList = this.commonService.selectList("report_SQL.itemDimValueProcessInfo", commandMap);
    String[] dimValueIds = StringUtil.checkNull(commandMap.get("ID")).replaceAll("'", "").split(",");

    for (Map dimValueProcessInfoMap : dimValueProcessInfoList) {
      if (codeId.isEmpty()) {
        codeId = String.valueOf(dimValueProcessInfoMap.get("CodeID"));
        jsonMap = new HashMap();
      }
      else if (!codeId.equals(String.valueOf(dimValueProcessInfoMap.get("CodeID")))) {
        list.add(jsonMap);
        rnum++;
        codeId = String.valueOf(dimValueProcessInfoMap.get("CodeID"));
        jsonMap = new HashMap();
      }

      jsonMap.put("RNUM", Integer.valueOf(rnum));
      jsonMap.put("Identifier", dimValueProcessInfoMap.get("Identifier"));
      jsonMap.put("ItemName", dimValueProcessInfoMap.get("ItemName"));
      jsonMap.put("Path", dimValueProcessInfoMap.get("Path"));
      jsonMap.put("ClassName", dimValueProcessInfoMap.get("ClassName"));
      for (int i = 0; i < dimValueIds.length; i++) {
        if (dimValueIds[i].equals(dimValueProcessInfoMap.get("DimValueID"))) {
          jsonMap.put("DimValueName" + String.valueOf(i + 1), "1");
        }
      }
    }

    list.add(jsonMap);

    String[] cols = ((String)commandMap.get("cols")).split("[|]");
    JsonUtil.returnGridJson(list, cols, response, (String)commandMap.get("contextPath"));
  }

  @RequestMapping({"/wordReport.do"})
  public String wordReport(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response)
    throws Exception
  {
    Map target = new HashMap();

    String url = "/custom/base/report/wordExport_base";
    if (!StringUtil.checkNull(commandMap.get("URL")).equals("")) url = "/" + StringUtil.checkNull(commandMap.get("URL")); try
    {
      Map setMap = new HashMap();
      String languageId = String.valueOf(commandMap.get("sessionCurrLangType"));
      String delItemsYN = StringUtil.checkNull(commandMap.get("delItemsYN"));
      setMap.put("languageID", languageId);
      setMap.put("langCode", StringUtil.checkNull(commandMap.get("sessionCurrLangCode")).toUpperCase());
      setMap.put("s_itemID", request.getParameter("s_itemID"));
      setMap.put("ArcCode", request.getParameter("ArcCode"));
      setMap.put("delItemsYN", delItemsYN);

      Map selectedItemMap = this.commonService.select("report_SQL.getItemInfo", setMap);

      setMap.put("DocumentID", request.getParameter("s_itemID"));
      setMap.put("DocCategory", "ITM");
      List L2AttachFileList = this.commonService.selectList("fileMgt_SQL.getFile_gridList", setMap);

      String defaultFont = this.commonService.selectString("report_SQL.getDefaultFont", setMap);

      String defaultLang = this.commonService.selectString("item_SQL.getDefaultLang", commandMap);
      List modelList = new ArrayList();
      List totalList = new ArrayList();

      List allTotalList = new ArrayList();
      Map allTotalMap = new HashMap();
      Map titleItemMap = new HashMap();
      String e2eModelId = "";
      Map e2eModelMap = new HashMap();
      List lowLankItemIdList = new ArrayList();
      String selectedItemPath = "";
      Map e2eAttrMap = new HashMap();
      Map e2eAttrNameMap = new HashMap();
      Map e2eAttrHtmlMap = new HashMap();
      List e2eDimResultList = new ArrayList();

      Map piAttrMap = new HashMap();
      Map piAttrNameMap = new HashMap();
      Map piAttrHtmlMap = new HashMap();

      String reportCode = StringUtil.checkNull(commandMap.get("reportCode"));
      String classCode = this.commonService.selectString("report_SQL.getItemClassCode", setMap);
      List rptAllocClassList = this.commonService.selectList("report_SQL.getRptAllocatedClass", commandMap);
      Map e2eClassMap = new HashMap();
      Map piClassMap = new HashMap();

      List L2SubItemInfoList = new ArrayList();

      if (rptAllocClassList.size() > 0) {
        for (int i = 0; rptAllocClassList.size() > i; i++) {
          Map map = (Map)rptAllocClassList.get(i);
          if (reportCode.equals("RP00008"))
            e2eClassMap.put(map.get("ClassCode"), map.get("ClassCode"));
          else if (reportCode.equals("RP00031")) {
            piClassMap.put(map.get("ClassCode"), map.get("ClassCode"));
          }
        }
      }

      if (e2eClassMap.containsKey(classCode))
      {
        setMap.put("ModelTypeCode", "MT003");
        e2eModelMap = this.commonService.select("report_SQL.getModelIdAndSize", setMap);

        selectedItemPath = this.commonService.selectString("report_SQL.getMyIdAndNamePath", setMap);

        commandMap.put("ItemID", request.getParameter("s_itemID"));
        commandMap.put("DefaultLang", defaultLang);
        List attrList = new ArrayList();
        if ("N".equals(StringUtil.checkNull(request.getParameter("onlyMap"))))
        {
          getE2EAttrInfo(commandMap, e2eAttrMap, e2eAttrNameMap, e2eAttrHtmlMap);

          getE2EDimInfo(setMap, e2eDimResultList);
        }

        if (e2eModelMap == null) {
          url = "/cmm/ajaxResult/ajaxPage";
        } else {
          setModelMap(e2eModelMap, request);
          e2eModelId = StringUtil.checkNull(e2eModelMap.get("ModelID"));
          List parentList = getE2EModelList(e2eModelId, "SB00001", "");

          for (int p = 0; parentList.size() > p; p++) {
            titleItemMap = new HashMap();
            Map parentMap = (Map)parentList.get(p);

            setMap.put("s_itemID", parentMap.get("MyItemID"));
            titleItemMap = this.commonService.select("report_SQL.getItemInfo", setMap);

            List childList = getE2EModelList(e2eModelId, "", StringUtil.checkNull(parentMap.get("ElementID")));

            if (childList.size() > 0) {
              allTotalMap = new HashMap();
              totalList = new ArrayList();
              setTotalList(totalList, childList, setMap, request, commandMap, defaultLang, languageId);
              allTotalMap.put("titleItemMap", titleItemMap);
              allTotalMap.put("totalList", totalList);
              allTotalList.add(allTotalMap);
            }
          }

        }

        if (totalList.size() > 0)
          lowLankItemIdList = getE2EContents(allTotalList);
      }
      else if (piClassMap.containsKey(classCode))
      {
        selectedItemPath = selectedItemMap.get("Identifier") + " " + selectedItemMap.get("ItemName");

        commandMap.put("ItemID", request.getParameter("s_itemID"));
        commandMap.put("DefaultLang", defaultLang);
        List attrList = new ArrayList();
        if ("N".equals(StringUtil.checkNull(request.getParameter("onlyMap"))))
        {
          getPIAttrInfo(commandMap, piAttrMap, piAttrNameMap, piAttrHtmlMap);

          setMap.put("languageID", request.getParameter("languageID"));
          List relItemList = this.commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);

          allTotalMap = new HashMap();
          totalList = new ArrayList();
          setTotalList(totalList, relItemList, setMap, request, commandMap, defaultLang, languageId);
          titleItemMap = selectedItemMap;
          allTotalMap.put("titleItemMap", titleItemMap);
          allTotalMap.put("totalList", totalList);
          allTotalList.add(allTotalMap);
        }

        if (totalList.size() > 0)
          lowLankItemIdList = getE2EContents(allTotalList);
      }
      else {
        if ("CL01005".equals(classCode)) {
          Map subProcessMap = new HashMap();
          subProcessMap.put("MyItemID", request.getParameter("s_itemID"));
          modelList.add(subProcessMap);
          selectedItemPath = selectedItemMap.get("Identifier") + " " + selectedItemMap.get("ItemName");
        } else {
          setMap.put("ClassCode", "subProcess");

          String arcCode = StringUtil.checkNull(request.getParameter("ArcCode"));
          commandMap.put("ArcCode", arcCode);
          commandMap.put("SelectMenuId", arcCode);
          Map arcFilterDimInfoMap = this.commonService.select("report_SQL.getArcFilterDimInfo", commandMap);
          String TreeSql = StringUtil.checkNull(arcFilterDimInfoMap.get("TreeSql"));
          commandMap.put("TreeSql", TreeSql);
          String outPutItems = "";
          if ((TreeSql != null) && (!"".equals(TreeSql))) {
            outPutItems = getArcDimTreeIDs(commandMap);
            commandMap.put("outPutItems", outPutItems);
          }

          setMap.put("outPutItems", outPutItems);
          modelList = this.commonService.selectList("report_SQL.getItemStrList_gridList", setMap);
          setMap.remove("ClassCode");

          lowLankItemIdList = getRowLankItemList(this.commonService, request.getParameter("s_itemID"), classCode, languageId, outPutItems, delItemsYN);

          selectedItemPath = selectedItemMap.get("Identifier") + " " + selectedItemMap.get("ItemName");

          setMap.put("CURRENT_ITEM", request.getParameter("s_itemID"));
          setMap.put("CategoryCode", "ST1");
          setMap.put("languageID", languageId);
          setMap.put("toItemClassCode", "CL01004");

          L2SubItemInfoList = this.commonService.selectList("report_SQL.getChildItemsForWord", setMap);
        }

        setTotalList(totalList, modelList, setMap, request, commandMap, defaultLang, languageId);
        titleItemMap = selectedItemMap;
        allTotalMap.put("titleItemMap", titleItemMap);
        allTotalMap.put("totalList", totalList);
        allTotalMap.put("L2AttachFileList", L2AttachFileList);
        allTotalList.add(allTotalMap);
      }

      model.put("allTotalList", allTotalList);
      model.put("e2eModelMap", e2eModelMap);
      model.put("e2eItemInfo", selectedItemMap);
      model.put("e2eAttrMap", e2eAttrMap);
      model.put("e2eAttrNameMap", e2eAttrNameMap);
      model.put("e2eAttrHtmlMap", e2eAttrHtmlMap);
      model.put("e2eDimResultList", e2eDimResultList);

      model.put("piItemInfo", selectedItemMap);
      model.put("piAttrMap", piAttrMap);
      model.put("piAttrNameMap", piAttrNameMap);
      model.put("piAttrHtmlMap", piAttrHtmlMap);
      model.put("reportCode", reportCode);
      model.put("onlyMap", request.getParameter("onlyMap"));
      model.put("paperSize", request.getParameter("paperSize"));
      model.put("menu", getLabel(request, this.commonService));
      model.put("setMap", setMap);
      model.put("defaultFont", defaultFont);
      model.put("lowLankItemIdList", lowLankItemIdList);
      model.put("selectedItemPath", selectedItemPath);
      String itemNameofFileNm = StringUtil.checkNull(selectedItemMap.get("ItemName")).replace("&#xa;", "");
      model.put("ItemNameOfFileNm", URLEncoder.encode(itemNameofFileNm, "UTF-8").replace("+", "%20"));
      allTotalMap.put("L2SubItemInfoList", L2SubItemInfoList);
      model.put("selectedItemIdentifier", StringUtil.checkNull(selectedItemMap.get("Identifier")));
      model.put("outputType", request.getParameter("outputType"));
      if (StringUtil.checkNull(commandMap.get("url")).equals("wordExport_CJGLOBAL")) {
        MakeWordReport.makeWordExportCJGLOBAL(commandMap, model);
      }
      model.put("selectedItemMap", selectedItemMap);

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00105"));
      target.put("SCRIPT", "parent.goBack();parent.$('#isSubmit').remove();");
    } catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl(url);
  }

  @RequestMapping({"/batchProcessExport.do"})
  public String batchProcessExport(HttpServletRequest request, HashMap commandMap, ModelMap model)
    throws Exception
  {
    Map target = new HashMap();
    try
    {
      Map setMap = new HashMap();
      String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
      String itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
      String classCode = "CL01005";
      commandMap.put("onlyMap", "N");

      setMap.put("itemID", itemID);
      setMap.put("classCode", classCode);
      setMap.put("languageID", languageID);
      List itemInfoList = this.commonService.selectList("report_SQL.getChildItemList", setMap);

      commandMap.remove("s_itemID");
      String returnValue = "";
      if (itemInfoList.size() > 0) {
        for (int i = 0; i < itemInfoList.size(); i++) {
          Map itemInfoMap = (Map)itemInfoList.get(i);
          commandMap.put("s_itemID", itemInfoMap.get("MyItemID"));
          returnValue = setBatchWordReport(request, commandMap, model);
        }
      }

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
      target.put("SCRIPT", "parent.afterWordReport();parent.$('#isSubmit').remove();");
    } catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  private String setBatchWordReport(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    Map target = new HashMap();
    String returnValue = "";
    try {
      Map setMap = new HashMap();
      String languageId = String.valueOf(commandMap.get("sessionCurrLangType"));
      String delItemsYN = StringUtil.checkNull(commandMap.get("delItemsYN"));
      setMap.put("languageID", languageId);
      setMap.put("langCode", StringUtil.checkNull(commandMap.get("sessionCurrLangCode")).toUpperCase());
      setMap.put("s_itemID", commandMap.get("s_itemID"));
      setMap.put("s_itemID", commandMap.get("s_itemID"));
      setMap.put("ArcCode", request.getParameter("ArcCode"));
      setMap.put("delItemsYN", delItemsYN);

      Map selectedItemMap = this.commonService.select("report_SQL.getItemInfo", setMap);

      setMap.put("DocumentID", StringUtil.checkNull(commandMap.get("s_itemID")));
      setMap.put("DocCategory", "ITM");
      List L2AttachFileList = this.commonService.selectList("fileMgt_SQL.getFile_gridList", setMap);

      String defaultFont = this.commonService.selectString("report_SQL.getDefaultFont", setMap);

      String defaultLang = this.commonService.selectString("item_SQL.getDefaultLang", commandMap);
      List modelList = new ArrayList();
      List totalList = new ArrayList();

      List allTotalList = new ArrayList();
      Map allTotalMap = new HashMap();
      Map titleItemMap = new HashMap();
      String e2eModelId = "";
      Map e2eModelMap = new HashMap();
      List lowLankItemIdList = new ArrayList();
      String selectedItemPath = "";
      Map e2eAttrMap = new HashMap();
      Map e2eAttrNameMap = new HashMap();
      Map e2eAttrHtmlMap = new HashMap();
      List e2eDimResultList = new ArrayList();

      Map piAttrMap = new HashMap();
      Map piAttrNameMap = new HashMap();
      Map piAttrHtmlMap = new HashMap();

      String reportCode = StringUtil.checkNull(commandMap.get("reportCode"));
      String classCode = this.commonService.selectString("report_SQL.getItemClassCode", setMap);
      List rptAllocClassList = this.commonService.selectList("report_SQL.getRptAllocatedClass", commandMap);
      Map e2eClassMap = new HashMap();
      Map piClassMap = new HashMap();

      List L2SubItemInfoList = new ArrayList();

      if (rptAllocClassList.size() > 0) {
        for (int i = 0; rptAllocClassList.size() > i; i++) {
          Map map = (Map)rptAllocClassList.get(i);
          if (reportCode.equals("RP00008"))
            e2eClassMap.put(map.get("ClassCode"), map.get("ClassCode"));
          else if (reportCode.equals("RP00031")) {
            piClassMap.put(map.get("ClassCode"), map.get("ClassCode"));
          }
        }
      }

      if (e2eClassMap.containsKey(classCode))
      {
        setMap.put("ModelTypeCode", "MT003");
        e2eModelMap = this.commonService.select("report_SQL.getModelIdAndSize", setMap);

        selectedItemPath = this.commonService.selectString("report_SQL.getMyIdAndNamePath", setMap);

        commandMap.put("ItemID", commandMap.get("s_itemID"));
        commandMap.put("DefaultLang", defaultLang);
        List attrList = new ArrayList();
        if ("N".equals(StringUtil.checkNull(request.getParameter("onlyMap"))))
        {
          getE2EAttrInfo(commandMap, e2eAttrMap, e2eAttrNameMap, e2eAttrHtmlMap);

          getE2EDimInfo(setMap, e2eDimResultList);
        }

        if (e2eModelMap != null)
        {
          setModelMap(e2eModelMap, request);
          e2eModelId = StringUtil.checkNull(e2eModelMap.get("ModelID"));
          List parentList = getE2EModelList(e2eModelId, "SB00001", "");

          for (int p = 0; parentList.size() > p; p++) {
            titleItemMap = new HashMap();
            Map parentMap = (Map)parentList.get(p);

            setMap.put("s_itemID", parentMap.get("MyItemID"));
            titleItemMap = this.commonService.select("report_SQL.getItemInfo", setMap);

            List childList = getE2EModelList(e2eModelId, "SB00004", StringUtil.checkNull(parentMap.get("ElementID")));

            if (childList.size() > 0) {
              allTotalMap = new HashMap();
              totalList = new ArrayList();
              setTotalList(totalList, childList, setMap, request, commandMap, defaultLang, languageId);
              allTotalMap.put("titleItemMap", titleItemMap);
              allTotalMap.put("totalList", totalList);
              allTotalList.add(allTotalMap);
            }
          }

        }

        if (totalList.size() > 0)
          lowLankItemIdList = getE2EContents(allTotalList);
      }
      else if (piClassMap.containsKey(classCode))
      {
        selectedItemPath = selectedItemMap.get("Identifier") + " " + selectedItemMap.get("ItemName");

        commandMap.put("ItemID", commandMap.get("s_itemID"));
        commandMap.put("DefaultLang", defaultLang);
        List attrList = new ArrayList();
        if ("N".equals(StringUtil.checkNull(request.getParameter("onlyMap"))))
        {
          getPIAttrInfo(commandMap, piAttrMap, piAttrNameMap, piAttrHtmlMap);

          setMap.put("languageID", request.getParameter("languageID"));
          List relItemList = this.commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);

          allTotalMap = new HashMap();
          totalList = new ArrayList();
          setTotalList(totalList, relItemList, setMap, request, commandMap, defaultLang, languageId);
          titleItemMap = selectedItemMap;
          allTotalMap.put("titleItemMap", titleItemMap);
          allTotalMap.put("totalList", totalList);
          allTotalList.add(allTotalMap);
        }

        if (totalList.size() > 0)
          lowLankItemIdList = getE2EContents(allTotalList);
      }
      else {
        if ("CL01005".equals(classCode)) {
          Map subProcessMap = new HashMap();
          subProcessMap.put("MyItemID", commandMap.get("s_itemID"));
          modelList.add(subProcessMap);
          selectedItemPath = selectedItemMap.get("Identifier") + " " + selectedItemMap.get("ItemName");
        } else {
          setMap.put("ClassCode", "subProcess");

          String arcCode = StringUtil.checkNull(request.getParameter("ArcCode"));
          commandMap.put("ArcCode", arcCode);
          commandMap.put("SelectMenuId", arcCode);

          String outPutItems = "";

          modelList = this.commonService.selectList("report_SQL.getItemStrList_gridList", setMap);
          setMap.remove("ClassCode");

          lowLankItemIdList = getRowLankItemList(this.commonService, StringUtil.checkNull(commandMap.get("s_itemID")), classCode, languageId, outPutItems, delItemsYN);

          selectedItemPath = this.commonService.selectString("report_SQL.getMyIdAndNamePath", setMap);

          setMap.put("CURRENT_ITEM", commandMap.get("s_itemID"));
          setMap.put("CategoryCode", "ST1");
          setMap.put("languageID", languageId);
          setMap.put("toItemClassCode", "CL01004");

          L2SubItemInfoList = this.commonService.selectList("report_SQL.getChildItemsForWord", setMap);
        }

        setTotalList(totalList, modelList, setMap, request, commandMap, defaultLang, languageId);
        titleItemMap = selectedItemMap;
        allTotalMap.put("titleItemMap", titleItemMap);
        allTotalMap.put("totalList", totalList);
        allTotalMap.put("L2AttachFileList", L2AttachFileList);
        allTotalList.add(allTotalMap);
      }

      model.put("allTotalList", allTotalList);
      model.put("e2eModelMap", e2eModelMap);
      model.put("e2eItemInfo", selectedItemMap);
      model.put("e2eAttrMap", e2eAttrMap);
      model.put("e2eAttrNameMap", e2eAttrNameMap);
      model.put("e2eAttrHtmlMap", e2eAttrHtmlMap);
      model.put("e2eDimResultList", e2eDimResultList);

      model.put("piItemInfo", selectedItemMap);
      model.put("piAttrMap", piAttrMap);
      model.put("piAttrNameMap", piAttrNameMap);
      model.put("piAttrHtmlMap", piAttrHtmlMap);
      model.put("reportCode", reportCode);
      model.put("onlyMap", commandMap.get("onlyMap"));
      model.put("paperSize", commandMap.get("paperSize"));
      model.put("menu", getLabel(request, this.commonService));
      model.put("setMap", setMap);
      model.put("defaultFont", defaultFont);
      model.put("lowLankItemIdList", lowLankItemIdList);
      model.put("selectedItemPath", selectedItemPath);
      String itemNameofFileNm = StringUtil.checkNull(selectedItemMap.get("ItemName")).replace("&#xa;", "");
      model.put("ItemNameOfFileNm", itemNameofFileNm);
      commandMap.put("identifier", StringUtil.checkNull(selectedItemMap.get("Identifier")));
      allTotalMap.put("L2SubItemInfoList", L2SubItemInfoList);

      setMap.put("languageID", languageId);
      String extLangCode = StringUtil.checkNull(this.commonService.selectString("common_SQL.getLanguageExtCode", setMap));
      commandMap.put("extLangCode", extLangCode);
      returnValue = MakeWordReport.makeWordExportCJGLOBAL(commandMap, model);
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    return returnValue;
  }

  @RequestMapping({"/wordReportPI.do"})
  public String wordReportPI(HttpServletRequest request, HashMap commandMap, ModelMap model)
    throws Exception
  {
    Map target = new HashMap();

    String url = "/custom/" + GlobalVal.BASE_ATCH_URL + "/wordExportPI" + "_" + GlobalVal.BASE_ATCH_URL;
    if (!StringUtil.checkNull(request.getParameter("url")).equals("")) {
      url = "/custom/" + GlobalVal.BASE_ATCH_URL + "/" + StringUtil.checkNull(request.getParameter("url"));
    }
    try
    {
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

      selectedItemPath = this.commonService.selectString("report_SQL.getMyPathAndName", setMap);
      selectedItemName = StringUtil.checkNull(this.commonService.selectString("report_SQL.getMyIdAndName", setMap)).replace("&#xa;", "");

      Map selectedItemMap = this.commonService.select("report_SQL.getItemInfo", setMap);

      String defaultFont = this.commonService.selectString("report_SQL.getDefaultFont", setMap);

      String defaultLang = this.commonService.selectString("item_SQL.getDefaultLang", commandMap);
      String classCode = this.commonService.selectString("report_SQL.getItemClassCode", setMap);

      List piSubItemList = this.commonService.selectList("report_SQL.getSubPIItemList", setMap);
      List L4ProcessList = this.commonService.selectList("report_SQL.getPIL4ItemList", setMap);

      Map setData = new HashMap();
      Map piSubItemInfoMap = new HashMap();
      List piSubItemList2 = new ArrayList();
      if (piSubItemList.size() > 0) {
        for (int i = 0; piSubItemList.size() > i; i++) {
          Map processMap = (Map)piSubItemList.get(i);

          setData.put("itemID", processMap.get("SUBPIItemID"));
          setData.put("s_itemID", processMap.get("SUBPIItemID"));
          setData.put("languageID", commandMap.get("sessionCurrLangType"));
          piSubItemInfoMap = this.commonService.select("report_SQL.getItemInfo", setData);

          setData.put("SUBPIItemID", processMap.get("SUBPIItemID"));
          List subItemRelatedList = this.commonService.selectList("report_SQL.getPIL4ItemList", setData);

          setData.put("objClassCode", "CL08002");
          List piSubItemKpiList = this.commonService.selectList("report_SQL.getPIObjectList", setData);

          setData.put("objClassCode", "CL07002");
          List piSubItemRuleSetList = this.commonService.selectList("report_SQL.getPIObjectList", setData);

          setData.put("objClassCode", "CL09002");
          List piSubItemToCheckList = this.commonService.selectList("report_SQL.getPIObjectList", setData);

          processMap.put("AT00003", piSubItemInfoMap.get("Description"));
          processMap.put("OwnerTeamName", piSubItemInfoMap.get("OwnerTeamName"));
          processMap.put("OwnerName", piSubItemInfoMap.get("Name"));

          processMap.put("subItemRelatedList", subItemRelatedList);
          processMap.put("piSubItemKpiList", piSubItemKpiList);
          processMap.put("piSubItemRuleSetList", piSubItemRuleSetList);
          processMap.put("piSubItemToCheckList", piSubItemToCheckList);

          piSubItemList2.add(i, processMap);
        }
      }

      model.put("piSubItemList", piSubItemList2);
      model.put("L4ProcessList", L4ProcessList);

      setMap.put("objClassCode", "CL08002");
      List piKpiList = this.commonService.selectList("report_SQL.getPIObjectList", setMap);

      setMap.put("objClassCode", "CL07002");
      List piRuleSetList = this.commonService.selectList("report_SQL.getPIObjectList", setMap);

      setMap.put("objClassCode", "CL09002");
      List piToCheckList = this.commonService.selectList("report_SQL.getPIObjectList", setMap);

      model.put("piKpiList", piKpiList);
      model.put("piRuleSetList", piRuleSetList);
      model.put("piToCheckList", piToCheckList);
      model.put("menu", getLabel(request, this.commonService));
      model.put("setMap", setMap);
      model.put("defaultFont", defaultFont);
      model.put("selectedItemPath", selectedItemPath);
      model.put("selectedItemName", selectedItemName);
      model.put("selectedItemMap", selectedItemMap);
      model.put("ItemNameOfFileNm", URLEncoder.encode(selectedItemName, "UTF-8").replace("+", "%20"));
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00105"));
      target.put("SCRIPT", "parent.afterWordReport();parent.$('#isSubmit').remove();");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl(url);
  }

  @RequestMapping({"/rulesetWordReport.do"})
  public String rulesetWordReport(HttpServletRequest request, HashMap commandMap, ModelMap model)
    throws Exception
  {
    Map target = new HashMap();
    String url = "/custom/base/report/ruleReport";
    if (!StringUtil.checkNull(commandMap.get("url")).equals("")) url = "/" + StringUtil.checkNull(commandMap.get("url"));
    try
    {
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

      selectedItemPath = this.commonService.selectString("report_SQL.getMyPathAndName", setMap);
      selectedItemName = StringUtil.checkNull(this.commonService.selectString("report_SQL.getMyIdAndName", setMap)).replace("&#xa;", "");

      String defaultFont = this.commonService.selectString("report_SQL.getDefaultFont", setMap);

      String defaultLang = this.commonService.selectString("item_SQL.getDefaultLang", commandMap);
      String classCode = this.commonService.selectString("report_SQL.getItemClassCode", setMap);

      if ("CL07001".equals(classCode))
      {
        setMap.put("CURRENT_ITEM", request.getParameter("s_itemID"));
        setMap.put("CategoryCode", "ST1");
        ruleSetList = this.commonService.selectList("report_SQL.getChildItemsForWord", setMap);

        ruleSetList = getConItemInfo(ruleSetList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, "CN00107", "ToItemID");
      }

      model.put("attrRsNameMap", attrRsNameMap);
      model.put("attrRsHtmlMap", attrRsHtmlMap);
      model.put("ruleSetList", ruleSetList);

      model.put("menu", getLabel(request, this.commonService));
      model.put("setMap", setMap);
      model.put("defaultFont", defaultFont);
      model.put("selectedItemPath", selectedItemPath);
      model.put("selectedItemName", URLEncoder.encode(selectedItemName, "UTF-8").replace("+", "%20"));

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00105"));
      target.put("SCRIPT", "parent.afterWordReport();parent.$('#isSubmit').remove();");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl(url);
  }

  @RequestMapping({"/wordReportRuleSet.do"})
  public String wordReportRuleSet(HttpServletRequest request, HashMap commandMap, ModelMap model)
    throws Exception
  {
    Map target = new HashMap();
    String url = "/custom/" + GlobalVal.BASE_ATCH_URL + "/wordExportRuleSet" + "_" + GlobalVal.BASE_ATCH_URL;
    if (!StringUtil.checkNull(request.getParameter("url")).equals("")) {
      url = "/custom/" + GlobalVal.BASE_ATCH_URL + "/" + StringUtil.checkNull(request.getParameter("url"));
    }
    try
    {
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

      selectedItemPath = this.commonService.selectString("report_SQL.getMyPathAndName", setMap);
      selectedItemName = StringUtil.checkNull(this.commonService.selectString("report_SQL.getMyIdAndName", setMap)).replace("&#xa;", "");

      String defaultFont = this.commonService.selectString("report_SQL.getDefaultFont", setMap);

      String defaultLang = this.commonService.selectString("item_SQL.getDefaultLang", commandMap);
      String classCode = this.commonService.selectString("report_SQL.getItemClassCode", setMap);

      Map selectedItemMap = this.commonService.select("report_SQL.getItemInfo", setMap);

      if ("CL07001".equals(classCode))
      {
        setMap.put("CURRENT_ITEM", request.getParameter("s_itemID"));
        setMap.put("CategoryCode", "ST1");
        ruleSetList = this.commonService.selectList("report_SQL.getChildItemsForWord", setMap);

        ruleSetList = getConItemInfo(ruleSetList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, "CN00107", "ToItemID");
      }

      model.put("attrRsNameMap", attrRsNameMap);
      model.put("attrRsHtmlMap", attrRsHtmlMap);
      model.put("ruleSetList", ruleSetList);

      model.put("menu", getLabel(request, this.commonService));
      model.put("setMap", setMap);
      model.put("defaultFont", defaultFont);
      model.put("selectedItemPath", selectedItemPath);
      model.put("selectedItemName", selectedItemName);
      model.put("itemNameOfFileNm", URLEncoder.encode(selectedItemName, "UTF-8").replace("+", "%20"));
      model.put("selectedItemMap", selectedItemMap);
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00105"));
      target.put("SCRIPT", "parent.afterWordReport();parent.$('#isSubmit').remove();");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl(url);
  }

  @RequestMapping({"/kpiWordReport.do"})
  public String kpiWordReport(HttpServletRequest request, HashMap commandMap, ModelMap model)
    throws Exception
  {
    Map target = new HashMap();
    String url = "/custom/base/report/kpiReport";
    if (!StringUtil.checkNull(commandMap.get("url")).equals("")) url = "/" + StringUtil.checkNull(commandMap.get("url"));
    try
    {
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

      selectedItemPath = this.commonService.selectString("report_SQL.getMyPathAndName", setMap);
      selectedItemName = StringUtil.checkNull(this.commonService.selectString("report_SQL.getMyIdAndName", setMap)).replace("&#xa;", "");

      String defaultFont = this.commonService.selectString("report_SQL.getDefaultFont", setMap);

      String defaultLang = this.commonService.selectString("item_SQL.getDefaultLang", commandMap);
      String classCode = this.commonService.selectString("report_SQL.getItemClassCode", setMap);

      if ("CL08001".equals(classCode))
      {
        setMap.put("CURRENT_ITEM", request.getParameter("s_itemID"));
        setMap.put("CategoryCode", "ST1");
        kpiList = this.commonService.selectList("report_SQL.getChildItemsForWord", setMap);

        kpiList = getConItemInfo(kpiList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, "CN00108", "ToItemID");
      }

      model.put("attrRsNameMap", attrRsNameMap);
      model.put("attrRsHtmlMap", attrRsHtmlMap);
      model.put("kpiList", kpiList);

      model.put("menu", getLabel(request, this.commonService));
      model.put("setMap", setMap);
      model.put("defaultFont", defaultFont);
      model.put("selectedItemPath", selectedItemPath);
      model.put("selectedItemName", URLEncoder.encode(selectedItemName, "UTF-8").replace("+", "%20"));
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00105"));
      target.put("SCRIPT", "parent.afterWordReport();parent.$('#isSubmit').remove();");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl(url);
  }

  @RequestMapping({"/wordReportKpi.do"})
  public String wordReportKpi(HttpServletRequest request, HashMap commandMap, ModelMap model)
    throws Exception
  {
    Map target = new HashMap();
    String url = "/custom/" + GlobalVal.BASE_ATCH_URL + "/wordExportKpi" + "_" + GlobalVal.BASE_ATCH_URL;
    if (!StringUtil.checkNull(request.getParameter("url")).equals(""))
      url = "/custom/" + GlobalVal.BASE_ATCH_URL + "/" + StringUtil.checkNull(request.getParameter("url"));
    try
    {
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

      selectedItemPath = this.commonService.selectString("report_SQL.getMyPathAndName", setMap);
      selectedItemName = StringUtil.checkNull(this.commonService.selectString("report_SQL.getMyIdAndName", setMap)).replace("&#xa;", "");

      String defaultFont = this.commonService.selectString("report_SQL.getDefaultFont", setMap);

      String defaultLang = this.commonService.selectString("item_SQL.getDefaultLang", commandMap);
      String classCode = this.commonService.selectString("report_SQL.getItemClassCode", setMap);

      Map selectedItemMap = this.commonService.select("report_SQL.getItemInfo", setMap);

      if ("CL08001".equals(classCode))
      {
        setMap.put("CURRENT_ITEM", request.getParameter("s_itemID"));
        setMap.put("CategoryCode", "ST1");
        kpiList = this.commonService.selectList("report_SQL.getChildItemsForWord", setMap);

        kpiList = getConItemInfo(kpiList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, "CN00108", "ToItemID");
      }

      model.put("attrRsNameMap", attrRsNameMap);
      model.put("attrRsHtmlMap", attrRsHtmlMap);
      model.put("kpiList", kpiList);

      model.put("menu", getLabel(request, this.commonService));
      model.put("setMap", setMap);
      model.put("defaultFont", defaultFont);
      model.put("selectedItemPath", selectedItemPath);
      model.put("selectedItemName", selectedItemName);
      model.put("itemNameOfFileNm", URLEncoder.encode(selectedItemName, "UTF-8").replace("+", "%20"));
      model.put("selectedItemMap", selectedItemMap);
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00105"));
      target.put("SCRIPT", "parent.afterWordReport();parent.$('#isSubmit').remove();");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl(url);
  }

  public void getE2EAttrInfo(HashMap commandMap, Map e2eAttrMap, Map e2eAttrNameMap, Map e2eAttrHtmlMap)
    throws Exception
  {
    List attrList = this.commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
    for (int k = 0; attrList.size() > k; k++) {
      Map map = (Map)attrList.get(k);
      e2eAttrMap.put(map.get("AttrTypeCode"), map.get("PlainText"));
      e2eAttrNameMap.put(map.get("AttrTypeCode"), map.get("Name"));
      e2eAttrHtmlMap.put(map.get("AttrTypeCode"), map.get("HTML"));
    }
  }

  public void getPIAttrInfo(HashMap commandMap, Map piAttrMap, Map piAttrNameMap, Map piAttrHtmlMap)
    throws Exception
  {
    List attrList = this.commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
    for (int k = 0; attrList.size() > k; k++) {
      Map map = (Map)attrList.get(k);
      piAttrMap.put(map.get("AttrTypeCode"), map.get("PlainText"));
      piAttrNameMap.put(map.get("AttrTypeCode"), map.get("Name"));
      piAttrHtmlMap.put(map.get("AttrTypeCode"), map.get("HTML"));
    }
  }

  public void getE2EDimInfo(Map setMap, List dimResultList)
    throws Exception
  {
    List dimInfoList = this.commonService.selectList("dim_SQL.selectDim_gridList", setMap);
    Map dimResultMap = new HashMap();
    String dimTypeName = "";
    String dimValueNames = "";
    for (int i = 0; i < dimInfoList.size(); i++) {
      Map map = (HashMap)dimInfoList.get(i);

      if (i > 0) {
        if (dimTypeName.equals(map.get("DimTypeName").toString())) {
          dimValueNames = dimValueNames + " / " + map.get("DimValueName").toString();
        } else {
          dimResultMap.put("dimValueNames", dimValueNames);
          dimResultList.add(dimResultMap);
          dimResultMap = new HashMap();
          dimTypeName = map.get("DimTypeName").toString();
          dimResultMap.put("dimTypeName", dimTypeName);
          dimValueNames = map.get("DimValueName").toString();
        }
      } else {
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

  public List getE2EContents(List allTotalList)
    throws Exception
  {
    List lowLankItemIdList = new ArrayList();
    Map lowLankItemIdMap = new HashMap();
    List l4ItemList = new ArrayList();
    Map l3l4ItemIdMap = new HashMap();
    List l3l4ItemIdList = new ArrayList();

    for (int index = 0; allTotalList.size() > index; index++) {
      Map allTotalMap = (Map)allTotalList.get(index);
      List totalList = (List)allTotalMap.get("totalList");
      for (int i = 0; totalList.size() > i; i++) {
        Map totalMap = (Map)totalList.get(i);
        List prcList = (List)totalMap.get("prcList");
        Map prcMap = (Map)prcList.get(0);
        String name = removeAllTag(StringUtil.checkNull(prcMap.get("ItemName")));
        if (name.equals("")) {
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
    lowLankItemIdList.add(lowLankItemIdMap);

    return lowLankItemIdList;
  }

  public List getRowLankItemList(CommonService commonService, String selectedItemId, String classCode, String languageID, String outPutItems, String delItemsYN)
    throws Exception
  {
    List list0 = new ArrayList();
    List list1 = new ArrayList();
    List l3l4ItemIdList = new ArrayList();
    Map lowLankItemIdMap = new HashMap();
    List lowLankItemIdList = new ArrayList();
    Map map0 = new HashMap();
    Map map1 = new HashMap();
    Map setMap = new HashMap();

    String itemId = selectedItemId;
    String toItemId = "";
    setMap.put("delItemsYN", delItemsYN);
    if (!outPutItems.isEmpty()) {
      setMap.put("CURRENT_ToItemID", outPutItems);
    }

    if ("CL01001".equals(classCode)) {
      setMap.put("CURRENT_ITEM", itemId);
      setMap.put("CategoryCode", "ST1");
      setMap.put("languageID", languageID);
      setMap.put("toItemClassCode", "CL01002");
      list0 = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
    } else if ("CL01002".equals(classCode)) {
      setMap.put("CURRENT_ITEM", itemId);
      setMap.put("CategoryCode", "ST1");
      setMap.put("languageID", languageID);
      setMap.put("toItemClassCode", "CL01004");
      list1 = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
    } else if ("CL01004".equals(classCode)) {
      setMap.put("languageID", languageID);
      setMap.put("s_itemID", itemId);
      list1 = commonService.selectList("report_SQL.itemStDetailInfo", setMap);
      map1 = (Map)list1.get(0);
      map1.put("ToItemID", itemId);
      map1.put("toItemIdentifier", map1.get("Identifier"));
      map1.put("toItemName", map1.get("ItemName"));
      list1 = new ArrayList();
      list1.add(map1);
    }

    if (list0.size() > 0) {
      for (int i = 0; list0.size() > i; i++) {
        lowLankItemIdMap = new HashMap();
        l3l4ItemIdList = new ArrayList();
        map0 = (Map)list0.get(i);

        String l2Name = removeAllTag(StringUtil.checkNull(map0.get("toItemName")));
        String l2Item = StringUtil.checkNull(map0.get("toItemIdentifier") + " " + l2Name);

        setMap.put("CURRENT_ITEM", map0.get("ToItemID"));
        setMap.put("toItemClassCode", "CL01004");
        setMap.put("outPutItems", outPutItems);
        list1 = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
        lowLankItemIdMap.put("l2Item", l2Item);
        getL3l4ContentsList(list1, l3l4ItemIdList, setMap);
        lowLankItemIdMap.put("l3l4ItemIdList", l3l4ItemIdList);
        lowLankItemIdList.add(lowLankItemIdMap);
      }
    } else {
      lowLankItemIdMap = new HashMap();
      l3l4ItemIdList = new ArrayList();
      getL3l4ContentsList(list1, l3l4ItemIdList, setMap);
      lowLankItemIdMap.put("l2Item", "");
      lowLankItemIdMap.put("l3l4ItemIdList", l3l4ItemIdList);
      lowLankItemIdList.add(lowLankItemIdMap);
    }

    return lowLankItemIdList;
  }

  private void getL3l4ContentsList(List list1, List l3l4ItemIdList, Map setMap)
    throws Exception
  {
    List l4ItemList = new ArrayList();
    Map l3l4ItemIdMap = new HashMap();

    for (int k = 0; list1.size() > k; k++) {
      l4ItemList = new ArrayList();
      l3l4ItemIdMap = new HashMap();

      Map map1 = (Map)list1.get(k);

      String l3Name = removeAllTag(StringUtil.checkNull(map1.get("toItemName")));
      String l3Item = StringUtil.checkNull(map1.get("toItemIdentifier") + " " + l3Name);

      setMap.put("CURRENT_ITEM", map1.get("ToItemID"));
      setMap.put("toItemClassCode", "CL01005");
      List list2 = this.commonService.selectList("report_SQL.getChildItemsForWord", setMap);

      for (int m = 0; list2.size() > m; m++) {
        Map map2 = (Map)list2.get(m);
        String l4Name = removeAllTag(StringUtil.checkNull(map2.get("toItemName")));
        l4ItemList.add(StringUtil.checkNull(map2.get("toItemIdentifier") + " " + l4Name));
      }

      l3l4ItemIdMap.put("l3Item", l3Item);
      l3l4ItemIdMap.put("l4ItemList", l4ItemList);
      l3l4ItemIdList.add(l3l4ItemIdMap);
    }
  }

  public void setTotalList(List totalList, List modelList, Map setMap, HttpServletRequest request, HashMap commandMap, String defaultLang, String languageId)
    throws Exception
  {
    String beforFromItemID = "";
    for (int index = 0; modelList.size() > index; index++) {
      Map totalMap = new HashMap();
      Map subProcessMap = (Map)modelList.get(index);

      List detailElementList = new ArrayList();
      List cnitemList = new ArrayList();
      List dimResultList = new ArrayList();
      List ruleSetList = new ArrayList();
      List requirementList = new ArrayList();
      List kpiList = new ArrayList();
      List attachFileList = new ArrayList();
      List toCheckList = new ArrayList();

      List L3SubItemInfoList = new ArrayList();
      List L3KpiList = new ArrayList();
      Map L3AttrKpiNameMap = new HashMap();
      Map L3AttrKpiHtmlMap = new HashMap();
      List L3AttachFileList = new ArrayList();

      List cngtList = new ArrayList();

      setMap.put("s_itemID", subProcessMap.get("MyItemID"));
      setMap.put("s_itemID", subProcessMap.get("MyItemID"));
      setMap.put("itemId", String.valueOf(subProcessMap.get("MyItemID")));
      setMap.put("sessionCurrLangType", String.valueOf(commandMap.get("sessionCurrLangType")));
      setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
      setMap.put("attrTypeCode", commandMap.get("attrTypeCode"));

      List prcList = this.commonService.selectList("report_SQL.getItemInfo", setMap);

      Map prcMap = (Map)prcList.get(0);
      String fromItemID = StringUtil.checkNull(prcMap.get("FromItemID"));

      if ((beforFromItemID.equals("")) || (!beforFromItemID.equals(fromItemID))) {
        Map setData = new HashMap();
        setData.put("CURRENT_ITEM", fromItemID);
        setData.put("CategoryCode", "ST1");
        setData.put("languageID", languageId);
        setData.put("toItemClassCode", "CL01005");
        L3SubItemInfoList = this.commonService.selectList("report_SQL.getChildItemsForWord", setData);

        setData.put("CURRENT_ITEM", fromItemID);
        setData.put("itemTypeCode", "CN00108");
        L3KpiList = this.commonService.selectList("report_SQL.getChildItemsForWord", setData);

        L3KpiList = getConItemInfo(L3KpiList, defaultLang, languageId, L3AttrKpiNameMap, L3AttrKpiHtmlMap, "CN00108", "ToItemID");
        totalMap.put("L3AttrKpiNameMap", L3AttrKpiNameMap);
        totalMap.put("L3AttrKpiHtmlMap", L3AttrKpiHtmlMap);
        totalMap.put("L3KpiList", L3KpiList);
        setData.remove("CURRENT_ITEM");

        setData.put("DocumentID", fromItemID);
        setData.put("DocCategory", "ITM");
        setData.remove("itemTypeCode");
        L3AttachFileList = this.commonService.selectList("fileMgt_SQL.getFile_gridList", setData);
      }
      beforFromItemID = fromItemID;

      commandMap.put("ItemID", subProcessMap.get("MyItemID"));
      commandMap.put("DefaultLang", defaultLang);

      List attrList = new ArrayList();
      List activityList = new ArrayList();
      if ("N".equals(StringUtil.checkNull(commandMap.get("onlyMap")))) {
        attrList = this.commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
        Map attrMap = new LinkedHashMap();
        Map attrNameMap = new LinkedHashMap();
        Map attrHtmlMap = new LinkedHashMap();
        for (int k = 0; attrList.size() > k; k++) {
          Map map = (Map)attrList.get(k);
          attrMap.put(map.get("AttrTypeCode"), map.get("PlainText"));
          attrNameMap.put(map.get("AttrTypeCode"), map.get("Name"));
          attrHtmlMap.put(map.get("AttrTypeCode"), map.get("HTML"));
        }

        setMap.put("viewType", "wordReport");
        activityList = this.commonService.selectList("item_SQL.getSubItemList_gridList", setMap);

        activityList = getActivityAttr(activityList, defaultLang, languageId, attrNameMap, attrHtmlMap);

        List activityNames = this.commonService.selectList("report_SQL.getActivityAttrName", commandMap);
        for (int k = 0; activityNames.size() > k; k++) {
          Map map = (Map)activityNames.get(k);
          attrNameMap.put(map.get("AttrTypeCode"), map.get("Name"));
        }

        totalMap.put("attrMap", attrMap);
        totalMap.put("attrNameMap", attrNameMap);
        totalMap.put("attrHtmlMap", attrHtmlMap);
      }

      setMap.remove("ModelTypeCode");
      setMap.put("MTCategory", request.getParameter("MTCategory"));
      Map modelMap = this.commonService.select("report_SQL.getModelIdAndSize", setMap);

      if (modelMap != null) {
        setModelMap(modelMap, request);
        Map setMap2 = new HashMap();
        setMap2.put("languageID", languageId);
        if ("N".equals(StringUtil.checkNull(commandMap.get("onlyMap"))))
        {
          detailElementList = getElementList(setMap2, modelMap);
        }
      }

      if ("N".equals(StringUtil.checkNull(commandMap.get("onlyMap"))))
      {
        cnitemList = this.commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);

        List dimInfoList = this.commonService.selectList("dim_SQL.selectDim_gridList", setMap);
        Map dimResultMap = new HashMap();
        String dimTypeName = "";
        String dimValueNames = "";
        for (int i = 0; i < dimInfoList.size(); i++) {
          Map map = (HashMap)dimInfoList.get(i);

          if (i > 0) {
            if (dimTypeName.equals(map.get("DimTypeName").toString())) {
              dimValueNames = dimValueNames + " / " + map.get("DimValueName").toString();
            } else {
              dimResultMap.put("dimValueNames", dimValueNames);
              dimResultList.add(dimResultMap);
              dimResultMap = new HashMap();
              dimTypeName = map.get("DimTypeName").toString();
              dimResultMap.put("dimTypeName", dimTypeName);
              dimValueNames = map.get("DimValueName").toString();
            }
          } else {
            dimTypeName = map.get("DimTypeName").toString();
            dimResultMap.put("dimTypeName", dimTypeName);
            dimValueNames = map.get("DimValueName").toString();
          }
        }

        if (dimInfoList.size() > 0) {
          dimResultMap.put("dimValueNames", dimValueNames);
          dimResultList.add(dimResultMap);
        }

        Map attrRsNameMap = new HashMap();
        Map attrRsHtmlMap = new HashMap();
        setMap.put("CURRENT_ITEM", setMap.get("s_itemID"));
        setMap.put("itemTypeCode", "CN00107");
        ruleSetList = this.commonService.selectList("report_SQL.getChildItemsForWord", setMap);

        ruleSetList = getConItemInfo(ruleSetList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, "CN00107", "ToItemID");
        totalMap.put("attrRsNameMap", attrRsNameMap);
        totalMap.put("attrRsHtmlMap", attrRsHtmlMap);
        totalMap.put("ruleSetList", ruleSetList);
        setMap.remove("CURRENT_ITEM");

        setMap.put("CURRENT_ITEM", setMap.get("s_itemID"));
        setMap.put("itemTypeCode", "CN00108");
        kpiList = this.commonService.selectList("report_SQL.getChildItemsForWord", setMap);

        kpiList = getConItemInfo(kpiList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, "CN00108", "ToItemID");
        totalMap.put("attrKpiNameMap", attrRsNameMap);
        totalMap.put("attrKpiHtmlMap", attrRsHtmlMap);
        totalMap.put("kpiList", kpiList);
        setMap.remove("CURRENT_ITEM");

        setMap.remove("itemTypeCode");
        setMap.put("DocumentID", String.valueOf(subProcessMap.get("MyItemID")));
        attachFileList = this.commonService.selectList("fileMgt_SQL.getFile_gridList", setMap);

        String classCode = this.commonService.selectString("report_SQL.getItemClassCode", setMap);

        setMap.put("CURRENT_ToItemID", setMap.get("s_itemID"));
        setMap.put("itemTypeCode", "CN01301");
        requirementList = this.commonService.selectList("report_SQL.getChildItemsForWord", setMap);

        requirementList = getConItemInfo(requirementList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, "CN01301", "FromItemID");
        totalMap.put("attrPINameMap", attrRsNameMap);
        totalMap.put("attrPIHtmlMap", attrRsHtmlMap);
        totalMap.put("requirementList", requirementList);
        setMap.remove("CURRENT_ToItemID");

        setMap.put("CURRENT_ITEM", setMap.get("s_itemID"));
        setMap.put("itemTypeCode", "CN00109");
        toCheckList = this.commonService.selectList("report_SQL.getChildItemsForWord", setMap);

        toCheckList = getConItemInfo(toCheckList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, "CN00109", "ToItemID");
        totalMap.put("attrToCheckNameMap", attrRsNameMap);
        totalMap.put("attrToCheckHtmlMap", attrRsHtmlMap);
        totalMap.put("toCheckList", toCheckList);
        setMap.remove("CURRENT_ToItemID");

        cngtList = this.commonService.selectList("report_SQL.getItemChangeListRPT", setMap);

        List companyRuleList = new ArrayList();
        List guideLineProcList = new ArrayList();
        List standardFormList = new ArrayList();

        List positionList = new ArrayList();
        List knowledgeList = new ArrayList();

        setMap.remove("CURRENT_ToItemID");
        setMap.remove("CategoryCode");
        setMap.remove("toItemClassCode");
        setMap.put("CURRENT_ITEM", setMap.get("s_itemID"));
        setMap.put("itemTypeCode", "CN00107");
        companyRuleList = this.commonService.selectList("report_SQL.getChildItemsForWord", setMap);

        companyRuleList = getConItemInfo(companyRuleList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, "CN00107", "FromItemID");
        totalMap.put("attrCompanyRuleNameMap", attrRsNameMap);
        totalMap.put("attrCompanyRuleHtmlMap", attrRsHtmlMap);
        totalMap.put("companyRuleList", companyRuleList);

        setMap.remove("CURRENT_ITEM");
        setMap.remove("CURRENT_ToItemID");
        setMap.put("CURRENT_ITEM", setMap.get("s_itemID"));

        guideLineProcList = this.commonService.selectList("report_SQL.getChildItemsForWord", setMap);

        guideLineProcList = getConItemInfo(guideLineProcList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, "CN00105", "ToItemID");
        totalMap.put("attrGuideProcNameMap", attrRsNameMap);
        totalMap.put("attrGuideProcHtmlMap", attrRsHtmlMap);
        totalMap.put("guideLineProcList", guideLineProcList);

        setMap.remove("CURRENT_ITEM");
        setMap.remove("CURRENT_ToItemID");
        setMap.put("CURRENT_ToItemID", setMap.get("s_itemID"));
        setMap.put("itemTypeCode", "CN00201");
        setMap.remove("toItemClassCode");
        positionList = this.commonService.selectList("report_SQL.getChildItemsForWord", setMap);

        positionList = getConItemInfo(positionList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, "CN00201", "ToItemID");
        totalMap.put("attrPositionNameMap", attrRsNameMap);
        totalMap.put("attrPositionHtmlMap", attrRsHtmlMap);
        totalMap.put("positionList", positionList);

        setMap.remove("CURRENT_ITEM");
        setMap.remove("CURRENT_ToItemID");
        setMap.put("CURRENT_ITEM", setMap.get("s_itemID"));
        setMap.put("itemTypeCode", "CN00112");
        setMap.remove("toItemClassCode");
        knowledgeList = this.commonService.selectList("report_SQL.getChildItemsForWord", setMap);

        knowledgeList = getConItemInfo(knowledgeList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, "CN00112", "FromItemID");
        totalMap.put("attrPositionNameMap", attrRsNameMap);
        totalMap.put("attrPositionHtmlMap", attrRsHtmlMap);
        totalMap.put("knowledgeList", knowledgeList);

        setMap.put("CURRENT_ITEM", setMap.get("s_itemID"));
        setMap.put("itemTypeCode", "CN00106");
        standardFormList = this.commonService.selectList("report_SQL.getChildItemsForWord", setMap);

        standardFormList = getConItemInfo(standardFormList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, "CN00106", "ToItemID");
        totalMap.put("attrGuideSystemNameMap", attrRsNameMap);
        totalMap.put("attrGuideSystemHtmlMap", attrRsHtmlMap);
        totalMap.put("standardFormList", standardFormList);
      }

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

  public void setModelMap(Map modelMap, HttpServletRequest request)
  {
    int width = 546;
    int height = 655;
    int actualWidth = 0;
    int actualHeight = 0;
    int zoom = 100;

    if ("2".equals(request.getParameter("paperSize"))) {
      width = 700;
      height = 967;
    }

    actualWidth = Integer.parseInt(StringUtil.checkNull(modelMap.get("Width"), String.valueOf(width)));
    actualHeight = Integer.parseInt(StringUtil.checkNull(modelMap.get("Height"), String.valueOf(height)));

    if ((width < actualWidth) || (height < actualHeight)) {
      for (int i = 99; i > 1; i--) {
        actualWidth = actualWidth * i / 100;
        actualHeight = actualHeight * i / 100;
        if ((width > actualWidth) && (height > actualHeight)) {
          zoom = i;
          break;
        }
      }
    }

    modelMap.remove("Width");
    modelMap.remove("Height");
    modelMap.put("Width", Integer.valueOf(actualWidth));
    modelMap.put("Height", Integer.valueOf(actualHeight));
    System.out.println("Width==" + actualWidth);
    System.out.println("Height==" + actualHeight);
  }

  public List getE2EModelList(String modelId, String symTypeCode, String parent)
    throws Exception
  {
    Map map = new HashMap();
    map.put("ModelID", modelId);
    map.put("SymTypeCode", symTypeCode);
    map.put("Parent", parent);
    List returnModelList = this.commonService.selectList("report_SQL.getE2EMElementList", map);
    return returnModelList;
  }

  private List getCnItemList(List list, Map setMap)
  {
    setMap.put("parentID", setMap.get("s_itemID"));
    String className = "";

    List pertinentDetailList = new ArrayList();
    List relItemRowList = new ArrayList();
    Map classNameMap = new HashMap();
    int classNameCnt = 1;
    String strClassName = "";

    setMap.remove("attrTypeCode");

    for (int i = 0; i < list.size(); i++) {
      Map pertinentMap = (Map)list.get(i);
      String itemId = pertinentMap.get("s_itemID").toString();
      setMap.put("s_itemID", itemId);
      setMap.put("s_itemID", itemId);

      if (pertinentMap.get("ClassName") != null) {
        if (className.isEmpty()) {
          className = pertinentMap.get("ClassName").toString();
          strClassName = className;
          pertinentDetailList.add(removeAllHtmlTagAndSetAttrInfo(pertinentMap));
        }
        else if (className.equals(pertinentMap.get("ClassName").toString())) {
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

      if (i == list.size() - 1) {
        relItemRowList.add(pertinentDetailList);
      }

    }

    return relItemRowList;
  }

  private List getElementList(Map setMap2, Map modelMap)
    throws Exception
  {
    List returnList = new ArrayList();

    setMap2.remove("FromID");
    setMap2.remove("ToID");
    setMap2.put("ModelID", modelMap.get("ModelID"));
    setMap2.put("SymTypeCode", "SB00004");
    List elementList = this.commonService.selectList("report_SQL.getElementOfModel", setMap2);
    setMap2.remove("SymTypeCode");

    for (int i = 0; elementList.size() > i; i++) {
      Map returnMap = new HashMap();
      Map elementMap = (Map)elementList.get(i);
      String elementId = String.valueOf(elementMap.get("ElementID"));
      String objectId = String.valueOf(elementMap.get("ObjectID"));

      returnMap.put("RNUM", Integer.valueOf(i + 1));

      setMap2.remove("ToID");
      setMap2.put("FromID", elementId);
      List preList = this.commonService.selectList("report_SQL.getElementOfModel", setMap2);

      setMap2.remove("FromID");
      setMap2.put("ToID", elementId);
      List postList = this.commonService.selectList("report_SQL.getElementOfModel", setMap2);

      if ((preList.size() > 0) && (postList.size() > 0))
        returnMap.put("KBN", "Post");
      else if ((preList.size() > 0) && (postList.size() == 0))
        returnMap.put("KBN", "Pre");
      else if ((preList.size() == 0) && (postList.size() > 0))
        returnMap.put("KBN", "Post");
      else {
        returnMap.put("KBN", "");
      }

      setMap2.put("s_itemID", objectId);
      Map itemInfoMap = this.commonService.select("report_SQL.getItemInfo", setMap2);
      returnMap.put("ID", itemInfoMap.get("Identifier"));
      returnMap.put("Name", itemInfoMap.get("ItemName"));
      returnMap.put("Description", itemInfoMap.get("Description"));

      returnList.add(returnMap);
    }

    return returnList;
  }

  private List getActivityAttr(List List, String defaultLang, String sessionCurrLangType, Map attrNameMap, Map attrHtmlMap)
    throws Exception
  {
    List resultList = new ArrayList();
    Map setMap = new HashMap();
    List actToCheckList = new ArrayList();
    List actRuleSetList = new ArrayList();
    List actSystemList = new ArrayList();
    List actRoleList = new ArrayList();

    for (int i = 0; i < List.size(); i++) {
      Map listMap = new HashMap();
      listMap = (Map)List.get(i);
      String itemId = String.valueOf(listMap.get("ItemID"));

      setMap.put("ItemID", itemId);
      setMap.put("DefaultLang", defaultLang);
      setMap.put("sessionCurrLangType", sessionCurrLangType);

      List attrList = this.commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);

      for (int k = 0; attrList.size() > k; k++) {
        Map map = (Map)attrList.get(k);
        listMap.put(map.get("AttrTypeCode"), map.get("PlainText"));
      }

      setMap.put("languageID", sessionCurrLangType);

      setMap.put("CURRENT_ITEM", itemId);
      setMap.put("itemTypeCode", "CN00107");
      actRuleSetList = this.commonService.selectList("report_SQL.getChildItemsForWord", setMap);

      actRuleSetList = getConItemInfo(actRuleSetList, defaultLang, sessionCurrLangType, attrNameMap, attrHtmlMap, "CN00107", "ToItemID");
      listMap.put("actRuleSetList", actRuleSetList);
      setMap.remove("CURRENT_ITEM");

      setMap.put("CURRENT_ITEM", itemId);
      setMap.put("itemTypeCode", "CN00109");
      actToCheckList = this.commonService.selectList("report_SQL.getChildItemsForWord", setMap);

      actToCheckList = getConItemInfo(actToCheckList, defaultLang, sessionCurrLangType, attrNameMap, attrHtmlMap, "CN00109", "ToItemID");
      listMap.put("actToCheckList", actToCheckList);
      setMap.remove("CURRENT_ITEM");

      setMap.put("CURRENT_ITEM", itemId);
      setMap.put("itemTypeCode", "CN00104");
      actSystemList = this.commonService.selectList("report_SQL.getChildItemsForWord", setMap);

      actSystemList = getConItemInfo(actSystemList, defaultLang, sessionCurrLangType, attrNameMap, attrHtmlMap, "CN00104", "ToItemID");
      listMap.put("actSystemList", actSystemList);
      setMap.remove("CURRENT_ITEM");

      setMap.put("CURRENT_ToItemID", itemId);
      setMap.put("itemTypeCode", "CN00201");
      actRoleList = this.commonService.selectList("report_SQL.getChildItemsForWord", setMap);

      actRoleList = getConItemInfo(actRoleList, defaultLang, sessionCurrLangType, attrNameMap, attrHtmlMap, "CN00201", "FromItemID");
      listMap.put("actRoleList", actRoleList);
      setMap.remove("CURRENT_ToItemID");

      resultList.add(listMap);
    }

    return resultList;
  }

  private List getRuleSetAttr(List List, String defaultLang, String sessionCurrLangType, Map attrRsNameMap, Map attrRsHtmlMap)
    throws Exception
  {
    List resultList = new ArrayList();
    Map setMap = new HashMap();

    for (int i = 0; i < List.size(); i++) {
      Map listMap = new HashMap();
      listMap = (Map)List.get(i);
      String itemId = String.valueOf(listMap.get("s_itemID"));

      setMap.put("ItemID", itemId);
      setMap.put("DefaultLang", defaultLang);
      setMap.put("sessionCurrLangType", sessionCurrLangType);

      List attrList = this.commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);

      for (int k = 0; attrList.size() > k; k++) {
        Map map = (Map)attrList.get(k);
        listMap.put(map.get("AttrTypeCode"), map.get("PlainText"));
        attrRsNameMap.put(map.get("AttrTypeCode"), map.get("Name"));
        attrRsHtmlMap.put(map.get("AttrTypeCode"), map.get("HTML"));
      }

      resultList.add(listMap);
    }

    return resultList;
  }

  private List getConItemInfo(List List, String defaultLang, String sessionCurrLangType, Map attrRsNameMap, Map attrRsHtmlMap, String cnTypeCode, String source)
    throws Exception
  {
    List resultList = new ArrayList();
    Map setMap = new HashMap();

    for (int i = 0; i < List.size(); i++) {
      Map listMap = new HashMap();
      List resultSubList = new ArrayList();

      listMap = (Map)List.get(i);
      String itemId = String.valueOf(listMap.get(source));

      setMap.put("ItemID", itemId);
      setMap.put("DefaultLang", defaultLang);
      setMap.put("sessionCurrLangType", sessionCurrLangType);
      List attrList = this.commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);

      String plainText = "";
      for (int k = 0; attrList.size() > k; k++) {
        Map map = (Map)attrList.get(k);
        attrRsNameMap.put(map.get("AttrTypeCode"), map.get("Name"));
        attrRsHtmlMap.put(map.get("AttrTypeCode"), map.get("HTML"));
        if (map.get("DataType").equals("MLOV")) {
          plainText = getMLovVlaue(sessionCurrLangType, itemId, StringUtil.checkNull(map.get("AttrTypeCode")));
          listMap.put(map.get("AttrTypeCode"), plainText);
        } else {
          listMap.put(map.get("AttrTypeCode"), map.get("PlainText"));
        }
      }

      String isFromItem = "Y";
      if (!source.equals("FromItemID")) isFromItem = "N";
      setMap.put("varFilter", cnTypeCode);
      setMap.put("languageID", sessionCurrLangType);
      setMap.put("isFromItem", isFromItem);
      setMap.put("s_itemID", itemId);
      List relatedAttrList = new ArrayList();

      if (isFromItem.equals("Y"))
        resultSubList.add(StringUtil.checkNull(listMap.get("fromItemIdentifier")) + " " + removeAllTag(StringUtil.checkNull(listMap.get("fromItemName"))));
      else {
        resultSubList.add(StringUtil.checkNull(listMap.get("toItemIdentifier")) + " " + removeAllTag(StringUtil.checkNull(listMap.get("toItemName"))));
      }
      setMap.put("ItemID", listMap.get("FromItemID"));
      setMap.put("DefaultLang", defaultLang);
      setMap.put("sessionCurrLangType", sessionCurrLangType);
      relatedAttrList = this.commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
      if (relatedAttrList.size() > 0) {
        for (int m = 0; m < relatedAttrList.size(); m++) {
          Map relAttrMap = (Map)relatedAttrList.get(m);
          resultSubList.add(StringUtil.checkNull(relAttrMap.get("Name")));
          resultSubList.add(StringUtil.checkNull(relAttrMap.get("PlainText")));
          resultSubList.add(StringUtil.checkNull(relAttrMap.get("HTML")));
        }
      }

      listMap.put("resultSubList", resultSubList);

      resultList.add(listMap);
    }

    return resultList;
  }

  private String getMLovVlaue(String languageID, String itemID, String attrTypeCode) throws Exception {
    List mLovList = new ArrayList();
    Map setMap = new HashMap();
    String defaultLang = this.commonService.selectString("item_SQL.getDefaultLang", setMap);
    setMap.put("languageID", languageID);
    setMap.put("defaultLang", defaultLang);
    setMap.put("itemID", itemID);
    setMap.put("attrTypeCode", attrTypeCode);
    mLovList = this.commonService.selectList("attr_SQL.getMLovList", setMap);
    String plainText = "";
    if (mLovList.size() > 0) {
      for (int j = 0; j < mLovList.size(); j++) {
        Map mLovListMap = (HashMap)mLovList.get(j);
        if (j == 0)
          plainText = StringUtil.checkNull(mLovListMap.get("Value"));
        else {
          plainText = plainText + " / " + mLovListMap.get("Value");
        }
      }
    }
    return plainText;
  }

  @RequestMapping({"/excelImport.do"})
  public String excelImport(HttpServletRequest request, HashMap commandMap, ModelMap model)
    throws Exception
  {
    try
    {
      commandMap.put("AuthorID", commandMap.get("sessionUserId"));
      commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
      List returnData = this.commonService.selectList("project_SQL.getCsrListWithMember", commandMap);
      model.put("csrOption", returnData);

      model.put("languageID", commandMap.get("sessionCurrLangType"));
      model.put("s_itemID", request.getParameter("itemID"));
      model.put("option", request.getParameter("ArcCode"));
      model.put("menu", getLabel(request, this.commonService));
    }
    catch (Exception e)
    {
      System.out.println(e.toString());
    }

    return nextUrl("/report/excelImport");
  }

  @RequestMapping({"/itemExcelUpload.do"})
  public String itemExcelUpload(HashMap commandFileMap, HashMap commandMap, ModelMap model) throws Exception {
    Map target = new HashMap();

    int line = 0;
    try
    {
      List list = (List)commandFileMap.get("STORED_FILES");
      Map map = (Map)list.get(0);

      String sys_file_name = (String)map.get("SysFileNm");
      String file_path = "";
      String file_id = (String)map.get("AttFileID");

      HashMap drmInfoMap = new HashMap();
      String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
      String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
      String teamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
      String teamName = StringUtil.checkNull(commandMap.get("sessionTeamName"));
      drmInfoMap.put("userID", userID);
      drmInfoMap.put("userName", userName);
      drmInfoMap.put("teamID", teamID);
      drmInfoMap.put("teamName", teamName);

      String filePath = FileUtil.FILE_UPLOAD_DIR + sys_file_name;

      String errorCheckfilePath = GlobalVal.FILE_EXPORT_DIR;

      Map excelMap = new HashMap();
      int total_cnt = 0;
      int valid_cnt = 0;
      int attrTypeCode_cnt = 0;
      String colsName = "";
      String headerName = "";

      SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
      long date = System.currentTimeMillis();
      String fileName = "Upload_ERROR_" + formatter.format(Long.valueOf(date)) + ".txt";
      String downFile = errorCheckfilePath + fileName;
      File file = new File(downFile);
      BufferedWriter errorLog = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file, true), "UTF-8"));

      excelMap = getItemList(new File(filePath), commandFileMap, commandMap, errorLog);

      errorLog.close();

      List arrayList = (List)excelMap.get("list");
      total_cnt = NumberUtil.getIntValue(excelMap.get("totalCnt"));
      valid_cnt = NumberUtil.getIntValue(excelMap.get("validCnt"));
      attrTypeCode_cnt = NumberUtil.getIntValue(excelMap.get("attrTypeCodeCnt"));
      colsName = excelMap.get("colsName").toString();
      if (commandFileMap.get("uploadTemplate").equals("4")) {
        headerName = excelMap.get("headerName").toString();
      }

      String jsonObject = "";
      if (arrayList.size() > 0) {
        String[] cols = colsName.split("[|]");
        int totalPage = 0;
        jsonObject = JsonUtil.parseGridJson(arrayList, cols, totalPage, 1, (String)commandFileMap.get("contextPath"));
        jsonObject = jsonObject.replace("<br/>", ", ");
      }

      System.out.println("total_cnt==" + total_cnt);
      System.out.println("valid_cnt==" + valid_cnt);

      String type = StringUtil.checkNull(commandFileMap.get("uploadTemplate"));
      target.put("SCRIPT", "parent.doCntReturn('');parent.$('#isSubmit').remove();");
      System.out.println("attrTypeCode_cnt == " + attrTypeCode_cnt);
      System.out.println("type == " + type);
      System.out.println("file_id == " + file_id);
      System.out.println("jsonObject == " + jsonObject);
      System.out.println("headerName == " + headerName);

      String errMsgYN = "";
      if (excelMap.get("msg") != null)
        errMsgYN = "Y";
      else errMsgYN = "N";
      target.put("SCRIPT", "parent.doCntReturn('" + total_cnt + "','" + valid_cnt + "','" + attrTypeCode_cnt + "','" + type + "','" + file_id + "','" + jsonObject + "','" + headerName + "','" + errMsgYN + "','" + fileName + "','" + downFile + "');");

      if (excelMap.get("msg") != null) {
        errorLog.close();
      }
      else
      {
        file.delete();
      }
    }
    catch (Exception e)
    {
      target.put("SCRIPT", "parent.$('#isSubmit').remove();");

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00072", new String[] { e.getMessage().replaceAll("\"", "") }));
    }

    model.addAttribute("resultMap", target);

    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }
  @RequestMapping({"/itemExcelSave.do"})
  public String itemExcelSave(HashMap commandMap, ModelMap model) throws Exception {
    Map target = new HashMap();
    try
    {
      String itemTypeCode = StringUtil.checkNull(this.commonService.selectString("item_SQL.selectedItemTypeCode", commandMap));
      String itemTypeCodeCN = StringUtil.checkNull(this.commonService.selectString("item_SQL.selectedConItemTypeCode", commandMap));

      List userInfoList = this.commonService.selectList("report_SQL.getUserInfo", commandMap);
      Map userInfoMap = (Map)userInfoList.get(0);

      commandMap.put("companyID", userInfoMap.get("CompanyID"));
      commandMap.put("OwnerTeamID", userInfoMap.get("TeamID"));

      commandMap.put("itemTypeCode", itemTypeCode);
      commandMap.put("itemTypeCodeCN", itemTypeCodeCN);

      this.reportService.save(commandMap);

      String msg = MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00088");

      if (commandMap.containsKey("infoMsg")) {
        msg = msg + commandMap.get("infoMsg").toString();
      }

      target.put("ALERT", msg);
      target.put("SCRIPT", "parent.doSaveReturn();parent.$('#isSubmit').remove()");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00073", new String[] { e.getMessage().replaceAll("\"", "") }));
    }
    model.addAttribute("resultMap", target);

    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  @RequestMapping({"/exeConsolidation.do"})
  public String exeConsolidation(HttpServletRequest request, HashMap commandMap, ModelMap model)
    throws Exception
  {
    HashMap target = new HashMap();
    try
    {
      Map setMap = new HashMap();
      String items = request.getParameter("items").toString();
      String masterItemId = request.getParameter("masterItemId").toString();
      String[] arrayItems = items.split(",");

      for (int i = 0; i < arrayItems.length; i++) {
        String targetItemId = arrayItems[i];
        setMap.put("masterItemId", masterItemId);
        setMap.put("targetItemId", targetItemId);
        this.commonService.update("report_SQL.exeConsolidation", setMap);
      }

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
      target.put("SCRIPT", "this.$('#isSubmit').remove();");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "this.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  @RequestMapping({"/html.do"})
  public String html(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    Map target = new HashMap();

    String url = "/report/html";
    try
    {
      String schType = "";
      Map setMap = new HashMap();
      setMap.put("languageID", request.getParameter("languageID"));
      setMap.put("s_itemID", request.getParameter("s_itemID"));
      setMap.put("s_itemID", request.getParameter("s_itemID"));
      setMap.put("ArcCode", request.getParameter("option"));

      int totCnt = NumberUtil.getIntValue(this.commonService.selectString("report_SQL.processTotalCnt", setMap));
      this._log.info("totCnt=" + totCnt);
      if (totCnt > 0) setMap.put("schType", "FROM"); else {
        setMap.put("schType", "TO");
      }

      Map mapValue = new HashMap();

      List prcList = removeAllHtmlTag(this.commonService.selectList("report_SQL.getItemInfo", setMap));

      List attributesList = this.commonService.selectList("report_SQL.itemAttributesInfo", setMap);
      List attributesNameList = this.commonService.selectList("report_SQL.getAttrDicName", setMap);

      Map attrNameMap = new HashMap();
      Map attrTextMap = new HashMap();
      mapValue = new HashMap();
      for (int i = 0; i < attributesList.size(); i++) {
        mapValue = (HashMap)attributesList.get(i);
        attrTextMap.put(mapValue.get("AttrTypeCode"), mapValue.get("PlainText"));
      }

      for (int i = 0; i < attributesNameList.size(); i++) {
        mapValue = (HashMap)attributesNameList.get(i);
        attrNameMap.put(mapValue.get("TypeCode"), mapValue.get("Name"));
      }

      if (!"".equals(commandMap.get("sessionParamSubItems"))) {
        setMap.put("sessionParamSubItems", commandMap.get("sessionParamSubItems").toString());
      }

      List subModelList = this.commonService.selectList("item_SQL.getSubItemList_gridList", setMap);

      if (!"".equals(commandMap.get("sessionParamSubItems"))) {
        setMap.remove("sessionParamSubItems");
      }

      List relItemList = this.commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);

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
        Map pertinentMap = (Map)relItemList.get(i);
        String itemId = pertinentMap.get("s_itemID").toString();
        setMap.put("s_itemID", itemId);
        setMap.put("s_itemID", itemId);

        if (pertinentMap.get("ClassName") != null) {
          if (className.isEmpty()) {
            className = pertinentMap.get("ClassName").toString();
            strClassName = className;
            pertinentDetailList.add(removeAllHtmlTagAndSetAttrInfo(pertinentMap));
          }
          else if (className.equals(pertinentMap.get("ClassName").toString())) {
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

        if (i == relItemList.size() - 1) {
          relItemRowList.add(pertinentDetailList);
        }
      }

      model.put("menu", getLabel(request, this.commonService));
      model.put("strClassName", strClassName);
      model.put("prcList", prcList);

      model.put("attrNameMap", attrNameMap);
      model.put("attrTextMap", attrTextMap);

      model.put("subModelList", subModelList);

      model.put("relItemRowList", relItemRowList);

      model.put("s_itemID", request.getParameter("s_itemID"));

      model.put("setMap", setMap);
    }
    catch (Exception e) {
      System.out.println(e.toString());
    }

    return nextUrl(url);
  }

  @RequestMapping({"/programHtml.do"})
  public String programHtml(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    Map target = new HashMap();

    String url = "/report/programHtml";
    try
    {
      String schType = "";
      Map setMap = new HashMap();
      setMap.put("languageID", request.getParameter("languageID"));
      setMap.put("LanguageID", request.getParameter("languageID"));
      setMap.put("s_itemID", request.getParameter("s_itemID"));
      setMap.put("s_itemID", request.getParameter("s_itemID"));
      setMap.put("ArcCode", request.getParameter("option"));

      int totCnt = NumberUtil.getIntValue(this.commonService.selectString("report_SQL.processTotalCnt", setMap));
      this._log.info("totCnt=" + totCnt);
      if (totCnt > 0) setMap.put("schType", "FROM"); else {
        setMap.put("schType", "TO");
      }

      Map menuMap = new HashMap();
      Map mapValue = new HashMap();

      List prcList = removeAllHtmlTag(this.commonService.selectList("report_SQL.getItemInfo", setMap));

      String classCode = (String)((HashMap)prcList.get(0)).get("ClassCode");

      List attributesList = new ArrayList();
      List attributesNameList = new ArrayList();
      List programStatusList = new ArrayList();

      Map attrNameMap = new HashMap();
      Map attrTextMap = new HashMap();
      Map pgrStsMap = new HashMap();

      if ("CL04005".equals(classCode))
      {
        setMap.put("FromTypeCode", "AT00038");
        setMap.put("ToTypeCode", "AT00072");
        attributesList = this.commonService.selectList("report_SQL.itemAttrInfoForProgram", setMap);
        attributesNameList = this.commonService.selectList("report_SQL.getAttrDicNameForProgram", setMap);

        mapValue = new HashMap();
        for (int i = 0; i < attributesList.size(); i++) {
          mapValue = (HashMap)attributesList.get(i);
          attrTextMap.put(mapValue.get("AttrTypeCode"), mapValue.get("PlainText"));
        }

        for (int i = 0; i < attributesNameList.size(); i++) {
          mapValue = (HashMap)attributesNameList.get(i);
          attrNameMap.put(mapValue.get("TypeCode"), mapValue.get("Name"));
        }

        setMap.put("Category", "PGRSTS");
        programStatusList = this.commonService.selectList("project_SQL.getChangeSetInsertInfo", setMap);

        for (int i = 0; i < programStatusList.size(); i++) {
          mapValue = (HashMap)programStatusList.get(i);
          pgrStsMap.put(mapValue.get("TypeCode"), mapValue.get("Name"));
        }

      }
      else
      {
        setMap.put("FromTypeCode", "AT00039");
        setMap.put("ToTypeCode", "AT00101");
        attributesList = this.commonService.selectList("report_SQL.itemAttrInfoForProgram", setMap);
        attributesNameList = this.commonService.selectList("report_SQL.getAttrDicNameForProgram", setMap);

        mapValue = new HashMap();
        for (int i = 0; i < attributesList.size(); i++) {
          mapValue = (HashMap)attributesList.get(i);
          attrTextMap.put(mapValue.get("AttrTypeCode"), mapValue.get("PlainText"));
        }

        for (int i = 0; i < attributesNameList.size(); i++) {
          mapValue = (HashMap)attributesNameList.get(i);
          attrNameMap.put(mapValue.get("TypeCode"), mapValue.get("Name"));
        }

        setMap.put("Category", "IFSTS");
        programStatusList = this.commonService.selectList("project_SQL.getChangeSetInsertInfo", setMap);

        for (int i = 0; i < programStatusList.size(); i++) {
          mapValue = (HashMap)programStatusList.get(i);
          pgrStsMap.put(mapValue.get("TypeCode"), mapValue.get("Name"));
        }

      }

      List relItemList = this.commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);

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
        Map pertinentMap = (Map)relItemList.get(i);
        String itemId = pertinentMap.get("s_itemID").toString();
        setMap.put("s_itemID", itemId);
        setMap.put("s_itemID", itemId);

        if (pertinentMap.get("ClassName") != null) {
          if (className.isEmpty()) {
            className = pertinentMap.get("ClassName").toString();
            strClassName = className;
            pertinentDetailList.add(removeAllHtmlTagAndSetAttrInfo(pertinentMap));
          }
          else if (className.equals(pertinentMap.get("ClassName").toString())) {
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

        if (i == relItemList.size() - 1) {
          relItemRowList.add(pertinentDetailList);
        }

      }

      model.put("menu", getLabel(request, this.commonService));
      model.put("prcList", prcList);

      model.put("attrNameMap", attrNameMap);
      model.put("attrTextMap", attrTextMap);
      model.put("pgrStsMap", pgrStsMap);

      model.put("classCode", classCode);

      model.put("programStatusList", programStatusList);
      model.put("strClassName", strClassName);
      model.put("relItemRowList", relItemRowList);

      model.put("s_itemID", request.getParameter("s_itemID"));

      model.put("setMap", setMap);
    }
    catch (Exception e) {
      System.out.println(e.toString());
    }

    return nextUrl(url);
  }

  @RequestMapping({"/downloadCNListPop.do"})
  public String downloadCNListPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    Map target = new HashMap();
    String url = "/report/downloadCNListPop";
    try
    {
      Map setMap = new HashMap();
      setMap.put("s_itemID", commandMap.get("itemID"));
      String itemTypeCode = this.commonService.selectString("config_SQL.getItemTypeCodeItemID", setMap);

      model.put("itemTypeCode", itemTypeCode);
      model.put("s_itemID", commandMap.get("s_itemID"));
      model.put("menu", getLabel(request, this.commonService));
    }
    catch (Exception e) {
      System.out.println(e.toString());
    }

    return nextUrl(url);
  }

  @RequestMapping({"/downloadCNList.do"})
  public String downloadCNList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    Map target = new HashMap();
    String url = "/report/downloadCNList";
    try {
      Map setMap = new HashMap();
      model.put("itemTypeCode", request.getParameter("itemTypeCode"));
      model.put("s_itemID", commandMap.get("s_itemID"));
      model.put("menu", getLabel(request, this.commonService));
    }
    catch (Exception e) {
      System.out.println(e.toString());
    }

    return nextUrl(url);
  }

  @RequestMapping({"/downloadCNCountPop.do"})
  public String downloadCNCountPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    Map target = new HashMap();
    String url = "/report/downloadCNCountPop";
    try
    {
      Map setMap = new HashMap();
      setMap.put("s_itemID", commandMap.get("itemID"));
      String itemTypeCode = this.commonService.selectString("config_SQL.getItemTypeCodeItemID", setMap);

      model.put("itemTypeCode", itemTypeCode);
      model.put("s_itemID", commandMap.get("s_itemID"));
      model.put("menu", getLabel(request, this.commonService));
    }
    catch (Exception e) {
      System.out.println(e.toString());
    }

    return nextUrl(url);
  }

  private List removeAllHtmlTag(List List) {
    List resultList = new ArrayList();
    for (int i = 0; i < List.size(); i++) {
      Map listMap = new HashMap();
      listMap = (Map)List.get(i);
      String description = "";
      if (listMap.get("Description") != null) {
        description = listMap.get("Description").toString().replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
      }
      listMap.put("StringDescription", description);
      resultList.add(listMap);
    }

    return resultList;
  }

  private List removeAllHtmlTagAndSetAttrInfo(List List, Map map) {
    List resultList = new ArrayList();

    if (List.size() == 0)
      resultList.add(map);
    else {
      for (int i = 0; i < List.size(); i++) {
        Map listMap = new HashMap();
        listMap = (Map)List.get(i);
        String description = "";
        if (map.get("ProcessInfo") != null) {
          description = map.get("ProcessInfo").toString().replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
        }

        listMap.put("ProcessInfo", description);

        if (map.get("ClassName") != null) {
          listMap.put("ClassName", map.get("ClassName").toString());
        }

        if (map.get("ItemID") != null) {
          listMap.put("ItemID", map.get("ItemID").toString());
        }

        if (map.get("ItemName") != null) {
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

    if (map.get("ProcessInfo") != null) {
      description = map.get("ProcessInfo").toString().replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
    }

    listMap.put("ProcessInfo", description);

    if (map.get("ClassName") != null) {
      listMap.put("ClassName", map.get("ClassName").toString());
    }

    if (map.get("s_itemID") != null) {
      listMap.put("s_itemID", map.get("s_itemID").toString());
    }

    if (map.get("Identifier") != null) {
      listMap.put("Identifier", map.get("Identifier").toString());
    }

    if (map.get("ItemName") != null) {
      listMap.put("ItemName", map.get("ItemName").toString());
    }

    if (map.get("LastUpdated") != null) {
      listMap.put("LastUpdated", map.get("LastUpdated").toString());
    }

    return listMap;
  }

  protected Map fetchRowData(Map map, int index) throws Exception {
    Map result = new HashMap();
    int colNum = NumberUtil.getIntValue(map.get("colNum"));
    String[] cols = ((String)map.get("colName")).split("[|]");

    for (int i = 1; i < colNum; i++) {
      result.put(cols[(i - 1)], map.get("r" + index + "_col" + i));
    }
    result.put("type", map.get("r" + index + "_type"));
    if (map.get("loginInfo") != null) {
      result.putAll((Map)map.get("loginInfo"));
    }
    return result;
  }

  private Map getItemList(File excelFile, HashMap commandFileMap, HashMap commandMap, BufferedWriter errorLog) throws Exception
  {
    Map excelMap = new HashMap();

    XSSFWorkbook workbook = new XSSFWorkbook(new FileInputStream(excelFile));
    XSSFSheet sheet = null;
    try
    {
      sheet = workbook.getSheetAt(0);

      int rowCount = sheet.getPhysicalNumberOfRows();

      if (rowCount <= 1) {
        throw new Exception("There is not data in excel file.");
      }

      if ((commandFileMap.get("uploadTemplate").equals("1")) || (commandFileMap.get("uploadTemplate").equals("2")))
      {
        excelMap = setUploadMapNew(sheet, commandFileMap.get("uploadTemplate").toString(), commandFileMap.get("uploadOption").toString(), commandMap, errorLog);
      }
      else if (commandFileMap.get("uploadTemplate").equals("3"))
      {
        excelMap = setUploadMapConnection(sheet, commandFileMap.get("uploadOption").toString(), commandMap, errorLog);
      }
      else if (commandFileMap.get("uploadTemplate").equals("4"))
      {
        excelMap = setUploadMapDimension(sheet, commandFileMap.get("uploadOption").toString(), commandMap, errorLog);
      }
      else if (commandFileMap.get("uploadTemplate").equals("10"))
      {
        excelMap = setUploadMapItemTeam(sheet, commandFileMap.get("uploadOption").toString(), commandMap, errorLog);
      }
      else if (commandFileMap.get("uploadTemplate").equals("11"))
      {
        excelMap = setUploadMapItemMember(sheet, commandFileMap.get("uploadOption").toString(), commandMap, errorLog);
      }

      Map localMap1 = excelMap;
      return localMap1;
    }
    catch (Exception e) {
      System.out.println(e.toString());
      throw e;
    } finally {
      try {
        workbook = null;
        sheet = null;
      } catch (Exception localException2) {
      }
    }
  }

  private String removeAllTag(String str)
  {
    str = str.replaceAll("\n", "&&rn");
    str = str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#10;", " ").replace("&#xa;", "").replace("&nbsp;", " ");

    return StringEscapeUtils.unescapeHtml4(str);
  }
  private String removeAllTag(String str, String type) {
    if (type.equals("DbToEx"))
      str = str.replaceAll("<br/>", "&&rn").replaceAll("<br />", "&&rn").replaceAll("\r\n", "&&rn").replaceAll("&gt;", ">").replaceAll("&lt;", "<").replaceAll("&#40;", "(").replaceAll("&#41;", ")").replace("&sect;", "-");
    else {
      str = str.replaceAll("\n", "&&rn");
    }
    str = str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#10;", " ").replace("&#xa;", "").replace("&nbsp;", " ").replace("&amp;", "&");
    if (type.equals("DbToEx")) {
      str = str.replaceAll("&&rn", "\n");
    }

    return StringEscapeUtils.unescapeHtml4(str);
  }

  private Map setUploadMapNew(XSSFSheet sheet, String temp, String option, HashMap commandMap, BufferedWriter errorLog)
    throws Exception
  {
    Map excelMap = new HashMap();

    String colsName = "";
    int attrTypeColNum = 1;
    String[][] data = null;
    List list = new ArrayList();
    List identifierList = new ArrayList();

    int valCnt = 0;
    int totalCnt = 0;

    int rowCount = sheet.getPhysicalNumberOfRows();
    int colCount = sheet.getRow(0).getPhysicalNumberOfCells();

    data = new String[rowCount][colCount];

    XSSFRow row = null;
    XSSFCell cell = null;

    String langCode = String.valueOf(commandMap.get("sessionCurrLangCode"));

    for (int i = 0; i < rowCount; i++)
    {
      row = sheet.getRow(i);

      for (int j = 0; j < colCount; j++) {
        cell = row.getCell(j);

        if (cell != null) {
          if (cell.getCellType() == 0)
            data[i][j] = StringUtil.checkNull(setDateYyyymmdd(cell, "yyyy-MM-dd"));
          else
            data[i][j] = StringUtil.checkNull(cell);
        }
        else {
          data[i][j] = StringUtil.checkNull(cell);
        }

        if ((i != 0) || (j <= 3))
          continue;
        if (data[i][j].isEmpty())
        {
          excelMap.put("msg", MessageHandler.getMessage(langCode + ".WM00110", new String[] { String.valueOf(j + 1), "AttrTypeCode" }));
          errorLog.write(MessageHandler.getMessage(langCode + ".WM00110", new String[] { String.valueOf(j + 1), "AttrTypeCode" }));
          errorLog.newLine();
        }

        excelMap.put("AttrTypeCode" + (j - 3), data[i][j]);
        colsName = colsName + "|" + "newPlainText" + (j - 3);
        attrTypeColNum++;
      }

      if (i <= 1) {
        continue;
      }
      String msg = checkValueForUploadNew(i, data, temp, option, identifierList, langCode, errorLog);
      if (!msg.isEmpty()) {
        excelMap.put("msg", msg);
      }

      identifierList.add(data[i][2]);

      Map map = new HashMap();
      map.put("RNUM", Integer.valueOf(i - 1));
      map.put("newParentIdentifier", data[i][0]);
      map.put("newItemId", data[i][1]);
      map.put("newIdentifier", data[i][2]);
      map.put("newClassCode", data[i][3]);
      for (int j = 1; j < attrTypeColNum; j++)
      {
        map.put("newPlainText" + j, replaceSingleQuotation(excelMap.get(new StringBuilder("AttrTypeCode").append(j).toString()).toString() + "::" + removeAllTag(StringUtil.checkNull(data[i][(3 + j)]))));
      }

      list.add(map);
      if (msg.isEmpty()) {
        valCnt++;
      }
      totalCnt++;
    }

    excelMap.put("list", list);
    excelMap.put("validCnt", Integer.valueOf(valCnt));
    excelMap.put("totalCnt", Integer.valueOf(totalCnt));
    excelMap.put("attrTypeCodeCnt", Integer.valueOf(attrTypeColNum));
    excelMap.put("colsName", "newParentIdentifier|newItemId|newIdentifier|newClassCode" + colsName);

    return excelMap;
  }

  private String checkValueForUploadNew(int i, String[][] data, String temp, String option, List identifierList, String langCode, BufferedWriter errorLog)
    throws Exception
  {
    String msg = "";
    Map commandMap = new HashMap();

    if (temp.equals("1"))
    {
      if ((!data[i][0].isEmpty()) && 
        (!identifierList.contains(data[i][0]))) {
        msg = MessageHandler.getMessage(langCode + ".WM00111", new String[] { String.valueOf(i + 1), "ParentIdentifier" });
        errorLog.write(msg);
        errorLog.newLine();
      }

      if (!data[i][1].isEmpty()) {
        commandMap.put("ProjectID", data[i][1]);
        String cnt = StringUtil.checkNull(this.commonService.selectString("report_SQL.getCSRCnt", commandMap));
        if (cnt.equals("0"))
        {
          msg = MessageHandler.getMessage(langCode + ".WM00108", new String[] { String.valueOf(i + 1), "CSR ID" });
          errorLog.write(msg);
          errorLog.newLine();
        }
      }

      if (data[i][2].isEmpty())
      {
        msg = MessageHandler.getMessage(langCode + ".WM00107", new String[] { String.valueOf(i + 1), "Identifier" });
        errorLog.write(msg);
        errorLog.newLine();
      }

      if (identifierList.contains(data[i][2]))
      {
        msg = MessageHandler.getMessage(langCode + ".WM00109", new String[] { String.valueOf(i + 1), "Identifier" });
        errorLog.write(msg);
        errorLog.newLine();
      }

      if (data[i][0].equals(data[i][2]))
      {
        msg = MessageHandler.getMessage(langCode + ".WM00109", new String[] { String.valueOf(i + 1), "Identifier" });
        errorLog.write(msg);
        errorLog.newLine();
      }

    }
    else if (option.equals("1"))
    {
      if (data[i][0].isEmpty())
      {
        msg = MessageHandler.getMessage(langCode + ".WM00107", new String[] { String.valueOf(i + 1), " ItemId" });
        errorLog.write(msg);
        errorLog.newLine();
      }
      else
      {
        commandMap.put("ItemID", data[i][0]);
        String cnt = StringUtil.checkNull(this.commonService.selectString("report_SQL.getCountWithItemId", commandMap));
        if (cnt.equals("0"))
        {
          msg = MessageHandler.getMessage(langCode + ".WM00108", new String[] { String.valueOf(i + 1), " ItemId" });
          errorLog.write(msg);
          errorLog.newLine();
        }

      }

    }
    else if (data[i][2].isEmpty())
    {
      msg = MessageHandler.getMessage(langCode + ".WM00107", new String[] { String.valueOf(i + 1), "Identifier" });
      errorLog.write(msg);
      errorLog.newLine();
    }
    else
    {
      commandMap.put("Identifier", data[i][2]);
      commandMap.put("ClassCode", data[i][3]);
      String cnt = StringUtil.checkNull(this.commonService.selectString("report_SQL.getCountWithIdentifier", commandMap));
      if (cnt.equals("0"))
      {
        msg = MessageHandler.getMessage(langCode + ".WM00108", new String[] { String.valueOf(i + 1), "Identifier" });
        errorLog.write(msg);
        errorLog.newLine();
      }

    }

    if (data[i][3].isEmpty())
    {
      msg = MessageHandler.getMessage(langCode + ".WM00107", new String[] { String.valueOf(i + 1), "ClassCode" });
      errorLog.write(msg);
      errorLog.newLine();
    }

    if ((data[i][4].isEmpty()) && (data[i][5].isEmpty()))
    {
      msg = MessageHandler.getMessage(langCode + ".WM00107", new String[] { String.valueOf(i + 1), "plainText" });
      errorLog.write(msg);
      errorLog.newLine();
    }

    return msg;
  }

  private Map setUploadMapCboList(XSSFSheet sheet)
    throws Exception
  {
    Map excelMap = new HashMap();

    String colsName = "newParentIdentifier|newProcessID|newItemName|newName|newCBOType|newCBOId|newCatagory|newDSAP|newPeriod|newDifficulty|newImportance|newPriority|newProductionCosts|newSystem|newModule|newProgramID|newTCode|newNote";

    int attrTypeColNum = 1;
    List list = new ArrayList();

    int valCnt = 0;
    int rowCount = sheet.getPhysicalNumberOfRows();

    XSSFRow row = null;
    XSSFCell cell = null;
    String parentIdentifier = "";

    String msg = checkValueForUploadCboList(sheet, rowCount);
    if (!msg.isEmpty()) {
      excelMap.put("msg", msg);
    }

    if (excelMap.get("msg") == null)
    {
      for (int i = 4; i < rowCount; i++)
      {
        row = sheet.getRow(i);
        int colCount = row.getPhysicalNumberOfCells();

        Map map = new HashMap();
        int kbn = 0;

        for (int j = 0; j < colCount; j++) {
          cell = row.getCell(j);

          if ((i == 4) && (j == 0)) {
            parentIdentifier = String.valueOf(cell);
          }

          map.put("RNUM", Integer.valueOf(i - 3));

          if (j == 0) {
            if ((StringUtil.checkNull(cell).isEmpty()) || (!parentIdentifier.equals(String.valueOf(cell)))) {
              kbn = 1;
              break;
            }

            map.put("newParentIdentifier", cell);
          }

          if (j == 3) map.put("newProcessID", cell);
          if (j == 4) map.put("newItemName", cell);
          if (j == 6) map.put("newName", cell);
          if (j == 7) map.put("newCBOType", cell);
          if (j == 8) map.put("newCBOId", cell.getRawValue());
          if (j == 9) map.put("newCatagory", cell);
          if (j == 10) map.put("newDSAP", cell);
          if (j == 11) map.put("newPeriod", cell);

          if (j == 14) map.put("newDifficulty", cell);
          if (j == 15) map.put("newImportance", cell);
          if (j == 16) map.put("newPriority", cell);
          if (j == 17) map.put("newProductionCosts", cell);
          if (j == 18) map.put("newSystem", cell);
          if (j == 19) map.put("newModule", cell);

          if (j == 45) map.put("newProgramID", cell);
          if (j == 46) map.put("newTCode", cell);
          if (j != 47) continue; map.put("newNote", StringUtil.checkNull(cell, "").replace("<br/>", ""));
        }

        if (kbn == 0) {
          list.add(map);
        }

        valCnt++;
      }

    }

    excelMap.put("list", list);
    excelMap.put("validCnt", Integer.valueOf(valCnt));
    excelMap.put("totalCnt", Integer.valueOf(valCnt));
    excelMap.put("attrTypeCodeCnt", Integer.valueOf(attrTypeColNum));
    excelMap.put("colsName", colsName);

    return excelMap;
  }

  private String checkValueForUploadCboList(XSSFSheet sheet, int rowCount)
    throws Exception
  {
    String msg = "";
    Map commandMap = new HashMap();

    XSSFRow row = null;
    XSSFCell cell = null;

    String parentIdentifier = "";

    for (int i = 4; i < rowCount; i++)
    {
      row = sheet.getRow(i);
      int colCount = row.getPhysicalNumberOfCells();

      Map map = new HashMap();
      int kbn = 0;

      for (int j = 0; j < colCount; j++) {
        cell = row.getCell(j);

        if ((i == 4) && (j == 0)) {
          parentIdentifier = String.valueOf(cell);
        }

        if (j == 0) {
          if ((StringUtil.checkNull(cell).isEmpty()) || (!parentIdentifier.equals(String.valueOf(cell)))) {
            kbn = 1;
            break;
          }

          if (StringUtil.checkNull(cell).isEmpty()) {
            msg = i + 1 + "행의 [모듈/시스템]을 입력해 주세요.";
            return msg;
          }

        }

        if ((j == 6) && 
          (StringUtil.checkNull(cell).isEmpty())) {
          msg = i + 1 + "행의 [개발항목]을 입력해 주세요.";
          return msg;
        }

        if ((j == 7) && 
          (StringUtil.checkNull(cell).isEmpty())) {
          msg = i + 1 + "행의 [CBO Type]을 입력해 주세요.";
          return msg;
        }

        if ((j != 8) || 
          (!StringUtil.checkNull(cell).isEmpty())) continue;
        msg = i + 1 + "행의 [CBO ID]을 입력해 주세요.";
        return msg;
      }

    }

    return msg;
  }

  private Map setUploadMapIfMaster(XSSFSheet sheet)
    throws Exception
  {
    Map excelMap = new HashMap();

    String colsName = "newParentIdentifier|newInterfaceID|newGroupName|newKanri|newTani|newSub|newIfName|newCboId|newProgramID|newProcessId|newItemName|newVariant|newGapId|newDSAP|newPeriod|newInOut|newOnLineOrBatch|newIfPeriod|newErp|newRfcDestination|newMw|newLegacy|newErpType|newMwType|newLegacyType|newErpTanto|newMwTanto|newLegacyTanto|newErpStatus|newMwStatus|newLegacyStatus|newTotalStatus|newTestPeriod|newIssue|newNote";

    int attrTypeColNum = 1;
    List list = new ArrayList();

    int valCnt = 0;
    int rowCount = sheet.getPhysicalNumberOfRows();

    XSSFRow row = null;
    XSSFCell cell = null;
    String parentIdentifier = "";

    String msg = checkValueForUploadIfMaster(sheet, rowCount);
    if (!msg.isEmpty()) {
      excelMap.put("msg", msg);
    }

    if (excelMap.get("msg") == null)
    {
      for (int i = 4; i < rowCount; i++)
      {
        row = sheet.getRow(i);
        int colCount = row.getPhysicalNumberOfCells();

        Map map = new HashMap();
        int kbn = 0;

        for (int j = 0; j < colCount; j++) {
          cell = row.getCell(j);

          if ((i == 4) && (j == 0)) {
            parentIdentifier = String.valueOf(cell);
          }

          map.put("RNUM", Integer.valueOf(i - 3));

          if (j == 0) {
            if ((StringUtil.checkNull(cell).isEmpty()) || (!parentIdentifier.equals(String.valueOf(cell)))) {
              kbn = 1;
              break;
            }

            map.put("newParentIdentifier", cell);
          }

          if (j == 1) map.put("newInterfaceID", cell.getRawValue());
          if (j == 2) map.put("newGroupName", cell);
          if (j == 3) map.put("newKanri", cell);
          if (j == 4) map.put("newTani", cell);
          if (j == 5) map.put("newSub", cell);
          if (j == 6) map.put("newIfName", cell);
          if (j == 7) map.put("newCboId", cell);
          if (j == 8) map.put("newProgramID", cell);
          if (j == 9) map.put("newProcessId", cell);
          if (j == 10) map.put("newItemName", cell);
          if (j == 11) map.put("newVariant", cell);
          if (j == 12) map.put("newGapId", cell);
          if (j == 13) map.put("newDSAP", cell);
          if (j == 14) map.put("newPeriod", cell);
          if (j == 15) map.put("newInOut", cell);
          if (j == 16) map.put("newOnLineOrBatch", cell);
          if (j == 17) map.put("newIfPeriod", cell);
          if (j == 18) map.put("newErp", cell);
          if (j == 19) map.put("newRfcDestination", cell);
          if (j == 20) map.put("newMw", cell);
          if (j == 21) map.put("newLegacy", cell);
          if (j == 22) map.put("newErpType", cell);
          if (j == 23) map.put("newMwType", cell);
          if (j == 24) map.put("newLegacyType", cell);
          if (j == 25) map.put("newErpTanto", cell);
          if (j == 26) map.put("newMwTanto", cell);
          if (j == 27) map.put("newLegacyTanto", cell);
          if (j == 28) map.put("newErpStatus", cell);
          if (j == 29) map.put("newMwStatus", cell);
          if (j == 30) map.put("newLegacyStatus", cell);
          if (j == 31) map.put("newTotalStatus", cell);
          if (j == 32) map.put("newTestPeriod", cell);

          if (j == 56) map.put("newIssue", StringUtil.checkNull(cell, "").replace("<br/>", ""));
          if (j != 57) continue; map.put("newNote", StringUtil.checkNull(cell, "").replace("<br/>", ""));
        }

        if (kbn == 0) {
          list.add(map);
        }

        valCnt++;
      }

    }

    excelMap.put("list", list);
    excelMap.put("validCnt", Integer.valueOf(valCnt));
    excelMap.put("totalCnt", Integer.valueOf(valCnt));
    excelMap.put("attrTypeCodeCnt", Integer.valueOf(attrTypeColNum));
    excelMap.put("colsName", colsName);

    return excelMap;
  }

  private String checkValueForUploadIfMaster(XSSFSheet sheet, int rowCount)
    throws Exception
  {
    String msg = "";
    Map commandMap = new HashMap();

    XSSFRow row = null;
    XSSFCell cell = null;

    String parentIdentifier = "";

    for (int i = 4; i < rowCount; i++)
    {
      row = sheet.getRow(i);
      int colCount = row.getPhysicalNumberOfCells();

      Map map = new HashMap();
      int kbn = 0;

      for (int j = 0; j < colCount; j++) {
        cell = row.getCell(j);

        if ((i == 4) && (j == 0)) {
          parentIdentifier = String.valueOf(cell);
        }

        if (j == 0) {
          if ((StringUtil.checkNull(cell).isEmpty()) || (!parentIdentifier.equals(String.valueOf(cell)))) {
            kbn = 1;
            break;
          }

          if (StringUtil.checkNull(cell).isEmpty()) {
            msg = i + 1 + "행의 [모듈/시스템]을 입력해 주세요.";
            return msg;
          }

        }

        if ((j == 1) && 
          (StringUtil.checkNull(cell).isEmpty())) {
          msg = i + 1 + "행의 [Interface ID]을 입력해 주세요.";
          return msg;
        }

        if ((j != 6) || 
          (!StringUtil.checkNull(cell).isEmpty())) continue;
        msg = i + 1 + "행의 [I/F 항목 명]을 입력해 주세요.";
        return msg;
      }

    }

    return msg;
  }

  private Map setUploadWholeCompanySystemItem(XSSFSheet sheet)
    throws Exception
  {
    Map excelMap = new HashMap();

    String colsName = "newParentIdentifier|newTaniSystemE|newTaniSystemK|newSystemOverview|newDate|newGenPart|newUserNum|newHidm|newSso|newSubSystemE|newSubSystemK|newWorkArea|newGroup|newUneiTeam|newUneiPart|newPL|newItTanto|newNewSmTanto|newOldSmTamto|newService1|newService2|newService3|newUrl";

    int attrTypeColNum = 1;
    List list = new ArrayList();

    int valCnt = 0;
    int rowCount = sheet.getPhysicalNumberOfRows();

    XSSFRow row = null;
    XSSFCell cell = null;

    String parentIdentifier = "";

    if (excelMap.get("msg") == null)
    {
      for (int i = 3; i < rowCount; i++)
      {
        row = sheet.getRow(i);
        int colCount = row.getPhysicalNumberOfCells();

        Map map = new HashMap();

        for (int j = 0; j < colCount; j++) {
          cell = row.getCell(j);

          map.put("RNUM", Integer.valueOf(i - 2));

          if (j == 1) map.put("newParentIdentifier", setCell(cell));
          if (j == 4) map.put("newTaniSystemE", setCell(cell));
          if (j == 5) map.put("newTaniSystemK", setCell(cell));
          if (j == 6) map.put("newSystemOverview", setCell(cell));
          if (j == 7) map.put("newDate", setDateYyyymmdd(cell, "yyyy-MM"));
          if (j == 8) map.put("newGenPart", setCell(cell));
          if (j == 9) map.put("newUserNum", setCell(cell));
          if (j == 10) map.put("newHidm", setCell(cell));
          if (j == 11) map.put("newSso", setCell(cell));

          if (j == 12) map.put("newSubSystemE", setCell(cell));
          if (j == 13) map.put("newSubSystemK", setCell(cell));
          if (j == 14) map.put("newWorkArea", setCell(cell));
          if (j == 15) map.put("newGroup", setCell(cell));
          if (j == 16) map.put("newUneiTeam", setCell(cell));
          if (j == 17) map.put("newUneiPart", setCell(cell));
          if (j == 18) map.put("newPL", setCell(cell));
          if (j == 19) map.put("newItTanto", setCell(cell));
          if (j == 20) map.put("newNewSmTanto", setCell(cell));
          if (j == 21) map.put("newOldSmTamto", setCell(cell));
          if (j == 22) map.put("newService1", setCell(cell));
          if (j == 23) map.put("newService2", setCell(cell));
          if (j == 24) map.put("newService3", setCell(cell));
          if (j != 25) continue; map.put("newUrl", setCell(cell));
        }

        list.add(map);

        valCnt++;
      }

    }

    excelMap.put("list", list);
    excelMap.put("validCnt", Integer.valueOf(valCnt));
    excelMap.put("totalCnt", Integer.valueOf(valCnt));
    excelMap.put("attrTypeCodeCnt", Integer.valueOf(attrTypeColNum));
    excelMap.put("colsName", colsName);

    return excelMap;
  }

  private String setCell(XSSFCell cell)
  {
    return StringUtil.checkNull(cell).replaceAll(System.getProperty("line.separator"), "");
  }

  private Map setUploadMapConnection(XSSFSheet sheet, String option, HashMap commandMap, BufferedWriter errorLog)
    throws Exception
  {
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

    for (int i = 0; i < rowCount; i++)
    {
      row = sheet.getRow(i);
      colCount = row.getPhysicalNumberOfCells();

      for (int j = 0; j < colCount; j++) {
        cell = row.getCell(j);

        if (cell.getCellType() == 0)
          data[i][j] = StringUtil.checkNull(cell.getRawValue());
        else {
          data[i][j] = StringUtil.checkNull(cell);
        }

      }

      if (i > 0)
      {
        String msg = checkValueForConnection(i, data, option, langCode, errorLog);
        if (!msg.isEmpty()) {
          excelMap.put("msg", msg);
        }

        Map map = new HashMap();

        map.put("RNUM", Integer.valueOf(i));
        map.put("newFromItemId", data[i][0]);
        map.put("newFromClassCode", data[i][1]);
        map.put("newFromName", replaceSingleQuotation(data[i][2]));
        map.put("newToItemId", data[i][3]);
        map.put("newToClassCode", data[i][4]);
        map.put("newToName", replaceSingleQuotation(data[i][5]));
        map.put("newConnectionClassCode", data[i][6]);

        list.add(map);
        valCnt++;
      }
      totalCnt++;
    }

    excelMap.put("list", list);
    excelMap.put("validCnt", Integer.valueOf(valCnt));
    excelMap.put("totalCnt", Integer.valueOf(totalCnt));
    excelMap.put("attrTypeCodeCnt", Integer.valueOf(attrTypeColNum));
    excelMap.put("colsName", "newFromItemId|newFromClassCode|newFromName|newToItemId|newToClassCode|newToName|newConnectionClassCode");

    return excelMap;
  }

  private String checkValueForConnection(int i, String[][] data, String option, String langCode, BufferedWriter errorLog)
    throws Exception
  {
    String msg = "";
    Map commandMap = new HashMap();

    if (data[i][0].isEmpty())
    {
      msg = MessageHandler.getMessage(langCode + ".WM00107", new String[] { String.valueOf(i + 1), "From ItemID" });
      errorLog.write(msg);
      errorLog.newLine();
    }

    if (data[i][3].isEmpty())
    {
      msg = MessageHandler.getMessage(langCode + ".WM00107", new String[] { String.valueOf(i + 1), "To ItemID" });
      errorLog.write(msg);
      errorLog.newLine();
    }

    if (data[i][6].isEmpty()) {
      msg = i + 1 + "행의 Connection Class 를 입력해 주세요.";
      errorLog.write(msg);
      errorLog.newLine();
    }

    return msg;
  }

  private Map setUploadMapDimension(XSSFSheet sheet, String option, HashMap commandMap, BufferedWriter errorLog)
    throws Exception
  {
    Map excelMap = new HashMap();

    String colsName = "";
    String headerName = "";
    int attrTypeColNum = 1;
    String[][] data = null;
    List list = new ArrayList();
    int valCnt = 0;

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
        data[i][j] = StringUtil.checkNull(cell);

        if ((i == 0) && (j > 1))
        {
          if (data[i][j].isEmpty())
          {
            excelMap.put("msg", MessageHandler.getMessage(langCode + ".WM00110", new String[] { String.valueOf(j + 1), "DimValueText" }));
            errorLog.write(MessageHandler.getMessage(langCode + ".WM00110", new String[] { String.valueOf(j + 1), "DimValueText" }));
            errorLog.newLine();
          }

          excelMap.put("DimValueText" + (j - 1), data[i][j]);
          colsName = colsName + "|" + "newDimValue" + (j - 1);
          headerName = headerName + "," + data[i][j];
          attrTypeColNum++;
        }

        if ((i != 1) || (j <= 1))
          continue;
        if (data[i][j].isEmpty())
        {
          excelMap.put("msg", MessageHandler.getMessage(langCode + ".WM00110", new String[] { String.valueOf(j + 1), "DimValueID" }));
          errorLog.write(MessageHandler.getMessage(langCode + ".WM00110", new String[] { String.valueOf(j + 1), "DimValueText" }));
          errorLog.newLine();
        }

        excelMap.put("DimValue" + (j - 1), data[i][j]);
      }

      if (i <= 0) {
        continue;
      }
      String msg = checkValueForDimension(i, data, option, langCode, errorLog);
      if (!msg.isEmpty()) {
        excelMap.put("msg", msg);
      }

      Map map = new HashMap();

      map.put("RNUM", Integer.valueOf(i));
      map.put("newItemTypeId", data[i][0]);
      if (i == 1) {
        map.put("newDimTypeIdItemName", data[i][1]);
      }

      for (int j = 1; j < attrTypeColNum; j++) {
        if (!data[i][(1 + j)].isEmpty())
          map.put("newDimValue" + j, excelMap.get("DimValue" + j).toString());
        else {
          map.put("newDimValue" + j, "");
        }
      }

      list.add(map);
      valCnt++;
    }

    excelMap.put("list", list);
    excelMap.put("validCnt", Integer.valueOf(valCnt));
    excelMap.put("totalCnt", Integer.valueOf(valCnt));
    excelMap.put("attrTypeCodeCnt", Integer.valueOf(attrTypeColNum));
    excelMap.put("colsName", "newItemTypeId|newDimTypeIdItemName" + colsName);
    excelMap.put("headerName", headerName);

    return excelMap;
  }

  private String checkValueForDimension(int i, String[][] data, String option, String langCode, BufferedWriter errorLog)
    throws Exception
  {
    String msg = "";
    Map commandMap = new HashMap();

    if (i == 1)
    {
      if (data[i][0].isEmpty())
      {
        msg = MessageHandler.getMessage(langCode + ".WM00107", new String[] { String.valueOf(i + 1), "ItemTypeCode" });
        errorLog.write(msg);
        errorLog.newLine();
      }

      if (data[i][1].isEmpty())
      {
        msg = MessageHandler.getMessage(langCode + ".WM00107", new String[] { String.valueOf(i + 1), "Dimensin Type ID" });
        errorLog.write(msg);
        errorLog.newLine();
      }

      commandMap.put("ItemID", data[i][1]);
      String cnt = StringUtil.checkNull(this.commonService.selectString("report_SQL.getCountWithItemId", commandMap));
      if (cnt.equals("0"))
      {
        msg = MessageHandler.getMessage(langCode + ".WM00108", new String[] { String.valueOf(i + 1), "Dimensin Type ID" });
        errorLog.write(msg);
        errorLog.newLine();
      }

    }

    if (i > 1)
    {
      if (data[i][0].isEmpty())
      {
        msg = MessageHandler.getMessage(langCode + ".WM00107", new String[] { String.valueOf(i + 1), "ItemID or Identifier" });
        errorLog.write(msg);
        errorLog.newLine();
      }

      if (option.equals("1"))
      {
        commandMap.put("ItemID", data[i][0]);
        String cnt = StringUtil.checkNull(this.commonService.selectString("report_SQL.getCountWithItemId", commandMap));
        if (cnt.equals("0"))
        {
          msg = MessageHandler.getMessage(langCode + ".WM00108", new String[] { String.valueOf(i + 1), "ItemId" });
          errorLog.write(msg);
          errorLog.newLine();
        }

      }
      else
      {
        commandMap.put("Identifier", data[i][0]);
        String cnt = StringUtil.checkNull(this.commonService.selectString("report_SQL.getCountWithIdentifier", commandMap));
        if (cnt.equals("0"))
        {
          msg = MessageHandler.getMessage(langCode + ".WM00108", new String[] { String.valueOf(i + 1), "Identifier" });
          errorLog.write(msg);
          errorLog.newLine();
        }

      }

    }

    return msg;
  }

  private Map setUploadPgStatusCboList(XSSFSheet sheet)
    throws Exception
  {
    Map excelMap = new HashMap();

    String colsName = "newItemId|newFDTanto|newFDPlannedStart|newFDPlannedEnd|newFDStatus|newFDActualStart|newFDActualEnd|newPGTanto|newPGPlannedStart|newPGPlannedEnd|newPGStatus|newPGActualStart|newPGActualEnd|newUTTanto|newUTPlannedStart|newUTPlannedEnd|newUTStatus|newUTActualStart|newUTActualEnd|newTDTanto|newTDPlannedStart|newTDPlannedEnd|newTDStatus|newTDActualStart|newTDActualEnd";

    int attrTypeColNum = 1;
    List list = new ArrayList();
    List identifierList = new ArrayList();
    Map commandMap = new HashMap();

    int valCnt = 0;

    int rowCount = sheet.getPhysicalNumberOfRows();

    XSSFRow row = null;
    XSSFCell cell = null;
    String parentIdentifier = "";

    String msg = checkValueForUploadPgStatusCboList(sheet, rowCount);
    if (!msg.isEmpty()) {
      excelMap.put("msg", msg);
    }

    if (excelMap.get("msg") == null)
    {
      for (int i = 4; i < rowCount; i++)
      {
        row = sheet.getRow(i);
        int colCount = row.getPhysicalNumberOfCells();

        Map map = new HashMap();
        int kbn = 0;

        for (int j = 0; j < colCount; j++) {
          cell = row.getCell(j);

          if ((i == 4) && (j == 0)) {
            parentIdentifier = String.valueOf(cell);
          }

          map.put("RNUM", Integer.valueOf(i - 3));

          if ((j == 0) && (
            (StringUtil.checkNull(cell).isEmpty()) || (!parentIdentifier.equals(String.valueOf(cell))))) {
            kbn = 1;
            break;
          }

          if (j == 1) {
            commandMap.put("Identifier", cell.getRawValue());
            String itemId = StringUtil.checkNull(this.commonService.selectString("report_SQL.getItemIdWithIdentifier", commandMap));
            map.put("newItemId", itemId);
          }

          if (j == 2) map.put("newFDTanto", cell);
          if (j == 3) map.put("newFDPlannedStart", setDateYyyymmdd(cell, "yyyy-MM-dd"));
          if (j == 4) map.put("newFDPlannedEnd", setDateYyyymmdd(cell, "yyyy-MM-dd"));
          if (j == 5) map.put("newFDStatus", cell);
          if (j == 6) map.put("newFDActualStart", setDateYyyymmdd(cell, "yyyy-MM-dd"));
          if (j == 7) map.put("newFDActualEnd", setDateYyyymmdd(cell, "yyyy-MM-dd"));

          if (j == 8) map.put("newPGTanto", cell);
          if (j == 9) map.put("newPGPlannedStart", setDateYyyymmdd(cell, "yyyy-MM-dd"));
          if (j == 10) map.put("newPGPlannedEnd", setDateYyyymmdd(cell, "yyyy-MM-dd"));
          if (j == 11) map.put("newPGStatus", cell);
          if (j == 12) map.put("newPGActualStart", setDateYyyymmdd(cell, "yyyy-MM-dd"));
          if (j == 13) map.put("newPGActualEnd", setDateYyyymmdd(cell, "yyyy-MM-dd"));

          if (j == 14) map.put("newUTTanto", cell);

          if (j == 15) map.put("newUTPlannedStart", setDateYyyymmdd(cell, "yyyy-MM-dd"));
          if (j == 16) map.put("newUTPlannedEnd", setDateYyyymmdd(cell, "yyyy-MM-dd"));
          if (j == 17) map.put("newUTStatus", cell);
          if (j == 18) map.put("newUTActualStart", setDateYyyymmdd(cell, "yyyy-MM-dd"));
          if (j == 19) map.put("newUTActualEnd", setDateYyyymmdd(cell, "yyyy-MM-dd"));

          if (j == 20) map.put("newTDTanto", cell);
          if (j == 21) map.put("newTDPlannedStart", setDateYyyymmdd(cell, "yyyy-MM-dd"));
          if (j == 22) map.put("newTDPlannedEnd", setDateYyyymmdd(cell, "yyyy-MM-dd"));
          if (j == 23) map.put("newTDStatus", cell);
          if (j == 24) map.put("newTDActualStart", setDateYyyymmdd(cell, "yyyy-MM-dd"));
          if (j != 25) continue; map.put("newTDActualEnd", setDateYyyymmdd(cell, "yyyy-MM-dd"));
        }

        if (kbn == 0) {
          list.add(map);
        }

        valCnt++;

        if (excelMap.get("msg") != null)
        {
          break;
        }
      }
    }

    excelMap.put("list", list);
    excelMap.put("validCnt", Integer.valueOf(valCnt));
    excelMap.put("totalCnt", Integer.valueOf(valCnt));
    excelMap.put("attrTypeCodeCnt", Integer.valueOf(attrTypeColNum));
    excelMap.put("colsName", colsName);

    return excelMap;
  }

  private String checkValueForUploadPgStatusCboList(XSSFSheet sheet, int rowCount)
    throws Exception
  {
    String msg = "";
    Map commandMap = new HashMap();

    XSSFRow row = null;
    XSSFCell cell = null;

    String parentIdentifier = "";

    for (int i = 4; i < rowCount; i++)
    {
      row = sheet.getRow(i);
      int colCount = row.getPhysicalNumberOfCells();

      Map map = new HashMap();
      int kbn = 0;

      for (int j = 0; j < colCount; j++) {
        cell = row.getCell(j);

        if ((i == 4) && (j == 0)) {
          parentIdentifier = String.valueOf(cell);
        }

        if ((j == 0) && (
          (StringUtil.checkNull(cell).isEmpty()) || (!parentIdentifier.equals(String.valueOf(cell))))) {
          kbn = 1;
          break;
        }

        if (j == 8) {
          if (StringUtil.checkNull(cell).isEmpty()) {
            msg = i + 1 + "행의 [CBO ID]을 입력해 주세요.";
            return msg;
          }
          commandMap.put("Identifier", cell.getRawValue());
          String itemId = StringUtil.checkNull(this.commonService.selectString("report_SQL.getItemIdWithIdentifier", commandMap));

          if (itemId.isEmpty()) {
            msg = i + 1 + "행의 [CBO ID]가 데이터 베이스에 존재 하지 않습니다.";
            return msg;
          }

        }

      }

    }

    return msg;
  }

  private Map setUploadPgStatusIfMaster(XSSFSheet sheet)
    throws Exception
  {
    Map excelMap = new HashMap();

    String colsName = "newItemId|newIMPlannedStart|newIMPlannedEnd|newIMActualStart|newIMActualEnd|newIMLegacyActualEndDate|newIfMappingName|newIPPlannedStart|newIPPlannedEnd|newIPActualStart|newIPActualEnd|newIPEAIEndDate|newIPLegacyPlannedEndDate|newIPLegacyActualEndDate|newUtPlannedStart|newUtPlannedEnd|newUtActualStart|newUtActualEnd|newUtMWUtEndDate|newUtLegacyActualEndDate|newITPlannedStart|newITPlannedEnd|newITActualStart|newITActualEnd";

    int attrTypeColNum = 1;
    List list = new ArrayList();
    List identifierList = new ArrayList();
    Map commandMap = new HashMap();

    int valCnt = 0;

    int rowCount = sheet.getPhysicalNumberOfRows();

    XSSFRow row = null;
    XSSFCell cell = null;
    String parentIdentifier = "";

    String msg = checkValueForUploadPgStatusIfMaster(sheet, rowCount);
    if (!msg.isEmpty()) {
      excelMap.put("msg", msg);
    }

    if (excelMap.get("msg") == null)
    {
      for (int i = 4; i < rowCount; i++)
      {
        row = sheet.getRow(i);
        int colCount = row.getPhysicalNumberOfCells();

        Map map = new HashMap();
        int kbn = 0;

        for (int j = 0; j < colCount; j++) {
          cell = row.getCell(j);

          if ((i == 4) && (j == 0)) {
            parentIdentifier = String.valueOf(cell);
          }

          map.put("RNUM", Integer.valueOf(i - 3));

          if ((j == 0) && (
            (StringUtil.checkNull(cell).isEmpty()) || (!parentIdentifier.equals(String.valueOf(cell))))) {
            kbn = 1;
            break;
          }

          if (j == 1) {
            commandMap.put("Identifier", cell.getRawValue());
            String itemId = StringUtil.checkNull(this.commonService.selectString("report_SQL.getItemIdWithIdentifier", commandMap));
            map.put("newItemId", itemId);
          }

          if (j == 33) map.put("newIMPlannedStart", setDateYyyymmdd(cell, "yyyy-MM-dd"));
          if (j == 34) map.put("newIMPlannedEnd", setDateYyyymmdd(cell, "yyyy-MM-dd"));
          if (j == 35) map.put("newIMActualStart", setDateYyyymmdd(cell, "yyyy-MM-dd"));
          if (j == 36) map.put("newIMActualEnd", setDateYyyymmdd(cell, "yyyy-MM-dd"));
          if (j == 37) map.put("newIMLegacyActualEndDate", setDateYyyymmdd(cell, "yyyy-MM-dd"));
          if (j == 38) map.put("newIfMappingName", cell);

          if (j == 39) map.put("newIPPlannedStart", setDateYyyymmdd(cell, "yyyy-MM-dd"));
          if (j == 40) map.put("newIPPlannedEnd", setDateYyyymmdd(cell, "yyyy-MM-dd"));
          if (j == 41) map.put("newIPActualStart", setDateYyyymmdd(cell, "yyyy-MM-dd"));
          if (j == 42) map.put("newIPActualEnd", setDateYyyymmdd(cell, "yyyy-MM-dd"));
          if (j == 43) map.put("newIPEAIEndDate", setDateYyyymmdd(cell, "yyyy-MM-dd"));
          if (j == 44) map.put("newIPLegacyPlannedEndDate", setDateYyyymmdd(cell, "yyyy-MM-dd"));
          if (j == 45) map.put("newIPLegacyActualEndDate", setDateYyyymmdd(cell, "yyyy-MM-dd"));

          if (j == 46) map.put("newUtPlannedStart", setDateYyyymmdd(cell, "yyyy-MM-dd"));
          if (j == 47) map.put("newUtPlannedEnd", setDateYyyymmdd(cell, "yyyy-MM-dd"));
          if (j == 48) map.put("newUtActualStart", setDateYyyymmdd(cell, "yyyy-MM-dd"));
          if (j == 49) map.put("newUtActualEnd", setDateYyyymmdd(cell, "yyyy-MM-dd"));
          if (j == 50) map.put("newUtMWUtEndDate", setDateYyyymmdd(cell, "yyyy-MM-dd"));
          if (j == 51) map.put("newUtLegacyActualEndDate", setDateYyyymmdd(cell, "yyyy-MM-dd"));

          if (j == 52) map.put("newITPlannedStart", setDateYyyymmdd(cell, "yyyy-MM-dd"));
          if (j == 53) map.put("newITPlannedEnd", setDateYyyymmdd(cell, "yyyy-MM-dd"));
          if (j == 54) map.put("newITActualStart", setDateYyyymmdd(cell, "yyyy-MM-dd"));
          if (j != 55) continue; map.put("newITActualEnd", setDateYyyymmdd(cell, "yyyy-MM-dd"));
        }

        if (kbn == 0) {
          list.add(map);
        }

        valCnt++;

        if (excelMap.get("msg") != null)
        {
          break;
        }
      }
    }

    excelMap.put("list", list);
    excelMap.put("validCnt", Integer.valueOf(valCnt));
    excelMap.put("totalCnt", Integer.valueOf(valCnt));
    excelMap.put("attrTypeCodeCnt", Integer.valueOf(attrTypeColNum));
    excelMap.put("colsName", colsName);

    return excelMap;
  }

  private String checkValueForUploadPgStatusIfMaster(XSSFSheet sheet, int rowCount)
    throws Exception
  {
    String msg = "";
    Map commandMap = new HashMap();

    XSSFRow row = null;
    XSSFCell cell = null;

    String parentIdentifier = "";

    for (int i = 4; i < rowCount; i++)
    {
      row = sheet.getRow(i);
      int colCount = row.getPhysicalNumberOfCells();

      Map map = new HashMap();
      int kbn = 0;

      for (int j = 0; j < colCount; j++) {
        cell = row.getCell(j);

        if ((i == 4) && (j == 0)) {
          parentIdentifier = String.valueOf(cell);
        }

        if ((j == 0) && (
          (StringUtil.checkNull(cell).isEmpty()) || (!parentIdentifier.equals(String.valueOf(cell))))) {
          kbn = 1;
          break;
        }

        if (j == 1) {
          if (StringUtil.checkNull(cell).isEmpty()) {
            msg = i + 1 + "행의 [Interface ID]을 입력해 주세요.";
            return msg;
          }
          commandMap.put("Identifier", cell.getRawValue());
          String itemId = StringUtil.checkNull(this.commonService.selectString("report_SQL.getItemIdWithIdentifier", commandMap));

          if (itemId.isEmpty()) {
            msg = i + 1 + "행의 [Interface ID]가 데이터 베이스에 존재 하지 않습니다.";
            return msg;
          }

        }

      }

    }

    return msg;
  }

  private String replaceSingleQuotation(String plainText)
  {
    String result = "";
    result = plainText.replace("'", "");
    return result;
  }

  private List getModelId(List List, String languageID) throws Exception {
    List resultList = new ArrayList();
    Map setMap = new HashMap();
    for (int i = 0; i < List.size(); i++) {
      Map listMap = new HashMap();
      listMap = (Map)List.get(i);
      String modelId = "";

      setMap.put("ItemID", listMap.get("ItemID"));
      setMap.put("languageID", languageID);
      List modelList = this.commonService.selectList("model_SQL.getModelsWithItemID", setMap);

      if (modelList.size() != 0) {
        Map modelMap = (Map)modelList.get(0);
        modelId = modelMap.get("ModelID").toString();
      }

      listMap.put("ModelID", modelId);
      resultList.add(listMap);
    }
    return resultList;
  }

  @RequestMapping({"/tranAttrList.do"})
  public String tranAttrList(HttpServletRequest request, HashMap commandMap, ModelMap model)
    throws Exception
  {
    String url = "/report/tranAttrList";
    model.put("menu", getLabel(request, this.commonService));

    return nextUrl(url);
  }

  @RequestMapping({"/updateTranAttr.do"})
  public String updateTranAttr(HttpServletRequest request, HashMap commandMap, ModelMap model)
    throws Exception
  {
    Map target = new HashMap();
    try {
      this.commonService.insert("report_SQL.insertTranAttr", commandMap);
      this.commonService.update("report_SQL.updateTranAttr", commandMap);

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    model.addAttribute("resultMap", target);

    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  @RequestMapping({"/downloadTranAttrExcel.do"})
  public String downloadTranAttrExcel(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response)
    throws Exception
  {
    HashMap target = new HashMap();
    HashMap setData = new HashMap();
    FileOutputStream fileOutput = null;
    XSSFWorkbook wb = new XSSFWorkbook();
    try
    {
      List result = this.commonService.selectList("report_SQL.getTranAttrDataList_gridList", commandMap);

      XSSFSheet sheet = wb.createSheet("TranAttr Data");
      XSSFCellStyle headerStyle = setCellHeaderStyle(wb);
      XSSFCellStyle contentsStyle = setCellContentsStyle(wb, "");

      int cellIndex = 0;
      int rowIndex = 0;
      XSSFRow row = sheet.createRow(rowIndex);
      row.setHeight((short) 409);
      XSSFCell cell = null;
      rowIndex++;
      String TextDefOLD = "";
      String TextDef = "";
      String TargetText = "";

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

      for (int i = 0; i < result.size(); i++) {
        cellIndex = 0;
        Map map = (Map)result.get(i);
        row = sheet.createRow(rowIndex);
        row.setHeight((short) 409);

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

      String orgFileName1 = selectedItemName1 + "_" + formatter.format(Long.valueOf(date)) + ".xlsx";
      String orgFileName2 = selectedItemName2 + "_" + formatter.format(Long.valueOf(date)) + ".xlsx";
      String downFile1 = FileUtil.FILE_EXPORT_DIR + orgFileName1;
      String downFile2 = FileUtil.FILE_EXPORT_DIR + orgFileName2;

      File file = new File(downFile2);
      fileOutput = new FileOutputStream(file);
      wb.write(fileOutput);
      target.put("SCRIPT", "parent.doFileDown('" + orgFileName1 + "', 'excel');parent.$('#isSubmit').remove();");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00089"));
    } finally {
      if (fileOutput != null) fileOutput.close();
      wb = null;
    }

    model.addAttribute("resultMap", target);

    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  @RequestMapping({"/tranAttrExcelUpload.do"})
  public String tranAttrExcelUpload(HashMap commandFileMap, HashMap commandMap, ModelMap model) throws Exception
  {
    Map target = new HashMap();
    int line = 0;
    try
    {
      List list = (List)commandFileMap.get("STORED_FILES");
      Map map = (Map)list.get(0);

      String sys_file_name = (String)map.get("SysFileNm");
      String file_path = "";
      String file_id = (String)map.get("AttFileID");

      String filePath = FileUtil.FILE_UPLOAD_DIR + sys_file_name;

      String errorCheckfilePath = GlobalVal.FILE_EXPORT_DIR;

      Map excelMap = new HashMap();
      int total_cnt = 0;
      int valid_cnt = 0;
      String colsName = "";
      String headerName = "";

      SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
      long date = System.currentTimeMillis();
      String fileName = "Upload_ATTR_ERROR_" + formatter.format(Long.valueOf(date)) + ".txt";
      String downFile = errorCheckfilePath + fileName;
      File file = new File(downFile);
      BufferedWriter errorLog = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file, true), "UTF-8"));

      excelMap = getAttrTranList(new File(filePath), commandFileMap, commandMap, errorLog);

      errorLog.close();

      List arrayList = (List)excelMap.get("list");
      total_cnt = NumberUtil.getIntValue(excelMap.get("totalCnt"));
      valid_cnt = NumberUtil.getIntValue(excelMap.get("validCnt"));
      colsName = excelMap.get("colsName").toString();

      String jsonObject = "";
      if (arrayList.size() > 0) {
        String[] cols = colsName.split("[|]");
        int totalPage = 0;
        jsonObject = JsonUtil.parseGridJson(arrayList, cols, totalPage, 1, (String)commandFileMap.get("contextPath"));
        jsonObject = jsonObject.replace("<br/>", "&&rn");
      }

      String errMsgYN = "";
      if (excelMap.get("msg") != null)
        errMsgYN = "Y";
      else errMsgYN = "N";
      System.out.println("total_cnt==" + total_cnt);
      System.out.println("jsonObject==" + jsonObject);
      target.put("SCRIPT", "parent.doCntReturn('" + total_cnt + "','" + valid_cnt + "','" + file_id + "','" + jsonObject + "','" + errMsgYN + "','" + fileName + "','" + downFile + "');");

      if (excelMap.get("msg") != null)
        errorLog.close();
      else
        file.delete();
    }
    catch (Exception e)
    {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove();");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00072", new String[] { e.getMessage().replaceAll("\"", "") }));
    }

    model.addAttribute("resultMap", target);

    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  private Map getAttrTranList(File excelFile, HashMap commandFileMap, HashMap commandMap, BufferedWriter errorLog) throws Exception
  {
    Map excelMap = new HashMap();
    XSSFWorkbook workbook = new XSSFWorkbook(new FileInputStream(excelFile));
    XSSFSheet sheet = null;
    try {
      sheet = workbook.getSheetAt(0);
      int rowCount = sheet.getPhysicalNumberOfRows();

      if (rowCount <= 1) {
        throw new Exception("There is no data in the file.");
      }
      excelMap = setUploadAttrTranMap(sheet, commandMap, errorLog);

      Map localMap1 = excelMap;
      return localMap1;
    }
    catch (Exception e) {
      System.out.println(e.toString());
      throw e;
    } finally {
      try {
        workbook = null;
        sheet = null;
      } catch (Exception localException2) {
      }
    }
  }

  private Map setUploadAttrTranMap(XSSFSheet sheet, HashMap commandMap, BufferedWriter errorLog)
    throws Exception
  {
    Map excelMap = new HashMap();

    String colsName = "";
    int attrTypeColNum = 1;
    String[][] data = null;
    List list = new ArrayList();
    List identifierList = new ArrayList();

    int valCnt = 0;
    int rowCount = sheet.getPhysicalNumberOfRows();
    int colCount = sheet.getRow(0).getPhysicalNumberOfCells();

    data = new String[rowCount][colCount];

    XSSFRow row = null;
    XSSFCell cell = null;

    String langCode = String.valueOf(commandMap.get("sessionCurrLangCode"));

    for (int i = 0; i < rowCount; i++) {
      row = sheet.getRow(i);
      for (int j = 0; j < colCount; j++) {
        cell = row.getCell(j);

        if (cell != null) {
          if (cell.getCellType() == 0)
            data[i][j] = StringUtil.checkNull(setDateYyyymmdd(cell, "yyyy-MM-dd"));
          else
            data[i][j] = StringUtil.checkNull(cell);
        }
        else {
          data[i][j] = StringUtil.checkNull(cell);
        }

      }

      if (i <= 0)
        continue;
      String msg = checkValueForUploadTran(i, data, langCode, errorLog);
      if (!msg.isEmpty()) {
        excelMap.put("msg", msg);
      }

      Map map = new HashMap();
      map.put("RNUM", Integer.valueOf(i));
      map.put("itemID", data[i][1]);
      map.put("attrTypeCode", data[i][2]);
      map.put("languageID", data[i][3]);
      map.put("targetText", data[i][10]);
      map.put("revisionNo", data[i][13]);
      list.add(map);
      valCnt++;
    }

    excelMap.put("list", list);
    excelMap.put("validCnt", Integer.valueOf(valCnt));
    excelMap.put("totalCnt", Integer.valueOf(valCnt));
    excelMap.put("colsName", "itemID|attrTypeCode|languageID|targetText|revisionNo");

    return excelMap;
  }

  private String setDateYyyymmdd(XSSFCell cell, String strFormat) {
    String result = "";
    SimpleDateFormat formatter = new SimpleDateFormat(strFormat);

    if (cell.getCellType() == 0) {
      if (HSSFDateUtil.isCellDateFormatted(cell))
        result = formatter.format(cell.getDateCellValue());
      else
        result = StringUtil.checkNull(cell.getRawValue());
    }
    else {
      result = StringUtil.checkNull(cell);
    }

    return result;
  }

  private String checkValueForUploadTran(int i, String[][] data, String langCode, BufferedWriter errorLog)
    throws Exception
  {
    String msg = "";

    if (data[i][0].isEmpty()) {
      msg = MessageHandler.getMessage(langCode + ".WM00107", new String[] { String.valueOf(i + 1), "ItemID" });
      errorLog.write(msg);
      errorLog.newLine();
    }

    if (data[i][1].isEmpty())
    {
      msg = MessageHandler.getMessage(langCode + ".WM00107", new String[] { String.valueOf(i + 1), "AttrTypeCode" });
      errorLog.write(msg);
      errorLog.newLine();
    }

    return msg;
  }

  @RequestMapping({"/tranAttrExcelImport.do"})
  public String tranAttrExcelImport(HttpServletRequest request, HashMap commandMap, ModelMap model)
    throws Exception
  {
    String url = "/report/tranAttrExcelImportPop";
    model.put("menu", getLabel(request, this.commonService));

    return nextUrl(url);
  }

  @RequestMapping({"/saveTranAttrExcel.do"})
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

        if ((data != null) && (data.size() > 0)) {
          itemID = StringUtil.checkNull(data.get("itemID"));
          attrTypeCode = StringUtil.checkNull(data.get("attrTypeCode"));
          targetLanguage = StringUtil.checkNull(data.get("languageID"));
          plainTextTarget = removeAllTag(StringUtil.checkNull(data.get("targetText")));
          revisionNo = StringUtil.checkNull(data.get("revisionNo"));

          insertData.put("ItemID", itemID);
          insertData.put("languageID", targetLanguage);
          insertData.put("AttrTypeCode", attrTypeCode);

          html = StringUtil.checkNull(this.commonService.selectString("report_SQL.getAttrHtmlType", insertData));
          if (attrTypeCode.equals("AT00001")) {
            plainTextTarget = plainTextTarget.replaceAll("&&rn", " ");
          }
          else if (html.equals("1"))
            plainTextTarget = plainTextTarget.replaceAll("&&rn", "<br/>");
          else {
            plainTextTarget = plainTextTarget.replaceAll("&&rn", "\r\n");
          }

          insertData.put("PlainText", plainTextTarget);
          itemAttrCnt = Integer.parseInt(this.commonService.selectString("report_SQL.getItemAttrCnt", insertData));
          if (itemAttrCnt > 0)
            this.commonService.insert("item_SQL.updateItemAttr", insertData);
          else {
            this.commonService.insert("item_SQL.setItemAttr", insertData);
          }

          updateTranData.put("itemID", itemID);
          updateTranData.put("attrTypeCode", attrTypeCode);
          updateTranData.put("targetLanguage", targetLanguage);
          updateTranData.put("revisionNo", revisionNo);
          this.commonService.update("report_SQL.updateItemAttrTran", updateTranData);
        }

      }

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
      target.put("SCRIPT", "parent.fnCallBack();");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    model.addAttribute("resultMap", target);

    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  public String insertFile(HashMap fileMap, HashMap model, HashMap commandMap) throws Exception {
    String resultValue = "sucess";
    try {
      List fileList = new ArrayList();

      Map setMap = new HashMap();
      setMap.put("itemID", model.get("selectedItemID"));
      setMap.put("fileName", fileMap.get("fileName"));
      String fileSeq = StringUtil.checkNull(this.commonService.selectString("fileMgt_SQL.getFileSeq", setMap));

      if (fileSeq.equals("")) {
        fileSeq = StringUtil.checkNull(this.commonService.selectString("fileMgt_SQL.itemFile_nextVal", setMap));

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
      }
      else {
        fileMap.put("Seq", fileSeq);
        fileMap.put("FileName", fileMap.get("sysFileName"));
        fileMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
        fileMap.put("sessionUserId", commandMap.get("itemAuthorID"));
        fileMap.put("FltpCode", fileMap.get("fltpCode"));
        fileMap.put("KBN", "update");
        fileMap.put("SQLNAME", "fileMgt_SQL.itemFile_update");

        fileList.add(fileMap);
      }

      this.fileMgtService.save(fileList, fileMap);
    }
    catch (Exception ex) {
      resultValue = "failed";
      System.out.println(ex.toString());
    }

    return resultValue;
  }
  @RequestMapping({"/deleteItem.do"})
  public String deleteItem(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    HashMap updateCommandMap = new HashMap();
    HashMap setMap = new HashMap();
    try {
      String itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
      Map setData = new HashMap();
      setData.put("itemId", itemID);
      Map itemInfo = this.commonService.select("fileMgt_SQL.selectItemAuthorID", setData);
      String itemStatus = StringUtil.checkNull(itemInfo.get("Status"));
      String itemBlocked = StringUtil.checkNull(itemInfo.get("Blocked"));

      setData.put("itemID", itemID);
      int toItemCNT = Integer.parseInt(StringUtil.checkNull(this.commonService.selectString("report_SQL.getToItemCNT", setData)));
      int mdlOBJCNT = Integer.parseInt(StringUtil.checkNull(this.commonService.selectString("report_SQL.getMDLOBJCNT", setData)));

      if (!itemBlocked.equals("0")) {
        if (itemStatus.equals("REL"))
          target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00121"));
        else {
          target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00054"));
        }
        model.addAttribute("resultMap", target);
        return nextUrl("/cmm/ajaxResult/ajaxPage");
      }
      if ((itemStatus.equals("NEW1")) || (itemStatus.equals("NEW2")) || (itemStatus.equals("REL"))) {
        if (toItemCNT > 0) {
          target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00024"));
          model.addAttribute("resultMap", target);
          return nextUrl("/cmm/ajaxResult/ajaxPage");
        }if (mdlOBJCNT > 0) {
          target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00052"));
          model.addAttribute("resultMap", target);
          return nextUrl("/cmm/ajaxResult/ajaxPage");
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

      this.commonService.update("item_SQL.updateCNItemDeleted", updateCommandMap);

      this.commonService.update("project_SQL.updateItemStatus", updateCommandMap);

      deleteDimItemTreeInfo(commandMap, itemID);

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069"));
      target.put("SCRIPT", "this.doCallBack();this.$('#isSubmit').remove();");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "this.$('#isSubmit').remove()");

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  private void deleteDimItemTreeInfo(HashMap commandMap, String itemID)
    throws ExceptionUtil
  {
    Map setMap = new HashMap();
    try
    {
      String deletedItemId = itemID;
      setMap.put("ItemID", deletedItemId);
      List dimensionList = this.commonService.selectList("dim_SQL.getDimListWithItemId", setMap);

      for (int j = 0; j < dimensionList.size(); j++) {
        Map dimensionMap = (Map)dimensionList.get(j);
        String dimTypeID = String.valueOf(dimensionMap.get("DimTypeID"));
        String dimValueID = String.valueOf(dimensionMap.get("DimValueID"));

        List<String> connectionIdList = new ArrayList();

        List itemDimIdList = new ArrayList();
        DimTreeAdd.getUnderConnectionId(this.commonService, itemID, connectionIdList);
        DimTreeAdd.getExistItemDimId(this.commonService, itemDimIdList, connectionIdList, dimTypeID, dimValueID);

        connectionIdList = new ArrayList();
        DimTreeAdd.getOverConnectionId(this.commonService, itemID, dimTypeID, dimValueID, connectionIdList, 0);
        DimTreeAdd.getExistItemDimId(this.commonService, itemDimIdList, connectionIdList, dimTypeID, dimValueID);

        connectionIdList = new ArrayList();
        DimTreeAdd.getUnderConnectionId(this.commonService, itemID, connectionIdList);
        DimTreeAdd.getOverConnectionId(this.commonService, itemID, dimTypeID, dimValueID, connectionIdList, 1);

        setMap.put("DimTypeID", dimTypeID);
        setMap.put("DimValueID", dimValueID);
        for (String connectionId : connectionIdList) {
          setMap.put("NodeID", connectionId);
          this.commonService.delete("dim_SQL.delSubDimTree", setMap);
        }

        itemDimIdList.remove(itemID);
        if (itemDimIdList.size() != 0)
        {
          for (int k = 0; k < itemDimIdList.size(); k++) {
            String itemDimId = (String)itemDimIdList.get(k);

            commandMap.put("ItemID", itemDimId);
            List itemInfoList = this.commonService.selectList("dim_SQL.getItemTypeCodeAndClassCode", commandMap);
            Map itemInfoMap = (Map)itemInfoList.get(0);
            String itemTypeCode = itemInfoMap.get("ItemTypeCode").toString();

            connectionIdList = new ArrayList();

            DimTreeAdd.getOverConnectionId(this.commonService, itemDimId, dimTypeID, dimValueID, connectionIdList, 0);
            DimTreeAdd.getUnderConnectionId(this.commonService, itemDimId, connectionIdList);

            commandMap.put("DimTypeID", dimTypeID);
            commandMap.put("DimValueID", dimValueID);
            commandMap.put("ItemTypeCode", itemTypeCode);
            DimTreeAdd.insertToTbItemDimTree(this.commonService, connectionIdList, commandMap);
          }

        }

        setMap.put("DimTypeID", dimTypeID);
        setMap.put("DimValueID", dimValueID);
        setMap.put("s_itemID", itemID);
        this.commonService.delete("dim_SQL.delSubDimValue", setMap);
      }
    }
    catch (Exception e) {
      throw new ExceptionUtil(e.toString());
    }
  }

  @RequestMapping({"/objectReportList.do"})
  public String objectReportList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    String url = "itm/sub/ObjectReportList";
    try
    {
      List getList = new ArrayList();
      Map getMap = new HashMap();

      String kbn = StringUtil.checkNull(request.getParameter("kbn"));

      getMap.put("s_itemID", request.getParameter("s_itemID"));
      getMap.put("languageID", commandMap.get("sessionCurrLangType"));
      getMap.put("AuthLev", commandMap.get("sessionAuthLev"));
      getMap.put("defLanguageID", commandMap.get("sessionDefLanguageId"));

      getList = this.commonService.selectList("report_SQL.getReportList", getMap);

      String loginUser = String.valueOf(commandMap.get("sessionUserId"));
      if (!"1".equals(String.valueOf(commandMap.get("sessionAuthLev")))) {
        for (int i = 0; getList.size() > i; i++) {
          Map map = (Map)getList.get(i);
          String IsPublic = StringUtil.checkNull(map.get("IsPublic"));
          String SeqLevel = StringUtil.checkNull(map.get("SeqLevel"));
          if (("0".equals(IsPublic)) || ("1".equals(SeqLevel))) {
            String itemAuthorID = StringUtil.checkNull(map.get("AuthorID"));
            if (!itemAuthorID.equals(loginUser)) {
              getList.remove(i);
              i--;
            }
          }
        }
      }

      model.put("getList", getList);
      model.put("menu", getLabel(request, this.commonService));
      model.put("s_itemID", request.getParameter("s_itemID"));
      model.put("option", request.getParameter("option"));
      model.put("kbn", kbn);
      model.put("backBtnYN", request.getParameter("backBtnYN"));
      model.put("accMode", request.getParameter("accMode"));
    }
    catch (Exception e) {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }
    return nextUrl(url);
  }

  @RequestMapping({"/checkDocDownComplete.do"})
  public String checkDocDownComplete(HttpServletRequest request, HashMap commandMap, ModelMap model)
    throws Exception
  {
    HashMap target = new HashMap();
    try {
      HttpSession session = request.getSession(true);

      String flg = StringUtil.checkNull(session.getAttribute("expFlag"), "N");

      if ("Y".equals(flg)) {
        target.put("SCRIPT", "Y");
      }
      else
        target.put("SCRIPT", "N");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "this.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    model.addAttribute("resultMap", target);

    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  @RequestMapping({"/downloadAllProcessList.do"})
  public String downloadAllProcData(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    model.put("s_itemID", commandMap.get("s_itemID"));
    model.put("menu", getLabel(request, this.commonService));
    return nextUrl("/custom/base/report/downloadAllProcessList");
  }
  @RequestMapping({"/updateElementPosition.do"})
  public String updateElementPosition(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    try {
      HashMap setData = new HashMap();
      HashMap updateData = new HashMap();
      List elementList = this.commonService.selectList("report_SQL.getElmentList", setData);
      String currPath = "";
      String newPath = "";
      String currPositionY = "";
      String newPositionY = "";
      for (int i = 0; elementList.size() > i; i++) {
        Map elementListMap = (Map)elementList.get(i);
        updateData = new HashMap();
        currPositionY = StringUtil.checkNull(elementListMap.get("PositionY"));
        if ((!currPositionY.equals("")) && (currPositionY != null)) {
          newPositionY = StringUtil.checkNull(Float.valueOf(Float.parseFloat(currPositionY) + 250.0F));
          updateData.put("positionY", newPositionY);
        }
        currPath = StringUtil.checkNull(elementListMap.get("Path"));
        updateData.put("modelID", StringUtil.checkNull(elementListMap.get("ModelID")));
        updateData.put("elementID", StringUtil.checkNull(elementListMap.get("ElementID")));
        updateData.put("lastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));

        if ((!currPath.equals("")) && (currPath != null)) {
          Map elementMap = getCurrXmlStr(currPath);

          if (!elementMap.isEmpty()) {
            String currY = "";
            String[] valueY = StringUtil.checkNull(elementMap.get("valueY")).split(",");
            String newY = "";

            if (valueY.length > 0) {
              for (int j = 0; valueY.length > j; j++) {
                currY = StringUtil.checkNull(valueY[j]);
                newY = StringUtil.checkNull(Float.valueOf(Float.parseFloat(valueY[j]) + 25.0F));
                if (j == 0)
                  newPath = currPath.replace(currY, newY);
                else {
                  newPath = newPath.replace(currY, newY);
                }
              }
              updateData.put("path", newPath);
            }
          }
        }
        if ((!currPositionY.equals("")) || (!currPath.equals(""))) {
          this.commonService.update("report_SQL.updateElementPosionY", updateData);
        }
      }

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
      target.put("SCRIPT", "this.doCallBack();this.$('#isSubmit').remove();");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "this.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  private Map getCurrXmlStr(String m_xmlStr)
  {
    HashMap currMXCell = new HashMap();
    int startIndex = m_xmlStr.indexOf("<");
    do {
      int endIndex = m_xmlStr.indexOf(">", startIndex) + 1;
      String currLine = m_xmlStr.substring(startIndex, endIndex);
      int startMXTypeIndex = currLine.indexOf("<") + 1;
      int endMXTypeIndex = currLine.indexOf(" ", startMXTypeIndex);
      if (endMXTypeIndex == -1) endMXTypeIndex = currLine.indexOf(">", startMXTypeIndex);

      String MXType = currLine.substring(startMXTypeIndex, endMXTypeIndex);
      if (MXType.equals("mxPoint")) {
        getElementValue(currLine, currMXCell);
      }
      startIndex = m_xmlStr.indexOf("<", endIndex);
    }
    while (startIndex != -1);
    this.valueY = "";
    return currMXCell;
  }

  private void getElementValue(String cellStr, HashMap mxCell) {
    int startIndex = cellStr.indexOf("x=\"");
    int endIndex = 0;
    String currStr = "";
    int i = 0;

    startIndex = cellStr.indexOf("y=\"");
    if (startIndex != -1) {
      startIndex += 3;
      endIndex = cellStr.indexOf("\"", startIndex);
      currStr = cellStr.substring(startIndex, endIndex);

      if (this.valueY.equals(""))
        this.valueY = currStr;
      else {
        this.valueY = (this.valueY + "," + currStr);
      }
      mxCell.put("valueY", this.valueY);
    }
  }

  @RequestMapping({"/itemExcelIF.do"})
  public String itemExcelIF(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception
  {
    try
    {
      commandMap.put("AuthorID", commandMap.get("sessionUserId"));
      commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
      List returnData = this.commonService.selectList("project_SQL.getCsrListWithMember", commandMap);
      model.put("csrOption", returnData);

      model.put("languageID", commandMap.get("sessionCurrLangType"));
      model.put("s_itemID", request.getParameter("itemID"));
      model.put("option", request.getParameter("ArcCode"));
      model.put("menu", getLabel(request, this.commonService));
    }
    catch (Exception e) {
      System.out.println(e.toString());
    }

    return nextUrl("/report/itemExcelIF");
  }
  @RequestMapping({"/itemExcelIFUpload.do"})
  public String itemExcelIFUpload(HashMap commandFileMap, HashMap commandMap, ModelMap model) throws Exception {
    Map target = new HashMap();
    int line = 0;
    try
    {
      List list = (List)commandFileMap.get("STORED_FILES");
      Map map = (Map)list.get(0);

      String sys_file_name = (String)map.get("SysFileNm");
      String file_path = "";
      String file_id = (String)map.get("AttFileID");

      String filePath = FileUtil.FILE_UPLOAD_DIR + sys_file_name;

      String errorCheckfilePath = GlobalVal.FILE_EXPORT_DIR;

      Map excelMap = new HashMap();
      int total_cnt = 0;
      int valid_cnt = 0;
      int attrTypeCode_cnt = 0;

      SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
      long date = System.currentTimeMillis();
      String fileName = "Upload_ERROR_" + formatter.format(Long.valueOf(date)) + ".txt";
      String downFile = errorCheckfilePath + fileName;
      File file = new File(downFile);
      BufferedWriter errorLog = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file, true), "UTF-8"));

      excelMap = getItemList(new File(filePath), commandFileMap, commandMap, errorLog);
      errorLog.close();

      List arrayList = (List)excelMap.get("list");
      total_cnt = NumberUtil.getIntValue(excelMap.get("totalCnt"));
      valid_cnt = NumberUtil.getIntValue(excelMap.get("validCnt"));
      attrTypeCode_cnt = NumberUtil.getIntValue(excelMap.get("attrTypeCodeCnt"));

      System.out.println("arrayList==" + arrayList);
      System.out.println("total_cnt==" + total_cnt);
      System.out.println("valid_cnt==" + valid_cnt);

      String type = StringUtil.checkNull(commandFileMap.get("uploadTemplate"));
      String option = StringUtil.checkNull(commandFileMap.get("uploadOption").toString());

      System.out.println("attrTypeCode_cnt == " + attrTypeCode_cnt);
      System.out.println("type == " + type);
      System.out.println("file_id == " + file_id);

      Map resultMap = new HashMap();
      this.commonService.delete("report_SQL.deleteItemAttrIF", resultMap);
      for (int i = 0; i < arrayList.size(); i++) {
        Map map2 = (Map)arrayList.get(i);

        resultMap.put("ParentID", map2.get("newParentIdentifier").toString());
        resultMap.put("ItemClassCode", map2.get("newClassCode").toString());
        resultMap.put("ProjectID", commandMap.get("csrInfo"));

        if ((option.equals("2")) || (option == "2"))
          resultMap.put("Identifier", map2.get("newIdentifier").toString());
        else {
          resultMap.put("ItemID", map2.get("newIdentifier").toString());
        }

        for (int j = 1; j < attrTypeCode_cnt; j++) {
          String attrTypeCode = map2.get("newPlainText" + j).toString().substring(0, 7);
          String plainText = map2.get("newPlainText" + j).toString().substring(9);
          resultMap.put(attrTypeCode, plainText);
        }

        if ((type.equals("2")) || (type == "2")) {
          resultMap.put("Action", "U");
          resultMap.put("languageID", commandMap.get("reportLanguage"));
        }

        this.commonService.insert("report_SQL.insertItemAttrIF", resultMap);
      }

      String errMsgYN = "";
      if (excelMap.get("msg") != null)
        errMsgYN = "Y";
      else errMsgYN = "N";
      target.put("SCRIPT", "parent.doCntReturn('" + total_cnt + "','" + valid_cnt + "','" + attrTypeCode_cnt + "','" + type + "','" + file_id + "','" + errMsgYN + "','" + fileName + "','" + downFile + "');");

      if (excelMap.get("msg") != null)
        errorLog.close();
      else
        file.delete();
    }
    catch (Exception e)
    {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00073", new String[] { e.getMessage().replaceAll("\"", "") }));
    }
    model.addAttribute("resultMap", target);

    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }
  @RequestMapping({"/callExcelIF.do"})
  public String callExcelIf(HashMap commandMap, HttpServletRequest request, ModelMap model) throws Exception {
    Map target = new HashMap();
    try
    {
      Map resultMap = new HashMap();
      resultMap.put("procedureName", "XBOLTADM.TI_ITEM_BATCH");
      this.commonService.insert("report_SQL.insertExcelIF", resultMap);

      String errorCode = StringUtil.checkNull(this.commonService.selectString("report_SQL.getItemAttrError", resultMap), "");
      String msg = MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00088");

      if (!errorCode.equals("")) {
        msg = "Error : " + errorCode;
      }

      target.put("ALERT", msg);
      target.put("SCRIPT", "parent.doSaveReturn();parent.$('#isSubmit').remove()");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00073", new String[] { e.getMessage().replaceAll("\"", "") }));
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }
  @RequestMapping({"/subItemInfoReport.do"})
  public String subItemInfoReportPop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
    try {
      String s_itemID = StringUtil.checkNull(request.getParameter("itemID"), "");
      String classCodeList = StringUtil.checkNull(request.getParameter("classCodeList"), "");
      String url = StringUtil.checkNull(request.getParameter("url"), "");
      String itemInfoRptUrl = StringUtil.checkNull(request.getParameter("itemInfoRptUrl"), "");
      if (!itemInfoRptUrl.equals("")) url = "/" + itemInfoRptUrl;

      model.put("s_itemID", s_itemID);
      model.put("menu", getLabel(request, this.commonService));
      model.put("url", url);
      model.put("classCodeList", classCodeList);
      model.put("outputType", StringUtil.checkNull(cmmMap.get("outputType")));

      HttpSession session = request.getSession(true);

      session.setAttribute("expFlag", "N");
    }
    catch (Exception e) {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }
    return nextUrl("/popup/subItemInfoRptPop");
  }

  @RequestMapping({"/subItemInfoReportEXE.do"})
  public String subItemInfoReportEXE(HttpServletRequest request, HashMap commandMap, ModelMap model)
    throws Exception
  {
    Map target = new HashMap();
    String url = "/custom/base/report/subItemInfoReport";
    if (!StringUtil.checkNull(request.getParameter("URL")).equals("")) url = "/" + StringUtil.checkNull(request.getParameter("URL")); try
    {
      Map setMap = new HashMap();
      String languageId = String.valueOf(commandMap.get("sessionCurrLangType"));
      setMap.put("languageID", languageId);
      setMap.put("langCode", StringUtil.checkNull(commandMap.get("sessionCurrLangCode")).toUpperCase());
      String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
      String s_itemIDs = StringUtil.checkNull(request.getParameter("s_itemIDs"));
      String delItemsYN = String.valueOf(request.getParameter("delItemsYN"));
      String outputType = String.valueOf(request.getParameter("outputType"));
      String paperSize = String.valueOf(request.getParameter("paperSize"));
      String accMode = StringUtil.checkNull(commandMap.get("accMode"), "OPS");
      setMap.put("delItemsYN", delItemsYN);
      String[] arrayItems;
    
      if (s_itemIDs.isEmpty())
        arrayItems = s_itemID.split(",");
      else {
        arrayItems = s_itemIDs.split(",");
      }

      Map attrRsNameMap = new HashMap();
      Map attrRsHtmlMap = new HashMap();
      String selectedItemPath = "";
      String selectedItemName = "";
      List allSubItemList = new ArrayList();
      List items = new ArrayList();
      Map itemsMap = new HashMap();

      String defaultFont = this.commonService.selectString("report_SQL.getDefaultFont", setMap);

      for (int index = 0; index < arrayItems.length; index++) {
        s_itemID = arrayItems[index];
        setMap.put("s_itemID", s_itemID);
        Map selectedItemMap = this.commonService.select("report_SQL.getItemInfo", setMap);
        model.put("selectedItemInfo", selectedItemMap);

        String classCode = this.commonService.selectString("report_SQL.getItemClassCode", setMap);
        String classCodeList = StringUtil.checkNull(request.getParameter("classCodeList"));
        String classCodes = "";
        String includeClassCode = "N";
        Map classMap = new HashMap();
        if ((!classCodeList.isEmpty()) && (classCodeList != null)) {
          String[] classCodeListSPLT = classCodeList.split(",");
          for (int i = 0; classCodeListSPLT.length > i; i++) {
            if (i == 0)
              classCodes = "'" + classCodeListSPLT[i] + "'";
            else {
              classCodes = classCodes + ",'" + classCodeListSPLT[i] + "'";
            }
            if (classCode.equals(classCodeListSPLT[i]))
              includeClassCode = "Y";
          }
        }
        else if (!s_itemIDs.isEmpty()) {
          includeClassCode = "Y";
        }
        model.put("includeClassCode", includeClassCode);

        selectedItemPath = this.commonService.selectString("report_SQL.getMyPathAndName", setMap);
        selectedItemName = StringUtil.checkNull(this.commonService.selectString("report_SQL.getMyIdAndName", setMap)).replace("&#xa;", "");

        String defaultLang = this.commonService.selectString("item_SQL.getDefaultLang", commandMap);

        List subItemList = new ArrayList();
        Map setData = new HashMap();
        String toItemID = "";

        if (includeClassCode.equals("Y")) {
          items.add(s_itemID);
          setMap.put("itemID", s_itemID);
          subItemList = this.commonService.selectList("report_SQL.getChildItemsForWord", setMap);
          allSubItemList = subItemList;

          allSubItemList = getCXNItemsInfo(allSubItemList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, accMode, "ItemID");
          itemsMap.put(s_itemID, allSubItemList);
        } else {
          setMap.remove("s_itemID");
          setMap.put("CURRENT_ITEM", request.getParameter("s_itemID"));
          setMap.put("CategoryCode", "ST1");
          setMap.put("itemClassCodes", classCodes);
          subItemList = this.commonService.selectList("report_SQL.getChildItemsForWord", setMap);
          String itemID = "";
          for (int i = 0; subItemList.size() > i; i++) {
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
            List getSubItemList = this.commonService.selectList("report_SQL.getChildItemsForWord", setData);

            for (int j = 0; getSubItemList.size() > j; j++) {
              allSubItemList = new ArrayList();
              allSubItemList.clear();
              Map getSubItemInfo = (Map)getSubItemList.get(j);
              allSubItemList.add(getSubItemInfo);
              itemID = StringUtil.checkNull(getSubItemInfo.get("ToItemID"));
              items.add(itemID);

              allSubItemList = getCXNItemsInfo(allSubItemList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, accMode, "ToItemID");
              itemsMap.put(itemID, allSubItemList);
            }

            allSubItemList = getCXNItemsInfo(allSubItemList, defaultLang, languageId, attrRsNameMap, attrRsHtmlMap, accMode, "ToItemID");
            itemsMap.put(itemID, allSubItemList);
          }
        }
      }
      model.put("attrRsNameMap", attrRsNameMap);
      model.put("attrRsHtmlMap", attrRsHtmlMap);
      model.put("allSubItemList", allSubItemList);
      model.put("items", items);
      model.put("itemsMap", itemsMap);

      model.put("menu", getLabel(request, this.commonService));
      model.put("setMap", setMap);
      model.put("outputType", outputType);
      model.put("paperSize", paperSize);
      model.put("defaultFont", defaultFont);
      model.put("selectedItemPath", selectedItemPath);
      model.put("itemName", selectedItemName);
      model.put("selectedItemName", URLEncoder.encode(selectedItemName, "UTF-8").replace("+", "%20"));

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00105"));
      target.put("SCRIPT", "parent.goBack();parent.$('#isSubmit').remove();");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl(url);
  }

  private List getCXNItemsInfo(List List, String defaultLang, String sessionCurrLangType, Map attrRsNameMap, Map attrRsHtmlMap, String accMode, String source)
    throws Exception
  {
    List resultList = new ArrayList();
    Map setMap = new HashMap();
    List cngtList = new ArrayList();
    List attrList = new ArrayList();
    Map attrMap = new HashMap();

    for (int i = 0; i < List.size(); i++) {
      Map listMap = new HashMap();
      List resultSubList = new ArrayList();

      listMap = (Map)List.get(i);
      String itemId = String.valueOf(listMap.get(source));
      setMap.put("itemID", itemId);
      setMap.put("s_itemID", itemId);
      setMap.put("languageID", sessionCurrLangType);
      setMap.put("status", "CLS");

      setMap.put("itemId", itemId);
      cngtList = this.commonService.selectList("report_SQL.getItemChangeListRPT", setMap);
      listMap.put("cngtList", cngtList);
      setMap.remove("status");

      Map prcList = this.commonService.select("report_SQL.getItemInfo", setMap);

      List attrOrgList = new ArrayList();
      String changeSetID = "";
      setMap.put("ItemID", itemId);
      setMap.put("DefaultLang", defaultLang);
      setMap.put("sessionCurrLangType", sessionCurrLangType);

      if ((accMode.equals("OPS")) || (accMode.equals(""))) {
        changeSetID = StringUtil.checkNull(prcList.get("ReleaseNo"));
        setMap.put("changeSetID", changeSetID);
        if (!changeSetID.equals("0")) {
          prcList = this.commonService.select("item_SQL.getItemAttrRevInfo", setMap);
        }
        attrOrgList = this.commonService.selectList("item_SQL.getItemRevDetailInfo", setMap);
      } else {
        changeSetID = StringUtil.checkNull(prcList.get("CurChangeSet"));
        attrOrgList = this.commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
      }

      String plainText = "";
      for (int k = 0; attrOrgList.size() > k; k++) {
        Map map = (Map)attrOrgList.get(k);
        attrRsNameMap.put(map.get("AttrTypeCode"), map.get("Name"));
        attrRsHtmlMap.put(map.get("AttrTypeCode"), map.get("HTML"));
        if (map.get("DataType").equals("MLOV")) {
          plainText = getMLovVlaue(sessionCurrLangType, itemId, StringUtil.checkNull(map.get("AttrTypeCode")));
        }
        else {
          plainText = StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(map.get("PlainText")));
        }

        attrMap = new HashMap();
        attrMap.put("AttrTypeCode", map.get("AttrTypeCode"));
        attrMap.put("Name", map.get("Name"));
        attrMap.put("PlainText", plainText);
        attrMap.put("PlainText2", map.get("PlainText2"));
        attrMap.put("LovCode", map.get("LovCode"));
        attrMap.put("BaseLovCode", map.get("BaseLovCode"));
        attrMap.put("DataType", map.get("DataType"));
        attrMap.put("IsComLang", map.get("IsComLang"));
        attrMap.put("HTML", map.get("HTML"));
        attrMap.put("AreaHeight", map.get("AreaHeight"));
        attrMap.put("ItemID", map.get("ItemID"));
        attrMap.put("AttrTypeCode", map.get("AttrTypeCode"));
        attrList.add(attrMap);
      }

      listMap.put("prcList", prcList);
      listMap.put("attrList", attrList);

      setMap.put("assigned", "1");
      List roleList = this.commonService.selectList("role_SQL.getItemTeamRoleList_gridList", setMap);
      listMap.put("roleList", roleList);

      List relItemList = new ArrayList();
      List relItemTemp = this.commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);

      String isFromItem = "Y";
      if (!source.equals("FromItemID")) isFromItem = "N";
      for (int j = 0; j < relItemTemp.size(); j++) {
        Map relItem = (Map)relItemTemp.get(j);
        Map temp = new HashMap();
        temp.put("languageID", sessionCurrLangType);
        String typeCode = (String)relItem.get("ItemTypeCode");
        String cxnCode = "CN001" + typeCode.substring(5, 7);
        temp.put("varFilter", cxnCode);
        temp.put("isFromItem", isFromItem);
        temp.put("s_itemID", relItem.get("s_itemID"));
        List relCxnItemList = this.commonService.selectList("item_SQL.getCXNItems", temp);
        relItem.put("cxnList", relCxnItemList);
        relItemList.add(j, relItem);

        List relatedAttrList = new ArrayList();
        for (int k = 0; relCxnItemList.size() > k; k++) {
          Map map = (Map)relCxnItemList.get(k);
          resultSubList.add(StringUtil.checkNull(map.get("RelIdentifier")) + " " + removeAllTag(StringUtil.checkNull(map.get("RelName"))));
          String cnItemItem = "";
          if (k > 0) {
            cnItemItem = " / " + StringUtil.checkNull(map.get("RelIdentifier")) + " " + removeAllTag(StringUtil.checkNull(map.get("RelName")));
          }
          setMap.put("ItemID", map.get("CnItemID"));
          setMap.put("DefaultLang", defaultLang);
          setMap.put("sessionCurrLangType", sessionCurrLangType);
          relatedAttrList = this.commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
          if (relatedAttrList.size() > 0) {
            for (int m = 0; m < relatedAttrList.size(); m++) {
              Map relAttrMap = (Map)relatedAttrList.get(m);
              cnItemItem = cnItemItem + StringUtil.checkNull(relAttrMap.get("Name")) + StringUtil.checkNull(relAttrMap.get("PlainText")) + StringUtil.checkNull(relAttrMap.get("HTML"));
            }
          }
          resultSubList.add(cnItemItem);
          cnItemItem = "";
        }
      }

      listMap.put("resultSubList", resultSubList);
      listMap.put("relItemList", relItemList);

      List dimInfoList = this.commonService.selectList("dim_SQL.selectDim_gridList", setMap);
      List dimResultList = new ArrayList();
      Map dimResultMap = new HashMap();
      String dimTypeName = "";
      String dimValueNames = "";
      if (dimInfoList.size() > 0) {
        for (int k = 0; k < dimInfoList.size(); k++) {
          Map map = (HashMap)dimInfoList.get(k);

          if (k > 0) {
            if (dimTypeName.equals(map.get("DimTypeName").toString())) {
              dimValueNames = dimValueNames + " / " + map.get("DimValuePath").toString();
            } else {
              dimResultMap.put("dimValueNames", dimValueNames);
              dimResultList.add(dimResultMap);
              dimResultMap = new HashMap();
              dimTypeName = map.get("DimTypeName").toString();
              dimResultMap.put("dimTypeName", dimTypeName);
              dimValueNames = map.get("DimValuePath").toString();
            }
          } else {
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

      setMap = new HashMap();
      setMap.put("s_itemID", itemId);
      List changeSetList = this.commonService.selectList("report_SQL.getChangeSetInfo", setMap);
      listMap.put("changeSetList", changeSetList);

      setMap.put("DocumentID", itemId);
      setMap.put("DocCategory", "ITM");
      setMap.put("languageID", sessionCurrLangType);
      setMap.put("changeSetID", changeSetID);
      List fileList = this.commonService.selectList("fileMgt_SQL.getFile_gridList", setMap);
      listMap.put("fileList", fileList);

      resultList.add(listMap);
    }

    return resultList;
  }
  @RequestMapping({"/itemTreeListByDim.do"})
  public String itemTreeListByDim(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception {
    Map setMap = new HashMap();
    try {
      List treeRootItemData = new ArrayList();
      List itemTreeListByDimList = new ArrayList();
      List fromItemIdList = new ArrayList();
      List dimValueList = new ArrayList();
      List dimValueNmList = new ArrayList();
      String rootItemID = StringUtil.checkNull(request.getParameter("rootItemID"));
      String rootClassCode = StringUtil.checkNull(request.getParameter("rootClassCode"));
      String dimTypeID = StringUtil.checkNull(request.getParameter("dimTypeID"));
      String cxnTypeCode = StringUtil.checkNull(request.getParameter("cxnTypeCode"));
      String selectedDimClass = StringUtil.checkNull(request.getParameter("selectedDimClass"));

      int maxTreeLevel = Integer.parseInt(request.getParameter("maxTreeLevel"));

      setMap.put("dimTypeID", dimTypeID);
      setMap.put("rootItemID", rootItemID);
      setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
      setMap.put("itemTypeCode", cxnTypeCode);
      setMap.put("classCode", rootClassCode);

      treeRootItemData = this.commonService.selectList("report_SQL.getTreeRootItem", setMap);

      itemTreeListByDimList.add(treeRootItemData);

      for (int i = 0; treeRootItemData.size() > i; i++) {
        Map tempMap0 = (Map)treeRootItemData.get(i);
        rootItemID = String.valueOf(tempMap0.get("ItemID"));
        setMap.put("ItemTypeCode", tempMap0.get("ItemTypeCode"));
        setMap.put("classCode", tempMap0.get("Level"));
      }

      Map tempMap1 = new HashMap();
      tempMap1.put("ToItemID", rootItemID);
      fromItemIdList.add(tempMap1);

      for (int i = 1; i < maxTreeLevel; i++) {
        if (fromItemIdList.size() > 0) {
          setMap.put("FromItemIdList", fromItemIdList);
          setMap.put("treeLevel", Integer.valueOf(i));
          itemTreeListByDimList.add(this.commonService.selectList("report_SQL.getItemTreeListByDimList", setMap));
          fromItemIdList = this.commonService.selectList("report_SQL.getItemTreeListByDimFromItemId", setMap);
        }

      }

      dimValueList = this.commonService.selectList("dim_SQL.getDimValueNameList", setMap);

      cmmMap.put("DimTypeID", dimTypeID);
      dimValueNmList = this.commonService.selectList("dim_SQL.getDimValueList", cmmMap);
      String dimVNm = "";
      String dWidth = "";
      String dAlign = "";
      String dType = "";
      String dSort = "";
      String classCode = "";

      for (int i = 0; i < dimValueNmList.size(); i++) {
        Map temp = (Map)dimValueNmList.get(i);
        if (i > 0) {
          dimVNm = dimVNm + "," + StringUtil.checkNull(temp.get("NAME"));
          dWidth = dWidth + ",80";
          dAlign = dAlign + ",center";
          dType = dType + ",ro";
          dSort = dSort + ",str";
        }
        else {
          dimVNm = StringUtil.checkNull(temp.get("NAME"));
          dWidth = "80";
          dAlign = "center";
          dType = "ro";
          dSort = "str";
        }
      }
      String prcTreeXml = "<rows>";
      prcTreeXml = setItemTreeXML(itemTreeListByDimList, selectedDimClass, dimValueList, rootItemID, 0, 0, prcTreeXml);
      prcTreeXml = prcTreeXml + "</rows>";
      model.put("prcTreeXml", prcTreeXml);
      model.put("rootItemID", rootItemID);
      model.put("dimTypeID", dimTypeID);
      model.put("dimVNm", dimVNm);
      model.put("dWidth", dWidth);
      model.put("dAlign", dAlign);
      model.put("dType", dType);
      model.put("dSort", dSort);
      model.put("rootClassCode", rootClassCode);
      model.put("selectedDimClass", selectedDimClass);
      model.put("cxnTypeCode", cxnTypeCode);
      model.put("maxTreeLevel", Integer.valueOf(maxTreeLevel));
      model.put("menu", getLabel(request, this.commonService));

      setMap.put("reportCode", StringUtil.checkNull(request.getParameter("reportCode"), ""));
      model.put("reportCode", StringUtil.checkNull(request.getParameter("reportCode"), ""));
      model.put("title", this.commonService.selectString("report_SQL.getReportName", setMap));
    } catch (Exception e) {
      System.out.println(e.toString());
    }

    return nextUrl("/report/itemTreeListByDim");
  }

  private String setItemTreeXML(List ItemTreeListByDimList, String selectedDimClass, List DimValueList, String comPareTreeItemId, int curLevelLoopCnt, int curLoopCnt, String prcTreeXml) {
    String CELL = "\t<cell></cell>";
    String CELL_CHECK = "\t<cell>0</cell>";
    String CELL_OPEN = "\t<cell>";
    String CELL_OPEN_CUSOR = "\t<cell style='cursor:pointer;'>";
    String CELL_CLOSE = "</cell>";
    String CLOSE = ">";
    String CELL_TOT = "";
    String ROW_OPEN = "<row id=";
    String ROW_CLOSE = "</row>";
    int maxLevel = ItemTreeListByDimList.size() - 1;
    List itemTreeList = new ArrayList();
    boolean dimCheckFlag = false;
    for (int i = curLevelLoopCnt; i < curLevelLoopCnt + 1; i++) {
      itemTreeList = (List)ItemTreeListByDimList.get(i);
      if (curLevelLoopCnt > 0) {
        comPareTreeItemId = StringUtil.checkNull(((HashMap)((List)ItemTreeListByDimList.get(i - 1)).get(curLoopCnt)).get("TREE_ID")).trim();
      }
      for (int j = 0; j < itemTreeList.size(); j++) {
        Map TempMap = (HashMap)itemTreeList.get(j);
        String ClassCode = StringUtil.checkNull(TempMap.get("Level")).trim();
        String PreTreeItemID = StringUtil.checkNull(TempMap.get("PRE_TREE_ID")).trim();
        String TreeItemID = StringUtil.checkNull(TempMap.get("TREE_ID")).trim();
        int ChildCnt = Integer.parseInt(TempMap.get("ChildCnt").toString());
        int treeLevel = Integer.parseInt(TempMap.get("TreeLevel").toString());
        String TreeName = StringUtil.checkNull(TempMap.get("TREE_NM")).replace("<", "(").replace(">", ")").replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ");
        String[] DimValueIDList = StringUtil.checkNull(TempMap.get("DimValueID")).trim().split(",");

        if ((i != 0) && (!PreTreeItemID.equals(comPareTreeItemId)))
          continue;
        prcTreeXml = prcTreeXml + "<row id='" + TreeItemID + ((ChildCnt == 0) || (i == maxLevel) ? "'>" : "' open='1'>");
        prcTreeXml = prcTreeXml + "\t\t<cell image='img_process.png'>" + TreeName + CELL_CLOSE;
        prcTreeXml = prcTreeXml + CELL_OPEN + PreTreeItemID + CELL_CLOSE;
        prcTreeXml = prcTreeXml + CELL_OPEN + TreeItemID + CELL_CLOSE;
        for (int l4d = 0; l4d < DimValueList.size(); l4d++) {
          dimCheckFlag = false;
          Map tempDimValue = (Map)DimValueList.get(l4d);
          for (String DimValueID : DimValueIDList) {
            if ((tempDimValue.get("DimValueID").equals(DimValueID)) && (ClassCode.equals(selectedDimClass))) {
              prcTreeXml = prcTreeXml + CELL_OPEN + "O" + CELL_CLOSE;
              dimCheckFlag = true;
            }
          }
          if (!dimCheckFlag) {
            prcTreeXml = prcTreeXml + CELL_OPEN + CELL_CLOSE;
          }
        }
        if ((curLevelLoopCnt < maxLevel) && (ChildCnt > 0)) {
          curLevelLoopCnt++;
          prcTreeXml = setItemTreeXML(ItemTreeListByDimList, selectedDimClass, DimValueList, comPareTreeItemId, curLevelLoopCnt, j, prcTreeXml);
          prcTreeXml = prcTreeXml + ROW_CLOSE;
          curLevelLoopCnt--;
        } else {
          prcTreeXml = prcTreeXml + ROW_CLOSE;
        }
      }
    }

    System.out.println(prcTreeXml);
    return prcTreeXml.replace("&", "&amp;");
  }

  private Map getCountMap(List conutList)
  {
    Map contMap = new HashMap();
    Map mapValue = new HashMap();
    for (int i = 0; i < conutList.size(); i++) {
      mapValue = (HashMap)conutList.get(i);
      contMap.put(mapValue.get("Identifier"), mapValue.get("CNT"));
    }

    return contMap;
  }
  private String makeGridHeader(List list, String conStr) {
    String strHeader = "";
    for (int i = 0; list.size() > i; i++) {
      Map map = (Map)list.get(i);
      String name = (String)map.get("Identifier");

      strHeader = strHeader + conStr + name;
    }
    return strHeader;
  }
  private String makeGridHeader(List list, String keyName, String conStr) {
    String strHeader = "";
    for (int i = 0; list.size() > i; i++) {
      Map map = (Map)list.get(i);
      String name = (String)map.get(keyName);

      strHeader = strHeader + conStr + name;
    }
    return strHeader;
  }

  @RequestMapping({"/itemTotalReport.do"})
  public String itemTotalReport(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    try {
      String s_itemID = StringUtil.checkNull(request.getParameter("itemID"), "");
      String arcCode = StringUtil.checkNull(request.getParameter("ArcCode"), "");
      String url = StringUtil.checkNull(request.getParameter("url"), "");
      String objType = StringUtil.checkNull(request.getParameter("objType"), "OJ00001");

      commandMap.put("ItemTypeCode", objType);
      Map modelExist = this.commonService.select("common_SQL.getMDLTypeCode_commonSelect", commandMap);

      model.put("menu", getLabel(request, this.commonService));
      model.put("s_itemID", s_itemID);
      model.put("arcCode", arcCode);
      model.put("url", url);
      model.put("objType", objType);
      model.put("modelExist", Integer.valueOf(modelExist.size()));
      model.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType"), ""));
    }
    catch (Exception e) {
      System.out.println(e.toString());
    }

    return nextUrl("/report/itemTotalReport");
  }

  @RequestMapping({"/itemDocReport.do"})
  public String itemDocReport(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response)
    throws Exception
  {
    Map target = new HashMap();

    String url = "/custom/base/report/processReport";
    if (!StringUtil.checkNull(commandMap.get("url")).equals("")) url = "/" + StringUtil.checkNull(commandMap.get("url")); try
    {
      Map setMap = new HashMap();
      String languageId = String.valueOf(commandMap.get("sessionCurrLangType"));
      String delItemsYN = StringUtil.checkNull(commandMap.get("delItemsYN"));
      setMap.put("languageID", languageId);
      setMap.put("langCode", StringUtil.checkNull(commandMap.get("sessionCurrLangCode")).toUpperCase());
      setMap.put("s_itemID", request.getParameter("s_itemID"));
      setMap.put("ArcCode", request.getParameter("ArcCode"));
      setMap.put("delItemsYN", delItemsYN);

      Map selectedItemMap = this.commonService.select("report_SQL.getItemInfo", setMap);

      setMap.put("DocumentID", request.getParameter("s_itemID"));
      setMap.put("DocCategory", "ITM");
      List L2AttachFileList = this.commonService.selectList("fileMgt_SQL.getFile_gridList", setMap);

      String defaultFont = this.commonService.selectString("report_SQL.getDefaultFont", setMap);

      String defaultLang = this.commonService.selectString("item_SQL.getDefaultLang", commandMap);
      List modelList = new ArrayList();
      List totalList = new ArrayList();

      List allTotalList = new ArrayList();
      Map allTotalMap = new HashMap();
      Map titleItemMap = new HashMap();
      String e2eModelId = "";
      Map e2eModelMap = new HashMap();
      List lowLankItemIdList = new ArrayList();
      String selectedItemPath = "";
      Map e2eAttrMap = new HashMap();
      Map e2eAttrNameMap = new HashMap();
      Map e2eAttrHtmlMap = new HashMap();
      List e2eDimResultList = new ArrayList();

      Map gItem = new HashMap();
      List pItemList = new ArrayList();
      List mainItemList = new ArrayList();

      String classCode = this.commonService.selectString("report_SQL.getItemClassCode", setMap);
      String objType = StringUtil.checkNull(commandMap.get("objType"));
      setMap.put("classCode", classCode);
      setMap.put("ItemTypeCode", objType);
      int maxLevel = Integer.parseInt(this.commonService.selectString("analysis_SQL.getItemClassMaxLevel", setMap));

      int Level = Integer.parseInt(this.commonService.selectString("report_SQL.getLevelfromClassCode", setMap));

      if (Level == 2) {
        gItem = selectedItemMap;

        setMap.put("CURRENT_ITEM", selectedItemMap.get("ItemID"));
        setMap.put("CategoryCode", "ST1");
        pItemList = this.commonService.selectList("report_SQL.getChildItemsForWord", setMap);

        for (int i = 0; i < pItemList.size(); i++) {
          Map pItemMap = (Map)pItemList.get(i);
          setMap.put("classCode", pItemMap.get("toItemClassCode"));

          int pItemLevel = Integer.parseInt(this.commonService.selectString("report_SQL.getLevelfromClassCode", setMap));
          pItemLevel++;
          if (pItemLevel != maxLevel) {
            setMap.put("CURRENT_ITEM", pItemMap.get("ToItemID"));
            setMap.put("CategoryCode", "ST1");
            mainItemList.add(this.commonService.selectList("report_SQL.getChildItemsForWord", setMap));
          }
        }
      }
      if (Level == 3) {
        setMap.put("classCode", selectedItemMap.get("ClassCode"));

        int pItemLevel = Integer.parseInt(this.commonService.selectString("report_SQL.getLevelfromClassCode", setMap));
        pItemLevel++;
        if (pItemLevel != maxLevel) {
          pItemList.add(selectedItemMap);
          setMap.put("CURRENT_ITEM", selectedItemMap.get("ItemID"));
          setMap.put("CategoryCode", "ST1");
          mainItemList.add(this.commonService.selectList("report_SQL.getChildItemsForWord", setMap));
        }

      }

      selectedItemPath = selectedItemMap.get("Identifier") + " " + selectedItemMap.get("ItemName");
      model.put("gItem", gItem);
      model.put("pItemList", pItemList);
      model.put("mainItemList", mainItemList);

      setMap.put("ClassCode", "CL01005");

      String arcCode = StringUtil.checkNull(request.getParameter("ArcCode"));
      commandMap.put("ArcCode", arcCode);
      commandMap.put("SelectMenuId", arcCode);
      Map arcFilterDimInfoMap = this.commonService.select("report_SQL.getArcFilterDimInfo", commandMap);
      String TreeSql = StringUtil.checkNull(arcFilterDimInfoMap.get("TreeSql"));
      commandMap.put("TreeSql", TreeSql);
      String outPutItems = "";
      if ((TreeSql != null) && (!"".equals(TreeSql))) {
        outPutItems = getArcDimTreeIDs(commandMap);
        commandMap.put("outPutItems", outPutItems);
      }
      setMap.put("outPutItems", outPutItems);
      modelList = this.commonService.selectList("report_SQL.getItemStrList_gridList", setMap);
      setMap.remove("ClassCode");

      getItemTotalInfo(totalList, modelList, setMap, request, commandMap, defaultLang, languageId);
      titleItemMap = selectedItemMap;
      allTotalMap.put("titleItemMap", titleItemMap);
      allTotalMap.put("totalList", totalList);

      allTotalList.add(allTotalMap);

      model.put("allTotalList", allTotalList);
      model.put("e2eModelMap", e2eModelMap);
      model.put("e2eItemInfo", selectedItemMap);
      model.put("e2eAttrMap", e2eAttrMap);
      model.put("e2eAttrNameMap", e2eAttrNameMap);
      model.put("e2eAttrHtmlMap", e2eAttrHtmlMap);
      model.put("e2eDimResultList", e2eDimResultList);

      model.put("onlyMap", request.getParameter("onlyMap"));
      model.put("paperSize", request.getParameter("paperSize"));
      model.put("menu", getLabel(request, this.commonService));
      model.put("setMap", setMap);
      model.put("defaultFont", defaultFont);
      model.put("selectedItemPath", selectedItemPath);
      String itemNameofFileNm = StringUtil.checkNull(selectedItemMap.get("ItemName")).replace("&#xa;", "");
      model.put("ItemNameOfFileNm", URLEncoder.encode(itemNameofFileNm, "UTF-8").replace("+", "%20"));
      model.put("selectedItemIdentifier", StringUtil.checkNull(selectedItemMap.get("Identifier")));
      model.put("outputType", request.getParameter("outputType"));
      if (StringUtil.checkNull(commandMap.get("url")).equals("wordExport_CJGLOBAL")) {
        MakeWordReport.makeWordExportCJGLOBAL(commandMap, model);
      }
      model.put("selectedItemMap", selectedItemMap);

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00105"));
      target.put("SCRIPT", "parent.goBack();parent.$('#isSubmit').remove();");
      System.out.println("totalList == " + totalList);
    } catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl(url);
  }

  public void getItemTotalInfo(List totalList, List modelList, Map setMap, HttpServletRequest request, HashMap commandMap, String defaultLang, String languageId)
    throws Exception
  {
    String beforFromItemID = "";
    for (int index = 0; modelList.size() > index; index++) {
      Map map = new HashMap();
      Map totalMap = new HashMap();
      Map subProcessMap = (Map)modelList.get(index);

      List detailElementList = new ArrayList();
      List relItemList = new ArrayList();
      List dimResultList = new ArrayList();
      List attachFileList = new ArrayList();

      setMap.put("s_itemID", subProcessMap.get("MyItemID"));
      setMap.put("itemId", String.valueOf(subProcessMap.get("MyItemID")));
      setMap.put("sessionCurrLangType", String.valueOf(commandMap.get("sessionCurrLangType")));
      setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
      setMap.put("attrTypeCode", commandMap.get("attrTypeCode"));

      List prcList = this.commonService.selectList("report_SQL.getItemInfo", setMap);

      Map prcMap = (Map)prcList.get(0);
      String fromItemID = StringUtil.checkNull(prcMap.get("FromItemID"));

      commandMap.put("ItemID", subProcessMap.get("MyItemID"));
      commandMap.put("DefaultLang", defaultLang);

      List attrList = new ArrayList();
      List activityList = new ArrayList();
      if ("N".equals(StringUtil.checkNull(commandMap.get("onlyMap")))) {
        attrList = this.commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
        Map attrMap = new HashMap();
        Map attrNameMap = new HashMap();
        Map attrHtmlMap = new HashMap();
        String mlovAttrText = "";
        for (int k = 0; attrList.size() > k; k++) {
          map = (Map)attrList.get(k);
          if (!map.get("DataType").equals("MLOV")) {
            attrMap.put(map.get("AttrTypeCode"), StringEscapeUtils.unescapeHtml4((String)map.get("PlainText")));
          } else {
            String mlovAttrCode = (String)map.get("AttrTypeCode");
            if ((attrMap.get(mlovAttrCode) == null) || (attrMap.get(mlovAttrCode) == ""))
              mlovAttrText = map.get("PlainText").toString();
            else {
              mlovAttrText = mlovAttrText + " / " + map.get("PlainText").toString();
            }
            attrMap.put(mlovAttrCode, mlovAttrText);
          }
          attrNameMap.put(map.get("AttrTypeCode"), map.get("Name"));
          attrHtmlMap.put(map.get("AttrTypeCode"), map.get("HTML"));
        }

        List dimInfoList = this.commonService.selectList("dim_SQL.selectDim_gridList", setMap);
        Map dimResultMap = new HashMap();
        String dimTypeName = "";
        String dimValueNames = "";

        if (dimInfoList.size() > 0) {
          for (int i = 0; i < dimInfoList.size(); i++) {
            map = (HashMap)dimInfoList.get(i);
            if (i > 0) {
              if (dimTypeName.equals(map.get("DimTypeName").toString())) {
                dimValueNames = dimValueNames + " / " + map.get("DimValueName").toString();
              } else {
                dimResultMap.put("dimValueNames", dimValueNames);
                dimResultList.add(dimResultMap);
                dimResultMap = new HashMap();
                dimTypeName = map.get("DimTypeName").toString();
                dimResultMap.put("dimTypeName", dimTypeName);
                dimValueNames = map.get("DimValueName").toString();
              }
            } else {
              dimTypeName = map.get("DimTypeName").toString();
              dimResultMap.put("dimTypeName", dimTypeName);
              dimValueNames = map.get("DimValueName").toString();
            }
          }

          dimResultMap.put("dimValueNames", dimValueNames);
          dimResultList.add(dimResultMap);
        }

        relItemList = this.commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);

        List impl = new ArrayList();
        List relItemID = new ArrayList();

        for (int j = 0; j < relItemList.size(); j++) {
          map = (Map)relItemList.get(j);
          impl.add(map.get("ClassCode"));
          relItemID.add(map.get("s_itemID"));
        }

        TreeSet relItemClassCode = new TreeSet(impl);
        ArrayList relItemClassCodeList = new ArrayList(relItemClassCode);

        List relItemNameList = new ArrayList();
        for (int j = 0; j < relItemClassCodeList.size(); j++) {
          setMap.put("typeCode", relItemClassCodeList.get(j));
          String cnName = this.commonService.selectString("common_SQL.getNameFromDic", setMap);
          relItemNameList.add(cnName);
        }

        List relItemAttrbyID = new ArrayList();
        for (int j = 0; j < relItemID.size(); j++) {
          setMap.put("itemID", relItemID.get(j));
          List temp = this.commonService.selectList("report_SQL.getItemAttr", setMap);
          relItemAttrbyID.addAll(temp);
        }
        List temp = this.commonService.selectList("attr_SQL.getItemAttrType", setMap);
        Map AttrTypeListTemp = new HashMap();
        Map AttrTypeList = new HashMap();

        for (int j = 0; j < temp.size(); j++) {
          AttrTypeListTemp = (Map)temp.get(j);
          AttrTypeList.put(AttrTypeListTemp.get("AttrTypeCode"), AttrTypeListTemp.get("DataType"));
        }
        totalMap.put("relItemClassCodeList", relItemClassCodeList);
        totalMap.put("relItemNameList", relItemNameList);
        totalMap.put("relItemID", relItemID);
        totalMap.put("relItemAttrbyID", relItemAttrbyID);
        totalMap.put("AttrTypeList", AttrTypeList);

        setMap.put("viewType", "wordReport");
        setMap.put("gubun", "M");
        if ("Y".equals(StringUtil.checkNull(commandMap.get("element")))) {
          setMap.remove("gubun");
        }
        activityList = this.commonService.selectList("item_SQL.getSubItemList_gridList", setMap);

        activityList = getActivityAttr(activityList, defaultLang, languageId, attrNameMap, attrHtmlMap);

        List activityNames = this.commonService.selectList("report_SQL.getActivityAttrName", commandMap);
        for (int k = 0; activityNames.size() > k; k++) {
          map = (Map)activityNames.get(k);
          attrNameMap.put(map.get("AttrTypeCode"), map.get("Name"));
        }

        totalMap.put("attrMap", attrMap);
        totalMap.put("attrNameMap", attrNameMap);
        totalMap.put("attrHtmlMap", attrHtmlMap);

        setMap.remove("itemTypeCode");
        setMap.put("DocumentID", String.valueOf(subProcessMap.get("MyItemID")));
        attachFileList = this.commonService.selectList("fileMgt_SQL.getFile_gridList", setMap);
      }

      setMap.remove("ModelTypeCode");
      Map modelMap = new HashMap();
      if (!"0".equals(StringUtil.checkNull(commandMap.get("modelExist")))) {
        setMap.put("MTCategory", request.getParameter("MTCategory"));
        modelMap = this.commonService.select("report_SQL.getModelIdAndSize", setMap);

        if (modelMap != null) {
          setModelMap(modelMap, request);
          Map setMap2 = new HashMap();
          setMap2.put("languageID", languageId);
          if ("N".equals(StringUtil.checkNull(commandMap.get("onlyMap"))))
          {
            detailElementList = getElementList(setMap2, modelMap);
          }
        }
      }

      totalMap.put("prcList", prcList);
      totalMap.put("modelMap", modelMap);
      totalMap.put("activityList", activityList);
      totalMap.put("elementList", detailElementList);
      totalMap.put("relItemList", relItemList);
      totalMap.put("dimResultList", dimResultList);
      totalMap.put("attachFileList", attachFileList);
      totalList.add(index, totalMap);
    }
  }

  @RequestMapping({"/itemStrListWithElement.do"})
  public String itemStrListWithElement(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    try {
      Map setMap = new HashMap();

      setMap.put("s_itemID", request.getParameter("itemID"));
      Map iteminfoMap = this.commonService.select("project_SQL.getItemInfo", setMap);
      model.put("menu", getLabel(request, this.commonService));
      model.put("s_itemID", request.getParameter("itemID"));
      model.put("modelItemClass", request.getParameter("modelItemClass"));
      model.put("elmChildList", request.getParameter("elmChildList"));
      model.put("elmInfoSheet", request.getParameter("elmInfoSheet"));
      model.put("elmClass", request.getParameter("elmClass"));
      model.put("ArcCode", request.getParameter("ArcCode"));
      model.put("multiple", request.getParameter("multiple"));

      model.put("itemTypeCode", StringUtil.checkNull(iteminfoMap.get("ItemTypeCode")));
    }
    catch (Exception e) {
      System.out.println(e.toString());
    }

    return nextUrl("/report/itemStrListWithElement");
  }

  @RequestMapping({"/itemStrListWithElementExcel.do"})
  public String itemStrListWithElementExcel(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response)
    throws Exception
  {
    HashMap target = new HashMap();
    HashMap setMap = new HashMap();
    FileOutputStream fileOutput = null;
    XSSFWorkbook wb = new XSSFWorkbook();
    try
    {
      String itemID = "";
      String ClassCode = "";
      String modelItemClass = StringUtil.checkNull(request.getParameter("modelItemClass"));

      String arcCode = StringUtil.checkNull(request.getParameter("ArcCode"));
      commandMap.put("ArcCode", arcCode);
      commandMap.put("SelectMenuId", arcCode);
      commandMap.put("modelItemClass", modelItemClass);
      Map arcFilterDimInfoMap = this.commonService.select("report_SQL.getArcFilterDimInfo", commandMap);
      String TreeSql = StringUtil.checkNull(arcFilterDimInfoMap.get("TreeSql"));
      commandMap.put("TreeSql", TreeSql);

      if ((TreeSql != null) && (!"".equals(TreeSql))) {
        String outPutItems = getArcDimTreeIDs(commandMap);
        commandMap.put("outPutItems", outPutItems);
      }

      List result = this.commonService.selectList("report_SQL.getItemStrList_gridList", commandMap);
      List resultSub = new ArrayList();
      Map menu = getLabel(request, this.commonService);
      String attType = StringUtil.checkNull(commandMap.get("AttrTypeCode"));
      String attrName = StringUtil.checkNull(commandMap.get("AttrName"));

      String defaultLang = StringUtil.checkNull(commandMap.get("sessionDefLanguageId"));

      Map selectedItemMap = this.commonService.select("report_SQL.getItemInfo", commandMap);

      XSSFSheet sheet = wb.createSheet("process report");
      sheet.createFreezePane(3, 2);
      XSSFCellStyle headerStyle = setCellHeaderStyle(wb);
      XSSFCellStyle deFaultStyle = setCellContentsStyle(wb, "");
      XSSFCellStyle selStyle = setCellContentsStyle(wb, "LIGHT_BLUE");
      XSSFCellStyle elmStyle = setCellContentsStyle(wb, "LIGHT_CORNFLOWER_BLUE");
      XSSFCellStyle contentsStyle = deFaultStyle;

      int cellIndex = 0;
      int rowIndex = 0;
      XSSFRow row = sheet.createRow(rowIndex);
      row.setHeight((short) 409);
      XSSFCell cell = null;
      rowIndex++;

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
      cell.setCellValue("AT00001");
      cell.setCellStyle(headerStyle);
      cellIndex++;

      String[] attrNameArray = attrName.split(",");
      String[] attrTypeArray = attType.split(",");

      for (int i = 0; attrTypeArray.length > i; i++) {
        cell = row.createCell(cellIndex);
        cell.setCellValue(attrTypeArray[i].replaceAll("&#39;", "").replaceAll("'", ""));
        cell.setCellStyle(headerStyle);
        cellIndex++;
      }

      cell = row.createCell(cellIndex);
      cell.setCellValue("");
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue("");
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cellIndex = 0;
      row = sheet.createRow(rowIndex);
      row.setHeight((short) 512);
      rowIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue("ItemID");
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00043")));
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00106")));
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00016")));
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00028")));
      cell.setCellStyle(headerStyle);
      cellIndex++;

      for (int i = 0; attrNameArray.length > i; i++) {
        cell = row.createCell(cellIndex);
        cell.setCellValue(attrNameArray[i].replaceAll("&#39;", "").replaceAll("'", ""));
        cell.setCellStyle(headerStyle);
        cellIndex++;
      }

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00070")));
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00105")));
      cell.setCellStyle(headerStyle);
      cellIndex++;
      String MyItemName = "";

      for (int i = 0; i < result.size(); i++) {
        Map map = (Map)result.get(i);
        itemID = String.valueOf(map.get("MyItemID"));
        ClassCode = String.valueOf(map.get("MyClassCode"));

        cellIndex = 0;
        row = sheet.createRow(rowIndex);
        row.setHeight((short) 409);
        MyItemName = StringUtil.checkNull(map.get("MyItemName")).replaceAll("&#10;", "").replaceAll("&amp;", "&");
        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("MyItemID")));
        if (modelItemClass.equals(ClassCode))
          contentsStyle = selStyle;
        else {
          contentsStyle = deFaultStyle;
        }
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("MyPath")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("Identifier")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("MyClassName")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(MyItemName);
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;

        cell = row.createCell(cellIndex);

        commandMap.put("ItemID", itemID);
        commandMap.put("DefaultLang", defaultLang);

        List attrList = this.commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
        String dataType = "";
        Map setData = new HashMap();
        List mLovList = new ArrayList();
        for (int j = 0; attrTypeArray.length > j; j++) {
          String attrType = attrTypeArray[j].replaceAll("&#39;", "").replaceAll("'", "");
          String cellValue = "";

          for (int k = 0; attrList.size() > k; k++) {
            Map attrMap = (Map)attrList.get(k);
            dataType = StringUtil.checkNull(attrMap.get("DataType"));
            if (attrMap.get("AttrTypeCode").equals(attrType)) {
              String plainText = removeAllTag(StringUtil.checkNull(attrMap.get("PlainText")), "DbToEx");
              if (dataType.equals("MLOV")) {
                plainText = getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionDefLanguageId")), itemID, attrType);
                cellValue = plainText;
              } else {
                cellValue = plainText;
              }
            }
          }
          cell = row.createCell(cellIndex);
          cell.setCellValue(cellValue);
          cell.setCellStyle(contentsStyle);
          cell.setCellType(1);
          sheet.autoSizeColumn(cellIndex);
          cellIndex++;
        }

        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("LastUpdated")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("LastUser")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;

        rowIndex++;

        if (modelItemClass.equals(ClassCode)) {
          setMap = new HashMap();
          setMap.put("itemID", itemID);
          resultSub = this.commonService.selectList("report_SQL.getElementStrInfo_gridList", setMap);
          for (int j = 0; resultSub.size() > j; j++) {
            cellIndex = 0;
            Map resultSubMap = (Map)resultSub.get(j);

            row = sheet.createRow(rowIndex);
            row.setHeight((short) 409);
            MyItemName = StringUtil.checkNull(resultSubMap.get("MyItemName")).replaceAll("&#10;", "").replaceAll("&amp;", "&");
            cell = row.createCell(cellIndex);
            cell.setCellValue(StringUtil.checkNull(resultSubMap.get("MyItemID")));
            cell.setCellStyle(deFaultStyle);
            sheet.autoSizeColumn(cellIndex);
            cellIndex++;
            cell = row.createCell(cellIndex);
            cell.setCellValue(StringUtil.checkNull(resultSubMap.get("MyPath")));
            cell.setCellStyle(deFaultStyle);
            sheet.autoSizeColumn(cellIndex);
            cellIndex++;
            cell = row.createCell(cellIndex);
            cell.setCellValue(StringUtil.checkNull(resultSubMap.get("Identifier")));
            cell.setCellStyle(deFaultStyle);
            sheet.autoSizeColumn(cellIndex);
            cellIndex++;
            cell = row.createCell(cellIndex);
            cell.setCellValue(StringUtil.checkNull(resultSubMap.get("MyClassName")));
            cell.setCellStyle(deFaultStyle);
            sheet.autoSizeColumn(cellIndex);
            cellIndex++;
            cell = row.createCell(cellIndex);
            cell.setCellValue(MyItemName);
            cell.setCellStyle(deFaultStyle);
            sheet.autoSizeColumn(cellIndex);
            cellIndex++;

            cell = row.createCell(cellIndex);

            commandMap.put("ItemID", resultSubMap.get("MyItemID"));
            commandMap.put("DefaultLang", defaultLang);

            attrList = this.commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
            dataType = "";
            setData = new HashMap();
            mLovList = new ArrayList();
            for (int jj = 0; attrTypeArray.length > jj; jj++) {
              String attrType = attrTypeArray[jj].replaceAll("&#39;", "").replaceAll("'", "");
              String cellValue = "";

              for (int k = 0; attrList.size() > k; k++) {
                Map attrMap = (Map)attrList.get(k);
                dataType = StringUtil.checkNull(attrMap.get("DataType"));
                if (attrMap.get("AttrTypeCode").equals(attrType)) {
                  String plainText = removeAllTag(StringUtil.checkNull(attrMap.get("PlainText")), "DbToEx");
                  if (dataType.equals("MLOV")) {
                    plainText = getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionDefLanguageId")), StringUtil.checkNull(resultSubMap.get("MyItemID")), attrType);
                    cellValue = plainText;
                  } else {
                    cellValue = plainText;
                  }
                }
              }
              cell = row.createCell(cellIndex);
              cell.setCellValue(cellValue);
              cell.setCellStyle(deFaultStyle);
              cell.setCellType(1);
              sheet.autoSizeColumn(cellIndex);
              cellIndex++;
            }

            cell = row.createCell(cellIndex);
            cell.setCellValue(StringUtil.checkNull(resultSubMap.get("LastUpdated")));
            cell.setCellStyle(deFaultStyle);
            sheet.autoSizeColumn(cellIndex);
            cellIndex++;
            cell = row.createCell(cellIndex);
            cell.setCellValue(StringUtil.checkNull(resultSubMap.get("LastUser")));
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

      String orgFileName1 = "ITEMLIST_" + selectedItemName1 + "_" + formatter.format(Long.valueOf(date)) + ".xlsx";
      String orgFileName2 = "ITEMLIST_" + selectedItemName2 + "_" + formatter.format(Long.valueOf(date)) + ".xlsx";
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

      String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);

      target.put("SCRIPT", "parent.doFileDown('" + orgFileName1 + "', 'excel');parent.$('#isSubmit').remove();");
    } catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    } finally {
      if (fileOutput != null) fileOutput.close();
      wb = null;
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  @RequestMapping({"/subItemListWithElmInfoSheet.do"})
  public String subItemListWithElmInfoSheet(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response)
    throws Exception
  {
    HashMap target = new HashMap();
    HashMap setMap = new HashMap();
    Map modelMap = new HashMap();
    FileOutputStream fileOutput = null;
    XSSFWorkbook wb = new XSSFWorkbook();
    int tempCellIndex = 0;
    int tempRowIndex = 0;
    try
    {
      String itemID = "";
      String s_itemID = "";
      String elm_itemID = "";
      String ClassCode = "";
      String modelItemClass = StringUtil.checkNull(request.getParameter("modelItemClass"));
      String elmChildList = StringUtil.checkNull(request.getParameter("elmChildList"));
      String elmInfoSheet = StringUtil.checkNull(request.getParameter("elmInfoSheet"));
      String elmClass = StringUtil.checkNull(request.getParameter("elmClass"));
      String MTCategory = StringUtil.checkNull(request.getParameter("MTCategory"));
      int tempIndex = elmInfoSheet.equals("Y") ? 2 : 1;
      ArrayList sheetNameList = new ArrayList();
      int shtTmpIdx = 0;
      String sheetTmpName = "";

      String arcCode = StringUtil.checkNull(request.getParameter("ArcCode"));
      commandMap.put("ArcCode", arcCode);
      commandMap.put("SelectMenuId", arcCode);
      commandMap.put("modelItemClass", modelItemClass);
      Map arcFilterDimInfoMap = this.commonService.select("report_SQL.getArcFilterDimInfo", commandMap);
      String TreeSql = StringUtil.checkNull(arcFilterDimInfoMap.get("TreeSql"));
      commandMap.put("TreeSql", TreeSql);

      if ((TreeSql != null) && (!"".equals(TreeSql))) {
        String outPutItems = getArcDimTreeIDs(commandMap);
        commandMap.put("outPutItems", outPutItems);
      }

      List result = this.commonService.selectList("report_SQL.getItemStrList_gridList", commandMap);
      List resultSub = new ArrayList();
      List elementChild = new ArrayList();
      Map menu = getLabel(request, this.commonService);
      String attType = StringUtil.checkNull(commandMap.get("AttrTypeCode"));
      String attrName = StringUtil.checkNull(commandMap.get("AttrName"));

      String defaultLang = StringUtil.checkNull(commandMap.get("sessionDefLanguageId"));

      Map selectedItemMap = this.commonService.select("report_SQL.getItemInfo", commandMap);
      String selectedItemName = StringUtil.checkNull(selectedItemMap.get("ItemName")).replace("/", "_");
      sheetNameList.add(selectedItemName);

      XSSFSheet sheet = wb.createSheet(selectedItemName);
      sheet.createFreezePane(3, 2);
      XSSFCellStyle headerStyle = setCellHeaderStyle(wb);
      XSSFCellStyle deFaultStyle = setCellContentsStyle(wb, "");
      XSSFCellStyle selStyle = setCellContentsStyle(wb, "LIGHT_GREEN");
      XSSFCellStyle elmStyle = setCellContentsStyle(wb, "LIGHT_CORNFLOWER_BLUE");
      XSSFCellStyle contentsStyle = deFaultStyle;

      int cellIndex = 0;
      int rowIndex = 0;
      XSSFRow row = sheet.createRow(rowIndex);
      row.setHeight((short) 409);
      XSSFCell cell = null;

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
      cell.setCellValue("AT00001");
      cell.setCellStyle(headerStyle);
      cellIndex++;

      String[] attrNameArray = attrName.split(",");
      String[] attrTypeArray = attType.split(",");

      for (int i = 0; attrTypeArray.length > i; i++) {
        cell = row.createCell(cellIndex);
        cell.setCellValue(attrTypeArray[i].replaceAll("&#39;", "").replaceAll("'", ""));
        cell.setCellStyle(headerStyle);
        cellIndex++;
      }

      cell = row.createCell(cellIndex);
      cell.setCellValue("");
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue("");
      cell.setCellStyle(headerStyle);
      cellIndex++;
      rowIndex++;

      cellIndex = 0;
      row = sheet.createRow(rowIndex);
      row.setHeight((short) 512);

      cell = row.createCell(cellIndex);
      cell.setCellValue("ItemID");
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00043")));
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00106")));
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00016")));
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00028")));
      cell.setCellStyle(headerStyle);
      cellIndex++;

      for (int i = 0; attrNameArray.length > i; i++) {
        cell = row.createCell(cellIndex);
        cell.setCellValue(attrNameArray[i].replaceAll("&#39;", "").replaceAll("'", ""));
        cell.setCellStyle(headerStyle);
        cellIndex++;
      }

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00070")));
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00105")));
      cell.setCellStyle(headerStyle);
      cellIndex++;
      rowIndex++;

      String MyItemName = "";

      for (int i = 0; i < result.size(); i++) {
        Map map = (Map)result.get(i);
        itemID = String.valueOf(map.get("MyItemID"));
        ClassCode = String.valueOf(map.get("MyClassCode"));

        cellIndex = 0;
        row = sheet.createRow(rowIndex);
        row.setHeight((short) 409);
        MyItemName = StringUtil.checkNull(map.get("MyItemName")).replaceAll("&#10;", "").replaceAll("&amp;", "&");
        cell = row.createCell(cellIndex);
        cell.setCellValue(itemID);
        if (modelItemClass.equals(ClassCode))
          contentsStyle = selStyle;
        else {
          contentsStyle = deFaultStyle;
        }
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("MyPath")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("Identifier")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("MyClassName")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(MyItemName);
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;

        cell = row.createCell(cellIndex);

        commandMap.put("ItemID", itemID);
        commandMap.put("DefaultLang", defaultLang);

        List attrList = this.commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
        String dataType = "";
        Map setData = new HashMap();
        List mLovList = new ArrayList();
        for (int j = 0; attrTypeArray.length > j; j++) {
          String attrType = attrTypeArray[j].replaceAll("&#39;", "").replaceAll("'", "");
          String cellValue = "";

          for (int k = 0; attrList.size() > k; k++) {
            Map attrMap = (Map)attrList.get(k);
            dataType = StringUtil.checkNull(attrMap.get("DataType"));
            if (attrMap.get("AttrTypeCode").equals(attrType)) {
              String plainText = removeAllTag(StringUtil.checkNull(attrMap.get("PlainText")), "DbToEx");
              if (dataType.equals("MLOV")) {
                plainText = getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionDefLanguageId")), itemID, attrType);
                cellValue = plainText;
              } else {
                cellValue = plainText;
              }
            }
          }
          cell = row.createCell(cellIndex);
          cell.setCellValue(cellValue);
          cell.setCellStyle(contentsStyle);
          cell.setCellType(1);
          sheet.autoSizeColumn(cellIndex);
          cellIndex++;
        }

        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("LastUpdated")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("LastUser")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        rowIndex++;

        if (modelItemClass.equals(ClassCode)) {
          setMap = new HashMap();
          setMap.put("MTCategory", MTCategory);
          setMap.put("ItemID", itemID);
          setMap.put("languageID", defaultLang);
          modelMap = this.commonService.select("model_SQL.getModelViewer", setMap);
          setMap = new HashMap();
          setMap.put("languageID", defaultLang);
          setMap.put("modelID", modelMap.get("ModelID"));
          setMap.put("cxnYN", "N");
          setMap.put("classCode", elmClass);

          resultSub = this.commonService.selectList("model_SQL.getElementItemList_gridList", setMap);

          for (int j = 0; resultSub.size() > j; j++) {
            cellIndex = 0;
            contentsStyle = elmStyle;
            Map resultSubMap = (Map)resultSub.get(j);
            s_itemID = StringUtil.checkNull(resultSubMap.get("ItemID"));

            row = sheet.createRow(rowIndex);
            row.setHeight((short) 409);
            MyItemName = StringUtil.checkNull(resultSubMap.get("ItemName")).replaceAll("&#10;", "").replaceAll("&amp;", "&");
            cell = row.createCell(cellIndex);
            cell.setCellValue(s_itemID);
            cell.setCellStyle(contentsStyle);
            sheet.autoSizeColumn(cellIndex);
            cellIndex++;
            cell = row.createCell(cellIndex);
            cell.setCellValue(StringUtil.checkNull(resultSubMap.get("Path")));
            cell.setCellStyle(contentsStyle);
            sheet.autoSizeColumn(cellIndex);
            cellIndex++;
            cell = row.createCell(cellIndex);
            cell.setCellValue(StringUtil.checkNull(resultSubMap.get("Identifier")));
            cell.setCellStyle(contentsStyle);
            sheet.autoSizeColumn(cellIndex);
            cellIndex++;
            cell = row.createCell(cellIndex);
            cell.setCellValue(StringUtil.checkNull(resultSubMap.get("ClassName")));
            cell.setCellStyle(contentsStyle);
            sheet.autoSizeColumn(cellIndex);
            cellIndex++;
            cell = row.createCell(cellIndex);
            cell.setCellValue(MyItemName);
            cell.setCellStyle(contentsStyle);
            sheet.autoSizeColumn(cellIndex);
            cellIndex++;

            commandMap.put("ItemID", s_itemID);
            commandMap.put("DefaultLang", defaultLang);

            attrList = this.commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
            dataType = "";
            setData = new HashMap();
            mLovList = new ArrayList();
            for (int jj = 0; attrTypeArray.length > jj; jj++) {
              String attrType = attrTypeArray[jj].replaceAll("&#39;", "").replaceAll("'", "");
              String cellValue = "";

              for (int k = 0; attrList.size() > k; k++) {
                Map attrMap = (Map)attrList.get(k);
                dataType = StringUtil.checkNull(attrMap.get("DataType"));
                if (attrMap.get("AttrTypeCode").equals(attrType)) {
                  String plainText = removeAllTag(StringUtil.checkNull(attrMap.get("PlainText")), "DbToEx");
                  if (dataType.equals("MLOV")) {
                    plainText = getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionDefLanguageId")), s_itemID, attrType);
                    cellValue = plainText;
                  } else {
                    cellValue = plainText;
                  }
                }
              }
              cell = row.createCell(cellIndex);
              cell = row.createCell(cellIndex);
              cell.setCellValue(cellValue);
              cell.setCellStyle(contentsStyle);
              cell.setCellType(1);
              sheet.autoSizeColumn(cellIndex);
              cellIndex++;
            }

            cell = row.createCell(cellIndex);
            cell.setCellValue(StringUtil.checkNull(resultSubMap.get("LastUpdated")));
            cell.setCellStyle(contentsStyle);
            sheet.autoSizeColumn(cellIndex);
            cellIndex++;
            cell = row.createCell(cellIndex);
            cell.setCellValue(StringUtil.checkNull(resultSubMap.get("LastUser")));
            cell.setCellStyle(contentsStyle);
            sheet.autoSizeColumn(cellIndex);
            cellIndex++;
            rowIndex++;

            if (elmChildList.equals("Y")) {
              setMap = new HashMap();
              setMap.put("s_itemID", s_itemID);
              setMap.put("languageID", defaultLang);
              elementChild = this.commonService.selectList("report_SQL.getItemStrList_gridList", setMap);
              for (int a1 = 0; a1 < tempIndex; a1++) {
                if ((elmInfoSheet.equals("Y")) && (a1 > 0)) {
                  rowIndex = 0;
                  cellIndex = 0;
                  contentsStyle = deFaultStyle;
                  sheetTmpName = StringUtil.checkNull(resultSubMap.get("Identifier")) + " " + StringUtil.checkNull(resultSubMap.get("ItemName")).replace("/", "_");
                  for (int shtIdx = 0; shtIdx < sheetNameList.size(); shtIdx++) {
                    if (sheetNameList.get(shtIdx).equals(sheetTmpName)) {
                      shtTmpIdx++;
                    }
                  }
                  sheetNameList.add(sheetTmpName);

                  sheet = wb.createSheet(sheetTmpName + (shtTmpIdx > 0 ? "(" + shtTmpIdx + ")" : ""));
                  row = sheet.createRow(rowIndex);

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
                  cell.setCellValue("AT00001");
                  cell.setCellStyle(headerStyle);
                  cellIndex++;

                  attrNameArray = attrName.split(",");
                  attrTypeArray = attType.split(",");

                  for (int i2 = 0; attrTypeArray.length > i2; i2++) {
                    cell = row.createCell(cellIndex);
                    cell.setCellValue(attrTypeArray[i2].replaceAll("&#39;", "").replaceAll("'", ""));
                    cell.setCellStyle(headerStyle);
                    cellIndex++;
                  }

                  cell = row.createCell(cellIndex);
                  cell.setCellValue("");
                  cell.setCellStyle(headerStyle);
                  cellIndex++;

                  cell = row.createCell(cellIndex);
                  cell.setCellValue("");
                  cell.setCellStyle(headerStyle);
                  cellIndex++;
                  rowIndex++;

                  cellIndex = 0;
                  row = sheet.createRow(rowIndex);
                  row.setHeight((short) 512);

                  cell = row.createCell(cellIndex);
                  cell.setCellValue("ItemID");
                  cell.setCellStyle(headerStyle);
                  cellIndex++;

                  cell = row.createCell(cellIndex);
                  cell.setCellValue(String.valueOf(menu.get("LN00043")));
                  cell.setCellStyle(headerStyle);
                  cellIndex++;

                  cell = row.createCell(cellIndex);
                  cell.setCellValue(String.valueOf(menu.get("LN00106")));
                  cell.setCellStyle(headerStyle);
                  cellIndex++;

                  cell = row.createCell(cellIndex);
                  cell.setCellValue(String.valueOf(menu.get("LN00016")));
                  cell.setCellStyle(headerStyle);
                  cellIndex++;

                  cell = row.createCell(cellIndex);
                  cell.setCellValue(String.valueOf(menu.get("LN00028")));
                  cell.setCellStyle(headerStyle);
                  cellIndex++;

                  for (int i1 = 0; attrNameArray.length > i1; i1++) {
                    cell = row.createCell(cellIndex);
                    cell.setCellValue(attrNameArray[i1].replaceAll("&#39;", "").replaceAll("'", ""));
                    cell.setCellStyle(headerStyle);
                    cellIndex++;
                  }

                  cell = row.createCell(cellIndex);
                  cell.setCellValue(String.valueOf(menu.get("LN00070")));
                  cell.setCellStyle(headerStyle);
                  cellIndex++;

                  cell = row.createCell(cellIndex);
                  cell.setCellValue(String.valueOf(menu.get("LN00105")));
                  cell.setCellStyle(headerStyle);
                  cellIndex++;
                  rowIndex++;
                }

                for (int d = 0; elementChild.size() > d; d++) {
                  cellIndex = 0;
                  Map elementChildMap = (Map)elementChild.get(d);
                  elm_itemID = StringUtil.checkNull(elementChildMap.get("MyItemID"));
                  if (!s_itemID.equals(elm_itemID)) {
                    row = sheet.createRow(rowIndex);
                    row.setHeight((short) 409);
                    MyItemName = StringUtil.checkNull(elementChildMap.get("MyItemName")).replaceAll("&#10;", "").replaceAll("&amp;", "&");
                    cell = row.createCell(cellIndex);
                    cell.setCellValue(StringUtil.checkNull(elementChildMap.get("MyItemID")));
                    cell.setCellStyle(deFaultStyle);
                    sheet.autoSizeColumn(cellIndex);
                    cellIndex++;
                    cell = row.createCell(cellIndex);
                    cell.setCellValue(StringUtil.checkNull(elementChildMap.get("MyPath")));
                    cell.setCellStyle(deFaultStyle);
                    sheet.autoSizeColumn(cellIndex);
                    cellIndex++;
                    cell = row.createCell(cellIndex);
                    cell.setCellValue(StringUtil.checkNull(elementChildMap.get("Identifier")));
                    cell.setCellStyle(deFaultStyle);
                    sheet.autoSizeColumn(cellIndex);
                    cellIndex++;
                    cell = row.createCell(cellIndex);
                    cell.setCellValue(StringUtil.checkNull(elementChildMap.get("MyClassName")));
                    cell.setCellStyle(deFaultStyle);
                    sheet.autoSizeColumn(cellIndex);
                    cellIndex++;
                    cell = row.createCell(cellIndex);
                    cell.setCellValue(MyItemName);
                    cell.setCellStyle(deFaultStyle);
                    sheet.autoSizeColumn(cellIndex);
                    cellIndex++;

                    cell = row.createCell(cellIndex);

                    commandMap.put("ItemID", elementChildMap.get("MyItemID"));
                    commandMap.put("DefaultLang", defaultLang);

                    attrList = this.commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
                    dataType = "";
                    setData = new HashMap();
                    mLovList = new ArrayList();
                    for (int jj = 0; attrTypeArray.length > jj; jj++) {
                      String attrType = attrTypeArray[jj].replaceAll("&#39;", "").replaceAll("'", "");
                      String cellValue = "";

                      for (int k = 0; attrList.size() > k; k++) {
                        Map attrMap = (Map)attrList.get(k);
                        dataType = StringUtil.checkNull(attrMap.get("DataType"));
                        if (attrMap.get("AttrTypeCode").equals(attrType)) {
                          String plainText = removeAllTag(StringUtil.checkNull(attrMap.get("PlainText")), "DbToEx");
                          if (dataType.equals("MLOV")) {
                            plainText = getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionDefLanguageId")), StringUtil.checkNull(elementChildMap.get("MyItemID")), attrType);
                            cellValue = plainText;
                          } else {
                            cellValue = plainText;
                          }
                        }
                      }
                      cell = row.createCell(cellIndex);
                      cell.setCellValue(cellValue);
                      cell.setCellStyle(deFaultStyle);
                      cell.setCellType(1);
                      sheet.autoSizeColumn(cellIndex);
                      cellIndex++;
                    }

                    cell = row.createCell(cellIndex);
                    cell.setCellValue(StringUtil.checkNull(elementChildMap.get("LastUpdated")));
                    cell.setCellStyle(deFaultStyle);
                    sheet.autoSizeColumn(cellIndex);
                    cellIndex++;
                    cell = row.createCell(cellIndex);
                    cell.setCellValue(StringUtil.checkNull(elementChildMap.get("LastUser")));
                    cell.setCellStyle(deFaultStyle);
                    sheet.autoSizeColumn(cellIndex);
                    cellIndex++;
                    rowIndex++;
                  }
                }
                if (a1 == 0) {
                  tempCellIndex = cellIndex;
                  tempRowIndex = rowIndex;
                }
              }

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

      String orgFileName1 = "ITEMLIST_" + selectedItemName1 + "_" + formatter.format(Long.valueOf(date)) + ".xlsx";
      String orgFileName2 = "ITEMLIST_" + selectedItemName2 + "_" + formatter.format(Long.valueOf(date)) + ".xlsx";
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

      String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
      String useDownDRM = "";
      if ((!"".equals(useDRM)) && (!"N".equals(useDownDRM))) {
        drmInfoMap.put("funcType", "report");
        DRMUtil.drmMgt(drmInfoMap);
      }

      target.put("SCRIPT", "parent.doFileDown('" + orgFileName1 + "', 'excel');parent.$('#isSubmit').remove();");
    } catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    } finally {
      if (fileOutput != null) fileOutput.close();
      wb = null;
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  @RequestMapping({"/subItemListWithElmInfoMultiple.do"})
  public String subItemListWithElmInfoMultiple(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response)
    throws Exception
  {
    HashMap target = new HashMap();
    try {
      String s_itemID = "";
      String elm_itemID = "";
      String ClassCode = "";
      String modelItemClass = StringUtil.checkNull(request.getParameter("modelItemClass"));

      Map selectedItemMap = this.commonService.select("report_SQL.getItemInfo", commandMap);

      List treeItemList = this.commonService.selectList("report_SQL.getItemStrList_gridList", commandMap);
      commandMap.remove("multiple");
      List fileList = new ArrayList();
      String fileName = "";
      for (int i = 0; i < treeItemList.size(); i++) {
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

      String zipFileName1 = "ITEMLIST_" + selectedItemName1 + "_" + formatter.format(Long.valueOf(date)) + ".zip";
      String zipFileName2 = "ITEMLIST_" + selectedItemName2 + "_" + formatter.format(Long.valueOf(date)) + ".zip";

      String path = FileUtil.FILE_EXPORT_DIR;
      String fullPath = FileUtil.FILE_EXPORT_DIR + zipFileName2;

      File zipFile = new File(fullPath);
      File dirFile = new File(path);
      if (!dirFile.exists()) {
        dirFile.mkdirs();
      }

      ZipOutputStream zos = null;
      zos = new ZipOutputStream(new FileOutputStream(zipFile));
      zos.setEncoding("euc-kr");

      byte[] buffer = new byte[2048];
      int k = 0;
      String filePath = "";
      String file = "";
      for (int i = 0; i < fileList.size(); i++) {
        file = StringUtil.checkNull(fileList.get(i));
        filePath = path + file;
        BufferedInputStream bis = new BufferedInputStream(new FileInputStream(filePath));
        zos.putNextEntry(new ZipEntry(file));

        int length = 0;
        while ((length = bis.read(buffer)) != -1) {
          zos.write(buffer, 0, length);
        }

        zos.closeEntry();
        bis.close();
      }
      zos.closeEntry();
      zos.close();

      target.put("SCRIPT", "parent.doFileDown('" + zipFileName1 + "', 'excel');parent.$('#isSubmit').remove();");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  private String makeSubItemListWithElmInfoMultiple(HttpServletRequest request, HashMap commandMap, ModelMap model)
    throws Exception
  {
    HashMap setMap = new HashMap();
    FileOutputStream fileOutput = null;
    XSSFWorkbook wb = new XSSFWorkbook();
    int tempCellIndex = 0;
    int tempRowIndex = 0;
    String returnFile = "";
    try
    {
      String itemID = "";
      String s_itemID = "";
      String elm_itemID = "";
      String ClassCode = "";
      String[] modelItemClasses = StringUtil.checkNull(request.getParameter("modelItemClass")).split(",");
      String elmChildList = StringUtil.checkNull(request.getParameter("elmChildList"));
      String elmInfoSheet = StringUtil.checkNull(request.getParameter("elmInfoSheet"));
      String elmClass = StringUtil.checkNull(request.getParameter("elmClass"));
      int tempIndex = elmInfoSheet.equals("Y") ? 2 : 1;

      String selectedItemClassCode = StringUtil.checkNull(commandMap.get("myClassCode"));
      Map modelItemClassMap = new HashMap();
      String modelItemClass = "";
      if (modelItemClasses.length > 0) {
        for (int i = 0; i < modelItemClasses.length; i++) {
          if (selectedItemClassCode.equals(StringUtil.checkNull(modelItemClasses[i]))) {
            modelItemClass = StringUtil.checkNull(modelItemClasses[i]);
            commandMap.put("modelItemClass", StringUtil.checkNull(modelItemClasses[i]));
          }
        }

      }

      String arcCode = StringUtil.checkNull(request.getParameter("ArcCode"));
      commandMap.put("ArcCode", arcCode);
      commandMap.put("SelectMenuId", arcCode);

      Map arcFilterDimInfoMap = this.commonService.select("report_SQL.getArcFilterDimInfo", commandMap);
      String TreeSql = StringUtil.checkNull(arcFilterDimInfoMap.get("TreeSql"));
      commandMap.put("TreeSql", TreeSql);

      if ((TreeSql != null) && (!"".equals(TreeSql))) {
        String outPutItems = getArcDimTreeIDs(commandMap);
        commandMap.put("outPutItems", outPutItems);
      }

      List result = this.commonService.selectList("report_SQL.getItemStrList_gridList", commandMap);
      List resultSub = new ArrayList();
      List elementChild = new ArrayList();
      Map menu = getLabel(request, this.commonService);
      String attType = StringUtil.checkNull(commandMap.get("AttrTypeCode"));
      String attrName = StringUtil.checkNull(commandMap.get("AttrName"));

      String defaultLang = StringUtil.checkNull(commandMap.get("sessionDefLanguageId"));

      Map selectedItemMap = this.commonService.select("report_SQL.getItemInfo", commandMap);
      String selectedItemName = StringUtil.checkNull(selectedItemMap.get("ItemName"));
      XSSFSheet sheet = wb.createSheet(selectedItemName);
      sheet.createFreezePane(3, 2);
      XSSFCellStyle headerStyle = setCellHeaderStyle(wb);
      XSSFCellStyle deFaultStyle = setCellContentsStyle(wb, "");
      XSSFCellStyle selStyle = setCellContentsStyle(wb, "LIGHT_GREEN");
      XSSFCellStyle elmStyle = setCellContentsStyle(wb, "LIGHT_CORNFLOWER_BLUE");
      XSSFCellStyle contentsStyle = deFaultStyle;

      int cellIndex = 0;
      int rowIndex = 0;
      XSSFRow row = sheet.createRow(rowIndex);
      row.setHeight((short) 409);
      XSSFCell cell = null;

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
      cell.setCellValue("AT00001");
      cell.setCellStyle(headerStyle);
      cellIndex++;

      String[] attrNameArray = attrName.split(",");
      String[] attrTypeArray = attType.split(",");

      for (int i = 0; attrTypeArray.length > i; i++) {
        cell = row.createCell(cellIndex);
        cell.setCellValue(attrTypeArray[i].replaceAll("&#39;", "").replaceAll("'", ""));
        cell.setCellStyle(headerStyle);
        cellIndex++;
      }

      cell = row.createCell(cellIndex);
      cell.setCellValue("");
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue("");
      cell.setCellStyle(headerStyle);
      cellIndex++;
      rowIndex++;

      cellIndex = 0;
      row = sheet.createRow(rowIndex);
      row.setHeight((short) 512);

      cell = row.createCell(cellIndex);
      cell.setCellValue("ItemID");
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00043")));
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00106")));
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00016")));
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00028")));
      cell.setCellStyle(headerStyle);
      cellIndex++;

      for (int i = 0; attrNameArray.length > i; i++) {
        cell = row.createCell(cellIndex);
        cell.setCellValue(attrNameArray[i].replaceAll("&#39;", "").replaceAll("'", ""));
        cell.setCellStyle(headerStyle);
        cellIndex++;
      }

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00070")));
      cell.setCellStyle(headerStyle);
      cellIndex++;

      cell = row.createCell(cellIndex);
      cell.setCellValue(String.valueOf(menu.get("LN00105")));
      cell.setCellStyle(headerStyle);
      cellIndex++;
      rowIndex++;

      String MyItemName = "";

      for (int i = 0; i < result.size(); i++) {
        Map map = (Map)result.get(i);
        itemID = String.valueOf(map.get("MyItemID"));
        ClassCode = String.valueOf(map.get("MyClassCode"));

        cellIndex = 0;
        row = sheet.createRow(rowIndex);
        row.setHeight((short) 409);
        MyItemName = StringUtil.checkNull(map.get("MyItemName")).replaceAll("&#10;", "").replaceAll("&amp;", "&");
        cell = row.createCell(cellIndex);
        cell.setCellValue(itemID);
        if (modelItemClass.equals(ClassCode))
          contentsStyle = selStyle;
        else {
          contentsStyle = deFaultStyle;
        }
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("MyPath")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("Identifier")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("MyClassName")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(MyItemName);
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;

        cell = row.createCell(cellIndex);

        commandMap.put("ItemID", itemID);
        commandMap.put("DefaultLang", defaultLang);

        List attrList = this.commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
        String dataType = "";
        Map setData = new HashMap();
        List mLovList = new ArrayList();
        for (int j = 0; attrTypeArray.length > j; j++) {
          String attrType = attrTypeArray[j].replaceAll("&#39;", "").replaceAll("'", "");
          String cellValue = "";

          for (int k = 0; attrList.size() > k; k++) {
            Map attrMap = (Map)attrList.get(k);
            dataType = StringUtil.checkNull(attrMap.get("DataType"));
            if (attrMap.get("AttrTypeCode").equals(attrType)) {
              String plainText = removeAllTag(StringUtil.checkNull(attrMap.get("PlainText")), "DbToEx");
              if (dataType.equals("MLOV")) {
                plainText = getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionDefLanguageId")), itemID, attrType);
                cellValue = plainText;
              } else {
                cellValue = plainText;
              }
            }
          }
          cell = row.createCell(cellIndex);
          cell.setCellValue(cellValue);
          cell.setCellStyle(contentsStyle);
          cell.setCellType(1);
          sheet.autoSizeColumn(cellIndex);
          cellIndex++;
        }

        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("LastUpdated")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        cell = row.createCell(cellIndex);
        cell.setCellValue(StringUtil.checkNull(map.get("LastUser")));
        cell.setCellStyle(contentsStyle);
        sheet.autoSizeColumn(cellIndex);
        cellIndex++;
        rowIndex++;

        if (modelItemClass.equals(ClassCode)) {
          setMap = new HashMap();
          setMap.put("itemID", itemID);
          setMap.put("elmClass", elmClass);
          setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
          resultSub = this.commonService.selectList("report_SQL.getElementStrInfo_gridList", setMap);
          for (int j = 0; resultSub.size() > j; j++) {
            cellIndex = 0;
            contentsStyle = elmStyle;
            Map resultSubMap = (Map)resultSub.get(j);
            s_itemID = StringUtil.checkNull(resultSubMap.get("MyItemID"));

            row = sheet.createRow(rowIndex);
            row.setHeight((short) 409);
            MyItemName = StringUtil.checkNull(resultSubMap.get("MyItemName")).replaceAll("&#10;", "").replaceAll("&amp;", "&");
            cell = row.createCell(cellIndex);
            cell.setCellValue(s_itemID);
            cell.setCellStyle(contentsStyle);
            sheet.autoSizeColumn(cellIndex);
            cellIndex++;
            cell = row.createCell(cellIndex);
            cell.setCellValue(StringUtil.checkNull(resultSubMap.get("MyPath")));
            cell.setCellStyle(contentsStyle);
            sheet.autoSizeColumn(cellIndex);
            cellIndex++;
            cell = row.createCell(cellIndex);
            cell.setCellValue(StringUtil.checkNull(resultSubMap.get("Identifier")));
            cell.setCellStyle(contentsStyle);
            sheet.autoSizeColumn(cellIndex);
            cellIndex++;
            cell = row.createCell(cellIndex);
            cell.setCellValue(StringUtil.checkNull(resultSubMap.get("MyClassName")));
            cell.setCellStyle(contentsStyle);
            sheet.autoSizeColumn(cellIndex);
            cellIndex++;
            cell = row.createCell(cellIndex);
            cell.setCellValue(MyItemName);
            cell.setCellStyle(contentsStyle);
            sheet.autoSizeColumn(cellIndex);
            cellIndex++;

            commandMap.put("ItemID", s_itemID);
            commandMap.put("DefaultLang", defaultLang);

            attrList = this.commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
            dataType = "";
            setData = new HashMap();
            mLovList = new ArrayList();
            for (int jj = 0; attrTypeArray.length > jj; jj++) {
              String attrType = attrTypeArray[jj].replaceAll("&#39;", "").replaceAll("'", "");
              String cellValue = "";

              for (int k = 0; attrList.size() > k; k++) {
                Map attrMap = (Map)attrList.get(k);
                dataType = StringUtil.checkNull(attrMap.get("DataType"));
                if (attrMap.get("AttrTypeCode").equals(attrType)) {
                  String plainText = removeAllTag(StringUtil.checkNull(attrMap.get("PlainText")), "DbToEx");
                  if (dataType.equals("MLOV")) {
                    plainText = getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionDefLanguageId")), s_itemID, attrType);
                    cellValue = plainText;
                  } else {
                    cellValue = plainText;
                  }
                }
              }
              cell = row.createCell(cellIndex);
              cell = row.createCell(cellIndex);
              cell.setCellValue(cellValue);
              cell.setCellStyle(contentsStyle);
              cell.setCellType(1);
              sheet.autoSizeColumn(cellIndex);
              cellIndex++;
            }

            cell = row.createCell(cellIndex);
            cell.setCellValue(StringUtil.checkNull(resultSubMap.get("LastUpdated")));
            cell.setCellStyle(contentsStyle);
            sheet.autoSizeColumn(cellIndex);
            cellIndex++;
            cell = row.createCell(cellIndex);
            cell.setCellValue(StringUtil.checkNull(resultSubMap.get("LastUser")));
            cell.setCellStyle(contentsStyle);
            sheet.autoSizeColumn(cellIndex);
            cellIndex++;
            rowIndex++;

            if (elmChildList.equals("Y")) {
              setMap = new HashMap();
              setMap.put("s_itemID", s_itemID);
              setMap.put("languageID", defaultLang);
              elementChild = this.commonService.selectList("report_SQL.getItemStrList_gridList", setMap);
              for (int a1 = 0; a1 < tempIndex; a1++) {
                if ((elmInfoSheet.equals("Y")) && (a1 > 0)) {
                  rowIndex = 0;
                  cellIndex = 0;
                  contentsStyle = deFaultStyle;
                  try {
                    sheet = wb.createSheet(StringUtil.checkNull(resultSubMap.get("Identifier")) + " " + StringUtil.checkNull(resultSubMap.get("MyItemName"))); } catch (Exception localException1) {
                  }
                  row = sheet.createRow(rowIndex);

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
                  cell.setCellValue("AT00001");
                  cell.setCellStyle(headerStyle);
                  cellIndex++;

                  attrNameArray = attrName.split(",");
                  attrTypeArray = attType.split(",");

                  for (int i2 = 0; attrTypeArray.length > i2; i2++) {
                    cell = row.createCell(cellIndex);
                    cell.setCellValue(attrTypeArray[i2].replaceAll("&#39;", "").replaceAll("'", ""));
                    cell.setCellStyle(headerStyle);
                    cellIndex++;
                  }

                  cell = row.createCell(cellIndex);
                  cell.setCellValue("");
                  cell.setCellStyle(headerStyle);
                  cellIndex++;

                  cell = row.createCell(cellIndex);
                  cell.setCellValue("");
                  cell.setCellStyle(headerStyle);
                  cellIndex++;
                  rowIndex++;

                  cellIndex = 0;
                  row = sheet.createRow(rowIndex);
                  row.setHeight((short) 512);

                  cell = row.createCell(cellIndex);
                  cell.setCellValue("ItemID");
                  cell.setCellStyle(headerStyle);
                  cellIndex++;

                  cell = row.createCell(cellIndex);
                  cell.setCellValue(String.valueOf(menu.get("LN00043")));
                  cell.setCellStyle(headerStyle);
                  cellIndex++;

                  cell = row.createCell(cellIndex);
                  cell.setCellValue(String.valueOf(menu.get("LN00106")));
                  cell.setCellStyle(headerStyle);
                  cellIndex++;

                  cell = row.createCell(cellIndex);
                  cell.setCellValue(String.valueOf(menu.get("LN00016")));
                  cell.setCellStyle(headerStyle);
                  cellIndex++;

                  cell = row.createCell(cellIndex);
                  cell.setCellValue(String.valueOf(menu.get("LN00028")));
                  cell.setCellStyle(headerStyle);
                  cellIndex++;

                  for (int i1 = 0; attrNameArray.length > i1; i1++) {
                    cell = row.createCell(cellIndex);
                    cell.setCellValue(attrNameArray[i1].replaceAll("&#39;", "").replaceAll("'", ""));
                    cell.setCellStyle(headerStyle);
                    cellIndex++;
                  }

                  cell = row.createCell(cellIndex);
                  cell.setCellValue(String.valueOf(menu.get("LN00070")));
                  cell.setCellStyle(headerStyle);
                  cellIndex++;

                  cell = row.createCell(cellIndex);
                  cell.setCellValue(String.valueOf(menu.get("LN00105")));
                  cell.setCellStyle(headerStyle);
                  cellIndex++;
                  rowIndex++;
                }

                for (int d = 0; elementChild.size() > d; d++) {
                  cellIndex = 0;
                  Map elementChildMap = (Map)elementChild.get(d);
                  elm_itemID = StringUtil.checkNull(elementChildMap.get("MyItemID"));
                  if (!s_itemID.equals(elm_itemID)) {
                    row = sheet.createRow(rowIndex);
                    row.setHeight((short) 409);
                    MyItemName = StringUtil.checkNull(elementChildMap.get("MyItemName")).replaceAll("&#10;", "").replaceAll("&amp;", "&");
                    cell = row.createCell(cellIndex);
                    cell.setCellValue(StringUtil.checkNull(elementChildMap.get("MyItemID")));
                    cell.setCellStyle(deFaultStyle);
                    sheet.autoSizeColumn(cellIndex);
                    cellIndex++;
                    cell = row.createCell(cellIndex);
                    cell.setCellValue(StringUtil.checkNull(elementChildMap.get("MyPath")));
                    cell.setCellStyle(deFaultStyle);
                    sheet.autoSizeColumn(cellIndex);
                    cellIndex++;
                    cell = row.createCell(cellIndex);
                    cell.setCellValue(StringUtil.checkNull(elementChildMap.get("Identifier")));
                    cell.setCellStyle(deFaultStyle);
                    sheet.autoSizeColumn(cellIndex);
                    cellIndex++;
                    cell = row.createCell(cellIndex);
                    cell.setCellValue(StringUtil.checkNull(elementChildMap.get("MyClassName")));
                    cell.setCellStyle(deFaultStyle);
                    sheet.autoSizeColumn(cellIndex);
                    cellIndex++;
                    cell = row.createCell(cellIndex);
                    cell.setCellValue(MyItemName);
                    cell.setCellStyle(deFaultStyle);
                    sheet.autoSizeColumn(cellIndex);
                    cellIndex++;

                    cell = row.createCell(cellIndex);

                    commandMap.put("ItemID", elementChildMap.get("MyItemID"));
                    commandMap.put("DefaultLang", defaultLang);

                    attrList = this.commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
                    dataType = "";
                    setData = new HashMap();
                    mLovList = new ArrayList();
                    for (int jj = 0; attrTypeArray.length > jj; jj++) {
                      String attrType = attrTypeArray[jj].replaceAll("&#39;", "").replaceAll("'", "");
                      String cellValue = "";

                      for (int k = 0; attrList.size() > k; k++) {
                        Map attrMap = (Map)attrList.get(k);
                        dataType = StringUtil.checkNull(attrMap.get("DataType"));
                        if (attrMap.get("AttrTypeCode").equals(attrType)) {
                          String plainText = removeAllTag(StringUtil.checkNull(attrMap.get("PlainText")), "DbToEx");
                          if (dataType.equals("MLOV")) {
                            plainText = getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionDefLanguageId")), StringUtil.checkNull(elementChildMap.get("MyItemID")), attrType);
                            cellValue = plainText;
                          } else {
                            cellValue = plainText;
                          }
                        }
                      }
                      cell = row.createCell(cellIndex);
                      cell.setCellValue(cellValue);
                      cell.setCellStyle(deFaultStyle);
                      cell.setCellType(1);
                      sheet.autoSizeColumn(cellIndex);
                      cellIndex++;
                    }

                    cell = row.createCell(cellIndex);
                    cell.setCellValue(StringUtil.checkNull(elementChildMap.get("LastUpdated")));
                    cell.setCellStyle(deFaultStyle);
                    sheet.autoSizeColumn(cellIndex);
                    cellIndex++;
                    cell = row.createCell(cellIndex);
                    cell.setCellValue(StringUtil.checkNull(elementChildMap.get("LastUser")));
                    cell.setCellStyle(deFaultStyle);
                    sheet.autoSizeColumn(cellIndex);
                    cellIndex++;
                    rowIndex++;
                  }
                }
                if (a1 == 0) {
                  tempCellIndex = cellIndex;
                  tempRowIndex = rowIndex;
                }
              }

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

      String orgFileName1 = "ITEMLIST_" + selectedItemName1 + "_" + formatter.format(Long.valueOf(date)) + ".xlsx";
      String orgFileName2 = "ITEMLIST_" + selectedItemName2 + "_" + formatter.format(Long.valueOf(date)) + ".xlsx";
      returnFile = "ITEMLIST_" + itemName + "_" + formatter.format(Long.valueOf(date)) + ".xlsx";
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

      String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
      String useDownDRM = "";
      if ((!"".equals(useDRM)) && (!"N".equals(useDownDRM))) {
        drmInfoMap.put("funcType", "report");
        DRMUtil.drmMgt(drmInfoMap);
      }
    } catch (Exception e) {
      System.out.println(e);
    } finally {
      if (fileOutput != null) fileOutput.close();
      wb = null;
    }
    return returnFile;
  }

  private Map setUploadMapItemTeam(XSSFSheet sheet, String option, HashMap commandMap, BufferedWriter errorLog) throws Exception {
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

    for (int i = 0; i < rowCount; i++)
    {
      row = sheet.getRow(i);
      colCount = row.getPhysicalNumberOfCells();

      for (int j = 0; j < colCount; j++) {
        cell = row.getCell(j);

        if (cell.getCellType() == 0)
          data[i][j] = StringUtil.checkNull(cell.getRawValue());
        else {
          data[i][j] = StringUtil.checkNull(cell);
        }
      }

      if (i > 0)
      {
        String msg = checkValueForTeamMapping(i, data, option, langCode, errorLog);
        if (!msg.isEmpty()) {
          excelMap.put("msg", msg);
        }

        Map map = new HashMap();

        map.put("RNUM", Integer.valueOf(i));
        map.put("TeamCode", data[i][0]);
        map.put("TeamName", replaceSingleQuotation(data[i][1]));
        map.put("Identifier", data[i][2]);
        map.put("ClassCode", data[i][3]);
        map.put("ItemName", replaceSingleQuotation(data[i][4]));
        map.put("TeamRoleCategory", replaceSingleQuotation(data[i][5]));
        map.put("RoleTypeCode", data[i][6]);
        list.add(map);
        valCnt++;
      }
      totalCnt++;
    }

    excelMap.put("list", list);
    excelMap.put("validCnt", Integer.valueOf(valCnt));
    excelMap.put("totalCnt", Integer.valueOf(totalCnt));
    excelMap.put("attrTypeCodeCnt", Integer.valueOf(attrTypeColNum));
    excelMap.put("colsName", "Identifier|ClassCode|ItemName|TeamCode|TeamName|TeamRoleCategory|RoleTypeCode");

    return excelMap;
  }

  private String checkValueForTeamMapping(int i, String[][] data, String option, String langCode, BufferedWriter errorLog) throws Exception {
    String msg = "";
    Map commandMap = new HashMap();

    if (data[i][0].isEmpty())
    {
      msg = MessageHandler.getMessage(langCode + ".WM00107", new String[] { String.valueOf(i + 1), "From ItemID" });
      errorLog.write(msg);
      errorLog.newLine();
    }

    if (data[i][3].isEmpty())
    {
      msg = MessageHandler.getMessage(langCode + ".WM00107", new String[] { String.valueOf(i + 1), "Team Code" });
      errorLog.write(msg);
      errorLog.newLine();
    }

    if (data[i][6].isEmpty()) {
      msg = "Input Connection Type of row " + (i + 1);
      errorLog.write(msg);
      errorLog.newLine();
    }

    return msg;
  }

  private Map setUploadMapItemMember(XSSFSheet sheet, String option, HashMap commandMap, BufferedWriter errorLog) throws Exception {
    Map excelMap = new HashMap();

    int attrTypeColNum = 1;
    String[][] data = null;
    List list = new ArrayList();
    int valCnt = 0;
    int totalCnt = 0;
    int idx = 1;

    int rowCount = sheet.getPhysicalNumberOfRows();
    int colCount = sheet.getRow(0).getPhysicalNumberOfCells();

    data = new String[rowCount][colCount];

    XSSFRow row = null;
    XSSFCell cell = null;

    String langCode = String.valueOf(commandMap.get("sessionCurrLangCode"));

    for (int i = 0; i < rowCount; i++)
    {
      row = sheet.getRow(i);
      colCount = row.getPhysicalNumberOfCells();

      for (int j = 0; j < colCount; j++) {
        cell = row.getCell(j);

        if (cell.getCellType() == 0)
          data[i][j] = StringUtil.checkNull(cell.getRawValue());
        else {
          data[i][j] = StringUtil.checkNull(cell);
        }
      }

      if (i > 0)
      {
        String msg = checkValueForMemberMapping(i, data, option, langCode, errorLog);
        if (!msg.isEmpty()) {
          excelMap.put("msg", msg);
        }

        if (!data[i][0].isEmpty()) {
          Map setData = new HashMap();
          String employeeNum = StringUtil.checkNull(data[i][0]);
          setData.put("employeeNum", employeeNum);
          String employeeCnt = this.commonService.selectString("user_SQL.getMemberIDFromEmpNOCNT", setData);

          if (Integer.parseInt(employeeCnt) == 1) {
            Map map = new HashMap();

            map.put("RNUM", Integer.valueOf(idx));
            map.put("EmployeeNum", data[i][0]);
            map.put("MemberName", replaceSingleQuotation(data[i][1]));
            map.put("Identifier", data[i][2]);
            map.put("ClassCode", data[i][3]);
            map.put("ItemName", replaceSingleQuotation(data[i][4]));
            map.put("AssignmentType", data[i][5]);
            map.put("RoleType", data[i][6]);

            list.add(map);
            valCnt++;
            idx++;
          }
        }
      }
      totalCnt++;
    }

    excelMap.put("list", list);
    excelMap.put("validCnt", Integer.valueOf(valCnt));
    excelMap.put("totalCnt", Integer.valueOf(totalCnt));
    excelMap.put("attrTypeCodeCnt", Integer.valueOf(attrTypeColNum));
    excelMap.put("colsName", "Identifier|ClassCode|ItemName|EmployeeNum|MemberName|AssignmentType|RoleType");

    return excelMap;
  }

  private String checkValueForMemberMapping(int i, String[][] data, String option, String langCode, BufferedWriter errorLog) throws Exception {
    String msg = "";
    Map commandMap = new HashMap();

    if (data[i][0].isEmpty()) {
      msg = MessageHandler.getMessage(langCode + ".WM00107", new String[] { String.valueOf(i + 1), "EmployeeNum" });
      errorLog.write(msg);
      errorLog.newLine();
    }

    if (data[i][2].isEmpty()) {
      msg = MessageHandler.getMessage(langCode + ".WM00107", new String[] { String.valueOf(i + 1), "Item Code" });
      errorLog.write(msg);
      errorLog.newLine();
    }

    if (data[i][5].isEmpty()) {
      msg = MessageHandler.getMessage(langCode + ".WM00107", new String[] { String.valueOf(i + 1), "Role Category" });
      errorLog.write(msg);
      errorLog.newLine();
    }

    if (data[i][6].isEmpty()) {
      msg = MessageHandler.getMessage(langCode + ".WM00107", new String[] { String.valueOf(i + 1), "Role Type" });
      errorLog.write(msg);
      errorLog.newLine();
    }

    if (!data[i][0].isEmpty()) {
      Map setData = new HashMap();
      String employeeNum = StringUtil.checkNull(data[i][0]);
      setData.put("employeeNum", employeeNum);
      String employeeCnt = this.commonService.selectString("user_SQL.getMemberIDFromEmpNOCNT", setData);
      if (Integer.parseInt(employeeCnt) > 1)
      {
        msg = "Employee number : " + employeeNum + " is duplicated.";
        errorLog.write(msg);
        errorLog.newLine();
      }
    }

    return msg;
  }
  @RequestMapping({"/itemMstListWLang.do"})
  public String itemMstListWLang(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    try {
      Map setMap = new HashMap();
      setMap.put("s_itemID", request.getParameter("itemID"));
      Map iteminfoMap = this.commonService.select("project_SQL.getItemInfo", setMap);

      model.put("menu", getLabel(request, this.commonService));
      model.put("s_itemID", request.getParameter("itemID"));
      model.put("ArcCode", request.getParameter("ArcCode"));
      model.put("itemTypeCode", StringUtil.checkNull(iteminfoMap.get("ItemTypeCode")));
      model.put("itemMstListWLang", "Y");
    }
    catch (Exception e) {
      System.out.println(e.toString());
    }

    return nextUrl("/report/hierarchStrReport");
  }
  @RequestMapping({"/exportMOJWLang.do"})
  public String itemMultiLangWithElementList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    model.put("menu", getLabel(request, this.commonService));
    return nextUrl("/report/exportMOJWLang");
  }
  @RequestMapping({"/replaceHtmlTagSpclChrctrs.do"})
  public String replaceHtmlTagSpclChrctrs(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    try {
      Map setMap = new HashMap();
      List htmlPlainTextList = this.commonService.selectList("report_SQL.getHTMLPlainText", setMap);

      String plainText = "";
      String replaceHtmlPlainText = "";
      String seq = "";
      String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
      setMap.put("lastUser", userID);

      if (htmlPlainTextList.size() > 0) {
        for (int i = 0; i < htmlPlainTextList.size(); i++) {
          Map htmlPlainTextInfo = (Map)htmlPlainTextList.get(i);

          seq = StringUtil.checkNull(htmlPlainTextInfo.get("Seq"));
          plainText = StringUtil.checkNull(htmlPlainTextInfo.get("PlainText"));
          replaceHtmlPlainText = StringEscapeUtils.unescapeHtml4(plainText);

          setMap.put("seq", seq);
          setMap.put("plainText", replaceHtmlPlainText);
          this.commonService.update("report_SQL.updatePlainText", setMap);
        }
      }
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
      target.put("SCRIPT", "this.doCallBack();");
    } catch (Exception e) {
      System.out.println(e.toString());
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }
  @RequestMapping({"/removeInvalidXMLCharacter.do"})
  public String removeInvalidXMLCharacter(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    try {
      Map setMap = new HashMap();
      this.commonService.update("report_SQL.updateRemoveInvalidXMLCharacter", setMap);

      List xmlPlainTextList = this.commonService.selectList("report_SQL.getInvalidXMLCharacter", setMap);

      String plainText = "";
      String replaceHtmlPlainText = "";
      String seq = "";
      String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
      setMap.put("lastUser", userID);

      if (xmlPlainTextList.size() > 0) {
        for (int i = 0; i < xmlPlainTextList.size(); i++) {
          Map xmlPlainTextInfo = (Map)xmlPlainTextList.get(i);

          seq = StringUtil.checkNull(xmlPlainTextInfo.get("Seq"));
          plainText = StringUtil.checkNull(xmlPlainTextInfo.get("PlainText"));

          replaceHtmlPlainText = plainText.replaceAll("[^\\u0009\\u000A\\u000D\\u0020-\\uD7FF\\uE000-\\uFFFD\\u10000-\\u10FFF]+", "");

          setMap.put("seq", seq);
          setMap.put("plainText", replaceHtmlPlainText);
          this.commonService.update("report_SQL.updatePlainText", setMap);
        }
      }

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
      target.put("SCRIPT", "this.doCallBack();");
    } catch (Exception e) {
      System.out.println(e.toString());
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  @RequestMapping({"/wordReportPop.do"})
  public String wordReportPop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception
  {
    try {
      List returnData = new ArrayList();
      HashMap setMap = new HashMap();

      String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
      String scrnType = StringUtil.checkNull(request.getParameter("scrnType"), "");
      String url = StringUtil.checkNull(cmmMap.get("url"));

      setMap.put("s_itemID", s_itemID);
      String classCode = this.commonService.selectString("report_SQL.getItemClassCode", setMap);
      String l4List = getRowLankL4List(s_itemID, classCode, String.valueOf(cmmMap.get("sessionCurrLangType")));

      model.put("s_itemID", s_itemID);
      model.put("l4List", l4List);
      model.put("menu", getLabel(request, this.commonService));
      model.put("scrnType", scrnType);
      model.put("url", url);
      model.put("outputType", StringUtil.checkNull(cmmMap.get("outputType")));

      HttpSession session = request.getSession(true);

      session.setAttribute("expFlag", "N");
    }
    catch (Exception e) {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }
    return nextUrl("/popup/wordReportPop");
  }

  private String getRowLankL4List(String selectedItemId, String classCode, String languageID)
    throws ExceptionUtil
  {
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
        setMap.put("CURRENT_ITEM", itemId);
        setMap.put("CategoryCode", "ST1");
        setMap.put("languageID", languageID);
        setMap.put("toItemClassCode", "CL01004");
        list1 = this.commonService.selectList("report_SQL.getChildItemsForWord", setMap);
      } else if ("CL01004".equals(classCode)) {
        setMap.put("languageID", languageID);
        setMap.put("s_itemID", itemId);
        list1 = this.commonService.selectList("report_SQL.itemStDetailInfo", setMap);
        map1 = (Map)list1.get(0);
        map1.put("ToItemID", itemId);
        map1.put("toItemIdentifier", map1.get("Identifier"));
        map1.put("toItemName", map1.get("ItemName"));
        list1 = new ArrayList();
        list1.add(map1);
      }

      for (int k = 0; list1.size() > k; k++) {
        map1 = (Map)list1.get(k);
        setMap.put("CURRENT_ITEM", map1.get("ToItemID"));

        setMap.put("toItemClassCode", "CL01005");
        list2 = this.commonService.selectList("report_SQL.getChildItemsForWord", 
          setMap);

        for (int m = 0; list2.size() > m; m++) {
          map2 = (Map)list2.get(m);
          if (l4ItemList.isEmpty())
            l4ItemList = StringUtil.checkNull(map2.get("ToItemID"));
          else
            l4ItemList = l4ItemList + "," + 
              StringUtil.checkNull(map2.get("ToItemID"));
        }
      }
    }
    catch (Exception e)
    {
      throw new ExceptionUtil(e.toString());
    }

    return l4ItemList;
  }
  @RequestMapping({"/updateItemBlocked.do"})
  public String updateItemBlocked(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    try {
      Map setMap = new HashMap();
      String s_itemID = StringUtil.checkNull(commandMap.get("itemID"));
      setMap.put("s_itemID", s_itemID);
      String itemStatus = StringUtil.checkNull(this.commonService.selectString("project_SQL.getItemStatus", setMap));
      String changeSetID = StringUtil.checkNull(this.commonService.selectString("item_SQL.getItemCurChangeSet", setMap));
      String releaseNo = StringUtil.checkNull(this.commonService.selectString("item_SQL.getItemReleaseNo", setMap));
      String projectID = StringUtil.checkNull(this.commonService.selectString("item_SQL.getProjectIDFromItem", setMap));
      String blocked = StringUtil.checkNull(this.commonService.selectString("item_SQL.getItemBlocked", setMap));

      setMap.put("changeSetID", changeSetID);
      this.commonService.update("attr_SQL.deleteItemAttrRevCSID", setMap);
      this.CSActionController.insertItemAttrRev(commandMap, s_itemID, projectID, changeSetID);

      if (("REL".equals(itemStatus)) && ("0".equals(blocked))) {
        setMap.put("Blocked", "2");
      }
      else if (("REL".equals(itemStatus)) && (!"0".equals(blocked))) {
        setMap.put("Blocked", "0");
      }
      else if ((!"REL".equals(itemStatus)) && ("0".equals(blocked))) {
        setMap.put("Blocked", "2");
      }
      else {
        setMap.put("changeSetID", releaseNo);
        this.commonService.update("attr_SQL.deleteItemAttrRevCSID", setMap);
        this.CSActionController.insertItemAttrRev(commandMap, s_itemID, projectID, changeSetID);

        setMap.put("Blocked", "0");
      }

      setMap.put("ItemID", s_itemID);
      this.commonService.update("item_SQL.updateItemObjectInfo", setMap);

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
      target.put("SCRIPT", "this.doCallBack();");
    } catch (Exception e) {
      System.out.println(e.toString());
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }
}