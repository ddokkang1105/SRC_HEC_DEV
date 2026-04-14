package xbolt.cmm.controller;

import com.org.json.JSONArray;
import com.org.json.JSONObject;
import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.xssf.streaming.SXSSFCell;
import org.apache.poi.xssf.streaming.SXSSFRow;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import xbolt.cmm.framework.filter.XSSRequestWrapper;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.DRMUtil;
import xbolt.cmm.framework.util.DateUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.DrmGlobalVal;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

/**
 * 공통 서블릿 처리
 * @Class Name : FileActionController.java
 * @Description : 공통화면을 제공한다.
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2012. 09. 01. smartfactory		최초생성
 *
 * @since 2012. 09. 01.
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class FileActionController extends XboltController{

	@Resource(name = "commonService")
	private CommonService commonService;

	/**
	 * 게시판에 업로드된 파일을 삭제한다.
	 * 2012/12/24
	 * @param cmmMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/boardFileDelete.do")
	public String boardFileDelete(HashMap cmmMap, ModelMap model) throws Exception {
		Map target = new HashMap();		
		String delType = StringUtil.checkNull(cmmMap.get("delType"), "");
		if( delType.equals("1")){	//공지사항관련 파일 삭제
			cmmMap.put("BoardID", StringUtil.checkNull(cmmMap.get("BoardID"), ""));
			cmmMap.put("Seq", StringUtil.checkNull(cmmMap.get("Seq"), ""));
			target = commonService.select("boardFile_SQL.boardFile_select", cmmMap);	//new mode
		}
		try {
			
			String realFile = FileUtil.FILE_UPLOAD_DIR + target.get("FileName");
			File existFile = new File(realFile);
			if(existFile.exists() && existFile.isFile()){existFile.delete();}
			commonService.delete("boardFile_SQL.boardFile_delete", cmmMap);	//new mode
			/*
			if( delType.equals("BOARD")){
				//commonService.delete("CommonFile.commFile_delete", cmmMap);
			}
			 * */			
			//target.put(AJAX_ALERT, "파일 삭제가 성공하였습니다.");
			System.out.println("boardFileDelete try::"+MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00075"));
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00075")); // 성공
		}
		catch (Exception e) {
			System.out.println(e);
			//target.put(AJAX_ALERT, "파일 삭제중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00076")); // 오류
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}

	//변경이력 파일첨부 삭제
	@RequestMapping(value="/changeSetFileDelete.do")
	public String changeSetFileDelete(HashMap cmmMap, ModelMap model) throws Exception {
		//Map target = commonService.select("CommonFile.commFile_select", cmmMap);
		Map map = new HashMap();
		Map target =  new HashMap();

		try {
			map.put("seq", StringUtil.checkNull(cmmMap.get("seq")));
			String FileName = StringUtil.checkNull(commonService.selectString("fileMgt_SQL.getFileSysName", map));	//new mode
			
			String fltpCode = StringUtil.checkNull(cmmMap.get("fltpCode"));
			map.put("fltpCode", fltpCode);
			String fltpPath = StringUtil.checkNull(commonService.selectString("fileMgt_SQL.getFilePath", map));
			String realFile = fltpPath + FileName;
			
			File existFile = new File(realFile);
			if(existFile.exists() && existFile.isFile()){existFile.delete();}

			//commonService.delete("CommonFile.commFile_delete", cmmMap);
			commonService.delete("project_SQL.changeSetFile_delete", cmmMap);	//new mode

			//target.put(AJAX_ALERT, "파일 삭제가 성공하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00075")); // 성공
		}
		catch (Exception e) {
			System.out.println(e);
			//target.put(AJAX_ALERT, "파일 삭제중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00076")); // 오류
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/itemFileDelete.do")
	public String itemFileDelete(HashMap cmmMap, ModelMap model) throws Exception {
		Map map = new HashMap();
		
		map.put("ItemID", cmmMap.get("ItemID"));
		map.put("Seq", cmmMap.get("Seq"));
		map.put("FilePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
		Map target = commonService.select("item_SQL.itemFile_select", map);	//new mode

		try {
			String linkType = StringUtil.checkNull(target.get("LinkType"), "");
			String realFile = StringUtil.checkNull(target.get("fullFileName"), "");
			if(linkType.equals("1") && realFile.length() > 0){
				File existFile = new File(realFile);
				if(existFile.exists() && existFile.isFile()){existFile.delete();}
			}
			commonService.delete("item_SQL.itemFile_delete", map);	//new mode

			//target.put(AJAX_ALERT, "파일 삭제가 성공하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00075")); // 성공
		}
		catch (Exception e) {
			System.out.println(e);
			//target.put(AJAX_ALERT, "파일 삭제중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00076")); // 오류
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
	

	@RequestMapping(value="/fileDelete.do")
	public String fileDelete(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map map = new HashMap();
		
		map.put("AttFileID", request.getParameter("AttFileID"));
		map.put("Seq", request.getParameter("Seq"));
		
		Map target = commonService.select("CommonFile.cmmFile_select", map);	//new mode

		try {
			String realFile = StringUtil.checkNull(target.get("fullFileName"), "");
			if(realFile.length() > 0){
				File existFile = new File(realFile);
				existFile.delete();
			}
			commonService.delete("CommonFile.cmmFile_delete", map);	//new mode

			//target.put(AJAX_ALERT, "파일 삭제가 성공하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00075")); // 성공
		}
		catch (Exception e) {
			System.out.println(e);
			//target.put(AJAX_ALERT, "파일 삭제중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00076")); // 오류
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}

	
	/**
	 * 업로드된 파일을 삭제한다.
	 * @param cmmMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/fileDeleteNoMsg.do")
	public String fileDeleteNoMsg(Map cmmMap, ModelMap model) throws Exception {
		//Map target = commonService.select("CommonFile.commFile_select", cmmMap);
		Map target = commonService.select("CommonFile.cmmFile_select", cmmMap);	//new mode

		try {
			String realFile = FileUtil.FILE_UPLOAD_DIR + target.get("FILE_PATH") + File.separator + target.get("SYS_FILE_NAME");
			File existFile = new File(realFile);
			existFile.delete();

			//commonService.delete("CommonFile.commFile_delete", cmmMap);
			commonService.delete("CommonFile.cmmFile_delete", cmmMap);	//new mode

		}
		catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_ALERT, "파일 삭제중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00076")); // 오류
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
	/**
	 * 파일 다운로드 기능을 제공한다.
	 */
	@RequestMapping(value = "/fileDown.do")
	public String fileDown(HttpServletRequest request, Map cmmMap, HttpServletResponse response) throws Exception {
		String seq = request.getParameter("seq");
		String scrnType = request.getParameter("scrnType");
		Map setMap = new HashMap();
		setMap.put("seq", seq);
		String filename = "";
		String original = "";
		String downFile = "";
		String ORGFileDir = "";
		
		if("BRD".equals(scrnType)) {			
			filename = commonService.selectString("boardFile_SQL.getFileSysName", setMap);	//new mode
			original =  commonService.selectString("boardFile_SQL.getFileName", setMap);	//new mode
			downFile = GlobalVal.FILE_UPLOAD_BOARD_DIR + filename; 
			ORGFileDir = GlobalVal.FILE_UPLOAD_BOARD_DIR;
		}
		else if("excel".equals(scrnType)) {			
			filename = request.getParameter("filename");
			original =  request.getParameter("original");
			original = new String(original.getBytes("8859_1"), "UTF-8");
			downFile = FileUtil.FILE_EXPORT_DIR + filename;
			ORGFileDir = FileUtil.FILE_EXPORT_DIR;
		}
		else {
			filename = commonService.selectString("fileMgt_SQL.getFileSysName", setMap);	//new mode
			original =  commonService.selectString("fileMgt_SQL.getFileName", setMap);	//new mode
			downFile = FileUtil.FILE_UPLOAD_DIR + filename;
			ORGFileDir = FileUtil.FILE_UPLOAD_DIR;
		}

		//String enOriginal = new String(original.getBytes("8859_1"), "UTF-8");
		
		
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
		
		// file DRM 적용
		String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
		String useDownDRM = StringUtil.checkNull(GlobalVal.DRM_DOWN_USE);
		if(!"".equals(useDRM) && !"N".equals(useDownDRM)){
			//DRMUtil.setDRM(drmInfoMap);
			drmInfoMap.put("ORGFileDir", ORGFileDir);
			drmInfoMap.put("DRMFileDir", StringUtil.checkNull(DrmGlobalVal.DRM_DECODING_FILEPATH) + StringUtil.checkNull(cmmMap.get("sessionUserId"))+"//");
			drmInfoMap.put("Filename", original);
			drmInfoMap.put("funcType", "download"); 
		}
		request.setAttribute("downFile", downFile);
		request.setAttribute("orginFile", original); // 20140627 request.setAttribute("orginFile", enOriginal); 수정

		FileUtil.downFile(request, response);

		return null;
	}	
	@RequestMapping(value = "/dsFileDown.do")
	public String handleRequest(HttpServletRequest request, Map cmmMap, HttpServletResponse response) throws Exception {
		String seq = request.getParameter("seq");
		String scrnType = request.getParameter("scrnType");
		Map setMap = new HashMap();
		setMap.put("seq", seq);
		String filename = "";
		String original = "";
		String filePath = "";
		String returnValue = "";
		
		if("BRD".equals(scrnType)) {			
			filename = commonService.selectString("boardFile_SQL.getFileSysName", setMap);	//new mode
			original =  commonService.selectString("boardFile_SQL.getFileName", setMap);	//new mode
			filePath = GlobalVal.FILE_UPLOAD_BOARD_DIR;
		}
		else {
			filename = commonService.selectString("fileMgt_SQL.getFileSysName", setMap);	//new mode
			original =  commonService.selectString("fileMgt_SQL.getFileName", setMap);	//new mode
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
		
		// file DRM 적용
		String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
		String useDownDRM = StringUtil.checkNull(GlobalVal.DRM_DOWN_USE);
		if(!"".equals(useDRM) && !"N".equals(useDownDRM)){
			//DRMUtil.setDRM(drmInfoMap);
			drmInfoMap.put("ORGFileDir", filePath);
			drmInfoMap.put("DRMFileDir", StringUtil.checkNull(DrmGlobalVal.DRM_DECODING_FILEPATH) + StringUtil.checkNull(cmmMap.get("sessionUserId"))+"//");
			drmInfoMap.put("Filename", filename);
			drmInfoMap.put("funcType", "download");
			returnValue = DRMUtil.drmMgt(drmInfoMap); // 암호화 
		}

		if(!"".equals(returnValue)) {
			downFile = returnValue;
		}

		request.setAttribute("downFile", downFile);
		request.setAttribute("orginFile", enOriginal);

		FileUtil.downFile(request, response);

		return null;
	}
	/**
	 * 엑셀 다운로드 기능을 제공한다.
	 * title : 제목
	 * headers : 컬럼명(컬럼1|컬럼2|컬럼3|...)
	 * cols : 컬럼명(컬럼1|컬럼2|컬럼3|...)
	 * key : sqlKey
	 */
	@SuppressWarnings("deprecation")
	@RequestMapping(value = "/excelDown.do")
	public String excelDown(Map cmmMap, ModelMap model) throws Exception {
		try {
			String title = getString(cmmMap.get("title"));
			String[]headers = StringUtil.toArray(cmmMap.get("headers"));
			String[]cols = StringUtil.toArray(cmmMap.get("cols"));

			String caltype = (String)cmmMap.get("coltype");
			HashMap hmColTypes = new HashMap();
			if(caltype.length() ==0 || caltype.equals("undefined"))
			{
				for(int i=0; i<cols.length; i++)
				{
					hmColTypes.put(cols[i], "T_C");
				}
			}
			else
			{
				String[]coltypes = StringUtil.toArray(cmmMap.get("coltype"));
				for(int i=0; i<cols.length; i++)
				{
					hmColTypes.put(cols[i], coltypes[i]);
				}

			}

			String sqlKey = getString(cmmMap.get("key")+SQL_GRID_LIST);
			if( title.lastIndexOf("> ") > 0)
			{
				title = title.substring(title.lastIndexOf("> ")+2);
			}
			model.addAttribute("fileName", URLEncoder.encode(title));
			model.addAttribute("title", title);
			model.addAttribute("headers", headers);
			model.addAttribute("cols", cols);
			model.addAttribute("coltypes", hmColTypes);
			model.addAttribute("bodyList", commonService.selectList(sqlKey, cmmMap));
		}catch (Exception e) {
			System.out.println(e);
			throw e;
		}
		return FORWARD_EXCEL;
	}
	
	
	/**
	 * 엑셀 다운로드
	 * 서버에서 엑셀파일을 작성한다
	 */
	@SuppressWarnings("deprecation")
	@RequestMapping(value = "/excelFileDownload.do")
	public String excelFileDownload(Map cmmMap, ModelMap model,HttpServletResponse response) throws Exception {
		try {
			File file = makeExcelFile(cmmMap, response);
			pushFile(file, response);
		} catch (Exception e) {
			System.out.println(e.toString());
			throw e;
		}
		return null;
	}
	
	public static String getJSONFormatClean(String s) {
	    if (s == null) {
	        return null;
	    }
		String cleanedString = s.replaceAll("&lt;br\\s*/?&gt;", "\n").replaceAll("&amp;","&");
		return StringEscapeUtils.unescapeHtml4(cleanedString).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>|<!--(.*?)-->", "");
	}
	
	public File makeExcelFile(Map cmmMap, HttpServletResponse response) throws Exception {		 
        String[] headers = StringUtil.toArray(cmmMap.get("headers"));
        String[] ids = StringUtil.toArray(cmmMap.get("ids"));
        String[] aligns = StringUtil.toArray(cmmMap.get("aligns"));
        String[] widths = StringUtil.toArray(cmmMap.get("widths"));
        String[] hiddens = null;
        String[] types = null;
        String[] headers2 = null;
        String[] headers3 = null;
        String[] headersCols = null;
        String[] headers2Cols = null;
        String[] headers3Cols = null;
        String[] headersSheet2 = null;
        String[] idsSheet2 = null;
        
        if(!StringUtil.checkNull(cmmMap.get("hiddens")).equals("") && StringUtil.checkNull(cmmMap.get("hiddens")) != null) {
        	hiddens = StringUtil.toArray(cmmMap.get("hiddens"));
        }
        if(!StringUtil.checkNull(cmmMap.get("headers2")).replaceAll(",", "").equals("") && StringUtil.checkNull(cmmMap.get("headers2")) != null) {
        	headers2 =  StringUtil.toArray(cmmMap.get("headers2"));
        }
        
        if(!StringUtil.checkNull(cmmMap.get("headers3")).replaceAll(",", "").equals("") && StringUtil.checkNull(cmmMap.get("headers3")) != null) {
        	headers3 =  StringUtil.toArray(cmmMap.get("headers3"));
        }
        
        if(!StringUtil.checkNull(cmmMap.get("headersCols")).replaceAll(",", "").equals("") && StringUtil.checkNull(cmmMap.get("headersCols")) != null) {
        	headersCols =  StringUtil.toArray(cmmMap.get("headersCols"));
        }
        
        if(!StringUtil.checkNull(cmmMap.get("headers2Cols")).replaceAll(",", "").equals("") && StringUtil.checkNull(cmmMap.get("headers2Cols")) != null) {
        	headers2Cols =  StringUtil.toArray(cmmMap.get("headers2Cols"));
        }
        
        if(!StringUtil.checkNull(cmmMap.get("headers3Cols")).replaceAll(",", "").equals("") && StringUtil.checkNull(cmmMap.get("headers3Cols")) != null) {
        	headers3Cols =  StringUtil.toArray(cmmMap.get("headers3Cols"));
        }
        
        if(!StringUtil.checkNull(cmmMap.get("headersSheet2")).equals("") && StringUtil.checkNull(cmmMap.get("headersSheet2")) != null) {
        	headersSheet2 = StringUtil.toArray(cmmMap.get("headersSheet2"));
        	idsSheet2 = StringUtil.toArray(cmmMap.get("idsSheet2"));
        }
        
        if(!StringUtil.checkNull(cmmMap.get("types")).equals("") && StringUtil.checkNull(cmmMap.get("types")) != null) {
        	types = StringUtil.toArray(cmmMap.get("types"));
        }
	        
        String gridData = StringUtil.checkNull(cmmMap.get("gridExcelData"));
        String filepath = FileUtil.FILE_UPLOAD_DIR;        
        String time = DateUtil.getCurrentTime("yyyyMMddHHmmss");
        String filename ="";
        if(!StringUtil.checkNull(cmmMap.get("fileName")).equals("") && StringUtil.checkNull(cmmMap.get("fileName")) != null) {
        	filename = URLEncoder.encode((String) cmmMap.get("fileName")+".xlsx","UTF-8").replaceAll("\\+", "%20");
        } else{
        	filename = "data_list_"+ time +".xlsx";  
        } 
        String sessionDefFont = StringUtil.checkNull(cmmMap.get("sessionDefFont"));
        
        try {
			File file = new File( filepath+ "/" + filename );
			FileOutputStream fop = new FileOutputStream(file);
			
			SXSSFWorkbook workbook = new SXSSFWorkbook(); 
			workbook.setCompressTempFiles(true);
			SXSSFSheet sheet = null;
			SXSSFSheet sheet2 = null;
     		if(!StringUtil.checkNull(cmmMap.get("fileName")).equals("") && StringUtil.checkNull(cmmMap.get("fileName")) != null) {
     			if(!StringUtil.checkNull(cmmMap.get("sheet1")).equals("")) {
     				sheet = (SXSSFSheet) workbook.createSheet(StringUtil.checkNull(cmmMap.get("sheet1")));
     			}else {
     				sheet = (SXSSFSheet) workbook.createSheet(StringUtil.checkNull(cmmMap.get("fileName")));
     			}
            } else {
            	sheet = (SXSSFSheet) workbook.createSheet("data_list_"+time);
            }
     		
     		// 두 번째 시트 존재하면 생성
     		if(!StringUtil.checkNull(cmmMap.get("sheet2")).equals("")) {
     			sheet2 = (SXSSFSheet) workbook.createSheet(StringUtil.checkNull(cmmMap.get("sheet2"))); // 두 번째 시트 이름 설정 :ex: 2.MH실적집계_일자별
     		}

     		XSSFCellStyle style = (XSSFCellStyle) workbook.createCellStyle();
     		XSSFFont font = (XSSFFont) workbook.createFont();
 			font.setFontHeightInPoints((short)14);
 			font.setFontName(sessionDefFont);
 			font.setBold(true);
 			font.setItalic(false);
 			font.setColor(IndexedColors.GREY_80_PERCENT.index);
 			font.setUnderline(XSSFFont.U_SINGLE);
 			style.setFont(font);  
 			style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.index);
 			style.setFillPattern(CellStyle.SOLID_FOREGROUND);
 			style.setBorderTop(XSSFCellStyle.BORDER_THIN);                          
			style.setBorderLeft(XSSFCellStyle.BORDER_THIN);
			style.setBorderRight(XSSFCellStyle.BORDER_THIN);
			style.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			style.setAlignment(XSSFCellStyle.ALIGN_CENTER);
 			SXSSFRow row = (SXSSFRow) sheet.createRow(0);
 			SXSSFCell cell = (SXSSFCell) row.createCell(0);
 			cell.setCellStyle(style);
 			
 			int rnum=0;
            int rnum2=0;
            
 			// 두 번째 시트에 행 추가
 			SXSSFRow row2 = null;
 			SXSSFCell cell2 = null;
 			JSONArray jsonArraySheet2 = null;
 			if(!StringUtil.checkNull(cmmMap.get("sheet2")).equals("") ) {
	 			row2 = (SXSSFRow) sheet2.createRow(0);
	 			cell2 = (SXSSFCell) row2.createCell(0);
	 			cell2.setCellStyle(style);
	 			
	 			//header
				for(int i=0;i<headersSheet2.length;i++){
					cell2 = (SXSSFCell) row2.createCell(i);
					cell2.setCellStyle(style);
					cell2.setCellValue(getJSONFormatClean(headersSheet2[i]));
		        }
				rnum2++;
	 			
	 			row2 = (SXSSFRow) sheet2.createRow(rnum2);
	 			cell2 = (SXSSFCell) row2.createCell(0);
	 			
	 			// 두 번째 시트 데이터 조회 
				if(!StringUtil.checkNull(cmmMap.get("sqlCodeSheet2")).equals("")) {
					List gridDataSheet2 = commonService.selectList(StringUtil.checkNull(cmmMap.get("sqlCodeSheet2")),cmmMap);
					jsonArraySheet2 = new JSONArray(gridDataSheet2);
				} 
 			}
             
			row = (SXSSFRow) sheet.createRow(rnum);
			
			int headerLength = 0;
			
			if(!StringUtil.checkNull(cmmMap.get("headers3")).replaceAll(",", "").equals("")) {
				headerLength = Math.max(headers.length, headers3.length);
			} else if(!StringUtil.checkNull(cmmMap.get("headers2")).replaceAll(",", "").equals("")) {
				headerLength = Math.max(headers.length, headers2.length);
			} else {
				headerLength = headers.length;
			}

            //header
			for(int i=0;i<headers.length;i++){
				if(!StringUtil.checkNull(cmmMap.get("headersCols")).replaceAll(",", "") .equals("") && StringUtil.checkNull(cmmMap.get("headersCols")).replaceAll(",", "") != null) {
					if(!getJSONFormatClean(headersCols[i]).equals("")) {
						//sheet.addMergedRegion(new CellRangeAddress(0,0,i,i+Integer.parseInt(getJSONFormatClean(headersCols[i]))-1 ));
					}
				}
				 
	        	cell = (SXSSFCell) row.createCell(i);
            	cell.setCellStyle(style);
            	cell.setCellValue(getJSONFormatClean(headers[i]));
	        }
			rnum++;
			
			//header2
			if(!StringUtil.checkNull(cmmMap.get("headers2")).replaceAll(",", "").equals("")) {
				row = (SXSSFRow) sheet.createRow(rnum);
				for(int i2=0;i2<headerLength;i2++){	  
					
					/*
					 * if(!StringUtil.checkNull(cmmMap.get("headers2Cols")).replaceAll(",", "")
					 * .equals("") &&
					 * StringUtil.checkNull(cmmMap.get("headers2Cols")).replaceAll(",", "") != null)
					 * { if(!getJSONFormatClean(headers2Cols[i2]).equals("")) {
					 * //sheet.addMergedRegion(new
					 * CellRangeAddress(0,0,i2,i2+Integer.parseInt(getJSONFormatClean(headers2Cols[
					 * i2]))-1 )); } }
					 */
					
		        	cell = (SXSSFCell) row.createCell(i2);
	            	cell.setCellStyle(style);
	            	cell.setCellValue(getJSONFormatClean(headers2[i2]));
		        }
				rnum++;
	        }
			
			//header3
			if(!StringUtil.checkNull(cmmMap.get("headers3")).replaceAll(",", "").equals("")) {
				row = (SXSSFRow) sheet.createRow(rnum);
				for(int i3=0;i3<headerLength;i3++){	  
					
					/*
					 * if(!StringUtil.checkNull(cmmMap.get("headers3Cols")).replaceAll(",", "")
					 * .equals("") &&
					 * StringUtil.checkNull(cmmMap.get("headers3Cols")).replaceAll(",", "") != null)
					 * { if(!getJSONFormatClean(headers3Cols[i3]).equals("")) {
					 * //sheet.addMergedRegion(new
					 * CellRangeAddress(0,0,i2,i2+Integer.parseInt(getJSONFormatClean(headers3Cols[
					 * i2]))-1 )); } }
					 */
					
		        	cell = (SXSSFCell) row.createCell(i3);
	            	cell.setCellStyle(style);
	            	cell.setCellValue(getJSONFormatClean(headers3[i3]));
		        }
				rnum++;
	        }
			
			// content
			JSONArray jsonArray = new JSONArray(gridData);
			if(!StringUtil.checkNull(cmmMap.get("sqlCode")).equals("")) {
				cmmMap.put("languageID", cmmMap.get("sessionCurrLangType"));
				List getGridDataList = commonService.selectList(StringUtil.checkNull(cmmMap.get("sqlCode")),cmmMap);
				jsonArray = new JSONArray(getGridDataList);
			} 
			
			style = (XSSFCellStyle) workbook.createCellStyle();
 			font.setFontHeightInPoints((short)11);
 			font.setFontName(sessionDefFont);
 			font.setBold(false);
 			font.setItalic(false);
 			font.setColor(IndexedColors.GREY_80_PERCENT.index);
 			font.setUnderline(XSSFFont.U_NONE);
 			style.setFont(font);  
 			style.setFillForegroundColor(IndexedColors.WHITE.index);
			style.setFillPattern(CellStyle.SOLID_FOREGROUND);
			style.setBorderTop(XSSFCellStyle.BORDER_THIN);                          
			style.setBorderLeft(XSSFCellStyle.BORDER_THIN);
			style.setBorderRight(XSSFCellStyle.BORDER_THIN);
			style.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			style.setAlignment(XSSFCellStyle.ALIGN_LEFT);
			
			for (int idx = 0; idx < jsonArray.length(); idx++) {
				JSONObject jsonData = (JSONObject) jsonArray.get(idx);	
				row = (SXSSFRow) sheet.createRow(rnum);
				
				for(int i=0; i<headerLength; i++){
					
					cell = (SXSSFCell) row.createCell(i);
					String columWidths = StringUtil.checkNull(widths[i]);
	            	if (columWidths.contains(".")) {
	            	    columWidths = columWidths.split("\\.")[0]; // 앞부분만 사용
	            	}
			
		            if("center".equals(aligns[i])) style.setAlignment(XSSFCellStyle.ALIGN_CENTER); 
            		else if("right".equals(aligns[i])) style.setAlignment(XSSFCellStyle.ALIGN_RIGHT); 
            		else if("left".equals(aligns[i])) style.setAlignment(XSSFCellStyle.ALIGN_LEFT); 
		            if(StringUtil.checkNull(columWidths).equals("")) {
		            	sheet.setColumnWidth(i, 300*40);
		            }else {
		            	sheet.setColumnWidth(i, Integer.parseInt(columWidths)*40);
		            }
		            
		            if(!StringUtil.checkNull(cmmMap.get("hiddens")).equals("") && StringUtil.checkNull(cmmMap.get("hiddens")) != null) {
			            if(StringUtil.checkNull(hiddens[i]).equals("true")) {
			            	sheet.setColumnHidden(i, true);
			            }else {
			            	sheet.setColumnWidth(i, Integer.parseInt(columWidths)*40);
			            }
		            }else {
		            	sheet.setColumnWidth(i, Integer.parseInt(columWidths)*40);
		            }
		            
		            String data = "";
		            int numberData = 0;
		            
		            if(jsonData.has(ids[i])) {
		            	data = getJSONFormatClean(StringUtil.checkNull(jsonData.get(ids[i])));
		            }
					
            		cell.setCellStyle(style);
            		
            		if(types != null && "number".equals(types[i])) {
	            		if(!"".equals(data) && data.matches("\\d+")) numberData = Integer.parseInt(data);
	            		cell.setCellValue(numberData);
		            } else {
		            	cell.setCellValue(data);
		            }
            		
				}
				rnum++;
			}
			
			if(!StringUtil.checkNull(cmmMap.get("sheet2")).equals("")) { // 두번째 시트 생성 있을시 
				// 두번째 시트 
				for (int idx = 0; idx < jsonArraySheet2.length(); idx++) {
					JSONObject jsonData2 = (JSONObject) jsonArraySheet2.get(idx);	
					row2 = (SXSSFRow) sheet2.createRow(rnum2);
					
					for(int i=0; i<idsSheet2.length; i++){
						
						cell2 = (SXSSFCell) row2.createCell(i);
				
			            style.setAlignment(XSSFCellStyle.ALIGN_CENTER);             		
			            sheet2.setColumnWidth(i, 300*40);
			            
			            String data = "";
			            int numberData = 0;
			            
			            if(jsonData2.has(idsSheet2[i])) {
			            	data = getJSONFormatClean(StringUtil.checkNull(jsonData2.get(idsSheet2[i])));
			            }
						
	            		cell2.setCellStyle(style);
	            		
	            		if(types != null && "number".equals(types[i])) {
		            		if(!"".equals(data) && data.matches("\\d+")) numberData = Integer.parseInt(data);
		            		cell.setCellValue(numberData);
			            } else {
			            	cell.setCellValue(data);
			            }
	            		
					}
					rnum2++;
				}
			}
			
		    workbook.write(fop); 
            fop.flush();
            fop.close();
            
	        return file;
        } catch ( Exception e ){
        	System.out.println(e.toString());
        	throw e;
        }
	}
	
	/**
	 * excel file을 조립한다
	 * @param cmmMap
	 * @param model
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public File makeExcelFile_ORG(Map cmmMap, ModelMap model, HttpServletResponse response) throws Exception {
        String title = getString(cmmMap.get("title"));
        String[]headers = StringUtil.toArray(cmmMap.get("headers"));
        String[]cols = StringUtil.toArray(cmmMap.get("cols"));
        String[] widths= StringUtil.toArray(cmmMap.get("widths"));
        String[] aligns = StringUtil.toArray(cmmMap.get("aligns"));
        String sqlKey = getString(cmmMap.get("key"));
        
        String filepath = XboltController.getWebappRoot();
        String filename = title+".xlsx";
        String time = DateUtil.getCurrentTime("yyyyMMddHHmmss");
        filename = time+".xlsx";
        try {
			File file = new File( filepath+ "/" + filename );
			FileOutputStream fop = new FileOutputStream(file);
			
			List list = commonService.selectList(sqlKey,cmmMap); 
			//title
    		
    		XSSFWorkbook workbook = new XSSFWorkbook();
     		XSSFSheet sheet = workbook.createSheet(title);

     		XSSFCellStyle style = workbook.createCellStyle();
     		XSSFFont font = workbook.createFont();
 			font.setFontHeightInPoints((short)14);
 			font.setFontName("ARIAL");
 			font.setBold(true);
 			font.setItalic(false);
 			font.setColor(IndexedColors.GREY_80_PERCENT.index);
 			font.setUnderline(XSSFFont.U_SINGLE);
 			style.setFont(font);  
 			XSSFRow row = sheet.createRow(0);
 			XSSFCell cell = row.createCell(0);
 			cell.setCellStyle(style);
             
            style = workbook.createCellStyle();
 			font.setFontHeightInPoints((short)12);
 			font.setFontName("COURIER");
 			font.setBold(true);
 			font.setItalic(false);
 			font.setColor(IndexedColors.GREY_80_PERCENT.index);
 			font.setUnderline(XSSFFont.U_NONE);
 			style.setFont(font);  
 			style.setFillForegroundColor(IndexedColors.GREY_50_PERCENT.index);
			style.setFillPattern(CellStyle.SOLID_FOREGROUND);
			style.setBorderTop(XSSFCellStyle.BORDER_THIN);                          
			style.setBorderLeft(XSSFCellStyle.BORDER_THIN);
			style.setBorderRight(XSSFCellStyle.BORDER_THIN);
			style.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			style.setAlignment(XSSFCellStyle.ALIGN_CENTER);
            int rnum=3;

			row = sheet.createRow(rnum);
            //header

            for(int i=0;i<headers.length;i++){
            	cell = row.createCell(i);
            	cell.setCellStyle(style);
            	cell.setCellValue(headers[i]);
        	}
            
            //content
            rnum++;
            for(Object o:list){
            	HashMap rowMap = (HashMap)o;
    			row = sheet.createRow(rnum);
            	for(int i=0;i<cols.length;i++){

                	cell = row.createCell(i);
            		style = workbook.createCellStyle();
         			font.setFontHeightInPoints((short)11);
         			font.setFontName("TAHOMA");
         			font.setBold(false);
         			font.setItalic(false);
         			font.setColor(IndexedColors.GREY_80_PERCENT.index);
         			font.setUnderline(XSSFFont.U_NONE);
         			style.setFont(font);  
         			style.setFillForegroundColor(IndexedColors.GREY_50_PERCENT.index);
        			style.setFillPattern(CellStyle.SOLID_FOREGROUND);
        			style.setAlignment(XSSFCellStyle.ALIGN_CENTER);
        			
		            if("center".equals(aligns[i])) style.setAlignment(XSSFCellStyle.ALIGN_CENTER); 
            		else if("right".equals(aligns[i])) style.setAlignment(XSSFCellStyle.ALIGN_RIGHT); 
            		else if("left".equals(aligns[i])) style.setAlignment(XSSFCellStyle.ALIGN_LEFT); 
            		sheet.setColumnWidth(i, Integer.parseInt(widths[i])*30);

					String data = (rowMap.get(cols[i])!=null)?rowMap.get(cols[i]).toString():null;
            		cell.setCellStyle(style);
            		cell.setCellValue(data);
            	}
            	rnum++;
            }

            workbook.write(fop); 
            fop.flush();
            fop.close();
            //workbook.close();
	        return file;
        } catch ( Exception e ){
        	System.out.println(e.toString());
        	throw e;
        }
	}
	
	/**
	 * excel file을 내보낸다
	 * @param file
	 * @param response
	 * @throws Exception
	 */
	public void pushFile(File file, HttpServletResponse response) throws Exception {
		FileInputStream fin = null;
		try {
            fin = new FileInputStream(file);
            int ifilesize = (int)file.length();
            String filename = file.getName();
            byte b[] = new byte[ifilesize];

            response.setContentLength(ifilesize);
            response.setContentType("application/vnd.ms-excel");
            response.setHeader( "Content-Disposition", "attachment; filename=" + filename+";" );
            ServletOutputStream oout = response.getOutputStream();
           
            while (fin.read(b) > 0) {
	            oout.write(b,0,ifilesize);
            }
	        oout.close();
            fin.close();
            file.delete();
        } catch ( Exception e ) {
        	System.out.println(e.toString());
        	throw e;
        } finally {
        	if(fin != null) {
        		try {
        			fin.close();
        		} catch ( Exception e ) {
                	System.out.println(e.toString());
                	throw e;
                }
        	}
        }
	}	
	
	@RequestMapping(value="/uploadImgFileScrn.do")
	public String uploadImgFileScrn(HashMap cmmMap,ModelMap model) throws Exception {
		return nextUrl("/cmm/imgFileUpload");	
	}
	
	@RequestMapping(value="/uploadImgFile.do")
	public String uploadImgFile(MultipartHttpServletRequest request, HashMap cmmMap,ModelMap model) throws Exception {
		Map target = new HashMap();
		XSSRequestWrapper xss = new XSSRequestWrapper(request);
		
		//Map map = new HashMap();
		try {
			/*Map<String,String[]> params = request.getParameterMap();

			for(String[] values : params.values()){
			  
			}*/
			
			Iterator fileNameIter = request.getFileNames();
			String savePath = GlobalVal.FILE_UPLOAD_TINY_DIR;
			String fileName = "";
		    while (fileNameIter.hasNext()) {
			   MultipartFile mFile = request.getFile((String)fileNameIter.next());
			   fileName = mFile.getOriginalFilename();
			   if (mFile.getSize() > 0) {	
				   String ext = FileUtil.getExt(fileName);
				   
				   if(!FileUtil.isPicture(ext)) {
					   target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00074")); // 성공
					   target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
					   model.addAttribute(AJAX_RESULTMAP, target);
						
					   return nextUrl(AJAXPAGE);	
				   }
				   HashMap resultMap = FileUtil.uploadFile(mFile, savePath, true);
				   fileName = resultMap.get(FileUtil.UPLOAD_FILE_NM)+"^";
			   }
			}				
			//target.put(AJAX_ALERT, "파일 업로드에 성공하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00071")); // 성공
			target.put(AJAX_SCRIPT, "parent.doReturn('"+fileName+"','');parent.$('#isSubmit').remove();");
		}
		catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			//target.put(AJAX_ALERT, "파일 업로드 중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00074")); // 오류
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		
		return nextUrl(AJAXPAGE);	
	}
	
	/**
	 * 업로드된 파일을 삭제한다.
	 * @param cmmMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/removeFile.do")
	public String removeFile(Map cmmMap, ModelMap model) throws Exception {
		Map target = new HashMap();

		try {
			String uploadDir = GlobalVal.FILE_UPLOAD_BASE_DIR;
			String userID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			String fileName = StringUtil.checkNull(cmmMap.get("fileName")); 
			String removeAll = StringUtil.checkNull(cmmMap.get("removeAll")); 
		   
			String realFile = uploadDir+ userID +"//" + fileName.trim();
			if(removeAll.equals("Y")) {
				realFile =  uploadDir+ userID;
			}
			
			File existFile = new File(realFile);
			
			// 새로운 코드 추가 부분 ======= 
			
			String isInit = StringUtil.checkNull(cmmMap.get("isInit")); 
			
			if(removeAll.equals("Y") && isInit.equals("Y")) {
			    // 초기화 단계에선 폴더가 폴더가 없더라도 오류처리하지 않고 정상 처리해 종료하도록 함
			    if (!existFile.exists() || !existFile.isDirectory()) {
					return nextUrl(AJAXPAGE);
			    }
			}
			// 새로운 코드 추가 종료 =======
			
			if(removeAll.equals("Y")) {
				 File[] fileList = existFile.listFiles();				 
				 for(int i=0; i<fileList .length; i++){
			            fileList[i].delete() ;
			      }
			}else {
					existFile.delete();
			}
		}
		catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00076")); // 오류
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/removeFileList.do")
	public String removeFileList(Map cmmMap, ModelMap model) throws Exception {
		Map target = new HashMap();

		try {
			String uploadDir = GlobalVal.FILE_UPLOAD_BASE_DIR;
			String userID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			String fileNameList[] = StringUtil.checkNull(cmmMap.get("fileNameList")).split(","); 
		   
			String fileName = "";
			String realFile ="";
			for(int idx=0; idx<fileNameList.length; idx++) {
				fileName = StringUtil.checkNull(fileNameList[idx]);
				
				realFile = uploadDir+ userID +"//" + fileName;
				File existFile = new File(realFile);		 
				existFile.delete() ;
			}
			target.put(AJAX_SCRIPT, "fnClose();");
		}
		catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00076")); // 오류
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping("/custom/inboundLinkFileDown.do")
	public String inboundLinkFileDown(HttpServletRequest request, HttpServletResponse response, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/template/olmLinkPopup";
		Map target = new HashMap();
		try {
			Map setData =  new HashMap();
			setData.put("Seq", StringUtil.checkNull(request.getParameter("linkID"), ""));
			Map fileMap = commonService.select("fileMgt_SQL.selectDownFile",setData);
			String original = StringUtil.checkNull(fileMap.get("original"));
			String downFile = StringUtil.checkNull(fileMap.get("downFile"));
			
			if (!new File(downFile).exists()) {					 
				 target.put(AJAX_ALERT, MessageHandler.getMessage("KO.WM00078", new String[]{original}));						
				 model.addAttribute(AJAX_RESULTMAP, target);
				 return nextUrl(AJAXPAGE);
			}
			
			request.setAttribute("downFile", downFile);
			request.setAttribute("orginFile", original);
				
			FileUtil.flMgtdownFile(request, response);
		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/getFLTPCodeByClassCode.do", method = RequestMethod.GET)
	@ResponseBody
	public void getFLTPCodeByClassCode (HttpServletRequest req, HttpServletResponse res, ModelMap model) throws Exception {
		JSONObject jsonObject = new JSONObject();
		Map setMap = new HashMap();

		res.setHeader("Cache-Control", "no-cache");
		res.setContentType("text/plain");
		res.setCharacterEncoding("UTF-8");

		try {
			String classCode = StringUtil.checkNull(req.getParameter("classCode"), "");
			setMap.put("classCode", classCode);
			String fltpCode = commonService.selectString("fileMgt_SQL.getFltpCodeAllocByClassCode", setMap);
			res.getWriter().print(fltpCode == null ? "" : fltpCode);
		} catch (Exception e) {
			System.out.println(e.toString());
			res.getWriter().print("");
		}
	}

}
