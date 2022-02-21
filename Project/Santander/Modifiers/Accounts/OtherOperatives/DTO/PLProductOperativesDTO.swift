//
//  PLAccountOtherOperativesDTO.swift
//  Santander
//
//  Created by Julio Nieto Santiago on 7/10/21.
//

import Foundation
import CoreFoundationLib

struct PLProductOperativesDTO: Codable {
    let id: String?
    let url: String?
    let method: String?
    let isAvailable: Bool?
    var isFullScreen: Bool = true

    var getHTTPMethod: HTTPMethodType {
        if self.method == "GET" {
            return .get
        } else {
            return .post
        }
    }
}
