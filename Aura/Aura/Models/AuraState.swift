//
//  AuraState.swift
//  Aura
//
//  Created by Yannick LEPLARD on 01/05/2024.
//

import Foundation

class AuraState: ObservableObject {
    @Published var token: String = ""
    @Published var account = AuraAccount()
}
