//
//  QuestCameraView.swift
//  ShiranAppNew
//
//  Created by user on 2021/12/14.
//

import SwiftUI
import AVFoundation
import Instructions
import Vision
import CoreML
import UIKit
import VideoToolbox
import Firebase


//カメラのビュー
struct QuestCameraView: UIViewControllerRepresentable {
    @Binding var isVideo: Bool
    @EnvironmentObject var dataCounter: DataCounter
    func makeUIViewController(context: Context) -> UIViewController {
        return QuestCameraViewController(questCameraView: self)
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}


class QuestCameraViewController: UIViewController {
    
//    //var pD = OriginalPoseDetection()
//    //var poseDetect = PoseDetectionModel()
//    let poseImageView = PoseImageView()
    private var model : QuestCameraViewModel!
    private var poseNet: PoseNet!
    private var currentFrame: CGImage?
    // カメラからの入出力データをまとめるセッション
    var session: AVCaptureSession!
    // プレビューレイヤ
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
//    
//    //var state: Int = DataCounter.setDailyState()//  diff.dayの数値
//    let qType = UserDefaults.standard.integer(forKey: Keys.questType.rawValue)
//    
//    var count = 0
//    var recordButton: UIButton!
//    var isRecording = false
//    
//    var scoreBoad: UILabel!
//    var score:Float = 0.0
//    var prePose: Pose! = Pose()
//    var timesBonus: Float = 1.0
//    var myPoseList: [Int] = []
//    var friPoseList: [Int] = []
//    var poseNum: Int = 0
//    
//    var time = 4
//    var timer = Timer()
//    var textTimer: UILabel!
//    var countDown = true
//    
//    var exiteBoss: boss? = BOSS().isExist()
//    var bossHPbar: UIProgressView!
//    var bossImage: UIImageView!
//    var killList: [boss] = []
    
    var questCameraView:QuestCameraView
    init(questCameraView:QuestCameraView) {
        self.questCameraView = questCameraView
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            poseNet = try PoseNet()
            model = QuestCameraViewModel(_self: self)
        } catch {
            fatalError("Failed to load model. \(error.localizedDescription)")
        }
        poseNet.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      UIApplication.shared.isIdleTimerDisabled = true  //この画面をスリープさせない。'
        self.initCamera()
    }
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      UIApplication.shared.isIdleTimerDisabled = false
    }
    
    /*override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        self.initCamera()
    }*/

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        model.isRecording = false
        model.timer.invalidate()
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
    private func initCamera() {
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else{return}
        do {
            let input = try AVCaptureDeviceInput(device: videoDevice)
            let output: AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
            output.videoSettings = [kCVPixelBufferPixelFormatTypeKey : kCVPixelFormatType_32BGRA] as [String : Any]
            output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            output.alwaysDiscardsLateVideoFrames = true

            self.session = AVCaptureSession()
            self.session.sessionPreset = .medium
            if self.session.canAddInput(input) && self.session.canAddOutput(output) {
                self.session.addInput(input)
                self.session.addOutput(output)

                self.session.startRunning()
                model.setUpCaptureButton()
                // プレビュー開始
                //self.startPreview()
            }
        }
        catch _ {
            print("error occurd")
        }
    }

    
    
}

extension QuestCameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate{
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        //print("1フレームごとの処理をここに書く")
        
        connection.videoOrientation = .portrait//UpsideDown
        connection.isVideoMirrored = true
        
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        let ciimage : CIImage = CIImage(cvPixelBuffer: imageBuffer)
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(ciimage, from: ciimage.extent)!
        DispatchQueue.main.sync {
            guard currentFrame == nil else {
                return
            }
            //if cgImage == nil {print("image取得できていない");return}
            currentFrame = cgImage
            poseNet.predict(cgImage)
        }
        
    }
}


extension QuestCameraViewController: PoseNetDelegate {
    func poseNet(_ poseNet: PoseNet, didPredict predictions: PoseNetOutput) {
        defer { self.currentFrame = nil }

        if self.currentFrame == nil {return}
        //guard let currentFrame = currentFrame else {return}

        let poseBuilder = PoseBuilder(output: predictions,
                                      configuration: PoseBuilderConfiguration(),
                                      inputImage: self.currentFrame!)
        let pose = poseBuilder.pose
        let check = model.check(pose: pose, size: self.currentFrame!.size)
        if check {
            let poseImage = model.poseImageView.showMiss(on: self.currentFrame!)
            let poseImageView = UIImageView(image: poseImage)
            poseImageView.layer.position = CGPoint(x: self.view.bounds.size.width/2, y:60 + poseImage.size.height/2)
            //poseImageView.isOpaque = false
            self.view.subviews.last?.removeFromSuperview()//直近のsubViewだけ、描画のリセット
            self.view.addSubview(poseImageView)
            return
        }
        //自分とフレンドの動きを描画
        let poseImage: UIImage = model.poseImageView.show(
            state: 0, qType: model.qType,
            prePose: model.prePose,
            pose: pose,//自分のポーズ
            friPose: pose,//フレンドのポーズ
            on: self.currentFrame!)
        let size = self.view.bounds.size
        let poseImageView = UIImageView(image: poseImage)
        poseImageView.layer.position = CGPoint(x: size.width/2, y:60 + poseImage.size.height/2)
        //poseImageView.isOpaque = false
        self.view.subviews.last?.removeFromSuperview()//直近のsubViewだけ、描画のリセット
        self.view.addSubview(poseImageView)
        
        //self.scoreBoad.text = "Score \(Int(score))"//スコア更新
        if model.qType == 2 { model.poseImageView.qScore = Int(model.score) }
        model.prePose = model.culculateScore(pose: pose, prePose: model.prePose)
        
    }
    
}

