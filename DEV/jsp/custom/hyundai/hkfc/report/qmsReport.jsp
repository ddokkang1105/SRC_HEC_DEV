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
<%@page import="org.apache.commons.text.StringEscapeUtils" %>

<%

try{
	String LogoImgUrl = "";
	String modelImgPath = GlobalVal.MODELING_DIGM_DIR;
	String logoPath = GlobalVal.FILE_UPLOAD_TINY_DIR;
	String defaultFont = "맑은 고딕";
	
	String regexDelFontSize = "font-size(.*?);";
	String regexDelFontFamily = "font-family(.*?);";
	String regexDelTableInsert1 = "page-break-before: always;";
	String regexDelTableInsert2 = "mso-break-type: section-break;";
 	
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
 	
 	String selectedItemPath = String.valueOf(request.getAttribute("selectedItemPath"));
 	String reportCode = String.valueOf(request.getAttribute("reportCode"));
 	
 	Map selectedItemMap = (Map)request.getAttribute("selectedItemMap");
 	Map gItem = (Map)request.getAttribute("gItem");
 	List pItemList = (List)request.getAttribute("pItemList");
 	List mainItemList = (List)request.getAttribute("mainItemList");
 	
 	double titleCellWidth = 170.0;
 	double titleCellWidth2 = 90.0;
 	double contentCellWidth3 = 90.0;
	double contentCellWidth = 350.0;
	double contentCellWidth2 = 220.0;
	double mergeCellWidth = 500.0;
	double totalCellWidth = 560.0;
	String value = "";
	String name = "";
	String fontFamilyHtml = "<span style=\"font-family:"+defaultFont+"; font-size: 9pt;\">";
	String fontFamilyHtmlForTableInner = "<span style=\"font-family:"+defaultFont+"; font-size: 9pt;\">";
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
    builder.getFont().setSize(8); 
    
 	// 1.footer : Line
 	//builder.getParagraphFormat().setSpaceBefore(1);
    builder.insertHtml("<hr size=5 color='silver'/>");
 	// 2.footer : logo
    builder.insertCell();
    builder.getCellFormat().setWidth(100.0);
    builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
    String imageFileName = logoPath + "logo.png";
    String imageFileName2 = logoPath + "kpal_restricted.png";
    builder.write("HYUNDAI KEFICO KPAL");
 	// 3.footer : current page / total page 
    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
    builder.insertCell();
    builder.getCellFormat().setWidth(100.0);
    // Set first cell to 1/3 of the page width.
    builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(100 / 3));
    // Insert page numbering text here.
    // It uses PAGE and NUMPAGES fields to auto calculate current page number and total number of pages.
    builder.insertField("PAGE", "");
    builder.write(" / ");
    builder.insertField("NUMPAGES", "");
    
 	// 4.footer : current page / total page 
    builder.insertCell();
    builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
    builder.getCellFormat().setWidth(500.0);
    builder.write("이 문서는 당사의 동의없이 수정, 변경 및 복사할 수 없습니다.");
    
    builder.endTable().setAllowAutoFit(false);
        
    builder.moveToDocumentEnd();
//=========================================================================
	
	builder = new DocumentBuilder(doc);
	
	//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	for (int totalCnt = 0;allTotalList.size() > totalCnt ; totalCnt++ ) {
		Map allTotalMap = (Map)allTotalList.get(totalCnt);
		Map titleItemMap = new HashMap();
		List totalList = (List)allTotalMap.get("totalList");
// 		if (!e2eModelMap.isEmpty()) {
// 			titleItemMap = e2eItemInfo;
// 		}else{
			titleItemMap = (Map)allTotalMap.get("titleItemMap");
