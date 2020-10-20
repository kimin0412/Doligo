package com.trablock.api;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/error")
public class FilterErrorController {
	@RequestMapping("jwtfilter")
    public void flterError(HttpServletRequest req) {
    	throw new SecurityException((String)req.getAttribute("msg"));
    }
}
