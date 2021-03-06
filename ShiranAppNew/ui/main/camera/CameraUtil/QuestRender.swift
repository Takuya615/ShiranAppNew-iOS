
import SwiftUI

class QuestRender{
    
    static func show(model: QuestCameraViewModel, pose:Pose,size: CGSize,cgContext:CGContext){
        switch UserDefaults.standard.integer(forKey: Keys.questType .rawValue) {
        case 1: quest1(model:model,pose: pose, size: size, in: cgContext)
        case 3: quest3(model:model,pre: model.prePose, pose: pose, size: size, in: cgContext)
        case 2: quest2(model: model, pose: pose)
            //case 4: quest4(model:model, pose: pose, size: size, in: cgContext)
        case 5: quest5(model:model, pose: pose, size: size, in: cgContext)
        case 6: quest6(model:model, pose: pose, size: size, in: cgContext)
        case 7: quest7(model:model, pose: pose, size: size, in: cgContext)
            //case 8: quest8(model:model, pose: pose, size: size, in: cgContext)
        default: return
        }
    }
    static func randomAct(model: QuestCameraViewModel, callBack: ()->Void){
        if model.qGoal[2]/10 < Int(model.flg) {
            model.flg = 0.0
            if Bool.random() {
                SystemSounds.score_up("")
                callBack()
            }
        }
    }
    
    //coins
    static func quest1(model:QuestCameraViewModel, pose:Pose, size: CGSize, in cgContext: CGContext){
        if model.qPlace.y == 0 {
            let places: [CGPoint] = [CGPoint(x: size.width*1/6,y: size.height*1/4),
                                     CGPoint(x: size.width*1/6,y: size.height*2/4),
                                     CGPoint(x: size.width*1/6,y: size.height*3/4),
                                     CGPoint(x: size.width*3/6,y: size.height*1/4),
                                     CGPoint(x: size.width*3/6,y: size.height*2/4),
                                     CGPoint(x: size.width*3/6,y: size.height*3/4),
                                     CGPoint(x: size.width*5/6,y: size.height*1/4),
                                     CGPoint(x: size.width*5/6,y: size.height*2/4),
                                     CGPoint(x: size.width*5/6,y: size.height*3/4),]
            model.qPlace = places.randomElement() ?? CGPoint(x: -100, y: 0)
        }
        let rectangle = CGRect(x: model.qPlace.x - 30, y: -model.qPlace.y - 30,
                               width: 90, height: 90)
        let cgImage = UIImage(named: "coin")?.cgImage
        cgContext.scaleBy(x: 1.0, y: -1.0)
        cgContext.draw(cgImage!, in: rectangle)
        
        if !model.isRecording {return}
        let left = pose[.leftWrist].position
        let l_diff = abs(model.qPlace.x - left.x) + abs(model.qPlace.y - left.y)
        if l_diff < 40 { model.qPlace = CGPoint(x: -100, y: 0); model.qScore += 1; SystemSounds.score_up("")}
        let right = pose[.rightWrist].position
        let r_diff = abs(model.qPlace.x - right.x) + abs(model.qPlace.y - right.y)
        if r_diff < 40 { model.qPlace = CGPoint(x: -100, y: 0); model.qScore += 1; SystemSounds.score_up("")}
    }
    
    static func quest2(model:QuestCameraViewModel, pose:Pose){
        Joint.Name.allCases.forEach {name in
            if pose.joints[name] != nil && model.prePose.joints[name] != nil{
                if pose.joints[name]!.confidence > 0.1 && model.prePose.joints[name]!.confidence > 0.1 {
                    let disX = abs(pose.joints[name]!.position.x - model.prePose.joints[name]!.position.x)
                    let disY = abs(pose.joints[name]!.position.y - model.prePose.joints[name]!.position.y)
                    model.qScore += (disY+disX)/100
                    
                }
            }
        }
    }
    
    //climbing
    static func quest3(model:QuestCameraViewModel,pre:Pose,pose: Pose,size: CGSize, in cgContext: CGContext){
        let cgImage = UIImage(named: "rockwall")?.cgImage
        let rectangle = CGRect(x:0, y:model.qPlace.y-size.height, width:size.width, height:size.height)
        let rectangle2 = CGRect(x:0, y:model.qPlace.y, width:size.width, height:size.height)
        cgContext.setAlpha(0.5)
        cgContext.draw(cgImage!, in: rectangle)
        cgContext.draw(cgImage!,in: rectangle2)
        
        if !model.isRecording {return}
        let leftE = pose[.leftElbow].position.y - pre[.leftElbow].position.y
        let rightE = pose[.rightElbow].position.y - pre[.rightElbow].position.y
        let leftK = pose[.leftKnee].position.y - pre[.leftKnee].position.y
        let rightK = pose[.rightKnee].position.y - pre[.rightKnee].position.y
        if leftE > 0 && rightK > 0 { model.qScore += (leftE/2 + rightK)/10; model.qPlace.y += leftE*2 + rightK*4 }
        if leftK > 0 && rightE > 0 { model.qScore += (leftK + rightE/2)/10; model.qPlace.y += leftK*4 + rightE*2}
        if model.qPlace.y > size.height {model.qPlace.y = 0}
    }
    //powerCharge
    static func quest5(model:QuestCameraViewModel,pose: Pose,size: CGSize, in cgContext: CGContext){
        let rectangle = CGRect(x: model.qPlace.x, y: 0, width: size.width/2, height: size.height)
        cgContext.setAlpha(0.2)
        cgContext.fill(rectangle)
        cgContext.setFillColor(Colors.cgYellow)
        if !model.isRecording {return}
        randomAct(model: model, callBack: {
            if model.qPlace.x == 0 {
                model.qPlace.x = size.width/2
            }else{
                model.qPlace.x = 0
            }
        })
        
        Joint.Name.allCases.forEach {name in
            if pose.joints[name] != nil && model.prePose.joints[name] != nil{
                if pose.joints[name]!.confidence > 0.1 && model.prePose.joints[name]!.confidence > 0.1 {
                    let disX = abs(pose.joints[name]!.position.x - model.prePose.joints[name]!.position.x)
                    let disY = abs(pose.joints[name]!.position.y - model.prePose.joints[name]!.position.y)
                    //print("??????\(flg)~\(flg + size.width/2)???????????????????????????\(pose.joints[name]!.position.x )")
                    if model.qPlace.x < pose.joints[name]!.position.x && pose.joints[name]!.position.x < model.qPlace.x + size.width/2 {
                        model.qScore += (disY+disX)/100
                        model.flg += (disY+disX)/100
                    }else{
                        model.qScore -= (disY+disX)/100
                    }
                }
            }
        }
    }
    
