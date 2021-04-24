//
//  homeCell.swift
//  stockSimulation
//
//  Created by JC on 4/23/21.
//

import UIKit

class homeCell: UITableViewCell {

    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var LogoImage: UIImageView!
    @IBOutlet weak var PriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
