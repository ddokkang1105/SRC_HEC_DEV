<%@page contentType="application/msword; charset=utf-8"%>
<%@page trimDirectiveWhitespaces="true" %>

<%@page import="java.io.*" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.HashMap" %>
<%@page import="java.util.List" %>
<%@page import="xbolt.cmm.framework.util.StringUtil" %>
<%@page import="xbolt.cmm.framework.val.GlobalVal" %>

<%@page import="com.aspose.words.*" %>
<%@page import="java.awt.Color" %>


<%

License license = new License();
license.setLicense("Aspose.Words.Java.lic");
 
try{
	System.out.println("BType");
	String LogoImgUrl = "";
	String modelImgPath = GlobalVal.MODELING_DIGM_DIR;

	Document doc = new Document();
	DocumentBuilder builder = new DocumentBuilder(doc);
	builder.getFont().setSize(10);

	List prcList = (List)request.getAttribute("prcList");
 	List attrHdList = (List)request.getAttribute("attrPrcHdList");
 	List attrsList = (List)request.getAttribute("attrsList");
	List actList = (List)request.getAttribute("actList");
	//List tipList = (List)request.getAttribute("tipList");
 	Map setMap = (HashMap)request.getAttribute("setMap");

	//==================================================================================================
    Map rowPrcData = new HashMap();
	if(prcList.size() > 0) rowPrcData = (HashMap) prcList.get(0);    

	//==================================================================================================
	//프로세스 정의
	builder.writeln("*프로세스 정의");
	builder.startTable();
	
	// Make the header row.
	builder.insertCell();
	builder.getRowFormat().clearFormatting();
	builder.getCellFormat().clearFormatting();
	
	// Set the left indent for the table. Table wide formatting must be applied after
	// at least one row is present in the table.
	//prcTbl.setLeftIndent(10.0);
	
	// Set height and define the height rule for the header row.
	builder.getRowFormat().setHeight(20.0);
	builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
	
	// Some special features for the header row.
	builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	builder.getFont().setSize(10);
	//builder.getFont().setName("Arial");
	builder.getFont().setBold (true);
	
	builder.getCellFormat().setWidth(80.0);
	builder.write("ID");
	builder.insertCell();
	builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	builder.getFont().setBold (false);
	if(prcList.size() > 0) builder.write(StringUtil.checkNullToBlank(rowPrcData.get("MyItemID")));
	builder.insertCell();
	builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	builder.getFont().setBold (true);
	builder.write("프로세스명");
	builder.insertCell();
	builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	builder.getFont().setBold (false);
	if(prcList.size() > 0) builder.write(StringUtil.checkNullToBlank(rowPrcData.get("MyItemName")));		
	builder.endRow();
	
	builder.getCellFormat().setWidth(80.0);
	builder.insertCell();
	builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	builder.getFont().setBold (true);
	builder.write("담당조죅");
	builder.insertCell();
	builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	builder.getFont().setBold (false);
	if(prcList.size() > 0)builder.write("("+StringUtil.checkNullToBlank(rowPrcData.get("OwnerTeamID"))+")"+StringUtil.checkNullToBlank(rowPrcData.get("OwnerTeamNM")));
	builder.insertCell();
	builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	builder.getFont().setBold (true);
	builder.write("최종작성자");
	builder.insertCell();
	builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	builder.getFont().setBold (false);
	if(prcList.size() > 0)builder.write(StringUtil.checkNullToBlank(rowPrcData.get("LastUserNM")));
	builder.endRow();
	
	builder.getCellFormat().setWidth(80.0);
	builder.insertCell();
	builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	builder.getFont().setBold (true);
	builder.write("경로");
	builder.insertCell();
	builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	builder.getFont().setBold (false);
	builder.getCellFormat().setHorizontalMerge(CellMerge.FIRST);
	if(prcList.size() > 0)builder.write(StringUtil.checkNullToBlank(rowPrcData.get("MyPath")));
	builder.insertCell();
	builder.getCellFormat().setHorizontalMerge(CellMerge.PREVIOUS);
	builder.insertCell();
	builder.getCellFormat().setHorizontalMerge(CellMerge.PREVIOUS);
	builder.endRow();		

	builder.getCellFormat().setWidth(80.0);
	builder.insertCell();	
	builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	builder.getFont().setBold (true);
	builder.write("설명");
	builder.insertCell();
	builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	builder.getFont().setBold (false);
	builder.getCellFormat().setHorizontalMerge(CellMerge.FIRST);
	if(prcList.size() > 0)builder.write(StringUtil.checkNullToBlank(rowPrcData.get("MyItemDesc")));
	builder.insertCell();
	builder.getCellFormat().setHorizontalMerge(CellMerge.PREVIOUS);
	builder.insertCell();
	builder.getCellFormat().setHorizontalMerge(CellMerge.PREVIOUS);
	builder.endRow();		

	builder.endTable();		
	
	
	//==================================================================================================
	//프로세스 정의서(기타 항목)
	System.out.println("프로세스정의서");
	if(attrHdList!=null&& attrHdList.size() > 0){
		System.out.println("프로세스정의서1");
		builder.insertBreak(BreakType.LINE_BREAK);
		builder.startTable();
		
		// Make the header row.
		builder.insertCell();
		builder.getRowFormat().clearFormatting();
		builder.getCellFormat().clearFormatting();
		
		//prcTbl.setLeftIndent(10.0);
		
		// Set height and define the height rule for the header row.
		builder.getRowFormat().setHeight(20.0);
		builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
		
		// Some special features for the header row.
		builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
		builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
		builder.getFont().setSize(10);
		//builder.getFont().setName("Arial");
		
		Map rowAttrHdData = new HashMap();
		Map rowAttrsData = new HashMap();
		String attrValue = "";
		for(int j=0; j<attrHdList.size(); j++){
			rowAttrHdData = (HashMap) attrHdList.get(j); 		    
		   if( j != 0 ){
				builder.getCellFormat().setWidth(120.0);
			   	builder.insertCell();
		   }
		   
			builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
			builder.getFont().setBold (true);
			if( j == 0) builder.getCellFormat().setWidth(120.0);
			builder.write(StringUtil.checkNullToBlank(rowAttrHdData.get("AttrName")));
			
			builder.insertCell();
			builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
			builder.getFont().setBold (false);
			attrValue = " ";
			int maxAttrSize = attrsList.size();
			for(int k=0; k<maxAttrSize;k++){
				rowAttrsData = (HashMap) attrsList.get(k); 
				/*
				System.out.println("==1:"+StringUtil.checkNullToBlank(rowPrcData.get("MyItemID"))+","+ StringUtil.checkNullToBlank(rowAttrsData.get("MyItemID"))
						+"==2:"+ StringUtil.checkNullToBlank(rowAttrHdData.get("ClassCode"))+","+  StringUtil.checkNullToBlank(rowAttrsData.get("ClassCode"))
						+"==3:"+ StringUtil.checkNullToBlank(rowAttrHdData.get("AttrType"))+","+ StringUtil.checkNullToBlank(rowAttrsData.get("AttrType"))
						+"==4:"+ StringUtil.checkNullToBlank(rowAttrsData.get("IsCheck"))
						+" value="+StringUtil.checkNullToBlank(rowAttrsData.get("AttrValue"))
						);
			*/
				if(StringUtil.checkNullToBlank(rowPrcData.get("MyItemID")).equals(StringUtil.checkNullToBlank(rowAttrsData.get("MyItemID")))
						&& StringUtil.checkNullToBlank(rowAttrHdData.get("ClassCode")).equals(StringUtil.checkNullToBlank(rowAttrsData.get("ClassCode")))
						&& StringUtil.checkNullToBlank(rowAttrHdData.get("AttrType")).equals(StringUtil.checkNullToBlank(rowAttrsData.get("AttrType")))
						&& StringUtil.checkNullToBlank(rowAttrsData.get("IsCheck")).equals("N")
						){
					attrValue = StringUtil.checkNullToBlank(rowAttrsData.get("AttrValue"));
					System.out.println("attrValue="+attrValue);						
					//attrsList.set(k, rowAttrsData.put("IsCheck", "Y"));
				}
			}
			builder.write(attrValue);
			//}
			
			if(j != 0 && j % 2 == 1) builder.endRow();
		}

		builder.endTable();		
	}
	//==================================================================================================
	//Tip리스트
	/*
	System.out.println("tipList");
	builder.insertBreak(BreakType.LINE_BREAK);
	builder.insertBreak(BreakType.LINE_BREAK);
	builder.writeln("*TIP");
	builder.startTable();
	
	// Make the header row.
	builder.insertCell();
	builder.getRowFormat().clearFormatting();
	builder.getCellFormat().clearFormatting();
	
	// Set the left indent for the table. Table wide formatting must be applied after
	// at least one row is present in the table.
	//actTbl.setLeftIndent(10.0);
	
	// Set height and define the height rule for the header row.
	builder.getRowFormat().setHeight(20.0);
	builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
	
	// Some special features for the header row.
	builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	//builder.getFont().setSize(10);
	//builder.getFont().setName("Arial");
	builder.getFont().setBold (true);
	
	builder.getCellFormat().setWidth(100.0);
	builder.write("제목");
	builder.insertCell();
	builder.write("내용");
	builder.insertCell();
	builder.getCellFormat().setWidth(100.0);
	builder.write("작성일");
	builder.endRow();	
	
	// Set features for the other rows and cells.
	builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	builder.getCellFormat().setWidth(100.0);
	builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	
	// Reset height and define a different height rule for table body
	builder.getRowFormat().setHeight(30.0);
	builder.getRowFormat().setHeightRule(HeightRule.AUTO);
	
	// Build the other cells.
    Map rowTipData = new HashMap();
	if(tipList!=null && tipList.size()>0){
		for(int j=0; j<tipList.size(); j++){
			rowTipData = (HashMap) tipList.get(j);
		    
	    	builder.insertCell();
		    if( j==0){
		    	// Reset font formatting.
		    	//builder.getFont().setSize(10);
		    	builder.getFont().setBold(false);
		    }
		   	builder.write(StringUtil.checkNullToBlank(rowTipData.get("Subject")));
			builder.insertCell();
			builder.write(StringUtil.checkNullToBlank(rowTipData.get("Content")));
			builder.insertCell();
			builder.write(StringUtil.checkNullToBlank(rowTipData.get("Date")));
			builder.endRow();
		}	
	}
	
	builder.endTable();	
	*/
	
	//==================================================================================================
	//프로세스 맵
	System.out.println("프로세스맵");
	builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
	builder.writeln("*프로세스 맵");
	String imgLang = "_"+StringUtil.checkNull(setMap.get("langCode"));
	String imgPath = modelImgPath+rowPrcData.get("ID")+imgLang+"."+GlobalVal.MODELING_DIGM_IMG_TYPE;
	System.out.println("프로세스맵 imgPath="+imgPath);
	try{
		builder.insertImage(imgPath, RelativeHorizontalPosition.PAGE, 30, RelativeVerticalPosition.PAGE,20,500,400,WrapType.NONE);
	} catch(Exception ex){}

	//==================================================================================================
	//액티비티리스트
	System.out.println("actList");
	builder.insertBreak(BreakType.SECTION_BREAK_NEW_PAGE);
	builder.writeln("*액티비티 리스트");
	builder.startTable();
	
	// Make the header row.
	builder.insertCell();
	
	// Set the left indent for the table. Table wide formatting must be applied after
	// at least one row is present in the table.
	//actTbl.setLeftIndent(10.0);
	
	// Set height and define the height rule for the header row.
	builder.getRowFormat().setHeight(20.0);
	builder.getRowFormat().setHeightRule(HeightRule.AT_LEAST);
	
	// Some special features for the header row.
	builder.getCellFormat().getShading().setBackgroundPatternColor(new Color(179, 179, 179));
	builder.getParagraphFormat().setAlignment(ParagraphAlignment.CENTER);
	//builder.getFont().setSize(10);
	//builder.getFont().setName("Arial");
	builder.getFont().setBold (true);
	
	builder.getCellFormat().setWidth(100.0);
	builder.write("ID");
	builder.insertCell();
	builder.write("액티비티명");
	builder.insertCell();
	builder.write("액티비티설명");
	builder.endRow();	
	
	// Set features for the other rows and cells.
	builder.getCellFormat().getShading().setBackgroundPatternColor(Color.WHITE);
	builder.getCellFormat().setWidth(100.0);
	builder.getCellFormat().setVerticalAlignment(CellVerticalAlignment.CENTER);
	
	// Reset height and define a different height rule for table body
	builder.getRowFormat().setHeight(30.0);
	builder.getRowFormat().setHeightRule(HeightRule.AUTO);
	
	// Build the other cells.
    Map rowActData = new HashMap();
	if(actList!=null && actList.size()>0){
		for(int j=0; j<actList.size(); j++){
		    rowActData = (HashMap) actList.get(j);
		    
	    	builder.insertCell();
		    if( j==0){
		    	// Reset font formatting.
		    	//builder.getFont().setSize(10);
		    	builder.getFont().setBold(false);
		    }
		   	builder.write(StringUtil.checkNullToBlank(rowActData.get("MyItemID")));
			builder.insertCell();
			builder.write(StringUtil.checkNullToBlank(rowActData.get("MyItemName")));
			builder.insertCell();
			builder.write(StringUtil.checkNullToBlank(rowActData.get("MyItemDesc")));
			builder.endRow();
		}	
	}
	
	builder.endTable();			

	
	boolean openNewWindow = true;//request.getParameter("openNewWindow") != null;
	
    String fileName = "test" + "." + "doc";
    response.setContentType("application/msword");
    response.setCharacterEncoding("UTF-8");
    response.setHeader("content-disposition","attachment; filename=" + fileName);
    
    doc.save(response.getOutputStream(), SaveFormat.DOC);

} catch(Exception e){
	e.printStackTrace();
	
} finally{
	
	response.getOutputStream().flush();
	response.getOutputStream().close();
}

%>
