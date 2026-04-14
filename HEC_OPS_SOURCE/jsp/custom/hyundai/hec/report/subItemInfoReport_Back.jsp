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
<%@page import="xbolt.cmm.framework.util.DRMUtil" %>

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
 	
 	String selectedItemName = String.valueOf(request.getAttribute("selectedItemName"));
 	
 	String paperSize = String.valueOf(request.getAttribute("paperSize"));
 	String outputType = String.valueOf(request.getAttribute("outputType"));
	String itemName = "";
 	
 	double titleCellWidth = 60.0;
 	double contentCellWidth3 = 90.0;
	double contentCellWidth = 165.0;
	double mergeCellWidth = 390.0;
	double totalCellWidth = 560.0;
		
	String fontFamilyHtml = "<span style=\"font-family:"+defaultFont+"; font-size: 10pt;\">";
//==================================================================================================
	Section currentSection = builder.getCurrentSection();
    PageSetup pageSetup = currentSection.getPageSetup();
    
    // page 여백 설정
	builder.getPageSetup().setRightMargin(57);
	builder.getPageSetup().setLeftMargin(57);
	builder.getPageSetup().setBottomMargin(57);
	builder.getPageSetup().setTopMargin(57);
	
	builder.getPageSetup().setOrientation(Orientation.LANDSCAPE);
	// PaperSize 설정
	builder.getPageSetup().setPaperSize(PaperSize.A4);
	
//==================================================================================================
	SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
	long date = System.currentTimeMillis();
	String fileName = "";
	 
