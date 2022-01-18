////
////  PLPublicMenuViewContainer.swift
////  Santander
////
////  Created by crodrigueza on 21/9/21.
////
//
//import Menu
//import Commons
//import SANPLLibrary
//
//final class PLPublicMenuViewContainer {
//    private let resolver: DependenciesResolver
//    private let viewComponent: PLPublicMenuViewComponents
//    private let mainStackView = UIStackView()
//    
//    init(resolver: DependenciesResolver) {
//        self.resolver = resolver
//        self.viewComponent = PLPublicMenuViewComponents(resolver: resolver)
//    }
//    
//    func createView(data: PublicMenuViewComponentsProtocol?) -> UIView {
//        self.viewComponent.dataComponent = data
//        self.configureStackView()
//        self.createFirstRow()
//        self.createATM()
//        self.createThirdRow()
//        if isTrustedDevice() {
//            self.createMobileAuthorizationView()
//        }
//        
//        return self.mainStackView
//    }
//}
//
//private extension PLPublicMenuViewContainer {
//    func createFirstRow() {
//        let otherUserView = self.viewComponent.createOtherUserView()
//        let informationView = self.viewComponent.createInformationView()
//        let servicesView = self.viewComponent.createServicesView()
//        let stackViewCol = UIStackView()
//        stackViewCol.translatesAutoresizingMaskIntoConstraints = false
//        stackViewCol.axis = .vertical
//        stackViewCol.spacing = 8
//        stackViewCol.distribution = .fillEqually
//        if isTrustedDevice() {
//            stackViewCol.addArrangedSubview(otherUserView)
//        }
//        stackViewCol.addArrangedSubview(informationView)
//        let stackViewRow = UIStackView()
//        stackViewRow.translatesAutoresizingMaskIntoConstraints = false
//        stackViewRow.axis = .horizontal
//        stackViewRow.spacing = 8
//        stackViewRow.distribution = .fillEqually
//        stackViewRow.heightAnchor.constraint(equalToConstant: 128.0).isActive = true
//        stackViewRow.addArrangedSubview(stackViewCol)
//        stackViewRow.addArrangedSubview(servicesView)
//        self.mainStackView.addArrangedSubview(stackViewRow)
//    }
//    
//    func createATM() {
//        let view = self.viewComponent.createPLATMView()
//        view.heightAnchor.constraint(equalToConstant: 88.0).isActive = true
//        self.mainStackView.addArrangedSubview(view)
//    }
//    
//    func createThirdRow() {
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .horizontal
//        stackView.spacing = 8
//        stackView.distribution = .fillEqually
//        stackView.heightAnchor.constraint(equalToConstant: 128.0).isActive = true
//        let offerView = self.viewComponent.createOfferView()
//        let contactView = self.viewComponent.createContactView()
//        stackView.addArrangedSubview(offerView)
//        stackView.addArrangedSubview(contactView)
//        self.mainStackView.addArrangedSubview(stackView)
//    }
//    
//    func createMobileAuthorizationView() {
//        let view = self.viewComponent.createMobileAuthorizationView()
//        view.heightAnchor.constraint(equalToConstant: 56.0).isActive = true
//        self.mainStackView.addArrangedSubview(view)
//    }
//    
//    func configureStackView() {
//        self.mainStackView.translatesAutoresizingMaskIntoConstraints = false
//        self.mainStackView.axis = .vertical
//        self.mainStackView.spacing = 8
//        self.mainStackView.distribution = .fill
//    }
//}
//
//private extension PLPublicMenuViewContainer {
//    func isTrustedDevice() -> Bool {
//        let managerProvider: PLManagersProviderProtocol = self.resolver.resolve(for: PLManagersProviderProtocol.self)
//        let trustedDeviceManager = managerProvider.getTrustedDeviceManager()
//        return trustedDeviceManager.getTrustedDeviceHeaders() != nil
//    }
//}
//extension PLPublicMenuViewContainer: PublicMenuViewContainerProtocol { }
