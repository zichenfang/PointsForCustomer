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
        self.navigationController?.isNavigationBarHidden = true;
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
        
        
        //地理位置获取
        let address :String! = "海尔工业园"
        locationLabel.text = address
        locationViewConstraint.constant = address.widthWithFountAndHeight(font: locationLabel.font, height: locationLabel.frame.size.height) + 40;
        
        
        //headerview
        updateTableViewHeaderView();
        
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
