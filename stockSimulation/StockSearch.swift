//
//  StockSearch.swift
//  stockSimulation
//
//  Created by Ariel Cobena on 5/11/21.
//

import Foundation
import Parse

let API_KEY = "OVULR05CBMMN9THU"

var stockResults = [[String:Any]]()

let symbolText = "TSLA"

func stockSearch(symbolText: String) {
    
    let url = URL(string: "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=" + symbolText + "&apikey=" + API_KEY)!
    let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
    let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    let task = session.dataTask(with: request) { (data, response, error) in
         // This will run when the network request returns
         if let error = error {
                print(error.localizedDescription)
         } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                print(dataDictionary)

         }
    }
    task.resume()
    
}

func stockInformation(ticker: String) {
    
    let url = URL(string: "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=" + ticker + "&apikey=" + API_KEY)!
    let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
    let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    let task = session.dataTask(with: request) { (data, response, error) in
         // This will run when the network request returns
         if let error = error {
                print(error.localizedDescription)
         } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                print(dataDictionary)

         }
    }
    task.resume()
    
}
