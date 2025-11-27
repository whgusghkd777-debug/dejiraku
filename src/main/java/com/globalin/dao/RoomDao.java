package com.globalin.dao;

public interface RoomDao {
    /** 호텔ID와 ROOM_TYPE으로 ROOM_ID 조회 */
    Long findIdByHotelAndType(long hotelId, String roomType);
}