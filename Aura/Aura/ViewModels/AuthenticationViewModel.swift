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
    @Published var error: AuraError = .No
    
    let onLoginSucceed: (() -> ())
    
    private var apiService: AuraAPIServiceProtocol
    
    init(apiService: AuraAPIServiceProtocol = AuraAPIService(), callback: @escaping () -> ()) {
        self.apiService = apiService
        self.onLoginSucceed = callback
    }
    
    func emailAndPasswordAreValid() -> Bool {
        // si l'email n'a pas un format valide, on efface les champs
        if !AuraCheck.validEmail(username) {
            password = ""
            error = .InvalidEmail
            return false
        }
        // le champ mot de passe ne doit pas être vide
        if password == "" {
            error = .EmptyPassword
            return false
        }
        
        return true
    }
    
    func login(auraState: AuraState) {
        Task{ @MainActor in
            do{
                auraState.token = try await apiService.askForAuthenticationToken(for: AuraIdentity(username: username, password: password))
                onLoginSucceed()
                auraState.account = try await apiService.askForDetailedAccount(from: auraState.token)
            }catch{
                self.error = .RequestResponse
            }
        }
    }
}
