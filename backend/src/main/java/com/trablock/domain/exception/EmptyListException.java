package com.trablock.domain.exception;

public class EmptyListException extends RuntimeException {

    private static final long serialVersionUID = 6410744374489766116L;

    public EmptyListException(String msg){
        super(msg);
    }
}