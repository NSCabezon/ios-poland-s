//
//  PreSetupSendMoneyUseCase.swift
//  Santander
//
//  Created by José María Jiménez Pérez on 23/9/21.
//
import CoreFoundationLib
import TransferOperatives
import Commons
import SANPLLibrary
import CoreDomain

final class PreSetupSendMoneyUseCase: UseCase<Void, PreSetupSendMoneyUseCaseOkOutput, StringErrorOutput> {
    
    let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<PreSetupSendMoneyUseCaseOkOutput, StringErrorOutput> {
        let gpNotVisibleAccounts = dependenciesResolver.resolve(for: GlobalPositionWithUserPrefsRepresentable.self).accountsNotVisiblesWithoutPiggy
        let sepaInfoRepository: SepaInfoRepositoryProtocol = self.dependenciesResolver.resolve()
        guard let sepaList = sepaInfoRepository.getSepaList() else { return .error(StringErrorOutput(nil))}
        let faqsRepository: FaqsRepositoryProtocol = self.dependenciesResolver.resolve()
        let faqs = faqsRepository.getFaqsList()?.transferOperative
        let result = try self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self).getTransferManager().getAccountsForDebit()
        var accountVisibles: [AccountRepresentable] = []
        var accountNotVisibles: [AccountRepresentable] = []
        switch result {
        case .success(let accounts):
            accounts.forEach { account in
                var found = false
                gpNotVisibleAccounts.forEach { notVisibleAccout in
                    if account.equalsTo(other: notVisibleAccout.accountRepresentable) {
                        found = true
                    }
                }
                if found {
                    accountNotVisibles.append(account)
                } else {
                    accountVisibles.append(account)
                }
            }
            return .ok(PreSetupSendMoneyUseCaseOkOutput(accountVisibles: accountVisibles,
                                                        accountNotVisibles: accountNotVisibles,
                                                        sepaList: sepaList,
                                                        faqs: faqs))
        case .failure(let error):
            return .error(StringErrorOutput(error.localizedDescription))
        }
        
    }
}

extension PreSetupSendMoneyUseCase: PreSetupSendMoneyUseCaseProtocol { }
