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

 	List subTreeItemIDList = (List)request.getAttribute("subTreeItemIDList");
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
    builder.getCellFormat().setWidth(150.0);
    builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
    String imageFileName = logoPath + "logo_hanwha.png";
    builder.insertImage(imageFileName, 145, 25);
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
    builder.getCellFormat().setWidth(200);
    builder.write("본 문서는 (주)한화의 자산으로 임의 배포 및 반출을 허용하지 않습니다.");
    
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

			List L2SubItemInfoList = (List)allTotalMap.get("L2SubItemInfoList"); 
			List L2AttachFileList = (List)allTotalMap.get("L2AttachFileList"); // L2 첨부파일

			String selectedItemClass = StringUtil.checkNullToBlank(titleItemMap.get("ClassCode"));
		
		//==================================================================================================
		/* 표지 */
		//if (totalList.size() > 0) { 
			currentSection = builder.getCurrentSection();
		    pageSetup = currentSection.getPageSetup();
		    pageSetup.setDifferentFirstPageHeaderFooter(false);
		   // pageSetup.setD
		 	// 표지 START
		 	builder.startTable();
		 	builder.getCellFormat().getBorders().setLineWidth(0.0);
		 	
		 	// 1.image
		 	builder.insertCell();
    		builder.getCellFormat().setWidth(totalCellWidth);
		 	builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		 	builder.insertHtml("<br>");
		 	builder.insertImage(imageFileName, 277, 40);
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
			builder.write(String.valueOf(menu.get("LN00018"))); // 관리조직

			builder.insertCell();
			builder.getCellFormat().setWidth(200);
			builder.write(String.valueOf(menu.get("LN00004"))); // 담당자

			builder.insertCell();
			builder.getCellFormat().setWidth(100);
			builder.write(String.valueOf(menu.get("LN00070"))); //수정일
			
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
			builder.write(StringUtil.checkNullToBlank(titleItemMap.get("OwnerTeamName")));				
			builder.insertCell();
		    builder.getCellFormat().setWidth(200);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(StringUtil.checkNullToBlank(titleItemMap.get("Name")));
			builder.insertCell();
		   	builder.getCellFormat().setWidth(100);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(StringUtil.checkNullToBlank(titleItemMap.get("LastUpdated")));	
			builder.endRow();
			builder.endTable().setAlignment(TabAlignment.CENTER);
			builder.endRow();		
			builder.endTable().setAllowAutoFit(false);
    		///////////////////////////////////////////////////////////////////////////////////////
    		// 표지 END
    		
    		
    		
    		if(subTreeItemIDList.size() > 0){
   				if(((List) ((Map)subTreeItemIDList.get(0)).get("l3l4ItemIdList")).size() > 0) {
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
				    
					for (int lowlankCnt = 0;subTreeItemIDList.size() > lowlankCnt ; lowlankCnt++) {
						Map lowLankItemIdMap = (Map) subTreeItemIDList.get(lowlankCnt);
						
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
				//builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);		
	   		}
			// content END

    		// L2 기본정보 : ID,명칭,개요
    		if(selectedItemClass.equals("CL01002") ){
    			builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
    	   		
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
    	 	   	name = StringUtil.checkNullToBlank(titleItemMap.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
    	 	   	name = name.replace("&#10;", " ");
    	 	   	name = name.replace("&#xa;", "");
    	 	    name = name.replace("&nbsp;", " ");
    	 	    builder.write(titleItemMap.get("Identifier") + name);  
    	 	    
    	 	    builder.getFont().setName(defaultFont);
    	 	    builder.getFont().setColor(Color.LIGHT_GRAY);
    	 	    builder.getFont().setSize(11);
    	 	    
    	 	    builder.insertCell();
    	 		builder.getCellFormat().getBorders().setColor(Color.WHITE);
    	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
    	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.RIGHT);
    	 	    builder.write(String.valueOf(titleItemMap.get("Path"))); 
    	 	    builder.endRow();	
    	 	    builder.endTable().setAllowAutoFit(false);	
    	 	    
    	 	    // 타이틀과 내용 사이 간격
    	 	    builder.insertHtml("<hr size=4 color='silver'/>");
    	 	 	// 머릿말 : END
    	 	 	builder.moveToDocumentEnd();
    	 	  	//==================================================================================================
    		 	  			
    	   		
    	   		// 프로세스 기본 정보 Title
    		 	builder.getFont().setColor(Color.DARK_GRAY);
    		    builder.getFont().setSize(11);
    		    builder.getFont().setBold(true);
    		    builder.getFont().setName(defaultFont);
    		    builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
    			builder.writeln("1." + String.valueOf(menu.get("LN00005")));
    			
    			builder.startTable();
    		 	
    			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
    			//builder.insertHtml("<br>");
    			//builder.insertHtml("<br>");
    	 	    builder.getFont().setName(defaultFont);
    	 	    builder.getFont().setColor(Color.BLACK);
    	 	    builder.getFont().setSize(10);
    	 		
    	 		// Make the header row.
    	 		builder.getRowFormat().clearFormatting();
    	 		builder.getCellFormat().clearFormatting();
    	 		builder.getRowFormat().setHeight(250.0);
    	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경
    			
    	 		// 1.ROW : ID,명칭
    	 		builder.insertCell();
    	 		//==================================================================================================	
    	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
    	 		builder.getCellFormat().setWidth(titleCellWidth);
    	 		builder.getRowFormat().setHeight(30.0);
    	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
    	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
    	 		builder.getFont().setBold (true);
    	 		builder.write("ID");  // ID
    	 	
    	 		builder.insertCell();
    	 		builder.getCellFormat().setWidth(contentCellWidth);
    	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
    	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
    			builder.getFont().setBold(false);
    			builder.write(StringUtil.checkNullToBlank(titleItemMap.get("Identifier"))); // Identifier
    	 		
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
    			builder.write(StringUtil.checkNullToBlank(titleItemMap.get("ItemName"))); // 명칭
    	 		//==================================================================================================	
    	 		builder.endRow();
    			
    			// 2.ROW : 개요
    	 		builder.insertCell();
    	 		//==================================================================================================	
    	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
    	 		builder.getCellFormat().setWidth(titleCellWidth);
    	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
    	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
    	 		builder.getFont().setBold (true);
    	 		builder.write(String.valueOf(menu.get("LN00035")));  // 개요
    	 		
    	 		builder.insertCell();
    	 		builder.getCellFormat().setWidth(mergeCellWidth);
    	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
    	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
    	 		String Description = StringUtil.checkNullToBlank(titleItemMap.get("Description")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
    	 		builder.insertHtml(fontFamilyHtml+Description.replace("upload/", logoPath)+"</span>");
    	 		builder.endRow();
    	 		
    	 		// 3.ROW :클래스
    	 		builder.insertCell();
    	 		//==================================================================================================	
    	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
    	 		builder.getCellFormat().setWidth(titleCellWidth);
    	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
    	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
    	 		builder.getFont().setBold (true);
    	 		builder.write(String.valueOf(menu.get("LN00016")));  // 클래스
    	 		
    	 		builder.insertCell();
    	 		builder.getCellFormat().setWidth(mergeCellWidth);
    	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
    	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
    			builder.write(StringUtil.checkNullToBlank(titleItemMap.get("ClassName"))); // ClassName
    			//==================================================================================================	
    	 		builder.endRow();
    			
    			//4.ROW : 관리조직, 담당자
    	 		builder.insertCell();
    	 		//==================================================================================================	
    	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
    	 		builder.getCellFormat().setWidth(titleCellWidth);
    	 		builder.getRowFormat().setHeight(30.0);
    	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
    	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
    	 		builder.getFont().setBold (true);
    	 		builder.write(String.valueOf(menu.get("LN00018")));  // 관리조직
    	 	
    	 		builder.insertCell();
    	 		builder.getCellFormat().setWidth(contentCellWidth);
    	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
    	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
    			builder.getFont().setBold(false);
    			builder.write(StringUtil.checkNullToBlank(titleItemMap.get("OwnerTeamName"))); // 관리조직
    	 		
    	 		builder.insertCell();
    	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
    	 		builder.getCellFormat().setWidth(titleCellWidth);
    	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
    	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
    	 		builder.getFont().setBold (true);
    	 		builder.write(String.valueOf(menu.get("LN00004")));  // 담당
    	 		
    	 		builder.insertCell();
    	 		builder.getCellFormat().setWidth(contentCellWidth);
    	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
    	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
    			builder.getFont().setBold(false);
    			builder.write(StringUtil.checkNullToBlank(titleItemMap.get("Name"))); // 담당
    	 		//==================================================================================================	
    	 		builder.endRow();
    			
    			//5.ROW : 생성일, 수정일
    	 		builder.insertCell();
    	 		//==================================================================================================	
    	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
    	 		builder.getCellFormat().setWidth(titleCellWidth);
    	 		builder.getRowFormat().setHeight(30.0);
    	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
    	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
    	 		builder.getFont().setBold (true);
    	 		builder.write(String.valueOf(menu.get("LN00013")));  // 생성일
    	 	
    	 		builder.insertCell();
    	 		builder.getCellFormat().setWidth(contentCellWidth);
    	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
    	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
    			builder.getFont().setBold(false);
    			builder.write(StringUtil.checkNullToBlank(titleItemMap.get("CreateDT"))); // 생성일
    	 		
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
    			builder.write(StringUtil.checkNullToBlank(titleItemMap.get("LastUpdated"))); //수정일
    	 		//==================================================================================================	
    	 		builder.endRow();
    	 		
    	 		builder.endTable().setAllowAutoFit(false);
    		 	builder.writeln();
    		}
	   		
    		// L2 SubProcess List 
    		//==================================================================================================		
    		if (L2SubItemInfoList.size() > 0) { 				
    			// 프로세스 기본 정보 Title
    		 	builder.getFont().setColor(Color.DARK_GRAY);
    		    builder.getFont().setSize(11);
    		    builder.getFont().setBold(true);
    		    builder.getFont().setName(defaultFont);
    		    builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
    			builder.writeln("2.하위 프로세스");
    			builder.startTable();
    		 	
    			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
    	 	    builder.getFont().setName(defaultFont);
    	 	    builder.getFont().setColor(Color.BLACK);
    	 	    builder.getFont().setSize(10);
    	 		
    	 		// Make the header row.
    	 		builder.getRowFormat().clearFormatting();
    	 		builder.getCellFormat().clearFormatting();
    	 		builder.getRowFormat().setHeight(250.0);
    	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경
    	 		
    	 		builder.insertCell();
    	 		//==================================================================================================	
    	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
    	 		builder.getCellFormat().setWidth(50);
    	 		builder.getRowFormat().setHeight(30.0);
    	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
    	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
    	 		builder.getFont().setBold (true);
    	 		builder.write(String.valueOf(menu.get("LN00042")));  // 구분
    	 	
    	 		builder.insertCell();
    	 		builder.getCellFormat().setWidth(60);
    	 		//builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
    	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
    			builder.getFont().setBold(false);
    			builder.write(String.valueOf(menu.get("LN00106")));  // ID
    			
    			builder.insertCell();
    	 		builder.getCellFormat().setWidth(120);
    	 		//builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
    	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
    			builder.getFont().setBold(false);
    			builder.write(String.valueOf(menu.get("LN00006")));  // 명칭        
    			
    			builder.insertCell();
    	 		builder.getCellFormat().setWidth(340);
    	 		//builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
    	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
    			builder.getFont().setBold(false);
    			builder.write(String.valueOf(menu.get("LN00035")));  // 개요
    			builder.endRow();
    			
    		 	for (int index = 0; L2SubItemInfoList.size() > index ; index++) {
    		 		Map L2SubItemInfoMap = (Map)L2SubItemInfoList.get(index); 
    		 		// 1.ROW : ID,명칭
    		 		builder.insertCell();
    		 		//==================================================================================================	
    		 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
    		 		builder.getCellFormat().setWidth(50);
    		 		builder.getRowFormat().setHeight(30.0);
    		 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
    		 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
    		 		builder.getFont().setBold (true);
    		 		builder.write("Sub");  // SubProcess
    		 	
    		 		builder.insertCell();
    		 		builder.getCellFormat().setWidth(60);
    		 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
    		 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
    				builder.getFont().setBold(false);
    				builder.write(StringUtil.checkNullToBlank(L2SubItemInfoMap.get("toItemIdentifier"))); // Identifier
    		 		
    		 		builder.insertCell();
    		 		builder.getCellFormat().setWidth(120);
    		 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
    		 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
    				builder.getFont().setBold(false);
    				builder.write(StringUtil.checkNullToBlank(L2SubItemInfoMap.get("toItemName"))); // 명칭
    				
    				builder.insertCell();
    		 		builder.getCellFormat().setWidth(340);
    		 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
    		 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
    				builder.getFont().setBold(false);
    				String toItemDescription = StringUtil.checkNullToBlank(L2SubItemInfoMap.get("toItemDescription")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
    				builder.insertHtml(fontFamilyHtml+toItemDescription.replace("upload/", logoPath)+"</span>");
    				
    		 		//==================================================================================================	
    		 		builder.endRow();	
    		 	} 
    	 		builder.endTable().setAllowAutoFit(false);
    	 		builder.writeln();
    			//==================================================================================================
    			// END L2 SubProcess List 
    		}//==================================================================================================
    	 	// 3. 첨부문서
    	 	if(selectedItemClass.equals("CL01002")){ // L2일때만	  		
     	 		builder.getFont().setColor(Color.DARK_GRAY);
    		    builder.getFont().setSize(11);
    		    builder.getFont().setBold(true);
    		    builder.getFont().setName(defaultFont);
    		    builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
    			builder.write("3. " + String.valueOf(menu.get("LN00019")));
    			
    			if (L2AttachFileList.size() > 0) {
    				Map L2FileListMap = new HashMap();
    		 		
    				builder.startTable();
    				builder.getRowFormat().clearFormatting();
    				builder.getCellFormat().clearFormatting();
    				
    				// Make the header row.
    				builder.insertCell();
    				builder.getRowFormat().setHeight(10.0);
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
    				
    				for(int j=0; j<L2AttachFileList.size(); j++){
    					L2FileListMap = (HashMap) L2AttachFileList.get(j);
    				    
    			    	builder.insertCell();
    				    if( j==0){
    				    	// Reset font formatting.
    				    	builder.getFont().setBold(false);
    				    }
    				    
    				    builder.getCellFormat().setWidth(20.0);
    				   	builder.write(StringUtil.checkNullToBlank(L2FileListMap.get("RNUM")));
    				   	builder.insertCell();
    				   	builder.getCellFormat().setWidth(120.0);
    				   	builder.write(StringUtil.checkNullToBlank(L2FileListMap.get("FltpName")));
    					builder.insertCell();
    					builder.getCellFormat().setWidth(210.0);
    					builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
    					builder.write(StringUtil.checkNullToBlank(L2FileListMap.get("FileRealName"))); 
    					builder.insertCell();
    					builder.getCellFormat().setWidth(80.0);
    					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
    					builder.write(StringUtil.checkNullToBlank(L2FileListMap.get("LastUpdated")));
    					builder.endRow();
    				}	
    				builder.endTable().setAllowAutoFit(false);	
    				
    			} 
    			builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
    			//==================================================================================================
    	
    			//======================================================================================================
    			// 4.운영원칙
    		 	builder.getFont().setColor(Color.DARK_GRAY);
    		    builder.getFont().setSize(11);
    		    builder.getFont().setBold(true);
    		    builder.getFont().setName(defaultFont);
    		    builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
    			builder.write("4.운영원칙");
    			
    			builder.startTable();
    		 	
    			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
    	 	    builder.getFont().setName(defaultFont);
    	 	    builder.getFont().setColor(Color.BLACK);
    	 	    builder.getFont().setSize(10);
    	 		
    	 		// Make the header row.
    	 		builder.getRowFormat().clearFormatting();
    	 		builder.getCellFormat().clearFormatting();
    	 		builder.getRowFormat().setHeight(250.0);
    	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경
    	 		
    	 		builder.insertCell();
     	 		builder.getCellFormat().setWidth(totalCellWidth);
     	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
     	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
     	 		builder.insertHtml("<br>"); 	 		
     	 		String OprRuleL2 = StringUtil.checkNullToBlank(titleItemMap.get("OprRule")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
    			builder.insertHtml(fontFamilyHtml+OprRuleL2.replace("upload/", logoPath)+"</span>"); 	 	
     	 		//==================================================================================================	
     	 		builder.endRow(); 	 		
    	 		builder.endTable().setAllowAutoFit(false);
    	 		//builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
    	 	}
    		
    		
		//==================================================================================================
		
		if (totalList.size() > 0) {
	 	for (int index = 0; totalList.size() > index ; index++) {
 			builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
	 		
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
			
	 		// 아이템 속성 		
	 		if ("N".equals(onlyMap)) {
	 			//==================================================================================================
		 		// 머릿말 : START
				currentSection = builder.getCurrentSection();
			    pageSetup = currentSection.getPageSetup();
			    pageSetup.setDifferentFirstPageHeaderFooter(false);
			    pageSetup.setHeaderDistance(20);
			    builder.moveToHeaderFooter(HeaderFooterType.HEADER_PRIMARY);
			    
				builder.startTable();
				builder.getRowFormat().clearFormatting();
				builder.getCellFormat().clearFormatting();
				builder.getRowFormat().setHeight(25.0);
				builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
				
				builder.insertCell();
				builder.getCellFormat().setWidth(300);
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
			    builder.write(StringUtil.checkNullToBlank(rowPrcData.get("Identifier")) + name);
			   
			    builder.getFont().setName(defaultFont);
			    builder.getFont().setColor(Color.LIGHT_GRAY);
			    builder.getFont().setSize(12);
			    
			    builder.insertCell();
			    builder.getCellFormat().setWidth(300);
				builder.getCellFormat().getBorders().setColor(Color.WHITE);
				builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				builder.getParagraphFormat().setAlignment(ParagraphAlignment.RIGHT);
				String path = String.valueOf(rowPrcData.get("Path"));
				if (path.equals("/")) {
					path = "";
				}
			    builder.write(path);  
			    builder.endRow();	
			    builder.endTable().setAllowAutoFit(false);	
			    
			    // 타이틀과 내용 사이 간격
			    builder.insertHtml("<hr size=3 color='silver'/>");
			    
			 	// 머릿말 : END
			 	builder.moveToDocumentEnd();
		 	  	//==================================================================================================
		 	  	
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
	 	 	    
	 	 		
	 	 	 	// 1.ROW : 개요	 	 	 	
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
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
	 	 		
	 	 		// 2.ROW : 관리조직, 작성자
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getRowFormat().setHeight(30.0);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(menu.get("LN00018")));  // 관리조직
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold (false);
	 	 		builder.write(StringUtil.checkNullToBlank(rowPrcData.get("OwnerTeamName"))); // 관리조죅
	 	 		
	 	 		
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
	 	 		builder.write(StringUtil.checkNullToBlank(rowPrcData.get("Name"))); // 작성자 : 내용
	 	 		
	 	 		builder.endRow();
	 	 		
	 	 		builder.getRowFormat().clearFormatting();
				builder.getCellFormat().clearFormatting();
				builder.getRowFormat().setHeight(30.0);
	 	 		//builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경
					 	 		
	 	 		// 5.ROW : Input,Output
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00015")));  // Input
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
	 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00015"))); // Input : 내용
	 	 		
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00016")));  //output
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
	 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00016"))); // Output 	 	 
	 	 	
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 		// 9.ROW : 실행부서, 유관부서
	 	 		builder.insertCell();	 	 	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getRowFormat().setHeight(30.0);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00010")));  //실행부서
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
 	 			builder.getFont().setBold(false);
 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00010"))); // 조직 : 실행부서
 	 			
 	 			builder.insertCell();	 	 	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getRowFormat().setHeight(30.0);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00017")));  //유관부서
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
 	 			builder.getFont().setBold(false);
 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00017"))); // 조직 : 유관부서
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 		// 6.ROW : 주기, 비고
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00009")));  // Input
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
	 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00009"))); // Input : 내용
	 	 		
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00006")));  //비고
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
	 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00006"))); // 비고 	 	 
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 	// 10.ROW : 수정일, Progress
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
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(titleCellWidth);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(AttrTypeList.get("AT00026")));  // Progress
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
	 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00026"))); // Progress : 내용
	 	 		builder.endRow();
	 	 		//==================================================================================================
	 	 		
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
	 	 		
	 	 		int headerNO = 2;
	 	 		// 2. 선/후행 프로세스
	 	 		if (0 != modelMap.size()) {
	 	 			if (String.valueOf(request.getAttribute("occYN")).equals("on")) {
	 	 				builder.getFont().setColor(Color.DARK_GRAY);
					    builder.getFont().setSize(11);
					    builder.getFont().setBold(true);
					    builder.getFont().setName(defaultFont);
						builder.writeln(headerNO+". " + String.valueOf(menu.get("LN00178"))+"Process");
						headerNO++;
						
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
							
							if(StringUtil.checkNullToBlank(processInfo).contains("font-family")){	
								builder.insertHtml(processInfo);
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+processInfo+"</span>",false);
			 	 			}
							
							builder.endRow();
						}	
						
						builder.endTable().setAllowAutoFit(false);	
				 		builder.insertHtml("<br>");
						builder.insertHtml("<br>");
			 		}
	 	 		}
		 		
				//==================================================================================================
		 		
				//첨부문서 목록
		 		if (String.valueOf(request.getAttribute("fileYN")).equals("on")) {
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
					builder.insertHtml("<br>");
					builder.insertHtml("<br>");
				}
				//==================================================================================================
		 		
				
				//3. 관련항목
				Map cnAttrList = new HashMap();
				List cnAttr = new ArrayList();
				Map AttrInfoList = new HashMap();
				Map ItemAttrInfo = new HashMap();
				if (String.valueOf(request.getAttribute("cxnYN")).equals("on")) {
					for(int i=0; i <relItemClassCodeList.size() ; i++){
						builder.getFont().setColor(Color.DARK_GRAY);
					    builder.getFont().setSize(11);
					    builder.getFont().setBold(true);
					    builder.getFont().setName(defaultFont);
						
						if(relItemClassCodeList.get(i).equals("CL08002")){
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
									builder.getRowFormat().setHeight(20.0);
									builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
						 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
						 	 		builder.getCellFormat().setWidth(titleCellWidth);
						 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
						 	 		builder.getFont().setSize(10);
									builder.getFont().setBold (true);
									builder.getFont().setColor(Color.BLACK);
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
						 	 		ItemAttrInfo = new HashMap();
						 	 		//==================================================================================================	
						 	 		
									//==================================================================================================	
						 	 		ItemAttrInfo = (Map)AttrInfoList.get("AT00007");
									// 3.ROW - IT 요구사항
									builder.insertCell();
						 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
						 	 		builder.getCellFormat().setWidth(titleCellWidth);
						 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
						 	 		builder.getFont().setBold (true);
						 	 		builder.write(String.valueOf(AttrTypeList.get("AT00007")));
						 	 		
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
				}
				
				builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
				//5. 운영원칙
				builder.startTable();
	 			// 프로세스 기본 정보 Title
	 	 		builder.getFont().setColor(Color.DARK_GRAY);
			    builder.getFont().setSize(11);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
			    builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);			    
				builder.writeln(headerNO+". 운영원칙");
				headerNO++;
	 	 		
	 	 	    builder.getFont().setColor(Color.BLACK);
	 	 	    builder.getFont().setSize(10);
	 	 		
	 	 		// Make the header row.
	 	 		builder.getRowFormat().clearFormatting();
	 	 		builder.getCellFormat().clearFormatting();
	 	 		builder.getRowFormat().setHeight(250.0);
	 	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경
	 	 		
	 	 	 	// 1.ROW : 운영원칙
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 	
	 	 		builder.getCellFormat().setWidth(totalCellWidth);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		
	 	 		String AT00008 = StringUtil.checkNullToBlank(attrMap.get("AT00008")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
	 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00008")))) { // type이 HTML인 경우
	 	 			if(StringUtil.checkNullToBlank(attrMap.get("AT00008")).contains("font-family")){
	 	 				builder.insertHtml(AT00008);
	 	 			}else{
	 	 				builder.insertHtml(fontFamilyHtml+AT00008+"</span>");
	 	 			}
	 	 		} else {
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(AT00008); // 운영원칙 : 내용
	 	 		}
	 	 		//==================================================================================================	
	 	 		builder.endRow(); 
	 	 		builder.endTable().setAllowAutoFit(false);
	 			
		 		
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
	 	 		
		 		// 액티비티리스트
				if (String.valueOf(request.getAttribute("subItemYN")).equals("on")) {
					builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
			 		// 액티비티 리스트 Title
			 		builder.getFont().setColor(Color.DARK_GRAY);
				    builder.getFont().setSize(11);
				    builder.getFont().setBold(true);
				    builder.getFont().setName(defaultFont);
					builder.writeln(headerNO+". " + String.valueOf(menu.get("LN00151")));
					Map rowActData = new HashMap();	
					for(int j=0; j<activityList.size(); j++){
						rowActData = (HashMap) activityList.get(j);
						
						builder.getFont().setColor(Color.DARK_GRAY);
					    builder.getFont().setSize(11);
					    builder.getFont().setBold(true);
					    builder.getFont().setName(defaultFont);
					    
					    builder.insertHtml("<br>"); 
					    String identifier =  StringUtil.checkNullToBlank(rowActData.get("Identifier"));
					    String itemName = StringUtil.checkNullToBlank(rowActData.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
						itemName = itemName.replace("&#10;", " ");
						itemName = itemName.replace("&#xa;", "");
						itemName = itemName.replace("&nbsp;", " "); 
						itemName = itemName.replace("&amp;", "&"); 
								    
					    builder.writeln(identifier+" "+itemName); //명칭	
					
					    	
					  	builder.startTable();
			 	
			 	 		builder.getFont().setColor(Color.DARK_GRAY);
					    builder.getFont().setSize(11);
					    builder.getFont().setBold(true);
					    builder.getFont().setName(defaultFont);
					    builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
							 	 		
			 	 	    builder.getFont().setName(defaultFont);
			 	 	    builder.getFont().setColor(Color.BLACK);
			 	 	    builder.getFont().setSize(10);
			 	 		
			 	 		// Make the header row.
			 	 		builder.getRowFormat().clearFormatting();
			 	 		builder.getCellFormat().clearFormatting();
			 	 		builder.getRowFormat().setHeight(50.0);
			 	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경
			 	 		
			 	 	 	// 1.ROW : 개요
			 	 		builder.insertCell();
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(AttrTypeList.get("AT00003")));  // 개요
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(mergeCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		//builder.getFont()
			 	 		
			 	 		String ATVITAT00003 = StringUtil.checkNullToBlank(rowActData.get("AT00003")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
						if(StringUtil.checkNullToBlank(rowActData.get("AT00003")).contains("font-family")){	
							builder.insertHtml(ATVITAT00003);
		 	 			}else{
		 	 				builder.insertHtml(fontFamilyHtml+ATVITAT00003+"</span>");
		 	 			}			 	 
						builder.insertHtml("<br>");
			 	 		//==================================================================================================	
			 	 		builder.endRow();	 
			 	 		
			 	 		builder.getRowFormat().clearFormatting();
						builder.getCellFormat().clearFormatting();
						builder.getRowFormat().setHeight(10.0);
			 	 		//builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경
			 	 		
			 	 		// 2.ROW : Input,Output
			 	 		builder.insertCell();
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(AttrTypeList.get("AT00015")));  // Input
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getFont().setBold(false);
			 	 		builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00015"))); // Input 
			 	 		
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(AttrTypeList.get("AT00016")));  // Output
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getFont().setBold (false);
			 	 		builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00016"))); // Output : 
			 	 		
			 	 		//==================================================================================================	
			 	 		builder.endRow();
			 	 		
			 	 			 	 		
			 	 		// 2.시스템, 화면코드
			 	 		builder.insertCell();	 	 	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getRowFormat().setHeight(10.0);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(AttrTypeList.get("AT00013")));  //시스템
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		 	 			builder.getFont().setBold(false);
		 	 			builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00013"))); //시스템
		 	 			
		 	 			builder.insertCell();	 	 	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getRowFormat().setHeight(10.0);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(AttrTypeList.get("AT00014")));  //화면코드
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		 	 			builder.getFont().setBold(false);
		 	 			builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00014"))); // 화면코드	 	 			
		 	 		
			 	 		//==================================================================================================	
			 	 		builder.endRow();	
		 	 			
			 	 	// 3.주기, 실행부서
			 	 		builder.insertCell();	 	 	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getRowFormat().setHeight(10.0);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(AttrTypeList.get("AT00009")));  //주기
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		 	 			builder.getFont().setBold(false);
		 	 			builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00009"))); //주기
		 	 			
		 	 			builder.insertCell();	 	 	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getRowFormat().setHeight(10.0);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(AttrTypeList.get("AT00010")));  //실행부서
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		 	 			builder.getFont().setBold(false);
		 	 			builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00010"))); //실행부서
		 	 			builder.endRow();	
		 	 			
		 	 			
		 	 			builder.insertCell();	 	 	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getRowFormat().setHeight(10.0);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(AttrTypeList.get("AT00006")));  //비고
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(mergeCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		 	 			builder.getFont().setBold(false);
		 	 			builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00006"))); // 비고	 	 			
		 	 		
			 	 		//==================================================================================================	
			 	 		builder.endRow();	
			 	 		builder.endTable().setAllowAutoFit(false);
					}
				}
		 		
				if (String.valueOf(request.getAttribute("csYN")).equals("on")) {
					builder.insertHtml("<BR>");	
		 	 		builder.getFont().setColor(Color.DARK_GRAY);
				    builder.getFont().setSize(11);
				    builder.getFont().setBold(true);
				    builder.getFont().setName(defaultFont);
					builder.writeln(headerNO+". 개정이력");
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
					
					builder.getCellFormat().setWidth(60.0);
					builder.write("Version"); 
					builder.insertCell();
					builder.getCellFormat().setWidth(80.0);
					builder.write(String.valueOf(menu.get("LN00022"))); // 변경구분
					builder.insertCell();
					builder.getCellFormat().setWidth(140.0);
					builder.write(String.valueOf(menu.get("LN00131"))); // 프로젝트
					builder.insertCell();
					builder.getCellFormat().setWidth(80.0);
					builder.write(String.valueOf(menu.get("LN00004"))); // 담당자
					builder.insertCell();
					builder.getCellFormat().setWidth(120.0);
					builder.write(String.valueOf(menu.get("LN00018"))); // 관리조직
					builder.insertCell();
					builder.getCellFormat().setWidth(80.0);
					builder.write(String.valueOf(menu.get("LN00063"))); // 시작일
					builder.insertCell();
					builder.getCellFormat().setWidth(80.0);
					builder.write(String.valueOf(menu.get("LN00064"))); // 완료일
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
					    
					    builder.getCellFormat().setWidth(60.0);
					   	builder.write(StringUtil.checkNullToBlank(data.get("Version")));
					   	builder.insertCell();
					    builder.getCellFormat().setWidth(80.0);
					   	builder.write(StringUtil.checkNullToBlank(data.get("ChangeType")));
					   	builder.insertCell();
					   	builder.getCellFormat().setWidth(140.0);
					   	builder.write(StringUtil.checkNullToBlank(data.get("ProcjectName")));
						builder.insertCell();
						builder.getCellFormat().setWidth(80.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.write(StringUtil.checkNullToBlank(data.get("AuthorName"))); 
						builder.insertCell();
						builder.getCellFormat().setWidth(120.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.write(StringUtil.checkNullToBlank(data.get("AuthorTeamName")));						
						builder.insertCell();
						builder.getCellFormat().setWidth(80.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.write(StringUtil.checkNullToBlank(data.get("StartDate")));
						builder.insertCell();
						builder.getCellFormat().setWidth(80.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.write(StringUtil.checkNullToBlank(data.get("CompletionDT")));
						builder.endRow();
						
						if(!StringUtil.checkNullToBlank(data.get("Description")).equals("") && data.get("Description") != null){
							builder.insertCell();
				 	 		builder.getCellFormat().setWidth(mergeCellWidth);
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);			 	 		
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(data.get("Description"))); // 개요 : 내용
				 	 		builder.endRow();	 
						}
					}	
					builder.endTable().setAllowAutoFit(false);
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
		String selectedItemIdentifier = String.valueOf(request.getAttribute("selectedItemIdentifier"));
		String fileName = "HW-PD-" + selectedItemIdentifier +"-"+ itemNameOfFileNm + "_" + formatter.format(date) +".docx";
	    if(outputType.equals("pdf")){
	    	fileName = "HW-PD-" + selectedItemIdentifier +"-"+ itemNameOfFileNm + "_" + formatter.format(date) +".pdf";
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
