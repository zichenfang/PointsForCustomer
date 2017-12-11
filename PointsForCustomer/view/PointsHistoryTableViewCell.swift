//
//  PointsHistoryTableViewCell.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/10/8.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class PointsHistoryTableViewCell: UITableViewCell {

    @IBOutlet var shopNameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var xiaofeiPointsLabel: UILabel!//消费积分
    @IBOutlet var huodePointsLabel: UILabel!//获得积分
    @IBOutlet var huodePointsLabel: UILabel!//获得积分
    @IBOutlet var stateLabel: UILabel!//状态

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func data (obj:PPPointsHistoryObj){
        self.shopNameLabel.text = obj.transaction_name
        self.timeLabel.text = obj.create_time
        self.pointsDesLabel.text = obj.type
        self.valueLabel.text = obj.num
        if (obj.num?.hasPrefix("+"))! {
            valueLabel.textColor = UIColor.styleRed()
        }
        else{
            valueLabel.textColor = UIColor.styleGreen()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
