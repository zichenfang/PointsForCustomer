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

//MARK: 屏幕
let SCREEN_WIDTH :CGFloat = UIScreen.main.bounds.size.width;
let SCREEN_HEIGHT :CGFloat = UIScreen.main.bounds.size.height;
//MARK: 模拟器检测
struct PLARFORM {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}
//MARK: 高德地图appkey
let AMAP_APPKEY : String = Bundle.main.infoDictionary?["AMAP_APPKEY"] as! String;
let AMAP_PRODUCT_NAME : String = Bundle.main.infoDictionary?["CFBundleName"] as! String;

let PLACE_HOLDER_IMAGE :UIImage = UIImage.init(named: "placeholderimage")!;
let APP_DELEGATE  = UIApplication.shared.delegate as! AppDelegate;

//MARK: 通知别名 NotificationCenter
let NOTI_LOCATION_CHANGED  = NSNotification.Name(rawValue: "pp_noti_001");

//MARK: 具体接口地址别名
let API_HEADERURL :String = "http://jf.bingplus.com/";
//MARK: ●用户注册
let API_USER_REGISTER :String = "/api.php/v1.Publics/register";


//MARK: ●轮播图
let API_SHOP_BANNER :String = "/api.php/v1.Index/ads";

class ConstantForSwift: NSObject {

}
