

import UIKit

@IBDesignable
class PoseImageView: UIImageView {
    
    static func showMiss(on frame: CGImage) -> UIImage {
        let dstImageSize = CGSize(width: frame.width, height: frame.height)
        let dstImageFormat = UIGraphicsImageRendererFormat()
        dstImageFormat.scale = 1
        let renderer = UIGraphicsImageRenderer(size: dstImageSize,format: dstImageFormat)
        let dstImage = renderer.image { rendererContext in
            let cgContext = rendererContext.cgContext
            PoseImageView.draw(image: frame, in: cgContext)
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
    
    static func showDefault(model: DefaultCameraViewModel,prePose: Pose,pose: Pose,on frame: CGImage) -> UIImage {
        let dstImageSize = CGSize(width: frame.width, height: frame.height)
        let dstImageFormat = UIGraphicsImageRendererFormat()
        dstImageFormat.scale = 1
        let renderer = UIGraphicsImageRenderer(size: dstImageSize,format: dstImageFormat)
        let dstImage = renderer.image { rendererContext in
            PoseImageView.draw(image: frame, in: rendererContext.cgContext)
//            PoseImageView.setBackGround(size: dstImageSize, in: rendererContext.cgContext)
            BodyRender.show(BodyNo: model.bodyNo, pose: pose, cgContext: rendererContext.cgContext)
            PoseImageView.drawHead(num: model.skinNo,pose: pose, in: rendererContext.cgContext)
            DaylyRender.def(model: model, pose: pose, size: dstImageSize, in: rendererContext.cgContext)
        }
        return dstImage
    }
    static func showDayly(model: VideoCameraViewModel,pose: Pose,friPose: Pose?, on frame: CGImage) -> UIImage {
        let dstImageSize = CGSize(width: frame.width, height: frame.height)
        let dstImageFormat = UIGraphicsImageRendererFormat()
        dstImageFormat.scale = 1
        let renderer = UIGraphicsImageRenderer(size: dstImageSize,format: dstImageFormat)
        let dstImage = renderer.image { rendererContext in
            PoseImageView.draw(image: frame, in: rendererContext.cgContext)
//            PoseImageView.setBackGround(size: dstImageSize, in: rendererContext.cgContext)
            BodyRender.show(BodyNo: model.bodyNo, pose: pose, cgContext: rendererContext.cgContext)
            PoseImageView.drawHead(num: model.skinNo,pose: pose, in: rendererContext.cgContext)
            DaylyRender.daily(model: model,pose: pose, size: dstImageSize, in: rendererContext.cgContext)
        }
        return dstImage
    }
    static func showQuest(model: QuestCameraViewModel,pose: Pose, on frame: CGImage) -> UIImage {
        let dstImageSize = CGSize(width: frame.width, height: frame.height)
        let dstImageFormat = UIGraphicsImageRendererFormat()
        dstImageFormat.scale = 1
        let renderer = UIGraphicsImageRenderer(size: dstImageSize,format: dstImageFormat)
        let dstImage = renderer.image { context in
            PoseImageView.draw(image: frame, in: context.cgContext)
            BodyRender.show(BodyNo: model.bodyNo, pose: pose, cgContext: context.cgContext)
            PoseImageView.drawHead(num: model.skinNo,pose: pose, in: context.cgContext)
            QuestRender.show(model: model, pose: pose, size: dstImageSize, cgContext: context.cgContext)
        }
        return dstImage
    }
    
    
    struct JointSegment {
        let segmentName: Joint.SegmentName
        let jointA: Joint.Name
        let jointB: Joint.Name
    }
    static let jointSegments = [
        JointSegment(segmentName: .arm, jointA: .leftShoulder, jointB: .leftElbow),
        JointSegment(segmentName: .arm, jointA: .rightShoulder, jointB: .rightElbow),
        JointSegment(segmentName: .leg, jointA: .leftHip, jointB: .leftKnee),
        JointSegment(segmentName: .leg, jointA: .rightHip, jointB: .rightKnee),
        
        JointSegment(segmentName: .none, jointA: .leftHip, jointB: .leftShoulder),
        JointSegment(segmentName: .none, jointA: .rightHip, jointB: .rightShoulder),
        JointSegment(segmentName: .hip, jointA: .leftHip, jointB: .rightHip),
        JointSegment(segmentName: .shoulder, jointA: .leftShoulder, jointB: .rightShoulder),
    
        JointSegment(segmentName: .arm, jointA: .leftElbow, jointB: .leftWrist),
        JointSegment(segmentName: .arm, jointA: .rightElbow, jointB: .rightWrist),
        JointSegment(segmentName: .leg, jointA: .leftKnee, jointB: .leftAnkle),
        JointSegment(segmentName: .leg, jointA: .rightKnee, jointB: .rightAnkle),
    
    ]
    static func draw(image: CGImage, in cgContext: CGContext) {
        cgContext.saveGState()
        cgContext.scaleBy(x: 1.0, y: -1.0)
        let drawingRect = CGRect(x: 0, y: -image.height, width: image.width, height: image.height)
        cgContext.draw(image, in: drawingRect)
        cgContext.restoreGState()
    }
    
    static func setBackGround(size: CGSize, in cgContext: CGContext){
        let cgImage = UIImage(named: "wallpaper1")?.cgImage
        let rectangle = CGRect(x: 0, y: -size.height, width: size.width, height: size.height)
        cgContext.saveGState()
        cgContext.scaleBy(x: 1.0, y: -1.0)
        cgContext.draw(cgImage!, in: rectangle)
        cgContext.restoreGState()
    }
    
    static func drawLine(from parentJoint: Joint,
                          to childJoint: Joint,
                          in cgContext: CGContext,
                         color segmentColor: CGColor,
                         line segmentLineWidth: CGFloat
                         ) {
        cgContext.setStrokeColor(segmentColor)
        cgContext.setLineWidth(segmentLineWidth)
        cgContext.move(to: parentJoint.position)
        cgContext.addLine(to: childJoint.position)
        cgContext.strokePath()
    }
    
    static func draw(circle joint: Joint, in cgContext: CGContext,color segmentColor: CGColor,
                     line jointSize: CGFloat) {
        if joint.name == .nose || joint.name == .rightEar || joint.name == .leftEar {return}
        cgContext.setFillColor(segmentColor)
        let rectangle = CGRect(x: joint.position.x - jointSize/2, y: joint.position.y - jointSize/2,width: jointSize, height: jointSize)
        cgContext.addEllipse(in: rectangle)
        cgContext.drawPath(using: .fill)
    }
    
    static func drawHead(num skinNo:Int, pose: Pose, in cgContext: CGContext) {
        let head: Skin = Skin.skins[skinNo]
        guard let image: UIImage = UIImage(named: head.image) else {return}
        let ix:CGFloat = head.x ?? 0.0
        let iy:CGFloat = head.y ?? 0.0
        let iw:CGFloat = head.w ?? 1.0
        let ih:CGFloat = head.h ?? 1.0
        guard let cg: CGImage = image.cgImage else {return}
        let long:CGFloat = abs(pose.joints[.rightShoulder]!.position.x - pose.joints[.leftShoulder]!.position.x)*1.5
        cgContext.saveGState()
        cgContext.scaleBy(x: 1.0, y: -1.0)//reverce affect
        let rectangle = CGRect(
            x: Int(pose[.nose].position.x-long/2*iw-long*ix),
            y: -Int(pose[.nose].position.y+long/2*ih+long*iy),
            width: Int(long*iw),
            height: Int(long*ih)
        )
        cgContext.draw(cg, in: rectangle)
        cgContext.restoreGState()
    }
    static func drawPictoHead(color segmentColor:CGColor, pose: Pose, in cgContext: CGContext) {
        guard let nose = pose.joints[.nose]?.position else {return}
        guard let rS = pose.joints[.rightHip]?.position else {return}
        guard let lS = pose.joints[.leftHip]?.position else {return}
        let jointRadius = abs(rS.x-lS.x)
        //cgContext.setFillColor(Colors.gray)
//        let edge = CGRect(x: nose.x - jointRadius*0.5, y: nose.y - jointRadius*0.5,width: jointRadius, height: jointRadius)
//        cgContext.addEllipse(in: edge)
//        cgContext.drawPath(using: .fill)
        //jointRadius -= 10
        cgContext.setFillColor(segmentColor)
        let rectangle = CGRect(x: nose.x - jointRadius*0.5, y: nose.y - jointRadius*0.5,width: jointRadius, height: jointRadius)
        cgContext.addEllipse(in: rectangle)
        cgContext.drawPath(using: .fill)
    }
    static func fillBody(wid:CGFloat,color:CGColor,pose:Pose,in cgContext: CGContext){
        guard let rs = pose.joints[.rightShoulder] else {return}
        guard let ls = pose.joints[.leftShoulder] else {return}
        guard let rh = pose.joints[.rightHip] else {return}
        guard let lh = pose.joints[.leftHip] else {return}
        let rectangle = CGRect(x: rs.position.x+wid/2, y: rs.position.y+wid, width: ls.position.x-rs.position.x-wid, height: lh.position.y-rs.position.y-wid-wid)
        let rectangle2 = CGRect(x: ls.position.x, y: ls.position.y+wid, width: rh.position.x-ls.position.x, height: rh.position.y-ls.position.y-wid-wid)
        cgContext.setFillColor(color)
        cgContext.addRect(rectangle)
        cgContext.addRect(rectangle2)
        cgContext.drawPath(using: .fillStroke)

    }
    
    static private func drawText(image: CGImage,score: CGFloat, in cgContext: CGContext){
        UIGraphicsPushContext(cgContext)
        let font = UIFont.systemFont(ofSize: 30)
        let string = NSAttributedString(
            string: str.score.rawValue + String(Int(score) / 100),
            attributes: [NSAttributedString.Key.font : font]
        )
        string.draw(at: CGPoint(x: image.width*1/10, y: image.height*9/10))
        UIGraphicsPopContext()
    }
    
    static func pictoBody(color: CGColor,pose: Pose, cgContext:CGContext){
        for segment in PoseImageView.jointSegments {
            let jointA = pose[segment.jointA]
            let jointB = pose[segment.jointB]
            guard jointA.isValid, jointB.isValid else {continue}
            drawLine(from: jointA,to: jointB,in: cgContext,color:color,line:30)
        }
        for joint in pose.joints.values.filter({ $0.isValid }) {
            draw(circle: joint, in:cgContext,color: color,line:30)
        }
        fillBody(wid: 15, color: color, pose: pose, in: cgContext)
        drawPictoHead(color: color, pose: pose, in: cgContext)
    }
    
    static func drawBodyPicture(num bodyNo:Int,part: String,from jointA: Joint,
                                to jointB: Joint, in cgContext: CGContext) {
        guard let origin: UIImage = UIImage(named: "body" + String(bodyNo) + "_" + part) else {return}
        
        let radian: CGFloat = RenderUtil.angle(
            f: jointA.position,
            m: jointB.position,
            l: CGPoint(x: jointA.position.x, y: jointB.position.y))
//        let radian2: CGFloat = RenderUtil.angle(jointA.position,jointB.position)
        
        let image = RenderUtil.imageRotate(image: origin, angle: radian)
        var long:CGFloat = RenderUtil.calcDisntace(jointA.position, jointB.position)
        let center = RenderUtil.calcCenter(jointA.position, jointB.position)
        
        if part == "shoulder" || part == "hip"  {long = long * 2}
//
        guard let cg: CGImage = image.cgImage else {return}
        let rectangle = CGRect(x: center.x - long/2, y: -center.y - long/2, width: long, height: long)
        cgContext.saveGState()
        cgContext.scaleBy(x: 1.0, y: -1.0)
        cgContext.draw(cg, in: rectangle)
        cgContext.restoreGState()
        
    }
    
    
}

struct RenderUtil{
    
    //回転画像
    static func imageRotate(image: UIImage, angle:CGFloat) -> UIImage{
        let imgSize = CGSize.init(width: image.size.width, height: image.size.height)
        UIGraphicsBeginImageContextWithOptions(imgSize, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.translateBy(x: image.size.width/2, y: image.size.height/2)
        context.scaleBy(x: 1.0, y: -1.0)
        let radian: CGFloat = angle// * CGFloat(Double.pi) / 180.0
        context.rotate(by: radian)
        context.draw(image.cgImage!, in: CGRect.init(x: -image.size.width/2, y: -image.size.height/2, width: image.size.width, height: image.size.height))
        let rotatedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return rotatedImage
    }
    //画像の1一辺の長さ
    static func calcDisntace(_ pA: CGPoint, _ pB: CGPoint) -> CGFloat{
        let dx = Float(pA.x - pB.x)
        let dy = Float(pA.y - pB.y)
        return CGFloat(sqrt(dx*dx + dy*dy)*1.5)
    }
//    イメージの中心の座標
    static func calcCenter(_ pA: CGPoint, _ pB: CGPoint) -> CGPoint{
        let x = (pA.x+pB.x)/2
        let y = (pA.y+pB.y)/2
        return CGPoint(x: x, y: y);
    }
    
    static func angle(
          f firstLandmark: CGPoint,
          m midLandmark: CGPoint,
          l lastLandmark:CGPoint
      ) -> CGFloat {
          let radians: CGFloat =
              atan2(lastLandmark.y - midLandmark.y,
                        lastLandmark.x - midLandmark.x) -
                atan2(firstLandmark.y - midLandmark.y,
                        firstLandmark.x - midLandmark.x)
//          var degrees = radians// * 180.0 /  M_PI//.pi
//          degrees = abs(degrees) // Angle should never be negative
//          if degrees > 180.0 {
//              degrees = 360.0 - degrees // Always get the acute representation of the angle
//          }
          return radians
      }
    
    static func showRender(
        skin:Int = UserDefaults.standard.integer(forKey:Keys.selectSkin.rawValue),
        body:Int = UserDefaults.standard.integer(forKey:Keys.selectBody.rawValue)
    ) -> UIImage {
        let size = CGSize(width: 500, height: 1000)
        let pose = Pose.defaultPose(size: size)
        let dstImageFormat = UIGraphicsImageRendererFormat()
        dstImageFormat.scale = 1
        let renderer = UIGraphicsImageRenderer(size: size,format: dstImageFormat)
        let dstImage = renderer.image { rendererContext in
            BodyRender.show(BodyNo: body, pose: pose, cgContext: rendererContext.cgContext)
            PoseImageView.drawHead(num: skin,pose: pose, in: rendererContext.cgContext)
        }
        return dstImage
    }
}
