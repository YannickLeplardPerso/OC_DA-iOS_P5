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
    @Published var error: AuraError = .No
    
    func recipientAndAmountAreValid() -> Bool {
        // les deux champs doivent être remplis
        if recipient.isEmpty || amount.isEmpty {
            error = .Empty
            transferMessage = "Please enter recipient and amount."
            return false
        }
        // si le destinataire est invalide, on efface les deux champs (recipient et amount)
        if !AuraCheck.validEmail(recipient) && !AuraCheck.validFrenchPhoneNumber(recipient) {
            recipient = ""
            amount = ""
            error = .InvalidRecipient
            transferMessage = "Invalid recipient"
            return false
        } 
        // on remplace la virgule par un point si nécessaire
        amount = AuraCheck.replaceCommaWithDot(amount)
        // si le montant est invalide, on efface le champ amount
        if !AuraCheck.validAmount(amount) {
            amount = ""
            error = .InvalidAmount
            transferMessage = "Invalid amount"
            return false
        }
        return true
    }
    
    func sendMoney(auraState: AuraState) {
       // if !recipient.isEmpty && !amount.isEmpty {
            Task{ @MainActor in
                do{
                    // !!! problème si conversion String de amount échoue, message de transfert ok, avec mauvais montant !!! AMOUNT doit obligatoirement avoir été vérifié
                    let isTransferOK = try await AuraAPIService().askForMoneyTransfer(from: auraState.token, to: AuraTransferInfos(recipient: recipient, amount: Double(amount)!))
                    if isTransferOK == true {
                        error = .No
                        transferMessage = "Successfully transferred \(amount) € to \(recipient)"
                    } else {
                        error = .RequestResponse
                        transferMessage = "Error transfer KO"
                    }
                    
                }catch{
                    self.error = .RequestResponse
                    transferMessage = "Error API transfer"
                }
             }
//        } else {
//            error = .Empty
//            transferMessage = "Please enter recipient and amount."
//        }
    }
}
