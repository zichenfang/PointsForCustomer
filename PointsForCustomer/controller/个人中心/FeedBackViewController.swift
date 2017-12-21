//
//  FeedBackViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/12/7.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class FeedBackViewController: BaseViewController {
    convenience init() {
        self.init(nibName: "FeedBackViewController", bundle: nil);
    }
    @IBOutlet var contentView: UIView!
    @IBOutlet var inputTV: UITextView!//
    @IBOutlet var placeHolderLabel: UILabel!
    @IBOutlet var inputPhoneTF: UITextField!//输入电话号码
    @IBOutlet var inputMailTF: UITextField!//输入邮箱
    @IBOutlet var phoneLabel: UILabel!//拨打电话
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "意见反馈";
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "常见问题", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goFAQ));
        //添加输入框监控方法
        NotificationCenter.default.addObserver(self, selector: #selector(tvChanged), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        let service_phone = PPUserInfoManager.userInfo()?.value(forKey: "service_phone") as! String;
        phoneLabel.text = "TEL" + service_phone;
    }
    // MARK:输入评论
    @objc func tvChanged (){
        if inputTV.text.characters.count>0 {
            placeHolderLabel.isHidden = true
        }
        else{
            placeHolderLabel.isHidden = false
        }
    }


    //MARK:提交反馈
    @IBAction func save(_ sender: Any) {
        if inputTV.text.characters.count <= 0{
            ProgressHUD.showError("请输入反馈内容");
            return
        }

        var para = ["content":inputTV.text.killEmoji(),
                    "token":PPUserInfoManager.token()] as [String:AnyObject];
        if inputPhoneTF.text!.characters.count > 0{
            para.updateValue(inputPhoneTF.text as AnyObject, forKey: "phone");
        }
        if inputMailTF.text!.characters.count > 0{
            para.updateValue(inputMailTF.text as AnyObject, forKey: "email");
        }

        ProgressHUD.show(nil, interaction: false)
        PPRequestManager.POST(url: API_USER_FEEDBACK, para: para, success: { (json) in
            let code = json["code"] as! Int
            let msg = json["msg"] as! String
            if code == 200 {
                ProgressHUD.showSuccess(msg, interaction: false);
                self.perform(#selector(self.successBack), with: nil, afterDelay: 1.2);
            }
            else{
                let msg = json["msg"] as! String
                ProgressHUD.showError(msg, interaction: false)
            }
        }) {
            ProgressHUD.showError("请求超时，请重试", interaction: false)
        }
    }
    //MARK:拨打电话
    @IBAction func callMeMaybe(_ sender: Any) {
        let service_phone = PPUserInfoManager.userInfo()?.value(forKey: "service_phone") as! String;
        UIApplication.shared.openURL(NSURL(string: "tel://" + service_phone)! as URL);
    }
    @objc func successBack (){
        self.navigationController?.popViewController(animated: true);
    }

    //MARK:常见问题
    @objc func goFAQ (){
        let vc = FAQViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
