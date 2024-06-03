//
//  AccountDetailViewModelTests.swift
//  AuraTests
//
//  Created by Yannick LEPLARD on 01/06/2024.
//

import XCTest
import SwiftUI
@testable import Aura

class AccountDetailViewModelTests: XCTestCase {
    
    var viewModel: AccountDetailViewModel!
    var auraState: AuraState!
    
    override func setUp() {
        super.setUp()
        viewModel = AccountDetailViewModel()
        
        auraState = AuraState()
        auraState.account.currentBalance = 12345.90
    }
    
    override func tearDown() {
        viewModel = nil
        auraState = nil
        super.tearDown()
    }
    
    func testAccountSummaryUpdatesTotalAmount() {
        viewModel.accountSummary(auraState: auraState)
        XCTAssertEqual(viewModel.totalAmount, "€12\u{00a0}345,90")
    }
    
    func testAccountSummaryUpdatesRecentTransactions_FromMoreThanThree() {
        auraState.account.transactions = [
                AuraTransaction(label: "Rent", value: -1500.00),
                AuraTransaction(label: "Grocery", value: -300.45),
                AuraTransaction(label: "Electricity Bill", value: -75.80),
                AuraTransaction(label: "Gym", value: -50.00),
                AuraTransaction(label: "Internet", value: -30.99)
            ]
        
        viewModel.accountSummary(auraState: auraState)
        
        let expectedTransactions = [
            Transaction(description: "Electricity Bill", amount: "-€75,80"),
            Transaction(description: "Gym", amount: "-€50,00"),
            Transaction(description: "Internet", amount: "-€30,99")
        ]
        
        XCTAssertEqual(viewModel.recentTransactions.count, expectedTransactions.count)
        
        for (index, transaction) in viewModel.recentTransactions.enumerated() {
            XCTAssertEqual(transaction.description, expectedTransactions[index].description)
            XCTAssertEqual(transaction.amount, expectedTransactions[index].amount)
        }
    }
    
    func testAccountSummaryUpdatesRecentTransactions_FromLessThanThree() {
        auraState.account.transactions = [
                AuraTransaction(label: "Electricity Bill", value: -75.80),
                AuraTransaction(label: "Gym", value: -50.00),
            ]
        
        viewModel.accountSummary(auraState: auraState)
        
        let expectedTransactions = [
            Transaction(description: "Electricity Bill", amount: "-€75,80"),
            Transaction(description: "Gym", amount: "-€50,00"),
        ]
        
        XCTAssertEqual(viewModel.recentTransactions.count, expectedTransactions.count)
        
        for (index, transaction) in viewModel.recentTransactions.enumerated() {
            XCTAssertEqual(transaction.description, expectedTransactions[index].description)
            XCTAssertEqual(transaction.amount, expectedTransactions[index].amount)
        }
    }
    
    func testAccountSummaryUpdatesRecentTransactions_Zero() {
        viewModel.accountSummary(auraState: auraState)
        
        XCTAssertTrue(viewModel.recentTransactions.isEmpty)
    }
}
