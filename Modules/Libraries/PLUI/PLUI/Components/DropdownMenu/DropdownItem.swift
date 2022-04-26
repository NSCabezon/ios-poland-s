//
//  DropdownItem.swift
//
//  Created by Piotr Mielcarzewicz on 24/06/2021.
//

public struct DropdownItem {
    public let name: String
    public let action: () -> Void
    
    public init(name: String, action: @escaping () -> Void) {
        self.name = name
        self.action = action
    }
}
