
import Foundation
import SwiftUI

struct incentive{
    static func getCoin(dataCounter: DataCounter)->Int{
        let inc = Int( 10.0*Float(UserDefaults.standard.integer(forKey: Keys.level.rawValue))*UserDefaults.standard.float(forKey: Keys.rcCoinRate.rawValue)*Float.random(in: 1.0..<3.0))
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
}
