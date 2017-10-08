//
//  MainTabbarViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/12.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class MainTabbarViewController: UITabBarController {
    var indexVC :IndexViewController?
    var readBitCodeVC :ReadBitCodeViewController?
    var userCenterVC :UserCenterViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColor.styleRed();
        indexVC = IndexViewController();
        addChildVC(childVC: indexVC!, title: "首页", image: "tabbar_index");
        readBitCodeVC = ReadBitCodeViewController();
        addChildVC(childVC: readBitCodeVC!, title: "买单", image: "tabbar_readCode");
        userCenterVC = UserCenterViewController();
        addChildVC(childVC: userCenterVC!, title: "我的", image: "tabbar_usercenter");
        NotificationCenter.default.addObserver(self, selector: #selector(scanCode), name: NOTI_INDEX_SCANECODE, object: nil)
        
    }
    func addChildVC(childVC :UIViewController,title:String,image:String) {
        childVC.title = title;
        childVC.tabBarItem.image = UIImage(named: image);
//        childVC.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        let nav = UINavigationController.init(rootViewController: childVC);
        addChildViewController(nav);

    }
    @objc func scanCode () {
        self.selectedViewController = self.viewControllers?[1]
    }
}
