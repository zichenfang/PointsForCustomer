//
//  CommentObj.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/29.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit
class CommentObj: BaseObject {
    var id :Int?
    var user_id :Int?
    var nickname :String?
    var head_url :String?
    var comment :String?
    //评分
    var score :Double?
    //星星等级
    var star :Int?
    var image1 :String?
    var image2 :String?
    var image3 :String?
    //自组成数组
    var images = NSMutableArray() as! [String]
    var create_time :String?

    init(info :NSDictionary){
        self.id = info["id"]as?Int;
        self.user_id = info["user_id"]as?Int;
        self.nickname = info["nickname"]as?String;
        self.head_url = info["head_url"]as?String;
        self.comment = info["comment"]as?String;
        self.score = info["score"]as?Double;
        self.star = Int(self.score!)
        self.image1 = info["image1"]as?String;
        self.image2 = info["image2"]as?String;
        self.image3 = info["image3"]as?String;
        if self.image1 != nil {
            self.images.append(self.image1!)
        }
        if self.image2 != nil {
            self.images.append(self.image2!)
        }
        if self.image3 != nil {
            self.images.append(self.image3!)
        }
        self.create_time = info["create_time"]as?String;
    }
}
