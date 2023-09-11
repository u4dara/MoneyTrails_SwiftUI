//
//  ExpensesView.swift
//  MoneyTrails_SwiftUI
//
//  Created by Udara Sachinthana on 2023-09-11.
//

import SwiftUI

struct ExpensesView: View {
    var body: some View {
        NavigationView {
            Text("Expenses")
                .navigationTitle("Expenses")
        }
    }
}

struct ExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesView()
    }
}
