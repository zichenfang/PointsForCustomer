//
//  UserCenterViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/12.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class UserCenterViewController: BaseViewController , UITableViewDataSource , UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    convenience init() {
        self.init(nibName: "UserCenterViewController", bundle: nil);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "UserCenterTableViewCell", bundle: nil), forCellReuseIdentifier: "usercenter");
        // Do any additional setup after loading the view.
    }
//    MARK:UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :UserCenterTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "usercenter", for: indexPath) as! UserCenterTableViewCell;
        return cell!;
    }
//    MARK:UITableViewDelegate
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
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
