//
//  PPShopDetailobj.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/10/8.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class PPShopDetailobj: BaseObject {
    var id :Int?
    var address :String?
    var name :String?
    var head_img :String? = ""
    //描述文字
    var desc1 :String?
    var desc2 :String?
    var desc3 :String?
    var desces = NSMutableArray()
    //轮播图
    var image1 :String?
    var image2 :String?
    var image3 :String?
    var images = NSMutableArray()
    //详细描述
    var introduction :String? = ""
    //营业执照
    var business_license :String?
    //营业许可证
    var business_permit :String?
    //积分使用范围
    var use_range :String?
    //营业时间
    var business_hours :String?
    
    //评分
    var ave_score :Double?
    //产品
    var product_score :Double?
    //服务
    var server_score :Double?
    //环境
    var milieu_score :Double?

    
    //星星等级
    var star :Int?
    var comment_num :NSInteger?
    var distance :String?
    var integral_ratio :NSInteger?
    var latitude :Double?
    var longitude :Double?
    //电话
    var mobile :String?
    var type :String?

    
    init(info :NSDictionary){
        self.id = info["id"]as?Int;
        self.name = info["name"]as?String;
        self.address = info["address"]as?String;
        //头部图
        if let head_img = info["head_img"]as?String {
            self.head_img = head_img;
        }

        self.desc1 = info["desc"]as?String ?? "";
        self.desc2 = info["desc2"]as?String ?? "";
        self.desc3 = info["desc3"]as?String ?? "";
        self.desces.add(self.desc1!)
        self.desces.add(self.desc2!)
        self.desces.add(self.desc3!)

        
        self.image1 = info["image"]as?String ?? "";
        self.image2 = info["image2"]as?String ?? "";
        self.image3 = info["image3"]as?String ?? "";
        self.images.add(self.image1!)
        self.images.add(self.image2!)
        self.images.add(self.image3!)
        if let introduction = info["introduction"]as?String {
            self.introduction = introduction;
        }
        self.business_license = info["business_license"]as?String;
        self.business_permit = info["business_permit"]as?String;

        self.ave_score = info["ave_score"]as?Double;
        self.star = Int(self.ave_score!)
        self.server_score = info["server_score"]as?Double;
        self.product_score = info["product_score"]as?Double;
        self.milieu_score = info["milieu_score"]as?Double;

        self.comment_num = info["comment_num"]as?NSInteger;
        self.distance = info["distance"]as?String;
        self.integral_ratio = info["integral_ratio"]as?NSInteger;
        if let latitude :String = info["latitude"] as? String{
            self.latitude = Double(latitude);
        }
        if let longitude :String = info["longitude"] as? String{
            self.longitude = Double(longitude);
        }
        
        self.mobile = info["mobile"]as?String;
        self.type = info["type"]as?String;
        self.business_hours = info["business_hours"]as?String;
        self.use_range = info["use_range"]as?String;

    }
}
