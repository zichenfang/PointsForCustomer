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
    var avatarUrl_original :String!//原用户头像（
    var avatarUrl_new :String!//用户上传头像成功之后返回的头像地址

    var photoActionSheet :ZLPhotoActionSheet!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title  = "我的信息"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: UIBarButtonItemStyle.plain, target: self, action: #selector(save));
        self.navigationItem.rightBarButtonItem?.isEnabled = false;
        
        let nickname = PPUserInfoManager.userInfo()?.value(forKey: "nickname") as! String;
        nickNameTF.text = nickname ;
        avatarUrl_original = PPUserInfoManager.userInfo()?.value(forKey: "head_img") as! String;
        avatarUrl_new = avatarUrl_original;

        avatarIV.sd_setImage(with: URL.init(string: avatarUrl_original), placeholderImage: PLACE_HOLDER_IMAGE_GENERAL)
        nickNameTF.addTarget(self, action: #selector(tfChanged(_:)), for: UIControlEvents.allEvents)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true);
    }
    @objc func tfChanged(_ tf:UITextField){
        let input = nickNameTF.text ?? "";
        let nickname = PPUserInfoManager.userInfo()?.value(forKey: "nickname") as! String;
        if (input.characters.count>0 && input != nickname) || avatarUrl_new != avatarUrl_original{
            self.navigationItem.rightBarButtonItem?.isEnabled = true;
            if input.characters.count>0 && input != nickname {
                namecache = input;
            }
            else{
                namecache = nil;
            }
        }
        else{
            self.navigationItem.rightBarButtonItem?.isEnabled = false;
        }
    }
    @IBAction func tapAvatarIV(_ sender: Any) {
        photoActionSheet = ZLPhotoActionSheet.init()
        photoActionSheet.navBarColor = UIColor.styleRed()
        photoActionSheet.maxSelectCount = 1
        photoActionSheet.sender = self
        photoActionSheet.allowSelectVideo = false
        photoActionSheet.allowSelectLivePhoto = false
        
        photoActionSheet.transBlock{(images,assets) ->Void in
            if images.count > 0 {
                self.avatarcache = images[0] as! UIImage;
                self.uploadAvatar();
            }
        }
        photoActionSheet.showPhotoLibrary()
    }
    func uploadAvatar() {
        let para = ["token":PPUserInfoManager.token()] as [String:AnyObject]
        ProgressHUD.show(nil, interaction: false)
        PPRequestManager.POST(url: API_SHOP_UPLOADIMAGE, para: para, construct: { (formatData) in
            if self.avatarcache != nil{
                formatData.appendPart(withFileData: UIImagePNGRepresentation(self.avatarcache)!, name: "image", fileName: "pic.png", mimeType: "image/png");
            }
        }, success: { (json) in
            let code = json["code"] as! Int
            let msg = json["msg"] as! String
            if code == 200 {
                ProgressHUD.dismiss();
                let result = json.dictionary_ForKey(key: "result");
                let file = result.string_ForKey(key: "file");
                self.avatarUrl_new = file;
                self.avatarIV.image = self.avatarcache;
                self.navigationItem.rightBarButtonItem?.isEnabled = true;
            }
            else{
                ProgressHUD.showError(msg, interaction: false)
            }
            
        }) {
            ProgressHUD.showError("请求超时，请重试", interaction: false)
        }
    }
    @objc func save () {
        var para = ["token":PPUserInfoManager.token()] as [String:AnyObject];
        if self.namecache != nil {
            para.updateValue(self.namecache as AnyObject, forKey: "nickname");
        }
        if self.avatarUrl_new != nil {
            para.updateValue(self.avatarUrl_new as AnyObject, forKey: "head_img");
        }
        ProgressHUD.show(nil, interaction: false)
        PPRequestManager.POST(url: API_USER_CHANGEINFO, para: para, success: { (json) in
            let code = json["code"] as! Int
            let msg = json["msg"] as! String
            if code == 200 {
                let userInfo :NSMutableDictionary? = NSMutableDictionary.init(dictionary: PPUserInfoManager.userInfo()!);
                if self.namecache != nil {
                    userInfo?.setObject(self.namecache, forKey: "nickname" as NSCopying)
                }
                if self.avatarUrl_new != nil {
                    userInfo?.setObject(self.avatarUrl_new, forKey: "head_img" as NSCopying)
                }
                PPUserInfoManager.updateUserInfo(info: userInfo);
                
                ProgressHUD.showSuccess("修改成功", interaction: false)
                self.perform(#selector(self.changeInfoSucccess), with: nil, afterDelay: 1.2)
            }
            else{
                ProgressHUD.showError(msg, interaction: false)
            }

        }) {
            ProgressHUD.showError("请求超时，请重试", interaction: false)
        }

    }
    @objc func changeInfoSucccess () {
        self.navigationController?.popViewController(animated: true);
    }
}
