package xbolt.cmm.framework.util;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.awt.Color;
import java.io.File;

import org.apache.commons.text.StringEscapeUtils;
import org.springframework.ui.ModelMap;

import com.aspose.words.*;
import xbolt.cmm.framework.val.GlobalVal;


/**
 * 공통 서블릿 처리
 * @Class Name : MakeWordReport.java
 * @Description : wordReport 관련 함수
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2017. 05. 10. smartfactory		최초생성
 *
 * @since 2017. 05. 10.
 * @version 1.0
 * @see
 * 
 * Copyright (C) 2013 by SMARTFACTORY All right reserved.
 */
@SuppressWarnings("unused")
public class MakeWordReport {	
	 
	
	public static String exportProcessReport(HashMap commandMap, ModelMap model) {
		String returnValue = "";
		try{
			String LogoImgUrl = "";
			String modelImgPath = GlobalVal.MODELING_DIGM_DIR;
			String logoPath = GlobalVal.FILE_UPLOAD_TINY_DIR;
			String defaultFont = String.valueOf(model.get("defaultFont"));
		 	
			License license = new License();
			license.setLicense(logoPath + "Aspose.Words.lic");
			
			Document doc = new Document();
			DocumentBuilder builder = new DocumentBuilder(doc);	
			
			Map menu = (Map)model.get("menu");
		 	Map setMap = (HashMap)model.get("setMap");
		 	List allTotalList = (List)model.get("allTotalList");
		 	
		 	String onlyMap = String.valueOf(model.get("onlyMap"));
		 	String paperSize = String.valueOf(model.get("paperSize"));
		 	String itemNameOfFileNm = String.valueOf(model.get("ItemNameOfFileNm")).replaceAll("[/\\\\:*?\"<>|]", "_");
		 	
		 	Map e2eModelMap = (Map)model.get("e2eModelMap");
		 	Map e2eItemInfo = (Map)model.get("e2eItemInfo");
		 	Map e2eAttrMap = (Map)model.get("e2eAttrMap");
		 	Map e2eAttrNameMap = (Map)model.get("e2eAttrNameMap");
		 	Map e2eAttrHtmlMap = (Map)model.get("e2eAttrHtmlMap");
		 	
		 	Map piItemInfo = (Map)model.get("piItemInfo");
		 	Map piAttrMap = (Map)model.get("piAttrMap");
		 	Map piAttrNameMap = (Map)model.get("piAttrNameMap");
		 	Map piAttrHtmlMap = (Map)model.get("piAttrHtmlMap");
		 	
		 	List e2eDimResultList = (List)model.get("e2eDimResultList");		 	
		 	List subTreeItemIDList = (List)model.get("subTreeItemIDList");
		 	String selectedItemPath = String.valueOf(model.get("selectedItemPath"));
		 	String reportCode = String.valueOf(model.get("reportCode"));
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
			
			builder.getPageSetup().setPaperSize(PaperSize.A4);
			
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
		    builder.write("Process Asset Library ");
		    
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
//				    if (!e2eModelMap.isEmpty()) {
//				    	builder.writeln("E2E Process report");
//				    }else if(reportCode.equals("RP00031")){
//				    	builder.writeln("PI Task report");
//				    } else {
				    	builder.writeln("Process Definition Report");
//				    }
					builder.endRow();
					
					// 3.선택한 L2 프로세스 정보
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
		    		
		    		// 4.선택한 L2 프로세스 정보 테이블
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
					builder.write(String.valueOf(menu.get("LN00070"))); // 수정일
					
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
					builder.write(StringUtil.checkNullToBlank(titleItemMap.get("Name")));	
					
					builder.insertCell();
				   	builder.getCellFormat().setWidth(200);
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.write("동원 F&B 차세대 ERP 구축");
					
					builder.insertCell();
				   	builder.getCellFormat().setWidth(100);
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.write(StringUtil.checkNullToBlank(titleItemMap.get("CreateDT")));	
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
					    builder.insertHtml("<br>");
					    builder.writeln("\tContent"); // content
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
					   
					    builder.endRow();
					    
					    builder.getFont().setName(defaultFont);
					    builder.getFont().setColor(Color.LIGHT_GRAY);
					    builder.getFont().setSize(11);
						builder.getFont().setUnderline(0);
						builder.getFont().setBold(false);
						
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
			 	 	    builder.getFont().setSize(11);
			 	 		
			 	 		// Make the header row.
			 	 		builder.getRowFormat().clearFormatting();
			 	 		builder.getCellFormat().clearFormatting();
			 	 		builder.getRowFormat().setHeight(150.0);
			 	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경
			 	 		
			 	 	 	// 1.ROW : 개요
			 	 		builder.insertCell();
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth2);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(e2eAttrNameMap.get("AT00003")));  // 개요
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(mergeCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		if ("1".equals(StringUtil.checkNullToBlank(e2eAttrHtmlMap.get("AT00003")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00003")).contains("font-family")){
			 	 				builder.insertHtml(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00003")).replace("/upload", logoPath));
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+StringUtil.checkNullToBlank(e2eAttrMap.get("AT00003")).replace("/upload", logoPath)+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00003"))); // 개요 : 내용
			 	 		}
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
			 	 		if ("1".equals(StringUtil.checkNullToBlank(e2eAttrHtmlMap.get("AT00020")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00020")).contains("font-family")){
			 	 				builder.insertHtml(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00020")));
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+StringUtil.checkNullToBlank(e2eAttrMap.get("AT00020"))+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00020"))); // Main Module : 내용
			 	 		}
			 	 		
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
			 	 		if ("1".equals(StringUtil.checkNullToBlank(e2eAttrHtmlMap.get("AT00072")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00072")).contains("font-family")){
			 	 				builder.insertHtml(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00072")));
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+StringUtil.checkNullToBlank(e2eAttrMap.get("AT00072"))+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00072"))); // 연관 모듈 : 내용
			 	 		}
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
			 	 		if ("1".equals(StringUtil.checkNullToBlank(e2eAttrHtmlMap.get("AT00018")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00018")).contains("font-family")){
			 	 				builder.insertHtml(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00018")));
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+StringUtil.checkNullToBlank(e2eAttrMap.get("AT00018"))+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00018"))); // Due date : 내용
			 	 		}
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
			 	 		if ("1".equals(StringUtil.checkNullToBlank(e2eAttrHtmlMap.get("AT00006")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00006")).contains("font-family")){
			 	 				builder.insertHtml(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00006")).replace("/upload", logoPath));
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+StringUtil.checkNullToBlank(e2eAttrMap.get("AT00006")).replace("/upload", logoPath)+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00006"))); // 비고 : 내용
			 	 		}
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
			 	 		builder.writeln();
					  	
					  	
					  	//==================================================================================================
						//==================================================================================================
					 	//프로세스 맵
					 	builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
				 	 	builder.startTable();
				 	    
				 	 	builder.insertCell();
				 	 	builder.getRowFormat().clearFormatting();
				 		builder.getCellFormat().clearFormatting();
				 		builder.getRowFormat().setHeight(20.0);
				 		builder.getRowFormat().setHeightRule(HeightRule.AUTO);
				 	 	builder.getCellFormat().setWidth(totalCellWidth);
				 	 	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
				 	 	
				 		String imgLang = "_"+StringUtil.checkNull(setMap.get("langCode"));
				 		String imgPath = modelImgPath+e2eModelMap.get("ModelID")+imgLang+"."+GlobalVal.MODELING_DIGM_IMG_TYPE;
				 		int width = Integer.parseInt(String.valueOf(e2eModelMap.get("Width")));
				 		int height = Integer.parseInt(String.valueOf(e2eModelMap.get("Height")));
				 		//System.out.println("프로세스맵 imgPath="+imgPath);
				 		try{
				 			if(!imgPath.equals("")){
					 			builder.insertHtml("<br>");
					 			builder.insertImage(imgPath, RelativeHorizontalPosition.PAGE, 30, RelativeVerticalPosition.PAGE,20,width,height,WrapType.INLINE);
					 			builder.insertHtml("<br>");
				 			}
				 		} catch(Exception ex){}
				 		
				 		builder.endTable().setAllowAutoFit(false);
					}
			 		//==================================================================================================
					// E2E 기본정보 END
				
					// PI 과제기본정보 */
					if(reportCode.equals("RP00031")){ 
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
					   	name = StringUtil.checkNullToBlank(piItemInfo.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
					   	name = name.replace("&#10;", " ");
					   	name = name.replace("&#xa;", "");
					   	name = name.replace("&nbsp;", " ");
					    builder.write("PI 과제 : " + StringUtil.checkNullToBlank(piItemInfo.get("Identifier")) + " "+ name);
					   
					    builder.getFont().setName(defaultFont);
					    builder.getFont().setColor(Color.LIGHT_GRAY);
					    builder.getFont().setSize(11);
					    
					    builder.insertCell();
						builder.getCellFormat().getBorders().setColor(Color.WHITE);
						builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.RIGHT);
						String path = String.valueOf(piItemInfo.get("Path"));
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
					  	// PI과제 기본정보 표시
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
			 	 		builder.write(String.valueOf(piAttrNameMap.get("AT00003")));  // PI 개요
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(mergeCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		if ("1".equals(StringUtil.checkNullToBlank(piAttrHtmlMap.get("AT00003")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(piAttrMap.get("AT00003")).contains("font-family")){
			 	 				builder.insertHtml(StringUtil.checkNullToBlank(piAttrMap.get("AT00003")).replace("/upload", logoPath));
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+StringUtil.checkNullToBlank(piAttrMap.get("AT00003")).replace("/upload", logoPath)+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(piAttrMap.get("AT00003"))); // PI 개요 : 내용
			 	 		}
			 	 		//==================================================================================================	
			 	 		builder.endRow();
			 	 		
			 	 		// 2.ROW : 비고
			 	 		builder.insertCell();
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(piAttrNameMap.get("AT00006")));  // PI 비고
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(mergeCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		if ("1".equals(StringUtil.checkNullToBlank(piAttrHtmlMap.get("AT00006")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(piAttrMap.get("AT00006")).contains("font-family")){
			 	 				builder.insertHtml(StringUtil.checkNullToBlank(piAttrMap.get("AT00006")).replace("/upload", logoPath));
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+StringUtil.checkNullToBlank(piAttrMap.get("AT00006")).replace("/upload", logoPath)+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(piAttrMap.get("AT00006"))); // PI 비고 : 내용
			 	 		}
			 	 		//==================================================================================================	
			 	 		builder.endRow();
			 	 		
			 	 		builder.getRowFormat().clearFormatting();
						builder.getCellFormat().clearFormatting();
						builder.getRowFormat().setHeight(30.0);
			 	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경
			 	 		
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
				 		builder.write(StringUtil.checkNullToBlank(piItemInfo.get("Name"))); // 작성자 : 내용
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(piAttrNameMap.get("AT00022")));  // PI 담당자
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		if ("1".equals(StringUtil.checkNullToBlank(piAttrHtmlMap.get("AT00022")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(piAttrMap.get("AT00022")).contains("font-family")){
			 	 				builder.insertHtml(StringUtil.checkNullToBlank(piAttrMap.get("AT00022")));
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+StringUtil.checkNullToBlank(piAttrMap.get("AT00022"))+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(piAttrMap.get("AT00022"))); // Due date : 내용
			 	 		}
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
				 		builder.write(StringUtil.checkNullToBlank(piItemInfo.get("CreateDT"))); // 생성일 : 내용
			 	 		
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
			 	 		builder.write(StringUtil.checkNullToBlank(piItemInfo.get("LastUpdated"))); // 수정일 : 내용
			 	 		builder.endRow();
			 	 		//==================================================================================================
			 	 				
			 	 		// 5.ROW : 오너조직, Owner
		 	 	 		builder.insertCell();
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(piAttrNameMap.get("AT00033"))); // 오너조직
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		if ("1".equals(StringUtil.checkNullToBlank(piAttrHtmlMap.get("AT00033")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(piAttrMap.get("AT00033")).contains("font-family")){
			 	 				builder.insertHtml(StringUtil.checkNullToBlank(piAttrMap.get("AT00033")));
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+StringUtil.checkNullToBlank(piAttrMap.get("AT00033"))+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(piAttrMap.get("AT00033"))); // 오너조직 : 내용
			 	 		}
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(piAttrNameMap.get("AT00012"))); // 오너
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		if ("1".equals(StringUtil.checkNullToBlank(piAttrHtmlMap.get("AT00012")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(piAttrMap.get("AT00012")).contains("font-family")){
			 	 				builder.insertHtml(StringUtil.checkNullToBlank(piAttrMap.get("AT00012")));
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+StringUtil.checkNullToBlank(piAttrMap.get("AT00012"))+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(piAttrMap.get("AT00012"))); // 오너
			 	 		}
			 	 		builder.endRow();
			 	 		//==================================================================================================
			 	 		
			 	 		builder.endTable().setAllowAutoFit(false);
			 	 		builder.writeln();
					  	
					  	
					}			
				//} 
				// PI 과제기본정보 END */
				//==================================================================================================
				if (totalList.size() > 0) { 
			 	for (int index = 0; totalList.size() > index ; index++) {
			 		
			 		if (totalList.size() != 1) {
			 			builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
			 		}
			 		
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
			 		List roleList = (List)totalMap.get("roleList");
			 		List toCheckList = (List)totalMap.get("toCheckList");
			 		Map attrMap = (Map)totalMap.get("attrMap");
			 		Map attrNameMap = (Map)totalMap.get("attrNameMap");
			 		Map attrHtmlMap = (Map)totalMap.get("attrHtmlMap");
			 		Map modelMap = (Map)totalMap.get("modelMap");
			 		List relItemList = (List)totalMap.get("relItemList");
			 		List relItemClassCodeList = (List)totalMap.get("relItemClassCodeList");
			 		List relItemNameList = (List)totalMap.get("relItemNameList");
		 	 		List relItemID = (List)totalMap.get("relItemID");
		 	 		List relItemAttrbyID = (List)totalMap.get("relItemAttrbyID");
		 	 		Map AttrTypeList = (Map)totalMap.get("AttrTypeList");
			 		Map map = new HashMap();
			 		Map attrRsNameMap = (Map)totalMap.get("attrRsNameMap");
			 		Map attrRsHtmlMap = (Map)totalMap.get("attrRsHtmlMap");
			 		 		
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
					
					builder.getCellFormat().setWidth(30);
					builder.getCellFormat().setVerticalMerge(CellMerge.FIRST);
					//builder.insertCell();
		    		builder.insertImage(imageFileName, 125, 25);

					builder.insertCell();
					builder.getCellFormat().setWidth(80);
					name = StringUtil.checkNullToBlank(rowPrcData.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
			 	   	name = name.replace("&#10;", " ");
			 	   	name = name.replace("&#xa;", "");
			 	    name = name.replace("&nbsp;", " ");
			 	    builder.write("Process definition report"); 
			 	  //  builder.write(rowPrcData.get("Identifier") + " "+ name);  	
					
					builder.endRow();
					
					// Set features for the other rows and cells.
					builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
					builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
					builder.getFont().setSize(10);
					builder.getFont().setUnderline(0);
					builder.getFont().setBold(false);
					
					// Reset height and define a different height rule for table body
					builder.getRowFormat().setHeight(30.0);
					builder.getRowFormat().setHeightRule(HeightRule.AUTO);
					
				    builder.insertCell(); 	
				    builder.getCellFormat().setWidth(30);
					builder.getCellFormat().setVerticalMerge(CellMerge.PREVIOUS);
					
					builder.insertCell();
				   	builder.getCellFormat().setWidth(35);builder.getCellFormat().setVerticalMerge(CellMerge.NONE);
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.write(rowPrcData.get("Identifier") + " "+ name);  
		    		
					builder.insertCell();
				   	builder.getCellFormat().setWidth(45);builder.getCellFormat().setVerticalMerge(CellMerge.NONE);
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
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(attrNameMap.get("AT00003")));  // 개요
			 	 		
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
			 	 		 
						builder.insertCell();	
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth2);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(attrNameMap.get("AT00010")));  // ROLE
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth2);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		
			 	 		String AT00009 = StringUtil.checkNullToBlank(attrMap.get("AT00010")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
			 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00010")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(attrMap.get("AT00010")).contains("font-family")){
			 	 				builder.insertHtml(AT00009);
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+AT00009+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00010"))); // ROLE
			 	 		}
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth2);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(attrNameMap.get("AT00017")));  // 관련조직
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth2);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		
			 	 		String AT00037 = StringUtil.checkNullToBlank(attrMap.get("AT00017")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
			 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00017")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(attrMap.get("AT00017")).contains("font-family")){
			 	 				builder.insertHtml(AT00037);
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+AT00037+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00017"))); // 관련조직 : 내용
			 	 		}
			 	 		//==================================================================================================	
			 	 		builder.endRow();
						
			 	 	
			 	 		// 3.ROW : Input,Output
			 	 		builder.insertCell();
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth2);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(attrNameMap.get("AT00030")));  // AS-IS
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(totalCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		
			 	 		String AT00015 = StringUtil.checkNullToBlank(attrMap.get("AT00030")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
			 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00030")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(attrMap.get("AT00030")).contains("font-family")){
			 	 				builder.insertHtml(AT00015);
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+AT00015+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00030"))); // AS-IS : 내용
			 	 		}
			 	 		builder.endRow();

			 	 		builder.insertCell();
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth2);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(attrNameMap.get("AT00054")));  // TO-BE
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(totalCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		
			 	 		String AT00016 = StringUtil.checkNullToBlank(attrMap.get("AT00054")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
			 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00054")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(attrMap.get("AT00054")).contains("font-family")){
			 	 				builder.insertHtml(AT00016);
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+AT00016+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00054"))); // TO-BE : 내용
			 	 		}
			 	 		//==================================================================================================	
			 	 		builder.endRow();

			 	 		
			 	 		// 4.ROW : Region,Progress
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth2);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(attrNameMap.get("AT00026")));  // Progress
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		
			 	 		String AT00026 = StringUtil.checkNullToBlank(attrMap.get("AT00026")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
			 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00026")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(attrMap.get("AT00026")).contains("font-family")){
			 	 				builder.insertHtml(AT00026);
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+AT00026+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00026"))); // Progress : 내용
			 	 		}
			 	 		//==================================================================================================	
			 	 		builder.endRow();
			 	 		
			 	 	    //5.ROW : 작성자, 수정일
		 	 			builder.insertCell();
		 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth2);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(menu.get("LN00060")));  // 작성자
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getFont().setBold (false);
			 	 		builder.getCellFormat().setWidth(contentCellWidth2);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.write(StringUtil.checkNullToBlank(rowPrcData.get("Name"))); // 작성자 : 내용
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth2);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
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
			 	 		for(int j=0; j<dimResultList.size(); j++){
			 	 			Map dimResultMap = (Map) dimResultList.get(j);
				 	 		
			 	 			builder.insertCell();
				 	 		//==================================================================================================	
				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
				 	 		builder.getCellFormat().setWidth(titleCellWidth2);
				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
				 	 		builder.getFont().setBold (true);
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
			 	 		//builder.writeln();
			 	 		
			 	 		int headerNO = 2;
			 	 		// 2. 선/후행 프로세스
			 	 		if (0 != modelMap.size()) {
			 	 			if (true) {
				 	 			
			 	 				builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
			 	 				builder.getFont().setColor(Color.BLACK);
			 				    builder.getFont().setSize(11);
			 				    builder.getFont().setBold(true);
			 				    builder.getFont().setName(defaultFont);
			 					builder.writeln(headerNO+". " + String.valueOf(menu.get("LN00178"))+"Process");
			 					headerNO++;
			 					
			 			 		if (elementList.size() > 0) {
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
			 						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
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
			 						builder.getCellFormat().setWidth(80);
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
			 							builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 						   	builder.write(StringUtil.checkNullToBlank(cnProcessData.get("RNUM")));	
			 							
			 						   	builder.insertCell();
			 						   	builder.getCellFormat().setWidth(40);
			 							builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 							builder.write(StringUtil.checkNullToBlank(cnProcessData.get("LinkType")));				
			 							builder.insertCell();
			 						   	builder.getCellFormat().setWidth(80);
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
			 			 		}
			 	 				
					 		}
			 	 		}
				 		
						//==================================================================================================
				 		
						if (String.valueOf(model.get("csYN")).equals("on")) {
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
							
							
							for(int j=0; j<elementList.size(); j++){
								data = (HashMap) elementList.get(j);
							    
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
						}
						//==================================================================================================
				 				
						
						//3. 관련항목
						Map cnAttrList = new HashMap();
						List cnAttr = new ArrayList();
						Map AttrInfoList = new HashMap();
						Map ItemAttrInfo = new HashMap();
						if (String.valueOf(model.get("cxnYN")).equals("on")) {
							if(relItemClassCodeList.size() > 0) {
								builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
							}
							for(int i=0; i <relItemClassCodeList.size() ; i++){
								builder.getFont().setColor(Color.DARK_GRAY);
							    builder.getFont().setSize(11);
							    builder.getFont().setBold(true);
							    builder.getFont().setName(defaultFont);
								
								if(relItemClassCodeList.get(i).equals("CL07002")){
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
											builder.getRowFormat().setHeight(30.0);
											builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);	
								 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
								 	 		builder.getCellFormat().setWidth(titleCellWidth);
								 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
								 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
								 	 		builder.getFont().setBold(true);
								 	 		builder.write(String.valueOf(menu.get("LN00106"))); // ID
								 	 		
								 	 		builder.insertCell();
								 	 		builder.getCellFormat().setWidth(contentCellWidth);
								 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
								 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
								 	 		builder.getFont().setBold(false);
									 		builder.write(StringUtil.checkNullToBlank(map.get("Identifier"))); // ID : 내용
								 	 		
											/*
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
											*/
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
											builder.endRow();
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
								 	 		ItemAttrInfo = (Map)AttrInfoList.get("AT00021");
											// 3.ROW - IT 요구사항
											builder.insertCell();
								 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
								 	 		builder.getCellFormat().setWidth(titleCellWidth);
								 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
								 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
								 	 		builder.getFont().setBold (true);
								 	 		builder.write(String.valueOf(AttrTypeList.get("AT00021")));
								 	 		
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
			
								if(relItemClassCodeList.get(i).equals("CL08002")){
									builder.insertHtml("<br>");
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
											builder.getRowFormat().setHeight(30.0);
											builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);	
								 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
								 	 		builder.getCellFormat().setWidth(titleCellWidth);
								 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
								 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
								 	 		builder.getFont().setBold(true);
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
											// 2.ROW - KPI Type
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
								 	 		ItemAttrInfo = (Map)AttrInfoList.get("AT00011");
											// 3.ROW - 개선항목구분
											builder.insertCell();
								 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
								 	 		builder.getCellFormat().setWidth(titleCellWidth);
								 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
								 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
								 	 		builder.getFont().setBold (true);
								 	 		builder.write(String.valueOf(AttrTypeList.get("AT00011")));
								 	 		
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
								 	 	
								 	 		//==================================================================================================	
								 	 		ItemAttrInfo = (Map)AttrInfoList.get("AT00013");
											// 4.ROW - IT System
											builder.insertCell();
								 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
								 	 		builder.getCellFormat().setWidth(titleCellWidth);
								 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
								 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
								 	 		builder.getFont().setBold (true);
								 	 		builder.write(String.valueOf(AttrTypeList.get("AT00013")));
								 	 		
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
						//
						
			 			
				 		
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
				 		if (String.valueOf(model.get("fileYN")).equals("on")) {
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
						if (String.valueOf(model.get("teamYN")).equals("on")) {
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
						
						
						if (true) {
							builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
					 		// 액티비티 리스트 Title
					 		builder.getFont().setColor(Color.DARK_GRAY);
						    builder.getFont().setSize(11);
						    builder.getFont().setBold(true);
						    builder.getFont().setName(defaultFont);
							builder.writeln(headerNO+". " + String.valueOf(menu.get("LN00151")));
							builder.insertHtml("<br>");
							Map rowActData = new HashMap();	
							for(int j=0; j<activityList.size(); j++){
								rowActData = (HashMap) activityList.get(j);
								
								builder.getFont().setColor(new Color(0,112,192));
							    builder.getFont().setSize(11);
							    builder.getFont().setBold(true);
							    builder.getFont().setName(defaultFont);
							    
							    String identifier =  StringUtil.checkNullToBlank(rowActData.get("Identifier"));
							    String itemName = StringUtil.checkNullToBlank(rowActData.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
							    itemName = itemName.replace("&#10;", " ");
								itemName = itemName.replace("&#xa;", "");
								itemName = itemName.replace("&nbsp;", " ");
							    builder.writeln(identifier+" "+itemName); //명칭
							    //builder.insertHtml("<br>"); 20240215
								
							    builder.getFont().setColor(Color.BLACK);
							    
							    if (StringUtil.checkNullToBlank(rowActData.get("AT00008")).length() > 0) {
							    builder.writeln("[GuideLine]");// GuideLine
								builder.getFont().setSize(10);
								builder.getFont().setBold(false);
								String regexDelFontSize = "font-size(.*?);";
								String regexDelFontFamily = "font-family(.*?);";
								String regexDelTableInsert1 = "page-break-before: always;";
								String regexDelTableInsert2 = "mso-break-type: section-break;";
								String ATVITAT00003 = StringUtil.checkNullToBlank(rowActData.get("AT00008")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
								ATVITAT00003 = ATVITAT00003.replaceAll(regexDelTableInsert1, "");
								ATVITAT00003 = ATVITAT00003.replaceAll(regexDelTableInsert2, "");
								if(StringUtil.checkNullToBlank(rowActData.get("AT00008")).contains("font-family")){	
									ATVITAT00003 = ATVITAT00003.replaceAll(regexDelFontSize, "");
									ATVITAT00003 = ATVITAT00003.replaceAll(regexDelFontFamily, "");
									builder.insertHtml(ATVITAT00003,true);
				 	 			}else{
				 	 				builder.insertHtml(fontFamilyHtml+ATVITAT00003+"</span>");
				 	 			}			 	 
								builder.insertHtml("<br>");
							    }
							    
							    if (StringUtil.checkNullToBlank(rowActData.get("AT00037")).length() > 0) {
								builder.getFont().setSize(11);
								builder.getFont().setBold(true);
								builder.writeln("[System Type]");
								builder.getFont().setSize(10);
								builder.getFont().setBold(false);
								builder.writeln(StringUtil.checkNullToBlank(rowActData.get("AT00037"))); // SystemType
								//builder.insertHtml("<br>");20240215
							    }
							    
							    if (StringUtil.checkNullToBlank(rowActData.get("AT00013")).length() > 0) {
								builder.getFont().setSize(11);
								builder.getFont().setBold(true);
								builder.writeln("[Application/Module]");
								builder.getFont().setSize(10);
								builder.getFont().setBold(false);
								builder.writeln(StringUtil.checkNullToBlank(rowActData.get("AT00013"))); // Application/Module
								//builder.insertHtml("<br>");20240215
							    }
							    
							    if (StringUtil.checkNullToBlank(rowActData.get("AT00014")).length() > 0) {
								builder.getFont().setSize(11);
								builder.getFont().setBold(true);
								builder.writeln( "[화면코드]");
								builder.getFont().setSize(10);
								builder.getFont().setBold(false);
								builder.writeln(StringUtil.checkNullToBlank(rowActData.get("AT00014"))); // 화면코드
								//builder.insertHtml("<br>");20240215
							    }
							    
							    if (StringUtil.checkNullToBlank(rowActData.get("AT00029")).length() > 0) {
								builder.getFont().setSize(11);
								builder.getFont().setBold(true);
								builder.writeln( "[Check Point]");
								builder.getFont().setSize(10);
								builder.getFont().setBold(false);
								builder.writeln(StringUtil.checkNullToBlank(rowActData.get("AT00029"))); // check point
								//builder.insertHtml("<br>");20240215
							    }
							    
							    if (StringUtil.checkNullToBlank(rowActData.get("AT00053")).length() > 0) {
								builder.getFont().setSize(11);
								builder.getFont().setBold(true);
								builder.writeln( "[PI 과제번호]");
								builder.getFont().setSize(10);
								builder.getFont().setBold(false);
								builder.writeln(StringUtil.checkNullToBlank(rowActData.get("AT00053"))); // 과제번호
								//builder.insertHtml("<br>");20240215
							    }
							    
							    if (StringUtil.checkNullToBlank(rowActData.get("AT00010")).length() > 0) {
								builder.getFont().setSize(11);
								builder.getFont().setBold(true);
								builder.writeln("[Role]"); // 담당
								builder.getFont().setSize(10);
								builder.getFont().setBold(false);
								builder.writeln(StringUtil.checkNullToBlank(rowActData.get("AT00010"))); // 담당
								builder.insertHtml("<br>");
							    }
								
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
			
			String extLangCode = StringUtil.checkNull(commandMap.get("extLangCode"));
			
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));			
			String identifier = StringUtil.checkNull(commandMap.get("identifier"));
			//String filePath = "C://TEMP//" ;
			String filePath = StringUtil.checkNull(commandMap.get("filePath"));
			if(filePath.equals("") || filePath == null){
				filePath = GlobalVal.FILE_UPLOAD_ITEM_DIR + "FLTP001/";
			}
			File dirFile = new File(filePath); if(!dirFile.exists()){dirFile.mkdirs();} 
		    String fileName = identifier+"."+itemNameOfFileNm+"(Process)"+"_"+extLangCode+".docx";
		   // String downFile = FileUtil.FILE_EXPORT_DIR + fileName;	
		    String downFile = filePath + fileName;	
			doc.save(downFile);
			
			// file DRM 적용			
			String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
			String useDownDRM = StringUtil.checkNull(GlobalVal.DRM_DOWN_USE);
			if(!"".equals(useDRM) && !"N".equals(useDownDRM)){
				HashMap drmInfoMap = new HashMap();			
				String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
				String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
				String teamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
				String teamName = StringUtil.checkNull(commandMap.get("sessionTeamName"));
				
				drmInfoMap.put("userID", userID);
				drmInfoMap.put("userName", userName);
				drmInfoMap.put("teamID", teamID);
				drmInfoMap.put("teamName", teamName);
				drmInfoMap.put("orgFileName", fileName);
				drmInfoMap.put("downFile", downFile);
				drmInfoMap.put("filePath", filePath);			
				drmInfoMap.put("funcType", "report");
				returnValue = DRMUtil.drmMgt(drmInfoMap); // 암호화 
			}
			
			returnValue = "success";
			
		} catch(Exception e){
			System.out.println(e.toString());
		}	
		return returnValue;
	}
	
	public static String zharim_exportProcessReport(HashMap commandMap, ModelMap model) {
		String returnValue = "";
		try{
			String LogoImgUrl = "";
			String modelImgPath = GlobalVal.MODELING_DIGM_DIR;
			String logoPath = GlobalVal.FILE_UPLOAD_TINY_DIR;
			String defaultFont = String.valueOf(model.get("defaultFont"));
		 	
			License license = new License();
			license.setLicense(logoPath + "Aspose.Words.lic");
			
			Document doc = new Document();
			DocumentBuilder builder = new DocumentBuilder(doc);	
			
			Map menu = (Map)model.get("menu");
		 	Map setMap = (HashMap)model.get("setMap");
		 	List allTotalList = (List)model.get("allTotalList");
		 	
		 	String onlyMap = String.valueOf(model.get("onlyMap"));
		 	String paperSize = String.valueOf(model.get("paperSize"));
		 	String itemNameOfFileNm = String.valueOf(model.get("ItemNameOfFileNm")).replaceAll("[/\\\\:*?\"<>|]", "_");
		 	
		 	Map e2eModelMap = (Map)model.get("e2eModelMap");
		 	Map e2eItemInfo = (Map)model.get("e2eItemInfo");
		 	Map e2eAttrMap = (Map)model.get("e2eAttrMap");
		 	Map e2eAttrNameMap = (Map)model.get("e2eAttrNameMap");
		 	Map e2eAttrHtmlMap = (Map)model.get("e2eAttrHtmlMap");
		 	
		 	Map piItemInfo = (Map)model.get("piItemInfo");
		 	Map piAttrMap = (Map)model.get("piAttrMap");
		 	Map piAttrNameMap = (Map)model.get("piAttrNameMap");
		 	Map piAttrHtmlMap = (Map)model.get("piAttrHtmlMap");
		 	
		 	List e2eDimResultList = (List)model.get("e2eDimResultList");		 	
		 	List subTreeItemIDList = (List)model.get("subTreeItemIDList");
		 	String selectedItemPath = String.valueOf(model.get("selectedItemPath"));
		 	String reportCode = String.valueOf(model.get("reportCode"));
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
			
			builder.getPageSetup().setPaperSize(PaperSize.A4);
			
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
		    String imageFileName = logoPath + "logo_HARIM.png";
		    String imageFileName2 = logoPath + "logo_color.png";
		    //builder.insertImage(imageFileName2, 125, 25);
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
		    builder.write("Process Asset Library ");
		    
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
//				    if (!e2eModelMap.isEmpty()) {
//				    	builder.writeln("E2E Process report");
//				    }else if(reportCode.equals("RP00031")){
//				    	builder.writeln("PI Task report");
//				    } else {
				    	builder.writeln("Process Definition Report");
//				    }
					builder.endRow();
					
					// 3.선택한 L2 프로세스 정보
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
		    		
		    		// 4.선택한 L2 프로세스 정보 테이블
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
					builder.write(String.valueOf(menu.get("LN00070"))); // 수정일
					
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
					builder.write(StringUtil.checkNullToBlank(titleItemMap.get("Name")));	
					
					builder.insertCell();
				   	builder.getCellFormat().setWidth(200);
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.write("하림 One ERP 1단계 구축");
					
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
				    builder.insertBreak(BreakType.PAGE_BREAK);
		    		if (subTreeItemIDList.size() > 0) { 
		    			// content START	
						builder.getFont().setColor(Color.DARK_GRAY);
					    builder.getFont().setSize(14);
					    builder.getFont().setBold(true);
					    builder.getFont().setName(defaultFont);
					    builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					    builder.insertHtml("<br>");
					    builder.insertHtml("<br>");
					    builder.writeln("\tContent"); // content
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
					   
					    builder.endRow();
					    
					    builder.getFont().setName(defaultFont);
					    builder.getFont().setColor(Color.LIGHT_GRAY);
					    builder.getFont().setSize(11);
						builder.getFont().setUnderline(0);
						builder.getFont().setBold(false);
						
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
			 	 	    builder.getFont().setSize(11);
			 	 		
			 	 		// Make the header row.
			 	 		builder.getRowFormat().clearFormatting();
			 	 		builder.getCellFormat().clearFormatting();
			 	 		builder.getRowFormat().setHeight(150.0);
			 	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경
			 	 		
			 	 	 	// 1.ROW : 개요
			 	 		builder.insertCell();
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth2);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(e2eAttrNameMap.get("AT00003")));  // 개요
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(mergeCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		if ("1".equals(StringUtil.checkNullToBlank(e2eAttrHtmlMap.get("AT00003")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00003")).contains("font-family")){
			 	 				builder.insertHtml(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00003")).replace("/upload", logoPath));
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+StringUtil.checkNullToBlank(e2eAttrMap.get("AT00003")).replace("/upload", logoPath)+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00003"))); // 개요 : 내용
			 	 		}
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
			 	 		if ("1".equals(StringUtil.checkNullToBlank(e2eAttrHtmlMap.get("AT00020")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00020")).contains("font-family")){
			 	 				builder.insertHtml(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00020")));
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+StringUtil.checkNullToBlank(e2eAttrMap.get("AT00020"))+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00020"))); // Main Module : 내용
			 	 		}
			 	 		
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
			 	 		if ("1".equals(StringUtil.checkNullToBlank(e2eAttrHtmlMap.get("AT00072")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00072")).contains("font-family")){
			 	 				builder.insertHtml(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00072")));
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+StringUtil.checkNullToBlank(e2eAttrMap.get("AT00072"))+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00072"))); // 연관 모듈 : 내용
			 	 		}
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
			 	 		if ("1".equals(StringUtil.checkNullToBlank(e2eAttrHtmlMap.get("AT00018")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00018")).contains("font-family")){
			 	 				builder.insertHtml(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00018")));
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+StringUtil.checkNullToBlank(e2eAttrMap.get("AT00018"))+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00018"))); // Due date : 내용
			 	 		}
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
			 	 		if ("1".equals(StringUtil.checkNullToBlank(e2eAttrHtmlMap.get("AT00006")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00006")).contains("font-family")){
			 	 				builder.insertHtml(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00006")).replace("/upload", logoPath));
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+StringUtil.checkNullToBlank(e2eAttrMap.get("AT00006")).replace("/upload", logoPath)+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(e2eAttrMap.get("AT00006"))); // 비고 : 내용
			 	 		}
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
			 	 		builder.writeln();
					  	
					  	
					  	//==================================================================================================
						//==================================================================================================
					 	//프로세스 맵
					 	builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
				 	 	builder.startTable();
				 	    
				 	 	builder.insertCell();
				 	 	builder.getRowFormat().clearFormatting();
				 		builder.getCellFormat().clearFormatting();
				 		builder.getRowFormat().setHeight(20.0);
				 		builder.getRowFormat().setHeightRule(HeightRule.AUTO);
				 	 	builder.getCellFormat().setWidth(totalCellWidth);
				 	 	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
				 	 	
				 		String imgLang = "_"+StringUtil.checkNull(setMap.get("langCode"));
				 		String imgPath = modelImgPath+e2eModelMap.get("ModelID")+imgLang+"."+GlobalVal.MODELING_DIGM_IMG_TYPE;
				 		int width = Integer.parseInt(String.valueOf(e2eModelMap.get("Width")));
				 		int height = Integer.parseInt(String.valueOf(e2eModelMap.get("Height")));
				 		//System.out.println("프로세스맵 imgPath="+imgPath);
				 		try{
				 			if(!imgPath.equals("")){
					 			builder.insertHtml("<br>");
					 			builder.insertImage(imgPath, RelativeHorizontalPosition.PAGE, 30, RelativeVerticalPosition.PAGE,20,width,height,WrapType.INLINE);
					 			builder.insertHtml("<br>");
				 			}
				 		} catch(Exception ex){}
				 		
				 		builder.endTable().setAllowAutoFit(false);
					}
			 		//==================================================================================================
					// E2E 기본정보 END
				
					// PI 과제기본정보 */
					if(reportCode.equals("RP00031")){ 
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
					   	name = StringUtil.checkNullToBlank(piItemInfo.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
					   	name = name.replace("&#10;", " ");
					   	name = name.replace("&#xa;", "");
					   	name = name.replace("&nbsp;", " ");
					    builder.write("PI 과제 : " + StringUtil.checkNullToBlank(piItemInfo.get("Identifier")) + " "+ name);
					   
					    builder.getFont().setName(defaultFont);
					    builder.getFont().setColor(Color.LIGHT_GRAY);
					    builder.getFont().setSize(11);
					    
					    builder.insertCell();
						builder.getCellFormat().getBorders().setColor(Color.WHITE);
						builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
						builder.getParagraphFormat().setAlignment(ParagraphAlignment.RIGHT);
						String path = String.valueOf(piItemInfo.get("Path"));
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
					  	// PI과제 기본정보 표시
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
			 	 		builder.write(String.valueOf(piAttrNameMap.get("AT00003")));  // PI 개요
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(mergeCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		if ("1".equals(StringUtil.checkNullToBlank(piAttrHtmlMap.get("AT00003")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(piAttrMap.get("AT00003")).contains("font-family")){
			 	 				builder.insertHtml(StringUtil.checkNullToBlank(piAttrMap.get("AT00003")).replace("/upload", logoPath));
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+StringUtil.checkNullToBlank(piAttrMap.get("AT00003")).replace("/upload", logoPath)+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(piAttrMap.get("AT00003"))); // PI 개요 : 내용
			 	 		}
			 	 		//==================================================================================================	
			 	 		builder.endRow();
			 	 		
			 	 		// 2.ROW : 비고
			 	 		builder.insertCell();
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(piAttrNameMap.get("AT00006")));  // PI 비고
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(mergeCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		if ("1".equals(StringUtil.checkNullToBlank(piAttrHtmlMap.get("AT00006")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(piAttrMap.get("AT00006")).contains("font-family")){
			 	 				builder.insertHtml(StringUtil.checkNullToBlank(piAttrMap.get("AT00006")).replace("/upload", logoPath));
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+StringUtil.checkNullToBlank(piAttrMap.get("AT00006")).replace("/upload", logoPath)+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(piAttrMap.get("AT00006"))); // PI 비고 : 내용
			 	 		}
			 	 		//==================================================================================================	
			 	 		builder.endRow();
			 	 		
			 	 		builder.getRowFormat().clearFormatting();
						builder.getCellFormat().clearFormatting();
						builder.getRowFormat().setHeight(30.0);
			 	 		builder.getRowFormat().setHeightRule(HeightRule.AUTO); // TODO:높이 내용에 맞게 변경
			 	 		
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
				 		builder.write(StringUtil.checkNullToBlank(piItemInfo.get("Name"))); // 작성자 : 내용
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(piAttrNameMap.get("AT00022")));  // PI 담당자
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		if ("1".equals(StringUtil.checkNullToBlank(piAttrHtmlMap.get("AT00022")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(piAttrMap.get("AT00022")).contains("font-family")){
			 	 				builder.insertHtml(StringUtil.checkNullToBlank(piAttrMap.get("AT00022")));
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+StringUtil.checkNullToBlank(piAttrMap.get("AT00022"))+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(piAttrMap.get("AT00022"))); // Due date : 내용
			 	 		}
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
				 		builder.write(StringUtil.checkNullToBlank(piItemInfo.get("CreateDT"))); // 생성일 : 내용
			 	 		
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
			 	 		builder.write(StringUtil.checkNullToBlank(piItemInfo.get("LastUpdated"))); // 수정일 : 내용
			 	 		builder.endRow();
			 	 		//==================================================================================================
			 	 				
			 	 		// 5.ROW : 오너조직, Owner
		 	 	 		builder.insertCell();
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(piAttrNameMap.get("AT00033"))); // 오너조직
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		if ("1".equals(StringUtil.checkNullToBlank(piAttrHtmlMap.get("AT00033")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(piAttrMap.get("AT00033")).contains("font-family")){
			 	 				builder.insertHtml(StringUtil.checkNullToBlank(piAttrMap.get("AT00033")));
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+StringUtil.checkNullToBlank(piAttrMap.get("AT00033"))+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(piAttrMap.get("AT00033"))); // 오너조직 : 내용
			 	 		}
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(piAttrNameMap.get("AT00012"))); // 오너
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		if ("1".equals(StringUtil.checkNullToBlank(piAttrHtmlMap.get("AT00012")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(piAttrMap.get("AT00012")).contains("font-family")){
			 	 				builder.insertHtml(StringUtil.checkNullToBlank(piAttrMap.get("AT00012")));
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+StringUtil.checkNullToBlank(piAttrMap.get("AT00012"))+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(piAttrMap.get("AT00012"))); // 오너
			 	 		}
			 	 		builder.endRow();
			 	 		//==================================================================================================
			 	 		
			 	 		builder.endTable().setAllowAutoFit(false);
			 	 		builder.writeln();
					  	
					  	
					}			
				//} 
				// PI 과제기본정보 END */
				//==================================================================================================
				if (totalList.size() > 0) { 
			 	for (int index = 0; totalList.size() > index ; index++) {
			 		
			 		if (totalList.size() != 1) {
			 			builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
			 		}
			 		
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
			 		List roleList = (List)totalMap.get("roleList");
			 		List toCheckList = (List)totalMap.get("toCheckList");
			 		Map attrMap = (Map)totalMap.get("attrMap");
			 		Map attrNameMap = (Map)totalMap.get("attrNameMap");
			 		Map attrHtmlMap = (Map)totalMap.get("attrHtmlMap");
			 		Map modelMap = (Map)totalMap.get("modelMap");
			 		List relItemList = (List)totalMap.get("relItemList");
			 		List relItemClassCodeList = (List)totalMap.get("relItemClassCodeList");
			 		List relItemNameList = (List)totalMap.get("relItemNameList");
		 	 		List relItemID = (List)totalMap.get("relItemID");
		 	 		List relItemAttrbyID = (List)totalMap.get("relItemAttrbyID");
		 	 		Map AttrTypeList = (Map)totalMap.get("AttrTypeList");
			 		Map map = new HashMap();
			 		Map attrRsNameMap = (Map)totalMap.get("attrRsNameMap");
			 		Map attrRsHtmlMap = (Map)totalMap.get("attrRsHtmlMap");
			 		 		
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
					
					builder.getCellFormat().setWidth(30);
					builder.getCellFormat().setVerticalMerge(CellMerge.FIRST);
					//builder.insertCell();
		    		builder.insertImage(imageFileName2, 34, 25);
		    		builder.insertImage(imageFileName, 125, 25);

					builder.insertCell();
					builder.getCellFormat().setWidth(80);
					name = StringUtil.checkNullToBlank(rowPrcData.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
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
				    builder.getCellFormat().setWidth(30);
					builder.getCellFormat().setVerticalMerge(CellMerge.PREVIOUS);
					
					builder.insertCell();
				   	builder.getCellFormat().setWidth(35);builder.getCellFormat().setVerticalMerge(CellMerge.NONE);
					builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
					builder.write(rowPrcData.get("Identifier") + " "+ name);  
		    		
					builder.insertCell();
				   	builder.getCellFormat().setWidth(45);builder.getCellFormat().setVerticalMerge(CellMerge.NONE);
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
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(attrNameMap.get("AT00003")));  // 개요
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(totalCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		
			 	 		String AT00003 = StringUtil.checkNullToBlank(attrMap.get("AT00003")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath).replace("&amp;", "&");
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
			 	 		
			 	 		// 2.ROW : 담당PI, 담당 컨설턴트	 
						builder.insertCell();	
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth2);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(attrNameMap.get("AT00022")));  // 담당PI
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth2);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		
			 	 		String AT00022 = StringUtil.checkNullToBlank(attrMap.get("AT00022")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
			 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00022")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(attrMap.get("AT00022")).contains("font-family")){
			 	 				builder.insertHtml(AT00022);
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+AT00022+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00022"))); // 담당PI
			 	 		}
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth2);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(attrNameMap.get("AT00025")));  // 담당 컨설턴트
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth2);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		
			 	 		String AT00025 = StringUtil.checkNullToBlank(attrMap.get("AT00025")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
			 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00025")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(attrMap.get("AT00025")).contains("font-family")){
			 	 				builder.insertHtml(AT00025);
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+AT00025+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00025"))); // 담당 컨설턴트
			 	 		}
			 	 		//==================================================================================================	
			 	 		builder.endRow();
						
			 	 		// 3.ROW : 비고/이슈, Progress
			 	 		builder.insertCell();	
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth2);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(attrNameMap.get("AT00006")));  // 비고/이슈
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth2);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		
			 	 		String AT00006 = StringUtil.checkNullToBlank(attrMap.get("AT00006")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
			 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00006")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(attrMap.get("AT00006")).contains("font-family")){
			 	 				builder.insertHtml(AT00006);
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+AT00006+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00006"))); // 비고/이슈
			 	 		}
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth2);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(attrNameMap.get("AT00026")));  // Progress
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(contentCellWidth2);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		
			 	 		String AT00026 = StringUtil.checkNullToBlank(attrMap.get("AT00026")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
			 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("AT00026")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(attrMap.get("AT00026")).contains("font-family")){
			 	 				builder.insertHtml(AT00026);
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+AT00026+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("AT00026"))); // Progress
			 	 		}
			 	 		//==================================================================================================	
			 	 		builder.endRow();
			 	 		
			 	 		
			 	 		// 4.ROW : Business Type
			 	 		builder.insertCell();
			 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth2);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(attrNameMap.get("ZAT0011")));  // Business Type
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(totalCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		
			 	 		String ZAT0011 = StringUtil.checkNullToBlank(attrMap.get("ZAT0011")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
			 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("ZAT0011")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(attrMap.get("ZAT0011")).contains("font-family")){
			 	 				builder.insertHtml(ZAT0011);
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+ZAT0011+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0011"))); // Business Type
			 	 		}
			 	 		builder.endRow();
			 	 		// 5.ROW : Division
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth2);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(attrNameMap.get("ZAT0012")));  // Division
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().setWidth(totalCellWidth);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		
			 	 		String ZAT0012 = StringUtil.checkNullToBlank(attrMap.get("ZAT0012")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
			 	 		if ("1".equals(StringUtil.checkNullToBlank(attrHtmlMap.get("ZAT0012")))) { // type이 HTML인 경우
			 	 			if(StringUtil.checkNullToBlank(attrMap.get("ZAT0012")).contains("font-family")){
			 	 				builder.insertHtml(ZAT0012);
			 	 			}else{
			 	 				builder.insertHtml(fontFamilyHtml+ZAT0012+"</span>");
			 	 			}
			 	 		} else {
			 	 			builder.getFont().setBold(false);
			 	 			builder.write(StringUtil.checkNullToBlank(attrMap.get("ZAT0012"))); // Division
			 	 		}
			 	 		//==================================================================================================	
			 	 		builder.endRow();
		 
			 	 		
			 	 	    //6.ROW : 작성자, 수정일
		 	 			builder.insertCell();
		 	 		//==================================================================================================	
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth2);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
			 	 		builder.write(String.valueOf(menu.get("LN00060")));  // 작성자
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getFont().setBold (false);
			 	 		builder.getCellFormat().setWidth(contentCellWidth2);
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.write(StringUtil.checkNullToBlank(rowPrcData.get("Name"))); // 작성자 : 내용
			 	 		
			 	 		builder.insertCell();
			 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			 	 		builder.getCellFormat().setWidth(titleCellWidth2);
			 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
			 	 		builder.getFont().setBold (true);
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
//			 	 		for(int j=0; j<dimResultList.size(); j++){
//			 	 			Map dimResultMap = (Map) dimResultList.get(j);
//				 	 		
//			 	 			builder.insertCell();
//				 	 		//==================================================================================================	
//				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
//				 	 		builder.getCellFormat().setWidth(titleCellWidth2);
//				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
//				 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
//				 	 		builder.getFont().setBold (true);
//				 	 		builder.write(String.valueOf(dimResultMap.get("dimTypeName")));
//				 	 		
//				 	 		builder.insertCell();
//				 	 		builder.getCellFormat().setWidth(totalCellWidth);
//				 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
//				 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
//				 	 		builder.getFont().setBold(false);
//			 	 			builder.write(StringUtil.checkNullToBlank(dimResultMap.get("dimValueNames")));
//				 	 		//==================================================================================================	
//			 	 			builder.endRow();
//			 	 		}
			 	 		
			 	 		builder.endTable().setAllowAutoFit(false);
			 	 		//builder.writeln();
			 	 		
			 	 		int headerNO = 2;
			 	 		// 2. 선/후행 프로세스
			 	 		if (0 != modelMap.size()) {
			 	 			if (true) {
				 	 			
			 	 				builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
			 	 				builder.getFont().setColor(Color.BLACK);
			 				    builder.getFont().setSize(11);
			 				    builder.getFont().setBold(true);
			 				    builder.getFont().setName(defaultFont);
			 					builder.writeln(headerNO+". " + String.valueOf(menu.get("LN00178"))+"Process");
			 					headerNO++;
			 					
			 			 		if (elementList.size() > 0) {
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
			 						builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
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
			 						builder.getCellFormat().setWidth(80);
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
			 							String processInfo = StringUtil.checkNullToBlank(cnProcessData.get("Description")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
			 							processInfo = processInfo.replace("&#10;", " ");
			 							processInfo = processInfo.replace("&#xa;", "");
			 							processInfo = processInfo.replace("&nbsp;", " ");
			 							builder.getCellFormat().setWidth(30);
			 							builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
			 						   	builder.write(StringUtil.checkNullToBlank(cnProcessData.get("RNUM")));	
			 							
			 						   	builder.insertCell();
			 						   	builder.getCellFormat().setWidth(40);
			 							builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
			 							builder.write(StringUtil.checkNullToBlank(cnProcessData.get("LinkType")));				
			 							builder.insertCell();
			 						   	builder.getCellFormat().setWidth(80);
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
			 			 		}
			 	 				
					 		}
			 	 		}
				 		
						//==================================================================================================
				 		
						if (String.valueOf(model.get("csYN")).equals("on")) {
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
							
							
							for(int j=0; j<elementList.size(); j++){
								data = (HashMap) elementList.get(j);
							    
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
						}
						//==================================================================================================
				 				
						
						//3. 관련항목
						Map cnAttrList = new HashMap();
						List cnAttr = new ArrayList();
						Map AttrInfoList = new HashMap();
						Map ItemAttrInfo = new HashMap();
						if (String.valueOf(model.get("cxnYN")).equals("on")) {
							if(relItemClassCodeList.size() > 0) {
								builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
							}
							for(int i=0; i <relItemClassCodeList.size() ; i++){
								builder.getFont().setColor(Color.DARK_GRAY);
							    builder.getFont().setSize(11);
							    builder.getFont().setBold(true);
							    builder.getFont().setName(defaultFont);
								
								if(relItemClassCodeList.get(i).equals("CL07002")){
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
											builder.getRowFormat().setHeight(30.0);
											builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);	
								 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
								 	 		builder.getCellFormat().setWidth(titleCellWidth);
								 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
								 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
								 	 		builder.getFont().setBold(true);
								 	 		builder.write(String.valueOf(menu.get("LN00106"))); // ID
								 	 		
								 	 		builder.insertCell();
								 	 		builder.getCellFormat().setWidth(contentCellWidth);
								 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
								 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
								 	 		builder.getFont().setBold(false);
									 		builder.write(StringUtil.checkNullToBlank(map.get("Identifier"))); // ID : 내용
								 	 		
											/*
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
											*/
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
											builder.endRow();
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
								 	 		ItemAttrInfo = (Map)AttrInfoList.get("AT00021");
											// 3.ROW - IT 요구사항
											builder.insertCell();
								 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
								 	 		builder.getCellFormat().setWidth(titleCellWidth);
								 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
								 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
								 	 		builder.getFont().setBold (true);
								 	 		builder.write(String.valueOf(AttrTypeList.get("AT00021")));
								 	 		
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
			
								if(relItemClassCodeList.get(i).equals("CL08002")){
									builder.insertHtml("<br>");
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
											builder.getRowFormat().setHeight(30.0);
											builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);	
								 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
								 	 		builder.getCellFormat().setWidth(titleCellWidth);
								 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
								 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
								 	 		builder.getFont().setBold(true);
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
											// 2.ROW - KPI Type
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
								 	 		ItemAttrInfo = (Map)AttrInfoList.get("AT00011");
											// 3.ROW - 개선항목구분
											builder.insertCell();
								 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
								 	 		builder.getCellFormat().setWidth(titleCellWidth);
								 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
								 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
								 	 		builder.getFont().setBold (true);
								 	 		builder.write(String.valueOf(AttrTypeList.get("AT00011")));
								 	 		
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
								 	 	
								 	 		//==================================================================================================	
								 	 		ItemAttrInfo = (Map)AttrInfoList.get("AT00013");
											// 4.ROW - IT System
											builder.insertCell();
								 	 		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
								 	 		builder.getCellFormat().setWidth(titleCellWidth);
								 	 		builder.getParagraphFormat().setAlignment(ParagraphAlignment.LEFT);
								 	 		builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
								 	 		builder.getFont().setBold (true);
								 	 		builder.write(String.valueOf(AttrTypeList.get("AT00013")));
								 	 		
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
						//
						
			 			
				 		
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
				 		if (String.valueOf(model.get("fileYN")).equals("on")) {
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
						if (String.valueOf(model.get("teamYN")).equals("on")) {
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
						
						
						if (true) {
							builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
					 		// 액티비티 리스트 Title
					 		builder.getFont().setColor(Color.DARK_GRAY);
						    builder.getFont().setSize(11);
						    builder.getFont().setBold(true);
						    builder.getFont().setName(defaultFont);
							builder.writeln(headerNO+". " + String.valueOf(menu.get("LN00151")));
							builder.insertHtml("<br>");
							Map rowActData = new HashMap();	
							for(int j=0; j<activityList.size(); j++){
								rowActData = (HashMap) activityList.get(j);
								
								builder.getFont().setColor(new Color(0,112,192));
							    builder.getFont().setSize(11);
							    builder.getFont().setBold(true);
							    builder.getFont().setName(defaultFont);
							    
							    String identifier =  StringUtil.checkNullToBlank(rowActData.get("Identifier"));
							    String itemName = StringUtil.checkNullToBlank(rowActData.get("ItemName")).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
							    itemName = itemName.replace("&#10;", " ");
								itemName = itemName.replace("&#xa;", "");
								itemName = itemName.replace("&nbsp;", " ");
							    builder.writeln(identifier+" "+itemName); //명칭
							    builder.insertHtml("<br>");
								
							    builder.getFont().setColor(Color.BLACK);
							    builder.writeln("[개요]");
								builder.getFont().setSize(10);
								builder.getFont().setBold(false);
								String regexDelFontSize = "font-size(.*?);";
								String regexDelFontFamily = "font-family(.*?);";
								String regexDelTableInsert1 = "page-break-before: always;";
								String regexDelTableInsert2 = "mso-break-type: section-break;";
								String ATVITAT00003 = StringUtil.checkNullToBlank(rowActData.get("AT00003")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"").replace("upload/", logoPath);
								ATVITAT00003 = ATVITAT00003.replaceAll(regexDelTableInsert1, "");
								ATVITAT00003 = ATVITAT00003.replaceAll(regexDelTableInsert2, "");
								if(StringUtil.checkNullToBlank(rowActData.get("AT00003")).contains("font-family")){	
									ATVITAT00003 = ATVITAT00003.replaceAll(regexDelFontSize, "");
									ATVITAT00003 = ATVITAT00003.replaceAll(regexDelFontFamily, "");
									builder.insertHtml(ATVITAT00003,true);
				 	 			}else{
				 	 				builder.insertHtml(fontFamilyHtml+ATVITAT00003+"</span>");
				 	 			}			 	 
								builder.insertHtml("<br>");
								
								builder.getFont().setSize(11);
								builder.getFont().setBold(true);
								builder.writeln("[System Type]");
								builder.getFont().setSize(10);
								builder.getFont().setBold(false);
								builder.writeln(StringUtil.checkNullToBlank(rowActData.get("AT00037")));
								builder.insertHtml("<br>");
								
								builder.getFont().setSize(11);
								builder.getFont().setBold(true);
								builder.writeln("[IT System]");
								builder.getFont().setSize(10);
								builder.getFont().setBold(false);
								builder.writeln(StringUtil.checkNullToBlank(rowActData.get("AT00013")));
								builder.insertHtml("<br>");
								
								builder.getFont().setSize(11);
								builder.getFont().setBold(true);
								builder.writeln( "[수행부서]");
								builder.getFont().setSize(10);
								builder.getFont().setBold(false);
								builder.writeln(StringUtil.checkNullToBlank(rowActData.get("AT00010")));
								builder.insertHtml("<br>");
								
								builder.getFont().setSize(11);
								builder.getFont().setBold(true);
								builder.writeln( "[비고/이슈]");
								builder.getFont().setSize(10);
								builder.getFont().setBold(false);
								builder.writeln(StringUtil.checkNullToBlank(rowActData.get("AT00006")));
								builder.insertHtml("<br>");
								
								builder.getFont().setSize(11);
								builder.getFont().setBold(true);
								builder.writeln( "[Fit/GAP]");
								builder.getFont().setSize(10);
								builder.getFont().setBold(false);
								builder.writeln(StringUtil.checkNullToBlank(rowActData.get("AT00046")));
								builder.insertHtml("<br>");
								
								builder.getFont().setSize(11);
								builder.getFont().setBold(true);
								builder.writeln( "[모듈]");
								builder.getFont().setSize(10);
								builder.getFont().setBold(false);
								builder.writeln(StringUtil.checkNullToBlank(rowActData.get("AT00020")));
								builder.insertHtml("<br>");
								
								builder.getFont().setSize(11);
								builder.getFont().setBold(true);
								builder.writeln( "[화면코드]");
								builder.getFont().setSize(10);
								builder.getFont().setBold(false);
								builder.writeln(StringUtil.checkNullToBlank(rowActData.get("AT00014")));
								builder.insertHtml("<br>");
								
								builder.getFont().setSize(11);
								builder.getFont().setBold(true);
								builder.writeln( "[Business Type]");
								builder.getFont().setSize(10);
								builder.getFont().setBold(false);
								builder.writeln(StringUtil.checkNullToBlank(rowActData.get("ZAT0011")));
								builder.insertHtml("<br>");
															
								builder.getFont().setSize(11);
								builder.getFont().setBold(true);
								builder.writeln( "[Division]");
								builder.getFont().setSize(10);
								builder.getFont().setBold(false);
								builder.writeln(StringUtil.checkNullToBlank(rowActData.get("ZAT0012"))); 
								builder.insertHtml("<br>");
								
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
			
			String extLangCode = StringUtil.checkNull(commandMap.get("extLangCode"));
			
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));			
			String identifier = StringUtil.checkNull(commandMap.get("identifier"));
			//String filePath = "C://TEMP//" ;
			String filePath = StringUtil.checkNull(commandMap.get("filePath"));
			if(filePath.equals("") || filePath == null){
				filePath = GlobalVal.FILE_UPLOAD_ITEM_DIR + "FLTP001/";
			}
			File dirFile = new File(filePath); if(!dirFile.exists()){dirFile.mkdirs();} 
		    String fileName = identifier+"."+itemNameOfFileNm+"(Process)"+"_"+extLangCode+".docx";
		   // String downFile = FileUtil.FILE_EXPORT_DIR + fileName;	
		    String downFile = filePath + fileName;	
			doc.save(downFile);
			
			// file DRM 적용			
			String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
			String useDownDRM = StringUtil.checkNull(GlobalVal.DRM_DOWN_USE);
			if(!"".equals(useDRM) && !"N".equals(useDownDRM)){
				HashMap drmInfoMap = new HashMap();			
				String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
				String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
				String teamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
				String teamName = StringUtil.checkNull(commandMap.get("sessionTeamName"));
				
				drmInfoMap.put("userID", userID);
				drmInfoMap.put("userName", userName);
				drmInfoMap.put("teamID", teamID);
				drmInfoMap.put("teamName", teamName);
				drmInfoMap.put("orgFileName", fileName);
				drmInfoMap.put("downFile", downFile);
				drmInfoMap.put("filePath", filePath);			
				drmInfoMap.put("funcType", "report");
				returnValue = DRMUtil.drmMgt(drmInfoMap); // 암호화 
			}
			
			returnValue = "success";
			
		} catch(Exception e){
			System.out.println(e.toString());
		}	
		return returnValue;
	}
}
