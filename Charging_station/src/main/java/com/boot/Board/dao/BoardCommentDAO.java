package com.boot.Board.dao;

import java.util.HashMap;
import java.util.List;

import com.boot.Board.dto.BoardCommentDTO;

public interface BoardCommentDAO {
    
    // 댓글 목록 조회
    List<BoardCommentDTO> getComments(int boardId);
    
    // 댓글 작성
    void writeComment(HashMap<String, String> param);
    
    // 댓글 수정
    void modifyComment(HashMap<String, String> param);
    
    // 댓글 삭제
    void deleteComment(int commentId);
    
    // 댓글 상세 조회
    BoardCommentDTO getComment(int commentId);
}

