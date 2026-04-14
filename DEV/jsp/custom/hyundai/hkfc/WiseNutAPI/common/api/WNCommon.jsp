<%@ page import="java.util.*,java.io.IOException,javax.servlet.jsp.JspWriter,QueryAPI530.Search"%><%@ include file="./WNUtils.jsp"%><%!
/**
*  file: WNCommon.jsp
*  subject: Search Formula-1 API Wrapper 클래스
*  ------------------------------------------------------------------------
*  @original author: WISEnut
*  @edit author: WISEnut
*  @update date 2012.04.24
*  ------------------------------------------------------------------------
*/
public class WNCommon {
   private Search search = null;
   private JspWriter out = null;
   boolean isDebug = false;

   /**
    * SF-1 Search 클래스 객체를 생성하는 WNCommon의 생성자 함수이다.
    */
   public WNCommon() {
       this.search = new Search();
   }

   /**
    * WNCommon 오버로딩(overloading) 함수이다.
    * WNCommon을 단독으로 사용할 경우 debug 사용유무를 지정할 수 있다.
    * @param out
    * @param isDubug
    */
   public WNCommon(JspWriter out, boolean isDubug) {
       this.search = new Search();
       this.out = out;
       this.isDebug = isDubug;
   }

   /**
    * 검색 질의 키워드와 질의나 출력에 사용될 문자집합을 정한다.
    * v4.x 호환 method이므로 COMMON_OR_WHEN_NORESULT을 지정하지 않는다.
    * @param query
    * @param charSet
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    * @deprecated  As of v4.x, replaced by
    * {@link #setCommonQuery(String,String,int)}
    */
   public int setCommonQuery(String query, String charSet) {
       int ret = 0;
       ret = search.w3SetCodePage(charSet);
       ret = search.w3SetQueryLog(1);
       ret = search.w3SetTraceLog(0);
       ret = search.w3SetCommonQuery(query, 0);
       return ret;
   }

    /**
    * 검색 질의 UID와 질의나 출력에 사용될 문자집합을 정한다.
    * @param charSet
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int setUidQuery(String charSet) {
       int ret = 0;
       ret = search.w3SetCodePage(charSet);
       ret = search.w3SetQueryLog(0);
       return ret;
   }

   /**
    * 검색 질의 키워드와 질의나 출력에 사용될 문자집합을 정한다.
    * @param query
    * @param charSet
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int setCommonQuery(String query, String charSet, int useOrResult, boolean useSuggestedQuery) {
       int ret = 0;
       ret = search.w3SetCodePage(charSet);
       ret = search.w3SetQueryLog(1);
       ret = search.w3SetTraceLog(0);
       ret = search.w3SetCommonQuery(query, useOrResult);
       if(useSuggestedQuery) {
           ret = search.w3SetSpellCorrectionQuery(query, 0);
       }
       return ret;
   }

   /**
    * setCommonQuery의 오버로딩(overloading) 함수로
    * session정보를 부가기능으로 사용할 수 있다.
    * v4.x 호환 method이므로 COMMON_OR_WHEN_NORESULT을 지정하지 않는다.
    * @param query
    * @param charSet
    * @param logInfo
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    * @deprecated  As of v4.x, replaced by
    * {@link #setCommonQuery(String,String,String[],int)}
    */
   public int setCommonQuery(String query, String charSet, String[] logInfo) {
       int ret = 0;
       if (logInfo != null && logInfo.length > 2) {
           ret = search.w3SetSessionInfo(logInfo[0], logInfo[1], logInfo[2]);
       }
       setCommonQuery(query, charSet);
       return ret;
   }


   /**
    * setCommonQuery의 오버로딩(overloading) 함수로
    * session정보를 부가기능으로 사용할 수 있다.
    * @param query
    * @param charSet
    * @param logInfo
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int setCommonQuery(String query, String charSet, int useOrResult, String[] logInfo) {
       int ret = 0;
       if (logInfo != null && logInfo.length > 2) {
           ret = search.w3SetSessionInfo(logInfo[0], logInfo[1], logInfo[2]);
       }
       ret = search.w3SetCodePage(charSet);
       ret = search.w3SetQueryLog(1);
       ret = search.w3SetCommonQuery(query, useOrResult);
       return ret;
   }

   /**
    * setCommonQuery의 오버로딩(overloading) 함수로
    * session정보를 부가기능으로 사용할 수 있다.
    * @param query
    * @param charSet
    * @param logInfo
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int setCommonQuery(String query, String charSet, int useOrResult, boolean useSuggestedQuery, String[] logInfo) {
       int ret = 0;
       if (logInfo != null && logInfo.length > 2) {
           ret = search.w3SetSessionInfo(logInfo[0], logInfo[1], logInfo[2]);
       }
       ret = search.w3SetCodePage(charSet);
       ret = search.w3SetQueryLog(1);
       ret = search.w3SetCommonQuery(query, useOrResult);
       if(useSuggestedQuery) {
           ret = search.w3SetSpellCorrectionQuery(query, 0);
       }
       return ret;
   }

   /**
    * 컬렉션 별로 검색어 지정
    * @param collectionName
    * @param query
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int setCollectionQuery(String collectionName, String query) {
       return search.w3SetCollectionQuery(collectionName, query);
   }


   /**
    * 컬렉션 별로 boost query 지정
    * @param collectionName
    * @param boost query
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int setBoostQuery(String collectionName, String query) {
       int idx = query.lastIndexOf("/");
       int option = Integer.parseInt(query.substring(idx, query.length()));
       return search.w3SetBoostQuery(collectionName, query, option);
   }

   /**
    * 컬렉션 별로 boost query 지정
    * @param collectionName
    * @param boost query
    * @param option 0,1,2
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int setBoostQuery(String collectionName, String query, int option) {
       return search.w3SetBoostQuery(collectionName, query, option);
   }

   /**
    * 검색하고자 하는 컬렉션의 UID를 설정한다.
    * @param collectionName
    * @param values
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int setUid(String collectionName, String[] values,
           String searcherId) {
       int ret = 0;
       for (int i = 0; i < values.length; i++) {
           long uid = 0L;
           try {
               uid = Long.parseLong(values[i]);
           } catch (NumberFormatException e) {
               return -1;
           }
           ret = search.w3AddUid(collectionName, uid, searcherId);
       }
       return ret;
   }

   /**
    * 검색대상 컬렉션, 언어분석기 사용유무, 대소문자 구분유무를 설정한다.
    * v4.x 호환 method이므로 USEORIGINAL, USESYNONYM을 지정하지 않는다.
    * @param collectionName
    * @param useKma
    * @param isCase
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    * @deprecated  As of v4.5, replaced by
    * {@link #addCollection(String,int,int,int,int,int)}
    */
   public int addCollection(String collectionName, int useKma, int isCase) {
       int ret = 0;
       ret = search.w3AddCollection(collectionName);
        //USEMA, ISCASE, USEORIGINAL, USESYNONYM
       ret = search.w3SetQueryAnalyzer(collectionName, useKma, isCase, 1,1);
       ret = search.w3SetDuplicateDetection(collectionName);
       //systemOut("[w3AddCollection] "+collectionName);
       return ret;
   }

