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
    @IBOutlet var stateLabel: UILabel!//状态

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        stateLabel.layer.masksToBounds = true;
        stateLabel.layer.cornerRadius = 2;
        stateLabel.layer.borderWidth = 1;
        stateLabel.layer.borderColor = UIColor.styleRed().cgColor;
    }
    func data (obj:PPOrderHisoryObj){
//        type 1-交易订单  9-评论    10-签到   11-首次注册
        self.shopNameLabel.text = obj.seller_name
        self.timeLabel.text = obj.pay_time
        self.xiaofeiPointsLabel.text = String.init(format: "-%d", obj.integral_proportion!);
        self.huodePointsLabel.text = String.init(format: "+%d", obj.obtain_integral!);
        self.stateLabel.text = String.init(format: "%@ ", obj.state_des!);
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
