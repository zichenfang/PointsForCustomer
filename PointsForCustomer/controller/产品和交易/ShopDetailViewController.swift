//
//  ShopDetailViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/20.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit
import MapKit

class ShopDetailViewController: BaseViewController , UITableViewDataSource , UITableViewDelegate , SDCycleScrollViewDelegate {
    //外部传值店铺
    public var shopObj : PPShopObject!
    var favBarItem : UIBarButtonItem!
    //是否已经收藏，默认为否
    var isFav :Bool = false;
    @IBOutlet var tableView: UITableView!
    @IBOutlet var bannerScrollView: SDCycleScrollView!
    @IBOutlet var titleLabel: UILabel! //标题
    @IBOutlet var contentLabel: UILabel! //内容
    @IBOutlet var pointScaleLabel: UILabel! //比例
    @IBOutlet var kdaLabel: UILabel!//评分
    @IBOutlet var commentCountBtn: UIButton!//评论数目
    @IBOutlet var addressLabel: UILabel!//地址
    @IBOutlet var timeDesLabel: UILabel!//营业时间
    @IBOutlet var shiyongDesTV: UITextView!//使用范围
    @IBOutlet var zhizhaoIV: UIImageView!//营业执照
    @IBOutlet var xukezhengIV: UIImageView!//经营许可证

