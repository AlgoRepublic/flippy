package com.flippy.service;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.jdbc.core.simple.ParameterizedRowMapper;
import org.springframework.jdbc.core.simple.SimpleJdbcInsert;
import org.springframework.jdbc.core.simple.SimpleJdbcTemplate;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;

import com.flippy.domain.ChatLog;

public class ChatLogDAOImpl implements ChatLogDAO {

	private SimpleJdbcTemplate simpleJdbcTemplate;
	private SimpleJdbcInsert insertLog;
	private TransactionTemplate transactionTemplate;
	
	public void setDataSource(DataSource dataSource) {
		simpleJdbcTemplate = new SimpleJdbcTemplate(dataSource);
		insertLog = new SimpleJdbcInsert(dataSource)
		            .withTableName("fl_chat_log")
		            .usingColumns("session_id", "sender_name","dest_name", "topic", "message", "timestamp")
				    .usingGeneratedKeyColumns("id");
		
		DataSourceTransactionManager ptm = new DataSourceTransactionManager(dataSource);
		this.transactionTemplate = new TransactionTemplate(ptm);
	}
	
	@Override
	public List<ChatLog> getBySender(String senderUserName) {
		String sql = "select id, session_id, sender_name, dest_name, topic, message, timestamp from fl_chat_log where sender_name=?";
		
		ParameterizedRowMapper<List<ChatLog>> mapper = new ParameterizedRowMapper<List<ChatLog>>() {

			@Override
			public List<ChatLog> mapRow(ResultSet rs, int rowNum) throws SQLException {
				
				List<ChatLog> ret = new ArrayList<ChatLog>();
				
				while (rs.next()) {
					ChatLog cl = new ChatLog();
					cl.setId(rs.getInt("id"));
					cl.setSessionId(rs.getString("session_id"));
					cl.setSenderUserName(rs.getString("sender_name"));
					cl.setDestinationUserName(rs.getString("dest_name"));
					cl.setTopic(rs.getString("topic"));
					cl.setMessage(rs.getString("message"));
					cl.setTimestamp(rs.getTimestamp("timestamp"));
					
					ret.add(cl);
				}
				
				return ret;
			}
			
		};
		
		List<ChatLog> ret = null;
		
		try {
			ret = simpleJdbcTemplate.queryForObject(sql, mapper, senderUserName);
		} catch (Throwable e) {
			//e.printStackTrace();
		}
		
		return ret;
	}

	@Override
	public int writeLog(String destinationUserName, String message,
			String senderUserName, String sessionId, Date timestamp,
			String topic) {
		
		HashMap<String, Object> params = new HashMap<String, Object>(6);
		params.put("session_id", sessionId);
		params.put("sender_name", senderUserName);
		params.put("dest_name", destinationUserName);
		params.put("topic", topic);
		params.put("message", message);
		params.put("timestamp", timestamp!=null?timestamp:new Date());
		
		
		Number newId = insertLog.executeAndReturnKey(params);
		return newId.intValue();
		
	}
	
}
