//
//  PPRequestManager.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/30.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class PPRequestManager: NSObject {
    //MARK:GET
    static func GET (url :String , para:[AnyHashable : Any]? , success:((_ json:Dictionary<String, AnyObject>)->Void)? , failure:(()->Void)? ){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let manager = AFHTTPSessionManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.requestSerializer.timeoutInterval = 10.0
        /*系统的公共参数集中在这里*/
        //设备平台
        var para_here = para
        para_here?.updateValue("ios", forKey: "client")
        var url_here = url
        if url_here .hasPrefix("http") == false{
            url_here = API_HEADERURL + url_here
        }
//        url_here = url_here.replacingOccurrences(of: "//", with: "/")

        manager.get(url_here, parameters: para, progress: nil, success: {(task,response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            let response_data = response as! Data
            do{
                let json_option = try JSONSerialization.jsonObject(with: response_data, options: .allowFragments)
                let json_dic = json_option as! Dictionary<String, AnyObject>
                if success != nil{
                    print("url = \(url_here) \n para = \(para_here ?? [:]) \n json_dic =\(json_dic)")
                    success!(json_dic)
                }
            }catch let error as NSError{
                print("url = \(url_here) \n error =\(error)")
                if failure != nil{
                    failure!();
                }
            }
        }, failure:{(task,error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            let error_ojc = error as NSError
            print("错误 = \(error) \n 错误数据 =\(String.init(data: error_ojc.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as! Data, encoding: String.Encoding.utf8) ?? "...")");
            ProgressHUD.dismiss()
        });
    }
    //MARK:POST
    static func POST (url :String , para:[AnyHashable : Any]? , success:((_ json:Dictionary<String, AnyObject>)->Void)? , failure:(()->Void)? ){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let manager = AFHTTPSessionManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.requestSerializer.timeoutInterval = 10.0
        /*系统的公共参数集中在这里*/
        //设备平台
        var para_here = para
        para_here?.updateValue("ios", forKey: "client")
        var url_here = url
        if url_here .hasPrefix("http") == false{
            url_here = API_HEADERURL + url_here
        }
//        url_here = url_here.replacingOccurrences(of: "//", with: "/")
        
        manager.post(url_here, parameters: para, progress: nil, success: {(task,response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            let response_data = response as! Data
            do{
                let json_option = try JSONSerialization.jsonObject(with: response_data, options: .allowFragments)
                let json_dic = json_option as! Dictionary<String, AnyObject>
                if success != nil{
                    print("url = \(url_here) \n para = \(para_here ?? [:]) \n json_dic =\(json_dic)")
                    success!(json_dic)
                }
            }catch let error as NSError{
                print("url = \(url_here) \n error =\(error)")
                if failure != nil{
                    failure!();
                }
            }
        }, failure:{(task,error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            let error_ojc = error as NSError
            print("错误 = \(error) \n 错误数据 =\(String.init(data: error_ojc.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as! Data, encoding: String.Encoding.utf8) ?? "...")");
            ProgressHUD.dismiss()
        });
    }
}
