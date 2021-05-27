//
//  StockDetailsViewController.swift
//  stockSimulation
//
//  Created by Leyla Tuon on 5/1/21.
//

import UIKit

class StockDetailsViewController: UIViewController {
    @IBOutlet weak var TickerLabel: UILabel!
    @IBOutlet weak var CostLabel: UILabel!
    @IBOutlet weak var TickerImage: UIImageView!
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var changePercentLabel: UILabel!

    
    var ticker = String()
    var priceForStock = String()
    var stockName = String()
    var balance = 0.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=" + ticker + "&apikey=" + API_KEY)!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { [self] (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                let dataQuote = dataDictionary["Global Quote"] as! [String:Any]
                let dataPrice = dataQuote["05. price"] as! String
                priceForStock = dataPrice

                TickerLabel.text = stockName
                CostLabel.text = "$" + priceForStock
                balanceLabel.text = "$" + String(balance)
                
                let dataLow = dataQuote["04. low"] as! String
                lowLabel.text = "$" + dataLow
                
                let dataHigh = dataQuote["03. high"] as! String
                highLabel.text = "$" + dataHigh
                
                let dataChange = dataQuote["09. change"] as! String
                changeLabel.text = "$" + dataChange
                
                let dataChangePercent = dataQuote["10. change percent"] as! String
                changePercentLabel.text = dataChangePercent
                
                print(dataDictionary)
             }
        }
        task.resume()
    
        // Do any additional setup after loading the view.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let detailsViewController = segue.destination as! BuyingViewController
        
        detailsViewController.stockName = stockName
        detailsViewController.priceForStock = Double(priceForStock)!
        detailsViewController.balance = balance
        detailsViewController.ticker = ticker
        
//        let sellingViewController = segue.destination as! SellingViewController
//
//        sellingViewController.stockName = stockName
//        sellingViewController.priceForStock = Double(priceForStock)!
//        sellingViewController.balance = balance
//        sellingViewController.ticker = ticker
    }

}
