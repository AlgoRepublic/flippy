package com.flippy.service;

import java.util.List;

import com.flippy.domain.Room;

/**
 * @author uudashr
 *
 */
public interface RoomDAO {
    boolean create(String name, int learningAge, String description);
    List<Room> getRooms();
    List<Room> getRooms(int requiredLearningAge);
    boolean delete(int id);
    boolean update(int id, String name, int learningAge, String description);
    
}
