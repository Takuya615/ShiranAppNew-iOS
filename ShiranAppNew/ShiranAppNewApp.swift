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
        //EditByOpenCV().register(url: nil)//バックグラウンドの準備！
        
        return true
    }

}



class AppState: ObservableObject {
    //@Published var isLogin = false
    @Published var isLoading = false
    @Published var errorStr = ""
    //@Published var isinAccount = false
    @Published var isPrivacyPolicy = false
    @Published var isExplainView = false
    @Published var isVideoPlayer = false
    @Published var isPlayerView = false
    @Published var coachMark1: Bool = UserDefaults.standard.bool(forKey: "CoachMark1")//Save on CoachMarks-37
    @Published var coachMark2: Bool = UserDefaults.standard.bool(forKey: "CoachMark2")//Save on ViewController2 -82
    @Published var showWanWan: Bool = false
    init() {
        if !coachMark1 {isExplainView = true}
        //UserDefaults.standard.set(10, forKey: "Level")
    }
    
    
    /*
    init() {
        //FirebaseApp.configure()//FireBaseの初期化
        if Auth.auth().currentUser != nil {
            self.isinAccount = true
            //self.isLogin = true
        }
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
                self?.isLogin = false
                self?.isLoading = false
                self?.errorStr = ""
                self?.isinAccount = true
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
                self?.isLogin = false
                self?.isLoading = false
                self?.errorStr = ""
                self?.isinAccount = true
                
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
    }*/
    
}
