//
//  ShopViewModel.swift
//  ShiranAppNew
//
//  Created by user on 2022/02/19.
//

import Foundation
import SwiftUI


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
        UserDefaults.standard.set(article.id,forKey: Keys.selectSkin.rawValue)
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
    
    
    
    static func getSkins() -> [Skin]{
        guard let gotItems: [Int] = UserDefaults.standard.array(forKey: Keys.yourItem.rawValue )as? [Int] else {return Skin.skins}
        var sList = Skin.skins
        var count = 0
        for num in gotItems.sorted() {
            sList.remove(at: num-count)
            count += 1
        }
        return sList
    }
}
