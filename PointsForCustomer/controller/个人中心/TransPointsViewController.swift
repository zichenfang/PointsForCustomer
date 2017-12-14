//
//  TransPointsViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/10/10.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class TransPointsViewController: BaseViewController {
    convenience init() {
        self.init(nibName: "TransPointsViewController", bundle: nil);
    }
    @IBOutlet var phoneTF: UITextField!
    @IBOutlet var pointsTF: UITextField!
    @IBOutlet var loginPWTF: UITextField!
    @IBOutlet var lastPointsLabel: UILabel!//剩余积分
    
    @IBOutlet var saveBtn: UIButton!//再未获取到账户信息时，禁用掉此按钮
    var lastPoints :Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "积分转赠"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "转赠记录", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goTransHistory));
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.saveBtn.isEnabled = false;
        self.loadAccountInfo();
    }
    // MARK: - 获取账户信息（这里会用到积分余额）
    func loadAccountInfo() {
        let para = ["token":PPUserInfoManager.token()] as [String : AnyObject]
        ProgressHUD.show(nil, interaction: false)
        PPRequestManager.POST(url: API_USER_ACCOUNT_INFO, para: para, success: { (json) in
            ProgressHUD.dismiss();
            let code = json["code"] as! Int
            let msg = json["msg"] as! String
            if code == 200 {
                let result = json.dictionary_ForKey(key: "result");
                if let integral_balance :Int = result["integral_balance"] as? Int {
                    if integral_balance > 0 {
                        self.lastPoints = integral_balance;
                        self.saveBtn.isEnabled = true;
                        self.lastPointsLabel.text = String.init(format: "账户当前剩余%d积分", self.lastPoints)
                    }
                }
            }
            else{
                ProgressHUD.showError(msg, interaction: false)
            }
        }) {
        }
    }
    // MARK: - 转赠
    @IBAction func transNow(_ sender: Any) {
        if phoneTF.text?.isValidMobileNO() == false{
            ProgressHUD.showError("手机号格式不正确", interaction: false)
            return
        }
        if pointsTF.text == nil || pointsTF.text == ""{
            ProgressHUD.showError("请输入转赠金额", interaction: false)
            return
        }
        if Int(pointsTF.text!)! > lastPoints {
            ProgressHUD.showError("您的积分余额不足", interaction: false)
            return
        }
        if loginPWTF.text == nil || loginPWTF.text == ""{
            ProgressHUD.showError("请输入登录密码", interaction: false)
            return
        }
        let alertC = UIAlertController.init(title: "确认转赠？", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alertC.addAction(UIAlertAction.init(title: "转赠", style: UIAlertActionStyle.default, handler: { (act) in
            self.requestTrans()
        }))
        alertC.addAction(UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alertC, animated: true, completion: nil)
    }
    // MARK: - 转赠请求
    func requestTrans()  {
        ProgressHUD.show(nil, interaction: false)
        let para = ["token":PPUserInfoManager.token(),
                    "tomobile":phoneTF.text!,
                    "amount":Int(pointsTF.text!)!,
                    "remark":"备注",
                    "password":self.loginPWTF.text!.md5_32Bit_String()] as [String:AnyObject];
        PPRequestManager.POST(url: API_USER_TRANS_POINTS, para: para, success: { (json) in
            let code = json["code"] as! Int
            let msg = json["msg"] as! String
            if code == 200 {
                ProgressHUD.showSuccess("转赠成功", interaction: false)
            }
            else{
                ProgressHUD.showError(msg, interaction: false)
            }
        }) {
            ProgressHUD.showError("请求错误，请重试", interaction: false)
        }
    }
    //    MARK:转赠成功之后的回掉
    @objc func tranSuccess()  {
        self.loadAccountInfo();
    }
    //    MARK:查看转赠记录
    @objc func goTransHistory()  {
        let vc = TransPointsHistoryViewController();
        self.navigationController?.pushViewController(vc, animated: true);
    }

}
