package com.globalin.domain;

import java.time.LocalDate;

public class Reservation {

    // --- PK & FK ---
    private Long reservationId;   // RESERVATION_ID
    private Long memberId;        // MEMBER_ID
    private Long hotelId;         // HOTEL_ID
    private Long roomId;          // ROOM_ID  ★ NEW

    // --- 화면 편의용(테이블 컬럼 X) ---
    private String hotelName;
    private String region;

    // --- 예약 기본 정보 ---
    private String roomType;      // business / pair / family (ROOM_ID 조회용)
    private LocalDate checkin;    // CHECKIN_DATE (별칭 제공)
    private LocalDate checkout;   // CHECKOUT_DATE (별칭 제공)
    private Integer guests;       // GUESTS

    // --- 결제/상태 ---
    private Long amount;          // TOTAL_PRICE (별칭 제공)
    private String paymentMethod; // PAYMENT_METHOD
    private String status;        // BOOKING_STATUS (별칭 제공)

    // ===== 기본 게터/세터 =====
    public Long getReservationId() { return reservationId; }
    public void setReservationId(Long reservationId) { this.reservationId = reservationId; }
    public Long getMemberId() { return memberId; }
    public void setMemberId(Long memberId) { this.memberId = memberId; }
    public Long getHotelId() { return hotelId; }
    public void setHotelId(Long hotelId) { this.hotelId = hotelId; }
    public Long getRoomId() { return roomId; }
    public void setRoomId(Long roomId) { this.roomId = roomId; }

    public String getHotelName() { return hotelName; }
    public void setHotelName(String hotelName) { this.hotelName = hotelName; }
    public String getRegion() { return region; }
    public void setRegion(String region) { this.region = region; }

    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }

    public LocalDate getCheckin() { return checkin; }
    public void setCheckin(LocalDate checkin) { this.checkin = checkin; }
    public LocalDate getCheckout() { return checkout; }
    public void setCheckout(LocalDate checkout) { this.checkout = checkout; }

    public Integer getGuests() { return guests; }
    public void setGuests(Integer guests) { this.guests = guests; }

    public Long getAmount() { return amount; }
    public void setAmount(Long amount) { this.amount = amount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    // ===== 호환용 별칭(Alias) 게터/세터 =====
    // DAO가 checkinDate/checkoutDate/totalPrice/bookingStatus를 호출해도 동작하도록

    public LocalDate getCheckinDate() { return checkin; }
    public void setCheckinDate(LocalDate d) { this.checkin = d; }

    public LocalDate getCheckoutDate() { return checkout; }
    public void setCheckoutDate(LocalDate d) { this.checkout = d; }

    public Double getTotalPrice() { return (amount == null) ? null : amount.doubleValue(); }
    public void setTotalPrice(Double v) { this.amount = (v == null) ? null : v.longValue(); }

    public String getBookingStatus() { return status; }
    public void setBookingStatus(String s) { this.status = s; }

    // 일부 코드에서 getId()/setId()를 쓰는 경우 대비
    public Long getId() { return reservationId; }
    public void setId(Long id) { this.reservationId = id; }
}
