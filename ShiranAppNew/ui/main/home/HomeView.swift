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
        let bounds = UIScreen.main.bounds
        let width = bounds.width
        let height = bounds.height
        NavigationView{
            VStack{
                HStack{
                    VStack{
                        Text(str.count_retry.rawValue)
                            .font(.system(size: 20, weight: .black, design: .default))
                            .foregroundColor(.blue)
                        
                        Text(String(self.dataCounter.continuedRetryCounter))
                            .font(.system(size: 50, weight: .black, design: .default))
                            .frame(width: 100, height: 20, alignment: .center)
                            .foregroundColor(.blue)
                    }
                    VStack{
                        Text(str.count_continue.rawValue)
                            .font(.system(size: 20, weight: .black, design: .default))
                            .foregroundColor(.blue)
                        Text(String(self.dataCounter.continuedDayCounter))
                            .font(.system(size: 50, weight: .black, design: .default))
                            .frame(width: 100, height: 20, alignment: .center)
                            .foregroundColor(.blue)
                    }
                }
                StatusView(w: width/2, h: height*0.7)
                    .frame(width: width/2, height: height*0.7, alignment: .center)
                
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
    var w: CGFloat
    var h: CGFloat
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        
        let faceImage: String = UserDefaults.standard.string(forKey: Keys.itemFace.rawValue) ?? ""
//        let bounds = UIScreen.main.bounds
//        let w = bounds.width
//        let h = bounds.height
        let ps: CGFloat = 20
        let c = ps/2
        let lw: CGFloat = 5
        let leftShoulder=CGPoint(x: w*0.71, y: h*0.25)
        let rightShoulder=CGPoint(x: w*0.29, y: h*0.25)
        let leftElbow=CGPoint(x: w*0.8, y: h*0.38)
        let rightElbow=CGPoint(x: w*0.2, y: h*0.38)
        let leftWrist=CGPoint(x: w*0.85, y: h*0.51)
        let rightWrist=CGPoint(x: w*0.15, y: h*0.51)
        let leftHip=CGPoint(x: w*0.68, y: h*0.55)
        let rightHip=CGPoint(x: w*0.32, y: h*0.55)
        let leftKnee=CGPoint(x: w*0.7, y: h*0.7)
        let rightKnee=CGPoint(x: w*0.3, y: h*0.7)
        let leftAnkle=CGPoint(x: w*0.7, y: h*0.9)
        let rightAnkle=CGPoint(x: w*0.3, y: h*0.9)
        
        
        ZStack{
            Image(decorative:faceImage)
                .resizable()
                .offset(x: 3, y:-h*0.36)
                .frame(width: w/3, height: w/3, alignment: .center)
            
            Rectangle()
                .onTapGesture {
                    self.appState.isItemSelectView = true
                }
                .foregroundColor(Color.gray.opacity(0.1))
                .frame(width:w*0.9, height: h*0.9)
            
            
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
            
        }
        
        
    }
}


struct CircleCheck_Previews: PreviewProvider {
    @EnvironmentObject var dataCounter: DataCounter
    static var previews: some View {
        let bounds = UIScreen.main.bounds
        let w = bounds.width
        let h = bounds.height
        //StatusView()
        VStack{
            HStack{
                VStack{
                    Text(str.count_retry.rawValue)
                        .font(.system(size: 20, weight: .black, design: .default))
                        .foregroundColor(.blue)
                    
                    Text(String("0"))
                        .font(.system(size: 50, weight: .black, design: .default))
                        .frame(width: 100, height: 20, alignment: .center)
                        .foregroundColor(.blue)
                }
                VStack{
                    Text(str.count_continue.rawValue)
                        .font(.system(size: 20, weight: .black, design: .default))
                        .foregroundColor(.blue)
                    Text(String("0"))
                        .font(.system(size: 50, weight: .black, design: .default))
                        .frame(width: 100, height: 20, alignment: .center)
                        .foregroundColor(.blue)
                }
            }
            
            StatusView(w: w/2, h: h/2)
                .frame(width: w/2, height: h/2, alignment: .center)
            
            
        }
        
    }
}
