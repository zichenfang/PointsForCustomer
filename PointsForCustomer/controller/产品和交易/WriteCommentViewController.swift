//
//  WriteCommentViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/10/9.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class WriteCommentViewController: BaseViewController ,UMSocialUIDelegate{
    convenience init(){
        self.init(nibName: "WriteCommentViewController", bundle: nil)
    }
    public var shop_id :Int?
    var uploadImages :[UIImage]?//上传图片数组
    var selectedAssets = NSMutableArray()//已选择的图片数组
    var photoActionSheet :ZLPhotoActionSheet!
    var kda_zonghe : Int = 5 //综合评分
    var kda_fuwu : Int = 5 //服务评分
    var kda_chanpin : Int = 5 //产品评分
    var kda_huanjing : Int = 5 //环境评分
    public var sAlertView :ShareAlertView!

    

    @IBOutlet var placeHolderTV: UITextView!//用于显示placeholder的textview，因为要保持跟commentTV一致，所以用了UITextView
    @IBOutlet var commentTV: UITextView!//输入评论内容
    //承载三个插图的 view视图
    @IBOutlet var insertImagesParentView: UIView!
    @IBOutlet var textParentViewHeightConstraint: NSLayoutConstraint!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "发表评论"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "完成", style: UIBarButtonItemStyle.plain, target: self, action: #selector(resignKeyBoard))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "取消", style: UIBarButtonItemStyle.plain, target: self, action: #selector(dis))

        //添加输入框监控方法
        NotificationCenter.default.addObserver(self, selector: #selector(tvChanged), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        
    }
