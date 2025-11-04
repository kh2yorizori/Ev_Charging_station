package com.boot.Main_Page.controller;

import java.util.ArrayList;
import java.util.List; // List import 추가

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam; // @RequestParam import 추가
import org.springframework.web.bind.annotation.ResponseBody; // @ResponseBody import 추가

import com.boot.Main_Page.dto.ElecDTO;
import com.boot.Main_Page.service.ElecService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class ElecController {
	
	@Autowired
	private ElecService service;
	
    // 💡 [수정] 모든 데이터를 JSP로 넘기는 로직 제거
	@GetMapping("/map_kakao")
	public String kakao_map() {
		// 이제 데이터는 검색 시 JavaScript에서 비동기(AJAX/Fetch)로 요청합니다.
		return "kakao_map";
	}
	
	@GetMapping("/map")
	public String showMapPage() {
		return "map";
	}
    
    // 💡 [추가] 검색 요청을 처리하고 JSON을 반환하는 엔드포인트
    @GetMapping("/searchStations")
    @ResponseBody // 반환 값을 JSON 형태로 HTTP 응답 본문에 직접 작성하도록 지정
    public List<ElecDTO> searchStations(
            @RequestParam("lat") double latitude,
            @RequestParam("lng") double longitude,
            // 반경(m)을 받으며, 값이 없을 경우 기본값은 5000m (5km)로 설정
            @RequestParam(value = "radius", defaultValue = "5000") int radius) {
    	log.info("--- 1. Controller searchStations 메서드 시작 ---");
        log.info("충전소 검색 요청: Latitude={}, Longitude={}, Radius={}m", latitude, longitude, radius);
        
        // Service의 검색 메서드를 호출합니다.
        List<ElecDTO> stations = service.searchStations(latitude, longitude, radius);
        log.info("--- 2. Controller Service 호출 완료. 반환 데이터 수: {}", stations.size());
        
        return stations; // Spring이 List를 JSON 배열로 자동 변환하여 클라이언트에 전송합니다.
    }
}