

import Foundation
import SwiftUI

struct QuestAlertItem: Identifiable {
    var id = UUID()
    var title: Text
    var message: Text
    var primary : Alert.Button
    var secondary: Alert.Button
}

struct QuestSheetItem: Identifiable{
    var id = UUID()
    var url:String?
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
    static var stageManager = [1,1, 2,2,2, 3,3, 4,4,4, 5,5,5]
    static func textHiit(_ sec:Int,_ goal:Int) -> String{
        return "画面が赤い時だけ全力で動きましょう。\n\(sec)秒以内にモンスターを\(goal)体たおす\n\n※注意　このクエストには、難易度が反映されます"
    }
    static var quests:[Quest] = [
        //TT = 5~10
        Quest(number: 0,type: 1,goal: [3,4,10],time: 0,name: "コイン集め", text: "時間以内に、画面上のコインを10コ集める"),
        Quest(number: 1,type: 2,goal: [200,350,700],time: 0,name: "とにかく動け！", text: "時間以内に、スコア 700以上のはげしい運動をする"),
        //TT = 8-15
        Quest(number: 2,type: 3,goal: [60,100,150],time: 0,name: "ボルダリング", text: "時間以内に、カベを150m登りきる"),
        Quest(number: 3, type: 5, goal: [150,300,600], time: 0, name: "パワーチャージ", text: "時間内にエナジーバーを満杯にする"),
        Quest(number: 4, type: -1, goal: [10,20,25], time: 60, name: "HIIT(ヒート)体験版",text:textHiit(60,25)),
        //TT = 10-20
        Quest(number: 5,type: 3,goal: [80,110,200],time: 0,name: "ボルダリング", text: "時間以内に、カベを200m登りきる"),
        Quest(number: 6, type: -1, goal: [30,40,50], time: 120, name: "HIIT(ヒート)体験版2", text:textHiit(120, 50)),
        Quest(number: 7, type: 6, goal: [150,300,600], time: 0, name: "パワーチャージ2", text: "時間内にエナジーバーを満杯にする"),
        //TT = 13-30
        Quest(number: 8,type: 1,goal: [8,13,30],time: 0,name: "コイン集め", text: "時間以内に、画面上のコインを30コ集める"),
        Quest(number: 9, type: -1, goal: [40,60,70], time: 180, name: "HIIT(ヒート)体験版3", text:textHiit(180, 70)),
        Quest(number: 10, type: 7, goal: [300,500,1000], time: 0, name: "パワーチャージ3", text: "時間内にエナジーバーを満杯にする"),
        //TT = 15-40
        Quest(number: 11,type: 1,goal: [10,15,40],time: 0,name: "コイン集め", text: "時間以内に、画面上のコインを40コ集める"),
        Quest(number: 12, type: -1, goal: [60,80,95], time: 240, name: "タバタ式 HIIT(ヒート)", text:textHiit(240, 95)),
        Quest(number: 13, type: 7, goal: [350,700,1400], time: 0, name: "パワーチャージ3", text: "時間内にエナジーバーを満杯にする"),
    ]
    
    
    static func showQuests(stageOnNow: Int) -> [Quest]{
        var list: [Quest] = []
        let num = getStageNum(stage: stageOnNow)
        for i in 0 ..< getStageQuantity(stage: stageOnNow) {
            list.append(Config.reQuest(quest: quests[num+i]))
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
    
    static func getQuestSheetItem(page: Int) -> QuestSheetItem{
        var url: String?
        switch page {
        case 0: url = Bundle.main.path(forResource: "q_coin", ofType: "mp4")
        case 1: url = Bundle.main.path(forResource: "q_hiit", ofType: "mov")
        case 3: url = Bundle.main.path(forResource: "q_climb", ofType: "mp4")
        default: url = Bundle.main.path(forResource: "q_coin", ofType: "mp4")
        }
        return QuestSheetItem(url: url)
    }
    
    static func getQuestAlertItem(item: Quest,appState: AppState, charg: Int) -> QuestAlertItem{
        let interval: Int = UserDefaults.standard.integer(forKey: Keys.rcQReHeart.rawValue)
        return QuestAlertItem(
            title: Text(item.name),
            message: Text(item.text),
            primary: Alert.Button.cancel(Text(str.quite.rawValue)),
            secondary: Alert.Button.default(
                Text(str.challenge.rawValue),
                action: {
                    EventAnalytics.tap(name: item.name, type: "quest")
                    UserDefaults.standard.set(item.number, forKey: Keys.questNum.rawValue)
                    UserDefaults.standard.set(item.type,forKey: Keys.questType.rawValue)
                    UserDefaults.standard.set(item.goal, forKey: Keys.qGoal.rawValue)
                    UserDefaults.standard.set(item.time, forKey: Keys.qTime.rawValue)
                    UserDefaults.standard.set(Date(), forKey: Keys.lastOpenedScreen.rawValue)
                    UserDefaults.standard.set(charg + interval, forKey: Keys.chargTime.rawValue)
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
        let dt = Date()
        let  diff = Calendar.current.dateComponents([.second], from: lastOpenedScreen, to: dt)
        let charge = UserDefaults.standard.integer(forKey: Keys.chargTime.rawValue)
        if charge - diff.second! <= 0 {return 0}
        return charge - diff.second!
    }
}
