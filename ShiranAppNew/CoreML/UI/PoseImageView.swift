/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Implementation details of a view that visualizes the detected poses.
*/

import UIKit

@IBDesignable
class PoseImageView: UIImageView {
    
    var gameStart = false
    var qScore = 0
    var qPlace:CGPoint = CGPoint(x: -100, y: 0)
    
    
    
    /// A data structure used to describe a visual connection between two joints.
    struct JointSegment {
        let jointA: Joint.Name
        let jointB: Joint.Name
    }

    /// An array of joint-pairs that define the lines of a pose's wireframe drawing.
    static let jointSegments = [
        // The connected joints that are on the left side of the body.
        JointSegment(jointA: .leftHip, jointB: .leftShoulder),
        JointSegment(jointA: .leftShoulder, jointB: .leftElbow),
        JointSegment(jointA: .leftElbow, jointB: .leftWrist),
        JointSegment(jointA: .leftHip, jointB: .leftKnee),
        JointSegment(jointA: .leftKnee, jointB: .leftAnkle),
        // The connected joints that are on the right side of the body.
        JointSegment(jointA: .rightHip, jointB: .rightShoulder),
        JointSegment(jointA: .rightShoulder, jointB: .rightElbow),
        JointSegment(jointA: .rightElbow, jointB: .rightWrist),
        JointSegment(jointA: .rightHip, jointB: .rightKnee),
        JointSegment(jointA: .rightKnee, jointB: .rightAnkle),
        // The connected joints that cross over the body.
        JointSegment(jointA: .leftShoulder, jointB: .rightShoulder),
        JointSegment(jointA: .leftHip, jointB: .rightHip)
    ]

    /// The width of the line connecting two joints.
    @IBInspectable var segmentLineWidth: CGFloat = 8
    /// The color of the line connecting two joints.
    @IBInspectable var segmentColor: UIColor = UIColor.green//.systemGreen//.systemTeal
    /// The radius of the circles drawn for each joint.
    @IBInspectable var jointRadius: CGFloat = 9
    /// The color of the circles drawn for each joint.
    @IBInspectable var jointColor: UIColor = UIColor.yellow//.systemYellow//.systemPink
    
    func showMiss(on frame: CGImage) -> UIImage {
        let dstImageSize = CGSize(width: frame.width, height: frame.height)
        let dstImageFormat = UIGraphicsImageRendererFormat()
        dstImageFormat.scale = 1
        
        let renderer = UIGraphicsImageRenderer(size: dstImageSize,format: dstImageFormat)
        let dstImage = renderer.image { rendererContext in
            let cgContext = rendererContext.cgContext
            draw(image: frame, in: cgContext)
            let cg = UIImage(named: "picto")?.cgImage
            cgContext.saveGState()
            cgContext.scaleBy(x: 1.0, y: -1.0)
            let drawingRect = CGRect(x: 0, y: -frame.height, width: frame.width, height: frame.height*9/10)
            cgContext.setAlpha(0.5)
            cgContext.draw(cg!, in: drawingRect)
            cgContext.restoreGState()
        }
        return dstImage
    }
    
