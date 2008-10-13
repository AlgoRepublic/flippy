package com.flippy.service;

import java.sql.ResultSet;
import java.sql.SQLException;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.jdbc.core.simple.ParameterizedRowMapper;
import org.springframework.jdbc.core.simple.SimpleJdbcTemplate;

import com.flippy.domain.MemberInfo;

public class MemberInfoDAOImpl implements MemberInfoDAO {

	private SimpleJdbcTemplate simpleJdbcTemplate;

	public void setDataSource(DataSource dataSource) {
		simpleJdbcTemplate = new SimpleJdbcTemplate(dataSource);
	}

	@Override
	public MemberInfo findByUserName(String userName) {
		String sql = 
			"select fl.user_name, fr.name role_name, m.n_city city, fl.dtlastlogin " +
			"from fl_login fl, t_member m, fl_role fr " +
			"where fl.user_name = m.c_username " +
			"and fl.role_id = fr.id " +
			"and fl.user_name = ? ";
				
		MemberInfo ret = null;
		try {
			ParameterizedRowMapper<MemberInfo> rm = new ParameterizedRowMapper<MemberInfo>() {
			
				@Override
				public MemberInfo mapRow(ResultSet rs, int n) throws SQLException {
					MemberInfo mi = new MemberInfo();
					mi.setUserName(rs.getString("user_name"));
					mi.setRoleName(rs.getString("role_name"));
					mi.setCity(rs.getString("city"));
					mi.setDtlastlogin(rs.getTimestamp("dtlastlogin"));
					
					return mi;
				}
			};
			ret  = simpleJdbcTemplate.queryForObject(sql, rm, userName);
		} catch (Throwable e) {
			// e.printStackTrace();
			Logger.getLogger(MemberInfoDAOImpl.class).error(e);
		}

		return ret;

	}

}
