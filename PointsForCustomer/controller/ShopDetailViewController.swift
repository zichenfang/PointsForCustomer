//
//  ShopDetailViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/20.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class ShopDetailViewController: BaseViewController , UITableViewDataSource , UITableViewDelegate , SDCycleScrollViewDelegate {
    var favBarItem : UIBarButtonItem!
    //是否已经收藏，默认为否
    var isFav :Bool = false;
    @IBOutlet var tableView: UITableView!
    @IBOutlet var phoneBtnWidthConstraint: NSLayoutConstraint!
    @IBOutlet var bannerScrollView: SDCycleScrollView!
    @IBOutlet var titleLabel: UILabel! //标题
    @IBOutlet var contentLabel: UILabel! //内容
    @IBOutlet var pointScaleLabel: UILabel! //比例
    @IBOutlet var kpiLabel: UILabel!//评分
    @IBOutlet var commentCountBtn: UIButton!//评论数目
    @IBOutlet var addressLabel: UILabel!//地址
    @IBOutlet var subContentView: UIView!//小星星的父视图，用来批量处理小星星
    
    
    convenience init() {
        self.init(nibName: "ShopDetailViewController", bundle: nil);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "店铺详情";
        tableView.register(UINib.init(nibName: "ShopDetailSingleTextTableViewCell", bundle: nil), forCellReuseIdentifier: "shopdetailtext");
        tableView.register(UINib.init(nibName: "ShopDetailSingleImageTableViewCell", bundle: nil), forCellReuseIdentifier: "shopdetailimage");

        prepareFavItem();
        richBannerScrollView();
        updateHeaderUIData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        //修改打电话按钮的宽度
        phoneBtnWidthConstraint.constant = SCREEN_WIDTH * 0.226
        
        
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
    //    MARK:配置轮播图哦
    func richBannerScrollView() {
        bannerScrollView.backgroundColor = UIColor.yellow;
        bannerScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        bannerScrollView.currentPageDotColor = UIColor.styleRed(); // 自定义分页控件小圆标颜色
        bannerScrollView.pageDotColor = UIColor.darkGray; //
        bannerScrollView.autoScrollTimeInterval = 4.0;
        bannerScrollView.pageControlBottomOffset = 10;
        bannerScrollView.bannerImageViewContentMode = UIViewContentMode.scaleAspectFill;
    }

//    MARK:更新头部数据（除图文以外的数据）
    func updateHeaderUIData() {
        tableView.beginUpdates()
        bannerScrollView.imageURLStringsGroup = ["https://wx1.sinaimg.cn/mw690/7049c17bly1fjzdk2h2hcj20u011ik0a.jpg","https://wx4.sinaimg.cn/mw690/7049c17bly1fjzdk280zgj20k00k0mze.jpg","https://wx4.sinaimg.cn/mw690/006mSd2Lgy1fjzjvagg0cj30hs10l10r.jpg"];
        
        //测试一下修改headerView高度
        let contentForTest = "经过休赛期的运作，骑士队阵容中新面孔不少。你认为这套阵容是否变更强了？他们能在新赛季走多远？#"
        contentLabel.text = contentForTest
        let contentHeight = contentForTest.heightWithFountAndWidth(font: contentLabel.font, width: SCREEN_WIDTH - 10*2) + 405
        tableView.tableHeaderView?.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: contentHeight)
        titleLabel.text = "#NBA酷图# ";
        pointScaleLabel.text = "积分比例" + "5" + "%"
        let kpi = 3;
        for index in 0...4 {
            let starIV = subContentView.viewWithTag(100 + index) as? UIImageView
            if index+1 <= kpi  {
                starIV!.image = #imageLiteral(resourceName: "xingxing_liang")
            }
            else{
                starIV!.image = #imageLiteral(resourceName: "xingxing_an")
            }
        }
        kpiLabel.text = "5.0" + "分"
        commentCountBtn!.titleLabel?.text = "213" + "评论"
        addressLabel.text = "山东省青岛市市北区福州南路117号"
        tableView.endUpdates()
    }
    //    MARK: 进入评论列表
    @IBAction func goCommentList(_ sender: Any) {
        print("goCommentList")
    }
    
    //    MARK: 打电话
    @IBAction func callToShop(_ sender: Any) {
        print("call me maybe !")
    }
    //    MARK: 地址导航
    @IBAction func goMap(_ sender: Any) {
        print("goMap")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    MARK:添加或者删除收藏
    @objc func add_remove_Fav()  {
        if isFav == false {
            //添加收藏
            isFav = true;
        }
        else{
            //取消收藏
            isFav = false;
        }
        //数据请求
        //更新UI
        prepareFavItem();
        
    }
    //    MARK:UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 /*文字*/{
            let cell :ShopDetailSingleTextTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "shopdetailtext", for: indexPath) as! ShopDetailSingleTextTableViewCell;
            cell.contentLabel.text = "所有人处在巅峰状态时有一拼，现在已被后浪拍在沙滩上所有人处在巅峰状态时有一拼，现在已被后浪拍在沙滩上所有人处在巅峰状态时有一拼，现在已被后浪拍在沙滩上所有人处在巅峰状态时有一拼，现在已被后浪拍在沙滩上所有人处在巅峰状态时有一拼，现在已被后浪拍在沙滩上所有人处在巅峰状态时有一拼，现在已被后浪拍在沙滩上所有人处在巅峰状态时有一拼，现在已被后浪拍在沙滩上所有人处在巅峰状态时有一拼，现在已被后浪拍在沙滩上所有人处在巅峰状态时有一拼，现在已被后浪拍在沙滩上"
            return cell!;
        }
        else /*图片*/{
            let cell :ShopDetailSingleImageTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "shopdetailimage", for: indexPath) as! ShopDetailSingleImageTableViewCell;
            cell.imgView.sd_setImage(with: URL.init(string: "https://wx2.sinaimg.cn/mw690/0069ptwkly1fger3k2lk3j30ku0kujwp.jpg"), placeholderImage: PLACE_HOLDER_IMAGE)
            return cell!;
        }

    }
    //    MARK:UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0/*文字高度*/ {
            return 100;
        }
        else/*图片高度*/{
            return SCREEN_WIDTH * 0.8;
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
    }
    // MARK: - SDCycleScrollViewDelegate
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        print(index);
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
