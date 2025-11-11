package com.boot.Notice.controller;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.boot.Notice.dto.NoticeDTO;
import com.boot.Notice.service.NoticeService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class NoticeController {
    
    @Autowired
    private NoticeService noticeService;
    
    // 공지사항 목록 페이지
    @GetMapping("/notice")
    public String noticeList(
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "keyword", required = false) String keyword,
            HttpServletRequest request,
            Model model) {
        log.info("@# GET /notice category={}, keyword={}", category, keyword);
        
        // 세션에서 관리자 정보 확인
        HttpSession session = request.getSession(false);
        if (session != null) {
            Integer admin = (Integer) session.getAttribute("admin");
            log.info("@# 공지사항 목록 - 세션 admin 값: {}", admin);
            model.addAttribute("adminCheck", admin);
        }
        
        List<NoticeDTO> notices;
        
        // 고정 공지사항 조회
        List<NoticeDTO> fixedNotices = noticeService.getFixedNotices();
        model.addAttribute("fixedNotices", fixedNotices);
        
        // 검색어가 있으면 검색, 카테고리가 있으면 카테고리별 조회, 없으면 전체 조회
        if (keyword != null && !keyword.trim().isEmpty()) {
            HashMap<String, String> param = new HashMap<>();
            param.put("keyword", keyword);
            notices = noticeService.search(param);
        } else if (category != null && !category.isEmpty()) {
            notices = noticeService.listByCategory(category);
        } else {
            notices = noticeService.list();
        }
        
        model.addAttribute("notices", notices);
        return "notice/notice_list";
    }
    
    // 공지사항 상세 페이지
    @GetMapping("/notice/detail")
    public String noticeDetail(@RequestParam("noticeId") int noticeId, Model model) {
        log.info("@# GET /notice/detail noticeId={}", noticeId);
        
        NoticeDTO notice = noticeService.getNotice(noticeId);
        model.addAttribute("notice", notice);
        
        return "notice/notice_detail";
    }
    
    // 공지사항 작성 페이지 (관리자만)
    @GetMapping("/notice/write")
    public String noticeWriteForm(HttpServletRequest request) {
        log.info("@# GET /notice/write");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            return "redirect:/login";
        }
        
        Integer adminCk = (Integer) session.getAttribute("admin");
        if (adminCk == null || adminCk != 1) {
            return "redirect:/notice";
        }
        
        return "notice/notice_write";
    }
    
    // 공지사항 작성 처리
    @PostMapping("/notice/write")
    public String noticeWrite(
            @RequestParam HashMap<String, String> param,
            HttpServletRequest request) {
        log.info("@# POST /notice/write param={}", param);
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            return "redirect:/login";
        }
        
        Integer adminCk = (Integer) session.getAttribute("admin");
        if (adminCk == null || adminCk != 1) {
            return "redirect:/notice";
        }
        
        String memberId = (String) session.getAttribute("id");
        param.put("member_id", memberId);
        
        noticeService.write(param);
        
        return "redirect:/notice";
    }
    
    // 공지사항 수정 페이지
    @GetMapping("/notice/modify")
    public String noticeModifyForm(
            @RequestParam("noticeId") int noticeId,
            HttpServletRequest request,
            Model model) {
        log.info("@# GET /notice/modify noticeId={}", noticeId);
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            return "redirect:/login";
        }
        
        Integer adminCk = (Integer) session.getAttribute("admin");
        if (adminCk == null || adminCk != 1) {
            return "redirect:/notice";
        }
        
        NoticeDTO notice = noticeService.notgetNotice(noticeId);
        model.addAttribute("notice", notice);
        
        return "notice/notice_modify";
    }
    
    // 공지사항 수정 처리
    @PostMapping("/notice/modify")
    public String noticeModify(
            @RequestParam HashMap<String, String> param,
            HttpServletRequest request) {
        log.info("@# POST /notice/modify param={}", param);
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            return "redirect:/login";
        }
        
        Integer adminCk = (Integer) session.getAttribute("admin");
        if (adminCk == null || adminCk != 1) {
            return "redirect:/notice";
        }
        
        // is_fixed 값이 없으면 0으로 설정
        if (!param.containsKey("is_fixed") || param.get("is_fixed") == null || param.get("is_fixed").isEmpty()) {
            param.put("is_fixed", "0");
        }
        
        noticeService.modify(param);
        
        return "redirect:/notice/detail?noticeId=" + param.get("notice_id");
    }
    
    // 공지사항 삭제
    @PostMapping("/notice/delete")
    public String noticeDelete(
            @RequestParam("noticeId") int noticeId,
            HttpServletRequest request) {
        log.info("@# POST /notice/delete noticeId={}", noticeId);
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            return "redirect:/login";
        }
        
        Integer adminCk = (Integer) session.getAttribute("admin");
        if (adminCk == null || adminCk != 1) {
            return "redirect:/notice";
        }
        
        noticeService.delete(noticeId);
        
        return "redirect:/notice";
    }
}

