//
//  ProfileView.swift
//  MoneyTrails_SwiftUI
//
//  Created by Udara Sachinthana on 2023-09-05.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        List{
            Section{
                HStack(spacing: 15) {
                    Text("UD")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 72, height: 72)
                        .background(Color(.systemGray3))
                    .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4){
                        Text("Udara Sachinthana")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.top, 4)
                        
                        Text("test@gmail.com")
                            .font(.footnote)
                            .accentColor(.gray)
                    }
                }
            }
            
            Section("General"){
                HStack(spacing: 12){
                    Image(systemName: "gear")
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
            
            Section("Account"){
                Button {
                    print("Sign out")
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
        }.scrollContentBackground(.hidden)
        .background{
            LinearGradient(colors: [Color("COrange"), Color("CPurple")], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                .opacity(0.4)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
