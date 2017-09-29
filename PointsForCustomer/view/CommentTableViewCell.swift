//
//  CommentTableViewCell.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/29.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet var uesrAvatarIV: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var commentTimeLabel: UILabel!
    @IBOutlet var kpiLabel: UILabel!
    @IBOutlet var userInfoView: UIView!
    @IBOutlet var insertImagesView: UIView!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var insertImagesViewHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func data(obj:CommentObj) {
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
