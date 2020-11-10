package com.dolligo;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.scheduling.annotation.EnableScheduling;

@EnableCaching//캐시 사용하겠다
@EnableScheduling//background task executor 생성 => for @Scheduled 
@ServletComponentScan//filter사용
@SpringBootApplication
@MapperScan(value = "com.dolligo.repository")
public class Application extends SpringBootServletInitializer{

	public static void main(String[] args) {
		SpringApplication.run(Application.class, args);
	}
 
	@Override protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) { 
		return builder.sources(Application.class); 
	}

}
