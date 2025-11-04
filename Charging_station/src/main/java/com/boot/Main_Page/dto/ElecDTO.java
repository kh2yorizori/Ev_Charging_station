package com.boot.Main_Page.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ElecDTO {

    private int id;
    private int installation_year;                 // 설치년도
    private String city;                           // 시도
    private String district;                       // 군구
    private String address;                        // 주소
    private String station_name;                   // 충전소명
    private String facility_type_large;            // 시설구분(대)
    private String facility_type_small;            // 시설구분(소)
    private String charger_model_large;            // 기종(대)
    private String charger_model_small;            // 기종(소)
    private String operator_large;                 // 운영기관(대)
    private String operator_small;                 // 운영기관(소)
    private String fast_charge_capacity;           // 급속충전량
    private String charger_type;                   // 충전기타입
    private String user_restriction;               // 이용자제한

    private double latitude;                       // 위도
    private double longitude;                      // 경도
}

