<%@page import="java.util.ArrayList"%>
<%@page contentType="application/msword; charset=utf-8"%>
<%@page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:url value="/" var="root" />

<%@page import="java.io.*"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="xbolt.cmm.framework.util.StringUtil"%>
<%@page import="xbolt.cmm.framework.val.GlobalVal"%>

<%@page import="com.aspose.words.*"%>
<%@page import="java.awt.Color"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.apache.commons.text.StringEscapeUtils"%>

<%@page import="org.apache.commons.logging.Log"%>
<%@page import="org.apache.commons.logging.LogFactory"%>

<%
final Log log = LogFactory.getLog(this.getClass());

try {
	String LogoImgUrl = "";
	String modelImgPath = GlobalVal.MODELING_DIGM_DIR;
	String logoPath = GlobalVal.FILE_UPLOAD_TINY_DIR;
	String defaultFont = String.valueOf(request.getAttribute("defaultFont"));

	License license = new License();
	license.setLicense(logoPath + "Aspose.Words.lic");

	Document doc = new Document();
	DocumentBuilder builder = new DocumentBuilder(doc);

	Map menu = (Map) request.getAttribute("menu");
	Map setMap = (HashMap) request.getAttribute("setMap");
	List allTotalList = (List) request.getAttribute("allTotalList");

	//  	String onlyMap = String.valueOf(request.getAttribute("onlyMap"));
	String paperSize = String.valueOf(request.getAttribute("paperSize"));
	String itemNameOfFileNm = String.valueOf(request.getAttribute("ItemNameOfFileNm"));
	String outputType = String.valueOf(request.getAttribute("outputType"));

	Map e2eModelMap = (Map) request.getAttribute("e2eModelMap");
	Map e2eItemInfo = (Map) request.getAttribute("e2eItemInfo");
	Map e2eAttrMap = (Map) request.getAttribute("e2eAttrMap");
	Map e2eAttrNameMap = (Map) request.getAttribute("e2eAttrNameMap");
	Map e2eAttrHtmlMap = (Map) request.getAttribute("e2eAttrHtmlMap");
	List e2eDimResultList = (List) request.getAttribute("e2eDimResultList");

	String selectedItemPath = String.valueOf(request.getAttribute("selectedItemPath"));
	String reportCode = String.valueOf(request.getAttribute("reportCode"));

	List subTreeItemIDList = (List) request.getAttribute("subTreeItemIDList");
	Map selectedItemMap = (Map) request.getAttribute("selectedItemMap");

	double titleCellWidth = 170.0;
	double titleCellWidth2 = 90.0;
	double contentCellWidth3 = 90.0;
	double contentCellWidth = 350.0;
	double contentCellWidth2 = 220.0;
	double mergeCellWidth = 500.0;
	double totalCellWidth = 560.0;
	String value = "";
	String name = "";
	String fontFamilyHtml = "<span style=\"font-family:" + defaultFont + "; font-size: 10pt;\">";
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
	builder.write("Global Consolidation PI TFT");

	builder.endTable().setAllowAutoFit(false);

	builder.moveToDocumentEnd();
	//=========================================================================

	builder = new DocumentBuilder(doc);

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
	} else if (reportCode.equals("RP00031")) {
		builder.writeln("PI 과제 정의서");
	} else {
		builder.writeln("Process Definition Report");
	}
	builder.endRow();

	// 3.선택한 프로세스 정보
	builder.insertCell();
	builder.getFont().setColor(Color.BLACK);
	builder.getFont().setBold(true);
	builder.getFont().setName(defaultFont);
	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	builder.getFont().setSize(26);
	builder.getFont().setUnderline(0);
	builder.writeln("[" + selectedItemPath + "]");
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
	builder.write(StringUtil.checkNullToBlank(e2eItemInfo.get("AuthorName")));

	builder.insertCell();
	builder.getCellFormat().setWidth(200);
	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	builder.write("Global Process management");
	builder.insertCell();
	builder.getCellFormat().setWidth(100);
	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	builder.write(StringUtil.checkNullToBlank(e2eItemInfo.get("CreateDT")));
	builder.endRow();
	builder.endTable().setAlignment(TabAlignment.CENTER);
	builder.endRow();

	builder.endTable().setAllowAutoFit(false);
	///////////////////////////////////////////////////////////////////////////////////////
	// 표지 END
	builder.insertBreak(BreakType.PAGE_BREAK);
	if (subTreeItemIDList.size() > 0) {
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

		for (int lowlankCnt = 0; subTreeItemIDList.size() > lowlankCnt; lowlankCnt++) {
	Map lowLankItemIdMap = (Map) subTreeItemIDList.get(lowlankCnt);

	String l2Item = StringUtil.checkNull(lowLankItemIdMap.get("l2Item"));
	List l3l4ItemIdList = (List) lowLankItemIdMap.get("l3l4ItemIdList");

	if (!l2Item.isEmpty()) {
		builder.writeln("\t" + l2Item);
	}

	for (int l3l4Cnt = 0; l3l4ItemIdList.size() > l3l4Cnt; l3l4Cnt++) {
		Map l3l4ItemIdMap = (Map) l3l4ItemIdList.get(l3l4Cnt);
		String l3Item = StringUtil.checkNull(l3l4ItemIdMap.get("l3Item"));
		List l4ItemList = (List) l3l4ItemIdMap.get("l4ItemList");

		if (!l3Item.isEmpty()) {
			builder.writeln("\t\t" + l3Item);
		}
		for (int l4Cnt = 0; l4ItemList.size() > l4Cnt; l4Cnt++) {
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
		builder.getCellFormat().setWidth(contentCellWidth);
		builder.getCellFormat().getBorders().setColor(Color.WHITE);
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getFont().setName(defaultFont);
		builder.getFont().setBold(true);
		builder.getFont().setColor(Color.BLUE);
		builder.getFont().setSize(14);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		name = StringUtil.checkNullToBlank(e2eItemInfo.get("ItemName"))
		.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
		name = name.replace("&#10;", " ");
		name = name.replace("&#xa;", "");
		name = name.replace("&nbsp;", " ");
		builder.write("E2E Scenario : " + StringUtil.checkNullToBlank(e2eItemInfo.get("Identifier")) + " " + name);

		builder.getFont().setName(defaultFont);
		builder.getFont().setColor(Color.LIGHT_GRAY);
		builder.getFont().setSize(12);

		builder.insertCell();
		builder.getCellFormat().setWidth(titleCellWidth2);
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
		builder.getFont().setBold(true);
		builder.write(String.valueOf(e2eAttrNameMap.get("AT00003"))); // 개요

		builder.insertCell();
		builder.getCellFormat().setWidth(mergeCellWidth);
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		String E2EAT00003 = StringUtil.checkNullToBlank(e2eAttrMap.get("AT00003")).replaceAll("&lt;", "<")
		.replaceAll("&gt;", ">").replaceAll("&quot;", "\"").replace("upload/", logoPath);
		if ("1".equals(StringUtil.checkNullToBlank(e2eAttrHtmlMap.get("AT00003")))) { // type이 HTML인 경우
	if (StringUtil.checkNullToBlank(e2eAttrMap.get("AT00003")).contains("font-family")) {
		builder.insertHtml(E2EAT00003);
	} else {
		builder.insertHtml(fontFamilyHtml + E2EAT00003 + "</span>");
	}
		} else {
	builder.getFont().setBold(false);
	builder.write(E2EAT00003); // 개요 : 내용
		}
		//==================================================================================================	
		builder.endRow();

		// 6.ROW (Dimension 정보 만큼 행 표시)
		for (int j = 0; j < e2eDimResultList.size(); j++) {
	Map dimResultMap = (Map) e2eDimResultList.get(j);

	builder.insertCell();
	//==================================================================================================	
	builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	builder.getCellFormat().setWidth(titleCellWidth);
	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	builder.getFont().setBold(true);
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
		builder.startTable();

		builder.insertCell();
		builder.getRowFormat().clearFormatting();
		builder.getCellFormat().clearFormatting();
		builder.getRowFormat().setHeight(20.0);
		builder.getRowFormat().setHeightRule(HeightRule.AUTO);
		builder.getCellFormat().setWidth(totalCellWidth);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);

		String imgLang = "_" + StringUtil.checkNull(setMap.get("langCode"));
		String imgPath = modelImgPath + e2eModelMap.get("ModelID") + imgLang + "." + GlobalVal.MODELING_DIGM_IMG_TYPE;
		int width = Integer.parseInt(String.valueOf(e2eModelMap.get("Width")));
		int height = Integer.parseInt(String.valueOf(e2eModelMap.get("Height")));
		System.out.println("프로세스맵 imgPath=" + imgPath);
		try {
	builder.insertHtml("<br>");
	builder.insertImage(imgPath, RelativeHorizontalPosition.PAGE, 30, RelativeVerticalPosition.PAGE, 20, width,
			height, WrapType.INLINE);
	builder.insertHtml("<br>");
		} catch (Exception ex) {
		}

		builder.endTable().setAllowAutoFit(false);
	}
	//==================================================================================================
	// E2E 기본정보 END

	//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	for (int totalCnt = 0; allTotalList.size() > totalCnt; totalCnt++) {
		Map allTotalMap = (Map) allTotalList.get(totalCnt);
		Map titleItemMap = new HashMap();
		List totalList = (List) allTotalMap.get("totalList");
		if (!e2eModelMap.isEmpty()) {
	titleItemMap = e2eItemInfo;
		} else {
	titleItemMap = (Map) allTotalMap.get("titleItemMap");
		}

		//==================================================================================================

		//==================================================================================================

		if (totalList.size() > 0) {
	for (int index = 0; totalList.size() > index; index++) {
		if (totalList.size() != 1) {
			builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
		}

		Map totalMap = (Map) totalList.get(index);

		List prcList = (List) totalMap.get("prcList");
		Map rowPrcData = (HashMap) prcList.get(0);
		List dimResultList = (List) totalMap.get("dimResultList");
		Map attrMap = (Map) totalMap.get("attrMap");
		Map attrNameMap = (Map) totalMap.get("attrNameMap");
		Map attrHtmlMap = (Map) totalMap.get("attrHtmlMap");
		Map modelMap = (Map) totalMap.get("modelMap");
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
		name = StringUtil.checkNullToBlank(rowPrcData.get("ItemName"))
				.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
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
		builder.getCellFormat().setWidth(180);
		builder.getCellFormat().setVerticalMerge(CellMerge.NONE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		builder.write(rowPrcData.get("Identifier") + " " + name);

		builder.insertCell();
		builder.getCellFormat().setWidth(240);
		builder.getCellFormat().setVerticalMerge(CellMerge.NONE);
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
		// 	 		if ("N".equals(onlyMap)) {
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
		builder.getCellFormat().setWidth(titleCellWidth2);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setBold(true);
		builder.write(String.valueOf(attrNameMap.get("AT00003"))); // 개요

		builder.insertCell();
		builder.getCellFormat().setWidth(totalCellWidth);
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);

		String AT00003 = StringUtil.checkNullToBlank(attrMap.get("AT00003")).replaceAll("&lt;", "<")
				.replaceAll("&gt;", ">").replaceAll("&quot;", "\"").replace("upload/", logoPath);
		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00003")))) { // type이 HTML인 경우
			if (StringUtil.checkNullToBlank(attrMap.get("AT00003")).contains("font-family")) {
				builder.insertHtml(AT00003);
			} else {
				builder.insertHtml(fontFamilyHtml + AT00003 + "</span>");
			}
		} else {
			builder.getFont().setBold(false);
			builder.write(AT00003); // 개요 : 내용
		}
		//==================================================================================================	
		builder.endRow();

		//프로세스목적
		builder.insertCell();
		//==================================================================================================	
		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		builder.getCellFormat().setWidth(titleCellWidth2);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setBold(true);
		builder.write(String.valueOf(attrNameMap.get("AT09963")));

		builder.insertCell();
		builder.getCellFormat().setWidth(totalCellWidth);
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.getFont().setBold(false);
		String AT09963 = StringUtil.checkNullToBlank(attrMap.get("AT09963")).replaceAll("&lt;", "<")
				.replaceAll("&gt;", ">").replaceAll("&quot;", "\"").replace("upload/", logoPath);
		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT09963")))) { // type이 HTML인 경우
			if (StringUtil.checkNullToBlank(attrMap.get("AT09963")).contains("font-family")) {
				builder.insertHtml(AT09963);
			} else {
				builder.insertHtml(fontFamilyHtml + AT09963 + "</span>");
			}
		} else {
			builder.getFont().setBold(false);
			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT09963"))); // 주기 : 내용
		}
		//==================================================================================================	
		builder.endRow();

		//주요기준정보	
		builder.insertCell();
		//==================================================================================================	
		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		builder.getCellFormat().setWidth(titleCellWidth2);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setBold(true);
		builder.write(String.valueOf(attrNameMap.get("ZAT0012")));

		builder.insertCell();
		builder.getCellFormat().setWidth(totalCellWidth);
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.getFont().setBold(false);
		String ZAT0012 = StringUtil.checkNullToBlank(attrMap.get("ZAT0012")).replaceAll("&lt;", "<")
				.replaceAll("&gt;", ">").replaceAll("&quot;", "\"").replace("upload/", logoPath);
		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("ZAT0012")))) { // type이 HTML인 경우
			if (StringUtil.checkNullToBlank(attrMap.get("ZAT0012")).contains("font-family")) {
				builder.insertHtml(ZAT0012);
			} else {
				builder.insertHtml(fontFamilyHtml + ZAT0012 + "</span>");
			}
		} else {
			builder.getFont().setBold(false);
			builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0012"))); // 주기 : 내용
		}
		//==================================================================================================	
		builder.endRow();

		//ROW : AT00005	Variant, AT00009	주기
		builder.insertCell();
		//==================================================================================================	
		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		builder.getCellFormat().setWidth(titleCellWidth2);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setBold(true);
		builder.write(String.valueOf(attrNameMap.get("AT00005"))); // variant

		builder.insertCell();
		builder.getCellFormat().setWidth(contentCellWidth2);
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);

		String AT00005 = StringUtil.checkNullToBlank(attrMap.get("AT00005")).replaceAll("&lt;", "<")
				.replaceAll("&gt;", ">").replaceAll("&quot;", "\"").replace("upload/", logoPath);
		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00005")))) { // type이 HTML인 경우
			if (StringUtil.checkNullToBlank(attrMap.get("AT00005")).contains("font-family")) {
				builder.insertHtml(AT00005);
			} else {
				builder.insertHtml(fontFamilyHtml + AT00005 + "</span>");
			}
		} else {
			builder.getFont().setBold(false);
			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00005"))); // variant
		}

		builder.insertCell();
		//==================================================================================================	
		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		builder.getCellFormat().setWidth(titleCellWidth2);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setBold(true);
		builder.write(String.valueOf(attrNameMap.get("AT00009"))); // 주기

		builder.insertCell();
		builder.getCellFormat().setWidth(contentCellWidth2);
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);

		String AT00009 = StringUtil.checkNullToBlank(attrMap.get("AT00009")).replaceAll("&lt;", "<")
				.replaceAll("&gt;", ">").replaceAll("&quot;", "\"").replace("upload/", logoPath);
		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00009")))) { // type이 HTML인 경우
			if (StringUtil.checkNullToBlank(attrMap.get("AT00009")).contains("font-family")) {
				builder.insertHtml(AT00009);
			} else {
				builder.insertHtml(fontFamilyHtml + AT00009 + "</span>");
			}
		} else {
			builder.getFont().setBold(false);
			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00009"))); // 주기 : 내용
		}
		builder.endRow();

		//row : AT00022	담당 PI, AT00025	담당 컨설턴트
		builder.insertCell();
		//==================================================================================================	
		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		builder.getCellFormat().setWidth(titleCellWidth2);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setBold(true);
		builder.write(String.valueOf(attrNameMap.get("AT00022")));

		builder.insertCell();
		builder.getCellFormat().setWidth(contentCellWidth2);
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);

		String AT00022 = StringUtil.checkNullToBlank(attrMap.get("AT00022")).replaceAll("&lt;", "<")
				.replaceAll("&gt;", ">").replaceAll("&quot;", "\"").replace("upload/", logoPath);
		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00022")))) { // type이 HTML인 경우
			if (StringUtil.checkNullToBlank(attrMap.get("AT00022")).contains("font-family")) {
				builder.insertHtml(AT00022);
			} else {
				builder.insertHtml(fontFamilyHtml + AT00022 + "</span>");
			}
		} else {
			builder.getFont().setBold(false);
			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00022")));
		}

		builder.insertCell();
		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		builder.getCellFormat().setWidth(titleCellWidth2);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setBold(true);
		builder.write(String.valueOf(attrNameMap.get("AT00025")));

		builder.insertCell();
		builder.getCellFormat().setWidth(contentCellWidth2);
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);

		String AT00025 = StringUtil.checkNullToBlank(attrMap.get("AT00025")).replaceAll("&lt;", "<")
				.replaceAll("&gt;", ">").replaceAll("&quot;", "\"").replace("upload/", logoPath);
		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00025")))) { // type이 HTML인 경우
			if (StringUtil.checkNullToBlank(attrMap.get("AT00025")).contains("font-family")) {
				builder.insertHtml(AT00025);
			} else {
				builder.insertHtml(fontFamilyHtml + AT00025 + "</span>");
			}
		} else {
			builder.getFont().setBold(false);
			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00025")));
		}
		//==================================================================================================	
		builder.endRow();

		//row : AT00055	작성 예정일, AT00090	리뷰완료일
		builder.insertCell();
		//==================================================================================================	
		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		builder.getCellFormat().setWidth(titleCellWidth2);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setBold(true);
		builder.write(String.valueOf(attrNameMap.get("AT00055")));

		builder.insertCell();
		builder.getCellFormat().setWidth(contentCellWidth2);
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);

		String AT00055 = StringUtil.checkNullToBlank(attrMap.get("AT00055")).replaceAll("&lt;", "<")
				.replaceAll("&gt;", ">").replaceAll("&quot;", "\"").replace("upload/", logoPath);
		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00055")))) { // type이 HTML인 경우
			if (StringUtil.checkNullToBlank(attrMap.get("AT00055")).contains("font-family")) {
				builder.insertHtml(AT00055);
			} else {
				builder.insertHtml(fontFamilyHtml + AT00055 + "</span>");
			}
		} else {
			builder.getFont().setBold(false);
			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00055")));
		}

		builder.insertCell();
		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		builder.getCellFormat().setWidth(titleCellWidth2);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setBold(true);
		builder.write(String.valueOf(attrNameMap.get("AT00090")));

		builder.insertCell();
		builder.getCellFormat().setWidth(contentCellWidth2);
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);

		String AT00090 = StringUtil.checkNullToBlank(attrMap.get("AT00090")).replaceAll("&lt;", "<")
				.replaceAll("&gt;", ">").replaceAll("&quot;", "\"").replace("upload/", logoPath);
		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00090")))) { // type이 HTML인 경우
			if (StringUtil.checkNullToBlank(attrMap.get("AT00090")).contains("font-family")) {
				builder.insertHtml(AT00090);
			} else {
				builder.insertHtml(fontFamilyHtml + AT00090 + "</span>");
			}
		} else {
			builder.getFont().setBold(false);
			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00090")));
		}
		//==================================================================================================	
		builder.endRow();

		//row : AT00091	Prototype 일정, AT00026	Progress
		builder.insertCell();
		//==================================================================================================	
		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		builder.getCellFormat().setWidth(titleCellWidth2);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setBold(true);
		builder.write(String.valueOf(attrNameMap.get("AT00091")));

		builder.insertCell();
		builder.getCellFormat().setWidth(contentCellWidth2);
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);

		String AT00091 = StringUtil.checkNullToBlank(attrMap.get("AT00091")).replaceAll("&lt;", "<")
				.replaceAll("&gt;", ">").replaceAll("&quot;", "\"").replace("upload/", logoPath);
		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00091")))) { // type이 HTML인 경우
			if (StringUtil.checkNullToBlank(attrMap.get("AT00091")).contains("font-family")) {
				builder.insertHtml(AT00091);
			} else {
				builder.insertHtml(fontFamilyHtml + AT00091 + "</span>");
			}
		} else {
			builder.getFont().setBold(false);
			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00091")));
		}

		builder.insertCell();
		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		builder.getCellFormat().setWidth(titleCellWidth2);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setBold(true);
		builder.write(String.valueOf(attrNameMap.get("AT00026")));

		builder.insertCell();
		builder.getCellFormat().setWidth(contentCellWidth2);
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);

		String AT00026 = StringUtil.checkNullToBlank(attrMap.get("AT00026")).replaceAll("&lt;", "<")
				.replaceAll("&gt;", ">").replaceAll("&quot;", "\"").replace("upload/", logoPath);
		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00026")))) { // type이 HTML인 경우
			if (StringUtil.checkNullToBlank(attrMap.get("AT00026")).contains("font-family")) {
				builder.insertHtml(AT00026);
			} else {
				builder.insertHtml(fontFamilyHtml + AT00026 + "</span>");
			}
		} else {
			builder.getFont().setBold(false);
			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00026")));
		}
		//==================================================================================================	
		builder.endRow();

		//row : AT00008	운영원칙 및 전제조건, AT00092	기대효과
		builder.insertCell();
		//==================================================================================================	
		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		builder.getCellFormat().setWidth(titleCellWidth2);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setBold(true);
		builder.write(String.valueOf(attrNameMap.get("AT00008")));

		builder.insertCell();
		builder.getCellFormat().setWidth(contentCellWidth2);
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);

		String AT00008 = StringUtil.checkNullToBlank(attrMap.get("AT00008")).replaceAll("&lt;", "<")
				.replaceAll("&gt;", ">").replaceAll("&quot;", "\"").replace("upload/", logoPath);
		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00008")))) { // type이 HTML인 경우
			if (StringUtil.checkNullToBlank(attrMap.get("AT00008")).contains("font-family")) {
				builder.insertHtml(AT00008);
			} else {
				builder.insertHtml(fontFamilyHtml + AT00008 + "</span>");
			}
		} else {
			builder.getFont().setBold(false);
			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00008")));
		}

		builder.insertCell();
		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		builder.getCellFormat().setWidth(titleCellWidth2);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setBold(true);
		builder.write(String.valueOf(attrNameMap.get("AT00092")));

		builder.insertCell();
		builder.getCellFormat().setWidth(contentCellWidth2);
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);

		String AT00092 = StringUtil.checkNullToBlank(attrMap.get("AT00092")).replaceAll("&lt;", "<")
				.replaceAll("&gt;", ">").replaceAll("&quot;", "\"").replace("upload/", logoPath);
		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00092")))) { // type이 HTML인 경우
			if (StringUtil.checkNullToBlank(attrMap.get("AT00092")).contains("font-family")) {
				builder.insertHtml(AT00092);
			} else {
				builder.insertHtml(fontFamilyHtml + AT00092 + "</span>");
			}
		} else {
			builder.getFont().setBold(false);
			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00092")));
		}
		//==================================================================================================	
		builder.endRow();

		//row : AT00023	TOBE 변화사항, AT00030	AS IS 현황
		builder.insertCell();
		//==================================================================================================	
		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		builder.getCellFormat().setWidth(titleCellWidth2);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setBold(true);
		builder.write(String.valueOf(attrNameMap.get("AT00023")));

		builder.insertCell();
		builder.getCellFormat().setWidth(contentCellWidth2);
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);

		String AT00023 = StringUtil.checkNullToBlank(attrMap.get("AT00023")).replaceAll("&lt;", "<")
				.replaceAll("&gt;", ">").replaceAll("&quot;", "\"").replace("upload/", logoPath);
		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00023")))) { // type이 HTML인 경우
			if (StringUtil.checkNullToBlank(attrMap.get("AT00023")).contains("font-family")) {
				builder.insertHtml(AT00023);
			} else {
				builder.insertHtml(fontFamilyHtml + AT00023 + "</span>");
			}
		} else {
			builder.getFont().setBold(false);
			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00023")));
		}

		builder.insertCell();
		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		builder.getCellFormat().setWidth(titleCellWidth2);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setBold(true);
		builder.write(String.valueOf(attrNameMap.get("AT00030")));

		builder.insertCell();
		builder.getCellFormat().setWidth(contentCellWidth2);
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);

		String AT00030 = StringUtil.checkNullToBlank(attrMap.get("AT00030")).replaceAll("&lt;", "<")
				.replaceAll("&gt;", ">").replaceAll("&quot;", "\"").replace("upload/", logoPath);
		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00030")))) { // type이 HTML인 경우
			if (StringUtil.checkNullToBlank(attrMap.get("AT00030")).contains("font-family")) {
				builder.insertHtml(AT00030);
			} else {
				builder.insertHtml(fontFamilyHtml + AT00030 + "</span>");
			}
		} else {
			builder.getFont().setBold(false);
			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00030")));
		}
		//==================================================================================================	
		builder.endRow();

		//row : AT00006	비고/이슈, ZAT0001	ASIS ID
		builder.insertCell();
		//==================================================================================================	
		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		builder.getCellFormat().setWidth(titleCellWidth2);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setBold(true);
		builder.write(String.valueOf(attrNameMap.get("AT00006")));

		builder.insertCell();
		builder.getCellFormat().setWidth(contentCellWidth2);
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);

		String AT00006 = StringUtil.checkNullToBlank(attrMap.get("AT00006")).replaceAll("&lt;", "<")
				.replaceAll("&gt;", ">").replaceAll("&quot;", "\"").replace("upload/", logoPath);
		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00006")))) { // type이 HTML인 경우
			if (StringUtil.checkNullToBlank(attrMap.get("AT00006")).contains("font-family")) {
				builder.insertHtml(AT00006);
			} else {
				builder.insertHtml(fontFamilyHtml + AT00006 + "</span>");
			}
		} else {
			builder.getFont().setBold(false);
			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00006")));
		}

		builder.insertCell();
		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		builder.getCellFormat().setWidth(titleCellWidth2);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setBold(true);
		builder.write(String.valueOf(attrNameMap.get("ZAT0001")));

		builder.insertCell();
		builder.getCellFormat().setWidth(contentCellWidth2);
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);

		String ZAT0001 = StringUtil.checkNullToBlank(attrMap.get("ZAT0001")).replaceAll("&lt;", "<")
				.replaceAll("&gt;", ">").replaceAll("&quot;", "\"").replace("upload/", logoPath);
		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("ZAT0001")))) { // type이 HTML인 경우
			if (StringUtil.checkNullToBlank(attrMap.get("ZAT0001")).contains("font-family")) {
				builder.insertHtml(ZAT0001);
			} else {
				builder.insertHtml(fontFamilyHtml + ZAT0001 + "</span>");
			}
		} else {
			builder.getFont().setBold(false);
			builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0001")));
		}
		//==================================================================================================	
		builder.endRow();

		//row : ZAT0002	As-Is 수작업(시간/월) - PC, ZAT0003	To-Be 수작업(시간/월) - PC
		builder.insertCell();
		//==================================================================================================	
		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		builder.getCellFormat().setWidth(titleCellWidth2);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setBold(true);
		builder.write(String.valueOf(attrNameMap.get("ZAT0002")));

		builder.insertCell();
		builder.getCellFormat().setWidth(contentCellWidth2);
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);

		String ZAT0002 = StringUtil.checkNullToBlank(attrMap.get("ZAT0002")).replaceAll("&lt;", "<")
				.replaceAll("&gt;", ">").replaceAll("&quot;", "\"").replace("upload/", logoPath);
		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("ZAT0002")))) { // type이 HTML인 경우
			if (StringUtil.checkNullToBlank(attrMap.get("ZAT0002")).contains("font-family")) {
				builder.insertHtml(ZAT0002);
			} else {
				builder.insertHtml(fontFamilyHtml + ZAT0002 + "</span>");
			}
		} else {
			builder.getFont().setBold(false);
			builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0002")));
		}

		builder.insertCell();
		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		builder.getCellFormat().setWidth(titleCellWidth2);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setBold(true);
		builder.write(String.valueOf(attrNameMap.get("ZAT0003")));

		builder.insertCell();
		builder.getCellFormat().setWidth(contentCellWidth2);
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);

		String ZAT0003 = StringUtil.checkNullToBlank(attrMap.get("ZAT0003")).replaceAll("&lt;", "<")
				.replaceAll("&gt;", ">").replaceAll("&quot;", "\"").replace("upload/", logoPath);
		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("ZAT0003")))) { // type이 HTML인 경우
			if (StringUtil.checkNullToBlank(attrMap.get("ZAT0003")).contains("font-family")) {
				builder.insertHtml(ZAT0003);
			} else {
				builder.insertHtml(fontFamilyHtml + ZAT0003 + "</span>");
			}
		} else {
			builder.getFont().setBold(false);
			builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0003")));
		}
		//==================================================================================================	
		builder.endRow();

		//row : ZAT0004	As-Is 수작업(시간/월) - SL, ZAT0005	To-Be 수작업(시간/월) - SL
		builder.insertCell();
		//==================================================================================================	
		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		builder.getCellFormat().setWidth(titleCellWidth2);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setBold(true);
		builder.write(String.valueOf(attrNameMap.get("ZAT0004")));

		builder.insertCell();
		builder.getCellFormat().setWidth(contentCellWidth2);
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);

		String ZAT0004 = StringUtil.checkNullToBlank(attrMap.get("ZAT0004")).replaceAll("&lt;", "<")
				.replaceAll("&gt;", ">").replaceAll("&quot;", "\"").replace("upload/", logoPath);
		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("ZAT0004")))) { // type이 HTML인 경우
			if (StringUtil.checkNullToBlank(attrMap.get("ZAT0004")).contains("font-family")) {
				builder.insertHtml(ZAT0004);
			} else {
				builder.insertHtml(fontFamilyHtml + ZAT0004 + "</span>");
			}
		} else {
			builder.getFont().setBold(false);
			builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0004")));
		}

		builder.insertCell();
		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		builder.getCellFormat().setWidth(titleCellWidth2);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setBold(true);
		builder.write(String.valueOf(attrNameMap.get("ZAT0005")));

		builder.insertCell();
		builder.getCellFormat().setWidth(contentCellWidth2);
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);

		String ZAT0005 = StringUtil.checkNullToBlank(attrMap.get("ZAT0005")).replaceAll("&lt;", "<")
				.replaceAll("&gt;", ">").replaceAll("&quot;", "\"").replace("upload/", logoPath);
		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("ZAT0005")))) { // type이 HTML인 경우
			if (StringUtil.checkNullToBlank(attrMap.get("ZAT0005")).contains("font-family")) {
				builder.insertHtml(ZAT0005);
			} else {
				builder.insertHtml(fontFamilyHtml + ZAT0005 + "</span>");
			}
		} else {
			builder.getFont().setBold(false);
			builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0005")));
		}
		//==================================================================================================	
		builder.endRow();

		//row : ZAT0006	As-Is 수작업(시간/월) - BR, ZAT0007	To-Be 수작업(시간/월) - BR
		builder.insertCell();
		//==================================================================================================	
		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		builder.getCellFormat().setWidth(titleCellWidth2);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setBold(true);
		builder.write(String.valueOf(attrNameMap.get("ZAT0006")));

		builder.insertCell();
		builder.getCellFormat().setWidth(contentCellWidth2);
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);

		String ZAT0006 = StringUtil.checkNullToBlank(attrMap.get("ZAT0006")).replaceAll("&lt;", "<")
				.replaceAll("&gt;", ">").replaceAll("&quot;", "\"").replace("upload/", logoPath);
		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("ZAT0006")))) { // type이 HTML인 경우
			if (StringUtil.checkNullToBlank(attrMap.get("ZAT0006")).contains("font-family")) {
				builder.insertHtml(ZAT0006);
			} else {
				builder.insertHtml(fontFamilyHtml + ZAT0006 + "</span>");
			}
		} else {
			builder.getFont().setBold(false);
			builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0006")));
		}

		builder.insertCell();
		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		builder.getCellFormat().setWidth(titleCellWidth2);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setBold(true);
		builder.write(String.valueOf(attrNameMap.get("ZAT0007")));

		builder.insertCell();
		builder.getCellFormat().setWidth(contentCellWidth2);
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);

		String ZAT0007 = StringUtil.checkNullToBlank(attrMap.get("ZAT0007")).replaceAll("&lt;", "<")
				.replaceAll("&gt;", ">").replaceAll("&quot;", "\"").replace("upload/", logoPath);
		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("ZAT0007")))) { // type이 HTML인 경우
			if (StringUtil.checkNullToBlank(attrMap.get("ZAT0007")).contains("font-family")) {
				builder.insertHtml(ZAT0007);
			} else {
				builder.insertHtml(fontFamilyHtml + ZAT0007 + "</span>");
			}
		} else {
			builder.getFont().setBold(false);
			builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0007")));
		}
		//==================================================================================================	
		builder.endRow();

		//row : ZAT0008	As-Is 수작업(시간/월) - S9, ZAT0009	To-Be 수작업(시간/월) - S9
		builder.insertCell();
		//==================================================================================================	
		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		builder.getCellFormat().setWidth(titleCellWidth2);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setBold(true);
		builder.write(String.valueOf(attrNameMap.get("ZAT0008")));

		builder.insertCell();
		builder.getCellFormat().setWidth(contentCellWidth2);
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);

		String ZAT0008 = StringUtil.checkNullToBlank(attrMap.get("ZAT0008")).replaceAll("&lt;", "<")
				.replaceAll("&gt;", ">").replaceAll("&quot;", "\"").replace("upload/", logoPath);
		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("ZAT0008")))) { // type이 HTML인 경우
			if (StringUtil.checkNullToBlank(attrMap.get("ZAT0008")).contains("font-family")) {
				builder.insertHtml(ZAT0008);
			} else {
				builder.insertHtml(fontFamilyHtml + ZAT0008 + "</span>");
			}
		} else {
			builder.getFont().setBold(false);
			builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0008")));
		}

		builder.insertCell();
		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		builder.getCellFormat().setWidth(titleCellWidth2);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setBold(true);
		builder.write(String.valueOf(attrNameMap.get("ZAT0009")));

		builder.insertCell();
		builder.getCellFormat().setWidth(contentCellWidth2);
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);

		String ZAT0009 = StringUtil.checkNullToBlank(attrMap.get("ZAT0009")).replaceAll("&lt;", "<")
				.replaceAll("&gt;", ">").replaceAll("&quot;", "\"").replace("upload/", logoPath);
		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("ZAT0009")))) { // type이 HTML인 경우
			if (StringUtil.checkNullToBlank(attrMap.get("ZAT0009")).contains("font-family")) {
				builder.insertHtml(ZAT0009);
			} else {
				builder.insertHtml(fontFamilyHtml + ZAT0009 + "</span>");
			}
		} else {
			builder.getFont().setBold(false);
			builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0009")));
		}
		//==================================================================================================	
		builder.endRow();

		//row : ZAT0010	As-Is 수작업(시간/월) - GFS, ZAT0011	To-Be 수작업(시간/월) - GFS
		builder.insertCell();
		//==================================================================================================	
		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		builder.getCellFormat().setWidth(titleCellWidth2);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setBold(true);
		builder.write(String.valueOf(attrNameMap.get("ZAT0010")));

		builder.insertCell();
		builder.getCellFormat().setWidth(contentCellWidth2);
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);

		String ZAT0010 = StringUtil.checkNullToBlank(attrMap.get("ZAT0010")).replaceAll("&lt;", "<")
				.replaceAll("&gt;", ">").replaceAll("&quot;", "\"").replace("upload/", logoPath);
		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("ZAT0010")))) { // type이 HTML인 경우
			if (StringUtil.checkNullToBlank(attrMap.get("ZAT0010")).contains("font-family")) {
				builder.insertHtml(ZAT0010);
			} else {
				builder.insertHtml(fontFamilyHtml + ZAT0010 + "</span>");
			}
		} else {
			builder.getFont().setBold(false);
			builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0010")));
		}

		builder.insertCell();
		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		builder.getCellFormat().setWidth(titleCellWidth2);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setBold(true);
		builder.write(String.valueOf(attrNameMap.get("ZAT0011")));

		builder.insertCell();
		builder.getCellFormat().setWidth(contentCellWidth2);
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);

		String ZAT0011 = StringUtil.checkNullToBlank(attrMap.get("ZAT0011")).replaceAll("&lt;", "<")
				.replaceAll("&gt;", ">").replaceAll("&quot;", "\"").replace("upload/", logoPath);
		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("ZAT0011")))) { // type이 HTML인 경우
			if (StringUtil.checkNullToBlank(attrMap.get("ZAT0011")).contains("font-family")) {
				builder.insertHtml(ZAT0011);
			} else {
				builder.insertHtml(fontFamilyHtml + ZAT0011 + "</span>");
			}
		} else {
			builder.getFont().setBold(false);
			builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0011")));
		}
		//==================================================================================================	
		builder.endRow();

		//

		//ROW : 작성자, 수정일
		builder.insertCell();
		//==================================================================================================	
		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		builder.getCellFormat().setWidth(titleCellWidth2);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setBold(true);
		builder.write(String.valueOf(menu.get("LN00060"))); // 작성자

		builder.insertCell();
		builder.getFont().setBold(false);
		builder.getCellFormat().setWidth(contentCellWidth2);
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.write(StringUtil.checkNullToBlank(rowPrcData.get("Name"))); // 작성자 : 내용

		builder.insertCell();
		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		builder.getCellFormat().setWidth(titleCellWidth2);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
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

		// 6.ROW (Dimension 정보 만큼 행 표시)
		for (int j = 0; j < dimResultList.size(); j++) {
			Map dimResultMap = (Map) dimResultList.get(j);

			builder.insertCell();
			//==================================================================================================	
			builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			builder.getCellFormat().setWidth(titleCellWidth2);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			builder.getFont().setBold(true);
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
		builder.writeln();

		int headerNO = 2;
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
			builder.writeln(headerNO + ". " + String.valueOf(menu.get("LN00197")));
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

			String imgLang = "_" + StringUtil.checkNull(setMap.get("langCode"));
			String imgPath = modelImgPath + modelMap.get("ModelID") + imgLang + "."
					+ GlobalVal.MODELING_DIGM_IMG_TYPE;
			int width = Integer.parseInt(String.valueOf(modelMap.get("Width")));
			int height = Integer.parseInt(String.valueOf(modelMap.get("Height")));
			System.out.println("프로세스맵 imgPath=" + imgPath);
			try {
				builder.insertHtml("<br>");
				builder.insertImage(imgPath, RelativeHorizontalPosition.PAGE, 30, RelativeVerticalPosition.PAGE,
						20, width, height, WrapType.INLINE);
				builder.insertHtml("<br>");
			} catch (Exception ex) {
			}

			builder.endTable().setAllowAutoFit(false);

			//==================================================================================================

		}
		// 	 		}
	}
		}

		//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
		long date = System.currentTimeMillis();
		String fileName = "E2E_" + itemNameOfFileNm + "_" + formatter.format(date) + ".docx";
		if (outputType.equals("pdf")) {
	fileName = "E2E_" + itemNameOfFileNm + "_" + formatter.format(date) + ".pdf";
		}
		response.setContentType("application/msword");
		response.setCharacterEncoding("UTF-8");
		response.setHeader("content-disposition", "attachment; filename=" + fileName);

		if (outputType.equals("pdf")) {
	doc.save(response.getOutputStream(), SaveFormat.PDF);
		} else {
	doc.save(response.getOutputStream(), SaveFormat.DOCX);
		}
	}
} catch (Exception e) {
	//2025-03-25 소스코드 취약점 수정
	log.error("Exception", e);
	//e.printStackTrace();

} finally {
	request.getSession(true).setAttribute("expFlag", "Y");

	response.getOutputStream().flush();
	response.getOutputStream().close();
}
%>
