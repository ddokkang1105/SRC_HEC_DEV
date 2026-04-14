<%@page contentType="application/vnd.ms-excel; charset=EUC-KR"%>
<%@page import="org.apache.poi.hssf.usermodel.*" %>
<%@page import="java.io.*" %>

<%@page import="org.apache.commons.logging.Log" %>
<%@page import="org.apache.commons.logging.LogFactory" %>

<%

final Log log = LogFactory.getLog(this.getClass());

try {

String fileName = "test.xls";
response.setHeader("Content-Disposition", "attachment; filename=" + fileName); 
response.setHeader("Content-Description", "JSP Generated Data"); 

//��洹� ���щ��� ����
HSSFWorkbook wb = new HSSFWorkbook();

 //sheet1���쇰�� �대��� ���ъ���몃�� �������� �ㅻ����� ����
HSSFSheet sheet1 = wb.createSheet("sheet1"); 

for(int i = 0; i < 100; i++) {

 //���� ����
HSSFRow row = sheet1.createRow((short)i); 

//���� ���� �곗�댄�곕�� �ㅼ�� 
row.createCell((short)0).setCellValue("text value");
 row.createCell((short)1).setCellValue(123456);
 row.createCell((short)2).setCellValue(25.45);
 }

 OutputStream fileOut = response.getOutputStream();
 wb.write(fileOut);

} catch (Exception e) {

	//2025-03-25 소스코드 취약점 수정
	log.error("Exception", e);
	//e.printStackTrace();
}
%>
