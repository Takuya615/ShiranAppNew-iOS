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
    
    //var pD = OriginalPoseDetection()
    //var poseDetect = PoseDetectionModel()
    let poseImageView = PoseImageView()
    private var poseNet: PoseNet!
    private var currentFrame: CGImage?
    // カメラからの入出力データをまとめるセッション
    var session: AVCaptureSession!
    // プレビューレイヤ
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    var state: Int = DataCounter().setDailyState()//  diff.dayの数値
    let qType = UserDefaults.standard.integer(forKey: Keys.questType.rawValue)
    
    var count = 0
    var recordButton: UIButton!
    var isRecording = false
    
    var scoreBoad: UILabel!
    var score:Float = 0.0
    var prePose: Pose! = Pose()
    var timesBonus: Float = 1.0
    var myPoseList: [Int] = []
    var friPoseList: [Int] = []
    var poseNum: Int = 0
    
    var time = 4
    var timer = Timer()
    var textTimer: UILabel!
    var countDown = true
    
    var exiteBoss: boss? = BOSS().isExist()
    var bossHPbar: UIProgressView!
    var bossImage: UIImageView!
    var killList: [boss] = []
    
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
        
        self.isRecording = false
        timer.invalidate()
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
                self.setUpCaptureButton()
                // プレビュー開始
                //self.startPreview()
            }
        }
        catch _ {
            print("error occurd")
        }
    }

    private func startPreview() {
        self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
        self.videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        self.view.layer.addSublayer(videoPreviewLayer)
        self.setUpCaptureButton()
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
            DispatchQueue.main.async {
                let frame = self.view.bounds
                self.videoPreviewLayer.frame = CGRect(x: 10, y: 0,
                                                      width: frame.width - 20,
                                                      height: frame.height)//self.view.bounds
            }
        }
        
    }
    func setUpCaptureButton(){
        let rect = self.view.bounds.size
        
        //TimerBoard
        self.textTimer = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 50))
        self.textTimer.text = self.min(time: self.taskTime())
        self.textTimer.textColor = UIColor.blue
        self.textTimer.backgroundColor = .white
        self.textTimer.font = UIFont.systemFont(ofSize: 50)
        self.textTimer.textAlignment = NSTextAlignment.center
        self.textTimer.center = CGPoint(x: rect.width/2, y: 25)//rect.height*0.01)
        self.textTimer.layer.borderColor = UIColor.blue.cgColor
        self.textTimer.layer.borderWidth = 2
        self.textTimer.layer.masksToBounds = true
        self.textTimer.layer.cornerRadius = 10
        self.view.addSubview(textTimer)//subView 1
        
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 50))
        backButton.setTitle("< Back", for: .normal)
        backButton.setTitleColor(UIColor.blue, for: .normal)
        backButton.backgroundColor = UIColor.clear
        backButton.center = CGPoint(x: 45, y: 25)
        //backButton.layer.cornerRadius = 5
        //backButton.layer.position = CGPoint(x: rect.width / 2, y:rect.height - 80)
        backButton.addTarget(self, action: #selector(self.onClickBackButton(sender:)), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        
        self.scoreBoad = UILabel(frame: CGRect(x: 0, y: 0, width: rect.width, height: 80))
        self.scoreBoad.layer.position = CGPoint(x: rect.width/2, y: rect.height-42)
        self.scoreBoad.text = "Score"
        self.scoreBoad.textColor = UIColor.blue
        //self.scoreBoad.backgroundColor = UIColor.red
        self.scoreBoad.font = UIFont.systemFont(ofSize: 50)
        self.scoreBoad.isHidden = true
        self.view.addSubview(self.scoreBoad)
        
        // recording button
        self.recordButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        self.recordButton.backgroundColor = UIColor.orange
        self.recordButton.layer.masksToBounds = true
        self.recordButton.layer.cornerRadius = self.recordButton.frame.width/2
        self.recordButton.setTitle("START", for: .normal)
        //self.recordButton.layer.cornerRadius = 20
        self.recordButton.layer.position = CGPoint(x: rect.width / 2, y:rect.height - 42)
        self.recordButton.addTarget(self, action: #selector(self.onClickRecordButton(sender:)), for: .touchUpInside)
        self.view.addSubview(recordButton)//subView 0
        
        
        let der = UILabel()// あとで消す用のUIView
        self.view.addSubview(der)
        
    }
    
    @objc func onClickBackButton(sender: UIButton) {
        self.questCameraView.isVideo = false
    }
    @objc func onClickRecordButton(sender: UIButton) {
        var Ring = false
        self.recordButton.isHidden = true
        if state > 0 {self.bossHPbar.isHidden = false} else {self.scoreBoad.isHidden = false}
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.time -= 1
            
            if self.countDown {
                if !Ring {
                    Ring = true
                    SystemSounds.countDown("")
                }
                self.textTimer.text = String(self.time)
                self.textTimer.textColor = UIColor.orange
                
            }else{
                self.textTimer.text = self.min(time: self.time)
                self.textTimer.textColor = UIColor.blue
            }
            
            
            if self.time == 0 {
                if self.countDown{
                    //   moment of 0 Sec
                    self.countDown = false
                    self.isRecording = true
                    self.poseImageView.gameStart = true//クエストはじめ
                    self.time = self.taskTime() //                           本編スタート
                }else{
                    print("撮影終了")
                    SystemSounds.buttonVib("")
                    SystemSounds.buttonSampleWav("")
                    //SystemSounds().EndVideoRecording()
                    self.isRecording = false
                    self.poseImageView.gameStart = true//クエストゲーム終了
                    timer.invalidate()//timerの終了
                    
                    if self.state > 0 {self.bossHPbar.isHidden = true; self.bossImage.isHidden = true;}
                                 else {self.scoreBoad.isHidden = true}
                    //リザルト表示
                    var alert: UIAlertController = UIAlertController(title: "", message: "", preferredStyle:  UIAlertController.Style.alert)
                    alert = self.questCameraView.dataCounter.showQuestResult(
                        alert: alert, view: self.questCameraView, qType: self.qType,qScore: self.poseImageView.qScore)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
            
        })
    }
    
    func taskTime() -> Int{
        var taskTime: Int = UserDefaults.standard.integer(forKey: Keys.taskTime.rawValue)
        if taskTime < 5 {taskTime = 5}
        if taskTime > 240 {taskTime = 240}
        return taskTime
    }
    func min(time: Int) -> String{
        if time<60 {return String(time)}
        let min = time/60
        let sec = time%60
        return String("\(min):\(sec)")
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
        let check = check(pose: pose, size: self.currentFrame!.size)
        if check {
            let poseImage = poseImageView.showMiss(on: self.currentFrame!)
            let poseImageView = UIImageView(image: poseImage)
            poseImageView.layer.position = CGPoint(x: self.view.bounds.size.width/2, y:60 + poseImage.size.height/2)
            //poseImageView.isOpaque = false
            self.view.subviews.last?.removeFromSuperview()//直近のsubViewだけ、描画のリセット
            self.view.addSubview(poseImageView)
            return
        }
        //自分とフレンドの動きを描画
        let poseImage: UIImage = poseImageView.show(
            state: 0, qType: self.qType,
            prePose: prePose,
            pose: pose,//自分のポーズ
            friPose: pose,//フレンドのポーズ
            on: self.currentFrame!)
        let size = self.view.bounds.size
        let poseImageView = UIImageView(image: poseImage)
        poseImageView.layer.position = CGPoint(x: size.width/2, y:60 + poseImage.size.height/2)
        //poseImageView.isOpaque = false
        self.view.subviews.last?.removeFromSuperview()//直近のsubViewだけ、描画のリセット
        self.view.addSubview(poseImageView)
        
        self.scoreBoad.text = "Score \(Int(score))"//スコア更新
        if qType == 2 { self.poseImageView.qScore = Int(score) }
        prePose = culculateScore(pose: pose, prePose: prePose)
        
    }
    
    func culculateScore(pose: Pose, prePose: Pose) -> Pose{
        //スコアの測定計算
        if !isRecording {return pose}
        Joint.Name.allCases.forEach {name in
            
            if pose.joints[name] != nil && prePose.joints[name] != nil{
                if pose.joints[name]!.confidence > 0.1 && prePose.joints[name]!.confidence > 0.1 {
                    let disX = abs(pose.joints[name]!.position.x - prePose.joints[name]!.position.x)
                    let disY = abs(pose.joints[name]!.position.y - prePose.joints[name]!.position.y)
                    let sum = Float(disY + disX)/100*timesBonus
                    score += sum
                }
            }
        }
        return pose
    }
    func check(pose: Pose,size: CGSize) -> Bool{
        //return false
        let list = [pose[.leftAnkle],pose[.rightAnkle],
                    pose[.leftWrist],pose[.rightWrist],
                    pose[.nose]
        ]
        for l in list {
            if l.confidence < 0.1 {return true}
            if l.position.x < 0 || l.position.x > size.width {return true}
            if l.position.y < 0 || l.position.y > size.height {return true}
        }
        return false
    }
}