   /**
    * 검색대상 컬렉션, 언어분석기 사용유무, 대소문자 구분유무를 설정한다.
    * @param collectionName
    * @param useKma
    * @param isCase
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int addCollection(String collectionName, int useKma, int isCase,
           int useOriginal, int useSynonym, int duplicateDectection) {
       int ret = 0;
       ret = search.w3AddCollection(collectionName);
       //USEMA, ISCASE, USEORIGINAL, USESYNONYM
       ret = search.w3SetQueryAnalyzer(collectionName, useKma, isCase, useOriginal, useSynonym);
       //systemOut("[w3AddCollection] "+collectionName);
       if(duplicateDectection == 1) {
           ret = search.w3SetDuplicateDetection(collectionName);
       }
       return ret;
   }

   /**
    * 추상 컬렉션 추가
    * v4.x 호환 method이므로 USEORIGINAL, USESYNONYM을 지정하지 않는다.
    * @param aliasName 설정한 별칭 컬렉션명
    * @param collectionName 실제 컬렉션
    * @param useKma
    * @param isCase
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    * @deprecated  As of v4.5, replaced by
    * {@link #addAliasCollection(String,String,int,int,int,int,int)}
    */
   public int addAliasCollection(String aliasName, String collectionName,
           int useKma, int isCase) {
       int ret = 0;
       ret = search.w3AddAliasCollection(aliasName, collectionName);
       ret = search.w3SetQueryAnalyzer(aliasName, useKma, isCase, 1, 1);
       ret = search.w3SetDuplicateDetection(aliasName);
       return ret;
   }

   /**
    * 추상 컬렉션 추가
    * @param aliasName 설정한 별칭 컬렉션명
    * @param collectionName 실제 컬렉션
    * @param useKma
    * @param isCase
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int addAliasCollection(String aliasName, String collectionName,
           int useKma, int isCase, int useOriginal, int useSynonym, int duplicateDectection) {
       int ret = 0;
       ret = search.w3AddAliasCollection(aliasName, collectionName);
       ret = search.w3SetQueryAnalyzer(aliasName, useKma, isCase,
               useOriginal, useSynonym);
       if(duplicateDectection == 1) {
           ret = search.w3SetDuplicateDetection(aliasName);
       }
       return ret;
   }

   /**
    * 검색기 연결
    * @param ip
    * @param port
    * @param timeOut
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int getConnection(String ip, int port, int timeOut) {
       int ret = search.w3ConnectServer(ip, port, timeOut);
       return ret;
   }

   /**
    * 해당 컬렉션의 검색 대상 필드를 여러 개를 설정한다.
    * v4.x 호환 method이므로 fieldscore를 지정하지 않는다.
    * @param collectionName
    * @param fields
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    * @deprecated  As of v4.5, replaced by
    * {@link #setSearchField(String,String)}
    **/
   public int addSearchField(String collectionName, String[] fields) {
       int ret = 0;
       for (int i = 0; i < fields.length; i++) {
           ret = search.w3AddSearchField(collectionName, fields[i]);
           systemOut("[w3AddSearchField] " + collectionName + " / "
                   + fields[i]);
       }
       return ret;
   }

    /**
    * 검색 필드별 랭킹 스코어(score)를 설정한다.
    * @param collectionName
    * @param fields TITLE,CONTENT
    * @param rankScores 100,30
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int addSearchFieldScore(String collectionName, String[] fields, int[] rankScores) {
       int ret = 0;
       for (int i = 0; i < fields.length; i++) {
           ret = search.w3AddSearchFieldScore(collectionName, fields[i], rankScores[i]);
           systemOut("[w3AddSearchFieldScore] " + collectionName + " / "+ fields[i] + "/" + rankScores[i]);
       }
       return ret;
   }

   /**
    * 해당 컬렉션의 검색 대상 필드를 여러 개를 설정한다.
    * @param collectionName
    * @param fields TITLE/100,CONTENT/30
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int setSearchField(String collectionName, String fields) {
       int ret = 0;
       String[] searchFieldTemp = split(fields, ","); //TITLE/100,CONTENT/30
       for (int i = 0; i < searchFieldTemp.length; i++) {
           String[] searchField = split(searchFieldTemp[i], "/");
           if (searchField != null && searchField.length > 0) {
               ret = search.w3AddSearchField(collectionName,
                       searchField[0]);
               systemOut("[w3AddSearchField] " + collectionName + " / "+ searchField[0]);
           }
       }
       ret = search.w3SetSearchFieldScore(collectionName, fields);
       systemOut("[w3AddSearchField] " + collectionName + " / " + fields);
       return ret;
   }



   /**
    * 검색결과의 정렬필드를 설정한다.
    * v4.x 호환 method
    * @param collectionName
    * @param sortField
    * @param sortOrder
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    * @deprecated  As of v4.5, replaced by
    * {@link #setSortField(String,String)}
    */
   public int addSortField(String collectionName, String sortField, int sortOrder) {
       int ret = 0;
       ret = search.w3AddSortField(collectionName, sortField, sortOrder);
       systemOut("[w3AddSortField] " + collectionName + " / " + sortField);
       return ret;
   }

