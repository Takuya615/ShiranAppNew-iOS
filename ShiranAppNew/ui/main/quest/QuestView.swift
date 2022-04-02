//
//  QuestView.swift
//  ShiranAppNew
//
//  Created by user on 2022/02/19.
//

import SwiftUI

struct QuestView: View{
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var dataCounter: DataCounter
    @State var dialogPresentation = DialogPresentation()
    @State var showAlert = false
    @State var qsl: [Int] = UserDefaults.standard.array(forKey: Keys.qsl.rawValue) as? [Int] ?? [0,0,0]
    @State var updated_stage: Int = UserDefaults.standard.integer(forKey: "updatedStage")
    @State var stage :Int = 3//星の数で開けるステージを限定
    @State var stageOnNow :Int = 1//今どこのステージにいるのか
    @State var neededStar: Int = 0//残りの星の必要な数
    @State var onVideo: Bool = false
    
    var body: some View {
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
            
            //QuestViewModel.showQuests(stageOnNow: stageOnNow)
            List(showQuestsS(stageOnNow: stageOnNow)){ item in
                VStack{
                    HStack{
                        Text(item.name)
                        switch item.number {
                        case 1: Text("▶️").onTapGesture(perform: {onVideo.toggle()}).sheet(isPresented: $onVideo, content: {PlayerViewCoin()})//ExplainAppView
                        case 3: Text("▶️").onTapGesture(perform: {onVideo.toggle()}).sheet(isPresented: $onVideo, content: {PlayerViewHiit()})
                        case 6: Text("▶️").onTapGesture(perform: {onVideo.toggle()}).sheet(isPresented: $onVideo, content: {PlayerViewClimb()})
                            
                        default: Text("")
                        }
                    }
                    
                    Button(action: {
                        self.showAlert = true
                    }, label: {
                        HStack{
                            Spacer()
                            ForEach(1..<4) { i in
                                if qsl[item.number] >= i {
                                    Image(systemName: "star.fill").resizable()
                                        .frame(width: 50.0, height: 50.0, alignment: .leading)
                                }else{
                                    Image(systemName: "star").resizable()
                                        .frame(width: 50.0, height: 50.0, alignment: .leading)
                                }
                                Spacer()
                            }
                        }
                    }).alert(isPresented: $showAlert) {
                        return Alert(title: Text(str.tryChallenge.rawValue),
                                     message: Text(item.text),
                                     primaryButton: .cancel(Text(str.quite.rawValue)),
                                     secondaryButton: .default(Text(str.challenge.rawValue), action: {
                            UserDefaults.standard.set(item.number, forKey: Keys.questNum.rawValue)
                            UserDefaults.standard.set(item.type,forKey: Keys.questType.rawValue)
                            UserDefaults.standard.set(item.goal, forKey: Keys.qGoal.rawValue)
                            UserDefaults.standard.set(item.time, forKey: Keys.qTime.rawValue)
                            EventAnalytics.questDone()
                            if item.type == -1 {
                                appState.isVideo = true
                            }else{
                                appState.isQuest = true
                            }
                            
                        }))
                    }
                }
                
            }
            .onAppear(perform: {
                setStage()
                //if !self.appState.coachOpenQuest{dialogPresentation.show(content: .contentDetail4(isPresented: $dialogPresentation.isPresented))}
            })
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
    func setStage(){
        var num = 0//もっている星の数
        for i in qsl { num += i }
        
        var addQ = 2
        switch num {
        case 5...12 : stage = 2; stageOnNow = 2; neededStar = 13-num; addQ = 3
        case 13...21 : stage = 3; stageOnNow = 3; neededStar = 22-num; addQ = 3
        case 22...100 : stage = 4; stageOnNow = 4; neededStar = 101-num; addQ = 4
        default: neededStar = 5-num// stage 1
        }
        if stage > updated_stage {//新ステージ解放時。　星の数を記録するリストを更新する
            UserDefaults.standard.set(stage, forKey: "updatedStage")
            for _ in 1 ... addQ{ qsl.append(0) }
            UserDefaults.standard.set(qsl, forKey: Keys.qsl.rawValue)
            switch stage {
            case 2: EventAnalytics.qCrear1()
            case 3: EventAnalytics.qCrear2()
            case 4: EventAnalytics.qCrear3()
            default : return
            }
            
        }
    }
    func showQuestsS(stageOnNow: Int) -> [Quest]{
        let quests:[Quest] = [
            Quest(number: 1,type: 1,goal: [3,4,5],time: 10,name: "コイン集め", text: "制限時間以内に、画面上のコインを5コ集める"),
            Quest(number: 2,type: 2,goal: [100,230,350],time: 10,name: "とにかく動け！", text: "制限時間以内に、スコア 350以上のはげしい運動をする"),
            
            
            Quest(number: 3, type: -1, goal: [5,7,10], time: 60, name: "HIIT(ヒート)体験版", text: "画面が赤い時だけ全力で動きましょう。\n60秒以内にモンスターを10体たおす\n\n※注意　このクエストには、難易度が反映されます"),
            Quest(number: 4,type: 1,goal: [5,8,10],time: 10,name: "コイン集め", text: "制限時間以内に、画面上のコインを6コ集める"),
            Quest(number: 5,type: 2,goal: [200,300,400],time: 10,name: "とにかく動け！", text: "制限時間以内に、スコア 400以上のはげしい運動をする"),
            
            
            Quest(number: 6,type: 3,goal: [60,100,140],time: 10,name: "ボルダリング", text: "制限時間以内に、140m　登りきる"),
            Quest(number: 7,type: 1,goal: [6,9,11],time: 10,name: "コイン集め", text: "制限時間以内に、画面上のコインを8コ集める"),
            Quest(number: 8,type: 2,goal: [340,400,450],time: 10,name: "とにかく動け！", text: "制限時間以内に、スコア 450以上のはげしい運動をする"),
            //Quest(number: 9,type: 3,goal: [100,170,200],time: 10,name: "ボルダリング", text: "制限時間以内に、200m　登りきる"),
            
            
            Quest(number: 9, type: -1, goal: [10,14,20], time: 120, name: "HIIT(ヒート)体験版", text: "画面が赤い時だけ全力で動きましょう。\n120秒以内にモンスターを20体たおす"),
            Quest(number: 10,type: 1,goal: [7,9,11],time: 10,name: "コイン集め", text: "制限時間以内に、画面上のコインを11コ集める"),
            Quest(number: 11,type: 2,goal: [400,500,550],time: 10,name: "とにかく動け！", text: "制限時間以内に、スコア 550以上のはげしい運動をする"),
            Quest(number: 12,type: 3,goal: [150,200,250],time: 10,name: "ボルダリング", text: "制限時間以内に、250m　登りきる"),
            Quest(number: 13, type: -1, goal: [15,21,30], time: 180, name: "HIIT(ヒート)体験版", text: "画面が赤い時だけ全力で動きましょう。\n180秒以内にモンスターを30体たおす"),
            //Quest(number: 12,type: 4,goal: [8,15,25],name: "スケート", text: "制限時間以内に、25m　滑りきる"),
        ]
        switch stageOnNow {
        case 2: return [quests[2],quests[3],quests[4]]
        case 3: return [quests[5],quests[6],quests[7],quests[8]]
        case 4: return [quests[9],quests[10],quests[11],quests[12]]
        default : return [quests[0],quests[1]]
        }
    }
}
