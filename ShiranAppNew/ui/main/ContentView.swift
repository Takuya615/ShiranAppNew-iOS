//
//  ContentView.swift
//  ShiranApp
//
//  Created by user on 2021/07/19.
//

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
            VideoCameraView(isVideo: $appState.isVideo)
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
        }else {
            ZStack{
                if self.appState.coachMarkf { CoachMarkView() }
                fragment
                //if dataCounter.countedDiamond == 0 { dia }
                fab
                
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
            /*SecondView()
             .tabItem {
             Image(systemName: "pencil")
             Text("活動記録")
             }*/
            QuestView()
                .tabItem {
                    Image(systemName: "line.horizontal.star.fill.line.horizontal")
                    Text(str.quest.rawValue)
                }
            
            CharacterView()
                .tabItem {
                    Image(systemName: "tortoise.fill")
                    Text(str.suketto.rawValue)
                }
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
    var fab: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action:{
                    EventAnalytics.tapFab()
                    self.appState.isVideo = true
                    self.appState.coachMark1 = true
                    UserDefaults.standard.set(true, forKey: "CoachMark1")
                }, label: {
                    Image(systemName: "flame")//"video.fill.badge.plus")
                        .foregroundColor(.white)
                        .font(.system(size: 40))
                })
                    .frame(width: 60, height: 60, alignment: .center)
                    .background(Color.orange)
                    .cornerRadius(30.0)
                    .shadow(color: .gray, radius: 3, x: 3, y: 3)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 60.0, trailing: 16.0))
                    .onAppear(perform: {
                        if self.appState.coachMark1 && !self.appState.coachMark3 {
                            dialogPresentation.show(content: .contentDetail1(isPresented: $dialogPresentation.isPresented))
                        }
                        if self.appState.coachMark3 && !self.appState.coachMark4{
                            dialogPresentation.show(content: .contentDetail2(isPresented: $dialogPresentation.isPresented))
                        }
                        
                        
                    })
                /*.fullScreenCover(isPresented: self.$isVideo, content: {
                 VideoCameraView2(isVideo: $isVideo)
                 })*/
            }.customDialog(presentaionManager: dialogPresentation)
        }
    }
    
}





/*
struct SecondView: View{
    @EnvironmentObject var appState: AppState
    struct Videos: Identifiable {
        var id = UUID()     // ユニークなIDを自動で設定¥
        var date: String
        var score: Int
    }
 @State var videos:[Videos] = []
 
 var body: some View {
 NavigationView{
 List{
 ForEach(videos){ video in
 HStack{
 Text(video.date)
 Spacer()
 Text("スコア\(video.score)")
 }
 }.onDelete(perform: delete)
 }
 .onAppear(perform: VideoList)
 .navigationTitle("活動記録")
 .navigationBarTitleDisplayMode(.inline)
 }.navigationViewStyle(StackNavigationViewStyle())
 }
 
 func VideoList() {
 
 videos = []//reset
 guard let listD = UserDefaults.standard.array(forKey: DataCounter().listD) as? [String] else {return}
 guard let listS = UserDefaults.standard.array(forKey: DataCounter().listS) as? [Int] else {return}
 
 for num in 0 ..< listS.count {
 videos.append(Videos(date: listD[num], score: listS[num]))
 }
 videos.reverse()
 }
 
 func delete(at offsets: IndexSet){
 videos.remove(atOffsets: offsets)
 
 var listD = UserDefaults.standard.array(forKey: DataCounter().listD) as! [String]
 var listS = UserDefaults.standard.array(forKey: DataCounter().listS) as! [Int]
 
 //let num = offsets.map({$0})
 listD.remove(atOffsets: offsets)
 listS.remove(atOffsets: offsets)
 
 UserDefaults.standard.setValue(listD, forKey: DataCounter().listD)
 UserDefaults.standard.setValue(listS, forKey: DataCounter().listS)
 
 }
 
 
 }*/





    
    /*
     var body: some View {
     NavigationView{
     List(skins){ video in
     HStack{
     Text(video.name)
     Spacer()
     Text("コイン\(video.coin)")
     if dataCounter.countedCoin >= video.coin {
     Button(action: {
     self.showAlert = true
     },
     label:{
     Text("購入")
     //Image("coin").resizable().frame(width: 100.0, height: 100.0, alignment: .leading)
     }).alert(isPresented: $showAlert) {
     Alert(title: Text("\(video.name)を購入しますか？"),
     //message: Text("詳細メッセージです"),
     primaryButton: .cancel(Text("キャンセル")),
     secondaryButton: .default(Text("購入する"), action: {
     UserDefaults.standard.set(video.skinNum, forKey: DataCounter().skin)
     self.isBought = true
     dataCounter.countedCoin -= video.coin
     UserDefaults.standard.set(dataCounter.countedCoin,forKey: dataCounter.coin)
     }))
     }
     
     }
     }
     
     }.alert(isPresented: $isBought, content: {
     Alert(title: Text("設定しました！"))
     })
     .onAppear(perform: {
     if !self.appState.coachOpenShop{
     dialogPresentation.show(content: .contentDetail5(isPresented: $dialogPresentation.isPresented))
     }
     })
     .navigationTitle("ショップ")
     .navigationBarTitleDisplayMode(.inline)
     .toolbar{
     ToolbarItem(placement: .navigationBarLeading){
     HStack{
     Image("coin").resizable().frame(width: 30.0, height: 30.0, alignment: .leading)
     Text(" \(self.dataCounter.countedCoin)")
     Image("diamonds").resizable().frame(width: 30.0, height: 30.0, alignment: .leading)
     Text(" \(self.dataCounter.countedDiamond)")
     }
     
     }
     }
     
     }.navigationViewStyle(StackNavigationViewStyle())
     .customDialog(presentaionManager: dialogPresentation)
     }
    
}*/
