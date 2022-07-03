
import Firebase
import FirebaseRemoteConfig
import Foundation

//build in ShiranApp.init
struct Config{
    static func setRemoteConfig(){
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        if EventAnalytics.isDebag {
            settings.minimumFetchInterval = 0
            Config.testDevice()
        }
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "remote_config_defaults")
        remoteConfig.fetchAndActivate(completionHandler:{ status, error in
            if status == .successFetchedFromRemote || status == .successUsingPreFetchedData{
                //                print("リモート取得　\(remoteConfig.configValue(forKey:Keys.rcLevel.rawValue).numberValue)")
                //                print(remoteConfig.configValue(forKey:Keys.rcAddTT.rawValue).numberValue)
                //                print(remoteConfig.configValue(forKey:Keys.rcCoinRate.rawValue).numberValue)
                //                print(remoteConfig.configValue(forKey:Keys.rcQGoal.rawValue).numberValue)
                //                print(remoteConfig.configValue(forKey:Keys.rcQTime.rawValue).numberValue)
                //                print(remoteConfig.configValue(forKey:Keys.rcQReHeart.rawValue).numberValue)
                //                print(remoteConfig.configValue(forKey:Keys.exist_quest.rawValue).boolValue)
                //                print(remoteConfig.configValue(forKey:Keys.exist_interval_heart.rawValue).boolValue)
                
                UserDefaults.standard.set(remoteConfig.configValue(forKey:Keys.rcLevel.rawValue).numberValue,forKey: Keys.rcLevel.rawValue)
                UserDefaults.standard.set(remoteConfig.configValue(forKey:Keys.rcAddTT.rawValue).numberValue,forKey: Keys.rcAddTT.rawValue)
                UserDefaults.standard.set(remoteConfig.configValue(forKey:Keys.rcCoinRate.rawValue).numberValue,forKey: Keys.rcCoinRate.rawValue)
                UserDefaults.standard.set(remoteConfig.configValue(forKey:Keys.rcQGoal.rawValue).numberValue,forKey: Keys.rcQGoal.rawValue)
                UserDefaults.standard.set(remoteConfig.configValue(forKey:Keys.rcQTime.rawValue).numberValue,forKey: Keys.rcQTime.rawValue)
                UserDefaults.standard.set(remoteConfig.configValue(forKey:Keys.rcQReHeart.rawValue).numberValue,forKey: Keys.rcQReHeart.rawValue)//int
                UserDefaults.standard.set(remoteConfig.configValue(forKey:Keys.exist_quest.rawValue).boolValue,forKey: Keys.exist_quest.rawValue)//bool
                UserDefaults.standard.set(remoteConfig.configValue(forKey:Keys.exist_interval_heart.rawValue).boolValue,forKey: Keys.exist_interval_heart.rawValue)//bool
            }
        })
    }
    
    //ABテスト登録用のトークンID取得メソッド
    static func testDevice(){
        Installations.installations().authTokenForcingRefresh(true, completion: { (result, error) in
            if let error = error {
                print("Error fetching token: \(error)")
                return
            }
            guard let result = result else { return }
            print("Installation auth token: \(result.authToken)")
        })
    }
    
    static func reQuest(quest q :Quest) -> Quest{
        let rcQGoal: Float = UserDefaults.standard.float(forKey: Keys.rcQGoal.rawValue)
        let rcQTime: Float = UserDefaults.standard.float(forKey: Keys.rcQTime.rawValue)
        let time = Int(Float(q.time)*rcQTime)
        var goal:[Int] = []
        for i in q.goal {
            goal.append(Int(Float(i)*rcQGoal))
        }
        return Quest(number: q.number, type: q.type, goal: goal, time: time,title:q.title,name: q.name, text: q.text)
    }
    
}
