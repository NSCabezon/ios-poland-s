//
//  PLAccountTransactionDetailAction.swift
//  Santander
//

import Account
import CoreFoundationLib
import PLLegacyAdapter
import SANLegacyLibrary
import SANPLLibrary
import PdfCommons
import UI

class PLAccountTransactionDetailAction: AccountTransactionDetailActionProtocol {
    
    private let dependenciesResolver: DependenciesResolver
    private let drawer: BaseMenuController

    public init(dependenciesResolver: DependenciesResolver, drawer: BaseMenuController) {
        self.dependenciesResolver = dependenciesResolver
        self.drawer = drawer
    }
    
    func getTransactionActions(for transaction: AccountTransactionEntity) -> [AccountTransactionDetailAction]? {
        if let receiptId = transaction.dto.receiptId, receiptId.isNotEmpty {
            return [.pdf, .share(nil)]
        }
        return [.share(nil)]
    }
    
    func showComingSoonToast() -> Bool {
        return false
    }
    
    func didSelectAction(_ action: AccountTransactionDetailAction, for transaction: AccountTransactionEntity) -> Bool {
        switch action {
        case .pdf:
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

private extension PLAccountTransactionDetailAction {
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

extension PLAccountTransactionDetailAction: GenericErrorDialogPresentationCapable {
    var associatedGenericErrorDialogView: UIViewController {
        return self.drawer.currentRootViewController as? UINavigationController ?? UIViewController()
    }
}

extension PLAccountTransactionDetailAction: LoadingViewPresentationCapable {
    var associatedLoadingView: UIViewController {
        return self.drawer.currentRootViewController as? UINavigationController ?? UIViewController()
    }
}
