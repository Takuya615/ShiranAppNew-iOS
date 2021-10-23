//
//  DataCounter.swift
//  ShiranAppNew
//
//  Created by user on 2021/10/01.
//

import Foundation
import SwiftUI
import Firebase


class DataCounter: ObservableObject {
    
    // Key
    let totalDay = "totalDay"
    let continuedDay = "cDay"
    let continuedWeek = "wDay"
    let retry = "retry"
    let _LastTimeDay = "LastTimeDay"
    let taskTime = "TaskTime"
    let listD = "dateList"
    let listS = "scoreList"
    
    let level = "Level"
    let exp = "ExperiencePoint"
    let coin = "Coin"
    let diamond = "Diamond"
    let bossNum = "BOSS_ListNumber"
    let damage = "BOSS_Damege"
    let myName = "MyName"
    let questNum = "QuestNumber"
    let qsl = "QuestStateList"
    let skin = "SkinNumber"
    
    @Published var countedLevel: Int = UserDefaults.standard.integer(forKey: "Level")
    @Published var countedCoin: Int = UserDefaults.standard.integer(forKey: "Coin")
    @Published var countedDiamond: Int = UserDefaults.standard.integer(forKey: "Diamond")
    @Published var questStateList: [Int]? = UserDefaults.standard.array(forKey: "QuestStateList") as? [Int]
    @Published var continuedDayCounter: Int = UserDefaults.standard.integer(forKey: "cDay")//めいんViewに表示する用
    @Published var continuedRetryCounter: Int = UserDefaults.standard.integer(forKey: "retry")//めいんViewに表示する用
    //@Published var capStart: Bool = false//??

