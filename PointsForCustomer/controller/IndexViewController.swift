//
//  IndexViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/12.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class IndexViewController: BaseViewController , UITableViewDataSource , UITableViewDelegate , SDCycleScrollViewDelegate{

    @IBOutlet var tableView: UITableView!
    var bannerDatas :NSMutableArray? = NSMutableArray();

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true;
        tableView.register(UINib.init(nibName: "PPShopTableViewCell", bundle: nil), forCellReuseIdentifier: "indexShop");
        
        
        //假设获取到了轮播图数据
        bannerDatas?.add(PPBannerObject.init(info: ["imageUrl":"https://tva1.sinaimg.cn/crop.1.0.637.637.50/a3609e63jw8fboayxpgz2j20hs0hpgmj.jpg"]));
        bannerDatas?.add(PPBannerObject.init(info: ["imageUrl":"https://tva4.sinaimg.cn/crop.0.0.177.177.50/612edf3agw1ekppvdur8wj2050050q32.jpg"]));

        bannerDatas?.add(PPBannerObject.init(info: ["imageUrl":"https://tvax3.sinaimg.cn/crop.8.0.495.495.50/48876d1bly8fin26lls2jj20e80dr75m.jpg"]));
        bannerDatas?.add(PPBannerObject.init(info: ["imageUrl":"https://tvax4.sinaimg.cn/crop.0.0.750.750.50/006KfxSIly8fe51x6ba02j30ku0kuq3u.jpg"]));
        updateTableViewHeaderView();

        
    }
    func updateTableViewHeaderView(){
        let headerView = IndexHeaderView.init();
        headerView.bannerDatas = bannerDatas;
        headerView.delegate = self;
        tableView.tableHeaderView = headerView;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    MARK:UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :PPShopTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "indexShop", for: indexPath) as! PPShopTableViewCell;
        return cell!;
    }
    //    MARK:UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    // MARK: - SDCycleScrollViewDelegate
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        print(index);
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
