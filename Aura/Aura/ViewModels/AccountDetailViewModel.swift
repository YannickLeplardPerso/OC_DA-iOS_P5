//
//  AccountDetailViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation
import SwiftUI

class AccountDetailViewModel: ObservableObject {
    @Published var totalAmount: String = "€12,345.67"
    @Published var recentTransactions: [Transaction] = [
        Transaction(description: "Starbucks", amount: "-€5.50"),
        Transaction(description: "Amazon Purchase", amount: "-€34.99"),
        Transaction(description: "Salary", amount: "+€2,500.00")
    ]
    
    struct Transaction {
        let description: String
        let amount: String
    }
    
    func accountSummary(auraState: AuraState) {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.currencyCode = "EUR"
        formatter.numberStyle = .currency
        
        totalAmount = formatter.string(for: auraState.account.currentBalance) ?? ""
        
        let nb = min(auraState.account.transactions.count, 3)
        recentTransactions = []
        for i in 0..<nb {
            let desc = auraState.account.transactions[i].label
            let amount = formatter.string(for: auraState.account.transactions[i].value) ?? ""
            
            recentTransactions += [Transaction(description: desc, amount: amount)]
        }
        
        print(totalAmount)
        print(recentTransactions)
    }
}
