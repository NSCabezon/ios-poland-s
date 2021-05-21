//
//  PLAssets.swift
//  PLUI

import Foundation

public final class PLAssets {

    public static func image(named name: String) -> UIImage? {
        return UIImage(named: name, in: Bundle(for: PLAssets.self), compatibleWith: nil)
    }

}
