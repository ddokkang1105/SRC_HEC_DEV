<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ include file="common/api/WNSearch.jsp" %>
<% request.setCharacterEncoding("UTF-8");%><%
    /*
     * subject: 검색 메인 페이지
     * @original author: SearchTool
     */
    //실시간 검색어 화면 출력 여부 체크
    boolean isRealTimeKeyword = false;
    //인기 검색어 화면 출력 여부 체크
    boolean isPopKeyword = true;
    //디버깅 보기 설정
    boolean isDebug = true;
	boolean useSuggestedQuery = true;
    response.setHeader("Access-Control-Allow-Origin", "*"); //html 의 보안문제 해결
    int TOTALVIEWCOUNT = 3;    //통합검색시 출력건수

    //날짜얻어오기
    Calendar nowDate = Calendar.getInstance();
    int nowYear   = nowDate.get(Calendar.YEAR);
    int nowMonth  = nowDate.get(Calendar.MONTH) + 1;
    int nowDay    = nowDate.get(Calendar.DAY_OF_MONTH);
    // 결과 시작 넘버
    int startIndex      = parseInt(getCheckReqXSS(request, "startIndex", "0"), 0);
    int listCount      = parseInt(getCheckReqXSS(request, "listCount", "10"), 10);
    String query        = getCheckReqXSS(request, "query", "");          //검색어
    String collection   = getCheckReqXSS(request, "collection", "ALL");  //컬렉션이름

    String rt   = getCheckReqXSS(request, "rt", "");              //결과내 재검색 체크필드
    String rt2   = getCheckReqXSS(request, "rt2", "");            //결과내 재검색 체크필드
    String requery   = getCheckReqXSS(request, "requery", "");    //결과내 검색어
    String mode   = getCheckReqXSS(request, "mode", "basic");     //통합검색(basic),상세검색(detail)
    String sortOrg   = getCheckReqXSS(request, "sort", "RANK");      //정렬필드
    String range   = getCheckReqXSS(request, "range", "0");       //기간관련필드
    String startDate   = getCheckReqXSS(request, "sdate", "");    //시작날짜
    String endDate   = getCheckReq(request, "edate", "");      //끝날짜
    String writer   = getCheckReqXSS(request, "writer", "");      //작성자

	String itemCd   = getCheckReqXSS(request, "itemCd", "");      //작성자
	String itemNm   = getCheckReqXSS(request, "itemNm", "");      //작성자
	String authorIdNm   = getCheckReqXSS(request, "authorNm", "");      //작성자
	String authorEm   = getCheckReqXSS(request, "authorEm", "");      //작성자
	String itemStatusNm   = getCheckReqXSS(request, "itemStatusNm", "");      //작성자
	String teamNm   = getCheckReqXSS(request, "teamNm", "");      //작성자
    String itemContents   = getCheckReqXSS(request, "itemContents", "");      //작성자

    String itemTypeCd   = getCheckReqXSS(request, "itemTypeCd", "");      //작성자
	String languageId   = getCheckReqXSS(request, "languageId", "");      //작성자


	String fileRealNm   = getCheckReqXSS(request, "fileRealNm", "");      //작성자
	String fileDesc   = getCheckReqXSS(request, "fileDesc", "");      //작성자

    String sfield   = "";
	String sort = "";
	String itemCollectionQuery = "";
	String fileCollectionQuery = "";
	String collectionQuery = "";
    // 상세검색 검색 필드 설정이 되었을때
    String [] field = request.getParameterValues("sfield");
    if ( field != null ) {
        for ( int x=0; x<field.length;x++) {
            sfield = sfield + field[x] + ",";
        }

    } else sfield = "ALL";
 
 //2021-12-24 수정
	if ( sortOrg != null && sortOrg.indexOf(",") >-1 ) {
		String [] sortfields = sortOrg.split(",");
        for ( int x=0; x<sortfields.length;x++) {
            sort += sortfields[x]+"/DESC";
			if(x<sortfields.length){
				sort += ",";
			}
        }

    } else sort = "RANK/DESC";
 //2021-12-24 수정

    if ( range.equals("0") ) {
        startDate = "";
        endDate = "";
    }

    String[] collections = null;
    if(collection.equals("ALL")) { //통합검색인 경우
        collections = COLLECTIONS;
    } else {                        //개별검색인 경우
        collections = new String[] { collection };
    }

	if(itemCd != ""){
		itemCollectionQuery += "<ITEM_CD:contains:"+itemCd+">";
	}

	if(itemNm != ""){
		itemCollectionQuery += "<ITEM_NM:contains:"+itemNm+">";
		fileCollectionQuery += "<ITEM_NM:contains:"+itemNm+">";
	}

	if(authorIdNm != ""){
		itemCollectionQuery += "<AUTHORID_NM:contains:"+authorIdNm+">";
	}

	if(authorEm != ""){
		itemCollectionQuery += "<AUTHOR_EM:contains:"+authorEm+">";
	}

	if(itemStatusNm != ""){
		itemCollectionQuery += "<ITEM_STATUS_NM:contains:"+itemStatusNm+">";
	}

	if(teamNm != ""){
		itemCollectionQuery += "<TEAM_NM:contains:"+teamNm+">";
	}

	if(itemContents != ""){
		itemCollectionQuery += "<ITEM_CONTENTS:contains:"+itemContents+">";
	}

	if(fileRealNm != ""){
		fileCollectionQuery += "<FILE_REAL_NM:contains:"+fileRealNm+">";
	}

	if(fileDesc != ""){
		fileCollectionQuery += "<FILE_DESC:contains:"+fileDesc+">";
	}


	


    String search = query ;
    String strOperation  = "" ; //operation 조건 필드
    String exquery = "" ;       //exquery 조건 필드
    int totalCount = 0;

    if ( rt.equals("1") && !requery.equals("") ) {
		   search = query + " " + requery;
 	} else if ( rt2.equals("1") && !requery.equals("") ) {
 		search = requery ;
  	}


	if(itemTypeCd != ""){
		strOperation += "<ITEM_TYPE_CD:substring:"+itemTypeCd+">";
	}

	if(languageId != ""){
		strOperation += "<LANGUAGE_ID:substring:"+languageId+">";
	}


    String[] searchFields = null;
    if ( !writer.equals("") ) {
        exquery = "<WRITER:" + writer + ">";
    }

    WNSearch wnsearch = new WNSearch(isDebug,false, collections, searchFields);

    int viewResultCount = listCount;
   

    for (int i = 0; i < collections.length; i++) {

        //출력건수
        wnsearch.setCollectionInfoValue(collections[i], PAGE_INFO, startIndex+","+viewResultCount);

        //검색어가 없으면 DATE_RANGE 로 전체 데이터 출력
        if ( !query.equals("") ) {
              wnsearch.setCollectionInfoValue(collections[i], SORT_FIELD, sort);
        } else {
              wnsearch.setCollectionInfoValue(collections[i], DATE_RANGE, "1970/01/01,2030/12/31,-");
              wnsearch.setCollectionInfoValue(collections[i], SORT_FIELD, "RANK/DESC,DATE/DESC");
        }
        //sfield 값이 있으면 설정, 없으면 기본검색필드
        if ( !sfield.equals("") && sfield.indexOf("ALL") == -1 ) wnsearch.setCollectionInfoValue(collections[i], SEARCH_FIELD, sfield );
        //operation 설정
        if ( !strOperation.equals("") &&  collections[i].equals("KPAL_ITEM")) wnsearch.setCollectionInfoValue(collections[i], FILTER_OPERATION, strOperation);

		if ( !itemCollectionQuery.equals("") &&  collections[i].equals("KPAL_ITEM")) wnsearch.setCollectionInfoValue(collections[i], COLLECTION_QUERY, itemCollectionQuery);

		if ( !fileCollectionQuery.equals("") &&  collections[i].equals("KPAL_FILE")) wnsearch.setCollectionInfoValue(collections[i], COLLECTION_QUERY, fileCollectionQuery);
        //exquery 설정
        if ( !exquery.equals("") ) wnsearch.setCollectionInfoValue(collections[i], EXQUERY_FIELD, exquery );
        //기간 설정 , 날짜가 모두 있을때
        if ( !startDate.equals("")  && !endDate.equals("") )
             wnsearch.setCollectionInfoValue(collections[i], DATE_RANGE, startDate.replaceAll("-","/") + "," + endDate.replaceAll("-","/") + ",-");
        //기간 설정 , 시작날짜만 있을때에는 뒤에 날짜를 오늘날짜로 셋팅한다.
        else if ( !startDate.equals("")  && endDate.equals("") )
             wnsearch.setCollectionInfoValue(collections[i], DATE_RANGE, startDate.replaceAll("-","/") + "," + nowYear + "/" + nowMonth + "/" + nowDay + ",-");


    }

    wnsearch.search(search, isRealTimeKeyword, CONNECTION_CLOSE, useSuggestedQuery);

	  // 전체건수 구하기
    if ( collection.equals("ALL") ) {
        for (int i = 0; i < collections.length; i++) {
           totalCount += wnsearch.getResultTotalCount(collections[i]);
        }
    } else {
      //개별건수 구하기
        totalCount = wnsearch.getResultTotalCount(collection);
    }

	

	
	Map<String, Object> integratedMap = new HashMap();
	ArrayList<Map<String, Object>> integratedList = new ArrayList();

	integratedMap.put("TotalCount", totalCount);
	integratedMap.put("Query", search);

	for (int i = 0; i < collections.length; i++) {
		Map<String, Object> resultmap = new HashMap();
		
		int Count = wnsearch.getResultCount(collections[i]);
		int thisTotalCount = wnsearch.getResultTotalCount(collections[i]);
		
		resultmap.put("CollectionName", collections[i]);
		resultmap.put("CollTotCount", thisTotalCount);
		resultmap.put("CollListCount", Count);

		ArrayList<Map<String, Object>> resultlist = new ArrayList();

		String resultFields = wnsearch.wncol.COLLECTION_INFO[wnsearch.getCollIdx(collections[i])][RESULT_FIELD];
		
		for(int idx = 0; idx < Count; idx ++) {
			Map<String, Object> result = new HashMap();
			
			String[] resultFieldArr = resultFields.split(",");

			for (int x=0; x<resultFieldArr.length; x++) {
				String resultField = resultFieldArr[x];
				//2021-12-21 수정
				String usedResultField = "";
				
				if(resultField.indexOf("/")>-1){
					String[] arrayResultField = resultField.split("/");
					usedResultField = arrayResultField[0];
				}else{
					usedResultField = resultField;
				}

				result.put(usedResultField, wnsearch.getField(collections[i], usedResultField, idx, false));
				//2021-12-21 수정 
			} 

			resultlist.add(result);
		}

		resultmap.put("Document",resultlist);

		integratedList.add(resultmap);
	}
	
	integratedMap.put("Collections",integratedList);
	 	
	JSONArray jObj = JSONArray.fromObject(integratedList);
  	out.println(jObj.toString());

    if ( wnsearch != null )
        wnsearch.closeServer();
%>
