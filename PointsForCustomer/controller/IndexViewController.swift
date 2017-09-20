//
//  IndexViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/12.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class IndexViewController: BaseViewController , UITableViewDataSource , UITableViewDelegate , SDCycleScrollViewDelegate ,UITextFieldDelegate{
    //定位
    var locationManager: AMapLocationManager!
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
    convenience init() {
        self.init(nibName: "IndexViewController", bundle: nil);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //定位
        startUpdatingLocation();
        //圆角和边线
        locationView.backgroundColor = UIColor.black.withAlphaComponent(0.5);
        locationView.layer.masksToBounds = true;
        locationView.layer.cornerRadius = locationView!.frame.size.height * 0.5;
        locationView.layer.borderWidth = 1;
        locationView.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor;
        //注册tableViewCell
        tableView.register(UINib.init(nibName: "PPShopTableViewCell", bundle: nil), forCellReuseIdentifier: "indexShop");
        tableView.contentInset = UIEdgeInsets.init(top: -20, left: 0, bottom: 0, right: 0);
        print(tableView.contentInset);
        
        //假设获取到了轮播图数据
        bannerDatas?.removeAllObjects();
        bannerDatas?.add(PPBannerObject.init(info: ["imageUrl":"https://gw.alicdn.com/tfs/TB1fYOSeMMPMeJjy1XbXXcwxVXa-750-291.jpg_Q90.jpg"]));
        bannerDatas?.add(PPBannerObject.init(info: ["imageUrl":"https://img.alicdn.com/tfs/TB1i_aLd3oQMeJjy1XaXXcSsFXa-800-300.jpg"]));

        bannerDatas?.add(PPBannerObject.init(info: ["imageUrl":"https://aecpm.alicdn.com/simba/img/TB1q7ymhUQIL1JjSZFhSuuDZFXa.jpg"]));
        bannerDatas?.add(PPBannerObject.init(info: ["imageUrl":"https://gw.alicdn.com/imgextra/i4/1/TB20GOyXDJ_SKJjSZPiXXb3LpXa_!!1-0-luban.jpg"]));
        //加数据 子分类数据
        subClassDatas?.removeAllObjects();
        for _ in 1...30{
            subClassDatas?.add(IndexClassObj.init(info: ["id":String.init(format: "%d", arc4random()%100000) , "name" : String.random32bitStringGGG(length: 4) ,"imageUrl" : "https://gw.alicdn.com/imgextra/i4/1/TB20GOyXDJ_SKJjSZPiXXb3LpXa_!!1-0-luban.jpg"]))
        }
        
        //headerview
        updateTableViewHeaderView();
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(true, animated: true);
    }
    func updateTableViewHeaderView(){
        let headerView = IndexHeaderView.init();
        headerView.bannerDatas = bannerDatas;
        headerView.subClassDatas = subClassDatas;
        headerView.delegate = self;
        tableView.tableHeaderView = headerView;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK:高德地图定位
    func startUpdatingLocation() -> Void {
        ProgressHUD.show("位置更新中", interaction: false);
        locationManager = AMapLocationManager();
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.locationTimeout = 2
        locationManager.reGeocodeTimeout = 2
        locationManager.requestLocation(withReGeocode: true, completionBlock: {  (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
            ProgressHUD.dismiss();
            if let error = error {
                let error = error as NSError
                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
                    NSLog("定位错误:{\(error.code) - \(error.localizedDescription)};")
                    self.updateLocationLabel(address: "手动获取位置");
                    let alertVC = UIAlertController.init(title: "定位获取失败", message: String.init(format: "请打开系统设置中“隐私->定位服务”，允许%@使用您的位置", AMAP_PRODUCT_NAME), preferredStyle: UIAlertControllerStyle.alert);
                    alertVC.addAction(UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: nil));
                    alertVC.addAction(UIAlertAction.init(title: "设置", style: UIAlertActionStyle.default, handler: { (act) in
                        UIApplication.shared.openURL(URL.init(string: UIApplicationOpenSettingsURLString)!);
                    }));
                    self.present(alertVC, animated: true, completion: nil);
                    
                    return
                }
                else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                    || error.code == AMapLocationErrorCode.timeOut.rawValue
                    || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                    || error.code == AMapLocationErrorCode.badURL.rawValue
                    || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                    || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
                    //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
                    NSLog("逆地理错误:{\(error.code) - \(error.localizedDescription)};")
                    self.showLocationFaildAlertAndTryAgain();
                }
                else {
                    //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
                }
            }
            //

            //先取逆地理信息，如果失败，则即使经纬度有有效信息，也被视为无效信息
            if let reGeocode = reGeocode {
                print("逆地理信息\(reGeocode)");
                var pointName:String? = reGeocode.poiName;
                //poiname失败，则取aoiname
                if (pointName?.characters.count)!<=1 {
                    pointName = reGeocode.aoiName;
                }
                //aoiname失败，则取street
                else if (pointName?.characters.count)!<=1 {
                    pointName = reGeocode.street;
                }
                if let location = location {
                    print("经纬度\(location)");
                    self.updateLocationLabel(address: pointName!);
                    //重新刷新页面数据
                }
                else{
                    self.showLocationFaildAlertAndTryAgain();
                }
            }
            
        })
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
        locationViewConstraint.constant = (address.widthWithFountAndHeight(font: locationLabel.font, height: locationLabel.frame.size.height)) + 40;
    }
//    MARK:手动选择地理位置
    @IBAction func selectLocation(_ sender: UITapGestureRecognizer) {
        let vc = CityListViewController();
        vc.handler = {(_info: NSDictionary?) -> Void in
            //手动选择地址回掉之后，刷新首页数据
        }
        
        vc.hidesBottomBarWhenPushed = true;
        navigationController?.pushViewController(vc, animated: true);
    }
    
    //    MARK:UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :PPShopTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "indexShop", for: indexPath) as! PPShopTableViewCell;
        let aobj = PPShopObject.init(info: ["imgUrl":"https://gw.alicdn.com/imgextra/i4/1/TB20GOyXDJ_SKJjSZPiXXb3LpXa_!!1-0-luban.jpg","star":NSNumber.init(value: arc4random()%5+1)])
        cell.data(obj: aobj);
        return cell!;
    }
    //    MARK:UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ShopDetailViewController();
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
