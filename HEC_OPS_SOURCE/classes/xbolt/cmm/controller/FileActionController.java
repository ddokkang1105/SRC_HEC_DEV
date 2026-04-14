package xbolt.cmm.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import xbolt.cmm.framework.filter.XSSRequestWrapper;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.DRMUtil;
import xbolt.cmm.framework.util.DateUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

@Controller
public class FileActionController extends XboltController
{

  @Resource(name="commonService")
  private CommonService commonService;

  @RequestMapping({"/boardFileDelete.do"})
  public String boardFileDelete(HashMap cmmMap, ModelMap model)
    throws Exception
  {
    Map target = new HashMap();
    String delType = StringUtil.checkNull(cmmMap.get("delType"), "");
    if (delType.equals("1")) {
      cmmMap.put("BoardID", StringUtil.checkNull(cmmMap.get("BoardID"), ""));
      cmmMap.put("Seq", StringUtil.checkNull(cmmMap.get("Seq"), ""));
      target = this.commonService.select("boardFile_SQL.boardFile_select", cmmMap);
    }
    try
    {
      String realFile = FileUtil.FILE_UPLOAD_DIR + target.get("FileName");
      File existFile = new File(realFile);
      if ((existFile.exists()) && (existFile.isFile())) existFile.delete();
      this.commonService.delete("boardFile_SQL.boardFile_delete", cmmMap);

      System.out.println("boardFileDelete try::" + MessageHandler.getMessage(new StringBuilder().append(cmmMap.get("sessionCurrLangCode")).append(".WM00075").toString()));
      target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00075"));
    }
    catch (Exception e) {
      System.out.println(e);

      target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00076"));
    }
    model.addAttribute("resultMap", target);

    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  @RequestMapping({"/changeSetFileDelete.do"})
  public String changeSetFileDelete(HashMap cmmMap, ModelMap model) throws Exception
  {
    Map map = new HashMap();
    Map target = new HashMap();
    try
    {
      map.put("seq", StringUtil.checkNull(cmmMap.get("seq")));
      String FileName = StringUtil.checkNull(this.commonService.selectString("fileMgt_SQL.getFileSysName", map));

      String fltpCode = StringUtil.checkNull(cmmMap.get("fltpCode"));
      map.put("fltpCode", fltpCode);
      String fltpPath = StringUtil.checkNull(this.commonService.selectString("fileMgt_SQL.getFilePath", map));
      String realFile = fltpPath + FileName;

      File existFile = new File(realFile);
      if ((existFile.exists()) && (existFile.isFile())) existFile.delete();

      this.commonService.delete("project_SQL.changeSetFile_delete", cmmMap);

      target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00075"));
    }
    catch (Exception e) {
      System.out.println(e);

      target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00076"));
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }
  @RequestMapping({"/itemFileDelete.do"})
  public String itemFileDelete(HashMap cmmMap, ModelMap model) throws Exception {
    Map map = new HashMap();

    map.put("ItemID", cmmMap.get("ItemID"));
    map.put("Seq", cmmMap.get("Seq"));
    map.put("FilePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
    Map target = this.commonService.select("item_SQL.itemFile_select", map);
    try
    {
      String linkType = StringUtil.checkNull(target.get("LinkType"), "");
      String realFile = StringUtil.checkNull(target.get("fullFileName"), "");
      if ((linkType.equals("1")) && (realFile.length() > 0)) {
        File existFile = new File(realFile);
        if ((existFile.exists()) && (existFile.isFile())) existFile.delete();
      }
      this.commonService.delete("item_SQL.itemFile_delete", map);

      target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00075"));
    }
    catch (Exception e) {
      System.out.println(e);

      target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00076"));
    }
    model.addAttribute("resultMap", target);

    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  @RequestMapping({"/fileDelete.do"})
  public String fileDelete(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
    Map map = new HashMap();

    map.put("AttFileID", request.getParameter("AttFileID"));
    map.put("Seq", request.getParameter("Seq"));

    Map target = this.commonService.select("CommonFile.cmmFile_select", map);
    try
    {
      String realFile = StringUtil.checkNull(target.get("fullFileName"), "");
      if (realFile.length() > 0) {
        File existFile = new File(realFile);
        existFile.delete();
      }
      this.commonService.delete("CommonFile.cmmFile_delete", map);

      target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00075"));
    }
    catch (Exception e) {
      System.out.println(e);

      target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00076"));
    }
    model.addAttribute("resultMap", target);

    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  @RequestMapping({"/fileDeleteNoMsg.do"})
  public String fileDeleteNoMsg(Map cmmMap, ModelMap model)
    throws Exception
  {
    Map target = this.commonService.select("CommonFile.cmmFile_select", cmmMap);
    try
    {
      String realFile = FileUtil.FILE_UPLOAD_DIR + target.get("FILE_PATH") + File.separator + target.get("SYS_FILE_NAME");
      File existFile = new File(realFile);
      existFile.delete();

      this.commonService.delete("CommonFile.cmmFile_delete", cmmMap);
    }
    catch (Exception e)
    {
      System.out.println(e);
      target.put("ALERT", "파일 삭제중 오류가 발생하였습니다.");
      target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00076"));
    }
    model.addAttribute("resultMap", target);

    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  @RequestMapping({"/fileDown.do"})
  public String fileDown(HttpServletRequest request, Map cmmMap, HttpServletResponse response) throws Exception
  {
    String seq = request.getParameter("seq");
    String scrnType = request.getParameter("scrnType");
    Map setMap = new HashMap();
    setMap.put("seq", seq);
    String filename = "";
    String original = "";
    String downFile = "";
    String ORGFileDir = "";

    if ("BRD".equals(scrnType)) {
      filename = this.commonService.selectString("boardFile_SQL.getFileSysName", setMap);
      original = this.commonService.selectString("boardFile_SQL.getFileName", setMap);
      downFile = GlobalVal.FILE_UPLOAD_BOARD_DIR + filename;
      ORGFileDir = GlobalVal.FILE_UPLOAD_BOARD_DIR;
    }
    else if ("excel".equals(scrnType)) {
      filename = request.getParameter("filename");
      original = request.getParameter("original");
      // original = new String(original.getBytes("8859_1"), "UTF-8"); // 한글 깨짐 문제 
      downFile = FileUtil.FILE_EXPORT_DIR + filename;
      ORGFileDir = FileUtil.FILE_EXPORT_DIR;
    }
    else {
      filename = this.commonService.selectString("fileMgt_SQL.getFileSysName", setMap);
      original = this.commonService.selectString("fileMgt_SQL.getFileName", setMap);
      downFile = FileUtil.FILE_UPLOAD_DIR + filename;
      ORGFileDir = FileUtil.FILE_UPLOAD_DIR;
    }

    if ("".equals(filename)) {
      request.setAttribute("message", "File not found.");
      return "cmm/utl/EgovFileDown";
    }

    if ("".equals(original)) {
      original = filename;
    }

    HashMap drmInfoMap = new HashMap();

    String userID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
    String userName = StringUtil.checkNull(cmmMap.get("sessionUserNm"));
    String teamID = StringUtil.checkNull(cmmMap.get("sessionTeamId"));
    String teamName = StringUtil.checkNull(cmmMap.get("sessionTeamName"));

    drmInfoMap.put("userID", userID);
    drmInfoMap.put("userName", userName);
    drmInfoMap.put("teamID", teamID);
    drmInfoMap.put("teamName", teamName);
    drmInfoMap.put("orgFileName", original);
    drmInfoMap.put("downFile", downFile);

    String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
    String useDownDRM = "";
    String returnUrl = "";
    if ((!"".equals(useDRM)) && (!"N".equals(useDownDRM)))
    {
      drmInfoMap.put("ORGFileDir", ORGFileDir);
      drmInfoMap.put("DRMFileDir", StringUtil.checkNull(GlobalVal.DRM_DECODING_FILEPATH) + StringUtil.checkNull(cmmMap.get("sessionUserId")) + "//");
      drmInfoMap.put("Filename", original);
      drmInfoMap.put("funcType", "download");
      returnUrl = DRMUtil.drmMgt(drmInfoMap);
    }
    
    if(!"".equals(returnUrl)){
    	downFile = returnUrl;
    }
    request.setAttribute("downFile", downFile);
    request.setAttribute("orginFile", original);

    FileUtil.flMgtdownFile(request, response);
    
    if ("excel".equals(scrnType)) {
    	File existFile = new File(downFile);
		if(existFile.isFile() && existFile.exists()){existFile.delete();}
    }

    return null;
  }
  @RequestMapping({"/dsFileDown.do"})
  public String handleRequest(HttpServletRequest request, Map cmmMap, HttpServletResponse response) throws Exception { String seq = request.getParameter("seq");
    String scrnType = request.getParameter("scrnType");
    Map setMap = new HashMap();
    setMap.put("seq", seq);
    String filename = "";
    String original = "";
    String filePath = "";
    String returnValue = "";

    if ("BRD".equals(scrnType)) {
      filename = this.commonService.selectString("boardFile_SQL.getFileSysName", setMap);
      original = this.commonService.selectString("boardFile_SQL.getFileName", setMap);
      filePath = GlobalVal.FILE_UPLOAD_BOARD_DIR;
    }
    else {
      filename = this.commonService.selectString("fileMgt_SQL.getFileSysName", setMap);
      original = this.commonService.selectString("fileMgt_SQL.getFileName", setMap);
      filePath = FileUtil.FILE_UPLOAD_DIR;
    }

    String downFile = FileUtil.FILE_UPLOAD_DIR + filename;

    String enOriginal = new String(original.getBytes("8859_1"), "UTF-8");

    if ("".equals(filename)) {
      request.setAttribute("message", "File not found.");
      return "cmm/utl/EgovFileDown";
    }

    if ("".equals(original)) {
      original = filename;
    }

    HashMap drmInfoMap = new HashMap();

    String userID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
    String userName = StringUtil.checkNull(cmmMap.get("sessionUserNm"));
    String teamID = StringUtil.checkNull(cmmMap.get("sessionTeamId"));
    String teamName = StringUtil.checkNull(cmmMap.get("sessionTeamName"));

    drmInfoMap.put("userID", userID);
    drmInfoMap.put("userName", userName);
    drmInfoMap.put("teamID", teamID);
    drmInfoMap.put("teamName", teamName);
    drmInfoMap.put("orgFileName", original);
    drmInfoMap.put("downFile", downFile);

    String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
    String useDownDRM = "";
    if ((!"".equals(useDRM)) && (!"N".equals(useDownDRM)))
    {
      drmInfoMap.put("ORGFileDir", filePath);
      drmInfoMap.put("DRMFileDir", StringUtil.checkNull(GlobalVal.DRM_DECODING_FILEPATH) + StringUtil.checkNull(cmmMap.get("sessionUserId")) + "//");
      drmInfoMap.put("Filename", filename);
      drmInfoMap.put("funcType", "download");
      returnValue = DRMUtil.drmMgt(drmInfoMap);
    }

    if (!"".equals(returnValue)) {
      downFile = returnValue;
    }

    request.setAttribute("downFile", downFile);
    request.setAttribute("orginFile", enOriginal);

    FileUtil.downFile(request, response);

    return null;
  }

  @RequestMapping({"/excelDown.do"})
  public String excelDown(Map cmmMap, ModelMap model)
    throws Exception
  {
    try
    {
      String title = getString(cmmMap.get("title"));
      String[] headers = StringUtil.toArray(cmmMap.get("headers"));
      String[] cols = StringUtil.toArray(cmmMap.get("cols"));

      String caltype = (String)cmmMap.get("coltype");
      HashMap hmColTypes = new HashMap();
      if ((caltype.length() == 0) || (caltype.equals("undefined")))
      {
        for (int i = 0; i < cols.length; i++)
        {
          hmColTypes.put(cols[i], "T_C");
        }
      }
      else
      {
        String[] coltypes = StringUtil.toArray(cmmMap.get("coltype"));
        for (int i = 0; i < cols.length; i++)
        {
          hmColTypes.put(cols[i], coltypes[i]);
        }

      }

      String sqlKey = getString(cmmMap.get("key") + "_gridList");
      if (title.lastIndexOf("> ") > 0)
      {
        title = title.substring(title.lastIndexOf("> ") + 2);
      }
      model.addAttribute("fileName", URLEncoder.encode(title));
      model.addAttribute("title", title);
      model.addAttribute("headers", headers);
      model.addAttribute("cols", cols);
      model.addAttribute("coltypes", hmColTypes);
      model.addAttribute("bodyList", this.commonService.selectList(sqlKey, cmmMap));
    } catch (Exception e) {
      System.out.println(e);
      throw e;
    }
    return "forward:/WEB-INF/jsp/cmm/excelTemplate.jsp";
  }

  @RequestMapping({"/excelFileDownload.do"})
  public String excelFileDownload(Map cmmMap, ModelMap model, HttpServletResponse response)
    throws Exception
  {
    try
    {
      File file = makeExcelFile(cmmMap, model, response);
      pushFile(file, response);
    } catch (Exception e) {
      System.out.println(e.toString());
      throw e;
    }
    return null;
  }

  public File makeExcelFile(Map cmmMap, ModelMap model, HttpServletResponse response)
    throws Exception
  {
    String title = getString(cmmMap.get("title"));
    String[] headers = StringUtil.toArray(cmmMap.get("headers"));
    String[] cols = StringUtil.toArray(cmmMap.get("cols"));
    String[] widths = StringUtil.toArray(cmmMap.get("widths"));
    String[] aligns = StringUtil.toArray(cmmMap.get("aligns"));
    String sqlKey = getString(cmmMap.get("key"));

    String filepath = XboltController.getWebappRoot();
    String filename = title + ".xlsx";
    String time = DateUtil.getCurrentTime("yyyyMMddHHmmss");
    filename = time + ".xlsx";
    try {
      File file = new File(filepath + "/" + filename);
      FileOutputStream fop = new FileOutputStream(file);

      List list = this.commonService.selectList(sqlKey, cmmMap);

      XSSFWorkbook workbook = new XSSFWorkbook();
      XSSFSheet sheet = workbook.createSheet(title);

      XSSFCellStyle style = workbook.createCellStyle();
      XSSFFont font = workbook.createFont();
      font.setFontHeightInPoints((short) 14);
      font.setFontName("ARIAL");
      font.setBold(true);
      font.setItalic(false);
      font.setColor(IndexedColors.GREY_80_PERCENT.index);
      font.setUnderline((byte) 1);
      style.setFont(font);
      XSSFRow row = sheet.createRow(0);
      XSSFCell cell = row.createCell(0);
      cell.setCellStyle(style);

      style = workbook.createCellStyle();
      font.setFontHeightInPoints((short) 12);
      font.setFontName("COURIER");
      font.setBold(true);
      font.setItalic(false);
      font.setColor(IndexedColors.GREY_80_PERCENT.index);
      font.setUnderline((byte) 0);
      style.setFont(font);
      style.setFillForegroundColor(IndexedColors.GREY_50_PERCENT.index);
      style.setFillPattern((short) 1);
      style.setBorderTop((short) 1);
      style.setBorderLeft((short) 1);
      style.setBorderRight((short) 1);
      style.setBorderBottom((short) 1);
      style.setAlignment((short) 2);
      int rnum = 3;

      row = sheet.createRow(rnum);

      for (int i = 0; i < headers.length; i++) {
        cell = row.createCell(i);
        cell.setCellStyle(style);
        cell.setCellValue(headers[i]);
      }

      rnum++;
      for (Iterator localIterator = list.iterator(); localIterator.hasNext(); ) { Object o = localIterator.next();
        HashMap rowMap = (HashMap)o;
        row = sheet.createRow(rnum);
        for (int i = 0; i < cols.length; i++)
        {
          cell = row.createCell(i);
          style = workbook.createCellStyle();
          font.setFontHeightInPoints((short) 11);
          font.setFontName("TAHOMA");
          font.setBold(false);
          font.setItalic(false);
          font.setColor(IndexedColors.GREY_80_PERCENT.index);
          font.setUnderline((byte) 0);
          style.setFont(font);
          style.setFillForegroundColor(IndexedColors.GREY_50_PERCENT.index);
          style.setFillPattern((short) 1);
          style.setAlignment((short) 2);

          if ("center".equals(aligns[i])) style.setAlignment((short) 2);
          else if ("right".equals(aligns[i])) style.setAlignment((short) 3);
          else if ("left".equals(aligns[i])) style.setAlignment((short) 1);
          sheet.setColumnWidth(i, Integer.parseInt(widths[i]) * 30);

          String data = rowMap.get(cols[i]) != null ? rowMap.get(cols[i]).toString() : null;
          cell.setCellStyle(style);
          cell.setCellValue(data);
        }
        rnum++;
      }

      workbook.write(fop);
      fop.flush();
      fop.close();

      return file;
    } catch (Exception e) {
      System.out.println(e.toString());throw e;
    }
  }

  public void pushFile(File file, HttpServletResponse response)
    throws Exception
  {
    try
    {
      FileInputStream fin = new FileInputStream(file);
      int ifilesize = (int)file.length();
      String filename = file.getName();
      byte[] b = new byte[ifilesize];

      response.setContentLength(ifilesize);
      response.setContentType("application/vnd.ms-excel");
      response.setHeader("Content-Disposition", "attachment; filename=" + filename + ";");
      ServletOutputStream oout = response.getOutputStream();

      while (fin.read(b) > 0) {
        oout.write(b, 0, ifilesize);
      }
      oout.close();
      fin.close();
      file.delete();
    } catch (Exception e) {
      System.out.println(e.toString());
      throw e;
    }
  }

  @RequestMapping({"/uploadImgFileScrn.do"})
  public String uploadImgFileScrn(HashMap cmmMap, ModelMap model) throws Exception {
    return nextUrl("/cmm/imgFileUpload");
  }
  @RequestMapping({"/uploadImgFile.do"})
  public String uploadImgFile(MultipartHttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
    Map target = new HashMap();
    XSSRequestWrapper xss = new XSSRequestWrapper(request);

    List fileList = new ArrayList();
    try
    {
      Iterator fileNameIter = request.getFileNames();
      String savePath = GlobalVal.FILE_UPLOAD_TINY_DIR;
      String fileName = "";
      while (fileNameIter.hasNext()) {
        MultipartFile mFile = request.getFile((String)fileNameIter.next());
        fileName = mFile.getOriginalFilename();
        if (mFile.getSize() > 0L) {
          String ext = FileUtil.getExt(fileName);

          if (!FileUtil.isPicture(ext)) {
            target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00074"));
            target.put("SCRIPT", "parent.$('#isSubmit').remove();");
            model.addAttribute("resultMap", target);

            return nextUrl("/cmm/ajaxResult/ajaxPage");
          }
          Map fileMap = new HashMap();
          HashMap resultMap = FileUtil.uploadFile(mFile, savePath, true);
          fileName = resultMap.get("SysFileNm") + "^";
        }
      }

      target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00071"));
      target.put("SCRIPT", "parent.doReturn('" + fileName + "','');parent.$('#isSubmit').remove();");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove();");

      target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00074"));
    }
    model.addAttribute("resultMap", target);

    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }
}