//
//  AuraCheckTests.swift
//  AuraTests
//
//  Created by Yannick LEPLARD on 01/06/2024.
//

import XCTest
@testable import Aura

class AuraCheckTests: XCTestCase {

    // Test the validEmail method
    func testValidEmail() {
        XCTAssertTrue(AuraCheck.validEmail("test@example.com"))
        XCTAssertFalse(AuraCheck.validEmail("test.example.com"))
        XCTAssertFalse(AuraCheck.validEmail("test@.com"))
        XCTAssertFalse(AuraCheck.validEmail("test@com"))
    }
    
    // Test the validFrenchPhoneNumber method
    func testValidFrenchPhoneNumber() {
        XCTAssertTrue(AuraCheck.validFrenchPhoneNumber("0612345678"))
        XCTAssertTrue(AuraCheck.validFrenchPhoneNumber("0712345678"))
        XCTAssertTrue(AuraCheck.validFrenchPhoneNumber("+33612345678"))
        XCTAssertTrue(AuraCheck.validFrenchPhoneNumber("+33712345678"))
        XCTAssertFalse(AuraCheck.validFrenchPhoneNumber("1012345678"))
        XCTAssertFalse(AuraCheck.validFrenchPhoneNumber("06123456789"))
        XCTAssertFalse(AuraCheck.validFrenchPhoneNumber("+33123456789"))
    }
    
    // Test the validAmount method
    func testValidAmount() {
        XCTAssertTrue(AuraCheck.validAmount("1234"))
        XCTAssertTrue(AuraCheck.validAmount("1234.56"))
        XCTAssertFalse(AuraCheck.validAmount("1234,56.78"))
        XCTAssertFalse(AuraCheck.validAmount("abc"))
    }
    
    // Test the Amount method (assuming it's intended to be the same as validAmount)
    func testAmount() {
        XCTAssertTrue(AuraCheck.Amount("1234"))
        XCTAssertTrue(AuraCheck.Amount("1234.56"))
        XCTAssertFalse(AuraCheck.Amount("1234,56.78"))
        XCTAssertFalse(AuraCheck.Amount("abc"))
    }

    // Test the replaceCommaWithDot method
    func testReplaceCommaWithDot() {
        XCTAssertEqual(AuraCheck.replaceCommaWithDot("100,20"), "100.20")
        XCTAssertEqual(AuraCheck.replaceCommaWithDot("100.20"), "100.20")
        XCTAssertEqual(AuraCheck.replaceCommaWithDot("100"), "100")
    }
}
