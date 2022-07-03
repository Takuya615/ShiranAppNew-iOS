
import SwiftUI

struct SettingView: View {
    
    @EnvironmentObject var appState: AppState
    @State private var selection = UserDefaults.standard.integer(forKey: Keys.difficult.rawValue)//0,1,2
    static let difficults = [
        str.normal.rawValue,
        str.hard.rawValue,
        str.veryHard.rawValue]
    
    var body: some View {
        
        VStack {
            BackKeyView(callBack: {self.appState.isSettingView.toggle()})
            Text(str.settingDifficulty.rawValue)
            Picker(selection: $selection,
                   label: Text(str.selectDifficulty.rawValue)) {
                ForEach(0 ..< 3) { i in Text(SettingView.difficults[i])}
            }
            .pickerStyle(SegmentedPickerStyle())    // セグメントピッカースタイルの指定
            .frame(width: 400)
            //.onAppear(perform: {selection -= 1})
            .onDisappear(perform: {
                //selection += 1
                UserDefaults.standard.set(selection, forKey: Keys.difficult.rawValue)
            })
            
            switch selection {
            case 0 : Text(str.modeNormal.rawValue)
            case 1 : Text(str.modeHard.rawValue)
            default: Text(str.modeVeryHard.rawValue)
            }
            Spacer()
        }
        .onAppear(perform: {EventAnalytics.screen(name: str.set.rawValue)})
    }
}
