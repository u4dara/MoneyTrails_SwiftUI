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
class AddExpenseViewModel: ObservableObject {
    
    @Published var expenses : [Expense] = []
    
    // Retrieve category names from db
    func retrieveCategoryNames() async throws -> [String] {
        let db = Firestore.firestore()
        let colorsCollection = db.collection("categories")
        
        if let currentUser = Auth.auth().currentUser {
            let userID = currentUser.uid
            
            // Create a query to retrieve documents where the 'userID' field matches the current user's UID
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
            // No user is signed in, handle this case as needed
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
                "amount": amount,
                "date": date,
                "category": category,
                "title": title,
                "userID": userID
            ] as [String : Any]
            
            // Use Firestore's asynchronous method to add the document
            do {
                _ = try await expensesCollection.addDocument(data: expenseData)
                print("Expense added to Firestore successfully!")
            } catch {
                throw error
            }
        } else {
            // No user is signed in, handle this case as needed
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
                
                // Use Task to switch back to the main thread
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
                                
                                // Print the expense object
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
            // No user is signed in, handle this case as needed
            throw ErrorType.userNotLoggedIn
        }
    }



}
