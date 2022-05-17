//
//  PLAppConfig.swift
//  Santander
//
//  Created by Jose C. Yebes on 03/05/2021.
//

import CoreFoundationLib
import CoreDomain

class PLAppConfig: LocalAppConfig {
    let isEnabledOnboardingLocationDialog = false
    var isEnabledTopUpsPrivateMenu = false
    var isEnabledMailbox = true
    var isScheduledTransferDetailDeleteButtonEnabled = false
    var isScheduledTransferDetailEditButtonEnabled = false
    let isTransferDetailPDFButtonEnabled = true
    let isTransferDetailReuseButtonEnabled = true
    let isEnabledHistorical = true
    let isEnabledFavorites = true
    let enableBiometric = true
    let digitalProfile = false
    let endMorning = 5
    let endAfternoon = 14
    let endNight = 20
    let language: LanguageType = .polish
    let isEnabledPfm = false
    let privateMenu = true
    let isEnabledConfigureWhatYouSee = true
    let isPortugal = false
    let isEnabledPlusButtonPG = true
    let isEnabledMagnifyingGlass = true
    let isEnabledTimeline = true
    let isEnabledPregranted = true
    let languageList: [LanguageType] = [.polish, .english, .russian, .ukrainian]
    let isEnabledDepositWebView = false
    let isEnabledfundWebView = false
    let clickablePension = true
    let clickableInsuranceSaving = true
    let clickableStockAccount = true
    let clickableLoan = true
    let isEnabledGoToManager: Bool = false
    let isEnabledGoToPersonalArea: Bool = true
    let isEnabledGoToATMLocator: Bool = true
    let isEnabledGoToHelpCenter: Bool = true
    let isEnabledDigitalProfileView: Bool = false
    let isEnabledWorld123: Bool = false
    let isEnabledSendMoney: Bool = true
    let isEnabledBills: Bool = false
    let isEnabledBillsAndTaxesInMenu: Bool = false
    let isEnabledExploreProductsInMenu: Bool = false
    let isEnabledPersonalAreaInMenu: Bool = true
    let isEnabledConfigureAlertsInMenu: Bool = false
    let isEnabledNotificationsInMenu: Bool = true
    let isEnabledHelpUsInMenu: Bool = true
    let isEnabledPersonalData: Bool = true
    let isEnabledATMsInMenu: Bool = false
    let enablePortfoliosHome: Bool = true
    let enablePensionsHome: Bool = true
    let enableInsuranceSavingHome: Bool = true
    let enabledChangeAliasProducts: [ProductTypeEntity] = [.card, .account, .loan, .deposit, .fund]
    let isEnabledSecurityArea: Bool = true
    let isEnabledAnalysisArea: Bool = false
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
    let analysisAreaHasTimelineSection: Bool = false
    let analysisAreaIsIncomeSelectable: Bool = false
    let analysisAreaIsExpensesSelectable: Bool = false
    let enablePGCardActivation: Bool = true
    var isAnalysisAreaHomeEnabled = false
    var countryCode = "PL"
    var isEnabledConsentManagement = false
    let isEnabledSavings = true
}
