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
    
    @EnvironmentObject var addExpenseViewModel: AddExpenseViewModel
    
    @State private var categoryNames: [String] = []
    @State private var selectedCategory: String = ""
    @State private var amount = ""
    @State private var date = Date()
    @State private var note = ""
    
    @State private var showingSuccessAlert = false
    
    func onAppear() async {
        do {
            categoryNames = try await addExpenseViewModel.retrieveCategoryNames();
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
                        Text("Amount ($)")
                        Spacer()
                        TextField("Amount in USD", text: $amount)
                            .multilineTextAlignment(.trailing)
                            .submitLabel(.done)
                            .keyboardType(.numberPad)
                    }
                    
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
                            }
                        }
                        else {
                            Text("No categories available")
                                .foregroundColor(.gray)
                        }
                        
                    }
                    
                    HStack {
                        Text("Note")
                        Spacer()
                        TextField("Note", text: $note)
                            .multilineTextAlignment(.trailing)
                            .submitLabel(.done)
                    }
                }
                .scrollContentBackground(.hidden)
                .frame(height: 200)
                .padding(.top, 50)
                
                Button {
                    Task {
                            do {
                                try await addExpenseViewModel.addExpense(amount: amount, date: date, category: selectedCategory , note: note)
                                showingSuccessAlert = true
                            } catch {
                                print("Error adding expense: \(error.localizedDescription)")
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
}

struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseView()
    }
}
