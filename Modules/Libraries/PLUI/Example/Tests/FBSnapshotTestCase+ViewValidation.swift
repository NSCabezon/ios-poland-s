//
//  FBSnapshotTestCase+ViewValidation.swift
//  PLUI
//
//  Created by Marcos Álvarez Mesa on 16/12/21.
//

import FBSnapshotTestCase

extension FBSnapshotTestCase {

    func verifyView(view: UIView,
                    screens: [SnapshotTestsDeviceSceen] = SnapshotTestsDeviceSceen.allCases,
                    file: StaticString = #file,
                    line: UInt = #line) {

        for screen in screens {
            let size = view.systemLayoutSizeFitting(screen.screenSize,
                                                    withHorizontalFittingPriority: .required,
                                                    verticalFittingPriority: .fittingSizeLevel)
            let contentView = UIView(frame: .zero)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: contentView.topAnchor),
                view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

                contentView.widthAnchor.constraint(equalToConstant: size.width),
                contentView.heightAnchor.constraint(equalToConstant: size.height)
            ])

            view.layoutIfNeeded()

            FBSnapshotVerifyView(contentView,
                                 identifier: screen.screenIdentifier,
                                 file: file,
                                 line: line)
        }
    }
}
