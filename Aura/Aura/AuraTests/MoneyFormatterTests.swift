//
//  MoneyFormatterTests.swift
//  AuraTests
//
//  Created by Yannick LEPLARD on 01/06/2024.
//

import XCTest
@testable import Aura

class MoneyFormatterTests: XCTestCase {
    
    var moneyFormatter: MoneyFormatter!
    
    override func setUp() {
        super.setUp()
        // Initialize MoneyFormatter before each test
        moneyFormatter = MoneyFormatter()
    }
    
    override func tearDown() {
        // Clean up after each test
        moneyFormatter = nil
        super.tearDown()
    }
    
    // Test that the euros formatter has the correct properties
    func testEurosFormatterProperties() {
        XCTAssertEqual(moneyFormatter.euros.maximumFractionDigits, 2)
        XCTAssertEqual(moneyFormatter.euros.minimumFractionDigits, 2)
        XCTAssertEqual(moneyFormatter.euros.currencyCode, "EUR")
        XCTAssertEqual(moneyFormatter.euros.numberStyle, .currency)
    }
    
    func testEurosFormatterFormatting() {
        let number = NSNumber(value: 12345.20)
        let formattedString = moneyFormatter.euros.string(from: number)!
        
        XCTAssertEqual(formattedString, "€12\u{00a0}345,20")
    }
    
    func testEurosFormatterFormattingWithoutDecimals() {
        let number = NSNumber(value: 12345)
        let formattedString = moneyFormatter.euros.string(from: number)!
        
        XCTAssertEqual(formattedString, "€12\u{00a0}345,00")
    }
    
//    func testEurosFormatterFormattingSmallNumber() {
//        let number = NSNumber(value: 0.56)
//        let formattedString = moneyFormatter.euros.string(from: number)
//        
//        XCTAssertEqual(formattedString, "€0.56")
//    }
}
