package com.boot.Notice.dao;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.boot.Notice.dto.NoticeDTO;

@Repository
public class NoticeDAOImpl implements NoticeDAO {
    
    @Autowired
    private SqlSession sqlSession;
    
    private static final String NAMESPACE = "com.boot.Notice.dao.NoticeDAO";
    
    @Override
    public List<NoticeDTO> list() {
        return sqlSession.selectList(NAMESPACE + ".list");
    }
    
    @Override
    public List<NoticeDTO> listByCategory(String category) {
        return sqlSession.selectList(NAMESPACE + ".listByCategory", category);
    }
    
    @Override
    public List<NoticeDTO> search(HashMap<String, String> param) {
        return sqlSession.selectList(NAMESPACE + ".search", param);
    }
    
    @Override
    public NoticeDTO getNotice(int noticeId) {
        return sqlSession.selectOne(NAMESPACE + ".getNotice", noticeId);
    }
    
    @Override
    public void write(HashMap<String, String> param) {
        sqlSession.insert(NAMESPACE + ".write", param);
    }
    
    @Override
    public void modify(HashMap<String, String> param) {
        sqlSession.update(NAMESPACE + ".modify", param);
    }
    
    @Override
    public void delete(int noticeId) {
        sqlSession.delete(NAMESPACE + ".delete", noticeId);
    }
    
    @Override
    public void increaseViewCount(int noticeId) {
        sqlSession.update(NAMESPACE + ".increaseViewCount", noticeId);
    }
    
    @Override
    public List<NoticeDTO> getFixedNotices() {
        return sqlSession.selectList(NAMESPACE + ".getFixedNotices");
    }
}

