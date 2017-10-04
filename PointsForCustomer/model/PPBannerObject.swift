//
//  PPBannerObject.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/15.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class PPBannerObject: BaseObject {
    var id :Int?
    var name :String?
    var imageUrl :String?
    init(info :NSDictionary){
        self.id = info["id"]as?Int;
        self.imageUrl = info["image_url"]as?String;
        self.name = info["title"]as?String;
    }
}
