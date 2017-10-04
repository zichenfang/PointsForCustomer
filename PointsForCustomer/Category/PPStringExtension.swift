//
//  PPStringExtension.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/19.
//  Copyright © 2017年 fff. All rights reserved.
//

import Foundation
extension String{
    //MARK:弃掉空格
    func absoluleString() -> String {
        let trimmedString = self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).trimmingCharacters(in: NSCharacterSet.whitespaces)
        return trimmedString.replacingOccurrences(of: " ", with: "")

    }
    //MARK:验证手机号
    func isValidMobileNO() -> Bool {
        let emailRegex :String = "^1(3|5|7|8)[0-9]{9}$"
        let emailTest :NSPredicate = NSPredicate.init(format: "SELF MATCHES %@", emailRegex)
        return  emailTest.evaluate(with:self)

    }
    //    MARK: 根据固定高度适配宽度
    func widthWithFountAndHeight(font :UIFont,height :CGFloat) -> CGFloat {
        let size:CGSize = CGSize.init(width: 1500, height: height)
        let paragraphStyle :NSMutableParagraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        let contentText :NSString = self as NSString
        
        let lableSize :CGSize = contentText.boundingRect(with: size, options: [NSStringDrawingOptions.usesLineFragmentOrigin,NSStringDrawingOptions.usesFontLeading], attributes: [NSAttributedStringKey.font : font,NSAttributedStringKey.paragraphStyle : paragraphStyle.copy()], context: nil).size
        return lableSize.width
    }
    //    MARK: 根据固定宽度适配高度
    func heightWithFountAndWidth(font :UIFont,width :CGFloat) -> CGFloat {
        let size:CGSize = CGSize.init(width: width, height: 1500)
        let paragraphStyle :NSMutableParagraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        let contentText :NSString = self as NSString
        
        let lableSize :CGSize = contentText.boundingRect(with: size, options: [NSStringDrawingOptions.usesLineFragmentOrigin,NSStringDrawingOptions.usesFontLeading], attributes: [NSAttributedStringKey.font : font,NSAttributedStringKey.paragraphStyle : paragraphStyle.copy()], context: nil).size
        return lableSize.height
    }
    //MARK:随机字符串
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
    ////MARK: 32位MD5加密方式,并且返回大写
    func md5_32Bit_String() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deallocate(capacity: digestLen)
        
        return String(format: hash as String)
        
    }
//    - (NSString *)md5_32Bit_String{
//    const char *cStr = [self UTF8String];
//    unsigned char digest[CC_MD5_DIGEST_LENGTH];
//    CC_MD5(cStr,  (unsigned)strlen(cStr), digest );
//    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
//    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
//    [result appendFormat:@"%02x", digest[i]];
//    return result.uppercaseString;//大写
//    }
    
}
