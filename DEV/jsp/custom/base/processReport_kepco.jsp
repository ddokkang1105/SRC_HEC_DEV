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

<%@page import="org.apache.commons.logging.Log" %>
<%@page import="org.apache.commons.logging.LogFactory" %>


<%

final Log log = LogFactory.getLog(this.getClass());

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
 	
 	List subTreeItemIDList = (List)request.getAttribute("subTreeItemIDList");
 	String selectedItemPath = String.valueOf(request.getAttribute("selectedItemPath"));
 	String reportCode = String.valueOf(request.getAttribute("reportCode"));
 	double titleCellWidth = 60.0;
 	double titleCellWidthL4 = 90.0;
 	double contentCellWidth3 = 90.0;
	double contentCellWidth = 165.0;
	double mergeCellWidth = 500.0;
	double totalCellWidth = 560.0;
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
    builder.write("본 문서는 한국전력공사의 자산으로 임의 배포 및 반출을 허용하지 않습니다.");
    
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
		
		List L2SubItemInfoList = (List)allTotalMap.get("L2SubItemInfoList"); 
		List L2AttachFileList = (List)allTotalMap.get("L2AttachFileList"); // L2 첨부파일
		String selectedItemClass = StringUtil.checkNullToBlank(titleItemMap.get("ClassCode"));
		String fontFamilyHtml = "<span style=\"font-family:"+defaultFont+"; font-size: 10pt;\">";
		String ulStyle = "<ul style=\"padding-left:30px;\">";
		String olStyle = "<ol style=\"padding-left:30px;\">";
		//==================================================================================================
		/* 표지 */
		//if (totalList.size() > 0) { 
		currentSection = builder.getCurrentSection();
	    pageSetup = currentSection.getPageSetup();
	    pageSetup.setDifferentFirstPageHeaderFooter(false);
	    
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
   		builder.getFont().setColor(Color.DARK_GRAY);
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
		builder.insertCell();
		builder.getCellFormat().setWidth(40); // 테이블 앞 여백 설정
		
		builder.insertCell();
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getCellFormat().setWidth(320);
		
		builder.startTable();
		builder.getRowFormat().clearFormatting();
		builder.getCellFormat().clearFormatting();
		
		// Make the header row.
		builder.insertCell();
		
		builder.getRowFormat().setHeight(30);
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
   		
   		if (totalList.size() > 0) { 
   			if(subTreeItemIDList.size() > 0){
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
				//builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);		
	   		}   	
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
	 		String Description = StringUtil.checkNullToBlank(titleItemMap.get("Description")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replaceAll("<ul>",ulStyle).replaceAll("<ol>",olStyle);
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
		} // END if(selectedItemClass.equals("CL01002"))	  	
		// END L2 기본정보 
		
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
				String toItemDescription = StringUtil.checkNullToBlank(L2SubItemInfoMap.get("toItemDescription")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replaceAll("<ul>",ulStyle).replaceAll("<ol>",olStyle);
				builder.insertHtml(fontFamilyHtml+toItemDescription.replace("upload/", logoPath)+"</span>");
				
		 		//==================================================================================================	
		 		builder.endRow();	
		 	} 
	 		builder.endTable().setAllowAutoFit(false);
	 		builder.writeln();
			//==================================================================================================
			// END L2 SubProcess List 
		}
		//==================================================================================================
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
 	 		String OprRuleL2 = StringUtil.checkNullToBlank(titleItemMap.get("OprRule")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replaceAll("<ul>",ulStyle).replaceAll("<ol>",olStyle);
			builder.insertHtml(fontFamilyHtml+OprRuleL2.replace("upload/", logoPath)+"</span>"); 	 	
 	 		//==================================================================================================	
 	 		builder.endRow(); 	 		
	 		builder.endTable().setAllowAutoFit(false);
	 		//builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
	 	} // END if(selectedItemClass.equals("CL01002")){
		
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
 	 		builder.insertHtml(fontFamilyHtml+StringUtil.checkNullToBlank(e2eAttrMap.get("AT00003")).replace("upload/", logoPath)+"</span>");
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
 	 		builder.insertHtml(fontFamilyHtml+StringUtil.checkNullToBlank(e2eAttrMap.get("AT00020"))+"</span>");
 	 		
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
 	 		builder.insertHtml(fontFamilyHtml+StringUtil.checkNullToBlank(e2eAttrMap.get("AT00072"))+"</span>");
 	 		
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
 	 		builder.insertHtml(fontFamilyHtml+StringUtil.checkNullToBlank(e2eAttrMap.get("AT00018"))+"</span>");
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
 	 		builder.insertHtml(fontFamilyHtml+StringUtil.checkNullToBlank(e2eAttrMap.get("AT00006")).replace("upload/", logoPath)+"</span>");
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
		  	
		  	//==================================================================================================
			//==================================================================================================
		 	//프로세스 맵
		 	builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
	 	 	builder.startTable();
	 	    
	 	 	builder.insertCell();
	 	 	builder.getRowFormat().clearFormatting();
	 		builder.getCellFormat().clearFormatting();
	 		builder.getRowFormat().setHeight(10.0);
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
	
		
		//==================================================================================================		
		if (totalList.size() > 0) { 
	 	for (int index = 0; totalList.size() > index ; index++) {	 		
	 		//if (totalList.size() != 1) {
	 		//	
	 		//}	 		
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
	 		List attachFileList = (List)totalMap.get("attachFileList");
	 		Map attrMap = (Map)totalMap.get("attrMap");
	 		Map attrNameMap = (Map)totalMap.get("attrNameMap");
	 		Map attrHtmlMap = (Map)totalMap.get("attrHtmlMap");
	 		Map modelMap = (Map)totalMap.get("modelMap");
	 		Map attrRsNameMap = (Map)totalMap.get("attrRsNameMap");
	 		Map attrRsHtmlMap = (Map)totalMap.get("attrRsHtmlMap");
	 		
	 		List L3SubItemInfoList = (List)totalMap.get("L3SubItemInfoList");
	 		List L3KpiList = (List)totalMap.get("L3KpiList");
	 		List L3AttachFileList = (List)totalMap.get("L3AttachFileList");
	 		List cngtList = (List)totalMap.get("cngtList");  // L4 changeSetList
	 		
	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
 		//==================================================================================================
        // L3 정보 ======================================================================================================
	 	if(!selectedItemClass.equals("CL01005")){
	 		if(L3SubItemInfoList.size()>0){
	 			builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
	 			for(int h=0; L3SubItemInfoList.size() > h; h++ ){
		 			Map l3InfoMap = (Map)L3SubItemInfoList.get(h);
		 			if(h==0){	 			
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
				 		builder.getCellFormat().setWidth(mergeCellWidth);
				 		builder.getCellFormat().getBorders().setColor(Color.WHITE);
				 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 		builder.getFont().setName(defaultFont);
				 	    builder.getFont().setBold(true);
				 	    builder.getFont().setColor(Color.BLUE);
				 	    builder.getFont().setSize(11);
				 	    builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	   	name = StringUtil.checkNullToBlank(l3InfoMap.get("fromItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
				 	   	name = name.replace("&#10;", " ");
				 	   	name = name.replace("&#xa;", "");
				 	    name = name.replace("&nbsp;", " ");
				 	    builder.write(l3InfoMap.get("fromItemIdentifier") + name);  
				 	    
				 	    builder.getFont().setName(defaultFont);
				 	    builder.getFont().setColor(Color.LIGHT_GRAY);
				 	    builder.getFont().setSize(11);
				 	    
				 	    builder.insertCell();
				 	    builder.getCellFormat().setWidth(mergeCellWidth);
				 		builder.getCellFormat().getBorders().setColor(Color.WHITE);
				 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.RIGHT);
				 	    builder.write(String.valueOf(l3InfoMap.get("fromItemPath"))); 
				 	    builder.endRow();	
				 	    builder.endTable().setAllowAutoFit(false);	
				 	    
				 	    // 타이틀과 내용 사이 간격
				 	    builder.insertHtml("<hr size=4 color='silver'/>");
				 	 	// 머릿말 : END
				 	 	builder.moveToDocumentEnd();
			 	   
				 	  	//==================================================================================================
		 				builder.getFont().setColor(Color.DARK_GRAY);
					    builder.getFont().setSize(11);
					    builder.getFont().setBold(true);
					    builder.getFont().setName(defaultFont);
					    builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						builder.write("1."+String.valueOf(menu.get("LN00005"))); // L3 기본정보
				 		
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
				 		
				 		//1.Row : ID, 명칭
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
						builder.write(StringUtil.checkNullToBlank(l3InfoMap.get("fromItemIdentifier"))); // Identifier
				 		
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
						builder.write(StringUtil.checkNullToBlank(l3InfoMap.get("fromItemName"))); // 명칭
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
				 		String fromItemDescription = StringUtil.checkNullToBlank(l3InfoMap.get("fromItemDescription")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replaceAll("<ul>",ulStyle).replaceAll("<ol>",olStyle);
				 		builder.insertHtml(fontFamilyHtml+fromItemDescription.replace("upload/", logoPath)+"</span>");
				 						 		
				 		//==================================================================================================	
				 		builder.endRow();
				 		
				 		// 3.ROW : 클래스
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
				 		builder.write(StringUtil.checkNullToBlank(l3InfoMap.get("fromItemClassName"))); // 클래스명
				 		//==================================================================================================	
				 		builder.endRow();
				 		
				 		// 4.Row : 관리조직, 담당자
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
						builder.write(StringUtil.checkNullToBlank(l3InfoMap.get("fromItemTeamName"))); // 관리조직
				 		
				 		builder.insertCell();
				 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
				 		builder.getCellFormat().setWidth(titleCellWidth);
				 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
				 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 		builder.getFont().setBold (true);
				 		builder.write(String.valueOf(menu.get("LN00004")));  // 담당자
				 		
				 		builder.insertCell();
				 		builder.getCellFormat().setWidth(contentCellWidth);
				 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
				 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						builder.getFont().setBold(false);
						builder.write(StringUtil.checkNullToBlank(l3InfoMap.get("fromItemAuthorName"))); // 담당자
				 		//==================================================================================================	
				 		builder.endRow();
						
						// 5.Row : 생성일, 수정일
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
						builder.write(StringUtil.checkNullToBlank(l3InfoMap.get("fromItemCreateDT"))); // 생성일
				 		
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
						builder.write(StringUtil.checkNullToBlank(l3InfoMap.get("fromItemLastUpdated"))); // 수정일
				 		//==================================================================================================	
				 		builder.endRow();
				 		
				 		builder.endTable().setAllowAutoFit(false);
				 		
				 		builder.insertHtml("<br>");
				 		builder.getFont().setColor(Color.DARK_GRAY);
					    builder.getFont().setSize(11);
					    builder.getFont().setBold(true);
					    builder.getFont().setName(defaultFont);
					    builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						builder.writeln("2.하위 프로세스");
		 		
			 			builder.startTable();	
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
				 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.getFont().setBold(false);
						builder.write(String.valueOf(menu.get("LN00106")));  // ID
						
						builder.insertCell();
				 		builder.getCellFormat().setWidth(120);
				 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.getFont().setBold(false);
						builder.write(String.valueOf(menu.get("LN00028")));  // 명칭
						
						builder.insertCell();
				 		builder.getCellFormat().setWidth(340);
				 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.getFont().setBold(false);
						builder.write(String.valueOf(menu.get("LN00035")));  // 개요
						builder.endRow();
		 			}
		 			
		 			// 1.ROW : ID,명칭
		 			builder.getFont().setColor(Color.BLACK);
					builder.getFont().setSize(10);
					builder.getFont().setBold(true);
					builder.getFont().setName(defaultFont);
		 			
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
					builder.write(StringUtil.checkNullToBlank(l3InfoMap.get("toItemIdentifier"))); // Identifier
			 
			 		builder.insertCell();
			 		builder.getCellFormat().setWidth(120);
			 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
					builder.getFont().setBold(false);
					builder.write(StringUtil.checkNullToBlank(l3InfoMap.get("toItemName"))); // 명칭
					
					builder.insertCell();
			 		builder.getCellFormat().setWidth(340);
			 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
					builder.getFont().setBold(false); // L4 개요
					String toItemDescription = StringUtil.checkNullToBlank(l3InfoMap.get("toItemDescription")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replaceAll("<ul>",ulStyle).replaceAll("<ol>",olStyle);
					builder.insertHtml(fontFamilyHtml+toItemDescription.replace("upload/", logoPath)+"</span>");
			 		//==================================================================================================	
			 		builder.endRow();	
		 	 		builder.endTable().setAllowAutoFit(false);			 	 		
	 			}
				   
			} 	
	 		// END L3 SubProcess
	 	} // END if(!selectedItemClass.equals("CL01005")){
	 		// 아이템 속성 		
	 	if ("N".equals(onlyMap)) {
	 			builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
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
 			    // L4 정보  ======================================================================================================	
			  	builder.startTable();
	 			// 프로세스 기본 정보 Title
	 	 		builder.getFont().setColor(Color.DARK_GRAY);
			    builder.getFont().setSize(11);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
			    builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				builder.write("1." + String.valueOf(menu.get("LN00005"))); // L4 기본정보
	 	 		
	 	 	    builder.getFont().setName(defaultFont);
	 	 	    builder.getFont().setColor(Color.BLACK);
	 	 	    builder.getFont().setSize(10);
	 	 		
	 	 		// Make the header row.
	 	 		builder.getRowFormat().clearFormatting();
	 	 		builder.getCellFormat().clearFormatting();
	 	 		builder.getRowFormat().setHeight(150.0);
	 	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경	 	 			 		
	 	 		
	 	 	    // 0.ROW : ID,명칭
		 		builder.insertCell();
		 		//==================================================================================================	
		 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		 		builder.getCellFormat().setWidth(90);
		 		builder.getRowFormat().setHeight(30.0);
		 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		 		builder.getFont().setBold (true);
		 		builder.write("ID");  // ID
		 	
		 		builder.insertCell();
		 		builder.getCellFormat().setWidth(205);
		 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				builder.getFont().setBold(false);
				builder.write(StringUtil.checkNullToBlank(rowPrcData.get("Identifier")));// Identifie
				
		 		
		 		builder.insertCell();
		 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		 		builder.getCellFormat().setWidth(60);
		 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		 		builder.getFont().setBold (true);
		 		builder.write(String.valueOf(menu.get("LN00028")));  // 명칭
		 		
		 		builder.insertCell();
		 		builder.getCellFormat().setWidth(205);
		 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				builder.getFont().setBold(false);
				builder.write(StringUtil.checkNullToBlank(name));// 명칭
				//==================================================================================================	
		 		builder.endRow();
	 	 		
	 	 		
	 	 		
	 	 		
	 	 	 	// 1.ROW : 개요
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(90);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write("프로세스 설명");  // 개요
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(470);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		
	 	 		String AT00003 = StringUtil.checkNullToBlank(attrMap.get("AT00003")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replaceAll("<ul>",ulStyle).replaceAll("<ol>",olStyle);
	 	 		builder.insertHtml(fontFamilyHtml+AT00003.replace("upload/", logoPath)+"</span>");
	 	 		//==================================================================================================	
	 	 		builder.endRow();	 	 		
	 	 		
	 	 		// 2.ROW : 관련 규정 및 지침, 주기, 오너부서
	 	 		//==================================================================================================	
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(90);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(attrNameMap.get("AT00008")));  //관련 규정 및 지침
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(170);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
	 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00008"))); // 관련 규정 및 지침 내용		
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(60);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(attrNameMap.get("AT00009")));  // 주기
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(90);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
	 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00009"))); // 주기 내용
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	 	 		builder.getCellFormat().setWidth(60);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.write(String.valueOf(attrNameMap.get("AT00033")));  //오너부서
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(90);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
	 	 		builder.getFont().setBold(false);
	 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00033"))); // 오너부서 내용 	 	 
	 	 	
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		builder.endTable().setAllowAutoFit(false);	 	 		
	 	 		
	 	 		// 액티비티리스트
			 	// Build the other cells.
			 	// 액티비티리스트나 연관항목중 한건이라도 존재하면 새로운 페이지를 추가한다
			 	/* if (activityList.size() > 0 || cnitemList.size() > 0) {
			 		builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
			 	} */
				
			 	builder.insertHtml("<br>");

			    if (activityList.size() > 0) {
					Map rowActData = new HashMap();
					
					builder.startTable();	
					builder.insertCell();
					//==================================================================================================	
					builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
					builder.getCellFormat().setWidth(60);
					builder.getRowFormat().setHeight(30.0);
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					builder.getFont().setBold (true);
					builder.write(String.valueOf(menu.get("LN00106")));  // ID
					 	
					builder.insertCell();
					builder.getCellFormat().setWidth(100);
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.getFont().setBold(true);
					builder.write("업무활동");   // 명칭 (업무활동)
							
					builder.insertCell();
					builder.getCellFormat().setWidth(160);
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.getFont().setBold(true);
					builder.write("설명");  // 설명
							
					builder.insertCell();
					builder.getCellFormat().setWidth(60);
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.getFont().setBold(true);
					builder.write(String.valueOf(attrNameMap.get("AT00017")));  // 수행부서
					
					builder.insertCell();
					builder.getCellFormat().setWidth(60);
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.getFont().setBold(true);
					builder.write(String.valueOf(attrNameMap.get("AT00015")));  // 주요 투입물
					
					builder.insertCell();
					builder.getCellFormat().setWidth(60);
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.getFont().setBold(true);
					builder.write(String.valueOf(attrNameMap.get("AT00016")));  // 주요 산출물
					
					builder.insertCell();
					builder.getCellFormat().setWidth(60);
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.getFont().setBold(true);
					builder.write("시스템");  // 시스템
					
					builder.endRow();
					
					for(int j=0; j<activityList.size(); j++){
						rowActData = (HashMap) activityList.get(j);
						
					    //builder.insertHtml("<br>"); 
					    String identifier =  StringUtil.checkNullToBlank(rowActData.get("Identifier"));
					    String itemName = StringUtil.checkNullToBlank(rowActData.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
						itemName = itemName.replace("&#10;", " ");
						itemName = itemName.replace("&#xa;", "");
						itemName = itemName.replace("&nbsp;", " "); 
						itemName = itemName.replace("&amp;", "&"); 
					    
						// 1.Cell : ID
						builder.insertCell();
			 	 		builder.getCellFormat().setWidth(60);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getFont().setBold(false);
			 	 		builder.write(identifier); // ID
			 	 		
						// 2.Cell : 업무활동    
						builder.insertCell();
			 	 		builder.getCellFormat().setWidth(100);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getFont().setBold(false);
			 	 		builder.write(itemName); // 명칭
						    
			 	 	 	// 3.Cell : 개요
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(160);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		
			 	 		String Description = StringUtil.checkNullToBlank(rowActData.get("AT00003")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replaceAll("<ul>",ulStyle).replaceAll("<ol>",olStyle);
			 	 		builder.insertHtml(fontFamilyHtml+Description.replace("upload/", logoPath)+"</span>");
			 	 		//==================================================================================================	
			 	 		
			 	 		//builder.getRowFormat().clearFormatting();
						//builder.getCellFormat().clearFormatting();
						//builder.getRowFormat().setHeight(10.0);
			 	 		
			 	 		// 4.Cell : 수행부서
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(60);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getFont().setBold(false);
			 	 		builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00017"))); // 수행부서 
			 	 		
			 	 		// 5.Cell : 주요 투입물
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(60);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getFont().setBold (false);
			 	 		builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00015"))); // 투입물 : 
			 	 			 	 		
			 	 		// 6.Cell : 주요 산출물
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(60);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		 	 			builder.getFont().setBold(false);
		 	 			builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00016"))); //산출물
			 	 		
		 	 			// 7.Cell : 시스템
		 	 			
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(60);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		 	 			builder.getFont().setBold(false);
		 	 			builder.write(StringUtil.checkNullToBlank(rowActData.get("AT00013"))); // 시스템	 	 			
		 	 		
			 	 		//==================================================================================================	
			 	 		builder.endRow();	
			 	 	}	
			 	 	builder.endTable().setAllowAutoFit(false);
					
				}
				//==================================================================================================
				// END ActivityList
	 	 		
				builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);		 		
		 		
		 	// 6.업무처리 절차 Title
		 	//	if (null == modelMap) {
		 	//		builder.insertHtml("<br>");
		 	//	}
		 		builder.getFont().setColor(Color.DARK_GRAY);
			    builder.getFont().setSize(11);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
				builder.write("2. " + String.valueOf(menu.get("LN00197")));
				
	 	 		if (null != modelMap) {
	 	 		//==================================================================================================
	 		 		//프로세스 맵
	 		 	 	builder.startTable();
	 		 	 	builder.insertCell();
	 		 	 	builder.getRowFormat().clearFormatting();
	 		 		builder.getCellFormat().clearFormatting();
	 		 		builder.getRowFormat().setHeight(10.0);
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
				
	 	 		// 2. 선/후행 프로세스
	 	 		builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
	 	 		builder.getFont().setColor(Color.DARK_GRAY);
			    builder.getFont().setSize(11);
			    builder.getFont().setBold(true);
			    builder.getFont().setName(defaultFont);
				builder.write("3. " + String.valueOf(menu.get("LN00178"))+"Process");
				
		 		if (elementList.size() > 0) {
		 			Map cnProcessData = new HashMap();
			 		
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
					
					builder.getCellFormat().setWidth(30);
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
						String processInfo = StringUtil.checkNullToBlank(cnProcessData.get("Description")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
						processInfo = processInfo.replace("&#10;", " ");
						processInfo = processInfo.replace("&#xa;", "");
						processInfo = processInfo.replace("&nbsp;", " ");
						processInfo = processInfo.replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
						processInfo = processInfo.replaceAll("<ul>",ulStyle).replaceAll("<ol>",olStyle);
						
						builder.getCellFormat().setWidth(30);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					   	builder.write(StringUtil.checkNullToBlank(cnProcessData.get("RNUM")));	
						
					   	builder.insertCell();
					   	builder.getCellFormat().setWidth(50);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.write(StringUtil.checkNullToBlank(cnProcessData.get("LinkType")));				
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
						builder.insertHtml(fontFamilyHtml+processInfo.replace("upload/", logoPath)+"</span>");
						builder.endRow();
					}	
					
					builder.endTable().setAllowAutoFit(false);	
		 		}
				
		 	} else {
		 		if (null != modelMap) {
		 	 		//==================================================================================================
	 		 		//프로세스 맵
	 		 	 	builder.startTable();
	 		 	    
	 		 	 	builder.insertCell();
	 		 	 	builder.getRowFormat().clearFormatting();
	 		 		builder.getCellFormat().clearFormatting();
	 		 		builder.getRowFormat().setHeight(10.0);
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
	 		 		builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
	 		 		//==================================================================================================
	 	 		}
		 		
		 	}
 	 	
	 	} 
	}
	}
	
	//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	String selectedItemIdentifier = String.valueOf(request.getAttribute("selectedItemIdentifier"));
	SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
	long date = System.currentTimeMillis();
    String fileName = "HW-PD-" + selectedItemIdentifier +"-"+ itemNameOfFileNm + "_" + formatter.format(date) + ".docx";
    if(outputType.equals("pdf")){
    	fileName = "HW-PD-" + selectedItemIdentifier +"-"+ itemNameOfFileNm + "_" + formatter.format(date) + ".pdf";
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
	//2025-03-25 소스코드 취약점 수정
	log.error("Exception", e);
	//e.printStackTrace();
} finally{
	request.getSession(true).setAttribute("expFlag", "Y");
	
	response.getOutputStream().flush();
	response.getOutputStream().close();
}

%>

