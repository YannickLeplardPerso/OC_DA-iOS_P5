//
//  AuraAPIService.swift
//  Aura
//
//  Created by Yannick LEPLARD on 01/05/2024.
//

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// ATTENTION
// Un seul compte est configuré dans l'API, il s'agit du compte `test@aura.app` avec le mot de passe `test123`
// Ne pas oublier de modifier la fonction askForAuthenticationToken quand la gestion d'identités sera active
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

import Foundation



// Structures de données compatibles JSON
struct AuraIdentity: Codable {
    let username: String
    let password: String
}

struct AuraToken: Codable {
    let token: String
}

struct AuraAccount: Codable {
    let currentBalance: Decimal
    let transactions: [AuraTransaction]
}
//extension AuraAccount {
    struct AuraTransaction: Codable {
        let value: Decimal
        let label: String
    }
//}

struct AuraTransferInfos: Codable {
    let recipient: String
    let amount: Double
}


//==================================
// SERVICE API
//==================================
struct AuraAPIService {
    static private let BASE_URL = "http://127.0.0.1:8080"
    
    // pour vérifier si le service est lancé : la requête doit retourner "It works!" (erreur dans la doc du backend)
    func createIsRunningOkRequest() -> URLRequest {
        var request = URLRequest(url: URL(string: AuraAPIService.BASE_URL)!)
        request.httpMethod = "GET"
        return request
    }
    // -> retourne TRUE si le service est lancé (bonne réponse), FALSE sinon
    func isRunningOk() async throws -> Bool {
        let (data, _) = try await URLSession.shared.data(for: createIsRunningOkRequest())
        
        if String(decoding: data, as: UTF8.self) == "It works!" {
            return true
        }
        
        return false
    }
    
    // pour s'authentifier
    func createTokenRequest(for id: AuraIdentity) throws -> URLRequest {
        let stringURL = AuraAPIService.BASE_URL + "/auth"
        var request = URLRequest(url: URL(string: stringURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = try JSONEncoder().encode(id)
        request.httpBody = data
        return request
    }
    // <- prend une identité (nom, mot de passe) en paramètres
    // -> retourne un token (optionnel)
    func askForAuthenticationToken(for id: AuraIdentity) async throws -> String {
        // TEMP : à supprimer dès que le serveur backend est configuré pour gérer de vraies identités
        let pocID = AuraIdentity(username: "test@aura.app", password: "test123")
        
        let (data, response) = try await URLSession.shared.data(for: createTokenRequest(for: pocID))
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw AuraError.RequestResponse
        }
        let auraToken = try JSONDecoder().decode(AuraToken.self, from: data)
        return auraToken.token
    }
    
    // pour obtenir le détail d'un compte
    func createDetailedAccountRequest(from token: String) throws -> URLRequest {
        let stringURL = AuraAPIService.BASE_URL + "/account"
        var request = URLRequest(url: URL(string: stringURL)!)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "token")
        return request
    }
    // <- prend un token en paramètre
    // -> retourne le détail du compte associé au token
    func askForDetailedAccount(from token: String) async throws -> AuraAccount {
        let (data, response) = try await URLSession.shared.data(for: createDetailedAccountRequest(from: token))
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw AuraError.RequestResponse
        }
        let auraAccount = try JSONDecoder().decode(AuraAccount.self, from: data)
        return auraAccount
    }
    
    // pour demander un transfert d'argent : réponse vide, mais code http = 200 si demande acceptée
    func createMoneyTransferRequest(from token: String, to auraTransferInfos: AuraTransferInfos ) throws -> URLRequest {
        let stringURL = AuraAPIService.BASE_URL + "/account/transfer"
        var request = URLRequest(url: URL(string: stringURL)!)
        request.httpMethod = "POST"
        request.setValue(token, forHTTPHeaderField: "token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = try JSONEncoder().encode(auraTransferInfos)
        request.httpBody = data
        return request
    }
    // <- prend un token en paramètre (demandeur) et les informations du transfert (email ou téléphone du destinataire et montant du transfert)
    // -> retourne true si la demande est acceptée
    func askForMoneyTransfer(from token: String, to auraTransferInfos: AuraTransferInfos) async throws -> Bool {
        let (_, response) = try await URLSession.shared.data(for: createMoneyTransferRequest(from: token, to: auraTransferInfos))
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw AuraError.RequestResponse
        }
        return true
    }
}
