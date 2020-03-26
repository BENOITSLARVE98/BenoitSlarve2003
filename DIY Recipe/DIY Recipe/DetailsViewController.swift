//
//  DetailsViewController.swift
//  DIY Recipe
//
//  Created by Slarve N. on 3/21/20.
//  Copyright © 2020 Slarve N. All rights reserved.
//

import UIKit
import AVKit

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var name: UILabel!
    @IBOutlet var VideoImage: UIImageView!
    
    var RecipeArray = [RecipeCard]()
    var recipe: RecipeCard!
    var Ingredients = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        name.text = recipe.name
        VideoImage.image = recipe.img

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return Ingredients.count
        return recipe.ingredient.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_ID", for: indexPath) as? DetailsCell
        else{return tableView.dequeueReusableCell(withIdentifier: "Cell_ID", for: indexPath)}
        
        // Configure the cell...
        //cell.IngredientName.text = Ingredients[indexPath.row]
        cell.IngredientName.text = recipe.ingredient[indexPath.row]
        
        return cell
    }

    @IBAction func playVideo(_ sender: Any) {
        videoPlayer()
    }
    
    func videoPlayer() {
        let videoUrl = URL(string: recipe.videoUrl)
        let player = AVPlayer(url: videoUrl!)
        let vc = AVPlayerViewController()
        vc.player = player

        present(vc, animated: true) {
            vc.player?.play()
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let destination = segue.destination as? TableViewController {
            destination.numbers = recipe.numbersArray
            destination.instructions = recipe.instructionsArray
        }
        
    }

}
