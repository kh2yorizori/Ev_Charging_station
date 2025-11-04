package com.boot.login.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;     // [1] 이메일 관련 Import 추가
import org.springframework.mail.javamail.JavaMailSender;  // [2] 이메일 관련 Import 추가
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

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

    @Autowired
    private JavaMailSender mailSender; // [3] JavaMailSender 주입

    // 로그인 화면
    @RequestMapping("/login")
    public String login() {
        log.info("@# GET /login");
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
        
        // [보안] 나중에 이 로직을 BCrypt 암호화 방식으로 변경해야 합니다.
        ArrayList<MemDTO> dtos = memService.loginYn(param);

        if (dtos == null || dtos.isEmpty()) {
            request.setAttribute("msg", "아이디 또는 비밀번호가 잘못 되었습니다.");
            request.setAttribute("url", "login"); 
            return "login_page/alert"; 
        } else {
            HttpSession session = request.getSession();
            MemDTO loginUser = dtos.get(0);

            session.setAttribute("id", loginUser.getMemberId());
            session.setAttribute("name", loginUser.getName());
            session.setAttribute("admin", loginUser.getAdminck());

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
        return "login_page/login_ok"; 
    }

    // 회원가입 화면
    @RequestMapping("/register")
    public String register() {
        log.info("@# GET /register");
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
            request.setAttribute("url", "register");
            return "login_page/alert";
        }
        // ... (다른 중복 검사)

        memService.write(param); 

        session.setAttribute("id", param.get("MEMBER_ID"));
        session.setAttribute("name", param.get("NAME"));
        session.setAttribute("admin", 0); 
        
        return "redirect:/home"; // 회원가입 성공 시 이동할 페이지
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
                request.setAttribute("url", "login");
                return "login_page/alert";
            }

            HttpSession session = request.getSession();
            session.setAttribute("id", socialMember.getMemberId());
            session.setAttribute("name", socialMember.getName());
            session.setAttribute("admin", socialMember.getAdminck());

            return "redirect:/login_ok";

        } catch (Exception e) {
            log.error("@# 구글 로그인 처리 중 예외 발생: {}", e.getMessage());
            request.setAttribute("msg", "소셜 로그인 중 오류가 발생했습니다. 관리자에게 문의하세요.");
            request.setAttribute("url", "login");
            return "login_page/alert";
        }
    }
    
    // [4] 비밀번호 찾기 기능 (수정 완료)
    
    /**
     * 비밀번호 찾기 페이지로 이동
     */
    @RequestMapping("/findPassword")
    public String findPassword() {
        log.info("@# GET /findPassword");
        return "login_page/findPassword";
    }

    /**
     * 비밀번호 찾기 폼 처리 (메일 발송)
     */
    @PostMapping("/findPasswordAction")
    public String findPasswordAction(@RequestParam("MEMBER_ID") String memberId,
                                    @RequestParam("email") String email, HttpServletRequest request) {
        
        // (로그 형식 수정: {} 사용)
        log.info("@# POST /findPasswordAction => ID: {}, Email: {}", memberId, email);
        
        HashMap<String, String> params = new HashMap<>();
        params.put("MEMBER_ID", memberId);
        params.put("email", email);
        
        MemDTO user = memService.findUserByIdAndEmail(params);
        
        if(user == null) {
            // [수정] 자바스크립트 줄바꿈 오류 방지를 위해 \n 대신 \\n 사용
            request.setAttribute("msg", "일치 하는 회원 정보가 없습니다.\\n아이디 또는 이메일이 올바르지 않습니다.");
            request.setAttribute("url", "findPassword");
            return "login_page/alert";
            
        } else {
            // 1. 임시 비밀번호 생성
            String tempPassword = getTempPassword(8);
            
            // 2. DB에 임시 비밀번호로 업데이트
            HashMap<String , String> updateParams = new HashMap<>();
            updateParams.put("MEMBER_ID", memberId);
            updateParams.put("PASSWORD", tempPassword); // [보안] 추후 이 부분을 암호화해서 저장해야 합니다.
            
            memService.updatePassword(updateParams);
            
            // 3. 실제 이메일 발송
            try {
                SimpleMailMessage message = new SimpleMailMessage();
                message.setTo(email); // 수신자 이메일
                
                // [!!] application.properties의 spring.mail.username과 동일한 이메일
                message.setFrom("your_emai@gmail.com"); 
                message.setSubject("[임시 비밀번호 안내] 요청하신 임시 비밀번호입니다."); // 메일 제목
                
                String mailText = "요청하신 임시 비밀번호입니다.\n\n"
                                + "임시 비밀번호: " + tempPassword + "\n\n"
                                + "로그인 후 반드시 비밀번호를 변경해주세요.";
                message.setText(mailText); // 메일 본문
                
                mailSender.send(message); // 발송
                
                log.info("임시 비밀번호 이메일 발송 성공: {}", email);

            } catch (Exception e) {
                log.error("이메일 발송 중 오류 발생: {}", e.getMessage());
                // (선택 사항) 만약 메일 발송만 실패하면 사용자에게 다르게 알릴 수 있음
                // request.setAttribute("msg", "DB 업데이트는 성공했으나 메일 발송에 실패했습니다. 관리자에게 문의하세요.");
            }
            
            // 4. 완료 알림
            // [수정] 자바스크립트 줄바꿈 오류 방지를 위해 \n 대신 \\n 사용
            request.setAttribute("msg", "가입하신 이메일로 임시 비밀번호가 발송되었습니다.\\n로그인 후 비밀번호를 변경해주세요.");
            request.setAttribute("url","login");
            return "login_page/alert";
        }
    }
    
    /**
     * 임시 비밀번호 생성기 (Helper Method)
     */
    private String getTempPassword(int length) {
        char[] charSet = new char[] {
                '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
                'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 
                'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
        
        String str ="";
        int idx = 0;
        for(int i = 0; i < length; i++) {
            idx = (int)(charSet.length * Math.random());
            str += charSet[idx];
        }
        return str;
    }
}