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
	String paperSize = String.valueOf(request.getAttribute("paperSize"));
 	
	License license = new License();
	license.setLicense(logoPath + "Aspose.Words.lic");
	
	Document doc = new Document();
	DocumentBuilder builder = new DocumentBuilder(doc);	
	
	Map menu = (Map)request.getAttribute("menu");
 	Map setMap = (HashMap)request.getAttribute("setMap");
 	List ruleSetList = (List)request.getAttribute("allSubItemList");
 	Map attrRsNameMap = (Map)request.getAttribute("attrRsNameMap");
 	Map attrRsHtmlMap = (Map)request.getAttribute("attrRsHtmlMap");
 	Map selectedItemInfo = (Map)request.getAttribute("selectedItemInfo");
 	
 	String selectedItemPath = String.valueOf(request.getAttribute("selectedItemPath"));
 	String selectedItemName = String.valueOf(request.getAttribute("selectedItemName"));
 	String includeClassCode = String.valueOf(request.getAttribute("includeClassCode"));
 	
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
	
	//builder.getPageSetup().setOrientation(Orientation.LANDSCAPE); // 세로 option
	
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
	builder.getCellFormat().setWidth(totalCellWidth);
	builder.getFont().setColor(Color.BLACK);
    builder.getFont().setBold(true);
    builder.getFont().setName(defaultFont);
    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
    builder.getFont().setSize(20);   
    builder.writeln(String.valueOf(selectedItemInfo.get("ItemName")) );
    builder.insertHtml("<br><br><br>");
	builder.endRow();
	
	// 3.선택한 L2 프로세스 정보
	builder.insertCell();
	builder.getFont().setColor(Color.BLACK);
    builder.getFont().setBold(true);
    builder.getFont().setName(defaultFont);
    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
    builder.getFont().setSize(18);
    builder.getFont().setUnderline(0);
	builder.writeln(String.valueOf(selectedItemInfo.get("Identifier")) );
	builder.insertHtml("<br><br><br><br><br><br><br>");
	builder.endRow();
	
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
	
	// Set features for the other rows and cells.
	builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	
	// Reset height and define a different height rule for table body
	builder.getRowFormat().setHeight(30.0);
	builder.getRowFormat().setHeightRule(HeightRule.AUTO);
	
	builder.insertCell();
   	builder.getCellFormat().setWidth(120);
	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	builder.write("적용법인");				
	builder.insertCell();
   	builder.getCellFormat().setWidth(200);
	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	builder.write(String.valueOf(selectedItemInfo.get("TeamName")));
	builder.endRow();
	
	builder.insertCell();
   	builder.getCellFormat().setWidth(120);
	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	builder.write(String.valueOf(menu.get("LN00018")));	 // 관리조직	
	builder.insertCell();
   	builder.getCellFormat().setWidth(200);
	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	builder.write(String.valueOf(selectedItemInfo.get("OwnerTeamName")));
	builder.endRow();
	
	builder.endTable().setAlignment(TabAlignment.CENTER);
	builder.endRow();
	
	builder.endTable().setAllowAutoFit(false);
	

	///////////////////////////////////////////////////////////////////////////////////////
	// 표지 END
	builder.insertBreak(BreakType.PAGE_BREAK);
	
	if (ruleSetList.size() > 0) {	
		
		for(int i=0; i < ruleSetList.size(); i++){
			
			Map ruleSetInfo = (HashMap) ruleSetList.get(i);
			List cnItemList = (List) ruleSetInfo.get("resultSubList");
			List changeSetList = (List) ruleSetInfo.get("changeSetList");
			List fileList = (List) ruleSetInfo.get("fileList");
			
			builder.getFont().setSize(11);
			builder.getFont().setColor(Color.BLACK);
			builder.getFont().setName(defaultFont);
			builder.getFont().setBold(true);
			
			// 개정이력
			//============================================================================================================
			
			builder.writeln("[개정이력]");
			builder.getFont().setSize(10);
			builder.getFont().setColor(Color.BLACK);
			builder.getFont().setName(defaultFont);
			builder.getFont().setBold(false);
			
			
			builder.startTable();
			builder.getRowFormat().clearFormatting();
			builder.getCellFormat().clearFormatting();
			
			// Set features for the other rows and cells.
			builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			builder.getCellFormat().setWidth(totalCellWidth);
			builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			
			// Reset height and define a different height rule for table body
			builder.getRowFormat().setHeight(30.0);
			builder.getRowFormat().setHeightRule(HeightRule.AUTO);
			if(changeSetList.size()>0){
				builder.insertCell();
			    builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
				builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
				builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				builder.getFont().setSize(10);
				builder.getFont().setBold (true);
				builder.getFont().setColor(Color.BLACK);
				builder.getFont().setName(defaultFont);
				
				builder.getCellFormat().setWidth(60.0);
				builder.write("차수"); // 차수
				  	
			   	builder.insertCell();
			    builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
			    builder.getFont().setBold (true);
				builder.getCellFormat().setWidth(80.0);
				builder.write("개정일자"); // 개정일자
				
				builder.insertCell();
			    builder.getFont().setBold (true);
				builder.getCellFormat().setWidth(320.0);
				builder.write("변경개요"); // 변경개요
				
				builder.insertCell();
			    builder.getFont().setBold (true);
				builder.getCellFormat().setWidth(100.0);
				builder.write("개정자"); // 개정자
				
				builder.endRow();
				
				for(int k=0; k < changeSetList.size(); k++){				
					Map changeInfo = (HashMap) changeSetList.get(k);			
	 			
			    	builder.insertCell();
				    builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);	
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					builder.getFont().setSize(10);
					builder.getFont().setBold (false);
					builder.getFont().setColor(Color.BLACK);
					
					builder.getCellFormat().setWidth(60.0);
					builder.write(String.valueOf(changeInfo.get("RNUM"))); // 차수
					  	
				   	builder.insertCell();
					builder.getCellFormat().setWidth(80.0);
					builder.write(String.valueOf(changeInfo.get("RegDate")));  // 개정일자
					
					builder.insertCell();
					builder.getCellFormat().setWidth(320.0);
					builder.write(StringUtil.checkNull(changeInfo.get("Description"))); // 변경개요
					
					builder.insertCell();
					builder.getCellFormat().setWidth(100.0);
					builder.write(String.valueOf(changeInfo.get("AuthorName")));  // 개정자
					
					builder.endRow();
				}
				builder.endTable();
			}
			builder.insertHtml("<br><br>");
			
			
			// fileList 
			//===========================================================================================================
			builder.getFont().setSize(11);
			builder.getFont().setBold(true);
			builder.writeln("["+String.valueOf(menu.get("LN00019"))+"]");
			builder.getFont().setSize(10);
			builder.getFont().setColor(Color.BLACK);
			builder.getFont().setName(defaultFont);
			builder.getFont().setBold(false);
			
			if(fileList.size()>0){
				builder.startTable();
				builder.getRowFormat().clearFormatting();
				builder.getCellFormat().clearFormatting();
				
				// Set features for the other rows and cells.
				builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
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
				
				builder.getCellFormat().setWidth(160.0);
				builder.write(String.valueOf(menu.get("LN00091"))); // 문서유형
								  	
			   	builder.insertCell();
			    builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
			    builder.getFont().setBold (true);
				builder.getCellFormat().setWidth(400.0);
				builder.write(String.valueOf(menu.get("LN00101"))); // 문서명
				
				builder.endRow();
				
				for(int k=0; k < fileList.size(); k++){				
					Map fileInfo = (HashMap) fileList.get(k);			
	 			
			    	builder.insertCell();
				    builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);	
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					builder.getFont().setSize(10);
					builder.getFont().setBold (false);
					builder.getFont().setColor(Color.BLACK);
					
					builder.getCellFormat().setWidth(160.0);
					builder.write(StringUtil.checkNull(fileInfo.get("FltpName"))); // 문서유형
					  	
				   	builder.insertCell();
				   	builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
					builder.getCellFormat().setWidth(400.0);
					builder.write(String.valueOf(fileInfo.get("FileRealName")));  // 문서명
					
					builder.endRow();
				}
				builder.endTable();
			}
			builder.insertHtml("<br><br>");
			
			// itemInfo
			//============================================================================================================
			
			builder.startTable();
			builder.getRowFormat().clearFormatting();
			builder.getCellFormat().clearFormatting();
			
			// Set features for the other rows and cells.
			builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
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
		   		builder.write(StringUtil.checkNullToBlank(ruleSetInfo.get("Identifier")));
		   	}else{
		   		builder.write(StringUtil.checkNullToBlank(ruleSetInfo.get("toItemIdentifier")));	
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
				builder.write(StringUtil.checkNullToBlank(ruleSetInfo.get("ItemName"))); 
			}else{
				builder.write(StringUtil.checkNullToBlank(ruleSetInfo.get("toItemName"))); 
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
				builder.write(StringUtil.checkNullToBlank(ruleSetInfo.get("ItemClassName"))); 
			}else{
				builder.write(StringUtil.checkNullToBlank(ruleSetInfo.get("toItemClassName"))); 
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
				builder.write(StringUtil.checkNullToBlank(ruleSetInfo.get("ItemCompanyName"))); 
			}else{
		   		builder.write(StringUtil.checkNullToBlank(ruleSetInfo.get("toItemCompanyName")));
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
				builder.write(StringUtil.checkNullToBlank(ruleSetInfo.get("ItemTeamName"))); 
			}else{
				builder.write(StringUtil.checkNullToBlank(ruleSetInfo.get("toItemTeamName"))); 
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
				builder.write(StringUtil.checkNullToBlank(ruleSetInfo.get("ItemAuthorName"))); 
			}else{
				builder.write(StringUtil.checkNullToBlank(ruleSetInfo.get("toItemAuthorName"))); 	
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
				builder.write(StringUtil.checkNullToBlank(ruleSetInfo.get("ItemPath"))); 
			}else{
				builder.write(StringUtil.checkNullToBlank(ruleSetInfo.get("toItemPath")));
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
				builder.write(StringUtil.checkNullToBlank(ruleSetInfo.get("ItemLastUpdated"))); 
			}else{
				builder.write(StringUtil.checkNullToBlank(ruleSetInfo.get("toItemLastUpdated"))); 	
			}
			builder.endRow();
			
			// 개요 ===========================================================================================================
			/*
			builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			builder.getFont().setSize(10);
			builder.getFont().setColor(Color.BLACK);
			builder.getFont().setName(defaultFont);*/
			
			builder.insertCell();
			builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);	
			builder.getCellFormat().setWidth(560.0);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			
			String AT00003 = StringUtil.checkNullToBlank(ruleSetInfo.get("AT00003")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
			if ("1".equals(StringUtil.checkNullToBlank(attrRsHtmlMap.get("AT00003")))) { // type이 HTML인 경우
 	 			if(StringUtil.checkNullToBlank(ruleSetInfo.get("AT00003")).contains("font-family")){
 	 				builder.insertHtml(AT00003);
 	 			}else{
 	 				builder.insertHtml(fontFamilyHtml+AT00003+"</span>");
 	 			}
 	 		} else {
 	 			builder.getFont().setBold(false);
 	 			builder.write(StringUtil.checkNullToBlank(ruleSetInfo.get("AT00003"))); // 개요 : 내용
 	 		}
			
			builder.endRow();
			
			
			// AttrList ====================================================================================
					
			List attrList = (List) ruleSetInfo.get("attrList");
			if(attrList.size()>0){
				for(int j=0; j < attrList.size(); j++){
					Map attrInfoMap = (Map)attrList.get(j);
					String attrTypeCode = StringUtil.checkNullToBlank(attrInfoMap.get("AttrTypeCode"));
					
					if(!attrTypeCode.equals("AT00003")){
						builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
						builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
						builder.getFont().setSize(10);
						builder.getFont().setBold (true);
						builder.getFont().setColor(Color.BLACK);
						builder.getFont().setName(defaultFont);
						builder.insertCell();
						builder.getCellFormat().setWidth(60.0);
						String attrName = StringUtil.checkNullToBlank(attrInfoMap.get("Name"));
						builder.write(attrName); // 개요
						
						builder.insertCell();
						builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);	
						builder.getCellFormat().setWidth(500.0);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
						
						String plainText = StringUtil.checkNullToBlank(attrInfoMap.get("PlainText")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
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
			
			builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			builder.getFont().setSize(10);
			builder.getFont().setBold(true);
			builder.getFont().setColor(Color.BLACK);
			builder.getFont().setName(defaultFont);
			builder.insertCell();
			builder.getCellFormat().setWidth(60.0);
			builder.write(String.valueOf(menu.get("LN00008"))); // 연관항목
			
			builder.insertCell();
			builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);	
			builder.getCellFormat().setWidth(500.0);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			builder.getFont().setBold(false);
			String cnItems = "";
			for(int prcCnt=0; prcCnt < cnItemList.size(); prcCnt++){
				String cnItem = String.valueOf(cnItemList.get(prcCnt));
				builder.write(cnItem);
			}
			builder.endRow();
			
			// Dimension ===========================================================================================================
			List dimResultList = (List) ruleSetInfo.get("dimResultList");
			if(dimResultList.size()>0){
				for(int k=0; k < dimResultList.size(); k++){
					Map dimInfoMap = (Map)dimResultList.get(k);
					
					builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(240, 248, 255));
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					builder.getFont().setSize(10);
					builder.getFont().setBold (true);
					builder.getFont().setColor(Color.BLACK);
					builder.getFont().setName(defaultFont);
					builder.insertCell();
					builder.getCellFormat().setWidth(60.0);
					String dimTypeName = StringUtil.checkNullToBlank(dimInfoMap.get("dimTypeName"));
					builder.write(dimTypeName); // dimTypeName
					
					builder.insertCell();
					builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);	
					builder.getCellFormat().setWidth(500.0);
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
					
					String dimValueNames = StringUtil.checkNullToBlank(dimInfoMap.get("dimValueNames"));
	 	 			builder.getFont().setBold(false);
	 	 			builder.write(dimValueNames);  // dimValueNames
					builder.endRow();
				}
			}		
					
			builder.endTable().setAllowAutoFit(false);	
			builder.insertHtml("<br>");
			
		}	
		builder.insertHtml("<br>");
		
		
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
	e.printStackTrace();
	
} finally{
	response.getOutputStream().flush();
	response.getOutputStream().close();
}

%>

