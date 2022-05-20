

import Foundation
import SwiftUI

struct QuestAlertItem: Identifiable {
    var id = UUID()
    var title: Text
    var message: Text
    var primary : Alert.Button
    var secondary: Alert.Button
}

struct Quest: Identifiable {
    var id = UUID()     // ユニークなIDを自動で設定¥
    var number: Int
    var type: Int
    var goal: [Int]
    var time: Int
    var name: String
    var text: String
}

struct QuestViewModel {
    static var stageManager = [1,1, 2,2,2, 3,3,3,3, 4,4,4,4,4]
    static var quests:[Quest] = [
        Quest(number: 0,type: 1,goal: [3,4,5],time: 10,name: "コイン集め", text: "制限時間以内に、画面上のコインを5コ集める"),
        Quest(number: 1,type: 2,goal: [100,230,350],time: 10,name: "とにかく動け！", text: "制限時間以内に、スコア 350以上のはげしい運動をする"),
        
        
        Quest(number: 2, type: -1, goal: [5,7,10], time: 60, name: "HIIT(ヒート)体験版",text:"画面が赤い時だけ全力で動きましょう。\n60秒以内にモンスターを10体たおす\n\n※注意　このクエストには、難易度が反映されます"),
        Quest(number: 3,type: 1,goal: [5,8,10],time: 10,name: "コイン集め", text: "制限時間以内に、画面上のコインを6コ集める"),
        Quest(number: 4,type: 2,goal: [200,300,400],time: 10,name: "とにかく動け！", text: "制限時間以内に、スコア 400以上のはげしい運動をする"),
        
        
        Quest(number: 5,type: 3,goal: [60,100,140],time: 10,name: "ボルダリング", text: "制限時間以内に、140m　登りきる"),
        Quest(number: 6,type: 1,goal: [6,9,11],time: 10,name: "コイン集め", text: "制限時間以内に、画面上のコインを8コ集める"),
        Quest(number: 7,type: 2,goal: [340,400,450],time: 10,name: "とにかく動け！", text: "制限時間以内に、スコア 450以上のはげしい運動をする"),
        //Quest(number: 9,type: 3,goal: [100,170,200],time: 10,name: "ボルダリング", text: "制限時間以内に、200m　登りきる"),
        Quest(number: 8, type: -1, goal: [10,14,20], time: 120, name: "HIIT(ヒート)体験版", text: "画面が赤い時だけ全力で動きましょう。\n120秒以内にモンスターを20体たおす"),
        
        
        Quest(number: 9,type: 1,goal: [7,9,11],time: 10,name: "コイン集め", text: "制限時間以内に、画面上のコインを11コ集める"),
        Quest(number: 10,type: 2,goal: [400,500,550],time: 10,name: "とにかく動け！", text: "制限時間以内に、スコア 550以上のはげしい運動をする"),
        Quest(number: 11,type: 3,goal: [150,200,250],time: 10,name: "ボルダリング", text: "制限時間以内に、250m　登りきる"),
        Quest(number: 12, type: -1, goal: [15,21,30], time: 180, name: "HIIT(ヒート)体験版", text: "画面が赤い時だけ全力で動きましょう。\n180秒以内にモンスターを30体たおす"),
        Quest(number: 13, type: 5, goal: [15,21,30], time: 10, name: "テスト", text: "あああ"),
        //Quest(number: 12,type: 4,goal: [8,15,25],name: "スケート", text: "制限時間以内に、25m　滑りきる"),
    ]
    
    
    static func showQuests(stageOnNow: Int) -> [Quest]{
        var list: [Quest] = []
        let num = getStageNum(stage: stageOnNow)
        for i in 0 ..< getStageQuantity(stage: stageOnNow) {
            list.append(quests[num+i])
        }
        return list
    }
    static func getStageQuantity(stage: Int) -> Int{
        var quantity = 0
        for i in stageManager{
            if stage == i {quantity += 1}
        }
        return quantity
    }
    static func getStageNum(stage: Int) -> Int{
        return stageManager.firstIndex(of: stage) ?? 1000
    }
    
    
    static func getQuestAlertItem(item: Quest,appState: AppState, charg: Int) -> QuestAlertItem{
        return QuestAlertItem(
            title: Text(item.name),
            message: Text(item.text),
            primary: Alert.Button.cancel(Text(str.quite.rawValue)),
            secondary: Alert.Button.default(
                Text(str.challenge.rawValue),
                action: {
                    UserDefaults.standard.set(item.number, forKey: Keys.questNum.rawValue)
                    UserDefaults.standard.set(item.type,forKey: Keys.questType.rawValue)
                    UserDefaults.standard.set(item.goal, forKey: Keys.qGoal.rawValue)
                    UserDefaults.standard.set(item.time, forKey: Keys.qTime.rawValue)
                    UserDefaults.standard.set(Date(), forKey: Keys.lastOpenedScreen.rawValue)
                    UserDefaults.standard.set(charg + 300, forKey: Keys.chargTime.rawValue)
                    EventAnalytics.questDone()
                    if item.type == -1 {
                        appState.isVideo = true
                    }else{
                        appState.isQuest = true
                    }
                }
            ))
    }
    
    static func setTimer() -> Int {
        guard let lastOpenedScreen: Date = UserDefaults.standard.object(forKey: Keys.lastOpenedScreen.rawValue) as? Date else {return 0}
        //let cal =
//        let todayDC = Calendar.current.dateComponents([.year,.month,.day,.minute,.second], from: Date())
//        let lastDC = Calendar.current.dateComponents([.year,.month,.day,.minute,.second], from: lastOpenedScreen)
//        let pastSec: DateComponents = cal.dateComponents([.second], from: todayDC, to: lastDC)
//        print("todayDC = \(todayDC),,,,lastDC = \(lastDC),,,,pastSec = \(pastSec)")

        let dt = Date()
        let  diff = Calendar.current.dateComponents([.second], from: lastOpenedScreen, to: dt)
        print("dt = \(dt),,,,lastDC = \(lastOpenedScreen),,,,deiff1  = \(diff)")
        
        let charge = UserDefaults.standard.integer(forKey: Keys.chargTime.rawValue)
        if charge - diff.second! <= 0 {return 0}
        return charge - diff.second!
    }
}
