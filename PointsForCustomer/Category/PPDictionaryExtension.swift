//
//  PPDictionaryExtension.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/10/24.
//  Copyright © 2017年 fff. All rights reserved.
//

import Foundation
extension Dictionary{
    //MARK:取出数组
    func array_ForKey(key:String) -> [AnyObject] {
        if let dic_self = self as? [String:AnyObject]{
            if let arr = dic_self[key] as? [AnyObject]{
                return arr;
            }
            else{
                return [AnyObject]();
            }
        }
        else{
            return [AnyObject]();
        }

    }
    //MARK:取出字典
    func dictionary_ForKey(key:String) -> [String:AnyObject] {
        if let dic_self = self as? [String:AnyObject]{
            if let dic = dic_self[key] as? [String:AnyObject]{
                return dic;
            }
            else{
                return [String:AnyObject]();
            }
        }
        else{
            return [String:AnyObject]();
        }
        
    }
    //MARK:取出字符串
    func string_ForKey(key:String) -> String {
        if let dic_self = self as? [String:AnyObject]{
            if let str = dic_self[key] as? String{
                return str;
            }
            else{
                return "";
            }
        }
        else{
            return "";
        }
        
    }
    
}
