
import SwiftUI
import Foundation

class DefaultCameraViewModel{
    
    var countDown = true
    var rest = false
    var jump = false
    var isResult = false
    var isRecording = false
    
    var recordButton: UIButton!
    var scoreBoad: UILabel!
    var textTimer: UILabel!
    
    var poseNum: Int = 0
    var score:Float = 0.0
    var timesBonus: Float = 1.0
    var difBonus: Float = 1.0
    var myPoseList: [Int] = []
    var friPoseList: [Int] = []
    var time = 3
    var switchTime = 20
    var timer = Timer()
    var prePose: Pose! = Pose()
    
    let skinNo:Int = UserDefaults.standard.integer(forKey:Keys.selectSkin.rawValue)
    let bodyNo:Int = UserDefaults.standard.integer(forKey:Keys.selectBody.rawValue)
    let difficult = UserDefaults.standard.integer(forKey: Keys.difficult.rawValue)+1//1 2 3

    var _self :DefaultCameraController
    init(_self :DefaultCameraController){
        self._self = _self
        EventAnalytics.action_setting(type: str.def.rawValue)
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
        backButton.setTitle(str.home.rawValue, for: .normal)
        backButton.setTitleColor(UIColor.blue, for: .normal)
        backButton.backgroundColor = UIColor.clear
        backButton.center = CGPoint(x: 45, y: 25)
        backButton.addTarget(self, action: #selector(self.onClickBackButton(sender:)), for: .touchUpInside)
        _self.view.addSubview(backButton)
        
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
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
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
                    self._self.view.backgroundColor = .white
                    self.isRecording = false
                    timer.invalidate()//timerの終了
                    let alert  = DataCounter.showScoreResult(score: self.score,bonus: self.timesBonus,completion: {self._self.cameraView.isVideo = false})
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
                self.textTimer.text = CameraModel.min(time: self.time)
                self.textTimer.textColor = UIColor.blue
                self.count20_10()
                self.difficultBonus()
            }
            self.time -= 1
        })
    }
    
    func count20_10(){
        if switchTime == 0 {
            rest = !rest
            if rest {
                self.isRecording = false
                self.scoreBoad.isHidden = false
                self.scoreBoad.text = str.rest.rawValue
                _self.view.backgroundColor = UIColor.init(red: 102/255, green: 153/255, blue: 255/255, alpha: 80/100)
                switchTime = 10
            }else{
                self.isRecording = true
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
        }else if jump {
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
}

