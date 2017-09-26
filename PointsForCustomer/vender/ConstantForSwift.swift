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


let SCREEN_WIDTH :CGFloat = UIScreen.main.bounds.size.width;
let SCREEN_HEIGHT :CGFloat = UIScreen.main.bounds.size.height;
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
let AMAP_APPKEY : String = Bundle.main.infoDictionary?["AMAP_APPKEY"] as! String;
let AMAP_PRODUCT_NAME : String = Bundle.main.infoDictionary?["CFBundleName"] as! String;

let PLACE_HOLDER_IMAGE :UIImage = UIImage.init(named: "placeholderimage")!;
let APP_DELEGATE  = UIApplication.shared.delegate as! AppDelegate;

//通知别名 NotificationCenter
let NOTI_LOCATION_CHANGED  = NSNotification.Name(rawValue: "pp_noti_001");

class ConstantForSwift: NSObject {

}
