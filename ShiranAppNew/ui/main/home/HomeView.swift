//
//  HomeView.swift
//  ShiranAppNew
//
//  Created by user on 2022/02/19.
//

import SwiftUI

struct HomeView: View{
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var dataCounter: DataCounter
    @State var isOpenSideMenu = false
    
    var body: some View {
        NavigationView{
            VStack{
//                HStack{
//                    VStack{
//                        Text(str.count_retry.rawValue)
//                            .font(.system(size: 20, weight: .black, design: .default))
//                            .foregroundColor(.blue)
//
//                        Text(String(self.dataCounter.continuedRetryCounter))
//                            .font(.system(size: 100, weight: .black, design: .default))
//                            .frame(width: 170, height: 200, alignment: .center)
//                            .foregroundColor(.blue)
//                    }
//                    VStack{
//                        Text(str.count_continue.rawValue)
//                            .font(.system(size: 20, weight: .black, design: .default))
//                            .foregroundColor(.blue)
//                        Text(String(self.dataCounter.continuedDayCounter))
//                            .font(.system(size: 100, weight: .black, design: .default))
//                            .frame(width: 170, height: 200, alignment: .center)
//                            .foregroundColor(.blue)
//                    }
//                }
                StatasView()
                 
                if self.appState.showWanWan {
                    Image("char_dog")
                        .resizable()
                        .frame(width: 80.0, height: 80.0, alignment: .leading)
                }
                
                
            }
            .onAppear(perform: {
                self.dataCounter.countedLevel = UserDefaults.standard.integer(forKey: Keys.level.rawValue)//データ更新
                self.dataCounter.continuedDayCounter = UserDefaults.standard.integer(forKey: Keys.continuedDay.rawValue)
                self.dataCounter.continuedRetryCounter = UserDefaults.standard.integer(forKey: Keys.retry.rawValue)
                if CharacterModel.useTaskHelper() > 1.0 {
                    self.appState.showWanWan = true
                }else{
                    self.appState.showWanWan = false
                }
            })
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Menu{
                        Button(action: {
                            appState.isSettingView = true
                        }) {
                            Text(str.set.rawValue)
                            Image(systemName: "gear")//"gearshape")歯車まーく
                        }
                        Button(action: {
                            appState.isExplainView = true
                        }) {
                            Text(str.detailApp.rawValue)
                            Image(systemName: "info.circle")//"gearshape")歯車まーく
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
                        /*
                         Button(action: {
                         guard let writeReviewURL = URL(string: "https://apps.apple.com/us/app/%E3%81%97%E3%82%89%E3%82%93%E3%83%97%E3%83%AA/id1584268203")
                         else { fatalError("Expected a valid URL") }
                         UIApplication.shared.open(writeReviewURL)
                         }) {
                         Text("アプリを評価する")
                         Image(systemName: "rectangle.and.pencil.and.ellipsis")
                         }*/
                        
                        
                         Button(action: {
                         UserDefaults.standard.removeAll()
                         exit(0)
                         }) {
                         Text("リセット")
                         Image(systemName: "shield")
                         }
                         
                         Button(action: {
                         let LastTimeDay = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
                         UserDefaults.standard.set(LastTimeDay, forKey: Keys._LastTimeDay.rawValue)
                         }) {
                         Text("１日リセット")
                         Image(systemName: "shield")
                         }
                         
                        /*
                         @IBAction func share() {
                         //share(上の段)から遷移した際にシェアするアイテム
                         let activityItems: [Any] = [shareText, shareUrl]
                         let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: [LINEActivity(message: shareText), TwitterActivity(message: shareText)])
                         self.present(activityViewController, animated: true, completion: nil)
                         }
                         */
                    }label: {
                        Image(systemName: "line.horizontal.3")
                            .resizable()
                            .frame(width: 25, height: 15, alignment: .topLeading)
                    }
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 8, trailing: 10))
                }
                ToolbarItem(placement: .navigationBarLeading){
                    HStack{
                        Text(UserDefaults.standard.string(forKey: Keys.myName.rawValue) ?? "")
                        Text("  Lv. \(self.dataCounter.countedLevel)  ")
                        Image("coin").resizable().frame(width: 30.0, height: 30.0, alignment: .leading)
                        Text(" \(self.dataCounter.countedCoin)")
                        Image("diamonds").resizable().frame(width: 30.0, height: 30.0, alignment: .leading)
                        Text(" \(self.dataCounter.countedDiamond)")
                    }
                    
                }
            }
            
            
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
}


struct StatasView: View {
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 100, y: 0))
            path.addLine(to: CGPoint(x: 200, y: 200))
            path.addLine(to: CGPoint(x: 0, y: 200))
            path.addLine(to: CGPoint(x: 100, y: 0))
        }
        .stroke(lineWidth: 20)
        .fill(Color.red)
        .frame(width: 200, height: 200)
    }
}
 
