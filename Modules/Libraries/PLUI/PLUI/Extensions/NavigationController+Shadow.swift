//
//  NavigationController+Shadow.swift
//  BLIK
//
//  Created by 186492 on 10/06/2021.
//

import Foundation
import UI

public extension UINavigationController {
    func addNavigationBarShadow() {
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.shadowImage = UIColor.mediumSkyGray.image()
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        } else {
            navigationBar.shadowImage = UIColor.mediumSkyGray.image()
        }
    }
}

private extension UIColor {
    func image(_ size: CGSize = .init(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
