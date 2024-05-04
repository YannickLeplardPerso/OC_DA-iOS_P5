//
//  MoneyTransferViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

class MoneyTransferViewModel: ObservableObject {
    @Published var recipient: String = ""
    @Published var amount: String = ""
    @Published var transferMessage: String = ""
    
    func sendMoney(auraState: AuraState) {
        if !recipient.isEmpty && !amount.isEmpty {
            Task{ @MainActor in
                do{
                    // !!! problème si conversion String de amount échoue, message de transfert ok, avec mauvais montant !!!
                    // + problème de saisie dans le champ
                    let isTransferOK = try await AuraAPIService().askForMoneyTransfer(from: auraState.token, to: AuraTransferInfos(recipient: recipient, amount: Double(amount) ?? 0))
                    if isTransferOK == true {
                        transferMessage = "Successfully transferred \(amount) to \(recipient)"
                    } else {
                        transferMessage = "Error transfer KO"
                    }
                    
                }catch{
                    transferMessage = "Error API transfer"
                }
             }
        } else {
            transferMessage = "Please enter recipient and amount."
        }
    }
}
