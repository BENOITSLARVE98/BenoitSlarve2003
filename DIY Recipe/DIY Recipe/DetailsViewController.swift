//
//  DetailsViewController.swift
//  DIY Recipe
//
//  Created by Slarve N. on 3/21/20.
//  Copyright © 2020 Slarve N. All rights reserved.
//

import UIKit
import AVKit
import FirebaseDatabase
import FirebaseAuth

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var name: UILabel!
    @IBOutlet var VideoImage: UIImageView!
    
    var recipeSaved = [RecipeCard]()
    var searchString = ""
    
    var recipe: RecipeCard!
    var favoriteRecipes = [RecipeCard]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        name.text = recipe.name
        VideoImage.image = recipe.img
        parseSearch()
    }
    
    // Table View Functions setup
// -----------------------------------------------------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe.ingredient.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_ID", for: indexPath) as? DetailsCell
        else{return tableView.dequeueReusableCell(withIdentifier: "Cell_ID", for: indexPath)}
        
        // Configure the cell...
        cell.IngredientName.text = recipe.ingredient[indexPath.row]
        
        return cell
    }

    // Video Player Integration Functions
// -----------------------------------------------------------------------------------------------------------------------
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

    // Add Favorites Function
// -----------------------------------------------------------------------------------------------------------------------
    @IBAction func addToFavorites(_ sender: Any) {
        
        let user = Auth.auth().currentUser
        let uid = user?.uid
        
        let recipeRef = Database.database().reference().child("Recipes").child(uid!)
        
        let recipeObjectDict = [
            "name" : recipe.name
        ]
        //Save data
        recipeRef.setValue(recipeObjectDict, withCompletionBlock: { error, ref in
            if error == nil {
            
            } else {
            
            }
        })
        
        //Read data
        recipeRef.observe(DataEventType.value, with: { (snapshot) in
            let recipe = snapshot.value as! [String: String] ?? [:]
          // ...
            if snapshot.exists() {
                self.searchString = recipe["name"]!
            }
        })
        
        
    }
    
        // Parse Function
    // -----------------------------------------------------------------------------------------------------------------------
        func parseSearch() {
            
            // Get the recipe that was searched from Tasty API
            let headers = [
                "x-rapidapi-host": "tasty.p.rapidapi.com",
                "x-rapidapi-key": "59d338597cmsh4f789cced9df6a2p1b0e7fjsna39bda851ccd"
            ]

            let request = NSMutableURLRequest(url: NSURL(string: "https://tasty.p.rapidapi.com/recipes/list?tags=under_30_minutes&q=\(searchString)&from=0&sizes=0")! as URL,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error!)
                }

                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200,
                    let data = data
                    else { return }

                do {
                    //De-Serialize data object
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {

                        var arrayOfIngredients = [String]()
                        
                        for firstLevelItem in json {
                            guard let result = firstLevelItem.value as? [[String: Any]]
                                else { continue
                            }
                            
                            for child in result {
                                guard let name = child["name"] as? String,
                                      let image = child["thumbnail_url"] as? String,
                                      let video = child["original_video_url"] as? String,
                                      let instructions = child["instructions"] as? [[String: Any]],
                                      let sections = child["sections"] as? [[String: Any]]
                                    else { continue
                                }
                                
                                var numbersArray = [Int]()
                                var instructionsArray = [String]()
                                for item in instructions {
                                    guard let stepNumber = item["position"] as? Int,
                                          let instructionText = item["display_text"] as? String
                                        else { continue
                                    }
                                    numbersArray.append(stepNumber)
                                    instructionsArray.append(instructionText)
                                }
                                
                                for item in sections {
                                    guard let components = item["components"] as? [[String: Any]]
                                        else { continue
                                    }
                                    for item in components {
                                        let ingredient = item["raw_text"] as? String
                                        arrayOfIngredients.append(ingredient ?? "")
                                    }
                                }
                                
                                //Append elements to recipe array
                                self.recipeSaved.append(RecipeCard(name: name, imgString: image, ingredient: arrayOfIngredients, videoUrl: video, numbersArray: numbersArray, instructionsArray: instructionsArray))
                            }
                            
                        }
                    }

                }
                catch {
                    print(error.localizedDescription)
                    //assertionFailure();
                }
            })
            dataTask.resume()
        }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "stepByStep" {
            if let destination = segue.destination as? TableViewController {
                destination.numbers = recipe.numbersArray
                destination.instructions = recipe.instructionsArray
            }
        } else if segue.identifier == "favorites" {
            if let destination = segue.destination as? FavoritesViewController {
                destination.favoriteRecipes = recipeSaved
            }
        }

        
    }

}
