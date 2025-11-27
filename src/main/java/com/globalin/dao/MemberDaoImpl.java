// src/main/java/com/globalin/dao/MemberDaoImpl.java
package com.globalin.dao;

import com.globalin.domain.Member;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import org.springframework.beans.factory.annotation.Autowired;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.List;

@Repository
public class MemberDaoImpl implements MemberDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // ========== 가입 ==========
    @Override
    public int insert(Member m) {
        String sql =
            "INSERT INTO MEMBER (" +
            "  MEMBER_ID, USERID, PASSWORD_HASH, NAME, EMAIL, PHONE, BIRTHDATE, GENDER" +
            ") VALUES (" +
            "  SEQ_MEMBER_ID.NEXTVAL, ?, ?, ?, ?, ?, ?, ?" +
            ")";
        return jdbcTemplate.update(sql,
                m.getUserid(),
                m.getPasswordHash(),
                m.getName(),
                m.getEmail(),
                m.getPhone(),
                m.getBirthdate(),   // java.sql.Date 권장 (모델에서 맞춰주면 best)
                m.getGender()
        );
    }

    // ========== 조회 ==========
    @Override
    public Member findByUserId(String userId) {
        String sql = "SELECT * FROM MEMBER WHERE USERID = ?";
        try {
            return jdbcTemplate.queryForObject(sql, (rs, i) -> map(rs), userId);
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    @Override
    public Member findById(long memberId) {
        String sql = "SELECT * FROM MEMBER WHERE MEMBER_ID = ?";
        try {
            return jdbcTemplate.queryForObject(sql, (rs, i) -> map(rs), memberId);
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    // ========== 프로필 수정 (PK로 수정) ==========
    @Override
    public int updateProfile(Member m) {
        String sql =
            "UPDATE MEMBER SET " +
            "  NAME      = NVL(?, NAME), " +
            "  EMAIL     = NVL(?, EMAIL), " +
            "  PHONE     = NVL(?, PHONE), " +
            "  BIRTHDATE = NVL(?, BIRTHDATE), " +
            "  GENDER    = NVL(?, GENDER) " +
            "WHERE MEMBER_ID = ?";
        return jdbcTemplate.update(sql, ps -> {
            ps.setString(1, m.getName());
            ps.setString(2, m.getEmail());
            ps.setString(3, m.getPhone());
            if (m.getBirthdate() == null) {
                ps.setNull(4, Types.DATE);
            } else if (m.getBirthdate() instanceof java.sql.Date) {
                ps.setDate(4, (java.sql.Date) m.getBirthdate());
            } else {
                ps.setDate(4, new java.sql.Date(m.getBirthdate().getTime()));
            }
            ps.setString(5, m.getGender());
            ps.setLong(6, m.getMemberId());
        });
    }

    // ========== 회원탈퇴 ==========
    @Override
    public int deleteById(long memberId) {
        String sql = "DELETE FROM MEMBER WHERE MEMBER_ID = ?";
        return jdbcTemplate.update(sql, memberId);
    }

    // ========== 아이디/비번 찾기(복구) ==========
    @Override
    public String findUseridByNameAndEmail(String name, String email) {
        String sql = "SELECT USERID FROM MEMBER WHERE NAME = ? AND EMAIL = ?";
        try {
            return jdbcTemplate.queryForObject(sql, String.class, name, email);
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    @Override
    public boolean existsByUseridAndEmail(String userid, String email) {
        String sql = "SELECT COUNT(*) FROM MEMBER WHERE USERID = ? AND EMAIL = ?";
        Integer cnt = jdbcTemplate.queryForObject(sql, Integer.class, userid, email);
        return cnt != null && cnt > 0;
    }

    @Override
    public int updatePasswordHashByUseridAndEmail(String userid, String email, String newPasswordHash) {
        String sql = "UPDATE MEMBER SET PASSWORD_HASH = ? WHERE USERID = ? AND EMAIL = ?";
        return jdbcTemplate.update(sql, newPasswordHash, userid, email);
    }

    // ========== 매핑 유틸 ==========
    private Member map(ResultSet rs) throws SQLException {
        Member m = new Member();
        m.setMemberId(rs.getLong("MEMBER_ID"));
        m.setUserid(rs.getString("USERID"));
        m.setPasswordHash(rs.getString("PASSWORD_HASH"));
        m.setName(rs.getString("NAME"));
        m.setEmail(rs.getString("EMAIL"));
        m.setPhone(rs.getString("PHONE"));
        m.setBirthdate(rs.getDate("BIRTHDATE")); // java.sql.Date
        m.setGender(rs.getString("GENDER"));
        return m;
    }
    @Override
    public Member findByNameAndEmail(String name, String email) {
        String sql = "SELECT * FROM MEMBER WHERE NAME = ? AND EMAIL = ?";
        return jdbcTemplate.query(sql, rs -> rs.next() ? map(rs) : null, name, email);
    }

    @Override
    public Member findByUseridAndEmail(String userid, String email) {
        String sql = "SELECT * FROM MEMBER WHERE USERID = ? AND EMAIL = ?";
        return jdbcTemplate.query(sql, rs -> rs.next() ? map(rs) : null, userid, email);
    }

    @Override
    public int updatePasswordByUserid(String userid, String newPlainOrHash) {
        String sql = "UPDATE MEMBER SET PASSWORD_HASH = ? WHERE USERID = ?";
        return jdbcTemplate.update(sql, newPlainOrHash, userid);
    }
    @Override
    public int updatePasswordHashByUserid(String userid, String email, String bcryptHash) {
        String sql = "UPDATE MEMBER SET PASSWORD_HASH = ? WHERE USERID = ? AND EMAIL = ?";
        return jdbcTemplate.update(sql, bcryptHash, userid, email);
    }
}
