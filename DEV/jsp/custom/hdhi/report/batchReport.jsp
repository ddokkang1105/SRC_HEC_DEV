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
 	
 	String selectedItemPath = String.valueOf(request.getAttribute("selectedItemPath"));
 	String reportCode = String.valueOf(request.getAttribute("reportCode"));
 	
 	Map selectedItemMap = (Map)request.getAttribute("selectedItemMap");
 	Map gItem = (Map)request.getAttribute("gItem");
 	List pItemList = (List)request.getAttribute("pItemList");
 	List mainItemList = (List)request.getAttribute("mainItemList");
 	
 	double titleCellWidth = 170.0;
 	double titleCellWidth2 = 400.0;
 	double contentCellWidth3 = 90.0;
	double contentCellWidth = 350.0;
	double contentCellWidth2 = 1020.0;
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
	builder.getPageSetup().setBottomMargin(10);
	builder.getPageSetup().setTopMargin(20);
	
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
    pageSetup.setFooterDistance(0);
    builder.moveToHeaderFooter(HeaderFooterType.FOOTER_PRIMARY);
    
    builder.startTable();
    builder.getCellFormat().getBorders().setLineWidth(0.0);
    builder.getFont().setName(defaultFont);
    builder.getFont().setColor(Color.BLACK);
    builder.getFont().setSize(8);
    
 	// 1.footer : Line
 	builder.getParagraphFormat().setSpaceBefore(7);
    builder.insertHtml("<hr size=5 color='silver'/>");
 	// 2.footer : logo
    builder.insertCell();
    builder.getCellFormat().setWidth(300.0);
    builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
    String imageFileName = logoPath + "logo.png";
    builder.write("HYUNDAI HEAVY INDUSTRY BPM");
 	// 3.footer : current page / total page 
    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
    builder.insertCell();
    builder.getCellFormat().setWidth(300.0);
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
    builder.getCellFormat().setWidth(300.0);
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
	 		Map attrNameMap = (Map)totalMap.get("attrNameMap");
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
	 	    builder.write("Batch Job 정의서"); 
			
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
			builder.write(rowPrcData.get("Identifier") + "\n"+ name);  
    		
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
				
	 			builder.startTable();
	 	 		
	 	 	    builder.getFont().setName(defaultFont);
	 	 	    builder.getFont().setColor(Color.BLACK);
	 	 	    builder.getFont().setSize(10);
	 	 	    
	 	 		builder.getRowFormat().clearFormatting();
				builder.getCellFormat().clearFormatting();
				builder.getRowFormat().setHeight(30.0);
	 	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경	 	
	 	 	    
	 	 	 	// ROW : 작업명/순서	 	 	 	
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(400);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.getFont().setSize(10);
	 	 		builder.write("작업명/순서");  // 개요
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getFont().setBold(false); 
	 	 		builder.getFont().setSize(12);
	 	 		builder.getCellFormat().setWidth(1500);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.write(StringUtil.checkNullToBlank(selectedItemMap.get("ItemName") + "/" + attrMap.get("ATPRD90")));

	 	 		builder.getRowFormat().setHeight(25.0);
	 	 		builder.getRowFormat().setHeightRule(HeightRule.EXACTLY);	 		 	 		
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 	    
	 	 	 	// ROW : 목적	 	 	 	
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(400);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.getFont().setSize(10);
	 	 		builder.write("목적");  // 개요
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getFont().setBold(false); 
	 	 		builder.getFont().setSize(10);
	 	 		builder.getCellFormat().setWidth(1500);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("ATPRD93")));

	 	 		builder.getRowFormat().setHeight(40.0);
	 	 		builder.getRowFormat().setHeightRule(HeightRule.EXACTLY);	 	 		
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 	 	// ROW : 모듈/프로그램명	 	 	 	
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(400);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.getFont().setSize(10);
	 	 		builder.write("모듈");
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getFont().setBold (false);
	 	 		builder.getFont().setSize(10);
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO);
	 	 		
	 	 		String module = StringUtil.checkNullToBlank(rowPrcData.get("Path"));
	 	        String lastTwoChars = module.substring(module.length() - 2);
	 	 		builder.write(StringUtil.checkNullToBlank(lastTwoChars));
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(400);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.getFont().setSize(10);
	 	 		builder.write("프로그램명");
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getFont().setBold(false);
	 	 		builder.getFont().setSize(10);
	 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("ATPRD91")));
	 	 		
	 	 		builder.getRowFormat().setHeight(20.0);
	 	 		builder.getRowFormat().setHeightRule(HeightRule.EXACTLY);
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 	 	// ROW : 담당자/호출일자	 	 	 	
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(400);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.getFont().setSize(10);
	 	 		builder.write("담당자");
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getFont().setBold (false);
	 	 		builder.getFont().setSize(10);
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO);
	 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("ATPRD09")));
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(400);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.getFont().setSize(10);
	 	 		builder.write("호출일자");
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getFont().setBold(false);
	 	 		builder.getFont().setSize(10);
	 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("ATPRD02")));
	 	 		
	 	 		builder.getRowFormat().setHeight(20.0);
	 	 		builder.getRowFormat().setHeightRule(HeightRule.EXACTLY);
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 	 	// ROW : 배치 주기_시간/작업시작일	 	 	 	
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(400);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.getFont().setSize(9);
	 	 		builder.write("배치 주기/시간");
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getFont().setBold (false);
	 	 		builder.getFont().setSize(10);
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO);
	 	 		if ((!attrMap.get("ATPRD04").equals("0") || !attrMap.get("ATPRD04").equals("00") || !attrMap.get("ATPRD04").equals(""))) {
	 	 			builder.write(StringUtil.checkNullToBlank(attrNameMap.get("ATPRD04")));
	 	 		} else if ((!attrMap.get("ATPRD05").equals("0") || !attrMap.get("ATPRD05").equals("00") || !attrMap.get("ATPRD05").equals(""))) {
	 	 			builder.write(StringUtil.checkNullToBlank(attrNameMap.get("ATPRD05")));
	 	 		} else if ((!attrMap.get("ATPRD06").equals("0") || !attrMap.get("ATPRD06").equals("00") || !attrMap.get("ATPRD06").equals(""))) {
	 	 			builder.write(StringUtil.checkNullToBlank(attrNameMap.get("ATPRD06")));
	 	 		} else if ((!attrMap.get("ATPRD07").equals("0") || !attrMap.get("ATPRD07").equals("00") || !attrMap.get("ATPRD07").equals(""))) {
	 	 			builder.write(StringUtil.checkNullToBlank(attrNameMap.get("ATPRD07")));
	 	 		} else if ((!attrMap.get("ATPRD08").equals("0") || !attrMap.get("ATPRD08").equals("00") || !attrMap.get("ATPRD08").equals(""))) {
	 	 			builder.write(StringUtil.checkNullToBlank(attrNameMap.get("ATPRD08")));
	 	 		}
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(400);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.getFont().setSize(10);
	 	 		builder.write("작업시작일");
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getFont().setBold(false);
	 	 		builder.getFont().setSize(10);
	 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("ATPRD12")));
	 	 		
	 	 		builder.getRowFormat().setHeight(20.0);
	 	 		builder.getRowFormat().setHeightRule(HeightRule.EXACTLY);
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 		
	 	 	 	// ROW : 변형이름/변형값	 	 	 	
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(400);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.getFont().setSize(10);
	 	 		builder.write("변형이름");
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getFont().setBold (false);
	 	 		builder.getFont().setSize(10);
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO);
	 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("ATPRD01")));
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(400);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.getFont().setSize(10);
	 	 		builder.write("변형 값");
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getCellFormat().setWidth(contentCellWidth2);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getFont().setBold(false);
	 	 		builder.getFont().setSize(8);
	 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("ATPRD97")));
	 	 		
	 	 		builder.getRowFormat().setHeight(50.0);
	 	 		builder.getRowFormat().setHeightRule(HeightRule.EXACTLY);
	 	 		//==================================================================================================	
	 	 		builder.endRow();
	 	 	    
	 	 	 	// ROW : 배치 유형	 	 	 	
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(400);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.getFont().setSize(10);
	 	 		builder.write("배치 유형");  // 개요
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getFont().setBold(false); 
	 	 		builder.getFont().setSize(10);
	 	 		builder.getCellFormat().setWidth(1500);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("ATPRD98")));

	 	 		builder.getRowFormat().setHeight(20.0);
	 	 		builder.getRowFormat().setHeightRule(HeightRule.EXACTLY);	 		 	 		
	 	 		//==================================================================================================	
	 	 		builder.endRow();	 	 		
	 	 	    
	 	 	 	// ROW : 비고(특이사항)	 	 	 	
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(242, 242, 242));
	 	 		builder.getCellFormat().setWidth(400);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	 	 		builder.getFont().setBold (true);
	 	 		builder.getFont().setSize(9);
	 	 		builder.write("비고(특이사항)");  // 개요
	 	 		
	 	 		builder.insertCell();
	 	 		builder.getFont().setBold(false);
	 	 		builder.getFont().setSize(10);
	 	 		builder.getCellFormat().setWidth(1500);
	 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	 	 		builder.write(StringUtil.checkNullToBlank(attrMap.get("ATPRD99")));

	 	 		builder.getRowFormat().setHeight(50.0);
	 	 		builder.getRowFormat().setHeightRule(HeightRule.EXACTLY);	 		 	 		
	 	 		//==================================================================================================	
	 	 		builder.endRow();	 	 		
	 	 		
	 	 		//
	 	 		builder.insertCell();
	 	 		//==================================================================================================	
	 	 		builder.getRowFormat().setHeight(380.0);
	 	 		builder.getRowFormat().setHeightRule(HeightRule.EXACTLY);
 		 	 	builder.getCellFormat().setWidth(totalCellWidth);
 		 	 	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
 		 	 	
 		 	 	if (0 != modelMap.size()) {
	 		 		String imgLang = "_"+StringUtil.checkNull(setMap.get("langCode"));
	 		 		String imgPath = modelImgPath+modelMap.get("ModelID")+imgLang+"."+GlobalVal.MODELING_DIGM_IMG_TYPE;
	 		 		double width = Integer.parseInt(String.valueOf(modelMap.get("Width")));
	 		 		double height = Integer.parseInt(String.valueOf(modelMap.get("Height")));
	 		 		try{
	 		 			builder.insertImage(imgPath, RelativeHorizontalPosition.PAGE, 20, RelativeVerticalPosition.PAGE,20,width,height,WrapType.INLINE);
	 		 		} catch(Exception ex){}
 		 	 	}
	 	 		//==================================================================================================	
	 	 		builder.endRow();	 	 		
	 	 		
	 	 		builder.endTable().setAllowAutoFit(false);
	 	 		builder.getFont().setSize(1);
	 	 		//builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
				
	 	 		
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
