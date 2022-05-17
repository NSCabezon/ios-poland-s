//
//  SavingProductOption.swift
//  Santander
import CoreDomain

struct SavingProductOption: SavingProductOptionRepresentable {
    let title: String
    let imageName: String
    let imageColor: UIColor?
    let accessibilityIdentifier: String
    let type: SavingProductOptionType
    var hash: String
    let titleIdentifier: String?
    let imageIdentifier: String?
    let otherOperativesSection: SavingsActionSection?

    init(title: String,
         imageName: String,
         imageColor: UIColor?,
         accessibilityIdentifier: String,
         type: SavingProductOptionType,
         titleIdentifier: String?,
         imageIdentifier: String?,
         otherOperativesSection: SavingsActionSection?) {
        self.title = title
        self.imageName = imageName
        self.imageColor = imageColor
        self.accessibilityIdentifier = accessibilityIdentifier
        self.type = type
        self.hash = title
        self.titleIdentifier = titleIdentifier
        self.imageIdentifier = imageIdentifier
        self.otherOperativesSection = otherOperativesSection
    }
}
