//
//  AuraApp.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import SwiftUI

@main
struct AuraApp: App {
    @StateObject var viewModel = AppViewModel()
    @StateObject var auraState = AuraState()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if viewModel.isLogged {
                    TabView {
                        AccountDetailView(viewModel: viewModel.accountDetailViewModel)
                            .tabItem {
                                Image(systemName: "person.crop.circle")
                                Text("Account")
                            }
                            .environmentObject(auraState)
                        
                        MoneyTransferView()
                            .tabItem {
                                Image(systemName: "arrow.right.arrow.left.circle")
                                Text("Transfer")
                            }
                    }
                    
                } else {
                    AuthenticationView(viewModel: viewModel.authenticationViewModel)
                        .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity),
                                                removal: .move(edge: .top).combined(with: .opacity)))
                        //.environmentObject(auraState)
                    
                }
            }
            .accentColor(Color(hex: "#94A684"))
            .animation(.easeInOut(duration: 0.5), value: UUID())
        }
        .environmentObject(auraState)
    }
}
