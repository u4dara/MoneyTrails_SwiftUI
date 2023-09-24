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

class AddExpenseViewModel: ObservableObject {
    
    @Published var expenses : [Expense] = []
    @Published var categories: [Category] = []
    
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
    func addExpense(amount: String, date: Date, category: String, note: String) async throws {
        let db = Firestore.firestore()
        let expensesCollection = db.collection("expenses")
        
        if let currentUser = Auth.auth().currentUser {
            let userID = currentUser.uid
            
            let expenseData = [
                "amount": amount,
                "date": date,
                "category": category,
                "note": note,
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
    
}
