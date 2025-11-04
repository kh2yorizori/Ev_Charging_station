package com.boot.MY_Page.controller;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.boot.MY_Page.dto.MyPageDTO;
import com.boot.MY_Page.service.MyPageService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class MyPageController {

    @Autowired
    private MyPageService service;

    @RequestMapping("/role")
    public String role(HttpServletRequest request, Model model) {
        log.info("@# role()");
        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("id") == null) {
            return "redirect:login_view";
        }

        List<MyPageDTO> userData = service.list();
        model.addAttribute("userData", userData);
        return "role";
    }

    @RequestMapping("/list")
    public String list(HttpServletRequest request, Model model) {
        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("id") == null) {
            return "redirect:login_view";
        }

        String memberId = (String) session.getAttribute("id");
        MyPageDTO userData = service.getUserById(memberId);
        model.addAttribute("user", userData);
        return "list";
    }

    @RequestMapping("/modify")
    public String modify(HttpServletRequest request, @RequestParam HashMap<String, String> param, Model model) {
        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("id") == null) {
            return "redirect:login_view";
        }

        String memberId = (String) session.getAttribute("id");
        param.putIfAbsent("memberId", memberId); // HashMap 키를 DTO 필드명과 동일하게

        log.info("@# modify() param: " + param);
        service.modify(param);

        return "redirect:list";
    }

    @RequestMapping("/mypage_edit")
    public String edit(@RequestParam("memberId") String memberId, Model model) {
        MyPageDTO userData = service.getUserById(memberId);
        model.addAttribute("user", userData);
        return "mypage_edit";
    }

    @RequestMapping("/delete")
    public String delete(@RequestParam HashMap<String, String> param, HttpServletRequest request) {
        log.info("@# delete() param: " + param);
        service.delete(param);

        HttpSession session = request.getSession(false);
        if(session != null) {
            session.invalidate();
        }

        return "redirect:home";
    }

    @RequestMapping("/delete2")
    public String delete2(@RequestParam HashMap<String, String> param) {
        log.info("@# delete2() param: " + param);
        service.delete(param);

        return "redirect:role";
    }
}
