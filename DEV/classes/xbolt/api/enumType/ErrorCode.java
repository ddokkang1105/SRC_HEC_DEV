package xbolt.api.enumType;


import org.springframework.http.HttpStatus;

public enum ErrorCode {

    //ERROR
    // 400 Bad Request
    // 403 Forbidden
    // 404 Not Found
    // 405 Method Not Allowed
    // 409 Conflict
    // 500 Internal Server Error


    
    BAD_REQUEST(HttpStatus.BAD_REQUEST, 400, "잘못된 요청입니다."),


    
    
    
    INTERNAL_SERVER_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, 402, "서버에 오류가 발생하였습니다."),

    
    
    INVALID_API_KEY(HttpStatus.UNAUTHORIZED, 403, "올바르지 않은 API KEY"),
    
    INVALID_USER(HttpStatus.UNAUTHORIZED, 410, "존재하지 않는 ID"),
    
    ITEM_INSERT_ERROR(HttpStatus.UNAUTHORIZED, 410, "ITEM 데이터 입력 중 오류 발생"),
    ITEM_ST1_INSERT_ERROR(HttpStatus.UNAUTHORIZED, 410, "ST1 데이터 입력 중 오류 발생"),
    ITEM_ATTR_INSERT_ERROR(HttpStatus.UNAUTHORIZED, 410, "ATTR 데이터 입력 중 오류 발생"),
    ITEM_ATTR_REV_INSERT_ERROR(HttpStatus.UNAUTHORIZED, 410, "ATTR REV 데이터 입력 중 오류 발생"),
    CHANGESET_INSERT_ERROR(HttpStatus.UNAUTHORIZED, 410, "CS 데이터 입력 중 오류 발생"),
    DIM_INSERT_ERROR(HttpStatus.UNAUTHORIZED, 410, "DIM 데이터 입력 중 오류 발생"),
    PLM_INSERT_ERROR(HttpStatus.UNAUTHORIZED, 410, "PLM 데이터 입력 중 오류 발생"),
    LOG_INSERT_ERROR(HttpStatus.UNAUTHORIZED, 410, "LOG 데이터 입력 중 오류 발생"),
    
    ITEM_DELETE_ERROR(HttpStatus.UNAUTHORIZED, 411, "ITEM 데이터 삭제 중 오류 발생"),
    ITEM_ST1_DELETE_ERROR(HttpStatus.UNAUTHORIZED, 411, "ST1 데이터 삭제 중 오류 발생"),
    ITEM_ATTR_DELETE_ERROR(HttpStatus.UNAUTHORIZED, 411, "ATTR 데이터 삭제 중 오류 발생"),
    CHANGESET_DELETE_ERROR(HttpStatus.UNAUTHORIZED, 411, "CS 데이터 삭제 중 오류 발생"),
    DIM_DELETE_ERROR(HttpStatus.UNAUTHORIZED, 411, "DIM 데이터 삭제 중 오류 발생"),
    
    PARENT_ID_SELECT_ERROR(HttpStatus.UNAUTHORIZED, 412, "FromItemId 조회 중 오류 발생"),
    PROJECT_INFO_SELECT_ERROR(HttpStatus.UNAUTHORIZED, 412, "Project 정보 조회 중 오류 발생"),
    USER_INFO_SELECT_ERROR(HttpStatus.UNAUTHORIZED, 412, "User 정보 조회 중 오류 발생"),

    
    IDENTIFIER_GENERATE_ERROR(HttpStatus.UNAUTHORIZED, 413, "채번 생성 중 오류 발생"),
    
    CHECK_DOC_NO_ERROR(HttpStatus.UNAUTHORIZED, 414, "DocNo 중복 확인 중 오류 발생"),
    
    
    LOVCODE_SELECT_ERROR(HttpStatus.UNAUTHORIZED, 415, "LovCode 정보 조회 중 오류 발생"),
    VALUE_SELECT_ERROR(HttpStatus.UNAUTHORIZED, 415, "Value 정보 조회 중 오류 발생"),
    PLM_ITEM_INFO_SELECT_ERROR(HttpStatus.UNAUTHORIZED, 415, "PLM 정보 조회 중 오류 발생"),
    
    USER_ITEM_UPDATE_ERROR(HttpStatus.UNAUTHORIZED, 416, "User 정보 업데이트 중 오류 발생"),
    
    
    
    INVALID_JSON_INPUT(HttpStatus.NOT_ACCEPTABLE, 420, "필수 항목 누락"),
    //필수 항목 누락 : 421~429
    
    
    INVALID_JSON_INPUT1(HttpStatus.NOT_ACCEPTABLE, 421, "문서번호/Rev. 항목 누락"), 
    INVALID_JSON_INPUT2(HttpStatus.NOT_ACCEPTABLE, 422, "문서명 항목 누락"),    
    INVALID_JSON_INPUT3(HttpStatus.NOT_ACCEPTABLE, 423, "담당 Site 항목 누락"), 
    INVALID_JSON_INPUT4(HttpStatus.NOT_ACCEPTABLE, 424, "담당자 사번  항목 누락"),  
    INVALID_JSON_INPUT5(HttpStatus.NOT_ACCEPTABLE, 425, "NCT 여부 항목 누락"), 
    INVALID_JSON_INPUT6(HttpStatus.NOT_ACCEPTABLE, 426, "문서 영역 항목 누락"),  
    INVALID_JSON_INPUT7(HttpStatus.NOT_ACCEPTABLE, 427, "문서 레벨 항목 누락"), 
    INVALID_JSON_INPUT8(HttpStatus.NOT_ACCEPTABLE, 428, "문서 분야 항목 누락"),  
    INVALID_JSON_INPUT9(HttpStatus.NOT_ACCEPTABLE, 429, "공정 항목 누락"), 
    
    
    
    //파일 미존재
    NO_FILE_AVAILABLE(HttpStatus.NOT_FOUND, 430, "파일 미존재"),
    FILE_COPY_ERROR(HttpStatus.METHOD_NOT_ALLOWED, 431, "파일 복사 중 오류 발생"),
    FILE_INSERT_ERROR(HttpStatus.METHOD_NOT_ALLOWED, 432, "파일 입력 중 오류 발생"),
    FILE_DELETE_ERROR(HttpStatus.METHOD_NOT_ALLOWED, 433, "파일 삭제 중 오류 발생"),

    
    
    INVALID_DATA_FORMAT(HttpStatus.NOT_ACCEPTABLE, 440, "미정의된 항목값"),
    //미정의된 항목값 :  441-448
    INVALID_DATA_FORMAT1(HttpStatus.NOT_ACCEPTABLE, 441, "처리 유형 값 오류"),   
    INVALID_DATA_FORMAT2(HttpStatus.NOT_ACCEPTABLE, 442, "문서 구분 값 오류"),    
    INVALID_DATA_FORMAT3(HttpStatus.NOT_ACCEPTABLE, 443, "담당 Site 값 오류"),   
    INVALID_DATA_FORMAT4(HttpStatus.NOT_ACCEPTABLE, 444, "NCT 여부 값 오류"),    
    INVALID_DATA_FORMAT5(HttpStatus.NOT_ACCEPTABLE, 445, "문서 영역 값 오류"),   
    INVALID_DATA_FORMAT6(HttpStatus.NOT_ACCEPTABLE, 446, "문서 레벨 값 오류"),    
    INVALID_DATA_FORMAT7(HttpStatus.NOT_ACCEPTABLE, 447, "문서 분야 값 오류"),   
    INVALID_DATA_FORMAT8(HttpStatus.NOT_ACCEPTABLE, 448, "공정 값 오류"),        
    INVALID_DATA_FORMAT9(HttpStatus.NOT_ACCEPTABLE, 449, "지정 Site 값 오류"),        
    
    ETC_ERROR(HttpStatus.BAD_REQUEST, 490, "기타 오류"),
    
    REV_DUPLICATED(HttpStatus.BAD_REQUEST, 450, "BPLM 문서번호 Revision 중복 수신"),
    ;




	private final HttpStatus httpStatus;
    private final int resultCd;
    private final String resultMsg;;
    
    public int getHttpStatusCode() {

        return httpStatus.value();
    }

	public int getResultCd() {
		return resultCd;
	}


	public String getResultMsg() {
		return resultMsg;
	}
	
	ErrorCode(HttpStatus httpStatus, int resultCd, String resultMsg) {

        this.httpStatus = httpStatus;
        this.resultCd = resultCd;
        this.resultMsg = resultMsg;
    }


}