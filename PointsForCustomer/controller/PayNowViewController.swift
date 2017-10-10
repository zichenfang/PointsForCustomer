//
//  PayNowViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/29.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class PayNowViewController: BaseViewController {
    // 店铺id,店铺名,转换比例,消费金额
    var para :Array<String>!
    @IBOutlet var maxPointLabel: UILabel!
    @IBOutlet var canGetPointLabel: UILabel!
    @IBOutlet var usePointTF: UITextField!
    @IBOutlet var priceLabel: UILabel!
    var canUseMaxPoint :Int! //本单使用积分上限
    var price : Double! //消费总金额
    var shopId :Int! //店铺ID
    convenience init(){
        self.init(nibName: "PayNowViewController", bundle: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        shopId = Int(para[0])
        self.title = para[1]
        //消费金额
        price = Double(para[3])
        priceLabel.text = String.init(format: "%.2f", price)
        //最多使用积分限制
        print(Double(para[2])! * 0.01 * price)
        print(Int(Double(para[2])! * 0.01 * price))
        canUseMaxPoint = Int(Double(para[2])! * 0.01 * price)
        maxPointLabel.text = String.init(format: "%d分", canUseMaxPoint)
        canGetPointLabel.text = maxPointLabel.text
        
        //添加textField通知监听
        usePointTF.addTarget(self, action: #selector(tfChanged(_:)), for: UIControlEvents.allEvents)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(false, animated: true);
    }
    @objc func tfChanged(_ tf:UITextField){
        var inputPoint = Int(usePointTF.text!) ?? 0
        if inputPoint > canUseMaxPoint {
            inputPoint = canUseMaxPoint
            usePointTF.text = String.init(format: "%d", inputPoint)
        }
        if inputPoint<0 {
            inputPoint = 0
            usePointTF.text = "0"
        }
        
        canGetPointLabel.text = String.init(format: "%d分", canUseMaxPoint - inputPoint)
    }
//    MARK:支付，支付成功后，跳转到评价页面
    @IBAction func payNow(_ sender: Any) {
        let usePoint = Int(usePointTF.text!) ?? 0
        let para = ["pay_points" : usePoint,
                    "token" : PPUserInfoManager.token(),
                    "store_id" : shopId,
                    "total_fee" : price] as [String:AnyObject]
        PPRequestManager.POST(url: API_SHOP_PAYNOW, para: para, success: { (json) in
            let code = json["code"] as! Int
            let msg = json["msg"] as! String
            if code == 200 {
                ProgressHUD.showSuccess("支付成功！", interaction: false)
                self.perform(#selector(self.paySuccess), with: nil, afterDelay: 1.2)
            }
            else{
                ProgressHUD.showError(msg, interaction: false)
            }
        }) {
            ProgressHUD.showError("支付失败，请重试", interaction: false)
        }
        
    }
//    MARK:支付成功，跳转到评论页面
    @objc func paySuccess()  {
        let vc = WriteCommentViewController()
        vc.shop_id = shopId
        self.present(UINavigationController.init(rootViewController: vc), animated: true, completion: nil)
    }
    
}
