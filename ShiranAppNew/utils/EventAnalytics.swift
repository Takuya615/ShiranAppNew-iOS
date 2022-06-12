

import Foundation
import Firebase
import FirebaseAnalytics

struct EventAnalytics {
    static let isDebag = true
    static let isDeb = true
    
    //カスタムイベント
    static func action_setting(type:String){
        let skinNo:Int = UserDefaults.standard.integer(forKey:Keys.selectSkin.rawValue)
        let bodyNo:Int = UserDefaults.standard.integer(forKey:Keys.selectBody.rawValue)
        let diff = UserDefaults.standard.integer(forKey: Keys.difficult.rawValue)//0 1 2
        let qNo: Int = UserDefaults.standard.integer(forKey: Keys.questNum.rawValue)
        let tt: Int = UserDefaults.standard.integer(forKey: Keys.taskTime.rawValue)
        let level = UserDefaults.standard.integer(forKey: Keys.level.rawValue)
        //print("action_setting\(type),\(Skin.skins[skinNo].name),\(Body.bodys[bodyNo].name),\(SettingView.difficults[diff]),\(qNo)")
        if isDeb {return}
        Analytics.logEvent("action_setting", parameters: [
            "action_type": type,            
            "task_time": tt,
            "level": level,
            "quest": qNo,
            "face_skin": Skin.skins[skinNo].name,
            "body_skin": Body.bodys[bodyNo].name,
            "difficult": SettingView.difficults[diff],
        ])
    }
    static func action_achieve(type:String,achieve:Int){
        let skinNo:Int = UserDefaults.standard.integer(forKey:Keys.selectSkin.rawValue)
        let bodyNo:Int = UserDefaults.standard.integer(forKey:Keys.selectBody.rawValue)
        let diff = UserDefaults.standard.integer(forKey: Keys.difficult.rawValue)//0 1 2
        let qNo: Int = UserDefaults.standard.integer(forKey: Keys.questNum.rawValue)
        let tt: Int = UserDefaults.standard.integer(forKey: Keys.taskTime.rawValue)
        let level = UserDefaults.standard.integer(forKey: Keys.level.rawValue)
        //print("action_achieve\(type),\(level),\(achieve),")
        if isDeb {return}
        Analytics.logEvent("action_acheive", parameters: [
            "action_type": type,
            "task_time": tt,
            "level": level,
            "quest": qNo,
            "face_skin": Skin.skins[skinNo].name,
            "body_skin": Body.bodys[bodyNo].name,
            "difficult": SettingView.difficults[diff],
            "achieve": achieve,
        ])
    }
//    static func action_quality(error:Int,quarter:Int,half:Int,three:Int){
//        DispatchQueue.global().async {
//
//        }
//        print("action_qualityエラー率\(error)%,25％活動率\(quarter)%,50％活動率\(half)%,75％活動率\(three)%")
//        if isDeb {return}
//        Analytics.logEvent("action_quality", parameters: [
//            "error_par_all_flame": error,
//            "quarter_par_all_flame": quarter,
//            "half_par_all_flame": half,
//            "three_quarter_par_all_flame": three,
//        ])
//    }
    
    static func tap(name: String,type: String){
        if isDeb {print(name);return}
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
          AnalyticsParameterContent: name,
          AnalyticsParameterContentType: type
          ])
//        Analytics.logEvent("button_tap", parameters: [
//            "button_name": name
//        ])
    }
    static func tap(name: String){
        if isDeb {print(name);return}
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
          AnalyticsParameterContent: name,
          AnalyticsParameterContentType: ""
          ])
    }
    
    //推奨イベント
    static func levelUp(level: Int){
        if isDeb {print("level\(level)");return}
        Analytics.logEvent(AnalyticsEventLevelUp, parameters: [
          //AnalyticsParameterCharacter: character!,
            AnalyticsParameterLevel: level
          ])
    }
    static func earn_virtual_currency(matter virtualCurrencyName :String,amount value: Int){
        if isDeb {print("稼いだ\(virtualCurrencyName)を\(value)");return}
        Analytics.logEvent(AnalyticsEventEarnVirtualCurrency, parameters: [
          AnalyticsParameterValue: value,
          AnalyticsParameterVirtualCurrencyName: virtualCurrencyName//coin or diamond
          ])
    }
    static func spend_virtual_currency(item itemName:String,matter virtualCurrencyName :String,amount value: Int){
        if isDeb {print("支払い\(virtualCurrencyName)の\(value)で\(itemName)を買った");return}
        Analytics.logEvent(AnalyticsEventSpendVirtualCurrency, parameters: [
          AnalyticsParameterItemName: itemName,
          AnalyticsParameterValue: value,
          AnalyticsParameterVirtualCurrencyName: virtualCurrencyName//coin or diamond
          ])
    }
    static func in_app_purchase(/*id:String,*/item:String,price:Int){
        if  isDeb {print("課金した\(item)ni\(price)支払った");return}
        Analytics.logEvent(AnalyticsEventPurchase, parameters: [
            AnalyticsParameterTransactionID: "TransactionID",
            AnalyticsParameterItems: [
                AnalyticsParameterItemName: item,
                AnalyticsParameterPrice: price
            ]
        ])
    }
//    static func tutorial_begin(){//△
//        if isDebag {return}
//        Analytics.logEvent(AnalyticsEventTutorialBegin, parameters: nil)
//    }
//    static func tutorial_complete(){//△
//        if isDebag {return}
//        Analytics.logEvent(AnalyticsEventTutorialComplete, parameters: nil)
//    }
//    static func share(){
//        if isDebag {return}
//        Analytics.logEvent(AnalyticsEventShare, parameters: nil)
//    }
//    static func signUp(){
//        if isDebag {return}
//        Analytics.logEvent(AnalyticsEventSignUp, parameters: nil)
//    }
//    static func login(){
//        if isDebag {return}
//        Analytics.logEvent(AnalyticsEventLogin, parameters: nil)
//    }
    
}
