//
//  MockAuraAPIService.swift
//  AuraTests
//
//  Created by Yannick LEPLARD on 02/06/2024.
//

import XCTest
@testable import Aura



class MockAuraAPIService: AuraAPIServiceProtocol {
    var shouldSucceed: Bool = true
    
    //...
    init(shouldSucceed: Bool = true) {
        self.shouldSucceed = shouldSucceed
    }
        
    func askForMoneyTransfer(from token: String, to transferInfo: AuraTransferInfos) async throws -> Bool {
        if shouldSucceed {
            return true
        } else {
            throw NSError(domain: "com.test.error", code: 1, userInfo: nil)
        }
    }
    
    //...
    func askForAuthenticationToken(for identity: AuraIdentity) async throws -> String {
        if shouldSucceed {
            return "mockToken"
        }
        else {
            throw NSError(domain: "", code: -1, userInfo: nil)
        }
    }

    func askForDetailedAccount(from token: String) async throws -> AuraAccount {
        if shouldSucceed {
            return AuraAccount()
        }
        else {
            throw NSError(domain: "", code: -1, userInfo: nil)
        }
    }
}
