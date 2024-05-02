//
//  foodListModel.swift
//  tasteable
//
//  Created by jhon on 4/11/24.
//

import Foundation
import SwiftUI

struct FoodListModel: Identifiable {
    let id = UUID()
    let name: String
    let consumptionDate: Date
    let priority: Priority // 별점 입력시 Int
    let recipe: String?
    let experience: String?
    var images: [Image]
    
    // 'Priority' 열거형을 내부에 정의합니다.
    enum Priority: Int, CaseIterable {
        case high = 5, himed = 4, medium = 3, medlow=2, low = 1
    }
}






