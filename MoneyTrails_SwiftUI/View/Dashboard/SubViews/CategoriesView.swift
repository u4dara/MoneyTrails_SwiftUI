//
//  CategoriesView.swift
//  MoneyTrails_SwiftUI
//
//  Created by Udara Sachinthana on 2023-09-11.
//

import SwiftUI
import FirebaseFirestore
import Firebase
import FirebaseAuth

struct CategoriesView: View {
    
    @EnvironmentObject var viewModel : AuthViewModel
    @EnvironmentObject var CategoryviewModel : CategoryViewModel
    
    @State private var categoryName = ""
    @State private var newCategoryColor = Color.red
    @State private var categories: [FirestoreCategory] = []
    
    struct RGBColor {
        let red: Double
        let green: Double
        let blue: Double
    }
    
    struct FirestoreCategory {
        let categoryName: String
        let color: RGBColor
    }

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
    func retrieveCategories() async throws -> [FirestoreCategory] {
        let db = Firestore.firestore()
        let colorsCollection = db.collection("categories")
        
        if let currentUser = Auth.auth().currentUser {
            let userID = currentUser.uid
            
            // Create a query to retrieve documents where the 'userID' field matches the current user's UID
            let query = colorsCollection.whereField("userID", isEqualTo: userID)
            
            do {
                let querySnapshot = try await query.getDocuments()
                var categories: [FirestoreCategory] = []
                
                for document in querySnapshot.documents {
                    let data = document.data()
                    if let categoryName = data["categoryName"] as? String,
                       let colorData = data["color"] as? [String: Double],
                       let red = colorData["red"],
                       let green = colorData["green"],
                       let blue = colorData["blue"] {
                        let rgbColor = RGBColor(red: red, green: green, blue: blue)
                        let firestoreCategory = FirestoreCategory(categoryName: categoryName, color: rgbColor)
                        categories.append(firestoreCategory)
                    }
                }
                
                return categories
            } catch {
                throw error
            }
        } else {
            // No user is signed in, handle this case as needed
            throw ErrorType.userNotLoggedIn
        }
    }



    
    var body: some View {
        VStack{
            List(categories, id: \.categoryName){ category in
                    HStack(spacing: 15){
                        Circle()
                            .frame(width: 15)
                            .foregroundColor(Color(red: category.color.red, green: category.color.green, blue: category.color.blue))
                            
                        Text(category.categoryName)
                            .font(.headline)
                    }
                
                
            }.onAppear{
                Task {
                        do {
                            categories = try await retrieveCategories()
                            print (categories)
                        } catch {
                            print("Error retrieving categories: \(error)")
                        }
                    }
            }
            
            Spacer()
            
            HStack(spacing: 13){
                
                // Color Picker
                ColorPicker("", selection: $newCategoryColor)
                    .labelsHidden()
                
                // New Category TextField
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color("TextBackground"))
                    .frame(height: 40)
                    .shadow(color: .gray, radius: 1)
                    .overlay{
                        HStack{
                            Image(systemName: "tag")
                                .padding(.leading, 20)
                                .foregroundColor(.secondary)
                            
                            TextField("Category Name", text: $categoryName)
                            
                            if categoryName.count > 0 {
                                // Textfiled clear button
                                Button{
                                    categoryName = ""
                                } label: {
                                    Label("Clear", systemImage: "xmark.circle.fill")
                                        .labelStyle(.iconOnly)
                                        .foregroundColor(.gray)
                                        .font(.title3)
                                        .padding(.trailing, 15)
                                }
                            }
                        }
                    }
                
                // Add Category button
                HStack{
                    Button{
                        Task {
                                do {
                                    try await addCategories(selectedColor: newCategoryColor, textField: categoryName)
                                } catch {
                                    print("Error writing color to Firestore: \(error.localizedDescription)")
                                }
                            }
                    }
                    label: {
                        Label("Submit", systemImage: "arrow.up.circle.fill")
                            .font(.largeTitle)
                            .labelStyle(.iconOnly)
                     }
                }.padding([.horizontal], -5)
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                
                
            }.padding().padding(.bottom, 10)
        }
            .navigationTitle("Categories")
    }
}

// Form Validation Parameters
extension CategoriesView : AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !categoryName.isEmpty
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}

enum ErrorType: Error {
    case userNotLoggedIn
}
