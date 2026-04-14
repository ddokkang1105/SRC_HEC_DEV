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
	String ulStyle = "<ul style=\"padding-left:30px;\">";
	String olStyle = "<ol style=\"padding-left:30px;\">";
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
//     builder.insertCell();
//     builder.getCellFormat().setWidth(200.0);
//     builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
    String imageFileName = logoPath + "logo.png";
//     String imageFileName2 = logoPath + "logo_footer.png";
//     builder.insertImage(imageFileName2, 125, 25);
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
//     builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
//     builder.insertCell();
//     builder.getCellFormat().setWidth(200.0);
//     builder.write("DSBPA");
    
    builder.endTable().setAllowAutoFit(false);
        
    builder.moveToDocumentEnd();
//=========================================================================
	
	builder = new DocumentBuilder(doc);
	
	//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
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
			builder.writeln("["+selectedItemPath+"]");
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
			builder.write(StringUtil.checkNullToBlank(selectedItemMap.get("Name")));				
			builder.insertCell();
		   	builder.getCellFormat().setWidth(200);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write("프로세스 자산화");
			builder.insertCell();
		   	builder.getCellFormat().setWidth(100);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(StringUtil.checkNullToBlank(selectedItemMap.get("CreateDT")));	
			builder.endRow();
			builder.endTable().setAlignment(TabAlignment.CENTER);
			builder.endRow();
			
			builder.endTable().setAllowAutoFit(false);
    		///////////////////////////////////////////////////////////////////////////////////////
    		// 표지 END
		//==================================================================================================
	
	builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
    		
	builder.getFont().setColor(Color.DARK_GRAY);
	builder.getFont().setSize(11);
	builder.getFont().setBold(true);
	builder.getFont().setName(defaultFont);
	builder.writeln("1. " + String.valueOf(menu.get("LN00005")));
	
	for (int totalCnt = 0; allTotalList.size() > totalCnt ; totalCnt++ ) {
		Map allTotalMap = (Map)allTotalList.get(totalCnt);
		Map titleItemMap = new HashMap();
		List totalList = (List)allTotalMap.get("totalList");
		
		//==================================================================================================
		if (totalList.size() > 0) { 
		 	for (int index = 0; totalList.size() > index ; index++) {
		 		
// 		 		if (totalList.size() != 1) {
// 		 			builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
// 		 		}
		 		
		 		Map totalMap = (Map)totalList.get(index);
		 		
		 		List prcList = (List)totalMap.get("prcList");
		 		Map rowPrcData =  (HashMap) prcList.get(0);
		 		
		 		Map attrMap = (Map)totalMap.get("attrMap");
		 		Map attrNameMap = (Map)totalMap.get("attrNameMap");
		 		Map attrHtmlMap = (Map)totalMap.get("attrHtmlMap");
		 		Map modelMap = (Map)totalMap.get("modelMap");
		 		
		 		builder.insertHtml("<br>");
			    String identifier =  StringUtil.checkNullToBlank(rowPrcData.get("Identifier"));
			    String itemName = StringUtil.checkNullToBlank(rowPrcData.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
			    itemName = itemName.replace("&#10;", " ");
				itemName = itemName.replace("&#xa;", "");
				itemName = itemName.replace("&nbsp;", " ");

	 	 	    builder.getFont().setColor(Color.BLACK);
	 	 	    builder.getFont().setSize(11);
	 	 	    
			    builder.writeln(identifier+" "+itemName); //명칭
		 		System.out.println(identifier);
		 		// 아이템 속성 		
		 		if ("N".equals(onlyMap)) {

		 			builder.startTable();
		 	 		
		 	 	    builder.getFont().setName(defaultFont);
		 	 	    builder.getFont().setColor(Color.BLACK);
		 	 	    builder.getFont().setSize(10);
		 	 		
		 	 		// Make the header row.
		 	 		builder.getRowFormat().clearFormatting();
		 	 		builder.getCellFormat().clearFormatting();
		 	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경
		 	 		
		 	 		for ( Object key : attrMap.keySet()) {
// 		 	 			if(!attrMap.get(key).equals("")){			// 내용 있는 필드만 출력
		 	 			// ROW
			 	 		builder.insertCell();
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(attrNameMap.get(key)));  // 개요
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(mergeCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						
			 	 		String contents = StringUtil.checkNullToBlank(attrMap.get(key)).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replaceAll("<ul>",ulStyle).replaceAll("<ol>",olStyle);
				 		builder.insertHtml(fontFamilyHtml+contents.replace("upload/", logoPath)+"</span>");
			 	 		//==================================================================================================	
			 	 		builder.endRow();
// 		 	 			}
		 	 		}
			    
		 	 		builder.endTable().setAllowAutoFit(false);
		 	 		builder.writeln();
		 	 				 	 		
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
			 	} // else
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
