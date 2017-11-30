//
//  MainTabbarViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/12.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class MainTabbarViewController: UITabBarController ,UITabBarControllerDelegate{
    var indexVC :IndexViewController?
    var readBitCodeVC :ReadBitCodeViewController?
    var userCenterVC :UserCenterViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColor.styleRed();
        self.tabBar.isTranslucent = false;
        indexVC = IndexViewController();
        addChildVC(childVC: indexVC!, title: "首页", image: "tabbar_index");
        readBitCodeVC = ReadBitCodeViewController();
        addChildVC(childVC: readBitCodeVC!, title: "买单", image: "tabbar_readCode");
        userCenterVC = UserCenterViewController();
        addChildVC(childVC: userCenterVC!, title: "我的", image: "tabbar_usercenter");
        NotificationCenter.default.addObserver(self, selector: #selector(scanCode), name: NOTI_INDEX_SCANECODE, object: nil)
        self.delegate = self
    }
    func addChildVC(childVC :UIViewController,title:String,image:String) {
        childVC.title = title;
        childVC.tabBarItem.image = UIImage(named: image);
//        childVC.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        let nav = UINavigationController.init(rootViewController: childVC);
        addChildViewController(nav);

    }
    @objc func scanCode () {
        if PPUserInfoManager.isLogined() == false {
            let vc = LoginViewController()
            self.selectedViewController?.present(UINavigationController.init(rootViewController: vc), animated: true, completion: nil)
        }
        else{
            self.selectedViewController = self.viewControllers?[1]
        }
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        //扫码时，判断登录状态
        if viewController == self.viewControllers?[1] && PPUserInfoManager.isLogined() == false {
            let vc = LoginViewController()
            self.selectedViewController?.present(UINavigationController.init(rootViewController: vc), animated: true, completion: nil)
            return false
        }
        else{
            return true
        }
    }
}
