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
    @IBOutlet var kdaLabel: UILabel!
    @IBOutlet var userInfoView: UIView!
    @IBOutlet var insertImagesView: UIView!
    @IBOutlet var iv1: UIImageView!
    @IBOutlet var iv2: UIImageView!
    @IBOutlet var iv3: UIImageView!
    
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var insertImagesViewHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func data(obj:CommentObj) {
        //包含图片
        if obj.images.count>0 {
            self.insertImagesViewHeight.constant = SCREEN_WIDTH * 0.2
            self.insertImagesView.isHidden = false
            //图1
            if obj.image1 != nil{
                self.iv1.sd_setImage(with: URL.init(string: obj.image1!), placeholderImage: PLACE_HOLDER_IMAGE_GENERAL)
            }
            else{
                self.iv1.image = nil
            }
            //图2
            if obj.image2 != nil{
                self.iv2.sd_setImage(with: URL.init(string: obj.image2!), placeholderImage: PLACE_HOLDER_IMAGE_GENERAL)
            }
            else{
                self.iv2.image = nil
            }
            //图3
            if obj.image3 != nil{
                self.iv3.sd_setImage(with: URL.init(string: obj.image3!), placeholderImage: PLACE_HOLDER_IMAGE_GENERAL)
            }
            else{
                self.iv3.image = nil
            }
            
        }
            //不包含图片，只有文字
        else{
            self.insertImagesViewHeight.constant = 0
            self.insertImagesView.isHidden = true
        }
        //头像等信息
        self.uesrAvatarIV.sd_setImage(with: URL.init(string: obj.head_url!), placeholderImage: PLACE_HOLDER_IMAGE_USER)
        self.userNameLabel.text = obj.nickname
        self.kdaLabel.text = String.init(format: "%.1f分", obj.score!)
        self.commentTimeLabel.text = obj.create_time
        //星星
        let starValue = obj.star!;
        for tag in 100...104 {
            let starIV:UIImageView? = self.userInfoView.viewWithTag(tag) as? UIImageView;
            if tag-100 < starValue{
                starIV?.image = #imageLiteral(resourceName: "xingxing_liang");
            }
            else{
                starIV?.image = #imageLiteral(resourceName: "xingxing_an");
            }
        }
        //评论内容
        self.commentLabel.text = obj.comment
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
