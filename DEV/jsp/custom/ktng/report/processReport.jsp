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
 	String itemIdOfFileNm = String.valueOf(selectedItemMap.get("Identifier"));
 	System.out.println("itemIdOfFileNm = "+itemIdOfFileNm);
 	Map gItem = (Map)request.getAttribute("gItem");
 	List pItemList = (List)request.getAttribute("pItemList");
 	List mainItemList = (List)request.getAttribute("mainItemList");
 	
 	double titleCellWidth = 170.0;
 	double titleCellWidth2 = 95.0;
 	double contentCellWidth3 = 95.0;
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
//     builder.getCellFormat().setWidth(200.0);
	builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(100 / 3));
    String imageFileName = logoPath + "logo_KTNG.png";
//     String imageFileName2 = logoPath + "logo_footer.png";
//     builder.insertImage(imageFileName2, 125, 25);
    builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	builder.write("ERP 사내 시스템명"); //하단
 	// 3.footer : current page / total page 
    builder.insertCell();
//     builder.getCellFormat().setWidth(200.0);
    // Set first cell to 1/3 of the page width.
    builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(100 / 3));
    // Insert page numbering text here.
    // It uses PAGE and NUMPAGES fields to auto calculate current page number and total number of pages.
    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
    builder.insertField("PAGE", "");
    builder.write(" / ");
    builder.insertField("NUMPAGES", "");
    
    builder.insertCell();
	builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(100 / 3));
 	builder.getParagraphFormat().setAlignment(ParagraphAlignment.RIGHT);
	builder.write("KT&G Corp."); //하단
    
 	// 4.footer : current page / total page 
    builder.insertCell();
