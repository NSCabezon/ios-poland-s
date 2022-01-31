//
//  ContextSelectorViewModel.swift
//  PLContexts
//

import SANPLLibrary
import UIKit
import Commons

public struct ContextSelectorViewModel {
    public let ownerId: String
    public let abbreviationColor: UIColor
    public let selected: Bool
    public var formattedName: String {
        self.name.lowercased().camelCasedString.withMaxSize(20, truncateTail: true)
    }
    public var typeName: String {
        self.getContextTypeName()
    }
    public var abbreviation: String {
        self.getAbbreviation()
    }
    public var backgroundColor: UIColor {
        self.selected ? .turquoise.withAlphaComponent(0.07) : .white
    }
    public var textColor: UIColor {
        self.selected ? .darkTorquoise : .lisboaGray
    }
    private let name: String
    private let type: ContextType?

    public init(ownerId: String, name: String, type: ContextType?, abbreviationColor: UIColor, selected: Bool) {
        self.ownerId = ownerId
        self.name = name
        self.type = type
        self.abbreviationColor = abbreviationColor
        self.selected = selected
    }

    private func getContextTypeName() -> String {
        switch self.type {
        case .PROXY:
            return localized("pl_context_type_proxy")
        case .INDIVIDUAL:
            return localized("pl_context_type_individual")
        case .COMPANY:
            return localized("pl_context_type_company")
        case .MINI_COMPANY:
            return localized("pl_context_type_mini_company")
        default:
            return ""
        }
    }

    private func getAbbreviation() -> String {
        let initials = self.name.split(" ")
        let firstInitial = initials.first?.prefix(1) ?? ""
        let secondInitial = initials.count > 1 ? initials[1].prefix(1) : ""
        return "\(firstInitial)\(secondInitial)".uppercased()
    }
}
