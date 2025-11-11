package com.boot.Notice.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.Notice.dao.NoticeDAO;
import com.boot.Notice.dto.NoticeDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class NoticeServiceImpl implements NoticeService {
    
    @Autowired
    private NoticeDAO noticeDAO;
    
    @Override
    public List<NoticeDTO> list() {
        log.info("@# NoticeServiceImpl.list()");
        return noticeDAO.list();
    }
    
    @Override
    public List<NoticeDTO> listByCategory(String category) {
        log.info("@# NoticeServiceImpl.listByCategory() category={}", category);
        return noticeDAO.listByCategory(category);
    }
    
    @Override
    public List<NoticeDTO> search(HashMap<String, String> param) {
        log.info("@# NoticeServiceImpl.search() param={}", param);
        return noticeDAO.search(param);
    }
    
    @Override
    public NoticeDTO getNotice(int noticeId) {
        log.info("@# NoticeServiceImpl.getNotice() noticeId={}", noticeId);
        // 조회수 증가
        noticeDAO.increaseViewCount(noticeId);
        return noticeDAO.getNotice(noticeId);
    }
    
    @Override
    public void write(HashMap<String, String> param) {
        log.info("@# NoticeServiceImpl.write() param={}", param);
        noticeDAO.write(param);
    }
    
    @Override
    public void modify(HashMap<String, String> param) {
        log.info("@# NoticeServiceImpl.modify() param={}", param);
        noticeDAO.modify(param);
    }
    
    @Override
    public void delete(int noticeId) {
        log.info("@# NoticeServiceImpl.delete() noticeId={}", noticeId);
        noticeDAO.delete(noticeId);
    }
    
    @Override
    public List<NoticeDTO> getFixedNotices() {
        log.info("@# NoticeServiceImpl.getFixedNotices()");
        return noticeDAO.getFixedNotices();
    }
    
    @Override
    public NoticeDTO notgetNotice(int noticeId) {
        log.info("@# NoticeServiceImpl.getNotice() noticeId={}", noticeId);
        // 조회수 증가
        return noticeDAO.getNotice(noticeId);
    }
}

