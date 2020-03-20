//
//  ViewController.swift
//  DIY Recipe
//
//  Created by Slarve N. on 3/17/20.
//  Copyright © 2020 Slarve N. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet var imageView1: UIImageView!
    @IBOutlet var imageView2: UIImageView!
    @IBOutlet var imageView3: UIImageView!
    
    @IBOutlet var image1Title: UILabel!
    
    var recipe = [RecipeCard]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Call parsing method
        parse()
    }
    
    
    func parse() {
        
        // 3 Latest feeds API
        let headers = [
            "x-rapidapi-host": "tasty.p.rapidapi.com",
            "x-rapidapi-key": "59d338597cmsh4f789cced9df6a2p1b0e7fjsna39bda851ccd"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://tasty.p.rapidapi.com/feeds/list?size=3&timezone=%252B0700&vegetarian=false&from=3")! as URL,
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

                    for firstLevelItem in json {
                        guard let result = firstLevelItem.value as? [[String: Any]]
                            else { return
                        }
                        
                        for child in result {
                            guard let item = child["item"] as? [String: Any],
                                  let name = item["name"] as? String,
                                  let image = item["thumbnail_url"] as? String
                                else { return
                            }
                            self.recipe.append(RecipeCard(name: name, imgString: image))
                        }
                        
                        DispatchQueue.main.async {
                            self.imageView1.image = self.recipe[0].img
                            self.imageView2.image = self.recipe[1].img
                            self.imageView3.image = self.recipe[2].img
                            
                            self.image1Title.text = self.recipe[0].name
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
    
    
}
