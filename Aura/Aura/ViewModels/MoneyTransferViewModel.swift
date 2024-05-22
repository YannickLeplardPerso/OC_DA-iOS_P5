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
    
    func recipientAndAmountAreValid() -> Bool {
        // si le destinataire est invalide, on efface les deux champs (recipient et amount)
        if !AuraCheck.validEmail(recipient) && !AuraCheck.validFrenchPhoneNumber(recipient) {
            recipient = ""
            amount = ""
            transferMessage = "Invalid recipient"
            return false
        } 
        // si le montant est invalide, on efface le champ amount
        if !AuraCheck.validAmount(amount) {
            amount = ""
            transferMessage = "Invalid amount"
            return false
        }
        return true
    }
    
    func sendMoney(auraState: AuraState) {
        if !recipient.isEmpty && !amount.isEmpty {
            Task{ @MainActor in
                do{
                    // !!! problème si conversion String de amount échoue, message de transfert ok, avec mauvais montant !!!
                    // amount a été vérifié
                    let isTransferOK = try await AuraAPIService().askForMoneyTransfer(from: auraState.token, to: AuraTransferInfos(recipient: recipient, amount: Double(amount)!))
                    if isTransferOK == true {
                        transferMessage = "Successfully transferred \(amount) € to \(recipient)"
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
