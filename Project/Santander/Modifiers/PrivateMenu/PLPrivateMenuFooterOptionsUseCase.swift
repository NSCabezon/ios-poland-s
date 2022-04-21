//
//  PLPrivateMenuFooterOptionsUseCase.swift
//  Santander
//
//  Created by Daniel Gómez Barroso on 3/2/22.
//

import PrivateMenu
import OpenCombine
import CoreDomain

struct PLPrivateMenuFooterOptionsUseCase: GetPrivateMenuFooterOptionsUseCase {
    struct PLPrivateMenuFooterOptions: PrivateMenuFooterOptionRepresentable {
        let title: String
        let imageName: String
        let imageURL: String?
        let accessibilityIdentifier: String
        let optionType: FooterOptionType
    }
    
    func fetchFooterOptions() -> AnyPublisher<[PrivateMenuFooterOptionRepresentable], Never> {
        return Just(buildOptions()).eraseToAnyPublisher()
    }
    
    func buildOptions() -> [PrivateMenuFooterOptionRepresentable] {
        var options: [PrivateMenuFooterOptionRepresentable] = []
        options.append(PLPrivateMenuFooterOptions(title: "menu_link_security",
                                    imageName: "icnSecurity",
                                    imageURL: nil,
                                    accessibilityIdentifier: "menuBtnSecurity",
                                    optionType: .security))
        options.append(PLPrivateMenuFooterOptions(title: "menu_link_atm",
                                    imageName: "icnAtmMenuBlack",
                                    imageURL: nil,
                                    accessibilityIdentifier: "menuBtnAtm",
                                    optionType: .atm))
        options.append(PLPrivateMenuFooterOptions(title: "menu_link_HelpCenter",
                                    imageName: "icnSupportMenu",
                                    imageURL: nil,
                                    accessibilityIdentifier: "menuBtnHelpCenter",
                                    optionType: .helpCenter))
        return options
    }
}
