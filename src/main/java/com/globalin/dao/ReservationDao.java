package com.globalin.dao;

import java.util.List;

import com.globalin.domain.Reservation;
import com.globalin.dto.ReservationView;

public interface ReservationDao {
    long insert(Reservation r);

    /** 전체(상태 무관) */
    List<ReservationView> findByMemberId(long memberId);

    /** 취소 가능(PAID만) */
    List<ReservationView> findCancelableByMemberId(long memberId);

    /** 회원탈퇴 등에서 일괄 삭제(설계상 허용) */
    int deleteByMemberId(long memberId);

    /**
     * 본인 소유 + 현재 PAID인 경우에만 CANCELED 로 상태 변경
     * DELETE 금지. UPDATE 로만 상태 변경.
     */
    int cancelIfOwnedAndPaid(long memberId, long reservationId);
    
    ReservationView findViewById(long reservationId);
}
