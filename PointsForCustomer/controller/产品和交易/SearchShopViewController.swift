//
//  SearchShopViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/20.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class SearchShopViewController: BaseViewController , UITableViewDataSource , UITableViewDelegate ,UITextFieldDelegate ,UIScrollViewDelegate{
    //var searchView :SearchShopInputView!
    var searchTF :UITextField?
    @IBOutlet var tableView: UITableView!
    //商家列表数据
    var shopDatas :NSMutableArray? = NSMutableArray();
    //商家列表分页页码
    var page :Int = 1;
    convenience init() {
        self.init(nibName: "SearchShopViewController", bundle: nil);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareSearchView()
        configTableView()
    }
    //MARK:配置tableview下拉刷新，cell ，contentInset
    func configTableView()  {
        tableView.register(UINib.init(nibName: "PPShopTableViewCell", bundle: nil), forCellReuseIdentifier: "indexShop");
        //        tableView.contentInset = UIEdgeInsets.init(top: -20, left: 0, bottom: 0, right: 0);
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
    func prepareSearchView()  {
        let searchView = UIView.init(frame: CGRect.init(x: 0, y: 7, width: SCREEN_WIDTH - 120, height: 44-7*2))
        searchView.backgroundColor = UIColor.white;
        searchView.layer.cornerRadius = searchView.frame.size.height*0.5
        let imgView = UIImageView.init(frame: CGRect.init(x: 7, y: (searchView.frame.size.height - 16)*0.5, width: 16, height: 16))
        imgView.image = UIImage.init(named: "fangdajing");
        searchView.addSubview(imgView)
        searchTF = UITextField.init(frame: CGRect.init(x: 7+16+7, y: 0, width: searchView.frame.size.width - (7+16+7), height: searchView.frame.size.height))
        searchView.addSubview(searchTF!);
        searchTF!.placeholder = "输入店铺名/商品名"
        searchTF!.returnKeyType = UIReturnKeyType.search
        searchTF!.tintColor = UIColor.lightGray
        searchTF!.font = UIFont.systemFont(ofSize: 15)
        searchTF!.delegate = self
        self.navigationItem.titleView = searchView
        searchTF?.becomeFirstResponder()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "搜索", style: UIBarButtonItemStyle.plain, target: self, action: #selector(searchNow))
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchTF?.resignFirstResponder()
    }
//    MARK:UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.searchTF {
            self.searchNow()
        }
        return true
    }
    @objc func searchNow() {
        self.searchTF!.resignFirstResponder()
        if self.searchTF!.text == nil || searchTF?.text == ""{
            ProgressHUD.showError("搜索内容不能为空", interaction: false)
            return
        }
        else{
            tableView.mj_header.beginRefreshing()
        }
        self.tableView.mj_header.beginRefreshing()
    }
    //    MARK:获取商家数据
    func loadShopData() {
        let para = ["longitude":LOCATION_MANAGER.currentLocation?.coordinate.longitude ?? DEFAULT_LOCATION_LONGITUDE,
                    "latitude":LOCATION_MANAGER.currentLocation?.coordinate.latitude ?? DEFAULT_LOCATION_LATITUDE,
                    "city_id":LOCATION_MANAGER.currentCity ?? DEFAULT_LOCATION_CITYNAME,
                    "p":page,
                    "pagesize":LIST_PAGESIZE,
                    "type":"all",
                    "keyword":self.searchTF!.text!] as [String : AnyObject]
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
                let result = json.array_ForKey(key: "result");
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
//    MARK:UIScrollViewDelegate
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == tableView {
            self.searchTF?.resignFirstResponder()
        }
    }
}
