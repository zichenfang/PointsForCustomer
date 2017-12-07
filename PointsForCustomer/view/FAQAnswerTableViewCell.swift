//
//  FAQAnswerTableViewCell.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/12/7.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class FAQAnswerTableViewCell: UITableViewCell {
    @IBOutlet var answerLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func data (obj:PPFAQObj){
        self.answerLabel.text = obj.answer;
    }
}
