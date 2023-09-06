//
//  LoginView.swift
//  MoneyTrails_SwiftUI
//
//  Created by Udara Sachinthana on 2023-09-03.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    
    @EnvironmentObject var viewModel : AuthViewModel
    
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            
            VStack{
                // Gradiant Background
                LinearGradient(colors: [Color("COrange"), Color("CPurple")], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                    .frame(height: 300)
                    .overlay{
                        VStack{
                            Image("Login_Image").resizable()
                                .scaledToFit()
                        }
                    }
                
                VStack(spacing: 10){
                    
                    // Login Text
                    HStack{
                        Spacer()
                        Text("Login").font(.system(size: 30, weight: .bold))
                        Spacer()
                    }.padding(.top, -5)
                    
                    
                    // Welcome Text
                    HStack{
                        Spacer()
                        Text("Hello, Welcome back!").font(.system(size: 20))
                        Spacer()
                    }.padding(.bottom, 5)
                    
                    
                    // Email Textfield
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("TextBackground"))
                        .frame(height: 50)
                        .shadow(color: .gray, radius: 1)
                        .overlay{
                            HStack{
                                Image(systemName: "envelope").padding([.leading], 30).foregroundColor(.secondary)
                                TextField("Email", text: $email)
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
                                SecureField("Password", text: $password)
                                NavigationLink {
                                    ForgotPasswordView()
                                } label: {
                                    Text("Forget?").foregroundColor(.blue).padding([.trailing], 10)
                                }
                            }
                        }
                    
                    
                    // Login Button
                    Button {
                        Task{
                            try await viewModel.signIn(withEmail: email, password: password)
                        }
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
                        NavigationLink(
                            destination: RegisterView().navigationBarBackButtonHidden(true),
                            label: {
                            Text("Sign in").foregroundColor(.blue)
                                .font(.system(size: 20))
                                .bold()
                        })
                        
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
