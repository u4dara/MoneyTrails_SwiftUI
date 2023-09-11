//
//  SettingsView.swift
//  MoneyTrails_SwiftUI
//
//  Created by Udara Sachinthana on 2023-09-11.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var viewModel : AuthViewModel
    
    var body: some View {
        NavigationView{
            List{
                Section("Categories"){
                    // All Categories Tab Item
                    NavigationLink {
                        
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
                        
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "trash.circle.fill")
                                .imageScale(.small)
                                .font(.title)
                            
                            Text("Erase all Data")
                                .font(.headline)
                        }
                    }
                }
                
                Section("Account"){
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
                        print("Sign out")
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