   /**
    * 검색결과의 정렬필드를 설정한다.
    * @param collectionName
    * @param sortValue
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int setSortField(String collectionName, String sortValue) {
       int ret = 0;
       ret = search.w3SetSortField(collectionName, sortValue);
       systemOut("[w3SetSortField] " + collectionName + " / " + sortValue);
       return ret;
   }

   /**
    * 검색결과 RANKING을 설정한다. SF-1 v5.0 신규 추가 method.
    * @param collectionName
    * @param method 랭킹 메소드( basic, custom, BM25 )
    * @param option
       - p( proximity )
       - r( field weight )
       - k( multi keyword factor )
       - f( frequency )
       - m( morpheme )
       - o( offset )
       - l( length )
    * @param maxcount Ranking 표기의 MAX 값. (예) %로 표기할 시 100
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
   */
   public int setRanking(String collectionName, String method, String option, int maxcount) {
       return search.w3SetRanking(collectionName, method, option, maxcount);
   }

   /**
   * 검색한 결과 랭크값에 대한 범위를 지정
   * @param collectionName Collection 이름
   * @param minRank 최소 랭킹 값
   * @param maxRank 최대 랭킹 값
   * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
   */
   public int setRankRange(String collectionName, int minRank, int maxRank) {
       return search.w3SetRankRange(collectionName, minRank, maxRank);

   }

   /**
    *
    * @param collectionName
    * @param fieldNameValues
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int setPrefixQuery(String collectionName,
           String fieldNameValues) {
       //value값에 /가 있을 수 있으므로 >/로 찾아서 query와 연산자를 분리한다.
       fieldNameValues = fieldNameValues.trim();
       int index = fieldNameValues.lastIndexOf("/");
       String prefixQuery = "";
       int operator = 1;
       if(index != -1) {
           prefixQuery = fieldNameValues.substring(0, index);
           String temp = fieldNameValues.substring(index+1, fieldNameValues.length());
           temp = temp.trim();
           operator = Integer.parseInt(temp);
       }else{
           prefixQuery = fieldNameValues.trim();
       }
       int ret = search.w3SetPrefixQuery(collectionName, prefixQuery, operator);
       systemOut("[w3SetPrefixQuery]" + fieldNameValues);
       return ret;
   }

   /**
    *
    * @param collectionName
    * @param fieldNameValues
    * @return  성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int setFilterOperation(String collectionName, String fieldNameValues) {
       int ret = search.w3SetFilterQuery(collectionName, fieldNameValues);
       systemOut("[w3SetFilterQuery]" + fieldNameValues);
       return ret;
   }

   /**
    *
    * @param collectionName
    * @param fieldNameValues
    * @return  성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int setFilterQuery(String collectionName, String fieldNameValues) {
       int ret = search.w3SetFilterQuery(collectionName, fieldNameValues);
       systemOut("[w3SetFilterQuery]" + fieldNameValues);
       return ret;
   }

   /**
   * setResultField에서 지정한 결과 필드들의 값을 얻는 함수이다.
   * v4.x 호환 method이다. displaylength를 지정하지 않으므로 주의해야한다.
   * @param collectionName
   * @param fields
   * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
   * @deprecated  As of v4.5, replaced by
   * {@link #setResultField(String,String)}
   */
   public int setResultField(String collectionName, String[] fields) {
       int ret = 0;
       for(int i=0; i< fields.length; i++) {
           ret = search.w3AddDocumentField(collectionName, fields[i], 0);
           systemOut("[w3AddDocumentField] " + collectionName + " / " + fields[i]);
       }
       return ret;
   }

   /**
    * setResultField에서 지정한 결과 필드들의 값을 얻는 함수이다.
    * @param collectionName
    * @param fields
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int setResultField(String collectionName, String fields) {
       int ret = 0;
       ret = search.w3SetDocumentField(collectionName, fields);
       systemOut("[w3SetDocumentField] " + collectionName + " / " + fields);
       return ret;
   }

   /**
    * 해당 컬렉션의 몇 번째 검색 결과부터 몇 개를
    * 가져올 것인지를 지정하고 하이라이트 기능과 요약기능을 지정하는 함수이다.
    * 검색 API v3.5에서는 w3SetHighlight의 파라미터가 2개이지만 v3.7에서는 3개이다.
    * @param collName
    * @param highlight
    * @param startPos
    * @param resultCnt
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int setPageInfo(String collName, int highlight, int startPos,
           int resultCnt) {
       int ret = 0;
       if (highlight == 1) { //OFF, ON
           ret = search.w3SetHighlight(collName, 0, 1);
       } else if (highlight == 2) { //ON , OFF
           ret = search.w3SetHighlight(collName, 1, 0);
       } else if (highlight == 3) { //ON, ON
           ret = search.w3SetHighlight(collName, 1, 1);
       } else {//OFF, OFF
           ret = search.w3SetHighlight(collName, 0, 0);
       }
       // 페이지, 기본정렬 설정
       ret = search.w3SetPageInfo(collName, startPos, resultCnt);

       return ret;
   }

   /**
    * 검색한 결과 날짜/시간 범위를 지정하고
    * 시작날짜와 종료날짜의 형식이 YYYY/MM/DD가 아니라면
    * 변경할 문자를 인자로 지정한다.
    * @param collectionName
    * @param startDate
    * @param endDate
    * @param replaceChr
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int setDateRange(String collectionName, String startDate,
           String endDate, String replaceChr) {
       // 날짜 조건 세팅
       int ret = 0;
       if (!startDate.equals("") && !endDate.equals("")) {
           startDate = replace(startDate, replaceChr, "/");
           endDate = replace(endDate, replaceChr, "/");
           ret = search.w3SetDateRange(collectionName, startDate, endDate);
       }
       return ret;
   }

   /**
    *
    * @param collectionName
    * @param field
    * @param matchType
    * @param boostID
    * @param boostKeyword
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    * @deprecated  As of v4.x, replaced by
    * {@link #setBoostCategory(String,String,String,String)}
    */
   public int setCategoryBoost(String collectionName, String field,
           String matchType, String boostID, String boostKeyword) {
       int ret = 0;
       ret = search.w3SetBoostCategory(collectionName, field, matchType, boostKeyword);
       return ret;
   }

