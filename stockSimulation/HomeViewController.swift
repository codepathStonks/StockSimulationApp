//
//  HomeViewController.swift
//  stockSimulation
//
//  Created by Ariel Cobena on 4/13/21.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var TotalLabel: UILabel!
    @IBOutlet weak var ChangeLabel: UILabel!
    @IBOutlet weak var HomeBalanceLabel: UILabel!
    @IBOutlet weak var HomeWalletImage: UIImageView!
    
    @IBOutlet weak var home_tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        home_tableView.dataSource = self
        home_tableView.delegate = self
        
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
            print("balance retrieved")
            balance = us3r["balance"] as! Double
        }
        HomeBalanceLabel.text = "$"
        HomeBalanceLabel.text?.append(String(balance))
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(identifier: "LoginViewController")
        
        let delegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        delegate.window?.rootViewController = loginViewController
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell") as! homeCell
        //test
        cell.NameLabel.text = "Company A"
        cell.PriceLabel.text = "$96"
        return cell
    }
}
