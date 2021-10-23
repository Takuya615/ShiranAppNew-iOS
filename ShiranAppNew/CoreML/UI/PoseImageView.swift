/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Implementation details of a view that visualizes the detected poses.
*/

import UIKit

@IBDesignable
class PoseImageView: UIImageView {

    var qPlace:CGPoint = CGPoint(x: -100, y: 0)
    let qNum = UserDefaults.standard.integer(forKey: DataCounter().questNum)
    var qScore = 0
    var gameStart = false
    
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
    
    
    func show(pose: Pose,friPose: Pose, on frame: CGImage) -> UIImage {
        
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
            
            //フレンド
            if friPose[.nose].position.x != 0 {
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
                
            }
            //クエスト
            if gameStart {
                if qNum == 1 { quest1(pose: pose,size: dstImageSize, in: rendererContext.cgContext) }
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
    func draw(image: CGImage, in cgContext: CGContext) {
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
    func drawLine(from parentJoint: Joint,
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
        //val kadomaruShikaku = UIBezierPath(roundedRect: CGRect(x: 100, y: 100, width: 100, height: 100), cornerRadius: 10)
    }
    
    private func drawText(image: CGImage,score: CGFloat, in cgContext: CGContext){
        UIGraphicsPushContext(cgContext)
        let font = UIFont.systemFont(ofSize: 30)
        let string = NSAttributedString(string: "Score \(Int(score) / 100)", attributes: [NSAttributedString.Key.font: font])
        string.draw(at: CGPoint(x: image.width*1/10, y: image.height*9/10))
        UIGraphicsPopContext()
    }
    
    func changeSkin(){
        let skin = UserDefaults.standard.integer(forKey: DataCounter().skin)
        if skin == 001 {
            segmentColor = .systemPink
            jointColor = .red
            segmentLineWidth = 20
        }else{
            segmentColor = .green
            jointColor = .yellow
        }
    }
    
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
        if l_diff < 30 { qPlace = CGPoint(x: -100, y: 0); qScore += 1 }
        let right = pose[.rightWrist].position
        let r_diff = abs(qPlace.x - right.x) + abs(qPlace.y - right.y)
        if r_diff < 30 { qPlace = CGPoint(x: -100, y: 0); qScore += 1 }
        
        jointRadius = 30
        segmentColor = .red
        cgContext.setFillColor(jointColor.cgColor)
        //cgContext.setStrokeColor(jointColor.cgColor)
        let rectangle = CGRect(x: qPlace.x - jointRadius, y: qPlace.y - jointRadius,
                               width: jointRadius * 2, height: jointRadius * 2)
        cgContext.setLineWidth(9)
        cgContext.fillEllipse(in: rectangle)
        cgContext.drawPath(using: .stroke)
        jointRadius = 9
        segmentColor = .green
        
    }
    
}
