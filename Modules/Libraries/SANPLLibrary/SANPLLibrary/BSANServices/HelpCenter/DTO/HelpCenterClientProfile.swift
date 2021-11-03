//
//  HelpCenterClientProfile.swift
//  SANPLLibrary
//
//  Created by 186484 on 16/08/2021.
//

import Foundation

public enum HelpCenterClientProfile: String, Codable {
    case individual = "klient_indywidualny"
    case notLogged = "klient_niezalogowany"
    case company = "klient_firmowy"
}
