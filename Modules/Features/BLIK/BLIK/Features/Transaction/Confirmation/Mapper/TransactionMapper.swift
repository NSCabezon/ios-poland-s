import Foundation
import SANPLLibrary
import SANLegacyLibrary
import PLCommons

protocol TransactionMapping {
    func map(dto: GetTrnToConfDTO) throws -> Transaction
}

final class TransactionMapper: TransactionMapping {
    enum Error: LocalizedError {
        case wrongDateFormat
    }
}

extension TransactionMapper {
    func map(dto: GetTrnToConfDTO) throws -> Transaction {
        let date = DateFormats.toDate(string: dto.date, output: .YYYYMMDD)
        let dateFormatter = PLTimeFormat.YYYYMMDD_HHmmssSSS.createDateFormatter()
        dateFormatter.locale = Locale(identifier: "pl_pl")  //This date will always 
        let timeDate = dateFormatter.date(from: dto.time)   //come in polish time zone
        
        guard let transferType = Transaction.TransferType(rawValue: dto.transferType.rawValue) else {
            throw Error.wrongDateFormat
        }

        return Transaction(transactionId: dto.trnId,
                           title: dto.title,
                           date: date,
                           time: timeDate,
                           transferType: transferType,
                           aliasContext: getAliasContext(from: dto),
                           amount: dto.amount.amount,
                           merchant: dto.merchant,
                           transactionRawValue: dto
        )
    }
    
    private func getAliasContext(from dto: GetTrnToConfDTO) -> Transaction.AliasContext {
        if let aliasUsedInTransaction = dto.aliases.auth, let type = aliasUsedInTransaction.type, let label = aliasUsedInTransaction.label {
            let alias = Transaction.Alias(
                type: getAliasType(from: type),
                label: label
            )
            return .transactionWasPerformedWithAlias(alias)
        }
        
        if let aliasProposal = getSupportedAliasProposals(from: dto).first {
            return .receivedAliasProposal(aliasProposal)
        }
        
        return .none
    }
    
    func getSupportedAliasProposals(from dto: GetTrnToConfDTO) -> [Transaction.AliasProposal] {
        return dto.aliases.proposal.compactMap { alias -> Transaction.AliasProposal? in
            let supportedType: Transaction.AliasProposalType? = {
                switch alias.type {
                case .cookie:
                    return .cookie
                case .uid:
                    return .uid
                case .hce, .md:
                    return nil
                }
            }()
            guard let type = supportedType else { return nil }
            return Transaction.AliasProposal(
                alias: alias.alias,
                type: type,
                label: alias.label
            )
        }
    }
    
    private func getAliasType(from type: GetTrnToConfDTO.AliasType) -> Transaction.AliasType {
        switch type {
        case .cookie:
            return .cookie
        case .hce:
            return .hce
        case .md:
            return .md
        case .uid:
            return .uid
        }
    }
}
