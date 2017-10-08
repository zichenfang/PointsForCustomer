//
//  PPPointsHistoryObj.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/10/8.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class PPPointsHistoryObj: BaseObject {
    var id :Int?
    var shopName :String?
    init(info :NSDictionary){
        self.id = info["id"]as?Int;
        self.shopName = info["shopName"]as?String;
    }
}
