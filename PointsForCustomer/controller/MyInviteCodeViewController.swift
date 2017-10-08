//
//  MyInviteCodeViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/10/8.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class MyInviteCodeViewController: BaseViewController {
    @IBOutlet var codeLabel: UILabel!
    @IBOutlet var btn: UIButton!
    convenience init() {
        self.init(nibName: "MyInviteCodeViewController", bundle: nil);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title  = "邀请码"
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 2
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.3).cgColor
        codeLabel.text = PPUserInfoManager.userInfo()!["invitation_code"] as? String
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true);
    }
    @IBAction func fuzhi(_ sender: Any) {
        UIPasteboard.general.string = codeLabel.text
        ProgressHUD.showSuccess("已复制到粘贴板", interaction: false)
    }

}
