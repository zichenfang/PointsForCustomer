//
//  ShopDetailViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/20.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class ShopDetailViewController: BaseViewController {
    var favBarItem : UIBarButtonItem!
    //是否已经收藏，默认为否
    var isFav :Bool = false;
    @IBOutlet var tableView: UITableView!
    @IBOutlet var phoneBtnWidthConstraint: NSLayoutConstraint!
    convenience init() {
        self.init(nibName: "ShopDetailViewController", bundle: nil);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "店铺详情";
        prepareFavItem();
        tableView.beginUpdates()
    }
    func prepareFavItem() {
        if isFav == false {
            favBarItem = UIBarButtonItem.init(image: UIImage.init(named: "shoucang"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(add_remove_Fav));
        }
        else {
            favBarItem = UIBarButtonItem.init(image: UIImage.init(named: "yishoucang"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(add_remove_Fav));
        }
        navigationItem.rightBarButtonItem = favBarItem;
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        //修改打电话按钮的宽度
        phoneBtnWidthConstraint.constant = SCREEN_WIDTH * 0.226
        //测试一下修改headerView高度
        tableView.tableHeaderView?.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 680);

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    MARK:添加或者删除收藏
    func add_remove_Fav()  {
        if isFav == false {
            //添加收藏
            isFav = true;
        }
        else{
            //取消收藏
            isFav = false;
        }
        //数据请求
        //更新UI
        prepareFavItem();
        
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
