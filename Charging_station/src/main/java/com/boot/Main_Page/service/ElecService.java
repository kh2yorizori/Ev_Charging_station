package com.boot.Main_Page.service;

import java.util.ArrayList;
import java.util.List; // List import 추가

import org.springframework.stereotype.Service;

import com.boot.Main_Page.dto.ElecDTO;

public interface ElecService {
	public ArrayList<ElecDTO> list();
    
    // 💡 [추가] 위도, 경도, 반경을 받아 검색 로직을 수행할 메서드
    public List<ElecDTO> searchStations(double latitude, double longitude, int radius);
}