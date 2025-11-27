package com.globalin.dao;

import java.sql.Date;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.globalin.domain.Reservation;
import com.globalin.dto.ReservationView;

@Repository
public class ReservationDaoImpl implements ReservationDao {

    private final JdbcTemplate jdbc;

    public ReservationDaoImpl(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    @Override
    public long insert(Reservation r) {
        // 실제 DB 컬럼 순서 (GUESTS는 마지막)
        String sql =
            "INSERT INTO RESERVATION (" +
            "  RESERVATION_ID, MEMBER_ID, ROOM_ID, HOTEL_ID, " +
            "  CHECKIN_DATE, CHECKOUT_DATE, TOTAL_PRICE, " +
            "  PAYMENT_METHOD, BOOKING_STATUS, CREATED_AT, GUESTS" +
            ") VALUES (" +
            "  SEQ_RESERVATION_ID.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?, SYSTIMESTAMP, ?)";

        jdbc.update(sql,
            r.getMemberId(),
            r.getRoomId(),                // ROOM_ID 필수
            r.getHotelId(),
            Date.valueOf(r.getCheckinDate()),
            Date.valueOf(r.getCheckoutDate()),
            r.getTotalPrice(),
            r.getPaymentMethod(),
            r.getBookingStatus(),
            r.getGuests()                 // 마지막 바인딩
        );

        return jdbc.queryForObject("SELECT SEQ_RESERVATION_ID.CURRVAL FROM DUAL", Long.class);
    }

    @Override
    public int deleteByMemberId(long memberId) {
        String sql = "DELETE FROM RESERVATION WHERE MEMBER_ID = ?";
        return jdbc.update(sql, memberId);
    }

    @Override
    public List<ReservationView> findByMemberId(long memberId) {
        String sql =
            "SELECT r.RESERVATION_ID AS id, " +
            "       r.MEMBER_ID      AS ownerId, " +
            "       hb.HOTEL_NAME    AS hotelName, " +
            "       rm.ROOM_TYPE     AS roomType, " +
            "       r.CHECKIN_DATE   AS checkin, " +
            "       r.CHECKOUT_DATE  AS checkout, " +
            "       r.GUESTS         AS guests, " +
            "       r.TOTAL_PRICE    AS totalPrice, " +
            "       r.BOOKING_STATUS AS status " +
            "  FROM RESERVATION r " +
            "  JOIN HOTEL_BRANCH hb ON hb.HOTEL_ID = r.HOTEL_ID " +
            "  JOIN ROOM rm        ON rm.ROOM_ID   = r.ROOM_ID " +
            " WHERE r.MEMBER_ID = ? " +
            " ORDER BY r.RESERVATION_ID DESC";

        return jdbc.query(sql, new Object[]{memberId}, (rs, i) -> {
            ReservationView v = new ReservationView();
            v.setId(rs.getLong("id"));
            v.setOwnerId(rs.getLong("ownerId"));
            v.setHotelName(rs.getString("hotelName"));
            v.setRoomType(rs.getString("roomType"));
            v.setCheckin(rs.getDate("checkin").toLocalDate());
            v.setCheckout(rs.getDate("checkout").toLocalDate());
            v.setGuests(rs.getInt("guests"));
            v.setTotalPrice(rs.getBigDecimal("totalPrice"));
            v.setStatus(rs.getString("status"));
            return v;
        });
    }

    @Override
    public List<ReservationView> findCancelableByMemberId(long memberId) {
        String sql =
            "SELECT r.RESERVATION_ID AS id, " +
            "       r.MEMBER_ID      AS ownerId, " +
            "       hb.HOTEL_NAME    AS hotelName, " +
            "       rm.ROOM_TYPE     AS roomType, " +
            "       r.CHECKIN_DATE   AS checkin, " +
            "       r.CHECKOUT_DATE  AS checkout, " +
            "       r.GUESTS         AS guests, " +
            "       r.TOTAL_PRICE    AS totalPrice, " +
            "       r.BOOKING_STATUS AS status " +
            "  FROM RESERVATION r " +
            "  JOIN HOTEL_BRANCH hb ON hb.HOTEL_ID = r.HOTEL_ID " +
            "  JOIN ROOM rm        ON rm.ROOM_ID   = r.ROOM_ID " +
            " WHERE r.MEMBER_ID = ? " +
            "   AND r.BOOKING_STATUS = 'PAID' " +
            " ORDER BY r.RESERVATION_ID DESC";

        return jdbc.query(sql, new Object[]{memberId}, (rs, i) -> {
            ReservationView v = new ReservationView();
            v.setId(rs.getLong("id"));
            v.setOwnerId(rs.getLong("ownerId"));
            v.setHotelName(rs.getString("hotelName"));
            v.setRoomType(rs.getString("roomType"));
            v.setCheckin(rs.getDate("checkin").toLocalDate());
            v.setCheckout(rs.getDate("checkout").toLocalDate());
            v.setGuests(rs.getInt("guests"));
            v.setTotalPrice(rs.getBigDecimal("totalPrice"));
            v.setStatus(rs.getString("status"));
            return v;
        });
    }

    @Override
    public int cancelIfOwnedAndPaid(long memberId, long reservationId) {
        // ★ 변경: 삭제가 아닌 상태 업데이트 + 취소 시각 기록
        String sql =
            "UPDATE RESERVATION " +
            "   SET BOOKING_STATUS = 'CANCELED' " +     // ★ 변경
            " WHERE RESERVATION_ID = ? " +
            "   AND MEMBER_ID      = ? " +
            "   AND BOOKING_STATUS = 'PAID'";
        return jdbc.update(sql, reservationId, memberId);
    }
    
    @Override
    public ReservationView findViewById(long reservationId) {
        String sql =
            "SELECT r.RESERVATION_ID AS id, " +
            "       r.MEMBER_ID      AS ownerId, " +
            "       hb.HOTEL_NAME    AS hotelName, " +
            "       rm.ROOM_TYPE     AS roomType, " +
            "       r.CHECKIN_DATE   AS checkin, " +
            "       r.CHECKOUT_DATE  AS checkout, " +
            "       r.GUESTS         AS guests, " +
            "       r.TOTAL_PRICE    AS totalPrice, " +
            "       r.BOOKING_STATUS AS status, " +
            "       r.MEMBER_ID      AS ownerId " + // 소유 검증용
            "  FROM RESERVATION r " +
            "  JOIN HOTEL_BRANCH hb ON hb.HOTEL_ID = r.HOTEL_ID " +
            "  JOIN ROOM rm        ON rm.ROOM_ID   = r.ROOM_ID " +
            " WHERE r.RESERVATION_ID = ?";

        return jdbc.query(sql, ps -> ps.setLong(1, reservationId), rs -> {
            if (!rs.next()) return null;
            ReservationView v = new ReservationView();
            v.setId(rs.getLong("id"));
            v.setOwnerId(rs.getLong("ownerId"));
            v.setHotelName(rs.getString("hotelName"));
            v.setRoomType(rs.getString("roomType"));
            v.setCheckin(rs.getDate("checkin").toLocalDate());
            v.setCheckout(rs.getDate("checkout").toLocalDate());
            v.setGuests(rs.getInt("guests"));
            v.setTotalPrice(rs.getBigDecimal("totalPrice"));
            v.setStatus(rs.getString("status"));
            // ownerId는 모델로 직접 쓰지 않고 컨트롤러에서 세션 사용자와 비교만
            v.setOwnerId(rs.getLong("ownerId")); // 필요하면 dto에 필드 추가
            return v;
        });
    }
}
