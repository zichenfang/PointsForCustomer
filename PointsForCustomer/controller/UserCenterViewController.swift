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
    var menus :Array<String>!
    convenience init() {
        self.init(nibName: "UserCenterViewController", bundle: nil);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        menus = ["我的邀请码","收藏店铺","修改密码","我的电话","分享软件","联系我们","注销登录"]
        tableView.register(UINib.init(nibName: "UserCenterTableViewCell", bundle: nil), forCellReuseIdentifier: "usercenter");
        tableView.contentInset = UIEdgeInsets.init(top: -20, left: 0, bottom: 0, right: 0);
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(true, animated: true);
    }
    //    MARK:点击消息
    @IBAction func goMsg(_ sender: Any) {
        print("gomsg")
    }
    //    MARK:点击用户头像，进入用户资料
    @IBAction func goUserInfo(_ sender: UITapGestureRecognizer) {
        print("goUserInfo")
        if TTUserInfoManager.logined() == false {
            let vc = LoginViewController()
            vc.handler = {(_ info :NSDictionary?) -> Void in
                self.nameLabel.text = "登录成功"
            }
            self.present(UINavigationController.init(rootViewController: vc), animated: true, completion: nil)
            return
        }
        else{
            //进入个人资料页面
        }
    }
    //    MARK:点我的积分
    @IBAction func goMyPoints(_ sender: Any) {
        print("goMyPoints")
    }
    //    MARK:积分转增
    @IBAction func goZhuanZengPoints(_ sender: Any) {
        print("goZhuanZengPoints")
    }
    //    MARK:积分说明
    @IBAction func goPointsReadMe(_ sender: Any) {
        print("goPointsReadMe")
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
        // MARK: - 我的邀请码
        // MARK: - 收藏店铺
        // MARK: - 修改密码
        // MARK: - 我的电话
        // MARK: - 分享软件
        // MARK: - 联系我们
        // MARK: - 注销登录
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
