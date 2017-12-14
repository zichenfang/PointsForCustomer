//
//  PointsTransObtainHistoryTableViewCell.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/12/12.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class PointsTransObtainHistoryTableViewCell: UITableViewCell {

    @IBOutlet var userNameLabel: UILabel!//用户名
    @IBOutlet var timeLabel: UILabel!//时间
    @IBOutlet var pointsDesLabel: UILabel!//积分状态描述
    @IBOutlet var pointsLabel: UILabel!//积分值
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func data (obj:PPPointsHistoryObj){
        self.userNameLabel.text = obj.transaction_name;
        self.timeLabel.text = obj.create_time;
        self.pointsLabel.text = obj.num;
        self.pointsDesLabel.text = obj.type;
        if (obj.num?.hasPrefix("-"))! {
            self.pointsLabel.textColor = UIColor.styleRed();
        }
        else{
            self.pointsLabel.textColor = UIColor.init(hexString: "#29D144")
        }
    }
}
