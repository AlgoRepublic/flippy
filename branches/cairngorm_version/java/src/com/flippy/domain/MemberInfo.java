package com.flippy.domain;

import java.util.Date;

public class MemberInfo {
	private String userName;
	private String roleName;
	private String city;
	private Date dtlastlogin;
	
	
	public MemberInfo() {
		super();
	}
	
	/**
	 * @return the userName
	 */
	public String getUserName() {
		return userName;
	}

	/**
	 * @param userName the userName to set
	 */
	public void setUserName(String userName) {
		this.userName = userName;
	}

	/**
	 * @return the roleName
	 */
	public String getRoleName() {
		return roleName;
	}

	/**
	 * @param roleName the roleName to set
	 */
	public void setRoleName(String roleName) {
		this.roleName = roleName;
	}

	/**
	 * @return the city
	 */
	public String getCity() {
		return city;
	}

	/**
	 * @param city the city to set
	 */
	public void setCity(String city) {
		this.city = city;
	}

	/**
	 * @return the dtlastlogin
	 */
	public Date getDtlastlogin() {
		return dtlastlogin;
	}

	/**
	 * @param dtlastlogin the dtlastlogin to set
	 */
	public void setDtlastlogin(Date dtlastlogin) {
		this.dtlastlogin = dtlastlogin;
	}

	
	@Override
	public String toString() {
		return "{userName="+userName+";roleName="+roleName+";city="+city+";dtlastlogin="+dtlastlogin+"}";
	}
	
	
}
