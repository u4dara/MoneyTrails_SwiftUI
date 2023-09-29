//
//  AddExpenseViewModel.swift
//  MoneyTrails_SwiftUI
//
//  Created by Udara Sachinthana on 2023-09-24.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

@MainActor
class ExpenseViewModel: ObservableObject {
    
    @Published var expenses : [Expense] = []
    @Published var currentMonthExpenses: [ExpenseData] = []
    
    struct ExpenseData {
        let category: String
        let amount: Double
    }
    
    // Retrieve category names from db
    func retrieveCategoryNames() async throws -> [String] {
        let db = Firestore.firestore()
        let colorsCollection = db.collection("categories")
        
        if let currentUser = Auth.auth().currentUser {
            let userID = currentUser.uid
            
            let query = colorsCollection.whereField("userID", isEqualTo: userID)
            
            do {
                let querySnapshot = try await query.getDocuments()
                var categoryNames: [String] = []
                
                for document in querySnapshot.documents {
                    let data = document.data()
                    if let categoryName = data["categoryName"] as? String {
                        categoryNames.append(categoryName)
                    }
                }
                return categoryNames
            } catch {
                throw error
            }
        } else {
            throw ErrorType.userNotLoggedIn
        }
    }

    // Add Expense to database
    func addExpense(amount: String, date: Date, category: String, title: String) async throws {
        let db = Firestore.firestore()
        let expensesCollection = db.collection("expenses")
        
        if let currentUser = Auth.auth().currentUser {
            let userID = currentUser.uid
            
            let expenseData = [
                "amount": amount+".00",
                "date": date,
                "category": category,
                "title": title,
                "userID": userID
            ] as [String : Any]
            
            
            do {
                _ = try await expensesCollection.addDocument(data: expenseData)
                print("Expense added to Firestore successfully!")
            } catch {
                throw error
            }
        } else {
            throw ErrorType.userNotLoggedIn
        }
    }
    
    
    
    // Retrieve the expenses from the database
    func fetchExpenses() async {
        let db = Firestore.firestore()
        let expensesCollection = db.collection("expenses")
        
        if let currentUser = Auth.auth().currentUser {
            let userID = currentUser.uid
            
            do {
                _ = try await expensesCollection.whereField("userID", isEqualTo: userID).getDocuments()
                
                Task {
                    do {
                        let querySnapshot = try await expensesCollection.whereField("userID", isEqualTo: userID).getDocuments()
                        
                        // Process the data on the main thread
                        DispatchQueue.main.async {
                            self.expenses = querySnapshot.documents.compactMap { document in
                                let data = document.data()
                                let id = document.documentID
                                let title = data["title"] as? String ?? ""
                                let amount = data["amount"] as? String ?? ""
                                let dateTimestamp = data["date"] as? Timestamp ?? Timestamp()
                                let category = data["category"] as? String ?? ""
                                
                                // Convert Timestamp to Date
                                let date = dateTimestamp.dateValue()
                                let expense = Expense(id: id, title: title, category: category, amount: amount, date: date, userID: userID)
                                
                                
                                print("Fetched Expense: \(expense)")
                                
                                return expense
                            }
                        }
                    } catch {
                        print("Error fetching expenses: \(error.localizedDescription)")
                    }
                }
            } catch {
                print("Error fetching expenses: \(error.localizedDescription)")
            }
        }
    }


    // Delete an Expense from the database
    func deleteExpense(_ expense: Expense) async throws {
        let db = Firestore.firestore()
        let expensesCollection = db.collection("expenses")
        
        if let currentUser = Auth.auth().currentUser {
            let userID = currentUser.uid
            do {
                let expenseRef = expensesCollection.document(expense.id)
                try await expenseRef.delete()
                print("Expense deleted successfully.")
                
                // Remove the deleted expense from the local array
                expenses.removeAll { $0.id == expense.id }
            } catch {
                throw error
            }
        } else {
            
            throw ErrorType.userNotLoggedIn
        }
    }

    // Create an array contain [category, ammount] pair
    func getExpensesForCurrentUser() async throws -> [(category: String, amount: Double)] {
        guard let currentUser = Auth.auth().currentUser else {
            // User is not logged in, handle accordingly
            return []
        }

        let db = Firestore.firestore()
        let expensesCollection = db.collection("expenses")

        do {
            let querySnapshot = try await expensesCollection
                .whereField("userID", isEqualTo: currentUser.uid)
                .getDocuments()

            var result: [(category: String, amount: Double)] = []

            for document in querySnapshot.documents {
                let data = document.data() // No need for optional binding here

                if let category = data["category"] as? String,
                   let amountString = data["amount"] as? String,
                   let amount = Double(amountString) {
                    result.append((category: category, amount: amount))
                }
            }

            return result
        } catch {
            // Handle the error
            print("Error fetching expenses: \(error.localizedDescription)")
            throw error
        }
    }
    
    
    



    
}
