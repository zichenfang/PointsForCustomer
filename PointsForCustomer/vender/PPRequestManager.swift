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
    static func GET (url :String , para:[AnyHashable : Any]? , success:((_ response:NSDictionary)->Void)? , failure:((_ error:NSError)->Void)? ){
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

//        manager.get(url_here, parameters: para, progress: nil, success: {(task,response) in
////            print(NSString.init(data: response as! Data, encoding: String.Encoding.utf8.rawValue)!)
//            let json :Any? = try JSONSerialization.jsonObject(with: response as! Data, options: [])
//            print(json!)
//        }, failure:{(task,error) in
//            print(error);
//        });

        
        
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
        if success != nil{
            success!(["1":"2"]);
        }
    }
}
