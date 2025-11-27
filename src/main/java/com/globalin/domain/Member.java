// src/main/java/com/globalin/domain/Member.java
package com.globalin.domain;
import java.sql.Date;
import lombok.Data;

@Data
public class Member {
    private Long memberId;
    private String userid;
    private String passwordHash;
    private String name;
    private String email;
    private String phone;
    private Date birthdate;  // yyyy-MM-dd -> Date.valueOf 로 변환
    private String gender;   // 'M' / 'F'
}