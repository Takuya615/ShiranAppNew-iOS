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
                    //if dataCounter.countedDiamond == 0 { dia }
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
            /*SecondView()
                .tabItem {
                    Image(systemName: "pencil")
                    Text("活動記録")
                }*/
            fourthView()
             .tabItem {
                 Image(systemName: "line.horizontal.star.fill.line.horizontal")
                 Text("クエスト")
               }
             
            ThirdView()
            .tabItem {
                Image(systemName: "tortoise.fill")
                Text("スケット")
            }
            fifthView()
            .tabItem {
                Image(systemName: "bag.fill")
                Text("ショップ")
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
                self.dataCounter.countedLevel = UserDefaults.standard.integer(forKey: "Level")//データ更新
                if CharacterModel().useTaskHelper() > 1.0 {
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
                        
                        /*      　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　でバック用ボタン
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
                        */
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
    


//キャラクター
struct ThirdView: View {
    
    @ObservedObject var cM = CharacterModel()
    //@EnvironmentObject var appState: AppState
    //@State var dialogPresentation = DialogPresentation()
    //@State var characters:[character] = Character().items()
    //@State var itemTap: Bool = false
    //@State var scoreUp: Bool = false
    @State var level: Int = UserDefaults.standard.integer(forKey: DataCounter().level)
    //@State var coach5: Bool = UserDefaults.standard.bool(forKey: "CoachMark5")
    
    var body: some View {
        NavigationView{
            List(cM.characters){ item in
                
                if level >= item.level {
                    Button(action: {
                        self.cM.itemOpen = true
                        //self.itemTap = true
                    }, label: {
                        HStack{
                            Image(item.image,bundle: .main)
                                .resizable()
                                .frame(width: 90.0, height: 90.0, alignment: .leading)
                            VStack(alignment: .center){
                                Text(item.name).font(.title)
                            }
                        }
                    }).sheet(isPresented: self.$cM.itemOpen){
                        actCharacterView(char: item, cM: self.cM)
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
    @State var qsl: [Int] = UserDefaults.standard.array(forKey: DataCounter().qsl) as? [Int] ?? [0,0,0]
    @State var updated_stage: Int = UserDefaults.standard.integer(forKey: "updatedStage")
    @State var stage :Int = 1//星の数で開けるステージを限定
    @State var stageOnNow :Int = 1//今どこのステージにいるのか
    @State var neededStar: Int = 0//残りの星の必要な数
    @State var onVideo: Bool = false
    struct Quest: Identifiable {
        var id = UUID()     // ユニークなIDを自動で設定¥
        var number: Int
        var type: Int
        var goal: [Int]
        var name: String
        var text: String
    }
    @State var quests:[Quest] = [
        Quest(number: 1,type: 1,goal: [2,4,5],name: "コイン集め", text: "制限時間以内に、画面上のコインを5コ集める"),
        Quest(number: 2,type: 2,goal: [100,230,350],name: "とにかく動け！", text: "制限時間以内に、スコア 350以上のはげしい運動をする"),
        
        Quest(number: 3,type: 1,goal: [3,5,6],name: "コイン集め", text: "制限時間以内に、画面上のコインを6コ集める"),
        Quest(number: 4,type: 2,goal: [200,300,400],name: "とにかく動け！", text: "制限時間以内に、スコア 400以上のはげしい運動をする"),
        Quest(number: 5,type: 3,goal: [60,100,140],name: "ボルダリング", text: "制限時間以内に、140m　登りきる"),
        
        Quest(number: 6,type: 1,goal: [5,7,8],name: "コイン集め", text: "制限時間以内に、画面上のコインを8コ集める"),
        Quest(number: 7,type: 2,goal: [340,400,450],name: "とにかく動け！", text: "制限時間以内に、スコア 450以上のはげしい運動をする"),
        Quest(number: 8,type: 3,goal: [100,170,200],name: "ボルダリング", text: "制限時間以内に、200m　登りきる"),
        
        Quest(number: 9,type: 1,goal: [7,9,11],name: "コイン集め", text: "制限時間以内に、画面上のコインを11コ集める"),
        Quest(number: 10,type: 2,goal: [400,500,550],name: "とにかく動け！", text: "制限時間以内に、スコア 550以上のはげしい運動をする"),
        Quest(number: 11,type: 3,goal: [150,200,250],name: "ボルダリング", text: "制限時間以内に、250m　登りきる"),
        //Quest(number: 12,type: 4,goal: [8,15,25],name: "スケート", text: "制限時間以内に、25m　滑りきる"),
    ]
    func showQuests() -> [Quest]{
        switch stageOnNow {
        case 2: return [quests[2],quests[3],quests[4]]
        case 3: return [quests[5],quests[6],quests[7]]
        case 4: return [quests[8],quests[9],quests[10]]
        default : return [quests[0],quests[1]]
        }
    }
    
    var body: some View {
        NavigationView{
            if stage+1 == stageOnNow {
                Text("あと⭐️\(neededStar)コでステージ解放")
                .navigationTitle("ステージ\(stageOnNow)")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading){
                        Button(action: {
                            stageOnNow -= 1
                        }) { Image(systemName: "arrowtriangle.left.fill") }
                    }
                }
            }
            
            
            List(showQuests()){ item in
                VStack{
                    HStack{
                        Text(item.name)
                        switch item.number {
                        case 1: Text("▶️").onTapGesture(perform: {onVideo.toggle()}).sheet(isPresented: $onVideo, content: {PlayerViewCoin()})
                        case 5: Text("▶️").onTapGesture(perform: {onVideo.toggle()}).sheet(isPresented: $onVideo, content: {PlayerViewClimb()})
                        default: Text("")
                        }
                    }
                    
                    Button(action: {
                        self.showAlert = true
                    }, label: {
                        HStack{
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
                    }).alert(isPresented: $showAlert) {
                        return Alert(title: Text("チャレンジしますか？"),
                                     message: Text(item.text),
                            primaryButton: .cancel(Text("キャンセル")),
                            secondaryButton: .default(Text("チャレンジ"), action: {
                            UserDefaults.standard.set(item.number, forKey: DataCounter().questNum)
                            UserDefaults.standard.set(item.type,forKey: DataCounter().questType)
                            UserDefaults.standard.set(item.goal, forKey: DataCounter().qGoal)
                            appState.isVideo = true
                            EventAnalytics().doneQuest()
                            }))
                        
                    }
                    
                    
                }
                
            }
            .onAppear(perform: {
                setStage()
                //if !self.appState.coachOpenQuest{dialogPresentation.show(content: .contentDetail4(isPresented: $dialogPresentation.isPresented))}
            })
            .navigationTitle("ステージ\(stageOnNow)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    if stageOnNow > 1 {
                        Button(action: {
                            stageOnNow -= 1
                        }) { Image(systemName: "arrowtriangle.left.fill") }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    if stageOnNow < stage+1 {
                        Button(action: {
                            stageOnNow += 1
                        }) { Image(systemName: "arrowtriangle.right.fill") }
                    }
                    
                }
            }
            
        }.navigationViewStyle(StackNavigationViewStyle())
        //.customDialog(presentaionManager: dialogPresentation)
    }
    func setStage(){
        var num = 0//もっている星の数
        for i in qsl { num += i }
        
        var addQ = 2
        switch num {
        case 5...12 : stage = 2; stageOnNow = 2; neededStar = 13-num; addQ = 3
        case 13...21 : stage = 3; stageOnNow = 3; neededStar = 22-num; addQ = 3
        case 22...100 : stage = 4; stageOnNow = 4; neededStar = 101-num; addQ = 4
        default: neededStar = 5-num// stage 1
        }
        if stage > updated_stage {//新ステージ解放時。　星の数を記録するリストを更新する
            UserDefaults.standard.set(stage, forKey: "updatedStage")
            for _ in 1 ... addQ{ qsl.append(0) }
            UserDefaults.standard.set(qsl, forKey: DataCounter().qsl)
        }
        
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
