//
//  SearchViewController.swift
//  stockSimulation
//
//  Created by Ariel Cobena on 4/14/21.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
        
    var stockResults = [[String:Any]]()

    let symbolText = "Apple"

    func stockSearch(symbolText: String) {
        
        let url = URL(string: "https://ticker-2e1ica8b9.now.sh//keyword/" + symbolText)!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
                
                print("Printing dataDictionary")
                print(dataDictionary)
                
                self.stockResults = dataDictionary as! [[String:Any]]
                
                self.tableView.reloadData()
                
             }
        }
        
        
        task.resume()

    }
    
    @IBOutlet weak var tickerSearch: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        stockSearch(symbolText: "Tesla")
        
        tickerSearch.delegate = self

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(stockResults.count)
        return stockResults.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as! SearchTableViewCell
        
        let company = stockResults[indexPath.row]
        let companyName = company["name"] as! String
        let companyTicker = company["symbol"] as! String
        
        cell.companyName.text = companyName
        cell.companyTicker.text = companyTicker
        
        return cell
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        stockSearch(symbolText: searchBar.text!)
    }

}
