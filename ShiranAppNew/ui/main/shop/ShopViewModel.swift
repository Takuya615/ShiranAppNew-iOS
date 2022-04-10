//
//  ShopViewModel.swift
//  ShiranAppNew
//
//  Created by user on 2022/02/19.
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
}

struct ShopViewModel{
    
    static func checkCanBuy(price:Int) -> Bool{
        let coin = UserDefaults.standard.integer(forKey: Keys.coin.rawValue)
        if coin < price {
            return false
        }
        return true
    }
    
    static func buy(article:Skin) -> Int{
        var coin = UserDefaults.standard.integer(forKey: Keys.coin.rawValue)
        coin -= article.coin
        var items: [Int] = UserDefaults.standard.array(forKey: Keys.yourItem.rawValue) as? [Int] ?? [] as [Int]
        items.append(article.id)
        UserDefaults.standard.set(coin, forKey: Keys.coin.rawValue)
        UserDefaults.standard.set(items, forKey: Keys.yourItem.rawValue)
        UserDefaults.standard.setEncoded(article,forKey: Keys.selectSkin.rawValue)
        return coin
    }
    
    
    
    static func itemPrice(article:Skin) -> Int{
        //        let items: [Skin] = UserDefaults.standard.array(forKey: Keys.yourItem.rawValue) as? [Skin] ?? [] as [Skin]
        //        for item in items {
        //            if item == article.name {
        //                return 0
        //            }
        //        }
        return article.coin
    }
    
    static func getMoney(coin:Int){
        UserDefaults.standard.set(coin, forKey: Keys.coin.rawValue)
    }
    
    static var skins: [Skin] = [
        Skin(id: 0,name: "シルクハット",image: "face1",coin: 55,y: -0.5),
        Skin(id: 1,name: "3Dメガネ",image: "face2",coin: 11,y: -0.1),
        Skin(id: 2,name: "テディベア",image: "face3",coin: 22,y: -0.45),
        Skin(id: 3,name: "ハット",image: "face4",coin: 33,y: -0.4),
        Skin(id: 4,name: "アフロ",image: "face5",coin: 44,y: -0.4),
        Skin(id: 5,name: "ちょんまげ",image: "face6",coin: 33,y: -0.3),
    ]
    
    static func getSkins() -> [Skin]{
        guard let gotItems: [Int] = UserDefaults.standard.array(forKey: Keys.yourItem.rawValue )as? [Int] else {return skins}
        var sList = skins
        var count = 0
//        print("ああああ")
//        print(gotItems)
//        print(gotItems.sorted())
        for num in gotItems.sorted() {
//            print(num)
//            print("->")
//            print(num-count)
            sList.remove(at: num-count)
            count += 1
        }
        return sList
    }
}