   /**
    *
    * @param collectionName
    * @param field
    * @param matchType
    * @param boostID
    * @param boostKeyword
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int setBoostCategory(String collectionName, String field,
           String matchType, String boostID, String boostKeyword) {
       return search.w3SetBoostCategory(collectionName, field, matchType, boostKeyword);
   }
	
   /**
    * 검색결과에서 중복문서 정렬 기준을 설정한다.
    * @param collectionName Collection 명
     * @param categoryGroup Category 그룹정보
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int addDuplicateDetectionCriterionField(String collection, String field, int nOrder) {        	
   	int ret = -1;
   	ret = search.w3AddDuplicateDetectionCriterionField(collection, field, nOrder);
       return ret;
   }
   
   
   /**
    * 검색결과에서 중복문서 정렬 기준을 설정한다.
    * @param collectionName Collection 명
     * @param categoryGroup Category 그룹정보
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int setDuplicateDetectionCriterionField(String collection, String fieldList ) {        	
   	int ret = -1;
   	ret = search.w3SetDuplicateDetectionCriterionField(collection, fieldList);
       return ret;
   }
   
   /**
    * 검색결과 패킷에 카테고리 지정 컬렉션의 카테고리 필드에서 Depth별 Category의 리스트를 포함시킨다.
    * @param collectionName Collection 명
     * @param categoryGroup Category 그룹정보
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int addCategoryGroupBy(String collectionName, String[] categoryGroup) {        	
   	int ret = -1;
       int length = categoryGroup.length;
       for(int i=0; i < length; i++) {
      		String[] dataFields = split(categoryGroup[i], ":");
			if(dataFields.length == 2){
				//depthList depth의 list를 콤마(:) 로 구분하여 입력
				ret = search.w3AddCategoryGroupBy(collectionName, dataFields[0], dataFields[1]);
			}
       }
       return ret;
   }

    /**
    * 선택한 컬렉션 내의 선택 카테고리 필드의 값으로 검색결과를 필터링 한다.
    * 혹은 다른 쿼리없이 본쿼리를 실행하면 해당 카테고리의 값에 매치되는 문서를 출력한다.
    * @param collectionName Collection 명
    * @param categoryQuery
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int addCategoryQuery(String collectionName, String[] categoryQuery) {
  		int ret = -1;
       int length = categoryQuery.length;
       for(int i=0; i < length; i++) {
      	String[] dataFields = split(categoryQuery[i], "/");
			if(dataFields.length == 2){
				ret = search.w3AddCategoryQuery(collectionName, dataFields[0], dataFields[1]);
			}
       }
       return ret;
   }

   /**
    * w3SetCategoryGroupBy를 통해 패킷에 포함된 해당 collection-field-depth를 key로 하는
     * 카테고리의 총 개수를 반환
    * @param collectionName 검색 대상 collection명
     * @param fieldName Category Field 명
     * @param depth 현재 그룹핑하여 보고자 하는 depth
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int getCategoryCount(String collectionName, String field, int depth) {
       return search.w3GetCategoryCount(collectionName, field, depth);
   }

   /**
    * w3SetCategoryGroupBy를 통해 패킷에 포함된 해당 collection-field-depth를 key로 하는
     * 카테고리 중 categoryIdx번째의 완전한 카테고리 이름을 반환
    * @param collectionName 검색 대상 collection명
     * @param fieldName Category Field 명
     * @param depth 현재 그룹핑하여 보고자 하는 depth
     * @param idx 해당 컬렉션-카테고리-Depth에 해당하는 카테고리 결과의 인덱스
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public String getCategoryName(String collectionName, String field, int depth, int idx){
       return search.w3GetCategoryName(collectionName, field, depth, idx);
   }

    /**
    * w3SetCategoryGroupBy를 통해 패킷에 포함된 해당 collection-field-depth를 key로 하는 카테고리 중
     * categoryIdx번째의 카테고리안에 몇 개의 문서가 포함되어있는지(검색 결과내에서)를 반환
    * @param collectionName 검색 대상 collection명
     * @param fieldName Category Field 명
     * @param depth 현재 그룹핑하여 보고자 하는 depth
     * @param idx 해당 컬렉션-카테고리-Depth에 해당하는 카테고리 결과의 인덱스
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int getDocumentCountInCategory(String collectionName, String field, int depth, int idx){
       return search.w3GetDocumentCountInCategory(collectionName, field, depth, idx);
   }

   /**
   * 특정 필드의 값을 기준으로 범위 별로 그룹을 만들거나, 이 필드 값이 특정 범위에 속하는 레코드만 추출
   * @ collectionName
   * @ field
   * @ min
   * @ max
   * @ groupCount
   */
   public int setPropertyGroup(String collectionName, String field, int min, int max, int groupCount) {
       int ret = 0;
       ret = search.w3SetPropertyGroup(collectionName, field, min, max, groupCount);
       return ret;
   }

