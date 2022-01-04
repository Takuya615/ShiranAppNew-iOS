//
//  DataCounter.swift
//  ShiranAppNew
//
//  Created by user on 2021/10/01.
//

import Foundation
import SwiftUI
import Firebase

enum Keys: String {
    // Key
    case daylyState = "DailyState"
    case totalDay = "totalDay"
    case continuedDay = "cDay"
    case continuedWeek = "wDay"
    case retry = "retry"
    case _LastTimeDay = "LastTimeDay"
    case taskTime = "TaskTime"
    
    case listD = "dateList"
    case listS = "scoreList"
    
    case level = "Level"
    case difficult = "difficultyLevel"
    case scoreMax = "MomentaryMaxScore"
    case exp = "ExperiencePoint"
    case expTT = "ExpForTaskTime"
    case coin = "Coin"
    case diamond = "Diamond"
    case bossNum = "BOSS_ListNumber"
    case damage = "BOSS_Damege"
    case myName = "MyName"
    
    case questNum = "QuestNumber"
    case questType = "QuestType"
    case qGoal = "QuestGoalScore"
    case qsl = "QuestStarsList"
    case skin = "SkinNumber"
    
}

class DataCounter: ObservableObject {
    
    @Published var countedLevel = UserDefaults.standard.integer(forKey: Keys.level.rawValue)
    @Published var continuedDayCounter = UserDefaults.standard.integer(forKey: Keys.continuedDay.rawValue)
    @Published var continuedRetryCounter = UserDefaults.standard.integer(forKey: Keys.retry.rawValue)
    @Published var countedCoin = UserDefaults.standard.integer(forKey: Keys.coin.rawValue)
    @Published var countedDiamond = UserDefaults.standard.integer(forKey: Keys.diamond.rawValue)
    //日時の差分を計算するメソッド
    static func setDailyState() -> Int{
        let User = UserDefaults.standard
        let today = Date()
        //let LastTimeDay = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let LastTimeDay: Date? = User.object(forKey: Keys._LastTimeDay.rawValue) as? Date
        if LastTimeDay == nil{
            print("記念すべき第一回目")
            User.set(0, forKey: Keys.totalDay.rawValue)//総日数
            User.set(0, forKey: Keys.continuedDay.rawValue)//継続日数
            let lastDay: Date? = Calendar.current.date(byAdding: .day, value: -1, to: today)
            User.set(lastDay, forKey: Keys._LastTimeDay.rawValue)//デイリー更新(初回はもう一度遊べるようにする)
            //continuedDayCounter = 0
            User.set(10, forKey: Keys.taskTime.rawValue)
            //updateTaskTime(total: -1)
            User.setValue(-1, forKey: Keys.daylyState.rawValue)
            return -1
        }
        let cal = Calendar(identifier: .gregorian)
        let todayDC = Calendar.current.dateComponents([.year, .month,.day], from: today)
        let lastDC = Calendar.current.dateComponents([.year, .month,.day], from: LastTimeDay!)
        let diff: DateComponents = cal.dateComponents([.day], from: lastDC, to: todayDC)
        //guard let diff = di else {return diff.day}
        print("todayDC:\(todayDC)")
        print("dt1DC:\(lastDC)")
        print("差は \(diff.day!) 日")
        User.setValue(diff.day!, forKey: Keys.daylyState.rawValue)
        return diff.day!
    }
    static func updateDate(diff: Int){
        let totalDay: Int = UserDefaults.standard.integer(forKey: Keys.totalDay.rawValue)
        UserDefaults.standard.set(totalDay+1, forKey: Keys.totalDay.rawValue)
        
        let continuedDay = UserDefaults.standard.integer(forKey: Keys.continuedDay.rawValue)
        let retry = UserDefaults.standard.integer(forKey: Keys.retry.rawValue)
        if(diff == 1){
            UserDefaults.standard.set(continuedDay + 1, forKey: Keys.continuedDay.rawValue)
            EventAnalytics.doneDayly()
        }else{
            print("記録リセット")
            UserDefaults.standard.set(0, forKey: Keys.continuedDay.rawValue)
            UserDefaults.standard.set(retry + 1, forKey: Keys.retry.rawValue)//値の書き込み　↓表示の更新
            EventAnalytics.doneNotEveryDay(diff: diff)
        }
    }
    /*
    func scoreCounter() -> Int{
        let User = UserDefaults.standard
        let totalDay: Int = User.integer(forKey: Keys.totalDay.rawValue)//読み込み
        
        //var calenderList:[ Int] = UserDefaults.standard.object(forKey: self.calender) as? [Int] ?? []//値が無ければ空のリスト
        let continuedDay = User.integer(forKey: Keys.continuedDay.rawValue)
        let retry = User.integer(forKey: Keys.retry.rawValue)
        let diff = User.integer(forKey: Keys.daylyState.rawValue)
        if diff == 0{
            print("デイリー達成済み")
            return 0
        }else if(diff == 1){
            print("毎日記録更新")
            User.set(continuedDay + 1, forKey: Keys.continuedDay.rawValue)
            continuedDayCounter = continuedDay + 1
            EventAnalytics.doneDayly()
        }else{
            print("記録リセット")
            User.set(0, forKey: Keys.continuedDay.rawValue)
            continuedDayCounter = 0
            User.set(retry + 1, forKey: Keys.retry.rawValue)//値の書き込み　↓表示の更新
            continuedRetryCounter = retry + 1
            EventAnalytics.doneNotEveryDay(diff: diff)
        }
        User.set(totalDay + 1, forKey: Keys.totalDay.rawValue)
        User.set(Date(), forKey: Keys._LastTimeDay.rawValue)
        let taskTime = updateTaskTime(total: totalDay)
        return taskTime
    }*/
    /*
    func saveData(score: Int){
        //日時の指定
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.locale =  Locale(identifier: "ja_JP")
        let date = dateFormatter.string(from: Date())
        
        let dateList: [String]? = UserDefaults.standard.array(forKey: DataCounter().listD) as? [String]
        let scoreList:[Int]? = UserDefaults.standard.array(forKey: DataCounter().listS) as? [Int]
        
        if var dateList = dateList, var scoreList = scoreList {
            dateList.append(date)
            scoreList.append(score)
            if dateList.count > 15 {
                dateList.removeLast()
                scoreList.removeLast()
            }
            print("リストseve data \(dateList)  score \(scoreList)")
            UserDefaults.standard.setValue(dateList, forKey: DataCounter().listD)
            UserDefaults.standard.setValue(scoreList, forKey: DataCounter().listS)
        }else {
            print("リストが nil になっている")
            UserDefaults.standard.setValue([date], forKey: DataCounter().listD)
            UserDefaults.standard.setValue([score], forKey: DataCounter().listS)
        }
        
    }*/
    
