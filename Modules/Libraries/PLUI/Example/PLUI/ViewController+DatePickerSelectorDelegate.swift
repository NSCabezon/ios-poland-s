//
//  ViewController+DatePickerSelectorDelegate.swift
//  PLUI_Example
//
//  Created by 187125 on 09/12/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import PLUI

extension ViewController {
    
    func datePickerSelector() -> UIView {
        let view = UIView(frame: .zero)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy" //Depend which date format should be used
        let datePickerLanguage = "pl" //Depend which language should be used
        let datePicker = TransferDateSelector(language: datePickerLanguage, dateFormatter: dateFormatter)
        datePicker.delegate = self
            
        view.addSubview(datePicker)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 150).isActive = true
        datePicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 3).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 3).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -3).isActive = true
        
        return view
    }
}

extension ViewController: TransferDateSelectorDelegate {
    func didSelectDate(date: Date, withOption option: DateTransferOption) {
        print("Selected date: \(date)")
    }
}
