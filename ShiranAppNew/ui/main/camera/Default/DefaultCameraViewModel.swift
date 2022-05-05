
import SwiftUI
import Foundation

class DefaultCameraViewModel{
    
    let poseImageView = PoseImageView()
    private var poseNet: PoseNet!
    private var currentFrame: CGImage?
    
    //var state: Int = DataCounter.setDailyState()//  diff.dayの数値
    //let qType = UserDefaults.standard.integer(forKey: Keys.questType.rawValue)
    
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
//    var bossHPbar: UIProgressView!
//    var bossImage: UIImageView!
//    var killList: [boss] = []
 
    var _self :DefaultCameraController
    init(_self :DefaultCameraController){
        self._self = _self
    }
    
    func setUpCaptureButton(){
        let rect = _self.view.bounds.size
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
        _self.view.addSubview(textTimer)//subView 1
        
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 50))
        backButton.setTitle(str.home.rawValue, for: .normal)
        backButton.setTitleColor(UIColor.blue, for: .normal)
        backButton.backgroundColor = UIColor.clear
        backButton.center = CGPoint(x: 45, y: 25)
        //backButton.layer.cornerRadius = 5
        //backButton.layer.position = CGPoint(x: rect.width / 2, y:rect.height - 80)
        backButton.addTarget(self, action: #selector(self.onClickBackButton(sender:)), for: .touchUpInside)
        _self.view.addSubview(backButton)
        
        
        /*let heart2 = UIImageView(image: UIImage(systemName: "heart.fill"))
        heart2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        heart2.layer.position = CGPoint(x: rect.width/2 + 100, y: 25)
        self.view.addSubview(heart2)*/
        
//        self.bossHPbar = UIProgressView(frame: CGRect(x: 0, y: 0, width: rect.width-20, height: 30))
//        self.bossHPbar.progress = 0.0//Float(damage / exiteBoss!.maxHp)
//        self.bossHPbar.progressTintColor = .gray
//        self.bossHPbar.backgroundColor = .red
//        //self.bossHPbar.setProgress(bossHPbar.progress, animated: true)
//        self.bossHPbar.transform = CGAffineTransform(scaleX: 1.0, y: 10.0)
//        self.bossHPbar.layer.position = CGPoint(x: rect.width/2, y: rect.height-42)
//        self.bossHPbar.isHidden = true
//        _self.view.addSubview(self.bossHPbar)
//        self.bossImage = UIImageView(image: UIImage(named: exiteBoss!.image))
//        self.bossImage.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
//        self.bossImage.layer.position = CGPoint(x: rect.width/2, y: rect.height-42)
//        _self.view.addSubview(bossImage)
        
        self.scoreBoad = UILabel(frame: CGRect(x: 0, y: 0, width: rect.width, height: 80))
        self.scoreBoad.layer.position = CGPoint(x: rect.width/2, y: rect.height-42)
        self.scoreBoad.text = str.score.rawValue
        self.scoreBoad.textColor = UIColor.blue
        //self.scoreBoad.backgroundColor = UIColor.red
        self.scoreBoad.font = UIFont.systemFont(ofSize: 50)
        self.scoreBoad.isHidden = true
        _self.view.addSubview(self.scoreBoad)
        
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
        
        if !AppState().coachMark2 {
            let alert: UIAlertController = UIAlertController(
                title: str.coachMarck2text.rawValue, message: "", preferredStyle:  UIAlertController.Style.alert)
            let confirmAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                UserDefaults.standard.set(true, forKey: "CoachMark2 ")
                //self.coachController.start(in: .window(over: self))　コーチマーク
            })
            alert.addAction(confirmAction)
            _self.present(alert, animated: true, completion: nil)
            UserDefaults.standard.set(true, forKey: "CoachMark2")
        }
        let der = UILabel()// あとで消す用のUIView
        _self.view.addSubview(der)
        /*
        if !AppState().coachMark2 {
            let MainView = UIHostingController(rootView: IntroView(imageName: "sample", number: 0).environmentObject(AppState()))//ContentView())
            MainView.presentationController?.delegate = self
            self.present(MainView, animated: true, completion:nil)
        }*/

    }
    
    @objc func onClickBackButton(sender: UIButton) {
        _self.cameraView.isVideo = false
    }
    @objc func onClickRecordButton(sender: UIButton) {
        var Ring = false
        self.recordButton.isHidden = true
        self.scoreBoad.isHidden = false
//        self.bossImage.isHidden = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            if self.time == 0 {
                if self.countDown{
                    //   moment of 0 Sec
                    self.countDown = false
                    self.isRecording = true
                    self.poseImageView.gameStart = true//PoseImageview はじめ
                    self.time = self.taskTime() //                           本編スタート
                }else{
                    SystemSounds.buttonVib("")
                    SystemSounds.buttonSampleWav("")
                    //SystemSounds().EndVideoRecording()
                    self._self.view.backgroundColor = .white
                    self.isRecording = false
                    self.poseImageView.gameStart = false// PoseImageView終了
                    timer.invalidate()//timerの終了
                    
                    let alert  = DataCounter.showScoreResult(view: self._self.cameraView,
                                                                 score: self.score, bonus: self.timesBonus)
                    self._self.present(alert, animated: true, completion: nil)
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
//                self.bossImage.isHidden = true
//                self.bossHPbar.isHidden = true
                self.scoreBoad.isHidden = false
                self.scoreBoad.text = str.rest.rawValue
                _self.view.backgroundColor = UIColor.init(red: 102/255, green: 153/255, blue: 255/255, alpha: 80/100)
                switchTime = 10
            }else{
                self.isRecording = true
                self.poseImageView.gameStart = true
//                self.bossImage.isHidden = false
//                self.bossHPbar.isHidden = false
                self.scoreBoad.isHidden = true
                _self.view.backgroundColor = UIColor.init(red: 255/255, green: 102/255, blue: 102/255, alpha: 80/100)
                switchTime = 20
            }
        }
        if switchTime == 3 {SystemSounds.countDown("")}
        switchTime -= 1
        
        if self.time == 0 && !self.countDown { _self.view.backgroundColor = .white }
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
    
    
    
    
    //Extension
    func culculateScore(pose: Pose){
        //スコアの測定計算
        if !isRecording {return}
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
                scoreBoad.text = str.score2.rawValue + String(Int(score))
                
            }
        }
        prePose = pose
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
