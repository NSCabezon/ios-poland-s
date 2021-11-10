import Foundation
import SANPLLibrary
import SANLegacyLibrary

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
        let timeDate = DateFormats.toDate(string: dto.time, output: .YYYYMMDD_HHmmssSSSZ)
        
        guard let transferType = Transaction.TransferType(rawValue: dto.transferType.rawValue) else {
            throw Error.wrongDateFormat
        }

        return Transaction(transactionId: dto.trnId,
                           title: dto.title,
                           date: date,
                           time: timeDate,
                           transferType: transferType,
                           placeName: dto.merchant?.shortName,
                           address: dto.merchant?.address,
                           city: dto.merchant?.city,
                           amount: dto.amount.amount,
                           aliasContext: getAliasContext(from: dto)
        )
    }
    
    private func getAliasContext(from dto: GetTrnToConfDTO) -> Transaction.AliasContext {
        if let aliasUsedInTransaction = dto.aliases.auth.first {
            let alias = Transaction.Alias(
                type: getAliasType(from: aliasUsedInTransaction.type),
                label: aliasUsedInTransaction.label
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
