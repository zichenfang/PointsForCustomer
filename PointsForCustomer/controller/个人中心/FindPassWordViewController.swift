//
//  FindPassWordViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/10/5.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class FindPassWordViewController: BaseViewController {
    @IBOutlet var phoneTF: UITextField!
    @IBOutlet var codeTF: UITextField!
    @IBOutlet var passWordTF: UITextField!
    @IBOutlet var passWordAgainTF: UITextField!
    //短信倒计时
    @IBOutlet var codeBtn: UIButton!
    var leftCount :Int!
    var msgCode :Int!
    
    convenience init() {
        self.init(nibName: "FindPassWordViewController", bundle: nil);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "忘记密码"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - 获取验证码
    @IBAction func sendCode(_ sender: Any) {
        if phoneTF.text?.isValidMobileNO() == false {
            ProgressHUD.showError("请输入正确的手机号码", interaction: false)
            return
        }
        let para = ["mobile":phoneTF.text ?? ""] as [String : AnyObject]
        ProgressHUD.show(nil, interaction: false)
        PPRequestManager.POST(url: API_USER_MESSAGE, para: para, success: { (json) in
            let code = json["code"] as! Int
            let msg = json["msg"] as! String
            if code == 200 {
                let result = json["result"] as! NSDictionary
                self.msgCode = result["code"] as! Int
                ProgressHUD.showSuccess("短信验证码获取成功", interaction: false)
                self.startTimeLimit()
            }
            else{
                ProgressHUD.showError(msg, interaction: false)
            }
        }) {
        }
    }
    // MARK: - 进入倒计时
    func startTimeLimit() {
        self.codeBtn.isEnabled = false
        self.leftCount = MESSAGE_CODE_TIMEOUT
        let codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
        codeTimer.schedule(deadline: .now(), repeating: .seconds(1))
        codeTimer.setEventHandler(handler: {
            self.leftCount = self.leftCount - 1
            if self.leftCount > 0 {
                let title = String(self.leftCount) + "秒后重新获取"
                DispatchQueue.main.async {
                    self.codeBtn.setTitle(title, for: UIControlState.normal)
                }
            }
            else{
                codeTimer.cancel()
                DispatchQueue.main.async {
                    self.codeBtn.setTitle("重新获取", for: UIControlState.normal)
                    self.codeBtn.isEnabled = true
                }
            }
        })
        codeTimer.resume()
    }
    // MARK: - 找回密码
    @IBAction func sendRequest(_ sender: Any) {
        if phoneTF.text?.isValidMobileNO() == false {
            ProgressHUD.showError("请输入正确的手机号码", interaction: false)
            return
        }
        if Int(codeTF.text!) != self.msgCode{
            ProgressHUD.showError("验证码错误", interaction: false)
            return
        }
        if passWordTF.text! == "" || (passWordTF.text?.characters.count)!<6{
            ProgressHUD.showError("请输入至少6位数密码", interaction: false)
            return
        }
        if passWordTF.text != passWordAgainTF.text {
            ProgressHUD.showError("两次输入密码不一致", interaction: false)
            return
        }
        let para = ["mobile":phoneTF.text,
                    "password":passWordTF.text?.md5_32Bit_String(),
                    "code":codeTF.text
            ] as [String : AnyObject]
        ProgressHUD.show(nil, interaction: false)
        PPRequestManager.POST(url: API_USER_FINDPASSWORD, para: para, success: { (json) in
            let code = json["code"] as! Int
            let msg = json["msg"] as! String
            if code == 200 {
                ProgressHUD.showSuccess("密码修改成功", interaction: false)
                self.perform(#selector(self.successBack), with: nil, afterDelay: 1.2)
            }
            else{
                ProgressHUD.showError(msg, interaction: false)
            }
        }) {
        }
    }
    //    MARK:密码修改成功跳转
    @objc func successBack()  {
        self.navigationController?.popToRootViewController(animated: true)
    }

}
