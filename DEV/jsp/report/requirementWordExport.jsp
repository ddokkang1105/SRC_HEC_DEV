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
 	List ruleSetList = (List)request.getAttribute("requirementList");
 	Map attrRsNameMap = (Map)request.getAttribute("attrRsNameMap");
 	Map attrRsHtmlMap = (Map)request.getAttribute("attrRsHtmlMap");
 	
 	String selectedItemPath = String.valueOf(request.getAttribute("selectedItemPath"));
 	String selectedItemName = String.valueOf(request.getAttribute("selectedItemName"));
 	
 	double titleCellWidth = 60.0;
 	double contentCellWidth3 = 90.0;
	double contentCellWidth = 165.0;
	double mergeCellWidth = 390.0;
	double totalCellWidth = 450.0;
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
	
	builder.getPageSetup().setOrientation(Orientation.LANDSCAPE);
	
//==================================================================================================

//=========================================================================
// TODO : FOOTER
	currentSection = builder.getCurrentSection();
    pageSetup = currentSection.getPageSetup();
    
    pageSetup.setDifferentFirstPageHeaderFooter(false);
    pageSetup.setFooterDistance(20);
    builder.moveToHeaderFooter(HeaderFooterType.FOOTER_PRIMARY);
    
    builder.startTable();
    builder.getCellFormat().getBorders().setLineWidth(0.0);
    builder.getFont().setName(defaultFont);
    builder.getFont().setColor(Color.BLACK);
    builder.getFont().setSize(10);
    
 	// 1.footer : Line
 	//builder.getParagraphFormat().setSpaceBefore(7);
    builder.insertHtml("<hr size=2 color='silver'/>");
 	// 2.footer : logo
    //builder.insertCell();
    //builder.getCellFormat().setWidth(150.0);
    //builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
    //String imageFileName = logoPath + "logo.png";
    //builder.insertImage(imageFileName, 125, 25);
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
    //builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
    //builder.insertCell();
    //builder.getCellFormat().setWidth(150.0);
    //builder.write("PI/ERP TFT");
    
    builder.endTable().setAllowAutoFit(false);
        
    builder.moveToDocumentEnd();
//=========================================================================

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
	builder.getRowFormat().setHeight(20.0);
	builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
	
	builder.insertCell();
	builder.getCellFormat().getBorders().setColor(Color.WHITE);
	builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	builder.getFont().setName(defaultFont);
    builder.getFont().setBold(true);
    builder.getFont().setColor(Color.BLUE);
    builder.getFont().setSize(14);
    builder.getParagraphFormat().setAlignment(ParagraphAlignment.RIGHT);
    builder.write(selectedItemPath);
   
    builder.endRow();	
    builder.endTable().setAllowAutoFit(false);	
    
    // 타이틀과 내용 사이 간격
    builder.insertHtml("<hr size=2 color='silver'/>");
    
 	// 머릿말 : END
 	builder.moveToDocumentEnd();
  	//==================================================================================================
	
	builder = new DocumentBuilder(doc);
	
	//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	//builder.insertHtml("<br>");
	
	if (ruleSetList.size() > 0) {
		
		builder.getFont().setSize(10);
		//builder.getFont().setBold (true);
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
		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setSize(10);
		builder.getFont().setBold (true);
		builder.getFont().setColor(Color.BLACK);
		builder.getFont().setName(defaultFont);
		
		builder.getCellFormat().setWidth(35.0);
		builder.write(String.valueOf(menu.get("LN00106"))); // ID
		builder.insertCell();
		builder.getCellFormat().setWidth(50.0);
		builder.write(String.valueOf(menu.get("LN00028"))); // 명칭
		builder.insertCell();
		builder.getCellFormat().setWidth(150.0);
		builder.write(String.valueOf(menu.get("LN00035"))); // 개요
		builder.insertCell();
		builder.getCellFormat().setWidth(150.0);
		builder.write(String.valueOf(attrRsNameMap.get("AT00023"))); // 기대효과
		builder.getCellFormat().setWidth(80.0);
		builder.write(String.valueOf(menu.get("LN00155"))); // 연관 프로세스
		builder.endRow();	
		
		// Set features for the other rows and cells.
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getCellFormat().setWidth(100.0);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		
		// Reset height and define a different height rule for table body
		builder.getRowFormat().setHeight(30.0);
		builder.getRowFormat().setHeightRule(HeightRule.AUTO);
		
		for(int i=0; i < ruleSetList.size(); i++){
			
			Map rowCnData = (HashMap) ruleSetList.get(i);
			List cnItemList = (List) rowCnData.get("resultSubList");
 			
	    	builder.insertCell();
		    if(i==0){
		    	// Reset font formatting.
		    	builder.getFont().setBold(false);
		    }
		    
		    
		   	builder.getCellFormat().setWidth(35.0);
		   	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		   	
		   	builder.write(StringUtil.checkNullToBlank(rowCnData.get("toItemIdentifier")));
			builder.insertCell();
			builder.getCellFormat().setWidth(50.0);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(StringUtil.checkNullToBlank(rowCnData.get("toItemName"))); 
			
			builder.insertCell();
			builder.getCellFormat().setWidth(150.0);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			if ("1".equals(StringUtil.checkNullToBlank(attrRsHtmlMap.get("AT00003")))) { // type이 HTML인 경우
 	 			builder.insertHtml(StringUtil.checkNullToBlank(rowCnData.get("AT00003")).replace("upload/", logoPath));
 	 		} else {
 	 			builder.getFont().setBold(false);
 	 			builder.write(StringUtil.checkNullToBlank(rowCnData.get("AT00003"))); // 개요 : 내용
 	 		}
			
			builder.insertCell();
			builder.getCellFormat().setWidth(150.0);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			if ("1".equals(StringUtil.checkNullToBlank(attrRsHtmlMap.get("AT00023")))) { // type이 HTML인 경우
 	 			builder.insertHtml(StringUtil.checkNullToBlank(rowCnData.get("AT00023")).replace("upload/", logoPath));
 	 		} else {
 	 			builder.getFont().setBold(false);
 	 			builder.write(StringUtil.checkNullToBlank(rowCnData.get("AT00023"))); // IT 요구사항 : 내용
 	 		}
			
			// 연관 프로세스
			builder.insertCell();
			builder.getCellFormat().setWidth(80.0);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			String cnItems = "";
			for(int prcCnt=0; prcCnt < cnItemList.size(); prcCnt++){
				String cnItem = String.valueOf(cnItemList.get(prcCnt));
				builder.writeln(cnItem);
			}
			
			builder.endRow();
			
		}	
		
		builder.endTable().setAllowAutoFit(false);	
		
	}
	
	//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
	long date = System.currentTimeMillis();
    String fileName = "Ruleset_Report_" + selectedItemName + "_" + formatter.format(date) + ".docx";
    response.setContentType("application/msword");
    response.setCharacterEncoding("UTF-8");
    response.setHeader("content-disposition","attachment; filename=" + fileName);
    
    doc.save(response.getOutputStream(), SaveFormat.DOCX);

} catch(Exception e){
	//2025-03-25 소스코드 취약점 수정
	log.error("Exception", e);
	//e.printStackTrace();
	
} finally{
	response.getOutputStream().flush();
	response.getOutputStream().close();
}

%>

