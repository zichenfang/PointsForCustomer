//
//  PointsDesViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/12/12.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class PointsDesViewController: BaseViewController {
    convenience init() {
        self.init(nibName: "PointsDesViewController", bundle: nil);
    }
    @IBOutlet var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "积分说明";
        self.loadDes();
    }
    //    MARK:获取积分说明
    func loadDes() {
        let para = [:] as [String : AnyObject]
        PPRequestManager.POST(url: API_USER_POINTS_README, para: para, success: { (json) in
            let code = json["code"] as! Int
            let msg = json["msg"] as! String
            if code == 200 {
                let content:String? = json.dictionary_ForKey(key: "result").string_ForKey(key: "content");
                self.webView.loadHTMLString(content!, baseURL: nil);
            }
            else{
                ProgressHUD.showError(msg, interaction: false)
            }
        }) {
        }
    }
}
