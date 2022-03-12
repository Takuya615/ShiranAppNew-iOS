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
        let enemyList = enemyList()
        return enemyList.randomElement()
    }
    
    func newBoss() -> boss? {
        return enemyList().randomElement()
    }

    func showBOSS(boss:boss) -> UIAlertController{
        let message = str.dialogBossText.rawValue
        let alert: UIAlertController = UIAlertController(title: boss.name, message:  message, preferredStyle:  UIAlertController.Style.alert)
        let confirmAction: UIAlertAction = UIAlertAction(title: str.challenge.rawValue, style: UIAlertAction.Style.default, handler:{
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
        let time = UserDefaults.standard.integer(forKey: Keys.taskTime.rawValue)
        if time < 10 {
            return[
                boss.init(image: "enemy1", name: "スライム", maxHp: 50.0, encount: 0, bonus: 50),
                boss.init(image: "enemy1", name: "スライム", maxHp: 60.0, encount: 0, bonus: 60),
                boss.init(image: "enemy1", name: "スライム", maxHp: 70.0, encount: 0, bonus: 70),
                boss.init(image: "enemy1", name: "スライム", maxHp: 70.0, encount: 0, bonus: 80),
                boss.init(image: "enemy1", name: "スライム", maxHp: 70.0, encount: 0, bonus: 90),
                boss.init(image: "enemy2", name: "おばけ", maxHp: 80.0, encount: 0, bonus: 80),
                boss.init(image: "enemy2", name: "おばけ", maxHp: 90.0, encount: 0, bonus: 90),
                boss.init(image: "enemy3", name: "コブラ", maxHp: 100.0, encount: 0, bonus: 100),
            ]
        }else if time > 30 {
            return[
             boss.init(image: "enemy2", name: "おばけ", maxHp: 100.0, encount: 0, bonus: 100),
             boss.init(image: "enemy2", name: "おばけ", maxHp: 110.0, encount: 0, bonus: 110),
             boss.init(image: "enemy2", name: "おばけ", maxHp: 120.0, encount: 0, bonus: 120),
             boss.init(image: "enemy2", name: "おばけ", maxHp: 130.0, encount: 0, bonus: 130),
             
             boss.init(image: "enemy3", name: "コブラ", maxHp: 170.0, encount: 0, bonus: 170),
             boss.init(image: "enemy3", name: "コブラ", maxHp: 180.0, encount: 0, bonus: 180),
             boss.init(image: "enemy3", name: "コブラ", maxHp: 190.0, encount: 0, bonus: 190),
             boss.init(image: "enemy3", name: "コブラ", maxHp: 200.0, encount: 0, bonus: 200),
             
             boss.init(image: "enemy4", name: "あばれ牛", maxHp: 500.0, encount: 0, bonus: 500),
             boss.init(image: "enemy5", name: "あばれグマ", maxHp: 1000.0, encount: 0, bonus: 1000),
            ]
            
        }
        
        return [
            boss.init(image: "enemy1", name: "スライム", maxHp: 50.0, encount: 0, bonus: 50),
            boss.init(image: "enemy1", name: "スライム", maxHp: 60.0, encount: 0, bonus: 60),
            boss.init(image: "enemy1", name: "スライム", maxHp: 70.0, encount: 0, bonus: 70),
            boss.init(image: "enemy1", name: "スライム", maxHp: 80.0, encount: 0, bonus: 80),
            boss.init(image: "enemy1", name: "スライム", maxHp: 90.0, encount: 0, bonus: 90),
            boss.init(image: "enemy1", name: "スライム", maxHp: 100.0, encount: 0, bonus: 100),
            boss.init(image: "enemy1", name: "スライム", maxHp: 110.0, encount: 0, bonus: 110),
            boss.init(image: "enemy1", name: "スライム", maxHp: 120.0, encount: 0, bonus: 120),
            boss.init(image: "enemy1", name: "スライム", maxHp: 130.0, encount: 0, bonus: 130),
            boss.init(image: "enemy1", name: "スライム", maxHp: 140.0, encount: 0, bonus: 140),
            
            boss.init(image: "enemy2", name: "おばけ", maxHp: 80.0, encount: 0, bonus: 80),
            boss.init(image: "enemy2", name: "おばけ", maxHp: 90.0, encount: 0, bonus: 90),
            boss.init(image: "enemy2", name: "おばけ", maxHp: 100.0, encount: 0, bonus: 100),
            boss.init(image: "enemy2", name: "おばけ", maxHp: 110.0, encount: 0, bonus: 110),
            boss.init(image: "enemy2", name: "おばけ", maxHp: 120.0, encount: 0, bonus: 120),
            boss.init(image: "enemy2", name: "おばけ", maxHp: 130.0, encount: 0, bonus: 130),
            
            boss.init(image: "enemy3", name: "コブラ", maxHp: 160.0, encount: 0, bonus: 160),
            boss.init(image: "enemy3", name: "コブラ", maxHp: 170.0, encount: 0, bonus: 170),
            boss.init(image: "enemy3", name: "コブラ", maxHp: 180.0, encount: 0, bonus: 180),
            boss.init(image: "enemy3", name: "コブラ", maxHp: 190.0, encount: 0, bonus: 190),
            boss.init(image: "enemy3", name: "コブラ", maxHp: 200.0, encount: 0, bonus: 200),
            
            //boss.init(image: "enemy4", name: "あばれ牛", maxHp: 500.0, encount: 0, bonus: 500),
            //boss.init(image: "enemy5", name: "あばれグマ", maxHp: 1000.0, encount: 0, bonus: 1000),
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
