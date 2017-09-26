//
//  CityListViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/20.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class CityListViewController: BaseViewController ,UITableViewDelegate , UITableViewDataSource ,UITextFieldDelegate{
    convenience init() {
        self.init(nibName: "CityListViewController", bundle: nil);
    }
    //选择的城市按钮
    @IBOutlet var selectedCityBtn: UIButton!
    //搜索输入框
    @IBOutlet var searchTF: UITextField!
    //三角▶️
    @IBOutlet var markIV: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var aoiBtn: UIButton!
    
    //城市列表是否展示的标识符(默认为true，隐藏)
    var cityTableViewHidden: Bool = true
    /*城市列表使用了本地的数据库*/
    var db:FMDatabase!
    var rset:FMResultSet!
    var citys = NSMutableArray.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "手动定位";
        tableView.register(UINib.init(nibName: "AllCityTableViewCell", bundle: nil), forCellReuseIdentifier: "allcity");
        if LOCATION_MANAGER.currentCity != nil {
            selectedCityBtn.setTitle(LOCATION_MANAGER.currentCity, for: UIControlState.normal);
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(false, animated: true);
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.frame = CGRect.init(x: 0, y: tableView.frame.origin.y, width: SCREEN_WIDTH, height: 0);
    }
//    MARK: 打开或者关闭城市列表
    @IBAction func showHideCityTableView(_ sender: Any) {
        if cityTableViewHidden == true {
            //展示出来 城市列表
            showCityTableView()
        }
        else{
        //隐藏 城市列表
            hideCityTableView();
        }
    }
    func showCityTableView() {
        if citys.count == 0 {
            loadCitysFromDataBase();
        }
        cityTableViewHidden = false;
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.frame = CGRect.init(x: 0, y: self.tableView.frame.origin.y, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - self.tableView.frame.origin.y - 64);
            self.tableView.isHidden = false;
        })

    }
    func hideCityTableView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.frame = CGRect.init(x: 0, y: self.tableView.frame.origin.y, width: SCREEN_WIDTH, height:0);
        }, completion: { (finished) in
            self.tableView.isHidden = true;
        })
        cityTableViewHidden = true;
    }
    
//    MARK:获取本地城市列表数据库的数据
    func loadCitysFromDataBase() {
        let path = Bundle.main.path(forResource: "citys", ofType: "db");
        db = FMDatabase.init(path: path);
        db.open();
        rset = try? db.executeQuery("SELECT * FROM citys", values: nil);
        //根据首字母进行索引分类
        var sectionTitle:String!
        while rset.next() {
            //英文名称首字母
            let cityName = rset.string(forColumn: "area_name_en") as NSString;
            let initial = cityName.substring(with: NSRange.init(location: 0, length: 1)) as String;
            if sectionTitle != initial {
                let dic = NSMutableDictionary.init(capacity: 2);
                dic.setObject(initial, forKey: "sectionTitle" as NSCopying);
                dic.setObject(NSMutableArray.init(), forKey: "list" as NSCopying);
                citys.add(dic);
                sectionTitle = initial;
                
            }
            
            let list :NSMutableArray! = (citys.lastObject as! NSMutableDictionary).object(forKey: "list") as! NSMutableArray;
            list.add(["area_id" :rset.string(forColumn: "area_id"),"area_name" :rset.string(forColumn: "area_name")])
            
        }
        DispatchQueue.main.async {
            self.tableView.reloadData();
        }

    }
//  MARK:开始定位
    @IBAction func startLocation(_ sender: Any) {
        ProgressHUD.show("位置更新中", interaction: false);
        LOCATION_MANAGER.requestLocation(success: { (location, cityName, aoiName) in
            ProgressHUD.dismiss();
            LOCATION_MANAGER.currentCity = cityName;
            LOCATION_MANAGER.currentAOIName = aoiName;
            LOCATION_MANAGER.currentLocation = location;
            self.selectedCityBtn.setTitle(LOCATION_MANAGER.currentCity, for: UIControlState.normal);
            self.aoiBtn.setTitle(LOCATION_MANAGER.currentAOIName, for: UIControlState.normal);
            //获取当前位置下的商家列表数据
            
        }, permissionFailed: {
            //用户权限获取失败
            ProgressHUD.dismiss();
            self.selectedCityBtn.setTitle(LOCATION_MANAGER.currentCity, for: UIControlState.normal);
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
        let alertVC = UIAlertController.init(title: "获取定位失败，请重试", message: nil, preferredStyle: UIAlertControllerStyle.alert);
        alertVC.addAction(UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: nil));
        alertVC.addAction(UIAlertAction.init(title: "重试", style: UIAlertActionStyle.default, handler: { (act) in
            self.startLocation(UIButton.init());
        }));
        self.present(alertVC, animated: true, completion: nil);
    }
    //    MARK:UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let obj = citys.object(at: section) as! NSDictionary;
        let list = obj.object(forKey: "list") as! NSArray;
        return list.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :AllCityTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "allcity", for: indexPath) as! AllCityTableViewCell;
        let obj = citys.object(at: indexPath.section) as! NSDictionary;
        let list = obj.object(forKey: "list") as! NSArray;
        let area_name = (list.object(at: indexPath.row) as! NSDictionary).object(forKey: "area_name") as? String;
        cell.nameLabel.text = area_name;
        if area_name == LOCATION_MANAGER.currentCity {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark;
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryType.none;
        }
        return cell!;
    }
    //    MARK:UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return citys.count;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        let obj = citys.object(at: indexPath.section) as! NSDictionary;
        let list = obj.object(forKey: "list") as! NSArray;
        let cityObj = list.object(at: indexPath.row) as! NSDictionary;
        LOCATION_MANAGER.currentCity = cityObj.object(forKey: "area_name") as? String;
        selectedCityBtn.setTitle(LOCATION_MANAGER.currentCity, for: UIControlState.normal);
        tableView.reloadData();
        hideCityTableView();
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 30));
        headerView.backgroundColor = UIColor.groupTableViewBackground;
        let label = UILabel.init(frame: CGRect.init(x: 10, y: 0, width: 100, height: headerView.frame.size.height));
        headerView.addSubview(label);
        
        let obj = citys.object(at: section) as! NSDictionary;
        label.text = obj.object(forKey: "sectionTitle") as? String;
        label.textColor = UIColor.darkGray;
        label.font = UIFont.systemFont(ofSize: 14);
        label.backgroundColor = UIColor.clear;
        
        return headerView;
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30;
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let titles = NSMutableArray.init();
        for aobj in citys {
            let sectionTitle = (aobj as AnyObject).object(forKey: "sectionTitle");
            titles.add(sectionTitle ?? "");
        }
        return titles as? [String];
    }
    
//    MARK:搜索跳转
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if LOCATION_MANAGER.currentCity == nil {
            ProgressHUD.showError("请先选择城市", interaction: false);
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.2, execute: {
                self.showCityTableView();
            })
            return false;
        }
        let vc = SearchAreaViewController();
        vc.handler = {(_ info :NSDictionary) -> Void in
            self.navigationController?.popViewController(animated: false);
        }
        self.present(vc, animated: true, completion: nil);
        return false;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