//    MARK:取消评论
    @objc func dis (){
        let alertC = UIAlertController.init(title: "是否放弃评论？", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alertC.addAction(UIAlertAction.init(title: "放弃", style: UIAlertActionStyle.default, handler: { (act) in
            self.dismiss(animated: true, completion: nil)
            if self.handler != nil{
                self.handler!([:])
            }
        }))
        alertC.addAction(UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alertC, animated: true, completion: nil)
    }
    @objc func resignKeyBoard (){
        commentTV.resignFirstResponder()
    }
    // MARK:输入评论
    @objc func tvChanged (){
        if commentTV.text.characters.count>0 {
            placeHolderTV.isHidden = true
        }
        else{
            placeHolderTV.isHidden = false
        }
        var commentHeight = commentTV.contentSize.height
        if commentHeight < 95 {
            commentHeight = 95
        }
        if commentHeight > 200 {
            commentHeight = 200
        }
        textParentViewHeightConstraint.constant = commentHeight
    }
    //    MARK:插入图片
    @IBAction func addImages(_ sender: Any) {
        photoActionSheet = ZLPhotoActionSheet.init()
        photoActionSheet.navBarColor = UIColor.styleRed()
        photoActionSheet.maxSelectCount = 3
        photoActionSheet.sender = self
        photoActionSheet.allowSelectVideo = false
        photoActionSheet.allowSelectLivePhoto = false
        photoActionSheet.arrSelectedAssets = self.selectedAssets

        photoActionSheet.transBlock{(images,assets) ->Void in
            self.uploadImages = images as? [UIImage]
            if assets.count>0{
                self.selectedAssets.removeAllObjects()
                self.selectedAssets.addObjects(from: assets)
                self.updateInsertImagesUI()
            }
        }
        photoActionSheet.showPhotoLibrary()

    }
    //    MARK:更新插图UI
    func updateInsertImagesUI(){
        for index in 100...102{
            let itemView = insertImagesParentView.viewWithTag(index)
            let iv = itemView?.viewWithTag(10) as! UIImageView
            if index - 100 < (self.uploadImages?.count)!{
                iv.image = uploadImages?[index - 100]
                iv.isHidden = false
            }
            else if index - 100 == (self.uploadImages?.count)!{
                iv.image = UIImage.init(named: "zhaoxiangji")//点击上传图片
                iv.isHidden = false
            }
            else{
                iv.isHidden = true
            }
        }
    }
    // MARK:长按删除图片
    @IBAction func longPressForDeleteImage(_ sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.ended {
//            let point = sender.location(in: sender.view)
//            let index = Int(point.x/(SCREEN_WIDTH/3))
        }
    }
    // MARK:选择星星等级(综合评分)
    @IBAction func tapForStar_zonghe(_ sender: UITapGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.ended {
            let point = sender.location(in: sender.view)
            kda_zonghe = Int(point.x/40) + 1 //单个星星的宽度为40
            //更改星星亮和暗
            for index in 0...4 {
                let starIV = sender.view?.viewWithTag(100+index) as! UIImageView
                if index < kda_zonghe{
                    starIV.image = UIImage.init(named: "daxingxinghuang");
                }
                else{
                    starIV.image = UIImage.init(named: "daxingxinghui");
                }
            }
        }
    }
    // MARK:选择星星等级(服务评分)
    @IBAction func tapForStar_fuwu(_ sender: UITapGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.ended {
            let point = sender.location(in: sender.view)
            kda_fuwu = Int(point.x/27) + 1 //单个星星的宽度为40
            //更改星星亮和暗
            for index in 0...4 {
                let starIV = sender.view?.viewWithTag(100+index) as! UIImageView
                if index < kda_fuwu{
                    starIV.image = UIImage.init(named: "xiaolian_huang");
                }
                else{
                    starIV.image = UIImage.init(named: "xiaolian_hui");
                }
            }
        }
        
    }
    // MARK:选择星星等级(产品评分)
    @IBAction func tapForStar_chanpin(_ sender: UITapGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.ended {
            let point = sender.location(in: sender.view)
            kda_chanpin = Int(point.x/27) + 1 //单个星星的宽度为40
            //更改星星亮和暗
            for index in 0...4 {
                let starIV = sender.view?.viewWithTag(100+index) as! UIImageView
                if index < kda_chanpin{
                    starIV.image = UIImage.init(named: "xiaolian_huang");
                }
                else{
                    starIV.image = UIImage.init(named: "xiaolian_hui");
                }
            }
        }
        
    }
    // MARK:选择星星等级(环境评分)
    @IBAction func tapForStar_huanjing(_ sender: UITapGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.ended {
            let point = sender.location(in: sender.view)
            kda_huanjing = Int(point.x/27) + 1 //单个星星的宽度为40
            //更改星星亮和暗
            for index in 0...4 {
                let starIV = sender.view?.viewWithTag(100+index) as! UIImageView
                if index < kda_huanjing{
                    starIV.image = UIImage.init(named: "xiaolian_huang");
                }
                else{
                    starIV.image = UIImage.init(named: "xiaolian_hui");
                }
            }
        }
        
    }

    // MARK: - 发布评价
    @IBAction func save(_ sender: Any) {
        if shop_id! <= 0{
            ProgressHUD.showError("店铺信息错误")
            return
        }
        if commentTV.text.characters.count<5{
            ProgressHUD.showError("请输入不少于5个字的内容")
            return
        }
        let para = ["comment":self.commentTV.text.killEmoji(),
                    "score":NSNumber.init(value: kda_zonghe),
                    "server_score":NSNumber.init(value: kda_fuwu),
                    "product_score":NSNumber.init(value: kda_chanpin),
                    "milieu_score":NSNumber.init(value: kda_huanjing),
                    "seller_id":shop_id!,
                    "token":PPUserInfoManager.token()] as [String:AnyObject]
        //测试发表评价
        ProgressHUD.show(nil, interaction: false)
        PPRequestManager.POST(url: API_SHOP_ADD_COMMENT, para: para, construct: { (formatData) in
            if self.uploadImages != nil{
                var index = 1
                for img in self.uploadImages!{
                    let imgName = String.init(format: "image%d", index)
                    formatData.appendPart(withFileData: UIImagePNGRepresentation(img)!, name: imgName, fileName: "pic.png", mimeType: "image/png")
                    index = index + 1
                }
            }
        }, success: { (json) in
            let code = json["code"] as! Int
            if code == 200 {
                self.showShareAlertView();
                ProgressHUD.dismiss();
            }
            else{
                let msg = json["msg"] as! String
                ProgressHUD.showError(msg, interaction: false)
            }

        }) {
            ProgressHUD.showError("请求超时，请重试", interaction: false)
        }
    }

    //MARK:show alert
    func showShareAlertView() {
        sAlertView = Bundle.main.loadNibNamed("ShareAlertView", owner: self, options: nil)?.first as? ShareAlertView;
        sAlertView?.frame = UIScreen.main.bounds;
        UIApplication.shared.keyWindow?.addSubview(sAlertView!);
        sAlertView?.cancelBtn.addTarget(self, action: #selector(cancelShareApp(_sender:)), for: UIControlEvents.touchUpInside)
        sAlertView?.shareBtn.addTarget(self, action: #selector(shareAPP(_sender:)), for: UIControlEvents.touchUpInside)
    }
    //MARK:取消分享
    @objc func cancelShareApp(_sender:UIButton) {
        self.goPointsHistory();
    }
    //MARK:分享 app
    @objc func shareAPP(_sender:UIButton) {
        _sender.superview?.superview?.removeFromSuperview();
        TTUmengManager.shareContent(withTitle: "大哲扣", url: "http://www.baidu.com/", shareText: "大哲扣", shareImage: PLACE_HOLDER_IMAGE_GENERAL, delegate: self, inSheetView: self);
    }
    //    MARK:跳转到积分记录页面
    @objc func goPointsHistory()  {
        sAlertView.removeFromSuperview();
        let vc = PointsHistoryViewController();
        vc.handler = {(_ info) -> Void in
            //从积分记录页面返回回来之后，发送通知，跳转到个人中心
            if self.handler != nil {
                self.handler!([:]);
            }
            self.dismiss(animated: true, completion: nil);
            NotificationCenter.default.post(name: NOTI_GO_USERCENTER, object: nil)
        }
        self.navigationController?.pushViewController(vc, animated: true);
    }
    //MARK:友盟分享回调
    func didFinishGetUMSocialData(inViewController response: UMSocialResponseEntity!) {
        if response.responseCode == UMSResponseCodeSuccess {
            ProgressHUD.showSuccess("分享成功！");
            self.goPointsHistory();
        }
        else{
            ProgressHUD.showError("分享失败！");
            self.showShareAlertView();
        }
    }
    func didCloseUIViewController(_ fromViewControllerType: UMSViewControllerType) {
        self.showShareAlertView();
    }
}
