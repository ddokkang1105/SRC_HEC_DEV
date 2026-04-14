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
 	
	License license = new License();
	license.setLicense(logoPath + "Aspose.Words.lic");
	
	Document doc = new Document();
	DocumentBuilder builder = new DocumentBuilder(doc);	
	
	Map menu = (Map)request.getAttribute("menu");
 	Map setMap = (HashMap)request.getAttribute("setMap");
 	List allTotalList = (List)request.getAttribute("allTotalList");
 	
 	String onlyMap = String.valueOf(request.getAttribute("onlyMap"));
 	String paperSize = String.valueOf(request.getAttribute("paperSize"));
 	String itemNameOfFileNm = String.valueOf(request.getAttribute("ItemNameOfFileNm"));
 	
 	Map e2eModelMap = (Map)request.getAttribute("e2eModelMap");
 	Map e2eItemInfo = (Map)request.getAttribute("e2eItemInfo");
 	Map e2eAttrMap = (Map)request.getAttribute("e2eAttrMap");
 	Map e2eAttrNameMap = (Map)request.getAttribute("e2eAttrNameMap");
 	Map e2eAttrHtmlMap = (Map)request.getAttribute("e2eAttrHtmlMap");
 	List e2eDimResultList = (List)request.getAttribute("e2eDimResultList");
 	
 	List lowLankItemIdList = (List)request.getAttribute("lowLankItemIdList");
 	String selectedItemPath = String.valueOf(request.getAttribute("selectedItemPath"));
 	
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
    
    // page 여백 설정
	builder.getPageSetup().setRightMargin(30);
	builder.getPageSetup().setLeftMargin(30);
	builder.getPageSetup().setBottomMargin(30);
	builder.getPageSetup().setTopMargin(30);
	
	// PaperSize 설정
	if ("1".equals(paperSize)) {
		builder.getPageSetup().setPaperSize(PaperSize.A4);
	} else if ("2".equals(paperSize)) {
		builder.getPageSetup().setPaperSize(PaperSize.A3);
	}
//==================================================================================================

//=========================================================================
// TODO : FOOTER
	currentSection = builder.getCurrentSection();
    pageSetup = currentSection.getPageSetup();
    
    pageSetup.setDifferentFirstPageHeaderFooter(false);
    pageSetup.setFooterDistance(25);
    builder.moveToHeaderFooter(HeaderFooterType.FOOTER_PRIMARY);
    
    builder.startTable();
    builder.getCellFormat().getBorders().setLineWidth(0.0);
    builder.getFont().setName(defaultFont);
    builder.getFont().setColor(Color.BLACK);
    builder.getFont().setSize(10);
    
 	// 1.footer : Line
 	builder.getParagraphFormat().setSpaceBefore(7);
    builder.insertHtml("<hr size=5 color='silver'/>");
 	// 2.footer : logo
    builder.insertCell();
    builder.getCellFormat().setWidth(150.0);
    builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
    String imageFileName = logoPath + "logo.png";
    builder.insertImage(imageFileName, 125, 25);
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
    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
    builder.insertCell();
    builder.getCellFormat().setWidth(150.0);
    builder.write("PI/ERP TFT");
    
    builder.endTable().setAllowAutoFit(false);
        
    builder.moveToDocumentEnd();
