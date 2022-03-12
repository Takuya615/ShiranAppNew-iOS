//
//  ShopViewModel.swift
//  ShiranAppNew
//
//  Created by user on 2022/02/19.
//

import Foundation
import SwiftUI

struct Skin: Identifiable {
    var id = UUID()     // ユニークなIDを自動で設定
    var name: String
    var image: String
    var num: Int
    var coin: Int
    
}

struct ShopViewModel{
    
    static func checkCanBuy(price:Int) -> Bool{
        let coin = UserDefaults.standard.integer(forKey: Keys.coin.rawValue)
        if coin < price {
            return false
        }
        return true
    }
    
    static func buy(article:Skin){
        var coin = UserDefaults.standard.integer(forKey: Keys.coin.rawValue)
        coin -= article.coin
        var items: [String] = UserDefaults.standard.array(forKey: Keys.yourItem.rawValue) as! [String]
        items.append(article.name)
        UserDefaults.standard.set(coin, forKey: Keys.coin.rawValue)
        UserDefaults.standard.set(items, forKey: Keys.yourItem.rawValue)
        UserDefaults.standard.set(article.image, forKey: Keys.itemFace.rawValue)
    }
    
    static func itemPrice(article:Skin) -> Int{
        let items: [String] = UserDefaults.standard.array(forKey: Keys.yourItem.rawValue) as? [String] ?? [] as [String]
        for item in items {
            if item == article.name {
                return 0
            }
        }
        return article.coin
    }
    
    static let skins:[Skin] = [
        Skin(name: "face1",image: "face1",num: 001,coin: 55),
        Skin(name: "face2",image: "face2",num: 002,coin: 11),
        Skin(name: "face3",image: "face3",num: 003,coin: 22),
        Skin(name: "face4",image: "face4",num: 004,coin: 33),
        Skin(name: "face5",image: "face5",num: 005,coin: 44),
        
    ]
}
