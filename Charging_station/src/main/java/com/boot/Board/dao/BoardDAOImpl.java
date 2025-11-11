package com.boot.Board.dao;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.boot.Board.dto.BoardDTO;

@Repository
public class BoardDAOImpl implements BoardDAO {
    
    @Autowired
    private SqlSession sqlSession;
    
    private static final String NAMESPACE = "com.boot.Board.dao.BoardDAO";
    
    @Override
    public List<BoardDTO> list() {
        return sqlSession.selectList(NAMESPACE + ".list");
    }
    
    @Override
    public List<BoardDTO> search(HashMap<String, String> param) {
        return sqlSession.selectList(NAMESPACE + ".search", param);
    }
    
    @Override
    public BoardDTO getBoard(int boardId) {
        return sqlSession.selectOne(NAMESPACE + ".getBoard", boardId);
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
    public void delete(int boardId) {
        sqlSession.delete(NAMESPACE + ".delete", boardId);
    }
    
    @Override
    public void increaseViewCount(int boardId) {
        sqlSession.update(NAMESPACE + ".increaseViewCount", boardId);
    }
}

