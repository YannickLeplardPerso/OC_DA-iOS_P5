//
//  AccountDetailViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation
import SwiftUI

struct Transaction {
    let description: String
    let amount: String
}

class AccountDetailViewModel: ObservableObject {
    @Published var totalAmount: String = "€12,345.67"
    @Published var recentTransactions: [Transaction] = [
        Transaction(description: "Starbucks", amount: "-€5.50"),
        Transaction(description: "Amazon Purchase", amount: "-€34.99"),
        Transaction(description: "Salary", amount: "+€2,500.00")
    ]
    
    func accountSummary(auraState: AuraState) {
        totalAmount = MoneyFormatter().euros.string(for: auraState.account.currentBalance) ?? ""
        
        recentTransactions = auraState.account.transactions
            .suffix(3)
            .map { transaction in
                let desc = transaction.label
                let amount = MoneyFormatter().euros.string(for: transaction.value) ?? ""
                
                return Transaction(description: desc, amount: amount)
            }
    }
}
