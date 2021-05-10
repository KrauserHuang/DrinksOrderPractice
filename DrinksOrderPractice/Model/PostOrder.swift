//
//  PostOrder.swift
//  DrinksOrderPractice
//
//  Created by Tai Chin Huang on 2021/5/3.
//

import Foundation

struct PostOrder: Codable {
    let data: OrderInfo
}

struct OrderInfo: Codable {
    let orderer: String
    let drinkName: String
    let sizeLevel: String
    let iceLevel: String
    let sugarLevel: String
    let extraToppings: String
    let totalPrice: String
}
