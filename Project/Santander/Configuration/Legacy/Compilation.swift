//
//  Compilation.swift
//  Santander
//
//  Created by Jose C. Yebes on 03/05/2021.
//

/// Note that this struct is maintained for compatibility with legacy code and will be removed in some point in the furure

import Foundation
import ESCommons
import SANLibraryV3
import Models

struct Compilation: CompilationProtocol {
    let quickbalance: String = ""
    let service: String = ""
    let sharedTokenAccessGroup: String = ""
    let isEnvironmentsAvailable: Bool = false
    let debugLoginSetup: LoginDebugSetup? = nil
    let keychain: CompilationKeychainProtocol = CompilationKeychain()
    let userDefaults: CompilationUserDefaultsProtocol = CompilationUserDefaults()
    let defaultDemoUser: String? = ""
    let defaultMagic: String? = ""
    var tealiumTarget: String {
        return XCConfig["TEALIUM_TARGET"] ?? ""
    }
    let twinPushSubdomain: String = ""
    let twinPushAppId: String = ""
    let twinPushApiKey: String = ""
    let salesForceAppId: String = ""
    let salesForceAccessToken: String = ""
    let salesForceMid: String = ""
    let emmaApiKey: String = ""
    let isLogEnabled: Bool = false
    let isValidatingCertificate: Bool = false
    let appCenterIdentifier: String = "" // TODO: Add PL appCenter distribution identifier
    let isLoadPfmEnabled: Bool = false
    let isTrustInvalidCertificateEnabled: Bool = true
    let managerWallProductionEnvironment: Bool = false
    let appGroupsIdentifier: String = ""
    let bsanHostProvider: BSANHostProviderProtocol = BSANHostProviderEmpty()
    let publicFilesHostProvider: PublicFilesHostProviderProtocol = PublicFilesHostProvider()
    let mapPoiHostProvider: MapPoiHostProviderProtocol = MapPoiHostProvider()
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
    let environmentDefault: BSANEnvironmentDTO = BSANEnvironmentDTO(urlBase: "", isHttps: false, name: "", urlNetInsight: "", urlSocius: "", urlBizumEnrollment: "", urlBizumWeb: "", urlGetCMC: "", urlGetNewPassword: "", urlForgotPassword: "", urlRestBase: "", oauthClientId: "", oauthClientSecret: "", microURL: "", click2CallURL: "", branchLocatorGlobile: "", insurancesPass2Url: "", pass2oauthClientId: "", pass2oauthClientSecret: "", ecommerceUrl: "")
    
    func getEnvironments() -> [BSANEnvironmentDTO] {
        return [self.environmentDefault]
    }
}

struct PublicFilesHostProvider: PublicFilesHostProviderProtocol {
    let publicFilesEnvironments: [PublicFilesEnvironmentDTO] = [
        PublicFilesEnvironmentDTO("PRE", "https://micrositeoneapp9.santander.pt/filesFF/", false),
        PublicFilesEnvironmentDTO("QA", "https://serverftp.ciber-es.com/one_app/pt/files_qa/", false),
        PublicFilesEnvironmentDTO("DEV", "https://serverftp.ciber-es.com/one_app/pt/files_dev/", false),
        PublicFilesEnvironmentDTO("FILES", "https://serverftp.ciber-es.com/one_app/pt/files_pre/", false),
        PublicFilesEnvironmentDTO("PRO", "https://micrositeoneapp.santander.pt/filesFF/", false),
        PublicFilesEnvironmentDTO("LOCAL_1", "/assetsLocal/local_1/", true),
        PublicFilesEnvironmentDTO("LOCAL_2", "/assetsLocal/local_2/", true),
    ]
}

struct MapPoiHostProvider: MapPoiHostProviderProtocol {
    static let rcMappoiUrlPre = "https://webcomerciallr.santander.pre.corp/cspresan/Satellite?"
    static let rcMappoiUrlPro = "https://www.bancosantander.es/cssa/ContentServer?"
    let mapPoiEnvironments: [MapPoiEnvironmentDTO] = [
        MapPoiEnvironmentDTO("PRE", rcMappoiUrlPre),
        MapPoiEnvironmentDTO("PRO", rcMappoiUrlPro)
    ]
}
