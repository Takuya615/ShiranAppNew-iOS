

import SwiftUI

struct QuestView: View{
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var dataCounter: DataCounter
    @State var qsl: [Int] = UserDefaults.standard.array(forKey: Keys.qsl.rawValue) as? [Int] ?? [0,0,0]
    @State var updated_stage: Int = UserDefaults.standard.integer(forKey: Keys.updatedStage.rawValue)
    @State var stage :Int = 1//星の数で開けるステージを限定
    @State var stageOnNow :Int = 1//今どこのステージにいるのか
    @State var neededStar: Int = 0//残りの星の必要な数
    @State var onVideo: Bool = false
    @State var alertItem: QuestAlertItem?
    @State var sheetItem: QuestSheetItem?
    @State var timer :Timer?
    @State var charge: Int = 0
    @State private var image1: Image = Image(systemName: "heart.fill")
    @State private var image2: Image = Image(systemName: "heart.fill")
    @State private var image3: Image = Image(systemName: "heart.fill")
    private let exit_heart = UserDefaults.standard.bool(forKey: Keys.exist_interval_heart.rawValue)
    
    var body: some View {
        if !UserDefaults.standard.bool(forKey: Keys.exist_quest.rawValue){
            Text("ただいま準備中・・・\(String(UserDefaults.standard.bool(forKey: Keys.exist_quest.rawValue)))")
        }else{
            NavigationView{
                if stage+1 == stageOnNow {
                    Text(str.questViewText1.rawValue + String(neededStar) + str.questViewText2.rawValue)
                        .navigationTitle(str.stage.rawValue + String(stageOnNow))
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar{
                            ToolbarItem(placement: .navigationBarLeading){
                                Button(action: {
                                    stageOnNow -= 1
                                }) { Image(systemName: "arrowtriangle.left.fill") }
                            }
                        }
                }
                VStack{
                    if exit_heart {
                        HStack{
                            Text("+ \(CameraModel.min(time: charge))")
                            if 1 > charge { image1.resizable().frame(width: 20.0, height: 20.0, alignment: .leading).foregroundColor(Color(Colors.pink))}
                            if 301 > charge { image2.resizable().frame(width: 20.0, height: 20.0, alignment: .leading).foregroundColor(Color(Colors.pink))}
                            if 601 > charge { image3.resizable().frame(width: 20.0, height: 20.0, alignment: .leading).foregroundColor(Color(Colors.pink))}
                        }
                    }
                    List(QuestViewModel.showQuests(stageOnNow: stageOnNow)){ item in
                        VStack{
                            HStack{
                                Text(item.name)
                                switch item.number {
                                case 0: Text("▶️").onTapGesture(perform: {sheetItem = QuestViewModel.getQuestSheetItem(page: item.number)})
                                case 1: Text("▶️").onTapGesture(perform: {sheetItem = QuestViewModel.getQuestSheetItem(page: item.number)})
                                case 2: Text("▶️").onTapGesture(perform: {sheetItem = QuestViewModel.getQuestSheetItem(page: item.number)})
                                case 5: Text("▶️").onTapGesture(perform: {sheetItem = QuestViewModel.getQuestSheetItem(page: item.number)})
                                default: Text("")
                                }
                            }
                            Button(action: {
                                alertItem = QuestViewModel.getQuestAlertItem(item: item, appState: appState,charg: charge)
                            }, label: {
                                HStack{
                                    Spacer()
                                    ForEach(1..<4) { i in
                                        if qsl[item.number] >= i {
                                            Image(systemName: "star.fill").resizable()
                                                .frame(width: 50.0, height: 50.0, alignment: .leading).foregroundColor(Color(Colors.orange))
                                        }else{
                                            Image(systemName: "star").resizable()
                                                .frame(width: 50.0, height: 50.0, alignment: .leading).foregroundColor(Color(Colors.orange))
                                        }
                                        Spacer()
                                    }
                                }
                            })
                        }
                    }
                }
                .alert(item: $alertItem, content: {alert in
                    if exit_heart && charge > 600 {
                        return Alert(title:Text(str.emptyHeart.rawValue),message: nil,dismissButton: Alert.Button.cancel(Text(str.quite.rawValue)))
                    }
                    return Alert(title: alert.title, message: alert.message, primaryButton: alert.primary, secondaryButton: alert.secondary)
                })
                .sheet(item: $sheetItem, onDismiss: nil, content: {sheet in PlayerViewQuest(url: sheet.url)})
                .onAppear(perform: { setStage() })
                .onDisappear(perform: { timer?.invalidate() })
                .navigationTitle(str.stage.rawValue + String(stageOnNow))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading){
                        if stageOnNow > 1 {
                            Button(action: {
                                stageOnNow -= 1
                            }) { Image(systemName: "arrowtriangle.left.fill") }
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing){
                        if stageOnNow < stage+1 {
                            Button(action: {
                                stageOnNow += 1
                            }) { Image(systemName: "arrowtriangle.right.fill") }
                        }
                    }
                }
            }.navigationViewStyle(StackNavigationViewStyle())
            //.customDialog(presentaionManager: dialogPresentation)
        }
    }
    func setStage(){
        EventAnalytics.tap(name: str.quest.rawValue)
        qsl = UserDefaults.standard.array(forKey: Keys.qsl.rawValue) as? [Int] ?? [0,0,0]
        while qsl.count < QuestViewModel.stageManager.count { qsl.append(0) }
        let num = qsl.reduce(0, +)
        var a = (3*QuestViewModel.getStageNum(stage: stage+1)*85/100) - num
        while a < 1 {
            stage += 1
            stageOnNow += 1
            a = (3*QuestViewModel.getStageNum(stage: stage+1)*85/100) - num
        }
        neededStar = a
        UserDefaults.standard.set(qsl, forKey: Keys.qsl.rawValue)
        
        charge = QuestViewModel.setTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if charge > 0 {charge -= 1} else {timer.invalidate()}
        }
    }
    
}
