//
//  PPBannerObject.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/15.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class PPBannerObject: BaseObject {
    var id :String?
    var name :String?
    var imageUrl :String?
    init(info :NSDictionary){
        self.id = info["id"]as?String;
        self.imageUrl = info["imageUrl"]as?String;
    }
}
