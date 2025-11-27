// src/main/java/com/globalin/service/MemberService.java
package com.globalin.service;

import com.globalin.domain.Member;

public interface MemberService {
	void register(Member m);

	Member login(String userId, String rawPassword);

	/** 마이페이지: 회원 프로필(이름/메일/폰/생일/성별) 수정 */

	/** 세션 갱신/조회용 */
	Member findByUserId(String userId);

	void updateProfile(Member m);

	/** ★ 회원탈퇴: PK( MEMBER_ID )로 삭제 */
	void deleteById(long memberId); // ★ 추가

}
