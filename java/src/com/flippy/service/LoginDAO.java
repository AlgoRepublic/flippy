package com.flippy.service;

import java.util.Map;


public interface LoginDAO {
	Map<String,Object> login(String userName, String password); 
}
