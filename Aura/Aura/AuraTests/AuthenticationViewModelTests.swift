//
//  AuthenticationViewModelTests.swift
//  AuraTests
//
//  Created by Yannick LEPLARD on 01/06/2024.
//

import XCTest
import SwiftUI
@testable import Aura



class AuthenticationViewModelTests: XCTestCase {
    var viewModel: AuthenticationViewModel!
    var mockService: MockAuraAPIService!

    override func setUp() {
        super.setUp()
        mockService = MockAuraAPIService()
        viewModel = AuthenticationViewModel(apiService: mockService, callback: {} )
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
//    func testAuthenticationViewModelInitialization() {
//        XCTAssertEqual(viewModel.username, "")
//        XCTAssertEqual(viewModel.password, "")
//        XCTAssertEqual(viewModel.error, .No)
//    }
    
    func testAuthenticationViewModelEmailAndPasswordAreValid() {
        viewModel.username = "valid@gmail.com"
        viewModel.password = "validPassword"
        
        XCTAssertTrue(viewModel.emailAndPasswordAreValid())
    }
    
    func testAuthenticationViewModelEmailAndPasswordAreValid_KO_Email() {
        viewModel.username = "invalid.com"
        viewModel.password = "validPassword"
        
        XCTAssertFalse(viewModel.emailAndPasswordAreValid())
        XCTAssertEqual(viewModel.error, .InvalidEmail)
    }
    
    func testAuthenticationViewModelEmailAndPasswordAreValid_EmptyPassword() {
        viewModel.username = "valid@gmail.com"
        viewModel.password = ""
        
        XCTAssertFalse(viewModel.emailAndPasswordAreValid())
        XCTAssertEqual(viewModel.error, .EmptyPassword)
    }
    
    func testAuthenticationViewModelLogin_Success() async {
        let auraState = AuraState()
        viewModel.username = "valid@gmail.com"
        viewModel.password = "validPassword"
        
        
        let expectation = self.expectation(description: "Async call")
        
        Task {
            viewModel.login(auraState: auraState)
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 2)
        
        XCTAssertEqual(auraState.token, "mockToken")
        //XCTAssertEqual(auraState.account, "valid@gmail.com")
    }
    
    func testAuthenticationViewModelLogin_Failure() async {
        mockService.shouldSucceed = false
        let auraState = AuraState()
        viewModel.username = "valid@gmail.com"
        viewModel.password = "invalid"
        
        let expectation = self.expectation(description: "Async call")
        
        Task {
            viewModel.login(auraState: auraState)
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 2)
        
        XCTAssertEqual(viewModel.error, .RequestResponse)
    }
}
