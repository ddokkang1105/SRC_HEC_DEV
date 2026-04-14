package xbolt.api.exception;

import xbolt.api.enumType.ErrorCode;

public class CustomException extends Exception{
	
	private ErrorCode errorCode;
	
	public CustomException(ErrorCode errorCode) {
		
		super(errorCode != null ? errorCode.getResultMsg() : "Not Registered ErrorCode");
		this.errorCode = errorCode;
	}
	
	public ErrorCode getErrorCode() {
		return errorCode;
	}
	
}
