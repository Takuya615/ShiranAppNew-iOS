

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
    var w: CGFloat?
    var h: CGFloat?
    
    static var skins: [Skin] = [
        Skin(id: 0,name: "",image: "face0",coin: 0),
        Skin(id: 1,name: "シルクハット",image: "face1",coin: 30,y: -0.5),
        Skin(id: 2,name: "3Dメガネ",   image: "face2",coin: 30,y: -0.1),
        Skin(id: 3,name: "テディベア",  image: "face3",coin: 30,y: -0.4),
        Skin(id: 4,name: "ハット",     image: "face4",coin: 30,y: -0.3),
        Skin(id: 5,name: "アフロ",     image: "face5",coin: 30,y: -0.4,w: 1.5,h: 1.5),
        
        Skin(id: 6,name: "ちょんまげ",  image: "face6",coin: 30,y: -0.3),
        Skin(id: 7,name: "ヒーロー",  image: "face7",coin: 30,y: -0.1),
        Skin(id: 8,name: "ピエロ",  image: "face8",coin: 30,y: -0.1),
        Skin(id: 9,name: "キツネ",  image: "face9",coin: 30,y: -0.1),
        Skin(id: 10,name: "天使の輪",  image: "face10",coin: 30,y: -0.5,w: 2.0),
        
        Skin(id: 11,name: "クマ",  image: "face11",coin: 30,y: -0.1),
        Skin(id: 12,name: "うきわ",  image: "face12",coin: 30,y: 1.4,w: 1.5,h: 1.5),
        Skin(id: 13,name: "まったりネコ",  image: "face13",coin: 30,y: -0.1),
        Skin(id: 14,name: "能めん",  image: "face14",coin: 30,y: -0.1),
        Skin(id: 15,name: "麦わら",  image: "face15",coin: 30,y: -0.3),
        
        Skin(id: 16,name: "ピクトフェイス",  image: "face16",coin: 30,y: 0.0,w: 0.5,h: 0.5),
        Skin(id: 17,name: "アイコン",  image: "face17",coin: 30,y: -0.1),
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
