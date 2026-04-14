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
	List items = (List)request.getAttribute("items");
 	Map itemsMap = (Map)request.getAttribute("itemsMap");
 	Map attrRsNameMap = (Map)request.getAttribute("attrRsNameMap");
 	Map attrRsHtmlMap = (Map)request.getAttribute("attrRsHtmlMap");
 	
 	String selectedItemPath = StringUtil.checkNull(request.getAttribute("selectedItemPath"));
 	String selectedItemName = StringUtil.checkNull(request.getAttribute("selectedItemName"));
 	String includeClassCode = StringUtil.checkNull(request.getAttribute("includeClassCode"));
 	
 	double titleCellWidth = 60.0;
 	double contentCellWidth3 = 90.0;
	double contentCellWidth = 165.0;
	double mergeCellWidth = 390.0;
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
	
	//builder.getPageSetup().setOrientation(Orientation.LANDSCAPE);
	
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
    builder.getCellFormat().setWidth(560.0);
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
		for(int i=0; i < items.size(); i++){
		Object itemID = items.get(i);
		List list = (List) itemsMap.get(itemID);
		Map itemInfo = (Map)list.get(0);
		
		Map prcListMap = (Map) itemInfo.get("prcList");
		List cnItemList = (List) itemInfo.get("resultSubList");
		
		builder.getFont().setSize(10);
		builder.getFont().setColor(Color.BLACK);
		builder.getFont().setName(defaultFont);
		
		builder.startTable();
		builder.getRowFormat().clearFormatting();
		builder.getCellFormat().clearFormatting();
		
		// Set features for the other rows and cells.
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getCellFormat().setWidth(100.0);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		
		// Reset height and define a different height rule for table body
		builder.getRowFormat().setHeight(30.0);
		builder.getRowFormat().setHeightRule(HeightRule.AUTO);
 			
	    	builder.insertCell();
		    builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			builder.getFont().setSize(10);
			builder.getFont().setBold (true);
			builder.getFont().setColor(Color.BLACK);
			builder.getFont().setName(defaultFont);
			
			builder.getCellFormat().setWidth(60.0);
			builder.write(String.valueOf(menu.get("LN00106"))); // ID
			
			builder.insertCell();
			builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);	
			builder.getFont().setBold (false);
		   	builder.getCellFormat().setWidth(125.0);		   
		   	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);	
		   	if(includeClassCode.equals("Y")){
		   		builder.write(StringUtil.checkNullToBlank(itemInfo.get("Identifier")));
		   	}else{
		   		builder.write(StringUtil.checkNullToBlank(itemInfo.get("toItemIdentifier")));	
		   	}
		   	
		   	builder.insertCell();
		    builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
		    builder.getFont().setBold (true);
			builder.getCellFormat().setWidth(60.0);
			builder.write(String.valueOf(menu.get("LN00028"))); // 명칭
			
			builder.insertCell();
			builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);	
			builder.getFont().setBold (false);
			builder.getCellFormat().setWidth(125.0);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			if(includeClassCode.equals("Y")){
				builder.write(StringUtil.checkNullToBlank(itemInfo.get("ItemName"))); 
			}else{
				builder.write(StringUtil.checkNullToBlank(itemInfo.get("toItemName"))); 
			}
			
			builder.insertCell();		
			builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
		    builder.getFont().setBold (true);
			builder.getCellFormat().setWidth(60.0);
			builder.write(String.valueOf(menu.get("LN00016"))); // class
			
			builder.insertCell();
			builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);	
			builder.getFont().setBold (false);
			builder.getCellFormat().setWidth(130.0);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			if(includeClassCode.equals("Y")){
				builder.write(StringUtil.checkNullToBlank(itemInfo.get("ItemClassName"))); 
			}else{
				builder.write(StringUtil.checkNullToBlank(itemInfo.get("toItemClassName"))); 
			}
			
			builder.endRow();
			//===========================================================================================================
			
		    builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			builder.getFont().setSize(10);
			builder.getFont().setBold (true);
			builder.getFont().setColor(Color.BLACK);
			builder.getFont().setName(defaultFont);
			builder.insertCell();
			builder.getCellFormat().setWidth(60.0);
			builder.write(String.valueOf(menu.get("LN00014"))); // 법인
			
			builder.insertCell();
			builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);	
			builder.getFont().setBold (false);
		   	builder.getCellFormat().setWidth(125.0);		   
		   	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		   	
		   	if(includeClassCode.equals("Y")){
				builder.write(StringUtil.checkNullToBlank(itemInfo.get("ItemCompanyName"))); 
			}else{
		   		builder.write(StringUtil.checkNullToBlank(itemInfo.get("toItemCompanyName")));
			}
		   	
		   	builder.insertCell();
		    builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
		    builder.getFont().setBold (true);
			builder.getCellFormat().setWidth(60.0);
			builder.write(String.valueOf(menu.get("LN00018"))); // 관리조직
			
			builder.insertCell();
			builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);	
			builder.getFont().setBold (false);
			builder.getCellFormat().setWidth(125.0);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			if(includeClassCode.equals("Y")){
				builder.write(StringUtil.checkNullToBlank(itemInfo.get("ItemTeamName"))); 
			}else{
				builder.write(StringUtil.checkNullToBlank(itemInfo.get("toItemTeamName"))); 
			}
			
			builder.insertCell();		
			builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
		    builder.getFont().setBold (true);
			builder.getCellFormat().setWidth(60.0);
			builder.write(String.valueOf(menu.get("LN00004"))); // 담당자
			
			builder.insertCell();
			builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);	
			builder.getFont().setBold (false);
			builder.getCellFormat().setWidth(130.0);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			if(includeClassCode.equals("Y")){
				builder.write(StringUtil.checkNullToBlank(itemInfo.get("ItemAuthorName"))); 
			}else{
				builder.write(StringUtil.checkNullToBlank(itemInfo.get("toItemAuthorName"))); 	
			}
			
			builder.endRow();
			
			//===========================================================================================================
			
			builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			builder.getFont().setSize(10);
			builder.getFont().setBold (true);
			builder.getFont().setColor(Color.BLACK);
			builder.getFont().setName(defaultFont);
			builder.insertCell();
			builder.getCellFormat().setWidth(60.0);
			builder.write(String.valueOf(menu.get("LN00043"))); // 경로
			
			builder.insertCell();
			builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);	
			builder.getFont().setBold (false);
			builder.getCellFormat().setWidth(310.0);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			
			if(includeClassCode.equals("Y")){
				builder.write(StringUtil.checkNullToBlank(itemInfo.get("ItemPath"))); 
			}else{
				builder.write(StringUtil.checkNullToBlank(itemInfo.get("toItemPath")));
			}
			
			builder.insertCell();		
			builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
		    builder.getFont().setBold (true);
			builder.getCellFormat().setWidth(60.0);
			builder.write(String.valueOf(menu.get("LN00070"))); // 최종수정일
			
			builder.insertCell();
			builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);	
			builder.getFont().setBold (false);
			builder.getCellFormat().setWidth(130.0);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			
			if(includeClassCode.equals("Y")){
				builder.write(StringUtil.checkNullToBlank(itemInfo.get("ItemLastUpdated"))); 
			}else{
				builder.write(StringUtil.checkNullToBlank(itemInfo.get("toItemLastUpdated"))); 	
			}
			builder.endRow();
			
			// 개요 ===========================================================================================================
			
			builder.insertCell();
			builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);	
			builder.getCellFormat().setWidth(560.0);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			
			String AT00003 = StringUtil.checkNullToBlank(itemInfo.get("AT00003")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("/upload", logoPath);
			if ("1".equals(StringUtil.checkNullToBlank(attrRsHtmlMap.get("AT00003")))) { // type이 HTML인 경우
 	 			if(StringUtil.checkNullToBlank(itemInfo.get("AT00003")).contains("font-family")){
 	 				builder.insertHtml(AT00003);
 	 			}else{
 	 				builder.insertHtml(fontFamilyHtml+AT00003+"</span>");
 	 			}
 	 		} else {
 	 			builder.getFont().setBold(false);
 	 			builder.write(StringUtil.checkNullToBlank(itemInfo.get("AT00003"))); // 개요 : 내용
 	 		}
			
			builder.endRow();
			
			// AttrList ====================================================================================
					
			List attrList = (List) itemInfo.get("attrList");
			if(attrList.size()>0){
				for(int j=0; j < attrList.size(); j++){
					Map attrInfoMap = (Map)attrList.get(j);
					String attrTypeCode = StringUtil.checkNullToBlank(attrInfoMap.get("AttrTypeCode"));
					
					if(!attrTypeCode.equals("AT00003")){
						builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
						builder.getFont().setSize(10);
						builder.getFont().setBold (true);
						builder.getFont().setColor(Color.BLACK);
						builder.getFont().setName(defaultFont);
						builder.insertCell();
						builder.getCellFormat().setWidth(80.0);
						String attrName = StringUtil.checkNullToBlank(attrInfoMap.get("Name"));
						builder.write(attrName); // 개요
						
						builder.insertCell();
						builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);	
						builder.getCellFormat().setWidth(500.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
						
						String plainText = StringUtil.checkNullToBlank(attrInfoMap.get("PlainText")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("/upload", logoPath);
						String html = StringUtil.checkNull(attrInfoMap.get("HTML"));
						if ("1".equals(html)) { // type이 HTML인 경우
			 	 			if(plainText.contains("font-family")){
			 	 				builder.insertHtml(plainText);
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+plainText+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(plainText); // 개요 : 내용
			 	 		}
						
						builder.endRow();
					}
				}
			}
			
			// 연관항목===========================================================================================================
			
			//builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
			//builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			//builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			//builder.getFont().setSize(10);
			//builder.getFont().setBold(true);
			//builder.getFont().setColor(Color.BLACK);
			//builder.getFont().setName(defaultFont);
			//builder.insertCell();
			//builder.getCellFormat().setWidth(60.0);
			//builder.write(String.valueOf(menu.get("LN00008"))); // 연관항목
			
			//builder.insertCell();
			//builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);	
			//builder.getCellFormat().setWidth(500.0);
			//builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			//builder.getFont().setBold(false);
			//String cnItems = "";
			//for(int prcCnt=0; prcCnt < cnItemList.size(); prcCnt++){
			//	String cnItem = String.valueOf(cnItemList.get(prcCnt));
			//	builder.write(cnItem);
			//}
			//builder.endRow();
			
			// Dimension ===========================================================================================================
			List dimResultList = (List) itemInfo.get("dimResultList");
			if(dimResultList.size()>0){
				for(int k=0; k < dimResultList.size(); k++){
					Map dimInfoMap = (Map)dimResultList.get(k);
					
					builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					builder.getFont().setSize(10);
					builder.getFont().setBold (true);
					builder.getFont().setColor(Color.BLACK);
					builder.getFont().setName(defaultFont);
					builder.insertCell();
					builder.getCellFormat().setWidth(80.0);
					String dimTypeName = StringUtil.checkNullToBlank(dimInfoMap.get("dimTypeName"));
					builder.write(dimTypeName); // dimTypeName
					
					builder.insertCell();
					builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);	
					builder.getCellFormat().setWidth(500.0);
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					
					String dimValueNames = StringUtil.checkNullToBlank(dimInfoMap.get("dimValueNames"));
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(dimValueNames);  // dimValueNames
					builder.endRow();
				}
			}		
					
			builder.endTable().setAllowAutoFit(false);
			builder.insertBreak(BreakType.PAGE_BREAK);
		}
		
		
	//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
	long date = System.currentTimeMillis();
    String fileName = "Report_" + selectedItemName + "_" + formatter.format(date) + ".docx";
    response.setContentType("application/msword");
    response.setCharacterEncoding("UTF-8");
    response.setHeader("content-disposition","attachment; filename=" + fileName);
    
    doc.save(response.getOutputStream(), SaveFormat.DOCX);

} catch(Exception e){
	e.printStackTrace();
	
} finally{
	response.getOutputStream().flush();
	response.getOutputStream().close();
}

%>

