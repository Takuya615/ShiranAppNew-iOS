
import SwiftUI
import Firebase
import StoreKit
import SwiftyStoreKit
import Foundation

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
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    break
                }
            }
        }
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
    @Published var isOpinionView = false
    @Published var isItemSelectView = false
    @Published var isPurchaseView = false
    
    @Published var coachMark1: Bool = UserDefaults.standard.bool(forKey: Keys.CoachMark1.rawValue)//Save on CoachMarks-37
    @Published var coachMark2: Bool = UserDefaults.standard.bool(forKey: Keys.CoachMark2.rawValue)//Save on ViewController -82
    @Published var coachMark3: Bool = UserDefaults.standard.bool(forKey: Keys.CoachMark3.rawValue)
    @Published var coachMark4: Bool = UserDefaults.standard.bool(forKey: Keys.CoachMark4.rawValue)
    @Published var coachOpenQuest: Bool = UserDefaults.standard.bool(forKey: Keys.OpenQuest.rawValue)
    @Published var coachOpenChar: Bool = UserDefaults.standard.bool(forKey: Keys.OpenChar.rawValue)
    @Published var coachOpenShop: Bool = UserDefaults.standard.bool(forKey: Keys.OpenShop.rawValue)
    @Published var coachMarkf: Bool = UserDefaults.standard.bool(forKey: Keys.CoachMarkf.rawValue)
    @Published var showWanWan: Bool = false
    //@Published var getDiamond: Bool = UserDefaults.standard.bool(forKey: Keys.firstUseBounus.rawValue)
    init() {
        Config.setRemoteConfig()
        if !coachMark1 {
            isVideoPlayer = true
            UserDefaults.standard.register(defaults: [Keys.level.rawValue: 1])
            UserDefaults.standard.register(defaults: [Keys.difficult.rawValue: 1])
        }
        if Auth.auth().currentUser != nil {
            self.isinAccount = true//true?????????????????????????????? ???false???????????????????????????????????????????????????
            //self.isLogin = true
        }
    }
    
    func signup(email:String, password:String){//email:String,password:String
        Auth.auth().createUser(withEmail: email, password: password) { [weak self]authResult, error in
            guard self != nil else {
                self?.isLoading = false
                return
            }
            if authResult != nil && error == nil{
                self?.isLoading = false
                self?.errorStr = ""
                self?.isNamed = true
                self?.isinAccount = true
                //self?.saveDetails()
            }else{
                //self?.isLogin = false
                self?.isLoading = false
                self?.errorStr = "??????????????????????????????????????????"
            }
        }
        
    }
    
    
    func loginMethod(email:String, password:String){
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard self != nil else {
                self?.isLoading = false
                return
            }
            if error == nil{
                //self?.isLoading = false
                self?.errorStr = ""
                self?.isinAccount = true
                self?.existName()
            }else{
                //self?.isLogin = false
                self?.isLoading = false
                self?.errorStr = "?????????????????????????????????"
            }
            //self?.appState.isLogin = true
        }
    }
    
    func logout(){
        do {
            try Auth.auth().signOut()
            print("???????????????????????????")
            self.isinAccount = false
            //self.isLogin = true
        } catch let signOutError as NSError {
            self.isinAccount = true
            print ("?????????????????????????????????Error signing out: %@", signOutError)
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
                print("????????????Error adding document: \(err)")
                self.isLoading = false
                self.errorStr = "??????????????????\n?????????????????????????????????????????????????????????????????????"
            } else {
                print("???????????????????????????????????????")
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
            if querySnapshot!.documents.isEmpty {//????????????????????????????????????????????????????????????NameSettingView???
                self.isNamed = true
                self.isLoading = false
            }else{//                                name?????????????????????????????????
                let name: String = querySnapshot!.documents[0].data()["name"] as! String
                print("document???\(name)")
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
         print("???????????????Error removing document: \(err)")
         } else {
         
         print("???????????????Document successfully removed!")
         }
         }*/
    }
}

extension UserDefaults {
    func removeAll() {
        dictionaryRepresentation().forEach{ removeObject(forKey: $0.key) }
    }
}
