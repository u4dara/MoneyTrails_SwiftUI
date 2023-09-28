//
//  ReportsView.swift
//  MoneyTrails_SwiftUI
//
//  Created by Udara Sachinthana on 2023-09-11.
//

import SwiftUI
import Charts
import SwiftUICharts

struct DashnoardView: View {
    
    @EnvironmentObject var ExpenseViewModel: ExpenseViewModel

    @State private var selectedExpense: Expense?
    
    // Calculate the expenses by category for the current month
    private var expensesByCategory: [(String, Double)] {
        let currentDate = Date()
        let currentMonth = Calendar.current.component(.month, from: currentDate)

        let currentMonthExpenses = ExpenseViewModel.expenses.filter { expense in
            let expenseMonth = Calendar.current.component(.month, from: expense.date)
            return expenseMonth == currentMonth
        }

        // Calculate the total expenses by category
        let expensesGroupedByCategory = Dictionary(grouping: currentMonthExpenses, by: { $0.category })

        let expensesByCategory = expensesGroupedByCategory.map { (category, expenses) in
            let totalAmount = expenses.reduce(0.00) { $0 + Double($1.amount)! }
            return (category, totalAmount)
        }

        return expensesByCategory
    }
    
    private var totalExpensesForCurrentMonth: Double {
        let currentDate = Date()
        let currentMonth = Calendar.current.component(.month, from: currentDate)
        
        let currentMonthExpenses = ExpenseViewModel.expenses.filter { expense in
            let expenseMonth = Calendar.current.component(.month, from: expense.date)
            return expenseMonth == currentMonth
        }
        
        return currentMonthExpenses.reduce(0.0) { total, expense in
            if let amount = Double(expense.amount) {
                return total + amount
            } else {
                return total
            }
        }
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
    
    private var currentMonthExpenses: [Expense] {
        let currentDate = Date()
        let currentMonth = Calendar.current.component(.month, from: currentDate)
        return ExpenseViewModel.expenses.filter { expense in
            let expenseMonth = Calendar.current.component(.month, from: expense.date)
            return expenseMonth == currentMonth
        }
    }
    
    private func fetchExpenses() async {
        await ExpenseViewModel.fetchExpenses()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Total Expenses This Month : $\(totalExpensesForCurrentMonth, specifier: "%.2f")")
                    .font(.headline)
                    .padding()
                List {
                    
                    Section(header: Text("This Month Expenses")) {
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
                .navigationTitle("Dashboard")
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
    }
    
    struct ReportsView_Previews: PreviewProvider {
        static var previews: some View {
            DashnoardView()
        }
    }
}
