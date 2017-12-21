//
//  BoundListTableViewCell.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/12/21.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class BoundListTableViewCell: UITableViewCell {

    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var avatarIV: UIImageView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var pointsLabel: UILabel!
    @IBOutlet var inviteGradeLabel: UILabel!//邀请层级
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func data (obj:PPInviteListObj){
        self.userNameLabel.text = obj.transaction_name;
        self.avatarIV.sd_setImage(with: URL.init(string: obj.transaction_head_img!), placeholderImage: PLACE_HOLDER_IMAGE_USER);
        self.timeLabel.text = obj.create_time;
        self.pointsLabel.text = String.init(format: "+%d", obj.num!);
        self.inviteGradeLabel.text = obj.remark;
    }
}
