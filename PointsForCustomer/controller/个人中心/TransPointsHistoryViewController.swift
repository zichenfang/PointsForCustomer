//
//  TransPointsHistoryViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/12/12.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class TransPointsHistoryViewController: BaseViewController , UITableViewDataSource , UITableViewDelegate{
    convenience init() {
        self.init(nibName: "TransPointsHistoryViewController", bundle: nil);
    }
    @IBOutlet var tableView: UITableView!
    //积分纪录列表数据
    var pointsHistoryData  = NSMutableArray() as! [PPPointsHistoryObj];
    //商家列表分页页码
    var page :Int = 1;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "转赠记录";
        configTableView()
        loadPointsHistoryData()

    }
    //MARK:配置tableview下拉刷新，cell ，contentInset
    func configTableView()  {
        tableView.register(UINib.init(nibName: "PointsTransObtainHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "pointshistory");
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.page = 1
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
                    "pagesize":LIST_PAGESIZE,
                    "type":"1"] as [String : AnyObject]
        
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
                let result = json.array_ForKey(key: "result");
                if self.page == 1{
                    self.pointsHistoryData.removeAll()
                }
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
        let cell :PointsTransObtainHistoryTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "pointshistory", for: indexPath) as! PointsTransObtainHistoryTableViewCell;
        let aobj = pointsHistoryData[indexPath.row]
        cell.data(obj: aobj);
        return cell!;
    }
    //    MARK:UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
    }

}
