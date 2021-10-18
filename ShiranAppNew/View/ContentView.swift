//
//  ContentView.swift
//  ShiranApp
//
//  Created by user on 2021/07/19.
//

import SwiftUI
import Firebase


struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var dataCounter: DataCounter
    @State var push = false
    @State var isVideo = false
    @State var showDiamondAlert = false
    let modifiedDate = Calendar.current.date(byAdding: .second, value: 30, to: Date())!
    
    var body: some View {
        Group{if self.isVideo {
            VideoCameraView(isVideo: $isVideo)
        }else if self.appState.isPrivacyPolicy{
            PrivacyPolicyView()
        }else if self.appState.isExplainView{
            ExplainAppView()
        //}else if self.appState.isLogin{
           // LoginView()
        }else {
                ZStack{
                    if !appState.coachMark1 {
                        CoachMarkView()
                    }else if !appState.coachMark3 {
                        CoachMarkView3()
                            .onDisappear(perform: {appState.coachMark3 = true})
                            
                    }
                    
                    fragment
                    fab
                    if dataCounter.countedDiamond == 0 { dia }
                }
            }
        }
    }
    var fragment:some View {
        TabView {
            FirstView()
             .tabItem {
                Image(systemName: "homekit")
                Text("ホーム")
              }
            SecondView()
                .tabItem {
                    Image(systemName: "pencil")
                    Text("活動記録")
                }
            ThirdView()
             .tabItem {
                 Image(systemName: "lightbulb.fill")
                 Text("スケット")
               }
        }
    }
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
                        message: Text("ダイヤ ×５０ をプレゼント！！\n＊このダイヤは今はまだゲーム内で使えません。"),
                        dismissButton: .default(Text("了解"),
                        action: {
                            dataCounter.countedDiamond = 50
                            UserDefaults.standard.set(50, forKey: dataCounter.diamond)
                        }))
                })
            }
        }
    }
    var fab: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                
                Button(action:{
                    self.isVideo = true
                    self.appState.coachMark1 = true
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
                /*.fullScreenCover(isPresented: self.$isVideo, content: {
                    VideoCameraView2(isVideo: $isVideo)
                })*/
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            //.environmentObject(AppState())
    }
}


struct FirstView: View{
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var dataCounter: DataCounter
    @State var isOpenSideMenu = false

    var body: some View {
        NavigationView{
            VStack{
                
                HStack{
                    VStack{
                        Text("リトライ数")
                            .font(.system(size: 20, weight: .black, design: .default))
                            .foregroundColor(.blue)
                        
                        Text(String(self.dataCounter.continuedRetryCounter))
                            .font(.system(size: 100, weight: .black, design: .default))
                            .frame(width: 130, height: 200, alignment: .center)
                            .foregroundColor(.blue)
                    }
                    VStack{
                        Text("継続日数")
                            .font(.system(size: 20, weight: .black, design: .default))
                            .foregroundColor(.blue)
                        Text(String(self.dataCounter.continuedDayCounter))
                            .font(.system(size: 100, weight: .black, design: .default))
                            .frame(width: 130, height: 200, alignment: .center)
                            .foregroundColor(.blue)
                    }
                }
                
                if self.appState.showWanWan {
                    Image("char_dog")
                        .resizable()
                        .frame(width: 80.0, height: 80.0, alignment: .leading)
                }
                
                
                
            }
            .onAppear(perform: {
                if Character().useTaskHelper() > 1.0 {
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
                            appState.isExplainView = true
                        }) {
                            Text("アプリ詳細")
                            Image(systemName: "info.circle")//"gearshape")歯車まーく
                            }
                        Button(action: {
                            appState.isPrivacyPolicy = true
                        }) {
                            Text("プライバシーポリシー")
                            Image(systemName: "shield")
                            }
                        
                        Button(action: {
                            guard let writeReviewURL = URL(string: "https://twitter.com/G0DhdLNn4SftTjc")
                                else { fatalError("Expected a valid URL") }
                                UIApplication.shared.open(writeReviewURL)
                        }) {
                            Text("ご意見（twitter）")
                            Image(systemName: "rectangle.and.pencil.and.ellipsis")
                            }
                        
                        Button(action: {
                            guard let writeReviewURL = URL(string: "https://apps.apple.com/us/app/%E3%81%97%E3%82%89%E3%82%93%E3%83%97%E3%83%AA/id1584268203")
                                else { fatalError("Expected a valid URL") }
                                UIApplication.shared.open(writeReviewURL)
                        }) {
                            Text("アプリを評価する")
                            Image(systemName: "rectangle.and.pencil.and.ellipsis")
                            }
                        
                        Button(action: {
                            let massage = "運動習慣化アプリ　しらんプリ"
                            //let image = postImage
                            let link = URL(string: "https://apps.apple.com/us/app/%E3%81%97%E3%82%89%E3%82%93%E3%83%97%E3%83%AA/id1584268203")!
                            let activityViewController = UIActivityViewController(activityItems: [massage,link], applicationActivities: nil)
                            let viewController = UIApplication.shared.windows.first?.rootViewController
                            viewController?.present(activityViewController, animated: true, completion: nil)
                            EventAnalytics().share()
                        }) {
                            Text("シェア")
                            Image(systemName: "paperplane.fill")
                            }
                        
                        
                        /*
                         @IBAction func share() {
                                 //share(上の段)から遷移した際にシェアするアイテム
                                 let activityItems: [Any] = [shareText, shareUrl]
                                 let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: [LINEActivity(message: shareText), TwitterActivity(message: shareText)])
                                 self.present(activityViewController, animated: true, completion: nil)
                             }
                         
                         
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
                    }label: {
                        Image(systemName: "line.horizontal.3")
                            .resizable()
                            .frame(width: 25, height: 15, alignment: .topLeading)
                    }
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 8, trailing: 10))
                }
                ToolbarItem(placement: .navigationBarLeading){
                    HStack{
                        Text("  Lv. \(self.dataCounter.countedLevel)  ")
                        Image("diamonds").resizable().frame(width: 30.0, height: 30.0, alignment: .leading)
                        Text(" \(self.dataCounter.countedDiamond)")
                    }
                    
                }
            }
            
            
        }.navigationViewStyle(StackNavigationViewStyle())
        
    }
}




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
    
    
}
    




struct ThirdView: View {
    
    
    @State var characters:[character] = Character().items()
    @State var itemTap: Bool = false
    @State var scoreUp: Bool = false
    @State var level: Int = UserDefaults.standard.integer(forKey: DataCounter().level)
    
    var body: some View {
        NavigationView{
            List(characters){ item in
                
                if level >= item.level {
                    Button(action: {
                        self.itemTap = true
                    }, label: {
                        HStack{
                            Image(item.image,bundle: .main)
                                .resizable()
                                .frame(width: 90.0, height: 90.0, alignment: .leading)
                            VStack(alignment: .center){
                                Text(item.name).font(.title)
                                //Text(item.scr)
                            }
                        }
                    }).sheet(isPresented: self.$itemTap){
                        actCharacterView(char: item)
                    }
                    
                    
                }else{
                    HStack{
                        Image(systemName: "questionmark.circle.fill")
                            .resizable()
                            .frame(width: 80.0, height: 80.0, alignment: .leading)
                        Text("レベル\(item.level)で解放").font(.title)
                    }
                }
                
            }
            .navigationTitle("スケット")
            .navigationBarTitleDisplayMode(.inline)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
