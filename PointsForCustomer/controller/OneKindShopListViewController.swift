//
//  OneKindShopListViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/29.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class OneKindShopListViewController: BaseViewController , UITableViewDataSource , UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    public var classObj :PPIndexClassObj!
    //商家列表数据
    var shopDatas :NSMutableArray? = NSMutableArray();
    //商家列表分页页码
    var page :Int = 1;
    convenience init() {
        self.init(nibName: "OneKindShopListViewController", bundle: nil);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = classObj.name
        configTableView()
        loadShopData()
        self.navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: ""), style: UIBarButtonItemStyle.plain, target: self, action: #selector(searchThisKindShop));
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(false, animated: true);
    }
//    MARK:搜索
    @objc func searchThisKindShop() {
        
    }
    //MARK:配置tableview下拉刷新，cell ，contentInset
    func configTableView()  {
        tableView.register(UINib.init(nibName: "PPShopTableViewCell", bundle: nil), forCellReuseIdentifier: "indexShop");
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.page = 1
            self.shopDatas?.removeAllObjects()
            self.loadShopData()
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page = self.page + 1
            self.loadShopData()
        })
    }
    //    MARK:获取商家数据
    func loadShopData() {
        let para = ["longitude":LOCATION_MANAGER.currentLocation?.coordinate.longitude ?? DEFAULT_LOCATION_LONGITUDE,
                    "latitude":LOCATION_MANAGER.currentLocation?.coordinate.latitude ?? DEFAULT_LOCATION_LATITUDE,
                    "city_id":LOCATION_MANAGER.currentCity ?? DEFAULT_LOCATION_CITYNAME,
                    "p":page,
                    "pagesize":LIST_PAGESIZE,
                    "type":classObj.id!] as [String : AnyObject]

        PPRequestManager.POST(url: API_SHOP_SHOPS, para: para, success: { (json) in
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
        navigationController?.pushViewController(vc, animated: true);
    }

}
