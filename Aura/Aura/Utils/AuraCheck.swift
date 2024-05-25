//
//  AuraCheck.swift
//  Aura
//
//  Created by Yannick LEPLARD on 06/05/2024.
//

import Foundation



struct AuraCheck {
    // pour vérifier une adresse email
    // format : A@B.C avec A = [A-Z0-9a-z._+-] de longueur max. 64, B = [A-Za-z0-9.-], C = [A-Za-z]
    // !!! le format n'est pas exhaustif, d'autres caractère sont possibles pour A
    // aucun test n'est effectué sur la longueur de A, B et C
    // On pourrait utiliser la regex côté serveur (dans Email.swift), mais elle est trop stricte et doit être modifiée.
    static func validEmail(_ email: String) -> Bool {
        let regEx = "[A-Z0-9a-z._+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regEx)
        return predicate.evaluate(with: email)
    }
    
    // pour vérifier une numéro de téléphone français
    // format : 0AXXXXXXXX ou +33AXXXXXXXX,  avec A = 6 ou 7
    static func validFrenchPhoneNumber(_ phoneNumber: String) -> Bool {
        // longueur 10 [0-9], commence par 0, suivi de 6 ou 7
        let regExFr = "0[6-7][0-9]{8}"
        let predicateFr = NSPredicate(format:"SELF MATCHES %@", regExFr)
        // longueur 12, commence par +33, suivi de 6 ou 7, suivi de [0-9]
        let regExInter = "[+]33[6-7][0-9]{8}"
        let predicateInter = NSPredicate(format:"SELF MATCHES %@", regExInter)
        
        return (predicateFr.evaluate(with: phoneNumber) || predicateInter.evaluate(with: phoneNumber))
    }
    
    // pour vérifier si un montant est valide
    // SUGGESTION : AVOIR UN MONTANT MAX POUR SÉCURISER LES VIREMENTS, PAR EXEMPLE EN DEMANDANT CONFIRMATION AVANT ENVOI DE LA DEMANDE...
    static func validAmount(_ amount: String) -> Bool {
        let dotAmount = amount.replacingOccurrences(of: ",", with: ".")
        if let _ = Double(dotAmount) {
            return true
        }
        return false
    }
    
    static func Amount(_ amount: String) -> Bool {
        let dotAmount = amount.replacingOccurrences(of: ",", with: ".")
        if let _ = Double(dotAmount) {
            return true
        }
        return false
    }
    // ? le clavier affiche une virgule alors que l'on attend un point pour séparer les décimales
    static func replaceCommaWithDot(_ amount: String) -> String {
        return amount.replacingOccurrences(of: ",", with: ".")
    }
}
