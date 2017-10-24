//
//  LoginViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/12.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    
    @IBOutlet var phoneTF: UITextField!
    @IBOutlet var passWordTF: UITextField!
    convenience init() {
        self.init(nibName: "LoginViewController", bundle: nil);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "登录"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "取消", style: UIBarButtonItemStyle.plain, target: self, action: #selector(dis))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true);
    }
    @objc func dis (){
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Navigation
    @IBAction func findPassword(_ sender: Any) {
        let vc = FindPassWordViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func regist(_ sender: Any) {
        let vc = RegistViewController()
        vc.handler = {(_ info) ->Void in
            //注册成功之后的回掉
            self.dismiss(animated: true, completion: nil)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func login(_ sender: Any) {
        if phoneTF.text?.isValidMobileNO() == false {
            ProgressHUD.showError("请输入正确的手机号码", interaction: false)
            return
        }
        if passWordTF.text! == "" || (passWordTF.text?.characters.count)!<6{
            ProgressHUD.showError("请输入至少6位数密码", interaction: false)
            return
        }
        let para = ["mobile":phoneTF.text,
                    "password":passWordTF.text?.md5_32Bit_String(),
            ] as [String : AnyObject]
        ProgressHUD.show(nil, interaction: false)
        PPRequestManager.POST(url: API_USER_LOGIN, para: para, success: { (json) in
            let code = json["code"] as! Int
            let msg = json["msg"] as! String
            if code == 200 {
                ProgressHUD.showSuccess("登录成功", interaction: false)
                let result = json["result"] as! NSDictionary
                PPUserInfoManager.updateUserInfo(info: result)
                PPUserInfoManager.updateIsLogined(logined: true)
                self.perform(#selector(self.successBack), with: nil, afterDelay: 1.2)
            }
            else{
                ProgressHUD.showError(msg, interaction: false)
            }
        }) {
        }
    }
    //    MARK:登录成功跳转
    @objc func successBack()  {
        self.dismiss(animated: true, completion: nil)
    }
    
}
