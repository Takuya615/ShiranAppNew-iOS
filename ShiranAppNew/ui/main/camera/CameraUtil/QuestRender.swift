
import Foundation
import UIKit
import SwiftUI
import AVFoundation

struct DaylyRender{
    static func show(pose:Pose,cgContext:CGContext) {
        for segment in PoseImageView.jointSegments {
            let jointA = pose[segment.jointA]
            let jointB = pose[segment.jointB]
            guard jointA.isValid, jointB.isValid else {continue}
            PoseImageView.drawLine(from: jointA,to: jointB,in: cgContext,color:Colors.line0,line:8)
        }
        for joint in pose.joints.values.filter({ $0.isValid }) {
            PoseImageView.draw(circle: joint, in:cgContext,color: Colors.dot0,line:16)
        }
    }
    //デイリー
    static func daily(jump:Bool,gameStart:Bool,pose: Pose,size: CGSize, in cgContext: CGContext)->Bool{
        var sta = 1.0
        switch UserDefaults.standard.integer(forKey: Keys.difficult.rawValue) {
        case 2 : sta = 5/6//  Hard Mode
        case 3 : sta = 4/6//  VeryHard Mode
        default: return jump//     Nomal Mode
        }
        if jump {
            let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height*sta)
            cgContext.setAlpha(0.2)
            cgContext.fill(rectangle)
            if !gameStart {return jump}
            let left = pose[.leftAnkle].position.y
            let right = pose[.rightAnkle].position.y
            if left < size.height*sta && right < size.height*sta {
                //qScore+=1
                SystemSounds.score_up("")
                return false
            }
        }else{
            let rectangle = CGRect(x: 0, y: size.height*7/8, width: size.width, height: size.height/8)
            cgContext.setAlpha(0.2)
            cgContext.fill(rectangle)
            if !gameStart {return jump}
            let leftW = pose[.leftWrist]
            let rightW = pose[.rightWrist]
            
            if leftW.position.y > size.height*7/8 && rightW.position.y > size.height*7/8 {
                let lh = pose[.leftHip].confidence
                let lk = pose[.leftKnee].confidence
                let la = pose[.leftAnkle].confidence
                let rh = pose[.rightHip].confidence
                let rk = pose[.rightKnee].confidence
                let ra = pose[.rightAnkle].confidence
                if lh+lk+la+rh+rk+ra < 2.4 {
                    //qScore+=1
                    SystemSounds.score_up("")
                    return true
                    
                }
                //if lh+lk+la+rh+rk+ra < 3.0 {SystemSounds().buttonVib("")}
                /*let angleR = angle(firstLandmark: pose[.rightShoulder],
                 midLandmark: pose[.rightElbow],
                 lastLandmark: rightW)
                 let angleL = angle(firstLandmark: pose[.leftShoulder],
                 midLandmark: pose[.leftElbow],
                 lastLandmark: leftW)
                 if angleL < 150 || angleR < 90 {
                 
                 }*/
                
            }
        }
        return jump
    }
//    func angle(
//        firstLandmark: Joint,
//        midLandmark: Joint,
//        lastLandmark: Joint
//    ) -> CGFloat {
//        let radians: CGFloat =
//        atan2(lastLandmark.position.y - midLandmark.position.y,
//              lastLandmark.position.x - midLandmark.position.x) -
//        atan2(firstLandmark.position.y - midLandmark.position.y,
//              firstLandmark.position.x - midLandmark.position.x)
//        var degrees = radians * 180.0 / .pi
//        degrees = abs(degrees) // Angle should never be negative
//        if degrees > 180.0 {
//            degrees = 360.0 - degrees // Always get the acute representation of the angle
//        }
//        return degrees
//    }


    
}

class QuestRender{
    var qScore: Int = 0
    private var qPlace :CGPoint = CGPoint()
    private let questNo:Int = UserDefaults.standard.integer(forKey: Keys.questNum.rawValue)
    
    func show(pre:Pose, pose:Pose,size: CGSize,cgContext:CGContext){
        switch questNo {
        case 1: quest1(pose: pose, size: size, in: cgContext)
        case 3: quest3(pre: pre, pose: pose, size: size, in: cgContext)
        case 4: quest4(pre: pre, pose: pose, size: size, in: cgContext)
            
        default: return
        }
    }
    
    //coins
    func quest1( pose:Pose, size: CGSize, in cgContext: CGContext){
        //if !pose[.leftAnkle].isValid || !pose[.rightAnkle].isValid {return}
        //var qPlace = pre

        if qPlace.y == 0 {
            let places: [CGPoint] = [CGPoint(x: size.width/6,y: size.height*1/6),
                                     CGPoint(x: size.width/6,y: size.height*3/6),
                                     CGPoint(x: size.width/6,y: size.height*5/6),
                                     CGPoint(x: size.width*3/6,y: size.height*1/6),
                                     CGPoint(x: size.width*3/6,y: size.height*3/6),
                                     CGPoint(x: size.width*3/6,y: size.height*5/6),
                                     CGPoint(x: size.width*5/6,y: size.height*1/6),
                                     CGPoint(x: size.width*5/6,y: size.height*3/6),
                                     CGPoint(x: size.width*5/6,y: size.height*5/6),]
            self.qPlace = places.randomElement() ?? CGPoint(x: -100, y: 0)
        }
        let left = pose[.leftWrist].position
        let l_diff = abs(qPlace.x - left.x) + abs(qPlace.y - left.y)
        if l_diff < 40 { qPlace = CGPoint(x: -100, y: 0); qScore += 1; SystemSounds.score_up("")}
        let right = pose[.rightWrist].position
        let r_diff = abs(qPlace.x - right.x) + abs(qPlace.y - right.y)
        if r_diff < 40 { qPlace = CGPoint(x: -100, y: 0); qScore += 1; SystemSounds.score_up("")}

        let rectangle = CGRect(x: qPlace.x - 30, y: -qPlace.y - 30,
                               width: 90, height: 90)
        //let drawingRect = CGRect(x: 0, y: -image.height, width: image.width, height: image.height)
        let cgImage = UIImage(named: "coin")?.cgImage//flipVertical().cgImage
        cgContext.scaleBy(x: 1.0, y: -1.0)
        cgContext.draw(cgImage!, in: rectangle)
        //cgContext.restoreGState()
    }
    
    //climbing
    func quest3(pre: Pose,pose: Pose,size: CGSize, in cgContext: CGContext){

        let leftE = pose[.leftElbow].position.y - pre[.leftElbow].position.y
        let rightE = pose[.rightElbow].position.y - pre[.rightElbow].position.y
        let leftK = pose[.leftKnee].position.y - pre[.leftKnee].position.y
        let rightK = pose[.rightKnee].position.y - pre[.rightKnee].position.y
        if leftE > 0 && rightK > 0 { qScore += Int((leftE/2 + rightK)/10); qPlace.y += leftE*2 + rightK*4 }
        if leftK > 0 && rightE > 0 { qScore += Int((leftK + rightE/2)/10); qPlace.y += leftK*4 + rightE*2}

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
    func quest4(pre: Pose,pose: Pose,size: CGSize, in cgContext: CGContext){

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
        qScore += Int(sTime/10)
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


}
