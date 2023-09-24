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
            ExpensesView()
                .tabItem{
                    Label("Expenses", systemImage: "tray.and.arrow.up.fill")
                }
            
            ReportsView()
                .tabItem{
                    Label("Reports", systemImage: "chart.bar.fill")
                }
            
            AddExpenseView()
                .tabItem{
                    Label("Add", systemImage: "plus")
                }
            
            SettingsView()
                .tabItem{
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
    }
}
