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
     var handler:((_ info:NSDictionary)->Void)?

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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated);
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
