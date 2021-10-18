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


//カメラのビュー
struct VideoCameraView: UIViewControllerRepresentable {
    @Binding var isVideo: Bool
    @EnvironmentObject var dataCounter: DataCounter
    func makeUIViewController(context: Context) -> UIViewController {
        return VideoViewController(videoCameraView: self)
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}


class VideoViewController: UIViewController {
    
    //var pD = OriginalPoseDetection()
    //var poseDetect = PoseDetectionModel()
    private var poseNet: PoseNet!
    private var currentFrame: CGImage?
    // カメラからの入出力データをまとめるセッション
    var session: AVCaptureSession!
    // プレビューレイヤ
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    var count = 0
    var recordButton: UIButton!
    var isRecording = false
    
    var scoreBoad: UILabel!
    var score:Float = 0.0
    var prePose: Pose!
    var timesBonus: Float = 1.0
    var myPoseList: [Pose]!
    
    var time = 4
    var timer = Timer()
    var textTimer: UILabel!
    var countDown = true
    
    //コーチマーク用
    var coachController = CoachMarksController()
    var messages:[String] = []
    var views: [UIView] = []
    
    var exiteBoss: boss? = BOSS().isExist()
    var isBoss: Bool = false
    var bossHPbar: UIProgressView!
    
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
        self.coachController.dataSource = self//CoachMark
        do {
            poseNet = try PoseNet()
        } catch {
            fatalError("Failed to load model. \(error.localizedDescription)")
        }
        poseNet.delegate = self
        //poseDetect.delegate = self
        timesBonus = Character().useTaskHelper()
        if exiteBoss != nil { view.backgroundColor = .black; isBoss = true }
        EventAnalytics().tapFab()
        
    }
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      UIApplication.shared.isIdleTimerDisabled = true  //この画面をスリープさせない。
    }
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      UIApplication.shared.isIdleTimerDisabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        self.initCamera()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Viewが閉じられたとき、セッションを終了
        if !AppState().coachMark2{
            self.coachController.stop(immediately: true)//CoachMark
            UserDefaults.standard.set(true, forKey: "CoachMark2")//CoachMark
        }
        
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
        
        if !countDown {
            DataCounter().saveMyPose(poseList: myPoseList)
            //let save = SaveVideo().environmentObject(DataCounter())
            //SaveVideo().saveData(score: Int(score)/100)
            //self.videoCameraView.dataCounter.scoreCounter(score: Int(score * timesBonus)/100)
        }
        
    }

    private func initCamera() {
        // バックカメラを取得
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
            self.session.sessionPreset = .medium

            // セッションに追加.
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
        // 画像を表示するレイヤーを生成
        self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
        // カメラ入力の縦横比を維持したまま、レイヤーいっぱいに表示
        self.videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        // 縦向きで固定
        //self.videoPreviewLayer.connection?.videoOrientation = .portrait
        // previewViewに追加
        self.view.layer.addSublayer(videoPreviewLayer)
        self.setUpCaptureButton()
        // startRunningメソッドはブロッキングメソッドなので、非同期に並列処理を行う
        // qos引数は処理の優先順位
        DispatchQueue.global(qos: .userInitiated).async {
            // セッション開始
            self.session.startRunning()
            // 上記処理の終了後、下記処理をメインスレッドで実行
            DispatchQueue.main.async {
                // 'previewView'の大きさに'videoPreviewLayer'をリサイズ
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
        
        if isBoss {
            let alert1 = BOSS().showBOSS(boss: exiteBoss!)
            self.present(alert1, animated: true, completion: nil)
            
            self.bossHPbar = UIProgressView(frame: CGRect(x: 0, y: 0, width: rect.width-20, height: 80))
            self.bossHPbar.progress = 0.0//Float(damage / exiteBoss!.maxHp)
            self.bossHPbar.progressTintColor = .gray
            self.bossHPbar.backgroundColor = .red
            //self.bossHPbar.setProgress(bossHPbar.progress, animated: true)
            self.bossHPbar.transform = CGAffineTransform(scaleX: 1.0, y: 10.0)
            self.bossHPbar.layer.position = CGPoint(x: rect.width/2, y: rect.height-42)
            self.bossHPbar.isHidden = true
            self.view.addSubview(self.bossHPbar)

        }else{
            self.scoreBoad = UILabel(frame: CGRect(x: 0, y: 0, width: rect.width, height: 80))
            self.scoreBoad.layer.position = CGPoint(x: rect.width/2, y: rect.height-42)
            self.scoreBoad.text = "Score"
            self.scoreBoad.textColor = UIColor.blue
            //self.scoreBoad.backgroundColor = UIColor.red
            self.scoreBoad.font = UIFont.systemFont(ofSize: 50)
            self.scoreBoad.isHidden = true
            self.view.addSubview(self.scoreBoad)
        }
        
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
        
        if !AppState().coachMark2 {
            self.coachController.start(in: .window(over: self))
        }
        /*
        if !AppState().coachMark2 {
            let MainView = UIHostingController(rootView: IntroView(imageName: "sample", number: 0).environmentObject(AppState()))//ContentView())
            MainView.presentationController?.delegate = self
            self.present(MainView, animated: true, completion:nil)
        }*/

    }
    
    @objc func onClickBackButton(sender: UIButton) {
        self.videoCameraView.isVideo = false
    }
    @objc func onClickRecordButton(sender: UIButton) {
        var Ring = false
        self.recordButton.isHidden = true
        if isBoss {self.bossHPbar.isHidden = false} else {self.scoreBoad.isHidden = false}
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.time -= 1
            
            if self.countDown {
                if !Ring {
                    Ring = true
                    SystemSounds().countDown("")
                }
                self.textTimer.text = String(self.time)
                self.textTimer.textColor = UIColor.orange
                //self.textTimer.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
                //self.textTimer.font = UIFont.systemFont(ofSize: 200)
                //self.textTimer.layer.position = CGPoint(x: self.view.bounds.width / 2 , y: self.view.bounds.height * 0.5)
            }else{
                self.textTimer.text = self.min(time: self.time)
                self.textTimer.textColor = UIColor.blue
                //self.textTimer.frame = CGRect(x: 0, y: 0, width: 120, height: 50)
                //self.textTimer.font = UIFont.systemFont(ofSize: 50)
                //self.textTimer.layer.position = CGPoint(x: self.view.bounds.width / 2 , y: self.view.bounds.height * 0.01)
            }
            
            
            if self.time == 0 {
                if self.countDown{
                    //   moment of 0 Sec
                    self.countDown = false
                    self.isRecording = true
                    self.time = self.taskTime() //                           本編スタート
                }else{
                    print("撮影終了")
                    SystemSounds().buttonVib("")
                    SystemSounds().buttonSampleWav("")
                    //SystemSounds().EndVideoRecording()
                    self.isRecording = false
                    timer.invalidate()//timerの終了
                    if self.isBoss {self.bossHPbar.isHidden = true} else {self.scoreBoad.isHidden = true}
                    
                    let num = self.videoCameraView.dataCounter.scoreCounter(score: Int(self.score))
                    //DataCounter().scoreCounter(view: self.videoCameraView,score: Int(self.score))
                    let alert = self.videoCameraView.dataCounter.showResult(view: self.videoCameraView,boss: self.exiteBoss,
                                                  score: self.score,bonus: self.timesBonus,num: num)
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
            
        })
    }
    
    func taskTime() -> Int{
        var taskTime: Int = UserDefaults.standard.integer(forKey: DataCounter().taskTime)
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

extension VideoViewController: AVCaptureVideoDataOutputSampleBufferDelegate{
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


extension VideoViewController: PoseNetDelegate {
    func poseNet(_ poseNet: PoseNet, didPredict predictions: PoseNetOutput) {
        defer {
            // Release `currentFrame` when exiting this method.
            self.currentFrame = nil
        }

        if self.currentFrame == nil {return}
        //guard let currentFrame = currentFrame else {return}

        let poseBuilder = PoseBuilder(output: predictions,
                                      configuration: PoseBuilderConfiguration(),
                                      inputImage: self.currentFrame!)

        let pose = poseBuilder.pose
        
        //print("currentFrame = \(String(describing: self.currentFrame))  ,  view.size = \(self.view.bounds.size)")
        if !self.countDown{
            myPoseList.append(pose)
        }
        
        
        
        
        //ココにFirebaseからのPoseデータを読み込んで、PoseImageView().showに読み込ませられれば、友達の行動とリンクして遊べるようになる！！
        //0.5秒おきにPoseを渡す。みたいな感じになると思う
        
        
        
        
        
        
        
        let poseImage: UIImage = PoseImageView().show(
            pose: pose,
            on: self.currentFrame!)
        
        //print("poseImage  = \(poseImage.size)")
        //print("view = \(self.view.bounds.size)")
        let size = self.view.bounds.size
        let poseImageView = UIImageView(image: poseImage)
        poseImageView.layer.position = CGPoint(x: size.width/2, y:50 + poseImage.size.height/2)
        //poseImageView.isOpaque = false
        self.view.subviews.last?.removeFromSuperview()//直近のsubViewだけ、描画のリセット
        self.view.addSubview(poseImageView)
        
        if exiteBoss != nil {
            let damage: Float = UserDefaults.standard.float(forKey: DataCounter().damage)
            //print("スコア\(score)　ダメージ\(damage)　マックス\(exiteBoss!.maxHp)　計算結果\(Float((score + damage) / exiteBoss!.maxHp))")
            self.bossHPbar.progress = Float((score + damage) / exiteBoss!.maxHp)
            //self.bossHPbar.setProgress(self.bossHPbar.progress, animated: true)
        }else{
            self.scoreBoad.text = "Score \(Int(score))"//スコア更新
        }
        
        
        if !isRecording {return}
        
        //if pose.confidence < 0.1 {return}//print("人写ってない");
        if prePose == nil {
            prePose = pose
        }else{
            
            Joint.Name.allCases.forEach {name in
                
                if pose.joints[name] != nil && prePose.joints[name] != nil{
                    if pose.joints[name]!.confidence > 0.1 && prePose.joints[name]!.confidence > 0.1 {
                        let disX = abs(pose.joints[name]!.position.x - prePose.joints[name]!.position.x)
                        let disY = abs(pose.joints[name]!.position.y - prePose.joints[name]!.position.y)
                        let sum = Float(disY + disX)/100*timesBonus
                        score = score + sum
                    }
                }
                
            }
            prePose = pose
        }
    }
}
