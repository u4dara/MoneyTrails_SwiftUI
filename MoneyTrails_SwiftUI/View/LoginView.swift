//
//  LoginView.swift
//  MoneyTrails_SwiftUI
//
//  Created by Udara Sachinthana on 2023-09-03.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var loginVM : LoginViewModel = LoginViewModel()
    
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            
            VStack{
                // Gradiant Background
                LinearGradient(colors: [Color("COrange"), Color("CPurple")], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                    .frame(height: 350)
                    .overlay{
                        VStack{
                            Image("Login_Image").resizable()
                                .scaledToFit()
                        }
                    }
                
                VStack(spacing: 20){
                    
                    // Login Text
                    HStack{
                        Text("Login").font(.system(size: 30, weight: .bold))
                        Spacer()
                    }.padding([.leading, .top, .bottom], 10)
                    
                    
                    // Email Textfield
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("TextBackground"))
                        .frame(height: 50)
                        .shadow(color: .gray, radius: 1)
                        .overlay{
                            HStack{
                                Image(systemName: "envelope").padding([.leading], 30).foregroundColor(.secondary)
                                TextField("Email", text: $loginVM.email)
                            }
                        }
                    
                    // Password Textfield
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("TextBackground"))
                        .frame(height: 50)
                        .shadow(color: .gray, radius: 1)
                        .overlay{
                            HStack{
                                Image(systemName: "lock").padding([.leading], 32).foregroundColor(.secondary)
                                TextField("Password", text: $loginVM.password)
                                Text("Forget?").foregroundColor(.blue).padding([.trailing], 10)
                            }
                        }
                    
                    
                    // Login Button
                    Button {
                        
                    } label: {
                        
                        ZStack {
                            LinearGradient(colors: [Color("COrange"), Color("CPurple")], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea(edges : .top).clipShape(RoundedRectangle(cornerRadius: 10))
                                .frame(height: 50)
                            Text("Login")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .bold()
                        }
                        
                    }
                    
                    // Register Text
                    HStack{
                        Text("New to MoneyTrail?")
                            .font(.system(size: 20))
                        Text("Sign in").foregroundColor(.blue)
                            .font(.system(size: 20))
                    }
                    
                    
                }.padding()
                
                
                
                Spacer()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
