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
        url_here = url_here.replacingOccurrences(of: "//", with: "/")

        manager.get(url_here, parameters: para, progress: nil, success: {(task,response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            let response_data = response as! Data
            do{
                let json_option = try JSONSerialization.jsonObject(with: response_data, options: .allowFragments)
                let json_dic = json_option as! Dictionary<String, AnyObject>
                if success != nil{
                    print("url = \(url_here) \n para = \(para_here) \n json_dic =\(json_dic)")
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
            print(error);
        });

        
        
//        [manager GET:URLString parameters:para_here progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSDictionary *cacheDic = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
//            NSLog(@"URLString =%@ \n parameters =%@ \n %@ 's cacheDic  =%@\n ",URLString,parameters,[parameters string_ForKey:@"method"],cacheDic);
//            mySuccess(cacheDic.noNullObject);
//            NSString *code = [cacheDic.noNullObject objectForKey:@"code"];
//            if (code.intValue ==100) {
//            [TTUserInfoManager setLogined:NO];
//            [TTRequestOperationManager shouldLogin];
//            }
//            [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
//
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [ProgressHUD showError:@"网络连接错误，请确定您已连接到互联网"];
//            NSLog(@"%@",error);
//            myFailure(error);
//            [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
//            }];
    }
}
