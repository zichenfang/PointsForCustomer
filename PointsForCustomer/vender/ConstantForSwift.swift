//
//  ConstantForSwift.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/13.
//  Copyright © 2017年 fff. All rights reserved.
//

/*
 相当于define用法
 */
import UIKit


public let SCREEN_WIDTH :CGFloat = UIScreen.main.bounds.size.width;
public let SCREEN_HEIGHT :CGFloat = UIScreen.main.bounds.size.height;
//模拟器检测
struct PLARFORM {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}
//高德地图appkey
public let AMAP_APPKEY : String = Bundle.main.infoDictionary?["AMAP_APPKEY"] as! String;

class ConstantForSwift: NSObject {

}
