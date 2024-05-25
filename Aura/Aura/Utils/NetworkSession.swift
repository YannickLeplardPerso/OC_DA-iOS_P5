//
//  AuraNetworkSession.swift
//  Aura
//
//  Created by Yannick LEPLARD on 22/05/2024.
//

import Foundation



protocol NetworkSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await self.data(for: request, delegate: nil)
    }
}

