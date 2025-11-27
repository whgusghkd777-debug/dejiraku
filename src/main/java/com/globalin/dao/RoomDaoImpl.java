package com.globalin.dao;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class RoomDaoImpl implements RoomDao {

    private final JdbcTemplate jdbc;

    public RoomDaoImpl(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    @Override
    public Long findIdByHotelAndType(long hotelId, String roomType) {
        final String sql = "SELECT ROOM_ID FROM ROOM " +
                           "WHERE HOTEL_ID = ? AND UPPER(ROOM_TYPE) = UPPER(?)";

        List<Long> ids = jdbc.query(sql, (rs, i) -> rs.getLong(1), hotelId, roomType);
        return ids.isEmpty() ? null : ids.get(0);
    }
}
