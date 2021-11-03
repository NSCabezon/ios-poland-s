//
//  SharedValueBox.swift
//  BLIK
//
//  Created by 185167 on 15/10/2021.
//

class SharedValueBox<ValueType> {
    private var value: ValueType
    private let syncQueue = DispatchQueue(
        label: "pl.santander.mobile.Blik.SharedValueBox.\(ValueType.self)"
    )
    
    init(value: ValueType) {
        self.value = value
    }
    
    func setValue(_ newValue: ValueType) {
        syncQueue.sync {
            self.value = newValue
        }
    }
    
    func getValue() -> ValueType {
        return syncQueue.sync {
            return self.value
        }
    }
}
