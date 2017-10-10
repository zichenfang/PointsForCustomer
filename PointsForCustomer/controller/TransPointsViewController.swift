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
    var lastPoints :Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "积分转赠"
        lastPoints = 10
        lastPointsLabel.text = String.init(format: "账户当前剩余%d积分", lastPoints)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true);
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
                    "remark":"备注"] as [String:AnyObject]
        PPRequestManager.GET(url: API_USER_TRANS_POINTS, para: para, success: { (json) in
            let code = json["code"] as! Int
            let msg = json["msg"] as! String
            if code == 200 {
                ProgressHUD.showSuccess("转赠成功", interaction: false)
                self.perform(#selector(self.tranSuccess), with: nil, afterDelay: 1.2)
            }
            else{
                ProgressHUD.showError(msg, interaction: false)
            }
        }) {
            ProgressHUD.showError("请求错误，请重试", interaction: false)
        }
    }
    //    MARK:支付成功，跳转到评论页面
    @objc func tranSuccess()  {
        self.navigationController?.popToRootViewController(animated: false)
    }

}
