//
//  QRCodeDetector.swift
//  Pods
//
//  Created by 188216 on 18/03/2022.
//

import Foundation
import UIKit

protocol QRCodeDetectorProtocol {
    func detectQrCodes(in image: UIImage) -> [String]
}

final class QRCodeDetector: QRCodeDetectorProtocol {
    func detectQrCodes(in image: UIImage) -> [String] {
        guard let ciImage = CIImage(image: image) else {
            return []
        }
        
        let detectorOptions = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: detectorOptions)
        let detectedFeature = detector?.features(in: ciImage) ?? []
        return detectedFeature.compactMap { feature in
            return (feature as? CIQRCodeFeature)?.messageString
        }
    }
}
