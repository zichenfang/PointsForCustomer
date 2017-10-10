//
//  PPShopObject.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/12.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class PPShopObject: BaseObject {
    var id :Int?
    var name :String?
    var head_img :String?
    //评分
    var ave_score :Double?
    //星星等级
    var star :Int?
    var comment_num :Int?
    var distance :String?
    var integral_ratio :Int?
    var latitude :Double?
    var longitude :Double?

    init(info :NSDictionary){
        self.id = info["id"]as?Int;
        self.name = info["name"]as?String;
        self.head_img = info["head_img"]as?String;
        self.ave_score = info["ave_score"]as?Double;
        self.star = Int(self.ave_score!)
        self.comment_num = info["comment_num"]as?Int;
        self.distance = info["distance"]as?String;
        self.integral_ratio = info["integral_ratio"]as?Int;
        self.latitude = info["latitude"]as?Double;
        self.longitude = info["longitude"]as?Double;

    }
}
