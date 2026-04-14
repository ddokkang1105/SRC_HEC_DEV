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
 	
 	String selectedItemPath = String.valueOf(request.getAttribute("selectedItemPath"));
 	String reportCode = String.valueOf(request.getAttribute("reportCode"));
 	
 	Map selectedItemMap = (Map)request.getAttribute("selectedItemMap");
 	Map gItem = (Map)request.getAttribute("gItem");
 	List pItemList = (List)request.getAttribute("pItemList");
 	List mainItemList = (List)request.getAttribute("mainItemList");
 	
 	double titleCellWidth = 170.0;
 	double titleCellWidth2 = 135.0;
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
//     String imageFileName2 = logoPath + "logo_footer.png";
//     builder.insertImage(imageFileName2, 125, 25);
    builder.write("HYUNDAI KEFICO KPAL");
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
		    builder.getFont().setSize(26);
		    builder.getFont().setUnderline(0);
			builder.writeln(StringUtil.checkNullToBlank(titleItemMap.get("ItemName")));
			builder.insertHtml("<br>");
			builder.writeln("[Rev."+StringUtil.checkNullToBlank(titleItemMap.get("Version"))+"]");
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
			
			builder.getCellFormat().setWidth(100);
			builder.write("문서번호"); // 문서번호
			
			builder.insertCell();
			builder.getCellFormat().setWidth(100);
			builder.write(String.valueOf(menu.get("LN00356"))); // 개정번호
			
			builder.insertCell();
			builder.getCellFormat().setWidth(100);
			builder.write(String.valueOf(menu.get("LN00357"))); // 개정일자
			
			builder.insertCell();
			builder.getCellFormat().setWidth(100);
			builder.write(String.valueOf(menu.get("LN00018"))); // 관리조직
			
			builder.endRow();
			
			// Set features for the other rows and cells.
			builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			
			// Reset height and define a different height rule for table body
			builder.getRowFormat().setHeight(30.0);
			builder.getRowFormat().setHeightRule(HeightRule.AUTO);
			
			builder.insertCell();
			builder.getCellFormat().setWidth(100);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(StringUtil.checkNullToBlank(titleItemMap.get("Identifier")));
			
			builder.insertCell();
		   	builder.getCellFormat().setWidth(100);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(StringUtil.checkNullToBlank(titleItemMap.get("Version")));
			
			builder.insertCell();
		   	builder.getCellFormat().setWidth(100);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(StringUtil.checkNullToBlank(titleItemMap.get("ValidFrom")));	
			
			builder.insertCell();
			builder.getCellFormat().setWidth(100);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(StringUtil.checkNullToBlank(titleItemMap.get("OwnerTeamName")));
			
			builder.endRow();
			builder.endTable().setAlignment(TabAlignment.CENTER);
			builder.endRow();
			
			builder.endTable().setAllowAutoFit(false);
    		///////////////////////////////////////////////////////////////////////////////////////
    		// 표지 END
		    builder.insertBreak(BreakType.PAGE_BREAK);
//     		if (pItemList.size() > 0) { 
//     			// content START	
// 				builder.getFont().setColor(Color.DARK_GRAY);
// 			    builder.getFont().setSize(14);
// 			    builder.getFont().setBold(true);
// 			    builder.getFont().setName(defaultFont);
// 			    builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
// 			    builder.insertHtml("<br>");
// 			    builder.insertHtml("<br>");
// 				builder.writeln("\tContent"); // content
// 				builder.insertHtml("<br>");
				
// 			    builder.getFont().setSize(11);
// 			    builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			    
// 			    if (!gItem.isEmpty()) {	// L2에서 워드리포트 실행 경우
// 					builder.writeln("\t" + gItem.get("Identifier")+" "+gItem.get("ItemName"));
// 					for (int j = 0; pItemList.size() > j ; j++) {
// 						Map pItemMap = (Map)pItemList.get(j);
// 						builder.writeln("\t\t" + pItemMap.get("toItemIdentifier")+" "+pItemMap.get("toItemName"));
						
