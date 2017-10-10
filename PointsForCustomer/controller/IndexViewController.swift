//
//  IndexViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/12.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class IndexViewController: BaseViewController , UITableViewDataSource , UITableViewDelegate , SDCycleScrollViewDelegate ,UITextFieldDelegate ,UIScrollViewDelegate{
    /*定位*/
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var headerToolView: UIView!
    /*所在位置的view模块（因为要根据位置长度设置其view长度，和圆角和边线，所以设置其为属性）*/
    @IBOutlet var locationView: UIView!
    /*动态计算locationView的宽度，计算方式为地址名称label宽度+40*/
    @IBOutlet var locationViewConstraint: NSLayoutConstraint!
    @IBOutlet var locationLabel: UILabel!
    //轮播图数据
    var bannerDatas :NSMutableArray? = NSMutableArray();
    //子分类数据
    var subClassDatas :NSMutableArray? = NSMutableArray();
    //商家列表数据
    var shopDatas :NSMutableArray? = NSMutableArray();
    //商家列表分页页码
    var page :Int = 1;
    convenience init() {
        self.init(nibName: "IndexViewController", bundle: nil);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //定位
        LOCATION_MANAGER.addObserver(self, forKeyPath: "currentLocation", options: NSKeyValueObservingOptions.new, context: nil);
        completeUIForLocationView();
        configTableView();
        startUpdatingLocation();
        //获取轮播图数据和分类数据
        loadBannerData()
        loadSubClassData()
        
    }
//    MARK: 位置视图加圆角和边线
    func completeUIForLocationView(){
        //圆角和边线
        locationView.backgroundColor = UIColor.black.withAlphaComponent(0.5);
        locationView.layer.masksToBounds = true;
        locationView.layer.cornerRadius = locationView!.frame.size.height * 0.5;
        locationView.layer.borderWidth = 1;
        locationView.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor;
    }
    //MARK:配置tableview下拉刷新，cell ，contentInset
    func configTableView()  {
        tableView.register(UINib.init(nibName: "PPShopTableViewCell", bundle: nil), forCellReuseIdentifier: "indexShop");
        tableView.contentInset = UIEdgeInsets.init(top: -20, left: 0, bottom: 0, right: 0);
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.page = 1
            self.shopDatas?.removeAllObjects()
            self.loadShopData()
            self.loadBannerData()
            self.loadSubClassData()
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page = self.page + 1
            self.loadShopData()
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(true, animated: true);
    }
//    MARK:获取轮播图数据
    func loadBannerData() {
        PPRequestManager.GET(url: API_SHOP_BANNER, para: nil, success: { (json) in
            let code = json["code"] as! Int
            if code == 200 {
                let result = json["result"] as! NSArray
                self.bannerDatas?.removeAllObjects()
                for banner_dic in result{
                    let banner = PPBannerObject.init(info: banner_dic as! NSDictionary)
                    self.bannerDatas?.add(banner)
                }
                self.updateTableViewHeaderView()
            }
        }) {
        }
    }
    //    MARK:获取分类数据
    func loadSubClassData() {
        PPRequestManager.GET(url: API_SHOP_SUBCLASS, para: nil, success: { (json) in
            let code = json["code"] as! Int
            if code == 200 {
                let result = json["result"] as! NSArray
                self.subClassDatas?.removeAllObjects()
                for subclass_dic in result{
                    let subclass = PPIndexClassObj.init(info: subclass_dic as! NSDictionary)
                    self.subClassDatas?.add(subclass)
                }
                self.updateTableViewHeaderView()
            }
        }) {
        }
        
    }
