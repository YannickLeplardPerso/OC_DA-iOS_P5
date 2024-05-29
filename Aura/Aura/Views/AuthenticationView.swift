//
//  AuthenticationView.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import SwiftUI

struct AuthenticationView: View {
    @ObservedObject var viewModel: AuthenticationViewModel
    @EnvironmentObject var auraState: AuraState
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [.authBackgroundColorTop, .authBackgroundColorBottom]), startPoint: .top, endPoint: .bottomLeading)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                
                Text("Welcome !")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                TextField("Adresse email", text: $viewModel.username)
                    .padding()
                    .border(viewModel.error == .InvalidEmail ? Color.red : Color(UIColor.secondarySystemBackground), width: 1)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
                
                SecureField("Mot de passe", text: $viewModel.password)
                    .padding()
                    .border(viewModel.error == .EmptyPassword ? Color.red : Color(UIColor.secondarySystemBackground), width: 1)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)
                
                Button(action: {
                    if viewModel.emailAndPasswordAreValid() {
                        viewModel.login(auraState: auraState)
                    }
                }) {
                    Text("Se connecter")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black) // You can also change this to your pastel green color
                        .cornerRadius(8)
                }
                
                // Message
                if viewModel.error == .RequestResponse {
                    Text("Erreur authentification")
                        .padding(.top, 20)
                        .foregroundStyle(.red)
                }
            }
            .padding(.horizontal, 40)
        }
        .onTapGesture {
            self.endEditing(true)  // This will dismiss the keyboard when tapping outside
        }
    }
    
}



#Preview {
    AuthenticationView(viewModel: AuthenticationViewModel({
    }))
}
