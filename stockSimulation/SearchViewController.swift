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
    
    var stockData = [String:Any]()

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
        
        stockSearch(symbolText: "A")
        
        tickerSearch.delegate = self

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let stockTicker = stockResults[indexPath.row]
        let ticker = stockTicker["symbol"] as! String
        
        let detailsViewController = segue.destination as! StockDetailsViewController
        
        
        
        detailsViewController.ticker = ticker
        detailsViewController.stockName = stockTicker["name"] as! String
        
    }

}