//=========================================================================
// TODO : FOOTER
	currentSection = builder.getCurrentSection();
    pageSetup = currentSection.getPageSetup();
        
 	String imageFileName = logoPath + "logo_HEC.png";
        
    builder.moveToDocumentEnd();
	//=========================================================================
	builder = new DocumentBuilder(doc);
	//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	for(int i=0; i < items.size(); i++) {
		Object itemID = items.get(i);
		List list = (List) itemsMap.get(itemID);
		Map itemInfo = (Map)list.get(0);
		
		Map prcListMap = (Map) itemInfo.get("prcList");
		List cngtList = (List) itemInfo.get("cngtList");

		List relItemList = (List) itemInfo.get("relItemList");
		List fileList = (List) itemInfo.get("fileList");
		itemName = StringUtil.checkNullToBlank(prcListMap.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
		itemName = itemName.replace("&#10;", " ").replace("&#xa;", "").replace("&nbsp;", " ").replace("&amp;", "&");
		
		//==================================================================================================
 		/* 표지 */
//  	    currentSection = builder.getCurrentSection();
// 		pageSetup = currentSection.getPageSetup();
// 		pageSetup.setDifferentFirstPageHeaderFooter(true);
// 		builder.moveToHeaderFooter(HeaderFooterType.HEADER_FIRST);
		
 	    // NEW 머릿글 : START
//  	    builder.startTable();
// 		builder.getCellFormat().setWidth(738);
// 		builder.getRowFormat().clearFormatting();
// 		builder.getCellFormat().clearFormatting();
		
// 		// Make the header row.
// 		builder.insertCell();
// 		builder.getRowFormat().setHeight(70.0);
		
// 		// Some special features for the header row.
// 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
// 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
// 		builder.getFont().setSize(22);
// 		builder.getFont().setUnderline(0);
// 		builder.getFont().setBold(true);
// 		builder.getFont().setColor(Color.BLACK);
// 		builder.getFont().setName(defaultFont);
		
		
// 		builder.write("SOP (표준업무절차)");  
// 		builder.endRow();
		
// 		builder.endTable();
//  	 	// 머릿말 : END
//  	 	builder.moveToDocumentEnd();
//  	  	//==================================================================================================
 	  	
// 		// 머릿말 : START
// 		currentSection = builder.getCurrentSection();
// 	    pageSetup = currentSection.getPageSetup();
// 	    pageSetup.setHeaderDistance(57);
// 	    builder.moveToHeaderFooter(HeaderFooterType.HEADER_PRIMARY);
	    
// 		builder.startTable();
// 		builder.getCellFormat().setWidth(800);
// 		builder.getRowFormat().clearFormatting();
// 		builder.getCellFormat().clearFormatting();
// 		builder.getRowFormat().setHeight(70.0);
		
// 		builder.insertCell();
		
// 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
// 		builder.getFont().setName(defaultFont);
// 	    builder.getFont().setBold(true);
// 	    builder.getFont().setColor(Color.black);
// 	    builder.getFont().setSize(8);
// 	    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
// 	    builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
// 	    builder.getCellFormat().setWidth(222);
// 	    builder.insertImage(imageFileName,100,18);//현대 로고
	    
// 	    builder.insertCell();
// 	    builder.getCellFormat().setWidth(302);
// 	    builder.getFont().setSize(16);
// 		builder.write(itemName);
		
// 		builder.insertCell();
// 	    builder.getFont().setSize(8);
// 	    builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
// 	    builder.getCellFormat().setWidth(274);
// 		builder.writeln("문서번호 : "+StringUtil.checkNullToBlank(prcListMap.get("Identifier")));
// 		builder.writeln("개정번호 : "+StringUtil.checkNullToBlank(prcListMap.get("Version")));
// 		builder.writeln("개정일자 : "+StringUtil.checkNullToBlank(prcListMap.get("CompletionDT")));
// 		builder.write("페 이 지  : ");
// 		builder.insertField("PAGE", "");
// 	    builder.write(" / ");
// 	    builder.insertField("NUMPAGES", "");
		
// 	    builder.endRow();	
// 	    builder.endTable().setAllowAutoFit(false);	
	    
// 	 	// 머릿말 : END
// 	 	builder.moveToDocumentEnd();
	  	//==================================================================================================
	  			 	   
		// 표지 하단
		builder.startTable();
// 		builder.getCellFormat().getBorders().setLineWidth(0.0);
		
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getCellFormat().setWidth(800);
		
		builder.getRowFormat().clearFormatting();
		builder.getCellFormat().clearFormatting();
		builder.getParagraphFormat().clearFormatting();
		
		builder.insertCell();
		builder.getFont().setColor(Color.BLACK);
		builder.getFont().setBold(true);
		builder.getFont().setName(defaultFont);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		builder.getFont().setSize(16);
		builder.getFont().setUnderline(0);
		builder.insertHtml("<br>");
		builder.insertHtml("<br>");
		builder.insertHtml("<br>");
		builder.writeln(itemName);
		builder.getFont().setSize(12);
		builder.getFont().setBold(false);
		builder.insertHtml("<br>");
		builder.insertHtml("<br>");
		builder.insertHtml("<br>");
		builder.insertHtml("<br>");
		builder.insertHtml("<br>");
		builder.writeln(StringUtil.checkNullToBlank(prcListMap.get("Identifier")));
		builder.insertHtml("<br>");
		builder.insertHtml("<br>");
		builder.insertHtml("<br>");
		builder.endRow();
		
		// Make the header row.
		builder.insertCell();
		builder.getRowFormat().setHeight(33.0);

		// Some special features for the header row.
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setSize(10);
		builder.getFont().setUnderline(0);
		builder.getFont().setBold(false);
		builder.getFont().setColor(Color.BLACK);
		builder.getFont().setName(defaultFont);

		builder.getCellFormat().setWidth(200);
		builder.write("개정번호"); //개정번호

		builder.insertCell();
		builder.getCellFormat().setWidth(200);
		builder.write(StringUtil.checkNullToBlank(prcListMap.get("Version")));

		builder.insertCell();
		builder.getCellFormat().setWidth(200);
		builder.write("작   성"); //작 성

		builder.insertCell();
		builder.getCellFormat().setWidth(200);
		builder.write("");

		builder.endRow();

		builder.insertCell();
		builder.getCellFormat().setWidth(200);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		builder.write("개정일자"); //개정일자				
		builder.insertCell();
		builder.getCellFormat().setWidth(200);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		builder.write(StringUtil.checkNullToBlank(prcListMap.get("CompletionDT")));
		builder.insertCell();
		builder.getCellFormat().setWidth(200);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		builder.write("검   토");
		builder.insertCell();
		builder.getCellFormat().setWidth(200);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		builder.write("");
		builder.endRow();

		builder.insertCell();
		builder.getCellFormat().setWidth(200);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		builder.write("작성부서");				
		builder.insertCell();
		builder.getCellFormat().setWidth(200);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		builder.write(StringUtil.checkNullToBlank(prcListMap.get("OwnerTeamName")));
		builder.insertCell();
		builder.getCellFormat().setWidth(200);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		builder.write("승   인");	
		builder.insertCell();
		builder.getCellFormat().setWidth(200);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		builder.write("");	
		builder.endRow();

		builder.insertCell();
		builder.getCellFormat().setWidth(800);
		builder.getRowFormat().setHeight(55.0);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		builder.insertImage(imageFileName, 160, 30);//현대 로고
		builder.endRow();

		builder.endTable().setAllowAutoFit(false);
		///////////////////////////////////////////////////////////////////////////////////////
		// 표지 END
		//==================================================================================================
		builder.insertBreak(BreakType.PAGE_BREAK);
		
		//==================================================================================================
				
		// 개정내역 START		
		builder.getFont().setSize(14);
		builder.getFont().setBold(true);  
		builder.getFont().setName(defaultFont);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		builder.write("개 정 관 리 표");
		builder.getParagraphFormat().setLineSpacing(18.0);
		
		builder.startTable();
		
		// Make the header row.
		builder.insertCell();
		builder.getRowFormat().setHeight(30.0);
		
		builder.getRowFormat().clearFormatting();
		builder.getCellFormat().clearFormatting();
		builder.getParagraphFormat().clearFormatting();

		// Some special features for the header row.
		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
		builder.getFont().setSize(10);
		builder.getFont().setUnderline(0);
		builder.getFont().setBold(false);
		builder.getFont().setColor(Color.BLACK);
		builder.getFont().setName(defaultFont);
	
		builder.getCellFormat().setWidth(76);
		builder.write("개정번호"); //개정번호
		
		builder.insertCell();
		builder.getCellFormat().setWidth(148);
		builder.write("개정일자");
		
		builder.insertCell();
		builder.getCellFormat().setWidth(302);
		builder.write("개 정 내 용"); //작 성
		
		builder.insertCell();
		builder.getCellFormat().setWidth(91);
		builder.write("작 성");
		
		builder.insertCell();
		builder.getCellFormat().setWidth(91);
		builder.write("검 토");
		
		builder.insertCell();
		builder.getCellFormat().setWidth(91);
		builder.write("승 인");
		
		builder.endRow();
					
		for(int x=0; x < cngtList.size(); x++){
			Map cngtInfo = (HashMap) cngtList.get(x);
			
			builder.insertCell();
			builder.getCellFormat().setWidth(76);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(StringUtil.checkNullToBlank(cngtInfo.get("Version"))); //개정번호	
			
			builder.insertCell();
			builder.getCellFormat().setWidth(148);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(StringUtil.checkNullToBlank(cngtInfo.get("CompletionDT"))); //개정일자
			
			builder.insertCell();
			builder.getCellFormat().setWidth(302);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			builder.write(StringUtil.checkNullToBlank(cngtInfo.get("Description"))); //개정내용
			
			builder.insertCell();
			builder.getCellFormat().setWidth(91);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(""); //작성
			
			builder.insertCell();
			builder.getCellFormat().setWidth(91);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(""); //경로
			
			builder.insertCell();
			builder.getCellFormat().setWidth(91);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(""); //승인
			builder.endRow();
		}
		for(int z=0; z < 10 - cngtList.size(); z++){
			
			builder.insertCell();
			builder.getCellFormat().setWidth(76);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(""); //개정번호	
			
			builder.insertCell();
			builder.getCellFormat().setWidth(148);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(""); //개정일자
			
			builder.insertCell();
			builder.getCellFormat().setWidth(302);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(""); //개정내용
			
			builder.insertCell();
			builder.getCellFormat().setWidth(91);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(""); //작성

			builder.insertCell();
			builder.getCellFormat().setWidth(91);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(""); //경로
			

			builder.insertCell();
			builder.getCellFormat().setWidth(91);
			builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			builder.write(""); //승인
			builder.endRow();
		}						
		builder.endTable().setAllowAutoFit(false);
		///////////////////////////////////////////////////////////////////////////////////////
		// 개정내역 END
		builder.insertBreak(BreakType.PAGE_BREAK);
		
		//==================================================================================================
		// 목차 START
		builder.getFont().setSize(14);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		builder.getParagraphFormat().setLineSpacing(18.0);
		builder.writeln("목 차");
		
		builder.getFont().setColor(Color.BLACK);
		builder.getFont().setBold(true);  
		builder.getFont().setName(defaultFont);
		builder.getFont().setSize(10);
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
		builder.writeln("1.0 목적");
		builder.writeln("2.0 적용 범위");
		builder.writeln("3.0 용어 정의");
		builder.writeln("4.0 책임 사항");
		builder.writeln("5.0 일반 사항");
		builder.writeln("6.0 수행 절차");
		builder.writeln("7.0 관련 문서");
		builder.writeln("8.0 첨부");
		
		builder.getParagraphFormat().clearFormatting();
		///////////////////////////////////////////////////////////////////////////////////////
		// 목차 END
		builder.insertBreak(BreakType.PAGE_BREAK);

		builder.getFont().setSize(10);
		builder.getFont().setColor(Color.BLACK);
		builder.getFont().setName(defaultFont);
		
		// AttrList ====================================================================================
		List attrList = (List) itemInfo.get("attrList");
		if(attrList.size()>0){
			for(int j=0; j < attrList.size(); j++){
				Map attrInfoMap = (Map)attrList.get(j);
				String attrTypeCode = StringUtil.checkNullToBlank(attrInfoMap.get("AttrTypeCode"));
				
				if(attrTypeCode.equals("AT00501")){
					builder.getFont().setBold (false);
					
					String plainText = StringUtil.checkNullToBlank(attrInfoMap.get("PlainText")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("/upload", logoPath).replace("<table","<table border=\"1\" style='border-collapse:collapse;'");
// 		 	 			if(plainText.contains("font-family")){
// 		 	 				builder.insertHtml(plainText);
// 		 	 			}else{
		 	 				builder.insertHtml(fontFamilyHtml+plainText+"</span>");
// 		 	 			}
				}
			}
		}
				
		if(i != items.size()-1) builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
		
		if(i == 0){
			fileName = "Report_" + selectedItemName;
			if(outputType.equals("pdf")) fileName += ".pdf";
			if(outputType.equals("doc")) fileName += ".docx";
		} else {
			fileName = "SOP_Report_" + formatter.format(date);
			if(outputType.equals("pdf")) fileName += ".pdf";
			if(outputType.equals("doc")) fileName += ".docx";
		}
	}
	//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		
	HashMap drmInfoMap = new HashMap();
	Map loginInfo = (Map) session.getAttribute("loginInfo");
	
	String userID = StringUtil.checkNull(loginInfo.get("sessionUserId"));
	String userName = StringUtil.checkNull(loginInfo.get("sessionUserNm"));
	String teamID = StringUtil.checkNull(loginInfo.get("sessionTeamId"));
	String teamName = StringUtil.checkNull(loginInfo.get("sessionTeamName"));
	
	drmInfoMap.put("userID", userID);
	drmInfoMap.put("userName", userName);
	drmInfoMap.put("teamID", teamID);
	drmInfoMap.put("teamName", teamName);
	drmInfoMap.put("orgFileName", fileName);
	drmInfoMap.put("downFile", fileName);
	
	// file DRM 적용
	String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
	if(!"".equals(useDRM)){
		drmInfoMap.put("funcType", "report");
		DRMUtil.drmMgt(drmInfoMap); // 암호화 
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
	e.printStackTrace();
	
} finally{
	request.getSession(true).setAttribute("expFlag", "Y");
	response.getOutputStream().flush();
	response.getOutputStream().close();
}

%>

