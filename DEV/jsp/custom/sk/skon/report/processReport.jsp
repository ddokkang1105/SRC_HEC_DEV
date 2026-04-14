<%@page import="com.sap.i18n.cp.ConvertSystemCpToC7bOnly"%>
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

<%@page import="org.apache.commons.logging.Log" %>
<%@page import="org.apache.commons.logging.LogFactory" %>

<%

try{
	String LogoImgUrl = "";
	String modelImgPath = GlobalVal.MODELING_DIGM_DIR;
	String logoPath = GlobalVal.FILE_UPLOAD_TINY_DIR; //=> C://OLM3.6//webapps//ROOT//upload//
	String defaultFont = String.valueOf(request.getAttribute("defaultFont"));
 	
	License license = new License();
	license.setLicense(logoPath + "Aspose.Words.lic");
	
	Document doc = new Document();
	DocumentBuilder builder = new DocumentBuilder(doc);	
	
	Map menu = (Map)request.getAttribute("menu");
 	Map setMap = (HashMap)request.getAttribute("setMap");
 	List allTotalList = (List)request.getAttribute("allTotalList");
 	List history = null;
	
	
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
   // String imageFileName2 = logoPath + "logo_footer.png";
   // builder.insertImage(imageFileName2, 80, 25);
    
 	// 3.footer : current page / total page 
    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
    builder.insertCell();
    builder.getCellFormat().setWidth(200.0);
    
    // Set first cell to 1/3 of the page width.
    builder.getCellFormat().setPreferredWidth(PreferredWidth.fromPercent(100 / 3));
    // Insert page numbering text here.
    // It uses PAGE and NUMPAGES fields to auto calculate current page number and total number of pages.
	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
    builder.insertField("PAGE", "");
    builder.write(" / ");
    builder.insertField("NUMPAGES", "");
    
 	// 4.footer : current page / total page 
     builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
    builder.insertCell();
    builder.getCellFormat().setWidth(200.0);
   // builder.write("Process Asset Library ");
     
    builder.endTable().setAllowAutoFit(false);
        
    builder.moveToDocumentEnd();
//=========================================================================
	
	builder = new DocumentBuilder(doc);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	for (int totalCnt = 0;allTotalList.size() > totalCnt ; totalCnt++ ) {
		Map allTotalMap = (Map)allTotalList.get(totalCnt);
		history  = (List)allTotalMap.get("cngtList");
		
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
		    	builder.writeln("제 ．개정이력");
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
			builder.writeln("["+selectedItemPath+"]");
			builder.insertHtml("<br>");
    		builder.insertHtml("<br>");
    		//builder.insertHtml("<br>");
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
			builder.write(String.valueOf(menu.get("LN00356"))); // 개정번호

			builder.insertCell();
			builder.getCellFormat().setWidth(200);
			builder.write(String.valueOf(menu.get("LN00360"))); // 주요개정사항

			builder.insertCell();
			builder.getCellFormat().setWidth(120);
			builder.write(String.valueOf(menu.get("LN00060"))); // 작성자
			
			builder.insertCell();
			builder.getCellFormat().setWidth(100);
			builder.write(String.valueOf(menu.get("LN00357"))); // 개정일
			
			builder.endRow();//1행끝
			
			// Set features for the other rows and cells.
			builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			
			// Reset height and define a different height rule for table body
			
			//2행시작 
					builder.getRowFormat().setHeight(30.0);
					builder.getRowFormat().setHeightRule(HeightRule.AUTO);
					
	
			
		if (history.size() >= 0) { 
			 	for (int index = 0; history.size() > index ; index++) {	 		
			 	
			 	
			 		HashMap data = (HashMap) history.get(index);
					
			 		builder.insertCell();
				   	builder.getCellFormat().setWidth(120);
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);			
					builder.write(StringUtil.checkNullToBlank(data.get("Version")));//개정번호 
				
					
					builder.insertCell();
				   	builder.getCellFormat().setWidth(200);
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					
					builder.write(StringUtil.checkNullToBlank(data.get("Description")));//주요개정사항
						
					builder.insertCell();
				   	builder.getCellFormat().setWidth(120);
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					//builder.write(StringUtil.checkNullToBlank(titleItemMap.get("AuthorName")));	//작성자
					builder.write(StringUtil.checkNullToBlank(data.get("AuthorName")));
					builder.insertCell();
				   	builder.getCellFormat().setWidth(100);
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					//builder.write(StringUtil.checkNullToBlank(titleItemMap.get("ValidFrom")));	//개정일자 
					builder.write(StringUtil.checkNullToBlank(data.get("ApproveDate")));
					
					builder.endRow();
				}
			 }
		
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
	 		
	 		List cngtList = (List)totalMap.get("cngtList");
	 		//List<Map<String, Object>> activityList = (List)totalMap.get("activityList");
	 		List elementList = (List)totalMap.get("elementList");
	 		List relItemList = (List)totalMap.get("relItemList");
	 		List dimResultList = (List)totalMap.get("dimResultList");
	 		List attachFileList = (List)totalMap.get("attachFileList");
	 		List roleList = (List)totalMap.get("roleList");
	 		Map attrMap = (Map)totalMap.get("attrMap");
	 		Map attrHtmlMap = (Map)totalMap.get("attrHtmlMap");
	 		Map modelMap = (Map)totalMap.get("modelMap");
	 		List relItemClassCodeList = (List)totalMap.get("relItemClassCodeList");
	 		List relItemNameList = (List)totalMap.get("relItemNameList");
 	 		List relItemID = (List)totalMap.get("relItemID");
 	 		List relItemAttrbyID = (List)totalMap.get("relItemAttrbyID");
 	 		List termList = (List)totalMap.get("termList");
 	 		//System.out.println("termList=="+termList);
 	 		Map AttrTypeList = (Map)totalMap.get("AttrTypeList");
	 		Map map = new HashMap();
			
	 		System.out.print("rowPrcData:"+rowPrcData);
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
			//로고이미지 
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			builder.getFont().setSize(14);
			builder.getFont().setUnderline(0);
			builder.getFont().setBold(true);
			builder.getFont().setColor(Color.BLACK);
			builder.getFont().setName(defaultFont);
			
			builder.getCellFormat().setWidth(60);
			builder.getCellFormat().setVerticalMerge(CellMerge.FIRST);
			//builder.insertCell();
    		builder.insertImage(imageFileName, 50, 25);

    		//문서번호 
			builder.insertCell();
			builder.getCellFormat().setWidth(100);
			name = StringUtil.checkNullToBlank(rowPrcData.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
	 	   	name = name.replace("&#10;", " ");
	 	   	name = name.replace("&#xa;", "");
	 	    name = name.replace("&nbsp;", " ");
	 	    builder.write("문서번호"); 
	
			
	 	  //문서명
	 	  	builder.insertCell();
			builder.getCellFormat().setWidth(200);
	 	    builder.getCellFormat().setVerticalMerge(CellMerge.FIRST);
	 	    builder.write(name); 
	 	    
	 	    //개정일자
	 	  	builder.insertCell();
	 		builder.getCellFormat().setWidth(70);
	 		builder.getCellFormat().setVerticalMerge(CellMerge.FIRST);
	 		builder.write("개정일자"); 
			builder.endRow();//1행끝 
			
			// 2행 start 
			builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			builder.getFont().setSize(11);
			builder.getFont().setUnderline(0);
			builder.getFont().setBold(false);
			
			// Reset height and define a different height rule for table body
			builder.getRowFormat().setHeight(30.0);
			builder.getRowFormat().setHeightRule(HeightRule.AUTO);
			//1번째 열
		    builder.insertCell(); 	
		    builder.getCellFormat().setWidth(60);
			builder.getCellFormat().setVerticalMerge(CellMerge.PREVIOUS);
			
			//2번째 열 문서번호 
			builder.insertCell();
		   	builder.getCellFormat().setWidth(100);
		   	builder.getCellFormat().setVerticalMerge(CellMerge.NONE);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(String.valueOf(rowPrcData.get("Identifier")));  
    		
			//3번째 열 문서명과 맞추기 
			builder.insertCell();
		   	builder.getCellFormat().setWidth(200);
			builder.getCellFormat().setVerticalMerge(CellMerge.PREVIOUS);
			
			//4번쨰 열 개정일자 맞춤 
			builder.insertCell();
		   	builder.getCellFormat().setWidth(70);
		   	builder.getCellFormat().setVerticalMerge(CellMerge.FIRST);
		   	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		   	builder.write(rowPrcData.get("LastUpdated")+"("+rowPrcData.get("Version") +")");
			builder.endRow();//2행끝
			
			builder.endTable().setAllowAutoFit(false);
			 // 타이틀과 내용 사이 간격
	 	    builder.insertHtml("<hr size=4 color='silver'/>");
	 	 	// 머릿말 : END
	 	 	builder.moveToDocumentEnd();
	 	  	//==================================================================================================
	 	  		
	 		// 아이템 속성 		
	 		if ("N".equals(onlyMap)) {

	 		 
	 			/*  builder.getFont().setColor(Color.DARK_GRAY);
			    builder.getFont().setSize(11);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
			    builder.insertHtml("<span style='font-size:7px'>&#9632;&nbsp;&nbsp;</span>");
			 	builder.writeln("목차" );//목적
				builder.insertHtml("<br>");
	 		
				builder.writeln("제-개정 이력서");//목적
				builder.insertHtml("<br>");
				
	 			// 1. 목적
	 	 		builder.getFont().setColor(Color.DARK_GRAY);
			    builder.getFont().setSize(11);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
			    builder.insertHtml("<span style='font-size:7px'>&#9632;&nbsp;&nbsp;</span>");
				builder.writeln("1. " + String.valueOf(AttrTypeList.get("AT00803")));//목적
				builder.insertHtml("<br>");
	 			//builder.startTable();
	 	 		
	 	 	
	 	 		
	 	 		//=================
	 	 	    //2. 적용범위 
	 	 		builder.getFont().setColor(Color.DARK_GRAY);
			    builder.getFont().setSize(11);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
				builder.writeln("2. " + String.valueOf(AttrTypeList.get("ZAT02016")));//적용범위

	 	 		builder.insertHtml("<br>");
	 	 		//===============================
	 	 		
	 	 				
	 	 		// 3.ROW : 용어의 정의 
	 	 		
	 	 
	 	 	    builder.getFont().setColor(Color.DARK_GRAY);
			    builder.getFont().setSize(11);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
			    builder.insertHtml("<br><span style='font-size:7px'>&#9632;&nbsp;&nbsp;</span>");
				builder.writeln("2. "+String.valueOf(AttrTypeList.get("ZAT02024")));
				
				builder.insertHtml("<br>");
				
				
	 	 		 //4. 책임 밑 권한 
	 	 		  
	 	 		builder.getFont().setColor(Color.DARK_GRAY);
			    builder.getFont().setSize(11);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
				builder.writeln("4. " + String.valueOf(AttrTypeList.get("ZAT02017")));//적용범위
				
	 		
	 	 		builder.insertHtml("<br>");
	 	 		//==================================================================================================	
	
	 	 			 	 		
	 	 		// 5.ROW : 관련문서 
	 			builder.getFont().setColor(Color.DARK_GRAY);
			    builder.getFont().setSize(11);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
			    builder.insertHtml("<br><span style='font-size:7px'>&#9632;&nbsp;&nbsp;</span>");
				builder.writeln("5.관련문서" );//적용범위
				
				builder.insertHtml("<br>");
	 	 		//6. 기록 및 보관 
	 	 		builder.getFont().setColor(Color.DARK_GRAY);
			    builder.getFont().setSize(11);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
			    builder.insertHtml("<br><span style='font-size:7px'>&#9632;&nbsp;&nbsp;</span>");
				builder.writeln("6. " + String.valueOf(AttrTypeList.get("ZAT02020")));//적용범위
				
	 	 	  
	 	 		builder.insertHtml("<br>");
	 	 		//==================================================================================================	
	 	
	 	 		
	 	 		// 7.ROW : 업무 절차 
	 	 
	 	 		//==================================================================================================	
	 	 		builder.getFont().setColor(Color.DARK_GRAY);
			    builder.getFont().setSize(11);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
			    builder.insertHtml("<span style='font-size:7px'>&#9632;&nbsp;&nbsp;</span>");
				builder.writeln("7. 업무절차" );//적용범위
			 */
 
			
	 	 		//==================================================================================================	
	 	 		
	 	 
		 		
	 	 
	 	 		//page 2
	 	 		int headerNO = 1;
	 	 			 	 		
	 	 	// 1. 목적 
 	 			//builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE); // 페이지구분 
	 			builder.getFont().setColor(Color.DARK_GRAY);
			    builder.getFont().setSize(11);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
				builder.writeln(1+". " + String.valueOf(AttrTypeList.get("AT00803")));
				headerNO++;
				
				
				builder.getFont().setName(defaultFont);
		 	 	    builder.getFont().setColor(Color.BLACK);
		 	 	    builder.getFont().setSize(10);
		 	 	 	String AT00803 = StringUtil.checkNullToBlank(attrMap.get("AT00803")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
		 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00803")))) { // type이 HTML인 경우
		 	 			if(StringUtil.checkNullToBlank(attrMap.get("AT00803")).contains("font-family")){
		 	 				builder.insertHtml(AT00803);
		 	 			}else{
		 	 				builder.insertHtml(fontFamilyHtml+AT00803+"</span>");
		 	 			}
		 	 		} else {
		 	 			builder.getFont().setBold(false);
		 	 			builder.write(AT00803); // 목적 : 내용
		 	 			builder.insertHtml("<br><br style='line-height:1.0;'>");
		 	 		}
		 	 		builder.insertHtml("<br>");
		 	 		
		 	 		//2.적용범위 
		 	 		
		 	 	builder.getFont().setColor(Color.DARK_GRAY);
			    builder.getFont().setSize(11);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
			    builder.insertHtml("<br><span style='font-size:7px'>&#9632;&nbsp;&nbsp;</span>");
				builder.writeln("2. " + String.valueOf(AttrTypeList.get("ZAT02016")));//적용범위
	 	 
				//내용
	 	 		builder.getFont().setName(defaultFont);
		 	 	    builder.getFont().setColor(Color.BLACK);
		 	 	    builder.getFont().setSize(10);
		 	 	 	String ZAT02016 = StringUtil.checkNullToBlank(attrMap.get("ZAT02016")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
		 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("ZAT02016")))) { // type이 HTML인 경우
		 	 			if(StringUtil.checkNullToBlank(attrMap.get("ZAT02016")).contains("font-family")){
		 	 				builder.insertHtml(ZAT02016);
		 	 			}else{
		 	 				builder.insertHtml(fontFamilyHtml+ZAT02016+"</span>");
		 	 			}
		 	 		} else {
		 	 			builder.getFont().setBold(false);
		 	 			builder.write(ZAT02016); // 목적 : 내용
		 	 			builder.insertHtml("<br><br style='line-height:1.0;'>");
		 	 		}
		 	 		builder.insertHtml("<br>");
	
			 			Map cnProcessData = new HashMap();
				 		//용어의 정의 
				 		builder.getFont().setColor(Color.DARK_GRAY);
					    builder.getFont().setSize(11);
					    builder.getFont().setBold(true);
					    builder.getFont().setName(defaultFont);
					    builder.insertHtml("<br><span style='font-size:7px'>&#9632;&nbsp;&nbsp;</span>");
						builder.writeln("3. 용어의 정의 " );//적용범위
				 		
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
						builder.getCellFormat().setWidth(100);
						builder.write("용어명"); // 용어명
			
						builder.insertCell();
						builder.getCellFormat().setWidth(200);
						builder.write("용어의 정의"); // ID
						builder.endRow();
					
						
						for(int j=0; j<termList.size(); j++){
							cnProcessData = (HashMap) termList.get(j);
							builder.getRowFormat().clearFormatting();
							builder.getCellFormat().clearFormatting();
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
						   	builder.getCellFormat().setWidth(100);
							builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
							String termItemName = StringEscapeUtils.unescapeHtml4(StringUtil.checkNullToBlank(cnProcessData.get("ItemName")));
							builder.write(termItemName);
							builder.insertCell();
						   	builder.getCellFormat().setWidth(200);
							builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
							
							
							String rawText = StringUtil.checkNullToBlank(cnProcessData.get("KoreanText"));
							String koreanText = StringEscapeUtils.unescapeHtml4(
							    rawText.replaceAll("(?i)<br\\s*/?>", "\n")
							);
							
							
							koreanText = koreanText.replaceAll("<[^>]*>", "");//나머지 태그제거
						 
							builder.write(koreanText);

							if(StringUtil.checkNullToBlank(processInfo).contains("font-family")){	
								builder.insertHtml(processInfo);
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+processInfo+"</span>",false);
			 	 			}
							
							builder.endRow();
						}	
						
						// Set features for the other rows and cells.
						//builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
						//builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
						
						// Reset height and define a different height rule for table body
						builder.getRowFormat().setHeight(30.0);
						builder.getRowFormat().setHeightRule(HeightRule.AUTO);
						
						
						builder.endTable().setAllowAutoFit(false);	
				 		builder.insertHtml("<br>");
						builder.insertHtml("<br>");

			
						
			 	 		 //4. 책임 밑 권한 
			 	 		  
			 	 		builder.getFont().setColor(Color.DARK_GRAY);
					    builder.getFont().setSize(11);
					    builder.getFont().setBold(true);
					    builder.getFont().setName(defaultFont);
					 
						builder.writeln("4. " + String.valueOf(AttrTypeList.get("ZAT02017")));//적용범위
						//내용
			 	 		builder.getFont().setName(defaultFont);
				 	 	    builder.getFont().setColor(Color.BLACK);
				 	 	    builder.getFont().setSize(10);
				 	 	 	String ZAT02017 = StringUtil.checkNullToBlank(attrMap.get("ZAT02017")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
				 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("ZAT02017")))) { // type이 HTML인 경우
				 	 			if(StringUtil.checkNullToBlank(attrMap.get("ZAT02017")).contains("font-family")){
				 	 				builder.insertHtml(ZAT02017);
				 	 			}else{
				 	 				builder.insertHtml(fontFamilyHtml+ZAT02017+"</span>");
				 	 			}
				 	 		} else {
				 	 			builder.getFont().setBold(false);
				 	 			builder.write(ZAT02017); // 목적 : 내용
				 	 			builder.insertHtml("<br><br style='line-height:1.0;'>");
				 	 		}
				 	 		
							//5. 연관 문서 , 연관항목
							Map cnAttrList = new HashMap();
							List cnAttr = new ArrayList();
							Map AttrInfoList = new HashMap();
							Map ItemAttrInfo = new HashMap();
							
							if (String.valueOf(request.getAttribute("cxnYN")).equals("on")) {
								if(relItemClassCodeList.size() > 0) {
									//builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
								}
								builder.writeln("5. " + String.valueOf(menu.get("LN00008")));//연관항목
								builder.getFont().setColor(Color.DARK_GRAY);
							    builder.getFont().setSize(11);
							    builder.getFont().setBold(true);
							    builder.getFont().setName(defaultFont);
							    builder.startTable();
								builder.getRowFormat().clearFormatting();
								builder.getCellFormat().clearFormatting();
								
								//==================================================================================================	
								// 1.row header 
								builder.insertCell();
								builder.getRowFormat().setHeight(30.0);
								builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);	
					 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
					 	 		builder.getCellFormat().setWidth(60);
					 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
					 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					 	 		builder.getFont().setBold(true);
					 	 		builder.write(String.valueOf(menu.get("LN00024")));//no
					 	 		
					 	 		
					 	 		builder.insertCell();
					 	 		builder.getCellFormat().setWidth(270);
					 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
					 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
					 	 		builder.getFont().setBold(true);
					 	 		builder.write(String.valueOf(menu.get("LN00101")));//문서명
					 	 		
					 	 		builder.insertCell();
					 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
					 	 		builder.getCellFormat().setWidth(300);
					 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					 	 		builder.getFont().setBold (true);
					 	 		builder.write("문서번호");  // 문서번호 
					 	 		
					 	 		builder.insertCell();
					 	 		builder.getCellFormat().setWidth(90);
					 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
					 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
					 	 		builder.getFont().setBold(true);
				 	 			builder.write(String.valueOf(menu.get("LN00091"))); // 문서유형
					 	 		builder.endRow();
					 	 		//==================================================================================================	
				 	 			int no = 1; // 연관항목 번호 
								for(int i=0; i <relItemClassCodeList.size() ; i++){
									
								   	if(relItemClassCodeList.size()>0){
										
										//headerNO++;
										for(int j=0; j<relItemID.size(); j++){
											Object ItemID = relItemID.get(j);
											map = (HashMap)relItemList.get(j);
											
											if(map.containsValue(relItemClassCodeList.get(i))){
												
												AttrInfoList = new HashMap();
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
												// 2.ROW -no 내용
												builder.insertCell();
									 	 		builder.getCellFormat().setWidth(60);
									 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
												builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
									 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
									 	 		builder.getFont().setBold (false);
									 	 		builder.write(String.valueOf(no));//no
									 	 		
									 	 		// 문서명 
									 	 		builder.insertCell();
									 	 		builder.getCellFormat().setWidth(270);
									 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
									 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
									 	 		builder.getFont().setBold(false);
									 	 		builder.write(StringUtil.checkNullToBlank(map.get("ItemName")));
									 	 		
									 	 		
									 	 		//문서번호
									 	 		builder.insertCell();
									 	 		builder.getCellFormat().setWidth(300);
									 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
									 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
									 	 		builder.getFont().setBold(false);
									 	 		builder.write(StringUtil.checkNullToBlank(map.get("Identifier")));
									 	 		//System.out.print("identifier>>"+StringUtil.checkNullToBlank(map.get("Identifier")));
									 	 	
									 	 		
									 	 
									 	 		//문서유형
									 	 		builder.insertCell();
									 	 		builder.getCellFormat().setWidth(90);
									 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
									 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
									 	 		builder.getFont().setBold(false);
									 	 		builder.write(StringUtil.checkNullToBlank(relItemClassCodeList.get(i)));
									 	 		builder.endRow();	
									 	 		ItemAttrInfo = new HashMap();
									 	 		no++; 
									 	 		
												//AttrInfoList = new HashMap();
									 	 		builder.insertHtml("<br>");
											}
										}
									}
				
								}
									builder.endTable().setAllowAutoFit(false);//Word 문서 안의 테이블을 종료하고, 자동 크기 조절을 설정하지 않도록설정
							}
				 	 		
				 	 		 //6. 기록 및 권한 
				 	 		  
				 	 		builder.getFont().setColor(Color.DARK_GRAY);
						    builder.getFont().setSize(11);
						    builder.getFont().setBold(true);
						    builder.getFont().setName(defaultFont);
							builder.insertHtml("<br>");
							builder.writeln("6. " + String.valueOf(AttrTypeList.get("ZAT02020")));
							//내용
				 	 		builder.getFont().setName(defaultFont);
					 	 	    builder.getFont().setColor(Color.BLACK);
					 	 	    builder.getFont().setSize(10);
					 	 	 	String ZAT02020 = StringUtil.checkNullToBlank(attrMap.get("ZAT02020")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
					 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("ZAT02020")))) { // type이 HTML인 경우
					 	 			if(StringUtil.checkNullToBlank(attrMap.get("ZAT02020")).contains("font-family")){
					 	 				builder.insertHtml(ZAT02020);
					 	 			}else{
					 	 				builder.insertHtml(fontFamilyHtml+ZAT02020+"</span>");
					 	 			}
					 	 		} else {
					 	 			builder.getFont().setBold(false);
					 	 			builder.write(ZAT02020); // 목적 : 내용
					 	 			builder.insertHtml("<br><br style='line-height:1.0;'>");
					 	 		}
				
					 	 	
					 	 	//7. 업무절차
					 	 	builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE); 	  
					 	 	builder.getFont().setColor(Color.DARK_GRAY);
							builder.getFont().setSize(11);
							builder.getFont().setBold(true);
							builder.getFont().setName(defaultFont);
							builder.writeln("7."+ String.valueOf(menu.get("LN00197")));
							

	
							// 표 생성

						
							
							// Some special features for the header row.
							
							//============================================== rasi 시작 
							List  <Map<String, Object>> activityList = (List)request.getAttribute("activityList"); //activityList 
							int activityNO=1;
							System.out.print("activityList:"+activityList);
							String split = "\\$\\$ ";
							for (Map<String, Object> item : activityList) {
								// 표 시작
							    builder.startTable();
							    builder.getRowFormat().clearFormatting();
								builder.getCellFormat().clearFormatting();
								
								String activityName = String.valueOf(item.get("Activity"));
								activityName=StringEscapeUtils.unescapeHtml4(activityName);
								activityName=activityName.replaceAll("<[^>]*>", "");
								builder.insertHtml("&emsp;");
								builder.writeln("7."+ String.valueOf(activityNO)+" "+activityName);
								builder.insertHtml("&emsp;&emsp;");
								builder.writeln("Activity 업무내용");
								// HTML 엔티티 디코딩
								builder.insertHtml("&emsp;&emsp;");
								String Outline = String.valueOf(item.get("Outline"));
								Outline = StringEscapeUtils.unescapeHtml4(Outline);
								Outline = Outline.replaceAll("<[^>]*>", "");              // 태그 제거
								Outline = StringEscapeUtils.unescapeHtml4(Outline);       // HTML 엔티티 제거
								Outline = Outline.replaceAll("[\\u00A0]+", " ");           // NBSP 제거
								Outline = Outline.replaceAll("&nbsp;+", " ");             // 남아있는 &nbsp; 제거
								Outline = Outline.trim();                                 // 양쪽 공백 정리
								builder.write(Outline);             

								
								// Make the header row.
								builder.insertCell();
								builder.getRowFormat().setHeight(30.0);
								builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
								
								builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
								builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
								builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
								builder.getFont().setSize(10);
								builder.getFont().setBold (true);
								builder.getFont().setColor(Color.BLACK);
								builder.getFont().setName(defaultFont);
								
								builder.getCellFormat().setWidth(70);
								builder.getCellFormat().setVerticalMerge(CellMerge.FIRST);  // ← 여기!
								builder.write("RASI"); // RASI
			
								builder.insertCell();
								builder.getCellFormat().setWidth(30);
								builder.getCellFormat().setVerticalMerge(CellMerge.NONE);
								builder.write("R"); // R
					
								builder.insertCell();
								builder.getCellFormat().setWidth(30);
								builder.getCellFormat().setVerticalMerge(CellMerge.NONE);
								builder.write("A");
								
								builder.insertCell();
								builder.getCellFormat().setWidth(30);
								builder.getCellFormat().setVerticalMerge(CellMerge.NONE);
								builder.write("S");
								
								builder.insertCell();
								builder.getCellFormat().setWidth(30);
								builder.getCellFormat().setVerticalMerge(CellMerge.NONE);
								builder.write("I");
							
								builder.endRow(); // 행 종료
								
								builder.getRowFormat().clearFormatting();
								builder.getCellFormat().clearFormatting();
								//다음행 시작 (데이터)	
								builder.insertCell();
								builder.getCellFormat().setWidth(70);
								builder.getCellFormat().setVerticalMerge(CellMerge.PREVIOUS);  // ← 여기!
								builder.write(""); // RASI
								
								
								
								// R
								String r_texts[] = StringUtil.checkNull(item.get("r_text")).split(split);
								String r_ItemIDs[] = StringUtil.checkNull(item.get("r_ItemID")).split(split);
								String r_text = "";
								for (int i = 0; i < r_texts.length; i++) {
									r_text += r_texts[i];
								}
							
								// HTML 엔티티 디코딩
								r_text = StringEscapeUtils.unescapeHtml4(r_text);
								builder.insertCell();
								builder.getFont().setBold (false);
								builder.getCellFormat().setWidth(30);
								builder.getCellFormat().setVerticalAlignment(CellMerge.NONE);
								builder.write(r_text); // R_text
								
								// A
								String a_texts[] = StringUtil.checkNull(item.get("a_text")).split(split);
								String a_ItemIDs[] = StringUtil.checkNull(item.get("a_ItemID")).split(split);
								String a_text = "";
								for (int i = 0; i < a_texts.length; i++) {
									a_text += a_texts[i];
								}
								
								// HTML 엔티티 디코딩
								
								a_text = StringEscapeUtils.unescapeHtml4(a_text);
								builder.insertCell();
								builder.getCellFormat().setWidth(30);
								builder.getCellFormat().setVerticalAlignment(CellMerge.NONE);
								builder.write(a_text); // A_text

								// S
								String s_texts[] = StringUtil.checkNull(item.get("s_text")).split(split);
								String s_ItemIDs[] = StringUtil.checkNull(item.get("s_ItemID")).split(split);
								String s_text = "";
								for (int i = 0; i < s_texts.length; i++) {
									s_text += s_texts[i];
								}
								
								s_text = StringEscapeUtils.unescapeHtml4(s_text);
								builder.insertCell();
								builder.getCellFormat().setWidth(30);
								builder.getCellFormat().setVerticalAlignment(CellMerge.NONE);
								builder.write(s_text); // S_text
								
								// I
								String i_texts[] = StringUtil.checkNull(item.get("i_text")).split(split);
								String i_ItemIDs[] = StringUtil.checkNull(item.get("i_ItemID")).split(split);
								String i_text = "";
								for (int i = 0; i < i_texts.length; i++) {
									i_text +=  i_texts[i];
								}
					
								i_text = StringEscapeUtils.unescapeHtml4(i_text);
								builder.insertCell();
								builder.getCellFormat().setWidth(30);
								builder.getCellFormat().setVerticalAlignment(CellMerge.NONE);
								builder.write(i_text); // I_text
								
								builder.endRow(); 
								
								//2행추가 input 
								builder.insertCell();
								builder.getCellFormat().setWidth(70);
								builder.getFont().setBold(true); // 일반 텍스트
								builder.getCellFormat().setVerticalMerge(CellMerge.FIRST); 
								builder.getCellFormat().setVerticalAlignment(CellMerge.NONE);
								builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
								builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);//텍스트를 가로 방향으로 가운데 정렬
								builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);//셀 내 텍스트의 세로방향 기준으로 가운데 정렬
								builder.write("입력물");
								
								builder.insertCell();
							    builder.getRowFormat().clearFormatting();
								builder.getCellFormat().clearFormatting();
								builder.getCellFormat().setWidth(120);
								builder.getFont().setBold(false); // 일반 텍스트
								builder.write(StringUtil.checkNull(item.get("Input")));
								
								builder.endRow(); // 행 종료
								
								//3행 추가 Output 
								builder.insertCell();
								builder.getCellFormat().setWidth(70);
								builder.getFont().setBold(true); // 일반 텍스트
								builder.getCellFormat().setVerticalMerge(CellMerge.FIRST); 
								builder.getCellFormat().setVerticalAlignment(CellMerge.NONE);
								builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
								builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);//텍스트를 가로 방향으로 가운데 정렬
								builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
								builder.write("출력물");
								
								builder.insertCell();
							    builder.getRowFormat().clearFormatting();
								builder.getCellFormat().clearFormatting();
								builder.getCellFormat().setWidth(120);
								builder.getFont().setBold(false); // 일반 텍스트
								builder.write(StringUtil.checkNull(item.get("Output")));
								
								builder.endRow(); // 행 종료
								
								
								builder.endTable().setAllowAutoFit(false);//테이블 종료
						
								
								//4행 추가 수행시스템 
								builder.insertCell();
								builder.getCellFormat().setWidth(70);
								builder.getFont().setBold(true); 
								builder.getCellFormat().setVerticalMerge(CellMerge.FIRST); 
								builder.getCellFormat().setVerticalAlignment(CellMerge.NONE);
								builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
								builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
								builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
								builder.write("수행 시스템");
								
								builder.insertCell();
							    builder.getRowFormat().clearFormatting();
								builder.getCellFormat().clearFormatting();
								builder.getCellFormat().setWidth(120);
								builder.getFont().setBold(false);
								builder.write(StringUtil.checkNull(item.get("PerformanceSystem")));
								
								builder.endRow(); // 행 종료
								
								
								builder.endTable().setAllowAutoFit(false);//테이블 종료
								builder.insertHtml("<br>");
								activityNO++;
							
							}

				
						
				 	 		
				//==================================================================================================
		 		
				//변경이력
			/* 	if (String.valueOf(request.getAttribute("csYN")).equals("on")) {
	 	 			builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
		 	 		builder.getFont().setColor(Color.DARK_GRAY);
				    builder.getFont().setSize(11);
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
					builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
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
					builder.endTable().setAllowAutoFit(false);
				} */
				//==================================================================================================
		 				
				
				
			
	 			
		 		/*
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
					builder.writeln(headerNO+". " + String.valueOf(menu.get("LN00197")));
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
	 	 		
	 	 		
	 	 		
		 		//첨부문서 목록
		 		if (String.valueOf(request.getAttribute("fileYN")).equals("on")) {
		 			builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
		 	 		builder.getFont().setColor(Color.DARK_GRAY);
				    builder.getFont().setSize(11);
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
					builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					builder.getFont().setSize(10);
					builder.getFont().setBold (true);
					builder.getFont().setColor(Color.BLACK);
					builder.getFont().setName(defaultFont);
					
					builder.getCellFormat().setWidth(50.0);
					builder.write(String.valueOf(menu.get("LN00024"))); // No
					builder.insertCell();
					builder.getCellFormat().setWidth(120.0);
					builder.write(String.valueOf(menu.get("LN00091"))); // 문서유형
					builder.insertCell();
					builder.getCellFormat().setWidth(300.0);
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
					    
					    builder.getCellFormat().setWidth(50.0);
					   	builder.write(StringUtil.checkNullToBlank(rowCnData.get("RNUM")));
					   	builder.insertCell();
					   	builder.getCellFormat().setWidth(120.0);
					   	builder.write(StringUtil.checkNullToBlank(rowCnData.get("FltpName")));
						builder.insertCell();
						builder.getCellFormat().setWidth(300.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						builder.write(StringUtil.checkNullToBlank(rowCnData.get("FileRealName"))); 
						builder.insertCell();
						builder.getCellFormat().setWidth(80.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.write(StringUtil.checkNullToBlank(rowCnData.get("LastUpdated")));
						builder.endRow();
					}	
					builder.endTable().setAllowAutoFit(false);	
				}
				//==================================================================================================
		 	
		 		
				//teamRole 목록
				if (String.valueOf(request.getAttribute("teamYN")).equals("on")) {
					builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
		 	 		builder.getFont().setColor(Color.DARK_GRAY);
				    builder.getFont().setSize(11);
				    builder.getFont().setBold(true);
				    builder.getFont().setName(defaultFont);
					builder.writeln(headerNO+". " + String.valueOf(menu.get("LN00036")));
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
					builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					builder.getFont().setSize(10);
					builder.getFont().setBold (true);
					builder.getFont().setColor(Color.BLACK);
					builder.getFont().setName(defaultFont);
					
					builder.getCellFormat().setWidth(50.0);
					builder.write(String.valueOf(menu.get("LN00024"))); // No
					builder.insertCell();
					builder.getCellFormat().setWidth(120.0);
					builder.write(String.valueOf(menu.get("LN00247"))); // 조직
					builder.insertCell();
					builder.getCellFormat().setWidth(280.0);
					builder.write(String.valueOf(menu.get("LN00162"))); // 상위조직
					builder.insertCell();
					builder.getCellFormat().setWidth(100.0);
					builder.write(String.valueOf(menu.get("LN00119"))); // 역할
					builder.insertCell();
					builder.getCellFormat().setWidth(80.0);
					builder.write(String.valueOf(menu.get("LN00078"))); // 등록일
					builder.endRow();	
					
					// Set features for the other rows and cells.
					builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
					builder.getCellFormat().setWidth(100.0);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					
					// Reset height and define a different height rule for table body
					builder.getRowFormat().setHeight(30.0);
					builder.getRowFormat().setHeightRule(HeightRule.AUTO);
					
					
					for(int j=0; j<roleList.size(); j++){
						data = (HashMap) roleList.get(j);
					    
				    	builder.insertCell();
					    if( j==0){
					    	// Reset font formatting.
					    	builder.getFont().setBold(false);
					    }
					    
					    builder.getCellFormat().setWidth(50.0);
					   	builder.write(StringUtil.checkNullToBlank(data.get("RNUM")));
					   	builder.insertCell();
					   	builder.getCellFormat().setWidth(120.0);
					   	builder.write(StringUtil.checkNullToBlank(data.get("TeamNM")));
						builder.insertCell();
						builder.getCellFormat().setWidth(280.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						builder.write(StringUtil.checkNullToBlank(data.get("TeamPath"))); 
						builder.insertCell();
						builder.getCellFormat().setWidth(100.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.write(StringUtil.checkNullToBlank(data.get("TeamRoleNM"))); 
						builder.insertCell();
						builder.getCellFormat().setWidth(80.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.write(StringUtil.checkNullToBlank(data.get("AssignedDate")));
						builder.endRow();
					}	
					builder.endTable().setAllowAutoFit(false);
				}
				//==================================================================================================
		 		
		 		// 액티비티리스트
		 		// Build the other cells.
		 		// 액티비티리스트나 연관항목중 한건이라도 존재하면 새로운 페이지를 추가한다
		 		//if (activityList.size() > 0 || relItemList.size() > 0) {
		 			
		 		//}
				
				*/	
				if (String.valueOf(request.getAttribute("subItemYN")).equals("on")) {
					builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
			 		// 액티비티 리스트 Title
			 		builder.getFont().setColor(Color.DARK_GRAY);
				    builder.getFont().setSize(11);
				    builder.getFont().setBold(true);
				    builder.getFont().setName(defaultFont);
					builder.writeln("프로세스 맵");
					builder.insertHtml("<br>");
					Map rowActData = new HashMap();	
					if (0 != modelMap.size()) {
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
					}
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
<script type="text/javascript">
    // JSP에서 전달된 값은 <% %>를 사용하여 자바스크립트로 전달할 수 있습니다.

    console.log("Selected Paper Size: " );
    
  
 </script>