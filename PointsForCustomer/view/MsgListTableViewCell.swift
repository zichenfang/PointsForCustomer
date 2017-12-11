//
//  MsgListTableViewCell.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/12/11.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class MsgListTableViewCell: UITableViewCell {
    @IBOutlet var msgTitleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func data (obj:PPMsgObject){
        self.msgTitleLabel.text = obj.title;
        self.timeLabel.text = obj.create_time;
        self.contentLabel.text = obj.message;
        if obj.is_read == true {
            self.msgTitleLabel.textColor = UIColor.darkGray;
            self.timeLabel.textColor = UIColor.darkGray;
            self.contentLabel.textColor = UIColor.darkGray;
        }
        else {
            self.msgTitleLabel.textColor = UIColor.black;
            self.timeLabel.textColor = UIColor.black;
            self.contentLabel.textColor = UIColor.black;
        }
    }
}
