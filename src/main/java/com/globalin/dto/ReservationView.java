package com.globalin.dto;

import java.time.LocalDate;
import java.math.BigDecimal;

public class ReservationView {
    private long id;
    private String hotelName;
    private String roomType;
    private LocalDate checkin;
    private LocalDate checkout;
    private int guests;
    private BigDecimal totalPrice;
    private String status;

    // 🔸 추가: 예약 소유자(회원) ID
    private long ownerId;

    // --- getters/setters ---
    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public String getHotelName() { return hotelName; }
    public void setHotelName(String hotelName) { this.hotelName = hotelName; }

    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }

    public LocalDate getCheckin() { return checkin; }
    public void setCheckin(LocalDate checkin) { this.checkin = checkin; }

    public LocalDate getCheckout() { return checkout; }
    public void setCheckout(LocalDate checkout) { this.checkout = checkout; }

    public int getGuests() { return guests; }
    public void setGuests(int guests) { this.guests = guests; }

    public BigDecimal getTotalPrice() { return totalPrice; }
    public void setTotalPrice(BigDecimal totalPrice) { this.totalPrice = totalPrice; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public long getOwnerId() { return ownerId; }
    public void setOwnerId(long ownerId) { this.ownerId = ownerId; }
}
