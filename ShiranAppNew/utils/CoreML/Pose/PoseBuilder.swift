
import CoreGraphics

struct PoseBuilder {
    let output: PoseNetOutput
    let modelToInputTransformation: CGAffineTransform
    let minimumJointsValue = 0.5/// The minimum value for valid joints in a pose.ポーズ内の有効なジョイントの最小値。

    init(output: PoseNetOutput, inputImage: CGImage) {
        self.output = output

        modelToInputTransformation = CGAffineTransform(scaleX: inputImage.size.width / output.modelInputSize.width,
                                                       y: inputImage.size.height / output.modelInputSize.height)
    }
}


extension PoseBuilder {
    /// Returns a pose constructed using the outputs from the PoseNet model.
    var pose: Pose {
        var pose = Pose()

        // For each joint, find its most likely position and associated confidence
        // by querying the heatmap array for the cell with the greatest
        // confidence and using this to compute its position.
        pose.joints.values.forEach { joint in
            configure(joint: joint)
        }

        // Compute and assign the confidence for the pose.
        pose.confidence = pose.joints.values
            .map { $0.confidence }.reduce(0, +) / Double(Joint.numberOfJoints)

        // Map the pose joints positions back onto the original image.
        pose.joints.values.forEach { joint in
            joint.position = joint.position.applying(modelToInputTransformation)
        }

        return pose
    }
    
    /// Sets the joint's properties using the associated cell with the greatest confidence.
    ///
    /// The confidence is obtained from the `heatmap` array output by the PoseNet model.
    /// - parameters:
    ///     - joint: The joint to update.
    private func configure(joint: Joint) {
        // Iterate over the heatmap's associated joint channel to locate the
        // cell with the greatest confidence.
        var bestCell = PoseNetOutput.Cell(0, 0)
        var bestConfidence = 0.0
        for yIndex in 0..<output.height {
            for xIndex in 0..<output.width {
                let currentCell = PoseNetOutput.Cell(yIndex, xIndex)
                let currentConfidence = output.confidence(for: joint.name, at: currentCell)

                // Keep track of the cell with the greatest confidence.
                if currentConfidence > bestConfidence {
                    bestConfidence = currentConfidence
                    bestCell = currentCell
                }
            }
        }

        // Update joint.
        joint.cell = bestCell
        joint.position = output.position(for: joint.name, at: joint.cell)
        joint.confidence = bestConfidence
        joint.isValid = joint.confidence >= minimumJointsValue
    }
    
    static func sample(size: CGSize) -> Pose {
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
            case Joint.Name.leftAnkle:    point = CGPoint(x: w*0.63, y: h*0.85);joint.isValid = true
            case Joint.Name.rightAnkle:   point = CGPoint(x: w*0.37, y: h*0.85);joint.isValid = true
            default:point = CGPoint();joint.isValid = false
            }
            joint.position = point
        }
        return pose
    }
}
