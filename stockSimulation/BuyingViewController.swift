//
//  BuyingViewController.swift
//  stockSimulation
//
//  Created by Leyla Tuon on 5/1/21.
//

import UIKit
import Parse


class BuyingViewController: UIViewController {
    @IBOutlet weak var TickerLabel: UILabel!
    @IBOutlet weak var TickerImage: UIImageView!
    @IBOutlet weak var CostLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    @IBOutlet weak var QuantityField: UITextField!
    
    let curr_user = PFUser.current()
    var priceForStock = 0.00
    var stockName = String()
    var balance = 0.00
    var ticker = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TickerLabel.text = stockName
        //CostLabel.text = "$" + String(priceForStock)
        CostLabel.text = String(format: "$%.2f", priceForStock)
        balanceLabel.text = "$" + String(balance)
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func CalculatePrice(_ sender: Any) {
        let quantity = Double(QuantityField.text!) ?? 0
        if(quantity>0)
        {
            //CostLabel.text = "$" + String(quantity * priceForStock)
            let buffer = quantity * priceForStock
            CostLabel.text = String(format: "$%.2f", buffer)
        }
        else {
            CostLabel.text = String(format: "$%.2f", priceForStock)
        }
    }
    
    @IBAction func onConfirm(_ sender: Any) {
        let quantity = Double(QuantityField.text!) ?? 0
        let currPortfolio = PFObject(className: "Portfolio")
        
        let totalPrice = quantity * Double(priceForStock)
        
        if(balance>=totalPrice){
            let q2 = PFQuery(className: "Portfolio")
            q2.whereKey("user", equalTo: curr_user!)
            q2.whereKey("ticker", equalTo: stockName)
            if let portfolio = try? q2.findObjects()
            {
                //create new object
                let count = portfolio.count
                if portfolio.count == 0  && quantity > 0{
                    print("Nothing in portfolio")
                    currPortfolio["user"] = PFUser.current()!
                    currPortfolio["ticker"] = ticker
                    currPortfolio["quantity"] = quantity
                    currPortfolio["price_bought_at"] = priceForStock
                    currPortfolio["date_bought_at"] = Date()
                let q = PFQuery(className: "users")
                q.whereKey("user", equalTo: curr_user!)
                if let object = try? q.findObjects()
                {
                    print("balance retrieved")
                    var obj2 = object[0]
                    var newBalance = obj2["balance"] as! Double
                    newBalance -= totalPrice
                    obj2["balance"] = newBalance
                }
                    
                    currPortfolio.saveInBackground { (success, error) in
                    if success {
                        print("saved tester portfolio")
                        
                    }
                    else {
                        print ("error tester portfolio")
                    }
                    }
                }
                else {
                //get first object
                    var obj = portfolio[0]
                    var qty = obj["quantity"] as! Int
                    qty += Int(quantity)
                    obj["quantity"] = qty
                    obj.saveInBackground()
                    
                    let q = PFQuery(className: "users")
                    q.whereKey("user", equalTo: curr_user!)
                    if let object = try? q.findObjects()
                    {
                        print("balance retrieved")
                        var obj2 = object[0]
                        var newBalance = obj2["balance"] as! Double
                        newBalance -= totalPrice
                        obj2["balance"] = newBalance
                        obj2.saveInBackground()
                    }
                }
                print(portfolio.count)
                for object in portfolio{
                    print(object)
                }
                
                
                //_ = navigationController?.popViewController(animated: true)
                _ = navigationController?.popToRootViewController(animated: true)
            }
            else{
                print("can't buy")
            }
            }
            else {
                print("error getting portfolio")
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
