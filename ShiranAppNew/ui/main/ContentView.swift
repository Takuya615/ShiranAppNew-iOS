
import SwiftUI
import Firebase
import Instructions
import MessageUI


struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var dataCounter: DataCounter
    @State var push = false
    @State var selection: Int = 0
    @State var showDiamondAlert = false
    @State var dialogPresentation = DialogPresentation()
    let modifiedDate = Calendar.current.date(byAdding: .second, value: 30, to: Date())!
    
    var body: some View {
        Group{if self.appState.isVideo {
            if DataCounter.setDailyState() == 0{
                DefaultCameraView(isVideo: $appState.isVideo)
            }else{
                VideoCameraView(isVideo: $appState.isVideo)
            }
        }else if self.appState.isQuest{
            QuestCameraView(isVideo: $appState.isQuest)
        }else if self.appState.isPrivacyPolicy{
            PrivacyPolicyView()
        }else if self.appState.isExplainView{
            ExplainAppView()
        }else if self.appState.isLogin{
            LoginView()
        }else if self.appState.isVideoPlayer{
            VideoPlayerView()
        }else if self.appState.isSettingView{
            SettingView()
        }else if self.appState.isOpinionView{
            UserOpinionView()
        }else if self.appState.isItemSelectView{
            ItemSelectView()
        }else if self.appState.isPurchaseView{
            AppPurchaseView()
        }else {
            ZStack{
                if self.appState.coachMarkf { CoachMarkView() }
                
                fragment
                //if dataCounter.countedDiamond == 0 { dia }
            }
        }
        }
    }
    var fragment:some View {
        TabView {
            
            HomeView()
                .tabItem {
                    Image(systemName: "homekit")
                    Text(str.home.rawValue)
            }
            QuestView()
                .tabItem {
                    Image(systemName: "line.horizontal.star.fill.line.horizontal")
                    Text(str.quest.rawValue)
                }
            
//            CharacterView()
//                .tabItem {
//                    Image(systemName: "tortoise.fill")
//                    Text(str.suketto.rawValue)
//                }
            ShopView()
                .tabItem {
                    Image(systemName: "bag.fill")
                    Text(str.shop.rawValue)
                }
            
        }
    }
    /*
     var dia: some View {
     VStack {
     Spacer()
     HStack {
     Spacer()
     Button(action:{
     showDiamondAlert = true
     }, label: {
     Image("diamonds").resizable().frame(width: 100.0, height: 100.0, alignment: .leading)
     })
     .frame(width: 60, height: 60, alignment: .center)
     //.background(Color.blue)
     .cornerRadius(30.0)
     .shadow(color: .gray, radius: 3, x: 3, y: 3)
     .padding(EdgeInsets(top: 0, leading: 0, bottom: 150.0, trailing: 16.0))
     .alert(isPresented: $showDiamondAlert, content: {
     Alert(title: Text("インストール\nありがとうございます!"),
     message: Text("コイン　×100　とダイヤ ×５０ をプレゼント！！\n＊このダイヤは今はまだゲーム内で使えません。"),
     dismissButton: .default(Text("了解"),
     action: {
     dataCounter.countedDiamond = 50
     UserDefaults.standard.set(50, forKey: dataCounter.diamond)
     dataCounter.countedCoin = 100
     UserDefaults.standard.set(100, forKey: DataCounter().coin)
     }))
     })
     }
     }
     }*/
    
}
