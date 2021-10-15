import Operative
import Commons
import Models
import UI

// TODO: Ask if this Builder could be added to Operative module
final class OperativeSummaryStandardViewModelBuilder {
    
    private var header: OperativeSummaryStandardHeaderViewModel =
        OperativeSummaryStandardHeaderViewModel(image: "", title: "", description: "", extraInfo: "")
    private var bodyItems: [OperativeSummaryStandardBodyItemViewModel] = []
    private var bodyActionItems: [OperativeSummaryStandardBodyActionViewModel] = []
    private var footerItems: [OperativeSummaryStandardFooterItemViewModel] = []
    
    func setHeader(
        image: String,
        title: String,
        description: String,
        extraInfo: String?
    ) -> Self {
        header = OperativeSummaryStandardHeaderViewModel(
            image: image,
            title: title,
            description: description,
            extraInfo: extraInfo
        )
        return self
    }
    
    func addBodyItem(
        title: String,
        subTitle: NSAttributedString,
        info: String? = nil,
        accessibilityIdentifier: String? = nil
    ) -> Self {
        bodyItems.append(
            OperativeSummaryStandardBodyItemViewModel(
                title: title,
                subTitle: subTitle,
                info: info,
                accessibilityIdentifier: accessibilityIdentifier
            )
        )
        return self
    }
    
    func addBodyItem(
        title: String,
        subTitle: String,
        info: String? = nil,
        accessibilityIdentifier: String? = nil
    ) -> Self {
        bodyItems.append(
            OperativeSummaryStandardBodyItemViewModel(
                title: title,
                subTitle: subTitle,
                info: info,
                accessibilityIdentifier: accessibilityIdentifier
            )
        )
        return self
    }
    
    func addBodyActionItem(
        image: String,
        title: String,
        action: @escaping () -> Void
    ) -> Self {
        bodyActionItems.append(
            OperativeSummaryStandardBodyActionViewModel(
                image: image,
                title: title,
                action: action
            )
        )
        return self
    }
    
    func addFooterItem(
        image: UIImage?,
        title: String,
        action: @escaping () -> Void
    ) -> Self {
        footerItems.append(
            OperativeSummaryStandardFooterItemViewModel(
                image: image,
                title: title,
                action: action
            )
        )
        return self
    }
    
    func addFooterItem(
        imageKey: String,
        title: String,
        action: @escaping () -> Void
    ) -> Self {
        footerItems.append(
            OperativeSummaryStandardFooterItemViewModel(
                imageKey: imageKey,
                title: title,
                action: action
            )
        )
        return self
    }
    
    func build() -> OperativeSummaryStandardViewModel {
        return OperativeSummaryStandardViewModel(
            header: header,
            bodyItems: bodyItems,
            bodyActionItems: bodyActionItems,
            footerItems: footerItems
        )
    }
    
}

extension OperativeSummaryStandardViewModelBuilder {
    func addBodyItem(
        title: String,
        amount: AmountEntity?,
        accessibilityIdentifier: String? = nil
    ) -> Self {
        guard let amount = amount else { return self }
        let moneyDecorator = MoneyDecorator(
            amount,
            font: .santander(family: .micro, type: .bold, size: 29),
            decimalFontSize: 21
        )
        
        return addBodyItem(
            title: title,
            subTitle: moneyDecorator.getFormatedAbsWith1M() ?? NSAttributedString(string: amount.getStringValue()),
            accessibilityIdentifier: accessibilityIdentifier
        )
    }
    
    func addBodyItem(
        title: String,
        value: String?,
        valueAttributes: [NSAttributedString.Key : Any],
        accessibilityIdentifier: String? = nil
    ) -> Self {
        guard let value = value else { return self }
        return addBodyItem(
            title: title,
            subTitle: NSAttributedString(string: value, attributes: valueAttributes),
            accessibilityIdentifier: accessibilityIdentifier
        )
    }
    
    func addBodyItem(
        title: String,
        accountAmount: AmountEntity?,
        accountAlias: String?,
        accessibilityIdentifier: String? = nil
    ) -> Self {
        guard let accountAmount = accountAmount, let accountAlias = accountAlias else { return self }
        
        let font = UIFont.santander(family: .headline, type: .bold, size: 14.0)
        let value = NSMutableAttributedString(string: "\(accountAlias) ", attributes: [NSAttributedString.Key.font: font])
        
        let moneyDecorator = MoneyDecorator(accountAmount, font: font)
        let amountTmp = moneyDecorator.getCurrencyWithoutFormat() ?? NSAttributedString(string: "")
        let attributes = [NSAttributedString.Key.font: UIFont.santander(family: .micro, type: .regular, size: 14.0)]
        let amount = NSAttributedString(string: "(\(amountTmp.string))", attributes: attributes)
        value.append(amount)
        
        return addBodyItem(
            title: title,
            subTitle: value,
            accessibilityIdentifier: accessibilityIdentifier
        )
    }
}
