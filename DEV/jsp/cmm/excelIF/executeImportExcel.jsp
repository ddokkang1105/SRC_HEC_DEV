<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%
	int numOfCol = 19;

	String[] dataArray = request.getParameterValues("value");
	
	int numOfRow = dataArray.length / numOfCol;

	String[][] rawData = new String[numOfRow][numOfCol];
	
	int j = 0;
	int i = 0;
	for(int count = 0; count < dataArray.length; count++) {
		i = count / numOfCol;
		j = count % numOfCol;
		
		rawData[i][j] = dataArray[count];
	}
	

	
	ArrayList< ArrayList<String> > dataForUpdate = new ArrayList< ArrayList<String> >();
	
	for(i = 0; i < numOfRow; i++) {
		boolean isUpdate = false;
		String reviewCode = "";
		String gubun = "";
		
		if(rawData[i][0].length() == 3) {
			if(rawData[i][11].toString().equals("N")|| rawData[i][11].toString().equals("M")) {
				reviewCode	= rawData[i][11];
				gubun		= "A";
				isUpdate	= true;
			}
		}
		else if(rawData[i][0].length() == 6) {
			if(rawData[i][4].toString().equals("N") || rawData[i][4].toString().equals("M")) {
				reviewCode	= rawData[i][4];
				gubun		= "P";
				isUpdate	= true;
			}
		}
		
		if(isUpdate == false) {
			continue;
		}
		
		for(j = 0; j < numOfCol - 1; j++) {
			if( j == 1 || j == 3 || j == 4 || j == 11 ) {
				continue;
			}
			
			if(rawData[i][j].toString().equals("")) {				
				continue;
			}
			
			String attrTypeCode = "";
			switch(j) {
				case 0:
					attrTypeCode = "AT00000";
					break;
				case 2:
					attrTypeCode = "AT00001";
					break;
				case 5:
					attrTypeCode = "AT00004";
					break;
				case 6:
					attrTypeCode = "AT00003";
					break;
				case 7:
					attrTypeCode = "AT00007";
					break;
				case 8:
					attrTypeCode = "AT00008";
					break;
				case 9:
					attrTypeCode = "AT00009";
					break;
				case 10:
					attrTypeCode = "AT00010";
					break;
				case 12:
					attrTypeCode = "AT00003";
					break;
				case 13:
					attrTypeCode = "AT00005";
					break;
				case 14:
					attrTypeCode = "AT00006";
					break;
				case 15:
					attrTypeCode = "AT00011";
					break;
				case 16:
					attrTypeCode = "AT00012";
					break;
				case 17:
					attrTypeCode = "AT00013";
					break;
			}
			
			ArrayList<String> currString = new ArrayList<String>();
			
			currString.add(0, rawData[i][numOfCol-1]);
			currString.add(1, rawData[i][j]);
			currString.add(2, attrTypeCode);
			currString.add(3, reviewCode);
			currString.add(4, gubun);
			
			dataForUpdate.add(currString);
			
		}
	}
	
	for( i = 0; i < dataForUpdate.size(); i++) {		
		out.println(dataForUpdate.get(i).get(0));
		out.println(dataForUpdate.get(i).get(1));
		out.println(dataForUpdate.get(i).get(2));
		out.println(dataForUpdate.get(i).get(3));
		out.println(dataForUpdate.get(i).get(4));
		out.println("<br>");
	}
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<body>

</body>
</html>