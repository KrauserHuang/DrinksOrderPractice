//
//  Enums.swift
//  DrinksOrderPractice
//
//  Created by Tai Chin Huang on 2021/5/3.
//

import Foundation

//enum OptionType: String, CaseIterable {
//    case iceLevel, sugarLevel, sizeLevel, extraToppings
//}

enum SizeLevel: String, CaseIterable {
    case medium = "中杯"
    case large = "大杯"
}
enum IceLevel: String, CaseIterable {
    case regular = "正常"
    case seventy = "少冰"
    case thirty = "微冰"
    case no = "去冰"
    case roomTemp = "常溫"
    case hot = "熱"
}
enum SugarLevel: String, CaseIterable {
    case regular = "正常"
    case seventy = "少糖"
    case fifty = "半糖"
    case thirty = "微糖"
    case no = "無糖"
}
enum ExtraToppings: String, CaseIterable {
    case none = "無"
    case boba = "白玉珍珠"
//    case grassjelly = "嫩仙草"
}
