
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
        switch time {
        case 31...240 :
            return[
                boss.init(image: "enemy2", name: "おばけ", maxHp: 500.0, encount: 0, bonus: 500),
                boss.init(image: "enemy2", name: "おばけ", maxHp: 500.0, encount: 0, bonus: 500),
                boss.init(image: "enemy2", name: "おばけ", maxHp: 500.0, encount: 0, bonus: 500),
                boss.init(image: "enemy2", name: "おばけ", maxHp: 500.0, encount: 0, bonus: 500),
                boss.init(image: "enemy3", name: "コブラ", maxHp: 600.0, encount: 0, bonus: 600),
                boss.init(image: "enemy3", name: "コブラ", maxHp: 700.0, encount: 0, bonus: 700),
                boss.init(image: "enemy3", name: "コブラ", maxHp: 700.0, encount: 0, bonus: 700),
                boss.init(image: "enemy3", name: "コブラ", maxHp: 800.0, encount: 0, bonus: 800),
                boss.init(image: "enemy4", name: "あばれ牛", maxHp: 1100.0, encount: 0, bonus: 1100),
                boss.init(image: "enemy5", name: "あばれグマ", maxHp: 1700.0, encount: 0, bonus: 1700),
            ]
        
        default:
            return[
                boss.init(image: "enemy1", name: "スライム", maxHp:230, encount: 0, bonus: 230),
                boss.init(image: "enemy1", name: "スライム", maxHp:240, encount: 0, bonus: 240),
                boss.init(image: "enemy1", name: "スライム", maxHp:250, encount: 0, bonus: 250),
                boss.init(image: "enemy1", name: "スライム", maxHp:260, encount: 0, bonus: 260),
                boss.init(image: "enemy1", name: "スライム", maxHp:270, encount: 0, bonus: 270),
                boss.init(image: "enemy2", name: "おばけ", maxHp: 300, encount: 0, bonus: 300),
                boss.init(image: "enemy2", name: "おばけ", maxHp: 350, encount: 0, bonus: 350),
//                boss.init(image: "enemy3", name: "コブラ", maxHp: 100.0, encount: 0, bonus: 400),
            ]
        }
        
    }
    
//    func bossList() -> [boss]{
//        //let tot = UserDefaults.standard.integer(forKey: DataCounter().totalDay)
//        return [
//            boss.init(image: "", name: "", maxHp: 0.0, encount: -1, bonus: 0),
//            boss.init(image: "boss1", name: "BOSS", maxHp: 630.0, encount: 6, bonus: 700),
//            boss.init(image: "boss1", name: "BOSS", maxHp: 900.0, encount: 12, bonus: 1000),
//            boss.init(image: "boss2", name: "BOSS", maxHp: 1170.0, encount: 18, bonus: 1200),
//            boss.init(image: "boss2", name: "BOSS", maxHp: 1440.0, encount: 24, bonus: 1500),
//            boss.init(image: "boss2", name: "BOSS", maxHp: 1710.0, encount: 30, bonus: 1800)
//        ]
//    }
}

struct boss: Identifiable {
    var id = UUID()     // ユニークなIDを自動で設定¥
    var image: String
    var name: String
    var maxHp: Float
    var encount: Int  //TotalDayがこの数字と同じになった時、BOSSがエンカウントする
    var bonus: Int
}
