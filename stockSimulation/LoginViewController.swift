//
//  LoginViewController.swift
//  stockSimulation
//
//  Created by Ariel Cobena on 4/13/21.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        
        let username = usernameField.text!
        let password = passwordField.text!
        
        let portfolio = PFObject(className: "Portfolios") //move to buying and selling
        portfolio["user"] = "user" //PFUser.current()!
        portfolio["ticker"] = "ticker"
        portfolio["quantity"] = 0
        portfolio["date_bought_at"] = Date()
        portfolio["price_bought_at"] = 0.00
        
        portfolio.saveInBackground { (success, error) in
            if success {
                print("saved tester portfolio")
            }
            else {
                print ("error tester portfolio")
            }
        }
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if(user != nil) {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    @IBAction func onSignUp(_ sender: Any) {
    
        let user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
       
        
        
        user.signUpInBackground { (success, error) in
            if(success) {
                
                //set initial balance to 1000
                let curr_user = PFUser.current()
                let start: Double
                start = 1000.0
                let a = PFObject(className: "users")
                a["balance"] = start
                a["user"] = curr_user
                a.saveInBackground { (success, error) in
                    if success { print("balance saved")
                    }
                    else {
                        print("balance not saved")
                    }
                }
 
                
                //move to home screen
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
}
