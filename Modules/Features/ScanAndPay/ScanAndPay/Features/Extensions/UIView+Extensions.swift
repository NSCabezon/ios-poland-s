//
//  UIView+Extensions.swift
//  ScanAndPay
//
//  Created by 188216 on 13/04/2022.
//

import Foundation
import UIKit

extension UIView {
    func asImage() -> UIImage {
        return UIGraphicsImageRenderer(size: bounds.size).image { _ in
            drawHierarchy(in: CGRect(origin: .zero, size: bounds.size), afterScreenUpdates: true)
        }
    }
}
