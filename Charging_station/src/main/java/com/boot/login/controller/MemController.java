package com.boot.login.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

// [참고] 사용자님이 com.boot.login.google.dto/service로 임포트하셔서 그대로 둡니다.
// 만약 이전에 제가 제안한 com.boot.login.dto/service에 클래스를 만드셨다면
// 이 import 구문을 수정해야 합니다.
import com.boot.login.dto.MemDTO;
import com.boot.login.google.dto.GoogleUserInfo; 
import com.boot.login.google.service.GoogleOAuthService;
import com.boot.login.service.MemService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class MemController {

    @Autowired
    private MemService memService;

    @Autowired
    private GoogleOAuthService googleOAuthService;

    // 로그인 화면
    @RequestMapping("/login")
    public String login() {
        log.info("@# GET /login");
        // ✅ [수정] 실제 JSP 경로
        return "login_page/login"; 
    }

    // 로그인 확인
    @RequestMapping("/login_yn")
    public String login_yn(HttpServletRequest request) { 
        String id = request.getParameter("MEMBER_ID"); 
        String pw = request.getParameter("PASSWORD"); 

        log.info("@# POST /login_yn: MEMBER_ID={}, PASSWORD={}", id, pw);

        HashMap<String, String> param = new HashMap<>();
        param.put("MEMBER_ID", id);
        param.put("PASSWORD", pw);

        ArrayList<MemDTO> dtos = memService.loginYn(param);

        if (dtos == null || dtos.isEmpty()) {
            request.setAttribute("msg", "아이디 또는 비밀번호가 잘못 되었습니다.");
            // ✅ [수정] alert.jsp가 사용할 URL (컨트롤러 매핑 경로)
            request.setAttribute("url", "login"); 
            // ✅ [수정] 실제 alert.jsp 경로
            return "login_page/alert"; 
        } else {
            HttpSession session = request.getSession();
            MemDTO loginUser = dtos.get(0);

            session.setAttribute("id", loginUser.getMemberId());
            session.setAttribute("name", loginUser.getName());
            session.setAttribute("admin", loginUser.getAdminck());

            // ✅ [수정] /login_ok 매핑으로 리다이렉트 (이전과 동일하게 유지)
            return "redirect:/login_ok"; 
        }
    }

    // 로그인 성공 페이지
    @RequestMapping("/login_ok")
    public String login_ok(HttpSession session) {
        log.info("@# GET /login_ok, session ID: " + session.getAttribute("id"));
        if (session.getAttribute("id") == null) {
            return "redirect:/login";
        }
        // ✅ [수정] 실제 JSP 경로
        return "login_page/login_ok"; 
    }

    // 회원가입 화면
    @RequestMapping("/register")
    public String register() {
        log.info("@# GET /register");
        // ✅ [수정] 실제 JSP 경로
        return "login_page/register"; 
    }

    @PostMapping("/checkDuplicate")
    @ResponseBody 
    public String checkDuplicate(@RequestParam("fieldType") String fieldType, @RequestParam("value") String value) {
        log.info("@# POST /checkDuplicate: fieldType={}, value={}", fieldType, value);
        int count = 0;

        switch (fieldType) {
            case "id": count = memService.idCheck(value); break;
            case "nickname": count = memService.nicknameCheck(value); break;
            case "email": count = memService.emailCheck(value); break;
            case "phone": count = memService.phoneCheck(value); break;
        }

        return (count == 0) ? "SUCCESS" : "FAIL";
    }

    @RequestMapping("/registerOk")
    public String registerOk(@RequestParam HashMap<String, String> param, HttpSession session, HttpServletRequest request) {
        log.info("@# POST /registerOk: " + param);

        if (memService.idCheck(param.get("MEMBER_ID")) > 0) {
            request.setAttribute("msg", "이미 사용 중인 아이디입니다.");
            // ✅ [수정] alert.jsp가 사용할 URL (컨트롤러 매핑 경로)
            request.setAttribute("url", "register");
            // ✅ [수정] 실제 alert.jsp 경로
            return "login_page/alert";
        }
        // ... (다른 중복 검사들도 동일하게 수정 필요)

        memService.write(param); 

        session.setAttribute("id", param.get("MEMBER_ID"));
        session.setAttribute("name", param.get("NAME"));
        session.setAttribute("admin", 0); 
        
        return "redirect:/home";
    }

    @RequestMapping("/logout")
    public String logout(HttpServletRequest request) {
        log.info("@# GET /logout");
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        } 
        return "redirect:/login";
    }

    // 구글 소셜 로그인 콜백
    @RequestMapping("/login/oauth2/code/google")
    public String googleCallback(@RequestParam String code, HttpServletRequest request) {
        log.info("@# GET /login/oauth2/code/google, code={}", code);

        try {
            String accessToken = googleOAuthService.getGoogleAccessToken(code);
            GoogleUserInfo googleUserInfo = googleOAuthService.getGoogleUserInfo(accessToken);

            HashMap<String, String> userInfo = new HashMap<>();
            userInfo.put("socialType", "google");
            userInfo.put("socialId", googleUserInfo.getId());
            userInfo.put("EMAIL", googleUserInfo.getEmail());
            userInfo.put("NAME", googleUserInfo.getName());
            
            String nickname = googleUserInfo.getName();
            if (nickname == null || nickname.trim().isEmpty()) {
                nickname = googleUserInfo.getEmail().split("@")[0];
            }
            userInfo.put("NICKNAME", nickname);

            MemDTO socialMember = memService.findOrCreateMember(userInfo);

            if (socialMember == null) {
                request.setAttribute("msg", "이미 해당 이메일로 가입된 계정이 있습니다.");
                // ✅ [수정] alert.jsp가 사용할 URL (컨트롤러 매핑 경로)
                request.setAttribute("url", "login");
                // ✅ [수정] 실제 alert.jsp 경로
                return "login_page/alert";
            }

            HttpSession session = request.getSession();
            session.setAttribute("id", socialMember.getMemberId());
            session.setAttribute("name", socialMember.getName());
            session.setAttribute("admin", socialMember.getAdminck());

            return "redirect:/home";

        } catch (Exception e) {
            log.error("@# 구글 로그인 처리 중 예외 발생: {}", e.getMessage());
            request.setAttribute("msg", "소셜 로그인 중 오류가 발생했습니다. 관리자에게 문의하세요.");
            // ✅ [수정] alert.jsp가 사용할 URL (컨트롤러 매핑 경로)
            request.setAttribute("url", "login");
            // ✅ [수정] 실제 alert.jsp 경로
            return "login_page/alert";
        }
    }
}

