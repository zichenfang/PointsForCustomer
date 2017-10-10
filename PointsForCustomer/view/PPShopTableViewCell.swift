//
//  PPShopTableViewCell.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/15.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class PPShopTableViewCell: UITableViewCell {

    @IBOutlet var shopThumbIV: UIImageView!
    @IBOutlet var shopNameLabel: UILabel!
    @IBOutlet var kdaLabel: UILabel!
    @IBOutlet var percentLabel: UILabel!
    @IBOutlet var commentCountLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func data(obj:PPShopObject) {
        shopThumbIV.sd_setImage(with: URL.init(string: obj.head_img!), placeholderImage: PLACE_HOLDER_IMAGE_GENERAL);
        shopNameLabel.text = obj.name
        kdaLabel.text = String.init(format: "%.1f分", obj.ave_score!)
        percentLabel.text = String.init(format: "返利折扣：%d%", obj.integral_ratio!)
        commentCountLabel.text = String.init(format: "%d评论", obj.comment_num!)
        distanceLabel.text = String.init(format: "<%@", obj.distance!)

        //星星
        let starValue = obj.star!;
        for tag in 100...104 {
            let starIV:UIImageView? = self.contentView.viewWithTag(tag) as? UIImageView;
            if tag-100 < starValue{
                starIV?.image = #imageLiteral(resourceName: "xingxing_liang");
            }
            else{
                starIV?.image = #imageLiteral(resourceName: "xingxing_an");
            }
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
