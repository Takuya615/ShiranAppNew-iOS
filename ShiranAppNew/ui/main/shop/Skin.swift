//
//  Face.swift
//  ShiranAppNew
//
//  Created by 津村拓哉 on 2022/04/15.
//

import Foundation
import SwiftUI

struct Skin: Identifiable,Codable {
    var id: Int//String = "aa"//UUID()     // ユニークなIDを自動で設定
    var name: String
    var image: String
    var coin: Int
    var x: CGFloat?
    var y: CGFloat?
    
    static var skins: [Skin] = [
        Skin(id: 0,name: "",image: "face0",coin: 0),
        Skin(id: 1,name: "シルクハット",image: "face1",coin: 55,y: -0.5),
        Skin(id: 2,name: "3Dメガネ",image: "face2",coin: 11,y: -0.1),
        Skin(id: 3,name: "テディベア",image: "face3",coin: 22,y: -0.45),
        Skin(id: 4,name: "ハット",image: "face4",coin: 33,y: -0.4),
        Skin(id: 5,name: "アフロ",image: "face5",coin: 44,y: -0.4),
        Skin(id: 6,name: "ちょんまげ",image: "face6",coin: 33,y: -0.3),
    ]
}
