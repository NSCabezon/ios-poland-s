//
//  SanpshotTestsDevices.swift
//  PLUI
//
//  Created by Marcos Álvarez Mesa on 15/12/21.
//

import UIKit

enum SnapshotTestsDeviceSceen: String, CaseIterable {

    case iPhone5
    case iPhone6
    case iPhoneX
    case iPhone13
    case iPhone13ProMax

    var screenSize: CGSize {

        switch self {
        case .iPhone5:
            return CGSize(width: 320, height: 568)
        case .iPhone6:
            return CGSize(width: 375, height: 667)
        case .iPhoneX:
            return CGSize(width: 375, height: 812)
        case .iPhone13:
            return CGSize(width: 390, height: 844)
        case .iPhone13ProMax:
            return CGSize(width: 428, height: 926)
        }
    }

    var screenIdentifier: String {
        
        return self.rawValue
    }
}
