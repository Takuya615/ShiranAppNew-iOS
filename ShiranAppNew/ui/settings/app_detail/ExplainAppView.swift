//
//  ExplainAppView.swift
//  ShiranAppNew
//
//  Created by user on 2021/09/09.
//

import SwiftUI
import AVKit

struct ExplainAppView: View {
    @EnvironmentObject var appState: AppState
    @State private var btn0 = false
    @State private var btn01 = false
    @State private var btn1 = false
    @State private var btn2 = false
    @State private var btn3 = false
    @State private var btn4 = false
    @State private var btn5 = false
    
    var body: some View {
        HStack{
                Button(
                    action:{self.appState.isExplainView = false},
                    label: {Text(str.back.rawValue).font(.system(size: 20))
                        })
                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                        Spacer()
                }
        VStack{
            Spacer()
            Text(str.exp1.rawValue).font(.title)
            .onAppear(perform: { if !appState.coachMark1{btn0 = true}})
            
            
            List{
                Button(action: {
                    self.btn0.toggle()
                }, label: {
                    HStack{
                        Text(str.expTitle1.rawValue)
                        Image(systemName: "play.rectangle.fill")
                            .foregroundColor(.red)
                    }
                }).sheet(isPresented: self.$btn0, content: {
                    PlayerView()
                })
                /*Button(action: {
                    self.btn01.toggle()
                }, label: {
                    HStack{
                        Text("敵モンスターの倒しかた")
                        Image(systemName: "play.rectangle.fill")
                            .foregroundColor(.red)
                    }
                }).sheet(isPresented: self.$btn01, content: {
                    PlayerView2()
                })*/
                Button(str.expTitle2.rawValue){
                    self.btn1.toggle()
                }.sheet(isPresented: self.$btn1, content: {
                    Explanation1()
                })
                Button(str.expTitle3.rawValue){
                    self.btn2.toggle()
                }.sheet(isPresented: self.$btn2, content: {
                    Explanation2()
                })
                Button(str.expTitle4.rawValue){
                    self.btn3.toggle()
                }.sheet(isPresented: self.$btn3, content: {
                    Explanation3()
                })
                Button(str.expTitle5.rawValue){
                    self.btn4.toggle()
                }.sheet(isPresented: self.$btn4, content: {
                    Explanation4()
                })
            
                
                
            }

        }
        
    }
}

struct PlayerView: View {
    @EnvironmentObject var appState: AppState
    let url = Bundle.main.path(forResource: "introduce", ofType: "mov")
    var body: some View {
        let player = AVPlayer(url: URL(fileURLWithPath: url!))
        VideoPlayer(player: player)
            .onDisappear(perform: {
                if !appState.coachMark1 {self.appState.isExplainView = false}
            })
            //.onAppear() {player.play()}
    }
}
struct PlayerView2: View {
    let url = Bundle.main.path(forResource: "fightEnemy", ofType: "MP4")
    var body: some View {
        let player = AVPlayer(url: URL(fileURLWithPath: url!))
        VideoPlayer(player: player)
            .onAppear() {player.play()}
    }
}
struct PlayerViewCoin: View {
    let url = Bundle.main.path(forResource: "q_coin", ofType: "mp4")
    var body: some View {
        let player = AVPlayer(url: URL(fileURLWithPath: url!))
        VStack{
            Image(systemName: "chevron.compact.down")
                .resizable().frame(width: 100, height: 20, alignment: .top).padding().foregroundColor(.gray)
            VideoPlayer(player: player)
                        .onAppear() {player.play()}
        }
        
    }
}
struct PlayerViewClimb: View {
    let url = Bundle.main.path(forResource: "q_climb", ofType: "mp4")
    var body: some View {
        let player = AVPlayer(url: URL(fileURLWithPath: url!))
        VStack{
            Image(systemName: "chevron.compact.down")
                .resizable().frame(width: 100, height: 20, alignment: .top).padding().foregroundColor(.gray)
            VideoPlayer(player: player)
                        .onAppear() {player.play()}
        }
    }
}
struct PlayerViewHiit: View {
    let url = Bundle.main.path(forResource: "q_hiit", ofType: "mov")
    var body: some View {
        let player = AVPlayer(url: URL(fileURLWithPath: url!))
        VStack{
            Image(systemName: "chevron.compact.down")
                .resizable().frame(width: 100, height: 20, alignment: .top).padding().foregroundColor(.gray)
            VideoPlayer(player: player)
                        .onAppear() {player.play()}
        }
    }
}
/// ２番めのView
struct Explanation1: View {
    var body: some View {
        Text(str.expTitle2.rawValue).font(.title)
        
        Text(str.exp2.rawValue)
            .foregroundColor(.red)
            .bold()
            .font(.system(size: 25, design: .default))
        Text(str.exp2_2.rawValue)
    }
}
struct Explanation2: View {
    var body: some View {
        Text(str.expTitle3.rawValue).font(.title)
        Text(str.exp3.rawValue)
    }
}
struct Explanation3: View {
    var body: some View {
        Text(str.expTitle4.rawValue).font(.title)
        
        Text(str.exp4.rawValue)
    }
}
struct Explanation4: View {
    var body: some View {
        Text(str.expTitle5.rawValue).font(.title)
        
        Text(str.exp5.rawValue)
    }
}
