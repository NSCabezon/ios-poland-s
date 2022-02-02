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
                let containsAccountNotVisible = gpNotVisibleAccounts.contains { accountNotVisibles in
                    return account.ibanRepresentable?.codBban.contains(accountNotVisibles.representable.ibanRepresentable?.codBban ?? "") ?? false
                }
                guard containsAccountNotVisible else {
                    accountVisibles.append(account)
                    return
                }
                accountNotVisibles.append(account)
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
