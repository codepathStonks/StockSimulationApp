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
    
    var ticker = String()
    var priceForStock = String()
    var stockName = String()
    
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
                print(dataDictionary)
             }
        }
        task.resume()
    
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
