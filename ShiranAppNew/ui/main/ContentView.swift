
import SwiftUI
import Firebase
import Instructions
import MessageUI


struct ContentView: View {
    @EnvironmentObject var appState: AppState
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
            //AppPurchaseView()
        }else {
            ZStack{
                if self.appState.coachMarkf { CoachMarkView() }
                fragment
            }
        }}
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
}