    /*func updateTaskTime(total:Int) -> Int{
        if total%2 == 0{return 0}//偶数なら見送り
        var tt = UserDefaults.standard.integer(forKey: Keys.taskTime.rawValue)
        switch total {
        case 0 ..< 61:
            tt = tt + 1
        case 61 ..< 91:
            tt = tt + 2
        case 91 ..< 121:
            tt = tt + 3
        case 121 ..< 151:
            tt = tt + 4
        case 151 ..< 181:
            tt = tt + 5
        default://   over 181
            tt = tt + 5
        }
        print("タスクタイム＝\(tt)")
        UserDefaults.standard.set(tt, forKey: Keys.taskTime.rawValue)
        EventAnalytics.totalAndTask(total: total, task: tt)
        return tt
    }*/
    
    
    
    //リザルト画面３つ。　何もなし　デイリー　クエスト
    static func showScoreResult(view: VideoCameraView,score:Float,bonus:Float) -> UIAlertController{
        //saveData(score: Int(score))//スコアリストにセーブ（必要ない？？）
        let title = "Score \(Int(score))p"
        var message = "(デイリー達成済み 経験値なし)"
        if bonus != 1.0 {message += "(\nスケット補正　×\(bonus))"}
        let alert: UIAlertController = UIAlertController(title: title, message:  message, preferredStyle:  UIAlertController.Style.alert)
        //alert.view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let confirmAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            view.isVideo = false
        })
        alert.addAction(confirmAction)
        return alert
    }
    static func showDailyResult(view: VideoCameraView,bonus:Float,killList:[boss],lostHeart:Int)
    -> (UIAlertController,UIProgressView,Float,Float,Int,UIProgressView,Float,Float,Int){
        EventAnalytics.totalBattle()
        //let alert: UIAlertController = UIAlertController(title:"", message:"", preferredStyle:  UIAlertController.Style.alert)
        //let taskTime = UserDefaults.standard.integer(forKey: Keys.taskTime.rawValue)
        //let center = Int(alert.view.frame.height*0)
        let alert: UIAlertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message:  "",
                                                         preferredStyle:  UIAlertController.Style.alert)
        //alert.view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let confirmAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            view.isVideo = false
        })
        alert.addAction(confirmAction)
        
        var exp = 0
        var wid = 0
        let lav = UILabel(frame: CGRect(x: 10, y: 5, width: 200, height: 20))
        lav.text = "\n たおした数　\(killList.count)!!"
        alert.view.addSubview(lav)
        
        for kill in killList {
            let myInputImage = CIImage(image: UIImage(named: kill.image)!)
            let imageView = UIImageView(frame: CGRect(x:10+wid, y:30, width:40, height:40))
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
        
        let resultLv = updateLv(score: exp)
        //let message = resultLv.3//DataCounter.mes(score: exp, str: "")
        let lav2 = UILabel(frame: CGRect(x: 10, y: 75 , width: 200, height: 20))
        lav2.text = resultLv.3//message
        alert.view.addSubview(lav2)
        let progressLV = UIProgressView(progressViewStyle: .default)
        progressLV.frame = CGRect(x: 10, y: 100 , width: 200, height: 20)
        progressLV.progress = 0.0
        progressLV.setProgress(0.0, animated: true)
        progressLV.tintColor = UIColor.yellow
        alert.view.addSubview(progressLV)
    
        let result = DataCounter.updateTT(score: exp,lost: lostHeart)//初期値、末期値、何回プログレスバーを更新するかInt
        let lav3 = UILabel(frame: CGRect(x: 10, y: 130 , width: 400, height: 20))
        lav3.text = result.3//"制限時間が\(taskTime)秒に伸びました！"
        alert.view.addSubview(lav3)
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.frame = CGRect(x: 10, y: 155 , width: 200, height: 20)
        progressView.progress = 0.0
        progressView.setProgress(0.0, animated: true)
        progressView.tintColor = UIColor.blue
        alert.view.addSubview(progressView)
        
        //self.saveData(score: exp)
        return (alert, progressLV,resultLv.0,resultLv.1,resultLv.2,progressView, result.0, result.1, result.2)
    }
    
    
    func showQuestResult(view: QuestCameraView,qType: Int, qScore: Int) -> UIAlertController{
        let alert :UIAlertController = UIAlertController(title: "", message: "", preferredStyle:  UIAlertController.Style.alert)
        var title = ""
        let qNum: Int = UserDefaults.standard.integer(forKey: Keys.questNum.rawValue)
        let qGoal: [Int] = UserDefaults.standard.array(forKey: Keys.qGoal.rawValue) as! [Int]
        var qsl: [Int] = UserDefaults.standard.array(forKey: Keys.qsl.rawValue) as? [Int] ?? [0,0,0]
        
        switch qType {
        case 1:title += "\n 獲得コイン　\(qScore) コ\n"
        case 2:title = "\n スコア　\(qScore)p \n"
        case 3,4:title += "\n移動距離 \(qScore)m\n"
        default:title = ""
        }
        if qScore >= qGoal[2] {qsl[qNum] = 3;title += " クエスト　コンプリート！\n"}
        else if qScore >= qGoal[1] {qsl[qNum] = 2;title += " 2/3　達成\n"}
        else if qScore >= qGoal[0] {qsl[qNum] = 1;title += " 1/3　達成\n"}
        
        UserDefaults.standard.set(0, forKey: Keys.questNum.rawValue)
        UserDefaults.standard.set(0, forKey: Keys.questType.rawValue)
        UserDefaults.standard.set(qsl, forKey: Keys.qsl.rawValue)
        alert.title = title
        let confirmAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            view.isVideo = false
        })
        alert.addAction(confirmAction)
        return alert
    }
    
    /*
    //Lv
    static func mes(score: Int,str: String) -> String{
        let ctrLeval = levelUp(score: score)//DataCounter().levelUp(score: boss!.bonus)
        var message = ""
        if ctrLeval.0 == ctrLeval.1 {
            message = "Exp 獲得 \(score)p \(str)"
        }else{
            EventAnalytics.levelUp(level: ctrLeval.1)
            message = "レベルアップ！！ \(ctrLeval.0) → \(ctrLeval.1)"
        }
        return message
    }
    static func levelUp(score:Int) -> (Int,Int){
        let user = UserDefaults.standard
        let levelTable = [200,480,870,1320,1830,2400,3030,3720,4470,5280,6150,7080,8070,9120,10230,11400,
        12630,13920,15270,16680,18150,19680,21270,22920,24630,26400,27930,29220,30570,31980,33480]
        var exp: Int = user.integer(forKey: Keys.exp.rawValue)//読み込み
        let preLevel: Int = user.integer(forKey: Keys.level.rawValue)//読み込み
        var newLevel = preLevel
        exp += score
        
        for i in 0...levelTable.count-1 {
            if levelTable[i] > exp {
                newLevel = i
                break
            }
        }
        user.set(exp, forKey: Keys.exp.rawValue)
        user.set(newLevel, forKey: Keys.level.rawValue)
        
        return (preLevel,newLevel)
    }
    */
    
    static func updateLv(score: Int) -> (Float,Float,Int,String){
        let levelTable = [200,480,870,1320,1830,2400,3030,3720,4470,5280,6150,7080,8070,9120,10230,11400,
        12630,13920,15270,16680,18150,19680,21270,22920,24630,26400,27930,29220,30570,31980,33480]
        let exp: Int = UserDefaults.standard.integer(forKey: Keys.exp.rawValue)//読み込み
        let preLv: Int = UserDefaults.standard.integer(forKey: Keys.level.rawValue)//読み込み
        var newLv = preLv
        
        for i in 0...levelTable.count-1 {
            if levelTable[i] > exp+score {
                newLv = i
                break
            }
        }
        UserDefaults.standard.set(exp+score, forKey: Keys.exp.rawValue)
        UserDefaults.standard.set(newLv, forKey: Keys.level.rawValue)
        
        let be = Float(exp-levelTable[preLv-1]) / Float(levelTable[preLv]-levelTable[preLv-1])
        let af = Float(exp+score-levelTable[newLv-1]) / Float(levelTable[newLv]-levelTable[newLv-1])
        var message = ""
        if newLv == preLv{
            message = "Exp 獲得 \(score)p "
        }else{
            EventAnalytics.levelUp(level: newLv)
            message = "レベルアップ！！ \(preLv) → \(newLv)"
        }
        
        return (be,af,newLv-preLv,message)
    }
    
    //前のタイム経験値、今回の経験値の端数、何回プログレスバーを更新するかInt (VideoCameraView)
    static func updateTT(score: Int,lost: Int) -> (Float,Float,Int,String){
        let TimeList = [10,30,60,90,120,150,180,210,240]
        let TTT = [0,5000,16000,40000,79000,135000,210000,306000,425000]
        var expTT = UserDefaults.standard.integer(forKey: Keys.expTT.rawValue)
        var bn = 1
        var an = 1
        var count = 0
        for i in 1...TTT.count-1 {
            if TTT[i] > expTT { bn = i; break }
        }
        let before: Float = Float(expTT-TTT[bn-1]) / Float(TTT[bn]-TTT[bn-1])// 0.0 - 1.0
       
        var text = ""
        var after: Float = 0.0
        if lost != 0{
            let diffic = UserDefaults.standard.integer(forKey: Keys.difficult.rawValue)//1or2or6
            expTT -= (2000 * diffic * lost) + score
            for i in 1...TTT.count-1 {
                if TTT[i] > expTT { an = i; break }
            }
            after = Float(expTT+score-TTT[an-1]) / Float(TTT[an]-TTT[an-1])// 0.0 - 1.0
            text = "ペナルティ　制限時間　\(TimeList[an])秒"
            count = an-bn-1
        }else{
            for i in 1...TTT.count-1 {
                if TTT[i] > expTT+score { an = i; break }
            }
            after = Float(expTT+score-TTT[an-1]) / Float(TTT[an]-TTT[an-1])// 0.0 - 1.0
            text = "制限時間　\(TimeList[an])秒"
            count = an-bn
        }
        //print("before\(before) ,after\(after) ,lebel \(an-bn)")
        UserDefaults.standard.set(TimeList[an-1], forKey: Keys.taskTime.rawValue)
        UserDefaults.standard.set(expTT+score, forKey: Keys.expTT.rawValue)
        
        return (before,after,count,text)
    }
    
    func saveMyPose(poseList:[Int]){
        guard let myName = UserDefaults.standard.string(forKey: Keys.myName.rawValue) else {return}
        let db = Firestore.firestore().collection("users").document(myName)
        db.updateData([
            "poseList": poseList
        ]) { err in
            if let err = err {
                print("エラー　Error adding document: \(err)")
            } else {
                print("PoseListの保存成功！！")
            }
        }
    }
}
