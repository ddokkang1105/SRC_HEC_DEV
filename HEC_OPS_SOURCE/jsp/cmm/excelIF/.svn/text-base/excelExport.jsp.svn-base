<%@page contentType="application/vnd.ms-excel; charset=EUC-KR"%>
<%@page import="org.apache.poi.hssf.usermodel.*" %>
<%@page import="java.io.*" %>
<%

try {

String fileName = "test.xls";
response.setHeader("Content-Disposition", "attachment; filename=" + fileName); 
response.setHeader("Content-Description", "JSP Generated Data"); 

//신규 워크북을 작성
HSSFWorkbook wb = new HSSFWorkbook();

 //sheet1」라는 이름의 워크시트를 표시하는 오브젝트 생성
HSSFSheet sheet1 = wb.createSheet("sheet1"); 

for(int i = 0; i < 100; i++) {

 //행의 작성
HSSFRow row = sheet1.createRow((short)i); 

//행에 셀의 데이터를 설정 
row.createCell((short)0).setCellValue("text value");
 row.createCell((short)1).setCellValue(123456);
 row.createCell((short)2).setCellValue(25.45);
 }

 OutputStream fileOut = response.getOutputStream();
 wb.write(fileOut);

} catch (Exception e) {

e.printStackTrace(); 

}
%>
