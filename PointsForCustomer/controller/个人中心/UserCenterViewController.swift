//
//  UserCenterViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/12.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class UserCenterViewController: BaseViewController , UITableViewDataSource , UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var msgCountLabel: UILabel!//消息数目
    @IBOutlet var avatarIV: UIImageView!//头像
    @IBOutlet var nameLabel: UILabel!//昵称
    @IBOutlet var headBackIV: UIImageView!//头部背景色
    
    var menus :Array<String>!
    convenience init() {
        self.init(nibName: "UserCenterViewController", bundle: nil);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //开局手动刷新一下页面
        userStatusDidChanged()
        tableView.register(UINib.init(nibName: "UserCenterTableViewCell", bundle: nil), forCellReuseIdentifier: "usercenter");
        //添加用户登录状态和信息修改通知
        NotificationCenter.default.addObserver(self, selector: #selector(userInfoDidChanged), name: NOTI_USERINFO_CHANGED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userStatusDidChanged), name: NOTI_USERSTATUS_CHANGED, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(true, animated: true);
    }
//    MARK:用户登录状态和信息修改通知
    @objc func userInfoDidChanged () {
        let nickname = PPUserInfoManager.userInfo()?.value(forKey: "nickname") as! String;
        nameLabel.text = nickname ;
        let avatar = PPUserInfoManager.userInfo()?.value(forKey: "head_img") as! String;
        avatarIV.sd_setImage(with: URL.init(string: avatar), placeholderImage: PLACE_HOLDER_IMAGE_GENERAL)
        self.tableView.contentOffset = CGPoint.init(x: 0, y: 0);
    }
    //MARK:用户登录或者注销之后变更个人中心菜单
    @objc func userStatusDidChanged () {
        if PPUserInfoManager.isLogined() == true {
            userInfoDidChanged()
            menus = ["奖励信息","我的邀请码","分享软件","收藏店铺","修改密码","个人资料","意见反馈","联系我们","注销登录"]
            loadUnReadMessage();//获取一下未读消息
        }
        else{
            nameLabel.text = "登录/注册" ;
            avatarIV.image = PLACE_HOLDER_IMAGE_GENERAL
            menus = ["奖励信息","我的邀请码","分享软件","收藏店铺","修改密码","个人资料","意见反馈","联系我们"]
            self.msgCountLabel.isHidden = true;
        }
        tableView.reloadData()
    }
    //MARK:获取未读消息
    @objc func loadUnReadMessage() {
        let para = ["token":PPUserInfoManager.token()] as [String:AnyObject];
        PPRequestManager.POST(url: API_USER_GET_UNREADMESSAGE, para: para, success: { (json) in
            let code = json["code"] as! Int
            if code == 200 {
                let result = json.dictionary_ForKey(key: "result");
                if let unread :Int = result["unread"] as? Int {
                    if unread == 1 {
                        self.msgCountLabel.isHidden = false;
                    }
                    else{
                        self.msgCountLabel.isHidden = true;
                    }
                }
            }
            else{
                self.msgCountLabel.isHidden = true;
            }
        }) {
        }
    }
    //    MARK:签到
    @IBAction func goSignIn(_ sender: Any) {
        if PPUserInfoManager.isLogined() == false {
            let vc = LoginViewController()
            self.present(UINavigationController.init(rootViewController: vc), animated: true, completion: nil)
            return;
        }
        let para = ["token":PPUserInfoManager.token()] as [String:AnyObject];
        PPRequestManager.POST(url: API_USER_SIGNIN, para: para, success: { (json) in
            let code = json["code"] as! Int
            let msg = json["msg"] as! String;
            if code == 200 {
                let result = json.dictionary_ForKey(key: "result");
                if let get_point :Int = result["get_point"] as? Int {
                    ProgressHUD.showSuccess(String.init(format: "签到成功，获得%d积分", get_point), interaction: false);
                }
            }
            else{
                ProgressHUD.showSuccess(msg, interaction: false);
            }
        }) {
        }

    }
    //    MARK:跳转到消息列表
    @IBAction func goMsg(_ sender: Any) {
        if PPUserInfoManager.isLogined() == false {
            let vc = LoginViewController()
            self.present(UINavigationController.init(rootViewController: vc), animated: true, completion: nil)
        }
        else{
            let vc = MsgListViewController();
            vc.hidesBottomBarWhenPushed = true;
            vc.handler = {(_info) -> Void in
                //刷新未读消息
                self.loadUnReadMessage();
            }
            self.navigationController?.pushViewController(vc, animated: true);
        }
    }
    //    MARK:点击用户头像，进入用户资料
    @IBAction func goUserInfo(_ sender: UITapGestureRecognizer) {
        print("goUserInfo")
        if PPUserInfoManager.isLogined() == false {
            let vc = LoginViewController()
            self.present(UINavigationController.init(rootViewController: vc), animated: true, completion: nil)
        }
        else{
            //进入个人资料页面
            let vc = UserInfoViewController();
            vc.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(vc, animated: true);
        }
    }
    //    MARK:点我的积分(积分纪录)
    @IBAction func goMyPoints(_ sender: Any) {
        if PPUserInfoManager.isLogined() == false {
            let vc = LoginViewController()
            self.present(UINavigationController.init(rootViewController: vc), animated: true, completion: nil)
        }
        else{
            let vc = PointsHistoryViewController();
            vc.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(vc, animated: true);
        }
    }
    //    MARK:积分转增
    @IBAction func goZhuanZengPoints(_ sender: Any) {
        if PPUserInfoManager.isLogined() == false {
            let vc = LoginViewController()
            self.present(UINavigationController.init(rootViewController: vc), animated: true, completion: nil)
        }
        else{
            let vc = TransPointsViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    //    MARK:积分说明
    @IBAction func goPointsReadMe(_ sender: Any) {
        let vc = PointsDesViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    //    MARK:UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :UserCenterTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "usercenter", for: indexPath) as! UserCenterTableViewCell;
        let name =  menus[indexPath.row]
        let imageName = "usercenter_" + name
        cell.IV.image = UIImage.init(named: imageName)
        cell.nameLabel.text = name
        return cell!;
    }
//    MARK:UITableViewDelegate
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = menus[indexPath.row]
        let titles_need_login = ["奖励信息","我的邀请码","收藏店铺","修改密码","我的电话","个人资料"]
        //在需要登录到情况下，判断登录状态
        if titles_need_login.contains(title) && PPUserInfoManager.isLogined() == false {
            let vc = LoginViewController()
            self.present(UINavigationController.init(rootViewController: vc), animated: true, completion: nil)
            return
        }

        switch title {
        // MARK: - 三级分销（奖励信息）
        case "奖励信息":
            let vc = BoundsListViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            // MARK: - 我的邀请码
        case "我的邀请码":
            let vc = MyInviteCodeViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case "注销登录":
            logOut()
        // MARK: - 修改密码
        case "修改密码":
            let vc = ChangePassWordViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            // MARK: - 收藏店铺
        case "收藏店铺":
            let vc = FavShopListViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            // MARK: - 个人资料
        case "个人资料":
            let vc = UserInfoViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case "分享软件":
            // MARK: - 分享软件
            TTUmengManager.shareContent(withTitle: "积分购", url: "http://www.baidu.com/", shareText: "积分购应用", shareImage: PLACE_HOLDER_IMAGE_GENERAL, delegate: nil, inSheetView: self);
        case "联系我们":
            // MARK: - 联系我们
            let service_phone = PPUserInfoManager.userInfo()?.value(forKey: "service_phone") as! String;
            UIApplication.shared.openURL(NSURL(string: "tel://" + service_phone)! as URL);
        case "意见反馈":
            // MARK: - 意见反馈
            let vc = FeedBackViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print("default")
        }
    }
    // MARK: - 注销登录
    func logOut()  {
        let alertVC = UIAlertController.init(title: "确认退出？", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alertVC.addAction(UIAlertAction.init(title: "退出", style: UIAlertActionStyle.destructive, handler: { (act) in
            PPUserInfoManager.updateIsLogined(logined: false)
            let vc = LoginViewController()
            self.present(UINavigationController.init(rootViewController: vc), animated: true, completion: nil)
            NotificationCenter.default.post(name: NOTI_USER_LOGOUT, object: nil);
        }))
        alertVC.addAction(UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
