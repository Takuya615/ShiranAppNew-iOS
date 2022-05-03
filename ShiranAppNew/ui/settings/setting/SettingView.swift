//
//  SettingView.swift
//  ShiranAppNew
//
//  Created by user on 2021/12/23.
//

import SwiftUI

struct SettingView: View {
    
    @EnvironmentObject var appState: AppState
    let difficults = [
        str.normal.rawValue,
        str.hard.rawValue,
        str.veryHard.rawValue]
    @State private var selection = UserDefaults.standard.integer(forKey: Keys.difficult.rawValue)
    
    var body: some View {
        
        VStack {
            BackKeyView(callBack: {self.appState.isSettingView.toggle()})
            Text(str.settingDifficulty.rawValue)
            Picker(selection: $selection,
                   label: Text(str.selectDifficulty.rawValue)) {
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
            case 0 : Text(str.modeNormal.rawValue)
            case 1 : Text(str.modeHard.rawValue)
            default: Text(str.modeVeryHard.rawValue)
            }
            Spacer()
        }
    }
}
