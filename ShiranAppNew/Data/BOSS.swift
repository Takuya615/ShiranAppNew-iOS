//
//  BOSS.swift
//  ShiranAppNew
//
//  Created by user on 2021/09/30.
//

import Foundation
import SwiftUI


class BOSS {
    
    func isExist() -> boss?{
        //let user = UserDefaults.standard
        /*デイリーなのかチェックする
        let today = Date()
        //let LastTimeDay = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let LastTimeDay: Date? = user.object(forKey: DataCounter()._LastTimeDay) as? Date
        if LastTimeDay == nil {return nil}//　初めて使う時は、敵が出てこない。
        let cal = Calendar(identifier: .gregorian)
        let todayDC = Calendar.current.dateComponents([.year, .month,.day], from: today)
        let lastDC = Calendar.current.dateComponents([.year, .month,.day], from: LastTimeDay!)
        let diff = cal.dateComponents([.day], from: lastDC, to: todayDC)
        if diff.day == 0 { return nil }*/
        
        //BOSSと戦闘中？？
        /*let list = bossList()
        //UserDefaults.standard.set( 3 , forKey: DataCounter().bossNum)
        //return list[3]
        let bossNum = user.integer(forKey: DataCounter().bossNum)
        //let damage = user.integer(forKey: DataCounter().damage)
        if bossNum > 0 { return list[bossNum] }
        
        //新規BOSS？？
        let total = user.integer(forKey: DataCounter().totalDay)
        for i in 1 ... list.count-1 {
            if total == list[i].encount {
                user.set( i , forKey: DataCounter().bossNum)
                return list[i]
            }
        }*/
        
        let enemyList = enemyList()
        return enemyList.randomElement()
    }
    
    func newBoss() -> boss? {
        return enemyList().randomElement()
    }

    func showBOSS(boss:boss) -> UIAlertController{
        let message = "STARTすると、下にテキHPがでます\n０になるまで運動しましょう"
        let alert: UIAlertController = UIAlertController(title: boss.name, message:  message, preferredStyle:  UIAlertController.Style.alert)
        let confirmAction: UIAlertAction = UIAlertAction(title: "チャレンジ", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
        })
        alert.addAction(confirmAction)
        
        let imageView = UIImageView(frame: CGRect(x:100, y:-75, width:100, height:100))
        imageView.image = UIImage(named: boss.image)
        alert.view.addSubview(imageView)
        
        return alert
    }
    
    
    
    /*
    func damage(score:Int) -> Int{
        var bossHP = UserDefaults.standard.integer(forKey: DataCounter().bossHP)
        bossHP = bossHP - score
        UserDefaults.standard.set(bossHP, forKey: DataCounter().bossHP)
        return bossHP
    }*/
    
    func enemyList() -> [boss]{
        return [
            boss.init(image: "enemy1", name: "スライム", maxHp: 30.0, encount: 0, bonus: 50),
            boss.init(image: "enemy1", name: "スライム", maxHp: 40.0, encount: 0, bonus: 50),
            boss.init(image: "enemy1", name: "スライム", maxHp: 40.0, encount: 0, bonus: 50),
            boss.init(image: "enemy1", name: "スライム", maxHp: 40.0, encount: 0, bonus: 50),
            boss.init(image: "enemy1", name: "スライム", maxHp: 40.0, encount: 0, bonus: 50),
            boss.init(image: "enemy1", name: "スライム", maxHp: 40.0, encount: 0, bonus: 50),
            boss.init(image: "enemy1", name: "スライム", maxHp: 40.0, encount: 0, bonus: 50),
            boss.init(image: "enemy1", name: "スライム", maxHp: 30.0, encount: 0, bonus: 50),
            boss.init(image: "enemy1", name: "スライム", maxHp: 30.0, encount: 0, bonus: 50),
            boss.init(image: "enemy1", name: "スライム", maxHp: 120.0, encount: 0, bonus: 500),
            
            boss.init(image: "enemy2", name: "おばけ", maxHp: 40.0, encount: 0, bonus: 80),
            boss.init(image: "enemy2", name: "おばけ", maxHp: 40.0, encount: 0, bonus: 80),
            boss.init(image: "enemy2", name: "おばけ", maxHp: 50.0, encount: 0, bonus: 80),
            boss.init(image: "enemy2", name: "おばけ", maxHp: 50.0, encount: 0, bonus: 80),
            boss.init(image: "enemy2", name: "おばけ", maxHp: 50.0, encount: 0, bonus: 80),
            boss.init(image: "enemy2", name: "おばけ", maxHp: 20.0, encount: 0, bonus: 80),
            
            boss.init(image: "enemy3", name: "コブラ", maxHp: 60.0, encount: 0, bonus: 100),
            boss.init(image: "enemy3", name: "コブラ", maxHp: 60.0, encount: 0, bonus: 100),
            boss.init(image: "enemy3", name: "コブラ", maxHp: 80.0, encount: 0, bonus: 100),
            boss.init(image: "enemy3", name: "コブラ", maxHp: 80.0, encount: 0, bonus: 100),
            boss.init(image: "enemy3", name: "コブラ", maxHp: 40.0, encount: 0, bonus: 100),
            
            boss.init(image: "enemy4", name: "あばれ牛", maxHp: 100.0, encount: 0, bonus: 300),
            boss.init(image: "enemy5", name: "あばれグマ", maxHp: 120.0, encount: 0, bonus: 400),
        ]
    }
    
    func bossList() -> [boss]{
        //let tot = UserDefaults.standard.integer(forKey: DataCounter().totalDay)
        return [
            boss.init(image: "", name: "", maxHp: 0.0, encount: -1, bonus: 0),
            boss.init(image: "boss1", name: "BOSS", maxHp: 630.0, encount: 6, bonus: 700),
            boss.init(image: "boss1", name: "BOSS", maxHp: 900.0, encount: 12, bonus: 1000),
            boss.init(image: "boss2", name: "BOSS", maxHp: 1170.0, encount: 18, bonus: 1200),
            boss.init(image: "boss2", name: "BOSS", maxHp: 1440.0, encount: 24, bonus: 1500),
            boss.init(image: "boss2", name: "BOSS", maxHp: 1710.0, encount: 30, bonus: 1800)
        ]
    }
}

struct boss: Identifiable {
    var id = UUID()     // ユニークなIDを自動で設定¥
    var image: String
    var name: String
    var maxHp: Float
    var encount: Int  //TotalDayがこの数字と同じになった時、BOSSがエンカウントする
    var bonus: Int
}
