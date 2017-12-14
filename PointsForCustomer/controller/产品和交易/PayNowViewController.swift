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
    @IBOutlet var percentLabel: UILabel!//比例
    @IBOutlet var canGetPointLabel: UILabel!
    @IBOutlet var usePointTF: UITextField!
    @IBOutlet var priceLabel: UILabel!
    var canUseMaxPoint :Int! //本单使用积分上限
    var price : Double! //消费总金额
    var percent : Double! //比例
    @IBOutlet var payTruePriceLabel: UILabel!//实际消费
    
    var shopId :Int! //店铺ID
    convenience init(){
        self.init(nibName: "PayNowViewController", bundle: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        shopId = Int(para[0])
        self.title = para[1]
        self.percent = Double(para[2])!*0.01;
        //比例
        self.percentLabel.text = String.init(format: "%.0f%%", self.percent*100);
        //消费金额
        price = Double(para[3])
        priceLabel.text = String.init(format: "%.0f元", price)
        payTruePriceLabel.text = String.init(format: "%.0f元", price);
        //最多使用积分限制
        canUseMaxPoint = Int(self.percent * price);
        canGetPointLabel.text = String.init(format: "%.0f分", canUseMaxPoint)
        //添加textField通知监听
        usePointTF.addTarget(self, action: #selector(tfChanged(_:)), for: UIControlEvents.allEvents)
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
        //实际支付
        payTruePriceLabel.text = String.init(format: "%.0f元", price - (Double)(inputPoint));
    }
//    MARK:开始支付
    @IBAction func payNow(_ sender: Any) {
        let alertC = UIAlertController.init(title: "确认支付？", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alertC.addAction(UIAlertAction.init(title: "支付", style: UIAlertActionStyle.default, handler: { (act) in
            self.requestPay()
        }))
        alertC.addAction(UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alertC, animated: true, completion: nil)

    }
    //    MARK:支付请求
    func requestPay() {
        let usePoint = Int(usePointTF.text!) ?? 0
        let para = ["pay_points" : usePoint,
                    "token" : PPUserInfoManager.token(),
                    "store_id" : shopId,
                    "total_fee" : price] as [String:AnyObject]
        ProgressHUD.show(nil)
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
        vc.handler = {(_ info) -> Void in
            self.navigationController?.popToRootViewController(animated: false)
        }
        self.present(UINavigationController.init(rootViewController: vc), animated: true, completion: nil)
    }
    
}
