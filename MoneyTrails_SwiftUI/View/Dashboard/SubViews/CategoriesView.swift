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
    
    var body: some View {
        VStack{
            List(CategoryviewModel.categories, id: \.categoryName){ category in
                    HStack(spacing: 15){
                        Circle()
                            .frame(width: 15)
                            .foregroundColor(Color(red: category.color.red, green: category.color.green, blue: category.color.blue))
                            
                        Text(category.categoryName)
                            .font(.headline)
                        
                        Spacer()
                        
                        Button{
                            Task {
                                    do {
                                        try await CategoryviewModel.deleteCategory(category)
                                    } catch {
                                        print("Error deleting category: \(error.localizedDescription)")
                                    }
                                }
                        }label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                
                
            }.onAppear{
                Task {
                        do {
                            CategoryviewModel.categories = try await CategoryviewModel.retrieveCategories()
                            print (CategoryviewModel.categories)
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
                                    try await CategoryviewModel.addCategories(selectedColor: newCategoryColor, textField: categoryName)
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