   /**
    * v3.7에서는 2개의 전달인자 v4.0에서는 3개의 전달인자
    * @param collectionName
    * @param field
    * @param docCount
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int setGroupBy(String collectionName, String field, int docCount) {
       int ret = 0;
       ret = search.w3SetGroupBy(collectionName, field, docCount);
       return ret;
   }

   /**
     * 단순히 최종 결과에서 특정 필드(들)값의 그룹핑된 결과를 얻어오기 원할 때 사용
     * @param collectionName 컬렉션명
     * @param fieldName 그룹핑할 필드명
     * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int addMultiGroupBy(String collectionName, String fields) {
       int ret = 0;
       String[] field = split(fields, ",");
       int length = field.length;
       for(int i = 0; i < length; i++ ) {
           ret = search.w3AddMultiGroupBy(collectionName, field[i]);
       }
       return ret ;
   }

   public int setMultiGroupBy (String collectionName, String fields) {
       return search.w3SetMultiGroupBy(collectionName, fields);
   }

   /**
     * 멀티 그룹바이된 결과를 반환
     * @param collectionName 컬렉션명
     * @param fieldName 그룹핑할 필드명
     * @return 성공 시 해당 컬렉션 결과에서 인자로 주어진 필드의 그룹핑 결과 문자열을 반환하며, 에러 발생시 빈 문자열을 반환
    */
   public String getMultiGroupByResult(String collectionName, String field) {
       String ret = "";
       ret = search.w3GetMultiGroupByResult(collectionName, field);
       return ret ;
   }

   /**
    * 그룹 검색결과의 정렬필드를 설정한다.
    * @param collectionName
    * @param sortField
    * @param sortOrder
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int addSortFieldInGroup(String collectionName, String sortField,
           int sortOrder) {
       int ret = 0;
       ret = search.w3AddSortFieldInGroup(collectionName, sortField,
               sortOrder);
       systemOut("[w3AddSortFieldInGroup] " + collectionName + " / "
               + sortField);
       return ret;
   }

   /**
    * 그룹내의 문서들의 정렬 정보들을 지정해 주는 함수
    * @param collectionName
    * @param sortValue url/DESC,RANK/DESC,DATE/ASC
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int setSortFieldInGroup(String collectionName, String sortValue) {
       int ret = 0;
       ret = search.w3SetSortFieldInGroup(collectionName, sortValue);
       systemOut("[w3SetSortFieldInGroup] " + collectionName + " / " + sortValue);
       return ret;
   }


   /**
    * 권한 쿼리 (Authority Query)
    * @param collection
    * @param authTargetField
    * @param authCollection
    * @param authReferField
    * @param authorityQuery
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int setAuthorityQuery(String collection, String authTargetField,
           String authCollection, String authReferField, String authorityQuery ) {
       int ret = search.w3SetAuthorityQuery(collection, authTargetField,
               authCollection, authReferField, authorityQuery);
       systemOut("[w3SetAuthorityQuery]" + authorityQuery);
       return ret;
   }

   /**
    *
    * @param collectionName
    * @return 검색기로부터 받아온 속성 그룹의 개수를 반환
    */
   public int getCountPropertyGroup(String collectionName) {
       return search.w3GetCountPropertyGroup(collectionName);
   }

   /**
    *
    * @param collectionName
    * @return 전체 그룹 개수
    */
   public int getResultGroupCount(String collectionName) {
       return search.w3GetResultGroupCount(collectionName);
   }


   /**
    *
    * @param collectionName
    * @return 전체 그룹 개수
    */
   public int getResultTotalGroupCount(String collectionName) {
       return search.w3GetResultTotalGroupCount(collectionName);
   }

   /**
    *
    * @param collectionName
    * @parma groupIndex
    * @return 그룹에 속하는 문서 중 가져온 문서 개수
    */
   public int getCountInGroup(String collectionName, int groupIndex) {
       return search.w3GetCountInGroup(collectionName, groupIndex);
   }

   /**
    *
    * @param collectionName
    * @parma groupIndex
    * @return 그룹에 속하는 전체문서 개수
    */
   public int getTotalCountInGroup(String collectionName, int groupIndex) {
       return search.w3GetTotalCountInGroup(collectionName, groupIndex);
   }


   /**
    *
    * @param collectionName
    * @return 성공시 해당 속성 그룹의 최소값을 반환하며, 에러 발생시 음수를 반환
    */
   public int getMinValuePropertyGroup(String collectionName){
       return search.w3GetMinValuePropertyGroup(collectionName);
   }

   /**
    *
    * @param collectionName
    * @return 성공시 해당 속성 그룹의 최대값을 반환하며, 에러 발생시 음수를 반환
    */
   public int getMaxValuePropertyGroup(String collectionName){
       return search.w3GetMaxValuePropertyGroup(collectionName);
   }

   /**
    *
    * @param collectionName
    * @parma groupIndex
    * @return 성공시 속성 그룹 결과의 최소값을 반환하며, 에러 발생시 음수를 반환
    */
   public int getMinValueInPropertyGroup(String collectionName, int groupIndex){
       return search.w3GetMinValueInPropertyGroup(collectionName, groupIndex);
   }

   /**
    *
    * @param collectionName
    * @parma groupIndex
    * @return 성공시 속성 그룹 결과의 최대값을 반환하며, 에러 발생시 음수를 반환
    */
   public int getMaxValueInPropertyGroup(String collectionName, int groupIndex){
       return search.w3GetMaxValueInPropertyGroup(collectionName, groupIndex);
   }


   /**
    *
    * @param collectionName
    * @parma groupIndex
    * @return 지정된 속성 그룹 내 문서개수를 반환
    */
   public int getDocumentCountInPropertyGroup(String collectionName, int groupIndex){
       return search.w3GetDocumentCountInPropertyGroup(collectionName, groupIndex);
   }

