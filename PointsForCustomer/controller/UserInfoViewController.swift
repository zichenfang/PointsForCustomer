//
//  UserInfoViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/10/24.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class UserInfoViewController: BaseViewController {
    convenience init() {
        self.init(nibName: "UserInfoViewController", bundle: nil);
    }
    @IBOutlet var nickNameTF: UITextField!
    @IBOutlet var avatarIV: UIImageView!
    var namecache :String!
    var avatarcache :UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title  = "我的信息"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: UIBarButtonItemStyle.plain, target: self, action: #selector(save));
        self.navigationItem.rightBarButtonItem?.isEnabled = false;
        
        let nickname = PPUserInfoManager.userInfo()?.value(forKey: "nickname") as! String;
        nickNameTF.text = nickname ;
        let avatar = PPUserInfoManager.userInfo()?.value(forKey: "head_img") as! String;
        avatarIV.sd_setImage(with: URL.init(string: avatar), placeholderImage: PLACE_HOLDER_IMAGE_GENERAL)
        nickNameTF.addTarget(self, action: #selector(tfChanged(_:)), for: UIControlEvents.allEvents)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true);
    }
    @objc func tfChanged(_ tf:UITextField){
        let input = nickNameTF.text ?? "";
        let nickname = PPUserInfoManager.userInfo()?.value(forKey: "nickname") as! String;
        if input.characters.count>0 && input != nickname {
            self.navigationItem.rightBarButtonItem?.isEnabled = true;
        }
        else{
            self.navigationItem.rightBarButtonItem?.isEnabled = false;
        }
        namecache = input;
    }
    @IBAction func tapAvatarIV(_ sender: Any) {
    }
    @objc func save () {}
}
