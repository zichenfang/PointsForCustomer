//
//  KuangkuangView.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/13.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class KuangkuangView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = UIColor.clear;
        self.isOpaque = true;
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let x_room :CGFloat = 30.0;
        let kuang_width :CGFloat = rect.size.width - x_room*2;
        let y_room :CGFloat = (rect.size.height - kuang_width)*0.5;
        UIColor.init(white: 0, alpha: 0.5).setFill();
        UIRectFill(rect);
        let holeRection :CGRect = CGRect.init(x: x_room, y: y_room-64*0.5, width: kuang_width, height: kuang_width);
        let holeiInterSection :CGRect = holeRection.intersection(rect);

        UIColor.clear.setFill();
        UIRectFill(holeiInterSection);
        
    }

}
