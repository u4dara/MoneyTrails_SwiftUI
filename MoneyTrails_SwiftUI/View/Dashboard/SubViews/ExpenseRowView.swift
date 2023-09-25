//
//  ExpenseRowView.swift
//  MoneyTrails_SwiftUI
//
//  Created by Udara Sachinthana on 2023-09-25.
//

import SwiftUI

struct ExpenseRowView: View {
    
    let title: String
    let category: String
    let amount: String
    let date: String
    
    var body: some View {
        HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(title)
                            .font(.headline)
                        
                        Text(category)
                            .font(.subheadline)
                            .padding(.horizontal, 10)
                            .foregroundColor(.white)
                            .background(
                                Capsule()
                                    .fill(Color.gray)
                                    .opacity(0.7)
                                    .frame(height: 30)
                            )
                        
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 10) {
                        Text("$" + amount)
                            .font(.headline)
                            
                        
                        Text(date)
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
    }
}

struct ExpenseRowView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseRowView(title: "Expense Title", category: "Food", amount: "50.00", date: "Sep 24 2023")
    }
}
