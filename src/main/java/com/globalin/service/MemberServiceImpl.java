package com.globalin.service;

import com.globalin.dao.MemberDao;
import com.globalin.domain.Member;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class MemberServiceImpl implements MemberService {
    @Autowired MemberDao memberDao;
    @Autowired(required = false) BCryptPasswordEncoder passwordEncoder;

    @Transactional
    @Override
    public void register(Member m) {
        // 비밀번호 해시 (encoder 빈이 없으면 평문 저장 방지용 간단 fallback)
        String hash = (passwordEncoder != null)
                ? passwordEncoder.encode(m.getPasswordHash())
                : m.getPasswordHash();
        m.setPasswordHash(hash);
        memberDao.insert(m);
    }
    
    @Override
    public Member login(String userId, String rawPassword) {
        Member m = memberDao.findByUserId(userId);
        if (m == null) return null;

        if (passwordEncoder == null) {
            // encoder 빈이 없을 때는 평문 비교 (임시)
            return rawPassword.equals(m.getPasswordHash()) ? m : null;
        }

        return passwordEncoder.matches(rawPassword, m.getPasswordHash()) ? m : null;
    }
    /* ====================== 여기부터 "내 정보 수정" 관련 ====================== */

    /** 마이페이지: 프로필(이름/이메일/휴대폰/생일/성별) 수정 */
    @Transactional
    @Override
    public void updateProfile(Member m) {
        // 주의: DAO가 WHERE USERID = ? 로 업데이트한다면
        // 컨트롤러에서 m.setUserid(세션의 userid) 를 반드시 넣어 넘겨야 함!
        memberDao.updateProfile(m);
    }

    /** 세션 갱신/조회용 */
    @Override
    public Member findByUserId(String userId) {
        return memberDao.findByUserId(userId);
    }
    
    /* ====================== ★ 회원탈퇴 ====================== */
    @Transactional
    @Override
    public void deleteById(long memberId) { // ★ 추가
        memberDao.deleteById(memberId);     // ★ 추가
    }
    
}