    static func quest6(model:QuestCameraViewModel,pose: Pose,size: CGSize, in cgContext: CGContext){
        let rectangle = CGRect(x: 0, y: model.qPlace.y, width: size.width, height: size.height/2)
        cgContext.setAlpha(0.2)
        cgContext.fill(rectangle)
        cgContext.setFillColor(Colors.cgYellow)
        if !model.isRecording {return}
        randomAct(model:model, callBack: {
            if model.qPlace.y == 0 {
                model.qPlace.y = size.height/2
            }else{
                model.qPlace.y = 0
            }
        })
        Joint.Name.allCases.forEach {name in
            if pose.joints[name] != nil && model.prePose.joints[name] != nil{
                if pose.joints[name]!.confidence > 0.1 && model.prePose.joints[name]!.confidence > 0.1 {
                    let disX = abs(pose.joints[name]!.position.x - model.prePose.joints[name]!.position.x)
                    let disY = abs(pose.joints[name]!.position.y - model.prePose.joints[name]!.position.y)
                    if model.qPlace.y == 0 {
                        switch name {
                        case .leftHip: model.qScore -= (disY+disX)/100
                        case .leftKnee: model.qScore -= (disY+disX)/100
                        case .leftAnkle: model.qScore -= (disY+disX)/100
                        case .rightHip: model.qScore -= (disY+disX)/100
                        case .rightKnee: model.qScore -= (disY+disX)/100
                        case .rightAnkle: model.qScore -= (disY+disX)/100
                        default: model.qScore += (disY+disX)/25; model.flg += (disY+disX)/25
                        }
                    }else{
                        switch name {
                        case .leftShoulder: model.qScore -= (disY+disX)/100
                        case .leftElbow: model.qScore -= (disY+disX)/100
                        case .leftWrist: model.qScore -= (disY+disX)/100
                        case .rightShoulder: model.qScore -= (disY+disX)/100
                        case .rightElbow: model.qScore -= (disY+disX)/100
                        case .rightWrist: model.qScore -= (disY+disX)/100
                        default: model.qScore += (disY+disX)/25; model.flg += (disY+disX)/25
                        }
                        
                    }
                }
            }
        }
    }
    
    static func quest7(model:QuestCameraViewModel,pose: Pose,size: CGSize, in cgContext: CGContext){
        
        let rectangle = CGRect(x: model.qPlace.x, y: model.qPlace.y, width: size.width/2, height: size.height/2)
        cgContext.setAlpha(0.2)
        cgContext.fill(rectangle)
        cgContext.setFillColor(Colors.cgYellow)
        if !model.isRecording {return}
        randomAct(model: model, callBack: {
            if model.qPlace.x == 0 {
                model.qPlace.x = size.width/2
            }else{
                model.qPlace.x = 0
            }
            if Bool.random() {
                model.qPlace.y = size.height/2
            }else{
                model.qPlace.y = 0
            }
        })
        Joint.Name.allCases.forEach {name in
            if pose.joints[name] != nil && model.prePose.joints[name] != nil{
                if pose.joints[name]!.confidence > 0.1 && model.prePose.joints[name]!.confidence > 0.1 {
                    let disX = abs(pose.joints[name]!.position.x - model.prePose.joints[name]!.position.x)
                    let disY = abs(pose.joints[name]!.position.y - model.prePose.joints[name]!.position.y)
                    if model.qPlace.x < pose.joints[name]!.position.x && pose.joints[name]!.position.x < model.qPlace.x + size.width/2 {
                        if model.qPlace.y == 0 {
                            switch name {
                            case .leftHip: model.qScore -= (disY+disX)/100
                            case .leftKnee: model.qScore -= (disY+disX)/100
                            case .leftAnkle: model.qScore -= (disY+disX)/100
                            case .rightHip: model.qScore -= (disY+disX)/100
                            case .rightKnee: model.qScore -= (disY+disX)/100
                            case .rightAnkle: model.qScore -= (disY+disX)/100
                            default: model.qScore += (disY+disX)/20; model.flg += (disY+disX)/20
                            }
                        }else{
                            switch name {
                            case .leftShoulder: model.qScore -= (disY+disX)/100
                            case .leftElbow: model.qScore -= (disY+disX)/100
                            case .leftWrist: model.qScore -= (disY+disX)/100
                            case .rightShoulder: model.qScore -= (disY+disX)/100
                            case .rightElbow: model.qScore -= (disY+disX)/100
                            case .rightWrist: model.qScore -= (disY+disX)/100
                            default: model.qScore += (disY+disX)/20; model.flg += (disY+disX)/20
                            }
                        }
                    }else{
                        model.qScore -= (disY+disX)/100
                    }
                    
                }
            }
        }
    }
    
    
}
