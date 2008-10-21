package com.flippy.service;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.jdbc.core.simple.ParameterizedRowMapper;
import org.springframework.jdbc.core.simple.SimpleJdbcInsert;
import org.springframework.jdbc.core.simple.SimpleJdbcTemplate;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;

import sun.security.action.GetLongAction;

import com.flippy.domain.QuestionLog;

public class QuestionLogDAOImpl implements QuestionLogDAO {

	private SimpleJdbcTemplate simpleJdbcTemplate;
	private SimpleJdbcInsert insertLog;
	private TransactionTemplate transactionTemplate;

	public void setDataSource(DataSource dataSource) {
		simpleJdbcTemplate = new SimpleJdbcTemplate(dataSource);
		insertLog = new SimpleJdbcInsert(dataSource).withTableName("fl_questions_log")
		        .usingColumns("session_id", "sender_name", "question", "timestamp").usingGeneratedKeyColumns("id");

		DataSourceTransactionManager ptm = new DataSourceTransactionManager(
				dataSource);
		this.transactionTemplate = new TransactionTemplate(ptm);
	}

	@Override
	public List<QuestionLog> getBySenderAndSessionId(String senderUserName, String sessionId) {
		String sql = "select id, session_id, sender_name, question, timestamp from fl_questions_log where session_id=? and sender_name=?";

		ParameterizedRowMapper<List<QuestionLog>> mapper = new ParameterizedRowMapper<List<QuestionLog>>() {

			@Override
			public List<QuestionLog> mapRow(ResultSet rs, int rowNum)
					throws SQLException {

				List<QuestionLog> ret = new ArrayList<QuestionLog>();

				while (rs.next()) {
					QuestionLog cl = new QuestionLog();
					cl.setId(rs.getInt("id"));
					cl.setSessionId(rs.getString("session_id"));
					cl.setSenderUserName(rs.getString("sender_name"));
					cl.setQuestion(rs.getString("question"));
					cl.setTimestamp(rs.getTimestamp("timestamp"));

					ret.add(cl);
				}

				return ret;
			}

		};

		List<QuestionLog> ret = null;

		try {
			ret = simpleJdbcTemplate
					.queryForObject(sql, mapper, sessionId, senderUserName);
		} catch (Throwable e) {
			// e.printStackTrace();
		}

		return ret;
	}

	@Override
	public List<QuestionLog> getBySessionId(String sessionId) {
		String sql = "select id, session_id, sender_name, question, timestamp from fl_questions_log where session_id=?";

		ParameterizedRowMapper<List<QuestionLog>> mapper = new ParameterizedRowMapper<List<QuestionLog>>() {

			@Override
			public List<QuestionLog> mapRow(ResultSet rs, int rowNum)
					throws SQLException {

				List<QuestionLog> ret = new ArrayList<QuestionLog>();

				while (rs.next()) {
					QuestionLog cl = new QuestionLog();
					cl.setId(rs.getInt("id"));
					cl.setSessionId(rs.getString("session_id"));
					cl.setSenderUserName(rs.getString("sender_name"));
					cl.setQuestion(rs.getString("question"));
					cl.setTimestamp(rs.getTimestamp("timestamp"));

					ret.add(cl);
				}

				return ret;
			}

		};

		List<QuestionLog> ret = null;

		try {
			ret = simpleJdbcTemplate
					.queryForObject(sql, mapper, sessionId);
		} catch (Throwable e) {
			// e.printStackTrace();
		}

		return ret;
	}

	@Override
	public int writeLog(String sessionId, String senderUserName,
			String question, Date timestamp) {
		
		Logger logger = Logger.getLogger(QuestionLogDAOImpl.class);
		
		logger.debug("writelog("+ sessionId + ", " + senderUserName + ", " + question + ", " + timestamp);
		
		HashMap<String, Object> params = new HashMap<String, Object>(6);
		params.put("session_id", sessionId);
		params.put("sender_name", senderUserName);
		params.put("question", question);
		params.put("timestamp", timestamp != null ? timestamp : new Date());

		Number newId = insertLog.executeAndReturnKey(params);
		return newId.intValue();

	}

}
