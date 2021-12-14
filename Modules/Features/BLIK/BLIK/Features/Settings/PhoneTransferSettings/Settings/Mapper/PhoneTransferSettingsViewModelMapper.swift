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
        switch (wallet.alias.isSynced, wallet.alias.type) {
        case (_, .empty):
            return .unregisteredPhoneNumber
        case (_, .eWallet_Alias):
            return .unregisteredPhoneNumber
        case (true, .eWalletAndPSP_Alias):
            return .registeredPhoneNumber
        case (false, .eWalletAndPSP_Alias):
            return .expiredPhoneNumber
        }
    }
}
