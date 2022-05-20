

import Foundation
import SwiftUI

class QuestCameraViewModel{
    
    var countDown = true
    var isRecording = false
    
    var recordButton: UIButton!
    var scoreBoad: UILabel!
    var textTimer: UILabel!
    var boltGaugebar: UIProgressView!
    
    var poseNum: Int = 0
    var myPoseList: [Int] = []
    var friPoseList: [Int] = []
    var time = 4
    var timer = Timer()
    
    //forQuestRender
    var prePose: Pose! = Pose()
    var render: QuestRender = QuestRender()
    var qScore: CGFloat = 0.0
    
    let qType = UserDefaults.standard.integer(forKey: Keys.questType.rawValue)
    let qGoal: [Int] = UserDefaults.standard.array(forKey: Keys.qGoal.rawValue) as! [Int]
    let skinNo:Int = UserDefaults.standard.integer(forKey:Keys.selectSkin.rawValue)
    let bodyNo:Int = UserDefaults.standard.integer(forKey:Keys.selectBody.rawValue)
    
    var _self :QuestCameraViewController
    init(_self :QuestCameraViewController){
        self._self = _self
    }
    
    func setUpCaptureButton(){
        let rect = _self.view.bounds.size
        
        //TimerBoard
        self.textTimer = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 50))
        self.textTimer.text = CameraModel.min(time: CameraModel.taskTime())
        self.textTimer.textColor = UIColor.blue
        self.textTimer.backgroundColor = .white
        self.textTimer.font = UIFont.systemFont(ofSize: 50)
        self.textTimer.textAlignment = NSTextAlignment.center
        self.textTimer.center = CGPoint(x: rect.width/2, y: 25)
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
        backButton.addTarget(self, action: #selector(self.onClickBackButton(sender:)), for: .touchUpInside)
        _self.view.addSubview(backButton)
        
        if qType == 2 {
            self.boltGaugebar = UIProgressView(frame: CGRect(x: 0, y: 0, width: rect.width-20, height: 30))
            self.boltGaugebar.progress = 0.0//Float(damage / exiteBoss!.maxHp)
            self.boltGaugebar.progressTintColor = .yellow
            self.boltGaugebar.backgroundColor = .gray
            //self.bossHPbar.setProgress(bossHPbar.progress, animated: true)
            self.boltGaugebar.transform = CGAffineTransform(scaleX: 1.0, y: 10.0)
            self.boltGaugebar.layer.position = CGPoint(x: rect.width/2, y: rect.height-42)
            _self.view.addSubview(self.boltGaugebar)
            let boltImage = UIImageView(image: UIImage(systemName: "bolt.fill"))
            boltImage.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            boltImage.layer.position = CGPoint(x: rect.width/2, y: rect.height-42)
            _self.view.addSubview(boltImage)
        }
        
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
                    self.time = CameraModel.taskTime() //                           本編スタート
                }else{
                    SystemSounds.buttonVib("")
                    SystemSounds.buttonSampleWav("")
                    //SystemSounds().EndVideoRecording()
                    self.isRecording = false
                    timer.invalidate()//timerの終了
                    
                    //リザルト表示
                    let alert = DataCounter.showQuestResult(qType: self.qType,qScore: Int(self.qScore),completion: {self._self.questCameraView.isVideo = false})
                    self._self.present(alert, animated: true, completion: nil)
                    
                }
            }
            
        })
    }
    
    
    //Extension
    func getPoseImage(pose: Pose,frame: CGImage) -> UIImage{
        showHPbar(pose: pose)
        let image = PoseImageView.showQuest(
            model: self,
            pose: pose, on: frame)
        prePose = pose
        return image
    }
    func showHPbar(pose: Pose){
        //スコアの測定計算
        if !self.isRecording || qType != 2 {return}
        Joint.Name.allCases.forEach {name in
            if pose.joints[name] != nil && prePose.joints[name] != nil{
                if pose.joints[name]!.confidence > 0.1 && prePose.joints[name]!.confidence > 0.1 {
                    let disX = abs(pose.joints[name]!.position.x - prePose.joints[name]!.position.x)
                    let disY = abs(pose.joints[name]!.position.y - prePose.joints[name]!.position.y)
                    self.qScore += (disY+disX)/100
                    boltGaugebar.progress = Float(qScore) / Float(qGoal[2])
                }
            }
        }
    }
}
