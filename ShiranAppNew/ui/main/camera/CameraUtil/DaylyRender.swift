
import SwiftUI

struct DailyRender{
    //デイリー
    static func daily(model: VideoCameraViewModel,pose: Pose,size: CGSize, in cgContext: CGContext){
        var sta = 1.0
        cgContext.setFillColor(Colors.cgGreen)
        switch model.difficult {
        case 2 : sta = 5/6//  Hard Mode
        case 3 : sta = 4/6//  VeryHard Mode
        default: return //     Nomal Mode
        }
        if model.jump {
            let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height*sta)
            cgContext.setAlpha(0.2)
            cgContext.fill(rectangle)
            if !model.isRecording {return}
            let left = pose[.leftAnkle].position.y
            let right = pose[.rightAnkle].position.y
            if left < size.height*sta && right < size.height*sta {
                //qScore+=1
                SystemSounds.score_up()
                model.jump = false
            }
        }else{
            let rectangle = CGRect(x: 0, y: size.height*7/8, width: size.width, height: size.height/8)
            cgContext.setAlpha(0.2)
            cgContext.fill(rectangle)
            if !model.isRecording {return}
            let leftW = pose[.leftWrist]
            let rightW = pose[.rightWrist]
            
            if leftW.position.y > size.height*5/6 && rightW.position.y > size.height*5/6 {
                let lh = pose[.leftHip].confidence
                let lk = pose[.leftKnee].confidence
                let la = pose[.leftAnkle].confidence
                let rh = pose[.rightHip].confidence
                let rk = pose[.rightKnee].confidence
                let ra = pose[.rightAnkle].confidence
                if lh+lk+la+rh+rk+ra < 2.4 {
                    //qScore+=1
                    SystemSounds.score_up()
                    model.jump = true
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
    }
    //デフォルト
    static func def(model: DefaultCameraViewModel,pose: Pose,size: CGSize, in cgContext: CGContext){
        var sta = 1.0
        cgContext.setFillColor(Colors.cgGreen)
        switch model.difficult {
        case 2 : sta = 5/6//  Hard Mode
        case 3 : sta = 4/6//  VeryHard Mode
        default: return //     Nomal Mode
        }
        if model.jump {
            let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height*sta)
            cgContext.setAlpha(0.2)
            cgContext.fill(rectangle)
            if !model.isRecording {return}
            let left = pose[.leftAnkle].position.y
            let right = pose[.rightAnkle].position.y
            if left < size.height*sta && right < size.height*sta {
                SystemSounds.score_up()
                model.jump = false
            }
        }else{
            let rectangle = CGRect(x: 0, y: size.height*7/8, width: size.width, height: size.height/8)
            cgContext.setAlpha(0.2)
            cgContext.fill(rectangle)
            if !model.isRecording {return}
            let leftW = pose[.leftWrist]
            let rightW = pose[.rightWrist]
            
            if leftW.position.y > size.height*5/6 && rightW.position.y > size.height*5/6 {
                let lh = pose[.leftHip].confidence
                let lk = pose[.leftKnee].confidence
                let la = pose[.leftAnkle].confidence
                let rh = pose[.rightHip].confidence
                let rk = pose[.rightKnee].confidence
                let ra = pose[.rightAnkle].confidence
                if lh+lk+la+rh+rk+ra < 2.4 {
                    SystemSounds.score_up()
                    model.jump = true
                }
            }
        }
    }
    
    
    //Aboid Bars
    static func dailyQuest(model:VideoCameraViewModel,pose: Pose,size: CGSize, in cgContext: CGContext){
        //flg is time keeper
        let min = size.width/20
        let p = CGPoint(x: (pose[.rightShoulder].position.x + pose[.leftShoulder].position.x)/2, y: pose[.leftShoulder].position.y)
        let rectangle = CGRect(x: p.x - min/2, y: p.y - min/2,width: min, height: min)
        cgContext.setFillColor(Colors.cgPink)
        cgContext.addEllipse(in: rectangle)
        cgContext.drawPath(using: .fill)
        
        if !model.isRecording {return}
        model.flg += 10.0
        let numbers :Int = Int(model.flg) / Int(size.height/3)
        var color = Colors.cgWhite
        for i in 0...numbers {
            let y = model.flg-min/2 - size.height/3*CGFloat(i)
            let obstacle1 = CGRect(x:0, y:y, width:size.width/2, height:min)
            let obstacle2 = CGRect(x:size.width/2, y:size.height-y, width:size.width/2, height:min)
            
            if p.x < size.width/2 {
                let diff = abs(p.y - y)
                if diff < 10 {color = Colors.cgPink;model.qScore += 1}
            }else{
                let diff = abs(p.y - (size.height-y))
                if diff < 10 {color = Colors.cgPink;model.qScore += 1}
            }
            cgContext.setFillColor(color)
            cgContext.addRect(obstacle1)
            cgContext.addRect(obstacle2)
            cgContext.drawPath(using: .fillStroke)
            
        }
    }
    
}
