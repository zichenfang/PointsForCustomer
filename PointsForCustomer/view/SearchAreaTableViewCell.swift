//
//  SearchAreaTableViewCell.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/22.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class SearchAreaTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
