package com.dolligo.exception;

public class RepositoryException extends RuntimeException {
    static final long serialVersionUID = 1;

    public RepositoryException(Throwable throwable, String msg){
        super(msg, throwable);
    }

    public RepositoryException(String msg){
        super(msg);
    }

    public RepositoryException(Throwable throwable){
        super(throwable);
    }

}
