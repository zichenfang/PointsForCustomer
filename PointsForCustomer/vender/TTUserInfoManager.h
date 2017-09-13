//
//  UserInfoManager.h
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

/*用户登陆、注销、信息修改都会触发*/
#define kNoti_userStatsChanged @"NNNNOTI_001"
/*用户token过期*/
#define kNoti_userTokeExpire @"NNNNOTI_002"

@interface TTUserInfoManager : NSObject



//执行该方法的时候，会发送通知kNoti_userStatsChanged
+ (void)setUserInfo:(NSDictionary *)userInfo;
+ (NSDictionary *)userInfo;

+ (NSString *)token;


+ (void)setAccount:(NSString *)account;
+ (NSString *)account;

+ (void)setPassword:(NSString *)password;
+ (NSString *)password;

//系统是否第一次启动
+ (void)setAppHasLaunched:(BOOL)launched;
+ (BOOL)appHasLaunched;

//执行该方法的时候，会发送通知kNoti_userStatsChanged
//登录状态
+ (void)setLogined:(BOOL)logined;
+ (BOOL)logined;


@property(nonatomic,assign) int unRdCount_rpy;//回复我的未读数目
@property(nonatomic,assign) int unRdCount_prv;//
@property(nonatomic,assign) int unRdCount_sys;

//回复我的未读数目
+ (void)setCount_rpy:(int)count;
+ (int)count_rpy;

//系统消息未读数目
+ (void)setCount_sys:(int)count;
+ (int)count_sys;

//禁止提示更新的版本号
+ (void)setBanUpdateVersion:(NSString *)version;
+ (NSString *)banUpdateVersion;

//地区
+ (void)setArea_name:(NSString *)area_name;
+ (NSString *)area_name;

+ (void)setArea_id:(NSString *)area_id;
+ (NSString *)area_id;
@end
