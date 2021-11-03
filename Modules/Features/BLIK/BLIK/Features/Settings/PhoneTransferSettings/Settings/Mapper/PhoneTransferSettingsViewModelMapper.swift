//
//  PhoneTransferSettingsViewModelMapper.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 27/07/2021.
//

protocol PhoneTransferSettingsViewModelMapping {
    func map(wallet: GetWalletUseCaseOkOutput.Wallet) -> PhoneTransferSettingsViewModel
}

final class PhoneTransferSettingsViewModelMapper: PhoneTransferSettingsViewModelMapping {
    func map(wallet: GetWalletUseCaseOkOutput.Wallet) -> PhoneTransferSettingsViewModel {
        guard wallet.alias.isSynced else {
            return .expiredPhoneNumber
        }
        
        switch wallet.alias.type {
        case .empty, .eWallet_Alias:
            return .unregisteredPhoneNumber
        case .eWalletAndPSP_Alias:
            return .registeredPhoneNumber
        }
    }
}
