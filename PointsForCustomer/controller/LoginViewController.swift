//
//  LoginViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/12.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    
    @IBOutlet var phoneTF: UITextField!
    @IBOutlet var passWordTF: UITextField!
    convenience init() {
        self.init(nibName: "LoginViewController", bundle: nil);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "登录"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "取消", style: UIBarButtonItemStyle.plain, target: self, action: #selector(dis))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true);
    }
    @objc func dis (){
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Navigation
    @IBAction func findPassword(_ sender: Any) {
    }
    @IBAction func regist(_ sender: Any) {
        let vc = RegistViewController()
        vc.handler = {(_ info :NSDictionary?) ->Void in
            if self.handler != nil {
                self.handler!([:])
            }
            self.dismiss(animated: true, completion: nil)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func login(_ sender: Any) {
    }
    
}
