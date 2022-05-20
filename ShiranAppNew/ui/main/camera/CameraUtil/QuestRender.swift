
import SwiftUI

class QuestRender{
    //var qScore: CGFloat = 0.0
    private var qPlace :CGPoint = CGPoint()
    func show(model: QuestCameraViewModel, pose:Pose,size: CGSize,cgContext:CGContext){
        switch UserDefaults.standard.integer(forKey: Keys.questType .rawValue) {
        case 1: quest1(model:model,pose: pose, size: size, in: cgContext)
        case 3: quest3(model:model,pre: model.prePose, pose: pose, size: size, in: cgContext)
        case 4: quest4(model:model, pose: pose, size: size, in: cgContext)
        case 5: quest5(model:model, pose: pose, size: size, in: cgContext)
        default: return
        }
    }
    
    //coins
    func quest1(model:QuestCameraViewModel, pose:Pose, size: CGSize, in cgContext: CGContext){
        if qPlace.y == 0 {
            let places: [CGPoint] = [CGPoint(x: size.width*2/6,y: size.height*2/6),
                                     CGPoint(x: size.width*2/6,y: size.height*3/6),
                                     CGPoint(x: size.width*2/6,y: size.height*5/6),
                                     CGPoint(x: size.width*3/6,y: size.height*2/6),
                                     CGPoint(x: size.width*3/6,y: size.height*3/6),
                                     CGPoint(x: size.width*3/6,y: size.height*5/6),
                                     CGPoint(x: size.width*5/6,y: size.height*2/6),
                                     CGPoint(x: size.width*5/6,y: size.height*3/6),
                                     CGPoint(x: size.width*5/6,y: size.height*5/6),]
            qPlace = places.randomElement() ?? CGPoint(x: -100, y: 0)
        }
        let rectangle = CGRect(x: qPlace.x - 30, y: -qPlace.y - 30,
                               width: 90, height: 90)
        let cgImage = UIImage(named: "coin")?.cgImage
        cgContext.scaleBy(x: 1.0, y: -1.0)
        cgContext.draw(cgImage!, in: rectangle)
        
        if model.isRecording {return}
        let left = pose[.leftWrist].position
        let l_diff = abs(qPlace.x - left.x) + abs(qPlace.y - left.y)
        if l_diff < 40 { qPlace = CGPoint(x: -100, y: 0); model.qScore += 1; SystemSounds.score_up("")}
        let right = pose[.rightWrist].position
        let r_diff = abs(qPlace.x - right.x) + abs(qPlace.y - right.y)
        if r_diff < 40 { qPlace = CGPoint(x: -100, y: 0); model.qScore += 1; SystemSounds.score_up("")}
    }
    
    //climbing
    func quest3(model:QuestCameraViewModel,pre:Pose,pose: Pose,size: CGSize, in cgContext: CGContext){
        let leftE = pose[.leftElbow].position.y - pre[.leftElbow].position.y
        let rightE = pose[.rightElbow].position.y - pre[.rightElbow].position.y
        let leftK = pose[.leftKnee].position.y - pre[.leftKnee].position.y
        let rightK = pose[.rightKnee].position.y - pre[.rightKnee].position.y
       if leftE > 0 && rightK > 0 { model.qScore += (leftE/2 + rightK)/10; qPlace.y += leftE*2 + rightK*4 }
        if leftK > 0 && rightE > 0 { model.qScore += (leftK + rightE/2)/10; qPlace.y += leftK*4 + rightE*2}

        let cgImage = UIImage(named: "rockwall")?.cgImage
        let rectangle = CGRect(x:0, y:qPlace.y-size.height, width:size.width, height:size.height)
        let rectangle2 = CGRect(x:0, y:qPlace.y, width:size.width, height:size.height)
        cgContext.setAlpha(0.5)
        cgContext.draw(cgImage!, in: rectangle)
        cgContext.draw(cgImage!,in: rectangle2)
        if qPlace.y > size.height {qPlace.y = 0}
    }
    
    //skating
    private var co:CGFloat = 0.0
    private var sTime: CGFloat = 0.0
    private var flg = 0
    private var leftside = true
    func quest4(model:QuestCameraViewModel,pose: Pose,size: CGSize, in cgContext: CGContext){

        let leftA = pose[.leftKnee].position
        let rightA = pose[.rightKnee].position
        let diff = leftA.y - rightA.y
        var newflg = 1
        if diff<0 {newflg = 1}else{newflg = -1}
        if newflg != flg {//足が切り替わった
            //print("切り替わった")
            flg = newflg
            co = 0.0
        }
        sTime = -0.4*co*co + 4.0*co + 1.0
        if sTime < 0.0 || 20 > abs(diff) {sTime = 0.0}
        co += 1.0

        qPlace.y += sTime
        model.qScore += sTime/10
        let back = UIImage(named: "skate_back")?.cgImage//flipVertical().cgImage
        let rectangle = CGRect(x:0, y:-size.height, width:size.width, height:size.height/2)
        cgContext.setAlpha(0.5)
        cgContext.scaleBy(x: 1.0, y: -1.0)
        cgContext.draw(back!, in: rectangle)

        cgContext.setFillColor(CGColor(red: 0.9, green: 1.0, blue: 1.0, alpha: 0.8))
        cgContext.fill(CGRect(x: 0, y: size.height*1/2, width: size.width, height: size.height/2))

        let cgImage = UIImage(named: "icerock")?.cgImage//flipVertical().cgImage
        let si = 200-qPlace.y//画像サイズ
        //if size.height*2/3 > size.height - si - qPlace.y {print("リセット"); qPlace = CGPoint(x: 0,y: 0)}
        if si < 0 {qPlace = CGPoint(x: 0,y: 0); leftside = !leftside}
        var r = qPlace.y/2
        if !leftside { r = size.width - 200 + qPlace.y/2 }
        let rectangle2 = CGRect(x: r , y:-size.height+100 + qPlace.y, width:si, height:si)
        cgContext.setAlpha(0.9)
        cgContext.draw(cgImage!, in: rectangle2)
    }
    
    func quest5(model:QuestCameraViewModel,pose: Pose,size: CGSize, in cgContext: CGContext){

        
    }

}
