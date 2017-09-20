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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func data(obj:PPShopObject) {
        shopThumbIV.sd_setImage(with: URL.init(string: obj.imgUrl!), placeholderImage: PLACE_HOLDER_IMAGE);
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
