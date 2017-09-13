//
//  NSString+MyCustomString.m
//  DressIn3D
//
//  Created by Timo on 15/10/9.
//  Copyright © 2015年 Timo. All rights reserved.
//

#import "NSString+MyCustomString.h"

#import <CommonCrypto/CommonDigest.h>


@implementation NSString (MyCustomString)
//去掉空格
- (NSString *)absoluteString
{
    NSString *trimmedString = [[self stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return [trimmedString stringByReplacingOccurrencesOfString:@" " withString:@""];
}

//去掉空格
- (NSString *)absolute_String
{
    NSString *trimmedString = [[self stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return [trimmedString stringByReplacingOccurrencesOfString:@" " withString:@""];
}
//32位MD5加密方式,并且返回大写
- (NSString *)md5_32Bit_String{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr,  (unsigned)strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result.uppercaseString;//大写
}
//只有数字的字符串
- (NSString *)onlyIntegerString
{
    if (self.length<=0) {
        return self;
    }
    NSString *validRegEx =@"^[0-9]*$";
    NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
    NSMutableString *str = [NSMutableString string];
    for (int i=0; i<self.length; i++) {
        NSString *aChar = [self substringWithRange:NSMakeRange(i, 1)];
        if ([regExPredicate evaluateWithObject:aChar]) {
            [str appendString:aChar];
        }
    }
    return str;

}
//转化成汉语拼音
- (NSString *)pinyinString
{
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    NSString *pinyinString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return pinyinString;
}
//json字符串转化成字典
- (NSDictionary *)dictionary
{
    if (self == nil) {
        return nil;
    }
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
//随机字符串
+(NSString *)random32bitString

{
    
    char data[32];
    
    for (int x=0;x<32;data[x++] = (char)('A' + (arc4random_uniform(26))));
    
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
    
}
- (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (BOOL)isValidateMobile
{
    if (self.length!=11) {
        return NO;
    }
    NSString *phoneRegex = @"^1(3|5|7|8)[0-9]{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];

}


- (BOOL)isValidateQQ:(NSString *)QQ
{
    NSString *patternQQ = @"^[1-9](\\d){4,9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",patternQQ];
    return [phoneTest evaluateWithObject:QQ];
}

- (CGFloat)heightWithFont:(UIFont *)font Width :(float)width
{
    CGSize size = CGSizeMake(width, 1500);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize labelSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle.copy} context:nil].size;
    return labelSize.height;
 }
- (CGFloat)heightWithFont:(UIFont *)font LineSpacing :(float )lineSpacing Width :(float)width
{
    CGSize size = CGSizeMake(width, 1500);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    [paragraphStyle setLineSpacing:lineSpacing];
    CGSize labelSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle.copy} context:nil].size;
    return labelSize.height;
}
- (CGFloat)widthWithFont:(UIFont *)font Height :(float)height
{
    CGSize size = CGSizeMake(1500, height);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize labelSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle.copy} context:nil].size;
    return labelSize.width;
}




//普通字符串转换为base64
- (NSString *)normalToBase64Str
{
    if (self) {
        NSData *nsdata = [self dataUsingEncoding:NSUTF8StringEncoding];
        return [nsdata base64EncodedStringWithOptions:0];
    }
    else
    {
        return @"";
    }
}
//baee64转化为普通字符串
- (NSString *)base64ToNormalStr
{
    if (self) {
        NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:0];
        return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
    else
    {
        return @"";
    }
}



@end
