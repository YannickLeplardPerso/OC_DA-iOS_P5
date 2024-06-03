//
//  TransactionListViewModelTests.swift
//  AuraTests
//
//  Created by Yannick LEPLARD on 01/06/2024.
//

import XCTest
//import SwiftUI
@testable import Aura

class TransactionListViewModelTests: XCTestCase {
    
    var viewModel: TransactionListViewModel!
    var auraState: AuraState!
    
    override func setUp() {
        super.setUp()
        viewModel = TransactionListViewModel()
        
        auraState = AuraState()
        auraState.account.currentBalance = 12345.90
    }
    
    override func tearDown() {
        viewModel = nil
        auraState = nil
        super.tearDown()
    }
    
    func testAll() {        
        auraState.account.transactions = [
            AuraTransaction(label: "Rent", value: -1500.00),
            AuraTransaction(label: "Grocery", value: -300.45),
            AuraTransaction(label: "Electricity Bill", value: -75.80),
            AuraTransaction(label: "Gym", value: -50.00),
            AuraTransaction(label: "Internet", value: -30.99)
        ]
        
        viewModel.all(auraState: auraState)
            
        let expectedTransactions = [
            Transaction(description: "Rent", amount: "-€1\u{00a0}500,00"),
            Transaction(description: "Grocery", amount: "-€300,45"),
            Transaction(description: "Electricity Bill", amount: "-€75,80"),
            Transaction(description: "Gym", amount: "-€50,00"),
            Transaction(description: "Internet", amount: "-€30,99")
        ]
            
        XCTAssertEqual(viewModel.transactions.count, expectedTransactions.count)
            
        for (index, _) in viewModel.transactions.enumerated() {
            XCTAssertEqual(viewModel.transactions[index].description, expectedTransactions[index].description)
            XCTAssertEqual(viewModel.transactions[index].amount, expectedTransactions[index].amount)
        }
    }
    
    func testAll_withEmptyTransactions() {
        auraState.account.transactions = []
        
        viewModel.all(auraState: auraState)
        
        XCTAssertTrue(viewModel.transactions.isEmpty)
    }
    
    func testAll_withNegativeAndPositiveValues() {
        auraState.account.transactions = [
            AuraTransaction(label: "Refund", value: 1500.00),
            AuraTransaction(label: "Withdrawal", value: -500.00)
        ]
        
        viewModel.all(auraState: auraState)
        
        let expectedTransactions = [
            Transaction(description: "Refund", amount: "€1\u{00a0}500,00"),
            Transaction(description: "Withdrawal", amount: "-€500,00")
        ]
        
        XCTAssertEqual(viewModel.transactions.count, expectedTransactions.count)
        
        for (index, _) in viewModel.transactions.enumerated() {
            XCTAssertEqual(viewModel.transactions[index].description, expectedTransactions[index].description)
            XCTAssertEqual(viewModel.transactions[index].amount, expectedTransactions[index].amount)
        }
    }
    
    func testAll_withLargeAndSmallValues() {
        auraState.account.transactions = [
            AuraTransaction(label: "Large Transaction", value: 1_000_000.00),
            AuraTransaction(label: "Small Transaction", value: 0.01)
        ]
        
        viewModel.all(auraState: auraState)
        
        let expectedTransactions = [
            Transaction(description: "Large Transaction", amount: "€1\u{00a0}000\u{00a0}000,00"),
            Transaction(description: "Small Transaction", amount: "€0,01")
        ]
        
        XCTAssertEqual(viewModel.transactions.count, expectedTransactions.count)
        
        for (index, _) in viewModel.transactions.enumerated() {
            XCTAssertEqual(viewModel.transactions[index].description, expectedTransactions[index].description)
            XCTAssertEqual(viewModel.transactions[index].amount, expectedTransactions[index].amount)
        }
    }
    
    func testMoneyFormatter_withVariousValues() {
        let formatter = MoneyFormatter().euros
        
        XCTAssertEqual(formatter.string(for: 1000.00), "€1\u{00a0}000,00")
        XCTAssertEqual(formatter.string(for: -1000.00), "-€1\u{00a0}000,00")
        XCTAssertEqual(formatter.string(for: 0.00), "€0,00")
    }
    
    func testAll_withFormattedValues() {
        auraState.account.transactions = [
            AuraTransaction(label: "Payment", value: 1234.56),
            AuraTransaction(label: "Refund", value: -1234.56)
        ]
        
        viewModel.all(auraState: auraState)
        
        let expectedTransactions = [
            Transaction(description: "Payment", amount: "€1\u{00a0}234,56"),
            Transaction(description: "Refund", amount: "-€1\u{00a0}234,56")
        ]
        
        XCTAssertEqual(viewModel.transactions.count, expectedTransactions.count)
        
        for (index, _) in viewModel.transactions.enumerated() {
            XCTAssertEqual(viewModel.transactions[index].description, expectedTransactions[index].description)
            XCTAssertEqual(viewModel.transactions[index].amount, expectedTransactions[index].amount)
        }
    }
    
    func testAll_withNonStandardDescriptions() {
        auraState.account.transactions = [
            AuraTransaction(label: "Transaction 1", value: 100.00),
            AuraTransaction(label: "Transaction 2", value: -50.00)
        ]
        
        viewModel.all(auraState: auraState)
        
        let expectedTransactions = [
            Transaction(description: "Transaction 1", amount: "€100,00"),
            Transaction(description: "Transaction 2", amount: "-€50,00")
        ]
        
        XCTAssertEqual(viewModel.transactions.count, expectedTransactions.count)
        
        for (index, _) in viewModel.transactions.enumerated() {
            XCTAssertEqual(viewModel.transactions[index].description, expectedTransactions[index].description)
            XCTAssertEqual(viewModel.transactions[index].amount, expectedTransactions[index].amount)
        }
    }
}
