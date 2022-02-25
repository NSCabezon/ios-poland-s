import CoreFoundationLib
import Foundation
import SANPLLibrary

protocol GetWalletsActiveProtocol: UseCase<Void, GetWalletUseCaseOkOutput, StringErrorOutput> {}

final class GetWalletsActiveUseCase: UseCase<Void, GetWalletUseCaseOkOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    private let managersProvider: PLManagersProviderProtocol
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        self.managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
    }
    
    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<GetWalletUseCaseOkOutput, StringErrorOutput> {
        let result = try managersProvider.getBLIKManager().getWalletsActive()
        switch result {
        case .success(let wallets):
            return response(for: wallets)
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
    
    private func response(for wallets: [GetWalletsActiveDTO]) -> UseCaseResponse<GetWalletUseCaseOkOutput, StringErrorOutput> {
        guard let dtoWallet = wallets.first else {
            return .ok(
                GetWalletUseCaseOkOutput(
                    serviceStatus: .unavailable
                )
            )
        }
        return .ok(
            GetWalletUseCaseOkOutput(
                serviceStatus: .available(GetWalletUseCaseOkOutput.Wallet(wallet: dtoWallet))
            )
        )
    }
}

extension GetWalletsActiveUseCase: GetWalletsActiveProtocol {}

struct GetWalletUseCaseOkOutput {
    let serviceStatus: WalletServiceStatus
    
    struct Wallet {
        let shouldSetChequePin: Bool
        let alias: Alias
        let sourceAccount: Account
        let noPinTrnVisible: Bool
        let limits: LimitInfo
        
        struct Alias: Codable {
            let label: String
            let type: Type
            let isSynced: Bool
            
            enum `Type`: String, Codable {
                case empty = "EMPTY"
                case eWallet_Alias = "EWALLET_ALIAS"
                case eWalletAndPSP_Alias = "EWALLET_AND_PSP_ALIAS"
            }
        }
        
        struct Account {
            let name: String
            let shortName: String
            let number: String
        }
        
        struct LimitInfo {
            let shopLimitInfo: Limit
            let cashLimitInfo: Limit
        }
        
        struct Limit {
            let trnLimit: Decimal
            let cycleLimit: Decimal
            let cycleLimitRemaining: Decimal
        }
    }
    
    enum WalletServiceStatus {
        case available(Wallet)
        case unavailable
    }
}

fileprivate extension GetWalletUseCaseOkOutput.Wallet {
    init(wallet: GetWalletsActiveDTO) {
        self.shouldSetChequePin =  (wallet.chequePinStatus == .notSet)
        self.noPinTrnVisible = wallet.noPinTrnVisible
        let aliasType: GetWalletUseCaseOkOutput.Wallet.Alias.`Type` = {
            switch wallet.alias.type {
            case .empty:
                return .empty
            case .eWallet_Alias:
                return .eWallet_Alias
            case .eWalletAndPSP_Alias:
                return .eWalletAndPSP_Alias
            }
        }()
        self.alias = GetWalletUseCaseOkOutput.Wallet.Alias(
            label: wallet.alias.label,
            type: aliasType,
            isSynced: wallet.alias.isSynced
        )
        self.sourceAccount = GetWalletUseCaseOkOutput.Wallet.Account(
            name: wallet.accounts.srcAccName,
            shortName: wallet.accounts.srcAccShortName,
            number: wallet.accounts.srcAccNo
        )
        self.limits = LimitInfo(
            shopLimitInfo: Limit(
                trnLimit: wallet.limits.shopLimits.trnLimit,
                cycleLimit: wallet.limits.shopLimits.cycleLimit,
                cycleLimitRemaining: wallet.limits.shopLimits.cycleLimitRemaining
            ),
            cashLimitInfo: Limit(
                trnLimit: wallet.limits.cashLimits.trnLimit,
                cycleLimit: wallet.limits.cashLimits.cycleLimit,
                cycleLimitRemaining: wallet.limits.cashLimits.cycleLimitRemaining
            )
        )
    }
}
