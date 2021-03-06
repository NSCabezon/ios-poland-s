import UI
import CoreFoundationLib

public protocol ErrorPresentable {
    func showServiceInaccessibleMessage(onConfirm: (() -> Void)?)
    func showErrorMessage(_ message: String, onConfirm: (() -> Void)?)
    func showErrorMessage(_ message: String, image: String, onConfirm: (() -> Void)?)
    func showErrorMessage(title: String, message: String, image: String, onConfirm: (() -> Void)?)
    func showErrorMessage(
        title: String,
        message: String,
        actionButtonTitle: String,
        closeButton: Dialog.CloseButton,
        onConfirm: (() -> Void)?
    )
    func showMessage(title: String, message: String, image: String, onConfirm: (() -> Void)?)
}

extension ErrorPresentable where Self: UIViewController {
    public func showErrorMessage(
        title: String,
        message: String,
        actionButtonTitle: String,
        closeButton: Dialog.CloseButton,
        onConfirm: (() -> Void)?
    ) {
        let dialog = Dialog(
            title: title,
            items: [
                .styledConfiguredText(
                    .plain(text: message),
                    configuration: LocalizedStylableTextConfiguration(
                        font: .santander(
                            family: .micro,
                            type: .regular,
                            size: 16
                        ),
                        alignment: .center
                    )
                )
            ],
            image: "icnAlert",
            actionButton: .init(title: actionButtonTitle, style: .red, action: onConfirm ?? {}),
            closeButton: closeButton, hasTitleAndNotAlignment: true)
        dialog.show(in: self)
    }
    
    public func showErrorMessage(_ message: String, onConfirm: (() -> Void)?) {
        showErrorMessage(message, image: "icnAlert", onConfirm: onConfirm)
    }
    
    public func showErrorMessage(_ message: String, image: String, onConfirm: (() -> Void)?) {
        showErrorMessage(title: localized("pl_generic_alert_titleError"), message: message, image: image, onConfirm: onConfirm)
    }
    
    public func showErrorMessage(title: String, message: String, image: String, onConfirm: (() -> Void)?) {
        let dialog = Dialog(
            title: title,
            items: [
                .styledConfiguredText(
                    .plain(text: message),
                    configuration: LocalizedStylableTextConfiguration(
                        font: .santander(
                            family: .micro,
                            type: .regular,
                            size: 16
                        ),
                        alignment: .center
                    )
                )
            ],
            image: image,
            actionButton: .init(title: localized("generic_link_ok"), style: .red, action: onConfirm ?? {}),
            closeButton: .none, hasTitleAndNotAlignment: true)
        dialog.show(in: self)
    }
    
    public func showServiceInaccessibleMessage(onConfirm: (() -> Void)?) {
        showErrorMessage(localized("pl_blik_alert_text_error"), onConfirm: onConfirm)
    }
    
    public func showMessage(title: String, message: String, image: String, onConfirm: (() -> Void)?) {
        let dialog = Dialog(
            title: title,
            items: [
                .styledConfiguredText(
                    .plain(text: message),
                    configuration: LocalizedStylableTextConfiguration(
                        font: .santander(
                            family: .micro,
                            type: .regular,
                            size: 16
                        ),
                        alignment: .center
                    )
                )
            ],
            image: image,
            actionButton: .init(title: localized("generic_link_ok"), style: .red, action: onConfirm ?? {}),
            closeButton: .none, hasTitleAndNotAlignment: true)
        dialog.show(in: self)
    }
}
