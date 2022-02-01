//
//  PLHelpCenterPresenter.swift
//  Pods
//
//  Created by 186484 on 04/06/2021.
//

import CoreFoundationLib
import PLCommons
import PLCommonOperatives
import UI

protocol HelpCenterDashboardPresenterProtocol: MenuTextWrapperProtocol {
    var view: HelpCenterDashboardViewProtocol? { get set }

    func viewDidLoad()
    func viewWillAppear()
    func backButtonSelected()
    func didSelectMenu()
}

final class HelpCenterDashboardPresenter {
    weak var view: HelpCenterDashboardViewProtocol?
    let dependenciesResolver: DependenciesResolver
    
    private var sceneType: HelpCenterSceneType?
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    private var getHelpCenterSceneTypeUseCase: GetHelpCenterSceneTypeUseCaseProtocol {
        return dependenciesResolver.resolve(for: GetHelpCenterSceneTypeUseCaseProtocol.self)
    }
    
    private var getHelpCenterConfigUseCase: GetHelpCenterConfigUseCaseProtocol {
        return dependenciesResolver.resolve(for: GetHelpCenterConfigUseCaseProtocol.self)
    }

    private var getUserContextForOnlineAdvisorUseCase: GetUserContextForOnlineAdvisorUseCaseProtocol {
        dependenciesResolver.resolve(for: GetUserContextForOnlineAdvisorUseCaseProtocol.self)
    }
}

private extension HelpCenterDashboardPresenter {
    var coordinator: HelpCenterDashboardCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: HelpCenterDashboardCoordinatorProtocol.self)
    }
    
    private var moduleCoordinatorDelegate: PLHelpCenterModuleCoordinatorDelegate {
        return self.dependenciesResolver.resolve(for: PLHelpCenterModuleCoordinatorDelegate.self)
    }
}

extension HelpCenterDashboardPresenter: HelpCenterDashboardPresenterProtocol, OpenUrlCapable {
    
    func viewDidLoad() {
        loadConfig()
    }
    
    func viewWillAppear() {
        setUpSceneType()
    }
    
    func backButtonSelected() {
        coordinator.goBack()
    }
    
    func didSelectMenu() {
        moduleCoordinatorDelegate.didSelectMenu()
    }
    
    private func setUpSceneType() {
        if let sceneType = sceneType {
            view?.setSceneType(sceneType)
        } else {
            Scenario(useCase: getHelpCenterSceneTypeUseCase)
                .execute(on: dependenciesResolver.resolve())
                .onSuccess { [weak self] result in
                    self?.sceneType = result.sceneType
                    self?.view?.setSceneType(result.sceneType)
                }
        }
    }
    
    private func loadConfig() {
        view?.showLoading(completion: { [weak self] in
            guard let self = self else { return }
            Scenario(useCase: self.getHelpCenterConfigUseCase)
                .execute(on: self.dependenciesResolver.resolve())
                .onSuccess { [weak self] result in
                    self?.view?.dismissLoading()
                    self?.setupViewModels(with: result.helpCenterConfig)
                }
                .onError { [weak self] _ in
                    self?.view?.dismissLoading()
                }
        })
    }
    
    private func setupViewModels(with helpCenterConfig: HelpCenterConfig) {
        let viewModels: [HelpCenterSectionViewModel] = helpCenterConfig.sections.map { section in
            let elements = section.elements.map { element in
                HelpCenterElementViewModel(element: element) {
                    self.performActionFor(element: element)
                }
            }
            return HelpCenterSectionViewModel(sectionType: section.section, elements: elements)
        }
        self.view?.setup(with: viewModels)
    }
    
    private func performActionFor(element: HelpCenterConfig.Element) {
        print("☘️ performActionFor element \(element)")
        switch element {
        case .advisor(_, _, let details):
            performActionFor(advisorDetails: details)
        case .call(let phoneNumber):
            performActionFor(phoneNumber: phoneNumber)
        case .yourCases, .mailContact:
            openWebView(withIdentifier: element.webViewIdentifier)
        default:
            //TODO
            // Implement others actions
            print("TODO: Implement others actions")
        }
    }
    
