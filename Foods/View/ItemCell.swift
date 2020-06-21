//
//  ItemCell.swift
//  Foods
//
//  Created by bennoui ihab on 5/19/20.
//  Copyright © 2020 bennoui ihab. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    @IBOutlet weak var itemImageView : UIImageView!
    @IBOutlet weak var itemNameLbl : UILabel!
    @IBOutlet weak var itemPriceLbl : UILabel!
    
    func configureCell(item : Item){
        itemImageView.image = item.image
        itemNameLbl.text = item.name
        itemPriceLbl.text = String(describing : item.price)
    }
}
