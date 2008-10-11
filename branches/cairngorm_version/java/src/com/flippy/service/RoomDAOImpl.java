package com.flippy.service;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import javax.sql.DataSource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import com.flippy.domain.Room;

/**
 * Default Spring implementation of {@link RoomDAO}.
 * 
 * @author uudashr
 *
 */
public class RoomDAOImpl implements RoomDAO {
    private static final class RoomRowMapper implements RowMapper {
        public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
            Room room = new Room();
            room.setId(rs.getInt("id"));
            room.setName(rs.getString("name"));
            room.setLearningAge(rs.getInt("learning_age"));
            room.setDescription(rs.getString("description"));
            room.setDateCreate(rs.getTimestamp("dt_create"));
            return room;
        }
    }

    private static final Log logger = LogFactory.getLog(RoomDAOImpl.class);
    private JdbcTemplate jdbcTemplate;
    
    public void setDataSource(DataSource dataSource) {
        jdbcTemplate = new JdbcTemplate(dataSource);
    }
    
    public boolean create(String name, int learningAge, String description) {
        int rowsAffected = jdbcTemplate.update("insert into fl_room (name, learning_age, description, status, dt_create, dt_last_change) values (?, ?, ?, 1, now(), now())", new Object[]{name, learningAge, description});
        boolean succeed = rowsAffected > 0;
        if (!succeed) {
            logger.warn("Failed create room, returing rows affected is " + rowsAffected);
        }
        return succeed;
    }
    
    public boolean delete(int id) {
        int rowsAffected = jdbcTemplate.update("delete from fl_room where id = ?", new Object[]{id});
        boolean succeed = rowsAffected > 0;
        if (!succeed) {
            logger.warn("Failed delete room with id " + id + ", returing rows affected is " + rowsAffected);
        }
        return succeed;
    }
    
    @SuppressWarnings("unchecked")
    public List<Room> getRooms() {
        return jdbcTemplate.query("select * from fl_room order by learning_age, name", 
                new RoomRowMapper());
    }
    
    @SuppressWarnings("unchecked")
    public List<Room> getRooms(int requiredLearningAge) {
        return jdbcTemplate.query("select * from fl_room order where learningAge <= ? by learning_age, name", 
                new Object[]{requiredLearningAge}, new RoomRowMapper());
    }
    
    public boolean update(int id, String name, int learningAge, String description) {
        int rowsAffected = jdbcTemplate.update("update fl_room set name = ?, learning_age = ?, description = ?, dt_last_change = now() where id = ?", new Object[]{name, learningAge, description, id});
        boolean succeed = rowsAffected > 0;
        if (!succeed) {
            logger.warn("Failed update room with id " + id + ", returning rows affected is " + rowsAffected);
        }
        return succeed;
    }
}
