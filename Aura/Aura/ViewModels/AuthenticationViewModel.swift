//
//  AuthenticationViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation
import SwiftUI

class AuthenticationViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    
    let onLoginSucceed: (() -> ())
    
    init(_ callback: @escaping () -> ()) {
        self.onLoginSucceed = callback
    }
    
    func emailAndPasswordAreValid() -> Bool {
        // si l'email n'a pas un format valide, on efface les champs
        if !AuraCheck.validEmail(username) {
            username = ""
            password = ""
            return false
        }
        // le champ mot de passe ne doit pas être vide
        if password == "" {
            return false
        }
        
        return true
    }
    
    func login(auraState: AuraState) {
        
    }
}
