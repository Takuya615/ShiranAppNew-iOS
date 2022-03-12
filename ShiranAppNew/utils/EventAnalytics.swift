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
    
    static private let isDebag = true
    
    static func tapFab(){
        if isDebag {return}
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
          AnalyticsParameterItemID: "id-DailyTask",
          AnalyticsParameterItemName: "Fabのタップ数",
          AnalyticsParameterItemCategory: "Daily"
        ])
    }
    
    static func doneNotEveryDay(diff: Int){
        if isDebag {return}
        Analytics.logEvent("doneNotEveryday", parameters: [
            AnalyticsParameterItemCategory: "Daily",
            AnalyticsParameterItemName: "継続しっぱい数",
          "count": "\(diff) 日ぶりの更新" as NSObject
        ])
    }
    
    
    //DataCounter
    static func levelUp(level: Int){
        if isDebag {return}
        let totalDay: Int = UserDefaults.standard.integer(forKey: Keys.totalDay.rawValue)
        Analytics.logEvent(AnalyticsEventLevelUp, parameters: [
            AnalyticsParameterItemName: "レベルアップ",
            AnalyticsParameterLevel: level,
            AnalyticsParameterCharacter: "Player-継続-\(totalDay)日目"
        ])
    }
    
    
    static func share(){
        if isDebag {return}
        Analytics.logEvent(AnalyticsEventShare, parameters: [
            AnalyticsParameterMethod: "SNS",
            AnalyticsParameterContentType: "Text"
        ])
    }
    
    static func lastCharacterReleased(){
        if isDebag {return}
        Analytics.logEvent("LastCharaReleased", parameters: [
            AnalyticsParameterItemName: "ラストキャラ使われた",
            AnalyticsParameterContentType: "Int"
        ])
    }
    
    //Character.finish()
    static func doneCharacter(){
        if isDebag {return}
        Analytics.logEvent("doneCharacter", parameters: [
            AnalyticsParameterItemCategory: "Daily",
            AnalyticsParameterItemName: "キャラクター利用数"
        ])
    }
    static func difficult(){
        if isDebag {return}
        Analytics.logEvent("difficult", parameters: [
            AnalyticsParameterItemCategory: "Daily",
            AnalyticsParameterItemName: "キャラクター利用数"
        ])
    }
    
    
    
    //ContentView.fouthView  in .alert()
    static func questDone(){
        if isDebag {return}
        Analytics.logEvent("questDone", parameters: [
            AnalyticsParameterItemCategory: "quest",
            AnalyticsParameterItemName: "クエスト利用数"
        ])
    }
    static func qCrear1(){
        if isDebag {return}
        Analytics.logEvent("qClear1", parameters: [
            AnalyticsParameterItemCategory: "quest",
            AnalyticsParameterItemName: "ステージ１のクリア数"
        ])
    }
    static func qCrear2(){
        if isDebag {return}
        Analytics.logEvent("qClear2", parameters: [
            AnalyticsParameterItemCategory: "quest",
            AnalyticsParameterItemName: "ステージ2のクリア数"
        ])
    }
    static func qCrear3(){
        if isDebag {return}
        Analytics.logEvent("qClear3", parameters: [
            AnalyticsParameterItemCategory: "quest",
            AnalyticsParameterItemName: "ステージ3のクリア数"
        ])
    }
}
