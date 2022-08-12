
import UIKit
import SwiftUI
import AVFoundation
import Vision

struct BodyRender{
    static func show(BodyNo:Int,pose:Pose,cgContext:CGContext){
        switch BodyNo {
        case 1: body1(pose: pose, cgContext:cgContext)
        case 2: body2(pose: pose, cgContext:cgContext)
        case 3: body3(pose: pose, cgContext:cgContext)
        case 4: body4(pose: pose, cgContext:cgContext)
        case 5: body5(pose: pose, cgContext:cgContext)
        case 6: body6(pose: pose, cgContext:cgContext)
        case 7: body7(pose: pose, cgContext:cgContext)
        default:defaultBody(pose: pose, cgContext:cgContext)
        }
    }
    
    static func defaultBody(pose:Pose,cgContext:CGContext) {
        for segment in PoseImageView.jointSegments {
            let jointA = pose[segment.jointA]
            let jointB = pose[segment.jointB]
            guard jointA.isValid, jointB.isValid else {continue}
            PoseImageView.drawLine(from: jointA,to: jointB,in: cgContext,color:Colors.cgYellow,line:8)
        }
        for joint in pose.joints.values.filter({ $0.isValid }) {
            PoseImageView.draw(circle: joint, in:cgContext,color: Colors.cgGreen,line:8)
        }
    }
    static func body1(pose: Pose, cgContext:CGContext){
        PoseImageView.pictoBody(color: Colors.cgPink, pose: pose, cgContext: cgContext)
    }
    static func body2(pose: Pose, cgContext:CGContext){
        PoseImageView.pictoBody(color: Colors.cgBlue, pose: pose, cgContext: cgContext)
    }
    static func body3(pose: Pose, cgContext:CGContext){
        PoseImageView.pictoBody(color: Colors.cgGreen, pose: pose, cgContext: cgContext)
    }
    static func body4(pose: Pose, cgContext:CGContext){
        PoseImageView.pictoBody(color: Colors.cgGray, pose: pose, cgContext: cgContext)
    }
    static func body5(pose: Pose, cgContext:CGContext){
        PoseImageView.pictoBody(color: Colors.cgOrange, pose: pose, cgContext: cgContext)
    }
    static func body6(pose: Pose, cgContext:CGContext){
        for segment in PoseImageView.jointSegments {
            if segment.segmentName == .none {continue}
            let jointA = pose[segment.jointA]
            let jointB = pose[segment.jointB]
            guard jointA.isValid, jointB.isValid else {continue}
            PoseImageView.drawBodyPicture(num: 3, part: segment.segmentName.rawValue,
                             from: jointA, to: jointB, in: cgContext)
        }
    }
    static func body7(pose: Pose, cgContext:CGContext){
        for segment in PoseImageView.jointSegments {
            if segment.segmentName == .none {continue}
            let jointA = pose[segment.jointA]
            let jointB = pose[segment.jointB]
            guard jointA.isValid, jointB.isValid else {continue}
            PoseImageView.drawBodyPicture(num: 4, part: segment.segmentName.rawValue,
                             from: jointA, to: jointB, in: cgContext)
        }
    }
//    static func body7(pose: Pose, cgContext:CGContext){
//
//        for joint in pose.joints.values.filter({ $0.isValid }) {
//            drawRing(circle: joint.position, in: cgContext, color: Colors.cgRed, line: 40)
//        }
//
////        let right = pose[.rightShoulder].position
////        let left = pose[.leftShoulder].position
////        drawRing(circle: CGPoint(x: right.x, y: right.y+20), in: cgContext, color: Colors.cgRed, line: 100)
////        drawRing(circle: CGPoint(x: left.x, y: left.y+20), in: cgContext, color: Colors.cgRed, line: 100)
//
//        let segments = [
//            PoseImageView.JointSegment(segmentName: .arm, jointA: .leftShoulder, jointB: .leftElbow),
//            PoseImageView.JointSegment(segmentName: .arm, jointA: .rightShoulder, jointB: .rightElbow),
//            PoseImageView.JointSegment(segmentName: .leg, jointA: .leftHip, jointB: .leftKnee),
//            PoseImageView.JointSegment(segmentName: .leg, jointA: .rightHip, jointB: .rightKnee),
//            PoseImageView.JointSegment(segmentName: .arm, jointA: .leftElbow, jointB: .leftWrist),
//            PoseImageView.JointSegment(segmentName: .arm, jointA: .rightElbow, jointB: .rightWrist),
//            PoseImageView.JointSegment(segmentName: .leg, jointA: .leftKnee, jointB: .leftAnkle),
//            PoseImageView.JointSegment(segmentName: .leg, jointA: .rightKnee, jointB: .rightAnkle),
//        ]
//        for i in segments {
//            betweenRing(circle: pose[i.jointA], circle2: pose[i.jointB], in: cgContext,
//                        color: Colors.cgRed, line: 0)
//        }
//
//
//    }
//
//    static func drawRing(circle: CGPoint, in cgContext: CGContext,color segmentColor: CGColor,
//                     line jointSize: CGFloat) {
//        cgContext.setFillColor(segmentColor)
//        cgContext.setStrokeColor(Colors.cgWhite)
//        let rectangle = CGRect(x: circle.x - jointSize/2, y: circle.y - jointSize/2,width: jointSize, height: jointSize)
//        cgContext.addEllipse(in: rectangle)
//        cgContext.drawPath(using: .fillStroke)
//    }
//    static func betweenRing(circle: Joint,circle2: Joint, in cgContext: CGContext,color segmentColor: CGColor, line jointSize: CGFloat) {
//        cgContext.setFillColor(segmentColor)
//        cgContext.setStrokeColor(Colors.cgWhite)
//
//        let cen = RenderUtil.calcCenter(circle.position, circle2.position)
//        let dist = RenderUtil.calcDisntace(circle.position, circle2.position)
//
//        let rectangle = CGRect(x: cen.x-dist/4, y: cen.y-dist/4,width: dist/2.5, height: dist/2)
//        cgContext.addEllipse(in: rectangle)
//        cgContext.drawPath(using: .fillStroke)
//    }
    
//    static func body7(pose: Pose, cgContext:CGContext){
//        for segment in PoseImageView.jointSegments {
//            let jointA = pose[segment.jointA]
//            let jointB = pose[segment.jointB]
//            guard jointA.isValid, jointB.isValid else {continue}
//            drawLine(from: jointA,to: jointB,in: cgContext,color:Colors.cgGray,line:8)
//        }
//        for joint in pose.joints.values.filter({ $0.isValid }) {
//            PoseImageView.draw(circle: joint, in:cgContext,color: Colors.cgGreen,line:8)
//        }
//    }
//    static func drawLine(from parentJoint: Joint,
//                          to childJoint: Joint,
//                          in cgContext: CGContext,
//                         color segmentColor: CGColor,
//                         line segmentLineWidth: CGFloat
//                         ) {
//        let parent = parentJoint.position
//        let child = childJoint.position
//        let li_x = parent.x - child.x
//        let li_y = parent.y - child.y
////        let tilt = (parent.y - child.y)/(parent.x - child.x)
//        cgContext.setStrokeColor(segmentColor)
//        cgContext.setLineWidth(segmentLineWidth)
//        cgContext.move(to: parent)
//        //cgContext.addCurve(to: <#T##CGPoint#>, control1: <#T##CGPoint#>, control2: <#T##CGPoint#>)
////        cgContext.addLines(between: [CGPoint(x: 100,y: -100),CGPoint(x: 400,y: -120)])
//        cgContext.addLine(to: CGPoint(x: parent.x - li_x/1 + 10, y: parent.y - li_y/1 + 10))
//        cgContext.addLine(to: CGPoint(x: parent.x - li_x/2 - 10, y: parent.y - li_y/2 - 10))
//        cgContext.addLine(to: CGPoint(x: parent.x - li_x/3 + 10, y: parent.y - li_y/3 + 10))
//        cgContext.addLine(to: CGPoint(x: parent.x - li_x/4 - 10, y: parent.y - li_y/4 - 10))
//        cgContext.addLine(to: CGPoint(x: parent.x - li_x/5 + 10, y: parent.y - li_y/5 + 10))
//        cgContext.addLine(to: CGPoint(x: parent.x - li_x/6 - 10, y: parent.y - li_y/6 - 10))
//        cgContext.addLine(to: CGPoint(x: parent.x - li_x/7 + 10, y: parent.y - li_y/7 + 10))
//        cgContext.addLine(to: CGPoint(x: parent.x - li_x/8 - 10, y: parent.y - li_y/8 - 10))
//        cgContext.addLine(to: CGPoint(x: parent.x - li_x/9 + 10, y: parent.y - li_y/9 + 10))
//        cgContext.addLine(to: child)
//        cgContext.strokePath()
//    }
}


struct Body_Previews: PreviewProvider {
    static var previews: some View{
        Image(uiImage:RenderUtil.showRender(skin: 0, body: 6))
    }
}