   /**
    * 그룹화된 문서 중 지정된 순서의 그룹 내에서 주어진 collection 결과 에서 index 번째 문서의 Collection ID를 반환
    * @param collectionName
    * @param groupIndex
    * @param docIndex
    * @return 그룹에 속하는 문서중 원하는 문서의 필드값
    */
   public String getCollectionIdInGroup(String collectionName,	int groupIndex, int docIndex) {
       return search.w3GetCollectionIdInGroup(collectionName, groupIndex, docIndex);
   }

   /**
    *
    * @param collectionName
    * @param groupIndex
    * @param docIndex
    * @return 그룹에 속하는 문서중 원하는 문서의 필드값
    */
   public long getRankInGroup(String collectionName,	int groupIndex, int docIndex) {
       return search.w3GetRankInGroup(collectionName, groupIndex, docIndex);
   }

   /**
    *
    * @param collectionName
    * @param groupIndex
    * @param docIndex
    * @return 그룹에 속하는 문서중 원하는 문서의 필드값
    */
   public String getFieldInGroup(String collectionName, String fieldName,
           int groupIndex, int docIndex) {
       return search.w3GetFieldInGroup(collectionName, fieldName,
               groupIndex, docIndex);
   }

   /**
    *
    * @param collectionName
    * @param groupIndex
    * @param docIndex
    * @return 그룹에 속하는 문서중 원하는 문서의 uid값
    */
   public long getUidInGroup(String collectionName, int groupIndex,
           int docIndex) {
       return search.w3GetUidInGroup(collectionName, groupIndex, docIndex);
   }

   /**
    *
    * @param collectionName
    * @param groupIndex
    * @param docIndex
    * @return 그룹에 속하는 문서중 원하는 문서의 가중치 값
    */
   public long getWeightInGroup(String collectionName, int groupIndex,
           int docIndex) {
       return search.w3GetWeightInGroup(collectionName, groupIndex,
               docIndex);
   }

   /**
    *
    * @param collectionName
    * @param groupIndex
    * @param docIndex
    * @return 그룹에 속하는 문서중 원하는 문서의 날짜 정보
    */
   public String getDateInGroup(String collectionName, int groupIndex,
           int docIndex) {
       return search
               .w3GetDateInGroup(collectionName, groupIndex, docIndex);
   }

   /**
    *
    * @param collectionName
    * @param groupIndex
    * @param docIndex
    * @return 그룹에 속하는 문서중 원하는 문서의 sc 정보
    */
   public String getSearcherIdInGroup(String collectionName, int groupIndex,
           int docIndex) {
       return search.w3GetSearcherIdInGroup(collectionName, groupIndex, docIndex);
   }


   /**
    * v4.x 호환 method
    * v5.0에서는 삭제되었다.
    * 하이라이팅될 문자열을 보여주는 함수이다.
    * @return 하이라이팅될 문자열
   public String getHighlightKeyword() {
       String keyWord = this.search.w3GetHighlightKeyword().trim();
       return keyWord;
   }
    */

   /**
    * 형태소 분석된 결과 문자열을 보여주는 함수이다.
    * @param colName
    * @param field
    * @return 하이라이팅될 문자열
    */
   public String getHighlightKeywordByField(String colName,
           String searchField) {
       String keyWord = this.search.w3GetHighlightByField(colName,
               searchField);
       return keyWord;
   }

   /**
    *
    * @param collectionName
    * @return 검색결과 개수
    */
   public int getResultCount(String collectionName) {
       return search.w3GetResultCount(collectionName);
   }

   /**
    *
    * @param collectionName
    * @return 검색결과 총 개수
    */
   public int getResultTotalCount(String collectionName) {
       return search.w3GetResultTotalCount(collectionName);
   }


   /**
    *
    * @param collectionName
    * @param idx
    * @return 검색한 해당 문서의 중복문서 개수를 반환
    */
   public int getDuplicateDocumentCount(String collectionName, int idx) {
       return search.w3GetDuplicateDocumentCount(collectionName, idx);
   }

   /**
    *
    * @param collectionName
    * @param groupIndex
    * @param docIndex
    * @return 그룹화된 문서 중 지정된 순서의 그룹 내에서 각 결과들이 중복된 문서의 개수를 반환
    */
   public int getDuplicateDocumentCountInGroup(String collectionName, int groupIndex,
           int docIndex) {
       return search.w3GetDuplicateDocumentCountInGroup(collectionName, groupIndex, docIndex);
   }

   /**
    * 최근에 검색된 키워드리스트를 반환한다.
    * @param count
    * @return 최근에 검색된 키워드리스트
    */
   public String[] receiveRecentQueryListResult(int mode, int count) {
       int ret = search.w3ReceiveRecentQueryListResult(mode, count);
       if( ret < 0 ){
           systemOut("[W3ReceiveRecentQueryListResult] " + search.w3GetErrorInfo() + ", ret=" + ret);
           return null;
       }
       int size = search.w3GetRecentQueryListSize();
       String[] keyList = new String[size];
       for(int i=0; i<size; i++ ){
           keyList[i] = search.w3GetRecentQuery(i);
       }
       return keyList;
   }

   /**
    * 최근에 검색된 키워드리스트를 반환한다.
    * @param count
    * @return 최근에 검색된 키워드리스트
    */
   public int receiveRecentQueryListResultAsXml(int mode, int count) {
       int ret = search.w3ReceiveRecentQueryListResultAsXml(mode, count);
       if( ret < 0 ){
           systemOut("[w3ReceiveRecentQueryListResultAsXml] " + search.w3GetErrorInfo() + ", ret=" + ret);
           return -1;
       }
       return ret;
   }

