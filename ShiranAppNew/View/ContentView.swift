//
//  ContentView.swift
//  ShiranApp
//
//  Created by user on 2021/07/19.
//

import SwiftUI
import Firebase
import Instructions


struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var dataCounter: DataCounter
    @State var push = false
    @State var selection: Int = 0
    @State var showDiamondAlert = false
    //@State var showCoachMarkMnager = false
    //@State var showArrow = false
    //@State var showArrow2 = false
    @State var dialogPresentation = DialogPresentation()
    let modifiedDate = Calendar.current.date(byAdding: .second, value: 30, to: Date())!
    
    var body: some View {
        Group{if self.appState.isVideo {
            VideoCameraView(isVideo: $appState.isVideo)
        }else if self.appState.isPrivacyPolicy{
            PrivacyPolicyView()
        }else if self.appState.isExplainView{
            ExplainAppView()
        }else if self.appState.isLogin{
            LoginView()
        }else if self.appState.isVideoPlayer{
            VideoPlayerView()
        }else {
                ZStack{
                    if self.appState.coachMarkf { CoachMarkView() }
                    fragment
                    if dataCounter.countedDiamond == 0 { dia }
                    fab
                    
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
            fourthView()
             .tabItem {
                 Image(systemName: "lightbulb.fill")
                 Text("クエスト")
               }
             
            ThirdView()
            .tabItem {
                Image(systemName: "lightbulb.fill")
                Text("スケット")
            }
            fifthView()
            .tabItem {
                Image(systemName: "lightbulb.fill")
                Text("ショップ")
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
    }
    var fab: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action:{
                    EventAnalytics().tapFab()
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
                        
                        
                        Button(action: {
                            UserDefaults.standard.removeAll()
                            exit(0)
                        }) {
                            Text("リセット")
                            Image(systemName: "shield")
                            }
                        
                        Button(action: {
                            let LastTimeDay = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
                            UserDefaults.standard.set(LastTimeDay, forKey: self.dataCounter._LastTimeDay)
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
                        Text(UserDefaults.standard.string(forKey: DataCounter().myName) ?? "")
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
    
    @EnvironmentObject var appState: AppState
    @State var dialogPresentation = DialogPresentation()
    @State var characters:[character] = Character().items()
    @State var itemTap: Bool = false
    @State var scoreUp: Bool = false
    @State var level: Int = UserDefaults.standard.integer(forKey: DataCounter().level)
    @State var coach5: Bool = UserDefaults.standard.bool(forKey: "CoachMark5")
    
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
            /*.onAppear(perform: {
                if !self.appState.coachOpenChar{
                    dialogPresentation.show(content: .contentDetail3(isPresented: $dialogPresentation.isPresented))
                }
            })*/
            .navigationTitle("スケット")
            .navigationBarTitleDisplayMode(.inline)
            //if !coach5 { CoachMarkView(place: $place) }
        }.navigationViewStyle(StackNavigationViewStyle())
        //.customDialog(presentaionManager: dialogPresentation)
        
    }
}



//クエスト
struct fourthView: View{
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var dataCounter: DataCounter
    @State var dialogPresentation = DialogPresentation()
    @State var showAlert = false
    @State var qsl: [Int] = UserDefaults.standard.array(forKey: DataCounter().qsl) as? [Int] ?? [0,0,0,0,0]
    struct Quest: Identifiable {
        var id = UUID()     // ユニークなIDを自動で設定¥
        var number: Int
        var goal: [Int]
        var name: String
        var text: String
    }
    @State var quests:[Quest] = [
        Quest(number: 1,goal: [3,4,5],name: "コイン集め", text: "制限時間以内に、画面上のコインを５コ集める"),
        Quest(number: 2,goal: [100,300,400],name: "とにかく動け！", text: "制限時間以内に、スコア 500以上のはげしい運動をする"),
    
    ]
    
    var body: some View {
        NavigationView{
            List(quests){ item in
                //Text("挑戦!!").hidden()
                Button(action: {
                    self.showAlert = true
                }, label: {
                    HStack{
                        
                        /*if dataCounter.questStateList != nil {
                            if dataCounter.questStateList![item.number] == 1{
                                Text("挑戦中")
                            }else if dataCounter.questStateList![item.number] == 2 {
                                Text("クリア！")
                            }
                        }*/
                        VStack{
                            Text(item.name)
                            HStack{
                                //ForEach(1..<5) { i in Text("hello") }
                                //let stars: Int = qsl[item.number]
                                Spacer()
                                ForEach(1..<4) { i in
                                    if qsl[item.number] >= i {
                                        Image(systemName: "star.fill").resizable()
                                            .frame(width: 50.0, height: 50.0, alignment: .leading)
                                    }else{
                                        Image(systemName: "star").resizable()
                                            .frame(width: 50.0, height: 50.0, alignment: .leading)
                                    }
                                    Spacer()
                                }
                            }
                        }
                        
                    }
                    
                }).alert(isPresented: $showAlert) {
                    if item.number == 1 {
                        return Alert(title: Text("チャレンジしますか？"),
                                     message: Text(item.text),
                            primaryButton: .cancel(Text("キャンセル")),
                            secondaryButton: .default(Text("チャレンジ"), action: {
                            UserDefaults.standard.set(item.number, forKey: DataCounter().questNum)
                            UserDefaults.standard.set(item.goal, forKey: DataCounter().qGoal)
                            //UserDefaults.standard.set([0,1,0,0,0,0,0], forKey: DataCounter().qsl)
                            //dataCounter.questStateList = [0,1,0,0,0,0,0]
                            appState.isVideo = true
                            }))
                    }else if item.number == 2 {
                        return Alert(title: Text("チャレンジしますか？"),
                                     message: Text(item.text),
                            primaryButton: .cancel(Text("キャンセル")),
                            secondaryButton: .default(Text("チャレンジ"), action: {
                            UserDefaults.standard.set(item.number, forKey: DataCounter().questNum)
                            UserDefaults.standard.set(item.goal, forKey: DataCounter().qGoal)
                            //UserDefaults.standard.set([0,1,0,0,0,0,0], forKey: DataCounter().qsl)
                            //dataCounter.questStateList = [0,1,0,0,0,0,0]
                            appState.isVideo = true
                            }))
                    }else{
                        return Alert(title: Text("このクエストはまだ受けられません"),
                            dismissButton: .cancel(Text("キャンセル")))
                    }
                    
                    
                    
                }
            }
            /*.onAppear(perform: {
                if !self.appState.coachOpenQuest{
                    dialogPresentation.show(content: .contentDetail4(isPresented: $dialogPresentation.isPresented))
                }
            })*/
            .navigationTitle("クエスト")
            .navigationBarTitleDisplayMode(.inline)
        }.navigationViewStyle(StackNavigationViewStyle())
        //.customDialog(presentaionManager: dialogPresentation)
    }
    
    func countStars() -> Int {
        var num = 0
        for i in qsl { num += i }
        return num
    }
    
    func delete(at offsets: IndexSet){
        quests.remove(atOffsets: offsets)
        var listD = UserDefaults.standard.array(forKey: DataCounter().listD) as! [String]
        var listS = UserDefaults.standard.array(forKey: DataCounter().listS) as! [Int]
        //let num = offsets.map({$0})
        listD.remove(atOffsets: offsets)
        listS.remove(atOffsets: offsets)
        UserDefaults.standard.setValue(listD, forKey: DataCounter().listD)
        UserDefaults.standard.setValue(listS, forKey: DataCounter().listS)
    }
    
    
}

//ショップ
struct fifthView: View{
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var dataCounter: DataCounter
    @State var dialogPresentation = DialogPresentation()
    @State var coin = UserDefaults.standard.integer(forKey: DataCounter().coin)
    @State var showAlert = false
    @State var isBought = false
    struct Skin: Identifiable {
        var id = UUID()     // ユニークなIDを自動で設定
        var name: String
        var coin: Int
        var skinNum: Int
    }
    @State var skins:[Skin] = [
        Skin(name: "カラーあか", coin: 100, skinNum: 001),
        Skin(name: "カラーあお", coin: 150, skinNum: 002),
        Skin(name: "カラーくろ", coin: 150, skinNum: 003),
        Skin(name: "カラーみどり", coin: 150, skinNum: 004),
        Skin(name: "衣装１", coin: 500, skinNum: 005),
        Skin(name: "衣装２", coin: 1000, skinNum: 006),
        Skin(name: "衣装３", coin: 1500, skinNum: 007),
    ]
    
    var body: some View {
        NavigationView{
            VStack{
                Text("開店準備中")
            }
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
        }
    }
    
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
    }*/
    
}