    //日時の差分を計算するメソッド
    func scoreCounter(score: Int) -> Int{
        saveData(score: score)
        
        let User = UserDefaults.standard
        let totalDay: Int = User.integer(forKey: self.totalDay)//読み込み
        
        let today = Date()
        //let LastTimeDay = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let LastTimeDay: Date? = User.object(forKey: self._LastTimeDay) as? Date
    
        if LastTimeDay == nil{
            print("記念すべき第一回目")
            User.set(0, forKey: self.totalDay)//総日数
            User.set(0, forKey: self.continuedDay)//継続日数
            let lastDay = Calendar.current.date(byAdding: .day, value: -1, to: today)!
            User.set(lastDay, forKey: self._LastTimeDay)//デイリー更新(初回はもう一度遊べるようにする)
            continuedDayCounter = 0
            updateTaskTime(total: 7)
            return -1
        }
                    
        let cal = Calendar(identifier: .gregorian)
        let todayDC = Calendar.current.dateComponents([.year, .month,.day], from: today)
        let lastDC = Calendar.current.dateComponents([.year, .month,.day], from: LastTimeDay!)
        let di: DateComponents? = cal.dateComponents([.day], from: lastDC, to: todayDC)
        guard let diff = di else {return 0}
        print("todayDC:\(todayDC)")
        print("dt1DC:\(lastDC)")
        print("差は \(diff.day!) 日")
                
        
        //var calenderList:[ Int] = UserDefaults.standard.object(forKey: self.calender) as? [Int] ?? []//値が無ければ空のリスト
        let continuedDay = User.integer(forKey: self.continuedDay)
        let retry = User.integer(forKey: self.retry)
        
        if diff.day == 0{
            print("デイリー達成済み")
            return 0
        }else if(diff.day == 1){
            print("毎日記録更新")
            User.set(continuedDay + 1, forKey: self.continuedDay)
            continuedDayCounter = continuedDay + 1
            EventAnalytics().doneDayly()
        }else{
            print("記録リセット")
            User.set(0, forKey: self.continuedDay)
            continuedDayCounter = 0
            User.set(retry + 1, forKey: self.retry)//値の書き込み　↓表示の更新
            continuedRetryCounter = retry + 1
            EventAnalytics().doneNotEveryDay(diff: diff.day!)
        }
        User.set(totalDay + 1, forKey: self.totalDay)
        User.set(today, forKey: self._LastTimeDay)
        updateTaskTime(total: totalDay)
        return diff.day!
    }
    
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
        
    }
    
    func updateTaskTime(total:Int){
        if total%2 == 0{return}//偶数なら見送り
        var tt = UserDefaults.standard.integer(forKey: self.taskTime)
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
        /*if total % 7 != 0 { return}
        var tt = UserDefaults.standard.integer(forKey: self.taskTime)
        tt += 30
        if tt > 240 {tt = 240}*/
        UserDefaults.standard.set(tt, forKey: self.taskTime)
        EventAnalytics().totalAndTask(total: total, task: tt)
    }
    
    func levelUp(score:Int) -> (Int,Int){
        let user = UserDefaults.standard
        let levelTable = [200,480,870,1320,1830,2400,3030,3720,4470,5280,6150,7080,8070,9120,10230,11400,
        12630,13920,15270,16680,18150,19680,21270,22920,24630,26400,27930,29220,30570,31980,33480]
        var exp: Int = user.integer(forKey: self.exp)//読み込み
        let preLevel: Int = user.integer(forKey: self.level)//読み込み
        exp = exp + score
        user.set(exp, forKey: self.exp)
        
        for i in 0...levelTable.count-1 {
            if levelTable[i] > exp {
                countedLevel = i
                break
            }
        }
        /*if exp > levelTable[countedLevel] {
            countedLevel = countedLevel + 1
        }
        if exp > levelTable[countedLevel+1] {
            countedLevel = countedLevel + 1
        }
        if exp > levelTable[countedLevel+2] {
            countedLevel = countedLevel + 1
        }*/
        user.set(countedLevel, forKey: self.level)
        return (preLevel,countedLevel)
    }
    
    func showResult(view: VideoCameraView,boss:boss?,score:Float,bonus:Float,num:Int) -> UIAlertController{
        var addStr = ""
        if bonus != 1.0 {addStr = "\n(スケット補正　×\(bonus))"}
        let intScore = Int(score)
        var title = "Score \(intScore)p"
        var message = "(デイリー達成済み 経験値なし)\n\(addStr)"
        if view.qScore != 0 {
            title += "\nさわったボール　\(view.qScore) コ"
                        message = ""
            if view.qScore > 5 {title = "クエストクリア!!\n" + title
                self.questStateList = [0,2,0,0,0,0,0,0]
                UserDefaults.standard.set(0, forKey: DataCounter().questNum)
                UserDefaults.standard.set([0,2,0,0,0,0,0], forKey: DataCounter().qsl)
            }
        }
        let alert: UIAlertController = UIAlertController(title: title, message:  message, preferredStyle:  UIAlertController.Style.alert)
        if num != 0 {//　　　　　デイリー達成していない
            if boss == nil {
                title = "Score \(intScore)"//mes(score: intScore,str: addStr)
                message = ""
            }else{
                EventAnalytics().totalBattle()
                let damage: Float = UserDefaults.standard.float(forKey: DataCounter().damage)
                let reHP = boss!.maxHp - score - damage
                if reHP < 0 {//撃破！！
                    UserDefaults.standard.set(0.0, forKey: DataCounter().damage)
                    UserDefaults.standard.set(-1, forKey: DataCounter().bossNum)
                    title = "WINNER！！"
                    addStr = addStr + "\n(討伐ボーナス　Exp ＋\(boss!.bonus))"
                    message = mes(score: boss!.bonus + Int(score),str: addStr)
                    
                    //モノクロ
                    let myInputImage = CIImage(image: UIImage(named: boss!.image)!)
                    let imageView = UIImageView(frame: CGRect(x:100, y:-75, width:100, height:100))
                    let myMonochromeFilter = CIFilter(name: "CIColorMonochrome")
                    myMonochromeFilter!.setValue(myInputImage, forKey: kCIInputImageKey)
                    myMonochromeFilter!.setValue(CIColor(red: 0.9, green: 0.9, blue: 0.9), forKey: kCIInputColorKey)
                    myMonochromeFilter!.setValue(1.0, forKey: kCIInputIntensityKey)
                    let myOutputImage : CIImage = (myMonochromeFilter?.outputImage!)!
                    imageView.image = UIImage(ciImage: myOutputImage)//UIImage(named: boss!.image)
                    alert.view.addSubview(imageView)
                }else{
                    title = "\(boss!.name)討伐 失敗..."
                    let imageView = UIImageView(frame: CGRect(x:100, y:-75, width:100, height:100))
                    imageView.image = UIImage(named: boss!.image)
                    alert.view.addSubview(imageView)
                    
                    if boss!.encount != 0 {//ボスならEXP全部没収
                        addStr = addStr + "\n(ボスペナルティー　Exp ×0.1)"
                        message = mes(score: boss!.bonus/10, str: addStr)
                        UserDefaults.standard.set(score + damage, forKey: DataCounter().damage)
                    }else{
                        addStr = addStr + "\n(ペナルティー　Exp ×0.5)"
                        message = mes(score: boss!.bonus/2, str: addStr)
                        EventAnalytics().loseEnemy(enemy: boss!.name)
                    }
                    
                }
            }
        }
        
        alert.title = title
        alert.message = message
        let confirmAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            view.isVideo = false
        })
        alert.addAction(confirmAction)
        
        return alert
    }
    
    func mes(score: Int,str: String) -> String{
        let ctrLeval = levelUp(score: score)//DataCounter().levelUp(score: boss!.bonus)
        var message = ""
        if ctrLeval.0 == ctrLeval.1 {
            message = "Exp 獲得 \(score)p \(str)"
        }else{
            EventAnalytics().levelUp(level: ctrLeval.1)
            message = "レベルアップ！！ \(ctrLeval.0) → \(ctrLeval.1)"
        }
        return message
    }
    
    func saveMyPose(poseList:[Int]){
        guard let myName = UserDefaults.standard.string(forKey: self.myName) else {return}
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
