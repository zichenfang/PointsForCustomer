//
//  CommentListViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/29.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class CommentListViewController: BaseViewController , UITableViewDataSource , UITableViewDelegate{
    //外部传值店铺
    public var shopObj : PPShopObject!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var shopNameLabel: UILabel!
    @IBOutlet var commentCountLabel: UILabel!
    //评价列表数据
    var commentDatas = NSMutableArray() as! [CommentObj];
    //商家列表分页页码
    var page :Int = 1;
    convenience init() {
        self.init(nibName: "CommentListViewController", bundle: nil);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "评价";
        shopNameLabel.text = shopObj.name
        commentCountLabel.text = String.init(format: "%d 评价", shopObj.comment_num!)
        configTableView()
        loadCommentData()
    }
    //MARK:配置tableview下拉刷新，cell ，contentInset
    func configTableView()  {
        tableView.register(UINib.init(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "comment");
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.page = 1
            self.commentDatas.removeAll()
            self.loadCommentData()
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page = self.page + 1
            self.loadCommentData()
        })
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
                for comment_dic in result{
                    let comment = CommentObj.init(info: comment_dic as! NSDictionary)
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
            return 74 + SCREEN_WIDTH * 0.2 + obj.comment!.heightWithFountAndWidth(font: UIFont.systemFont(ofSize: 14), width: SCREEN_WIDTH - 10*2) + 15
        }
            //不包含图片，只有文字
        else{
            return 74 + obj.comment!.heightWithFountAndWidth(font: UIFont.systemFont(ofSize: 14), width: SCREEN_WIDTH - 10*2) + 15
        }
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
