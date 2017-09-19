//
//  ReadBitCodeViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/12.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit
import AVFoundation


class ReadBitCodeViewController: BaseViewController,AVCaptureMetadataOutputObjectsDelegate {
    
    var session : AVCaptureSession?
    var lineView : UIView?
    var animation_y : CABasicAnimation?
    var torchON : Bool?
    var codeValue : String!

    convenience init() {
        self.init(nibName: "ReadBitCodeViewController", bundle: nil);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black;
        if PLARFORM.isSimulator == true{
            UIAlertView.init(title: "模拟器无法使用相机！", message: nil, delegate: nil, cancelButtonTitle: "确定").show();
        }
        else{
            prepareCamera();
        }
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        startReadCode();
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
        stopReadCode();
    }
//MARK:相机初始化
    func prepareCamera(){
        let authStatus : AVAuthorizationStatus? = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if authStatus == AVAuthorizationStatus.restricted || authStatus == AVAuthorizationStatus.denied{
            let alertVC = UIAlertController.init(title: "相机权限受限,请在设备的设置-隐私-相机中允许访问相机。", message: nil, preferredStyle: UIAlertControllerStyle.alert);
            alertVC .addAction(UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default, handler: nil));
            self.present(alertVC, animated: true, completion: nil);
            return;
        }
        let device :AVCaptureDevice? = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo);
        
        let input :AVCaptureDeviceInput? = try?AVCaptureDeviceInput.init(device: device);
        let output = AVCaptureMetadataOutput.init();
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main);
//        output.rectOfInterest
        session = AVCaptureSession.init();
        session?.canSetSessionPreset(AVCaptureSessionPresetHigh);
        if input != nil{
            session?.addInput(input);
        }
        session?.addOutput(output);

        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        let layer = AVCaptureVideoPreviewLayer.init(session: session);
        layer?.videoGravity = AVLayerVideoGravityResizeAspectFill;
        layer?.frame = CGRect.init(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64);
        self.view.layer.insertSublayer(layer!, at: 0);
//        //扫码半透明框
        let kuangView :KuangkuangView? = KuangkuangView.init(frame: CGRect.init(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64));
        self.view.addSubview(kuangView!);
        lineView = UIView.init(frame: CGRect.init(x: 30, y: (SCREEN_HEIGHT - SCREEN_WIDTH)*0.5, width: SCREEN_WIDTH - 60, height: 1.5));
        lineView?.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 0.768, blue: 0.043, alpha: 1);
        self.view.addSubview(lineView!);
        
        animation_y = CABasicAnimation.init(keyPath: "transform.translation.y");
        let toValue :Float = Float(SCREEN_WIDTH);
        animation_y?.toValue = NSNumber.init(value: toValue);
        
        animation_y?.autoreverses = true;
        animation_y?.fillMode = kCAFillModeForwards;
        animation_y?.repeatCount = MAXFLOAT;
        animation_y?.duration = 2.0;

//        
//        UILabel *  lblTip = [[UILabel alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-110, SCREEN_WIDTH, 15)];
//        lblTip.text = @"请对准二维码到框内（距离30cm左右）";
//        lblTip.textColor = [UIColor whiteColor];
//        lblTip.font = [UIFont systemFontOfSize:13];
//        lblTip.textAlignment = NSTextAlignmentCenter;
//        [self.view addSubview:lblTip];
//        
//        UILabel *  detaillblTip = [[UILabel alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-80, SCREEN_WIDTH, 15)];
//        detaillblTip.text = @"打开WIFI、GPS开关可提高定位精准度";
//        detaillblTip.textColor = [UIColor whiteColor];
//        detaillblTip.font = [UIFont systemFontOfSize:13];
//        detaillblTip.textAlignment = NSTextAlignmentCenter;
//        [self.view addSubview:detaillblTip];
    }
//    MARK : 灯光开关
    func switchTorchStatus () {
        if torchON == false {
            torchON = true;
        }
        else{
            torchON = false;
        }
        turnTorchOn(status: torchON!);
    }
    func turnTorchOn(status:Bool) -> Void {
        if let _ :AnyClass = NSClassFromString("AVCaptureDevice"){
            let device :AVCaptureDevice? = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo);
            if device?.hasTorch == true && device?.hasFlash == true{
                try?device?.lockForConfiguration();
                if status == true{
                    device?.torchMode = AVCaptureTorchMode.on;
                    device?.flashMode = AVCaptureFlashMode.on;
                }
                else{
                    device?.torchMode = AVCaptureTorchMode.off;
                    device?.flashMode = AVCaptureFlashMode.off;
                }
                device?.unlockForConfiguration();
            }
        }
    }
    func startReadCode () {
        if session != nil {
            session?.startRunning();
            lineView?.layer.add(animation_y!, forKey: "scanCode")
        }
    }
    func stopReadCode () {
        session?.stopRunning();
        lineView?.layer .removeAllAnimations();
        turnTorchOn(status: false);

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Navigation
    internal func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if (metadataObjects.count>0) {
            //输出扫描字符串
            stopReadCode();
            if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject{
                codeValue = metadataObject.stringValue;
                print(codeValue);
            }
            
        }

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
