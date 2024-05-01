//
//  AuthenticationViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

class AuthenticationViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    
    let onLoginSucceed: (() -> ())
    
    init(_ callback: @escaping () -> ()) {
        self.onLoginSucceed = callback
    }
    
    func login() {
//        print("login with \(username) and \(password)")
//        onLoginSucceed()
        Task{
            do{
                let isOk = try await AuraAPIService().isRunningOk()
                print("isRunningOk : \(isOk)")
                let token = try await AuraAPIService().askForAuthenticationToken(for: AuraIdentity(username: username, password: password))
                print("token : \(token)")
                let account = try await AuraAPIService().askForDetailedAccount(from: token)
                print(account.currentBalance)
                print(account.transactions[0].label)
                print(account.transactions[0].value)
                let ret = try await AuraAPIService().askForMoneyTransfer(from: token, to: AuraTransferInfos(recipient: "+33684731985", amount: 12.40))
                print("askForMoneyTransfer : \(ret)")
            }catch{
                print("Error \(error) AuraAPIService")
            }
         }
        
    }
}
