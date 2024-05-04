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
    
    func login(auraState: AuraState) {
        Task{ @MainActor in
            do{
                auraState.token = try await AuraAPIService().askForAuthenticationToken(for: AuraIdentity(username: username, password: password))
                onLoginSucceed()
                auraState.account = try await AuraAPIService().askForDetailedAccount(from: auraState.token)
            }catch{
                print("Error \(error) AuraAPIService")
            }
         }
    }
}
