import CoreFoundationLib
import UI

public protocol PLOnlineAdvisorManagerProtocol {
    func open(initialParams: String)
}

protocol HelpCenterConversationTopicPresenterProtocol: MenuTextWrapperProtocol {
    var view: HelpCenterConversationTopicViewProtocol? { get set }

    func backButtonSelected()
    func setUp(with: HelpCenterConfig.AdvisorDetails)
    func performActionFor(subjectDetails: HelpCenterConfig.SubjectDetails, mediumType: String, baseAddress: String)
}

final class HelpCenterConversationTopicPresenter {
    weak var view: HelpCenterConversationTopicViewProtocol?
    let dependenciesResolver: DependenciesResolver

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    private var getUserContextForOnlineAdvisorUseCase: GetUserContextForOnlineAdvisorUseCaseProtocol {
        dependenciesResolver.resolve(for: GetUserContextForOnlineAdvisorUseCaseProtocol.self)
    }
    
}

private extension HelpCenterConversationTopicPresenter {
    var coordinator: HelpCenterConversationTopicCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: HelpCenterConversationTopicCoordinatorProtocol.self)
    }
}

extension HelpCenterConversationTopicPresenter: HelpCenterConversationTopicPresenterProtocol {
    
    func backButtonSelected() {
        coordinator.goBack()
    }
    
    func setUp(with advisorDetails: HelpCenterConfig.AdvisorDetails) {
        let elements = advisorDetails.subjects.compactMap({ subject in
            return HelpCenterElementViewModel(element: .subject(details: subject),
                                              action: { [weak self] in
                                                self?.performActionFor(subjectDetails: subject,
                                                                       mediumType: advisorDetails.mediumType.rawValue,
                                                                       baseAddress: advisorDetails.baseAddress)
                                              })
        })
        let viewModel = HelpCenterSectionViewModel(sectionType: .conversationTopic, elements: elements)
        
        self.view?.setup(with: [viewModel])
    }
    
    func performActionFor(subjectDetails: HelpCenterConfig.SubjectDetails, mediumType: String, baseAddress: String) {
        if subjectDetails.loginActionRequired {
            // TODO: Implement the flow that requires user to log-in [MOBILE-7891]
            Toast.show(localized("generic_alert_notAvailableOperation"))
        } else {
            loadUserContextThenGoToOnlineAdvisor(
                subjectDetails: subjectDetails,
                mediumType: mediumType,
                baseAddress: baseAddress
            )
        }
    }
    
    private func loadUserContextThenGoToOnlineAdvisor(
        subjectDetails: HelpCenterConfig.SubjectDetails,
        mediumType: String,
        baseAddress: String
    ) {
        view?.showLoading()
        let input = GetUserContextForOnlineAdvisorUseCaseOkInput(
            entryType: subjectDetails.entryType,
            mediumType: mediumType,
            subjectID: subjectDetails.subjectId,
            baseAddress: baseAddress
        )
        Scenario(useCase: getUserContextForOnlineAdvisorUseCase, input: input)
            .execute(on: dependenciesResolver.resolve())
            .onSuccess { [weak self] response in
                self?.view?.dismissLoading {
                    let initialParams = response.pdata
                    let onlineAdvisor = self?.dependenciesResolver.resolve(for: PLOnlineAdvisorManagerProtocol.self)
                    onlineAdvisor?.open(initialParams: initialParams)
                }
            }
            .onError { [weak self] _ in
                self?.view?.dismissLoading {
                    self?.view?.showErrorDialog()
                }
            }
    }
}

extension HelpCenterConversationTopicPresenter: AutomaticScreenActionTrackable {
    var trackerPage: PLHelpCenterPage {
        PLHelpCenterPage()
    }
    var trackerManager: TrackerManager {
        self.dependenciesResolver.resolve(for: TrackerManager.self)
    }
}

