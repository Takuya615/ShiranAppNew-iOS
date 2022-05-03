

import Foundation
import SwiftUI


struct ShopViewModel{
    
    static func checkCanBuy(price:Int,dia:Int?) -> Bool{
        if dia != nil {
            let diamond = UserDefaults.standard.integer(forKey: Keys.diamond.rawValue)
            if diamond < dia! {
                return false
            }
        }else{
            let coin = UserDefaults.standard.integer(forKey: Keys.coin.rawValue)
            if coin < price {
                return false
            }
        }
        return true
    }
    
    static func buy(parts:String,id articleId:Int,coin articleCoin:Int,dia articleDia:Int?) -> (Int,Bool){
        var your = ""
        var select = ""
        if parts == "Body" {
            your = Keys.yourBodys.rawValue
            select = Keys.selectBody.rawValue
        }else{
            your = Keys.yourItem.rawValue
            select = Keys.selectSkin.rawValue
        }
        if articleDia != nil {
            var diamonds = UserDefaults.standard.integer(forKey: Keys.diamond.rawValue)
            diamonds -= articleDia!
            var items: [Int] = UserDefaults.standard.array(forKey: your) as? [Int] ?? [0] as [Int]
            items.append(articleId)
            UserDefaults.standard.set(diamonds, forKey: Keys.diamond.rawValue)
            UserDefaults.standard.set(items, forKey: your)
            UserDefaults.standard.set(articleId,forKey: select)
            return (diamonds,false)
        }else{
            var coin = UserDefaults.standard.integer(forKey: Keys.coin.rawValue)
            coin -= articleCoin
            var items: [Int] = UserDefaults.standard.array(forKey: your) as? [Int] ?? [0] as [Int]
            items.append(articleId)
            UserDefaults.standard.set(coin, forKey: Keys.coin.rawValue)
            UserDefaults.standard.set(items, forKey: your)
            UserDefaults.standard.set(articleId,forKey: select)
            return (coin,true)
        }
    }
    
    static func getSkins() -> [Skin]{
        let gotItems: [Int] = UserDefaults.standard.array(forKey:Keys.yourItem.rawValue)as? [Int] ?? [0] as [Int]
        var sList = Skin.skins
        var count = 0
        for num in gotItems.sorted() {
            sList.remove(at: num-count)
            count += 1
        }
        return sList
    }
    static func getBodys() -> [Body]{
        let gotItems: [Int] = UserDefaults.standard.array(forKey: Keys.yourBodys.rawValue)as? [Int] ?? [0] as [Int]
        var sList = Body.bodys
        var count = 0
        for num in gotItems.sorted() {
            sList.remove(at: num-count)
            count += 1
        }
        return sList
    }
}
