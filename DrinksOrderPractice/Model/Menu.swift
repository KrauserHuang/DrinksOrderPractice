//
//  Menu.swift
//  DrinksOrderPractice
//
//  Created by Tai Chin Huang on 2021/5/4.
//

import Foundation

struct Menu: Codable {
    let feed: Feed
}

struct Feed: Codable {
    let entry: [DrinkData]
}
// 全為自定義，StringType為DrinkData property的下一層，這一層只有gsx$ + property，用CodingKeys去轉換
struct DrinkData: Codable {
    let drink: StringType
    let priceM: StringType
    let priceL: StringType
    let description: StringType
    let imageUrl: StringType
    
    enum CodingKeys: String, CodingKey {
        case drink = "gsx$drink"
        case priceM = "gsx$pricem"
        case priceL = "gsx$pricel"
        case description = "gsx$description"
        case imageUrl = "gsx$imageurl"
    }
}
// StrinType是作為最後的Key，解析到這層就可以抓到需要的資料了
struct StringType: Codable {
    let value: String
    enum CodingKeys: String, CodingKey {
        case value = "$t"
    }
}
