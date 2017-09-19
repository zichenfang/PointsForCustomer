//
//  PPStringExtension.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/19.
//  Copyright © 2017年 fff. All rights reserved.
//

import Foundation
extension String{
    func absoluleString() -> String {
        let trimmedString = self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).trimmingCharacters(in: NSCharacterSet.whitespaces)
        return trimmedString.replacingOccurrences(of: " ", with: "")

    }
    func isValidMobileNO() -> Bool {
        let emailRegex :String = "^1(3|5|7|8)[0-9]{9}$"
        let emailTest :NSPredicate = NSPredicate.init(format: "SELF MATCHES %@", emailRegex)
        return  emailTest.evaluate(with:self)

    }
    func widthWithFountAndHeight(font :UIFont,height :CGFloat) -> CGFloat {
        let size:CGSize = CGSize.init(width: 1500, height: height)
        let paragraphStyle :NSMutableParagraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        let contentText :NSString = self as NSString
        
        let lableSize :CGSize = contentText.boundingRect(with: size, options: [NSStringDrawingOptions.usesLineFragmentOrigin,NSStringDrawingOptions.usesFontLeading], attributes: [NSFontAttributeName : font,NSParagraphStyleAttributeName : paragraphStyle.copy()], context: nil).size
        return lableSize.width
    }
    //随机字符串
    static func random32bitStringGGG(length : Int) -> String {
        var index = 0
        var output = ""
        while index < length {
            let randomNumber = arc4random() % 26 + 97
            let randomChar = Character(UnicodeScalar(randomNumber)!)

            output.append(randomChar)
            index = index + 1;
        }
        return output.uppercased()
    }

    
}
