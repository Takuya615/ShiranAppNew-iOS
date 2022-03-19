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
                    toolbarItemView()
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
    @EnvironmentObject var appState: AppState
    var body: some View {
        
        let faceImage: String = UserDefaults.standard.string(forKey: Keys.itemFace.rawValue) ?? ""
        let gloabImage: String = UserDefaults.standard.string(forKey: Keys.itemFace.rawValue) ?? ""
        let shoseImage: String = UserDefaults.standard.string(forKey: Keys.itemFace.rawValue) ?? ""
        let jointColor: String = UserDefaults.standard.string(forKey: Keys.itemFace.rawValue) ?? ""
        let jColor: String = UserDefaults.standard.string(forKey: Keys.itemFace.rawValue) ?? ""
        
        let bounds = UIScreen.main.bounds
        let w = bounds.width
        let h = bounds.height
        let ps: CGFloat = 20
        let c = ps/2
        let lw: CGFloat = 5
        let leftShoulder=CGPoint(x: w*0.61, y: h*0.38)
        let rightShoulder=CGPoint(x: w*0.39, y: h*0.38)
        let leftElbow=CGPoint(x: w*0.7, y: h*0.48)
        let rightElbow=CGPoint(x: w*0.3, y: h*0.48)
        let leftWrist=CGPoint(x: w*0.75, y: h*0.58)
        let rightWrist=CGPoint(x: w*0.25, y: h*0.58)
        let leftHip=CGPoint(x: w*0.58, y: h*0.58)
        let rightHip=CGPoint(x: w*0.42, y: h*0.58)
        let leftKnee=CGPoint(x: w*0.6, y: h*0.71)
        let rightKnee=CGPoint(x: w*0.4, y: h*0.71)
        let leftAnkle=CGPoint(x: w*0.6, y: h*0.83)
        let rightAnkle=CGPoint(x: w*0.4, y: h*0.83)
        
        
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
            .stroke(lineWidth: lw)
            .fill(Color.green)
            .frame(width: w, height: h)
            
            
            
            Path { path in
                path.addEllipse(in: CGRect(x:leftShoulder.x-c, y: leftShoulder.y-c, width: ps, height: ps))
                path.addEllipse(in: CGRect(x:rightShoulder.x-c, y: rightShoulder.y-c, width: ps, height: ps))
                path.addEllipse(in: CGRect(x:leftElbow.x-c, y: leftElbow.y-c, width: ps, height: ps))
                path.addEllipse(in: CGRect(x:rightElbow.x-c, y: rightElbow.y-c, width: ps, height: ps))
                path.addEllipse(in: CGRect(x:leftWrist.x-c, y: leftWrist.y-c, width: ps, height: ps))
                path.addEllipse(in: CGRect(x:rightWrist.x-c, y: rightWrist.y-c, width: ps, height: ps))
                
                path.addEllipse(in: CGRect(x:leftHip.x-c, y: leftHip.y-c, width: ps, height: ps))
                path.addEllipse(in: CGRect(x:rightHip.x-c, y: rightHip.y-c, width: ps, height: ps))
                path.addEllipse(in: CGRect(x:leftKnee.x-c, y: leftKnee.y-c, width: ps, height: ps))
                path.addEllipse(in: CGRect(x:rightKnee.x-c, y: rightKnee.y-c, width: ps, height: ps))
                path.addEllipse(in: CGRect(x:leftAnkle.x-c, y: leftAnkle.y-c, width: ps, height: ps))
                path.addEllipse(in: CGRect(x:rightAnkle.x-c, y: rightAnkle.y-c, width: ps, height: ps))
            }
            .fill(Color.yellow)
            .frame(width: w, height: h)
            
            Image(decorative: "face2")//faceImage)
                .resizable()
                .offset(x: 2, y:-h*0.18)
                .frame(width: 70.0, height: 70.0, alignment: .center)
            
            Rectangle()
                .onTapGesture {
                    self.appState.isItemSelectView = true
                }
                .foregroundColor(Color.black.opacity(0.1))
                .frame(width:w/2, height: h*0.6)
                .offset(x: 0, y: h*0.05)

            
        }
        
        
    }
}


struct CircleCheck_Previews: PreviewProvider {
    static var previews: some View {
        StatusView()
    }
}
