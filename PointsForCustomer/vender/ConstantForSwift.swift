//
//  ConstantForSwift.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/13.
//  Copyright © 2017年 fff. All rights reserved.
//

/*
 相当于define用法
 */
import UIKit

//MARK: 屏幕
let SCREEN_WIDTH :CGFloat = UIScreen.main.bounds.size.width;
let SCREEN_HEIGHT :CGFloat = UIScreen.main.bounds.size.height;
//MARK: 模拟器检测
struct PLARFORM {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}
//MARK: 高德地图appkey
let AMAP_APPKEY : String = Bundle.main.infoDictionary?["AMAP_APPKEY"] as! String;
let AMAP_PRODUCT_NAME : String = Bundle.main.infoDictionary?["CFBundleName"] as! String;
//默认经纬度为青岛市北区政府，默认城市为青岛
let DEFAULT_LOCATION_LONGITUDE = 120.3748378135;
let DEFAULT_LOCATION_LATITUDE = 36.0876615097;
let DEFAULT_LOCATION_CITYNAME = "青岛";

//MARK: ●通用默认图
let PLACE_HOLDER_IMAGE_GENERAL :UIImage = UIImage.init(named: "placeholderimage")!;
//MARK: ●用户头像默认图
let PLACE_HOLDER_IMAGE_USER :UIImage = UIImage.init(named: "avatarplaceholder")!;


let APP_DELEGATE  = UIApplication.shared.delegate as! AppDelegate;

//MARK: 通知别名 NotificationCenter
//MARK: ●地理位置发生改变的时候（自动获取位置或者手动获取位置成功后）
let NOTI_LOCATION_CHANGED  = NSNotification.Name(rawValue: "pp_noti_001");
//MARK: ●用户信息被修改之后（比如头像或者昵称）
let NOTI_USERINFO_CHANGED  = NSNotification.Name(rawValue: "pp_noti_002");
//MARK: ●用户登录成功或者退出登录
let NOTI_USERSTATUS_CHANGED  = NSNotification.Name(rawValue: "pp_noti_003");
//MARK: ●点击首页右上角扫码动作
let NOTI_INDEX_SCANECODE  = NSNotification.Name(rawValue: "pp_noti_004");
//MARK: ●用户注销登录
let NOTI_USER_LOGOUT  = NSNotification.Name(rawValue: "pp_noti_005");
//MARK: ●跳转到个人中心页面
let NOTI_GO_USERCENTER  = NSNotification.Name(rawValue: "pp_noti_006");

//MARK: 列表页内数据个数
let LIST_PAGESIZE  = 50 ;
//MARK: 短信验证码倒计时
let MESSAGE_CODE_TIMEOUT  = 60 ;

//MARK: 具体接口地址别名
let API_HEADERURL :String = "http://jf.bingplus.com/";
//MARK: ●用户注册
let API_USER_REGISTER :String = "/api.php/v1.Publics/register";
//MARK: ●短信
let API_USER_MESSAGE :String = "/api.php/v1.Publics/sendSms";
//MARK: ●登录
let API_USER_LOGIN :String = "/api.php/v1.Publics/login";
//MARK: ●忘记密码
let API_USER_FINDPASSWORD :String = "/api.php/v1.Publics/retrievePassword";
//MARK: ●获取订单历史
let API_USER_ORDER_HISTORY :String = "/api.php/v1.User/orders";
//MARK: ●积分转赠
let API_USER_TRANS_POINTS :String = "/api.php/v1.User/invitationWithdraw";
//MARK: ●申请退款
let API_USER_ORDER_REFUND :String = "/api.php/v1.User/refund";
//MARK: ●修改密码
let API_USER_CHANGE_PASSWORD :String = "/api.php/v1.User/changePassword";

//MARK: ●轮播图
let API_SHOP_BANNER :String = "/api.php/v1.Index/ads";
//MARK: ●首页分类
let API_SHOP_SUBCLASS :String = "/api.php/v1.Index/category";
//MARK: ●获取商家
let API_SHOP_SHOPS :String = "/api.php/v1.Index/sellers";
//MARK: ●获取商家（没有距离）
let API_SHOP_SHOPS_WITHOUTDISTANCE :String = "/api.php/v1.Index/sellerList";
//MARK: ●获取商家详情
let API_SHOP_SHOPS_DETAIL :String = "/api.php/v1.Index/sellerDetail";
//MARK: ●收藏店铺
let API_SHOP_ADD_FAV :String = "/api.php/v1.User/addCollection";
//MARK: ●取消收藏店铺
let API_SHOP_DELE_FAV :String = "/api.php/v1.User/removeCollection";
//MARK: ●获取收藏店铺状态
let API_SHOP_FAV_STATUS :String = "/api.php/v1.User/isCollection";
//MARK: ●获取收藏店铺列表
let API_SHOP_FAV_LIST :String = "/api.php/v1.User/collections";
//MARK: ●发表评论(图片与其他内容一并提交)
let API_SHOP_ADD_COMMENT :String = "/api.php/v1.User/addCommentIos";
//MARK: ●上传图片（修改头像等）
let API_SHOP_UPLOADIMAGE :String = "/api.php/v1.User/upload";
//MARK: ●扫码支付
let API_SHOP_PAYNOW :String = "/api.php/v1.User/pay";
//MARK: ●商家下面的评论列表
let API_SHOP_COMMENTS :String = "/api.php/v1.Index/Comments";
//MARK: ●修改用户信息
let API_USER_CHANGEINFO :String = "/api.php/v1.User/changeInfo";
//MARK: ●意见反馈
let API_USER_FEEDBACK :String = "/api.php/v1.User/feedback";
//MARK: ●获取常见问题
let API_USER_FAQ_LIST :String = "/api.php/v1.User/FAQs";
//MARK: ●获取未读系统消息
let API_USER_GET_UNREADMESSAGE :String = "/api.php/v1.User/unreadMessages";
//MARK: ●系统消息列表
let API_USER_MESSAGE_LIST :String = "/api.php/v1.User/messages";
//MARK: ●设置消息为已读
let API_USER_READ_MESSAGE :String = "/api.php/v1.User/readMessage";
//MARK: ●获取积分说明
let API_USER_POINTS_README :String = "/api.php/v1.Publics/integralExplain";
//MARK: ●获取账户信息
let API_USER_ACCOUNT_INFO :String = "/api.php/v1.User/account";
//MARK: ●获取积分记录
let API_USER_POINTS_HISTORY :String = "/api.php/v1.User/statement";
//MARK: ●获取邀请统计数据
let API_USER_INVITE_INFO :String = "/api.php/v1.User/inviteStatistics";
//MARK: ●获取邀请列表
let API_USER_INVITE_LIST :String = "/api.php/v1.User/inviteList";
//MARK: ●获取三个评分数据
let API_USER_TRIBLE_SCORE :String = "/api.php/v1.Index/average";
//MARK: ●签到
let API_USER_SIGNIN :String = "/api.php/v1.User/signIn";
//MARK: ●用户协议
let API_USER_REGIST_DEAL_DES :String = "/api.php/v1.Publics/registrationProtocol";
//MARK: ●I获取版本信息
let API_APP_VERSION_INFO :String = "/api.php/v1.Publics/checkVersion";



class ConstantForSwift: NSObject {

}
