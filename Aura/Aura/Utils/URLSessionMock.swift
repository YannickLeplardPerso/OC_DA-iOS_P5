//
//  URLSessionMock.swift
//  Aura
//
//  Created by Yannick LEPLARD on 22/05/2024.
//

import Foundation

class URLSessionMock: NetworkSession {
    private let data: Data?
    private let response: URLResponse?
    private let error: Error?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        return (data ?? Data(), response ?? URLResponse())
    }
}

