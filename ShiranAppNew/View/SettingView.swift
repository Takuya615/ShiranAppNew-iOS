//
//  SettingView.swift
//  ShiranAppNew
//
//  Created by user on 2021/12/23.
//

import SwiftUI

struct SettingView: View {
    
    @EnvironmentObject var appState: AppState
    let difficults = ["ノーマル", "ハード", "ベリーハード"]
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
            Picker(selection: $selection, label: Text("フルーツを選択")) {
                ForEach(0 ..< difficults.count) { num in
                    Text(self.difficults[num])
                }
            }
            .pickerStyle(SegmentedPickerStyle())    // セグメントピッカースタイルの指定
            .frame(width: 400)
            .onDisappear(perform: {UserDefaults.standard.set(selection, forKey: Keys.difficult.rawValue)})
            
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
