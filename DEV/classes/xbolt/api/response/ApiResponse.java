package xbolt.api.response;

import xbolt.api.enumType.ErrorCode;

public class ApiResponse<T> {

	private String status;
    private int code;
    private String msg;
    private T data;

    private static final String SUCCESS = "success";

    private static final String FAIL = "fail";


    private ApiResponse(String status, int code, String msg, T data) {
    	this.status = status;
        this.code = code;
        this.msg = msg;
        this.data = data;
    }

	public static <T> ApiResponse<T> success(int code, String message, T data) {
        return new ApiResponse<T>("S", 200, "정상처리", data);
    }

    public static <T> ApiResponse<T> fail(ErrorCode errorCode, T data) {
        return new ApiResponse<T>("F", errorCode.getResultCd(), errorCode.getResultMsg(), data);
    }


	public String getStatus() {
		return status;
	}


	public int getCode() {
		return code;
	}


	public String getMsg() {
		return msg;
	}


	public T getData() {
		return data;
	}


	public static String getSuccess() {
		return SUCCESS;
	}


	public static String getFail() {
		return FAIL;
	}
    



}