//
//  Dashboard.swift
//  MoneyTrails_SwiftUI
//
//  Created by Udara Sachinthana on 2023-09-11.
//

import SwiftUI

struct Dashboard: View {
    var body: some View {
        TabView {
            DashnoardView()
                .tabItem{
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }
            
            ExpensesView()
                .tabItem{
                    Label("Expenses", systemImage: "chart.bar.doc.horizontal.fill")
                }
            
            AddExpenseView()
                .tabItem{
                    Label("Add", systemImage: "plus")
                }
            
            SettingsView()
                .tabItem{
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }.accentColor(Color("CPurple"))
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
    }
}
