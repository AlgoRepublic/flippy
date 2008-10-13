package com.flippy.service;

import com.flippy.domain.MemberInfo;


public interface MemberInfoDAO {
	MemberInfo findByUserName(String userName);
}
