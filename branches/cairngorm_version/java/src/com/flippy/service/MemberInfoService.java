package com.flippy.service;

import org.springframework.context.ApplicationContext;

import com.flippy.domain.MemberInfo;

public class MemberInfoService {

	public static MemberInfo findByUserName(String userName) {
		ApplicationContext ctx = ServiceManager.getInstance().getContext();

		return ((MemberInfoDAOImpl) ctx.getBean("MemberInfoService"))
				.findByUserName(userName);
	}

	public static void main(String[] args) {
		MemberInfo o = MemberInfoService.findByUserName("reni");
		
		if (o != null) {
			System.out.println(o);
		} else {
			System.out.println("no resutl");
		}
	}

}
