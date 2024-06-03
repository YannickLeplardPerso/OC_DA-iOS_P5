//
//  AuraAPIServiceProtocol.swift
//  Aura
//
//  Created by Yannick LEPLARD on 01/06/2024.
//

import Foundation



protocol AuraAPIServiceProtocol {
    func askForMoneyTransfer(from token: String, to transferInfo: AuraTransferInfos) async throws -> Bool
    
    func askForAuthenticationToken(for identity: AuraIdentity) async throws -> String
    func askForDetailedAccount(from token: String) async throws -> AuraAccount
}