// 		}
		
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
// 		    if (!e2eModelMap.isEmpty()) {
// 		    	builder.writeln("E2E 프로세스 정의서");
// 		    }else if(reportCode.equals("RP00031")){
// 		    	builder.writeln("PI 과제 정의서");
// 		    } else {
// 		    	builder.writeln("Process Definition Report");
// 		    }
			builder.endRow();
			
			// 3.선택한 프로세스 정보
    		builder.insertCell();
    		builder.getFont().setColor(Color.BLACK);
		    builder.getFont().setBold(true);
		    builder.getFont().setName(defaultFont);
		    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		    builder.getFont().setSize(30); 
		    builder.getFont().setUnderline(0);
			builder.writeln(StringUtil.checkNullToBlank(selectedItemMap.get("ItemName")));
			builder.insertHtml("<br>");
    		builder.insertHtml("<br>");
    		builder.insertHtml("<br>");
    		builder.insertHtml("<br>");
    		builder.insertHtml("<br>");
			builder.endRow();
    		
    		// 4.선택한 프로세스 정보 테이블
    		///////////////////////////////////////////////////////////////////////////////////////
    		//builder.insertCell();
    		//builder.getCellFormat().setWidth(30); // 테이블 앞 여백 설정
    		
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
			builder.getFont().setSize(10);
			builder.getFont().setUnderline(0);
			builder.getFont().setBold(true);
			builder.getFont().setColor(Color.BLACK);
			builder.getFont().setName(defaultFont);
			
			builder.getCellFormat().setWidth(150);
			builder.write(String.valueOf(menu.get("LN00018"))); // 주관조직
			
			builder.insertCell();
			builder.getCellFormat().setWidth(150);
			builder.write(String.valueOf(menu.get("LN01006"))); // 책임자
			
			builder.insertCell();
			builder.getCellFormat().setWidth(150);
			builder.write(String.valueOf(menu.get("LN00004"))); // 담당자
			
			builder.insertCell();
			builder.getCellFormat().setWidth(110);
			builder.write(String.valueOf(menu.get("LN00356"))); // 개정번호
			
			builder.endRow();
			
			// Set features for the other rows and cells.
			builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			builder.getFont().setBold(false);
					
			// Reset height and define a different height rule for table body
			builder.getRowFormat().setHeight(30.0);
			builder.getRowFormat().setHeightRule(HeightRule.AUTO);
			
			builder.insertCell();
		   	builder.getCellFormat().setWidth(150);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(StringUtil.checkNullToBlank(titleItemMap.get("OwnerTeamName")));
			
			builder.insertCell();
		   	builder.getCellFormat().setWidth(150);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(String.valueOf(request.getAttribute("ownerTeamMngNM")));
			
			builder.insertCell();
		   	builder.getCellFormat().setWidth(150);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(StringUtil.checkNullToBlank(titleItemMap.get("AuthorName")));
			
			builder.insertCell();
		   	builder.getCellFormat().setWidth(110);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(StringUtil.checkNullToBlank(titleItemMap.get("Version")));
			
			builder.endTable().setAlignment(TabAlignment.CENTER);
			builder.endRow();
			
			builder.endTable().setAllowAutoFit(false);
    		///////////////////////////////////////////////////////////////////////////////////////
    		// 표지 END
		    builder.insertBreak(BreakType.PAGE_BREAK);
    		

		//==================================================================================================
		
		if (totalList.size() > 0) { 
	 	for (int index = 0; totalList.size() > index ; index++) {	 		
	 		if (totalList.size() != 1) {
	 			builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
	 		}
	 		
	 		Map totalMap = (Map)totalList.get(index);
	 		
	 		List prcList = (List)totalMap.get("prcList");
	 		Map rowPrcData =  (HashMap) prcList.get(0); 
	 		List cngtList = (List)totalMap.get("cngtList");
	 		List activityList = (List)totalMap.get("activityList");
	 		List elementList = (List)totalMap.get("elementObjList");
	 		List relItemList = (List)totalMap.get("relItemList");
	 		List relItemConList = (List)totalMap.get("relItemConList");
	 		List relItemSubList = (List)totalMap.get("relItemSubList");
	 		List dimResultList = (List)totalMap.get("dimResultList");
	 		List attachFileList = (List)totalMap.get("attachFileList");
	 		List roleList = (List)totalMap.get("roleList");
	 		List rnrList = (List)totalMap.get("rnrList");
	 		Map attrMap = (Map)totalMap.get("attrMap");
	 		Map attrHtmlMap = (Map)totalMap.get("attrHtmlMap");
	 		Map modelMap = (Map)totalMap.get("modelMap");
	 		List relItemClassCodeList = (List)totalMap.get("relItemClassCodeList");
	 		List relItemNameList = (List)totalMap.get("relItemNameList");
 	 		List relItemID = (List)totalMap.get("relItemID");
 	 		List relItemAttrbyID = (List)totalMap.get("relItemAttrbyID");
 	 		Map AttrTypeList = (Map)totalMap.get("AttrTypeList");
	 		Map map = new HashMap();
	 		
	 		currentSection = builder.getCurrentSection();
	 	    pageSetup = currentSection.getPageSetup();
	 	    
	 	    pageSetup.setDifferentFirstPageHeaderFooter(false);
	 	    pageSetup.setHeaderDistance(25);
	 	    builder.moveToHeaderFooter(HeaderFooterType.HEADER_PRIMARY);
	 	    
	 	    //==================================================================================================
	 		// NEW 머릿글 : START
	 		
	 		// 사내한
	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.RIGHT);
	 		builder.insertImage(imageFileName2, 70, 25);
	 	    
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
	 	    builder.write(name); 
			
			builder.endRow();
			
			// Set features for the other rows and cells.
			builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			builder.getFont().setSize(10); 
			builder.getFont().setUnderline(0);
			builder.getFont().setBold(true); 
			
			// Reset height and define a different height rule for table body
			builder.getRowFormat().setHeight(30.0);
			builder.getRowFormat().setHeightRule(HeightRule.AUTO);
			
		    builder.insertCell(); 	
		    builder.getCellFormat().setWidth(140);
			builder.getCellFormat().setVerticalMerge(CellMerge.PREVIOUS);
			
			builder.insertCell();
		   	builder.getCellFormat().setWidth(180);builder.getCellFormat().setVerticalMerge(CellMerge.NONE);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(StringUtil.checkNullToBlank(rowPrcData.get("Identifier")));   
    		
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
	 			
	 			// [ 1. 프로세스 개요 ]
	 	 		builder.getFont().setColor(Color.DARK_GRAY);
			    builder.getFont().setSize(12);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
				builder.writeln("1. " + String.valueOf(menu.get("LN00057")));
				
	 			builder.startTable();
	 	 		
	 	 	    builder.getFont().setName(defaultFont);
	 	 	    builder.getFont().setColor(Color.BLACK);
	 	 	    builder.getFont().setSize(9);
	 	 	    
	 	 		builder.getRowFormat().clearFormatting();
				builder.getCellFormat().clearFormatting();
				builder.getRowFormat().setHeight(30.0);
	 	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경	 	
	 	 	    
	 	 		// 1.ROW : 프로세스
 	 			builder.insertCell();
 	 			//==================================================================================================
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(menu.get("LN00011")));
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getFont().setBold (false);
	 	 		builder.getCellFormat().setWidth(totalCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.write(StringUtil.checkNullToBlank(selectedItemMap.get("ItemName"))); // 프로세스 : 내용
	 	 		//==================================================================================================
	 	 		builder.endRow();
	 	 		
	 	 		// 2.ROW : 프로세스 코드
 	 			builder.insertCell();
 	 			//==================================================================================================
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(menu.get("LN00166")));
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getFont().setBold (false);
	 	 		builder.getCellFormat().setWidth(totalCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.write(StringUtil.checkNullToBlank(selectedItemMap.get("Identifier"))); // 프로세스 코드 : 내용
	 	 		//==================================================================================================
	 	 		builder.endRow();
	 	 		
	 	 		// 3.ROW : 개정번호
 	 			builder.insertCell();
 	 			//==================================================================================================
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(menu.get("LN00356")));
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getFont().setBold (false);
	 	 		builder.getCellFormat().setWidth(totalCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.write(StringUtil.checkNullToBlank(selectedItemMap.get("Version"))); // 개정번호 : 내용
	 	 		//==================================================================================================
	 	 		builder.endRow();
	 	 		
	 	 		// 4.ROW : 개정일
 	 			builder.insertCell();
 	 			//==================================================================================================
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(menu.get("LN00357")));
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getFont().setBold (false);
	 	 		builder.getCellFormat().setWidth(totalCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.write(StringUtil.checkNullToBlank(selectedItemMap.get("ValidFrom"))); // 개정일 : 내용
	 	 		//==================================================================================================
	 	 		builder.endRow();
	 	 		
	 	 		// 5.ROW : 관리조직
 	 			builder.insertCell();
 	 			//==================================================================================================
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(menu.get("LN00018")));
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getFont().setBold (false);
	 	 		builder.getCellFormat().setWidth(totalCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.write(StringUtil.checkNullToBlank(selectedItemMap.get("OwnerTeamName"))); // 관리조직 : 내용
	 	 		//==================================================================================================
	 	 		builder.endRow();
	 	 		
	 	 		// 6.ROW : 책임자
 	 			builder.insertCell();
 	 			//==================================================================================================
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(menu.get("LN01006")));
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getFont().setBold (false);
	 	 		builder.getCellFormat().setWidth(totalCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.write(StringUtil.checkNullToBlank(request.getAttribute("ownerTeamMngNM"))); // 책임자 : 내용
	 	 		//==================================================================================================
	 	 		builder.endRow();
	 	 		
	 	 		// 7.ROW : 담당자
 	 			builder.insertCell();
 	 			//==================================================================================================
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(menu.get("LN00004")));
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getFont().setBold (false);
	 	 		builder.getCellFormat().setWidth(totalCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.write(StringUtil.checkNullToBlank(selectedItemMap.get("Name"))); // 담당자 : 내용
	 	 		//==================================================================================================
	 	 		builder.endRow();
	 	 		
	 	 		// 8.ROW : 관리법인
 	 			builder.insertCell();
 	 			//==================================================================================================
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(menu.get("LN00352")));
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getFont().setBold (false);
	 	 		builder.getCellFormat().setWidth(totalCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.write(StringUtil.checkNullToBlank(selectedItemMap.get("TeamName"))); // 관리법인 : 내용
	 	 		//==================================================================================================
	 	 		builder.endRow();
	 	 		
	 	 	 	// 9.ROW : 목적	 	 	 	
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(menu.get("LN00386")));  // 목적
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(totalCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		
	 	 		builder.getFont().setName(defaultFont);
	 	 	    builder.getFont().setSize(9);
	 	 	  	builder.getFont().setBold(false);
	 	 		String AT00003 = StringUtil.checkNullToBlank(attrMap.get("AT00003")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("/upload", "upload").replace("upload/", logoPath);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00003")))) { // type이 HTML인 경우
	 	 			AT00003 = AT00003.replaceAll(regexDelTableInsert1, "");
 	 				AT00003 = AT00003.replaceAll(regexDelTableInsert2, "");
	 	 			if(StringUtil.checkNullToBlank(attrMap.get("AT00003")).contains("font-family")){
	 	 				AT00003 = AT00003.replaceAll(regexDelFontSize, "");
	 	 				AT00003 = AT00003.replaceAll(regexDelFontFamily, "");
	 	 				builder.insertHtml(AT00003,true);
	 	 			}else{
	 	 				builder.insertHtml(fontFamilyHtmlForTableInner+AT00003+"</span>",true);
	 	 			}
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(AT00003); // 개요 : 내용
	 	 		}
	 	 		
	 	 		//==================================================================================================	
	 	 		builder.endRow();
				
	 	 		// 10.ROW : 적용범위
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00060")));
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(totalCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		
	 	 		builder.getFont().setName(defaultFont);
	 	 	    builder.getFont().setSize(9);
	 	 	  	builder.getFont().setBold(false);
	 	 		String AT00060 = StringUtil.checkNullToBlank(attrMap.get("AT00060")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00060")))) { // type이 HTML인 경우
	 	 			AT00060 = AT00060.replaceAll(regexDelTableInsert1, "");
 	 				AT00060 = AT00060.replaceAll(regexDelTableInsert2, "");
	 	 			if(StringUtil.checkNullToBlank(attrMap.get("AT00060")).contains("font-family")){
	 	 				AT00060 = AT00060.replaceAll(regexDelFontSize, "");
	 	 				AT00060 = AT00060.replaceAll(regexDelFontFamily, "");
	 	 				builder.insertHtml(AT00060,true);
	 	 			}else{
	 	 				builder.insertHtml(fontFamilyHtmlForTableInner+AT00060+"</span>",true);
	 	 			}
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(AT00060);
	 	 		}
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 		// 11.ROW : 검토주기
 	 			builder.insertCell();
 	 			//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00080")));  // 검토주기
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getFont().setBold (false);
	 	 		builder.getCellFormat().setWidth(totalCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00080"))); // 검토주기 : 내용
	 	 		//==================================================================================================
	 	 		builder.endRow();
	 	 		
	 	 		// 12.ROW : 업무 관련부서
 	 			builder.insertCell();
 	 			//==================================================================================================
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(menu.get("LN01024"))); // 업무 관련부서 
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(totalCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
	 	 		String roleListR = "";
	 	 		for(int j=0; j < roleList.size(); j++) {
	 	 			Map role = (Map) roleList.get(j);
	 	 			if("R".equals(String.valueOf(role.get("TeamRoletype")))) {
	 	 				if(!"".equals(roleListR)) roleListR += ", ";
	 	 				roleListR += role.get("TeamNM");
	 	 			}
	 	 		}
	 	 		builder.write(roleListR); // 업무 관련부서 : 내용
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 		
	 	 		// 13.ROW : 장비 및 운영 정보
 	 			builder.insertCell();
 	 			//==================================================================================================
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00086")));
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getFont().setBold (false);
	 	 		builder.getCellFormat().setWidth(totalCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00086"))); // 장비 및 운영 정보 : 내용
	 	 		//==================================================================================================
	 	 		builder.endRow();
	 	 		
	 	 		// 14.ROW : 교육/지식/skills
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00082")));
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getFont().setBold (false);
	 	 		builder.getCellFormat().setWidth(totalCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00082"))); // 교육/지식/skills : 내용
	 	 		//==================================================================================================
	 	 		builder.endRow();
	 	 		
	 	 		// 15.ROW : 입력물
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00015")));
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getFont().setBold (false);
	 	 		builder.getCellFormat().setWidth(totalCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00015"))); // 입력물 : 내용
	 	 		//==================================================================================================
	 	 		builder.endRow();
	 	 		
	 	 		// 16.ROW : 출력물
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00016")));
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(totalCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
	 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00016"))); // 출력물 : 내용
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 		// 17.ROW : 선행 프로세스
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(menu.get("LN00387")));
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(totalCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
	 	 		
	 	 		String preElement = "";
	 	 		for(int j=0; j < elementList.size(); j++) {
	 	 			Map list = (Map) elementList.get(j);
	 	 			if("Pre".equals(String.valueOf(list.get("LinkType"))) && "SB00003".equals(String.valueOf(list.get("SymTypeCode")))) {
	 	 				if(!"".equals(preElement)) preElement += ", ";
	 	 				preElement += String.valueOf(list.get("PlainText"));
	 	 			}
	 	 		}
	 	 		builder.write(preElement); // 선행 프로세스 : 내용
	 	 		
	 	 		//==================================================================================================	
 	 			builder.endRow();
	 	 		
 	 			// 18.ROW : 후행 프로세스
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(menu.get("LN00385")));
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(totalCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
	 	 		String postElement = "";
	 	 		for(int j=0; j < elementList.size(); j++) {
	 	 			Map list = (Map) elementList.get(j);
	 	 			if(("Post".equals(String.valueOf(list.get("LinkType"))) || "Post/Pre".equals(String.valueOf(list.get("LinkType"))) || "Pre/Post".equals(String.valueOf(list.get("LinkType"))))
	 	 					&& "SB00003".equals(String.valueOf(list.get("SymTypeCode")))) {
	 	 				if(!"".equals(postElement)) postElement += ", ";
	 	 				postElement += String.valueOf(list.get("PlainText"));
	 	 			}
	 	 		}
	 	 		builder.write(postElement); // 후행 프로세스 : 내용
	 	 		//==================================================================================================	
 	 			builder.endRow();
	 	 		
 	 			// 19.ROW : 지침/절차/방법
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(menu.get("ZLN0003")));
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(totalCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
	 	 		
	 	 		String ZLN0003 = "";
	 	 		for(int j=0; j < elementList.size(); j++) {
	 	 			Map list = (Map) elementList.get(j);
	 	 			if("SB00016".equals(String.valueOf(list.get("SymTypeCode")))) {
	 	 				if(!"".equals(ZLN0003)) ZLN0003 += ", ";
	 	 				ZLN0003 += String.valueOf(list.get("PlainText"));
	 	 			}
	 	 		}
	 	 		builder.write(ZLN0003); // 지침/절차/방법 : 내용
	 	 		//==================================================================================================	
 	 			builder.endRow();
	 	 		
 	 			// 20.ROW : 성과지표
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(menu.get("ZLN0002")));
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(totalCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
	 	 		
	 	 		String ZLN0002 = "";
	 	 		for(int j=0; j<relItemList.size(); j++){
					Map relItem = (Map) relItemList.get(j);
					if("OJ00008".equals(String.valueOf(relItem.get("ItemTypeCode")))){
						if(!"".equals(ZLN0002)) ZLN0002 += ", ";
						ZLN0002 += String.valueOf(relItem.get("ItemName"));
					}
	 	 		}
	 	 		builder.write(ZLN0002); // 성과지표 : 내용
	 	 		//==================================================================================================	
 	 			builder.endRow();
	 	 		
	 	 		
	 	 		// 6.ROW (Dimension 정보 만큼 행 표시)
	 	 		for(int j=0; j<dimResultList.size(); j++){
	 	 			Map dimResultMap = (Map) dimResultList.get(j);
		 	 		
	 	 			builder.insertCell();
		 	 		//==================================================================================================	
		 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
		 	 		builder.getCellFormat().setWidth(titleCellWidth2);
		 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		 	 		builder.getFont().setBold (true);
		 	 		builder.write(String.valueOf(dimResultMap.get("dimTypeName")));
		 	 		
		 	 		builder.insertCell();
		 	 		builder.getCellFormat().setWidth(totalCellWidth);
		 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		 	 		builder.getFont().setBold(false);
	 	 			builder.write(StringUtil.checkNullToBlank(dimResultMap.get("dimValueNames")));
		 	 		//==================================================================================================	
	 	 			builder.endRow();
	 	 		}
	 	 		
	 	 		builder.endTable().setAllowAutoFit(false);
	 	 		//builder.writeln();
	 	 		
	 	 		int headerNO = 2;
	 	 		
	 	 		// [ 2. 제/개정 이력 ]
	 	 		if (String.valueOf(request.getAttribute("csYN")).equals("on")) {
	 	 			builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
		 	 		builder.getFont().setColor(Color.DARK_GRAY);
				    builder.getFont().setSize(12);
				    builder.getFont().setBold(true);
				    builder.getFont().setName(defaultFont);
					builder.writeln(headerNO+". " + String.valueOf(menu.get("LN00012")));
					headerNO++;
				
					Map data = new HashMap();
			 		
					builder.startTable();
					builder.getRowFormat().clearFormatting();
					builder.getCellFormat().clearFormatting();
					
					// Make the header row.
					builder.insertCell();
					builder.getRowFormat().setHeight(20.0);
					builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
					
					// Some special features for the header row.
					builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					builder.getFont().setSize(9);
					builder.getFont().setBold (true);
					builder.getFont().setColor(Color.BLACK);
					builder.getFont().setName(defaultFont);
					// 10
					builder.getCellFormat().setWidth(70.0); // Version
					builder.write("Version");
					builder.insertCell();
					
					builder.getCellFormat().setWidth(310.0);
					builder.write(String.valueOf(menu.get("LN00290"))); // 변경 개요
					builder.insertCell();

					builder.getCellFormat().setWidth(100.0);
					builder.write(String.valueOf(menu.get("LN00022"))); // 변경구분
					builder.insertCell();
					
					builder.getCellFormat().setWidth(150.0);
					builder.write(String.valueOf(menu.get("LN00004"))); // 담당자
					builder.insertCell();
					
					builder.getCellFormat().setWidth(100.0);
					builder.write(String.valueOf(menu.get("LN00095"))); // 승인일
					builder.endRow();	
					
					// Set features for the other rows and cells.
					builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
					builder.getCellFormat().setWidth(100.0);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					
					// Reset height and define a different height rule for table body
					builder.getRowFormat().setHeight(30.0);
					builder.getRowFormat().setHeightRule(HeightRule.AUTO);
					
					for(int j=0; j<cngtList.size(); j++){
						data = (HashMap) cngtList.get(j);
					    
				    	builder.insertCell();
					    if( j==0){
					    	// Reset font formatting.
					    	builder.getFont().setBold(false);
					    }
					    
					   	builder.getCellFormat().setWidth(70.0);
					   	builder.write(StringUtil.checkNullToBlank(data.get("Version")));
						builder.insertCell();
						builder.getCellFormat().setWidth(310.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						builder.write(StringUtil.checkNullToBlank(data.get("Description"))); 
						builder.insertCell();
						builder.getCellFormat().setWidth(100.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.write(StringUtil.checkNullToBlank(data.get("ChangeType"))); 
						builder.insertCell();
						builder.getCellFormat().setWidth(150.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.write(StringUtil.checkNullToBlank(data.get("AuthorName")));
						builder.insertCell();
						builder.getCellFormat().setWidth(100.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.write(StringUtil.checkNullToBlank(data.get("ApproveDate")));
						builder.endRow();
					}	
					builder.endTable().setAllowAutoFit(false);
				}
				//==================================================================================================
		 		
				// [ 3. 모델 ]						
				if (0 != modelMap.size()) {
	 				builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
			 		// 업무처리 절차 Title
			 		if (null == modelMap) {
			 			builder.insertHtml("<br>");
			 		}
			 		builder.getFont().setColor(Color.DARK_GRAY);
				    builder.getFont().setSize(11);
				    builder.getFont().setBold(true);
				    builder.getFont().setName(defaultFont);
					builder.writeln(headerNO+". " + String.valueOf(menu.get("LN00125")));
					headerNO++;
					
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
	 	 		
				// [4. 세부업무 ]
				if (String.valueOf(request.getAttribute("subItemYN")).equals("on")) {
	 	 			builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
		 	 		builder.getFont().setColor(Color.DARK_GRAY);
				    builder.getFont().setSize(12);
				    builder.getFont().setBold(true);
				    builder.getFont().setName(defaultFont);
					builder.writeln(headerNO+". " + String.valueOf(menu.get("ZLN0004")));
					headerNO++;
					
					builder.getRowFormat().clearFormatting();
					builder.getCellFormat().clearFormatting();
					
					Map data = new HashMap();
					
					// L4
					for(int j=0; j<activityList.size(); j++){
						data = (HashMap) activityList.get(j);
						
						// L4 title
						builder.getFont().setName(defaultFont);
			 	 	    builder.getFont().setColor(Color.BLACK);
			 	 	    builder.getFont().setSize(9);
			 	 	  	builder.getFont().setBold (true);
			 	 	  
			 	 	  	List itemInfo = (List) data.get("actPrcList");
			 	 	  	String identifier = "";
			 	 	  	String className = "";
			 	 	  	String classCode = "";
			 	 	  	String version = "";
			 	 	  	String validFrom = "";
			 	 	  	String ownerTeamName = "";
			 	 	  	String Name = "";
			 	 	  	String teamName = "";
			 	 	  	
			 	 		for(int k=0; k < itemInfo.size(); k++) {
			 	 			Map info = (Map) itemInfo.get(k);
			 	 			if(info.containsKey("Identifier")) identifier = String.valueOf(info.get("Identifier"));
			 	 			if(info.containsKey("ClassName")) className = String.valueOf(info.get("ClassName"));
			 	 			if(info.containsKey("ClassCode")) classCode = String.valueOf(info.get("ClassCode"));
			 	 			if(info.containsKey("Version")) version = String.valueOf(info.get("Version")); // 개정
			 	 			if(info.containsKey("ValidFrom")) validFrom = String.valueOf(info.get("ValidFrom")); // 개정일
			 	 			if(info.containsKey("OwnerTeamName")) ownerTeamName = String.valueOf(info.get("OwnerTeamName")); // 관리조직
			 	 			if(info.containsKey("Name")) Name = String.valueOf(info.get("Name")); // 담당자
			 	 			if(info.containsKey("TeamName")) teamName = String.valueOf(info.get("TeamName")); // 관리법인
			 	 		}
			 	 	    
			 	 		if("CL01005".equals(classCode)) {
			 	 			
			 	 			builder.writeln("[" + className + "] " + identifier + StringUtil.checkNullToBlank(data.get("PlainText")));
			 	 			builder.startTable();
				 	 	    
				 	 		builder.getRowFormat().clearFormatting();
							builder.getCellFormat().clearFormatting();
							builder.getRowFormat().setHeight(30.0);
				 	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경
			 	 			
			 	 			// 개정번호
			 	 			builder.insertCell();
			 	 			//==================================================================================================
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
				 	 		builder.getCellFormat().setWidth(titleCellWidth2);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold (true);
				 	 		builder.write(String.valueOf(menu.get("LN00356")));
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getFont().setBold (false);
				 	 		builder.getCellFormat().setWidth(totalCellWidth);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.write(version); // 개정번호 : 내용
				 	 		//==================================================================================================
				 	 		builder.endRow();
				 	 		
			 	 			// 개정일
			 	 			builder.insertCell();
			 	 			//==================================================================================================
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
				 	 		builder.getCellFormat().setWidth(titleCellWidth2);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold (true);
				 	 		builder.write(String.valueOf(menu.get("LN00357")));
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getFont().setBold (false);
				 	 		builder.getCellFormat().setWidth(totalCellWidth);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.write(validFrom); // 개정일 : 내용
				 	 		//==================================================================================================
				 	 		builder.endRow();
				 	 		
			 	 			// 관리조직
			 	 			builder.insertCell();
			 	 			//==================================================================================================
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
				 	 		builder.getCellFormat().setWidth(titleCellWidth2);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold (true);
				 	 		builder.write(String.valueOf(menu.get("LN00018")));
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getFont().setBold (false);
				 	 		builder.getCellFormat().setWidth(totalCellWidth);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.write(ownerTeamName); // 관리조직 : 내용
				 	 		//==================================================================================================
				 	 		builder.endRow();
				 	 		
			 	 			// 책임자
			 	 			builder.insertCell();
			 	 			//==================================================================================================
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
				 	 		builder.getCellFormat().setWidth(titleCellWidth2);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold (true);
				 	 		builder.write(String.valueOf(menu.get("LN01006")));
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getFont().setBold (false);
				 	 		builder.getCellFormat().setWidth(totalCellWidth);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.write(String.valueOf(data.get("ownerTeamMngNM"))); // 책임자 : 내용
				 	 		//==================================================================================================
				 	 		builder.endRow();
				 	 		
			 	 			// 담당자
			 	 			builder.insertCell();
			 	 			//==================================================================================================
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
				 	 		builder.getCellFormat().setWidth(titleCellWidth2);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold (true);
				 	 		builder.write(String.valueOf(menu.get("LN00004")));
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getFont().setBold (false);
				 	 		builder.getCellFormat().setWidth(totalCellWidth);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.write(Name); // 담당자 : 내용
				 	 		//==================================================================================================
				 	 		builder.endRow();
			 	 			
			 	 			// 관리법인
			 	 			builder.insertCell();
			 	 			//==================================================================================================
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
				 	 		builder.getCellFormat().setWidth(titleCellWidth2);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold (true);
				 	 		builder.write(String.valueOf(menu.get("LN00352")));
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getFont().setBold (false);
				 	 		builder.getCellFormat().setWidth(totalCellWidth);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.write(teamName); // 관리조직 : 내용
				 	 		//==================================================================================================
				 	 		builder.endRow();
				 	 		
			 	 			// 개요
			 	 			builder.insertCell();
			 	 			//==================================================================================================
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
				 	 		builder.getCellFormat().setWidth(titleCellWidth2);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold (true);
				 	 		builder.write(String.valueOf(AttrTypeList.get("AT00003")));
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getFont().setBold (false);
				 	 		builder.getCellFormat().setWidth(totalCellWidth);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		
				 	 		String actAT00003 = StringUtil.checkNullToBlank(data.get("AT00003")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("/upload", "upload").replace("upload/", logoPath);
				 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00003")))) { // type이 HTML인 경우
				 	 			actAT00003 = actAT00003.replaceAll(regexDelTableInsert1, "");
			 	 				actAT00003 = actAT00003.replaceAll(regexDelTableInsert2, "");
				 	 			if(StringUtil.checkNullToBlank(data.get("AT00003")).contains("font-family")){
				 	 				actAT00003 = actAT00003.replaceAll(regexDelFontSize, "");
				 	 				actAT00003 = actAT00003.replaceAll(regexDelFontFamily, "");
				 	 				builder.insertHtml(actAT00003,true);
				 	 			}else{
				 	 				builder.insertHtml(fontFamilyHtmlForTableInner+actAT00003+"</span>",true);
				 	 			}
				 	 		} else {
				 	 			builder.getFont().setBold(false);
				 	 			builder.write(actAT00003); // 개요 : 내용
				 	 		}
				 	 		//==================================================================================================
				 	 		builder.endRow();
				 	 		
			 	 			// 업무기준
			 	 			builder.insertCell();
			 	 			//==================================================================================================
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
				 	 		builder.getCellFormat().setWidth(titleCellWidth2);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold (true);
				 	 		builder.write(String.valueOf(AttrTypeList.get("AT00008")));
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getFont().setBold (false);
				 	 		builder.getCellFormat().setWidth(totalCellWidth);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		
				 	 		String actAT00008 = StringUtil.checkNullToBlank(data.get("AT00008")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("/upload", "upload").replace("upload/", logoPath);
				 	 		actAT00008 = actAT00008.replaceAll(regexDelTableInsert1, "");
		 	 				actAT00008 = actAT00008.replaceAll(regexDelTableInsert2, "");
				 	 		if(StringUtil.checkNullToBlank(data.get("AT00008")).contains("font-family")){
			 	 				actAT00008 = actAT00008.replaceAll(regexDelFontSize, "");
			 	 				actAT00008 = actAT00008.replaceAll(regexDelFontFamily, "");
			 	 				builder.insertHtml(actAT00008,true);
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtmlForTableInner+actAT00008+"</span>",true);
			 	 			}
				 	 		//==================================================================================================
				 	 		builder.endRow();
				 	 		
				 	 		// 업무 주관부서
			 	 			builder.insertCell();
			 	 			//==================================================================================================	
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
				 	 		builder.getCellFormat().setWidth(titleCellWidth2);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold (true);
				 	 		builder.write(String.valueOf(menu.get("ZLN0001")));  // 업무 주관부서
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getFont().setBold (false);
				 	 		builder.getCellFormat().setWidth(totalCellWidth);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		String actRoleListR = "";
				 	 		List actRoleList = (List) data.get("actTeamRoleList");
				 	 		for(int k=0; k < actRoleList.size(); k++) {
				 	 			Map role = (Map) actRoleList.get(k);
				 	 			if(role.containsKey("TeamRoletype")){
					 	 			if("R".equals(String.valueOf(role.get("TeamRoletype")))) {
					 	 				if(!("").equals(actRoleListR)) actRoleListR += ", ";
					 	 				actRoleListR += role.get("TeamNM");
					 	 			}
				 	 			}
				 	 		}
				 	 		builder.write(actRoleListR); // 업무 주관부서 : 내용
				 	 		//==================================================================================================
				 	 		builder.endRow();
				 	 		
				 	 		// 업무 관련부서
			 	 			builder.insertCell();
			 	 			//==================================================================================================
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
				 	 		builder.getCellFormat().setWidth(titleCellWidth2);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold (true);
				 	 		builder.write(String.valueOf(menu.get("LN01024"))); // 업무 관련부서 
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getCellFormat().setWidth(totalCellWidth);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.getFont().setBold(false);
				 	 		String actRoleListC = "";
				 	 		for(int k=0; k < actRoleList.size(); k++) {
				 	 			Map role = (Map) actRoleList.get(k);
				 	 			if(role.containsKey("TeamRoletype")){
					 	 			if(!"R".equals(String.valueOf(role.get("TeamRoletype")))) {
					 	 				if(!("").equals(actRoleListC)) actRoleListC += ", ";
					 	 				actRoleListC += role.get("TeamNM");
					 	 			}
				 	 			}
				 	 		}
				 	 		builder.write(actRoleListC); // 업무 관련부서 : 내용
				 	 		//==================================================================================================	
				 	 		builder.endRow();
				 	 		
				 	 		
				 	 		// 업무주기/시점
			 	 			builder.insertCell();
			 	 			//==================================================================================================
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
				 	 		builder.getCellFormat().setWidth(titleCellWidth2);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold (true);
				 	 		builder.write(String.valueOf(AttrTypeList.get("AT00009")));
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getFont().setBold (false);
				 	 		builder.getCellFormat().setWidth(totalCellWidth);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.write(StringUtil.checkNullToBlank(data.get("AT00009"))); // 업무주기/시점 : 내용
				 	 		//==================================================================================================
				 	 		builder.endRow();
				 	 		
				 	 		// 입력물
				 	 		builder.insertCell();
				 	 		//==================================================================================================	
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
				 	 		builder.getCellFormat().setWidth(titleCellWidth2);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold (true);
				 	 		builder.write(String.valueOf(AttrTypeList.get("AT00015")));
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getFont().setBold (false);
				 	 		builder.getCellFormat().setWidth(totalCellWidth);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.write(StringUtil.checkNullToBlank(data.get("AT00015"))); // 입력물 : 내용
				 	 		//==================================================================================================
				 	 		builder.endRow();
				 	 		
				 	 		// 출력물
				 	 		builder.insertCell();
				 	 		//==================================================================================================	
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
				 	 		builder.getCellFormat().setWidth(titleCellWidth2);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold (true);
				 	 		builder.write(String.valueOf(AttrTypeList.get("AT00016")));
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getCellFormat().setWidth(totalCellWidth);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.getFont().setBold(false);
				 	 		builder.write(StringUtil.checkNullToBlank(data.get("AT00016"))); // 출력물 : 내용
				 	 		//==================================================================================================	
				 	 		builder.endRow();
				 	 		
				 	 		// IT SYSTEM
				 	 		builder.insertCell();
				 	 		//==================================================================================================	
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
				 	 		builder.getCellFormat().setWidth(titleCellWidth2);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold (true);
				 	 		builder.write("IT SYSTEM");
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getCellFormat().setWidth(totalCellWidth);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.getFont().setBold(false);
				 	 		String actItSystem = "";
				 	 		List actItemList = (List) data.get("actITSystemList");
				 	 		
				 	 		for(int k=0; k < actItemList.size(); k++) {
				 	 			Map relItem = (Map) actItemList.get(k);
				 	 			if("OJ00004".equals(String.valueOf(relItem.get("ItemTypeCode")))) {
				 	 				if(!("").equals(actItSystem)) actItSystem += ", ";
				 	 				actItSystem += relItem.get("ItemName")+"("+relItem.get("ItemPath")+")";
				 	 			}
				 	 		}
				 	 		builder.write(actItSystem); // IT SYSTEM : 내용
				 	 		//==================================================================================================	
			 	 			builder.endRow();
						
			 	 			builder.endTable().setAllowAutoFit(false);	
				 	 		builder.insertHtml("<br>");
			 	 		}
					}
					
					// L5
					for(int j=0; j<activityList.size(); j++){
						data = (HashMap) activityList.get(j);
						
						// L5 title
						builder.getFont().setName(defaultFont);
			 	 	    builder.getFont().setColor(Color.BLACK);
			 	 	    builder.getFont().setSize(9);
			 	 	  	builder.getFont().setBold (true);
			 	 	    
			 	 	  	List itemInfo = (List) data.get("actPrcList");
			 	 	  	String identifier = "";
			 	 	  	String className = "";
			 	 	  	String classCode = "";
			 	 	  	
			 	 		for(int k=0; k < itemInfo.size(); k++) {
			 	 			Map info = (Map) itemInfo.get(k);
			 	 			identifier = String.valueOf(info.get("Identifier"));
			 	 			className = String.valueOf(info.get("ClassName"));
			 	 			classCode = String.valueOf(info.get("ClassCode"));
			 	 		}
			 	 	    
			 	 		if("CL01006".equals(classCode)) {
			 	 		
				 	 	  	builder.writeln("[" + className + "] " + identifier + StringUtil.checkNullToBlank(data.get("PlainText")));
							builder.startTable();
				 	 	    
				 	 		builder.getRowFormat().clearFormatting();
							builder.getCellFormat().clearFormatting();
							builder.getRowFormat().setHeight(30.0);
				 	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경
							
				 	 		// 업무 주관부서
			 	 			builder.insertCell();
			 	 			//==================================================================================================	
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
				 	 		builder.getCellFormat().setWidth(titleCellWidth2);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold (true);
				 	 		builder.write(String.valueOf(menu.get("ZLN0001")));  // 업무 주관부서
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getFont().setBold (false);
				 	 		builder.getCellFormat().setWidth(totalCellWidth);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		String actRoleListR = "";
				 	 		List actRoleList = (List) data.get("actTeamRoleList");
				 	 		for(int k=0; k < actRoleList.size(); k++) {
				 	 			Map role = (Map) actRoleList.get(k);
				 	 			if(role.containsKey("TeamRoletype")){
					 	 			if("R".equals(String.valueOf(role.get("TeamRoletype")))) {
					 	 				if(!("").equals(actRoleListR)) actRoleListR += ", ";
					 	 				actRoleListR += role.get("TeamNM");
					 	 			}
				 	 			}
				 	 		}
				 	 		builder.write(actRoleListR); // 업무 주관부서 : 내용
				 	 		//==================================================================================================
				 	 		builder.endRow();
				 	 		
				 	 		// 업무 관련부서
			 	 			builder.insertCell();
			 	 			//==================================================================================================
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
				 	 		builder.getCellFormat().setWidth(titleCellWidth2);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold (true);
				 	 		builder.write(String.valueOf(menu.get("LN01024"))); // 업무 관련부서 
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getCellFormat().setWidth(totalCellWidth);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.getFont().setBold(false);
				 	 		String actRoleListC = "";
				 	 		for(int k=0; k < actRoleList.size(); k++) {
				 	 			Map role = (Map) actRoleList.get(k);
				 	 			if(role.containsKey("TeamRoletype")){
					 	 			if(!"R".equals(String.valueOf(role.get("TeamRoletype")))) {
					 	 				if(!("").equals(actRoleListC)) actRoleListC += ", ";
					 	 				actRoleListC += role.get("TeamNM");
					 	 			}
				 	 			}
				 	 		}
				 	 		builder.write(actRoleListC); // 업무 관련부서 : 내용
				 	 		//==================================================================================================	
				 	 		builder.endRow();
				 	 		
				 	 		
				 	 		// 업무주기/시점
			 	 			builder.insertCell();
			 	 			//==================================================================================================
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
				 	 		builder.getCellFormat().setWidth(titleCellWidth2);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold (true);
				 	 		builder.write(String.valueOf(AttrTypeList.get("AT00009")));
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getFont().setBold (false);
				 	 		builder.getCellFormat().setWidth(totalCellWidth);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.write(StringUtil.checkNullToBlank(data.get("AT00009"))); // 업무주기/시점 : 내용
				 	 		//==================================================================================================
				 	 		builder.endRow();
				 	 		
				 	 		// 입력물
				 	 		builder.insertCell();
				 	 		//==================================================================================================	
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
				 	 		builder.getCellFormat().setWidth(titleCellWidth2);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold (true);
				 	 		builder.write(String.valueOf(AttrTypeList.get("AT00015")));
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getFont().setBold (false);
				 	 		builder.getCellFormat().setWidth(totalCellWidth);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.write(StringUtil.checkNullToBlank(data.get("AT00015"))); // 입력물 : 내용
				 	 		//==================================================================================================
				 	 		builder.endRow();
				 	 		
				 	 		// 출력물
				 	 		builder.insertCell();
				 	 		//==================================================================================================	
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
				 	 		builder.getCellFormat().setWidth(titleCellWidth2);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold (true);
				 	 		builder.write(String.valueOf(AttrTypeList.get("AT00016")));
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getCellFormat().setWidth(totalCellWidth);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.getFont().setBold(false);
				 	 		builder.write(StringUtil.checkNullToBlank(data.get("AT00016"))); // 출력물 : 내용
				 	 		//==================================================================================================	
				 	 		builder.endRow();
				 	 		
				 	 		// IT SYSTEM
				 	 		builder.insertCell();
				 	 		//==================================================================================================	
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
				 	 		builder.getCellFormat().setWidth(titleCellWidth2);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold (true);
				 	 		builder.write("IT SYSTEM");
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getCellFormat().setWidth(totalCellWidth);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.getFont().setBold(false);
				 	 		String actItSystem = "";
				 	 		List actItemList = (List) data.get("actITSystemList");
				 	 		
				 	 		for(int k=0; k < actItemList.size(); k++) {
				 	 			Map relItem = (Map) actItemList.get(k);
				 	 			if("OJ00004".equals(String.valueOf(relItem.get("ItemTypeCode")))) {
				 	 				if(!("").equals(actItSystem)) actItSystem += ", ";
				 	 				actItSystem += relItem.get("ItemName")+"("+relItem.get("ItemPath")+")";
				 	 			}
				 	 		}
				 	 		builder.write(actItSystem); // IT SYSTEM : 내용
				 	 		//==================================================================================================	
			 	 			builder.endRow();
				 	 		
			 	 			// 테스크 개요
				 	 		builder.insertCell();
				 	 		//==================================================================================================	
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
				 	 		builder.getCellFormat().setWidth(totalCellWidth + titleCellWidth2);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold (true);
				 	 		builder.write(String.valueOf(menu.get("LN00380")));
				 	 		builder.endRow();
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getCellFormat().setWidth(totalCellWidth + titleCellWidth2);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		
				 	 		builder.getFont().setName(defaultFont);
				 	 	    builder.getFont().setSize(9);
				 	 	  	builder.getFont().setBold(false);
							
				 	 		String ATVITAT00003 = StringUtil.checkNullToBlank(data.get("AT00003")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("/upload", "upload").replace("upload/", logoPath);
				 	 		ATVITAT00003 = ATVITAT00003.replaceAll(regexDelFontSize, "");
				 	 		ATVITAT00003 = ATVITAT00003.replaceAll(regexDelFontFamily, "");
				 	 		ATVITAT00003 = ATVITAT00003.replaceAll(regexDelTableInsert1, "");
				 	 		ATVITAT00003 = ATVITAT00003.replaceAll(regexDelTableInsert2, "");
				 	 		builder.insertHtml(ATVITAT00003,true); // 테스크 개요 : 내용
				 	 		//==================================================================================================	
			 	 			builder.endRow();
							
			 	 			builder.endTable().setAllowAutoFit(false);
							builder.insertHtml("<br>");
			 	 		}
					}
					
				}
				
				//==================================================================================================
				
				// [ 5. 선/후행  Process ] -- 제외
						
				// [ 6. R&R ]
				if (String.valueOf(request.getAttribute("rnrYN")).equals("on")) {
					
					builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
		 	 		builder.getFont().setColor(Color.DARK_GRAY);
				    builder.getFont().setSize(12);
				    builder.getFont().setBold(true);
				    builder.getFont().setName(defaultFont);
					builder.writeln(headerNO+". R&R");
					headerNO++;
					
					// L3 QMS Process
					Map data = new HashMap();
					data = (HashMap) rnrList.get(0);						
					
					builder.getFont().setSize(9);
					builder.getFont().setBold (true);
					
					builder.writeln("[L3.QMS Process] " + StringUtil.checkNullToBlank(data.get("Identifier")) + " " + StringUtil.checkNullToBlank(data.get("TREE_NM")));
			 		
					builder.startTable();
					builder.getRowFormat().clearFormatting();
					builder.getCellFormat().clearFormatting();
					
					// Make the header row.
					builder.insertCell();
					builder.getRowFormat().setHeight(20.0);
					builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
					
					// Some special features for the header row.
					builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					builder.getFont().setSize(9);
					builder.getFont().setBold (true);
					builder.getFont().setColor(Color.BLACK);
					builder.getFont().setName(defaultFont);
					
					builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(9.0));
					builder.write(String.valueOf(menu.get("LN00024"))); // No
					
					builder.insertCell();
					builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(65.0));
					builder.write(String.valueOf(menu.get("LN00247"))); // 조직
					
					builder.insertCell();
					builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(25.0));
					builder.write(String.valueOf(menu.get("LN00119"))); // 역할
					
					builder.endRow();	
					
					// Set features for the other rows and cells.
					builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					
					// Reset height and define a different height rule for table body
					builder.getRowFormat().setHeight(30.0);
					builder.getRowFormat().setHeightRule(HeightRule.AUTO);
					
					List subItemRoleList = (List) data.get("teamInfo");
					for(int k=0; k<subItemRoleList.size(); k++){
						builder.getFont().setBold(false);
						
						Map subItemRole = new HashMap();
						subItemRole = (HashMap) subItemRoleList.get(k);
						
						builder.insertCell();
				    	builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(9.0));
					   	builder.write(StringUtil.checkNullToBlank(subItemRole.get("RNUM")));
					   	
					   	builder.insertCell();
					   	builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(65.0));
					   	builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
					   	builder.write(StringUtil.checkNullToBlank(subItemRole.get("TeamNM")));
						 
						builder.insertCell();
						builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(25.0));
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.write(StringUtil.checkNullToBlank(subItemRole.get("TeamRoleNM"))); 

						builder.endRow();
					}
					builder.endTable().setAllowAutoFit(false);
					builder.insertHtml("<br>");
					
					// L4 Process
					for(int j=0; j<activityList.size(); j++){
						data = (HashMap) activityList.get(j);
						
						// L4 title
						builder.getFont().setName(defaultFont);
			 	 	    builder.getFont().setColor(Color.BLACK);
			 	 	    builder.getFont().setSize(9);
			 	 	  	builder.getFont().setBold (true);
			 	 	  
			 	 	  	List itemInfo = (List) data.get("actPrcList");
			 	 	  	String identifier = "";
			 	 	  	String className = "";
			 	 	  	String classCode = "";
			 	 	  	
			 	 		for(int k=0; k < itemInfo.size(); k++) {
			 	 			Map info = (Map) itemInfo.get(k);
			 	 			identifier = String.valueOf(info.get("Identifier"));
			 	 			className = String.valueOf(info.get("ClassName"));
			 	 			classCode = String.valueOf(info.get("ClassCode"));
			 	 		}
			 	 	    
			 	 		if("CL01005".equals(classCode)) {
			 	 			builder.writeln("[Process > " + className + "] " + identifier + StringUtil.checkNullToBlank(data.get("PlainText")));
			 	 			builder.startTable();
			 	 			builder.getRowFormat().clearFormatting();
							builder.getCellFormat().clearFormatting();
							
							// Make the header row.
							builder.insertCell();
							builder.getRowFormat().setHeight(20.0);
							builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
							
							// Some special features for the header row.
							builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
							builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
							builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
							builder.getFont().setSize(9);
							builder.getFont().setBold (true);
							builder.getFont().setColor(Color.BLACK);
							builder.getFont().setName(defaultFont);
							
							builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(9.0));
							builder.write(String.valueOf(menu.get("LN00024"))); // No
							
							builder.insertCell();
							builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(65.0));
							builder.write(String.valueOf(menu.get("LN00247"))); // 조직
							
							builder.insertCell();
							builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(25.0));
							builder.write(String.valueOf(menu.get("LN00119"))); // 역할
							
							builder.endRow();	
							
							// Set features for the other rows and cells.
							builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
							builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
							
							// Reset height and define a different height rule for table body
							builder.getRowFormat().setHeight(30.0);
							builder.getRowFormat().setHeightRule(HeightRule.AUTO);
							
							subItemRoleList = (List) data.get("actTeamRoleList");
							for(int k=0; k<subItemRoleList.size(); k++){
								builder.getFont().setBold(false);
								
								Map subItemRole = new HashMap();
								subItemRole = (HashMap) subItemRoleList.get(k);
								
								builder.insertCell();
						    	builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(9.0));
							   	builder.write(StringUtil.checkNullToBlank(subItemRole.get("RNUM")));
							   	
							   	builder.insertCell();
							   	builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(65.0));
							   	builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
							   	builder.write(StringUtil.checkNullToBlank(subItemRole.get("TeamNM")));
								 
								builder.insertCell();
								builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(25.0));
								builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
								builder.write(StringUtil.checkNullToBlank(subItemRole.get("TeamRoleNM"))); 

								builder.endRow();
							}
							builder.endTable().setAllowAutoFit(false);
							builder.insertHtml("<br>");
			 	 		}
					}
					
					
					// L5 Activity
					for(int j=0; j<activityList.size(); j++){
						data = (HashMap) activityList.get(j);
						
						// L5 title
						builder.getFont().setName(defaultFont);
			 	 	    builder.getFont().setColor(Color.BLACK);
			 	 	    builder.getFont().setSize(9);
			 	 	  	builder.getFont().setBold (true);
			 	 	  
			 	 	  	List itemInfo = (List) data.get("actPrcList");
			 	 	  	String identifier = "";
			 	 	  	String className = "";
			 	 	  	String classCode = "";
			 	 	  	
			 	 		for(int k=0; k < itemInfo.size(); k++) {
			 	 			Map info = (Map) itemInfo.get(k);
			 	 			identifier = String.valueOf(info.get("Identifier"));
			 	 			className = String.valueOf(info.get("ClassName"));
			 	 			classCode = String.valueOf(info.get("ClassCode"));
			 	 		}
			 	 	    
			 	 		if("CL01006".equals(classCode)) {
			 	 			builder.writeln("[Process > " + className + "] " + identifier + StringUtil.checkNullToBlank(data.get("PlainText")));
			 	 			builder.startTable();
			 	 			builder.getRowFormat().clearFormatting();
							builder.getCellFormat().clearFormatting();
							
							// Make the header row.
							builder.insertCell();
							builder.getRowFormat().setHeight(20.0);
							builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
							
							// Some special features for the header row.
							builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
							builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
							builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
							builder.getFont().setSize(9);
							builder.getFont().setBold (true);
							builder.getFont().setColor(Color.BLACK);
							builder.getFont().setName(defaultFont);
							
							builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(9.0));
							builder.write(String.valueOf(menu.get("LN00024"))); // No
							
							builder.insertCell();
							builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(65.0));
							builder.write(String.valueOf(menu.get("LN00247"))); // 조직
							
							builder.insertCell();
							builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(25.0));
							builder.write(String.valueOf(menu.get("LN00119"))); // 역할
							
							builder.endRow();	
							
							// Set features for the other rows and cells.
							builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
							builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
							
							// Reset height and define a different height rule for table body
							builder.getRowFormat().setHeight(30.0);
							builder.getRowFormat().setHeightRule(HeightRule.AUTO);
							
							subItemRoleList = (List) data.get("actTeamRoleList");
							for(int k=0; k<subItemRoleList.size(); k++){
								builder.getFont().setBold(false);
								
								Map subItemRole = new HashMap();
								subItemRole = (HashMap) subItemRoleList.get(k);
								
								builder.insertCell();
						    	builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(9.0));
							   	builder.write(StringUtil.checkNullToBlank(subItemRole.get("RNUM")));
							   	
							   	builder.insertCell();
							   	builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(65.0));
							   	builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
							   	builder.write(StringUtil.checkNullToBlank(subItemRole.get("TeamNM")));
								 
								builder.insertCell();
								builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(25.0));
								builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
								builder.write(StringUtil.checkNullToBlank(subItemRole.get("TeamRoleNM"))); 

								builder.endRow();
							}
							builder.endTable().setAllowAutoFit(false);
							builder.insertHtml("<br>");
			 	 		}
					}
					
				}
				//==================================================================================================
		 		
				// [ 연관항목 ] ( 연관항목 + 용어 + 성과지표 )
				
				Map cnAttrList = new HashMap();
				List cnAttr = new ArrayList();
				Map AttrInfoList = new HashMap();
				Map ItemAttrInfo = new HashMap();
				if (String.valueOf(request.getAttribute("cxnYN")).equals("on")) {
					
					// 7. 연관항목 (L4)
					builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
					
					builder.getFont().setColor(Color.DARK_GRAY);
				    builder.getFont().setSize(12);
				    builder.getFont().setBold(true);
				    builder.getFont().setName(defaultFont);
					builder.writeln(headerNO+". " + String.valueOf(menu.get("LN00008")));
					headerNO++;
				    				    
					builder.getFont().setSize(9);
					builder.getFont().setBold (true);
					builder.getFont().setColor(Color.BLACK);
					builder.getFont().setName(defaultFont);
					builder.writeln("[L4.Process]" + StringUtil.checkNullToBlank(selectedItemMap.get("Identifier")) + StringUtil.checkNullToBlank(selectedItemMap.get("ItemName")));
					
				    builder.startTable();
					builder.getRowFormat().clearFormatting();
					builder.getCellFormat().clearFormatting();
					
					// Make the header row.
					builder.insertCell();
					builder.getRowFormat().setHeight(20.0);
					builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
					
					// Some special features for the header row.
					builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(217, 217, 217));
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(70.0));
					builder.write(String.valueOf(menu.get("LN00028"))); // 명칭
					
					builder.insertCell();
					builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(30.0));
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					builder.write(String.valueOf(menu.get("LN00038"))); // 관계속성
					
					builder.endRow();	
					
					
					// Set features for the other rows and cells.
					// Connected Process
					if(relItemConList.size() > 0){
						builder.insertCell();
						builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(70.0));
						builder.write("Connected Process");
						
						builder.insertCell();
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(30.0));
						
						builder.endRow();
						
						for(int j=0; j<relItemConList.size(); j++){
							Map relItem = (Map) relItemConList.get(j);
						    
					    	builder.insertCell();
						    builder.getFont().setBold(false);
						    builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
							builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(70.0));
							builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						   	builder.write(StringUtil.checkNullToBlank(relItem.get("Identifier")) + StringUtil.checkNullToBlank(relItem.get("ItemName")));
							
						   	builder.insertCell();
							builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(30.0));
							builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
							builder.write(StringUtil.checkNullToBlank(relItem.get("LinkType")));
							
							builder.endRow();
						}
					}
					
					// 역할 , 양식 , 입출력마스터
					String preClassName = "";
					String ClassName = "";
					for(int j=0; j<relItemList.size(); j++){
						Map relItem = (Map) relItemList.get(j);
					    
						String CXNItemTypeCode = StringUtil.checkNullToBlank(relItem.get("CXNItemTypeCode"));
						ClassName = StringUtil.checkNullToBlank(relItem.get("ClassName"));
						if("CN00205".equals(CXNItemTypeCode) || "CN00506".equals(CXNItemTypeCode)) {
							
							if(!ClassName.equals(preClassName)){
								builder.insertCell();
								builder.getFont().setBold (true);
								builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
								builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(70.0));
								builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
								builder.write(ClassName);
								
								builder.insertCell();
								builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(30.0));
								builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
								builder.endRow();
							}
							
					    	builder.insertCell();
						    builder.getFont().setBold(false);
						    builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
						    builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(70.0));
							builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						   	builder.write(StringUtil.checkNullToBlank(relItem.get("Identifier")) + StringUtil.checkNullToBlank(relItem.get("ItemName")));
							
							builder.insertCell();
						   	builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(30.0));
							builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
							builder.write(StringUtil.checkNullToBlank(relItem.get("LinkType")));
							
							builder.endRow();
							
							preClassName = ClassName;
						}
					}
					
					builder.endTable().setAllowAutoFit(false);	
					builder.insertHtml("<br>");
					
					// 8.용어 (Terms)
					builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
					
					builder.getFont().setColor(Color.DARK_GRAY);
				    builder.getFont().setSize(11);
				    builder.getFont().setBold(true);
				    builder.getFont().setName(defaultFont);
					builder.writeln(headerNO+". " + String.valueOf(menu.get("LN00388")));
					headerNO++;
					
					builder.getFont().setSize(9);
					builder.getFont().setBold (true);
					builder.getFont().setColor(Color.BLACK);
					builder.getFont().setName(defaultFont);
					
					builder.startTable();
					builder.getRowFormat().clearFormatting();
					builder.getCellFormat().clearFormatting();
					
					// Make the header row.
					builder.insertCell();
					builder.getRowFormat().setHeight(20.0);
					builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
					
					// Some special features for the header row.
					builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(217, 217, 217));
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					
					builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(30.0));
					builder.write(String.valueOf(menu.get("LN00028"))); // 명칭
					builder.insertCell();
					builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(17.5));
					builder.write(String.valueOf(menu.get("LN00003"))); // 내용
					
					builder.endRow();
					
					for(int j=0; j<relItemList.size(); j++){
						Map relItem = (Map) relItemList.get(j);
					    
						String CXNItemTypeCode = StringUtil.checkNullToBlank(relItem.get("CXNItemTypeCode"));
						// TERMS 만
						if("CN00511".equals(CXNItemTypeCode)) {
							
					    	builder.insertCell();
						    builder.getFont().setBold(false);
						    
						    builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
							builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(30.0));
							builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						   	builder.write(StringUtil.checkNullToBlank(relItem.get("ItemName")));
							builder.insertCell();
							builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(70.0));
							builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
							builder.write(StringUtil.checkNullToBlank(relItem.get("ProcessInfo")));
							
							builder.endRow();
						}
					}
					builder.endTable().setAllowAutoFit(false);	
					builder.insertHtml("<br>");
					
					// 9.성과지표
					builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
					
					builder.getFont().setColor(Color.DARK_GRAY);
				    builder.getFont().setSize(11);
				    builder.getFont().setBold(true);
				    builder.getFont().setName(defaultFont);
					builder.writeln(headerNO+". " + String.valueOf(menu.get("ZLN0002")));
					headerNO++;
					
					builder.getFont().setSize(9);
					builder.getFont().setBold (true);
					builder.getFont().setColor(Color.BLACK);
					builder.getFont().setName(defaultFont);
					
					builder.startTable();
					builder.getRowFormat().clearFormatting();
					builder.getCellFormat().clearFormatting();
					
					// Make the header row.
					builder.insertCell();
					builder.getRowFormat().setHeight(20.0);
					builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
					
					// Some special features for the header row.
					builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(217, 217, 217));
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					
					builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(30.0));
					builder.write(String.valueOf(menu.get("ZLN0005"))); // 지표
					builder.insertCell();
					builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(17.5));
					builder.write(String.valueOf(menu.get("ZLN0006"))); // 산출식
					
					builder.endRow();
					
					String OJ00008ID = "";
					String OJ00008Value = "";
		 	 		for(int j=0; j<relItemList.size(); j++){
						Map relItem = (Map) relItemList.get(j);
						if("OJ00008".equals(String.valueOf(relItem.get("ItemTypeCode")))){
							builder.insertCell();
						    builder.getFont().setBold(false);
						    
						    builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
							builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(30.0));
							builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						   	builder.write(StringUtil.checkNullToBlank(relItem.get("ItemName")));
							builder.insertCell();
							
							OJ00008ID = StringUtil.checkNullToBlank(relItem.get("ItemID"));
							for(int k=0; k < relItemAttrbyID.size(); k++) {
								Map relID = (Map) relItemAttrbyID.get(k);
								if(OJ00008ID.equals(StringUtil.checkNullToBlank(relID.get("ItemID"))) && "AT00085".equals(StringUtil.checkNullToBlank(relID.get("AttrType")))){
									OJ00008Value = StringUtil.checkNullToBlank(relID.get("AttrValue"));
								}
							}
							builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(70.0));
							builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
							builder.write(OJ00008Value);
							
							builder.endRow();
							
						}
		 	 		}
					builder.endTable().setAllowAutoFit(false);	
					builder.insertHtml("<br>");
					
				}
		 		
		 		//[ 10. 첨부문서 목록 ] 
		 		if (String.valueOf(request.getAttribute("fileYN")).equals("on")) {
		 			builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
		 	 		builder.getFont().setColor(Color.DARK_GRAY);
				    builder.getFont().setSize(12);
				    builder.getFont().setBold(true);
				    builder.getFont().setName(defaultFont);
					builder.writeln(headerNO+". " + String.valueOf(menu.get("LN00019")));
					headerNO++;
					
					Map rowCnData = new HashMap();
			 		
					builder.startTable();
					builder.getRowFormat().clearFormatting();
					builder.getCellFormat().clearFormatting();
					
					// Make the header row.
					builder.insertCell();
					builder.getRowFormat().setHeight(20.0);
					builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
					
					// Some special features for the header row.
					builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					builder.getFont().setSize(9);
					builder.getFont().setBold (true);
					builder.getFont().setColor(Color.BLACK);
					builder.getFont().setName(defaultFont);
					
					builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(7.5));
					builder.write(String.valueOf(menu.get("LN00024"))); // No
					builder.insertCell();
					builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(23.0));
					builder.write(String.valueOf(menu.get("LN00091"))); // 문서유형
					builder.insertCell();
					builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(55.0));
					builder.write(String.valueOf(menu.get("LN00101"))); // 문서명
					builder.insertCell();
					builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(14.5));
					builder.write(String.valueOf(menu.get("LN00060"))); // 작성자
					builder.endRow();	
					
					// Set features for the other rows and cells.
					builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					
					// Reset height and define a different height rule for table body
					builder.getRowFormat().setHeight(30.0);
					builder.getRowFormat().setHeightRule(HeightRule.AUTO);
					
					
					for(int j=0; j<attachFileList.size(); j++){
						rowCnData = (HashMap) attachFileList.get(j);
					    
				    	builder.insertCell();
					    builder.getFont().setBold(false);
					    builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(7.5));
					    builder.write(StringUtil.checkNullToBlank(j+1));
					   
					   	builder.insertCell();
					   	builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(23.0));
					   	builder.write(StringUtil.checkNullToBlank(rowCnData.get("FltpName")));
						
					   	builder.insertCell();
						builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(55.0));
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						builder.write(StringUtil.checkNullToBlank(rowCnData.get("FileRealName"))); 
						
						builder.insertCell();
						builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(14.5));
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.write(StringUtil.checkNullToBlank(rowCnData.get("WriteUserNM")));
						builder.endRow();
					}	
					builder.endTable().setAllowAutoFit(false);	
				}
				//==================================================================================================
		 		
		 	} else {
		 		if (0 != modelMap.size()) {
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
	    if("pdf".equals(outputType)){
	    	fileName = "BPD_" + itemNameOfFileNm + "_" + formatter.format(date) +".pdf";
	    }
	    response.setContentType("application/msword");
	    response.setCharacterEncoding("UTF-8");
	    response.setHeader("content-disposition","attachment; filename=" + fileName);
	    
	    if("pdf".equals(outputType)){
	    	doc.save(response.getOutputStream(), SaveFormat.PDF);
	    }else{
	    	doc.save(response.getOutputStream(), SaveFormat.DOCX);
	    }
	
}catch(Exception e){
e.printStackTrace();
	
} finally{
	request.getSession(true).setAttribute("expFlag", "Y");
	
	response.getOutputStream().flush();
	response.getOutputStream().close();
}

%>
