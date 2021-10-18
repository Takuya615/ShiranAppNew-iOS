//
//  EventAnalytics.swift
//  ShiranAppNew
//
//  Created by user on 2021/10/06.
//

import Foundation
import Firebase
import FirebaseAnalytics

class EventAnalytics {
    
    private let isDebag = true//false
    
    func tapFab(){
        if isDebag {return}
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
          AnalyticsParameterItemID: "id-DailyTask",
          AnalyticsParameterItemName: "Fabのタップ数",
          AnalyticsParameterItemCategory: "Daily"
        ])
    }
    func totalAndTask(total:Int,task:Int){
        if isDebag {return}
        Analytics.logEvent("totalAndTask", parameters: [
            AnalyticsParameterItemCategory: "Daily",
            AnalyticsParameterItemName: "総日数とタスク",
            "count": "総日\(total)日で タスク時間\(task)秒" as NSObject
        ])
    }
    func doneDayly(){
        if isDebag {return}
        Analytics.logEvent("doneDaily", parameters: [
            AnalyticsParameterItemCategory: "Daily",
            AnalyticsParameterItemName: "毎日更新数"
        ])
    }
    func doneNotEveryDay(diff: Int){
        if isDebag {return}
        Analytics.logEvent("doneNotEveryday", parameters: [
            AnalyticsParameterItemCategory: "Daily",
            AnalyticsParameterItemName: "継続しっぱい数",
          "count": "\(diff) 日ぶりの更新" as NSObject
        ])
    }
    
    
    //DataCounter
    func loseEnemy(enemy:String){
        if isDebag {return}
        //let total = UserDefaults.standard.integer(forKey: DataCounter().totalDay)
        let task = UserDefaults.standard.integer(forKey: DataCounter().taskTime)
        Analytics.logEvent("loseEnemy", parameters: [
            AnalyticsParameterItemCategory: "Battle",
            AnalyticsParameterItemName: "負けた数",
          "count": "\(enemy)タスク\(task)秒負け" as NSObject,
        ])
    }
    //DataCounter
    func totalBattle(){
        if isDebag {return}
        Analytics.logEvent("totalBattle", parameters: [
            AnalyticsParameterItemCategory: "Battle",
            AnalyticsParameterItemName: "総バトル回数"
        ])
    }
    //DataCounter
    func levelUp(level: Int){
        if isDebag {return}
        let totalDay: Int = UserDefaults.standard.integer(forKey: DataCounter().totalDay)
        Analytics.logEvent(AnalyticsEventLevelUp, parameters: [
            AnalyticsParameterItemName: "レベルアップ",
            AnalyticsParameterLevel: level,
            AnalyticsParameterCharacter: "Player-継続-\(totalDay)日目"
        ])
    }
    
    
    func share(){
        if isDebag {return}
        Analytics.logEvent(AnalyticsEventShare, parameters: [
            AnalyticsParameterMethod: "SNS",
            AnalyticsParameterContentType: "Text"
        ])
    }
    
    func lastCharacterReleased(){
        if isDebag {return}
        Analytics.logEvent("LastCharaReleased", parameters: [
            AnalyticsParameterItemName: "ラストキャラ使われた",
            AnalyticsParameterContentType: "Int"
        ])
    }
}
