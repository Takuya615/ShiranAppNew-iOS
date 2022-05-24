
import Firebase
import FirebaseRemoteConfig

//build in ShiranApp.init
struct ABRemoteConfig{
    static func setRemoteConfig(){
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        if EventAnalytics.isDebag {
            settings.minimumFetchInterval = 0
            ABRemoteConfig.testTestDevice()
        }
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "remote_config_defaults")
        remoteConfig.fetchAndActivate(completionHandler:{ status, error in
            if status == .successFetchedFromRemote || status == .successUsingPreFetchedData{
                print("リモート取得　\(remoteConfig.configValue(forKey: "ExtraStages").numberValue)")
                
            }else{
                print("エラー \(String(describing: error))")
            }
            
        })
    }
    
    //ABテスト登録用のトークンID取得メソッド
    static func testTestDevice(){
        Installations.installations().authTokenForcingRefresh(true, completion: { (result, error) in
            if let error = error {
                print("Error fetching token: \(error)")
                return
            }
            guard let result = result else { return }
            print("Installation auth token: \(result.authToken)")
        })
    }
}
