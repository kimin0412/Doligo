package com.trablock.domain.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(code = HttpStatus.BAD_REQUEST)
public class BadRequestException extends Exception {
    static final long serialVersionUID = 1;
    private String errorMessage;

    public BadRequestException() {
        super();
    }

    public BadRequestException(Throwable throwable, String errorMessage){
        super(errorMessage, throwable);
        this.errorMessage = errorMessage;
    }

    public BadRequestException(String errorMessage){
        super(errorMessage);
        this.errorMessage = errorMessage;
    }

    public BadRequestException(Throwable throwable){
        super(throwable);
    }

    public String getErrorMessage() {
        return errorMessage;
    }

}