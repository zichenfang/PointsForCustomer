//
//  MsgListViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/12/11.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class MsgListViewController: BaseViewController  , UITableViewDataSource , UITableViewDelegate{
    convenience init() {
        self.init(nibName: "MsgListViewController", bundle: nil);
    }
    @IBOutlet var tableView: UITableView!
    //积分纪录列表数据
    var msgListData  = NSMutableArray() as! [PPMsgObject];
    //商家列表分页页码
    var page :Int = 1;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "消息中心";
        configTableView()
        loadMsgListData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        if self.handler != nil{
            self.handler!([:]);
        }
    }
    //MARK:配置tableview下拉刷新，cell ，contentInset
    func configTableView()  {
        tableView.register(UINib.init(nibName: "MsgListTableViewCell", bundle: nil), forCellReuseIdentifier: "msg");
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.page = 1
            self.msgListData.removeAll()
            self.loadMsgListData()
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page = self.page + 1
            self.loadMsgListData()
        })
    }
    //    MARK:获取积分纪录数据
    func loadMsgListData() {
        let para = ["token":PPUserInfoManager.token(),
                    "p":page,
                    "pagesize":LIST_PAGESIZE] as [String : AnyObject]
        
        PPRequestManager.POST(url: API_USER_MESSAGE_LIST, para: para, success: { (json) in
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
                    let msgObj = PPMsgObject.init(info: pointhis_dic as! NSDictionary)
                    self.msgListData.append(msgObj)
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
        return msgListData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :MsgListTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "msg", for: indexPath) as! MsgListTableViewCell;
        let aobj = msgListData[indexPath.row]
        cell.data(obj: aobj);
        return cell!;
    }
    //    MARK:UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let aobj = msgListData[indexPath.row];
        if aobj.isOpen == true {
            return aobj.cell_height_open!;
        }
        else{
            return aobj.cell_height_close!;
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        let aobj = msgListData[indexPath.row];
        aobj.isOpen = !aobj.isOpen!;
        //如果未读
        if aobj.is_read == false {
            aobj.is_read = true;
            //请求接口设置为已读
            requestRedMsg(aobj: aobj);
        }
        tableView.reloadData();
    }
    //    MARK:设置消息为已读
    func requestRedMsg(aobj:PPMsgObject) {
        let para = ["token":PPUserInfoManager.token(),
                    "message_id":aobj.msg_id] as [String : AnyObject]
        PPRequestManager.POST(url: API_USER_READ_MESSAGE, para: para, success: { (json) in
            let code = json["code"] as! Int
            if code == 200 {
            }
        }) {
        }
    }
}
