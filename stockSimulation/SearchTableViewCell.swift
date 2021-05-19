//
//  SearchTableViewCell.swift
//  stockSimulation
//
//  Created by Ariel Cobena on 5/19/21.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var companyTicker: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
