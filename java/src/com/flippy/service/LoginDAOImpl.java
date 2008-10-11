package com.flippy.service;

import java.util.Map;

import javax.sql.DataSource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.jdbc.core.simple.SimpleJdbcTemplate;

public class LoginDAOImpl implements LoginDAO {
    private static final Log logger = LogFactory.getLog(LoginDAOImpl.class);
    
	private SimpleJdbcTemplate simpleJdbcTemplate;

	public void setDataSource(DataSource dataSource) {
		simpleJdbcTemplate = new SimpleJdbcTemplate(dataSource);
	}

	@Override
	public Map<String, Object> login(String userName, String password) {
		String sql = 
			"select l.user_name, l.password, l.role_id, r.name from fl_login l join fl_role r on l.role_id = r.id " +
			"where user_name=? and password=?";

		Map<String, Object> ret=null;
		
		try {
			ret = simpleJdbcTemplate.queryForMap(sql, userName, password);
		} catch (Throwable e) {
			logger.error("Failed getting user information", e);
		}

		return ret;
	}

}
