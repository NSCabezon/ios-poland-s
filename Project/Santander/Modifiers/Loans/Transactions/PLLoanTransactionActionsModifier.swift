//
//  PLLoanTransactionActionsModifier.swift
//  Santander
//

import CoreFoundationLib
import CoreDomain
import Loans
import UI
import SANPLLibrary
import PdfCommons

final class PLLoanTransactionActionsModifier: LoanTransactionActionsModifier {

    private let dependenciesResolver: DependenciesResolver
    private let drawer: BaseMenuController

    public init(dependenciesResolver: DependenciesResolver, drawer: BaseMenuController) {
        self.dependenciesResolver = dependenciesResolver
        self.drawer = drawer
    }

    func didSelectAction(_ action: LoanTransactionDetailActionType, forTransaction transaction: LoanTransactionEntity, andLoan loan: LoanEntity) -> Bool {
        switch action {
        case .pdfExtract:
            if let receiptId = transaction.dto.receiptId, receiptId.isNotEmpty {
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

private extension PLLoanTransactionActionsModifier {
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

extension PLLoanTransactionActionsModifier: GenericErrorDialogPresentationCapable {
    var associatedGenericErrorDialogView: UIViewController {
        return self.drawer.currentRootViewController as? UINavigationController ?? UIViewController()
    }
}

extension PLLoanTransactionActionsModifier: LoadingViewPresentationCapable {
    var associatedLoadingView: UIViewController {
        return self.drawer.currentRootViewController as? UINavigationController ?? UIViewController()
    }
}
