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
        self.tabBar.tintColor = UIColor.green;
        indexVC = IndexViewController();
        addChildVC(childVC: indexVC!, title: "首页", image: "tabbar_index");
        readBitCodeVC = ReadBitCodeViewController();
        addChildVC(childVC: readBitCodeVC!, title: "扫码", image: "tabbar_readCode");
        userCenterVC = UserCenterViewController();
        addChildVC(childVC: userCenterVC!, title: "用户", image: "tabbar_usercenter");

        
    }
    func addChildVC(childVC :UIViewController,title:String,image:String) {
        childVC.title = title;
        childVC.tabBarItem.image = UIImage(named: image);
//        childVC.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        let nav = UINavigationController.init(rootViewController: childVC);
        addChildViewController(nav);

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
