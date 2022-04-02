//
//  QuestViewModel.swift
//  ShiranAppNew
//
//  Created by user on 2022/02/19.
//

import Foundation
import SwiftUI

struct Quest: Identifiable {
    var id = UUID()     // ユニークなIDを自動で設定¥
    var number: Int
    var type: Int
    var goal: [Int]
    var time: Int
    var name: String
    var text: String
}

struct QuestViewModel {
    
    static func showQuests(stageOnNow: Int) -> [Quest]{
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
