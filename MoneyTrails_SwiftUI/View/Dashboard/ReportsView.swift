//
//  ReportsView.swift
//  MoneyTrails_SwiftUI
//
//  Created by Udara Sachinthana on 2023-09-11.
//

import SwiftUI

struct ReportsView: View {
    
    @EnvironmentObject var addExpenseViewModel: AddExpenseViewModel
    
    @State private var selectedExpense: Expense?
    
    private var totalExpensesForCurrentMonth: Double {
        let currentDate = Date()
        let currentMonth = Calendar.current.component(.month, from: currentDate)
        
        let currentMonthExpenses = addExpenseViewModel.expenses.filter { expense in
            let expenseMonth = Calendar.current.component(.month, from: expense.date)
            return expenseMonth == currentMonth
        }
        
        return currentMonthExpenses.reduce(0.0) { total, expense in
            if let amount = Double(expense.amount) {
                return total + amount
            } else {
                // Handle cases where the amount is not a valid Double (e.g., display an error or use a default value)
                return total
            }
        }
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
    
    private var currentMonthExpenses: [Expense] {
        let currentDate = Date()
        let currentMonth = Calendar.current.component(.month, from: currentDate)
        return addExpenseViewModel.expenses.filter { expense in
            let expenseMonth = Calendar.current.component(.month, from: expense.date)
            return expenseMonth == currentMonth
        }
    }
    
    private func fetchExpenses() async {
        await addExpenseViewModel.fetchExpenses()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Total Expenses This Month : $\(totalExpensesForCurrentMonth, specifier: "%.2f")")
                    .font(.headline)
                    .padding()
                
                List {
                    Section(header: Text("Current Month Expenses")) {
                        ForEach(currentMonthExpenses) { expense in
                            ExpenseRowView(
                                title: expense.title,
                                category: expense.category,
                                amount: String(expense.amount),
                                date: formattedDate(expense.date)
                            )
                            .swipeActions {
                                Button(role: .destructive) {
                                    selectedExpense = expense
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Expense Report")
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
    }
    
    struct ReportsView_Previews: PreviewProvider {
        static var previews: some View {
            ReportsView()
        }
    }
}