//=========================================================================
	
	builder = new DocumentBuilder(doc);
	
	//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	for (int totalCnt = 0;allTotalList.size() > totalCnt ; totalCnt++ ) {
		Map allTotalMap = (Map)allTotalList.get(totalCnt);
		Map titleItemMap = new HashMap();
		List totalList = (List)allTotalMap.get("totalList");
		if (!e2eModelMap.isEmpty()) {
			titleItemMap = e2eItemInfo;
		} else {
			titleItemMap = (Map)allTotalMap.get("titleItemMap");
		}
		
		//==================================================================================================
		/* 표지 */
		if (totalList.size() > 1) { 
			currentSection = builder.getCurrentSection();
		    pageSetup = currentSection.getPageSetup();
		    pageSetup.setDifferentFirstPageHeaderFooter(true);
		    
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
    		
    		// 2.TO-BE 프로세스 정의서
    		builder.insertCell();
    		builder.getFont().setColor(Color.DARK_GRAY);
		    builder.getFont().setBold(true);
		    builder.getFont().setName(defaultFont);
		    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		    builder.getFont().setSize(60);
		    builder.insertHtml("<br>");
		    builder.getFont().setSize(36);
		    if (!e2eModelMap.isEmpty()) {
		    	builder.writeln("E2E 프로세스 정의서");
		    } else {
		    	builder.writeln("TO-BE 프로세스 정의서");
		    }
			builder.endRow();
			
			// 3.선택한 L2 프로세스 정보
    		builder.insertCell();
    		builder.getFont().setColor(Color.BLUE);
		    builder.getFont().setBold(true);
		    builder.getFont().setName(defaultFont);
		    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		    builder.getFont().setSize(26);
		    builder.getFont().setUnderline(1);
			builder.writeln(selectedItemPath);
			builder.insertHtml("<br>");
    		builder.insertHtml("<br>");
    		builder.insertHtml("<br>");
			builder.endRow();
    		
    		// 4.선택한 L2 프로세스 정보 테이블
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
			
			builder.getCellFormat().setWidth(80);
			builder.write(String.valueOf(menu.get("LN00060"))); // 작성자

			builder.insertCell();
			builder.getCellFormat().setWidth(80);
			builder.write(String.valueOf(menu.get("LN00131"))); // 프로젝트

			builder.insertCell();
			builder.getCellFormat().setWidth(80);
			builder.write(String.valueOf(menu.get("LN00013"))); // 생성일
			
			builder.endRow();
			
			// Set features for the other rows and cells.
			builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			
			// Reset height and define a different height rule for table body
			builder.getRowFormat().setHeight(30.0);
			builder.getRowFormat().setHeightRule(HeightRule.AUTO);
			
			builder.insertCell();
		   	builder.getCellFormat().setWidth(80);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(StringUtil.checkNullToBlank(titleItemMap.get("Name")));				
			builder.insertCell();
		   	builder.getCellFormat().setWidth(80);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write("PI/ERP TFT");
			builder.insertCell();
		   	builder.getCellFormat().setWidth(80);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(StringUtil.checkNullToBlank(titleItemMap.get("CreateDT")));	
			builder.endRow();
			builder.endTable().setAlignment(TabAlignment.CENTER);
			builder.endRow();
			
			builder.endTable().setAllowAutoFit(false);
    		///////////////////////////////////////////////////////////////////////////////////////
    		
    		// 표지 END
		    
		 	// content START	
		    builder.insertBreak(BreakType.PAGE_BREAK);
		    
			builder.getFont().setColor(Color.DARK_GRAY);
		    builder.getFont().setSize(14);
		    builder.getFont().setBold(true);
		    builder.getFont().setName(defaultFont);
		    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		    builder.insertHtml("<br>");
			builder.writeln("- Content -"); // content
			builder.insertHtml("<br>");
			
		    builder.getFont().setSize(11);
		    builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		    
			for (int lowlankCnt = 0;lowLankItemIdList.size() > lowlankCnt ; lowlankCnt++) {
				Map lowLankItemIdMap = (Map) lowLankItemIdList.get(lowlankCnt);
				
				String l2Item = StringUtil.checkNull(lowLankItemIdMap.get("l2Item"));
				List l3l4ItemIdList = (List) lowLankItemIdMap.get("l3l4ItemIdList");
				
				if (!l2Item.isEmpty()) {
					builder.writeln("\t" + l2Item);
				}
				
				for (int l3l4Cnt = 0;l3l4ItemIdList.size() > l3l4Cnt ; l3l4Cnt++) {
					Map l3l4ItemIdMap = (Map) l3l4ItemIdList.get(l3l4Cnt);
					String l3Item = StringUtil.checkNull(l3l4ItemIdMap.get("l3Item"));
					List l4ItemList = (List) l3l4ItemIdMap.get("l4ItemList");
					
					if (!l3Item.isEmpty()) {
						builder.writeln("\t\t" + l3Item);
					}
					for (int l4Cnt = 0;l4ItemList.size() > l4Cnt ; l4Cnt++) {
						builder.writeln("\t\t\t" + l4ItemList.get(l4Cnt).toString());
					}
				}
			}
			// content END
			
			/* E2E : E2E기본정보 및 E2E모델맵 표시*/
			if (!e2eModelMap.isEmpty()) {
				builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
				//==================================================================================================
				// 머릿말 : START
				currentSection = builder.getCurrentSection();
			    pageSetup = currentSection.getPageSetup();
			    pageSetup.setDifferentFirstPageHeaderFooter(false);
			    pageSetup.setHeaderDistance(25);
			    builder.moveToHeaderFooter(HeaderFooterType.HEADER_PRIMARY);
			    
				builder.startTable();
				builder.getRowFormat().clearFormatting();
				builder.getCellFormat().clearFormatting();
				builder.getRowFormat().setHeight(25.0);
				builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
				
				builder.insertCell();
				builder.getCellFormat().getBorders().setColor(Color.WHITE);
				builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				builder.getFont().setName(defaultFont);
			    builder.getFont().setBold(true);
			    builder.getFont().setColor(Color.BLUE);
			    builder.getFont().setSize(14);
			    builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			   	name = StringUtil.checkNullToBlank(e2eItemInfo.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
			   	name = name.replace("&#10;", " ");
			   	name = name.replace("&#xa;", "");
			   	name = name.replace("&nbsp;", " ");
			    builder.write("E2E Scenario : " + StringUtil.checkNullToBlank(e2eItemInfo.get("Identifier")) + " "+ name);
			   
			    builder.getFont().setName(defaultFont);
			    builder.getFont().setColor(Color.LIGHT_GRAY);
			    builder.getFont().setSize(12);
			    
			    builder.insertCell();
				builder.getCellFormat().getBorders().setColor(Color.WHITE);
				builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				builder.getParagraphFormat().setAlignment(ParagraphAlignment.RIGHT);
				String path = String.valueOf(e2eItemInfo.get("Path"));
				if (path.equals("/")) {
					path = "";
				}
			    builder.write(path); 
			    builder.endRow();	
			    builder.endTable().setAllowAutoFit(false);	
			    
			    // 타이틀과 내용 사이 간격
			    builder.insertHtml("<hr size=4 color='silver'/>");
			    
			 	// 머릿말 : END
			 	builder.moveToDocumentEnd();
			  	//==================================================================================================
			  	//==================================================================================================
			  	// E2E 기본정보 표시
				builder.startTable();
	 	 		
	 	 	    builder.getFont().setName(defaultFont);
	 	 	    builder.getFont().setColor(Color.BLACK);
	 	 	    builder.getFont().setSize(10);
	 	 		
	 	 		// Make the header row.
	 	 		builder.getRowFormat().clearFormatting();
	 	 		builder.getCellFormat().clearFormatting();
	 	 		builder.getRowFormat().setHeight(150.0);
	 	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경
	 	 		
	 	 	 	// 1.ROW
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(e2eAttrNameMap.get("AT00003")));  // 개요
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(mergeCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(e2eAttrHtmlMap.get("AT00003")))) { // type이 HTML인 경우
	 	 			builder.insertHtml(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00003")).replace("/upload", logoPath));
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00003"))); // 개요 : 내용
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
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(e2eAttrNameMap.get("AT00020")));  // Main Module
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(e2eAttrHtmlMap.get("AT00020")))) { // type이 HTML인 경우
	 	 			builder.insertHtml(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00020")));
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00020"))); // Main Module : 내용
	 	 		}
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(e2eAttrNameMap.get("AT00072")));  // 연관 모듈
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(e2eAttrHtmlMap.get("AT00072")))) { // type이 HTML인 경우
	 	 			builder.insertHtml(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00072")));
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00072"))); // 연관 모듈 : 내용
	 	 		}
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 		// 3.ROW
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(menu.get("LN00060"))); // 작성자
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
		 		builder.write(StringUtil.checkNullToBlank(e2eItemInfo.get("Name"))); // 작성자 : 내용
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(e2eAttrNameMap.get("AT00018")));  // Due date
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(e2eAttrHtmlMap.get("AT00018")))) { // type이 HTML인 경우
	 	 			builder.insertHtml(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00018")));
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00018"))); // Due date : 내용
	 	 		}
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 		// 4.ROW
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(menu.get("LN00013"))); // 생성일
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
		 		builder.write(StringUtil.checkNullToBlank(e2eItemInfo.get("CreateDT"))); // 생성일 : 내용
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(menu.get("LN00070")));  // 수정일
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
	 	 		builder.write(StringUtil.checkNullToBlank(e2eItemInfo.get("LastUpdated"))); // 수정일 : 내용
	 	 		builder.endRow();
	 	 		//==================================================================================================
	 	 		
	 	 		// 5.ROW
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(e2eAttrNameMap.get("AT00006")));  // 비고
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(mergeCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(e2eAttrHtmlMap.get("AT00006")))) { // type이 HTML인 경우
	 	 			builder.insertHtml(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00006")).replace("/upload", logoPath));
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00006"))); // 비고 : 내용
	 	 		}
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 		// 6.ROW (Dimension 정보 만큼 행 표시)
	 	 		for(int j=0; j<e2eDimResultList.size(); j++){
	 	 			Map dimResultMap = (Map) e2eDimResultList.get(j);
		 	 		
	 	 			builder.insertCell();
		 	 		//==================================================================================================	
		 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
		 	 		builder.getCellFormat().setWidth(titleCellWidth);
		 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		 	 		builder.getFont().setBold (true);
		 	 		builder.write(String.valueOf(dimResultMap.get("dimTypeName")));
		 	 		
		 	 		builder.insertCell();
		 	 		builder.getCellFormat().setWidth(mergeCellWidth);
		 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		 	 		builder.getFont().setBold(false);
	 	 			builder.write(StringUtil.checkNullToBlank(dimResultMap.get("dimValueNames")));
		 	 		//==================================================================================================	
	 	 			builder.endRow();
	 	 		}
	 	 		
	 	 		builder.endTable().setAllowAutoFit(false);
	 	 		builder.writeln();
			  	
			  	
			  	//==================================================================================================
				//==================================================================================================
			 	//프로세스 맵
			 	builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
		 	 	builder.startTable();
		 	    
		 	 	builder.insertCell();
		 	 	builder.getRowFormat().clearFormatting();
		 		builder.getCellFormat().clearFormatting();
		 		builder.getRowFormat().setHeight(20.0);
		 		builder.getRowFormat().setHeightRule(HeightRule.AUTO);
		 	 	builder.getCellFormat().setWidth(totalCellWidth);
		 	 	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		 	 	
		 		String imgLang = "_"+StringUtil.checkNull(setMap.get("langCode"));
		 		String imgPath = modelImgPath+e2eModelMap.get("ModelID")+imgLang+"."+GlobalVal.MODELING_DIGM_IMG_TYPE;
		 		int width = Integer.parseInt(String.valueOf(e2eModelMap.get("Width")));
		 		int height = Integer.parseInt(String.valueOf(e2eModelMap.get("Height")));
		 		System.out.println("프로세스맵 imgPath="+imgPath);
		 		try{
		 			builder.insertHtml("<br>");
		 			builder.insertImage(imgPath, RelativeHorizontalPosition.PAGE, 30, RelativeVerticalPosition.PAGE,20,width,height,WrapType.INLINE);
		 			builder.insertHtml("<br>");
		 		} catch(Exception ex){}
		 		
		 		builder.endTable().setAllowAutoFit(false);
			}
	 		//==================================================================================================
			
		} 
		
		
		//==================================================================================================
		
	 	for (int index = 0; totalList.size() > index ; index++) {
	 		
	 		if (totalList.size() != 1) {
	 			builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
	 		}
	 		
	 		Map totalMap = (Map)totalList.get(index);
	 		
	 		List prcList = (List)totalMap.get("prcList");
	 		Map rowPrcData =  (HashMap) prcList.get(0); 
	 		List activityList = (List)totalMap.get("activityList");
	 		List elementList = (List)totalMap.get("elementList");
	 		List cnitemList = (List)totalMap.get("cnitemList");
	 		List dimResultList = (List)totalMap.get("dimResultList");
	 		List ruleSetList = (List)totalMap.get("ruleSetList");
	 		List kpiList = (List)totalMap.get("kpiList");
	 		List attachFileList = (List)totalMap.get("attachFileList");
	 		Map attrMap = (Map)totalMap.get("attrMap");
	 		Map attrNameMap = (Map)totalMap.get("attrNameMap");
	 		Map attrHtmlMap = (Map)totalMap.get("attrHtmlMap");
	 		Map modelMap = (Map)totalMap.get("modelMap");
	 		Map attrRsNameMap = (Map)totalMap.get("attrRsNameMap");
	 		Map attrRsHtmlMap = (Map)totalMap.get("attrRsHtmlMap");
	 		
	 		currentSection = builder.getCurrentSection();
	 	    pageSetup = currentSection.getPageSetup();
	 	    
	 	    pageSetup.setDifferentFirstPageHeaderFooter(false);
	 	    pageSetup.setHeaderDistance(25);
	 	    builder.moveToHeaderFooter(HeaderFooterType.HEADER_PRIMARY);
	 	    
	 	 	//==================================================================================================
	 		// 머릿말 : START
	 		builder.startTable();
	 		builder.getRowFormat().clearFormatting();
	 		builder.getCellFormat().clearFormatting();
	 		builder.getRowFormat().setHeight(25.0);
	 		builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
	 		
	 		builder.insertCell();
	 		builder.getCellFormat().getBorders().setColor(Color.WHITE);
	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 		builder.getFont().setName(defaultFont);
	 	    builder.getFont().setBold(true);
	 	    builder.getFont().setColor(Color.BLUE);
	 	    builder.getFont().setSize(11);
	 	    builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	   	name = StringUtil.checkNullToBlank(rowPrcData.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
	 	   	name = name.replace("&#10;", " ");
	 	   	name = name.replace("&#xa;", "");
	 	    name = name.replace("&nbsp;", " ");
	 	    builder.write(rowPrcData.get("Identifier") + " "+ name);  
	 	    
	 	    builder.getFont().setName(defaultFont);
	 	    builder.getFont().setColor(Color.LIGHT_GRAY);
	 	    builder.getFont().setSize(11);
	 	    
	 	    builder.insertCell();
	 		builder.getCellFormat().getBorders().setColor(Color.WHITE);
	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.RIGHT);
	 	    builder.write(String.valueOf(rowPrcData.get("Path"))); 
	 	    builder.endRow();	
	 	    builder.endTable().setAllowAutoFit(false);	
	 	    
	 	    // 타이틀과 내용 사이 간격
	 	    builder.insertHtml("<hr size=4 color='silver'/>");
	 	 	// 머릿말 : END
	 	 	builder.moveToDocumentEnd();
	 	  	//==================================================================================================
	 		
	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 		//==================================================================================================
	 		// 표시 될 값 설정
 			String id = StringUtil.checkNullToBlank(rowPrcData.get("Identifier"));
 			String prcName = StringUtil.checkNullToBlank(rowPrcData.get("ItemName"));
			String teamId = StringUtil.checkNullToBlank(rowPrcData.get("OwnerTeamID"));
 	 		String teamName = StringUtil.checkNullToBlank(rowPrcData.get("OwnerTeamName"));
 	 		String teamIdAndName = teamId + "." + teamName;
	 	 		
	 		// 아이템 속성 		
	 		if ("N".equals(onlyMap)) {
	 			// Map
	 			builder.getFont().setColor(Color.BLACK);
			    builder.getFont().setSize(10);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
				
	 	 		if (null != modelMap) {
	 	 		//==================================================================================================
	 		 		//프로세스 맵
	 		 	 	builder.startTable();
	 	 			
	 		 		//==================================================================================================
	 		 	 	builder.getRowFormat().clearFormatting();
					builder.getCellFormat().clearFormatting();
					builder.getRowFormat().setHeight(30.0);
		 	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO);
		 	 		builder.insertCell();
		 	 			
		 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
		 	 		builder.getCellFormat().setWidth(titleCellWidth);
		 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		 	 		builder.getFont().setBold (true);
		 	 		builder.write("Process");  // Process
		 	 		
		 	 		builder.insertCell();
		 	 		builder.getCellFormat().setWidth(mergeCellWidth);
		 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
		 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		 	 		builder.write(id + "_" + prcName + " (" + teamIdAndName + ")"); // 프로세스 목적 : 내용
		 	 		builder.endRow();
		 	 		//==================================================================================================	
	 	 		
	 		 	 	builder.insertCell();
	 		 	 	builder.getRowFormat().clearFormatting();
	 		 		builder.getCellFormat().clearFormatting();
	 		 		builder.getRowFormat().setHeight(20.0);
	 		 		builder.getRowFormat().setHeightRule(HeightRule.AUTO);
	 		 	 	builder.getCellFormat().setWidth(totalCellWidth);
	 		 	 	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 		 	 	
	 		 		String imgLang = "_"+StringUtil.checkNull(setMap.get("langCode"));
	 		 		String imgPath = modelImgPath+modelMap.get("ModelID") + imgLang+"."+ GlobalVal.MODELING_DIGM_IMG_TYPE;
	 		 		int width = Integer.parseInt(String.valueOf(modelMap.get("Width")));
	 		 		int height = Integer.parseInt(String.valueOf(modelMap.get("Height")));
	 		 		System.out.println("프로세스맵 imgPath="+imgPath);
	 		 		try{
	 		 			builder.insertHtml("<br>");
	 		 			builder.insertImage(imgPath, RelativeHorizontalPosition.PAGE, 30, RelativeVerticalPosition.PAGE,20,width,height,WrapType.INLINE);
	 		 			builder.insertHtml("<br>");
	 		 		} catch(Exception ex){}
	 		 		
	 		 		builder.endTable().setAllowAutoFit(false);
	 		 		
	 		 		//==================================================================================================
	 	 		}
	 			
	 			// 프로세스 기본 정보 Title
	 			if (null != modelMap) {
	 				builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
	 			}
	 			builder.startTable();
	 	 		
	 	 	    builder.getFont().setName(defaultFont);
	 	 	    builder.getFont().setColor(Color.BLACK);
	 	 	    builder.getFont().setSize(10);
	 	 		
	 	 		// Make the header row.
	 	 		builder.getRowFormat().clearFormatting();
	 	 		builder.getCellFormat().clearFormatting();
	 	 		builder.getRowFormat().setHeight(30.0);
	 	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO);
	 	 		
	 	 		// 1.ROW
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write("Process ID");  // Process ID
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
	 	 		builder.write(id); // Process ID : 내용
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write("Process 명");  // Process 명
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
 	 			builder.write(id + "_" + prcName); // Process 명 : 내용
	 	 		
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 		// 2.ROW
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(attrNameMap.get("AT00007")));  // 프로세스 오너
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00007")))) { // type이 HTML인 경우
	 	 			builder.insertHtml(StringUtil.checkNullToBlank(attrMap.get("AT00007")).replace("/upload", logoPath));
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00007"))); // 프로세스 오너 : 내용
	 	 		}
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(attrNameMap.get("AT00008")));  // 작성 책임자
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00008")))) { // type이 HTML인 경우
	 	 			builder.insertHtml(StringUtil.checkNullToBlank(attrMap.get("AT00008")).replace("/upload", logoPath));
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00008"))); // 작성 책임자 : 내용
	 	 		}
	 	 		
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 		// 3.ROW
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(attrNameMap.get("AT00009")));  // 시작 Event
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00009")))) { // type이 HTML인 경우
	 	 			builder.insertHtml(StringUtil.checkNullToBlank(attrMap.get("AT00009")).replace("/upload", logoPath));
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00009"))); // 시작 Event : 내용
	 	 		}
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(attrNameMap.get("AT00010")));  // 종료 Event
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00010")))) { // type이 HTML인 경우
	 	 			builder.insertHtml(StringUtil.checkNullToBlank(attrMap.get("AT00010")).replace("/upload", logoPath));
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00010"))); // 종료 Event : 내용
	 	 		}
	 	 		
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 		// 4.ROW
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(menu.get("LN00153")));  // 담당조직
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
 	 			builder.write(teamIdAndName); // 담당조직 : 내용 TODO
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(menu.get("LN00018")));  // 관리조직
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
 	 			builder.write(teamIdAndName); // 관리조직 : 내용 TODO
	 	 		
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 		// 5.ROW
	 	 	 	builder.getRowFormat().clearFormatting();
				builder.getCellFormat().clearFormatting();
				builder.getRowFormat().setHeight(150.0);
	 	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경
	 	 		builder.insertCell();
	 	 		//==================================================================================================
	 	 				
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(attrNameMap.get("AT00004")));  // 프로세스 목적
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(mergeCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00004")))) { // type이 HTML인 경우
	 	 			builder.insertHtml(StringUtil.checkNullToBlank(attrMap.get("AT00004")).replace("/upload", logoPath));
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00004"))); // 프로세스 목적 : 내용
	 	 		}
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 	 	// 6.ROW
	 	 		builder.insertCell();
	 	 		//==================================================================================================
	 	 				
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(attrNameMap.get("AT00003")));  // 개요
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(mergeCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00003")))) { // type이 HTML인 경우
	 	 			builder.insertHtml(StringUtil.checkNullToBlank(attrMap.get("AT00003")).replace("/upload", logoPath));
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00003"))); // 개요 : 내용
	 	 		}
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 		builder.endTable().setAllowAutoFit(false);
	 	 		builder.writeln();
	 	 		
		 		// 액티비티리스트
		 		if (activityList.size() == 0) {
		 			builder.insertHtml("<br>");
		 		}
		 		builder.getFont().setColor(Color.BLACK);
			    builder.getFont().setSize(10);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
				
				if (activityList.size() > 0) {
					Map rowActData = new HashMap();
					
					builder.startTable();
					builder.getRowFormat().clearFormatting();
					builder.getCellFormat().clearFormatting();
					
					//==================================================================================================
					builder.insertCell();
					builder.getRowFormat().setHeight(30.0);
		 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
		 	 		builder.getCellFormat().setWidth(totalCellWidth);
		 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		 	 		builder.getFont().setBold (true);
		 	 		builder.write(String.valueOf(menu.get("LN00151")));  // 액티비티리스트
		 	 		builder.endRow();
		 	 		//==================================================================================================
		 	 		
					// Make the header row.
					builder.insertCell();
					builder.getRowFormat().setHeight(20.0);
					builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
					
					// Some special features for the header row.
					builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					builder.getFont().setSize(10);
					builder.getFont().setBold (true);
					builder.getFont().setColor(Color.BLACK);
					builder.getFont().setName(defaultFont);
					
					builder.getCellFormat().setWidth(40.0);
					builder.write(String.valueOf(menu.get("LN00015"))); // 액티비티 코드
					builder.insertCell();
					builder.getCellFormat().setWidth(60.0);
					builder.write(String.valueOf(menu.get("LN00028"))); // 액티비티명
					builder.insertCell();
					builder.getCellFormat().setWidth(110.0);
					builder.write(String.valueOf(menu.get("LN00035"))); // 액티비티 설명
					builder.insertCell();
					builder.getCellFormat().setWidth(40.0);
					builder.write(String.valueOf(attrNameMap.get("AT00005"))); // 수행부서
					builder.insertCell();
					builder.getCellFormat().setWidth(40.0);
					builder.write(String.valueOf(attrNameMap.get("AT00006"))); // 수행주체
					builder.insertCell();
					builder.getCellFormat().setWidth(40.0);
					builder.write(String.valueOf(attrNameMap.get("AT00011"))); // From
					builder.insertCell();
					builder.getCellFormat().setWidth(40.0);
					builder.write(String.valueOf(attrNameMap.get("AT00012"))); // TO
					builder.insertCell();
					builder.getCellFormat().setWidth(40.0);
					builder.write(String.valueOf(attrNameMap.get("AT00013"))); // 사용 시스템
					builder.insertCell();
					builder.getCellFormat().setWidth(40.0);
					builder.write(String.valueOf(attrNameMap.get("AT00017"))); // 산출물
					
					builder.endRow();	
					
					// Set features for the other rows and cells.
					builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
					builder.getCellFormat().setWidth(100.0);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					
					// Reset height and define a different height rule for table body
					builder.getRowFormat().setHeight(30.0);
					builder.getRowFormat().setHeightRule(HeightRule.AUTO);
					
					for(int j=0; j<activityList.size(); j++){
					    rowActData = (HashMap) activityList.get(j);
					    
				    	builder.insertCell();
					    if( j==0){
					    	// Reset font formatting.
					    	builder.getFont().setBold(false);
					    }
					    String activityId = StringUtil.checkNullToBlank(rowActData.get("Identifier"));
					    builder.getCellFormat().setWidth(40.0);
					   	builder.write(activityId);
						
						String itemName = StringUtil.checkNullToBlank(rowActData.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
						itemName = itemName.replace("&#10;", " ");
						itemName = itemName.replace("&#xa;", "");
						itemName = itemName.replace("&nbsp;", " ");
						String processInfo = StringUtil.checkNullToBlank(rowActData.get("ProcessInfo")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
						processInfo = processInfo.replace("&#10;", " ");
						processInfo = processInfo.replace("&#xa;", "");
						processInfo = processInfo.replace("&nbsp;", " ");
						
						builder.insertCell();
					   	builder.getCellFormat().setWidth(60.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						builder.write(id + activityId + " " + itemName);
						builder.insertCell();
						builder.getCellFormat().setWidth(110.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						builder.write(processInfo);
						builder.insertCell();
						builder.getCellFormat().setWidth(40.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00005"))); // 수행부서
						builder.insertCell();
						builder.getCellFormat().setWidth(40.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00006"))); // 수행주체
						builder.insertCell();
						builder.getCellFormat().setWidth(40.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00011"))); // From
						builder.insertCell();
						builder.getCellFormat().setWidth(40.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00012"))); // TO
						builder.insertCell();
						builder.getCellFormat().setWidth(40.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00013"))); // 사용 시스템
						builder.insertCell();
						builder.getCellFormat().setWidth(40.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00017"))); // 산출물
						builder.endRow();
					}	
					builder.endTable().setAllowAutoFit(false);	
				}
				//==================================================================================================
				
		 	} else {
		 		if (null != modelMap) {
		 			//==================================================================================================
	 		 		//프로세스 맵
	 		 	 	builder.startTable();
	 	 			
	 		 		//==================================================================================================
	 		 	 	builder.getRowFormat().clearFormatting();
					builder.getCellFormat().clearFormatting();
					builder.getRowFormat().setHeight(30.0);
		 	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO);
		 	 		builder.insertCell();
		 	 			
		 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
		 	 		builder.getCellFormat().setWidth(titleCellWidth);
		 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		 	 		builder.getFont().setBold (true);
		 	 		builder.write("Process");  // Process
		 	 		
		 	 		builder.insertCell();
		 	 		builder.getCellFormat().setWidth(mergeCellWidth);
		 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
		 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		 	 		builder.write(id + "_" + prcName + " (" + teamIdAndName + ")"); // 프로세스 목적 : 내용
		 	 		builder.endRow();
		 	 		//==================================================================================================	
	 	 		
	 		 	 	builder.insertCell();
	 		 	 	builder.getRowFormat().clearFormatting();
	 		 		builder.getCellFormat().clearFormatting();
	 		 		builder.getRowFormat().setHeight(20.0);
	 		 		builder.getRowFormat().setHeightRule(HeightRule.AUTO);
	 		 	 	builder.getCellFormat().setWidth(totalCellWidth);
	 		 	 	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 		 	 	
	 		 		String imgLang = "_"+StringUtil.checkNull(setMap.get("langCode"));
	 		 		String imgPath = modelImgPath+modelMap.get("ModelID") + imgLang+"."+ GlobalVal.MODELING_DIGM_IMG_TYPE;
	 		 		int width = Integer.parseInt(String.valueOf(modelMap.get("Width")));
	 		 		int height = Integer.parseInt(String.valueOf(modelMap.get("Height")));
	 		 		System.out.println("프로세스맵 imgPath="+imgPath);
	 		 		try{
	 		 			builder.insertHtml("<br>");
	 		 			builder.insertImage(imgPath, RelativeHorizontalPosition.PAGE, 30, RelativeVerticalPosition.PAGE,20,width,height,WrapType.INLINE);
	 		 			builder.insertHtml("<br>");
	 		 		} catch(Exception ex){}
	 		 		
	 		 		builder.endTable().setAllowAutoFit(false);
	 		 		
	 		 		//==================================================================================================
	 	 		}
		 	}
	 	} 
	}
	
	//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
	long date = System.currentTimeMillis();
    String fileName = "BPD_" + itemNameOfFileNm + "_" + formatter.format(date) + ".docx";
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

