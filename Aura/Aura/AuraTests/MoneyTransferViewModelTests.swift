//
//  MoneyTransferViewModelTests.swift
//  AuraTests
//
//  Created by Yannick LEPLARD on 01/06/2024.
//

import XCTest
@testable import Aura



class MoneyTransferViewModelTests: XCTestCase {

    var viewModel: MoneyTransferViewModel!
    var mockService: MockAuraAPIService!
    
    override func setUp() {
        super.setUp()
        mockService = MockAuraAPIService()
        viewModel = MoneyTransferViewModel(apiService: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    // Test recipientAndAmountAreValid method when both fields are empty
    func testRecipientAndAmountAreValid_BothFieldsEmpty() {
        viewModel.recipient = ""
        viewModel.amount = ""
        XCTAssertFalse(viewModel.recipientAndAmountAreValid())
        XCTAssertEqual(viewModel.error, .Empty)
        XCTAssertEqual(viewModel.transferMessage, "Please enter recipient and amount.")
    }

    // Test recipientAndAmountAreValid method with invalid recipient
    func testRecipientAndAmountAreValid_InvalidRecipient() {
        viewModel.recipient = "invalidRecipient"
        viewModel.amount = "100"
        XCTAssertFalse(viewModel.recipientAndAmountAreValid())
        XCTAssertEqual(viewModel.recipient, "")
        XCTAssertEqual(viewModel.amount, "")
        XCTAssertEqual(viewModel.error, .InvalidRecipient)
        XCTAssertEqual(viewModel.transferMessage, "Invalid recipient")
    }

    // Test recipientAndAmountAreValid method with valid recipient and invalid amount
    func testRecipientAndAmountAreValid_InvalidAmount() {
        viewModel.recipient = "test@example.com"
        viewModel.amount = "invalidAmount"
        XCTAssertFalse(viewModel.recipientAndAmountAreValid())
        XCTAssertEqual(viewModel.amount, "")
        XCTAssertEqual(viewModel.error, .InvalidAmount)
        XCTAssertEqual(viewModel.transferMessage, "Invalid amount")
    }

    // Test recipientAndAmountAreValid method with valid recipient and valid amount
    func testRecipientAndAmountAreValid_ValidRecipientAndAmount() {
        viewModel.recipient = "test@example.com"
        viewModel.amount = "100"
        XCTAssertTrue(viewModel.recipientAndAmountAreValid())
        XCTAssertEqual(viewModel.error, .No)
        XCTAssertEqual(viewModel.transferMessage, "")
    }
    
    // Test sendMoney method with valid recipient and amount
    func testSendMoney_ValidRecipientAndAmount() async {
        mockService.shouldSucceed = true
        
        viewModel = MoneyTransferViewModel(apiService: mockService)
        
        viewModel.recipient = "test@example.com"
        viewModel.amount = "100"
        
        let expectation = self.expectation(description: "Async call")
        
        Task {
            viewModel.sendMoney(auraState: AuraState())
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 2)
        
        XCTAssertEqual(viewModel.error, .No)
        XCTAssertEqual(viewModel.transferMessage, "Successfully transferred 100 € to test@example.com")
    }

    // Test sendMoney method with API failure
    func testSendMoney_APIError() async {
        mockService.shouldSucceed = false
        
        viewModel = MoneyTransferViewModel(apiService: mockService)
        
        viewModel.recipient = "test@example.com"
        viewModel.amount = "100"
        
        let expectation = self.expectation(description: "Async call")
        
        Task {
            viewModel.sendMoney(auraState: AuraState())
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 3)
                
        XCTAssertEqual(viewModel.error, .RequestResponse)
        XCTAssertEqual(viewModel.transferMessage, "Error API transfer")
    }
}
