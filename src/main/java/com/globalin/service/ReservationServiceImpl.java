package com.globalin.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.globalin.dao.ReservationDao;
import com.globalin.dao.RoomDao;
import com.globalin.domain.Reservation;
import com.globalin.dto.ReservationView;

@Service
public class ReservationServiceImpl implements ReservationService {

    private final ReservationDao reservationDao;
    private final RoomDao roomDao;

    public ReservationServiceImpl(ReservationDao reservationDao, RoomDao roomDao) {
        this.reservationDao = reservationDao;
        this.roomDao = roomDao;
    }

    @Transactional
    @Override
    public long create(Reservation r) {
        // ---- 디버그: 들어온 값 확인 (필요 없으면 지워도 됨)
        System.out.println("[RESV] hotelId=" + r.getHotelId() + ", roomType=" + r.getRoomType() +
                ", roomId=" + r.getRoomId() + ", checkin=" + r.getCheckinDate() +
                ", checkout=" + r.getCheckoutDate() + ", guests=" + r.getGuests());

        // 필수값 점검
        if (r.getHotelId() == null) {
            throw new IllegalArgumentException("HOTEL_ID is null");
        }
        if (r.getCheckinDate() == null || r.getCheckoutDate() == null) {
            throw new IllegalArgumentException("CHECKIN/CHECKOUT is null");
        }

        // roomId 없으면 hotelId + roomType으로 조회해 세팅
        if (r.getRoomId() == null || r.getRoomId() == 0L) {
            if (r.getRoomType() == null || r.getRoomType().trim().isEmpty()) {
                throw new IllegalArgumentException("ROOM_ID and ROOM_TYPE are both null/empty");
            }
            String type = r.getRoomType().trim().toUpperCase();
            Long found = roomDao.findIdByHotelAndType(r.getHotelId(), type);
            if (found == null) {
                throw new IllegalStateException("Room not found for hotelId=" + r.getHotelId() + ", type=" + type);
            }
            r.setRoomId(found);
            r.setRoomType(type);
        }

        // 기본값 보정
        if (r.getGuests() == null) r.setGuests(1);
        if (r.getPaymentMethod() == null) r.setPaymentMethod("VISA");
        if (r.getBookingStatus() == null) r.setBookingStatus("PAID");
        if (r.getTotalPrice() == null) r.setTotalPrice(0.0);

        // INSERT
        return reservationDao.insert(r);
    }

    // 호환용
    @Override
    public List<ReservationView> findByMemberId(long memberId) {
        return reservationDao.findByMemberId(memberId);
    }

    // 표준 목록
    @Override
    public List<ReservationView> listByMember(long memberId) {
        return reservationDao.findByMemberId(memberId);
    }

    @Override
    @Transactional
    public int deleteByMemberId(long memberId) {
        return reservationDao.deleteByMemberId(memberId);
    }

    @Override
    @Transactional  // ★ 변경: 트랜잭션으로 묶기
    public void cancel(long memberId, long reservationId) {
        int updated = reservationDao.cancelIfOwnedAndPaid(memberId, reservationId);
        // 필요시 검증/로깅
        // if (updated == 0) { ... } // 소유 아님, 이미 취소 등
    }

    @Override
    public List<ReservationView> findCancelableByMemberId(long memberId) {
        return reservationDao.findCancelableByMemberId(memberId);
    }
    
    @Override
    public ReservationView findViewById(long reservationId) {
        return reservationDao.findViewById(reservationId);
    }
}
