//
//  TransactionListView.swift
//  Aura
//
//  Created by Yannick LEPLARD on 06/05/2024.
//

import SwiftUI

struct TransactionListView: View {
    @StateObject var viewModel = TransactionListViewModel()
    @EnvironmentObject var auraState: AuraState
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            // Display transactions
            VStack(alignment: .leading, spacing: 10) {
                List {
                    ForEach(viewModel.transactions, id: \.description) { transaction in
                        HStack {
                            Image(systemName: transaction.amount.contains("+") ? "arrow.up.right.circle.fill" : "arrow.down.left.circle.fill")
                                .foregroundColor(transaction.amount.contains("+") ? .green : .red)
                            Text(transaction.description)
                            Spacer()
                            Text(transaction.amount)
                                .fontWeight(.bold)
                                .foregroundColor(transaction.amount.contains("+") ? .green : .red)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .padding([.horizontal])
                    }
                }
                
            }

            Spacer()
            
            Button("Dismiss") {
                dismiss()
            }
            .padding()
            .background(Color(hex: "#94A684"))
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .onAppear {
            viewModel.all(auraState: auraState)
        }
    }
}

//#Preview {
//    TransactionListView()
//}
