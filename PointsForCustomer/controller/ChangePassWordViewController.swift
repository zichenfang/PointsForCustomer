//
//  ChangePassWordViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/10/11.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class ChangePassWordViewController: BaseViewController {
    convenience init() {
        self.init(nibName: "ChangePassWordViewController", bundle: nil);
    }
    @IBOutlet var oldPWTF: UITextField!
    @IBOutlet var lastPWTF: UITextField!
    @IBOutlet var lastPWAgainTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "修改密码"
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true);
    }
    @IBAction func changeNow(_ sender: Any) {
        if oldPWTF.text == nil || (oldPWTF.text?.characters.count)!<6{
            ProgressHUD.showError("请输入至少6位数旧密码", interaction: false)
            return
        }
        if lastPWTF.text == nil || (lastPWTF.text?.characters.count)!<6{
            ProgressHUD.showError("请输入至少6位数新密码", interaction: false)
            return
        }
        if lastPWTF.text != lastPWAgainTF.text{
            ProgressHUD.showError("两次输入新密码不一致，请重新输入", interaction: false)
            return
        }
        let para = ["token":PPUserInfoManager.token(),
                    "old_password":oldPWTF.text?.md5_32Bit_String(),
                    "new_password":lastPWAgainTF.text?.md5_32Bit_String()] as [String : AnyObject]
        ProgressHUD.show(nil)
        PPRequestManager.POST(url: API_USER_CHANGE_PASSWORD, para: para, success: { (json) in
            let code = json["code"] as! Int
            let msg = json["msg"] as! String
            if code == 200 {
                ProgressHUD.showSuccess("修改成功", interaction: false)
                self.perform(#selector(self.changePWSuccess), with: nil, afterDelay: 1.2)
            }
            else{
                ProgressHUD.showError(msg, interaction: false)
            }
        }) {
            ProgressHUD.showError("修改失败，请重试", interaction: false)
        }
    }
    @objc func changePWSuccess () {
        self.navigationController?.popToRootViewController(animated: true)
    }

}
