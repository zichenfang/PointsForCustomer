//
//  AllKindsListViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/12/21.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class AllKindsListViewController: BaseViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    convenience init() {
        self.init(nibName: "AllKindsListViewController", bundle: nil);
    }
    //子分类数据
    var subClassDatas :NSMutableArray? = NSMutableArray();
    var itemWidth :CGFloat?

    @IBOutlet var cv: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "全部";
        configTableView()
        self.loadSubClassData();
    }
    //MARK:配置tableview下拉刷新，cell ，contentInset
    func configTableView()  {
        itemWidth = (SCREEN_WIDTH - 5)*0.2;
        cv.register(UINib.init(nibName: "AllKindsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "kinds")
        cv.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.loadSubClassData()
        })
    }
    //    MARK:获取分类数据
    func loadSubClassData() {
        PPRequestManager.GET(url: API_SHOP_SUBCLASS, para: nil, success: { (json) in
            let code = json["code"] as! Int
            if code == 200 {
                self.cv.mj_header.endRefreshing();
                let result = json.array_ForKey(key: "result")
                self.subClassDatas?.removeAllObjects()
                for subclass_dic in result{
                    let subclass = PPIndexClassObj.init(info: subclass_dic as! NSDictionary)
                    if subclass.name?.contains("全部") == false{
                        self.subClassDatas?.add(subclass);
                    }
                }
                self.cv.reloadData();
            }
        }) {
            self.cv.mj_header.endRefreshing();
        }
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.subClassDatas?.count)!;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : AllKindsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "kinds", for: indexPath) as! AllKindsCollectionViewCell
        let classObj :PPIndexClassObj! = self.subClassDatas![indexPath.row] as! PPIndexClassObj;
        cell.nameLabel.text = classObj.name;
        cell.imgView.sd_setImage(with: URL.init(string: (classObj.imageUrl!)), placeholderImage: PLACE_HOLDER_IMAGE_GENERAL);

        return cell;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: itemWidth!, height: 70);
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 20, left: 0, bottom: 0, right: 0);
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let classObj :PPIndexClassObj! = self.subClassDatas![indexPath.row] as! PPIndexClassObj;
        let vc = OneKindShopListViewController();
        vc.classObj = classObj;
        vc.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(vc, animated: true);
    }
}






