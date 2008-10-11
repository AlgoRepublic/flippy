package com.flippy.service;

import java.util.List;

import org.springframework.context.ApplicationContext;

import com.flippy.domain.Room;

/**
 * @author uudashr
 *
 */
public class RoomService {
    public static List<Room> createRoom(String name, int learningAge, String description) {
        RoomDAO roomDao = getRoomDao();
        roomDao.create(name, learningAge, description);
        return roomDao.getRooms();
    }
    
    public static List<Room> getRoom() {
        RoomDAO roomDao = getRoomDao();
        return roomDao.getRooms();
    }
    
    private static RoomDAO getRoomDao() {
        ApplicationContext ctx = ServiceManager.getInstance().getContext();
        RoomDAO roomDao = (RoomDAO)ctx.getBean("RoomService");
        return roomDao;
    }

    public static List<Room> delete(int id) {
        RoomDAO roomDao = getRoomDao();
        roomDao.delete(id);
        return roomDao.getRooms();
    }

    public static List<Room> update(int id, String name, int learningAge,
            String description) {
        RoomDAO roomDao = getRoomDao();
        roomDao.update(id, name, learningAge, description);
        return roomDao.getRooms();
    }

    public static List<Room> getRooms(int requiredLearningAge) {
        RoomDAO roomDao = getRoomDao();
        return roomDao.getRooms(requiredLearningAge);
    }
}
