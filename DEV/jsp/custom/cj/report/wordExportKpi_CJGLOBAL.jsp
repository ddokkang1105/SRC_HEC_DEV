<%@page import="java.util.ArrayList"%>
<%@page contentType="application/msword; charset=utf-8"%>
<%@page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<%@page import="java.io.*" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.HashMap" %>
<%@page import="java.util.List" %>
<%@page import="xbolt.cmm.framework.util.StringUtil" %>
<%@page import="xbolt.cmm.framework.val.GlobalVal" %>

<%@page import="com.aspose.words.*" %>
<%@page import="java.awt.Color" %>
<%@page import="java.text.SimpleDateFormat" %>

<%

try{
	
	String LogoImgUrl = "";
	String modelImgPath = GlobalVal.MODELING_DIGM_DIR;
	String logoPath = GlobalVal.FILE_UPLOAD_TINY_DIR;
	String defaultFont = String.valueOf(request.getAttribute("defaultFont"));
	String fontFamilyHtml = "<span style=\"font-family:"+defaultFont+"; font-size: 10pt;\">";

	License license = new License();
	license.setLicense(logoPath + "Aspose.Words.lic");
	
	Document doc = new Document();
	DocumentBuilder builder = new DocumentBuilder(doc);	
	
	Map menu = (Map)request.getAttribute("menu");
 	Map setMap = (HashMap)request.getAttribute("setMap");
 	List kpiList = (List)request.getAttribute("kpiList");
 	Map attrRsNameMap = (Map)request.getAttribute("attrRsNameMap");
 	Map attrRsHtmlMap = (Map)request.getAttribute("attrRsHtmlMap");
 	Map selectedItemMap = (Map)request.getAttribute("selectedItemMap");
 	
 	String selectedItemPath = String.valueOf(request.getAttribute("selectedItemPath"));
 	String selectedItemName = String.valueOf(request.getAttribute("selectedItemName"));
 	
 	double titleCellWidth = 60.0;
 	double contentCellWidth3 = 90.0;
	double contentCellWidth = 165.0;
	double mergeCellWidth = 390.0;
	double totalCellWidth = 450.0;
	String value = "";
	String name = "";
	
	//==================================================================================================
	Section currentSection = builder.getCurrentSection();
    PageSetup pageSetup = currentSection.getPageSetup();
    String paperSize = String.valueOf(request.getAttribute("paperSize"));
   
    // page 여백 설정
	builder.getPageSetup().setRightMargin(30);
	builder.getPageSetup().setLeftMargin(30);
	builder.getPageSetup().setBottomMargin(30);
	builder.getPageSetup().setTopMargin(30);
	
	//builder.getPageSetup().setOrientation(Orientation.LANDSCAPE);
	// PaperSize 설정
	//if ("1".equals(paperSize)) {
		builder.getPageSetup().setPaperSize(PaperSize.A4);
	//} else if ("2".equals(paperSize)) {
	//	builder.getPageSetup().setPaperSize(PaperSize.A3);
	//}
//==================================================================================================

//=========================================================================
// TODO : FOOTER
	currentSection = builder.getCurrentSection();
    pageSetup = currentSection.getPageSetup();
    
    pageSetup.setDifferentFirstPageHeaderFooter(false);
    pageSetup.setFooterDistance(20);
    builder.moveToHeaderFooter(HeaderFooterType.FOOTER_PRIMARY);
    
    builder.startTable();
    builder.getCellFormat().getBorders().setLineWidth(0.0);
    builder.getFont().setName(defaultFont);
    builder.getFont().setColor(Color.BLACK);
    builder.getFont().setSize(10);
    
 	// 1.footer : Line
 	//builder.getParagraphFormat().setSpaceBefore(7);
    builder.insertHtml("<hr size=2 color='silver'/>");
 	// 2.footer : logo
    //builder.insertCell();
    //builder.getCellFormat().setWidth(150.0);
    //builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
    String imageFileName = logoPath + "logo_CJ.png";
    //builder.insertImage(imageFileName, 125, 25);
 	// 3.footer : current page / total page 
    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
    builder.insertCell();
    builder.getCellFormat().setWidth(150.0);
    // Set first cell to 1/3 of the page width.
    builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(100 / 3));
    // Insert page numbering text here.
    // It uses PAGE and NUMPAGES fields to auto calculate current page number and total number of pages.
    builder.insertField("PAGE", "");
    builder.write(" / ");
    builder.insertField("NUMPAGES", "");
    
 	// 4.footer : current page / total page 
    //builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
    //builder.insertCell();
    //builder.getCellFormat().setWidth(150.0);
    //builder.write("PI/ERP TFT");
    
    builder.endTable().setAllowAutoFit(false);
        
    builder.moveToDocumentEnd();
	//=========================================================================

	
  	//==================================================================================================
	
	builder = new DocumentBuilder(doc);  	
	//==================================================================================================
	/* 표지 */
 	// 표지 START
 	builder.startTable();
 	builder.getCellFormat().getBorders().setLineWidth(0.0);
 	
 	// 1.image
 	builder.insertCell();
  	builder.getCellFormat().setWidth(300.0);
 	builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
 	builder.insertHtml("<br>");
  	builder.insertImage(imageFileName, 180, 36);
  	builder.insertHtml("<br>");
  	builder.endRow();
  		
	// 2.KPI 정의서
	builder.insertCell();
	builder.getFont().setColor(Color.DARK_GRAY);
    builder.getFont().setBold(true);
    builder.getFont().setName(defaultFont);
    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
    builder.getFont().setSize(32);
    builder.insertHtml("<br>");
    builder.write("KPI 정의서");
	builder.endRow();

	// 3.선택한 프로세스 정보
	builder.insertCell();
    builder.getFont().setBold(true);
    builder.getFont().setName(defaultFont);
    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
    builder.getFont().setSize(18);
	builder.writeln("["+selectedItemName+"]"); // Rule Set 명
	builder.insertHtml("<br>");
	builder.insertHtml("<br>");
	builder.insertHtml("<br>");
	builder.insertHtml("<br>");
	builder.insertHtml("<br>");
	builder.endRow();
	
	// 4.선택한 프로세스 정보 테이블
	///////////////////////////////////////////////////////////////////////////////////////
	builder.insertCell();
	builder.getCellFormat().setWidth(30); // 테이블 앞 여백 설정
	
	builder.insertCell();
	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	builder.getCellFormat().setWidth(240);
	
	builder.startTable();
	builder.getRowFormat().clearFormatting();
	builder.getCellFormat().clearFormatting();
	
	// Make the header row.
	builder.insertCell();
	
	builder.getRowFormat().setHeight(30.0);
	builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
	
	// Some special features for the header row.
	builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(247, 247, 247));
	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	builder.getFont().setSize(11);
	builder.getFont().setUnderline(0);
	builder.getFont().setBold(false);
	builder.getFont().setColor(Color.BLACK);
	builder.getFont().setName(defaultFont);
	
	builder.getCellFormat().setWidth(70);
	builder.write("Owner"); // 작성자

	builder.insertCell();
	builder.getCellFormat().setWidth(100);
	builder.write(String.valueOf(menu.get("LN00131"))); // 프로젝트

	builder.insertCell();
	builder.getCellFormat().setWidth(70);
	builder.write(String.valueOf(menu.get("LN00078"))); // 생성일
	
	builder.endRow();
	
	// Set features for the other rows and cells.
	builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	
	// Reset height and define a different height rule for table body
	builder.getRowFormat().setHeight(30.0);
	builder.getRowFormat().setHeightRule(HeightRule.AUTO);
	
	builder.insertCell();
   	builder.getCellFormat().setWidth(70);
	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	builder.write(StringUtil.checkNullToBlank(selectedItemMap.get("Name")) + "("+StringUtil.checkNullToBlank(selectedItemMap.get("TeamName"))+")");				
	builder.insertCell();
   	builder.getCellFormat().setWidth(100);
	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	builder.write(StringUtil.checkNullToBlank(selectedItemMap.get("RefPjtName"))+"/"+StringUtil.checkNullToBlank(selectedItemMap.get("ProjectName")));
	builder.insertCell();
   	builder.getCellFormat().setWidth(70);
	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	builder.write(StringUtil.checkNullToBlank(selectedItemMap.get("CreateDT")));	
	builder.endRow();
	builder.endTable().setAlignment(TabAlignment.CENTER);
	builder.endRow();
	
	builder.endTable().setAllowAutoFit(false);
	builder.insertHtml("<br>");
	builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);	
    ///////////////////////////////////////////////////////////////////////////////////////
    
    // 머릿말 : START
	currentSection = builder.getCurrentSection();
    pageSetup = currentSection.getPageSetup();
    pageSetup.setDifferentFirstPageHeaderFooter(false);
    pageSetup.setHeaderDistance(20);
    builder.moveToHeaderFooter(HeaderFooterType.HEADER_PRIMARY);
    
	builder.startTable();
	builder.getRowFormat().clearFormatting();
	builder.getCellFormat().clearFormatting();
	builder.getRowFormat().setHeight(20.0);
	builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
	
	// Make the header row.
	builder.insertCell();
	
	builder.getRowFormat().setHeight(26.0);
	// builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
	builder.getRowFormat().setHeightRule(HeightRule.AUTO);
	
	// Some special features for the header row.
	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	builder.getFont().setSize(14);
	builder.getFont().setUnderline(0);
	builder.getFont().setBold(true);
	builder.getFont().setColor(Color.BLACK);
	builder.getFont().setName(defaultFont);
	
	builder.getCellFormat().setWidth(30);
	builder.getCellFormat().setVerticalMerge(CellMerge.FIRST);
	//builder.insertCell();
	builder.insertImage(imageFileName, 125, 25);

	builder.insertCell();
	builder.getCellFormat().setWidth(80);
	name = StringUtil.checkNullToBlank(selectedItemMap.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
	   	name = name.replace("&#10;", " ");
	   	name = name.replace("&#xa;", "");
	    name = name.replace("&nbsp;", " ");
	builder.write(selectedItemMap.get("Identifier") + " "+ name);  	
	
	builder.endRow();
	
	// Set features for the other rows and cells.
	builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	builder.getFont().setSize(11);
	builder.getFont().setUnderline(0);
	builder.getFont().setBold(false);
	
	// Reset height and define a different height rule for table body
	builder.getRowFormat().setHeight(30.0);
	builder.getRowFormat().setHeightRule(HeightRule.AUTO);
	
    builder.insertCell(); 	
    builder.getCellFormat().setWidth(30);
	builder.getCellFormat().setVerticalMerge(CellMerge.PREVIOUS);
	
	builder.insertCell();
   	builder.getCellFormat().setWidth(35);builder.getCellFormat().setVerticalMerge(CellMerge.NONE);
	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	builder.write(selectedItemMap.get("Identifier") + " "+ name);  
	
	builder.insertCell();
   	builder.getCellFormat().setWidth(45);builder.getCellFormat().setVerticalMerge(CellMerge.NONE);
	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	builder.write(StringUtil.checkNullToBlank(selectedItemMap.get("Path")));
	builder.endRow();
	
	builder.endTable().setAllowAutoFit(false);
	 // 타이틀과 내용 사이 간격
    builder.insertHtml("<hr size=2 color='silver'/>");
 	// 머릿말 : END
 	builder.moveToDocumentEnd();
	
	//==================================================================================================
	//1. 기본정보 
 	builder.getFont().setColor(Color.DARK_GRAY);
    builder.getFont().setSize(14);
    builder.getFont().setBold(true);
    builder.getFont().setName(defaultFont);
	builder.writeln("1. "+menu.get("LN00005"));
	builder.getFont().setSize(11);
			
	currentSection = builder.getCurrentSection();
    pageSetup = currentSection.getPageSetup();
    pageSetup.setDifferentFirstPageHeaderFooter(false);
    pageSetup.setHeaderDistance(25);
    
	builder.startTable();	 	 		
    builder.getFont().setName(defaultFont);
    builder.getFont().setColor(Color.BLACK);
    builder.getFont().setSize(10);
	
	// Make the header row.
	builder.getRowFormat().clearFormatting();
	builder.getCellFormat().clearFormatting();
	builder.getRowFormat().setHeight(150.0);
	builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경
	
 	// 1.ROW : 개요
	builder.insertCell();
	//==================================================================================================	
	builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	builder.getCellFormat().setWidth(titleCellWidth);
	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	builder.getFont().setBold (true);
	builder.getFont().setSize(10);
	builder.write(String.valueOf(menu.get("LN00035")));  // 개요
	
	builder.insertCell();
	builder.getCellFormat().setWidth(mergeCellWidth);
	builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	if(StringUtil.checkNullToBlank(selectedItemMap.get("Description")).contains("font-family")){
		builder.insertHtml(StringUtil.checkNullToBlank(selectedItemMap.get("Description")).replace("upload/", logoPath));
	}else{
		builder.insertHtml(fontFamilyHtml+StringUtil.checkNullToBlank(selectedItemMap.get("Description")).replace("upload/", logoPath)+"</span>");
	}
	//==================================================================================================	
	builder.endRow();
	
	builder.getRowFormat().clearFormatting();
	builder.getCellFormat().clearFormatting();
	builder.getRowFormat().setHeight(30.0);
	builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경
	
	// 2.ROW 
	builder.insertCell();
	//==================================================================================================	
	builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	builder.getCellFormat().setWidth(titleCellWidth);
	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	builder.getFont().setBold (true);
	builder.write(String.valueOf(menu.get("LN00016")));  // 계층
	
	builder.insertCell();
	builder.getCellFormat().setWidth(mergeCellWidth);
	builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	
	builder.getFont().setBold(false);
	builder.write(StringUtil.checkNullToBlank(selectedItemMap.get("ClassName"))); // 계층 : 내용
	//==================================================================================================	
	builder.endRow();
	
	//6.ROW : 작성자, 수정일
	builder.getRowFormat().clearFormatting();
	builder.getCellFormat().clearFormatting();
	builder.getRowFormat().setHeight(30.0);
	builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경	 	
		
	builder.insertCell();
	builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	builder.getCellFormat().setWidth(titleCellWidth);
	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	builder.getFont().setBold (true);
	builder.write(String.valueOf(menu.get("LN00060")));  // 작성자
	
	builder.insertCell();
	builder.getCellFormat().setWidth(contentCellWidth);
	builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	builder.getFont().setBold (false);
	builder.write(StringUtil.checkNullToBlank(selectedItemMap.get("Name"))); // 작성자 : 내용
	
	builder.insertCell();
	//==================================================================================================	
	builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	builder.getCellFormat().setWidth(titleCellWidth);
	builder.getRowFormat().setHeight(30.0);
	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	builder.getFont().setBold (true);
	builder.write(String.valueOf(menu.get("LN00070"))); // 수정일
	
	builder.insertCell();
	builder.getCellFormat().setWidth(contentCellWidth);
	builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	builder.getFont().setBold(false);
	builder.write(StringUtil.checkNullToBlank(selectedItemMap.get("LastUpdated"))); // 수정일 : 내용
	//==================================================================================================	
	builder.endRow(); 	 	
		
	builder.endTable().setAllowAutoFit(false);
	//==================================================================================================
	builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);	
	
	if (kpiList.size() > 0) {
		
		builder.getFont().setSize(10);
		builder.getFont().setColor(Color.BLACK);
		builder.getFont().setName(defaultFont);
		
		for(int i=0; i < kpiList.size(); i++){
			
			builder.startTable();
			builder.getRowFormat().clearFormatting();
			builder.getCellFormat().clearFormatting();
			builder.getRowFormat().setHeight(20.0);
			
			Map rowCnData = (HashMap) kpiList.get(i);
			List cnItemList = (List) rowCnData.get("resultSubList");
 			
		    if(i==0){
		    	// Reset font formatting.
		    	builder.getFont().setBold(false);
		    }
		    
		    // ID
		    builder.insertCell();
			builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
			builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			builder.getFont().setBold (true);
			builder.getCellFormat().setWidth(titleCellWidth);
			builder.write(String.valueOf(menu.get("LN00106"))); // ID
			
			builder.insertCell();
			builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			builder.getFont().setBold(false);
			builder.getCellFormat().setWidth(contentCellWidth);
			builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			builder.write(StringUtil.checkNullToBlank(rowCnData.get("toItemIdentifier")));
			
			// 명칭
		    builder.insertCell();
			builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
			builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			builder.getFont().setBold (true);
			builder.getCellFormat().setWidth(titleCellWidth);
			builder.write(String.valueOf(menu.get("LN00028"))); // 명칭
			
			builder.insertCell();
			builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			builder.getFont().setBold(false);
			builder.getCellFormat().setWidth(contentCellWidth);
			builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			builder.write(StringUtil.checkNullToBlank(rowCnData.get("toItemName")));
			builder.endRow();
			
			 // Owner
		    builder.insertCell();
			builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
			builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			builder.getFont().setBold (true);
			builder.getCellFormat().setWidth(titleCellWidth);
			builder.write(String.valueOf(attrRsNameMap.get("AT00012"))); // Owner
			builder.insertCell();
			builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			builder.getCellFormat().setWidth(contentCellWidth);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			if ("1".equals(StringUtil.checkNullToBlank(attrRsHtmlMap.get("AT00012")))) { // type이 HTML인 경우
 	 			builder.insertHtml(StringUtil.checkNullToBlank(rowCnData.get("AT00012")).replace("upload/", logoPath));
 	 		} else {
 	 			builder.getFont().setBold(false);
 	 			builder.write(StringUtil.checkNullToBlank(rowCnData.get("AT00012"))); //Owner : 내용
 	 		}
			
			// 작성자
		    builder.insertCell();
			builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
			builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			builder.getFont().setBold (true);
			builder.getCellFormat().setWidth(titleCellWidth);
			builder.write(String.valueOf(menu.get("LN00060"))); // 작성자
			builder.insertCell();
			builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			builder.getFont().setBold(false);
			builder.getCellFormat().setWidth(contentCellWidth);
			builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			builder.write(StringUtil.checkNullToBlank(rowCnData.get("toItemAuthorName")));
			builder.endRow();
			
			builder.getRowFormat().setHeight(100.0);
			builder.getRowFormat().setHeightRule(HeightRule.AUTO);
			
			// 개요
 	 		builder.insertCell();
 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
 	 		builder.getCellFormat().setWidth(titleCellWidth);
 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
 	 		builder.getFont().setBold (true);
 	 		builder.write(String.valueOf(attrRsNameMap.get("AT00003")));  // 개요
 	 		
 	 		builder.insertCell();
 	 		builder.getCellFormat().setWidth(mergeCellWidth);
 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
 	 		if ("1".equals(StringUtil.checkNullToBlank(attrRsHtmlMap.get("AT00003")))) { // type이 HTML인 경우
 	 			builder.insertHtml(StringUtil.checkNullToBlank(rowCnData.get("AT00003")).replace("upload/", logoPath));
 	 		} else {
 	 			builder.getFont().setBold(false);
 	 			builder.write(StringUtil.checkNullToBlank(rowCnData.get("AT00003"))); // 개요 : 내용
 	 		}
 	 		builder.endRow();
 	 		
 	 		// 산출공식
 	 		builder.insertCell();
 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
 	 		builder.getCellFormat().setWidth(titleCellWidth);
 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
 	 		builder.getFont().setBold (true);
 	 		builder.write(String.valueOf(attrRsNameMap.get("AT00007")));  // 산출공식
 	 		builder.insertCell();
 	 		builder.getCellFormat().setWidth(contentCellWidth);
 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
 	 		if ("1".equals(StringUtil.checkNullToBlank(attrRsHtmlMap.get("AT00007")))) { // type이 HTML인 경우
 	 			builder.insertHtml(StringUtil.checkNullToBlank(rowCnData.get("AT00007")).replace("upload/", logoPath));
 	 		} else {
 	 			builder.getFont().setBold(false);
 	 			builder.write(StringUtil.checkNullToBlank(rowCnData.get("AT00007"))); // IT System : 내용
 	 		}
		    
			// 연관 프로세스
			builder.insertCell();
			builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
 	 		builder.getCellFormat().setWidth(titleCellWidth);
 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
 	 		builder.getFont().setBold (true);
 	 		builder.write(String.valueOf(menu.get("LN00155")));  // 연관 프로세스
			builder.insertCell();
			builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			builder.getCellFormat().setWidth(contentCellWidth);
			builder.getFont().setBold(false);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			String cnItems = "";
			for(int prcCnt=0; prcCnt < cnItemList.size(); prcCnt++){
				String cnItem = String.valueOf(cnItemList.get(prcCnt));
				builder.writeln(cnItem);
			}
					
			builder.endRow();
			builder.endTable().setAllowAutoFit(false);	
			
			builder.insertHtml("<br>");
		}	
	}
	
	//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
	long date = System.currentTimeMillis();
    String fileName = "KPI_Report_" + selectedItemName + "_"+ formatter.format(date) + ".docx";
    response.setContentType("application/msword");
    response.setCharacterEncoding("UTF-8");
    response.setHeader("content-disposition","attachment; filename=" + fileName);
    
    doc.save(response.getOutputStream(), SaveFormat.DOCX);

} catch(Exception e){
	e.printStackTrace();
	
} finally{
	response.getOutputStream().flush();
	response.getOutputStream().close();
}

%>

