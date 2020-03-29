//
//  FavoritesViewController.swift
//  DIY Recipe
//
//  Created by Slarve N. on 3/27/20.
//  Copyright © 2020 Slarve N. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet var userEmail: UILabel!
    
    @IBOutlet var imageViews: [UIImageView]!
    @IBOutlet var imageViewTitles: [UILabel]!
    
    var favoriteRecipes = [RecipeCard]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        displayUI()
    }
    
    // displayUI Function
// -----------------------------------------------------------------------------------------------------------------------
    func displayUI() {
        
        if favoriteRecipes.count == 0 {
            imageViews[0].isHidden = true
            imageViews[1].isHidden = true
            imageViews[2].isHidden = true
            imageViews[3].isHidden = true

            imageViewTitles[0].isHidden = true
            imageViewTitles[1].isHidden = true
            imageViewTitles[2].isHidden = true
            imageViewTitles[3].isHidden = true
        }
        else if (favoriteRecipes.count == 1) {
            imageViews[0].image = favoriteRecipes[0].img
            imageViews[1].isHidden = true
            imageViews[2].isHidden = true
            imageViews[3].isHidden = true

            imageViewTitles[0].text = favoriteRecipes[0].name
            imageViewTitles[1].isHidden = true
            imageViewTitles[2].isHidden = true
            imageViewTitles[3].isHidden = true
        }
        else if (favoriteRecipes.count == 2) {
            imageViews[0].image = favoriteRecipes[0].img
            imageViews[1].image = favoriteRecipes[1].img
            imageViews[2].isHidden = true
            imageViews[3].isHidden = true

            imageViewTitles[0].text = favoriteRecipes[0].name
            imageViewTitles[1].text = favoriteRecipes[1].name
            imageViewTitles[2].isHidden = true
            imageViewTitles[3].isHidden = true
        }
        else if (favoriteRecipes.count == 3) {
            imageViews[0].image = favoriteRecipes[0].img
            imageViews[1].image = favoriteRecipes[1].img
            imageViews[2].image = favoriteRecipes[2].img
            imageViews[3].isHidden = true

            imageViewTitles[0].text = favoriteRecipes[0].name
            imageViewTitles[1].text = favoriteRecipes[1].name
            imageViewTitles[2].text = favoriteRecipes[2].name
            imageViewTitles[3].isHidden = true
        }
        else {
            imageViews[0].image = favoriteRecipes[0].img
            imageViews[1].image = favoriteRecipes[1].img
            imageViews[2].image = favoriteRecipes[2].img
            imageViews[3].image = favoriteRecipes[3].img

            imageViewTitles[0].text = favoriteRecipes[0].name
            imageViewTitles[1].text = favoriteRecipes[1].name
            imageViewTitles[2].text = favoriteRecipes[2].name
            imageViewTitles[3].text = favoriteRecipes[3].name
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
