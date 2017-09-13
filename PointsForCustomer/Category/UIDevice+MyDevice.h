//
//  UIDevice+MyDevice.h
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/12.
//  Copyright © 2017年 fff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (MyDevice)
+ (NSString *)localIP;
//获得设备型号
+ (NSString *)getCurrentDeviceModel;
@end
