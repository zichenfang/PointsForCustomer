//
//  CommentListViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/29.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class CommentListViewController: BaseViewController , UITableViewDataSource , UITableViewDelegate{
    //外部传值店铺,店铺的详细信息
    public var shopObj : PPShopDetailobj!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var fuwuView: UIView!//服务
    @IBOutlet var fuwuPointsLabel: UILabel!
    @IBOutlet var chanpinView: UIView!//产品
    @IBOutlet var chanpinPointsLabel: UILabel!
    @IBOutlet var huanjingView: UIView!//环境
    @IBOutlet var huanjingPointsLabel: UILabel!
    var huanjingScore: Float! = 0;
    var fuwuScore: Float! = 0;
    var chanpinScore: Float! = 0;

    //评价列表数据
    var commentDatas = NSMutableArray() as! [PPCommentObj];
    //商家列表分页页码
    var page :Int = 1;
    convenience init() {
        self.init(nibName: "CommentListViewController", bundle: nil);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "评价";
        configTableView()
        loadCommentData()
        loadTribleScore();
    }
    //MARK:配置tableview下拉刷新，cell ，contentInset
    func configTableView()  {
        tableView.register(UINib.init(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "comment");
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.page = 1
            self.loadCommentData()
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page = self.page + 1
            self.loadCommentData()
        })

    }
    //    MARK:获取评价三个评分数据
    func loadTribleScore() {
        let para = ["seller_id":shopObj.id!] as [String : AnyObject]
        
        PPRequestManager.POST(url: API_USER_TRIBLE_SCORE, para: para, success: { (json) in
            let code = json["code"] as! Int
            if code == 200 {
                let result = json.dictionary_ForKey(key: "result");
                if let server_average :String = result["server_average"] as? String {
                    self.fuwuScore = Float(server_average);
                }
                if let product_average :String = result["product_average"] as? String  {
                    self.chanpinScore = Float(product_average);
                }
                if let milieu_average :String = result["milieu_average"] as? String  {
                    self.huanjingScore = Float(milieu_average);
                }
                self.unpdateTribleScoreUI();
            }
            else{
            }
        }) {
        }
    }
    //MARK:更新三个评分UI
    func unpdateTribleScoreUI()  {
        //将三个评分赋值到当前页面
        //服务
        for index in 0...4 {
            let starIV = fuwuView.viewWithTag(100+index) as! UIImageView
            if index < (Int)(self.fuwuScore){
                starIV.image = UIImage.init(named: "xiaolian_huang");
            }
            else{
                starIV.image = UIImage.init(named: "xiaolian_hui");
            }
        }
        self.fuwuPointsLabel.text = String.init(format: "%.1f分", self.fuwuScore);
        //产品
        for index in 0...4 {
            let starIV = chanpinView.viewWithTag(100+index) as! UIImageView
            if index < (Int)(self.chanpinScore){
                starIV.image = UIImage.init(named: "xiaolian_huang");
            }
            else{
                starIV.image = UIImage.init(named: "xiaolian_hui");
            }
        }
        self.chanpinPointsLabel.text = String.init(format: "%.1f分", self.chanpinScore);
        //环境
        for index in 0...4 {
            let starIV = huanjingView.viewWithTag(100+index) as! UIImageView
            if index < (Int)(self.huanjingScore){
                starIV.image = UIImage.init(named: "xiaolian_huang");
            }
            else{
                starIV.image = UIImage.init(named: "xiaolian_hui");
            }
        }
        self.huanjingPointsLabel.text = String.init(format: "%.1f分", self.huanjingScore);
    }
    //    MARK:获取评价列表数据
    func loadCommentData() {
        let para = ["seller_id":shopObj.id!,
                    "p":page,
                    "pagesize":LIST_PAGESIZE] as [String : AnyObject]
        
        PPRequestManager.POST(url: API_SHOP_COMMENTS, para: para, success: { (json) in
            if self.page == 1{
                self.tableView.mj_header.endRefreshing()
            }
            else{
                self.tableView.mj_footer.endRefreshing()
            }
            let code = json["code"] as! Int
            let msg = json["msg"] as! String
            if code == 200 {
                let result = json["result"] as! NSArray
                if self.page == 1{
                    self.commentDatas.removeAll();
                }
                for comment_dic in result{
                    let comment = PPCommentObj.init(info: comment_dic as! NSDictionary)
                    self.commentDatas.append(comment)
                }
                if result.count < LIST_PAGESIZE {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData();
                }
                self.tableView.reloadData()
            }
            else{
                ProgressHUD.showError(msg, interaction: false)
            }
        }) {
            if self.page == 1{
                self.tableView.mj_header.endRefreshing()
            }
            else{
                self.tableView.mj_footer.endRefreshing()
            }
        }
    }
    //    MARK:UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentDatas.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :CommentTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath) as! CommentTableViewCell;
        
        let obj = commentDatas[indexPath.row]
        cell.data(obj: obj)
       
        return cell!;
    }
    //    MARK:UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let obj = commentDatas[indexPath.row]
        //包含图片
        if obj.images.count>0 {
            return 84 + SCREEN_WIDTH * 0.2 + obj.comment!.heightWithFountAndWidth(font: UIFont.systemFont(ofSize: 14), width: SCREEN_WIDTH - 10*2) + 15
        }
            //不包含图片，只有文字
        else{
            return 84 + obj.comment!.heightWithFountAndWidth(font: UIFont.systemFont(ofSize: 14), width: SCREEN_WIDTH - 10*2) + 15
        }
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let obj = commentDatas[indexPath.row];
        if obj.images.count > 0  {
            let broVC :ImageBrowserVC = ImageBrowserVC.init(links:obj.images, currentIndex: 0);
            broVC.show();
        }

    }
}