// 						if(mainItemList.size() > 0){
// 							List mainItemTemp = (List)mainItemList.get(j);
// 							for(int k = 0; mainItemTemp.size() > k; k++){
// 								Map mainItemMap = (Map)mainItemTemp.get(k);
// 								builder.writeln("\t\t\t" + mainItemMap.get("toItemIdentifier")+" "+mainItemMap.get("toItemName"));
// 							}
// 						}
// 					}
// 				} else {
// 					Map pItemMap = (Map)pItemList.get(0);
// 					builder.writeln("\t" + pItemMap.get("Identifier")+" "+pItemMap.get("ItemName"));
					
// 					List mainItemTemp = (List)mainItemList.get(0);
// 					for(int k = 0; mainItemTemp.size() > k; k++){
// 						Map mainItemMap = (Map)mainItemTemp.get(k);
// 						builder.writeln("\t\t" + mainItemMap.get("toItemIdentifier")+" "+mainItemMap.get("toItemName"));
// 					}
// 				}
				
//     		}
// 			// content END

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
	 		List elementList = (List)totalMap.get("elementList");
	 		List relItemList = (List)totalMap.get("relItemList");
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
	 	    builder.write("QMS Process report"); 
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
	 	 	    
	 	 		builder.getRowFormat().clearFormatting();
				builder.getCellFormat().clearFormatting();
				builder.getRowFormat().setHeight(30.0);
	 	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경	 	
	 	 	    
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write("이름");
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getFont().setBold (false);
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.write(StringUtil.checkNullToBlank(selectedItemMap.get("ItemName")));
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write("문서번호");
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
	 	 		builder.write(StringUtil.checkNullToBlank(selectedItemMap.get("Identifier")));
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write("개정번호");
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getFont().setBold (false);
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.write(StringUtil.checkNullToBlank(selectedItemMap.get("Version")));
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write("개정일자");
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
	 	 		builder.write(StringUtil.checkNullToBlank(selectedItemMap.get("ValidFrom")));
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write("관리조직");
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getFont().setBold (false);
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.write(StringUtil.checkNullToBlank(selectedItemMap.get("OwnerTeamName")));
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write("프로세스 책임자");
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
	 	 		builder.write(String.valueOf(request.getAttribute("ownerTeamMngNM")));
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write("프로세스 담당자");
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getFont().setBold (false);
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.write(StringUtil.checkNullToBlank(selectedItemMap.get("AuthorName")));
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write("관리법인");
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
	 	 		builder.write(StringUtil.checkNullToBlank(selectedItemMap.get("TeamName")));
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 	 	// 1.ROW : 개요	 	 	 	
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write("적용범위");  // 개요
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(totalCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		
	 	 		String AT00060 = StringUtil.checkNullToBlank(attrMap.get("AT00060")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00060")))) { // type이 HTML인 경우
	 	 			if(StringUtil.checkNullToBlank(attrMap.get("AT00060")).contains("font-family")){
	 	 				builder.insertHtml(AT00060);
	 	 			}else{
	 	 				builder.insertHtml(fontFamilyHtml+AT00060+"</span>");
	 	 			}
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(AT00060);
	 	 		}
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write("검토주기");
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getFont().setBold (false);
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00080")));
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(titleCellWidth2);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write("관련부서");
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
	 	 		String roleListREL = "";
	 	 		for(int j=0; j < roleList.size(); j++) {
	 	 			Map role = (Map) roleList.get(j);
	 	 			if(role.get("TeamRoletype").equals("R")) {
	 	 				if(j != 0) roleListREL += ", ";
	 	 				roleListREL += role.get("TeamNM");
	 	 			}
	 	 		}
	 	 		builder.write(roleListREL);
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 			 	 		
	 	 		builder.endTable().setAllowAutoFit(false);
	 	 		builder.writeln();
	 	 		
	 	 		builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
	 	 		
	 	 		int headerNO = 2;
	 	 		
	 	 		builder.getFont().setColor(Color.DARK_GRAY);
			    builder.getFont().setSize(11);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
				builder.writeln(headerNO+". 목적 및 세부업무");
				headerNO++;
				
				String ZAT1300 = StringUtil.checkNullToBlank(attrMap.get("ZAT1300")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
 	 			if(StringUtil.checkNullToBlank(attrMap.get("ZAT1300")).contains("font-family")){
 	 				builder.insertHtml(ZAT1300);
 	 			}else{
 	 				builder.insertHtml(fontFamilyHtml+ZAT1300+"</span>");
 	 			}
 	 			
	 	 		builder.getFont().setColor(Color.DARK_GRAY);
			    builder.getFont().setSize(11);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
				
				
				builder.getRowFormat().clearFormatting();
				builder.getCellFormat().clearFormatting();
				
				Map data = new HashMap();
				for(int j=0; j<activityList.size(); j++){
					
					data = (HashMap) activityList.get(j);
					
					builder.startTable();
					
					// Make the header row.
					builder.getRowFormat().setHeight(30.0);
					builder.getRowFormat().setHeightRule(HeightRule.AUTO);
					
					// Some special features for the header row.
					builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					builder.getFont().setSize(10);
					builder.getFont().setBold (true);
					builder.getFont().setColor(Color.BLACK);
					builder.getFont().setName(defaultFont);
					
					builder.insertCell();
					builder.getCellFormat().setWidth(80.0);
					builder.write(StringUtil.checkNullToBlank(data.get("Identifier")));
					
					builder.insertCell();
					builder.getCellFormat().setWidth(120.0);
					builder.write(StringUtil.checkNullToBlank(data.get("ItemName")));
					
					builder.endRow();
					
					// Set features for the other rows and cells.
					builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					
					// Reset height and define a different height rule for table body
					builder.getRowFormat().setHeight(30.0);
					builder.getRowFormat().setHeightRule(HeightRule.AUTO);

					builder.insertCell();
					builder.getCellFormat().setWidth(200.0);
					String ATVITAT00003 = StringUtil.checkNullToBlank(data.get("AT00003")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
					builder.insertHtml(ATVITAT00003);
					
					builder.endRow();
					
					builder.insertCell();
					String ATVITAT00062 = StringUtil.checkNullToBlank(data.get("AT00062")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
					builder.insertHtml(ATVITAT00062);
					builder.endRow();
					builder.endTable().setAllowAutoFit(false);
					builder.insertHtml("<br>");
					
					
					/*
					data = (HashMap) activityList.get(j);
					
					builder.startTable();
					
					// Make the header row.
					builder.getRowFormat().setHeight(30.0);
					builder.getRowFormat().setHeightRule(HeightRule.AUTO);
					
					// Some special features for the header row.
					builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					builder.getFont().setSize(10);
					builder.getFont().setBold (true);
					builder.getFont().setColor(Color.BLACK);
					builder.getFont().setName(defaultFont);
					
					builder.insertCell();
					builder.getCellFormat().setWidth(80.0);
					builder.write(StringUtil.checkNullToBlank(data.get("Identifier")));
					
					builder.insertCell();
					builder.getCellFormat().setWidth(120.0);
					builder.write(StringUtil.checkNullToBlank(data.get("ItemName")));
					
					builder.endRow();
					
					// Set features for the other rows and cells.
					builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					
					// Reset height and define a different height rule for table body
					builder.getRowFormat().setHeight(30.0);
					builder.getRowFormat().setHeightRule(HeightRule.AUTO);

					builder.insertCell();
					builder.getCellFormat().setWidth(200.0);
					String ATVITAT00003 = StringUtil.checkNullToBlank(data.get("AT00003")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
					builder.insertHtml(ATVITAT00003);
					
					builder.endRow();
					
					String ATVITAT00062 = StringUtil.checkNullToBlank(data.get("AT00062")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
					builder.insertHtml(ATVITAT00062);

					builder.endRow();
					*/
				}

				//3. 관련항목
				Map cnAttrList = new HashMap();
				List cnAttr = new ArrayList();
				Map AttrInfoList = new HashMap();
				Map ItemAttrInfo = new HashMap();
				if (String.valueOf(request.getAttribute("cxnYN")).equals("on")) {
					builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
					builder.getFont().setColor(Color.DARK_GRAY);
				    builder.getFont().setSize(11);
				    builder.getFont().setBold(true);
				    builder.getFont().setName(defaultFont);
					builder.writeln(headerNO+". " + String.valueOf(menu.get("LN00008")));
					headerNO++;
					
					for(int i=0; i <relItemClassCodeList.size() ; i++){
						builder.getFont().setColor(Color.DARK_GRAY);
					    builder.getFont().setSize(11);
					    builder.getFont().setBold(true);
					    builder.getFont().setName(defaultFont);
			 	 		builder.insertHtml("<br>");
				    	builder.writeln("연관 프로세스");
				    	
					    builder.startTable();
					    builder.getRowFormat().clearFormatting();
						builder.getCellFormat().clearFormatting();
						
						// Make the header row.
						builder.getRowFormat().setHeight(20.0);
						builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
						
						// Some special features for the header row.
						builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
						builder.getFont().setSize(10);
						builder.getFont().setBold (true);
						builder.getFont().setColor(Color.BLACK);
						builder.getFont().setName(defaultFont);

						builder.insertCell();
						builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(24.0));
						builder.write("활동번호");
						builder.insertCell();
						builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(55.0));
						builder.write("프로세스명");
						builder.insertCell();
						builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(20.0));
						builder.write("관리부서");
						builder.endRow();
						
						// Set features for the other rows and cells.
						builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
						builder.getCellFormat().setWidth(100.0);
						builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
						
						// Reset height and define a different height rule for table body
						builder.getRowFormat().setHeight(30.0);
						builder.getRowFormat().setHeightRule(HeightRule.AUTO);
						
				    	for(int j=0; j<relItemID.size(); j++){
							Object ItemID = relItemID.get(j);
							map = (HashMap)relItemList.get(j);
							builder.getFont().setBold(false);
							builder.getFont().setSize(10);
							builder.getFont().setColor(Color.BLACK);
							
							if(map.containsValue(relItemClassCodeList.get(i))){									 
								//==================================================================================================	
					 	 		builder.insertCell();
					 	 		builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(24.0));
							   	builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
							   	builder.write(StringUtil.checkNullToBlank(map.get("Identifier")));
							   	
								builder.insertCell();
								builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(55.0));
								builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);								   	
								builder.write(StringUtil.checkNullToBlank(map.get("ItemName")));
					 	 								 	 		
					 	 		builder.insertCell();
					 	 		builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(20.0));
							   	builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
							   	builder.write(StringUtil.checkNullToBlank(map.get("OwnerTeamName")));
					 	 		
					 	 		builder.endRow();
					 	 		//==================================================================================================	
					 	 		builder.endTable().setAllowAutoFit(false);
							}
						}
				    
					    
					    if(relItemClassCodeList.get(i).equals("CL11004")){
							builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
				 	 		builder.getFont().setColor(Color.DARK_GRAY);
						    builder.getFont().setSize(11);
						    builder.getFont().setBold(true);
						    builder.getFont().setName(defaultFont);
					    	builder.writeln(headerNO+ ". 용어");
					    	
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
							builder.getFont().setSize(10);
							builder.getFont().setBold (true);
							builder.getFont().setColor(Color.BLACK);
							builder.getFont().setName(defaultFont);
							
							builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(25.0));
							builder.write("용어");
							builder.insertCell();
							builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(75.0));
							builder.write("용어의 정의");
							builder.endRow();
							
							// Set features for the other rows and cells.
							builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
							builder.getCellFormat().setWidth(100.0);
							builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
							
							// Reset height and define a different height rule for table body
							builder.getRowFormat().setHeight(30.0);
							builder.getRowFormat().setHeightRule(HeightRule.AUTO);
							
					    	for(int j=0; j<relItemID.size(); j++){
								Object ItemID = relItemID.get(j);
								map = (HashMap)relItemList.get(j);
								builder.getFont().setBold(false);
								builder.getFont().setSize(10);
								builder.getFont().setColor(Color.BLACK);
								
								if(map.containsValue(relItemClassCodeList.get(i))){									 
									for(int k=0; k<relItemAttrbyID.size(); k++){
										cnAttrList = (Map)relItemAttrbyID.get(k);
										if(ItemID.equals(cnAttrList.get("ItemID"))){
											String AttrType = (String)cnAttrList.get("AttrType");
											AttrInfoList.put(AttrType,cnAttrList);
										}
									}
									
									//==================================================================================================	
						 	 		ItemAttrInfo = (Map)AttrInfoList.get("AT00003");
									
						 	 		builder.insertCell();
						 	 		builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(25.0));
								   	builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
								   	builder.write(StringUtil.checkNullToBlank(map.get("ItemName")));
								   	
									builder.insertCell();
									builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(75.0));
									builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);								   	
									if(ItemAttrInfo != null){
							 	 		String AttrValue = StringEscapeUtils.unescapeHtml4(StringUtil.checkNullToBlank(ItemAttrInfo.get("AttrValue"))).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
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
						 	 		//==================================================================================================	
						 	 		builder.endTable().setAllowAutoFit(false);
								}
							}
					    }
					    
					    if(relItemClassCodeList.get(i).equals("CL06002")){
							builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
				 	 		builder.getFont().setColor(Color.DARK_GRAY);
						    builder.getFont().setSize(11);
						    builder.getFont().setBold(true);
						    builder.getFont().setName(defaultFont);
					    	builder.writeln(headerNO+ ". 양식");
					    	headerNO++;
					    	
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
							builder.getFont().setSize(10);
							builder.getFont().setBold (true);
							builder.getFont().setColor(Color.BLACK);
							builder.getFont().setName(defaultFont);
														
							builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(24.0));
							builder.write("문서번호");
							
							builder.insertCell();
							builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(55.0));
							builder.write("문서명");
							
							builder.insertCell();
							builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(20.0));
							builder.write("관리부서");
							builder.endRow();
							
							// Set features for the other rows and cells.
							builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
							builder.getCellFormat().setWidth(100.0);
							builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
							
							// Reset height and define a different height rule for table body
							builder.getRowFormat().setHeight(30.0);
							builder.getRowFormat().setHeightRule(HeightRule.AUTO);
							
					    	for(int j=0; j<relItemID.size(); j++){
								Object ItemID = relItemID.get(j);
								map = (HashMap)relItemList.get(j);
								builder.getFont().setBold(false);
								builder.getFont().setSize(10);
								builder.getFont().setColor(Color.BLACK);
								
								if(map.containsValue(relItemClassCodeList.get(i))){									 
									//==================================================================================================	
						 	 		builder.insertCell();
						 	 		builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(24.0));
								   	builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
								   	builder.write(StringUtil.checkNullToBlank(map.get("Identifier")));
								   	
									builder.insertCell();
									builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(55.0));
									builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);								   	
									builder.write(StringUtil.checkNullToBlank(map.get("ItemName")));
						 	 		
						 	 		
						 	 		builder.insertCell();
						 	 		builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(20.0));
								   	builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
								   	builder.write(StringUtil.checkNullToBlank(map.get("OwnerTeamName")));
						 	 		
						 	 		builder.endRow();
						 	 		//==================================================================================================	
						 	 		
								}
							}
					    	builder.endTable().setAllowAutoFit(false);
					    }
					}
				}
				
				//==================================================================================================
				if (String.valueOf(request.getAttribute("csYN")).equals("on")) {
					builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
		 	 		builder.getFont().setColor(Color.DARK_GRAY);
				    builder.getFont().setSize(11);
				    builder.getFont().setBold(true);
				    builder.getFont().setName(defaultFont);
					builder.writeln(headerNO +". " + String.valueOf(menu.get("LN00012")));
					headerNO++;
				
					data = new HashMap();
			 		
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
					builder.getFont().setSize(10);
					builder.getFont().setBold (true);
					builder.getFont().setColor(Color.BLACK);
					builder.getFont().setName(defaultFont);
					
					builder.getCellFormat().setWidth(50.0);
					builder.write(String.valueOf(menu.get("LN00024"))); // No
					builder.insertCell();
					builder.getCellFormat().setWidth(100.0);
					builder.write("Version");
					builder.insertCell();
					builder.getCellFormat().setWidth(280.0);
					builder.write(String.valueOf(menu.get("LN00131"))); // 프로젝트
					builder.insertCell();
					builder.getCellFormat().setWidth(100.0);
					builder.write(String.valueOf(menu.get("LN00022"))); // 변경구분
					builder.insertCell();
					builder.getCellFormat().setWidth(80.0);
					builder.write(String.valueOf(menu.get("LN00004"))); // 담당자
					builder.insertCell();
					builder.getCellFormat().setWidth(120.0);
					builder.write(String.valueOf(menu.get("LN00296"))); // 시행일
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
					    
					    builder.getCellFormat().setWidth(50.0);
					   	builder.write(String.valueOf(j+1));
					   	builder.insertCell();
					   	builder.getCellFormat().setWidth(100.0);
					   	builder.write(StringUtil.checkNullToBlank(data.get("Version")));
						builder.insertCell();
						builder.getCellFormat().setWidth(280.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						builder.write(StringUtil.checkNullToBlank(data.get("ProcjectName")) + "/" +StringUtil.checkNullToBlank(data.get("CSRName"))); 
						builder.insertCell();
						builder.getCellFormat().setWidth(100.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.write(StringUtil.checkNullToBlank(data.get("ChangeType"))); 
						builder.insertCell();
						builder.getCellFormat().setWidth(80.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.write(StringUtil.checkNullToBlank(data.get("AuthorName")));
						builder.insertCell();
						builder.getCellFormat().setWidth(120.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.write(StringUtil.checkNullToBlank(data.get("ValidFrom")));
						builder.endRow();
					}	
					builder.endTable().setAllowAutoFit(true);
				}
				//==================================================================================================
		 		if (String.valueOf(request.getAttribute("rnrYN")).equals("on")) {
					builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
		 	 		builder.getFont().setColor(Color.DARK_GRAY);
				    builder.getFont().setSize(11);
				    builder.getFont().setBold(true);
				    builder.getFont().setName(defaultFont);
					builder.writeln(headerNO + ". R&R");
					headerNO++;
					
					builder.getRowFormat().clearFormatting();
					builder.getCellFormat().clearFormatting();
					
					for(int j=0; j<rnrList.size(); j++){
						data = new HashMap();
						data = (HashMap) rnrList.get(j);						

						builder.insertHtml("<br>");
						builder.getFont().setBold (true);
						builder.writeln(StringUtil.checkNullToBlank(data.get("Identifier")) + " " + StringUtil.checkNullToBlank(data.get("TREE_NM")));
				 		
						builder.startTable();
						
						// Make the header row.
						builder.insertCell();
						builder.getRowFormat().setHeight(20.0);
						builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
						
						// Some special features for the header row.
						builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
						builder.getFont().setSize(10);
						builder.getFont().setBold (true);
						builder.getFont().setColor(Color.BLACK);
						builder.getFont().setName(defaultFont);
						
						builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(7.5));
						builder.write(String.valueOf(menu.get("LN00024"))); // No
						builder.insertCell();
						builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(25.0));
						builder.write(String.valueOf(menu.get("LN00247"))); // 조직
						builder.insertCell();
						builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(42.0));
						builder.write(String.valueOf(menu.get("LN00162"))); // 상위조직
						builder.insertCell();
						builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(11.0));
						builder.write(String.valueOf(menu.get("LN00119"))); // 역할
						builder.insertCell();
						builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(14.5));
						builder.write(String.valueOf(menu.get("LN00078"))); // 등록일
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
					    	builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(7.5));
						   	builder.write(StringUtil.checkNullToBlank(subItemRole.get("RNUM")));
						   	builder.insertCell();
						   	builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(25.0));
						   	builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						   	builder.write(StringUtil.checkNullToBlank(subItemRole.get("TeamNM")));
							builder.insertCell();
							builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(42.0));
							builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
							builder.write(StringUtil.checkNullToBlank(subItemRole.get("TeamPath"))); 
							builder.insertCell();
							builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(11.0));
							builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
							builder.write(StringUtil.checkNullToBlank(subItemRole.get("TeamRoleNM"))); 
							builder.insertCell();
							builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(14.5));
							builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
							builder.write(StringUtil.checkNullToBlank(subItemRole.get("AssignedDate")));
							builder.endRow();
						}
						builder.endTable().setAllowAutoFit(false);
					}
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
	
}catch(Exception e){
e.printStackTrace();
	
} finally{
	request.getSession(true).setAttribute("expFlag", "Y");
	
	response.getOutputStream().flush();
	response.getOutputStream().close();
}

%>
