//
//  CommentObj.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/29.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class CommentObj: BaseObject {
    var id :String?
    var name :String?
    var imageUrl :String?
    init(info :NSDictionary){
        self.id = info["id"]as?String;
        self.name = info["name"]as?String;
        self.imageUrl = info["imageUrl"]as?String;
    }
}