   /**
    * 최근에 검색된 키워드리스트를 반환한다.
    * @param count
    * @return 최근에 검색된 키워드리스트
    */
   public int receiveRecentQueryListResultAsJson(int mode, int count) {
       int ret = search.w3ReceiveRecentQueryListResultAsJson(mode, count);
       if( ret < 0 ){
           systemOut("[w3ReceiveRecentQueryListResultAsJson] " + search.w3GetErrorInfo() + ", ret=" + ret);
           return -1;
       }
       return ret;
   }


   /**
   */
   public String getSuggestedQuery() {
       return search.w3GetSuggestedQuery();
   }

   /**
    * v4.x 호환 method
    * @param mode
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    * @deprecated  As of v4.x, replaced by
    * {@link #receiveSearchQueryResult(int)}
    */
   public int recvResult(int mode) {
       int ret = search.w3ReceiveSearchQueryResult(mode);
       return ret;
   }

   /**
   *
   */
   public int recvDuplicateDocumentsResult(int mode) {
       int ret = search.w3ReceiveDuplicateDocumentsResult(mode);
       return ret;
   }

   /**
   *
   */
   public int recvDuplicateDocumentsResultAsJson(int mode) {
       int ret = search.w3ReceiveDuplicateDocumentsResultAsJson(mode);
       return ret;
   }

   /**
   *
   */
   public int recvDuplicateDocumentsResultAsXml(int mode) {
       int ret = search.w3ReceiveDuplicateDocumentsResultAsXml(mode);
       return ret;
   }


   /**
    *
    * @param mode
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int receiveSearchQueryResult(int mode) {
       int ret = search.w3ReceiveSearchQueryResult(mode);
       return ret;
   }

   /**
    *
    * @param mode
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int receiveSearchQueryResultAsXml(int mode) {
       int ret = search.w3ReceiveSearchQueryResultAsXml(mode);
       return ret;
   }


   /**
    *
    * @param mode
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int receiveSearchQueryResultAsJson(int mode) {
       int ret = search.w3ReceiveSearchQueryResultAsJson(mode);
       return ret;
   }

   /**
    *
    * @return 성공이면 검색결과를 XML로 반환한다.
    */
   public String getResultXml() {
       String ret = search.w3GetResultXml();
       return ret;
   }

   /**
    *
    * @return 성공이면 검색결과를 JSON data로 반환한다.
    */
   public String getResultJson() {
       String ret = search.w3GetResultJson();
       return ret;
   }

   /**
    * UID 검색을 검색기에 전달하고, 결과를 받는 함수이다.
    * v4.x 호환 method
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    * @deprecated  As of v4.x, replaced by
    * {@link #receiveUidResult(int)}
    */
   public int recvDocument(int mode) {
       int ret = search.w3ReceiveUidResult(mode);
       return ret;
   }

   /**
    * UID 검색을 검색기에 전달하고, 결과를 받는 함수이다.
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int receiveUidResult(int mode) {
       int ret = search.w3ReceiveUidResult(mode);
       return ret;
   }

   /**
    * UID 검색을 검색기에 전달하고, 결과를 받는 함수이다.
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int receiveUidResultAsXml(int mode) {
       int ret = search.w3ReceiveUidResultAsXml(mode);
       return ret;
   }

   /**
    * UID 검색을 검색기에 전달하고, 결과를 받는 함수이다.
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int receiveUidResultAsJson(int mode) {
       int ret = search.w3ReceiveUidResultAsJson(mode);
       return ret;
   }

   /**
    * v4.x 호환 method
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    * @deprecated  As of v4.x, replaced by
    * {@link #receiveMorphemeAnalysisResult(int)}
    */
   public int recvAnalyzedQuery(int mode) {
       int ret = search.w3ReceiveMorphemeAnalysisResult(mode);
       return ret;
   }

   /**
    *
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int receiveMorphemeAnalysisResult(int mode) {
       int ret = search.w3ReceiveMorphemeAnalysisResult(mode);
       return ret;
   }

   /**
    *
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int receiveMorphemeAnalysisResultAsXml(int mode) {
       int ret = search.w3ReceiveMorphemeAnalysisResultAsXml(mode);
       return ret;
   }

   /**
    *
    * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
    */
   public int receiveMorphemeAnalysisResultAsJson(int mode) {
       int ret = search.w3ReceiveMorphemeAnalysisResultAsJson(mode);
       return ret;
   }


   /**
    * 주어진 collection 결과 에서 index 번째 문서의 Collection ID를 반환한다.
    * @param coll
    * @param idx
    * @return FIELD VALUE
    */
   public String getCollectionId(String coll, int idx) {
       return search.w3GetCollectionId(coll, idx);
   }

   /**
    *
    * @param coll
    * @param field
    * @param idx
    * @return FIELD VALUE
    */
   public String getField(String coll, String field, int idx) {
       return search.w3GetField(coll, field, idx);
   }

   /**
    *
    * @param coll
    * @param idx
    * @return DATE
    */
   public String getDate(String coll, int idx) {
       return search.w3GetDate(coll, idx);
   }

   /**
    *
    * @param coll
    * @param idx
    * @return DATE
    */
   public long getWeight(String coll, int idx) {
       return search.w3GetWeight(coll, idx);
   }

   /**
    *
    * @param coll
    * @param idx
    * @return RANK
    */
   public long getRank(String coll, int idx) {
       return search.w3GetRank(coll, idx);
   }

   /**
    *
    * @param coll
    * @param idx
    * @return UID
    */
   public long getUid(String coll, int idx) {
       return search.w3GetUid(coll, idx);
   }

   /**
    *
    * @param coll
    * @param idx
    * @return SearcherId
    */
   public String getSearcherId(String coll, int idx) {
       return search.w3GetSearcherId(coll, idx);
   }

