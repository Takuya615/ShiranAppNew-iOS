
import Foundation
import SwiftUI

struct incentive{
    static func getCoin(dataCounter: DataCounter)->Int{
//        let inc = Int( 10.0*Float(UserDefaults.standard.integer(forKey: Keys.level.rawValue))*UserDefaults.standard.float(forKey: Keys.rcCoinRate.rawValue)*Float.random(in: 1.0..<3.0))
        var inc = 0
        if UserDefaults.standard.bool(forKey: Keys.exist_quest.rawValue){
            inc = Int(18.0*UserDefaults.standard.float(forKey: Keys.rcCoinRate.rawValue)+Float.random(in: 1.0..<5.0))
        }else{
            inc = Int(30.0*UserDefaults.standard.float(forKey: Keys.rcCoinRate.rawValue)+Float.random(in: 1.0..<5.0))
        }
        dataCounter.countedCoin += inc
        UserDefaults.standard.set(dataCounter.countedCoin, forKey: Keys.coin.rawValue)
        EventAnalytics.earn_virtual_currency(matter: str.coin.rawValue, amount: inc)
        return inc
    }
    static func getDia(dataCounter: DataCounter, num:Float){
        let inc = Int(num)//Int(num * UserDefaults.standard.float(forKey: Keys.rcDiaRate.rawValue))
        dataCounter.countedDiamond += inc
        UserDefaults.standard.set(dataCounter.countedDiamond, forKey: Keys.diamond.rawValue)
        EventAnalytics.earn_virtual_currency(matter: str.diamond.rawValue, amount: inc)
    }
    static func getCoin_for_quest(dataCounter: DataCounter,inc: Int)->Int{//まだクエストの達成率毎に応じて報酬を変化させない
        let coin = Int.random(in: 0...5)
        dataCounter.countedCoin += coin//inc*2
        UserDefaults.standard.set(dataCounter.countedCoin, forKey: Keys.coin.rawValue)
        return coin//inc*2
    }
}
