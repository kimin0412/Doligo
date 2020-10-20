package com.trablock.domain.exception;

public class NotFoundException extends RuntimeException {
    private static final long serialVersionUID = 2157902426746147324L;

    public NotFoundException(String msg){
        super(msg);
    }
}