//
//  OrderListTableViewCell.swift
//  DrinksOrderPractice
//
//  Created by Tai Chin Huang on 2021/5/8.
//

import UIKit

class OrderListTableViewCell: UITableViewCell {

    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var orderInfoLabel: UILabel!
    @IBOutlet weak var ordererLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
