/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The implementation details of a structure that hold the parameters algorithms use for
 estimating poses.
*/

import CoreGraphics

enum Algorithm: Int {
    case single
    case multiple
}

struct PoseBuilderConfiguration {
    /// The minimum value for valid joints in a pose.ポーズ内の有効なジョイントの最小値。
    var jointConfidenceThreshold = 0.5

    /// The minimum value for a valid pose.  有効なポーズの最小値。
    var poseConfidenceThreshold = 0.5

    /*
    /// The minimum distance between two distinct joints of the same type.  同じタイプの2つの異なるジョイント間の最小距離。
    ///
    /// - Note: This parameter only applies to the multiple-pose algorithm.このパラメーターは、マルチポーズアルゴリズムにのみ適用されます。
    var matchingJointDistance = 40.0

    /// Search radius used when checking if a joint has the greatest confidence amongst its neighbors.
    ///ジョイントが隣接するジョイントの中で最大の信頼性を持っているかどうかをチェックするときに使用される検索半径
    /// - Note: This parameter only applies to the multiple-pose algorithm. マルチポーズアルゴリズムにのみ適用されます。
    var localSearchRadius = 3

    /// The maximum number of poses returned.  返されるポーズの最大数。
    ///
    /// - Note: This parameter only applies to the multiple-pose algorithm.  マルチポーズアルゴリズムにのみ適用されます。
    var maxPoseCount = 15

    /// The number of iterations performed to refine an adjacent joint's position.
    ///
    /// - Note: This parameter only applies to the multiple-pose algorithm.  マルチポーズアルゴリズムにのみ適用されます。
    var adjacentJointOffsetRefinementSteps = 3
    */
}
