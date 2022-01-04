//
//  SettingView.swift
//  ShiranAppNew
//
//  Created by user on 2021/12/23.
//

import SwiftUI

struct SettingView: View {
    
    @EnvironmentObject var appState: AppState
    let difficults = ["ノーマル","ハード","ベリーハード"]
    @State private var selection = UserDefaults.standard.integer(forKey: Keys.difficult.rawValue)
    
    var body: some View {
        
        VStack {
            HStack{
                        Button(action: {self.appState.isSettingView = false},
                            label: {Text("  ＜Back").font(.system(size: 20))
                        })
                        Spacer()
                    }
            Text("\nデイリーの難易度を設定します\n")
            Picker(selection: $selection, label: Text("難易度を選択")) {
                ForEach(0 ..< difficults.count) { i in Text(self.difficults[i])}
            }
            .pickerStyle(SegmentedPickerStyle())    // セグメントピッカースタイルの指定
            .frame(width: 400)
            .onAppear(perform: {if selection == 6 {selection = 2} else {selection -= 1}})
            .onDisappear(perform: {
                if selection == 2 {selection = 6} else {selection += 1}
                UserDefaults.standard.set(selection, forKey: Keys.difficult.rawValue)
            })
            
            switch selection {
            case 0 : Text("　\n　ノーマルモード\n自分の好きなエクササイズを自由に行えるという点が最大のメリットです。")
            case 1 : Text("　\n　ハードモード\nこのアプリ本来の難易度。スコアがイージーの２倍")
            default: Text("　\n　ベリーハードモード\nスコアがノーマルの４倍普段からトレーニングをされており、デイリーの制限時間を早く伸ばしたいという方にお勧め")
            }
            Spacer()
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
