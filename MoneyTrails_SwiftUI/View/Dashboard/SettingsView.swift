//
//  SettingsView.swift
//  MoneyTrails_SwiftUI
//
//  Created by Udara Sachinthana on 2023-09-11.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var viewModel : AuthViewModel
    @EnvironmentObject var categoryViewModel : CategoryViewModel
    
    @State private var showingConfirmationAlert = false
    @State private var redirectToOnboarding = false
    
    var body: some View {
        NavigationView{
            List{
                Section("Categories"){

                    NavigationLink {
                        CategoriesView()
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "tag.circle.fill")
                                .imageScale(.small)
                                .font(.title)
                            
                            Text("All Categories")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                    }
                    
                    // Delete all categoriess button
                    Button(role : .destructive){
                        showingConfirmationAlert = true
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "trash.circle.fill")
                                .imageScale(.small)
                                .font(.title)
                            
                            Text("Erase all Data")
                                .font(.headline)
                        }
                    }
                    .alert(isPresented: $showingConfirmationAlert) {
                        Alert(
                            title: Text("Confirm Deletion"),
                            message: Text("Are you sure you want to delete all categories? This action cannot be undone."),
                            primaryButton: .destructive(Text("Delete")) {
                                // Call the deleteAllCategoriesForCurrentUser() method
                                Task {
                                    do {
                                        try await categoryViewModel.deleteAllCategoriesForCurrentUser()
                                        // Handle success, e.g., show an alert
                                    } catch {
                                        // Handle the error, e.g., show an error message
                                        print("Error deleting categories: \(error.localizedDescription)")
                                    }
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
                
                if let user = viewModel.currentUser {
                    Section("Account"){
                        HStack(spacing: 15) {
                            Text(user.initials)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 72, height: 72)
                                .background(Color(.systemGray3))
                            .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4){
                                Text(user.fullName)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.top, 4)
                                
                                Text(user.email)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }

                        
                        Button {
                            viewModel.signOut()
                        } label: {
                            HStack(spacing: 12){
                                Image(systemName: "arrow.left.circle.fill")
                                    .imageScale(.small)
                                    .font(.title)
                                    .foregroundColor(.red)
                                
                                Text("Sign out")
                                    .font(.headline)
                                    .foregroundColor(.black)
                            }
                        }
                        
                        Button {
                            showingConfirmationAlert = true
                        } label: {
                            HStack(spacing: 12){
                                Image(systemName: "xmark.bin.circle.fill")
                                    .imageScale(.small)
                                    .font(.title)
                                    .foregroundColor(.red)
                                
                                Text("Delete Account")
                                    .font(.headline)
                                    .foregroundColor(.black)
                            }
                        }
                        .alert(isPresented: $showingConfirmationAlert) {
                            Alert(
                                title: Text("Confirm Deletion"),
                                message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                                primaryButton: .destructive(Text("Delete")) {
                                    // Call the deleteAccount method
                                    Task {
                                        do {
                                            try await viewModel.deleteUserAccount()
                                            print("User account deleted successfully")
                                        } catch {
                                            print("Error deleting user account: \(error.localizedDescription)")
                                        }
                                    }
                                },
                                secondaryButton: .cancel()
                            )
                        }
                        .background(
                            NavigationLink(
                                destination: Onboarding(),
                                isActive: $redirectToOnboarding,
                                label: { EmptyView() }
                            )
                        )

                    }
                }
                
                
                
                
                Section("App"){
                    HStack(spacing: 12){
                        Image(systemName: "gear.circle.fill")
                            .imageScale(.small)
                            .font(.title)
                            .foregroundColor(.gray)
                        
                        Text("Version")
                            .font(.subheadline)
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Text("1.0.0")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }

            }
            .navigationTitle("Settings")
        }.scrollContentBackground(.hidden)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
