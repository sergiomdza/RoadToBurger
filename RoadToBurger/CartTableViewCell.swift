//
//  CartTableViewCell.swift
//  RoadToBurger
//
//  Created by Ingenieria on 13/06/22.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var imagen1: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productQuant: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
