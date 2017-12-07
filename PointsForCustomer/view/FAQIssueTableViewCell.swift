//
//  FAQIssueTableViewCell.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/12/7.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class FAQIssueTableViewCell: UITableViewCell {

    @IBOutlet var issueLabel: UILabel!
    @IBOutlet var arrowIV: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func data (obj:PPFAQObj){
        self.issueLabel.text = obj.issue;
        if obj.isOpen == true {
            arrowIV.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi));
        }
        else{
            arrowIV.transform = CGAffineTransform.init(rotationAngle: 0);
        }
    }

}
