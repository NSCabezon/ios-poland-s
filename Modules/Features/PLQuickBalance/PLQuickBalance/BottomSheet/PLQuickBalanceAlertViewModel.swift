//
//  PLQuickBalanceAlertViewModel.swift
//  PLQuickBalance
//
//  Created by 185860 on 29/04/2022.
//

import Foundation

class PLQuickBalanceAlertViewModel {
    let image: UIImage = UIImage(named: "question", in: .module, compatibleWith: nil) ?? UIImage()
    let title: String = "#Czy chcesz włączyć Szybki podgląd i blokadę ekranu?"
    let subtitle: String = "#Będziesz widzieć dostępne środki zanim zalogujesz się do aplikacji. Dla Twojego bezpieczeństwa poprosimy Cię także o włączenie blokady ekranu w Twoim telefonie. Czy chcesz to zrobić teraz?"
    let cancelButtonTitle: String = "#Nie Teraz"
    let acceptButtonTitle: String = "#Tak"
    
}
