//
//  Incentive.swift
//  ShiranAppNew
//
//  Created by user on 2022/02/19.
//

import Foundation

class incentive{
    static func getCoin(score:Int)->Int{
        let nowMoney = UserDefaults.standard.integer(forKey: Keys.coin.rawValue)
        UserDefaults.standard.set(nowMoney+(score/100), forKey: Keys.coin.rawValue)
        return score/100
    }
    
}