//    MARK:更新轮播图和分类数据UI
    func updateTableViewHeaderView(){
        let headerView = IndexHeaderView.init();
        headerView.bannerDatas = bannerDatas;
        headerView.subClassDatas = subClassDatas;
        headerView.delegate = self;
        //    MARK:跳转到某一个分类列表
        headerView.classSelectedHandler = {(_ item :PPIndexClassObj)->Void in
//            print(item.id!);
            let vc = OneKindShopListViewController();
            vc.classObj = item;
            vc.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(vc, animated: true);
        }
        tableView.tableHeaderView = headerView;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK:高德地图定位
    func startUpdatingLocation() -> Void {
        ProgressHUD.show("位置更新中", interaction: false);
        LOCATION_MANAGER.requestLocation(success: { (location, cityName, aoiName) in
            ProgressHUD.dismiss();
            LOCATION_MANAGER.currentCity = cityName;
            LOCATION_MANAGER.currentAOIName = aoiName;
            LOCATION_MANAGER.currentLocation = location;
            
        }, permissionFailed: {
            //用户权限获取失败
            ProgressHUD.dismiss();
            self.updateLocationLabel(address: "手动获取位置");
            let alertVC = UIAlertController.init(title: "定位获取失败", message: String.init(format: "请打开系统设置中“隐私->定位服务”，允许%@使用您的位置", AMAP_PRODUCT_NAME), preferredStyle: UIAlertControllerStyle.alert);
            alertVC.addAction(UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: nil));
            alertVC.addAction(UIAlertAction.init(title: "设置", style: UIAlertActionStyle.default, handler: { (act) in
                UIApplication.shared.openURL(URL.init(string: UIApplicationOpenSettingsURLString)!);
            }));
            self.present(alertVC, animated: true, completion: nil);

        }) {
            //获取地理位置失败或者逆地理编码失败
            ProgressHUD.dismiss();
            self.showLocationFaildAlertAndTryAgain();
        }
    }
    func showLocationFaildAlertAndTryAgain() {
        updateLocationLabel(address: "定位失败");
        let alertVC = UIAlertController.init(title: "获取定位失败，请重试", message: "定位失败？点击左上角可进行手动定位", preferredStyle: UIAlertControllerStyle.alert);
        alertVC.addAction(UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: nil));
        alertVC.addAction(UIAlertAction.init(title: "重试", style: UIAlertActionStyle.default, handler: { (act) in
            self.startUpdatingLocation();
        }));
        self.present(alertVC, animated: true, completion: nil);
    }
    func updateLocationLabel(address : String) {
        locationLabel.text = address;
        var locationLabelWidth :CGFloat = (address.widthWithFountAndHeight(font: locationLabel.font, height: locationLabel.frame.size.height)) + 40;
        if locationLabelWidth >  SCREEN_WIDTH - 180{
            locationLabelWidth = SCREEN_WIDTH - 180;
        }
        locationViewConstraint.constant = locationLabelWidth;
    }
//    MARK:手动选择地理位置
    @IBAction func selectLocation(_ sender: UITapGestureRecognizer) {
        let vc = CityListViewController();
        vc.handler = {(_info: NSDictionary?) -> Void in
            //手动选择地址回掉之后，刷新首页数据
            self.updateLocationLabel(address: LOCATION_MANAGER.currentAOIName!)
        }
        
        vc.hidesBottomBarWhenPushed = true;
        navigationController?.pushViewController(vc, animated: true);
    }
    //MARK:地理位置发生改变的时候，刷新商家数据
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentLocation" {
            self.updateLocationLabel(address: LOCATION_MANAGER.currentAOIName!)
            self.tableView.mj_header.beginRefreshing()
        }
    }
//    MARK:获取商家数据
    func loadShopData() {
        if LOCATION_MANAGER.currentLocation == nil {
            ProgressHUD.showError("系统无法获取到您的位置，定位成功后再次重试", interaction: false)
            return
        }
        let para = ["longitude":LOCATION_MANAGER.currentLocation?.coordinate.longitude ?? DEFAULT_LOCATION_LONGITUDE,
                    "latitude":LOCATION_MANAGER.currentLocation?.coordinate.latitude ?? DEFAULT_LOCATION_LATITUDE,
                    "city_id":LOCATION_MANAGER.currentCity ?? DEFAULT_LOCATION_CITYNAME,
                    "p":page,
                    "pagesize":LIST_PAGESIZE,
                    "type":"all"] as [String : AnyObject]
        
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
    // MARK: - SDCycleScrollViewDelegate
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        print(index);
    }
    // MARK: - UITextFieldDelegate 跳转到新的搜索页面，
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let vc = SearchShopViewController();
        vc.hidesBottomBarWhenPushed = true;
        navigationController?.pushViewController(vc, animated: true);
        return false;
    }
    // MARK: - 扫码跳转
    @IBAction func scanCode(_ sender: Any) {
        NotificationCenter.default.post(name: NOTI_INDEX_SCANECODE, object: nil)
    }
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let rangeForAlpha :CGFloat = 200.0
        var alpha = (scrollView.contentOffset.y - 50)/rangeForAlpha
        if alpha > 1 {
            alpha = 1
        }
        if alpha<0 {
            alpha = 0
        }
        headerToolView.backgroundColor = UIColor.styleRed().withAlphaComponent(alpha)
    }
    /*

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
