//
//  CategoryViewModel.swift
//  MoneyTrails_SwiftUI
//
//  Created by Udara Sachinthana on 2023-09-11.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

@MainActor
class CategoryViewModel : ObservableObject {
    
    @Published var categories: [Category] = []
    
    // Add categories to db
    func addCategories(selectedColor: Color, textField: String) async throws {
        // Convert SwiftUI Color to RGB values
        let uiColor = UIColor(selectedColor)
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        // Create an instance of RGBColor
        let rgbColor = RGBColor(red: Double(red), green: Double(green), blue: Double(blue))
        
        let db = Firestore.firestore()
        let colorsCollection = db.collection("categories")
        
        if let currentUser = Auth.auth().currentUser {
            let userID = currentUser.uid
            
            let colorData = [
                "red": rgbColor.red,
                "green": rgbColor.green,
                "blue": rgbColor.blue
            ]
            
            // Use Firestore's asynchronous method to add the document
            do {
                _ = try await colorsCollection.addDocument(data: [
                    "userID": userID,
                    "categoryName" : textField,
                    "color" : colorData
                ])
                print("Color added to Firestore successfully!")
                updateCategories()
            } catch {
                throw error
            }
            
        }
        else {
            // No user is signed in, handle this case as needed
            print("No user is signed in.")
        }
        
        
    }
    
    
    // Retrieve categories from db
    func retrieveCategories() async throws -> [Category] {
        let db = Firestore.firestore()
        let colorsCollection = db.collection("categories")
        
        if let currentUser = Auth.auth().currentUser {
            let userID = currentUser.uid
            
            // Create a query to retrieve documents where the 'userID' field matches the current user's UID
            let query = colorsCollection.whereField("userID", isEqualTo: userID)
            
            do {
                let querySnapshot = try await query.getDocuments()
                var categories: [Category] = []
                
                for document in querySnapshot.documents {
                    let data = document.data()
                    if let categoryName = data["categoryName"] as? String,
                       let colorData = data["color"] as? [String: Double],
                       let red = colorData["red"],
                       let green = colorData["green"],
                       let blue = colorData["blue"] {
                        let rgbColor = RGBColor(red: red, green: green, blue: blue)
                        let firestoreCategory = Category(categoryName: categoryName, color: rgbColor)
                        categories.append(firestoreCategory)
                    }
                }
                self.categories = categories
                return categories
            } catch {
                throw error
            }
        } else {
            // No user is signed in, handle this case as needed
            throw ErrorType.userNotLoggedIn
        }
    }
    
    // Update the categories array and notify observers
        private func updateCategories() {
            Task {
                do {
                    let updatedCategories = try await retrieveCategories()
                    DispatchQueue.main.async {
                        self.categories = updatedCategories
                    }
                } catch {
                    print("Error updating categories: \(error.localizedDescription)")
                }
            }
        }
    
}
