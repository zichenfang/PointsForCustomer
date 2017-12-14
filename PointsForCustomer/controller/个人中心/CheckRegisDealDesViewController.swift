//
//  CheckRegisDealDesViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/12/14.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class CheckRegisDealDesViewController: BaseViewController {
    convenience init() {
        self.init(nibName: "CheckRegisDealDesViewController", bundle: nil);
    }
    
    @IBOutlet var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "用户使用协议";
        self.loadUserDealDes();
    }
    func loadUserDealDes() {
        let para = ["figure":"seller"] as [String:AnyObject];
        PPRequestManager.POST(url: API_USER_REGIST_DEAL_DES, para: para, success: { (json) in
            let code = json["code"] as! Int
            let msg = json["msg"] as! String;
            if code == 200 {
                let result = json.dictionary_ForKey(key: "result");
                if let content :String = result["content"] as? String {
                    self.webView.loadHTMLString(content, baseURL: nil);
                }
            }
            else{
                ProgressHUD.showSuccess(msg, interaction: false);
            }
        }) {
        }
        
    }
}