   /*
     * 여러 컬렉션의 검색결과를 하나의 가상 컬렉션(Merge Collection) 결과로 통합하여 가져오기 원할 때 사용하는 함수
     * @param mergeCollection 통합 가상 컬렉션명
     * @param collections[] (통합대상) 컬렉션명
     * @param start (결과 중) 시작 문서 인덱스
     * @param count (결과 중) 가져올 문서 개수
     * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
     */
   public int addMergeCollectionInfo(String mergeCollection, String[] collections, int start, int count ){
       int collectionLen = collections.length;
       int ret = 0;

       for(int i=0; i < collectionLen; i++) {

           ret = search.w3AddMergeCollection(mergeCollection, collections[i]);
       }

       ret = search.w3SetMergePageInfo(mergeCollection, start, count);

       return ret;
   }

   /*
     * 통합 컬렉션(Merge Collection)의 결과 필드(Document Field)와 통합될 개별 컬렉션의 결과 필드를 1:N ( 0 < N < 64 ) 관계로 연결시킨다
     * @param mergeCollection 통합 가상 컬렉션명
     * @param mergeFields[] 가상 통합 컬렉션의 결과 필드명
     * @param collections[] (통합대상) 컬렉션명
     * @param fields[,] (통합대상) 컬렉션의 결과 필드명
     * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
     */
   public int addMergeDocumentField(String mergeCollection, String[] mergeFields, String[] collections, String[][] fields) {
       int ret = 0;
       int collectionLen = collections.length;
       int fieldsLen = mergeFields.length;

       for(int i=0; i < collectionLen; i++) {

           for(int j=0; j<fieldsLen; j++) {
               ret = search.w3AddMergeDocumentField(mergeCollection, mergeFields[j], collections[i], fields[i][j]);
           }
       }
       return ret;
   }

     /*
      * w3AddMergeDocumentField 함수가 통합 컬렉션의 결과 필드를 정의 하였다면, 이 함수는 통합 컬렉션의
      * MultiGroupBy 필드명의 정의 및 개별 컬렉션의 MultiGroupBy 필드명과 연결시키는 역할
      * @param mergeCollection 통합 가상 컬렉션명
      * @param mergeFields[] 가상 통합 컬렉션의 결과 필드명
      * @param collections[] (통합대상) 컬렉션명
      * @param fields[,] (통합대상) 컬렉션의 결과 필드명
      * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
      */
   public int addMergeMultiGroupByField(String mergeCollection, String[] mergeFields, String[] collections, String[][] fields) {
       int ret = 0;
       int collectionLen = collections.length;
       int fieldsLen = mergeFields.length;
       for(int i=0; i < collectionLen; i++) {
           for(int j=0; j<fieldsLen; j++) {
               ret = search.w3AddMergeMultiGroupByField(mergeCollection, mergeFields[j], collections[i], fields[i][j]);
           }
       }
       return ret;
   }

   /*
     * 통합 컬렉션의 CategoryGroupBy 필드명의 정의 및 개별 컬렉션의
     * CategoryGroupBy 필드명과 연결시키는 역할
     * @param mergeCollection 통합 가상 컬렉션명
     * @param mergeFields[] 가상 통합 컬렉션의 결과 필드명
     * @param collections[] (통합대상) 컬렉션명
     * @param fields[,] (통합대상) 컬렉션의 결과 필드명
     * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
     */
   public int addMergeCategoryGroupByField(String mergeCollection, String[] mergeFields, String[] collections, String[][] fields) {
       int ret = 0;
       int collectionLen = collections.length;
       int fieldsLen = mergeFields.length;
       for(int i=0; i < collectionLen; i++) {
           for(int j=0; j<fieldsLen; j++) {
               ret = search.w3AddMergeCategoryGroupByField(mergeCollection, mergeFields[j], collections[i], fields[i][j]);
           }
       }
       return ret;
   }

   /*
     * 검색기에서 받아올 통합 컬렉션(Merge Collection) 결과의 시작 인덱스와 문서 개수를 설정
     * CategoryGroupBy 필드명과 연결시키는 역할
     * @param mergeCollection 통합 가상 컬렉션명
     * @param collections (통합대상) 컬렉션명
     *
     * @return 문서 개수 반환한다.
     */
   public int getResultTotalCountInMerge(String mergeCollection, String collection){
       return search.w3GetResultTotalCountInMerge(mergeCollection, collection);
   }

   /**
    * 네트워크 종료
    */
   public void closeServer() {
       if (search != null) {
           search.w3CloseServer();
           search = null;
       }
   }

   /**
    * 인자로 전달받은 collection의 검색결과의 에러가 발생하면 에러 코드와 메시지를 반환한다.
    * @param collectionName
    * @return
    */
   public String getCollectionErrorInfo(String collectionName) {
       String errorMsg = "";
       int errorCode = search.w3GetCollectionError(collectionName);
       if (errorCode != 0) {
           errorMsg = search.w3GetCollectionErrorInfo(collectionName);
           errorMsg = errorMsg + "(<b>code:<font color='red'>" + errorCode
                   + "</font></b>)";
       }
       return errorMsg;
   }



   /**
    * 검색결과의 에러가 발생하면 에러 코드와 메시지를 반환한다.
    * @return
    */
   public String getErrorInfo() {
       String errorMsg = "";
       int errorCode = search.w3GetError();
       if (errorCode != 0) {
           errorMsg = search.w3GetErrorInfo();
           errorMsg = errorMsg + "(<b>code:<font color='red'>" + errorCode
                   + "</font></b>)";
       }
       return errorMsg;
   }

   /**
    * 검색 api의 버전정보를 반환한다.
    * @return
    */
   public String getVersionInfo() {
       return search.w3GetVersionInfo();
   }



   /**
    * 에러 코드에 대한 에러정보를 web application의 standard out log에 출력한다.
    * @param msg
    */
   public void systemOut(String msg) {
       if (out != null && isDebug) {
           try {
               out.println(msg + "<br>");
           } catch (IOException e) {
               e.printStackTrace();
           }
       }
   }
}
%>