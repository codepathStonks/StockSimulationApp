//
//  SearchViewController.swift
//  stockSimulation
//
//  Created by Ariel Cobena on 4/14/21.
//

import UIKit

class SearchViewController: UIViewController {
    
    let API_KEY = "OVULR05CBMMN9THU"
    
    var stockResults = [[String:Any]]()
    
    let symbolText = "TSLA"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stockInformation(ticker: symbolText)
        stockSearch(symbolText: "Tesla")
        // Do any additional setup after loading the view.
    }
    
    
//    func stockSearch(symbolText: String) {
//
//        let url = URL(string: "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=" + symbolText + "&apikey=" + API_KEY)!
//        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
//        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
//        let task = session.dataTask(with: request) { (data, response, error) in
//             // This will run when the network request returns
//             if let error = error {
//                    print(error.localizedDescription)
//             } else if let data = data {
//                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
//
//                    print(dataDictionary)
//
//             }
//        }
//        task.resume()
//
//    }
//
//    func stockInformation(ticker: String) {
//
//        let url = URL(string: "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=" + ticker + "&apikey=" + API_KEY)!
//        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
//        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
//        let task = session.dataTask(with: request) { (data, response, error) in
//             // This will run when the network request returns
//             if let error = error {
//                    print(error.localizedDescription)
//             } else if let data = data {
//                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
//
//                    print(dataDictionary)
//
//             }
//        }
//        task.resume()
//
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
