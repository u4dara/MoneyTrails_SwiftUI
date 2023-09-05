//
//  RegisterView.swift
//  MoneyTrails_SwiftUI
//
//  Created by Udara Sachinthana on 2023-09-04.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject var loginVM : LoginViewModel = LoginViewModel()
    
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
                            Image("Register_Image").resizable()
                                .scaledToFit()
                        }
                    }
                
                VStack(spacing: 20){
                    // Register Text
                    HStack{
                        Spacer()
                        Text("Sign up").font(.system(size: 30, weight: .bold))
                        Spacer()
                    }.padding(.top, -5)
                    
                    // Welcome Text
                    HStack{
                        Spacer()
                        Text("Create your free account").font(.system(size: 20))
                        Spacer()
                    }.padding(.top, -5)
                    
                    // Name Textfield
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("TextBackground"))
                        .frame(height: 50)
                        .shadow(color: .gray, radius: 1)
                        .overlay{
                            HStack{
                                Image(systemName: "person.crop.circle").padding([.leading], 30).foregroundColor(.secondary)
                                TextField("Name", text: $loginVM.name)
                            }
                        }
                    
                    
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
                                Image(systemName: "lock").padding([.leading], 30).foregroundColor(.secondary)
                                SecureField("Password", text: $loginVM.password)
                            }
                        }
                    
                    // Sign in Button
                    Button {
                        
                    } label: {
                        
                        ZStack {
                            LinearGradient(colors: [Color("COrange"), Color("CPurple")], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea(edges : .top).clipShape(RoundedRectangle(cornerRadius: 10))
                                .frame(height: 50)
                            Text("Sign up")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .bold()
                        }
                        
                    }
                    
                    // Login Text, Button
                    HStack{
                        Text("Already have an account?")
                            .font(.system(size: 20))
                        NavigationLink(
                            destination: LoginView().navigationBarBackButtonHidden(true),
                            label: {
                            Text("Login").foregroundColor(.blue)
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

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
