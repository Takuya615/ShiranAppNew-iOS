//
//  ViewController2.swift
//  ShiranApp
//
//  Created by user on 2021/08/23.
//

import SwiftUI
import AVFoundation
import Instructions
import Vision
import CoreML
import UIKit
import VideoToolbox
import Firebase


struct VideoCameraView: UIViewControllerRepresentable {
    @Binding var isVideo: Bool
    //@EnvironmentObject var dataCounter: DataCounter
    func makeUIViewController(context: Context) -> UIViewController {
        return VideoViewController(videoCameraView: self)
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}


class VideoViewController: UIViewController {
    
    private var model : VideoCameraViewModel!
    let poseImageView = PoseImageView()
    private var poseNet: PoseNet!
    private var currentFrame: CGImage?
    // カメラからの入出力データをまとめるセッション
    var session: AVCaptureSession!
    // プレビューレイヤ
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
//
//    var state: Int = DataCounter.setDailyState()//  diff.dayの数値
//    let qType = UserDefaults.standard.integer(forKey: Keys.questType.rawValue)
//
//    var count = 0
//    var recordButton: UIButton!
//
//    var isRecording = false
//    var isResult = false
//
//    var scoreBoad: UILabel!
//    var score:Float = 0.0
//    var prePose: Pose! = Pose()
//    var timesBonus: Float = 1.0
//    var difBonus: Float = 1.0
//    var myPoseList: [Int] = []
//    var friPoseList: [Int] = []
//    var poseNum: Int = 0
//
//    var time = 3
//    var timer = Timer()
//    var textTimer: UILabel!
//    var countDown = true
//
//    var switchTime = 20
//    var rest = false
//
//    //コーチマーク用
//    /*var coachController = CoachMarksController()
//    var messages:[String] = []
//    var views: [UIView] = []*/
//    let difficult = UserDefaults.standard.integer(forKey: Keys.difficult.rawValue)//1 2 3
//    var exiteBoss: boss? = BOSS().isExist()
//    var bossHPbar: UIProgressView!
//    var bossImage: UIImageView!
//    var killList: [boss] = []
    
    var videoCameraView:VideoCameraView
    init(videoCameraView:VideoCameraView) {
        self.videoCameraView = videoCameraView
        
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.coachController.dataSource = self//CoachMark
        do {
            poseNet = try PoseNet()
            model = VideoCameraViewModel(_self: self)
        } catch {
            fatalError("Failed to load model. \(error.localizedDescription)")
        }
        poseNet.delegate = self
        /*let db = Firestore.firestore().collection("users").whereField("name", isEqualTo: "つむ")
        db.getDocuments() { (querySnapshot, err) in
            if err != nil {return}
            guard let poseList: [Int] = querySnapshot!.documents[0].data()["poseList"] as? [Int] else{print("フレンドリストなし");return}
            self.friPoseList = poseList
        }*/
        
        model.timesBonus = CharacterModel.useTaskHelper()
        
    }
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      UIApplication.shared.isIdleTimerDisabled = true  //この画面をスリープさせない。
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
        // Viewが閉じられたとき、セッションを終了
        /*if !AppState().coachMark2{
            self.coachController.stop(immediately: true)//CoachMark
            UserDefaults.standard.set(true, forKey: "CoachMark2")//CoachMark
        }*/
        
        self.session.stopRunning()
        // メモリ解放
        for output in self.session.outputs {
            self.session.removeOutput(output as AVCaptureOutput)
        }
        for input in self.session.inputs {
            self.session.removeInput(input as AVCaptureInput)
        }
        self.session = nil
        
        model.isRecording = false
        model.timer.invalidate()
        if !model.countDown {
            //DataCounter().saveMyPose(poseList: myPoseList)　　　　　　　　　　　　　　　自分ポーズを保存！！
            //let save = SaveVideo().environmentObject(DataCounter())
            //SaveVideo().saveData(score: Int(score)/100)
            //self.videoCameraView.dataCounter.scoreCounter(score: Int(score * timesBonus)/100)
        }
        
    }

    private func initCamera() {
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
            output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
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
                model.setUpCaptureButton()
            }
        }
        catch _ {
            print("error occurd")
        }
    }
    
    
    
}

