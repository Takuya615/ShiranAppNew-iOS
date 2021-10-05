//
//  DataCounter.swift
//  ShiranAppNew
//
//  Created by user on 2021/10/01.
//

import Foundation
import SwiftUI


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
    
    let bossNum = "BOSS_ListNumber"
    //let bossHP = "BOSS_HP"
    let damage = "BOSS_Damege"
    
    @Published var countedLevel: Int = UserDefaults.standard.integer(forKey: "Level")
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
            User.set(1, forKey: self.totalDay)//総日数
            User.set( 1, forKey: self.continuedDay)//継続日数
            let lastDay = Calendar.current.date(byAdding: .day, value: -1, to: today)!
            User.set(lastDay, forKey: self._LastTimeDay)//デイリー更新(初回はもう一度遊べるようにする)
            continuedDayCounter = 1
            updateTaskTime(total: 181)
            return -1
        }
                    
        let cal = Calendar(identifier: .gregorian)
        let todayDC = Calendar.current.dateComponents([.year, .month,.day], from: today)
        let lastDC = Calendar.current.dateComponents([.year, .month,.day], from: LastTimeDay!)
        let diff = cal.dateComponents([.day], from: lastDC, to: todayDC)
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
            
        }else{
            print("記録リセット")
            User.set(0, forKey: self.continuedDay)
            continuedDayCounter = 0
            User.set(retry + 1, forKey: self.retry)//値の書き込み　↓表示の更新
            continuedRetryCounter = retry + 1
        }
        User.set(totalDay + 1, forKey: self.totalDay)
        User.set(today, forKey: self._LastTimeDay)
        updateTaskTime(total: totalDay)
        return diff.day!
    }
    
    func saveData(score: Int){
        //日時の指定
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale =  Locale(identifier: "ja_JP")
        let date = dateFormatter.string(from: Date())
        
        let dateList: [String]? = UserDefaults.standard.array(forKey: DataCounter().listD) as? [String]
        let scoreList:[Int]? = UserDefaults.standard.array(forKey: DataCounter().listS) as? [Int]
        
        if var dateList = dateList, var scoreList = scoreList {
            dateList.append(date)
            scoreList.append(score)
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
        UserDefaults.standard.set(tt, forKey: self.taskTime)
    }
    
    func levelUp(score:Int) -> (Int,Int){
        let user = UserDefaults.standard
        let levelTable = [10,480,870,1320,1830,2400,3030,3720,4470,5280,6150,7080,8070,9120,10230,11400,
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
        var message = "(デイリー達成済み)\(addStr)"
        
        if num != 0 {//　　　　　デイリー達成していない
            if boss == nil {
                title = mes(view: view, score: intScore,str: addStr)
                message = ""
            }else{
                let damage: Float = UserDefaults.standard.float(forKey: DataCounter().damage)
                let reHP = boss!.maxHp - score - damage
                if reHP < 0 {//撃破！！
                    UserDefaults.standard.set(0.0, forKey: DataCounter().damage)
                    UserDefaults.standard.set(-1, forKey: DataCounter().bossNum)
                    title = "\(boss!.name)討伐 成功！！"
                    addStr = addStr + "\n(討伐ボーナス　Exp ＋\(boss!.bonus))"
                    message = mes(view: view, score: boss!.bonus + Int(score),str: addStr)
                    
                }else{
                    title = "\(boss!.name)討伐 未達成..."
                    if boss!.encount != 0 {//ボスならEXP全部没収
                        addStr = addStr + "\n(ボスペナルティー　Exp ×0.1)"
                        message = mes(view: view, score: boss!.bonus/10, str: addStr)
                        UserDefaults.standard.set(score + damage, forKey: DataCounter().damage)
                    }else{
                        addStr = addStr + "\n(ペナルティー　Exp ×0.5)"
                        message = mes(view: view, score: boss!.bonus/2, str: addStr)
                    }
                    
                }
            }
        }
        
        let alert: UIAlertController = UIAlertController(title: title, message:  message, preferredStyle:  UIAlertController.Style.alert)
        let confirmAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            view.isVideo = false
        })
        alert.addAction(confirmAction)
        
        return alert
    }
    
    func mes(view: VideoCameraView ,score: Int,str: String) -> String{
        let ctrLeval = view.dataCounter.levelUp(score: score)//DataCounter().levelUp(score: boss!.bonus)
        var message = ""
        if ctrLeval.0 == ctrLeval.1 {
            message = "Exp 獲得 \(score)p \(str)"
        }else{
            message = "レベルアップ！！ \(ctrLeval.0) → \(ctrLeval.1)"
        }
        return message
    }
    
}
