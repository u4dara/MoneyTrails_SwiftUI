//
//  ExpensesView.swift
//  MoneyTrails_SwiftUI
//
//  Created by Udara Sachinthana on 2023-09-11.
//

import SwiftUI

struct ExpensesView: View {
    
    @EnvironmentObject var addExpenseViewModel: AddExpenseViewModel
    
    @State private var selectedExpense: Expense?
    
    private func fetchExpenses() async {
        await addExpenseViewModel.fetchExpenses()
    }
    
    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy" // Customize the date format as needed
        return dateFormatter.string(from: date)
    }
    
    private func deleteExpense(_ expense: Expense) {
            Task {
                do {
                    try await addExpenseViewModel.deleteExpense(expense)
                } catch {
                    print("Error deleting expense: \(error.localizedDescription)")
                }
            }
        }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(groupedExpenses, id: \.0) { date, expenses in
                    Section(header: Text(formattedDate(date))) {
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
                            // Step 2: Confirmation alert
                            Alert(
                                title: Text("Confirm Deletion"),
                                message: Text("Are you sure you want to delete this expense?"),
                                primaryButton: .destructive(Text("Delete")) {
                                    // Step 3: Call the deleteExpense function
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
        let groupedDictionary = Dictionary(grouping: addExpenseViewModel.expenses, by: { Calendar.current.startOfDay(for: $0.date) })
        return groupedDictionary.sorted { $0.key > $1.key }
    }
}

struct ExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesView()
    }
}
