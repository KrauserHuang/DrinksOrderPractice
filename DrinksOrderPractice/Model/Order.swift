//
//  Order.swift
//  DrinksOrderPractice
//
//  Created by Tai Chin Huang on 2021/5/3.
//

import Foundation

class Order {
    var drinkName: String?
    var sizeLevel: SizeLevel?
    var iceLevel: IceLevel?
    var sugarLevel: SugarLevel?
    var extraToppings: ExtraToppings?
    var totalPrice: Int?
    
    init(drinkName: String?,
         sizeLevel: SizeLevel?,
         iceLevel: IceLevel?,
         sugarLevel: SugarLevel?,
         extraToppings: ExtraToppings?,
         totalPrice: Int?) {
        self.drinkName = drinkName
        self.sizeLevel = sizeLevel
        self.iceLevel = iceLevel
        self.sugarLevel = sugarLevel
        self.extraToppings = extraToppings
        self.totalPrice = totalPrice
    }
}
