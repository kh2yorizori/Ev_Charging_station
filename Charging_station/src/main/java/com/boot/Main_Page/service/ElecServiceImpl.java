package com.boot.Main_Page.service;

import java.util.ArrayList;
import java.util.HashMap; // HashMap import 추가
import java.util.List; // List import 추가
import java.util.Map; // Map import 추가

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.Main_Page.dao.ElecDAO;
import com.boot.Main_Page.dto.ElecDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ElecServiceImpl implements ElecService {

	@Autowired
	SqlSession sqlSession;
	
	@Override
	public ArrayList<ElecDTO> list() {
		ElecDAO dao = sqlSession.getMapper(ElecDAO.class);
		ArrayList<ElecDTO> list = dao.list();
		
		if (!list.isEmpty()) {
		    // 💡 첫 번째 항목의 station_name 값이 무엇인지 확인합니다.
		    log.info("첫 번째 충전소 이름 (DB 조회 결과): [{}]", list.get(0).getStation_name()); 
		} 
		
		return list;
	}

    // 💡 [추가] 검색 메서드 구현
    @Override
    public List<ElecDTO> searchStations(double latitude, double longitude, int radius) {
    	log.info("--- 3. Service searchStations 진입 ---");
        ElecDAO dao = sqlSession.getMapper(ElecDAO.class);
        
        // 파라미터를 Map에 담아 DAO로 전달
        Map<String, Object> params = new HashMap<>();
        params.put("targetLat", latitude);
        params.put("targetLng", longitude);
        params.put("radius", radius);
        
        List<ElecDTO> list = dao.searchStations(params); // DAO 호출
        
        log.info("DAO 검색 결과 건수: {}", list.size()); 
        if (!list.isEmpty()) {
            // 💡 중요: 첫 번째 DTO 객체의 station_name 값을 확인합니다.
            log.info("첫 번째 충전소 이름 (DB 조회 결과): [{}]", list.get(0).getStation_name()); 
        }
        
        return list;
    }
}