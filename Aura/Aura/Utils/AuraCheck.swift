//
//  AuraCheck.swift
//  Aura
//
//  Created by Yannick LEPLARD on 06/05/2024.
//

import Foundation



struct AuraCheck {
    // pour vérifier une adresse email
    // format : A@B.C avec A = [A-Z0-9a-z._%+-], B = [A-Za-z0-9.-], C = [A-Za-z] et 2 à 64 caractères
    static func validEmail(_ email: String) -> Bool {
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regEx)
        return predicate.evaluate(with: email)
    }
    
    // pour vérifier une numéro de téléphone français
    // format : 06XXXXXXXX ou 07XXXXXXXX ou +336XXXXXXXX ou 006XXXXXXXX
    static func validFrenchPhoneNumber(_ phoneNumber: String) -> Bool {
        return false
    }
    
    // pour vérifier si un montant est valide
    // format : A.B avec A, B chiffres
    static func validAmount(_ amount: String) -> Bool {
        return false
    }
}
