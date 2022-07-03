
import SwiftUI

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
                SystemSounds.score_up("")
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
                    SystemSounds.score_up("")
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
                SystemSounds.score_up("")
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
                    SystemSounds.score_up("")
                    model.jump = true
                }
            }
        }
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
