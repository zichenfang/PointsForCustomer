//
//  UserLocationManager.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/25.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

/*静态单例*/
let LOCATION_MANAGER :UserLocationManager = UserLocationManager.init();

class UserLocationManager: NSObject {

    /*静态方法*/
//    static func defaultManager() -> UserLocationManager {
//        return locationManager;
//    }
    /*用户真实的地理位置，只有当获取到地图权限的时候定位，才能得到，如果定位失败，则原真实位置保留*/
    var realLocation :CLLocation?
    var realCity :String?
    var realAOIName :String?

    /*当前选择的地理位置 ,下面的属性赋值操作，不在UserLocationManager该类中进行*/
    @objc dynamic var currentLocation :CLLocation?
    var currentCity :String?
    @objc dynamic var currentAOIName :String?
    
    var mapManager: AMapLocationManager!

    public override init() {
        /*定位初始化*/
        mapManager = AMapLocationManager();
        mapManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        mapManager.locationTimeout = 10
        mapManager.reGeocodeTimeout = 10
        super.init();
    }
    /*静态方法,开始定位
     success 成功
     permissionFailed 权限获取失败
     reGeocodeFailed 逆地理编码获取失败
     */
     func requestLocation (success :((_ location:CLLocation , _ cityName : String? , _ aoiName : String?)->Void)? , permissionFailed :(()->Void)? , reGeocodeFailed :(()->Void)? ) {
        
        self.mapManager.requestLocation(withReGeocode: true, completionBlock: {  (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
            ProgressHUD.dismiss();
            if let error = error {
                let error = error as NSError
                print("定位错误了！！！\(error)")
                if error.code == AMapLocationErrorCode.locateFailed.rawValue && permissionFailed != nil{
                    permissionFailed!();
                    return
                }
                else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                    || error.code == AMapLocationErrorCode.timeOut.rawValue
                    || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                    || error.code == AMapLocationErrorCode.badURL.rawValue
                    || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                    || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
                    //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
                    NSLog("逆地理错误:{\(error.code) - \(error.localizedDescription)};")
                    if reGeocodeFailed != nil{
                        reGeocodeFailed!();
                    }
                }
            }
            //先取逆地理信息，如果失败，则即使经纬度有有效信息，也被视为无效信息
            if let reGeocode = reGeocode {
                print("逆地理信息\(reGeocode)");
                var aoiName:String? = reGeocode.aoiName;
                //aoiName失败，则取poiname
                if aoiName == nil {
                    aoiName = reGeocode.poiName;
                }
                    //aoiname失败，则取street
                else if aoiName == nil {
                    aoiName = reGeocode.street;
                }
                if let location = location {
                    print("经纬度\(location)");
                    /*定位成功！！！！*/
                    if success != nil{
                        success!(location,reGeocode.city,aoiName);
                    }
                    self.realLocation = location;
                    self.realCity = reGeocode.city;
                    self.realAOIName = aoiName;
                }
                else{
                    /*定位失败！！！！*/
                    if reGeocodeFailed != nil{
                        reGeocodeFailed!();
                    }
                }
            }
            
        })
    }
    
}
