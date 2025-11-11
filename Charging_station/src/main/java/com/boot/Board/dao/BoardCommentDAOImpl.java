package com.boot.Board.dao;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.boot.Board.dto.BoardCommentDTO;

@Repository
public class BoardCommentDAOImpl implements BoardCommentDAO {
    
    @Autowired
    private SqlSession sqlSession;
    
    private static final String NAMESPACE = "com.boot.Board.dao.BoardCommentDAO";
    
    @Override
    public List<BoardCommentDTO> getComments(int boardId) {
        return sqlSession.selectList(NAMESPACE + ".getComments", boardId);
    }
    
    @Override
    public void writeComment(HashMap<String, String> param) {
        sqlSession.insert(NAMESPACE + ".writeComment", param);
    }
    
    @Override
    public void modifyComment(HashMap<String, String> param) {
        sqlSession.update(NAMESPACE + ".modifyComment", param);
    }
    
    @Override
    public void deleteComment(int commentId) {
        sqlSession.delete(NAMESPACE + ".deleteComment", commentId);
    }
    
    @Override
    public BoardCommentDTO getComment(int commentId) {
        return sqlSession.selectOne(NAMESPACE + ".getComment", commentId);
    }
}