    /*static func showDial() -> UIImage {
        //let dstImageSize = CGSize(width: frame.width, height: frame.height)
        let frame = CGSize(width: 250, height: 500)
        let dstImageFormat = UIGraphicsImageRendererFormat()
        dstImageFormat.scale = 1
        
        let renderer = UIGraphicsImageRenderer(size: frame,format: dstImageFormat)
        let dstImage = renderer.image { rendererContext in
            let cgContext = rendererContext.cgContext
            UIGraphicsPushContext(cgContext)
            let font = UIFont.systemFont(ofSize: 30)
            let string = NSAttributedString(string: "あいうえお", attributes: [NSAttributedString.Key.font: font])
            string.draw(at: CGPoint(x: frame.width/2, y: frame.height/2))
            UIGraphicsPopContext()
            /*draw(image: frame, in: cgContext)
            let cg = UIImage(named: "picto")?.cgImage
            cgContext.saveGState()
            cgContext.scaleBy(x: 1.0, y: -1.0)
            let drawingRect = CGRect(x: 0, y: -frame.height, width: frame.width, height: frame.height*9/10)
            cgContext.setAlpha(0.5)
            cgContext.draw(cg!, in: drawingRect)
            cgContext.restoreGState()*/
        }
        return dstImage
    }*/
    
    func show(state: Int,qType: Int,prePose: Pose,pose: Pose,friPose: Pose, on frame: CGImage) -> UIImage {
        
        let dstImageSize = CGSize(width: frame.width, height: frame.height)
        let dstImageFormat = UIGraphicsImageRendererFormat()

        dstImageFormat.scale = 1
        let renderer = UIGraphicsImageRenderer(size: dstImageSize,
                                               format: dstImageFormat)

        let dstImage = renderer.image { rendererContext in
            // Draw the current frame as the background for the new image.
            draw(image: frame, in: rendererContext.cgContext)

            //drawText(image:frame,score: score, in: rendererContext.cgContext)
            changeSkin()
            for segment in PoseImageView.jointSegments {
                let jointA = pose[segment.jointA]
                let jointB = pose[segment.jointB]
                guard jointA.isValid, jointB.isValid else {continue}
                drawLine(from: jointA,
                         to: jointB,
                         in: rendererContext.cgContext)
            }
            for joint in pose.joints.values.filter({ $0.isValid }) {
                draw(circle: joint, in: rendererContext.cgContext)
            }
            //gameStart = true
            if state == 0{//クエスト
                if gameStart {
                    switch qType {
                    case 1 : quest1(pose: pose,size: dstImageSize, in: rendererContext.cgContext)
                    case 3 : quest2(pre: prePose, pose: pose, size: dstImageSize, in: rendererContext.cgContext)
                    case 4 : quest3(pre: prePose, pose: pose, size: dstImageSize, in: rendererContext.cgContext)
                    default: print();
                    }
                }
            }else{//デイリー　（フレンド）
                daily(pose: pose, size: dstImageSize, in: rendererContext.cgContext)
                /*if friPose[.nose].position.x != 0 {
                    segmentColor = .blue
                    jointColor = .blue
                    for joint in friPose.joints.values.filter({ $0.isValid }) {
                        draw(circle: joint, in: rendererContext.cgContext)
                    }
                    drawHead(circle: friPose[.nose], in: rendererContext.cgContext)
                    for segment in PoseImageView.jointSegments {
                        let jointA = friPose[segment.jointA]
                        let jointB = friPose[segment.jointB]
                        guard jointA.isValid, jointB.isValid else {continue}
                        drawLine(from: jointA,
                                    to: jointB,
                                    in: rendererContext.cgContext)
                    }
                 }*/
            }
        }

        image = dstImage
        return dstImage
    }

    /// Vertically flips and draws the given image.
    ///
    /// - parameters:
    ///     - image: The image to draw onto the context (vertically flipped).
    ///     - cgContext: The rendering context.
    private func draw(image: CGImage, in cgContext: CGContext) {
        cgContext.saveGState()
        // The given image is assumed to be upside down; therefore, the context
        // is flipped before rendering the image.
        cgContext.scaleBy(x: 1.0, y: -1.0)
        // Render the image, adjusting for the scale transformation performed above.
        let drawingRect = CGRect(x: 0, y: -image.height, width: image.width, height: image.height)
        cgContext.draw(image, in: drawingRect)
        cgContext.restoreGState()
    }

    /// Draws a line between two joints.
    ///
    /// - parameters:
    ///     - parentJoint: A valid joint whose position is used as the start position of the line.
    ///     - childJoint: A valid joint whose position is used as the end of the line.
    ///     - cgContext: The rendering context.
    private func drawLine(from parentJoint: Joint,
                  to childJoint: Joint,
                  in cgContext: CGContext) {
        cgContext.setStrokeColor(segmentColor.cgColor)
        cgContext.setLineWidth(segmentLineWidth)

        cgContext.move(to: parentJoint.position)
        cgContext.addLine(to: childJoint.position)
        cgContext.strokePath()
    }

    /// Draw a circle in the location of the given joint.
    ///
    /// - parameters:
    ///     - circle: A valid joint whose position is used as the circle's center.
    ///     - cgContext: The rendering context.
    private func draw(circle joint: Joint, in cgContext: CGContext) {
        if joint.name == .nose {return}
        cgContext.setFillColor(jointColor.cgColor)
        let rectangle = CGRect(x: joint.position.x - jointRadius, y: joint.position.y - jointRadius,
                               width: jointRadius * 2, height: jointRadius * 2)
        cgContext.addEllipse(in: rectangle)
        cgContext.drawPath(using: .fill)
    }
    
    private func drawHead(circle joint: Joint, in cgContext: CGContext) {
        //if joint.name != .nose {return}
        jointRadius = 30
        //cgContext.setFillColor(jointColor.cgColor)
        cgContext.setStrokeColor(jointColor.cgColor)
        let rectangle = CGRect(x: joint.position.x - jointRadius, y: joint.position.y - jointRadius,
                               width: jointRadius * 2, height: jointRadius * 2)
        cgContext.setLineWidth(9)
        cgContext.strokeEllipse(in: rectangle)
        cgContext.drawPath(using: .stroke)
        jointRadius = 9
        //val kadomaruShikaku = UIBezierPath(roundedRect: CGRect(x: 100, y: 100, width: 100, height: 100), cornerRadius: 10)
    }
    
    private func drawText(image: CGImage,score: CGFloat, in cgContext: CGContext){
        UIGraphicsPushContext(cgContext)
        let font = UIFont.systemFont(ofSize: 30)
        let string = NSAttributedString(string: "Score \(Int(score) / 100)", attributes: [NSAttributedString.Key.font: font])
        string.draw(at: CGPoint(x: image.width*1/10, y: image.height*9/10))
        UIGraphicsPopContext()
    }
    
    private func changeSkin(){
        let skin = UserDefaults.standard.integer(forKey: Keys.skin.rawValue)
        if skin == 001 {
            segmentColor = .systemPink
            jointColor = .red
            segmentLineWidth = 20
        }else{
            segmentColor = .green
            jointColor = .yellow
        }
    }
    
    //デイリー
    var jump = false
    //private var diffi = UserDefaults.standard.integer(forKey: Keys.difficult.rawValue)//1,2,6
    func daily(pose: Pose,size: CGSize, in cgContext: CGContext){
        var sta = 1.0
        switch UserDefaults.standard.integer(forKey: Keys.difficult.rawValue) {
        case 2 : sta = 5/6//  Hard Mode
        case 3 : sta = 4/6//  VeryHard Mode
        default: return//     Nomal Mode
        }
        if jump {
            let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height*sta)
            cgContext.setAlpha(0.2)
            cgContext.fill(rectangle)
            if !gameStart {return}
            let left = pose[.leftAnkle].position.y
            let right = pose[.rightAnkle].position.y
            if left < size.height*sta && right < size.height*sta {
                jump = false
                //qScore+=1
                SystemSounds.score_up("")
            }
        }else{
            let rectangle = CGRect(x: 0, y: size.height*7/8, width: size.width, height: size.height/8)
            cgContext.setAlpha(0.2)
            cgContext.fill(rectangle)
            if !gameStart {return}
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
                    jump = true
                    //qScore+=1
                    SystemSounds.score_up("")
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
    func angle(
          firstLandmark: Joint,
          midLandmark: Joint,
          lastLandmark: Joint
      ) -> CGFloat {
          let radians: CGFloat =
              atan2(lastLandmark.position.y - midLandmark.position.y,
                        lastLandmark.position.x - midLandmark.position.x) -
                atan2(firstLandmark.position.y - midLandmark.position.y,
                        firstLandmark.position.x - midLandmark.position.x)
          var degrees = radians * 180.0 / .pi
          degrees = abs(degrees) // Angle should never be negative
          if degrees > 180.0 {
              degrees = 360.0 - degrees // Always get the acute representation of the angle
          }
          return degrees
      }
    
    
    
    
    //coins
    func quest1(pose: Pose,size: CGSize, in cgContext: CGContext){
        //if !pose[.leftAnkle].isValid || !pose[.rightAnkle].isValid {return}
        
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
            qPlace = places.randomElement() ?? CGPoint(x: -100, y: 0)
        }
        let left = pose[.leftWrist].position
        let l_diff = abs(qPlace.x - left.x) + abs(qPlace.y - left.y)
        if l_diff < 40 { qPlace = CGPoint(x: -100, y: 0); qScore += 1; SystemSounds.score_up("")}
        let right = pose[.rightWrist].position
        let r_diff = abs(qPlace.x - right.x) + abs(qPlace.y - right.y)
        if r_diff < 40 { qPlace = CGPoint(x: -100, y: 0); qScore += 1; SystemSounds.score_up("") }
        
        jointRadius = 30
        segmentColor = .red
        //cgContext.setFillColor(jointColor.cgColor)
        //cgContext.setStrokeColor(jointColor.cgColor)
        let rectangle = CGRect(x: qPlace.x - jointRadius, y: qPlace.y - jointRadius,
                               width: jointRadius * 3, height: jointRadius * 3)
        //let drawingRect = CGRect(x: 0, y: -image.height, width: image.width, height: image.height)
        let cgImage = UIImage(named: "coin")?.flipVertical().cgImage
        cgContext.draw(cgImage!, in: rectangle)
        //cgContext.restoreGState()
        
        //cgContext.setLineWidth(9)
        //cgContext.fillEllipse(in: rectangle)
        //cgContext.drawPath(using: .stroke)
        jointRadius = 9
        segmentColor = .green
        
    }
    //climbing
    func quest2(pre: Pose,pose: Pose,size: CGSize, in cgContext: CGContext){
        
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
    func quest3(pre: Pose,pose: Pose,size: CGSize, in cgContext: CGContext){
        
        let leftA = pose[.leftKnee].position
        let rightA = pose[.rightKnee].position
        let diff = leftA.y - rightA.y
        var newflg = 1
        if diff<0 {newflg = 1}else{newflg = -1}
        if newflg != flg {//足が切り替わった
            print("切り替わった")
            flg = newflg
            co = 0.0
        }
        sTime = -0.4*co*co + 4.0*co + 1.0
        if sTime < 0.0 || 20 > abs(diff) {sTime = 0.0}
        co += 1.0
        
        qPlace.y += sTime
        qScore += Int(sTime/10)
        let back = UIImage(named: "skate_back")?.flipVertical().cgImage
        let rectangle = CGRect(x:0, y:0, width:size.width, height:size.height/2)
        cgContext.setAlpha(0.5)
        cgContext.draw(back!, in: rectangle)
        
        cgContext.setFillColor(CGColor(red: 0.9, green: 1.0, blue: 1.0, alpha: 0.8))
        cgContext.fill(CGRect(x: 0, y: size.height*1/2, width: size.width, height: size.height/2))
        
        let cgImage = UIImage(named: "icerock")?.flipVertical().cgImage
        let si = 200-qPlace.y//画像サイズ
        //if size.height*2/3 > size.height - si - qPlace.y {print("リセット"); qPlace = CGPoint(x: 0,y: 0)}
        if si < 0 {qPlace = CGPoint(x: 0,y: 0); leftside = !leftside}
        var r = qPlace.y/2
        if !leftside { r = size.width - 200 + qPlace.y/2 }
        let rectangle2 = CGRect(x: r , y:size.height-100 - qPlace.y, width:si, height:si)
        cgContext.setAlpha(0.9)
        cgContext.draw(cgImage!, in: rectangle2)
    }
    
}

extension UIImage {


    //上下反転
    func flipVertical() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        let imageRef = self.cgImage
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y:  0)
        context?.scaleBy(x: 1.0, y: 1.0)
        context?.draw(imageRef!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let flipHorizontalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return flipHorizontalImage!
    }

    //左右反転
    func flipHorizontal() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        let imageRef = self.cgImage
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: size.width, y:  size.height)
        context?.scaleBy(x: -1.0, y: -1.0)
        context?.draw(imageRef!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let flipHorizontalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return flipHorizontalImage!
    }

}
