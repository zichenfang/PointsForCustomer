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
        self.perform(#selector(loadVersionInfo), with: nil, afterDelay: 2);
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
        entity.types = Int(UInt8(JPAuthorizationOptions.alert.rawValue)|UInt8(JPAuthorizationOptions.sound.rawValue));
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: nil);
    }
    func prepareJPushWithOptions(launchOptions:[UIApplicationLaunchOptionsKey: Any]?) {
        JPUSHService.setup(withOption: launchOptions , appKey: "94df0421e2ed7350e4f8e261", channel: "1", apsForProduction: false, advertisingIdentifier: nil);
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
    //MARK:获取版本信息
    @objc func loadVersionInfo() {
//        类型 1-用户端   2-商户端
        let para = ["type":"1"] as [String : AnyObject]
        PPRequestManager.POST(url: API_APP_VERSION_INFO, para: para, success: { (json) in
            let code = json["code"] as! Int
            let msg = json["msg"] as! String
            let result = json["result"] as! NSDictionary;
            if code == 200 {
                let version_online = result.string_ForKey(key: "ios_version");
                let version_online_int = (Int)((version_online.replacingOccurrences(of: ".", with: "")))!;
                let version_local:String? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String;
                let version_local_int = (Int)((version_local?.replacingOccurrences(of: ".", with: ""))!)!;
                let version_reject_update = PPUserInfoManager.rejectUpdateVersion();//被拒绝掉的版本更新号
                let version_reject_update_int = (Int)((version_reject_update.replacingOccurrences(of: ".", with: "")))!;

                //version_online版本以下的并且在被拒绝版本以上的
                if (version_local_int < version_online_int && version_reject_update_int < version_online_int) {
                    let ios_describe = result.string_ForKey(key: "ios_describe");
                    let ios_href = result.string_ForKey(key: "ios_href");
                    
                    let alertVC = UIAlertController.init(title: "新版本可用", message: ios_describe, preferredStyle: UIAlertControllerStyle.alert)
                    alertVC.addAction(UIAlertAction.init(title: "立即升级", style: UIAlertActionStyle.default, handler: { (act) in
                        if UIApplication.shared.canOpenURL(URL.init(string: ios_href)!) {
                            UIApplication.shared.openURL(URL.init(string: ios_href)!);
                        }
                    }))
                    alertVC.addAction(UIAlertAction.init(title: "暂不升级", style: UIAlertActionStyle.cancel, handler: { (act) in
                        PPUserInfoManager.updateRejectUpdateVersion(version: version_online);
                    }))
                    self.window?.rootViewController?.present(alertVC, animated: true, completion: nil)
                }
            }
            else{
                ProgressHUD.showError(msg, interaction: false)
            }
        }) {
        }
    }
    //MARK:友盟回调控制
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        let result = UMSocialSnsService.handleOpen(url);
        if result == false {
            // 其他如支付等SDK的回调
        }
        return result;
    }
    
}

