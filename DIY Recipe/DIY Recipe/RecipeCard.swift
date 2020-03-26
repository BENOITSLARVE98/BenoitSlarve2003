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
    var videoUrl: String
    var numbersArray: [Int]!
    var instructionsArray: [String]!
    var ingredient: [String]

    /* Initializers */
    init(name: String, imgString: String, ingredient: [String], videoUrl: String, numbersArray: [Int], instructionsArray: [String]!) {
        self.name = name
        self.ingredient = ingredient
        self.videoUrl = videoUrl
        self.numbersArray = numbersArray
        self.instructionsArray = instructionsArray
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
