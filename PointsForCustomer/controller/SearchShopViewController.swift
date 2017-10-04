//
//  SearchShopViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/20.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class SearchShopViewController: BaseViewController {
    //var searchView :SearchShopInputView!
    var searchTF :UITextField?
    convenience init() {
        self.init(nibName: "SearchShopViewController", bundle: nil);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareSearchView();
    }
    func prepareSearchView()  {
        let searchView = UIView.init(frame: CGRect.init(x: 0, y: 7, width: SCREEN_WIDTH - 120, height: 44-7*2))
        searchView.backgroundColor = UIColor.white;
        searchView.layer.cornerRadius = searchView.frame.size.height*0.5
        let imgView = UIImageView.init(frame: CGRect.init(x: 7, y: (searchView.frame.size.height - 16)*0.5, width: 16, height: 16))
        imgView.image = UIImage.init(named: "fangdajing");
        searchView.addSubview(imgView)
        searchTF = UITextField.init(frame: CGRect.init(x: 7+16+7, y: 0, width: searchView.frame.size.width, height: searchView.frame.size.height))
        searchView.addSubview(searchTF!);
        searchTF!.placeholder = "输入店铺名/商品名"
        searchTF!.returnKeyType = UIReturnKeyType.search
        searchTF!.tintColor = UIColor.lightGray
        searchTF?.font = UIFont.systemFont(ofSize: 15)
        self.navigationItem.titleView = searchView

        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "搜索", style: UIBarButtonItemStyle.plain, target: self, action: #selector(loadShopData))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(false, animated: true);
    }
    //    MARK:获取商家数据
    @objc func loadShopData() {
//        if LOCATION_MANAGER.currentLocation == nil {
//            ProgressHUD.showError("系统无法获取到您的位置，定位成功后再次重试", interaction: false)
//            return
//        }
//        let para = ["longitude":LOCATION_MANAGER.currentLocation?.coordinate.longitude ?? DEFAULT_LOCATION_LONGITUDE,
//                    "latitude":LOCATION_MANAGER.currentLocation?.coordinate.latitude ?? DEFAULT_LOCATION_LATITUDE,
//                    "city_id":LOCATION_MANAGER.currentCity ?? DEFAULT_LOCATION_CITYNAME,
//                    "p":page,
//                    "pagesize":LIST_PAGESIZE,
//                    "type":"all"] as [String : AnyObject]
//
//
//        PPRequestManager.GET(url: API_SHOP_SHOPS, para: para, success: { (json) in
//            if self.page == 1{
//                self.tableView.mj_header.endRefreshing()
//            }
//            else{
//                self.tableView.mj_footer.endRefreshing()
//            }
//            let code = json["code"] as! Int
//            let msg = json["msg"] as! String
//            if code == 200 {
//                let result = json["result"] as! NSArray
//                for shop_dic in result{
//                    let shop = PPShopObject.init(info: shop_dic as! NSDictionary)
//                    self.shopDatas?.add(shop)
//                }
//                if result.count < LIST_PAGESIZE {
//                    self.tableView.mj_footer.endRefreshingWithNoMoreData();
//                }
//            }
//            else{
//                ProgressHUD.showError(msg, interaction: false)
//            }
//        }) {
//            if self.page == 1{
//                self.tableView.mj_header.endRefreshing()
//            }
//            else{
//                self.tableView.mj_footer.endRefreshing()
//            }
//        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
