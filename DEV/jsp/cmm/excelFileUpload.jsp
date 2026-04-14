<%@page contentType="text/html; charset=utf-8" language="java" errorPage=""%>  
<%@page import="java.util.*,java.io.*" %>
<%@page import="com.oreilly.servlet.MultipartRequest,
com.oreilly.servlet.multipart.DefaultFileRenamePolicy,jxl.*"%>  

<% 
System.out.println("저장시작~");
/*
Enumeration menum = request.getParameterNames();
while(menum.hasMoreElements()){
	String name = (String)menum.nextElement();
	String[] values = request.getParameterValues(name);
	if(values != null){
		for(int i = 0; i < values.length ; i++){
		System.out.println("NAME :  "+name + " // values : " + values[i]);
		}
	}
}
*/


 String savePath = request.getRealPath("/")+"jsp/upload/tmp"; // 저장할 디렉토리   
 
 File dir = new File(savePath);
 if(!dir.exists()){
	 dir.mkdirs();
 }
 
 int sizeLimit = 30 * 1024 * 1024 ; // 용량제한   
 String formName = "";   
 String fileName = "";   
 Vector vFileName = new Vector();   
 Vector vFileSize = new Vector();   
 String[] aFileName = null;   
 String[] aFileSize = null;   
 long fileSize = 0;   
    
 MultipartRequest multi = new MultipartRequest(request, savePath, sizeLimit, "utf-8", new DefaultFileRenamePolicy());   
  
 Enumeration formNames = multi.getFileNames();    
  
 while (formNames.hasMoreElements()) {    
  
 formName = (String)formNames.nextElement();    
    fileName = multi.getFilesystemName(formName);    
  
 if(fileName != null) {   // 파일이 업로드 되면   
	  fileSize = multi.getFile(formName).length();   
	  vFileName.addElement(fileName);   
	        vFileSize.addElement(String.valueOf(fileSize));   
	 }    
 }   
       
 aFileName = (String[])vFileName.toArray(new String[vFileName.size()]);   
 aFileSize = (String[])vFileSize.toArray(new String[vFileSize.size()]);   
 
 System.out.println("저장완료~");
 
%>  
  
<%   
 Workbook workbook = Workbook.getWorkbook(new File(savePath + "/" + fileName));    
 Sheet sheet = workbook.getSheet(0);   
     
 int col = sheet.getColumns();  // 시트의 컬럼의 수를 반환한다.    
 int row = sheet.getRows();   // 시트의 열의 수를 반환한다.  
%>