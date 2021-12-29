//
//  ShiranAppNewApp.swift
//  ShiranAppNew
//
//  Created by user on 2021/09/03.
//

import SwiftUI
import Firebase

@main
struct ShiranAppNewApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AppState())
                .environmentObject(DataCounter())
        }
    }
}


class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        return true
    }

}



class AppState: ObservableObject {
    @Published var isVideo = false
    @Published var isQuest = false
    @Published var isLogin = false
    @Published var isNamed = false
    @Published var isinAccount = false
    @Published var isLoading = false
    @Published var errorStr = ""
    @Published var isPrivacyPolicy = false
    @Published var isExplainView = false
    @Published var isVideoPlayer = false
    @Published var isPlayerView = false
    @Published var isSettingView = false
    
    @Published var coachMark1: Bool = UserDefaults.standard.bool(forKey: "CoachMark1")//Save on CoachMarks-37
    @Published var coachMark2: Bool = UserDefaults.standard.bool(forKey: "CoachMark2")//Save on ViewController -82
    @Published var coachMark3: Bool = UserDefaults.standard.bool(forKey: "CoachMark3")
    @Published var coachMark4: Bool = UserDefaults.standard.bool(forKey: "CoachMark4")
    @Published var coachOpenQuest: Bool = UserDefaults.standard.bool(forKey: "OpenQuest")
    @Published var coachOpenChar: Bool = UserDefaults.standard.bool(forKey: "OpenChar")
    @Published var coachOpenShop: Bool = UserDefaults.standard.bool(forKey: "OpenShop")
    @Published var coachMarkf: Bool = UserDefaults.standard.bool(forKey: "CoachMarkf")
    
    @Published var showWanWan: Bool = false
    @Published var getDiamond: Bool = UserDefaults.standard.bool(forKey: "getDiamonds")
    init() {
        if !coachMark1 { isVideoPlayer = true }//{isExplainView = true}
        if Auth.auth().currentUser != nil {
            self.isinAccount = true//trueなら　アカウント設定 　false　ならログアウトボタンに切り替わる
            //self.isLogin = true
        }
        //UserDefaults.standard.set(10, forKey: "Level")
    }
    
    func signup(email:String, password:String){//email:String,password:String
        Auth.auth().createUser(withEmail: email, password: password) { [weak self]authResult, error in
            guard self != nil else {
                self?.isLoading = false
                return
            }
            print("登録メアドは\(email)")
            print("登録パスワードは\(password)")
            if authResult != nil && error == nil{
                self?.isLoading = false
                self?.errorStr = ""
                self?.isNamed = true
                self?.isinAccount = true
                //self?.saveDetails()
            }else{
                //self?.isLogin = false
                self?.isLoading = false
                self?.errorStr = "アカウント作成に失敗しました"
            }
        }
        
    }
    
    
    func loginMethod(email:String, password:String){
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard self != nil else {
                self?.isLoading = false
                return
            }
            print("ログインメルアドは\(email)")
            print("ログインパスワードは\(password)")
            if error == nil{
                //self?.isLoading = false
                self?.errorStr = ""
                self?.isinAccount = true
                self?.existName()
            }else{
                //self?.isLogin = false
                self?.isLoading = false
                self?.errorStr = "ログインに失敗しました"
            }
            //self?.appState.isLogin = true
        }
    }
    
    func logout(){
        do {
          try Auth.auth().signOut()
            print("ログアウトしました")
            self.isinAccount = false
            //self.isLogin = true
        } catch let signOutError as NSError {
            self.isinAccount = true
          print ("ログアウトできてませんError signing out: %@", signOutError)
          //UserDefaults.standard.set({true}, forKey:"login")
        }
    }
    
    func saveDetails(name: String){
        //guard let myName = UserDefaults.standard.string(forKey: DataCounter().myName) else {return}
        let id = Auth.auth().currentUser!.uid
        let db = Firestore.firestore().collection("users").document(name)
        db.setData([
            "id": id,
            "name": name,
            "friends": [],
            "poseList": []
        ]) { err in
            if let err = err {
                print("エラー　Error adding document: \(err)")
                self.isLoading = false
                self.errorStr = "不明なエラー\n通信環境の良いところで、もう１度お試しください"
            } else {
                print("ディティールの保存成功！！")
                self.isLoading = false
                self.errorStr = ""
                UserDefaults.standard.set(name, forKey: Keys.myName.rawValue)
                self.isLogin = false
                self.isNamed = false
            }
        }
    }
    
    func existName(){
        let id = Auth.auth().currentUser!.uid
        let db = Firestore.firestore().collection("users").whereField("id", isEqualTo: id)
        db.getDocuments() { (querySnapshot, err) in
            if querySnapshot!.documents.isEmpty {//そもそもまだデータ登録されていない場合、NameSettingViewへ
                self.isNamed = true
                self.isLoading = false
            }else{//                                nameを設定し直してメインへ
                let name: String = querySnapshot!.documents[0].data()["name"] as! String
                print("documentは\(name)")
                UserDefaults.standard.set(name, forKey: Keys.myName.rawValue)
                self.isLogin = false
                self.isLoading = false
            }
        }
    }
    
    func reset(){
        //let db = Firestore.firestore()
        //guard let myName = UserDefaults.standard.string(forKey: DataCounter().myName) else {return}
        /*db.collection("users").document(myName).delete() { err in
            if let err = err {
                print("さくじょ　Error removing document: \(err)")
            } else {
                
                print("さくじょ　Document successfully removed!")
            }
        }*/
    }
}

extension UserDefaults {
    func removeAll() {
        dictionaryRepresentation().forEach{ removeObject(forKey: $0.key) }
    }
}
