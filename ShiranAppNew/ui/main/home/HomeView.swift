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
                StatusView()
                 
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


struct StatusView: View {
    var body: some View {
        let bounds = UIScreen.main.bounds
        let xt = 3
        let xp = 0
        let yt = 3
        let yp = 100
        let ps = 20
        let pr = ps / 2
        ZStack{
            Path { path in
                path.addLines([
                    CGPoint(x: 35*xt+xp, y: 130*yt+yp),
                    CGPoint(x: 40*xt+xp, y: 90*yt+yp),
                    CGPoint(x: 45*xt+xp, y: 55*yt+yp),
                    CGPoint(x: 85*xt+xp, y: 55*yt+yp),
                    CGPoint(x: 90*xt+xp, y: 90*yt+yp),
                    CGPoint(x: 95*xt+xp, y: 130*yt+yp)
                ])
                path.addLines([
                    CGPoint(x: 50*xt+xp, y: 200*yt+yp),
                    CGPoint(x: 50*xt+xp, y: 160*yt+yp),
                    CGPoint(x: 50*xt+xp, y: 120*yt+yp),
                    CGPoint(x: 80*xt+xp, y: 120*yt+yp),
                    CGPoint(x: 80*xt+xp, y: 160*yt+yp),
                    CGPoint(x: 80*xt+xp, y: 200*yt+yp)
                ])
                path.move(to: CGPoint(x: 45*xt+xp, y: 55*yt+yp))
                path.addLine(to: CGPoint(x: 50*xt+xp, y: 120*yt+yp))
                path.move(to: CGPoint(x: 85*xt+xp, y: 55*yt+yp))
                path.addLine(to: CGPoint(x: 80*xt+xp, y: 120*yt+yp))
                
            }
            .stroke(lineWidth: 2)
            .fill(Color.green)
            .frame(width: bounds.width, height: bounds.height)
            
            
            Path { path in
                path.addEllipse(in: CGRect(x:35*xt+xp-pr, y: 130*yt+yp-pr, width: ps, height: ps))
                path.addEllipse(in: CGRect(x:40*xt+xp-pr, y: 90*yt+yp-pr, width: ps, height: ps))
                path.addEllipse(in: CGRect(x:45*xt+xp-pr, y: 55*yt+yp-pr, width: ps, height: ps))
                path.addEllipse(in: CGRect(x:85*xt+xp-pr, y: 55*yt+yp-pr, width: ps, height: ps))
                path.addEllipse(in: CGRect(x:90*xt+xp-pr, y: 90*yt+yp-pr, width: ps, height: ps))
                path.addEllipse(in: CGRect(x:95*xt+xp-pr, y: 130*yt+yp-pr, width: ps, height: ps))
                
                
                path.addEllipse(in: CGRect(x:50*xt+xp-pr, y: 200*yt+yp-pr, width: ps, height: ps))
                path.addEllipse(in: CGRect(x:50*xt+xp-pr, y: 160*yt+yp-pr, width: ps, height: ps))
                path.addEllipse(in: CGRect(x:50*xt+xp-pr, y: 120*yt+yp-pr, width: ps, height: ps))
                path.addEllipse(in: CGRect(x:80*xt+xp-pr, y: 120*yt+yp-pr, width: ps, height: ps))
                path.addEllipse(in: CGRect(x:80*xt+xp-pr, y: 160*yt+yp-pr, width: ps, height: ps))
                path.addEllipse(in: CGRect(x:80*xt+xp-pr, y: 200*yt+yp-pr, width: ps, height: ps))
            }
            .fill(Color.yellow)
            .frame(width: bounds.width, height: bounds.height)
            
            
        }
        
        
    }
}
struct StatusView2: View {
    var body: some View {
        let bounds = UIScreen.main.bounds
        let w = bounds.width
        let h = bounds.height
        let xt = 1
        let xp = 0
        let yt = 1
        let yp = 0
        let ps = 20
        let pr = ps / 2
        
        
        let leftShoulder=CGPoint(x: w*0.6, y: h*0.25)
        let rightShoulder=CGPoint(x: w*0.4, y: h*0.25)
        let leftElbow=CGPoint(x: w*0.63, y: h*0.35)
        let rightElbow=CGPoint(x: w*0.38, y: h*0.35)
        let leftWrist=CGPoint(x: w*0.65, y: h*0.5)
        let rightWrist=CGPoint(x: w*0.35, y: h*0.5)
        let leftHip=CGPoint(x: w*0.58, y: h*0.5)
        let rightHip=CGPoint(x: w*0.42, y: h*0.5)
        let leftKnee=CGPoint(x: w*0.6, y: h*0.65)
        let rightKnee=CGPoint(x: w*0.4, y: h*0.65)
        let leftAnkle=CGPoint(x: w*0.6, y: h*0.75)
        let rightAnkle=CGPoint(x: w*0.4, y: h*0.75)
        
        ZStack{
            Path { path in
                path.addLines([
                    rightWrist,
                    rightElbow,
                    rightShoulder,
                    leftShoulder,
                    leftElbow,
                    leftWrist
                ])
                path.addLines([
                    rightAnkle,
                    rightKnee,
                    rightHip,
                    leftHip,
                    leftKnee,
                    leftAnkle
                ])
                path.move(to: rightShoulder)
                path.addLine(to: rightHip)
                path.move(to: leftShoulder)
                path.addLine(to: leftHip)
                
            }
            .stroke(lineWidth: 2)
            .fill(Color.green)
            .frame(width: bounds.width, height: bounds.height)
            
            
            Path { path in
                path.addEllipse(in: CGRect(x:35*xt+xp-pr, y: 130*yt+yp-pr, width: ps, height: ps))
                path.addEllipse(in: CGRect(x:40*xt+xp-pr, y: 90*yt+yp-pr, width: ps, height: ps))
                path.addEllipse(in: CGRect(x:45*xt+xp-pr, y: 55*yt+yp-pr, width: ps, height: ps))
                path.addEllipse(in: CGRect(x:85*xt+xp-pr, y: 55*yt+yp-pr, width: ps, height: ps))
                path.addEllipse(in: CGRect(x:90*xt+xp-pr, y: 90*yt+yp-pr, width: ps, height: ps))
                path.addEllipse(in: CGRect(x:95*xt+xp-pr, y: 130*yt+yp-pr, width: ps, height: ps))
                
                
                path.addEllipse(in: CGRect(x:50*xt+xp-pr, y: 200*yt+yp-pr, width: ps, height: ps))
                path.addEllipse(in: CGRect(x:50*xt+xp-pr, y: 160*yt+yp-pr, width: ps, height: ps))
                path.addEllipse(in: CGRect(x:50*xt+xp-pr, y: 120*yt+yp-pr, width: ps, height: ps))
                path.addEllipse(in: CGRect(x:80*xt+xp-pr, y: 120*yt+yp-pr, width: ps, height: ps))
                path.addEllipse(in: CGRect(x:80*xt+xp-pr, y: 160*yt+yp-pr, width: ps, height: ps))
                path.addEllipse(in: CGRect(x:80*xt+xp-pr, y: 200*yt+yp-pr, width: ps, height: ps))
            }
            .fill(Color.yellow)
            .frame(width: bounds.width, height: bounds.height)
            
            
        }
        
        
    }
}

struct CircleCheck_Previews: PreviewProvider {
    static var previews: some View {
        StatusView2()
    }
}

