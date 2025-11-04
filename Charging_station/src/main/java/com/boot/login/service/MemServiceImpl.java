package com.boot.login.service;

import java.util.ArrayList;
import java.util.HashMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.login.dao.MemDAO;
import com.boot.login.dto.MemDTO;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class MemServiceImpl implements MemService {

    @Autowired
    private MemDAO memDAO;
    
    @Override
    public ArrayList<MemDTO> loginYn(HashMap<String, String> param) {
        log.info("@# MemServiceImpl.loginYn() start");
        return memDAO.loginYn(param);
    }
    
    @Override
    public void write(HashMap<String, String> param) {
        log.info("@# MemServiceImpl.write() start");
        param.putIfAbsent("PROFILE_IMAGE", "default_profile.jpg");
        memDAO.write(param);
    }

    @Override
    public MemDTO getMemberInfo(String memberId) {
        log.info("@# MemServiceImpl.getMemberInfo() start for ID: " + memberId);
        return memDAO.getMemberInfo(memberId);
    }
    
    // ===== 중복 확인 서비스 구현 추가 =====
    @Override
    public int idCheck(String memberId) {
        log.info("@# MemServiceImpl.idCheck() for ID: " + memberId);
        return memDAO.idCheck(memberId);
    }

    @Override
    public int nicknameCheck(String nickname) {
        log.info("@# MemServiceImpl.nicknameCheck() for Nickname: " + nickname);
        return memDAO.nicknameCheck(nickname);
    }

    @Override
    public int emailCheck(String email) {
        log.info("@# MemServiceImpl.emailCheck() for Email: " + email);
        return memDAO.emailCheck(email);
    }

    @Override
    public int phoneCheck(String phoneNumber) {
        log.info("@# MemServiceImpl.phoneCheck() for Phone: " + phoneNumber);
        return memDAO.phoneCheck(phoneNumber);
    }

	@Override
    public MemDTO findOrCreateMember(HashMap<String, String> socialUserInfo) {
        HashMap<String, String> findParam = new HashMap<>();
        findParam.put("socialType", socialUserInfo.get("socialType"));
        findParam.put("socialId", socialUserInfo.get("socialId"));
        
        MemDTO member = memDAO.findMemberBySocial(findParam);
        
        // 1. [Case 1: 신규 회원] member가 null일 때 회원가입 로직 수행
        if (member == null) {
            log.info("@# 신규 소셜 회원 자동 회원가입");
            
            // Controller에서 넘겨주는 Key값 (대소문자 주의)
            String socialEmail = socialUserInfo.get("EMAIL"); 
            
            // 이메일 중복 체크 (일반 가입자)
            if(socialEmail != null && !socialEmail.isEmpty() && memDAO.emailCheck(socialEmail) > 0) {
                log.warn("@# 소셜 로그인 실패: 이미 등록된 이메일 {}", socialEmail);
                return null;
            }
            
            String newNickname = socialUserInfo.get("NICKNAME");
            if(newNickname == null || newNickname.isEmpty()) {
                // "NANE" -> "NAME" 오타 수정
                newNickname = socialUserInfo.get("NAME") + (System.currentTimeMillis() % 1000); 
            }
            
            if(memDAO.nicknameCheck(newNickname) > 0) {
                newNickname = newNickname + "_" + (System.currentTimeMillis() % 1000); 
            }
            
            String newMemberId = socialUserInfo.get("socialType") + "_" + socialUserInfo.get("socialId");
            
            // DB 컬럼 길이에 맞춰 ID 자르기 (if문의 20을 50으로 수정)
            if(newMemberId.length() > 100) { 
                newMemberId = newMemberId.substring(0, 100);
            }
            
            // ===== 회원가입 로직 시작 =====
            // (잘못된 if문 밖으로 로직을 꺼냈습니다)
            HashMap<String, String> registerParam = new HashMap<>();
            registerParam.put("MEMBER_ID", newMemberId);
            registerParam.put("NAME", socialUserInfo.get("NAME"));
            registerParam.put("NICKNAME", newNickname);
            registerParam.put("EMAIL", socialEmail);
            registerParam.put("SOCIAL_TYPE", socialUserInfo.get("socialType"));
            registerParam.put("SOCIAL_ID", socialUserInfo.get("socialId"));
            
            // this.write()를 호출해야 PROFILE_IMAGE 기본값이 적용됩니다.
            this.write(registerParam);
            
            // 방금 가입한 회원 정보를 다시 조회
            member = memDAO.findMemberBySocial(findParam);
            // ===== 회원가입 로직 끝 =====
            
        } 
        // 2. [Case 2: 기존 회원] member가 null이 아닐 때
        else {
            log.info("@# 기존 소셜 회원 로그인 " + member.getMemberId());
        }
        
        // 3. 최종적으로 회원 정보 반환 (신규 회원이든 기존 회원이든)
        return member;
    }

	@Override
	public MemDTO findUserByIdAndEmail(HashMap<String, String> param) {
		return memDAO.findUserByIdAndEmail(param);
	}

	@Override
	public void updatePassword(HashMap<String, String> param) {
		memDAO.updatePassword(param);
	}
}