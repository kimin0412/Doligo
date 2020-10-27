package com.dolligo.exception;

public class ApplicationException extends RuntimeException {
    static final long serialVersionUID = 1;

    public ApplicationException(Throwable throwable, String msg){
        super(msg, throwable);
    }

    public ApplicationException(String msg){
        super(msg);
    }

    public ApplicationException(Throwable throwable){
        super(throwable);
    }

}