    @IBOutlet var subContentView: UIView!//小星星的父视图，用来批量处理小星星
    //用来适配中间标题+简介view模块的高度，没有用autolayout是因为它报错了
    @IBOutlet var titleViewConstraint: NSLayoutConstraint!
    var shopDetailObj :PPShopDetailobj!
    convenience init() {
        self.init(nibName: "ShopDetailViewController", bundle: nil);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "店铺详情";
        //图文部分，用单文字cell和单图片cell组成
        tableView.register(UINib.init(nibName: "ShopDetailSingleTextTableViewCell", bundle: nil), forCellReuseIdentifier: "shopdetailtext");
        tableView.register(UINib.init(nibName: "ShopDetailSingleImageTableViewCell", bundle: nil), forCellReuseIdentifier: "shopdetailimage");
        prepareFavItem();
        richBannerScrollView();
        //获取店铺详情数据
        loadShopDetailData()
        //获取店铺收藏状态
        loadFavStatus()
        
    }
    //MAR:修改收藏状态按钮
    func prepareFavItem() {
        if isFav == false {
            favBarItem = UIBarButtonItem.init(image: UIImage.init(named: "shoucang"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(add_remove_Fav));
        }
        else {
            favBarItem = UIBarButtonItem.init(image: UIImage.init(named: "yishoucang")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(add_remove_Fav));
        }
        navigationItem.rightBarButtonItem = favBarItem;
    }
    //    MARK:配置轮播图
    func richBannerScrollView() {
        bannerScrollView.delegate = self
        bannerScrollView.backgroundColor = UIColor.white;
        bannerScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        bannerScrollView.currentPageDotColor = UIColor.styleRed(); // 自定义分页控件小圆标颜色
        bannerScrollView.pageDotColor = UIColor.darkGray; //
        bannerScrollView.autoScrollTimeInterval = 4.0;
        bannerScrollView.pageControlBottomOffset = 10;
        bannerScrollView.bannerImageViewContentMode = UIViewContentMode.scaleAspectFill;
    }
//    MARK:获取店铺详情数据
    func loadShopDetailData(){
        let para = ["seller_id":shopObj.id ?? 0]
        PPRequestManager.POST(url: API_SHOP_SHOPS_DETAIL, para: para, success: { (json) in
            let code = json["code"] as! Int
            let msg = json["msg"] as! String
            if code == 200 {
                let result = json["result"] as! NSDictionary
                self.shopDetailObj = PPShopDetailobj.init(info: result)
                self.tableView.reloadData()
                self.updateHeaderUIData()
            }
            else{
                ProgressHUD.showError(msg, interaction: false)
            }
        }) {
        }
    }
    //    MARK:获取收藏状态
    func loadFavStatus(){
        let para = ["token":PPUserInfoManager.token(),
                    "seller_id":shopObj.id!] as [String:AnyObject]
        PPRequestManager.POST(url: API_SHOP_FAV_STATUS, para: para, success: { (json) in
            let code = json["code"] as! Int
            let msg = json["msg"] as! String
            if code == 200 {
                let result = json["result"] as! NSDictionary
                let is_collection = result["is_collection"] as! Bool
                if is_collection == true {
                    self.isFav = true
                }
                else{
                    self.isFav = false
                }
                self.prepareFavItem()
            }
            else{
                ProgressHUD.showError(msg, interaction: false)
            }
        }) {
        }
        
    }
    
//    MARK:更新头部数据（除图文以外的数据）
    func updateHeaderUIData() {
        tableView.beginUpdates()
        bannerScrollView.imageURLStringsGroup = shopDetailObj.images as! [String];
        //测试一下修改headerView高度
        contentLabel.text = shopDetailObj.introduction
        let bannerHeight = SCREEN_WIDTH*7/15
        //标题和描述view的高度
        let titleViewHeight = shopDetailObj.introduction!.heightWithFountAndWidth(font: contentLabel.font, width: SCREEN_WIDTH - 10*2) + 40
        titleViewConstraint.constant = titleViewHeight
        //积分、电话等内容的高度
        let subContentheight :CGFloat = 350
        tableView.tableHeaderView?.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: bannerHeight + titleViewHeight + subContentheight)
        titleLabel.text = shopDetailObj.name;
        pointScaleLabel.text = String.init(format: "积分比例：%d %%", shopDetailObj.integral_ratio!)

        let starValue = shopDetailObj.star!;
        for index in 0...4 {
            let starIV = subContentView.viewWithTag(100 + index) as? UIImageView
            if index+1 <= starValue  {
                starIV!.image = #imageLiteral(resourceName: "xingxing_liang")
            }
            else{
                starIV!.image = #imageLiteral(resourceName: "xingxing_an")
            }
        }
        kdaLabel.text = String.init(format: "%.1f分", shopDetailObj.ave_score!)
        commentCountBtn.setTitle(String.init(format: "%d 评价", shopDetailObj.comment_num!), for: UIControlState.normal)
        addressLabel.text = shopDetailObj.address
        //营业时间和使用范围
        timeDesLabel.text = shopDetailObj.business_hours;
        shiyongDesTV.text = shopDetailObj.use_range;
        //营业执照和经营许可证
        zhizhaoIV.sd_setImage(with: URL.init(string: shopDetailObj.business_license!), placeholderImage: PLACE_HOLDER_IMAGE_GENERAL)
        xukezhengIV.sd_setImage(with: URL.init(string: shopDetailObj.business_permit!), placeholderImage: PLACE_HOLDER_IMAGE_GENERAL)
        tableView.tableFooterView?.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH*1.54);
        tableView.endUpdates()
    }
    //    MARK: 进入评论列表
    @IBAction func goCommentList(_ sender: Any) {
        let vc = CommentListViewController()
        vc.shopObj = shopDetailObj;
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //    MARK: 打电话
    @IBAction func callToShop(_ sender: Any) {
        let phoneUrl = "telprompt://" + shopDetailObj.mobile!
        UIApplication.shared.openURL(URL.init(string: phoneUrl)!)
    }
    //    MARK: 地址导航
    @IBAction func goMap(_ sender: Any) {
        let loc = CLLocationCoordinate2D.init(latitude: shopDetailObj.latitude!, longitude: shopDetailObj.longitude!);
        //检测地图app安装情况
        let alertC = UIAlertController.init(title: "选择", message: nil, preferredStyle: UIAlertControllerStyle.alert);
        //自带apple地图
        alertC.addAction(UIAlertAction.init(title: "Apple地图", style: UIAlertActionStyle.default, handler: { (act) in
            let currentMapItem = MKMapItem.forCurrentLocation();
            let toMapItem = MKMapItem.init(placemark: MKPlacemark.init(coordinate: loc, addressDictionary: nil));
            MKMapItem.openMaps(with: [currentMapItem,toMapItem], launchOptions: [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey:NSNumber.init(value: true)]);
        }));
        if UIApplication.shared.canOpenURL(URL.init(string: "iosamap://")!) {
            //高德地图
            alertC.addAction(UIAlertAction.init(title: "高德地图", style: UIAlertActionStyle.default, handler: { (act) in
                let urlStr = String.init(format: "iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2","积分购","pointsbuy", loc.latitude,loc.longitude).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed);
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL.init(string: urlStr!)!, options: [:], completionHandler: nil);
                } else {
                    UIApplication.shared.openURL(URL.init(string: urlStr!)!);
                }
            }));
        }
        if UIApplication.shared.canOpenURL(URL.init(string: "baidumap://")!) {
            //百度地图
            alertC.addAction(UIAlertAction.init(title: "百度地图", style: UIAlertActionStyle.default, handler: { (act) in
                let urlStr = String.init(format: "baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02", loc.latitude,loc.longitude).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed);
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL.init(string: urlStr!)!, options: [:], completionHandler: nil);
                } else {
                    UIApplication.shared.openURL(URL.init(string: urlStr!)!);
                }
            }));
        }
        if UIApplication.shared.canOpenURL(URL.init(string: "comgooglemaps://")!) {
            //谷歌地图
            alertC.addAction(UIAlertAction.init(title: "Google地图", style: UIAlertActionStyle.default, handler: { (act) in
                let urlStr = String.init(format: "comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving","积分购","pointsbuy", loc.latitude,loc.longitude).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed);
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL.init(string: urlStr!)!, options: [:], completionHandler: nil);
                } else {
                    UIApplication.shared.openURL(URL.init(string: urlStr!)!);
                }
            }));
        }
        
        alertC.addAction(UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: nil));
        self.present(alertC, animated: true, completion: nil);
    }
