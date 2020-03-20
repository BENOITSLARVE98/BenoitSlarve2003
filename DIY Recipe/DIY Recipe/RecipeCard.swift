//
//  RecipeCard.swift
//  DIY Recipe
//
//  Created by Slarve N. on 3/19/20.
//  Copyright © 2020 Slarve N. All rights reserved.
//

import Foundation
import UIKit

class RecipeCard {
    
    //properties
    var name: String
    var img: UIImage!

    /* Initializers */
    init(name: String, imgString: String) {
        self.name = name

        //Our init will take care of dowloading the image
        if let url = URL(string: imgString) {

            do {
                let data = try Data(contentsOf: url)
                self.img = UIImage(data: data)
            }
            catch  {

            }
        }
    }
    
}
