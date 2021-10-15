//
//  LocalizedStylableComponent+Styles.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 16/06/2021.
//

import UI

extension LocalizedStylableTextConfiguration {
    static var boldMicro28CenteredStyle: LocalizedStylableTextConfiguration {
        return LocalizedStylableTextConfiguration(
            font: .santander(
                family: .micro,
                type: .bold,
                size: 28
            ),
            alignment: .center
        )
    }
    static var regularMicro16CenteredStyle: LocalizedStylableTextConfiguration {
        return LocalizedStylableTextConfiguration(
            font: .santander(
                family: .micro,
                type: .regular,
                size: 16
            ),
            alignment: .center
        )
    }
    
    static var boldHeadline28CenteredStyle: LocalizedStylableTextConfiguration {
        return LocalizedStylableTextConfiguration(
            font: .santander(
                family: .headline,
                type: .bold,
                size: 28
            ),
            alignment: .center
        )
    }
    
    static var bold16CenteredStyle: LocalizedStylableTextConfiguration {
        return LocalizedStylableTextConfiguration(
            font: .santander(
                family: .text,
                type: .bold,
                size: 16
            ),
            alignment: .center
        )
    }
}
