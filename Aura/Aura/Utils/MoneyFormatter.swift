//
//  MoneyFormatter.swift
//  Aura
//
//  Created by Yannick LEPLARD on 06/05/2024.
//

import Foundation

struct MoneyFormatter {
    
    let euros: NumberFormatter
    
    init() {
        euros = NumberFormatter()
        euros.maximumFractionDigits = 2
        euros.minimumFractionDigits = 2
        euros.currencyCode = "EUR"
        euros.numberStyle = .currency
    }
}

