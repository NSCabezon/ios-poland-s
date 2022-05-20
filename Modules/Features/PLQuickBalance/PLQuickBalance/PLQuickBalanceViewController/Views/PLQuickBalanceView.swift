import Foundation
import UI
import SANPLLibrary

protocol PLQuickBalanceViewActionsDelegate: AnyObject {
    func close()
}

class PLQuickBalanceView: UIView {
    weak var delegate: PLQuickBalanceViewActionsDelegate?
    let close = UIButton()
    let logo = UIImageView()
    let backLogin = UIButton()
    let mainAccountView = PLQuickBalanceAccountView()
    let mainAccountHistoryView = PLQuickBalanceAccountHistoryView()

    let errorView = PLQuickBalanceErrorView()
    let secondAccountView = PLQuickBalanceAccountView()
    let secondAccountHistoryView = PLQuickBalanceAccountHistoryView()

    init() {
        super.init(frame: .zero)
        configureBaseView()
        configureActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureBaseView()
        configureActions()
    }
    
    private func configureActions() {
        self.backLogin.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        self.close.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
    }
    
    @objc private func closeAction() {
        delegate?.close()
    }
    
    func showServiceInaccesible() {
        addErrorView()
    }
    
    func fillWith(items: PLQuickBalanceDTO?) {
        if (items?.count ?? 0) >= 2, let firstItem = items?.first, let secondItem = items?[safe: 1] {
            configureMainAccountViewWith(item: firstItem)
            configureSecondAccountViewWith(item: secondItem)
        } else if let firstItem = items?.first {
            configureMainAccountViewWith(item: firstItem)
        }
    }
    
    private func configureMainAccountViewWith(item: PLQuickBalanceDTOElement) {
        mainAccountView.setLabelsWith(item: item)
        addMainAccountView()
        if let _ = item.lastTransaction {
            mainAccountHistoryView.setLabelsWith(item: item)
            addMainAccountHistoryView()
        }
        
    }
    
    private func configureSecondAccountViewWith(item: PLQuickBalanceDTOElement) {
        secondAccountView.setLabelsWith(item: item)
        addSecondAccountView()
        if let _ = item.lastTransaction {
            secondAccountHistoryView.setLabelsWith(item: item)
            addSecondHistoryView()
        }
    }
    
    
    private func configureBaseView(){
        backgroundColor = UIColor(red: 242/255.0,
                                  green: 244/255.0,
                                  blue: 246/255.0,
                                  alpha: 1)
        addSubview(backLogin)
        addSubview(close)
        addSubview(logo)
        
        backLogin.setImage(UIImage(named: "backLogin", in: .module, compatibleWith: nil), for: .normal)
        backLogin.contentMode = .scaleAspectFit
        
        close.setImage(UIImage(named: "close", in: .module, compatibleWith: nil), for: .normal)
        logo.image = UIImage(named: "logo", in: .module, compatibleWith: nil)
        
        close.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            close.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            close.topAnchor.constraint(equalTo: topAnchor, constant: 48),
            close.heightAnchor.constraint(equalToConstant: 24),
            close.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        backLogin.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backLogin.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            backLogin.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 2),
            backLogin.heightAnchor.constraint(equalToConstant: 40),
            backLogin.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        logo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logo.leadingAnchor.constraint(equalTo: backLogin.trailingAnchor, constant: 24),
            logo.topAnchor.constraint(equalTo: topAnchor, constant: 64),
            logo.heightAnchor.constraint(equalToConstant: 50),
            logo.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func addErrorView() {
        addSubview(errorView)
        
        errorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 64),
            errorView.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 5),
            errorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23)
        ])
    }
    
    private func addMainAccountView() {
        addSubview(mainAccountView)
        mainAccountView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainAccountView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 64),
            mainAccountView.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 5),
            mainAccountView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23)
        ])
    }
    
    private func addMainAccountHistoryView() {
        addSubview(mainAccountHistoryView)
        mainAccountHistoryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainAccountHistoryView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 64),
            mainAccountHistoryView.topAnchor.constraint(equalTo: mainAccountView.bottomAnchor, constant: 15),
            mainAccountHistoryView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23)
        ])
    }
    
    private func addSecondAccountView() {
        addSubview(secondAccountView)
        secondAccountView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secondAccountView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 64),
            secondAccountView.topAnchor.constraint(equalTo: mainAccountHistoryView.bottomAnchor, constant: 15),
            secondAccountView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23)
        ])
    }
    
    private func addSecondHistoryView() {
        addSubview(secondAccountHistoryView)
        secondAccountHistoryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secondAccountHistoryView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 64),
            secondAccountHistoryView.topAnchor.constraint(equalTo: secondAccountView.bottomAnchor, constant: 15),
            secondAccountHistoryView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23)
        ])
    }
}
