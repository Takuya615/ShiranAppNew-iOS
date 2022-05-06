//
//  QuestCameraViewModel.swift
//  ShiranAppNew
//
//  Created by 津村拓哉 on 2022/03/26.
//

import Foundation
import SwiftUI

class QuestCameraViewModel{
    
    //var pD = OriginalPoseDetection()
    //var poseDetect = PoseDetectionModel()
    let poseImageView = PoseImageView()
    let questRender = QuestRender()
    //private var poseNet: PoseNet!
    //private var currentFrame: CGImage?
       
    //var state: Int = DataCounter.setDailyState()//  diff.dayの数値
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
//
//    var exiteBoss: boss? = BOSS().isExist()
//    var bossHPbar: UIProgressView!
//    var bossImage: UIImageView!
//    var killList: [boss] = []
//
    
    var _self :QuestCameraViewController
    init(_self :QuestCameraViewController){
        self._self = _self
    }
    
    /*private func startPreview() {
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
     
     }*/
    func setUpCaptureButton(){
        let rect = _self.view.bounds.size
        
        //TimerBoard
        self.textTimer = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 50))
        self.textTimer.text = CameraModel.min(time: CameraModel.taskTime())
        self.textTimer.textColor = UIColor.blue
        self.textTimer.backgroundColor = .white
        self.textTimer.font = UIFont.systemFont(ofSize: 50)
        self.textTimer.textAlignment = NSTextAlignment.center
        self.textTimer.center = CGPoint(x: rect.width/2, y: 25)//rect.height*0.01)
        self.textTimer.layer.borderColor = UIColor.blue.cgColor
        self.textTimer.layer.borderWidth = 2
        self.textTimer.layer.masksToBounds = true
        self.textTimer.layer.cornerRadius = 10
        _self.view.addSubview(textTimer)//subView 1
        
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 50))
        backButton.setTitle(str.back.rawValue, for: .normal)
        backButton.setTitleColor(UIColor.blue, for: .normal)
        backButton.backgroundColor = UIColor.clear
        backButton.center = CGPoint(x: 45, y: 25)
        //backButton.layer.cornerRadius = 5
        //backButton.layer.position = CGPoint(x: rect.width / 2, y:rect.height - 80)
        backButton.addTarget(self, action: #selector(self.onClickBackButton(sender:)), for: .touchUpInside)
        _self.view.addSubview(backButton)
        
        /*
         self.scoreBoad = UILabel(frame: CGRect(x: 0, y: 0, width: rect.width, height: 80))
         self.scoreBoad.layer.position = CGPoint(x: rect.width/2, y: rect.height-42)
         self.scoreBoad.text = "Score"
         self.scoreBoad.textColor = UIColor.blue
         //self.scoreBoad.backgroundColor = UIColor.red
         self.scoreBoad.font = UIFont.systemFont(ofSize: 50)
         self.scoreBoad.isHidden = true
         self.view.addSubview(self.scoreBoad)
         */
        
        // recording button
        self.recordButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        self.recordButton.backgroundColor = UIColor.orange
        self.recordButton.layer.masksToBounds = true
        self.recordButton.layer.cornerRadius = self.recordButton.frame.width/2
        self.recordButton.setTitle(str.start.rawValue, for: .normal)
        //self.recordButton.layer.cornerRadius = 20
        self.recordButton.layer.position = CGPoint(x: rect.width / 2, y:rect.height - 42)
        self.recordButton.addTarget(self, action: #selector(self.onClickRecordButton(sender:)), for: .touchUpInside)
        _self.view.addSubview(recordButton)//subView 0
        
        
        let der = UILabel()// あとで消す用のUIView
        _self.view.addSubview(der)
        
    }
    
    @objc func onClickBackButton(sender: UIButton) {
        _self.questCameraView.isVideo = false
    }
    @objc func onClickRecordButton(sender: UIButton) {
        var Ring = false
        self.recordButton.isHidden = true
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
                self.textTimer.text = CameraModel.min(time: self.time)
                self.textTimer.textColor = UIColor.blue
            }
            
            if self.time == 0 {
                if self.countDown{
                    //   moment of 0 Sec
                    self.countDown = false
                    self.isRecording = true
                    self.poseImageView.gameStart = true//クエストはじめ
                    self.time = CameraModel.taskTime() //                           本編スタート
                }else{
                    SystemSounds.buttonVib("")
                    SystemSounds.buttonSampleWav("")
                    //SystemSounds().EndVideoRecording()
                    self.isRecording = false
                    self.poseImageView.gameStart = true//クエストゲーム終了
                    timer.invalidate()//timerの終了
                    
                    //リザルト表示
                    //var alert: UIAlertController = UIAlertController(title: "", message: "", preferredStyle:  UIAlertController.Style.alert)
                    let alert = DataCounter.showQuestResult(qType: self.qType,qScore: self.questRender.qScore,completion: {self._self.questCameraView.isVideo = false})
                    self._self.present(alert, animated: true, completion: nil)
                    
                }
            }
            
        })
    }
    
    
    //Extension
//    func culculateScore(pose: Pose, prePose: Pose) -> Pose{
//        //スコアの測定計算
//        if !isRecording {return pose}
//        Joint.Name.allCases.forEach {name in
//
//            if pose.joints[name] != nil && prePose.joints[name] != nil{
//                if pose.joints[name]!.confidence > 0.1 && prePose.joints[name]!.confidence > 0.1 {
//                    let disX = abs(pose.joints[name]!.position.x - prePose.joints[name]!.position.x)
//                    let disY = abs(pose.joints[name]!.position.y - prePose.joints[name]!.position.y)
//                    let sum = Float(disY + disX)/100*timesBonus
//                    score += sum
//                }
//            }
//        }
//        return pose
//    }
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
    func getPoseImage(pose: Pose,frame: CGImage) -> UIImage{
        
//        if qType == 2 {
//            prePose = culculateScore(pose: pose, prePose: prePose)
//            questRender.qScore = Int(score)
//        }
        let image = poseImageView.showQuest(qRender: questRender,qType: qType, prePose: prePose, pose: pose, on: frame)
        prePose = pose
        return image
    }
}
