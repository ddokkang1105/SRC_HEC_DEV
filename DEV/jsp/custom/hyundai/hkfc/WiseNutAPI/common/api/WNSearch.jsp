<%@ page contentType="text/html; charset=UTF-8"%><%@ page import="java.util.*,
				 java.io.IOException,
	             javax.servlet.jsp.JspWriter"%><%@
include file="./WNAnchor.jsp" %><%@
include file="../WNCollection.jsp" %><%@
include file="./WNCommon.jsp" %><%!
	/**
	 *  file: WNSearch.jsp
	 *  subject: 검색페이지에서 사용되는 메소드를 정의한 클래스
	 *  ------------------------------------------------------------------------
	 *  @original author: WISEnut
	 *  @edit author: WISEnut
	 *  @update date 2012.04.24
	 *  ------------------------------------------------------------------------
	 */
	public class WNSearch {
		private WNCommon common ;
		private WNCollection wncol;
		private String[] collections ;
		private String[] mergeCollections ;
		private String[] searchFields;
		private String managerURL = "";
		private int hiSum = 0;
		private int connectionOpt = 0;
		private StringBuffer sb = null;
		private StringBuffer warningMsg = null;

		private String searcherId = "";
		private boolean isDebug = false;
		private boolean isUidSrch = false;
		private int resultType = 0;
		
		public String realTimeKeywords= "";
		public String suggestedQuery = "";
		/**
		 * WNCommon객체를 생성하고 검색 대상 컬렉션과 검색 대상 필드들을 설정한다.
		 * @param searcherId 검색 대상 sc id
		 * @param isDebug 검색설정을 화면에 출력할 것인지 여부를 결정
		 * @param isUidSrch 키워드 검색을 할 것인지 UID 검색을 할 것인지 여부를 결정
		 * @param collections 검색하고자 하는 컬렉션들을 Array로 지정한다.
		 * @param searchFields 검색하고자 하는 검색필드들을 Array로 지정한다.
		 */
		public WNSearch(String searcherId, boolean isDebug, boolean isUidSrch, 
				String[] collections, String[] searchFields){
		    this.common = new WNCommon();
		    this.wncol = new WNCollection();
		    this.collections = collections;
		    this.searchFields = searchFields;
		    this.sb = new StringBuffer();
		    this.warningMsg = new StringBuffer();
		    this.isDebug = isDebug;
		    this.isUidSrch = isUidSrch;
		    this.searcherId = searcherId;
		}
		
		/**
		 * WNCommon객체를 생성하고 검색 대상 컬렉션과 검색 대상 필드들을 설정한다.
		 * @param searcherId 검색 대상 sc id
		 * @param isDebug 검색설정을 화면에 출력할 것인지 여부를 결정
		 * @param isUidSrch 키워드 검색을 할 것인지 UID 검색을 할 것인지 여부를 결정
		 * @param collections 검색하고자 하는 컬렉션들을 Array로 지정한다.
		 * @param searchFields 검색하고자 하는 검색필드들을 Array로 지정한다.
		 * @param resultType 검색결과를 반환받고자 하는 데이터 형태
		 */
		public WNSearch(String searcherId, boolean isDebug, boolean isUidSrch, 
				String[] collections, String[] searchFields, int resultType){
		    this.common = new WNCommon();
		    this.wncol = new WNCollection();
		    this.collections = collections;
		    this.searchFields = searchFields;
		    this.sb = new StringBuffer();
		    this.warningMsg = new StringBuffer();
		    this.isDebug = isDebug;
		    this.isUidSrch = isUidSrch;
		    this.searcherId = searcherId;
		    this.resultType = resultType;
		}
		
		/**
		 * WNCommon객체를 생성하고 검색 대상 컬렉션과 검색 대상 필드들을 설정한다.
		 * @param searcherId 검색 대상 sc id
		 * @param isDebug 검색설정을 화면에 출력할 것인지 여부를 결정
		 * @param isUidSrch 키워드 검색을 할 것인지 UID 검색을 할 것인지 여부를 결정
		 * @param collections 검색하고자 하는 컬렉션들을 Array로 지정한다.
		 * @param mergeCollections 검색하고자 하는 가상통합컬렉션을 Array로 지정한다.
		 * @param searchFields 검색하고자 하는 검색필드들을 Array로 지정한다.
		 * @param resultType 검색결과를 반환받고자 하는 데이터 형태
		 */
		public WNSearch(String searcherId, boolean isDebug, boolean isUidSrch, 
				String[] collections, String[] mergeCollections, String[] searchFields, int resultType){
		    this.common = new WNCommon();
		    this.wncol = new WNCollection();
		    this.collections = collections;
		    this.mergeCollections = mergeCollections;
		    this.searchFields = searchFields;
		    this.sb = new StringBuffer();
		    this.warningMsg = new StringBuffer();
		    this.isDebug = isDebug;
		    this.isUidSrch = isUidSrch;
		    this.searcherId = searcherId;
		    this.resultType = resultType;
		}

		/**
		 * WNCommon객체를 생성하고 검색 대상 컬렉션과 검색 대상 필드들을 설정한다.
		 * @param isDebug 검색설정을 화면에 출력할 것인지 여부를 결정
		 * @param isUidSrch 키워드 검색을 할 것인지 UID 검색을 할 것인지 여부를 결정
		 * @param collections 검색하고자 하는 컬렉션들을 Array로 지정한다.
		 * @param searchFields 검색하고자 하는 검색필드들을 Array로 지정한다.
		 * @param resultType 검색결과를 반환받고자 하는 데이터 형태
		 */
		public WNSearch(boolean isDebug, boolean isUidSrch, String[] collections, 
				String[] searchFields, int resultType){
		    this.common = new WNCommon();
		    this.wncol = new WNCollection();
		    this.collections = collections;
		    this.searchFields = searchFields;
		    this.sb = new StringBuffer();
		    this.warningMsg = new StringBuffer();
		    this.isDebug = isDebug;
		    this.isUidSrch = isUidSrch;
		    this.resultType = resultType;
		}
		
		/**
		 * WNCommon객체를 생성하고 검색 대상 컬렉션과 검색 대상 필드들을 설정한다.
		 * @param isDebug 검색설정을 화면에 출력할 것인지 여부를 결정
		 * @param isUidSrch 키워드 검색을 할 것인지 UID 검색을 할 것인지 여부를 결정
		 * @param collections 검색하고자 하는 컬렉션들을 Array로 지정한다.
		 * @param mergeCollections 검색하고자 하는 가상통합컬렉션을 Array로 지정한다.
		 * @param searchFields 검색하고자 하는 검색필드들을 Array로 지정한다.
		 * @param resultType 검색결과를 반환받고자 하는 데이터 형태
		 */
		public WNSearch(boolean isDebug, boolean isUidSrch, String[] collections, 
				String[] mergeCollections, String[] searchFields, int resultType){
		    this.common = new WNCommon();
		    this.wncol = new WNCollection();
		    this.collections = collections;
		    this.mergeCollections = mergeCollections;
		    this.searchFields = searchFields;
		    this.sb = new StringBuffer();
		    this.warningMsg = new StringBuffer();
		    this.isDebug = isDebug;
		    this.isUidSrch = isUidSrch;
		    this.resultType = resultType;
		}
		
		
		/**
		 * WNCommon객체를 생성하고 검색 대상 컬렉션과 검색 대상 필드들을 설정한다.
		 * @param isDebug 검색설정을 화면에 출력할 것인지 여부를 결정
		 * @param isUidSrch 키워드 검색을 할 것인지 UID 검색을 할 것인지 여부를 결정
		 * @param collections 검색하고자 하는 컬렉션들을 Array로 지정한다.
		 * @param searchFields 검색하고자 하는 검색필드들을 Array로 지정한다.
		 */
		public WNSearch(boolean isDebug, boolean isUidSrch, String[] collections, String[] searchFields){
		    this.common = new WNCommon();
		    this.wncol = new WNCollection();
		    this.collections = collections;
		    this.searchFields = searchFields;
		    this.sb = new StringBuffer();
		    this.warningMsg = new StringBuffer();
		    this.isDebug = isDebug;
		    this.isUidSrch = isUidSrch;
		}
		
		/**
		 * WNCommon객체를 생성하고 검색 대상 컬렉션과 검색 대상 필드들을 설정한다.
		 * @param isDebug 검색설정을 화면에 출력할 것인지 여부를 결정
		 * @param isUidSrch 키워드 검색을 할 것인지 UID 검색을 할 것인지 여부를 결정
		 * @param collections 검색하고자 하는 컬렉션들을 Array로 지정한다.
		 * @param mergeCollections 검색하고자 하는 가상통합컬렉션을 Array로 지정한다.
		 * @param searchFields 검색하고자 하는 검색필드들을 Array로 지정한다.
		 */
		public WNSearch(boolean isDebug, boolean isUidSrch, String[] collections, 
				String[] mergeCollections, String[] searchFields){
		    this.common = new WNCommon();
		    this.wncol = new WNCollection();
		    this.collections = collections;
		    this.mergeCollections = mergeCollections;
		    this.searchFields = searchFields;
		    this.sb = new StringBuffer();
		    this.warningMsg = new StringBuffer();
		    this.isDebug = isDebug;
		    this.isUidSrch = isUidSrch;
		}
	
		/**
		 * 검색 키워드를 설정한다.
		 * @param query 검색 키워드
		 * @param isRealQuery 실시간 검색어를 출력한 것인지 여부를 결정
		 * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		public int search(String query, boolean isRealQuery) {
		    return search(query, isRealQuery, null, HI_SUM_ONON, COMMON_OR_WHEN_NORESULT_OFF, CONNECTION_CLOSE, false);
		}
		
		
		/**
		 * 검색 키워드를 설정한다.
		 * @param query 검색 키워드
		 * @param isRealQuery 실시간 검색어를 출력한 것인지 여부를 결정
		 * @param useOrResult 검색결과 없을 때 OR로 검색할지 여부를 결정
		 * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		public int search(String query, boolean isRealQuery, int useOrResult) {
		    return search(query, isRealQuery, null, HI_SUM_ONON, useOrResult, CONNECTION_CLOSE, false);
		}
		
		/**
		 * 검색 키워드를 설정한다.
		 * @param query 검색 키워드
		 * @param isRealQuery 실시간 검색어를 출력한 것인지 여부를 결정
         * @param connectionOpt 검색기와 연결을 유지할 것인지 끊을 것인지 여부를 결정
         * @param useSuggestedQuery speller 결과를 사용할 것인지 여부를 결정
		 * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		public int search(String query, boolean isRealQuery, int connectionOpt, boolean useSuggestedQuery) {
		    this.connectionOpt = connectionOpt;
		    return search(query, isRealQuery, null, HI_SUM_ONON, COMMON_OR_WHEN_NORESULT_OFF, connectionOpt, useSuggestedQuery);
		}
		
		
		/**
		 * 검색 키워드를 설정한다.
		 * @param query 검색 키워드
		 * @param isRealQuery 실시간 검색어를 출력한 것인지 여부를 결정
		 * @param useOrResult 검색결과 없을 때 OR로 검색할지 여부를 결정
         * @param connectionOpt 검색기와 연결을 유지할 것인지 끊을 것인지 여부를 결정
         * @param useSuggestedQuery speller 결과를 사용할 것인지 여부를 결정
		 * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		public int search(String query, boolean isRealQuery, int useOrResult, int connectionOpt, boolean useSuggestedQuery) {
		    this.connectionOpt = connectionOpt;
		    return search(query, isRealQuery, null, HI_SUM_ONON, useOrResult, connectionOpt, useSuggestedQuery);
		}
		
		/**
		 * 검색 키워드를 설정한다.
		 * @param query 검색 키워드
		 * @param isRealQuery 실시간 검색어를 출력한 것인지 여부를 결정
		 * @param useOrResult 검색결과 없을 때 OR로 검색할지 여부를 결정
         * @param connectionOpt 검색기와 연결을 유지할 것인지 끊을 것인지 여부를 결정
         * @param hisum 하이라이팅과 요약을 사용할 옵션을 결정
         * @param useSuggestedQuery speller 결과를 사용할 것인지 여부를 결정
		 * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		public int search(String query, boolean isRealQuery, int useOrResult, int connectionOpt, int hiSum, boolean useSuggestedQuery) {
		    this.connectionOpt = connectionOpt;
		    return search(query, isRealQuery, null, hiSum, useOrResult, connectionOpt, useSuggestedQuery);
		}

        /**
		 * 검색 키워드를 설정한다.
		 * @param query 검색 키워드
		 * @param isRealQuery 실시간 검색어를 출력한 것인지 여부를 결정
         * @param userInfo 사용자 정보를 QueryLog파일이 저장할 때 사용된다
         * @param hisum 하이라이팅과 요약을 사용할 옵션을 결정
         * @param useOrResult 검색결과 없을 때 OR로 검색할지 여부를 결정
         * @param connectionOpt 검색기와 연결을 유지할 것인지 끊을 것인지 여부를 결정
         * @param useSuggestedQuery speller 결과를 사용할 것인지 여부를 결정
		 * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		private int search(String query, boolean isRealQuery, String[] userInfo, int hiSum, int useOrResult, int connectionOpt, boolean useSuggestedQuery) {
			this.connectionOpt = connectionOpt;
		  	this.hiSum = hiSum;
		  	int ret = 0;
		  	if(!isUidSrch) {
		        ret = common.setCommonQuery(query, CHARSET, useOrResult, useSuggestedQuery, userInfo);
		    } else {
		        ret = common.setUidQuery(CHARSET);
		    }

			if( collections != null){
				for(int i=0; i<collections.length; i++) {
					//컬렉션 index 설정
					int idx = getCollIdx(collections[i]);
					//컬렉션 index 결과 비교
					if(idx < 0){
						appendWarnings("[WARNING] [w3AddCollection] [search] ["+collections[i]+"] Collection name is not exist");
						break;
					}
					
					//검색 컬렉션 설정
					ret = setCollectionBasicInfo(idx);
					
					//검색 필드 설정
					if(!isUidSrch) {
						ret = setSearchFieldInfo(idx);
						//날짜 범위 검색
						ret = setDateRange(idx);
						//Rank 범위 검색
                        ret = setRankRange(idx);
						//PrefixQuery 조건 검색
						ret = setPrefixQuery(idx);
						//CollectionQuery 검색
						ret = setCollectionQuery(idx);
						//카테고리 부스팅 적용
						ret = setBoostCategory(idx);
						//카테고리 그룹바이
						ret = addCategoryGroupBy(idx);
						//카테고리 검색
						ret = addCategoryQuery(idx);
						//FilterQuery 조건 검색
						ret = setFilterQuery(idx);
						//권한 검색 조건 
						ret = setAuthorityQuery(idx);
						//속성 그룹 검색 조건 
						ret = setPropertyGroup(idx);
						//그룹바이 조건검색
						ret = setGroupBy(idx);
						//멀티그룹바이 조건검색
						ret = setMultiGroupBy(idx);
                        // DEDUP 조건검색
                        ret = setDuplicateDetectionCriterionField(idx);
					}else {
						//UID검색						
						ret = setUid(idx, query, searcherId);
					}
					//결과 필드 설정
					ret = setResultFieldInfo(idx);
				}
				
				
			}else{
				  appendWarnings("[WARNING] [w3AddCollection] [search] [ ] CollectionName is null.");
			}
			
			if(mergeCollections != null) {
				for(int n=0; n < mergeCollections.length; n++) {
					int idx = getMergeCollIdx(mergeCollections[n]);
					//컬렉션 index 결과 비교
					if(idx < 0){
						appendWarnings("[WARNING] [w3AddMergeCollection] [search] ["+mergeCollections[n]+"] Merge Collection name is not exist");
						break;
					}
					//가상 collection 설정
					ret = setMergeCollectionBasicnfo(idx);
					//가상 collection document field
					ret = addMergeDocumentField(idx);	
					//가상 collection multi-group by
					ret = addMergeMultiGroupBy(idx);	
					//가상 collection category group by
					ret = addMergeCategoryGroupByField(idx);	
				}
			}
			
			//Connection
			ret = common.getConnection(SEARCH_IP, SEARCH_PORT, CONNECTION_TIMEOUT);
			
			//실시간 검색키워드를 요청
			if(isRealQuery && !query.equals("")) {
				this.realTimeKeywords = recvRealTimeSearchKeywordList(REALTIME_COUNT);
			}			
			
			//검색결과를 얻는다.
			if(!isUidSrch) {
				if(resultType == USE_RESULT_XML) {
					ret = common.receiveSearchQueryResultAsXml(this.connectionOpt);
				}else if(resultType == USE_RESULT_JSON) {
					ret = common.receiveSearchQueryResultAsJson(this.connectionOpt);
				}else {
					ret = common.receiveSearchQueryResult(this.connectionOpt);
				}
			}else {
				if(resultType == USE_RESULT_XML) {
					ret = common.receiveUidResultAsXml(this.connectionOpt);
				} else if(resultType == USE_RESULT_JSON) {
					ret = common.receiveUidResultAsJson(this.connectionOpt);
				} else if(resultType == USE_RESULT_DUPLICATE_STRING) {
					ret = common.recvDuplicateDocumentsResult(this.connectionOpt);
				} else if(resultType == USE_RESULT_DUPLICATE_XML) {
					ret = common.recvDuplicateDocumentsResultAsXml(this.connectionOpt);
				} else if(resultType == USE_RESULT_DUPLICATE_JSON) {
					ret = common.recvDuplicateDocumentsResultAsJson(this.connectionOpt);
				} else {
					ret = common.receiveUidResult(this.connectionOpt);
				}			    
			}		
			
			//디버그 모드일 경우
			if(isDebug) {
				//디버그 정보
				debugMsg(isRealQuery, query);
				//에러 정보
				String errMsg = common.getErrorInfo();
				appendErrors(errMsg);
			}
			
			//오타후 정타 추천 키워드 요청
			if(useSuggestedQuery){
				this.suggestedQuery = common.getSuggestedQuery();
			}
			
			return ret;
		}
		
		
		
		/**
		 * 기본 검색 정보를 설정한다. 언어분석, 페이지 설정, 정렬이 해당된다.
		 * @param idx 검색하고자 하는 컬렉션의 index
		 * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		public int setCollectionBasicInfo(int idx) {
			int ret = 0;
			String[] analyzer = split(wncol.COLLECTION_INFO[idx][ANALYZER], ",");
			String[] pageInfo = split(wncol.COLLECTION_INFO[idx][PAGE_INFO], ",");
			String[] rankingOption = split(wncol.COLLECTION_INFO[idx][RANKING_OPTION], ",");
			String sortFieldInfo = wncol.COLLECTION_INFO[idx][SORT_FIELD];
			if(analyzer.length < 5 || pageInfo.length < 2 
					|| rankingOption.length < 3) {
				appendWarnings("[WARNING] [setCollectionBasicInfo] ["+ COLLECTIONS[idx] 
						+ "] Analyzer : '" + wncol.COLLECTION_INFO[idx][ANALYZER] 
						+ "', PageInfo : '" + wncol.COLLECTION_INFO[idx][PAGE_INFO] 
						+ "', RankingOption : '"+ wncol.COLLECTION_INFO[idx][RANKING_OPTION] 	
						+ "' error");
				return -1;
			}
			
			int useKma=Integer.parseInt(analyzer[0]);
			int isCase=Integer.parseInt(analyzer[1]);
			int useOriginal = Integer.parseInt(analyzer[2]);
			int useSynonym = Integer.parseInt(analyzer[3]);
			int useDuplicateDetection = Integer.parseInt(analyzer[4]);
			
			if(checkKeywordAnalyzer(COLLECTIONS[idx], useKma, isCase, useOriginal, useSynonym, useDuplicateDetection)== -1) {
				return -1;
			}
			
			ret = addCollection(idx, useKma, isCase, useOriginal, useSynonym, useDuplicateDetection);

			if(checkSetPageInfo(COLLECTIONS[idx], this.hiSum, Integer.parseInt(pageInfo[0]), Integer.parseInt(pageInfo[1])) == -1 ) {
				return -1;
			}
			ret = common.setPageInfo(COLLECTIONS[idx], this.hiSum,
			        Integer.parseInt(pageInfo[0]), Integer.parseInt(pageInfo[1]));
				
		    ret = common.setRanking(COLLECTIONS[idx], rankingOption[0], rankingOption[1],  parseInt(rankingOption[2], 100));
		    
            for( String sortField : sortFieldInfo.split(",") )
            {
                String[] tokens = sortField.split("/");
                if( tokens.length != 2 )
                {
                    appendWarnings("[ERROR] Sort Field format is not correct. ( FIELD/ORDER )");
                    return -1;
                }
                if( checkSortFieldName(COLLECTIONS[idx], tokens[0], tokens[1]) != 0 )
                    return -1;
            }
		    ret = common.setSortField(COLLECTIONS[idx], sortFieldInfo);
			return ret;
		}

		/**
		 *
		 * @param idx
		 * @param useKma
		 * @param isCase
		 * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		public int addCollection(int idx, int useKma, int isCase, int useOriginal, int useSynonym, int useDuplicateDetection){
			int ret = 0;
			String indexName = COLLECTIONS[idx];
			String colName = wncol.COLLECTION_INFO[idx][COLLECTION_NAME];
			if(indexName.equals(colName)){
				if(useOriginal == -1 && useSynonym == -1) {
					ret = common.addCollection(indexName, useKma, isCase);
				}else{
					ret = common.addCollection(indexName, useKma, isCase, useOriginal, useSynonym, useDuplicateDetection);
				}
			}else{
				if(useOriginal == -1 && useSynonym == -1) {
					ret = common.addAliasCollection(indexName, colName, useKma, isCase);
				}else{
					ret = common.addAliasCollection(indexName, colName, useKma, isCase, useOriginal, useSynonym, useDuplicateDetection);
				}
				
			}

			return ret;
		}

		/**
		 * WNCollection의 wncol.COLLECTION_INFO에 설정이 필요한 값을 Assign한다.
		 * @param collName 검색하고자 하는 컬렉션의 이름
		 * @param target Assign 대상
		 * @param value Assign 값
		 * @return 성공이면 true, 실패하면 false를 반환한다.
		 */
		public boolean setCollectionInfoValue(String collName, int target, String value) {
			int idx = getCollIdx(collName);
			if (idx == -1){
				appendWarnings("[WARNING] [w3AddCollection] [setCollectionInfoValue] ["+collName+"] Collection name is not exist");
				return false;
			}
			wncol.COLLECTION_INFO[idx][target] = value;
			return true;
		}
		
		/**
		 * WNCollection의 wncol.COLLECTION_INFO에 설정이 필요한 값을 Assign한다.
		 * @param collName 검색하고자 하는 컬렉션의 이름
		 * @param target Assign 대상
		 * @param value Assign 값
		 * @return 성공이면 true, 실패하면 false를 반환한다.
		 */
		public boolean setMergeCollectionInfoValue(String collName, int target, String value) {
			int idx = getMergeCollIdx(collName);
			if (idx == -1){
				appendWarnings("[WARNING] [w3AddMergeCollection] [setMergeCollectionInfoValue] ["+collName+"] Collection name is not exist");
				return false;
			}
			wncol.MERGE_COLLECTION_INFO[idx][target] = value;
			return true;
		}

		/**
		 * 검색하고자 하는 컬렉션의 모든 검색 필드를 설정한다.
		 * @param idx 검색하고자 하는 컬렉션의 index
		 * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		public int setSearchFieldInfo(int idx) {
			int ret = 0;//설정된 검색필드 전체조건에서 검색
			//WNCollection에 정의된 검색필드 리스트를 얻는다.
			String searchFields = wncol.COLLECTION_INFO[idx][SEARCH_FIELD];
			String[] searchFieldList = split(searchFields, ",");
			if(searchFieldList.length < 1) {
				appendWarnings("[WARNING] [w3AddSearchField] [setAllSearchFieldInfo] [" + COLLECTIONS[idx] + "] SEARCH_FIELD should be defined.");
				return -1;
			}
			int i = checkFieldName("[w3AddSearchField]", COLLECTIONS[idx], searchFieldList, SEARCH_FIELD);
			if( i != 0) {
				appendWarnings("[WARNING] [w3AddSearchField] [setAllSearchFieldInfo] [" + COLLECTIONS[idx] + "] '" + searchFieldList[i-1] + "' is not exist.");
				return -1;
			}
			ret = common.setSearchField(COLLECTIONS[idx], searchFields);
			return ret;
		}

		
		/**
		 * 컬렉션 별로 검색어 지정한다.
		 * @return  성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		public int setCollectionQuery(int idx) {
			int ret = 0;
			//컬렉션 검색 설정
			if (!wncol.COLLECTION_INFO[idx][COLLECTION_QUERY].equals("")) {
				if(isDebug) {
					checkCollectionQueryFieldName("[w3SetCollectionQuery] [setCollectionQuery]", COLLECTIONS[idx],wncol.COLLECTION_INFO[idx][COLLECTION_QUERY] );
				}
				ret = common.setCollectionQuery(COLLECTIONS[idx],
	                       wncol.COLLECTION_INFO[idx][COLLECTION_QUERY]);
			}
			return ret;
		}
		
		/**
		 * 특정 필드에 쿼리 및 가중치를 부여하여 검색 결과를 조정하도록 해준다.
		 * @return  성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		public int setBoostQuery(int idx) {
			int ret = 0;
			//Boost 검색 설정
			if (!wncol.COLLECTION_INFO[idx][BOOST_QUERY].equals("")) {
				/* if(isDebug) {
					checkCollectionQueryFieldName("[w3SetBoostQuery] [setBoostQuery]", COLLECTIONS[idx],wncol.COLLECTION_INFO[idx][COLLECTION_QUERY] );
				} */
				ret = common.setBoostQuery(COLLECTIONS[idx], wncol.COLLECTION_INFO[idx][BOOST_QUERY]);
			}
			return ret;
		}

		/**
		 * 검색하고자 하는 컬렉션의 UID 검색을 설정한다.
		 * @param idx 검색하고자 하는 컬렉션의 index
		 * @param value 검색하고자 하는 UID 값
		 * @return  성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		public int setUid(int idx, String value, String searcherId) {
			int ret = 0;
			
			if(!value.equals("")) {
				String[] values = split(value,",");
				ret = common.setUid(COLLECTIONS[idx], values, searcherId);
			}
			return ret;
		}

		/**
		 * 검색하고자 하는 컬렉션의 검색 날짜 범위를 설정한다.
		 * @param idx 검색하고자 하는 컬렉션의 index
		 * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		public int setDateRange(int idx) {
			int ret = 0;
			//날짜검색 범위 설정
			if (!wncol.COLLECTION_INFO[idx][DATE_RANGE].equals("")) {
				String[] dateFields = split(wncol.COLLECTION_INFO[idx][DATE_RANGE], ",");
				if(dateFields.length < 2) {
					appendWarnings("[WARNING] [w3SetDateRange] [setDateRange] [" + COLLECTIONS[idx] + "] DATE_RANGE : '" + wncol.COLLECTION_INFO[idx][DATE_RANGE] + "' error.");
					return -1;
				}
				ret = common.setDateRange(COLLECTIONS[idx], dateFields[0], dateFields[1], dateFields[2]);
			}
			return ret;
		}

        /**
		 * 검색하고자 하는 컬렉션의 검색 Ranking 범위를 설정한다.
		 * @param idx 검색하고자 하는 컬렉션의 index
		 * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		public int setRankRange(int idx) {
			int ret = 0;
			//날짜검색 범위 설정
			if (!wncol.COLLECTION_INFO[idx][RANK_RANGE].equals("")) {
				String[] rankFields = split(wncol.COLLECTION_INFO[idx][RANK_RANGE], ",");
				if(rankFields.length < 2) {
					appendWarnings("[WARNING] [w3SetRankRange] [setRankRange] [" + COLLECTIONS[idx] + "] RANK_RANGE : '" + wncol.COLLECTION_INFO[idx][RANK_RANGE] + "' error.");
					return -1;
				}
				int min = parseInt(rankFields[0], 0);
				int max = parseInt(rankFields[1], 100);
				ret = common.setRankRange(COLLECTIONS[idx], min, max);
			}
			return ret;
		}

		/**
		 * 검색하고자 하는 컬렉션의 기본 검색 필드 외에 특정 필드에 키워드를 별도로 설정한다.
		 * @param idx 검색하고자 하는 컬렉션의 index
		 * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		public int setPrefixQuery(int idx){
			int ret = 0;
			//확장 검색 설정
			if (!wncol.COLLECTION_INFO[idx][EXQUERY_FIELD].equals("")) {
				if(isDebug) {
					checkExFieldName("[w3AddExQuery] [setExQuery]", COLLECTIONS[idx]
				                    , wncol.COLLECTION_INFO[idx][EXQUERY_FIELD]);
				}
				ret = common.setPrefixQuery(COLLECTIONS[idx],
				                wncol.COLLECTION_INFO[idx][EXQUERY_FIELD]);
			}
			return ret;
		}

		/**
		 * 카테고리 부스팅을 설정한다.
		 * @param idx 검색하고자 하는 컬렉션의 index
		 * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		public int setBoostCategory(int idx){
		    int ret = 0;
		    //확장 검색 설정
		    if (!wncol.COLLECTION_INFO[idx][CATEGORY_BOOST].equals("")) {
				String[] dataFields = split(wncol.COLLECTION_INFO[idx][CATEGORY_BOOST], ",");

				if(dataFields.length == 4){
					ret = common.setBoostCategory(COLLECTIONS[idx],
							dataFields[0], dataFields[1], dataFields[2], dataFields[3]);
				}
    		}
			return ret;
		}
		
		
		/**
		 * 검색결과 패킷에 카테고리 지정 컬렉션의 카테고리 필드에서 Depth별 Category의 리스트를 포함시킨다. 
		 * @param idx 검색하고자 하는 컬렉션의 index
		 * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		public int addCategoryGroupBy(int idx){
			int ret = 0;
			
			if (!wncol.COLLECTION_INFO[idx][CATEGORY_GROUPBY].equals("")) {
				String[] categoryGroup = split(wncol.COLLECTION_INFO[idx][CATEGORY_GROUPBY], ",");

				common.addCategoryGroupBy(COLLECTIONS[idx], categoryGroup);
			}
			
			return ret;
		}
		
		/**
		 * 선택한 컬렉션 내의 선택 카테고리 필드의 값으로 검색결과를 필터링 한다. 
		 * 혹은 다른 쿼리없이 본쿼리를 실행하면 해당 카테고리의 값에 매치되는 문서를 출력한다.
		 * @param idx 검색하고자 하는 컬렉션의 index
		 * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		public int addCategoryQuery(int idx){
			int ret = 0;
			
			if (!wncol.COLLECTION_INFO[idx][CATEGORY_QUERY].equals("")) {
				String[] categoryQuery = split(wncol.COLLECTION_INFO[idx][CATEGORY_QUERY], ",");
				
				ret = common.addCategoryQuery(COLLECTIONS[idx], categoryQuery);
    		}
			
			return ret;
		}
		
		public int getCategoryCount(String collectionName, String fieldName, int depth) {
			int cnt = 0;
			int chk = checkValidCollection("[w3GetCategoryCount] [getCategoryCount]", collectionName);
			if(chk == -1){
				return -1;
			}
			/*
			chk = checkValidDocumentField(collectionName, fieldName, RESULT_FIELD);
			if(chk == -1){
				appendWarnings("[WARNING] [w3GetCategoryCount] [getCategoryCount] [" + collectionName + "] RESULT_FIELD should be defined.");
				return -1;
			}
			*/
			
			return common.getCategoryCount(collectionName, fieldName, depth);
		}
		
		
		public String getCategoryName(String collectionName, String fieldName, int depth, int idx) {
			int cnt = 0;
			int chk = checkValidCollection("[w3GetCategoryName] [getCategoryName]", collectionName);
			if(chk == -1){
				return null;
			}
			/*
			chk = checkValidDocumentField(collectionName, fieldName, RESULT_FIELD);
			if(chk == -1){
				appendWarnings("[WARNING] [w3GetCategoryName] [getCategoryName] [" + collectionName + "] RESULT_FIELD should be defined.");
				return null;
			}
			*/
			return common.getCategoryName(collectionName, fieldName, depth, idx);
		}
		
		public int getDocumentCountInCategory(String collectionName, String fieldName, int depth, int idx) {
			int cnt = 0;
			int chk = checkValidCollection("[w3GetDocumentCountInCategory] [getDocumentCountInCategory]", collectionName);
			if(chk == -1){
				return -1;
			}
			/*
			chk = checkValidDocumentField(collectionName, fieldName, RESULT_FIELD);
			if(chk == -1){
				appendWarnings("[WARNING] [w3GetDocumentCountInCategory] [getDocumentCountInCategory] [" + collectionName + "] RESULT_FIELD should be defined.");
				return -1;
			}
			*/
			return common.getDocumentCountInCategory(collectionName, fieldName, depth, idx);
		}
		
		/**
		* 권한검색하고자 하는 컬렉션의 특정 필드와 조건을 설정한다.
		* @param idx 검색하고자 하는 컬렉션의 index
		* @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		*/
		public int setAuthorityQuery(int idx) {
			int ret = 0;
			//컬렉션 검색 설정
			if (!wncol.COLLECTION_INFO[idx][AUTH_QUERY].equals("")) {
				String[] dataFields = split(wncol.COLLECTION_INFO[idx][AUTH_QUERY], ",");

				if(dataFields.length == 4){
					ret = common.setAuthorityQuery(COLLECTIONS[idx],
							dataFields[0], dataFields[1], dataFields[2], dataFields[3]);
				}
				
			}
			return ret;
		}
		
		
		/**
		* 특정 필드의 값을 기준으로 범위 별로 그룹을 만들거나, 이 필드 값이 특정 범위에 속하는 레코드만 추출
		* @param idx 검색하고자 하는 컬렉션의 index
		* @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		*/
		public int setPropertyGroup(int idx) {
			int ret = 0;
			//컬렉션 검색 설정
			if (!wncol.COLLECTION_INFO[idx][PROPERTY_GROUP].equals("")) {
				String[] dataFields = split(wncol.COLLECTION_INFO[idx][PROPERTY_GROUP], ",");

				if(dataFields.length == 4){
					ret = common.setPropertyGroup(COLLECTIONS[idx],
							dataFields[0], parseInt(dataFields[1],0), 
							parseInt(dataFields[2], 1000000), parseInt(dataFields[3], 5));
				}				
			}
			return ret;
		}
		
		/**
		* 검색기로부터 받아온 속성 그룹의 개수를 반환
		* @param collectionName
		* @return 성공이면 검색결과 개수을 반환한다. 실패하거나 결과가 없을 경우 0 값을 반환한다.
		*/
		public int getCountPropertyGroup(String collectionName) {
			int cnt = 0;
			int chk = checkValidCollection("[w3GetCountPropertyGroup] [getCountPropertyGroup]", collectionName);
			if(chk == -1){
				return cnt;
			}
			return common.getCountPropertyGroup(collectionName);
		}
		
		/**
		* 전체 속성 그룹 결과에서 최소값을 반환
		* @param collectionName
		* @return 성공이면 검색결과 개수을 반환한다. 실패하거나 결과가 없을 경우 0 값을 반환한다.
		*/
		public int getMinValuePropertyGroup(String collectionName) {
			int cnt = 0;
			int chk = checkValidCollection("[w3GetMinValuePropertyGroup] [getMinValuePropertyGroup]", collectionName);
			if(chk == -1){
				return cnt;
			}
			return common.getMinValuePropertyGroup(collectionName);
		}
		
		/**
		* 전체 속성 그룹 결과에서 최대값을 반환
		* @param collectionName
		* @return 성공이면 검색결과 개수을 반환한다. 실패하거나 결과가 없을 경우 0 값을 반환한다.
		*/
		public int getMaxValuePropertyGroup(String collectionName) {
			int cnt = 0;
			int chk = checkValidCollection("[w3GetMaxValuePropertyGroup] [getMaxValuePropertyGroup]", collectionName);
			if(chk == -1){
				return cnt;
			}
			return common.getMaxValuePropertyGroup(collectionName);
		}
		
		/**
		* 지정된 속성 그룹 내 최소값을 반환
		* @param collectionName
		* @param groupIndex
		* @return 성공이면 검색결과 개수을 반환한다. 실패하거나 결과가 없을 경우 0 값을 반환한다.
		*/
		public int getMinValueInPropertyGroup(String collectionName, int groupIndex) {
			int cnt = 0;
			int chk = checkValidCollection("[w3GetMinValueInPropertyGroup] [getMinValueInPropertyGroup]", collectionName);
			if(chk == -1){
				return cnt;
			}
			return common.getMinValueInPropertyGroup(collectionName, groupIndex);
		}
		
		/**
		* 지정된 속성 그룹 내 최대값을 반환
		* @param collectionName
		* @param groupIndex
		* @return 성공이면 검색결과 개수을 반환한다. 실패하거나 결과가 없을 경우 0 값을 반환한다.
		*/
		public int getMaxValueInPropertyGroup(String collectionName, int groupIndex) {
			int cnt = 0;
			int chk = checkValidCollection("[w3GetMaxValueInPropertyGroup] [getMaxValueInPropertyGroup]", collectionName);
			if(chk == -1){
				return cnt;
			}
			return common.getMaxValueInPropertyGroup(collectionName, groupIndex);
		}
		
		
		/**
		 * 검색하고자 하는 컬렉션의 특정 필드의 값으로 필터링 한다.
		 * @param idx 검색하고자 하는 컬렉션의 index
		 * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		public int setFilterQuery(int idx) {
			int ret = 0;
			if (!wncol.COLLECTION_INFO[idx][FILTER_OPERATION].equals("")) {
				if(isDebug) {
					checkFilterFieldName("[w3SetFilterQuery] [setFilterQuery]", COLLECTIONS[idx]
                    		, wncol.COLLECTION_INFO[idx][FILTER_OPERATION]);
       			}
        		ret = common.setFilterQuery(COLLECTIONS[idx], wncol.COLLECTION_INFO[idx][FILTER_OPERATION]);
			}
			return ret;
		}
		
		public int setMultiGroupBy(int idx) {			
			int ret = 0;
			if (!wncol.COLLECTION_INFO[idx][MULTI_GROUP_BY].equals("")) {
				String field = wncol.COLLECTION_INFO[idx][MULTI_GROUP_BY];
				//그룹전달인자 확인
				ret = common.setMultiGroupBy(COLLECTIONS[idx], field);
			}
			return ret;
		}
		
		/**
		 * 검색하고자 하는 컬렉션의 특정 필드의 값으로 그룹화 한고 정렬 조건이 있을 경우 정렬한다.
		 * @param idx  검색하고자 하는 컬렉션의 index
		 * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		 public int addMultiGroupBy(int idx) {
			int ret = 0;
			if (!wncol.COLLECTION_INFO[idx][MULTI_GROUP_BY].equals("")) {
				String field = wncol.COLLECTION_INFO[idx][MULTI_GROUP_BY];
				//그룹전달인자 확인
				ret = common.addMultiGroupBy(COLLECTIONS[idx], field);
			}
			return ret;
		}
		
		/**
		*/
		public String getMultiGroupByResult(String collectionName, String fieldName) {
			int cnt = 0;
			int chk = checkValidCollection("[w3AddMultiGroupBy] [getMultiGroupByResult]", collectionName);
			if(chk == -1){
				return null;
			}
			chk = checkValidDocumentField(collectionName, fieldName, RESULT_FIELD);
			if(chk == -1){
				appendWarnings("[WARNING] [w3AddMultiGroupBy] [getMultiGroupByResult] [" + collectionName + "] RESULT_FIELD should be defined.");
				return null;
			}
			return common.getMultiGroupByResult(collectionName, fieldName);
		}
		
		/**
		 * 검색하고자 하는 컬렉션의 특정 필드의 값으로 그룹화 한고 정렬 조건이 있을 경우 정렬한다.
		 * @param idx  검색하고자 하는 컬렉션의 index
		 * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		 public int setGroupBy(int idx) {
			int ret = 0;
			if (!wncol.COLLECTION_INFO[idx][GROUP_BY].equals("")) {
				String[] groupby = split(wncol.COLLECTION_INFO[idx][GROUP_BY], ",");
				if(isDebug) {
				// 그룹화할 필드가 fastacces로 잡혀있는지 체크
					if(checkValidField(COLLECTIONS[idx], groupby[0], FAST_ACCESS) == -1) {
						appendWarnings("[WARNING] [w3SetGroupBy] [setGroupBy] [" + COLLECTIONS[idx] + "] " +groupby[0]+ " is not fastaccess field.");
					}
				}
				//그룹전달인자 확인
				if(groupby.length == 2){
					//그룹화 설정
					ret = common.setGroupBy(COLLECTIONS[idx], groupby[0], parseInt(groupby[1], 0));
					//그룹 정렬 전달 인자 확인
					ret = addSortFieldInGroup(idx);
				}else{
					appendWarnings("[WARNING] [w3SetGroupBy] [setGroupBy] [" + COLLECTIONS[idx] + "] " +wncol.COLLECTION_INFO[idx][GROUP_BY]+ "  Check variable format and value.");
				}
			}
			return ret;
		}

		/**
		 * 그룹화 된 컬렉션의 정렬을 정한다.
		 * @param idx
		 * @return 성공이면 0 실패면 0 보다 작은 값 반환
		 */
		public int addSortFieldInGroup(int idx){
			int ret = -1;
			//그룹 정렬 전달인자 확인
			if (wncol.COLLECTION_INFO[idx][GROUP_SORT_FIELD] != ""){
				String sortValue = wncol.COLLECTION_INFO[idx][GROUP_SORT_FIELD];
				ret = common.setSortFieldInGroup(COLLECTIONS[idx], sortValue);
			}
			return ret;
		}
		
		/**
		 * 검색결과에서 중복문서 정렬 기준을 설정한다.
		 * @param collectionName
		 * @param idx
		 * @return 검색한 해당 문서의 중복문서 개수를 반환
		 */
		public int setDuplicateDetectionCriterionField(int idx){
			int ret = 0;
			if (!wncol.COLLECTION_INFO[idx][DEDUP_SORT_FIELD].equals("")){
				String sortValue = wncol.COLLECTION_INFO[idx][DEDUP_SORT_FIELD];
				ret = common.setDuplicateDetectionCriterionField(COLLECTIONS[idx], sortValue);
			}
			return ret;
		}
		
		/**
		 * 검색 결과 중 개별 문서에 대해서 중복으로 판별된 문서의 개수를 반환한다.
		 * @param collectionName
		 * @param idx
		 * @return 검색한 해당 문서의 중복문서 개수를 반환
		 */
		public int getDuplicateDocumentCount(String collectionName, int idx){
			int cnt = 0;
			int chk = checkValidCollection("[w3GetDuplicateDocumentCount] [getDuplicateDocumentCount]", collectionName);
			if(chk == -1){
				return cnt;
			}
			return common.getDuplicateDocumentCount(collectionName, idx);
		}
		
		/**
		 * 그룹화된 문서 중 지정된 순서의 그룹 내에서 각 결과들이 중복된 문서의 개수를 반환
		 * @param collectionName
		 * @param groupIndex
		 * @param idx
		 * @return 중복문서 개수를 반환
		 */
		public int getDuplicateDocumentCountInGroup(String collectionName, int groupIndex, int idx){
			int cnt = 0;
			int chk = checkValidCollection("[w3GetDuplicateDocumentCount] [getDuplicateDocumentCount]", collectionName);
			if(chk == -1){
				return cnt;
			}
			return common.getDuplicateDocumentCountInGroup(collectionName, groupIndex, idx);
		}
		
		/**
		 * 그룹화 설정된 전체 그룹 수를 가져온다.
		 * @param collectionName
		 * @return 성공이면 검색결과 개수을 반환한다. 실패하거나 결과가 없을 경우 0 값을 반환한다.
		 */
		public int  getResultTotalGroupCount(String collectionName) {
			int cnt = 0;
			int chk = checkValidCollection("[w3GetResultTotalGroupCount] [getResultTotalGroupCount]", collectionName);
			if(chk == -1){
				return cnt;
			}
			return common.getResultTotalGroupCount(collectionName);
		}

		/**
		 * 화면에 보여질 그룹화 설정된 그룹 수를 가져온다.
		 * @param collectionName
		 * @return 성공이면 검색결과 개수을 반환한다. 실패하거나 결과가 없을 경우 0 값을 반환한다.
		 */
		public int getResultGroupCount(String collectionName) {
			int cnt = 0;
			int chk = checkValidCollection("[w3GetGroupByCount] [getGroupByCount]", collectionName);
			if(chk == -1){
				return cnt;
			}
			return common.getResultGroupCount(collectionName);
		}

		
		/**
		 * 그룹에 속하는 문서중 가져온 문서 개수를 구한다.
		 * @param collectionName
		 * @param groupIndex
		 * @return 그룹에 속하는 전제문서 개수를 반환한다. 실패하거나 결과가 없을 경우 0 보다 작은값 반환한다.
		 */
		public int getTotalCountInGroup(String collectionName, int groupIndex) {
			int cnt = 0;
			int chk = checkValidCollection("[w3GetTotalCountInGroup] [getTotalCountInGroup]", collectionName);
			if(chk == -1){
				return cnt;
			}
			return common.getTotalCountInGroup(collectionName, groupIndex);
		}

		/**
		 *
		 * @param collectionName
		 * @param groupIndex
		 * @return 그룹에 속하는 문서중 가져온 문서 개수를 반환한다. 실패하거나 결과가 없을 경우 0 보다 작은값 반환한다.
		 */
		public int getCountInGroup(String collectionName, int groupIndex) {
			int cnt = 0;
			int chk = checkValidCollection("[w3GetCountInGroup] [getCountInGroup]", collectionName);
			if(chk == -1){
				return cnt;
			}
			return common.getCountInGroup(collectionName, groupIndex);
		}
		
		/**
		 * 그룹화된 문서 중 지정된 순서의 그룹 내에서 주어진 collection 결과 에서 index 번째 문서의 Collection ID를 반환
		 * @param collectionName
		 * @param groupIndex
		 * @param docIndex
		 * @return 그룹에 속하는 문서중 특정 문서의 필드값을 반환한다. 실패할 경우 null값을 반환한다.
		 */
		public String getCollectionIdInGroup(String collectionName, int groupIndex, int docIndex) {
			int cnt = 0;
			int chk = checkValidCollection("[w3GetCollectionIdInGroup] [getCollectionIdInGroup]", collectionName);
			if(chk == -1){
				return null;
			}
			return common.getCollectionIdInGroup(collectionName, groupIndex, docIndex);
		}
		
		/**
		 * 그룹에 속하는 문서중 특정 문서의 Ranking값을 구한다.
		 * @param collectionName
		 * @param groupIndex
		 * @param docIndex
		 * @return 그룹에 속하는 문서중 특정 문서의 필드값을 반환한다. 실패할 경우 -1값을 반환한다.
		 */
		public long getRankInGroup(String collectionName, int groupIndex, int docIndex) {
			int cnt = 0;
			int chk = checkValidCollection("[w3GetRankInGroup] [getRankInGroup]", collectionName);
			if(chk == -1){
				return -1;
			}
			return common.getRankInGroup(collectionName, groupIndex, docIndex);
		}
		
		/**
		 * 그룹에 속하는 문서중 특정 문서의 필드값을 구한다.
		 * @param collectionName
		 * @param fieldName
		 * @param groupIndex
		 * @param docIndex
		 * @return 그룹에 속하는 문서중 특정 문서의 필드값을 반환한다. 실패할 경우 null값을 반환한다.
		 */
		public String getFieldInGroup(String collectionName, String fieldName, int groupIndex, int docIndex) {
			int cnt = 0;
			int chk = checkValidCollection("[w3GetFieldInGroup] [getFieldInGroup]", collectionName);
			if(chk == -1){
				return null;
			}
			chk = checkValidDocumentField(collectionName, fieldName, RESULT_FIELD);
			if(chk == -1){
				appendWarnings("[WARNING] [w3AddDocumentField] [setResultFieldInfo] [" + collectionName + "] RESULT_FIELD should be defined.");
				return null;
			}
			return common.getFieldInGroup(collectionName, fieldName, groupIndex, docIndex);
		}

		/**
		 * 그룹에 속하는 문서중 특정 문서의 UID값을 구한다.
		 * @param collectionName
		 * @param groupIndex
		 * @param docIndex
		 * @return 그룹에 속하는 문서중 특정 문서의 UID값을 반환한다. 실패할 경우 0보다 작은 값을 반환한다.
		 */
		public long getUidInGroup(String collectionName, int groupIndex, int docIndex) {
			int cnt = 0;
			int chk = checkValidCollection("[w3getUidInGroup] [getCountInGroup]", collectionName);
			if(chk == -1){
				return -1;
			}
			return common.getUidInGroup(collectionName, groupIndex, docIndex);
		}

		/**
		 * 그룹에 속하는 문서중 특정 문서의 가중치값을 구한다.
		 * @param collectionName
		 * @param groupIndex
		 * @param docIndex
		 * @return 그룹에 속하는 문서중 특정 문서의 가중치값을 반환한다. 실패할 경우 0보다 작은 값을 반환한다.
		 */
		public long getWeightInGroup(String collectionName, int groupIndex, int docIndex) {
			int cnt = 0;
			int chk = checkValidCollection("[w3getUidInGroup] [getCountInGroup]", collectionName);
			if(chk == -1){
				return -1;
			}
			return common.getWeightInGroup(collectionName, groupIndex, docIndex);
		}

		/**
		 * 그룹에 속하는 문서중 특정 문서의 날짜정보값을 구한다.
		 * @param collectionName
		 * @param groupIndex
		 * @param docIndex
		 * @return 그룹에 속하는 문서중 특정 문서의 날짜정보값을 반환한다. 실패할 경우 빈문자열을 반환한다.
		 */
		public String getDateInGroup(String collectionName, int groupIndex, int docIndex) {
			int cnt = 0;
			int chk = checkValidCollection("[w3getUidInGroup] [getCountInGroup]", collectionName);
			if(chk == -1){
				return "";
			}
			return common.getDateInGroup(collectionName, groupIndex, docIndex);
		}
		
		
		/**
		 * 그룹에 속하는 문서중 특정 문서의 검색기 아이디값을 구한다.
		 * @param collectionName
		 * @param groupIndex
		 * @param docIndex
		 * @return 그룹에 속하는 문서중 특정 문서의 검색기 아이디값을 반환한다. 실패할 경우 빈문자열을 반환한다.
		 */
		public String getSearcherIdInGroup(String collectionName, int groupIndex, int docIndex) {
			int cnt = 0;
			int chk = checkValidCollection("[w3GetSearcherIdInGroup] [getSearcherIdInGroup]", collectionName);
			if(chk == -1){
				return "";
			}
			return common.getSearcherIdInGroup(collectionName, groupIndex, docIndex);
		}

		/**
		 * 검색하고자 하는 컬렉션의 결과 필드를 설정한다.
		 * @param idx 검색하고자 하는 컬렉션의 index
		 * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		public int setResultFieldInfo(int idx) {
			int ret = 0;
			String resultFields = wncol.COLLECTION_INFO[idx][RESULT_FIELD];
			String[] resultFieldList = split(resultFields,",");
			if(resultFieldList.length < 1) {
				appendWarnings("[WARNING] [w3AddDocumentField] [setResultFieldInfo] [" + COLLECTIONS[idx] + "] RESULT_FIELD should be defined.");
				return -1;
			}
			int i = checkFieldName("[w3AddDocumentField]", COLLECTIONS[idx], resultFieldList, RESULT_FIELD);
			if( i != 0 ) {
				appendWarnings("[WARNING] [w3AddDocumentField] [setResultFieldInfo] [" + COLLECTIONS[idx] + "] '" + resultFieldList[i-1] + "' is not exist.");
				return -1;
			}
			ret = common.setResultField(COLLECTIONS[idx], resultFields);
			return ret;
		}

		/**
		 * 검색 조건을 만족하는 레코드로 가져온 개수,
		 * 검색 조건의 start 위치에서부터 count보다 같거나 작은 개수를 가져온다.
		 * @param collectionName
		 * @return 성공이면 검색결과 개수을 반환한다. 실패하거나 결과가 없을 경우 0 값을 반환한다.
		 */
		public int getResultCount (String collectionName) {
			int cnt = 0;
			int chk = checkValidCollection("[w3GetResultCount] [getResultCount]", collectionName);
			if(chk == -1){
				return cnt;
			}
			return common.getResultCount(collectionName);
		}

		/**
		 * 검색 조건을 만족하는 총 검색 결과 개수
		 * @param collectionName
		 * @return 성공이면 검색결과 총 개수을 반환한다. 실패하거나 결과가 없을 경우 0 값을 반환한다.
		 */
		public int getResultTotalCount (String collectionName) {
			int chk = checkValidCollection("[w3GetResultTotalCount] [getResultTotalCount]", collectionName);
			if(chk == -1){
				return chk;
			}
			return common.getResultTotalCount(collectionName);
		}

		/**
		 * 현재 검색 되고 있는 실시간 검색어 리스트를 얻는다.
		 * @param count 실시간 검색어 개수
		 * @return 실시간 검색어 리스트를 반환한다.
		 */
		public String recvRealTimeSearchKeywordList(int count) {
			StringBuffer sbKey = new StringBuffer();
			String[] keywordList = common.receiveRecentQueryListResult(CONNECTION_KEEP, count);
			if(keywordList != null){
				int keyCount = keywordList.length;
				for(int i = 0; i < keyCount; i++){
					sbKey.append(keywordList[i].replaceAll("'", "").replaceAll("\\\\", ""));
					if(i < keywordList.length - 1) {
						sbKey.append(",");
					}
				}
			} else {
				return "";
			}
			return sbKey.toString();
		}

		/**
		 * 검색 결과 필드의 값을 얻는다. field명에 따라서 UID, RANK, DATE 값을 얻을 수 있다.
		 * @param collectionName 결과를 얻고자 하는 컬렉션 이름
		 * @param field 결과 필드
		 * @param idx 검색결과 컬렉션의 index
		 * @param isHL 하이라이팅을 할 것인지 여부를 결정
		 * @return FIELD VALUE
		 */
		public String getField(String collectionName, String field, int idx, boolean isHL) {
			String ret = "";
			if (collectionName.equals("")) return ret;
			if (field.toUpperCase().equals("UID")) {
				ret = String.valueOf(common.getUid(collectionName, idx));
			}else if (field.toUpperCase().equals("RANK")) {
				ret = String.valueOf(common.getRank(collectionName, idx));
			}else  if (field.toUpperCase().equals("DATE")) {
				ret = parseDate(common.getDate(collectionName, idx),"yyyy/MM/dd HH:mm:ss","yyyy.MM.dd");
			}else  if (field.toUpperCase().equals("WEIGHT")) {
				ret = String.valueOf(common.getWeight(collectionName, idx));
			}else  if (field.toUpperCase().equals("SEARCHERID")) {
				ret = common.getSearcherId(collectionName, idx);
			}else  if (field.toUpperCase().equals("COLLECTIONID")) {
				ret = common.getCollectionId(collectionName, idx);
			}else {
				
				if (checkValidDocumentField(collectionName, field, RESULT_FIELD) == -1) {
					return ret;
				}
				if(isHL){
					ret = getKeywordHl(common.getField(collectionName, field ,idx), "red");
				}else{
					ret = common.getField(collectionName, field ,idx);
				}
			}
            return ret;
		}
		
		/**
		* 여러 컬렉션의 검색결과를 하나의 가상 통합 컬렉션(Merge Collection) 결과로 통합하여 가져오기 원할 때 사용하는 함수
		* @param idx 검색하고자 하는 컬렉션의 index
		* @return 성공이면 검색결과 총 개수을 반환한다. 실패하거나 결과가 없을 경우 0 값을 반환한다.
		*/
		public int setMergeCollectionBasicnfo(int idx) {
			int ret = 0;
			
			String mergeCollectionName = wncol.MERGE_COLLECTION_INFO[idx][MERGE_COLLECTION_NAME];
			String[] collectionNames = split(wncol.MERGE_COLLECTION_INFO[idx][MERGE_MAPPING_COLLECTION_NAME], "/");
			String[] pageInfo = split(wncol.MERGE_COLLECTION_INFO[idx][MERGE_PAGE_INFO], ",");
			if(pageInfo.length < 2 ) {
				appendWarnings("[WARNING] [setMergeCollectionBasicnfo] [PageInfo : '" + wncol.MERGE_COLLECTION_INFO[idx][MERGE_PAGE_INFO]		
						+ "' error");
				return -1;
			}
			int length = collectionNames.length;
			for(int i=0; i<length; i++) {
				int chk = checkValidCollection("[setMergeCollectionBasicnfo]", collectionNames[i]);
				if(chk == -1){
					return -1;
				}
			}
			
			int start = parseInt(pageInfo[0], 0);
			int count = parseInt(pageInfo[1], 10);
			
			
			ret = common.addMergeCollectionInfo(mergeCollectionName, collectionNames, start, count);
			
			return ret;		
		}
		
		/**
		* 가상 통합 컬렉션(Merge Collection)의 가상 결과 필드(Document Field)와 통합될 개별 Collection의 실제 결과 필드명을 연결시킨다.
		* @param idx 검색하고자 하는 컬렉션의 index
		* @return 성공이면 검색결과 총 개수을 반환한다. 실패하거나 결과가 없을 경우 0 값을 반환한다.
		*/
		public int addMergeDocumentField(int idx) {
			int ret = 0;
			String mergeCollectionName = wncol.MERGE_COLLECTION_INFO[idx][MERGE_COLLECTION_NAME];
			String[] collectionNames = split(wncol.MERGE_COLLECTION_INFO[idx][MERGE_MAPPING_COLLECTION_NAME], "/");
			
			int collectionLength = collectionNames.length;
			for(int i=0; i < collectionLength; i++) {
				int chk = checkValidCollection("[setMergeCollectionBasicnfo]", collectionNames[i]);
				if(chk == -1){
					return -1;
				}
			}
		
			String[] mergeFields = split(wncol.MERGE_COLLECTION_INFO[idx][MERGE_RESULT_FIELD], ",");
			int mergeFieldLength = mergeFields.length;
			
			String[][] documentFields = new String[collectionLength][mergeFieldLength];
			String[] temp = split(wncol.MERGE_COLLECTION_INFO[idx][MERGE_MAPPING_RESULT_FIELD], "/");
			
			for(int k=0; k < collectionLength; k++) {
				for(int n=0; n < temp.length; n++) {
					if( k == n ) documentFields[k] = split(temp[n], ",");
					if(mergeFieldLength != documentFields[k].length){
						appendWarnings("[Error] [addMergeDocumentField] [merge fields, collection document and different.]");
						return -1;
					}
				}
			}
			
			ret = common.addMergeDocumentField(mergeCollectionName, mergeFields, collectionNames, documentFields);
			
			return ret;		
		}
		
		
		/**
		 * 가상 통합 컬렉션(Merge Collection)의 Multi Group-By 필드명의 정의 및 개별 Collection의 Multi Group-By 필드명과 연결시키는 역할을 한다.
		 * @param idx 검색하고자 하는 컬렉션의 index
		 * @return 성공이면 검색결과 총 개수을 반환한다. 실패하거나 결과가 없을 경우 0 값을 반환한다.
		 */
		 public int addMergeMultiGroupBy(int idx) {
			int ret = 0;
			if (!wncol.MERGE_COLLECTION_INFO[idx][MERGE_MULTI_GROUP_BY_FIELD].equals("")) {				
				String mergeCollectionName = wncol.MERGE_COLLECTION_INFO[idx][MERGE_COLLECTION_NAME];
				String[] collectionNames = split(wncol.MERGE_COLLECTION_INFO[idx][MERGE_MAPPING_COLLECTION_NAME], "/");
				
				int collectionLength = collectionNames.length;
				for(int i=0; i < collectionLength; i++) {
					int chk = checkValidCollection("[addMergeMultiGroupBy]", collectionNames[i]);
					if(chk == -1){
						return -1;
					}
				}
			
				String[] mergeMultiGroupByFields = split(wncol.MERGE_COLLECTION_INFO[idx][MERGE_MULTI_GROUP_BY_FIELD], ",");
				int mergeLength = mergeMultiGroupByFields.length;
				
				String[][] documentFields = new String[collectionLength][mergeLength];
				String[] temp = split(wncol.MERGE_COLLECTION_INFO[idx][MERGE_MAPPING_MULTI_GROUP_BY_FIELD], "/");
				
				for(int k=0; k < collectionLength; k++) {
					for(int n=0; n < temp.length; n++) {
						if (k==n) documentFields[k] = split(temp[n], ",");
						if(mergeLength != documentFields[k].length){
							appendWarnings("[Error] [addMergeMultiGroupBy] [merge multi-group-by, collection multi-group-by and different.]");
							return -1;
						}
					}
				}
				
				ret = common.addMergeMultiGroupByField(mergeCollectionName, mergeMultiGroupByFields, collectionNames, documentFields);
			}
			return ret;
		}
		
		 /**
		 * 가상 통합 컬렉션(Merge Collection)의 카테고리 그룹 필드명의 정의 및 개별 Collection의 카테고리 그룹 필드명과 연결시키는 역할을 한다.
		 * @param idx  검색하고자 하는 컬렉션의 index
		 * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		 public int addMergeCategoryGroupByField(int idx) {
			int ret = 0;
			if (!wncol.MERGE_COLLECTION_INFO[idx][MERGE_CATEGORY_GROUPBY_FIELD].equals("")) {
				
				String mergeCollectionName = wncol.MERGE_COLLECTION_INFO[idx][MERGE_COLLECTION_NAME];
				String[] collectionNames = split(wncol.MERGE_COLLECTION_INFO[idx][MERGE_MAPPING_COLLECTION_NAME], "/");
				
				int collectionLength = collectionNames.length;
				for(int i=0; i < collectionLength; i++) {
					int chk = checkValidCollection("[addMergeCategoryGroupByField]", collectionNames[i]);
					if(chk == -1){
						return -1;
					}
				}
			
				String[] mergeCategoryGroupByFields = split(wncol.MERGE_COLLECTION_INFO[idx][MERGE_CATEGORY_GROUPBY_FIELD], ",");
				int mergeCategoryLength = mergeCategoryGroupByFields.length;
				
				String[][] documentFields = new String[collectionLength][mergeCategoryLength];
				String[] temp = split(wncol.MERGE_COLLECTION_INFO[idx][MERGE_MAPPING_CATEGORY_GROUPBY_FIELD], "/");
				
				for(int k=0; k < collectionLength; k++) {
					for(int n=0; n < temp.length; n++) {
						if (k == n) documentFields[k] = split(temp[n], ",");
						if(mergeCategoryLength != documentFields[k].length){
							appendWarnings("[Error] [addMergeCategoryGroupByField] [merge category-group-by, collection category-group-by and different.]");
							return -1;
						}
					}
				}
				
				
				ret = common.addMergeCategoryGroupByField(mergeCollectionName, mergeCategoryGroupByFields, collectionNames, documentFields);
			}
			return ret;
		}
		
		
		 /**
		 * 하나의 가상 통합 컬렉션(Merge Collection)으로 병합된 개별 Collection에서 검색된 문서의 전체 개수를 반환한다.
		 * @param mergeCollection 가상컬렉션 이름
		 * @param collectionName 컬렉션 이름
		 * @return 성공이면 검색결과 총 개수을 반환한다. 실패하거나 결과가 없을 경우 0 값을 반환한다.
		 */
		public int getResultTotalCountInMerge (String mergeCollection, String collection) {
			int cnt = 0;
			
			int chk = checkValidCollection("[w3GetResultTotalCountInMerge] [getResultTotalCountInMerge]", collection);
			if(chk == -1){
				return cnt;
			}
			return common.getResultTotalCountInMerge(mergeCollection, collection);
		}
		 
		/**
		* 검색결과를 XML 데이터로 반환
		*/
		public String getResultXml() {
			return common.getResultXml();
		}
		
		/**
		* 검색결과를 JSON 데이터로 반환
		*/
		public String getResultJson() {
			return common.getResultJson();
		}
		
		

		/**
		 * 네트워크 종료
		 */
		public void closeServer(){
		    common.closeServer();
		}


		/**
		 * 검색된 키워드의 분석 결과의 리스트를 얻어서 인자로 받은 문자열에 하이라이팅 한다.
		 * @param content 하이라이팅 하고자 하는 문자열
		 * @param color
		 * @return 하이라이팅된 문자열을 반환한다.
		 */
		public String getKeywordHl(String content, String color) {
			if(content != null) {
				content = content.replaceAll("<!HS>", "<font color='" + color + "'>");
				content = content.replaceAll("<!HE>", "</font>");
			}
			return content;
		}


		/**
		 * 검색된 키워드의 분석 결과의 리스트를 얻어서 인자로 받은 문자열에 하이라이팅 한다.
		 * @param content 하이라이팅 하고자 하는 문자열
		 * @param startTag 하이라이팅 하고자 하는 Tag의 시작 문자
		 * @param endTag 하이라이팅 하고자 하는 Tag의 끝 문자
		 * @return 하이라이팅된 문자열을 반환한다.
		 */
		public String getKeywordHl(String content, String startTag, String endTag) {
			if(content != null) {
				content = replace(content, "<!HS>", startTag);
				content = replace(content, "<!HE>", endTag);
			}
			return content;
		}


		/**
		 * WNCollection에서 정의된 COLLECTIONS의 index를 얻는다.
		 * @param collName 검색하고자 하는 컬렉션의 이름
		 * @return 컬렉션 index를 반환한다.
		 */
		public int getCollIdx(String collName) {
			for(int i=0; i < COLLECTIONS.length; i++) {
				if (COLLECTIONS[i].trim().equals(collName.trim())) return i;
			}
			return -1;
		}
		
		/**
		 * WNCollection에서 정의된 MERGE COLLECTIONS의 index를 얻는다.
		 * @param collName 검색하고자 하는 컬렉션의 이름
		 * @return 컬렉션 index를 반환한다.
		 */
		public int getMergeCollIdx(String collName) {
			for(int i=0; i < MERGE_COLLECTIONS.length; i++) {
				if( MERGE_COLLECTIONS[i].trim().equals(collName.trim()) ) return i;
			}
			return -1;
		}
		
		/**
		* 검색 후 해당 Collection의 Erro정보를 반환한다.
		* @param collectionName 검색을 수행한 컬렉션 이름
		* @return collection의 에러정보
		*/
		public String getCollectionErrorInfo(String collectionName) {
			return common.getCollectionErrorInfo(collectionName);
		}
		
		/**
		* 검색 API의 버전정보를 반환한다.
		* @return API 버전정보
		*/
		public String getVersionInfo() {
			return common.getVersionInfo();
		}

		/**
		 * 형태소 분석 및 대소문자 값을 체크한다.
		 * @param useKma 형태소 분석 값
		 * @param isCase 대소문자 구분 여부
		 * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		public int checkKeywordAnalyzer(String collectionName, int useKma, int isCase, int useOriginal, int useSynonym, int useDuplicateDetection) {
			int chk = 0;
			if(useKma != 0 && useKma != 1 && useKma != 2) {
				appendWarnings("[WARNING] [w3SetQueryAnalyzer] [checkKeywordAnalyzer] ["+ collectionName + "] '" + useKma + "' is not kma option");
				return -1;
			}
			if(isCase != 0 && isCase != 1) {
				appendWarnings("[WARNING] [w3SetQueryAnalyzer] [checkKeywordAnalyzer] ["+ collectionName + "] '" + isCase + "' is not case option");
				return -1;
			}
			if(useOriginal != 0 && useOriginal != 1) {
				appendWarnings("[WARNING] [w3SetQueryAnalyzer] [checkKeywordAnalyzer] ["+ collectionName + "] '" + useOriginal + "' is not use original option");
				return -1;
			}
			if(useSynonym != 0 && useSynonym != 1) {
				appendWarnings("[WARNING] [w3SetQueryAnalyzer] [checkKeywordAnalyzer] ["+ collectionName + "] '" + useSynonym + "' is not use synonym option");
				return -1;
			}
			if(useDuplicateDetection !=0 && useDuplicateDetection != 1) {
				appendWarnings("[WARNING] [w3SetQueryAnalyzer] [checkKeywordAnalyzer] ["+ collectionName + "] '" + useDuplicateDetection + "' is not use duplicate detection option");
				return -1;
			}
			
			return chk;
		}


		/**
		 * 검색하고자 하는 컬렉션을 체크한다.
		 * @param collectionName 검색하고자 하는 컬렉션
		 * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		public int checkValidCollection(String msg, String collectionName) {
			
			int chk = getCollIdx(collectionName);
			if(chk == -1 && mergeCollections != null) { //merge collection에서 check를 다시한다.
				chk = getMergeCollIdx(collectionName);
			}		
			
			if(chk == -1) {
				appendWarnings("[WARNING] "+msg+" [" + collectionName + "] Collection name is not exist.");
			}
			return chk;
		}


		/**
		 * 필드를 체크하는 각 함수에서 사용된다.
		 * @param collectionName 검색하고자 하는 컬렉션
		 * @param field 필드 이름
		 * @param item WNCollection에 지정된 상수
		 * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		public int checkValidField(String collectionName, String field, int item) {
			
			int idx = getCollIdx(collectionName);
			String[] fields = split(wncol.COLLECTION_INFO[idx][item], ",");
			int chk = findArrayValue(field, fields);
			return chk;
		}

		
		/**
		 * 필드를 체크하는 각 함수에서 사용된다.
		 * @param collectionName 검색하고자 하는 컬렉션
		 * @param field 필드 이름
		 * @param item WNCollection에 지정된 상수
		 * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		public int checkValidDocumentField(String collectionName, String field, int item) {
			int chk = -1;			
			int idx = getCollIdx(collectionName);
			if(idx != -1){
				String[] fields = split(wncol.COLLECTION_INFO[idx][item], ",");
				int length = fields.length;
				
				for(int i=0; i<length; i++) {
				    String[] documentFields = split(fields[i], "/");
					if(documentFields != null && documentFields.length > 0 && documentFields[0].equals(field)){
						chk = i;
					}
				}
			}else{	//merge collection도 체크한다.			
				idx = getMergeCollIdx(collectionName);
				if(idx != -1) {				
					String[] fields = split(wncol.MERGE_COLLECTION_INFO[idx][MERGE_RESULT_FIELD], ",");
					int length = fields.length;				
					for(int i=0; i<length; i++) {
						if(fields[i].equals(field)){
							chk = i;
						}
					}
                    if (chk == -1) {
						String[] fields1 = split(wncol.MERGE_COLLECTION_INFO[idx][MERGE_CATEGORY_GROUPBY_FIELD], ",");
						length = fields1.length;				
						for(int ii=0; ii<length; ii++) {
							if(fields1[ii].equals(field)){
								chk = ii;
							}
						}
					}
				}	
			}			
			
			return chk;
		}
		
		/**
		 * 검색하고자 하는 컬렉션의 각 필드 값을 체크한다.
		 * @param msg 화면에 출력할 메시지
		 * @param collectionName 검색하고자 하는 컬렉션
		 * @param fields 체크하고자 하는 필드
		 * @param item WNCollection에 지정된 상수
		 * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		public int checkFieldName(String msg, String collectionName, String[] fields, int item) {
			int chk = 0;
			for(int i=0; i<fields.length; i++) {
				if(fields[i] == null || (checkValidField(collectionName, fields[i], item) == -1)) {
					return i+1;
				}
			}
			return chk;
		}


		/**
		 * 검색하고자 하는 컬렉션의 확장 필드 값을 체크한다.
		 * @param msg 화면에 출력할 메시지
		 * @param collectionName 검색하고자 하는 컬렉션
		 * @param value 체크하고자 하는 필드
		 * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		public int checkExFieldName(String msg, String collectionName, String value) {
			int chk = 0;
			String[] replaceChar = new String[]{"!", "|", "(", ")", "[", "]", "{", "}", "\"", "^", "<", ">"};
			for(int i=0; i < replaceChar.length; i++) {
				value = replace(value, replaceChar[i], " ");
			}

			String[] fieldName = split(value, " ");
			for(int i=0; i < fieldName.length; i++) {
				int index = 0;
				if(fieldName[i].indexOf(":", 0) != -1) {
					index = fieldName[i].indexOf(":", 0);
					fieldName[i] = fieldName[i].trim().substring(0, index);
				}
				// 확장검색 필드 검사
				if(checkValidField(collectionName, fieldName[i], PREFIX_FIELD) == -1) {
					appendWarnings("[WARNING] " + msg + "[" + collectionName + "] " +fieldName[i]+ " is not prefix field.");
					chk = -1;
				}
			}
			return chk;
		}

		/**
		 * 검색하고자 하는 컬렉션의 쿼리 필드 값을 체크한다.
		 * @param msg 화면에 출력할 메시지
		 * @param collectionName 검색하고자 하는 컬렉션
		 * @param value 체크하고자 하는 필드
		 * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		public int checkCollectionQueryFieldName(String msg, String collectionName, String value) {
			int chk = 0;
			String[] replaceChar = new String[]{"!", "|", "(", ")", "[", "]", "{", "}", "\"", "^", "<", ">"};
			for(int i=0; i < replaceChar.length; i++) {
				value = replace(value, replaceChar[i], " ");
			}

			String[] fieldName = split(value, " ");
			for(int i=0; i < fieldName.length; i++) {
				int index = 0;
				if(fieldName[i].indexOf(":", 0) != -1) {
					index = fieldName[i].indexOf(":", 0);
					fieldName[i] = fieldName[i].trim().substring(0, index);
				}
				String[] fields = fieldName[i].split(",");
				for(int j=0;j < fields.length; j++){
					// 컬렉션 쿼리 필드 검사
					if(checkValidField(collectionName, fields[j], PREFIX_FIELD) != -1) {
						appendWarnings("[WARNING] " + msg + "[" + collectionName + "] " +fields[j]+ " is prefix field.");
						chk = -1;
					}
				}
			}
			return chk;
		}

		/**
		 * 검색하고자 하는 컬렉션의 필터링 필드 값을 체크한다.
		 * @param msg 화면에 출력할 메시지
		 * @param collectionName 검색하고자 하는 컬렉션
		 * @param value 체크하고자 하는 필드
		 * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		public int checkFilterFieldName(String msg, String collectionName, String value) {
			int chk = 0;
			String[] replaceChar = new String[]{"|", "(", ")", "[", "]", "{", "}", "\"", "^"};
			for(int i=0; i < replaceChar.length; i++) {
				value = replace(value, replaceChar[i], " ");
			}

			String[] fieldName = split(value, " ");
			for(int i=0; i < fieldName.length; i++) {
				int index = 0;
				if(fieldName[i].indexOf("<", 0) != -1) {
					index = fieldName[i].indexOf("<", 0);
					fieldName[i] = fieldName[i].trim().substring(0, index);
					// 필터링 검색 필드 검사
					if(checkValidField(collectionName, fieldName[i], FAST_ACCESS) == -1) {
						appendWarnings("[WARNING] " + msg + " [" + collectionName + "] " +fieldName[i]+ " is not fastaccess field.");
						chk = -1;
					}
				}
			}
			return chk;
		}


		/**
		 * 검색결과의 지정 범위를 체크한다.
		 * @param collectionName 검색하고자 하는 컬렉션
		 * @param highlight 하이라이팅 옵션 값
		 * @param startPos 검색결과 시작 offset
		 * @param resultCnt 검색 결과 count
		 * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		public int checkSetPageInfo(String collectionName, int highlight, int startPos, int resultCnt) {
			int chk = 0;
			if(highlight < 0 || highlight> 3 || startPos < 0 || resultCnt < 0) {
				appendWarnings("[WARNING] [] [checkSetPageInfo] [" + collectionName + "] Highlight: '"
	                        + highlight + "', StartPosition: '"+startPos+ "', ResultCount: '"+resultCnt+"' is invalid value");
				return -1;
			}
			return chk;
		}


		/**
		 * 검색 정렬 필드를 체크한다.
		 * @param collectionName 검색하고자 하는 컬렉션
		 * @param sortField 정렬필드
		 * @param sortOrder 오름차순/내림차순
		 * @return 성공이면 0을 반환한다. 실패면 0이 아닌 값을 반환한다.
		 */
		public int checkSortFieldName(String collectionName, String sortField, String sortOrder) {
			if(sortField.toUpperCase().equals("DATE")) {
				if(sortOrder.equals("DESC") == false && sortOrder.equals("ASC") == false) {
					//DATE는 오름차순과 내림차순으로만 정렬 가능
					appendWarnings("[ERROR] [w3AddSortField] [checkSortFieldName] [" + collectionName + "] Date sortOrder is '" + sortOrder + "'. Only DESC or ASC is allowed.");
					return -1;
				}
			} else if(sortField.toUpperCase().equals("RANK")) {
				if(sortOrder.equals("DESC") == false) {
					//RANK는 내림차순(1)으로만 정렬 가능
					appendWarnings("[ERROR] [w3AddSortField] [checkSortFieldName] [" + collectionName + "] RANK sortOrder is '" + sortOrder +"' Only DESC is allowed.");
					return -1;
				}
			}else if(sortField.toUpperCase().equals("WEIGHT")) {
				if(sortOrder.equals("DESC") == false && sortOrder.equals("ASC") == false) {
					//WEIGHT는 오름차순(0)과 내림차순(1)으로만 정렬 가능
					appendWarnings("[ERROR] [w3AddSortField] [checkSortFieldName] [" + collectionName + "] WEIGHT sortOrder is '" + sortOrder +"' Only DESC or ASC is allowed");
					return -1;
				}
			}else {
				// 정렬 필드 검사
				if(checkValidDocumentField(collectionName, sortField, RESULT_FIELD) == -1) {
					appendWarnings("[ERROR] [w3AddSortField] [checkSortFieldName] [" + collectionName + "] '" + sortField + "' is not exist.");
					return -1;
				}
				if(checkValidField(collectionName, sortField, FAST_ACCESS) == -1) {
					// fastaccess가 지정되지 않은 필드에서 속도 느릴수 있음.
					appendWarnings("[WARNING] [w3AddSortField] [checkSortFieldName] [" + collectionName + "] " +sortField+ " is not fastaccess field.");
				}
			}
			return 0;
		}

		/**
		 * 디버그 메시지를 구성한다.
		 * @param isRealQuery
		 * @param query
		 */
		public void debugMsg(boolean isRealQuery, String query){
			sb.append("[CHARSET] " + CHARSET + " [QUERY] " + query);
			sb.append("<br>[w3ConnectServer] [IP] " + SEARCH_IP + " [PORT] " + SEARCH_PORT + " [TIMEOUT]" + CONNECTION_TIMEOUT);
			if(!isUidSrch) {
				sb.append("<br>[w3RecvResult] Mode : " + this.connectionOpt);
				if(isRealQuery){
					sb.append("<br>[W3ReceiveRecentQueryListResult] Set Count : " + REALTIME_COUNT);
				}
			}

			sb.append("<br>");
			for(int i=0; i < collections.length; i++) {
				int idx = getCollIdx(collections[i]);

				if(idx < 0){
					return;
				}
				int count = 0;

				// 컬렉션 정보
				String content = wncol.COLLECTION_INFO[idx][INDEX_NAME];
				if(content != null && !content.equals("")){
					sb.append("<br>[w3AddCollection] <b>" + content + "</b>");
				}
				if(!isUidSrch) {
					//페이지 설정
					content = wncol.COLLECTION_INFO[idx][PAGE_INFO];
					if(content != null && !content.equals("")){
						sb.append("<br>[w3SetPageInfo] " + content);
					}

					//분석 정보
					content = wncol.COLLECTION_INFO[idx][ANALYZER];
					if(content != null && !content.equals("")){
						sb.append("<br>[w3SetQueryAnalyzer] " + content);
					}

					//하이라이팅 정보
					count = this.hiSum;
					if(count >= 0){
						switch(count){
						case 0:
							content = " : Highlight off, Snippet off.";break;
						case 1:
							content = " : Highlight off, Snippet on.";break;
						case 2:
							content = " : Highlight on, Snippet off.";break;
						case 3:
							content = " : Highlight on, Snippet on.";break;
						default:
							content = " : wrong infomation";
						}
						sb.append("<br>[w3SetQueryAnalyzer] " + count + content);
					}

					//정렬 정보
					content = wncol.COLLECTION_INFO[idx][SORT_FIELD];
					if(content != null && !content.equals("")){
						sb.append("<br>[w3AddSortField] " + content);
					}

					//검색 필드 정보
					String search_field = wncol.COLLECTION_INFO[idx][SEARCH_FIELD];
					String[] searchField = search_field.split(",");

					content = wncol.COLLECTION_INFO[idx][SEARCH_FIELD];
					if(content != null && !content.equals("")){
						sb.append("<br>[w3AddSearchField] " );
						for(int k = 0; k<searchField.length; k++){
							if(k != 0){
								sb.append(", ");
							}
							sb.append(searchField[k]);
						}
					}

					//기간 정보
					content = wncol.COLLECTION_INFO[idx][DATE_RANGE];
					if(content != null && !content.equals("")){
						sb.append("<br>[w3SetDateRange] " + content);
					}

					//확장 검색  정보
					content = wncol.COLLECTION_INFO[idx][EXQUERY_FIELD];
					if(content != null && !content.equals("")){
						sb.append("<br>[w3SetPrefixQuery] " + content.replaceAll("<", "&lt;").replaceAll(">", "&gt;"));
					}

					//카테고리 부스트 정보
					content = wncol.COLLECTION_INFO[idx][CATEGORY_BOOST];
					if(content != null && !content.equals("")){
						sb.append("<br>[w3SetBoostCategory] " + content);
					}

					//컬렉션 쿼리 정보
					content = wncol.COLLECTION_INFO[idx][COLLECTION_QUERY];
					if(content != null && !content.equals("")){
						sb.append("<br>[w3SetCollectionQuery] " + content.replaceAll("<", "&lt;").replaceAll(">", "&gt;"));
					}

					//필터 정보
					content = wncol.COLLECTION_INFO[idx][FILTER_OPERATION];
					if(content != null && !content.equals("")){
						sb.append("<br>[w3SetFilterQuery] " + content.replaceAll("<", "&lt;").replaceAll(">", "&gt;"));
					}

					//그룹화  정보
					content = wncol.COLLECTION_INFO[idx][GROUP_BY];
					if(content != null && !content.equals("")){
						sb.append("<br>[w3SetGroupBy] " + content);
					}

					//그룹 정렬  정보
					content = wncol.COLLECTION_INFO[idx][GROUP_SORT_FIELD];
					if(content != null && !content.equals("")){
						sb.append("<br>[w3AddSortFieldInGroup] " + content);
					}


					if(!wncol.COLLECTION_INFO[idx][GROUP_BY].equals("")){
						//전체 그룹 개수 정보
						count = getResultGroupCount(collections[i]);
						if(count > 0){
							sb.append("<br>[w3GetGroupBycount] " + count);
						}
					}

                    // dedup field
                    content = wncol.COLLECTION_INFO[idx][DEDUP_SORT_FIELD];
                    if(content != null && !content.equals("")){
                        sb.append("<br>[w3SetDuplicateDetectionCriterionField] " + content);
                    }
				}

				//결과 필드 정보
				content = wncol.COLLECTION_INFO[idx][RESULT_FIELD];
				if(content != null && !content.equals("")){
					sb.append("<br>[w3AddDocumentField] " + content);
				}
				sb.append("<br>");
			}
			
			//merge collection debug info
			if(mergeCollections != null) {
				for(int i=0; i < mergeCollections.length; i++) {
					int idx = getMergeCollIdx(mergeCollections[i]);

					if(idx < 0){
						return;
					}
					
					//merge collection name 정보
					String content = wncol.MERGE_COLLECTION_INFO[idx][MERGE_COLLECTION_NAME];
					String mappingColl =  wncol.MERGE_COLLECTION_INFO[idx][MERGE_MAPPING_COLLECTION_NAME];
					if(content != null && !content.equals("") && mappingColl != null && !mappingColl.equals("")){
						sb.append("<br>[w3AddMergeCollection] <b>" + content + "</b>, [Collection Name]<b>" + mappingColl + "</b>");
					}
					
					content = wncol.MERGE_COLLECTION_INFO[idx][MERGE_PAGE_INFO];
					if(content != null && !content.equals("")){
						sb.append("<br>[w3SetMergePageInfo] " + content);
					}
					
					content = wncol.MERGE_COLLECTION_INFO[idx][MERGE_RESULT_FIELD];
					String mappingDocs = wncol.MERGE_COLLECTION_INFO[idx][MERGE_MAPPING_RESULT_FIELD];
					if(content != null && !content.equals("") && mappingDocs != null && !mappingDocs.equals("")){
						sb.append("<br>[w3AddMergeDocumentField] " + content + ", [Collection Document Fields]" + mappingDocs);
					}
					
					content = wncol.MERGE_COLLECTION_INFO[idx][MERGE_MULTI_GROUP_BY_FIELD];
					String mappingMulti = wncol.MERGE_COLLECTION_INFO[idx][MERGE_MAPPING_MULTI_GROUP_BY_FIELD];
					if(content != null && !content.equals("") && mappingMulti != null && !mappingMulti.equals("")){
						sb.append("<br>[w3AddMergeMultiGroupByField] " + content + ", [Collection Multi-Groupby Fields]" + mappingMulti);
					}
					
					content = wncol.MERGE_COLLECTION_INFO[idx][MERGE_CATEGORY_GROUPBY_FIELD];
					String mappingCategory = wncol.MERGE_COLLECTION_INFO[idx][MERGE_MAPPING_CATEGORY_GROUPBY_FIELD];
					if(content != null && !content.equals("") && mappingCategory != null && !mappingCategory.equals("")){
						sb.append("<br>[w3AddMergeCategoryGroupByField] " + content + ", [Collection Category Groupby Fields]" + mappingCategory);
					}
				}
				
				sb.append("<br>");
			}
		}

		/**
		 * 경고 메시지를 버퍼에 저장한다.
		 * @param msg 경고 메시지
		 */
		public void appendWarnings(String msg) {
			if(isDebug && !msg.equals("")){
				warningMsg.append(msg + "<br>");
			}
		}


		/**
		 * 에러 메시지를 버퍼에 저장한다.
		 * @param msg 에러 메시지
		 */
		public void appendErrors(String msg) {
			if(!msg.equals("")){
				sb.append("<br>" + msg + "<br>");
			}
		}

		/**
		 * 디버그 정보를 화면에 출력할 경우 메시지를 반환한다.
		 * @return 디버그 정보 반환
		 */
		public String printDebug() {
			if(!warningMsg.toString().equals("")){
				return sb.toString() + "<br>" + warningMsg.toString()+ "<br>";
			}
			return sb.toString();
		}

		/**
		 * 관리도구의 경로를 지정한다.
		 * @param managerURL 관리도구 경로
		 */
		public void setManagerMode(String managerURL){
			if(managerURL != null && !managerURL.trim().equals("")){
				this.managerURL = managerURL;
			}
		}

		/*
		 * 매니저 동작 준비 테그를 생성한다.
		 * @param colName 컬렉션 명
		 * @param idx 결과 인덱스
		 * @param docid 특정 결과 DOCID
		 * @return 매니저 동작 준비 테그
		 */
		public String getManagerOperationTag(String colName, int idx, String docid){
			String uniid = colName + "_" + idx;
			if (!this.managerURL.equals("")){
				return "<input type='checkbox' name='manager_idx' id='" + uniid + "'  value='checkbox' onclick=\"javascript:manager_addDocIdForDelete('" + colName + "', '" + docid + "', '" + uniid + "')\" />" + docid + "&nbsp";
			}else{
				return "";
			}
		}

		/*
		 * 매니저 동작 테그를 생성한다.
		 * @param transferURL xml 파싱 파일 경로
		 * @return 매니저 동작 테그
		 */
		public String getManagerActionTag(String transferURL) {
			if (!this.managerURL.equals(""))
				return "<input type='button'  value='Delete' onclick=\"javascript:manager_runDelete('" + transferURL + "', '" + this.managerURL + "', '" + SEARCH_IP + "', " + SEARCH_PORT + ")\" />";
			else
				return "";
		}

		/**
		 * 검색 결과 페이징 번호를 출력한다.
		 * @param startCount 검색 결과 시작 offset
		 * @param totalCount 검색 결과의 총 개수
		 * @param viewListCount 검색결과로 요청된 offset의 개수
		 * @param bundleCount 페이지 이동할 개수
		 * @return 페이징 문자열 반환
		 */
		public String getPageLinks(int startCount, int totalCount, int viewListCount, int bundleCount) {
			StringBuffer sbRet = new StringBuffer();
			WNAnchor wnanchor = getPageAnchor(startCount, totalCount, viewListCount, bundleCount);
			
			if(wnanchor.getFirstPage() != -1) {
				sbRet.append("<a class=\"pre\" href=\"#none\" onClick=\"javascript:doPaging('"+wnanchor.getBundleBefore()+"');\" title=\"이전페이지\">이전페이지</a>");
			} else {
				sbRet.append("<a class=\"pre\" href=\"#none\" title=\"이전페이지\">이전페이지</a>");
			} 
 
			int pageCount = wnanchor.getPageCount();
			String pages[][] = wnanchor.getPages();

			for(int i=0; i<pageCount && i < pages.length; i++) {
				if(pages[i][1].equals("-1")) {
					sbRet.append("<strong>" + pages[i][0] + "</strong>");
				} else {
					sbRet.append("<a href=\"#none\" onClick=\"javascript:doPaging('"+pages[i][1]+"');\" title=\"페이징\"> "+pages[i][0]+" </a>");
				}
			}

			if(wnanchor.getBundleNext() != -1) {
    			sbRet.append("<a class=\"next\" href=\"#none\" onClick=\"javascript:doPaging('"+wnanchor.getBundleNext()+"')\" title=\"다음페이지\">다음페이지</a>");
			} else {
				sbRet.append("<a class=\"next\" href=\"#none\" title=\"다음페이지\">다음페이지</a>");
			}
 
			return sbRet.toString();
		}

		/**
		 * 페이지 Anchor를 생성한다.
		 * @param startNum 검색 결과 시작 offset
		 * @param totalcount 검색 결과의 총 개수
		 * @param resultCnt 검색결과로 요청된 offset의 개수
		 * @param anchorSacle 페이지 이동할 개수
		 * @return WNAnchor Object를 반환
		 */
		public WNAnchor getPageAnchor(int startNum, int totalcount, int resultCnt, int anchorSacle) {
			WNAnchor anchor = new WNAnchor();

			if(totalcount == 0) {   //등록된 정보가 없으면 페이지 Anchor를 생성 하지 않는다.
				return anchor;
			}

			int curBunbleNum = startNum / (resultCnt * anchorSacle);
			int totalPageCnt = totalcount / resultCnt;
			if(totalcount % resultCnt > 0) {
				totalPageCnt++;
			}

			anchor.setTotalPgCount(totalPageCnt);      // 전체 페이지 세팅

			if ( startNum > 0){        // 이전 페이지
				int beforePg = startNum - resultCnt;
				anchor.setBefore(beforePg);
			}

			if( startNum+resultCnt < totalcount ){        // 다음페이지
				int nextPg = startNum + resultCnt;
				anchor.setNext(nextPg);
			}

			//번들 뒤로 이동
			int bunbleBeforePg = (curBunbleNum-1) * resultCnt * anchorSacle;    //이전 번들로 이동하는 번호
			if(curBunbleNum > 0){
				anchor.setBundleBefore(bunbleBeforePg);
			}

			//번들 앞으로 이동
			int bundleNextPg = (1 + curBunbleNum) * anchorSacle * resultCnt;
			if( totalPageCnt >= anchorSacle && (curBunbleNum+1) * anchorSacle <  totalPageCnt ){
				anchor.setBundleNext(bundleNextPg);
			}

			//맨처음..
			if(startNum != 0 && curBunbleNum != 0){
				anchor.setFirstPage(0);
			}
			//맨끝...
			int lastPage = (resultCnt * totalPageCnt) - resultCnt ;
			if( totalPageCnt >= anchorSacle && (curBunbleNum+1) * anchorSacle <  totalPageCnt ) {
				anchor.setLastPage(lastPage);
			}

			int pageCount = 1;
			String[][] pages = new String[anchorSacle][2];
			for(int i = 0; i < anchorSacle; i++) {
				int startCnt = ((curBunbleNum * anchorSacle) + i) * resultCnt;
				int pageNum = (curBunbleNum * anchorSacle) + i + 1;
				if(startCnt < totalcount) {
					if (startCnt != startNum) {
						pages[i][0] = Integer.toString(pageNum);
						pages[i][1] = Integer.toString(startCnt);
					} else {
						pages[i][0] = Integer.toString(pageNum);
						pages[i][1] = "-1";
						anchor.setCurPageNumber(pageNum);
					}
					anchor.setPageCount(pageCount);
					pageCount++;
				}
			}
			anchor.setPages(pages);
			return anchor;
		}



        /**
         * 검색 결과 페이징 번호를 출력한다.
         * @param startCount 검색 결과 시작 offset
         * @param totalCount 검색 결과의 총 개수
         * @param viewListCount 검색결과로 요청된 offset의 개수
         * @param bundleCount 페이지 이동할 개수
         * @return 페이징 문자열 반환
         */
        public String getPageLinksWebAccess(String base, String url, int startCount, int totalCount, int viewListCount, int bundleCount) {

			String RequestURI = base;
			String RequestURL = url;

            StringBuffer sbRet = new StringBuffer();
            WNAnchor wnanchor = getPageAnchor(startCount, totalCount, viewListCount, bundleCount);
            String ppreImg="";
            String preImg="";
            String nextImg="";
            String nnextImg="";
            ppreImg = "<IMG SRC='images/navi/icon_first.gif' BORDER='0' align='absmiddle'>";
            preImg = "<IMG SRC='images/navi/icon_preview.gif' BORDER='0' align='absmiddle'>";
            nextImg = "<IMG SRC='images/navi/icon_next.gif' BORDER='0' align='absmiddle'>";
            nnextImg = "<IMG SRC='images/navi/icon_end.gif' BORDER='0' align='absmiddle'>";

            if(wnanchor.getFirstPage() != -1) {
                sbRet.append("<A HREF='" + replaceURL(RequestURI, RequestURL, "startCount",String.valueOf(wnanchor.getFirstPage())) +"'  >"+ppreImg+"</A>&nbsp;&nbsp;");
            } else {
                sbRet.append(ppreImg+"&nbsp;");
            }
            if(wnanchor.getBundleBefore() != -1) {
                sbRet.append("<A HREF='" + replaceURL(RequestURI, RequestURL, "startCount", String.valueOf(wnanchor.getFirstPage())) +"'  >"+preImg+"</A>&nbsp;&nbsp;");
            } else {
                sbRet.append(preImg+"&nbsp;");
            }

            int pageCount = wnanchor.getPageCount();
            String pages[][] = wnanchor.getPages();

            for(int i=0; i<pageCount && i < pages.length; i++) {
                if(pages[i][1].equals("-1")) {
                    sbRet.append("<b>" + pages[i][0]+"</b>");
                } else {
                    sbRet.append("<A HREF='" + replaceURL(RequestURI,RequestURL,"startCount", String.valueOf(pages[i][1])) + "' class='nav'> "+pages[i][0]+" </A>");
                }
                if(pageCount > i+1) {
                    sbRet.append("&nbsp;|&nbsp;");// 페이지 경계 1 | 2 | 3
                }
            }
            if(wnanchor.getBundleNext() != -1) {
                sbRet.append("&nbsp;&nbsp;<A HREF='" + replaceURL(RequestURI,RequestURL,"startCount",String.valueOf(wnanchor.getBundleNext())) + "'>"+nextImg+"</A>");
            } else {
                sbRet.append("&nbsp;&nbsp;"+nextImg+"");
            }
            if(wnanchor.getLastPage() != -1) {
                sbRet.append("&nbsp;&nbsp;<A HREF='" + replaceURL(RequestURI,RequestURL,"startCount",String.valueOf(wnanchor.getLastPage())) + "'>"+nnextImg+"</A>");
            } else {
                sbRet.append("&nbsp;&nbsp;"+nnextImg+"");
            }
            return sbRet.toString();
        }


        public String getCollectionKorName(String col) {
            String value = "";
            for ( int idx=0;idx< COLLECTIONS.length; idx++){
                String coll = wncol.COLLECTION_INFO[idx][COLLECTION_NAME].trim();
                if ( coll.equals(col) )
                    return wncol.COLLECTION_INFO[idx][COLLECTION_KOR];

            }

            return value;
        }

		public String getCollectionName(String col) {
			String value = "";
			for ( int idx=0;idx< COLLECTIONS.length; idx++){
				if ( COLLECTIONS[idx].equals(col) ) {
					return COLLECTIONS_NAME[idx];
				}
			}

			return value;
		}
	}
%>