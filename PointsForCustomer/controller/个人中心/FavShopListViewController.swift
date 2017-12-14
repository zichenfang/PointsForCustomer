//
//  FavShopListViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/20.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class FavShopListViewController: BaseViewController , UITableViewDataSource , UITableViewDelegate{
    @IBOutlet var tableView: UITableView!
    //商家列表数据
    var shopDatas :NSMutableArray? = NSMutableArray();
    //商家列表分页页码
    var page :Int = 1;
    convenience init() {
        self.init(nibName: "FavShopListViewController", bundle: nil);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的收藏";
        configTableView()
    }
    //MARK:配置tableview下拉刷新，cell ，contentInset
    func configTableView()  {
        tableView.register(UINib.init(nibName: "PPShopTableViewCell", bundle: nil), forCellReuseIdentifier: "indexShop");
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.page = 1
            self.loadShopData()
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page = self.page + 1
            self.loadShopData()
        })
        tableView.mj_header.beginRefreshing();
    }
    //    MARK:获取商家数据
    func loadShopData() {
        let para = ["token":PPUserInfoManager.token()] as [String : AnyObject]
        PPRequestManager.POST(url: API_SHOP_FAV_LIST, para: para, success: { (json) in
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
                    self.shopDatas?.removeAllObjects()
                }
                for shop_dic in result{
                    let shop = PPShopObject.init(info: shop_dic as! NSDictionary)
                    self.shopDatas?.add(shop)
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
        return (shopDatas?.count)!;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :PPShopTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "indexShop", for: indexPath) as! PPShopTableViewCell;
        let aobj = shopDatas![indexPath.row]
        cell.data(obj: aobj as! PPShopObject);
        cell.setDistanceHidden(hidden: true);//隐藏距离显示
        return cell!;
    }
    //    MARK:UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ShopDetailViewController();
        vc.shopObj = shopDatas![indexPath.row] as! PPShopObject
        vc.hidesBottomBarWhenPushed = true;
        vc.handler = {(info)->Void in
            if let obj :PPShopObject = info["shop"] as? PPShopObject {
                if let type = info["type"] {
                    if type as! String == "1" && !(self.shopDatas?.contains(obj))!{
                        self.shopDatas?.add(obj);
                    }
                    else if type as! String == "0" && (self.shopDatas?.contains(obj))!{
                        self.shopDatas?.remove(obj);
                    }
                    self.tableView .reloadData();
                }
            }
        };
        navigationController?.pushViewController(vc, animated: true);
    }

}

