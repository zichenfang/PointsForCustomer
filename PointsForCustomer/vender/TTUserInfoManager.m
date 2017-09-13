//
//  UserInfoManager.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "TTUserInfoManager.h"
#import "JsonKillNull.h"
#import "TTRequestOperationManager.h"


NSString *const UserInfo = @"UserInfo_userinfo";
//是否启动过APP
NSString *const AppHasLaunched = @"AppHasLaunched";
//登录状态
NSString *const Logined = @"Logined";
//锁屏密码
NSString *const screenPassword = @"screenPassword";
//登录状态
NSString *const NotiClosed = @"NotiClosed";

//回复我的 未读消息数目
NSString *const Count_rpy = @"Count_rpy";

//系统消息 未读消息数目
NSString *const Count_sys = @"Count_sys";

//禁止提示更新的版本号
NSString *const ban_update_version = @"ban_update_version";
@interface TTUserInfoManager()
@property(nonatomic, strong)NSDictionary *userInfo;
@end
@implementation TTUserInfoManager


+ (TTUserInfoManager *)defaultManager {
    static TTUserInfoManager *manager = nil;
    if (!manager) {
        manager = [[TTUserInfoManager alloc] init];
        manager.userInfo =[[NSUserDefaults standardUserDefaults] objectForKey:UserInfo];

    }
    return manager;
}
#pragma mark -用户信息
//用户信息
- (void)setUserInfo:(NSDictionary *)userInfo
{
    if (userInfo) {
        [[NSUserDefaults standardUserDefaults] setObject:[userInfo noNullObject] forKey:UserInfo];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _userInfo = userInfo;
    }
}

+ (void)setUserInfo:(NSDictionary *)userInfo
{
    [[TTUserInfoManager defaultManager]setUserInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoti_userStatsChanged object:nil];
}

+ (NSDictionary *)userInfo
{
    return [[TTUserInfoManager defaultManager] userInfo];
}

//用户账户
- (void)setAccount:(NSString *)account
{
    if (account!=nil) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:UserInfo]];
        [dic setObject:account forKey:@"account"];
        [TTUserInfoManager setUserInfo:dic];
    }
}
+ (void)setAccount:(NSString *)account
{
    [[TTUserInfoManager defaultManager]setAccount:account];
}
+ (NSString *)account
{
    return [[[TTUserInfoManager defaultManager] userInfo] string_ForKey:@"account"];
}
+ (NSString *)token
{
    return [[[TTUserInfoManager defaultManager] userInfo] string_ForKey:@"token"];
}
//用户密码
- (void)setPassword:(NSString *)password
{
    if (password!=nil) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:UserInfo]];
        [dic setObject:password forKey:@"password"];
        [TTUserInfoManager setUserInfo:dic];
    }
}
+ (void)setPassword:(NSString *)password
{
    [[TTUserInfoManager defaultManager]setPassword:password];
}
+ (NSString *)password
{
    return [[[TTUserInfoManager defaultManager] userInfo] string_ForKey:@"password"];
}
#pragma mark -系统信息
//系统是否第一次启动
+ (void)setAppHasLaunched:(BOOL)launched
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",launched] forKey:AppHasLaunched];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)appHasLaunched
{
    return [[[NSUserDefaults standardUserDefaults] stringForKey:AppHasLaunched] boolValue];
}

//登录状态
+ (void)setLogined:(BOOL)logined
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",logined] forKey:Logined];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoti_userStatsChanged object:nil];
}

+ (BOOL)logined
{
    return [[[NSUserDefaults standardUserDefaults] stringForKey:Logined] boolValue];
}





//回复我的未读数目
+ (void)setCount_rpy:(int)count
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",count] forKey:Count_rpy];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
+ (int)count_rpy
{
    return [[[NSUserDefaults standardUserDefaults] stringForKey:Count_rpy] intValue];

}
//系统消息未读数目
+ (void)setCount_sys:(int)count
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",count] forKey:Count_sys];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (int)count_sys
{
    return [[[NSUserDefaults standardUserDefaults] stringForKey:Count_sys] intValue];

}

//禁止提示更新的版本号
+ (void)setBanUpdateVersion:(NSString *)version
{
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:ban_update_version];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
+ (NSString *)banUpdateVersion
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:ban_update_version];
}


+ (void)setArea_name:(NSString *)area_name
{
    [[NSUserDefaults standardUserDefaults] setObject:area_name forKey:@"area_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)area_name
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"area_name"];
}

+ (void)setArea_id:(NSString *)area_id
{
    [[NSUserDefaults standardUserDefaults] setObject:area_id forKey:@"area_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)area_id
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"area_id"];
}

@end
