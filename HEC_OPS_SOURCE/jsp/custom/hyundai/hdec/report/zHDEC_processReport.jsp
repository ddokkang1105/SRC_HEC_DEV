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
 	String outputType = String.valueOf(request.getAttribute("outputType"));
 	
 	Map e2eModelMap = (Map)request.getAttribute("e2eModelMap");
 	Map e2eItemInfo = (Map)request.getAttribute("e2eItemInfo");
 	Map e2eAttrMap = (Map)request.getAttribute("e2eAttrMap");
 	Map e2eAttrNameMap = (Map)request.getAttribute("e2eAttrNameMap");
 	Map e2eAttrHtmlMap = (Map)request.getAttribute("e2eAttrHtmlMap");
 	
 	Map piItemInfo = (Map)request.getAttribute("piItemInfo");
 	Map piAttrMap = (Map)request.getAttribute("piAttrMap");
 	Map piAttrNameMap = (Map)request.getAttribute("piAttrNameMap");
 	Map piAttrHtmlMap = (Map)request.getAttribute("piAttrHtmlMap");
 	
 	List e2eDimResultList = (List)request.getAttribute("e2eDimResultList");
 	
 	List lowLankItemIdList = (List)request.getAttribute("lowLankItemIdList");
 	String selectedItemPath = String.valueOf(request.getAttribute("selectedItemPath"));
 	String reportCode = String.valueOf(request.getAttribute("reportCode"));
 	double titleCellWidth = 60.0;
 	double contentCellWidth3 = 90.0;
	double contentCellWidth = 165.0;
	double mergeCellWidth = 500.0;
	double totalCellWidth = 560.0;
	String value = "";
	String name = "";
	String fontFamilyHtml = "<span style=\"font-family:"+defaultFont+"; font-size: 10pt;\">";
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
    builder.getCellFormat().setWidth(200.0);
    builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
    String imageFileName = logoPath + "logo_HMAP.png";
    String imageFileName2 = logoPath + "logo_footer.png";
    builder.insertImage(imageFileName2, 125, 25);
 	// 3.footer : current page / total page 
    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
    builder.insertCell();
    builder.getCellFormat().setWidth(200.0);
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
    builder.getCellFormat().setWidth(200.0);
    builder.write("수행체계혁신 TFT");
    
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
		}else{
			titleItemMap = (Map)allTotalMap.get("titleItemMap");
		}
		
		//==================================================================================================
		/* 표지 */
		//if (totalList.size() > 0) { 
			currentSection = builder.getCurrentSection();
		    pageSetup = currentSection.getPageSetup();
		    pageSetup.setDifferentFirstPageHeaderFooter(true);
		   // pageSetup.setD
		 	// 표지 START
		 	builder.startTable();
		 	builder.getCellFormat().getBorders().setLineWidth(0.0);
		 	
		 	// 1.image
		 	builder.insertCell();
    		builder.getCellFormat().setWidth(totalCellWidth);
		 	builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		 	builder.insertHtml("<br>");
    	//	builder.insertImage(imageFileName, 180, 36);
    		builder.insertHtml("<br>");
    		builder.endRow();
    		
    		// 2.프로세스 정의서
    		builder.insertCell();
    		builder.getFont().setColor(Color.BLACK);
		    builder.getFont().setBold(true);
		    builder.getFont().setName(defaultFont);
		    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		    builder.getFont().setSize(60);
		    builder.insertHtml("<br>");
		    builder.getFont().setSize(36);
		    if (!e2eModelMap.isEmpty()) {
		    	builder.writeln("E2E 프로세스 정의서");
		    }else if(reportCode.equals("RP00031")){
		    	builder.writeln("PI 과제 정의서");
		    } else {
		    	builder.writeln("Process Definition Report");
		    }
			builder.endRow();
			
			// 3.선택한 L2 프로세스 정보
    		builder.insertCell();
    		builder.getFont().setColor(Color.BLACK);
		    builder.getFont().setBold(true);
		    builder.getFont().setName(defaultFont);
		    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		    builder.getFont().setSize(26);
		    builder.getFont().setUnderline(0);
			builder.writeln("["+selectedItemPath+"]");
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
    		builder.getCellFormat().setWidth(totalCellWidth);
    		
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
			
			builder.getCellFormat().setWidth(120);
			builder.write(String.valueOf(menu.get("LN00060"))); // 작성자

			builder.insertCell();
			builder.getCellFormat().setWidth(200);
			builder.write(String.valueOf(menu.get("LN00131"))); // 프로젝트

			builder.insertCell();
			builder.getCellFormat().setWidth(100);
			builder.write(String.valueOf(menu.get("LN00013"))); // 생성일
			
			builder.endRow();
			
			// Set features for the other rows and cells.
			builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			
			// Reset height and define a different height rule for table body
			builder.getRowFormat().setHeight(30.0);
			builder.getRowFormat().setHeightRule(HeightRule.AUTO);
			
			builder.insertCell();
		   	builder.getCellFormat().setWidth(120);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(StringUtil.checkNullToBlank(titleItemMap.get("Name")));				
			builder.insertCell();
		   	builder.getCellFormat().setWidth(200);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write("수행체계혁신 TFT");
			builder.insertCell();
		   	builder.getCellFormat().setWidth(100);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(StringUtil.checkNullToBlank(titleItemMap.get("CreateDT")));	
			builder.endRow();
			builder.endTable().setAlignment(TabAlignment.CENTER);
			builder.endRow();
			
			builder.endTable().setAllowAutoFit(false);
    		///////////////////////////////////////////////////////////////////////////////////////
    		// 표지 END
		    builder.insertBreak(BreakType.PAGE_BREAK);
    		if (lowLankItemIdList.size() > 0) { 
    			// content START	
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
	 	 		
	 	 	 	// 1.ROW : 개요
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(e2eAttrNameMap.get("AT00003")));  // 개요
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(mergeCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		String E2EAT00003 = StringUtil.checkNullToBlank(e2eAttrMap.get("AT00003")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("/upload", logoPath);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(e2eAttrHtmlMap.get("AT00003")))) { // type이 HTML인 경우
	 	 			if(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00003")).contains("font-family")){
	 	 				builder.insertHtml(E2EAT00003);
	 	 			}else{
	 	 				builder.insertHtml(fontFamilyHtml+E2EAT00003+"</span>");
	 	 			}
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(E2EAT00003); // 개요 : 내용
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
	 	 		builder.write(String.valueOf(e2eAttrNameMap.get("AT00020")));  //  Module
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		String E2EAT00020 = StringUtil.checkNullToBlank(e2eAttrMap.get("AT00020")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("/upload", logoPath);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(e2eAttrHtmlMap.get("AT00020")))) { // type이 HTML인 경우
	 	 			if(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00020")).contains("font-family")){
	 	 				builder.insertHtml(E2EAT00020);
	 	 			}else{
	 	 				builder.insertHtml(fontFamilyHtml+E2EAT00020+"</span>");
	 	 			}
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(E2EAT00020); // Main Module : 내용
	 	 		}
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(e2eAttrNameMap.get("AT00072")));  // 
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		
	 	 		String E2EAT00072 = StringUtil.checkNullToBlank(e2eAttrMap.get("AT00072")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("/upload", logoPath);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(e2eAttrHtmlMap.get("AT00072")))) { // type이 HTML인 경우
	 	 			if(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00072")).contains("font-family")){
	 	 				builder.insertHtml(E2EAT00072);
	 	 			}else{
	 	 				builder.insertHtml(fontFamilyHtml+E2EAT00072+"</span>");
	 	 			}
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(E2EAT00072); // 연관 모듈 : 내용
	 	 		}
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 		// 3.ROW
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
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
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(e2eAttrNameMap.get("AT00018")));  // Due date
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		
	 	 		String E2EAT00018 = StringUtil.checkNullToBlank(e2eAttrMap.get("AT00018")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("/upload", logoPath);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(e2eAttrHtmlMap.get("AT00018")))) { // type이 HTML인 경우
	 	 			if(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00018")).contains("font-family")){
	 	 				builder.insertHtml(E2EAT00018);
	 	 			}else{
	 	 				builder.insertHtml(fontFamilyHtml+E2EAT00018+"</span>");
	 	 			}
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(E2EAT00018); // Due date : 내용
	 	 		}
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 		// 4.ROW
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
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
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
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
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(e2eAttrNameMap.get("AT00006")));  // 비고
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(mergeCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		
	 	 		String E2EAT00006 = StringUtil.checkNullToBlank(e2eAttrMap.get("AT00006")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("/upload", logoPath);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(e2eAttrHtmlMap.get("AT00006")))) { // type이 HTML인 경우
	 	 			if(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00006")).contains("font-family")){
	 	 				builder.insertHtml(E2EAT00006);
	 	 			}else{
	 	 				builder.insertHtml(fontFamilyHtml+E2EAT00006+"</span>");
	 	 			}
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
		 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
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
			// E2E 기본정보 END
		
			// PI 과제기본정보 */
			if(reportCode.equals("RP00031")){ 
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
			   	name = StringUtil.checkNullToBlank(piItemInfo.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
			   	name = name.replace("&#10;", " ");
			   	name = name.replace("&#xa;", "");
			   	name = name.replace("&nbsp;", " ");
			    builder.write("PI 과제 : " + StringUtil.checkNullToBlank(piItemInfo.get("Identifier")) + " "+ name);
			   
			    builder.getFont().setName(defaultFont);
			    builder.getFont().setColor(Color.LIGHT_GRAY);
			    builder.getFont().setSize(12);
			    
			    builder.insertCell();
				builder.getCellFormat().getBorders().setColor(Color.WHITE);
				builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				builder.getParagraphFormat().setAlignment(ParagraphAlignment.RIGHT);
				String path = String.valueOf(piItemInfo.get("Path"));
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
			  	// PI과제 기본정보 표시
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
	 	 		builder.write(String.valueOf(piAttrNameMap.get("AT00003")));  // PI 개요
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(mergeCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		
	 	 		String PIAT00003 = StringUtil.checkNullToBlank(piAttrMap.get("AT00003")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("/upload", logoPath);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(piAttrHtmlMap.get("AT00003")))) { // type이 HTML인 경우
	 	 			if(StringUtil.checkNullToBlank(piAttrMap.get("AT00003")).contains("font-family")){
	 	 				builder.insertHtml(PIAT00003);
	 	 			}else{
	 	 				builder.insertHtml(fontFamilyHtml+PIAT00003+"</span>");
	 	 			}
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(PIAT00003); // PI 개요 : 내용
	 	 		}
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 		// 2.ROW : 비고
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(piAttrNameMap.get("AT00006")));  // PI 비고
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(mergeCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		
	 	 		String PIAT00006 = StringUtil.checkNullToBlank(piAttrMap.get("AT00006")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("/upload", logoPath);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(piAttrHtmlMap.get("AT00006")))) { // type이 HTML인 경우
	 	 			if(StringUtil.checkNullToBlank(piAttrMap.get("AT00006")).contains("font-family")){
	 	 				builder.insertHtml(PIAT00006);
	 	 			}else{
	 	 				builder.insertHtml(fontFamilyHtml+PIAT00006+"</span>");
	 	 			}
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(PIAT00006); // PI 비고 : 내용
	 	 		}
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 		builder.getRowFormat().clearFormatting();
				builder.getCellFormat().clearFormatting();
				builder.getRowFormat().setHeight(30.0);
	 	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경
	 	 		
	 	 		// 3.ROW
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
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
		 		builder.write(StringUtil.checkNullToBlank(piItemInfo.get("Name"))); // 작성자 : 내용
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(piAttrNameMap.get("AT00022")));  // PI 담당자
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		
	 	 		String PIAT00022 = StringUtil.checkNullToBlank(piAttrMap.get("AT00022")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("/upload", logoPath);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(piAttrHtmlMap.get("AT00022")))) { // type이 HTML인 경우
	 	 			if(StringUtil.checkNullToBlank(piAttrMap.get("AT00022")).contains("font-family")){
	 	 				builder.insertHtml(PIAT00022);
	 	 			}else{
	 	 				builder.insertHtml(fontFamilyHtml+PIAT00022+"</span>");
	 	 			}
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(PIAT00022); 
	 	 		}
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 		// 4.ROW
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
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
		 		builder.write(StringUtil.checkNullToBlank(piItemInfo.get("CreateDT"))); // 생성일 : 내용
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
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
	 	 		builder.write(StringUtil.checkNullToBlank(piItemInfo.get("LastUpdated"))); // 수정일 : 내용
	 	 		builder.endRow();
	 	 		//==================================================================================================
	 	 				
	 	 		// 5.ROW : 오너조직, Owner
 	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(piAttrNameMap.get("AT00033"))); // 오너조직
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		
	 	 		String PIAT00033 = StringUtil.checkNullToBlank(piAttrMap.get("AT00033")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("/upload", logoPath);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(piAttrHtmlMap.get("AT00033")))) { // type이 HTML인 경우
	 	 			if(StringUtil.checkNullToBlank(piAttrMap.get("AT00033")).contains("font-family")){
	 	 				builder.insertHtml(PIAT00033);
	 	 			}else{
	 	 				builder.insertHtml(fontFamilyHtml+PIAT00033+"</span>");
	 	 			}
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(PIAT00033); // 오너조직 : 내용
	 	 		}
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(piAttrNameMap.get("AT00012"))); // 오너
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		
	 	 		String PIAT00012 = StringUtil.checkNullToBlank(piAttrMap.get("AT00012")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("/upload", logoPath);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(piAttrHtmlMap.get("AT00012")))) { // type이 HTML인 경우
	 	 			if(StringUtil.checkNullToBlank(piAttrMap.get("AT00012")).contains("font-family")){
	 	 				builder.insertHtml(PIAT00012);
	 	 			}else{
	 	 				builder.insertHtml(fontFamilyHtml+PIAT00012+"</span>");
	 	 			}
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(PIAT00012); // 오너
	 	 		}
	 	 		builder.endRow();
	 	 		//==================================================================================================
	 	 		
	 	 		builder.endTable().setAllowAutoFit(false);
	 	 		builder.writeln();
			  	
			  	
			}			
		//} 
		// PI 과제기본정보 END */
		//==================================================================================================
		if (totalList.size() > 0) { 
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
	 		List requirementList = (List)totalMap.get("requirementList");
	 		List positionList = (List)totalMap.get("positionList");
	 		List knowledgeList = (List)totalMap.get("knowledgeList");
	 		List companyRuleList = (List)totalMap.get("companyRuleList");	 		
	 		
	 		List attachFileList = (List)totalMap.get("attachFileList");
	 		List toCheckList = (List)totalMap.get("toCheckList");
	 		Map attrMap = (Map)totalMap.get("attrMap");
	 		Map attrNameMap = (Map)totalMap.get("attrNameMap");
	 		Map attrHtmlMap = (Map)totalMap.get("attrHtmlMap");
	 		Map modelMap = (Map)totalMap.get("modelMap");
	 		Map attrRsNameMap = (Map)totalMap.get("attrRsNameMap");
	 		Map attrRsHtmlMap = (Map)totalMap.get("attrRsHtmlMap");
	 		Map attrToCheckNameMap = (Map)totalMap.get("attrToCheckNameMap");
	 		Map attrToCheckHtmlMap = (Map)totalMap.get("attrToCheckHtmlMap");
	 		
	 		currentSection = builder.getCurrentSection();
	 	    pageSetup = currentSection.getPageSetup();
	 	    
	 	    pageSetup.setDifferentFirstPageHeaderFooter(false);
	 	    pageSetup.setHeaderDistance(25);
	 	    builder.moveToHeaderFooter(HeaderFooterType.HEADER_PRIMARY);
	 	    
	 	    //==================================================================================================
	 		// NEW 머릿글 : START
	 	    builder.startTable();
			builder.getRowFormat().clearFormatting();
			builder.getCellFormat().clearFormatting();
			
			// Make the header row.
			builder.insertCell();
			builder.getCellFormat().setWidth(totalCellWidth);
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
			
			builder.getCellFormat().setWidth(140);
			builder.getCellFormat().setVerticalMerge(CellMerge.FIRST);
			//builder.insertCell();
    		builder.insertImage(imageFileName, 125, 25);

			builder.insertCell();
			builder.getCellFormat().setWidth(420);
			name = StringUtil.checkNullToBlank(rowPrcData.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
	 	   	name = name.replace("&#10;", " ");
	 	   	name = name.replace("&#xa;", "");
	 	    name = name.replace("&nbsp;", " ");
	 	    builder.write("Process definition report"); 
	 	  //  builder.write(rowPrcData.get("Identifier") + " "+ name);  	
			
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
		    builder.getCellFormat().setWidth(140);
			builder.getCellFormat().setVerticalMerge(CellMerge.PREVIOUS);
			
			builder.insertCell();
		   	builder.getCellFormat().setWidth(180);builder.getCellFormat().setVerticalMerge(CellMerge.NONE);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(rowPrcData.get("Identifier") + " "+ name);  
    		
			builder.insertCell();
		   	builder.getCellFormat().setWidth(240);builder.getCellFormat().setVerticalMerge(CellMerge.NONE);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(StringUtil.checkNullToBlank(rowPrcData.get("Path")));
			builder.endRow();
			
			builder.endTable().setAllowAutoFit(false);
			 // 타이틀과 내용 사이 간격
	 	    builder.insertHtml("<hr size=4 color='silver'/>");
	 	 	// 머릿말 : END
	 	 	builder.moveToDocumentEnd();
	 	  	//==================================================================================================
	 	  		
	 		// 아이템 속성 		
	 		if ("N".equals(onlyMap)) {
	 			// 프로세스 기본 정보 Title
	 	 		builder.getFont().setColor(Color.DARK_GRAY);
			    builder.getFont().setSize(11);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
				builder.writeln("1. " + String.valueOf(menu.get("LN00005")));
				
	 			builder.startTable();
	 	 		
	 	 	    builder.getFont().setName(defaultFont);
	 	 	    builder.getFont().setColor(Color.BLACK);
	 	 	    builder.getFont().setSize(10);
	 	 		
	 	 		// Make the header row.
	 	 		builder.getRowFormat().clearFormatting();
	 	 		builder.getCellFormat().clearFormatting();
	 	 		builder.getRowFormat().setHeight(250.0);
	 	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경
	 	 		
	 	 	 	// 1.ROW : 개요
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(attrNameMap.get("AT00003")));  // 개요
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(mergeCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		
	 	 		String AT00003 = StringUtil.checkNullToBlank(attrMap.get("AT00003")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("/upload", logoPath);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00003")))) { // type이 HTML인 경우
	 	 			if(StringUtil.checkNullToBlank(attrMap.get("AT00003")).contains("font-family")){
	 	 				builder.insertHtml(AT00003);
	 	 			}else{
	 	 				builder.insertHtml(fontFamilyHtml+AT00003+"</span>");
	 	 			}
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(AT00003); // 개요 : 내용
	 	 		}
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 	// 2.ROW : 적용범위
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getRowFormat().setHeight(30.0);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(attrNameMap.get("AT00008")));  // 적용범위
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(mergeCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		
 	 			builder.getFont().setBold(false);
 	 			String AT00008 = StringUtil.checkNullToBlank(attrMap.get("AT00008")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("/upload", logoPath);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00008")))) { // type이 HTML인 경우
	 	 			if(StringUtil.checkNullToBlank(attrMap.get("AT00008")).contains("font-family")){
	 	 				builder.insertHtml(AT00008);
	 	 			}else{
	 	 				builder.insertHtml(fontFamilyHtml+AT00008+"</span>");
	 	 			}
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00008"))); // 적용범위 : 내용
	 	 		}
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 		// 3.ROW : 검색어
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getRowFormat().setHeight(30.0);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(attrNameMap.get("AT00005")));  // 검색어
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(mergeCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		
 	 			builder.getFont().setBold(false);
 	 			String AT00005 = StringUtil.checkNullToBlank(attrMap.get("AT00005")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("/upload", logoPath);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00005")))) { // type이 HTML인 경우
	 	 			if(StringUtil.checkNullToBlank(attrMap.get("AT00005")).contains("font-family")){
	 	 				builder.insertHtml(AT00008);
	 	 			}else{
	 	 				builder.insertHtml(fontFamilyHtml+AT00008+"</span>");
	 	 			}
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00005"))); // 검색어 : 내용
	 	 		}
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 		
	 	 		// 4.ROW : 비고
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getRowFormat().setHeight(30.0);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(attrNameMap.get("AT00006")));  // 비고
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(mergeCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		
 	 			builder.getFont().setBold(false);
 	 			String AT00006 = StringUtil.checkNullToBlank(attrMap.get("AT00006")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("/upload", logoPath);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00006")))) { // type이 HTML인 경우
	 	 			if(StringUtil.checkNullToBlank(attrMap.get("AT00006")).contains("font-family")){
	 	 				builder.insertHtml(AT00006);
	 	 			}else{
	 	 				builder.insertHtml(fontFamilyHtml+AT00008+"</span>");
	 	 			}
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00006"))); // 검색어 : 내용
	 	 		}
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
	 	 		builder.write(StringUtil.checkNullToBlank(rowPrcData.get("Name"))); // 작성자 : 내용
	 	 		
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
		 		builder.write(StringUtil.checkNullToBlank(rowPrcData.get("LastUpdated"))); // 수정일 : 내용
	 	 		//==================================================================================================	
	 	 		builder.endRow(); 	 		
	 	 	
	 	 				
	 	 		// 11.ROW (Dimension 정보 만큼 행 표시)
	 	 		for(int j=0; j<dimResultList.size(); j++){
	 	 			Map dimResultMap = (Map) dimResultList.get(j);
		 	 		
	 	 			builder.insertCell();
		 	 		//==================================================================================================	
		 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
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
	 	 		
	 	 		builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
	 	 		
	 	 		// 2. 선/후행 프로세스
	 	 		builder.getFont().setColor(Color.DARK_GRAY);
			    builder.getFont().setSize(11);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
				builder.writeln("2. " + String.valueOf(menu.get("LN00178"))+"Process");
				
		 		if (elementList.size() > 0) {
		 			Map cnProcessData = new HashMap();
			 		
					builder.startTable();			
					builder.getRowFormat().clearFormatting();
					builder.getCellFormat().clearFormatting();
					
					// Make the header row.
					builder.insertCell();
					builder.getRowFormat().setHeight(20.0);
					builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
					
					// Some special features for the header row.
					builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					builder.getFont().setSize(10);
					builder.getFont().setBold (true);
					builder.getFont().setColor(Color.BLACK);
					builder.getFont().setName(defaultFont);
					
					builder.getCellFormat().setWidth(25);
					builder.write(String.valueOf(menu.get("LN00024"))); // No

					builder.insertCell();
					builder.getCellFormat().setWidth(50);
					builder.write(String.valueOf(menu.get("LN00042"))); // 구분

					builder.insertCell();
					builder.getCellFormat().setWidth(70);
					builder.write(String.valueOf(menu.get("LN00106"))); // ID

					builder.insertCell();
					builder.getCellFormat().setWidth(140);
					builder.write(String.valueOf(menu.get("LN00028"))); // 명칭

					builder.insertCell();
					builder.getCellFormat().setWidth(300);
					builder.write(String.valueOf(menu.get("LN00035"))); // 개요
					builder.endRow();	
					
					// Set features for the other rows and cells.
					builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					
					// Reset height and define a different height rule for table body
					builder.getRowFormat().setHeight(30.0);
					builder.getRowFormat().setHeightRule(HeightRule.AUTO);
					
					for(int j=0; j<elementList.size(); j++){
						cnProcessData = (HashMap) elementList.get(j);
					    
				    	builder.insertCell();
					    if( j==0){
					    	// Reset font formatting.
					    	builder.getFont().setBold(false);
					    }
					    
						String itemName = StringUtil.checkNullToBlank(cnProcessData.get("Name")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
						itemName = itemName.replace("&#10;", " ");
						itemName = itemName.replace("&#xa;", "");
						itemName = itemName.replace("&nbsp;", " ");
						String processInfo = StringUtil.checkNullToBlank(cnProcessData.get("Description")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");;
						processInfo = processInfo.replace("&#10;", " ");
						processInfo = processInfo.replace("&#xa;", "");
						processInfo = processInfo.replace("&nbsp;", " ");
						builder.getCellFormat().setWidth(25);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					   	builder.write(StringUtil.checkNullToBlank(cnProcessData.get("RNUM")));	
						
					   	builder.insertCell();
					   	builder.getCellFormat().setWidth(50);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.write(StringUtil.checkNullToBlank(cnProcessData.get("KBN")));				
						builder.insertCell();
					   	builder.getCellFormat().setWidth(70);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.write(StringUtil.checkNullToBlank(cnProcessData.get("ID")));				
						builder.insertCell();
					   	builder.getCellFormat().setWidth(140);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						builder.write(itemName);				
						builder.insertCell();
						builder.getCellFormat().setWidth(300);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						builder.insertHtml(processInfo);
						
						builder.endRow();
					}	
					
					builder.endTable().setAllowAutoFit(false);	
		 		}
		 							
				//==================================================================================================
		 		//4. KPI		
		 		builder.insertHtml("<br>");
		 		builder.getFont().setColor(Color.DARK_GRAY);
			    builder.getFont().setSize(11);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
				builder.writeln("3.직무");
				builder.insertHtml("<br>");
				if (positionList.size() > 0) {
					Map rowCnData = new HashMap();
					builder.startTable();
					builder.getRowFormat().clearFormatting();
					builder.getCellFormat().clearFormatting();
					
					// Set features for the other rows and cells.
					builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
					builder.getCellFormat().setWidth(100.0);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					
					// Reset height and define a different height rule for table body
					builder.getRowFormat().setHeight(30.0);
					builder.getRowFormat().setHeightRule(HeightRule.AUTO);
				
					for(int j=0; j<positionList.size(); j++){
						rowCnData = (HashMap) positionList.get(j);
						List positionSubList = (List)rowCnData.get("resultSubList");
						// 1.ROW
						builder.insertCell();
						builder.getRowFormat().setHeight(30.0);
						builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
						
						//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold(true);
			 	 		builder.write(String.valueOf(menu.get("LN00106"))); // ID
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getFont().setBold(false);
				 		builder.write(StringUtil.checkNullToBlank(rowCnData.get("fromItemIdentifier"))); // ID : 내용
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(menu.get("LN00028")));  // 명칭
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getFont().setBold(false);
		 	 			builder.write(StringUtil.checkNullToBlank(rowCnData.get("fromItemName"))); // 명칭 : 내용
			 	 		//==================================================================================================	
			 	 		builder.endRow();
		 	 			
			 	 		builder.getRowFormat().clearFormatting();
						builder.getCellFormat().clearFormatting();
						builder.getRowFormat().setHeight(50.0);
						builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
		 	 			
			 	 		// 2.ROW
						builder.insertCell();
			 	 		//==================================================================================================	
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
			 	 		
			 	 		String KPIAT00003 = StringUtil.checkNullToBlank(rowCnData.get("fromItemDescription")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("/upload", logoPath);
			 	 		if ("1".equals(StringUtil.checkNullToBlank(attrRsHtmlMap.get("AT00003")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(rowCnData.get("AT00003")).contains("font-family")){
			 	 				builder.insertHtml(KPIAT00003);
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+KPIAT00003+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(rowCnData.get("AT00003"))); // 개요 : 내용
			 	 		}
			 	 		//==================================================================================================	
			 	 		builder.endRow();	
			 	 		builder.endTable().setAllowAutoFit(false);
			 	 		builder.insertHtml("<br>");
					}	 
				
				} 
				//==================================================================================================	
						
		 		//==================================================================================================
		 		// 4.Rule set
		 		builder.insertHtml("<br>");
	 	 		builder.getFont().setColor(Color.DARK_GRAY);
			    builder.getFont().setSize(11);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
				builder.writeln("4.표준");
				builder.insertHtml("<br>");				
				if (companyRuleList.size() > 0) {
					Map rowCnData = new HashMap();
					
					builder.getFont().setSize(10);
					//builder.getFont().setBold (true);
					builder.getFont().setColor(Color.BLACK);
					builder.getFont().setName(defaultFont);
					
					for(int j=0; j<companyRuleList.size(); j++){						
						rowCnData = (HashMap) companyRuleList.get(j);			 		
						builder.startTable();
						builder.getRowFormat().clearFormatting();
						builder.getCellFormat().clearFormatting();
						
						// 1.ROW
						builder.insertCell();
						builder.getRowFormat().setHeight(30.0);
						builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
						
						//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold(true);
			 	 		builder.write(String.valueOf(menu.get("LN00106"))); // ID
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getFont().setBold(false);
				 		builder.write(StringUtil.checkNullToBlank(rowCnData.get("toItemIdentifier"))); // ID : 내용
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(menu.get("LN00028")));  // 명칭
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getFont().setBold(false);
		 	 			builder.write(StringUtil.checkNullToBlank(rowCnData.get("toItemName"))); // 명칭 : 내용
			 	 		//==================================================================================================	
			 	 		builder.endRow();
		 	 			
			 	 		builder.getRowFormat().clearFormatting();
						builder.getCellFormat().clearFormatting();
						builder.getRowFormat().setHeight(50.0);
						builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
		 	 			
						// 2.ROW
						builder.insertCell();
			 	 		//==================================================================================================	
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
			 	 		
			 	 		String RSAT00003 = StringUtil.checkNullToBlank(rowCnData.get("toItemDescription")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("/upload", logoPath);
			 	 		if ("1".equals(StringUtil.checkNullToBlank(attrRsHtmlMap.get("AT00003")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(rowCnData.get("AT00003")).contains("font-family")){
			 	 				builder.insertHtml(RSAT00003);
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+RSAT00003+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(rowCnData.get("AT00003"))); // 개요 : 내용
			 	 		}
			 	 		//==================================================================================================	
			 	 		builder.endRow();
			 	 		
			 	 					 	 		
			 	 		// 2.ROW
						/* builder.insertCell();
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(attrRsNameMap.get("AT00021")));  // IT 요구사항
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(mergeCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		
			 	 		String RSAT00021 = StringUtil.checkNullToBlank(rowCnData.get("AT00021")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("/upload", logoPath);
			 	 		if ("1".equals(StringUtil.checkNullToBlank(attrRsHtmlMap.get("AT00021")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(rowCnData.get("AT00021")).contains("font-family")){
			 	 				builder.insertHtml(RSAT00021);
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+RSAT00021+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(rowCnData.get("AT00021"))); // IT 요구사항: 내용
			 	 		}
			 	 		//==================================================================================================	
			 	 		builder.endRow();	 */					
						builder.endTable().setAllowAutoFit(false);	
						builder.insertHtml("<br>");
					}	
					
				} 
				//==================================================================================================
							
				//==================================================================================================
		 		//5. 관련지식	Process/Knowledge	
		 		builder.insertHtml("<br>");
		 		builder.getFont().setColor(Color.DARK_GRAY);
			    builder.getFont().setSize(11);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
				builder.writeln("5.관련지식");
				builder.insertHtml("<br>");
				if (knowledgeList.size() > 0) {
					Map rowCnData = new HashMap();
					builder.startTable();
					builder.getRowFormat().clearFormatting();
					builder.getCellFormat().clearFormatting();
					
					// Set features for the other rows and cells.
					builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
					builder.getCellFormat().setWidth(100.0);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					
					// Reset height and define a different height rule for table body
					builder.getRowFormat().setHeight(30.0);
					builder.getRowFormat().setHeightRule(HeightRule.AUTO);
				
					for(int j=0; j<knowledgeList.size(); j++){
						rowCnData = (HashMap) knowledgeList.get(j);
						List knowledgeSubList = (List)rowCnData.get("knowledgeSubList");
						// 1.ROW
						builder.insertCell();
						builder.getRowFormat().setHeight(30.0);
						builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
						
						//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold(true);
			 	 		builder.write(String.valueOf(menu.get("LN00106"))); // ID
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getFont().setBold(false);
				 		builder.write(StringUtil.checkNullToBlank(rowCnData.get("toItemIdentifier"))); // ID : 내용
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(menu.get("LN00028")));  // 명칭
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getFont().setBold(false);
		 	 			builder.write(StringUtil.checkNullToBlank(rowCnData.get("toItemName"))); // 명칭 : 내용
			 	 		//==================================================================================================	
			 	 		builder.endRow();
		 	 			
			 	 		builder.getRowFormat().clearFormatting();
						builder.getCellFormat().clearFormatting();
						builder.getRowFormat().setHeight(50.0);
						builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
		 	 			
			 	 		// 2.ROW
						builder.insertCell();
			 	 		//==================================================================================================	
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
			 	 		
			 	 		String KPIAT00003 = StringUtil.checkNullToBlank(rowCnData.get("toItemDescription")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("/upload", logoPath);
			 	 		if ("1".equals(StringUtil.checkNullToBlank(attrRsHtmlMap.get("AT00003")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(rowCnData.get("AT00003")).contains("font-family")){
			 	 				builder.insertHtml(KPIAT00003);
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+KPIAT00003+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(rowCnData.get("AT00003"))); // 개요 : 내용
			 	 		}
			 	 		//==================================================================================================	
			 	 		builder.endRow();	
			 	 		builder.endTable().setAllowAutoFit(false);
			 	 		builder.insertHtml("<br>");
					}	 
				
				} 
				//==================================================================================================
				
		 		// 5. 첨부문서
		 		/* builder.insertHtml("<br>");
	 	 		builder.getFont().setColor(Color.DARK_GRAY);
			    builder.getFont().setSize(11);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
				builder.writeln("5. " + String.valueOf(menu.get("LN00019")));
				
				if (attachFileList.size() > 0) {
					Map rowCnData = new HashMap();
			 		
					builder.startTable();
					builder.getRowFormat().clearFormatting();
					builder.getCellFormat().clearFormatting();
					
					// Make the header row.
					builder.insertCell();
					builder.getRowFormat().setHeight(20.0);
					builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
					
					// Some special features for the header row.
					builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					builder.getFont().setSize(10);
					builder.getFont().setBold (true);
					builder.getFont().setColor(Color.BLACK);
					builder.getFont().setName(defaultFont);
					
					builder.getCellFormat().setWidth(20.0);
					builder.write(String.valueOf(menu.get("LN00024"))); // No
					builder.insertCell();
					builder.getCellFormat().setWidth(120.0);
					builder.write(String.valueOf(menu.get("LN00091"))); // 문서유형
					builder.insertCell();
					builder.getCellFormat().setWidth(210.0);
					builder.write(String.valueOf(menu.get("LN00101"))); // 문서명
					builder.insertCell();
					builder.getCellFormat().setWidth(80.0);
					builder.write(String.valueOf(menu.get("LN00070"))); // 수정일
					builder.endRow();	
					
					// Set features for the other rows and cells.
					builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
					builder.getCellFormat().setWidth(100.0);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					
					// Reset height and define a different height rule for table body
					builder.getRowFormat().setHeight(30.0);
					builder.getRowFormat().setHeightRule(HeightRule.AUTO);
					
					
					for(int j=0; j<attachFileList.size(); j++){
						rowCnData = (HashMap) attachFileList.get(j);
					    
				    	builder.insertCell();
					    if( j==0){
					    	// Reset font formatting.
					    	builder.getFont().setBold(false);
					    }
					    
					    builder.getCellFormat().setWidth(20.0);
					   	builder.write(StringUtil.checkNullToBlank(rowCnData.get("RNUM")));
					   	builder.insertCell();
					   	builder.getCellFormat().setWidth(120.0);
					   	builder.write(StringUtil.checkNullToBlank(rowCnData.get("FltpName")));
						builder.insertCell();
						builder.getCellFormat().setWidth(210.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						builder.write(StringUtil.checkNullToBlank(rowCnData.get("FileRealName"))); 
						builder.insertCell();
						builder.getCellFormat().setWidth(80.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.write(StringUtil.checkNullToBlank(rowCnData.get("LastUpdated")));
						builder.endRow();
					}	
					builder.endTable().setAllowAutoFit(false);	
				} */
				//==================================================================================================
		 		
				//if (null != modelMap) {
		 			builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
		 		//}
		 		
		 		// 7.업무처리 절차 Title
		 		if (null == modelMap) {
		 			builder.insertHtml("<br>");
		 		}
		 		builder.getFont().setColor(Color.DARK_GRAY);
			    builder.getFont().setSize(11);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
				builder.writeln("6. " + String.valueOf(menu.get("LN00197")));
				
	 	 		if (null != modelMap) {
	 	 		//==================================================================================================
	 		 		//프로세스 맵
	 		 	 	builder.startTable();
	 		 	 	builder.insertCell();
	 		 	 	builder.getRowFormat().clearFormatting();
	 		 		builder.getCellFormat().clearFormatting();
	 		 		builder.getRowFormat().setHeight(20.0);
	 		 		builder.getRowFormat().setHeightRule(HeightRule.AUTO);
	 		 	 	builder.getCellFormat().setWidth(totalCellWidth);
	 		 	 	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 		 	 	
	 		 		String imgLang = "_"+StringUtil.checkNull(setMap.get("langCode"));
	 		 		String imgPath = modelImgPath+modelMap.get("ModelID")+imgLang+"."+GlobalVal.MODELING_DIGM_IMG_TYPE;
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
		 		
		 		// 액티비티리스트
		 		// Build the other cells.
		 		// 액티비티리스트나 연관항목중 한건이라도 존재하면 새로운 페이지를 추가한다
		 		//if (activityList.size() > 0 || cnitemList.size() > 0) {
		 			builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
		 		//}
				
		 		// 7.액티비티 리스트 Title
		 		if (activityList.size() == 0) {
		 			builder.insertHtml("<br>");
		 		}
		 		builder.getFont().setColor(Color.DARK_GRAY);
			    builder.getFont().setSize(11);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
				builder.writeln("7. " + String.valueOf(menu.get("LN00151")));
				builder.insertHtml("<br>");
				if (activityList.size() > 0) {
					Map rowActData = new HashMap();	
					for(int j=0; j<activityList.size(); j++){
						rowActData = (HashMap) activityList.get(j);
						
						builder.getFont().setColor(Color.DARK_GRAY);
					    builder.getFont().setSize(11);
					    builder.getFont().setBold(true);
					    builder.getFont().setName(defaultFont);
					    
					    String identifier =  StringUtil.checkNullToBlank(rowActData.get("Identifier"));
					    String itemName = StringUtil.checkNullToBlank(rowActData.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
					    itemName = itemName.replace("&#10;", " ");
						itemName = itemName.replace("&#xa;", "");
						itemName = itemName.replace("&nbsp;", " ");
					    builder.writeln(identifier+" "+itemName); //명칭
					    builder.insertHtml("<br>");
						builder.writeln("[Description]");// GuideLine
						builder.getFont().setBold(false);
		 	 			
						String ATVITAT00003 = StringUtil.checkNullToBlank(rowActData.get("AT00003")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("/upload", logoPath);
						if(StringUtil.checkNullToBlank(rowActData.get("AT00003")).contains("font-family")){	
							builder.insertHtml(ATVITAT00003);
		 	 			}else{
		 	 				builder.insertHtml(fontFamilyHtml+ATVITAT00003+"</span>");
		 	 			}			 	 
						builder.insertHtml("<br>");
						
						builder.getFont().setBold(true);
						builder.writeln("[Rule]");
						builder.getFont().setBold(false);
						List actRuleSetList = (List)rowActData.get("actRuleSetList");
						if (actRuleSetList.size() > 0) {
							Map rowActRuleSetData = new HashMap();
							for(int m=0; m<actRuleSetList.size(); m++){
								rowActRuleSetData = (HashMap)actRuleSetList.get(m);							
								builder.writeln(StringUtil.checkNullToBlank(rowActRuleSetData.get("toItemIdentifier")) +" "+ StringUtil.checkNullToBlank(rowActRuleSetData.get("toItemName"))); // toItemDescription
							}
						}			
						builder.insertHtml("<br>");
						
						builder.getFont().setBold(true);
						builder.writeln("[To-Check]"); 
						builder.getFont().setBold(false);
						List actToCheckList = (List)rowActData.get("actToCheckList"); 
						if (actToCheckList.size() > 0) {
							Map rowActToCheckData = new HashMap();
							for(int m=0; m<actToCheckList.size(); m++){
								rowActToCheckData = (HashMap)actToCheckList.get(m);							
								builder.writeln(StringUtil.checkNullToBlank(rowActToCheckData.get("toItemIdentifier")) +" "+ StringUtil.checkNullToBlank(rowActToCheckData.get("toItemName"))); // toItemDescription
							}
						}						
						builder.insertHtml("<br>");
						
						builder.getFont().setBold(true);
						builder.writeln("[Role]"); // 담당
						builder.getFont().setBold(false);
						builder.writeln(StringUtil.checkNullToBlank(rowActData.get("AT00022"))); // 담당
						builder.insertHtml("<br>");
						
						builder.getFont().setBold(true);
						builder.writeln("[System Type]");
						builder.getFont().setBold(false);
						builder.writeln(StringUtil.checkNullToBlank(rowActData.get("AT00037"))); // SystemType
						builder.insertHtml("<br>");
						
						builder.getFont().setBold(true);
						builder.writeln( "["+StringUtil.checkNullToBlank(attrNameMap.get("AT00014")) +"]");
						builder.getFont().setBold(false);
						builder.writeln(StringUtil.checkNullToBlank(rowActData.get("AT00014"))); // 화면코드
						builder.insertHtml("<br>");
						
						/* builder.getFont().setBold(true);
						builder.writeln("[통제유형]");
						builder.getFont().setBold(false);
						builder.writeln(StringUtil.checkNullToBlank(rowActData.get("AT00019"))); // 통제유형
						builder.insertHtml("<br>");
						
						builder.getFont().setBold(true);
						builder.writeln("[시스템 요구사항]");
						builder.getFont().setBold(false);
						builder.writeln(StringUtil.checkNullToBlank(rowActData.get("AT00021"))); // 시스템요구사항
						builder.insertHtml("<br>");
						
						builder.getFont().setBold(true);
						builder.writeln("[GAP]");
						builder.getFont().setBold(false);
						builder.writeln(StringUtil.checkNullToBlank(rowActData.get("AT00027"))); // FIT/GAP
						builder.insertHtml("<br>");
						
						builder.getFont().setBold(true);
						builder.writeln("[비고]]");
						builder.getFont().setBold(false);
						builder.writeln(StringUtil.checkNullToBlank(rowActData.get("AT00006"))); // 비고
						builder.insertHtml("<br>"); */
					}
					
					/* builder.startTable();
					builder.getRowFormat().clearFormatting();
					builder.getCellFormat().clearFormatting();
					
					// Make the header row.
					builder.insertCell();
					builder.getRowFormat().setHeight(20.0);
					builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
					
					// Some special features for the header row.
					builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					builder.getFont().setSize(10);
					builder.getFont().setBold (true);
					builder.getFont().setColor(Color.BLACK);
					builder.getFont().setName(defaultFont);
					
					builder.getCellFormat().setWidth(20.0);
					builder.write(String.valueOf(menu.get("LN00024"))); // No
					builder.insertCell();
					builder.getCellFormat().setWidth(110.0);
					builder.write(String.valueOf(menu.get("LN00028"))); // 명칭
					builder.insertCell();
					builder.getCellFormat().setWidth(180.0);
					builder.write(String.valueOf(menu.get("LN00035"))); // 개요
					builder.insertCell();
					builder.getCellFormat().setWidth(60.0);
					builder.write(String.valueOf(attrNameMap.get("AT00013"))); // IT System
					builder.insertCell();
					builder.getCellFormat().setWidth(60.0);
					builder.write(String.valueOf(attrNameMap.get("AT00014"))); // T-Code
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
					    
					    builder.getCellFormat().setWidth(20.0);
					   	builder.write(StringUtil.checkNullToBlank(rowActData.get("RNUM")));
						
					   	builder.insertCell();
					   	builder.getCellFormat().setWidth(110.0);
						String itemName = StringUtil.checkNullToBlank(rowActData.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
						itemName = itemName.replace("&#10;", " ");
						itemName = itemName.replace("&#xa;", "");
						itemName = itemName.replace("&nbsp;", " ");
						String processInfo = StringUtil.checkNullToBlank(rowActData.get("ProcessInfo")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
						processInfo = processInfo.replace("&#10;", " ");
						processInfo = processInfo.replace("&#xa;", "");
						processInfo = processInfo.replace("&nbsp;", " ");
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						builder.write(itemName);
						
						builder.insertCell();
						builder.getCellFormat().setWidth(180.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						builder.write(processInfo);
						builder.insertCell();
						builder.getCellFormat().setWidth(60.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00013"))); // IT System
						builder.insertCell();
						builder.getCellFormat().setWidth(60.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00014"))); // T-Code
						builder.endRow();
					}	
					
					builder.endTable().setAllowAutoFit(false);	 */
				}
				//==================================================================================================
				
		 	} else {
		 		if (null != modelMap) {
		 	 		//==================================================================================================
	 		 		//프로세스 맵
	 		 	 	builder.startTable();
	 		 	    
	 		 	 	builder.insertCell();
	 		 	 	builder.getRowFormat().clearFormatting();
	 		 		builder.getCellFormat().clearFormatting();
	 		 		builder.getRowFormat().setHeight(20.0);
	 		 		builder.getRowFormat().setHeightRule(HeightRule.AUTO);
	 		 	 	builder.getCellFormat().setWidth(totalCellWidth);
	 		 	 	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 		 	 	
	 		 		String imgLang = "_"+StringUtil.checkNull(setMap.get("langCode"));
	 		 		String imgPath = modelImgPath+modelMap.get("ModelID")+imgLang+"."+GlobalVal.MODELING_DIGM_IMG_TYPE;
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
	}
	
	//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
	long date = System.currentTimeMillis();
    String fileName = "BPD_" + itemNameOfFileNm + "_" + formatter.format(date) +".docx";
    if(outputType.equals("pdf")){
    	fileName = "BPD_" + itemNameOfFileNm + "_" + formatter.format(date) +".pdf";
    }
    response.setContentType("application/msword");
    response.setCharacterEncoding("UTF-8");
    response.setHeader("content-disposition","attachment; filename=" + fileName);
    
    if(outputType.equals("pdf")){
    	doc.save(response.getOutputStream(), SaveFormat.PDF);
    }else{
    	doc.save(response.getOutputStream(), SaveFormat.DOCX);
    }
    

	
} catch(Exception e){
	e.printStackTrace();
	
} finally{
	request.getSession(true).setAttribute("expFlag", "Y");
	
	response.getOutputStream().flush();
	response.getOutputStream().close();
}

%>