extension VideoViewController: AVCaptureVideoDataOutputSampleBufferDelegate{
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
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


extension VideoViewController: PoseNetDelegate {
    func poseNet(_ poseNet: PoseNet, didPredict predictions: PoseNetOutput) {
        defer { self.currentFrame = nil }

        if self.currentFrame == nil {return}
        //guard let currentFrame = currentFrame else {return}

        
        /*if isResult {
            let poseImage = PoseImageView.showDial()
            let poseImageView = UIImageView(image: poseImage)
            poseImageView.layer.position = CGPoint(x: self.view.bounds.size.width/2, y:60 + poseImage.size.height/2)
            //poseImageView.isOpaque = false
            //self.view.subviews.last?.removeFromSuperview()//直近のsubViewだけ、描画のリセット
             self.view.addSubview(poseImageView)
            return
        }*/
        
        let poseBuilder = PoseBuilder(output: predictions,
                                      configuration: PoseBuilderConfiguration(),
                                      inputImage: self.currentFrame!)
        let pose = poseBuilder.pose
        let check = model.check(pose: pose, size: self.currentFrame!.size)
        if check {
            let poseImage = poseImageView.showMiss(on: self.currentFrame!)
            let poseImageView = UIImageView(image: poseImage)
            poseImageView.layer.position = CGPoint(x: self.view.bounds.size.width/2, y:60 + poseImage.size.height/2)
            //poseImageView.isOpaque = false
            self.view.subviews.last?.removeFromSuperview()//直近のsubViewだけ、描画のリセット
            self.view.addSubview(poseImageView)
            return
        }
        //フレンドの描画部分
        let fPose = Pose()
        if !model.countDown{
            let namelist = Pose().joints2
            //自分のポーズを保存
            for i in 0 ... namelist.count-1 {
                if pose[namelist[i]].isValid {
                    model.myPoseList.append(Int(pose[namelist[i]].position.x))
                    model.myPoseList.append(Int(pose[namelist[i]].position.y))
                }else{
                    model.myPoseList.append(-1); model.myPoseList.append(-1)
                }
            }
            //友達のポーズを引っ張ってきてプレイ！
            if !model.friPoseList.isEmpty {
                var n = 0
                for i in stride(from: 0, to: 26, by: 2) {
                    if model.friPoseList[i] > -1 {
                        fPose[namelist[n]].isValid = true
                        fPose[namelist[n]].position = CGPoint(x: model.friPoseList[i], y: model.friPoseList[i+1])
                        if model.isRecording {//フレンドのスコアを追加する
                            model.score += Float(abs(model.friPoseList[i] - model.friPoseList[i+26])) / 100
                        }
                        
                    }
                    n += 1
                }
                model.friPoseList.removeFirst(26)
            }
        }
        //自分とフレンドの動きを描画
        let poseImage: UIImage = poseImageView.show(
            state: model.state, qType: 0,
            prePose: model.prePose,
            pose: pose,//自分のポーズ
            friPose: fPose,//フレンドのポーズ
            on: self.currentFrame!)
        let size = self.view.bounds.size
        let poseImageView = UIImageView(image: poseImage)
        poseImageView.layer.position = CGPoint(x: size.width/2, y:60 + poseImage.size.height/2)
        //poseImageView.isOpaque = false
        self.view.subviews.last?.removeFromSuperview()//直近のsubViewだけ、描画のリセット
        self.view.addSubview(poseImageView)
//        if !isRecording {
//            self.view.subviews.last?.removeFromSuperview()//直近のsubViewだけ、描画のリセット
//        }
        
        //スコアやボスの表示
        if model.state > 0 { //デイリーのばあい
            let damage: Float = UserDefaults.standard.float(forKey: Keys.damage.rawValue)
            model.bossHPbar.progress = Float((model.score + damage) / model.exiteBoss!.maxHp)
            //モンスターを倒した
            if (model.score + damage) > model.exiteBoss!.maxHp{
                SystemSounds.attack()
                model.killList.append(model.exiteBoss!)
                model.score = 0
                model.exiteBoss = BOSS().newBoss()
                model.bossImage.image = UIImage(named: model.exiteBoss!.image)// = UIImageView(image: UIImage(named: exiteBoss!.image))
            }
            //self.bossHPbar.setProgress(self.bossHPbar.progress, animated: true)
        }else{
            model.scoreBoad.text = str.score2.rawValue + String(Int(model.score))
            //if qType == 2 { self.poseImageView.qScore = Int(score) }
        }
        model.prePose = model.culculateScore(pose: pose, prePose: model.prePose)
        //prePose = culculateScore(pose: pose, prePose: prePose)
        
    }
    
    
}

