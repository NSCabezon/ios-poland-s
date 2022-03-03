//
//  TaxAuthorityForm.swift
//  TaxTransfer
//
//  Created by 185167 on 02/03/2022.
//

enum TaxAuthorityForm {
    case formTypeUnselected
    case us(UsTaxAuthorityForm)
    case irp(IrpTaxAuthorityForm)
}