//    MARK:添加或者删除收藏
    @objc func add_remove_Fav()  {
        //验证登录状态
        if PPUserInfoManager.isLogined() == false {
            let vc = LoginViewController()
            self.present(UINavigationController.init(rootViewController: vc), animated: true, completion: nil)
            return
        }
        var api = ""
        if isFav == false {
            //添加收藏
            api = API_SHOP_ADD_FAV
        }
        else{
            //取消收藏
            api = API_SHOP_DELE_FAV
        }
        let para = ["token":PPUserInfoManager.token(),
                    "seller_id":shopObj.id!] as [String:AnyObject]
        PPRequestManager.POST(url: api, para: para, success: { (json) in
            let code = json["code"] as! Int
            if code == 200 {
                if self.isFav == false {
                    self.isFav = true
                    ProgressHUD.showSuccess("收藏成功", interaction: false)
                    if self.handler != nil{
                        self.handler!(["shop":self.shopObj,"type":"1" as AnyObject]);//type 1:添加收藏
                    }
                }
                else{
                    self.isFav = false
                    ProgressHUD.showSuccess("取消收藏成功", interaction: false)
                    if self.handler != nil{
                        self.handler!(["shop":self.shopObj,"type":"0" as AnyObject]);//type 0:删除收藏
                    }
                }
                self.prepareFavItem()
            }
            else{
                ProgressHUD.showError("操作失败", interaction: false)
            }
        }) {
            ProgressHUD.showError("操作失败", interaction: false)
        }
    }
    //    MARK:UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shopDetailObj == nil {
            return 0
        }
        else{
            return 2
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 /*图片*/{
            let cell :ShopDetailSingleImageTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "shopdetailimage", for: indexPath) as! ShopDetailSingleImageTableViewCell;
            let imgUrl = shopDetailObj.images[indexPath.section] as? String
            cell.imgView.sd_setImage(with: URL.init(string: imgUrl!), placeholderImage: PLACE_HOLDER_IMAGE_GENERAL)
            return cell!;
        }
        else /*文字*/{
            let cell :ShopDetailSingleTextTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "shopdetailtext", for: indexPath) as! ShopDetailSingleTextTableViewCell;
            cell.contentLabel.text = shopDetailObj.desces[indexPath.section] as? String
            return cell!;
        }

    }
    //    MARK:UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        if shopDetailObj == nil {
            return 0
        }
        else{
            return 3
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 /*图片高度*/{
            return SCREEN_WIDTH * 0.8;
        }
        else/*文字高度*/{
            let des = shopDetailObj.desces[indexPath.section] as! String
            let height = des.heightWithFountAndWidth(font: UIFont.systemFont(ofSize: 15), width: SCREEN_WIDTH - 10*2) + 5
            return height;
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let broVC :ImageBrowserVC = ImageBrowserVC.init(links: self.shopDetailObj.images as! [Any], currentIndex: indexPath.section);
            broVC.show();
        }
    }
    // MARK: - SDCycleScrollViewDelegate
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        let broVC :ImageBrowserVC = ImageBrowserVC.init(links: self.shopDetailObj.images as! [Any], currentIndex: index);
        broVC.show();
    }


}
