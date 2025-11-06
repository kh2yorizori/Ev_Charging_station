package com.boot.Notice.dao;

import java.util.HashMap;
import java.util.List;

import com.boot.Notice.dto.NoticeDTO;

public interface NoticeDAO {
    
    // 공지사항 목록 조회 (전체)
    List<NoticeDTO> list();
    
    // 공지사항 목록 조회 (카테고리별)
    List<NoticeDTO> listByCategory(String category);
    
    // 공지사항 검색
    List<NoticeDTO> search(HashMap<String, String> param);
    
    // 공지사항 상세 조회
    NoticeDTO getNotice(int noticeId);
    
    // 공지사항 작성
    void write(HashMap<String, String> param);
    
    // 공지사항 수정
    void modify(HashMap<String, String> param);
    
    // 공지사항 삭제
    void delete(int noticeId);
    
    // 조회수 증가
    void increaseViewCount(int noticeId);
    
    // 고정 공지사항 조회
    List<NoticeDTO> getFixedNotices();
}

