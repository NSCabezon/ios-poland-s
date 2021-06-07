//
//  PLAppConfig.swift
//  Santander
//
//  Created by Jose C. Yebes on 03/05/2021.
//

import Foundation

import Commons
import Models

class PLAppConfig: LocalAppConfig {
    let isEnabledHistorical = true
    let isEnabledFavorites = true
    let enableBiometric = true
    let digitalProfile = true
    let endMorning = 5
    let endAfternoon = 14
    let endNight = 20
    let language: LanguageType = .spanish
    let isEnabledPfm = true
    let privateMenu = true
    let isEnabledConfigureWhatYouSee = true
    let isPortugal = false
    let isEnabledPlusButtonPG = false
    let isEnabledMagnifyingGlass = true
    let isEnabledTimeline = true
    let isEnabledPregranted = true
    let languageList: [LanguageType] = [.polish, .english]
    let enablePGCardActivation = true
    let isEnabledDepositWebView = false
    let isEnabledfundWebView = false
    let clickablePension = true
    let clickableInsuranceSaving = true
    let clickableStockAccount = true
    let clickableLoan = true
    let isEnabledGoToManager: Bool = true
    let isEnabledGoToPersonalArea: Bool = true
    let isEnabledGoToATMLocator: Bool = true
    let isEnabledGoToHelpCenter: Bool = true
    let isEnabledDigitalProfileView: Bool = true
    let isEnabledPersonalInformation: Bool = true
    let isEnabledWorld123: Bool = false
    let isEnabledSendMoney: Bool = true
    let isEnabledBills: Bool = true
    let enablePortfoliosHome: Bool = true
    let enablePensionsHome: Bool = true
    let enableInsuranceSavingHome: Bool = true
    let enabledChangeAliasProducts: [ProductTypeEntity] = [.card, .account]
    let isEnabledSecurityArea: Bool = true
    let isEnabledAnalysisArea: Bool = true
    let isEnabledWithholdings: Bool = true
    let isEnabledCardDetail = true
    let isEnabledForceTouch = true
    let enableSplitExpenseBizum: Bool = true
    let isEnabledChangeDestinationCountry: Bool = true
    let isEnabledChangeCurrency: Bool = true
    let isEnabledTransfersFAQs: Bool = true
    var maxLengthInternalTransferConcept: Int = 140
    var showATMIntermediateScreen: Bool = false
    var isEnabledEditAlias: Bool = false
}
