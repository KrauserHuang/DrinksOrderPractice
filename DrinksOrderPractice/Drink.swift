//
//  Drink.swift
//  DrinksOrderPractice
//
//  Created by Tai Chin Huang on 2021/5/3.
//

import Foundation

struct Drink: Decodable {
    var name: String
    var price: Int
}


func fetchItem() {
    let url = Bundle.main.url(forResource: "naptea", withExtension: "plist")!
    if let data = try? Data(contentsOf: url) {
        let drink = try? PropertyListDecoder().decode([Drink].self, from: data)
        print(drink!)
    }
}
