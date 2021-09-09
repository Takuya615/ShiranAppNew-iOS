//
//  PoseUIView.swift
//  ShiranAppNew
//
//  Created by user on 2021/09/08.
//
/*
import Foundation
import UIKit

class PoseUIView: UIView{
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
    @IBInspectable var segmentLineWidth: CGFloat = 5
    /// The color of the line connecting two joints.
    @IBInspectable var segmentColor: UIColor = UIColor.green//.systemGreen//.systemTeal
    /// The radius of the circles drawn for each joint.
    @IBInspectable var jointRadius: CGFloat = 8
    /// The color of the circles drawn for each joint.
    @IBInspectable var jointColor: UIColor = UIColor.yellow//.systemYellow//.systemPink
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //self.backgroundColor = .clear
        //self.isOpaque = false
    }
    

    var pose: Pose
    var score: CGFloat
    override init(frame: CGRect/*,pose: Pose,score: CGFloat*/) {
        //super.init(frame: frame)
        super .init(frame: frame)
        //self.pose = pose
        //self.score = score
        
        //self.backgroundColor = .clear
        //self.isOpaque = false
    }
    
    override func draw(_ rect: CGRect) {
        let context:CGContext = UIGraphicsGetCurrentContext()!
        
        //draw(image: <#T##CGImage#>, in: context)
        
    }
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
}
*/
