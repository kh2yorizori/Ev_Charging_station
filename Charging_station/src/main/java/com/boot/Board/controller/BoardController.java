package com.boot.Board.controller;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.boot.Board.dto.BoardCommentDTO;
import com.boot.Board.dto.BoardDTO;
import com.boot.Board.service.BoardCommentService;
import com.boot.Board.service.BoardService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class BoardController {
    
    @Autowired
    private BoardService boardService;
    
    @Autowired
    private BoardCommentService boardCommentService;
    
    // 게시판 목록 페이지
    @GetMapping("/board")
    public String boardList(
            @RequestParam(value = "keyword", required = false) String keyword,
            HttpServletRequest request,
            Model model) {
        log.info("@# GET /board keyword={}", keyword);
        
        // 세션에서 사용자 정보 확인
        HttpSession session = request.getSession(false);
        if (session != null) {
            String memberId = (String) session.getAttribute("id");
            model.addAttribute("memberId", memberId);
        }
        
        List<BoardDTO> boards;
        
        // 검색어가 있으면 검색, 없으면 전체 조회
        if (keyword != null && !keyword.trim().isEmpty()) {
            HashMap<String, String> param = new HashMap<>();
            param.put("keyword", keyword);
            boards = boardService.search(param);
        } else {
            boards = boardService.list();
        }
        
        model.addAttribute("boards", boards);
        return "board/board_list";
    }
    
    // 게시글 상세 페이지
    @GetMapping("/board/detail")
    public String boardDetail(
            @RequestParam("boardId") int boardId,
            HttpServletRequest request,
            Model model) {
        log.info("@# GET /board/detail boardId={}", boardId);
        
        BoardDTO board = boardService.getBoard(boardId);
        model.addAttribute("board", board);
        
        // 댓글 목록 조회
        List<BoardCommentDTO> comments = boardCommentService.getComments(boardId);
        model.addAttribute("comments", comments);
        
        // 세션에서 사용자 정보 확인
        HttpSession session = request.getSession(false);
        if (session != null) {
            String memberId = (String) session.getAttribute("id");
            model.addAttribute("memberId", memberId);
        }
        
        return "board/board_detail";
    }
    
    // 게시글 작성 페이지
    @GetMapping("/board/write")
    public String boardWriteForm(HttpServletRequest request) {
        log.info("@# GET /board/write");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            return "redirect:/login";
        }
        
        return "board/board_write";
    }
    
    // 게시글 작성 처리
    @PostMapping("/board/write")
    public String boardWrite(
            @RequestParam HashMap<String, String> param,
            HttpServletRequest request) {
        log.info("@# POST /board/write param={}", param);
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            return "redirect:/login";
        }
        
        String memberId = (String) session.getAttribute("id");
        param.put("member_id", memberId);
        
        boardService.write(param);
        
        return "redirect:/board";
    }
    
    // 게시글 수정 페이지
    @GetMapping("/board/modify")
    public String boardModifyForm(
            @RequestParam("boardId") int boardId,
            HttpServletRequest request,
            Model model) {
        log.info("@# GET /board/modify boardId={}", boardId);
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            return "redirect:/login";
        }
        
        String memberId = (String) session.getAttribute("id");
        BoardDTO board = boardService.getBoardWithoutViewCount(boardId);
        
        // 본인 글인지 확인
        if (!board.getMemberId().equals(memberId)) {
            return "redirect:/board";
        }
        
        model.addAttribute("board", board);
        
        return "board/board_modify";
    }
    
    // 게시글 수정 처리
    @PostMapping("/board/modify")
    public String boardModify(
            @RequestParam HashMap<String, String> param,
            HttpServletRequest request) {
        log.info("@# POST /board/modify param={}", param);
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            return "redirect:/login";
        }
        
        String memberId = (String) session.getAttribute("id");
        BoardDTO board = boardService.getBoardWithoutViewCount(Integer.parseInt(param.get("board_id")));
        
        // 본인 글인지 확인
        if (!board.getMemberId().equals(memberId)) {
            return "redirect:/board";
        }
        
        boardService.modify(param);
        
        return "redirect:/board/detail?boardId=" + param.get("board_id");
    }
    
    // 게시글 삭제
    @PostMapping("/board/delete")
    public String boardDelete(
            @RequestParam("boardId") int boardId,
            HttpServletRequest request) {
        log.info("@# POST /board/delete boardId={}", boardId);
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            return "redirect:/login";
        }
        
        String memberId = (String) session.getAttribute("id");
        BoardDTO board = boardService.getBoardWithoutViewCount(boardId);
        
        // 본인 글인지 확인
        if (!board.getMemberId().equals(memberId)) {
            return "redirect:/board";
        }
        
        boardService.delete(boardId);
        
        return "redirect:/board";
    }
    
    // 댓글 작성
    @PostMapping("/board/comment/write")
    public String commentWrite(
            @RequestParam HashMap<String, String> param,
            HttpServletRequest request) {
        log.info("@# POST /board/comment/write param={}", param);
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            return "redirect:/login";
        }
        
        String memberId = (String) session.getAttribute("id");
        param.put("member_id", memberId);
        
        boardCommentService.writeComment(param);
        
        return "redirect:/board/detail?boardId=" + param.get("board_id");
    }
    
    // 댓글 수정
    @PostMapping("/board/comment/modify")
    public String commentModify(
            @RequestParam HashMap<String, String> param,
            HttpServletRequest request) {
        log.info("@# POST /board/comment/modify param={}", param);
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            return "redirect:/login";
        }
        
        String memberId = (String) session.getAttribute("id");
        BoardCommentDTO comment = boardCommentService.getComment(Integer.parseInt(param.get("comment_id")));
        
        // 본인 댓글인지 확인
        if (!comment.getMemberId().equals(memberId)) {
            return "redirect:/board";
        }
        
        boardCommentService.modifyComment(param);
        
        return "redirect:/board/detail?boardId=" + param.get("board_id");
    }
    
    // 댓글 삭제
    @PostMapping("/board/comment/delete")
    public String commentDelete(
            @RequestParam("commentId") int commentId,
            @RequestParam("boardId") int boardId,
            HttpServletRequest request) {
        log.info("@# POST /board/comment/delete commentId={}", commentId);
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            return "redirect:/login";
        }
        
        String memberId = (String) session.getAttribute("id");
        BoardCommentDTO comment = boardCommentService.getComment(commentId);
        
        // 본인 댓글인지 확인
        if (!comment.getMemberId().equals(memberId)) {
            return "redirect:/board";
        }
        
        boardCommentService.deleteComment(commentId);
        
        return "redirect:/board/detail?boardId=" + boardId;
    }
}

