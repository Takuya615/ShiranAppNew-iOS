//
//  CameraModel.swift
//  ShiranAppNew
//
//  Created by 津村拓哉 on 2022/04/15.
//

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
        } catch _ {print("error occurd")}
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
    }
    
}
