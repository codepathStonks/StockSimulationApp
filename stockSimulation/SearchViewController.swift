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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
