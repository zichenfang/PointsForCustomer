//
//  IndexClassObj.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/19.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class PPIndexClassObj: BaseObject {
    var id :Int?
    var name :String?
    var imageUrl :String?
    init(info :NSDictionary){
        self.id = info["id"]as?Int;
        self.name = info["name"]as?String;
        self.imageUrl = info["icon_url"]as?String;
    }
}
