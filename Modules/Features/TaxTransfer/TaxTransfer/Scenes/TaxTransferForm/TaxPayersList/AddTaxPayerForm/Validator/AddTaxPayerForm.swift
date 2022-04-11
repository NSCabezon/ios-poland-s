//
//  AddTaxPayerForm.swift
//  TaxTransfer
//
//  Created by 187831 on 07/02/2022.
//

struct AddTaxPayerForm {
    let payerName: String
    let identifierNumber: String
    let identifierType: TaxIdentifierType
    
    var isEmpty: Bool {
        return payerName.isEmpty || identifierNumber.isEmpty
    }
}
