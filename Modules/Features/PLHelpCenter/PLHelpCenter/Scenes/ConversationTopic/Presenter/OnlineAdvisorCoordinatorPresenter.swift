//
//  OnlineAdvisorCoordinatorPresenter.swift
//  PLHelpCenter
//
//  Created by 185860 on 23/03/2022.
//

import Foundation
import CoreFoundationLib
import UI

public protocol OnlineAdvisorCoordinatorPresenterProtocol: MenuTextWrapperProtocol {
    func getUserContext(parameters: String?)
    var onlineAdvisorParameters: String? { get set }
}

final class OnlineAdvisorCoordinatorPresenter: OnlineAdvisorCoordinatorPresenterProtocol {
    public var onlineAdvisorParameters: String?
    
    var dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    private var getUserContextForOnlineAdvisorUseCase: GetUserContextForOnlineAdvisorUseCaseProtocol {
        dependenciesResolver.resolve(for: GetUserContextForOnlineAdvisorUseCaseProtocol.self)
    }
    
    private func getServicesBaseAddress() -> String? {
        let onlineAdvisorDTO = dependenciesResolver.resolve(for: PLHelpCenterOnlineAdvisorRepository.self).get()
        let servicesBaseAddress = onlineAdvisorDTO?.servicesBaseAddress
        return servicesBaseAddress
    }
    
    func getUserContext(parameters: String?) {
        guard let url = getServicesBaseAddress() else { return }
        
        let pairs = parameters?.components(separatedBy: ";")
        let result = pairs?.reduce(into: [String: String](), { parameters, pairs in
            let splitPair = pairs.components(separatedBy: "=")
            let key = splitPair.first
            let value = splitPair.last?.removingPercentEncoding?.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
            parameters[key ?? ""] = value ?? ""
        })
       
        let input = GetUserContextForOnlineAdvisorUseCaseOkInput(
            entryType: result?["entryType"]?.removingPercentEncoding ?? "",
            mediumType: result?["mediumType"]?.removingPercentEncoding ?? "",
            subjectID: result?["subjectId"]?.removingPercentEncoding ?? "",
            baseAddress: url
        )
        
        let onlineAdvisor = self.dependenciesResolver.resolve(for: PLOnlineAdvisorManagerProtocol.self)
        Scenario(useCase: getUserContextForOnlineAdvisorUseCase, input: input)
            .execute(on: dependenciesResolver.resolve())
            .onSuccess { response in
                let initialParams = response.pdata
                onlineAdvisor.open(initialParams: initialParams)
            }
            .onError {error in
                Toast.show(error.getErrorDesc() ?? "")
            }
    }
}

