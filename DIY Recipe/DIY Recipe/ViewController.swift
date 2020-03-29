//
//  ViewController.swift
//  DIY Recipe
//
//  Created by Slarve N. on 3/17/20.
//  Copyright © 2020 Slarve N. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet var imageViews: [UIImageView]!
    
    @IBOutlet var image1Title: UILabel!
    @IBOutlet var image2Title: UILabel!
    @IBOutlet var image3Title: UILabel!
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    
    
    var recipe = [RecipeCard]()
    var searchString = ""
    
    var Index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true);
        
        if recipe.count != 0 {
            displayUI() //Call diplay method to display elements from feed data to UI screen
        }
        setUpSearchBar() // Call searchBar delegate method
        AddTapGesturesToImages() // Call function to add tap gestures to my collection of imageViews
        
    }
    
    // Search Bar Functions
// -----------------------------------------------------------------------------------------------------------------------
    func setUpSearchBar() {
        searchBar.delegate = self
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchString = searchText
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        parseSearch()
        searchBar.resignFirstResponder()
        recipe = [RecipeCard]()
    }
    
    // Image tapped selector method
    @IBAction func imageTapped(_ sender: AnyObject ) {
        Index = sender.view.tag
        performSegue(withIdentifier: "GoToDetailsPage", sender: self) // Segue to my Details page
    }
    
    // Parse Function
// -----------------------------------------------------------------------------------------------------------------------
    func parseSearch() {
        
        // Conditional to fix search crash bug when there's multiple search terms
        var newSearchString = ""
        
        if searchString.contains(" ") {
            let split = searchString.split(separator: " ")
            newSearchString = "\(split[0])%20\(split[1])%20\(split[2])"
        } else {
            newSearchString = searchString
        }
        
        
        // Get the recipe that was searched from Tasty API
        let headers = [
            "x-rapidapi-host": "tasty.p.rapidapi.com",
            "x-rapidapi-key": "59d338597cmsh4f789cced9df6a2p1b0e7fjsna39bda851ccd"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://tasty.p.rapidapi.com/recipes/list?tags=under_30_minutes&q=\(newSearchString)&from=0&sizes=0")! as URL,
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
                            self.recipe.append(RecipeCard(name: name, imgString: image, ingredient: arrayOfIngredients, videoUrl: video, numbersArray: numbersArray, instructionsArray: instructionsArray))
                        }
                        
                        DispatchQueue.main.async {
                            // Reset UI everytime parseSearch function is called
                            self.imageViews[0].isHidden = false
                            self.imageViews[1].isHidden = false
                            self.imageViews[2].isHidden = false
                            self.image1Title.isHidden = false
                            self.image2Title.isHidden = false
                            self.image3Title.isHidden = false
                        }
                        
                        // Conditionals to verify if the array element count matches screen maximum recipe cards
                        if self.recipe.count == 0 {
                            DispatchQueue.main.async {
                                self.imageViews[0].isHidden = true
                                self.imageViews[1].isHidden = true
                                self.imageViews[2].isHidden = true

                                self.image1Title.isHidden = true
                                self.image2Title.isHidden = true
                                self.image3Title.isHidden = true
                                
                                // Diplay some message if the recipe searched is not found
                                let message: String = "Not Found!!"
                                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                self.present(alertController, animated: true)
                            }
                        }
                        else if (self.recipe.count == 1) {
                            DispatchQueue.main.async {
                                self.imageViews[0].image = self.recipe[0].img
                                self.imageViews[1].isHidden = true
                                self.imageViews[2].isHidden = true

                                self.image1Title.text = self.recipe[0].name
                                self.image2Title.isHidden = true
                                self.image3Title.isHidden = true
                            }
                        }
                        else if (self.recipe.count == 2) {
                            DispatchQueue.main.async {
                                self.imageViews[0].image = self.recipe[0].img
                                self.imageViews[1].image = self.recipe[1].img
                                self.imageViews[2].isHidden = true

                                self.image1Title.text = self.recipe[0].name
                                self.image2Title.text = self.recipe[1].name
                                self.image3Title.isHidden = true
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                self.imageViews[0].image = self.recipe[0].img
                                self.imageViews[1].image = self.recipe[1].img
                                self.imageViews[2].image = self.recipe[2].img

                                self.image1Title.text = self.recipe[0].name
                                self.image2Title.text = self.recipe[1].name
                                self.image3Title.text = self.recipe[2].name
                            }
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

    // displayUI Function
// -----------------------------------------------------------------------------------------------------------------------
    func displayUI() {
        DispatchQueue.main.async {
            self.imageViews[0].image = self.recipe[0].img
            self.imageViews[1].image = self.recipe[1].img
            self.imageViews[2].image = self.recipe[2].img

            self.image1Title.text = self.recipe[0].name
            self.image2Title.text = self.recipe[1].name
            self.image3Title.text = self.recipe[2].name
        }
    }
    // Add gestures to all image views in my imageViews collection
// -----------------------------------------------------------------------------------------------------------------------
    func AddTapGesturesToImages() {
        for view in self.imageViews {
            // hide images
            view.image = UIImage(named: " ")
            // define the gesture
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
            // assign the gesture to the imageView
            view.addGestureRecognizer(gesture)
            // enable user interaction to item
            view.isUserInteractionEnabled = true
        }
    }
    // Prepare for segue method
 // -----------------------------------------------------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? DetailsViewController {
            destination.recipe = recipe[Index] // send one recipe card object to DetailsViewController based on the user's selection
        }
    }
    
}

