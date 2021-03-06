//
//  PLAccountOtherOperativesData.swift
//  Santander
//
//  Created by Julio Nieto Santiago on 7/10/21.
//

import Foundation
import CoreFoundationLib

struct PLProductOperativesData {
    var identifier: String?
    var link: String?
    var isAvailable: Bool?
    var httpMethod: HTTPMethodType?
    var parameter: String?
    var isFullScreen: Bool = true
}
