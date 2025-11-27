package com.globalin.service;

import java.util.List;

import com.globalin.domain.Reservation;
import com.globalin.dto.ReservationView;

public interface ReservationService {
    long create(Reservation r);

    // 표준 메서드
    List<ReservationView> listByMember(long memberId);

    // 호환용(기존 코드 살리기)
    default List<ReservationView> findByMemberId(long memberId) {
        return listByMember(memberId);
    }

    int deleteByMemberId(long memberId);

    /** 본인 소유 + PAID 일 때만 CANCELED 로 변경 */
    void cancel(long memberId, long reservationId);

    /** 취소 가능(PAID만) */
    List<ReservationView> findCancelableByMemberId(long memberId);
    
    ReservationView findViewById(long reservationId);
}
	