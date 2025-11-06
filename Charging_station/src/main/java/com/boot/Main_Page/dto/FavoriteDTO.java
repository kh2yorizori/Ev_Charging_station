package com.boot.Main_Page.dto;

import java.sql.Timestamp;
import lombok.Data;

@Data
public class FavoriteDTO {
    
    private int favoriteId;       // 즐겨찾기 ID (PK)
    private String memberId;      // 회원 ID (FK)
    private int stationId;        // 충전소 ID (FK)
    private Timestamp createdAt;  // 생성일
}