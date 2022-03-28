import CoreFoundationLib
import UI

final public class InfoDialogBuilder {
    private let title: LocalizedStylableText
    private let description: LocalizedStylableText
    private let image: UIImage
    private var buttontTapAction: () -> Void
    
    public init(
        title: LocalizedStylableText,
        description: LocalizedStylableText,
        image: UIImage,
        buttontTapAction: @escaping () -> Void
    ) {
        self.title = title
        self.description = description
        self.image = image
        self.buttontTapAction = buttontTapAction
    }
    
    public func build() -> LisboaDialog {
        let items: [LisboaDialogItem] = [
            .margin(24),
            .image(.init(image: image, size: (50, 50))),
            .margin(12),
            .styledText(
                .init(
                    text: title,
                    font: .santander(family: .headline, type: .bold, size: 28),
                    color: .lisboaGray,
                    alignament: .center,
                    margins: (left: 28.0, right: 28.0)
                )
            ),
            .margin(12),
            .styledText(
                .init(
                    text: description,
                    font: .santander(family: .micro, type: .regular, size: 16),
                    color: .lisboaGray,
                    alignament: .center,
                    margins: (left: 28.0, right: 28.0)
                )
            ),
            .margin(24),
            .verticalAction(
                VerticalLisboaDialogAction(
                    title: localized("generic_button_understand"),
                    type: .red, margins: (left: 16, right: 16),
                    action: buttontTapAction
                )
            ),
            .margin(16.0)
        ]
        return LisboaDialog(items: items, closeButtonAvailable: false)
    }
}
