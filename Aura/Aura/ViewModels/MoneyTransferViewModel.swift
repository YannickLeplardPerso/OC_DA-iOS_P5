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
                    // amount a été vérifié
                    let isTransferOK = try await AuraAPIService().askForMoneyTransfer(from: auraState.token, to: AuraTransferInfos(recipient: recipient, amount: Double(amount)!))
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
    
    // TODO
//    static func validations(_ validations: inout Vapor.Validations) {
//        validations.add("recipient", as: String.self, is: .email || .pattern("^(?:(?:\\+|00)33[\\s.-]{0,3}(?:\\(0\\)[\\s.-]{0,3})?|0)[1-9](?:[\\s.-]?\\d{2}){4}$"))
//        validations.add("amount", as: Decimal.self, is: .valid)
//    }
    // vérifie le montant et le transforme en nombre
    private func verifyAndTranslate(amount: String) -> Double? {
        
        //let x = Double(amount) ?? 
        
        return nil
    }
    
    // TODO
    // vérifie que le format du destinataire est une adresse email valide ou un numéro de téléphone valide français
    // => créer fonction vérif format email (car utilisé dans Auth View Model) idem pour tél ?
    private func verifyEmailOrFrenchPhoneNumber(recipient: String) -> Bool {
        return false
    }
}
