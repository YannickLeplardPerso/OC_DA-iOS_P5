//
//  AppViewModelTests.swift
//  AuraTests
//
//  Created by Yannick LEPLARD on 30/05/2024.
//

import XCTest
import Combine
@testable import Aura

class AppViewModelTests: XCTestCase {
    var viewModel: AppViewModel!
    //var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        viewModel = AppViewModel()
        //cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        //cancellables = nil
        super.tearDown()
    }

    func testIsLoggedInitiallyFalse() {
        XCTAssertFalse(viewModel.isLogged, "isLogged devrait être false à l'initialisation")
    }
    
    func testAuthenticationViewModelUpdatesIsLogged() {
        let authenticationViewModel = viewModel.authenticationViewModel
            
        XCTAssertFalse(viewModel.isLogged, "isLogged devrait être false avant la connexion")
            
        // Simuler la connexion réussie
        authenticationViewModel.onLoginSucceed()
            
        XCTAssertTrue(viewModel.isLogged, "isLogged devrait être true après la connexion")
    }
    
    func testAccountDetailViewModelInitialization() {
        let accountDetailViewModel = viewModel.accountDetailViewModel
            
        XCTAssertNotNil(accountDetailViewModel, "accountDetailViewModel ne devrait pas être nil")
    }
}
