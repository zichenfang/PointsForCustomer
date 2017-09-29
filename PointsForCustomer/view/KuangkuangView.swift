//
//  KuangkuangView.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/13.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class KuangkuangView: UIView {
    var animation_y : CABasicAnimation?
    var lineView : UIView?

    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = UIColor.clear;
        self.isOpaque = true;
        //        //扫码半透明框
        let x_room :CGFloat = 30.0;
        let kuang_width :CGFloat = frame.size.width - x_room*2;
        let y_room :CGFloat = (frame.size.height - kuang_width)*0.5;
        lineView = UIView.init(frame: CGRect.init(x: x_room, y: y_room - 64*0.5, width: frame.size.width - x_room*2, height: 1.5));
        lineView?.backgroundColor = UIColor.init(red: 0, green: 0.768, blue: 0.043, alpha: 1);
        
        self.addSubview(lineView!);
        
        animation_y = CABasicAnimation.init(keyPath: "transform.translation.y");
        let toValue :Float = Float(kuang_width);
        animation_y?.toValue = NSNumber.init(value: toValue);
        
        animation_y?.autoreverses = true;
        animation_y?.fillMode = kCAFillModeForwards;
        animation_y?.repeatCount = MAXFLOAT;
        animation_y?.duration = 2.0;

        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let x_room :CGFloat = 30.0;
        let kuang_width :CGFloat = rect.size.width - x_room*2;
        let y_room :CGFloat = (rect.size.height - kuang_width)*0.5;
        UIColor.init(white: 0, alpha: 0.7).setFill();
        UIRectFill(rect);
        let holeRection :CGRect = CGRect.init(x: x_room, y: y_room-64*0.5, width: kuang_width, height: kuang_width);
        let holeiInterSection :CGRect = holeRection.intersection(rect);

        UIColor.clear.setFill();
        UIRectFill(holeiInterSection);
        
    }
    func begainAnimation(){
        lineView!.layer.add(animation_y!, forKey: "scanCode")
    }
    func stopAnimation(){
        lineView!.layer .removeAllAnimations();
    }

}
