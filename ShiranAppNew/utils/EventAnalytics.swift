

import Foundation
import Firebase
import FirebaseAnalytics

struct EventAnalytics {
    static let isDebag = true
    static let isDeb = true
    
    static func action_setting(){
        let diff = UserDefaults.standard.integer(forKey: Keys.difficult.rawValue)//0 1 2
        if isDeb {return}
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterContentType: SettingView.difficults[diff],
        ])
        Analytics.logEvent("action_setting", parameters: ["difficult": 1])
    }
    
    static func reclear_quest(title: String){
        if isDeb {print(title);return}
        print("reclear_quest_"+title)
        //Analytics.logEvent("reclear_quest_"+title, parameters: nil)
        Analytics.logEvent("reclear_quest", parameters: ["reclear_quest_"+title: 1])
    }
    
    static func screen(name: String){
        if isDeb {print(name);return}
        Analytics.logEvent(AnalyticsEventScreenView,parameters: [
            AnalyticsParameterScreenName: name,
            //AnalyticsParameterScreenClass: ""
        ])
    }
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
            "earn_virtual_currency_value": value,
            "earn_virtual_currency_name": virtualCurrencyName//coin or diamond
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
    //    static func in_app_purchase(/*id:String,*/item:String,price:Int){
    //        if  isDeb {print("課金した\(item)ni\(price)支払った");return}
    //        Analytics.logEvent(AnalyticsEventPurchase, parameters: [
    //            AnalyticsParameterTransactionID: item,
    //            AnalyticsParameterItems: [
    //                //AnalyticsParameterItemName: nil,
    //                AnalyticsParameterPrice: price,
    //            ]
    //        ])
    //    }
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
