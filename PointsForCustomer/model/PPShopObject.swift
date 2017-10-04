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
    var imgUrl :String?
    var star :NSInteger?
    init(info :NSDictionary){
        self.id = info["id"]as?Int;
        self.imgUrl = info["imgUrl"]as?String;
        self.star = info["star"]as?NSInteger;
        
    }
}
