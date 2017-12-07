//
//  PointsHistoryViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/10/8.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class PointsHistoryViewController: BaseViewController , UITableViewDataSource , UITableViewDelegate{
    @IBOutlet var lastPointsLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    //积分纪录列表数据
    var pointsHistoryData  = NSMutableArray() as! [PPPointsHistoryObj];
    //商家列表分页页码
    var page :Int = 1;
    convenience init() {
        self.init(nibName: "PointsHistoryViewController", bundle: nil);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title  = "我的积分"
        let points = PPUserInfoManager.userInfo()!["integral_balance"] as? Int
        lastPointsLabel.text = String.init(format: "%d", points!)
        configTableView()
        loadPointsHistoryData()
    }
    //MARK:配置tableview下拉刷新，cell ，contentInset
    func configTableView()  {
        tableView.register(UINib.init(nibName: "PointsHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "pointshistory");
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.page = 1
            self.pointsHistoryData.removeAll()
            self.loadPointsHistoryData()
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page = self.page + 1
            self.loadPointsHistoryData()
        })
    }
    //    MARK:获取积分纪录数据
    func loadPointsHistoryData() {
        let para = ["token":PPUserInfoManager.token(),
                    "p":page,
                    "pagesize":LIST_PAGESIZE] as [String : AnyObject]
        
        PPRequestManager.POST(url: API_USER_POINTS_HISTORY, para: para, success: { (json) in
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
                for pointhis_dic in result{
                    let pointhisObj = PPPointsHistoryObj.init(info: pointhis_dic as! NSDictionary)
                    self.pointsHistoryData.append(pointhisObj)
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
        return pointsHistoryData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :PointsHistoryTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "pointshistory", for: indexPath) as! PointsHistoryTableViewCell;
        let aobj = pointsHistoryData[indexPath.row]
        cell.data(obj: aobj);
        return cell!;
    }
    //    MARK:UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

}
