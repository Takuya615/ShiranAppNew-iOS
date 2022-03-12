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
            .onAppear(perform: {selection -= 1})
            .onDisappear(perform: {
                selection += 1
                UserDefaults.standard.set(selection, forKey: Keys.difficult.rawValue)
            })
            
            switch selection {
            case 0 : Text("　\n　ノーマルモード\n　好きな運動してください。AIが体の動きから自動でスコアを計算してくれます。\n自分で自由に行えるという点が、このモードのいいところです。")
            case 1 : Text("　\n　ハードモード\n　バーピージャンプでスコアをかせげるモードです。このアプリ本来の難易度です。\nスコアがノーマルモードの２倍になります。")
            default: Text("　\n　ベリーハードモード\n　かかえこみバーピージャンプに挑戦するモードです。ハードモードより高く跳ばなければ得点になりません。\nスコアがノーマルモードの３倍です。\n普段からトレーニングをされており、デイリーの制限時間を早く伸ばしたいという方にお勧めです。")
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
