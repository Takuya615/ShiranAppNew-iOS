/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 Implementation details of a structure used to describe a pose.
 */

import CoreGraphics

struct Pose {
    static func defaultPose(size: CGSize) -> Pose {
        let pose: Pose = Pose()
        let w = size.width
        let h = size.height
        pose.joints.values.forEach { joint in
            var point: CGPoint = .zero
            switch joint.name {
            case Joint.Name.nose:         point = CGPoint(x: w*0.5, y: h*0.15);joint.isValid = true
            case Joint.Name.leftShoulder: point = CGPoint(x: w*0.62, y: h*0.25);joint.isValid = true
            case Joint.Name.rightShoulder:point = CGPoint(x: w*0.38, y: h*0.25);joint.isValid = true
            case Joint.Name.leftElbow:    point = CGPoint(x: w*0.73, y: h*0.38);joint.isValid = true
            case Joint.Name.rightElbow:   point = CGPoint(x: w*0.27, y: h*0.38);joint.isValid = true
            case Joint.Name.leftWrist:    point = CGPoint(x: w*0.78, y: h*0.51);joint.isValid = true
            case Joint.Name.rightWrist:   point = CGPoint(x: w*0.26, y: h*0.51);joint.isValid = true
            case Joint.Name.leftHip:      point = CGPoint(x: w*0.61, y: h*0.55);joint.isValid = true
            case Joint.Name.rightHip:     point = CGPoint(x: w*0.39, y: h*0.55);joint.isValid = true
            case Joint.Name.leftKnee:     point = CGPoint(x: w*0.63, y: h*0.7);joint.isValid = true
            case Joint.Name.rightKnee:    point = CGPoint(x: w*0.37, y: h*0.7);joint.isValid = true
            case Joint.Name.leftAnkle:    point = CGPoint(x: w*0.63, y: h*0.9);joint.isValid = true
            case Joint.Name.rightAnkle:   point = CGPoint(x: w*0.37, y: h*0.9);joint.isValid = true
            default:point = CGPoint();joint.isValid = false
            }
            joint.position = point
        }
        return pose
    }
    
    /// A structure used to describe a parent-child relationship between two joints.
    struct Edge {
        let index: Int
        let parent: Joint.Name
        let child: Joint.Name
        
        init(from parent: Joint.Name, to child: Joint.Name, index: Int) {
            self.index = index
            self.parent = parent
            self.child = child
        }
    }
    
    /// An array of edges used to define the connections between the joints.
    ///
    /// The index relates to the index used to access the associated value within the displacement maps
    /// output by the PoseNet model.
    static let edges = [
        Edge(from: .nose, to: .leftEye, index: 0),
        Edge(from: .leftEye, to: .leftEar, index: 1),
        Edge(from: .nose, to: .rightEye, index: 2),
        Edge(from: .rightEye, to: .rightEar, index: 3),
        Edge(from: .nose, to: .leftShoulder, index: 4),
        Edge(from: .leftShoulder, to: .leftElbow, index: 5),
        Edge(from: .leftElbow, to: .leftWrist, index: 6),
        Edge(from: .leftShoulder, to: .leftHip, index: 7),
        Edge(from: .leftHip, to: .leftKnee, index: 8),
        Edge(from: .leftKnee, to: .leftAnkle, index: 9),
        Edge(from: .nose, to: .rightShoulder, index: 10),
        Edge(from: .rightShoulder, to: .rightElbow, index: 11),
        Edge(from: .rightElbow, to: .rightWrist, index: 12),
        Edge(from: .rightShoulder, to: .rightHip, index: 13),
        Edge(from: .rightHip, to: .rightKnee, index: 14),
        Edge(from: .rightKnee, to: .rightAnkle, index: 15)
    ]
    
    /// The joints that make up a pose.
    private(set) var joints: [Joint.Name: Joint] = [
        .nose: Joint(name: .nose),
        //.leftEye: Joint(name: .leftEye),
        .leftEar: Joint(name: .leftEar),
        .leftShoulder: Joint(name: .leftShoulder),
        .leftElbow: Joint(name: .leftElbow),
        .leftWrist: Joint(name: .leftWrist),
        .leftHip: Joint(name: .leftHip),
        .leftKnee: Joint(name: .leftKnee),
        .leftAnkle: Joint(name: .leftAnkle),
        //.rightEye: Joint(name: .rightEye),
        .rightEar: Joint(name: .rightEar),
        .rightShoulder: Joint(name: .rightShoulder),
        .rightElbow: Joint(name: .rightElbow),
        .rightWrist: Joint(name: .rightWrist),
        .rightHip: Joint(name: .rightHip),
        .rightKnee: Joint(name: .rightKnee),
        .rightAnkle: Joint(name: .rightAnkle)
    ]
    
    var joints2: [Joint.Name] = [
        .nose,
        .leftShoulder,
        .leftElbow,
        .leftWrist,
        .leftHip,
        .leftKnee,
        .leftAnkle,
        
            .rightShoulder,
        .rightElbow,
        .rightWrist,
        .rightHip,
        .rightKnee,
        .rightAnkle
    ]
    
    /// The confidence score associated with this pose.
    var confidence: Double = 0.0
    
    /// Accesses the joint with the specified name.
    subscript(jointName: Joint.Name) -> Joint {
        get {
            assert(joints[jointName] != nil)
            return joints[jointName]!
        }
        set {
            joints[jointName] = newValue
        }
    }
    
    /// Returns all edges that link **from** or **to** the specified joint.
    ///
    /// - parameters:
    ///     - jointName: Query joint name.
    /// - returns: All edges that connect to or from `jointName`.
    static func edges(for jointName: Joint.Name) -> [Edge] {
        return Pose.edges.filter {
            $0.parent == jointName || $0.child == jointName
        }
    }
    
    /// Returns the edge having the specified parent and child  joint names.
    ///
    /// - parameters:
    ///     - parentJointName: Edge's parent joint name.
    ///     - childJointName: Edge's child joint name.
    /// - returns: All edges that connect to or from `jointName`.
    static func edge(from parentJointName: Joint.Name, to childJointName: Joint.Name) -> Edge? {
        return Pose.edges.first(where: { $0.parent == parentJointName && $0.child == childJointName })
    }
}
