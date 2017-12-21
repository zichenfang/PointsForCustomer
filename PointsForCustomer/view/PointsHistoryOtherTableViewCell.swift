//
//  PointsHistoryOtherTableViewCell.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/12/20.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class PointsHistoryOtherTableViewCell: UITableViewCell {

    @IBOutlet var pointsFromLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var pointsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func data (obj:PPOrderHisoryObj){
        //        type 1-交易订单  9-评论    10-签到   11-首次注册
        switch obj.type! {
        case 9:
            self.pointsFromLabel.text = "评论奖励";
        case 10:
            self.pointsFromLabel.text = "签到奖励";
        case 11:
            self.pointsFromLabel.text = "注册奖励";
        default:
            self.pointsFromLabel.text = "其他奖励";
        }
        self.timeLabel.text = obj.pay_time
        self.pointsLabel.text = String.init(format: "+%d", obj.obtain_integral!);
    }
}
