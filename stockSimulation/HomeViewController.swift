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
