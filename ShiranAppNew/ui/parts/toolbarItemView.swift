
import SwiftUI
struct toolbarItemView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        Menu{
            Button(action: {
                appState.isSettingView = true
            }) {
                Text(str.set.rawValue)
                Image(systemName: "gear")//"gearshape")
            }
            Button(action: {
                appState.isExplainView = true
            }) {
                Text(str.detailApp.rawValue)
                Image(systemName: "info.circle")//"gearshape")
            }
            /*
             if self.appState.isinAccount {
             Button(action: {
             appState.logout()
             }) {
             Text("ログアウト")
             Image(systemName: "person")
             }
             }else{
             Button(action: {
             appState.isLogin = true
             }) {
             Text("アカウント設定")
             Image(systemName: "person")
             }
             }*/
            Button(action: {
                appState.isPrivacyPolicy = true
            }) {
                Text(str.privacy_policy.rawValue)
                Image(systemName: "shield")
            }
            Button(action: {
                guard let writeReviewURL = URL(string: "https://twitter.com/G0DhdLNn4SftTjc")
                else { fatalError("Expected a valid URL") }
                UIApplication.shared.open(writeReviewURL)
            }) {
                Text(str.twitter.rawValue)
                Image(systemName: "rectangle.and.pencil.and.ellipsis")
            }
            Button(action: {
                appState.isOpinionView = true
            }) {
                Text(str.opinion.rawValue)
                Image(systemName: "rectangle.and.pencil.and.ellipsis")
            }
            
            if EventAnalytics.isDebag {
                Button(action: {
                    UserDefaults.standard.removeAll()
                    exit(0)
                }) {
                    Text(str.reset.rawValue)
                    Image(systemName: "shield")
                }
                Button(action: {
                    let LastTimeDay = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
                    UserDefaults.standard.set(LastTimeDay, forKey: Keys._LastTimeDay.rawValue)
                }) {
                    Text(str.oneDayReset.rawValue)
                    Image(systemName: "shield")
                }
                Button(action: {
                    UserDefaults.standard.set(1000, forKey: Keys.diamond.rawValue)
                    UserDefaults.standard.set(10000, forKey: Keys.coin.rawValue)
                    UserDefaults.standard.set([3,3, 3,3,3, 0,0,0,0, 0,0,0,0], forKey: Keys.qsl.rawValue)
                }) {
                    Text(str.cheat.rawValue)
                    Image(systemName: "shield")
                }
            }
            
        }label: {
            Image(systemName: "line.horizontal.3")
                .resizable()
                .frame(width: 25, height: 15, alignment: .topLeading)
        }
        .padding(EdgeInsets(top: 20, leading: 0, bottom: 8, trailing: 10))
    }
}
