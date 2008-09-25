package com.flippy.service;

import java.util.Map;

import org.springframework.context.ApplicationContext;

public class LoginService {

	public static Map<String, Object> login(String userName, String password) {
		ApplicationContext ctx = ServiceManager.getInstance().getContext();

		return ((LoginDAO) ctx.getBean("LoginService")).login(userName,	password);
	}

	public static void main(String[] args) {
		Map<String, Object> l = LoginService.login("hendra", "manager");

		if (l != null) {
			System.out.println(l);
		} else {
			System.out.println("Empty result");
		}
	}

}
