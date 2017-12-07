//
//  FAQViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/12/7.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class FAQViewController: BaseViewController ,UITableViewDataSource , UITableViewDelegate{
    @IBOutlet var tableView: UITableView!
    //积分纪录列表数据
    var datas  = NSMutableArray() as! [PPFAQObj];
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "常见问题";
        configTableView()
        loaddatas();
    }
    //MARK:配置tableview下拉刷新，cell
    func configTableView()  {
        tableView.register(UINib.init(nibName: "FAQIssueTableViewCell", bundle: nil), forCellReuseIdentifier: "issue");
        tableView.register(UINib.init(nibName: "FAQAnswerTableViewCell", bundle: nil), forCellReuseIdentifier: "answer");
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.loaddatas()
        })
    }
    //    MARK:获取积分纪录数据
    func loaddatas() {
        let para = ["token":PPUserInfoManager.token()] as [String : AnyObject]
        PPRequestManager.POST(url: API_USER_FAQ_LIST, para: para, success: { (json) in
            self.tableView.mj_header.endRefreshing()
            let code = json["code"] as! Int
            let msg = json["msg"] as! String
            if code == 200 {
                let result = json["result"] as! NSArray
                self.datas.removeAll();
                for faq_dic in result{
                    let faqObj = PPFAQObj.init(info: faq_dic as! NSDictionary)
                    self.datas.append(faqObj)
                }
                self.tableView.reloadData()
            }
            else{
                ProgressHUD.showError(msg, interaction: false)
            }
        }) {
            self.tableView.mj_header.endRefreshing()
        }
    }
    //    MARK:UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let aobj = datas[section];
        if aobj.isOpen == true {
            //展开了
            return 2;
        }
        else{
            //合并了
            return 1;
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aobj = datas[indexPath.section]
        //问题
        if indexPath.row == 0 {
            let cell :FAQIssueTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "issue", for: indexPath) as! FAQIssueTableViewCell;
            cell.data(obj: aobj);
            return cell!;
        }
        //答案
        else{
            let cell :FAQAnswerTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "answer", for: indexPath) as! FAQAnswerTableViewCell;
            cell.data(obj: aobj);
            return cell!;
        }
    }
    //    MARK:UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return datas.count
    }
    //MARK:计算高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let aobj = datas[indexPath.section];
        //计算问题高度
        if indexPath.row == 0 {
            let height = (aobj.issue?.heightWithFountAndWidth(font: UIFont.systemFont(ofSize: 15), width: SCREEN_WIDTH-50))! + 20;
            return max(50, height);
        }
        //计算答案高度
        else{
            let height = (aobj.answer?.heightWithFountAndWidth(font: UIFont.systemFont(ofSize: 15), width: SCREEN_WIDTH-20))! + 20;
            return max(50, height);
        }

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let aobj = datas[indexPath.section];
        if aobj.isOpen == true {
            aobj.isOpen = false;
        }
        else{
            aobj.isOpen = true;
        }
        self.tableView.reloadData();
    }

}
