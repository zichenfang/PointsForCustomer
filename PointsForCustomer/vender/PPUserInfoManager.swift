//
//  PPUserInfoManager.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/10/5.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit
let USERDEFAULTS_KEY_USERINFO = "userdefaults_001";
let USERDEFAULTS_KEY_ISLOGINED = "userdefaults_002";
let USERDEFAULTS_KEY_JPUSH_REGISTID = "userdefaults_003";
let USERDEFAULTS_KEY_REJECT_VERSION_UPDATE = "userdefaults_004";//拒绝更新的版本号key

class PPUserInfoManager: NSObject {
//    MARK:用户信息综合
    static func updateUserInfo(info :NSDictionary?)  {
        if info != nil {
            UserDefaults.standard.setValue(info, forKey: USERDEFAULTS_KEY_USERINFO)
            //发送用户信息更新通知
            NotificationCenter.default.post(name: NOTI_USERINFO_CHANGED, object: nil)
        }
    }
    static func userInfo() -> NSDictionary? {
        if let userinfo =  UserDefaults.standard.value(forKey: USERDEFAULTS_KEY_USERINFO) as? NSDictionary{
            return userinfo
        }
        else{
            return [:]
        }
    }
    static func updateUserInfo(userInfo :NSDictionary) {
        UserDefaults.standard.setValue(userInfo, forKey: USERDEFAULTS_KEY_USERINFO)
        //发送用户信息修改通知
        NotificationCenter.default.post(name: NOTI_USERINFO_CHANGED, object: nil)
    }
//    MARK:登录状态
    static func updateIsLogined(logined :Bool)  {
        UserDefaults.standard.setValue(logined, forKey: USERDEFAULTS_KEY_ISLOGINED)
        //发送用户登录状态更改通知
        NotificationCenter.default.post(name: NOTI_USERSTATUS_CHANGED, object: nil)
    }
    static func isLogined() -> Bool {
        if let status = UserDefaults.standard.value(forKey: USERDEFAULTS_KEY_ISLOGINED) as? Bool{
            return status
        }
        else{
            return false
        }
    }
    //    MARK:token
    static func token() -> String {
        if let token = PPUserInfoManager.userInfo()!["token"]{
            return token as! String
        }
        else{
            return ""
        }
    }
    //    MARK:极光注册ID
    static func updateJPushRegistID(rID :String) {
        UserDefaults.standard.setValue(rID, forKey: USERDEFAULTS_KEY_JPUSH_REGISTID)
    }
    static func jPushRegistID() -> String{
        if let rID = UserDefaults.standard.value(forKey: USERDEFAULTS_KEY_JPUSH_REGISTID) as? String{
            return rID;
        }
        else{
            return "";
        }
    }
    //    MARK:拒绝版本更新的版本号
    static func updateRejectUpdateVersion(version :String) {
        UserDefaults.standard.setValue(version, forKey: USERDEFAULTS_KEY_REJECT_VERSION_UPDATE)
    }
    static func rejectUpdateVersion() -> String{
        if let version = UserDefaults.standard.value(forKey: USERDEFAULTS_KEY_REJECT_VERSION_UPDATE) as? String{
            return version;
        }
        else{
            return "1.0";
        }
    }

}
