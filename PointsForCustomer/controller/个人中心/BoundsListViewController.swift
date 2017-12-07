//
//  BoundsListViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/12/6.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class BoundsListViewController: BaseViewController {
    convenience init() {
        self.init(nibName: "FavShopListViewController", bundle: nil);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "奖励信息";
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
