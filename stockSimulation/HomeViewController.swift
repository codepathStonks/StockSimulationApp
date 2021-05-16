//
//  HomeViewController.swift
//  stockSimulation
//
//  Created by Ariel Cobena on 4/13/21.
//

import UIKit
import Parse
import Charts

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChartViewDelegate {

    @IBOutlet weak var TotalLabel: UILabel!
    @IBOutlet weak var ChangeLabel: UILabel!
    @IBOutlet weak var HomeBalanceLabel: UILabel!
    @IBOutlet weak var HomeWalletImage: UIImageView!
    
    @IBOutlet weak var home_tableView: UITableView!
    
    let API_KEY = "OVULR05CBMMN9THU"
    let API_KEY2 = "97F5BWWWRJDS6L1C"
    let curr_user = PFUser.current()
    var stockResults = [String:Any]()
    var totalChange = 0.0
    var count = 0
    var totalValue = 0.0
    var onOff = false
    
    var allStockPrices = [""]
    var allStockChanges = [""]
    var symbolText = ""
    var tickers = [""]
    let group = DispatchGroup()
    
    var balance = 0.0
    
    //chart
    var lineChart = LineChartView()
    var dataBuffer = [String:Any]()
    var dataBuffer2 = [String:Any]()
    var dataBuffer3 = [String:Any]()
    var oneStockData = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        home_tableView.dataSource = self
        home_tableView.delegate = self
        lineChart.delegate = self
        
        TotalLabel.text = ""
        ChangeLabel.text = ""
        
        var us3r: PFObject!
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
        
        group.enter()
        
        let q2 = PFQuery(className: "Portfolio")
        q2.whereKey("user", equalTo: curr_user!)
        if let portfolio = try? q2.findObjects()
        {
            count = portfolio.count
            if portfolio.count == 0 {
                print("Nothing in portfolio")
                TotalLabel.text = "$0.00"
                ChangeLabel.text = "$0.00"
            }
            else {
                for a in 0...portfolio.count - 1 {
                    let obj = portfolio[a]
                    symbolText = obj["ticker"] as! String
                    tickers.append(symbolText)
                }
            }
        }
        else {
            print("error getting portfolio")
        }
        if count != 0 {
            for b in 1...tickers.count - 1{
                symbolText = tickers[b]
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
                        self.allStockPrices.append(self.stockResults["05. price"] as! String)
                        self.allStockChanges.append(self.stockResults["09. change"] as! String)
                        
                        let change = self.stockResults["09. change"] as! String
                        let c = Double(change)
                        self.totalChange += c!
                        //find individual value of each stock
                        let price = self.stockResults["05. price"]! as! String
                        let p = Double(price)
                        self.totalValue += p!
                        self.home_tableView.reloadData()
                     }
                }
                if b == tickers.count - 1 {
                    self.home_tableView.reloadData()
                    getChartData()
                }
                task.resume()
            }
        }
        group.leave()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let selectionIndexPath = home_tableView.indexPathForSelectedRow{
                self.home_tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
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
        
        //group.notify(queue: .main) {
            //get price
            if self.allStockPrices.count > self.count {
                let p = Double(self.allStockPrices[indexPath.row + 1])
                cell.PriceLabel.text = String(format: "$%.2f", p!)
                let c = Double(self.allStockChanges[indexPath.row + 1])
                if c! < 0 {
                    cell.PriceLabel.textColor = UIColor.red
                }
                else {
                    cell.PriceLabel.textColor = UIColor.green
                }
                self.changeTotalLabel()
                self.changeChangeLabel()
                
                self.viewDidLayoutSubviews()
            }
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        lineChart.frame = CGRect(x: 0, y: 140, width: self.view.frame.width, height: 225)
        view.addSubview(lineChart)
    }
    
    func updateChart() {
        print(oneStockData)
        if oneStockData.count > 1 {
            var entries = [ChartDataEntry]()
            for b in 1...oneStockData.count - 1 {
                entries.append(ChartDataEntry(x: Double(b), y: Double(oneStockData[b])! + balance))
            }
            let set = LineChartDataSet(entries: entries)
            let data = LineChartData(dataSet: set)
            lineChart.data = data
            
            lineChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        }
    }
    
    func getChartData() {
        for b in 1...tickers.count - 1{
            symbolText = tickers[b]
            //symbolText = tickers[1]
            let url = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=" + symbolText + "&interval=5min&apikey=" + API_KEY2)!
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            let task = session.dataTask(with: request) { (data, response, error) in
                 // This will run when the network request returns
                 if let error = error {
                        print(error.localizedDescription)
                 } else if let data = data {
                        let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        print(dataDictionary)
                    self.dataBuffer = dataDictionary["Time Series (5min)"] as! [String : Any]
                    
                    //get last refreshed time and record hour and min for some math
                    self.dataBuffer3 = dataDictionary["Meta Data"] as! [String : Any]
                    let fullDate = self.dataBuffer3["3. Last Refreshed"] as! String
                    print(fullDate)
                    let datePrefix = fullDate.prefix(11)
                    print(datePrefix)
                    let fullTime = fullDate.suffix(8)
                    print(fullTime)
                    let hourMin = fullTime.prefix(5)
                    print(hourMin)
                    let hour = hourMin.prefix(2)
                    print(hour)
                    var hourInt = Int(hour)!
                    let min = hourMin.suffix(2)
                    print(min)
                    var minInt = Int(min)!
                    
                    if hourInt > 16 {
                        hourInt = 16
                        minInt = 0
                    }
                    
    //                //reconstruction of date using modifiable parts
    //                var newDate = ""
    //                if minInt == 0 {
    //                    newDate = datePrefix + String(hourInt) + ":00:00"
    //                }
    //                else {
    //                    newDate = datePrefix + String(hourInt) + ":" + String(minInt) + ":00"
    //                }
    //                print(newDate)
                    
                    //non-Hardcoded retrieval of data
                    for i in 0...9 {
                        var newDate = ""
                        if minInt == 0 {
                            newDate = datePrefix + String(hourInt) + ":00:00"
                        }
                        else {
                            newDate = datePrefix + String(hourInt) + ":" + String(minInt) + ":00"
                        }
                        print(newDate)
                        self.dataBuffer2 = self.dataBuffer[newDate] as! [String : Any]
                        
                        if b == 1 {
                            self.oneStockData.append(self.dataBuffer2["4. close"] as! String)
                        }
                        else {
                            print(b)
                            var tempDouble = Double(self.oneStockData[1 + i])
                            let tempString = self.dataBuffer2["4. close"] as! String
                            tempDouble! += Double(tempString)!
                            self.oneStockData[1 + i] = (String(tempDouble!))
                        }
                        
                        
                        //math for calculating date
                        if minInt == 0 {
                            minInt = 55
                            if hourInt == 1 {
                                hourInt = 12
                            }
                            else {
                                hourInt -= 1
                            }
                        }
                        else {
                            minInt -= 5
                        }
                        print(minInt)
                        print(hourInt)
                    }
                    
    //                //hardcoded retrieval of data
    //                self.dataBuffer2 = self.dataBuffer["2021-05-13 16:00:00"] as! [String : Any]
    //                self.oneStockData.append(self.dataBuffer2["4. close"] as! String)
    //                self.dataBuffer2 = self.dataBuffer["2021-05-13 15:55:00"] as! [String : Any]
    //                self.oneStockData.append(self.dataBuffer2["4. close"] as! String)
    //                self.dataBuffer2 = self.dataBuffer["2021-05-13 15:50:00"] as! [String : Any]
    //                self.oneStockData.append(self.dataBuffer2["4. close"] as! String)
    //                self.dataBuffer2 = self.dataBuffer["2021-05-13 15:45:00"] as! [String : Any]
    //                self.oneStockData.append(self.dataBuffer2["4. close"] as! String)
    //                self.dataBuffer2 = self.dataBuffer["2021-05-13 15:40:00"] as! [String : Any]
    //                self.oneStockData.append(self.dataBuffer2["4. close"] as! String)
    //                self.dataBuffer2 = self.dataBuffer["2021-05-13 15:35:00"] as! [String : Any]
    //                self.oneStockData.append(self.dataBuffer2["4. close"] as! String)
    //                self.dataBuffer2 = self.dataBuffer["2021-05-13 15:30:00"] as! [String : Any]
    //                self.oneStockData.append(self.dataBuffer2["4. close"] as! String)
    //                self.dataBuffer2 = self.dataBuffer["2021-05-13 15:25:00"] as! [String : Any]
    //                self.oneStockData.append(self.dataBuffer2["4. close"] as! String)
    //                self.dataBuffer2 = self.dataBuffer["2021-05-13 15:20:00"] as! [String : Any]
    //                self.oneStockData.append(self.dataBuffer2["4. close"] as! String)
    //                self.dataBuffer2 = self.dataBuffer["2021-05-13 15:15:00"] as! [String : Any]
    //                self.oneStockData.append(self.dataBuffer2["4. close"] as! String)
    //                print(self.oneStockData)
                    self.updateChart()
                 }
            }
            task.resume()
        }
    }
    
    
    var Once = true
    var finalDataPt = ""
    func addFinal() {
        if Once {
            Once = false
            let countT = (TotalLabel.text!.count - 1)
            let final = String((TotalLabel.text?.suffix(countT))!)
            let finalDouble = Double(final)! - balance
            finalDataPt = String(finalDouble)
            if oneStockData.count > 1 {
                oneStockData.append(finalDataPt)
            }
            updateChart()
        }
    }
}




