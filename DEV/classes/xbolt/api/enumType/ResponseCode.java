package xbolt.api.enumType;

import org.springframework.http.HttpStatus;

public enum ResponseCode {

    //SUCCESS
    // 200 OK
    SELECT_SUCCESS(HttpStatus.OK, "조회 성공"),
    UPDATE_SUCCESS(HttpStatus.OK, "수정 성공"),
    INSERT_SUCCESS(HttpStatus.OK, "생성 성공"),
    DELETE_SUCCESS(HttpStatus.OK, "삭제 성공");

    private final HttpStatus httpStatus;
    private final String message;

    ResponseCode(HttpStatus httpStatus, String message) {
		this.httpStatus = httpStatus;
		this.message = message;
	}

	public int getHttpStatusCode() {

        return httpStatus.value();
    }

}