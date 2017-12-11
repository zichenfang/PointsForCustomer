//
//  PPFAQObj.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/12/7.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class PPFAQObj: BaseObject {
    var faq_id :Int?
    var issue :String?
    var answer :String?
    var isOpen :Bool?//是否展开

    init(info :NSDictionary){
        self.faq_id = info["id"]as?Int;
        self.issue = info["issue"]as?String;
        self.answer = info["answer"]as?String;
        self.isOpen = false;//默认为关闭
    }
}
