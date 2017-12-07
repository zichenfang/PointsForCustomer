//
//  SearchAreaViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/22.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class SearchAreaViewController: BaseViewController ,UITextFieldDelegate ,UITableViewDataSource , UITableViewDelegate ,AMapSearchDelegate{
    convenience init() {
        self.init(nibName: "SearchAreaViewController", bundle: nil);
    }
    //搜索
    var search : AMapSearchAPI = AMapSearchAPI.init()
    @IBOutlet var searchTF: UITextField!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var tableView: TPKeyboardAvoidingTableView!
    //搜索出来的数据
    var resultsData :NSMutableArray? = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "搜索地址";
        tableView.register(UINib.init(nibName: "SearchAreaTableViewCell", bundle: nil), forCellReuseIdentifier: "searcharea");
        search.delegate = self;
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        searchTF.becomeFirstResponder();
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func searchPOI(_ keyword :String?) {
        ProgressHUD.show(nil, interaction: false);
        /*如果程序中存在用户的真实地理位置，并且选择的城市与真实地理位置的城市一致，则用周边搜索，并在tableviewcell中显示距离，否则用关键字搜索、并隐藏tableviewcell中的距离*/
        let request = AMapPOIKeywordsSearchRequest()
        request.keywords = keyword
        request.requireExtension = true
        request.city = LOCATION_MANAGER.currentCity
        request.cityLimit = true
        request.requireSubPOIs = true
        if LOCATION_MANAGER.realLocation != nil{
            request.location = AMapGeoPoint.location(withLatitude: CGFloat((LOCATION_MANAGER.realLocation?.coordinate.latitude)!), longitude: CGFloat((LOCATION_MANAGER.realLocation?.coordinate.longitude)!))
        }
        search.aMapPOIKeywordsSearch(request)
    }
    @IBAction func cancelSearch(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //    MARK:UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (resultsData?.count)!;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :SearchAreaTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "searcharea", for: indexPath) as! SearchAreaTableViewCell;
        let apoi = resultsData?.object(at: indexPath.row) as! AMapPOI;
        cell.nameLabel.text = apoi.name;
        cell.addressLabel.text = apoi.address;
        //如果存在真实地理位置，则计算搜索结果的距离，并显示
        if LOCATION_MANAGER.realLocation != nil{
            let apoi_corrd = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(apoi.location.latitude), longitude: CLLocationDegrees(apoi.location.longitude))
            let distance = MAMetersBetweenMapPoints(MAMapPointForCoordinate((LOCATION_MANAGER.realLocation?.coordinate)!), MAMapPointForCoordinate(apoi_corrd));
            if distance <= 0.1 {
                cell.distanceLabel.isHidden = true;
            }
            else{
                cell.distanceLabel.isHidden = false;
                var distance_des :String;
                if distance < 1000{
                    distance_des = String.init(format: "%.0f 米", distance);
                }
                else{
                    distance_des = String.init(format: "%.1f 千米", distance/1000.0);
                }
                print(distance_des);
                cell.distanceLabel.text = distance_des;
            }

        }
        //隐藏距离显示
        else{
            cell.distanceLabel.isHidden = true;
        }


        return cell!;
    }
    //    MARK:UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let apoi = resultsData?.object(at: indexPath.row) as! AMapPOI;
        LOCATION_MANAGER.currentAOIName = apoi.name;
        LOCATION_MANAGER.currentCity = apoi.city;
        LOCATION_MANAGER.currentLocation = CLLocation.init(latitude: CLLocationDegrees(apoi.location.latitude), longitude: CLLocationDegrees(apoi.location.longitude));
        self.dismiss(animated: false, completion: nil);
        if handler != nil {
            handler!([:]);
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder();
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        searchPOI(textField.text!);
        return true;
    }
//    MARK:AMapSearchDelegate
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        resultsData?.removeAllObjects();
        if response.count == 0{
            ProgressHUD.showError("未搜索到相应的地址", interaction: false);
        }
        else{
            ProgressHUD.dismiss();
            for aPOI in response.pois {
                resultsData?.add(aPOI);
            }
            tableView.reloadData();
        }
    }
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        print(error);
        resultsData?.removeAllObjects();
        tableView.reloadData();
        ProgressHUD.showError("未搜索到相应的地址", interaction: false);
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
