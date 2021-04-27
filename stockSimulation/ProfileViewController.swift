//
//  ProfileViewController.swift
//  stockSimulation
//
//  Created by Ariel Cobena on 4/14/21.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {

    @IBOutlet weak var LabelUsernameLabel: UILabel!
    @IBOutlet weak var BalanceLabel: UILabel!
    @IBOutlet weak var UsernameLabel: UILabel!
    @IBOutlet weak var WalletImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UsernameLabel.text = PFUser.current()?.username
        
        var us3r: PFObject!
        var balance = 0.0
        let curr_user = PFUser.current()
        let q = PFQuery(className: "users")
        q.whereKey("user", equalTo: curr_user!)
//        q.findObjectsInBackground { (obj, error) in
//            if error == nil {
//                self.balance = obj![0]["balance"] as! Double
//                print("success")
//            }
//            else {
//                print("error")
//            }
//        }
        if let object = try? q.getFirstObject()
        {
            us3r = object
            print("success")
            balance = us3r["balance"] as! Double
        }
        BalanceLabel.text = "$"
        BalanceLabel.text?.append(String(balance)) 
        
        // Do any additional setup after loading the view.
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
