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


//カメラのビュー
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
    
    //var pD = OriginalPoseDetection()
    //var poseDetect = PoseDetectionModel()
    let poseImageView = PoseImageView()
    private var poseNet: PoseNet!
    private var currentFrame: CGImage?
    // カメラからの入出力データをまとめるセッション
    var session: AVCaptureSession!
    // プレビューレイヤ
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    var state: Int = DataCounter.setDailyState()//  diff.dayの数値
    let qType = UserDefaults.standard.integer(forKey: Keys.questType.rawValue)
    
    var count = 0
    var recordButton: UIButton!
    
    var isRecording = false
    var isResult = false
    
    var scoreBoad: UILabel!
    var score:Float = 0.0
    var prePose: Pose! = Pose()
    var timesBonus: Float = 1.0
    var difBonus: Float = 1.0
    var myPoseList: [Int] = []
    var friPoseList: [Int] = []
    var poseNum: Int = 0
    
    var time = 3
    var timer = Timer()
    var textTimer: UILabel!
    var countDown = true
    
    var switchTime = 20
    var rest = false
    
    //コーチマーク用
    /*var coachController = CoachMarksController()
    var messages:[String] = []
    var views: [UIView] = []*/
    let difficult = UserDefaults.standard.integer(forKey: Keys.difficult.rawValue)//1 2 3
    var exiteBoss: boss? = BOSS().isExist()
    var bossHPbar: UIProgressView!
    var bossImage: UIImageView!
    var killList: [boss] = []
    
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
        
        timesBonus = CharacterModel.useTaskHelper()
        
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
                self.setUpCaptureButton()
                // プレビュー開始
                //self.startPreview()
            }
        }
        catch _ {
            print("error occurd")
        }
    }
    /*private func startPreview() {
        // 画像を表示するレイヤーを生成
        self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
        // カメラ入力の縦横比を維持したまま、レイヤーいっぱいに表示
        self.videoPreviewLayer.videoGravity = .resizeAspect//AVLayerVideoGravity.resize//.resizeAspectFill
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
                                                      width: frame.width/10 - 20,
                                                      height: frame.height/10)//self.view.bounds
            }
        }
        
    }*/
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
        
        
        /*let heart2 = UIImageView(image: UIImage(systemName: "heart.fill"))
        heart2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        heart2.layer.position = CGPoint(x: rect.width/2 + 100, y: 25)
        self.view.addSubview(heart2)*/
        
        self.bossHPbar = UIProgressView(frame: CGRect(x: 0, y: 0, width: rect.width-20, height: 30))
        self.bossHPbar.progress = 0.0//Float(damage / exiteBoss!.maxHp)
        self.bossHPbar.progressTintColor = .gray
        self.bossHPbar.backgroundColor = .red
        //self.bossHPbar.setProgress(bossHPbar.progress, animated: true)
        self.bossHPbar.transform = CGAffineTransform(scaleX: 1.0, y: 10.0)
        self.bossHPbar.layer.position = CGPoint(x: rect.width/2, y: rect.height-42)
        self.bossHPbar.isHidden = true
        self.view.addSubview(self.bossHPbar)
        self.bossImage = UIImageView(image: UIImage(named: exiteBoss!.image))
        self.bossImage.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        self.bossImage.layer.position = CGPoint(x: rect.width/2, y: rect.height-42)
        self.view.addSubview(bossImage)
        
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
        
        if !AppState().coachMark2 {
            let alert: UIAlertController = UIAlertController(
                title: "カベに立てかけ、\n↓のSTARTをタップ\n（初回は時間が5秒だけです）", message: "", preferredStyle:  UIAlertController.Style.alert)
            let confirmAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                UserDefaults.standard.set(true, forKey: "CoachMark2 ")
                //self.coachController.start(in: .window(over: self))　コーチマーク
            })
            alert.addAction(confirmAction)
            self.present(alert, animated: true, completion: nil)
            UserDefaults.standard.set(true, forKey: "CoachMark2")
        }
        let der = UILabel()// あとで消す用のUIView
        self.view.addSubview(der)
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
        if state > 0 {
            self.bossHPbar.isHidden = false
            self.view.backgroundColor =  UIColor.init(red: 255/255, green: 102/255, blue: 102/255, alpha: 80/100)
        } else {
            self.scoreBoad.isHidden = false
            self.bossImage.isHidden = true
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            if self.time == 0 {
                if self.countDown{
                    //   moment of 0 Sec
                    self.countDown = false
                    self.isRecording = true
                    self.poseImageView.gameStart = true//PoseImageview はじめ
                    self.time = self.taskTime() //                           本編スタート
                }else{
                    print("撮影終了")
                    SystemSounds.buttonVib("")
                    SystemSounds.buttonSampleWav("")
                    //SystemSounds().EndVideoRecording()
                    self.view.backgroundColor = .white
                    self.isRecording = false
                    self.poseImageView.gameStart = false// PoseImageView終了
                    timer.invalidate()//timerの終了
                    if self.state > 0 {//　デイリー
                        if self.qType == -1{
                            let alert = DataCounter.showQuestResult2(view: self.videoCameraView, qType: 0, qScore: self.killList.count)
                            //DataCounter.showDailyResult(view: self.videoCameraView, bonus: self.timesBonus, killList: self.killList)
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                        
                        DataCounter.updateDate(diff: self.state)
                        let alert = DataCounter.showDailyResult(view: self.videoCameraView, bonus: self.timesBonus, killList: self.killList)
                        self.present(alert, animated: true, completion: nil)
                        
                    }else{
                        let alert  = DataCounter.showScoreResult(view: self.videoCameraView,
                                                                 score: self.score, bonus: self.timesBonus)
                        self.present(alert, animated: true, completion: nil)
                    }
                     
                }
            }
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
                self.count20_10()
                self.difficultBonus()
            }
            self.time -= 1
        })
    }
    
    func taskTime() -> Int{
        if qType == -1 { return 60 }
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
    func count20_10(){
        if switchTime == 0 {
            rest = !rest
            if rest {
                self.isRecording = false
                self.poseImageView.gameStart = false
                self.bossImage.isHidden = true
                self.bossHPbar.isHidden = true
                self.scoreBoad.isHidden = false
                self.scoreBoad.text = "  きゅうけい"
                self.view.backgroundColor = UIColor.init(red: 102/255, green: 153/255, blue: 255/255, alpha: 80/100)
                switchTime = 10
            }else{
                self.isRecording = true
                self.poseImageView.gameStart = true
                self.bossImage.isHidden = false
                self.bossHPbar.isHidden = false
                self.scoreBoad.isHidden = true
                self.view.backgroundColor = UIColor.init(red: 255/255, green: 102/255, blue: 102/255, alpha: 80/100)
                switchTime = 20
            }
        }
        if switchTime == 3 {SystemSounds.countDown("")}
        switchTime -= 1
        
        if self.time == 0 && !self.countDown { self.view.backgroundColor = .white }
    }
    
    var jumpC = 2
    var isMiss = false
    func difficultBonus(){//jumpタスクがtrueになってから２秒以内に達成できなければ、スコア加算されない
        if isMiss {
            difBonus = 1.0
            if jumpC == 0 {isMiss = false; jumpC = 2}
            jumpC -= 1
        }else if poseImageView.jump {
            difBonus = Float(difficult)
            if jumpC <= 0 { isMiss = true; jumpC = 3; }//ここにミスった時のBGM
            jumpC -= 1
        }else{
            difBonus = Float(difficult)
            jumpC = 2
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
        //フレンドの描画部分
        let fPose = Pose()
        if !self.countDown{
            let namelist = Pose().joints2
            //自分のポーズを保存
            for i in 0 ... namelist.count-1 {
                if pose[namelist[i]].isValid {
                    myPoseList.append(Int(pose[namelist[i]].position.x))
                    myPoseList.append(Int(pose[namelist[i]].position.y))
                }else{
                    myPoseList.append(-1); myPoseList.append(-1)
                }
            }
            //友達のポーズを引っ張ってきてプレイ！
            if !friPoseList.isEmpty {
                var n = 0
                for i in stride(from: 0, to: 26, by: 2) {
                    if friPoseList[i] > -1 {
                        fPose[namelist[n]].isValid = true
                        fPose[namelist[n]].position = CGPoint(x: friPoseList[i], y: friPoseList[i+1])
                        if isRecording {//フレンドのスコアを追加する
                            score += Float(abs(friPoseList[i] - friPoseList[i+26])) / 100
                        }
                        
                    }
                    n += 1
                }
                friPoseList.removeFirst(26)
            }
        }
        //自分とフレンドの動きを描画
        let poseImage: UIImage = poseImageView.show(
            state: self.state, qType: 0,
            prePose: prePose,
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
        if state > 0 { //デイリーのばあい
            let damage: Float = UserDefaults.standard.float(forKey: Keys.damage.rawValue)
            self.bossHPbar.progress = Float((score + damage) / exiteBoss!.maxHp)
            //モンスターを倒した
            if (score + damage) > exiteBoss!.maxHp{
                SystemSounds.attack()
                self.killList.append(exiteBoss!)
                score = 0
                exiteBoss = BOSS().newBoss()
                self.bossImage.image = UIImage(named: exiteBoss!.image)// = UIImageView(image: UIImage(named: exiteBoss!.image))
            }
            //self.bossHPbar.setProgress(self.bossHPbar.progress, animated: true)
        }else{
            self.scoreBoad.text = "Score \(Int(score))"//スコア更新
            //if qType == 2 { self.poseImageView.qScore = Int(score) }
        }
        
        prePose = culculateScore(pose: pose, prePose: prePose)
        
    }
    
    func culculateScore(pose: Pose, prePose: Pose) -> Pose{
        //スコアの測定計算
        if !isRecording {return pose}
        for i in 0...12 {
            let part = Joint.scoreParts[i]
            guard let newPose = pose.joints[part] else {continue}
            guard let prePose = prePose.joints[part] else {continue}
            if newPose.confidence > 0.1 && prePose.confidence > 0.1 {
                var partBonus: Float = 0.2
                if i < 4 { partBonus = 0.5 }
                else if i < 8 { partBonus = 0.8 }
                let disX = abs(newPose.position.x - prePose.position.x)
                let disY = abs(newPose.position.y - prePose.position.y)
                let sum = Float(disY + disX)/100 * partBonus * timesBonus * difBonus
                
                score += sum
                
            }
        }
        return pose
    }
    func check(pose: Pose,size: CGSize) -> Bool{
        //return false
        //地面に手をついた時だけは信頼性を無視
        if isRecording && !poseImageView.jump {
            if pose[.leftWrist].position.y > size.height*7/8 && pose[.rightWrist].position.y > size.height*7/8 {
                return false
            }
        }
        
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