//     builder.getCellFormat().setWidth(200.0);
	builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(100 / 3));
    builder.getParagraphFormat().setAlignment(ParagraphAlignment.RIGHT);
    //builder.write("Hyundai Mobis Co., Ltd."); //하단
    
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
//     		builder.insertImage(imageFileName, 180, 70);
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
		    	builder.writeln("Process & System User Manual");
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
			builder.getCellFormat().setHorizontalMerge(CellMerge.FIRST);
			//builder.write(String.valueOf(menu.get("LN00060"))); // 작성자
			builder.write("Process Owner"); // 작성자

			builder.insertCell();
			builder.getCellFormat().setWidth(200);
			//builder.write(String.valueOf(menu.get("LN00131"))); // 프로젝트
			builder.write(String.valueOf(menu.get("LN00018"))); // 관리조직

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
		   	builder.getCellFormat().setWidth(60);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(StringUtil.checkNullToBlank(titleItemMap.get("TeamName")));
			builder.insertCell();
		   	builder.getCellFormat().setWidth(60);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(StringUtil.checkNullToBlank(titleItemMap.get("Name")));
			
			builder.insertCell();
		   	builder.getCellFormat().setWidth(200);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(StringUtil.checkNullToBlank(titleItemMap.get("TeamName")));
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
				builder.getFont().setColor(Color.BLACK);
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
    		builder.insertImage(imageFileName, 95, 45);

			builder.insertCell();
			builder.getCellFormat().setWidth(420);
			name = StringUtil.checkNullToBlank(rowPrcData.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
	 	   	name = name.replace("&#10;", " ");
	 	   	name = name.replace("&#xa;", "");
	 	    name = name.replace("&nbsp;", " ");
	 	    builder.write("Process & System User Manual"); 
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
	 	 		builder.getFont().setColor(Color.BLACK);
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
	 	 	
// 	 	 		// 11.ROW (Dimension 정보 만큼 행 표시)
 	 	 		for(int j=0; j<dimResultList.size(); j++){
 	 	 			Map dimResultMap = (Map) dimResultList.get(j);
		 	 		if(String.valueOf(dimResultMap.get("dimTypeName")).equals("법인")){
		 	 			builder.insertCell();
	 		 	 		//==================================================================================================	
	 		 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 		 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 		 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
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
 	 	 		}
	 	 		
	 	 	// 1.ROW : 개요	 	 	 	
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold(true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00003")));  // 개요
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(totalCellWidth);
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
	 	 		
	 	 		// 2.ROW : 클래스, Frequency
	 	 		builder.insertCell();	
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold(true);
	 	 		builder.write(String.valueOf(menu.get("LN00016")));  // 클래스
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getFont().setBold(false);
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.write(StringUtil.checkNullToBlank(rowPrcData.get("ClassName"))); // 클래스 : 내용
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold(true);
	 	 		builder.write("Frequency");  // Frequency
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getFont().setBold(false);
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.write(""); // Frequency : 내용
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 			 	 		
	 	 		// 3.ROW : Input,Output
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold(true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00015")));  // Input
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		
	 	 		String AT00015 = StringUtil.checkNullToBlank(attrMap.get("AT00015")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00015")))) { // type이 HTML인 경우
	 	 			if(StringUtil.checkNullToBlank(attrMap.get("AT00015")).contains("font-family")){
	 	 				builder.insertHtml(AT00015);
	 	 			}else{
	 	 				builder.insertHtml(fontFamilyHtml+AT00015+"</span>");
	 	 			}
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00015"))); // Input : 내용
	 	 		}
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold(true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00016")));  // Output
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		
	 	 		String AT00016 = StringUtil.checkNullToBlank(attrMap.get("AT00016")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00016")))) { // type이 HTML인 경우
	 	 			if(StringUtil.checkNullToBlank(attrMap.get("AT00016")).contains("font-family")){
	 	 				builder.insertHtml(AT00016);
	 	 			}else{
	 	 				builder.insertHtml(fontFamilyHtml+AT00016+"</span>");
	 	 			}
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00016"))); // Output : 내용
	 	 		}
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 		// 4.ROW : 비고	 	 	 	
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold(true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00006")));  // 비고
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(totalCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00006"))); // 비고 : 내용
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 	    //5.ROW : 조직, 작성자
 	 			builder.insertCell();
 	 			//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold(true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00017")));  // 조직
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getFont().setBold(false);
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00017"))); // 조직 : 내용
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold(true);
	 	 		builder.write(String.valueOf(menu.get("LN00060")));  // 작성자
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getFont().setBold(false);
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.write(StringUtil.checkNullToBlank(rowPrcData.get("Name"))); // 작성자 : 내용
	 	 		//==================================================================================================	
	 	 		builder.endRow(); 	 		
	 	 	
	 	 		// 6.ROW : 수정일	 	 	 	
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getRowFormat().setHeight(30.0);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold(true);
	 	 		builder.write(String.valueOf(menu.get("LN00070"))); // 수정일
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
		 		builder.write(StringUtil.checkNullToBlank(rowPrcData.get("LastUpdated"))); // 수정일 : 내용
	 	 		//==================================================================================================	
	 	 		builder.endRow();

	 	 		
	 	 		builder.endTable().setAllowAutoFit(false);
	 	 		
	 	 		builder.insertHtml("<br>");
	 	 		builder.insertHtml("<br>");
	 	 		
	 	 		int headerNO = 2;
		 		
/* 		 	// 3. 기능요구사항, 변화사항(ASIS), 변화사항(TOBE)
				builder.writeln(headerNO+". " + String.valueOf(AttrTypeList.get("AT00049"))
						+", "+String.valueOf(AttrTypeList.get("AT00030"))+", "+String.valueOf(AttrTypeList.get("AT00054"))+", "+String.valueOf(AttrTypeList.get("AT00042")));
				headerNO++;
				
			    builder.getFont().setSize(10);
			    builder.getFont().setColor(Color.BLACK);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
			    
			    builder.startTable();
				builder.getRowFormat().clearFormatting();
				builder.getCellFormat().clearFormatting();
				
				//==================================================================================================	
				// 3-1.기능요구사항
				builder.insertCell();
				builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
				builder.getRowFormat().setHeight(30.0);
				builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);	
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold(true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00049"))); // 기능요구사항
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(mergeCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
		 		String AT00049 = StringUtil.checkNullToBlank(attrMap.get("AT00049")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00049")))) { // type이 HTML인 경우
	 	 			if(StringUtil.checkNullToBlank(attrMap.get("AT00049")).contains("font-family")){
	 	 				builder.insertHtml(AT00049);
	 	 			}else{
	 	 				builder.insertHtml(fontFamilyHtml+AT00049+"</span>");
	 	 			}
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(AT00049); // 기능요구사항 : 내용
	 	 		}
		 		builder.endRow();
		 		
		 		// 3-2. 변화사항(ASIS)
				builder.insertCell();
				builder.getRowFormat().setHeight(30.0);
				builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold(true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00030"))); // 변화사항(ASIS)
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(mergeCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
		 		builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00030"))); // 변화사항(ASIS) : 내용
		 		builder.endRow();
		 		
		 		// 3-3. 변화사항(TOBE)
				builder.insertCell();
				builder.getRowFormat().setHeight(30.0);
				builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold(true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00054"))); // 변화사항(TOBE)
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(mergeCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
		 		builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00054"))); // 변화사항(TOBE) : 내용
		 		builder.endRow();
		 		builder.endTable().setAllowAutoFit(false);
		 		
		 		// 3-4. Business Rule
				builder.insertCell();
				builder.getRowFormat().setHeight(30.0);
				builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold(true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00042"))); // Business Rule
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(mergeCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
		 		String AT00042 = StringUtil.checkNullToBlank(attrMap.get("AT00042")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00042")))) { // type이 HTML인 경우
	 	 			if(StringUtil.checkNullToBlank(attrMap.get("AT00042")).contains("font-family")){
	 	 				builder.insertHtml(AT00042);
	 	 			}else{
	 	 				builder.insertHtml(fontFamilyHtml+AT00042+"</span>");
	 	 			}
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(AT00042); // Business Rule : 내용
	 	 		}
		 		builder.endRow();
		 		builder.endTable().setAllowAutoFit(false); */
		 		
		 	// 3. 기능요구사항, 변화사항(ASIS), 변화사항(TOBE)
				builder.writeln(headerNO+". " + String.valueOf(AttrTypeList.get("AT00042"))
						+", "+String.valueOf(AttrTypeList.get("AT00075")));
				headerNO++;
				
			    builder.getFont().setSize(10);
			    builder.getFont().setColor(Color.BLACK);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
			    
			    builder.startTable();
				builder.getRowFormat().clearFormatting();
				builder.getCellFormat().clearFormatting();
				
				//==================================================================================================	
				// 3-1.기능요구사항
				builder.insertCell();
				builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
				builder.getRowFormat().setHeight(30.0);
				builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);	
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold(true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00042"))); // 기능요구사항
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(mergeCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
		 		String AT00042 = StringUtil.checkNullToBlank(attrMap.get("AT00042")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00042")))) { // type이 HTML인 경우
	 	 			if(StringUtil.checkNullToBlank(attrMap.get("AT00042")).contains("font-family")){
	 	 				builder.insertHtml(AT00042);
	 	 			}else{
	 	 				builder.insertHtml(fontFamilyHtml+AT00042+"</span>");
	 	 			}
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(AT00042); // 기능요구사항 : 내용
	 	 		}
		 		builder.endRow();
		 		
		 		// 3-2. RCM
				builder.insertCell();
				builder.getRowFormat().setHeight(30.0);
				builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold(true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00075"))); // 변화사항(ASIS)
	 	 		

				String relItemIdString = "";
				for(int j=0; j<relItemID.size(); j++){
					Object ItemID = relItemID.get(j);
					map = (HashMap)relItemList.get(j);
					relItemIdString += map.get("Identifier") + " " + map.get("ItemName") + (relItemID.size()-1 == j ? "" : "\n" );
				}	 	 		
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(mergeCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
		 		builder.write(relItemIdString); // 변화사항(ASIS) : 내용
		 		builder.endRow();
		 		builder.endTable().setAllowAutoFit(false);
		 							
				//==================================================================================================
		 				
				//3. 관련항목
// 				Map cnAttrList = new HashMap();
// 				List cnAttr = new ArrayList();
// 				Map AttrInfoList = new HashMap();
// 				Map ItemAttrInfo = new HashMap();
// 				for(int i=0; i <relItemClassCodeList.size() ; i++){
// 					builder.getFont().setColor(Color.BLACK);
// 				    builder.getFont().setSize(11);
// 				    builder.getFont().setBold(true);
// 				    builder.getFont().setName(defaultFont);
					
// 					if(relItemClassCodeList.get(i).equals("CL07002")){
// 				 		builder.insertHtml("<br>");
// 						builder.writeln(headerNO+". "+relItemNameList.get(i));
// 						headerNO++;
						
// 						builder.startTable();			
// 						builder.getRowFormat().clearFormatting();
// 						builder.getCellFormat().clearFormatting();
						
// 						// Make the header row.
// 						builder.insertCell();
// 						builder.getRowFormat().setHeight(20.0);
// 						builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
						
// 						// Some special features for the header row.
// 						builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
// 						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
// 						builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
// 						builder.getFont().setSize(10);
// 						builder.getFont().setBold (true);
// 						builder.getFont().setColor(Color.BLACK);
// 						builder.getFont().setName(defaultFont);
						
// 						builder.getCellFormat().setWidth(40);
// 						builder.write(String.valueOf(menu.get("LN00024"))); // No
	
// 						builder.insertCell();
// 						builder.getCellFormat().setWidth(450);
// 						builder.write(String.valueOf(AttrTypeList.get("AT00003"))); // 개요
						
// 						builder.insertCell();
// 						builder.getCellFormat().setWidth(100);
// 						builder.write(String.valueOf(AttrTypeList.get("AT00019"))); // 개요
// 						builder.endRow();	
						
// 						// Set features for the other rows and cells.
// 						builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
// 						builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
						
// 						// Reset height and define a different height rule for table body
// 						builder.getRowFormat().setHeight(30.0);
// 						builder.getRowFormat().setHeightRule(HeightRule.AUTO);
						
// 						int No = 1;
// 						for(int j=0; j<relItemID.size(); j++){
// 							Object ItemID = relItemID.get(j);
// 							map = (HashMap)relItemList.get(j);
							
// 							if(map.containsValue(relItemClassCodeList.get(i))){
// 								for(int k=0; k<relItemAttrbyID.size(); k++){
// 									cnAttrList = (Map)relItemAttrbyID.get(k);
// 									if(ItemID.equals(cnAttrList.get("ItemID"))){
// 										String AttrType = (String)cnAttrList.get("AttrType");
// 										AttrInfoList.put(AttrType,cnAttrList);
// 									}
// 								}
								
// 								builder.getFont().setBold (false);
// 								builder.insertCell();
// 					 	 		builder.getCellFormat().setWidth(40);
// 					 	 		builder.write(Integer.toString(No++));
					 	 		
// 					 	 		ItemAttrInfo = (Map)AttrInfoList.get("AT00003");
// 					 	 		builder.insertCell();
// 					 	 		builder.getCellFormat().setWidth(450);
// 					 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
// 					 	 		if(ItemAttrInfo != null){
// 						 	 		String AttrValue = StringUtil.checkNullToBlank(ItemAttrInfo.get("AttrValue")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
// 						 	 		if ("1".equals(StringUtil.checkNullToBlank(ItemAttrInfo.get("HTML")))) { // type이 HTML인 경우
// 						 	 			if(StringUtil.checkNullToBlank(ItemAttrInfo.get("AttrValue")).contains("font-family")){
// 						 	 				builder.insertHtml(AttrValue);
// 						 	 			}else{
// 						 	 				builder.insertHtml(fontFamilyHtml+AttrValue+"</span>");
// 						 	 			}
// 						 	 		} else if(ItemAttrInfo.get("LovValue") != null) {
// 						 	 			builder.write(StringUtil.checkNullToBlank(ItemAttrInfo.get("LovValue"))); // Lov 값
// 						 	 		} else {
// 						 	 			builder.write(StringUtil.checkNullToBlank(ItemAttrInfo.get("AttrValue"))); // 해당 속성 내용
// 						 	 		}
// 					 	 		}
// 					 	 		ItemAttrInfo = new HashMap();
					 	 		
// 					 	 		ItemAttrInfo = (Map)AttrInfoList.get("AT00019");
// 					 	 		builder.insertCell();
// 					 	 		builder.getCellFormat().setWidth(100);
// 					 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
// 					 	 		if(ItemAttrInfo != null){
// 						 	 		String AttrValue = StringUtil.checkNullToBlank(ItemAttrInfo.get("AttrValue")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
// 						 	 		if ("1".equals(StringUtil.checkNullToBlank(ItemAttrInfo.get("HTML")))) { // type이 HTML인 경우
// 						 	 			if(StringUtil.checkNullToBlank(ItemAttrInfo.get("AttrValue")).contains("font-family")){
// 						 	 				builder.insertHtml(AttrValue);
// 						 	 			}else{
// 						 	 				builder.insertHtml(fontFamilyHtml+AttrValue+"</span>");
// 						 	 			}
// 						 	 		} else if(ItemAttrInfo.get("LovValue") != null) {
// 						 	 			builder.write(StringUtil.checkNullToBlank(ItemAttrInfo.get("LovValue"))); // Lov 값
// 						 	 		} else {
// 						 	 			builder.write(StringUtil.checkNullToBlank(ItemAttrInfo.get("AttrValue"))); // 해당 속성 내용
// 						 	 		}
// 					 	 		}
// 					 	 		ItemAttrInfo = new HashMap();
					 	 		
// 					 	 		builder.endRow();
// 								AttrInfoList = new HashMap();
// 							}
// 						}
// 						builder.endTable().setAllowAutoFit(false);
// 					}
// 				}
				//
				
				//if (null != modelMap) {
		 			builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
		 		//}
		 		
		 		// 업무처리 절차 Title
		 		if (null == modelMap) {
		 			builder.insertHtml("<br>");
		 		}
		 		builder.getFont().setColor(Color.BLACK);
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
	 	 		
	 	 		builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);

	 	 		// 2. 선/후행 프로세스
	 	 		builder.getFont().setColor(Color.BLACK);
			    builder.getFont().setSize(11);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
				builder.writeln(headerNO+". " + String.valueOf(menu.get("LN00178"))+"Process");
				headerNO++;
				
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
					
					builder.getCellFormat().setWidth(30);
					builder.write(String.valueOf(menu.get("LN00024"))); // No

					builder.insertCell();
					builder.getCellFormat().setWidth(40);
					builder.write(String.valueOf(menu.get("LN00042"))); // 구분

					builder.insertCell();
					builder.getCellFormat().setWidth(80);
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
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					   	builder.write(StringUtil.checkNullToBlank(cnProcessData.get("RNUM")));	
						
					   	builder.insertCell();
					   	builder.getCellFormat().setWidth(40);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						builder.write(StringUtil.checkNullToBlank(cnProcessData.get("LinkType")));				
						builder.insertCell();
					   	builder.getCellFormat().setWidth(80);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						builder.write(StringUtil.checkNullToBlank(cnProcessData.get("ID")));				
						builder.insertCell();
					   	builder.getCellFormat().setWidth(140);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						builder.write(itemName);				
						builder.insertCell();
						builder.getCellFormat().setWidth(300);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						
						if(StringUtil.checkNullToBlank(processInfo).contains("font-family")){	
							builder.insertHtml(processInfo);
		 	 			}else{
		 	 				builder.insertHtml(fontFamilyHtml+processInfo+"</span>",false);
		 	 			}
						
						builder.endRow();
					}	
					
					builder.endTable().setAllowAutoFit(false);	
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
			 		builder.getFont().setColor(Color.BLACK);
				    builder.getFont().setSize(11);
				    builder.getFont().setBold(true);
				    builder.getFont().setName(defaultFont);
					builder.writeln(headerNO+". " + String.valueOf(menu.get("LN00151")));
					if (activityList.size() > 0) {
						Map rowActData = new HashMap();	
						for(int j=0; j<activityList.size(); j++){
							rowActData = (HashMap) activityList.get(j);
							
							builder.getFont().setColor(new Color(0,112,192));
						    builder.getFont().setSize(11);
						    builder.getFont().setBold(true);
						    builder.getFont().setName(defaultFont);
						    
						    String identifier =  StringUtil.checkNullToBlank(rowActData.get("Identifier"));
						    String itemName = StringUtil.checkNullToBlank(rowActData.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
						    itemName = itemName.replace("&#10;", " ");
							itemName = itemName.replace("&#xa;", "");
							itemName = itemName.replace("&nbsp;", " ");
						    builder.writeln(identifier+" "+itemName); //명칭

							builder.getFont().setColor(Color.BLACK);
							builder.writeln("[GuideLine]");// GuideLine
							builder.getFont().setBold(false);
							builder.getFont().setSize(10);
							
							String ATVITAT00003 = StringUtil.checkNullToBlank(rowActData.get("AT00008")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
							if(StringUtil.checkNullToBlank(rowActData.get("AT00008")).contains("font-family")){	
								builder.insertHtml(ATVITAT00003);
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+ATVITAT00003+"</span>",false);
			 	 			}
							builder.insertHtml("<br>");
							builder.getFont().setSize(11);
							builder.getFont().setBold(true);
							builder.write("[Role] "); // 담당
							builder.getFont().setBold(false);
							builder.getFont().setSize(10);
							builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00010")));
							builder.insertHtml("<br>");
							
							builder.getFont().setSize(11);
							builder.getFont().setBold(true);
							builder.write("[System] ");
							builder.getFont().setBold(false);
							builder.getFont().setSize(10);
							builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00013")));
							builder.insertHtml("<br>");
							
							if(rowActData.get("AT00037") != null && !rowActData.get("AT00037").equals("")){
								builder.getFont().setSize(11);
								builder.getFont().setBold(true);
								builder.write("[APPlication Type] ");
								builder.getFont().setBold(false);
								builder.getFont().setSize(10);
								builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00037"))); // APPlication Type
								builder.insertHtml("<br>");
							}
							builder.insertHtml("<br>");

							if(rowActData.get("AT00013") != null && !rowActData.get("AT00013").equals("")){
								builder.getFont().setSize(11);
								builder.getFont().setBold(true);
								builder.write("[모듈/APP] ");
								builder.getFont().setBold(false);
								builder.getFont().setSize(10);
								builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00013"))); // APPlication Type
								builder.insertHtml("<br>");
							}
							builder.insertHtml("<br>");
							
							if(rowActData.get("AT00014") != null && !rowActData.get("AT00014").equals("")){
								builder.getFont().setSize(11);
								builder.getFont().setBold(true);
								builder.write("[T-Code] ");
								builder.getFont().setBold(false);
								builder.getFont().setSize(10);
								builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00014"))); // T-Code
								builder.insertHtml("<br>");
							}
							builder.insertHtml("<br>");
							
							if(rowActData.get("AT00039") != null && !rowActData.get("AT00039").equals("")){
								builder.getFont().setSize(11);
								builder.getFont().setBold(true);
								builder.write("[Fiori ID] ");
								builder.getFont().setBold(false);
								builder.getFont().setSize(10);
								builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00039"))); // Fiori ID
								builder.insertHtml("<br>");
							}
							builder.insertHtml("<br>");
						}
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
	    String fileName = "BPD_" + itemIdOfFileNm + "_" +  itemNameOfFileNm +".docx";
	    if(outputType.equals("pdf")){
	    	fileName = "BPD_" + itemIdOfFileNm + "_" + itemNameOfFileNm +".pdf";
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
