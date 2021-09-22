//
//  PlayerView.swift
//  aaa
//
//  Created by user on 2021/06/29.
//
/*
import SwiftUI
import AVKit

struct PlayerView: View {
    @EnvironmentObject var appState: AppState
    //private var player = AVPlayer(url: URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!)
    var player2: AVPlayer?// = AVPlayer(url: Bundle.main.url(forResource: "intro", withExtension: "mp4")!)
    
    init() {
        //let url = Bundle.main.url(forResource: "intro", withExtension: "MP4")!
        let url = Bundle.main.path(forResource: "introduce", ofType: "MP4")
        self.player2 = AVPlayer(url: URL(fileURLWithPath: url!))
    }
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {self.appState.isVideoPlayer = false}, label: {
                        Text("  ＜Back").font(.system(size: 20))
                })
                Spacer()
            }
            
            VideoPlayer(player: player2)
                .onAppear() {player2!.play()}
                .onDisappear(){
                    
                }
            
            
            
            /*let url = URL(string: self.appState.playUrl)
            if url != nil{
                let player2 = AVPlayer(url: url!)
                VideoPlayer(player: player2).onAppear() {player2.play()}
            }*/
            
        }
        
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}

*/
