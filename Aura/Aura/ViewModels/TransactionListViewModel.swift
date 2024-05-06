//
//  TransactionListViewModel.swift
//  Aura
//
//  Created by Yannick LEPLARD on 06/05/2024.
//

import Foundation
//import SwiftUI

class TransactionListViewModel: ObservableObject {
    @Published var transactions: [Transaction] = [
        Transaction(description: "Starbucks", amount: "-€5.50"),
        Transaction(description: "Amazon Purchase", amount: "-€34.99"),
        Transaction(description: "Salary", amount: "+€2,500.00")
    ]
    
    struct Transaction {
        let description: String
        let amount: String
    }
    
    func all(auraState: AuraState) {
        transactions = auraState.account.transactions
            .map { transaction in
                let desc = transaction.label
                let amount = MoneyFormatter().euros.string(for: transaction.value) ?? ""
                return Transaction(description: desc, amount: amount)
            }
    }
}
