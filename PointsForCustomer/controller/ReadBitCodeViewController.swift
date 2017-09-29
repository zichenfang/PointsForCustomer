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
    var torchON : Bool?
    var codeValue : String!
    var device :AVCaptureDevice!

    var input :AVCaptureDeviceInput!
    var output : AVCaptureMetadataOutput!
    var kuangView :KuangkuangView!

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
        let authStatus : AVAuthorizationStatus? = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == AVAuthorizationStatus.restricted || authStatus == AVAuthorizationStatus.denied{
            let alertVC = UIAlertController.init(title: "相机权限受限,请在设备的设置-隐私-相机中允许访问相机。", message: nil, preferredStyle: UIAlertControllerStyle.alert);
            alertVC .addAction(UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default, handler: nil));
            self.present(alertVC, animated: true, completion: nil);
            return;
        }
        device = AVCaptureDevice.default(for: AVMediaType.video);
        do{
            input = try AVCaptureDeviceInput.init(device: device!);
            output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main);
            session = AVCaptureSession();
            session!.canSetSessionPreset(AVCaptureSession.Preset.high);
            if session!.canAddInput(input){
                session!.addInput(input!);
            }
            if session!.canAddOutput(output) {
                session!.addOutput(output);
            }
            
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr,AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.ean8, AVMetadataObject.ObjectType.code128];
            let layer = AVCaptureVideoPreviewLayer.init(session: session!);
            layer.videoGravity = AVLayerVideoGravity.resizeAspectFill;
            layer.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64);
            self.view.layer.insertSublayer(layer, at: 0);
        }
        catch{
            ProgressHUD.showError("摄像头不可用");
        }
        //半透明镂空涂层 
        kuangView = KuangkuangView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64));
        self.view.addSubview(kuangView!);

    }
//    MARK: 灯光开关
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
            let device :AVCaptureDevice? = AVCaptureDevice.default(for: AVMediaType.video);
            if device?.hasTorch == true && device?.hasFlash == true{
                try?device?.lockForConfiguration();
                if status == true{
                    device?.torchMode = AVCaptureDevice.TorchMode.on;
                    device?.flashMode = AVCaptureDevice.FlashMode.on;
                }
                else{
                    device?.torchMode = AVCaptureDevice.TorchMode.off;
                    device?.flashMode = AVCaptureDevice.FlashMode.off;
                }
                device?.unlockForConfiguration();
            }
        }
    }
    func startReadCode () {
        if session != nil {
            session!.startRunning();
            kuangView.begainAnimation();
        }
    }
    func stopReadCode () {
        session?.stopRunning();
        kuangView.stopAnimation();
        turnTorchOn(status: false);

    }
    // MARK: - 读取到二维码内容
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if (metadataObjects.count>0) {
            //输出扫描字符串
            //播放扫码声音
            var soundID:SystemSoundID = 0
            AudioServicesCreateSystemSoundID(URL.init(string: Bundle.main.path(forResource: "qrcode_found", ofType: "wav")!)! as CFURL, &soundID)
            AudioServicesPlaySystemSound(soundID)
            stopReadCode();
            if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject{
                codeValue = metadataObject.stringValue;
                print(codeValue);
                let vc = PayNowViewController();
                vc.title = codeValue;
                vc.hidesBottomBarWhenPushed = true;
                self.navigationController?.pushViewController(vc, animated: true);
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
