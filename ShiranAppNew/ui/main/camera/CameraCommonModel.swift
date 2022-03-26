//
//  CameraCommonModel.swift
//  ShiranAppNew
//
//  Created by 津村拓哉 on 2022/03/26.
//

import Foundation
import SwiftUI

struct CameraCommon{
    //画像の１８０度回転
    static func inversionImage(image: UIImage) -> UIImage {
        print("こもん　１８０度回転")
        let degrees: CGFloat = 180.0
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(image.cgImage!, in: CGRect(x: image.size.width / 2, y: image.size.height / 2, width: image.size.width, height: image.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
