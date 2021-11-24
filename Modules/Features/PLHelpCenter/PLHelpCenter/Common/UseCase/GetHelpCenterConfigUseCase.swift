import Foundation
import DomainCommon
import Commons
import Models
import SANPLLibrary

protocol GetHelpCenterConfigUseCaseProtocol: UseCase<Void, GetHelpCenterConfigUseCaseOkOutput, StringErrorOutput> {}

final class GetHelpCenterConfigUseCase: UseCase<Void, GetHelpCenterConfigUseCaseOkOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    
    private lazy var plManagersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<GetHelpCenterConfigUseCaseOkOutput, StringErrorOutput> {
        let manager = plManagersProvider.getHelpCenterManager()
        let clientProfile: HelpCenterClientProfile = getCurrentClientProfile()
        var sections: [HelpCenterConfig.Section] = []
        
        let callElements: [HelpCenterConfig.Element] = [.call(phoneNumber: "+48 61 811 99 99")]
        let advisorElements: [HelpCenterConfig.Element]
        
        if case let .success(onlineAdvisor) = try manager.getOnlineAdvisorConfig() {
            advisorElements = makeAdvisorElements(from: onlineAdvisor, for: clientProfile)
        } else {
            advisorElements = []
        }
        
        switch clientProfile {
        case .notLogged:
            sections.append(HelpCenterConfig.Section(
                section: .contact,
                elements: callElements + advisorElements
            ))
        case .individual, .company:
            if case let .success(helpQuestions) = try manager.getHelpQuestionsConfig(),
               let section = makeExpandableHintSection(from: helpQuestions, for: clientProfile) {
                sections.append(section)
            }
            sections.append(HelpCenterConfig.Section(
                section: .inAppActions,
                elements: [.yourCases]
            ))
            sections.append(HelpCenterConfig.Section(
                section: .call,
                elements: callElements
            ))
            if !advisorElements.isEmpty {
                sections.append(HelpCenterConfig.Section(
                    section: .onlineAdvisor,
                    elements: advisorElements
                ))
            }
        }
        
        let config = HelpCenterConfig(sections: sections)
        
        return .ok(GetHelpCenterConfigUseCaseOkOutput(helpCenterConfig: config))
    }
    
    private func getCurrentClientProfile() -> HelpCenterClientProfile {
        let loginManager = plManagersProvider.getLoginManager()
        if let authCredentials = try? loginManager.getAuthCredentials(),
           authCredentials.accessTokenCredentials != nil {
            // TODO: Detect what type of user is logged [MOBILE-8591], also not sure if this kind od checking logic of logged user is ok
            return .individual
        } else {
            return .notLogged
        }
    }
    
    func getCurrentLanguage() -> String? {
        return dependenciesResolver.resolve(forOptionalType: StringLoader.self)?.getCurrentLanguage().languageType.rawValue
    }
}

extension GetHelpCenterConfigUseCase: GetHelpCenterConfigUseCaseProtocol {}

struct GetHelpCenterConfigUseCaseOkOutput {
    let helpCenterConfig: HelpCenterConfig
}

private extension HelpCenterConfig.AdvisorDetails {
    
    static func mapFrom(
        channel: OnlineAdvisorDTO.Channel,
        baseAddress: String,
        iconBaseAddress: String,
        clientProfile: HelpCenterClientProfile
    ) -> HelpCenterConfig.AdvisorDetails {
        let clientIsLoggedIn = clientProfile != .notLogged
        let subjects: [HelpCenterConfig.SubjectDetails] = channel.subjects.map { subjectDTO in
            let isLoginRequired = subjectDTO.requiredLoggingIn ?? false // if this flag is missing it means that login is not required
            return HelpCenterConfig.SubjectDetails(
                name: subjectDTO.name,
                entryType: subjectDTO.entryType,
                subjectId: subjectDTO.subjectId,
                iconUrl: iconBaseAddress + subjectDTO.iconName,
                loginActionRequired: isLoginRequired && !clientIsLoggedIn
            )
        }
        return HelpCenterConfig.AdvisorDetails(mediumType: channel.mediumType, subjects: subjects, baseAddress: baseAddress, iconBaseAddress: iconBaseAddress)
    }
}

private extension GetHelpCenterConfigUseCase {
    
    private func makeExpandableHintSection(
        from helpQuestions: HelpQuestionsDTO,
        for clientProfile: HelpCenterClientProfile
    ) -> HelpCenterConfig.Section? {
        guard let currentLanguage = getCurrentLanguage(),
              let category = helpQuestions.categoryByLanguage[currentLanguage]
        else { return nil }
        
        let elements = category.sections
            .filter { $0.profiles.contains(clientProfile) }
            .flatMap {
                $0.questions.map { question in
                    HelpCenterConfig.Element.expandableHint(
                        question: question.name,
                        answer: question.answer
                    )
                }
            }
        
        return HelpCenterConfig.Section(
            section: .hints(title: category.mainWindowCategoryTitle),
            elements: elements
        )
    }
    
    private func makeAdvisorElements(
        from onlineAdvisor: OnlineAdvisorDTO,
        for clientProfile: HelpCenterClientProfile
    ) -> [HelpCenterConfig.Element] {
        var elements = onlineAdvisor.channels
            .filter {$0.profiles.contains(clientProfile)}
            .map {
                HelpCenterConfig.Element.advisor(
                    name: $0.channelName,
                    iconUrl: onlineAdvisor.iconBaseAddress + $0.iconName,
                    details: HelpCenterConfig.AdvisorDetails.mapFrom(
                        channel: $0,
                        baseAddress: onlineAdvisor.servicesBaseAddress,
                        iconBaseAddress: onlineAdvisor.iconBaseAddress,
                        clientProfile: clientProfile
                    )
                )
            }
        if let currentLanguage = getCurrentLanguage(),
           let message = onlineAdvisor.messages[currentLanguage] {
            elements.insert(.info(message: message), at: 0)
        }

        return elements
    }
}
