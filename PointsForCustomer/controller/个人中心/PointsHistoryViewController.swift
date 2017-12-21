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
    var pointsHistoryData  = NSMutableArray() as! [PPOrderHisoryObj];
    //商家列表分页页码
    var page :Int = 1;
    convenience init() {
        self.init(nibName: "PointsHistoryViewController", bundle: nil);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title  = "积分记录"
        if self.handler != nil {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "返回", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goUserCenter));
        }
        let points = PPUserInfoManager.userInfo()!["integral_balance"] as? Int
        lastPointsLabel.text = String.init(format: "%d", points!)
        configTableView()
        loadPointsHistoryData()
    }
    //MARK:配置tableview下拉刷新，cell ，contentInset
    func configTableView()  {
        tableView.register(UINib.init(nibName: "PointsHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "pointshistory");
        tableView.register(UINib.init(nibName: "PointsHistoryOtherTableViewCell", bundle: nil), forCellReuseIdentifier: "pointshistoryother");
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
                    "pagesize":LIST_PAGESIZE] as [String : AnyObject]
        
        PPRequestManager.POST(url: API_USER_ORDER_HISTORY, para: para, success: { (json) in
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
                    let pointhisObj = PPOrderHisoryObj.init(info: pointhis_dic as! NSDictionary)
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
        let aobj = pointsHistoryData[indexPath.row];
        if aobj.type == 1 {
            let cell :PointsHistoryTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "pointshistory", for: indexPath) as! PointsHistoryTableViewCell;
            cell.data(obj: aobj);
            return cell!;

        }
        else{
            let cell :PointsHistoryOtherTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "pointshistoryother", for: indexPath) as! PointsHistoryOtherTableViewCell;
            cell.data(obj: aobj);
            return cell!;
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let aobj = pointsHistoryData[indexPath.row];
        if aobj.type == 1 {
            return 95;
        }
        else{
            return 70;
        }
    }
    //    MARK:UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        let aobj = pointsHistoryData[indexPath.row]
//        "state": "integer,订单状态 2-冻结中 3-退款中 5-已完成  9-已退款",
        if aobj.state == 2 {
            let alertVC = UIAlertController.init(title: "确认退款？", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            alertVC.addAction(UIAlertAction.init(title: "退款", style: UIAlertActionStyle.destructive, handler: { (act) in
                self.refundOrder(orderObj: aobj);
            }))
            alertVC.addAction(UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    //    MARK:退款
    func refundOrder(orderObj:PPOrderHisoryObj) {
        let para = ["token":PPUserInfoManager.token(),
                    "order_id":orderObj.order_history_id ?? 0] as [String : AnyObject]
        PPRequestManager.POST(url: API_USER_ORDER_REFUND, para: para, success: { (json) in
            let code = json["code"] as! Int
            let msg = json["msg"] as! String
            if code == 200 {
                ProgressHUD.showSuccess(msg, interaction: false);
                orderObj.state = 3;
                orderObj.state_des = "退款中";
                self.tableView.reloadData();
            }
            else{
                ProgressHUD.showError(msg, interaction: false)
            }
        }) {
        }
    }
    //MARK:从评论页面跳转到该记录页面之后，返回到个人中心
    @objc func goUserCenter () {
        if self.handler != nil {
            self.handler!([:]);
        }
        self.navigationController?.popViewController(animated: false);
    }
}
