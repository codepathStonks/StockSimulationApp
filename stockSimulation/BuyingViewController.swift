//
//  BuyingViewController.swift
//  stockSimulation
//
//  Created by Leyla Tuon on 5/1/21.
//

import UIKit

class BuyingViewController: UIViewController {
    @IBOutlet weak var TickerLabel: UILabel!
    @IBOutlet weak var TickerImage: UIImageView!
    @IBOutlet weak var CostLabel: UILabel!
    
    @IBOutlet weak var QuantityField: UITextField!
    @IBAction func onConfirm(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
