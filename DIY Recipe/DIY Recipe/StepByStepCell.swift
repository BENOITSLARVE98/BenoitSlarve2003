//
//  StepByStepCell.swift
//  DIY Recipe
//
//  Created by Slarve N. on 3/25/20.
//  Copyright © 2020 Slarve N. All rights reserved.
//

import UIKit

class StepByStepCell: UITableViewCell {

    @IBOutlet var stepNumber: UILabel!
    //@IBOutlet var instructionText: UITextView!
    @IBOutlet var instructionText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //instructionText.delegate = self
        //instructionText.translatesAutoresizingMaskIntoConstraints = false
        //stepNumber.translatesAutoresizingMaskIntoConstraints = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
