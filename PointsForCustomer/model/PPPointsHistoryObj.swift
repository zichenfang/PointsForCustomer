//
//  PPPointsHistoryObj.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/12/12.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class PPPointsHistoryObj: BaseObject {
    var create_time :String?
    var num :String?
    var order_no :String?
    var remark :String?
    var transaction_id :Int?
    var transaction_name :String?
    var type :String?
    
    init(info :NSDictionary){
        self.create_time = info["create_time"]as?String;
        self.num = info["num"]as?String;
        self.order_no = info["order_no"]as?String;
        self.remark = info["remark"]as?String;
        self.transaction_id = info["transaction_id"]as?Int;
        self.transaction_name = info["transaction_name"]as?String;
        self.type = info["type"]as?String;
        
    }
}
