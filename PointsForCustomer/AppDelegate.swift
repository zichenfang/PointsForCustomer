//
//  AppDelegate.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/11.
//  Copyright © 2017年 fff. All rights reserved.
//

/*
 项目马上就要开始了
 */
import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    //真实的实时位置
    var realLocation :CLLocation!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //准备高德地图定位
        prepareAMAPConfig();
        //友盟启动配置
        TTUmengManager.setUp();
        window = UIWindow.init(frame: UIScreen.main.bounds);
        window?.rootViewController = MainTabbarViewController();
        window?.makeKeyAndVisible();
        //推送
        prepareAPNs();
        prepareJPushWithOptions(launchOptions: launchOptions);
        return true
    }
    //MARK:准备高德地图定位
    func prepareAMAPConfig(){
        AMapServices.shared().apiKey = AMAP_APPKEY;
    }
    func allowBeLocated() -> Bool  {
        if CLLocationManager.locationServicesEnabled(){
            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined
            {
                return true;
            }
            else{
                return false;
            }
        }
        else{
            return false;
        }
    }
    //MARK:添加初始化APNs代码
    func prepareAPNs() {
        let entity = JPUSHRegisterEntity.init();
        entity.types = Int(UInt8(JPAuthorizationOptions.alert.rawValue)|UInt8(JPAuthorizationOptions.badge.rawValue)|UInt8(JPAuthorizationOptions.sound.rawValue));
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: nil);
    }
    func prepareJPushWithOptions(launchOptions:[UIApplicationLaunchOptionsKey: Any]?) {
        JPUSHService.setup(withOption: launchOptions , appKey: "", channel: "1", apsForProduction: false, advertisingIdentifier: nil);
        JPUSHService.registrationIDCompletionHandler { (resCode, registrationID) in
            if resCode == 0 {
                //记录到本地注册ID
                PPUserInfoManager.updateJPushRegistID(rID: registrationID!);
            }
        }
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken);
    }


}

