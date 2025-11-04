package com.boot.Main_Page.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List; // List import 추가

import com.boot.Main_Page.dto.ElecDTO;
import java.util.Map; // Map import 추가


public interface ElecDAO {
	public ArrayList<ElecDTO> list();
    
    // 💡 [추가] 검색 파라미터(위도, 경도, 반경)를 Map으로 받아 충전소 목록을 반환하는 메서드
    public List<ElecDTO> searchStations(Map<String, Object> params); 
}