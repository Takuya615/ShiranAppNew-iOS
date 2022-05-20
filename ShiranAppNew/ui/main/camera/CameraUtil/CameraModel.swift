

import SwiftUI
import AVFoundation

class CameraModel{
    var delegate: AVCaptureVideoDataOutputSampleBufferDelegate!
    init(delegate: AVCaptureVideoDataOutputSampleBufferDelegate) {
        self.delegate = delegate
    }
    var session: AVCaptureSession!// カメラからの入出力データをまとめるセッション
    func setViewWillAppear() {
        UIApplication.shared.isIdleTimerDisabled = true  //この画面をスリープさせない。
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else{return}
        // FPSの設定
        //videoDevice.activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: 30)
        do {
            // 入力設定
            let input = try AVCaptureDeviceInput(device: videoDevice)
            // 出力設定
            let output: AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
            // 出力設定: カラーチャンネル
            output.videoSettings = [kCVPixelBufferPixelFormatTypeKey : kCVPixelFormatType_32BGRA] as [String : Any]
            // 出力設定: デリゲート、画像をキャプチャするキュー
            output.setSampleBufferDelegate(delegate, queue: DispatchQueue(label: "videoQueue"))
            // 出力設定: キューがブロックされているときに新しいフレームが来たら削除
            output.alwaysDiscardsLateVideoFrames = true
            // セッションの作成
            self.session = AVCaptureSession()
            // 解像度を設定
            self.session.sessionPreset = .medium//.high//.hd4K3840x2160
            // セッションに追加.
            if self.session.canAddInput(input) && self.session.canAddOutput(output) {
                self.session.addInput(input)
                self.session.addOutput(output)
                
                self.session.startRunning()
            }
        } catch _ {return}
    }
    func setViewWillDisappear() {
        UIApplication.shared.isIdleTimerDisabled = false
    }
    func setViewDidDisappear() {
        self.session.stopRunning()
        // メモリ解放
        for output in self.session.outputs {
            self.session.removeOutput(output as AVCaptureOutput)
        }
        for input in self.session.inputs {
            self.session.removeInput(input as AVCaptureInput)
        }
        self.session = nil
        UserDefaults.standard.set(0, forKey: Keys.qTime.rawValue)
        UserDefaults.standard.set(0, forKey: Keys.questNum.rawValue)
        UserDefaults.standard.set(0, forKey: Keys.questType.rawValue)
    }
    
    static func taskTime() -> Int{
        let qT = UserDefaults.standard.integer(forKey: Keys.qTime.rawValue)
        if qT != 0 { return qT }
        var taskTime: Int = UserDefaults.standard.integer(forKey: Keys.taskTime.rawValue)
        if taskTime < 5 {taskTime = 5}
        if taskTime > 240 {taskTime = 240}
        return taskTime
    }
    static func min(time: Int) -> String{
        if time<60 {return String(time)}
        let min = time/60
        let sec = time%60
        return String("\(min):\(sec)")
    }
    
    static func check(pose: Pose,size: CGSize, isRecording:Bool, jump:Bool?) -> Bool{
        //return false
        if jump != nil {
            //地面に手をついた時だけは信頼性を無視
            if isRecording && !jump! {
                if pose[.leftWrist].position.y > size.height*7/8 && pose[.rightWrist].position.y > size.height*7/8 {
                    return false
                }
            }
        }
        
        for l in [pose[.leftAnkle],pose[.rightAnkle],pose[.leftWrist],pose[.rightWrist],pose[.nose]] {
            if l.confidence < 0.1 {return true}
            if l.position.x < 0 || l.position.x > size.width {return true}
            if l.position.y < 0 || l.position.y > size.height {return true}
        }
        return false
        
        
    }
}
