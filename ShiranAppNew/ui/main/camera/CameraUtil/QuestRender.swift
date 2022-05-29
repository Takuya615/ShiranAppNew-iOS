
import SwiftUI

class QuestRender{
    private var flg = 0.0
    private var flg2 = 0.0
    private var qPlace :CGPoint = CGPoint()
    
    func show(model: QuestCameraViewModel, pose:Pose,size: CGSize,cgContext:CGContext){
        switch UserDefaults.standard.integer(forKey: Keys.questType .rawValue) {
        case 1: quest1(model:model,pose: pose, size: size, in: cgContext)
        case 3: quest3(model:model,pre: model.prePose, pose: pose, size: size, in: cgContext)
        case 2: quest2(model: model, pose: pose)
        case 4: quest4(model:model, pose: pose, size: size, in: cgContext)
        case 5: quest5(model:model, pose: pose, size: size, in: cgContext)
        case 6: quest6(model:model, pose: pose, size: size, in: cgContext)
        case 7: quest7(model:model, pose: pose, size: size, in: cgContext)
        //case 8: quest8(model:model, pose: pose, size: size, in: cgContext)
        default: return
        }
    }
    func randomAct(flg: CGFloat, callBack: ()->Void, callBack2: ()->Void){
        if Int.random(in: 1..<50) == 1 {
            SystemSounds.score_up("")
            if flg == 0 {
                callBack()
            }else{
                callBack2()
            }
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
        
        if !model.isRecording {return}
        let left = pose[.leftWrist].position
        let l_diff = abs(qPlace.x - left.x) + abs(qPlace.y - left.y)
        if l_diff < 40 { qPlace = CGPoint(x: -100, y: 0); model.qScore += 1; SystemSounds.score_up("")}
        let right = pose[.rightWrist].position
        let r_diff = abs(qPlace.x - right.x) + abs(qPlace.y - right.y)
        if r_diff < 40 { qPlace = CGPoint(x: -100, y: 0); model.qScore += 1; SystemSounds.score_up("")}
    }
    
    func quest2(model:QuestCameraViewModel, pose:Pose){
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
    func quest3(model:QuestCameraViewModel,pre:Pose,pose: Pose,size: CGSize, in cgContext: CGContext){
        let cgImage = UIImage(named: "rockwall")?.cgImage
        let rectangle = CGRect(x:0, y:qPlace.y-size.height, width:size.width, height:size.height)
        let rectangle2 = CGRect(x:0, y:qPlace.y, width:size.width, height:size.height)
        cgContext.setAlpha(0.5)
        cgContext.draw(cgImage!, in: rectangle)
        cgContext.draw(cgImage!,in: rectangle2)
        
        if !model.isRecording {return}
        let leftE = pose[.leftElbow].position.y - pre[.leftElbow].position.y
        let rightE = pose[.rightElbow].position.y - pre[.rightElbow].position.y
        let leftK = pose[.leftKnee].position.y - pre[.leftKnee].position.y
        let rightK = pose[.rightKnee].position.y - pre[.rightKnee].position.y
        if leftE > 0 && rightK > 0 { model.qScore += (leftE/2 + rightK)/10; qPlace.y += leftE*2 + rightK*4 }
        if leftK > 0 && rightE > 0 { model.qScore += (leftK + rightE/2)/10; qPlace.y += leftK*4 + rightE*2}
        if qPlace.y > size.height {qPlace.y = 0}
    }
    
    //skating
    private var co:CGFloat = 0.0
    private var sTime: CGFloat = 0.0
    private var leftside = true
    func quest4(model:QuestCameraViewModel,pose: Pose,size: CGSize, in cgContext: CGContext){
        
        let leftA = pose[.leftKnee].position
        let rightA = pose[.rightKnee].position
        let diff = leftA.y - rightA.y
        var newflg = 1.0
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
        let rectangle = CGRect(x: flg, y: 0, width: size.width/2, height: size.height)
        cgContext.setAlpha(0.2)
        cgContext.fill(rectangle)
        
        if !model.isRecording {return}
        randomAct(flg: flg, callBack: {flg = size.width/2},callBack2: {flg = 0})
        Joint.Name.allCases.forEach {name in
            if pose.joints[name] != nil && model.prePose.joints[name] != nil{
                if pose.joints[name]!.confidence > 0.1 && model.prePose.joints[name]!.confidence > 0.1 {
                    let disX = abs(pose.joints[name]!.position.x - model.prePose.joints[name]!.position.x)
                    let disY = abs(pose.joints[name]!.position.y - model.prePose.joints[name]!.position.y)
                    //print("範囲\(flg)~\(flg + size.width/2)、今のポジションは\(pose.joints[name]!.position.x )")
                    if flg < pose.joints[name]!.position.x && pose.joints[name]!.position.x < flg + size.width/2 {
                        model.qScore += (disY+disX)/100
                    }else{
                        model.qScore -= (disY+disX)/100
                    }
                }
            }
        }
    }
    
    func quest6(model:QuestCameraViewModel,pose: Pose,size: CGSize, in cgContext: CGContext){
        let rectangle = CGRect(x: 0, y: flg, width: size.width, height: size.height/2)
        cgContext.setAlpha(0.2)
        cgContext.fill(rectangle)
        
        if !model.isRecording {return}
        randomAct(flg:flg, callBack: {flg = size.height/2},callBack2: {flg = 0})
        Joint.Name.allCases.forEach {name in
            if pose.joints[name] != nil && model.prePose.joints[name] != nil{
                if pose.joints[name]!.confidence > 0.1 && model.prePose.joints[name]!.confidence > 0.1 {
                    let disX = abs(pose.joints[name]!.position.x - model.prePose.joints[name]!.position.x)
                    let disY = abs(pose.joints[name]!.position.y - model.prePose.joints[name]!.position.y)
                    if flg == 0 {
                        switch name {
                        case .leftHip: model.qScore -= (disY+disX)/100
                        case .leftKnee: model.qScore -= (disY+disX)/100
                        case .leftAnkle: model.qScore -= (disY+disX)/100
                        case .rightHip: model.qScore -= (disY+disX)/100
                        case .rightKnee: model.qScore -= (disY+disX)/100
                        case .rightAnkle: model.qScore -= (disY+disX)/100
                        default: model.qScore += (disY+disX)/25
                        }
                    }else{
                        switch name {
                        case .leftShoulder: model.qScore -= (disY+disX)/100
                        case .leftElbow: model.qScore -= (disY+disX)/100
                        case .leftWrist: model.qScore -= (disY+disX)/100
                        case .rightShoulder: model.qScore -= (disY+disX)/100
                        case .rightElbow: model.qScore -= (disY+disX)/100
                        case .rightWrist: model.qScore -= (disY+disX)/100
                        default: model.qScore += (disY+disX)/25
                        }
                        
                    }
                }
            }
        }
    }
    
//    func quest6(model:QuestCameraViewModel,pose: Pose,size: CGSize, in cgContext: CGContext){
//        let udRect = CGRect(x: size.width/4 - qPlace.x/2, y: size.height*6/8, width: qPlace.x, height: qPlace.x)
//        let rlRect = CGRect(x: size.width*3/4 - qPlace.y/2, y: size.height*6/8, width: qPlace.y, height: qPlace.y)
//        cgContext.setFillColor(Colors.cgGreen)
//        cgContext.setAlpha(0.5)
//        if flg == 0 {
//            cgContext.fill(udRect)
//            qPlace = CGPoint(x: size.width/5,y: size.width/10)
//        }else{
//            cgContext.fill(rlRect)
//            qPlace = CGPoint(x: size.width/10,y: size.width/5)
//        }
//        cgContext.setAlpha(1.0)
//        cgContext.draw( UIImage(systemName: "arrow.up.and.down.circle")!.cgImage! ,in: udRect)
//        cgContext.draw( UIImage(systemName: "arrow.left.and.right.circle")!.cgImage! ,in: rlRect)
//
//
//        if !model.isRecording {return}
//        Joint.Name.allCases.forEach {name in
//            if pose.joints[name] != nil && model.prePose.joints[name] != nil{
//                if pose.joints[name]!.confidence > 0.1 && model.prePose.joints[name]!.confidence > 0.1 {
//                    let disY = abs(pose.joints[name]!.position.y - model.prePose.joints[name]!.position.y)
//                    let disX = abs(pose.joints[name]!.position.x - model.prePose.joints[name]!.position.x)
//                    if flg == 0 {
//                        model.qScore -= disX/50
//                        model.qScore += disY/50
//                    }else{
//                        model.qScore += disX/50
//                        model.qScore -= disY/50
//
//                    }
//                }
//            }
//        }
//        randomAct(callBack: {flg = 100},callBack2: {flg = 0})
//    }
    func quest7(model:QuestCameraViewModel,pose: Pose,size: CGSize, in cgContext: CGContext){
        
        let rectangle = CGRect(x: flg, y: flg2, width: size.width/2, height: size.height/2)
        cgContext.setAlpha(0.2)
        cgContext.fill(rectangle)
        
        if !model.isRecording {return}
        randomAct(flg: flg, callBack: {
            flg = size.width/2
            if Bool.random() {
                flg2 = size.height/2
            }else{
                flg2 = 0
            }
        },callBack2: {
            flg = 0
            if Bool.random() {
                flg2 = size.height/2
            }else{
                flg2 = 0
            }
        })
        Joint.Name.allCases.forEach {name in
            if pose.joints[name] != nil && model.prePose.joints[name] != nil{
                if pose.joints[name]!.confidence > 0.1 && model.prePose.joints[name]!.confidence > 0.1 {
                    let disX = abs(pose.joints[name]!.position.x - model.prePose.joints[name]!.position.x)
                    let disY = abs(pose.joints[name]!.position.y - model.prePose.joints[name]!.position.y)
                    if flg < pose.joints[name]!.position.x && pose.joints[name]!.position.x < flg + size.width/2 {
                        if flg2 == 0 {
                            switch name {
                            case .leftHip: model.qScore -= (disY+disX)/100
                            case .leftKnee: model.qScore -= (disY+disX)/100
                            case .leftAnkle: model.qScore -= (disY+disX)/100
                            case .rightHip: model.qScore -= (disY+disX)/100
                            case .rightKnee: model.qScore -= (disY+disX)/100
                            case .rightAnkle: model.qScore -= (disY+disX)/100
                            default: model.qScore += (disY+disX)/25
                            }
                        }else{
                            switch name {
                            case .leftShoulder: model.qScore -= (disY+disX)/100
                            case .leftElbow: model.qScore -= (disY+disX)/100
                            case .leftWrist: model.qScore -= (disY+disX)/100
                            case .rightShoulder: model.qScore -= (disY+disX)/100
                            case .rightElbow: model.qScore -= (disY+disX)/100
                            case .rightWrist: model.qScore -= (disY+disX)/100
                            default: model.qScore += (disY+disX)/25
                            }
                            
                        }
                    }else{
                        model.qScore -= (disY+disX)/100
                    }
                    
                }
            }
        }
    }
//    func quest7(model:QuestCameraViewModel,pose: Pose,size: CGSize, in cgContext: CGContext){
//
//        randomAct(callBack: {
//            flg = size.width/2
//            if Bool.random() {
//                flg2 = 100
//            }else{
//                flg2 = 0
//            }
//        },callBack2: {
//            flg = 0
//            if Bool.random() {
//                flg2 = 100
//            }else{
//                flg2 = 0
//            }
//        })
//
//        let rectangle = CGRect(x: flg, y: 0, width: size.width/2, height: size.height)
//        cgContext.setAlpha(0.2)
//        cgContext.setFillColor(Colors.cgGreen)
//        cgContext.fill(rectangle)
//
//        let udRect = CGRect(x: size.width/4 - qPlace.x/2, y: size.height*6/8, width: qPlace.x, height: qPlace.x)
//        let rlRect = CGRect(x: size.width*3/4 - qPlace.y/2, y: size.height*6/8, width: qPlace.y, height: qPlace.y)
//        cgContext.setFillColor(Colors.cgGreen)
//        cgContext.setAlpha(0.5)
//        if flg2 == 0 {
//            cgContext.fill(udRect)
//            qPlace = CGPoint(x: size.width/5,y: size.width/10)
//        }else{
//            cgContext.fill(rlRect)
//            qPlace = CGPoint(x: size.width/10,y: size.width/5)
//        }
//        cgContext.setAlpha(1.0)
//        cgContext.draw( UIImage(named: "picto")!.cgImage! ,in: udRect)
//        cgContext.draw( UIImage(named: "picto")!.cgImage! ,in: rlRect)
//
//
//        if !model.isRecording {return}
//        Joint.Name.allCases.forEach {name in
//            if pose.joints[name] != nil && model.prePose.joints[name] != nil{
//                if pose.joints[name]!.confidence > 0.1 && model.prePose.joints[name]!.confidence > 0.1 {
//                    let disX = abs(pose.joints[name]!.position.x - model.prePose.joints[name]!.position.x)
//                    let disY = abs(pose.joints[name]!.position.y - model.prePose.joints[name]!.position.y)
//                    //print("範囲\(flg)~\(flg + size.width/2)、今のポジションは\(pose.joints[name]!.position.x )")
//                    if flg < pose.joints[name]!.position.x && pose.joints[name]!.position.x < flg + size.width/2 {
//                        if flg2 == 0 {
//                            model.qScore -= disX/100
//                            model.qScore += disY/100
//                        }else{
//                            model.qScore += disX/100
//                            model.qScore -= disY/100
//
//                        }
//                    }else{
//                        model.qScore -= (disY+disX)/100
//                    }
//                }
//            }
//        }
//    }
//
    
    
    
}
