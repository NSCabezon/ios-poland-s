//
//  BLIKTransactionViewModelSource.swift
//  BLIK
//
//  Created by 185167 on 19/11/2021.
//

enum BLIKTransactionViewModelSource {
    case prefetched(BLIKTransactionViewModel)
    case needsToBeFetched
}
