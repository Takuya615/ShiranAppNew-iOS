

import Foundation
import SwiftUI
import Firebase


class DataCounter: ObservableObject {
    
    @Published var countedLevel = UserDefaults.standard.integer(forKey: Keys.level.rawValue)
    @Published var continuedDayCounter = UserDefaults.standard.integer(forKey: Keys.continuedDay.rawValue)
    @Published var continuedRetryCounter = UserDefaults.standard.integer(forKey: Keys.retry.rawValue)
    @Published var countedCoin = UserDefaults.standard.integer(forKey: Keys.coin.rawValue)
    @Published var countedDiamond = UserDefaults.standard.integer(forKey: Keys.diamond.rawValue)
    //@Published var isDaily = setDailyState()
    //日時の差分を計算するメソッド
    static func setDailyState() -> Int{
        if UserDefaults.standard.integer(forKey: Keys.questType.rawValue) == -1{ return 1 }//クエスト
        let today = Date()
        let LastTimeDay: Date? = UserDefaults.standard.object(forKey: Keys._LastTimeDay.rawValue) as? Date
        if LastTimeDay == nil{
            UserDefaults.standard.set(0, forKey: Keys.totalDay.rawValue)//総日数
            UserDefaults.standard.set(0, forKey: Keys.continuedDay.rawValue)//継続日数
            UserDefaults.standard.set(5, forKey: Keys.taskTime.rawValue)
            return 0
        }
        let cal = Calendar(identifier: .gregorian)
        let todayDC = Calendar.current.dateComponents([.year, .month,.day], from: today)
        let lastDC = Calendar.current.dateComponents([.year, .month,.day], from: LastTimeDay!)
        let diff: DateComponents = cal.dateComponents([.day], from: lastDC, to: todayDC)
        return diff.day!
    }
    static func updateDate(){
        let totalDay: Int = UserDefaults.standard.integer(forKey: Keys.totalDay.rawValue)
        UserDefaults.standard.set(totalDay+1, forKey: Keys.totalDay.rawValue)
        UserDefaults.standard.set(Date(), forKey: Keys._LastTimeDay.rawValue)
        if(setDailyState() < 1){
            let continuedDay = UserDefaults.standard.integer(forKey: Keys.continuedDay.rawValue)
            UserDefaults.standard.set(continuedDay + 1, forKey: Keys.continuedDay.rawValue)
        }else{
            let retry = UserDefaults.standard.integer(forKey: Keys.retry.rawValue)
            UserDefaults.standard.set(0, forKey: Keys.continuedDay.rawValue)
            UserDefaults.standard.set(retry + 1, forKey: Keys.retry.rawValue)//値の書き込み　↓表示の更新
        }
    }
    
