package com.boot.Main_Page.controller;

import java.util.ArrayList;
import java.util.List; 
import java.util.Map;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam; 
import org.springframework.web.bind.annotation.ResponseBody; 

import com.boot.Main_Page.dto.ElecDTO;
import com.boot.Main_Page.service.ElecService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class ElecController {
	
	@Autowired
	private ElecService service;
	
    // (기존) JSP 페이지만 반환
	@GetMapping("/map_kakao")
	public String kakao_map() {
		return "kakao_map";
	}
	
    // (기존) JSP 페이지만 반환
	@GetMapping("/map")
	public String showMapPage() {
		return "map";
	}
     
    /**
     * 1. '반경 검색' 엔드포인트
     */
    @GetMapping("/searchByRadius")
    @ResponseBody 
    public List<ElecDTO> searchByRadius(
            @RequestParam("lat") double latitude,
            @RequestParam("lng") double longitude,
            @RequestParam(value = "radius", defaultValue = "5000") double radius) {
       
        log.info("--- 1. Controller searchByRadius 메서드 시작 ---");
        Map<String, Object> params = new HashMap<>();
        params.put("targetLat", latitude);
        params.put("targetLng", longitude);
        params.put("radius", radius);
        
        List<ElecDTO> stations = service.findStationsByRadius(params); 
        log.info("--- 2. Controller searchByRadius 완료. 반환 데이터 수: {}", stations.size());
         
        return stations;
    }

    /**
     * 2. '키워드 검색' 엔드포인트
     */
    @GetMapping("/searchByKeyword")
    @ResponseBody
    public List<ElecDTO> searchByKeyword(@RequestParam("keyword") String keyword) {
        log.info("--- 1. Controller searchByKeyword 메서드 시작 ---");
        Map<String, Object> params = new HashMap<>();
        params.put("keyword", keyword);

        List<ElecDTO> stations = service.findStationsByKeyword(params);
        log.info("--- 2. Controller searchByKeyword 완료. 반환 데이터 수: {}", stations.size());

        return stations;
    }
    
    /**
     * 3. '지도 영역 검색' 엔드포인트 (현재 위치에서 찾기 버튼용)
     */
    @GetMapping("/searchByBounds")
    @ResponseBody
    public List<ElecDTO> searchByBounds(
            @RequestParam("minLat") double minLat,
            @RequestParam("maxLat") double maxLat,
            @RequestParam("minLng") double minLng,
            @RequestParam("maxLng") double maxLng) {
        
        log.info("--- 1. Controller searchByBounds 메서드 시작 ---");
        Map<String, Object> params = new HashMap<>();
        params.put("minLat", minLat);
        params.put("maxLat", maxLat);
        params.put("minLng", minLng);
        params.put("maxLng", maxLng);
        
        List<ElecDTO> stations = service.findStationsByBounds(params);
        log.info("--- 2. Controller searchByBounds 완료. 반환 데이터 수: {}", stations.size());

        return stations;
    }
}