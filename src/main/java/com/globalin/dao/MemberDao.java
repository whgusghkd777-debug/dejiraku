// src/main/java/com/globalin/dao/MemberDao.java
package com.globalin.dao;

import com.globalin.domain.Member;

public interface MemberDao {

    // 가입
    int insert(Member m);

    // 로그인/조회
    Member findByUserId(String userId);
    Member findById(long memberId);

    // 프로필 수정 (PK로 수정)
    int updateProfile(Member m);

    // 회원탈퇴 (PK)
    int deleteById(long memberId);

    // ───── 아이디/비번 찾기(복구) ─────
    /** 이름+이메일로 사용자 ID 찾기 (없으면 null) */
    String findUseridByNameAndEmail(String name, String email);

    /** userid+email 존재 확인 */
    boolean existsByUseridAndEmail(String userid, String email);

    /** userid+email 조건으로 비밀번호 해시 갱신 */
    int updatePasswordHashByUseridAndEmail(String userid, String email, String bcryptHash);
    Member findByNameAndEmail(String name, String email);
    Member findByUseridAndEmail(String userid, String email);
    int updatePasswordByUserid(String userid, String newPlainOrHash);

	int updatePasswordHashByUserid(String userid, String email, String bcryptHash);
    
}
