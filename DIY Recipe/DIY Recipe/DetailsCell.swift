//
//  DetailsCell.swift
//  DIY Recipe
//
//  Created by Slarve N. on 3/23/20.
//  Copyright © 2020 Slarve N. All rights reserved.
//

import UIKit

class DetailsCell: UITableViewCell {
    
    @IBOutlet var IngredientName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
