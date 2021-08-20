//
//  Compilation.swift
//  Santander
//
//  Created by Jose C. Yebes on 03/05/2021.
//

/// Note that this struct is maintained for compatibility with legacy code and will be removed in some point in the furure

import SANLegacyLibrary
import PLCommons
import Commons
import Models

struct Compilation: PLCompilationProtocol {
    let service: String = ""
    let sharedTokenAccessGroup: String = ""
    var isEnvironmentsAvailable: Bool = false
    let debugLoginSetup: LoginDebugSetup? = nil
    let keychain: CompilationKeychainProtocol = CompilationKeychain()
    let userDefaults: CompilationUserDefaultsProtocol = CompilationUserDefaults()
    let defaultDemoUser: String? = ""
    let defaultMagic: String? = ""
    var tealiumTarget: String = ""
    let twinPushSubdomain: String = ""
    let twinPushAppId: String = ""
    let twinPushApiKey: String = ""
    let isLogEnabled: Bool = false
    let isValidatingCertificate: Bool = false
    let appCenterIdentifier: String = "" // TODO: Add PL appCenter distribution identifier
    let isLoadPfmEnabled: Bool = false
    var isTrustInvalidCertificateEnabled: Bool = true
    let managerWallProductionEnvironment: Bool = false
    let appGroupsIdentifier: String = ""
    let bsanHostProvider: BSANHostProviderProtocol = BSANHostProviderEmpty()
    let publicFilesHostProvider: PublicFilesHostProviderProtocol = PublicFilesHostProvider()
}

struct CompilationKeychain: CompilationKeychainProtocol {
    let account: CompilationAccountProtocol = CompilationAccount()
    let service: String = ""
    let sharedTokenAccessGroup: String = ""
}

struct CompilationAccount: CompilationAccountProtocol {
    let touchId: String = ""
    let biometryEvaluationSecurity: String = ""
    let widget: String = ""
    let tokenPush: String = ""
    let old: String? = nil
}

struct CompilationUserDefaults: CompilationUserDefaultsProtocol {
    let key: CompilationKeyProtocol = CompilationKey()
}

struct CompilationKey: CompilationKeyProtocol {
    let oldDeviceId: String? = nil
    let firstOpen: String = ""
}

final class BSANHostProviderEmpty: BSANHostProviderProtocol {
    let environmentDefault: BSANEnvironmentDTO = BSANEnvironmentDTO(urlBase: "", isHttps: false, name: "", urlNetInsight: "", urlSocius: "", urlBizumEnrollment: "", urlBizumWeb: "", urlGetCMC: "", urlGetNewMagic: "", urlForgotMagic: "", urlRestBase: "", oauthClientId: "", oauthClientSecret: "", microURL: "", click2CallURL: "", branchLocatorGlobile: "", insurancesPass2Url: "", pass2oauthClientId: "", pass2oauthClientSecret: "", ecommerceUrl: "", fintechUrl: "")
    
    func getEnvironments() -> [BSANEnvironmentDTO] {
        return [self.environmentDefault]
    }
}

struct PublicFilesHostProvider: PublicFilesHostProviderProtocol {
    let publicFilesEnvironments: [PublicFilesEnvironmentDTO] = [
        PublicFilesEnvironmentDTO("PRE", "https://micrositeoneapp9.santander.pl/filesFF/", false),
        PublicFilesEnvironmentDTO("QA", "https://serverftp.ciber-es.com/one_app/pl/files_qa/", false),
        PublicFilesEnvironmentDTO("DEV", "https://serverftp.ciber-es.com/one_app/pl/files_dev/", false),
        PublicFilesEnvironmentDTO("FILES", "https://serverftp.ciber-es.com/one_app/pl/files_pre/", false),
        PublicFilesEnvironmentDTO("PRO", "https://micrositeoneapp.santander.pl/filesFF/", false),
        PublicFilesEnvironmentDTO("LOCAL_1", "/assetsLocal/local_1/", true),
        PublicFilesEnvironmentDTO("LOCAL_2", "/assetsLocal/local_2/", true),
    ]
}
