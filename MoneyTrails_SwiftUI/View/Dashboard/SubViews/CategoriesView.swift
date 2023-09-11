//
//  CategoriesView.swift
//  MoneyTrails_SwiftUI
//
//  Created by Udara Sachinthana on 2023-09-11.
//

import SwiftUI

struct CategoriesView: View {
    
    @EnvironmentObject var viewModel : AuthViewModel
    
    @State private var categoryName = ""
    @State private var newCategoryColor = Color(.sRGB, red: 0.98, green: 0.2, blue: 0.2)
    @State private var categories : [Category] = [
        Category(id: "01", name: "Transport", color: .blue),
        Category(id: "02", name: "Bills", color: .red),
        Category(id: "03", name: "Food", color: .orange),
        Category(id: "04", name: "Donations", color: .pink),
        Category(id: "05", name: "Savings", color: .purple)
        
    ]
    
    func deleteCategory(at offsets: IndexSet){
        categories.remove(atOffsets: offsets)
    }
    
    var body: some View {
        VStack{
            List{
                ForEach(categories) { category in
                    HStack(spacing: 15){
                        Circle()

                            .frame(width: 15)
                            .foregroundColor(category.color)
                            
                        Text(category.name)
                            .font(.headline)
                    }
                }
                .onDelete(perform: deleteCategory)
                
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
                        
                    } label: {
                        Label("Submit", systemImage: "paperplane.circle.fill")
                            .font(.title)
                            .labelStyle(.iconOnly)
                    }
                }
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
