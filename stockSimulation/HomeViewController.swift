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
    
    let API_KEY = "OVULR05CBMMN9THU"
    let curr_user = PFUser.current()
    var stockResults = [String:Any]()
    var totalChange = 0.0
    var count = 0
    var totalValue = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        home_tableView.dataSource = self
        home_tableView.delegate = self
        
        var us3r: PFObject!
        var balance = 0.0
        let q = PFQuery(className: "users")
        q.whereKey("user", equalTo: curr_user!)
        if let object = try? q.getFirstObject()
        {
            us3r = object
            print("balance retrieved")
            balance = us3r["balance"] as! Double
            self.totalValue = balance
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
        let q = PFQuery(className: "Portfolio")
        q.whereKey("user", equalTo: curr_user!)
        if let portfolio = try? q.findObjects()
        {
            count = portfolio.count
        }
        else {
            print("error getting portfolio")
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var symbolText = ""
        var price = ""
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell") as! homeCell
        
        //Placeholders
        cell.NameLabel.text = ""
        cell.PriceLabel.text = ""
        
        let q = PFQuery(className: "Portfolio")
        q.whereKey("user", equalTo: curr_user!)
        if let portfolio = try? q.findObjects()
        {
            let obj = portfolio[indexPath.row]
            symbolText = obj["ticker"] as! String
            cell.NameLabel.text = symbolText
        }
        else {
            print("error getting portfolio")
        }
        
        let url = URL(string: "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=" + symbolText + "&apikey=" + API_KEY)!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    print(dataDictionary)
                self.stockResults = dataDictionary["Global Quote"] as! [String : Any]
                print(self.stockResults)
                print("-----------------")
                
                //set price label = current price of stock
                price = self.stockResults["05. price"]! as! String
                let p = Double(price)
                cell.PriceLabel.text = String(format: "$%.2f", p!)
                
                //find individual changes of each stock
                let change = self.stockResults["09. change"] as! String
                let c = Double(change)
                if c! < 0 {
                    cell.PriceLabel.textColor = UIColor.red
                }
                else {
                    cell.PriceLabel.textColor = UIColor.green
                }
                
                let group = DispatchGroup()
                group.enter()
                self.totalChange += c!
                print(self.totalChange)
                //find individual value of each stock
                self.totalValue += p!
                print(self.totalValue)
                print(indexPath.row)
                print(self.count)
                group.leave()
                
                if indexPath.row == self.count - 1{
                    self.changeChangeLabel()
                    self.changeTotalLabel()
                    print(self.totalChange)
                    print(self.totalValue)
                }
                

             }
        }
        task.resume()
        
        return cell
    }

    func changeChangeLabel() {
        ChangeLabel.text = String(format: "$%.2f", totalChange)
        if totalChange < 0 {
            ChangeLabel.textColor = UIColor.red
        }
        else {
            ChangeLabel.textColor = UIColor.green
        }
    }
    func changeTotalLabel() {
        TotalLabel.text = String(format: "$%.2f", self.totalValue)
    }
}




