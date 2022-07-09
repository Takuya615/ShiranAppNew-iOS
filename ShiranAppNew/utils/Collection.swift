

import Foundation
import SwiftUI

struct Skin:Hashable{
    var id: Int//String = "aa"//UUID()     // ユニークなIDを自動で設定
    var name: String
    var image: String
    var coin: Int
    var dia: Int?
    var x: CGFloat?
    var y: CGFloat?
    
    static var skins: [Skin] = [
        Skin(id: 0,name: "",image: "face0",coin: 0),
        Skin(id: 1,name: "シルクハット",image: "face1",coin: 30,y: -0.5),
        Skin(id: 2,name: "3Dメガネ",   image: "face2",coin: 30,y: -0.1),
        Skin(id: 3,name: "テディベア",  image: "face3",coin: 30,y: -0.45),
        Skin(id: 4,name: "ハット",     image: "face4",coin: 30,y: -0.4),
        Skin(id: 5,name: "アフロ",     image: "face5",coin: 30,y: -0.4),
        Skin(id: 6,name: "ちょんまげ",  image: "face6",coin: 30,y: -0.3),
    ]
}


struct Body:Hashable{
    var code = UUID()
    var id: Int//String = "aa"//UUID()     // ユニークなIDを自動で設定
    var name: String
    var coin: Int
    var dia: Int?
    
    static var bodys: [Body] = [
        Body(id: 0,name: "デフォルト",coin: 0),
        Body(id: 1,name: "ピクトグラム 青",coin: 150),
        Body(id: 2,name: "ピクトグラム ピンク",coin: 150),
    ]
}
