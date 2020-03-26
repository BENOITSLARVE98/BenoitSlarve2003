//
//  ViewController.swift
//  DIY Recipe
//
//  Created by Slarve N. on 3/17/20.
//  Copyright © 2020 Slarve N. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet var imageViews: [UIImageView]!
    
    @IBOutlet var image1Title: UILabel!
    @IBOutlet var image2Title: UILabel!
    @IBOutlet var image3Title: UILabel!
    
    @IBOutlet var searchBar: UISearchBar!
    
    var recipe = [RecipeCard]()
    var recipeSearchArray = [RecipeCard]()
    var searchString = ""
    
    var Index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Call parsing method
        //parseFeed()
        setUpSearchBar()
        AddTapGesturesToImages()
    }
    
    //Search Bar
    func setUpSearchBar() {
        searchBar.delegate = self
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchString = searchText
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        parseSearch()
        searchBar.resignFirstResponder()
        recipeSearchArray = [RecipeCard]()
    }

    @IBAction func imageTapped(_ sender: AnyObject ) {
        performSegue(withIdentifier: "GoToDetailsPage", sender: self)
    }
    
    func parseSearch() {
        
        // 3 Latest feeds API
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
                            
                            self.recipeSearchArray.append(RecipeCard(name: name, imgString: image, ingredient: arrayOfIngredients, videoUrl: video, numbersArray: numbersArray, instructionsArray: instructionsArray))
                        }
                        DispatchQueue.main.async {
                            self.imageViews[0].image = self.recipeSearchArray[0].img
                            self.imageViews[1].image = self.recipeSearchArray[1].img
                            self.imageViews[2].image = self.recipeSearchArray[2].img

                            self.image1Title.text = self.recipeSearchArray[0].name
                            self.image2Title.text = self.recipeSearchArray[1].name
                            self.image3Title.text = self.recipeSearchArray[2].name
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
    
    func parseFeed() {
        
        
        // 3 Latest feeds API
        let headers = [
            "x-rapidapi-host": "tasty.p.rapidapi.com",
            "x-rapidapi-key": "59d338597cmsh4f789cced9df6a2p1b0e7fjsna39bda851ccd"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://tasty.p.rapidapi.com/feeds/list?size=5&timezone=%252B0700&vegetarian=false&from=3")! as URL,
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
                            guard let item = child["item"] as? [String: Any],
                                  let name = item["name"] as? String,
                                  let image = item["thumbnail_url"] as? String,
                                  let video = child["original_video_url"] as? String,
                                  let sections = item["sections"] as? [[String: Any]]
                                else { continue
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
                            
                            //self.recipe.append(RecipeCard(name: name, imgString: image, ingredient: arrayOfIngredients,videoUrl: video))
                        }
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
            catch {
                print(error.localizedDescription)
                //assertionFailure();
            }
        })
        dataTask.resume()
    }
    
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? DetailsViewController {
            //destination.Ingredients = recipeSearchArray[0].ingredient
            destination.recipe = recipeSearchArray[0]
        }
    }
    
}