    func performActionFor(advisorDetails: HelpCenterConfig.AdvisorDetails) {
        switch advisorDetails.subjects.count {
        case 1:
            performActionForSingleSubjectIn(advisorDetails: advisorDetails)
        default:
            coordinator.goToConversationTopicScene(advisorDetails: advisorDetails)
        }
    }
    
    func performActionFor(phoneNumber: String) {
        let preFormattedPhoneNumber = phoneNumber.notWhitespaces()
        guard let phoneURL = URL(string: "tel://\(preFormattedPhoneNumber)"),
              canOpenUrl(phoneURL) else { return }
        openUrl(phoneURL)
    }
    
    private func performActionForSingleSubjectIn(advisorDetails: HelpCenterConfig.AdvisorDetails) {
        guard let subject = advisorDetails.subjects.first else { fatalError() }
        
        if subject.loginActionRequired {
            // TODO: Implement the flow that requires user to log-in [MOBILE-7891]
            Toast.show(localized("generic_alert_notAvailableOperation"))
        } else {
            loadUserContextThenGoToOnlineAdvisor(advisorDetails: advisorDetails)
        }
    }
    
    private func loadUserContextThenGoToOnlineAdvisor(advisorDetails: HelpCenterConfig.AdvisorDetails) {
        guard let subject = advisorDetails.subjects.first else { fatalError() }
        
        view?.showLoading()
        let input = GetUserContextForOnlineAdvisorUseCaseOkInput(
            entryType: subject.entryType,
            mediumType: advisorDetails.mediumType.rawValue,
            subjectID: subject.subjectId,
            baseAddress: advisorDetails.baseAddress
        )
        Scenario(useCase: getUserContextForOnlineAdvisorUseCase, input: input)
            .execute(on: dependenciesResolver.resolve())
            .onSuccess { [weak self] _ in
                self?.view?.dismissLoading {
                    // TODO:
                    // Should be implemented in [MOBILE-8288]
                    Toast.show(localized("generic_alert_notAvailableOperation"))
                }
            }
            .onError { _ in
                self.view?.dismissLoading {
                    self.view?.showErrorDialog()
                }
            }
    }
    
    private func openWebView(withIdentifier identifier: String?) {
        guard let identifier = identifier else { return }
        let repository = self.dependenciesResolver.resolve(for: PLWebViewLinkRepositoryProtocol.self)
        guard let webViewLink = repository.getWebViewLink(forIdentifier: identifier) else { return }
        guard webViewLink.isAvailable else {
            return Toast.show(localized("generic_alert_notAvailableOperation"))
        }
        
        let input = GetBasePLWebConfigurationUseCaseInput(webViewLink: webViewLink)
        let useCase = self.dependenciesResolver.resolve(for: GetBasePLWebConfigurationUseCaseProtocol.self)
        
        Scenario(useCase: useCase, input: input)
            .execute(on: self.dependenciesResolver.resolve())
            .onSuccess { [weak self] result in
                self?.coordinator.openWebView(withConfiguration: result.configuration)
            }
            .onError { error in
                Toast.show(error.getErrorDesc() ?? "")
            }
    }
}

extension HelpCenterDashboardPresenter: AutomaticScreenActionTrackable {
    var trackerPage: PLHelpCenterPage {
        PLHelpCenterPage()
    }
    var trackerManager: TrackerManager {
        self.dependenciesResolver.resolve(for: TrackerManager.self)
    }
}

//TODO:
//Change it in future
public struct PLHelpCenterPage: PageWithActionTrackable {
    public typealias ActionType = Action
    public let page = "examplePage"
    
    public enum Action: String {
        case apply = "example"
    }
    public init() {}
}
