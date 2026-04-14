<%@page import="java.util.ArrayList"%>
<%@page contentType="application/msword; charset=utf-8"%>
<%@page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<%@page import="java.io.*" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.HashMap" %>
<%@page import="java.util.List" %>
<%@page import="java.net.URLEncoder" %>
<%@page import="xbolt.cmm.framework.util.StringUtil" %>
<%@page import="xbolt.cmm.framework.val.GlobalVal" %>
<%@page import="xbolt.cmm.framework.util.DRMUtil" %>
<%@page import="xbolt.cmm.framework.util.FileUtil" %>

<%@page import="com.aspose.words.*" %>
<%@page import="java.awt.Color" %>
<%@page import="java.text.SimpleDateFormat" %>

<%

// 1 inch equals 25.4 millimeters. 1 inch equals 72 points.

String fileName = "";
String drmFileName = "";
String downFileName = "";
try{

	String LogoImgUrl = "";
	String modelImgPath = GlobalVal.MODELING_DIGM_DIR;
	String logoPath = GlobalVal.FILE_UPLOAD_TINY_DIR;
	String defaultFont = String.valueOf(request.getAttribute("defaultFont"));
	
	License license = new License();
	license.setLicense(logoPath + "Aspose.Words.lic");
	
	Document doc = new Document();
	DocumentBuilder builder = new DocumentBuilder(doc);
	
	Map menu = (Map)request.getAttribute("menu");
	List items = (List)request.getAttribute("items");
	Map itemsMap = (Map)request.getAttribute("itemsMap");
	
	Map attrRsNameMap = (Map)request.getAttribute("attrRsNameMap");
	Map attrRsHtmlMap = (Map)request.getAttribute("attrRsHtmlMap");
	
	String selectedItemName = String.valueOf(request.getAttribute("selectedItemName"));
	
	String paperSize = String.valueOf(request.getAttribute("paperSize"));
	String outputType = String.valueOf(request.getAttribute("outputType"));
	String itemName = "";
	
	double titleCellWidth = 60.0;
	double contentCellWidth3 = 90.0;
	double contentCellWidth = 165.0;
	double mergeCellWidth = 390.0;
	double totalCellWidth = 560.0;
	
	String fontFamilyHtml = "<span style=\"font-family:"+defaultFont+"; font-size: 10pt;\">";
	//==================================================================================================
	Section currentSection = builder.getCurrentSection();
	    PageSetup pageSetup = currentSection.getPageSetup();
	    
	    // page 여백 설정
	builder.getPageSetup().setRightMargin(ConvertUtil.millimeterToPoint(20.0));
	builder.getPageSetup().setLeftMargin(ConvertUtil.millimeterToPoint(20.0));
	builder.getPageSetup().setBottomMargin(ConvertUtil.millimeterToPoint(20.0));
	builder.getPageSetup().setTopMargin(ConvertUtil.millimeterToPoint(20.0));
	
	//builder.getPageSetup().setOrientation(Orientation.LANDSCAPE);
	// PaperSize 설정
	builder.getPageSetup().setPaperSize(PaperSize.A4);
	
	//==================================================================================================
	SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
	long date = System.currentTimeMillis();
	
	//=========================================================================
	// TODO : FOOTER
	currentSection = builder.getCurrentSection();
	    pageSetup = currentSection.getPageSetup();
	        
	String imageFileName = logoPath + "logo_HEC.png";
	        
	    builder.moveToDocumentEnd();
	//=========================================================================
	builder = new DocumentBuilder(doc);
	//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	for(int i=0; i < items.size(); i++) {
		Object itemID = items.get(i);
		List list = (List) itemsMap.get(itemID);
		Map itemInfo = (Map)list.get(0);
		
		Map prcListMap = (Map) itemInfo.get("prcList");
		List cngtList = (List) itemInfo.get("cngtList");
		
		List relItemList = (List) itemInfo.get("relItemList");
		List fileList = (List) itemInfo.get("fileList");
		itemName = StringUtil.checkNullToBlank(prcListMap.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
		itemName = itemName.replace(" ", " ").replace(" ", " ").replace("&", "&");
		
		//==================================================================================================
		/* 표지 */
		currentSection = builder.getCurrentSection();
		pageSetup = currentSection.getPageSetup();
		pageSetup.setDifferentFirstPageHeaderFooter(true);
		builder.moveToHeaderFooter(HeaderFooterType.HEADER_FIRST);
	
	    // NEW 머릿글 : START
	    builder.startTable();
		builder.getCellFormat().setWidth(ConvertUtil.millimeterToPoint(170.0));
		builder.getRowFormat().clearFormatting();
		builder.getCellFormat().clearFormatting();
		
		builder.getCellFormat().setLeftPadding(0.0);
		builder.getCellFormat().setRightPadding(0.0);
		
		// Make the header row.
		builder.insertCell();
		builder.getCellFormat().setWidth(ConvertUtil.millimeterToPoint(170.0));
		builder.getRowFormat().setHeight(70.0);
		
		// Some special features for the header row.
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setSize(22);
		builder.getFont().setUnderline(0);
		builder.getFont().setBold(true);
		builder.getFont().setColor(Color.BLACK);
		builder.getFont().setName(defaultFont);
		
		
		//builder.write("SOP (표준업무절차)");  
		//builder.write("SOP (Standard Operating Procedure)");  
		builder.write(StringUtil.checkNullToBlank(menu.get("ZLN022")));  
		builder.endRow();
	
	    builder.endTable().setAllowAutoFit(false);
		//   // 머릿말 : END
	    builder.moveToDocumentEnd();
		//    //==================================================================================================
	  
		// 머릿말 : START
		currentSection = builder.getCurrentSection();
	    pageSetup = currentSection.getPageSetup();
	    pageSetup.setHeaderDistance(57);
	    builder.moveToHeaderFooter(HeaderFooterType.HEADER_PRIMARY);
		    
		Table table = builder.startTable();
		
		builder.getRowFormat().clearFormatting();
		builder.getCellFormat().clearFormatting();
		
		builder.getCellFormat().setLeftPadding(0.0);
		builder.getCellFormat().setRightPadding(0.0);
		
		builder.getRowFormat().setHeight(ConvertUtil.millimeterToPoint(24.0));
		builder.getCellFormat().setWidth(ConvertUtil.millimeterToPoint(170.0));
		builder.insertCell();
		
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getFont().setName(defaultFont);
	    builder.getFont().setBold(true);
	    builder.getFont().setColor(Color.black);
	    builder.getFont().setSize(11);
	    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	    builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	    builder.getCellFormat().setWidth(ConvertUtil.millimeterToPoint(40.0));
	    builder.insertImage(imageFileName,100,18);//현대 로고
	
	    builder.insertCell();
	    builder.getCellFormat().setWidth(ConvertUtil.millimeterToPoint(70.0));
	    builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	    builder.getFont().setSize(14);
	    builder.getFont().setSpacing(-0.5);

		builder.getParagraphFormat().setLineSpacingRule(LineSpacingRule.EXACTLY);
		builder.getParagraphFormat().setLineSpacing(15.0);
		builder.write(itemName);
		
		builder.insertCell();
	    builder.getFont().setSize(11);
	    builder.getFont().setSpacing(-1.0);
	    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	    builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	    builder.getCellFormat().getBorders().getRight().setLineWidth(0.0);
	    builder.getCellFormat().setWidth(ConvertUtil.millimeterToPoint(20.0));
	    
		builder.getParagraphFormat().setLineSpacingRule(LineSpacingRule.EXACTLY);
		builder.getParagraphFormat().setLineSpacing(20.0);
		
		//builder.writeln("문서번호 : ");
		//builder.writeln("개정번호 : ");
		//builder.write("개정일자 : ");
		//builder.writeln("Doc. No. : ");
		//builder.writeln("Rev. No. : ");
		//builder.write("Rev. Date : ");
		builder.writeln(StringUtil.checkNullToBlank(menu.get("ZLN028")));  
		builder.writeln(StringUtil.checkNullToBlank(menu.get("ZLN023")));  
		builder.write(StringUtil.checkNullToBlank(menu.get("ZLN024")));  
	
		builder.insertCell();
		builder.getCellFormat().clearFormatting();
	    builder.getFont().setSize(11);
	    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	    builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	    builder.getCellFormat().getBorders().getTop().setLineWidth(1.0);
	    builder.getCellFormat().getBorders().getLeft().setLineWidth(0.0);
	    builder.getCellFormat().getBorders().getRight().setLineWidth(1.0);
	    builder.getCellFormat().getBorders().getBottom().setLineWidth(1.0);
	    builder.getCellFormat().setWidth(ConvertUtil.millimeterToPoint(40.0));
	    
		builder.getCellFormat().setLeftPadding(0.0);
		builder.getCellFormat().setRightPadding(0.0);

		builder.getParagraphFormat().setLineSpacingRule(LineSpacingRule.EXACTLY);
		builder.getParagraphFormat().setLineSpacing(20.0);
	
	    builder.getFont().setSpacing(-0.3);
		builder.writeln(StringUtil.checkNullToBlank(prcListMap.get("Identifier")));
		builder.writeln(StringUtil.checkNullToBlank(prcListMap.get("Version")));
		builder.write(StringUtil.checkNullToBlank(prcListMap.get("ValidFrom")));
		
	    builder.endRow();
	
	    builder.endTable().setAllowAutoFit(false);
	    
		// // 머릿말 : END
		builder.moveToDocumentEnd();
		  //==================================================================================================
		     
		// 표지 하단
		builder.startTable();
		builder.getCellFormat().getBorders().setLineWidth(0.0);
		
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getCellFormat().setWidth(ConvertUtil.millimeterToPoint(170.0));
		
		builder.getRowFormat().clearFormatting();
		builder.getCellFormat().clearFormatting();
		builder.getParagraphFormat().clearFormatting();
	
		builder.getCellFormat().setLeftPadding(0.0);
		builder.getCellFormat().setRightPadding(0.0);
		
		builder.insertCell();
		builder.getFont().setColor(Color.BLACK);
		builder.getFont().setBold(true);
		builder.getFont().setName(defaultFont);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		builder.getFont().setSize(16);
		builder.getFont().setUnderline(0);
		builder.insertHtml("<br>");
		builder.insertHtml("<br>");
		builder.insertHtml("<br>");
		builder.writeln(itemName);
		builder.getFont().setSize(12);
		builder.getFont().setBold(false);
		builder.insertHtml("<br>");
		builder.insertHtml("<br>");
		builder.insertHtml("<br>");
		builder.insertHtml("<br>");
		builder.insertHtml("<br>");
		builder.writeln(StringUtil.checkNullToBlank(prcListMap.get("Identifier")));
		builder.insertHtml("<br>");
		builder.insertHtml("<br>");
		builder.insertHtml("<br>");
		builder.insertHtml("<br>");
		builder.insertHtml("<br>");
		builder.insertHtml("<br>");
		builder.insertHtml("<br>");
		builder.insertHtml("<br>");
		builder.insertHtml("<br>");
		builder.insertHtml("<br>");
		builder.insertHtml("<br>");
		builder.insertHtml("<br>");
		builder.endRow();
		
		// Make the header row.
		builder.insertCell();
		builder.getRowFormat().setHeight(ConvertUtil.millimeterToPoint(15.0));
		
		// Some special features for the header row.
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getCellFormat().setWidth(ConvertUtil.millimeterToPoint(12.0));
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		builder.getParagraphFormat().setLineSpacingRule(LineSpacingRule.EXACTLY);
		builder.getParagraphFormat().setLineSpacing(12.0);
		builder.getFont().setSize(11);
		builder.getFont().setUnderline(0);
		builder.getFont().setBold(false);
		builder.getFont().setColor(Color.BLACK);
		builder.getFont().setName(defaultFont);
		
		builder.getCellFormat().setWidth(ConvertUtil.millimeterToPoint(42.5));
		//builder.write("개정번호"); //개정번호
		//builder.write("Rev. No."); //개정번호
		builder.write(StringUtil.checkNullToBlank(menu.get("ZLN023")));  
		
		builder.insertCell();
		builder.getCellFormat().setWidth(ConvertUtil.millimeterToPoint(42.5));
		builder.write(StringUtil.checkNullToBlank(prcListMap.get("Version")));
		
		builder.insertCell();
		builder.getCellFormat().setWidth(ConvertUtil.millimeterToPoint(42.5));
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		//builder.write("작성부서");
		//builder.write("Prepared Dept.");
		builder.write(StringUtil.checkNullToBlank(menu.get("ZLN025")));  
		builder.insertCell();
		builder.getCellFormat().setWidth(ConvertUtil.millimeterToPoint(42.5));
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		builder.write(StringUtil.checkNullToBlank(prcListMap.get("CurOwnerTeamName")));
		
		builder.endRow();
		
		builder.insertCell();
		builder.getCellFormat().setWidth(ConvertUtil.millimeterToPoint(42.5));
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		//builder.write("개정일자"); //개정일자
		//builder.write("Rev. Date"); //개정일자
		builder.write(StringUtil.checkNullToBlank(menu.get("ZLN024")));  
		
		builder.insertCell();
		builder.getCellFormat().setWidth(ConvertUtil.millimeterToPoint(42.5));
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		builder.write(StringUtil.checkNullToBlank(prcListMap.get("ValidFrom")));
		
		builder.insertCell();
		builder.getCellFormat().setWidth(ConvertUtil.millimeterToPoint(42.5));
		//builder.write("작  성  자"); //작 성
		//builder.write("Prepared by"); //작 성
		builder.write(StringUtil.checkNullToBlank(menu.get("ZLN026")));  
		
		builder.insertCell();
		builder.getCellFormat().setWidth(ConvertUtil.millimeterToPoint(42.5));
		builder.write(StringUtil.checkNullToBlank(prcListMap.get("AuthorName")));
		builder.endRow();
		
		builder.insertCell();
		builder.getParagraphFormat().clearFormatting();
		builder.getCellFormat().setWidth(ConvertUtil.millimeterToPoint(170.0));
		builder.getRowFormat().setHeight(ConvertUtil.millimeterToPoint(16.0));
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		builder.insertImage(imageFileName, 160, 30);//현대 로고
		builder.endRow();
		
		builder.endTable().setAllowAutoFit(false);
		///////////////////////////////////////////////////////////////////////////////////////
		// 표지 END
		//==================================================================================================
		builder.insertBreak(BreakType.PAGE_BREAK);
		
		//==================================================================================================
		
		// 개정내역 START
		builder.getFont().setSize(14);
		builder.getFont().setBold(true);  
		builder.getFont().setName(defaultFont);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		//builder.write("개 정 관 리 표");
		//builder.write("Revision History");
		builder.write(StringUtil.checkNullToBlank(menu.get("ZLN029")));  
		builder.getParagraphFormat().setLineSpacing(18.0);
		
		builder.startTable();
		
		// Make the header row.
		builder.insertCell();
		builder.getCellFormat().setWidth(ConvertUtil.millimeterToPoint(170.0));
		builder.getRowFormat().setHeight(ConvertUtil.millimeterToPoint(15.0));
		
		builder.getRowFormat().clearFormatting();
		builder.getCellFormat().clearFormatting();
		builder.getParagraphFormat().clearFormatting();
		
		builder.getCellFormat().setLeftPadding(0.0);
		builder.getCellFormat().setRightPadding(0.0);
		
		// Some special features for the header row.
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setSize(11);
		builder.getFont().setUnderline(0);
		builder.getFont().setBold(false);
		builder.getFont().setColor(Color.BLACK);
		builder.getFont().setName(defaultFont);
		
		builder.getCellFormat().setWidth(ConvertUtil.millimeterToPoint(12.0));
		builder.getParagraphFormat().setLineSpacingRule(LineSpacingRule.EXACTLY);
		builder.getParagraphFormat().setLineSpacing(12.0);
		//builder.writeln("개정"); //개정번호
		//builder.write("번호");
		//builder.writeln("Rev."); //개정번호
		//builder.write("No.");
		builder.write(StringUtil.checkNullToBlank(menu.get("ZLN023")));  
		
		builder.insertCell();
		builder.getCellFormat().setWidth(ConvertUtil.millimeterToPoint(28.0));
		//builder.write("개정일자");
		//builder.write("Rev. Date");
		builder.write(StringUtil.checkNullToBlank(menu.get("ZLN024")));  
		
		builder.insertCell();
		builder.getCellFormat().setWidth(ConvertUtil.millimeterToPoint(100.0));
		//builder.write("개 정 내 용"); //작 성
		//builder.write("Contents"); //작 성
		builder.write(StringUtil.checkNullToBlank(menu.get("ZLN027")));  
		
		builder.insertCell();
		builder.getCellFormat().setWidth(ConvertUtil.millimeterToPoint(30.0));
		//builder.write("작 성 자");
		//builder.write("Prepared by");
		builder.write(StringUtil.checkNullToBlank(menu.get("ZLN026")));  
		builder.endRow();
	
		builder.getRowFormat().setHeight(ConvertUtil.millimeterToPoint(10.0));
		for(int x=0; x < cngtList.size(); x++){
			Map cngtInfo = (HashMap) cngtList.get(x);
			
			builder.insertCell();
			builder.getCellFormat().setWidth(ConvertUtil.millimeterToPoint(12.0));
			builder.getCellFormat().setLeftPadding(0.0);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(StringUtil.checkNullToBlank(cngtInfo.get("Version"))); //개정번호
			
			builder.insertCell();
			builder.getCellFormat().setWidth(ConvertUtil.millimeterToPoint(28.0));
			builder.getCellFormat().setLeftPadding(0.0);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(StringUtil.checkNullToBlank(cngtInfo.get("ValidFrom"))); //개정일자
			
			builder.insertCell();
			builder.getCellFormat().setWidth(ConvertUtil.millimeterToPoint(100.0));
			builder.getCellFormat().setLeftPadding(10.0);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			builder.write(StringUtil.checkNullToBlank(cngtInfo.get("Description"))); //개정내용
			
			builder.insertCell();
			builder.getCellFormat().setWidth(ConvertUtil.millimeterToPoint(30.0));
			builder.getCellFormat().setLeftPadding(0.0);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(StringUtil.checkNullToBlank(cngtInfo.get("AuthorName"))); //작성
			
			builder.endRow();
		}
		for(int z=0; z < 17 - cngtList.size(); z++){
		
			builder.insertCell();
			builder.getCellFormat().setWidth(ConvertUtil.millimeterToPoint(12.0));
			builder.getCellFormat().setLeftPadding(0.0);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(""); //개정번호
			
			builder.insertCell();
			builder.getCellFormat().setWidth(ConvertUtil.millimeterToPoint(28.0));
			builder.getCellFormat().setLeftPadding(0.0);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(""); //개정일자
			
			builder.insertCell();
			builder.getCellFormat().setWidth(ConvertUtil.millimeterToPoint(100.0));
			builder.getCellFormat().setLeftPadding(10.0);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			builder.write(""); //개정내용
			
			builder.insertCell();
			builder.getCellFormat().setWidth(ConvertUtil.millimeterToPoint(30.0));
			builder.getCellFormat().setLeftPadding(0.0);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(""); //작성
			builder.endRow();
		}
		builder.endTable().setAllowAutoFit(false);
		///////////////////////////////////////////////////////////////////////////////////////
		// 개정내역 END
		builder.insertBreak(BreakType.PAGE_BREAK);
		
		//==================================================================================================
		// 목차 START
		/*builder.getFont().setSize(14);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		builder.getParagraphFormat().setLineSpacing(18.0);
		builder.writeln("목 차");
		
		builder.getFont().setColor(Color.BLACK);
		builder.getFont().setBold(true);  
		builder.getFont().setName(defaultFont);
		builder.getFont().setSize(10);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.writeln("1.0 목적");
		builder.writeln("2.0 적용 범위");
		builder.writeln("3.0 용어 정의");
		builder.writeln("4.0 책임 사항");
		builder.writeln("5.0 일반 사항");
		builder.writeln("6.0 수행 절차");
		builder.writeln("7.0 관련 문서");
		builder.writeln("8.0 첨부");
		
		builder.getParagraphFormat().clearFormatting();
		///////////////////////////////////////////////////////////////////////////////////////
		// 목차 END
		builder.insertBreak(BreakType.PAGE_BREAK);
		*/
		builder.getFont().setSize(10);
		builder.getFont().setColor(Color.BLACK);
		builder.getFont().setName(defaultFont);
		
		// AttrList ====================================================================================
		List attrList = (List) itemInfo.get("attrList");
		if(attrList.size()>0){
			for(int j=0; j < attrList.size(); j++){
				Map attrInfoMap = (Map)attrList.get(j);
				String attrTypeCode = StringUtil.checkNullToBlank(attrInfoMap.get("AttrTypeCode"));
				
				if(attrTypeCode.equals("AT00501")){
					builder.getFont().setBold (false);
					
					String plainText = StringUtil.checkNullToBlank(attrInfoMap.get("PlainText")).replaceAll("<","<").replaceAll(">", ">").replaceAll("&quot;","\"").replace("upload/", logoPath).replace("<table","<table border=\"1\" style='border-collapse:collapse;'");
					// if(plainText.contains("font-family")){
					// builder.insertHtml(plainText);
					// }else{
					// builder.insertHtml(fontFamilyHtml+plainText+"</span>");
					builder.insertHtml(fontFamilyHtml+"<p>"+plainText+"</p>"+"</span>");
					// }
				}
			}
		}
	
		if(i != items.size()-1) builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
	
		if(i == 0){
			fileName = "Report_" + itemName + "_" + formatter.format(date);
			if(outputType.equals("pdf")) fileName += ".pdf";
			if(outputType.equals("doc")) fileName += ".docx";
		} else {
			fileName = "SOP_Report_" + formatter.format(date);
			if(outputType.equals("pdf")) fileName += ".pdf";
			if(outputType.equals("doc")) fileName += ".docx";
		}
	}
	//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		
	HashMap drmInfoMap = new HashMap();
	Map loginInfo = (Map) session.getAttribute("loginInfo");
	
	String userID = StringUtil.checkNull(loginInfo.get("sessionUserId"));
	String sessionLoginId = StringUtil.checkNull(loginInfo.get("sessionLoginId"));
	String userName = StringUtil.checkNull(loginInfo.get("sessionUserNm"));
	String teamID = StringUtil.checkNull(loginInfo.get("sessionTeamId"));
	String teamName = StringUtil.checkNull(loginInfo.get("sessionTeamName"));
	
	drmInfoMap.put("userID", userID);	
	drmInfoMap.put("userLoginID", sessionLoginId);	
	drmInfoMap.put("orgFileName", fileName.replace(selectedItemName,""));
	drmInfoMap.put("downFile", FileUtil.FILE_EXPORT_DIR + userID + "//" + fileName.replace(selectedItemName,""));

	doc.save(FileUtil.FILE_EXPORT_DIR + userID + "//" + fileName.replace(selectedItemName,""));
	downFileName = fileName.replace(itemName,selectedItemName);
	
	// file DRM 적용
	String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
	if(!"".equals(useDRM)){
		drmInfoMap.put("funcType", "report");
		drmFileName = DRMUtil.drmMgt(drmInfoMap); // 암호화 
	}
	

} catch(Exception e){
	e.printStackTrace();
	
} finally{

	
	if(!"".equals(drmFileName)) {
	    response.setContentType("application/msword");
	    response.setCharacterEncoding("UTF-8");
	    response.setHeader("Content-Transfer-Encoding", "binary");
		response.setHeader("Pragma", "no-cache");
		response.setHeader("Expires", "0");
	    response.setHeader("content-disposition","attachment; filename=" + downFileName);
		
		request.getSession(true).setAttribute("expFlag", "Y");
		BufferedInputStream fin = new BufferedInputStream(new FileInputStream(drmFileName));
		BufferedOutputStream outs = new BufferedOutputStream(response.getOutputStream());
		int read = 0;
		byte[] b = new byte[FileUtil.BUFF_SIZE];
		
		while ((read = fin.read(b)) != -1) {
			outs.write(b, 0, read);
		}
		
		outs.close();
		fin.close();
	}
	else {

	    response.setContentType("application/msword");
	    response.setCharacterEncoding("UTF-8");
	    response.setHeader("content-disposition","attachment; filename=" + downFileName);
		

		request.getSession(true).setAttribute("expFlag", "Y");
		response.getOutputStream().flush();
		response.getOutputStream().close();
	}
}

%>

