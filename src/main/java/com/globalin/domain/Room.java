package com.globalin.domain;

public class Room {
    private Long roomId;
    private Long hotelId;
    private String roomType;   // BUSINESS / PAIR / FAMILY
    private Double price;
    private Integer maxPerson;
    private String status;

    // getters/setters
    public Long getRoomId() { return roomId; }
    public void setRoomId(Long roomId) { this.roomId = roomId; }
    public Long getHotelId() { return hotelId; }
    public void setHotelId(Long hotelId) { this.hotelId = hotelId; }
    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }
    public Double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }
    public Integer getMaxPerson() { return maxPerson; }
    public void setMaxPerson(Integer maxPerson) { this.maxPerson = maxPerson; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
