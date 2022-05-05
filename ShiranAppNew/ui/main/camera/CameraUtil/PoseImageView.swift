

import UIKit

@IBDesignable
class PoseImageView: UIImageView {
    
    var jump = false
    var gameStart = false
    let skinNo:Int = UserDefaults.standard.integer(forKey:Keys.selectSkin.rawValue)
    let bodyNo:Int = UserDefaults.standard.integer(forKey:Keys.selectBody.rawValue)
    
    func showMiss(on frame: CGImage) -> UIImage {
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
    
    
    func showDefault(prePose: Pose,pose: Pose,on frame: CGImage) -> UIImage {
        let dstImageSize = CGSize(width: frame.width, height: frame.height)
        let dstImageFormat = UIGraphicsImageRendererFormat()
        dstImageFormat.scale = 1
        let renderer = UIGraphicsImageRenderer(size: dstImageSize,format: dstImageFormat)
        let dstImage = renderer.image { rendererContext in
            PoseImageView.draw(image: frame, in: rendererContext.cgContext)
            BodyRender.show(BodyNo: bodyNo, pose: pose, cgContext: rendererContext.cgContext)
            PoseImageView.drawHead(num: skinNo,pose: pose, in: rendererContext.cgContext)
        }
        return dstImage
    }
    func showDayly(prePose: Pose,pose: Pose,friPose: Pose, on frame: CGImage) -> UIImage {
        let dstImageSize = CGSize(width: frame.width, height: frame.height)
        let dstImageFormat = UIGraphicsImageRendererFormat()
        dstImageFormat.scale = 1
        let renderer = UIGraphicsImageRenderer(size: dstImageSize,format: dstImageFormat)
        let dstImage = renderer.image { rendererContext in
            PoseImageView.draw(image: frame, in: rendererContext.cgContext)
            BodyRender.show(BodyNo: bodyNo, pose: pose, cgContext: rendererContext.cgContext)
            PoseImageView.drawHead(num: skinNo,pose: pose, in: rendererContext.cgContext)
            jump = DaylyRender.daily(jump: jump, gameStart: gameStart, pose: pose, size: dstImageSize, in: rendererContext.cgContext)
        }
        return dstImage
    }
    func showQuest(qRender:QuestRender,qType: Int,prePose: Pose,pose: Pose, on frame: CGImage) -> UIImage {
        let dstImageSize = CGSize(width: frame.width, height: frame.height)
        let dstImageFormat = UIGraphicsImageRendererFormat()
        dstImageFormat.scale = 1
        let renderer = UIGraphicsImageRenderer(size: dstImageSize,format: dstImageFormat)
        let dstImage = renderer.image { context in
            PoseImageView.draw(image: frame, in: context.cgContext)
            BodyRender.show(BodyNo: bodyNo, pose: pose, cgContext: context.cgContext)
            PoseImageView.drawHead(num: skinNo,pose: pose, in: context.cgContext)
            qRender.show(pre: prePose, pose: pose, size: dstImageSize, cgContext: context.cgContext)
        }
        return dstImage
    }
    
    struct JointSegment {
        let jointA: Joint.Name
        let jointB: Joint.Name
    }
    static let jointSegments = [
        JointSegment(jointA: .leftHip, jointB: .leftShoulder),
        JointSegment(jointA: .rightHip, jointB: .rightShoulder),
        JointSegment(jointA: .leftShoulder, jointB: .rightShoulder),
        JointSegment(jointA: .leftHip, jointB: .rightHip),
        
        JointSegment(jointA: .leftShoulder, jointB: .leftElbow),
        JointSegment(jointA: .leftElbow, jointB: .leftWrist),
        JointSegment(jointA: .leftHip, jointB: .leftKnee),
        JointSegment(jointA: .leftKnee, jointB: .leftAnkle),
        
        JointSegment(jointA: .rightShoulder, jointB: .rightElbow),
        JointSegment(jointA: .rightElbow, jointB: .rightWrist),
        JointSegment(jointA: .rightHip, jointB: .rightKnee),
        JointSegment(jointA: .rightKnee, jointB: .rightAnkle),
        
    ]
    static func draw(image: CGImage, in cgContext: CGContext) {
        cgContext.saveGState()
        cgContext.scaleBy(x: 1.0, y: -1.0)
        let drawingRect = CGRect(x: 0, y: -image.height, width: image.width, height: image.height)
        cgContext.draw(image, in: drawingRect)
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
        guard let cg: CGImage = image.cgImage else {return}
        let long:CGFloat = abs(pose.joints[.rightShoulder]!.position.x - pose.joints[.leftShoulder]!.position.x)*1.5
        cgContext.saveGState()
        cgContext.scaleBy(x: 1.0, y: -1.0)//reverce affect
        let rectangle = CGRect(
            x: Int(pose[.nose].position.x-long/2-long*ix),
            y: -Int(pose[.nose].position.y+long/2+long*iy),
            width: Int(long),
            height: Int(long)
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
    
    private func drawText(image: CGImage,score: CGFloat, in cgContext: CGContext){
        UIGraphicsPushContext(cgContext)
        let font = UIFont.systemFont(ofSize: 30)
        let string = NSAttributedString(
            string: str.score.rawValue + String(Int(score) / 100),
            attributes: [NSAttributedString.Key.font : font]
        )
        string.draw(at: CGPoint(x: image.width*1/10, y: image.height*9/10))
        UIGraphicsPopContext()
    }
}
