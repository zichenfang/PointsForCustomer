//
//  PPPointsHistoryObj.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/10/8.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class PPOrderHisoryObj: BaseObject {
    var amount :Int? = 0
    var order_history_id :Int? = 0
    var integral_proportion :Int? = 0
    var integral_ratio :Int? = 0
    var obtain_integral :Int? = 0

    var order_no :String? = ""
    var pay_time :String? = ""
    var seller_name :String? = ""
    var state :Int! = 5
    var type :Int? = 0
    var state_des :String? = ""

    init(info :NSDictionary){
        if let amount = info["amount"]as?Int {
            self.amount = amount;
        }
        if let order_history_id = info["id"]as?Int {
            self.order_history_id = order_history_id;
        }
        if let integral_proportion = info["integral_proportion"]as?Int {
            self.integral_proportion = integral_proportion;
        }
        if let integral_ratio = info["integral_ratio"]as?Int {
            self.integral_ratio = integral_ratio;
        }
        if let obtain_integral = info["obtain_integral"]as?Int {
            self.obtain_integral = obtain_integral;
        }
        if let order_no = info["order_no"]as?String {
            self.order_no = order_no;
        }
        if let pay_time = info["pay_time"]as?String {
            self.pay_time = pay_time;
        }
        if let seller_name = info["seller_name"]as?String {
            self.seller_name = seller_name;
        }
        if let state = info["state"]as?Int {
            self.state = state;
        }
//        "state": "integer,订单状态 2-冻结中 3-退款中 5-已完成  9-已退款",
        switch self.state {
        case 2:
            self.state_des = "退款";
        case 3:
            self.state_des = "退款中";
        case 5:
            self.state_des = "已完成";
        case 9:
            self.state_des = "已退款";
        default:
            self.state_des = "已完成";
        }
//        1-交易订单  9-评论    10-签到   11-首次注册
        self.type = info["type"]as?Int;
    }
}
