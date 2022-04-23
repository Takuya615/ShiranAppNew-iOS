
import UIKit
import SwiftUI
import AVFoundation
import Vision

struct BodyRender{
    static func show(BodyNo:Int,pose:Pose,cgContext:CGContext){
        switch BodyNo {
        case 1: body1(pose: pose, cgContext:cgContext)
        case 2: body2(pose: pose, cgContext:cgContext)
        default:defaultBody(pose: pose, cgContext:cgContext)
        }
    }
    
    static func defaultBody(pose:Pose,cgContext:CGContext) {
        for segment in PoseImageView.jointSegments {
            let jointA = pose[segment.jointA]
            let jointB = pose[segment.jointB]
            guard jointA.isValid, jointB.isValid else {continue}
            PoseImageView.drawLine(from: jointA,to: jointB,in: cgContext,color:Colors.line0,line:8)
        }
        for joint in pose.joints.values.filter({ $0.isValid }) {
            PoseImageView.draw(circle: joint, in:cgContext,color: Colors.dot0,line:8)
        }
    }
    static func body1(pose: Pose, cgContext:CGContext){
        for joint in pose.joints.values.filter({ $0.isValid }) {
            PoseImageView.draw(circle: joint, in:cgContext,color: Colors.dot0,line:60)
            PoseImageView.draw(circle: joint, in:cgContext,color: Colors.dot1,line:50)
        }
        for segment in PoseImageView.jointSegments {
            let jointA = pose[segment.jointA]
            let jointB = pose[segment.jointB]
            guard jointA.isValid, jointB.isValid else {continue}
            PoseImageView.drawLine(from: jointA,to: jointB,in: cgContext,color:Colors.line0,line:60)
            PoseImageView.drawLine(from: jointA,to: jointB,in: cgContext,color:Colors.line1,line:50)
        }
        PoseImageView.fillBody(wid:50,color: Colors.line1, pose: pose, in: cgContext)
        PoseImageView.drawPictoHead(color: Colors.line1, pose: pose, in: cgContext)
    }
    static func body2(pose: Pose, cgContext:CGContext){
        for joint in pose.joints.values.filter({ $0.isValid }) {
            PoseImageView.draw(circle: joint, in:cgContext,color: Colors.dot1,line:40)
            PoseImageView.draw(circle: joint, in:cgContext,color: Colors.line2,line:30)
        }
        for segment in PoseImageView.jointSegments {
            let jointA = pose[segment.jointA]
            let jointB = pose[segment.jointB]
            guard jointA.isValid, jointB.isValid else {continue}
            PoseImageView.drawLine(from: jointA,to: jointB,in: cgContext,color:Colors.line1,line:40)
            PoseImageView.drawLine(from: jointA,to: jointB,in: cgContext,color:Colors.line2,line:30)
        }
        PoseImageView.fillBody(wid:30.0,color: Colors.line2, pose: pose, in: cgContext)
        PoseImageView.drawPictoHead(color: Colors.line2, pose: pose, in: cgContext)
    }
    
    
    static func showRender(on size: CGSize) -> UIImage {
        let pose = Pose.defaultPose(size: size)
        let dstImageFormat = UIGraphicsImageRendererFormat()
        dstImageFormat.scale = 1
        let renderer = UIGraphicsImageRenderer(size: size,format: dstImageFormat)
        let dstImage = renderer.image { rendererContext in
            BodyRender.show(BodyNo: 2, pose: pose, cgContext: rendererContext.cgContext)
            PoseImageView.drawHead(num: 2,pose: pose, in: rendererContext.cgContext)
            
        }
        return dstImage
    }
    
}


struct Body_Previews: PreviewProvider {
    static var previews: some View{
        let size = CGSize(width: 300, height: 700)
        Image(uiImage:BodyRender.showRender(on: size))
    }
}












