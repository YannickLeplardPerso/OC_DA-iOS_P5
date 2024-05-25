//
//  AuraAPIServiceTests.swift
//  Aura
//
//  Created by Yannick LEPLARD on 22/05/2024.
//

//import Foundation

import XCTest
@testable import Aura



class AuraAPIServiceTests: XCTestCase {
    
    func testIsRunningOk() async throws {
        let expectedData = "It works!".data(using: .utf8)
        let urlResponse = HTTPURLResponse(url: URL(string: AuraAPIService.BASE_URL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let sessionMock = URLSessionMock(data: expectedData, response: urlResponse, error: nil)
        
        let apiService = AuraAPIService(session: sessionMock)
        
        let isRunning = try await apiService.isRunningOk()
        
        XCTAssertTrue(isRunning)
    }
    
    func testIsRunningOk_KO() async throws {
        let expectedData: Data? = nil
        let urlResponse = HTTPURLResponse(url: URL(string: AuraAPIService.BASE_URL)!, statusCode: 504, httpVersion: nil, headerFields: nil)
        let sessionMock = URLSessionMock(data: expectedData, response: urlResponse, error: nil)
        
        let apiService = AuraAPIService(session: sessionMock)
        
        let isRunning = try await apiService.isRunningOk()
        
        XCTAssertFalse(isRunning)
    }

    func testAskForAuthenticationToken() async throws {
        let tokenResponse = AuraToken(token: "testToken")
        let expectedData = try JSONEncoder().encode(tokenResponse)
        let urlResponse = HTTPURLResponse(url: URL(string: AuraAPIService.BASE_URL + "/auth")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let sessionMock = URLSessionMock(data: expectedData, response: urlResponse, error: nil)
        
        let apiService = AuraAPIService(session: sessionMock)
        let id = AuraIdentity(username: "test@aura.app", password: "test123")
        
        let token = try await apiService.askForAuthenticationToken(for: id)
        
        XCTAssertEqual(token, "testToken")
    }

    func testAskForAuthenticationToken_BAD_ID() async throws {
        let urlResponse = HTTPURLResponse(url: URL(string: AuraAPIService.BASE_URL + "/auth")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        let sessionMock = URLSessionMock(data: nil, response: urlResponse, error: nil)
        
        let apiService = AuraAPIService(session: sessionMock)
        let id = AuraIdentity(username: "invalid@aura.app", password: "badPassword")
        
        do {
            _ = try await apiService.askForAuthenticationToken(for: id)
            XCTFail("should throw an error : bad id")
        } catch let error as AuraError {
            XCTAssertEqual(error, AuraError.RequestResponse)
        }
    }
    
    func testAskForAuthenticationToken_BAD_JSON() async throws {
//        let tokenResponse = AuraToken(token: "testToken")
//        let expectedData = try JSONEncoder().encode(tokenResponse)
        let expectedData = "{ \"toto\": \"titi\" }".data(using: .utf8)
        let urlResponse = HTTPURLResponse(url: URL(string: AuraAPIService.BASE_URL + "/auth")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let sessionMock = URLSessionMock(data: expectedData, response: urlResponse, error: nil)
        
        let apiService = AuraAPIService(session: sessionMock)
        let id = AuraIdentity(username: "test@aura.app", password: "test123")
        
        do {
            _ = try await apiService.askForAuthenticationToken(for: id)
            XCTFail("should throw an error : not a valid json response")
        } catch {
//            print(error.localizedDescription)
//            XCTAssertEqual(error.localizedDescription, "The data couldn’t be read because it isn’t in the correct format.")
        }
    }


    func testAskForDetailedAccount() async throws {
        let accountResponse = AuraAccount(currentBalance: 100.0, transactions: [])
        let expectedData = try JSONEncoder().encode(accountResponse)
        let urlResponse = HTTPURLResponse(url: URL(string: AuraAPIService.BASE_URL + "/account")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let sessionMock = URLSessionMock(data: expectedData, response: urlResponse, error: nil)
        
        let apiService = AuraAPIService(session: sessionMock)
        
        let account = try await apiService.askForDetailedAccount(from: "testToken")
        
        XCTAssertEqual(account.currentBalance, 100.0)
        XCTAssertTrue(account.transactions.isEmpty)
    }
    
    func testAskForDetailedAccount_ERR_SERV() async throws {
        let accountResponse = AuraAccount(currentBalance: 100.0, transactions: [])
        let expectedData = try JSONEncoder().encode(accountResponse)
        let urlResponse = HTTPURLResponse(url: URL(string: AuraAPIService.BASE_URL + "/account")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        let sessionMock = URLSessionMock(data: expectedData, response: urlResponse, error: nil)
        
        let apiService = AuraAPIService(session: sessionMock)
                
        do {
            _ = try await apiService.askForDetailedAccount(from: "testToken")
            XCTFail("should throw an error : not a valid json response")
        } catch let error as AuraError {
            XCTAssertEqual(error, AuraError.RequestResponse)
        }
    }
    
    func testAskForDetailedAccount_BAD_JSON() async throws {
        let expectedData = "notAJsonToken".data(using: .utf8)
        let urlResponse = HTTPURLResponse(url: URL(string: AuraAPIService.BASE_URL + "/account")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let sessionMock = URLSessionMock(data: expectedData, response: urlResponse, error: nil)
        
        let apiService = AuraAPIService(session: sessionMock)
                
        do {
            _ = try await apiService.askForDetailedAccount(from: "testToken")
            XCTFail("should throw an error : not a valid json response")
        } catch {}
    }
    
    func testAskForMoneyTransfer() async throws {
        let urlResponse = HTTPURLResponse(url: URL(string: AuraAPIService.BASE_URL + "/account/transfer")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let sessionMock = URLSessionMock(data: nil, response: urlResponse, error: nil)
        
        let apiService = AuraAPIService(session: sessionMock)
        let transferInfos = AuraTransferInfos(recipient: "recipient@test.com", amount: 50.0)
        
        let success = try await apiService.askForMoneyTransfer(from: "testToken", to: transferInfos)
        
        XCTAssertTrue(success)
    }
    
    func testAskForMoneyTransfer_DENIED() async throws {
        let urlResponse = HTTPURLResponse(url: URL(string: AuraAPIService.BASE_URL + "/account/transfer")!, statusCode: 403, httpVersion: nil, headerFields: nil)
        let sessionMock = URLSessionMock(data: nil, response: urlResponse, error: nil)
        
        let apiService = AuraAPIService(session: sessionMock)
        let transferInfos = AuraTransferInfos(recipient: "recipient@test.com", amount: 500000.0)
        
        do {
            _ = try await apiService.askForMoneyTransfer(from: "testToken", to: transferInfos)
            XCTFail("should throw an error : not a valid json response")
        } catch {}
    }
}
