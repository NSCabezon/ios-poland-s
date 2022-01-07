//
//  PLEnvironmentEntity.swift
//  PLLogin

import Foundation

import CoreFoundationLib
import SANPLLibrary

struct PLEnvironmentEntity: CustomStringConvertible, Codable, DTOInstantiable {
    let dto: BSANPLEnvironmentDTO

    init(_ dto: BSANPLEnvironmentDTO) {
        self.dto = dto
    }

    func getBSANEnvironmentDTO() -> BSANPLEnvironmentDTO {
        return self.dto
    }

    var name: String {
        return self.dto.name
    }

    var urlBase: String {
        return self.dto.urlBase
    }

    var description: String {
        return "\(name): \(urlBase)"
    }
}
