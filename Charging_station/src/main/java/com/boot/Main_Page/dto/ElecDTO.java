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

    private double latitude;
    private double longitude;
    private double distance_m;

    /**
     * COUNT(*) AS charger_count
     * 해당 충전소의 총 충전기 개수
     */
    private int charger_count;

    /**
     * [추가] 
     * SUM(CASE ...) AS fast_charger_count
     * 급속 충전기 총 개수
     */
    private int fast_charger_count;

    /**
     * [추가]
     * SUM(CASE ...) AS slow_charger_count
     * 완속 충전기 총 개수
     */
    private int slow_charger_count;
    
    
    /** [추가] 급속 충전기 상세_DC콤보 */
    private int fast_type_dc_combo;
    /** [추가] 급속 충전기 상세_DC차데모 */
    private int fast_type_dc_chademo;
    /** [추가] 급속 충전기 상세_DC차데모+AC3상+DC콤보 */
    private int fast_type_multi_1;
    /** [추가] 급속 충전기 상세_DC차데모+DC콤보 */
    private int fast_type_multi_2;
    /** [추가] 급속 충전기 상세_DC차데모+AC3상 */
    private int fast_type_multi_3;

    /** [추가] 완속 충전기 상세_AC3상 */
    private int slow_type_ac3;
    /** [추가] 완속 충전기 상세_AC완속 */
    private int slow_type_ac_slow;
    /** [추가] 완속 충전기 상세_DC콤보(완속) */
    private int slow_type_dc_slow;
    
}