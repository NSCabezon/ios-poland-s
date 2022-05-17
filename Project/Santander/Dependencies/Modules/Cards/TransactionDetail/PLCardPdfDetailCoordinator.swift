//
//  PLCardPdfDetailCoordinator.swift
//  Santander
//
//  Created by Hernán Villamil on 12/5/22.
//

import Foundation
import CoreDomain
import CoreFoundationLib
import UI
import Cards
import SANPLLibrary
import PdfCommons

final class PLCardPdfDetailCoordinator: BindableCoordinator {
    private let dependenciesResolver: DependenciesResolver
    public var onFinish: (() -> Void)?
    public var dataBinding: DataBinding = DataBindingObject()
    public var childCoordinators: [Coordinator] = []
    public var navigationController: UINavigationController?
    
    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    public func start() {
        guard let transaction: CardTransactionRepresentable = dataBinding.get() else {
            return
        }
        if let receiptId = transaction.receiptId {
            showPdfViewer(receiptId: receiptId)
        } else {
            showError()
        }
    }
}

private extension PLCardPdfDetailCoordinator {
    func showPdfViewer(receiptId: String) {
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

    func showError() {
        self.showGenericErrorDialog(withDependenciesResolver: self.dependenciesResolver, action: nil, closeAction: nil)
    }
}

extension PLCardPdfDetailCoordinator: GenericErrorDialogPresentationCapable {
    var associatedGenericErrorDialogView: UIViewController {
        return navigationController ?? UIViewController()
    }
}

extension PLCardPdfDetailCoordinator: LoadingViewPresentationCapable {
    var associatedLoadingView: UIViewController {
        return navigationController ?? UIViewController()
    }
}