    //リザルト画面３つ。　何もなし　デイリー　クエスト
    static func showScoreResult(score:Float,bonus:Float, completion: @escaping ()->Void,retry: @escaping ()->Void) -> UIAlertController{
        let title = str.score.rawValue + String(Int(score)) + " / 500"
        var message = ""
        if bonus != 1.0 {message += "\n" + str.assist.rawValue + String(Int(bonus))}
        let alert: UIAlertController = UIAlertController(title: title, message:  message, preferredStyle:  UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: str.retry.rawValue, style: UIAlertAction.Style.cancel,
                                      handler: {_ in retry()}))
        alert.addAction(UIAlertAction(title: str.ok.rawValue, style: UIAlertAction.Style.default,
                                      handler:{_ in completion()}))
        return alert
    }
    func showDailyResult(bonus:Float,killList:[boss], completion: @escaping ()->Void) -> (UIAlertController){
        if UserDefaults.standard.integer(forKey: Keys.questType.rawValue) == -1 {
            return showQuestResult(qType: -1, qScore: killList.count, completion: completion)
        }
        DataCounter.updateDate()
        let alert: UIAlertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n", message:  "",
                                                         preferredStyle:  UIAlertController.Style.alert)
        let confirmAction: UIAlertAction = UIAlertAction(title: str.ok.rawValue, style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            completion()
        })
        alert.addAction(confirmAction)
        
        var exp = 0
        var wid = 0
        let lav = UILabel(frame: CGRect(x: 10, y: 15, width: 200, height: 20))
        lav.text = str.kill.rawValue + String(killList.count)
        alert.view.addSubview(lav)
        for kill in killList {
            let myInputImage = CIImage(image: UIImage(named: kill.image)!)
            let imageView = UIImageView(frame: CGRect(x:10+wid, y:40, width:40, height:40))
            wid += 20
            let myMonochromeFilter = CIFilter(name: "CIColorMonochrome")//モノクロ
            myMonochromeFilter!.setValue(myInputImage, forKey: kCIInputImageKey)
            myMonochromeFilter!.setValue(CIColor(red: 0.9, green: 0.9, blue: 0.9), forKey: kCIInputColorKey)
            myMonochromeFilter!.setValue(1.0, forKey: kCIInputIntensityKey)
            let myOutputImage : CIImage = (myMonochromeFilter?.outputImage!)!
            imageView.image = UIImage(ciImage: myOutputImage)//UIImage(named: boss!.image)
            alert.view.addSubview(imageView)
            exp += kill.bonus
        }
        let lav1 = UILabel(frame: CGRect(x: 10, y: 85 , width: 200, height: 30))
        lav1.text = str.rewardCoin.rawValue + "  " + String(incentive.getCoin(dataCounter: self)) + "G"
        alert.view.addSubview(lav1)
        
        let resultLv = DataCounter.updateLv(score: exp,data: self)
        //let message = resultLv.3//DataCounter.mes(score: exp, str: "")
        let lav2 = UILabel(frame: CGRect(x: 10, y: 115 , width: 200, height: 20))
        lav2.text = resultLv.1//message
        alert.view.addSubview(lav2)
        let progressLV = UIProgressView(progressViewStyle: .default)
        progressLV.frame = CGRect(x: 10, y: 140 , width: 200, height: 20)
        progressLV.progress = resultLv.0
        progressLV.setProgress(resultLv.0, animated: true)
        progressLV.tintColor = UIColor.blue
        alert.view.addSubview(progressLV)
        
        let result = DataCounter.updateTT(score: exp)//初期値、末期値、何回プログレスバーを更新するかInt
        let lav3 = UILabel(frame: CGRect(x: 10, y: 170 , width: 400, height: 20))
        lav3.text = result.2//"制限時間が\(taskTime)秒に伸びました！"
        alert.view.addSubview(lav3)
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.frame = CGRect(x: 10, y: 195 , width: 200, height: 20)
        progressView.progress = result.0
        progressView.setProgress(result.0, animated: true)
        progressView.tintColor = UIColor.blue
        alert.view.addSubview(progressView)
        
        //self.saveData(score: exp)
        return alert
    }
    
    func showQuestResult(qType: Int, qScore: Int, completion: @escaping ()->Void) -> UIAlertController{
        let alert :UIAlertController = UIAlertController(title: "", message: "", preferredStyle:  UIAlertController.Style.alert)
        var title = ""
        let qNum: Int = UserDefaults.standard.integer(forKey: Keys.questNum.rawValue)
        let qGoal: [Int] = UserDefaults.standard.array(forKey: Keys.qGoal.rawValue) as! [Int]
        var qsl: [Int] = UserDefaults.standard.array(forKey: Keys.qsl.rawValue) as? [Int] ?? [0,0,0]
        //print("qType \(qType)  score \(qScore)")
        switch qType {
        case -1:title = "\n" + str.kill.rawValue + String(qScore) + str.tai.rawValue + "\n"
        case 1:title += "\n" + str.coin.rawValue + String(qScore) + str.co.rawValue + "\n"
        case 2,5,6,7:title = "\n " + str.score2.rawValue + String(qScore) + str.p.rawValue + "\n"
        case 3,4:title += "\n" + str.rewardDistance.rawValue + String(qScore) + str.m.rawValue + "\n"
        default:title = ""
        }
        var re = 0
        if qScore >= qGoal[2] {qsl[qNum]=3; re=3; title += str.questCompAll.rawValue + "\n"}
        else if qScore >= qGoal[1] {qsl[qNum]=2; re=2; title += str.questComp066.rawValue + "\n"}
        else if qScore >= qGoal[0] {qsl[qNum]=1; re=1; title += str.questComp033.rawValue + "\n"}
        title += "\n" + str.rewardCoin.rawValue + "  " + String(incentive.getCoin_for_quest(dataCounter: self,inc: re)) + "G"
        for i in 1 ... 3 {
            let imageView = UIImageView(frame: CGRect(x:15+50*i, y:0, width:40, height:40))
            if re < i {
                imageView.image = UIImage(systemName: "star")
            }else{
                imageView.image = UIImage(systemName: "star.fill")
            }
            alert.view.addSubview(imageView)
        }
        UserDefaults.standard.set(qsl, forKey: Keys.qsl.rawValue)
        alert.title = title
        let confirmAction: UIAlertAction = UIAlertAction(title: str.ok.rawValue, style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            completion()
        })
        alert.addAction(confirmAction)
        
        //        let lav1 = UILabel(frame: CGRect(x: 10, y: 85 , width: 200, height: 30))
        //        lav1.text = str.rewardCoin.rawValue + "  " + String(incentive.getCoin_for_quest(dataCounter: self)) + "G"
        //        alert.view.addSubview(lav1)
        return alert
    }
    
    
    static func updateLv(score: Int,data: DataCounter) -> (Float,String){
        let rcLv: Int = Int(UserDefaults.standard.float(forKey: Keys.rcLevel.rawValue)*100)//RemoteConfig
        let exp: Int = UserDefaults.standard.integer(forKey: Keys.exp.rawValue)
        let preLv: Int = UserDefaults.standard.integer(forKey: Keys.level.rawValue)
        var newLv = preLv
        
        for i in 1..<table.count {
            if table[i]*rcLv/100 > exp+score {
                newLv = i
                break
            }
        }
        UserDefaults.standard.set(exp+score, forKey: Keys.exp.rawValue)
        UserDefaults.standard.set(newLv, forKey: Keys.level.rawValue)
        let af = Float(exp+score-table[newLv-1]*rcLv/100) / Float(table[newLv]*rcLv/100-table[newLv-1]*rcLv/100)
        var message = ""
        if newLv == preLv{
            message = str.rewardExp.rawValue + " " + String(exp+score-table[newLv-1]*rcLv/100) + " / " + String(table[newLv]*rcLv/100-table[newLv-1]*rcLv/100)
        }else{
            EventAnalytics.levelUp(level: newLv)
            message = str.levelUp.rawValue + String(preLv) + " → " + String(newLv)
            data.countedLevel = newLv
        }
        return (af,message)
    }
    
    //前のタイム経験値、今回の経験値の端数、何回プログレスバーを更新するかInt (VideoCameraView)
    static func updateTT(score: Int) -> (Float,Int,String){
        let rcTimes: Int = Int(UserDefaults.standard.float(forKey: Keys.rcAddTT.rawValue)*100)//RemoteConfig
        let lastTime = UserDefaults.standard.integer(forKey: Keys.taskTime.rawValue)
        let total = UserDefaults.standard.integer(forKey: Keys.totalDay.rawValue)
        var tt = 1
        switch total {
        case 0 ..< 61: tt = 1
        case 61 ..< 91: tt = 2
        case 91 ..< 121: tt = 3
        case 121 ..< 151: tt = 4
        case 151 ..< 181: tt = 5
        default:          tt = 1
        }
        
        let expTT = UserDefaults.standard.integer(forKey: Keys.expTT.rawValue)
        var bn = 1
        var an = 1
        for i in 1..<table.count {
            if table[i]*rcTimes/100 > expTT { bn = i; break }
        }
        for i in 1..<table.count {
            if table[i]*rcTimes/100 > expTT+score { an = i; break }
        }
        
        
        let after = Float(expTT+score-table[an-1]*rcTimes/100) / Float(table[an]*rcTimes/100 - table[an-1]*rcTimes/100 )// 0.0 - 1.0
        var text = ""
        if an == bn {
            text = str.limitTime.rawValue + String(lastTime) + str.sec.rawValue
        }else {
            text = String(lastTime) + str.sec.rawValue + "→" + String(lastTime + (tt * (an-bn))) + str.sec.rawValue
        }
        UserDefaults.standard.set(lastTime + (tt * (an-bn)), forKey: Keys.taskTime.rawValue)
        UserDefaults.standard.set(expTT+score, forKey: Keys.expTT.rawValue)
        return (after,an-bn,text)
    }
    
    static func saveMyPose(poseList:[Int]){
        guard let myName = UserDefaults.standard.string(forKey: Keys.myName.rawValue) else {return}
        let db = Firestore.firestore().collection("users").document(myName)
        db.updateData([
            "poseList": poseList
        ]) { err in
            if let err = err { print(err) }
        }
    }
    
    static let table: [Int] = [0,100,600,960,1320,1740,2160,2640,3120,3660,4200,4800,5400,6060,6720,7440,8160,8940,9720,10560,11400,12300,13200,14160,15120,16140,17160,18240,19320,20460,21600,22800,24000,25260,26520,27840,29160,30540,31920,33360,34800,36300,37800,39360,40920,42540,44160,45840,47520,49260,51000,52800,54600,55860,57120,58440,59760,61140,62520,63960,65400,66960,68520,70200,71880,73680,75480,77400,79320,81360,83400,85560,87720,90000,92280,94680,97080,99600,102120,104760,107400,110160,112920,115800,118680,121680,124680,127200,129720,132360,135000,137820,140640,143640,146640,149820,153000,156360,159720,163260,166800,170520,174240,178140,182040,186120,190200,193860,197520,201360,205200,209220,213240,217440,221640,226020,230400,234960,239520,244260,249000,253980,258960,264180,269400,274260,279120,284220,289320,294660,300000,305580,311160,316980,322800,328860,334920,341220,347520,354060,360600,366780,372960,379380,385800,392460,399120,406020,412920,420060,427200,434640,442080,449820,457560,465000,472440,480180,487920,495960,504000,512340,520680,529320,537960,546900,555840,564480,573120,582060,591000,600240,609480,619020,628560,638400,648240,658140
    ]
}
