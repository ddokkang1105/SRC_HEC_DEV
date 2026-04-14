<%@ page pageEncoding = "UTF-8" %><%!
    /**
    *  subject: 검색 환경 설정 페이지
    **/

    final static int CONNECTION_TIMEOUT = 20000;
	final static String CHARSET = "UTF-8";
	final static int REALTIME_COUNT=100;
	final static int PAGE_SCALE = 10; //view page list count

	final static int CONNECTION_KEEP = 0; //recevive mode
	final static int CONNECTION_REUSE = 2;
	final static int CONNECTION_CLOSE = 3;

	final static int ASC = 0; //order
	final static int DESC = 1; //order

	final static int USE_KMA_OFFOFF = 0; //synonym, morpheme
	final static int USE_KMA_ONON = 1;
	final static int USE_KMA_ONOFF = 2;
	
	final static int USE_RESULT_STRING = 0; //result data type	
	final static int USE_RESULT_XML = 1;
	final static int USE_RESULT_JSON = 2;
	final static int USE_RESULT_DUPLICATE_STRING = 3; //uid result data type	
	final static int USE_RESULT_DUPLICATE_XML = 4;
	final static int USE_RESULT_DUPLICATE_JSON = 5;

	final static int IS_CASE_ON = 1; //case on, off
	final static int IS_CASE_OFF = 0;

	final static int HI_SUM_OFFOFF = 0; //summarizing, highlighting
	final static int HI_SUM_OFFON = 1;
	final static int HI_SUM_ONOFF = 2;
	final static int HI_SUM_ONON = 3;
			
	final static int COMMON_OR_WHEN_NORESULT_OFF = 0;
	final static int COMMON_OR_WHEN_NORESULT_ON = 1;

	final static int INDEX_NAME = 0;
	final static int COLLECTION_NAME = 1;
	final static int PAGE_INFO = 2;
	final static int ANALYZER = 3;
	final static int SORT_FIELD = 4;
	final static int RANKING_OPTION = 5;
	final static int SEARCH_FIELD = 6;
	final static int RESULT_FIELD = 7;
	final static int DATE_RANGE = 8;
	final static int RANK_RANGE = 9;
	final static int EXQUERY_FIELD = 10;
	final static int COLLECTION_QUERY =11;
	final static int BOOST_QUERY =12;
	final static int FILTER_OPERATION = 13;
	final static int GROUP_BY = 14;
	final static int GROUP_SORT_FIELD = 15;
	final static int CATEGORY_BOOST = 16;
	final static int CATEGORY_GROUPBY = 17;
	final static int CATEGORY_QUERY = 18;
	final static int PROPERTY_GROUP = 19;
	final static int PREFIX_FIELD = 20;
	final static int FAST_ACCESS = 21;
	final static int MULTI_GROUP_BY = 22;
	final static int AUTH_QUERY = 23;
	final static int DEDUP_SORT_FIELD = 24;
	final static int COLLECTION_KOR = 25;	
	
	final static int MERGE_COLLECTION_NAME = 0;
	final static int MERGE_MAPPING_COLLECTION_NAME = 1;
	final static int MERGE_PAGE_INFO = 2;
	final static int MERGE_RESULT_FIELD = 3;
	final static int MERGE_MAPPING_RESULT_FIELD = 4;
	final static int MERGE_MULTI_GROUP_BY_FIELD = 5;
	final static int MERGE_MAPPING_MULTI_GROUP_BY_FIELD = 6;
	final static int MERGE_CATEGORY_GROUPBY_FIELD = 7;
	final static int MERGE_MAPPING_CATEGORY_GROUPBY_FIELD = 8;
%>