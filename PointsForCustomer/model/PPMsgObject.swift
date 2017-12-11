//
//  MsgObject.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/12/11.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class PPMsgObject: BaseObject {
    var msg_id :Int?
    var title :String?
    var message :String?
    var is_read :Bool?//是否已读
    var isOpen :Bool?//是否展开
    var create_time :String?//时间
    var cell_height_close :CGFloat?//单元格高度(关闭)
    var cell_height_open :CGFloat?//单元格高度（展开）

    init(info :NSDictionary){
        self.msg_id = info["id"]as?Int;
        self.title = info["title"]as?String;
        self.is_read = info["is_read"]as?Bool;
        self.isOpen = false;//默认为关闭
        self.create_time = info["create_time"]as?String;
        self.message = info["message"]as?String;
        let titleHeight:CGFloat! = self.title?.heightWithFountAndWidth(font: UIFont.systemFont(ofSize: 15), width: SCREEN_WIDTH-5*2);
        let contentHeight:CGFloat! = self.message?.heightWithFountAndWidth(font: UIFont.systemFont(ofSize: 13), width: SCREEN_WIDTH-5*2);
        cell_height_close = max(titleHeight + 60, 70);
        cell_height_open = max(titleHeight + contentHeight + 40, 70);
    }
}
