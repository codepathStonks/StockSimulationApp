//
//  GuideViewController.swift
//  stockSimulation
//
//  Created by JC on 5/16/21.
//

import UIKit

class GuideViewController: UIViewController {

    @IBOutlet weak var beginnerGuide: UIButton!
    @IBOutlet weak var options: UIButton!
    @IBOutlet weak var crypto: UIButton!
    @IBOutlet weak var advice: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onGuide(_ sender: Any) {
        if let url = URL(string: "https://www.thebalance.com/the-complete-beginner-s-guide-to-investing-in-stock-358114") {
        UIApplication.shared.open(url)
        }
    }
    @IBAction func onOption(_ sender: Any) {
        if let url = URL(string: "https://www.investopedia.com/options-basics-tutorial-4583012") {
        UIApplication.shared.open(url)
        }
    }
    @IBAction func onCrypto(_ sender: Any) {
        if let url = URL(string: "https://academy.binance.com/en/articles/a-complete-guide-to-cryptocurrency-trading-for-beginners") {
        UIApplication.shared.open(url)
        }
    }
    @IBAction func onAdvice(_ sender: Any) {
        if let url = URL(string: "https://www.forbes.com/sites/laurashin/2013/10/29/10-investing-tricks-that-will-help-you-outperform-most-investors/?sh=623cdb816f01") {
        UIApplication.shared.open(url)
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
