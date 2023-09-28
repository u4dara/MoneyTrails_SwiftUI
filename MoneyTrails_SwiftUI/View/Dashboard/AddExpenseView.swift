//
//  AddExpenseView.swift
//  MoneyTrails_SwiftUI
//
//  Created by Udara Sachinthana on 2023-09-24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct AddExpenseView: View {
    
    @EnvironmentObject var ExpenseViewModel: ExpenseViewModel
    
    @State private var categoryNames: [String] = []
    @State private var selectedCategory: String = ""
    @State private var amount = ""
    @State private var date = Date()
    @State private var title = ""
    
    // Validation variables
    @State private var isTitleValid = true
    @State private var isAmountValid = true
    @State private var isCategoryValid = true
    @State private var showingSuccessAlert = false
    @State private var isCategoryEmptyAlertPresented = false
    
    func onAppear() async {
        do {
            categoryNames = try await ExpenseViewModel.retrieveCategoryNames();
            if let firstCategory = categoryNames.first {
                        selectedCategory = firstCategory
                    }
            print("Category Names: \(categoryNames)")
        } catch {
            print("Error retrieving category names: \(error.localizedDescription)")
        }
    }

    
    var body: some View {
        NavigationView{
            VStack {
            
                List {
                    HStack {
                        Text("Title")
                        Spacer()
                        TextField("Expense Title", text: $title)
                            .multilineTextAlignment(.trailing)
                            .submitLabel(.done)
                    }
                    .background(isTitleValid ? Color.clear : Color.red.opacity(0.2))
                    
                    
                    HStack {
                        Text("Amount ($)")
                        Spacer()
                        TextField("Amount", text: $amount)
                            .multilineTextAlignment(.trailing)
                            .submitLabel(.done)
                            .keyboardType(.numberPad)
                    }
                    .background(isAmountValid ? Color.clear : Color.red.opacity(0.2))
                    
                    HStack {
                        Text("Date")
                        Spacer()
                        DatePicker(
                            selection: $date,
                            displayedComponents: .date,
                            label: { Text("") }
                        )
                    }
                    
                    HStack {
                        Text("Category")
                        Spacer()
                        if categoryNames.count > 0 {
                            Picker("", selection: $selectedCategory) {
                                ForEach(categoryNames, id: \.self) { category in
                                    Text(category).tag(category)
                                }
                            }.pickerStyle(.menu)
                            .foregroundColor(.black)
                        }
                        else {
                            Text("No categories available")
                                .foregroundColor(.gray)
                        }
                        
                    }
                    .background(isCategoryValid ? Color.clear : Color.red.opacity(0.2))
                }
                .scrollContentBackground(.hidden)
                .frame(height: 200)
                .padding(.top, 50)
                
                Button {
                    Task {
                        if categoryNames.isEmpty {
                            // Show an alert if no categories are available
                            isCategoryEmptyAlertPresented = true
                        } else if validateInputs() {
                            do {
                                try await ExpenseViewModel.addExpense(amount: amount, date: date, category: selectedCategory, title: title)
                                showingSuccessAlert = true
                            } catch {
                                print("Error adding expense: \(error.localizedDescription)")
                            }
                        }
                    }
                } label: {
                    ZStack {
                        LinearGradient(colors: [Color("COrange"), Color("CPurple")], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea(edges : .top).clipShape(RoundedRectangle(cornerRadius: 10))
                            .frame(height: 50)
                        Text("Add Expense")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .bold()
                    }.padding()
                        .padding(.horizontal, 20)
                }
                .alert(isPresented: $isCategoryEmptyAlertPresented) {
                    Alert(
                        title: Text("Error"),
                        message: Text("Please create a category first."),
                        dismissButton: .default(Text("OK"))
                    )
                }
                
                Spacer()
            }
            .navigationTitle("Add Expense")
            .alert(isPresented: $showingSuccessAlert) {
                            Alert(
                                title: Text("Success"),
                                message: Text("Expense added successfully!"),
                                dismissButton: .default(Text("OK"))
                            )
                        }
        }
        .onAppear {
            Task {
                    await onAppear()
                }
        }
    }
    
    // Function to validate input fields
    private func validateInputs() -> Bool {
        var isValid = true
        
        // Validate title
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            isTitleValid = false
            isValid = false
        } else {
            isTitleValid = true
        }
        
        // Validate amount
        if amount.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            isAmountValid = false
            isValid = false
        } else {
            isAmountValid = true
        }
        
        // Validate category
        if selectedCategory.isEmpty {
            isCategoryValid = false
            isValid = false
        } else {
            isCategoryValid = true
        }
        
        return isValid
    }
}

struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseView()
    }
}
