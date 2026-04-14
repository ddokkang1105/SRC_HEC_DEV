package xbolt.api.exception;

import com.fasterxml.jackson.core.JsonProcessingException;

public class CustomJsonProcessingException extends JsonProcessingException{
	

    private static final long serialVersionUID = 1L;
	
    public CustomJsonProcessingException(String message, Throwable cause) {
        super(message, cause); 
        
    }

}
