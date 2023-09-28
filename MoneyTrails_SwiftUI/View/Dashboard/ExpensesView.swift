//
//  ExpensesView.swift
//  MoneyTrails_SwiftUI
//
//  Created by Udara Sachinthana on 2023-09-11.
//

import SwiftUI

struct ExpensesView: View {
    
    @EnvironmentObject var ExpenseViewModel: ExpenseViewModel
    
    @State private var selectedExpense: Expense?
    
    private func fetchExpenses() async {
        await ExpenseViewModel.fetchExpenses()
    }
    
    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
    
    private func deleteExpense(_ expense: Expense) {
            Task {
                do {
                    try await ExpenseViewModel.deleteExpense(expense)
                } catch {
                    print("Error deleting expense: \(error.localizedDescription)")
                }
            }
        }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(groupedExpenses, id: \.0) { date, expenses in
                    Section(header: Text(formattedDate(date)).foregroundColor(.black)) {
                        ForEach(expenses) { expense in
                            ExpenseRowView(
                                title: expense.title,
                                category: expense.category,
                                amount: String(expense.amount),
                                date: formattedDate(expense.date)
                            )
                            .swipeActions {
                                Button(role: .destructive) { selectedExpense = expense } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Expenses")
            .alert(item: $selectedExpense) { expense in
                Alert(
                    title: Text("Confirm Deletion"),
                    message: Text("Are you sure you want to delete this expense?"),
                    primaryButton: .destructive(Text("Delete")) {
                        deleteExpense(expense)
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .onAppear {
            Task {
                await fetchExpenses()
            }
        }
    }
    
    // Helper property to group expenses by date
    private var groupedExpenses: [(Date, [Expense])] {
        let groupedDictionary = Dictionary(grouping: ExpenseViewModel.expenses, by: { Calendar.current.startOfDay(for: $0.date) })
        return groupedDictionary.sorted { $0.key > $1.key }
    }
}

struct ExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesView()
    }
}
