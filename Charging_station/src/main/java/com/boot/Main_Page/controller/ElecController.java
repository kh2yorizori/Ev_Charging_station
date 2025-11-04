package com.boot.Main_Page.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.boot.Main_Page.dto.ElecDTO;
import com.boot.Main_Page.service.ElecService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class ElecController {
	
	@Autowired
	private ElecService service;
	
//	@GetMapping("/map_kakao")
//	public String kakao_map() {
//		return "kakao_map"; 
//	}
	
	@GetMapping("/map_kakao")
	public String kakao_map(Model model, HttpServletRequest request) {
		ArrayList<ElecDTO> list = service.list();
		// 전기차 db들을 담아서 jsp로 보낼 elec_charge
		model.addAttribute("elec_charge", list);
		
		return "kakao_map"; 
	}
	
	@GetMapping("/map")
	public String showMapPage() {
		return "map"; 
	}
	
}









