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
                        // get true when push fab
                        CoachMarkView()
                    }
                
                    fragment
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
            ThirdView()
             .tabItem {
                 Image(systemName: "questionmark")
                 Text("")
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
            .navigationTitle("ホーム")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Menu{
                        Button(action: {
                            appState.isExplainView = true
                        }) {
                            Text("アプリ詳細")
                            Image(systemName: "newspaper")//"gearshape")歯車まーく
                            }
                        
                        Button(action: {
                            appState.isPrivacyPolicy = true
                        }) {
                            Text("プライバシーポリシー")
                            Image(systemName: "shield")
                            }
                        
                        /*if self.appState.isinAccount {
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
                
            }
            
        }.navigationViewStyle(StackNavigationViewStyle())
        /*SideMenuView(isOpen: $isOpenSideMenu)
            .edgesIgnoringSafeArea(.all)
        }*/
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
        guard let listD = UserDefaults.standard.array(forKey: DataCounter().listD) as? [String]
        else {print("リストが nil になっている"); return}
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
    var body: some View {
        NavigationView{
            Text("ただいま工事中")
            .navigationTitle("？？？")
            .navigationBarTitleDisplayMode(.inline)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
