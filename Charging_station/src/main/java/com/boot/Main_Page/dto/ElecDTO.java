package com.boot.Main_Page.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ElecDTO {

    private int id;
    private int installation_year;              // 설치년도
    private String city;                        // 시도
    private String district;                    // 군구
    private String address;                     // 주소
    private String station_name;                // 충전소명
    private String facility_type_large;         // 시설구분(대)
    private String facility_type_small;         // 시설구분(소)
    private String charger_model_large;         // 기종(대)
    private String charger_model_small;         // 기종(소) (GROUP_CONCAT으로 묶인 문자열)
    private String operator_large;              // 운영기관(대)
    private String operator_small;              // 운영기관(소)
    private String fast_charge_capacity;        // 급속충전량 (GROUP_CONCAT으로 묶인 문자열)
    // private String charger_type;             // (타입별 개수로 대체되었으므로 제거)
    private String user_restriction;            // 이용자제한

    private double latitude;                    // 위도
    private double longitude;                   // 경도
    
    /**
     * (6371... * ACOS(...)) AS distance_m 
     * 사용자와의 거리 (미터)
     */
    private double distance_m;

    /**
     * COUNT(*) AS charger_count
     * 해당 충전소의 총 충전기 개수
     */
    private int charger_count;

    /**
     * SUM(CASE WHEN charger_type = 'DC콤보' ...) AS count_dc_combo
     * DC콤보 타입 충전기 개수
     */
    private int count_dc_combo;

    /**
     * SUM(CASE WHEN charger_type = 'AC3상' ...) AS count_ac3
     * AC3상 타입 충전기 개수
     */
    private int count_ac3;

    /**
     * SUM(CASE WHEN charger_type = 'DC차데모+AC3상+DC콤보' ...) AS count_multi
     * 3-in-1 (멀티) 타입 충전기 개수
     */
    private int count_multi;

    /**
     * SUM(CASE WHEN charger_type = 'DC차데모' ...) AS count_chademo
     * DC차데모 타입 충전기 개수
     */
    private int count_chademo;
    
}