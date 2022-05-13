//
//  PLCardTransactionDetailActionFactoryModifierProtocol.swift
//  Santander
//
//  Created by Alvaro Royo on 24/9/21.
//

import Foundation
import Cards
import CoreFoundationLib
import UI
import SANPLLibrary
import PdfCommons

class PLCardTransactionDetailActionFactoryModifier: CardTransactionDetailActionFactoryModifierProtocol {

    private let dependenciesResolver: DependenciesResolver
    private let drawer: BaseMenuController
    
    public init(dependenciesResolver: DependenciesResolver, drawer: BaseMenuController) {
        self.dependenciesResolver = dependenciesResolver
        self.drawer = drawer
    }
    
    func customViewType() -> ActionButtonFillViewType {
        .none
    }
    
    func addPDFDetail(transaction: CardTransactionEntity) -> Bool {
        if let receiptId = transaction.dto.receiptId, receiptId.isNotEmpty {
            return true
        }
        return false
    }

    func getCustomActions(for card: CardEntity, forTransaction transaction: CardTransactionEntity) -> [CardActionType]? {
        if let receiptId = transaction.dto.receiptId, receiptId.isNotEmpty {
            return [.pdfDetail, .share(nil)]
        }
        return [.share(nil)]
    }

    func didSelectAction(_ action: CardActionType, forTransaction transaction: CardTransactionEntity, andCard card: CardEntity) -> Bool {
        switch action {
        case .pdfDetail:
            if let receiptId = transaction.dto.receiptId {
                self.showPdfViewer(receiptId: receiptId)
            } else {
                self.showError()
            }
            return true
        default:
            return false
        }
    }
}

private extension PLCardTransactionDetailActionFactoryModifier {
    private func showPdfViewer(receiptId: String) {
        self.showLoading {
            let historyManager = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self).getHistoryManager()
            let languageType = self.dependenciesResolver.resolve(forOptionalType: StringLoader.self)?.getCurrentLanguage().languageType ?? .polish
            let language = languageType.rawValue.uppercased()
            let data = try? historyManager.getReceipt(receiptId: receiptId, language: language).get()
            self.dismissLoading {
                if let data = data {
                    let pdfLauncher = self.dependenciesResolver.resolve(for: PDFCoordinatorLauncher.self)
                    pdfLauncher.openPDF(data, title: localized("toolbar_title_movesDetail"), source: PdfSource.unknown)
                } else {
                    self.showError()
                }
            }
        }
    }

    private func showError() {
        self.showGenericErrorDialog(withDependenciesResolver: self.dependenciesResolver, action: nil, closeAction: nil)
    }
}

extension PLCardTransactionDetailActionFactoryModifier: GenericErrorDialogPresentationCapable {
    var associatedGenericErrorDialogView: UIViewController {
        return self.drawer.currentRootViewController as? UINavigationController ?? UIViewController()
    }
}

extension PLCardTransactionDetailActionFactoryModifier: LoadingViewPresentationCapable {
    var associatedLoadingView: UIViewController {
        return self.drawer.currentRootViewController as? UINavigationController ?? UIViewController()
    }
}
