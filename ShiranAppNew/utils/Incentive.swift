
import Foundation
import SwiftUI

struct incentive{
    var dataCounter: DataCounter
    func getCoin()->Int{
        let inc = Int(Float(UserDefaults.standard.integer(forKey: Keys.level.rawValue)) * 10.0 * Float.random(in: 1.0..<3.0))
        self.dataCounter.countedCoin += inc
        UserDefaults.standard.set(self.dataCounter.countedCoin, forKey: Keys.coin.rawValue)
        return inc
    }
    func getDia(num:Int){
        self.dataCounter.countedDiamond += num
        UserDefaults.standard.set(self.dataCounter.countedDiamond, forKey: Keys.diamond.rawValue)
    }
}
