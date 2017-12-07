//
//  BaseViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/12.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    //用于该页面返回上层时的传值，默认info可以传空[:]
    var handler:((_ info:[String:AnyObject])->Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white];
        //去掉导航栏下面的黑线
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(color: UIColor.styleRed()), for: UIBarMetrics.default);
        self.navigationController?.navigationBar.shadowImage = UIImage.init();
        //状态栏围白色
//        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true);

    }
    //默认导航栏都是显示的，在不需要显示的地方重写此方法
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
