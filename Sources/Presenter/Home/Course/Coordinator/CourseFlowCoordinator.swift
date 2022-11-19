//
//  CourseFlowCoordinator.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/19.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

enum CourseFlowType: Int {
    /// 계획을 하지 않은 상태에서 데이트 코스를 추가합니다.
    /// 타이틀, 장소, 후기 등록을 합니다.
    case addCourse = 0
    
    /// 계획을 해두었던 데이트 코스에 대하여 후기를 작성합니다.
    /// 사진과 후기를 등록합니다.
    case registerReview

    /// 계획을 해두었던 데이트 코스에 대하여 수정을 합니다.
    /// 타이틀, 장소를 수정합니다.
    case editCourse
    
    /// 데이트 코스를 계획합니다.
    /// 타이틀, 장소를 계획합니다.
    case addPlan

    /// 계획한 데이트 코스를 수정합니다.
    /// 타이틀, 장소를 수정합니다.
    case editPlan
}

protocol CourseFlowCoordinator: Coordinator {
    
}
