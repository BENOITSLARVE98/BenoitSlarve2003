//
//  SignUpViewController.swift
//  DIY Recipe
//
//  Created by Slarve N. on 3/27/20.
//  Copyright © 2020 Slarve N. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        let signUpManager = AuthManager()
        if let email = email.text, let password = password.text {
            signUpManager.createUser(email: email, password: password) {[weak self] (success) in
                guard let `self` = self else { return }
                var message: String = ""
                if (success) {
                    self.performSegue(withIdentifier: "signUp", sender: self)
                } else {
                    message = "Invalid email."
                }
                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertController, animated: true)
            }
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
