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
 	
//  	Map e2eModelMap = (Map)request.getAttribute("e2eModelMap");
//  	Map e2eItemInfo = (Map)request.getAttribute("e2eItemInfo");
//  	Map e2eAttrMap = (Map)request.getAttribute("e2eAttrMap");
//  	Map e2eAttrNameMap = (Map)request.getAttribute("e2eAttrNameMap");
//  	Map e2eAttrHtmlMap = (Map)request.getAttribute("e2eAttrHtmlMap");
 	
 	// Map piItemInfo = (Map)request.getAttribute("piItemInfo");
 	// Map piAttrMap = (Map)request.getAttribute("piAttrMap");
 	// Map piAttrNameMap = (Map)request.getAttribute("piAttrNameMap");
 	// Map piAttrHtmlMap = (Map)request.getAttribute("piAttrHtmlMap");
 	
 	// List e2eDimResultList = (List)request.getAttribute("e2eDimResultList");
 	
 	// List subTreeItemIDList = (List)request.getAttribute("subTreeItemIDList");
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
    String imageFileName = logoPath + "logo.png";
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
    builder.write("지식정보원");
    
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
		    	builder.writeln("Process Definition Report");
// 		    }
			builder.endRow();
			
			// 3.선택한 프로세스 정보
    		builder.insertCell();
    		builder.getFont().setColor(Color.BLACK);
		    builder.getFont().setBold(true);
		    builder.getFont().setName(defaultFont);
		    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		    builder.getFont().setSize(26);
		    builder.getFont().setUnderline(0);
			builder.writeln("[ "+selectedItemPath+" ]");
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
			builder.write("지식정보원");
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
    		if (pItemList.size() > 0) { 
    			// content START	
				builder.getFont().setColor(Color.DARK_GRAY);
			    builder.getFont().setSize(14);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
			    builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			    builder.insertHtml("<br>");
			    builder.insertHtml("<br>");
				builder.writeln("\tContent"); // content
				builder.insertHtml("<br>");
				
			    builder.getFont().setSize(11);
			    builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			    
			    if (!gItem.isEmpty()) {	// L2에서 워드리포트 실행 경우
					builder.writeln("\t" + gItem.get("Identifier")+" "+gItem.get("ItemName"));
					for (int j = 0; pItemList.size() > j ; j++) {
						Map pItemMap = (Map)pItemList.get(j);
						builder.writeln("\t\t" + pItemMap.get("toItemIdentifier")+" "+pItemMap.get("toItemName"));
						
						if(mainItemList.size() > 0){
							List mainItemTemp = (List)mainItemList.get(j);
							for(int k = 0; mainItemTemp.size() > k; k++){
								Map mainItemMap = (Map)mainItemTemp.get(k);
								builder.writeln("\t\t\t" + mainItemMap.get("toItemIdentifier")+" "+mainItemMap.get("toItemName"));
							}
						}
					}
				} else {
					Map pItemMap = (Map)pItemList.get(0);
					builder.writeln("\t" + pItemMap.get("Identifier")+" "+pItemMap.get("ItemName"));
					
					List mainItemTemp = (List)mainItemList.get(0);
					for(int k = 0; mainItemTemp.size() > k; k++){
						Map mainItemMap = (Map)mainItemTemp.get(k);
						builder.writeln("\t\t" + mainItemMap.get("toItemIdentifier")+" "+mainItemMap.get("toItemName"));
					}
				}
    		}
			// content END

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
	 		List relItemList = (List)totalMap.get("relItemList");
	 		List dimResultList = (List)totalMap.get("dimResultList");
	 		//List ruleSetList = (List)totalMap.get("ruleSetList");
	 		//List kpiList = (List)totalMap.get("kpiList");
	 		//List requirementList = (List)totalMap.get("requirementList");
	 		//List attachFileList = (List)totalMap.get("attachFileList");
	 		//List toCheckList = (List)totalMap.get("toCheckList");
	 		Map attrMap = (Map)totalMap.get("attrMap");
	 		// Map attrNameMap = (Map)totalMap.get("attrNameMap");
	 		Map attrHtmlMap = (Map)totalMap.get("attrHtmlMap");
	 		Map modelMap = (Map)totalMap.get("modelMap");
	 		//Map attrRsNameMap = (Map)totalMap.get("attrRsNameMap");
	 		//Map attrRsHtmlMap = (Map)totalMap.get("attrRsHtmlMap");
	 		//Map attrToCheckNameMap = (Map)totalMap.get("attrToCheckNameMap");
	 		//Map attrToCheckHtmlMap = (Map)totalMap.get("attrToCheckHtmlMap");
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
	 	 		builder.getRowFormat().setHeight(30.0);
	 	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경
	 	 		
	 	 	 	// 1.ROW : 개요
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00003")));  // 개요
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(mergeCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		
	 	 		String AT00003 = StringUtil.checkNullToBlank(attrMap.get("AT00003")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
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
	 	 		
	 	 		// 2.ROW : 클래스
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(menu.get("LN00016")));  // 클래스
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(mergeCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		
 	 			builder.getFont().setBold(false);
 	 			builder.write(StringUtil.checkNullToBlank(rowPrcData.get("ClassName"))); // 클래스 : 내용
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 		// 3.ROW : 주관부서,유관부서
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00012")));  // 주관부서
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
 	 			builder.getFont().setBold(false);
 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00012"))); // 주관부서 : 내용
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00010")));  // 유관부서
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
 	 			builder.getFont().setBold(false);
 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00010"))); // 유관부서 : 내용
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 		// 4.ROW : 발생유형,발생주기
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00005")));  // 발생유형
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
 	 			builder.getFont().setBold(false);
 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00005"))); // 발생유형 : 내용
	 	 	
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00009")));  // 발생주기
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
 	 			builder.getFont().setBold(false);
 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00009"))); // 발생주기 : 내용
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 	// 5.ROW : 성과지표,발생시점
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00007")));  // 발생유형
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
 	 			builder.getFont().setBold(false);
 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00007"))); // 성과지표 : 내용
	 	 	
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00018")));  // 발생주기
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
 	 			builder.getFont().setBold(false);
 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00018"))); // 발생시점 : 내용
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 		// 6.ROW : 변동구분,변동이유
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00030")));  // 변동구분
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
 	 			builder.getFont().setBold(false);
 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00030"))); // 변동구분 : 내용
	 	 	
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00033")));  // 변동이유
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
 	 			builder.getFont().setBold(false);
 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00033"))); // 변동이유 : 내용
	 	 		//==================================================================================================	
	 	 		builder.endRow();
 	 			
	 	 	// 7.ROW : 개선구분,Progress
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00019")));  // 개선구분
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
 	 			builder.getFont().setBold(false);
 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00019"))); // 개선구분 : 내용
	 	 	
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00026")));  // Progress
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
 	 			builder.getFont().setBold(false);
 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00026"))); // Progress : 내용
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 	    // 8.ROW : 작성자, 수정일	 	 		
 	 			builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(menu.get("LN00060")));  // 작성자
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getFont().setBold (false);
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.write(StringUtil.checkNullToBlank(rowPrcData.get("Name"))); // 작성자 : 내용
	 	 		
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getRowFormat().setHeight(30.0);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(menu.get("LN00070"))); // 수정일
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
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
		 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
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
				builder.insertHtml("<br>");
				
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
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					builder.getFont().setSize(10);
					builder.getFont().setBold (true);
					builder.getFont().setColor(Color.BLACK);
					builder.getFont().setName(defaultFont);
					
					builder.getCellFormat().setWidth(30);
					builder.write(String.valueOf(menu.get("LN00024"))); // No

					builder.insertCell();
					builder.getCellFormat().setWidth(40);
					builder.write(String.valueOf(menu.get("LN00042"))); // 구분

					builder.insertCell();
					builder.getCellFormat().setWidth(50);
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
						builder.getCellFormat().setWidth(30);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
					   	builder.write(StringUtil.checkNullToBlank(cnProcessData.get("RNUM")));	
						
					   	builder.insertCell();
					   	builder.getCellFormat().setWidth(40);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						builder.write(StringUtil.checkNullToBlank(cnProcessData.get("LinkType")));				
						builder.insertCell();
					   	builder.getCellFormat().setWidth(50);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
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
		 				
				//3. 관련항목
				int headerNO = 3;
				Map cnAttrList = new HashMap();
				List cnAttr = new ArrayList();
				Map AttrInfoList = new HashMap();
				Map ItemAttrInfo = new HashMap();
				for(int i=0; i <relItemClassCodeList.size() ; i++){
					builder.getFont().setColor(Color.DARK_GRAY);
				    builder.getFont().setSize(11);
				    builder.getFont().setBold(true);
				    builder.getFont().setName(defaultFont);
					
					if(relItemClassCodeList.get(i).equals("CL07002")){
						builder.insertHtml("<br>");
						builder.writeln(headerNO+". "+relItemNameList.get(i));
						headerNO++;
						for(int j=0; j<relItemID.size(); j++){
							Object ItemID = relItemID.get(j);
							map = (HashMap)relItemList.get(j);
							
							if(map.containsValue(relItemClassCodeList.get(i))){
								builder.startTable();
								builder.getRowFormat().clearFormatting();
								builder.getCellFormat().clearFormatting();
								
								//==================================================================================================	
								// 1.ROW
								builder.insertCell();
								builder.getRowFormat().setHeight(30.0);
								builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);	
					 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
					 	 		builder.getCellFormat().setWidth(titleCellWidth);
					 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
					 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					 	 		builder.getFont().setBold(true);
					 	 		builder.write(String.valueOf(menu.get("LN00106"))); // ID
					 	 		
					 	 		builder.insertCell();
					 	 		builder.getCellFormat().setWidth(contentCellWidth);
					 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
					 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
					 	 		builder.getFont().setBold(false);
						 		builder.write(StringUtil.checkNullToBlank(map.get("Identifier"))); // ID : 내용
					 	 		
					 	 		builder.insertCell();
					 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
					 	 		builder.getCellFormat().setWidth(80.0);
					 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					 	 		builder.getFont().setBold (true);
					 	 		builder.write(String.valueOf(menu.get("LN00028")));  // 명칭
					 	 		
					 	 		builder.insertCell();
					 	 		builder.getCellFormat().setWidth(contentCellWidth);
					 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
					 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
					 	 		builder.getFont().setBold(false);
				 	 			builder.write(StringUtil.checkNullToBlank(map.get("ItemName"))); // 명칭 : 내용
					 	 		builder.endRow();
					 	 		//==================================================================================================	
				 	 			
					 	 		builder.getRowFormat().clearFormatting();
								builder.getCellFormat().clearFormatting();
								builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
				 	 			
								for(int k=0; k<relItemAttrbyID.size(); k++){
									cnAttrList = (Map)relItemAttrbyID.get(k);
									if(ItemID.equals(cnAttrList.get("ItemID"))){
										String AttrType = (String)cnAttrList.get("AttrType");
										AttrInfoList.put(AttrType,cnAttrList);
									}
								}
								
								
								//==================================================================================================	
								ItemAttrInfo = (Map)AttrInfoList.get("AT00003");
								// 2.ROW - 개요
								builder.insertCell();
					 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
					 	 		builder.getCellFormat().setWidth(titleCellWidth);
					 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
					 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					 	 		builder.getFont().setBold (true);
					 	 		builder.write(String.valueOf(AttrTypeList.get("AT00003")));
					 	 		
					 	 		builder.insertCell();
					 	 		builder.getCellFormat().setWidth(mergeCellWidth);
					 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
					 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
					 	 		builder.getFont().setBold(false);
					 	 		
					 	 		if(ItemAttrInfo != null){
						 	 		String AttrValue = StringUtil.checkNullToBlank(ItemAttrInfo.get("AttrValue")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
						 	 		if ("1".equals(StringUtil.checkNullToBlank(ItemAttrInfo.get("HTML")))) { // type이 HTML인 경우
						 	 			if(StringUtil.checkNullToBlank(ItemAttrInfo.get("AttrValue")).contains("font-family")){
						 	 				builder.insertHtml(AttrValue);
						 	 			}else{
						 	 				builder.insertHtml(fontFamilyHtml+AttrValue+"</span>");
						 	 			}
						 	 		} else if(ItemAttrInfo.get("LovValue") != null) {
						 	 			builder.write(StringUtil.checkNullToBlank(ItemAttrInfo.get("LovValue"))); // Lov 값
						 	 		} else {
						 	 			builder.write(StringUtil.checkNullToBlank(ItemAttrInfo.get("AttrValue"))); // 해당 속성 내용
						 	 		}
					 	 		}
					 	 		builder.endRow();	
					 	 		ItemAttrInfo = new HashMap();
					 	 		//==================================================================================================	
					 	 		
								//==================================================================================================	
					 	 		ItemAttrInfo = (Map)AttrInfoList.get("AT00004");
								// 3.ROW - 법규/규정/지침
								builder.insertCell();
					 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
					 	 		builder.getCellFormat().setWidth(titleCellWidth);
					 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
					 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					 	 		builder.getFont().setBold (true);
					 	 		builder.write(String.valueOf(AttrTypeList.get("AT00004")));
					 	 		
					 	 		builder.insertCell();
					 	 		builder.getCellFormat().setWidth(mergeCellWidth);
					 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
					 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
					 	 		builder.getFont().setBold(false);
					 	 		
					 	 		if(ItemAttrInfo != null){
						 	 		String AttrValue = StringUtil.checkNullToBlank(ItemAttrInfo.get("AttrValue")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
						 	 		if ("1".equals(StringUtil.checkNullToBlank(ItemAttrInfo.get("HTML")))) { // type이 HTML인 경우
						 	 			if(StringUtil.checkNullToBlank(ItemAttrInfo.get("AttrValue")).contains("font-family")){
						 	 				builder.insertHtml(AttrValue);
						 	 			}else{
						 	 				builder.insertHtml(fontFamilyHtml+AttrValue+"</span>");
						 	 			}
						 	 		} else if(ItemAttrInfo.get("LovValue") != null) {
						 	 			builder.write(StringUtil.checkNullToBlank(ItemAttrInfo.get("LovValue"))); // Lov 값
						 	 		} else {
						 	 			builder.write(StringUtil.checkNullToBlank(ItemAttrInfo.get("AttrValue"))); // 해당 속성 내용
						 	 		}
					 	 		}
					 	 		builder.endRow();
					 	 		ItemAttrInfo = new HashMap();
					 	 		//==================================================================================================	
					 	 		
					 	 		//==================================================================================================	
					 	 		ItemAttrInfo = (Map)AttrInfoList.get("AT00012");
								// 4.ROW - 주관부서
								builder.insertCell();
					 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
					 	 		builder.getCellFormat().setWidth(titleCellWidth);
					 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
					 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					 	 		builder.getFont().setBold (true);
					 	 		builder.write(String.valueOf(AttrTypeList.get("AT00012")));
					 	 		
					 	 		builder.insertCell();
					 	 		builder.getCellFormat().setWidth(mergeCellWidth);
					 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
					 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
					 	 		builder.getFont().setBold(false);
					 	 		
					 	 		if(ItemAttrInfo != null){
						 	 		String AttrValue = StringUtil.checkNullToBlank(ItemAttrInfo.get("AttrValue")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
						 	 		if ("1".equals(StringUtil.checkNullToBlank(ItemAttrInfo.get("HTML")))) { // type이 HTML인 경우
						 	 			if(StringUtil.checkNullToBlank(ItemAttrInfo.get("AttrValue")).contains("font-family")){
						 	 				builder.insertHtml(AttrValue);
						 	 			}else{
						 	 				builder.insertHtml(fontFamilyHtml+AttrValue+"</span>");
						 	 			}
						 	 		} else if(ItemAttrInfo.get("LovValue") != null) {
						 	 			builder.write(StringUtil.checkNullToBlank(ItemAttrInfo.get("LovValue"))); // Lov 값
						 	 		} else {
						 	 			builder.write(StringUtil.checkNullToBlank(ItemAttrInfo.get("AttrValue"))); // 해당 속성 내용
						 	 		}
					 	 		}
								builder.endRow();
								ItemAttrInfo = new HashMap();
								//==================================================================================================	
								builder.endTable().setAllowAutoFit(false);
								AttrInfoList = new HashMap();
					 	 		builder.insertHtml("<br>");
							}
						}
					}
					
					if(relItemClassCodeList.get(i).equals("CL13002")){
						builder.insertHtml("<br>");
						builder.writeln(headerNO+". "+relItemNameList.get(i));
						headerNO++;
						for(int j=0; j<relItemID.size(); j++){
							Object ItemID = relItemID.get(j);
							map = (HashMap)relItemList.get(j);
							
							if(map.containsValue(relItemClassCodeList.get(i))){
								builder.startTable();
								builder.getRowFormat().clearFormatting();
								builder.getCellFormat().clearFormatting();
								
								//==================================================================================================	
								// 1.ROW
								builder.insertCell();
								builder.getRowFormat().setHeight(30.0);
								builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);	
					 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
					 	 		builder.getCellFormat().setWidth(titleCellWidth);
					 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
					 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					 	 		builder.getFont().setBold(true);
					 	 		builder.write(String.valueOf(menu.get("LN00106"))); // ID
					 	 		
					 	 		builder.insertCell();
					 	 		builder.getCellFormat().setWidth(contentCellWidth);
					 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
					 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
					 	 		builder.getFont().setBold(false);
						 		builder.write(StringUtil.checkNullToBlank(map.get("Identifier"))); // ID : 내용
					 	 		
					 	 		builder.insertCell();
					 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
					 	 		builder.getCellFormat().setWidth(80.0);
					 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					 	 		builder.getFont().setBold (true);
					 	 		builder.write(String.valueOf(menu.get("LN00028")));  // 명칭
					 	 		
					 	 		builder.insertCell();
					 	 		builder.getCellFormat().setWidth(contentCellWidth);
					 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
					 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
					 	 		builder.getFont().setBold(false);
				 	 			builder.write(StringUtil.checkNullToBlank(map.get("ItemName"))); // 명칭 : 내용
					 	 		builder.endRow();
					 	 		//==================================================================================================	
				 	 			
					 	 		builder.getRowFormat().clearFormatting();
								builder.getCellFormat().clearFormatting();
								builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
				 	 			
								for(int k=0; k<relItemAttrbyID.size(); k++){
									cnAttrList = (Map)relItemAttrbyID.get(k);
									if(ItemID.equals(cnAttrList.get("ItemID"))){
										String AttrType = (String)cnAttrList.get("AttrType");
										AttrInfoList.put(AttrType,cnAttrList);
									}
								}
								
								//==================================================================================================	
								ItemAttrInfo = (Map)AttrInfoList.get("AT00003");
								// 2.ROW - 개요
								builder.insertCell();
					 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
					 	 		builder.getCellFormat().setWidth(titleCellWidth);
					 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
					 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					 	 		builder.getFont().setBold (true);
					 	 		builder.write(String.valueOf(AttrTypeList.get("AT00003")));
					 	 		
					 	 		builder.insertCell();
					 	 		builder.getCellFormat().setWidth(mergeCellWidth);
					 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
					 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
					 	 		builder.getFont().setBold(false);
					 	 		
					 	 		if(ItemAttrInfo != null){
						 	 		String AttrValue = StringUtil.checkNullToBlank(ItemAttrInfo.get("AttrValue")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
						 	 		if ("1".equals(StringUtil.checkNullToBlank(ItemAttrInfo.get("HTML")))) { // type이 HTML인 경우
						 	 			if(StringUtil.checkNullToBlank(ItemAttrInfo.get("AttrValue")).contains("font-family")){
						 	 				builder.insertHtml(AttrValue);
						 	 			}else{
						 	 				builder.insertHtml(fontFamilyHtml+AttrValue+"</span>");
						 	 			}
						 	 		} else if(ItemAttrInfo.get("LovValue") != null) {
						 	 			builder.write(StringUtil.checkNullToBlank(ItemAttrInfo.get("LovValue"))); // Lov 값
						 	 		} else {
						 	 			builder.write(StringUtil.checkNullToBlank(ItemAttrInfo.get("AttrValue"))); // 해당 속성 내용
						 	 		}
					 	 		}
					 	 		builder.endRow();	
					 	 		ItemAttrInfo = new HashMap();
					 	 		//==================================================================================================	
					 	 		
								//==================================================================================================	
					 	 		ItemAttrInfo = (Map)AttrInfoList.get("AT00020");
								// 3.ROW - 개선항목구분
								builder.insertCell();
					 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
					 	 		builder.getCellFormat().setWidth(titleCellWidth);
					 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
					 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					 	 		builder.getFont().setBold (true);
					 	 		builder.write(String.valueOf(AttrTypeList.get("AT00020")));
					 	 		
					 	 		builder.insertCell();
					 	 		builder.getCellFormat().setWidth(mergeCellWidth);
					 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
					 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
					 	 		builder.getFont().setBold(false);
					 	 		
					 	 		if(ItemAttrInfo != null){
						 	 		String AttrValue = StringUtil.checkNullToBlank(ItemAttrInfo.get("AttrValue")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
						 	 		if ("1".equals(StringUtil.checkNullToBlank(ItemAttrInfo.get("HTML")))) { // type이 HTML인 경우
						 	 			if(StringUtil.checkNullToBlank(ItemAttrInfo.get("AttrValue")).contains("font-family")){
						 	 				builder.insertHtml(AttrValue);
						 	 			}else{
						 	 				builder.insertHtml(fontFamilyHtml+AttrValue+"</span>");
						 	 			}
						 	 		} else if(ItemAttrInfo.get("LovValue") != null) {
						 	 			builder.write(StringUtil.checkNullToBlank(ItemAttrInfo.get("LovValue"))); // Lov 값
						 	 		} else {
						 	 			builder.write(StringUtil.checkNullToBlank(ItemAttrInfo.get("AttrValue"))); // 해당 속성 내용
						 	 		}
					 	 		}
					 	 		builder.endRow();
					 	 		ItemAttrInfo = new HashMap();
					 	 		//==================================================================================================	
					 	 		
			 	 				builder.endTable().setAllowAutoFit(false);
								AttrInfoList = new HashMap();
					 	 		builder.insertHtml("<br>");
							}
						}
					}
				}
				//
				
				//if (null != modelMap) {
		 			builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
		 		//}
		 		
		 		// 업무처리 절차 Title
		 		if (null == modelMap) {
		 			builder.insertHtml("<br>");
		 		}
		 		builder.getFont().setColor(Color.DARK_GRAY);
			    builder.getFont().setSize(11);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
				builder.writeln(headerNO+". " + String.valueOf(menu.get("LN00197")));
				headerNO++;
				
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
				
		 		// 액티비티 리스트 Title
		 		if (activityList.size() == 0) {
		 			builder.insertHtml("<br>");
		 		}
		 		builder.getFont().setColor(Color.DARK_GRAY);
			    builder.getFont().setSize(11);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
				builder.writeln(headerNO+". 업무활동 정의서");
				headerNO++;
				
				double activityCellWidth1 = 150.0;
				double activityCellWidth2 = 200.0;
				double activityCellWidth3 = 100.0;
				double activityCellWidth4 = 100.0;
				double activityCellWidth5 = 100.0;
				double activityCellWidth6 = 100.0;
				double activityCellWidth7 = 80.0;
				
				if (activityList.size() > 0) {
					Map rowActData = new HashMap();	
					List fdList = new ArrayList();
					Map fdMap = new HashMap();
					
					builder.getFont().setColor(Color.DARK_GRAY);
				    builder.getFont().setSize(10);
				    builder.getFont().setBold(true);
				    builder.getFont().setName(defaultFont);
				    
				    builder.startTable();
				    builder.getRowFormat().clearFormatting();
					builder.getCellFormat().clearFormatting();
						
					// ! 그리드 형식
					// Header Start
					builder.getRowFormat().setHeight(30.0);
					builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);	
		 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		 	 		builder.getFont().setBold (true);
		 	 		
					builder.insertCell();
		 	 		builder.getCellFormat().setWidth(activityCellWidth1);
		 	 		builder.write("업무활동명");
		 	 		
		 	 		builder.insertCell();
		 	 		builder.getCellFormat().setWidth(activityCellWidth2);
		 	 		builder.write("설명");
		 	 		
		 	 		builder.insertCell();
		 	 		builder.getCellFormat().setWidth(activityCellWidth3);
		 	 		builder.write(String.valueOf(AttrTypeList.get("AT00015")));
		 	 		
		 	 		builder.insertCell();
		 	 		builder.getCellFormat().setWidth(activityCellWidth4);
		 	 		builder.write(String.valueOf(AttrTypeList.get("AT00016")));
		 	 		
		 	 		builder.insertCell();
		 	 		builder.getCellFormat().setWidth(activityCellWidth5);
		 	 		builder.write(String.valueOf(AttrTypeList.get("AT00022")));
						
		 	 		builder.insertCell();
		 	 		builder.getCellFormat().setWidth(activityCellWidth6);
		 	 		builder.write(String.valueOf(AttrTypeList.get("AT00013")));
		 	 		
		 	 		builder.insertCell();
		 	 		builder.getCellFormat().setWidth(activityCellWidth7);
		 	 		builder.write(String.valueOf(AttrTypeList.get("AT00021")));
		 	 		builder.endRow();
		 	 		// Header End
		 	 		
					for(int j=0; j<activityList.size(); j++){
					
						rowActData = (HashMap) activityList.get(j);
						
						String itemName = StringUtil.checkNullToBlank(rowActData.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
 					    itemName = itemName.replace("&#10;", " ");
 						itemName = itemName.replace("&#xa;", "");
 						itemName = itemName.replace("&nbsp;", " ");
					
			 	 		// List Start
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getFont().setBold(false);
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(activityCellWidth1);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.write(itemName); // 업무활동명
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(activityCellWidth2);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00003"))); // 설명
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(activityCellWidth3);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00015"))); // 입력정보
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(activityCellWidth4);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00016"))); // 출력정보
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(activityCellWidth5);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00022"))); // 담당조직
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(activityCellWidth6);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00013"))); // 응용시스템
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(activityCellWidth7);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00021"))); // 기능개발
			 	 		builder.endRow();
			 	 		// List End
			 	 		
			 	 		
//						! 테이블 형식				    
// 					    builder.insertHtml("<br>");
// 					    String identifier =  StringUtil.checkNullToBlank(rowActData.get("Identifier"));
// 					    String itemName = StringUtil.checkNullToBlank(rowActData.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
// 					    itemName = itemName.replace("&#10;", " ");
// 						itemName = itemName.replace("&#xa;", "");
// 						itemName = itemName.replace("&nbsp;", " ");
// 					    builder.writeln(identifier+" "+itemName); //명칭
					    
// 					    builder.startTable();
// 						builder.getRowFormat().clearFormatting();
// 						builder.getCellFormat().clearFormatting();
						
// 						//==================================================================================================
// 						// 1.ROW - 개요
// 						builder.insertCell();
// 						builder.getRowFormat().setHeight(30.0);
// 						builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);	
// 			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
// 			 	 		builder.getCellFormat().setWidth(activityCellWidth);
// 			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
// 			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
// 			 	 		builder.getFont().setBold (true);
// 			 	 		builder.write(String.valueOf(AttrTypeList.get("AT00003")));
			 	 		
// 			 	 		builder.insertCell();
// 			 	 		builder.getCellFormat().setWidth(mergeCellWidth);
// 			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
// 			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
// 			 	 		builder.getFont().setBold(false);
			 	 		
// 			 	 		String ATVITAT00003 = StringUtil.checkNullToBlank(rowActData.get("AT00003")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
// 						if(StringUtil.checkNullToBlank(rowActData.get("AT00003")).contains("font-family")){	
// 							builder.insertHtml(ATVITAT00003);
// 		 	 			}else{
// 		 	 				builder.insertHtml(fontFamilyHtml+ATVITAT00003+"</span>");
// 		 	 			}
// 			 	 		builder.endRow();	
// 			 	 		//==================================================================================================
			 	 										
// 	 	 				//==================================================================================================	
// 						// 2.ROW
// 						builder.insertCell();
// 						builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);	
// 			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
// 			 	 		builder.getCellFormat().setWidth(activityCellWidth);
// 			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
// 			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
// 			 	 		builder.getFont().setBold(true);
// 			 	 		builder.write(String.valueOf(AttrTypeList.get("AT00015")));
			 	 		
// 			 	 		builder.insertCell();
// 			 	 		builder.getCellFormat().setWidth(contentCellWidth);
// 			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
// 			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
// 			 	 		builder.getFont().setBold(false);
// 				 		builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00015"))); // 입력정보
			 	 		
// 			 	 		builder.insertCell();
// 			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
// 			 	 		builder.getCellFormat().setWidth(activityCellWidth);
// 			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
// 			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
// 			 	 		builder.getFont().setBold (true);
// 			 	 		builder.write(String.valueOf(AttrTypeList.get("AT00016")));
			 	 		
// 			 	 		builder.insertCell();
// 			 	 		builder.getCellFormat().setWidth(contentCellWidth);
// 			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
// 			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
// 			 	 		builder.getFont().setBold(false);
// 		 	 			builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00016"))); // 출력정보
// 			 	 		builder.endRow();
// 			 	 		//==================================================================================================	
			 	 				
// 						//==================================================================================================	
// 						// 3.ROW
// 						builder.insertCell();
// 						builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);	
// 			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
// 			 	 		builder.getCellFormat().setWidth(activityCellWidth);
// 			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
// 			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
// 			 	 		builder.getFont().setBold(true);
// 			 	 		builder.write(String.valueOf(AttrTypeList.get("AT00022")));
			 	 		
// 			 	 		builder.insertCell();
// 			 	 		builder.getCellFormat().setWidth(contentCellWidth);
// 			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
// 			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
// 			 	 		builder.getFont().setBold(false);
// 				 		builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00022"))); // 담당
			 	 		
// 			 	 		builder.insertCell();
// 			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
// 			 	 		builder.getCellFormat().setWidth(activityCellWidth);
// 			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
// 			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
// 			 	 		builder.getFont().setBold (true);
// 			 	 		builder.write(String.valueOf(AttrTypeList.get("AT00013")));
			 	 		
// 			 	 		builder.insertCell();
// 			 	 		builder.getCellFormat().setWidth(contentCellWidth);
// 			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
// 			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
// 			 	 		builder.getFont().setBold(false);
// 		 	 			builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00013"))); // 응용시스템
// 			 	 		builder.endRow();
// 			 	 		//==================================================================================================	
			 	 				
// 			 	 		//==================================================================================================	
// 						// 4.ROW
// 						builder.insertCell();
// 						builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);	
// 			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
// 			 	 		builder.getCellFormat().setWidth(activityCellWidth);
// 			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
// 			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
// 			 	 		builder.getFont().setBold(true);
// 			 	 		builder.write(String.valueOf(AttrTypeList.get("AT00037")));
			 	 		
// 			 	 		builder.insertCell();
// 			 	 		builder.getCellFormat().setWidth(contentCellWidth);
// 			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
// 			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
// 			 	 		builder.getFont().setBold(false);
// 				 		builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00037"))); // 시스템/매뉴얼
			 	 		
// 			 	 		builder.insertCell();
// 			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
// 			 	 		builder.getCellFormat().setWidth(activityCellWidth);
// 			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
// 			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
// 			 	 		builder.getFont().setBold (true);
// 			 	 		builder.write(String.valueOf(AttrTypeList.get("AT00021")));
			 	 		
// 			 	 		builder.insertCell();
// 			 	 		builder.getCellFormat().setWidth(contentCellWidth);
// 			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
// 			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
// 			 	 		builder.getFont().setBold(false);
// 		 	 			builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00021"))); // 기능개발
// 			 	 		builder.endRow();
// 			 	 		//==================================================================================================						
// 						builder.endTable().setAllowAutoFit(false);
			 	 		
			 	 		String AT00021 = StringUtil.checkNullToBlank(rowActData.get("AT00021"));
			 	 		if(!AT00021.equals("")){
			 	 			fdList.add(rowActData);
			 	 		}
					}
					builder.endTable().setAllowAutoFit(false);
					builder.getRowFormat().clearFormatting();
					builder.getCellFormat().clearFormatting();
					
					if(fdList.size() > 0){
						builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
						
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						builder.getFont().setColor(Color.DARK_GRAY);
					    builder.getFont().setSize(11);
					    builder.getFont().setBold(true);
					    builder.getFont().setName(defaultFont);
						builder.writeln(headerNO+". 기능정의서");
						
						builder.startTable();
						builder.getRowFormat().clearFormatting();
						builder.getCellFormat().clearFormatting();
						
						// ! 그리드 형식
						// Header Start
						builder.getFont().setSize(10);
						builder.getRowFormat().setHeight(30.0);
						builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		
						builder.insertCell();
			 	 		builder.getCellFormat().setWidth(activityCellWidth1);
			 	 		builder.write("활동");
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(activityCellWidth1);
			 	 		builder.write("관련 내부 시스템");
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(activityCellWidth2);
			 	 		builder.write(String.valueOf(AttrTypeList.get("AT00024")));
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(activityCellWidth1);
			 	 		builder.write(String.valueOf(AttrTypeList.get("AT00023")));
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(activityCellWidth6);
			 	 		builder.write(String.valueOf(AttrTypeList.get("AT00029")));
			 	 		builder.endRow();
			 	 		// Header End
					
						for(int i = 0; fdList.size() > i; i++){
							fdMap = (Map)fdList.get(i);
							
						    String itemName = StringUtil.checkNullToBlank(fdMap.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
						    itemName = itemName.replace("&#10;", " ");
							itemName = itemName.replace("&#xa;", "");
							itemName = itemName.replace("&nbsp;", " ");
							
				 	 		// List Start
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getFont().setBold(false);
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getCellFormat().setWidth(activityCellWidth1);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.write(itemName); // 업무활동명
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getCellFormat().setWidth(activityCellWidth1);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.write(StringUtil.checkNullToBlank(fdMap.get("AT00013"))); // 관련 내부 시스템
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getCellFormat().setWidth(activityCellWidth2);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.write(StringUtil.checkNullToBlank(fdMap.get("AT00024"))); // 필요 기능 설명
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getCellFormat().setWidth(activityCellWidth1);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.write(StringUtil.checkNullToBlank(fdMap.get("AT00023"))); // 연계 필요시스템 또는 기관
				 	 		
				 	 		builder.insertCell();
				 	 		builder.getCellFormat().setWidth(activityCellWidth6);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.write(StringUtil.checkNullToBlank(fdMap.get("AT00029"))); // 관련 주요 정보
				 	 		builder.endRow();
				 	 		// List End
						
						
// 						//==================================================================================================
// 						// 1.ROW - 개요
// 						builder.insertCell();
// 						builder.getRowFormat().setHeight(30.0);
// 						builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);	
// 			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
// 			 	 		builder.getCellFormat().setWidth(activityCellWidth);
// 			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
// 			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
// 			 	 		builder.getFont().setBold (true);
// 			 	 		builder.write(String.valueOf(AttrTypeList.get("AT00001")));
			 	 		
// 			 	 		builder.insertCell();
// 			 	 		builder.getCellFormat().setWidth(mergeCellWidth);
// 			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
// 			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
// 			 	 		builder.getFont().setBold(false);
// 		 	 			builder.write(StringUtil.checkNullToBlank(itemName)); // 명칭
// 			 	 		builder.endRow();
// 			 	 		//==================================================================================================
			 	 			
// 						//==================================================================================================	
// 						// 2.ROW
// 						builder.insertCell();
// 						builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);	
// 			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
// 			 	 		builder.getCellFormat().setWidth(activityCellWidth);
// 			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
// 			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
// 			 	 		builder.getFont().setBold(true);
// 			 	 		builder.write(String.valueOf(AttrTypeList.get("AT00013")));
			 	 		
// 			 	 		builder.insertCell();
// 			 	 		builder.getCellFormat().setWidth(contentCellWidth);
// 			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
// 			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
// 			 	 		builder.getFont().setBold(false);
// 				 		builder.write(StringUtil.checkNullToBlank(fdMap.get("AT00013"))); // 응용시스템
			 	 		
// 			 	 		builder.insertCell();
// 			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
// 			 	 		builder.getCellFormat().setWidth(activityCellWidth);
// 			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
// 			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
// 			 	 		builder.getFont().setBold (true);
// 			 	 		builder.write(String.valueOf(AttrTypeList.get("AT00024")));
			 	 		
// 			 	 		builder.insertCell();
// 			 	 		builder.getCellFormat().setWidth(contentCellWidth);
// 			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
// 			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
// 			 	 		builder.getFont().setBold(false);
// 		 	 			builder.write(StringUtil.checkNullToBlank(fdMap.get("AT00024"))); // 필요기능설명
// 			 	 		builder.endRow();
// 			 	 		//==================================================================================================	
			 	 				
// 			 	 		//==================================================================================================	
// 						// 3.ROW
// 						builder.insertCell();
// 						builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);	
// 			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
// 			 	 		builder.getCellFormat().setWidth(activityCellWidth);
// 			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
// 			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
// 			 	 		builder.getFont().setBold(true);
// 			 	 		builder.write(String.valueOf(AttrTypeList.get("AT00023")));
			 	 		
// 			 	 		builder.insertCell();
// 			 	 		builder.getCellFormat().setWidth(contentCellWidth);
// 			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
// 			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
// 			 	 		builder.getFont().setBold(false);
// 				 		builder.write(StringUtil.checkNullToBlank(fdMap.get("AT00023"))); // 연계필요 시스템/기관
			 	 		
// 			 	 		builder.insertCell();
// 			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
// 			 	 		builder.getCellFormat().setWidth(activityCellWidth);
// 			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
// 			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
// 			 	 		builder.getFont().setBold (true);
// 			 	 		builder.write(String.valueOf(AttrTypeList.get("AT00029")));
			 	 		
// 			 	 		builder.insertCell();
// 			 	 		builder.getCellFormat().setWidth(contentCellWidth);
// 			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
// 			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
// 			 	 		builder.getFont().setBold(false);
// 		 	 			builder.write(StringUtil.checkNullToBlank(fdMap.get("AT00029"))); // 관련주요정보
// 			 	 		builder.endRow();
// 			 	 		//==================================================================================================						
						}
						builder.endTable().setAllowAutoFit(false);
					}
				//==================================================================================================
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
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
	}
}catch(Exception e){
e.printStackTrace();
	
} finally{
	request.getSession(true).setAttribute("expFlag", "Y");
	
	response.getOutputStream().flush();
	response.getOutputStream().close();
}

%>
